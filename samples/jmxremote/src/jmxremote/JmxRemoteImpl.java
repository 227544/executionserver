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

import ilog.rules.res.model.mbean.IlrJMXRepositoryMBean;
import ilog.rules.res.model.mbean.IlrJMXRuleAppMBean;
import ilog.rules.res.model.mbean.IlrJMXRulesetMBean;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Proxy;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

import javax.management.ObjectName;
import javax.management.OperationsException;

import org.apache.log4j.Logger;

/**
* This class allow to access the model.
*/
public abstract class JmxRemoteImpl {
   private static final Logger LOG = Logger.getLogger(JmxRemoteImpl.class);

   protected static final String JMXSAMPLERULEAPPFILE = "../data/JmxRemoteSample.jar";
   private static final String JMXRULEAPPSAMPLENAME = "JmxRemoteSample";
   

   public abstract InvocationHandler createHandler(ObjectName name);

   /**
    * Get the first occurrence of the Execution Server Model MBean found in the
    * server.
    * @return The first occurrence of the Execution Server Model MBean found
    *         in the server.
    */
   public abstract ObjectName getModelMBeanName();


   /**
    * Return the IlrJMXRepositoryMBean interface which is the entry point 
    * for the Rule Execution Server management model. The Rule Execution 
    * Server model allows you to create, list, and remove RuleApps.
    * It also provides some facilities for processing and retrieving RuleApp
    * Archives.
    * 
    * @return The IlrJMXRepositoryMBean.
    */
   public IlrJMXRepositoryMBean createJMXRepository(){
        ObjectName modelmbean = getModelMBeanName();
        if (modelmbean == null) {
            LOG.error("Couldn't find the Execution Server Model MBean. Verify you have deployed correctly the Execution server console");
            return null;
        }
        return (IlrJMXRepositoryMBean) Proxy.newProxyInstance(IlrJMXRepositoryMBean.class.getClassLoader(),
                                                              new Class[] {IlrJMXRepositoryMBean.class},
                                                              createHandler(modelmbean));
   }

   /**
    * Get a Rule Application deployed in the Rule Execution Server. The
    * IlrJmxRuleAppMBean interface allow to manage a Rule Application of the
    * Rule Execution Server.
    *
    * @see java.lang.reflect.Proxy Allow to hide method invocation of the MBean
    *      throw the Proxy class.
    *
    * @param ruleappMBeanName
    *            The RuleApp to find.
    * @return The Ruleapp found.
    */
   public IlrJMXRuleAppMBean getRuleAppMBean(ObjectName ruleappMBeanName) {
       return (IlrJMXRuleAppMBean) Proxy.newProxyInstance(IlrJMXRuleAppMBean.class.getClassLoader(),
                                                          new Class[] { IlrJMXRuleAppMBean.class },
                                                          createHandler(ruleappMBeanName));

   }

   /**
    * Get a Ruleset Archive deployed in the Rule Execution Server. The
    * IlrJmxRulesetMBean is the interface of the management bean for each
    * ruleset of the BRE Server management model.
    *
    * @param rulesetMBeanName:
    *            The ruleset name to find.
    * @return The ruleset found.
    */
   public IlrJMXRulesetMBean getRulesetMBean(ObjectName rulesetMBeanName) {
       return (IlrJMXRulesetMBean) Proxy.newProxyInstance(IlrJMXRulesetMBean.class.getClassLoader(),
                                                          new Class[] { IlrJMXRulesetMBean.class },
                                                          createHandler(rulesetMBeanName));

   }
   

   /**
    * Get the Rule Application associated with Jmx remote sample
    *
    * @return The Rule Application associated with Jmx remote sample.
    */
   public IlrJMXRuleAppMBean getJmxRuleappSample() {
       IlrJMXRepositoryMBean repository = createJMXRepository();

       if (repository != null) {
           ObjectName objectName = repository.getGreatestRuleAppObjectName(JMXRULEAPPSAMPLENAME);
           if (objectName != null)
               return getRuleAppMBean(objectName);
       }

       return null;
   }

   /**
    * This method allow to enable the ruleset status if the [effective date] <
    * current date < [expiration date] The effective date and expiration date
    * are properties associated to the ruleset.
    */
   public void checkStatusDate() {
       IlrJMXRuleAppMBean ruleapp = getJmxRuleappSample();
       if (ruleapp == null) {
           LOG.error("Cannot find ruleapp " + JMXRULEAPPSAMPLENAME + " in the server");
           return;
       }

       Iterator<ObjectName> itrs = ruleapp.getRulesetObjectNames().iterator();
       while (itrs.hasNext()) {
           ObjectName objrsname = itrs.next();
           IlrJMXRulesetMBean ruleset = getRulesetMBean(objrsname);

           try {
               DateFormat formatter = new SimpleDateFormat("MM/dd/yyyy");

               Date effectiveDate = formatter.parse(ruleset.getProperty("effectiveDate"));
               Date expirationDate = formatter.parse(ruleset.getProperty("expirationDate"));

               // Set an hard coded date so that the sample always works
               // In a real word we should have coded
               //      Date currentDate = new Date();
				Date currentDate = formatter.parse("02/06/2016");

               if ((currentDate.compareTo(effectiveDate) < 0 || currentDate.compareTo(expirationDate) > 0)
                   && ruleset.getStatus().equalsIgnoreCase("enabled")) {
                   LOG.info("Change the ruleset "
                            + ruleset.getName()
                            + " / "
                            + ruleset.getVersion()
                            + " status to disabled.");
                   LOG.info("  Reason: ");
                   if (currentDate.compareTo(expirationDate) > 0) {
                       LOG.info("The ruleset validity has expired. (Expiration date = "
                                + formatter.format(expirationDate)
                                + ")");
                   }
                   if (currentDate.compareTo(effectiveDate) < 0) {
                       LOG.info("The ruleset is not available at this time. Wait until  "
                                + formatter.format(effectiveDate));
                   }
                   ruleset.setStatus("disabled");
               } else if ((currentDate.compareTo(effectiveDate) > 0 || currentDate.compareTo(expirationDate) < 0
                                                                       && ruleset.getStatus()
                                                                                 .equalsIgnoreCase("disabled"))) {
                   LOG.info("Change the ruleset "
                            + ruleset.getName()
                            + " / "
                            + ruleset.getVersion()
                            + " status to enabled.");
                   LOG.info("  Reason: ");
                   LOG.info("The ruleset is available from "
                            + formatter.format(effectiveDate)
                            + " to "
                            + formatter.format(expirationDate));
                   ruleset.setStatus("enabled");
               }
           } catch (OperationsException e) {
               LOG.error(e);
           } catch (ParseException e) {
               LOG.error(e);
           }
       }
   }

   /**
    * This utility target allow to deploy a ruleapp in the Rule Execution
    * Server console.
    *
    * @param ruleappFile
    *            The Rule Application archive to upload
    * @return
    *            The ObjectName of the Rule Application deployed
    */
   @SuppressWarnings("rawtypes")
   public ObjectName deployRuleapp(File ruleappFile) {
       IlrJMXRepositoryMBean repository = createJMXRepository();
       if(repository == null)
           return null;

       try {
           byte[] contentRuleapp = getContentOfRuleAppArchive(ruleappFile);

           Set importedRuleapp = repository.importRuleApps(contentRuleapp,
                                                      "REPLACE_MERGING_POLICY",
                                                      "MAJOR_VERSION_POLICY");

           Iterator it = importedRuleapp.iterator();
           if (it.hasNext())
               return ((ObjectName) it.next());
       } catch (OperationsException e) {
           LOG.error(e);
       } catch (IOException e) {
           LOG.error(e);
       }
       return null;
   }

   /**
    * This method allow to display the RuleApp contains in the Rule Execution
    * Server.
    */
   public void displayResContent() {
       IlrJMXRepositoryMBean repository = createJMXRepository();
       if (repository != null) {
           // Iterate on the ruleapp list
           Iterator<ObjectName> it = repository.getRuleAppObjectNames().iterator();
           while (it.hasNext()) {
               ObjectName objname = (ObjectName) it.next();

               IlrJMXRuleAppMBean ruleapp = getRuleAppMBean(objname);
               displayRuleAppContent(ruleapp);
           }
       }
   }

   /**
    * Allow to display a RuleApp deployed in the Rule Execution Server
    * console.
    *
    * @param ruleapp
    *            The RuleApp to display.
    */
   @SuppressWarnings("rawtypes")
	public void displayRuleAppContent(IlrJMXRuleAppMBean ruleapp) {
       try {
           LOG.info("--------------------------------------");
           LOG.info("--+ Ruleapp: " + ruleapp.getName() + " / " + ruleapp.getVersion());
           if (ruleapp.getDescription() != null)
               LOG.info("----- Description: " + ruleapp.getDescription());
           if (ruleapp.getDisplayName() != null)
               LOG.info("----- Display Name: " + ruleapp.getDisplayName());
           LOG.info("----- Creation Date: " + new Date(ruleapp.getCreationDate()));

           if (ruleapp.getProperties().size() != 0) {
               LOG.info("----+ Properties:");
               for (Iterator it = ruleapp.getProperties().entrySet().iterator(); it.hasNext();) {
                   Map.Entry entry = (Map.Entry) it.next();
                   LOG.info("------- " + entry.getKey() + " = " + entry.getValue());
               }
           }
           // iterate on the ruleset list
           Iterator itrs = ruleapp.getRulesetObjectNames().iterator();
           while (itrs.hasNext()) {
               ObjectName objrsname = (ObjectName) itrs.next();
               IlrJMXRulesetMBean ruleset = getRulesetMBean(objrsname);
               displayRulesetContent(ruleset);
           }
       } catch (OperationsException e) {
           LOG.error(e);
       }
   }

   /**
    * Allow to display a Ruleset deployed in the Rule Execution Server
    * console.
    *
    * @param ruleset
    *            The Ruleset to display.
    */
   @SuppressWarnings("rawtypes")
	public void displayRulesetContent(IlrJMXRulesetMBean ruleset) {
       try {
           LOG.info("----+ Ruleset: " + ruleset.getName() + " / " + ruleset.getVersion());
           LOG.info("------- Creation Date: " + new Date(ruleset.getCreationDate()));

           if (ruleset.getDescription() != null)
               LOG.info("------- Description: " + ruleset.getDescription());
           if (ruleset.getDisplayName() != null)
               LOG.info("------- Display name: " + ruleset.getDisplayName());
           LOG.info("------- Ruleset Path: " + ruleset.getCanonicalRulesetPath());
           LOG.info("------- Execute Count: " + ruleset.getExecuteCount());

           if (ruleset.getProperties().size() != 0) {
               LOG.info("------+ Properties:");
               for (Iterator it = ruleset.getProperties().entrySet().iterator(); it.hasNext();) {
                   Map.Entry entry = (Map.Entry) it.next();
                   LOG.info("--------- " + entry.getKey() + " = " + entry.getValue());
               }
           }
       } catch (OperationsException e) {
           LOG.error(e);
       }
   }

   /**
    * Read a ruleapp archive and put it in byte array.
    *
    * @param jarFileName:
    *            The RuleApp archive to read
    * @return The byte array.
    */
   private byte[] getContentOfRuleAppArchive(File jarFileName) throws IOException {
       ByteArrayOutputStream jarContent = new ByteArrayOutputStream();
       FileInputStream is = null;
       try {
           is = new FileInputStream(jarFileName);

           byte[] buffer = new byte[1024];
           int i = 0;
           while ((i = is.read(buffer)) != -1) {
               jarContent.write(buffer, 0, i);
           }
       } finally {
           if (is != null)
               is.close();
       }

       return jarContent.toByteArray();
   }
}
