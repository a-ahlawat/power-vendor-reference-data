# Vendor data stewardship runbook

| Issue | Proposed owner | Action and evidence |
| --- | --- | --- |
| Ambiguous source identity | Vendor Master Steward | Review the source records, record an approval decision, and open a dated crosswalk entry |
| Expired, revoked, or wrong-site evidence | Project Qualification Reviewer | Validate replacement evidence and record its site, validity window, and evidence reference |
| Vendor hold | Procurement Governance | Verify hold status and route any release through the master-data approval workflow |
| Missing rules or data integrity failure | Data Platform and Package Owner | Hold publication, repair the candidate data, and retain failed query results under the run ID |

Business exceptions such as a qualification gap or an unresolved identity remain visible in a valid run. Structural failures such as overlapping approved mappings or orphan references block publication. In a production rollout, retain the previous validated shortlist and publish a new one only after the candidate passes controls.

## Failure and remediation exercises

1. **Overlapping mappings.** In a transaction, extend `X02` through June 2 by setting `valid_to = DATE '2025-06-02'`. The overlap check should return X02 and X03. N02 should show `IDENTITY_CONFLICT` and carry no resolved vendor. Roll back.
2. **Ambiguous vendor.** N05 has two candidate scores and no approved mapping. A steward's approval would establish identity only. For example, an approved mapping to V05 leaves N05 with a qualification gap because V05 has no evidence for the package. A score alone leaves N05 in the identity review queue.
3. **Boundary replay.** In a fresh scratch run, set the run date to May 31. N02 resolves to V05 under X02, while N03 and N06 are eligible before their expiry and revocation take effect. The fixture's other snapshot inputs stay fixed.
