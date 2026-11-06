# Architecture decisions

## 1. Separate legal identity from source records

**Decision.** Use a stable vendor ID as the legal entity key. ERP and portal identifiers are namespaced by source system. Candidate match scores prioritize review. Steward-approved mappings use start-inclusive, end-exclusive dates, with a null end for an open interval. A live source record must resolve to exactly one approved mapping to proceed.

**Trade-off.** Manual review prevents ambiguous names from creating an automatic merge, at the cost of a steward queue. A corrected mapping closes the prior interval and opens the successor on the same date. Keep both decision references. The synthetic scores are fixtures. The project does not implement matching or score calibration.

## 2. Evaluate qualifications against the work package

**Decision.** A package belongs to one site and defines mandatory credential types. At least one valid evidence record of each type must belong to that vendor and site. The credential start date is inclusive, its end date is exclusive, and revocation takes effect on its stated date. An on-hold vendor remains in the audit output and stays off the shortlist.

**Trade-off.** This model allows a credential at one site to satisfy the same type on several packages at that site. A real project may require evidence specific to a package, activity, asset, or subcontractor. That would need a more granular scope rule. An empty package rule set blocks eligibility and fails release validation.

## 3. Keep evidence and shortlist grains separate

**Decision.** Store all candidate evidence rows at nomination, requirement, and credential grain. Collapse evidence to a pass flag per requirement before counting requirements. Keep one decision per nomination. Group eligible nominations by legal entity and package for the shortlist.

**Operational boundary.** This demo fixes master status, package rules, candidate scores, and nominations in a synthetic snapshot. Changing the run date evaluates the effective-dated mapping and credential windows against that snapshot. It does not reconstruct prior versions of all inputs. A production design would publish against versioned policy and master data, record the evaluated date and source batches, and preserve the actual approval trail. Keep underlying evidence documents in a restricted store and expose reference IDs and decision outcomes through role-scoped views.
