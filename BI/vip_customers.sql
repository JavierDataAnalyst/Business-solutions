WITH referidos_count AS (SELECT
		 "Customer Referral Source Deal" AS referred_by_deal_id,
		 round(COUNT(*), 1) AS referidos
FROM  "Deals" 
WHERE	 "Customer Referral Source Deal"  IS NOT NULL
GROUP BY  "Customer Referral Source Deal") ,
tickets_referidos_summary AS (SELECT
		 d3."Customer Referral Source Deal" AS referidor_deal_id,
		 round(COUNT(DISTINCT st."Id"), 1) AS total_tickets_referidos
FROM  "Deals" d3
LEFT JOIN "Service Ticket" st ON st."Pertaining to Deal"  = d3."Id"  
WHERE	 d3."Customer Referral Source Deal"  IS NOT NULL
GROUP BY  d3."Customer Referral Source Deal") ,
stages_comments_sum AS (SELECT
		 STRING_AGG(d5.Id, ',') AS ref_id,
		 MAX(CONCAT('https://crm.zoho.com/crm/org699641359/tab/CustomModule23/', si.Id)) AS link_referido_ticket,
		 STRING_AGG(si."Customer Name", ',') AS "nombre referido",
		 STRING_AGG(si."Email", ',') AS "Email referido",
		 STRING_AGG(d5."City", ',') AS city,
		 STRING_AGG(d5."AEE Region", ',') AS Region,
		 STRING_AGG(si."Customer Phone Number", ',') AS "Customer Phone Number",
		 d5."Customer Referral Source Deal" AS referidorr_deal_id,
		 round(COUNT(DISTINCT si."Id"), 1) AS total_tickets_referidos,
		 STRING_AGG(si.Id, ',') AS service_ticket_id,
		 STRING_AGG(d5."Contact Name", ',') AS contact_id,
		 STRING_AGG(si."Area of Service", ', ') AS "Area of Service",
		 STRING_AGG(si."Service Stage", ', ') AS stages_list,
		 STRING_AGG(si."Service Type", ', ') AS Service_Type,
		 STRING_AGG(si."Field Customer Comments", ', ') AS "Field Customer Comments"
FROM  "Deals" d5
RIGHT JOIN "Service Ticket" si ON si."Pertaining to Deal"  = d5."Id"
	 AND	si."Area of Service"  IN ( '(2) Comercial'  , '(4) Rechazos Financiamiento'  , '(4) Rechazos Financiamiento'  , '(7) Permisos'  , '(9) Cotizacion Servicio'  )
	 AND	si."Service Type"  IN ( '(1) Status Cheques'  , '(1) Status Medicion Neta'  , '(1) Status Updates'  , '(2) Estudio de carga'  , '(2) Visita Pre-Diseño'  , '(3) Corrección de tamaño de Breaker'  , '(3) Cotización'  , '(3) CPs'  , '(3) Limpieza de Paneles Solares'  , '(3) Prepa Stuff'  , '(3) Rechazo Generac'  , '(3) Reubicacion de Paneles Solares'  , '(3) Señalamientos CDBG'  , '(3) Service - Impedancia Related'  , '(3) Tesla Wall Connector'  , '(3) Transfer Switch Installation'  , '(4) Visita Pre Instalacion'  , '(4) Solar Repairs'  , '(6) Base nueva (Pedestal)'  , '(6) Base nueva (Sencilla)'  , '(6) Certificacion en PREPA / Gestion Perito'  , '(6) Mantenimiento de base'  , '(6) Movimiento de Trenza'  , '(7) CDBG- Permit Team'  , '(10) Anclaje de Equipos'  , '(10) Re-instalacion Paneles Solares'  )
	 AND	si."Field Customer Comments"  IS NOT NULL  
WHERE	 d5."Customer Referral Source Deal"  IS NOT NULL
 AND	d5."Stage"  IN ( 'In Service'  , 'In Service - Complete'  )
GROUP BY  d5."Customer Referral Source Deal")
SELECT
		 MAX(c.link_crm) AS link_crm,
		 MAX(initcap(c."Cliente")) AS "Cliente",
		 MAX(c."city") AS city_referidor,
		 MAX(c."Region") AS region_referidor,
		 MAX(LOWER(c.email)) AS email,
		 MAX(c.phone) AS phone,
		 MAX(c.id) AS id,
		 MAX(c."Installation Stage") AS "Installation Stage",
		 MAX(c."Caso Vendido Closing Date") AS "Caso Vendido Closing Date",
		 MAX(c."created time") AS "created time",
		 MAX(c."installation completion date") AS "installation completion date",
		 MAX(c."System Size (W)") AS "System Size (W)",
		 MAX(c."Promo Items") AS "Promo Items",
		 MAX(c."Promo Item Status") AS "Promo Item Status",
		 MAX(c."Promo Items Payment Status") AS "Promo Items Payment Status",
		 MAX(c.referidos) AS referidos,
		 MAX(trs.total_tickets_referidos) AS "Service Tickets de Referidos",
		 MAX(round(trs.total_tickets_referidos / c.referidos, 1)) AS average_tickets,
		 MAX(csc.ref_id) AS ref_id,
		 MAX(initcap(csc."nombre referido")) AS "nombre referido",
		 MAX(LOWER(csc."Email referido")) AS "Email referido",
		 MAX(csc."Customer Phone Number") AS "Main Phone Number",
		 MAX(csc.service_ticket_id) AS id_comments,
		 MAX(csc."Field Customer Comments") AS "Field Customer Comments",
		 MAX(csc.link_referido_ticket) AS link_referido_ticket,
		 MAX(ctt.Id) AS contact_id,
		 MAX(csc.city) AS city,
		 MAX(csc."Region") AS Region,
		 MAX(csc."Area of Service") AS "Area of Service",
		 MAX(csc.stages_list) AS stages_list,
		 MAX(csc.Service_Type) AS Service_Type,
		 MAX(c.priority) AS priority,
		 MAX(CASE
				 WHEN c.referidos  > 9 THEN 'VIP 10+'
				 WHEN c."System Size (W)"  >= 12000 THEN 'VIP SYSTEM'
				 WHEN c.referidos  BETWEEN 5  AND  9 THEN 'VIP'
				 WHEN c.referidos  = 4 THEN 'Casi VIP'
				 WHEN c.referidos  BETWEEN 1  AND  3 THEN '1 - 3 Referidos'
				 WHEN c.referidos  = 0 THEN 'Sin Referidos'
				 ELSE NULL
			 END) AS "VIP STATUS"
FROM (	SELECT
			 d2."Preferred Name" AS "Cliente",
			 MAX(d2.City) AS city,
			 MAX(d2."AEE Region") AS "Region",
			 MAX(d2."Customer Email") AS "email",
			 MAX(d2."Main Phone") AS "phone",
			 MAX(d2.Id) AS id,
			 MAX(CONCAT('https://crm.zoho.com/crm/org699641359/tab/Potentials/', d2.Id)) AS link_crm,
			 MAX(d2."Stage") AS "Installation Stage",
			 MAX(d2."Closing Date") AS "Caso Vendido Closing Date",
			 MAX(d."Created Time") AS "created time",
			 MAX(d2."Installation Completion Date") AS "installation completion date",
			 MAX(d2."System Size (W)") AS "System Size (W)",
			 MAX(d2."Priority") AS priority,
			 MAX(d."Promo items") AS "Promo Items",
			 MAX(d."Promo Item Status") AS "Promo Item Status",
			 MAX(d."Promo Items Payment Status") AS "Promo Items Payment Status",
			 COALESCE(rc.referidos, 0) AS referidos
	FROM  "Deals" d
JOIN "Deals" d2 ON d2."Id"  = d."Customer Referral Source Deal" 
LEFT JOIN referidos_count rc ON rc.referred_by_deal_id  = d2.Id  
	WHERE	 d."Customer Referral Source Deal"  IS NOT NULL
	 AND	d2."Stage"  IN ( 'In Service'  , 'In Service - Complete'  )
	GROUP BY d2."Preferred Name",
		 d2.Id,
		  rc.referidos 
) AS  c
LEFT JOIN tickets_referidos_summary trs ON trs.referidor_deal_id  = c.id 
LEFT JOIN stages_comments_sum csc ON csc.referidorr_deal_id  = c.id 
LEFT JOIN "Contacts" ctt ON ctt.Id  = csc.contact_id  
GROUP BY  c.id 
 
