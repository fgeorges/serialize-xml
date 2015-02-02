<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:pkg="http://expath.org/ns/pkg"
                xmlns:ser="http://fgeorges.org/xslt/serial"
                xmlns:f="http://fxsl.sf.net/"
                exclude-result-prefixes="#all"
                version="2.0">

  <!--
      Create a private module that encapsulate those dependencies.
      If we are in XSLT 3.0, then it will use function items to not
      depend on FXSL, if not it will import those FXSL modules...
  -->
  <xsl:import href="http://fxsl.sf.net/f/func-apply.xsl"/>
  <xsl:import href="http://fxsl.sf.net/f/func-compose-flist.xsl"/>
  <xsl:import href="http://fxsl.sf.net/f/func-id.xsl"/>

  <pkg:import-uri>http://fgeorges.org/ns/xslt/serial.xsl</pkg:import-uri>

  <xsl:variable name="ser:options-indent-width-default" select="3" as="xs:integer"/>
  <xsl:variable name="ser:serializer-default-options" as="element()+">
    <indent width="{ $ser:options-indent-width-default }">true</indent>
  </xsl:variable>

  <!--
      CSS resolvers...
      
      Provide the actual location of the CSS files, as installed aside
      this stylesheet.
      
      TODO: It should be easier to provide such functions directly in
      the EXPath Packaging System rather than implementing them again
      and again...
  -->
  <xsl:function name="ser:resolve-css-uri" as="xs:anyURI">
    <xsl:param name="kind" as="xs:string"/> <!-- can be 'nxml' or 'oxygen' -->
    <xsl:sequence select="resolve-uri(concat('serial-', $kind, '.css'))"/>
  </xsl:function>

  <!--
      Constructors.
  -->

  <xsl:function name="ser:make-receiver" as="node()">
    <xsl:param name="chars"      as="node()"/>
    <xsl:param name="text"       as="node()"/>
    <xsl:param name="start-elem" as="node()"/>
    <xsl:param name="end-elem"   as="node()"/>
    <xsl:param name="start-doc"  as="node()"/>
    <xsl:param name="end-doc"    as="node()"/>
    <xsl:param name="pi"         as="node()"/>
    <xsl:param name="comment"    as="node()"/>
    <xsl:param name="options"    as="node()?"/>
    <xsl:sequence select="
        ser:make-receiver(
            $chars,
            $text,
            $start-elem,
            $end-elem,
            $start-doc,
            $end-doc,
            $pi,
            $comment,
            $options,
            f:id()
          )"/>
  </xsl:function>

  <xsl:function name="ser:make-receiver" as="node()">
    <xsl:param name="chars"      as="node()"/>
    <xsl:param name="text"       as="node()"/>
    <xsl:param name="start-elem" as="node()"/>
    <xsl:param name="end-elem"   as="node()"/>
    <xsl:param name="start-doc"  as="node()"/>
    <xsl:param name="end-doc"    as="node()"/>
    <xsl:param name="pi"         as="node()"/>
    <xsl:param name="comment"    as="node()"/>
    <xsl:param name="options"    as="node()?"/>
    <xsl:param name="post-proc"  as="node()"/>
    <ser:receiver>
      <chars>     <xsl:sequence select="$chars"/>     </chars>
      <text>      <xsl:sequence select="$text"/>      </text>
      <start-elem><xsl:sequence select="$start-elem"/></start-elem>
      <end-elem>  <xsl:sequence select="$end-elem"/>  </end-elem>
      <start-doc> <xsl:sequence select="$start-doc"/> </start-doc>
      <end-doc>   <xsl:sequence select="$end-doc"/>   </end-doc>
      <pi>        <xsl:sequence select="$pi"/>        </pi>
      <comment>   <xsl:sequence select="$comment"/>   </comment>
      <options>   <xsl:sequence select="$options"/>   </options>
      <post-proc> <xsl:sequence select="$post-proc"/> </post-proc>
    </ser:receiver>
  </xsl:function>

  <xsl:function name="ser:make-serializer" as="node()">
    <xsl:param name="receiver"   as="node()"/>
    <xsl:sequence select="
        ser:make-serializer($receiver, $ser:serializer-default-options, ser:normalizer())"/>
  </xsl:function>

  <xsl:function name="ser:make-serializer" as="node()">
    <xsl:param name="receiver"   as="node()"/>
    <xsl:param name="options"    as="node()?"/>
    <xsl:sequence select="
        ser:make-serializer($receiver, $options, ser:normalizer())"/>
  </xsl:function>

  <xsl:function name="ser:make-serializer" as="node()">
    <xsl:param name="receiver"   as="node()"/>
    <xsl:param name="options"    as="element()*"/>
    <xsl:param name="normalizer" as="node()"/>
    <xsl:sequence select="
        ser:make-serializer($receiver, $options, $normalizer, f:id())"/>
  </xsl:function>

  <xsl:function name="ser:make-serializer" as="node()">
    <xsl:param name="receiver"   as="node()"/>
    <xsl:param name="options"    as="element()*"/>
    <xsl:param name="normalizer" as="node()"/>
    <xsl:param name="post-proc"  as="node()"/>
    <ser:serializer>
      <normalizer><xsl:sequence select="$normalizer"/></normalizer>
      <receiver>  <xsl:sequence select="$receiver"/>  </receiver>
      <options>   <xsl:sequence select="$options"/>   </options>
      <post-proc> <xsl:sequence select="$post-proc"/> </post-proc>
    </ser:serializer>
  </xsl:function>

  <!--
      ser:normalizer()
  -->

  <xsl:function name="ser:normalizer" as="node()">
    <ser:normalizer/>
  </xsl:function>

  <xsl:function name="ser:normalizer" as="node()">
     <xsl:param name="options" as="element()*"/>
     <ser:normalizer>
        <options>
           <xsl:sequence select="$options"/>
        </options>
     </ser:normalizer>
  </xsl:function>

  <xsl:template match="ser:normalizer" as="document-node()" mode="f:FXSL">
    <xsl:param name="arg1" as="item()*"/>
    <xsl:param name="arg2" as="item()*"/>
    <xsl:document>
       <xsl:choose>
          <xsl:when test="empty(options/strip-spaces)">
             <xsl:sequence select="$arg1"/>
          </xsl:when>
          <xsl:otherwise>
             <xsl:apply-templates select="$arg1" mode="ser:normalize">
                <xsl:with-param name="strip-all"    tunnel="yes" select="
                    normalize-space(options/strip-spaces) eq '*'"/>
                <xsl:with-param name="strip-spaces" tunnel="yes" select="
                    for $t in options/strip-spaces/tokenize(., '\s+')[. ne '*'] return
                      resolve-QName($t, options/strip-spaces)"/>
             </xsl:apply-templates>
          </xsl:otherwise>
       </xsl:choose>
    </xsl:document>
  </xsl:template>

  <xsl:template match="node()" mode="ser:normalize">
     <xsl:copy>
        <xsl:copy-of select="@*"/>
        <xsl:apply-templates select="node()" mode="ser:normalize"/>
     </xsl:copy>
  </xsl:template>

   <xsl:template match="text()" mode="ser:normalize" priority="2">
     <xsl:param name="strip-all"    as="xs:boolean" tunnel="yes"/>
     <xsl:param name="strip-spaces" as="xs:QName*"  tunnel="yes"/>
     <xsl:if test="normalize-space(.)
                     or ancestor::*/@xml:space[. eq 'preserve']
                     or not($strip-all or $strip-spaces = node-name(..))">
        <xsl:sequence select="."/>
     </xsl:if>
  </xsl:template>

  <!--
      ser:serialize()
  -->

  <xsl:function name="ser:serialize" as="item()*">
    <xsl:param name="input"  as="item()*"/>
    <xsl:param name="serial" as="node()"/>
    <xsl:sequence select="ser:serialize($input, $serial, ())"/>
  </xsl:function>

  <xsl:function name="ser:serialize" as="item()*">
    <xsl:param name="input"  as="item()*"/>
    <xsl:param name="serial" as="node()"/>
    <xsl:param name="user"   as="item()*"/>
    <xsl:choose>
       <xsl:when test="$input instance of node()+">
          <xsl:variable name="normalized" as="item()*" select="
              f:apply($serial/normalizer/*, $input, $user)"/>
          <xsl:variable name="result" as="item()*">
            <xsl:apply-templates select="$normalized" mode="ser:serialize">
              <xsl:with-param name="serial" select="$serial"/>
              <xsl:with-param name="user"   select="$user"/>
            </xsl:apply-templates>
          </xsl:variable>
          <xsl:sequence select="
              f:apply($serial/post-proc/*,
                      f:apply($serial/receiver/*/post-proc/*, $result, $user),
                      $user)"/>
       </xsl:when>
       <xsl:otherwise>
          <xsl:sequence select="for $i in $input return string($i)"/>
       </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <!--
      Mode: ser:serialize
  -->

  <xsl:template match="document-node()" mode="ser:serialize" as="item()*">
    <xsl:param name="serial" as="node()+"/>
    <xsl:param name="user"   as="item()*"/>
    <xsl:sequence select="f:apply($serial/receiver/*/start-doc/*, ., $user)"/>
    <xsl:apply-templates select="node()" mode="ser:serialize">
      <xsl:with-param name="serial" select="$serial"/>
      <xsl:with-param name="user"   select="$user"/>
    </xsl:apply-templates>
    <xsl:sequence select="f:apply($serial/receiver/*/end-doc/*, ., $user)"/>
  </xsl:template>

  <xsl:template match="element()" mode="ser:serialize" as="item()*">
    <xsl:param name="serial" as="node()+"/>
    <xsl:param name="user"   as="item()*"/>

    <xsl:variable name="indent-width" as="xs:integer" select="
        if ( $serial/options/indent/@width ) then
          $serial/options/indent/@width
        else
          $ser:options-indent-width-default"/>
    <xsl:variable name="indent-step"  as="xs:string"  select="
        ser:make-string(' ', $indent-width)"/>

    <xsl:variable name="before"   select="
        if ( preceding-sibling::*[1] ) then
          preceding-sibling::*[1]/following-sibling::node() intersect preceding-sibling::node()
        else
          preceding-sibling::node()"/>

    <!--xsl:if test="$serial/options/xs:boolean(indent)
                    and exists(parent::*)
                    and empty(ancestor::*/@xml:space[. eq 'preserve'])
                    and not($before[self::text()][normalize-space(.)])"-->
    <xsl:if test="$serial/options/xs:boolean(indent)
                    and exists(parent::*)
                    and not($before[self::text()])">
      <xsl:variable name="indent-before" select="
            concat('&#10;', ser:make-string($indent-step, count(ancestor::*)))"/>
      <xsl:sequence select="f:apply($serial/receiver/*/chars/*, $indent-before, $user)"/>
    </xsl:if>

    <xsl:sequence select="
        f:apply($serial/receiver/*/start-elem/*,
                .,
                ser:make-attributes(.),
                ser:make-xmlns(.),
                $user)"/>
    <!--xsl:apply-templates mode="ser:serialize" select="
        if ( $serial/options/xs:boolean(indent)
               and empty(ancestor-or-self::*/@xml:space[. eq 'preserve']) ) then
          node() except text()[not(normalize-space(.))]
        else
          node()"-->
    <xsl:apply-templates mode="ser:serialize" select="node()">
      <xsl:with-param name="serial" select="$serial"/>
      <xsl:with-param name="user"   select="$user"/>
    </xsl:apply-templates>

    <xsl:if test="exists(node())">
      <!--xsl:if test="$serial/options/xs:boolean(indent)
                      and empty(ancestor-or-self::*/@xml:space[. eq 'preserve'])
                      and not(node()[last()][self::text()][normalize-space(.)])"-->
      <xsl:if test="$serial/options/xs:boolean(indent)
                      and not(node()[last()][self::text()])">
        <xsl:variable name="indent-after" select="
            concat('&#10;', ser:make-string($indent-step, count(ancestor::*)))"/>
        <xsl:sequence select="f:apply($serial/receiver/*/chars/*, $indent-after, $user)"/>
      </xsl:if>
      <xsl:sequence select="f:apply($serial/receiver/*/end-elem/*, ., $user)"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="text()" mode="ser:serialize" as="item()*">
    <xsl:param name="serial" as="node()+"/>
    <xsl:param name="user"   as="item()*"/>
    <xsl:sequence select="f:apply($serial/receiver/*/text/*, ser:escape-text(.), ., $user)"/>
  </xsl:template>

  <xsl:template match="processing-instruction()" mode="ser:serialize" as="item()*">
    <xsl:param name="serial" as="node()+"/>
    <xsl:param name="user"   as="item()*"/>
    <xsl:sequence select="f:apply($serial/receiver/*/pi/*, ., $user)"/>
  </xsl:template>

  <xsl:template match="comment()" mode="ser:serialize" as="item()*">
    <xsl:param name="serial" as="node()+"/>
    <xsl:param name="user"   as="item()*"/>
    <xsl:sequence select="f:apply($serial/receiver/*/comment/*, ., $user)"/>
  </xsl:template>

  <xsl:template match="attribute()" mode="ser:serialize">
    <xsl:param name="serial" as="node()+"/>
    <xsl:param name="user"   as="item()*"/>
    <xsl:message terminate="yes">
      <xsl:text>TODO: XSLT Serial: something wrong happend ?!?</xsl:text>
    </xsl:message>
  </xsl:template>

  <!--
      Utility routines.
  -->

  <xsl:function name="ser:make-attributes" as="element()*">
    <xsl:param name="elem" as="element()"/>
    <xsl:for-each select="$elem/@*">
      <attribute name="{ name(.) }" value="{ ser:escape-attribute(.) }"/>
    </xsl:for-each>
  </xsl:function>

  <xsl:variable name="prefixes-to-ignore" as="xs:string+" select="'xml'"/>

  <xsl:function name="ser:make-xmlns" as="element()*">
    <xsl:param name="elem" as="element()"/>
    <xsl:for-each select="in-scope-prefixes($elem)">
      <xsl:variable name="uri"    select="namespace-uri-for-prefix(., $elem)"/>
      <xsl:variable name="ignore" select="
        if ( . = $prefixes-to-ignore ) then
          true()
        else if ( empty($elem/parent::*) ) then
          false()
        else
          ( . = in-scope-prefixes($elem/parent::*) )
          and ( $uri eq namespace-uri-for-prefix(., $elem/parent::*) )"/>
      <xsl:if test="not($ignore)">
        <xmlns name="{ . }" uri="{ ser:escape-attribute($uri) }"/>
      </xsl:if>
    </xsl:for-each>
  </xsl:function>

  <xsl:function name="ser:escape-attribute" as="xs:string">
    <xsl:param name="value" as="xs:string"/>
    <xsl:sequence select="
        replace(replace($value, '&amp;', '&amp;amp;'),
                '&quot;',
                '&amp;quot;')"/>
  </xsl:function>

  <xsl:function name="ser:escape-text" as="xs:string">
    <xsl:param name="text" as="xs:string"/>
    <xsl:sequence select="
        replace(replace($text, '&amp;', '&amp;amp;'),
                '&lt;',
                '&amp;lt;')"/>
  </xsl:function>

  <xsl:function name="ser:make-string" as="xs:string">
    <xsl:param name="string" as="xs:string"/>
    <xsl:param name="num"    as="xs:integer"/>
    <xsl:sequence select="ser:make-string($string, $num, '')"/>
  </xsl:function>

  <xsl:function name="ser:make-string" as="xs:string">
    <xsl:param name="string"    as="xs:string"/>
    <xsl:param name="num"       as="xs:integer"/>
    <xsl:param name="separator" as="xs:string"/>
    <xsl:sequence select="string-join(for $i in 1 to $num return $string, $separator)"/>
  </xsl:function>

</xsl:stylesheet>
