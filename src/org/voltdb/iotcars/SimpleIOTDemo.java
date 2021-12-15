package org.voltdb.iotcars;

import java.util.Arrays;

import org.voltdb.client.Client;

public class SimpleIOTDemo extends BaseIOTDemo {

    public static void main(String[] args) {
        
        msg("Parameters:" + Arrays.toString(args));

        if (args.length != 1) {
            msg("Usage: hostnames");
            System.exit(1);
        }

        
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
