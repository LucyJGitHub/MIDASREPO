     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2020')
      *****************************************************************
/*XBIA*  OVRDBF FILE(UDFOLD) TOFILE(UPFFDSTPD)                        *
/*XBIB*  OVRDBF FILE(UDFNEW) TOFILE(UPFFDSTPD)                        *
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP ADBU Write Script for driver')                *
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP000054 - Midas UP ADBU generate script for SQL update      *
      *                                                               *
      *  (c) Finastra International 2020                              *
      *                                                               *
      *  Last Amend No. MD050666 *CREATE     Date 17Mar20             *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD050666 - Adaptive Database Upgrade                         *
      *                                                               *
      *****************************************************************
      *
     F*HSQLLOG  O  A E             DISK
     F*HUPGLOG  O  A E             DISK

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

     D BSFLDI          S             10    DIM(9999)
     D BSFLDB          S              5  0 DIM(9999)
     D BSFLDD          S              2  0 DIM(9999)
     D BSFLDP          S              2  0 DIM(9999)
     D BSFTXT          S             50    DIM(9999)
     D BSCHD1          S             20    DIM(9999)
     D BSCHD2          S             20    DIM(9999)
     D BSCHD3          S             20    DIM(9999)
     D BSFLDT          S              1    DIM(9999)
     D BSNULL          S              1    DIM(9999)
     D BSDFT           S             30    DIM(9999)
     D BSVARL          S              1    DIM(9999)
     D BSALIS          S             30    DIM(9999)

     D Prefix          S              2A
     D XSQL            S          32000A
     D DataType        S             10A
     D DataLen         S             10A
     D SQLStr          S          32000A
     D SQLStr1         S          32000A
     D SQLStr2         S          32000A
     D Quote           S              1A   INZ('''')
     D Append          S              1A
     D #FLDNM          S             10A
     D #Field          S             10A
     D #FieldN         S             10A
     D EndField        S             10A
     D #start          S              4  0
     D #end            S              4  0
     D #VAR            S             10A
     D Index           S              4  0
     D Bex             S              4  0
     D Index_S         S              4  0
     D IIX             S              4  0
     D wCHD            DS            60
     D  wCHD1                  1     20
     D  wCHD2                 21     40
     D  wCHD3                 41     60
     D q_add           S              2  0
     D xpos            S              2  0

     D FldData       E DS                  EXTNAME(UPFFDSTPD)

     D/COPY ZACPYSRC,PSDS

     D from            C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
     D to              C                   'BCDEFGHIJKLMNOPQRSTUVWXYZA'
       /EJECT
      *****************************************************************
      *                                                               *
      *  MAIN PROCESSING                                              *
      *                                                               *
      *****************************************************************

     C     *ENTRY        PLIST
     C                   PARM                    #File            10
     C                   PARM                    #Lib             10
     C                   PARM                    #Field           10
     C                   PARM                    #FieldN          10
     C                   PARM                    Mode              1
     C                   PARM                    Empty             1
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
      ** new fields
     C                   PARM                    ARFLDI
     C                   PARM                    ARFLDB
     C                   PARM                    ARFLDD
     C                   PARM                    ARFLDP
     C                   PARM                    ARFTXT
     C                   PARM                    ARCHD1
     C                   PARM                    ARCHD2
     C                   PARM                    ARCHD3
     C                   PARM                    ARFLDT
     C                   PARM                    ARNULL
     C                   PARM                    ARDFT
     C                   PARM                    ARVARL
     C                   PARM                    ARALIS
     C                   PARM                    ERROR            10
     C                   PARM                    #SEQ             15 5
     C                   PARM                    KEEP              1

     C                   eval      Prefix = %SUBST(#Lib:1:2)
     C                   EXSR      AddFld
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      *    AddFld - add field                                         *
      *                                                               *
      *****************************************************************

     C     AddFld        BEGSR

      * If Bespoke fields have to be kept
     C                   If        KEEP = 'Y'
     C                   Exsr      SR_StoreBesp
     C                   ENDIF

      * Step 1 - Add new colums with 'ZZ' suffix
     C                   EXSR      AddFldZZ

      * Step 2 - update the 'ZZ' fields
     C                   If        Empty = 'N'
     C                   EXSR      UpdFLdZZ
     C                   ENDIF

      * Step 3 - drop the original fields that were duplicated in step 1
     C                   EXSR      DropFldZZ

      * Step 4 - add back the original fields
     C                   EXSR      AddOFld

      * Step 5 - update original fields with ZZ value
     C                   If        Empty = 'N'
     C                   EXSR      UpdOFLd
     C                   ENDIF

      * Step 6 - drop ZZ fields
     C                   EXSR      DropZZFld

      * If Bespoke fields have to be kept, add them now at the end
     C                   If        KEEP = 'Y'
     C                   Exsr      SR_AddBesp
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *    AddFldZZ - Add ZZ fields                                   *
      *                                                               *
      *****************************************************************
      *
     C     AddFldZZ      BEGSR
      *
     C                   EVAL      Append = 'N'
     C                   EVAL      Index = 1
     C                   EVAL      SQLStr = *blanks
     C                   EVAL      SQLStr1 = *blanks
     C                   EVAL      SQLStr2 = *blanks
     C                   EVAL      Index_S = 0
      *
     C                   DOW       ARFLDI(Index) <> *BLANKS
     C                             or Append = 'Y'
      *
      ** get up to the marker field to be added at the end (#Field passed as entry parameter)
     C                   If        ARFLDI(Index) = #Field
     C                             or Append = 'Y'

      ** set the start index
     C                   If        Index_S = 0
     C                   eval      Index_S = Index
     C                   endif

      ** if 500 fields, break up statement
     C                   If        Index - Index_S = 500
     C                             or Index - Index_S = 1000
     C                             or Index - Index_S = 1500
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
     C+ insert into UPZSCRTD
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
     C+  ,:#Lib
     C+  ,:#SEQ
     C+  ,'  '
     C+  ,'SQL'
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+  ,:XSQL
     C+  ,'UP000054'
     C+ )
     C/END-EXEC
     C                   ENDIF
     C                   EVAL      Append = 'N'
     C                   EVAL      SQLStr = *blanks
     C                   EVAL      SQLStr1 = *blanks
     C                   EVAL      SQLStr2 = *blanks
     C                   EVAL      Index_S = 0

     C                   Endif

      ** append field with 'ZZ' suffix
     C                   EVAL      #FLDNM = *BLANKS
     C                   EVAL      Append = 'Y'
     C**   ARFLDI(Index) CAT       'ZZ':0        #FLDNM
      *free
      *
      *TotalLength = %len(%trim(ARFLDI(Index)));
      *ReduceByOne = TotalLength;
      *for count = 1 to TotalLength;
      *#FLDNM = %TRIM(#FLDNM) + %subst(ARFLDI(Index):ReduceByOne:1);
      *ReduceByone -=1;
      *endfor;
     C                   EVAL      #FLDNM = %XLATE(from:to:ARFLDI(Index))

     C                   IF        #FLDNM = ARFLDI(Index)
     C                   eval      #FLDNM ='#' + #FLDNM
     C                   ENDIF

     C                   SELECT
      *
     C                   WHEN      ARFLDT(Index) = 'A'
     C                   EVAL      DataType = 'char'
     C                   EVAL      DataLen = %TRIML(%EDITC(ARFLDB(Index):'3'))
     C                   If        ARVARL(Index) = 'Y'
     C                   EVAL      DataType = 'varchar'
     C                   ENDIF

     C                   WHEN      ARFLDT(Index) = 'S'
     C                   EVAL      DataType = 'numeric'
     C                   EVAL      DataLen = %TRIML(%EDITC(ARFLDD(Index):'3'))
     C                   EVAL      DataLen = %TRIMR(DataLen) + ',' +
     C                             %TRIML(%EDITC(ARFLDP(Index):'3'))
      *
     C                   WHEN      ARFLDT(Index) = 'P'
     C                   EVAL      DataType = 'decimal'
     C                   EVAL      DataLen = %TRIML(%EDITC(ARFLDD(Index):'3'))
     C                   EVAL      DataLen = %TRIMR(DataLen) + ',' +
     C                             %TRIML(%EDITC(ARFLDP(Index):'3'))

     C                   WHEN      ARFLDT(Index) = 'Z'
     C                   EVAL      DataType = 'TIMESTAMP'
     C                   EVAL      DataLen = *blanks

     C                   WHEN      ARFLDT(Index) = 'G'
     C                   EVAL      DataType = 'GRAPHIC'
     C                   EVAL      DataLen = %CHAR(%DECH(ARFLDB(Index)/2:10:0))

     C                   WHEN      ARFLDT(Index) = '1'
     C                   EVAL      DataType = 'CLOB'
     C                   EVAL      DataLen = *blanks

     C                   WHEN      ARFLDT(Index) = 'O'
     C                   EVAL      DataType = 'char'
     C                   EVAL      DataLen = %TRIML(%EDITC(ARFLDB(Index):'3'))
     C                   EVAL      DataType = 'OPEN'
      *
     C                   ENDSL

     C                   IF        SQLStr = *BLANKS
     C                   IF        DataType = 'TIMESTAMP'
     C                   EVAL      SQLStr = 'alter table ' + %TRIMR(#Lib) +
     C                             '/' + %TRIMR(#File) + ' add column ' +
     C                             %TRIMR(#FLDNM) + ' ' +  %TRIMR(DataType)
     C                   ELSE
     C                   If        DataType = 'GRAPHIC'
     C                   EVAL      SQLStr = 'alter table ' + %TRIMR(#Lib) +
     C                             '/' + %TRIMR(#File) + ' add column ' +
     C                             %TRIMR(#FLDNM) + ' ' +  %TRIMR(DataType) +
     C                             ' (' + %TRIMR(DataLen) + ')' +
     C                             ' CCSID 1200 '
     C                   ELSE
     C                   If        DataType = 'OPEN'
     C                   EVAL      SQLStr = 'alter table ' + %TRIMR(#Lib) +
     C                             '/' + %TRIMR(#File) + ' add column ' +
     C                             %TRIMR(#FLDNM) + ' ' +  'char' +
     C                             ' (' + %TRIMR(DataLen) + ')' +
     C                             ' FOR MIXED DATA '
     C                   ELSE
     C                   IF        DataLen = *BLANKS
     C                   EVAL      SQLStr = 'alter table ' + %TRIMR(#Lib) +
     C                             '/' + %TRIMR(#File) + ' add column ' +
     C                             %TRIMR(#FLDNM) + ' ' +  %TRIMR(DataType)
     C                   ELSE
     C                   EVAL      SQLStr = 'alter table ' + %TRIMR(#Lib) +
     C                             '/' + %TRIMR(#File) + ' add column ' +
     C                             %TRIMR(#FLDNM) + ' ' +  %TRIMR(DataType) +
     C                             ' (' + %TRIMR(DataLen) + ')'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
     C                   IF        DataType = 'TIMESTAMP'
     C                   EVAL      SQLStr = %TRIMR(SQLStr) +
     C                             ' add column ' +
     C                             %TRIMR(#FLDNM) + ' ' +  %TRIMR(DataType)
     C                   ELSE
     C                   If        DataType = 'GRAPHIC'
     C                   EVAL      SQLStr = %TRIMR(SQLStr) +
     C                             ' add column ' +
     C                             %TRIMR(#FLDNM) + ' ' +  %TRIMR(DataType) +
     C                             ' (' + %TRIMR(DataLen) + ')' +
     C                             ' CCSID 1200 '
     C                   ELSE
     C                   If        DataType = 'OPEN'
     C                   EVAL      SQLStr = %TRIMR(SQLStr) +
     C                             ' add column ' +
     C                             %TRIMR(#FLDNM) + ' ' +  'char'  +
     C                             ' (' + %TRIMR(DataLen) + ')' +
     C                             ' FOR MIXED DATA '
     C                   ELSE
     C                   IF        DataLen = *BLANKS
     C                   EVAL      SQLStr = %TRIMR(SQLStr) +
     C                             ' add column ' +
     C                             %TRIMR(#FLDNM) + ' ' +  %TRIMR(DataType)
     C                   ELSE
     C                   EVAL      SQLStr = %TRIMR(SQLStr) +
     C                             ' add column ' +
     C                             %TRIMR(#FLDNM) + ' ' +  %TRIMR(DataType) +
     C                             ' (' + %TRIMR(DataLen) + ')'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   IF        ARNULL(Index) = 'N'
     C                   EVAL      SQLStr = %TRIMR(SQLStr) +
     C                             ' not null with default'
     C                   IF        ARDFT(Index) <> *BLANKS
     C                   If        DataType = 'decimal'
     C                             or DataType = 'numeric'
     C                   EVAL      SQLStr = %TRIMR(SQLStr) + ' ' +
     C                             %trimr(ARDFT(Index))
     C                   else
     C                   EVAL      SQLStr = %TRIMR(SQLStr) + ' ' +
     C                             '''' + %trimr(ARDFT(Index))
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF


      ** set column headings
     C*                  EVAL      wCHD1 = ARCHD1(Index)
     C*                  EVAL      wCHD2 = ARCHD2(Index)
     C* no need now      EVAL      wCHD3 = ARCHD3(Index)
     C*                  IF        SQLStr1 = *BLANKS
     C*                  EVAL      SQLStr1 = 'label on column ' + %TRIMR(#Lib) +
     C*                            '/' + %TRIMR(#File) + ' (' + %TRIMR(#FLDNM) +
     C*                            ' is ' + '''' + %TRIMR(wCHD) + ''''
     C*                  ELSE
     C*                  EVAL      SQLStr1 = %TRIMR(SQLStr1) +
     C*                            ', ' + %TRIMR(#FLDNM) +
     C*                            ' is ' + '''' + %TRIMR(wCHD) + ''''
     C*                  ENDIF

      ** set label headings
     C*                  IF        SQLStr2 = *BLANKS
     C*                  EVAL      SQLStr2 = 'label on column ' + %TRIMR(#Lib) +
     C*                            '/' + %TRIMR(#File) + ' (' + %TRIMR(#FLDNM) +
     C*                            ' TEXT is ' + '''' + %TRIMR(ARFTXT(Index)) +
     C*                            ''''
     C*                  ELSE
     C*                  EVAL      SQLStr2 = %TRIMR(SQLStr2) +
     C*                            ', ' + %TRIMR(#FLDNM) +
     C*                            ' TEXT is ' + '''' + %TRIMR(ARFTXT(Index)) +
     C*                            ''''
     C*                  ENDIF

     C                   ENDIF

     C                   Eval      Index = Index + 1
      *
     C                   If        ARFLDI(Index) = *blanks
     C                   EVAL      Append = 'N'
     C                   Endif

     C                   ENDDO

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
     C+ insert into UPZSCRTD
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
     C+  ,:#Lib
     C+  ,:#SEQ
     C+  ,'  '
     C+  ,'SQL'
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+  ,:XSQL
     C+  ,'UP000054'
     C+ )
     C/END-EXEC
     C                   ENDIF

     C*                  EVAL      SQLStr1 = %TRIMR(SQLStr1) + ')'
     C*                  If        Mode = 'U'
     C*exec SQL
     C* execute immediate :SQLStr1
     C**nd-exec
     C*                  If        SQLCOD<*ZERO
     C*                  EVAL      SQLStr = SQLStr1
     C*                  EXSR      *PSSR
     C*                  EndIf
     C*                  ELSE
     C*                  EVAL      XSQL = SQLStr1
     C*                  WRITE     PHSQLLD0
     C*                  ENDIF

     C*                  EVAL      SQLStr2 = %TRIMR(SQLStr2) + ')'
     C*                  If        Mode = 'U'
     C*exec SQL
     C* execute immediate :SQLStr2
     C*end-exec
     C*                  If        SQLCOD<*ZERO
     C*                  EVAL      SQLStr = SQLStr2
     C*                  EXSR      *PSSR
     C*                  EndIf
     C*                  ELSE
     C*                  EVAL      XSQL = SQLStr2
     C*                  WRITE     PHSQLLD0
     C*                  ENDIF

     C     AddFldZZE     ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *    UpdFldZZ - Update ZZ fields                                *
      *                                                               *
      *****************************************************************
      *
     C     UpdFldZZ      BEGSR

     C                   EVAL      Append = 'N'
     C                   EVAL      Index = 1
     C                   EVAL      SQLStr = *BLANKS

     C                   DOW       ARFLDI(Index) <> *BLANKS
     C                             or Append = 'Y'

      ** get up to the field to be added at the end (#Field passed as entry parameter)
     C                   If        ARFLDI(Index) = #Field
     C                             or Append = 'Y'
      ** then add field with 'ZZ' suffix
     C*                  EVAL      #FLDNM = #FieldN
     C*                  Eval      EndField = #FLDNM
      *
     C*                  EVAL      SQLStr = 'update ' + %TRIMR(#Lib) +
     C*                            '/' + %TRIMR(#File) + ' set ' +
     C*                            %TRIMR(#FLDNM) + ' = ' +
     C*                            %TRIMR(ARFLDI(Index))
      ** no update for the new field because it is new
     C                   EVAL      Append = 'Y'
      ** make sure field to be updated exist in 'old file
     C                   EVAL      IIX = 1
     C     ARFLDI(Index) LOOKUP    A1FLDI(IIX)                            69
     C     *IN69         IFEQ      *ON
      *
      ** append field with 'ZZ' suffix
     C                   EVAL      #FLDNM = *BLANKS
     C*    ARFLDI(Index) CAT       'ZZ':0        #FLDNM
      *free
      *
      *TotalLength = %len(%trim(ARFLDI(Index)));
      *ReduceByOne = TotalLength;
      *for count = 1 to TotalLength;
      *#FLDNM = %TRIM(#FLDNM) + %subst(ARFLDI(Index):ReduceByOne:1);
      *ReduceByone -=1;
      *endfor;
     C                   EVAL      #FLDNM = %XLATE(from:to:ARFLDI(Index))

     C                   IF        #FLDNM = ARFLDI(Index)
     C                   eval      #FLDNM ='#' + #FLDNM
     C                   ENDIF


      ** Check if now alph field is to be updated with num field
     C                   If        A1FLDT(IIX) = 'S'
     C                             and ARFLDT(Index) = 'A'
     C                   If        SQLStr = *BLANKS
     C                   EVAL      SQLStr = 'update ' + %TRIMR(#Lib) +
     C                             '/' + %TRIMR(#File) + ' set ' +
     C                             %TRIMR(#FLDNM) + ' = digits(' +
     C                             %TRIMR(ARFLDI(Index)) + ')'
     C                   ELSE
     C                   EVAL      SQLStr = %TRIMR(SQLStr) + ', '  +
     C                             %TRIMR(#FLDNM) + ' = digits(' +
     C                             %TRIMR(ARFLDI(Index)) + ')'
     C                   Endif
     C                   Else
     C                   If        SQLStr = *BLANKS
     C                   EVAL      SQLStr = 'update ' + %TRIMR(#Lib) +
     C                             '/' + %TRIMR(#File) + ' set ' +
     C                             %TRIMR(#FLDNM) + ' = ' +
     C                             %TRIMR(ARFLDI(Index))
     C                   ELSE
     C                   EVAL      SQLStr = %TRIMR(SQLStr) + ', '  +
     C                             %TRIMR(#FLDNM) + ' = ' +
     C                             %TRIMR(ARFLDI(Index))
     C                   ENDIF
     C                   ENDIF


     C                   ENDIF
     C                   ENDIF
     C                   Eval      Index = Index + 1
      *
     C                   If        ARFLDI(Index) = *blanks
     C                   EVAL      Append = 'N'
     C                   Endif

     C                   ENDDO

     C                   If        SQLStr <> *Blanks
     C                   If        Mode = 'U'
     C/exec SQL
     C+ execute immediate :SQLStr
     C/end-exec
     C                   DOW       SQLCOD=-406
     C                   EVAL      #VAR = %TRIM(%SUBST(SQLERM:5:10))
     C                   EVAL      #start = %scan(%TRIM(#VAR):SQLSTR:1)
     C                   EVAL      #end = %scan(',':SQLSTR:#start)
     C                   if        #end = 0
     C                   eval      #end = #start + 25
     C                   endif
     C                   EVAL      #VAR = %TRIM(#VAR) + '=0'
     C                   EVAL      %SUBST(SQLStr:#start:#end-#start) = #VAR
     C/exec SQL
     C+ execute immediate :SQLStr
     C/end-exec
     C                   ENDDO
     C                   If        SQLCOD<*ZERO
     C                   EXSR      *PSSR
     C                   EndIf
     C                   ELSE
     C                   EVAL      XSQL = SQLStr

     C                   EVAL      #SEQ = #SEQ +1
     C/EXEC SQL
     C+ insert into UPZSCRTD
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
     C+  ,:#Lib
     C+  ,:#SEQ
     C+  ,'  '
     C+  ,'SQL'
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+  ,:XSQL
     C+  ,'UP000054'
     C+ )
     C/END-EXEC
     C                   ENDIF
     C                   ENDIF

     C     UpdFldZZE     ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *    DropFldZZ - Drop fields that were added with ZZ            *
      *                                                               *
      *****************************************************************
      *
     C     DropFldZZ     BEGSR
      *
     C                   EVAL      Append = 'N'
     C                   EVAL      Index = 1
     C                   EVAL      SQLStr = *BLANKS
     C                   EVAL      Index_S = 0

      ** when dropping fields, use A1FLDI array and #FieldN as start field
     C                   DOW       A1FLDI(Index) <> *BLANKS
      *
      ** get up to the field to be added at the end (#Field passed as entry parameter)
     C                   If        A1FLDI(Index) = #FieldN
     C                             or Append = 'Y'
      ** then add field with 'ZZ' suffix
     C*                  EVAL      #FLDNM = #FieldN
     C*                  Eval      EndField = #FLDNM

     C*                  EVAL      SQLStr = 'alter table ' + %TRIMR(#Lib) +
     C*                            '/' + %TRIMR(#File) + ' drop column ' +
     C*                            %TRIMR(ARFLDI(Index)) + ' cascade '

      ** set the start index
     C                   If        Index_S = 0
     C                   eval      Index_S = Index
     C                   endif

      ** if 500 fields, break up statement
     C                   If        Index - Index_S = 500
     C                             or Index - Index_S = 1000
     C                             or Index - Index_S = 1500
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
     C+ insert into UPZSCRTD
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
     C+  ,:#Lib
     C+  ,:#SEQ
     C+  ,'  '
     C+  ,'SQL'
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+  ,:XSQL
     C+  ,'UP000054'
     C+ )
     C/END-EXEC
     C                   ENDIF
     C                   EVAL      Append = 'N'
     C                   EVAL      SQLStr = *blanks
     C                   EVAL      Index_S = 0

     C                   Endif

      ** new field not to be dropped
     C                   EVAL      Append = 'Y'

      ** append field with 'ZZ' suffix
     C                   If        SQLStr = *BLANKS
     C                   EVAL      SQLStr = 'alter table ' + %TRIMR(#Lib) +
     C                             '/' + %TRIMR(#File) + ' drop column ' +
     C                             %TRIMR(A1FLDI(Index)) + ' cascade '
     C                   ELSE
     C                   EVAL      SQLStr = %TRIMR(SQLStr) +
     C                             ' drop column ' +
     C                             %TRIMR(A1FLDI(Index)) + ' cascade '
     C                   ENDIF

     C                   ENDIF
     C                   Eval      Index = Index + 1
      *
     C                   If        A1FLDI(Index) = *blanks
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
     C+ insert into UPZSCRTD
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
     C+  ,:#Lib
     C+  ,:#SEQ
     C+  ,'  '
     C+  ,'SQL'
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+  ,:XSQL
     C+  ,'UP000054'
     C+ )
     C/END-EXEC
     C                   ENDIF

      *
     C     DropFldZZE    ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *    AddOFld - Add back original fields after the ZZ fields     *
      *                                                               *
      *****************************************************************
      *
     C     AddOFld       BEGSR
      *
     C                   EVAL      SQLStr = *blanks
     C                   EVAL      SQLStr1 = *blanks
     C                   EVAL      SQLStr2 = *blanks
     C                   EVAL      Append = 'N'
     C                   EVAL      Index = 1
     C                   Eval      EndField = #FLDNM
     C                   EVAL      Index_S = 0
      *
     C                   DOW       ARFLDI(Index) <> *BLANKS
      *
      ** get up to the field to be added at the end (#Field passed as entry parameter)
     C                   If        ARFLDI(Index) = #Field
     C                             or Append = 'Y'

      ** set the start index
     C                   If        Index_S = 0
     C                   eval      Index_S = Index
     C                   endif

      ** if 500 fields, break up statement
     C                   If        Index - Index_S = 500
     C                             or Index - Index_S = 1000
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
     C+ insert into UPZSCRTD
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
     C+  ,:#Lib
     C+  ,:#SEQ
     C+  ,'  '
     C+  ,'SQL'
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+  ,:XSQL
     C+  ,'UP000054'
     C+ )
     C/END-EXEC
     C                   ENDIF

     C                   EVAL      SQLStr1 = %TRIMR(SQLStr1) + ')'
     C                   If        Mode = 'U'
     C/exec SQL
     C+ execute immediate :SQLStr1
     C/end-exec
     C                   If        SQLCOD<*ZERO
     C                   EVAL      SQLStr = SQLStr1
     C                   EXSR      *PSSR
     C                   EndIf
     C                   ELSE
     C                   EVAL      XSQL = SQLStr1

     C                   EVAL      #SEQ = #SEQ +1
     C/EXEC SQL
     C+ insert into UPZSCRTD
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
     C+  ,:#Lib
     C+  ,:#SEQ
     C+  ,'  '
     C+  ,'SQL'
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+  ,:XSQL
     C+  ,'UP000054'
     C+ )
     C/END-EXEC
     C                   ENDIF

     C                   EVAL      SQLStr2 = %TRIMR(SQLStr2) + ')'
     C                   If        Mode = 'U'
     C/exec SQL
     C+ execute immediate :SQLStr2
     C/end-exec
     C                   If        SQLCOD<*ZERO
     C                   EVAL      SQLStr = SQLStr2
     C                   EXSR      *PSSR
     C                   EndIf
     C                   ELSE
     C                   EVAL      XSQL = SQLStr2

     C                   EVAL      #SEQ = #SEQ +1
     C/EXEC SQL
     C+ insert into UPZSCRTD
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
     C+  ,:#Lib
     C+  ,:#SEQ
     C+  ,'  '
     C+  ,'SQL'
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+  ,:XSQL
     C+  ,'UP000054'
     C+ )
     C/END-EXEC
     C                   ENDIF
     C                   EVAL      Append = 'N'
     C                   EVAL      SQLStr = *blanks
     C                   EVAL      SQLStr1 = *blanks
     C                   EVAL      SQLStr2 = *blanks
     C                   EVAL      Index_S = 0

     C                   Endif

     C                   eval      Append = 'Y'
     C                   EVAL      #FLDNM = ARFLDI(Index)
     C                   SELECT
      *
     C                   WHEN      ARFLDT(Index) = 'A'
     C                   EVAL      DataType = 'char'
     C                   EVAL      DataLen = %TRIML(%EDITC(ARFLDB(Index):'3'))
     C                   If        ARVARL(Index) = 'Y'
     C                   EVAL      DataType = 'varchar'
     C                   ENDIF

     C                   WHEN      ARFLDT(Index) = 'S'
     C                   EVAL      DataType = 'numeric'
     C                   EVAL      DataLen = %TRIML(%EDITC(ARFLDD(Index):'3'))
     C                   EVAL      DataLen = %TRIMR(DataLen) + ',' +
     C                             %TRIML(%EDITC(ARFLDP(Index):'3'))
      *
     C                   WHEN      ARFLDT(Index) = 'P'
     C                   EVAL      DataType = 'decimal'
     C                   EVAL      DataLen = %TRIML(%EDITC(ARFLDD(Index):'3'))
     C                   EVAL      DataLen = %TRIMR(DataLen) + ',' +
     C                             %TRIML(%EDITC(ARFLDP(Index):'3'))

     C                   WHEN      ARFLDT(Index) = 'Z'
     C                   EVAL      DataType = 'TIMESTAMP'
     C                   EVAL      DataLen = *blanks

     C                   WHEN      ARFLDT(Index) = 'G'
     C                   EVAL      DataType = 'GRAPHIC'
     C                   EVAL      DataLen = %CHAR(%DECH(ARFLDB(Index)/2:10:0))

     C                   WHEN      ARFLDT(Index) = '1'
     C                   EVAL      DataType = 'CLOB'
     C                   EVAL      DataLen = *blanks

     C                   WHEN      ARFLDT(Index) = 'O'
     C                   EVAL      DataType = 'char'
     C                   EVAL      DataLen = %TRIML(%EDITC(ARFLDB(Index):'3'))
     C                   EVAL      DataType = 'OPEN'
      *
     C                   ENDSL

     C                   IF        SQLStr = *BLANKS
     C                   IF        DataType = 'TIMESTAMP'
     C                   EVAL      SQLStr = 'alter table ' + %TRIMR(#Lib) +
     C                             '/' + %TRIMR(#File) + ' add column ' +
     C                             %TRIMR(#FLDNM) + ' ' +  %TRIMR(DataType)
     C                   ELSE
     C                   If        DataType = 'GRAPHIC'
     C                   EVAL      SQLStr = 'alter table ' + %TRIMR(#Lib) +
     C                             '/' + %TRIMR(#File) + ' add column ' +
     C                             %TRIMR(#FLDNM) + ' ' +  %TRIMR(DataType) +
     C                             ' (' + %TRIMR(DataLen) + ')' +
     C                             ' CCSID 1200 '
     C                   ELSE
     C                   If        DataType = 'OPEN'
     C                   EVAL      SQLStr = 'alter table ' + %TRIMR(#Lib) +
     C                             '/' + %TRIMR(#File) + ' add column ' +
     C                             %TRIMR(#FLDNM) + ' ' +  'char' +
     C                             ' (' + %TRIMR(DataLen) + ')' +
     C                             ' FOR MIXED DATA '
     C                   ELSE
     C                   IF        DataLen = *BLANKS
     C                   EVAL      SQLStr = 'alter table ' + %TRIMR(#Lib) +
     C                             '/' + %TRIMR(#File) + ' add column ' +
     C                             %TRIMR(#FLDNM) + ' ' +  %TRIMR(DataType)
     C                   ELSE
     C                   EVAL      SQLStr = 'alter table ' + %TRIMR(#Lib) +
     C                             '/' + %TRIMR(#File) + ' add column ' +
     C                             %TRIMR(#FLDNM) + ' ' +  %TRIMR(DataType) +
     C                             ' (' + %TRIMR(DataLen) + ')'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
     C                   IF        DataType = 'TIMESTAMP'
     C                   EVAL      SQLStr = %TRIMR(SQLStr) +
     C                             ' add column ' +
     C                             %TRIMR(#FLDNM) + ' ' +  %TRIMR(DataType)
     C                   ELSE
     C                   If        DataType = 'GRAPHIC'
     C                   EVAL      SQLStr = %TRIMR(SQLStr) +
     C                             ' add column ' +
     C                             %TRIMR(#FLDNM) + ' ' +  %TRIMR(DataType) +
     C                             ' (' + %TRIMR(DataLen) + ')' +
     C                              ' CCSID 1200 '
     C                   ELSE
     C                   If        DataType = 'OPEN'
     C                   EVAL      SQLStr = %TRIMR(SQLStr) +
     C                             ' add column ' +
     C                             %TRIMR(#FLDNM) + ' ' +  'char'  +
     C                             ' (' + %TRIMR(DataLen) + ')' +
     C                             ' FOR MIXED DATA '
     C                   ELSE
     C                   IF        DataLen = *BLANKS
     C                   EVAL      SQLStr = %TRIMR(SQLStr) +
     C                             ' add column ' +
     C                             %TRIMR(#FLDNM) + ' ' +  %TRIMR(DataType)
     C                   ELSE
     C                   EVAL      SQLStr = %TRIMR(SQLStr) +
     C                             ' add column ' +
     C                             %TRIMR(#FLDNM) + ' ' +  %TRIMR(DataType) +
     C                             ' (' + %TRIMR(DataLen) + ')'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   IF        ARNULL(Index) = 'N'
     C                   EVAL      SQLStr = %TRIMR(SQLStr) +
     C                             ' not null with default'
     C                   IF        ARDFT(Index) <> *BLANKS
     C                   If        DataType = 'decimal'
     C                             or DataType = 'numeric'
     C                   EVAL      SQLStr = %TRIMR(SQLStr) + ' ' +
     C                             %trimr(ARDFT(Index))
     C                   else
     C                   EVAL      SQLStr = %TRIMR(SQLStr) + ' ' +
     C                             '''' + %trimr(ARDFT(Index))
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

      ** set column headings
     C                   EVAL      wCHD1 = ARCHD1(Index)
     C                   EVAL      wCHD2 = ARCHD2(Index)
     C                   EVAL      wCHD3 = ARCHD3(Index)
      ** look for double quote '', if found in wCHD1, shift wCHD2 by 1 char for each occurrence
     C                   EVAL      q_add = 0
     C                   EVAL      xpos = %SCAN(Quote:wCHD1:1)
     C                   If        xpos > 0 and %subst(wCHD1:xpos+1:1) = Quote
     C                   EVAL      q_add = q_add + 1
     C                   EVAL      xpos = %SCAN(Quote:wCHD1:xpos+2)
     C                   If        xpos > 0 and %subst(wCHD1:xpos+1:1) = Quote
     C                   EVAL      q_add = q_add + 1
     C                   ENDIF
     C                   ENDIF

     C                   if        q_add = 1 or q_add = 2
     C                   eval      wCHD2 = ' ' + wCHD2
     C                   eval      wCHD3 = ' ' + wCHD3
     C                   if        q_add = 2
     C                   eval      wCHD2 = ' ' + wCHD2
     C                   eval      wCHD3 = ' ' + wCHD3
     C                   ENDIF
     C                   ENDIF

      ** look for double quote '', if found in wCHD2, shift wCHD3 by 1 char for each occurrence
     C                   EVAL      q_add = 0
     C                   EVAL      xpos = %SCAN(Quote:wCHD2:1)
     C                   If        xpos > 0 and %subst(wCHD2:xpos+1:1) = Quote
     C                   EVAL      q_add = q_add + 1
     C                   EVAL      xpos = %SCAN(Quote:wCHD2:xpos+2)
     C                   If        xpos > 0 and %subst(wCHD2:xpos+1:1) = Quote
     C                   EVAL      q_add = q_add + 1
     C                   ENDIF
     C                   ENDIF

     C                   if        q_add = 1 or q_add = 2
     C                   eval      wCHD3 = ' ' + wCHD3
     C                   if        q_add = 2
     C                   eval      wCHD3 = ' ' + wCHD3
     C                   ENDIF
     C                   ENDIF

     C                   IF        SQLStr1 = *BLANKS
     C                   EVAL      SQLStr1 = 'label on column ' + %TRIMR(#Lib) +
     C                             '/' + %TRIMR(#File) + ' (' + %TRIMR(#FLDNM) +
     C                             ' is ' + '''' + %TRIMR(wCHD) + ''''
     C                   ELSE
     C                   EVAL      SQLStr1 = %TRIMR(SQLStr1) +
     C                             ', ' + %TRIMR(#FLDNM) +
     C                             ' is ' + '''' + %TRIMR(wCHD) + ''''
     C                   ENDIF


      ** set label headings
     C                   IF        SQLStr2 = *BLANKS
     C                   EVAL      SQLStr2 = 'label on column ' + %TRIMR(#Lib) +
     C                             '/' + %TRIMR(#File) + ' (' + %TRIMR(#FLDNM) +
     C                             ' TEXT is ' + '''' + %TRIMR(ARFTXT(Index)) +
     C                             ''''
     C                   ELSE
     C                   EVAL      SQLStr2 = %TRIMR(SQLStr2) +
     C                             ', ' + %TRIMR(#FLDNM) +
     C                             ' TEXT is ' + '''' + %TRIMR(ARFTXT(Index)) +
     C                             ''''
     C                   ENDIF

     C                   ENDIF

     C                   Eval      Index = Index + 1

     C                   If        ARFLDI(Index) = *blanks
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
     C+ insert into UPZSCRTD
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
     C+  ,:#Lib
     C+  ,:#SEQ
     C+  ,'  '
     C+  ,'SQL'
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+  ,:XSQL
     C+  ,'UP000054'
     C+ )
     C/END-EXEC
     C                   ENDIF

     C                   EVAL      SQLStr1 = %TRIMR(SQLStr1) + ')'
     C                   If        Mode = 'U'
     C/exec SQL
     C+ execute immediate :SQLStr1
     C/end-exec
     C                   If        SQLCOD<*ZERO
     C                   EVAL      SQLStr = SQLStr1
     C                   EXSR      *PSSR
     C                   EndIf
     C                   ELSE
     C                   EVAL      XSQL = SQLStr1

     C                   EVAL      #SEQ = #SEQ +1
     C/EXEC SQL
     C+ insert into UPZSCRTD
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
     C+  ,:#Lib
     C+  ,:#SEQ
     C+  ,'  '
     C+  ,'SQL'
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+  ,:XSQL
     C+  ,'UP000054'
     C+ )
     C/END-EXEC
     C                   ENDIF

     C                   EVAL      SQLStr2 = %TRIMR(SQLStr2) + ')'
     C                   If        Mode = 'U'
     C/exec SQL
     C+ execute immediate :SQLStr2
     C/end-exec
     C                   If        SQLCOD<*ZERO
     C                   EVAL      SQLStr = SQLStr2
     C                   EXSR      *PSSR
     C                   EndIf
     C                   ELSE
     C                   EVAL      XSQL = SQLStr2

     C                   EVAL      #SEQ = #SEQ +1
     C/EXEC SQL
     C+ insert into UPZSCRTD
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
     C+  ,:#Lib
     C+  ,:#SEQ
     C+  ,'  '
     C+  ,'SQL'
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+  ,:XSQL
     C+  ,'UP000054'
     C+ )
     C/END-EXEC
     C                   ENDIF

      *
     C     AddOFldE      ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *    UpdOFld - Update original fields with ZZ fields            *
      *                                                               *
      *****************************************************************
      *
     C     UpdOFld       BEGSR
      *
     C                   EVAL      SQLStr = *BLANKS
     C                   EVAL      Append = 'N'
     C                   EVAL      Index = 1
     C                   EVAL      #FLDNM = #FieldN
     C                   Eval      EndField = #FLDNM
      *
     C                   DOW       ARFLDI(Index) <> *BLANKS
      *
      ** get up to the field to be added at the end (#Field passed as entry parameter)
     C                   If        ARFLDI(Index) = #Field
     C                             or Append = 'Y'

     C                   EVAL      Append = 'Y'
      ** append field with 'ZZ' suffix
     C                   EVAL      #FLDNM = *BLANKS
      *free
      *
      *TotalLength = %len(%trim(ARFLDI(Index)));
      *ReduceByOne = TotalLength;
      *for count = 1 to TotalLength;
      *#FLDNM = %TRIM(#FLDNM) + %subst(ARFLDI(Index):ReduceByOne:1);
      *ReduceByone -=1;
      *endfor;
     C                   EVAL      #FLDNM = %XLATE(from:to:ARFLDI(Index))

     C                   IF        #FLDNM = ARFLDI(Index)
     C                   eval      #FLDNM ='#' + #FLDNM
     C                   ENDIF

     C                   IF        SQLStr = *BLANKS
     C                   EVAL      SQLStr = 'update ' + %TRIMR(#Lib) +
     C                             '/' + %TRIMR(#File) + ' set ' +
     C                             %TRIMR(ARFLDI(Index)) + ' = ' +
     C                             %TRIMR(#FLDNM)
     C                   ELSE
     C                   EVAL      SQLStr = %TRIMR(SQLStr) + ', '  +
     C                             %TRIMR(ARFLDI(Index)) + ' = ' +
     C                             %TRIMR(#FLDNM)
     C                   ENDIF

     C                   ENDIF
     C                   Eval      Index = Index + 1

     C                   If        ARFLDI(Index) = *blanks
     C                   LEAVE
     C                   ENDIF

     C                   ENDDO
      *
     C                   If        Mode = 'U'
     C/exec SQL
     C+ execute immediate :SQLStr
     C/end-exec
     C                   DOW       SQLCOD=-406
     C                   EVAL      #VAR = %TRIM(%SUBST(SQLERM:5:10))
     C                   EVAL      #start = %scan(%TRIM(#VAR):SQLSTR:1)
     C                   EVAL      #end = %scan(',':SQLSTR:#start)
     C                   if        #end = 0
     C                   eval      #end = #start + 25
     C                   endif
     C                   EVAL      #VAR = %TRIM(#VAR) + '=0'
     C                   EVAL      %SUBST(SQLStr:#start:#end-#start) = #VAR
     C/exec SQL
     C+ execute immediate :SQLStr
     C/end-exec
     C                   ENDDO
     C                   If        SQLCOD<*ZERO
     C                   EXSR      *PSSR
     C                   EndIf
     C                   ELSE
     C                   EVAL      XSQL = SQLStr

     C                   EVAL      #SEQ = #SEQ +1
     C/EXEC SQL
     C+ insert into UPZSCRTD
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
     C+  ,:#Lib
     C+  ,:#SEQ
     C+  ,'  '
     C+  ,'SQL'
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+  ,:XSQL
     C+  ,'UP000054'
     C+ )
     C/END-EXEC
     C                   ENDIF
      *
     C     UpdOFldE      ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *    DropZZFld - Drop fields that were added with ZZ            *
      *                                                               *
      *****************************************************************
      *
     C     DropZZFld     BEGSR
      *
     C                   EVAL      SQLStr = *BLANKS
     C                   EVAL      Append = 'N'
     C                   EVAL      Index = 1
     C                   eval      Index_S = 0
      *
     C                   DOW       ARFLDI(Index) <> *BLANKS
      *
      ** get up to the field to be added at the end (#Field passed as entry parameter)
     C                   If        ARFLDI(Index) = #Field
     C                             or Append = 'Y'


      ** set the start index
     C                   If        Index_S = 0
     C                   eval      Index_S = Index
     C                   endif

      ** if 500 fields, break up statement
     C                   If        Index - Index_S = 500
     C                             or Index - Index_S = 1000
     C                             or Index - Index_S = 1500
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
     C+ insert into UPZSCRTD
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
     C+  ,:#Lib
     C+  ,:#SEQ
     C+  ,'  '
     C+  ,'SQL'
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+  ,:XSQL
     C+  ,'UP000054'
     C+ )
     C/END-EXEC
     C                   ENDIF
     C                   EVAL      Append = 'N'
     C                   EVAL      SQLStr = *blanks
     C                   EVAL      Index_S = 0

     C                   Endif

     C                   EVAL      Append = 'Y'
      ** append field with 'ZZ' suffix
     C                   EVAL      #FLDNM = *BLANKS
      *free
      *
      *TotalLength = %len(%trim(ARFLDI(Index)));
      *ReduceByOne = TotalLength;
      *for count = 1 to TotalLength;
      *#FLDNM = %TRIM(#FLDNM) + %subst(ARFLDI(Index):ReduceByOne:1);
      *ReduceByone -=1;
      *endfor;

     C                   EVAL      #FLDNM = %XLATE(from:to:ARFLDI(Index))

     C                   IF        #FLDNM = ARFLDI(Index)
     C                   eval      #FLDNM ='#' + #FLDNM
     C                   ENDIF

     C                   IF        SQLStr = *BLANKS
     C                   EVAL      SQLStr = 'alter table ' + %TRIMR(#Lib) +
     C                             '/' + %TRIMR(#File) + ' drop column ' +
     C                             %TRIMR(#FLDNM) + ' cascade '
     C                   ELSE
     C                   EVAL      SQLStr = %TRIMR(SQLStr) +
     C                             ' drop column ' +
     C                             %TRIMR(#FLDNM) + ' cascade '
     C                   ENDIF

     C                   ENDIF

     C                   Eval      Index = Index + 1

     C                   If        ARFLDI(Index) = *blanks
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
     C+ insert into UPZSCRTD
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
     C+  ,:#Lib
     C+  ,:#SEQ
     C+  ,'  '
     C+  ,'SQL'
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+  ,:XSQL
     C+  ,'UP000054'
     C+ )
     C/END-EXEC
     C                   ENDIF
      *
     C     DropZZFldE    ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *    SR_StoreBesp - Store Bespoke fields                        *
      *                                                               *
      *****************************************************************

     C     SR_StoreBesp  BEGSR

      * Check which fields in A1FLDI are not in ARFLDI
     C                   EVAL      Index = 1
     C                   EVAL      Bex = 1
     C                   CLEAR                   BSFLDI
     C                   CLEAR                   BSFLDB
     C                   CLEAR                   BSFLDD
     C                   CLEAR                   BSFLDP
     C                   CLEAR                   BSFTXT
     C                   CLEAR                   BSCHD1
     C                   CLEAR                   BSCHD2
     C                   CLEAR                   BSCHD3
     C                   CLEAR                   BSFLDT
     C                   CLEAR                   BSNULL
     C                   CLEAR                   BSDFT
     C                   CLEAR                   BSVARL
     C                   CLEAR                   BSALIS

     C                   DOW       A1FLDI(Index) <> *BLANKS

      * get up to the marker field
     C                   If        ARFLDI(Index) = #Field
     C                             or Append = 'Y'

     C                   EVAL      Append = 'Y'
     C     A1FLDI(Index) Lookup    ARFLDI                                 69
      * if not found, store elements in Bespoke arrays
     C                   If        *IN69  = *OFF
     C                   EVAL      BSFLDI(Bex) = A1FLDI(Index)
     C                   EVAL      BSFLDB(Bex) = A1FLDB(Index)
     C                   EVAL      BSFLDD(Bex) = A1FLDD(Index)
     C                   EVAL      BSFLDP(Bex) = A1FLDP(Index)
     C                   EVAL      BSFTXT(Bex) = A1FTXT(Index)
     C                   EVAL      BSCHD1(Bex) = A1CHD1(Index)
     C                   EVAL      BSCHD2(Bex) = A1CHD2(Index)
     C                   EVAL      BSCHD3(Bex) = A1CHD3(Index)
     C                   EVAL      BSFLDT(Bex) = A1FLDT(Index)
     C                   EVAL      BSNULL(Bex) = A1NULL(Index)
     C                   EVAL      BSDFT(Bex) = A1DFT(Index)
     C                   EVAL      BSVARL(Bex) = A1VARL(Index)
     C                   EVAL      BSALIS(Bex) = A1ALIS(Index)
     C                   Eval      Bex = Bex + 1
     C                   ENDIF

     C                   ENDIF

     C                   Eval      Index = Index + 1

     C                   If        A1FLDI(Index) = *blanks
     C                   LEAVE
     C                   ENDIF

     C                   ENDDO

     C     BespokeE      ENDSR

      /EJECT
      *****************************************************************
      *                                                               *
      *    SR_AddBesp - Add Bespoke fields at the end                 *
      *                                                               *
      *****************************************************************

     C     SR_AddBesp    BEGSR

     C                   EVAL      SQLStr = *blanks
     C                   EVAL      SQLStr1 = *blanks
     C                   EVAL      SQLStr2 = *blanks
     C                   EVAL      Append = 'N'
     C                   EVAL      Bex = 1
     C                   Eval      EndField = #FLDNM

     C                   DOW       BSFLDI(Bex) <> *BLANKS

     C                   eval      Append = 'Y'
     C                   EVAL      #FLDNM = BSFLDI(Bex)
     C                   SELECT

     C                   WHEN      BSFLDT(Bex) = 'A'
     C                   EVAL      DataType = 'char'
     C                   EVAL      DataLen = %TRIML(%EDITC(BSFLDB(Bex):'3'))
     C                   If        BSVARL(Bex) = 'Y'
     C                   EVAL      DataType = 'varchar'
     C                   ENDIF

     C                   WHEN      BSFLDT(Bex) = 'S'
     C                   EVAL      DataType = 'numeric'
     C                   EVAL      DataLen = %TRIML(%EDITC(BSFLDD(Bex):'3'))
     C                   EVAL      DataLen = %TRIMR(DataLen) + ',' +
     C                             %TRIML(%EDITC(BSFLDP(Bex):'3'))

     C                   WHEN      BSFLDT(Bex) = 'P'
     C                   EVAL      DataType = 'decimal'
     C                   EVAL      DataLen = %TRIML(%EDITC(BSFLDD(Bex):'3'))
     C                   EVAL      DataLen = %TRIMR(DataLen) + ',' +
     C                             %TRIML(%EDITC(BSFLDP(Bex):'3'))

     C                   WHEN      BSFLDT(Bex) = 'Z'
     C                   EVAL      DataType = 'TIMESTAMP'
     C                   EVAL      DataLen = *blanks

     C                   WHEN      BSFLDT(Bex) = 'G'
     C                   EVAL      DataType = 'GRAPHIC'
     C                   EVAL      DataLen = %CHAR(%DECH(BSFLDB(Bex)/2:10:0))

     C                   WHEN      BSFLDT(Bex) = '1'
     C                   EVAL      DataType = 'CLOB'
     C                   EVAL      DataLen = *blanks

     C                   WHEN      BSFLDT(Bex) = 'O'
     C                   EVAL      DataType = 'char'
     C                   EVAL      DataLen = %TRIML(%EDITC(BSFLDB(Bex):'3'))
     C                   EVAL      DataType = 'OPEN'

     C                   ENDSL

     C                   IF        SQLStr = *BLANKS
     C                   IF        DataType = 'TIMESTAMP'
     C                   EVAL      SQLStr = 'alter table ' + %TRIMR(#Lib) +
     C                             '/' + %TRIMR(#File) + ' add column ' +
     C                             %TRIMR(#FLDNM) + ' ' +  %TRIMR(DataType)
     C                   ELSE
     C                   If        DataType = 'GRAPHIC'
     C                   EVAL      SQLStr = 'alter table ' + %TRIMR(#Lib) +
     C                             '/' + %TRIMR(#File) + ' add column ' +
     C                             %TRIMR(#FLDNM) + ' ' +  %TRIMR(DataType) +
     C                             ' (' + %TRIMR(DataLen) + ')' +
     C                             ' CCSID 1200 '
     C                   ELSE
     C                   If        DataType = 'OPEN'
     C                   EVAL      SQLStr = 'alter table ' + %TRIMR(#Lib) +
     C                             '/' + %TRIMR(#File) + ' add column ' +
     C                             %TRIMR(#FLDNM) + ' ' +  'char' +
     C                             ' (' + %TRIMR(DataLen) + ')' +
     C                             ' FOR MIXED DATA '
     C                   ELSE
     C                   IF        DataLen = *BLANKS
     C                   EVAL      SQLStr = 'alter table ' + %TRIMR(#Lib) +
     C                             '/' + %TRIMR(#File) + ' add column ' +
     C                             %TRIMR(#FLDNM) + ' ' +  %TRIMR(DataType)
     C                   ELSE
     C                   EVAL      SQLStr = 'alter table ' + %TRIMR(#Lib) +
     C                             '/' + %TRIMR(#File) + ' add column ' +
     C                             %TRIMR(#FLDNM) + ' ' +  %TRIMR(DataType) +
     C                             ' (' + %TRIMR(DataLen) + ')'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
     C                   IF        DataType = 'TIMESTAMP'
     C                   EVAL      SQLStr = %TRIMR(SQLStr) +
     C                             ' add column ' +
     C                             %TRIMR(#FLDNM) + ' ' +  %TRIMR(DataType)
     C                   ELSE
     C                   If        DataType = 'GRAPHIC'
     C                   EVAL      SQLStr = %TRIMR(SQLStr) +
     C                             ' add column ' +
     C                             %TRIMR(#FLDNM) + ' ' +  %TRIMR(DataType) +
     C                             ' (' + %TRIMR(DataLen) + ')' +
     C                              ' CCSID 1200 '
     C                   ELSE
     C                   If        DataType = 'OPEN'
     C                   EVAL      SQLStr = %TRIMR(SQLStr) +
     C                             ' add column ' +
     C                             %TRIMR(#FLDNM) + ' ' +  'char'  +
     C                             ' (' + %TRIMR(DataLen) + ')' +
     C                             ' FOR MIXED DATA '
     C                   ELSE
     C                   IF        DataLen = *BLANKS
     C                   EVAL      SQLStr = %TRIMR(SQLStr) +
     C                             ' add column ' +
     C                             %TRIMR(#FLDNM) + ' ' +  %TRIMR(DataType)
     C                   ELSE
     C                   EVAL      SQLStr = %TRIMR(SQLStr) +
     C                             ' add column ' +
     C                             %TRIMR(#FLDNM) + ' ' +  %TRIMR(DataType) +
     C                             ' (' + %TRIMR(DataLen) + ')'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   IF        BSNULL(Bex) = 'N'
     C                   EVAL      SQLStr = %TRIMR(SQLStr) +
     C                             ' not null with default'
     C                   IF        BSDFT(Bex) <> *BLANKS
     C                   If        DataType = 'decimal'
     C                             or DataType = 'numeric'
     C                   EVAL      SQLStr = %TRIMR(SQLStr) + ' ' +
     C                             %trimr(BSDFT(Bex))
     C                   else
     C                   EVAL      SQLStr = %TRIMR(SQLStr) + ' ' +
     C                             '''' + %trimr(BSDFT(Bex))
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

      ** set column headings
     C                   EVAL      wCHD1 = BSCHD1(Bex)
     C                   EVAL      wCHD2 = BSCHD2(Bex)
     C                   EVAL      wCHD3 = BSCHD3(Bex)
      ** look for double quote '', if found in wCHD1, shift wCHD2 by 1 char for each occurrence
     C                   EVAL      q_add = 0
     C                   EVAL      xpos = %SCAN(Quote:wCHD1:1)
     C                   If        xpos > 0 and %subst(wCHD1:xpos+1:1) = Quote
     C                   EVAL      q_add = q_add + 1
     C                   EVAL      xpos = %SCAN(Quote:wCHD1:xpos+2)
     C                   If        xpos > 0 and %subst(wCHD1:xpos+1:1) = Quote
     C                   EVAL      q_add = q_add + 1
     C                   ENDIF
     C                   ENDIF

     C                   if        q_add = 1 or q_add = 2
     C                   eval      wCHD2 = ' ' + wCHD2
     C                   eval      wCHD3 = ' ' + wCHD3
     C                   if        q_add = 2
     C                   eval      wCHD2 = ' ' + wCHD2
     C                   eval      wCHD3 = ' ' + wCHD3
     C                   ENDIF
     C                   ENDIF

      ** look for double quote '', if found in wCHD2, shift wCHD3 by 1 char for each occurrence
     C                   EVAL      q_add = 0
     C                   EVAL      xpos = %SCAN(Quote:wCHD2:1)
     C                   If        xpos > 0 and %subst(wCHD2:xpos+1:1) = Quote
     C                   EVAL      q_add = q_add + 1
     C                   EVAL      xpos = %SCAN(Quote:wCHD2:xpos+2)
     C                   If        xpos > 0 and %subst(wCHD2:xpos+1:1) = Quote
     C                   EVAL      q_add = q_add + 1
     C                   ENDIF
     C                   ENDIF

     C                   if        q_add = 1 or q_add = 2
     C                   eval      wCHD3 = ' ' + wCHD3
     C                   if        q_add = 2
     C                   eval      wCHD3 = ' ' + wCHD3
     C                   ENDIF
     C                   ENDIF

     C                   IF        SQLStr1 = *BLANKS
     C                   EVAL      SQLStr1 = 'label on column ' + %TRIMR(#Lib) +
     C                             '/' + %TRIMR(#File) + ' (' + %TRIMR(#FLDNM) +
     C                             ' is ' + '''' + %TRIMR(wCHD) + ''''
     C                   ELSE
     C                   EVAL      SQLStr1 = %TRIMR(SQLStr1) +
     C                             ', ' + %TRIMR(#FLDNM) +
     C                             ' is ' + '''' + %TRIMR(wCHD) + ''''
     C                   ENDIF


      ** set label headings
     C                   IF        SQLStr2 = *BLANKS
     C                   EVAL      SQLStr2 = 'label on column ' + %TRIMR(#Lib) +
     C                             '/' + %TRIMR(#File) + ' (' + %TRIMR(#FLDNM) +
     C                             ' TEXT is ' + '''' + %TRIMR(BSFTXT(Bex)) +
     C                             ''''
     C                   ELSE
     C                   EVAL      SQLStr2 = %TRIMR(SQLStr2) +
     C                             ', ' + %TRIMR(#FLDNM) +
     C                             ' TEXT is ' + '''' + %TRIMR(BSFTXT(Bex)) +
     C                             ''''
     C                   ENDIF


     C                   Eval      Bex = Bex + 1

     C                   If        BSFLDI(Bex) = *blanks
     C                   LEAVE
     C                   ENDIF

     C                   ENDDO

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
     C+ insert into UPZSCRTD
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
     C+  ,:#Lib
     C+  ,:#SEQ
     C+  ,'  '
     C+  ,'SQL'
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+  ,:XSQL
     C+  ,'UP000054'
     C+ )
     C/END-EXEC
     C                   ENDIF

     C                   EVAL      SQLStr1 = %TRIMR(SQLStr1) + ')'
     C                   If        Mode = 'U'
     C/exec SQL
     C+ execute immediate :SQLStr1
     C/end-exec
     C                   If        SQLCOD<*ZERO
     C                   EVAL      SQLStr = SQLStr1
     C                   EXSR      *PSSR
     C                   EndIf
     C                   ELSE
     C                   EVAL      XSQL = SQLStr1

     C                   EVAL      #SEQ = #SEQ +1
     C/EXEC SQL
     C+ insert into UPZSCRTD
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
     C+  ,:#Lib
     C+  ,:#SEQ
     C+  ,'  '
     C+  ,'SQL'
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+  ,:XSQL
     C+  ,'UP000054'
     C+ )
     C/END-EXEC
     C                   ENDIF

     C                   EVAL      SQLStr2 = %TRIMR(SQLStr2) + ')'
     C                   If        Mode = 'U'
     C/exec SQL
     C+ execute immediate :SQLStr2
     C/end-exec
     C                   If        SQLCOD<*ZERO
     C                   EVAL      SQLStr = SQLStr2
     C                   EXSR      *PSSR
     C                   EndIf
     C                   ELSE
     C                   EVAL      XSQL = SQLStr2

     C                   EVAL      #SEQ = #SEQ +1
     C/EXEC SQL
     C+ insert into UPZSCRTD
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
     C+  ,:#Lib
     C+  ,:#SEQ
     C+  ,'  '
     C+  ,'SQL'
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+  ,:XSQL
     C+  ,'UP000054'
     C+ )
     C/END-EXEC
     C                   ENDIF

     C     AddBespE      ENDSR

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
     C                   EVAL      ERROR = 'ERROR'
     C                   RETURN

     C                   ENDSR

      ********************************************************************
