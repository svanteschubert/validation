<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<!-- Licensed under Apache License version 2.0 -->
<xsl:stylesheet xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:iso="http://purl.oclc.org/dsdl/schematron" xmlns:qdt="urn:un:unece:uncefact:data:standard:QualifiedDataType:100" xmlns:ram="urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:100" xmlns:rsm="urn:un:unece:uncefact:data:standard:CrossIndustryInvoice:100" xmlns:saxon="http://saxon.sf.net/" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:udt="urn:un:unece:uncefact:data:standard:UnqualifiedDataType:100" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
<!--Implementers: please note that overriding process-prolog or process-root is 
    the preferred method for meta-stylesheets to use where possible. -->

<xsl:param name="archiveDirParameter" />
  <xsl:param name="archiveNameParameter" />
  <xsl:param name="fileNameParameter" />
  <xsl:param name="fileDirParameter" />
  <xsl:variable name="document-uri">
    <xsl:value-of select="document-uri(/)" />
  </xsl:variable>

<!--PHASES-->


<!--PROLOG-->
<xsl:output indent="yes" method="xml" omit-xml-declaration="no" standalone="yes" />

<!--XSD TYPES FOR XSLT2-->


<!--KEYS AND FUNCTIONS-->


<!--DEFAULT RULES-->


<!--MODE: SCHEMATRON-SELECT-FULL-PATH-->
<!--This mode can be used to generate an ugly though full XPath for locators-->
<xsl:template match="*" mode="schematron-select-full-path">
    <xsl:apply-templates mode="schematron-get-full-path" select="." />
  </xsl:template>

<!--MODE: SCHEMATRON-FULL-PATH-->
<!--This mode can be used to generate an ugly though full XPath for locators-->
<xsl:template match="*" mode="schematron-get-full-path">
    <xsl:apply-templates mode="schematron-get-full-path" select="parent::*" />
    <xsl:text>/</xsl:text>
    <xsl:choose>
      <xsl:when test="namespace-uri()=''">
        <xsl:value-of select="name()" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>*:</xsl:text>
        <xsl:value-of select="local-name()" />
        <xsl:text>[namespace-uri()='</xsl:text>
        <xsl:value-of select="namespace-uri()" />
        <xsl:text>']</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="preceding" select="count(preceding-sibling::*[local-name()=local-name(current())                                   and namespace-uri() = namespace-uri(current())])" />
    <xsl:text>[</xsl:text>
    <xsl:value-of select="1+ $preceding" />
    <xsl:text>]</xsl:text>
  </xsl:template>
  <xsl:template match="@*" mode="schematron-get-full-path">
    <xsl:apply-templates mode="schematron-get-full-path" select="parent::*" />
    <xsl:text>/</xsl:text>
    <xsl:choose>
      <xsl:when test="namespace-uri()=''">@<xsl:value-of select="name()" />
</xsl:when>
      <xsl:otherwise>
        <xsl:text>@*[local-name()='</xsl:text>
        <xsl:value-of select="local-name()" />
        <xsl:text>' and namespace-uri()='</xsl:text>
        <xsl:value-of select="namespace-uri()" />
        <xsl:text>']</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

<!--MODE: SCHEMATRON-FULL-PATH-2-->
<!--This mode can be used to generate prefixed XPath for humans-->
<xsl:template match="node() | @*" mode="schematron-get-full-path-2">
    <xsl:for-each select="ancestor-or-self::*">
      <xsl:text>/</xsl:text>
      <xsl:value-of select="name(.)" />
      <xsl:if test="preceding-sibling::*[name(.)=name(current())]">
        <xsl:text>[</xsl:text>
        <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />
        <xsl:text>]</xsl:text>
      </xsl:if>
    </xsl:for-each>
    <xsl:if test="not(self::*)">
      <xsl:text />/@<xsl:value-of select="name(.)" />
    </xsl:if>
  </xsl:template>
<!--MODE: SCHEMATRON-FULL-PATH-3-->
<!--This mode can be used to generate prefixed XPath for humans 
	(Top-level element has index)-->

<xsl:template match="node() | @*" mode="schematron-get-full-path-3">
    <xsl:for-each select="ancestor-or-self::*">
      <xsl:text>/</xsl:text>
      <xsl:value-of select="name(.)" />
      <xsl:if test="parent::*">
        <xsl:text>[</xsl:text>
        <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />
        <xsl:text>]</xsl:text>
      </xsl:if>
    </xsl:for-each>
    <xsl:if test="not(self::*)">
      <xsl:text />/@<xsl:value-of select="name(.)" />
    </xsl:if>
  </xsl:template>

<!--MODE: GENERATE-ID-FROM-PATH -->
<xsl:template match="/" mode="generate-id-from-path" />
  <xsl:template match="text()" mode="generate-id-from-path">
    <xsl:apply-templates mode="generate-id-from-path" select="parent::*" />
    <xsl:value-of select="concat('.text-', 1+count(preceding-sibling::text()), '-')" />
  </xsl:template>
  <xsl:template match="comment()" mode="generate-id-from-path">
    <xsl:apply-templates mode="generate-id-from-path" select="parent::*" />
    <xsl:value-of select="concat('.comment-', 1+count(preceding-sibling::comment()), '-')" />
  </xsl:template>
  <xsl:template match="processing-instruction()" mode="generate-id-from-path">
    <xsl:apply-templates mode="generate-id-from-path" select="parent::*" />
    <xsl:value-of select="concat('.processing-instruction-', 1+count(preceding-sibling::processing-instruction()), '-')" />
  </xsl:template>
  <xsl:template match="@*" mode="generate-id-from-path">
    <xsl:apply-templates mode="generate-id-from-path" select="parent::*" />
    <xsl:value-of select="concat('.@', name())" />
  </xsl:template>
  <xsl:template match="*" mode="generate-id-from-path" priority="-0.5">
    <xsl:apply-templates mode="generate-id-from-path" select="parent::*" />
    <xsl:text>.</xsl:text>
    <xsl:value-of select="concat('.',name(),'-',1+count(preceding-sibling::*[name()=name(current())]),'-')" />
  </xsl:template>

<!--MODE: GENERATE-ID-2 -->
<xsl:template match="/" mode="generate-id-2">U</xsl:template>
  <xsl:template match="*" mode="generate-id-2" priority="2">
    <xsl:text>U</xsl:text>
    <xsl:number count="*" level="multiple" />
  </xsl:template>
  <xsl:template match="node()" mode="generate-id-2">
    <xsl:text>U.</xsl:text>
    <xsl:number count="*" level="multiple" />
    <xsl:text>n</xsl:text>
    <xsl:number count="node()" />
  </xsl:template>
  <xsl:template match="@*" mode="generate-id-2">
    <xsl:text>U.</xsl:text>
    <xsl:number count="*" level="multiple" />
    <xsl:text>_</xsl:text>
    <xsl:value-of select="string-length(local-name(.))" />
    <xsl:text>_</xsl:text>
    <xsl:value-of select="translate(name(),':','.')" />
  </xsl:template>
<!--Strip characters-->  <xsl:template match="text()" priority="-1" />

<!--SCHEMA SETUP-->
<xsl:template match="/">
    <svrl:schematron-output schemaVersion="iso" title="Schema for Factur-X; 1.0.07; EN16931-COMPLIANT (FULLY)">
      <xsl:comment>
        <xsl:value-of select="$archiveDirParameter" />   
		 <xsl:value-of select="$archiveNameParameter" />  
		 <xsl:value-of select="$fileNameParameter" />  
		 <xsl:value-of select="$fileDirParameter" />
      </xsl:comment>
      <svrl:ns-prefix-in-attribute-values prefix="rsm" uri="urn:un:unece:uncefact:data:standard:CrossIndustryInvoice:100" />
      <svrl:ns-prefix-in-attribute-values prefix="qdt" uri="urn:un:unece:uncefact:data:standard:QualifiedDataType:100" />
      <svrl:ns-prefix-in-attribute-values prefix="ram" uri="urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:100" />
      <svrl:ns-prefix-in-attribute-values prefix="udt" uri="urn:un:unece:uncefact:data:standard:UnqualifiedDataType:100" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M5" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M6" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M7" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M8" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M9" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M10" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M11" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M12" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M13" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M14" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M15" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M16" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M17" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M18" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M19" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M20" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M21" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M22" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M23" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M24" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M25" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M26" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M27" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M28" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M29" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M30" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M31" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M32" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M33" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M34" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M35" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M36" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M37" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M38" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M39" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M40" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M41" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M42" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M43" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M44" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M45" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M46" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M47" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M48" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M49" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M50" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M51" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M52" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M53" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M54" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M55" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M56" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M57" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M58" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M59" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M60" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M61" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M62" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M63" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M64" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M65" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M66" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M67" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M68" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M69" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M70" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M71" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M72" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M73" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M74" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M75" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M76" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M77" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M78" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M79" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M80" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M81" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M82" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M83" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M84" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M85" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M86" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M87" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M88" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M89" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M90" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M91" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M92" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M93" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M94" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M95" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M96" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M97" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M98" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M99" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M100" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M101" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M102" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M103" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M104" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M105" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M106" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M107" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M108" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M109" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M110" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M111" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M112" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M113" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M114" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M115" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M116" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M117" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M118" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M119" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M120" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M121" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M122" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M123" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M124" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M125" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M126" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M127" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M128" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M129" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M130" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M131" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M132" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M133" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M134" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M135" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M136" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M137" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M138" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M139" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M140" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M141" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M142" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M143" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M144" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M145" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M146" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M147" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M148" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M149" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M150" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M151" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M152" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M153" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M154" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M155" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M156" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M157" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M158" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M159" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M160" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M161" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M162" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M163" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M164" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M165" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M166" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M167" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M168" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M169" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M170" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M171" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M172" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M173" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M174" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M175" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M176" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M177" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M178" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M179" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M180" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M181" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M182" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M183" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M184" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M185" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M186" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M187" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M188" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M189" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M190" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M191" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M192" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M193" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M194" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M195" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M196" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M197" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M198" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M199" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M200" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M201" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M202" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M203" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M204" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M205" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M206" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M207" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M208" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M209" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M210" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M211" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M212" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M213" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M214" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M215" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M216" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M217" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M218" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M219" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M220" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M221" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M222" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M223" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M224" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M225" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M226" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M227" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M228" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M229" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M230" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M231" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M232" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M233" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M234" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M235" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M236" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M237" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M238" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M239" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M240" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M241" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M242" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M243" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M244" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M245" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M246" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M247" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M248" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M249" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M250" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M251" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M252" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M253" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M254" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M255" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M256" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M257" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M258" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M259" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M260" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M261" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M262" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M263" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M264" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M265" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M266" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M267" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M268" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M269" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M270" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M271" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M272" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M273" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M274" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M275" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M276" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M277" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M278" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M279" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M280" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M281" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M282" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M283" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M284" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M285" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M286" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M287" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M288" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M289" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M290" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M291" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M292" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M293" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M294" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M295" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M296" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M297" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M298" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M299" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M300" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M301" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M302" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M303" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M304" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M305" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M306" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M307" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M308" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M309" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M310" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M311" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M312" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M313" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M314" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M315" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M316" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M317" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M318" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M319" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M320" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M321" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M322" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M323" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M324" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M325" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M326" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M327" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M328" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M329" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M330" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M331" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M332" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M333" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M334" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M335" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M336" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M337" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M338" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M339" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M340" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M341" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M342" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M343" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M344" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M345" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M346" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M347" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M348" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M349" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M350" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M351" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M352" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M353" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M354" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M355" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M356" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M357" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M358" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M359" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M360" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M361" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M362" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M363" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M364" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M365" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M366" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M367" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M368" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M369" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M370" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M371" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M372" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M373" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M374" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M375" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M376" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M377" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M378" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M379" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M380" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M381" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M382" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M383" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M384" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M385" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M386" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M387" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M388" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M389" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M390" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M391" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M392" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M393" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M394" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M395" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M396" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M397" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M398" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M399" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M400" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M401" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M402" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M403" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M404" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M405" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M406" select="/" />
    </svrl:schematron-output>
  </xsl:template>

<!--SCHEMATRON PATTERNS-->
<svrl:text>Schema for Factur-X; 1.0.07; EN16931-COMPLIANT (FULLY)</svrl:text>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="//ram:AdditionalReferencedDocument" mode="M5" priority="1000">
    <svrl:fired-rule context="//ram:AdditionalReferencedDocument" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(ram:IssuerAssignedID!='')" />
      <xsl:otherwise>
        <svrl:failed-assert test="(ram:IssuerAssignedID!='')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-52]-Each Additional supporting document (BG-24) shall contain a Supporting document reference (BT-122).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M5" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M5" priority="-1" />
  <xsl:template match="@*|node()" mode="M5" priority="-2">
    <xsl:apply-templates mode="M5" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax" mode="M6" priority="1000">
    <svrl:fired-rule context="//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(ram:BasisAmount)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(ram:BasisAmount)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-45]-Each VAT breakdown (BG-23) shall have a VAT category taxable amount (BT-116).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(ram:CalculatedAmount)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(ram:CalculatedAmount)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-46]-Each VAT breakdown (BG-23) shall have a VAT category tax amount (BT-117).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(ram:CategoryCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(ram:CategoryCode)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-47]-Each VAT breakdown (BG-23) shall be defined through a VAT category code (BT-118).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(ram:RateApplicablePercent) or (ram:CategoryCode = 'O')" />
      <xsl:otherwise>
        <svrl:failed-assert test="(ram:RateApplicablePercent) or (ram:CategoryCode = 'O')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-48]-Each VAT breakdown (BG-23) shall have a VAT category rate (BT-119), except if the Invoice is not subject to VAT.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((ram:TaxPointDate) and not (ram:DueDateTypeCode)) or (not (ram:TaxPointDate) and (ram:DueDateTypeCode)) or (not (ram:TaxPointDate) and not (ram:DueDateTypeCode))" />
      <xsl:otherwise>
        <svrl:failed-assert test="((ram:TaxPointDate) and not (ram:DueDateTypeCode)) or (not (ram:TaxPointDate) and (ram:DueDateTypeCode)) or (not (ram:TaxPointDate) and not (ram:DueDateTypeCode))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-CO-03]-Value added tax point date (BT-7) and Value added tax point date code (BT-8) are mutually exclusive.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(round(.[normalize-space(upper-case(ram:TypeCode)) = 'VAT']/xs:decimal(ram:RateApplicablePercent)) = 0 and (round(xs:decimal(ram:CalculatedAmount)) = 0)) or (round(.[normalize-space(upper-case(ram:TypeCode)) = 'VAT']/xs:decimal(ram:RateApplicablePercent)) != 0 and ((abs(xs:decimal(ram:CalculatedAmount)) - 1 &lt;= round(abs(xs:decimal(ram:BasisAmount)) * (.[normalize-space(upper-case(ram:TypeCode)) = 'VAT']/xs:decimal(ram:RateApplicablePercent) div 100) * 10 * 10) div 100 ) and (abs(xs:decimal(ram:CalculatedAmount)) + 1 >= round(abs(xs:decimal(ram:BasisAmount)) * (.[normalize-space(upper-case(ram:TypeCode)) = 'VAT']/xs:decimal(ram:RateApplicablePercent) div 100) * 10 * 10) div 100 ))) or (not(exists(.[normalize-space(upper-case(ram:TypeCode))='VAT']/xs:decimal(ram:RateApplicablePercent))) and (round(xs:decimal(ram:CalculatedAmount)) = 0))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(round(.[normalize-space(upper-case(ram:TypeCode)) = 'VAT']/xs:decimal(ram:RateApplicablePercent)) = 0 and (round(xs:decimal(ram:CalculatedAmount)) = 0)) or (round(.[normalize-space(upper-case(ram:TypeCode)) = 'VAT']/xs:decimal(ram:RateApplicablePercent)) != 0 and ((abs(xs:decimal(ram:CalculatedAmount)) - 1 &lt;= round(abs(xs:decimal(ram:BasisAmount)) * (.[normalize-space(upper-case(ram:TypeCode)) = 'VAT']/xs:decimal(ram:RateApplicablePercent) div 100) * 10 * 10) div 100 ) and (abs(xs:decimal(ram:CalculatedAmount)) + 1 >= round(abs(xs:decimal(ram:BasisAmount)) * (.[normalize-space(upper-case(ram:TypeCode)) = 'VAT']/xs:decimal(ram:RateApplicablePercent) div 100) * 10 * 10) div 100 ))) or (not(exists(.[normalize-space(upper-case(ram:TypeCode))='VAT']/xs:decimal(ram:RateApplicablePercent))) and (round(xs:decimal(ram:CalculatedAmount)) = 0))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-CO-17]-VAT category tax amount (BT-117) = VAT category taxable amount (BT-116) x (VAT category rate (BT-119) / 100), rounded to two decimals.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(ram:BasisAmount,'.'))&lt;=2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(ram:BasisAmount,'.'))&lt;=2">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-DEC-19]-The allowed maximum number of decimals for the VAT category taxable amount (BT-116) is 2.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(ram:CalculatedAmount,'.'))&lt;=2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(ram:CalculatedAmount,'.'))&lt;=2">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-DEC-20]-The allowed maximum number of decimals for the VAT category tax amount (BT-117) is 2.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M6" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M6" priority="-1" />
  <xsl:template match="@*|node()" mode="M6" priority="-2">
    <xsl:apply-templates mode="M6" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode[. = 'Z']" mode="M7" priority="1000">
    <svrl:fired-rule context="//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode[. = 'Z']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(../ram:BasisAmount -1 &lt; (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = 'Z']/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount))*10*10)div 100) + (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[(ram:ChargeIndicator/udt:Indicator cast as xs:boolean)=true() and ram:CategoryTradeTax/ram:CategoryCode='Z']/xs:decimal(ram:ActualAmount))*10*10)div 100) - (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[(ram:ChargeIndicator/udt:Indicator cast as xs:boolean)=false() and ram:CategoryTradeTax/ram:CategoryCode='Z']/xs:decimal(ram:ActualAmount))*10*10)div 100)) and (../ram:BasisAmount +1 > (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = 'Z']/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount))*10*10)div 100) + (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[(ram:ChargeIndicator/udt:Indicator cast as xs:boolean)=true() and ram:CategoryTradeTax/ram:CategoryCode='Z']/xs:decimal(ram:ActualAmount))*10*10)div 100) - (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[(ram:ChargeIndicator/udt:Indicator cast as xs:boolean)=false() and ram:CategoryTradeTax/ram:CategoryCode='Z']/xs:decimal(ram:ActualAmount))*10*10)div 100))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(../ram:BasisAmount -1 &lt; (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = 'Z']/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount))*10*10)div 100) + (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[(ram:ChargeIndicator/udt:Indicator cast as xs:boolean)=true() and ram:CategoryTradeTax/ram:CategoryCode='Z']/xs:decimal(ram:ActualAmount))*10*10)div 100) - (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[(ram:ChargeIndicator/udt:Indicator cast as xs:boolean)=false() and ram:CategoryTradeTax/ram:CategoryCode='Z']/xs:decimal(ram:ActualAmount))*10*10)div 100)) and (../ram:BasisAmount +1 > (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = 'Z']/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount))*10*10)div 100) + (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[(ram:ChargeIndicator/udt:Indicator cast as xs:boolean)=true() and ram:CategoryTradeTax/ram:CategoryCode='Z']/xs:decimal(ram:ActualAmount))*10*10)div 100) - (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[(ram:ChargeIndicator/udt:Indicator cast as xs:boolean)=false() and ram:CategoryTradeTax/ram:CategoryCode='Z']/xs:decimal(ram:ActualAmount))*10*10)div 100))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-Z-08]-In a VAT breakdown (BG-23) where VAT category code (BT-118) is "Zero rated" the VAT category taxable amount (BT-116) shall equal the sum of Invoice line net amount (BT-131) minus the sum of Document level allowance amounts (BT-92) plus the sum of Document level charge amounts (BT-99) where the VAT category codes (BT-151, BT-95, BT-102) are "Zero rated".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="../ram:CalculatedAmount = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="../ram:CalculatedAmount = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-Z-09]-The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where VAT category code (BT-118) is "Zero rated" shall equal 0 (zero).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(../ram:ExemptionReason) and not (../ram:ExemptionReasonCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(../ram:ExemptionReason) and not (../ram:ExemptionReasonCode)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-Z-10]-A VAT Breakdown (BG-23) with VAT Category code (BT-118) "Zero rated" shall not have a VAT exemption reason code (BT-121) or VAT exemption reason text (BT-120).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M7" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M7" priority="-1" />
  <xsl:template match="@*|node()" mode="M7" priority="-2">
    <xsl:apply-templates mode="M7" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode[.='S']" mode="M8" priority="1000">
    <svrl:fired-rule context="//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode[.='S']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(abs(xs:decimal(../ram:CalculatedAmount)) - 1 &lt; round(abs(xs:decimal(../ram:BasisAmount)) * ../ram:RateApplicablePercent) div 100 ) and (abs(xs:decimal(../ram:CalculatedAmount)) + 1 > round(abs(xs:decimal(../ram:BasisAmount)) * ../ram:RateApplicablePercent) div 100 )" />
      <xsl:otherwise>
        <svrl:failed-assert test="(abs(xs:decimal(../ram:CalculatedAmount)) - 1 &lt; round(abs(xs:decimal(../ram:BasisAmount)) * ../ram:RateApplicablePercent) div 100 ) and (abs(xs:decimal(../ram:CalculatedAmount)) + 1 > round(abs(xs:decimal(../ram:BasisAmount)) * ../ram:RateApplicablePercent) div 100 )">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-S-09]-The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where VAT category code (BT-118) is "Standard rated" shall equal the VAT category taxable amount (BT-116) multiplied by the VAT category rate (BT-119).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(../ram:ExemptionReason) and not (../ram:ExemptionReasonCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(../ram:ExemptionReason) and not (../ram:ExemptionReasonCode)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-S-10]-A VAT Breakdown (BG-23) with VAT Category code (BT-118) "Standard rate" shall not have a VAT exemption reason code (BT-121) or VAT exemption reason text (BT-120).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="every $rate in ../ram:RateApplicablePercent/xs:decimal(.) satisfies (../ram:BasisAmount = (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = 'S' and ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 10 * 10) div 100 + round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='S' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 10 * 10) div 100 - round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode='S' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 10 * 10) div 100))" />
      <xsl:otherwise>
        <svrl:failed-assert test="every $rate in ../ram:RateApplicablePercent/xs:decimal(.) satisfies (../ram:BasisAmount = (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = 'S' and ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 10 * 10) div 100 + round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='S' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 10 * 10) div 100 - round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode='S' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 10 * 10) div 100))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-S-08]-For each different value of VAT category rate (BT-119) where the VAT category code (BT-118) is "Standard rated", the VAT category taxable amount (BT-116) in a VAT breakdown (BG-23) shall equal the sum of Invoice line net amounts (BT-131) plus the sum of document level charge amounts (BT-99) minus the sum of document level allowance amounts (BT-92) where the VAT category code (BT-151, BT-102, BT-95) is "Standard rated" and the VAT rate (BT-152, BT-103, BT-96) equals the VAT category rate (BT-119).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M8" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M8" priority="-1" />
  <xsl:template match="@*|node()" mode="M8" priority="-2">
    <xsl:apply-templates mode="M8" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="//ram:ApplicableHeaderTradeSettlement/ram:BillingSpecifiedPeriod" mode="M9" priority="1000">
    <svrl:fired-rule context="//ram:ApplicableHeaderTradeSettlement/ram:BillingSpecifiedPeriod" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(ram:EndDateTime/udt:DateTimeString[@format = '102']) >= (ram:StartDateTime/udt:DateTimeString[@format = '102']) or not (ram:EndDateTime) or not (ram:StartDateTime)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(ram:EndDateTime/udt:DateTimeString[@format = '102']) >= (ram:StartDateTime/udt:DateTimeString[@format = '102']) or not (ram:EndDateTime) or not (ram:StartDateTime)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-29]-If both Invoicing period start date (BT-73) and Invoicing period end date (BT-74) are given then the Invoicing period end date (BT-74) shall be later or equal to the Invoicing period start date (BT-73).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(ram:StartDateTime) or (ram:EndDateTime)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(ram:StartDateTime) or (ram:EndDateTime)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-CO-19]-If Invoicing period (BG-14) is used, the Invoicing period start date (BT-73) or the Invoicing period end date (BT-74) shall be filled, or both.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M9" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M9" priority="-1" />
  <xsl:template match="@*|node()" mode="M9" priority="-2">
    <xsl:apply-templates mode="M9" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="//ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:ChargeIndicator[udt:Indicator='false']" mode="M10" priority="1000">
    <svrl:fired-rule context="//ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:ChargeIndicator[udt:Indicator='false']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(../ram:ActualAmount)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(../ram:ActualAmount)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-31]-Each Document level allowance (BG-20) shall have a Document level allowance amount (BT-92).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(../ram:CategoryTradeTax[upper-case(ram:TypeCode) = 'VAT']/ram:CategoryCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(../ram:CategoryTradeTax[upper-case(ram:TypeCode) = 'VAT']/ram:CategoryCode)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-32]-Each Document level allowance (BG-20) shall have a Document level allowance VAT category code (BT-95).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(../ram:Reason) or (../ram:ReasonCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(../ram:Reason) or (../ram:ReasonCode)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-33]-Each Document level allowance (BG-20) shall have a Document level allowance reason (BT-97) or a Document level allowance reason code (BT-98).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="true()" />
      <xsl:otherwise>
        <svrl:failed-assert test="true()">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-CO-05]-Document level allowance reason code (BT-98) and Document level allowance reason (BT-97) shall indicate the same type of allowance.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(../ram:Reason) or (../ram:ReasonCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(../ram:Reason) or (../ram:ReasonCode)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-CO-21]-Each Document level allowance (BG-20) shall contain a Document level allowance reason (BT-97) or a Document level allowance reason code (BT-98), or both.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(../ram:ActualAmount,'.'))&lt;=2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(../ram:ActualAmount,'.'))&lt;=2">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-DEC-01]-The allowed maximum number of decimals for the Document level allowance amount (BT-92) is 2.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(../ram:BasisAmount,'.'))&lt;=2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(../ram:BasisAmount,'.'))&lt;=2">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-DEC-02]-The allowed maximum number of decimals for the Document level allowance base amount (BT-93) is 2.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M10" priority="-1" />
  <xsl:template match="@*|node()" mode="M10" priority="-2">
    <xsl:apply-templates mode="M10" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="//ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:ChargeIndicator[udt:Indicator='true']" mode="M11" priority="1000">
    <svrl:fired-rule context="//ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:ChargeIndicator[udt:Indicator='true']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(../ram:ActualAmount)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(../ram:ActualAmount)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-36]-Each Document level charge (BG-21) shall have a Document level charge amount (BT-99).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(../ram:CategoryTradeTax[upper-case(ram:TypeCode) = 'VAT']/ram:CategoryCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(../ram:CategoryTradeTax[upper-case(ram:TypeCode) = 'VAT']/ram:CategoryCode)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-37]-Each Document level charge (BG-21) shall have a Document level charge VAT category code (BT-102).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(../ram:Reason) or (../ram:ReasonCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(../ram:Reason) or (../ram:ReasonCode)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-38]-Each Document level charge (BG-21) shall have a Document level charge reason (BT-104) or a Document level charge reason code (BT-105).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="true()" />
      <xsl:otherwise>
        <svrl:failed-assert test="true()">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-CO-06]-Document level charge reason code (BT-105) and Document level charge reason (BT-104) shall indicate the same type of charge.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(../ram:Reason) or (../ram:ReasonCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(../ram:Reason) or (../ram:ReasonCode)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-CO-22]-Each Document level charge (BG-21) shall contain a Document level charge reason (BT-104) or a Document level charge reason code (BT-105), or both.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(../ram:ActualAmount,'.'))&lt;=2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(../ram:ActualAmount,'.'))&lt;=2">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-DEC-05]-The allowed maximum number of decimals for the Document level charge amount (BT-99) is 2.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(../ram:BasisAmount,'.'))&lt;=2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(../ram:BasisAmount,'.'))&lt;=2">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-DEC-06]-The allowed maximum number of decimals for the Document level charge base amount (BT-100) is 2.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M11" priority="-1" />
  <xsl:template match="@*|node()" mode="M11" priority="-2">
    <xsl:apply-templates mode="M11" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="//ram:ApplicableProductCharacteristic" mode="M12" priority="1000">
    <svrl:fired-rule context="//ram:ApplicableProductCharacteristic" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(ram:Description) and (ram:Value)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(ram:Description) and (ram:Value)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-54]-Each Item attribute (BG-32) shall contain an Item attribute name (BT-160) and an Item attribute value (BT-161).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M12" priority="-1" />
  <xsl:template match="@*|node()" mode="M12" priority="-2">
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="//ram:ApplicableTradeSettlementFinancialCard" mode="M13" priority="1000">
    <svrl:fired-rule context="//ram:ApplicableTradeSettlementFinancialCard" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(ram:ID)&lt;=10" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(ram:ID)&lt;=10">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-51]-In accordance with card payments security standards an invoice should never include a full card primary account number (BT-87). At the moment PCI Security Standards Council has defined that the first 6 digits and last 4 digits are the maximum number of digits to be shown.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M13" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M13" priority="-1" />
  <xsl:template match="@*|node()" mode="M13" priority="-2">
    <xsl:apply-templates mode="M13" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="//ram:IncludedSupplyChainTradeLineItem" mode="M14" priority="1000">
    <svrl:fired-rule context="//ram:IncludedSupplyChainTradeLineItem" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(ram:AssociatedDocumentLineDocument/ram:LineID!='')" />
      <xsl:otherwise>
        <svrl:failed-assert test="(ram:AssociatedDocumentLineDocument/ram:LineID!='')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-21]-Each Invoice line (BG-25) shall have an Invoice line identifier (BT-126).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(ram:SpecifiedLineTradeDelivery/ram:BilledQuantity)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(ram:SpecifiedLineTradeDelivery/ram:BilledQuantity)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-22]-Each Invoice line (BG-25) shall have an Invoiced quantity (BT-129).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(ram:SpecifiedLineTradeDelivery/ram:BilledQuantity/@unitCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(ram:SpecifiedLineTradeDelivery/ram:BilledQuantity/@unitCode)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-23]-An Invoice line (BG-25) shall have an Invoiced quantity unit of measure code (BT-130).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-24]-Each Invoice line (BG-25) shall have an Invoice line net amount (BT-131).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(ram:SpecifiedTradeProduct/ram:Name!='')" />
      <xsl:otherwise>
        <svrl:failed-assert test="(ram:SpecifiedTradeProduct/ram:Name!='')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-25]-Each Invoice line (BG-25) shall contain the Item name (BT-153).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:ChargeAmount)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:ChargeAmount)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-26]-Each Invoice line (BG-25) shall contain the Item net price (BT-146).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:ChargeAmount) >= 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="(ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:ChargeAmount) >= 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-27]-The Item net price (BT-146) shall NOT be negative.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:ChargeAmount >= 0) or not(ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:ChargeAmount)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:ChargeAmount >= 0) or not(ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:ChargeAmount)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-28]-The Item gross price (BT-148) shall NOT be negative.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ram:SpecifiedTradeProduct/ram:GlobalID/@schemeID!='' or not (ram:SpecifiedTradeProduct/ram:GlobalID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="ram:SpecifiedTradeProduct/ram:GlobalID/@schemeID!='' or not (ram:SpecifiedTradeProduct/ram:GlobalID)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-64]-The Item standard identifier (BT-157) shall have a Scheme identifier.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(ram:SpecifiedTradeProduct/ram:DesignatedProductClassification/ram:ClassCode/@listID!='') or not (ram:SpecifiedTradeProduct/ram:DesignatedProductClassification)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(ram:SpecifiedTradeProduct/ram:DesignatedProductClassification/ram:ClassCode/@listID!='') or not (ram:SpecifiedTradeProduct/ram:DesignatedProductClassification)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-65]-The Item classification identifier (BT-158) shall have a Scheme identifier.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[upper-case(ram:TypeCode) = 'VAT']/ram:CategoryCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[upper-case(ram:TypeCode) = 'VAT']/ram:CategoryCode)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-CO-04]-Each Invoice line (BG-25) shall be categorized with an Invoiced item VAT category code (BT-151).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(ram:SpecifiedTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount,'.'))&lt;=2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(ram:SpecifiedTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount,'.'))&lt;=2">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-DEC-23]-The allowed maximum number of decimals for the Invoice line net amount (BT-131) is 2.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M14" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M14" priority="-1" />
  <xsl:template match="@*|node()" mode="M14" priority="-2">
    <xsl:apply-templates mode="M14" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="//ram:PayeeTradeParty" mode="M15" priority="1000">
    <svrl:fired-rule context="//ram:PayeeTradeParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(ram:Name) and (not(ram:Name = ../ram:SellerTradeParty/ram:Name) and not(ram:ID = ../ram:SellerTradeParty/ram:ID) and not(ram:SpecifiedLegalOrganization/ram:ID = ../ram:SellerTradeParty/ram:SpecifiedLegalOrganization/ram:ID))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(ram:Name) and (not(ram:Name = ../ram:SellerTradeParty/ram:Name) and not(ram:ID = ../ram:SellerTradeParty/ram:ID) and not(ram:SpecifiedLegalOrganization/ram:ID = ../ram:SellerTradeParty/ram:SpecifiedLegalOrganization/ram:ID))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-17]-The Payee name (BT-59) shall be provided in the Invoice, if the Payee (BG-10) is different from the Seller (BG-4).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M15" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M15" priority="-1" />
  <xsl:template match="@*|node()" mode="M15" priority="-2">
    <xsl:apply-templates mode="M15" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="//ram:SellerTaxRepresentativeTradeParty" mode="M16" priority="1000">
    <svrl:fired-rule context="//ram:SellerTaxRepresentativeTradeParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(ram:Name)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(ram:Name)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-18]-The Seller tax representative name (BT-62) shall be provided in the Invoice, if the Seller (BG-4) has a Seller tax representative party (BG-11).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(ram:PostalTradeAddress)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(ram:PostalTradeAddress)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-19]-The Seller tax representative postal address (BG-12) shall be provided in the Invoice, if the Seller (BG-4) has a Seller tax representative party (BG-11).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(ram:PostalTradeAddress/ram:CountryID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(ram:PostalTradeAddress/ram:CountryID)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-20]-The Seller tax representative postal address (BG-12) shall contain a Tax representative country code (BT-69), if the Seller (BG-4) has a Seller tax representative party (BG-11).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(ram:SpecifiedTaxRegistration/ram:ID[@schemeID='VA']!='')" />
      <xsl:otherwise>
        <svrl:failed-assert test="(ram:SpecifiedTaxRegistration/ram:ID[@schemeID='VA']!='')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-56]-Each Seller tax representative party (BG-11) shall have a Seller tax representative VAT identifier (BT-63).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M16" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M16" priority="-1" />
  <xsl:template match="@*|node()" mode="M16" priority="-2">
    <xsl:apply-templates mode="M16" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="//ram:SellerTradeParty" mode="M17" priority="1000">
    <svrl:fired-rule context="//ram:SellerTradeParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(ram:ID) or (ram:GlobalID) or (ram:SpecifiedLegalOrganization/ram:ID) or (ram:SpecifiedTaxRegistration/ram:ID[@schemeID='VA'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="(ram:ID) or (ram:GlobalID) or (ram:SpecifiedLegalOrganization/ram:ID) or (ram:SpecifiedTaxRegistration/ram:ID[@schemeID='VA'])">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-CO-26]-In order for the buyer to automatically identify a supplier, the Seller identifier (BT-29), the Seller legal registration identifier (BT-30) and/or the Seller VAT identifier (BT-31) shall be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M17" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M17" priority="-1" />
  <xsl:template match="@*|node()" mode="M17" priority="-2">
    <xsl:apply-templates mode="M17" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="//ram:SpecifiedLineTradeSettlement/ram:BillingSpecifiedPeriod" mode="M18" priority="1000">
    <svrl:fired-rule context="//ram:SpecifiedLineTradeSettlement/ram:BillingSpecifiedPeriod" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(ram:EndDateTime/udt:DateTimeString[@format = '102']) >= (ram:StartDateTime/udt:DateTimeString[@format = '102']) or not (ram:EndDateTime) or not (ram:StartDateTime)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(ram:EndDateTime/udt:DateTimeString[@format = '102']) >= (ram:StartDateTime/udt:DateTimeString[@format = '102']) or not (ram:EndDateTime) or not (ram:StartDateTime)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-30]-If both Invoice line period start date (BT-134) and Invoice line period end date (BT-135) are given then the Invoice line period end date (BT-135) shall be later or equal to the Invoice line period start date (BT-134).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(ram:StartDateTime) or (ram:EndDateTime)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(ram:StartDateTime) or (ram:EndDateTime)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-CO-20]-If Invoice line period (BG-26) is used, the Invoice line period start date (BT-134) or the Invoice line period end date (BT-135) shall be filled, or both.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M18" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M18" priority="-1" />
  <xsl:template match="@*|node()" mode="M18" priority="-2">
    <xsl:apply-templates mode="M18" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="//ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:ChargeIndicator[udt:Indicator = 'false']" mode="M19" priority="1000">
    <svrl:fired-rule context="//ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:ChargeIndicator[udt:Indicator = 'false']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(../ram:Reason) or (../ram:ReasonCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(../ram:Reason) or (../ram:ReasonCode)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-42]-Each Invoice line allowance (BG-27) shall have an Invoice line allowance reason (BT-139) or an Invoice line allowance reason code (BT-140).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M19" priority="-1" />
  <xsl:template match="@*|node()" mode="M19" priority="-2">
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="//ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:ChargeIndicator[udt:Indicator = 'false']&#xD;&#xA;" mode="M20" priority="1000">
    <svrl:fired-rule context="//ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:ChargeIndicator[udt:Indicator = 'false']&#xD;&#xA;" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(../ram:ActualAmount)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(../ram:ActualAmount)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-41]-Each Invoice line allowance (BG-27) shall have an Invoice line allowance amount (BT-136).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="true()" />
      <xsl:otherwise>
        <svrl:failed-assert test="true()">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-CO-07]-Invoice line allowance reason code (BT-140) and Invoice line allowance reason (BT-139) shall indicate the same type of allowance reason.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(../ram:Reason) or (../ram:ReasonCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(../ram:Reason) or (../ram:ReasonCode)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-CO-23]-Each Invoice line allowance (BG-27) shall contain an Invoice line allowance reason (BT-139) or an Invoice line allowance reason code (BT-140), or both.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(../ram:ActualAmount,'.'))&lt;=2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(../ram:ActualAmount,'.'))&lt;=2">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-DEC-24]-The allowed maximum number of decimals for the Invoice line allowance amount (BT-136) is 2.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(../ram:BasisAmount,'.'))&lt;=2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(../ram:BasisAmount,'.'))&lt;=2">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-DEC-25]-The allowed maximum number of decimals for the Invoice line allowance base amount (BT-137) is 2.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M20" priority="-1" />
  <xsl:template match="@*|node()" mode="M20" priority="-2">
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="//ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:ChargeIndicator[udt:Indicator = 'true']" mode="M21" priority="1000">
    <svrl:fired-rule context="//ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:ChargeIndicator[udt:Indicator = 'true']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(../ram:ActualAmount)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(../ram:ActualAmount)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-43]-Each Invoice line charge (BG-28) shall have an Invoice line charge amount (BT-141).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="true()" />
      <xsl:otherwise>
        <svrl:failed-assert test="true()">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-CO-08]-Invoice line charge reason code (BT-145) and Invoice line charge reason (BT-144) shall indicate the same type of charge reason.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(../ram:Reason) or (../ram:ReasonCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(../ram:Reason) or (../ram:ReasonCode)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-CO-24]-Each Invoice line charge (BG-28) shall contain an Invoice line charge reason (BT-144) or an Invoice line charge reason code (BT-145), or both.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(../ram:ActualAmount,'.'))&lt;=2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(../ram:ActualAmount,'.'))&lt;=2">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-DEC-27]-The allowed maximum number of decimals for the Invoice line charge amount (BT-141) is 2.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(../ram:BasisAmount,'.'))&lt;=2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(../ram:BasisAmount,'.'))&lt;=2">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-DEC-28]-The allowed maximum number of decimals for the Invoice line charge base amount (BT-142) is 2.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M21" priority="-1" />
  <xsl:template match="@*|node()" mode="M21" priority="-2">
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="//ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator = 'true']" mode="M22" priority="1000">
    <svrl:fired-rule context="//ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator = 'true']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(../ram:Reason) or (../ram:ReasonCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(../ram:Reason) or (../ram:ReasonCode)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-44]-Each Invoice line charge (BG-28) shall have an Invoice line charge reason (BT-144) or an Invoice line charge reason code (BT-145).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M22" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M22" priority="-1" />
  <xsl:template match="@*|node()" mode="M22" priority="-2">
    <xsl:apply-templates mode="M22" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="//ram:SpecifiedTaxRegistration/ram:ID[@schemeID='VA']" mode="M23" priority="1000">
    <svrl:fired-rule context="//ram:SpecifiedTaxRegistration/ram:ID[@schemeID='VA']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="contains(' 1A AD AE AF AG AI AL AM AN AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BL BJ BM BN BO BQ BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CW CX CY CZ DE DJ DK DM DO DZ EC EE EG EH EL ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RE RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR ST SV SX SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS XI YE YT ZA ZM ZW ', concat(' ', substring(.,1,2), ' '))" />
      <xsl:otherwise>
        <svrl:failed-assert test="contains(' 1A AD AE AF AG AI AL AM AN AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BL BJ BM BN BO BQ BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CW CX CY CZ DE DJ DK DM DO DZ EC EE EG EH EL ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RE RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR ST SV SX SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS XI YE YT ZA ZM ZW ', concat(' ', substring(.,1,2), ' '))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-CO-09]-The Seller VAT identifier (BT-31), the Seller tax representative VAT identifier (BT-63) and the Buyer VAT identifier (BT-48) shall have a prefix in accordance with ISO code ISO 3166-1 alpha-2 by which the country of issue may be identified. Nevertheless, Greece may use the prefix ‘EL’.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M23" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M23" priority="-1" />
  <xsl:template match="@*|node()" mode="M23" priority="-2">
    <xsl:apply-templates mode="M23" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="//ram:SpecifiedTradeAllowanceCharge" mode="M24" priority="1000">
    <svrl:fired-rule context="//ram:SpecifiedTradeAllowanceCharge" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(ram:ChargeIndicator)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(ram:ChargeIndicator)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-66]-Each Specified Trade Allowance Charge (BG-20)(BG-21) shall contain a Charge Indicator.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M24" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M24" priority="-1" />
  <xsl:template match="@*|node()" mode="M24" priority="-2">
    <xsl:apply-templates mode="M24" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='false']/ram:CategoryTradeTax[ram:CategoryCode = 'AE']" mode="M25" priority="1000">
    <svrl:fired-rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='false']/ram:CategoryTradeTax[ram:CategoryCode = 'AE']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(//ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = ('VA', 'FC')] or //ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']) and (//ram:BuyerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA'] or //ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:ID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(//ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = ('VA', 'FC')] or //ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']) and (//ram:BuyerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA'] or //ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:ID)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-AE-03]-An Invoice that contains a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Reverse charge" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63) and the Buyer VAT identifier (BT-48) and/or the Buyer legal registration identifier (BT-47).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ram:RateApplicablePercent = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="ram:RateApplicablePercent = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-AE-06]-In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Reverse charge" the Document level allowance VAT rate (BT-96) shall be 0 (zero).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M25" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M25" priority="-1" />
  <xsl:template match="@*|node()" mode="M25" priority="-2">
    <xsl:apply-templates mode="M25" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='false']/ram:CategoryTradeTax[ram:CategoryCode = 'E']" mode="M26" priority="1000">
    <svrl:fired-rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='false']/ram:CategoryTradeTax[ram:CategoryCode = 'E']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = ('VA', 'FC')] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']" />
      <xsl:otherwise>
        <svrl:failed-assert test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = ('VA', 'FC')] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-E-03]-An Invoice that contains a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Exempt from VAT" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ram:RateApplicablePercent = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="ram:RateApplicablePercent = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-E-06]-In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Exempt from VAT", the Document level allowance VAT rate (BT-96) shall be 0 (zero).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M26" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M26" priority="-1" />
  <xsl:template match="@*|node()" mode="M26" priority="-2">
    <xsl:apply-templates mode="M26" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='false']/ram:CategoryTradeTax[ram:CategoryCode = 'G']" mode="M27" priority="1000">
    <svrl:fired-rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='false']/ram:CategoryTradeTax[ram:CategoryCode = 'G']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(//ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA'] or //ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="(//ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA'] or //ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA'])">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-G-03]-An Invoice that contains a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Export outside the EU" shall contain the Seller VAT Identifier (BT-31) or the Seller tax representative VAT identifier (BT-63).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ram:RateApplicablePercent = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="ram:RateApplicablePercent = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-G-06]-In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Export outside the EU" the Document level allowance VAT rate (BT-96) shall be 0 (zero).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M27" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M27" priority="-1" />
  <xsl:template match="@*|node()" mode="M27" priority="-2">
    <xsl:apply-templates mode="M27" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='false']/ram:CategoryTradeTax[ram:CategoryCode = 'K']" mode="M28" priority="1000">
    <svrl:fired-rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='false']/ram:CategoryTradeTax[ram:CategoryCode = 'K']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(//ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA'] or //ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']) and //ram:BuyerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']" />
      <xsl:otherwise>
        <svrl:failed-assert test="(//ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA'] or //ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']) and //ram:BuyerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-IC-03]-An Invoice that contains a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Intra-community supply" shall contain the Seller VAT Identifier (BT-31) or the Seller tax representative VAT identifier (BT-63) and the Buyer VAT identifier (BT-48).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ram:RateApplicablePercent = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="ram:RateApplicablePercent = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-IC-06]-In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Intra-community supply" the Document level allowance VAT rate (BT-96) shall be 0 (zero).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M28" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M28" priority="-1" />
  <xsl:template match="@*|node()" mode="M28" priority="-2">
    <xsl:apply-templates mode="M28" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='false']/ram:CategoryTradeTax[ram:CategoryCode = 'L']" mode="M29" priority="1000">
    <svrl:fired-rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='false']/ram:CategoryTradeTax[ram:CategoryCode = 'L']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = ('VA', 'FC')] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']" />
      <xsl:otherwise>
        <svrl:failed-assert test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = ('VA', 'FC')] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-AF-03]-An Invoice that contains a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "IGIC" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ram:RateApplicablePercent > 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="ram:RateApplicablePercent > 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-AF-06]-In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "IGIC" the Document level allowance VAT rate (BT-96) shall be 0 (zero) or greater than zero.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M29" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M29" priority="-1" />
  <xsl:template match="@*|node()" mode="M29" priority="-2">
    <xsl:apply-templates mode="M29" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='false']/ram:CategoryTradeTax[ram:CategoryCode = 'M']" mode="M30" priority="1000">
    <svrl:fired-rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='false']/ram:CategoryTradeTax[ram:CategoryCode = 'M']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = ('VA', 'FC')] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']" />
      <xsl:otherwise>
        <svrl:failed-assert test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = ('VA', 'FC')] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-AG-03]-An Invoice that contains a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "IPSI" shall contain the Seller VAT Identifier (BT-31), the Seller Tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ram:RateApplicablePercent > 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="ram:RateApplicablePercent > 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-AG-06]-In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "IPSI" the Document level allowance VAT rate (BT-96) shall be 0 (zero) or greater than zero.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M30" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M30" priority="-1" />
  <xsl:template match="@*|node()" mode="M30" priority="-2">
    <xsl:apply-templates mode="M30" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='false']/ram:CategoryTradeTax[ram:CategoryCode = 'O']" mode="M31" priority="1000">
    <svrl:fired-rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='false']/ram:CategoryTradeTax[ram:CategoryCode = 'O']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']) and not (/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']) and not (/ram:BuyerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']) and not (/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']) and not (/ram:BuyerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA'])">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-O-03]-An Invoice that contains a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Not subject to VAT" shall not contain the Seller VAT identifier (BT-31), the Seller tax representative VAT identifier (BT-63) or the Buyer VAT identifier (BT-48).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(ram:RateApplicablePercent)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(ram:RateApplicablePercent)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-O-06]-A Document level allowance (BG-20) where VAT category code (BT-95) is "Not subject to VAT" shall not contain a Document level allowance VAT rate (BT-96).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M31" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M31" priority="-1" />
  <xsl:template match="@*|node()" mode="M31" priority="-2">
    <xsl:apply-templates mode="M31" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='false']/ram:CategoryTradeTax[ram:CategoryCode = 'S']" mode="M32" priority="1000">
    <svrl:fired-rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='false']/ram:CategoryTradeTax[ram:CategoryCode = 'S']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = ('VA', 'FC')] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']" />
      <xsl:otherwise>
        <svrl:failed-assert test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = ('VA', 'FC')] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-S-03]-An Invoice that contains a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Standard rated" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ram:RateApplicablePercent > 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="ram:RateApplicablePercent > 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-S-06]-In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Standard rated" the Document level allowance VAT rate (BT-96) shall be greater than zero.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M32" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M32" priority="-1" />
  <xsl:template match="@*|node()" mode="M32" priority="-2">
    <xsl:apply-templates mode="M32" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='false']/ram:CategoryTradeTax[ram:CategoryCode = 'Z']" mode="M33" priority="1000">
    <svrl:fired-rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='false']/ram:CategoryTradeTax[ram:CategoryCode = 'Z']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = ('VA', 'FC')] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']" />
      <xsl:otherwise>
        <svrl:failed-assert test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = ('VA', 'FC')] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-Z-03]-An Invoice that contains a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Zero rated" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ram:RateApplicablePercent = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="ram:RateApplicablePercent = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-Z-06]-In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Zero rated" the Document level allowance VAT rate (BT-96) shall be 0 (zero).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M33" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M33" priority="-1" />
  <xsl:template match="@*|node()" mode="M33" priority="-2">
    <xsl:apply-templates mode="M33" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='true']/ram:CategoryTradeTax[ram:CategoryCode = 'AE']" mode="M34" priority="1000">
    <svrl:fired-rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='true']/ram:CategoryTradeTax[ram:CategoryCode = 'AE']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(//ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = ('VA', 'FC')] or //ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']) and (//ram:BuyerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA'] or //ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:ID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(//ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = ('VA', 'FC')] or //ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']) and (//ram:BuyerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA'] or //ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:ID)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-AE-04]-An Invoice that contains a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Reverse charge" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63) and the Buyer VAT identifier (BT-48) and/or the Buyer legal registration identifier (BT-47).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ram:RateApplicablePercent = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="ram:RateApplicablePercent = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-AE-07]-In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Reverse charge" the Document level charge VAT rate (BT-103) shall be 0 (zero).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M34" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M34" priority="-1" />
  <xsl:template match="@*|node()" mode="M34" priority="-2">
    <xsl:apply-templates mode="M34" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='true']/ram:CategoryTradeTax[ram:CategoryCode = 'E']" mode="M35" priority="1000">
    <svrl:fired-rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='true']/ram:CategoryTradeTax[ram:CategoryCode = 'E']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = ('VA', 'FC')] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']" />
      <xsl:otherwise>
        <svrl:failed-assert test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = ('VA', 'FC')] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-E-04]-An Invoice that contains a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Exempt from VAT" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ram:RateApplicablePercent = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="ram:RateApplicablePercent = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-E-07]-In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Exempt from VAT", the Document level charge VAT rate (BT-103) shall be 0 (zero).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M35" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M35" priority="-1" />
  <xsl:template match="@*|node()" mode="M35" priority="-2">
    <xsl:apply-templates mode="M35" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='true']/ram:CategoryTradeTax[ram:CategoryCode = 'G']" mode="M36" priority="1000">
    <svrl:fired-rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='true']/ram:CategoryTradeTax[ram:CategoryCode = 'G']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(//ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA'] or //ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="(//ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA'] or //ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA'])">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-G-04]-An Invoice that contains a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Export outside the EU" shall contain the Seller VAT Identifier (BT-31) or the Seller tax representative VAT identifier (BT-63).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ram:RateApplicablePercent = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="ram:RateApplicablePercent = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-G-07]-In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Export outside the EU" the Document level charge VAT rate (BT-103) shall be 0 (zero).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M36" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M36" priority="-1" />
  <xsl:template match="@*|node()" mode="M36" priority="-2">
    <xsl:apply-templates mode="M36" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='true']/ram:CategoryTradeTax[ram:CategoryCode = 'K']" mode="M37" priority="1000">
    <svrl:fired-rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='true']/ram:CategoryTradeTax[ram:CategoryCode = 'K']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(//ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA'] or //ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']) and //ram:BuyerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']" />
      <xsl:otherwise>
        <svrl:failed-assert test="(//ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA'] or //ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']) and //ram:BuyerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-IC-04]-An Invoice that contains a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Intra-community supply" shall contain the Seller VAT Identifier (BT-31) or the Seller tax representative VAT identifier (BT-63) and the Buyer VAT identifier (BT-48).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ram:RateApplicablePercent = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="ram:RateApplicablePercent = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-IC-07]-In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Intra-community supply" the Document level charge VAT rate (BT-103) shall be 0 (zero).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M37" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M37" priority="-1" />
  <xsl:template match="@*|node()" mode="M37" priority="-2">
    <xsl:apply-templates mode="M37" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='true']/ram:CategoryTradeTax[ram:CategoryCode = 'L']" mode="M38" priority="1000">
    <svrl:fired-rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='true']/ram:CategoryTradeTax[ram:CategoryCode = 'L']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = ('VA', 'FC')] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']" />
      <xsl:otherwise>
        <svrl:failed-assert test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = ('VA', 'FC')] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-AF-04]-An Invoice that contains a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "IGIC" shall contain the Seller VAT Identifier (BT-31), the Seller Tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ram:RateApplicablePercent > 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="ram:RateApplicablePercent > 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-AF-07]-In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "IGIC" the Document level charge VAT rate (BT-103) shall be 0 (zero) or greater than zero.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M38" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M38" priority="-1" />
  <xsl:template match="@*|node()" mode="M38" priority="-2">
    <xsl:apply-templates mode="M38" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='true']/ram:CategoryTradeTax[ram:CategoryCode = 'M']" mode="M39" priority="1000">
    <svrl:fired-rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='true']/ram:CategoryTradeTax[ram:CategoryCode = 'M']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = ('VA', 'FC')] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']" />
      <xsl:otherwise>
        <svrl:failed-assert test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = ('VA', 'FC')] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-AG-04]-An Invoice that contains a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "IPSI" shall contain the Seller VAT Identifier (BT-31), the Seller Tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ram:RateApplicablePercent > 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="ram:RateApplicablePercent > 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-AG-07]-In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "IPSI" the Document level charge VAT rate (BT-103) shall be 0 (zero) or greater than zero.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M39" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M39" priority="-1" />
  <xsl:template match="@*|node()" mode="M39" priority="-2">
    <xsl:apply-templates mode="M39" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='true']/ram:CategoryTradeTax[ram:CategoryCode = 'O']" mode="M40" priority="1000">
    <svrl:fired-rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='true']/ram:CategoryTradeTax[ram:CategoryCode = 'O']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']) and not (/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']) and not (/ram:BuyerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']) and not (/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']) and not (/ram:BuyerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA'])">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-O-04]-An Invoice that contains a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Not subject to VAT" shall not contain the Seller VAT identifier (BT-31), the Seller tax representative VAT identifier (BT-63) or the Buyer VAT identifier (BT-48).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(ram:RateApplicablePercent)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(ram:RateApplicablePercent)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-O-07]-A Document level charge (BG-21) where the VAT category code (BT-102) is "Not subject to VAT" shall not contain a Document level charge VAT rate (BT-103).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M40" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M40" priority="-1" />
  <xsl:template match="@*|node()" mode="M40" priority="-2">
    <xsl:apply-templates mode="M40" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='true']/ram:CategoryTradeTax[ram:CategoryCode = 'S']" mode="M41" priority="1000">
    <svrl:fired-rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='true']/ram:CategoryTradeTax[ram:CategoryCode = 'S']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = ('VA', 'FC')] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']" />
      <xsl:otherwise>
        <svrl:failed-assert test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = ('VA', 'FC')] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-S-04]-An Invoice that contains a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Standard rated" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ram:RateApplicablePercent > 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="ram:RateApplicablePercent > 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-S-07]-In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Standard rated" the Document level charge VAT rate (BT-103) shall be greater than zero.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M41" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M41" priority="-1" />
  <xsl:template match="@*|node()" mode="M41" priority="-2">
    <xsl:apply-templates mode="M41" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='true']/ram:CategoryTradeTax[ram:CategoryCode = 'Z']" mode="M42" priority="1000">
    <svrl:fired-rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='true']/ram:CategoryTradeTax[ram:CategoryCode = 'Z']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = ('VA', 'FC')] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']" />
      <xsl:otherwise>
        <svrl:failed-assert test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = ('VA', 'FC')] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-Z-04]-An Invoice that contains a Document level charge where the Document level charge VAT category code (BT-102) is "Zero rated" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ram:RateApplicablePercent = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="ram:RateApplicablePercent = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-Z-07]-In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Zero rated" the Document level charge VAT rate (BT-103) shall be 0 (zero).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M42" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M42" priority="-1" />
  <xsl:template match="@*|node()" mode="M42" priority="-2">
    <xsl:apply-templates mode="M42" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="//ram:SpecifiedTradeSettlementHeaderMonetarySummation" mode="M43" priority="1000">
    <svrl:fired-rule context="//ram:SpecifiedTradeSettlementHeaderMonetarySummation" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="xs:decimal(ram:LineTotalAmount) = round(xs:decimal(sum(../../ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount)) * xs:decimal(100)) div xs:decimal(100)" />
      <xsl:otherwise>
        <svrl:failed-assert test="xs:decimal(ram:LineTotalAmount) = round(xs:decimal(sum(../../ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount)) * xs:decimal(100)) div xs:decimal(100)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-CO-10]-Sum of Invoice line net amount (BT-106) = Σ Invoice line net amount (BT-131).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(ram:LineTotalAmount)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(ram:LineTotalAmount)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-12]-An Invoice shall have the Sum of Invoice line net amount (BT-106).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(ram:TaxBasisTotalAmount)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(ram:TaxBasisTotalAmount)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-13]-An Invoice shall have the Invoice total amount without VAT (BT-109).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(ram:GrandTotalAmount)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(ram:GrandTotalAmount)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-14]-An Invoice shall have the Invoice total amount with VAT (BT-112).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(ram:DuePayableAmount)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(ram:DuePayableAmount)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-15]-An Invoice shall have the Amount due for payment (BT-115).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(not(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='false'])and not (ram:AllowanceTotalAmount)) or ram:AllowanceTotalAmount = (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='false']/ram:ActualAmount)* 10 * 10 ) div 100)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(not(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='false'])and not (ram:AllowanceTotalAmount)) or ram:AllowanceTotalAmount = (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='false']/ram:ActualAmount)* 10 * 10 ) div 100)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-CO-11]-Sum of allowances on document level (BT-107) = Σ Document level allowance amount (BT-92).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(not(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='true'])and not (ram:ChargeTotalAmount)) or (round (/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:ChargeTotalAmount * 10 * 10) div 100)= &#xD;&#xA;round(((round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='true']/ram:ActualAmount)* 10 * 10 ) div 100) + (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge/ram:AppliedAmount)* 10 * 10 ) div 100))*10*10) div 100" />
      <xsl:otherwise>
        <svrl:failed-assert test="(not(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='true'])and not (ram:ChargeTotalAmount)) or (round (/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:ChargeTotalAmount * 10 * 10) div 100)= round(((round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='true']/ram:ActualAmount)* 10 * 10 ) div 100) + (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge/ram:AppliedAmount)* 10 * 10 ) div 100))*10*10) div 100">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-CO-12]-Sum of charges on document level (BT-108) = Σ Document level charge amount (BT-99).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(xs:decimal(ram:TaxBasisTotalAmount) = round((xs:decimal(ram:LineTotalAmount) - xs:decimal(ram:AllowanceTotalAmount) + xs:decimal(ram:ChargeTotalAmount)) *10 * 10) div 100) or &#xD;&#xA;    ((xs:decimal(ram:TaxBasisTotalAmount) = round((xs:decimal(ram:LineTotalAmount) - xs:decimal(ram:AllowanceTotalAmount)) *10 * 10) div 100)  and not (ram:ChargeTotalAmount)) or &#xD;&#xA;    ((xs:decimal(ram:TaxBasisTotalAmount) = round((xs:decimal(ram:LineTotalAmount) + xs:decimal(ram:ChargeTotalAmount)) *10 * 10) div 100)  and not (ram:AllowanceTotalAmount)) or &#xD;&#xA;    ((xs:decimal(ram:TaxBasisTotalAmount) = round((xs:decimal(ram:LineTotalAmount))  *10 * 10) div 100) and not (ram:ChargeTotalAmount) and not (ram:AllowanceTotalAmount))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(xs:decimal(ram:TaxBasisTotalAmount) = round((xs:decimal(ram:LineTotalAmount) - xs:decimal(ram:AllowanceTotalAmount) + xs:decimal(ram:ChargeTotalAmount)) *10 * 10) div 100) or ((xs:decimal(ram:TaxBasisTotalAmount) = round((xs:decimal(ram:LineTotalAmount) - xs:decimal(ram:AllowanceTotalAmount)) *10 * 10) div 100) and not (ram:ChargeTotalAmount)) or ((xs:decimal(ram:TaxBasisTotalAmount) = round((xs:decimal(ram:LineTotalAmount) + xs:decimal(ram:ChargeTotalAmount)) *10 * 10) div 100) and not (ram:AllowanceTotalAmount)) or ((xs:decimal(ram:TaxBasisTotalAmount) = round((xs:decimal(ram:LineTotalAmount)) *10 * 10) div 100) and not (ram:ChargeTotalAmount) and not (ram:AllowanceTotalAmount))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-CO-13]-Invoice total amount without VAT (BT-109) = Σ Invoice line net amount (BT-131) - Sum of allowances on document level (BT-107) + Sum of charges on document level (BT-108).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="every $Currency &#xD;&#xA;                                in rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode&#xD;&#xA;                                satisfies (  &#xD;&#xA;                                  count ( rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxTotalAmount[@currencyID=$Currency] ) eq 1 and  &#xD;&#xA;                                  (//ram:SpecifiedTradeSettlementHeaderMonetarySummation/xs:decimal(ram:GrandTotalAmount) = round( &#xD;&#xA;                                    (//ram:SpecifiedTradeSettlementHeaderMonetarySummation/xs:decimal(ram:TaxBasisTotalAmount) + &#xD;&#xA;                                    (//ram:SpecifiedTradeSettlementHeaderMonetarySummation/xs:decimal(ram:TaxTotalAmount[@currencyID=$Currency]))) * 10 * 10) div 100)) or&#xD;&#xA;                                (//ram:SpecifiedTradeSettlementHeaderMonetarySummation/xs:decimal(ram:GrandTotalAmount) = (//ram:SpecifiedTradeSettlementHeaderMonetarySummation/xs:decimal(ram:TaxBasisTotalAmount)))" />
      <xsl:otherwise>
        <svrl:failed-assert test="every $Currency in rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode satisfies ( count ( rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxTotalAmount[@currencyID=$Currency] ) eq 1 and (//ram:SpecifiedTradeSettlementHeaderMonetarySummation/xs:decimal(ram:GrandTotalAmount) = round( (//ram:SpecifiedTradeSettlementHeaderMonetarySummation/xs:decimal(ram:TaxBasisTotalAmount) + (//ram:SpecifiedTradeSettlementHeaderMonetarySummation/xs:decimal(ram:TaxTotalAmount[@currencyID=$Currency]))) * 10 * 10) div 100)) or (//ram:SpecifiedTradeSettlementHeaderMonetarySummation/xs:decimal(ram:GrandTotalAmount) = (//ram:SpecifiedTradeSettlementHeaderMonetarySummation/xs:decimal(ram:TaxBasisTotalAmount)))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-CO-15]-Invoice total amount with VAT (BT-112) = Invoice total amount without VAT (BT-109) + Invoice total VAT amount (BT-110).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(xs:decimal(ram:DuePayableAmount) = xs:decimal(ram:GrandTotalAmount) - xs:decimal(ram:TotalPrepaidAmount) + xs:decimal(ram:RoundingAmount)) or &#xD;&#xA;    ((xs:decimal(ram:DuePayableAmount) = xs:decimal(ram:GrandTotalAmount) + xs:decimal(ram:RoundingAmount)) and not (xs:decimal(ram:TotalPrepaidAmount))) or &#xD;&#xA;    ((xs:decimal(ram:DuePayableAmount) = xs:decimal(ram:GrandTotalAmount) - xs:decimal(ram:TotalPrepaidAmount)) and not (xs:decimal(ram:RoundingAmount))) or &#xD;&#xA;    ((xs:decimal(ram:DuePayableAmount) = xs:decimal(ram:GrandTotalAmount)) and not (xs:decimal(ram:TotalPrepaidAmount)) and not (xs:decimal(ram:RoundingAmount)))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(xs:decimal(ram:DuePayableAmount) = xs:decimal(ram:GrandTotalAmount) - xs:decimal(ram:TotalPrepaidAmount) + xs:decimal(ram:RoundingAmount)) or ((xs:decimal(ram:DuePayableAmount) = xs:decimal(ram:GrandTotalAmount) + xs:decimal(ram:RoundingAmount)) and not (xs:decimal(ram:TotalPrepaidAmount))) or ((xs:decimal(ram:DuePayableAmount) = xs:decimal(ram:GrandTotalAmount) - xs:decimal(ram:TotalPrepaidAmount)) and not (xs:decimal(ram:RoundingAmount))) or ((xs:decimal(ram:DuePayableAmount) = xs:decimal(ram:GrandTotalAmount)) and not (xs:decimal(ram:TotalPrepaidAmount)) and not (xs:decimal(ram:RoundingAmount)))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-CO-16]-Amount due for payment (BT-115) = Invoice total amount with VAT (BT-112) -Paid amount (BT-113) +Rounding amount (BT-114).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(ram:LineTotalAmount,'.'))&lt;=2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(ram:LineTotalAmount,'.'))&lt;=2">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-DEC-09]-The allowed maximum number of decimals for the Sum of Invoice line net amount (BT-106) is 2.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(ram:AllowanceTotalAmount,'.'))&lt;=2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(ram:AllowanceTotalAmount,'.'))&lt;=2">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-DEC-10]-The allowed maximum number of decimals for the Sum of allowanced on document level (BT-107) is 2.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(ram:ChargeTotalAmount,'.'))&lt;=2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(ram:ChargeTotalAmount,'.'))&lt;=2">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-DEC-11]-The allowed maximum number of decimals for the Sum of charges on document level (BT-108) is 2.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(ram:TaxBasisTotalAmount,'.'))&lt;=2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(ram:TaxBasisTotalAmount,'.'))&lt;=2">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-DEC-12]-The allowed maximum number of decimals for the Invoice total amount without VAT (BT-109) is 2.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(ram:TaxTotalAmount) or ram:TaxTotalAmount[(@currencyID =/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode and . = round(. * 100) div 100) or not (@currencyID =/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode)]" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(ram:TaxTotalAmount) or ram:TaxTotalAmount[(@currencyID =/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode and . = round(. * 100) div 100) or not (@currencyID =/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode)]">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-DEC-13]-The allowed maximum number of decimals for the Invoice total VAT amount (BT-110) is 2.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(ram:GrandTotalAmount,'.'))&lt;=2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(ram:GrandTotalAmount,'.'))&lt;=2">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-DEC-14]-The allowed maximum number of decimals for the Invoice total amount with VAT (BT-112) is 2.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(ram:TaxTotalAmount) or ram:TaxTotalAmount[(@currencyID =/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxCurrencyCode and . = round(. * 100) div 100) or not (/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxCurrencyCode)]" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(ram:TaxTotalAmount) or ram:TaxTotalAmount[(@currencyID =/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxCurrencyCode and . = round(. * 100) div 100) or not (/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxCurrencyCode)]">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-DEC-15]-The allowed maximum number of decimals for the Invoice total VAT amount in accounting currency (BT-111) is 2.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(ram:TotalPrepaidAmount,'.'))&lt;=2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(ram:TotalPrepaidAmount,'.'))&lt;=2">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-DEC-16]-The allowed maximum number of decimals for the Paid amount (BT-113) is 2.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(ram:RoundingAmount,'.'))&lt;=2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(ram:RoundingAmount,'.'))&lt;=2">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-DEC-17]-The allowed maximum number of decimals for the Rounding amount (BT-114) is 2.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(ram:DuePayableAmount,'.'))&lt;=2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(ram:DuePayableAmount,'.'))&lt;=2">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-DEC-18]-The allowed maximum number of decimals for the Amount due for payment (BT-115) is 2.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxCurrencyCode) or (/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxCurrencyCode and (ram:TaxTotalAmount/@currencyID = /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxCurrencyCode) and not(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxCurrencyCode = /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxCurrencyCode) or (/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxCurrencyCode and (ram:TaxTotalAmount/@currencyID = /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxCurrencyCode) and not(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxCurrencyCode = /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-53]-If the VAT accounting currency code (BT-6) is present, then the Invoice total VAT amount in accounting currency (BT-111) shall be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M43" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M43" priority="-1" />
  <xsl:template match="@*|node()" mode="M43" priority="-2">
    <xsl:apply-templates mode="M43" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="//ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxTotalAmount[@currencyID=/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode]" mode="M44" priority="1000">
    <svrl:fired-rule context="//ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxTotalAmount[@currencyID=/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test=". = (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CalculatedAmount)*10*10)div 100)" />
      <xsl:otherwise>
        <svrl:failed-assert test=". = (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CalculatedAmount)*10*10)div 100)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-CO-14]-Invoice total VAT amount (BT-110) = Σ VAT category tax amount (BT-117).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M44" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M44" priority="-1" />
  <xsl:template match="@*|node()" mode="M44" priority="-2">
    <xsl:apply-templates mode="M44" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="//ram:SpecifiedTradeSettlementPaymentMeans" mode="M45" priority="1000">
    <svrl:fired-rule context="//ram:SpecifiedTradeSettlementPaymentMeans" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(ram:TypeCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(ram:TypeCode)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-49]-A Payment instruction (BG-16) shall specify the Payment means type code (BT-81).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(ram:PayeePartyCreditorFinancialAccount/ram:IBANID) or (ram:PayeePartyCreditorFinancialAccount/ram:ProprietaryID) or (not(ram:PayeePartyCreditorFinancialAccount/ram:IBANID) and not(ram:PayeePartyCreditorFinancialAccount/ram:ProprietaryID))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(ram:PayeePartyCreditorFinancialAccount/ram:IBANID) or (ram:PayeePartyCreditorFinancialAccount/ram:ProprietaryID) or (not(ram:PayeePartyCreditorFinancialAccount/ram:IBANID) and not(ram:PayeePartyCreditorFinancialAccount/ram:ProprietaryID))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-CO-27]-Either the IBAN or a Proprietary ID (BT-84) shall be used.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M45" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M45" priority="-1" />
  <xsl:template match="@*|node()" mode="M45" priority="-2">
    <xsl:apply-templates mode="M45" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="//ram:SpecifiedTradeSettlementPaymentMeans[ram:TypeCode='30' or ram:TypeCode='58']/ram:PayerPartyDebtorFinancialAccount" mode="M46" priority="1000">
    <svrl:fired-rule context="//ram:SpecifiedTradeSettlementPaymentMeans[ram:TypeCode='30' or ram:TypeCode='58']/ram:PayerPartyDebtorFinancialAccount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(ram:IBANID) or (ram:ProprietaryID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(ram:IBANID) or (ram:ProprietaryID)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-50]-A Payment account identifier (BT-84) shall be present if Credit transfer (BG-16) information is provided in the Invoice.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(ram:IBANID) or (ram:ProprietaryID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(ram:IBANID) or (ram:ProprietaryID)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-61]-If the Payment means type code (BT-81) means SEPA credit transfer, Local credit transfer or Non-SEPA international credit transfer, the Payment account identifier (BT-84) shall be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M46" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M46" priority="-1" />
  <xsl:template match="@*|node()" mode="M46" priority="-2">
    <xsl:apply-templates mode="M46" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="//rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement" mode="M47" priority="1000">
    <svrl:fired-rule context="//rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ram:ApplicableTradeTax" />
      <xsl:otherwise>
        <svrl:failed-assert test="ram:ApplicableTradeTax">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-CO-18]-An Invoice shall at least have one VAT breakdown group (BG-23).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M47" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M47" priority="-1" />
  <xsl:template match="@*|node()" mode="M47" priority="-2">
    <xsl:apply-templates mode="M47" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="//rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode[. = 'AE']" mode="M48" priority="1000">
    <svrl:fired-rule context="//rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode[. = 'AE']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(../ram:BasisAmount -1 &lt; (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = 'AE']/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount)*10*10)div 100) + (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='AE']/ram:ActualAmount)*10*10)div 100) - (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode='AE']/ram:ActualAmount)*10*10)div 100)) and (../ram:BasisAmount +1 > (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = 'AE']/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount)*10*10)div 100) + (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='AE']/ram:ActualAmount)*10*10)div 100) - (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode='AE']/ram:ActualAmount)*10*10)div 100))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(../ram:BasisAmount -1 &lt; (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = 'AE']/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount)*10*10)div 100) + (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='AE']/ram:ActualAmount)*10*10)div 100) - (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode='AE']/ram:ActualAmount)*10*10)div 100)) and (../ram:BasisAmount +1 > (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = 'AE']/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount)*10*10)div 100) + (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='AE']/ram:ActualAmount)*10*10)div 100) - (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode='AE']/ram:ActualAmount)*10*10)div 100))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-AE-08]-In a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Reverse charge" the VAT category taxable amount (BT-116) shall equal the sum of Invoice line net amounts (BT-131) minus the sum of Document level allowance amounts (BT-92) plus the sum of Document level charge amounts (BT-99) where the VAT category codes (BT-151, BT-95, BT-102) are "Reverse charge".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="../ram:CalculatedAmount = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="../ram:CalculatedAmount = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-AE-09]-The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Reverse charge" shall be 0 (zero).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(../ram:ExemptionReason) or (../ram:ExemptionReasonCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(../ram:ExemptionReason) or (../ram:ExemptionReasonCode)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-AE-10]-A VAT Breakdown (BG-23) with VAT Category code (BT-118) "Reverse charge" shall have a VAT exemption reason code (BT-121), meaning "Reverse charge" or the VAT exemption reason text (BT-120) "Reverse charge" (or the equivalent standard text in another language).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M48" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M48" priority="-1" />
  <xsl:template match="@*|node()" mode="M48" priority="-2">
    <xsl:apply-templates mode="M48" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="//rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode[. = 'E']" mode="M49" priority="1000">
    <svrl:fired-rule context="//rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode[. = 'E']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(../ram:BasisAmount - 1 &lt; (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = 'E']/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount)*10*10)div 100) + (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='E']/ram:ActualAmount)*10*10)div 100) - (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode='E']/ram:ActualAmount)*10*10)div 100)) and (../ram:BasisAmount + 1 > (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = 'E']/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount)*10*10)div 100) + (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='E']/ram:ActualAmount)*10*10)div 100) - (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode='E']/ram:ActualAmount)*10*10)div 100))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(../ram:BasisAmount - 1 &lt; (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = 'E']/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount)*10*10)div 100) + (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='E']/ram:ActualAmount)*10*10)div 100) - (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode='E']/ram:ActualAmount)*10*10)div 100)) and (../ram:BasisAmount + 1 > (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = 'E']/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount)*10*10)div 100) + (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='E']/ram:ActualAmount)*10*10)div 100) - (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode='E']/ram:ActualAmount)*10*10)div 100))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-E-08]-In a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Exempt from VAT" the VAT category taxable amount (BT-116) shall equal the sum of Invoice line net amounts (BT-131) minus the sum of Document level allowance amounts (BT-92) plus the sum of Document level charge amounts (BT-99) where the VAT category codes (BT-151, BT-95, BT-102) are "Exempt from VAT".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="../ram:CalculatedAmount = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="../ram:CalculatedAmount = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-E-09]-The VAT category tax amount (BT-117) In a VAT breakdown (BG-23) where the VAT category code (BT-118) equals "Exempt from VAT" shall equal 0 (zero).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(../ram:ExemptionReason) or (../ram:ExemptionReasonCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(../ram:ExemptionReason) or (../ram:ExemptionReasonCode)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-E-10]-A VAT Breakdown (BG-23) with VAT Category code (BT-118) "Exempt from VAT" shall have a VAT exemption reason code (BT-121) or a VAT exemption reason text (BT-120).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M49" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M49" priority="-1" />
  <xsl:template match="@*|node()" mode="M49" priority="-2">
    <xsl:apply-templates mode="M49" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="//rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode[. = 'G']" mode="M50" priority="1000">
    <svrl:fired-rule context="//rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode[. = 'G']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(../ram:BasisAmount -1 &lt; (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = 'G']/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount)*10*10)div 100) + (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='G']/ram:ActualAmount)*10*10)div 100) - (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode='G']/ram:ActualAmount)*10*10)div 100)) and (../ram:BasisAmount +1 > (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = 'G']/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount)*10*10)div 100) + (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='G']/ram:ActualAmount)*10*10)div 100) - (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode='G']/ram:ActualAmount)*10*10)div 100))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(../ram:BasisAmount -1 &lt; (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = 'G']/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount)*10*10)div 100) + (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='G']/ram:ActualAmount)*10*10)div 100) - (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode='G']/ram:ActualAmount)*10*10)div 100)) and (../ram:BasisAmount +1 > (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = 'G']/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount)*10*10)div 100) + (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='G']/ram:ActualAmount)*10*10)div 100) - (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode='G']/ram:ActualAmount)*10*10)div 100))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-G-08]-In a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Export outside the EU" the VAT category taxable amount (BT-116) shall equal the sum of Invoice line net amounts (BT-131) minus the sum of Document level allowance amounts (BT-92) plus the sum of Document level charge amounts (BT-99) where the VAT category codes (BT-151, BT-95, BT-102) are "Export outside the EU".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="../ram:CalculatedAmount = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="../ram:CalculatedAmount = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-G-09]-The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Export outside the EU" shall be 0 (zero).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(../ram:ExemptionReason) or (../ram:ExemptionReasonCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(../ram:ExemptionReason) or (../ram:ExemptionReasonCode)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-G-10]-A VAT Breakdown (BG-23) with the VAT Category code (BT-118) "Export outside the EU" shall have a VAT exemption reason code (BT-121), meaning "Export outside the EU" or the VAT exemption reason text (BT-120) "Export outside the EU" (or the equivalent standard text in another language).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M50" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M50" priority="-1" />
  <xsl:template match="@*|node()" mode="M50" priority="-2">
    <xsl:apply-templates mode="M50" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="//rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode[.= 'K']" mode="M51" priority="1000">
    <svrl:fired-rule context="//rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode[.= 'K']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(../ram:BasisAmount - 1 &lt; (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = 'K']/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount)*10*10)div 100) + (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='K']/ram:ActualAmount)*10*10)div 100) - (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode='K']/ram:ActualAmount)*10*10)div 100)) and (../ram:BasisAmount + 1 > (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = 'K']/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount)*10*10)div 100) + (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='K']/ram:ActualAmount)*10*10)div 100) - (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode='K']/ram:ActualAmount)*10*10)div 100))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(../ram:BasisAmount - 1 &lt; (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = 'K']/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount)*10*10)div 100) + (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='K']/ram:ActualAmount)*10*10)div 100) - (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode='K']/ram:ActualAmount)*10*10)div 100)) and (../ram:BasisAmount + 1 > (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = 'K']/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount)*10*10)div 100) + (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='K']/ram:ActualAmount)*10*10)div 100) - (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode='K']/ram:ActualAmount)*10*10)div 100))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-IC-08]-In a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Intra-community supply" the VAT category taxable amount (BT-116) shall equal the sum of Invoice line net amounts (BT-131) minus the sum of Document level allowance amounts (BT-92) plus the sum of Document level charge amounts (BT-99) where the VAT category codes (BT-151, BT-95, BT-102) are "Intra-community supply".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="../ram:CalculatedAmount = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="../ram:CalculatedAmount = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-IC-09]-The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Intra-community supply" shall be 0 (zero).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(../ram:ExemptionReason) or (../ram:ExemptionReasonCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(../ram:ExemptionReason) or (../ram:ExemptionReasonCode)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-IC-10]-A VAT Breakdown (BG-23) with the VAT Category code (BT-118) "Intra-community supply" shall have a VAT exemption reason code (BT-121), meaning "Intra-community supply" or the VAT exemption reason text (BT-120) "Intra-community supply" (or the equivalent standard text in another language).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ActualDeliverySupplyChainEvent/ram:OccurrenceDateTime/udt:DateTimeString) or (../../ram:BillingSpecifiedPeriod/ram:StartDateTime) or (../../ram:BillingSpecifiedPeriod/ram:EndDateTime)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ActualDeliverySupplyChainEvent/ram:OccurrenceDateTime/udt:DateTimeString) or (../../ram:BillingSpecifiedPeriod/ram:StartDateTime) or (../../ram:BillingSpecifiedPeriod/ram:EndDateTime)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-IC-11]-In an Invoice with a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Intra-community supply" the Actual delivery date (BT-72) or the Invoicing period (BG-14) shall not be blank.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress/ram:CountryID" />
      <xsl:otherwise>
        <svrl:failed-assert test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress/ram:CountryID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-IC-12]-In an Invoice with a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Intra-community supply" the Deliver to country code (BT-80) shall not be blank.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M51" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M51" priority="-1" />
  <xsl:template match="@*|node()" mode="M51" priority="-2">
    <xsl:apply-templates mode="M51" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="//rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode = 'L']" mode="M52" priority="1000">
    <svrl:fired-rule context="//rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode = 'L']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="every $rate in ../ram:RateApplicablePercent/xs:decimal(.) satisfies (../ram:BasisAmount = (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = 'L' and ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 10 * 10) div 100 + round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='L' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 10 * 10) div 100 - round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode='L' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 10 * 10) div 100))" />
      <xsl:otherwise>
        <svrl:failed-assert test="every $rate in ../ram:RateApplicablePercent/xs:decimal(.) satisfies (../ram:BasisAmount = (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = 'L' and ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 10 * 10) div 100 + round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='L' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 10 * 10) div 100 - round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode='L' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 10 * 10) div 100))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-AF-08]-For each different value of VAT category rate (BT-119) where the VAT category code (BT-118) is "IGIC", the VAT category taxable amount (BT-116) in a VAT breakdown (BG-23) shall equal the sum of Invoice line net amounts (BT-131) plus the sum of document level charge amounts (BT-99) minus the sum of document level allowance amounts (BT-92) where the VAT category code (BT-151, BT-102, BT-95) is "IGIC" and the VAT rate (BT-152, BT-103, BT-96) equals the VAT category rate (BT-119).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="true()" />
      <xsl:otherwise>
        <svrl:failed-assert test="true()">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-AF-09]-The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where VAT category code (BT-118) is "IGIC" shall equal the VAT category taxable amount (BT-116) multiplied by the VAT category rate (BT-119).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(ram:ExemptionReason) and not (ram:ExemptionReasonCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(ram:ExemptionReason) and not (ram:ExemptionReasonCode)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-AF-10]-A VAT Breakdown (BG-23) with VAT Category code (BT-118) "IGIC" shall not have a VAT exemption reason code (BT-121) or VAT exemption reason text (BT-120).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M52" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M52" priority="-1" />
  <xsl:template match="@*|node()" mode="M52" priority="-2">
    <xsl:apply-templates mode="M52" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="//rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode = 'M']" mode="M53" priority="1000">
    <svrl:fired-rule context="//rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode = 'M']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="every $rate in ../ram:RateApplicablePercent/xs:decimal(.) satisfies (../ram:BasisAmount = (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = 'M' and ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 10 * 10) div 100 + round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='M' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 10 * 10) div 100 - round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode='M' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 10 * 10) div 100))" />
      <xsl:otherwise>
        <svrl:failed-assert test="every $rate in ../ram:RateApplicablePercent/xs:decimal(.) satisfies (../ram:BasisAmount = (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = 'M' and ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 10 * 10) div 100 + round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='M' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 10 * 10) div 100 - round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode='M' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 10 * 10) div 100))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-AG-08]-For each different value of VAT category rate (BT-119) where the VAT category code (BT-118) is "IPSI", the VAT category taxable amount (BT-116) in a VAT breakdown (BG-23) shall equal the sum of Invoice line net amounts (BT-131) plus the sum of document level charge amounts (BT-99) minus the sum of document level allowance amounts (BT-92) where the VAT category code (BT-151, BT-102, BT-95) is "IPSI" and the VAT rate (BT-152, BT-103, BT-96) equals the VAT category rate (BT-119).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="true()" />
      <xsl:otherwise>
        <svrl:failed-assert test="true()">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-AG-09]-The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where VAT category code (BT-118) is "IPSI" shall equal the VAT category taxable amount (BT-116) multiplied by the VAT category rate (BT-119).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(ram:ExemptionReason) and not (ram:ExemptionReasonCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(ram:ExemptionReason) and not (ram:ExemptionReasonCode)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-AG-10]-A VAT Breakdown (BG-23) with VAT Category code (BT-118) "IPSI" shall not have a VAT exemption reason code (BT-121) or VAT exemption reason text (BT-120).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M53" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M53" priority="-1" />
  <xsl:template match="@*|node()" mode="M53" priority="-2">
    <xsl:apply-templates mode="M53" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="//rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode = 'O']" mode="M54" priority="1000">
    <svrl:fired-rule context="//rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode = 'O']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ram:BasisAmount = (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = 'O']/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount))*10*10)div 100) + (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[(ram:ChargeIndicator/udt:Indicator cast as xs:boolean)=true() and ram:CategoryTradeTax/ram:CategoryCode='O']/xs:decimal(ram:ActualAmount))*10*10)div 100) - (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[(ram:ChargeIndicator/udt:Indicator cast as xs:boolean)=false() and ram:CategoryTradeTax/ram:CategoryCode='O']/xs:decimal(ram:ActualAmount))*10*10)div 100)" />
      <xsl:otherwise>
        <svrl:failed-assert test="ram:BasisAmount = (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = 'O']/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount))*10*10)div 100) + (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[(ram:ChargeIndicator/udt:Indicator cast as xs:boolean)=true() and ram:CategoryTradeTax/ram:CategoryCode='O']/xs:decimal(ram:ActualAmount))*10*10)div 100) - (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[(ram:ChargeIndicator/udt:Indicator cast as xs:boolean)=false() and ram:CategoryTradeTax/ram:CategoryCode='O']/xs:decimal(ram:ActualAmount))*10*10)div 100)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-O-08]-In a VAT breakdown (BG-23) where the VAT category code (BT-118) is " Not subject to VAT" the VAT category taxable amount (BT-116) shall equal the sum of Invoice line net amounts (BT-131) minus the sum of Document level allowance amounts (BT-92) plus the sum of Document level charge amounts (BT-99) where the VAT category codes (BT-151, BT-95, BT-102) are "Not subject to VAT".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ram:CalculatedAmount = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="ram:CalculatedAmount = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-O-09]-The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Not subject to VAT" shall be 0 (zero).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(ram:ExemptionReason) or (ram:ExemptionReasonCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(ram:ExemptionReason) or (ram:ExemptionReasonCode)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-O-10]-A VAT Breakdown (BG-23) with VAT Category code (BT-118) " Not subject to VAT" shall have a VAT exemption reason code (BT-121), meaning " Not subject to VAT" or a VAT exemption reason text (BT-120) " Not subject to VAT" (or the equivalent standard text in another language).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(//ram:ApplicableTradeTax[ram:CategoryCode != 'O'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(//ram:ApplicableTradeTax[ram:CategoryCode != 'O'])">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-O-11]-An Invoice that contains a VAT breakdown group (BG-23) with a VAT category code (BT-118) "Not subject to VAT" shall not contain other VAT breakdown groups (BG-23).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(//ram:ApplicableTradeTax[ram:CategoryCode != 'O'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(//ram:ApplicableTradeTax[ram:CategoryCode != 'O'])">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-O-12]-An Invoice that contains a VAT breakdown group (BG-23) with a VAT category code (BT-118) "Not subject to VAT" shall not contain an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is not "Not subject to VAT".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(//ram:CategoryTradeTax[ram:CategoryCode != 'O'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(//ram:CategoryTradeTax[ram:CategoryCode != 'O'])">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-O-13]-An Invoice that contains a VAT breakdown group (BG-23) with a VAT category code (BT-118) "Not subject to VAT" shall not contain Document level allowances (BG-20) where Document level allowance VAT category code (BT-95) is not "Not subject to VAT".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(//ram:CategoryTradeTax[ram:CategoryCode != 'O'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(//ram:CategoryTradeTax[ram:CategoryCode != 'O'])">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-O-14]-An Invoice that contains a VAT breakdown group (BG-23) with a VAT category code (BT-118) "Not subject to VAT" shall not contain Document level charges (BG-21) where Document level charge VAT category code (BT-102) is not "Not subject to VAT".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M54" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M54" priority="-1" />
  <xsl:template match="@*|node()" mode="M54" priority="-2">
    <xsl:apply-templates mode="M54" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="//rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode = 'AE']" mode="M55" priority="1000">
    <svrl:fired-rule context="//rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode = 'AE']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(//ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = ('VA', 'FC')] or //ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']) and (//ram:BuyerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA'] or //ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:ID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(//ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = ('VA', 'FC')] or //ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']) and (//ram:BuyerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA'] or //ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:ID)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-AE-02]-An Invoice that contains an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Reverse charge" shall contain the Seller VAT Identifier (BT-31), the Seller Tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63) and the Buyer VAT identifier (BT-48) and/or the Buyer legal registration identifier (BT-47).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ram:RateApplicablePercent = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="ram:RateApplicablePercent = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-AE-05]-In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Reverse charge" the Invoiced item VAT rate (BT-152) shall be 0 (zero).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M55" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M55" priority="-1" />
  <xsl:template match="@*|node()" mode="M55" priority="-2">
    <xsl:apply-templates mode="M55" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="//rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode = 'E']" mode="M56" priority="1000">
    <svrl:fired-rule context="//rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode = 'E']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = ('VA', 'FC')] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']" />
      <xsl:otherwise>
        <svrl:failed-assert test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = ('VA', 'FC')] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-E-02]-An Invoice that contains an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Exempt from VAT" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ram:RateApplicablePercent = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="ram:RateApplicablePercent = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-E-05]-In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Exempt from VAT", the Invoiced item VAT rate (BT-152) shall be 0 (zero).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M56" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M56" priority="-1" />
  <xsl:template match="@*|node()" mode="M56" priority="-2">
    <xsl:apply-templates mode="M56" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="//rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode = 'G']" mode="M57" priority="1000">
    <svrl:fired-rule context="//rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode = 'G']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(//ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA'] or //ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="(//ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA'] or //ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA'])">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-G-02]-An Invoice that contains an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Export outside the EU" shall contain the Seller VAT Identifier (BT-31) or the Seller tax representative VAT identifier (BT-63).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ram:RateApplicablePercent = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="ram:RateApplicablePercent = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-G-05]-In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Export outside the EU" the Invoiced item VAT rate (BT-152) shall be 0 (zero).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M57" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M57" priority="-1" />
  <xsl:template match="@*|node()" mode="M57" priority="-2">
    <xsl:apply-templates mode="M57" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="//rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode = 'K']" mode="M58" priority="1000">
    <svrl:fired-rule context="//rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode = 'K']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(//ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA'] or //ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']) and //ram:BuyerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']" />
      <xsl:otherwise>
        <svrl:failed-assert test="(//ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA'] or //ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']) and //ram:BuyerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-IC-02]-An Invoice that contains an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Intra-community supply" shall contain the Seller VAT Identifier (BT-31) or the Seller tax representative VAT identifier (BT-63) and the Buyer VAT identifier (BT-48).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ram:RateApplicablePercent = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="ram:RateApplicablePercent = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-IC-05]-In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Intracommunity supply" the Invoiced item VAT rate (BT-152) shall be 0 (zero).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M58" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M58" priority="-1" />
  <xsl:template match="@*|node()" mode="M58" priority="-2">
    <xsl:apply-templates mode="M58" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="//rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode = 'L']" mode="M59" priority="1000">
    <svrl:fired-rule context="//rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode = 'L']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = ('VA', 'FC')] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']" />
      <xsl:otherwise>
        <svrl:failed-assert test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = ('VA', 'FC')] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-AF-02]-An Invoice that contains an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "IGIC" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ram:RateApplicablePercent > 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="ram:RateApplicablePercent > 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-AF-05]-In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "IGIC" the invoiced item VAT rate (BT-152) shall be greater than 0 (zero).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M59" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M59" priority="-1" />
  <xsl:template match="@*|node()" mode="M59" priority="-2">
    <xsl:apply-templates mode="M59" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="//rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode = 'M']" mode="M60" priority="1000">
    <svrl:fired-rule context="//rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode = 'M']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = ('VA', 'FC')] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']" />
      <xsl:otherwise>
        <svrl:failed-assert test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = ('VA', 'FC')] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-AG-02]-An Invoice that contains an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "IPSI" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ram:RateApplicablePercent > 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="ram:RateApplicablePercent > 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-AG-05]-In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "IPSI" the Invoiced item VAT rate (BT-152) shall be 0 (zero) or greater than zero.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M60" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M60" priority="-1" />
  <xsl:template match="@*|node()" mode="M60" priority="-2">
    <xsl:apply-templates mode="M60" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="//rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode = 'O']" mode="M61" priority="1000">
    <svrl:fired-rule context="//rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode = 'O']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']) and not (/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']) and not (/ram:BuyerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']) and not (/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']) and not (/ram:BuyerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA'])">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-O-02]-An Invoice that contains an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Not subject to VAT" shall not contain the Seller VAT identifier (BT-31), the Seller tax representative VAT identifier (BT-63) or the Buyer VAT identifier (BT-46).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(ram:RateApplicablePercent)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(ram:RateApplicablePercent)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-O-05]-An Invoice line (BG-25) where the VAT category code (BT-151) is "Not subject to VAT" shall not contain an Invoiced item VAT rate (BT-152).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M61" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M61" priority="-1" />
  <xsl:template match="@*|node()" mode="M61" priority="-2">
    <xsl:apply-templates mode="M61" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="//rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode = 'S']" mode="M62" priority="1000">
    <svrl:fired-rule context="//rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode = 'S']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = ('VA', 'FC')] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']" />
      <xsl:otherwise>
        <svrl:failed-assert test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = ('VA', 'FC')] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-S-02]-An Invoice that contains an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Standard rated" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ram:RateApplicablePercent > 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="ram:RateApplicablePercent > 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-S-05]-In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Standard rated" the Invoiced item VAT rate (BT-152) shall be greater than zero.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M62" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M62" priority="-1" />
  <xsl:template match="@*|node()" mode="M62" priority="-2">
    <xsl:apply-templates mode="M62" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="//rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode = 'Z']" mode="M63" priority="1000">
    <svrl:fired-rule context="//rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode = 'Z']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = ('VA', 'FC')] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']" />
      <xsl:otherwise>
        <svrl:failed-assert test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = ('VA', 'FC')] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-Z-02]-An Invoice that contains an Invoice line where the Invoiced item VAT category code (BT-151) is "Zero rated" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ram:RateApplicablePercent = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="ram:RateApplicablePercent = 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-Z-05]-In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Zero rated" the Invoiced item VAT rate (BT-152) shall be 0 (zero).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M63" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M63" priority="-1" />
  <xsl:template match="@*|node()" mode="M63" priority="-2">
    <xsl:apply-templates mode="M63" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice" mode="M64" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="//ram:IncludedSupplyChainTradeLineItem" />
      <xsl:otherwise>
        <svrl:failed-assert test="//ram:IncludedSupplyChainTradeLineItem">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-16]-An Invoice shall have at least one Invoice line (BG-25).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(number(//ram:DuePayableAmount) > 0 and ((//ram:SpecifiedTradePaymentTerms/ram:DueDateDateTime) or (//ram:SpecifiedTradePaymentTerms/ram:Description))) or not(number(//ram:DuePayableAmount) > 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(number(//ram:DuePayableAmount) > 0 and ((//ram:SpecifiedTradePaymentTerms/ram:DueDateDateTime) or (//ram:SpecifiedTradePaymentTerms/ram:Description))) or not(number(//ram:DuePayableAmount) > 0)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-CO-25]-In case the Amount due for payment (BT-115) is positive, either the Payment due date (BT-9) or the Payment terms (BT-20) shall be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(rsm:ExchangedDocumentContext/ram:GuidelineSpecifiedDocumentContextParameter/ram:ID != '')" />
      <xsl:otherwise>
        <svrl:failed-assert test="(rsm:ExchangedDocumentContext/ram:GuidelineSpecifiedDocumentContextParameter/ram:ID != '')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-01]-An Invoice shall have a Specification identifier (BT-24).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(rsm:ExchangedDocument/ram:ID !='')" />
      <xsl:otherwise>
        <svrl:failed-assert test="(rsm:ExchangedDocument/ram:ID !='')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-02]-An Invoice shall have an Invoice number (BT-1).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(rsm:ExchangedDocument/ram:IssueDateTime/udt:DateTimeString[@format='102']!='')" />
      <xsl:otherwise>
        <svrl:failed-assert test="(rsm:ExchangedDocument/ram:IssueDateTime/udt:DateTimeString[@format='102']!='')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-03]-An Invoice shall have an Invoice issue date (BT-2).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(rsm:ExchangedDocument/ram:TypeCode!='')" />
      <xsl:otherwise>
        <svrl:failed-assert test="(rsm:ExchangedDocument/ram:TypeCode!='')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-04]-An Invoice shall have an Invoice type code (BT-3).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode!='')" />
      <xsl:otherwise>
        <svrl:failed-assert test="(rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode!='')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-05]-An Invoice shall have an Invoice currency code (BT-5).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:Name!='')" />
      <xsl:otherwise>
        <svrl:failed-assert test="(rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:Name!='')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-06]-An Invoice shall contain the Seller name (BT-27).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:Name!='')" />
      <xsl:otherwise>
        <svrl:failed-assert test="(rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:Name!='')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-07]-An Invoice shall contain the Buyer name (BT-44).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="//ram:SellerTradeParty/ram:PostalTradeAddress" />
      <xsl:otherwise>
        <svrl:failed-assert test="//ram:SellerTradeParty/ram:PostalTradeAddress">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-08]-An Invoice shall contain the Seller postal address (BG-5).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="//ram:SellerTradeParty/ram:PostalTradeAddress/ram:CountryID!=''" />
      <xsl:otherwise>
        <svrl:failed-assert test="//ram:SellerTradeParty/ram:PostalTradeAddress/ram:CountryID!=''">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-09]-The Seller postal address (BG-5) shall contain a Seller country code (BT-40).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="//ram:BuyerTradeParty/ram:PostalTradeAddress" />
      <xsl:otherwise>
        <svrl:failed-assert test="//ram:BuyerTradeParty/ram:PostalTradeAddress">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-10]-An Invoice shall contain the Buyer postal address (BG-8).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="//ram:BuyerTradeParty/ram:PostalTradeAddress/ram:CountryID!=''" />
      <xsl:otherwise>
        <svrl:failed-assert test="//ram:BuyerTradeParty/ram:PostalTradeAddress/ram:CountryID!=''">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-11]-The Buyer postal address shall contain a Buyer country code (BT-55).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:URIUniversalCommunication[1]/ram:URIID/@schemeID) != '' or not (rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:URIUniversalCommunication)" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:URIUniversalCommunication[1]/ram:URIID/@schemeID) != '' or not (rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:URIUniversalCommunication)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-62]-The Seller electronic address (BT-34) shall have a Scheme identifier.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:URIUniversalCommunication[1]/ram:URIID/@schemeID) != '' or not (rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:URIUniversalCommunication)" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:URIUniversalCommunication[1]/ram:URIID/@schemeID) != '' or not (rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:URIUniversalCommunication)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-63]-The Buyer electronic address (BT-49) shall have a Scheme identifier.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((count(//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='S']) + count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='S'])) >=2 or not (//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='S'])) and     ((count(//ram:CategoryTradeTax[ram:CategoryCode='S']) + count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='S'])) >=2 or not (//ram:CategoryTradeTax[ram:CategoryCode='S']))" />
      <xsl:otherwise>
        <svrl:failed-assert test="((count(//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='S']) + count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='S'])) >=2 or not (//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='S'])) and ((count(//ram:CategoryTradeTax[ram:CategoryCode='S']) + count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='S'])) >=2 or not (//ram:CategoryTradeTax[ram:CategoryCode='S']))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-S-01]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is "Standard rated" shall contain in the VAT breakdown (BG-23) at least one VAT category code (BT-118) equal with "Standard rated".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='Z'])=0 and count(//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='Z'])=0 and count(//ram:CategoryTradeTax[ram:CategoryCode='Z'])=0) or ( count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='Z'])=1 and (exists(//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='Z']) or exists(//ram:CategoryTradeTax[ram:CategoryCode='Z'])))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='Z'])=0 and count(//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='Z'])=0 and count(//ram:CategoryTradeTax[ram:CategoryCode='Z'])=0) or ( count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='Z'])=1 and (exists(//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='Z']) or exists(//ram:CategoryTradeTax[ram:CategoryCode='Z'])))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-Z-01]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is "Zero rated" shall contain in the VAT breakdown (BG-23) exactly one VAT category code (BT-118) equal with "Zero rated".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='E'])=0 and count(//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='E'])=0 and count(//ram:CategoryTradeTax[ram:CategoryCode='E'])=0) or ( count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='E'])=1 and (exists(//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='E']) or exists(//ram:CategoryTradeTax[ram:CategoryCode='E'])))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='E'])=0 and count(//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='E'])=0 and count(//ram:CategoryTradeTax[ram:CategoryCode='E'])=0) or ( count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='E'])=1 and (exists(//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='E']) or exists(//ram:CategoryTradeTax[ram:CategoryCode='E'])))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-E-01]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is “Exempt from VAT” shall contain exactly one VAT breakdown (BG-23) with the VAT category code (BT-118) equal to "Exempt from VAT".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='AE'])=0 and count(//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='AE'])=0 and count(//ram:CategoryTradeTax[ram:CategoryCode='AE'])=0) or ( count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='AE'])=1 and (exists(//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='AE']) or exists(//ram:CategoryTradeTax[ram:CategoryCode='AE'])))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='AE'])=0 and count(//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='AE'])=0 and count(//ram:CategoryTradeTax[ram:CategoryCode='AE'])=0) or ( count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='AE'])=1 and (exists(//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='AE']) or exists(//ram:CategoryTradeTax[ram:CategoryCode='AE'])))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-AE-01]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is "Reverse charge" shall contain in the VAT breakdown (BG-23) exactly one VAT category code (BT-118) equal with "VAT reverse charge".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='K'])=0 and count(//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='K'])=0 and count(//ram:CategoryTradeTax[ram:CategoryCode='K'])=0) or ( count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='K'])=1 and (exists(//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='K']) or exists(//ram:CategoryTradeTax[ram:CategoryCode='K'])))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='K'])=0 and count(//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='K'])=0 and count(//ram:CategoryTradeTax[ram:CategoryCode='K'])=0) or ( count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='K'])=1 and (exists(//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='K']) or exists(//ram:CategoryTradeTax[ram:CategoryCode='K'])))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-IC-01]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is "Intra-community supply" shall contain in the VAT breakdown (BG-23) exactly one VAT category code (BT-118) equal with "Intra-community supply".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='G'])=0 and count(//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='G'])=0 and count(//ram:CategoryTradeTax[ram:CategoryCode='G'])=0) or ( count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='G'])=1 and (exists(//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='G']) or exists(//ram:CategoryTradeTax[ram:CategoryCode='G'])))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='G'])=0 and count(//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='G'])=0 and count(//ram:CategoryTradeTax[ram:CategoryCode='G'])=0) or ( count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='G'])=1 and (exists(//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='G']) or exists(//ram:CategoryTradeTax[ram:CategoryCode='G'])))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-G-01]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is "Export outside the EU" shall contain in the VAT breakdown (BG-23) exactly one VAT category code (BT-118) equal with "Export outside the EU".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='O']) or ( &#xD;&#xA;    count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='O'])=1 and &#xD;&#xA;    (exists(//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='O']) or&#xD;&#xA;    exists(//ram:CategoryTradeTax[ram:CategoryCode='O'])))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='O']) or ( count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='O'])=1 and (exists(//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='O']) or exists(//ram:CategoryTradeTax[ram:CategoryCode='O'])))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-O-01]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is "Not subject to VAT" shall contain exactly one VAT breakdown group (BG-23) with the VAT category code (BT-118) equal to "Not subject to VAT".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((count(//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='L']) + count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='L'])) >=2 or not (//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='L'])) and &#xD;&#xA;    ((count(//ram:CategoryTradeTax[ram:CategoryCode='L']) + count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='L'])) >=2 or not (//ram:CategoryTradeTax[ram:CategoryCode='L']))" />
      <xsl:otherwise>
        <svrl:failed-assert test="((count(//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='L']) + count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='L'])) >=2 or not (//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='L'])) and ((count(//ram:CategoryTradeTax[ram:CategoryCode='L']) + count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='L'])) >=2 or not (//ram:CategoryTradeTax[ram:CategoryCode='L']))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-AF-01]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is "IGIC" shall contain in the VAT breakdown (BG-23) at least one VAT category code (BT-118) equal with "IGIC".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((count(//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='M']) + count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='M'])) >=2 or not (//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='M'])) and &#xD;&#xA;    ((count(//ram:CategoryTradeTax[ram:CategoryCode='M']) + count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='M'])) >=2 or not (//ram:CategoryTradeTax[ram:CategoryCode='M']))" />
      <xsl:otherwise>
        <svrl:failed-assert test="((count(//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='M']) + count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='M'])) >=2 or not (//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='M'])) and ((count(//ram:CategoryTradeTax[ram:CategoryCode='M']) + count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='M'])) >=2 or not (//ram:CategoryTradeTax[ram:CategoryCode='M']))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-AG-01]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is "IPSI" shall contain in the VAT breakdown (BG-23) at least one VAT category code (BT-118) equal with "IPSI".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(not(//ram:CountryID != 'IT') and //ram:CategoryCode ='B') or (not(//ram:CategoryCode ='B'))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(not(//ram:CountryID != 'IT') and //ram:CategoryCode ='B') or (not(//ram:CategoryCode ='B'))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-B-01]-An Invoice where the VAT category code (BT-151, BT-95 or BT-102) is “Split payment” shall be a domestic Italian invoice.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(//ram:CategoryCode ='B' and (not(//ram:CategoryCode ='S'))) or (not(//ram:CategoryCode ='B'))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(//ram:CategoryCode ='B' and (not(//ram:CategoryCode ='S'))) or (not(//ram:CategoryCode ='B'))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-B-02]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is “Split payment" shall not contain an invoice line (BG-25), a Document level allowance (BG-20) or  a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is “Standard rated”.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M64" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M64" priority="-1" />
  <xsl:template match="@*|node()" mode="M64" priority="-2">
    <xsl:apply-templates mode="M64" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument" mode="M65" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:ID)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:ID)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:ID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:TypeCode)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:TypeCode)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:TypeCode' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M65" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M65" priority="-1" />
  <xsl:template match="@*|node()" mode="M65" priority="-2">
    <xsl:apply-templates mode="M65" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:ID[@schemeID]" mode="M66" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:ID[@schemeID]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Attribute @schemeID' marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M66" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M66" priority="-1" />
  <xsl:template match="@*|node()" mode="M66" priority="-2">
    <xsl:apply-templates mode="M66" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:IncludedNote" mode="M67" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:IncludedNote" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:Content)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:Content)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:Content' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:SubjectCode)&lt;=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:SubjectCode)&lt;=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:SubjectCode' may occur at maximum 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M67" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M67" priority="-1" />
  <xsl:template match="@*|node()" mode="M67" priority="-2">
    <xsl:apply-templates mode="M67" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:IncludedNote/ram:SubjectCode" mode="M68" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:IncludedNote/ram:SubjectCode" />
    <xsl:variable name="codeValue4" select="." />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=4]/enumeration[@value=$codeValue4]" />
      <xsl:otherwise>
        <svrl:failed-assert test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=4]/enumeration[@value=$codeValue4]">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Value of 'ram:SubjectCode' is not allowed.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M68" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M68" priority="-1" />
  <xsl:template match="@*|node()" mode="M68" priority="-2">
    <xsl:apply-templates mode="M68" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:IncludedNote/ram:SubjectCode[@listID]" mode="M69" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:IncludedNote/ram:SubjectCode[@listID]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Attribute @listID' marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M69" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M69" priority="-1" />
  <xsl:template match="@*|node()" mode="M69" priority="-2">
    <xsl:apply-templates mode="M69" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:IncludedNote/ram:SubjectCode[@listVersionID]" mode="M70" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:IncludedNote/ram:SubjectCode[@listVersionID]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Attribute @listVersionID' marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M70" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M70" priority="-1" />
  <xsl:template match="@*|node()" mode="M70" priority="-2">
    <xsl:apply-templates mode="M70" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:IssueDateTime/udt:DateTimeString" mode="M71" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:IssueDateTime/udt:DateTimeString" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@format" />
      <xsl:otherwise>
        <svrl:failed-assert test="@format">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@format' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M71" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M71" priority="-1" />
  <xsl:template match="@*|node()" mode="M71" priority="-2">
    <xsl:apply-templates mode="M71" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:IssueDateTime/udt:DateTimeString[@format]" mode="M72" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:IssueDateTime/udt:DateTimeString[@format]" />
    <xsl:variable name="codeValue3" select="@format" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=3]/enumeration[@value=$codeValue3]" />
      <xsl:otherwise>
        <svrl:failed-assert test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=3]/enumeration[@value=$codeValue3]">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Value of '@format' is not allowed.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M72" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M72" priority="-1" />
  <xsl:template match="@*|node()" mode="M72" priority="-2">
    <xsl:apply-templates mode="M72" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:TypeCode" mode="M73" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:TypeCode" />
    <xsl:variable name="codeValue2" select="." />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=2]/enumeration[@value=$codeValue2]" />
      <xsl:otherwise>
        <svrl:failed-assert test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=2]/enumeration[@value=$codeValue2]">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Value of 'ram:TypeCode' is not allowed.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M73" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M73" priority="-1" />
  <xsl:template match="@*|node()" mode="M73" priority="-2">
    <xsl:apply-templates mode="M73" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext" mode="M74" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:BusinessProcessSpecifiedDocumentContextParameter)&lt;=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:BusinessProcessSpecifiedDocumentContextParameter)&lt;=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:BusinessProcessSpecifiedDocumentContextParameter' may occur at maximum 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:GuidelineSpecifiedDocumentContextParameter)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:GuidelineSpecifiedDocumentContextParameter)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:GuidelineSpecifiedDocumentContextParameter' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M74" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M74" priority="-1" />
  <xsl:template match="@*|node()" mode="M74" priority="-2">
    <xsl:apply-templates mode="M74" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:BusinessProcessSpecifiedDocumentContextParameter" mode="M75" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:BusinessProcessSpecifiedDocumentContextParameter" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:ID)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:ID)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:ID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M75" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M75" priority="-1" />
  <xsl:template match="@*|node()" mode="M75" priority="-2">
    <xsl:apply-templates mode="M75" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:BusinessProcessSpecifiedDocumentContextParameter/ram:ID[@schemeID]" mode="M76" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:BusinessProcessSpecifiedDocumentContextParameter/ram:ID[@schemeID]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Attribute @schemeID' marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M76" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M76" priority="-1" />
  <xsl:template match="@*|node()" mode="M76" priority="-2">
    <xsl:apply-templates mode="M76" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:GuidelineSpecifiedDocumentContextParameter" mode="M77" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:GuidelineSpecifiedDocumentContextParameter" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:ID)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:ID)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:ID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M77" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M77" priority="-1" />
  <xsl:template match="@*|node()" mode="M77" priority="-2">
    <xsl:apply-templates mode="M77" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:GuidelineSpecifiedDocumentContextParameter/ram:ID" mode="M78" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:GuidelineSpecifiedDocumentContextParameter/ram:ID" />
    <xsl:variable name="codeValue1" select="." />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=1]/enumeration[@value=$codeValue1]" />
      <xsl:otherwise>
        <svrl:failed-assert test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=1]/enumeration[@value=$codeValue1]">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Value of 'ram:ID' is not allowed.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M78" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M78" priority="-1" />
  <xsl:template match="@*|node()" mode="M78" priority="-2">
    <xsl:apply-templates mode="M78" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:GuidelineSpecifiedDocumentContextParameter/ram:ID[@schemeID]" mode="M79" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:GuidelineSpecifiedDocumentContextParameter/ram:ID[@schemeID]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Attribute @schemeID' marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M79" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M79" priority="-1" />
  <xsl:template match="@*|node()" mode="M79" priority="-2">
    <xsl:apply-templates mode="M79" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction" mode="M80" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:IncludedSupplyChainTradeLineItem)>=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:IncludedSupplyChainTradeLineItem)>=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:IncludedSupplyChainTradeLineItem' must occur at least 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M80" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M80" priority="-1" />
  <xsl:template match="@*|node()" mode="M80" priority="-2">
    <xsl:apply-templates mode="M80" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement" mode="M81" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:SellerTradeParty)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:SellerTradeParty)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:SellerTradeParty' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:BuyerTradeParty)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:BuyerTradeParty)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:BuyerTradeParty' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M81" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M81" priority="-1" />
  <xsl:template match="@*|node()" mode="M81" priority="-2">
    <xsl:apply-templates mode="M81" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ not(ram:TypeCode=&quot;916&quot;) and  not(ram:TypeCode=&quot;50&quot;) and  not(ram:TypeCode=&quot;130&quot;)]" mode="M82" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ not(ram:TypeCode=&quot;916&quot;) and  not(ram:TypeCode=&quot;50&quot;) and  not(ram:TypeCode=&quot;130&quot;)]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element variant 'ram:AdditionalReferencedDocument[ not(ram:TypeCode="916") and  not(ram:TypeCode="50") and  not(ram:TypeCode="130")]' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M82" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M82" priority="-1" />
  <xsl:template match="@*|node()" mode="M82" priority="-2">
    <xsl:apply-templates mode="M82" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;130&quot;]" mode="M83" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;130&quot;]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:IssuerAssignedID)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:IssuerAssignedID)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:IssuerAssignedID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:TypeCode)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:TypeCode)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:TypeCode' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M83" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M83" priority="-1" />
  <xsl:template match="@*|node()" mode="M83" priority="-2">
    <xsl:apply-templates mode="M83" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;130&quot;]/ram:AttachmentBinaryObject" mode="M84" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;130&quot;]/ram:AttachmentBinaryObject" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M84" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M84" priority="-1" />
  <xsl:template match="@*|node()" mode="M84" priority="-2">
    <xsl:apply-templates mode="M84" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;130&quot;]/ram:FormattedIssueDateTime" mode="M85" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;130&quot;]/ram:FormattedIssueDateTime" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:FormattedIssueDateTime' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M85" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M85" priority="-1" />
  <xsl:template match="@*|node()" mode="M85" priority="-2">
    <xsl:apply-templates mode="M85" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;130&quot;]/ram:IssuerAssignedID[@schemeID]" mode="M86" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;130&quot;]/ram:IssuerAssignedID[@schemeID]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Attribute @schemeID' marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M86" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M86" priority="-1" />
  <xsl:template match="@*|node()" mode="M86" priority="-2">
    <xsl:apply-templates mode="M86" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;130&quot;]/ram:LineID" mode="M87" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;130&quot;]/ram:LineID" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:LineID' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M87" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M87" priority="-1" />
  <xsl:template match="@*|node()" mode="M87" priority="-2">
    <xsl:apply-templates mode="M87" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;130&quot;]/ram:Name" mode="M88" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;130&quot;]/ram:Name" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:Name' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M88" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M88" priority="-1" />
  <xsl:template match="@*|node()" mode="M88" priority="-2">
    <xsl:apply-templates mode="M88" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;130&quot;]/ram:ReferenceTypeCode" mode="M89" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;130&quot;]/ram:ReferenceTypeCode" />
    <xsl:variable name="codeValue14" select="." />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=14]/enumeration[@value=$codeValue14]" />
      <xsl:otherwise>
        <svrl:failed-assert test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=14]/enumeration[@value=$codeValue14]">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Value of 'ram:ReferenceTypeCode' is not allowed.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M89" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M89" priority="-1" />
  <xsl:template match="@*|node()" mode="M89" priority="-2">
    <xsl:apply-templates mode="M89" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;130&quot;]/ram:TypeCode" mode="M90" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;130&quot;]/ram:TypeCode" />
    <xsl:variable name="codeValue23" select="." />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=23]/enumeration[@value=$codeValue23]" />
      <xsl:otherwise>
        <svrl:failed-assert test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=23]/enumeration[@value=$codeValue23]">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Value of 'ram:TypeCode' is not allowed.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M90" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M90" priority="-1" />
  <xsl:template match="@*|node()" mode="M90" priority="-2">
    <xsl:apply-templates mode="M90" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;130&quot;]/ram:URIID" mode="M91" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;130&quot;]/ram:URIID" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:URIID' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M91" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M91" priority="-1" />
  <xsl:template match="@*|node()" mode="M91" priority="-2">
    <xsl:apply-templates mode="M91" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;50&quot;]" mode="M92" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;50&quot;]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:IssuerAssignedID)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:IssuerAssignedID)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:IssuerAssignedID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:TypeCode)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:TypeCode)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:TypeCode' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M92" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M92" priority="-1" />
  <xsl:template match="@*|node()" mode="M92" priority="-2">
    <xsl:apply-templates mode="M92" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;50&quot;]/ram:AttachmentBinaryObject" mode="M93" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;50&quot;]/ram:AttachmentBinaryObject" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M93" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M93" priority="-1" />
  <xsl:template match="@*|node()" mode="M93" priority="-2">
    <xsl:apply-templates mode="M93" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;50&quot;]/ram:FormattedIssueDateTime" mode="M94" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;50&quot;]/ram:FormattedIssueDateTime" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:FormattedIssueDateTime' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M94" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M94" priority="-1" />
  <xsl:template match="@*|node()" mode="M94" priority="-2">
    <xsl:apply-templates mode="M94" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;50&quot;]/ram:IssuerAssignedID[@schemeID]" mode="M95" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;50&quot;]/ram:IssuerAssignedID[@schemeID]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Attribute @schemeID' marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M95" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M95" priority="-1" />
  <xsl:template match="@*|node()" mode="M95" priority="-2">
    <xsl:apply-templates mode="M95" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;50&quot;]/ram:LineID" mode="M96" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;50&quot;]/ram:LineID" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:LineID' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M96" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M96" priority="-1" />
  <xsl:template match="@*|node()" mode="M96" priority="-2">
    <xsl:apply-templates mode="M96" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;50&quot;]/ram:Name" mode="M97" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;50&quot;]/ram:Name" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:Name' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M97" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M97" priority="-1" />
  <xsl:template match="@*|node()" mode="M97" priority="-2">
    <xsl:apply-templates mode="M97" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;50&quot;]/ram:ReferenceTypeCode" mode="M98" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;50&quot;]/ram:ReferenceTypeCode" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:ReferenceTypeCode' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M98" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M98" priority="-1" />
  <xsl:template match="@*|node()" mode="M98" priority="-2">
    <xsl:apply-templates mode="M98" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;50&quot;]/ram:TypeCode" mode="M99" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;50&quot;]/ram:TypeCode" />
    <xsl:variable name="codeValue22" select="." />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=22]/enumeration[@value=$codeValue22]" />
      <xsl:otherwise>
        <svrl:failed-assert test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=22]/enumeration[@value=$codeValue22]">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Value of 'ram:TypeCode' is not allowed.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M99" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M99" priority="-1" />
  <xsl:template match="@*|node()" mode="M99" priority="-2">
    <xsl:apply-templates mode="M99" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;50&quot;]/ram:URIID" mode="M100" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;50&quot;]/ram:URIID" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:URIID' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M100" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M100" priority="-1" />
  <xsl:template match="@*|node()" mode="M100" priority="-2">
    <xsl:apply-templates mode="M100" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;916&quot;]" mode="M101" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;916&quot;]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:IssuerAssignedID)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:IssuerAssignedID)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:IssuerAssignedID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:TypeCode)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:TypeCode)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:TypeCode' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:Name)&lt;=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:Name)&lt;=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:Name' may occur at maximum 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:AttachmentBinaryObject)&lt;=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:AttachmentBinaryObject)&lt;=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:AttachmentBinaryObject' may occur at maximum 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M101" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M101" priority="-1" />
  <xsl:template match="@*|node()" mode="M101" priority="-2">
    <xsl:apply-templates mode="M101" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;916&quot;]/ram:AttachmentBinaryObject" mode="M102" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;916&quot;]/ram:AttachmentBinaryObject" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@mimeCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@mimeCode">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@mimeCode' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@filename" />
      <xsl:otherwise>
        <svrl:failed-assert test="@filename">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@filename' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M102" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M102" priority="-1" />
  <xsl:template match="@*|node()" mode="M102" priority="-2">
    <xsl:apply-templates mode="M102" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;916&quot;]/ram:AttachmentBinaryObject[@mimeCode]" mode="M103" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;916&quot;]/ram:AttachmentBinaryObject[@mimeCode]" />
    <xsl:variable name="codeValue21" select="@mimeCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=21]/enumeration[@value=$codeValue21]" />
      <xsl:otherwise>
        <svrl:failed-assert test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=21]/enumeration[@value=$codeValue21]">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Value of '@mimeCode' is not allowed.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M103" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M103" priority="-1" />
  <xsl:template match="@*|node()" mode="M103" priority="-2">
    <xsl:apply-templates mode="M103" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;916&quot;]/ram:FormattedIssueDateTime" mode="M104" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;916&quot;]/ram:FormattedIssueDateTime" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:FormattedIssueDateTime' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M104" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M104" priority="-1" />
  <xsl:template match="@*|node()" mode="M104" priority="-2">
    <xsl:apply-templates mode="M104" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;916&quot;]/ram:IssuerAssignedID[@schemeID]" mode="M105" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;916&quot;]/ram:IssuerAssignedID[@schemeID]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Attribute @schemeID' marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M105" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M105" priority="-1" />
  <xsl:template match="@*|node()" mode="M105" priority="-2">
    <xsl:apply-templates mode="M105" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;916&quot;]/ram:LineID" mode="M106" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;916&quot;]/ram:LineID" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:LineID' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M106" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M106" priority="-1" />
  <xsl:template match="@*|node()" mode="M106" priority="-2">
    <xsl:apply-templates mode="M106" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;916&quot;]/ram:ReferenceTypeCode" mode="M107" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;916&quot;]/ram:ReferenceTypeCode" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:ReferenceTypeCode' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M107" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M107" priority="-1" />
  <xsl:template match="@*|node()" mode="M107" priority="-2">
    <xsl:apply-templates mode="M107" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;916&quot;]/ram:TypeCode" mode="M108" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;916&quot;]/ram:TypeCode" />
    <xsl:variable name="codeValue20" select="." />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=20]/enumeration[@value=$codeValue20]" />
      <xsl:otherwise>
        <svrl:failed-assert test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=20]/enumeration[@value=$codeValue20]">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Value of 'ram:TypeCode' is not allowed.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M108" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M108" priority="-1" />
  <xsl:template match="@*|node()" mode="M108" priority="-2">
    <xsl:apply-templates mode="M108" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;916&quot;]/ram:URIID[@schemeID]" mode="M109" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;916&quot;]/ram:URIID[@schemeID]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Attribute @schemeID' marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M109" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M109" priority="-1" />
  <xsl:template match="@*|node()" mode="M109" priority="-2">
    <xsl:apply-templates mode="M109" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument" mode="M110" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:IssuerAssignedID)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:IssuerAssignedID)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:IssuerAssignedID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M110" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M110" priority="-1" />
  <xsl:template match="@*|node()" mode="M110" priority="-2">
    <xsl:apply-templates mode="M110" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:AttachmentBinaryObject" mode="M111" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:AttachmentBinaryObject" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M111" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M111" priority="-1" />
  <xsl:template match="@*|node()" mode="M111" priority="-2">
    <xsl:apply-templates mode="M111" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:FormattedIssueDateTime" mode="M112" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:FormattedIssueDateTime" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:FormattedIssueDateTime' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M112" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M112" priority="-1" />
  <xsl:template match="@*|node()" mode="M112" priority="-2">
    <xsl:apply-templates mode="M112" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:IssuerAssignedID[@schemeID]" mode="M113" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:IssuerAssignedID[@schemeID]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Attribute @schemeID' marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M113" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M113" priority="-1" />
  <xsl:template match="@*|node()" mode="M113" priority="-2">
    <xsl:apply-templates mode="M113" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:LineID" mode="M114" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:LineID" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:LineID' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M114" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M114" priority="-1" />
  <xsl:template match="@*|node()" mode="M114" priority="-2">
    <xsl:apply-templates mode="M114" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:Name" mode="M115" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:Name" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:Name' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M115" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M115" priority="-1" />
  <xsl:template match="@*|node()" mode="M115" priority="-2">
    <xsl:apply-templates mode="M115" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:ReferenceTypeCode" mode="M116" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:ReferenceTypeCode" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:ReferenceTypeCode' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M116" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M116" priority="-1" />
  <xsl:template match="@*|node()" mode="M116" priority="-2">
    <xsl:apply-templates mode="M116" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:TypeCode" mode="M117" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:TypeCode" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:TypeCode' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M117" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M117" priority="-1" />
  <xsl:template match="@*|node()" mode="M117" priority="-2">
    <xsl:apply-templates mode="M117" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:URIID" mode="M118" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:URIID" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:URIID' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M118" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M118" priority="-1" />
  <xsl:template match="@*|node()" mode="M118" priority="-2">
    <xsl:apply-templates mode="M118" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty" mode="M119" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:ID)&lt;=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:ID)&lt;=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:ID' may occur at maximum 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:GlobalID)&lt;=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:GlobalID)&lt;=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:GlobalID' may occur at maximum 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:Name)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:Name)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:Name' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:DefinedTradeContact)&lt;=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:DefinedTradeContact)&lt;=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:DefinedTradeContact' may occur at maximum 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:PostalTradeAddress)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:PostalTradeAddress)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:PostalTradeAddress' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:URIUniversalCommunication)&lt;=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:URIUniversalCommunication)&lt;=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:URIUniversalCommunication' may occur at maximum 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:SpecifiedTaxRegistration)&lt;=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:SpecifiedTaxRegistration)&lt;=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:SpecifiedTaxRegistration' may occur at maximum 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M119" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M119" priority="-1" />
  <xsl:template match="@*|node()" mode="M119" priority="-2">
    <xsl:apply-templates mode="M119" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication" mode="M120" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:URIID)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:URIID)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:URIID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M120" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M120" priority="-1" />
  <xsl:template match="@*|node()" mode="M120" priority="-2">
    <xsl:apply-templates mode="M120" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:CompleteNumber" mode="M121" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:CompleteNumber" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:CompleteNumber' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M121" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M121" priority="-1" />
  <xsl:template match="@*|node()" mode="M121" priority="-2">
    <xsl:apply-templates mode="M121" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:URIID[@schemeID]" mode="M122" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:URIID[@schemeID]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Attribute @schemeID' marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M122" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M122" priority="-1" />
  <xsl:template match="@*|node()" mode="M122" priority="-2">
    <xsl:apply-templates mode="M122" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication" mode="M123" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:CompleteNumber)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:CompleteNumber)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:CompleteNumber' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M123" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M123" priority="-1" />
  <xsl:template match="@*|node()" mode="M123" priority="-2">
    <xsl:apply-templates mode="M123" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication/ram:URIID" mode="M124" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication/ram:URIID" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:URIID' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M124" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M124" priority="-1" />
  <xsl:template match="@*|node()" mode="M124" priority="-2">
    <xsl:apply-templates mode="M124" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:Description" mode="M125" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:Description" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:Description' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M125" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M125" priority="-1" />
  <xsl:template match="@*|node()" mode="M125" priority="-2">
    <xsl:apply-templates mode="M125" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:GlobalID" mode="M126" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:GlobalID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@schemeID' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M126" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M126" priority="-1" />
  <xsl:template match="@*|node()" mode="M126" priority="-2">
    <xsl:apply-templates mode="M126" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:GlobalID[@schemeID]" mode="M127" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:GlobalID[@schemeID]" />
    <xsl:variable name="codeValue15" select="@schemeID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=15]/enumeration[@value=$codeValue15]" />
      <xsl:otherwise>
        <svrl:failed-assert test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=15]/enumeration[@value=$codeValue15]">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Value of '@schemeID' is not allowed.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M127" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M127" priority="-1" />
  <xsl:template match="@*|node()" mode="M127" priority="-2">
    <xsl:apply-templates mode="M127" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:ID[@schemeID]" mode="M128" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:ID[@schemeID]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Attribute @schemeID' marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M128" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M128" priority="-1" />
  <xsl:template match="@*|node()" mode="M128" priority="-2">
    <xsl:apply-templates mode="M128" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress" mode="M129" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:CountryID)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:CountryID)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:CountryID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:CountrySubDivisionName)&lt;=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:CountrySubDivisionName)&lt;=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M129" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M129" priority="-1" />
  <xsl:template match="@*|node()" mode="M129" priority="-2">
    <xsl:apply-templates mode="M129" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress/ram:CountryID" mode="M130" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress/ram:CountryID" />
    <xsl:variable name="codeValue7" select="." />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=7]/enumeration[@value=$codeValue7]" />
      <xsl:otherwise>
        <svrl:failed-assert test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=7]/enumeration[@value=$codeValue7]">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Value of 'ram:CountryID' is not allowed.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M130" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M130" priority="-1" />
  <xsl:template match="@*|node()" mode="M130" priority="-2">
    <xsl:apply-templates mode="M130" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress/ram:PostcodeCode[@listID]" mode="M131" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress/ram:PostcodeCode[@listID]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Attribute @listID' marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M131" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M131" priority="-1" />
  <xsl:template match="@*|node()" mode="M131" priority="-2">
    <xsl:apply-templates mode="M131" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress/ram:PostcodeCode[@listVersionID]" mode="M132" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress/ram:PostcodeCode[@listVersionID]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Attribute @listVersionID' marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M132" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M132" priority="-1" />
  <xsl:template match="@*|node()" mode="M132" priority="-2">
    <xsl:apply-templates mode="M132" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:ID[@schemeID]" mode="M133" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:ID[@schemeID]" />
    <xsl:variable name="codeValue16" select="@schemeID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=16]/enumeration[@value=$codeValue16]" />
      <xsl:otherwise>
        <svrl:failed-assert test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=16]/enumeration[@value=$codeValue16]">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Value of '@schemeID' is not allowed.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M133" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M133" priority="-1" />
  <xsl:template match="@*|node()" mode="M133" priority="-2">
    <xsl:apply-templates mode="M133" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedTaxRegistration" mode="M134" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedTaxRegistration" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:ID)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:ID)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:ID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M134" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M134" priority="-1" />
  <xsl:template match="@*|node()" mode="M134" priority="-2">
    <xsl:apply-templates mode="M134" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedTaxRegistration/ram:ID" mode="M135" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedTaxRegistration/ram:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@schemeID' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M135" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M135" priority="-1" />
  <xsl:template match="@*|node()" mode="M135" priority="-2">
    <xsl:apply-templates mode="M135" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID]" mode="M136" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID]" />
    <xsl:variable name="codeValue18" select="@schemeID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=18]/enumeration[@value=$codeValue18]" />
      <xsl:otherwise>
        <svrl:failed-assert test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=18]/enumeration[@value=$codeValue18]">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Value of '@schemeID' is not allowed.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M136" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M136" priority="-1" />
  <xsl:template match="@*|node()" mode="M136" priority="-2">
    <xsl:apply-templates mode="M136" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:URIUniversalCommunication" mode="M137" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:URIUniversalCommunication" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:URIID)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:URIID)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:URIID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M137" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M137" priority="-1" />
  <xsl:template match="@*|node()" mode="M137" priority="-2">
    <xsl:apply-templates mode="M137" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:URIUniversalCommunication/ram:CompleteNumber" mode="M138" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:URIUniversalCommunication/ram:CompleteNumber" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:CompleteNumber' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M138" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M138" priority="-1" />
  <xsl:template match="@*|node()" mode="M138" priority="-2">
    <xsl:apply-templates mode="M138" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:URIUniversalCommunication/ram:URIID" mode="M139" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:URIUniversalCommunication/ram:URIID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@schemeID' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M139" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M139" priority="-1" />
  <xsl:template match="@*|node()" mode="M139" priority="-2">
    <xsl:apply-templates mode="M139" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:URIUniversalCommunication/ram:URIID[@schemeID]" mode="M140" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:URIUniversalCommunication/ram:URIID[@schemeID]" />
    <xsl:variable name="codeValue17" select="@schemeID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=17]/enumeration[@value=$codeValue17]" />
      <xsl:otherwise>
        <svrl:failed-assert test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=17]/enumeration[@value=$codeValue17]">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Value of '@schemeID' is not allowed.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M140" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M140" priority="-1" />
  <xsl:template match="@*|node()" mode="M140" priority="-2">
    <xsl:apply-templates mode="M140" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument" mode="M141" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:IssuerAssignedID)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:IssuerAssignedID)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:IssuerAssignedID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M141" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M141" priority="-1" />
  <xsl:template match="@*|node()" mode="M141" priority="-2">
    <xsl:apply-templates mode="M141" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument/ram:AttachmentBinaryObject" mode="M142" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument/ram:AttachmentBinaryObject" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M142" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M142" priority="-1" />
  <xsl:template match="@*|node()" mode="M142" priority="-2">
    <xsl:apply-templates mode="M142" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument/ram:FormattedIssueDateTime" mode="M143" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument/ram:FormattedIssueDateTime" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:FormattedIssueDateTime' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M143" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M143" priority="-1" />
  <xsl:template match="@*|node()" mode="M143" priority="-2">
    <xsl:apply-templates mode="M143" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument/ram:IssuerAssignedID[@schemeID]" mode="M144" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument/ram:IssuerAssignedID[@schemeID]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Attribute @schemeID' marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M144" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M144" priority="-1" />
  <xsl:template match="@*|node()" mode="M144" priority="-2">
    <xsl:apply-templates mode="M144" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument/ram:LineID" mode="M145" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument/ram:LineID" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:LineID' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M145" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M145" priority="-1" />
  <xsl:template match="@*|node()" mode="M145" priority="-2">
    <xsl:apply-templates mode="M145" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument/ram:Name" mode="M146" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument/ram:Name" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:Name' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M146" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M146" priority="-1" />
  <xsl:template match="@*|node()" mode="M146" priority="-2">
    <xsl:apply-templates mode="M146" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument/ram:ReferenceTypeCode" mode="M147" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument/ram:ReferenceTypeCode" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:ReferenceTypeCode' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M147" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M147" priority="-1" />
  <xsl:template match="@*|node()" mode="M147" priority="-2">
    <xsl:apply-templates mode="M147" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument/ram:TypeCode" mode="M148" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument/ram:TypeCode" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:TypeCode' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M148" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M148" priority="-1" />
  <xsl:template match="@*|node()" mode="M148" priority="-2">
    <xsl:apply-templates mode="M148" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument/ram:URIID" mode="M149" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument/ram:URIID" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:URIID' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M149" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M149" priority="-1" />
  <xsl:template match="@*|node()" mode="M149" priority="-2">
    <xsl:apply-templates mode="M149" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerOrderReferencedDocument" mode="M150" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerOrderReferencedDocument" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:IssuerAssignedID)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:IssuerAssignedID)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:IssuerAssignedID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M150" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M150" priority="-1" />
  <xsl:template match="@*|node()" mode="M150" priority="-2">
    <xsl:apply-templates mode="M150" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerOrderReferencedDocument/ram:AttachmentBinaryObject" mode="M151" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerOrderReferencedDocument/ram:AttachmentBinaryObject" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M151" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M151" priority="-1" />
  <xsl:template match="@*|node()" mode="M151" priority="-2">
    <xsl:apply-templates mode="M151" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerOrderReferencedDocument/ram:FormattedIssueDateTime" mode="M152" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerOrderReferencedDocument/ram:FormattedIssueDateTime" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:FormattedIssueDateTime' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M152" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M152" priority="-1" />
  <xsl:template match="@*|node()" mode="M152" priority="-2">
    <xsl:apply-templates mode="M152" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerOrderReferencedDocument/ram:IssuerAssignedID[@schemeID]" mode="M153" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerOrderReferencedDocument/ram:IssuerAssignedID[@schemeID]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Attribute @schemeID' marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M153" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M153" priority="-1" />
  <xsl:template match="@*|node()" mode="M153" priority="-2">
    <xsl:apply-templates mode="M153" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerOrderReferencedDocument/ram:LineID" mode="M154" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerOrderReferencedDocument/ram:LineID" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:LineID' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M154" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M154" priority="-1" />
  <xsl:template match="@*|node()" mode="M154" priority="-2">
    <xsl:apply-templates mode="M154" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerOrderReferencedDocument/ram:Name" mode="M155" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerOrderReferencedDocument/ram:Name" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:Name' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M155" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M155" priority="-1" />
  <xsl:template match="@*|node()" mode="M155" priority="-2">
    <xsl:apply-templates mode="M155" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerOrderReferencedDocument/ram:ReferenceTypeCode" mode="M156" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerOrderReferencedDocument/ram:ReferenceTypeCode" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:ReferenceTypeCode' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M156" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M156" priority="-1" />
  <xsl:template match="@*|node()" mode="M156" priority="-2">
    <xsl:apply-templates mode="M156" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerOrderReferencedDocument/ram:TypeCode" mode="M157" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerOrderReferencedDocument/ram:TypeCode" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:TypeCode' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M157" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M157" priority="-1" />
  <xsl:template match="@*|node()" mode="M157" priority="-2">
    <xsl:apply-templates mode="M157" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerOrderReferencedDocument/ram:URIID" mode="M158" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerOrderReferencedDocument/ram:URIID" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:URIID' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M158" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M158" priority="-1" />
  <xsl:template match="@*|node()" mode="M158" priority="-2">
    <xsl:apply-templates mode="M158" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty" mode="M159" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:Name)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:Name)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:Name' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:PostalTradeAddress)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:PostalTradeAddress)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:PostalTradeAddress' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:SpecifiedTaxRegistration)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:SpecifiedTaxRegistration)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:SpecifiedTaxRegistration' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M159" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M159" priority="-1" />
  <xsl:template match="@*|node()" mode="M159" priority="-2">
    <xsl:apply-templates mode="M159" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:DefinedTradeContact" mode="M160" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:DefinedTradeContact" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:DefinedTradeContact' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M160" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M160" priority="-1" />
  <xsl:template match="@*|node()" mode="M160" priority="-2">
    <xsl:apply-templates mode="M160" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:Description" mode="M161" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:Description" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:Description' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M161" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M161" priority="-1" />
  <xsl:template match="@*|node()" mode="M161" priority="-2">
    <xsl:apply-templates mode="M161" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:GlobalID" mode="M162" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:GlobalID" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:GlobalID' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M162" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M162" priority="-1" />
  <xsl:template match="@*|node()" mode="M162" priority="-2">
    <xsl:apply-templates mode="M162" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:ID" mode="M163" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:ID" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:ID' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M163" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M163" priority="-1" />
  <xsl:template match="@*|node()" mode="M163" priority="-2">
    <xsl:apply-templates mode="M163" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:PostalTradeAddress" mode="M164" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:PostalTradeAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:CountryID)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:CountryID)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:CountryID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:CountrySubDivisionName)&lt;=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:CountrySubDivisionName)&lt;=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M164" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M164" priority="-1" />
  <xsl:template match="@*|node()" mode="M164" priority="-2">
    <xsl:apply-templates mode="M164" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:PostalTradeAddress/ram:CountryID" mode="M165" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:PostalTradeAddress/ram:CountryID" />
    <xsl:variable name="codeValue7" select="." />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=7]/enumeration[@value=$codeValue7]" />
      <xsl:otherwise>
        <svrl:failed-assert test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=7]/enumeration[@value=$codeValue7]">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Value of 'ram:CountryID' is not allowed.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M165" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M165" priority="-1" />
  <xsl:template match="@*|node()" mode="M165" priority="-2">
    <xsl:apply-templates mode="M165" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:PostalTradeAddress/ram:PostcodeCode[@listID]" mode="M166" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:PostalTradeAddress/ram:PostcodeCode[@listID]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Attribute @listID' marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M166" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M166" priority="-1" />
  <xsl:template match="@*|node()" mode="M166" priority="-2">
    <xsl:apply-templates mode="M166" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:PostalTradeAddress/ram:PostcodeCode[@listVersionID]" mode="M167" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:PostalTradeAddress/ram:PostcodeCode[@listVersionID]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Attribute @listVersionID' marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M167" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M167" priority="-1" />
  <xsl:template match="@*|node()" mode="M167" priority="-2">
    <xsl:apply-templates mode="M167" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedLegalOrganization" mode="M168" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedLegalOrganization" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:SpecifiedLegalOrganization' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M168" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M168" priority="-1" />
  <xsl:template match="@*|node()" mode="M168" priority="-2">
    <xsl:apply-templates mode="M168" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration" mode="M169" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:ID)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:ID)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:ID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M169" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M169" priority="-1" />
  <xsl:template match="@*|node()" mode="M169" priority="-2">
    <xsl:apply-templates mode="M169" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID" mode="M170" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@schemeID' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M170" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M170" priority="-1" />
  <xsl:template match="@*|node()" mode="M170" priority="-2">
    <xsl:apply-templates mode="M170" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID]" mode="M171" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID]" />
    <xsl:variable name="codeValue19" select="@schemeID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=19]/enumeration[@value=$codeValue19]" />
      <xsl:otherwise>
        <svrl:failed-assert test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=19]/enumeration[@value=$codeValue19]">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Value of '@schemeID' is not allowed.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M171" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M171" priority="-1" />
  <xsl:template match="@*|node()" mode="M171" priority="-2">
    <xsl:apply-templates mode="M171" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:URIUniversalCommunication" mode="M172" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:URIUniversalCommunication" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:URIUniversalCommunication' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M172" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M172" priority="-1" />
  <xsl:template match="@*|node()" mode="M172" priority="-2">
    <xsl:apply-templates mode="M172" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty" mode="M173" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:Name)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:Name)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:Name' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:Description)&lt;=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:Description)&lt;=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:Description' may occur at maximum 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:DefinedTradeContact)&lt;=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:DefinedTradeContact)&lt;=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:DefinedTradeContact' may occur at maximum 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:PostalTradeAddress)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:PostalTradeAddress)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:PostalTradeAddress' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:URIUniversalCommunication)&lt;=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:URIUniversalCommunication)&lt;=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:URIUniversalCommunication' may occur at maximum 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:SpecifiedTaxRegistration[ram:ID/@schemeID=&quot;VA&quot;])&lt;=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:SpecifiedTaxRegistration[ram:ID/@schemeID=&quot;VA&quot;])&lt;=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element variant 'ram:SpecifiedTaxRegistration[ram:ID/@schemeID="VA"]' may occur at maximum 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:SpecifiedTaxRegistration[ram:ID/@schemeID=&quot;FC&quot;])&lt;=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:SpecifiedTaxRegistration[ram:ID/@schemeID=&quot;FC&quot;])&lt;=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element variant 'ram:SpecifiedTaxRegistration[ram:ID/@schemeID="FC"]' may occur at maximum 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M173" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M173" priority="-1" />
  <xsl:template match="@*|node()" mode="M173" priority="-2">
    <xsl:apply-templates mode="M173" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication" mode="M174" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:URIID)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:URIID)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:URIID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M174" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M174" priority="-1" />
  <xsl:template match="@*|node()" mode="M174" priority="-2">
    <xsl:apply-templates mode="M174" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:CompleteNumber" mode="M175" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:CompleteNumber" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:CompleteNumber' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M175" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M175" priority="-1" />
  <xsl:template match="@*|node()" mode="M175" priority="-2">
    <xsl:apply-templates mode="M175" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:URIID[@schemeID]" mode="M176" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:URIID[@schemeID]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Attribute @schemeID' marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M176" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M176" priority="-1" />
  <xsl:template match="@*|node()" mode="M176" priority="-2">
    <xsl:apply-templates mode="M176" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication" mode="M177" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:CompleteNumber)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:CompleteNumber)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:CompleteNumber' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M177" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M177" priority="-1" />
  <xsl:template match="@*|node()" mode="M177" priority="-2">
    <xsl:apply-templates mode="M177" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication/ram:URIID" mode="M178" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication/ram:URIID" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:URIID' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M178" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M178" priority="-1" />
  <xsl:template match="@*|node()" mode="M178" priority="-2">
    <xsl:apply-templates mode="M178" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:GlobalID" mode="M179" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:GlobalID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@schemeID' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M179" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M179" priority="-1" />
  <xsl:template match="@*|node()" mode="M179" priority="-2">
    <xsl:apply-templates mode="M179" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:GlobalID[@schemeID]" mode="M180" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:GlobalID[@schemeID]" />
    <xsl:variable name="codeValue15" select="@schemeID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=15]/enumeration[@value=$codeValue15]" />
      <xsl:otherwise>
        <svrl:failed-assert test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=15]/enumeration[@value=$codeValue15]">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Value of '@schemeID' is not allowed.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M180" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M180" priority="-1" />
  <xsl:template match="@*|node()" mode="M180" priority="-2">
    <xsl:apply-templates mode="M180" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:ID[@schemeID]" mode="M181" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:ID[@schemeID]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Attribute @schemeID' marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M181" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M181" priority="-1" />
  <xsl:template match="@*|node()" mode="M181" priority="-2">
    <xsl:apply-templates mode="M181" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress" mode="M182" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:CountryID)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:CountryID)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:CountryID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:CountrySubDivisionName)&lt;=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:CountrySubDivisionName)&lt;=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M182" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M182" priority="-1" />
  <xsl:template match="@*|node()" mode="M182" priority="-2">
    <xsl:apply-templates mode="M182" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:CountryID" mode="M183" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:CountryID" />
    <xsl:variable name="codeValue7" select="." />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=7]/enumeration[@value=$codeValue7]" />
      <xsl:otherwise>
        <svrl:failed-assert test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=7]/enumeration[@value=$codeValue7]">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Value of 'ram:CountryID' is not allowed.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M183" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M183" priority="-1" />
  <xsl:template match="@*|node()" mode="M183" priority="-2">
    <xsl:apply-templates mode="M183" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:PostcodeCode[@listID]" mode="M184" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:PostcodeCode[@listID]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Attribute @listID' marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M184" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M184" priority="-1" />
  <xsl:template match="@*|node()" mode="M184" priority="-2">
    <xsl:apply-templates mode="M184" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:PostcodeCode[@listVersionID]" mode="M185" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:PostcodeCode[@listVersionID]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Attribute @listVersionID' marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M185" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M185" priority="-1" />
  <xsl:template match="@*|node()" mode="M185" priority="-2">
    <xsl:apply-templates mode="M185" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedLegalOrganization/ram:ID[@schemeID]" mode="M186" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedLegalOrganization/ram:ID[@schemeID]" />
    <xsl:variable name="codeValue16" select="@schemeID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=16]/enumeration[@value=$codeValue16]" />
      <xsl:otherwise>
        <svrl:failed-assert test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=16]/enumeration[@value=$codeValue16]">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Value of '@schemeID' is not allowed.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M186" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M186" priority="-1" />
  <xsl:template match="@*|node()" mode="M186" priority="-2">
    <xsl:apply-templates mode="M186" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration[ not(ram:ID/@schemeID=&quot;VA&quot;) and  not(ram:ID/@schemeID=&quot;FC&quot;)]" mode="M187" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration[ not(ram:ID/@schemeID=&quot;VA&quot;) and  not(ram:ID/@schemeID=&quot;FC&quot;)]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element variant 'ram:SpecifiedTaxRegistration[ not(ram:ID/@schemeID="VA") and  not(ram:ID/@schemeID="FC")]' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M187" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M187" priority="-1" />
  <xsl:template match="@*|node()" mode="M187" priority="-2">
    <xsl:apply-templates mode="M187" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration[ram:ID/@schemeID=&quot;FC&quot;]" mode="M188" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration[ram:ID/@schemeID=&quot;FC&quot;]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:ID)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:ID)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:ID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M188" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M188" priority="-1" />
  <xsl:template match="@*|node()" mode="M188" priority="-2">
    <xsl:apply-templates mode="M188" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration[ram:ID/@schemeID=&quot;FC&quot;]/ram:ID" mode="M189" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration[ram:ID/@schemeID=&quot;FC&quot;]/ram:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@schemeID' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M189" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M189" priority="-1" />
  <xsl:template match="@*|node()" mode="M189" priority="-2">
    <xsl:apply-templates mode="M189" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration[ram:ID/@schemeID=&quot;VA&quot;]" mode="M190" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration[ram:ID/@schemeID=&quot;VA&quot;]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:ID)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:ID)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:ID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M190" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M190" priority="-1" />
  <xsl:template match="@*|node()" mode="M190" priority="-2">
    <xsl:apply-templates mode="M190" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration[ram:ID/@schemeID=&quot;VA&quot;]/ram:ID" mode="M191" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration[ram:ID/@schemeID=&quot;VA&quot;]/ram:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@schemeID' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M191" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M191" priority="-1" />
  <xsl:template match="@*|node()" mode="M191" priority="-2">
    <xsl:apply-templates mode="M191" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:URIUniversalCommunication" mode="M192" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:URIUniversalCommunication" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:URIID)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:URIID)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:URIID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M192" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M192" priority="-1" />
  <xsl:template match="@*|node()" mode="M192" priority="-2">
    <xsl:apply-templates mode="M192" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:URIUniversalCommunication/ram:CompleteNumber" mode="M193" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:URIUniversalCommunication/ram:CompleteNumber" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:CompleteNumber' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M193" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M193" priority="-1" />
  <xsl:template match="@*|node()" mode="M193" priority="-2">
    <xsl:apply-templates mode="M193" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:URIUniversalCommunication/ram:URIID" mode="M194" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:URIUniversalCommunication/ram:URIID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@schemeID' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M194" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M194" priority="-1" />
  <xsl:template match="@*|node()" mode="M194" priority="-2">
    <xsl:apply-templates mode="M194" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:URIUniversalCommunication/ram:URIID[@schemeID]" mode="M195" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:URIUniversalCommunication/ram:URIID[@schemeID]" />
    <xsl:variable name="codeValue17" select="@schemeID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=17]/enumeration[@value=$codeValue17]" />
      <xsl:otherwise>
        <svrl:failed-assert test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=17]/enumeration[@value=$codeValue17]">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Value of '@schemeID' is not allowed.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M195" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M195" priority="-1" />
  <xsl:template match="@*|node()" mode="M195" priority="-2">
    <xsl:apply-templates mode="M195" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SpecifiedProcuringProject/ram:ID[@schemeID]" mode="M196" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SpecifiedProcuringProject/ram:ID[@schemeID]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Attribute @schemeID' marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M196" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M196" priority="-1" />
  <xsl:template match="@*|node()" mode="M196" priority="-2">
    <xsl:apply-templates mode="M196" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery" mode="M197" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(ram:ShipToTradeParty/ram:PostalTradeAddress and ram:ShipToTradeParty/ram:PostalTradeAddress/ram:CountryID!='') or not (ram:ShipToTradeParty/ram:PostalTradeAddress)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(ram:ShipToTradeParty/ram:PostalTradeAddress and ram:ShipToTradeParty/ram:PostalTradeAddress/ram:CountryID!='') or not (ram:ShipToTradeParty/ram:PostalTradeAddress)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-57]-Each Deliver to address (BG-15) shall contain a Deliver to country code (BT-80).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M197" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M197" priority="-1" />
  <xsl:template match="@*|node()" mode="M197" priority="-2">
    <xsl:apply-templates mode="M197" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ActualDeliverySupplyChainEvent" mode="M198" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ActualDeliverySupplyChainEvent" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:OccurrenceDateTime)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:OccurrenceDateTime)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:OccurrenceDateTime' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M198" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M198" priority="-1" />
  <xsl:template match="@*|node()" mode="M198" priority="-2">
    <xsl:apply-templates mode="M198" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ActualDeliverySupplyChainEvent/ram:OccurrenceDateTime/udt:DateTimeString" mode="M199" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ActualDeliverySupplyChainEvent/ram:OccurrenceDateTime/udt:DateTimeString" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@format" />
      <xsl:otherwise>
        <svrl:failed-assert test="@format">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@format' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M199" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M199" priority="-1" />
  <xsl:template match="@*|node()" mode="M199" priority="-2">
    <xsl:apply-templates mode="M199" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ActualDeliverySupplyChainEvent/ram:OccurrenceDateTime/udt:DateTimeString[@format]" mode="M200" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ActualDeliverySupplyChainEvent/ram:OccurrenceDateTime/udt:DateTimeString[@format]" />
    <xsl:variable name="codeValue3" select="@format" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=3]/enumeration[@value=$codeValue3]" />
      <xsl:otherwise>
        <svrl:failed-assert test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=3]/enumeration[@value=$codeValue3]">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Value of '@format' is not allowed.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M200" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M200" priority="-1" />
  <xsl:template match="@*|node()" mode="M200" priority="-2">
    <xsl:apply-templates mode="M200" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DespatchAdviceReferencedDocument" mode="M201" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DespatchAdviceReferencedDocument" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:IssuerAssignedID)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:IssuerAssignedID)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:IssuerAssignedID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M201" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M201" priority="-1" />
  <xsl:template match="@*|node()" mode="M201" priority="-2">
    <xsl:apply-templates mode="M201" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:AttachmentBinaryObject" mode="M202" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:AttachmentBinaryObject" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M202" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M202" priority="-1" />
  <xsl:template match="@*|node()" mode="M202" priority="-2">
    <xsl:apply-templates mode="M202" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:FormattedIssueDateTime" mode="M203" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:FormattedIssueDateTime" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:FormattedIssueDateTime' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M203" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M203" priority="-1" />
  <xsl:template match="@*|node()" mode="M203" priority="-2">
    <xsl:apply-templates mode="M203" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:IssuerAssignedID[@schemeID]" mode="M204" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:IssuerAssignedID[@schemeID]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Attribute @schemeID' marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M204" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M204" priority="-1" />
  <xsl:template match="@*|node()" mode="M204" priority="-2">
    <xsl:apply-templates mode="M204" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:LineID" mode="M205" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:LineID" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:LineID' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M205" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M205" priority="-1" />
  <xsl:template match="@*|node()" mode="M205" priority="-2">
    <xsl:apply-templates mode="M205" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:Name" mode="M206" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:Name" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:Name' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M206" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M206" priority="-1" />
  <xsl:template match="@*|node()" mode="M206" priority="-2">
    <xsl:apply-templates mode="M206" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:ReferenceTypeCode" mode="M207" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:ReferenceTypeCode" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:ReferenceTypeCode' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M207" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M207" priority="-1" />
  <xsl:template match="@*|node()" mode="M207" priority="-2">
    <xsl:apply-templates mode="M207" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:TypeCode" mode="M208" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:TypeCode" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:TypeCode' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M208" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M208" priority="-1" />
  <xsl:template match="@*|node()" mode="M208" priority="-2">
    <xsl:apply-templates mode="M208" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:URIID" mode="M209" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:URIID" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:URIID' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M209" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M209" priority="-1" />
  <xsl:template match="@*|node()" mode="M209" priority="-2">
    <xsl:apply-templates mode="M209" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ReceivingAdviceReferencedDocument" mode="M210" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ReceivingAdviceReferencedDocument" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:IssuerAssignedID)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:IssuerAssignedID)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:IssuerAssignedID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M210" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M210" priority="-1" />
  <xsl:template match="@*|node()" mode="M210" priority="-2">
    <xsl:apply-templates mode="M210" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ReceivingAdviceReferencedDocument/ram:AttachmentBinaryObject" mode="M211" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ReceivingAdviceReferencedDocument/ram:AttachmentBinaryObject" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M211" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M211" priority="-1" />
  <xsl:template match="@*|node()" mode="M211" priority="-2">
    <xsl:apply-templates mode="M211" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ReceivingAdviceReferencedDocument/ram:FormattedIssueDateTime" mode="M212" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ReceivingAdviceReferencedDocument/ram:FormattedIssueDateTime" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:FormattedIssueDateTime' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M212" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M212" priority="-1" />
  <xsl:template match="@*|node()" mode="M212" priority="-2">
    <xsl:apply-templates mode="M212" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ReceivingAdviceReferencedDocument/ram:IssuerAssignedID[@schemeID]" mode="M213" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ReceivingAdviceReferencedDocument/ram:IssuerAssignedID[@schemeID]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Attribute @schemeID' marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M213" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M213" priority="-1" />
  <xsl:template match="@*|node()" mode="M213" priority="-2">
    <xsl:apply-templates mode="M213" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ReceivingAdviceReferencedDocument/ram:LineID" mode="M214" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ReceivingAdviceReferencedDocument/ram:LineID" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:LineID' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M214" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M214" priority="-1" />
  <xsl:template match="@*|node()" mode="M214" priority="-2">
    <xsl:apply-templates mode="M214" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ReceivingAdviceReferencedDocument/ram:Name" mode="M215" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ReceivingAdviceReferencedDocument/ram:Name" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:Name' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M215" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M215" priority="-1" />
  <xsl:template match="@*|node()" mode="M215" priority="-2">
    <xsl:apply-templates mode="M215" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ReceivingAdviceReferencedDocument/ram:ReferenceTypeCode" mode="M216" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ReceivingAdviceReferencedDocument/ram:ReferenceTypeCode" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:ReferenceTypeCode' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M216" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M216" priority="-1" />
  <xsl:template match="@*|node()" mode="M216" priority="-2">
    <xsl:apply-templates mode="M216" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ReceivingAdviceReferencedDocument/ram:TypeCode" mode="M217" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ReceivingAdviceReferencedDocument/ram:TypeCode" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:TypeCode' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M217" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M217" priority="-1" />
  <xsl:template match="@*|node()" mode="M217" priority="-2">
    <xsl:apply-templates mode="M217" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ReceivingAdviceReferencedDocument/ram:URIID" mode="M218" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ReceivingAdviceReferencedDocument/ram:URIID" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:URIID' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M218" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M218" priority="-1" />
  <xsl:template match="@*|node()" mode="M218" priority="-2">
    <xsl:apply-templates mode="M218" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty" mode="M219" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:ID)&lt;=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:ID)&lt;=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:ID' may occur at maximum 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:GlobalID)&lt;=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:GlobalID)&lt;=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:GlobalID' may occur at maximum 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M219" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M219" priority="-1" />
  <xsl:template match="@*|node()" mode="M219" priority="-2">
    <xsl:apply-templates mode="M219" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:DefinedTradeContact" mode="M220" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:DefinedTradeContact" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:DefinedTradeContact' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M220" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M220" priority="-1" />
  <xsl:template match="@*|node()" mode="M220" priority="-2">
    <xsl:apply-templates mode="M220" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:Description" mode="M221" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:Description" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:Description' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M221" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M221" priority="-1" />
  <xsl:template match="@*|node()" mode="M221" priority="-2">
    <xsl:apply-templates mode="M221" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:GlobalID" mode="M222" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:GlobalID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@schemeID' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M222" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M222" priority="-1" />
  <xsl:template match="@*|node()" mode="M222" priority="-2">
    <xsl:apply-templates mode="M222" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:GlobalID[@schemeID]" mode="M223" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:GlobalID[@schemeID]" />
    <xsl:variable name="codeValue15" select="@schemeID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=15]/enumeration[@value=$codeValue15]" />
      <xsl:otherwise>
        <svrl:failed-assert test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=15]/enumeration[@value=$codeValue15]">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Value of '@schemeID' is not allowed.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M223" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M223" priority="-1" />
  <xsl:template match="@*|node()" mode="M223" priority="-2">
    <xsl:apply-templates mode="M223" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:ID[@schemeID]" mode="M224" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:ID[@schemeID]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Attribute @schemeID' marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M224" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M224" priority="-1" />
  <xsl:template match="@*|node()" mode="M224" priority="-2">
    <xsl:apply-templates mode="M224" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress" mode="M225" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:CountryID)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:CountryID)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:CountryID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:CountrySubDivisionName)&lt;=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:CountrySubDivisionName)&lt;=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M225" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M225" priority="-1" />
  <xsl:template match="@*|node()" mode="M225" priority="-2">
    <xsl:apply-templates mode="M225" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress/ram:CountryID" mode="M226" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress/ram:CountryID" />
    <xsl:variable name="codeValue7" select="." />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=7]/enumeration[@value=$codeValue7]" />
      <xsl:otherwise>
        <svrl:failed-assert test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=7]/enumeration[@value=$codeValue7]">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Value of 'ram:CountryID' is not allowed.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M226" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M226" priority="-1" />
  <xsl:template match="@*|node()" mode="M226" priority="-2">
    <xsl:apply-templates mode="M226" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress/ram:PostcodeCode[@listID]" mode="M227" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress/ram:PostcodeCode[@listID]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Attribute @listID' marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M227" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M227" priority="-1" />
  <xsl:template match="@*|node()" mode="M227" priority="-2">
    <xsl:apply-templates mode="M227" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress/ram:PostcodeCode[@listVersionID]" mode="M228" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress/ram:PostcodeCode[@listVersionID]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Attribute @listVersionID' marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M228" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M228" priority="-1" />
  <xsl:template match="@*|node()" mode="M228" priority="-2">
    <xsl:apply-templates mode="M228" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:SpecifiedLegalOrganization" mode="M229" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:SpecifiedLegalOrganization" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:SpecifiedLegalOrganization' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M229" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M229" priority="-1" />
  <xsl:template match="@*|node()" mode="M229" priority="-2">
    <xsl:apply-templates mode="M229" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:SpecifiedTaxRegistration" mode="M230" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:SpecifiedTaxRegistration" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:SpecifiedTaxRegistration' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M230" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M230" priority="-1" />
  <xsl:template match="@*|node()" mode="M230" priority="-2">
    <xsl:apply-templates mode="M230" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:URIUniversalCommunication" mode="M231" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:URIUniversalCommunication" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:URIUniversalCommunication' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M231" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M231" priority="-1" />
  <xsl:template match="@*|node()" mode="M231" priority="-2">
    <xsl:apply-templates mode="M231" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement" mode="M232" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:PaymentReference)&lt;=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:PaymentReference)&lt;=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:PaymentReference' may occur at maximum 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:InvoiceCurrencyCode)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:InvoiceCurrencyCode)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:InvoiceCurrencyCode' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:ApplicableTradeTax)>=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:ApplicableTradeTax)>=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:ApplicableTradeTax' must occur at least 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:SpecifiedTradePaymentTerms)&lt;=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:SpecifiedTradePaymentTerms)&lt;=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:SpecifiedTradePaymentTerms' may occur at maximum 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:SpecifiedTradeSettlementHeaderMonetarySummation)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:SpecifiedTradeSettlementHeaderMonetarySummation)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:SpecifiedTradeSettlementHeaderMonetarySummation' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:ReceivableSpecifiedTradeAccountingAccount)&lt;=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:ReceivableSpecifiedTradeAccountingAccount)&lt;=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:ReceivableSpecifiedTradeAccountingAccount' may occur at maximum 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M232" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M232" priority="-1" />
  <xsl:template match="@*|node()" mode="M232" priority="-2">
    <xsl:apply-templates mode="M232" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax" mode="M233" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:CalculatedAmount)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:CalculatedAmount)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:CalculatedAmount' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:TypeCode)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:TypeCode)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:TypeCode' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:BasisAmount)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:BasisAmount)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:BasisAmount' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:CategoryCode)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:CategoryCode)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:CategoryCode' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M233" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M233" priority="-1" />
  <xsl:template match="@*|node()" mode="M233" priority="-2">
    <xsl:apply-templates mode="M233" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:BasisAmount[@currencyID]" mode="M234" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:BasisAmount[@currencyID]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Attribute @currencyID' marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M234" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M234" priority="-1" />
  <xsl:template match="@*|node()" mode="M234" priority="-2">
    <xsl:apply-templates mode="M234" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CalculatedAmount[@currencyID]" mode="M235" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CalculatedAmount[@currencyID]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Attribute @currencyID' marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M235" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M235" priority="-1" />
  <xsl:template match="@*|node()" mode="M235" priority="-2">
    <xsl:apply-templates mode="M235" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode" mode="M236" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode" />
    <xsl:variable name="codeValue10" select="." />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=10]/enumeration[@value=$codeValue10]" />
      <xsl:otherwise>
        <svrl:failed-assert test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=10]/enumeration[@value=$codeValue10]">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Value of 'ram:CategoryCode' is not allowed.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M236" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M236" priority="-1" />
  <xsl:template match="@*|node()" mode="M236" priority="-2">
    <xsl:apply-templates mode="M236" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:DueDateTypeCode" mode="M237" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:DueDateTypeCode" />
    <xsl:variable name="codeValue28" select="." />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=28]/enumeration[@value=$codeValue28]" />
      <xsl:otherwise>
        <svrl:failed-assert test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=28]/enumeration[@value=$codeValue28]">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Value of 'ram:DueDateTypeCode' is not allowed.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M237" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M237" priority="-1" />
  <xsl:template match="@*|node()" mode="M237" priority="-2">
    <xsl:apply-templates mode="M237" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReasonCode" mode="M238" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReasonCode" />
    <xsl:variable name="codeValue26" select="." />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=26]/enumeration[@value=$codeValue26]" />
      <xsl:otherwise>
        <svrl:failed-assert test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=26]/enumeration[@value=$codeValue26]">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Value of 'ram:ExemptionReasonCode' is not allowed.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M238" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M238" priority="-1" />
  <xsl:template match="@*|node()" mode="M238" priority="-2">
    <xsl:apply-templates mode="M238" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReasonCode[@listID]" mode="M239" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReasonCode[@listID]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Attribute @listID' marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M239" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M239" priority="-1" />
  <xsl:template match="@*|node()" mode="M239" priority="-2">
    <xsl:apply-templates mode="M239" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReasonCode[@listVersionID]" mode="M240" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReasonCode[@listVersionID]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Attribute @listVersionID' marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M240" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M240" priority="-1" />
  <xsl:template match="@*|node()" mode="M240" priority="-2">
    <xsl:apply-templates mode="M240" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:TaxPointDate/udt:DateString" mode="M241" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:TaxPointDate/udt:DateString" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@format" />
      <xsl:otherwise>
        <svrl:failed-assert test="@format">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@format' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M241" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M241" priority="-1" />
  <xsl:template match="@*|node()" mode="M241" priority="-2">
    <xsl:apply-templates mode="M241" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:TaxPointDate/udt:DateString[@format]" mode="M242" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:TaxPointDate/udt:DateString[@format]" />
    <xsl:variable name="codeValue27" select="@format" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=27]/enumeration[@value=$codeValue27]" />
      <xsl:otherwise>
        <svrl:failed-assert test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=27]/enumeration[@value=$codeValue27]">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Value of '@format' is not allowed.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M242" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M242" priority="-1" />
  <xsl:template match="@*|node()" mode="M242" priority="-2">
    <xsl:apply-templates mode="M242" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:TypeCode" mode="M243" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:TypeCode" />
    <xsl:variable name="codeValue9" select="." />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=9]/enumeration[@value=$codeValue9]" />
      <xsl:otherwise>
        <svrl:failed-assert test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=9]/enumeration[@value=$codeValue9]">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Value of 'ram:TypeCode' is not allowed.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M243" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M243" priority="-1" />
  <xsl:template match="@*|node()" mode="M243" priority="-2">
    <xsl:apply-templates mode="M243" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:BillingSpecifiedPeriod/ram:EndDateTime/udt:DateTimeString" mode="M244" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:BillingSpecifiedPeriod/ram:EndDateTime/udt:DateTimeString" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@format" />
      <xsl:otherwise>
        <svrl:failed-assert test="@format">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@format' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M244" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M244" priority="-1" />
  <xsl:template match="@*|node()" mode="M244" priority="-2">
    <xsl:apply-templates mode="M244" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:BillingSpecifiedPeriod/ram:EndDateTime/udt:DateTimeString[@format]" mode="M245" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:BillingSpecifiedPeriod/ram:EndDateTime/udt:DateTimeString[@format]" />
    <xsl:variable name="codeValue3" select="@format" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=3]/enumeration[@value=$codeValue3]" />
      <xsl:otherwise>
        <svrl:failed-assert test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=3]/enumeration[@value=$codeValue3]">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Value of '@format' is not allowed.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M245" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M245" priority="-1" />
  <xsl:template match="@*|node()" mode="M245" priority="-2">
    <xsl:apply-templates mode="M245" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:BillingSpecifiedPeriod/ram:StartDateTime/udt:DateTimeString" mode="M246" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:BillingSpecifiedPeriod/ram:StartDateTime/udt:DateTimeString" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@format" />
      <xsl:otherwise>
        <svrl:failed-assert test="@format">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@format' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M246" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M246" priority="-1" />
  <xsl:template match="@*|node()" mode="M246" priority="-2">
    <xsl:apply-templates mode="M246" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:BillingSpecifiedPeriod/ram:StartDateTime/udt:DateTimeString[@format]" mode="M247" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:BillingSpecifiedPeriod/ram:StartDateTime/udt:DateTimeString[@format]" />
    <xsl:variable name="codeValue3" select="@format" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=3]/enumeration[@value=$codeValue3]" />
      <xsl:otherwise>
        <svrl:failed-assert test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=3]/enumeration[@value=$codeValue3]">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Value of '@format' is not allowed.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M247" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M247" priority="-1" />
  <xsl:template match="@*|node()" mode="M247" priority="-2">
    <xsl:apply-templates mode="M247" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:CreditorReferenceID[@schemeID]" mode="M248" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:CreditorReferenceID[@schemeID]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Attribute @schemeID' marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M248" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M248" priority="-1" />
  <xsl:template match="@*|node()" mode="M248" priority="-2">
    <xsl:apply-templates mode="M248" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode" mode="M249" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode" />
    <xsl:variable name="codeValue24" select="." />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=24]/enumeration[@value=$codeValue24]" />
      <xsl:otherwise>
        <svrl:failed-assert test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=24]/enumeration[@value=$codeValue24]">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Value of 'ram:InvoiceCurrencyCode' is not allowed.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M249" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M249" priority="-1" />
  <xsl:template match="@*|node()" mode="M249" priority="-2">
    <xsl:apply-templates mode="M249" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument" mode="M250" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(ram:IssuerAssignedID!='')" />
      <xsl:otherwise>
        <svrl:failed-assert test="(ram:IssuerAssignedID!='')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	[BR-55]-Each Preceding Invoice reference (BG-3) shall contain a Preceding Invoice reference (BT-25).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:IssuerAssignedID)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:IssuerAssignedID)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:IssuerAssignedID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M250" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M250" priority="-1" />
  <xsl:template match="@*|node()" mode="M250" priority="-2">
    <xsl:apply-templates mode="M250" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:AttachmentBinaryObject" mode="M251" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:AttachmentBinaryObject" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M251" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M251" priority="-1" />
  <xsl:template match="@*|node()" mode="M251" priority="-2">
    <xsl:apply-templates mode="M251" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString" mode="M252" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@format" />
      <xsl:otherwise>
        <svrl:failed-assert test="@format">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@format' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M252" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M252" priority="-1" />
  <xsl:template match="@*|node()" mode="M252" priority="-2">
    <xsl:apply-templates mode="M252" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString[@format]" mode="M253" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString[@format]" />
    <xsl:variable name="codeValue33" select="@format" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=33]/enumeration[@value=$codeValue33]" />
      <xsl:otherwise>
        <svrl:failed-assert test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=33]/enumeration[@value=$codeValue33]">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Value of '@format' is not allowed.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M253" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M253" priority="-1" />
  <xsl:template match="@*|node()" mode="M253" priority="-2">
    <xsl:apply-templates mode="M253" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:IssuerAssignedID[@schemeID]" mode="M254" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:IssuerAssignedID[@schemeID]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Attribute @schemeID' marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M254" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M254" priority="-1" />
  <xsl:template match="@*|node()" mode="M254" priority="-2">
    <xsl:apply-templates mode="M254" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:LineID" mode="M255" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:LineID" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:LineID' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M255" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M255" priority="-1" />
  <xsl:template match="@*|node()" mode="M255" priority="-2">
    <xsl:apply-templates mode="M255" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:Name" mode="M256" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:Name" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:Name' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M256" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M256" priority="-1" />
  <xsl:template match="@*|node()" mode="M256" priority="-2">
    <xsl:apply-templates mode="M256" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:ReferenceTypeCode" mode="M257" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:ReferenceTypeCode" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:ReferenceTypeCode' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M257" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M257" priority="-1" />
  <xsl:template match="@*|node()" mode="M257" priority="-2">
    <xsl:apply-templates mode="M257" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:TypeCode" mode="M258" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:TypeCode" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:TypeCode' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M258" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M258" priority="-1" />
  <xsl:template match="@*|node()" mode="M258" priority="-2">
    <xsl:apply-templates mode="M258" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:URIID" mode="M259" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:URIID" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:URIID' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M259" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M259" priority="-1" />
  <xsl:template match="@*|node()" mode="M259" priority="-2">
    <xsl:apply-templates mode="M259" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty" mode="M260" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:ID)&lt;=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:ID)&lt;=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:ID' may occur at maximum 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:GlobalID)&lt;=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:GlobalID)&lt;=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:GlobalID' may occur at maximum 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:Name)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:Name)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:Name' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M260" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M260" priority="-1" />
  <xsl:template match="@*|node()" mode="M260" priority="-2">
    <xsl:apply-templates mode="M260" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:DefinedTradeContact" mode="M261" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:DefinedTradeContact" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:DefinedTradeContact' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M261" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M261" priority="-1" />
  <xsl:template match="@*|node()" mode="M261" priority="-2">
    <xsl:apply-templates mode="M261" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:Description" mode="M262" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:Description" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:Description' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M262" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M262" priority="-1" />
  <xsl:template match="@*|node()" mode="M262" priority="-2">
    <xsl:apply-templates mode="M262" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:GlobalID" mode="M263" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:GlobalID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@schemeID' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M263" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M263" priority="-1" />
  <xsl:template match="@*|node()" mode="M263" priority="-2">
    <xsl:apply-templates mode="M263" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:GlobalID[@schemeID]" mode="M264" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:GlobalID[@schemeID]" />
    <xsl:variable name="codeValue15" select="@schemeID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=15]/enumeration[@value=$codeValue15]" />
      <xsl:otherwise>
        <svrl:failed-assert test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=15]/enumeration[@value=$codeValue15]">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Value of '@schemeID' is not allowed.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M264" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M264" priority="-1" />
  <xsl:template match="@*|node()" mode="M264" priority="-2">
    <xsl:apply-templates mode="M264" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:ID[@schemeID]" mode="M265" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:ID[@schemeID]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Attribute @schemeID' marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M265" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M265" priority="-1" />
  <xsl:template match="@*|node()" mode="M265" priority="-2">
    <xsl:apply-templates mode="M265" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:PostalTradeAddress" mode="M266" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:PostalTradeAddress" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:PostalTradeAddress' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M266" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M266" priority="-1" />
  <xsl:template match="@*|node()" mode="M266" priority="-2">
    <xsl:apply-templates mode="M266" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:SpecifiedLegalOrganization/ram:ID[@schemeID]" mode="M267" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:SpecifiedLegalOrganization/ram:ID[@schemeID]" />
    <xsl:variable name="codeValue16" select="@schemeID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=16]/enumeration[@value=$codeValue16]" />
      <xsl:otherwise>
        <svrl:failed-assert test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=16]/enumeration[@value=$codeValue16]">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Value of '@schemeID' is not allowed.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M267" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M267" priority="-1" />
  <xsl:template match="@*|node()" mode="M267" priority="-2">
    <xsl:apply-templates mode="M267" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:SpecifiedLegalOrganization/ram:TradingBusinessName" mode="M268" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:SpecifiedLegalOrganization/ram:TradingBusinessName" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:TradingBusinessName' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M268" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M268" priority="-1" />
  <xsl:template match="@*|node()" mode="M268" priority="-2">
    <xsl:apply-templates mode="M268" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:SpecifiedTaxRegistration" mode="M269" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:SpecifiedTaxRegistration" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:SpecifiedTaxRegistration' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M269" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M269" priority="-1" />
  <xsl:template match="@*|node()" mode="M269" priority="-2">
    <xsl:apply-templates mode="M269" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:URIUniversalCommunication" mode="M270" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:URIUniversalCommunication" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:URIUniversalCommunication' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M270" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M270" priority="-1" />
  <xsl:template match="@*|node()" mode="M270" priority="-2">
    <xsl:apply-templates mode="M270" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ReceivableSpecifiedTradeAccountingAccount/ram:ID[@schemeID]" mode="M271" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ReceivableSpecifiedTradeAccountingAccount/ram:ID[@schemeID]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Attribute @schemeID' marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M271" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M271" priority="-1" />
  <xsl:template match="@*|node()" mode="M271" priority="-2">
    <xsl:apply-templates mode="M271" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ not(ram:ChargeIndicator/udt:Indicator=&quot;false&quot;) and  not(ram:ChargeIndicator/udt:Indicator=&quot;true&quot;)]" mode="M272" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ not(ram:ChargeIndicator/udt:Indicator=&quot;false&quot;) and  not(ram:ChargeIndicator/udt:Indicator=&quot;true&quot;)]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element variant 'ram:SpecifiedTradeAllowanceCharge[ not(ram:ChargeIndicator/udt:Indicator="false") and  not(ram:ChargeIndicator/udt:Indicator="true")]' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M272" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M272" priority="-1" />
  <xsl:template match="@*|node()" mode="M272" priority="-2">
    <xsl:apply-templates mode="M272" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]" mode="M273" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:ChargeIndicator)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:ChargeIndicator)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:ChargeIndicator' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:ActualAmount)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:ActualAmount)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:ActualAmount' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:CategoryTradeTax)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:CategoryTradeTax)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:CategoryTradeTax' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M273" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M273" priority="-1" />
  <xsl:template match="@*|node()" mode="M273" priority="-2">
    <xsl:apply-templates mode="M273" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:ActualAmount[@currencyID]" mode="M274" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:ActualAmount[@currencyID]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Attribute @currencyID' marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M274" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M274" priority="-1" />
  <xsl:template match="@*|node()" mode="M274" priority="-2">
    <xsl:apply-templates mode="M274" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:BasisAmount[@currencyID]" mode="M275" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:BasisAmount[@currencyID]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Attribute @currencyID' marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M275" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M275" priority="-1" />
  <xsl:template match="@*|node()" mode="M275" priority="-2">
    <xsl:apply-templates mode="M275" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:CategoryTradeTax" mode="M276" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:CategoryTradeTax" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:TypeCode)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:TypeCode)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:TypeCode' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:CategoryCode)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:CategoryCode)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:CategoryCode' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M276" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M276" priority="-1" />
  <xsl:template match="@*|node()" mode="M276" priority="-2">
    <xsl:apply-templates mode="M276" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:CategoryTradeTax/ram:BasisAmount" mode="M277" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:CategoryTradeTax/ram:BasisAmount" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:BasisAmount' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M277" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M277" priority="-1" />
  <xsl:template match="@*|node()" mode="M277" priority="-2">
    <xsl:apply-templates mode="M277" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:CategoryTradeTax/ram:CalculatedAmount" mode="M278" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:CategoryTradeTax/ram:CalculatedAmount" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:CalculatedAmount' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M278" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M278" priority="-1" />
  <xsl:template match="@*|node()" mode="M278" priority="-2">
    <xsl:apply-templates mode="M278" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:CategoryTradeTax/ram:CategoryCode" mode="M279" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:CategoryTradeTax/ram:CategoryCode" />
    <xsl:variable name="codeValue10" select="." />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=10]/enumeration[@value=$codeValue10]" />
      <xsl:otherwise>
        <svrl:failed-assert test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=10]/enumeration[@value=$codeValue10]">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Value of 'ram:CategoryCode' is not allowed.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M279" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M279" priority="-1" />
  <xsl:template match="@*|node()" mode="M279" priority="-2">
    <xsl:apply-templates mode="M279" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:CategoryTradeTax/ram:DueDateTypeCode" mode="M280" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:CategoryTradeTax/ram:DueDateTypeCode" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:DueDateTypeCode' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M280" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M280" priority="-1" />
  <xsl:template match="@*|node()" mode="M280" priority="-2">
    <xsl:apply-templates mode="M280" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:CategoryTradeTax/ram:ExemptionReason" mode="M281" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:CategoryTradeTax/ram:ExemptionReason" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:ExemptionReason' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M281" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M281" priority="-1" />
  <xsl:template match="@*|node()" mode="M281" priority="-2">
    <xsl:apply-templates mode="M281" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:CategoryTradeTax/ram:ExemptionReasonCode" mode="M282" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:CategoryTradeTax/ram:ExemptionReasonCode" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:ExemptionReasonCode' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M282" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M282" priority="-1" />
  <xsl:template match="@*|node()" mode="M282" priority="-2">
    <xsl:apply-templates mode="M282" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:CategoryTradeTax/ram:TaxPointDate" mode="M283" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:CategoryTradeTax/ram:TaxPointDate" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:TaxPointDate' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M283" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M283" priority="-1" />
  <xsl:template match="@*|node()" mode="M283" priority="-2">
    <xsl:apply-templates mode="M283" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:CategoryTradeTax/ram:TypeCode" mode="M284" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:CategoryTradeTax/ram:TypeCode" />
    <xsl:variable name="codeValue9" select="." />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=9]/enumeration[@value=$codeValue9]" />
      <xsl:otherwise>
        <svrl:failed-assert test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=9]/enumeration[@value=$codeValue9]">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Value of 'ram:TypeCode' is not allowed.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M284" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M284" priority="-1" />
  <xsl:template match="@*|node()" mode="M284" priority="-2">
    <xsl:apply-templates mode="M284" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:ReasonCode" mode="M285" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:ReasonCode" />
    <xsl:variable name="codeValue29" select="." />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=29]/enumeration[@value=$codeValue29]" />
      <xsl:otherwise>
        <svrl:failed-assert test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=29]/enumeration[@value=$codeValue29]">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Value of 'ram:ReasonCode' is not allowed.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M285" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M285" priority="-1" />
  <xsl:template match="@*|node()" mode="M285" priority="-2">
    <xsl:apply-templates mode="M285" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]" mode="M286" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:ChargeIndicator)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:ChargeIndicator)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:ChargeIndicator' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:ActualAmount)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:ActualAmount)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:ActualAmount' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:CategoryTradeTax)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:CategoryTradeTax)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:CategoryTradeTax' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M286" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M286" priority="-1" />
  <xsl:template match="@*|node()" mode="M286" priority="-2">
    <xsl:apply-templates mode="M286" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:ActualAmount[@currencyID]" mode="M287" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:ActualAmount[@currencyID]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Attribute @currencyID' marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M287" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M287" priority="-1" />
  <xsl:template match="@*|node()" mode="M287" priority="-2">
    <xsl:apply-templates mode="M287" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:BasisAmount[@currencyID]" mode="M288" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:BasisAmount[@currencyID]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Attribute @currencyID' marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M288" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M288" priority="-1" />
  <xsl:template match="@*|node()" mode="M288" priority="-2">
    <xsl:apply-templates mode="M288" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:CategoryTradeTax" mode="M289" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:CategoryTradeTax" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:TypeCode)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:TypeCode)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:TypeCode' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:CategoryCode)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:CategoryCode)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:CategoryCode' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M289" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M289" priority="-1" />
  <xsl:template match="@*|node()" mode="M289" priority="-2">
    <xsl:apply-templates mode="M289" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:CategoryTradeTax/ram:BasisAmount" mode="M290" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:CategoryTradeTax/ram:BasisAmount" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:BasisAmount' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M290" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M290" priority="-1" />
  <xsl:template match="@*|node()" mode="M290" priority="-2">
    <xsl:apply-templates mode="M290" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:CategoryTradeTax/ram:CalculatedAmount" mode="M291" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:CategoryTradeTax/ram:CalculatedAmount" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:CalculatedAmount' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M291" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M291" priority="-1" />
  <xsl:template match="@*|node()" mode="M291" priority="-2">
    <xsl:apply-templates mode="M291" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:CategoryTradeTax/ram:CategoryCode" mode="M292" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:CategoryTradeTax/ram:CategoryCode" />
    <xsl:variable name="codeValue10" select="." />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=10]/enumeration[@value=$codeValue10]" />
      <xsl:otherwise>
        <svrl:failed-assert test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=10]/enumeration[@value=$codeValue10]">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Value of 'ram:CategoryCode' is not allowed.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M292" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M292" priority="-1" />
  <xsl:template match="@*|node()" mode="M292" priority="-2">
    <xsl:apply-templates mode="M292" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:CategoryTradeTax/ram:DueDateTypeCode" mode="M293" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:CategoryTradeTax/ram:DueDateTypeCode" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:DueDateTypeCode' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M293" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M293" priority="-1" />
  <xsl:template match="@*|node()" mode="M293" priority="-2">
    <xsl:apply-templates mode="M293" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:CategoryTradeTax/ram:ExemptionReason" mode="M294" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:CategoryTradeTax/ram:ExemptionReason" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:ExemptionReason' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M294" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M294" priority="-1" />
  <xsl:template match="@*|node()" mode="M294" priority="-2">
    <xsl:apply-templates mode="M294" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:CategoryTradeTax/ram:ExemptionReasonCode" mode="M295" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:CategoryTradeTax/ram:ExemptionReasonCode" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:ExemptionReasonCode' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M295" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M295" priority="-1" />
  <xsl:template match="@*|node()" mode="M295" priority="-2">
    <xsl:apply-templates mode="M295" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:CategoryTradeTax/ram:TaxPointDate" mode="M296" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:CategoryTradeTax/ram:TaxPointDate" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:TaxPointDate' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M296" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M296" priority="-1" />
  <xsl:template match="@*|node()" mode="M296" priority="-2">
    <xsl:apply-templates mode="M296" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:CategoryTradeTax/ram:TypeCode" mode="M297" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:CategoryTradeTax/ram:TypeCode" />
    <xsl:variable name="codeValue9" select="." />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=9]/enumeration[@value=$codeValue9]" />
      <xsl:otherwise>
        <svrl:failed-assert test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=9]/enumeration[@value=$codeValue9]">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Value of 'ram:TypeCode' is not allowed.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M297" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M297" priority="-1" />
  <xsl:template match="@*|node()" mode="M297" priority="-2">
    <xsl:apply-templates mode="M297" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:ReasonCode" mode="M298" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:ReasonCode" />
    <xsl:variable name="codeValue30" select="." />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=30]/enumeration[@value=$codeValue30]" />
      <xsl:otherwise>
        <svrl:failed-assert test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=30]/enumeration[@value=$codeValue30]">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Value of 'ram:ReasonCode' is not allowed.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M298" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M298" priority="-1" />
  <xsl:template match="@*|node()" mode="M298" priority="-2">
    <xsl:apply-templates mode="M298" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms" mode="M299" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:Description)&lt;=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:Description)&lt;=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:Description' may occur at maximum 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:DirectDebitMandateID)&lt;=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:DirectDebitMandateID)&lt;=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:DirectDebitMandateID' may occur at maximum 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M299" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M299" priority="-1" />
  <xsl:template match="@*|node()" mode="M299" priority="-2">
    <xsl:apply-templates mode="M299" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:DirectDebitMandateID[@schemeID]" mode="M300" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:DirectDebitMandateID[@schemeID]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Attribute @schemeID' marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M300" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M300" priority="-1" />
  <xsl:template match="@*|node()" mode="M300" priority="-2">
    <xsl:apply-templates mode="M300" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:DueDateDateTime/udt:DateTimeString" mode="M301" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:DueDateDateTime/udt:DateTimeString" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@format" />
      <xsl:otherwise>
        <svrl:failed-assert test="@format">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@format' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M301" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M301" priority="-1" />
  <xsl:template match="@*|node()" mode="M301" priority="-2">
    <xsl:apply-templates mode="M301" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:DueDateDateTime/udt:DateTimeString[@format]" mode="M302" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:DueDateDateTime/udt:DateTimeString[@format]" />
    <xsl:variable name="codeValue3" select="@format" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=3]/enumeration[@value=$codeValue3]" />
      <xsl:otherwise>
        <svrl:failed-assert test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=3]/enumeration[@value=$codeValue3]">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Value of '@format' is not allowed.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M302" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M302" priority="-1" />
  <xsl:template match="@*|node()" mode="M302" priority="-2">
    <xsl:apply-templates mode="M302" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation" mode="M303" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:LineTotalAmount)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:LineTotalAmount)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:LineTotalAmount' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:ChargeTotalAmount)&lt;=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:ChargeTotalAmount)&lt;=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:ChargeTotalAmount' may occur at maximum 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:AllowanceTotalAmount)&lt;=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:AllowanceTotalAmount)&lt;=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:AllowanceTotalAmount' may occur at maximum 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:TaxBasisTotalAmount)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:TaxBasisTotalAmount)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:TaxBasisTotalAmount' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:TaxTotalAmount[@currencyID=../../ram:InvoiceCurrencyCode])&lt;=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:TaxTotalAmount[@currencyID=../../ram:InvoiceCurrencyCode])&lt;=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element variant 'ram:TaxTotalAmount[@currencyID=../../ram:InvoiceCurrencyCode]' may occur at maximum 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:TaxTotalAmount[@currencyID=../../ram:TaxCurrencyCode])&lt;=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:TaxTotalAmount[@currencyID=../../ram:TaxCurrencyCode])&lt;=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element variant 'ram:TaxTotalAmount[@currencyID=../../ram:TaxCurrencyCode]' may occur at maximum 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:RoundingAmount)&lt;=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:RoundingAmount)&lt;=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:RoundingAmount' may occur at maximum 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:GrandTotalAmount)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:GrandTotalAmount)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:GrandTotalAmount' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:TotalPrepaidAmount)&lt;=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:TotalPrepaidAmount)&lt;=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:TotalPrepaidAmount' may occur at maximum 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:DuePayableAmount)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:DuePayableAmount)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:DuePayableAmount' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M303" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M303" priority="-1" />
  <xsl:template match="@*|node()" mode="M303" priority="-2">
    <xsl:apply-templates mode="M303" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:AllowanceTotalAmount[@currencyID]" mode="M304" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:AllowanceTotalAmount[@currencyID]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Attribute @currencyID' marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M304" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M304" priority="-1" />
  <xsl:template match="@*|node()" mode="M304" priority="-2">
    <xsl:apply-templates mode="M304" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:ChargeTotalAmount[@currencyID]" mode="M305" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:ChargeTotalAmount[@currencyID]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Attribute @currencyID' marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M305" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M305" priority="-1" />
  <xsl:template match="@*|node()" mode="M305" priority="-2">
    <xsl:apply-templates mode="M305" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:DuePayableAmount[@currencyID]" mode="M306" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:DuePayableAmount[@currencyID]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Attribute @currencyID' marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M306" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M306" priority="-1" />
  <xsl:template match="@*|node()" mode="M306" priority="-2">
    <xsl:apply-templates mode="M306" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:GrandTotalAmount[@currencyID]" mode="M307" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:GrandTotalAmount[@currencyID]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Attribute @currencyID' marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M307" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M307" priority="-1" />
  <xsl:template match="@*|node()" mode="M307" priority="-2">
    <xsl:apply-templates mode="M307" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:LineTotalAmount[@currencyID]" mode="M308" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:LineTotalAmount[@currencyID]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Attribute @currencyID' marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M308" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M308" priority="-1" />
  <xsl:template match="@*|node()" mode="M308" priority="-2">
    <xsl:apply-templates mode="M308" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:RoundingAmount[@currencyID]" mode="M309" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:RoundingAmount[@currencyID]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Attribute @currencyID' marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M309" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M309" priority="-1" />
  <xsl:template match="@*|node()" mode="M309" priority="-2">
    <xsl:apply-templates mode="M309" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxBasisTotalAmount[@currencyID]" mode="M310" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxBasisTotalAmount[@currencyID]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Attribute @currencyID' marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M310" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M310" priority="-1" />
  <xsl:template match="@*|node()" mode="M310" priority="-2">
    <xsl:apply-templates mode="M310" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxTotalAmount[ not(@currencyID=../../ram:InvoiceCurrencyCode) and  not(@currencyID=../../ram:TaxCurrencyCode)]" mode="M311" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxTotalAmount[ not(@currencyID=../../ram:InvoiceCurrencyCode) and  not(@currencyID=../../ram:TaxCurrencyCode)]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element variant 'ram:TaxTotalAmount[ not(@currencyID=../../ram:InvoiceCurrencyCode) and  not(@currencyID=../../ram:TaxCurrencyCode)]' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M311" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M311" priority="-1" />
  <xsl:template match="@*|node()" mode="M311" priority="-2">
    <xsl:apply-templates mode="M311" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxTotalAmount[@currencyID=../../ram:InvoiceCurrencyCode and @currencyID]" mode="M312" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxTotalAmount[@currencyID=../../ram:InvoiceCurrencyCode and @currencyID]" />
    <xsl:variable name="codeValue31" select="@currencyID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=31]/enumeration[@value=$codeValue31]" />
      <xsl:otherwise>
        <svrl:failed-assert test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=31]/enumeration[@value=$codeValue31]">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Value of '@currencyID' is not allowed.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M312" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M312" priority="-1" />
  <xsl:template match="@*|node()" mode="M312" priority="-2">
    <xsl:apply-templates mode="M312" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxTotalAmount[@currencyID=../../ram:InvoiceCurrencyCode]" mode="M313" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxTotalAmount[@currencyID=../../ram:InvoiceCurrencyCode]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@currencyID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@currencyID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@currencyID' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M313" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M313" priority="-1" />
  <xsl:template match="@*|node()" mode="M313" priority="-2">
    <xsl:apply-templates mode="M313" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxTotalAmount[@currencyID=../../ram:TaxCurrencyCode and @currencyID]" mode="M314" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxTotalAmount[@currencyID=../../ram:TaxCurrencyCode and @currencyID]" />
    <xsl:variable name="codeValue32" select="@currencyID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=32]/enumeration[@value=$codeValue32]" />
      <xsl:otherwise>
        <svrl:failed-assert test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=32]/enumeration[@value=$codeValue32]">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Value of '@currencyID' is not allowed.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M314" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M314" priority="-1" />
  <xsl:template match="@*|node()" mode="M314" priority="-2">
    <xsl:apply-templates mode="M314" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxTotalAmount[@currencyID=../../ram:TaxCurrencyCode]" mode="M315" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxTotalAmount[@currencyID=../../ram:TaxCurrencyCode]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@currencyID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@currencyID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@currencyID' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M315" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M315" priority="-1" />
  <xsl:template match="@*|node()" mode="M315" priority="-2">
    <xsl:apply-templates mode="M315" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TotalPrepaidAmount[@currencyID]" mode="M316" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TotalPrepaidAmount[@currencyID]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Attribute @currencyID' marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M316" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M316" priority="-1" />
  <xsl:template match="@*|node()" mode="M316" priority="-2">
    <xsl:apply-templates mode="M316" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans" mode="M317" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:TypeCode)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:TypeCode)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:TypeCode' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:Information)&lt;=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:Information)&lt;=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:Information' may occur at maximum 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:PayeePartyCreditorFinancialAccount)&lt;=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:PayeePartyCreditorFinancialAccount)&lt;=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:PayeePartyCreditorFinancialAccount' may occur at maximum 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M317" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M317" priority="-1" />
  <xsl:template match="@*|node()" mode="M317" priority="-2">
    <xsl:apply-templates mode="M317" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:ApplicableTradeSettlementFinancialCard" mode="M318" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:ApplicableTradeSettlementFinancialCard" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:ID)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:ID)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:ID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M318" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M318" priority="-1" />
  <xsl:template match="@*|node()" mode="M318" priority="-2">
    <xsl:apply-templates mode="M318" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:ApplicableTradeSettlementFinancialCard/ram:ID[@schemeID]" mode="M319" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:ApplicableTradeSettlementFinancialCard/ram:ID[@schemeID]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Attribute @schemeID' marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M319" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M319" priority="-1" />
  <xsl:template match="@*|node()" mode="M319" priority="-2">
    <xsl:apply-templates mode="M319" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PayeePartyCreditorFinancialAccount/ram:IBANID[@schemeID]" mode="M320" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PayeePartyCreditorFinancialAccount/ram:IBANID[@schemeID]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Attribute @schemeID' marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M320" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M320" priority="-1" />
  <xsl:template match="@*|node()" mode="M320" priority="-2">
    <xsl:apply-templates mode="M320" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PayeePartyCreditorFinancialAccount/ram:ProprietaryID[@schemeID]" mode="M321" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PayeePartyCreditorFinancialAccount/ram:ProprietaryID[@schemeID]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Attribute @schemeID' marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M321" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M321" priority="-1" />
  <xsl:template match="@*|node()" mode="M321" priority="-2">
    <xsl:apply-templates mode="M321" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PayeeSpecifiedCreditorFinancialInstitution" mode="M322" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PayeeSpecifiedCreditorFinancialInstitution" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:BICID)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:BICID)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:BICID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M322" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M322" priority="-1" />
  <xsl:template match="@*|node()" mode="M322" priority="-2">
    <xsl:apply-templates mode="M322" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PayeeSpecifiedCreditorFinancialInstitution/ram:BICID[@schemeID]" mode="M323" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PayeeSpecifiedCreditorFinancialInstitution/ram:BICID[@schemeID]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Attribute @schemeID' marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M323" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M323" priority="-1" />
  <xsl:template match="@*|node()" mode="M323" priority="-2">
    <xsl:apply-templates mode="M323" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PayerPartyDebtorFinancialAccount" mode="M324" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PayerPartyDebtorFinancialAccount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:IBANID)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:IBANID)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:IBANID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M324" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M324" priority="-1" />
  <xsl:template match="@*|node()" mode="M324" priority="-2">
    <xsl:apply-templates mode="M324" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PayerPartyDebtorFinancialAccount/ram:IBANID[@schemeID]" mode="M325" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PayerPartyDebtorFinancialAccount/ram:IBANID[@schemeID]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Attribute @schemeID' marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M325" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M325" priority="-1" />
  <xsl:template match="@*|node()" mode="M325" priority="-2">
    <xsl:apply-templates mode="M325" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:TypeCode" mode="M326" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:TypeCode" />
    <xsl:variable name="codeValue25" select="." />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=25]/enumeration[@value=$codeValue25]" />
      <xsl:otherwise>
        <svrl:failed-assert test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=25]/enumeration[@value=$codeValue25]">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Value of 'ram:TypeCode' is not allowed.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M326" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M326" priority="-1" />
  <xsl:template match="@*|node()" mode="M326" priority="-2">
    <xsl:apply-templates mode="M326" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxCurrencyCode" mode="M327" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxCurrencyCode" />
    <xsl:variable name="codeValue24" select="." />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=24]/enumeration[@value=$codeValue24]" />
      <xsl:otherwise>
        <svrl:failed-assert test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=24]/enumeration[@value=$codeValue24]">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Value of 'ram:TaxCurrencyCode' is not allowed.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M327" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M327" priority="-1" />
  <xsl:template match="@*|node()" mode="M327" priority="-2">
    <xsl:apply-templates mode="M327" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem" mode="M328" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:AssociatedDocumentLineDocument)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:AssociatedDocumentLineDocument)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:AssociatedDocumentLineDocument' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:SpecifiedTradeProduct)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:SpecifiedTradeProduct)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:SpecifiedTradeProduct' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:SpecifiedLineTradeAgreement)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:SpecifiedLineTradeAgreement)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:SpecifiedLineTradeAgreement' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:SpecifiedLineTradeDelivery)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:SpecifiedLineTradeDelivery)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:SpecifiedLineTradeDelivery' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M328" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M328" priority="-1" />
  <xsl:template match="@*|node()" mode="M328" priority="-2">
    <xsl:apply-templates mode="M328" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:AssociatedDocumentLineDocument" mode="M329" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:AssociatedDocumentLineDocument" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:LineID)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:LineID)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:LineID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:IncludedNote)&lt;=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:IncludedNote)&lt;=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:IncludedNote' may occur at maximum 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M329" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M329" priority="-1" />
  <xsl:template match="@*|node()" mode="M329" priority="-2">
    <xsl:apply-templates mode="M329" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:AssociatedDocumentLineDocument/ram:IncludedNote" mode="M330" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:AssociatedDocumentLineDocument/ram:IncludedNote" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:Content)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:Content)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:Content' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M330" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M330" priority="-1" />
  <xsl:template match="@*|node()" mode="M330" priority="-2">
    <xsl:apply-templates mode="M330" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:AssociatedDocumentLineDocument/ram:IncludedNote/ram:SubjectCode" mode="M331" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:AssociatedDocumentLineDocument/ram:IncludedNote/ram:SubjectCode" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:SubjectCode' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M331" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M331" priority="-1" />
  <xsl:template match="@*|node()" mode="M331" priority="-2">
    <xsl:apply-templates mode="M331" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:AssociatedDocumentLineDocument/ram:LineID[@schemeID]" mode="M332" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:AssociatedDocumentLineDocument/ram:LineID[@schemeID]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Attribute @schemeID' marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M332" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M332" priority="-1" />
  <xsl:template match="@*|node()" mode="M332" priority="-2">
    <xsl:apply-templates mode="M332" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement" mode="M333" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:NetPriceProductTradePrice)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:NetPriceProductTradePrice)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:NetPriceProductTradePrice' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M333" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M333" priority="-1" />
  <xsl:template match="@*|node()" mode="M333" priority="-2">
    <xsl:apply-templates mode="M333" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:BuyerOrderReferencedDocument/ram:AttachmentBinaryObject" mode="M334" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:BuyerOrderReferencedDocument/ram:AttachmentBinaryObject" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M334" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M334" priority="-1" />
  <xsl:template match="@*|node()" mode="M334" priority="-2">
    <xsl:apply-templates mode="M334" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:BuyerOrderReferencedDocument/ram:FormattedIssueDateTime" mode="M335" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:BuyerOrderReferencedDocument/ram:FormattedIssueDateTime" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:FormattedIssueDateTime' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M335" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M335" priority="-1" />
  <xsl:template match="@*|node()" mode="M335" priority="-2">
    <xsl:apply-templates mode="M335" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:BuyerOrderReferencedDocument/ram:IssuerAssignedID" mode="M336" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:BuyerOrderReferencedDocument/ram:IssuerAssignedID" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:IssuerAssignedID' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M336" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M336" priority="-1" />
  <xsl:template match="@*|node()" mode="M336" priority="-2">
    <xsl:apply-templates mode="M336" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:BuyerOrderReferencedDocument/ram:LineID[@schemeID]" mode="M337" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:BuyerOrderReferencedDocument/ram:LineID[@schemeID]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Attribute @schemeID' marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M337" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M337" priority="-1" />
  <xsl:template match="@*|node()" mode="M337" priority="-2">
    <xsl:apply-templates mode="M337" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:BuyerOrderReferencedDocument/ram:Name" mode="M338" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:BuyerOrderReferencedDocument/ram:Name" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:Name' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M338" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M338" priority="-1" />
  <xsl:template match="@*|node()" mode="M338" priority="-2">
    <xsl:apply-templates mode="M338" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:BuyerOrderReferencedDocument/ram:ReferenceTypeCode" mode="M339" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:BuyerOrderReferencedDocument/ram:ReferenceTypeCode" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:ReferenceTypeCode' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M339" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M339" priority="-1" />
  <xsl:template match="@*|node()" mode="M339" priority="-2">
    <xsl:apply-templates mode="M339" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:BuyerOrderReferencedDocument/ram:TypeCode" mode="M340" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:BuyerOrderReferencedDocument/ram:TypeCode" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:TypeCode' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M340" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M340" priority="-1" />
  <xsl:template match="@*|node()" mode="M340" priority="-2">
    <xsl:apply-templates mode="M340" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:BuyerOrderReferencedDocument/ram:URIID" mode="M341" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:BuyerOrderReferencedDocument/ram:URIID" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:URIID' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M341" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M341" priority="-1" />
  <xsl:template match="@*|node()" mode="M341" priority="-2">
    <xsl:apply-templates mode="M341" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice" mode="M342" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:ChargeAmount)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:ChargeAmount)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:ChargeAmount' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:AppliedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;])&lt;=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:AppliedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;])&lt;=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element variant 'ram:AppliedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator="false"]' may occur at maximum 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M342" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M342" priority="-1" />
  <xsl:template match="@*|node()" mode="M342" priority="-2">
    <xsl:apply-templates mode="M342" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:AppliedTradeAllowanceCharge[ not(ram:ChargeIndicator/udt:Indicator=&quot;false&quot;) and  not(ram:ChargeIndicator/udt:Indicator=&quot;true&quot;)]" mode="M343" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:AppliedTradeAllowanceCharge[ not(ram:ChargeIndicator/udt:Indicator=&quot;false&quot;) and  not(ram:ChargeIndicator/udt:Indicator=&quot;true&quot;)]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element variant 'ram:AppliedTradeAllowanceCharge[ not(ram:ChargeIndicator/udt:Indicator="false") and  not(ram:ChargeIndicator/udt:Indicator="true")]' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M343" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M343" priority="-1" />
  <xsl:template match="@*|node()" mode="M343" priority="-2">
    <xsl:apply-templates mode="M343" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:AppliedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]" mode="M344" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:AppliedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:ChargeIndicator)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:ChargeIndicator)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:ChargeIndicator' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:ActualAmount)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:ActualAmount)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:ActualAmount' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M344" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M344" priority="-1" />
  <xsl:template match="@*|node()" mode="M344" priority="-2">
    <xsl:apply-templates mode="M344" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:AppliedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:ActualAmount[@currencyID]" mode="M345" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:AppliedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:ActualAmount[@currencyID]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Attribute @currencyID' marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M345" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M345" priority="-1" />
  <xsl:template match="@*|node()" mode="M345" priority="-2">
    <xsl:apply-templates mode="M345" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:AppliedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:BasisAmount" mode="M346" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:AppliedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:BasisAmount" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:BasisAmount' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M346" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M346" priority="-1" />
  <xsl:template match="@*|node()" mode="M346" priority="-2">
    <xsl:apply-templates mode="M346" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:AppliedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:CalculationPercent" mode="M347" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:AppliedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:CalculationPercent" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:CalculationPercent' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M347" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M347" priority="-1" />
  <xsl:template match="@*|node()" mode="M347" priority="-2">
    <xsl:apply-templates mode="M347" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:AppliedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:CategoryTradeTax" mode="M348" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:AppliedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:CategoryTradeTax" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:CategoryTradeTax' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M348" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M348" priority="-1" />
  <xsl:template match="@*|node()" mode="M348" priority="-2">
    <xsl:apply-templates mode="M348" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:AppliedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:Reason" mode="M349" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:AppliedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:Reason" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:Reason' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M349" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M349" priority="-1" />
  <xsl:template match="@*|node()" mode="M349" priority="-2">
    <xsl:apply-templates mode="M349" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:AppliedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:ReasonCode" mode="M350" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:AppliedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:ReasonCode" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:ReasonCode' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M350" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M350" priority="-1" />
  <xsl:template match="@*|node()" mode="M350" priority="-2">
    <xsl:apply-templates mode="M350" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:BasisQuantity[@unitCode]" mode="M351" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:BasisQuantity[@unitCode]" />
    <xsl:variable name="codeValue8" select="@unitCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=8]/enumeration[@value=$codeValue8]" />
      <xsl:otherwise>
        <svrl:failed-assert test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=8]/enumeration[@value=$codeValue8]">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Value of '@unitCode' is not allowed.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M351" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M351" priority="-1" />
  <xsl:template match="@*|node()" mode="M351" priority="-2">
    <xsl:apply-templates mode="M351" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:ChargeAmount[@currencyID]" mode="M352" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:ChargeAmount[@currencyID]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Attribute @currencyID' marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M352" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M352" priority="-1" />
  <xsl:template match="@*|node()" mode="M352" priority="-2">
    <xsl:apply-templates mode="M352" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice" mode="M353" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:ChargeAmount)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:ChargeAmount)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:ChargeAmount' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M353" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M353" priority="-1" />
  <xsl:template match="@*|node()" mode="M353" priority="-2">
    <xsl:apply-templates mode="M353" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:AppliedTradeAllowanceCharge" mode="M354" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:AppliedTradeAllowanceCharge" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:AppliedTradeAllowanceCharge' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M354" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M354" priority="-1" />
  <xsl:template match="@*|node()" mode="M354" priority="-2">
    <xsl:apply-templates mode="M354" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:BasisQuantity[@unitCode]" mode="M355" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:BasisQuantity[@unitCode]" />
    <xsl:variable name="codeValue8" select="@unitCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=8]/enumeration[@value=$codeValue8]" />
      <xsl:otherwise>
        <svrl:failed-assert test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=8]/enumeration[@value=$codeValue8]">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Value of '@unitCode' is not allowed.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M355" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M355" priority="-1" />
  <xsl:template match="@*|node()" mode="M355" priority="-2">
    <xsl:apply-templates mode="M355" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:ChargeAmount[@currencyID]" mode="M356" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:ChargeAmount[@currencyID]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Attribute @currencyID' marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M356" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M356" priority="-1" />
  <xsl:template match="@*|node()" mode="M356" priority="-2">
    <xsl:apply-templates mode="M356" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery" mode="M357" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:BilledQuantity)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:BilledQuantity)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:BilledQuantity' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M357" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M357" priority="-1" />
  <xsl:template match="@*|node()" mode="M357" priority="-2">
    <xsl:apply-templates mode="M357" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:BilledQuantity" mode="M358" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:BilledQuantity" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@unitCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@unitCode">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@unitCode' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M358" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M358" priority="-1" />
  <xsl:template match="@*|node()" mode="M358" priority="-2">
    <xsl:apply-templates mode="M358" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:BilledQuantity[@unitCode]" mode="M359" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:BilledQuantity[@unitCode]" />
    <xsl:variable name="codeValue8" select="@unitCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=8]/enumeration[@value=$codeValue8]" />
      <xsl:otherwise>
        <svrl:failed-assert test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=8]/enumeration[@value=$codeValue8]">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Value of '@unitCode' is not allowed.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M359" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M359" priority="-1" />
  <xsl:template match="@*|node()" mode="M359" priority="-2">
    <xsl:apply-templates mode="M359" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement" mode="M360" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:ApplicableTradeTax)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:ApplicableTradeTax)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:ApplicableTradeTax' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:SpecifiedTradeSettlementLineMonetarySummation)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:SpecifiedTradeSettlementLineMonetarySummation)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:SpecifiedTradeSettlementLineMonetarySummation' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:AdditionalReferencedDocument)&lt;=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:AdditionalReferencedDocument)&lt;=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:AdditionalReferencedDocument' may occur at maximum 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:ReceivableSpecifiedTradeAccountingAccount)&lt;=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:ReceivableSpecifiedTradeAccountingAccount)&lt;=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:ReceivableSpecifiedTradeAccountingAccount' may occur at maximum 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M360" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M360" priority="-1" />
  <xsl:template match="@*|node()" mode="M360" priority="-2">
    <xsl:apply-templates mode="M360" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:AdditionalReferencedDocument" mode="M361" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:AdditionalReferencedDocument" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:IssuerAssignedID)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:IssuerAssignedID)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:IssuerAssignedID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:TypeCode)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:TypeCode)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:TypeCode' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M361" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M361" priority="-1" />
  <xsl:template match="@*|node()" mode="M361" priority="-2">
    <xsl:apply-templates mode="M361" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:AdditionalReferencedDocument/ram:AttachmentBinaryObject" mode="M362" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:AdditionalReferencedDocument/ram:AttachmentBinaryObject" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M362" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M362" priority="-1" />
  <xsl:template match="@*|node()" mode="M362" priority="-2">
    <xsl:apply-templates mode="M362" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:AdditionalReferencedDocument/ram:FormattedIssueDateTime" mode="M363" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:AdditionalReferencedDocument/ram:FormattedIssueDateTime" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:FormattedIssueDateTime' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M363" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M363" priority="-1" />
  <xsl:template match="@*|node()" mode="M363" priority="-2">
    <xsl:apply-templates mode="M363" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:AdditionalReferencedDocument/ram:IssuerAssignedID[@schemeID]" mode="M364" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:AdditionalReferencedDocument/ram:IssuerAssignedID[@schemeID]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Attribute @schemeID' marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M364" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M364" priority="-1" />
  <xsl:template match="@*|node()" mode="M364" priority="-2">
    <xsl:apply-templates mode="M364" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:AdditionalReferencedDocument/ram:LineID" mode="M365" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:AdditionalReferencedDocument/ram:LineID" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:LineID' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M365" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M365" priority="-1" />
  <xsl:template match="@*|node()" mode="M365" priority="-2">
    <xsl:apply-templates mode="M365" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:AdditionalReferencedDocument/ram:Name" mode="M366" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:AdditionalReferencedDocument/ram:Name" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:Name' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M366" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M366" priority="-1" />
  <xsl:template match="@*|node()" mode="M366" priority="-2">
    <xsl:apply-templates mode="M366" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:AdditionalReferencedDocument/ram:ReferenceTypeCode" mode="M367" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:AdditionalReferencedDocument/ram:ReferenceTypeCode" />
    <xsl:variable name="codeValue14" select="." />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=14]/enumeration[@value=$codeValue14]" />
      <xsl:otherwise>
        <svrl:failed-assert test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=14]/enumeration[@value=$codeValue14]">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Value of 'ram:ReferenceTypeCode' is not allowed.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M367" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M367" priority="-1" />
  <xsl:template match="@*|node()" mode="M367" priority="-2">
    <xsl:apply-templates mode="M367" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:AdditionalReferencedDocument/ram:TypeCode" mode="M368" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:AdditionalReferencedDocument/ram:TypeCode" />
    <xsl:variable name="codeValue13" select="." />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=13]/enumeration[@value=$codeValue13]" />
      <xsl:otherwise>
        <svrl:failed-assert test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=13]/enumeration[@value=$codeValue13]">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Value of 'ram:TypeCode' is not allowed.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M368" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M368" priority="-1" />
  <xsl:template match="@*|node()" mode="M368" priority="-2">
    <xsl:apply-templates mode="M368" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:AdditionalReferencedDocument/ram:URIID" mode="M369" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:AdditionalReferencedDocument/ram:URIID" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:URIID' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M369" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M369" priority="-1" />
  <xsl:template match="@*|node()" mode="M369" priority="-2">
    <xsl:apply-templates mode="M369" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax" mode="M370" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:TypeCode)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:TypeCode)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:TypeCode' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:CategoryCode)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:CategoryCode)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:CategoryCode' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M370" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M370" priority="-1" />
  <xsl:template match="@*|node()" mode="M370" priority="-2">
    <xsl:apply-templates mode="M370" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:BasisAmount" mode="M371" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:BasisAmount" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:BasisAmount' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M371" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M371" priority="-1" />
  <xsl:template match="@*|node()" mode="M371" priority="-2">
    <xsl:apply-templates mode="M371" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CalculatedAmount" mode="M372" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CalculatedAmount" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:CalculatedAmount' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M372" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M372" priority="-1" />
  <xsl:template match="@*|node()" mode="M372" priority="-2">
    <xsl:apply-templates mode="M372" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode" mode="M373" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode" />
    <xsl:variable name="codeValue10" select="." />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=10]/enumeration[@value=$codeValue10]" />
      <xsl:otherwise>
        <svrl:failed-assert test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=10]/enumeration[@value=$codeValue10]">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Value of 'ram:CategoryCode' is not allowed.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M373" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M373" priority="-1" />
  <xsl:template match="@*|node()" mode="M373" priority="-2">
    <xsl:apply-templates mode="M373" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:DueDateTypeCode" mode="M374" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:DueDateTypeCode" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:DueDateTypeCode' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M374" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M374" priority="-1" />
  <xsl:template match="@*|node()" mode="M374" priority="-2">
    <xsl:apply-templates mode="M374" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReason" mode="M375" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReason" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:ExemptionReason' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M375" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M375" priority="-1" />
  <xsl:template match="@*|node()" mode="M375" priority="-2">
    <xsl:apply-templates mode="M375" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReasonCode" mode="M376" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReasonCode" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:ExemptionReasonCode' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M376" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M376" priority="-1" />
  <xsl:template match="@*|node()" mode="M376" priority="-2">
    <xsl:apply-templates mode="M376" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:TaxPointDate" mode="M377" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:TaxPointDate" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:TaxPointDate' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M377" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M377" priority="-1" />
  <xsl:template match="@*|node()" mode="M377" priority="-2">
    <xsl:apply-templates mode="M377" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:TypeCode" mode="M378" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:TypeCode" />
    <xsl:variable name="codeValue9" select="." />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=9]/enumeration[@value=$codeValue9]" />
      <xsl:otherwise>
        <svrl:failed-assert test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=9]/enumeration[@value=$codeValue9]">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Value of 'ram:TypeCode' is not allowed.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M378" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M378" priority="-1" />
  <xsl:template match="@*|node()" mode="M378" priority="-2">
    <xsl:apply-templates mode="M378" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:BillingSpecifiedPeriod/ram:EndDateTime/udt:DateTimeString" mode="M379" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:BillingSpecifiedPeriod/ram:EndDateTime/udt:DateTimeString" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@format" />
      <xsl:otherwise>
        <svrl:failed-assert test="@format">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@format' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M379" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M379" priority="-1" />
  <xsl:template match="@*|node()" mode="M379" priority="-2">
    <xsl:apply-templates mode="M379" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:BillingSpecifiedPeriod/ram:EndDateTime/udt:DateTimeString[@format]" mode="M380" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:BillingSpecifiedPeriod/ram:EndDateTime/udt:DateTimeString[@format]" />
    <xsl:variable name="codeValue3" select="@format" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=3]/enumeration[@value=$codeValue3]" />
      <xsl:otherwise>
        <svrl:failed-assert test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=3]/enumeration[@value=$codeValue3]">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Value of '@format' is not allowed.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M380" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M380" priority="-1" />
  <xsl:template match="@*|node()" mode="M380" priority="-2">
    <xsl:apply-templates mode="M380" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:BillingSpecifiedPeriod/ram:StartDateTime/udt:DateTimeString" mode="M381" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:BillingSpecifiedPeriod/ram:StartDateTime/udt:DateTimeString" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@format" />
      <xsl:otherwise>
        <svrl:failed-assert test="@format">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@format' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M381" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M381" priority="-1" />
  <xsl:template match="@*|node()" mode="M381" priority="-2">
    <xsl:apply-templates mode="M381" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:BillingSpecifiedPeriod/ram:StartDateTime/udt:DateTimeString[@format]" mode="M382" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:BillingSpecifiedPeriod/ram:StartDateTime/udt:DateTimeString[@format]" />
    <xsl:variable name="codeValue3" select="@format" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=3]/enumeration[@value=$codeValue3]" />
      <xsl:otherwise>
        <svrl:failed-assert test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=3]/enumeration[@value=$codeValue3]">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Value of '@format' is not allowed.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M382" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M382" priority="-1" />
  <xsl:template match="@*|node()" mode="M382" priority="-2">
    <xsl:apply-templates mode="M382" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ReceivableSpecifiedTradeAccountingAccount/ram:ID[@schemeID]" mode="M383" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ReceivableSpecifiedTradeAccountingAccount/ram:ID[@schemeID]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Attribute @schemeID' marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M383" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M383" priority="-1" />
  <xsl:template match="@*|node()" mode="M383" priority="-2">
    <xsl:apply-templates mode="M383" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ not(ram:ChargeIndicator/udt:Indicator=&quot;false&quot;) and  not(ram:ChargeIndicator/udt:Indicator=&quot;true&quot;)]" mode="M384" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ not(ram:ChargeIndicator/udt:Indicator=&quot;false&quot;) and  not(ram:ChargeIndicator/udt:Indicator=&quot;true&quot;)]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element variant 'ram:SpecifiedTradeAllowanceCharge[ not(ram:ChargeIndicator/udt:Indicator="false") and  not(ram:ChargeIndicator/udt:Indicator="true")]' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M384" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M384" priority="-1" />
  <xsl:template match="@*|node()" mode="M384" priority="-2">
    <xsl:apply-templates mode="M384" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]" mode="M385" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:ChargeIndicator)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:ChargeIndicator)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:ChargeIndicator' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:ActualAmount)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:ActualAmount)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:ActualAmount' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M385" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M385" priority="-1" />
  <xsl:template match="@*|node()" mode="M385" priority="-2">
    <xsl:apply-templates mode="M385" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:ActualAmount[@currencyID]" mode="M386" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:ActualAmount[@currencyID]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Attribute @currencyID' marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M386" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M386" priority="-1" />
  <xsl:template match="@*|node()" mode="M386" priority="-2">
    <xsl:apply-templates mode="M386" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:BasisAmount[@currencyID]" mode="M387" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:BasisAmount[@currencyID]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Attribute @currencyID' marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M387" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M387" priority="-1" />
  <xsl:template match="@*|node()" mode="M387" priority="-2">
    <xsl:apply-templates mode="M387" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:CategoryTradeTax" mode="M388" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:CategoryTradeTax" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:CategoryTradeTax' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M388" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M388" priority="-1" />
  <xsl:template match="@*|node()" mode="M388" priority="-2">
    <xsl:apply-templates mode="M388" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:ReasonCode" mode="M389" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:ReasonCode" />
    <xsl:variable name="codeValue11" select="." />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=11]/enumeration[@value=$codeValue11]" />
      <xsl:otherwise>
        <svrl:failed-assert test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=11]/enumeration[@value=$codeValue11]">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Value of 'ram:ReasonCode' is not allowed.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M389" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M389" priority="-1" />
  <xsl:template match="@*|node()" mode="M389" priority="-2">
    <xsl:apply-templates mode="M389" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]" mode="M390" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:ChargeIndicator)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:ChargeIndicator)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:ChargeIndicator' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:ActualAmount)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:ActualAmount)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:ActualAmount' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M390" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M390" priority="-1" />
  <xsl:template match="@*|node()" mode="M390" priority="-2">
    <xsl:apply-templates mode="M390" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:ActualAmount[@currencyID]" mode="M391" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:ActualAmount[@currencyID]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Attribute @currencyID' marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M391" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M391" priority="-1" />
  <xsl:template match="@*|node()" mode="M391" priority="-2">
    <xsl:apply-templates mode="M391" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:BasisAmount[@currencyID]" mode="M392" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:BasisAmount[@currencyID]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Attribute @currencyID' marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M392" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M392" priority="-1" />
  <xsl:template match="@*|node()" mode="M392" priority="-2">
    <xsl:apply-templates mode="M392" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:CategoryTradeTax" mode="M393" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:CategoryTradeTax" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Element 'ram:CategoryTradeTax' is marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M393" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M393" priority="-1" />
  <xsl:template match="@*|node()" mode="M393" priority="-2">
    <xsl:apply-templates mode="M393" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:ReasonCode" mode="M394" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:ReasonCode" />
    <xsl:variable name="codeValue12" select="." />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=12]/enumeration[@value=$codeValue12]" />
      <xsl:otherwise>
        <svrl:failed-assert test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=12]/enumeration[@value=$codeValue12]">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Value of 'ram:ReasonCode' is not allowed.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M394" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M394" priority="-1" />
  <xsl:template match="@*|node()" mode="M394" priority="-2">
    <xsl:apply-templates mode="M394" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation" mode="M395" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:LineTotalAmount)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:LineTotalAmount)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:LineTotalAmount' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M395" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M395" priority="-1" />
  <xsl:template match="@*|node()" mode="M395" priority="-2">
    <xsl:apply-templates mode="M395" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount[@currencyID]" mode="M396" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount[@currencyID]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Attribute @currencyID' marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M396" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M396" priority="-1" />
  <xsl:template match="@*|node()" mode="M396" priority="-2">
    <xsl:apply-templates mode="M396" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct" mode="M397" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:Name)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:Name)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:Name' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:Description)&lt;=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:Description)&lt;=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:Description' may occur at maximum 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M397" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M397" priority="-1" />
  <xsl:template match="@*|node()" mode="M397" priority="-2">
    <xsl:apply-templates mode="M397" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ApplicableProductCharacteristic" mode="M398" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ApplicableProductCharacteristic" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:Description)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:Description)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:Description' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:Value)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:Value)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:Value' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M398" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M398" priority="-1" />
  <xsl:template match="@*|node()" mode="M398" priority="-2">
    <xsl:apply-templates mode="M398" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:BuyerAssignedID[@schemeID]" mode="M399" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:BuyerAssignedID[@schemeID]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Attribute @schemeID' marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M399" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M399" priority="-1" />
  <xsl:template match="@*|node()" mode="M399" priority="-2">
    <xsl:apply-templates mode="M399" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:DesignatedProductClassification/ram:ClassCode" mode="M400" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:DesignatedProductClassification/ram:ClassCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@listID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@listID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@listID' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M400" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M400" priority="-1" />
  <xsl:template match="@*|node()" mode="M400" priority="-2">
    <xsl:apply-templates mode="M400" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:DesignatedProductClassification/ram:ClassCode[@listID]" mode="M401" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:DesignatedProductClassification/ram:ClassCode[@listID]" />
    <xsl:variable name="codeValue6" select="@listID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=6]/enumeration[@value=$codeValue6]" />
      <xsl:otherwise>
        <svrl:failed-assert test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=6]/enumeration[@value=$codeValue6]">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Value of '@listID' is not allowed.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M401" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M401" priority="-1" />
  <xsl:template match="@*|node()" mode="M401" priority="-2">
    <xsl:apply-templates mode="M401" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:GlobalID" mode="M402" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:GlobalID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@schemeID' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M402" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M402" priority="-1" />
  <xsl:template match="@*|node()" mode="M402" priority="-2">
    <xsl:apply-templates mode="M402" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:GlobalID[@schemeID]" mode="M403" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:GlobalID[@schemeID]" />
    <xsl:variable name="codeValue5" select="@schemeID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=5]/enumeration[@value=$codeValue5]" />
      <xsl:otherwise>
        <svrl:failed-assert test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=5]/enumeration[@value=$codeValue5]">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Value of '@schemeID' is not allowed.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M403" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M403" priority="-1" />
  <xsl:template match="@*|node()" mode="M403" priority="-2">
    <xsl:apply-templates mode="M403" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:OriginTradeCountry" mode="M404" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:OriginTradeCountry" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:ID)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:ID)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:ID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M404" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M404" priority="-1" />
  <xsl:template match="@*|node()" mode="M404" priority="-2">
    <xsl:apply-templates mode="M404" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:OriginTradeCountry/ram:ID" mode="M405" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:OriginTradeCountry/ram:ID" />
    <xsl:variable name="codeValue7" select="." />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=7]/enumeration[@value=$codeValue7]" />
      <xsl:otherwise>
        <svrl:failed-assert test="document('Factur-X_1.0.07_EN16931_codedb.xml')//cl[@id=7]/enumeration[@value=$codeValue7]">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Value of 'ram:ID' is not allowed.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M405" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M405" priority="-1" />
  <xsl:template match="@*|node()" mode="M405" priority="-2">
    <xsl:apply-templates mode="M405" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:SellerAssignedID[@schemeID]" mode="M406" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:SellerAssignedID[@schemeID]" />

		<!--REPORT -->
<xsl:if test="true()">
      <svrl:successful-report test="true()">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>
	Attribute @schemeID' marked as not used in the given context.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M406" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M406" priority="-1" />
  <xsl:template match="@*|node()" mode="M406" priority="-2">
    <xsl:apply-templates mode="M406" select="@*|*" />
  </xsl:template>
</xsl:stylesheet>
