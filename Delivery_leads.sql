SELECT 
    src.name as Source,
    CASE
    WHEN ulp.source_url like '%LeadSharingUtility%' THEN concat('LSU-',src.name)
    WHEN ulp.source_url like '%collegedekho%' THEN concat('CLD-',src.name)
    WHEN ulp.source_url like '%CLD%' THEN concat('CLD-',src.name)
    WHEN ulp.source_url like '%LeadSharingUtility-LeadSharingUtility%' THEN concat('GMU-',src.name)
    ELSE concat('GMU-',src.name) 
  END AS Actual_name,
    COUNT(DISTINCT CASE WHEN api.recon_status = 4 THEN api.lead_id END) AS Success_Leads,
    COUNT(DISTINCT ulp.id) AS Total_Leads, 
    
    ROUND(
        COUNT(DISTINCT CASE WHEN api.recon_status = 4 THEN api.lead_id END) * 100.0 / COUNT(DISTINCT ulp.id),
        2
    ) AS Success_Lead_Percentage
FROM 
    gmu.users_leadprofile AS ulp
LEFT JOIN 
    public.admin_utils_source AS src 
    ON src.id = ulp.source_id
LEFT JOIN 
    gmu.api_utility_apiclientlog AS api 
    ON api.lead_id = ulp.id
WHERE 
    DATE(ulp.added_on) >= ({{From_Date}})
    and DATE(ulp.added_on) <= ({{To_Date}})
GROUP BY 
    src.name,
    CASE
    WHEN ulp.source_url like '%LeadSharingUtility%' THEN concat('LSU-',src.name)
    WHEN ulp.source_url like '%collegedekho%' THEN concat('CLD-',src.name)
    WHEN ulp.source_url like '%CLD%' THEN concat('CLD-',src.name)
    WHEN ulp.source_url like '%LeadSharingUtility-LeadSharingUtility%' THEN concat('GMU-',src.name)
    ELSE concat('GMU-',src.name) 
  END
ORDER by
    Success_Lead_percentage DESC;
    


