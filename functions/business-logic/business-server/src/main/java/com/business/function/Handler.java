package com.business.function;

import java.lang.management.GarbageCollectorMXBean;
import java.lang.management.ManagementFactory;

import java.util.List;

import com.business.model.IHandler;
import com.business.model.IRequest;
import com.business.model.IResponse;
import com.business.model.Response;

import java.util.ArrayList;
import java.lang.Error;

public class Handler implements com.business.model.IHandler {

    public IResponse Handle(IRequest req) {
        List<GarbageCollectorMXBean> gcs = ManagementFactory.getGarbageCollectorMXBeans();
        GarbageCollectorMXBean scavenge = gcs.get(0);
        GarbageCollectorMXBean markSweep = gcs.get(1);

        long countBeforeScavenge = scavenge.getCollectionCount();
        long timeBeforeScavenge = scavenge.getCollectionTime();
        long countBeforeMarkSweep = markSweep.getCollectionCount();
        long timeBeforeMarkSweep = markSweep.getCollectionTime();
        long before = System.currentTimeMillis();

        String err = callFunction();

        long after = System.currentTimeMillis();
        long countAfterScavenge = scavenge.getCollectionCount();
        long timeAfterScavenge = scavenge.getCollectionTime();
        long countAfterMarkSweep = markSweep.getCollectionCount();
        long timeAfterMarkSweep = markSweep.getCollectionTime();

        String processName = java.lang.management.ManagementFactory.getRuntimeMXBean().getName();
        long pid = Long.parseLong(processName.split("@")[0]);

        String output = err + System.lineSeparator();
        if (err.length() == 0) {
            output = Long.toString(pid) + "," + // Pid
                Long.toString(after - before) + "," + // Business Logic Time in Milliseconds
                Long.toString(countAfterScavenge - countBeforeScavenge) + "," + // Scavenge Number of Collections
                Long.toString(timeAfterScavenge - timeBeforeScavenge) + "," + // Scavenge Collections Time Spent in Milliseconds
                Long.toString(countAfterMarkSweep - countBeforeMarkSweep) + "," + // MarkSweep Number of Collections
                Long.toString(timeAfterMarkSweep - timeBeforeMarkSweep); // MarkSweep Collections Time Spent in Milliseconds
        }

        Response res = new Response();
        res.setBody(output);
        return res;
    }

    public String callFunction() {
        String err = "";
        try {
        	System.out.println("DEBUG: Before Business");
        	int size = (int) Math.pow(2, Integer.parseInt(System.getenv("to_power_of")));
            List<Integer> list  = new ArrayList();
            for (int i = 0; i < size; i++) {
                    list.add(i);
            }
        	System.out.println("DEBUG: After Business");
            
        } catch (Exception e) {
            err = e.toString() + System.lineSeparator()
            		+ e.getCause() + System.lineSeparator()
            		+ e.getMessage();
            System.out.println("DEBUG: Exception in Business");
            
        } catch (Error e) {
            err = e.toString() + System.lineSeparator()
            		+ e.getCause() + System.lineSeparator()
            		+ e.getMessage();
            System.out.println("DEBUG: Error in Business");
        }

        return err;
    }

}
