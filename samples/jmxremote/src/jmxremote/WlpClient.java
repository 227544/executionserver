/*
 * Licensed Materials - Property of IBM
 * 5725-B69 5655-Y17 5655-Y31 5724-X98 5724-Y15 5655-V82 
 * Copyright IBM Corp. 1987, 2018. All Rights Reserved.
 *
 * Note to U.S. Government Users Restricted Rights: 
 * Use, duplication or disclosure restricted by GSA ADP Schedule 
 * Contract with IBM Corp.
 */

package jmxremote;

import java.io.File;
import java.io.IOException;
import java.lang.reflect.InvocationHandler;
import java.util.HashMap;
import java.util.Set;

import javax.management.Attribute;
import javax.management.MBeanServerConnection;
import javax.management.MalformedObjectNameException;
import javax.management.ObjectName;
import javax.management.remote.JMXConnector;
import javax.management.remote.JMXConnectorFactory;
import javax.management.remote.JMXServiceURL;

import org.apache.log4j.Logger;

public class WlpClient extends JmxRemoteImpl {
	private static final Logger LOG = Logger.getLogger(WlpClient.class);
	private static final String RES_MODEL_NAME = "RES:type=IlrJMXRepository";
	private JMXConnector connector;
	private MBeanServerConnection connection;

	public class LibertyHandler extends CommonHandler {
		private ObjectName objName;
		private MBeanServerConnection client;

		public LibertyHandler(MBeanServerConnection client, ObjectName objName) {
			this.objName = objName;
			this.client = client;
		}

		/**
		 * @see jmxremote.CommonHandler#getAttribute(java.lang.String)
		 */
		public Object getAttribute(String attributeName) throws Exception {
			return client.getAttribute(objName, attributeName);
		}

		/**
		 * @see jmxremote.CommonHandler#setAttribute(javax.management.Attribute)
		 */
		public void setAttribute(Attribute attr) throws Exception {
			client.setAttribute(objName, attr);
		}

		/**
		 * @see jmxremote.CommonHandler#invoke(java.lang.String,
		 *      java.lang.Object[], java.lang.String[])
		 */
		public Object invoke(String methodName, Object[] args,
				String[] parameters) throws Exception {
			return client.invoke(objName, methodName, args, parameters);
		}
	}

	/**
	 * @see jmxremote.JmxRemoteImpl#createHandler(javax.management.ObjectName)
	 */
	public InvocationHandler createHandler(ObjectName name) {
		return new LibertyHandler(connection, name);
	}

	/**
	 * @see jmxremote.JmxRemoteImpl#getModelMBeanName()
	 */
	@SuppressWarnings("unchecked")
	public ObjectName getModelMBeanName() {
		try {
			// Query the name of MBeans of type IlrBresModel
			Set mBeans = connection.queryNames(new ObjectName(RES_MODEL_NAME),
					null);

			// Getting the BresMbeanName
			if (mBeans.iterator().hasNext())
				return (ObjectName) mBeans.iterator().next();
		} catch (MalformedObjectNameException e) {
			LOG.error(e);
		} catch (IOException e) {
			LOG.error(e);
		}

		return null;
	}

	/**
	 * This method allow to instanciate a connection between the client and the
	 * server.
	 * 
	 * @throws IOException
	 *             If the connection failed
	 */
	public void connect() throws IOException {
		String wlp_server_config_dir = System.getProperty("wlp.server.config.dir");
		
		System.setProperty("javax.net.ssl.trustStore", wlp_server_config_dir + "/resources/security/key.jks");
		System.setProperty("javax.net.ssl.trustStorePassword", "odmAdmin");
		try {
			HashMap<String, Object> environment = new HashMap<String, Object>();
			environment.put("jmx.remote.protocol.provider.pkgs", "com.ibm.ws.jmx.connector.client");
			environment.put(JMXConnector.CREDENTIALS, new String[] { "resAdmin", "resAdmin" });

			JMXServiceURL url = new JMXServiceURL("service:jmx:rest://localhost:9443/IBMJMXConnectorREST");
			connector = JMXConnectorFactory.newJMXConnector(url, environment);
			connector.connect();
			connection = connector.getMBeanServerConnection();

			LOG.info("Server connected");
		} catch (Throwable t) {
			t.printStackTrace();
		}
	}

	/**
	 * This method allow to close the connection between the client and the
	 * server.
	 * 
	 * @throws IOException
	 *             If an IOException occurred
	 */
	public void disconnect() throws IOException {
		connector.close();
	}

	public static void main(String[] args) throws IOException {
		WlpClient client = new WlpClient();
		client.connect();

		if (args.length == 1 && args[0].equalsIgnoreCase("-displayall")) {
			client.displayResContent();
		} else {
			// Upload the ruleapp archive
			Object objectName = client.deployRuleapp(new File(JMXSAMPLERULEAPPFILE));
			if (objectName == null)
				LOG.error("Cannot deploy the ruleapp " + JMXSAMPLERULEAPPFILE);
			else {
				// Check the ruleset status
				client.checkStatusDate();
				// Display the modified ruleapp archive in the server
				client.displayRuleAppContent(client.getJmxRuleappSample());
			}
		}

		client.disconnect();
	}
}