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
import decisionservice.axisclient.proxy.ds.Currency;
import decisionservice.axisclient.proxy.ds.Order;
import decisionservice.axisclient.proxy.ds.ActionType;
import decisionservice.axisclient.proxy.ds.ReasonsType;
import decisionservice.axisclient.proxy.ds.SectorType;
import decisionservice.axisclient.proxy.ds.SecurityType;
import decisionservice.axisclient.proxy.ds.StatusType;

public class OrderFactory {
	public static Order createOrder () {
		Currency currencyEuro = Currency.Euro;
		ActionType action = ActionType.Buy;
		SecurityType securityType = SecurityType.Stock;
		java.util.Calendar dateTime = java.util.Calendar.getInstance();
		SectorType sector = SectorType.Oil;
		StatusType status = StatusType.Pending;
		ReasonsType reasons = ReasonsType.BadClient;
        Order order = new Order(
                "order000192-2006",
                "Company X",
                90,
                "Nouveau Marche",
                currencyEuro,
                "France",
                action,
                securityType,
                dateTime,
                sector,
                status,
                reasons);
		return order;
	}
}
