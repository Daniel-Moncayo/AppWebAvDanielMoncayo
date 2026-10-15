<!--#include file="../includes/core.asp"-->
<%
RequiereLogin
Dim id, raw, parts, i, nextValue, liked
id = IdSeguro(Request.QueryString("id"))
liked = False
raw = Session("PM_Favoritos") & ""

If id > 0 Then
    If Request.QueryString("toggle") = "0" Then
        nextValue = ""
        parts = Split(raw, ",")
        For i = 0 To UBound(parts)
            If parts(i) <> "" Then
                If CLng(parts(i)) <> id Then
                    If nextValue <> "" Then nextValue = nextValue & ","
                    nextValue = nextValue & parts(i)
                End If
            End If
        Next
        Session("PM_Favoritos") = nextValue
        liked = False
    Else
        parts = Split(raw, ",")
        For i = 0 To UBound(parts)
            If parts(i) <> "" Then
                If CLng(parts(i)) = id Then liked = True
            End If
        Next
        If Not liked Then
            If raw <> "" Then raw = raw & ","
            Session("PM_Favoritos") = raw & id
            liked = True
        End If
    End If
End If
JsonOut True, """liked"":" & LCase(CStr(liked))
%>
