
CREATE DATABASE HW3;
CREATE EXTENSION postgis;
CREATE EXTENSION postgis_topology;

CREATE TABLE places (name varchar, geom geometry);


INSERT INTO places VALUES
    ('2801 Orchard Avenue', 'POINT(34.029264 -118.287566)'),
    ('Study Hall','POINT(34.028762 -118.284303)'),
    ('The Dunes','POINT(34.028511 -118.287433)'),
    ('Terrace Apartments','POINT(34.028843 -118.28839)'),
    ('Manas Indian Cuisine','POINT(34.028979 -118.291786)'),
    ('Menlo Avenue','POINT(34.028524 -118.290377)'),
    ('Trojan Plaza Apartments','POINT(34.029915 -118.289253)'),
    ('Ellendale','POINT(34.030089 -118.289345)'),
    ('Mosaic Student Communities','POINT(34.030347 -118.284331)'),
    ('1210 West Adams','POINT(34.032595 -118.287144)'),
    ('USCVillage','POINT(34.026962 -118.285302)'),
    ('Lyoncenter','POINT(34.024342 -118.288307)');


--Generate convex hull

SELECT ST_AsText(
    ST_ConvexHull(
        ST_Collect(
            places.geom)))
FROM places;

--output: POLYGON((34.028979 -118.291786,34.024342 -118.288307,34.026962 -118.285302,34.028762 -118.284303,34.030347 -118.284331,34.032595 -118.287144,34.028979 -118.291786))

--4 nearest neighbors

SELECT v.name, v2.name, ST_Distance(v.geom, v2.geom)
    FROM places v, 
        lateral(SELECT * 
                FROM places v2
                WHERE v2.name <> v.name
                ORDER BY v.geom <-> v2.geom LIMIT 4) v2
WHERE v.name = '2801 Orchard Avenue';

--output:
--        name                   name                st_distance

 --2801 Orchard Avenue     The Dunes                 0.000764655477973831
 --2801 Orchard Avenue     Terrace Apartments        0.000925319944673526
 --2801 Orchard Avenue     Trojan Plaza Apartments   0.00180825053574436
 --2801 Orchard Avenue     Ellendale                 0.00196098597649117