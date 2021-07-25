<?xml version="1.0"?>
<xsl:stylesheet version="2.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xml="http://www.w3.org/XML/1998/namespace"
  xmlns="http://www.tei-c.org/ns/1.0"
  xpath-default-namespace="http://www.tei-c.org/ns/1.0"
  >
  <xsl:output indent="yes" 
    method="xml" 
    omit-xml-declaration="no" />
  <xsl:strip-space elements="*"/>
  
  <xsl:variable name="f01s1" select="document('source/xom-escolios-folio-01-side-1.xml')"/>
  <xsl:variable name="f01s2" select="document('source/xom-escolios-folio-01-side-2.xml')"/>
  <xsl:variable name="f02s1" select="document('source/xom-escolios-folio-02-side-1.xml')"/>
  <xsl:variable name="f02s2" select="document('source/xom-escolios-folio-02-side-2.xml')"/>
  <xsl:variable name="f03s1" select="document('source/xom-escolios-folio-03-side-1.xml')"/>
  <xsl:variable name="f03s2" select="document('source/xom-escolios-folio-03-side-2.xml')"/>
  <xsl:variable name="f04s1" select="document('source/xom-escolios-folio-04-side-1.xml')"/>
  <xsl:variable name="f04s2" select="document('source/xom-escolios-folio-04-side-2.xml')"/>
  <xsl:variable name="f05s1" select="document('source/xom-escolios-folio-05-side-1.xml')"/>
  <xsl:variable name="f05s2" select="document('source/xom-escolios-folio-05-side-2.xml')"/>
  <xsl:variable name="f06s1" select="document('source/xom-escolios-folio-06-side-1.xml')"/>
  <xsl:variable name="f06s2" select="document('source/xom-escolios-folio-06-side-2.xml')"/>
  
  <xsl:template match="//teiHeader">
  <TEI>     
    <xsl:copy-of select="." copy-namespaces="no" />
    <text>
      <front>
        <pb xml:id="f01-s1" />
        <xsl:copy-of select="$f01s1//text/front/*" copy-namespaces="no"/>
      </front>
      <body>
        <pb xml:id="f01-s1" />
        <xsl:copy-of select="$f01s1//text/body/*" copy-namespaces="no"/>
        <pb xml:id="f01-s2" />
        <xsl:copy-of select="$f01s2//text/body/*" copy-namespaces="no"/>
        <pb xml:id="f02-s1" />
        <xsl:copy-of select="$f02s1//text/body/*" copy-namespaces="no"/>
        <pb xml:id="f02-s2" />
        <xsl:copy-of select="$f02s2//text/body/*" copy-namespaces="no"/>
        <pb xml:id="f03-s1" />
        <xsl:copy-of select="$f03s1//text/body/*" copy-namespaces="no"/>
        <pb xml:id="f03-s2" />
        <xsl:copy-of select="$f03s2//text/body/*" copy-namespaces="no"/>
        <pb xml:id="f04-s1" />
        <xsl:copy-of select="$f04s1//text/body/*" copy-namespaces="no"/>
        <pb xml:id="f04-s2" />
        <xsl:copy-of select="$f04s2//text/body/*" copy-namespaces="no"/>
        <pb xml:id="f05-s1" />
        <xsl:copy-of select="$f05s1//text/body/*" copy-namespaces="no"/>
        <pb xml:id="f05-s2" />
        <xsl:copy-of select="$f05s2//text/body/*" copy-namespaces="no"/>
        <pb xml:id="f06-s1" />
        <xsl:copy-of select="$f06s1//text/body/*" copy-namespaces="no"/>
        <pb xml:id="f06-s2" />
        <xsl:copy-of select="$f06s2//text/body/*" copy-namespaces="no"/> 
      </body>
    </text>
  </TEI>
  </xsl:template>

  <xsl:template match="//text">
  </xsl:template>
  
</xsl:stylesheet>
