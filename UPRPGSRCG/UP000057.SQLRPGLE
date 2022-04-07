     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2020')
      *****************************************************************
/*XBIA*  OVRDBF FILE(UDFOLD) TOFILE(UPFFDSTPD)                        *
/*XBIB*  OVRDBF FILE(UDFNEW) TOFILE(UPFFDSTPD)                        *
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP ADBU Generate Script for SQL update')         *
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP000057 - Main program to build SQL string                  *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. MD059742             Date 23Mar22             *
      *  Prev Amend No. CUT017 *CREATE       Date 17Mar20             *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD059742 - Cope with change in Alternative field name        *
      *  CUT017 - Adaptive Database Upgrade                           *
      *                                                               *
      *****************************************************************

     D A1FLDI          S             10    DIM(9999)
     D A1FLDB          S              5  0 DIM(9999)
     D A1FLDD          S              2  0 DIM(9999)
     D A1FLDP          S              2  0 DIM(9999)
     D A1FTXT          S             50    DIM(9999)
     D A1CHD1          S             20    DIM(9999)
     D A1CHD2          S             20    DIM(9999)
     D A1CHD3          S             20    DIM(9999)
     D A1FLDT          S              1    DIM(9999)
     D A1NULL          S              1    DIM(9999)
     D A1DFT           S             30    DIM(9999)
     D A1VARL          S              1    DIM(9999)
     D A1ALIS          S             30    DIM(9999)

     D A2FLDI          S             10    DIM(9999)
     D A2FLDB          S              5  0 DIM(9999)
     D A2FLDD          S              2  0 DIM(9999)
     D A2FLDP          S              2  0 DIM(9999)
     D A2FTXT          S             50    DIM(9999)
     D A2CHD1          S             20    DIM(9999)
     D A2CHD2          S             20    DIM(9999)
     D A2CHD3          S             20    DIM(9999)
     D A2FLDT          S              1    DIM(9999)
     D A2NULL          S              1    DIM(9999)
     D A2DFT           S             30    DIM(9999)
     D A2VARL          S              1    DIM(9999)
     D A2ALIS          S             30    DIM(9999)

     D ARFLDI          S             10    DIM(9999)
     D ARFLDB          S              5  0 DIM(9999)
     D ARFLDD          S              2  0 DIM(9999)
     D ARFLDP          S              2  0 DIM(9999)
     D ARFTXT          S             50    DIM(9999)
     D ARCHD1          S             20    DIM(9999)
     D ARCHD2          S             20    DIM(9999)
     D ARCHD3          S             20    DIM(9999)
     D ARFLDT          S              1    DIM(9999)
     D ARNULL          S              1    DIM(9999)
     D ARDFT           S             30    DIM(9999)
     D ARVARL          S              1    DIM(9999)
     D ARALIS          S             30    DIM(9999)

     DTxtLine          DS
     D Txt                            1    DIM(100)
     DOutLine          DS
     D XOut                           1    DIM(100)
     D Idx             S              3  0
     D OIdx            S              3  0
     D XPos            S              3  0
     D lgth            S              3  0
     D LEAVE           S              1A
     D XSQL            S          32000A

     D  @DATA          DS
     D  @LEN                   1      5
     D  @LENn                  1      5  0

     D POldLib         S             10A
     D PNewLib         S             10A
     D PTable          S             10A
     D PRtnFlag        S              1A
     D Prefix          S              2A
      *
     D Library         S             10A
     D Outfile         S             10A
     D Format          S             50A
     D OFMbr           S             10A
     D OFMbrOpt        S              8A
     D Type            S             10A
     D DataType        S             10A
     D DataLen         S             10A
     D KeyPos          S              6A
     D SQLStr          S          32000A
     D SQLStr1         S          32000A
     D SQLStr2         S          32000A
     D Quote           S              1A   INZ('''')
     D Append          S              1A
     D #FLDNM          S             10A
     D #Field          S             10A
     D #Lib            S             10A
     D EndField        S             10A
     D Index           S              4  0
     D Idx1            S              4  0
     D Idx2            S              4  0
     D IID1            S              4  0
     D IID2            S              4  0
     D pos             S              2  0
     D l               S              2  0
     D wCHD            DS            60
     D  wCHD1                  1     20
     D  wCHD2                 21     40
     D  wCHD3                 41     60

     D/COPY ZACPYSRC,PSDS

     D FldData       E DS                  EXTNAME(UPFFDSTPD)
       /EJECT
      *****************************************************************
      *                                                               *
      *  MAIN PROCESSING                                              *
      *                                                               *
      *****************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    #File            10            File
     C                   PARM                    #Lib1            10            Library
     C                   PARM                    #Lib2            10            Library
     C                   PARM                    Mode              1            Mode
     C                   PARM                    Empty             1            Fiel is empty
     C                   PARM                    #SEQ             15 5          Sequence
     C                   PARM                    KEEP              1            Keep Bespoke

     C                   eval      Prefix = %SUBST(#Lib1:1:2)
      ** Call program to produce file field description outfile of old file.
     C                   EVAL      #Lib = #Lib1
     C                   EVAL      OutFile = 'UDFOLD'
     C                   EXSR      BldOutFile

     C                   EXSR      GetFields1

      ** Call program to produce file field description outfile of new file.
     C                   EVAL      #Lib = #Lib2
     C                   EVAL      OutFile = 'UDFOLD'
     C                   EXSR      BldOutFile

     C                   EXSR      GetFields2

      ** Compare all fields
     C                   EXSR      COMPARE

     C                   EVAL      *INLR = *ON
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      *    COMPARE - Compare fields                                   *
      *                                                               *
      *****************************************************************
      *
     C     COMPARE       BEGSR

     C                   EVAL      Idx1 = 1
     C                   EVAL      Idx2 = 1
     C                   EVAL      LEAVE = 'N'

      ** read all fields for new file
     C                   DOW       A2FLDI(Idx2) <> *BLANKS
     C                             and LEAVE = 'N'

     C                   SELECT
      ** all attributes are the same
     C                   WHEN      A1FLDI(Idx1) = A2FLDI(Idx2)
     C                             and A1FLDB(Idx1) = A2FLDB(Idx2)
     C                             and A1FLDD(Idx1) = A2FLDD(Idx2)
     C                             and A1FLDP(Idx1) = A2FLDP(Idx2)
     C                             and A1FTXT(Idx1) = A2FTXT(Idx2)
     C                             and A1CHD1(Idx1) = A2CHD1(Idx2)
     C                             and A1CHD2(Idx1) = A2CHD2(Idx2)
     C                             and A1CHD3(Idx1) = A2CHD3(Idx2)
     C                             and A1FLDT(Idx1) = A2FLDT(Idx2)
     C                             and A1NULL(Idx1) = A2NULL(Idx2)
     C                             and A1DFT(Idx1) = A2DFT(Idx2)
     C                             and A1VARL(Idx1) = A2VARL(Idx2)
     C                             and A1ALIS(Idx1) = A2ALIS(Idx2)
     C                   EVAL      Idx1 = Idx1 + 1
     C                   EVAL      Idx2 = Idx2 + 1

      ** field added at the bottom of the file
     C                   WHEN      A1FLDI(Idx1) = *BLANKS
     C                   EXSR      SrAddFieldB
     C                   EVAL      Idx1 = Idx1 + 1
     C                   EVAL      Idx2 = Idx2 + 1

      ** if field name is different, check if it is a rename or a new field
     C                   WHEN      A1FLDI(Idx1) <> A2FLDI(Idx2)
     C                             or A1ALIS(Idx1) <> A2ALIS(Idx2)                          MD059742
     C                   EVAL      #Field = A1FLDI(Idx1)
     C                   EXSR      SrRebuild
     C                   EVAL      Idx1 = Idx1 + 1
     C                   EVAL      Idx2 = Idx2 + 1


      ** field name/length is same but changed from num to char
     C                   WHEN      A1FLDI(Idx1) = A2FLDI(Idx2)
     C*                            and A1FLDB(Idx1) = A2FLDB(Idx2)
     C*                            and A1FLDD(Idx1) > 0
     C*                            and A2FLDD(Idx2) = 0
     C*                            and A1FLDT(Idx1) = 'S'
     C*                            and A2FLDT(Idx2) = 'A'
     C*                            and A1ECDE(Idx1) = 'X'
     C*                            and A2ECDE(Idx2) = ' '
     C                             and A1FLDB(Idx1) <> A2FLDB(Idx2)
     C                             or A1FLDI(Idx1) = A2FLDI(Idx2)
     C                             and A1FLDD(Idx1) <> A2FLDD(Idx2)
     C                             or A1FLDI(Idx1) = A2FLDI(Idx2)
     C                             and A1FLDB(Idx1) <> A2FLDB(Idx2)
     C                             or A1FLDI(Idx1) = A2FLDI(Idx2)
     C                             and A1FLDT(Idx1) <> A2FLDT(Idx2)
     C                             or A1FLDI(Idx1) = A2FLDI(Idx2)
     C                             and A1VARL(Idx1) <> A2VARL(Idx2)
     C                   EXSR      SrRebuild
     C                   EVAL      Idx1 = Idx1 + 1
     C                   EVAL      Idx2 = Idx2 + 1

      ** field length is changed (increase) but same name/type
     C                   WHEN      A1FLDB(Idx1) <> A2FLDB(Idx2)
     C                             and A1FLDB(Idx1) < A2FLDB(Idx2)
     C                             and A1FLDI(Idx1) = A2FLDI(Idx2)
     C*****                        and A1FLDD(Idx1) = A2FLDD(Idx2)
     C                             and A1FLDT(Idx1) = A2FLDT(Idx2)
     C                             or A1FLDB(Idx1) <> A2FLDB(Idx2)
     C                             and A1FLDB(Idx1) < A2FLDB(Idx2)
     C                             and A1FLDI(Idx1) = A2FLDI(Idx2)
     C                             and A1FLDT(Idx1) = 'P'
     C                             and A2FLDT(Idx2) = 'S'
     C*                            and A1ECDE(Idx1) = A2ECDE(Idx2)
      ** when field is now CLOB
     C                             or A1FLDB(Idx1) <> A2FLDB(Idx2)
     C                             and A1FLDI(Idx1) = A2FLDI(Idx2)
     C                             and A1FLDT(Idx1) = 'A'
     C                             and A2FLDT(Idx2) = '1'
     C                   EXSR      SrRebuild
     C                   EVAL      Idx1 = Idx1 + 1
     C                   EVAL      Idx2 = Idx2 + 1

      ** when field has a default
     C                   WHEN      A1FLDI(Idx1) = A2FLDI(Idx2)
     C                             and A1DFT(Idx1) <> A2DFT(Idx2)
     C                   EXSR      SrDefault
     C                   EVAL      Idx1 = Idx1 + 1
     C                   EVAL      Idx2 = Idx2 + 1

      ** field text is changed
     C                   WHEN      A1FLDI(Idx1) = A2FLDI(Idx2)
     C                             and A1FTXT(Idx1) <> A2FTXT(Idx2)
     C                   EXSR      SrChgTxt
     C                   EVAL      Idx1 = Idx1 + 1
     C                   EVAL      Idx2 = Idx2 + 1

      ** fields column heading
     C                   WHEN      A1FLDI(Idx1) = A2FLDI(Idx2)
     C                             and A1CHD1(Idx1) <> A2CHD1(Idx2)
     C                             or A1FLDI(Idx1) = A2FLDI(Idx2)
     C                             and A1CHD2(Idx1) <> A2CHD2(Idx2)
     C                             or A1FLDI(Idx1) = A2FLDI(Idx2)
     C                             and A1CHD3(Idx1) <> A2CHD3(Idx2)
     C                   EXSR      SrChgColHd
     C                   EVAL      Idx1 = Idx1 + 1
     C                   EVAL      Idx2 = Idx2 + 1

      ** field names are the same but type is now DBCS (e.g. CGCORRPD)
     C                   WHEN      A1FLDI(Idx1) = A2FLDI(Idx2)
     C                             and A1FLDT(Idx1) = 'A'
     C                             and A2FLDT(Idx2) = 'G'
      **** new pgm to call (also add WHPSUD in array???)
     C                   EVAL      Idx1 = Idx1 + 1
     C                   EVAL      Idx2 = Idx2 + 1

     C                   WHEN      A1FLDI(Idx1) = A2FLDI(Idx2)
     C                             and A1NULL(Idx1) <> A2NULL(Idx2)
     C                             and A2NULL(Idx2) = 'Y'
     C                   EXSR      SrChgNull
     C                   EVAL      Idx1 = Idx1 + 1
     C                   EVAL      Idx2 = Idx2 + 1

     C                   OTHER
     C                   DUMP
     C                   EVAL      Idx1 = Idx1 + 1
     C                   EVAL      Idx2 = Idx2 + 1

     C                   ENDSL
     C                   ENDDO

      ** if last field(s) was/were removed
     C                   If        A2FLDI(Idx2) =  *BLANKS
     C                             and A1FLDI(Idx1) <>  *BLANKS
     C                             and LEAVE = 'N'
     C                   exsr      SRDropFld
     C                   Endif

     C                   ENDSR

      /EJECT
      *****************************************************************
     C     SrChgColHd    BEGSR

     C                   EVAL      #SEQ = #SEQ +1
     C                   EVAL      SQLStr1 = *BLANKS
     C                   EVAL      #FLDNM = A2FLDI(Idx2)
      ** set column headings
     C                   EVAL      wCHD1 = A2CHD1(Idx2)
     C                   EVAL      wCHD2 = A2CHD2(Idx2)
     C                   EVAL      wCHD3 = A2CHD3(Idx2)
     C                   EVAL      SQLStr1 = 'label on column ' + %TRIMR(#Lib1)+
     C                             '/' + %TRIMR(#File) + ' (' + %TRIMR(#FLDNM) +
     C                             ' is ' + '''' + %TRIMR(wCHD) + ''''

     C                   EVAL      SQLStr1 = %TRIMR(SQLStr1) + ')'
     C                   If        Mode = 'U'
     C/exec SQL
     C+ execute immediate :SQLStr1
     C/end-exec
     C                   If        SQLCOD<*ZERO
     C                   EXSR      *PSSR
     C                   EndIf
     C                   ELSE
     C                   EVAL      XSQL = SQLStr1
     C/EXEC SQL
     C+ insert into UPGSCRTD
     C+ (
     C+   SCPRFX
     C+  ,SCFILE
     C+  ,SCLIB
     C+  ,SCSEQ
     C+  ,SCTYPE
     C+  ,SCCMTY
     C+  ,SCCDSH
     C+  ,SCDEPF
     C+  ,SCCDRN
     C+  ,SCCMD
     C+  ,SCOPGM
     C+ )
     C+ Values
     C+ (
     C+   :Prefix
     C+  ,:#FILE
     C+  ,:#Lib1
     C+  ,:#SEQ
     C+  ,'  '
     C+  ,'SQL'
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+  ,:XSQL
     C+  ,'UP000057'
     C+ )
     C/END-EXEC
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
     C     SrChgTxt      BEGSR

     C                   EVAL      #SEQ = #SEQ +1
     C                   EVAL      SQLStr2 = *BLANKS
     C                   EVAL      #FLDNM = A2FLDI(Idx2)
      ** set label headings
     C                   EVAL      SQLStr2 = 'label on column ' + %TRIMR(#Lib1)+
     C                             '/' + %TRIMR(#File) + ' (' + %TRIMR(#FLDNM) +
     C                             ' TEXT is ' + '''' + %TRIMR(A2FTXT(Idx2)) +
     C                             ''''

     C                   EVAL      SQLStr2 = %TRIMR(SQLStr2) + ')'
     C                   If        Mode = 'U'
     C/exec SQL
     C+ execute immediate :SQLStr2
     C/end-exec
     C                   If        SQLCOD<*ZERO
     C                   EXSR      *PSSR
     C                   EndIf
     C                   ELSE
     C                   EVAL      XSQL = SQLStr2
     C*                  WRITE     PHSQLLD0
     C/EXEC SQL
     C+ insert into UPGSCRTD
     C+ (
     C+   SCPRFX
     C+  ,SCFILE
     C+  ,SCLIB
     C+  ,SCSEQ
     C+  ,SCTYPE
     C+  ,SCCMTY
     C+  ,SCCDSH
     C+  ,SCDEPF
     C+  ,SCCDRN
     C+  ,SCCMD
     C+  ,SCOPGM
     C+ )
     C+ Values
     C+ (
     C+   :Prefix
     C+  ,:#FILE
     C+  ,:#Lib1
     C+  ,:#SEQ
     C+  ,'  '
     C+  ,'SQL'
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+  ,:XSQL
     C+  ,'UP000057'
     C+ )
     C/END-EXEC
     C                   ENDIF

      ** also check column heading
     C                   If        A1FLDI(Idx1) = A2FLDI(Idx2)
     C                             and A1CHD1(Idx1) <> A2CHD1(Idx2)
     C                             or A1FLDI(Idx1) = A2FLDI(Idx2)
     C                             and A1CHD2(Idx1) <> A2CHD2(Idx2)
     C                             or A1FLDI(Idx1) = A2FLDI(Idx2)
     C                             and A1CHD3(Idx1) <> A2CHD3(Idx2)
     C                   EXSR      SrChgColHd
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      *****************************************************************
     C     SrChgNull     BEGSR

      *
     C                   EVAL      #SEQ = #SEQ +1
     C                   EVAL      #FLDNM = A2FLDI(Idx2)
     C                   EVAL      SQLStr = *blanks
     C                   EVAL      SQLStr = 'alter table ' + %TRIMR(#Lib1) +
     C                             '/' + %TRIMR(#File) + ' ALTER COLUMN ' +
     C                             %TRIMR(#FLDNM) + ' DROP NOT NULL'
      *
     C                   If        Mode = 'U'
     C/exec SQL
     C+ execute immediate :SQLStr
     C/end-exec
     C                   If        SQLCOD<*ZERO
     C                   EXSR      *PSSR
     C                   EndIf
     C                   ELSE
     C                   EVAL      XSQL = SQLStr

     C/EXEC SQL
     C+ insert into UPGSCRTD
     C+ (
     C+   SCPRFX
     C+  ,SCFILE
     C+  ,SCLIB
     C+  ,SCSEQ
     C+  ,SCTYPE
     C+  ,SCCMTY
     C+  ,SCCDSH
     C+  ,SCDEPF
     C+  ,SCCDRN
     C+  ,SCCMD
     C+  ,SCOPGM
     C+ )
     C+ Values
     C+ (
     C+   :Prefix
     C+  ,:#FILE
     C+  ,:#Lib1
     C+  ,:#SEQ
     C+  ,'  '
     C+  ,'SQL'
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+  ,:XSQL
     C+  ,'UP000057'
     C+ )
     C/END-EXEC
     C                   ENDIF

     C                   ENDSR
      /EJECT
      *****************************************************************
      *****************************************************************
     C     SrDefault     BEGSR

     C                   EVAL      #SEQ = #SEQ +1
     C                   EVAL      #FLDNM = A2FLDI(Idx2)
     C                   EVAL      SQLStr = *blanks
     C                   If        A2FLDT(Idx2) = 'S'
     C                             or A2FLDT(Idx2) = 'P'
     C                   EVAL      SQLStr = 'alter table ' + %TRIMR(#Lib1) +
     C                             '/' + %TRIMR(#File) + ' ALTER COLUMN ' +
     C                             %TRIMR(#FLDNM) + ' SET DEFAULT ' +
     C                             %trimr(A2DFT(Idx2))
     C                   Else
     C                   EVAL      SQLStr = 'alter table ' + %TRIMR(#Lib1) +
     C                             '/' + %TRIMR(#File) + ' ALTER COLUMN ' +
     C                             %TRIMR(#FLDNM) + ' SET DEFAULT ' + '''' +
     C                             %trimr(A2DFT(Idx2))
     C                   Endif

     C                   If        Mode = 'U'
     C/exec SQL
     C+ execute immediate :SQLStr
     C/end-exec
     C                   If        SQLCOD<*ZERO
     C                   EXSR      *PSSR
     C                   EndIf
     C                   ELSE
     C                   EVAL      XSQL = SQLStr

     C/EXEC SQL
     C+ insert into UPGSCRTD
     C+ (
     C+   SCPRFX
     C+  ,SCFILE
     C+  ,SCLIB
     C+  ,SCSEQ
     C+  ,SCTYPE
     C+  ,SCCMTY
     C+  ,SCCDSH
     C+  ,SCDEPF
     C+  ,SCCDRN
     C+  ,SCCMD
     C+  ,SCOPGM
     C+ )
     C+ Values
     C+ (
     C+   :Prefix
     C+  ,:#FILE
     C+  ,:#Lib1
     C+  ,:#SEQ
     C+  ,'  '
     C+  ,'SQL'
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+  ,:XSQL
     C+  ,'UP000057'
     C+ )
     C/END-EXEC
     C                   ENDIF

     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *    FindBespFlds - Find bespoke fields on 'old' file.          *
      *                                                               *
      *****************************************************************
      *
     C     BldOutFile    BEGSR
      *
     C                   CALL      'UTC000004'
     C                   PARM                    #File
     C                   PARM                    #Lib
     C                   PARM                    OutFile
     C                   PARM      '*FIRST'      OFMbr
     C                   PARM      '*REPLACE'    OFMbrOpt
     C
      *
     C     BldOutFileE   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *    GetFields - Get all fields and store them in array         *
      *                                                               *
      *****************************************************************
      *
     C     GetFields1    BEGSR
      *
     C                   CLEAR                   A1FLDI
     C                   CLEAR                   A1FLDB
     C                   CLEAR                   A1FLDD
     C                   CLEAR                   A1FLDP
     C                   CLEAR                   A1FTXT
     C                   CLEAR                   A1CHD1
     C                   CLEAR                   A1CHD2
     C                   CLEAR                   A1CHD3
     C                   CLEAR                   A1FLDT
     C                   CLEAR                   A1NULL
     C                   CLEAR                   A1DFT
     C                   CLEAR                   A1VARL
     C                   CLEAR                   A1ALIS
     C                   EVAL      Index = 1
     C/exec SQL
     C+ declare GetFields1 cursor for
     C+ select *
     C+ from UDFOLD
     C/end-exec
      *
     C/exec SQL
     C+ open GetFields1
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from GetFields1
     C+ into :FldData
     C/end-exec
      *
     C                   DOW       SQLCODE = 0
      *
      ** Get until the fieldadd to the end of the table.
     C                   If        WHFLDI <> *BLANKS

     C                   EVAL      xpos = %SCAN(Quote:WHFTXT:1)
     C                   If        xpos > 0 and %subst(WHFTXT:xpos+1:1) <> Quote
     C                   eval      WHFTXT = %subst(WHFTXT:1:xpos) + Quote +
     C                             %subst(WHFTXT:xpos+1:50-xpos-1)
     C                   EVAL      xpos = %SCAN(Quote:WHFTXT:xpos+2)
     C                   If        xpos > 0 and %subst(WHFTXT:xpos+1:1) <> Quote
     C                   eval      WHFTXT = %subst(WHFTXT:1:xpos) + Quote +
     C                             %subst(WHFTXT:xpos+1:50-xpos-1)
     C                   EVAL      xpos = %SCAN(Quote:WHFTXT:xpos+2)
     C                   If        xpos > 0 and %subst(WHFTXT:xpos+1:1) <> Quote
     C                   eval      WHFTXT = %subst(WHFTXT:1:xpos) + Quote +
     C                             %subst(WHFTXT:xpos+1:50-xpos-1)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   EVAL      xpos = %SCAN(Quote:WHCHD1:1)
     C                   If        xpos > 0
     C                   eval      WHCHD1 = %subst(WHCHD1:1:xpos) + Quote +
     C                             %subst(WHCHD1:xpos+1:20-xpos-1)
     C                   EVAL      xpos = %SCAN(Quote:WHCHD1:xpos+2)
     C                   If        xpos > 0
     C                   eval      WHCHD1 = %subst(WHCHD1:1:xpos) + Quote +
     C                             %subst(WHCHD1:xpos+1:20-xpos-1)
     C                   EVAL      xpos = %SCAN(Quote:WHCHD1:xpos+2)
     C                   If        xpos > 0
     C                   eval      WHCHD1 = %subst(WHCHD1:1:xpos) + Quote +
     C                             %subst(WHCHD1:xpos+1:20-xpos-1)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   EVAL      xpos = %SCAN(Quote:WHCHD2:1)
     C                   If        xpos > 0
     C                   eval      WHCHD2 = %subst(WHCHD2:1:xpos) + Quote +
     C                             %subst(WHCHD2:xpos+1:20-xpos-1)
     C                   EVAL      xpos = %SCAN(Quote:WHCHD2:xpos+2)
     C                   If        xpos > 0
     C                   eval      WHCHD2 = %subst(WHCHD2:1:xpos) + Quote +
     C                             %subst(WHCHD2:xpos+1:20-xpos-1)
     C                   ENDIF
     C                   ENDIF

     C                   EVAL      xpos = %SCAN(Quote:WHCHD3:1)
     C                   If        xpos > 0
     C                   eval      WHCHD3 = %subst(WHCHD3:1:xpos) + Quote +
     C                             %subst(WHCHD3:xpos+1:20-xpos-1)
     C                   EVAL      xpos = %SCAN(Quote:WHCHD3:xpos+2)
     C                   If        xpos > 0
     C                   eval      WHCHD3 = %subst(WHCHD3:1:xpos) + Quote +
     C                             %subst(WHCHD3:xpos+1:20-xpos-1)
     C                   ENDIF
     C                   ENDIF

     C                   EVAL      A1FLDI(Index) = WHFLDI
     C                   EVAL      A1FLDB(Index) = WHFLDB
     C                   EVAL      A1FLDD(Index) = WHFLDD
     C                   EVAL      A1FLDP(Index) = WHFLDP
     C                   EVAL      A1FTXT(Index) = WHFTXT
     C                   EVAL      A1CHD1(Index) = WHCHD1
     C                   EVAL      A1CHD2(Index) = WHCHD2
     C                   EVAL      A1CHD3(Index) = WHCHD3
     C                   EVAL      A1FLDT(Index) = WHFLDT
     C                   EVAL      A1NULL(Index) = WHNULL
     C                   EVAL      A1DFT(Index) = WHDFT
     C                   if        WHDFT <> *BLANKS
     C                   EVAL      lgth = %len(%trimr(WHDFT))
     C                   EVAL      A1DFT(Index) = %trimr(%subst(WHDFT:2:lgth))
     C                   endif
     C                   EVAL      A1VARL(Index) = WHVARL
     C                   EVAL      A1ALIS(Index) = WHALIS
     C                   EVAL      Index = Index +1
     C                   ENDIF
      *
     C/exec SQL
     C+ fetch next
     C+ from GetFields1
     C+ into :FldData
     C/end-exec
      *
     C                   If        WHFLDI = *BLANKS
     C                   LEAVE
     C                   ENDIF

     C                   ENDDO
      *
     C/exec SQL
     C+ close GetFields1
     C/end-exec
      *
     C     GetField1E    ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *    GetFields - Get all fields and store them in array         *
      *                                                               *
      *****************************************************************
      *
     C     GetFields2    BEGSR
      *
     C                   CLEAR                   A2FLDI
     C                   CLEAR                   A2FLDB
     C                   CLEAR                   A2FLDD
     C                   CLEAR                   A2FLDP
     C                   CLEAR                   A2FTXT
     C                   CLEAR                   A2CHD1
     C                   CLEAR                   A2CHD2
     C                   CLEAR                   A2CHD3
     C                   CLEAR                   A2FLDT
     C                   CLEAR                   A2NULL
     C                   CLEAR                   A2DFT
     C                   CLEAR                   A2VARL
     C                   CLEAR                   A2ALIS
     C                   EVAL      Index = 1
     C/exec SQL
     C+ declare GetFields2 cursor for
     C+ select *
     C+ from UDFOLD
     C/end-exec
      *
     C/exec SQL
     C+ open GetFields2
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from GetFields2
     C+ into :FldData
     C/end-exec
      *
     C                   DOW       SQLCODE = 0
      *
      ** Get until the fieldadd to the end of the table.
     C                   If        WHFLDI <> *BLANKS

     C                   EVAL      xpos = %SCAN(Quote:WHFTXT:1)
     C                   If        xpos > 0 and %subst(WHFTXT:xpos+1:1) <> Quote
     C                   eval      WHFTXT = %subst(WHFTXT:1:xpos) + Quote +
     C                             %subst(WHFTXT:xpos+1:50-xpos-1)
     C                   EVAL      xpos = %SCAN(Quote:WHFTXT:xpos+2)
     C                   If        xpos > 0 and %subst(WHFTXT:xpos+1:1) <> Quote
     C                   eval      WHFTXT = %subst(WHFTXT:1:xpos) + Quote +
     C                             %subst(WHFTXT:xpos+1:50-xpos-1)
     C                   EVAL      xpos = %SCAN(Quote:WHFTXT:xpos+2)
     C                   If        xpos > 0 and %subst(WHFTXT:xpos+1:1) <> Quote
     C                   eval      WHFTXT = %subst(WHFTXT:1:xpos) + Quote +
     C                             %subst(WHFTXT:xpos+1:50-xpos-1)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   EVAL      xpos = %SCAN(Quote:WHCHD1:1)
     C                   If        xpos > 0
     C                   eval      WHCHD1 = %subst(WHCHD1:1:xpos) + Quote +
     C                             %subst(WHCHD1:xpos+1:20-xpos-1)
     C                   EVAL      xpos = %SCAN(Quote:WHCHD1:xpos+2)
     C                   If        xpos > 0
     C                   eval      WHCHD1 = %subst(WHCHD1:1:xpos) + Quote +
     C                             %subst(WHCHD1:xpos+1:20-xpos-1)
     C                   EVAL      xpos = %SCAN(Quote:WHCHD1:xpos+2)
     C                   If        xpos > 0
     C                   eval      WHCHD1 = %subst(WHCHD1:1:xpos) + Quote +
     C                             %subst(WHCHD1:xpos+1:20-xpos-1)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   EVAL      xpos = %SCAN(Quote:WHCHD2:1)
     C                   If        xpos > 0
     C                   eval      WHCHD2 = %subst(WHCHD2:1:xpos) + Quote +
     C                             %subst(WHCHD2:xpos+1:20-xpos-1)
     C                   EVAL      xpos = %SCAN(Quote:WHCHD2:xpos+2)
     C                   If        xpos > 0
     C                   eval      WHCHD2 = %subst(WHCHD2:1:xpos) + Quote +
     C                             %subst(WHCHD2:xpos+1:20-xpos-1)
     C                   ENDIF
     C                   ENDIF

     C                   EVAL      xpos = %SCAN(Quote:WHCHD3:1)
     C                   If        xpos > 0
     C                   eval      WHCHD3 = %subst(WHCHD3:1:xpos) + Quote +
     C                             %subst(WHCHD3:xpos+1:20-xpos-1)
     C                   EVAL      xpos = %SCAN(Quote:WHCHD3:xpos+2)
     C                   If        xpos > 0
     C                   eval      WHCHD3 = %subst(WHCHD3:1:xpos) + Quote +
     C                             %subst(WHCHD3:xpos+1:20-xpos-1)
     C                   ENDIF
     C                   ENDIF

     C                   EVAL      A2FLDI(Index) = WHFLDI
     C                   EVAL      A2FLDB(Index) = WHFLDB
     C                   EVAL      A2FLDD(Index) = WHFLDD
     C                   EVAL      A2FLDP(Index) = WHFLDP
     C                   EVAL      A2FTXT(Index) = WHFTXT
     C                   EVAL      A2CHD1(Index) = WHCHD1
     C                   EVAL      A2CHD2(Index) = WHCHD2
     C                   EVAL      A2CHD3(Index) = WHCHD3
     C                   EVAL      A2FLDT(Index) = WHFLDT
     C                   EVAL      A2NULL(Index) = WHNULL
     C                   EVAL      A2DFT(Index) = WHDFT
     C                   if        WHDFT <> *BLANKS
     C                   EVAL      lgth = %len(%trimr(WHDFT))
     C                   EVAL      A2DFT(Index) = %trimr(%subst(WHDFT:2:lgth))
     C                   endif
     C                   EVAL      A2VARL(Index) = WHVARL
     C                   EVAL      A2ALIS(Index) = WHALIS
     C                   EVAL      Index = Index +1
     C                   ENDIF
      *
     C/exec SQL
     C+ fetch next
     C+ from GetFields2
     C+ into :FldData
     C/end-exec
      *
     C                   If        WHFLDI = *BLANKS
     C                   LEAVE
     C                   ENDIF

     C                   ENDDO
      *
     C/exec SQL
     C+ close GetFields2
     C/end-exec
      *
     C     GetField2E    ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *    SrAddFieldB - Add new field at the bottom                  *
      *                                                               *
      *****************************************************************
      *
     C     SrAddFieldB   BEGSR
      *
     C                   EVAL      #SEQ = #SEQ +1
     C                   EVAL      #FLDNM = A2FLDI(Idx2)
     C                   EVAL      SQLStr = *blanks
     C                   EVAL      SQLStr1 = *blanks
     C                   EVAL      SQLStr2 = *blanks
     C                   EVAL      SQLStr = 'alter table ' + %TRIMR(#Lib1) +
     C                             '/' + %TRIMR(#File)
      *
     C                   SELECT
      *
     C                   WHEN      A2FLDT(Idx2) = 'A'
     C                   EVAL      DataType = 'char'
     C                   EVAL      DataLen = %TRIML(%EDITC(A2FLDB(Idx2):'3'))
     C                   If        A2VARL(Idx2) = 'Y'
     C                   EVAL      DataType = 'varchar'
     C                   ENDIF
      *
     C                   WHEN      A2FLDT(Idx2) = 'S'
     C                   EVAL      DataType = 'numeric'
     C                   EVAL      DataLen = %TRIML(%EDITC(A2FLDD(Idx2):'3'))
     C                   EVAL      DataLen = %TRIMR(DataLen) + ',' +
     C                             %TRIML(%EDITC(A2FLDP(Idx2):'3'))
      *
     C                   WHEN      A2FLDT(Idx2) = 'P'
     C                   EVAL      DataType = 'decimal'
     C                   EVAL      DataLen = %TRIML(%EDITC(A2FLDD(Idx2):'3'))
     C                   EVAL      DataLen = %TRIMR(DataLen) + ',' +
     C                             %TRIML(%EDITC(A2FLDP(Idx2):'3'))
      *
     C                   WHEN      A2FLDT(Idx2) = 'Z'
     C                   EVAL      DataType = 'TIMESTAMP'
     C                   EVAL      DataLen = *blanks

     C                   WHEN      A2FLDT(Idx2) = 'G'
     C                   EVAL      DataType = 'GRAPHIC'
     C                   EVAL      DataLen = %TRIML(%EDITC(A2FLDB(Idx2):'3'))

     C                   ENDSL

      * TIMESTAMP
     C                   If        DataType = 'TIMESTAMP'
     C                   If        A2ALIS(Idx2) = *blanks
     C                   EVAL      SQLStr = %TRIMR(SQLStr) +
     C                             ' add column ' +
     C                             %TRIMR(#FLDNM) + ' ' +  %TRIMR(DataType)
     C                   Else
     C                   EVAL      SQLStr = %TRIMR(SQLStr) +
     C                             ' add column ' +  %TRIMR(A2ALIS(Idx2)) +
     C                             ' for column ' +
     C                             %TRIMR(#FLDNM) + ' ' +  %TRIMR(DataType)
     C                   Endif
     C                   ELSE
      * GRAPHIC
     C                   If        DataType = 'GRAPHIC'
     C                   If        A2ALIS(Idx2) = *blanks
     C                   EVAL      SQLStr = %TRIMR(SQLStr) +
     C                             ' add column ' +
     C                             %TRIMR(#FLDNM) + ' ' +  %TRIMR(DataType) +
     C                             ' (' + %TRIMR(DataLen) + ')' +
     C                             ' CCSID 1200 '
     C                   Else
     C                   EVAL      SQLStr = %TRIMR(SQLStr) +
     C                             ' add column ' +  %TRIMR(A2ALIS(Idx2)) +
     C                             ' for column ' +
     C                             %TRIMR(#FLDNM) + ' ' +  %TRIMR(DataType) +
     C                             ' (' + %TRIMR(DataLen) + ')' +
     C                             ' CCSID 1200 '
     C                   Endif
     C                   ELSE
      * else ...
     C                   If        A2ALIS(Idx2) = *blanks
     C                   EVAL      SQLStr = %TRIMR(SQLStr) +
     C                             ' add column ' +
     C                             %TRIMR(#FLDNM) + ' ' +  %TRIMR(DataType) +
     C                             ' (' + %TRIMR(DataLen) + ')'
     C                   Else
     C                   EVAL      SQLStr = %TRIMR(SQLStr) +
     C                             ' add column ' +  %TRIMR(A2ALIS(Idx2)) +
     C                             ' for column ' +
     C                             %TRIMR(#FLDNM) + ' ' +  %TRIMR(DataType) +
     C                             ' (' + %TRIMR(DataLen) + ')'
     C                   Endif
     C                   ENDIF
     C                   ENDIF
     C                   IF        A2NULL(Idx2) = 'N'
     C                   EVAL      SQLStr = %TRIMR(SQLStr) +
     C                             ' not null with default'
     C                   IF        A2DFT(Idx2) <> *BLANKS
     C                   If        DataType = 'decimal'
     C                             or DataType = 'numeric'
     C                   EVAL      SQLStr = %TRIMR(SQLStr) + ' ' +
     C                             %trimr(A2DFT(Idx2))
     C                   else
     C                   EVAL      SQLStr = %TRIMR(SQLStr) + ' ' +
     C                             '''' + %trimr(A2DFT(Idx2))
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF


      ** set column headings
     C                   EVAL      wCHD1 = A2CHD1(Idx2)
     C                   EVAL      wCHD2 = A2CHD2(Idx2)
     C                   EVAL      wCHD3 = A2CHD3(Idx2)
     C                   EVAL      SQLStr1 = 'label on column ' + %TRIMR(#Lib1)+
     C                             '/' + %TRIMR(#File) + ' (' + %TRIMR(#FLDNM) +
     C                             ' is ' + '''' + %TRIMR(wCHD) + ''''

      ** set label headings
     C                   EVAL      SQLStr2 = 'label on column ' + %TRIMR(#Lib1)+
     C                             '/' + %TRIMR(#File) + ' (' + %TRIMR(#FLDNM) +
     C                             ' TEXT is ' + '''' + %TRIMR(A2FTXT(Idx2)) +
     C                             ''''

     C                   ADD       1             Idx2
     C                   DOW       A2FLDI(Idx2) <> *BLANKS
     C                   EVAL      #FLDNM = A2FLDI(Idx2)
     C
     C                   SELECT
      *
     C                   WHEN      A2FLDT(Idx2) = 'A'
     C                   EVAL      DataType = 'char'
     C                   EVAL      DataLen = %TRIML(%EDITC(A2FLDB(Idx2):'3'))
      *
     C                   WHEN      A2FLDT(Idx2) = 'S'
     C                   EVAL      DataType = 'numeric'
     C                   EVAL      DataLen = %TRIML(%EDITC(A2FLDD(Idx2):'3'))
     C                   EVAL      DataLen = %TRIMR(DataLen) + ',' +
     C                             %TRIML(%EDITC(A2FLDP(Idx2):'3'))
      *
     C                   WHEN      A2FLDT(Idx2) = 'P'
     C                   EVAL      DataType = 'decimal'
     C                   EVAL      DataLen = %TRIML(%EDITC(A2FLDD(Idx2):'3'))
     C                   EVAL      DataLen = %TRIMR(DataLen) + ',' +
     C                             %TRIML(%EDITC(A2FLDP(Idx2):'3'))
      *
     C                   WHEN      A2FLDT(Idx2) = 'Z'
     C                   EVAL      DataType = 'TIMESTAMP'
     C                   EVAL      DataLen = *blanks

     C                   WHEN      A2FLDT(Idx2) = 'G'
     C                   EVAL      DataType = 'GRAPHIC'
     C                   EVAL      DataLen = %TRIML(%EDITC(A2FLDB(Idx2):'3'))

     C                   ENDSL

      * TIMESTAMP
     C                   If        DataType = 'TIMESTAMP'
     C                   If        A2ALIS(Idx2) = *blanks
     C                   EVAL      SQLStr = %TRIMR(SQLStr) +
     C                             ' add column ' +
     C                             %TRIMR(#FLDNM) + ' ' +  %TRIMR(DataType)
     C                   Else
     C                   EVAL      SQLStr = %TRIMR(SQLStr) +
     C                             ' add column ' + %TRIMR(A2ALIS(Idx2)) +
     C                             ' for column ' +
     C                             %TRIMR(#FLDNM) + ' ' +  %TRIMR(DataType)
     C                   Endif
     C                   ELSE
      * GRAPHIC
     C                   If        DataType = 'GRAPHIC'
     C                   If        A2ALIS(Idx2) = *blanks
     C                   EVAL      SQLStr = %TRIMR(SQLStr) +
     C                             ' add column ' +
     C                             %TRIMR(#FLDNM) + ' ' +  %TRIMR(DataType) +
     C                             ' (' + %TRIMR(DataLen) + ')' +
     C                             ' CCSID 1200 '
     C                   Else
     C                   EVAL      SQLStr = %TRIMR(SQLStr) +
     C                             ' add column ' +  %TRIMR(A2ALIS(Idx2)) +
     C                             ' for column ' +
     C                             %TRIMR(#FLDNM) + ' ' +  %TRIMR(DataType) +
     C                             ' (' + %TRIMR(DataLen) + ')' +
     C                             ' CCSID 1200 '
     C                   Endif
     C                   ELSE
      * else ...
     C                   If        A2ALIS(Idx2) = *blanks
     C                   EVAL      SQLStr = %TRIMR(SQLStr) +
     C                             ' add column ' +
     C                             %TRIMR(#FLDNM) + ' ' +  %TRIMR(DataType) +
     C                             ' (' + %TRIMR(DataLen) + ')'
     C                   Else
     C                   EVAL      SQLStr = %TRIMR(SQLStr) +
     C                             ' add column ' +  %TRIMR(A2ALIS(Idx2)) +
     C                             ' for column ' +
     C                             %TRIMR(#FLDNM) + ' ' +  %TRIMR(DataType) +
     C                             ' (' + %TRIMR(DataLen) + ')'
     C                   Endif
     C                   ENDIF
     C                   ENDIF
     C                   IF        A2NULL(Idx2) = 'N'
     C                   EVAL      SQLStr = %TRIMR(SQLStr) +
     C                             ' not null with default'
     C                   IF        A2DFT(Idx2) <> *BLANKS
     C                   If        DataType = 'decimal'
     C                             or DataType = 'numeric'
     C                   EVAL      SQLStr = %TRIMR(SQLStr) + ' ' +
     C                             %trimr(A2DFT(Idx2))
     C                   else
     C                   EVAL      SQLStr = %TRIMR(SQLStr) + ' ' +
     C                             '''' + %trimr(A2DFT(Idx2))
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF


      ** set column headings
     C                   EVAL      wCHD1 = A2CHD1(Idx2)
     C                   EVAL      wCHD2 = A2CHD2(Idx2)
     C                   EVAL      wCHD3 = A2CHD3(Idx2)
     C                   EVAL      SQLStr1 = %TRIMR(SQLStr1) +
     C                             ', ' + %TRIMR(#FLDNM) +
     C                             ' is ' + '''' + %TRIMR(wCHD) + ''''

      ** set label headings
     C                   EVAL      SQLStr2 = %TRIMR(SQLStr2) +
     C                             ', ' + %TRIMR(#FLDNM) +
     C                             ' TEXT is ' + '''' + %TRIMR(A2FTXT(Idx2)) +
     C                             ''''

     C                   ADD       1             Idx2
     C                   ENDDO

     C                   EVAL      LEAVE = 'Y'

     C                   If        Mode = 'U'
     C/exec SQL
     C+ execute immediate :SQLStr
     C/end-exec
     C                   If        SQLCOD<*ZERO
     C                   EXSR      *PSSR
     C                   EndIf
     C                   ELSE
     C                   EVAL      XSQL = SQLStr

     C/EXEC SQL
     C+ insert into UPGSCRTD
     C+ (
     C+   SCPRFX
     C+  ,SCFILE
     C+  ,SCLIB
     C+  ,SCSEQ
     C+  ,SCTYPE
     C+  ,SCCMTY
     C+  ,SCCDSH
     C+  ,SCDEPF
     C+  ,SCCDRN
     C+  ,SCCMD
     C+  ,SCOPGM
     C+ )
     C+ Values
     C+ (
     C+   :Prefix
     C+  ,:#FILE
     C+  ,:#Lib1
     C+  ,:#SEQ
     C+  ,'  '
     C+  ,'SQL'
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+  ,:XSQL
     C+  ,'UP000057'
     C+ )
     C/END-EXEC
     C                   ENDIF

     C                   EVAL      SQLStr1 = %TRIMR(SQLStr1) + ')'
     C                   EVAL      #SEQ = #SEQ +1
     C                   If        Mode = 'U'
     C/exec SQL
     C+ execute immediate :SQLStr1
     C/end-exec
     C                   If        SQLCOD<*ZERO
     C                   EXSR      *PSSR
     C                   EndIf
     C                   ELSE
     C                   EVAL      XSQL = SQLStr1

     C/EXEC SQL
     C+ insert into UPGSCRTD
     C+ (
     C+   SCPRFX
     C+  ,SCFILE
     C+  ,SCLIB
     C+  ,SCSEQ
     C+  ,SCTYPE
     C+  ,SCCMTY
     C+  ,SCCDSH
     C+  ,SCDEPF
     C+  ,SCCDRN
     C+  ,SCCMD
     C+  ,SCOPGM
     C+ )
     C+ Values
     C+ (
     C+   :Prefix
     C+  ,:#FILE
     C+  ,:#Lib1
     C+  ,:#SEQ
     C+  ,'  '
     C+  ,'SQL'
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+  ,:XSQL
     C+  ,'UP000057'
     C+ )
     C/END-EXEC
     C                   ENDIF

     C                   EVAL      SQLStr2 = %TRIMR(SQLStr2) + ')'
     C                   EVAL      #SEQ = #SEQ +1
     C                   If        Mode = 'U'
     C/exec SQL
     C+ execute immediate :SQLStr2
     C/end-exec
     C                   If        SQLCOD<*ZERO
     C                   EXSR      *PSSR
     C                   EndIf
     C                   ELSE
     C                   EVAL      XSQL = SQLStr2

     C/EXEC SQL
     C+ insert into UPGSCRTD
     C+ (
     C+   SCPRFX
     C+  ,SCFILE
     C+  ,SCLIB
     C+  ,SCSEQ
     C+  ,SCTYPE
     C+  ,SCCMTY
     C+  ,SCCDSH
     C+  ,SCDEPF
     C+  ,SCCDRN
     C+  ,SCCMD
     C+  ,SCOPGM
     C+ )
     C+ Values
     C+ (
     C+   :Prefix
     C+  ,:#FILE
     C+  ,:#Lib1
     C+  ,:#SEQ
     C+  ,'  '
     C+  ,'SQL'
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+  ,:XSQL
     C+  ,'UP000057'
     C+ )
     C/END-EXEC
     C                   ENDIF

     C     SrAddFldBE    ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *    SrRebuild                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SrRebuild     BEGSR

     C*                  EVAL      #SEQ = #SEQ +1
     C                   CALL      'UP000058'
     C                   PARM                    #File
     C                   PARM                    #Lib1
     C                   PARM                    A2FLDI(Idx1)
     C                   PARM                    A1FLDI(Idx2)
     C                   PARM                    Mode
     C                   PARM                    Empty
     C                   PARM                    A1FLDI
     C                   PARM                    A1FLDB
     C                   PARM                    A1FLDD
     C                   PARM                    A1FLDP
     C                   PARM                    A1FTXT
     C                   PARM                    A1CHD1
     C                   PARM                    A1CHD2
     C                   PARM                    A1CHD3
     C                   PARM                    A1FLDT
     C                   PARM                    A1NULL
     C                   PARM                    A1DFT
     C                   PARM                    A1VARL
     C                   PARM                    A1ALIS
     C                   PARM                    A2FLDI
     C                   PARM                    A2FLDB
     C                   PARM                    A2FLDD
     C                   PARM                    A2FLDP
     C                   PARM                    A2FTXT
     C                   PARM                    A2CHD1
     C                   PARM                    A2CHD2
     C                   PARM                    A2CHD3
     C                   PARM                    A2FLDT
     C                   PARM                    A2NULL
     C                   PARM                    A2DFT
     C                   PARM                    A2VARL
     C                   PARM                    A2ALIS
     C                   PARM                    ERROR            10
     C                   PARM                    #SEQ
     C                   PARM                    KEEP

     C                   EVAL      LEAVE = 'Y'
     C                   IF        ERROR = 'ERROR'
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************

     C     SrDropFld     BEGSR

     C                   EVAL      #SEQ = #SEQ +1
     C                   EVAL      SQLStr = *blanks

     C                   DOW       A1FLDI(Idx1) <> *BLANKS

     C                   If        SQLStr = *BLANKS
     C                   EVAL      SQLStr = 'alter table ' + %TRIMR(#Lib1) +
     C                             '/' + %TRIMR(#File) + ' drop column ' +
     C                             %TRIMR(A1FLDI(Idx1)) + ' cascade '
     C                   ELSE
     C                   EVAL      SQLStr = %TRIMR(SQLStr) +
     C                             ' drop column ' +
     C                             %TRIMR(A1FLDI(Idx1)) + ' cascade '
     C                   ENDIF

     C                   Eval      Idx1 = Idx1 + 1
      *
     C                   If        A1FLDI(Idx1) = *blanks
     C                   LEAVE
     C                   ENDIF

     C                   ENDDO
      *
     C                   If        Mode = 'U'
     C/exec SQL
     C+ execute immediate :SQLStr
     C/end-exec
     C                   If        SQLCOD<*ZERO
     C                   EXSR      *PSSR
     C                   EndIf
     C                   ELSE
     C                   EVAL      XSQL = SQLStr

     C                   EVAL      #SEQ = #SEQ +1
     C/EXEC SQL
     C+ insert into UPGSCRTD
     C+ (
     C+   SCPRFX
     C+  ,SCFILE
     C+  ,SCLIB
     C+  ,SCSEQ
     C+  ,SCTYPE
     C+  ,SCCMTY
     C+  ,SCCDSH
     C+  ,SCDEPF
     C+  ,SCCDRN
     C+  ,SCCMD
     C+  ,SCOPGM
     C+ )
     C+ Values
     C+ (
     C+   :Prefix
     C+  ,:#FILE
     C+  ,:#Lib1
     C+  ,:#SEQ
     C+  ,'  '
     C+  ,'SQL'
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+  ,:XSQL
     C+  ,'UP000057'
     C+ )
     C/END-EXEC
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program Exception Error Routine                      *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *PSSR         BEGSR

     C                   DUMP

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR

      ********************************************************************
