<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns="http://www.tei-c.org/ns/1.0" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:html="http://www.w3.org/1999/xhtml" >

    <xsl:template match="/">
        
        <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
            <head>
                <meta http-equiv="content-type" content="text/html; charset=utf-8" />
                <link href="../Stylesheets/homericpapyri.css" rel="stylesheet" type="text/css" />
                <title><xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/></title>
            </head>
            <body>

                <div class="header">
                    <h1><xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/></h1>
                    <h2><xsl:apply-templates select="//tei:editionStmt"/></h2>
                    
                </div>

                <xsl:apply-templates/>
                
            </body>
        </html>

        
    </xsl:template>

<!-- Header Stuff -->

    <xsl:template match="tei:teiHeader"/>
    
    
    
<!-- Fore-matter Stuff -->
    
    
<!-- Papyrus Stuff -->
 
     <xsl:template match="tei:l">
         <p class="line">
             <span class="line-number"><xsl:value-of select="@n"/><xsl:text>&#160;&#160;&#160;&#160;</xsl:text></span>
             <xsl:apply-templates/>
         </p>
     </xsl:template>
 
     <xsl:template match="tei:div[@type='book']">
         <div class="book">
             <span class="book-number">Book <xsl:value-of select="@n"/></span>
             <xsl:apply-templates/>
         </div>
     </xsl:template>
 
     <xsl:template match="tei:supplied">
        <!-- <span class="supplied-text">&lt;<xsl:apply-templates/>&gt;</span> -->
         <span class="supplied-text"><xsl:call-template name="replaceSupplied"/></span>
     </xsl:template>
    
    <xsl:template match="tei:unclear">
        <span class="unclear-text"><xsl:call-template name="addDots"/></span>
    </xsl:template>

    <!-- A bit of recursion to add under-dots to unclear letters -->
    <xsl:template name="addDots">
        <xsl:variable name="currentChar">1</xsl:variable>
        <xsl:variable name="stringLength"><xsl:value-of select="string-length(text())"/></xsl:variable>
        <xsl:variable name="myString"><xsl:value-of select="normalize-space(text())"/></xsl:variable>
        <xsl:call-template name="addDotsRecurse">
            <xsl:with-param name="currentChar"><xsl:value-of select="$currentChar"/></xsl:with-param>
            <xsl:with-param name="stringLength"><xsl:value-of select="$stringLength"/></xsl:with-param>
            <xsl:with-param name="myString"><xsl:value-of select="$myString"/></xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="addDotsRecurse">
        <xsl:param name="currentChar"/>
        <xsl:param name="myString"/>
        <xsl:param name="stringLength"/>
        
        <xsl:choose>
            <xsl:when test="$currentChar &lt;= string-length($myString)">
                <xsl:call-template name="addDotsRecurse">
                    <xsl:with-param name="currentChar"><xsl:value-of select="$currentChar + 2"/></xsl:with-param>
                    <xsl:with-param name="stringLength"><xsl:value-of select="$stringLength + 1"/></xsl:with-param>
                    <xsl:with-param name="myString"><xsl:value-of select="concat(substring($myString,1,$currentChar), '&#803;', substring($myString, ($currentChar+1),(string-length($myString) - ($currentChar))) )"/></xsl:with-param>
                </xsl:call-template>               
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$myString"/>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    <!-- end under-dot recursion -->

    <!-- begin replacing supplied text with non-breaking spaces -->
    <xsl:template name="replaceSupplied">
        <xsl:variable name="currentChar">1</xsl:variable>
        <xsl:variable name="stringLength"><xsl:value-of select="string-length(text())"/></xsl:variable>
        <xsl:variable name="myString"><xsl:value-of select="normalize-space(text())"/></xsl:variable>
        <xsl:call-template name="replaceSuppliedRecurse">
            <xsl:with-param name="currentChar"><xsl:value-of select="$currentChar"/></xsl:with-param>
            <xsl:with-param name="stringLength"><xsl:value-of select="$stringLength"/></xsl:with-param>
            <xsl:with-param name="myString"><xsl:value-of select="$myString"/></xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="replaceSuppliedRecurse">
        <xsl:param name="currentChar"/>
        <xsl:param name="myString"/>
        <xsl:param name="stringLength"/>
        
        <xsl:choose>
            <xsl:when test="$currentChar &lt;= string-length($myString)">
                <xsl:call-template name="replaceSuppliedRecurse">
                    <xsl:with-param name="currentChar"><xsl:value-of select="$currentChar + 2"/></xsl:with-param>
                    <xsl:with-param name="stringLength"><xsl:value-of select="$stringLength"/></xsl:with-param>
                    <xsl:with-param name="myString"><xsl:value-of select="concat(substring($myString,1,($currentChar - 1)),'&#160;&#160;',substring($myString, ($currentChar + 1)))"/></xsl:with-param>
                </xsl:call-template>               
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$myString"/>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    
    <!-- end replacing supplied text with non-breaking spaces -->
    
    <xsl:template match="tei:div">
        <xsl:element name="div">
            <xsl:attribute name="class"><xsl:value-of select="@type"/></xsl:attribute>
            <xsl:attribute name="data-n"><xsl:value-of select="@n"/></xsl:attribute>
            <xsl:apply-templates></xsl:apply-templates>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:add[@place='supralinear']">
        <span class="supralinear-text"><xsl:apply-templates/></span>
    </xsl:template>
    
    <xsl:template match="tei:note"/>

    <xsl:template match="tei:add">
        <span class="added-text"><xsl:apply-templates/></span>
    </xsl:template>
    
    <xsl:template match="tei:choice">
        <span class="choice">(<xsl:apply-templates select="tei:sic"/>
            <xsl:apply-templates select="tei:corr"/>)</span>
    </xsl:template>

    <xsl:template match="tei:sic">
        <span class="sic"><xsl:apply-templates/> [sic]</span>
       <!-- <xsl:if test="current()/following-sibling::tei:corr">/</xsl:if> -->
    </xsl:template>

    <xsl:template match="tei:corr">
        <span class="corr">→<xsl:apply-templates/></span>
        <!-- <xsl:if test="current()/following-sibling::tei:sic">/</xsl:if> -->
    </xsl:template>
    
    <xsl:template match="tei:del">
        <span class="del"><xsl:apply-templates/></span>
    </xsl:template>
    
<!-- Boilerplate to catch everything else -->

    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
