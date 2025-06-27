SELECT
		 pp.Id AS Id,
		 
			CASE
				 WHEN pp."PPS Main Product"  IN ( 'Anker 757'  , 'Anker 767'  , 'Anker 767;Anker 757'  , 'Anker 767;Cooler 30'  , 'Anker 767;Cooler 40'  , 'Anker 767;Cooler 50'  , 'Anker F2600'  , 'Anker F2600;Anker 757'  , 'Anker F2600;Anker F3800'  , 'Anker F2600;Cooler 50'  , 'Anker F3800'  , 'Anker F3800+'  , 'Cooler 30'  , 'Cooler 40'  , 'Cooler 50'  ) THEN 'Anker'
				 ELSE 'N/A'
			 END AS "Product",
		 pp."PPS Main Product" AS "PPS Main Product",
		 TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(pp."PPS Main Product", ';', nums.n), ';', -1)) AS reference_anker,
		 pp."PPS Number" AS "PPS Number",
		 pp."PPS Sales Name" AS "PPS Sales Name",
		 pp."Link CRM" AS "Link CRM",
		 pp."Created Time" AS "Created Time",
		 pp."Closing Date" AS "Closing Date",
		 pp."Amount" AS "Amount",
		 pp."Customer City" AS "Customer City",
		 pp."Region PR" AS "Region PR"
FROM  "PPS Sales" pp
CROSS JOIN(	SELECT 1 AS n
	UNION ALL
 	SELECT 2
	UNION ALL
 	SELECT 3
	UNION ALL
 	SELECT 4
	UNION ALL
 	SELECT 5
 
 
 
 
) AS  nums 
WHERE	 nums.n  <= 1 + (LENGTH(pp."PPS Main Product") -LENGTH(REPLACE(pp."PPS Main Product", ';', '')))
 AND	pp."PPS Main Product"  IS NOT NULL
ORDER BY pp.Id,
	 pp."PPS Main Product",
	 nums.n 
