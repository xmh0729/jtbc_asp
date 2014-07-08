<%
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
Function ubbcode(ByVal strcontent, ByVal spopedom)
  Dim re, i
  ubbcode = strcontent
  If (InStr(strcontent, "[") = 0 Or InStr(strcontent, "]") = 0) And InStr(strcontent, "http://") = 0 Then
    Exit Function
  End If
  Set re = New regexp
  re.ignorecase = True
  re.Global = True
  If InStr(1, strcontent, "[img]", 1) > 0 Then
    re.Pattern = "(\[img\])(.[^\[]*)(\[\/img\])"
    strcontent = re.Replace(strcontent, "<a href=""$2"" target=""_blank""><img src=""$2"" border=""0"" alt=""$2"" onload=""iresize(this,1,500)""></a>")
  End If
  If InStr(1, strcontent, "[/dir]", 1) > 0 Then
    re.Pattern = "\[dir=*([0-9]*),*([0-9]*)\](.[^\[]*)\[\/dir]"
    strcontent = re.Replace(strcontent, "<object classid=clsid:166b1bca-3f9c-11cf-8075-444553540000 codebase=http://download.macromedia.com/pub/shockwave/cabs/director/sw.cab#version=7,0,2,0 width=$1 height=$2><param name=src value=$3><embed src=$3 pluginspage=http://www.macromedia.com/shockwave/download/ width=$1 height=$2></embed></object>")
  End If
  If InStr(1, strcontent, "[/qt]", 1) > 0 Then
    re.Pattern = "\[qt=*([0-9]*),*([0-9]*)\](.[^\[]*)\[\/qt]"
    strcontent = re.Replace(strcontent, "<embed src=$3 width=$1 height=$2 autoplay=true loop=false controller=true playeveryframe=false cache=false scale=tofit bgcolor=#000000 kioskmode=false targetcache=false pluginspage=http://www.apple.com/quicktime/>")
  End If
  If InStr(1, strcontent, "[/mp]", 1) > 0 Then
    re.Pattern = "\[mp=*([0-9]*),*([0-9]*)\](.[^\[]*)\[\/mp]"
    strcontent = re.Replace(strcontent, "<object align=middle classid=clsid:22d6f312-b0f6-11d0-94ab-0080c74c7e95 class=object id=mediaplayer width=$1 height=$2 ><param name=showstatusbar value=-1><param name=filename value=$3><embed type=application/x-oleobject codebase=http://activex.microsoft.com/activex/controls/mplayer/en/nsmp2inf.cab#version=5,1,52,701 flename=mp src=$3  width=$1 height=$2></embed></object>")
  End If
  If spopedom = 1 Then
    If InStr(1, strcontent, "[/rm]", 1) > 0 Then
      re.Pattern = "\[rm=*([0-9]*),*([0-9]*)\](.[^\[]*)\[\/rm]"
      strcontent = re.Replace(strcontent, "<object classid=clsid:cfcdaa03-8be4-11cf-b84b-0020afbbccfa class=object id=raocx width=$1 height=$2><param name=src value=$3><param name=console value=clip1><param name=controls value=imagewindow><param name=autostart value=true></object><br><object classid=clsid:cfcdaa03-8be4-11cf-b84b-0020afbbccfa height=32 id=video2 width=$1><param name=src value=$3><param name=autostart value=-1><param name=controls value=controlpanel><param name=console value=clip1></object>")
    End If
    If InStr(1, strcontent, "[/flash]", 1) > 0 Then
      re.Pattern = "\[flash=*([0-9]*),*([0-9]*)\](.[^\[]*)\[\/flash\]"
      strcontent = re.Replace(strcontent, "<script type=""text/javascript"">writeFlashHTML2(""_version=8,0,0,0"" ,""_swf=$3"", ""_width=$1"", ""_height=$2"", ""_quality=high"");</script>")
    End If
  End If
  If InStr(1, strcontent, "[/url]", 1) > 0 Then
    re.Pattern = "(\[url\])(.[^\[]*)(\[\/url\])"
    strcontent = re.Replace(strcontent, "<a href=""$2"" target=_blank>$2</a>")
    re.Pattern = "(\[url=(.[^\]]*)\])(.[^\[]*)(\[\/url\])"
    strcontent = re.Replace(strcontent, "<a href=""$2"" target=_blank>$3</a>")
  End If
  If InStr(1, strcontent, "[/email]", 1) > 0 Then
    re.Pattern = "(\[email\])(.[^\[]*)(\[\/email\])"
    strcontent = re.Replace(strcontent, "<a href=""mailto:$2"">$2</a>")
    re.Pattern = "(\[email=(.[^\[]*)\])(.[^\[]*)(\[\/email\])"
    strcontent = re.Replace(strcontent, "<a href=""mailto:$2"">$3</a>")
  End If
  If InStr(1, strcontent, "http://", 1) > 0 Then
    re.Pattern = "^(http://[a-za-z0-9\./=\?%\-&_;~`@':+!]+)"
    strcontent = re.Replace(strcontent, "<a target=_blank href=$1>$1</a>")
    re.Pattern = "(http://[a-za-z0-9\./=\?%\-&_;~`@':+!]+)$"
    strcontent = re.Replace(strcontent, "<a target=_blank href=$1>$1</a>")
    re.Pattern = "([^>=""])(http://[a-za-z0-9\./=\?%\-&_;~`@':+!]+)"
    strcontent = re.Replace(strcontent, "$1<a target=_blank href=$2>$2</a>")
  End If
  If InStr(1, strcontent, "ftp://", 1) > 0 Then
    re.Pattern = "^(ftp://[a-za-z0-9\./=\?%\-&_;~`@':+!]+)"
    strcontent = re.Replace(strcontent, "<a target=_blank href=$1>$1</a>")
    re.Pattern = "(ftp://[a-za-z0-9\./=\?%\-&_;~`@':+!]+)$"
    strcontent = re.Replace(strcontent, "<a target=_blank href=$1>$1</a>")
    re.Pattern = "([^>=""])(ftp://[a-za-z0-9\.\/=\?%\-&_;~`@':+!]+)"
    strcontent = re.Replace(strcontent, "$1<a target=_blank href=$2>$2</a>")
  End If
  If InStr(1, strcontent, "rtsp://", 1) > 0 Then
    re.Pattern = "^(rtsp://[a-za-z0-9\./=\?%\-&_;~`@':+!]+)"
    strcontent = re.Replace(strcontent, "<a target=_blank href=$1>$1</a>")
    re.Pattern = "(rtsp://[a-za-z0-9\./=\?%\-&_;~`@':+!]+)$"
    strcontent = re.Replace(strcontent, "<a target=_blank href=$1>$1</a>")
    re.Pattern = "([^>=""])(rtsp://[a-za-z0-9\.\/=\?%\-&_;~`@':+!]+)"
    strcontent = re.Replace(strcontent, "$1<a target=_blank href=$2>$2</a>")
  End If
  If InStr(1, strcontent, "mms://", 1) > 0 Then
    re.Pattern = "^(mms://[a-za-z0-9\./=\?%\-&_;~`@':+!]+)"
    strcontent = re.Replace(strcontent, "<a target=_blank href=$1>$1</a>")
    re.Pattern = "(mms://[a-za-z0-9\./=\?%\-&_;~`@':+!]+)$"
    strcontent = re.Replace(strcontent, "<a target=_blank href=$1>$1</a>")
    re.Pattern = "([^>=""])(mms://[a-za-z0-9\.\/=\?%\-&_;~`@':+!]+)"
    strcontent = re.Replace(strcontent, "$1<a target=_blank href=$2>$2</a>")
  End If
  If InStr(1, strcontent, "[/color]", 1) > 0 Then
    re.Pattern = "(\[color=(.[^\[]*)\])(.[^\[]*)(\[\/color\])"
    strcontent = re.Replace(strcontent, "<font color=$2>$3</font>")
  End If
  If InStr(1, strcontent, "[/face]", 1) > 0 Then
    re.Pattern = "(\[face=(.[^\[]*)\])(.[^\[]*)(\[\/face\])"
    strcontent = re.Replace(strcontent, "<font face=$2>$3</font>")
  End If
  If InStr(1, strcontent, "[/align]", 1) > 0 Then
    re.Pattern = "(\[align=(.[^\[]*)\])(.[^\[]*)(\[\/align\])"
    strcontent = re.Replace(strcontent, "<div align=$2>$3</div>")
  End If
  If InStr(1, strcontent, "[/fly]", 1) > 0 Then
    re.Pattern = "(\[fly\])(.[^\[]*)(\[\/fly\])"
    strcontent = re.Replace(strcontent, "<marquee width=90% behavior=alternate scrollamount=3>$2</marquee>")
  End If
  If InStr(1, strcontent, "[/move]", 1) > 0 Then
    re.Pattern = "(\[move\])(.[^\[]*)(\[\/move\])"
    strcontent = re.Replace(strcontent, "<marquee scrollamount=3>$2</marquee>")
  End If
  If InStr(1, strcontent, "[/glow]", 1) > 0 Then
    re.Pattern = "\[glow=*([0-9]*),*(#*[a-z0-9]*),*([0-9]*)\](.[^\[]*)\[\/glow]"
    strcontent = re.Replace(strcontent, "<table width=$1 style=""filter:glow(color=$2, strength=$3)"">$4</table>")
  End If
  If InStr(1, strcontent, "[/shadow]", 1) > 0 Then
    re.Pattern = "\[shadow=*([0-9]*),*(#*[a-z0-9]*),*([0-9]*)\](.[^\[]*)\[\/shadow]"
    strcontent = re.Replace(strcontent, "<table width=$1 style=""filter:shadow(color=$2, strength=$3)"">$4</table>")
  End If
  If InStr(1, strcontent, "[/i]", 1) > 0 Then
    re.Pattern = "(\[i\])(.[^\[]*)(\[\/i\])"
    strcontent = re.Replace(strcontent, "<i>$2</i>")
  End If
  If InStr(1, strcontent, "[/u]", 1) > 0 Then
    re.Pattern = "(\[u\])(.[^\[]*)(\[\/u\])"
    strcontent = re.Replace(strcontent, "<u>$2</u>")
  End If
  If InStr(1, strcontent, "[/b]", 1) > 0 Then
    re.Pattern = "(\[b\])(.[^\[]*)(\[\/b\])"
    strcontent = re.Replace(strcontent, "<b>$2</b>")
  End If
  If InStr(1, strcontent, "[/size]", 1) > 0 Then
    re.Pattern = "(\[size=1\])(.[^\[]*)(\[\/size\])"
    strcontent = re.Replace(strcontent, "<font size=1>$2</font>")
    re.Pattern = "(\[size=2\])(.[^\[]*)(\[\/size\])"
    strcontent = re.Replace(strcontent, "<font size=2>$2</font>")
    re.Pattern = "(\[size=3\])(.[^\[]*)(\[\/size\])"
    strcontent = re.Replace(strcontent, "<font size=3>$2</font>")
    re.Pattern = "(\[size=4\])(.[^\[]*)(\[\/size\])"
    strcontent = re.Replace(strcontent, "<font size=4>$2</font>")
  End If
  If InStr(1, strcontent, "[/center]", 1) > 0 Then
    re.Pattern = "(\[center\])(.[^\[]*)(\[\/center\])"
    strcontent = re.Replace(strcontent, "<center>$2</center>")
  End If
  If InStr(1, strcontent, "[/list]", 1) > 0 Then
    strcontent = docode(strcontent, "[list]", "[/list]", "<ul>", "</ul>")
    strcontent = docode(strcontent, "[list=1]", "[/list]", "<ol type=1>", "</ol id=1>")
    strcontent = docode(strcontent, "[list=a]", "[/list]", "<ol type=a>", "</ol id=a>")
  End If
  If InStr(1, strcontent, "[/*]", 1) > 0 Then
    strcontent = docode(strcontent, "[*]", "[/*]", "<li>", "</li>")
  End If
  If InStr(1, strcontent, "[/code]", 1) > 0 Then
    strcontent = docode(strcontent, "[code]", "[/code]", "<table cellpadding=""5"" cellspacing=""1"" border=""0"" width=""96%"" class=""quote"" align=""center""><tr><td class=""ash""><i>", "</i></td></tr></table>")
  End If
  If InStr(1, strcontent, "[em]", 1) > 0 Then
    re.Pattern = "(\[em\])(.[^\[]*)(\[\/em\])"
    strcontent = re.Replace(strcontent, "<img src=""{$global.images}em/$2.gif"" border=""0"">")
  End If
  Dim isquote: isquote = True
  Dim isqi
  Do While isquote
    If InStr(1, strcontent, "[/quote]", 1) > 0 Then
      re.Pattern = "(\[quote\])(.[^\[]*)(\[\/quote\])"
      strcontent = re.Replace(strcontent, "<table cellpadding=""5"" cellspacing=""1"" border=""0"" width=""96%"" class=""quote"" align=""center""><tr><td>$2</td></tr></table>")
    End If
    If isqi >= 10 Or InStr(1, strcontent, "[/quote]", 1) = 0 Then isquote = False
    isqi = isqi + 1
  Loop
  Set re = Nothing
  ubbcode = strcontent
End Function

Function docode(ByVal fstring, ByVal fotag, ByVal fctag, ByVal frotag, ByVal frctag)
  Dim fotagpos, fctagpos
  fotagpos = InStr(1, fstring, fotag, 1)
  fctagpos = InStr(1, fstring, fctag, 1)
  While (fctagpos > 0 And fotagpos > 0)
    fstring = Replace(fstring, fotag, frotag, 1, 1, 1)
    fstring = Replace(fstring, fctag, frctag, 1, 1, 1)
    fotagpos = InStr(1, fstring, fotag, 1)
    fctagpos = InStr(1, fstring, fctag, 1)
  Wend
  docode = fstring
End Function
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
%>
