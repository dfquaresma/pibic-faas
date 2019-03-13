package com.openfaas.function;

import com.openfaas.model.IHandler;
import com.openfaas.model.IResponse;
import com.openfaas.model.IRequest;
import com.openfaas.model.Response;

public class Handler implements com.openfaas.model.IHandler {

    public IResponse Handle(IRequest req) {
	Response res = new Response();

    String processName = java.lang.management.ManagementFactory.getRuntimeMXBean().getName();
	String pid = processName.split("@")[0]; 
	String pidHeader = req.getHeader("X-pid");
	
	if (pidHeader != null && pid.equals(pidHeader)) {
	    res.setStatusCode(503);
	}
	
	res.setBody(pid + " " + pidHeader);
	return res;
	}
}
