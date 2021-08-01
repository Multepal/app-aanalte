<?xml version="1.0"?>
<!--
    This produces an HTML template file using Jinja processing instructions.   
 -->
<xsl:stylesheet version="1.0" 
    
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:tei="http://www.tei-c.org/ns/1.0" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xml="http://www.w3.org/XML/1998/namespace"
    exclude-result-prefixes="tei">
    
    <xsl:output method="html" omit-xml-declaration="yes" encoding="UTF-8" indent="no" />
    
    <!-- Parameters -->
    <xsl:param name="configFile" select="../config.xml"/> <!-- Set by passed argument -->
    <xsl:variable name="config" select="document($configFile)"/>
    
    <xsl:variable name="web_api_root" select="$config//item[@id='multepal_db_url']/value/text()"/>
    <xsl:variable name="topics_path" select="$config//item[@id='topic_set_path']/value/text()" />
    <xsl:variable name="annotations_path" select="$config//item[@id='annotation_set_path']/value/text()" />
    <xsl:variable name="snippets_path" select="$config//item[@id='snippet_set_path']/value/text()" />
    
    <xsl:variable name="site_root" select="$config//item[@id='base_path']/value/text()"/>
               
    <!-- Get Topics -->
    <xsl:variable name="topics" select="document(concat($web_api_root, $topics_path))" />
    <xsl:variable name="annotations" select="document(concat($web_api_root, $annotations_path))" />
    <xsl:variable name="snippets" select="document(concat($web_api_root, $snippets_path))" />
    
    <!--
    <xsl:param name="topicsFile" select="'{$site_root}/collections/topics/topics.xml'" />
    <xsl:variable name="topics" select="document($topicsFile)" />
    -->
    <!--
    <xsl:param name="annotationsFile" select="'multepal/annotations.xml'" />
    <xsl:param name="annotations" select="document($annotationsFile)" />
    -->
    <!--
    <xsl:variable name="langname"> 
        <xsl:map>
            <xsl:map-entry key="'quc'" select="'K&quot;iche&quot;'" />
            <xsl:map-entry key="'spa'" select="'Castellano'" /> 
        </xsl:map>
    </xsl:variable>
    -->
    
    <!-- Not sure if this is doing anything -->
    <!--
    <xsl:strip-space elements="p" /> 
    -->
    
    <!-- Root node: Insert containing page elements -->
    <xsl:template match="/">
        
        <xsl:text>{% extends "base.html" %}</xsl:text>
        <xsl:text>{% block content %}</xsl:text>
        
        <!-- Header; may include a menu at some point -->
        <nav class="navbar navbar-expand-sm bg-light">
            <h1>
                <i><a href="index.html">Popol Wuj</a></i>
                <span> : </span>
                <span>Paragraphs and Topics Version</span>
            </h1>
        </nav>
        
        <!-- Main text viewing area -->
        <div class="wrapper">
            <div id="sidebar">
                <h3><small>idx</small></h3>
                <ul class="list-unstyled">
                    <xsl:for-each select="descendant::tei:div[@type='column'][@xml:lang='quc']//tei:pb">
                        <xsl:variable name="folio" select="number(substring(@xml:id, 6, 2))" />
                        <xsl:variable name="side" select="substring(@xml:id, 10, 1)" />
                        <xsl:variable name="sidex" select="translate($side, '12', 'rv')" />
                        <li>
                            <a class="folio-index-item" href="#" data-target="{@xml:id}" title="Align both columns to Folio {$folio}, side {$side} ({$sidex})">
                                <xsl:value-of select="concat($folio,$sidex)"/>
                            </a>    
                        </li>
                    </xsl:for-each>
                </ul>
            </div>
            <div class="container-fluid" id="content">
                <div class="row">
                    <xsl:apply-templates select="//tei:text//tei:body"/>                    
                </div>
                <div class="row">
                    <xsl:text>*   *   *</xsl:text>
                </div>
                <div class="row text-center mt-3 footer">
                    <div class="col" id="footer">
                        <!-- <a class="btn btn-primary btn-sm" href="index.html">Return Home</a> -->
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Modal box for displaying topic or annotation info -->
        <div class="container" id="data">
            <div class="modal" tabindex="-1" role="dialog" id="topic-box" title="">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <div class="modal-type">Type</div>
                            <h3 class="modal-title">Entry</h3>
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&#215;</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            <p>Modal body text goes here.</p>
                        </div>
                        <div class="modal-footer">
                            <a class="multepal-link btn btn-primary" href="#" target="_blank">See full record</a>
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="container" id="topic-list">
            <xsl:text>TOPICS</xsl:text>
            <xsl:value-of select="concat($web_api_root, $topics_path)" />
            <xsl:apply-templates select="$topics/topics/topic"/>
        </div>
        
        <div class="container" id="annotation-list">
            <xsl:apply-templates select="$annotations/annotations/annotation"/>
        </div>
        
        <xsl:text>{% endblock %}</xsl:text>
        
    </xsl:template>
    
    <!-- Handle columns -->
    <xsl:template match="tei:div[@type='column']">
        <xsl:variable name="column_label">
            <xsl:choose>
                <xsl:when test="@xml:lang = 'quc'">K'iche'</xsl:when>
                <xsl:otherwise>Castellano</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <div class="col {@xml:lang}" xml:lang="{@xml:lang}" title="Lado {$column_label}">    
            <h2 class="text-center">Lado <xsl:value-of select="$column_label"/></h2>
            <xsl:apply-templates />
        </div>
    </xsl:template>
    
    <!-- Handle paragraphs -->
    <xsl:template match="tei:p">
        <p data-pos="{position()}"><xsl:apply-templates /></p>
    </xsl:template>
    
    <!-- Handle line breaks -->
    <xsl:template match="tei:lb">
        <xsl:variable name="line_id" select="@id" />
        <xsl:variable name="folio" select="number(substring(@id, 6, 2))" />
        <xsl:variable name="side" select="substring(@id, 10, 1)" />
        <xsl:variable name="sidex" select="translate($side, '12', 'rv')" />
        <xsl:variable name="lang" select="substring(@id, 12, 3)" />
        <xsl:variable name="lang_name" select="$lang" />
        <!--
        <xsl:variable name="lang_name" select="$langname($lang)" />
        -->
        <!--
        <xsl:variable name="lang_name">
            <xsl:choose>
                <xsl:when test="$lang = 'quc'">
                    <xsl:text>K'iche'</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>Castellano</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        -->
        <xsl:variable name="line" select="substring(@id, 16, 2)" />
        <xsl:for-each select="$annotations//annotation-map/item[@line_id = $line_id]">
            <a class="lb" href="#"  
                title="Annotation for Folio {$folio}{$sidex}, column {$lang_name}, line {$line}" 
                data-source-line-id="{$line_id}" 
                data-nid="{@nid}" 
                data-toggle="modal" 
                data-target="#topic-box">
                <sup class="annotation-icon">&#9998;</sup> <!-- Target 8853 -->
            </a>
        </xsl:for-each>
        
        <xsl:text>__LB__</xsl:text>
        <span class="lb-marker">/</span>
        
        
        <!-- DOES NOT WORK AS EXPECTED
        <xsl:choose>
            <xsl:when test="preceding-sibling::tei:pc[1]">
                <xsl:text></xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text> </xsl:text>
            </xsl:otherwise>
        </xsl:choose> 
        -->
    </xsl:template>
    
    <xsl:template match="tei:pc">
        <xsl:text>__PC__</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:pb">
        <xsl:variable name="col" select="ancestor::tei:div[@type='column']/@xml:lang"/>
        <xsl:variable name="pbid" select="concat(@xml:id, @corresp)"/> <!-- Could use a choose here -->
        <xsl:variable name="folio" select="number(substring($pbid, 6, 2))" />
        <xsl:variable name="side" select="substring($pbid, 10, 1)" />
        <xsl:variable name="sidex" select="translate($side, '12', 'rv')" />
        <a id="{$col}-{$pbid}" 
            class="pb folio-index-item" 
            href="#"
            data-target="{$pbid}"
            title="Folio {$folio}, side {$side} ({$sidex}) begins here">
            <xsl:text>&#8212; </xsl:text>
            <xsl:value-of select="concat($folio,$sidex)"/>
            <xsl:text> &#8212;</xsl:text>
        </a>
        <span class="pb-marker">|</span>
    </xsl:template>
    
    <xsl:template match="tei:note">
        <span class="note {@resp} {@place}"><xsl:apply-templates /></span>
    </xsl:template>
    
    <xsl:template match="tei:rs">
        <a class="rs" data-ana="{@ana}" data-toggle="modal" data-target="#topic-box" href="#"><xsl:apply-templates /></a>
    </xsl:template>
    
    <xsl:template match="tei:corr">
        <xsl:apply-templates />
    </xsl:template>
    
    <xsl:template match="tei:hi">
        <span class="hi {@rend}"><xsl:apply-templates /></span>
    </xsl:template>
    
    <xsl:template match="tei:num">
        <span class="num {@rend}"><xsl:apply-templates /></span>
    </xsl:template>
    
    <xsl:template match="tei:del">
        <span class="del {@rend}"><xsl:apply-templates /></span>
    </xsl:template>
    
    <xsl:template match="tei:choice">
        <span class="expan"><xsl:value-of select="tei:expan/text()"/></span>
    </xsl:template>
    
    <!--
    <xsl:template match="text()">
        <xsl:value-of select="normalize-space()" />
    </xsl:template>
    -->
    
    <!-- Change this into a data record for use by JQuery, etc. -->
    <xsl:template match="topic">
        <div class="topic-entry" id="topic-{key}">
            <h2 class="topic-title"><xsl:value-of select="title" /></h2>
            <a href="{$web_api_root}{nid}" class="topic-link btn btn-primary btn-sm" target="_blank">See full record</a>
            <div class="topic-type">
                <xsl:value-of select="type"/>
            </div>
            <div class="topic-description">
                <xsl:apply-templates select="description"/>
            </div>
        </div>
    </xsl:template>
    
    <xsl:template match="annotation">
        <div class="annotation-entry" id="annotation-{@nid}">
            <h2 class="annotation-title"><xsl:value-of select="title" /></h2>
            <a href="{$web_api_root}{@nid}" class="annotation-link btn btn-primary btn-sm" target="_blank">See full record</a>
            <div class="annotation-content">
                <xsl:apply-templates select="content" />
                <div class="annotation-author"><xsl:value-of select="author"/></div>
            </div>
        </div>
    </xsl:template>
    
    <xsl:template match="p">
        <p>
            <xsl:apply-templates />
        </p>
    </xsl:template>
    
    <xsl:template match="a">
        <a href="{@href}" target="{@target}">
            <xsl:apply-templates />
        </a>
    </xsl:template>
    
    <xsl:template match="img">
        <a href="{@src}" target="_blank">
            <img src="{@src}">
                <xsl:apply-templates />
            </img>
        </a>
    </xsl:template>
    
</xsl:stylesheet>