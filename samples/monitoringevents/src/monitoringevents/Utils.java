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

import java.util.ArrayList;
import java.util.Date;

import javax.management.MBeanServer;
import javax.management.MBeanServerFactory;
import javax.management.Notification;
import javax.management.ObjectName;

/**
 * Utils class to generate URLs and RSS messages
 */
public class Utils {


	public static String MBEANSERVER_OBJECTNAME = "JMImplementation:type=MBeanServerDelegate";
	public static String TYPE = "type";
	public static String RULEAPP_CREATED = "RuleApp created: ";
	public static String RULEAPP_DELETED = "RuleApp removed: ";
	public static String RULEAPP_MODIFIED = "RuleApp property modified: ";
	public static String RULESET_CREATED = "Ruleset created: ";
	public static String RULESET_DELETED = "Ruleset removed: ";
	public static String RULESET_MODIFIED = "Ruleset property modified: ";
	public static String RULESETARCHIVE_MODIFIED = "Ruleset archive modified: ";

	/**
	 * The object in charge of
	 *    maintaining in memory the RSS items
	 *    Read the items from the file when the server starts
	 *    Write items to the file when the server shutdowns
	 */
	public static RSSHelper rssHelper = null;

	/**
	 * Initialize the helper
	 */
	static {
		rssHelper = new RSSHelper();
}

	/**
	 * Find the MBean Server object
	 */
	public static MBeanServer getMBeanServer() {
		ArrayList<?> mbList = MBeanServerFactory.findMBeanServer(null);
		if (mbList.size() != 0)
			return (MBeanServer) mbList.get(0);
		else
			return (MBeanServer) MBeanServerFactory.createMBeanServer();
	}

	/**
	 * Add an events to the RSS feed
	 */
	public static void addEvent(String title, String description, String url) {
		rssHelper.createEntry(title, url, new Date(), description);
	}

	/**
	 * Get the permalink to the RES Home page
	 */
	public static String getRuleAppRemovedLink() {
		StringBuffer link = new StringBuffer();
		link.append(rssHelper.getRESHomeLink());
		link.append("?newsid=");
		link.append(System.currentTimeMillis());
		return link.toString();
	}

	/**
	 * Get the permalink to the RuleApp
	 */
	public static String getRuleAppLink(ObjectName objectName) {
		StringBuffer link = new StringBuffer();
		link.append(rssHelper.getRESHomeLink());
		link.append("/protected/viewRuleApp.jsf?ruleappname=");
		link.append(objectName.getKeyProperty(IlrJMXRuleAppMBean.KEY_NAME));
		link.append("&ruleappversion=");
		link.append(objectName.getKeyProperty(IlrJMXRuleAppMBean.KEY_VERSION));
		link.append("&newsid=");
		link.append(System.currentTimeMillis());
		return link.toString();
	}

	/**
	 * Get the permalink to the Ruleset
	 */
	public static String getRulesetLink(ObjectName objectName) {
		StringBuffer link = new StringBuffer();
		link.append(rssHelper.getRESHomeLink());
		link.append("/protected/viewRuleset.jsf?ruleappname=");
		link.append(objectName.getKeyProperty(IlrJMXRulesetMBean.KEY_RULEAPP_NAME));
		link.append("&ruleappversion=");
		link.append(objectName.getKeyProperty(IlrJMXRulesetMBean.KEY_RULEAPP_VERSION));
		link.append("&rulesetname=");
		link.append(objectName.getKeyProperty(IlrJMXRulesetMBean.KEY_NAME));
		link.append("&rulesetversion=");
		link.append(objectName.getKeyProperty(IlrJMXRulesetMBean.KEY_VERSION));
		link.append("&newsid=");
		link.append(System.currentTimeMillis());
		return link.toString();
	}

	/**
	 * Get the permalink to the RuleApp containg this Ruleset
	 */
	public static String getRulesetRuleAppLink(ObjectName objectName) {
		StringBuffer link = new StringBuffer();
		link.append(rssHelper.getRESHomeLink());
		link.append("/protected/viewRuleApp.jsf?ruleappname=");
		link.append(objectName.getKeyProperty(IlrJMXRulesetMBean.KEY_RULEAPP_NAME));
		link.append("&ruleappversion=");
		link.append(objectName.getKeyProperty(IlrJMXRulesetMBean.KEY_RULEAPP_VERSION));
		link.append("&newsid=");
		link.append(System.currentTimeMillis());
		return link.toString();
	}

	/**
	 * Get the RuleApp description message
	 */
	public static String getRuleAppDescription(ObjectName objectName) {
		StringBuffer description = new StringBuffer();
		description.append("/");
		description.append(objectName.getKeyProperty(IlrJMXRuleAppMBean.KEY_NAME));
		description.append("/");
		description.append(objectName.getKeyProperty(IlrJMXRuleAppMBean.KEY_VERSION));
		return description.toString();
	}

	/**
	 * Get the Ruleset description message
	 */
	public static String getRulesetDescription(ObjectName objectName) {
		StringBuffer description = new StringBuffer();
		description.append("/");
		description.append(objectName.getKeyProperty(IlrJMXRulesetMBean.KEY_RULEAPP_NAME));
		description.append("/");
		description.append(objectName.getKeyProperty(IlrJMXRulesetMBean.KEY_RULEAPP_VERSION));
		description.append("/");
		description.append(objectName.getKeyProperty(IlrJMXRulesetMBean.KEY_NAME));
		description.append("/");
		description.append(objectName.getKeyProperty(IlrJMXRulesetMBean.KEY_VERSION));
		return description.toString();
	}

	/**
	 * Get the RuleApp description message on property change
	 */
	public static String getRuleAppPropertyChangeMessage(ObjectName objectName, Notification notification) {
		StringBuffer message = new StringBuffer();
		message.append(getRuleAppDescription(objectName));
		message.append(" - ");
		if (notification.getUserData() != null) {
			message.append("property: ");
			message.append(notification.getMessage());
			message.append(" ; value: ");
			message.append((String) notification.getUserData());
		} else {
			message.append("property: ");
			message.append(notification.getMessage());
			message.append(" removed");
		}
		return message.toString();
	}

	/**
	 * Get the Ruleset description message on property change
	 */
	public static String getRulesetPropertyChangeMessage(ObjectName objectName, Notification notification) {
		StringBuffer message = new StringBuffer();
		message.append(getRulesetDescription(objectName));
		message.append(" - ");
		if (notification.getUserData() != null) {
			message.append("property: ");
			message.append(notification.getMessage());
			message.append(" ; value: ");
			message.append((String) notification.getUserData());
		} else {
			message.append("property: ");
			message.append(notification.getMessage());
			message.append(" removed");
		}
		return message.toString();
	}



}
