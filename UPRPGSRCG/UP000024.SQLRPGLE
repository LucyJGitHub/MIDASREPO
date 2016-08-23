     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2015')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP Update T_UDFDEF with core field')             *
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP000024 - Update T_UDFDEF with core field                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2015            *
      *                                                               *
      *  Last Amend No. MD034724   *CREATE   Date 13Jun15             *
      *  Prev Amend No. xxxxxx             Date ddMmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD034724 - New method to restore libraries.                  *
      *                                                               *
      *****************************************************************
      *
     D PTable          S             10A
     D PKeyFld         S             10A
     D PFldText        S             50A
     D PDataType       S             10A
     D PType           S             10A
     D PFormat         S             50A
     D PKeyPos         S              6A
     D PRtnFlag        S              1A
      *
     D XMLData         S                   SQLTYPE(CLOB:99999)
     D UpdateData      S          99999A
     D CR              S              1A
     D B16             S             16A   INZ('                ')
     D B20             S             20A   INZ('                    ')
     D B24             S             24A   INZ('                        ')
     D KeyStr          S           1000A
     D FormatStr       S            100A
     D FoundPos        S              4  0
     D StartPos        S              4  0
     D StartKey        S              4  0
     D KeyCount        S              6  0
     D RestPos         S              4  0
     D SearchStr       S           1000A
     D SearchLen       S              3  0
     D XMLLen          S              4  0
      *
     D                 DS
     D KeyPosA                 1      6
     D KeyPosN                 1      6  0
      *
     C     *ENTRY        PLIST
     C                   PARM                    PTable
     C                   PARM                    PKeyFld
     C                   PARM                    PFldText
     C                   PARM                    PDataType
     C                   PARM                    PType
     C                   PARM                    PFormat
     C                   PARM                    PKeyPos
     C                   PARM                    PRtnFlag
      *
     C                   IF        PKeyPos <> '*FIRST'
     C                             and PKeyPos <> '*LAST'
     C                   EVAL      KeyPosA = PKeyPos
     C                   ELSE
     C                   IF        PKeyPos = '*FIRST'
     C                   EVAL      KeyPosN = 1
     C                   ELSE
     C                   EVAL      KeyPosN = 999999
     C                   ENDIF
     C                   ENDIF
      *
     C/exec SQL
     C+ declare UDFDEF cursor for
     C+ select
     C+   UDFXML
     C+ from T_UDFDEF
     C+ where
     C+ UDFDD = :PTable
     C/end-exec
      *
     C/exec SQL
     C+ open UDFDEF
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from UDFDEF
     C+ into :XMLData
     C/end-exec
      *
     C                   DOW       SQLCODE = 0
      *
      ** Retrieve the 'carriage return' character.
     C                   EVAL      FoundPos = %SCAN('<dataTables>':XMLData_Data)
     C                   EVAL      CR = %SUBST(XMLData_Data:(FoundPos + 12):1)
      *
      ** Build the key string to be inserted.
     C                   EXSR      BuildKey
      *
     C                   EVAL      UpdateData = *blanks
     C                   EXSR      UpdateKey
      ** Set the number of keys.
     C                   EVAL      KeyPosN = KeyCount
     C                   EXSR      UpdateFld
      *
      ** Once the new key data has been inserted then add the rest of the XML
      **  string.  Re-use StartPos to store field length.
     C                   EVAL      StartPos = %LEN(%TRIMR(UpdateData))
     C                   EVAL      UpdateData = %TRIMR(UpdateData) +
     C                             %SUBST(XMLData_Data:RestPos: +
     C                             (8000 - StartPos))
     C                   EVAL      XMLData_Data = UpdateData
     C                   EVAL      XMLData_Len = %LEN(%TRIMR(XMLData_Data))
      *
     C/exec SQL
     C+ update T_UDFDEF
     C+ set
     C+   UDFXML = :XMLData
     C+ where current of UDFDEF
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from UDFDEF
     C+ into :XMLData
     C/end-exec
      *
     C                   ENDDO
      *
     C/exec SQL
     C+ close UDFDEF
     C/end-exec
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      *    BuildKey - Build the key string to be inserted.            *
      *                                                               *
      *****************************************************************
      *
     C     BuildKey      BEGSR
      *
     C                   EVAL      KeyStr = CR + B16 + '<field>' +
     C                             CR + B20 + '<name>' +
     C                             PKeyFld
     C                   EVAL      KeyStr = %TRIMR(KeyStr) +
     C                             '</name>' + CR + B20 + '<description>' +
     C                             PFldText
     C                   EVAL      KeyStr = %TRIMR(KeyStr) +
     C                             '</description>' + CR + B20 + '<dbField>' +
     C                             PKeyFld
     C                   EVAL      KeyStr = %TRIMR(KeyStr) +
     C                             '</dbField>' + CR + B20 +
     C                             '<unique>Y</unique>' + CR + B20 +
     C                             '<mandatory>N</mandatory>' + CR + B20 +
     C                             '<preventInput>N</preventInput>' + CR + B20 +
     C                             '<zones/>' + CR + B20 +
     C                             '<switchableFeature/>' + CR + B20 +
     C                             '<datatype>' +
     C                             PDataType
     C                   EVAL      KeyStr = %TRIMR(KeyStr) +
     C                             '</datatype>' + CR + B20 +
     C                             '<format>' + CR + B24 + '<type>' +
     C                             PType
      ** Format the format string depending on value passed in.
     C                   EXSR      FmtFormat
     C                   EVAL      KeyStr = %TRIMR(KeyStr) +
     C                             '</type>' + CR + B24 + FormatStr
     C                   EVAL      KeyStr = %TRIMR(KeyStr) + CR + B20 +
     C                             '</format>' + CR + B16 +
     C                             '</field>'
      *
     C     BuildKeyE     ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *    FmtFormat - Format the format string.                      *
      *                                                               *
      *****************************************************************
      *
     C     FmtFormat     BEGSR
      *
      ** Check for 'length'.
     C                   EVAL      FoundPos = %SCAN('length':PFormat)
     C                   IF        FoundPos > 0
      ** Find the position of the end of the key.
     C                   EVAL      FormatStr = PFormat
     C                   ENDIF
      *
      ** Check for 'scale'.
     C                   EVAL      FoundPos = %SCAN('<scale>':PFormat)
     C                   IF        FoundPos > 0
     C                   EVAL      FormatStr = %TRIMR(%SUBST(PFormat:1: +
     C                             (FoundPos - 1)))
     C                   EVAL      FormatStr = %TRIMR(FormatStr) + CR + B24 +
     C                             %TRIMR(%SUBST(PFormat:FoundPos:17))
     C                   ENDIF
      *
     C     FmtFormatE    ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *    UpdateKey - Update primary key portion of XML.             *
      *                                                               *
      *****************************************************************
      *
     C     UpdateKey     BEGSR
      *
      ** Find the primary key portion of the XML.
     C                   EVAL      FoundPos = %SCAN('<primaryKey>':XMLData_Data)
     C                   EVAL      StartKey = FoundPos + 12
      ** Find the position of the end of the key.
     C                   EVAL      FoundPos = %SCAN('<':XMLData_Data:StartKey)
      ** Store the position start for the rest of the XML string.
     C                   EVAL      RestPos = FoundPos
     C                   EVAL      UpdateData = %SUBST(XMLData_Data:1:
     C                             (StartKey - 1))
      *
      ** Update SearchStr variable with list of key fields.
      **  Key field is in first position.
     C                   IF        KeyPosN = 1
     C                   EVAL      SearchStr = %TRIMR(PKeyFld) + ',' +
     C                             %SUBST(XMLData_Data:StartKey: +
     C                             (FoundPos - StartKey))
     C                   ELSE
      **  Key field is in last position.
     C                   IF        KeyPosN = 999999
     C                   EVAL      SearchStr = %TRIMR(%SUBST(XMLData_Data: +
     C                             StartKey:(FoundPos - StartKey))) + ',' +
     C                             PKeyFld
     C                   ELSE
      **  Key field is in a specified position.
     C                   EVAL      FoundPos = %SCAN(',':XMLData_Data:StartKey)
      ** If a ',' is not found then it means there is only one existing key
      **  field and the position will be last.
     C                   IF        FoundPos > RestPos
     C                             or FoundPos = 0
     C                   EVAL      SearchStr = %TRIMR(%SUBST(XMLData_Data: +
     C                             StartKey:(RestPos - StartKey))) + ',' +
     C                             PKeyFld
     C                   ELSE
     C                   EVAL      StartPos = StartKey
     C                   EVAL      KeyCount = 1
     C                   DOU       FoundPos > RestPos
     C                             or FoundPos = 0
     C                             or KeyCount = KeyPosN
     C                   EVAL      SearchStr = %TRIMR(SearchStr) +
     C                              %TRIMR(%SUBST(XMLData_Data: +
     C                             StartPos:(FoundPos - StartPos))) + ','
     C                   EVAL      StartPos = FoundPos + 1
     C                   EVAL      FoundPos = %SCAN(',':XMLData_Data:StartPos)
     C                   EVAL      KeyCount = KeyCount + 1
     C                   ENDDO
      ** Update SearchStr with the new key.
     C                   EVAL      SearchStr = %TRIMR(SearchStr) + PKeyFld
      ** Update SearchStr with the rest of the keys.
     C                   EVAL      SearchStr = %TRIMR(SearchStr) + ',' +
     C                             %TRIMR(%SUBST(XMLData_Data:StartPos: +
     C                             (RestPos - StartPos)))
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      ** Search the string of key fields to find the number of key fields.
     C                   EVAL      SearchLen = RestPos - StartKey
     C                   EVAL      KeyCount = 1
     C                   EVAL      StartPos = 1
     C                   DOU       FoundPos = 0
     C                   EVAL      FoundPos = %SCAN(',':SearchStr:StartPos)
     C                   IF        FoundPos <> 0
     C                   EVAL      StartPos = FoundPos + 1
     C                   EVAL      KeyCount = KeyCount + 1
     C                   ENDIF
      *
     C                   ENDDO
      *
     C     UpdateKeyE    ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *    UpdateFld - Update the field data.                         *
      *                                                               *
      *****************************************************************
      *
     C     UpdateFld     BEGSR
      *
      ** Look for the start of the fields.
     C                   EVAL      FoundPos = %SCAN('<fields>':XMLData_Data: +
     C                             RestPos)
     C                   EVAL      UpdateData = %TRIMR(UpdateData) +
     C                             %TRIMR(SearchStr) +
     C                             %SUBST(XMLData_Data:RestPos:
     C                             (FoundPos - RestPos + 8))
     C                   EVAL      RestPos = FoundPos + 8
      *
      ** Insert the new key at the end of the other key fields.
     C                   DO        KeyCount
     C                   EXSR      InsertOldKey
     C                   ENDDO
     C                   EVAL      UpdateData = %TRIMR(UpdateData) + KeyStr
      *
     C     UpdateFldE    ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *    InsertOldKey - Insert existing key field before inserting  *
      *                   new key.                                    *
      *                                                               *
      *****************************************************************
      *
     C     InsertOldKey  BEGSR
      *
      ** Look for the start of the individual field ...
     C                   EVAL      FoundPos = %SCAN('<field>':XMLData_Data: +
     C                             RestPos)
      ** ... and then look for the end for that field.
     C                   EVAL      FoundPos = %SCAN('</field>':XMLData_Data: +
     C                             RestPos)
      ** Update the string with that data and reset positions.
     C                   EVAL      UpdateData = %TRIMR(UpdateData) +
     C                             %SUBST(XMLData_Data:RestPos:
     C                             (FoundPos - RestPos + 8))
     C                   EVAL      RestPos = FoundPos + 8
      *
     C     InsertOldKeyE ENDSR
      *
      *****************************************************************
