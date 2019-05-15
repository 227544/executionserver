/*
* Licensed Materials - Property of IBM
* 5725-B69 5655-Y17 5655-Y31 5724-X98 5724-Y15 5655-V82 
* Copyright IBM Corp. 1987, 2018. All Rights Reserved.
*
* Note to U.S. Government Users Restricted Rights: 
* Use, duplication or disclosure restricted by GSA ADP Schedule 
* Contract with IBM Corp.
*/

package j2serulesession;

import ilog.rules.res.model.IlrPath;
import ilog.rules.res.session.IlrJ2SESessionFactory;
import ilog.rules.res.session.IlrSessionCreationException;
import ilog.rules.res.session.IlrSessionException;
import ilog.rules.res.session.IlrSessionRequest;
import ilog.rules.res.session.IlrSessionResponse;
import ilog.rules.res.session.IlrStatelessSession;

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

import loan.Borrower;
import loan.LoanRequest;
import loan.Report;

import com.ibm.rules.engine.load.EngineLoader;
import com.ibm.rules.engine.runtime.Engine;
import com.ibm.rules.engine.runtime.EngineDefinition;
import com.ibm.rules.engine.runtime.EngineOutput;

public class ExecuteRuleset {
	private IlrJ2SESessionFactory factory;
	private IlrStatelessSession session;
	private String rulesetPath = "/test_deployment/loan_validation_with_score_and_grade";

	
	public void testRulesetWithSession() throws Exception {
		try {
			init();
			// Create a session request object
			IlrSessionRequest sessionRequest = factory.createRequest();
			sessionRequest.setRulesetPath(IlrPath.parsePath(rulesetPath));
			// Ensure latest version of the ruleset is taken into account
			sessionRequest.setForceUptodate(true);
			// Set the input parameters for the execution of the rules
			Map<String, Object> inputParameters = new HashMap<String, Object>();
			inputParameters.put("borrower", getBorrower());
			inputParameters.put("loan", getLoan());
			sessionRequest.setInputParameters(inputParameters);
			// Execute rules
			IlrSessionResponse sessionResponse = this.session.execute(sessionRequest);
			// Display the report
			Report report = (Report)(sessionResponse.getOutputParameters().get("report"));
			System.out.println(report.toString());
		} catch (IlrSessionException rse) {
			rse.printStackTrace();
		}
	}

	// Utilities
	
	protected void init() throws IOException {
		// Instantiate a loggerPrinter.
		FileOutputStream outFile = new FileOutputStream("execution.log");
		PrintWriter loggerPrinter = new PrintWriter(outFile);
		try {
			// Build a J2SE rule session factory that uses the loggerPrinter
			this.factory = new IlrJ2SESessionFactory(loggerPrinter);
			// Create the stateless rule session.
			this.session = factory.createStatelessSession();
		} catch (IlrSessionCreationException e) {
			
		}
	}
	
	public static void main(String args[]) throws Exception {
		ExecuteRuleset test = new ExecuteRuleset();
		test.testRulesetWithSession();
		// Direct engine execution
		// test.testRulesetWithEngine();
	}	
	
	private Borrower getBorrower() {
		java.util.Date birthDate = loan.DateUtil.makeDate(1950, 1, 1);
		loan.Borrower borrower = new loan.Borrower("Smith", "John", birthDate,
				"123121234");
		borrower.setZipCode("12345");
		borrower.setCreditScore(200);
		borrower.setYearlyIncome(20000);
		return borrower;
	}

	private LoanRequest getLoan() {
		java.util.Date loanDate = new java.util.Date();
		loan.LoanRequest loan = new loan.LoanRequest(loanDate, 48, 100000, 1.2);
		return loan;
	}
	
	private String rulesetname = "loan_validation_with_score_and_grade.dsar";

	public void testRulesetWithEngine() throws Exception {
		InputStream rulesetStream = this.getClass().getResourceAsStream(rulesetname);
		EngineLoader loader = new EngineLoader(rulesetStream, null);
		EngineDefinition def = loader.load();
		Engine engine = def.createEngine();

		Map<String, Object> inputParams = new HashMap<String, Object>();
		inputParams.put("borrower", getBorrower());
		inputParams.put("loan", getLoan());

		System.out.println("exec:");
		EngineOutput output = engine.execute(inputParams);
		Report report = (Report) output.getParameter("report");
		System.out.println(report.toString());

		rulesetStream.close();
	}

}
