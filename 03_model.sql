CREATE VIEW v_run AS SELECT DATE '2025-06-01' AS as_of_on;

CREATE VIEW v_nomination_identity AS
WITH live_xref AS (
    SELECT x.source_system, x.source_vendor_id, COUNT(*) AS approved_count,
           MIN(x.vendor_id) AS vendor_id, MIN(x.xref_id) AS xref_id
    FROM approved_xref AS x CROSS JOIN v_run AS r
    WHERE x.valid_from <= r.as_of_on AND (x.valid_to IS NULL OR r.as_of_on < x.valid_to)
    GROUP BY x.source_system, x.source_vendor_id
),
candidates AS (
    SELECT source_system, source_vendor_id, COUNT(*) AS candidate_count
    FROM identity_candidate GROUP BY source_system, source_vendor_id
)
SELECT n.*, COALESCE(x.approved_count, 0) AS approved_count,
       COALESCE(c.candidate_count, 0) AS candidate_count,
       CASE WHEN x.approved_count = 1 THEN x.vendor_id END AS vendor_id,
       CASE WHEN x.approved_count = 1 THEN x.xref_id END AS xref_id
FROM nomination AS n
LEFT JOIN live_xref AS x ON x.source_system = n.source_system AND x.source_vendor_id = n.source_vendor_id
LEFT JOIN candidates AS c ON c.source_system = n.source_system AND c.source_vendor_id = n.source_vendor_id;

-- Evidence is inspectable at nomination, requirement and credential grain.
CREATE VIEW v_credential_evidence AS
SELECT n.nomination_id, p.site_id AS required_site, q.credential_type,
       c.credential_id, c.site_id AS credential_site, c.evidence_ref,
       CASE
           WHEN c.credential_id IS NULL THEN 'NO_EVIDENCE'
           WHEN c.site_id <> p.site_id THEN 'WRONG_SITE'
           WHEN c.valid_from > r.as_of_on THEN 'NOT_YET_VALID'
           WHEN c.revoked_on <= r.as_of_on THEN 'REVOKED'
           WHEN c.valid_to <= r.as_of_on THEN 'EXPIRED'
           ELSE 'VALID'
       END AS evidence_status
FROM v_nomination_identity AS n
JOIN work_package AS p ON p.package_id = n.package_id
JOIN package_requirement AS q ON q.package_id = p.package_id
CROSS JOIN v_run AS r
LEFT JOIN vendor_credential AS c ON c.vendor_id = n.vendor_id AND c.credential_type = q.credential_type
WHERE n.approved_count = 1;

CREATE VIEW v_requirement_result AS
SELECT nomination_id, credential_type,
       MAX(CASE WHEN evidence_status = 'VALID' THEN 1 ELSE 0 END) AS passed
FROM v_credential_evidence
GROUP BY nomination_id, credential_type;

CREATE VIEW v_nomination_decision AS
WITH requirement_counts AS (
    SELECT nomination_id, COUNT(*) AS requirement_count, SUM(passed) AS passed_count
    FROM v_requirement_result GROUP BY nomination_id
)
SELECT n.nomination_id, n.package_id, n.source_system, n.source_vendor_id,
       n.vendor_id, n.xref_id, n.candidate_count,
       COALESCE(q.requirement_count, 0) AS requirement_count,
       COALESCE(q.passed_count, 0) AS passed_count,
       CASE
           WHEN n.approved_count > 1 THEN 'IDENTITY_CONFLICT'
           WHEN n.approved_count = 0 THEN 'IDENTITY_REVIEW'
           WHEN v.vendor_id IS NULL THEN 'MASTER_MISSING'
           WHEN v.vendor_state <> 'ACTIVE' THEN 'VENDOR_HOLD'
           WHEN COALESCE(q.requirement_count, 0) = 0 THEN 'REQUIREMENTS_UNCONFIGURED'
           WHEN q.passed_count < q.requirement_count THEN 'QUALIFICATION_GAP'
           ELSE 'ELIGIBLE'
       END AS decision
FROM v_nomination_identity AS n
LEFT JOIN vendor AS v ON v.vendor_id = n.vendor_id
LEFT JOIN requirement_counts AS q ON q.nomination_id = n.nomination_id;

-- Use the legal entity and package grain for the shortlist.
CREATE VIEW v_eligible_vendor_package AS
SELECT vendor_id, package_id, COUNT(*) AS supporting_nominations
FROM v_nomination_decision
WHERE decision = 'ELIGIBLE'
GROUP BY vendor_id, package_id;
