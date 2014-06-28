<?xml version="1.0" encoding="UTF-8"?>

<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
               xmlns:ax="http://www.w3.org/1999/XSL/Transform#Alias"
               xmlns:ser="http://www.fgeorges.org/xslt/serial"
               exclude-result-prefixes="ser"
               version="2.0">

   <xsl:import href="serial-html.xsl"/>

   <xsl:output method="html"/>

   <xsl:namespace-alias stylesheet-prefix="ax" result-prefix="xsl"/>

   <xsl:variable name="indent-by-1" as="element()+">
      <indent width="1">true</indent>
   </xsl:variable>

   <xsl:template match="node()">
      <html>
         <head>
            <link rel="stylesheet" href="serial-oxygen.css" type="text/css"/>
         </head>
         <body>
            <h1>Serialized to HTML, no strip</h1>
            <pre>
               <xsl:sequence select="ser:serialize-to-html(.)"/>
            </pre>
            <h1>Serialized to HTML, strip *</h1>
            <pre>
               <xsl:variable name="strip" as="element()">
                  <strip-spaces>*</strip-spaces>
               </xsl:variable>
               <xsl:variable name="norm" select="ser:normalizer($strip)"/>
               <xsl:variable name="ser" select="
                   ser:make-serializer(ser:html-receiver(), $indent-by-1, $norm)"/>
               <xsl:sequence select="ser:serialize(., $ser)"/>
            </pre>
            <h1>Serialized to HTML, strip xsl:template</h1>
            <pre>
               <xsl:variable name="strip" as="element()">
                  <strip-spaces>xsl:template</strip-spaces>
               </xsl:variable>
               <xsl:variable name="norm" select="ser:normalizer($strip)"/>
               <xsl:variable name="ser" select="
                   ser:make-serializer(ser:html-receiver(), $indent-by-1, $norm)"/>
               <xsl:sequence select="ser:serialize(., $ser)"/>
            </pre>
         </body>
      </html>
   </xsl:template>

</xsl:transform>
