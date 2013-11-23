﻿<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<axsl:stylesheet xmlns:axsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:saxon="http://saxon.sf.net/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:iso="http://purl.oclc.org/dsdl/schematron" xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" xmlns:ubl="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" version="2.0">
  <!--Implementers: please note that overriding process-prolog or process-root is 
    the preferred method for meta-stylesheets to use where possible. -->

  <axsl:param name="archiveDirParameter" tunnel="no"/>
  <axsl:param name="archiveNameParameter" tunnel="no"/>
  <axsl:param name="fileNameParameter" tunnel="no"/>
  <axsl:param name="fileDirParameter" tunnel="no"/>

  <!--PHASES-->


  <!--PROLOG-->

  <axsl:output xmlns:svrl="http://purl.oclc.org/dsdl/svrl" method="xml" omit-xml-declaration="no" standalone="yes" indent="yes"/>

  <!--XSD TYPES-->


  <!--KEYS AND FUCNTIONS-->


  <!--DEFAULT RULES-->


  <!--MODE: SCHEMATRON-FULL-PATH-->
  <!--This mode can be used to generate an ugly though full XPath for locators-->

  <axsl:template match="*" mode="schematron-get-full-path">
    <axsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
    <axsl:text>/</axsl:text>
    <axsl:choose>
      <axsl:when test="namespace-uri()=''">
        <axsl:value-of select="name()"/>
      </axsl:when>
      <axsl:otherwise>
        <axsl:text>*:</axsl:text>
        <axsl:value-of select="local-name()"/>
        <axsl:text>[namespace-uri()='</axsl:text>
        <axsl:value-of select="namespace-uri()"/>
        <axsl:text>']</axsl:text>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:variable name="preceding" select="count(preceding-sibling::*[local-name()=local-name(current())                                   and namespace-uri() = namespace-uri(current())])"/>
    <axsl:text>[</axsl:text>
    <axsl:value-of select="1+ $preceding"/>
    <axsl:text>]</axsl:text>
  </axsl:template>
  <axsl:template match="@*" mode="schematron-get-full-path">
    <axsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
    <axsl:text>/</axsl:text>
    <axsl:choose>
      <axsl:when test="namespace-uri()=''">
        @<axsl:value-of select="name()"/>
      </axsl:when>
      <axsl:otherwise>
        <axsl:text>@*[local-name()='</axsl:text>
        <axsl:value-of select="local-name()"/>
        <axsl:text>' and namespace-uri()='</axsl:text>
        <axsl:value-of select="namespace-uri()"/>
        <axsl:text>']</axsl:text>
      </axsl:otherwise>
    </axsl:choose>
  </axsl:template>

  <!--MODE: SCHEMATRON-FULL-PATH-2-->
  <!--This mode can be used to generate prefixed XPath for humans-->

  <axsl:template match="node() | @*" mode="schematron-get-full-path-2">
    <axsl:for-each select="ancestor-or-self::*">
      <axsl:text>/</axsl:text>
      <axsl:value-of select="name(.)"/>
      <axsl:if test="preceding-sibling::*[name(.)=name(current())]">
        <axsl:text>[</axsl:text>
        <axsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
        <axsl:text>]</axsl:text>
      </axsl:if>
    </axsl:for-each>
    <axsl:if test="not(self::*)">
      <axsl:text/>/@<axsl:value-of select="name(.)"/>
    </axsl:if>
  </axsl:template>

  <!--MODE: SCHEMATRON-FULL-PATH-3-->
  <!--This mode can be used to generate prefixed XPath for humans 
	(Top-level element has index)-->

  <axsl:template match="node() | @*" mode="schematron-get-full-path-3">
    <axsl:for-each select="ancestor-or-self::*">
      <axsl:text>/</axsl:text>
      <axsl:value-of select="name(.)"/>
      <axsl:if test="parent::*">
        <axsl:text>[</axsl:text>
        <axsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
        <axsl:text>]</axsl:text>
      </axsl:if>
    </axsl:for-each>
    <axsl:if test="not(self::*)">
      <axsl:text/>/@<axsl:value-of select="name(.)"/>
    </axsl:if>
  </axsl:template>

  <!--MODE: GENERATE-ID-FROM-PATH -->

  <axsl:template match="/" mode="generate-id-from-path"/>
  <axsl:template match="text()" mode="generate-id-from-path">
    <axsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
    <axsl:value-of select="concat('.text-', 1+count(preceding-sibling::text()), '-')"/>
  </axsl:template>
  <axsl:template match="comment()" mode="generate-id-from-path">
    <axsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
    <axsl:value-of select="concat('.comment-', 1+count(preceding-sibling::comment()), '-')"/>
  </axsl:template>
  <axsl:template match="processing-instruction()" mode="generate-id-from-path">
    <axsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
    <axsl:value-of select="concat('.processing-instruction-', 1+count(preceding-sibling::processing-instruction()), '-')"/>
  </axsl:template>
  <axsl:template match="@*" mode="generate-id-from-path">
    <axsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
    <axsl:value-of select="concat('.@', name())"/>
  </axsl:template>
  <axsl:template match="*" mode="generate-id-from-path" priority="-0.5">
    <axsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
    <axsl:text>.</axsl:text>
    <axsl:value-of select="concat('.',name(),'-',1+count(preceding-sibling::*[name()=name(current())]),'-')"/>
  </axsl:template>

  <!--MODE: GENERATE-ID-2 -->

  <axsl:template match="/" mode="generate-id-2">U</axsl:template>
  <axsl:template match="*" mode="generate-id-2" priority="2">
    <axsl:text>U</axsl:text>
    <axsl:number level="multiple" count="*"/>
  </axsl:template>
  <axsl:template match="node()" mode="generate-id-2">
    <axsl:text>U.</axsl:text>
    <axsl:number level="multiple" count="*"/>
    <axsl:text>n</axsl:text>
    <axsl:number count="node()"/>
  </axsl:template>
  <axsl:template match="@*" mode="generate-id-2">
    <axsl:text>U.</axsl:text>
    <axsl:number level="multiple" count="*"/>
    <axsl:text>_</axsl:text>
    <axsl:value-of select="string-length(local-name(.))"/>
    <axsl:text>_</axsl:text>
    <axsl:value-of select="translate(name(),':','.')"/>
  </axsl:template>
  <!--Strip characters-->
  <axsl:template match="text()" priority="-1"/>

  <!--SCHEMA METADATA-->

  <axsl:template match="/">
    <svrl:schematron-output xmlns:svrl="http://purl.oclc.org/dsdl/svrl" title="BIICORE  T10 bound to UBL" schemaVersion="">
      <axsl:comment>
        <axsl:value-of select="$archiveDirParameter"/>   
        <axsl:value-of select="$archiveNameParameter"/>  
        <axsl:value-of select="$fileNameParameter"/>  
        <axsl:value-of select="$fileDirParameter"/>
      </axsl:comment>
      <svrl:ns-prefix-in-attribute-values uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" prefix="cbc"/>
      <svrl:ns-prefix-in-attribute-values uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" prefix="cac"/>
      <svrl:ns-prefix-in-attribute-values uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" prefix="ubl"/>
      <svrl:active-pattern>
        <axsl:attribute name="id">UBL-T10</axsl:attribute>
        <axsl:attribute name="name">UBL-T10</axsl:attribute>
        <axsl:apply-templates/>
      </svrl:active-pattern>
      <axsl:apply-templates select="/" mode="M5"/>
    </svrl:schematron-output>
  </axsl:template>

  <!--SCHEMATRON PATTERNS-->

  <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BIICORE  T10 bound to UBL</svrl:text>

  <!--PATTERN UBL-T10-->


  <!--RULE -->

  <axsl:template match="/ubl:Invoice" priority="1008" mode="M5">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Invoice"/>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9')"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9')">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R000]-This XML instance is NOT a core BiiTrdm010 transaction</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(count(//*[not(text())]) &gt; 0)"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(count(//*[not(text())]) &gt; 0)">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R001]-An invoice SHOULD not contain empty elements.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cbc:CopyIndicator)  and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cbc:CopyIndicator) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R002]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cbc:UUID)  and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cbc:UUID) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R003]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cbc:IssueTime)  and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cbc:IssueTime) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R004]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cbc:TaxCurrencyCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cbc:TaxCurrencyCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R005]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cbc:PricingCurrencyCode)  and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cbc:PricingCurrencyCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R006]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cbc:PaymentCurrencyCode)  and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cbc:PaymentCurrencyCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R007]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cbc:PaymentAlternativeCurrencyCode)  and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cbc:PaymentAlternativeCurrencyCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R008]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cbc:AccountingCostCode)  and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cbc:AccountingCostCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R009]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cbc:LineCountNumeric) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cbc:LineCountNumeric) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R010]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:BillingReference) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:BillingReference) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R011]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:DespatchDocumentReference)  and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:DespatchDocumentReference) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R012]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:ReceiptDocumentReference) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:ReceiptDocumentReference) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R013]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:OriginatorDocumentReference) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:OriginatorDocumentReference) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R014]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:Signature) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Signature) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R015]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:BuyerCustomerParty) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:BuyerCustomerParty) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R016]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:SellerSupplierParty) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:SellerSupplierParty) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R017]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:TaxRepresentativeParty) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxRepresentativeParty) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R018]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:DeliveryTerms/cbc:ID) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:DeliveryTerms/cbc:ID) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R019]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:DeliveryTerms/cbc:LossRiskResponsibilityCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:DeliveryTerms/cbc:LossRiskResponsibilityCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R019]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:DeliveryTerms/cbc:LossRisk) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:DeliveryTerms/cbc:LossRisk) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R019]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:DeliveryTerms/cbc:DeliveryLocation) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:DeliveryTerms/cbc:DeliveryLocation) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R019]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:DeliveryTerms/cbc:AllowanceCharge) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:DeliveryTerms/cbc:AllowanceCharge) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R019]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:PrepaidPayment) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PrepaidPayment) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R020]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:TaxExchangeRate) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxExchangeRate) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R021]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:PricingExchangeRate) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PricingExchangeRate) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R022]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:PaymentExchangeRate) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentExchangeRate) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R023]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:PaymentAlternativeExchangeRate) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentAlternativeExchangeRate) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R024]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoicePeriod/cbc:StartTime) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoicePeriod/cbc:StartTime) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R025]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoicePeriod/cbc:EndTime) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoicePeriod/cbc:EndTime) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R026]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoicePeriod/cbc:DurationMeasure) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoicePeriod/cbc:DurationMeasure) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R027]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoicePeriod/cbc:Description) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoicePeriod/cbc:Description) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R028]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoicePeriod/cbc:DescriptionCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoicePeriod/cbc:DescriptionCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R029]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:OrderReference/cbc:SalesOrderID) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:OrderReference/cbc:SalesOrderID) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R030]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:OrderReference/cbc:CopyIndicator)  and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:OrderReference/cbc:CopyIndicator) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R031]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:OrderReference/cbc:UUID)  and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:OrderReference/cbc:UUID) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R032]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:OrderReference/cbc:IssueDate)  and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:OrderReference/cbc:IssueDate) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R033]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:OrderReference/cbc:IssueTime)  and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:OrderReference/cbc:IssueTime) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R034]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:OrderReference/cbc:CustomerReference) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:OrderReference/cbc:CustomerReference) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R035]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:OrderReference/cac:DocumentReference) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:OrderReference/cac:DocumentReference) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R036]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:ContractDocumentReference/cbc:CooyIndicator) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:ContractDocumentReference/cbc:CooyIndicator) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R037]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:ContractDocumentReference/cbc:UUID) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:ContractDocumentReference/cbc:UUID) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R038]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:ContractDocumentReference/cbc:IssueDate) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:ContractDocumentReference/cbc:IssueDate) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R039]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:ContractDocumentReference/cbc:DocumentTypeCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:ContractDocumentReference/cbc:DocumentTypeCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R040]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:ContractDocumentReference/cbc:XPath) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:ContractDocumentReference/cbc:XPath) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R041]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:ContractDocumentReference/cac:Attachment) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:ContractDocumentReference/cac:Attachment) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R042]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AdditionalDocumentReference/cbc:CopyIndicator) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AdditionalDocumentReference/cbc:CopyIndicator) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R043]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AdditionalDocumentReference/cbc:UUID) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AdditionalDocumentReference/cbc:UUID) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R044]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AdditionalDocumentReference/cbc:IssueDate) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AdditionalDocumentReference/cbc:IssueDate) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R045]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AdditionalDocumentReference/cbc:DocumentTypeCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AdditionalDocumentReference/cbc:DocumentTypeCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R046]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AdditionalDocumentReference/cbc:XPath) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AdditionalDocumentReference/cbc:XPath) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R047]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:DocumentHash) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:DocumentHash) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R048]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:ExpiryDate) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:ExpiryDate) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R049]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:ExpiryTime) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:ExpiryTime) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R050]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingSupplierParty/cbc:CustomerAssignedAccountID) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cbc:CustomerAssignedAccountID) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R051]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingSupplierParty/cbc:AdditionalAccountID) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cbc:AdditionalAccountID) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R052]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingSupplierParty/cbc:DataSendingCapability) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cbc:DataSendingCapability) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R053]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingSupplierParty/cac:DespatchContact) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:DespatchContact) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R054]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingSupplierParty/cac:AccountingContact) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:AccountingContact) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R055]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingSupplierParty/cac:SellerContact) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:SellerContact) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R056]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cbc:MarkCareIndicator) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cbc:MarkCareIndicator) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R057]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cbc:MarkAttentionIndicator) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cbc:MarkAttentionIndicator) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R058]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cbc:WebsiteURI) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cbc:WebsiteURI) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R059]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cbc:LogoReferenceID) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cbc:LogoReferenceID) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R060]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:Language) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:Language) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R061]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:AddressTypeCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:AddressTypeCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R062]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:AddressFormatCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:AddressFormatCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R063]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:Floor) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:Floor) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R064]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:Room) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:Room) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R065]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:BlockName) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:BlockName) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R066]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:BuildingName) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:BuildingName) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R067]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:InhouseMail) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:InhouseMail) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R068]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:MarkAttention) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:MarkAttention) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R069]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:MarkCare) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:MarkCare) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R070]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:PlotIdentification) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:PlotIdentification) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R071]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CitySubdivisionName) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CitySubdivisionName) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R072]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:Region) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:Region) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R073]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:District) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:District) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R074]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:TimezoneOffset) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:TimezoneOffset) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R075]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R076]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R077]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:LocationCoordinate) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:LocationCoordinate) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R078]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PhysicalLocation) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PhysicalLocation) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R079]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:RegistrationName) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:RegistrationName) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R080]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:TaxLevelCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:TaxLevelCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R081]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:ExemptionReasonCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:ExemptionReasonCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R082]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:ExemptionReason) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:ExemptionReason) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R083]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:RegistrationAddress) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:RegistrationAddress) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R084]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R085]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:TaxTypeCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:TaxTypeCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R086]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:CurrencyCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:CurrencyCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R087]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cac:JurisdictionRegionAddress) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cac:JurisdictionRegionAddress) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R088]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:AddressTypeCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:AddressTypeCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R089]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:AddressFormatCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:AddressFormatCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R090]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Postbox) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Postbox) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R091]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Floor) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Floor) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R092]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Room) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Room) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R093]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:BlockName) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:BlockName) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R096]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:BuildingName) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:BuildingName) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R097]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:InhouseMail) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:InhouseMail) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R099]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Department) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Department) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R100]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:MarkAttention) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:MarkAttention) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R101]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:MarkCare) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:MarkCare) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R102]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:PlotIdentification) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:PlotIdentification) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R103]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CitySubdivisionName) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CitySubdivisionName) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R104]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CountrySubentityCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CountrySubentityCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R106]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Region) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Region) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R107]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:District) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:District) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R108]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:TimezoneOffset) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:TimezoneOffset) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R109]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:AddressLine) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:AddressLine) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R110]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R111]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:LocationCoordinate) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:LocationCoordinate) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R112]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:CorporateRegistrationScheme) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:CorporateRegistrationScheme) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R113]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:Contact/cbc:ID) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:Contact/cbc:ID) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R114]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:Contact/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:Contact/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R115]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:Contact/cbc:Note) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:Contact/cbc:Note) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R116]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:Contact/cac:OtherCommunication) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:Contact/cac:OtherCommunication) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R117]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:Person/cbc:Title) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:Person/cbc:Title) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R118]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:Person/cbc:NameSuffix) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:Person/cbc:NameSuffix) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R119]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:Person/cbc:OrganizationDepartment) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:Person/cbc:OrganizationDepartment) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R120]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:AgentParty) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:AgentParty) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R121]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingCustomerParty/cbc:SupplierAssignedAccountID) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cbc:SupplierAssignedAccountID) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R122]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingCustomerParty/cbc:CustomerAssignedAccountID) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cbc:CustomerAssignedAccountID) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R123]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingCustomerParty/cbc:AdditionalAccountID) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cbc:AdditionalAccountID) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R124]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingCustomerParty/cac:DeliveryContact) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:DeliveryContact) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R125]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingCustomerParty/cac:AccountingContact) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:AccountingContact) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R126]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingCustomerParty/cac:BuyerContact) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:BuyerContact) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R127]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cbc:MarkCareIndicator) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cbc:MarkCareIndicator) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R128]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cbc:MarkAttentionIndicator) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cbc:MarkAttentionIndicator) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R129]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cbc:WebsiteURI) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cbc:WebsiteURI) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R130]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cbc:LogoReferenceID) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cbc:LogoReferenceID) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R131]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:Language) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:Language) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R132]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:AddressTypeCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:AddressTypeCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R133]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:AddressFormatCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:AddressFormatCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R134]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:Floor) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:Floor) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R135]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:Room) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:Room) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R136]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:BlockName) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:BlockName) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R137]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:BuildingName) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:BuildingName) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R138]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:InhouseMail) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:InhouseMail) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R139]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:MarkAttention) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:MarkAttention) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R140]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:MarkCare) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:MarkCare) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R141]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:PlotIdentification) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:PlotIdentification) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R142]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CitySubdivisionName) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CitySubdivisionName) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R143]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:Region) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:Region) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R144]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:District) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:District) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R145]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:TimezoneOffset) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:TimezoneOffset) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R146]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R147]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R148]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:LocationCoordinate) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:LocationCoordinate) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R149]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PhysicalLocation) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PhysicalLocation) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R150]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:RegistrationName) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:RegistrationName) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R151]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:TaxLevelCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:TaxLevelCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R152]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:ExemptionReasonCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:ExemptionReasonCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R153]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:ExemptionReason) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:ExemptionReason) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R154]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:RegistrationAddress) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:RegistrationAddress) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R155]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R156]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:TaxTypeCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:TaxTypeCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R157]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:CurrencyCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:CurrencyCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R158]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cac:JurisdictionRegionAddress) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cac:JurisdictionRegionAddress) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R159]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:AddressTypeCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:AddressTypeCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R160]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:AddressFormatCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:AddressFormatCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R161]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Postbox) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Postbox) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R162]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Floor) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Floor) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R163]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Room) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Room) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R164]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:BlockName) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:BlockName) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R167]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:BuildingName) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:BuildingName) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R168]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:InhouseMail) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:InhouseMail) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R170]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Department) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Department) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R171]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:MarkAttention) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:MarkAttention) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R172]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:MarkCare) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:MarkCare) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R173]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:PlotIdentification) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:PlotIdentification) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R174]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CitySubdivisionName) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CitySubdivisionName) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R175]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CountrySubentityCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CountrySubentityCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R177]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Region) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Region) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R178]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:District) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:District) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R179]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:TimezoneOffset) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:TimezoneOffset) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R180]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:AddressLine) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:AddressLine) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R181]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R182]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:LocationCoordinate) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:LocationCoordinate) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R183]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:CorporateRegistrationScheme) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:CorporateRegistrationScheme) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R184]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:Contact/cbc:ID) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:Contact/cbc:ID) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R185]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:Contact/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:Contact/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R186]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:Contact/cbc:Note) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:Contact/cbc:Note) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R187]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:Contact/cac:OtherCommunication) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:Contact/cac:OtherCommunication) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R188]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:Person/cbc:Title) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:Person/cbc:Title) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R189]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:Person/cbc:NameSuffix) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:Person/cbc:NameSuffix) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R190]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:Person/cbc:OrganizationDepartment) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:Person/cbc:OrganizationDepartment) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R191]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:AgentParty) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:AgentParty) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R192]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:PayeeParty/cbc:MarkCareIndicator) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty/cbc:MarkCareIndicator) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R193]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:PayeeParty/cbc:MarkAttentionIndicator) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty/cbc:MarkAttentionIndicator) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R194]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:PayeeParty/cbc:WebsiteURI) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty/cbc:WebsiteURI) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R195]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:PayeeParty/cbc:LogoReferenceID) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty/cbc:LogoReferenceID) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R196]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:PayeeParty/cac:Language) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty/cac:Language) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R197]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:PayeeParty/cac:PostalAddress) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty/cac:PostalAddress) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R198]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:PayeeParty/cac:PhysicalLocation) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty/cac:PhysicalLocation) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R199]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:PayeeParty/cac:PartyTaxScheme) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty/cac:PartyTaxScheme) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R200]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:PayeeParty/cac:PartyLegalEntity/cbc:RegistrationName) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty/cac:PartyLegalEntity/cbc:RegistrationName) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R201]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:PayeeParty/cac:PartyLegalEntity/cac:RegistrationAddress) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty/cac:PartyLegalEntity/cac:RegistrationAddress) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R202]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:PayeeParty/cac:PartyLegalEntity/cac:CorporateRegistrationScheme) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty/cac:PartyLegalEntity/cac:CorporateRegistrationScheme) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R203]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:PayeeParty/cac:Contact) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty/cac:Contact) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R204]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:PayeeParty/cac:Person) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty/cac:Person) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R205]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:PayeeParty/cac:AgentParty) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty/cac:AgentParty) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R206]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:Delivery/cbc:ID) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cbc:ID) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R207]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:Delivery/cbc:Quantity) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cbc:Quantity) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R208]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:Delivery/cbc:MinimumQuantity) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cbc:MinimumQuantity) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R209]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:Delivery/cbc:MaximumQuantity) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cbc:MaximumQuantity) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R210]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:Delivery/cbc:ActualDeliveryTime) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cbc:ActualDeliveryTime) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R211]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:Delivery/cbc:LatestDeliveryDate) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cbc:LatestDeliveryDate) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R212]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:Delivery/cbc:LatestDeliveryTime) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cbc:LatestDeliveryTime) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R213]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:Delivery/cbc:TrackingID) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cbc:TrackingID) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R214]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:Delivery/cac:DeliveryAddress) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryAddress) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R215]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cbc:Description) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cbc:Description) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R216]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cbc:Conditions) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cbc:Conditions) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R217]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cbc:CountrySubentity) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cbc:CountrySubentity) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R218]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cbc:CountrySubentityCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cbc:CountrySubentityCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R219]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:ValidityPeriod) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:ValidityPeriod) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R220]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:AddressTypeCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:AddressTypeCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R221]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:AddressFormatCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:AddressFormatCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R222]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:Floor) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:Floor) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R223]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:Room) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:Room) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R224]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:BlockName) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:BlockName) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R225]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:BuildingName) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:BuildingName) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R226]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:InhouseMail) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:InhouseMail) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R227]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:Department) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:Department) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R228]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:MarkAttention) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:MarkAttention) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R229]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:MarkCare) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:MarkCare) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R230]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:PlotIdentification) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:PlotIdentification) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R231]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:CitySubdivisionName) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:CitySubdivisionName) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R232]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:CountrySubentityCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:CountrySubentityCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R233]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:Region) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:Region) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R234]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:District) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:District) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R235]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:TimezoneOffset) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:TimezoneOffset) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R236]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cac:AddressLine) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cac:AddressLine) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R237]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cac:Country/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cac:Country/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R238]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cac:LocationCoordinate) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cac:LocationCoordinate) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R239]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:RequestedDeliveryPeriod) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:RequestedDeliveryPeriod) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R240]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:PromisedDeliveryPeriod) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:PromisedDeliveryPeriod) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R241]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:EstimatedDeliveryPeriod) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:EstimatedDeliveryPeriod) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R242]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:DeliveryParty) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:DeliveryParty) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R243]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:Despatch) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Despatch) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R244]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:PaymentMeans/cbc:ID) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cbc:ID) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R245]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:PaymentMeans/cbc:InstructionID) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cbc:InstructionID) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R246]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:PaymentMeans/cbc:InstructionNote) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cbc:InstructionNote) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R247]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:PaymentMeans/cac:CardAccount) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cac:CardAccount) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R248]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:PaymentMeans/cac:PayerFinancialAccount) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cac:PayerFinancialAccount) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R249]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:PaymentMeans/cac:CreditAccount) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cac:CreditAccount) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R250]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R251]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:AccountTypeCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:AccountTypeCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R252]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:CurrencyCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:CurrencyCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R253]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cac:Country) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cac:Country) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R254]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R255]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:Address) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:Address) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R256]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R257]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cac:Address) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cac:Address) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R258]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:PaymentTerms/cbc:ID) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentTerms/cbc:ID) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R259]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:PaymentTerms/cbc:PaymentMeansID) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentTerms/cbc:PaymentMeansID) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R260]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:PaymentTerms/cbc:PrepaidPaymentReferenceID) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentTerms/cbc:PrepaidPaymentReferenceID) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R261]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:PaymentTerms/cbc:ReferenceEventCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentTerms/cbc:ReferenceEventCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R262]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:PaymentTerms/cbc:SettlementDiscountPercent) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentTerms/cbc:SettlementDiscountPercent) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R263]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:PaymentTerms/cbc:PenaltySurchargePercent) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentTerms/cbc:PenaltySurchargePercent) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R264]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:PaymentTerms/cbc:Amount) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentTerms/cbc:Amount) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R265]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:PaymentTerms/cac:SettlementPeriod) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentTerms/cac:SettlementPeriod) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R266]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:PaymentTerms/cac:PenaltyPeriod) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentTerms/cac:PenaltyPeriod) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R267]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AllowanceCharge/cbc:ID) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AllowanceCharge/cbc:ID) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R268]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AllowanceCharge/cbc:AllowanceChargeReasonCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AllowanceCharge/cbc:AllowanceChargeReasonCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R269]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AllowanceCharge/cbc:MultiplierFactorNumeric) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AllowanceCharge/cbc:MultiplierFactorNumeric) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R270]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AllowanceCharge/cbc:PrepaidIndicator) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AllowanceCharge/cbc:PrepaidIndicator) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R271]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AllowanceCharge/cbc:SequenceNumeric) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AllowanceCharge/cbc:SequenceNumeric) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R272]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AllowanceCharge/cbc:BaseAmount) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AllowanceCharge/cbc:BaseAmount) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R273]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AllowanceCharge/cbc:AccountingCostCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AllowanceCharge/cbc:AccountingCostCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R274]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AllowanceCharge/cbc:AccountingCost) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AllowanceCharge/cbc:AccountingCost) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R275]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AllowanceCharge/cac:TaxCategory/cbc:Name) or not(cac:AllowanceCharge/cac:TaxCategory/cbc:Percent) or not(cac:AllowanceCharge/cac:TaxCategory/cbc:BaseUnitMeasure) or not(cac:AllowanceCharge/cac:TaxCategory/cbc:PerUnitAmount) or not(cac:AllowanceCharge/cac:TaxCategory/cbc:TaxExemptionReasonCode) or not(cac:AllowanceCharge/cac:TaxCategory/cbc:TaxExemptionReason) or not(cac:AllowanceCharge/cac:TaxCategory/cbc:TierRange) or not(cac:AllowanceCharge/cac:TaxCategory/cbc:TierRatePercent) or not(cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:Name) or not(cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode) or not(cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:CurrencyCode) or not(cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cac:JurisdictionRegionAddress) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AllowanceCharge/cac:TaxCategory/cbc:Name) or not(cac:AllowanceCharge/cac:TaxCategory/cbc:Percent) or not(cac:AllowanceCharge/cac:TaxCategory/cbc:BaseUnitMeasure) or not(cac:AllowanceCharge/cac:TaxCategory/cbc:PerUnitAmount) or not(cac:AllowanceCharge/cac:TaxCategory/cbc:TaxExemptionReasonCode) or not(cac:AllowanceCharge/cac:TaxCategory/cbc:TaxExemptionReason) or not(cac:AllowanceCharge/cac:TaxCategory/cbc:TierRange) or not(cac:AllowanceCharge/cac:TaxCategory/cbc:TierRatePercent) or not(cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:Name) or not(cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode) or not(cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:CurrencyCode) or not(cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cac:JurisdictionRegionAddress) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R276]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AllowanceCharge/cac:TaxTotal/cbc:RoundingAmount) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AllowanceCharge/cac:TaxTotal/cbc:RoundingAmount) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R321]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AllowanceCharge/cac:TaxTotal/cbc:TaxEvidenceIndicator) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AllowanceCharge/cac:TaxTotal/cbc:TaxEvidenceIndicator) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R322]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AllowanceCharge/cac:TaxTotal/cac:TaxSubtotal) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AllowanceCharge/cac:TaxTotal/cac:TaxSubtotal) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R323]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:AllowanceCharge/cac:PaymentMeans) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AllowanceCharge/cac:PaymentMeans) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R278]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:TaxTotal/cbc:RoundingAmount) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxTotal/cbc:RoundingAmount) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R279]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:TaxTotal/cbc:TaxEvidenceIndicator) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxTotal/cbc:TaxEvidenceIndicator) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R280]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:TaxTotal/cac:TaxSubtotal/cbc:CalculationSequenceNumeric) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxTotal/cac:TaxSubtotal/cbc:CalculationSequenceNumeric) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R281]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:TaxTotal/cac:TaxSubtotal/cbc:TransactionCurrencyTaxAmount) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxTotal/cac:TaxSubtotal/cbc:TransactionCurrencyTaxAmount) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R282]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:TaxTotal/cac:TaxSubtotal/cbc:Percent) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxTotal/cac:TaxSubtotal/cbc:Percent) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R283]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:TaxTotal/cac:TaxSubtotal/cbc:BaseUnitMeasure) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxTotal/cac:TaxSubtotal/cbc:BaseUnitMeasure) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R284]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:TaxTotal/cac:TaxSubtotal/cbc:PerUnitAmount) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxTotal/cac:TaxSubtotal/cbc:PerUnitAmount) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R285]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:TaxTotal/cac:TaxSubtotal/cbc:TierRange) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxTotal/cac:TaxSubtotal/cbc:TierRange) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R286]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:TaxTotal/cac:TaxSubtotal/cbc:TierRatePercent) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxTotal/cac:TaxSubtotal/cbc:TierRatePercent) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R287]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R288]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:BaseUnitMeasure) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:BaseUnitMeasure) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R289]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:PerUnitAmount) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:PerUnitAmount) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R290]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:TierRange) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:TierRange) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R291]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:TierRatePercent) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:TierRatePercent) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R292]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R293]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R294]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:CurrencyCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:CurrencyCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R295]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cac:JurisdictionRegionAddress) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cac:JurisdictionRegionAddress) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R296]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cbc:UUID) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cbc:UUID) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R297]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cbc:TaxPointDate) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cbc:TaxPointDate) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R298]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cbc:AccountingCostCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cbc:AccountingCostCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R299]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cbc:FreeOfChargeIndicator) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cbc:FreeOfChargeIndicator) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R300]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:OrderLineReference/cbc:SalesOrderLineID) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:OrderLineReference/cbc:SalesOrderLineID) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R301]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:DespatchLineReference) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:DespatchLineReference) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R302]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:ReceiptLineReference) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:ReceiptLineReference) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R303]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:BillingReference) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:BillingReference) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R304]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:DocumentReference) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:DocumentReference) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R305]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:PricingReference) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:PricingReference) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R306]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:OriginatorParty) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:OriginatorParty) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R307]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:Delivery) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Delivery) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R308]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:PaymentTerms) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:PaymentTerms) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R309]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:AllowanceCharge/cbc:ID) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:AllowanceCharge/cbc:ID) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R310]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:AllowanceCharge/cbc:AllowanceChargeReasonCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:AllowanceCharge/cbc:AllowanceChargeReasonCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R311]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:AllowanceCharge/cbc:MultiplierFactorNumeric) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:AllowanceCharge/cbc:MultiplierFactorNumeric) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R312]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:AllowanceCharge/cbc:PrepaidIndicator) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:AllowanceCharge/cbc:PrepaidIndicator) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R313]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:AllowanceCharge/cbc:SequenceNumeric) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:AllowanceCharge/cbc:SequenceNumeric) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R314]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:AllowanceCharge/cbc:BaseAmount) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:AllowanceCharge/cbc:BaseAmount) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R315]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:AllowanceCharge/cbc:AccountingCostCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:AllowanceCharge/cbc:AccountingCostCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R316]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:AllowanceCharge/cbc:AccountingCost) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:AllowanceCharge/cbc:AccountingCost) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R317]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxCategory/cbc:Name) or not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxCategory/cbc:Percent) or not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxCategory/cbc:BaseUnitMeasure) or not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxCategory/cbc:PerUnitAmount) or not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxCategory/cbc:TaxExemptionReasonCode) or not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxCategory/cbc:TaxExemptionReason) or not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxCategory/cbc:TierRange) or not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxCategory/cbc:TierRatePercent) or not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:Name) or not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode) or not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:CurrencyCode) or not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cac:JurisdictionRegionAddress) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxCategory/cbc:Name) or not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxCategory/cbc:Percent) or not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxCategory/cbc:BaseUnitMeasure) or not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxCategory/cbc:PerUnitAmount) or not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxCategory/cbc:TaxExemptionReasonCode) or not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxCategory/cbc:TaxExemptionReason) or not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxCategory/cbc:TierRange) or not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxCategory/cbc:TierRatePercent) or not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:Name) or not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode) or not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:CurrencyCode) or not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cac:JurisdictionRegionAddress) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R318]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxTotal/cbc:RoundingAmount) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxTotal/cbc:RoundingAmount) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R321]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxTotal/cbc:TaxEvidenceIndicator) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxTotal/cbc:TaxEvidenceIndicator) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R322]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxTotal/cac:TaxSubtotal) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxTotal/cac:TaxSubtotal) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R323]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:AllowanceCharge/cac:PaymentMeans) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:AllowanceCharge/cac:PaymentMeans) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R320]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:TaxTotal/cbc:RoundingAmount) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:TaxTotal/cbc:RoundingAmount) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R321]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:TaxTotal/cbc:TaxEvidenceIndicator) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:TaxTotal/cbc:TaxEvidenceIndicator) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R322]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:TaxTotal/cac:TaxSubtotal) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:TaxTotal/cac:TaxSubtotal) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R323]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:Item/cbc:PackQuantity) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cbc:PackQuantity) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R324]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:Item/cbc:PackSizeNumeric) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cbc:PackSizeNumeric) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R325]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:Item/cbc:CatalogueIndicator) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cbc:CatalogueIndicator) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R326]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:Item/cbc:HazardousRiskIndicator) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cbc:HazardousRiskIndicator) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R327]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:Item/cbc:AdditionalInformation) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cbc:AdditionalInformation) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R328]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:Item/cbc:Keyword) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cbc:Keyword) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R329]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:Item/cbc:BrandName) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cbc:BrandName) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R330]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:Item/cbc:ModelName) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cbc:ModelName) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R331]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:BuyersItemIdentification/cbc:ExtendedID) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:BuyersItemIdentification/cbc:ExtendedID) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R332]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:BuyersItemIdentification/cbc:PhysycalAttribute) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:BuyersItemIdentification/cbc:PhysycalAttribute) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R333]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:BuyersItemIdentification/cbc:MeasurementDimension) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:BuyersItemIdentification/cbc:MeasurementDimension) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R334]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:BuyersItemIdentification/cbc:IssuerParty) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:BuyersItemIdentification/cbc:IssuerParty) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R335]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:SellersItemIdentification/cbc:ExtendedID) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:SellersItemIdentification/cbc:ExtendedID) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R332]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:SellersItemIdentification/cbc:PhysycalAttribute) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:SellersItemIdentification/cbc:PhysycalAttribute) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R333]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:SellersItemIdentification/cbc:MeasurementDimension) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:SellersItemIdentification/cbc:MeasurementDimension) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R334]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:SellersItemIdentification/cbc:IssuerParty) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:SellersItemIdentification/cbc:IssuerParty) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R335]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:StandardItemIdentification/cbc:ExtendedID) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:StandardItemIdentification/cbc:ExtendedID) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R336]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:StandardItemIdentification/cbc:PhysycalAttribute) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:StandardItemIdentification/cbc:PhysycalAttribute) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R337]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:StandardItemIdentification/cbc:MeasurementDimension) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:StandardItemIdentification/cbc:MeasurementDimension) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R338]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:StandardItemIdentification/cbc:IssuerParty) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:StandardItemIdentification/cbc:IssuerParty) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R339]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:CommodityClassification/cbc:NatureCargo) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:CommodityClassification/cbc:NatureCargo) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R341]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:CommodityClassification/cbc:CargoTypeCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:CommodityClassification/cbc:CargoTypeCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R342]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:CommodityClassification/cbc:CommodityCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:CommodityClassification/cbc:CommodityCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R343]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:ManufacturersItemIdentification) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:ManufacturersItemIdentification) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R344]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:CatalogueItemIdentification) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:CatalogueItemIdentification) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R345]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:AdditionalItemIdentification) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:AdditionalItemIdentification) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R346]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:CatalogueDocumentReference) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:CatalogueDocumentReference) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R347]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:ItemSpecificationDocumentReference) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:ItemSpecificationDocumentReference) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R348]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:OriginCountry) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:OriginCountry) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R349]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:TransactionConditions) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:TransactionConditions) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R350]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:HazardousItem) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:HazardousItem) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R351]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:ManufacturerParty) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:ManufacturerParty) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R352]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:InformationContentProviderParty) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:InformationContentProviderParty) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R353]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:OriginAddress) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:OriginAddress) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R354]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:ItemInstance) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:ItemInstance) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R355]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R356]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cbc:BaseUnitMeasure) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cbc:BaseUnitMeasure) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R357]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cbcPerUnitAmount) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cbcPerUnitAmount) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R358]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cbc:TaxExemptionReasonCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cbc:TaxExemptionReasonCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R359]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cbc:TaxExemptionReason) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cbc:TaxExemptionReason) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R360]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cbc:TierRange) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cbc:TierRange) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R361]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cbc:TierRatePercent) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cbc:TierRatePercent) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R362]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cac:TaxScheme/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cac:TaxScheme/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R363]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R364]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cac:TaxScheme/cbc:CurrencyCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cac:TaxScheme/cbc:CurrencyCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R365]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cac:TaxScheme/cac:JurisdictionAddress) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cac:TaxScheme/cac:JurisdictionAddress) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R366]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cac:AdditionalProperty/cac:UsabilityPeriod) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cac:AdditionalProperty/cac:UsabilityPeriod) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R367]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cac:AdditionalProperty/cac:ItemPropertyGroup) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cac:AdditionalProperty/cac:ItemPropertyGroup) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R368]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:Price/cbc:PriceChangeReason) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Price/cbc:PriceChangeReason) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R369]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:Price/cbc:PriceTypeCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Price/cbc:PriceTypeCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R370]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:Price/cbc:PriceType) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Price/cbc:PriceType) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R371]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:Price/cbc:OrderableUnitFactorRate) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Price/cbc:OrderableUnitFactorRate) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R372]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:Price/cac:ValidityPeriod) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Price/cac:ValidityPeriod) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R373]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:Price/cac:PriceList) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Price/cac:PriceList) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R374]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:ID) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:ID) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R375]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:AllowanceChargeReasonCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:AllowanceChargeReasonCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R376]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:PrepaidIndicator) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:PrepaidIndicator) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R377]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:SequenceNumeric) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:SequenceNumeric) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R378]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:AccountingCostCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:AccountingCostCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R379]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:AccountingCost) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:AccountingCost) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R380]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cbc:Name) or not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cbc:Percent) or not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cbc:BaseUnitMeasure) or not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cbc:PerUnitAmount) or not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cbc:TaxExemptionReasonCode) or not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cbc:TaxExemptionReason) or not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cbc:TierRange) or not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cbc:TierRatePercent) or not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:Name) or not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode) or not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:CurrencyCode) or not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cac:JurisdictionRegionAddress)  and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cbc:Name) or not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cbc:Percent) or not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cbc:BaseUnitMeasure) or not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cbc:PerUnitAmount) or not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cbc:TaxExemptionReasonCode) or not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cbc:TaxExemptionReason) or not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cbc:TierRange) or not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cbc:TierRatePercent) or not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:Name) or not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode) or not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:CurrencyCode) or not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cac:JurisdictionRegionAddress) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R381]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxTotal/cbc:RoundingAmount) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxTotal/cbc:RoundingAmount) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R321]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxTotal/cbc:TaxEvidenceIndicator) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxTotal/cbc:TaxEvidenceIndicator) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R322]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxTotal/cac:TaxSubtotal) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxTotal/cac:TaxSubtotal) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R323]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:PaymentMeans) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:PaymentMeans) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R383]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:OrderLineReference/cbc:UUID) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:OrderLineReference/cbc:UUID) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R384]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:OrderLineReference/cbc:LineStatusCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:OrderLineReference/cbc:LineStatusCode) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R385]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:InvoiceLine/cac:OrderLineReference/cac:OrderReference) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:OrderLineReference/cac:OrderReference) and contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R386]-A conformant SI XML invoice core data model SHOULD not have data elements not in the core.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates select="*|comment()|processing-instruction()" mode="M5"/>
  </axsl:template>

  <!--RULE -->

  <axsl:template match="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party" priority="1007" mode="M5">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party"/>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="count(cac:PartyIdentification)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(preceding::cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(cac:PartyIdentification)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(preceding::cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R387]-Element 'PartyIdentification' may occur at maximum 1 times.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="count(cac:PartyName)=1 and contains(preceding::cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(preceding::cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(cac:PartyName)=1 and contains(preceding::cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(preceding::cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R388]-Element 'PartyName' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="count(cac:PartyTaxScheme)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(preceding::cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(cac:PartyTaxScheme)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(preceding::cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R389]-Element 'PartyTaxScheme' may occur at maximum 1 times.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates select="*|comment()|processing-instruction()" mode="M5"/>
  </axsl:template>

  <!--RULE -->

  <axsl:template match="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party" priority="1006" mode="M5">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party"/>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="count(cac:PartyIdentification)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(preceding::cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(cac:PartyIdentification)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(preceding::cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R390]-Element 'PartyIdentification' may occur at maximum 1 times.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="count(cac:PartyName)=1 and contains(preceding::cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(preceding::cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(cac:PartyName)=1 and contains(preceding::cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(preceding::cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R391]-Element 'PartyName' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="count(cac:PostalAddress)=1 and contains(preceding::cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(preceding::cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(cac:PostalAddress)=1 and contains(preceding::cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(preceding::cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R392]-Element 'PostalAddress' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="count(cac:PartyTaxScheme)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(preceding::cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(cac:PartyTaxScheme)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(preceding::cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R393]-Element 'PartyTaxScheme' may occur at maximum 1 times.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates select="*|comment()|processing-instruction()" mode="M5"/>
  </axsl:template>

  <!--RULE -->

  <axsl:template match="/ubl:InvoiceLine" priority="1005" mode="M5">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:InvoiceLine"/>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="count(cac:TaxTotal)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(preceding::cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(cac:TaxTotal)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(preceding::cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R394]-Element 'TaxTotal' may occur at maximum 1 times.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="count(cac:Price)=1 and contains(preceding::cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(preceding::cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(cac:Price)=1 and contains(preceding::cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(preceding::cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R395]-Element 'Price' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates select="*|comment()|processing-instruction()" mode="M5"/>
  </axsl:template>

  <!--RULE -->

  <axsl:template match="/ubl:Invoice/cac:InvoiceLine/cac:Item" priority="1004" mode="M5">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Invoice/cac:InvoiceLine/cac:Item"/>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="count(cbc:Description)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(preceding::cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(cbc:Description)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(preceding::cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R396]-Element 'Description' may occur at maximum 1 times.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="count(cbc:Name)=1 and contains(preceding::cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(preceding::cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(cbc:Name)=1 and contains(preceding::cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(preceding::cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R397]-Element 'Name' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="count(cac:ClassifiedTaxCategory)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(preceding::cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(cac:ClassifiedTaxCategory)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(preceding::cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R398]-Element 'ClassifiedTaxCategory' may occur at maximum 1 times.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates select="*|comment()|processing-instruction()" mode="M5"/>
  </axsl:template>

  <!--RULE -->

  <axsl:template match="/ubl:Invoice/cac:InvoiceLine/cac:Price" priority="1003" mode="M5">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Invoice/cac:InvoiceLine/cac:Price"/>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="count(cac:AllowanceCharge)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(preceding::cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(cac:AllowanceCharge)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(preceding::cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R399]-Element 'AllowanceCharge' may occur at maximum 1 times.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates select="*|comment()|processing-instruction()" mode="M5"/>
  </axsl:template>

  <!--RULE -->

  <axsl:template match="/ubl:Invoice/cac:LegalMonetaryTotal" priority="1002" mode="M5">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Invoice/cac:LegalMonetaryTotal"/>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="count(cbc:TaxExclusiveAmount)=1 and contains(preceding::cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(preceding::cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(cbc:TaxExclusiveAmount)=1 and contains(preceding::cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(preceding::cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R400]-Element 'TaxExclusiveAmount' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="count(cbc:TaxInclusiveAmount)=1 and contains(preceding::cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(preceding::cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(cbc:TaxInclusiveAmount)=1 and contains(preceding::cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(preceding::cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R401]-Element 'TaxInclusiveAmount' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates select="*|comment()|processing-instruction()" mode="M5"/>
  </axsl:template>

  <!--RULE -->

  <axsl:template match="/ubl:Invoice/cac:PayeeParty" priority="1001" mode="M5">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Invoice/cac:PayeeParty"/>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="count(cac:PartyIdentification)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(preceding::cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(cac:PartyIdentification)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(preceding::cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R402]-Element 'PartyIdentification' may occur at maximum 1 times.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="count(cac:PartyName)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(preceding::cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(cac:PartyName)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(preceding::cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R403]-Element 'PartyName' may occur at maximum 1 times</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates select="*|comment()|processing-instruction()" mode="M5"/>
  </axsl:template>

  <!--RULE -->

  <axsl:template match="/ubl:Invoice/cac:PaymentMeans/cac:PayeeFinancialAccount" priority="1000" mode="M5">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Invoice/cac:PaymentMeans/cac:PayeeFinancialAccount"/>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="count(cbc:ID)=1 and contains(preceding::cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(preceding::cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(cbc:ID)=1 and contains(preceding::cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9') or not(contains(preceding::cbc:CustomizationID, 'urn:www.simplerinvoicing.org:si-xml:invoice:ver0.9'))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[SIXML-INV-R404]-Element 'ID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates select="*|comment()|processing-instruction()" mode="M5"/>
  </axsl:template>
  <axsl:template match="text()" priority="-1" mode="M5"/>
  <axsl:template match="@*|node()" priority="-2" mode="M5">
    <axsl:apply-templates select="*|comment()|processing-instruction()" mode="M5"/>
  </axsl:template>

  <!-- PEPPOL BIS4a specific rules below -->
  <!--RULE -->

  <axsl:template match="//cac:LegalMonetaryTotal" priority="1011" mode="M6">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:LegalMonetaryTotal"/>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="number(cbc:PayableAmount) &gt;= 0"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="number(cbc:PayableAmount) &gt;= 0">
          <axsl:attribute name="flag">fatal</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[EUGEN-T10-R019]-Total payable amount in an invoice MUST NOT be negative</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M6"/>
  </axsl:template>

  <!--RULE -->

  <axsl:template match="//cac:TaxSubtotal" priority="1010" mode="M6">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:TaxSubtotal"/>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="((cac:TaxCategory/cbc:ID = 'E') and (cac:TaxCategory/cbc:TaxExemptionReason or cac:TaxCategory/cbc:TaxExemptionReasonCode)) or (cac:TaxCategory/cbc:ID != 'E')"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="((cac:TaxCategory/cbc:ID = 'E') and (cac:TaxCategory/cbc:TaxExemptionReason or cac:TaxCategory/cbc:TaxExemptionReasonCode)) or (cac:TaxCategory/cbc:ID != 'E')">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[EUGEN-T10-R009]-If the category for VAT is exempt (E) then an exemption reason SHOULD be provided.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M6"/>
  </axsl:template>

  <!--RULE -->

  <axsl:template match="//cac:TaxCategory" priority="1009" mode="M6">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:TaxCategory"/>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="(parent::cac:AllowanceCharge) or (cbc:ID and cbc:Percent) or (cbc:ID = 'AE')"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(parent::cac:AllowanceCharge) or (cbc:ID and cbc:Percent) or (cbc:ID = 'AE')">
          <axsl:attribute name="flag">fatal</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[EUGEN-T10-R008]-For each tax subcategory the category ID and the applicable tax percentage MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M6"/>
  </axsl:template>

  <!--RULE -->

  <axsl:template match="//cac:AccountingSupplierParty/cac:Party" priority="1008" mode="M6">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:AccountingSupplierParty/cac:Party"/>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="(cac:PostalAddress/cbc:StreetName and cac:PostalAddress/cbc:CityName and cac:PostalAddress/cbc:PostalZone and cac:PostalAddress/cac:Country/cbc:IdentificationCode)"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cac:PostalAddress/cbc:StreetName and cac:PostalAddress/cbc:CityName and cac:PostalAddress/cbc:PostalZone and cac:PostalAddress/cac:Country/cbc:IdentificationCode)">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[EUGEN-T10-R001]-A supplier postal address in an invoice SHOULD contain at least, Street name and number, city name, zip code and country code.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M6"/>
  </axsl:template>

  <!--RULE -->

  <axsl:template match="//cac:PaymentMeans" priority="1007" mode="M6">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:PaymentMeans"/>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="((cbc:PaymentMeansCode = '31') and (cac:PayeeFinancialAccount/cbc:ID/@schemeID and cac:PayeeFinancialAccount/cbc:ID/@schemeID = 'IBAN') and (cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:ID/@schemeID and cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:ID/@schemeID = 'BIC')) or (cbc:PaymentMeansCode != '31') or ((cbc:PaymentMeansCode = '31') and  (not(cac:PayeeFinancialAccount/cbc:ID/@schemeID) or (cac:PayeeFinancialAccount/cbc:ID/@schemeID != 'IBAN')))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="((cbc:PaymentMeansCode = '31') and (cac:PayeeFinancialAccount/cbc:ID/@schemeID and cac:PayeeFinancialAccount/cbc:ID/@schemeID = 'IBAN') and (cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:ID/@schemeID and cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:ID/@schemeID = 'BIC')) or (cbc:PaymentMeansCode != '31') or ((cbc:PaymentMeansCode = '31') and (not(cac:PayeeFinancialAccount/cbc:ID/@schemeID) or (cac:PayeeFinancialAccount/cbc:ID/@schemeID != 'IBAN')))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[EUGEN-T10-R004]-If the payment means are international account transfer and the account id is IBAN then the financial institution should be identified by using the BIC id.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M6"/>
  </axsl:template>

  <!--RULE -->

  <axsl:template match="//cac:InvoicePeriod" priority="1006" mode="M6">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:InvoicePeriod"/>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="(cbc:StartDate)"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:StartDate)">
          <axsl:attribute name="flag">fatal</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[EUGEN-T10-R020]-If the invoice refers to a period, the period MUST have an start date.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="(cbc:EndDate)"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:EndDate)">
          <axsl:attribute name="flag">fatal</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[EUGEN-T10-R021]-If the invoice refers to a period, the period MUST have an end date.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M6"/>
  </axsl:template>

  <!--RULE -->

  <axsl:template match="//cac:InvoiceLine" priority="1005" mode="M6">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:InvoiceLine"/>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="(cbc:InvoicedQuantity and cbc:InvoicedQuantity/@unitCode)"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:InvoicedQuantity and cbc:InvoicedQuantity/@unitCode)">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[EUGEN-T10-R003]-Each invoice line SHOULD contain the quantity and unit of measure</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M6"/>
  </axsl:template>

  <!--RULE -->

  <axsl:template match="/ubl:Invoice" priority="1004" mode="M6">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Invoice"/>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="((cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']/cbc:TaxAmount) and (cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or not((cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT'])))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="((cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']/cbc:TaxAmount) and (cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or not((cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT'])))">
          <axsl:attribute name="flag">fatal</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[EUGEN-T10-R007]-If the VAT total amount in an invoice exists it MUST contain the suppliers VAT number.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cac:PayeeParty) or (cac:PayeeParty/cac:PartyName/cbc:Name)"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty) or (cac:PayeeParty/cac:PartyName/cbc:Name)">
          <axsl:attribute name="flag">fatal</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[EUGEN-T10-R010]-If payee information is provided then the payee name MUST be specified.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="starts-with(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID,//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and (//cac:TaxCategory/cbc:ID) = 'AE' or not((//cac:TaxCategory/cbc:ID) = 'AE')"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="starts-with(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID,//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and (//cac:TaxCategory/cbc:ID) = 'AE' or not((//cac:TaxCategory/cbc:ID) = 'AE')">
          <axsl:attribute name="flag">fatal</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[EUGEN-T10-R015]-IF VAT = "AE" (reverse charge) THEN it MUST contain Supplier VAT id and Customer VAT</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="(((//cac:TaxCategory/cbc:ID) = 'AE')  and not((//cac:TaxCategory/cbc:ID) != 'AE' )) or not((//cac:TaxCategory/cbc:ID) = 'AE') or not(//cac:TaxCategory)"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(((//cac:TaxCategory/cbc:ID) = 'AE') and not((//cac:TaxCategory/cbc:ID) != 'AE' )) or not((//cac:TaxCategory/cbc:ID) = 'AE') or not(//cac:TaxCategory)">
          <axsl:attribute name="flag">fatal</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[EUGEN-T10-R016]-IF VAT = "AE" (reverse charge) THEN VAT MAY NOT contain other VAT categories.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="(//cbc:TaxExclusiveAmount = //cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cbc:ID='AE']/cbc:TaxableAmount) and (//cac:TaxCategory/cbc:ID) = 'AE' or not((//cac:TaxCategory/cbc:ID) = 'AE')"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(//cbc:TaxExclusiveAmount = //cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cbc:ID='AE']/cbc:TaxableAmount) and (//cac:TaxCategory/cbc:ID) = 'AE' or not((//cac:TaxCategory/cbc:ID) = 'AE')">
          <axsl:attribute name="flag">fatal</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[EUGEN-T10-R017]-IF VAT = "AE" (reverse charge) THEN The taxable amount MUST equal the invoice total without VAT amount.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="//cac:TaxTotal/cbc:TaxAmount = 0 and (//cac:TaxCategory/cbc:ID) = 'AE' or not((//cac:TaxCategory/cbc:ID) = 'AE')"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="//cac:TaxTotal/cbc:TaxAmount = 0 and (//cac:TaxCategory/cbc:ID) = 'AE' or not((//cac:TaxCategory/cbc:ID) = 'AE')">
          <axsl:attribute name="flag">fatal</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[EUGEN-T10-R018]-IF VAT = "AE" (reverse charge) THEN VAT tax amount MUST be zero.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(//@currencyID != //cbc:DocumentCurrencyCode)"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(//@currencyID != //cbc:DocumentCurrencyCode)">
          <axsl:attribute name="flag">fatal</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[EUGEN-T10-R024]-Currency Identifier MUST be in stated in the currency stated on header level.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M6"/>
  </axsl:template>

  <!--RULE -->

  <axsl:template match="//cac:Delivery/cac:DeliveryLocation/cac:Address" priority="1003" mode="M6">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:Delivery/cac:DeliveryLocation/cac:Address"/>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="(cbc:CityName and cbc:PostalZone and cac:Country/cbc:IdentificationCode)"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:CityName and cbc:PostalZone and cac:Country/cbc:IdentificationCode)">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[EUGEN-T10-R005]-A Delivery address in an invoice SHOULD contain at least, city, zip code and country code.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M6"/>
  </axsl:template>

  <!--RULE -->

  <axsl:template match="//cac:AccountingCustomerParty/cac:Party" priority="1002" mode="M6">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:AccountingCustomerParty/cac:Party"/>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="(cac:PostalAddress/cbc:StreetName and cac:PostalAddress/cbc:CityName and cac:PostalAddress/cbc:PostalZone and cac:PostalAddress/cac:Country/cbc:IdentificationCode)"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cac:PostalAddress/cbc:StreetName and cac:PostalAddress/cbc:CityName and cac:PostalAddress/cbc:PostalZone and cac:PostalAddress/cac:Country/cbc:IdentificationCode)">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[EUGEN-T10-R002]-A customer postal address in an invoice SHOULD contain at least, Street name and number, city name, zip code and country code.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M6"/>
  </axsl:template>

  <!--RULE -->

  <axsl:template match="//cac:Item/cac:ClassifiedTaxCategory" priority="1001" mode="M6">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:Item/cac:ClassifiedTaxCategory"/>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="(//cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']/cbc:TaxAmount and cbc:ID) or not((//cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(//cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']/cbc:TaxAmount and cbc:ID) or not((//cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']))">
          <axsl:attribute name="flag">fatal</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[EUGEN-T10-R011]-If the VAT total amount in an invoice exists then each invoice line item MUST have a VAT category ID.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M6"/>
  </axsl:template>

  <!--RULE -->

  <axsl:template match="//cac:AllowanceCharge" priority="1000" mode="M6">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:AllowanceCharge"/>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="(((//cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']/cbc:TaxAmount) and (cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT')) or not((//cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT'])) and (local-name(parent:: node())=&#34;Invoice&#34;)) or not(local-name(parent:: node())=&#34;Invoice&#34;)"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(((//cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']/cbc:TaxAmount) and (cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT')) or not((//cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT'])) and (local-name(parent:: node())=&#34;Invoice&#34;)) or not(local-name(parent:: node())=&#34;Invoice&#34;)">
          <axsl:attribute name="flag">fatal</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[EUGEN-T10-R006]-If the VAT total amount in an invoice exists then an Allowances Charges amount on document level MUST have Tax category for VAT.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="number(cbc:Amount)&gt;=0"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="number(cbc:Amount)&gt;=0">
          <axsl:attribute name="flag">fatal</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[EUGEN-T10-R022]-An allowance or charge amount MUST NOT be negative.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="(cbc:AllowanceChargeReason)"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:AllowanceChargeReason)">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[EUGEN-T10-R023]-AllowanceChargeReason text SHOULD be specified for all allowances and charges</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="not(cbc:MultiplierFactorNumeric) or number(cbc:MultiplierFactorNumeric) &gt;=0"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cbc:MultiplierFactorNumeric) or number(cbc:MultiplierFactorNumeric) &gt;=0">
          <axsl:attribute name="flag">fatal</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[EUGEN-T10-R012]-An allowance percentage MUST NOT be negative.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="(cbc:MultiplierFactorNumeric and cbc:BaseAmount) or (not(cbc:MultiplierFactorNumeric) and not(cbc:BaseAmount)) "/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:MultiplierFactorNumeric and cbc:BaseAmount) or (not(cbc:MultiplierFactorNumeric) and not(cbc:BaseAmount))">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[EUGEN-T10-R013]-In allowances, both or none of percentage and base amount SHOULD be provided</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M6"/>
  </axsl:template>
  <axsl:template match="text()" priority="-1" mode="M6"/>
  <axsl:template match="@*|node()" priority="-2" mode="M6">
    <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M6"/>
  </axsl:template>

  <!--PATTERN CodesT10-->


  <!--RULE -->

  <axsl:template match="cac:FinancialInstitution/cbc:ID//@schemeID" priority="1006" mode="M7">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:FinancialInstitution/cbc:ID//@schemeID"/>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="( ( not(contains(normalize-space(.),' ')) and contains( ' BIC ',concat(' ',normalize-space(.),' ') ) ) )"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="( ( not(contains(normalize-space(.),' ')) and contains( ' BIC ',concat(' ',normalize-space(.),' ') ) ) )">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[PCL-010-002]-If FinancialAccountID is IBAN then Financial InstitutionID SHOULD be BIC code.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M7"/>
  </axsl:template>

  <!--RULE -->

  <axsl:template match="cac:PostalAddress/cbc:ID//@schemeID" priority="1005" mode="M7">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:PostalAddress/cbc:ID//@schemeID"/>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="( ( not(contains(normalize-space(.),' ')) and contains( ' GLN ',concat(' ',normalize-space(.),' ') ) ) )"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="( ( not(contains(normalize-space(.),' ')) and contains( ' GLN ',concat(' ',normalize-space(.),' ') ) ) )">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[PCL-010-003]-Postal address identifiers SHOULD be GLN.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M7"/>
  </axsl:template>

  <!--RULE -->

  <axsl:template match="cac:Delivery/cac:DeliveryLocation/cbc:ID//@schemeID" priority="1004" mode="M7">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:Delivery/cac:DeliveryLocation/cbc:ID//@schemeID"/>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="( ( not(contains(normalize-space(.),' ')) and contains( ' GLN ',concat(' ',normalize-space(.),' ') ) ) )"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="( ( not(contains(normalize-space(.),' ')) and contains( ' GLN ',concat(' ',normalize-space(.),' ') ) ) )">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[PCL-010-004]-Location identifiers SHOULD be GLN</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M7"/>
  </axsl:template>

  <!--RULE -->

  <axsl:template match="cac:Item/cac:StandardItemIdentification/cbc:ID//@schemeID" priority="1003" mode="M7">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:Item/cac:StandardItemIdentification/cbc:ID//@schemeID"/>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="( ( not(contains(normalize-space(.),' ')) and contains( ' GTIN ',concat(' ',normalize-space(.),' ') ) ) )"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="( ( not(contains(normalize-space(.),' ')) and contains( ' GTIN ',concat(' ',normalize-space(.),' ') ) ) )">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[PCL-010-005]-Standard item identifiers SHOULD be GTIN.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M7"/>
  </axsl:template>

  <!--RULE -->

  <axsl:template match="cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode//@listID" priority="1002" mode="M7">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode//@listID"/>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="( ( not(contains(normalize-space(.),' ')) and contains( ' UNSPSC eCLASS CPV ',concat(' ',normalize-space(.),' ') ) ) )"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="( ( not(contains(normalize-space(.),' ')) and contains( ' UNSPSC eCLASS CPV ',concat(' ',normalize-space(.),' ') ) ) )">
          <axsl:attribute name="flag">warning</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[PCL-010-006]-Commodity classification SHOULD be one of UNSPSC, eClass or CPV.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M7"/>
  </axsl:template>

  <!--RULE -->

  <axsl:template match="cac:PartyIdentification/cbc:ID//@schemeID" priority="1001" mode="M7">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:PartyIdentification/cbc:ID//@schemeID"/>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="( ( not(contains(normalize-space(.),' ')) and contains( ' GLN DUNS IBAN DK:CPR DK:CVR DK:P DK:SE DK:VANS IT:VAT IT:CF IT:FTI IT:SIA IT:SECETI NO:ORGNR NO:VAT HU:VAT SE:ORGNR FI:OVT EU:VAT EU:REID FR:SIRET AT:VAT AT:GOV AT:CID IS:KT IBAN AT:KUR ES:VAT ',concat(' ',normalize-space(.),' ') ) ) )"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="( ( not(contains(normalize-space(.),' ')) and contains( ' GLN DUNS IBAN DK:CPR DK:CVR DK:P DK:SE DK:VANS IT:VAT IT:CF IT:FTI IT:SIA IT:SECETI NO:ORGNR NO:VAT HU:VAT SE:ORGNR FI:OVT EU:VAT EU:REID FR:SIRET AT:VAT AT:GOV AT:CID IS:KT IBAN AT:KUR ES:VAT ',concat(' ',normalize-space(.),' ') ) ) )">
          <axsl:attribute name="flag">fatal</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[PCL-010-008]-Party Identifiers MUST use the PEPPOL PartyID list</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M7"/>
  </axsl:template>

  <!--RULE -->

  <axsl:template match="cbc:EndpointID//@schemeID" priority="1000" mode="M7">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cbc:EndpointID//@schemeID"/>

    <!--ASSERT -->

    <axsl:choose>
      <axsl:when test="( ( not(contains(normalize-space(.),' ')) and contains( ' GLN DUNS IBAN DK:CPR DK:CVR DK:P DK:SE DK:VANS IT:VAT IT:CF IT:FTI IT:SIA IT:SECETI NO:ORGNR NO:VAT HU:VAT SE:ORGNR FI:OVT EU:VAT EU:REID FR:SIRET AT:VAT AT:GOV AT:CID IS:KT IBAN AT:KUR ES:VAT ',concat(' ',normalize-space(.),' ') ) ) )"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="( ( not(contains(normalize-space(.),' ')) and contains( ' GLN DUNS IBAN DK:CPR DK:CVR DK:P DK:SE DK:VANS IT:VAT IT:CF IT:FTI IT:SIA IT:SECETI NO:ORGNR NO:VAT HU:VAT SE:ORGNR FI:OVT EU:VAT EU:REID FR:SIRET AT:VAT AT:GOV AT:CID IS:KT IBAN AT:KUR ES:VAT ',concat(' ',normalize-space(.),' ') ) ) )">
          <axsl:attribute name="flag">fatal</axsl:attribute>
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>[PCL-010-009]-Endpoint Identifiers MUST use the PEPPOL PartyID list.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M7"/>
  </axsl:template>
  <axsl:template match="text()" priority="-1" mode="M7"/>
  <axsl:template match="@*|node()" priority="-2" mode="M7">
    <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M7"/>
  </axsl:template>
</axsl:stylesheet>