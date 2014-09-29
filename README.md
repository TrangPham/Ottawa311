<h1>README</h1>

Created for the first (September 29th) Open Data Book Club:
Open Data Book Club is a monthly series of events aimed at exploring open datasets that relate to the National Capital Region.

Orginal data set: http://data.ottawa.ca/en/dataset/2014-311-monthly-service-request-submissions
(Jan - Aug only)

* Ruby version: ruby 2.1.2p95

* Database initialization: place CSV files in files/ and then run ServiceRequestsController::ingest

<h3>Verifying number of data points</h3>
```
$ wc -l < files/AugSR-2014.csv
   16780
$ wc -l < files/JanSR-2014.csv
   16781
$ wc -l < files/JunSR-2014.csv
   17985
$ wc -l < files/MaySR-2014.csv
   16384
$ wc -l < files/AprSR-2014.csv
   15302
$ wc -l < files/FebSR-2014.csv
   13463
$ wc -l < files/JulSR-2014.csv
   17696
$ wc -l < files/MarSR-2014.csv
   12805
```

Total data rows = 127188

<h3>Handling misformatted data</h3>
<h4>A weird row</h4>
```
2014-Feb-22 12:14:28,<22-Feb-2014 12:52:35 duguayro>Ward 7,Blue Box - SWC,Solid Waste Collection,City of Ottawa - FRIDAY - Cal. A Zone 3,CC PHONE
```

<h4>How did I find it?<h4>
```SQL
 ServiceRequest.select(:ward).uniq.map {|sr| sr.ward}.sort
  ServiceRequest Load (39.0ms)  SELECT DISTINCT "service_requests"."ward" FROM "service_requests"
 => [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 2220141252357]

2.1.2 :009 > ServiceRequest.where(ward: 2220141252357)
  ServiceRequest Load (33.9ms)  SELECT "service_requests".* FROM "service_requests"  WHERE "service_requests"."ward" = 2220141252357
 => #<ActiveRecord::Relation [#<ServiceRequest id: 38459, creation_date: "2014-02-22 17:14:28", ward: 2220141252357, call_description: "blue box - swc", call_type: "solid waste collection", maintenance_yard: "city of ottawa - friday - cal. a zone 3", created_at: "2014-09-28 01:19:10", updated_at: "2014-09-28 01:19:10", source: "files/FebSR-2014.csv">]>
```

<h4>Fixing it<h4>
```SQL
2.1.2 :015 >   ServiceRequest.where(ward: 2220141252357).first.update(ward: 7)
  ServiceRequest Load (12.4ms)  SELECT  "service_requests".* FROM "service_requests"  WHERE "service_requests"."ward" = 2220141252357  ORDER BY "service_requests"."id" ASC LIMIT 1
   (0.1ms)  begin transaction
  SQL (1.0ms)  UPDATE "service_requests" SET "updated_at" = ?, "ward" = ? WHERE "service_requests"."id" = 38459  [["updated_at", "2014-09-28 01:39:34.456726"], ["ward", 7]]
   (0.6ms)  commit transaction
 => true
2.1.2 :016 > ServiceRequest.find(38459)
  ServiceRequest Load (0.2ms)  SELECT  "service_requests".* FROM "service_requests"  WHERE "service_requests"."id" = ? LIMIT 1  [["id", 38459]]
 => #<ServiceRequest id: 38459, creation_date: "2014-02-22 17:14:28", ward: 7, call_description: "blue box - swc", call_type: "solid waste collection", maintenance_yard: "city of ottawa - friday - cal. a zone 3", created_at: "2014-09-28 01:19:10", updated_at: "2014-09-28 01:39:34", source: "files/FebSR-2014.csv">
 ```
