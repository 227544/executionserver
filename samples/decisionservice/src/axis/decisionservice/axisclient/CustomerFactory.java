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
import decisionservice.axisclient.proxy.ds.Customer;
import decisionservice.axisclient.proxy.ds.Currency;






public class CustomerFactory {
	public static Customer createCustomer () {
		Currency currencyEuro = Currency.Euro;
		Customer customer = new Customer(
		           "John Smith",
		           "George Smith@IBM",
		           (float)2000.0,
		           (float)800.0,
		           (float)800.0,
		           (float)800.0,
		           (float)800.0,
		           (float)800.0,
		           (float)800.0,
		           (float)800.0,
		           (float)800.0,
		           currencyEuro);
		return customer;
	}

}
