

file -inlinebatch END_OF_BATCH

DROP TASK run_create_appointment_slots IF EXISTS;
DROP TASK run_charge_wait_fees IF EXISTS;
DROP TASK run_overage_wait_fees IF EXISTS;
DROP TASK run_charge_wait_fees IF EXISTS;
DROP TASK run_charge_overage_fees IF EXISTS;

DROP PROCEDURE create_appointment_slots IF EXISTS;
DROP PROCEDURE charge_wait_fees IF EXISTS;
DROP PROCEDURE charge_overage_fees IF EXISTS;
DROP PROCEDURE charge_kwh_fees IF EXISTS;
DROP PROCEDURE GetOptions IF EXISTS;
DROP PROCEDURE SelectOption IF EXISTS;
DROP PROCEDURE ShowActivity__promBL IF EXISTS;
DROP PROCEDURE end_charge_session IF EXISTS;
DROP PROCEDURE stop_charge_session IF EXISTS;
DROP PROCEDURE start_charge_session IF EXISTS;
DROP PROCEDURE charge_kwh_fees IF EXISTS;
DROP PROCEDURE get_vehicle IF EXISTS;
DROP PROCEDURE GetParams IF EXISTS;

DROP VIEW request_state_view IF EXISTS;
DROP VIEW charger_state_view IF EXISTS;
DROP VIEW request_charge_summary_view IF EXISTS;
DROP VIEW charger_availability_fullness IF EXISTS;


DROP TABLE areas IF EXISTS;
DROP TABLE merchant_chargers IF EXISTS;
DROP TABLE area_merchants IF EXISTS;
DROP TABLE area_charger_availability IF EXISTS;
DROP TABLE area_chargers IF EXISTS;
DROP TABLE requests IF EXISTS;
DROP TABLE request_charges IF EXISTS;
DROP TABLE demo_parameters IF EXISTS;


END_OF_BATCH
