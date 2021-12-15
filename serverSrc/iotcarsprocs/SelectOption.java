package iotcarsprocs;

import java.util.Date;

/* This file is part of VoltDB.
 * Copyright (C) 2008-2020 VoltDB Inc.
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 * IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
 * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
 * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

import org.voltdb.SQLStmt;
import org.voltdb.VoltProcedure;
import org.voltdb.VoltTable;
import org.voltdb.types.TimestampType;

public class SelectOption extends VoltProcedure {

    // @formatter:off

    public static final SQLStmt getArea = new SQLStmt(
            "SELECT area_name FROM areas WHERE area_id = ?;");

    public static final SQLStmt getCharger = new SQLStmt(
            "SELECT charger_id, current_state, current_state_explanation "
            + "FROM area_chargers WHERE area_id = ? AND charger_id = ?;");

    public static final SQLStmt checkChargerTimeslots = new SQLStmt("select count(*) how_many"
            + " from area_charger_availability  "
            + "WHERE area_id = ? AND charger_id = ? AND timeslot BETWEEN TRUNCATE(MINUTE,?) AND TRUNCATE(MINUTE,?) ;");

    public static final SQLStmt removeChargerTimeslots = new SQLStmt("DELETE "
            + " from area_charger_availability  "
            + "WHERE area_id = ? AND charger_id = ? AND timeslot BETWEEN TRUNCATE(MINUTE,?) AND TRUNCATE(MINUTE,?) ;");

    public static final SQLStmt createRequest = new SQLStmt("INSERT INTO requests "
            + "(area_id,request_id,vehicle_plate,charger_id,max_kwh_hour_can_use,current_state,current_state_explanation,requested_start_time"
            + ", scheduled_end_time) VALUES (?,?,?,?,?,?,?,?,?);");

    public static final SQLStmt updateChargerStatus = new SQLStmt("UPDATE area_chargers "
            + "SET current_state = 'WAITING'"
            + "  , current_state_explanation = 'Waiting for ' || ? "
            + "WHERE area_id = ?"
            + "AND   charger_id = ?;");

    public static final SQLStmt getRequest = new SQLStmt("SELECT * FROM requests "
            + "WHERE area_id = ? "
            + "AND request_id = ?;");

	// @formatter:on

    public VoltTable[] run(long areaId, TimestampType arrivalTime, long chargerId, int wantedMinutes, int maxKwh,
            String licencePlate) throws VoltAbortException {

        this.setAppStatusCode(ReferenceData.STATUS_CHARGER_FOUND);

        if (arrivalTime == null) {
            throw new VoltAbortException("arrivalTime can't be null");
        }

        final Date departureTime = new Date(
                arrivalTime.asExactJavaDate().getTime() + ((wantedMinutes - 1) * 1000 * 60));

        // See if we know about this area and charger...
        voltQueueSQL(getArea, areaId);
        voltQueueSQL(getCharger, areaId, chargerId);
        voltQueueSQL(checkChargerTimeslots, areaId, chargerId, arrivalTime, departureTime);

        VoltTable[] availability = voltExecuteSQL();

        if (!availability[0].advanceRow()) {
            throw new VoltAbortException("Area " + areaId + " does not exist");
        }

        if (!availability[1].advanceRow()) {
            throw new VoltAbortException("Charger " + chargerId + " does not exist");
        }

        availability[2].advanceRow();
        long foundSlots = availability[2].getLong("how_many");

        if (foundSlots != wantedMinutes) {

            this.setAppStatusCode(ReferenceData.STATUS_CHARGER_NOT_FREE);
            this.setAppStatusString("Charger not free for entire time needed");

        } else {
            voltQueueSQL(removeChargerTimeslots, areaId, chargerId, arrivalTime, departureTime);
            voltQueueSQL(createRequest, areaId, this.getUniqueId(), licencePlate, chargerId, maxKwh, "WAITING",
                    "Due at " + arrivalTime.toString(), arrivalTime, departureTime);
            voltQueueSQL(updateChargerStatus, licencePlate, areaId, chargerId);
            voltQueueSQL(getCharger, areaId, chargerId);
            voltQueueSQL(getRequest, areaId, this.getUniqueId());

        }

        return voltExecuteSQL(true);
    }
}
