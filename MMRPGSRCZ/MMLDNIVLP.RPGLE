     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Loans/deposits post settlement validation')   *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMLDNIVLP - MM Loans/Deposits Post Settlement Validation     *
      *                                                               *
      *  Function: This Program Processes Post Settlement Detail      *
      *            LDNI date validation                               *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL165             Date 23Feb15               *
      *                 MD031494           Date 13Feb15               *
      *                 MD030409           Date 25Nov14               *
      *                 MD029724           Date 25Nov14               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 01Sep14               *
      *                 MD026390           Date 24Apr14               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 BUG25287           Date 03Aug09               *
      *                 BUG23732           Date 23Apr09               *
      *                 CER054             Date 07Apr09               *
      *                 BUG23437A          Date 24Mar09               *
      *                 CER048             Date 19May08               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 247452             Date 05Jul07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 BUG5169            Date 04Oct06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 11Jul06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG10343           Date 06Feb06               *
      *                 BUG8024            Date 06Jan06               *
      *                 CDL038             Date 10May05               *
      *                 CDL033             Date 10Feb05               *
      *                 BUG5517            Date 19Jan05               *
      *                 CSD025             Date 11Jan05               *
      *                 BUG3992            Date 12Nov04               *
      *                 BUG4761            Date 09Nov04               *
      *                 BUG3992  *CREATE   Date 01Oct04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL165   - Dual Withholding Tax (Recompile)                  *
      *  MD031494 - Negative Interest - MMDeals negative interest     *
      *             rates become positive when deal is amended.       *
      *           - Amend the program to use the correct sign of the  *
      *             entered rate.                                     *
      *  MD030409 - MM Rollover (RODL) of the deposit should only be  *
      *             allowed at the maturity date of the deposit when  *
      *             Taxable Indicator equal to 'A' and EU Tax status  *
      *             equal to T (Threshold).                           *
      *           - Consider the new Tax indicator value = 'A' in the *
      *             rollover validation when CER069 is ON.            *
      *  MD029724 - Rollover not allowed before maturity for deposits *
      *             with Taxable Indicator not equal to 'T'(Threshold)*
      *           - Include the taxable indicator in the rollover     *
      *             validation                                        *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  MD026390 - Deal date does not take into account local        *
      *             holidays.                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG25287 - Strange error message when trying to              *
      *             Authorise/input Deal                              *
      *  BUG23732 - Joint Account Threshold                           *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  BUG23437A - Correct validation of Initial start date and     *
      *             Final maturity date.                              *
      *  CER048 - German Features - Taxes                             *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus                                          *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  247452 -  Short term not reflected in Actual Interest Rate.  *
      *  BUG5169 - Add validation for rates if CDL020 is installed    *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10343 - DLC0606B 00001 failed, DBerror in LF/DAMBR        *
      *  BUG8024 - Duplicate error message in event dates             *
      *  CDL038 - Extended Deal Sub Type                              *
      *  CDL033 - Floating Rate CDs Issued                            *
      *  BUG5517- Authorisation Error on LDNI.  Retrieve contents of  *
      *           DTAARA/ZMUSER moved out of INZSR                    *
      *  CSD025 - Customer De-Activation                              *
      *  BUG3992- Re-open - Suppress duplicate error messages.        *
      *           Some may already have been sent bu MMLDNIVAL.       *
      *  BUG4761- Set up @SPRD for it to be used is setting up the    *
      *           valid deal (as MMLDNIVAL).                          *
      *  BUG3992- New program based on MMLDNIVAL to perform post      *
      *           settlement detail validation. Revalidate dates.     *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
 
     FSDBRTDL1  IF   E           K DISK    INFSR(*PSSR)
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,MMLDNVP001
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
 
     D/COPY ZACPYSRC,PROCPARMS
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS
 
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
      ** EXTERNAL DS FOR DEALING DETAILS
     D QQACC1        E                     EXTFLD(QQACCD)
 
     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
      ** EXTERNAL DS FOR Trading Data
     D QQACC2        E                     EXTFLD(QQACCD)
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS
 
     D SDPORT        E DS                  EXTNAME(SDPORTPD)
      **  Data structure for Portfolio Management ICD File
 
     D SDPCAC        E DS                  EXTNAME(SDPCACPD)
      **  Data structure for Profit Centre Accounting ICD File
 
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
      ** EXTERNAL DS FOR RETAIL DETAILS
     D QQACC3        E                     EXTFLD(QQACCD)
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** EXTERNAL DS FOR SAR DETAILS
 
     D SDPLCS        E DS                  EXTNAME(SDPLCSPD)
      ** External data structure for portfolio management details
 
     D SDDLST        E DS                  EXTNAME(SDDLSTPD)
      ** EXTERNAL DS FOR DEAL SUBTYPE DETAILS
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** External data structure for customer details
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External data structure for currency details
 
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** External data structure for branch details
     D QQDFC1        E                     EXTFLD(QQDFAC)
 
     D SDBROK        E DS                  EXTNAME(SDBROKPD)
      ** External data structure for broker details
 
     D SDACTX        E DS                  EXTNAME(SDACTXPD)                                MD030409
      ** External data structure for customer details by country of tax                     MD030409
                                                                                            MD030409
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
     D DSLDY         E DS                  EXTNAME(DSLDY)
      * THIRD DS FOR ACCESS PROGRAMS, VERY LONG DATA STRUCTURE
 
     D ValidDeal     E DS                  EXTNAME(MMVLDNIPD)
      * Valid Deals layout
 
     D ZMUSER          DS            17
     D  ZUSER                  1     10
     D  BRC                   11     13
     D  DEPT                  14     16
 
     D TranIn        E DS                  EXTNAME(MMLDNIPD)
      * Incoming Transaction
 
     D InfData       E DS                  EXTNAME(MMLDIFPD)
     D                                     PREFIX(IF_)
      * MM Extra Data - File (D/B) format
 
     D ExtData       E DS                  EXTNAME(MMLDEXPD)
      * MM Extra Data - File (D/B) format
 
      **  Front Office (2 First characters determine System Front Office)
     D FrontOffice     DS            20
     D  W_System               1      2
 
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
      ** 24X7 status dataarea
 
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
      ** SD data area
     D/COPY WNCPYSRC,MMLDNVP002
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Error message fields received as parameters
     D     Msg1        S                   LIKE(#MsgID)
     D     Msg2        S                   LIKE(#MsgID)
     D     Msg3        S                   LIKE(#MsgID)
     D     Msg4        S                   LIKE(#MsgID)
     D     Msg5        S                   LIKE(#MsgID)
     D     Msg6        S                   LIKE(#MsgID)
     D     Msg7        S                   LIKE(#MsgID)
     D     Msg8        S                   LIKE(#MsgID)                                     BUG23732
 
      ** Warning error message fields received as parameters
     D     WMSGID1     S                   LIKE(#MsgID)
     D     WMSGID2     S                   LIKE(#MsgID)
     D     WMSGID3     S                   LIKE(#MsgID)
     D     WMSGID4     S                   LIKE(#MsgID)
     D     WMSGID5     S                   LIKE(#MsgID)
     D     WMSGID6     S                   LIKE(#MsgID)
     D     WMSGID7     S                   LIKE(#MsgID)
     D*****WMsgId8     S                   LIKE(#MsgID)                              CER048 BUG23732
     D WMsgid8         S                   LIKE(#MsgID)                                       CDL096
     D WMsgDta8        S                   LIKE(#MsgData)                                     CDL096
     D PCurrency       S              3A   Dim(10)                                            CDL096
 
      ** Error message substitution data received as a parameter
     D MSGDATA         S                   LIKE(#MsgData)
     D MSGDATA2        S                   LIKE(#MsgData)
     D MSGDATA3        S                   LIKE(#MsgData)
     D MSGDATA4        S                   LIKE(#MsgData)
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
 
      ** Flags to indicate whether transaction fields are valid
      ** These have been declared for all MM0089D3 fields, some may not
      **  actually be needed if the field is not used/not validated
     D OKFlagsDS       DS
     D  DDActnOK                      1A
     D  DDDlnoOK                      1A
     D  DDTypeOK                      1A
     D  DDStypOK                      1A
     D  DDFedFOK                      1A
     D  DDDADNOK                      1A
     D  DDDlDtOK                      1A
     D  DDBrCAOK                      1A
     D  DDBokCOK                      1A
     D  DDLnkNOK                      1A
     D  DDBkCdOK                      1A
     D  DDBrkgOK                      1A
     D  DDRaCDOK                      1A
     D  DDCustOK                      1A
     D  DDVDatOK                      1A
     D  DDMDatOK                      1A
     D  DDNtceOK                      1A
     D  DDAcSqOK                      1A
     D  DDCcyOK                       1A
     D  DDAmnpOK                      1A
     D  DDBRatOK                      1A
     D  DDDRIDOK                      1A
     D  DDDDMROK                      1A
     D  DDBsRCOK                      1A
     D  DDSpRtOK                      1A
     D  DDICMtOK                      1A
     D  DDROLIOK                      1A
     D  DDIPFqOK                      1A
     D  DDNDatOK                      1A
     D  DDTotIOK                      1A
     D  DDIPDMOK                      1A
     D  DDCptIOK                      1A
     D  DDMTaxOK                      1A
     D  DDFUIDOK                      1A
     D  DDFLIdOK                      1A
     D  DDRDFCOK                      1A
     D  DDCDRfOK                      1A
     D  DDCDCHOK                      1A
     D  DDPrfCOK                      1A
     D  DDOrBrOK                      1A
     D  DDPtfROK                      1A
     D  DDAuRoOK                      1A
     D  DDCnNaOK                      1A
     D  DDRoFqOK                      1A
     D  DDRlDNOK                      1A
     D  DDIPdSOK                      1A
     D  DDIMetOK                      1A
     D  DDIScyOK                      1A
     D  DDInSAOK                      1A
     D  DDINosOK                      1A
     D  DDIi72OK                      1A
     D  DDFsrpOK                      1A
     D  DDFsgnOK                      1A
     D  DDFprcOK                      1A
     D  DDPenaOK                      1A
     D  DDTrnTpOK                     1A
     D  DDOylcOK                      1A
     D  DDLQPROK                      1A
     D  DDLQPSOK                      1A
     D  DDClasOK                      1A                                                      CDL038
      ** Flag(s) to indicate if combinations of transaction fields are valid
     D  DDDltStpOK                    1A
     D  DDIsDtOK                      1A                                                      CER020
     D  DDFmDtOK                      1A                                                      CER020
     D  DDOrDnOK                      1A                                                      CER020
 
      ** Flags to indicate whether transaction fields are valid                              BUG5169
     D OKFlagsDS2      DS                                                                    BUG5169
     D  DDSOFDOK                      1A                                                     BUG5169
     D  DDFBRTOK                      1A                                                     BUG5169
     D  DDAIROK                       1A                                                     BUG5169
 
      ** Error flags from Dates validation routine
     D ErrDealDat      S              1A   INZ('N')
     D ErrValDate      S              1A   INZ('N')
     D ErrMatDate      S              1A   INZ('N')
     D ErrNxInDat      S              1A   INZ('N')
 
      ** Error flags from int settle ccy & 'in' ccy validation routine
     D ErrIntSetc      S              1A   INZ('N')
     D ErrIntin72      S              1A   INZ('N')
 
      ** Error flags from funding details validation routine
     D ErrFundRat      S              1A   INZ('N')
     D ErrFundSgn      S              1A   INZ('N')
     D ErrFundPrf      S              1A   INZ('N')
 
      ** Default Round Down indicators for Branch & Currency
     D BrRdfc          S              1A
 
      ** Portfolio reference (default value, received from AOPLCSR1 in
      ** MMVBOOKCDE, passed to MMVPORTREF)
     D PortRef         S              4A
 
      ** Extended Settlement fields used by MMVVALDATE
     D PMERCD          S            150A
 
      ** Receive / Pay Settlement Currency, Method & Nostro
     D RecSetCcy       S              3A
     D RecSetMeth      S              2S 0
     D***RecNostro       S             12A
     D RecNostro       S             18A
     D PaySetCcy       S              3A
     D PaySetMeth      S              2S 0
     D PayNostro       S             18A
 
      ** Flag for whether an error was found in the call to ZDATE1
     D ZDATE1Err       S              1A
 
      ** Numeric version of spread/rate
     D @SPRD           S             11P 7
 
      ** A code to indicate the calling function to the lower level modules
     D LDNI            S              4A   INZ('LDNI')
 
      ** Response Mode, received as a parameter from the common header
     D RespMode        S              1A
 
      ** Previous Maturity Date
     D OLD_IKMATD      S              5P 0 INZ(0)
 
     D CDL006          S              1A   IMPORT
 
      ** Repos indicator
     D Repo            S              1A
 
     D CGL011          S              1A   IMPORT
 
     D CSC011          S              1A   INZ('N')
     D WProcDate       S                   LIKE(BJRDNB)
     D PRTCD           S              7A
     D POPTN           S              7A
     D PSARD           S              6A
 
      ** Define fields used in CAS001
     D CAS001          S              1A
     D PYCFN           S              6A
     D PERTP           S              1A
 
      ** Fields defined for Enhancement CDL010
     D CDL010          S              1A
 
      ** Define fields used in CAS005
 
     D CAS005          S              1A
     D PFwRv           S              1A
     D PFwYC           S              5A
      *                                                                                       CER020
     D CER020          S              1A                                                      CER020
      *                                                                                       CER020
     D PMsg8           S                   LIKE(#MsgID)                                       CER020
     D PMsg9           S                   LIKE(#MsgID)                                       CER020
     D PMsg10          S                   LIKE(#MsgID)                                       CER020
     D PWMsgID8        S                   LIKE(#MsgID)                                       CER020
     D PWMsgID9        S                   LIKE(#MsgID)                                       CER020
      *                                                                                       CER020
     D PErrFMtDat      S              1    INZ('N')                                           CER020
     D PErrInsDat      S              1    INZ('N')                                           CER020
     D PDefISFlg       S              1A   INZ('N')                                           CER020
     D PDefFMFlg       S              1A   INZ('N')                                           CER020
      *                                                                                       CER020
     D PDefISVal       S              6P 0                                                    CER020
     D PDefFMVal       S              6P 0                                                    CER020
 
     D CGL058          S              1A                                                    MD026390
     D CER069          S              1A                                                    MD030409
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,MMLDNVP003
 
      *****************************************************************
      /EJECT
      *****************************************************************
      **  Rename fields to differentiate DEALSDC from SDBRTDL1 fields.
     ISDBRTDD0
     I              LCD                         BRTLCD
     I              LCT                         BRTLCT
     I              CHTP                        BRCHTP
     I*
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      /COPY WNCPYSRC,MMLDNVP004
      *                                                                                      BUG5517
      **  Get default branch and user from ZMUSER                                            BUG5517
     C     *DTAARA       DEFINE                  ZMUSER                                      BUG5517
     C                   IN        ZMUSER                                                    BUG5517
     C                   UNLOCK    ZMUSER                                                    BUG5517
 
      ** Validate Branch Code                                                               MD026390
      *                                                                                     MD026390
     C                   IF        CGL058 <> 'Y'                                            MD026390
     C                   EXSR      RESETERRS                                                MD026390
                                                                                            MD026390
     C                   CALLB     'MMVBKGBRCH'                                             MD026390
     C                   PARM                    ReturnCode                                 MD026390
     C                   PARM                    MSG1                                       MD026390
     C                   PARM                    BJSBRC                                     MD026390
     C                   PARM                    BRC                                        MD026390
     C                   PARM                    BRRDFC                                     MD026390
     C                   PARM                    DDACTN                                     MD026390
     C                   PARM                    DDBRCA                                     MD026390
     C                   PARM                    RespMode                                   MD026390
     C                   PARM                    IKDBRC                                     MD026390
     C                   PARM                    SDBRCH                                     MD026390
                                                                                            MD026390
     C     MSG1          IFNE      *BLANK                                                   MD026390
     C                   ADD       1             Idx                                        MD026390
     C                   EVAL      FldNameArr(Idx) = 'DDBRCA'                               MD026390
     C                   EVAL      MsgIDArr(Idx) = MSG1                                     MD026390
     C                   ENDIF                                                              MD026390
      *                                                                                     MD026390
      ** Use the return code's value to set the field's OK flag                             MD026390
      *                                                                                     MD026390
     C                   CALLB     'ZASETOKFLG'                                             MD026390
     C                   PARM                    DDBrcaOK                                   MD026390
     C                   PARM                    ReturnCode                                 MD026390
     C                   PARM                    WarnGlobal                                 MD026390
     C                   ENDIF                                                              MD026390
                                                                                            MD026390
      *  *------------------------*
      *  * Validate All Dates     *  #03
      *  *------------------------*
 
     C                   EXSR      GetTaxInd                                                MD030409
                                                                                            MD030409
     C                   Z-ADD     IKMATD        OLD_IKMATD
     C                   EXSR      RESETERRS
     C                   CALLB     'MMVLDNIDAT'
     C                   PARM                    ReturnCode
      ***Message IDs 1 - 7 (Returned to caller)                                             BUG25287
     C**********         PARM                    Msg1                                       BUG25287
     C**********         PARM                    Msg2                                       BUG25287
     C**********         PARM                    Msg3                                       BUG25287
     C**********         PARM                    Msg4                                       BUG25287
     C**********         PARM                    Msg5                                       BUG25287
     C**********         PARM                    Msg6                                       BUG25287
     C**********         PARM                    Msg7                                       BUG25287
     C**********         PARM                    Msg8                              BUG23732 BUG25287
      ***Warning message IDs 1 - 7 (Returned to caller)                                     BUG25287
     C**********         PARM                    WMsgid1                                    BUG25287
     C**********         PARM                    WMsgid2                                    BUG25287
     C**********         PARM                    WMsgid3                                    BUG25287
     C**********         PARM                    WMsgid4                                    BUG25287
     C**********         PARM                    WMsgid5                                    BUG25287
     C**********         PARM                    WMsgid6                                    BUG25287
     C**********         PARM                    WMsgid7                                    BUG25287
     C**********         PARM                    WMsgid8                             CER048 BUG23732
      ** Message IDs 1 - 7 (Returned to caller)                                             BUG25287
     C                   PARM      *BLANKS       Msg1                                       BUG25287
     C                   PARM      *BLANKS       Msg2                                       BUG25287
     C                   PARM      *BLANKS       Msg3                                       BUG25287
     C                   PARM      *BLANKS       Msg4                                       BUG25287
     C                   PARM      *BLANKS       Msg5                                       BUG25287
     C                   PARM      *BLANKS       Msg6                                       BUG25287
     C                   PARM      *BLANKS       Msg7                                       BUG25287
     C                   PARM      *BLANKS       Msg8                                       BUG25287
      ** Warning message IDs 1 - 7 (Returned to caller)                                     BUG25287
     C                   PARM      *BLANKS       WMsgid1                                    BUG25287
     C                   PARM      *BLANKS       WMsgid2                                    BUG25287
     C                   PARM      *BLANKS       WMsgid3                                    BUG25287
     C                   PARM      *BLANKS       WMsgid4                                    BUG25287
     C                   PARM      *BLANKS       WMsgid5                                    BUG25287
     C                   PARM      *BLANKS       WMsgid6                                    BUG25287
     C                   PARM      *BLANKS       WMsgid7                                    BUG25287
     C                   PARM      *BLANKS       WMsgid8                                      CDL096
     C                   PARM      *BLANKS       WMsgDta8                                     CDL096
      ** Error in deal date flag (1A, returned to caller; contains 'Y'
      ** if errors, 'W' if warnings ONLY)
     C                   PARM                    ErrDealDat
      ** Error in value date flag (1A, returned to caller; contains 'Y'
      ** if errors, 'W' if warnings ONLY)
     C                   PARM                    ErrValDate
      ** Error in Maturity date flag (1A, returned to caller; contains 'Y'
      ** if errors, 'W' if warnings ONLY)
     C                   PARM                    ErrMatDate
      ** Error in Next interest date flag (1A, returned to caller; contains
      ** 'Y' if errors, 'W' if warnings ONLY)
     C                   PARM                    ErrNxInDat
      ** Standard deals file version of deal date (5,0P, returned from
      ** this module)
     C                   PARM                    IKDDND
      ** Standard deals file version of value date (5,0P, returned from
      ** this module)
     C                   PARM                    IKDVSD
      ** Standard deals file version of start/last interest date
      ** (5,0P, returned from this module)
     C                   PARM                    IKSLID
      ** Standard deals file version of maturity date (5,0P, returned by
      ** this module)
     C                   PARM                    IKMATD
      ** Standard Deals File version of next interest payment date
      ** (5,0P, returned from this module)
     C                   PARM                    IKNIPD
      ** Deal date (6A, from transaction)
     C                   PARM                    DDDLDT
      ** Value date (6A, from transaction)
     C                   PARM                    DDVDAT
      ** Maturity date (6A, from transaction)
     C                   PARM                    DDMDAT
      ** Next interest date (6A, from transaction)
     C                   PARM                    DDNDAT
      *                                                                                       CER048
     C                   PARM                    DDDADN                                       CER048
      ** Processing Date (either from SDBANKPD or SC24X7)
     C                   PARM                    WProcDate
      ** Date format indicator (1A, from SDBANKPD via caller)
     C                   PARM                    BJDFIN
      ** Local Currency code (3A, from SDBANKPD via caller)
     C                   PARM                    BJLCCY
      ** Branch Location Code (3A, from SDBRCHPD)
     C                   PARM                    A8LCCD
      ** Deal currency (3A, from transaction)
     C                   PARM                    DDCCY
      ** Deal type (2A, from transaction)
     C                   PARM                    DDTYPE
      ** Error codes (150A)
     C                   PARM                    PMERCD
      ** Pay - settlement currency (3A, from caller)
     C                   PARM                    PaySetCcy
      ** Pay - our nostro (12A, from caller)
     C                   PARM                    PayNostro
      ** Pay - settlement method (2,0S, from caller)
     C                   PARM                    PaySetMeth
      ** Receive - settlement currency (3A, from caller)
     C                   PARM                    RecSetCcy
      ** Receive - our nostro (12A, from caller)
     C                   PARM                    RecNostro
      ** Receive - settlement method (2,0S, from caller)
     C                   PARM                    RecSetMeth
      ** Interest payment frequency (1A, from transaction)
     C                   PARM                    DDIPFQ
      ** Japanese sub-module on (1A, from caller)
     C                   PARM                    S01391
      ** Global warning flag (1A, from caller)
     C                   PARM                    WarnGlobal
      ** Type of this transaction function (4A)
     C                   PARM                    LDNI
      ** Action Code (1A, from caller)
     C                   PARM                    DDACTN
      ** Flag indicaating if Input Program is MMREPOSIN
     C                   PARM                    RepoFlag
      ** Floating Rate CDs Issued                                                             CDL033
     C                   PARM                    CDL033                                       CDL033
      ** Business Day Convention Currencies                                                   CDL096
     C                   PARM                    PCurrency                                    CDL096
      ** Taxable Indicator                                                                  MD029724
     C                   PARM                    TaxInd            1                        MD030409
 
      /COPY WNCPYSRC,MMLDNVP005
 
     C     MSG1          IFNE      *BLANK
     C     MSG1          LOOKUP    MsgIDArr                               99                 BUG8024
     C     *IN99         IFEQ      '0'                                                       BUG8024
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDDLDT'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF                                                               BUG8024
     C                   ENDIF
     C     MSG2          IFNE      *BLANK
     C     MSG2          LOOKUP    MsgIDArr                               99                 BUG8024
     C     *IN99         IFEQ      '0'                                                       BUG8024
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDDLDT'
     C                   EVAL      MsgIDArr(Idx) = MSG2
     C                   ENDIF                                                               BUG8024
     C                   ENDIF
     C     MSG3          IFNE      *BLANK
     C     MSG3          LOOKUP    MsgIDArr                               99                 BUG8024
     C     *IN99         IFEQ      '0'                                                       BUG8024
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDVDAT'
     C                   EVAL      MsgIDArr(Idx) = MSG3
     C                   ENDIF                                                               BUG8024
     C                   ENDIF
     C     MSG4          IFNE      *BLANK
     C     MSG4          LOOKUP    MsgIDArr                               99                 BUG8024
     C     *IN99         IFEQ      '0'                                                       BUG8024
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDMDAT'
     C                   EVAL      MsgIDArr(Idx) = MSG4
     C                   ENDIF                                                               BUG8024
     C                   ENDIF
     C     MSG5          IFNE      *BLANK
     C     MSG5          LOOKUP    MsgIDArr                               99                 BUG8024
     C     *IN99         IFEQ      '0'                                                       BUG8024
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDMDAT'
     C                   EVAL      MsgIDArr(Idx) = MSG5
     C                   ENDIF                                                               BUG8024
     C                   ENDIF
     C     MSG6          IFNE      *BLANK
     C     MSG6          LOOKUP    MsgIDArr                               99                 BUG8024
     C     *IN99         IFEQ      '0'                                                       BUG8024
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNDAT'
     C                   EVAL      MsgIDArr(Idx) = MSG6
     C                   ENDIF                                                               BUG8024
     C                   ENDIF
     C     MSG7          IFNE      *BLANK
     C     MSG7          LOOKUP    MsgIDArr                               99                 BUG8024
     C     *IN99         IFEQ      '0'                                                       BUG8024
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNDAT'
     C                   EVAL      MsgIDArr(Idx) = MSG7
     C                   ENDIF                                                               BUG8024
     C                   ENDIF
      *                                                                                     BUG23732
     C     MSG8          IFNE      *BLANKS                                                  BUG23732
     C     MSG8          LOOKUP    MsgIDArr                               99                BUG23732
     C     *IN99         IFEQ      '0'                                                      BUG23732
     C                   ADD       1             Idx                                        BUG23732
     C                   EVAL      FldNameArr(Idx) = 'DDVDAT'                               BUG23732
     C                   EVAL      MsgIDArr(Idx) = MSG8                                     BUG23732
     C                   ENDIF                                                              BUG23732
     C                   ENDIF                                                              BUG23732
 
     C     WMSGID1       IFNE      *BLANK
     C     WMSGID1       LOOKUP    WMsgIDArr                              99                 BUG3992
     C     *IN99         IFEQ      '0'                                                       BUG3992
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDDDAT'
     C                   EVAL      WMsgIDArr(WIdx) = WMSGID1
     C                   ENDIF                                                               BUG3992
     C                   ENDIF
     C     WMSGID2       IFNE      *BLANK
     C     WMSGID2       LOOKUP    WMsgIDArr                              99                 BUG3992
     C     *IN99         IFEQ      '0'                                                       BUG3992
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDVDAT'
     C                   EVAL      WMsgIDArr(WIdx) = WMSGID2
     C                   ENDIF                                                               BUG3992
     C                   ENDIF
     C     WMSGID3       IFNE      *BLANK
     C     WMSGID3       LOOKUP    WMsgIDArr                              99                 BUG3992
     C     *IN99         IFEQ      '0'                                                       BUG3992
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDVDAT'
     C                   EVAL      WMsgIDArr(WIdx) = WMSGID3
     C                   ENDIF                                                               BUG3992
     C                   ENDIF
     C     WMSGID4       IFNE      *BLANK
     C     WMSGID4       LOOKUP    WMsgIDArr                              99                 BUG3992
     C     *IN99         IFEQ      '0'                                                       BUG3992
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDMDAT'
     C                   EVAL      WMsgIDArr(WIdx) = WMSGID4
     C                   ENDIF                                                               BUG3992
     C                   ENDIF
     C     WMSGID5       IFNE      *BLANK
     C     WMSGID5       LOOKUP    WMsgIDArr                              99                 BUG3992
     C     *IN99         IFEQ      '0'                                                       BUG3992
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDMDAT'
     C                   EVAL      WMsgIDArr(WIdx) = WMSGID5
     C                   ENDIF                                                               BUG3992
     C                   ENDIF
     C     WMSGID6       IFNE      *BLANK
     C     WMSGID6       LOOKUP    WMsgIDArr                              99                 BUG3992
     C     *IN99         IFEQ      '0'                                                       BUG3992
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDNDAT'
     C                   EVAL      WMsgIDArr(WIdx) = WMSGID6
     C                   ENDIF                                                               BUG3992
     C                   ENDIF
     C     WMSGID7       IFNE      *BLANK
     C     WMSGID7       LOOKUP    WMsgIDArr                              99                 BUG3992
     C     *IN99         IFEQ      '0'                                                       BUG3992
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDNDAT'
     C                   EVAL      WMsgIDArr(WIdx) = WMSGID7
     C                   ENDIF                                                               BUG3992
     C                   ENDIF
 
     C*****WMsgId8       IFNE      *BLANK                                            CER048 BUG23732
     C*****WMsgId8       LOOKUP    WMsgIDArr                              99         CER048 BUG23732
     C******IN99         IFEQ      '0'                                               CER048 BUG23732
     C**********         ADD       1             WIdx                                CER048 BUG23732
     C**********         EVAL      WFldNamArr(WIdx) = 'DDVDAT'                       CER048 BUG23732
     C**********         EVAL      WMsgIDArr(WIdx) = WMsgId8                         CER048 BUG23732
     C**********         ENDIF                                                       CER048 BUG23732
     C**********         ENDIF                                                       CER048 BUG23732
      *                                                                                       CER048
      ** Convert the 'field in error' flags to set the 'field OK' flags
      ** N.B. This is non-standard processing and takes the place of the
      **  call(s) to ZASETOKFLG.
     C                   CALLB     'ZACVTFLG'
     C                   PARM                    DDDlDtOK
     C                   PARM                    ErrDealDat
 
     C                   CALLB     'ZACVTFLG'
     C                   PARM                    DDVDatOK
     C                   PARM                    ErrValDate
 
     C                   CALLB     'ZACVTFLG'
     C                   PARM                    DDMDatOK
     C                   PARM                    ErrMatDate
 
     C                   CALLB     'ZACVTFLG'
     C                   PARM                    DDNDatOK
     C                   PARM                    ErrNxInDat
 
     C                   IF        WMSGID1 <> *BLANK OR WMSGID2 <> *BLANK
     C                             OR WMSGID3 <> *BLANK OR WMSGID4 <> *BLANK
     C                             OR WMSGID5 <> *BLANK
     C                   EVAL      WarnGlobal = 'Y'
     C                   ENDIF
 
     C     DDMDAT        IfNe      *BLANKS
     C                   Move      'Y'           W_Maturity        1
     C                   Else
     C                   Move      'N'           W_Maturity
     C                   Endif
 
      *  *-------------------------*                                                         BUG4761
      *  * Validate Base Rate Code *  #18                                                    BUG4761
      *  *-------------------------*                                                         BUG4761
     C                   EXSR      RESETERRS                                                 BUG4761
     C/COPY WNCPYSRC,MMLDNVP013                                                              BUG4761
                                                                                             BUG4761
     C                   CALLB     'ZAVBRATCDE'                                              BUG4761
     C                   PARM                    ReturnCode                                  BUG4761
     C                   PARM                    MSG1                                        BUG4761
      ** Warning message ID (10A)                                                            BUG4761
     C                   PARM                    WMsgID1                                     BUG4761
      ** Base rate (11,7P, returned by this module)                                          BUG4761
     C                   PARM                    BaseRate         11 7                       BUG4761
      ** DRS Base rate code (5A, returned by this module, and may be                         BUG4761
      ** obsolete long since)                                                                BUG4761
     C                   PARM                    IKDBSR                                      BUG4761
      ** Base rate code (2A, from transaction)                                               BUG4761
     C                   PARM                    DDBSRC                                      BUG4761
      ** Currency OK flag (1A)                                                               BUG4761
     C                   PARM                    DDCcyOK                                     BUG4761
      ** Deal value date in Midas day number format (5,0P)                                   BUG4761
     C                   PARM                    IKDVSD                                      BUG4761
      ** Value date OK flag (1A)                                                             BUG4761
     C                   PARM                    DDVDatOK                                    BUG4761
      ** Base rate code facility indicator (1A, from SDTRADPD)                               BUG4761
     C                   PARM                    BLBRCF                                      BUG4761
      ** Deal currency (3A, from transaction)                                                BUG4761
     C                   PARM                    DDCCY                                       BUG4761
                                                                                             BUG4761
      /COPY WNCPYSRC,MMLDNVP014                                                              BUG4761
                                                                                             BUG4761
     C     MSG1          IFNE      *BLANK                                                    BUG4761
     C                   ADD       1             Idx                                         BUG4761
     C                   EVAL      FldNameArr(Idx) = 'DDBSRC'                                BUG4761
     C                   EVAL      MsgIDArr(Idx) = MSG1                                      BUG4761
     C                   ENDIF                                                               BUG4761
     C     WMSGID1       IFNE      *BLANK                                                    BUG4761
     C     WMSGID1       LOOKUP    WMsgIDArr                              99                 BUG3992
     C     *IN99         IFEQ      '0'                                                       BUG3992
     C                   ADD       1             WIdx                                        BUG4761
     C                   EVAL      WFldNamArr(WIdx) = 'DDBSRC'                               BUG4761
     C                   EVAL      WMsgIDArr(WIdx) = WMSGID1                                 BUG4761
     C                   ENDIF                                                               BUG3992
     C                   ENDIF                                                               BUG4761
                                                                                             BUG4761
     C/COPY WNCPYSRC,MMLDNVP015                                                              BUG4761
      ** Use the return code's value to set the field's OK flag                              BUG4761
     C                   CALLB     'ZASETOKFLG'                                              BUG4761
     C                   PARM                    DDBsRCOK                                    BUG4761
     C                   PARM                    ReturnCode                                  BUG4761
     C                   PARM                    WarnGlobal                                  BUG4761
                                                                                             BUG4761
      /COPY WNCPYSRC,MMLDNVP016                                                              BUG4761
                                                                                             BUG4761
      *  *-------------------------------*                                                   BUG4761
      *  * Validate Interest Rate/Spread *  #19                                              BUG4761
      *  *-------------------------------*                                                   BUG4761
     C                   EXSR      RESETERRS                                                 BUG4761
     C/COPY WNCPYSRC,MMLDNVP017                                                              BUG4761
                                                                                             BUG4761
     C                   CALLB     'ZAVSPRRATE'                                              BUG4761
     C                   PARM                    ReturnCode                                  BUG4761
     C                   PARM                    MSG1                                        BUG4761
      ** Warning message ID (10A)                                                            BUG4761
     C                   PARM                    WMsgID1                                     BUG4761
      ** Standard deals file version of rate/spread (11,7P, from/to caller)                  BUG4761
     C                   PARM                    IKINTR                                      BUG4761
      ** Standard deals file version of spread/rate (11,7P, from/to caller)                  BUG4761
     C                   PARM                    @SPRD                                       BUG4761
      ** Spread/rate (12A, from transaction)                                                 BUG4761
     C                   PARM                    DDSPRT                                      BUG4761
      ** Deal type (2A, from transaction)                                                    BUG4761
     C                   PARM                    DDTYPE                                      BUG4761
      ** Base rate code (2A, from transaction)                                               BUG4761
     C                   PARM                    DDBSRC                                      BUG4761
      ** Base rate OK flag (1A)                                                              BUG4761
     C                   PARM                    DDBsRCOK                                    BUG4761
      ** Deal date in Midas day number format (5,0P,            )                            BUG4761
     C                   PARM                    IKDDND                                      BUG4761
      ** Value date in Midas day number format (5,0P,            )                           BUG4761
     C                   PARM                    IKDVSD                                      BUG4761
      ** Maturity date in Midas day number format (5,0P,            )                        BUG4761
     C                   PARM                    IKMATD                                      BUG4761
      ** Base rate (11,7P,)                                                                  BUG4761
     C                   PARM                    BaseRate                                    BUG4761
      ** Loan/deposits interest rate tolerance (3,1P, from SDDEALPD)                         BUG4761
     C                   PARM                    BNLDIT                                      BUG4761
      ** Deal currency (3A, from transaction)                                                BUG4761
     C                   PARM                    DDCCY                                       BUG4761
      ** Decimal separator (1A, from SDDEALPD)                                               BUG4761
     C                   PARM                    BNDCSP                                      BUG4761
                                                                                             BUG4761
      /COPY WNCPYSRC,MMLDNVP018                                                              BUG4761
                                                                                             BUG4761
     C     MSG1          IFNE      *BLANK                                                    BUG4761
     C     MSG1          LOOKUP    MsgIDArr                               99                 BUG8024
     C     *IN99         IFEQ      '0'                                                       BUG8024
     C                   ADD       1             Idx                                         BUG4761
     C                   EVAL      FldNameArr(Idx) = 'DDSPRT'                                BUG4761
     C                   EVAL      MsgIDArr(Idx) = MSG1                                      BUG4761
     C                   ENDIF                                                               BUG4761
     C     WMSGID1       IFNE      *BLANK                                                    BUG4761
     C     WMSGID1       LOOKUP    WMsgIDArr                              99                 BUG3992
     C     *IN99         IFEQ      '0'                                                       BUG3992
     C                   ADD       1             WIdx                                        BUG4761
     C                   EVAL      WFldNamArr(WIdx) = 'DDSPRT'                               BUG4761
     C                   EVAL      WMsgIDArr(WIdx) = WMSGID1                                 BUG4761
     C                   ENDIF                                                               BUG8024
     C                   ENDIF                                                               BUG3992
     C                   ENDIF                                                               BUG4761
                                                                                             BUG4761
      ** Use the return code's value to set the field's OK flag                              BUG4761
     C                   CALLB     'ZASETOKFLG'                                              BUG4761
     C                   PARM                    DDSpRtOK                                    BUG4761
     C                   PARM                    ReturnCode                                  BUG4761
     C                   PARM                    WarnGlobal                                  BUG4761
                                                                                             BUG4761
      *  *-------------------------------*                                                   BUG5169
      *  * Validate Actual Interest Rate *                                                   BUG5169
      *  *-------------------------------*                                                   BUG5169
                                                                                             BUG5169
     C     CDL020        IFEQ      'Y'                                                       BUG5169
                                                                                             BUG5169
     C                   EXSR      RESETERRS                                                 BUG5169
                                                                                             BUG5169
     C                   CALLB     'MMVACTINTR'                                              BUG5169
     C                   PARM                    ReturnCode                                  BUG5169
     C                   PARM                    MSG1                                        BUG5169
     C                   PARM                    DDAIR                                       BUG5169
     C                   PARM                    BGN0ST                                      BUG5169
     C                   PARM                    BNDCSP                                      BUG5169
     C                   PARM                    DDCCY                                       BUG5169
     C                   PARM                    DDBSRC                                      BUG5169
     C                   PARM                    IKDVSD                                      BUG5169
     C                   PARM                    BJRDNB                                      BUG5169
     C                   PARM                    IKSPRD                                      BUG5169
     C                   PARM                    IKINTR                                      BUG5169
                                                                                             BUG5169
     C                   IF        MSG1 <> *Blanks                                           BUG5169
     C                   EVAL      Idx = Idx + 1                                             BUG5169
     C                   EVAL      FldNameArr(Idx) = 'DDAIR'                                 BUG5169
     C                   EVAL      MsgIDArr(Idx) = MSG1                                      BUG5169
     C                   ENDIF                                                               BUG5169
                                                                                             BUG5169
      ** Use the return code's value to set the field's OK flag                              BUG5169
     C                   CALLB     'ZASETOKFLG'                                              BUG5169
     C                   PARM                    DDAIROK                                     BUG5169
     C                   PARM                    ReturnCode                                  BUG5169
     C                   PARM                    WarnGlobal                                  BUG5169
                                                                                             BUG5169
     C                   ENDIF                                                               BUG5169
                                                                                             BUG5169
     C                   IF        CDL033 = 'Y' and IKSTRT > 0                                247452
     C                   EVAL      IKINTR = IKSTRT                                            247452
     C                   ENDIF                                                                247452
      /COPY WNCPYSRC,MMLDNVP006
 
      *  *-------------------------------------------------------*
      *  * If no errors set up outstanding fields for valid file *
      *  *-------------------------------------------------------*
 
      /COPY WNCPYSRC,MMLDNVP007
 
      *                                                                                       CER020
      ** Validate the Original Deal Number, Initial and Final                                 CER020
      ** Maturity Date if feature is installed                                                CER020
      *                                                                                       CER020
     C                   IF        CER020 = 'Y'                                               CER020
      *                                                                                       CER020
     C                   EXSR      RESETERRS                                                  CER020
      *                                                                                       CER020
     C                   CALLB     'MMVORGDLNO'                                               CER020
     C                   PARM                    ReturnCode                                   CER020
     C                   PARM                    PMsg10                                       CER020
     C                   PARM                    DDVDAT                                       CER020
     C                   PARM                    DDMDAT                                       CER020
     C                   PARM                    DDDADN                                       CER020
     C                   PARM                    DDISDT                                       CER020
     C                   PARM                    DDFMDT                                       CER020
     C                   PARM                    DDORDN                                       CER020
     C                   PARM                    BJDFIN                                       CER020
     C**********         PARM                    PDefISFlg                          CER020 BUG23437A
     C**********         PARM                    PDefISVal                          CER020 BUG23437A
     C**********         PARM                    PDefFMFlg                          CER020 BUG23437A
     C**********         PARM                    PDefFMVal                          CER020 BUG23437A
     C                   PARM      'N'           PDefISFlg                                 BUG23437A
     C                   PARM      *Zeros        PDefISVal                                 BUG23437A
     C                   PARM      'N'           PDefFMFlg                                 BUG23437A
     C                   PARM      *Zeros        PDefFMVal                                 BUG23437A
      *                                                                                       CER020
     C                   IF        PMsg10 <> *BLANKS                                          CER020
     C     PMsg10        LOOKUP    MsgIDArr                               99                  CER020
     C                   IF        *IN99 = '0'                                                CER020
      *                                                                                       CER020
     C                   ADD       1             Idx                                          CER020
     C                   EVAL      FldNameArr(Idx) = 'DDORDN'                                 CER020
     C                   EVAL      MsgIDArr(Idx) = PMsg10                                     CER020
      *                                                                                       CER020
     C                   ENDIF                                                                CER020
      *                                                                                       CER020
     C                   ENDIF                                                                CER020
      *                                                                                       CER020
      ** Use the return code's value to set the field's OK flag                               CER020
      *                                                                                       CER020
     C                   CALLB     'ZASETOKFLG'                                               CER020
     C                   PARM                    DDOrDnOK                                     CER020
     C                   PARM                    ReturnCode                                   CER020
     C                   PARM                    WarnGlobal                                   CER020
      *                                                                                       CER020
      ** Validate Initial Start Date                                                          CER020
      *                                                                                       CER020
     C                   EXSR      RESETERRS                                                  CER020
     C                   CALLB     'MMVINSTDAT'                                               CER020
     C                   PARM      *BLANKS       ReturnCode                                   CER020
     C                   PARM                    PMsg8                                        CER020
     C                   PARM                    PWMsgID8                                     CER020
     C                   PARM                    IKISDT                                       CER020
     C                   PARM                    DDVDAT                                       CER020
     C                   PARM                    DDISDT                                       CER020
     C                   PARM                    DDCCY                                        CER020
     C                   PARM                    BJDFIN                                       CER020
     C                   PARM                    PDefISFlg                                    CER020
     C                   PARM                    PDefISVal                                    CER020
      *                                                                                       CER020
     C                   IF        PMsg8 <> *BLANKS                                           CER020
      *                                                                                       CER020
     C     PMsg8         LOOKUP    MsgIDArr                               99                  CER020
     C                   IF        *IN99 = '0'                                                CER020
      *                                                                                       CER020
     C                   ADD       1             Idx                                          CER020
     C                   EVAL      FldNameArr(Idx) = 'DDISDT'                                 CER020
     C                   EVAL      MsgIDArr(Idx) = PMsg8                                      CER020
      *                                                                                       CER020
     C                   ENDIF                                                                CER020
      *                                                                                       CER020
     C                   ENDIF                                                                CER020
      *                                                                                       CER020
     C                   IF        PWMsgID8 <> *BLANKS                                        CER020
      *                                                                                       CER020
     C     PWMsgID8      LOOKUP    WMsgIDArr                              99                  CER020
     C                   IF        *IN99 = '0'                                                CER020
      *                                                                                       CER020
     C                   ADD       1             WIdx                                         CER020
     C                   EVAL      WFldNamArr(WIdx) = 'DDISDT'                                CER020
     C                   EVAL      WMsgIDArr(WIdx) = PWMsgID8                                 CER020
     C                   EVAL      WarnGlobal = 'Y'                                           CER020
      *                                                                                       CER020
     C                   ENDIF                                                                CER020
      *                                                                                       CER020
     C                   ENDIF                                                                CER020
      *                                                                                       CER020
      ** Use the return code's value to set the field's OK flag                               CER020
      *                                                                                       CER020
     C                   CALLB     'ZASETOKFLG'                                               CER020
     C                   PARM                    DDIsDtOK                                     CER020
     C                   PARM                    ReturnCode                                   CER020
     C                   PARM                    WarnGlobal                                   CER020
      *                                                                                       CER020
      ** Validate Final Maturity Date                                                         CER020
      *                                                                                       CER020
     C                   EXSR      RESETERRS                                                  CER020
     C                   CALLB     'MMVFNMTDAT'                                               CER020
     C                   PARM      *BLANKS       ReturnCode                                   CER020
     C                   PARM                    PMsg9                                        CER020
     C                   PARM                    PWMsgID9                                     CER020
     C                   PARM                    IKFMDT                                       CER020
     C                   PARM                    DDMDAT                                       CER020
     C                   PARM                    DDFMDT                                       CER020
     C                   PARM                    DDTYPE                                       CER020
     C                   PARM                    DDCCY                                        CER020
     C                   PARM                    BJDFIN                                       CER020
     C                   PARM                    PDefFMFlg                                    CER020
      *                                                                                       CER020
     C                   IF        PMsg9 <> *BLANKS                                           CER020
      *                                                                                       CER020
     C     PMsg9         LOOKUP    MsgIDArr                               99                  CER020
     C                   IF        *IN99 = '0'                                                CER020
      *                                                                                       CER020
     C                   ADD       1             Idx                                          CER020
     C                   EVAL      FldNameArr(Idx) = 'DDFMDT'                                 CER020
     C                   EVAL      MsgIDArr(Idx) = PMsg9                                      CER020
      *                                                                                       CER020
     C                   ENDIF                                                                CER020
      *                                                                                       CER020
     C                   ENDIF                                                                CER020
      *                                                                                       CER020
     C                   IF        PWMsgID9 <> *BLANKS                                        CER020
      *                                                                                       CER020
     C     PWMsgID9      LOOKUP    WMsgIDArr                              99                  CER020
     C                   IF        *IN99 = '0'                                                CER020
      *                                                                                       CER020
     C                   ADD       1             WIdx                                         CER020
     C                   EVAL      WFldNamArr(WIdx) = 'DDFMDT'                                CER020
     C                   EVAL      WMsgIDArr(WIdx) = PWMsgID9                                 CER020
     C                   EVAL      WarnGlobal = 'Y'                                           CER020
      *                                                                                       CER020
     C                   ENDIF                                                                CER020
      *                                                                                       CER020
     C                   ENDIF                                                                CER020
      *                                                                                       CER020
      ** Use the return code's value to set the field's OK flag                               CER020
      *                                                                                       CER020
     C                   CALLB     'ZASETOKFLG'                                               CER020
     C                   PARM                    DDFmDtOK                                     CER020
     C                   PARM                    ReturnCode                                   CER020
     C                   PARM                    WarnGlobal                                   CER020
      *                                                                                       CER020
     C                   ENDIF                                                                CER020
      *                                                                                       CER020
     C                   IF        Idx = 0
     C                   EXSR      SetupValid
     C                   ENDIF
 
      /COPY WNCPYSRC,MMLDNVP008
 
     C                   RETURN
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,MMLDNVP009
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      * Response mode (1A), from source system common header
     C                   PARM                    RespMode
      * Transaction information (DS) from source system
     C                   PARM                    TranIn
     C                   PARM                    InfData
      * Receive Settlement Ccy, Method & Nostro and  Pay Settlement Ccy,
      * Method & Nostro, from default or valid deal
     C                   PARM                    RecSetCcy
     C                   PARM                    RecSetMeth
     C                   PARM                    RecNostro
     C                   PARM                    PaySetCcy
     C                   PARM                    PaySetMeth
     C                   PARM                    PayNostro
     C                   PARM                    FrontOffice
     C                   PARM                    ExtData
      * Field OK flags (DS) from/to caller
     C                   PARM                    OKFlagsDS
     C                   PARM                    OKFlagsDS2                                  BUG5169
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx
      * Valid Deals layout (DS) from/to caller
     C                   PARM                    ValidDeal
     C/COPY WNCPYSRC,MMLDNVP010
     C                   PARM                    RepoFlag          1
     C/COPY WNCPYSRC,MMLDNVP011
      **************                                                                         BUG5517
      ****GET*ZMUSER to access default branch.                                               BUG5517
      **************                                                                         BUG5517
     C******DTAARA**     DEFINE                  ZMUSER                                      BUG5517
     C**************     IN        ZMUSER                                                    BUG5517
     C**************     UNLOCK    ZMUSER                                                    BUG5517
      *
      **  Move program name into *LDA field.
      *
     C     *LOCK         IN        LDA
     C*********          MOVEL     'MMLDNIVAL'   DBPGM                                       BUG5169
     C                   MOVEL     'MMLDNIVLP'   DBPGM                                       BUG5169
     C                   OUT       LDA
      *
      ** Access Bank details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Access General Ledger details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOGELRR1'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDGELR        PARM      SDGELR        DSSDY
      *
      ** Access Dealing details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AODEALR1'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDDEAL        PARM      SDDEAL        DSSDY
      *
      ** Access Trading data via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOTRADR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDTRAD        PARM      SDTRAD        DSFDY
      *
      ** Access MIDAS Modules details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOMMODR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** Access Portfolio Management details via access program
      *  (database error handling done in access program)
     C     BGPFMG        IFEQ      'Y'
     C                   CALLB     'AOPORTR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST'      @OPTN
     C     SDPORT        PARM      SDPORT        DSFDY
     C                   ENDIF
 
      ** Access SAR details file to determine if CDE002 is switched on
 
     C                   CallB     'AOSARDR0'
     C                   Parm      *Blanks       PRTCD             7
     C                   Parm      '*VERIFY'     POPTN             7
     C                   Parm      'CDE002'      PSARD             6
     C     SCSARD        Parm      SCSARD        DSFDY
      *
     C                   Move      'N'           CDE002            1
     C                   If        PRTCD = *Blanks
     C                   Eval      CDE002 = 'Y'
     C                   Endif
      *
      ** Access Profit Centre Accounting details via access program
      *  (database error handling done in access program)
     C     BGN0ST        IFEQ      'Y'
     C                   CALLB     'AOPCACR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST'      @OPTN
     C     SDPCAC        PARM      SDPCAC        DSFDY
     C                   ENDIF
      *
      ** Access Retail details via access program
      *  (database error handling done in access program)
     C     BGRTBN        IFEQ      'Y'
     C     BGIOAC        OREQ      'Y'
     C                   CALLB     'AORETLR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDRETL        PARM      SDRETL        DSFDY
     C                   ENDIF
      *
      ** Access SAR details file to determine if Australian Brokerage
      ** is switched on
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'AUS007'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE                         * DBERROR 013 *
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     'AUS007'      DBKEY
     C                   OUT       LDA
     C                   SETON                                        U7U8LR
     C                   EXSR      #TERM
     C                   END
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           AUS007            1
     C                   SETON                                        14
     C                   ELSE
     C                   MOVEL     'N'           AUS007
     C                   END
      *
      ** Access SAR details file to determine if Enhanced Rollovers
      ** is switched on
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01434'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE                         * DBERROR 014 *
     C                   MOVEL     '002'         DBASE
     C                   MOVEL     'S01434'      DBKEY
     C                   OUT       LDA
     C                   SETON                                        U7U8LR
     C                   EXSR      #TERM
     C                   END
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           S01434            1
     C                   ELSE
     C                   MOVEL     'N'           S01434
     C                   END
      *
      ** Access SAR details file to determine if S01468 (changed
      ** validation for total interest field) is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01468'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE                         * DBERROR 020 *
     C                   MOVEL     '003'         DBASE
     C                   MOVEL     'S01468'      DBKEY
     C                   OUT       LDA
     C                   SETON                                        U7U8LR
     C                   EXSR      #TERM
     C                   END
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           S01468            1
     C                   ELSE
     C                   MOVEL     'N'           S01468
     C                   END
      *
      ** ACCESS SAR DETAILS FILE TO DETERMINE IF BRT SAR IS INSTALLED
      ** (DATABASE ERROR HANDLING DONE IN ACCESS PROGRAM)
      **
     C                   CALLB     'AOSARDR0'
     C                   PARM      '       '     @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01383'      @SARD             6
     C     @RTCD         IFNE      *BLANK
     C     @RTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE                         * DBERROR 012 *
     C                   MOVEL     '004'         DBASE
     C                   MOVEL     @RTCD         DBKEY
     C                   OUT       LDA
     C                   SETON                                        U7U8LR
     C                   EXSR      #TERM
     C                   END
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           S01383            1
     C                   END
     C*
     C** IF BRT SAR INSTALLED, ACCESS BRT INSTALLATION CONTROL DATA
     C*
     C     S01383        IFEQ      'Y'
     C                   MOVE      'D'           BRTKEY            1
     C     BRTKEY        CHAIN     SDBRTDD0                           60
     C*
     C** if *in60 is on, then it is a data base error
     C*
     C     *IN60         IFEQ      '1'
     C     *LOCK         IN        LDA                                          ***************
     C                   MOVEL     'SDBRTDPD'    DBFILE                         * DBERROR 013 *
     C                   MOVEL     '005'         DBASE                          ***************
     C                   MOVEL     BRTKEY        DBKEY
     C                   OUT       LDA
     C                   SETON                                        U7U8LR
     C                   EXSR      #TERM
     C                   END
     C                   END
     C**
     C** ACCESS SAR DETAILS FILE TO DETERMINE IF JSM SAR IS INSTALLED
     C** (DATABASE ERROR HANDLING DONE IN ACCESS PROGRAM)
     C**
     C                   CALLB     'AOSARDR0'
     C                   PARM      '       '     @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01391'      @SARD             6
     C     @RTCD         IFNE      *BLANK
     C     @RTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA                                          ***************
     C                   MOVEL     'SCSARDPD'    DBFILE                         * DBERROR 014 *
     C                   MOVEL     '006'         DBASE                          ***************
     C                   MOVEL     @RTCD         DBKEY
     C                   OUT       LDA
     C                   SETON                                        U7U8LR
     C                   EXSR      #TERM
     C                   END
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           S01391            1
     C                   END
      *
      ** Access SAR details file to determine if CDL005 is on.
      ** (Customer format in input functions is shortname)
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CDL005'      @SARD             6
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE                         * DBERROR 020 *
     C                   MOVEL     '007'         DBASE
     C                   MOVEL     'CDL005'      DBKEY
     C                   OUT       LDA
     C                   SETON                                        U7U8LR
     C                   EXSR      #TERM
     C                   END
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'S'           CustFormat        1
     C                   ELSE
     C                   MOVEL     'N'           CustFormat
     C                   END
      *
      ** Access SAR details file to determine if CDL011 is on.
      ** (Expansion of Customer Number on Dealing Transactions)
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CDL011'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CDL011'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '013'         DBASE
     C                   EXSR      *PSSR
     C                   END
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'S'           CustFormat
     C                   END
      *
      ** Access SAR details file to determine if CEU003 is on.
      ** (EMU Dealing settlement currency conversion)
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU003'      @SARD
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE                         * DBERROR 020 *
     C                   MOVEL     '008'         DBASE
     C                   MOVEL     'CEU003'      DBKEY
     C                   OUT       LDA
     C                   SETON                                        U7U8LR
     C                   EXSR      #TERM
     C                   END
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CEU003            1
     C                   END
      *
      ** Access SAR details file to determine if CEU015 is on.
      ** (EMU Rollover into Euros)
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU015'      @SARD
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '009'         DBASE
     C                   MOVEL     'CEU015'      DBKEY
     C                   OUT       LDA
     C                   SETON                                        U7U8LR
     C                   EXSR      #TERM
     C                   END
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CEU015            1
     C                   END
      *
      ** Access SAR details file to determine if CSE006 is on.
      ** (EMU Rollover into Euros)
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSE006'      @SARD
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '009'         DBASE
     C                   MOVEL     'CSE006'      DBKEY
     C                   OUT       LDA
     C                   SETON                                        U7U8LR
     C                   EXSR      #TERM
     C                   END
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CSE006            1
     C                   END
      *
      ** Access SAR details file to determine if CDL007 is on.
      ** (Deposit Breakdown Penalty)
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CDL007'      @SARD             6
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '010'         DBASE
     C                   MOVEL     'CDL007'      DBKEY
     C                   OUT       LDA
     C                   SETON                                        U7U8LR
     C                   EXSR      #TERM
     C                   END
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CDL007            1
     C                   ELSE
     C                   MOVEL     'N'           CDL007
     C                   ENDIF
 
      ** Access SAR details file to determine if CAS001 is on.
      ** (Net Present Value Accounting)
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CAS001'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C                   IF        PRTCD <> *BLANKS AND
     C                             PRTCD <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 011
     C                   EVAL      DBKEY = 'CAS001'
     C                   OUT       LDA
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   EXSR      #TERM
     C                   ENDIF
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CAS001 = 'Y'
     C                   ELSE
     C                   EVAL      CAS001 = 'N'
     C                   ENDIF
 
      ** Check if CSC011 is installed
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSC011'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRTCD = *Blanks
 
     C                   EVAL      CSC011 = 'Y'
 
     C                   IN        SC24X7
     C                   IN        SDSTAT
 
     C                   ELSE
 
      ** Database error
 
     C                   IF        PRTCD <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = 'CSC011'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 905
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
 
      ** Access SAR details file to determine if CDL010 is on.
      ** (Dealing Transaction Authorisation)
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CDL010'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C                   IF        PRTCD <> *BLANKS AND
     C                             PRTCD <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 012
     C                   EVAL      DBKEY = 'CDL010'
     C                   OUT       LDA
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   EXSR      #TERM
     C                   ENDIF
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CDL010 = 'Y'
     C                   ELSE
     C                   EVAL      CDL010 = 'N'
     C                   ENDIF
 
      ** If 24X7 Midas availability is installed and support system is
      ** active, used processing date from dataarea SC24X7 as the
      ** rundate.
 
     C                   IF        CSC011 = 'Y' AND
     C                             S1SUPP = LIBR
     C                   EVAL      WProcDate = S1DATE
     C                   ELSE
     C                   EVAL      WProcDate = BJRDNB
     C                   ENDIF
 
      ** Access SAR details file to determine if CAS005 is on.
      ** (Enhancements to CAS001, CAS002 and CAS004)
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CAS005'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRTCD <> *BLANKS AND
     C                             PRTCD <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 906
     C                   EVAL      DBKEY = 'CAS005'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CAS005 = 'Y'
     C                   ELSE
     C                   EVAL      CAS005 = 'N'
     C                   ENDIF
 
      ** Access SAR details file to determine if CDL016 is switched on
      ** (Autumatic Rollover of Fixed Term Loan/Deposit)
 
     C                   CallB     'AOSARDR0'
     C                   Parm      *Blanks       PRTCD
     C                   Parm      '*VERIFY'     POPTN
     C                   Parm      'CDL016'      PSARD
     C     SCSARD        Parm      SCSARD        DSFDY
      *
     C                   Move      'N'           CDL016            1
     C                   If        PRTCD = *Blanks
     C                   Eval      CDL016 = 'Y'
     C                   Endif
                                                                                              CDL033
      ** Verify if Floating Rate CDs Issued enhancement is on.                                CDL033
                                                                                              CDL033
     C                   CALLB     'AOSARDR0'                                                 CDL033
     C                   PARM      *BLANKS       PRTCD                                        CDL033
     C                   PARM      '*VERIFY'     POPTN                                        CDL033
     C                   PARM      'CDL033'      PSARD                                        CDL033
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL033
     C                   SELECT                                                               CDL033
     C                   WHEN      PRTCD = *BLANKS                                            CDL033
     C                   MOVE      'Y'           CDL033            1                          CDL033
     C                   WHEN      PRTCD <> '*NRF   '                                         CDL033
     C     *LOCK         IN        LDA                                                        CDL033
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CDL033
     C                   EVAL      DBASE = 014                                                CDL033
     C                   EVAL      DBKEY = PSARD                                              CDL033
     C                   OUT       LDA                                                        CDL033
     C                   EXSR      *PSSR                                                      CDL033
     C                   OTHER                                                                CDL033
     C                   MOVE      'N'           CDL033                                       CDL033
     C                   ENDSL                                                                CDL033
      *
      ** Access SAR details file to determine if CDL020 is switched on                       BUG5169
      ** (Apply Base Rate at Value Date)                                                     BUG5169
                                                                                             BUG5169
     C                   CallB     'AOSARDR0'                                                BUG5169
     C                   Parm      *Blanks       PRTCD                                       BUG5169
     C                   Parm      '*VERIFY'     POPTN                                       BUG5169
     C                   Parm      'CDL020'      PSARD                                       BUG5169
     C     SCSARD        Parm      SCSARD        DSFDY                                       BUG5169
      *                                                                                      BUG5169
     C                   Move      'N'           CDL020            1                         BUG5169
     C                   If        PRTCD = *Blanks                                           BUG5169
     C                   Eval      CDL020 = 'Y'                                              BUG5169
     C                   Endif                                                               BUG5169
      *                                                                                       CER020
      ** Check if CER020 is enabled.                                                          CER020
      *                                                                                       CER020
     C                   CALLB     'AOSARDR0'                                                 CER020
     C                   PARM      *BLANKS       PRtcd                                        CER020
     C                   PARM      '*VERIFY'     POptn                                        CER020
     C                   PARM      'CER020'      PSard                                        CER020
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER020
      *                                                                                       CER020
     C                   IF        PRtcd = *BLANKS                                            CER020
     C                   EVAL      CER020 = 'Y'                                               CER020
     C                   ELSE                                                                 CER020
      *                                                                                       CER020
     C                   EVAL      CER020 = 'N'                                               CER020
     C                   ENDIF                                                                CER020
      *                                                                                     MD026390
      ** Check if CGL058 is enabled.                                                        MD026390
      *                                                                                     MD026390
     C                   CALLB     'AOSARDR0'                                               MD026390
     C                   PARM      *BLANKS       PRtcd                                      MD026390
     C                   PARM      '*VERIFY'     POptn                                      MD026390
     C                   PARM      'CGL058'      PSard                                      MD026390
     C     SCSARD        PARM      SCSARD        DSFDY                                      MD026390
      *                                                                                     MD026390
     C                   IF        PRtcd = *BLANKS                                          MD026390
     C                   EVAL      CGL058 = 'Y'                                             MD026390
     C                   ELSE                                                               MD026390
      *                                                                                     MD026390
     C                   EVAL      CGL058 = 'N'                                             MD026390
     C                   ENDIF                                                              MD026390
 
      ** Check if CER069 is installed                                                       MD030409
                                                                                            MD030409
     C                   CALLB     'AOSARDR0'                                               MD030409
     C                   PARM      *BLANKS       PRtCd                                      MD030409
     C                   PARM      '*VERIFY'     POptn                                      MD030409
     C                   PARM      'CER069'      PSard                                      MD030409
     C     SCSARD        PARM      SCSARD        DSFDY                                      MD030409
                                                                                            MD030409
     C                   IF        PRtCd = *Blanks                                          MD030409
     C                   EVAL      CER069 = 'Y'                                             MD030409
     C                   ELSE                                                               MD030409
     C                   EVAL      CER069 = 'N'                                             MD030409
     C                   ENDIF                                                              MD030409
                                                                                            MD030409
      *  Set up the name of the MSGF from which the message handler will
      *   get the messages
     C                   EVAL      #MsgFile = 'DRSMM'
      *
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,MMLDNVP012
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * RESETERRS - Reset error information that is received back     *
      *    from each validation module.                               *
      *                                                               *
      * Called by: Main processing, before each validation module     *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     RESETERRS     BEGSR
 
     C                   RESET                   Msg1
     C                   RESET                   Msg2
     C                   RESET                   Msg3
     C                   RESET                   Msg4
     C                   RESET                   Msg5
     C                   RESET                   Msg6
     C                   RESET                   Msg7
 
     C                   RESET                   WMsgID1
     C                   RESET                   WMsgID2
     C                   RESET                   WMsgID3
     C                   RESET                   WMsgID4
     C                   RESET                   PMsg8                                        CER020
     C                   RESET                   PMsg9                                        CER020
     C                   RESET                   PMsg10                                       CER020
     C                   RESET                   PWMsgID8                                     CER020
     C                   RESET                   PWMsgID9                                     CER020
 
     C                   RESET                   MSGDATA
 
     C                   EVAL      ReturnCode= *Blanks
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPVALID - Set up additional fields that are needed on the  *
      *    Valid file record.                                         *
      *                                                               *
      *****************************************************************
 
     C     SETUPVALID    BEGSR
 
     C                   IF        CSE006='Y' and RepoFlag='Y'
     C
     C                   IF        DDTRTP='PR' or DDTRTP='RR'
     C                   EVAL      REPO='R'
     C                   ENDIF
     C
     C                   IF        DDTRTP='PL' or DDTRTP='PD'
     C                   EVAL      REPO='P'
     C                   ENDIF
     C
     C                   IF        DDTRTP='BB' or DDTRTP='BL'
     C                   EVAL      REPO='B'
     C                   ENDIF
     C
     C                   ENDIF
     C
 
      * Other IKxxxx fields are set up during the individual date
      *  validation, such as the ones where the input & database formats
      *  are different, e.g. dates, amounts.
      * This SR sets up the fields with the same (or compatible) attributes
 
     C                   MOVE      DDTYPE        IKTYPE
     C                   MOVE      DDSTYP        IKSTYP
     C                   MOVE      DDFEDF        IKFEDF
     C                   MOVE      DDDADN        IKDADN
     C                   MOVE      DDBRCA        IKBRCA
     C                   MOVE      DDBOKC        IKBOKC
     C                   MOVE      DDLNKN        IKLNKN
     C                   MOVE      DDBKCD        IKBKCD
     C                   MOVE      DDCCY         IKCCY
     C                   MOVE      DDICMT        IKICMT
     C                   MOVE      DDNGVI        IKNGVI
     C                   MOVE      DDIPFQ        IKIPFQ
     C                   MOVE      DDIPDM        IKIPDM
     C                   MOVE      DDCPTI        IKCPTI
     C                   MOVE      DDMTAX        IKMTAX
     C                   MOVE      DDFUID        IKFUID
     C                   MOVE      DDFLID        IKFLID
     C                   MOVE      DDRDFC        IKRDFC
     C                   MOVE      DDCDRF        IKCDRF
     C                   MOVE      DDPRFC        IKPRFC
     C                   MOVE      DDORBR        IKORBR
     C                   MOVE      DDAURO        IKAURO
     C                   MOVE      DDCNNA        IKCNNA
     C                   MOVE      DDIPDS        IKIPDS
     C                   MOVE      DDIMET        IKIMET
     C                   MOVE      DDINSA        IKINSA
     C                   MOVE      DDROFQ        IKROFQ
     C                   MOVE      DDRLDN        IKRLDN
     C                   MOVE      DDINOS        IKINOS
     C                   MOVE      DDRACD        IKRACD
 
      **  If screen Portfolio Reference is the Non-Portfolio value default
      **   in the file equivalent of this
     C*****DDPTFR        IFEQ      FCR997                                                   BUG10343
     C*****FCPORS        ANDNE     'B'                                                      BUG10343
     C*****BGN4ST        ANDNE     'Y'                                                      BUG10343
     C*****FCPORS        OREQ      'B'                                                      BUG10343
     C*****DDPTFR        ANDNE     *BLANKS                                                  BUG10343
     C*****DDPTFR        ANDEQ     FCR997                                                   BUG10343
     C*****BGN4ST        ANDNE     'Y'                                                      BUG10343
     C**********         MOVE      '9997'        IKPTFR                                     BUG10343
     C**********         ELSE                                                               BUG10343
     C**********         MOVE      DDPTFR        IKPTFR                                     BUG10343
     C**********         END                                                                BUG10343
 
      **  This routine may be called as part of amend processing, only do
      **   following sections if the relevant fields are valid
 
     C                   IF        (DDAmnpOK <> 'N') AND
     C                             (DDTotIOK <> 'N')
 
      **  Set the sign of the Amount and Total Interest depending upon the
      **  type of deal.  Signs of these two fields will always be opposite.
      **  Amount is -ive for a Loan, +ive for a deposit.
 
     C     DDTYPE        IFEQ      'IP'
     C     DDTYPE        OREQ      'TI'
     C     DDTYPE        OREQ      'CL'
     C     DDTYPE        OREQ      'LN'
     C     DDTYPE        OREQ      'DL'
 
     C     IKAMNP        IFGT      0
     C                   Z-SUB     IKAMNP        IKAMNP
     C                   ENDIF
     C     IKMTTI        IFLT      0
     C                   Z-SUB     IKMTTI        IKMTTI
     C                   ENDIF
 
     C                   ELSE
 
     C     IKAMNP        IFLT      0
     C                   Z-SUB     IKAMNP        IKAMNP
     C                   ENDIF
     C     IKMTTI        IFGT      0
     C                   Z-SUB     IKMTTI        IKMTTI
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        (DDBsRCOK <> 'N')
      **  Set spread field to spread/rate if base rate code entered,
      **  if not, set input interest field to spread/rate.
     C     DDBSRC        IFNE      *BLANKS
     C                   MOVE      @SPRD         IKSPRD
     C                   ELSE
     C                   MOVE      @SPRD         IKIIRT
     C     DDNGVI        IFEQ      'Y'
     C**********         Z-SUB     IKIIRT        IKIIRT                                     MD031494
     C                   Z-ADD     IKINTR        IKIIRT                                     MD031494
     C                   END
     C                   END
 
     C                   ENDIF
 
      ** Set up The user field from ZMUSER which is the front office
      ** user if sent . Only if CDL010 is installed
 
     C     CDL010        IFEQ      'Y'
     C                   MOVE      ZUSER         IKUSER
     C                   END
 
      ** Set up Rollover Indicator field if CDL016 is on
 
     C     CDL016        IFEQ      'Y'
     C                   MOVE      DDROLI        IKROLI
     C                   ENDIF
      *                                                                                       CER020
     C                   IF        CER020 = 'Y'                                               CER020
     C                   MOVEL     DDORDN        IKORDN                                       CER020
     C                   ENDIF                                                                CER020
 
     C                   ENDSR
      *****************************************************************                     MD030409
      *                                                               *                     MD030409
      * GetTaxInd - Subroutine to retrieve the Tax Indicator          *                     MD030409
      *                                                               *                     MD030409
      *****************************************************************                     MD030409
                                                                                            MD030409
     C     GetTaxInd     BEGSR                                                              MD030409
                                                                                            MD030409
     C                   EVAL      TaxInd = DDMTAX                                          MD030409
                                                                                            MD030409
     C                   IF        CER069 = 'Y' AND                                         MD030409
     C                             DDMTAX = 'A'                                             MD030409
                                                                                            MD030409
     C                   CALLB     'AOCUSTR1'                                               MD030409
     C                   PARM      *BLANKS       PRTCD                                      MD030409
     C                   PARM      '*KEY   '     POPTN                                      MD030409
     C                   PARM                    DDCUST                                     MD030409
     C                   PARM      *BLANKS       PKEY7             7                        MD030409
     C     SDCUST        PARM      SDCUST        DSLDY                                      MD030409
                                                                                            MD030409
     C                   IF        PRTCD = *BLANKS                                          MD030409
     C                   CALL      'AOACTXR0'                                               MD030409
     C                   PARM      *BLANKS       PRTCD                                      MD030409
     C                   PARM      '*KEY   '     POPTN                                      MD030409
     C                   PARM                    BBCUST                                     MD030409
     C                   PARM                    DDBRCA                                     MD030409
     C     SDACTX        PARM      SDACTX        DSFDY                                      MD030409
                                                                                            MD030409
     C                   IF        PRTCD = *BLANKS AND                                      MD030409
     C                             AXETXS = 'T'                                             MD030409
     C                   EVAL      TaxInd = 'T'                                             MD030409
     C                   ENDIF                                                              MD030409
     C                   ENDIF                                                              MD030409
                                                                                            MD030409
     C                   ENDIF                                                              MD030409
                                                                                            MD030409
     C                   ENDSR                                                              MD030409
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * #TERM    - Termination processing.                            *
      *                                                               *
      *****************************************************************
     C     #TERM         BEGSR
      *
      **  Terminate program
      *
     C     *INU7         IFEQ      '1'
     C                   DUMP
     C                   END
      *
     C                   RETURN
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
     C/COPY ZACPYSRC,DBERREXIT
      ********************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
      /EJECT
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2004
