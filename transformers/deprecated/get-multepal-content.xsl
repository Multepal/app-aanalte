<?xml version="1.0"?>
<!--
    This grabs and combines topic and annotation data.   
 -->
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    
    <xsl:output method="xml" omit-xml-declaration="no" encoding="UTF-8" indent="yes" />
    
    <!-- Parameters -->
    <!--
    <xsl:param name="configFile" select="../config.xml"/> 
    <xsl:variable name="config" select="document($configFile)"/>
    <xsl:variable name="web_api_root" select="$config//item[@id='multepal_db_url']/value/text()"/>
    <xsl:variable name="topics_path" select="$config//item[@id='topic_set_path']/value/text()" />
    <xsl:variable name="annotations_path" select="$config//item[@id='annotation_set_path']/value/text()" />
    <xsl:variable name="snippets_path" select="$config//item[@id='snippet_set_path']/value/text()" />    
    <xsl:variable name="site_root" select="$config//item[@id='base_path']/value/text()"/>
    -->
    <xsl:variable name="web_api_root" select="//item[@id='multepal_db_url']/value/text()"/>
    <xsl:variable name="topics_path" select="//item[@id='topic_set_path']/value/text()" />
    <xsl:variable name="annotations_path" select="//item[@id='annotation_set_path']/value/text()" />
    <xsl:variable name="snippets_path" select="//item[@id='snippet_set_path']/value/text()" />    
    <xsl:variable name="site_root" select="//item[@id='base_path']/value/text()"/>
    
    <!-- Get Topics, etc. -->
    <xsl:variable name="topics" select="document(concat($web_api_root, $topics_path))" />
    <xsl:variable name="annotations" select="document(concat($web_api_root, $annotations_path))" />
    <xsl:variable name="snippets" select="document(concat($web_api_root, $snippets_path))" />
    
    <xsl:template match="/">
        <multepal>
            <xsl:attribute name="src">
                <xsl:value-of select="id('multepal_db_url')/value/text()"/>
            </xsl:attribute>
            <xsl:copy-of select="$topics"/>     
            <xsl:copy-of select="$annotations"/>
        </multepal>
    </xsl:template>
        
    
              
    
    
    
</xsl:stylesheet>