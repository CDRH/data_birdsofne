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
  <xsl:variable name="title">
    <xsl:choose>
      <xsl:when test="contains(//teiHeader//bibl/title[1],':')">
        <xsl:value-of select="substring-before(//teiHeader//bibl/title[1],':')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="//teiHeader//bibl/title[1]"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="pubDate" select="//teiHeader//bibl/date"/>
  <xsl:variable name="document" select="tokenize(base-uri(.),'/')[last()]"/>
  <xsl:variable name="galleryDoc" select="'../../source/authority/gallery.xml'"/>

  <!-- ==================================================================== -->
  <!--                            OVERRIDES                                 -->
  <!-- ==================================================================== -->
  
  <!-- Create front matter (YML) header -->
  <xsl:template match="/">
    <xsl:variable name="apos"><xsl:text>'</xsl:text></xsl:variable>
    <xsl:variable name="doubleQuote"><xsl:text>"</xsl:text></xsl:variable>
    <xsl:text>---</xsl:text>
    <xsl:value-of select="$newline"/>
    <xsl:text>title: </xsl:text><xsl:value-of select="replace(replace(replace($title,'\[','('),'\]',')'),$doubleQuote,'')"/>
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
          <xsl:text>"</xsl:text><xsl:value-of select="replace(replace(replace($authorName,'\[','('),'\]',')'),$doubleQuote,$apos)"/><xsl:text>"</xsl:text>
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
    
    <div id="Content">
    <xsl:for-each select="//cit">
      <p class="cit"><xsl:apply-templates/></p>
    </xsl:for-each>
    <xsl:apply-templates/>
    
    <xsl:if test="document($galleryDoc)//entry[child::id = substring-before($document,'.xml')]">
      <h2 class="rel-img">Related Images:</h2>
      <div id="images">
        <xsl:for-each select="document($galleryDoc)//entry[child::id = substring-before($document,'.xml')]">
          <a>
            <xsl:attribute name="href"><xsl:text>{{ '/gallery/</xsl:text><xsl:value-of select="@id"/><xsl:text>.html' | absolute_url }}</xsl:text></xsl:attribute>
            <img>
              <xsl:attribute name="src"><xsl:text>{{ '/assets/images/small/</xsl:text><xsl:value-of select="@id"/><xsl:text>.jpg' | absolute_url }}</xsl:text></xsl:attribute>
            </img>
          </a>
          <xsl:text>&#160;&#160;</xsl:text>
        </xsl:for-each>
      </div>
    </xsl:if>
    </div>
  </xsl:template>
  
  <xsl:template match="text//p">
    <p class="noindent"><xsl:apply-templates/></p>
  </xsl:template>
  
  <xsl:template match="text//head">
    <xsl:choose>
      <xsl:when test="not(preceding::head)"><h1><xsl:apply-templates/></h1></xsl:when>
    <xsl:otherwise><h2><xsl:apply-templates/></h2></xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="cit"/>
  
  <xsl:template match="list">
    <p class="list">
      <xsl:apply-templates/>
    </p>
  </xsl:template>
  
  <xsl:template match="list/item">
    <xsl:apply-templates/>
    <br/>
  </xsl:template>
  
  <xsl:template match="table">
    <p/>
    <table border="1">
      <xsl:apply-templates/>
    </table>
  </xsl:template>
  
  <xsl:template match="row">
    <tr role="data">
      <xsl:apply-templates/>
    </tr>
  </xsl:template>
  
  <xsl:template match="cell">
    <td class="cell">
        <xsl:apply-templates/>
    </td>
  </xsl:template>
  
  <xsl:template match="hi[@rend='italic']">
    <i><xsl:apply-templates/></i>
  </xsl:template>
  
  <xsl:template match="quotation">
    <p>
        <xsl:apply-templates/>
    </p>
  </xsl:template>
  
  <xsl:template match="figure">
    <center>
      <img>
        <xsl:attribute name="src"><xsl:text>{{ '/assets/images/</xsl:text><xsl:value-of select="@entity"/><xsl:text>.jpg' | absolute_url }}</xsl:text></xsl:attribute>
        <xsl:attribute name="alt">
          <xsl:apply-templates select="figDesc"/>
        </xsl:attribute>
        <xsl:attribute name="border">1</xsl:attribute>
      </img>
    </center>
  </xsl:template>
  
</xsl:stylesheet>
