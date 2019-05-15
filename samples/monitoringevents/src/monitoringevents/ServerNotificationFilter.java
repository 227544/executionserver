/*
* Licensed Materials - Property of IBM
* 5725-B69 5655-Y17 5655-Y31 5724-X98 5724-Y15 5655-V82 
* Copyright IBM Corp. 1987, 2018. All Rights Reserved.
*
* Note to U.S. Government Users Restricted Rights: 
* Use, duplication or disclosure restricted by GSA ADP Schedule 
* Contract with IBM Corp.
*/

package monitoringevents;

import ilog.rules.res.model.mbean.IlrJMXRuleAppMBean;
import ilog.rules.res.model.mbean.IlrJMXRulesetMBean;

import javax.management.MBeanServerNotification;
import javax.management.Notification;
import javax.management.NotificationFilter;
import javax.management.ObjectName;

/**
 * Filters the MBean server notifications to keep only the RES ones
 */
public class ServerNotificationFilter implements NotificationFilter {

	private static final long serialVersionUID = 1L;

	/**
	 * @return true if the notification type is IlrJmxRuleAppMBean.VALUE_TYPE or IlrJmxRulesetMBean.VALUE_TYPE
	 */
	public boolean isNotificationEnabled(Notification notification) {
		if (notification instanceof MBeanServerNotification) {
			ObjectName objectName = ((MBeanServerNotification) notification).getMBeanName();
			String type = objectName.getKeyProperty(Utils.TYPE);
			if ((type != null)
					&& ((type.equals(IlrJMXRuleAppMBean.VALUE_TYPE))
					|| (type.equals(IlrJMXRulesetMBean.VALUE_TYPE))))
				return true;
			else
				return false;
		} else {
			return false;
		}
	}

}
