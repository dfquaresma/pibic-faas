package com.openfaas.function;

import com.openfaas.model.IHandler;
import com.openfaas.model.IResponse;
import com.openfaas.model.IRequest;
import com.openfaas.model.Response;

import java.lang.management.GarbageCollectorMXBean;
import java.lang.management.ManagementFactory;

import java.util.List;
import java.util.ArrayList;


public class Handler implements com.openfaas.model.IHandler {

    public IResponse Handle(IRequest req) {
	List<GarbageCollectorMXBean> gcs = ManagementFactory.getGarbageCollectorMXBeans();
	GarbageCollectorMXBean scavenge = gcs.get(0);
	GarbageCollectorMXBean markSweep = gcs.get(1);

	long countBeforeScavenge = scavenge.getCollectionCount();
	long timeBeforeScavenge = scavenge.getCollectionTime();
        long countBeforeMarkSweep = markSweep.getCollectionCount();
        long timeBeforeMarkSweep = markSweep.getCollectionTime();

	long before = System.currentTimeMillis();
	businessLogic();
        long after = System.currentTimeMillis();

        long countAfterScavenge = scavenge.getCollectionCount();
        long timeAfterScavenge = scavenge.getCollectionTime();
        long countAfterMarkSweep = markSweep.getCollectionCount();
        long timeAfterMarkSweep = markSweep.getCollectionTime();


        String processName = java.lang.management.ManagementFactory.getRuntimeMXBean().getName();
        long pid = Long.parseLong(processName.split("@")[0]);

        String data =
		"pid: " + Long.toString(pid) +
                ", Business Logic Time in Milliseconds: " + Long.toString(after - before) + System.lineSeparator() +
                "Scavenge Number of Collections: " + Long.toString(countAfterScavenge - countBeforeScavenge) +
                ", Scavenge Collections Time Spent in Milliseconds: " + Long.toString(timeAfterScavenge - timeBeforeScavenge) + System.lineSeparator() +
                "MarkSweep Number of Collections: " + Long.toString(countAfterMarkSweep - countBeforeMarkSweep) +
                ", MarkSweep Collections Time Spent in Milliseconds: " + Long.toString(timeAfterMarkSweep - timeBeforeMarkSweep);

	Response res = new Response();
 	res.setBody(data);
	return res;
    }

    public void businessLogic() {
        int size = (int) Math.pow(2, 21);
        List<Integer> list  = new ArrayList();
        for (int i = 0; i < size; i++) {
                list.add(i);
        }
    }

}
