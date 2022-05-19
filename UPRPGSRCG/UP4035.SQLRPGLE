     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2022')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*XBI *  OVRDBF FILE(UPOBJCTPD) TOFILE(UPDBRLPD)                      *
/*EXI *  TEXT('Midas UP Bridge DDS sanity report')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Upgrade Module                                       *
      *                                                               *
      *  UP4035 - This program run the sanity DDS report              *
      *                                                               *
      *  (c) Finastra International Limited 2022                      *
      *                                                               *
      *  Last Amend No. MD059732 *CREATE   Date 05May22               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD059732 - DDS improvements, report conflict only            *
      *                                                               *
      *****************************************************************
     FUP4035P1  O    E             PRINTER OFLIND(*IN37)
      /EJECT

     D Recursive       S              1

     D                 DS

      /SPACE 3

      ** API used for adding a validation list entry
     D OpenAPI         PR                  EXTPGM('QSYOLVLE')
     D  theRCVR                            LIKE(RCVR)
     D  theRCVRL                           LIKE(RCVRL)
     D  theLIST                            LIKE(LIST)
     D  theNRR                             LIKE(NRR)
     D  theFORMAT                          LIKE(FMT)
     D  theVLDL                            LIKE(VLDL)
     D  thequsec                           LIKE(QUSEC)

     D RCVR            DS
     D RCVRx                      29999A
     D RCVRL           DS
     D RCVRLx                         4B 0 INZ(9999)
      * 2-"Attribute" information.
     D LIST            DS
      * Number of attributes
      * Total records
     D  TotRec                 1      4B 0 INZ(0)
      * Records returned
     D  RecsRetn               5      8B 0 INZ(0)
      * Request handle
     D  ReqHdl                 9     12B 0 INZ(0)
      * Record length
     D  RecLength             13     16B 0 INZ(0)
      * Information complete indicator
     D  InfComInd             17     17
      * Date and time created
     D  DateTimeCr            18     30
      * List status indicator
     D  ListStsInd            31     31
      * Reserved
     D  Res1                  32     32
      * Length of information returned
     D  LengthInf             33     36B 0 INZ(0)
      * First record in buffer
     D  FirstRec              37     40B 0 INZ(0)
      * Reserved
     D  Res2                  41     68

     D NRR             S              4B 0 INZ(2000)
     D FMT             S              8A   INZ('VLDE0100')
     D DDSF            S             10A
     D UPCTDC          S              5  0
     D UPCTDB          S              5  0
     D UPCTDX          S              5  0
     D UPXTDD          S              5  0
     D UPXTDC          S              5  0
     D UPXTDB          S              5  0
     D UPDUPL          S              5  0
     D SQLDynStmt      S           5000A
     D XSCHEMA         S             10A
     D BSCHEMA         S             10A
     D XINDEX          S             10A
     D XINDEXB         S             10A
     D EXTINDEX        S             10A
     D KXINDEX         S             10A
     D KXSCHEMA        S             10A
     D KColumn         S             10A
     D KOrdinal        S              9  0
     D KeyArr          S             10A   DIM(12)
     D KeyFld          S            200A
     D WHERE           S            600A
     D WIdx            S              3P 0

     D XumbEnt         S             10  0
     D XumbRec         S             10  0

     D VLDL            DS                  ALIGN
     D   ValidList                   10A
     D   Library                     10A

     DQUSEC            DS
      * Bytes Provided.
     D QUSBPRV                       10I 0 INZ(%SIZE(QUSEC))
      * Bytes Available.
     D QUSBAVL                       10I 0 INZ(*ZEROS)
      * Exception ID.
     D QUSEI                          7
      * Reserved.
     D                                1
      * Message data.
     D MSDDATA                      500
     D PReturnCode                   20A
     D SQLEOF          C                   Const( 100 )
     D SQLOK           C                   Const( 0 )
     **************************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    Prfx              2
     C                   PARM                    LAYER             7
     C                   PARM                    MODE              4
     C                   PARM                    RtnFl             1

     C                   If        LAYER = '*GLOBAL'
     C                   eval      XSCHEMA = Prfx + 'GTALIB'
     C                   eval      BSCHEMA = Prfx + 'GMLIB'
     C                   else
     C                   eval      XSCHEMA = Prfx + 'DTALIB'
     C                   eval      BSCHEMA = Prfx + 'DMLIB'
     C                   endif

     C                   setoff                                       72
     C                   If        MODE = '*UPD'
     C                   seton                                        72
     C                   Endif
      * Write main page header.
     C                   eval      R_LAYER = %trim(LAYER) + ' (' + Prfx + ')'

      * Write main page header.
     C                   WRITE     HEADH
     C                   WRITE     HEADER

      * Read log file and process for each entry
     C/exec SQL
     C+ declare CursorRdG cursor for
     C+ select WHRFI
     C+ from UPOBJCTPD
     C+ order by WHRFI
     C/end-exec
      *
     C/exec SQL
     C+ open CursorRdG
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from CursorRdG
     C+ into :DDSF
     C/end-exec

     C                   DOW       SQLCODE = 0

      * Retrieve details
     C                   EXSR      RTV_DDS

      * If records are found print details
     C                   EXSR      Details


      * Read next record.
     C/exec SQL
     C+ fetch next
     C+ from CursorRdG
     C+ into :DDSF
     C/end-exec

      *
     C                   ENDDO
      *
      * Write trailer and end program.
     C                   WRITE     TRAILP
      *
     C/exec SQL
     C+ close CursorRdG
     C/end-exec

     C     ENDPGM        TAG
     C                   EVAL      *INLR = *ON
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      * Details -                                                     *
      *                                                               *
      *****************************************************************
     C     Details       BEGSR

     C                   clear                   DETAIL


      * If overflow on then write header.
     C                   IF        *IN37 = *ON
     C                   WRITE     HEADH
     C                   WRITE     HEADER
     C                   EVAL      *IN37 = *OFF
     C                   ENDIF

     C                   eval      R_FILE =  DDSF
     C                   eval      R_CTD  =  %char(UPCTDC)
     C                   eval      R_BTD  =  %char(UPCTDB)
     C                   eval      R_XTD  =  %char(UPCTDX)

      ** print error !! is CTD + BTD <> XTD
     C                   setoff                                       7071
     C                   if        UPCTDC + UPCTDB <> UPCTDX
     C                   seton                                        70
     C                   eval      R_ERR = 'Number of records in XTD' +
     C                             ' does not match sum of CTD and BTD' +
     C                             ' records'
     C                   ENDIF

      ** If features, check password
     C                   IF        %subst(DDSF:3:3) = 'SRD'

     C                   IF        Layer = '*GLOBAL'
     C                   EVAL      ValidList = 'GPFEATVL'
     C                   else
     C                   EVAL      ValidList = 'SCFEATVL'
     C                   endif
     C                   EVAL      Library  = '*LIBL'

      ** retrieve VLDL number of entries
     C                   EVAL      QUSEI = *BLANKS
     C                   CALLP     OpenAPI(RCVR:RCVRL:LIST:NRR:FMT:
     C                             VLDL:QUSEC)
     C                   IF        QUSEI <> *BLANKS
     C                   EVAL      PReturnCode = QUSEI
     C                   ELSE
     C                   EVAL      PReturnCode = *BLANKS
     C                   EVAL      XumbEnt = TotRec
     C                   ENDIF

      ** and retrieve number of features
     C                   IF        Layer = '*GLOBAL'
     C/exec SQL
     C+ select count(*) into :XumbRec
     C+ from GPSRDXTD
     C/end-exec
     C                   else
     C/exec SQL
     C+ select count(*) into :XumbRec
     C+ from SCSRDXTD
     C/end-exec
     C                   endif

      ** compare both and print error if different
     C                   if        XumbRec <> XumbEnt
     C                   seton                                        71
     C                   ENDIF

     C                   ENDIF

      ** if duplicate report error
     C                   IF        UPDUPL > 0
     C                   seton                                        71
     C                   ENDIF

      ** If mode is *AUD, report all DDS table
     C                   If        MODE = '*AUD'
     C                   WRITE     DETAIL
     C   70              WRITE     ERROR

      ** compare both and print error if different
     C                   IF        %subst(DDSF:3:3) = 'SRD'
     C                   if        XumbRec <> XumbEnt
     C                   eval      R_ERR = 'There seems to be missing' +
     C                             ' passwords in the validation list: ' +
     C                             'in file: ' + %char(XumbRec) + ' vs in' +
     C                             ' validation list: ' + %char(XumbEnt)
     C                   WRITE     ERROR
     C                   ENDIF
     C                   ENDIF

      ** if duplicate report error
     C                   IF        UPDUPL > 0
     C                   eval      R_ERR = 'There are ' + %trim(%char(UPDUPL)) +
     C                             ' duplicate recor' +
     C                             'ds. These are both in CTD and in BTD'
     C                   WRITE     ERROR
     C                   ENDIF

     C                   else
      ** If mode is *UPD, report only the tables for which error was found
     C                   If        *IN70 = *ON or *IN71 = *ON
     C                   seton                                        72
      ** call update program
     C                   call      'UP000716'
     C                   parm                    ERR              10
     C                   parm                    XINDEX
     C                   parm                    XSCHEMA
     C     UPXTDD        parm      *zero         xSDelCnt          5 0
     C     UPXTDC        parm      *zero         xSAdXCCnt         5 0
     C     UPXTDB        parm      *zero         xSAdXBCnt         5 0
     C                   parm      *zero         xSDelDup          5 0

     C                   IF        ERR <> ' '
     C                   exsr      *PSSR
     C                   ENDIF

     C                   eval      R_DEL  =  %char(UPXTDD)
     C                   eval      R_XAC  =  %char(UPXTDC)
     C                   eval      R_XAB  =  %char(UPXTDB)
     C                   eval      R_DUP  =  %char(xSDelDup)
     C                   WRITE     DETAIL
     C   70              WRITE     ERROR

      ** compare both and print error if different
     C                   IF        %subst(DDSF:3:3) = 'SRD'
     C                   if        XumbRec <> XumbEnt
     C                   eval      R_ERR = 'There seems to be missing' +
     C                             ' passwords in the validation list: ' +
     C                             'in file: ' + %char(XumbRec) + ' vs in' +
     C                             ' validation list: ' + %char(XumbEnt)
     C                   WRITE     ERROR
     C                   ENDIF
     C                   ENDIF

      ** if duplicate report error
     C                   IF        UPDUPL > 0
     C                   eval      R_ERR = 'There are ' + %trim(%char(UPDUPL)) +
     C                             ' duplicate recor' +
     C                             'ds. These are both in CTD and in BTD'
     C                   WRITE     ERROR
     C                   ENDIF

      ** for COB only
     C                   IF        %subst(DDSF:1:3) = 'CBCMP'
     C                             or  %subst(DDSF:1:3) = 'CBDPR'
     C                   eval      R_ERR = 'Use COBMENU to validate' +
     C                             ' components/dependencies'
     C                   WRITE     ERROR
     C                   ENDIF

     C                   ENDIF

     C                   endif

     C     DetailsE      ENDSR


      /EJECT

      ********************************************************************
     C     RTV_DDS       BEGSR

     C                   eval      XINDEX = DDSF
     C                   eval      XINDEXB = %SUBST(XINDEX:1:5) + 'BTD'
     C                   eval      EXTINDEX = %SUBST(XINDEX:1:5) + 'XTD'
      * Retrieve key fields
     C                   exsr      SR_RtvKeys

     C                   eval      WIdx = 1
     C                   eval      WHERE = *BLANKS
     C                   eval      WHERE = ' WHERE A.' + %trimr(KeyArr(WIdx)) +
     C                             ' = B.' + %trimr(KeyArr(WIdx))
     C                   eval      WIdx = WIdx + 1

     C     KeyArr(WIdx)  DOWNE     *BLANKS
     C     WIdx          ANDLT     13
     C                   eval      WHERE = %trimr(WHERE) + ' and A.' +
     C                             %trimr(KeyArr(WIdx)) +
     C                             ' = B.' + %trimr(KeyArr(WIdx))
     C                   eval      WIdx = WIdx + 1
     C                   ENDDO

     C                   eval      SQLDynStmt = 'select count(*) from ' +
     C                             %trimr(XSCHEMA) + '/' +
     C                             %trimr(XINDEX)

     C/EXEC SQL
     C+ prepare DynSQLStmnt
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ declare C1 cursor with return to client for DynSQLStmnt
     C/end-exec

     C/EXEC SQL
     C+ open C1
     C/END-EXEC

     C/EXEC SQL
     C+ fetch C1 into :UPCTDC
     C/END-EXEC

     C/EXEC SQL
     C+ close C1
     C/END-EXEC


     C                   eval      SQLDynStmt = 'select count(*) from ' +
     C                             %trimr(BSCHEMA) + '/' +
     C                             %trimr(XINDEXB)

     C/EXEC SQL
     C+ prepare DynSQLStmnt2
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ declare C2 cursor with return to client for DynSQLStmnt2
     C/end-exec

     C/EXEC SQL
     C+ open C2
     C/END-EXEC

     C/EXEC SQL
     C+ fetch C2 into :UPCTDB
     C/END-EXEC

     C/EXEC SQL
     C+ close C2
     C/END-EXEC

     C                   eval      SQLDynStmt = 'select count(*) from ' +
     C                             %trimr(BSCHEMA) + '/' +
     C                             %trimr(EXTINDEX)

     C/EXEC SQL
     C+ prepare DynSQLStmnt3
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ declare C3 cursor with return to client for DynSQLStmnt3
     C/end-exec

     C/EXEC SQL
     C+ open C3
     C/END-EXEC

     C/EXEC SQL
     C+ fetch C3 into :UPCTDX
     C/END-EXEC

     C/EXEC SQL
     C+ close C3
     C/END-EXEC

      ** Report duplicate records (the ones in both CTD and BTD)
     C                   eval      SQLDynStmt = 'select count(*) from ' +
     C                             %trimr(XSCHEMA) + '/' + XINDEX +
     C                             ' A where     exists (select * from ' +
     C                             %trimr(BSCHEMA) + '/' + XINDEXB +
     C                             ' B ' +  %trimr(WHERE) + ')'

     C/EXEC SQL
     C+ prepare DynSQLStmnt4
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ declare C4 cursor with return to client for DynSQLStmnt4
     C/end-exec

     C/EXEC SQL
     C+ open C4
     C/END-EXEC

     C/EXEC SQL
     C+ fetch C4 into :UPDUPL
     C/END-EXEC

     C/EXEC SQL
     C+ close C4
     C/END-EXEC

     C                   ENDSR
      ********************************************************************
      /EJECT
      *****************************************************************

      * SR_RtvKeys - Retrieve key fields

      *****************************************************************
     C     SR_RtvKeys    BEGSR

     C                   eval      KXINDEX = %SUBST(XINDEX:1:5) + 'JI0'
     C                   eval      KXSCHEMA = %SUBST(XSCHEMA:1:3) + 'VLIB'
     C                   clear                   KeyArr
     C                   eval      KOrdinal = 0
     C                   eval      KColumn = *blanks
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
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR SR **
      *
     C     Recursive     IFEQ      *BLANK
     C                   EVAL      Recursive = 'Y'
     C                   DUMP
     C                   END
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *
     C                   ENDSR
      *
      ********************************************************************
