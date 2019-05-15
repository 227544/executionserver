/*
* Licensed Materials - Property of IBM
* 5725-B69 5655-Y17 5655-Y31 5724-X98 5724-Y15 5655-V82 
* Copyright IBM Corp. 1987, 2018. All Rights Reserved.
*
* Note to U.S. Government Users Restricted Rights: 
* Use, duplication or disclosure restricted by GSA ADP Schedule 
* Contract with IBM Corp.
*/

package io.swagger.client.api;

import io.swagger.client.ApiException;
import io.swagger.client.model.Response;
import io.swagger.client.model.TraceFilter;
import io.swagger.client.model.Customer.CurrencyEnum;
import io.swagger.client.model.Order.ActionEnum;
import io.swagger.client.model.Order.ReasonsEnum;
import io.swagger.client.model.Order.SectorEnum;
import io.swagger.client.model.Order.SecurityTypeEnum;
import io.swagger.client.model.Order.StatusEnum;
import io.swagger.client.model.Request;
import io.swagger.client.model.Customer;
import io.swagger.client.model.Error;
import io.swagger.client.model.Order;

import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.junit.Test;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/** 
 * API tests for DefaultApi
 */
public class SimpleApiTest {

    private final DefaultApi api = new DefaultApi();

    
    /**
     * Invokes the execution of the decision service operation PreTradeChecks.
     *
     * Executes the decision service operation PreTradeChecks with the path /PreTradeChecksRuleApp/1.0/PreTradeChecks/1.0.
     *
     * @throws ApiException
     *          if the Api call fails
     */
    @Test
    public void callDecisionServiceOperationTest() throws ApiException {
    	Request request = new Request();
        /*
		 * Initialize customer values
		 */
		Customer customer = new Customer();
		customer.setName("John Smith");
		customer.setOwner("George Smith@IBM");
		customer.setInitialValue((float) 2000);
		customer.setCurrentValue((float) 800);
		customer.setSectorPosition((float) 800);
		customer.setBankStockPosition((float) 800);
		customer.setOilStockPosition((float) 800);
		customer.setRailStockPosition((float) 800);
		customer.setBondPosition((float) 800);
		customer.setFuturPosition((float) 800);
		customer.setStockPosition((float) 800);
		customer.setCurrency(CurrencyEnum.EURO);
		
		/*
		 * Initialize order values
		 */
		Order order = new Order();
		order.setStock("Company X");
		order.setAmount(90);
		order.setAction(ActionEnum.BUY);
		order.setSecurityType(SecurityTypeEnum.STOCK);
		DateTimeFormatter formatter = DateTimeFormat.forPattern("yyyy-MM-dd'T'HH:mm:ss");
		DateTime date = formatter.parseDateTime("2004-02-14T19:44:14");
		order.setDateTime(new DateTime(date));
		order.setSector(SectorEnum.OIL);
		order.setStatus(StatusEnum.PENDING);
		order.setReasons(ReasonsEnum.BADCLIENT);
		// Optional parameters
		order.setId("an_id");
		order.setExchange("New Market");
		order.setCurrency(io.swagger.client.model.Order.CurrencyEnum.EURO);
		order.setDestination("France");
		
		
		/*
		 * Initialize some trace filter values
		 */
		TraceFilter traceFilter = new TraceFilter();
		traceFilter.setInfoTotalRulesFired(true);
		traceFilter.setInfoBoundObjectByRule(false);
		traceFilter.setInfoRules(false);
		traceFilter.setInfoRulesetProperties(false);
		traceFilter.setInfoSystemProperties(false);
		traceFilter.setNone(true);
		
		/*
		 * Update request
		 */
		request.setCustomerParameter(customer);
		request.setOrderParameter(order);
		request.traceFilter_(traceFilter);
		
		
		Response result = null;
		try {
			/*
			 * Call the service
			 */
			result = api.callPreTradeChecksDecisionServiceOperation(request);
			
			System.out.println(result);
			
			/*
			 * Perform some tests
			 */
			assertNotNull(result.getReportParameter());
			assertEquals("an_id", result.getReportParameter().getId());
			assertEquals(new Integer(90), result.getReportParameter().getAmount());
			assertEquals("New Market", result.getReportParameter().getExchange());
			assertEquals(io.swagger.client.model.Order.CurrencyEnum.EURO, result.getReportParameter().getCurrency());
			assertEquals("France", result.getReportParameter().getDestination());
			assertEquals(ActionEnum.BUY, result.getReportParameter().getAction());
			assertEquals(SecurityTypeEnum.STOCK, result.getReportParameter().getSecurityType());
			assertEquals(SectorEnum.OIL, result.getReportParameter().getSector());
			assertEquals(StatusEnum.BLOCKED, result.getReportParameter().getStatus());
			assertEquals(ReasonsEnum.BLACKLISTSTOCKS, result.getReportParameter().getReasons());
			
		} catch (ApiException e) {
			System.err.println("Exception when calling DefaultApi#executeRuleset");
			e.printStackTrace();
		}
		assertNotNull(result);
    }
    
}
