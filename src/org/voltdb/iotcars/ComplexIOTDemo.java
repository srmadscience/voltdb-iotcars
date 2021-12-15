package org.voltdb.iotcars;

import java.util.Arrays;

import org.voltdb.client.Client;

public class ComplexIOTDemo extends BaseIOTDemo {

    public static void main(String[] args) {
        
        msg("Parameters:" + Arrays.toString(args));

        if (args.length != 6) {
            msg("Usage: hostnames  tpms durationseconds usercount areacount queryseconds");
            System.exit(1);
        }


        
        String hostnames = args[0];
        int tps = Integer.parseInt(args[1]);
        int duration  = Integer.parseInt(args[2]);
        int queryseconds  = Integer.parseInt(args[3]);
        int usercount  = Integer.parseInt(args[4]);
        int areacount  = Integer.parseInt(args[5]);
        
        try {
            Client c = connectVoltDB(hostnames);
            Client c2 = connectVoltDB(hostnames);
                       
            createAreasAndChargers(c,94000, 95000);
            
            deleteOldData(c);
            
            runManyVehicleBenchmark(usercount, areacount,tps, duration,
                    queryseconds,c,c2);
            
            
        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        

    }

}
