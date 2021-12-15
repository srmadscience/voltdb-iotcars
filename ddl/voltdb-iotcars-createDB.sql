
file voltdb-iotcars-removeDB.sql;
 
load classes ../jars/voltdb-iotcars.jar;

file -inlinebatch END_OF_BATCH

CREATE TABLE demo_parameters 
(param_name varchar(30) not null primary key
,param_value bigint not null);

CREATE TABLE areas
(area_id bigint not null primary key
,area_name varchar(30) not null);

CREATE TABLE area_merchants 
(area_id bigint not null 
,merchant_id bigint not null
,merchant_name   varchar(40) not null
,merchant_offers varchar(40) 
,primary key (area_id, merchant_id));

CREATE TABLE area_chargers 
(area_id bigint not null 
,charger_id bigint not null
,merchant_id bigint 
,charger_kwh smallint not null
,hold_rate_per_min decimal not null
,kwh_rate decimal not null
,overage_rate_per_min decimal not null
,current_state varchar(10) not null
,current_state_explanation varchar(80) 
,charging_requester_id bigint 
,primary key (area_id, charger_id));

PARTITION TABLE area_chargers ON COLUMN area_id;


CREATE TABLE area_charger_availability 
(area_id bigint not null 
,charger_id bigint not null
,timeslot timestamp not null
,primary key (area_id, charger_id,timeslot))
USING TTL 5 MINUTES ON COLUMN timeslot;

PARTITION TABLE area_charger_availability ON COLUMN area_id;

CREATE INDEX area_charger_availability_ix1 ON area_charger_availability (timeslot, area_id);

CREATE VIEW charger_availability_fullness AS
SELECT timeslot, count(*) how_many
FROM area_charger_availability
GROUP BY timeslot;

CREATE TABLE merchant_chargers
(area_id bigint not null
,merchant_id bigint not null
,charger_id bigint not null
,primary key (area_id, charger_id, merchant_id));

CREATE TABLE requests
(area_id bigint not null
,request_id bigint not null
,vehicle_plate varchar(10) not null
,charger_id bigint 
,max_kwh_hour_can_use smallint not null
,current_state varchar(10) not null
,current_state_explanation varchar(80) 
,requested_start_time timestamp not null
,actual_start_time timestamp 
,charged_until_time timestamp
,scheduled_end_time timestamp not null
,actual_end_time timestamp 
,primary key (area_id, request_id));

PARTITION TABLE requests ON COLUMN area_id;

CREATE INDEX requests_ix1 ON requests (current_state);

CREATE INDEX requests_ix2 ON requests (vehicle_plate);

CREATE VIEW active_user_count AS
SELECT current_state, count(*)
FROM requests
WHERE current_state IN ()
GROUP BY current_state;

CREATE TABLE request_charges
(area_id bigint not null 
,charger_id bigint not null
,fee_time timestamp not null
,request_id bigint not null
,vehicle_plate varchar(10) not null
,fee_type  varchar(10) not null
,kwh float 
,qty float 
,amount float
,primary key (area_id, charger_id,fee_time,request_id));

PARTITION TABLE request_charges ON COLUMN area_id;

CREATE INDEX request_charges_ix2 ON request_charges (vehicle_plate);


CREATE VIEW request_charge_summary_view AS
SELECT area_id
     , truncate(MINUTE, fee_time) fee_time
     , fee_type
     , sum(kwh) kwh, sum(amount) amount
FROM   request_charges
GROUP BY area_id, truncate(MINUTE, fee_time),fee_type;

CREATE INDEX request_charge_summary_view_ix1 ON request_charge_summary_view(fee_time);


CREATE VIEW charger_state_view AS
SELECT current_state, count(*) how_many
FROM   area_chargers
GROUP BY current_state;

CREATE VIEW request_state_view AS
SELECT current_state, count(*) how_many
FROM   requests
GROUP BY current_state;

CREATE PROCEDURE GetParams AS
SELECT * FROM demo_parameters
ORDER BY param_name;

CREATE PROCEDURE ShowActivity__promBL AS
BEGIN
select 'parameter_name' statname,  'parameter_name'  stathelp, param_name, param_value statvalue from demo_parameters;
select 'charger_state' statname,  'number of chargers in this state' stathelp  , current_state ,how_many statvalue from charger_state_view;
select 'request_state' statname,  'status of requests'  stathelp,  current_state,how_many statvalue from request_state_view;
select 'activity_in_area' statname, 'activity in area ' stathelp ,area_id,fee_type ,amount statvalue 
from request_charge_summary_view
where area_id = 94597
and fee_time = DATEADD(MINUTE,-1,TRUNCATE(MINUTE,NOW));
END;

CREATE PROCEDURE GetOptions 
PARTITION ON TABLE area_chargers COLUMN area_id
AS
select c.area_id, c.charger_id, am.merchant_name, am.merchant_offers
     , c.CHARGER_KWH,  c.HOLD_RATE_PER_MIN,  c.KWH_RATE, c.OVERAGE_RATE_PER_MIN 
 from area_chargers c
LEFT JOIN area_charger_availability aca ON c.area_id = aca.area_id AND c.charger_id = aca.charger_id
LEFT OUTER JOIN merchant_chargers mc  ON c.merchant_id = mc.merchant_id  AND c.area_id = mc.area_id
LEFT OUTER JOIN area_merchants am ON am.merchant_id = mc.merchant_id AND  am.area_id = mc.area_id
WHERE aca.area_id = ?
AND   aca.timeslot = TRUNCATE(MINUTE,?)
ORDER BY c.area_id, c.charger_id;

CREATE PROCEDURE  
   PARTITION ON TABLE  area_chargers COLUMN area_id
   FROM CLASS iotcarsprocs.SelectOption;
   
   
CREATE PROCEDURE create_appointment_slots
DIRECTED
AS
insert into area_charger_availability select area_id,charger_id,DATEADD(MINUTE,60,truncate(MINUTE,NOW)) from area_chargers;

CREATE TASK run_create_appointment_slots ON SCHEDULE EVERY 1 MINUTES 
PROCEDURE create_appointment_slots 
RUN ON PARTITIONS;

CREATE PROCEDURE start_charge_session
PARTITION ON TABLE area_chargers COLUMN area_id
AS
BEGIN
UPDATE area_chargers 
SET    current_state = 'CHARGING'
  ,    current_state_explanation = 'Started charging'
WHERE  area_id = ?
AND    charger_id = ?;
UPDATE requests 
SET    current_state = 'CHARGING'
  ,    current_state_explanation = 'Started charging'
  ,    actual_start_time = NOW
WHERE  area_id = ?
AND    request_id = ?;
END;

CREATE PROCEDURE stop_charge_session
PARTITION ON TABLE area_chargers COLUMN area_id
AS
BEGIN
UPDATE area_chargers 
SET    current_state = 'STOPPED'
  ,    current_state_explanation = 'Charging Stopped at '||NOW
WHERE  area_id = ?
AND    charger_id = ?;
UPDATE requests 
SET    current_state = 'STOPPED'
  ,    current_state_explanation = 'Charging Stopped at '||NOW
    ,    charged_until_time = NOW
WHERE  area_id = ?
AND    request_id = ?;
END;

CREATE PROCEDURE end_charge_session
PARTITION ON TABLE area_chargers COLUMN area_id
AS
BEGIN
UPDATE area_chargers 
SET    current_state = 'FREE'
  ,    current_state_explanation = null
WHERE  area_id = ?
AND    charger_id = ?;
UPDATE requests 
SET    current_state = 'DEPARTED'
  ,    current_state_explanation = null
    ,    charged_until_time = NVL(charged_until_time,NOW)
    ,    actual_end_time = NOW
WHERE  area_id = ?
AND    request_id = ?;
END;



CREATE PROCEDURE get_vehicle
AS
BEGIN
SELECT *
FROM requests 
WHERE vehicle_plate = ?
ORDER BY area_id, charger_id, requested_start_time, request_id;
SELECT *
FROM request_charges
WHERE vehicle_plate = ?
ORDER BY area_id, charger_id,fee_time,request_id;
END;


CREATE PROCEDURE charge_kwh_fees
PARTITION ON TABLE area_chargers COLUMN area_id PARAMETER 3
AS
BEGIN
insert into request_charges (area_id, charger_id, fee_time, request_id, vehicle_plate,fee_type,kwh,qty,amount) 
select r.area_id, r.charger_id, NOW, r.request_id, r.vehicle_plate, 'KWH',1,CAST(? AS FLOAT),CAST(? AS FLOAT)
FROM requests r
   , area_chargers ac 
WHERE r.area_id = ac.area_id 
AND   r.charger_id = ac.charger_id
AND   r.request_id = ? 
AND   ac.area_id = ? 
AND   ac.charger_id = ?;
UPDATE area_chargers 
SET    current_state = 'CHARGING'
  ,    current_state_explanation = 'Just Charged '||CAST(? AS FLOAT) ||'kwh for $'||CAST(? AS FLOAT)
WHERE  area_id = ?
AND    charger_id = ?;
END;

CREATE PROCEDURE charge_wait_fees
DIRECTED
AS
insert into request_charges (area_id, charger_id, fee_time, request_id, vehicle_plate,fee_type,kwh,qty,amount) 
select r.area_id, r.charger_id, NOW, r.request_id, r.vehicle_plate, 'WAITFEE',0,1,ac.hold_rate_per_min 
FROM requests r
   , area_chargers ac 
WHERE r.area_id = ac.area_id 
AND   r.charger_id = ac.charger_id 
AND   r.current_state = 'WAITING';

CREATE TASK run_charge_wait_fees ON SCHEDULE EVERY 1 MINUTES 
PROCEDURE charge_wait_fees 
RUN ON PARTITIONS;

CREATE PROCEDURE charge_overage_fees
DIRECTED
AS
insert into request_charges (area_id, charger_id, fee_time, request_id, vehicle_plate,fee_type,kwh,qty,amount) 
select r.area_id, r.charger_id, NOW, r.request_id, r.vehicle_plate, 'OVERAGE',0,1,ac.overage_rate_per_min 
FROM requests r
   , area_chargers ac 
WHERE r.area_id = ac.area_id 
AND   r.charger_id = ac.charger_id 
AND   r.current_state = 'STOPPED';

CREATE TASK run_charge_overage_fees ON SCHEDULE EVERY 1 MINUTES 
PROCEDURE charge_overage_fees 
RUN ON PARTITIONS;


END_OF_BATCH

file voltdb-iotcars-testdata.sql;
