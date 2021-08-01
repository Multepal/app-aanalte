<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output 
        method="xml"
        indent="yes"
    />
    <xsl:template match="/">
        <annotation-map>
            <xsl:apply-templates />    
        </annotation-map>
    </xsl:template>

    <xsl:template match="annotations">
        <xsl:apply-templates />
    </xsl:template>
    
    <xsl:template match="annotation">
        <xsl:element name="item">
            <xsl:attribute name="nid" select="nid" />
            <xsl:apply-templates select="lineas"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="sources">
        <xsl:value-of select="text()"/>
    </xsl:template>
    
    <xsl:template match="lineas">
        
        <!-- GOAL:
        <item nid="995" line_id="xom-f56-s1-quc-27" />
        -->
        <raw>
            <xsl:value-of select="."/>
        </raw>
        
        <xsl:for-each select="tokenize(., '\|')">
            
            <xsl:variable name="item" select="tokenize(., ' ')" />
            
            
            <xsl:variable name="number" select="$item[2]"/>
            
            <xsl:variable name="level" select="lower-case($item[1])"/>
            <xsl:variable name="level">
                <xsl:choose>
                    <xsl:when test="$level = 'folio'">
                        <xsl:text>f</xsl:text>
                        <xsl:value-of select="$number"/>
                    </xsl:when>
                    <xsl:when test="$level = 'column' and $number = 'A'">quc</xsl:when>
                    <xsl:when test="$level = 'column' and $number = 'B'">spa</xsl:when>
                    <xsl:when test="$level = 'line'">                        
                        <xsl:value-of select="$number"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:variable>                        
            
            <xsl:variable name="side">
                <xsl:choose>
                    <xsl:when test="$item[3] = 'recto'">-s1</xsl:when>
                    <xsl:when test="$item[3] = 'verso'">-s2</xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="''"/>
                    </xsl:otherwise>
                </xsl:choose>                
            </xsl:variable>           
            
            <!--
            lb_id = re.sub('Folio-', 'xom-f', lb_id)
            lb_id = re.sub('recto', 's1', lb_id)
            lb_id = re.sub('verso', 's2', lb_id)
            lb_id = re.sub(' Column-A', '-quc', lb_id)
            lb_id = re.sub(' Column-B', '-spa', lb_id)
            lb_id = re.sub(' Line', '', lb_id)
            lb_id = re.sub('Escolio-', 'xom_esc-f', lb_id)
            lb_id = re.sub(' X', '', lb_id)
            -->
            <!--
            <xsl:element name="part">
                <xsl:attribute name="level" select="$level"/>
                <xsl:attribute name="number" select="$number"/>
                <xsl:choose>
                    <xsl:when test="$side != ''">
                        <xsl:attribute name="side" select="$side"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:element>
            -->
            
            <cooked>
                <xsl:value-of select="concat($level, '', $side)"/>                
            </cooked>
            
            
            <!--
            <xsl:element name="part">
                <xsl:attribute name="level" select="$item[1]"/> 
                <xsl:value-of select="$item[2]"/>
            </xsl:element>
            -->            
            
            <!--
            <k>
            <xsl:for-each select="tokenize(., ' ')">
                <v>
                    <xsl:value-of select="normalize-space(.)"/>
                </v>
            </xsl:for-each>
            </k>
            -->
            
        </xsl:for-each>
    </xsl:template>
    
    
</xsl:stylesheet>