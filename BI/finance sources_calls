SELECT
		 F."Financing Sources Name" AS finance_deals,
		 MAX(L."Finance Company") AS finance_leads,
		 COUNT(C.Id) AS llamadas_a
FROM  "Calls" C
LEFT JOIN "Deals" D ON C."Related To"  = D."Id" 
LEFT JOIN "Leads" L ON C."Related To"  = L.Id 
LEFT JOIN "Financing Sources" F ON D."Finance Company"  = F."Id"  
WHERE	 D."Stage"  NOT IN ( 'In Service'  , 'In Service - Complete'  )
GROUP BY  F."Financing Sources Name" 
