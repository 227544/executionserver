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
import javax.xml.bind.annotation.XmlType;

@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "Customer", propOrder = {
    "name",
    "owner",
    "initialValue",
    "currentValue",
    "sectorPosition",
    "bankStockPosition",
    "oilStockPosition",
    "railStockPosition",
    "bondPosition",
    "futurPosition",
    "stockPosition",
    "currency"
})
public class Customer {

    protected String name;
    protected String owner;
    protected float initialValue;
    protected float currentValue;
    protected float sectorPosition;
    protected float bankStockPosition;
    protected float oilStockPosition;
    protected float railStockPosition;
    protected float bondPosition;
    protected float futurPosition;
    protected float stockPosition;
    @XmlElement(required = true)
    protected Currency currency;

    /**
     * Get name value.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getName() {
        return name;
    }

    /**
     * Set name value.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setName(String value) {
        this.name = value;
    }

    /**
     * Get owner value.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getOwner() {
        return owner;
    }

    /**
     * Set owner value.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setOwner(String value) {
        this.owner = value;
    }

    /**
     * Get initialValue value.
     * 
     */
    public float getInitialValue() {
        return initialValue;
    }

    /**
     * Set initialValue value.
     * 
     */
    public void setInitialValue(float value) {
        this.initialValue = value;
    }

    /**
     * Get currentValue value.
     * 
     */
    public float getCurrentValue() {
        return currentValue;
    }

    /**
     * Set currentValue value.
     * 
     */
    public void setCurrentValue(float value) {
        this.currentValue = value;
    }

    /**
     * Get sectorPosition value.
     * 
     */
    public float getSectorPosition() {
        return sectorPosition;
    }

    /**
     * Set sectorPosition value.
     * 
     */
    public void setSectorPosition(float value) {
        this.sectorPosition = value;
    }

    /**
     * Get bankStockPosition value.
     * 
     */
    public float getBankStockPosition() {
        return bankStockPosition;
    }

    /**
     * Set bankStockPosition value.
     * 
     */
    public void setBankStockPosition(float value) {
        this.bankStockPosition = value;
    }

    /**
     * Get oilStockPosition value.
     * 
     */
    public float getOilStockPosition() {
        return oilStockPosition;
    }

    /**
     * Set oilStockPosition value.
     * 
     */
    public void setOilStockPosition(float value) {
        this.oilStockPosition = value;
    }

    /**
     * Get railStockPosition value.
     * 
     */
    public float getRailStockPosition() {
        return railStockPosition;
    }

    /**
     * Set railStockPosition value.
     * 
     */
    public void setRailStockPosition(float value) {
        this.railStockPosition = value;
    }

    /**
     * Get bondPosition value.
     * 
     */
    public float getBondPosition() {
        return bondPosition;
    }

    /**
     * Set bondPosition value.
     * 
     */
    public void setBondPosition(float value) {
        this.bondPosition = value;
    }

    /**
     * Get futurPosition value.
     * 
     */
    public float getFuturPosition() {
        return futurPosition;
    }

    /**
     * Set futurPosition value.
     * 
     */
    public void setFuturPosition(float value) {
        this.futurPosition = value;
    }

    /**
     * Get stockPosition value.
     * 
     */
    public float getStockPosition() {
        return stockPosition;
    }

    /**
     * Set stockPosition value.
     * 
     */
    public void setStockPosition(float value) {
        this.stockPosition = value;
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

}
