package com.openfaas.function;

import com.openfaas.model.IHandler;
import com.openfaas.model.IResponse;
import com.openfaas.model.IRequest;
import com.openfaas.model.Response;

public class Handler implements com.openfaas.model.IHandler {

    public IResponse Handle(IRequest req) {
	Response res = new Response();

	String hostname = System.getenv("HOSTNAME");
	String header = req.getHeader("X-hostname");
	
	if (header != null && hostname.equals(header)) {
	    res.setStatusCode(503);
	} else {
	    res.setStatusCode(200);
	}
	
	res.setBody(hostname + " " + header);
	return res;
	}
}
