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

import java.io.IOException;
import java.util.Iterator;
import java.util.Set;

import javax.management.InstanceNotFoundException;
import javax.management.ListenerNotFoundException;
import javax.management.MBeanServer;
import javax.management.MalformedObjectNameException;
import javax.management.ObjectName;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.util.logging.Logger;

import com.sun.syndication.io.FeedException;

/**
 * Servlet context listener
 */
public class EventsContextListener implements ServletContextListener {

	private final static Logger logger = Logger.getLogger(EventsContextListener.class.getName());

	protected ServerNotificationListener serverListener;

	/**
	 * Load the RSS backup
	 * Add notification listeners on the MBean server and existing RuleApp/Ruleset MBeans
	 */
	public void contextInitialized(ServletContextEvent contextEvent) {
		try {
			// load the RSS backup
			Utils.rssHelper.load();
		} catch (IllegalArgumentException e) {
			logger.severe(e.getMessage());
		} catch (FeedException e) {
			logger.severe(e.getMessage());
		} catch (IOException e) {
			logger.severe(e.getMessage());
		}
		MBeanServer mbServer = Utils.getMBeanServer();
		try {
			// add a notification listener on the MBean Server
			// the ServerNotificationFilter class filters the notifications to keep only the RES ones
			serverListener = new ServerNotificationListener();
			mbServer.addNotificationListener(new ObjectName(Utils.MBEANSERVER_OBJECTNAME), serverListener, new ServerNotificationFilter(), null);
			logger.info("MBeanServer notification listener added");
			// query the MBean Server to get existing RuleApp mbeans
			Set<?> set = mbServer.queryNames(new ObjectName("RES:type=" + IlrJMXRuleAppMBean.VALUE_TYPE + ",*"), null);
			Iterator<?> it = set.iterator();
			// register the RES listener on each RuleApp MBean
			while(it.hasNext()) {
				ObjectName raObjectName = (ObjectName) it.next();
				mbServer.addNotificationListener(raObjectName, serverListener.resListener, null, null);
				logger.info("Added a notification listener on existing MBean --> " + raObjectName);
			}
			// query the MBean Server to get existing Ruleset mbeans
			set = mbServer.queryNames(new ObjectName("RES:type=" + IlrJMXRulesetMBean.VALUE_TYPE + ",*"), null);
			it = set.iterator();
			// register the RES listener on each Ruleset MBean
			while(it.hasNext()) {
				ObjectName rsObjectName = (ObjectName) it.next();
				mbServer.addNotificationListener(rsObjectName, serverListener.resListener, null, null);
				logger.info("Added a notification listener on existing MBean --> " + rsObjectName);
			}
		} catch (InstanceNotFoundException e) {
			logger.severe(e.getMessage());
		} catch (MalformedObjectNameException e) {
			logger.severe(e.getMessage());
		} catch (NullPointerException e) {
			logger.severe(e.getMessage());;
		}
	}

	/**
	 * Remove the MBean server notification listener
	 */
	public void contextDestroyed(ServletContextEvent contextEvent) {
		try {
			Utils.rssHelper.save();
		} catch (IOException e) {
			logger.severe(e.getMessage());
		} catch (FeedException e) {
			logger.severe(e.getMessage());
		}
		MBeanServer mbServer = Utils.getMBeanServer();
		try {
			mbServer.removeNotificationListener(new ObjectName("JMImplementation:type=MBeanServerDelegate"), serverListener);
			logger.info("MBeanServer notification listener removed");
		} catch (InstanceNotFoundException e) {
			logger.severe(e.getMessage());
		} catch (ListenerNotFoundException e) {
			logger.severe(e.getMessage());
		} catch (MalformedObjectNameException e) {
			logger.severe(e.getMessage());
		} catch (NullPointerException e) {
			logger.severe(e.getMessage());
		}
	}

}
