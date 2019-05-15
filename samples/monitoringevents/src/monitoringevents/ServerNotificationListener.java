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

import javax.management.InstanceNotFoundException;
import javax.management.MBeanServer;
import javax.management.MBeanServerNotification;
import javax.management.Notification;
import javax.management.NotificationListener;
import javax.management.ObjectName;

import java.util.logging.Logger;

/**
 * Gets the RES notifications sent to the MBean server (MBean create / remove)
 */
public class ServerNotificationListener implements NotificationListener {

	public RESNotificationListener resListener = new RESNotificationListener();

	private final static Logger logger = Logger.getLogger(ServerNotificationListener.class.getName());

	/**
	 * Register the RES notification listener on RuleApp/Ruleset creation
	 */
	public void handleNotification(Notification notification, Object handback) {
		if (notification instanceof MBeanServerNotification) {
			ObjectName objectName = ((MBeanServerNotification) notification).getMBeanName();
			if (objectName.getKeyProperty(Utils.TYPE).equals(IlrJMXRuleAppMBean.VALUE_TYPE)) {
				if (notification.getType().equals(MBeanServerNotification.REGISTRATION_NOTIFICATION)) {
					addRuleAppNotificationListener(objectName);
				} else if (notification.getType().equals(MBeanServerNotification.UNREGISTRATION_NOTIFICATION)) {
					removeRuleAppNotificationListener(objectName);
				}
			}
			if (objectName.getKeyProperty(Utils.TYPE).equals(IlrJMXRulesetMBean.VALUE_TYPE)) {
				if (notification.getType().equals(MBeanServerNotification.REGISTRATION_NOTIFICATION)) {
					addRuleSetNotificationListener(objectName);
				} else if (notification.getType().equals(MBeanServerNotification.UNREGISTRATION_NOTIFICATION)) {
					removeRuleSetNotificationListener(objectName);
				}
			}
		}
	}

	/**
	 * Register the RES notification listener on the RuleApp MBean
	 * Add an event in the RSS feed
	 */
	protected void addRuleAppNotificationListener(ObjectName objectName) {
		MBeanServer mbServer = Utils.getMBeanServer();
		try {
			mbServer.addNotificationListener(objectName, resListener, null, null);
			Utils.addEvent(Utils.RULEAPP_CREATED + Utils.getRuleAppDescription(objectName),
				Utils.getRuleAppDescription(objectName),
				Utils.getRuleAppLink(objectName));
			logger.info("RuleApp created --> Added a notification listener on --> " + objectName);
		} catch (InstanceNotFoundException e) {
			logger.severe(e.getMessage());
		}
	}

	/**
	 * Add an event in the RSS feed
	 */
	protected void removeRuleAppNotificationListener(ObjectName objectName) {
		Utils.addEvent(Utils.RULEAPP_DELETED + Utils.getRuleAppDescription(objectName),
			Utils.getRuleAppDescription(objectName),
			Utils.getRuleAppRemovedLink());
		logger.info("RuleApp removed --> " + objectName);
	}

	/**
	 * Register the RES notification listener on the Ruleset MBean
	 * Add an event in the RSS feed
	 */
	protected void addRuleSetNotificationListener(ObjectName objectName) {
		MBeanServer mbServer = Utils.getMBeanServer();
		try {
			mbServer.addNotificationListener(objectName, resListener, null, null);
			Utils.addEvent(Utils.RULESET_CREATED + Utils.getRulesetDescription(objectName),
				Utils.getRulesetDescription(objectName),
				Utils.getRulesetLink(objectName));
			logger.info("Ruleset created --> added a notification listener on --> " + objectName);
		} catch (InstanceNotFoundException e) {
			logger.severe(e.getMessage());
		}
	}

	/**
	 * Add an event in the RSS feed
	 */
	protected void removeRuleSetNotificationListener(ObjectName objectName) {
		Utils.addEvent(Utils.RULESET_DELETED + Utils.getRulesetDescription(objectName),
			Utils.getRulesetDescription(objectName),
			Utils.getRulesetRuleAppLink(objectName));
		logger.info("Ruleset removed --> " + objectName);
	}

}
