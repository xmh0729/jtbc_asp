<%
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
Class imgwhinfo
  Dim aso
  Private Sub class_initialize()
    Set aso = server.CreateObject("adodb.stream")
    aso.mode = 3
    aso.Type = 1
    aso.open
  End Sub

  Private Sub class_terminate()
    Err.Clear
    Set aso = Nothing
  End Sub

  Private Function bin2str(ByVal bin)
    Dim i, str
    For i = 1 To LenB(bin)
      clow = MidB(bin, i, 1)
      If AscB(clow) < 128 Then
        str = str & Chr(AscB(clow))
      Else
        i = i + 1
        If i <= LenB(bin) Then str = str & Chr(AscW(MidB(bin, i, 1) & clow))
      End If
    Next
    bin2str = str
  End Function

  Private Function num2str(ByVal num, ByVal base, ByVal lens)
    Dim ret
    ret = ""
    While (num >= base)
      ret = (num Mod base) & ret
      num = (num - num Mod base) / base
    Wend
    num2str = Right(String(lens, "0") & num & ret, lens)
  End Function

  Private Function str2num(ByVal str, ByVal base)
    Dim ret, i
    ret = 0
    For i = 1 To Len(str)
      ret = ret * base + CInt(Mid(str, i, 1))
     Next
    str2num = ret
  End Function

  Private Function binval(ByVal bin)
    Dim ret, i
    ret = 0
    For i = LenB(bin) To 1 Step -1
      ret = ret * 256 + AscB(MidB(bin, i, 1))
    Next
    binval = ret
  End Function

  Private Function binval2(ByVal bin)
    Dim ret, i
    ret = 0
    For i = 1 To LenB(bin)
      ret = ret * 256 + AscB(MidB(bin, i, 1))
    Next
    binval2 = ret
  End Function

  Private Function getimagesize(ByVal filespec)
    Dim bflag
    Dim ret(3)
    aso.loadfromfile (filespec)
    bflag = aso.read(3)
    Select Case Hex(binval(bflag))
      Case "4e5089":
        aso.read (15)
        ret(0) = "png"
        ret(1) = binval2(aso.read(2))
        aso.read (2)
        ret(2) = binval2(aso.read(2))
      Case "464947":
        aso.read (3)
        ret(0) = "gif"
        ret(1) = binval(aso.read(2))
        ret(2) = binval(aso.read(2))
      Case "535746":
        aso.read (5)
        bindata = aso.read(1)
        sconv = num2str(AscB(bindata), 2, 8)
        nbits = str2num(Left(sconv, 5), 2)
        sconv = Mid(sconv, 6)
        While (Len(sconv) < nbits * 4)
          bindata = aso.read(1)
          sconv = sconv & num2str(AscB(bindata), 2, 8)
        Wend
        ret(0) = "swf"
        ret(1) = Int(Abs(str2num(Mid(sconv, 1 * nbits + 1, nbits), 2) - str2num(Mid(sconv, 0 * nbits + 1, nbits), 2)) / 20)
        ret(2) = Int(Abs(str2num(Mid(sconv, 3 * nbits + 1, nbits), 2) - str2num(Mid(sconv, 2 * nbits + 1, nbits), 2)) / 20)
      Case "ffd8ff":
        Do
        Do: p1 = binval(aso.read(1)): Loop While p1 = 255 And Not aso.eos
        If p1 > 191 And p1 < 196 Then Exit Do Else aso.read (binval2(aso.read(2)) - 2)
        Do: p1 = binval(aso.read(1)): Loop While p1 < 255 And Not aso.eos
        Loop While True
        aso.read (3)
        ret(0) = "jpg"
        ret(2) = binval2(aso.read(2))
        ret(1) = binval2(aso.read(2))
      Case Else:
        If Left(bin2str(bflag), 2) = "bm" Then
          aso.read (15)
          ret(0) = "bmp"
          ret(1) = binval(aso.read(4))
          ret(2) = binval(aso.read(4))
        Else
          ret(0) = ""
        End If
    End Select
    ret(3) = "width=""" & ret(1) & """ height=""" & ret(2) & """"
    getimagesize = ret
  End Function

  Public Function imgw(ByVal imgpath)
    Dim fso, imgfile, fileext, arr
    Set fso = server.CreateObject("scripting.filesystemobject")
    If (fso.fileexists(imgpath)) Then
      Set imgfile = fso.getfile(imgpath)
      fileext = fso.getextensionname(imgpath)
      Select Case fileext
        Case "gif", "bmp", "jpg", "png":
          arr = getimagesize(imgfile.Path)
          imgw = arr(1)
      End Select
      Set imgfile = Nothing
    Else
      imgw = 0
    End If
    Set fso = Nothing
  End Function

  Public Function imgh(ByVal imgpath)
    Dim fso, imgfile, fileext, arr
    Set fso = server.CreateObject("scripting.filesystemobject")
    If (fso.fileexists(imgpath)) Then
      Set imgfile = fso.getfile(imgpath)
      fileext = fso.getextensionname(imgpath)
      Select Case fileext
        Case "gif", "bmp", "jpg", "png":
          arr = getimagesize(imgfile.Path)
          imgh = arr(2)
      End Select
      Set imgfile = Nothing
    Else
      imgh = 0
    End If
    Set fso = Nothing
  End Function
End Class

Function get_picwh(ByVal purl, ByVal ptype)
  On Error Resume Next
  Dim chpic
  Set chpic = New imgwhinfo
  If ptype = "w" then
    get_picwh = chpic.imgw(server.mappath(purl))
  Else
    get_picwh = chpic.imgh(server.mappath(purl))
  End If
  Set chpic = nothing
End Function
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
%>
