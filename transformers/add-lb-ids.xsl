<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xml="http://www.w3.org/XML/1998/namespace"
    xmlns="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:template match="node()|@*">
        <!-- Copy the current node -->
        <xsl:copy>
            <!-- Including any child nodes it has and any attributes -->
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- Add IDs to lines with numbers showing location in physical OHCO -->
    <!-- e.g. xom-f01-s1-quc-37 -->
    <xsl:template match="lb[@n]">
        
        <xsl:variable name="col">           
            <!-- Consider a more general model here, in cases where columns
            are not used for languages -->
            <xsl:choose>
                <xsl:when test="ancestor::div[@type='column'][@xml:lang][1]">
                    <xsl:value-of select="ancestor::div[@type='column'][1]/@xml:lang"/>
                </xsl:when>          
                <xsl:otherwise>
                    <xsl:value-of select="''"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="pb" select="preceding::pb[1]"/>
        <xsl:variable name="n" select="@n"/>
        <xsl:variable name="pbid">
            <xsl:choose>
                <xsl:when  test="$pb/@corresp">
                    <xsl:value-of select="$pb/@corresp"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$pb/@xml:id"/>
                </xsl:otherwise>
            </xsl:choose>         
        </xsl:variable>
        
        <lb n="{$n}">
            <xsl:attribute name="xml:id">
                <xsl:value-of select="$pbid" />                
                <xsl:if test="$col != ''">
                    <xsl:text>–</xsl:text>
                    <xsl:value-of select="$col"/>                    
                </xsl:if>
                <xsl:text>–</xsl:text>
                <xsl:value-of select="$n"/>
            </xsl:attribute>
            <xsl:value-of select="*|node()"/>
        </lb>
        
    </xsl:template>
    
</xsl:stylesheet>