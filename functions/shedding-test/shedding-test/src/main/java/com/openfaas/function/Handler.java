package com.openfaas.function;

import com.openfaas.model.IHandler;
import com.openfaas.model.IResponse;
import com.openfaas.model.IRequest;
import com.openfaas.model.Response;

public class Handler implements com.openfaas.model.IHandler {

    public IResponse Handle(IRequest req) {
	Response res = new Response();

        String processName = java.lang.management.ManagementFactory.getRuntimeMXBean().getName();
	long pid = Long.parseLong(processName.split("@")[0]);
	Long header = Long.parseLong(req.getHeader("pid"));

	res.setBody(Long.toString(pid) + " " + Long.toString(header));
	if (pid == header) {
	    res.setStatusCode(503);
	};

	return res;
    }
}
