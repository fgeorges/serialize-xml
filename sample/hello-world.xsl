<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
               xmlns:ser="http://www.fgeorges.org/xslt/serial"
               exclude-result-prefixes="ser"
               version="2.0">

  <xsl:import href="../src/serial.xsl"/>
  <xsl:import href="../src/serial-text.xsl"/>
  <xsl:import href="../src/serial-html.xsl"/>

  <xsl:output method="html"/>

  <xsl:variable name="options-indent-by-4" as="element()+">
    <indent width="4">true</indent>
  </xsl:variable>

  <xsl:variable name="options-no-indent" as="element()+">
    <indent>false</indent>
  </xsl:variable>

  <xsl:template match="/">
    <html>
      <head>
        <link rel="stylesheet" href="../src/serial-nxml.css" type="text/css"/>
      </head>
      <body>
        <h2>To text</h2>
        <pre>
          <xsl:sequence select="ser:serialize-to-text(.)"/>
        </pre>
        <h2>To HTML</h2>
        <pre>
          <xsl:sequence select="ser:serialize-to-html(.)"/>
        </pre>
        <h2>To text, no indent</h2>
        <pre>
          <xsl:sequence select="ser:serialize(., ser:text-serializer((), $options-no-indent))"/>
        </pre>
        <h2>To HTML, no indent</h2>
        <pre>
          <xsl:sequence select="ser:serialize(., ser:html-serializer((), $options-no-indent))"/>
        </pre>
        <h2>To text, indent by 4</h2>
        <pre>
          <xsl:sequence select="ser:serialize(., ser:text-serializer((), $options-indent-by-4))"/>
        </pre>
        <h2>To HTML, indent by 4</h2>
        <pre>
          <xsl:sequence select="ser:serialize(., ser:html-serializer((), $options-indent-by-4))"/>
        </pre>
      </body>
    </html>
  </xsl:template>

</xsl:transform>
