/*
 * Licensed Materials - Property of IBM
 * 5725-B69 5655-Y17 5655-Y31 5724-X98 5724-Y15 5655-V82 
 * Copyright IBM Corp. 1987, 2018. All Rights Reserved.
 *
 * Note to U.S. Government Users Restricted Rights: 
 * Use, duplication or disclosure restricted by GSA ADP Schedule 
 * Contract with IBM Corp.
 */


package ibm.com;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlSchemaType;
import javax.xml.bind.annotation.XmlType;
import javax.xml.datatype.XMLGregorianCalendar;

@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "Order", propOrder = {
		"id",
		"stock",
		"amount",
		"exchange",
		"currency",
		"destination",
		"action",
		"securityType",
		"dateTime",
		"sector",
		"status",
		"reasons"
})
public class Order {

	protected String id;
	protected String stock;
	protected int amount;
	protected String exchange;
	@XmlElement(required = true)
	protected Currency currency;
	protected String destination;
	@XmlElement(required = true)
	protected ActionType action;
	@XmlElement(required = true)
	protected SecurityType securityType;
	@XmlElement(required = true)
	@XmlSchemaType(name = "dateTime")
	protected XMLGregorianCalendar dateTime;
	@XmlElement(required = true)
	protected SectorType sector;
	@XmlElement(required = true)
	protected StatusType status;
	@XmlElement(required = true)
	protected ReasonsType reasons;

	/**
	 * Get id value.
	 * 
	 * @return
	 *     possible object is
	 *     {@link String }
	 *     
	 */
	public String getId() {
		return id;
	}

	/**
	 * Set id value.
	 * 
	 * @param value
	 *     allowed object is
	 *     {@link String }
	 *     
	 */
	public void setId(String value) {
		this.id = value;
	}

	/**
	 * Get stock value.
	 * 
	 * @return
	 *     possible object is
	 *     {@link String }
	 *     
	 */
	public String getStock() {
		return stock;
	}

	/**
	 * Set stock value.
	 * 
	 * @param value
	 *     allowed object is
	 *     {@link String }
	 *     
	 */
	public void setStock(String value) {
		this.stock = value;
	}

	/**
	 * Get amount value.
	 * 
	 */
	public int getAmount() {
		return amount;
	}

	/**
	 * Set amount value.
	 * 
	 */
	public void setAmount(int value) {
		this.amount = value;
	}

	/**
	 * Get exchange value.
	 * 
	 * @return
	 *     possible object is
	 *     {@link String }
	 *     
	 */
	public String getExchange() {
		return exchange;
	}

	/**
	 * Set exchange value.
	 * 
	 * @param value
	 *     allowed object is
	 *     {@link String }
	 *     
	 */
	public void setExchange(String value) {
		this.exchange = value;
	}

	/**
	 * Get currency value.
	 * 
	 * @return
	 *     possible object is
	 *     {@link String }
	 *     
	 */
	public String getCurrency() {
		if(currency != null){
			return currency.value();
		}
		return null;
	}

	/**
	 * Set currency value.
	 * 
	 * @param value
	 *     allowed object is
	 *     {@link String }
	 *     
	 */
	public void setCurrency(String value) {
		this.currency = Currency.fromValue(value);
	}

	/**
	 * Get destination value.
	 * 
	 * @return
	 *     possible object is
	 *     {@link String }
	 *     
	 */
	public String getDestination() {
		return destination;
	}

	/**
	 * Set destination value.
	 * 
	 * @param value
	 *     allowed object is
	 *     {@link String }
	 *     
	 */
	public void setDestination(String value) {
		this.destination = value;
	}

	/**
	 * Get action value.
	 * 
	 * @return
	 *     possible object is
	 *     {@link String }
	 *     
	 */
	public String getAction() {
		if(action != null){
			return action.value();
		}
		return null;
	}

	/**
	 * Set action value.
	 * 
	 * @param value
	 *     allowed object is
	 *     {@link ActionType }
	 *     
	 */
	public void setAction(ActionType value) {
		this.action = value;
	}
	
	public void setAction(String value) {
		this.action = ActionType.fromValue(value);
	}

	/**
	 * Get securityType value.
	 * 
	 * @return
	 *     possible object is
	 *     {@link SecurityType }
	 *     
	 */
	public String getSecurityType() {
		if(securityType != null){
			return securityType.value();
		}
		return null;
	}

	/**
	 * Set securityType value.
	 * 
	 * @param value
	 *     allowed object is
	 *     {@link SecurityType }
	 *     
	 */
	public void setSecurityType(SecurityType value) {
		this.securityType = value;
	}
	
	/**
	 * Set securityType value.
	 * 
	 * @param value
	 *     allowed object is
	 *     {@link String }
	 *     
	 */
	public void setSecurityType(String value) {
		this.securityType = SecurityType.fromValue(value);
	}

	/**
	 * Get dateTime value.
	 * 
	 * @return
	 *     possible object is
	 *     {@link XMLGregorianCalendar }
	 *     
	 */
	public XMLGregorianCalendar getDateTime() {
		return dateTime;
	}

	/**
	 * Set dateTime value.
	 * 
	 * @param value
	 *     allowed object is
	 *     {@link XMLGregorianCalendar }
	 *     
	 */
	public void setDateTime(XMLGregorianCalendar value) {
		this.dateTime = value;
	}

	/**
	 * Get sector value.
	 * 
	 * @return
	 *     possible object is
	 *     {@link SectorType }
	 *     
	 */
	public SectorType getSector() {
		return sector;
	}

	/**
	 * Set sector value.
	 * 
	 * @param value
	 *     allowed object is
	 *     {@link SectorType }
	 *     
	 */
	public void setSector(SectorType value) {
		this.sector = value;
	}

	/**
	 * Get status value.
	 * 
	 * @return
	 *     possible object is
	 *     {@link StatusType }
	 *     
	 */
	public String getStatus() {
		if(status != null){
			return status.value();
		}
		return null;
	}

	/**
	 * Set status value.
	 * 
	 * @param value
	 *     allowed object is
	 *     {@link String }
	 *     
	 */
	public void setStatus(String value) {
		this.status = StatusType.fromValue(value);
	}

	/**
	 * Get reasons value.
	 * 
	 * @return
	 *     possible object is
	 *     {@link String }
	 *     
	 */
	public String getReasons() {
		if(reasons != null){
			return reasons.value();
		}
		return null;
	}

	/**
	 * Set reasons value.
	 * 
	 * @param value
	 *     allowed object is
	 *     {@link String } 
	 *     
	 */
	public void setReasons(String value) {
		this.reasons = ReasonsType.fromValue(value);
	}

}
