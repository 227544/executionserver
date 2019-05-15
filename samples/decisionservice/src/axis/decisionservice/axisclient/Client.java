/*
* Licensed Materials - Property of IBM
* 5725-B69 5655-Y17 5655-Y31 5724-X98 5724-Y15 5655-V82 
* Copyright IBM Corp. 1987, 2018. All Rights Reserved.
*
* Note to U.S. Government Users Restricted Rights: 
* Use, duplication or disclosure restricted by GSA ADP Schedule 
* Contract with IBM Corp.
*/

package decisionservice.axisclient;

import java.net.MalformedURLException;
import java.net.URL;
import java.rmi.RemoteException;

import javax.xml.rpc.ServiceException;

import decisionservice.axisclient.proxy.tracefilter.TraceFilter;
import decisionservice.axisclient.proxy.ds.PreTradeChecksException;
import decisionservice.axisclient.proxy.ds.PreTradeChecksDecisionService_PortType;
import decisionservice.axisclient.proxy.ds.PreTradeChecksDecisionService_ServiceLocator;
import decisionservice.axisclient.proxy.ds.PreTradeChecksRequest;
import decisionservice.axisclient.proxy.ds.PreTradeChecksResponse;
import decisionservice.axisclient.proxy.ds.ReasonsType;
import decisionservice.axisclient.proxy.param.CustomerParameter;
import decisionservice.axisclient.proxy.param.OrderParameter;
import decisionservice.axisclient.proxy.param.ReportParameter;


public class Client {
	// Print the report content
	private static void printReport (ReportParameter report) {
		ReasonsType reasons = report.getReportParameter().getReasons();
		String value = reasons.getValue();
		System.out.println("Report reason = " + value);
	}

	// Call the decision service with the AXIS client generated java code
 	public static void main (String[] args) throws MalformedURLException, ServiceException, PreTradeChecksException, RemoteException {
 		// Instantiate the locator
		PreTradeChecksDecisionService_ServiceLocator locator = new PreTradeChecksDecisionService_ServiceLocator() ;
		// Get the endpoint url
		String address = locator.getPreTradeChecksRuleAppPreTradeChecksPortAddress();
		// retrieve the port type
		PreTradeChecksDecisionService_PortType pt = locator.getPreTradeChecksRuleAppPreTradeChecksPort(new URL (address));
		// Instantiate the input parameters
		OrderParameter orderParam 			= new OrderParameter (OrderFactory.createOrder());
		CustomerParameter customerParam 	= new CustomerParameter (CustomerFactory.createCustomer());
		// Create and configure a trace filter
		TraceFilter decisionTraceFilter = new TraceFilter();
		decisionTraceFilter.setAll(true);
		PreTradeChecksRequest dsr 	=
		    new PreTradeChecksRequest ("mydecision",decisionTraceFilter, customerParam, orderParam);
		// Invoke the decision service
		PreTradeChecksResponse dsresponse = pt.preTradeChecks(dsr);
		// Get the executed rule(s) count from the trace and print it
		// Note that the trace is enabled because the trace filter was configured
		// and the WSDL URL includes trace=true
		int count = dsresponse.getDecisionTrace().getTotalRulesFired().intValue();
		System.out.println("Nb rules fired " + count) ;
		// Retrieve the output parameter
		ReportParameter report = dsresponse.getReportParameter();
		// Print the result
		printReport(report) ;
	}

}
