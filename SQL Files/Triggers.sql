-- Trigger 1
CREATE OR REPLACE FUNCTION create_role_and_grant_access()
RETURNS TRIGGER AS
$$
DECLARE
    new_company_id INT;
    new_password TEXT;
BEGIN
    -- Get the newly inserted company ID and password
    SELECT NEW.Company_ID, NEW.Password INTO new_company_id, new_password;

    -- Create a new role based on the company ID
    EXECUTE format('CREATE ROLE company_role_%s WITH LOGIN PASSWORD %L', new_company_id, new_password);

    -- Create a view specific to the company
    EXECUTE format('CREATE OR REPLACE VIEW company_employee_view_%s AS SELECT * FROM employee WHERE company_id = %s', new_company_id, new_company_id);

    -- Grant SELECT privilege on the view to the new role
    EXECUTE format('GRANT SELECT ON company_employee_view_%s TO company_role_%s', new_company_id, new_company_id);

    RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER after_insert_company
AFTER INSERT ON Company
FOR EACH ROW
EXECUTE FUNCTION create_role_and_grant_access()

-- Trigger 2
CREATE OR REPLACE FUNCTION enforce_lease_expiry()
RETURNS TRIGGER AS
$$
BEGIN
    -- Check if the lease end date is in the past
    IF NEW.Lease_End_Date < CURRENT_DATE THEN
        -- Update the lease status to 'Expired'
        NEW.Lease_Status := 'Expired';
    END IF;

    RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER lease_expiry_trigger
BEFORE INSERT OR UPDATE ON Lease
FOR EACH ROW
EXECUTE FUNCTION enforce_lease_expiry();

--  Trigger 3

CREATE OR REPLACE FUNCTION ensure_data_consistency()
RETURNS TRIGGER AS
$$
BEGIN
    -- Check if the property has active leases
    IF EXISTS (SELECT 1 FROM Lease WHERE Property_ID = OLD.Property_ID AND Lease_Status <> 'Expired') THEN
        RAISE EXCEPTION 'Cannot delete property with active leases';
    END IF;

    -- Check if the property has pending maintenance requests
    IF EXISTS (SELECT 1 FROM MaintenanceRequest WHERE maintenance_request_id = OLD.maintenance_request_id AND Status = 'Pending') THEN
        RAISE EXCEPTION 'Cannot delete property with pending maintenance requests';
    END IF;

    RETURN OLD;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER ensure_data_consistency_trigger
BEFORE DELETE ON Property
FOR EACH ROW
EXECUTE FUNCTION ensure_data_consistency();
