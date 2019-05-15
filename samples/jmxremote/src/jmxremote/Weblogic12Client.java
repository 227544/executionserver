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
import java.io.InputStream;
import java.lang.reflect.InvocationHandler;
import java.util.Hashtable;
import java.util.Properties;
import java.util.Set;

import javax.management.Attribute;
import javax.management.MBeanServerConnection;
import javax.management.MalformedObjectNameException;
import javax.management.ObjectName;
import javax.management.remote.JMXConnector;
import javax.management.remote.JMXConnectorFactory;
import javax.management.remote.JMXServiceURL;
import javax.naming.Context;

import org.apache.log4j.Logger;

public class Weblogic12Client extends JmxRemoteImpl {
    private static final Logger LOG = Logger.getLogger(Weblogic12Client.class);
    private static final String RES_MODEL_NAME = "RES:Type=IlrJMXRepository,*";
    private JMXConnector connector;
    private MBeanServerConnection connection;

    public class WeblogicHandler extends CommonHandler {
        private ObjectName objName;
        private MBeanServerConnection client;

        public WeblogicHandler(MBeanServerConnection client, ObjectName objName) {
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
        public Object invoke(String methodName, Object[] args, String[] parameters) throws Exception {
            return client.invoke(objName, methodName, args, parameters);
        }
    }

    /**
     * @see jmxremote.JmxRemoteImpl#createHandler(javax.management.ObjectName)
     */
    public InvocationHandler createHandler(ObjectName name) {
        return new WeblogicHandler(connection, name);
    }

    /**
     * @see jmxremote.JmxRemoteImpl#getModelMBeanName()
     */
    @SuppressWarnings("unchecked")
	public ObjectName getModelMBeanName() {
        try {
            //Query the name of MBeans of type IlrBresModel
            Set mBeans = connection.queryNames(new ObjectName(RES_MODEL_NAME), null);

            //Getting the BresMbeanName
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
     * @throws IOException
     *          If the connection failed
     */
    @SuppressWarnings("unchecked")
    public void connect() throws IOException {
        // Load a properties file that stored the server information need to
        // connect to the server
        Properties fileprops = new Properties();
        ClassLoader cl = this.getClass().getClassLoader();
        InputStream is = cl.getResourceAsStream("build.properties");
        fileprops.load(is);

        String url = "service:jmx:" + fileprops.getProperty("server.url")
                     + "/jndi/weblogic.management.mbeanservers.runtime";
        JMXServiceURL serviceURL = new JMXServiceURL(url);

        Hashtable h = new Hashtable();
        h.put(Context.SECURITY_PRINCIPAL, fileprops.getProperty("server.user"));
        h.put(Context.SECURITY_CREDENTIALS, fileprops.getProperty("server.password"));
        h.put(JMXConnectorFactory.PROTOCOL_PROVIDER_PACKAGES, "weblogic.management.remote");
		connector = JMXConnectorFactory.connect(serviceURL, h);
        connection = connector.getMBeanServerConnection();
        
        LOG.info("Server connected");
    }

    /**
     * This method allow to close the connection between the client and the
     * server.
     * @throws IOException
     *          If an IOException occurred
     */
    public void disconnect() throws IOException {
        connector.close();
    }

    public static void main(String[] args) throws IOException {
        Weblogic12Client client = new Weblogic12Client();
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
