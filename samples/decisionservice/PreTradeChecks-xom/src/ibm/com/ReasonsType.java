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
import javax.xml.bind.annotation.XmlEnum;
import javax.xml.bind.annotation.XmlEnumValue;
import javax.xml.bind.annotation.XmlType;


@XmlType(name = "ReasonsType")
@XmlEnum
@XmlAccessorType(XmlAccessType.FIELD)
public enum ReasonsType {

    @XmlEnumValue("CustomerPreferences")
    CUSTOMER_PREFERENCES("CustomerPreferences"),
    @XmlEnumValue("BlackListStocks")
    BLACK_LIST_STOCKS("BlackListStocks"),
    @XmlEnumValue("BadClient")
    BAD_CLIENT("BadClient");
    private final String value;

    ReasonsType(String v) {
        value = v;
    }

    public String value() {
        return value;
    }

    public static ReasonsType fromValue(String v) {
        for (ReasonsType c: ReasonsType.values()) {
            if (c.value.equals(v)) {
                return c;
            }
        }
        throw new IllegalArgumentException(v);
    }

}
