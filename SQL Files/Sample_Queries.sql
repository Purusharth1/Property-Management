-- Q1)
-- select name,rent_amount from tenant,lease
-- where tenant.tenant_id=lease.tenant_id and
-- tenant.employment_status='Student' and 
-- lease.rent_amount>=1300 and lease.rent_amount<=1700;

-- Q2)
-- select name,specialization from contractor,maintenancerequest
-- where contractor.contractor_id=maintenancerequest.assigned_contractor_id and
-- maintenancerequest.status!='Completed'

-- Q3)
-- select address,market_value,name
-- from property,landlord,insurancepolicy 
-- where property.landlord_id=landlord.landlord_id and
-- insurancepolicy.property_id=property.property_id and
-- insurancepolicy.expiry_date<current_date;

