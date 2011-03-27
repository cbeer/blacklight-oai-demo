<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/" xmlns:dc="http://purl.org/dc/elements/1.1/" exclude-result-prefixes="oai_dc dc" omit-xml-declaration="yes">

    <xsl:template match="/record">
        <doc>
            <xsl:apply-templates />
            <field name="format">oai_pmh_oai_dc</field>
        </doc>
    </xsl:template>

    <xsl:template match="header">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="identifier">
        <field name="identifier_s"><xsl:value-of select="." /></field>
    </xsl:template>

    <xsl:template match="datestamp">
        <field name="timestamp"><xsl:value-of select="." /></field>
    </xsl:template>

    <xsl:template match="metadata">
       <xsl:apply-templates />
   </xsl:template>

   <xsl:template match="oai_dc:dc">
       <xsl:apply-templates />
   </xsl:template>

   <xsl:template match="dc:title[1]">
       <field name="title_display"><xsl:value-of select="." /></field>
       <field>
           <xsl:attribute name="name">dc_<xsl:value-of select="local-name()" />_t</xsl:attribute>
           <xsl:value-of select="." />
       </field>
   </xsl:template>

   <xsl:template match="dc:*">
       <field>
           <xsl:attribute name="name">dc_<xsl:value-of select="local-name()" />_t</xsl:attribute>
           <xsl:value-of select="." />
       </field>
   </xsl:template>

   <xsl:template match="*"/>
</xsl:stylesheet>
