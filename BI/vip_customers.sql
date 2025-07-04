WITH service_summary AS (SELECT
		 "Pertaining to Deal" AS deal_id,
		 COUNT(DISTINCT "Id") AS number_of_tickets,
		 MAX("Service Stage") AS "service_stage",
		 MAX("Service Type") AS "service_type",
		 MAX("Area of Service") AS "area_of_service",
		 MAX(COALESCE("Webform Notes", '')) AS notes_service_tik
FROM  "Service Ticket" 
GROUP BY  "Pertaining to Deal") ,
referidos_count AS (SELECT
		 "Customer Referral Source Deal" AS referred_by_deal_id,
		 COUNT(*) AS count_referidos
FROM  "Deals" 
WHERE	 "Customer Referral Source Deal"  IS NOT NULL
GROUP BY  "Customer Referral Source Deal")
SELECT
		 c.*,
		 
			CASE
				 WHEN c.count_referidos  > 9 THEN 'VIP 10+'
				 WHEN c."System Size (W)"  >= 12000 THEN 'VIP SYSTEM'
				 WHEN c.count_referidos  BETWEEN 5  AND  9 THEN 'VIP'
				 WHEN c.count_referidos  = 4 THEN 'Casi VIP'
				 WHEN c.count_referidos  BETWEEN 1  AND  3 THEN '1 - 3 Referidos'
				 WHEN c.count_referidos  = 0 THEN 'Sin Referidos'
				 ELSE NULL
			 END AS "VIP STATUS"
FROM (	SELECT
			 d2."Preferred Name" AS "Cliente",
			 MAX(d2."Stage") AS "Installation Stage",
			 MAX(d2."Closing Date") AS "Caso Vendido Closing Date",
			 MAX(d."Created Time") AS "created time",
			 MAX(d2."Installation Completion Date") AS "installation completion date",
			 MAX(d2."System Size (W)") AS "System Size (W)",
			 MAX(d2."Priority") AS priority,
			 MAX(d2.Id) AS id,
			 COALESCE(rc.count_referidos, 0) AS count_referidos,
			 MAX(d."Promo items") AS "Promo Items",
			 MAX(d."Promo Item Status") AS "Promo Item Status",
			 MAX(d."Promo Item Notes") AS "Promo Item Notes",
			 MAX(d."Promo Items Payment Status") AS "Promo Items Payment Status",
			 MAX(d."Underwriting Notes") AS "Underwriting Notes",
			 MAX(CONCAT(COALESCE(d."Promo Item Notes", ''), COALESCE(d."On Hold Notes", ''), COALESCE(d."Underwriting Notes", ''))) AS notes_summary,
			 MAX(ss.number_of_tickets) AS number_of_tickets,
			 MAX(ss.service_stage) AS "service stage",
			 MAX(ss.service_type) AS "service type",
			 MAX(ss.area_of_service) AS "area of service",
			 MAX(ss.notes_service_tik) AS notes_service_tik,
			 MAX(CONCAT('https://crm.zoho.com/crm/org699641359/tab/Potentials/', d.Id)) AS link_crm
	FROM  "Deals" d
LEFT JOIN "Deals" d2 ON d2."Id"  = d."Customer Referral Source Deal" 
LEFT JOIN referidos_count rc ON rc.referred_by_deal_id  = d2.Id 
LEFT JOIN service_summary ss ON ss.deal_id  = d2.Id  
	GROUP BY d2."Preferred Name",
		 d2.Id,
		  rc.count_referidos 
) AS  c 
 
