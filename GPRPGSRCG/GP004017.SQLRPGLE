     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas GP Event Group Audit Report')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GP004017 - Event Group Audit Report                          *
      *                                                               *
      *  Function: Produce Midas GP Event Group Audit Report          *
      *                                                               *
      *  Called By: GOC004017 - Event Group Audit Report              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. CBF023             Date 04Jan17               *
      *  Prev Amend No. AR1097353          Date 26Mar13               *
      *                 AR1036892          Date 27Sep12               *
      *                 AR1029156          Date 06Sep12               *
      *                 AR1029150          Date 06Sep12               *
      *                 AR1028208          Date 05Sep12               *
      *                 AR1027797          Date 03Sep12
      *                 AR1025965          Date 31Aug12               *
      *                 CBF022  *CREATE    Date 16Jul12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CBF023 - Soft Delete Feature on Security Related Modules     *
      *  AR1097353 - No Event code Audit Report was generated.        *
      *              Additional fix for AR1096060.                    *
      *  AR1036892 - Transaction not approved during CoB run and      *
      *              consequently approved after CoB did not appear   *
      *              in the report                                    *
      *  AR1029156 -  Change Timestamp has a value on newly inserted  *
      *               transaction                                     *
      *  AR1029150 - Event Codes without description is not displayed *
      *              in the report                                    *
      *  AR1028208 - There is a value in fields "Change Date" and     *
      *              "Change Timestamp" when action is Insert         *
      *  AR1027797 - The target for a numeric operation is too small  *
      *              to hold the result                               *
      *  AR1025965 - Unable to view the expected fields               *
      *  CBF022 - BF Infrastructure: Auditability                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      * *INZSR    - Program Initialisation                            *
      * *PSSR     - Error handling subroutine                         *
      * SrFetch   - Subroutine to Fetch Record from File              *
      * SrPrint   - Subroutine to Print the Record on the Main PRTF   *
      * SrPrint2  - Subroutine to Print the Secondary Details
      * SrOvrFlw  - Subroutine to check for overflow                  *
      * SrEnd     - Subroutine to Close the Main PRTF of the Report   *
      * SrAudit   - Subroutine to Print the Audit of the Report       *
      * SrConvdat - Subroutine to Convert Date from Timestamp to      *
      *              YYYYMMDD                                         *
      **SrZdateO**-*Subroutine*to*Convert*from*DDMMYY*to*Midas*Runday**                    AR1097353
      * SrZdateO  - Subroutine to Convert from YYYYMMDD to Midas Day  *                    AR1097353
      *              Number                                           *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-Specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Midas GP Event Group Audit Report
     FGP004017P1O    E             PRINTER USROPN
     F                                     INFSR(*PSSR)
     F                                     INFDS(SPOOL1)

      ** Midas GP Event Group Audit Report - Audit
     FGP004017AUO    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOLU)

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ External Data Areas                  ¦
      ** ¦ ===================                  ¦
      ** +--------------------------------------+
      *
      ** Midas Local Data Area for Database Error Reporting; Based on
      ** External File
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      ** The following fields are defined in the external file:
      **                                    134 141 DBFile
      **                                    142 170 DBKey
      **                                    171 180 DBPgm
      **                                    181 1830DBase
      **                                    184 193 DBMod
      **                                    194 203 DBProc
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** External DS for Bank Details
     D GZSDBANK      E DS                  EXTNAME(GZSDBANKPD)

      ** External DS for SAR Details                                                          CBF023
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CBF023
                                                                                              CBF023
      ** Short DS for Access Objects                                                          CBF023
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CBF023

      ** File Information DS for Main PRTF
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0

      ** File Information DS for Audit PRTF
     D SPOOLU          DS
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0

     D EvtDesDs        DS           502
     D  EvDes1                 1     85A
     D  EvDes2                86    170A
     D  EvDes3               171    255A
     D  EvDes4               256    340A
     D  EvDes5               341    425A
     D  EvDes6               426    502A

     D EvtModDs        DS           102
     D  EvMod1                 1     17A
     D  EvMod2                18     34A
     D  EvMod3                35     51A
     D  EvMod4                52     68A
     D  EvMod5                69     85A
     D  EvMod6                86    102A

     D EvtGrpDs        DS
     D  BFEVTGRP                    102A
     D  BFSHODES                    102A
     D  BFCDENUM                      9A
     D  BFEVCDES                    502A
     D  BFHOSMOD                    102A
     D  BFMODDBY                     32A
     D  BFCRTDBY                     32A
     D  BFLSTMOD                     26A
     D  BFRCRTON                     26A
     D  BFRAPRBY                     32A
     D  BFAPRDAT                     26A
     D  BFDELDAT                     26A                                                      CBF023

     D*NullIndDs       S              5I 0 DIM(11)                                            CBF023
     D NullIndDs       S              5I 0 DIM(12)                                            CBF023

      ** Input Parameter for ZDATEO

     D                 DS
     D PDateIn                 1      8  0

     D**ZDate***        S              6  0                                                AR1097353
     D ZDate           S              8S 0                                                 AR1097353
     D ZDayNo          S              5  0
     D ZError          S              2  0

     D ZDayNo3         S              5P 0
     D ZDayNo4         S              5P 0

      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Parameters for ZSFILE

     D PZSEnty         S              3
     D PZSFile         S             10
     D PZSNum          S              6  0
     D PZSErr          S              1
     D PZSSeq          S              5A

      ** Parameters for Access Programs

     D POption         S              7A
     D PRetCode        S              7A
     D PZone           S             10A
     D PErms           S             50A
     D PCache          S              1A
     D PRecImage       S          32000A
     D PSard           S              6A                                                      CBF023

      ** Other Work Variables

     D WRun            S              1A
     D Error           S              1A
     D wFlag           S              1A
     D*WFlgCtr**       S              3  0                                                 AR1027797
     D WFlgCtr         S              6  0                                                 AR1027797
     D wEvtGrp         S            102A
     D wZone           S             10A

     D WFirst          S              1    INZ('Y')
     D wNoRec          S              4S 0
     D RqdLn1          S              3  0
     D DifLn1          S              3  0

     D**TmpDat03        S               D   DATFMT(*DMY)                                   AR1097353
     D TmpDat03        S               D   DATFMT(*ISO)                                    AR1097353
     D DatNum03        S              8S 0

     D**TmpDat04        S               D   DATFMT(*DMY)                                   AR1097353
     D TmpDat04        S               D   DATFMT(*ISO)                                    AR1097353
     D DatNum04        S              8S 0

     D CBF023          S              1A                                                      CBF023
      ** +--------------------------------------+
      ** ¦ Declared Constants                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D wNoEvcd         S              9A   INZ('*********')
     D wNoDesc         S             85A   INZ('No Event Code Allocated')

      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************

      ** Read All Records from the Result Set of the SQL Statement

     C/exec sql
     C+ declare mainCursor Cursor
     C+  for select
     C+   A.BFEVENTGROUPIDPK,
     C+   A.BFEVENTGRPSHORTDESC,
     C+   C.BFEVENTCODENUMBER,
     C+   C.BFDESCRIPTION,
     C+   C.BFHOSTMODULEID,
     C+   A.BFRECLASTMODIFIEDBY,
     C+   A.BFRECCREATEDBY,
     C+   A.BFRECLASTMODIFIEDDATE,
     C+   A.BFRECCREATEDON,
     C+   A.BFRECAPPROVEDBY,
     C****A.BFRECAPPROVEDDATE******************************************                       CBF023
     C+   A.BFRECAPPROVEDDATE,                                                                CBF023
     C+   A.BFRECDELETETDATE                                                                  CBF023
     C+
     C+   from MIVW_EVGP A
     C+   left outer join MIVW_EVGA B on B.BFEVENTGROUPID = A.BFEVENTGROUPIDPK
     C+   left outer join MIVW_EVCD c on C.BFEVENTCODENUMBER =  B.BFEVENTCODEID
     C+
     C+  where
     C+   A.BFRECLASTMODIFIEDDATE is not null or
     C+   A.BFRECCREATEDON is not null
     C+
     C+   order by
     C+   A.BFEVENTGROUPIDPK,
     C+   A.BFEVENTGRPSHORTDESC,
     C+   C.BFEVENTCODENUMBER
     C/end-exec

     C/exec sql
     C+ open mainCursor
     C/end-exec

      ** Read First Record

     C                   EXSR      SrFetch

     C                   DOW       %SUBST(SQLSTT:1:2) = '00' OR
     C                             %SUBST(SQLSTT:1:2) = '01'
     C                   EXSR      SrConvDat

     C**********         IF        ZDayNo3  = BJRDNB OR                                    AR1036892
     C**********                   (ZDayNo4 = BJRDNB AND                                   AR1036892
     C**********                   ZDayNo3  = 0)                                           AR1036892
     C                   IF        ZDayNo4  = BJRDNB                                       AR1036892

      ** If Different Event Group

     C                   IF        BFEVTGRP <> wEvtGrp
     C                   EVAL      wFlag   = ' '
     C                   EVAL      wFlgCtr = 0
     C                   EVAL      WnoRec  = WnoReC+ 1
     C                   EXSR      SrPrint
     C                   ENDIF

     C                   EVAL      EvtDesDs = BFEVCDES
     C                   EVAL      EvtModDs = BFHOSMOD
     C                   EXSR      SrPrint2
     C                   ENDIF

     C                   EXSR      SrFetch
     C                   ENDDO

     C                   EXSR      SrEnd

     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrFetch - Subroutine to Fetch Record from File                *
      *                                                               *
      *****************************************************************
     C     SrFetch       BEGSR

     C/exec sql
     C+  fetch next
     C+   from mainCursor
     C+  into :EvtGrpDs indicator :NULLINDDS
     C/end-exec

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrPrint - Subroutine to Print the Record on the Main PRTF     *
      *                                                               *
      *****************************************************************
     C     SrPrint       BEGSR

      ** Open Report File

     C                   IF        NOT %OPEN(GP004017P1)
     C                   OPEN      GP004017P1
     C                   ENDIF

     C                   CALL      'ZSFILE'
     C                   PARM                    PZSSeq
     C                   PARM      *BLANKS       PZSEnty
     C                   PARM      SFILE1        PZSFile
     C                   PARM      SFNUM1        PZSNum
     C                   PARM      *BLANK        PZSErr

     C                   IF        PZSERR = 'Y'
     C                   EVAL      DBASE  = 2
     C                   EVAL      DBFILE = 'ZSFILE'
     C                   MOVE      PZSNUM        DBKEY
     C                   EVAL      Error = 'Y'
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   CLEAR                   DETAIL1                                   AR1028208
     C                   WRITE     HEADP1
     C                   EVAL      WFIRST = 'Y'

      ** Last Change User

     C                   IF        BFMODDBY <> *BLANKS
     C                   EVAL      RUSER  = BFMODDBY
     C                   ELSE
     C                   EVAL      RUSER  = BFCRTDBY
     C                   ENDIF

      ** Change Date

     C                   IF        BFDELDAT <> '0'                                            CBF023
     C                             AND CBF023 = 'Y'                                           CBF023
     C                   IF        NullIndDs(8) = 0                                           CBF023
     C                   EVAL      RCDAT = BFLSTMOD                                           CBF023
     C                   ENDIF                                                                CBF023
     C                   ELSE                                                                 CBF023
                                                                                              CBF023
     C                   IF        BFLSTMOD <> *BLANKS
     C                   IF        NullIndDs(8) = 0
     C                   EVAL      RCDAT = BFLSTMOD
     C                   ENDIF
     C                   ELSE
     C                   IF        NullIndDs(9) = 0
     C                   EVAL      RCDAT = BFRCRTON
     C                   ENDIF
     C                   ENDIF
                                                                                              CBF023
     C                   ENDIF                                                                CBF023

      ** Change Timestamp

     C                   IF        BFDELDAT <> '0'                                            CBF023
     C                             AND CBF023 = 'Y'                                           CBF023
     C                   IF        NullIndDs(8) = 0                                           CBF023
     C                   EVAL      RTIME = BFLSTMOD                                           CBF023
     C                   ENDIF                                                                CBF023
     C                   ELSE                                                                 CBF023
                                                                                              CBF023
     C                   IF        BFLSTMOD <> *BLANKS
     C                   IF        NullIndDs(8) = 0                                        AR1029156
     C                   EVAL      RTIME = BFLSTMOD
     C                   ENDIF                                                             AR1029156
     C                   ELSE
     C                   IF        NullIndDs(9) = 0                                        AR1029156
     C                   EVAL      RTIME = BFRCRTON
     C                   ENDIF                                                             AR1029156
     C                   ENDIF
                                                                                              CBF023
     C                   ENDIF                                                                CBF023

      ** Last Change Action

     C                   IF        BFDELDAT <> '0'                                            CBF023
     C                             AND CBF023 = 'Y'                                           CBF023
     C                   EVAL      RACTN = 'Delete'                                           CBF023
     C                   ELSE                                                                 CBF023
     C                   IF        ZDayNo3 = 0
     C                   EVAL      RACTN = 'Insert'
     C                   ELSE
     C                   EVAL      RACTN = 'Amend'
     C                   ENDIF
     C                   ENDIF                                                                CBF023

      ** Last Authorising User

     C                   EVAL      RAUTH = BFRAPRBY

      ** Authorisation Date

     C                   IF        NullIndDs(11) = 0
     C                   EVAL      RAUDT = BFAPRDAT
     C                   ENDIF

      ** Authorisation Timestamp

     C                   IF        NullIndDs(11) = 0                                       AR1028208
     C                   EVAL      RATIM = BFAPRDAT
     C                   ENDIF                                                             AR1028208

      ** Event Group

     C                   EVAL      REGRP = BFEVTGRP

      ** Event Group Name

     C                   EVAL      RENAM = BFSHODES

     C                   EVAL      wEvtGrp = BFEVTGRP
                                                                                           AR1027797
      ** Write Event Group Details to Report                                               AR1027797
                                                                                           AR1027797
     C                   WRITE     DETAIL1

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrPrint2 - Subroutine to Print the Secondary Details          *
      *                                                               *
      *****************************************************************
     C     SrPrint2      BEGSR

     C                   IF        BFCDENUM <> '0'
     C                   EVAL      REVID = BFCDENUM

     C**********         IF        EvDes1 <> ' ' OR                                        AR1029150
     C**********                   EvMod1 <> ' '                                           AR1029150
     C                   EVAL      REDES  = EvDes1
     C                   EVAL      RMODU  = EvMod1
     C                   EXSR      SrOvrFlw
     C                   WRITE     DETAIL2
     C**********         ENDIF                                                             AR1029150

     C                   EVAL      REVID = ' '

     C**********         IF        EvDes2 <> ' ' OR                                        AR1029150
     C**********                   EvMod2 <> ' '                                           AR1029150
     C                   EVAL      REDES  = EvDes2
     C                   EVAL      RMODU  = EvMod2
     C                   EXSR      SrOvrFlw
     C                   WRITE     DETAIL2
     C**********         ENDIF                                                             AR1029150

     C**********         IF        EvDes3 <> ' ' OR                                        AR1029150
     C**********                   EvMod3 <> ' '                                           AR1029150
     C                   EVAL      REDES  = EvDes3
     C                   EVAL      RMODU  = EvMod3
     C                   EXSR      SrOvrFlw
     C                   WRITE     DETAIL2
     C**********         ENDIF                                                             AR1029150

     C**********         IF        EvDes4 <> ' ' OR                                        AR1029150
     C**********                   EvMod4 <> ' '                                           AR1029150
     C                   EVAL      REDES  = EvDes4
     C                   EVAL      RMODU  = EvMod4
     C                   EXSR      SrOvrFlw
     C                   WRITE     DETAIL2
     C**********         ENDIF                                                             AR1029150

     C**********         IF        EvDes5 <> ' ' OR                                        AR1029150
     C**********                   EvMod5 <> ' '                                           AR1029150
     C                   EVAL      REDES  = EvDes5
     C                   EVAL      RMODU  = EvMod5
     C                   EXSR      SrOvrFlw
     C                   WRITE     DETAIL2
     C**********         ENDIF                                                             AR1029150

     C**********         IF        EvDes6 <> ' ' OR                                        AR1029150
     C**********                   EvMod6 <> ' '                                           AR1029150
     C                   EVAL      REDES  = EvDes6
     C                   EVAL      RMODU  = EvMod6
     C                   EXSR      SrOvrFlw
     C                   WRITE     DETAIL2
     C**********         ENDIF                                                             AR1029150

     C                   EVAL      WFlgCtr = WFlgCtr + 1
     C                   ELSE

     C                   IF        wFlag <> 'Y'
     C                             AND WFlgCtr < 1
     C                   EVAL      REDES = ' '
     C                   EVAL      RMODU = ' '

     C                   EVAL      REVID = wNoEvcd
     C                   EVAL      REDES = wNoDesc
     C                   EVAL      wFlag =  'Y'
     C                   EXSR      SrOvrFlw
     C                   WRITE     DETAIL2
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrOvrFlw - Subroutine to Check for Overflow                   *
      *                                                               *
      *****************************************************************
     C     SrOvrFlw      BEGSR

     C                   EVAL      RqdLn1 = 6
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1

     C                   IF        DifLn1 <= RqdLn1 OR
     C                             WFirst = 'Y'
     C                   WRITE     HEADP2
     C                   EVAL      WFIRST = 'N'
     C                   ENDIF

     C                   EVAL      RqdLn1 = 10                                             AR1027797
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1                                AR1027797
                                                                                           AR1027797
     C                   IF        DifLn1 <= RqdLn1 AND
     C                             WFirst = 'N'
     C                   WRITE     HEADP1
     C                   WRITE     HEADP2
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrEnd - Subroutine to Close the Main PRTF or the Report       *
      *                                                               *
      *****************************************************************
     C     SrEnd         BEGSR

      ** Close P1 and Write Trailer Record Format

     C                   IF        %OPEN(GP004017P1)

     C**********         EVAL      RqdLn1 = 4                                              AR1027797
     C                   EVAL      RqdLn1 = 6                                              AR1027797
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADP1
     C                   ENDIF

     C                   WRITE     TRAILP1
     C                   CLOSE     GP004017P1
     C                   ENDIF

     C                   EXSR      SRAudit

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrAudit - Subroutine to print the Audit of the report         *
      *                                                               *
      *****************************************************************
     C     SrAudit       BEGSR

     C                   IF        (Error <> 'Y')
     C                   IF        WnoRec = 0

      ** Open and Register AU Report Via RCF

     C                   Z-ADD     SFNUMU        PZSNum

     C                   CALL      'ZSFILE'
     C                   PARM      *BLANKS       PZSSeq
     C                   PARM      *BLANKS       PZSEnty
     C                   PARM      SFILEU        PZSFile
     C                   PARM                    PZSNum
     C                   PARM      *BLANK        PZSErr

     C                   IF        PZSERR = 'Y'
     C                   EVAL      DBASE  = 3
     C                   EVAL      DBFILE = 'ZSFILE'
     C                   MOVE      PZSNUM        DBKEY
     C                   EVAL      Error = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   ENDIF

     C                   WRITE     HEADAU

      ** Write No Details

     C                   WRITE     NODTLS
     C                   ENDIF

     C                   ELSE

      ** Write Database Error

     C                   WRITE     HEADAU
     C                   WRITE     DBERROR

     C                   IF        %OPEN(GP004017P1)
     C                   CLOSE     GP004017P1
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrConvdat - Subroutine to convert date from Timestamp to      *
      *             YYYYMMDD                                          *
      *                                                               *
      *****************************************************************
     C     SrConvdat     BEGSR

     C                   EVAL      ZDayNo3 = 0
     C                   EVAL      ZDayNo4 = 0

     C                   IF        NullIndDs(8) = 0
     C                   EVAL      TmpDat03 = %DATE(%SUBST(BFLSTMOD:1:10):*ISO)
     C                   EVAL      DatNum03 = %DEC(TmpDat03)
     C                   EVAL      PDateIN  = DatNum03
     C                   EXSR      SRZDateO
     C                   Z-ADD     ZDayNo        ZDayNo3
     C                   ENDIF

     C**********         IF        NullIndDs(9) = 0                                        AR1036892
     C**********         EVAL      TmpDat04 = %DATE(%SUBST(BFRCRTON:1:10):*ISO)            AR1036892
     C**********         EVAL      DatNum04 = %DEC(TmpDat03)                               AR1025965
     C                   IF        NullIndDs(11) = 0                                       AR1036892
     C                   EVAL      TmpDat04 = %DATE(%SUBST(BFAPRDAT:1:10):*ISO)            AR1036892
     C                   EVAL      DatNum04 = %DEC(TmpDat04)                               AR1025965
     C                   EVAL      PDateIN  = DatNum04
     C                   EXSR      SRZDateO
     C                   Z-ADD     ZDayNo        ZDayNo4
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      **SrZdateO**-*Subroutine*to*convert*from*DDMMYY*to*Midas*********                    AR1097353
      * SrZdateO  - Subroutine to convert from YYYYMMDD to Midas      *                    AR1097353
      *             Runday Number                                     *
      *                                                               *
      *****************************************************************
     C     SrZDateO      BEGSR

     C**********         CALL      'ZDATEO'                                                AR1097353
     C                   CALL      'ZDATE10'                                               AR1097353
     C                   PARM      PDateIN       ZDate
     C                   PARM                    ZDayNo
     C**********         PARM                    ZError                                    AR1097353

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation Routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    wZone

      ** Initialize Program Name

     C                   EVAL      DBPGM = 'GP004017'

      ** Access Bank Details

     C                   CALL      'GPACSZBNK'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      *BLANKS       PErms
     C                   PARM      wZone         PZone
     C                   PARM      'N'           PCache
     C     GZSDBANK      PARM                    PRecImage

      ** Database Error

     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE  = 1
     C                   EVAL      DBPGM = 'GPACSZBNK'
     C                   EVAL      DBFILE = 'GZSDBANKPD'
     C                   EVAL      DBKEY  = POption
     C                   OUT       LDA
     C                   EVAL      Error = 'Y'
     C                   EXSR      SrAudit
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Check if CBF023 is installed                                                         CBF023
                                                                                              CBF023
     C                   CALL      'AOSARDR0'                                                 CBF023
     C                   PARM      *BLANKS       PRetCode                                     CBF023
     C                   PARM      '*VERIFY'     POption                                      CBF023
     C                   PARM      'CBF023'      PSard                                        CBF023
     C     SCSARD        PARM      SCSARD        DSFDY                                        CBF023
                                                                                              CBF023
     C                   IF        PRetCode <> *BLANKS                                        CBF023
     C                             AND PRetCode <> '*NRF   '                                  CBF023
     C     *LOCK         IN        LDA                                                        CBF023
     C                   EVAL      DBFile = 'SCSARDPD'                                        CBF023
     C                   EVAL      DBKey = PSard                                              CBF023
     C                   EVAL      DBase = 4                                                  CBF023
     C                   OUT       LDA                                                        CBF023
     C                   EXSR      *PSSR                                                      CBF023
     C                   ENDIF                                                                CBF023
                                                                                              CBF023
     C                   EVAL      CBF023 = 'N'                                               CBF023
     C                   IF        PRetCode = *BLANKS                                         CBF023
     C                   EVAL      CBF023 = 'Y'                                               CBF023
     C                   ENDIF                                                                CBF023

     C                   ENDSR
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      *********************************************************************
     C     *PSSR         BEGSR

     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON

     C                   RETURN

     C                   ENDSR
      ********************************************************************
