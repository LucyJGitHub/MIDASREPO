     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas GP Event Code Audit Report')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GP004016 - Midas GP Event Code Audit Report                  *
      *                                                               *
      *  Function: Produce Midas GP Event Code Audit Report           *
      *                                                               *
      *  Called By: GOC004016 - Event Code Audit Report               *
      *                                                               *
      *     (c) Finastra International Limited 2012                   *
      *                                                               *
      *  Last Amend No. MD042109           Date 26Jun18               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CBF023             Date 04Jan17               *
      *                 MD035836A          Date 11May16               *
      *                 MD035836           Date 11May16               *
      *                 AR1097353          Date 26Mar13               *
      *                 AR1096060          Date 21Mar13               *
      *                 AR1036892          Date 27Sep12               *
      *                 AR1028208          Date 05Sep12               *
      *                 AR1028149          Date 04Sep12               *
      *                 AR1025965          Date 31Aug12               *
      *                 CBF022  *CREATE    Date 16Jul12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD042109 - Updates, amendments and deletes do not show on    *
      *             BFTC audit reports                                *
      *  MD046248 - Finastra Rebranding                               *
      *  CBF023 - Soft Delete Feature on Security Related Modules     *
      *  MD035836A - [UXP][UXP API]Application and Module in Event    *
      *              Code Audit Report are not descriptive/readable   *
      *              (Reopen)                                         *
      *  MD035836 - [UXP][UXP API]Application and Module in Event     *
      *             Code Audit Report are not descriptive/readable    *
      *  AR1097353 - No Event code Audit Report was generated.        *
      *              Additional fix for AR1096060.                    *
      *  AR1096060 - GOC004016 failed in Day 1 SG COB                 *
      *  AR1036892 - Transaction not approved during CoB run and      *
      *              consequently approved after CoB did not appear   *
      *              in the report                                    *
      *  AR1028208 - There is a value in fields "Change Date" and     *
      *              "Change Timestamp" when action is Insert         *
      *  AR1028149 - Event Code number field displays only 4 digits   *
      *              instead of 8                                     *
      *  AR1025965 - Unable to view the expected fields               *
      *  CBF022 - BF Infrastructure: Auditability                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      * *INZSR    - Program Initialisation                            *
      * *PSSR     - Error Handling Subroutine                         *
      * SrFetch   - Subroutine to Fetch Record from File              *
      * SrPrint   - Subroutine to Print the Record on the Main PRTF   *
      * SrEnd     - Subroutine to Close the Main PRTF or the Report   *
      * SrAudit   - Subroutine to Print the Audit of the Report       *
      * SrConvdat - Subroutine to Convert Date from Timestamp to      *
      *              YYYYMMDD                                         *
      **SrZdateO**-*Subroutine*to*Convert*from*DDMMYY*to*Midas*Runday**                    AR1097353
      * SrZdateO  - Subroutine to Convert from YYYYMMDD to Midas Day  *                    AR1097353
      *             Number                                            *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Midas GP Event Group Audit Report
     FGP004016P1O    E             PRINTER USROPN
     F                                     INFSR(*PSSR)
     F                                     INFDS(SPOOL1)

      ** Midas GP Event Group Audit Report - Audit
     FGP004016AUO    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOLU)

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ External Data Areas                  ¦
      ** ¦ ===================                  ¦
      ** +--------------------------------------+
      *
      ** Midas Local Data Area for database error reporting; based on
      ** external file
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      ** The following fields are defined in the external file:
      **                                    134 141 RFile
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

     D HandlrDs        DS           102
     D  EvHnd1                 1     51A
     D  EvHnd2                52    102A

     D ApplicDs        DS           102
     D  EvApp1                 1     51A
     D  EvApp2                52    102A

     D ModuleDs        DS           102                                                     MD035836
     D  EvMod1                 1     51A                                                    MD035836
     D  EvMod2                52    102A                                                    MD035836

     D DsgTimDs        DS           502
     D  DsMsg1                 1     85A
     D  DsMsg2                86    170A
     D  DsMsg3               171    255A
     D  DsMsg4               256    340A
     D  DsMsg5               341    425A
     D  DsMsg6               426    502A

     D RunTimDs        DS           502
     D  RuMsg1                 1     85A
     D  RuMsg2                86    170A
     D  RuMsg3               171    255A
     D  RuMsg4               256    340A
     D  RuMsg5               341    425A
     D  RuMsg6               426    502A

     D EvtCodDs        DS
     D  BFEVTCOD                     52A
     D**BFEVTNUM                      4A                                                   AR1028149
     D  BFEVTNUM                     12A                                                   AR1028149
     D  BFEVCDES                    502A
     D  BFCOLLEC                      2A
     D  BFHANDLA                      2A
     D  BFSEVERI                      3A
     D  BFUSRCON                      4A
     D  BFHANDLR                    102A
     D  BFAPLCTN                    102A                                                    MD035836
     D  BFHOSMOD                    102A
     D  BFHMDDSC                    102A                                                    MD035836
     D  BFLOCALE                     12A
     D  BFDSTMMS                    502A
     D  BFRNTMMS                    502A
     D  BFCRTDBY                     32A
     D  BFRCRTON                     26A
     D  BFMODDBY                     32A
     D  BFLSTMOD                     26A
     D  BFRAPRBY                     32A
     D  BFAPRDAT                     26A
     D  BFDELDAT                     26A                                                      CBF023

     D*NullIndDs       S              5I 0 DIM(18)                                         MD035836A
     D*NullIndDs       S              5I 0 DIM(20)                                  MD035836A CBF023
     D NullIndDs       S              5I 0 DIM(21)                                            CBF023

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
     D wEvtCod         S             52A
     D wZone           S             10A

     D WFirst          S              1    INZ('Y')
     D wNoRec          S              4S 0
     D RqdLn1          S              3  0
     D DifLn1          S              3  0

     D*TmpDat03*       S               D   DATFMT(*DMY)                                    AR1096060
     D TmpDat03        S               D   DATFMT(*ISO)                                    AR1096060
     D DatNum03        S              8S 0

     D*TmpDat04*       S               D   DATFMT(*DMY)                                    AR1096060
     D TmpDat04        S               D   DATFMT(*ISO)                                    AR1096060
     D DatNum04        S              8S 0

     D CBF023          S              1A                                                      CBF023
      ** +--------------------------------------+
      ** ¦ Declared Constants                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************

      ** Read All Records from the Result Set of the SQL Statement

     C/exec sql
     C+ declare mainCursor Cursor
     C+  for select
     C+  A.BFEVENTCODEIDPK,
     C+  A.BFEVENTCODENUMBER,
     C+  A.BFDESCRIPTION,
     C+  A.BFCOLLECTIBLE,
     C+  A.BFHANDLEABLE,
     C+  A.BFSEVERITY,
     C+  A.BFUSERCONFIGURABLE,
     C+  A.BFHANDLER,
     C+  D.BFHOSTSHORTNAME,                                                                 MD035836
     C+  C.BFHOSTMODULEIDPK,
     C+  C.BFHOSTMODULESHORTNAME,                                                           MD035836
     C+  B.BFLOCALE,
     C+  B.BFDESIGNTIMEMESSAGE,
     C+  B.BFRUNTIMEMESSAGE,
     C+  A.BFRECCREATEDBY,
     C+  A.BFRECCREATEDON,
     C+  A.BFRECLASTMODIFIEDBY,
     C+  A.BFRECLASTMODIFIEDDATE,
     C+  A.BFRECAPPROVEDBY,
     C***A.BFRECAPPROVEDDATE*******************************************                       CBF023
     C+  A.BFRECAPPROVEDDATE,                                                                 CBF023
     C+  A.BFRECDELETETDATE                                                                   CBF023
     C+
     C+  from MIVW_EVCD A
     C+  left outer join MIVW_EVCM B on B.BFEVENTCODEID=A.BFEVENTCODEIDPK
     C+  left outer join MIVW_HOSM C on C.BFHOSTMODULEIDPK=A.BFHOSTMODULEID
     C+  left outer join MIVW_HOST D on D.BFHOSTIDPK=C.BFHOSTID
     C+
     C+  where
     C+   A.BFRECLASTMODIFIEDDATE is not null or
     C+   A.BFRECCREATEDON is not null
     C+
     C+  order by
     C+  A.BFEVENTCODEIDPK,
     C+  A.BFEVENTCODENUMBER,
     C+  A.BFDESCRIPTION
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

     C                   IF        BFEVTCOD <> wEvtCod
     C                   EVAL      wNoRec   = wNoRec + 1
     C                   EVAL      EvtDesDs = BFEVCDES
     C                   EVAL      HandlrDs = BFHANDLR
     C**********         EVAL      ApplicDs = BFHOSMOD                                      MD035836
     C                   EVAL      ApplicDs = BFAPLCTN                                      MD035836
     C                   EVAL      ModuleDs = BFHMDDSC                                      MD035836
     C                   EVAL      DsgTimDs = BFDSTMMS
     C                   EVAL      RunTimDs = BFRNTMMS
     C                   EXSR      SrPrint
     C                   ENDIF

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
     C+  into :EvtCodDs indicator :NULLINDDS
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

     C                   IF        NOT %OPEN(GP004016P1)
     C                   OPEN      GP004016P1
     C                   ENDIF

     C                   CALL      'ZSFILE'
     C                   PARM                    PZSSeq
     C                   PARM      *BLANKS       PZSEnty
     C                   PARM      SFILE1        PZSFile
     C                   PARM      SFNUM1        PZSNum
     C                   PARM      *BLANK        PZSErr

     C                   IF        PZSERR = 'Y'
     C                   EVAL      DBASE  = 2
     C                   EVAL      RFILE  = 'ZSFILE'
     C                   MOVE      PZSNUM        DBKEY
     C                   EVAL      Error  = 'Y'
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
     C                   IF        NullIndDs(18) = 0                                          CBF023
     C                   EVAL      RCDAT = BFLSTMOD                                           CBF023
     C                   ENDIF                                                                CBF023
     C                   ELSE                                                                 CBF023
                                                                                              CBF023
     C                   IF        BFLSTMOD <> *BLANKS
     C**********         IF        NullIndDs(16) = 0                                       MD035836A
     C                   IF        NullIndDs(18) = 0                                       MD035836A
     C                   EVAL      RCDAT = BFLSTMOD
     C                   ENDIF
     C                   ELSE
     C**********         IF        NullIndDs(14) = 0                                       MD035836A
     C                   IF        NullIndDs(16) = 0                                       MD035836A
     C                   EVAL      RCDAT = BFRCRTON
     C                   ENDIF
     C                   ENDIF
                                                                                              CBF023
     C                   ENDIF                                                                CBF023

      ** Change Timestamp

     C                   IF        BFDELDAT <> '0'                                            CBF023
     C                             AND CBF023 = 'Y'                                           CBF023
     C                   IF        NullIndDs(18) = 0                                          CBF023
     C                   EVAL      RTIME = BFLSTMOD                                           CBF023
     C                   ENDIF                                                                CBF023
     C                   ELSE                                                                 CBF023
                                                                                              CBF023
     C                   IF        BFLSTMOD <> *BLANKS
     C**********         IF        NullIndDs(16) = 0                                       MD035836A
     C                   IF        NullIndDs(18) = 0                                       MD035836A
     C                   EVAL      RTIME = BFLSTMOD
     C                   ENDIF
     C                   ELSE
     C**********         IF        NullIndDs(14) = 0                                       MD035836A
     C                   IF        NullIndDs(16) = 0                                       MD035836A
     C                   EVAL      RTIME = BFRCRTON
     C                   ENDIF
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

     C**********         IF        NullIndDs(18) = 0                                       MD035836A
     C                   IF        NullIndDs(20) = 0                                       MD035836A
     C                   EVAL      RAUDT = BFAPRDAT
     C                   ENDIF

      ** Authorisation Timestamp

     C**********         IF        NullIndDs(18) = 0                                       MD035836A
     C                   IF        NullIndDs(20) = 0                                       MD035836A
     C                   EVAL      RATIM = BFAPRDAT
     C                   ENDIF

      ** Event Code Identifier

     C                   EVAL      REVE1 = BFEVTCOD

      ** Event Code Number

     C                   EVAL      REVE2 = BFEVTNUM

      ** Event Code Description

     C                   EVAL      RDES1 = EvDes1
     C                   EVAL      RDES2 = EvDes2
     C                   EVAL      RDES3 = EvDes3
     C                   EVAL      RDES4 = EvDes4
     C                   EVAL      RDES5 = EvDes5
     C                   EVAL      RDES6 = EvDes6

      ** Collectable/Disposable Indicator

     C                   EVAL      RCOLD = BFCOLLEC

      ** Handleable Indicator

     C                   EVAL      RHAND = BFHANDLA

      ** Severity

     C                   EVAL      RSEVE = BFSEVERI

      ** User Configurable Indicator

     C                   EVAL      RUCON = BFUSRCON

      ** Handler

     C                   EVAL      RHAN1 = EvHnd1
     C                   EVAL      RHAN2 = EvHnd2

      ** Application

     C                   EVAL      RAPP1 = EvApp1
     C                   EVAL      RAPP2 = EvApp2

      ** Module

     C**********         EVAL      RMOD1 = EvApp1                                           MD035836
     C**********         EVAL      RMOD2 = EvApp2                                           MD035836
     C                   EVAL      RMOD1 = EvMod1                                           MD035836
     C                   EVAL      RMOD2 = EvMod2                                           MD035836

      ** Message Locale

     C                   EVAL      RMESG = BFLOCALE

      ** Design-Time Message

     C                   EVAL      RSIG1 = DsMsg1
     C                   EVAL      RSIG2 = DsMsg2
     C                   EVAL      RSIG3 = DsMsg3
     C                   EVAL      RSIG4 = DsMsg4
     C                   EVAL      RSIG5 = DsMsg5
     C                   EVAL      RSIG6 = DsMsg6

      ** Run-Time Message

     C                   EVAL      RRUN1 = RuMsg1
     C                   EVAL      RRUN2 = RuMsg2
     C                   EVAL      RRUN3 = RuMsg3
     C                   EVAL      RRUN4 = RuMsg4
     C                   EVAL      RRUN5 = RuMsg5
     C                   EVAL      RRUN6 = RuMsg6

     C                   EVAL      wEvtCod = BFEVTCOD
     C                   WRITE     DETAIL1

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

     C                   IF        %OPEN(GP004016P1)

     C                   EVAL      RqdLn1 = 4
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADP1
     C                   ENDIF

     C                   WRITE     TRAILP1
     C                   CLOSE     GP004016P1
     C                   ENDIF

     C                   EXSR      SRAudit

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrAudit - Subroutine to Print the Audit of the Report         *
      *                                                               *
      *****************************************************************
     C     SrAudit       BEGSR

     C                   IF        (Error <> 'Y')
     C                   IF        wNoRec = 0

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
     C                   EVAL      RFILE  = 'ZSFILE'
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

     C                   IF        %OPEN(GP004016P1)
     C                   CLOSE     GP004016P1
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrConvdat - Subroutine to Convert Date from Timestamp to      *
      *             YYYYMMDD                                          *
      *                                                               *
      *****************************************************************
     C     SrConvdat     BEGSR

     C                   EVAL      ZDayNo3 = 0
     C                   EVAL      ZDayNo4 = 0

     C**********         IF        NullIndDs(16) = 0                                       MD035836A
     C                   IF        NullIndDs(18) = 0                                       MD035836A
     C                   EVAL      TmpDat03 = %DATE(%SUBST(BFLSTMOD:1:10):*ISO)
     C                   EVAL      DatNum03 = %DEC(TmpDat03)
     C                   EVAL      PDateIN  = DatNum03
     C                   EXSR      SRZDateO
     C                   Z-ADD     ZDayNo        ZDayNo3
     C                   ENDIF

     C**********         IF        NullIndDs(14) = 0                                       AR1036892
     C**********         EVAL      TmpDat04 = %DATE(%SUBST(BFRCRTON:1:10):*ISO)            AR1036892
     C**********         EVAL      DatNum04 = %DEC(TmpDat03)                               AR1025965
     C                   EVAL      TmpDat04 = *LOVAL                                        MD042109
      ** Approved Date                                                                      MD042109
     C**********         IF        NullIndDs(18) = 0                             AR1036892 MD035836A
     C                   IF        NullIndDs(20) = 0                                       MD035836A
     C                   EVAL      TmpDat04 = %DATE(%SUBST(BFAPRDAT:1:10):*ISO)            AR1036892
     C                   ELSE                                                               MD042109
      ** Last Modified Date                                                                 MD042109
     C                   IF        NullIndDs(18) = 0                                        MD042109
     C                   EVAL      TmpDat04 = %DATE(%SUBST(BFLSTMOD:1:10):*ISO)             MD042109
     C                   ELSE                                                               MD042109
      ** Created on Date                                                                    MD042109
     C                   IF        NullIndDs(16) = 0                                        MD042109
     C                   EVAL      TmpDat04 = %DATE(%SUBST(BFRCRTON:1:10):*ISO)             MD042109
     C                   ENDIF                                                              MD042109
     C                   ENDIF                                                              MD042109
     C                   ENDIF                                                              MD042109
     C                   IF        TmpDat04 <> *LOVAL                                       MD042109
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
      **SrZdateO**-*Subroutine*to*Convert*from*DDMMYY*to*Midas*Runday**                    AR1097353
      * SrZdateO  - Subroutine to Convert from YYYYMMDD to Midas Day  *                    AR1097353
      *             Number                                            *
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

     C                   EVAL      DBPGM = 'GP004016'

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
     C                   EVAL      DBPGM  = 'GPACSZBNK'
     C                   EVAL      RFILE  = 'GZSDBANKPD'
     C                   EVAL      DBKEY  = PZone
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
