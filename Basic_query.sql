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

