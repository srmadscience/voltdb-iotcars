package org.voltdb.iotcars;

import java.math.BigDecimal;

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

import java.text.SimpleDateFormat;
import java.util.Date;

import org.voltdb.VoltTable;

import org.voltdb.client.ClientResponse;
import org.voltdb.client.ProcedureCallback;

import iotcarsprocs.ReferenceData;

public class BookParkingCallback implements ProcedureCallback {

    VehicleState userTransactionState;
    int id;
    int randomArea;
    
    public BookParkingCallback(VehicleState userTransactionState, int id, int randomArea) {
        this.userTransactionState = userTransactionState;
        this.id = id;
        this.randomArea = randomArea;
    }

    /*
     * (non-Javadoc)
     * 
     * @see org.voltdb.chargingdemo.ReportLatencyCallback#clientCallback(org.voltdb.
     * client.ClientResponse)
     */
    @Override
    public void clientCallback(ClientResponse availableSpacesQuery) throws Exception {
        
  
        if (availableSpacesQuery.getStatus() == ClientResponse.SUCCESS) {
            
            if (availableSpacesQuery.getResults().length == 0) {
                // Space was taken
                userTransactionState.spaceStolen(id);
            } else {
               // userTransactionState.setState(UserState.STATUS_WAITING, id);
                VoltTable requestTable = availableSpacesQuery.getResults()[4];requestTable.advanceRow();
                long requestId = requestTable.getLong("REQUEST_ID");
                long chargerId = requestTable.getLong("CHARGER_ID");
                Date arrivalTime = new Date(System.currentTimeMillis() + 30000);
                userTransactionState.startWaiting(id, chargerId, randomArea, arrivalTime,requestId);
            }

           
        } else {
            msg("BookParkingCallback user=" + id + ":" + availableSpacesQuery.getStatusString());
        }
    }

    /**
     * Print a formatted message.
     * 
     * @param message
     */
    public static void msg(String message) {

        SimpleDateFormat sdfDate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Date now = new Date();
        String strDate = sdfDate.format(now);
        System.out.println(strDate + ":" + message);

    }

}
