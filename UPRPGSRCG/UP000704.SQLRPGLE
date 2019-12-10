     H DEBUG
     H COPYRIGHT('(c) Finastra International 2019')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP - Deliverable Data Split Take on')            *
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP000704 - This program update Extension file based on       *
      *             old file.                                         *
      *                                                               *
      *  (c) Finastra International 2019                              *
      *                                                               *
      *  Last Amend No. MD054605   *CREATE   Date 17Oct19             *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD054605 - Deliverable Data Split for SDSVALPD               *
      *                                                               *
      *****************************************************************
     D SQLEOF          C                   Const( 100 )
     D SQLOK           C                   Const( 0 )

     D EXTINDEX        S             10A
     D KXINDEX         S             10A
     D KXSCHEMA        S             10A
     D KMSCHEMA        S             10A
     D KColumn         S             10A
     D KOrdinal        S              9  0
     D KeyArr          S             10A   DIM(12)
     D KeyFld          S            200A
     D SQLDynStmt      S           5000A
     D Outfile         S             10A
     D OFMbr           S             10A
     D OFMbrOpt        S              8A
     D First           S              1A
     D FldData       E DS                  EXTNAME(UPFFDSTPD)
     D ReturnCode      S              1
     D ReturnData      S            180
     D Library         S             10
     D ObjectType      S             10
       /EJECT
      *****************************************************************
      *                                                               *
      *  MAIN PROCESSING                                              *
      *                                                               *
      *****************************************************************

     C     *ENTRY        PLIST
     C                   PARM                    XINDEX           10
     C                   PARM                    MBROVR           10
     C                   PARM                    KXINDEX

      * Retrieve key fields
     C                   exsr      SR_RtvKeys

      * Retrieve fields in extension file
     C                   exsr      SR_RtvExt

     C                   Seton                                        LR
     C                   Return

      *****************************************************************

      * SR_RtvKeys - Retrieve key fields

      *****************************************************************
     C     SR_RtvKeys    BEGSR

     C                   eval      KXINDEX = %SUBST(XINDEX:1:5) + 'JI0'
     C                   CALL      'UTRTVOBJD'
     C                   PARM                    KXINDEX
     C                   PARM      '*LIBL'       Library
     C                   PARM      '*FILE'       ObjectType
     C                   PARM                    ReturnCode
     C                   PARM                    ReturnData
     C                   IF        ReturnCode = *blank
     C                   eval      KXSCHEMA = %SUBST(ReturnData:39:10)
     C                   ENDIF
      * Retrieve key fields
     C/EXEC SQL
     C+ declare KKCursor insensitive scroll cursor for
     C+ select SYSTEM_COLUMN_NAME, ORDINAL_POSITION from QSYS2/SYSKEYS
     C+ where INDEX_NAME = :KXINDEX and INDEX_SCHEMA = :KXSCHEMA
     C+ order by ORDINAL_POSITION
     C/END-EXEC

     C/EXEC SQL
     C+ open KKCursor
     C/END-EXEC

     C     SQLCODE       IFEQ      SQLOK


     C                   DOU       SQLCODE <> SQLOK
     C                             and SQLCODE = SQLEOF

     C                   If        KOrdinal > 0
     C                   eval      KeyArr(KOrdinal) = KColumn
     C                   ENDIF
     C/EXEC SQL
     C+ fetch next from KKCursor into :KColumn, :KOrdinal
     C/END-EXEC

     C                   ENDDO

     C                   ENDIF

      *
      ** Close cursor fetch
      *
     C/EXEC SQL
     C+ close KKCursor
     C/END-EXEC

     C                   eval      KeyFld = *blanks
     C                   eval      KeyFld = KeyArr(1) + KeyArr(2) + KeyArr(3)
     C                             + KeyArr(4) + KeyArr(5) +KeyArr(6)
     C                             + KeyArr(7) + KeyArr(8) +KeyArr(9)
     C                             + KeyArr(10) + KeyArr(11) +KeyArr(12)

     C                   ENDSR

      *****************************************************************

      * SR_RtvExt - Retrieve fields from EXT file and flag them to be ignored

      *****************************************************************
     C     SR_RtvExt     BEGSR

     C                   eval      SQLDynStmt = *BLANKS
     C                   eval      SQLDynStmt = 'create alias AUTFLDDPD for' +
     C                             ' UTFLDDPD(' +%trim(MBROVR) + ')'

     C/EXEC SQL
     C+ prepare DynSQLStmnt
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ execute DynSQLStmnt
     C/end-exec
     C                   eval      First = 'Y'
     C                   eval      KMSCHEMA = %SUBST(KXSCHEMA:1:3) + 'MLIB'
     C                   eval      EXTINDEX = %SUBST(XINDEX:1:5) + 'XTD'

      ** Call program to produce file field description outfile of extension file
     C                   EVAL      OutFile = 'UDFOLD'
     C                   EXSR      BldOutFile

     C/exec SQL
     C+ declare GetFields cursor for
     C+ select *
     C+ from UDFOLD
     C/end-exec
      *
     C/exec SQL
     C+ open GetFields
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from GetFields
     C+ into :FldData
     C/end-exec
      *
     C                   DOW       SQLCODE = 0

      ** Ignore if field is part of key fields
     C     WHFLDI        SCAN      KeyFld                                 99
     C                   IF        *IN99  = '0'
     C/exec SQL
     C+ update AUTFLDDPD
     C+ set
     C+   FDSEQN = 999
     C+ where FDFILE = :XINDEX and FDRPGN = :WHFLDI
     C/end-exec
     C                   ENDIF
      *
     C/exec SQL
     C+ fetch next
     C+ from GetFields
     C+ into :FldData
     C/end-exec
      *
     C                   ENDDO
      *
     C/exec SQL
     C+ close GetFields
     C/end-exec

     C/exec SQL
     C+ drop alias AUTFLDDPD
     C/end-exec

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
     C                   PARM                    EXTINDEX
     C                   PARM                    KMSCHEMA
     C                   PARM                    OutFile
     C                   PARM      '*FIRST'      OFMbr
     C                   PARM      '*REPLACE'    OFMbrOpt
     C
      *
     C     BldOutFileE   ENDSR
      *
      /EJECT
      *****************************************************************
