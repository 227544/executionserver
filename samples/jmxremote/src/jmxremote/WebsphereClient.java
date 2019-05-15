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
import java.util.Properties;
import java.util.Set;

import javax.management.Attribute;
import javax.management.MalformedObjectNameException;
import javax.management.ObjectName;

import org.apache.log4j.Logger;

import com.ibm.websphere.management.AdminClient;
import com.ibm.websphere.management.AdminClientFactory;
import com.ibm.websphere.management.exception.ConnectorException;

public class WebsphereClient extends JmxRemoteImpl {
    private static final Logger LOG = Logger.getLogger(WebsphereClient.class);
    private static final String RES_MODEL_NAME = "WebSphere:type=IlrJMXRepository,*";

    private AdminClient connection;

    public class WebsphereHandler extends CommonHandler {
        private ObjectName objName;
        private AdminClient client;

        public WebsphereHandler(AdminClient client, ObjectName objName) {
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
     * @see jmxremote.JmxRemoteBase#createHandler(javax.management.ObjectName)
     */
    public InvocationHandler createHandler(ObjectName name) {
        return new WebsphereHandler(connection, name);
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
        } catch (ConnectorException e) {
            LOG.error(e);
        }

        return null;
    }

    /**
     * This method allow to instanciate a connection between the client and the
     * server. The properties used to connect to the server are stored in a
     * properties file.
     * @throws ConnectorException
     *          If the connection failed
     * @throws IOException
     *          If an IOException occurred
     */
    public void connect() throws ConnectorException, IOException {
        // Load a properties file that stored the server information need to
        // connect to the server
        Properties fileprops = new Properties();
        ClassLoader cl = this.getClass().getClassLoader();
        InputStream is = cl.getResourceAsStream("build.properties");
        fileprops.load(is);

        // WebSphere environment using SOAP connector
        Properties props = new Properties();
        props.setProperty(AdminClient.CONNECTOR_HOST, fileprops.getProperty("server.host"));
        props.setProperty(AdminClient.CONNECTOR_PORT, fileprops.getProperty("soap.connector.port"));
        props.setProperty(AdminClient.CONNECTOR_TYPE, AdminClient.CONNECTOR_TYPE_SOAP);

        // Required for secured connection
        props.setProperty(AdminClient.CONNECTOR_SECURITY_ENABLED, "true");
        props.setProperty(AdminClient.USERNAME, fileprops.getProperty("server.user"));
        props.setProperty(AdminClient.PASSWORD, fileprops.getProperty("server.password"));

        // connect
        connection = AdminClientFactory.createAdminClient(props);
        LOG.info("Server connected");
    }

    public static void main(String[] args) throws ConnectorException, IOException {
        WebsphereClient client = new WebsphereClient();
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
    }
}
