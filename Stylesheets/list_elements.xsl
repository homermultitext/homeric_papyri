<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns="http://www.tei-c.org/ns/1.0" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:html="http://www.w3.org/1999/xhtml" >

    <xsl:template match="/">
        
       <elements>
       		<xsl:apply-templates/>
       </elements>

        
    </xsl:template>

    
<!-- Boilerplate to catch everything else -->

    <xsl:template match="@*|node()">
    	<xsl:copy>
		<xsl:value-of select="name()"/>
    		<xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
