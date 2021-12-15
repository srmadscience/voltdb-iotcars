package org.voltdb.iotcars;

import org.voltdb.client.Client;

public class SimpleIOTDemo extends BaseIOTDemo {

    public static void main(String[] args) {
        
        String hostnames = args[0];
        
        try {
            Client c = connectVoltDB(hostnames);
            
            deleteOldData(c);
            
            runSingleVehicleExample(c);    
            
            
        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        

    }

}
