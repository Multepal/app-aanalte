<?xml version="1.0"?>
<!--
    This produces an HTML template file using Jinja processing instructions.   
-->

<xsl:stylesheet version="2.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"    
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:tei="http://www.tei-c.org/ns/1.0" 
    exclude-result-prefixes="tei">
    
    <xsl:output method="html" 
        version="5.0" 
        omit-xml-declaration="yes" 
        encoding="UTF-8" 
        indent="yes"  
        />

    <!-- PARAMETERS and VARIABLES-->
    <!-- <xsl:param name="configFile">/Users/rca2t1/Repos/aanalte/config.xml</xsl:param> -->
    <xsl:param name="configFile">../config.xml</xsl:param>
    <xsl:variable name="config" select="document($configFile)"/>    
    <xsl:variable name="site_title" select="$config/id('site_title')/value/text()"/>
    <xsl:variable name="topics_ajax_root" select="$config/id('multepal_db_url')/value/text()"/>
    <xsl:variable name="base_path" select="$config/id('base_path')/value/text()"/>
    <xsl:variable name="topicsFileName" select="$config/id('local_topic_set_path')/value/text()"/>
    <xsl:variable name="topics" select="document(concat($base_path, $topicsFileName))" />
    <xsl:variable name="annotationsFileName" select="$config/id('local_annotation_set_path')/value/text()"/>
    <xsl:variable name="annotations" select="document(concat($base_path, $annotationsFileName))" />
    <xsl:variable name="css_file_path" select="$config/id('css_file_path')/value/text()"/>
    <xsl:variable name="js_file_path" select="$config/id('js_file_path')/value/text()"/>

    <xsl:variable name="langname">
        <xsl:map>
            <xsl:map-entry key="'quc'">K&quot;iche&quot;</xsl:map-entry>
            <xsl:map-entry key="'spa'">Castellano</xsl:map-entry>  
        </xsl:map>
    </xsl:variable>

    <xsl:variable name="quote">
    <xsl:text>'</xsl:text>
    </xsl:variable>
    
    <xsl:variable name="quote_replacement">
        <xsl:text>__QUOTE__</xsl:text>
    </xsl:variable>
    
    
    <!-- Not sure if this is doing anything -->
    <xsl:preserve-space elements="p" /> 
    
    <!-- Root node: Insert containing page elements -->
    <xsl:template match="/">
        <xsl:variable 
            name="doc_title" 
            select="//tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title/text()"/>
        <html>
            <head>
                <title>
                    <xsl:value-of select="$site_title"/> 
                    <xsl:text> | </xsl:text>
                    <xsl:value-of select="$doc_title"/>
                </title>
                <meta charset="UTF-8"/>
                <!--
                <meta http-equiv="cache-control" content="no-store" />
                -->
                <xsl:for-each select="$config/id('css_files')/value">
                    <xsl:element name="link">
                        <xsl:attribute name="rel">stylesheet</xsl:attribute>
                        <xsl:attribute name="type">text/css</xsl:attribute>
                        <xsl:attribute name="href" select="concat($css_file_path, text())" />
                        <xsl:text xml:space="preserve"> </xsl:text>                        
                    </xsl:element>                    
                </xsl:for-each>                                    
            </head>
            <body>
                <!-- Header; may include a menu at some point -->
                <xsl:comment> HEADER </xsl:comment>
                <nav class="navbar navbar-expand-sm bg-light">
                    <h1 id="page-title">
                        <a href="index.html"><xsl:value-of select="$doc_title"/></a>                        
                    </h1>
                </nav>
        
                <div class="wrapper">
                    
                    <xsl:comment> SIDEBAR </xsl:comment>
                    <div id="sidebar">
                        <h3><small>idx</small></h3>
                        <ul class="list-unstyled">
                            <xsl:for-each select="descendant::tei:div[@type='column'][@xml:lang='quc']//tei:pb">
                                <xsl:variable name="folio" select="number(substring(@xml:id, 6, 2))" />
                                <xsl:variable name="side" select="substring(@xml:id, 10, 1)" />
                                <xsl:variable name="sidex" select="translate($side, '12', 'rv')" />
                                <li>
                                    <a class="folio-index-item" href="#" data-target="{@xml:id}" 
                                        title="Align both columns to Folio {$folio}, side {$side} ({$sidex})">
                                        <xsl:value-of select="concat($folio,$sidex)"/>
                                    </a>    
                                </li>
                            </xsl:for-each>
                        </ul>
                    </div>
                    
                    
                    <div class="container-fluid" id="content">
                        
                        <xsl:comment> CONTENT </xsl:comment>    
                        <div class="row">
                            <!--
                            <xsl:apply-templates select="//tei:text//tei:head"/>
                            -->
                            <xsl:apply-templates select="//tei:text//tei:front"/>
                            <xsl:apply-templates select="//tei:text//tei:body"/>                    
                        </div>
                        
                        <div class="row">
                            <xsl:text>*   *   *</xsl:text>
                        </div>
                        
                        <xsl:comment> FOOTER </xsl:comment>
                        <div class="row text-center mt-3 footer">
                            <div class="col" id="footer">
                                <!-- <a class="btn btn-primary btn-sm" href="index.html">Return Home</a> -->
                            </div>
                        </div>
                    </div>
                </div>
        
                <!-- Modal box for displaying topic or annotation info -->
                <xsl:comment> MODAL </xsl:comment>
                <div class="container" id="data">
                    <div class="modal" tabindex="-1" role="dialog" id="topic-box" title=""
                        style="display:none;"
                        aria-hidden="true">
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
        
                <xsl:comment> TOPICS </xsl:comment>
                <div class="container" id="topic-list">
                    <xsl:apply-templates select="$topics/topics/topic"/>
                </div>
                
                <xsl:comment> ANNOTATIONS </xsl:comment>                
                <div class="container" id="annotation-list">
                    <xsl:apply-templates select="$annotations/annotations/annotation"/>
                </div>
            
                <xsl:comment> SCRIPTS </xsl:comment>
                <xsl:for-each select="$config/id('js_files')/value">
                    <xsl:element name="script">
                        <xsl:attribute name="type">text/javascript</xsl:attribute>
                        <xsl:attribute name="src" select="concat($js_file_path, text())" />
                        <xsl:text xml:space="preserve"> </xsl:text>
                    </xsl:element>                       
                </xsl:for-each>                                
                
            </body>
        </html>        
    </xsl:template>
    
    <xsl:template match="tei:front">
        <div class="tei-front {@rend}">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="tei:body">
        <div class="tei-body {@rend}">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="tei:head">
        <div class="tei-head {@rend}">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <!-- Handle columns -->
    <xsl:template match="tei:div[@type='column']">
        <xsl:variable name="column_label">
            <xsl:choose>
                <xsl:when test="@xml:lang = 'quc'">K'iche'</xsl:when>
                <xsl:otherwise>Castellano</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <div class="col {@xml:lang} {@rend}" xml:lang="{@xml:lang}" title="Lado {$column_label}">    
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
        
        <xsl:variable name="line_id" select="@xml:id" />
        <xsl:variable name="folio" select="number(substring(@xml:id, 6, 2))" />
        <xsl:variable name="side" select="substring(@xml:id, 10, 1)" />
        <xsl:variable name="sidex" select="translate($side, '12', 'rv')" />
        <xsl:variable name="lang" select="substring(@xml:id, 12, 3)" />
        
        <!--
        <xsl:variable name="lang_name" select="$langname($lang)" />
        -->
        
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
        
        <xsl:variable name="line" select="substring(@id, 16, 2)" />
        <xsl:for-each select="$annotations//annotation-map/item[@line_id = $line_id]">
            <a class="lb" href="#"  
                title="Annotation for Folio {$folio}{$sidex}, column {$lang_name}, line {$line}" 
                data-source-line-id="{$line_id}" 
                data-nid="{nid}" 
                data-toggle="modal" 
                data-target="#topic-box">
                <sup class="annotation-icon">&#9998;</sup> <!-- Target 8853 -->
            </a>
        </xsl:for-each>
        
        <xsl:variable name="mycontent">
            <xsl:choose>
                <xsl:when test="preceding-sibling::*[1]/name() = 'pc'">
                    <span class="pc_lb"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text> </xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <!--
        <xsl:text>__LB__</xsl:text>
        -->
        <span class="lb-marker">/</span>
        
        <xsl:value-of select="$mycontent"/>
        
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

        <xsl:element name="span">
            <xsl:attribute name="class">pc</xsl:attribute>
            <xsl:choose>
                <xsl:when test="following-sibling::*[1]/name() = 'lb'">
                    <xsl:text/>             
                </xsl:when>
                <xsl:otherwise>                
                    <xsl:value-of select="text()"/>
                </xsl:otherwise>                    
            </xsl:choose>   
        </xsl:element>
        
        <!-- 
        <span>
            <xsl:attribute name="class">
                <xsl:choose>
                    <xsl:when test="following-sibling::*[1]/name() = 'lb'">
                        <xsl:text>tei-pc tei-pc-</xsl:text>
                        <xsl:value-of select="following-sibling::*[1]/name()"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>tei-pc-</xsl:text>
                    </xsl:otherwise>                    
                </xsl:choose>                
            </xsl:attribute>
            <xsl:value-of select="text()"/>            
        </span>
        -->
        
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
        <xsl:variable name="ana_new" select="replace(@ana, $quote, $quote_replacement)" />
        <a class="rs" data-ana="{$ana_new}" data-toggle="modal" data-target="#topic-box" href="#">
            <xsl:apply-templates />
        </a>
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

        <xsl:variable name="key_new" select="replace(key, $quote, $quote_replacement)" />

        <div class="topic-entry" id="topic-{$key_new}">
            <h2 class="topic-title"><xsl:value-of select="title" /></h2>
            <a href="{$topics_ajax_root}node/{nid}" 
                class="topic-link btn btn-primary btn-sm" target="_blank">See full record</a>
            <div class="topic-type">
                <xsl:value-of select="type"/>
            </div>
            <div class="topic-description">
                <xsl:apply-templates select="description"/>
            </div>
        </div>
    </xsl:template>
    
    <xsl:template match="*[@rend = 'single-line']">
        <xsl:apply-templates/><br/>
    </xsl:template>
    
    <xsl:template match="annotation">
        <div class="annotation-entry" id="annotation-{nid}">
            <h2 class="annotation-title"><xsl:value-of select="title" /></h2>
            <a href="{$topics_ajax_root}node/{nid}" 
                class="annotation-link btn btn-primary btn-sm" target="_blank">
                See full record</a>
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
    
    <!-- THIS SCREWS THINGS UP
    <xsl:template match=
        "text()[not(string-length(normalize-space()))]"/>
    -->
    
</xsl:stylesheet>
    
    <!--
    Sources:
    get-content.py
    xom-paragraphs.xsl
    xom-paragraphs.py
    build-site.py ?
    
     -->
   
