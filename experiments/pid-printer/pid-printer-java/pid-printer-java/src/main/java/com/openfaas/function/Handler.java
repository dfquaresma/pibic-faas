package com.openfaas.function;

import com.openfaas.model.IHandler;
import com.openfaas.model.IResponse;
import com.openfaas.model.IRequest;
import com.openfaas.model.Response;

public class Handler implements com.openfaas.model.IHandler {

    public IResponse Handle(IRequest req) {
        Response res = new Response();

        String processName = java.lang.management.ManagementFactory.getRuntimeMXBean().getName();
	String pid = Long.toString(Long.parseLong(processName.split("@")[0]));
	res.setBody(pid);

	return res;
    }
}
