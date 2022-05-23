%%sql
SHOW tables;

%%sql 
DESC location;

-- Create a table with all the necessary information and save as csv file
%%sql 
SELECT w.ws_property_id, s2.rental_date, w.current_monthly_rent, s3.percentile_10th_price, s3.percentile_90th_price, s3.sample_nightly_rent_price, l.city, l.state, p.apt_house, p.num_bedrooms, p.kitchen, p.shared
FROM watershed_property_info w
LEFT JOIN st_rental_prices s3 ON w.property_type = s3.property_type AND w.location = s3.location
LEFT JOIN st_property_info s1 ON w.location = s1.location
LEFT JOIN st_rental_dates s2 ON s1.st_property_id = s2.st_property
LEFT JOIN location l ON w.location = l.location_id 
LEFT JOIN property_type p ON w.property_type =p. property_type_id
ORDER BY ws_property_id;

-- Retrieve without date information 
%%sql 
SELECT DISTINCT w.ws_property_id, w.current_monthly_rent, s3.percentile_10th_price, s3.percentile_90th_price, s3.sample_nightly_rent_price, l.city, l.state, p.apt_house, p.num_bedrooms, p.kitchen, p.shared 
FROM watershed_property_info w 
INNER JOIN st_rental_prices s3 ON w.property_type = s3.property_type AND w.location = s3.location 
INNER JOIN st_property_info s1 ON w.location = s1.location 
INNER JOIN location l ON w.location = l.location_id 
INNER JOIN property_type p ON w.property_type =p. property_type_id 
ORDER BY ws_property_id;

-- calculate average occupancy rate for ws from 2015-01-01 to 2015-12-32
/*%%sql
SELECT DISTINCT ws_property_id w, ROUND(avg(OC),2) AS avg_rate
FROM (SELECT DISTINCT st_property,location,(count(rental_date)/365 ) AS OC
      FROM st_rental_dates r
      JOIN st_property_info st
      ON r.st_property = st.st_property_id
      WHERE rental_date between '2015-01-01' AND '2015-12-31'
      GROUP BY st_property,location) AS oc_tab
JOIN watershed_property_info w
ON w.location = oc_tab.location
GROUP BY ws_property_id
ORDER BY w  (wrong and need to check why !!) */

-- below method is correct !! 
%%sql
SELECT DISTINCT ws_property_id, days/365 AS oc_rate
FROM watershed_property_info ws,
(SELECT DISTINCT st_property_id,location,property_type, COUNT(DISTINCT rental_date) AS days
FROM st_property_info st, st_rental_dates r
WHERE st.st_property_id = r.st_property
AND YEAR(rental_date)=2015
GROUP BY st_property_id
ORDER BY st_property_id) AS sub
WHERE ws.location = sub.location
AND ws.property_type = sub.property_type 
ORDER BY ws_property_id 