     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas GP User Security Audit Report')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GP004010 - Midas GP User Security Audit Report               *
      *                                                               *
      *  Function: Produce Midas GP User Security Audit Report        *
      *                                                               *
      *  Called By: GOC004010 - User Security Audit Report            *
      *                                                               *
      *     (c) Finastra International Limited 2012                   *
      *                                                               *
      *  Last Amend No. MD050405           Date 03Jun20               *
      *  Prev Amend No. MD042109           Date 26Jun18               *
      *                 MD046248           Date 27Oct17               *
      *                 CBF023             Date 04Jan17               *
      *                 MD035820           Date 11May16               *
      *                 AR1097353          Date 26Mar13               *
      *                 AR1036892          Date 27Sep12               *
      *                 AR1037301          Date 26Sep12               *
      *                 AR1037258          Date 26Sep12               *
      *                 AR1036626          Date 25Sep12               *
      *                 AR1032564          Date 24Sep12               *
      *                 AR1028779          Date 10Sep12               *
      *                 CBF022   *CREATE   Date 16Jul12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD050405 - Fusion Midas 2.1 Platform Upgrade                 *
      *  MD042109 - Updates, amendments and deletes do not show on    *
      *             BFTC audit reports                                *
      *  MD046248 - Finastra Rebranding                               *
      *  CBF023 - Soft Delete Feature on Security Related Modules     *
      *  MD035820 - Zone Details in report are not the same from the  *
      *             created User profile.                             *
      *  AR1097353 - No Event code Audit Report was generated.        *
      *              Additional fix for AR1096060.                    *
      *  AR1036892 - Transaction not approved during CoB run and      *
      *              consequently approved after CoB did not appear   *
      *              in the report                                    *
      *  AR1037301 - Values in User Id and User Name are interchanged *
      *  AR1037258 - User Stat field and value should be separated by *
      *              colon (Recompile)                                *
      *  AR1036626 - User Type appears as a letter instead of the     *
      *              complete word                                    *
      *  AR1032564 - Locked User did not appear in the Report         *
      *  AR1028779 - Auditable Report contains no fields              *
      *  CBF022 - BF Infrastructure: Auditability                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  *INZSR    - Program Initialisation routine                   *
      *  SrReport  - SR to process the report GP004010P1              *
      *  SrAudit   - SR to process the audit report GP004010AU        *
      *  SrPreSQL1 - SR to prepare main SQL                           *
      *  SrPrcRpt  - SR to process report                             *
      *  SrEndRpt  - SR to process end of report                      *
      *  SrRCFAU   - Register the audit printer file via RCF          *
      *  SrFetch   - Fetch report detail 1                            *
      *  SrConvDat - Subroutine to convert date from Timestamp to     *
      *                YYYYMMDD                                       *
      *  SrPrint   - Print main details                               *
      *  SrBkBr    - Process details for booking branch detail 2      *
      *  SrOrBr    - Process details for originating branch detail 3  *
      *  SrComp    - Process details for company detail 4             *
      *  SrRole    - Process details for role detail 5                *
      *  SrAuZo    - Process details for authorised zones detail 6    *
      *  SrClose   - Close report detail 1 cursor                     *
      ***SrZdateO**-*Subroutine*to*convert*from*DDMMYY*to*Midas********                    AR1097353
      *  SrZdateO  - Subroutine to convert from YYYYMMDD to Midas     *                    AR1097353
      *                runday number                                  *
      *  SrRCFP1   - Register the P1 printer file via RCF             *
      *  SrPreDet1 - SR to prepare detail 1                           *
      *  SrPrcDet1 - SR to process detail 1                           *
      *  SrZoneDS  - SR to get zone details from GPZONEPD             *
      *  SrRUNA    - SR to get reference user name                    *
      *  SrLUCN    - SR to get linked user accounts                   *
      *  SrMUSER1  - SR to get midas user details 1                   *
      *  SrMUSER2  - SR to get midas user details 2                   *                    AR1028779
      *  *PSSR     - Program exception error routine                  *
      *****************************************************************
      *                                                               *
      *  I N D I C A T O R S   I N D E X                              *
      *                                                               *
      * LR -Last Record                                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  V A R I A B L E   I N D E X                                  *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Midas GP User Security Audit Report
     FGP004010P1O    E             PRINTER USROPN
     F                                     INFSR(*PSSR)
     F                                     INFDS(SPOOL1)

      ** Midas GP User Security Audit Report - Audit
     FGP004010AUO    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOLU)

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ External data areas                  ¦
      ** ¦ ===================                  ¦
      ** +--------------------------------------+
      *
      ** Midas Local Data Area for database error reporting; based on
      ** external file
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

      ** Short DS for Access Objects
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** File information DS for main PRTF
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0

      ** File information DS for audit PRTF
     D SPOOLU          DS
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0

     D SDS            SDS
     D  JBNAM                244    253
     D  JBUSR                254    263
     D  JBNUM                264    269

     D RptDS           DS
     D  FUSERID                      32A
     D  FTYPE                        10A
     D  FNAME                        32A
     D  FDESC                        32A
     D  FCMOD                        26A
     D  FRECR                        26A
     D  FREAP                        26A                                                   AR1036892
     D  FREDL                        26A                                                      CBF023

     D UserDS          DS
     D  FNAMEPK                      32A
     D  FBSOR                        10A
     D  FUTYPE                        1A
     D  FLANG                         4A
     D  FCTRY                         4A
     D  FLOCA                         4A
     D  FZONE                       102A
     D  FABRA                         6A
     D  FUSRID                       52A
     D  FRMODBY                      32A
     D  FRECBY                       32A
     D  FRECABY                      32A
     D  FRECAD                       26A
     D  FREFUSR                       9B 0
     D  FREFNAM                      32A
     D  FUELU                         9B 0
     D  FRSAFLAG                      4B 0
     D  FUSTAT                        4B 0                                                 AR1032564

     D ZoneDS          DS
     D  FZONS                        10A
     D  FZODS                        50A

     D Musr1DS         DS
     D  FROUT                         1A
     D  FMUREP1                       1A

     D Musr2DS         DS
     D  FSECL                         4S 0
     D  FBANK                         1A
     D  FDPPT                         3A
     D  FMUREP2                       1A
     D  FDBRN                         3A
     D  FOUTQ                        10A
     D  FDIRID                        8A
     D  FDIRAD                        8A
     D  FPAUT                         1A
     D  FROUF                         1A
     D  FCOUTQ                       10A
     D  FALACOD                       1A
     D  FUSRLVL                       1A
     D  FCOBAUT                       1A
     D  FTLID                         3A
     D
     D inDS            DS
     D  inBkBr                        1A
     D  inOrBr                        1A
     D  inComp                        1A
     D  inRole                        1A
     D  inAuZo                        1A

      ** Input parameter for ZDATE10
     D                 DS
     D  PDateIn                1      8  0

     D**ZDate***        S              6  0                                                AR1097353
     D ZDate           S              8S 0                                                 AR1097353
     D ZDayNo          S              5  0
     D ZError          S              2  0

     D ZDayNo1         S              5P 0
     D ZDayNo2         S              5P 0

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
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

      ** Null indicators
     D***NIRptDS***      S              5I 0 DIM(6)                                        AR1036892
     D***NIUserDS***     S              5I 0 DIM(17)                                       AR1032564
     D***NIRptDS         S              5I 0 DIM(7)                                 AR1036892 CBF023
     D NIRptDS         S              5I 0 DIM(8)                                             CBF023
     D NIUserDS        S              5I 0 DIM(18)                                         AR1032564
     D NIZoneDS        S              5I 0 DIM(2)
     D NIFRUNA         S              5I 0
     D NIFLUCN         S              5I 0
     D NIMusr1DS       S              5I 0 DIM(2)
     D NIMusr2DS       S              5I 0 DIM(15)

      ** Other work variables
     D WRun            S              1A
     D Error           S              1A
     D WNoRec          S             10  0 INZ(*ZEROS)
     D RqdLn1          S              3  0 INZ(*ZEROS)
     D DifLn1          S              3  0 INZ(*ZEROS)
     D WFirst          S              1    INZ('Y')
     D wZone           S             10A

     D**TmpDat01        S               D   DATFMT(*DMY)                                   AR1097353
     D TmpDat01        S               D   DATFMT(*ISO)                                    AR1097353
     D DatNum01        S              8S 0

     D**TmpDat02        S               D   DATFMT(*DMY)                                   AR1097353
     D TmpDat02        S               D   DATFMT(*ISO)                                    AR1097353
     D DatNum02        S              8S 0

     D  wUSERID        S             32A   INZ(*BLANKS)
     D  wTYPE          S             12A   INZ(*BLANKS)
     D  wNAME          S             32A   INZ(*BLANKS)
     D  wDESC          S            257A   INZ(*BLANKS)
     D  wCMOD          S             26A   INZ(*BLANKS)
     D  wRECR          S             26A   INZ(*BLANKS)

     D  FRUNA          S             52A
     D  FLUCN          S              4S 0

     D  CBF023         S              1A                                                      CBF023
      ** +--------------------------------------+
      ** ¦ Declared constants                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************

      ** Process Report

     C                   EXSR      SrReport

      ** Process Audit Report

     C                   EXSR      SrAudit

     C                   EVAL      *INLR = *ON

     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrReport - SR to process the report GP004010P1                *
      *                                                               *
      * Called by: Main Procedure                                     *
      *                                                               *
      * Calls: SrPreSQL1, SrPrcRpt, SrEndRpt                          *
      *                                                               *
      *****************************************************************
     C     SrReport      BEGSR

      ** Prepare SQL statement to be processed

     C                   EXSR      SrPreSQL1

      ** Process Report

     C                   EXSR      SrPrcRpt

      ** Process End of Report

     C                   EXSR      SrEndRpt

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrAudit - SR to process the audit report GP004010AU           *
      *                                                               *
      * Called by: Main Procedure                                     *
      *                                                               *
      * Calls: SrRCFAU                                                *
      *                                                               *
      *****************************************************************
     C     SrAudit       BEGSR

     C                   IF        (Error <> 'Y')
     C                   IF        WNoRec = 0

      ** Open and Register Audit report via RCF

     C                   EXSR      SrRCFAU

      ** Print Header (Audit)

     C                   WRITE     HEADAU

      ** Print No Details

     C                   WRITE     NODTLS
     C                   ENDIF

     C                   ELSE

      ** Print Database Error Details

     C                   WRITE     HEADAU
     C                   WRITE     DBERROR

      ** Close Report if Open

     C                   IF        %OPEN(GP004010P1)
     C                   CLOSE     GP004010P1
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrPreSQL1 - SR to prepare main SQL                            *
      *                                                               *
      * Called by: SrReport                                           *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrPreSql1     BEGSR

     C                   CLEAR                   RptDS                                     AR1028779
                                                                                           AR1028779
      ** Declare cursor
     C/exec sql
     C+ declare RptCursor cursor for
     C********select*USERID,*TYPE,*NAME,*DESC,*CMODDATE,*RECRTDON******                    AR1036892
     C********select*USERID,*TYPE,*NAME,*DESC,*CMODDATE,*RECRTDON,*APRDATE          AR1036892 CBF023
     C+       select USERID, TYPE, NAME, DESC, CMODDATE, RECRTDON, APRDATE,                   CBF023
     C+            RDELDATE                                                                   CBF023
     C+       from
     C+       (
     C+       select A.BFNAMEPK as USERID, BFRSAFLAG, 'BOOKBR' as TYPE,
     C+            1 as SRTODR, C.A8BRCD as NAME, C.A8BRNM as DESC,
     C+            A.BFRECLASTMODIFIEDDATE AS CMODDATE, A.BFRECCREATEDON
     C*************AS RECRTDON*****************************************                    AR1036892
     C*************as*RECRTDON,*A.BFRECAPPROVEDDATE*as*APRDATE*********             AR1036892 CBF023
     C+            as RECRTDON, A.BFRECAPPROVEDDATE as APRDATE,                               CBF023
     C+            A.BFRECDELETETDATE as RDELDATE                                             CBF023
     C+       from
     C+            MIVW_USER A
     C+            join GPBRCBPD B on A.BFNAMEPK = B.USRP
     C+            join SDBRCHPD C on B.BRCA = C.A8BRCD
     C+       union
     C+       select A.BFNAMEPK as USERID, BFRSAFLAG, 'ORIGBR' as TYPE,
     C+            2 as SRTODR, C.A8BRCD as NAME, C.A8BRNM as DESC,
     C+            A.BFRECLASTMODIFIEDDATE AS CMODDATE, A.BFRECCREATEDON
     C*************AS RECRTDON*****************************************                    AR1036892
     C*************as*RECRTDON,*.BFRECAPPROVEDDATE*as*APRDATE**********             AR1036892 CBF023
     C+            as RECRTDON, A.BFRECAPPROVEDDATE as APRDATE,                               CBF023
     C+            A.BFRECDELETETDATE as RDELDATE                                             CBF023
     C+       from
     C+            MIVW_USER A
     C+            join GPBRCOPD B on A.BFNAMEPK = B.USRP
     C+            join SDBRCHPD C on B.BRCA = C.A8BRCD
     C+       union
     C+       select A.BFNAMEPK as USERID, BFRSAFLAG, 'COMPANY' as TYPE,
     C+            3 as SRTODR, C.APCMCD as NAME, C.APCMNM as DESC,
     C+            A.BFRECLASTMODIFIEDDATE AS CMODDATE, A.BFRECCREATEDON
     C*************AS RECRTDON*****************************************                    AR1036892
     C*************as*RECRTDON,*A.BFRECAPPROVEDDATE*as*APRDATE*********             AR1036892 CBF023
     C+            as RECRTDON, A.BFRECAPPROVEDDATE as APRDATE,                               CBF023
     C+            A.BFRECDELETETDATE as RDELDATE                                             CBF023
     C+       from
     C+            MIVW_USER A
     C+            join GPCMPSPD B on A.BFNAMEPK = B.USRP
     C+            join SDCOMPPD C on B.CMP = C.APCMCD
     C+       union
     C+       select A.BFNAMEPK as USERID, BFRSAFLAG, 'ROLE' as TYPE,
     C+            4 as SRTODR, C.BFGROUPNAME AS NAME,
     C+            C.BFGROUPDESCRIPTION as DESC,
     C+            A.BFRECLASTMODIFIEDDATE AS CMODDATE, A.BFRECCREATEDON
     C*************AS RECRTDON*****************************************                    AR1036892
     C*************as*RECRTDON,*A.BFRECAPPROVEDDATE*as*APRDATE*********             AR1036892 CBF023
     C+            as RECRTDON, A.BFRECAPPROVEDDATE as APRDATE,                               CBF023
     C+            A.BFRECDELETETDATE as RDELDATE                                             CBF023
     C+       from
     C+            MIVW_USER A
     C+            join MIVW_OGUS B on A.BFNAMEPK = B.BFUSERNAME
     C+            join MIVW_OGRP C on  B.BFGROUPID = C.BFGROUPIDPK
     C+       union
     C+       select A.BFNAMEPK as USERID, BFRSAFLAG, 'AUTHZONE' as TYPE,
     C+            5 as SRTODR, C.BFSYSTEMPREFIX as NAME,
     C+            C.BFDESCRIPTION as DESC,
     C+            A.BFRECLASTMODIFIEDDATE AS CMODDATE, A.BFRECCREATEDON
     C*************AS RECRTDON*****************************************                    AR1036892
     C*************as*RECRTDON,*A.BFRECAPPROVEDDATE*as*APRDATE*********             AR1036892 CBF023
     C+            as RECRTDON, A.BFRECAPPROVEDDATE as APRDATE,                               CBF023
     C+            A.BFRECDELETETDATE as RDELDATE                                             CBF023
     C+       from
     C+            MIVW_USER A
     C+            join MIVW_ZUSR B on A.BFNAMEPK = B.BFUSERID
     C+            join MIVW_ZONE C on B.BFZONE = C.BFSYSTEMPREFIX
     C+       ) as REPORT
     C********where****************************************************                    AR1028779
     C********USERID*IN('XXXXXX','XXXXXXXX')***************************                    AR1028779
     C********USERID*IN('USER44','ESUSER01','ESSOFCR')*****************                    AR1028779
     C********USERID*in('QUINTO','ESSOFCR','ESUSER01')*****************                    AR1028779
     C+       order by USERID, SRTODR
     C/end-exec

      ** Open cursor
     C/exec sql
     C+ open RptCursor
     C/end-exec

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *   SrPreDet1 - SR to prepare detail 1                          *
      *                                                               *
      * Called by: SrPrint                                            *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrPreDet1     BEGSR

     C                   CLEAR                   UserDS                                    AR1028779
                                                                                           AR1028779
      ** Retrieve details from MIVW_USER
     C/exec sql
     C+ select
     C+       BFNAMEPK,
     C+       BFBRANCHSORTCODE,
     C+       BFUSERTYPE,
     C+       BFLANGUAGELOCALE,
     C+       BFCOUNTRYLOCALE,
     C+       BFVARIANTLOCALE,
     C+       BFZONE,
     C+       BFBMBRANCH,
     C+       BFUSERID,
     C+       BFRECLASTMODIFIEDBY,
     C+       BFRECCREATEDBY,
     C+       BFRECAPPROVEDBY,
     C+       BFRECAPPROVEDDATE,
     C+       BFREFERENCEUSER,
     C+       BFREFERENCEUSERNAME,
     C+       BFUPDATEENTOFLINKEDUSER,
     C********BFRSAFLAG************************************************                    AR1032564
     C+       BFRSAFLAG,                                                                   AR1032564
     C+       BFLOCKEDOUT                                                                  AR1032564
     C+ into :UserDS indicator :NIUserDS
     C+ from MIVW_USER
     C+ where BFNAMEPK = :FUSERID
     C/end-exec

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrPrcDet1 - SR to process detail 1                            *
      *                                                               *
      * Called by: SrPrint                                            *
      *                                                               *
      * Calls: SrZoneDS, SrRUNA, SrLUCN, SrMUSER1                     *
      *                                                               *
      *****************************************************************
     C     SrPrcDet1     BEGSR

      ** User Identifier

     C**********         EVAL      RUSID = FUSRID                                          AR1037301
     C                   EVAL      RUSID = FNAMEPK                                         AR1037301

      ** User Name and Type

     C                   IF        FUTYPE = *BLANKS                                        AR1036626
     C**********         EVAL      RNAME = FNAMEPK                                         AR1037301
     C**********         EVAL      RTYPE = FUTYPE                                          AR1036626
     C                   EVAL      RNAME = FUSRID                                          AR1037301
     C                   ELSE                                                              AR1036626
     C                   SELECT                                                            AR1036626
     C     FUTYPE        WHENEQ    'S'                                                     AR1036626
     C**********         EVAL      RNAME=%TRIM(FNAMEPK) + ' (Supervisor)'        AR1036626 AR1037301
     C                   EVAL      RNAME=%TRIM(FUSRID) + ' (Supervisor)'                   AR1037301
     C     FUTYPE        WHENEQ    'C'                                                     AR1036626
     C**********         EVAL      RNAME=%TRIM(FNAMEPK) + ' (Call Center User)'  AR1036626 AR1037301
     C                   EVAL      RNAME=%TRIM(FUSRID) + ' (Call Center User)'             AR1037301
     C     FUTYPE        WHENEQ    'N'                                                     AR1036626
     C**********         EVAL      RNAME=%TRIM(FNAMEPK) + ' (Normal)'            AR1036626 AR1037301
     C                   EVAL      RNAME=%TRIM(FUSRID) + ' (Normal)'                       AR1037301
     C     FUTYPE        WHENEQ    'T'                                                     AR1036626
     C**********         EVAL      RNAME=%TRIM(FNAMEPK) + ' (Teller)'            AR1036626 AR1037301
     C                   EVAL      RNAME=%TRIM(FUSRID) + ' (Teller)'                       AR1037301
     C     FUTYPE        WHENEQ    'A'                                                      MD050405
     C                   EVAL      RNAME=%TRIM(FUSRID) + ' (Central Admin)'                 MD050405
     C     FUTYPE        WHENEQ    'I'                                                      MD050405
     C                   EVAL      RNAME=%TRIM(FUSRID) + ' (Interface User)'                MD050405
     C                   ENDSL                                                             AR1036626
     C                   ENDIF                                                             AR1036626
                                                                                           AR1032564
      ** User Status                                                                       AR1032564
                                                                                           AR1032564
     C                   IF        FUSTAT = 0                                              AR1032564
     C                   EVAL      RUSTA = 'Unlocked'                                      AR1032564
     C                   ELSE                                                              AR1032564
     C                   EVAL      RUSTA = 'Locked'                                        AR1032564
     C                   ENDIF                                                             AR1032564

      ** Last Change User

     C                   IF        FCMOD <> *BLANKS
     C                   EVAL      RUSER = FRMODBY
     C                   ELSE
     C                   EVAL      RUSER = FRECBY
     C                   ENDIF

      ** Last Authorising User

     C                   EVAL      RAUTH = FRECABY

      ** Change Date

     C                   IF        FREDL <> '0'                                               CBF023
     C                             AND CBF023 = 'Y'                                           CBF023
     C                   EVAL      RCDAT = FCMOD                                              CBF023
     C                   ELSE                                                                 CBF023
     C                   IF        FCMOD <> *BLANKS
     C                   EVAL      RCDAT = FCMOD
     C                   ELSE
     C                   EVAL      RCDAT = FRECR
     C                   ENDIF
     C                   ENDIF                                                                CBF023

      ** Authorisation Date

     C                   EVAL      RAUDT = FRECAD

      ** Last change Action

     C                   IF        FREDL <> '0'                                               CBF023
     C                             AND CBF023 = 'Y'                                           CBF023
     C                   EVAL      RACTN = 'Delete'                                           CBF023
     C                   ELSE                                                                 CBF023
     C                   IF        FCMOD = *BLANKS
     C                   EVAL      RACTN = 'Insert'
     C                   ELSE
     C                   EVAL      RACTN = 'Amend'
     C                   ENDIF
     C                   ENDIF                                                                CBF023

      ** Change Timestamp

     C                   IF        FREDL <> '0'                                               CBF023
     C                             AND CBF023 = 'Y'                                           CBF023
     C                   EVAL      RTIME = FCMOD                                              CBF023
     C                   ELSE                                                                 CBF023
     C                   IF        FCMOD <> *BLANKS
     C                   EVAL      RTIME = FCMOD
     C                   ELSE
     C                   EVAL      RTIME = FRECR
     C                   ENDIF
     C                   ENDIF                                                                CBF023

      ** Authorisation Timestamp

     C                   EVAL      RATIM = FRECAD

      ** Branch Sort Code

     C                   EVAL      RBSOR = FBSOR

      ** Accounting Branch

     C                   EVAL      RABRA = FABRA

      ** Country Code

     C                   EVAL      RCTRY = FCTRY

      ** Default Zone and Description

     C                   EXSR      SrZoneDS
     C                   EVAL      RZONE = FZONS
     C                   EVAL      RZODS = FZODS

      ** Language

     C                   EVAL      RLANG = FLANG

      ** Local Variant

     C                   EVAL      RLOCA = FLOCA

      ** Reference User Identifier

     C                   EVAL      RRUID = FREFNAM

      ** Reference User Name

     C                   EXSR      SrRUNA
     C                   EVAL      RRUNA = FRUNA

      ** Reference User Indicator

     C                   EVAL      RRUIN = %CHAR(FREFUSR)

      ** Dual Factor Authentication Flag

     C                   EVAL      RDFAU = %CHAR(FRSAFLAG)

      ** Update Entitlements of Linked Users

     C                   EVAL      RUELU = %CHAR(FUELU)

      ** Linked User Counts

     C                   EXSR      SrLUCN
     C                   EVAL      RLUCN = %char(FLUCN)

      ** Choice of Report Instructions

     C                   EXSR      SrMUSER1
     C                   EVAL      RCHRI = FROUT

      ** Allow Access to Multiple User Reports

     C                   EVAL      RMURE = FMUREP1

     C                   WRITE     DETAIL1

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *   SrZoneDS - SR to get zone details from GPZONEPD             *
      *                                                               *
      * Called by: SrPrcDet1                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrZoneDS      BEGSR

     C                   CLEAR                   ZoneDS                                    AR1028779
                                                                                           AR1028779
     C/exec sql
     C+ select ZOZONE, ZODESC
     C+ into :ZoneDS indicator :NIZoneDS
     C+ from GPZONEPD
     C+ where ZOMSYS = :FZONE
     C/end-exec

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *   SrRUNA - SR to get reference user name                      *
      *                                                               *
      * Called by: SrPrcDet1                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrRUNA        BEGSR

     C                   CLEAR                   FRUNA                                     AR1028779
                                                                                           AR1028779
     C/exec sql
     C+ select BFUSERID
     C+ into :FRUNA indicator :NIFRUNA
     C+ from MIVW_USER
     C+ where BFNAMEPK = :FREFNAM
     C/end-exec

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *   SrLUCN - SR to get linked user accounts                     *
      *                                                               *
      * Called by: SrPrcDet1                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrLUCN        BEGSR

     C                   CLEAR                   FLUCN                                     AR1028779
                                                                                           AR1028779
     C/exec sql
     C+ select count(BFREFERENCEUSERNAME) as LUCN
     C+ into :FLUCN indicator :NIFLUCN
     C+ from MIVW_USER
     C+ where BFREFERENCEUSERNAME = :FNAMEPK
     C/end-exec

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *   SrMUSER1 - SR to get midas user details 1                   *
      *                                                               *
      * Called by: SrPrcDet1                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrMUSER1      BEGSR

     C                   CLEAR                   Musr1DS

     C/exec sql
     C+ select ROUT, MUREP
     C+ into :Musr1DS indicator :NIMusr1DS
     C+ from MUSER
     C+ where USRP = :FNAMEPK
     C/end-exec

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *   SrMUSER2 - SR to get midas user details 2                   *
      *                                                               *
      * Called by: SrAuZo                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrMUSER2      BEGSR

     C**********         CLEAR                   Musr1DS                                   AR1028779
     C                   CLEAR                   Musr2DS                                   AR1028779

     C/exec sql
     C**********+ select SECL, BANK, DPPT, MUREP, DBRN, OUTQ, DIRID, DIRAD,                 MD035820
     C+ select SECL, BANK, DPPT, MBREP, DBRN, OUTQ, DIRID, DIRAD,                           MD035820
     C+       PAUT, ROUF, COUTQ, ALACOD, USRLVL, COBAUT, TLID
     C+ into :Musr2DS indicator :NIMusr2DS
     C+ from MUSER
     C+ where USRP = :FNAMEPK
     C/end-exec

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *   SrPrcRpt - SR to process report                             *
      *                                                               *
      * Called by: SrReport                                           *
      *                                                               *
      * Calls: SrFetch, SrConvDat, SrPrint, SrBkBr, SrOrBr, SrComp,   *
      *        SrRole, SrAuZo, SrClose                                *
      *                                                               *
      *****************************************************************
     C     SrPrcRpt      BEGSR

      ** Fetch First Record

     C                   EXSR      SrFetch
     C                   DOW       SQLCODE = *ZEROS

      ** Convert Dates

     C                   EXSR      SrConvDat

     C**********         IF        ZDayNo1 = BJRDNB OR                                     AR1036892
     C**********                   ZDayNo2 = BJRDNB AND                                    AR1036892
     C**********                   ZDayNo1 = 0                                             AR1036892
     C**********         IF        ZDayNo2 = BJRDNB                               AR1036892 MD050405
                                                                                            MD050405
      ** Print report based on today's date instead of Midas rundate                        MD050405
                                                                                            MD050405
     C                   IF        TmpDat02 = %DATE()                                       MD050405

      ** Change in User ID

     C                   IF        FUSERID <> wUSERID

      ** Process Header and Detail1

     C                   EXSR      SrPrint

     C                   ENDIF

     C                   SELECT
     C                   WHEN      FTYPE = 'BOOKBR'
     C                   EXSR      SrBkBr
     C                   WHEN      FTYPE = 'ORIGBR'
     C                   EXSR      SrOrBr
     C                   WHEN      FTYPE = 'COMPANY'
     C                   EXSR      SrComp
     C                   WHEN      FTYPE = 'ROLE'
     C                   EXSR      SrRole
     C                   WHEN      FTYPE = 'AUTHZONE'
     C                   IF        FDESC = wZone                                            MD035820
     C                   EXSR      SrAuZo
     C                   ENDIF                                                              MD035820
     C                   ENDSL

     C                   ENDIF

      ** Fetch Next Record

     C                   EXSR      SrFetch
     C                   ENDDO

      ** Close Detail 1 Cursor

     C                   EXSR      SrClose

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *   SrEndRpt - SR to process end of report                      *
      *                                                               *
      * Called by: SrReport                                           *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrEndRpt      BEGSR

      ** Close P1 and Write Trailer Record Format

     C                   IF        %OPEN(GP004010P1)

     C                   EVAL      RqdLn1 = 3
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
     C                   IF        DifLn1 < RqdLn1
     C                   WRITE     HEADP1
     C                   ENDIF

     C                   WRITE     TRAILP1
     C                   CLOSE     GP004010P1
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *   SrPrint - Print main details                                *
      *                                                               *
      * Called by: SrPrcRpt                                           *
      *                                                               *
      * Calls: SrRCFP1, SrPreDet1, SrPrcDet1                          *
      *                                                               *
      *****************************************************************
     C     SrPrint       BEGSR

     C                   IF        NOT %OPEN(GP004010P1)

     C                   OPEN      GP004010P1

      ** Open and Register Printer File via RCF

     C                   EXSR      SrRCFP1
     C                   ENDIF
     C                   WRITE     HEADP1
     C                   EVAL      WFirst = 'Y'

      ** Prepare Detail 1

     C                   EXSR      SrPreDet1

      ** Process Detail 1

     C                   EXSR      SrPrcDet1

      ** Count the Number of Records Processed

     C                   EVAL      wNoRec = wNoRec + 1

      ** Save Current User ID for Next Use

     C                   EVAL      wUSERID = FUSERID

      ** Reset Group Head Indicators

     C                   EVAL      inDS = *ALL'N'

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *   SrFetch - Fetch report detail 1                             *
      *                                                               *
      * Called by: SrPrcRpt                                           *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrFetch       BEGSR

     C/exec sql
     C+  fetch next
     C+   from RptCursor
     C+  into :RptDS indicator :NIRptDS
     C/end-exec

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *   SrClose - Close report detail 1 cursor                      *
      *                                                               *
      * Called by: SrPrcRpt                                           *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrClose       BEGSR

     C/exec sql
     C+  close RptCursor
     C/end-exec

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *   SrBkBr - Process details for booking branch detail 2        *
      *                                                               *
      * Called by: SrPrcRpt                                           *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrBkBr        BEGSR

     C                   EVAL      RqdLn1 = 4
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1

      ** Write header if not yet written

     C                   IF        inBkBr = 'N'
     C                   IF        DifLn1 >= RqdLn1
     C                   WRITE     HEAD2
     C                   ELSE
     C                   WRITE     HEADP1
     C                   WRITE     HEAD2
     C                   ENDIF
     C                   EVAL      inBkBr = 'Y'
     C                   ENDIF

     C                   EVAL      RqdLn1 = 2
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1

     C                   EVAL      RBOOC = %TRIM(FNAME)
     C                   EVAL      RBOON = %TRIM(FDESC)

     C                   IF        DifLn1 >= RqdLn1
     C                   WRITE     DETAIL2
     C                   ELSE
     C                   WRITE     HEADP1
     C                   WRITE     HEAD2
     C                   WRITE     DETAIL2
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *   SrOrBr - Process details for originating branch detail 3    *
      *                                                               *
      * Called by: SrPrcRpt                                           *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrOrBr        BEGSR

     C                   EVAL      RqdLn1 = 4
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1

      ** Write header if not yet written

     C                   IF        inOrBr = 'N'
     C                   IF        DifLn1 >= RqdLn1
     C                   WRITE     HEAD3
     C                   ELSE
     C                   WRITE     HEADP1
     C                   WRITE     HEAD3
     C                   ENDIF
     C                   EVAL      inOrBr = 'Y'
     C                   ENDIF

     C                   EVAL      RqdLn1 = 2
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1

     C                   EVAL      ROBRC = %TRIM(FNAME)
     C                   EVAL      ROBRN = %TRIM(FDESC)

     C                   IF        DifLn1 >= RqdLn1
     C                   WRITE     DETAIL3
     C                   ELSE
     C                   WRITE     HEADP1
     C                   WRITE     HEAD3
     C                   WRITE     DETAIL3
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *   SrComp - Process details for company detail 4               *
      *                                                               *
      * Called by: SrPrcRpt                                           *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrComp        BEGSR

     C                   EVAL      RqdLn1 = 4
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1

      ** Write header if not yet written

     C                   IF        inComp = 'N'
     C                   IF        DifLn1 >= RqdLn1
     C                   WRITE     HEAD4
     C                   ELSE
     C                   WRITE     HEADP1
     C                   WRITE     HEAD4
     C                   ENDIF
     C                   EVAL      inComp = 'Y'
     C                   ENDIF

     C                   EVAL      RqdLn1 = 2
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1

     C                   EVAL      RCOMC = %TRIM(FNAME)
     C                   EVAL      RCOMN = %TRIM(FDESC)

     C                   IF        DifLn1 >= RqdLn1
     C                   WRITE     DETAIL4
     C                   ELSE
     C                   WRITE     HEADP1
     C                   WRITE     HEAD4
     C                   WRITE     DETAIL4
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *   SrRole - Process details for role detail 5                  *
      *                                                               *
      * Called by: SrPrcRpt                                           *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrRole        BEGSR

     C                   EVAL      RqdLn1 = 4
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1

      ** Write header if not yet written

     C                   IF        inRole = 'N'
     C                   IF        DifLn1 >= RqdLn1
     C                   WRITE     HEAD5
     C                   ELSE
     C                   WRITE     HEADP1
     C                   WRITE     HEAD5
     C                   ENDIF
     C                   EVAL      inRole = 'Y'
     C                   ENDIF

     C                   EVAL      RqdLn1 = 2
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1

     C                   EVAL      RROLE = %TRIM(FNAME)
     C                   EVAL      RROLD = %TRIM(FDESC)

     C                   IF        DifLn1 >= RqdLn1
     C                   WRITE     DETAIL5
     C                   ELSE
     C                   WRITE     HEADP1
     C                   WRITE     HEAD5
     C                   WRITE     DETAIL5
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *   SrAuZo - Process details for authorised zones detail 6      *
      *                                                               *
      * Called by: SrPrcRpt                                           *
      *                                                               *
      * Calls: SrMUSER2                                               *
      *                                                               *
      *****************************************************************
     C     SrAuZo        BEGSR

     C                   EVAL      RqdLn1 = 3
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1

      ** Write header if not yet written

     C                   IF        inAuZo = 'N'
     C                   IF        DifLn1 >= RqdLn1
     C                   WRITE     HEAD6
     C                   ELSE
     C                   WRITE     HEADP1
     C                   WRITE     HEAD6
     C                   ENDIF
     C                   EVAL      inAuZo = 'Y'
     C                   ENDIF

     C                   EVAL      RqdLn1 = 9
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1

     C                   EVAL      RZIDI = %TRIM(FNAME)
     C                   EVAL      RZONA = %TRIM(FDESC)

     C                   EXSR      SrMUSER2

     C                   EVAL      RDBRA = FDBRN
     C                   EVAL      RDEPT = FDPPT
     C                   EVAL      RSECU = FSECL
     C                   EVAL      RTELL = FTLID
     C                   EVAL      RROUT = FROUF
     C                   EVAL      RPAUT = FPAUT
     C                   EVAL      RCOBR = FCOBAUT
     C                   EVAL      RUAUT = FUSRLVL
     C                   EVAL      RACOD = FALACOD
     C                   EVAL      RBANK = FBANK
     C                   EVAL      RMBRA = FMUREP2
     C                   EVAL      ROUTR = FOUTQ
     C                   EVAL      ROUTC = FCOUTQ
     C                   EVAL      RDIRU = FDIRID
     C                   EVAL      RDIRA = FDIRAD

     C                   IF        DifLn1 >= RqdLn1
     C                   WRITE     DETAIL6
     C                   ELSE
     C                   WRITE     HEADP1
     C                   WRITE     HEAD6
     C                   WRITE     DETAIL6
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *   SrRCFP1 - Register the P1 printer file via RCF              *
      *                                                               *
      * Called by: SrPrint                                            *
      *                                                               *
      * Calls: SrAudit, *PSSR                                         *
      *                                                               *
      *****************************************************************
     C     SrRCFP1       BEGSR

     C                   Z-ADD     SFNUM1        PZSNUM

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
     C                   EXSR      SrAudit
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *   SrRCFAU - Register the audit printer file via RCF           *
      *                                                               *
      * Called by: SrAudit                                            *
      *                                                               *
      * Calls: SrAudit, *PSSR                                         *
      *                                                               *
      *****************************************************************
     C     SrRCFAU       BEGSR

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
     C                   EXSR      SrAudit
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *   SrConvDat - Subroutine to convert date from Timestamp to    *
      *             YYYYMMDD                                          *
      *                                                               *
      * Called by: SrPrcRpt                                           *
      *                                                               *
      * Calls: SRZDateO                                               *
      *                                                               *
      *****************************************************************
     C     SrConvDat     BEGSR

     C                   IF        NIRptDS(5) = 0
     C                   EVAL      TmpDat01 = %DATE(%SUBST(FCMOD:1:10):*ISO)
     C                   EVAL      DatNum01 = %DEC(TmpDat01)
     C                   EVAL      PDateIN  = DatNum01
     C                   EXSR      SRZDateO
     C                   Z-ADD     ZDayNo        ZDayNo1
     C                   ELSE
     C                   EVAL      ZDayNo1 = 0
     C                   EVAL      FCMOD   = *BLANKS
     C                   ENDIF

     C**********         IF        NIRptDS(6) = 0                                          AR1036892
     C**********         EVAL      TmpDat02 = %DATE(%SUBST(FRECR:1:10):*ISO)               AR1036892
     C                   EVAL      TmpDat02 = *LOVAL                                        MD042109
      ** Approved Date                                                                      MD042109
     C                   IF        NIRptDS(7) = 0                                           MD042109
     C**********         IF        NIRptDS(6) = 0                                 AR1036892 MD042109
     C                   EVAL      TmpDat02 = %DATE(%SUBST(FREAP:1:10):*ISO)               AR1036892
     C                   ELSE                                                               MD042109
      ** Last Modified Date                                                                 MD042109
     C                   IF        NIRptDS(5) = 0                                           MD042109
     C                   EVAL      TmpDat02 = %DATE(%SUBST(FCMOD:1:10):*ISO)                MD042109
     C                   ELSE                                                               MD042109
      ** Created on Date                                                                    MD042109
     C                   IF        NIRptDS(6) = 0                                           MD042109
     C                   EVAL      TmpDat02 = %DATE(%SUBST(FRECR:1:10):*ISO)                MD042109
     C                   ENDIF                                                              MD042109
     C                   ENDIF                                                              MD042109
     C                   ENDIF                                                              MD042109
     C                   IF        TmpDat02 <> *LOVAL                                       MD042109
     C                   EVAL      DatNum02 = %DEC(TmpDat02)
     C                   EVAL      PDateIN  = DatNum02
     C                   EXSR      SRZDateO
     C                   Z-ADD     ZDayNo        ZDayNo2
     C                   ELSE
     C                   EVAL      ZDayNo2 = 0
     C                   EVAL      FRECR   = *BLANKS
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      ****SrZdateO**-*Subroutine*to*convert*from*DDMMYY*to*Midas*******                    AR1097353
      *   SrZdateO  - Subroutine to convert from YYYYMMDD to Midas    *                    AR1097353
      *             runday number                                     *
      *                                                               *
      * Called by: SrConvDat                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrZDateO      BEGSR

     C**********         CALL      'ZDATEO'                                                AR1097353
     C                   CALL      'ZDATE10'                                               AR1097353
     C                   PARM      PDateIn       ZDate
     C                   PARM                    ZDayNo
     C**********         PARM                    ZError                                    AR1097353

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *   *INZSR - Program Initialisation routine                     *
      *                                                               *
      * Called by: Main Procedure                                     *
      *                                                               *
      * Calls: SrAudit, *PSSR                                         *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    wZone

      ** Initialize program name
     C                   EVAL      DBPGM = 'GP004010'

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
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: When in error                                      *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
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
      *****************************************************************
