<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xpath-default-namespace="http://www.tei-c.org/ns/1.0" version="2.0"
  exclude-result-prefixes="xsl tei xs">

  <!-- ==================================================================== -->
  <!--                             IMPORTS                                  -->
  <!-- ==================================================================== -->

  <xsl:import href="../.xslt-datura/tei_to_html/tei_to_html.xsl"/>

  <!-- To override, copy this file into your collection's script directory
    and change the above paths to:
    "../../.xslt-datura/tei_to_html/lib/formatting.xsl"
 -->

  <!-- For display in TEI framework, have changed all namespace declarations to http://www.tei-c.org/ns/1.0. If different (e.g. Whitman), will need to change -->
  <xsl:output method="xml" indent="no" encoding="UTF-8" omit-xml-declaration="yes"/>


  <!-- ==================================================================== -->
  <!--                           PARAMETERS                                 -->
  <!-- ==================================================================== -->

  <xsl:param name="collection"/>
  <xsl:param name="data_base"/>
  <xsl:param name="environment"/>
  <xsl:param name="image_large"/>
  <xsl:param name="image_thumb"/>
  <xsl:param name="image_illustration"/>
  <xsl:param name="media_base"/>
  <xsl:param name="site_url"/>
  
  <xsl:variable name="newline" select="'&#x0A;'"/>
  <xsl:variable name="title" select="//teiHeader//bibl/title[1]"/>
  <xsl:variable name="pubDate" select="//teiHeader//bibl/date"/>
  <xsl:variable name="document" select="tokenize(base-uri(.),'/')[last()]"/>
  
  <xsl:variable name="liquid_var">{{ base_url | relative_url }}</xsl:variable>

  <!-- ==================================================================== -->
  <!--                            OVERRIDES                                 -->
  <!-- ==================================================================== -->
  
  <!-- Create front matter (YML) header -->
  <xsl:template match="/">
    <xsl:text>---</xsl:text>
    <xsl:value-of select="$newline"/>
    <xsl:text>title: </xsl:text><xsl:value-of select="$title"/>
    <xsl:value-of select="$newline"/>
    <xsl:text>document: </xsl:text><xsl:value-of select="$document"/>
    <xsl:value-of select="$newline"/>
    <!-- author should be an array because there are multiple values -->
    <xsl:text>author: [</xsl:text>
    <xsl:for-each select="//teiHeader//bibl//author">
      <xsl:variable name="authorName" select="//teiHeader//bibl//author"/>
      <xsl:variable name="count" select="count(following-sibling::author)"/>
      <xsl:choose>
        <xsl:when test=". = preceding::author"/>
        <xsl:otherwise>
          <xsl:text>"</xsl:text><xsl:value-of select="$authorName"/><xsl:text>"</xsl:text>
          <xsl:if test="$count != 0"><xsl:text>,</xsl:text></xsl:if>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
    <xsl:text>]</xsl:text>
    <xsl:value-of select="$newline"/>
    <xsl:text>publication_date: </xsl:text><xsl:value-of select="$pubDate"/>
    <xsl:value-of select="$newline"/>
    <!--<xsl:text>category: </xsl:text><xsl:value-of select="$category"/>-->
    <xsl:text>category: article</xsl:text>
    <xsl:value-of select="$newline"/>
    <xsl:text>---</xsl:text>
    <xsl:value-of select="$newline"/>
    <xsl:value-of select="$newline"/>
    
    <xsl:for-each select="//cit">
      <p class="cit"><xsl:apply-templates/></p>
    </xsl:for-each>
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="text//p">
    <p class="noindent"><xsl:apply-templates/></p>
  </xsl:template>
  
  <xsl:template match="text//head">
    <h2 class="normal"><xsl:apply-templates/></h2>
  </xsl:template>
  
  <xsl:template match="cit"/>
  
</xsl:stylesheet>
