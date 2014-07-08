<%
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
Dim file_stream

Class upload_class
  Dim Form, File
  Private Sub Class_Initialize()
    Dim file_stream_br, iBinaryRead
    Dim iStart, iFileNameStart, iFileNameEnd, iEnd, vbEnter, iFormStart, iFormEnd, theFile
    Dim strDiv, mFormName, mFormValue, mFileName, mFileSize, mFilePath, iDivLen, mStr, mReadText
    If Request.TotalBytes < 1 Then Exit Sub
    Set Form = CreateObject("Scripting.Dictionary")
    Set File = CreateObject("Scripting.Dictionary")
    iBinaryRead = Request.BinaryRead(Request.TotalBytes)
    set file_stream_br = CreateObject("Adodb.Stream")
    file_stream_br.Mode = 3
    file_stream_br.Type = 1
    file_stream_br.Open
    file_stream_br.Write iBinaryRead
    file_stream_br.Position = 0
    file_stream_br.Type = 2
    file_stream_br.Charset = "utf-8"
    mReadText = file_stream_br.ReadText
    set file_stream_br = Nothing
    Set file_stream = CreateObject("Adodb.Stream")
    file_stream.Mode = 3
    file_stream.Type = 1
    file_stream.Open
    file_stream.write iBinaryRead
    vbEnter = Chr(13) & Chr(10)
    iDivLen = inString(1, vbEnter) + 1
    strDiv = subString(1, iDivLen)
    iFormStart = iDivLen
    iFormEnd = inString(iFormStart, strDiv) - 1
    While iFormStart < iFormEnd
      iStart = inString(iFormStart, "name=""")
      iEnd = inString(iStart + 6, """")
      mFormName = subString(iStart + 6, iEnd - iStart - 6)
      iFileNameStart = inString(iEnd + 1, "filename=""")
      If iFileNameStart > 0 And iFileNameStart < iFormEnd Then
        iFileNameEnd = inString(iFileNameStart + 10, """")
        Dim mFileNameStartT, mFileNameEndT
        mFileNameStartT = InStr(mReadText, "filename=""") + 10
        mFileNameEndT = InStr(mFileNameStartT, mReadText, """")
        mFileName = Mid(mReadText, mFileNameStartT, mFileNameEndT - mFileNameStartT)
        iStart = inString(iFileNameEnd + 1, vbEnter & vbEnter)
        iEnd = inString(iStart + 4, vbEnter & strDiv)
        If iEnd > iStart Then
          mFileSize = iEnd - iStart - 4
        Else
          mFileSize = 0
        End If
        Set theFile = New Upload_FileInfo
        theFile.FileName = GetFileName(mFileName)
        theFile.FilePath = GetFilePath(mFileName)
        theFile.FileSize = mFileSize
        theFile.FileStart = iStart + 4
        theFile.FormName = mFormName
        File.Add mFormName, theFile
        Set theFile = Nothing
      Else
        iStart = inString(iEnd + 1, vbEnter & vbEnter)
        iEnd = inString(iStart + 4, vbEnter & strDiv)
        If iEnd > iStart Then
          mFormValue = subString(iStart + 4, iEnd - iStart - 4)
        Else
          mFormValue = ""
        End If
        Form.Add mFormName, mFormValue
      End If
      iFormStart = iFormEnd + iDivLen
      iFormEnd = inString(iFormStart, strDiv) - 1
    Wend
  End Sub

  Private Function subString(theStart, theLen)
    Dim i, c, stemp
    file_stream.position = theStart - 1
    stemp = ""
    For i = 1 To theLen
      If file_stream.EOS Then Exit For
      c = AscB(file_stream.Read(1))
      If c > 127 Then
        If file_stream.EOS Then Exit For
        stemp = stemp & ChrW(AscW(ChrB(AscB(file_stream.Read(1))) & ChrB(c)))
        i = i + 1
      Else
        stemp = stemp & ChrW(c)
      End If
    Next
    subString = stemp
  End Function

  Private Function inString(theStart, varStr)
    Dim i, j, bt, theLen, Str
    inString = 0
    Str = toByte(varStr)
    theLen = LenB(Str)
    For i = theStart To file_stream.Size - theLen
      If i > file_stream.Size Then Exit Function
      file_stream.position = i - 1
      If AscB(file_stream.Read(1)) = AscB(MidB(Str, 1)) Then
        inString = i
        For j = 2 To theLen
          If file_stream.EOS Then
            inString = 0
            Exit For
          End If
          If AscB(file_stream.Read(1)) <> AscB(MidB(Str, j, 1)) Then
            inString = 0
            Exit For
          End If
        Next
        If inString <> 0 Then Exit Function
      End If
    Next
  End Function

  Private Sub Class_Terminate()
    Form.RemoveAll
    File.RemoveAll
    Set Form = Nothing
    Set File = Nothing
    file_stream.Close
    Set file_stream = Nothing
  End Sub

  Private Function GetFilePath(FullPath)
    If FullPath <> "" Then
      GetFilePath = Left(FullPath, InStrRev(FullPath, "\"))
    Else
      GetFilePath = ""
    End If
  End Function

  Private Function GetFileName(FullPath)
    If FullPath <> "" Then
      GetFileName = Mid(FullPath, InStrRev(FullPath, "\") + 1)
    Else
      GetFileName = ""
    End If
  End Function

  Private Function toByte(Str)
    Dim i, iCode, c, iLow, iHigh
    toByte = ""
    For i = 1 To Len(Str)
      c = Mid(Str, i, 1)
      iCode = Asc(c)
      If iCode < 0 Then iCode = iCode + 65535
      If iCode > 255 Then
        iLow = Left(Hex(Asc(c)), 2)
        iHigh = Right(Hex(Asc(c)), 2)
        toByte = toByte & ChrB("&H" & iLow) & ChrB("&H" & iHigh)
      Else
        toByte = toByte & ChrB(AscB(c))
      End If
    Next
  End Function
End Class

Class Upload_FileInfo
  Dim FormName, FileName, FilePath, FileSize, FileStart
  Private Sub Class_Initialize()
    FileName = ""
    FilePath = ""
    FileSize = 0
    FileStart = 0
    FormName = ""
  End Sub

  Public Function SaveAs(FullPath)
    Dim dr, ErrorChar, i
    SaveAs = 1
    If Trim(FullPath) = "" Or FileSize = 0 Or FileStart = 0 Or FileName = "" Then Exit Function
    If FileStart = 0 Or Right(FullPath, 1) = "/" Then Exit Function
    Set dr = CreateObject("Adodb.Stream")
    dr.Mode = 3
    dr.Type = 1
    dr.Open
    file_stream.position = FileStart - 1
    file_stream.copyto dr, FileSize
    dr.SaveToFile FullPath, 2
    dr.Close
    Set dr = Nothing
    SaveAs = 0
  End Function
End Class
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
%>
