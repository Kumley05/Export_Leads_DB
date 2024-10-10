SELECT
  ulp.id AS Lead_id,
  ulp.added_on,
  TO_CHAR(ulp.added_on, 'Month') ||''''|| TO_CHAR(ulp.added_on, 'YY') AS month_year,
  ulp.name,
  ulp.email,
  ulp.phone_no,
  ulp.source_url,
  ulp.first_source_url,
  public.admin_utils_source.name AS source_name,
  public.location_city.name AS city_name,
  public.location_state.name AS state_name,
  public.courses_level.name AS level_name,
  public.courses_stream.name AS course_name,
  CASE
    WHEN ulp.first_source_url LIKE '%LeadSharingUtility%' THEN concat('LSU-', public.admin_utils_source.name)
    WHEN ulp.first_source_url LIKE '%collegedekho%' THEN concat('CLD-', public.admin_utils_source.name)
    WHEN ulp.first_source_url LIKE '%CLD%' THEN concat('CLD-', public.admin_utils_source.name)
    WHEN ulp.first_source_url LIKE '%LeadSharingUtility-LeadSharingUtility%' THEN concat('GMU-', public.admin_utils_source.name)
    ELSE concat('GMU-', public.admin_utils_source.name)
  END AS Actual_name,
  CASE
    WHEN gmu.api_utility_apiclientlog.recon_status = '5' THEN 'Duplicate'
    WHEN gmu.api_utility_apiclientlog.recon_status = '4' THEN 'Success'
    WHEN gmu.api_utility_apiclientlog.recon_status = '6' THEN 'Error'
    WHEN gmu.api_utility_apiclientlog.recon_status = '1' THEN 'Daily Limit Exceeded'
    ELSE 'Error'
  END AS status,
  gmu.institutes_institute.name
FROM
  gmu.users_leadprofile AS ulp
  LEFT JOIN gmu.users_leadpreferences ON ulp.id = gmu.users_leadpreferences.lead_id
  LEFT JOIN gmu.users_preferredstream ON gmu.users_preferredstream.preferrence_id = gmu.users_leadpreferences.id
  LEFT JOIN public.admin_utils_source ON public.admin_utils_source.id = ulp.source_id
  LEFT JOIN public.courses_level ON public.courses_level.id = gmu.users_leadpreferences.preferred_level_id
  LEFT JOIN public.location_city ON public.location_city.id = ulp.city_id
  LEFT JOIN public.location_state ON public.location_state.id = ulp.state_id
  LEFT JOIN public.courses_stream ON public.courses_stream.id = gmu.users_preferredstream.stream_id
  LEFT JOIN gmu.users_preferreddegree ON gmu.users_leadpreferences.id = gmu.users_preferreddegree.preferrence_id
  LEFT JOIN public.courses_degree ON degree_id = public.courses_degree.id
  LEFT JOIN gmu.api_utility_apiclientlog ON gmu.api_utility_apiclientlog.lead_id = ulp.id
  LEFT JOIN gmu.institutes_institute ON gmu.api_utility_apiclientlog.institute_id = gmu.institutes_institute.id
WHERE
  date (ulp.added_on) BETWEEN {{From_Lead_CreatedDate}} AND {{To_Lead_Created_Date}}
  AND {{institutes_Name}}
  AND {{source_name}}
  AND {{course_name}}
  AND {{state_name}}
  AND {{Status}}
  AND {{Level}}
