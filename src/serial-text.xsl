<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:pkg="http://expath.org/ns/pkg"
                xmlns:ser="http://fgeorges.org/xslt/serial"
                xmlns:f="http://fxsl.sf.net/"
                exclude-result-prefixes="#all"
                version="2.0">

  <xsl:import href="serial.xsl"/>
  <xsl:import href="http://fxsl.sf.net/f/func-compose.xsl"/>

  <pkg:import-uri>http://fgeorges.org/ns/xslt/serial-text.xsl</pkg:import-uri>

  <!--
      ser:serialize-to-text()
  -->

  <xsl:function name="ser:serialize-to-text" as="node()*">
    <xsl:param name="input" as="item()+"/>
    <xsl:sequence select="
        ser:serialize($input, ser:make-serializer(ser:text-receiver()))"/>
  </xsl:function>

  <!--
      ser:text-serializer()
  -->

  <xsl:function name="ser:text-serializer" as="node()+">
    <xsl:sequence select="ser:make-serializer(ser:text-receiver())"/>
  </xsl:function>

  <xsl:function name="ser:text-serializer" as="node()+">
    <xsl:param name="receiver-options" as="node()?"/>
    <xsl:sequence select="ser:make-serializer(ser:text-receiver($receiver-options))"/>
  </xsl:function>

  <xsl:function name="ser:text-serializer" as="node()+">
    <xsl:param name="receiver-options"   as="node()?"/>
    <xsl:param name="serializer-options" as="node()?"/>
    <xsl:sequence select="
        ser:make-serializer(ser:text-receiver($receiver-options),
                            $serializer-options)"/>
  </xsl:function>

  <!--
      ser:text-receiver()
  -->

  <xsl:function name="ser:text-receiver" as="node()+">
    <xsl:sequence select="ser:text-receiver(())"/>
  </xsl:function>

  <xsl:function name="ser:text-receiver" as="node()+">
    <xsl:param name="options" as="node()?"/>
    <xsl:sequence select="
        ser:make-receiver(
            ser:text-chars(),
            ser:text-text(),
            ser:text-start-elem(),
            ser:text-end-elem(),
            ser:text-start-doc(),
            ser:text-end-doc(),
            ser:text-pi(),
            ser:text-comment(),
            $options,
            ser:text-post-proc()
          )"/>
  </xsl:function>

  <xsl:function name="ser:text-receiver" as="node()+">
    <xsl:param name="options"   as="node()?"/>
    <xsl:param name="post-proc" as="node()?"/>
    <xsl:sequence select="
        ser:make-receiver(
            ser:text-chars(),
            ser:text-text(),
            ser:text-start-elem(),
            ser:text-end-elem(),
            ser:text-start-doc(),
            ser:text-end-doc(),
            ser:text-pi(),
            ser:text-comment(),
            $options,
            f:compose($post-proc, ser:text-post-proc())
          )"/>
  </xsl:function>

  <!--
      ser:text-chars()
  -->

  <xsl:function name="ser:text-chars" as="node()">
    <ser:text-chars/>
  </xsl:function>

  <xsl:template match="ser:text-chars" as="item()*" mode="f:FXSL">
    <xsl:param name="arg1" as="xs:string"/>
    <xsl:param name="arg2" as="item()*"/>
    <xsl:sequence select="ser:text-chars($arg1, $arg2)"/>
  </xsl:template>

  <xsl:function name="ser:text-chars" as="item()*">
    <xsl:param name="str"  as="xs:string"/>
    <xsl:param name="user" as="item()*"/>
    <xsl:analyze-string select="$str" regex="'[&amp;&lt;&gt;]'">
      <xsl:matching-substring>
        <xsl:sequence select="
            if ( '&amp;' eq . ) then
              '&amp;amp;'
            else if ( '&lt;' eq . ) then
              '&amp;lt;'
            else
              '&amp;gt;'
          "/>
      </xsl:matching-substring>
      <xsl:non-matching-substring>
        <xsl:sequence select="."/>
      </xsl:non-matching-substring>
    </xsl:analyze-string>
  </xsl:function>

  <!--
      ser:text-text()
  -->

  <xsl:function name="ser:text-text" as="node()">
    <ser:text-text/>
  </xsl:function>

  <xsl:template match="ser:text-text" as="item()*" mode="f:FXSL">
    <xsl:param name="arg1" as="xs:string"/>
    <xsl:param name="arg2" as="text()"/>
    <xsl:param name="arg3" as="item()*"/>
    <xsl:sequence select="ser:text-text($arg1, $arg2, $arg3)"/>
  </xsl:template>

  <xsl:function name="ser:text-text" as="item()*">
    <xsl:param name="str"  as="xs:string"/>
    <xsl:param name="node" as="text()"/>
    <xsl:param name="user" as="item()*"/>
    <xsl:sequence select="ser:text-chars($str, $user)"/>
  </xsl:function>

  <!--
      ser:text-start-elem()
  -->

  <xsl:function name="ser:text-start-elem" as="node()">
    <ser:text-start-elem/>
  </xsl:function>

  <xsl:template match="ser:text-start-elem" as="item()*" mode="f:FXSL">
    <xsl:param name="arg1" as="element()"/>
    <xsl:param name="arg2" as="element()*"/>
    <xsl:param name="arg3" as="element()*"/>
    <xsl:param name="arg4" as="item()*"/>
    <xsl:sequence select="ser:text-start-elem($arg1, $arg2, $arg3, $arg4)"/>
  </xsl:template>

  <xsl:function name="ser:text-start-elem" as="item()*">
    <xsl:param name="node"  as="element()"/>
    <xsl:param name="attrs" as="element()*"/>
    <xsl:param name="xmlns" as="element()*"/>
    <xsl:param name="user"  as="item()*"/>
    <xsl:sequence select="
        '&lt;',
        name($node),
        for $a in $attrs return
          concat(' ', $a/@name, '=&quot;', $a/@value, '&quot;'),
        for $ns in $xmlns return
          concat(' xmlns:', $ns/@name, '=&quot;', $ns/@uri, '&quot;'),
        if ( $node/node() ) then '' else '/',
        '&gt;'"/>
  </xsl:function>

  <!--
      ser:text-end-elem()
  -->

  <xsl:function name="ser:text-end-elem" as="node()">
    <ser:text-end-elem/>
  </xsl:function>

  <xsl:template match="ser:text-end-elem" as="item()*" mode="f:FXSL">
    <xsl:param name="arg1" as="element()"/>
    <xsl:param name="arg2" as="item()*"/>
    <xsl:sequence select="ser:text-end-elem($arg1, $arg2)"/>
  </xsl:template>

  <xsl:function name="ser:text-end-elem" as="item()*">
    <xsl:param name="node" as="element()"/>
    <xsl:param name="user" as="item()*"/>
    <xsl:sequence select="'&lt;/', name($node), '&gt;'"/>
  </xsl:function>

  <!--
      ser:text-start-doc()
  -->

  <xsl:function name="ser:text-start-doc" as="node()">
    <ser:text-start-doc/>
  </xsl:function>

  <xsl:template match="ser:text-start-doc" as="item()*" mode="f:FXSL">
    <xsl:param name="arg1" as="document-node()"/>
    <xsl:param name="arg2" as="item()*"/>
    <xsl:sequence select="ser:text-start-doc($arg1, $arg2)"/>
  </xsl:template>

  <xsl:function name="ser:text-start-doc" as="item()*">
    <xsl:param name="node" as="document-node()"/>
    <xsl:param name="user" as="item()*"/>
  </xsl:function>

  <!--
      ser:text-end-doc()
  -->

  <xsl:function name="ser:text-end-doc" as="node()">
    <ser:text-end-doc/>
  </xsl:function>

  <xsl:template match="ser:text-end-doc" as="item()*" mode="f:FXSL">
    <xsl:param name="arg1" as="document-node()"/>
    <xsl:param name="arg2" as="item()*"/>
    <xsl:sequence select="ser:text-end-doc($arg1, $arg2)"/>
  </xsl:template>

  <xsl:function name="ser:text-end-doc" as="item()*">
    <xsl:param name="node" as="document-node()"/>
    <xsl:param name="user" as="item()*"/>
  </xsl:function>

  <!--
      ser:text-pi()
  -->

  <xsl:function name="ser:text-pi" as="node()">
    <ser:text-pi/>
  </xsl:function>

  <xsl:template match="ser:text-pi" as="item()*" mode="f:FXSL">
    <xsl:param name="arg1" as="processing-instruction()"/>
    <xsl:param name="arg2" as="item()*"/>
    <xsl:sequence select="ser:text-pi($arg1, $arg2)"/>
  </xsl:template>

  <xsl:function name="ser:text-pi" as="item()*">
    <xsl:param name="node" as="processing-instruction()"/>
    <xsl:param name="user" as="item()*"/>
    <xsl:sequence select="'&lt;?', name($node), ' ', string($node), '?&gt;'"/>
  </xsl:function>

  <!--
      ser:text-comment()
  -->

  <xsl:function name="ser:text-comment" as="node()">
    <ser:text-comment/>
  </xsl:function>

  <xsl:template match="ser:text-comment" as="item()*" mode="f:FXSL">
    <xsl:param name="arg1" as="comment()"/>
    <xsl:param name="arg2" as="item()*"/>
    <xsl:sequence select="ser:text-comment($arg1, $arg2)"/>
  </xsl:template>

  <xsl:function name="ser:text-comment" as="item()*">
    <xsl:param name="node" as="comment()"/>
    <xsl:param name="user" as="item()*"/>
    <xsl:sequence select="'&lt;!--', string($node), '--&gt;'"/>
  </xsl:function>

  <!--
      ser:text-post-proc()
  -->

  <xsl:function name="ser:text-post-proc" as="node()">
    <ser:text-post-proc/>
  </xsl:function>

  <xsl:template match="ser:text-post-proc" as="item()*" mode="f:FXSL">
    <xsl:param name="arg1" as="item()*"/>
    <xsl:param name="arg2" as="item()*"/>
    <xsl:sequence select="ser:text-post-proc($arg1, $arg2)"/>
  </xsl:template>

  <xsl:function name="ser:text-post-proc" as="text()">
    <xsl:param name="strings" as="item()*"/>
    <xsl:param name="user"    as="item()*"/>
    <xsl:value-of select="$strings" separator=""/>
  </xsl:function>

</xsl:stylesheet>
