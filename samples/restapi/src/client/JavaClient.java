/*
 * Licensed Materials - Property of IBM
 * 5725-B69 5655-Y17 5655-Y31 5724-X98 5724-Y15 5655-V82 
 * Copyright IBM Corp. 1987, 2018. All Rights Reserved.
 *
 * Note to U.S. Government Users Restricted Rights: 
 * Use, duplication or disclosure restricted by GSA ADP Schedule 
 * Contract with IBM Corp.
 */
package client;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.MissingResourceException;
import java.util.ResourceBundle;

import org.apache.http.HttpEntity;
import org.apache.http.HttpHost;
import org.apache.http.HttpStatus;
import org.apache.http.auth.AuthScope;
import org.apache.http.auth.UsernamePasswordCredentials;
import org.apache.http.client.AuthCache;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.CredentialsProvider;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpDelete;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.methods.HttpPut;
import org.apache.http.client.methods.HttpUriRequest;
import org.apache.http.client.protocol.HttpClientContext;
import org.apache.http.entity.ByteArrayEntity;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.auth.BasicScheme;
import org.apache.http.impl.client.BasicAuthCache;
import org.apache.http.impl.client.BasicCredentialsProvider;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClientBuilder;

import com.ibm.json.java.JSONObject;

/**
 *  The JavaClient class defines an authenticated Java client to execute requests by using the REST API.
 *  Scenarios are predefined: to deploy a rule application, to execute a ruleset and to clean.
 *  Each scenario begins with a get request with a JSON response to test whether it can run.
 *  Each XML request is displayed in the console as the URL, the returned status, and the XML response.
 * 
 */
public class JavaClient {
	protected CloseableHttpClient m_client;
	protected HttpClientContext m_context;
	private String m_ruleappFile = "Miniloan.jar";
	private String m_ruleAppName = "Miniloan";
	private String m_xomName = "miniloan-xom.zip";
	private String m_libraryName = "Miniloan_1.0";
	private String m_host;
	private String m_port;

	/**
	 * This constructor defines the preemptive basic HTTP authentication.
	 */
	public JavaClient() {
		initProperties();
		HttpHost targetHost = new HttpHost(getServerName(), getServerPortNumber(), "http");
		CredentialsProvider credsProvider = new BasicCredentialsProvider();
		credsProvider.setCredentials(
				new AuthScope(targetHost.getHostName(), targetHost.getPort()),
				new UsernamePasswordCredentials("resAdmin", "resAdmin"));

		// Create AuthCache instance
		AuthCache authCache = new BasicAuthCache();
		// Generate BASIC scheme object and add it to the local auth cache
		BasicScheme basicAuth = new BasicScheme();
		authCache.put(targetHost, basicAuth);

		// Add AuthCache to the execution context
		this.m_context = HttpClientContext.create();
		this.m_context.setCredentialsProvider(credsProvider);
		this.m_context.setAuthCache(authCache);		

		this.m_client = HttpClientBuilder.create().build(); 
	}


	// --------------------- Run Scenarios Methods
	/*
	 * RuleApp scenario:  Purpose:
	 *        - Check whether the scenario runs 
	 *        - List all rule applications
	 *        - Deploy a new rule application 
	 *        - List all rule applications to show the new one 
	 *        - Modify the rule application 
	 *        - Show the modified rule application
	 */
	public void runDeployRuleAppScenario() {
		String check = canDeployRuleApp();
		if (check == null) {
			String urlRuleApps = getRestAuthenticatedUrl() + "/ruleapps";
			String urlRuleApp = getRestAuthenticatedUrl() + "/ruleapps/"
					+ m_ruleAppName + "/1.0";
			// Lists all rule applications
			System.out.println("** Lists all the RuleApps.");
			executeGetMethod(urlRuleApps);
			// Deploy a rule application
			System.out.println("** Deploys a RuleApp.");
			executePostMethod(urlRuleApps,  null, getFileAsByteArray(m_ruleappFile));
			// Lists all rule applications after they are created
			System.out.println("** Lists all the RuleApps.");
			executeGetMethod(urlRuleApps);
			// Updates a rule application
			System.out.println("** Updates a RuleApps.");
			String modifiedRuleAppBody = "<ruleApp><description>Miniloan generated with build command \n and deployed by REST API.</description></ruleApp>";
			executePutMethod(urlRuleApp, modifiedRuleAppBody);
			// Lists all rule applications after they are updated
			System.out.println("** Shows the modified RuleApp.");
			executeGetMethod(urlRuleApp);
		} else
			System.out.println(check);
	}


	/**
	 * 
	 * @return null when the scenario runs or a message that explains the error
	 */
	private String canDeployRuleApp() {
		String urlRuleApp = getRestAuthenticatedUrl() + "/ruleapps/"
				+ m_ruleAppName + "/1.0";
		JSONObject response = executeJSONGetMethod(urlRuleApp);
		if (response == null) {
			InputStream rulesetArchive = getClass().getResourceAsStream(
					"../data/" + m_ruleappFile);
			if (rulesetArchive == null) 
				return "Generate the ruleapp before running the ruleapp scenario";
			return null;
		} else			
			return "Removes the RuleApp " + m_ruleAppName
				+ " before running the ruleapp scenario";
	}

	/*
	 * Execute  scenario: Purpose
	 *                - Check whether the scenario runs 
	 *                 - Execute the ruleset with the given amount 
	 *                 - Print the result
	 */
	public void runExecuteScenario(String id, int amount) {
		String check = canExecute();
		if (check == null) {
			// Parameters  definitions
			String rulesetParams = "<par:Request xmlns:par=\"http://www.ibm.com/rules/decisionservice/Miniloan/Miniloan_ServiceRuleset/param\">"
					+ "<par:DecisionID>"
					+ id + "</par:DecisionID>" +
					"<par:borrower><name>Joe</name><creditScore>600</creditScore><yearlyIncome>80000</yearlyIncome></par:borrower>"
					+ "<par:loan><approved>true</approved><amount>"
					+ amount + "</amount><duration>240</duration><yearlyInterestRate>0.05</yearlyInterestRate></par:loan>"
					+ "</par:Request>";
			// Execute a ruleset
			System.out.println("** Executes a ruleset: ask for a loan of " + amount);
			executePostMethod(getExecutionServiceUrl(), rulesetParams, null);
		} else
			System.out.println(check);
	}

	/*
	 * JSON Execute  scenario: Purpose
	 *                - Check whether the scenario runs 
	 *                 - Execute the ruleset with the given amount 
	 *                 - Print the result
	 */
	public void runJSONExecuteScenario(String id, int amount) {
		String check = canExecute();
		if (check == null) {
			// Parameters  definitions
			JSONObject borrowerParams = new JSONObject();
			borrowerParams.put("name", "joe");
			borrowerParams.put("creditScore", "600");
			borrowerParams.put("yearlyIncome", "80000");
			JSONObject loanParams = new JSONObject();
			loanParams.put("approved", true);
			loanParams.put("amount", amount);
			loanParams.put("duration", 240);
			loanParams.put("yearlyInterestRate", 0.05);
			JSONObject rulesetParams = new JSONObject();
			rulesetParams.put("DecisionID", id);
			rulesetParams.put("loan", loanParams);
			rulesetParams.put("borrower", borrowerParams);
			// Execute a ruleset
			System.out.println("** Executes a ruleset: ask for a loan of " + amount);
			executeJSONPostMethod(getExecutionServiceUrl(), rulesetParams, null);
		} else
			System.out.println(check);
	}    

	private String canExecute() {
		if (canDeployRuleApp() == null) {
			return "First runs the deploy.ruleapp scenario";
		}
		return null;
	}


	/*
	 * Clean scenario: Purpose
	 *                - Check whether the scenario runs 
	 *                 - Remove the added rule application 
	 *                 - List all rule applications to show that the rule application has been removed 
	 *                 - Remove the added XOM 
	 *                 - List all XOMs to show the XOM that has been removed
	 *                 - Remove the added library
	 */
	public void runCleanScenario() {
		String check = canClean();
		if (check == null) {
			String urlRuleApps = getRestAuthenticatedUrl() + "/ruleapps";
			String urlRuleApp = getRestAuthenticatedUrl() + "/ruleapps/"
					+ m_ruleAppName + "/1.0";
			String urlXom = getRestAuthenticatedUrl() + "/xoms";
			String urlThisXom = getRestAuthenticatedUrl() + "/v1/xoms/"
					+ m_xomName;
			String urlThisLibrary = getRestAuthenticatedUrl() + "/libraries/"
					+ m_libraryName ;
			// Deletes the rule application
			System.out.println("** Deletes the RuleApp.");
			executeDeleteMethod(urlRuleApp);
			// Lists all rule applications
			System.out.println("** Lists all the RuleApps.");
			executeGetMethod(urlRuleApps);
			// Deletes the XOM
			System.out.println("** Deletes the XOM.");
			executeDeleteMethod(urlThisXom + "/1.0");
			// Lists the XOMs after a XOM has been removed
			System.out.println("** Lists the XOMs after XOM deletion.");
			executeGetMethod(urlXom);
			// Deletes the Libraries
			System.out.println("** Deletes the library.");
			executeDeleteMethod(urlThisLibrary + "/1.0");

		} else
			System.out.println(check);
	}

	private String canClean() {
		if (canDeployRuleApp() == null) {
			return "First runs the ruleapp scenario";
		}
		return null;
	}

	public void usage() {
		System.out.println("Usage: JavaClient <scenarioName> [amount] [id] where scenarioName is one of RuleApp, Execute or Clean");
		System.out.println("        amount is an optional argument of the execution to specify the amount of the asked loan");
		System.out.println("        id is an optional argument of the execution to specify the id of the decision");
	}

	/** Main */
	public static void main(String[] args) {
		// Initialization gives credentials
		JavaClient client = new JavaClient();
		if (args.length != 1 && args.length != 3)
			client.usage();
		String scenarioName = args[0];
		if (scenarioName.equals("RuleApp"))
			client.runDeployRuleAppScenario();
		if (scenarioName.equals("Execute")) {
			int amount = 50000;
			String id = "id";
			if (args.length == 3) {
				try {
					amount = Integer.parseInt(args[1]);
					id = args[2];
				}
				catch (Exception e) {
				}
			}
			client.runExecuteScenario(id, amount);
		}
		if (scenarioName.equals("ExecuteJSON")) {
			int amount = 50000;
			String id = "id";
			if (args.length == 3) {
				try {
					amount = Integer.parseInt(args[1]);
					id = args[2];
				}
				catch (Exception e) {
				}
			}
			client.runJSONExecuteScenario(id, amount);
		}
		if (scenarioName.equals("Clean"))
			client.runCleanScenario();
		client.closeHttpClient();
	}

	/** Utilities */
	/**
	 * Converts the contents of a file to a 64-bit string to be passed as the XML body
	 */
	protected String getFileAsEncodedString(String name) {
		byte[] array = getFileAsByteArray(name);
		return javax.xml.bind.DatatypeConverter.printBase64Binary(array);
	}
	
	/**
	 * Close HttpClient instance
	 */
	public void closeHttpClient(){
		if(m_client != null){
			try {
				m_client.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}

	protected byte[] getFileAsByteArray(String name) {
		try {
			InputStream rulesetArchive = getClass().getResourceAsStream(
					"../data/" + name);
			ByteArrayOutputStream output = new ByteArrayOutputStream();
			byte[] buffer = new byte[1024];
			int i = 0;
			try {
				while ((i = rulesetArchive.read(buffer)) != -1) {
					output.write(buffer, 0, i);
				}
				rulesetArchive.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
			return output.toByteArray();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * Get methods
	 */
	/*
	 * Builds the URL to the REST API with an existing authentication.
	 */
	protected String getRestAuthenticatedUrl() {
		return "http://" + getServerName() + ":" + getServerPort()
				+ "/res/apiauth";
	}

	protected String getExecutionServiceUrl() {
		return "http://" + getServerName() + ":" + getServerPort()
				+ "/DecisionService/rest/v1/Miniloan/1.0/Miniloan_ServiceRuleset/1.0";
	}

	protected String getServerName() {
		return m_host;
	}

	protected String getServerPort() {
		return m_port;
	}

	protected int getServerPortNumber() {
		return new Integer(getServerPort()).intValue();
	}
	/**
	 * Execution of HTTP methods 
	 */
	protected void executePutMethod(String url, String body) {

		HttpPut putMethod = new HttpPut(url);
		try {
			StringEntity params = new StringEntity(body, "UTF8");
			params.setContentType("text/xml");
			putMethod.setEntity(params);
		} catch (Exception e) {
			e.printStackTrace();
		}
		executeMethod(url, putMethod, false);
	}

	protected void executePostMethod(String url, String stringBody,
			byte[] byteBody) {
		HttpPost postMethod = new HttpPost(url);
		try {
			if(stringBody != null){
				StringEntity params = new StringEntity(stringBody, "UTF8");
				params.setContentType("text/xml");
				postMethod.setEntity(params);
			}
			else{
				ByteArrayEntity param = new ByteArrayEntity(byteBody);
				postMethod.setHeader("Content-Type", "application/octet-stream");
				postMethod.setEntity(param);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		executeMethod(url, postMethod, false);
	}

	protected void executeJSONPostMethod(String url, JSONObject jsonObj,
			byte[] byteBody) {
		HttpPost postMethod = new HttpPost(url);
		try {
			if (jsonObj != null){
				StringEntity params = new StringEntity(jsonObj.toString(), "UTF8");
				params.setContentType("application/json");
				postMethod.setEntity(params);
			}
			else{
				ByteArrayEntity param = new ByteArrayEntity(byteBody);
				postMethod.setEntity(param);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		executeMethod(url, postMethod, false);
	}

	protected void executeDeleteMethod(String url) {
		executeMethod(url, new HttpDelete(url), false);
	}

	protected void executeGetMethod(String url) {
		executeMethod(url, new HttpGet(url), false);
	}

	protected JSONObject executeJSONGetMethod(String url) {
		String jsonUrl = url + "?accept=json";
		return executeMethod(jsonUrl, new HttpGet(jsonUrl), true);
	}

	protected JSONObject executeMethod(String url, HttpUriRequest method,
			boolean json) {
		JSONObject responseObject = null;
		try {
			// Executes the method.
			CloseableHttpResponse response =  m_client.execute(method, m_context);
			try{
				int statusCode = response.getStatusLine().getStatusCode();
				if (statusCode != HttpStatus.SC_OK && statusCode != HttpStatus.SC_NO_CONTENT && statusCode != HttpStatus.SC_CREATED ) {
					System.err.println("Method failed: " + response.getStatusLine());
				}
				HttpEntity entity = response.getEntity();
				if(entity != null){
					InputStream stream = entity.getContent();
					if (json) {
						try {
							responseObject = JSONObject.parse(stream);
						} catch (Exception e) {
							// The stream does not contain any JSON object.
							responseObject = null;
						}
					} else{
						displayResponse(url, statusCode,
								getResponse(stream));
					}
				}
			}finally {
				response.close();
			}
		} catch (ClientProtocolException e) {
			System.err.println("Fatal protocol violation: " + e.getMessage());
			e.printStackTrace();
		} catch (IOException e) {
			System.err.println("Fatal transport error: " + e.getMessage());
			e.printStackTrace();
		} 
		return responseObject;
	}

	private String getResponse(InputStream stream) {
		int count = 0 ;
		ByteArrayOutputStream outputStream = new ByteArrayOutputStream() ;
		byte[] byteArray = new byte[1024];
		try {
			while((count = stream.read(byteArray, 0, byteArray.length)) > 0) {
				outputStream.write(byteArray, 0, count) ;
			}
			return new String(outputStream.toByteArray(), "UTF-8");
		} catch (IOException e) {
			e.printStackTrace();
			return "";
		}
	}

	/**
	 * Initialization of properties 
	 */
	private void initProperties() {
		try {
			ResourceBundle rb = ResourceBundle.getBundle("build");
			m_port = rb.getString("server.port");
			m_host = "localhost";
		} catch (MissingResourceException e) {
			System.out.println("No bundle found. Use the default port and host.");
			m_port = "9090";
			m_host = "localhost";
		}
	}

	protected void displayResponse(String url, int statusCode, String response) {
		System.out.println(">> URL " + url);
		System.out.println("<< RESPONSE - Status code " + statusCode + "\n");
		System.out.println(response);
	}

}
