package org.voltdb.iotcars;

import java.util.Date;
import java.util.Random;

public class VehicleState {

    public final static int STATUS_LOOKING = 0;
    public final static int STATUS_BOOKING = 1;
    public final static int STATUS_WAITING = 2;
    public final static int STATUS_CHARGING = 3;
    public final static int STATUS_STOPPED = 4;
    public final static int STATUS_ELSEWHERE = 5;

    Vehicle[] state = null;
    
    int unableToFindParkingCounter = 0;

    public VehicleState(int count) {
        super();
        state = new Vehicle[count];

        for (int i = 0; i < state.length; i++) {
            state[i] = new Vehicle();
        }

    }

    /**
     * @return the state
     */
    public int getState(int id) {
        return state[id].getState();
    }

    /**
     * @param state the state to set
     */
    public void setState(int newState, int id) {
        synchronized (state) {
            this.state[id].setState(newState);
        }
    }

    /**
     * @return the txInFlight
     */
    public boolean isTxInFlight(int id) {
        return state[id].isTxInFlight();
    }

    /**
     * @param txInFlight the txInFlight to set
     */
    public void setTxInFlight(int id, boolean txInFlight) {
        this.state[id].setTxInFlight(txInFlight);
    }

    public void startTran(int randomuser) {
        setTxInFlight(randomuser, true);

    }

    public void endCharging(int id) {
        synchronized (state) {
            this.state[id].setState(STATUS_ELSEWHERE);
            this.state[id].setTxInFlight(false);
            this.state[id].setEndActivityDate(new Date(System.currentTimeMillis() + 1000));
            this.state[id].setChargeStartTime(null);
        }

    }
    
    public void endChargingWithOverage(int id, int overageTimeMinutes) {
        
        synchronized (state) {
            this.state[id].setState(STATUS_STOPPED);
            this.state[id].setTxInFlight(false);
            this.state[id].setEndActivityDate(new Date(System.currentTimeMillis() + (overageTimeMinutes * 60 * 1000)));
            this.state[id].setChargeStartTime(null);
        }
       
    }

 
    
    public void nothingFound(int id) {
        synchronized (state) {
            this.state[id].setState(STATUS_ELSEWHERE);
            this.state[id].setTxInFlight(false);
            this.state[id].setEndActivityDate(new Date());
            this.state[id].setChargeStartTime(null);
            unableToFindParkingCounter++;
        }

    }

    public void bookingHappening(int id, long myChargerId, long areaId, Date arrivalTime) {

        synchronized (state) {
            this.state[id].setState(STATUS_BOOKING);
            this.state[id].setChargerId(myChargerId);
            this.state[id].setAreaId(areaId);
            this.state[id].setTxInFlight(true);
            this.state[id].setEndActivityDate(arrivalTime);
            this.state[id].setRequestId(-1);
        }

    }

    public void startWaiting(int id, long myChargerId, long areaId, Date arrivalTime, long requestId) {

        synchronized (state) {
            this.state[id].setState(STATUS_WAITING);
            this.state[id].setChargerId(myChargerId);
            this.state[id].setAreaId(areaId);
            this.state[id].setTxInFlight(false);
            this.state[id].setEndActivityDate(arrivalTime);
            this.state[id].setRequestId(requestId);
        }

    }
   public void startCharging(int id, Date endTime) {

        synchronized (state) {
            this.state[id].setState(STATUS_CHARGING);
            this.state[id].setTxInFlight(false);
            this.state[id].setEndActivityDate(endTime);
            this.state[id].setChargeStartTime(new Date());
        }

    }

    public void continueCharging(int id, Date endTime) {
        synchronized (state) {
            this.state[id].setState(STATUS_CHARGING);
            this.state[id].setTxInFlight(false);
            this.state[id].setEndActivityDate(endTime);
        }
    }

  

    public boolean isActive(int id) {

        return this.state[id].isActive();
    }

    public long getChargerId(int randomuser) {

        return this.state[randomuser].getChargerId();
    }

    
    public long getAreaId(int randomuser) {
        
        return this.state[randomuser].getAreaId();
    }

    public long getRequestId(int randomuser) {

        return this.state[randomuser].getRequestId();
    }

    public void setRequestId(int randomuser, long requestId) {

        this.state[randomuser].setRequestId(requestId);
    }
    

    /**
     * @return the unableToFindParkingCounter
     */
    public int getUnableToFindParkingCounter() {
        return unableToFindParkingCounter;
    }

 

    class Vehicle {
        int state = STATUS_ELSEWHERE;
        boolean txInFlight = false;
        long chargerId = -1;
        long requestId = -1;
        long areaId = -1;
        Date endActivityDate = new Date(0);
        Date chargeStartTime = null;

        /**
         * @return the state
         */
        public int getState() {
            return state;
        }

        /**
         * @param state the state to set
         */
        public void setState(int state) {
            this.state = state;
        }

        /**
         * @return the txInFlight
         */
        public boolean isTxInFlight() {
            return txInFlight;
        }

        /**
         * @param txInFlight the txInFlight to set
         */
        public void setTxInFlight(boolean txInFlight) {
            this.txInFlight = txInFlight;
        }

        /**
         * @return the chargerId
         */
        public long getChargerId() {
            return chargerId;
        }

        /**
         * @param chargerId the chargerId to set
         */
        public void setChargerId(long chargerId) {
            this.chargerId = chargerId;
        }

        /**
         * @return the endActivityDate
         */
        public Date getEndActivityDate() {
            return endActivityDate;
        }

        /**
         * @param endActivityDate the endActivityDate to set
         */
        public void setEndActivityDate(Date endActivityDate) {
            this.endActivityDate = endActivityDate;
        }

        public boolean isActive() {

            if (endActivityDate.after(new Date())) {
                return true;
            }

            return false;
        }

        /**
         * @return the requestId
         */
        public long getRequestId() {
            return requestId;
        }

        /**
         * @param requestId the requestId to set
         */
        public void setRequestId(long requestId) {
            this.requestId = requestId;
        }

        /**
         * @return the chargeStateTime
         */
        public Date getChargeStartTime() {
            return chargeStartTime;
        }

        /**
         * @param chargeStateTime the chargeStateTime to set
         */
        public void setChargeStartTime(Date chargeStateTime) {
            this.chargeStartTime = chargeStateTime;
        }

        /**
         * @return the areaId
         */
        public long getAreaId() {
            return areaId;
        }

        /**
         * @param areaId the areaId to set
         */
        public void setAreaId(long areaId) {
            this.areaId = areaId;
        }

        @Override
        public String toString() {
            StringBuilder builder = new StringBuilder();
            builder.append("Vehicle [state=");
            builder.append(state);
            builder.append(", txInFlight=");
            builder.append(txInFlight);
            builder.append(", chargerId=");
            builder.append(chargerId);
            builder.append(", requestId=");
            builder.append(requestId);
            builder.append(", areaId=");
            builder.append(areaId);
            builder.append(", endActivityDate=");
            builder.append(endActivityDate);
            builder.append(", chargeStartTime=");
            builder.append(chargeStartTime);
            builder.append("]");
            return builder.toString();
        }

    }

  
}
