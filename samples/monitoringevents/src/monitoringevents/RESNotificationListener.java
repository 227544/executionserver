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

import javax.management.Notification;
import javax.management.NotificationListener;
import javax.management.ObjectName;
import java.util.logging.Logger;

/**
 * Rule Execution Server notification listener
 */
public class RESNotificationListener implements NotificationListener {

	private final static Logger logger = Logger.getLogger(RESNotificationListener.class.getName());

	/**
	 * Handle RuleApp and Ruleset notifications
	 * Add events in the RSS feed
	 */
	public void handleNotification(Notification notification, Object handback) {
		ObjectName objectName = (ObjectName) notification.getSource();
		// RuleApp property change notification
		if (notification.getType().equals(IlrJMXRuleAppMBean.NOTIFICATION_PROPERTY_CHANGE)) {
			Utils.addEvent(Utils.RULEAPP_MODIFIED + Utils.getRuleAppPropertyChangeMessage(objectName, notification),
				Utils.getRuleAppPropertyChangeMessage(objectName, notification),
				Utils.getRuleAppLink(objectName));
			logger.info("RuleApp property modification notification on --> " + objectName);
			// Ruleset property change notification
		} else if (notification.getType().equals(IlrJMXRulesetMBean.NOTIFICATION_PROPERTY_CHANGE)) {
			Utils.addEvent(Utils.RULESET_MODIFIED + Utils.getRulesetPropertyChangeMessage(objectName, notification),
				Utils.getRulesetPropertyChangeMessage(objectName, notification),
				Utils.getRulesetLink(objectName));
			logger.info("Ruleset property modification notification on --> " + objectName);
			// Ruleset archive change notification
		} else if (notification.getType().equals(IlrJMXRulesetMBean.NOTIFICATION_RULESET_ARCHIVE_CHANGE)) {
			Utils.addEvent(Utils.RULESETARCHIVE_MODIFIED + Utils.getRulesetDescription(objectName),
				Utils.getRulesetDescription(objectName),
				Utils.getRulesetLink(objectName));
			logger.info("Ruleset archive modification notification on --> " + objectName);
		}
	}
}
