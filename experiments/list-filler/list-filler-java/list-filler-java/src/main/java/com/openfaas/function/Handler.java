package com.openfaas.function;

import com.openfaas.model.IHandler;
import com.openfaas.model.IResponse;
import com.openfaas.model.IRequest;
import com.openfaas.model.Response;

import java.util.ArrayList;

public class Handler implements com.openfaas.model.IHandler {

    public IResponse Handle(IRequest req) {
	int size = (int) Math.pow(2, 21);

	long before = System.currentTimeMillis();
        ArrayList<Integer> list  = new ArrayList();
	for (int i = 0; i < size; i++) {
		list.add(i);
	}
        long after = System.currentTimeMillis();

	Response res = new Response();
 	res.setBody(Long.toString(after - before) + System.lineSeparator());
	return res;
    }
}
