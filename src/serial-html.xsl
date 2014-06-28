<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:pkg="http://expath.org/ns/pkg"
                xmlns:ser="http://fgeorges.org/xslt/serial"
                xmlns:f="http://fxsl.sf.net/"
                exclude-result-prefixes="#all"
                version="2.0">

  <xsl:import href="serial.xsl"/>

  <pkg:import-uri>http://fgeorges.org/ns/xslt/serial-html.xsl</pkg:import-uri>

  <xsl:variable name="ser:name-classes">
    <element>
      <prefix>xml-serial-element-prefix</prefix>
      <colon>xml-serial-element-colon</colon>
      <local>xml-serial-element-local-name</local>
    </element>
    <attribute>
      <prefix>xml-serial-attribute-prefix</prefix>
      <colon>xml-serial-attribute-colon</colon>
      <local>xml-serial-attribute-local-name</local>
    </attribute>
    <xmlns>
      <prefix>xml-serial-xmlns-xmlns</prefix>
      <colon>xml-serial-xmlns-colon</colon>
      <local>xml-serial-xmlns-prefix</local>
    </xmlns>
  </xsl:variable>

  <xsl:variable name="ser:value-classes">
    <attribute>
      <value>xml-serial-attribute-value</value>
      <value-delimiter>xml-serial-attribute-value-delimiter</value-delimiter>
    </attribute>
    <xmlns>
      <value>xml-serial-xmlns-value</value>
      <value-delimiter>xml-serial-xmlns-value-delimiter</value-delimiter>
    </xmlns>
  </xsl:variable>

  <!--
      ser:serialize-to-html()
  -->

  <xsl:function name="ser:serialize-to-html" as="item()*">
    <xsl:param name="input" as="item()+"/>
    <xsl:sequence select="
        ser:serialize($input, ser:make-serializer(ser:html-receiver()))"/>
  </xsl:function>

  <!--
      ser:html-serializer()
  -->

  <xsl:function name="ser:html-serializer" as="node()+">
    <xsl:sequence select="ser:make-serializer(ser:html-receiver())"/>
  </xsl:function>

  <xsl:function name="ser:html-serializer" as="node()+">
    <xsl:param name="receiver-options" as="node()?"/>
    <xsl:sequence select="ser:make-serializer(ser:html-receiver($receiver-options))"/>
  </xsl:function>

  <xsl:function name="ser:html-serializer" as="node()+">
    <xsl:param name="receiver-options"   as="node()?"/>
    <xsl:param name="serializer-options" as="node()?"/>
    <xsl:sequence select="
        ser:make-serializer(ser:html-receiver($receiver-options),
                            $serializer-options)"/>
  </xsl:function>

  <!--
      ser:html-receiver()
  -->

  <xsl:function name="ser:html-receiver" as="node()+">
    <xsl:sequence select="ser:html-receiver(())"/>
  </xsl:function>

  <xsl:function name="ser:html-receiver" as="node()+">
    <xsl:param name="options" as="node()?"/>
    <xsl:sequence select="
        ser:make-receiver(
            ser:html-chars(),
            ser:html-text(),
            ser:html-start-elem(),
            ser:html-end-elem(),
            ser:html-start-doc(),
            ser:html-end-doc(),
            ser:html-pi(),
            ser:html-comment(),
            $options
          )"/>
  </xsl:function>

  <xsl:function name="ser:html-receiver" as="node()+">
    <xsl:param name="options"   as="node()?"/>
    <xsl:param name="post-proc" as="node()?"/>
    <xsl:sequence select="
        ser:make-receiver(
            ser:html-chars(),
            ser:html-text(),
            ser:html-start-elem(),
            ser:html-end-elem(),
            ser:html-start-doc(),
            ser:html-end-doc(),
            ser:html-pi(),
            ser:html-comment(),
            $options,
            $post-proc
          )"/>
  </xsl:function>

  <!--
      Utility routines (handle names and values).
  -->

  <xsl:function name="ser:html-handle-name" as="node()">
     <ser:html-handle-name/>
  </xsl:function>

  <xsl:template match="ser:html-handle-name" as="item()*" mode="f:FXSL">
     <xsl:param name="arg1" as="xs:string"/>
     <xsl:param name="arg2" as="element()"/>
     <xsl:sequence select="ser:html-handle-name($arg1, $arg2)"/>
  </xsl:template>

  <xsl:function name="ser:html-handle-name" as="item()*">
    <xsl:param name="name"    as="xs:string"/>
    <xsl:param name="classes" as="element()"/>
    <xsl:choose>
      <xsl:when test="contains($name, ':')">
        <span class="{ $classes/prefix }">
          <xsl:sequence select="substring-before($name, ':')"/>
        </span>
        <span class="{ $classes/colon }">:</span>
        <span class="{ $classes/local }">
          <xsl:sequence select="substring-after($name, ':')"/>
        </span>
      </xsl:when>
      <xsl:otherwise>
        <span class="{ $classes/local }">
          <xsl:sequence select="$name"/>
        </span>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="ser:html-handle-value" as="node()">
     <ser:html-handle-value/>
  </xsl:function>

  <xsl:template match="ser:html-handle-value" as="item()*" mode="f:FXSL">
     <xsl:param name="arg1" as="xs:string"/>
     <xsl:param name="arg2" as="element()"/>
     <xsl:sequence select="ser:html-handle-value($arg1, $arg2)"/>
  </xsl:template>

  <xsl:function name="ser:html-handle-value" as="item()*">
    <xsl:param name="value"   as="xs:string"/>
    <xsl:param name="classes" as="element()"/>
    <span class="{ $classes/value-delimiter }">="</span>
    <span class="{ $classes/value }">
      <xsl:sequence select="$value"/>
    </span>
    <span class="{ $classes/value-delimiter }">"</span>
  </xsl:function>

  <!--
      ser:html-chars()
  -->

  <xsl:function name="ser:html-chars" as="node()">
    <ser:html-chars/>
  </xsl:function>

  <xsl:template match="ser:html-chars" as="item()*" mode="f:FXSL">
    <xsl:param name="arg1" as="xs:string"/>
    <xsl:param name="arg2" as="item()*"/>
    <xsl:sequence select="ser:html-chars($arg1, $arg2)"/>
  </xsl:template>

  <xsl:function name="ser:html-chars" as="item()*">
    <xsl:param name="str"  as="xs:string"/>
    <xsl:param name="user" as="item()*"/>
    <span class="xml-serial-text">
      <xsl:value-of select="$str"/>
    </span>
  </xsl:function>

  <!--
      ser:html-text()
  -->

  <xsl:function name="ser:html-text" as="node()">
    <ser:html-text/>
  </xsl:function>

  <xsl:template match="ser:html-text" as="item()*" mode="f:FXSL">
    <xsl:param name="arg1" as="xs:string"/>
    <xsl:param name="arg2" as="text()"/>
    <xsl:param name="arg3" as="item()*"/>
    <xsl:sequence select="ser:html-text($arg1, $arg2, $arg3)"/>
  </xsl:template>

  <xsl:function name="ser:html-text" as="item()*">
    <xsl:param name="str"  as="xs:string"/>
    <xsl:param name="node" as="text()"/>
    <xsl:param name="user" as="item()*"/>
    <span class="xml-serial-text">
      <xsl:value-of select="$str"/>
    </span>
  </xsl:function>

  <!--
      ser:html-start-elem()
  -->

  <!--
      Those are functors to be parametrizable.  TODO: For now, the functor
      actually used is a global variable.  But it should be part of the
      serializer HTML functor...
  -->

  <xsl:variable name="ser:html-handle-name-function"  select="ser:html-handle-name()"  as="node()"/>
  <xsl:variable name="ser:html-handle-value-function" select="ser:html-handle-value()" as="node()"/>

  <xsl:function name="ser:html-start-elem" as="node()">
    <ser:html-start-elem/>
  </xsl:function>

  <xsl:template match="ser:html-start-elem" as="item()*" mode="f:FXSL">
    <xsl:param name="arg1" as="element()"/>
    <xsl:param name="arg2" as="element()*"/>
    <xsl:param name="arg3" as="element()*"/>
    <xsl:param name="arg4" as="item()*"/>
    <xsl:sequence select="ser:html-start-elem($arg1, $arg2, $arg3, $arg4)"/>
  </xsl:template>

  <xsl:function name="ser:html-start-elem" as="item()*">
    <xsl:param name="node"  as="element()"/>
    <xsl:param name="attrs" as="element()*"/>
    <xsl:param name="xmlns" as="element()*"/>
    <xsl:param name="user"  as="item()*"/>
    <span class="xml-serial-tag-delimiter">&lt;</span>
    <xsl:sequence select="f:apply($ser:html-handle-name-function, name($node), $ser:name-classes/element)"/>
    <xsl:for-each select="$attrs">
      <xsl:text> </xsl:text>
      <xsl:sequence select="f:apply($ser:html-handle-name-function, @name, $ser:name-classes/attribute)"/>
      <xsl:sequence select="f:apply($ser:html-handle-value-function, @value, $ser:value-classes/attribute)"/>
    </xsl:for-each>
    <xsl:for-each select="$xmlns">
      <xsl:text> </xsl:text>
      <xsl:sequence select="f:apply($ser:html-handle-name-function,
                                    concat('xmlns:', @name),
                                    $ser:name-classes/xmlns)"/>
      <xsl:sequence select="f:apply($ser:html-handle-value-function, @uri, $ser:value-classes/xmlns)"/>
    </xsl:for-each>
    <xsl:if test="empty($node/node())">
      <span class="xml-serial-tag-slash">/</span>
    </xsl:if>
    <span class="xml-serial-tag-delimiter">&gt;</span>
  </xsl:function>

  <!--
      ser:html-end-elem()
  -->

  <xsl:function name="ser:html-end-elem" as="node()">
    <ser:html-end-elem/>
  </xsl:function>

  <xsl:template match="ser:html-end-elem" as="item()*" mode="f:FXSL">
    <xsl:param name="arg1" as="element()"/>
    <xsl:param name="arg2" as="item()*"/>
    <xsl:sequence select="ser:html-end-elem($arg1, $arg2)"/>
  </xsl:template>

  <xsl:function name="ser:html-end-elem" as="item()*">
    <xsl:param name="node" as="element()"/>
    <xsl:param name="user" as="item()*"/>
    <span class="xml-serial-tag-delimiter">&lt;</span>
    <span class="xml-serial-tag-slash">/</span>
    <xsl:sequence select="f:apply($ser:html-handle-name-function, name($node), $ser:name-classes/element)"/>
    <span class="xml-serial-tag-delimiter">&gt;</span>
  </xsl:function>

  <!--
      ser:html-start-doc()
  -->

  <xsl:function name="ser:html-start-doc" as="node()">
    <ser:html-start-doc/>
  </xsl:function>

  <xsl:template match="ser:html-start-doc" as="item()*" mode="f:FXSL">
    <xsl:param name="arg1" as="document-node()"/>
    <xsl:param name="arg2" as="item()*"/>
    <xsl:sequence select="ser:html-start-doc($arg1, $arg2)"/>
  </xsl:template>

  <xsl:function name="ser:html-start-doc" as="item()*">
    <xsl:param name="node" as="document-node()"/>
    <xsl:param name="user" as="item()*"/>
  </xsl:function>

  <!--
      ser:html-end-doc()
  -->

  <xsl:function name="ser:html-end-doc" as="node()">
    <ser:html-end-doc/>
  </xsl:function>

  <xsl:template match="ser:html-end-doc" as="item()*" mode="f:FXSL">
    <xsl:param name="arg1" as="document-node()"/>
    <xsl:param name="arg2" as="item()*"/>
    <xsl:sequence select="ser:html-end-doc($arg1, $arg2)"/>
  </xsl:template>

  <xsl:function name="ser:html-end-doc" as="item()*">
    <xsl:param name="node" as="document-node()"/>
    <xsl:param name="user" as="item()*"/>
  </xsl:function>

  <!--
      ser:html-pi()
  -->

  <xsl:function name="ser:html-pi" as="node()">
    <ser:html-pi/>
  </xsl:function>

  <xsl:template match="ser:html-pi" as="item()*" mode="f:FXSL">
    <xsl:param name="arg1" as="processing-instruction()"/>
    <xsl:param name="arg2" as="item()*"/>
    <xsl:sequence select="ser:html-pi($arg1, $arg2)"/>
  </xsl:template>

  <xsl:function name="ser:html-pi" as="item()*">
    <xsl:param name="node" as="processing-instruction()"/>
    <xsl:param name="user" as="item()*"/>
    <span class="xml-serial-pi-delimiter">&lt;?</span>
    <span class="xml-serial-pi-target">
      <xsl:value-of select="name($node)"/>
    </span>
    <xsl:text> </xsl:text>
    <span class="xml-serial-attribute-value">
      <xsl:value-of select="string($node)"/>
    </span>
    <span class="xml-serial-pi-delimiter">?&gt;</span>
  </xsl:function>

  <!--
      ser:html-comment()
  -->

  <xsl:function name="ser:html-comment" as="node()">
    <ser:html-comment/>
  </xsl:function>

  <xsl:template match="ser:html-comment" as="item()*" mode="f:FXSL">
    <xsl:param name="arg1" as="comment()"/>
    <xsl:param name="arg2" as="item()*"/>
    <xsl:sequence select="ser:html-comment($arg1, $arg2)"/>
  </xsl:template>

  <xsl:function name="ser:html-comment" as="item()*">
    <xsl:param name="node" as="comment()"/>
    <xsl:param name="user" as="item()*"/>
    <span class="xml-serial-comment-delimiter">&lt;--</span>
    <span class="xml-serial-comment-content">
      <xsl:value-of select="string($node)"/>
    </span>
    <span class="xml-serial-comment-delimiter">--&gt;</span>
  </xsl:function>

</xsl:stylesheet>
