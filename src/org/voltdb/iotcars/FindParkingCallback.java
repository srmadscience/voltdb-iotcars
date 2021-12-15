package org.voltdb.iotcars;

import java.io.IOException;
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
import java.util.Random;

import org.voltdb.VoltTable;
import org.voltdb.client.Client;
import org.voltdb.client.ClientResponse;
import org.voltdb.client.NoConnectionsException;
import org.voltdb.client.ProcedureCallback;

import iotcarsprocs.ReferenceData;

public class FindParkingCallback implements ProcedureCallback {

    VehicleState userTransactionState;
    int id;
    int randomArea;
    Random r;
    Client c2;
    
    public FindParkingCallback(VehicleState userTransactionState, int id, int randomArea,Random r,Client c2) {
        this.userTransactionState = userTransactionState;
        this.id = id;
        this.randomArea = randomArea;
        this.r = r;
        this.c2 = c2;
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

          VoltTable availableSpacesTable = availableSpacesQuery.getResults()[0];

          availableSpacesTable.resetRowPosition();

          if (availableSpacesTable.advanceRow()) {
              
              availableSpacesTable.advanceToRow(r.nextInt(availableSpacesTable.getRowCount()));

              long myChargerId = availableSpacesTable.getLong("CHARGER_ID");

              BookParkingCallback bpc = new BookParkingCallback(userTransactionState, id, randomArea);

              Date arrivalTime = new Date(System.currentTimeMillis() + 30000);

              userTransactionState.bookingHappening(id, myChargerId, randomArea, arrivalTime);

              c2.callProcedure(bpc, "SelectOption", randomArea, arrivalTime, myChargerId, r.nextInt(5) + 1, 75,
                      "CAR" + id);

          } else {

              userTransactionState.nothingFound(id);
          }

      } else {
          msg("FindParkingCallback user=" + id + ":" + availableSpacesQuery.getStatusString());
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
