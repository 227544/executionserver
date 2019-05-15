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
import javax.xml.bind.annotation.XmlEnum;
import javax.xml.bind.annotation.XmlEnumValue;
import javax.xml.bind.annotation.XmlType;

@XmlType(name = "Currency")
@XmlEnum
@XmlAccessorType(XmlAccessType.FIELD)
public enum Currency {

    @XmlEnumValue("USDollar")
    US_DOLLAR("USDollar"),
    @XmlEnumValue("Euro")
    EURO("Euro"),
    @XmlEnumValue("Pound")
    POUND("Pound"),
    @XmlEnumValue("JPRen")
    JP_REN("JPRen"),
    PRCRMB("PRCRMB"),
    @XmlEnumValue("SGDollar")
    SG_DOLLAR("SGDollar");
    @XmlElement
    private final String value;

    Currency(String v) {
        value = v;
    }

    public String value() {
        return value; 
    }

    public static Currency fromValue(String v) {
        for (Currency c: Currency.values()) {
            if (c.value.equals(v)) {
                return c;
            }
        }
        throw new IllegalArgumentException(v);
    }

}
