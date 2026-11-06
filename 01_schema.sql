CREATE TABLE vendor (
    vendor_id VARCHAR NOT NULL PRIMARY KEY,
    legal_name VARCHAR NOT NULL,
    vendor_state VARCHAR NOT NULL
);

CREATE TABLE source_vendor (
    source_system VARCHAR NOT NULL,
    source_vendor_id VARCHAR NOT NULL,
    source_name VARCHAR NOT NULL,
    PRIMARY KEY (source_system, source_vendor_id)
);

-- Candidate matches are suggestions for steward review.
CREATE TABLE identity_candidate (
    source_system VARCHAR NOT NULL,
    source_vendor_id VARCHAR NOT NULL,
    vendor_id VARCHAR NOT NULL REFERENCES vendor(vendor_id),
    match_score NUMBER(5, 4) NOT NULL,
    PRIMARY KEY (source_system, source_vendor_id, vendor_id),
    FOREIGN KEY (source_system, source_vendor_id) REFERENCES source_vendor(source_system, source_vendor_id)
);

CREATE TABLE approved_xref (
    xref_id VARCHAR NOT NULL PRIMARY KEY,
    source_system VARCHAR NOT NULL,
    source_vendor_id VARCHAR NOT NULL,
    vendor_id VARCHAR NOT NULL REFERENCES vendor(vendor_id),
    valid_from DATE NOT NULL,
    valid_to DATE,
    decision_ref VARCHAR NOT NULL,
    FOREIGN KEY (source_system, source_vendor_id) REFERENCES source_vendor(source_system, source_vendor_id)
);

CREATE TABLE work_package (
    package_id VARCHAR NOT NULL PRIMARY KEY,
    site_id VARCHAR NOT NULL,
    package_name VARCHAR NOT NULL
);

CREATE TABLE package_requirement (
    package_id VARCHAR NOT NULL REFERENCES work_package(package_id),
    credential_type VARCHAR NOT NULL,
    PRIMARY KEY (package_id, credential_type)
);

CREATE TABLE vendor_credential (
    credential_id VARCHAR NOT NULL PRIMARY KEY,
    vendor_id VARCHAR NOT NULL REFERENCES vendor(vendor_id),
    site_id VARCHAR NOT NULL,
    credential_type VARCHAR NOT NULL,
    valid_from DATE NOT NULL,
    valid_to DATE NOT NULL,
    revoked_on DATE,
    evidence_ref VARCHAR NOT NULL
);

CREATE TABLE nomination (
    nomination_id VARCHAR NOT NULL PRIMARY KEY,
    package_id VARCHAR NOT NULL REFERENCES work_package(package_id),
    source_system VARCHAR NOT NULL,
    source_vendor_id VARCHAR NOT NULL,
    FOREIGN KEY (source_system, source_vendor_id) REFERENCES source_vendor(source_system, source_vendor_id)
);
