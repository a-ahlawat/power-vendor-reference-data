-- Run before release. Each query should return zero rows.
WITH key_counts AS (
    SELECT 'VENDOR' AS object_name, vendor_id AS id, COUNT(*) AS copies FROM vendor GROUP BY vendor_id
    UNION ALL
    SELECT 'SOURCE_VENDOR', source_system || '/' || source_vendor_id, COUNT(*)
    FROM source_vendor GROUP BY source_system, source_vendor_id
    UNION ALL
    SELECT 'CANDIDATE', source_system || '/' || source_vendor_id || '/' || vendor_id, COUNT(*)
    FROM identity_candidate GROUP BY source_system, source_vendor_id, vendor_id
    UNION ALL
    SELECT 'XREF', xref_id, COUNT(*) FROM approved_xref GROUP BY xref_id
    UNION ALL
    SELECT 'PACKAGE', package_id, COUNT(*) FROM work_package GROUP BY package_id
    UNION ALL
    SELECT 'REQUIREMENT', package_id || '/' || credential_type, COUNT(*)
    FROM package_requirement GROUP BY package_id, credential_type
    UNION ALL
    SELECT 'CREDENTIAL', credential_id, COUNT(*) FROM vendor_credential GROUP BY credential_id
    UNION ALL
    SELECT 'NOMINATION', nomination_id, COUNT(*) FROM nomination GROUP BY nomination_id
)
SELECT * FROM key_counts WHERE copies > 1;

SELECT x.xref_id
FROM approved_xref AS x
LEFT JOIN vendor AS v ON v.vendor_id = x.vendor_id
LEFT JOIN source_vendor AS s ON s.source_system = x.source_system AND s.source_vendor_id = x.source_vendor_id
WHERE v.vendor_id IS NULL OR s.source_vendor_id IS NULL
   OR x.valid_to <= x.valid_from OR TRIM(x.decision_ref) = '';

-- Adjacent windows may share a boundary. Overlapping approved windows fail.
SELECT a.xref_id, b.xref_id AS conflicting_xref_id
FROM approved_xref AS a
JOIN approved_xref AS b
  ON a.source_system = b.source_system AND a.source_vendor_id = b.source_vendor_id
 AND a.xref_id < b.xref_id
 AND (a.valid_to IS NULL OR b.valid_from < a.valid_to)
 AND (b.valid_to IS NULL OR a.valid_from < b.valid_to);

SELECT c.source_system, c.source_vendor_id, c.vendor_id
FROM identity_candidate AS c
LEFT JOIN vendor AS v ON v.vendor_id = c.vendor_id
LEFT JOIN source_vendor AS s ON s.source_system = c.source_system AND s.source_vendor_id = c.source_vendor_id
WHERE v.vendor_id IS NULL OR s.source_vendor_id IS NULL OR c.match_score < 0 OR c.match_score > 1;

SELECT n.nomination_id
FROM nomination AS n
LEFT JOIN source_vendor AS s ON s.source_system = n.source_system AND s.source_vendor_id = n.source_vendor_id
LEFT JOIN work_package AS p ON p.package_id = n.package_id
WHERE s.source_vendor_id IS NULL OR p.package_id IS NULL;

SELECT q.package_id, q.credential_type
FROM package_requirement AS q LEFT JOIN work_package AS p ON p.package_id = q.package_id
WHERE p.package_id IS NULL OR TRIM(q.credential_type) = '';

SELECT p.package_id
FROM work_package AS p LEFT JOIN package_requirement AS q ON q.package_id = p.package_id
WHERE q.package_id IS NULL;

SELECT c.credential_id
FROM vendor_credential AS c LEFT JOIN vendor AS v ON v.vendor_id = c.vendor_id
WHERE v.vendor_id IS NULL OR c.valid_to <= c.valid_from
   OR c.revoked_on < c.valid_from OR TRIM(c.evidence_ref) = '';

SELECT vendor_id FROM vendor WHERE vendor_state NOT IN ('ACTIVE', 'ON_HOLD');

SELECT n.nomination_id, COUNT(d.nomination_id) AS decision_rows
FROM nomination AS n LEFT JOIN v_nomination_decision AS d ON d.nomination_id = n.nomination_id
GROUP BY n.nomination_id
HAVING COUNT(d.nomination_id) <> 1;
