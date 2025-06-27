SELECT
		 c.Id AS contact_id,
		 MAX(CONCAT('https://crm.zoho.com/crm/org699641359/tab/Contacts/', c.Id)) AS contact_link_crm,
		 MAX(c."Phone") AS "Phone",
		 MAX(COALESCE(c."Email", 'No email')) AS email,
		 MAX(CASE
				 WHEN d."Pipeline"  = 'Commercial Solar' THEN 'Commercial Solar'
				 WHEN d."Pipeline"  = 'Roofing' THEN 'Roofing'
				 WHEN d."Pipeline"  = 'Residential Solar' THEN 'Residential Solar'
				 ELSE 'Other'
			 END) AS by_pipeline,
		 MAX(s.total_deals) AS total_deals,
		 MAX(s.amount_by_contact) AS amount_by_contact,
		 MAX(s.cltv_cm) AS cltv_cm
FROM  "Contacts" c
JOIN "Deals" d ON d."Contact Name"  = c.Id
	 AND	d."Stage"  <> 'Cancelled'
	 AND	d."Amount"  IS NOT NULL
	 AND	d."Amount"  > 2 
LEFT JOIN(	SELECT
			 cc.Id AS id,
			 COUNT(dd.Id) OVER(PARTITION BY cc.Id  ) AS total_deals,
			 SUM(dd."Amount") OVER(PARTITION BY cc.Id  ) AS amount_by_contact,
			 SUM(CASE
					 WHEN dd."Pipeline"  = 'Commercial Solar' THEN dd."Amount" * 0.15
					 WHEN dd."Pipeline"  = 'Roofing' THEN dd."Amount" * 0.10
					 WHEN dd."Pipeline"  = 'Residential Solar' THEN dd."Amount" * 0.15
					 ELSE 0
				 END) OVER(PARTITION BY cc.Id  ) AS cltv_cm
	FROM  "Contacts" cc
JOIN "Deals" dd ON dd."Contact Name"  = cc.Id
		 AND	dd."Stage"  <> 'Cancelled'  
) AS  s ON s.id  = d."Contact Name"  
GROUP BY  contact_id 
UNION ALL
 SELECT
		 pps."Customer Phone" AS contact_id,
		 MAX('https://crm.zoho.com/crm/org699641359/tab/CustomModule38/custom-view/4258103001301270470/list?page=1') AS contact_link_crm,
		 MAX(pps."Customer Phone") AS "phone",
		 MAX(pps."Customer Email") AS email,
		 MAX('Anker') AS by_pipeline,
		 MAX(pt.total_deals) AS total_deals,
		 MAX(pt.amount_by_contact) AS amount_by_contact,
		 MAX(pt.cltv_cm) AS cltv_cm
FROM  "PPS Sales" pps
LEFT JOIN(	SELECT
			 pp."Customer Phone" AS contact_id,
			 COUNT(pp.Id) OVER(PARTITION BY pp."Customer Phone"  ) AS total_deals,
			 SUM(pp."Amount") OVER(PARTITION BY pp."Customer Phone"  ) AS amount_by_contact,
			 SUM(pp."Amount" * 0.15) OVER(PARTITION BY pp."Customer Phone"  ) AS cltv_cm
	FROM  "PPS Sales" pp 
) pt ON pt.contact_id  = pps."Customer Phone"  
WHERE	 pps.Amount  IS NOT NULL
 AND	pps.Amount  > 2
 AND	pps."Customer Phone"  IS NOT NULL
 AND	pps."Customer Phone"  NOT LIKE '%a%'
 AND	pps."Customer Phone"  NOT LIKE '%-%'
 AND	pps."Customer Phone"  NOT LIKE '%(%'
GROUP BY  contact_id 
 
ORDER BY cltv_cm 
