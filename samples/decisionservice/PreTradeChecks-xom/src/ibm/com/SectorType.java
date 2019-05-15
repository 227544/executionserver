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

@XmlType(name = "SectorType")
@XmlEnum
@XmlAccessorType(XmlAccessType.FIELD)
public enum SectorType {

    @XmlEnumValue("Tech")
    TECH("Tech"),
    @XmlEnumValue("Oil")
    OIL("Oil"),
    @XmlEnumValue("Rail")
    RAIL("Rail"),
    @XmlEnumValue("Bank")
    BANK("Bank");
    private final String value;

    SectorType(String v) {
        value = v;
    }

    public String value() {
        return value;
    }

    public static SectorType fromValue(String v) {
        for (SectorType c: SectorType.values()) {
            if (c.value.equals(v)) {
                return c;
            }
        }
        throw new IllegalArgumentException(v);
    }

}
