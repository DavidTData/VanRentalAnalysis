SELECT *
FROM urms_2022;


-- Select average two-bedroom rent in the city of Vancouver

SELECT census_subdivision, two_bedroom
FROM urms_2022
WHERE
	dwelling_type = 'Total'
	AND census_subdivision = 'Vancouver (CY)';


-- Compare Vancouver with other municipalities in Metro Vancouver

SELECT census_subdivision, two_bedroom
FROM urms_2022
WHERE
	dwelling_type = 'Total'
	AND two_bedroom IS NOT NULL
	AND centre = 'Vancouver'
	ORDER BY 2 DESC;


-- Compare Vancouver with select municipalities across Canada. (Chosen according to population)

SELECT census_subdivision, two_bedroom 
FROM urms_2022
WHERE
	dwelling_type ='Total'
	AND two_bedroom IS NOT NULL		
	AND census_subdivision IN ('Vancouver (CY)',
						   'Calgary (CY)',
						   'Edmonton (CY)',
						   'Winnipeg (CY)',
						   'Toronto (CY)',
						   'Montréal (V)',
						   'Québec (V)')
ORDER BY 2 DESC;
	
	
-- Compare Metro Vancouver with select metro areas across Canada

SELECT centre, two_bedroom 
FROM urms_2022
WHERE
	dwelling_type ='Total'
	AND two_bedroom IS NOT NULL	
	AND census_subdivision = 'Total'
	AND centre IN ('Vancouver',
				   'Calgary',
				   'Edmonton',
				   'Toronto',
				   'Ottawa',
				   'Gatineau',
				   'Montreal'
					)
	
ORDER BY 2 DESC;

-- Compare ten year rent increase across major Canadian cities

SELECT
	o22.census_subdivision, 
	o22.two_bedroom AS two_bedroom_2022,
	o12.two_bedroom AS two_bedroom_2012,
	(((o22.two_bedroom - o12.two_bedroom) * 100) / o12.two_bedroom) as ten_year_percent_difference
FROM urms_2022 AS o22
INNER JOIN urms_2012 AS o12
	ON o22.census_subdivision = o12.census_subdivision 
	AND o22.centre = o12.centre
	AND o22.dwelling_type = o12.dwelling_type
WHERE
	o22.census_subdivision IN ('Vancouver (CY)',
							  'Calgary (CY)',
							  'Edmonton (CY)',
							  'Winnipeg (CY)',
							  'Toronto (CY)',
							  'Montréal (V)',
							  'Québec (V)')
GROUP BY o22.census_subdivision, o22.two_bedroom, o12.two_bedroom
ORDER BY ten_year_percent_difference DESC, two_bedroom_2022 DESC;

-- Compare ten year rent increase across major Canadian metro areas

SELECT
	o22.centre, 
	o22.two_bedroom AS two_bedroom_2022,
	o12.two_bedroom AS two_bedroom_2012,
	(((o22.two_bedroom - o12.two_bedroom) * 100) / o12.two_bedroom) as ten_year_percent_difference
FROM urms_2022 AS o22
INNER JOIN urms_2012 AS o12
	ON o22.census_subdivision = o12.census_subdivision 
	AND o22.centre = o12.centre
	AND o22.dwelling_type = o12.dwelling_type
WHERE
	o22.census_subdivision = 'Total'
	AND o22.centre IN ('Vancouver',
				   'Calgary',
				   'Edmonton',
				   'Toronto',
				   'Ottawa',
				   'Gatineau',
				   'Montreal'
					)
					
-- Compare average two bedroom rent with average renter-household after tax income across Canadian metro areas

GROUP BY o22.centre, o22.two_bedroom, o12.two_bedroom
ORDER BY ten_year_percent_difference DESC, two_bedroom_2022 DESC;

SELECT u.province, u.centre, two_bedroom, household_income_2020, (two_bedroom*12*100)/household_income_2020 AS PercentIncomeSpentOnRent
FROM urms_2022 AS u
	INNER JOIN average_renter_household_after_tax_income AS h
	ON u.centre = h.centre AND u.province = h.province
WHERE
	dwelling_type = 'Total'
	AND census_subdivision = 'Total'
ORDER BY PercentIncomeSpentOnRent DESC
;