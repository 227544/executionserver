/*
* Licensed Materials - Property of IBM
* 5725-B69 5655-Y17 5655-Y31 5724-X98 5724-Y15 5655-V82 
* Copyright IBM Corp. 1987, 2018. All Rights Reserved.
*
* Note to U.S. Government Users Restricted Rights: 
* Use, duplication or disclosure restricted by GSA ADP Schedule 
* Contract with IBM Corp.
*/

package loan;

import java.text.MessageFormat;
import java.util.Date;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;

@XmlAccessorType(XmlAccessType.FIELD)
public class Loan extends LoanUtil implements java.io.Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 7356529391378635986L;

	//Fields
	@XmlElement	
	private int numberOfMonthlyPayments;
	@XmlElement	
	private Date startDate;
	@XmlElement	
	private int amount;
	@XmlElement	
	private double loanToValue;
	@XmlElement	
	private double yearlyInterestRate;
	@XmlElement	
	private double monthlyRepayment;

	@SuppressWarnings("unused")
	private Loan() {
	}

	public void setNumberOfMonthlyPayments(int numberOfMonthlyPayments) {
		this.numberOfMonthlyPayments = numberOfMonthlyPayments;
	}


	public void setStartDate(Date startDate) {
		this.startDate = startDate;
	}


	public void setAmount(int amount) {
		this.amount = amount;
	}


	public Loan(Date startDate, int numberOfMonthlyPayments, int amount,
			double loanToValue) {
		this.startDate = startDate;
		this.numberOfMonthlyPayments = numberOfMonthlyPayments;
		this.amount = amount;
		this.loanToValue = loanToValue;
	}


	/**
	 * @return Returns the loanToValue.
	 */
	public double getLoanToValue() {
		return loanToValue;
	}

	/**
	 * @param loanToValue
	 *            The loanToValue to set.
	 */
	public void setLoanToValue(double loanToValue) {
		this.loanToValue = loanToValue;
	}
	

	/**
	 * @return Returns the amount.
	 */
	public int getAmount() {
		return amount;
	}

	/**
	 * @return Returns the numberOfMonthlyPayments.
	 */
	public int getNumberOfMonthlyPayments() {
		return numberOfMonthlyPayments;
	}
	
	/**
	 * Get the loan duration (rounded to the upper int)
	 * @return a number of years 
	 */
	public int getDuration() {
		return (numberOfMonthlyPayments+11)/12;
	}

	/**
	 * @return Returns the startDate.
	 */
	public Date getStartDate() {
		return startDate;
	}
	
	/**
	 * @return Returns the yearlyRepayment.
	 */
	public double getYearlyRepayment() {
		return 12*monthlyRepayment;
	}

	/**
	 * @return Returns the monthlyRepayment.
	 */
	public double getMonthlyRepayment() {
		return monthlyRepayment;
	}
	/**
	 * @param monthlyRepayment
	 *            The monthlyRepayment to set.
	 */
	public void setMonthlyRepayment(double monthlyRepayment) {
		this.monthlyRepayment = monthlyRepayment;
	}
	/**
	 * @return Returns the rate.
	 */
	public double getYearlyInterestRate() {
		return yearlyInterestRate;
	}

	/**
	 * @param rate
	 *            The rate to set.
	 */
	public void setYearlyInterestRate(double rate) {
		this.yearlyInterestRate = rate;
	}
	
	public String toString() {
		String msg = Messages.getMessage("loan");
		Object[] arguments = { amount, DateUtil.format(startDate),
				numberOfMonthlyPayments, formattedPercentage(loanToValue) };
		String result = MessageFormat.format(msg, arguments);

		
		return result;
	}
};
