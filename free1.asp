<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3c.org/TR/1999/REC-html401-19991224/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" slick-uniqueid="3"><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8"><meta content="IE=7.0000" http-equiv="X-UA-Compatible">
<!--#include file="common/incfiles/inc.asp"-->
<!--#include file="common/incfiles/md5.asp"-->
<% Dim nckcode: nckcode = md5(format_date(Now(),2)&"jetiben",2) %>
<title>免费户型分析</title>
<meta content="IE=7.0000" http-equiv="X-UA-Compatible">
<meta name="keywords" content="免费在线户型解析">
<meta name="description" content="免费户型分析">
<meta name="author" content="">
<style type="text/css">BODY {
	PADDING-BOTTOM: 0px; MARGIN: 0px; PADDING-LEFT: 0px; PADDING-RIGHT: 0px; FONT: 14px/24px "宋体",Arial; COLOR: #000000; PADDING-TOP: 0px
}
OL {
	LIST-STYLE-TYPE: none
}
UL {
	LIST-STYLE-TYPE: none
}
LI {
	LIST-STYLE-TYPE: none
}
DT {
	LIST-STYLE-TYPE: none
}
DD {
	LIST-STYLE-TYPE: none
}
DL {
	LIST-STYLE-TYPE: none
}
IMG {
	BORDER-RIGHT-WIDTH: 0px; BORDER-TOP-WIDTH: 0px; BORDER-BOTTOM-WIDTH: 0px; BORDER-LEFT-WIDTH: 0px
}
SELECT {
	VERTICAL-ALIGN: middle
}
INPUT {
	VERTICAL-ALIGN: middle
}
A:link {
	FONT-FAMILY: "宋体",Arial; COLOR: #000; TEXT-DECORATION: none
}
A:visited {
	FONT-FAMILY: "宋体",Arial; COLOR: #000; TEXT-DECORATION: none
}
A:hover {
	COLOR: #f00; TEXT-DECORATION: underline
}
A:active {
	COLOR: #f00; TEXT-DECORATION: underline
}
INPUT {
	CURSOR: pointer
}
BUTTON {
	CURSOR: pointer
}
.cRed {
	COLOR: #ff0000
}
A.cRed {
	COLOR: #ff0000
}
A.cRed:visited {
	COLOR: #ff0000
}
.cBlue {
	COLOR: #006783
}
A.cBlue {
	COLOR: #006783
}
A.cBlue:visited {
	COLOR: #006783
}
.cDRed {
	COLOR: #8b0016
}
A.cDRed {
	COLOR: #8b0016
}
A.cDRed:visited {
	COLOR: #8b0016
}
.cGray {
	COLOR: #333333
}
A.cGray {
	COLOR: #333333
}
A.cGray:visited {
	COLOR: #333333
}
.cDGray {
	COLOR: #666666
}
A.cDGray {
	COLOR: #666666
}
A.cDGray:visited {
	COLOR: #666666
}
.cWhite {
	COLOR: #ffffff
}
A.cWhite {
	COLOR: #ffffff
}
A.cWhite:visited {
	COLOR: #ffffff
}
.cBlack {
	COLOR: #000000
}
A.cBlack {
	COLOR: #000000
}
A.cBlack:visited {
	COLOR: #000000
}
.cGreen {
	COLOR: #008000
}
A.cGreen {
	COLOR: #008000
}
A.cGreen:visited {
	COLOR: #008000
}
.cYellow {
	COLOR: #ff6600
}
A.cYellow {
	COLOR: #ff6600
}
A.cYellow:visited {
	COLOR: #ff6600
}
.fb {
	FONT-WEIGHT: bold
}
.f12 {
	FONT-SIZE: 12px
}
.f14 {
	FONT-SIZE: 14px
}
.fno {
	FONT-WEIGHT: normal
}
.f20 {
	LINE-HEIGHT: 30px; FONT-FAMILY: "微软雅黑"; FONT-SIZE: 20px
}
.f36 {
	LINE-HEIGHT: 40px; FONT-FAMILY: "微软雅黑"; FONT-SIZE: 36px
}
.left {
	FLOAT: left
}
.right {
	FLOAT: right
}
DIV.hr {
	BORDER-BOTTOM: #ccc 1px dotted; PADDING-BOTTOM: 0px; MARGIN: 5px 0px; PADDING-LEFT: 0px; PADDING-RIGHT: 0px; HEIGHT: 1px; OVERFLOW: hidden; PADDING-TOP: 0px
}
DIV.hr HR {
	DISPLAY: none
}
.mt5 {
	MARGIN-TOP: 5px
}
.mb5 {
	MARGIN-BOTTOM: 5px
}
.mt10 {
	MARGIN-TOP: 10px
}
.mr10 {
	MARGIN-RIGHT: 10px
}
.mb10 {
	MARGIN-BOTTOM: 10px
}
.ml10 {
	MARGIN-LEFT: 10px
}
.pt10 {
	PADDING-TOP: 10px
}
.pr10 {
	PADDING-RIGHT: 10px
}
.pb10 {
	PADDING-BOTTOM: 10px
}
.pl10 {
	PADDING-LEFT: 10px
}
.m10 {
	MARGIN: 10px
}
.p10 {
	PADDING-BOTTOM: 10px; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; PADDING-TOP: 10px
}
#container {
	MARGIN: 0px auto; WIDTH: 950px
}
#footer IFRAME {
	WIDTH: 950px; HEIGHT: 90px
}
#topHeader {
	HEIGHT: auto
}
#topHeader H1 IMG {
	WIDTH: 950px; HEIGHT: 250px
}
#topHeader A {
	PADDING-BOTTOM: 0px; PADDING-LEFT: 15px; PADDING-RIGHT: 15px; DISPLAY: block; COLOR: #fff; FONT-SIZE: 14px; FONT-WEIGHT: bold; PADDING-TOP: 0px
}
#topHeader A:hover {
	BACKGROUND: #fff; COLOR: #000
}
#topHeader UL {
	LINE-HEIGHT: 30px; PADDING-LEFT: 20px; BACKGROUND: #cc9a67; HEIGHT: 30px
}
#topHeader UL LI {
	TEXT-ALIGN: center; FLOAT: left; MARGIN-RIGHT: 10px
}
#topHeader .current {
	BORDER-BOTTOM-COLOR: #ab7640; BORDER-LEFT: #ab7640 2px solid; LINE-HEIGHT: 28px; BACKGROUND: #fff; BORDER-BOTTOM-WIDTH: 2px; COLOR: #067acd; FONT-SIZE: 14px; BORDER-TOP: #ab7640 2px solid; FONT-WEIGHT: bold; BORDER-RIGHT: #ab7640 2px solid
}
UL.newslist12px {
	
}
UL.newslist14px {
	
}
UL.newslist12px LI {
	LINE-HEIGHT: 23px; FONT-SIZE: 12px
}
UL.newslist12px LI A {
	LINE-HEIGHT: 23px; FONT-SIZE: 12px
}
UL.newslist14px LI {
	LINE-HEIGHT: 24px; FONT-SIZE: 14px
}
UL.newslist14px LI A {
	LINE-HEIGHT: 24px; FONT-SIZE: 14px
}
.headerInfo {
	HEIGHT: auto
}
.headerInfo H2 {
	TEXT-ALIGN: center; MARGIN-BOTTOM: 5px
}
.headerInfo H2 A:link {
	FONT: bold 18px/27px 宋体; COLOR: #cc0000
}
.headerInfo H2 A:visited {
	FONT: bold 18px/27px 宋体; COLOR: #cc0000
}
.headerInfo P {
	TEXT-ALIGN: left; TEXT-INDENT: 2em
}
DL.img_tex {
	MARGIN: 0px auto
}
DL.img_tex DT {
	MARGIN-BOTTOM: 5px; FLOAT: left; MARGIN-LEFT: 7px; MARGIN-RIGHT: 7px
}
DL.img_tex DT B {
	TEXT-ALIGN: center; PADDING-BOTTOM: 1px; PADDING-LEFT: 1px; WIDTH: auto; PADDING-RIGHT: 1px; DISPLAY: block; PADDING-TOP: 1px
}
DL.img_tex DT SPAN {
	TEXT-ALIGN: center; LINE-HEIGHT: 30px; DISPLAY: block; FONT-SIZE: 12px; FONT-WEIGHT: normal
}
.border1px {
	BORDER-BOTTOM: #cccccc 1px solid; BORDER-LEFT: #cccccc 1px solid; PADDING-BOTTOM: 20px; PADDING-LEFT: 20px; PADDING-RIGHT: 20px; BORDER-TOP: #cccccc 1px solid; BORDER-RIGHT: #cccccc 1px solid; PADDING-TOP: 20px
}
.btn {
	BORDER-BOTTOM: 2px solid; BORDER-LEFT: 2px solid; PADDING-BOTTOM: 10px; BACKGROUND-COLOR: #339900; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; DISPLAY: block; FLOAT: left; COLOR: #fff; BORDER-TOP: 2px solid; MARGIN-RIGHT: 10px; BORDER-RIGHT: 2px solid; PADDING-TOP: 10px
}
A.btn {
	COLOR: #fff; FONT-SIZE: 14px; FONT-WEIGHT: bold
}
.btna {
	BORDER-BOTTOM-COLOR: #ff6666; BORDER-TOP-COLOR: #ff6666; BACKGROUND: #cc3333; BORDER-RIGHT-COLOR: #ff6666; BORDER-LEFT-COLOR: #ff6666
}
.btnb {
	BORDER-BOTTOM-COLOR: #ff9966; BORDER-TOP-COLOR: #ff9966; BACKGROUND: #cc6633; BORDER-RIGHT-COLOR: #ff9966; BORDER-LEFT-COLOR: #ff9966
}
.btna:hover {
	BORDER-BOTTOM-COLOR: #ff3300; BORDER-TOP-COLOR: #ff3300; BACKGROUND: #ff6600; BORDER-RIGHT-COLOR: #ff3300; BORDER-LEFT-COLOR: #ff3300
}
.btnb:hover {
	BORDER-BOTTOM-COLOR: #ff3300; BORDER-TOP-COLOR: #ff3300; BACKGROUND: #ff6600; BORDER-RIGHT-COLOR: #ff3300; BORDER-LEFT-COLOR: #ff3300
}
.dot {
	BORDER-LEFT: #ccc 1px dotted; OVERFLOW: hidden
}
.dotb {
	BORDER-BOTTOM: #c76610 1px dotted; OVERFLOW: hidden
}
.bor {
	BORDER-BOTTOM: #ff7800 3px dotted; BORDER-LEFT: #ff7800 3px dotted; OVERFLOW: hidden; BORDER-TOP: #ff7800 3px dotted; BORDER-RIGHT: #ff7800 3px dotted
}
.flashNews {
	POSITION: relative; TEXT-ALIGN: left; WIDTH: 480px; OVERFLOW: hidden
}
.firstNews {
	BORDER-BOTTOM: #b6cae3 1px solid; POSITION: relative; BORDER-LEFT: #b6cae3 1px solid; WIDTH: 480px; MARGIN-BOTTOM: 10px; FLOAT: right; OVERFLOW: hidden; BORDER-TOP: #b6cae3 1px solid; BORDER-RIGHT: #b6cae3 1px solid
}
.flashNews {
	HEIGHT: 330px
}
.firstNews {
	HEIGHT: 330px
}
.flashNews .bg {
	POSITION: absolute; WIDTH: 480px; BOTTOM: 0px; HEIGHT: 40px; LEFT: 0px
}
#SwitchTitle H3 {
	DISPLAY: none
}
#SwitchTitle {
	TEXT-ALIGN: center; PADDING-BOTTOM: 0px; LINE-HEIGHT: 30px; PADDING-LEFT: 10px; WIDTH: 400px; PADDING-RIGHT: 10px; HEIGHT: 30px; OVERFLOW: hidden; PADDING-TOP: 0px
}
#SwitchTitle A:link {
	COLOR: #000000; FONT-WEIGHT: bold
}
#SwitchTitle A:visited {
	COLOR: #000000; FONT-WEIGHT: bold
}
#SwitchTitle A:hover {
	COLOR: #ff0000; TEXT-DECORATION: none
}
.firstNews P A {
	FONT-SIZE: 12px
}
.flashNews UL {
	Z-INDEX: 2; POSITION: absolute; PADDING-LEFT: 47px; BOTTOM: 0px; RIGHT: 0px; _padding-left: 46px
}
.flashNews UL LI {
	TEXT-ALIGN: center; LINE-HEIGHT: 18px; WIDTH: 15px; BACKGROUND: #000000; FLOAT: left; HEIGHT: 18px; MARGIN-LEFT: 1px
}
.flashNews UL LI A {
	WIDTH: 15px; DISPLAY: block; FONT-FAMILY: Tahoma; HEIGHT: 18px; COLOR: #ffffff; FONT-SIZE: 10px; FONT-WEIGHT: bold
}
.flashNews UL LI A:hover {
	COLOR: #f20000
}
.flashNews UL LI A.sel {
	COLOR: #f20000
}
.firstNews UL {
	MARGIN: 0px 0px 0px 12px; WIDTH: 314px; HEIGHT: auto; OVERFLOW: hidden; _zoom: 1
}
.firstNews UL LI {
	POSITION: relative; LINE-HEIGHT: 30px; TEXT-INDENT: 10px; WIDTH: 300px; HEIGHT: 30px; FONT-SIZE: 14px; OVERFLOW: hidden
}
.flashNews UL LI A:visited {
	COLOR: #ffffff
}
.flashNews UL LI A.sel:link {
	BACKGROUND: #ff0000; COLOR: #fff
}
.flashNews UL LI A.sel:visited {
	BACKGROUND: #ff0000; COLOR: #fff
}
.flashNews UL LI A.sel:hover {
	BACKGROUND: #ff0000; COLOR: #fff
}
.bor1 {
	BORDER-BOTTOM: #4e84e5 1px dotted; BORDER-LEFT: #4e84e5 1px dotted; OVERFLOW: hidden; BORDER-TOP: #4e84e5 1px dotted; BORDER-RIGHT: #4e84e5 1px dotted
}
.STYLE1 {
	COLOR: #ff0033
}
.STYLE2 {
	FONT-SIZE: 16px; FONT-WEIGHT: bold
}
</style>

<meta name="GENERATOR" content="MSHTML 8.00.6001.19088"><style type="text/css"></style></head>
<body>
<div id="container">
<table id="__01" width="950" height="249" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td colspan="7">
			<img src="images/huxing1.png" width="950" height="196" alt=""></td>
	</tr>
	<tr>
		<td>	
			<img src="images/huxing2.png" width="584" height="53" alt=""></td>
		<td>
			<a href="/product/?type=list&classid=18"><img src="images/huxing3.png" width="72" height="53" alt=""></a></td>
		<td>
			<img src="images/huxing4.png" width="9" height="53" alt=""></td>
		<td>
			<a href="/knowledge/?type=list&classid=17"><img src="images/huxing5.png" width="71" height="53" alt=""></a></td>
		<td>
			<img src="images/huxing6.png" width="15" height="53" alt=""></td>
		<td>
			<a href="/product/?type=list&classid=2"><img src="images/huxing7.png" width="76" height="53" alt=""></a></td>
		<td>
			<img src="images/huxing8.png" width="123" height="53" alt=""></td>
	</tr>
</table>
<table border="0" cellspacing="15" cellpadding="0" width="950" bgcolor="#ffffcc"><tbody>
  <tr valign="top">

    <td valign="top">
      <table class="dotb mb10" border="0" cellspacing="0" cellpadding="5">
        <tbody>
        <tr>
          <td><!--begin 1849832-41628-1-->
            <center>
            <table border="0" cellspacing="0" cellpadding="0" width="100%">
              <tbody>
              <tr>
				<td  align="middle">
                  <center><span style="FONT-SIZE: 18px"><font color="#ff0000"><strong>户型免费设计</strong></font></span></center>您若有针对您户型的免费设计需求，建议您留下邮箱，我们将及时与您联系</td>
                <td  height="35" align="middle">
                  <center><span style="FONT-SIZE: 18px"><font color="#ff0000"><strong>大户型免费解析受追捧 
                  设计专属HOUSE华风来帮忙</strong></font></span></center></td></tr>
              <tr>
			  				<td  height="150" style="background:transparent;"><iframe allowtransparency="true" scrolling="no" style="background-color:transparent" src="/support/gbook/?type=addfree&nckcode=<%=nckcode%>" frameborder="0" height="250" width="300"></iframe></td>
                <td valign="top" align="left"><p style="LINE-HEIGHT: 24px;padding-left:40px;" class="1">&nbsp;&nbsp;&nbsp; 
                  新家乔迁之喜，手握户型图的你是否暗自发愁？每天为工作奔波的你，是否没有时间去了解自己家的户型，甚至还不道自己的家会装修成什么样子？尤其是大户型装修，更多了宏观的繁琐和细节的捕捉。到底怎样让居室更完美，怎么搭配才能成为我们心中理想的“价位”？一切答案都在华风公益户型解析活动中为您解答！<br>&nbsp;&nbsp;&nbsp; 
                  </p></td></tr></tbody></table></center><!--end 1849832-41628-1--></td></tr></tbody></table>
 
<table class="mb10" border="0" cellspacing="0" cellpadding="0" width="950">
  <tbody>
  <tr valign="top">
    <td>
      <table border="0" cellspacing="0" cellpadding="0" width="500" background="./images/tbg.jpg" height="45"><tbody>
        <tr>
          <td width="60">&nbsp;</td>
          <td class="cDRed"><span class="cRed">♥</span><strong class="cYellow"><strong></strong>&nbsp;公司简介</strong></td></tr></tbody></table>
      <table class="bor" border="0" cellspacing="10" cellpadding="0" width="500" background="./images/bg1.jpg" bgcolor="#ffffcc">
        <tbody>
        <tr valign="top">
          <td valign="top" align="middle">
            <center>
            <table border="0" cellspacing="0" cellpadding="0" width="98%">
              <tbody>
              <tr>
                <td height="26" align="middle">
                  <center><span style="FONT-SIZE: 14px"><font color="#b60500"><strong>东易日盛装饰青岛分公司</strong></font></span></center></td></tr>
              <tr>
                <td valign="top" align="left"><span style="LINE-HEIGHT: 21px" class="f12">&nbsp;&nbsp;&nbsp;&nbsp;“东易日盛” 创建于 
                  1996年，在中国家居产业已形成规模化、专业化、品牌化、集团化、产业化的绝对领先优势 
                  。东易日盛于2001年落户青岛，成立东易日盛装饰青岛分公司，在青岛九年时间，服务过小区近百个，客户两千余户，在业内和客户心中形成了良好的形象和口碑。东易日盛青岛分公司现拥有原创国际别墅设计中心、东易日盛装饰设计中心，旨在为广大业主提供包括别墅、大户型在内的整体家装解决方案。在八级质量保证体系的保驾护航下，在五大非常优势的坚强后盾下，东易日盛将在终极家装的道路上越走越远。<a href="http://house.qingdaonews.com/gb/content/2011-07/01/content_8842668.htm" target="_blank">...[全文]</a></span></td></tr></tbody></table></center><!--end 1849834-41629-1--></td></tr></tbody></table></td>
    <td width="440">
      <table border="0" cellspacing="0" cellpadding="0" width="440" background="./images/tbg.jpg" height="45"><tbody>
        <tr>
          <td width="60">&nbsp;</td>
          <td class="cDRed"><strong><strong><strong><span class="cRed">♠</span> 
            <span class="cYellow">设计师介绍</span></strong></strong></strong></td></tr></tbody></table>
      <table class="bor" border="0" cellspacing="10" cellpadding="0" width="440" background="./images/bg1.jpg">
        <tbody>
        <tr valign="top">
          <td valign="top" align="middle"><!--begin 1849835-41630-1--><img src="./images/984be1c32a140f77692a19.jpg" width="160" height="173"><!--end 1849835-41630-1--></td>
          <td valign="top" align="middle"><!--begin 1849836-41630-1-->
            <center>
            <table border="0" cellspacing="0" cellpadding="0" width="98%">
              <tbody>
              <tr>
                <td height="26" align="middle">
                  <center><span style="FONT-SIZE: 14px"><font color="#b60500"><strong>设计师：XXXX</strong></font></span></center></td></tr>
              <tr>
                <td valign="top" align="left"><span style="LINE-HEIGHT: 21px" class="f12">&nbsp;&nbsp; XXXX
                  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX<a href="#" target="_blank">...[全文]</a></span></td></tr></tbody></table></center><!--end 1849836-41630-1--></td></tr></tbody></table></td></tr></tbody></table>
<table border="0" cellspacing="0" cellpadding="0" width="950" background="./images/tbg.jpg" height="45">
  <tbody>
  <tr>
    <td width="60">&nbsp;</td>	
    <td class="cDRed"><strong><strong><strong><span class="cRed">♣</span> <span class="cYellow">户型解析回顾</span></strong></strong></strong></td></tr></tbody></table>
<table class="bor" border="0" cellspacing="10" cellpadding="0" width="950" background="./images/bg.jpg">
  <tbody>
  <tr valign="top">
    <td valign="top" width="460" align="middle">
      <table border="0" cellspacing="10" cellpadding="0" align="center">
        <tbody>
        <tr>
          <td valign="top"><!--begin 1849837-41631-1--><img src="/product/common/upload/2014/7/25/10550NI.jpg" width="200" height="160"><!--end 1849837-41631-1--></td>
          <td valign="top"><!--begin 1849838-41631-1-->
            <center>
            <table border="0" cellspacing="0" cellpadding="0" width="100%">
              <tbody>
              <tr>
                <td height="30" align="middle">
                  <center><span style="FONT-SIZE: 14px"><font color="#456e0e"><strong>网友qiao1234的户型分析</strong></font></span></center></td></tr>
              <tr>
                <td valign="top" align="left"><span style="LINE-HEIGHT: 21px" class="f12">设计师解析：对原有卫生间做重新布局后，合理安排功能结构，将洗手盆设计在卫生间外面，避免卫生间过于拥挤，二是考虑到业主早上上班时间在使用卫生间时候发生冲突。餐厅面积不大，在这里设计了省空间的卡座，冰箱放进卡座与墙之间的角落<a href="/product/?type=detail&id=11" target="_blank">...[全文]</a></span></td></tr></tbody></table></center><!--end 1849838-41631-1--></td></tr></tbody></table></td>
    <td valign="top" align="middle">
      <table border="0" cellspacing="10" cellpadding="0" align="center">
        <tbody>
        <tr>
          <td valign="top"><!--begin 1849839-41631-1--><img src="/product/common/upload/2014/7/25/111125oj.jpg" width="200" height="160"><!--end 1849839-41631-1--></td>
          <td valign="top"><!--begin 1849840-41631-1-->
            <center>
            <table border="0" cellspacing="0" cellpadding="0" width="100%">
              <tbody>
              <tr>
                <td height="30" align="middle">
                  <center><span style="FONT-SIZE: 14px"><font color="#456e0e"><strong>网友welcome的户型分析</strong></font></span></center></td></tr>
              <tr>
                <td valign="top" align="left"><span style="LINE-HEIGHT: 21px" class="f12">设计师解析：设计师首先考虑的，就是空间分配和使用功能问题，尽可能的把空间的利用率提升到最大。由于入户门与餐厅密不可分，所以两个功能性空间要合并考虑。设计师首先在门边做了到顶的鞋柜，上面用来挂外套下面是鞋柜。<a href="/product/?type=detail&id=12" target="_blank">...[全文]</a></span></td></tr></tbody></table></center><!--end 1849840-41631-1--></td></tr></tbody></table></td></tr>
</tbody></table>




</div>



 



</body></html>