     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD FATCA Indicia Check/Update')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000732 - FATCA US Indicia Check                            *
      *                                                               *
      *  Function:  This module checks for US Indicia for Customers   *
      *             and Non Account Holders. If set to update mode,   *
      *             it will also update the FATCA Information file    *
      *                                                               *
      *  IMPORTANT: This module is has been cloned as SD000732A to    *                     MD026519
      *  allow automatic updates while on a commitment cycle. Any     *                     MD026519
      *  changes to this program would need to be done on SD000730A   *                     MD026519
      *                                                               *                     MD026519
      *  Changes to process History of Customer Info during manual    *                    MD027355A
      *  run (from the tool) added here but not on SD000732A          *                    MD027355A
      *                                                               *                    MD027355A
      *  Changes to reporting type only applicable on tool run and    *                     MD028165
      *  not applicable on SD000732A                                  *                     MD028165
      *                                                               *                     MD028165
      *  Changes to process Reclassification of Joint Accounts        *                     MD027669
      *  and Authority Holders (tool only) not added to SD000732A     *                     MD027669
      *                                                               *                     MD027669
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. MD054605           Date 17Oct19               *
      *                 MD050212           Date 02Apr18               *
      *                 MD051218           Date 06Jun18               *
      *                 MD040497           Date 18Aug16               *
      *                 CGL177             Date 11Jan16               *
      *                 MD046248           Date 27Oct17               *
      *                 CER071             Date 01Aug16               *
      *                 MD027677           Date 08Aug14               *
      *                 MD027571           Date 06Jul14               *
      *                 MD027669           Date 01Jul14               *
      *                 MD027498           Date 20Jun14               *
      *                 MD027327           Date 03Jun14               *
      *                 MD027355B          Date 06Jun14               *
      *                 MD027355A          Date 06Jun14               *
      *                 MD027355           Date 06Jun14               *
      *                 MD027315           Date 06Jun14               *
      *                 MD027295           Date 06Jun14               *
      *                 MD027199           Date 30May14               *
      *                 MD026854           Date 29May14               *
      *                 MD026705           Date 29May14               *
      *                 MD026519           Date 12May14               *
      *                 CGL132  *CREATE    Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *           Applied for MD-55510.                               *
      *  MD054605 - Deliverable Data Split for SDSVALPD               *
      *  MD050212 - Replication processing for SDCUSTXC (Recompile)   *
      *  MD051218 - US Indicia Tool not running properly              *
      *  MD040497 - US Indicia Changed not recorded in Customer       *
      *             Information History                               *
      *  CGL177 - CRS Reporting Phase 2                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER071 - BAIS - Legal Form field (Recompile)                 *
      *  MD027677 - FATCA Reporting Type Comment update by the tool   *
      *             lacks spacing                                     *
      *  MD027571 - FATCA Reporting Type is updated to blanks when    *
      *             its value before update mode run is unknown (U)   *
      *             Apply Fix MD028165                                *
      *  MD027669 - Joint Account Principal Wrongly classified        *
      *             by the tool                                       *
      *  MD027498 - Inconsistent behaviour of setting New             *
      *             Classification Code in selection criteria to blank*
      *  MD027327 - US Green Card System Value did not Update         *
      *           - Applied fix MD027125                              *
      *  MD027355B - 'US Indicia Changed' header is not displayed     *
      *  MD027355A - 'US Indicia Changed' header is not displayed     *
      *  MD027355 - 'US Indicia Changed' header is not displayed      *
      *  MD027315 - Classification changed during info mode error     *
      *  MD027295 - SDC009697 COB component run too long              *
      *  MD027199 - Recursive Authority Holders                       *
      *  MD026854 - Alternative country of citizenship is missing in  *
      *             history of customer information                   *
      *  MD026705 - Authority Holder Indicia                          *
      *  MD026519 - US Indicia Auto Update                            *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of indicator                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FSDCTRYL5  IF   E           K DISK    INFSR(*PSSR)

     FSDFTNHL0  UF   E           K DISK    INFSR(*PSSR)

     FSDFTNHL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(JN:2)
     F                                     RENAME(SDFTNHD0:SDFTNHD1)

     FSDFTCSL0  UF   E           K DISK    INFSR(*PSSR)

     FSDFTCSL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDFTCSD0:SDFTCSD1)

     FSDCUSTL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(OP:2)
     F                                     RENAME(@BBREBG:SDCUSTOP)

     FSDCUSTL1  IF   E           K DISK    INFSR(*PSSR)

     FSDCUSXL1  IF   E           K DISK    INFSR(*PSSR)

     FSDACUSL1  IF   E           K DISK    INFSR(*PSSR)

     FSDALTNL1  IF   E           K DISK    INFSR(*PSSR)

     FSDNAHOL0  IF   E           K DISK    INFSR(*PSSR)

     FSDWTCSL1  IF   E           K DISK    INFSR(*PSSR)

     FSDJACCL1  IF   E           K DISK    INFSR(*PSSR)

     FSDJACCL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(J2:2)
     F                                     RENAME(SDJACCD0:SDJACCD2)

     FSDJACCLC  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(J8:2)
     F                                     RENAME(SDJACCD0:SDJACCDC)

     FSDJACCLD  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(J9:2)
     F                                     RENAME(SDJACCD0:SDJACCD9)

     FSDNOSTL2  IF   E           K DISK    INFSR(*PSSR)

     FOTPAYL9   IF   E           K DISK    INFSR(*PSSR)

     FSDCUAHLA  IF   E           K DISK    INFSR(*PSSR)

     FSDCUAHL0  IF   E           K DISK    INFSR(*PSSR)                                     MD026705
     F                                     PREFIX(L0:2)                                     MD026705
     F                                     RENAME(SDCUAHD0:SDCUAHDX)                        MD026705
                                                                                            MD026705
     FSDCUAHL1  IF   E           K DISK    INFSR(*PSSR)                                     MD026705
     F                                     PREFIX(L1:2)                                     MD026705
     F                                     RENAME(SDCUAHD0:SDCUAHD1)                        MD026705
                                                                                            MD026705
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure

      ** +-----------------------------------------------------------------+
      ** D specs of the following types should be inserted after the
      ** relevant box.  *** Remove this text afterwards. ***
      ** +-----------------------------------------------------------------+

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** Input/Output: Transaction ID
     DPReturn          S              7A
      ** Input: Transaction ID
     DPTranID          S             10A
      ** Input: Identify if Customer/NAHO/Joint
     DPSource          S              1A
      ** Input: Classification codes
     DPClasIF          S              5A
     DPClasNF          S              5A
      ** Input: Manual or Automatic Mode
     DPMode            S              1A
      ** Input: Reporting Type
     DPRepType         S              1A

     DArrayMax         C                   CONST(999)
     DIndiciaCount     C                   CONST(12)
     DSYSVAL1          C                    'FATCAEffectStartDate'
     D***RepComment       C                    'Updated by US Indicia+                      MD027677
     DRepComment       C                    'Updated by US Indicia +                        MD027677
     D                                      Search Electronic Tool'
     DIndiciaF         S              1
     DIndToNo          S              1
     DWupdat           S              1                                                     MD027315

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** Run-time Array for Country Codes with FATCA Flag
     DCtryCodeArr      S              2    DIM(ArrayMax)

      ** Second DS for Access Programs, Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** Second DS for Access Programs, Long Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** External data structure for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** External data structure for ACUS
     D SDCUXC        E DS                  EXTNAME(SDCUSTXC)

      ** External data structure for ACUS
     D SDACUS        E DS                  EXTNAME(SDACUSPD)

      ** External data structure for ALTN
     D SDALTN        E DS                  EXTNAME(SDALTNPD)

      ** External data structure for SARD
     D SCSARD        E DS                  EXTNAME(SCSARDPD)

      ** External data structure for FTNH
     D SDFTCS        E DS                  EXTNAME(SDFTCSPD)
     D                                     PREFIX(HC:2)

      ** External data structure for SVAL
     D*SDSVAL***     E DS                  EXTNAME(SDSVALPD)                                MD054605

      ** Data Structure for Joint Account member search
     D WJointAcChk     DS                  DIM(ArrayMax) QUALIFIED
     D  JointAc                       6A
     D  MemCount                      3S 0

      ** Data Structure for Authority Holder search                                         MD026705
     D WAuthHolChk     DS                  DIM(ArrayMax) QUALIFIED                          MD026705
     D  AuthHold                     10A                                                    MD026705
     D  MemCount                      3S 0                                                  MD026705
                                                                                            MD026705
      ** Data Structure for Customer Indicia with Overrides
     DCustIndOverDS    DS
     D  FACISV
     D  FATXSV
     D  FACDSV
     D  FATESV
     D  FAGCSV
     D  FACBSV
     D  FAJASV
     D  FAMCSV
     D  FARPSV
     D  FAAUSV
     D  FAIDSV
     D  FAHMSV
     D  FACIOV
     D  FATXOV
     D  FACDOV
     D  FATEOV
     D  FAGCOV
     D  FACBOV
     D  FAJAOV
     D  FAMCOV
     D  FARPOV
     D  FAAUOV
     D  FAIDOV
     D  FAHMOV
     DCustIndiciaDS                  12A   OVERLAY(CustIndOverDS)
     DCustOverideDS                  12A   OVERLAY(CustIndOverDS:13)

      ** Data Structure for Non-Account Holder Indicia
     DNAHoIndOverDS    DS
     D  FNCISV
     D  FNTXSV
     D  FNCDSV
     D  FNTESV
     D  FNGCSV
     D  FNCBSV
     D  FNJASV
     D  FNHMSV
     D  FNRPSV
     D  FNAUSV                                                                              MD026705
     D  FNIDSV
     D  FNMCSV
     D  FNCIOV
     D  FNTXOV
     D  FNCDOV
     D  FNTEOV
     D  FNGCOV
     D  FNCBOV
     D  FNJAOV
     D  FNHMOV
     D  FNRPOV
     D  FNAUOV                                                                              MD026705
     D  FNIDOV
     D  FNMCOV
     D***NAHoIndiciaDS                  11A   OVERLAY(NAHoIndOverDS)                        MD026705
     D***NAHoOverideDS                  11A   OVERLAY(NAHoIndOverDS:12)                     MD026705
     DNAHoIndiciaDS                  12A   OVERLAY(NAHoIndOverDS)                           MD026705
     DNAHoOverideDS                  12A   OVERLAY(NAHoIndOverDS:13)                        MD026705

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D @RUN            S              1
     D Index           S              3S 0 INZ(1)
     D KCNUM           S              6A
     D KCust           S              6A
     D KNAHO           S             10A

     D CSE023          S              1A
     D CSE024          S              1A
     D CSD092          S              1A

     D PRetcode        S              7A
     D POption         S              7A
     D PSARD           S              6A

     D WMesLen         S             15S 5 INZ(50)

     D PRTCD           S             20A   INZ(*BLANKS)
     D POP01           S             20A   INZ(*BLANKS)
     D PVL01           S            200A   INZ(*BLANKS)
     D POP02           S             20A   INZ(*BLANKS)
     D PVL02           S            200A   INZ(*BLANKS)

     D PDateFormat     S              1A
     D WEffDate        S              5P 0
     D WNEffDate       S              6P 0

      ** Timestamp for the transaction
     D TimeStamp       S               Z

     D PCUST           S              6A
     D PBefCUST        S           5000A
     D PAftCUST        S           5000A
     D PBefACUS        S           5000A
     D PAftACUS        S           5000A
     D PBefFTCS        S           5000A   INZ(*BLANKS)
     D PAftFTCS        S           5000A   INZ(*BLANKS)
     D PBefJACC        S           5000A
     D PAftJACC        S           5000A
     D PBefCUAH        S           5000A
     D PAftCUAH        S           5000A
     D PBefCUXC        S           5000A                                                    MD026854
     D PAftCUXC        S           5000A                                                    MD026854
     D PBefCRSH        S           5000A                                                      CGL177
     D PAftCRSH        S           5000A                                                      CGL177
     D PBefCRSD        S           5000A                                                      CGL177
     D PAftCRSD        S           5000A                                                      CGL177
     D PACRV           S              1A
     D PELEC           S              1A
     D WHasIndicia     S              1A   INZ('N')
     D WSysOff         S              2S 0
     D WOvrOff         S              2S 0
     D WTime           S               T
     D WWTIME          S              6A
     D KUS             S              2A   INZ('US')

      ** Joint Account DS Index
     D JIdx            S              2S 0 INZ(0)
     D AIdx            S              2S 0 INZ(0)                                           MD026705
     D MCount          S              3S 0 INZ(0)
     D WLoopCnt        S              3S 0 INZ(0)
     D WKey            S              6A
     D WRKey           S              6A                                                    MD027199
     D WCustAuth       S              6A                                                    MD026705
     D WKeyNAHO        S             10A                                                    MD026705
     D WNAHORoll       S              1A                                                    MD026705

      ** OTPAY Key
     D KOTPAYType      S              1A
     D KOTPAYKey35     S             35A
     D KCUST35         S              6A
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************


     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT

     C                   EVAL      Wupdat = 'N'                                             MD027315
     C                   IF        PReturn = 'UPDAT'                                        MD027315
     C                   EVAL      Wupdat = 'Y'                                             MD027315
     C                   ENDIF                                                              MD027315
     C                   EVAL      PReturn = *BLANKS                                        MD027315
     C                   EXSR      SRInitialise

     C                   IF        PSource = 'N'
     C                   EVAL      KNAHO = PTranID
     C                   EXSR      SRProcNAHO
     C                   ENDIF

     C                   IF        PSource = 'C'
     C                   EVAL      KCUST = PTranID
     C                   EXSR      SRProcCUSD
     C                   ENDIF

     C                   IF        PMode = 'A'
     C                             AND PSource = 'J'
     C                             OR PMode = 'A'
     C                             AND PSource = 'C'
     C                             OR PMode = 'M'
     C                             AND PSource = 'J'
     C                   EXSR      SrCheckJACM
     C                   ENDIF

     C                   IF        PMode = 'A'                                              MD026705
     C                             AND PSource = 'C'                                        MD026705
     C                             OR PMode = 'M'                                           MD026705
     C                   EXSR      SrCheckAUTH                                              MD026705
     C                   ENDIF                                                              MD026705
                                                                                            MD026705
     C                   RETURN


      **********************************************************************
      /EJECT
      *****************************************************************                     MD027199
      *                                                               *                     MD027199
      * SrRecurAuth  - Subroutine to handle Recursive Auth Holder     *                     MD027199
      *                                                               *                     MD027199
      * Called by: SrCheckAuth                                        *                     MD027199
      *                                                               *                     MD027199
      * Calls: None                                                   *                     MD027199
      *                                                               *                     MD027199
      *****************************************************************                     MD027199
                                                                                            MD027199
     C     SrRecurAuth   BEGSR                                                              MD027199
                                                                                            MD027199
     C                   EVAL      WHasIndicia = 'N'                                        MD027199
      ** If a recursive chain has been found, unwrap from the last                          MD027199
     C                   DOW       AIdx >= 1                                                MD027199
                                                                                            MD027199
     C                   EVAL      WRKey = WAuthHolChk(AIdx).AuthHold                       MD027199
     C                   EVAL      AIdx = AIdx - 1                                          MD027199
                                                                                            MD027199
     C     WRKey         CHAIN     SDFTCSL0                                                 MD027199
                                                                                            MD027199
      ** NOTE: WHasIndicia gets set inside the loop                                         MD027199
      ** If not yet set, set to 'Y' if the 'child' has Indicia...                           MD027199
     C                   IF        WHasIndicia = 'Y'                                        MD027199
     C                             AND FAAUSV <> 'Y'                                        MD027199
     C                   EVAL      FAAUSV = 'Y'                                             MD027199
     C                   EVAL      FAAUSD = BJRDNB                                          MD027199
     C                   EVAL      FAAUST = WWTIME                                          MD027199
     C                   UPDATE    SDFTCSD0                                                 MD027199
                                                                                            MD027199
     C                   EXSR      SRHCISProc                                               MD027199
                                                                                            MD027199
      ** ... otherwise set to 'N' if needed                                                 MD027199
     C                   ELSEIF    WHasIndicia = 'N'                                        MD027199
     C                             AND FAAUSV = ' '                                         MD027199
     C                   EVAL      FAAUSV = 'N'                                             MD027199
     C                   EVAL      FAAUSD = BJRDNB                                          MD027199
     C                   EVAL      FAAUST = WWTIME                                          MD027199
     C                   UPDATE    SDFTCSD0                                                 MD027199
                                                                                            MD027199
     C                   EXSR      SRHCISProc                                               MD027199
                                                                                            MD027199
     C                   ENDIF                                                              MD027199
                                                                                            MD027199
     C                   EVAL      WHasIndicia = 'N'                                        MD027199
     C                   EXSR      SrChkCustInd                                             MD027199
                                                                                            MD027199
     C                   ENDDO                                                              MD027199
                                                                                            MD027199
     C                   ENDSR                                                              MD027199
                                                                                            MD027199
      **********************************************************************                MD027199
      /EJECT                                                                                MD027199
      *****************************************************************
      *                                                               *
      * SrInitialise - Initial subroutine                             *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrInitialise  BEGSR

     C                   ENDSR

      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrProcNAHO  - Process Non-Account Holders' Indicia            *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrProcNAHO    BEGSR

     C     KNAHO         CHAIN(N)  SDFTNHL0

      ** If not found, this means that no records exists; DB error
     C                   IF        NOT %FOUND(SDFTNHL0)
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 000
     C                   EVAL      DBFile = 'SDFTNHPD'
     C                   EVAL      DBKEY = KNAHO
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBMOD  =  PSProcMod
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C     KNAHO         CHAIN     SDNAHOL0
      ** If this is being run as part of automatic updates,
      ** Indicia should not be updated when tool has not been run
      ** manually first for the Non-Account Holder
     C                   IF        (PMode = 'A'
     C                             AND NHCHTP = 'A'
     C                             AND NAHoIndiciaDS = *BLANKS)
     C                             OR (PMode = 'A'
     C                             AND NHCHTP = 'I'
     C                             AND NHLCDT < WEffDate
     C                             AND NAHoIndiciaDS = *BLANKS)
     C                   RETURN
     C                   ENDIF

     C     KNAHO         CHAIN     SDFTNHL0

     C                   IF        PMode = 'C'                                              MD027669
     C                   GOTO      RECLASSN                                                 MD027669
     C                   ENDIF                                                              MD027669
      ** Timestamp
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp

     C                   MOVE      TimeStamp     WTime
     C     *HMS0         MOVE      WTime         WWTIME

      ** Country of Domicile
     C                   IF        %LOOKUP(NHCOLC:CtryCodeArr) <> 0
     C                             AND NHCOLC <> *BLANKS
     C                             AND FNCDSV <> 'Y'

     C                   EVAL      FNCDSV = 'Y'
     C                   EVAL      FNCDSD = BJRDNB
     C                   EVAL      FNCDST = WWTIME

     C                   EVAL      IndiciaF = 'Y'
     C                   ELSE

     C                   IF        FNCDSV =  ' '
     C                   EVAL      IndToNo = 'Y'
     C                   EVAL      FNCDSV = 'N'
     C                   EVAL      FNCDSD = BJRDNB
     C                   EVAL      FNCDST = WWTIME
     C                   ENDIF

     C                   ENDIF

      ** Country of Citizenship
     C                   IF        %LOOKUP(NHCOCZ:CtryCodeArr) <> 0
     C                             AND NHCOCZ <> *BLANKS
     C                             OR %LOOKUP(NHACCZ:CtryCodeArr) <> 0
     C                             AND NHACCZ <> *BLANKS
     C                             AND FNCISV <> 'Y'
     C                   EVAL      FNCISV = 'Y'
     C                   EVAL      FNCISD = BJRDNB
     C                   EVAL      FNCIST = WWTIME
     C                   EVAL      IndiciaF = 'Y'
     C                   ELSE

     C                   IF        FNCISV =  ' '
     C                   EVAL      IndToNo = 'Y'
     C                   EVAL      FNCISV = 'N'
     C                   EVAL      FNCISD = BJRDNB
     C                   EVAL      FNCIST = WWTIME
     C                   ENDIF

     C                   ENDIF

      ** Country of Issuance of Identity Document
     C                   IF        %LOOKUP(NHISCT:CtryCodeArr) <> 0
     C                             AND NHISCT <> *BLANKS
     C                             AND FNIDSV <> 'Y'
     C                   EVAL      FNIDSV = 'Y'
     C                   EVAL      FNIDSD = BJRDNB
     C                   EVAL      FNIDST = WWTIME
     C                   EVAL      IndiciaF = 'Y'
     C                   ELSE

     C                   IF        FNIDSV =  ' '
     C                   EVAL      IndToNo = 'Y'
     C                   EVAL      FNIDSV = 'N'
     C                   EVAL      FNIDSD = BJRDNB
     C                   EVAL      FNIDST = WWTIME
     C                   ENDIF

     C                   ENDIF

      ** Country of Birth
     C                   IF        %LOOKUP(NHBTHC:CtryCodeArr) <> 0
     C                             AND NHBTHC <> *BLANKS
     C                             AND FNCBSV <> 'Y'
     C                   EVAL      FNCBSV = 'Y'
     C                   EVAL      FNCBSD = BJRDNB
     C                   EVAL      FNCBST = WWTIME
     C                   EVAL      IndiciaF = 'Y'
     C                   ELSE

     C                   IF        FNCBSV =  ' '
     C                   EVAL      IndToNo = 'Y'
     C                   EVAL      FNCBSV = 'N'
     C                   EVAL      FNCBSD = BJRDNB
     C                   EVAL      FNCBST = WWTIME
     C                   ENDIF

     C                   ENDIF

      ** FATCA Details
      ** Check Mailing Country
     C                   IF        %LOOKUP(FNMAIL:CtryCodeArr) <> 0
     C                             AND FNMAIL <> *BLANKS
     C                             AND FNMCSV <> 'Y'
     C                   EVAL      FNMCSV = 'Y'
     C                   EVAL      FNMCSD = BJRDNB
     C                   EVAL      FNMCST = WWTIME
     C                   EVAL      IndiciaF = 'Y'
     C                   ELSE

     C                   IF        FNMCSV =  ' '
     C                   EVAL      IndToNo = 'Y'
     C                   EVAL      FNMCSV = 'N'
     C                   EVAL      FNMCSD = BJRDNB
     C                   EVAL      FNMCST = WWTIME
     C                   ENDIF

     C                   ENDIF

      ** Check Green Card
     C                   IF        FNGREC = 'Y'
     C                             AND FNGCSV <> 'Y'
     C                   EVAL      FNGCSV = 'Y'
     C                   EVAL      FNGCSD = BJRDNB
     C                   EVAL      FNGCST = WWTIME
     C                   EVAL      IndiciaF = 'Y'
     C                   ELSE

     C                   IF        FNGCSV =  ' '
     C                   EVAL      IndToNo = 'Y'
     C                   EVAL      FNGCSV = 'N'
     C                   EVAL      FNGCSD = BJRDNB
     C                   EVAL      FNGCST = WWTIME
     C                   ENDIF

     C                   ENDIF

      ** Check Regular Payment Instructions
      ** Check SDEXSTPD/OTPAYDD/STDSET
      ** Always N for NAHO
     C                   IF        FNRPSV = ' '
     C                   EVAL      FNRPSV = 'N'
     C                   EVAL      FNRPSD = BJRDNB
     C                   EVAL      FNRPST = WWTIME
     C                   EVAL      IndiciaF = 'Y'
     C                   ELSE

     C                   IF        FNRPSV =  ' '
     C                   EVAL      IndToNo = 'Y'
     C                   EVAL      FNRPSV = 'N'
     C                   EVAL      FNRPSD = BJRDNB
     C                   EVAL      FNRPST = WWTIME
     C                   ENDIF

     C                   ENDIF

      ** Check Telephone Number
     C                   IF        FNPHON = 'Y'
     C                             AND FNTESV <> 'Y'
     C                   EVAL      FNTESV = 'Y'
     C                   EVAL      FNTESD = BJRDNB
     C                   EVAL      FNTEST = WWTIME
     C                   EVAL      IndiciaF = 'Y'
     C                   ELSE

     C                   IF        FNTESV =  ' '
     C                   EVAL      IndToNo = 'Y'
     C                   EVAL      FNTESV = 'N'
     C                   EVAL      FNTESD = BJRDNB
     C                   EVAL      FNTEST = WWTIME
     C                   ENDIF

     C                   ENDIF

      ** Joint Account is set to N for NAHO
     C                   IF        FNJASV = ' '
     C                   EVAL      IndToNo = 'Y'
     C                   EVAL      FNJASV = 'N'
     C                   EVAL      FNJASD = BJRDNB
     C                   EVAL      FNJAST = WWTIME
     C                   ENDIF

      ** Authority Holder is set to N for NAHO
     C                   IF        FNAUSV = ' '
     C                   EVAL      IndToNo = 'Y'
     C                   EVAL      FNAUSV = 'N'
     C                   EVAL      FNAUSD = BJRDNB
     C                   EVAL      FNAUST = WWTIME
     C                   ENDIF

      ** Hold Mail always set to N for NAHO
     C                   IF        FNHMSV = ' '
     C                   EVAL      IndToNo = 'Y'
     C                   EVAL      FNHMSV = 'N'
     C                   EVAL      FNHMSD = BJRDNB
     C                   EVAL      FNHMST = WWTIME
     C                   ENDIF

      ** TIN always set to N for NAHO
      ** TIN is set to N if US TIN is not populated
     C                   IF        FNUTIN <> *BLANKS
     C                             AND FNTXSV <> 'Y'
     C                   EVAL      FNTXSV = 'Y'
     C                   EVAL      FNTXSD = BJRDNB
     C                   EVAL      IndiciaF = 'Y'
     C                   ELSE
     C                   IF        FNTXSV =  ' '
     C                   EVAL      IndToNo = 'Y'
     C                   EVAL      FNTXSV = 'N'
     C                   EVAL      FNTXSD = BJRDNB
     C                   EVAL      FNTXST = WWTIME
     C                   ENDIF
     C                   ENDIF

     C     RECLASSN      TAG                                                                MD027669
     C                   IF        PMode = 'M'
     C                             OR PMode = 'J'
     C                             OR PMode = 'C'                                           MD027669

     C**********         EVAL      FNPCLA = FNCLAC                                          MD027498
     C**********         EVAL      FNCLAD = BJRDNB                                          MD027498

     C                   EVAL      WHasIndicia = 'N'
     C                   EXSR      SrChkNAHoInd
     C                   IF        WHasIndicia = 'N'
     C                   IF        PClasNF <> *BLANKS                                       MD027498
     C                             AND PMode = 'C'                                          MD027669
     C                   EVAL      FNPCLA = FNCLAC                                          MD027498
     C                   EVAL      FNCLAD = BJRDNB                                          MD027498
     C                   EVAL      FNCLAC = PClasNF
     C                   ENDIF                                                              MD027498
     C                   ELSE
     C                   IF        PClasIF <> *BLANKS                                       MD027498
     C                             AND PMode = 'C'                                          MD027669
     C                   EVAL      FNPCLA = FNCLAC                                          MD027498
     C                   EVAL      FNCLAD = BJRDNB                                          MD027498
     C                   EVAL      FNCLAC = PClasIF
     C                   ENDIF                                                              MD027498
     C                   ENDIF

     C                   IF        FNRPTT = 'U'
     C**********                   AND PRepType <> ' '                                      MD028165
     C                             AND (PRepType <> 'U'                                     MD028165
     C                             AND PRepType <> ' ')                                     MD028165
     C                   EVAL      FNRPTT = PRepType
     C                   EVAL      FNRPTU = PSUser
     C                   EVAL      FNRPTD = BJRDNB
     C                   EVAL      FNRPTM = WWTIME
     C                   EVAL      FNRPTR = RepComment
     C                   ENDIF

     C                   ENDIF

     C                   UPDATE    SDFTNHD0

     C                   ENDSR

      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrGetCustRec - Get Customer Records                           *
      *                                                               *
      * Called by: SrProcCUST, SrCheckJACM                            *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrGetCustRec  BEGSR

     C     KCNUM         CHAIN     SDCUSTL1
     C                   IF        NOT %FOUND(SDCUSTL1)
      **DBerror
     C                   ENDIF

     C     KCNUM         CHAIN     SDCUSXL1
     C                   IF        NOT %FOUND(SDCUSXL1)
     C                   EVAL      SDCUXC = *BLANKS
     C                   ENDIF

     C     KCNUM         CHAIN     SDACUSL1
     C                   IF        NOT %FOUND(SDACUSL1)
     C                   EVAL      SDACUS = *BLANKS
     C                   ENDIF

     C     KCNUM         SETLL     SDALTNL1
     C     KCNUM         READE     SDALTNL1
     C                   IF        NOT %EOF(SDALTNL1)
     C                   EVAL      SDALTN = *BLANKS
     C                   ENDIF

     C                   ENDSR

      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrProcCUSD  - Check US Indicia on the Main Customer File      *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrProcCUSD    BEGSR

     C     KCUST         CHAIN(N)  SDFTCSL0

      ** If not found, this means that no records exists; DB error
     C                   IF        NOT %FOUND(SDFTCSL0)
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 000
     C                   EVAL      DBFile = 'SDFTCSPD'
     C                   EVAL      DBKEY = KCUST
     C                   EVAL      DBPGM = PSProcPgm
     C                   EVAL      DBMOD = PSProcMod
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C     KCUST         CHAIN     SDCUSTL1
      ** If this is being run as part of automatic updates,
      ** Indicia should not be updated when tool has not been run
      ** manually first for the Customer
     C**********         IF        (PMode = 'A'                                             MD040497
     C**********                   AND BBTYLC = 'A'                                         MD040497
     C**********                   AND CustIndiciaDS = *BLANKS)                             MD040497
     C**********                   OR (PMode = 'A'                                          MD040497
     C                   IF        (PMode = 'A'                                             MD040497
     C                             AND BBTYLC = 'I'
     C                             AND BBLCD  < WEffDate
     C                             AND CustIndiciaDS = *BLANKS)
     C                   RETURN
     C                   ENDIF

     C     KCUST         CHAIN     SDFTCSL0
     C                   EXSR      SrLoadFTCS
     C                   EVAL      PBefFTCS = SDFTCS

     C                   IF        PMode = 'C'                                              MD027669
     C                   GOTO      RECLASSC                                                 MD027669
     C                   ENDIF                                                              MD027669
      ** Timestamp
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp

     C                   MOVE      TimeStamp     WTime
     C     *HMS0         MOVE      WTime         WWTIME

     C                   EVAL      KCNUM = FACUST
     C                   EXSR      SrGetCustRec

     C                   DOW       NOT %EOF(SDALTNL1)
     C                             OR %LOOKUP(BBCOLC:CtryCodeArr) <> 0
     C                             AND BBCOLC <> *BLANKS
     C                             AND FACDSV <> 'Y'

      ** Check Country of Location/Domicile
     C                   IF        %LOOKUP(BBCOLC:CtryCodeArr) <> 0
     C                             AND BBCOLC <> *BLANKS
     C                             AND FACDSV <> 'Y'
     C                             OR %LOOKUP(BCCNCD:CtryCodeArr) <> 0
     C                             AND BCCNCD <> *BLANKS
     C                             AND FACDSV <> 'Y'
     C                   EVAL      FACDSV = 'Y'
     C                   EVAL      FACDSD = BJRDNB
     C                   EVAL      FACDST = WWTIME
     C                   EVAL      IndiciaF = 'Y'
     C                   LEAVE

     C                   ELSE

     C     KCNUM         READE     SDALTNL1

     C                   ENDIF

     C                   ENDDO

     C                   IF        FACDSV =  ' '
     C                   EVAL      IndToNo = 'Y'
     C                   EVAL      FACDSV = 'N'
     C                   EVAL      FACDSD = BJRDNB
     C                   EVAL      FACDST = WWTIME
     C                   ENDIF

      ** Check Country of Citizenship
     C                   IF        %LOOKUP(BBCNCZ:CtryCodeArr) <> 0
     C                             AND BBCNCZ <> *BLANKS
     C                             AND FACISV <> 'Y'
     C                             OR %LOOKUP(XCACCZ:CtryCodeArr) <> 0
     C                             AND XCACCZ <> *BLANKS
     C                             AND FACISV <> 'Y'
     C                   EVAL      FACISV = 'Y'
     C                   EVAL      FACISD = BJRDNB
     C                   EVAL      FACIST = WWTIME
     C                   ELSE

     C                   IF        FACISV =  ' '
     C                   EVAL      IndToNo = 'Y'
     C                   EVAL      FACISV = 'N'
     C                   EVAL      FACISD = BJRDNB
     C                   EVAL      FACIST = WWTIME
     C                   ENDIF

     C                   ENDIF

      ** Check Country of Birth
     C                   IF        %LOOKUP(E5BTHC:CtryCodeArr) <> 0
     C                             AND E5BTHC <> *BLANKS
     C                             AND FACBSV <> 'Y'
     C                   EVAL      FACBSV = 'Y'
     C                   EVAL      FACBSD = BJRDNB
     C                   EVAL      FACBST = WWTIME
     C                   ELSE

     C                   IF        FACBSV =  ' '
     C                   EVAL      IndToNo = 'Y'
     C                   EVAL      FACBSV = 'N'
     C                   EVAL      FACBSD = BJRDNB
     C                   EVAL      FACBST = WWTIME
     C                   ENDIF

     C                   ENDIF

      ** Check Identity Documents Issue
     C                   IF        %LOOKUP(E5ISCT:CtryCodeArr) <> 0
     C                             AND E5ISCT <> *BLANKS
     C                             AND FAIDSV <> 'Y'
     C                   EVAL      FAIDSV = 'Y'
     C                   EVAL      FAIDSD = BJRDNB
     C                   EVAL      FAIDST = WWTIME
     C                   ELSE

     C                   IF        FAIDSV =  ' '
     C                   EVAL      IndToNo = 'Y'
     C                   EVAL      FAIDSV = 'N'
     C                   EVAL      FAIDSD = BJRDNB
     C                   EVAL      FAIDST = WWTIME
     C                   ENDIF

     C                   ENDIF

      ** FATCA Details
      ** Check Mailing Country
     C                   IF        %LOOKUP(FAMAIL:CtryCodeArr) <> 0
     C                             AND FAMAIL <> *BLANKS
     C                             AND FAMCSV <> 'Y'
     C                   EVAL      FAMCSV = 'Y'
     C                   EVAL      FAMCSD = BJRDNB
     C                   EVAL      FAMCST = WWTIME
     C                   ELSE

     C                   IF        FAMCSV =  ' '
     C                   EVAL      IndToNo = 'Y'
     C                   EVAL      FAMCSV = 'N'
     C                   EVAL      FAMCSD = BJRDNB
     C                   EVAL      FAMCST = WWTIME
     C                   ENDIF

     C                   ENDIF

      ** Check Green Card
     C                   IF        FAGREC = 'Y'
     C                             AND FAGCSV <> 'Y'
     C                   EVAL      FAGCSV = 'Y'
     C                   EVAL      FAGCSD = BJRDNB
     C                   EVAL      FAGCST = WWTIME
     C                   ELSE

     C                   IF        FAGCSV =  ' '
     C                   EVAL      IndToNo = 'Y'
     C                   EVAL      FAGCSV = 'N'
     C                   EVAL      FAGCSD = BJRDNB
     C                   EVAL      FAGCST = WWTIME
     C                   ENDIF

     C                   ENDIF

      ** Check Telephone Number
     C                   IF        FAPHON = 'Y'
     C                             AND FATESV <> 'Y'
     C                   EVAL      FATESV = 'Y'
     C                   EVAL      FATESD = BJRDNB
     C                   EVAL      FATEST = WWTIME
     C                   ELSE

     C                   IF        FATESV =  ' '
     C                   EVAL      IndToNo = 'Y'
     C                   EVAL      FATESV = 'N'
     C                   EVAL      FATESD = BJRDNB
     C                   EVAL      FATEST = WWTIME
     C                   ENDIF

     C                   ENDIF

      ** Check Regular Payment Instructions
      ** Check SDEXSTPD/OTPAYDD/STDSET
     C                   IF        FARPSV <> 'Y'
     C                   EXSR      SRRegPayInst
     C                   IF        FARPSV = 'Y'
     C                   EVAL      FARPSD = BJRDNB
     C                   EVAL      FARPST = WWTIME
     C                   ELSE

     C                   IF        FARPSV =  ' '
     C                   EVAL      IndToNo = 'Y'
     C                   EVAL      FARPSV = 'N'
     C                   EVAL      FARPSD = BJRDNB
     C                   EVAL      FARPST = WWTIME
     C                   ENDIF
     C                   ENDIF

     C                   ENDIF

      ** Hold Mail always set to 'N'
     C                   IF        FAHMSV = ' '
     C                   EVAL      IndToNo = 'Y'
     C                   EVAL      FAHMSV = 'N'
     C                   EVAL      FAHMSD = BJRDNB
     C                   EVAL      FAHMST = WWTIME                                          MD026705
     C                   ENDIF

      ** US Witholding Tax Details

     C                   IF        CSE023 = 'Y' AND CSE024 = 'Y'
     C     KCustUS       CHAIN     SDWTCSL1
     C                   IF        %FOUND(SDWTCSL1)
     C                             AND FATXSV <> 'Y'
     C                             AND FAUTIN <> *BLANKS
     C                   EVAL      FATXSV = 'Y'
     C                   EVAL      FATXSD = BJRDNB
     C                   EVAL      FATXST = WWTIME
     C                   ELSE

     C                   IF        FATXSV =  ' '
     C                   EVAL      FATXSV = 'N'
     C                   EVAL      FATXSD = BJRDNB
     C                   EVAL      FATXST = WWTIME
     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

     C                   IF        FATXSV <> 'Y'
     C                             AND FAUTIN <> *BLANKS
     C                   EVAL      FATXSV = 'Y'
     C                   EVAL      FATXSD = BJRDNB
     C                   EVAL      FATXST = WWTIME
     C                   ELSE

     C                   IF        FATXSV =  ' '
     C                   EVAL      FATXSV = 'N'
     C                   EVAL      FATXSD = BJRDNB
     C                   EVAL      FATXST = WWTIME
     C                   ENDIF

     C                   ENDIF

      ** Joint Account is system value set to N for non joint accounts
     C                   IF        FAJASV = ' '
     C     FACUST        CHAIN     SDJACCLC
     C                   IF        NOT %FOUND(SDJACCLC)
     C                   EVAL      FAJASV = 'N'
     C                   EVAL      FAJASD = BJRDNB
     C                   EVAL      FAJAST = WWTIME
     C                   ENDIF
     C                   ENDIF

      ** Authority Holder system value set to N if no records in
      ** Authority Holder table
     C                   IF        FAAUSV = ' '
     C     FACUST        CHAIN     SDCUAHLA
     C                   IF        NOT %FOUND(SDCUAHLA)
     C                   EVAL      FAAUSV = 'N'
     C                   EVAL      FAAUSD = BJRDNB
     C                   EVAL      FAAUST = WWTIME
     C                   ENDIF
     C                   ENDIF

     C     RECLASSC      TAG                                                                MD027669
     C                   IF        PMode = 'M'
     C                             OR PMode = 'J'
     C                             OR PMode = 'C'                                           MD027669

     C**********         EVAL      FAPCLA = FACLAC                                          MD027498
     C**********         EVAL      FACLAD = BJRDNB                                          MD027498

     C                   EVAL      WHasIndicia = 'N'
     C                   EXSR      SrChkCustInd

     C                   IF        WHasIndicia = 'N'
     C                   IF        PClasNF <> *BLANKS                                       MD027498
     C                             AND PMode = 'C'                                          MD027669
     C                   EVAL      FAPCLA = FACLAC                                          MD027498
     C                   EVAL      FACLAD = BJRDNB                                          MD027498
     C                   EVAL      FACLAC = PClasNF
     C                   ENDIF                                                              MD027498
     C                   ELSE
     C                   IF        PClasIF <> *BLANKS                                       MD027498
     C                             AND PMode = 'C'                                          MD027669
     C                   EVAL      FAPCLA = FACLAC                                          MD027498
     C                   EVAL      FACLAD = BJRDNB                                          MD027498
     C                   EVAL      FACLAC = PClasIF
     C                   ENDIF                                                              MD027498
     C                   ENDIF

     C                   IF        FARPTT = 'U'
     C**********                   AND PRepType <> 'U'                                      MD028165
     C**********                   OR FARPTT = ' '                                          MD028165
     C                             AND (PRepType <> 'U'                                     MD028165
     C                             AND PRepType <> ' ')                                     MD028165
     C                   EVAL      FARPTT = PRepType
     C                   EVAL      FARPTU = PSUser
     C                   EVAL      FARPTD = BJRDNB
     C                   EVAL      FARPTM = WWTIME
     C                   EVAL      FARPTR = RepComment
     C                   ENDIF

     C                   ENDIF

     C                   UPDATE    SDFTCSD0

     C                   EXSR      SrLoadFTCS
     C                   EVAL      PAftFTCS = SDFTCS

     C                   IF        PMode <> 'I'
     C                             AND CSD092 = 'Y'
     C                             AND Wupdat = 'Y'                                         MD027315
      ** If Information only mode do not update History

     C                   EVAL      PELEC =  'Y'

     C**********         IF        PMode <> 'A'                                    MD027295 MD027355
     C                   IF        PMode = 'A' AND                                          MD027355
     C                             PBefFTCS = PAftFTCS                                      MD027355
     C                   ELSE                                                               MD027355
     C                   CALL      'SD009696'
     C                   PARM      FACUST        PCUST
     C                   PARM      *BLANKS       PBefCUST
     C                   PARM      *BLANKS       PAftCUST
     C                   PARM      *BLANKS       PBefACUS
     C                   PARM      *BLANKS       PAftACUS
     C                   PARM                    PBefFTCS
     C                   PARM                    PAftFTCS
     C                   PARM      *BLANKS       PBefJACC
     C                   PARM      *BLANKS       PAftJACC
     C                   PARM      *BLANKS       PBefCUAH
     C                   PARM      *BLANKS       PAftCUAH
     C                   PARM      *BLANKS       PBefCUXC                                   MD026854
     C                   PARM      *BLANKS       PAftCUXC                                   MD026854
     C                   PARM      'N'           PACRV
     C                   PARM                    PELEC
     C                   PARM      *BLANKS       PBefCRSH                                   MD051218
     C                   PARM      *BLANKS       PAftCRSH                                   MD051218
     C                   PARM      *BLANKS       PBefCRSD                                   MD051218
     C                   PARM      *BLANKS       PAftCRSD                                   MD051218
     C                   ENDIF                                                              MD027295
     C                   ENDIF

     C                   ENDSR

      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrChkCustInd - Check Customer Indicia (SYS and OVR)           *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrChkCustInd  BEGSR

     C                   EVAL      WOvrOff = 1
      ** Check if any override flag has been set on
      ** If any has been set, this needs to get flagged as having indicia
     C                   IF        %SCAN('Y':CustOverideDS) = 0

     C                   DOU       WOvrOff > IndiciaCount
     C                             OR  WOvrOff = 0

      ** Check any override as 'N' possibly invalidating
      ** system value Indicia
     C                   EVAL      WOvrOff =
     C                               %SCAN('Y':CustIndiciaDS:WOvrOff)
     C                   EVAL      WSysOff = WOvrOff
     C                   IF        WOvrOff <> 0
     C                   EVAL      WSysOff =
     C                               %SCAN('N':CustOverideDS:WSysOff)
     C                   ENDIF

      ** If offsets match, system value has been overriden
     C                   IF        WSysOff <> WOvrOff
     C                             AND WOvrOff <> 0
     C                   EVAL      WHasIndicia = 'Y'
     C                   LEAVE
     C                   ENDIF
     C                   IF        WOvrOff <> 0
     C                   EVAL      WOvrOff = WOvrOff + 1
     C                   ENDIF

     C                   ENDDO

     C                   ELSE
     C                   EVAL      WHasIndicia = 'Y'
     C                   ENDIF

     C                   ENDSR

      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrChkNAHoInd - Check Non Account Holder Indicia (SYS and OVR) *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrChkNAHoInd  BEGSR

     C                   EVAL      WOvrOff = 1
      ** Check if any override flag has been set on
      ** If any has been set, this needs to get flagged as having indicia
     C                   IF        %SCAN('Y':NAHoOverideDS) = 0

     C                   DOU       WOvrOff > IndiciaCount
     C                             OR  WOvrOff = 0

      ** Check any override as 'N' possibly invalidating
      ** system value Indicia
     C                   EVAL      WOvrOff =
     C                               %SCAN('Y':NAHoIndiciaDS:WOvrOff)
     C                   EVAL      WSysOff = WOvrOff
     C                   IF        WOvrOff <> 0
     C                   EVAL      WSysOff =
     C                               %SCAN('N':NAHoOverideDS:WSysOff)
     C                   ENDIF

      ** If offsets match, system value has been overriden
     C                   IF        WSysOff <> WOvrOff
     C                             AND WOvrOff <> 0
     C                   EVAL      WHasIndicia = 'Y'
     C                   LEAVE
     C                   ENDIF
     C                   IF        WOvrOff <> 0
     C                   EVAL      WOvrOff = WOvrOff + 1
     C                   ENDIF

     C                   ENDDO

     C                   ELSE
     C                   EVAL      WHasIndicia = 'Y'
     C                   ENDIF

     C                   ENDSR

      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrCheckJACM - Process Joint Account Members Indicia           *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrCheckJACM   BEGSR

     C                   EVAL      KCUST = PTranID

     C     KCUST         CHAIN     SDCUSTL1
                                                                                            MD027125
     C     KCUST         CHAIN     SDFTCSL0                                                 MD027125
      ** If this is being run as part of automatic updates,
      ** Indicia should not be updated when tool has not been run
      ** manually first for the Customer
     C**********         IF        (PMode = 'A'                                             MD040497
     C**********                   AND BBTYLC = 'A'                                         MD040497
     C**********                   AND CustIndiciaDS = *BLANKS)                             MD040497
     C**********                   OR (PMode = 'A'                                          MD040497
     C                   IF        (PMode = 'A'                                             MD040497
     C                             AND BBTYLC = 'I'
     C                             AND BBLCD  < WEffDate
     C                             AND CustIndiciaDS = *BLANKS)
     C                   RETURN
     C                   ENDIF

     C                   IF        PMode <> 'A'
     C     *LOVAL        SETLL     SDJACCLC
     C                   READ      SDJACCLC
     C                   ELSE
     C                   EVAL      KCUST = PTranID
     C     KCUST         SETLL     SDJACCLC
     C     KCUST         READE     SDJACCLC
     C                   ENDIF

     C                   DOW       NOT %EOF(SDJACCLC)
     C                   EVAL      JIdx = 1

      ** Timestamp
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp

     C                   MOVE      TimeStamp     WTime
     C     *HMS0         MOVE      WTime         WWTIME

     C     J8JANO        CHAIN     SDFTCSL0

     C                   IF        FAJASV = 'Y'
     C                             AND PMode = 'A'

     C                   EXSR      SrLoadFTCS
     C                   EVAL      PBefFTCS = SDFTCS
     C                   EVAL      PAftFTCS = SDFTCS

     C**********         IF        PMode =  'A'                                            MD027355A
     C**********                   AND CSD092 = 'Y'                                        MD027355A
     C                   IF        CSD092 = 'Y'                                            MD027355A
     C                             AND Wupdat = 'Y'                                        MD027355B
      ** If Information only mode do not update History

     C**********         CALL      'SDC009696'                                              MD026854
     C**********         IF        PMode <> 'A'                                    MD027295 MD027355
     C                   IF        PMode = 'A' AND                                          MD027355
     C                             PBefFTCS = PAftFTCS                                      MD027355
     C                   ELSE                                                               MD027355
     C                   CALL      'SD009696'
     C                   PARM      FACUST        PCUST
     C                   PARM      *BLANKS       PBefCUST
     C                   PARM      *BLANKS       PAftCUST
     C                   PARM      *BLANKS       PBefACUS
     C                   PARM      *BLANKS       PAftACUS
     C                   PARM                    PBefFTCS
     C                   PARM                    PAftFTCS
     C                   PARM      *BLANKS       PBefJACC
     C                   PARM      *BLANKS       PAftJACC
     C                   PARM      *BLANKS       PBefCUAH                                   MD026854
     C                   PARM      *BLANKS       PAftCUAH                                   MD026854
     C                   PARM      *BLANKS       PBefCUXC                                   MD026854
     C                   PARM      *BLANKS       PAftCUXC                                   MD026854
     C                   PARM      'N'           PACRV
     C                   PARM      'Y'           PELEC
     C                   PARM      *BLANKS       PBefCRSH                                     CGL177
     C                   PARM      *BLANKS       PAftCRSH                                     CGL177
     C                   PARM      *BLANKS       PBefCRSD                                     CGL177
     C                   PARM      *BLANKS       PAftCRSD                                     CGL177
     C                   ENDIF                                                              MD027295
     C                   ENDIF

     C                   UPDATE    SDFTCSD0
     C                   LEAVESR
     C                   ENDIF

      ** Only process indicia not yet Y and Tool has been ran
     C                   IF        FAJASV = 'Y'
     C                             OR CustIndiciaDS = *BLANKS
     C                             AND PMode = 'M'
     C                   READ      SDJACCLC
     C                   ITER
     C                   ENDIF

     C                   EVAL      WJointAcChk(JIdx).JointAc = J8JANO
     C                   EVAL      MCount = 1
     C                   EVAL      WJointAcChk(JIdx).MemCount = MCount

      ** A Blank customer field means that this only has NAHO members
      ** which means that this only has 1 layer
     C                   IF        J8CUST = *BLANKS
     C                   EVAL      WKey = J8JANO
     C                   EXSR      SRJacmNAHO

      ** If indicia has been found and Joint Account Hierarchy
      ** updated, read next record and return control to loop
     C                   IF        WHasIndicia ='Y'

      ** If any indicia has been found, Tag all Joint Accounts
      ** assosciated to have the Joint Account Indicia
     C                   DOW       JIdx >= 1
     C                   EVAL      WKey  = WJointAcChk(JIdx).JointAc
     C     WKey          CHAIN     SDFTCSL0

     C                   EXSR      SrLoadFTCS
     C                   EVAL      PBefFTCS = SDFTCS

     C                   IF        FAJASV <> 'Y'
     C                   EVAL      FAJASV = 'Y'
     C                   EVAL      FAJASD = BJRDNB
     C                   EVAL      FAJAST = WWTIME
     C                   UPDATE    SDFTCSD0

     C                   EXSR      SrLoadFTCS
     C                   EVAL      PAftFTCS = SDFTCS

     C**********         IF        PMode =  'A'                                            MD027355A
     C**********                   AND CSD092 = 'Y'                                        MD027355A
     C                   IF        CSD092 = 'Y'                                            MD027355A
     C                             AND Wupdat = 'Y'                                        MD027355B
      ** If Information only mode do not update History

     C**********         CALL      'SDC009696'                                              MD026854
     C**********         IF        PMode <> 'A'                                    MD027295 MD027355
     C                   IF        PMode = 'A' AND                                          MD027355
     C                             PBefFTCS = PAftFTCS                                      MD027355
     C                   ELSE                                                               MD027355
     C                   CALL      'SD009696'
     C                   PARM      FACUST        PCUST
     C                   PARM      *BLANKS       PBefCUST
     C                   PARM      *BLANKS       PAftCUST
     C                   PARM      *BLANKS       PBefACUS
     C                   PARM      *BLANKS       PAftACUS
     C                   PARM                    PBefFTCS
     C                   PARM                    PAftFTCS
     C                   PARM      *BLANKS       PBefJACC
     C                   PARM      *BLANKS       PAftJACC
     C                   PARM      *BLANKS       PBefCUAH                                   MD026854
     C                   PARM      *BLANKS       PAftCUAH                                   MD026854
     C                   PARM      *BLANKS       PBefCUXC                                   MD026854
     C                   PARM      *BLANKS       PAftCUXC                                   MD026854
     C                   PARM      'N'           PACRV
     C                   PARM      'Y'           PELEC
     C                   PARM      *BLANKS       PBefCRSH                                     CGL177
     C                   PARM      *BLANKS       PAftCRSH                                     CGL177
     C                   PARM      *BLANKS       PBefCRSD                                     CGL177
     C                   PARM      *BLANKS       PAftCRSD                                     CGL177
     C                   ENDIF                                                              MD027295
     C                   ENDIF

     C                   ENDIF
     C                   EVAL      JIdx = JIdx - 1
     C                   ENDDO

     C                   IF        FAJASV = 'Y'
     C                             AND PMode = 'A'
     C                   LEAVESR
     C                   ENDIF

     C                   READ      SDJACCLC
     C                   ITER
     C                   ENDIF

     C                   ELSE

     C                   EVAL      JIdx = JIdx + 1
     C                   EVAL      WJointAcChk(JIdx).JointAc = J8CUST
     C     Reposition    TAG
     C                   EVAL      WKey = WJointAcChk(JIdx).JointAc
     C     MemCountTag   TAG
     C     WKey          SETLL     SDJACCLD
     C                   EVAL      WJointAcChk(JIdx).MemCount = MCount

      ** Reposition to current Node
     C                   EVAL      WLoopCnt = 0
     C                   DOW       WLoopCnt < WJointAcChk(JIdx).MemCount
     C     WKey          READE     SDJACCLD
     C                   EVAL      WLoopCnt = WLoopCnt + 1
     C                   ENDDO

     C                   SELECT

      ** An End of File on the READ means that all the Nodes
      ** has been exhausted on this Hierarchy Level
     C                   WHEN      %EOF(SDJACCLD)
     C     WKey          CHAIN     SDFTCSL0
     C                   EVAL      WHasIndicia = 'N'
     C                   EXSR      SrChkCustInd

     C                   IF        WHasIndicia = 'Y'
     C                             AND JIdx > 1

      ** If any indicia has been found, Tag all Joint Accounts
      ** assosciated to have the Joint Account Indicia
     C                   DOW       JIdx >  1
     C                   EVAL      JIdx = JIdx - 1
     C                   EVAL      WKey  = WJointAcChk(JIdx).JointAc
     C     WKey          CHAIN     SDFTCSL0

     C                   EXSR      SrLoadFTCS
     C                   EVAL      PBefFTCS = SDFTCS

     C                   IF        FAJASV <> 'Y'
     C                   EVAL      FAJASV = 'Y'
     C                   EVAL      FAJASD = BJRDNB
     C                   EVAL      FAJAST = WWTIME
     C                   UPDATE    SDFTCSD0

     C                   EXSR      SrLoadFTCS
     C                   EVAL      PAftFTCS = SDFTCS

     C**********         IF        PMode =  'A'                                            MD027355A
     C**********                   AND CSD092 = 'Y'                                        MD027355A
     C                   IF        CSD092 = 'Y'                                            MD027355A
     C                             AND Wupdat = 'Y'                                        MD027355B
      ** If Information only mode do not update History

     C**********         CALL      'SDC009696'                                              MD026854
     C**********         IF        PMode <> 'A'                                    MD027295 MD027355
     C                   IF        PMode = 'A' AND                                          MD027355
     C                             PBefFTCS = PAftFTCS                                      MD027355
     C                   ELSE                                                               MD027355
     C                   CALL      'SD009696'
     C                   PARM      FACUST        PCUST
     C                   PARM      *BLANKS       PBefCUST
     C                   PARM      *BLANKS       PAftCUST
     C                   PARM      *BLANKS       PBefACUS
     C                   PARM      *BLANKS       PAftACUS
     C                   PARM                    PBefFTCS
     C                   PARM                    PAftFTCS
     C                   PARM      *BLANKS       PBefJACC
     C                   PARM      *BLANKS       PAftJACC
     C                   PARM      *BLANKS       PBefCUAH                                   MD026854
     C                   PARM      *BLANKS       PAftCUAH                                   MD026854
     C                   PARM      *BLANKS       PBefCUXC                                   MD026854
     C                   PARM      *BLANKS       PAftCUXC                                   MD026854
     C                   PARM      'N'           PACRV
     C                   PARM      'Y'           PELEC
     C                   PARM      *BLANKS       PBefCRSH                                     CGL177
     C                   PARM      *BLANKS       PAftCRSH                                     CGL177
     C                   PARM      *BLANKS       PBefCRSD                                     CGL177
     C                   PARM      *BLANKS       PAftCRSD                                     CGL177
     C                   ENDIF                                                              MD027295
     C                   ENDIF

     C                   ENDIF
     C                   ENDDO

     C                   IF        FAJASV = 'Y'
     C                             AND PMode = 'A'
     C                   LEAVESR
     C                   ENDIF

      ** Read next record after flagging
     C                   READ      SDJACCLC
     C                   ITER
     C                   ELSE

      ** If end of hierarchy but current node does not have indicia,
      ** Check next node
     C                   IF        JIdx > 1

      ** If this has Joint Account Members but no US indicia
     C                   IF        WJointAcChk(JIdx).MemCount > 1
     C                   ENDIF

     C                   EVAL      WKey  = WJointAcChk(JIdx).JointAc
     C     WKey          CHAIN     SDFTCSL0

     C                   EXSR      SrLoadFTCS
     C                   EVAL      PBefFTCS = SDFTCS

     C                   IF        FAJASV = ' '
     C                   EVAL      FAJASV = 'N'
     C                   EVAL      FAJASD = BJRDNB
     C                   EVAL      FAJAST = WWTIME
     C                   UPDATE    SDFTCSD0

     C                   EXSR      SrLoadFTCS
     C                   EVAL      PAftFTCS = SDFTCS

     C**********         IF        PMode =  'A'                                            MD027355A
     C**********                   AND CSD092 = 'Y'                                        MD027355A
     C                   IF        CSD092 = 'Y'                                            MD027355A
     C                             AND Wupdat = 'Y'                                        MD027355B
      ** If Information only mode do not update History

     C**********         CALL      'SDC009696'                                              MD026854
     C**********         IF        PMode <> 'A'                                    MD027295 MD027355
     C                   IF        PMode = 'A' AND                                          MD027355
     C                             PBefFTCS = PAftFTCS                                      MD027355
     C                   ELSE                                                               MD027355
     C                   CALL      'SD009696'
     C                   PARM      FACUST        PCUST
     C                   PARM      *BLANKS       PBefCUST
     C                   PARM      *BLANKS       PAftCUST
     C                   PARM      *BLANKS       PBefACUS
     C                   PARM      *BLANKS       PAftACUS
     C                   PARM                    PBefFTCS
     C                   PARM                    PAftFTCS
     C                   PARM      *BLANKS       PBefJACC
     C                   PARM      *BLANKS       PAftJACC
     C                   PARM      *BLANKS       PBefCUAH                                   MD026854
     C                   PARM      *BLANKS       PAftCUAH                                   MD026854
     C                   PARM      *BLANKS       PBefCUXC                                   MD026854
     C                   PARM      *BLANKS       PAftCUXC                                   MD026854
     C                   PARM      'N'           PACRV
     C                   PARM      'Y'           PELEC
     C                   PARM      *BLANKS       PBefCRSH                                     CGL177
     C                   PARM      *BLANKS       PAftCRSH                                     CGL177
     C                   PARM      *BLANKS       PBefCRSD                                     CGL177
     C                   PARM      *BLANKS       PAftCRSD                                     CGL177
     C                   ENDIF                                                              MD027295
     C                   ENDIF

     C                   ENDIF

     C                   EVAL      JIdx = JIdx - 1
     C                   EVAL      MCount = WJointAcChk(JIdx).MemCount
     C                   EVAL      MCount = MCount + 1
     C                   GOTO      Reposition
     C                   ELSE

      ** End of File and Top Node
     C                   IF        FAJASV = ' '
     C                   EVAL      FAJASV = 'N'
     C                   EVAL      FAJASD = BJRDNB
     C                   EVAL      FAJAST = WWTIME
     C                   UPDATE    SDFTCSD0
     C                   ENDIF

     C                   IF        FAJASV = 'Y'
     C                             AND PMode = 'A'
     C                   LEAVESR
     C                   ENDIF

     C                   READ      SDJACCLC
     C                   ITER
     C                   ENDIF

     C                   ENDIF

     C                   WHEN      NOT %EOF(SDJACCLD)
     C                             AND J9CUST = *BLANKS
     C                   EVAL      WKey = J9JANO
     C                   EXSR      SRJacmNAHO
     C                   IF        WHasIndicia = 'Y'

      ** If any indicia has been found, Tag all Joint Accounts
      ** assosciated to have the Joint Account Indicia
     C                   DOW       JIdx >  1
     C                   EVAL      JIdx = JIdx - 1
     C                   EVAL      WKey  = WJointAcChk(JIdx).JointAc
     C     WKey          CHAIN     SDFTCSL0

     C                   EXSR      SrLoadFTCS
     C                   EVAL      PBefFTCS = SDFTCS

     C                   IF        FAJASV <> 'Y'
     C                   EVAL      FAJASV = 'Y'
     C                   EVAL      FAJASD = BJRDNB
     C                   EVAL      FAJAST = WWTIME
     C                   UPDATE    SDFTCSD0

     C                   EXSR      SrLoadFTCS
     C                   EVAL      PAftFTCS = SDFTCS

     C**********         IF        PMode =  'A'                                            MD027355A
     C**********                   AND CSD092 = 'Y'                                        MD027355A
     C                   IF        CSD092 = 'Y'                                            MD027355A
     C                             AND Wupdat = 'Y'                                        MD027355B
      ** If Information only mode do not update History

     C**********         CALL      'SDC009696'                                              MD026854
     C**********         IF        PMode <> 'A'                                    MD027295 MD027355
     C                   IF        PMode = 'A' AND                                          MD027355
     C                             PBefFTCS = PAftFTCS                                      MD027355
     C                   ELSE                                                               MD027355
     C                   CALL      'SD009696'
     C                   PARM      FACUST        PCUST
     C                   PARM      *BLANKS       PBefCUST
     C                   PARM      *BLANKS       PAftCUST
     C                   PARM      *BLANKS       PBefACUS
     C                   PARM      *BLANKS       PAftACUS
     C                   PARM                    PBefFTCS
     C                   PARM                    PAftFTCS
     C                   PARM      *BLANKS       PBefJACC
     C                   PARM      *BLANKS       PAftJACC
     C                   PARM      *BLANKS       PBefCUAH                                   MD026854
     C                   PARM      *BLANKS       PAftCUAH                                   MD026854
     C                   PARM      *BLANKS       PBefCUXC                                   MD026854
     C                   PARM      *BLANKS       PAftCUXC                                   MD026854
     C                   PARM      'N'           PACRV
     C                   PARM      'Y'           PELEC
     C                   PARM      *BLANKS       PBefCRSH                                     CGL177
     C                   PARM      *BLANKS       PAftCRSH                                     CGL177
     C                   PARM      *BLANKS       PBefCRSD                                     CGL177
     C                   PARM      *BLANKS       PAftCRSD                                     CGL177
     C                   ENDIF                                                              MD027295
     C                   ENDIF

     C                   ENDIF
     C                   ENDDO

     C                   IF        FAJASV = 'Y'
     C                             AND PMode = 'A'
     C                   LEAVESR
     C                   ENDIF

     C                   READ      SDJACCLC
     C                   ITER

     C                   ELSE

     C                   IF        JIdx >  1
     C                   EVAL      JIdx = JIdx - 1
     C                   EVAL      MCount = WJointAcChk(JIdx).MemCount
     C                   EVAL      MCount = MCount + 1
     C                   GOTO      Reposition
     C                   ELSE
     C                   EVAL      MCount = MCount + 1
     C                   GOTO      MemCountTag
     C                   ENDIF
     C                   ENDIF

     C                   WHEN      NOT %EOF(SDJACCLD)
     C                   EVAL      JIdx = JIdx + 1
     C                   EVAL      WJointAcChk(JIdx).JointAc = J9CUST
     C                   EVAL      MCount = 1
     C                   GOTO      Reposition

     C                   ENDSL

     C                   ENDIF

     C                   IF        PMode <> 'A'
     C                   READ      SDJACCLC
     C                   ELSE
     C                   EVAL      KCUST = PTranID
     C     KCUST         READE     SDJACCLC
     C                   ENDIF

     C                   ENDDO

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************                     MD026705
      *                                                               *                     MD026705
      * SrCheckAuth - Process Authority Holders Indicia               *                     MD026705
      *                                                               *                     MD026705
      * Called by: Main                                               *                     MD026705
      *                                                               *                     MD026705
      * Calls: None                                                   *                     MD026705
      *                                                               *                     MD026705
      *****************************************************************                     MD026705
                                                                                            MD026705
     C     SrCheckAUTH   BEGSR                                                              MD026705
                                                                                            MD026705
     C                   EVAL      KCUST = PTranID                                          MD026705
                                                                                            MD026705
     C     KCUST         CHAIN     SDCUSTL1                                                 MD026705
                                                                                            MD027125
     C     KCUST         CHAIN     SDFTCSL0                                                 MD027125
      ** If this is being run as part of automatic updates,                                 MD026705
      ** Indicia should not be updated when tool has not been run                           MD026705
      ** manually first for the Customer                                                    MD026705
     C                   IF        (PMode = 'A'                                             MD026705
     C                             AND BBTYLC = 'A'                                         MD026705
     C                             AND CustIndiciaDS = *BLANKS)                             MD026705
     C                             OR (PMode = 'A'                                          MD026705
     C                             AND BBTYLC = 'I'                                         MD026705
     C                             AND BBLCD  < WEffDate                                    MD026705
     C                             AND CustIndiciaDS = *BLANKS)                             MD026705
     C                   RETURN                                                             MD026705
     C                   ENDIF                                                              MD026705
                                                                                            MD026705
     C                   IF        PMode <> 'A'                                             MD026705
     C     *LOVAL        SETLL     SDCUAHL0                                                 MD026705
     C                   READ      SDCUAHL0                                                 MD026705
     C                   ELSE                                                               MD026705
     C                   EVAL      KCUST = PTranID                                          MD026705
     C     KCUST         SETLL     SDCUAHL0                                                 MD026705
     C     KCUST         READE     SDCUAHL0                                                 MD026705
     C                   ENDIF                                                              MD026705
                                                                                            MD026705
      ** Timestamp                                                                          MD026705
     C                   CALLB     'ZAGENTMSTM'                                             MD026705
     C                   PARM                    TimeStamp                                  MD026705
                                                                                            MD026705
     C                   MOVE      TimeStamp     WTime                                      MD026705
     C     *HMS0         MOVE      WTime         WWTIME                                     MD026705
                                                                                            MD026705
     C                   DOW       NOT %EOF(SDCUAHL0)                                       MD026705
     C                   EVAL      AIdx = 1                                                 MD026705
                                                                                            MD026705
     C     L0CUST        CHAIN     SDFTCSL0                                                 MD026705
                                                                                            MD026705
     C                   IF        FAAUSV = 'Y'                                             MD026705
     C                             AND PMode = 'A'                                          MD026705
                                                                                            MD026705
     C                   EXSR      SrLoadFTCS                                               MD026705
     C                   EVAL      PBefFTCS = SDFTCS                                        MD026705
                                                                                            MD026705
     C                   EXSR      SRHCISProc                                               MD026705
                                                                                            MD026705
     C                   UPDATE    SDFTCSD0                                                 MD026705
     C                   LEAVESR                                                            MD026705
     C                   ENDIF                                                              MD026705
                                                                                            MD026705
      ** Only process indicia not yet Y and Tool has been ran                               MD026705
     C                   IF        FAAUSV = 'Y'                                             MD026705
     C                             OR CustIndiciaDS = *BLANKS                               MD026705
     C                             AND PMode = 'M'                                          MD026705
     C                   READ      SDCUAHL0                                                 MD026705
     C                   ITER                                                               MD026705
     C                   ENDIF                                                              MD026705
                                                                                            MD026705
     C                   EVAL      WKey = L0CUST                                            MD026705
     C                   EVAL      WAuthHolChk(AIdx).AuthHold = L0CUST                      MD026705
     C                   EVAL      MCount = 1                                               MD026705
     C                   EVAL      WAuthHolChk(AIdx).MemCount = MCount                      MD026705
                                                                                            MD026705
      ** If Key Length is greater than 6, this means that the Holder                        MD026705
      ** is a Non-Account Holder. Check Indicia for the NAHO, and if                        MD026705
      ** present, flag all concerned authority holders (done in SR)                         MD026705
      ** afterwards, terminate the process for the Auth Holder                              MD026705
                                                                                            MD026705
     C     NAHOPos       TAG                                                                MD026705
     C                   IF        %LEN(%TRIM(L0AUTH)) = 6                                  MD026705
     C                   EVAL      AIdx = AIdx + 1                                          MD026705
     C                   EVAL      WAuthHolChk(AIdx).AuthHold = L0AUTH                      MD026705
     C                   ELSE                                                               MD026705
                                                                                            MD026705
     C                   EVAL      WKeyNAHO = L0AUTH                                        MD026705
     C                   EXSR      SRAuthNAHO                                               MD026705
                                                                                            MD026705
     C                   IF        WNAHORoll = 'Y'                                          MD026705
                                                                                            MD026705
      ** If an indicia has been found, read next record if not                              MD026705
      ** on 'A'utomatic mode                                                                MD026705
     C                   IF        PMode <> 'A'                                             MD026705
     C                   READ      SDCUAHL0                                                 MD026705
     C                   ITER                                                               MD026705
     C                   ELSE                                                               MD026705
     C                   LEAVESR                                                            MD026705
     C                   ENDIF                                                              MD026705
                                                                                            MD026705
     C                   ELSE                                                               MD026705
                                                                                            MD026705
     C     WKey          READE     SDCUAHL0                                                 MD026705
                                                                                            MD026705
     C                   IF        NOT %EOF(SDCUAHL0)                                       MD026705
     C                   EVAL      MCount = MCount + 1                                      MD026705
     C                   GOTO      NAHOPos                                                  MD026705
     C                   ENDIF                                                              MD026705
     C                   ENDIF                                                              MD026705
                                                                                            MD026705
     C                   ENDIF                                                              MD026705
     C     RepositionAH  TAG                                                                MD026705
                                                                                            MD026705
      ** A length of 6 means that the authority holder is a customer                        MD026705
      ** and can have authority holders of his own                                          MD026705
     C                   EVAL      WKey = WAuthHolChk(AIdx).AuthHold                        MD026705
                                                                                            MD026705
     C     MemCountTagA  TAG                                                                MD026705
     C     WKey          SETLL     SDCUAHL1                                                 MD026705
     C                   EVAL      WAuthHolChk(AIdx).MemCount = MCount                      MD026705
                                                                                            MD026705
      ** Reposition to current Node                                                         MD026705
     C                   EVAL      WLoopCnt = 0                                             MD026705
     C                   DOW       WLoopCnt < WAuthHolChk(AIdx).MemCount                    MD026705
     C     WKey          READE     SDCUAHL1                                                 MD026705
     C                   EVAL      WLoopCnt = WLoopCnt + 1                                  MD026705
     C                   ENDDO                                                              MD026705
                                                                                            MD026705
     C                   SELECT                                                             MD026705
                                                                                            MD026705
      ** An End of File on the READ means that all the Nodes                                MD026705
      ** has been exhausted on this Hierarchy Level                                         MD026705
     C                   WHEN      %EOF(SDCUAHL1)                                           MD026705
     C     WKey          CHAIN     SDFTCSL0                                                 MD026705
     C                   EVAL      WHasIndicia = 'N'                                        MD026705
     C                   EXSR      SrChkCustInd                                             MD026705
                                                                                            MD026705
     C                   IF        WHasIndicia = 'Y'                                        MD026705
     C                             AND AIdx > 1                                             MD026705
                                                                                            MD026705
      ** If any indicia has been found, Tag all Authority Holders                           MD026705
      ** assosciated to have the Auth Holders Indicia                                       MD026705
     C                   DOW       AIdx >  1                                                MD026705
     C                   EVAL      AIdx = AIdx - 1                                          MD026705
     C                   EVAL      WKey  = WAuthHolChk(AIdx).AuthHold                       MD026705
     C     WKey          CHAIN     SDFTCSL0                                                 MD026705
                                                                                            MD026705
     C                   EXSR      SrLoadFTCS                                               MD026705
     C                   EVAL      PBefFTCS = SDFTCS                                        MD026705
                                                                                            MD026705
     C                   IF        FAAUSV <> 'Y'                                            MD026705
     C                   EVAL      FAAUSV = 'Y'                                             MD026705
     C                   EVAL      FAAUSD = BJRDNB                                          MD026705
     C                   EVAL      FAAUST = WWTIME                                          MD026705
     C                   UPDATE    SDFTCSD0                                                 MD026705
                                                                                            MD026705
     C                   EXSR      SRHCISProc                                               MD026705
                                                                                            MD026705
     C                   ENDIF                                                              MD026705
     C                   ENDDO                                                              MD026705
                                                                                            MD026705
     C                   IF        FAAUSV = 'Y'                                             MD026705
     C                             AND PMode = 'A'                                          MD026705
     C                   LEAVESR                                                            MD026705
     C                   ENDIF                                                              MD026705
                                                                                            MD026705
     C                   IF        AIdx >  1                                                MD026705
     C                   EVAL      AIdx = AIdx - 1                                          MD026705
     C                   EVAL      MCount = WAuthHolChk(AIdx).MemCount                      MD026705
     C                   EVAL      MCount = MCount + 1                                      MD026705
     C                   GOTO      RepositionAH                                             MD026705
     C                   ELSE                                                               MD026705
                                                                                            MD026705
      ** Read next record after flagging                                                    MD026705
     C                   IF        PMode <> 'A'                                             MD026705
     C                   READ      SDCUAHL0                                                 MD026705
     C                   ITER                                                               MD026705
     C                   ELSE                                                               MD026705
     C                   LEAVESR                                                            MD026705
     C                   ENDIF                                                              MD026705
                                                                                            MD026705
     C                   ENDIF                                                              MD026705
                                                                                            MD026705
     C                   ELSE                                                               MD026705
                                                                                            MD026705
      ** If end of hierarchy but current node does not have indicia,                        MD026705
      ** Check next node                                                                    MD026705
     C                   IF        AIdx > 1                                                 MD026705
                                                                                            MD026705
      ** If this has Authority Holders but no US indicia                                    MD026705
     C                   IF        WAuthHolChk(AIdx).MemCount > 1                           MD026705
     C                   ENDIF                                                              MD026705
                                                                                            MD026705
     C                   EVAL      WKey  = WAuthHolChk(AIdx).AuthHold                       MD026705
     C     WKey          CHAIN     SDFTCSL0                                                 MD026705
                                                                                            MD026705
     C                   EXSR      SrLoadFTCS                                               MD026705
     C                   EVAL      PBefFTCS = SDFTCS                                        MD026705
                                                                                            MD026705
     C                   IF        FAAUSV = ' '                                             MD026705
     C                   EVAL      FAAUSV = 'N'                                             MD026705
     C                   EVAL      FAAUSD = BJRDNB                                          MD026705
     C                   EVAL      FAAUST = WWTIME                                          MD026705
     C                   UPDATE    SDFTCSD0                                                 MD026705
                                                                                            MD026705
     C                   EXSR      SRHCISProc                                               MD026705
                                                                                            MD026705
     C                   ENDIF                                                              MD026705
                                                                                            MD026705
     C                   EVAL      AIdx = AIdx - 1                                          MD026705
     C                   EVAL      MCount = WAuthHolChk(AIdx).MemCount                      MD026705
     C                   EVAL      MCount = MCount + 1                                      MD026705
     C                   GOTO      RepositionAH                                             MD026705
     C                   ELSE                                                               MD026705
                                                                                            MD026705
      ** End of File and Top Node                                                           MD026705
     C                   IF        FAAUSV = ' '                                             MD026705
     C                   EVAL      FAAUSV = 'N'                                             MD026705
     C                   EVAL      FAAUSD = BJRDNB                                          MD026705
     C                   EVAL      FAAUST = WWTIME                                          MD026705
     C                   UPDATE    SDFTCSD0                                                 MD026705
     C                   ENDIF                                                              MD026705
                                                                                            MD026705
     C                   IF        FAAUSV = 'Y'                                             MD026705
     C                             AND PMode = 'A'                                          MD026705
     C                   LEAVESR                                                            MD026705
     C                   ENDIF                                                              MD026705
                                                                                            MD026705
     C                   IF        PMode <> 'A'                                             MD026705
     C                   READ      SDCUAHL0                                                 MD026705
     C                   ITER                                                               MD026705
     C                   ELSE                                                               MD026705
     C                   LEAVESR                                                            MD026705
     C                   ENDIF                                                              MD026705
                                                                                            MD026705
     C                   ENDIF                                                              MD026705
                                                                                            MD026705
     C                   ENDIF                                                              MD026705
                                                                                            MD026705
     C                   WHEN      NOT %EOF(SDCUAHL1)                                       MD026705
     C                             AND %LEN(%TRIM(L1AUTH)) > 6                              MD026705
     C                   EVAL      WKeyNAHO = L1AUTH                                        MD026705
     C                   EXSR      SRAuthNAHO                                               MD026705
                                                                                            MD026705
     C                   IF        WNAHORoll = 'Y'                                          MD026705
                                                                                            MD026705
      ** If an indicia has been found, read next record if not                              MD026705
      ** on 'A'utomatic mode                                                                MD026705
     C                   IF        PMode <> 'A'                                             MD026705
     C                   READ      SDCUAHL0                                                 MD026705
     C                   ITER                                                               MD026705
     C                   ELSE                                                               MD026705
     C                   LEAVESR                                                            MD026705
     C                   ENDIF                                                              MD026705
                                                                                            MD026705
     C                   ELSE                                                               MD026705
                                                                                            MD026705
     C                   EVAL      MCount = MCount + 1                                      MD026705
     C                   GOTO      MemCountTagA                                             MD026705
                                                                                            MD026705
     C                   ENDIF                                                              MD026705
                                                                                            MD026705
     C                   WHEN      NOT %EOF(SDCUAHL1)                                       MD026705
                                                                                            MD026705
     C                   EVAL      WCustAuth = L1AUTH                                       MD026705
     C     WCustAuth     CHAIN     SDFTCSL0                                                 MD026705
     C                   EVAL      WHasIndicia = 'N'                                        MD026705
     C                   EXSR      SrChkCustInd                                             MD026705
                                                                                            MD026705
     C                   IF        WHasIndicia = 'Y'                                        MD026705
                                                                                            MD026705
      ** If any indicia has been found, Tag all Authority Holders                           MD026705
      ** assosciated to have the Auth Holders Indicia                                       MD026705
     C                   DOW       AIdx >  0                                                MD026705
     C                   EVAL      WKey  = WAuthHolChk(AIdx).AuthHold                       MD026705
     C     WKey          CHAIN     SDFTCSL0                                                 MD026705
                                                                                            MD026705
     C                   EXSR      SrLoadFTCS                                               MD026705
     C                   EVAL      PBefFTCS = SDFTCS                                        MD026705
                                                                                            MD026705
     C                   IF        FAAUSV <> 'Y'                                            MD026705
     C                   EVAL      FAAUSV = 'Y'                                             MD026705
     C                   EVAL      FAAUSD = BJRDNB                                          MD026705
     C                   EVAL      FAAUST = WWTIME                                          MD026705
     C                   UPDATE    SDFTCSD0                                                 MD026705
                                                                                            MD026705
     C                   EXSR      SRHCISProc                                               MD026705
                                                                                            MD026705
     C                   ENDIF                                                              MD026705
     C                   EVAL      AIdx = AIdx - 1                                          MD026705
     C                   ENDDO                                                              MD026705
                                                                                            MD026705
     C                   ENDIF                                                              MD026705
                                                                                            MD026705
     C                   IF        WHasIndicia = 'Y'                                        MD026705
     C                   IF        PMode <> 'A'                                             MD026705
     C                   READ      SDCUAHL0                                                 MD026705
     C                   ITER                                                               MD026705
     C                   ELSE                                                               MD026705
     C                   LEAVESR                                                            MD026705
     C                   ENDIF                                                              MD026705
                                                                                            MD026705
     C                   ELSE                                                               MD026705
                                                                                            MD026705
     C                   MONITOR                                                            MD027199
     C                   EVAL      AIdx = AIdx + 1                                          MD026705
     C                   ON-ERROR  *PROGRAM                                                 MD027199
     C                   EXSR      SrRecurAuth                                              MD027199
                                                                                            MD027199
     C                   IF        PMode <> 'A'                                             MD027199
     C                   READ      SDCUAHL0                                                 MD027199
     C                   ITER                                                               MD027199
     C                   ELSE                                                               MD027199
     C                   LEAVESR                                                            MD027199
     C                   ENDIF                                                              MD027199
                                                                                            MD027199
     C                   ENDMON                                                             MD027199
                                                                                            MD027199
     C                   EVAL      WAuthHolChk(AIdx).AuthHold = L1AUTH                      MD026705
     C                   EVAL      MCount = 1                                               MD026705
     C                   GOTO      RepositionAH                                             MD026705
                                                                                            MD026705
     C                   ENDIF                                                              MD026705
                                                                                            MD026705
     C                   ENDSL                                                              MD026705
                                                                                            MD026705
     C                   IF        PMode <> 'A'                                             MD026705
     C                   READ      SDCUAHL0                                                 MD026705
     C                   ELSE                                                               MD026705
     C                   EVAL      KCUST = PTranID                                          MD026705
     C     KCUST         READE     SDCUAHL0                                                 MD026705
     C                   ENDIF                                                              MD026705
                                                                                            MD026705
     C                   ENDDO                                                              MD026705
                                                                                            MD026705
     C                   ENDSR                                                              MD026705
                                                                                            MD026705
      *****************************************************************                     MD026705
      /EJECT                                                                                MD026705
      *****************************************************************                     MD026705
      *                                                               *                     MD026705
      * SRHCISProc - History of Customer Info Processing              *                     MD026705
      *                                                               *                     MD026705
      * Called by: Implicitly on program activation                   *                     MD026705
      *                                                               *                     MD026705
      * Calls: None                                                   *                     MD026705
      *                                                               *                     MD026705
      *****************************************************************                     MD026705
                                                                                            MD026705
     C     SRHCISProc    BEGSR                                                              MD026705
                                                                                            MD026705
     C                   EXSR      SrLoadFTCS                                               MD026705
     C                   EVAL      PAftFTCS = SDFTCS                                        MD026705
                                                                                            MD026705
     C**********         IF        PMode =  'A'                                   MD026705 MD027355A
     C**********                   AND CSD092 = 'Y'                               MD026705 MD027355A
     C                   IF        CSD092 = 'Y'                                            MD027355A
     C                             AND Wupdat = 'Y'                                        MD027355B
      ** If Information only mode do not update History                                     MD026705
                                                                                            MD026705
     C**********         IF        PMode <> 'A'                                    MD027295 MD027355
     C                   IF        PMode = 'A' AND                                          MD027355
     C                             PBefFTCS = PAftFTCS                                      MD027355
     C                   ELSE                                                               MD027355
     C                   CALL      'SD009696'                                               MD026705
     C                   PARM      FACUST        PCUST                                      MD026705
     C                   PARM      *BLANKS       PBefCUST                                   MD026705
     C                   PARM      *BLANKS       PAftCUST                                   MD026705
     C                   PARM      *BLANKS       PBefACUS                                   MD026705
     C                   PARM      *BLANKS       PAftACUS                                   MD026705
     C                   PARM                    PBefFTCS                                   MD026705
     C                   PARM                    PAftFTCS                                   MD026705
     C                   PARM      *BLANKS       PBefJACC                                   MD026705
     C                   PARM      *BLANKS       PAftJACC                                   MD026705
     C                   PARM      *BLANKS       PBefCUAH                                   MD026705
     C                   PARM      *BLANKS       PAftCUAH                                   MD026705
     C                   PARM      *BLANKS       PBefCUXC                                   MD026705
     C                   PARM      *BLANKS       PAftCUXC                                   MD026705
     C                   PARM      'N'           PACRV                                      MD026705
     C                   PARM      'Y'           PELEC                                      MD026705
     C                   PARM      *BLANKS       PBefCRSH                                     CGL177
     C                   PARM      *BLANKS       PAftCRSH                                     CGL177
     C                   PARM      *BLANKS       PBefCRSD                                     CGL177
     C                   PARM      *BLANKS       PAftCRSD                                     CGL177
     C                   ENDIF                                                              MD027295
     C                   ENDIF                                                              MD026705
                                                                                            MD026705
     C                   ENDSR                                                              MD026705
      *****************************************************************                     MD026705
      /EJECT                                                                                MD026705
      *****************************************************************
      *                                                               *
      * SRJacmNAHO - Joint Account check for NAHO                     *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRJacmNAHO    BEGSR

     C     WKey          SETLL     SDJACCL2
     C     WKey          READE     SDJACCL2

     C                   DOW       NOT %EOF(SDJACCL2)

     C     J2NAHO        CHAIN     SDFTNHL0
     C                   EVAL      WHasIndicia = 'N'
     C                   EXSR      SrChkNAHoInd

     C                   IF        WHasIndicia = 'Y'

      ** If any indicia has been found, Tag all Joint Accounts
      ** assosciated to have the Joint Account Indicia
     C                   DOW       JIdx >= 1
     C                   EVAL      WKey  = WJointAcChk(JIdx).JointAc
     C     WKey          CHAIN     SDFTCSL0

     C                   EXSR      SrLoadFTCS
     C                   EVAL      PBefFTCS = SDFTCS

     C                   IF        FAJASV <> 'Y'
     C                   EVAL      FAJASV = 'Y'
     C                   EVAL      FAJASD = BJRDNB
     C                   EVAL      FAJAST = WWTIME
     C                   UPDATE    SDFTCSD0

     C                   EXSR      SrLoadFTCS
     C                   EVAL      PAftFTCS = SDFTCS

     C**********         IF        PMode =  'A'                                            MD027355A
     C**********                   AND CSD092 = 'Y'                                        MD027355A
     C                   IF        CSD092 = 'Y'                                            MD027355A
     C                             AND Wupdat = 'Y'                                        MD027355B
      ** If Information only mode do not update History

     C**********         CALL      'SDC009696'                                              MD026854
     C**********         IF        PMode <> 'A'                                    MD027295 MD027355
     C                   IF        PMode = 'A' AND                                          MD027355
     C                             PBefFTCS = PAftFTCS                                      MD027355
     C                   ELSE                                                               MD027355
     C                   CALL      'SD009696'
     C                   PARM      FACUST        PCUST
     C                   PARM      *BLANKS       PBefCUST
     C                   PARM      *BLANKS       PAftCUST
     C                   PARM      *BLANKS       PBefACUS
     C                   PARM      *BLANKS       PAftACUS
     C                   PARM                    PBefFTCS
     C                   PARM                    PAftFTCS
     C                   PARM      *BLANKS       PBefJACC
     C                   PARM      *BLANKS       PAftJACC
     C                   PARM      *BLANKS       PBefCUAH                                   MD026854
     C                   PARM      *BLANKS       PAftCUAH                                   MD026854
     C                   PARM      *BLANKS       PBefCUXC                                   MD026854
     C                   PARM      *BLANKS       PAftCUXC                                   MD026854
     C                   PARM      'N'           PACRV
     C                   PARM      'Y'           PELEC
     C                   PARM      *BLANKS       PBefCRSH                                     CGL177
     C                   PARM      *BLANKS       PAftCRSH                                     CGL177
     C                   PARM      *BLANKS       PBefCRSD                                     CGL177
     C                   PARM      *BLANKS       PAftCRSD                                     CGL177
     C                   ENDIF                                                              MD027295
     C                   ENDIF

     C                   ENDIF
     C                   EVAL      JIdx = JIdx - 1
     C                   ENDDO

     C                   LEAVESR
     C                   ELSE
     C     WKey          READE     SDJACCL2
     C                   ENDIF

     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                     MD026705
      *                                                               *                     MD026705
      * SRAuthNAHO - Authority Holder check for NAHO                  *                     MD026705
      *                                                               *                     MD026705
      * Called by:                                                    *                     MD026705
      *                                                               *                     MD026705
      * Calls: None                                                   *                     MD026705
      *                                                               *                     MD026705
      *****************************************************************                     MD026705
                                                                                            MD026705
     C     SRAuthNAHO    BEGSR                                                              MD026705
                                                                                            MD026705
     C                   EVAL      WNAHORoll = 'N'                                          MD026705
                                                                                            MD026705
     C     WKeyNAHO      CHAIN     SDFTNHL0                                                 MD026705
     C                   EVAL      WHasIndicia = 'N'                                        MD026705
     C                   EXSR      SrChkNAHoInd                                             MD026705
                                                                                            MD026705
     C                   IF        WHasIndicia = 'Y'                                        MD026705
                                                                                            MD026705
      ** If any indicia has been found, Tag all Joint Accounts                              MD026705
      ** assosciated to have the Joint Account Indicia                                      MD026705
     C                   DOW       AIdx >= 1                                                MD026705
     C                   EVAL      WKey  = WAuthHolChk(AIdx).AuthHold                       MD026705
     C     WKey          CHAIN     SDFTCSL0                                                 MD026705
                                                                                            MD026705
     C                   EXSR      SrLoadFTCS                                               MD026705
     C                   EVAL      PBefFTCS = SDFTCS                                        MD026705
                                                                                            MD026705
     C                   IF        FAAUSV <> 'Y'                                            MD026705
     C                   EVAL      FAAUSV = 'Y'                                             MD026705
     C                   EVAL      FAAUSD = BJRDNB                                          MD026705
     C                   EVAL      FAAUST = WWTIME                                          MD026705
     C                   UPDATE    SDFTCSD0                                                 MD026705
                                                                                            MD026705
     C                   EXSR      SRHCISProc                                               MD026705
                                                                                            MD026705
     C                   ENDIF                                                              MD026705
                                                                                            MD026705
     C                   EVAL      AIdx = AIdx - 1                                          MD026705
     C                   ENDDO                                                              MD026705
                                                                                            MD026705
     C                   EVAL      WNAHORoll = 'Y'                                          MD026705
     C                   LEAVESR                                                            MD026705
     C                   ENDIF                                                              MD026705
                                                                                            MD026705
     C                   ENDSR                                                              MD026705
      *****************************************************************                     MD026705
      /EJECT                                                                                MD026705
      *****************************************************************
      *                                                               *
      * SrLoadFTCS   - Load FTCS Records for History Processing       *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrLoadFTCS    BEGSR

     C                   EVAL      HCCUST = FACUST
     C                   EVAL      HCCLAC = FACLAC
     C                   EVAL      HCCLAD = FACLAD
     C                   EVAL      HCPCLA = FAPCLA
     C                   EVAL      HCHMSV = FAHMSV
     C                   EVAL      HCHMSD = FAHMSD
     C                   EVAL      HCHMST = FAHMST
     C                   EVAL      HCHMOV = FAHMOV
     C                   EVAL      HCHMON = FAHMON
     C                   EVAL      HCHMOD = FAHMOD
     C                   EVAL      HCHMOT = FAHMOT
     C                   EVAL      HCHMD1 = FAHMD1
     C                   EVAL      HCHMS1 = FAHMS1
     C                   EVAL      HCHMD2 = FAHMD2
     C                   EVAL      HCHMS2 = FAHMS2
     C                   EVAL      HCHMD3 = FAHMD3
     C                   EVAL      HCHMS3 = FAHMS3
     C                   EVAL      HCHMD4 = FAHMD4
     C                   EVAL      HCHMS4 = FAHMS4
     C                   EVAL      HCHMD5 = FAHMD5
     C                   EVAL      HCHMS5 = FAHMS5
     C                   EVAL      HCHMCO = FAHMCO
     C                   EVAL      HCMCSV = FAMCSV
     C                   EVAL      HCMCSD = FAMCSD
     C                   EVAL      HCMCST = FAMCST
     C                   EVAL      HCMCOV = FAMCOV
     C                   EVAL      HCMCON = FAMCON
     C                   EVAL      HCMCOD = FAMCOD
     C                   EVAL      HCMCOT = FAMCOT
     C                   EVAL      HCMCD1 = FAMCD1
     C                   EVAL      HCMCS1 = FAMCS1
     C                   EVAL      HCMCD2 = FAMCD2
     C                   EVAL      HCMCS2 = FAMCS2
     C                   EVAL      HCMCD3 = FAMCD3
     C                   EVAL      HCMCS3 = FAMCS3
     C                   EVAL      HCMCD4 = FAMCD4
     C                   EVAL      HCMCS4 = FAMCS4
     C                   EVAL      HCMCD5 = FAMCD5
     C                   EVAL      HCMCS5 = FAMCS5
     C                   EVAL      HCMCCO = FAMCCO
     C                   EVAL      HCRPSV = FARPSV
     C                   EVAL      HCRPSD = FARPSD
     C                   EVAL      HCRPST = FARPST
     C                   EVAL      HCRPOV = FARPOV
     C                   EVAL      HCRPON = FARPON
     C                   EVAL      HCRPOD = FARPOD
     C                   EVAL      HCRPOT = FARPOT
     C                   EVAL      HCRPD1 = FARPD1
     C                   EVAL      HCRPS1 = FARPS1
     C                   EVAL      HCRPD2 = FARPD2
     C                   EVAL      HCRPS2 = FARPS2
     C                   EVAL      HCRPD3 = FARPD3
     C                   EVAL      HCRPS3 = FARPS3
     C                   EVAL      HCRPD4 = FARPD4
     C                   EVAL      HCRPS4 = FARPS4
     C                   EVAL      HCRPD5 = FARPD5
     C                   EVAL      HCRPS5 = FARPS5
     C                   EVAL      HCRPCO = FARPCO
     C                   EVAL      HCAUSV = FAAUSV
     C                   EVAL      HCAUSD = FAAUSD
     C                   EVAL      HCAUST = FAAUST
     C                   EVAL      HCAUOV = FAAUOV
     C                   EVAL      HCAUON = FAAUON
     C                   EVAL      HCAUOD = FAAUOD
     C                   EVAL      HCAUOT = FAAUOT
     C                   EVAL      HCAUD1 = FAAUD1
     C                   EVAL      HCAUS1 = FAAUS1
     C                   EVAL      HCAUD2 = FAAUD2
     C                   EVAL      HCAUS2 = FAAUS2
     C                   EVAL      HCAUD3 = FAAUD3
     C                   EVAL      HCAUS3 = FAAUS3
     C                   EVAL      HCAUD4 = FAAUD4
     C                   EVAL      HCAUS4 = FAAUS4
     C                   EVAL      HCAUD5 = FAAUD5
     C                   EVAL      HCAUS5 = FAAUS5
     C                   EVAL      HCAUCO = FAAUCO
     C                   EVAL      HCCISV = FACISV
     C                   EVAL      HCCISD = FACISD
     C                   EVAL      HCCIST = FACIST
     C                   EVAL      HCCIOV = FACIOV
     C                   EVAL      HCCION = FACION
     C                   EVAL      HCCIOD = FACIOD
     C                   EVAL      HCCIOT = FACIOT
     C                   EVAL      HCCID1 = FACID1
     C                   EVAL      HCCIS1 = FACIS1
     C                   EVAL      HCCID2 = FACID2
     C                   EVAL      HCCIS2 = FACIS2
     C                   EVAL      HCCID3 = FACID3
     C                   EVAL      HCCIS3 = FACIS3
     C                   EVAL      HCCID4 = FACID4
     C                   EVAL      HCCIS4 = FACIS4
     C                   EVAL      HCCID5 = FACID5
     C                   EVAL      HCCIS5 = FACIS5
     C                   EVAL      HCCICO = FACICO
     C                   EVAL      HCCBSV = FACBSV
     C                   EVAL      HCCBSD = FACBSD
     C                   EVAL      HCCBST = FACBST
     C                   EVAL      HCCBOV = FACBOV
     C                   EVAL      HCCBON = FACBON
     C                   EVAL      HCCBOD = FACBOD
     C                   EVAL      HCCBOT = FACBOT
     C                   EVAL      HCCBD1 = FACBD1
     C                   EVAL      HCCBS1 = FACBS1
     C                   EVAL      HCCBD2 = FACBD2
     C                   EVAL      HCCBS2 = FACBS2
     C                   EVAL      HCCBD3 = FACBD3
     C                   EVAL      HCCBS3 = FACBS3
     C                   EVAL      HCCBD4 = FACBD4
     C                   EVAL      HCCBS4 = FACBS4
     C                   EVAL      HCCBD5 = FACBD5
     C                   EVAL      HCCBS5 = FACBS5
     C                   EVAL      HCCBCO = FACBCO
     C                   EVAL      HCCDSV = FACDSV
     C                   EVAL      HCCDSD = FACDSD
     C                   EVAL      HCCDST = FACDST
     C                   EVAL      HCCDOV = FACDOV
     C                   EVAL      HCCDON = FACDON
     C                   EVAL      HCCDOD = FACDOD
     C                   EVAL      HCCDOT = FACDOT
     C                   EVAL      HCCDD1 = FACDD1
     C                   EVAL      HCCDS1 = FACDS1
     C                   EVAL      HCCDD2 = FACDD2
     C                   EVAL      HCCDS2 = FACDS2
     C                   EVAL      HCCDD3 = FACDD3
     C                   EVAL      HCCDS3 = FACDS3
     C                   EVAL      HCCDD4 = FACDD4
     C                   EVAL      HCCDS4 = FACDS4
     C                   EVAL      HCCDD5 = FACDD5
     C                   EVAL      HCCDS5 = FACDS5
     C                   EVAL      HCCDCO = FACDCO
     C                   EVAL      HCGCSV = FAGCSV
     C                   EVAL      HCGCSD = FAGCSD
     C                   EVAL      HCGCST = FAGCST
     C                   EVAL      HCGCOV = FAGCOV
     C                   EVAL      HCGCON = FAGCON
     C                   EVAL      HCGCOD = FAGCOD
     C                   EVAL      HCGCOT = FAGCOT
     C                   EVAL      HCGCD1 = FAGCD1
     C                   EVAL      HCGCS1 = FAGCS1
     C                   EVAL      HCGCD2 = FAGCD2
     C                   EVAL      HCGCS2 = FAGCS2
     C                   EVAL      HCGCD3 = FAGCD3
     C                   EVAL      HCGCS3 = FAGCS3
     C                   EVAL      HCGCD4 = FAGCD4
     C                   EVAL      HCGCS4 = FAGCS4
     C                   EVAL      HCGCD5 = FAGCD5
     C                   EVAL      HCGCS5 = FAGCS5
     C                   EVAL      HCGCCO = FAGCCO
     C                   EVAL      HCIDSV = FAIDSV
     C                   EVAL      HCIDSD = FAIDSD
     C                   EVAL      HCIDST = FAIDST
     C                   EVAL      HCIDOV = FAIDOV
     C                   EVAL      HCIDON = FAIDON
     C                   EVAL      HCIDOD = FAIDOD
     C                   EVAL      HCIDOT = FAIDOT
     C                   EVAL      HCIDD1 = FAIDD1
     C                   EVAL      HCIDS1 = FAIDS1
     C                   EVAL      HCIDD2 = FAIDD2
     C                   EVAL      HCIDS2 = FAIDS2
     C                   EVAL      HCIDD3 = FAIDD3
     C                   EVAL      HCIDS3 = FAIDS3
     C                   EVAL      HCIDD4 = FAIDD4
     C                   EVAL      HCIDS4 = FAIDS4
     C                   EVAL      HCIDD5 = FAIDD5
     C                   EVAL      HCIDS5 = FAIDS5
     C                   EVAL      HCIDCO = FAIDCO
     C                   EVAL      HCJASV = FAJASV
     C                   EVAL      HCJASD = FAJASD
     C                   EVAL      HCJAST = FAJAST
     C                   EVAL      HCJAOV = FAJAOV
     C                   EVAL      HCJAON = FAJAON
     C                   EVAL      HCJAOD = FAJAOD
     C                   EVAL      HCJAOT = FAJAOT
     C                   EVAL      HCJAD1 = FAJAD1
     C                   EVAL      HCJAS1 = FAJAS1
     C                   EVAL      HCJAD2 = FAJAD2
     C                   EVAL      HCJAS2 = FAJAS2
     C                   EVAL      HCJAD3 = FAJAD3
     C                   EVAL      HCJAS3 = FAJAS3
     C                   EVAL      HCJAD4 = FAJAD4
     C                   EVAL      HCJAS4 = FAJAS4
     C                   EVAL      HCJAD5 = FAJAD5
     C                   EVAL      HCJAS5 = FAJAS5
     C                   EVAL      HCJACO = FAJACO
     C                   EVAL      HCTESV = FATESV
     C                   EVAL      HCTESD = FATESD
     C                   EVAL      HCTEST = FATEST
     C                   EVAL      HCTEOV = FATEOV
     C                   EVAL      HCTEON = FATEON
     C                   EVAL      HCTEOD = FATEOD
     C                   EVAL      HCTEOT = FATEOT
     C                   EVAL      HCTED1 = FATED1
     C                   EVAL      HCTES1 = FATES1
     C                   EVAL      HCTED2 = FATED2
     C                   EVAL      HCTES2 = FATES2
     C                   EVAL      HCTED3 = FATED3
     C                   EVAL      HCTES3 = FATES3
     C                   EVAL      HCTED4 = FATED4
     C                   EVAL      HCTES4 = FATES4
     C                   EVAL      HCTED5 = FATED5
     C                   EVAL      HCTES5 = FATES5
     C                   EVAL      HCTECO = FATECO
     C                   EVAL      HCTXSV = FATXSV
     C                   EVAL      HCTXSD = FATXSD
     C                   EVAL      HCTXST = FATXST
     C                   EVAL      HCTXOV = FATXOV
     C                   EVAL      HCTXON = FATXON
     C                   EVAL      HCTXOD = FATXOD
     C                   EVAL      HCTXOT = FATXOT
     C                   EVAL      HCTXD1 = FATXD1
     C                   EVAL      HCTXS1 = FATXS1
     C                   EVAL      HCTXD2 = FATXD2
     C                   EVAL      HCTXS2 = FATXS2
     C                   EVAL      HCTXD3 = FATXD3
     C                   EVAL      HCTXS3 = FATXS3
     C                   EVAL      HCTXD4 = FATXD4
     C                   EVAL      HCTXS4 = FATXS4
     C                   EVAL      HCTXD5 = FATXD5
     C                   EVAL      HCTXS5 = FATXS5
     C                   EVAL      HCTXCO = FATXCO
     C                   EVAL      HCEXEM = FAEXEM
     C                   EVAL      HCEXER = FAEXER
     C                   EVAL      HCEXED = FAEXED
     C                   EVAL      HCEXET = FAEXET
     C                   EVAL      HCEXEU = FAEXEU
     C                   EVAL      HCREPT = FAREPT
     C                   EVAL      HCGIIN = FAGIIN
     C                   EVAL      HCGIID = FAGIID
     C                   EVAL      HCGIIO = FAGIIO
     C                   EVAL      HCUTIN = FAUTIN
     C                   EVAL      HCGREC = FAGREC
     C                   EVAL      HCMAIL = FAMAIL
     C                   EVAL      HCPHON = FAPHON
     C                   EVAL      HCCSTY = FACSTY
     C                   EVAL      HCCSST = FACSST
     C                   EVAL      HCRPTT = FARPTT
     C                   EVAL      HCRPTR = FARPTR
     C                   EVAL      HCRPTD = FARPTD
     C                   EVAL      HCRPTM = FARPTM
     C                   EVAL      HCRPTU = FARPTU
     C                   EVAL      HCHVAC = FAHVAC
     C                   EVAL      HCINFC = FAINFC
     C                   EVAL      HCEXMA = FAEXMA
     C                   EVAL      HCEXID = FAEXID
     C                   EVAL      HCLDAT = FALDAT
     C                   EVAL      HCLCTP = FALCTP
     C                   EVAL      HCLUSR = FALUSR
     C                   EVAL      HCREPA = FAREPA
     C                   EVAL      HCFOID = FAFOID
     C                   EVAL      HCREPI = FAREPI
     C                   EVAL      HCTMST = FATMST

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRegPayInst - Regular Payment Instructions Indicia           *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRRegPayInst  BEGSR

      ** Check Customer Number
     C                   EVAL      KOTPAYType = 'C'
     C                   EVAL      KOTPAYKey35 = FACUST
     C     KOTPAYKey     SETLL     OTPAYL9
     C     KOTPAYKey     READE     OTPAYL9

     C                   DOW       NOT %EOF(OTPAYL9)

     C                   EVAL      KCUST35 = ACB1
     C     KCUST35       CHAIN     SDCUSTL0
     C                   IF        %LOOKUP(OPCOLC:CtryCodeArr) <> 0
     C                             AND OPCOLC <> *BLANKS
     C                             AND %FOUND(SDCUSTL0)
     C                   EVAL      FARPSV = 'Y'
     C                   LEAVESR
     C                   ENDIF

     C     KOTPAYKey     READE     OTPAYL9
     C                   ENDDO

      ** Check Customer Shortname
     C                   EVAL      KOTPAYType = 'S'
     C                   EVAL      KOTPAYKey35 = BBCSSN
     C     KOTPAYKey     SETLL     OTPAYL9
     C     KOTPAYKey     READE     OTPAYL9

     C                   DOW       NOT %EOF(OTPAYL9)

     C                   EVAL      KCUST35 = ACB1
     C     KCUST35       CHAIN     SDCUSTL0
     C                   IF        %LOOKUP(OPCOLC:CtryCodeArr) <> 0
     C                             AND OPCOLC <> *BLANKS
     C                             AND %FOUND(SDCUSTL0)
     C                   EVAL      FARPSV = 'Y'
     C                   LEAVESR
     C                   ENDIF

     C     KOTPAYKey     READE     OTPAYL9
     C                   ENDDO

      ** Check Nostros Attached to the customer
     C     FACUST        SETLL     SDNOSTL2
     C     FACUST        READE     SDNOSTL2

     C                   DOW       NOT %EOF(SDNOSTL2)
     C                   EVAL      KOTPAYType = 'A'
     C                   EVAL      KOTPAYKey35 = A7CYCD + A7NONB
     C     KOTPAYKey     SETLL     OTPAYL9
     C     KOTPAYKey     READE     OTPAYL9

     C                   DOW       NOT %EOF(OTPAYL9)

     C                   EVAL      KCUST35 = ACB1
     C     KCUST35       CHAIN     SDCUSTL0
     C                   IF        %LOOKUP(OPCOLC:CtryCodeArr) <> 0
     C                             AND OPCOLC <> *BLANKS
     C                   EVAL      FARPSV = 'Y'
     C                   LEAVESR
     C                   ENDIF

     C     KOTPAYKey     READE     OTPAYL9
     C                   ENDDO

     C     FACUST        READE     SDNOSTL2
     C                   ENDDO

     C                   ENDSR
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *DTAARA       DEFINE                  LDA

     C     *ENTRY        PLIST
      ** Return Code
      ** Transaction ID (Customer Number or NAHO Reference)
      ** Source API (C-Customer, N-Non-Account Holder, J-Joint Accounts)
      ** Classification if Indicia Found (M and J mode only)
      ** Classification if Indicia Not Found (M and J mode only)
      ** Mode (M-Manual, A-Automatic, I-Info Only)
     C                   PARM                    PReturn
     C                   PARM                    PTranID
     C                   PARM                    PSource
     C                   PARM                    PClasIF
     C                   PARM                    PClasNF
     C                   PARM                    PRepType
     C                   PARM                    PMode

     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSSDY

      ** Database error

     C     PRetCode      IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 001
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBKEY = '*FIRST'
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBMOD  =  PSProcMod
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      CSE023 = 'N'

     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*VERIFY'     POption
     C                   PARM      'CSE023'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     PRetCode      IFEQ      *BLANK
     C                   EVAL      CSE023 = 'Y'
     C                   ENDIF

     C                   EVAL      CSE024 = 'N'

     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*VERIFY'     POption
     C                   PARM      'CSE024'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     PRetCode      IFEQ      *BLANK
     C                   EVAL      CSE024 = 'Y'
     C                   ENDIF

     C                   EVAL      CSD092 = 'N'

     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*VERIFY'     POption
     C                   PARM      'CSD092'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     PRetCode      IFEQ      *BLANK
     C                   EVAL      CSD092 = 'Y'
     C                   ENDIF

     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      SYSVAL1       POP01
     C                   PARM      *BLANKS       PVL01
     C                   PARM                    POP02
     C                   PARM                    PVL02
     C                   PARM                    POP02
     C                   PARM                    PVL02
     C                   PARM                    POP02
     C                   PARM                    PVL02
     C                   PARM                    POP02
     C                   PARM                    PVL02
     C                   PARM                    POP02
     C                   PARM                    PVL02
     C                   PARM                    POP02
     C                   PARM                    PVL02
     C                   PARM                    POP02
     C                   PARM                    PVL02
     C                   PARM                    POP02
     C                   PARM                    PVL02
     C                   PARM                    POP02
     C                   PARM                    PVL02

     C     PRTCD         IFNE      *BLANKS
     C                   EVAL      DBKEY = SYSVAL1
     C                   EVAL      DBFILE = 'SDSVALPD'
     C                   EVAL      DBASE = 002
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        PVL01  <> *BLANKS
     C                   MOVEL     PVL01         WNEffDate

     C                   CALL      'ZDATE1'                             90
     C                   PARM                    PRetCode
     C                   PARM                    WNEffDate
     C                   PARM      BJDFIN        PDateFormat
     C                   PARM      *ZERO         WEffDate
     C                   ENDIF

      ** Build FATCA Country Code array
     C     *LOVAL        SETLL     SDCTRYL5
     C                   READ      SDCTRYL5

     C                   DOW       NOT %EOF(SDCTRYL5)
     C                   EVAL      CtryCodeArr(Index) = A4CNCD
     C                   EVAL      Index = Index + 1
     C                   READ      SDCTRYL5
     C                   ENDDO

     C     KCustUS       KLIST
     C                   KFLD                    FACUST
     C                   KFLD                    KUS

     C     KOTPAYKey     KLIST
     C                   KFLD                    KOTPAYType
     C                   KFLD                    KOTPAYKey35

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
      * Called by: (**calling routines**)                                 *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************

     C     *PSSR         BEGSR

     C                   DUMP

     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'

     C                   CALLB     'DBERRCTL'

     C                   ENDIF

     C                   EVAL      PRetCode = '*ERROR'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR

      ********************************************************************
