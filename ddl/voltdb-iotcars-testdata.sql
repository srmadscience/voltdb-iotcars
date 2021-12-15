INSERT INTO demo_parameters (param_name, param_value) values ('MINUTES_BEFORE_ARRIVAL',2);
INSERT INTO demo_parameters (param_name, param_value) values ('MINUTES_SPENT_CHARGING',2);
INSERT INTO demo_parameters (param_name, param_value) values ('MAX_OVERAGE_TIME',4);

INSERT INTO areas (area_id, area_name) VALUES (94597, 'Walnut Creek, CA');

INSERT INTO area_merchants (area_id, merchant_id, merchant_name, merchant_offers) VALUES (94597, 1, 'Bobs Burgers','Free Lunch special with charging');

INSERT INTO area_merchants (area_id, merchant_id, merchant_name,merchant_offers) VALUES (94597, 2, 'Alans Air','Free air in your tires');

INSERT INTO area_chargers
(area_id,charger_id,merchant_id,charger_kwh,hold_rate_per_min,kwh_rate,overage_rate_per_min,current_state,current_state_explanation,charging_requester_id)
values
(94597,1,1,75,3,0.31,20,'FREE','Not in use',null);

INSERT INTO area_chargers
(area_id,charger_id,merchant_id,charger_kwh,hold_rate_per_min,kwh_rate,overage_rate_per_min,current_state,current_state_explanation,charging_requester_id)
values
(94597,2,2,75,3,3.31,20,'FREE','Not in use',null);

INSERT INTO area_chargers
(area_id,charger_id,merchant_id,charger_kwh,hold_rate_per_min,kwh_rate,overage_rate_per_min,current_state,current_state_explanation,charging_requester_id)
values
(94597,3,null,15,3,0.31,20,'FREE','Not in use',null);

INSERT INTO area_chargers
(area_id,charger_id,merchant_id,charger_kwh,hold_rate_per_min,kwh_rate,overage_rate_per_min,current_state,current_state_explanation,charging_requester_id)
values
(94597,4,null,15,3,0.31,20,'FREE','Not in use',null);

INSERT INTO area_chargers
(area_id,charger_id,merchant_id,charger_kwh,hold_rate_per_min,kwh_rate,overage_rate_per_min,current_state,current_state_explanation,charging_requester_id)
values
(94597,5,null,15,3,0.31,20,'FREE','Not in use',null);

INSERT INTO merchant_chargers (area_id, charger_id, merchant_id) values (94597,1,1);
INSERT INTO merchant_chargers (area_id, charger_id, merchant_id) values (94597,2,2);


insert into area_charger_availability select area_id,charger_id,DATEADD(MINUTE,0,truncate(MINUTE,NOW)) from area_chargers;
insert into area_charger_availability select area_id,charger_id,DATEADD(MINUTE,1,truncate(MINUTE,NOW)) from area_chargers;
insert into area_charger_availability select area_id,charger_id,DATEADD(MINUTE,2,truncate(MINUTE,NOW)) from area_chargers;
insert into area_charger_availability select area_id,charger_id,DATEADD(MINUTE,3,truncate(MINUTE,NOW)) from area_chargers;
insert into area_charger_availability select area_id,charger_id,DATEADD(MINUTE,4,truncate(MINUTE,NOW)) from area_chargers;
insert into area_charger_availability select area_id,charger_id,DATEADD(MINUTE,5,truncate(MINUTE,NOW)) from area_chargers;
insert into area_charger_availability select area_id,charger_id,DATEADD(MINUTE,6,truncate(MINUTE,NOW)) from area_chargers;
insert into area_charger_availability select area_id,charger_id,DATEADD(MINUTE,7,truncate(MINUTE,NOW)) from area_chargers;
insert into area_charger_availability select area_id,charger_id,DATEADD(MINUTE,8,truncate(MINUTE,NOW)) from area_chargers;
insert into area_charger_availability select area_id,charger_id,DATEADD(MINUTE,9,truncate(MINUTE,NOW)) from area_chargers;
insert into area_charger_availability select area_id,charger_id,DATEADD(MINUTE,10,truncate(MINUTE,NOW)) from area_chargers;
insert into area_charger_availability select area_id,charger_id,DATEADD(MINUTE,11,truncate(MINUTE,NOW)) from area_chargers;
insert into area_charger_availability select area_id,charger_id,DATEADD(MINUTE,12,truncate(MINUTE,NOW)) from area_chargers;
insert into area_charger_availability select area_id,charger_id,DATEADD(MINUTE,13,truncate(MINUTE,NOW)) from area_chargers;
insert into area_charger_availability select area_id,charger_id,DATEADD(MINUTE,14,truncate(MINUTE,NOW)) from area_chargers;
insert into area_charger_availability select area_id,charger_id,DATEADD(MINUTE,15,truncate(MINUTE,NOW)) from area_chargers;
insert into area_charger_availability select area_id,charger_id,DATEADD(MINUTE,16,truncate(MINUTE,NOW)) from area_chargers;
insert into area_charger_availability select area_id,charger_id,DATEADD(MINUTE,17,truncate(MINUTE,NOW)) from area_chargers;
insert into area_charger_availability select area_id,charger_id,DATEADD(MINUTE,18,truncate(MINUTE,NOW)) from area_chargers;
insert into area_charger_availability select area_id,charger_id,DATEADD(MINUTE,19,truncate(MINUTE,NOW)) from area_chargers;
insert into area_charger_availability select area_id,charger_id,DATEADD(MINUTE,20,truncate(MINUTE,NOW)) from area_chargers;
insert into area_charger_availability select area_id,charger_id,DATEADD(MINUTE,21,truncate(MINUTE,NOW)) from area_chargers;
insert into area_charger_availability select area_id,charger_id,DATEADD(MINUTE,22,truncate(MINUTE,NOW)) from area_chargers;
insert into area_charger_availability select area_id,charger_id,DATEADD(MINUTE,23,truncate(MINUTE,NOW)) from area_chargers;
insert into area_charger_availability select area_id,charger_id,DATEADD(MINUTE,24,truncate(MINUTE,NOW)) from area_chargers;
insert into area_charger_availability select area_id,charger_id,DATEADD(MINUTE,25,truncate(MINUTE,NOW)) from area_chargers;
insert into area_charger_availability select area_id,charger_id,DATEADD(MINUTE,26,truncate(MINUTE,NOW)) from area_chargers;
insert into area_charger_availability select area_id,charger_id,DATEADD(MINUTE,27,truncate(MINUTE,NOW)) from area_chargers;
insert into area_charger_availability select area_id,charger_id,DATEADD(MINUTE,28,truncate(MINUTE,NOW)) from area_chargers;
insert into area_charger_availability select area_id,charger_id,DATEADD(MINUTE,29,truncate(MINUTE,NOW)) from area_chargers;
insert into area_charger_availability select area_id,charger_id,DATEADD(MINUTE,30,truncate(MINUTE,NOW)) from area_chargers;
insert into area_charger_availability select area_id,charger_id,DATEADD(MINUTE,31,truncate(MINUTE,NOW)) from area_chargers;
insert into area_charger_availability select area_id,charger_id,DATEADD(MINUTE,32,truncate(MINUTE,NOW)) from area_chargers;
insert into area_charger_availability select area_id,charger_id,DATEADD(MINUTE,33,truncate(MINUTE,NOW)) from area_chargers;
insert into area_charger_availability select area_id,charger_id,DATEADD(MINUTE,34,truncate(MINUTE,NOW)) from area_chargers;
insert into area_charger_availability select area_id,charger_id,DATEADD(MINUTE,35,truncate(MINUTE,NOW)) from area_chargers;
insert into area_charger_availability select area_id,charger_id,DATEADD(MINUTE,36,truncate(MINUTE,NOW)) from area_chargers;
insert into area_charger_availability select area_id,charger_id,DATEADD(MINUTE,37,truncate(MINUTE,NOW)) from area_chargers;
insert into area_charger_availability select area_id,charger_id,DATEADD(MINUTE,38,truncate(MINUTE,NOW)) from area_chargers;
insert into area_charger_availability select area_id,charger_id,DATEADD(MINUTE,39,truncate(MINUTE,NOW)) from area_chargers;
insert into area_charger_availability select area_id,charger_id,DATEADD(MINUTE,40,truncate(MINUTE,NOW)) from area_chargers;
insert into area_charger_availability select area_id,charger_id,DATEADD(MINUTE,41,truncate(MINUTE,NOW)) from area_chargers;
insert into area_charger_availability select area_id,charger_id,DATEADD(MINUTE,42,truncate(MINUTE,NOW)) from area_chargers;
insert into area_charger_availability select area_id,charger_id,DATEADD(MINUTE,43,truncate(MINUTE,NOW)) from area_chargers;
insert into area_charger_availability select area_id,charger_id,DATEADD(MINUTE,44,truncate(MINUTE,NOW)) from area_chargers;
insert into area_charger_availability select area_id,charger_id,DATEADD(MINUTE,45,truncate(MINUTE,NOW)) from area_chargers;
insert into area_charger_availability select area_id,charger_id,DATEADD(MINUTE,46,truncate(MINUTE,NOW)) from area_chargers;
insert into area_charger_availability select area_id,charger_id,DATEADD(MINUTE,47,truncate(MINUTE,NOW)) from area_chargers;
insert into area_charger_availability select area_id,charger_id,DATEADD(MINUTE,48,truncate(MINUTE,NOW)) from area_chargers;
insert into area_charger_availability select area_id,charger_id,DATEADD(MINUTE,49,truncate(MINUTE,NOW)) from area_chargers;
insert into area_charger_availability select area_id,charger_id,DATEADD(MINUTE,50,truncate(MINUTE,NOW)) from area_chargers;
insert into area_charger_availability select area_id,charger_id,DATEADD(MINUTE,51,truncate(MINUTE,NOW)) from area_chargers;
insert into area_charger_availability select area_id,charger_id,DATEADD(MINUTE,52,truncate(MINUTE,NOW)) from area_chargers;
insert into area_charger_availability select area_id,charger_id,DATEADD(MINUTE,53,truncate(MINUTE,NOW)) from area_chargers;
insert into area_charger_availability select area_id,charger_id,DATEADD(MINUTE,54,truncate(MINUTE,NOW)) from area_chargers;
insert into area_charger_availability select area_id,charger_id,DATEADD(MINUTE,55,truncate(MINUTE,NOW)) from area_chargers;
insert into area_charger_availability select area_id,charger_id,DATEADD(MINUTE,56,truncate(MINUTE,NOW)) from area_chargers;
insert into area_charger_availability select area_id,charger_id,DATEADD(MINUTE,57,truncate(MINUTE,NOW)) from area_chargers;
insert into area_charger_availability select area_id,charger_id,DATEADD(MINUTE,58,truncate(MINUTE,NOW)) from area_chargers;
insert into area_charger_availability select area_id,charger_id,DATEADD(MINUTE,59,truncate(MINUTE,NOW)) from area_chargers;


