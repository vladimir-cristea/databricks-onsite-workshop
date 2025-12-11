-- Grant permissions to workshop participants
-- PREREQUISITE: Create group "onsite_workshop_participants" in Settings → Identity and Access → Groups

-- Catalog permissions
GRANT USE CATALOG ON CATALOG onsite_workshop TO `onsite_workshop_participants`;
GRANT CREATE SCHEMA ON CATALOG onsite_workshop TO `onsite_workshop_participants`;

-- Schema permissions
GRANT USE SCHEMA ON SCHEMA onsite_workshop.shared_data TO `onsite_workshop_participants`;
GRANT SELECT ON SCHEMA onsite_workshop.shared_data TO `onsite_workshop_participants`;

-- Table permissions
GRANT SELECT ON TABLE onsite_workshop.shared_data.partners TO `onsite_workshop_participants`;
GRANT SELECT ON TABLE onsite_workshop.shared_data.products TO `onsite_workshop_participants`;
GRANT SELECT ON TABLE onsite_workshop.shared_data.transactions TO `onsite_workshop_participants`;
GRANT SELECT ON TABLE onsite_workshop.shared_data.partner_revenue_summary TO `onsite_workshop_participants`;
GRANT SELECT ON TABLE onsite_workshop.shared_data.product_performance_summary TO `onsite_workshop_participants`;
