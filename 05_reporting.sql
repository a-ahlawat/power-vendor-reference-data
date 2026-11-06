-- Source-level decision queue.
SELECT * FROM v_nomination_decision ORDER BY nomination_id;

-- Entity-level shortlist. Several source nominations may support one vendor.
SELECT * FROM v_eligible_vendor_package ORDER BY package_id, vendor_id;

-- Missing qualifications, with the evidence behind each failed requirement.
SELECT e.nomination_id, e.required_site, e.credential_type, e.credential_id,
       e.credential_site, e.evidence_ref, e.evidence_status
FROM v_requirement_result AS r
JOIN v_credential_evidence AS e
  ON e.nomination_id = r.nomination_id AND e.credential_type = r.credential_type
WHERE r.passed = 0
ORDER BY e.nomination_id, e.credential_type, e.credential_id;

-- Candidate queue for a steward. Scores never grant eligibility.
SELECT d.nomination_id, c.vendor_id AS candidate_vendor_id, c.match_score
FROM v_nomination_decision AS d
LEFT JOIN identity_candidate AS c
  ON c.source_system = d.source_system AND c.source_vendor_id = d.source_vendor_id
WHERE d.decision = 'IDENTITY_REVIEW'
ORDER BY d.nomination_id, c.match_score DESC, c.vendor_id;

SELECT d.nomination_id, d.vendor_id, x.decision_ref, x.valid_from, x.valid_to
FROM v_nomination_decision AS d
JOIN approved_xref AS x ON x.xref_id = d.xref_id
ORDER BY d.nomination_id;
