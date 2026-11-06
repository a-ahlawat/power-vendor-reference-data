INSERT INTO vendor VALUES
    ('V01', 'Fictional Arc Boiler Services', 'ACTIVE'),
    ('V02', 'Fictional Meridian Turbine Works', 'ACTIVE'),
    ('V03', 'Fictional Granite Lift Systems', 'ACTIVE'),
    ('V04', 'Fictional Cinder Electrical Projects', 'ACTIVE'),
    ('V05', 'Fictional Arc Industrial Supplies', 'ACTIVE'),
    ('V06', 'Fictional Delta Site Services', 'ON_HOLD');

INSERT INTO source_vendor VALUES
    ('ERP', 'E101', 'Arc Boiler Svcs'),
    ('PORTAL', 'P404', 'Arc Boiler Services'),
    ('ERP', 'E202', 'Meridian Turbine Works'),
    ('ERP', 'E303', 'Granite Lift Systems'),
    ('PORTAL', 'P505', 'Arc Industrial'),
    ('PORTAL', 'P606', 'Cinder Electrical Projects'),
    ('ERP', 'E606', 'Delta Site Services');

INSERT INTO identity_candidate VALUES
    ('PORTAL', 'P505', 'V01', 0.9200),
    ('PORTAL', 'P505', 'V05', 0.9100);

INSERT INTO approved_xref VALUES
    ('X01', 'ERP', 'E101', 'V01', DATE '2025-01-01', NULL, 'SYN-DEC-01'),
    ('X02', 'PORTAL', 'P404', 'V05', DATE '2025-01-01', DATE '2025-06-01', 'SYN-DEC-02'),
    ('X03', 'PORTAL', 'P404', 'V01', DATE '2025-06-01', NULL, 'SYN-DEC-03'),
    ('X04', 'ERP', 'E202', 'V02', DATE '2025-01-01', NULL, 'SYN-DEC-04'),
    ('X05', 'ERP', 'E303', 'V03', DATE '2025-01-01', NULL, 'SYN-DEC-05'),
    ('X06', 'PORTAL', 'P606', 'V04', DATE '2025-01-01', NULL, 'SYN-DEC-06'),
    ('X07', 'ERP', 'E606', 'V06', DATE '2025-01-01', NULL, 'SYN-DEC-07');

INSERT INTO work_package VALUES
    ('PKG-BOILER', 'NORTH', 'Boiler pressure-part installation'),
    ('PKG-LIFT', 'NORTH', 'Heavy lifts for turbine hall'),
    ('PKG-ELEC', 'SOUTH', 'Electrical balance of plant');

-- These are fictional project screening rules.
INSERT INTO package_requirement VALUES
    ('PKG-BOILER', 'SITE_HSE'),
    ('PKG-BOILER', 'WELDING_QUAL'),
    ('PKG-LIFT', 'SITE_HSE'),
    ('PKG-LIFT', 'LIFT_PLAN'),
    ('PKG-ELEC', 'SITE_HSE'),
    ('PKG-ELEC', 'ELECTRICAL_QUAL');

INSERT INTO vendor_credential VALUES
    ('C01', 'V01', 'NORTH', 'SITE_HSE', DATE '2025-01-01', DATE '2026-01-01', NULL, 'SYN-EV-01'),
    ('C02', 'V01', 'NORTH', 'WELDING_QUAL', DATE '2025-06-01', DATE '2026-01-01', NULL, 'SYN-EV-02'),
    ('C03', 'V02', 'NORTH', 'SITE_HSE', DATE '2025-01-01', DATE '2026-01-01', NULL, 'SYN-EV-03'),
    ('C04', 'V02', 'NORTH', 'WELDING_QUAL', DATE '2025-01-01', DATE '2025-06-01', NULL, 'SYN-EV-04'),
    ('C05', 'V03', 'NORTH', 'SITE_HSE', DATE '2025-01-01', DATE '2026-01-01', NULL, 'SYN-EV-05'),
    ('C06', 'V03', 'SOUTH', 'LIFT_PLAN', DATE '2025-01-01', DATE '2026-01-01', NULL, 'SYN-EV-06'),
    ('C07', 'V04', 'SOUTH', 'SITE_HSE', DATE '2025-01-01', DATE '2026-01-01', NULL, 'SYN-EV-07'),
    ('C08', 'V04', 'SOUTH', 'ELECTRICAL_QUAL', DATE '2025-01-01', DATE '2026-01-01', DATE '2025-06-01', 'SYN-EV-08'),
    ('C09', 'V06', 'SOUTH', 'SITE_HSE', DATE '2025-01-01', DATE '2026-01-01', NULL, 'SYN-EV-09'),
    ('C10', 'V06', 'SOUTH', 'ELECTRICAL_QUAL', DATE '2025-01-01', DATE '2026-01-01', NULL, 'SYN-EV-10');

INSERT INTO nomination VALUES
    ('N01', 'PKG-BOILER', 'ERP', 'E101'),
    ('N02', 'PKG-BOILER', 'PORTAL', 'P404'),
    ('N03', 'PKG-BOILER', 'ERP', 'E202'),
    ('N04', 'PKG-LIFT', 'ERP', 'E303'),
    ('N05', 'PKG-BOILER', 'PORTAL', 'P505'),
    ('N06', 'PKG-ELEC', 'PORTAL', 'P606'),
    ('N07', 'PKG-ELEC', 'ERP', 'E606');
