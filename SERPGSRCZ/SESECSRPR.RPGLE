     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Invalid securities repair')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SESECSRPR - Invalid Securities Repair                        *
      *                                                               *
      *  Function: This module allows invalid security details to be  *
      *            'repaired' and applied to the Midas database.      *
      *                                                               *
      *  Component of: SESECSRPR                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. LLN022A            Date 03Jun15               *
      *  Prev Amend No. LLN022             Date 03Jun15               *
      *                 AR996842           Date 11Feb13               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 248555             Date 18Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 232543             Date 04Apr05               *
      *                 CGL031             Date 05Jul04               *
      *                 CGL032             Date 05Jul04               *
      *                 BUG9529            Date 06Dec05               *
      *                 BUG9531            Date 06Dec05               *
      *                 BUG9530            Date 06Dec05               *
      *                 CER001             Date 25Apr05               *
      *                 CSE065             Date 08Nov04               *
      *                 CSE071             Date 19Jul05               *
      *                 220008             Date 28Jul03               *
      *                 218563             Date 10Jun03               *
      *                 CGL014             Date 20Oct03               *
      *                 CSC022             Date 24Feb04               *
      *                 222373             Date 23Oct03               *
      *                 CAS006             Date 21Jan03               *
      *                 CSE037             Date 29Apr02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011             Date 18Sep01               *
      *                 CSE031             Date 26Nov01               *
      *                 CSE032             Date 03Jan02               *
      *                 193883             Date 20Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSE029             Date 20Jul01               *
      *                 192054             Date 28Jun01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CAP060             Date 22May01               *
      *                 CSD006             Date 12Jan01               *
      *                 183604             Date 16Oct00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSE023             Date 12Jul00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP137  *CREATE    Date 07Feb00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LLN022A - BOE Upgrade to MidasPlus - incorporate code from   *
      *            /COPY members and add switchability.               *
      *  LLN022 - BOE Upgrade to MidasPlus                            *
      *           Recompiled over changes in /COPY                    *
      *  AR996842 - Creation of new security details: Private Banking *
      *             Instrument type defaulting improvement            *
      *             (Child:AR996843)                                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  248555 - Parameter mismatch for SESECS3VL (232543, CGL031)   *
      *           and SESECSCVT (CGL032)                              *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  232543 - Fix to CGL031                                       *
      *  CGL031 - Taxation on Savings Income                          *
      *  CGL032 - Automatic Exchange of Information                   *
      *  BUG9529 - Use full length of SEVSECSPD data structure.       *
      *  BUG9531 - Additional processing to prevent program from      *
      *            looping after the call to window program.          *
      *  BUG9530 - Parameter mismatch while calling SESECS2MD,        *
      *            SESECS2VL and SESECSCVT.                           *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  CSE065 - Const. Yield Amort. on Mortgage backed assets       *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  220008 - Securities input accepts country of tax which does  *
      *           not exist in SDWHTTPD. Fix is to add validation.    *
      *  218563 - Withholding Tax details window not shown. Fix is to *
      *           call window after 3rd screen if processing is on.   *
      *  CGL014 - Collaterals Processing                              *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  222373 - Parameter Mismatch                                  *
      *  CAS006 - Hedge Accounting Phase B                            *
      *  CSE037 - Countervalue rounding                               *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CSE031 - Coupon Fixing for Floating Rate Notes.              *
      *  CSE032 - Recompile over recompiled SESECS2VL.                *
      *  193883 - Recompile over changed SESECSUPD.                   *
      *  CSE029 - ISO15022 Message Generation (recompile)             *
      *  192054 - ISIN code must be available if Private banking is on*
      *  CAP060 - Midas APIs Sec Prices                               *
      *  CSD006 - Market Data Feed                                    *
      *  183604 - Industry Code and Market Center must be mandatory   *
      *           when new PB Module is switched ON. Rating Code      *
      *           must be validated against new table PBRATIPD when   *
      *           new PB Module is switched ON.                       *
      *  CSE023 - Treaty Withholding Tax                              *
      *  CAP137 - Conversion of SE Security inputs into modular       *
      *           modular structure to use as APIs.                   *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Transaction Errors file keyed on Front Office Transaction Id,
      ** Timestamp and Transaction Field Identifier
     FZATRNERRL1IF   E           K DISK    INFSR(*PSSR)
      *
      ** Invalid Security details by Timestamp and Front Office Id
      ** - for record retrieval
     FSEISECSL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SEISECSD0:SEISECSX0)
      *
      ** Invalid Security details by Front Office Id and Timestamp
      ** - for record update
     FSEISECSL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
                                                                                              CSC011
      ** API Invalid Log File by Type/FO ID/Timestamp                                         CSC011
     FAPILOGL0  UF   E           K DISK    INFSR(*PSSR) USROPN                                CSC011
     F                                     COMMIT                                             CSC011
      *                                                                                       CER001
     FSEISELX2L0UF   E           K DISK    USROPN                                             CER001
     F                                     INFSR(*PSSR)                                       CER001
     F                                     COMMIT                                             CER001
     F                                     RENAME(SEISELXD4:RTVIDX1)                          CER001
     FSEISELX5L0UF   E           K DISK    USROPN                                             CER001
     F                                     INFSR(*PSSR)                                       CER001
     F                                     COMMIT                                             CER001
     F                                     RENAME(SEISELXD6:RTVIDX2)                          CER001
     FSEISELX1L0UF   E           K DISK    USROPN                                             CER001
     F                                     INFSR(*PSSR)                                       CER001
     F                                     COMMIT                                             CER001
     F                                     RENAME(SEISELXDL:RTVIDX3)                          CER001
      *
      ** Hook to enable non-core files to be included
      /COPY WNCPYSRC,SESECSR001
      *
      *
     FSEISECSY0 UF   E           K DISK    INFSR(*PSSR)                                      LLN022A
     F                                     RENAME(SEISECSD0 : ISECSD0)                       LLN022A
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
      *
      /COPY ZACPYSRC,ERR_ARRAYS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
     D*WEI******       S              1    DIM(60)                                            CAS006
     D WEI             S              1    DIM(64)                                            CAS006
                                                                                              CSC022
     D WCmtJobArr      S             10A   DIM(10)                                            CSC022
      ** Array for commitment job names                                                       CSC022
      *
      ** Work array for warning message Ids
     D WPrvWarnAr      S                   Dim(ArrayMax)
     D                                     Like(WMsgIDArr)
      *
      ** Backup arrays for error messages on 1st screen
     D FldNameAr1      S                   Dim(ArrayMax)
     D                                     Like (FldNameArr)
     D MsgIdAr1        S                   Dim(ArrayMax)
     D                                     Like (MsgIdArr)
     D MsgDtaAr1       S                   Dim(ArrayMax)
     D                                     Like (MsgDtaArr)
      *
      ** Backup arrays for error messages on 2nd screen
     D FldNameAr2      S                   Dim(ArrayMax)
     D                                     Like (FldNameArr)
     D MsgIdAr2        S                   Dim(ArrayMax)
     D                                     Like (MsgIdArr)
     D MsgDtaAr2       S                   Dim(ArrayMax)
     D                                     Like (MsgDtaArr)
      *
      ** Backup arrays for error messages on 3rd screen
     D FldNameAr3      S                   Dim(ArrayMax)
     D                                     Like (FldNameArr)
     D MsgIdAr3        S                   Dim(ArrayMax)
     D                                     Like (MsgIdArr)
     D MsgDtaAr3       S                   Dim(ArrayMax)
     D                                     Like (MsgDtaArr)
      *                                                                                       CSE031
      ** Backup arrays for error messages on 4th screen                                       CSE031
     D FldNameAr4      S                   Dim(ArrayMax)                                      CSE031
     D                                     Like (FldNameArr)                                  CSE031
     D MsgIdAr4        S                   Dim(ArrayMax)                                      CSE031
     D                                     Like (MsgIdArr)                                    CSE031
     D MsgDtaAr4       S                   Dim(ArrayMax)                                      CSE031
     D                                     Like (MsgDtaArr)                                   CSE031
                                                                                              CAS006
      ** Backup arrays for error messages on 5th screen                                       CAS006
     D FldNameAr5      S                   Dim(ArrayMax)                                      CAS006
     D                                     Like (FldNameArr)                                  CAS006
     D MsgIdAr5        S                   Dim(ArrayMax)                                      CAS006
     D                                     Like (MsgIdArr)                                    CAS006
     D MsgDtaAr5       S                   Dim(ArrayMax)                                      CAS006
     D                                     Like (MsgDtaArr)                                   CAS006
      *
      ** Security details 1st screen details from incoming transaction
      ** - screen format
     D NwSE1ScnFmt   E DS                  EXTNAME(SESEC1PD)
      *
      ** Security details 2nd screen details from incoming transaction
      ** - screen format
     D NwSE2ScnFmt   E DS                  EXTNAME(SESEC2PD)
      *
      ** Security details 3rd screen details from incoming transaction
      ** - screen format
     D NwSE3ScnFmt   E DS                  EXTNAME(SESEC3PD)
      *                                                                                       CSE031
      ** Security screen 4 details from incoming transaction - screen format                  CSE031
     D NwSE4ScnFmt   E DS                  EXTNAME(SESEC4PD)                                  CSE031
                                                                                              CAS006
      ** Security Screen 5 Details From Incoming Transaction - Screen Format                  CAS006
     D NwSE5ScnFmt   E DS                  EXTNAME(SESEC5PD)                                  CAS006
      *                                                                                       CER001
     D NwExScnFmt    E DS                  EXTNAME(SESERXPD)                                  CER001
      *                                                                                       CER001
      ** Securities extra data layout - screen format                                         CER001
      *                                                                                       CER001
      *
      ** Security details for file update - file format
     D NwSEFilFmt    E DS                  EXTNAME(SEVSECSPD)
     D*NwSEFilFmt1             1    899                                               CSE065 BUG9529
      *                                                                                       CER001
     D NwExFilFmt2   E DS                  EXTNAME(SEVSELX2PD)                                CER001
      *                                                                                       CER001
      ** ER securities details extension for file update                                      CER001
      *                                                                                       CER001
     D NwExFilFmt3   E DS                  EXTNAME(SEVSELX3PD)                                CER001
      *                                                                                       CER001
      ** ER securities details extension for file update                                      CER001
      *                                                                                       CER001
     D NwExFilFmt4   E DS                  EXTNAME(SEVSELX1PD)                                CER001
      *                                                                                       CER001
      ** ER securities details extension for file update                                      CER001
      *                                                                                       CER001
      *
      ** Security details for file update- file format
     D NwSEFilFmtOld E DS                  EXTNAME(SEVSECSPD)
     D                                     PREFIX(O)
      *
      ** Security details 1st screen details retrieved from file
      ** - screen format
     D CrSE1ScnFmt   E DS                  EXTNAME(SESEC1PD)
     D                                     PREFIX(O)
      *
      ** Security details 2nd screen details retrieved from file
      ** - screen format
     D CrSE2ScnFmt   E DS                  EXTNAME(SESEC2PD)
     D                                     PREFIX(O)
      *
      ** Security details 3rd screen details retrieved from file
      ** - screen format
     D CrSE3ScnFmt   E DS                  EXTNAME(SESEC3PD)
     D                                     PREFIX(O)
      *                                                                                       CSE031
      ** Security screen 4 details retrieved from file - screen format                        CSE031
     D CrSE4ScnFmt   E DS                  EXTNAME(SESEC4PD)                                  CSE031
     D                                     PREFIX(O:1)                                        CSE031
                                                                                              CAS006
      ** Security Screen 5 Details Retrieved From File - Screen Format                        CAS006
     D CrSE5ScnFmt   E DS                  EXTNAME(SESEC5PD)                                  CAS006
     D                                     PREFIX(O:1)                                        CAS006
      *                                                                                      BUG9530
      ** Securities screen 6 details from incoming transaction                               BUG9530
      ** - screen format                                                                     BUG9530
     D NwSE6ScnFmt   E DS                  EXTNAME(SESEC6PD)                                 BUG9530
      *                                                                                      BUG9530
      ** Securities Screen 6 Details Retrieved From File                                     BUG9530
      ** - Screen Format                                                                     BUG9530
     D CrSE6ScnFmt   E DS                  EXTNAME(SESEC6PD)                                 BUG9530
     D                                     PREFIX(O)                                         BUG9530
      *
      ** Securities retrieved from file - file format
     D CrSEFilFmt    E DS                  EXTNAME(SECTYD)
     D*CrSEFilFmt1             1    899                                               CSE065 BUG9529
      *                                                                                       CER001
     D CrExFilFmt2   E DS                  EXTNAME(SESDX2PD)                                  CER001
      *                                                                                       CER001
      ** ER securities extension file format - current                                        CER001
      *                                                                                       CER001
     D CrExFilFmt3   E DS                  EXTNAME(SESDX3PD)                                  CER001
      *                                                                                       CER001
      ** ER securities extension file format - current                                        CER001
      *                                                                                       CER001
     D CrExFilFmt4   E DS                  EXTNAME(SESDX1PD)                                  CER001
     D  #VSESN       E                     EXTFLD(VVSESN)                                     CER001
      *                                                                                       CER001
      ** ER securities extension file format - current                                        CER001
      *                                                                                       CER001
      *
      ** Investment Types files
     D PINVTPD       E DS                  EXTNAME(INVTPD)
     D                                     PREFIX(F1)
      *
      ** Security details 1st screen error indicators
     D SEESEC1       E DS                  EXTNAME(SEESEC1PD)
      *
      ** Security details 2nd screen error indicators
     D SEESEC2       E DS                  EXTNAME(SEESEC2PD)
      *
      ** Security details 3rd screen error indicators
     D SEESEC3       E DS                  EXTNAME(SEESEC3PD)
      *                                                                                       CSE031
      ** Securities screen 4 error indicators                                                 CSE031
     D SEESEC4       E DS                  EXTNAME(SEESEC4PD)                                 CSE031
                                                                                              CAS006
      ** Securities Screen 5 Error Indicators                                                 CAS006
     D SEESEC5       E DS                  EXTNAME(SEESEC5PD)                                 CAS006
      *
      ** Security details extra data
     D PExtData      E DS                  EXTNAME(SESEEXPD)
      *
      ** Externally described DS for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Externally described DS for Midas Modules details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      *
      ** Externally described DS for securities trading ICD details
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
      *
      ** Externally described DS for API ICD details
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
      *
      ** Externally described DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SLCD          E                     EXTFLD(LCD)
      *
      ** DS for Access Objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS for Access Objects - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** Backup data structures for screen details
     D NwSE1ScnFmx   E DS                  EXTNAME(SESEC1PD)
     D                                     PREFIX(B)
     D NwSE2ScnFmx   E DS                  EXTNAME(SESEC2PD)
     D                                     PREFIX(B)
     D NwSE3ScnFmx   E DS                  EXTNAME(SESEC3PD)
     D                                     PREFIX(B)
     D NwSE4ScnFmx   E DS                  EXTNAME(SESEC4PD)                                  CSE031
     D                                     PREFIX(B)                                          CSE031
     D NwSE5ScnFmx   E DS                  EXTNAME(SESEC5PD)                                  CAS006
     D                                     PREFIX(B)                                          CAS006
      *
      ** Backup data structures for screen error indicators
     D SEESEC1x      E DS                  EXTNAME(SEESEC1PD)
     D                                     PREFIX(B)
     D SEEsEC2x      E DS                  EXTNAME(SEESEC2PD)
     D                                     PREFIX(B)
     D SEESEC3x      E DS                  EXTNAME(SEESEC3PD)
     D                                     PREFIX(B)
     D SEESEC4x      E DS                  EXTNAME(SEESEC4PD)                                 CSE031
     D                                     PREFIX(B)                                          CSE031
     D SEESEC5x      E DS                  EXTNAME(SEESEC5PD)                                 CAS006
     D                                     PREFIX(B)                                          CAS006
      *
      ** DS for ZMUSER details
     D ZMUSER          DS            17
     D  PUSRID                 1     10
     D  PDBRN                 11     13
      *
      ** DS of fields for output only
     D POutFlds        DS
     D  WCSNM1                       10A
     D  WCSNM2                       10A
     D  WCSNM3                       10A
     D  WMKTN                        20A
     D  WSTBS                         1A
                                                                                              CSC011
      ** SC24x7 Status Data Area                                                              CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
                                                                                              CSC011
      ** SD Data Area                                                                         CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
                                                                                              CSC022
     D SCCMTJOB      E DS           256    DTAARA(SCCMTJOB)                                   CSC022
     D  ComitJob               4    103                                                       CSC022
      ** Midas SC Jobs handling commitment control data area                                  CSC022
      *
     D DATALUX         DS          1024                                                       CER001
     D  L1SESN                 1     10A                                                      CER001
     D  L1FOTR                11     30A                                                      CER001
     D  L1ISNO                31     42A                                                      CER001
     D  #1DEXT                43     43                                                       CER001
     D  #2DEXT                44     44                                                       CER001
     D  #3DEXT                45     45                                                       CER001
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error messages
     D IDx             S              3P 0
      *
      ** Index for arrays of warning messages
     D WIDx            S              3P 0
      *
      ** Backup index for error messages on 1st screen
     D ID1             S              3P 0
      *
      ** Backup index for error messages on 2nd screen
     D ID2             S              3P 0
      *
      ** Backup index for error messages on 3rd screen
     D ID3             S              3P 0
      *                                                                                       CSE031
      ** Backup index for error messages on 4th screen                                        CSE031
     D ID4             S              3P 0                                                    CSE031
                                                                                              CAS006
      ** Backup index for error messages on 5th screen                                        CAS006
     D ID5             S              3P 0                                                    CAS006
      *
      ** Work index
     D Ex              S              3P 0
     D Fx              S              3P 0
     D WIx             S              3P 0
      *
      ** Mode of Operation
     D PMode           S              6A   INZ('*RPR  ')
      *
      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous.
     D PResponse       S              1A   INZ('S')
      *
      ** Fields for getting the starting field number from file
      ** (parameters to ZAGETFLDNO, plus the offset to the requested field)
     D PFormat         S             10A   INZ('SESECSPD')
     D PField1         S             10A   INZ('DDACTN')
     D PField2         S             10A   INZ('DDCPNR')
     D PField3         S             10A   INZ('DDISSD')
     D PField4         S             10A   INZ('DDAD01')                                      CAS006
     D PField5         S             10A   INZ('DDCCRK')                                      CAS006
     D PFieldExt       S             10A   INZ('L4LXPORE')                                    CER001
     D PFieldNo        S              5P 0
     D WFldOffset1     S              5P 0
     D WFldOffset2     S              5P 0
     D WFldOffset3     S              5P 0
     D WFldOffset4     S              5P 0                                                    CAS006
     D WFldOffset5     S              5P 0                                                    CAS006
     D WFldOffsetExt   S              5P 0                                                    CER001
      *
      ** Parameter fields
     D PFOTRID         S             20A
     D PBDSFL          S              1A
     D PRDSFL          S              1A
     D PRDNB           S              1A
     D PEdtFld         S              1A
     D PEKyFld         S              1A
     D PErrUp          S              1A
     D PErrMs          S              7A
     D POPSEL          S              1A
     D PACSEL          S              1A
     D PSecsSel        S             10A
     D PFOTRANSEL      S             20A
     D PTMESTPSEL      S             26Z

     D PAmendOk        S              1A
     D PPrCpn          S              1A
     D PNMDP           S              1P 0
     D PVLDP           S              1P 0
     D PResetFld       S              1A

     D PReDsp          S              1A
     D PLCPN           S              6A
     D PNCD            S              6A
     D POthInf         S            156A
     D POSESN          S             10A
     D PPOldSecDtl     S              1A
     D PINNR           S              3A                                                    AR996842
      *
      ** Parameters for WN0010
     D PWPGM           S             10A   INZ('SESECSRPR')
     D PWKEY           S              2A
     D PWACTION        S              1A
     D PWRTN           S              7A
     D PWSPARE         S            256A
      *
      ** Incoming and Current data
     D PIncData        S           2000A
     D PCurData        S           2000A
      *
      ** Parameters for AOSARDR0
     D PRTCD           S              7A
     D POPTN           S              7A
     D PSARD           S              6A
      *
      ** Work variables
     D WSCRN           S              1A
     D WOScrn          S              1A                                                      218563
     D WSndS2          S              1A
     D WSndS3          S              1A
     D WSndS5          S              1A                                                      CAS006
     D WDDSESN         S             10A
     D WSUBSE1         S              1A
     D WSUBSE2         S              1A
     D WSUBSE3         S              1A
     D WSUBSE4         S              1A                                                      CAS006
     D WSUBSE5         S              1A                                                      CAS006
     D WREDISPLAY      S              1A
     D WISSA1          S             11P 0
      *
     D KABFIELDID      S                   LIKE(ABFIELDID)
      *
      ** Function keys
     D PEINKE          S              1A
     D PEINKF          S              1A
     D PEINKG          S              1A
     D PEINKH          S              1A
     D PEINKI          S              1A                                                      CSE031
     D PEINKJ          S              1A
     D PEINKL          S              1A
     D PEINKP          S              1A
     D PINKC           S              1A
     D PINKE           S              1A
     D PINKF           S              1A
     D PINKG           S              1A
     D PINKH           S              1A
     D PINKI           S              1A                                                      CSE031
     D PINKJ           S              1A
     D PINKL           S              1A
     D PINKP           S              1A
      *
      ** SAR fields
     D CSE005          S              1A
     D CSE007          S              1A
     D CSE011          S              1A
     D CEU017          S              1A
     D CEU018          S              1A
     D S01401          S              1A
     D S01511          S              1A
     D CSE023          S              1A                                        CSE023
     D CSE031          S              1A                                                      CSE031
     D CSE065          S              1A                                                      CSE065
     D CSE071          S              1A                                                     BUG9530
      * Market Data Feed                                                                      CSD006
     D CSD006          S              1A                                                      CSD006
                                                                                              CSD006
      * Midas APIs Sec Prices                                                                 CAP060
     D CAP060          S              1A                                                      CAP060
                                                                                              CAP060
      ** Automatic Exchange of Information                                                    CGL032
     D CGL032          S              1A                                                      CGL032
                                                                                              CGL032
      ** Taxation on Savings Income                                                           CGL031
     D CGL031          S              1A                                                      CGL031
                                                                                              CGL031
     D CSC011          S              1A                                                      CSC011
     D CAS006          S              1A   INZ('N')                                           CAS006
     D WkDate          S              5  0                                                    CSC011
     D WkNext          S              5  0                                                    CSC011
                                                                                              CSC011
     D KMsgType        S              8A                                                      CSC011
     D KFrntOffID      S             20A                                                      CSC011
     D KTimeStamp      S               Z                                                      CSC011
     D PParmLink       S              1A                                                      CSC011
                                                                                              CGL014
     D CGL014          S              1                                                       CGL014
                                                                                              CSE037
      * Countervalue rounding                                                                 CSE037
     D CSE037          S              1A                                                      CSE037
      *
      ** +--------------------------------------+
      ** ¦ /COPYs                               ¦
      ** ¦ ======                               ¦
      ** +--------------------------------------+
      *
      /COPY QWINDSRC,SESECSDTA
      *
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      *
      /COPY WNCPYSRC,SESECSR002
      *                                                                                       CER001
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CER001
      *                                                                                       CER001
      ** External data structures for Customer Details                                        CER001
      *                                                                                       CER001
      *                                                                                       CER001
      ** Data Structures                                                                      CER001
                                                                                              CSC022
     D CSC022          S              1A                                                      CSC022
                                                                                              CSC022
     D WCommitSkip     S              1A                                                      CSC022
      ** Commitment Skip Field                                                                CSC022
      *
      ** Switchable                                                                           CER001
      *                                                                                       CER001
     D ULX610          S              1A                                                      CER001
     D ULX004          S              1A                                                      CER001
     D ULX043          S              1A                                                      CER001
     D ULX046          S              1A                                                      CER001
      *                                                                                       CER001
      ** Others variable by CER001                                                            CER001
      *                                                                                       CER001
     D W0RTN           S              7A                                                      CER001
     D ACTN            S              1A                                                      CER001
     D WFIND           S              1A                                                      CER001
                                                                                              CER001
     D ZFIELD          S             16                                                       CER001
     D ZADEC           S              1P 0                                                    CER001
     D WLUXSCRN        S              1A                                                      CER001
     D PDTMST          S               Z                                                      CER001
     D DDACTNB         S                   LIKE(DDACTN)                                       CER001
                                                                                              CER001
      ** Field to ask for Guarantees to be maintained  (only on window,                       CER001
      ** not existing in the extension file)                                                  CER001
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      /COPY WNCPYSRC,SESECSR003
      *
      ** Browse Invalid security details.
      *
     C                   IF        WSCRN = 'B'
     C                   EXSR      SRScrn_B
     C                   ENDIF
      *
      /COPY WNCPYSRC,SESECSR004
      *
      ** Read Next Browse Subfile record.
      *
     C                   IF        WSCRN = 'R'
     C                   EXSR      SRRdNBrw
     C                   ENDIF
      *
      /COPY WNCPYSRC,SESECSR005
      *
      ** DO WHILE: Process 1st screen.
      *
     C                   DOW       WSCRN = '1'
     C                   EXSR      SRScrn_1
     C                   ENDDO
      *
      /COPY WNCPYSRC,SESECSR006
      *
      ** DO WHILE: Process 2nd screen.
      *
     C                   DOW       WSCRN = '2'
     C                   EXSR      SRScrn_2
     C                   ENDDO
      *
      /COPY WNCPYSRC,SESECSR007
      *                                                                                       CSE031
      ** DO WHILE screen: level 4 screen details.                                             CSE031
      *                                                                                       CSE031
     C                   DOW       WSCRN = '4'                                                CSE031
     C                   EXSR      SRScrn_4                                                   CSE031
     C                   ENDDO                                                                CSE031
                                                                                              CAS006
      ** DO WHILE Screen: Level 5 Screen Details.                                             CAS006
                                                                                              CAS006
     C                   DOW       WScrn = '5'                                                CAS006
     C                   EXSR      SRScrn_5                                                   CAS006
     C                   ENDDO                                                                CAS006
      *
      ** DO WHILE: Process 3rd screen.
      *
     C                   DOW       WSCRN = '3'
     C                   EXSR      SRScrn_3
     C                   ENDDO
      *                                                                                       CER001
      ** DO WHILE screen: Extension File processing                                           CER001
      *                                                                                       CER001
     C                   IF        WSCRN = 'L'                                                CER001
     C                   EXSR      SRSCRN_L                                                   CER001
     C                   ENDIF                                                                CER001
      *
      /COPY WNCPYSRC,SESECSR008
      *
      ** Process Window screen.
      *
     C                   IF        WSCRN = 'W'
     C                   EXSR      SRScrn_W
     C                   ENDIF
      *
      /COPY WNCPYSRC,SESECSR009
      *
      ** Process Confirmation screen.
      *
     C                   IF        WSCRN = 'F'
     C                   EXSR      SRScrn_F
     C                   ENDIF
      *
      /COPY WNCPYSRC,SESECSR010
      *
      ** Update files.
      *
     C                   IF        WSCRN = 'U'
     C                   EXSR      SRUpdate
     C                   ENDIF
      *
      /COPY WNCPYSRC,SESECSR011
      *
      ** Terminate program.
      *
     C                   IF        WSCRN = 'T'
     C                   MOVE      *ON           *INLR
     C                   ENDIF
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Hook to enable non-core subroutines to be included
      *
      /COPY WNCPYSRC,SESECSR012
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSCRN_B - Browse invalid security details                   *
      *                                                               *
      *****************************************************************
     C     SRScrn_B      BEGSR
      *
      ** Reset Read Next Browse Subfile Record indicator.
     C                   MOVE      *BLANK        PRDNB
      *
      ** Browse invalid security details.
     C                   CALLB     'SESECSRPB'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Build Subfile
     C                   PARM      'Y'           PBDSFL
      *
      ** Read Subfile Record
     C                   PARM      *BLANK        PRDSFL
      *
      ** Error in update of previous transaction
     C                   PARM                    PErrUp
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System Runday
     C                   PARM                    BJMRDT
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC
      *
      ** OUTPUT
      ** ======
      *
      ** Error Message
     C                   PARM                    PERRMS
      *
      ** Option Selected
     C                   PARM                    POPSEL
      *
      ** Action Selected
     C                   PARM                    PACSEL
      *
      ** Securities Selected
     C                   PARM                    PSecsSel
      *
      ** Front Office Transaction Id Selected
     C                   PARM                    PFOTRANSEL
      *
      ** Timestamp of Transaction Selected
     C                   PARM                    PTMESTPSEL
      *
      ** Function Key Enabled - F3
     C                   PARM      '0'           PINKC
                                                                                              CSC011
      ** Switchable feature CSC011                                                            CSC011
                                                                                              CSC011
     C                   PARM                    CSC011                                       CSC011
      *
      ** Reset Update Status of Previous Transaction flag.
      *
     C                   EVAL      PERRUP = *BLANK
      *
      ** If error occurred, set on external job switch U6.
      *
     C                   IF        PERRMS <> *BLANKS
     C                   MOVE      *ON           *INU6
     C                   ENDIF
      *
      ** Terminate program if F3 was taken in Browse screen or
      ** if error occurred.  Otherwise, read selected Browse
      ** Subfile record.
     C                   IF        PINKC = *ON OR
     C                             PERRMS <> *BLANKS
     C                   EXSR      SREndP
     C                   ELSE
     C                   EVAL      PRDNB = 'Y'
     C                   EVAL      WSCRN = 'R'
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRDNBRW - Read Next Browse Subfile Record                   *
      *                                                               *
      *****************************************************************
     C     SRRdNBrw      BEGSR
      *
      ** Read Next Browse Subfile record.
     C                   CALLB     'SESECSRPB'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Build Subfile
     C                   PARM      *BLANK        PBDSFL
      *
      ** Read Subfile Record
     C                   PARM      'Y'           PRDSFL
      *
      ** Error in update of previous transaction
     C                   PARM                    PErrUp
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System Runday
     C                   PARM                    BJMRDT
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC
      *
      ** OUTPUT
      ** ======
      *
      ** Error Message
     C                   PARM                    PERRMS
      *
      ** Option Selected
     C                   PARM                    POPSEL
      *
      ** Action Selected
     C                   PARM                    PACSEL
      *
      ** Securities Selected
     C                   PARM                    PSecsSel
      *
      ** Front Office Transaction Id Selected
     C                   PARM                    PFOTRANSEL
      *
      ** Timestamp of Transaction Selected
     C                   PARM                    PTMESTPSEL
      *
      ** Function Key Enabled - F3
     C                   PARM      '0'           PINKC
                                                                                              CSC011
      ** Switchable feature CSC011                                                            CSC011
                                                                                              CSC011
     C                   PARM                    CSC011                                       CSC011
      *
      ** Terminate program if F3 was taken within Invalid
      ** Transaction Deletion function.
     C                   IF        PINKC = *ON
     C                   EXSR      SREndP
     C                   GOTO      ERdNBrw
     C                   ENDIF
      *
      ** Display Browse screen if no invalid security read from subfile.
     C                   IF        POPSEL = *BLANK
     C                   EVAL      WSCRN = 'B'
     C                   GOTO      ERdNBrw
     C                   ENDIF
      *
      ** Clear security details in screen format from incoming transaction.
     C                   CLEAR                   NwSE1ScnFmt
     C                   CLEAR                   NwSE2ScnFmt
     C                   CLEAR                   NwSE3ScnFmt
     C                   CLEAR                   NwSE4ScnFmt                                  CAS006
     C                   CLEAR                   NwSE5ScnFmt                                  CAS006
      *
      ** Clear security details in screen format retrieved from file.
     C                   CLEAR                   CrSE1ScnFmt
     C                   CLEAR                   CrSE2ScnFmt
     C                   CLEAR                   CrSE3ScnFmt
     C                   CLEAR                   CrSE4ScnFmt                                  CAS006
     C                   CLEAR                   CrSE5ScnFmt                                  CAS006
      *
      ** Initialise work variables.
     C                   EVAL      WSndS2 = *BLANK
     C                   EVAL      WSndS3 = *BLANK
      *
      ** Validate action code and security shortname and retrieve
      ** security details.
     C                   EVAL      DDACTN = PACSEL
     C                   EVAL      DDSESN = PSecsSel
     C                   EVAL      PFOTRID = PFOTRANSEL
      *
      ** If Insert, set Retrieve Mode to '*FRONT' (Access using Front Office
      ** Id).  Otherwise, if not Insert and Midas security shortname is present,
      ** set Retrieve Mode to blank (Access using Midas security shortname).
     C     DDACTN        IFEQ      'I'

     C                   MOVEL     '*FRONT'      PMode

     C                   ELSE

     C     DDSESN        IFEQ      *BLANK
     C                   MOVEL     '*FRONT'      PMode
     C                   ELSE
     C                   MOVEL     *BLANKS       PMode
     C                   ENDIF

     C                   ENDIF

     C                   EXSR      SRRtvSecty
      *                                                                                       CER001
      ** Retrieve record in extension file if switchable is on                                CER001
      *                                                                                       CER001
     C                   IF        ULX610  = 'Y'                                              CER001
     C                   EXSR      SRRTVLUX                                                   CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      *
      ** For the rest of the processing, set Mode of Operation
      ** to '*RPR  ' for the other modules to process the
      ** transaction as coming from the repair function.
     C                   EVAL      PMode = '*RPR  '
      *
      ** Move security details retrieved from the master database file
      ** into the update file record.  If no record has been retrieved
      ** (like in Insert), fields contain intial values.
     C**********         MOVEL     CrSEFilFmt    NwSEFilFmt                                   CSE065
     C**********         MOVEL     CrSEFilFmt1   NwSEFilFmt1                          CSE065 BUG9529
     C                   MOVEL     CrSEFilFmt    NwSEFilFmt                                  BUG9529
      *                                                                                       CSE065
     C**********         IF        CSE065 = 'Y'                                       CSE065 BUG9529
     C**********         Z-ADD     ALDT          S1ALDT                               CSE065 BUG9529
     C**********         ELSE                                                         CSE065 BUG9529
     C**********         Z-ADD     *ZEROS        S1ALDT                               CSE065 BUG9529
     C**********         ENDIF                                                        CSE065 BUG9529
      *
      ** If original security details were retrieved, convert security
      ** details from file to screen format.
      ** format.
     C                   IF        DDACTN <> 'I' AND
     C                             RECI <> *BLANK

     C                   EXSR      SRCvtSecty
      *
      ** Save security shortname retrieved from file.
     C                   EVAL      WDDSESN = DDSESN
      *
     C                   ENDIF
      *
      ** Access invalid security details file with Timestamp and
      ** Front Office Transaction Id.
     C     ZATRNKX0      CHAIN     SEISECSL0                          99
      *
      ** If original security details were retrieved, retore the
      ** security shortname retrieved from file.
     C                   IF        DDACTN <> 'I' AND
     C                             RECI <> *BLANK
     C                   EVAL      DDSESN = WDDSESN
     C                   ENDIF
      *
      ** If Action is Enquire or Delete, overwrite details from
      ** invalid security details file with the details retrieved
      ** from the master database file.
     C                   IF        DDACTN = 'E' AND RECI <> *BLANK OR
     C                             DDACTN = 'D' AND RECI <> *BLANK
     C                   MOVE      CrSE1ScnFmt   NwSE1ScnFmt
     C                   MOVE      CrSE2ScnFmt   NwSE2ScnFmt
     C                   MOVE      CrSE3ScnFmt   NwSE3ScnFmt
     C                   MOVE      CrSE4ScnFmt   NwSE4ScnFmt                                  CAS006
     C                   MOVE      CrSE5ScnFmt   NwSE5ScnFmt                                  CAS006
     C                   ENDIF
      *
      ** Action is amend and original security details were retrieved.
     C                   IF        DDACTN = 'A' AND RECI <> *BLANK
      *
      ** Check for the existence of the replacement character; if this is
      ** used, only the changed data has been sent, and all occurrences of
      ** the replacement character must be replaced with the corresponding
      ** character from the original transaction.
     C                   IF        GHSUBS <> *BLANK

     C     GHSUBS        SCAN      NwSE1ScnFmt                            99
     C                   IF        *IN99 = *ON
     C                   MOVE      'Y'           WSUBSE1
     C                   ELSE
     C                   MOVE      'N'           WSUBSE1
     C                   ENDIF

     C     GHSUBS        SCAN      NwSE2ScnFmt                            99
     C                   IF        *IN99 = *ON
     C                   MOVE      'Y'           WSUBSE2
     C                   ELSE
     C                   MOVE      'N'           WSUBSE2
     C                   ENDIF

     C     GHSUBS        SCAN      NwSE3ScnFmt                            99
     C                   IF        *IN99 = *ON
     C                   MOVE      'Y'           WSUBSE3
     C                   ELSE
     C                   MOVE      'N'           WSUBSE3
     C                   ENDIF
                                                                                              CAS006
     C     GHSUBS        SCAN      NwSE4ScnFmt                            99                  CAS006
     C                   IF        *IN99 = *ON                                                CAS006
     C                   MOVE      'Y'           WSUBSE4                                      CAS006
     C                   ELSE                                                                 CAS006
     C                   MOVE      'N'           WSUBSE4                                      CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C     GHSUBS        SCAN      NwSE5ScnFmt                            99                  CAS006
     C                   IF        *IN99 = *ON                                                CAS006
     C                   MOVE      'Y'           WSUBSE5                                      CAS006
     C                   ELSE                                                                 CAS006
     C                   MOVE      'N'           WSUBSE5                                      CAS006
     C                   ENDIF                                                                CAS006
      *
      ** Substitution character is present in the incoming transaction.
     C                   IF        WSUBSE1 = 'Y' OR
     C                             WSUBSE2 = 'Y' OR
     C**********                   WSUBSE3 = 'Y'                                              CAS006
     C                             WSUBSE3 = 'Y' OR                                           CAS006
     C                             WSUBSE4 = 'Y' OR                                           CAS006
     C                             WSUBSE5 = 'Y'                                              CAS006
      *
      ** Do data substitution.
     C                   EXSR      SRDtaSubs

     C                   ENDIF

     C                   ENDIF

     C                   ENDIF
      *
      ** If errors exist for action code or security shortname,
      ** blank out Action Code so input cannot proceed.
     C                   IF        OKACTN = 'N' OR OKSESN = 'N'
     C                   EVAL      DDACTN = *BLANK
     C                   ENDIF
      *
      ** Save screen details.
     C                   MOVEL     NwSE1ScnFmt   NwSE1ScnFmx
     C                   MOVEL     NwSE2ScnFmt   NwSE2ScnFmx
     C                   MOVEL     NwSE3ScnFmt   NwSE3ScnFmx
     C                   MOVEL     NwSE4ScnFmt   NwSE4ScnFmx                                  CAS006
     C                   MOVEL     NwSE5ScnFmt   NwSE5ScnFmx                                  CAS006
      *
      ** Send the security details validation error messages
      ** to 1st screen.
     C                   EXSR      SRSndM1
      *
      ** Display 1st screen.
     C                   EVAL      WSCRN = '1'

     C     ERdNBrw       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSCRN_1 - Process 1st screen                                *
      *                                                               *
      *****************************************************************
     C     SRScrn_1      BEGSR
      *
      ** If Action Code is Insert or Amend and Option selected is 'U',
      ** enable Detail fields on 1st screen (all fields on 1st screen
      ** except Initial screen fields: Action Code, Security Shortname).
      ** Also, enable F5=Refresh.
     C                   IF        DDACTN = 'I' AND POPSEL = 'U' OR
     C                             DDACTN = 'A' AND POPSEL = 'U'
     C                   EVAL      PEDTFLD = 'Y'
     C                   EVAL      PEINKE = 'Y'
     C                   ELSE
     C                   EVAL      PEDTFLD = 'N'
     C                   EVAL      PEINKE = 'N'
     C                   ENDIF
      *
      ** If Action is Delete and Option selected is 'U',
      ** enable F10=Delete.
     C                   IF        DDACTN = 'D' AND POPSEL = 'U'
     C                   EVAL      PEINKJ = 'Y'
     C                   ELSE
     C                   EVAL      PEINKJ = 'N'
     C                   ENDIF
      *
      ** Process defaulting of 1st screen details before going to 1st screen.
      *
     C                   EXSR      SRDefScn1
      *
      ** Display 1st screen.
     C                   CALLB     'SESECS1DP'
      *                             =========
      *
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Security 1st screen details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** Securities retrieved from file - file format
     C                   PARM                    CrSEFilFmt
      *
      ** Enable Detail Fields Indicator
      ** Enable Key Fields Indicator
     C                   PARM                    PEDtFld
     C                   PARM      'N'           PEKyFld
      *
      ** Enable Function Keys
      ** KE = Command Key 05 = Refresh
      ** KG = Command Key 07 = Read Previous
      ** KH = Command Key 08 = Read Next
      ** KJ = Command Key 10 = Delete
      ** KL = Command Key 12 = Cancel
      ** KP = Command Key 15 = Browse
     C                   PARM                    PEINKE
     C                   PARM      'N'           PEINKG
     C                   PARM      'N'           PEINKH
     C                   PARM                    PEINKJ
     C                   PARM      'Y'           PEINKL
     C                   PARM      'N'           PEINKP
      *
      ** Security 1st screen error indicators
     C                   PARM                    SEESEC1
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Warning fields/message Ids/message data (arrays) from/to
      ** caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Write Screen with No Read Indicator
     C                   PARM      'N'           WriteOnly
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System run date
     C                   PARM                    BJMRDT
      *
      ** SDGELR - Midas-Plato Interface
     C                   PARM                    BGN2ST
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** EMU Securities Decimals on Nominals
     C                   PARM                    CEU018
      *
      ** MT5xx Message Generation
     C                   PARM                    S01401
      *                                                                                       CSD006
      ** Market Data Feed on?                                                                 CSD006
     C                   PARM                    CSD006                                       CSD006
                                                                                              CGL032
      ** Automatic Exchange of Information                                                    CGL032
                                                                                              CGL032
     C                   PARM                    CGL032                                       CGL032
      *
      ** OUTPUT
      ** ======
      *
      ** Function Keys Enabled
      ** KC = Command Key 03 = Exit
      ** KE = Command Key 05 = Refresh
      ** KG = Command Key 07 = Read Previous
      ** KH = Command Key 08 = Read Next
      ** KJ = Command Key 10 = Delete
      ** KL = Command Key 12 = Cancel
      ** KP = Command Key 15 = Browse
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKE
     C                   PARM      '0'           PINKG
     C                   PARM      '0'           PINKH
     C                   PARM      '0'           PINKJ
     C                   PARM      '0'           PINKL
     C                   PARM      '0'           PINKP
      *                                                                                       192054
      ** Private Banking                                                                      192054
      *                                                                                       192054
     C                   PARM                    BGN4ST                                       192054
      *
      ** Save Warning Message Ids array of 1st screen.
     C                   MOVEA     WMsgIDArr     WPrvWarnAr
      *
      ** Reset error fields.
     C                   EXSR      SRResetErr
      *
     C                   SELECT
      *
      ** F3 - end program.
     C                   WHEN      PINKC = *ON
     C                   EXSR      SREndP
      *
      ** F5 - refresh 1st screen.
     C                   WHEN      PINKE = *ON
     C                   EVAL      NwSE1ScnFmt = NwSE1ScnFmx
     C                   EVAL      SEESEC1 = SEESEC1x
     C                   EVAL      FldNameArr = FldNameAr1
     C                   EVAL      MsgIdArr = MsgIdAr1
     C                   EVAL      MsgDtaArr = MsgDtaAr1
     C                   EVAL      IDx = ID1
      *
      ** F10 - delete record.  Proceed to update of files.
     C                   WHEN      PINKJ = *ON
     C                   EVAL      WSCRN = 'U'
      *
      ** F12 - cancel.  Read Next Subfile record or display
      ** Browse screen.
     C                   WHEN      PINKL = *ON

     C                   IF        PRDNB = 'Y'
     C                   EVAL      WSCRN = 'R'
     C                   ELSE
     C                   EVAL      WSCRN = 'B'
     C                   ENDIF
      *
      ** If Windows processing is on, clear any possible updates
      ** in Window function.
     C                   IF        BGWDPR = 'Y'
      *                                                                                       CSC022
     C                   If        (CSC022 <> 'Y')                                            CSC022
     C                   ROLBK
     C                   Else                                                                 CSC022
     C                   If        (WCommitSkip <> 'Y')                                       CSC022
     C                   ROLBK                                                                CSC022
     C                   Else                                                                 CSC022
     C                   Seton                                        U7U8                    CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CSC022
     C                   ENDIF
      *
      ** Enter key was pressed.
     C                   OTHER
      *
      ** If Action is Insert or Amend and Option selected is 'U',
      ** validate input to 1st screen.
     C                   IF        DDACTN = 'I' AND POPSEL = 'U' OR
     C                             DDACTN = 'A' AND POPSEL = 'U'
     C                   EXSR      SRVAL_1
     C                   GOTO      EScrn_1
     C                   ENDIF
      *
      ** If errors exist on 1st screen, no need to display
      ** succeeding screens.  Read Next Subfile record or
      ** display Browse screen instead.
     C                   IF        ID1 > 0
     C                   IF        PRDNB = 'Y'
     C                   EVAL      WSCRN = 'R'
     C                   ELSE
     C                   EVAL      WSCRN = 'B'
     C                   ENDIF
     C                   GOTO      EScrn_1
     C                   ENDIF
      *
      ** If Windows processing is on, display Window screen.
     C**********         IF        BGWDPR = 'Y'                                               218563

     C**********         EVAL      WSCRN = 'W'                                                218563

     C**********         ELSE                                                                 218563
      *
      ** If this has not been done yet, send security details
      ** validation error messages to 2nd screen.
     C                   IF        WSndS2 <> 'Y'
     C                   EXSR      SRSndM2
     C                   EVAL      WSndS2 = 'Y'
     C                   ELSE
     C                   MOVE      SEESEC2x      SEESEC2
     C                   MOVEA     FldNameAr2    FldNameArr
     C                   MOVEA     MsgIdAr2      MsgIdArr
     C                   MOVEA     MsgDtaAr2     MsgDtaArr
     C                   EVAL      IDx = ID2
     C                   ENDIF
      *
      ** Display 2nd screen.
     C                   EVAL      WSCRN = '2'
      *
      ** Process defaulting of 2nd screen details before going to 2nd screen.
     C                   EXSR      SRDefScn2

     C**********         ENDIF                                                                218563

     C                   ENDSL

     C     EScrn_1       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDefScn1 - Default fields in 1st screen                     *
      *                                                               *
      *****************************************************************
     C     SRDefScn1     BEGSR

     C                   CALLB     'SESECS1DT'
      *                             =========
      *
      ** INPUT
      ** =====
      *
      ** Securities retrieved from file - file format
     C                   PARM                    CrSEFilFmt
      *
      ** Investment type details
     C                   PARM                    PINVTPD
      *
      ** Redisplay screen indicator
     C                   PARM                    PReDsp
      *
      ** OUTPUT
      ** ======
      *
      ** Securities screen 1 details retrieved from file - screen format
     C                   PARM                    NwSE1ScnFmt

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVAL_1 - Validate input to 1st screen                       *
      *                                                               *
      *****************************************************************
     C     SRVal_1       BEGSR
      *
      ** If Action is Amend, validate whether non-amendable fields
      ** have been amended.
     C                   IF        DDACTN = 'A'

     C                   CALLB     'SESECS1MD'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Securities Screen 1 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** Securities Screen 1 details retrieved from file
      ** - screen format
     C                   PARM                    CrSE1ScnFmt
      *
      ** Securities retrieved from file - file format
     C                   PARM                    CrSEFilFmt
      *
      ** Investment processing type from PF/INVTPD
     C                   PARM                    F1PROT
      *
      ** Reset of Fields in Error Required (Y/N)
     C                   PARM      'Y'           PResetFld
      *
      ** STANDING DATA
      ** =============
      *
      ** SDMMOD - Midas-Plato Interface
     C                   PARM                    BGN2ST
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** EMU Securities Decimals on Nominals
     C                   PARM                    CEU018
      *
      ** MT5xx Message Generation
     C                   PARM                    S01401
      *
      ** Corporate Actions
     C                   PARM                    CSE007
      *
      ** EMU Securities Redenomination
     C                   PARM                    CEU017
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    IDx
      *
      ** Securities Screen 1 error indicators
     C                   PARM                    SEESEC1
      *
      ** OK Amendments field
     C                   PARM                    PAmendOK
      *                                                                                       192054
      ** Private Banking                                                                      192054
      *                                                                                       192054
     C                   PARM                    BGN4ST                                       192054
      *
     C                   ENDIF
      *
      ** Validate detail fields on 1st screen.
     C                   CALLB     'SESECS1VL'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
     C                   PARM                    PMode
      *
      ** Response Mode
     C                   PARM                    PResponse
      *
      ** Securities screen 1 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** Securities screen 1 details retrieved from file
      ** - screen format
     C                   PARM                    CrSE1ScnFmt
      *
      ** Securities retrieved from file - file format
     C                   PARM                    CrSEFilFmt
      *
      ** STANDING DATA
      ** =============
      *
      ** SDMMOD - Private banking
     C                   PARM                    BGN4ST
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Securities redenomination
     C                   PARM                    CEU017
      *
      ** Decimals on nominals
     C                   PARM                    CEU018
      *
      ** Corporate actions
     C                   PARM                    CSE007
      *
      ** Duplicate security code check
     C                   PARM                    CSE011
      *
      ** MT5xx message generation
     C                   PARM                    S01401
      *
      ** Market migration
     C                   PARM                    S01511
      *                                                                                       CSD006
      ** Market Data Feed                                                                     CSD006
     C                   PARM                    CSD006                                       CSD006
      *                                                                                       CAP060
      ** Midas APIs Sec Prices                                                                CAP060
     C                   PARM                    CAP060                                       CAP060
                                                                                              CGL032
      ** Automatic Exchange of Information                                                    CGL032
                                                                                              CGL032
     C                   PARM                    CGL032                                       CGL032
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      ** Warning flds/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    WIdx
      *
      ** Securities screen 1 error indicators
     C                   PARM                    SEESEC1
      *
      ** Securities screen 2 error indicators
     C                   PARM                    SEESEC2
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Externally described DS for investment types - output parameter
     C                   PARM                    PINVTPD
      *
      ** Nominal currency's no. of decimal places
     C                   PARM                    PNMDP
      *
      ** Value currency's no. of decimal places
     C                   PARM                    PVLDP
      *
      ** Redisplay screen indicator
     C                   PARM      'N'           PReDsp

     C                   EVAL      WRedisplay = *BLANK
      *
      ** If no errors occurred during validation of fields on 1st
      ** screen, check if there are warnings which have not been
      ** displayed yet.
     C                   IF        IDx = 0
      *
     C                   Z-ADD     1             WIx
      *
     C     WIx           DOWLE     WIDx
     C     WRedisplay    ANDEQ     *BLANK
     C                   IF        WMsgIdArr(WIx) <> WPrvWarnAr(WIx)
     C                   EVAL      WRedisplay = 'Y'
     C                   ELSE
     C                   EVAL      WIx =WIx + 1
     C                   ENDIF
     C                   ENDDO

     C                   IF        WRedisplay <> 'Y'
     C                   EXSR      SRResetErr
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Redisplay 1st screen if there are errors or if there
      ** are warnings which have not been displayed yet.
     C                   IF        IDx <> 0 OR WRedisplay = 'Y' OR
     C                             PReDsp = 'Y'
     C                   GOTO      EVal_1
     C                   ENDIF
      **********                                                                              218563
      ***If*Windows*processing*is*on,*display*Window*screen.***********                       218563
     C**********         IF        BGWDPR = 'Y'                                               218563

     C**********         EVAL      WSCRN = 'W'                                                218563

     C**********         ELSE                                                                 218563
      *
      ** If this has not been done yet, send security details
      ** validation error messages to 2nd screen.
     C                   IF        WSndS2 <> 'Y'
     C                   EXSR      SRSndM2
     C                   EVAL      WSndS2 = 'Y'
     C                   ELSE
     C                   MOVE      SEESEC2x      SEESEC2
     C                   MOVEA     FldNameAr2    FldNameArr
     C                   MOVEA     MsgIdAr2      MsgIdArr
     C                   MOVEA     MsgDtaAr2     MsgDtaArr
     C                   EVAL      IDx = ID2
     C                   ENDIF
      *
      ** Display 2nd screen.
     C                   EVAL      WSCRN = '2'
      *
      ** Process defaulting of 2nd screen details before going to 2nd screen.
     C                   EXSR      SRDefScn2

     C**********         ENDIF                                                                218563

     C     EVal_1        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSCRN_2 - Process 2nd screen                                *
      *                                                               *
      *****************************************************************
     C     SRScrn_2      BEGSR
      *
      ** If Action Code is Insert or Amend and Option selected is 'U',
      ** enable Detail fields on 2nd screen.
      ** Also, enable F5=Refresh.
      *
     C                   IF        DDACTN = 'I' AND POPSEL = 'U' OR
     C                             DDACTN = 'A' AND POPSEL = 'U'
     C                   EVAL      PEDTFLD = 'Y'
     C                   EVAL      PEINKE = 'Y'
     C                   ELSE
     C                   EVAL      PEDTFLD = 'N'
     C                   EVAL      PEINKE = 'N'
     C                   ENDIF
      *                                                                                       CSE031
      ** Only enable F9 (Additional Information) if CSE031 is ON and                          CSE031
      ** the processing type is 3 or 8.                                                       CSE031
      *                                                                                       CSE031
     C                   IF        CSE031  = 'Y'                                              CSE031
     C                   IF        F1PROT = '3' OR F1PROT = '8'                               CSE031
     C                   EVAL      PEINKI  = 'Y'                                              CSE031
     C                   ELSE                                                                 CSE031
     C                   EVAL      PEINKI  = 'N'                                              CSE031
     C                   ENDIF                                                                CSE031
     C                   ENDIF                                                                CSE031
      *
      ** Display 2nd screen.
      *
     C                   CALLB     'SESECS2DP'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Security 2nd screen details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE2ScnFmt
      *
      ** Security retrieved from file - file format
     C                   PARM                    CrSEFilFmt
      *
      ** Investment type details
     C                   PARM                    PINVTPD
      *
      ** Fields for display only
     C                   PARM                    POutFlds
      *
      ** Last Coupon Date
     C                   PARM                    PLCPN
      *
      ** Next Coupon Date
     C                   PARM                    PNCD
      *
      ** Enable Detail Fields Indicator
     C                   PARM                    PEDtFld
      *
      ** Securities Screen 1 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** Enable Function Keys
      ** KE = Command Key 05 = Refresh
      ** KF = Command Key 06 = Initial Screen
      ** KG = Command Key 07 = Read Previous
      ** KH = Command Key 08 = Read Next
      ** KL = Command Key 12 = Cancel
      ** KP = Command Key 15 = Browse
      ** KI = Command Key 09 = Additional Information                                         CSE031
     C                   PARM                    PEINKE
     C                   PARM      'N'           PEINKF
     C                   PARM      'N'           PEINKG
     C                   PARM      'N'           PEINKH
     C                   PARM      'Y'           PEINKL
     C                   PARM      'N'           PEINKP
     C                   PARM                    PEINKI                                       CSE031
      *
      ** Security 2nd screen error indicators
     C                   PARM                    SEESEC2
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Warning fields/message Ids/message data (arrays) from/to
      ** caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Write Screen with No Read Indicator
     C                   PARM      'N'           WriteOnly
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System run date
     C                   PARM                    BJMRDT
      *
      ** SDMMOD - Risk Manangement
     C                   PARM                    BGRKMG
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Effect of holidays on frn cpuon dates
     C                   PARM                    CSE005
      *
      ** Corporate Actions
     C                   PARM                    CSE007
      *
      ** EMU Securities Redenomination
     C                   PARM                    CEU017
      *                                                                                       CSE031
      ** Coupon Fixing for Floating Rate Notes                                                CSE031
     C                   PARM                    CSE031                                       CSE031
      *                                                                                       CSE037
      ** Countervalue rounding                                                                CSE037
     C                   PARM                    CSE037                                       CSE037
      *
      ** OUTPUT
      ** ======
      *
      ** Function Keys Enabled
      ** KC = Command Key 03 = Exit
      ** KE = Command Key 05 = Refresh
      ** KF = Command Key 06 = Initial Screen
      ** KG = Command Key 07 = Read Previous
      ** KH = Command Key 08 = Read Next
      ** KL = Command Key 12 = Cancel
      ** KP = Command Key 15 = Browse
      ** KI = Command Key 09 = Additional Information                                         CSE031
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKE
     C                   PARM      '0'           PINKF
     C                   PARM      '0'           PINKG
     C                   PARM      '0'           PINKH
     C                   PARM      '0'           PINKL
     C                   PARM      '0'           PINKP
     C                   PARM                    PINKI                                        CSE031
      *
      ** Save Warning Message Ids array of 2nd screen.
     C                   MOVEA     WMsgIDArr     WPrvWarnAr
      *
      ** Reset error fields.
     C                   EXSR      SRResetErr

     C                   SELECT
      *
      ** F3 - end program.
     C                   WHEN      PINKC = *ON
     C                   EXSR      SREndP
      *
      ** F5 - refresh 2nd screen.
     C                   WHEN      PINKE = *ON
     C                   EVAL      NwSE2ScnFmt = NwSE2ScnFmx
     C                   EVAL      SEESEC2 = SEESEC2x
     C                   EVAL      FldNameArr = FldNameAr2
     C                   EVAL      MsgIdArr = MsgIdAr2
     C                   EVAL      MsgDtaArr = MsgDtaAr2
     C                   EVAL      IDx = ID2
      *                                                                                       CSE031
      ** F9 - Additional Information - Display 4th Screen.                                    CSE031
     C                   WHEN      PINKI = *ON                                                CSE031
      *                                                                                       CSE031
     C                   EVAL      NwSeFilFmtOld = NwSEFilFmt                                 CSE031
     C                   EVAL      WSCRN = '4'                                                CSE031
      *
      ** F12 - cancel.  Display 1st screen.
     C                   WHEN      PINKL = *ON
     C                   EVAL      NwSE2ScnFmt = NwSE2ScnFmx
     C                   EVAL      WSCRN = '1'
      *
      ** Enter key was pressed.
     C                   OTHER
      *
      ** If Action is Insert or Amend and Option selected is 'U',
      ** validate input to 2nd screen.
     C                   IF        DDACTN = 'I' AND POPSEL = 'U' OR
     C                             DDACTN = 'A' AND POPSEL = 'U'
     C                   EXSR      SRVAL_2
     C                   GOTO      EScrn_2
     C                   ENDIF
      *
      ** If errors exist on 2nd screen, no need to display 3rd screen.
     C                   IF        ID2 > 0
     C                   IF        PRDNB = 'Y'
     C                   EVAL      WSCRN = 'R'
     C                   ELSE
     C                   EVAL      WSCRN = 'B'
     C                   ENDIF
     C                   GOTO      EScrn_2
     C                   ENDIF
                                                                                              CAS006
      ** Send Security Details validation error messages to the 5th                           CAS006
      ** Screen if necessary.                                                                 CAS006
                                                                                              CAS006
     C                   IF        WSndS5 <> 'Y'                                              CAS006
     C                   EXSR      SRSndM5                                                    CAS006
     C                   EVAL      WSndS5 = 'Y'                                               CAS006
     C                   ELSE                                                                 CAS006
     C                   MOVE      SEESEC5x      SEESEC5                                      CAS006
     C                   MOVEA     FldNameAr5    FldNameArr                                   CAS006
     C                   MOVEA     MsgIdAr5      MsgIdArr                                     CAS006
     C                   MOVEA     MsgDtaAr5     MsgDtaArr                                    CAS006
     C                   EVAL      IDx = ID5                                                  CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Display the 5th Screen.                                                              CAS006
                                                                                              CAS006
     C                   EVAL      WScrn = '5'                                                CAS006
      *
      ***If*New*Issue*is*'Y'*or*Private*Banking*is*installed,*display**                       CAS006
      ***third*screen.*************************************************                       CAS006
      *
     C**********         IF        DDNISS = 'Y' OR BGN4ST = 'Y'                               CAS006
      *
      ***If*this*has*not*been*done*yet,*send*security*details**********                       CAS006
      ***validation*error*messages*to*3rd*screen.**********************                       CAS006
     C**********         IF        WSndS3 <> 'Y'                                              CAS006
     C**********         EXSR      SRSndM3                                                    CAS006
     C**********         EVAL      WSndS3 = 'Y'                                               CAS006
     C**********         ELSE                                                                 CAS006
     C**********         MOVE      SEESEC3x      SEESEC3                                      CAS006
     C**********         MOVEA     FldNameAr3    FldNameArr                                   CAS006
     C**********         MOVEA     MsgIdAr3      MsgIdArr                                     CAS006
     C**********         MOVEA     MsgDtaAr3     MsgDtaArr                                    CAS006
     C**********         EVAL      IDx = ID3                                                  CAS006
     C**********         ENDIF                                                                CAS006
      *
      ***Display*3rd*screen.*******************************************                       CAS006
     C**********         EVAL      WSCRN = '3'                                                CAS006
      *
      ***Setup*issue*amount*for*3rd*screen*if*risk*management*module*is                       CAS006
      ***installed*and*early*rapayment*indicator*is*'Y'.**Value*of*this                       CAS006
      ***field*depends*on*previous*screen.*****************************                       CAS006
     C**********         IF        BGRKMG = 'Y' AND DDERPY ='Y'                               CAS006
     C**********         EVAL      DDISA2 = DDISA1                                            CAS006
     C**********         ENDIF                                                                CAS006

     C**********         ENDIF                                                                CAS006

     C                   ENDSL

     C     EScrn_2       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVAL_2 - Validate input 2nd screen                          *
      *                                                               *
      *****************************************************************
     C     SRVal_2       BEGSR
      *
      ** If Action is Amend, validate whether non-amendable fields
      ** have been amended.
     C                   IF        DDACTN = 'A'

     C                   CALLB     'SESECS2MD'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Securities Screen 2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE2ScnFmt
      *
      ** Securities Screen 2 details retrieved from file
      ** - screen format
     C                   PARM                    CrSE2ScnFmt
      *
      ** Securities retrieved from file - file format
     C                   PARM                    CrSEFilFmt
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Investment processing type from PF/INVTPD
     C                   PARM                    F1PROT
      *
      ** Reset of Fields in Error Required (Y/N)
     C                   PARM      'Y'           PResetFld
      *
      ** STANDING DATA
      ** =============
      *
      ** SDMMOD - Risk Management
     C                   PARM                    BGRKMG
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Effect of holidays on FRN coupon dates
     C                   PARM                    CSE005
      *
      ** Corporate Actions
     C                   PARM                    CSE007
      *
      ** EMU Securities Redenomination
     C                   PARM                    CEU017
      *                                                                                       CSE031
      ** Coupon Fixing for Floating Rate Notes.                                               CSE031
     C                   PARM                    CSE031                                       CSE031
      *                                                                                      BUG9530
      ** Multiple Holidays                                                                   BUG9530
      *                                                                                      BUG9530
     C                   PARM                    CSE071                                      BUG9530
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message Ids/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    IDx
      *
      ** Securities Screen 2 error indicators
     C                   PARM                    SEESEC2
      *
      ** OK Amendments field
     C                   PARM                    PAmendOK
      *
      ** Protect Coupon Rate/Inds Indicator
     C                   PARM                    PPrCpn

     C                   ENDIF
      *
      ** Validate Detail fields on 2nd screen.
     C                   CALLB     'SESECS2VL'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
     C                   PARM                    PMode
      *
      ** Response Mode
     C                   PARM                    PResponse
      *
      ** Securities screen 1 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** Securities screen 1 details retrieved from file
      ** - screen format
     C                   PARM                    CrSE1ScnFmt
      *
      ** Securities screen 2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE2ScnFmt
      *
      ** Security screen 2 details retrieved from file
      ** - screen format
     C                   PARM                    CrSE2ScnFmt
      *                                                                                      BUG9530
      ** Securities screen 6 details from incoming transaction                               BUG9530
      ** - screen format                                                                     BUG9530
     C                   PARM                    NwSE6ScnFmt                                 BUG9530
      *                                                                                      BUG9530
      ** Securities screen 6 details retrieved from file                                     BUG9530
      ** - screen format                                                                     BUG9530
     C                   PARM                    CrSE6ScnFmt                                 BUG9530
      *
      ** Securities retrieved from file - file format
     C                   PARM                    CrSEFilFmt
      *
      ** Processing type, from PF/INVTPD
     C                   PARM                    F1PROT
      *
      ** Settlement depot customer 1, from PF/INVTPD
     C                   PARM                    F1SDC1
      *
      ** Settlement depot customer 2, from PF/INVTPD
     C                   PARM                    F1SDC2
      *
      ** Settlement depot customer 3, from PF/INVTPD
     C                   PARM                    F1SDC3
      *
      ** Protect coupon rate/days
     C                   PARM                    PPrCpn
      *
      ** Nominal currency's decimal places
     C                   PARM                    PNmDp
      *
      ** Value currency's decimal places
     C                   PARM                    PVlDp
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - date format indicator
     C                   PARM                    BJDFIN
      *
      ** SDBANK - midas run date number
     C**********         PARM                    BJRDNB                                       CSC011
     C                   PARM                    WkDate                                       CSC011
      *
      ** SDBANK - date of next working day
     C**********         PARM                    BJDNWD                                       CSC011
     C                   PARM                    WkNext                                       CSC011
      *
      ** SDMMOD - interest risk management
     C                   PARM                    BGRKMG
      *
      ** SDSTRD - convertible indicator A/K
     C                   PARM                    BVCIAK
      *                                                                        183604
      ** SDMMOD - Private banking                                              183604
     C                   PARM                    BGN4ST                        183604
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Effect of holidays on FRN coupon dates
     C                   PARM                    CSE005
      *
      ** Corporate action
     C                   PARM                    CSE007
      *
      ** EMU securities redenomination
     C                   PARM                    CEU017
      *
      ** Duplicate security code check
     C                   PARM                    CSE011
      *                                                                                       CSE031
      ** Coupon Fixing for Floating Rate Notes.                                               CSE031
     C                   PARM                    CSE031                                       CSE031
      *                                                                                       CSE037
      ** Countervalue rounding                                                                CSE037
     C                   PARM                    CSE037                                       CSE037
      *                                                                                      BUG9530
      ** Multiple Holidays                                                                   BUG9530
     C                   PARM                    CSE071                                      BUG9530
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      ** Warning flds/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    WIdx
      *
      ** Securities screen 2 error indicators
     C                   PARM                    SEESEC2
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Redisplay screen indicator
     C                   PARM      'N'           PReDsp
      *
      ** Market Name
     C                   PARM                    WMKTN
      *
     C                   MOVEL     *BLANK        WRedisplay
      *
      ** If no errors occurred during validation of fields on 2nd screen,
      ** check if there are warnings which have not been displayed yet.
     C                   IF        IDx = 0

     C                   Z-ADD     1             WIx

     C     WIx           DOWLE     WIDx
     C     WRedisplay    ANDEQ     *BLANK
     C                   IF        WMsgIdArr(WIx) <> WPrvWarnAr(WIx)
     C                   EVAL      WRedisplay = 'Y'
     C                   ELSE
     C                   EVAL      WIx =WIx + 1
     C                   ENDIF
     C                   ENDDO

     C                   IF        WRedisplay <> 'Y'
     C                   EXSR      SRResetErr
     C                   ENDIF

     C                   ENDIF
      *
      ** Redisplay 2nd screen if there are errors or if there
      ** are warnings which have not been displayed yet.
     C                   IF        IDx <> 0 OR WRedisplay = 'Y' OR
     C                             PReDsp = 'Y'
     C                   GOTO      EVal_2
     C                   ENDIF
      *
      ** Save old values of data structure for file update, to be used
      ** later if a cancellation occurs.
      *
     C                   EVAL      NwSeFilFmtOld = NwSeFilFmt
                                                                                              CAS006
     C                   IF        WSndS5 <> 'Y'                                              CAS006
     C                   EXSR      SRSndM5                                                    CAS006
     C                   EVAL      WSndS5 = 'Y'                                               CAS006
     C                   ELSE                                                                 CAS006
     C                   MOVE      SEESEC5x      SEESEC5                                      CAS006
     C                   MOVEA     FldNameAr5    FldNameArr                                   CAS006
     C                   MOVEA     MsgIdAr5      MsgIdArr                                     CAS006
     C                   MOVEA     MsgDtaAr5     MsgDtaArr                                    CAS006
     C                   EVAL      IDx = ID5                                                  CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Display the 5th Screen.                                                              CAS006
                                                                                              CAS006
     C                   EVAL      WScrn = '5'                                                CAS006
      *
      ***Dispay*third*screen*if*New*Issue*is*'Y'*or*Private*Banking****                       CAS006
      ***is*installed.*************************************************                       CAS006
      *
     C**********         IF        DDNISS = 'Y' OR BGN4ST = 'Y'                               CAS006
      *
      ***If*this*has*not*been*done*yet,*send*security*details**********                       CAS006
      ***validation*error*messages*to*3rd*screen.**********************                       CAS006
     C**********         IF        WSndS3 <> 'Y'                                              CAS006
     C**********         EXSR      SRSndM3                                                    CAS006
     C**********         EVAL      WSndS3 = 'Y'                                               CAS006
     C**********         ELSE                                                                 CAS006
     C**********         MOVE      SEESEC3x      SEESEC3                                      CAS006
     C**********         MOVEA     FldNameAr3    FldNameArr                                   CAS006
     C**********         MOVEA     MsgIdAr3      MsgIdArr                                     CAS006
     C**********         MOVEA     MsgDtaAr3     MsgDtaArr                                    CAS006
     C**********         EVAL      IDx = ID3                                                  CAS006
     C**********         ENDIF                                                                CAS006
      *
      ***Display*3rd*screen.*******************************************                       CAS006
     C**********         EVAL      WSCRN = '3'                                                CAS006

     C**********         ELSE                                                                 CAS006
      *
      ***Else,*display*confirmation*screen.****************************                       CAS006
     C**********         EVAL      WSCRN = 'F'                                                CAS006

     C**********         ENDIF                                                                CAS006

     C     EVal_2        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDefScn2 - Default fields in 2nd screen                     *
      *                                                               *
      *****************************************************************
     C     SRDefScn2     BEGSR

     C                   CALLB     'SESECS2DT'
      *                             =========
      *
      ** INPUT
      ** =====
      *
      ** Security screen 1 details retrieved from file - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** Securities retrieved from file - file format
     C                   PARM                    CrSEFilFmt
      *
      ** Passed other information coming from link program
     C                   PARM      *BLANK        POthInf
      *
      ** Investment Types files
     C                   PARM                    PINVTPD
      *
      ** STANDING DATA
      ** =============
      *
      ** SDMMOD - Risk Management
     C                   PARM                    BGRKMG
      *                                                                                    222373
      ** SWITCHABLE FEATURES                                                               222373
      ** ===================                                                               222373
      *                                                                                    222373
      ** Coupon Fixing for Floating Rate Notes                                             222373
     C                   PARM                    CSE031                                    222373
      *
      ** OUTPUT
      ** ======
      *
      ** Security screen 2 details retrieved from file - screen format
     C                   PARM                    NwSE2ScnFmt
      *
      ** Security details for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Fields for display only
     C                   PARM                    POutFlds

     C                   ENDSR
      *****************************************************************                       CAS006
      /EJECT                                                                                  CAS006
      *****************************************************************                       CAS006
      *                                                               *                       CAS006
      *  SRVal_5 - Validate input to Screen 5.                        *                       CAS006
      *                                                               *                       CAS006
      *****************************************************************                       CAS006
     C     SRVal_5       BEGSR                                                                CAS006
                                                                                              CAS006
      ** If Action is Amend, validate whether non-amendable fields                            CAS006
      ** have been amended.                                                                   CAS006
                                                                                              CAS006
     C                   IF        DDACTN = 'A'                                               CAS006
                                                                                              CAS006
     C                   CALLB     'SESECS5MD'                                                CAS006
      *                  --------------------                                                 CAS006
                                                                                              CAS006
      ** Input Parameters                                                                     CAS006
      ** ================                                                                     CAS006
                                                                                              CAS006
      ** Return Code                                                                          CAS006
     C                   PARM                    RetCodeOut                                   CAS006
                                                                                              CAS006
      ** Securities Screen 5 Details From Incoming Transaction                                CAS006
      ** - Screen Format                                                                      CAS006
     C                   PARM                    NwSE5ScnFmt                                  CAS006
                                                                                              CAS006
      ** Securities Screen 5 Details Retrieved From File                                      CAS006
      ** - Screen Format                                                                      CAS006
     C                   PARM                    CrSE5ScnFmt                                  CAS006
                                                                                              CAS006
      ** Securities Details From Incoming Transaction - File Format                           CAS006
     C                   PARM                    NwSEFilFmt                                   CAS006
                                                                                              CAS006
      ** Securities Details Retrieved from File - File Format                                 CAS006
     C                   PARM                    CrSEFilFmt                                   CAS006
                                                                                              CAS006
      ** Investment Processing Type                                                           CAS006
     C                   PARM                    F1PROT                                       CAS006
                                                                                              CAS006
      ** Reset of Fields Flag                                                                 CAS006
     C                   PARM      'Y'           PResetFld                                    CAS006
                                                                                              CAS006
      ** Switchable Features:                                                                 CAS006
                                                                                              CAS006
      ** Hedge Accounting Phase B                                                             CAS006
     C                   PARM                    CAS006                                       CAS006
                                                                                              CAS006
      ** Output Parameters                                                                    CAS006
      ** =================                                                                    CAS006
                                                                                              CAS006
      ** Error Fields/Msg. IDs/Msg. Data (Arrays) From/To Caller                              CAS006
     C                   PARM                    FldNameArr                                   CAS006
     C                   PARM                    MsgIdArr                                     CAS006
     C                   PARM                    MsgDtaArr                                    CAS006
                                                                                              CAS006
      ** Error Array Index (3P0) From/To Caller                                               CAS006
     C                   PARM                    IdX                                          CAS006
                                                                                              CAS006
      ** Securities Screen 5 Error Indicators                                                 CAS006
     C                   PARM                    SEESEC5                                      CAS006
                                                                                              CAS006
      ** Amend OK Flag                                                                        CAS006
     C                   PARM                    PAmendOK                                     CAS006
                                                                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Validate input to the 5th Screen.                                                    CAS006
                                                                                              CAS006
     C                   CALLB     'SESECS5VL'                                                CAS006
      *                  --------------------                                                 CAS006
                                                                                              CAS006
      ** Input Parameters                                                                     CAS006
      ** ================                                                                     CAS006
                                                                                              CAS006
      ** Mode = '*FRONT' (Front Office Transaction Interface)                                 CAS006
      **      = '      ' (Not Front Office Transaction Interface)                             CAS006
      **      = '*RPR  ' (Repair Function)                                                    CAS006
      **      = '*SIN  ' (Screen Input Function)                                              CAS006
     C                   PARM                    PMode                                        CAS006
                                                                                              CAS006
      ** Response Mode                                                                        CAS006
     C                   PARM                    PResponse                                    CAS006
                                                                                              CAS006
      ** Securities Screen 1 Details From Incoming Transaction                                CAS006
      ** - Screen Format                                                                      CAS006
     C                   PARM                    NwSE1ScnFmt                                  CAS006
                                                                                              CAS006
      ** Securities Screen 1 Details Retrieved From File                                      CAS006
      ** - Screen Format                                                                      CAS006
     C                   PARM                    CrSE1ScnFmt                                  CAS006
                                                                                              CAS006
      ** Securities Screen 5 Details From Incoming Transaction                                CAS006
      ** - Screen Format                                                                      CAS006
     C                   PARM                    NwSE5ScnFmt                                  CAS006
                                                                                              CAS006
      ** Securities Screen 5 Details Retrieved From File                                      CAS006
      ** - Screen Format                                                                      CAS006
     C                   PARM                    CrSE5ScnFmt                                  CAS006
                                                                                              CAS006
      ** Securities Detail Retrieved From File - File Format                                  CAS006
     C                   PARM                    CrSEFilFmt                                   CAS006
                                                                                              CAS006
      ** Processing Type                                                                      CAS006
     C                   PARM                    F1PROT                                       CAS006
                                                                                              CAS006
      ** Switchable Features:                                                                 CAS006
                                                                                              CAS006
      ** Hedge Accounting Phase B                                                             CAS006
     C                   PARM                    CAS006                                       CAS006
                                                                                              CAS006
      ** Output Parameters                                                                    CAS006
      ** =================                                                                    CAS006
                                                                                              CAS006
      ** Error Fields/Msg. IDs/Msg. Data (Arrays) From/To Caller                              CAS006
     C                   PARM                    FldNameArr                                   CAS006
     C                   PARM                    MsgIdArr                                     CAS006
     C                   PARM                    MsgDtaArr                                    CAS006
                                                                                              CAS006
      ** Error Array Index (3P0) From/To Caller                                               CAS006
     C                   PARM                    IdX                                          CAS006
                                                                                              CAS006
      ** Warning Fields/Msg. IDs/Msg. Data (Arrays) From/To Caller                            CAS006
     C                   PARM                    WFldNamArr                                   CAS006
     C                   PARM                    WMsgIdArr                                    CAS006
     C                   PARM                    WMsgDtaArr                                   CAS006
                                                                                              CAS006
      ** Array Index (3P0) From/To Caller                                                     CAS006
     C                   PARM                    WIdX                                         CAS006
                                                                                              CAS006
      ** Securities Screen 5 Error Indicators                                                 CAS006
     C                   PARM                    SEESEC5                                      CAS006
                                                                                              CAS006
      ** Securities Details For File Update - File Format                                     CAS006
     C                   PARM                    NwSEFilFmt                                   CAS006
                                                                                              CAS006
      ** If no errors occurred during the validation phase, check if                          CAS006
      ** there are warnings which have not been displayed yet.                                CAS006
                                                                                              CAS006
     C                   EVAL      WRedisplay = *BLANK                                        CAS006
                                                                                              CAS006
     C                   IF        IdX = 0                                                    CAS006
                                                                                              CAS006
     C                   EVAL      WiX = 1                                                    CAS006
                                                                                              CAS006
     C                   DOW       WiX <= WIdX AND                                            CAS006
     C                             WRedisplay = *BLANK                                        CAS006
                                                                                              CAS006
     C                   IF        WMsgIdArr(WiX) <> WPrvWarnAr(WiX)                          CAS006
     C                   EVAL      WRedisplay = 'Y'                                           CAS006
     C                   ELSE                                                                 CAS006
     C                   EVAL      WiX = WiX + 1                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDDO                                                                CAS006
                                                                                              CAS006
     C                   IF        WRedisplay <> 'Y'                                          CAS006
     C                   EXSR      SRResetErr                                                 CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Redisplay the 5th Screen if there are errors or warnings                             CAS006
      ** which have not been displayed yet.                                                   CAS006
                                                                                              CAS006
     C                   IF        IdX <> 0 OR                                                CAS006
     C                             WRedisplay = 'Y'                                           CAS006
     C                   LEAVESR                                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Save the old values for file updates.                                                CAS006
                                                                                              CAS006
     C                   EVAL      NwSeFilFmtOld = NwSefilFmt                                 CAS006
                                                                                              CAS006
      ** If New Issue = 'Y' or Private Banking is enabled, display the                        CAS006
      ** 3rd Screen.                                                                          CAS006
                                                                                              CAS006
     C                   IF        DDNISS = 'Y' OR BGN4ST = 'Y'                               CAS006
                                                                                              CAS006
      ** Send the Security Details validation error messages to the                           CAS006
      ** 3rd Screen.                                                                          CAS006
                                                                                              CAS006
     C                   IF        WSndS3 <> 'Y'                                              CAS006
     C                   EXSR      SRSndM3                                                    CAS006
     C                   EVAL      WSndS3 = 'Y'                                               CAS006
     C                   ELSE                                                                 CAS006
     C                   MOVE      SEESEC3x      SEESEC3                                      CAS006
     C                   MOVEA     FldNameAr3    FldNameArr                                   CAS006
     C                   MOVEA     MsgIdAr3      MsgIdArr                                     CAS006
     C                   MOVEA     MsgDtaAr3     MsgDtaArr                                    CAS006
     C                   EVAL      IDx = ID3                                                  CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Display the 3rd Screen.                                                              CAS006
                                                                                              CAS006
     C                   EVAL      WScrn = '3'                                                CAS006
                                                                                              CAS006
     C                   ELSE                                                                 CAS006
                                                                                              CAS006
      ** Display the confirmation screen otherwise.                                           CAS006
                                                                                              CAS006
     C                   IF        ULX610  = 'Y'                                              CER001
     C                   EVAL      WSCRN   = 'L'                                              CER001
     C                   ELSE                                                                 CER001
     C                   EVAL      WScrn = 'F'                                                CAS006
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDSR                                                                CAS006
      *****************************************************************                       CAS006
      /EJECT                                                                                  CAS006
      *****************************************************************                       CAS006
      *                                                               *                       CAS006
      *  SRScrn_5 - Process Screen 5 (Screen 2 Extension)             *                       CAS006
      *                                                               *                       CAS006
      *****************************************************************                       CAS006
     C     SRScrn_5      BEGSR                                                                CAS006
                                                                                              CAS006
      ** If Action Code = 'I' or 'A' and the Option selected is 'U',                          CAS006
      ** enable the detail fields and F05 (Refresh).                                          CAS006
                                                                                              CAS006
     C                   IF        DDACTN = 'I' AND POPSEL = 'U' OR                           CAS006
     C                             DDACTN = 'A' AND POPSEL = 'U'                              CAS006
     C                   EVAL      PEdtFld = 'Y'                                              CAS006
     C                   EVAL      PEINKE = 'Y'                                               CAS006
     C                   ELSE                                                                 CAS006
     C                   EVAL      PEdtFld = 'N'                                              CAS006
     C                   EVAL      PEINKE = 'N'                                               CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Process the 2nd Screen Extension.                                                    CAS006
                                                                                              CAS006
     C                   CALLB     'SESECS5DP'                                                CAS006
      *                  ---------------------                                                CAS006
                                                                                              CAS006
      ** Input Parameters                                                                     CAS006
      ** ================                                                                     CAS006
                                                                                              CAS006
      ** Return Code                                                                          CAS006
     C                   PARM      *BLANKS       RetCodeOut                                   CAS006
                                                                                              CAS006
      ** Securities Screen 1 Details From Incoming Transaction                                CAS006
      ** - Screen Format                                                                      CAS006
     C                   PARM                    NwSE1ScnFmt                                  CAS006
                                                                                              CAS006
      ** Securities Screen 5 Details From Incoming Transaction                                CAS006
      ** - Screen Format                                                                      CAS006
     C                   PARM                    NwSE5ScnFmt                                  CAS006
                                                                                              CAS006
      ** Securities Details Retrieved From File - File Format                                 CAS006
     C                   PARM                    CrSEFilFmt                                   CAS006
                                                                                              CAS006
      ** Investment Type Details                                                              CAS006
     C                   PARM                    PINVTPD                                      CAS006
                                                                                              CAS006
      ** Display-Only Details                                                                 CAS006
     C                   PARM                    POutFlds                                     CAS006
                                                                                              CAS006
      ** Edit Indicator                                                                       CAS006
     C                   PARM                    PEDtFld                                      CAS006
                                                                                              CAS006
      ** Function Key Indicators:                                                             CAS006
                                                                                              CAS006
      ** KE (F05) = Refresh                                                                   CAS006
      ** KF (F06) = Initial Screen                                                            CAS006
      ** KG (F07) = Read Previous                                                             CAS006
      ** KH (F08) = Read Next                                                                 CAS006
      ** KL (F12) = Cancel                                                                    CAS006
      ** KP (F15) = Browse                                                                    CAS006
     C                   PARM                    PEINKE                                       CAS006
     C                   PARM      'N'           PEINKF                                       CAS006
     C                   PARM      'N'           PEINKG                                       CAS006
     C                   PARM      'N'           PEINKH                                       CAS006
     C                   PARM      'Y'           PEINKL                                       CAS006
     C                   PARM      'N'           PEINKP                                       CAS006
                                                                                              CAS006
      ** Securities Screen 5 Error Indicators                                                 CAS006
     C                   PARM                    SEESEC5                                      CAS006
                                                                                              CAS006
      ** Error Fields/Msg. IDs/Msg. Data (Arrays) From/To Caller                              CAS006
     C                   PARM                    FldNameArr                                   CAS006
     C                   PARM                    MsgIdArr                                     CAS006
     C                   PARM                    MsgDtaArr                                    CAS006
                                                                                              CAS006
      ** Warning Fields/Msg. IDs/Msg. Data (Arrays) From/To Caller                            CAS006
     C                   PARM                    WFldNamArr                                   CAS006
     C                   PARM                    WMsgIdArr                                    CAS006
     C                   PARM                    WMsgDtaArr                                   CAS006
                                                                                              CAS006
      ** Write Only Indicator                                                                 CAS006
     C                   PARM      'N'           WriteOnly                                    CAS006
                                                                                              CAS006
      ** Standing Data:                                                                       CAS006
                                                                                              CAS006
      ** System Run Date                                                                      CAS006
     C                   PARM                    BJMRDT                                       CAS006
                                                                                              CAS006
      ** Switchable Features:                                                                 CAS006
                                                                                              CAS006
      ** Hedge Accounting Phase B                                                             CAS006
     C                   PARM                    CAS006                                       CAS006
                                                                                              CAS006
      ** Output Parameters                                                                    CAS006
      ** =================                                                                    CAS006
                                                                                              CAS006
      ** KC (F03) = Exit                                                                      CAS006
      ** KE (F05) = Refresh                                                                   CAS006
      ** KF (F06) = Initial Screen                                                            CAS006
      ** KG (F07) = Read Previous                                                             CAS006
      ** KH (F08) = Read Next                                                                 CAS006
      ** KL (F12) = Cancel                                                                    CAS006
      ** KP (F15) = Browse                                                                    CAS006
     C                   PARM      *OFF          PINKC                                        CAS006
     C                   PARM      *OFF          PINKE                                        CAS006
     C                   PARM      *OFF          PINKF                                        CAS006
     C                   PARM      *OFF          PINKG                                        CAS006
     C                   PARM      *OFF          PINKH                                        CAS006
     C                   PARM      *OFF          PINKL                                        CAS006
     C                   PARM      *OFF          PINKP                                        CAS006
                                                                                              CAS006
      ** Save the Warning Message ID Array.                                                   CAS006
                                                                                              CAS006
     C                   MOVEA     WMsgIDArr     WPrvWarnAr                                   CAS006
                                                                                              CAS006
      ** Reset the Error Fields.                                                              CAS006
                                                                                              CAS006
     C                   EXSR      SRResetErr                                                 CAS006
                                                                                              CAS006
      ** Begin Function Key Selection                                                         CAS006
      ** ============================                                                         CAS006
                                                                                              CAS006
     C                   SELECT                                                               CAS006
                                                                                              CAS006
      ** F03 - End Program                                                                    CAS006
      ** -----------------                                                                    CAS006
                                                                                              CAS006
     C                   WHEN      PINKC = *ON                                                CAS006
     C                   EXSR      SREndP                                                     CAS006
                                                                                              CAS006
      ** F05 - Refresh                                                                        CAS006
      ** -------------                                                                        CAS006
                                                                                              CAS006
     C                   WHEN      PINKE = *ON                                                CAS006
     C                   EVAL      NwSE5ScnFmt = NwSE5ScnFmx                                  CAS006
     C                   EVAL      SEESEC5 = SEESEC5x                                         CAS006
     C                   EVAL      FldNameArr = FldNameAr5                                    CAS006
     C                   EVAL      MsgIdArr = MsgIdAr5                                        CAS006
     C                   EVAL      MsgDtaArr = MsgDtaAr5                                      CAS006
     C                   EVAL      IDx = ID5                                                  CAS006
                                                                                              CAS006
      ** F12 - Cancel                                                                         CAS006
      ** ------------                                                                         CAS006
                                                                                              CAS006
     C                   WHEN      PINKL = *ON                                                CAS006
     C                   EVAL      NwSE5ScnFmt = NwSE5ScnFmx                                  CAS006
     C                   EVAL      WScrn = '2'                                                CAS006
                                                                                              CAS006
      ** The Enter Key was pressed.                                                           CAS006
                                                                                              CAS006
     C                   OTHER                                                                CAS006
                                                                                              CAS006
      ** If Action Code = 'I' or 'A' and the Option selected is 'U',                          CAS006
      ** validate input to the 5th Screen.                                                    CAS006
                                                                                              CAS006
     C                   IF        DDACTN = 'I' AND POPSEL = 'U' OR                           CAS006
     C                             DDACTN = 'A' AND POPSEL = 'U'                              CAS006
     C                   EXSR      SRVal_5                                                    CAS006
     C                   LEAVESR                                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Don't display the 3rd screen if errors occurred.                                     CAS006
                                                                                              CAS006
     C                   IF        ID5 > 0                                                    CAS006
     C                   IF        PRDNB = 'Y'                                                CAS006
     C                   EVAL      WSCRN = 'R'                                                CAS006
     C                   ELSE                                                                 CAS006
     C                   EVAL      WSCRN = 'B'                                                CAS006
     C                   ENDIF                                                                CAS006
     C                   LEAVESR                                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** If New Issue = 'Y' or Private Banking is enabled, display the                        CAS006
      ** 3rd Screen.                                                                          CAS006
                                                                                              CAS006
     C                   IF        DDNISS = 'Y' OR BGN4ST = 'Y'                               CAS006
                                                                                              CAS006
      ** If this has not been done yet, send security details                                 CAS006
      ** validation error messages to 3rd screen.                                             CAS006
                                                                                              CAS006
     C                   IF        WSndS3 <> 'Y'                                              CAS006
     C                   EXSR      SRSndM3                                                    CAS006
     C                   EVAL      WSndS3 = 'Y'                                               CAS006
     C                   ELSE                                                                 CAS006
     C                   MOVE      SEESEC3x      SEESEC3                                      CAS006
     C                   MOVEA     FldNameAr3    FldNameArr                                   CAS006
     C                   MOVEA     MsgIdAr3      MsgIdArr                                     CAS006
     C                   MOVEA     MsgDtaAr3     MsgDtaArr                                    CAS006
     C                   EVAL      IDx = ID3                                                  CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Display 3rd screen.                                                                  CAS006
     C                   EVAL      WScrn = '3'                                                CAS006
                                                                                              CAS006
      ** Set the Issue Amount for the 3rd Screen if Risk Management is                        CAS006
      ** enabled and Early Repayment Indicator = 'Y'. The value of                            CAS006
      ** this field depends on the previous screen.                                           CAS006
                                                                                              CAS006
     C                   IF        BGRKMG = 'Y' AND DDERPY ='Y'                               CAS006
     C                   EVAL      DDISA2 = DDISA1                                            CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDSL                                                                CAS006
                                                                                              CAS006
      ** End Function Key Selection                                                           CAS006
      ** ==========================                                                           CAS006
                                                                                              CAS006
     C                   ENDSR                                                                CAS006
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSCRN_3 - Process 3rd screen                                *
      *                                                               *
      *****************************************************************
     C     SRScrn_3      BEGSR
      *
      ** If Action Code is Insert or Amend and Option selected is 'U',
      ** enable Detail fields on 3rd screen.
      ** Also, enable F5=Refresh.
     C                   IF        DDACTN = 'I' AND POPSEL = 'U' OR
     C                             DDACTN = 'A' AND POPSEL = 'U'
     C                   EVAL      PEDTFLD = 'Y'
     C                   EVAL      PEINKE = 'Y'
     C                   ELSE
     C                   EVAL      PEDTFLD = 'N'
     C                   EVAL      PEINKE = 'N'
     C                   ENDIF
      *
      ** Display 3rd screen.
     C                   CALLB     'SESECS3DP'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Security 1st screen details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** Security 3rd screen details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE3ScnFmt
      *
      ** Enable Detail Fields Indicator
     C                   PARM                    PEDtFld
      *                                                                                       CSE065
      ** Processing Type Indicator                                                            CSE065
     C                   PARM                    F1PROT                                       CSE065
      *
      ** Enable Function Keys
      ** KE = Command Key 05 = Refresh
      ** KF = Command Key 06 = Initial Screen
      ** KG = Command Key 07 = Read Previous
      ** KH = Command Key 08 = Read Next
      ** KL = Command Key 12 = Cancel
      ** KP = Command Key 15 = Browse
     C                   PARM                    PEINKE
     C                   PARM      'N'           PEINKF
     C                   PARM      'N'           PEINKG
     C                   PARM      'N'           PEINKH
     C                   PARM      'Y'           PEINKL
     C                   PARM      'N'           PEINKP
      *
      ** Security 3rd screen error indicators
     C                   PARM                    SEESEC3
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Warning fields/message Ids/message data (arrays) from/to
      ** caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Write Screen with No Read Indicator
     C                   PARM      'N'           WriteOnly
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System run date
     C                   PARM                    BJMRDT
      *                                                                                       CSE065
      ** SDBANK - System run day number                                                       CSE065
     C                   PARM                    BJRDNB                                       CSE065
      *
      ** SDGELR - Private Banking
     C                   PARM                    BGN4ST
                                                                                              CGL032
      ** SWITCHABLE FEATURES                                                                  CGL032
      ** ===================                                                                  CGL032
                                                                                              CGL014
      ** Collaterals Processing                                                               CGL014
     C                   PARM                    CGL014                                       CGL014
                                                                                              CGL031
      ** Taxation on Savings Income                                                           CGL031
                                                                                              CGL031
     C                   PARM                    CGL031                                       CGL031
                                                                                              CGL032
      ** Automatic Exhange of Information                                                     CGL032
                                                                                              CGL032
     C                   PARM                    CGL032                                       CGL032
      *
      ** OUTPUT
      ** ======
      *
      ** Function Keys Enabled
      ** KC = Command Key 03 = Exit
      ** KE = Command Key 05 = Refresh
      ** KF = Command Key 06 = Initial Screen
      ** KG = Command Key 07 = Read Previous
      ** KH = Command Key 08 = Read Next
      ** KL = Command Key 12 = Cancel
      ** KP = Command Key 15 = Browse
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKE
     C                   PARM      '0'           PINKF
     C                   PARM      '0'           PINKG
     C                   PARM      '0'           PINKH
     C                   PARM      '0'           PINKL
     C                   PARM      '0'           PINKP
      *
      ** Save Warning Message Ids array of 3rd screen.
     C                   MOVEA     WMsgIDArr     WPrvWarnAr
      *
      ** Reset error fields.
     C                   EXSR      SRResetErr
      *
     C                   SELECT
      *
      ** F3 - end program.
     C                   WHEN      PINKC = *ON
     C                   EXSR      SREndP
      *
      ** F5 - refresh 3rd screen.
     C                   WHEN      PINKE = *ON
     C                   EVAL      NwSE3ScnFmt = NwSE3ScnFmx
     C                   EVAL      SEESEC3 = SEESEC3x
     C                   EVAL      FldNameArr = FldNameAr3
     C                   EVAL      MsgIdArr = MsgIdAr3
     C                   EVAL      MsgDtaArr = MsgDtaAr3
     C                   EVAL      IDx = ID3
      *
      ** F12 - cancel.  Display 2nd screen.
     C                   WHEN      PINKL = *ON
     C                   EVAL      NwSE3ScnFmt = NwSE3ScnFmx
     C                   EVAL      NwSEFilFmt = NwSEFilFmtOld
      *
      ** Refresh, return old values for file update and redisplay screen 2.
      ** Set up Issue amount 1 to be equal to Issue amount on third screen
      ** only if Risk Management is on and early repayment and new issue.
      *
     C                   MOVE      DDISA1        WISSA1
     C                   IF        BGRKMG = 'Y' AND DDERPY ='Y' AND
     C                             DDNISS = 'Y' AND WISSA1 = *ZEROS
     C                   EVAL      DDISA1 = DDISA2
     C                   ENDIF
     C**********         EVAL      WSCRN = '2'                                                CAS006
     C                   EVAL      WScrn = '5'                                                CAS006
      *
      ** Enter key was pressed.
     C                   OTHER
      *
      ** If Action is Insert or Amend and Option selected is 'U',
      ** validate input to 3rd screen.
     C                   IF        DDACTN = 'I' AND POPSEL = 'U' OR
     C                             DDACTN = 'A' AND POPSEL = 'U'
     C                   EXSR      SRVAL_3
     C                   GOTO      EScrn_3
     C                   ENDIF
      *
      ** Read Next Subfile record or display Browse screen.
     C                   IF        PRDNB = 'Y'
     C                   EVAL      WSCRN = 'R'
     C                   ELSE
     C                   EVAL      WSCRN = 'B'
     C                   ENDIF

     C                   ENDSL

     C     EScrn_3       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVAL_3 - Validate input to 3rd screen                       *
      *                                                               *
      *****************************************************************
     C     SRVal_3       BEGSR
      *
      ** If Action is Amend, validate whether non-amendable fields
      ** have been amended.
     C                   IF        DDACTN = 'A'

     C                   CALLB     'SESECS3MD'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Securities Screen 3 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE3ScnFmt
      *
      ** Early Repayments? - from 1st screen
      ** New Issue - from 1st screen
      ** Issue Amount 1 - from 2nd screen
     C                   PARM                    DDERPY
     C                   PARM                    DDNISS
     C                   PARM                    DDISA1
      *
      ** Securities Screen 3 details retrieved from file
      ** - screen format
     C                   PARM                    CrSE3ScnFmt
      *
      ** Reset of Fields in Error Required (Y/N)
     C                   PARM      'Y'           PResetFld
      *
      ** STANDING DATA
      ** =============
      *
      ** SDMMOD - Private Banking
     C                   PARM                    BGN4ST
      *
      ** SDMMOD - Interest Risk Management
     C                   PARM                    BGRKMG
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message Ids/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    IDx
      *
      ** Securities Screen 3 error indicators
     C                   PARM                    SEESEC3
      *
      ** OK Amendments field
     C                   PARM                    PAmendOK

     C                   ENDIF
      *
      ** Validate Detail fields on 3rd screen.
     C                   CALLB     'SESECS3VL'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
     C                   PARM                    PMode
      *
      ** Response Mode
     C                   PARM                    PResponse
      *
      ** Securities screen 2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE2ScnFmt
      *
      ** Securities Screen 3 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE3ScnFmt
      *
      ** Securities retrieved from file - file format
     C                   PARM                    CrSEFilFmt
      *                                                                         CSE023
      ** Processing type, from PF/INVTPD                                        CSE023
     C                   PARM                    F1PROT                         CSE023
      *
      ** New Issue
     C                   PARM                    DDNISS
      *
      ** Action Code
     C                   PARM                    DDACTN
      *                                                                                       248555
      ** Subject to European Tax                                                              248555
     C                   PARM                    DDSETX                                       248555
      *                                                                                     AR996842
      ** Instrument type                                                                    AR996842
      *                                                                                     AR996842
     C                   PARM                    PINNR                                      AR996842
      *
      ** STANDING DATA
      ** =============
      *
      ** SDMMOD - Date Format Indicator
     C                   PARM                    BJDFIN
      *
      ** SDMMOD - Private Banking Flag
     C                   PARM                    BGN4ST
      *
      ** SDMMOD - Interest risk management
     C                   PARM                    BGRKMG
      *                                                                         CSE023
      ** CSE023 - US Withholding Tax Treaty                                     CSE023
     C                   PARM                    CSE023                         CSE023
                                                                                              CGL014
      ** Collaterals Processing                                                               CGL014
     C                   PARM                    CGL014                                       CGL014
      *                                                                                       248555
      ** Taxation on Savings Income                                                           248555
     C                   PARM                    CGL031                                       248555
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    IDx
      *
      ** Warning flds/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    WIDx
      *
      ** Securities Screen 3 error indicators
     C                   PARM                    SEESEC3
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Redisplay screen indicator
     C                   PARM      'N'           PReDsp
      *
     C                   MOVEL     *BLANK        WRedisplay
      *
      ** If no errors occurred during validation of fields on 3rd screen,
      ** check if there are warnings which have not been diplayed yet.
     C                   IF        IDx = 0

     C                   Z-ADD     1             WIx

     C     WIx           DOWLE     WIDx
     C     WRedisplay    ANDEQ     *BLANK
     C                   IF        WMsgIdArr(WIx) <> WPrvWarnAr(WIx)
     C                   EVAL      WRedisplay = 'Y'
     C                   ELSE
     C                   EVAL      WIx =WIx + 1
     C                   ENDIF
     C                   ENDDO

     C                   IF        WRedisplay <> 'Y'
     C                   EXSR      SRResetErr
     C                   ENDIF

     C                   ENDIF
      *
      ** Redisplay 3rd screen if there are errors or if there are
      ** warnings which have not been displayed yet.
     C                   IF        IDx <> 0 OR WRedisplay = 'Y' OR
     C                             PReDsp = 'Y'
     C                   GOTO      EVal_3
     C                   ENDIF
      *
      ** Call US Treaty Tax details if windows processing on, otherwise                       218563
      ** Display Confirmation screen.
      *                                                                                       218563
     C                   IF        ULX610  = 'Y'                                              CER001
     C                   EVAL      WSCRN   = 'L'                                              CER001
     C                   ELSE                                                                 CER001
     C                   IF        BGWDPR = 'Y'                                               218563
     C                   EVAL      WOScrn = WScrn                                             218563
     C                   EVAL      WScrn = 'W'                                                218563
     C                   ELSE                                                                 218563
     C                   EVAL      WSCRN = 'F'
     C                   ENDIF                                                                218563
     C                   ENDIF                                                                CER001

     C     EVal_3        ENDSR
      *****************************************************************
      /EJECT                                                                                  CSE031
      *****************************************************************                       CSE031
      *                                                               *                       CSE031
      *  SRSCRN_4 - Process 4th screen                                *                       CSE031
      *                                                               *                       CSE031
      *****************************************************************                       CSE031
     C     SRScrn_4      BEGSR                                                                CSE031
      *                                                                                       CSE031
      ** If Action Code is Insert or Amend and Option selected is 'U',                        CSE031
      ** enable Detail fields on 4th screen.                                                  CSE031
      ** Also, enable F5=Refresh.                                                             CSE031
      *                                                                                       CSE031
     C                   IF        DDACTN = 'I' AND POPSEL = 'U' OR                           CSE031
     C                             DDACTN = 'A' AND POPSEL = 'U'                              CSE031
     C                   EVAL      PEDTFLD = 'Y'                                              CSE031
     C                   EVAL      PEINKE = 'Y'                                               CSE031
     C                   ELSE                                                                 CSE031
     C                   EVAL      PEDTFLD = 'N'                                              CSE031
     C                   EVAL      PEINKE = 'N'                                               CSE031
     C                   ENDIF                                                                CSE031
      *                                                                                       CSE031
      ** Display 4th screen.                                                                  CSE031
      *                                                                                       CSE031
     C                   CALLB     'SESECS4DP'                                                CSE031
      *                             =========                                                 CSE031
      ** INPUT                                                                                CSE031
      ** =====                                                                                CSE031
      *                                                                                       CSE031
      ** Return Code                                                                          CSE031
     C                   PARM      *BLANKS       RetCodeOut                                   CSE031
      *                                                                                       CSE031
      ** Security 1st screen details from incoming transaction                                CSE031
      ** - screen format                                                                      CSE031
     C                   PARM                    NwSE1ScnFmt                                  CSE031
      *                                                                                       CSE031
      ** Security 2nd screen details from incoming transaction                                CSE031
      ** - screen format                                                                      CSE031
     C                   PARM                    NwSE2ScnFmt                                  CSE031
      *                                                                                       CSE031
      ** Security 4th screen details from incoming transaction                                CSE031
      ** - screen format                                                                      CSE031
     C                   PARM                    NwSE4ScnFmt                                  CSE031
      *                                                                                       CSE031
      ** Security retrieved from file - file format                                           CSE031
     C                   PARM                    CrSEFilFmt                                   CSE031
      *                                                                                       CSE031
      ** Enable Detail Fields Indicator                                                       CSE031
     C                   PARM                    PEDtFld                                      CSE031
      *                                                                                       CSE031
      ** Enable Function Keys                                                                 CSE031
      ** KE = Command Key 05 = Refresh                                                        CSE031
      ** KF = Command Key 06 = Initial Screen                                                 CSE031
      ** KG = Command Key 07 = Read Previous                                                  CSE031
      ** KH = Command Key 08 = Read Next                                                      CSE031
      ** KL = Command Key 12 = Cancel                                                         CSE031
      ** KP = Command Key 15 = Select                                                         CSE031
     C                   PARM                    PEINKE                                       CSE031
     C                   PARM      'N'           PEINKF                                       CSE031
     C                   PARM      'N'           PEINKG                                       CSE031
     C                   PARM      'N'           PEINKH                                       CSE031
     C                   PARM      'Y'           PEINKL                                       CSE031
     C                   PARM      'N'           PEINKP                                       CSE031
      *                                                                                       CSE031
      ** Security 4th screen error indicators                                                 CSE031
     C                   PARM                    SEESEC4                                      CSE031
      *                                                                                       CSE031
      ** Error fields/message IDs/message data (arrays) from/to caller                        CSE031
     C                   PARM                    FldNameArr                                   CSE031
     C                   PARM                    MsgIdArr                                     CSE031
     C                   PARM                    MsgDtaArr                                    CSE031
      *                                                                                       CSE031
      ** Warning fields/message Ids/message data (arrays) from/to                             CSE031
      ** caller                                                                               CSE031
     C                   PARM                    WFldNamArr                                   CSE031
     C                   PARM                    WMsgIdArr                                    CSE031
     C                   PARM                    WMsgDtaArr                                   CSE031
      *                                                                                       CSE031
      ** Write Screen with No Read Indicator                                                  CSE031
     C                   PARM      'N'           WriteOnly                                    CSE031
      *                                                                                       CSE031
      ** STANDING DATA                                                                        CSE031
      ** =============                                                                        CSE031
      *                                                                                       CSE031
      ** SDBANK - System run date                                                             CSE031
     C                   PARM                    BJMRDT                                       CSE031
      *                                                                                       CSE031
      ** OUTPUT                                                                               CSE031
      ** ======                                                                               CSE031
      *                                                                                       CSE031
      ** Function Keys Enabled                                                                CSE031
      ** KC = Command Key 03 = Exit                                                           CSE031
      ** KE = Command Key 05 = Refresh                                                        CSE031
      ** KF = Command Key 06 = Initial Screen                                                 CSE031
      ** KG = Command Key 07 = Read Previous                                                  CSE031
      ** KH = Command Key 08 = Read Next                                                      CSE031
      ** KL = Command Key 12 = Cancel                                                         CSE031
      ** KP = Command Key 15 = Select                                                         CSE031
     C                   PARM      '0'           PINKC                                        CSE031
     C                   PARM                    PINKE                                        CSE031
     C                   PARM      '0'           PINKF                                        CSE031
     C                   PARM      '0'           PINKG                                        CSE031
     C                   PARM      '0'           PINKH                                        CSE031
     C                   PARM                    PINKL                                        CSE031
     C                   PARM      '0'           PINKP                                        CSE031
      *                                                                                       CSE031
      ** Save Warning Message Ids array of 4th screen.                                        CSE031
     C                   MOVEA     WMsgIDArr     WPrvWarnAr                                   CSE031
      *                                                                                       CSE031
      ** Reset error fields.                                                                  CSE031
     C                   EXSR      SRResetErr                                                 CSE031
                                                                                              CSE031
     C                   SELECT                                                               CSE031
      *                                                                                       CSE031
      ** F3 - end program.                                                                    CSE031
     C                   WHEN      PINKC = *ON                                                CSE031
     C                   EXSR      SREndP                                                     CSE031
      *                                                                                       CSE031
      ** F5 - refresh 4th screen.                                                             CSE031
     C                   WHEN      PINKE = *ON                                                CSE031
     C                   EVAL      NwSE4ScnFmt = NwSE4ScnFmx                                  CSE031
     C                   EVAL      SEESEC4 = SEESEC4x                                         CSE031
     C                   EVAL      FldNameArr = FldNameAr4                                    CSE031
     C                   EVAL      MsgIdArr = MsgIdAr4                                        CSE031
     C                   EVAL      MsgDtaArr = MsgDtaAr4                                      CSE031
     C                   EVAL      IDx = ID4                                                  CSE031
      *                                                                                       CSE031
      ** F12 - cancel.  Display 2nd screen.                                                   CSE031
     C                   WHEN      PINKL = *ON                                                CSE031
     C                   EVAL      NwSE4ScnFmt = NwSE4ScnFmx                                  CSE031
     C                   EVAL      WSCRN = '2'                                                CSE031
      *                                                                                       CSE031
      ** Enter key was pressed.                                                               CSE031
     C                   OTHER                                                                CSE031
      *                                                                                       CSE031
      ** If Action is Insert or Amend and Option selected is 'U',                             CSE031
      ** validate input to 4th screen.                                                        CSE031
     C                   IF        DDACTN = 'I' AND POPSEL = 'U' OR                           CSE031
     C                             DDACTN = 'A' AND POPSEL = 'U'                              CSE031
     C                   EXSR      SRVAL_4                                                    CSE031
     C                   GOTO      EScrn_4                                                    CSE031
     C                   ENDIF                                                                CSE031
      *                                                                                       CSE031
      ** If errors exist on 4th screen, no need to display 2nd screen.                        CSE031
     C                   IF        ID4 > 0                                                    CSE031
      *                                                                                       CSE031
     C                   IF        PRDNB = 'Y'                                                CSE031
     C                   EVAL      WSCRN = 'R'                                                CSE031
     C                   ELSE                                                                 CSE031
     C                   EVAL      WSCRN = 'B'                                                CSE031
     C                   ENDIF                                                                CSE031
      *                                                                                       CSE031
     C                   GOTO      EScrn_4                                                    CSE031
     C                   ENDIF                                                                CSE031
      *                                                                                       CSE031
      *                                                                                       CSE031
      ** Redisplay 2nd screen.                                                                CSE031
     C                   EVAL      WSCRN = '2'                                                CSE031
      *                                                                                       CSE031
     C                   ENDSL                                                                CSE031
                                                                                              CSE031
     C     EScrn_4       ENDSR                                                                CSE031
      *****************************************************************                       CSE031
      /EJECT                                                                                  CSE031
      *****************************************************************                       CSE031
      *                                                               *                       CSE031
      *  SRVAL_4 - Validate input 4th screen                          *                       CSE031
      *                                                               *                       CSE031
      *****************************************************************                       CSE031
     C     SRVal_4       BEGSR                                                                CSE031
      *                                                                                       CSE031
      ** If Action is Amend, validate whether non-amendable fields                            CSE031
      ** have been amended.                                                                   CSE031
     C                   IF        DDACTN = 'A'                                               CSE031
                                                                                              CSE031
     C                   CALLB     'SESECS4MD'                                                CSE031
      *                             =========                                                 CSE031
      ** INPUT                                                                                CSE031
      ** =====                                                                                CSE031
      *                                                                                       CSE031
      ** Return Code                                                                          CSE031
     C                   PARM      *BLANKS       RetCodeOut                                   CSE031
      *                                                                                       CSE031
      ** Securities Screen 4 details from incoming transaction                                CSE031
      ** - screen format                                                                      CSE031
     C                   PARM                    NwSE4ScnFmt                                  CSE031
      *                                                                                       CSE031
      ** Securities Screen 4 details retrieved from file                                      CSE031
      ** - screen format                                                                      CSE031
     C                   PARM                    CrSE4ScnFmt                                  CSE031
      *                                                                                       CSE031
      ** Securities retrieved from file - file format                                         CSE031
     C                   PARM                    CrSEFilFmt                                   CSE031
      *                                                                                       CSE031
      ** Securities for file update - file format                                             CSE031
     C                   PARM                    NwSEFilFmt                                   CSE031
      *                                                                                       CSE031
      ** Investment processing type from PF/INVTPD                                            CSE031
     C                   PARM                    F1PROT                                       CSE031
      *                                                                                       CSE031
      ** Reset of Fields in Error Required (Y/N)                                              CSE031
     C                   PARM      'Y'           PResetFld                                    CSE031
      *                                                                                       CSE031
      ** SWITCHABLE FEATURES                                                                  CSE031
      ** ===================                                                                  CSE031
      *                                                                                       CSE031
      ** Coupon Fixing for Floating Rate Notes.                                               CSE031
     C                   PARM                    CSE031                                       CSE031
      *                                                                                       CSE031
      ** OUTPUT                                                                               CSE031
      ** ======                                                                               CSE031
      *                                                                                       CSE031
      ** Error fields/message Ids/message data (arrays) from/to caller                        CSE031
     C                   PARM                    FldNameArr                                   CSE031
     C                   PARM                    MsgIdArr                                     CSE031
     C                   PARM                    MsgDtaArr                                    CSE031
      *                                                                                       CSE031
      ** Array index (3P0) from/to caller                                                     CSE031
     C                   PARM                    IDx                                          CSE031
      *                                                                                       CSE031
      ** Securities Screen 4 error indicators                                                 CSE031
     C                   PARM                    SEESEC4                                      CSE031
      *                                                                                       CSE031
      ** OK Amendments field                                                                  CSE031
     C                   PARM                    PAmendOK                                     CSE031
                                                                                              CSE031
     C                   ENDIF                                                                CSE031
      *                                                                                       CSE031
      ** Validate Detail fields on 4th screen.                                                CSE031
     C                   CALLB     'SESECS4VL'                                                CSE031
      *                             =========                                                 CSE031
      ** INPUT                                                                                CSE031
      ** =====                                                                                CSE031
      *                                                                                       CSE031
      ** Mode = '*FRONT' (Front Office Transaction Interface)                                 CSE031
      ** Mode = '      ' (Not Front Office Transaction Interface)                             CSE031
      ** Mode = '*RPR  ' (Repair Function)                                                    CSE031
      ** Mode = '*SIN  ' (Screen Input Function)                                              CSE031
     C                   PARM                    PMode                                        CSE031
      *                                                                                       CSE031
      ** Response Mode                                                                        CSE031
     C                   PARM                    PResponse                                    CSE031
      *                                                                                       CSE031
      ** Securities screen 4 details from incoming transaction                                CSE031
      ** - screen format                                                                      CSE031
     C                   PARM                    NwSE4ScnFmt                                  CSE031
      *                                                                                       CSE031
      ** Securities screen 4 details retrieved from file                                      CSE031
      ** - screen format                                                                      CSE031
     C                   PARM                    CrSE4ScnFmt                                  CSE031
      *                                                                                       CSE031
      ** Securities retrieved from file - file format                                         CSE031
     C                   PARM                    CrSEFilFmt                                   CSE031
      *                                                                                       CSE031
      ** STANDING DATA                                                                        CSE031
      ** =============                                                                        CSE031
      *                                                                                       CSE031
      ** SDBANK - date format indicator                                                       CSE031
     C                   PARM                    BJDFIN                                       CSE031
      *                                                                                       CSE031
      ** SDBANK - midas run date number                                                       CSE031
     C                   PARM                    BJRDNB                                       CSE031
      *                                                                                       CSE031
      ** OUTPUT                                                                               CSE031
      ** ======                                                                               CSE031
      *                                                                                       CSE031
      ** Error fields/message IDs/message data (arrays) from/to caller                        CSE031
     C                   PARM                    FldNameArr                                   CSE031
     C                   PARM                    MsgIdArr                                     CSE031
     C                   PARM                    MsgDtaArr                                    CSE031
      *                                                                                       CSE031
      ** Array index (3P0) from/to caller                                                     CSE031
     C                   PARM                    Idx                                          CSE031
      *                                                                                       CSE031
      ** Warning flds/message IDs/message data (arrays) from/to caller                        CSE031
     C                   PARM                    WFldNamArr                                   CSE031
     C                   PARM                    WMsgIdArr                                    CSE031
     C                   PARM                    WMsgDtaArr                                   CSE031
      *                                                                                       CSE031
      ** Array index (3P0) from/to caller                                                     CSE031
     C                   PARM                    WIdx                                         CSE031
      *                                                                                       CSE031
      ** Securities screen 4 error indicators                                                 CSE031
     C                   PARM                    SEESEC4                                      CSE031
      *                                                                                       CSE031
      ** Securities for file update - file format                                             CSE031
     C                   PARM                    NwSEFilFmt                                   CSE031
      *                                                                                       CSE031
      ** Redisplay screen indicator                                                           CSE031
     C                   PARM      'N'           PReDsp                                       CSE031
      *                                                                                       CSE031
     C                   MOVEL     *BLANK        WRedisplay                                   CSE031
      *                                                                                       CSE031
      ** If no errors occurred during validation of fields on 4th screen,                     CSE031
      ** check if there are warnings which have not been displayed yet.                       CSE031
     C                   IF        IDx = 0                                                    CSE031
                                                                                              CSE031
     C                   Z-ADD     1             WIx                                          CSE031
                                                                                              CSE031
     C     WIx           DOWLE     WIDx                                                       CSE031
     C     WRedisplay    ANDEQ     *BLANK                                                     CSE031
     C                   IF        WMsgIdArr(WIx) <> WPrvWarnAr(WIx)                          CSE031
     C                   EVAL      WRedisplay = 'Y'                                           CSE031
     C                   ELSE                                                                 CSE031
     C                   EVAL      WIx =WIx + 1                                               CSE031
     C                   ENDIF                                                                CSE031
     C                   ENDDO                                                                CSE031
                                                                                              CSE031
     C                   IF        WRedisplay <> 'Y'                                          CSE031
     C                   EXSR      SRResetErr                                                 CSE031
     C                   ENDIF                                                                CSE031
                                                                                              CSE031
     C                   ENDIF                                                                CSE031
      *                                                                                       CSE031
      ** Redisplay 4th screen if there are errors or if there                                 CSE031
      ** are warnings which have not been displayed yet.                                      CSE031
     C                   IF        IDx <> 0 OR WRedisplay = 'Y' OR                            CSE031
     C                             PReDsp = 'Y'                                               CSE031
     C                   GOTO      EVal_4                                                     CSE031
     C                   ENDIF                                                                CSE031
      *                                                                                       CSE031
      ** Redisplay 2nd screen.                                                                CSE031
     C                   EVAL      WSCRN = '2'                                                CSE031
                                                                                              CSE031
                                                                                              CSE031
     C     EVal_4        ENDSR                                                                CSE031
      *****************************************************************                       CSE031
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSCRN_W - Process Window Screen                             *
      *                                                               *
      *****************************************************************
     C     SRScrn_W      BEGSR
      **********                                                                              218563
      ***Write*out*screen*to*remove*error*messages.********************                       218563
     C**********         CALLB     'SESECS1DP'                                                218563
      **********                    =========                                                 218563
      ***INPUT*********************************************************                       218563
      ***=====*********************************************************                       218563
      **********                                                                              218563
      ***Return*Code***************************************************                       218563
     C**********         PARM      *BLANKS       RetCodeOut                                   218563
      **********                                                                              218563
      ***Security*1st*screen*details*from*incoming*transaction*********                       218563
      ***-*screen*format***********************************************                       218563
     C**********         PARM                    NwSE1ScnFmt                                  218563
      **********                                                                              218563
      ***Securities*retrieved*from*file*-*file*format******************                       218563
     C**********         PARM                    CrSEFilFmt                                   218563
      **********                                                                              218563
      ***Enable*Detail*Fields*Indicator********************************                       218563
      ***Enable*Key*Fields*Indicator***********************************                       218563
     C**********         PARM                    PEDtFld                                      218563
     C**********         PARM      'N'           PEKyFld                                      218563
      **********                                                                              218563
      ***Enable*Function*Keys******************************************                       218563
      ***KE*=*Command*Key*05*=*Refresh*********************************                       218563
      ***KG*=*Command*Key*07*=*Read*Previous***************************                       218563
      ***KH*=*Command*Key*08*=*Read*Next*******************************                       218563
      ***KJ*=*Command*Key*10*=*Delete**********************************                       218563
      ***KJ*=*Command*Key*12*=*Cancel**********************************                       218563
      ***KP*=*Command*Key*15*=*Browse**********************************                       218563
     C**********         PARM                    PEINKE                                       218563
     C**********         PARM                    PEINKG                                       218563
     C**********         PARM                    PEINKH                                       218563
     C**********         PARM                    PEINKJ                                       218563
     C**********         PARM                    PEINKL                                       218563
     C**********         PARM                    PEINKP                                       218563
      **********                                                                              218563
      ***Security*1st*screen*error*indicators**************************                       218563
     C**********         PARM                    SEESEC1                                      218563
      **********                                                                              218563
      ***Error*fields/message*IDs/message*data*(arrays)*from/to*caller*                       218563
     C**********         PARM                    FldNameArr                                   218563
     C**********         PARM                    MsgIdArr                                     218563
     C**********         PARM                    MsgDtaArr                                    218563
      **********                                                                              218563
      ***Warning*fields/message*Ids/message*data*(arrays)*from/to******                       218563
      ***caller********************************************************                       218563
     C**********         PARM                    WFldNamArr                                   218563
     C**********         PARM                    WMsgIdArr                                    218563
     C**********         PARM                    WMsgDtaArr                                   218563
      **********                                                                              218563
      ***Write*Screen*with*No*Read*Indicator***************************                       218563
     C**********         PARM      'Y'           WriteOnly                                    218563
      **********                                                                              218563
      ***STANDING*DATA*************************************************                       218563
      ***=============*************************************************                       218563
      **********                                                                              218563
      ***SDBANK*-*System*run*date**************************************                       218563
     C**********         PARM                    BJMRDT                                       218563
      **********                                                                              218563
      ***SDGELR*-*Midas-Plato*Interface********************************                       218563
     C**********         PARM                    BGN2ST                                       218563
      **********                                                                              218563
      ***SWITCHABLE*FEATURES*******************************************                       218563
      ***===================*******************************************                       218563
      **********                                                                              218563
      ***EMU*Securities*Decimals*on*Nominals***************************                       218563
     C**********         PARM                    CEU018                                       218563
      **********                                                                              218563
      ***MT5xx*Message*Generation**************************************                       218563
     C**********         PARM                    S01401                                       218563
      **********                                                                              218563
      ***Market*Data*Feed*on?******************************************                       218563
     C**********         PARM                    CSD006                                CSD006 218563
      **********                                                                              218563
      ***OUTPUT********************************************************                       218563
      ***======********************************************************                       218563
      **********                                                                              218563
      ***Function*Keys*Enabled*****************************************                       218563
      ***KC*=*Command*Key*03*=*Exit************************************                       218563
      ***KE*=*Command*Key*05*=*Refresh*********************************                       218563
      ***KG*=*Command*Key*07*=*Read*Previous***************************                       218563
      ***KH*=*Command*Key*08*=*Read*Next*******************************                       218563
      ***KJ*=*Command*Key*10*=*Delete**********************************                       218563
      ***KL*=*Command*Key*12*=*Cancel**********************************                       218563
      ***KP*=*Command*Key*15*=*Browse**********************************                       218563
     C**********         PARM      '0'           PINKC                                        218563
     C**********         PARM      '0'           PINKE                                        218563
     C**********         PARM      '0'           PINKG                                        218563
     C**********         PARM      '0'           PINKH                                        218563
     C**********         PARM      '0'           PINKJ                                        218563
     C**********         PARM      '0'           PINKL                                        218563
     C**********         PARM      '0'           PINKP                                        218563
      **********                                                                       192054 218563
      ***Private*Banking***********************************************                192054 218563
      **********                                                                       192054 218563
     C**********         PARM                    BGN4ST                                192054 218563
      *
      /COPY WNCPYSRC,SESECSMV1
      *                                                                                      LLN022A
      ** If BOE installed move required fields into fields to be passed to window            LLN022A
      ** to be passed to window                                                              LLN022A
      *                                                                                      LLN022A
     C                   If        LLN022 = 'Y'                                              LLN022A
     C                   Movel     DDSESN        BYSESN                                      LLN022A
     C                   Movel     PTMESTPSEL    BYTMST                                      LLN022A
     C                   Movel     PFOTRANSEL    BYFOTR                                      LLN022A
     C                   Endif                                                               LLN022A
      *                                                                                      LLN022A
     C                   EVAL      #1CRTT = DDCRTT                              CSE023
     C                   EVAL      #1INCT = DDINCT                              CSE023
     C                   EVAL      #1EXCD = DDEXCD                              CSE023
     C                   EVAL      #1OIDI = DDOIDI                              CSE023
     C                   EVAL      #1APIE = DDAPIE                              CSE023
     C                   EVAL      #1PROT = F1PROT                              CSE023
     C                   EVAL      #1SITP = DDSITP                                            220008
      *
      ** Call Window Manager.
     C                   CALL      'WN0010'
     C                   PARM      'SESECSRPR'   PWPGM
     C                   PARM                    PWKEY
     C                   PARM      DDACTN        PWACTION
     C                   PARM                    DATA
     C                   PARM      *BLANKS       PWRTN
     C*****              PARM                    PWSPARE                        CSE023
     C                   PARM      'Y'           PWSPARE                        CSE023

     C                   SELECT
      *
      ** F3 - end program.
     C                   WHEN      PWRTN = 'Y2U9999'
     C                   EXSR      SREndP
      *
      ** F12 - cancel.  Display 1st screen.
     C                   WHEN      PWRTN = 'USR0790'
     C**********         EVAL      WSCRN = '1'                                                218563
     C                   EVAL      WSCRN = WOScrn                                             218563
      *
      ** Enter key was pressed.
     C                   OTHER
      *
      ** If this has not been done yet, send security details
      ** validation error messages to 2nd screen.
     C**********         IF        WSndS2 <> 'Y'                                             BUG9531
     C**********         EXSR      SRSndM2                                                   BUG9531
     C**********         EVAL      WSndS2 = 'Y'                                              BUG9531
     C**********         ELSE                                                                BUG9531
     C**********         MOVE      SEESEC2x      SEESEC2                                     BUG9531
     C**********         MOVEA     FldNameAr2    FldNameArr                                  BUG9531
     C**********         MOVEA     MsgIdAr2      MsgIdArr                                    BUG9531
     C**********         MOVEA     MsgDtaAr2     MsgDtaArr                                   BUG9531
     C**********         EVAL      IDx = ID2                                                 BUG9531
     C**********         ENDIF                                                               BUG9531
      *
      ** Display 2nd screen.
     C**********         EVAL      WSCRN = '2'                                               BUG9531
      *
      ** Process defaulting of 2nd screen details before going to 2nd screen.
     C**********         EXSR      SRDefScn2                                                 BUG9531

      *                                                                                      BUG9531
      ** If Action code is insert or Amend and Option selected is 'U'                        BUG9531
      ** update the screen                                                                   BUG9531
      *                                                                                      BUG9531
     C                   IF        DDACTN = 'I' AND POPSEL = 'U' OR                          BUG9531
     C                             DDACTN = 'A' AND POPSEL = 'U'                             BUG9531
     C                   EVAL      WSCRN = 'F'                                               BUG9531
     C                   LEAVESR                                                             BUG9531
     C                   ENDIF                                                               BUG9531
      *                                                                                      BUG9531
     C                   IF        PRDNB = 'Y'                                               BUG9531
     C                   EVAL      WSCRN = 'R'                                               BUG9531
     C                   ELSE                                                                BUG9531
     C                   EVAL      WSCRN = 'B'                                               BUG9531
     C                   ENDIF                                                               BUG9531
      *                                                                                      BUG9531
     C                   ENDSL

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       CER001
      *                                                               *                       CER001
      *  SRScrn_L - Extension File Processing                         *                       CER001
      *                                                               *                       CER001
      *****************************************************************                       CER001
     C     SRScrn_L      BEGSR                                                                CER001
     C                   EVAL      WLuxScrn = '1'                                             CER001
     C                   IF        POPSEL   = 'N'                                             CER001
     C                   EVAL      PWAction = 'E'                                             CER001
     C                   EVAL      #1DEXT   = 'Y'                                             CER001
     C                   EVAL      #2DEXT   = 'Y'                                             CER001
     C                   EVAL      #3DEXT   = 'Y'                                             CER001
     C                   ELSE                                                                 CER001
     C                   EVAL      PWAction = DDACTN                                          CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   DOW       WSCRN    = 'L'                                             CER001
      *                                                                                       CER001
     C                   SELECT                                                               CER001
      *                                                                                       CER001
     C                   WHEN      WLuxScrn = '1' And ULX004 = 'Y'                            CER001
     C                   CALL      'SESECS2RP'                                                CER001
     C                   PARM      *BLANKS       RetCodeIn                                    CER001
     C                   PARM                    PWAction                                     CER001
     C                   PARM                    DATALUX                                      CER001
     C                   PARM      *BLANKS       W0RTN                                        CER001
     C                   PARM                    PDTMST                                       CER001
     C                   PARM                    NwExScnFmt                                   CER001
     C                   PARM                    NwExFilFmt2                                  CER001
     C                   EVAL      #1DEXT   = *BLANK                                          CER001
      *                                                                                       CER001
     C                   WHEN      WLuxScrn = '2' And ULX004 = 'Y'                            CER001
     C                   CALL      'SESECS3RP'                                                CER001
     C                   PARM      *BLANKS       RetCodeIn                                    CER001
     C                   PARM                    PWAction                                     CER001
     C                   PARM                    DATALUX                                      CER001
     C                   PARM      *BLANKS       W0RTN                                        CER001
     C                   PARM                    PDTMST                                       CER001
     C                   PARM                    NwExScnFmt                                   CER001
     C                   PARM                    NwExFilFmt3                                  CER001
     C                   EVAL      #2DEXT   = *BLANK                                          CER001
      *                                                                                       CER001
     C                   WHEN      WLuxScrn = '3' And ULX043 = 'Y'                            CER001
     C                   CALL      'SESECS4RP'                                                CER001
     C                   PARM      *BLANKS       RetCodeIn                                    CER001
     C                   PARM                    PWAction                                     CER001
     C                   PARM                    DATALUX                                      CER001
     C                   PARM      *BLANKS       W0RTN                                        CER001
     C                   PARM                    PDTMST                                       CER001
     C                   PARM                    NwExScnFmt                                   CER001
     C                   PARM                    NwExFilFmt4                                  CER001
     C                   EVAL      #3DEXT   = *BLANK                                          CER001
      *                                                                                       CER001
     C                   ENDSL                                                                CER001
      *                                                                                       CER001
     C                   SELECT                                                               CER001
     C                   WHEN      W0RTN    = 'Y2U9999'                                       CER001
     C                   EVAL      WSCRN    = 'T'                                             CER001
      *                                                                                       CER001
     C                   WHEN      W0RTN    = 'USR0790'                                       CER001
     C                   SELECT                                                               CER001
     C                   WHEN      WLuxScrn = '3'                                             CER001
     C                   EVAL      WLuxScrn = '2'                                             CER001
     C                   WHEN      WLuxScrn = '2'                                             CER001
     C                   EVAL      WLuxScrn = '1'                                             CER001
     C                   WHEN      WLuxScrn = '1'                                             CER001
     C                   IF        PRDNB    = 'R'                                             CER001
     C                   EVAL      WSCRN    = 'R'                                             CER001
     C                   ELSE                                                                 CER001
     C                   EVAL      WSCRN    = '1'                                             CER001
     C                   ENDIF                                                                CER001
     C                   ENDSL                                                                CER001
      *                                                                                       CER001
     C                   WHEN      W0RTN    = *BLANKS                                         CER001
     C                   SELECT                                                               CER001
     C                   WHEN      WLuxScrn = '1'                                             CER001
     C                   EVAL      WLuxScrn = '2'                                             CER001
     C                   WHEN      WLuxScrn = '2'                                             CER001
     C                   EVAL      WLuxScrn = '3'                                             CER001
     C                   WHEN      WLuxScrn = '3' And PWAction <> 'E'                         CER001
     C                   EVAL      WSCRN    = 'F'                                             CER001
     C                   OTHER                                                                CER001
     C                   EVAL      WSCRN    = 'B'                                             CER001
     C                   ENDSL                                                                CER001
      *                                                                                       CER001
     C                   ENDSL                                                                CER001
      *                                                                                       CER001
     C                   ENDDO                                                                CER001
     C                   ENDSR                                                                CER001
      *****************************************************************                       CER001
      /EJECT                                                                                  CER001
      *****************************************************************
      *                                                               *
      *  SRSCRN_F - Process Confirmation Screen                       *
      *                                                               *
      *****************************************************************
     C     SRScrn_F      BEGSR
      *
      ** Reset error fields, specifically arrays for warning messages.
     C                   EXSR      SRResetErr
      *
      ** Entries are valid or only warnings exist.  Output message
      ** "Press ENTER to apply transaction to database or F12 to change.".
     C                   MOVE      '*ANY'        WFldNamArr(1)
     C                   MOVE      'SEA0302'     WMsgIdArr(1)
      *
      ** Display Confirmation screen.
     C                   CALLB     'SESECS1DP'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Security 1st screen details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** Securities retrieved from file - file format
     C                   PARM                    CrSEFilFmt
      *
      ** Enable Detail Fields Indicator
      ** Enable Key Fields Indicator
     C                   PARM                    PEDtFld
     C                   PARM      'N'           PEKyFld
      *
      ** Enable Function Keys
      ** KE = Command Key 05 = Refresh
      ** KG = Command Key 07 = Read Previous
      ** KH = Command Key 08 = Read Next
      ** KJ = Command Key 10 = Delete
      ** KL = Command Key 12 = Cancel
      ** KP = Command Key 15 = Browse
     C                   PARM      'N'           PEINKE
     C                   PARM      'N'           PEINKG
     C                   PARM      'N'           PEINKH
     C                   PARM      'N'           PEINKJ
     C                   PARM      'Y'           PEINKL
     C                   PARM      'N'           PEINKP
      *
      ** Security 1st screen error indicators
     C                   PARM                    SEESEC1
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Warning fields/message Ids/message data (arrays) from/to
      ** caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Write Screen with No Read Indicator
     C                   PARM      'N'           WriteOnly
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System run date
     C                   PARM                    BJMRDT
      *
      ** SDGELR - Midas-Plato Interface
     C                   PARM                    BGN2ST
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** EMU Securities Decimals on Nominals
     C                   PARM                    CEU018
      *
      ** MT5xx Message Generation
     C                   PARM                    S01401
      *
      ** Market Data Feed on?
     C                   PARM                    CSD006                                       CSD006
                                                                                              CGL032
      ** Automatic Exchange of Information                                                    CGL032
                                                                                              CGL032
     C                   PARM                    CGL032                                       CGL032
      *
      ** OUTPUT
      ** ======
      *
      ** Function Keys Enabled
      ** KC = Command Key 03 = Exit
      ** KE = Command Key 05 = Refresh
      ** KG = Command Key 07 = Read Previous
      ** KH = Command Key 08 = Read Next
      ** KJ = Command Key 10 = Delete
      ** KL = Command Key 12 = Cancel
      ** KP = Command Key 15 = Browse
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKE
     C                   PARM      '0'           PINKG
     C                   PARM      '0'           PINKH
     C                   PARM      '0'           PINKJ
     C                   PARM      '0'           PINKL
     C                   PARM      '0'           PINKP
      *                                                                                       192054
      ** Private Banking                                                                      192054
      *                                                                                       192054
     C                   PARM                    BGN4ST                                       192054
      *
      ** Reset error fields.
     C                   EXSR      SRResetErr
      *
     C                   SELECT
      *
      ** F3 - end program.
     C                   WHEN      PINKC = *ON
     C                   EXSR      SREndP
      *
      ** F12 - cancel.  Display 1st screen.
     C                   WHEN      PINKL = *ON
     C                   EVAL      WSCRN = '1'
      *
      ** Enter key was pressed.  Update files.
     C                   OTHER
     C                   EVAL      WSCRN = 'U'

     C                   ENDSL

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUPDATE - Update Files                                      *
      *                                                               *
      *****************************************************************
     C     SRUpdate      BEGSR
      *
      ** Action is delete.
      *
     C                   IF        DDACTN = 'D'
      *
      ** Record id.
     C                   EVAL      S1RECI = 'D'

     C                   ELSE
      *
      ** Action is insert.
      *
     C                   IF        DDACTN = 'I'
      *
      ** Record id.
     C                   EVAL      S1RECI = 'D'
      *
      ** Security shortname.
     C                   EVAL      S1SESN = DDSESN
      *
      ** Original entry dates.
     C                   Z-ADD     BJRDNB        S1ORED
      *
      ** First redemption - call/put,price and market price
     C                   EVAL      S1SCPI = *BLANK
     C                   EVAL      S1SCPP = *ZEROS
     C                   EVAL      S1MKPR = *ZEROS
     C                   EVAL      S1MKPN = *ZERO                                             CAS006
     C                   EVAL      S1MCRK = *ZERO                                             CAS006
     C                   EVAL      S1MLQP = *ZERO                                             CAS006
      *
      ** If  new issue flag is not 'Y', output blank fields.
     C                   IF        DDNISS <> 'Y'
     C                   Z-ADD     *ZEROS        S1ISSD
     C                   IF        CGL031 <> 'Y'                                              232543
     C                   Z-ADD     *ZEROS        S1ISSP
     C                   ENDIF                                                                232543
     C                   Z-ADD     *ZEROS        S1ISSA
     C                   Z-ADD     *ZEROS        S1TOTU
     C                   Z-ADD     *ZEROS        S1ALRQ
     C                   Z-ADD     *ZEROS        S1ALRC
     C                   Z-ADD     *ZEROS        S1UNFD
     C                   Z-ADD     *ZEROS        S1UNFR
     C                   Z-ADD     *ZEROS        S1MGFD
     C                   Z-ADD     *ZEROS        S1MGRC
     C**********         Z-ADD     *ZEROS        S1LMGR                                       CSD027
     C                   EVAL      S1LMGR = *BLANKS                                           CSD027
     C                   EVAL      S1FECY = S1NMCY
     C                   ENDIF
      *
      ** Current factor
     C                   IF        F1PROT = '8'
     C                   Z-ADD     1             S1CFCT
     C                   ELSE
     C                   Z-ADD     *ZEROS        S1CFCT
     C                   ENDIF
      *
      ** Default value of issue date to initial date if issue date
      ** was not entered.
     C                   IF        S1ISSD = *ZEROS
     C                   Z-ADD     S1ITLD        S1ISSD
     C                   ENDIF

     C                   ENDIF
      *
      ** Action is amend/insert.
      **           ============
      *
      ** Date made complete.
      *
     C                   IF        ODDINCS = 'I'

     C                   IF        DDINCS = *BLANK OR DDINCS = 'C'
     C                   Z-ADD     BJRDNB        S1DCOM
     C                   ENDIF

     C                   ENDIF
      *
      ** Security Full name -1 defaults to Report name if blanks.
      *
     C                   IF        DDSFN1 <> *BLANKS
     C                   EVAL      S1SFN1 = DDSFN1
     C                   ELSE
     C                   EVAL      S1SFN1 = *BLANKS
     C                   EVAL      S1SFN1 = DDSRPN
     C                   ENDIF
      *
      ** Security full name - 2.
      *
     C                   EVAL      S1SFN2 = DDSFN2
      *
      ** Sector code
      *
     C                   EVAL      S1SSEC = DDSSEC
      *
      ** Rating.
      *
     C                   EVAL      S1QLTY = DDQLTY
      *
      ** Statutory Returns Code.
      *
     C                   EVAL      S1SRET = DDSRET
      *
      ** Pay currency
      *
     C                   EVAL      S1SPYC = S1VLCY
      *
      ** If midas-plato interface is installed.
      *
     C                   IF        BGN2ST = 'Y'
     C                   EVAL      S1PLICCD = DDICCD
     C                   EVAL      S1PLDINM = DDDINM
     C                   EVAL      S1PLRGCD = DDRGCD
     C                   EVAL      S1PLPGCD = DDPGCD
     C                   ENDIF
      *                                                                         CSE023
      ** Windows 2000 processing.                                               CSE023
     C                   IF        BGWDPR = 'Y' AND CSE023 = 'Y'                CSE023
     C                   EVAL      S1CRTT = #1CRTT                              CSE023
     C                   EVAL      S1INCT = #1INCT                              CSE023
     C                   EVAL      S1EXCD = #1EXCD                              CSE023
     C                   EVAL      S1OIDI = #1OIDI                              CSE023
     C                   EVAL      S1APIE = #1APIE                              CSE023
     C                   ENDIF                                                  CSE023

     C                   ENDIF
      *
      ** Front Office Id.
     C                   EVAL      S1FRNT = PFOTRANSEL
      *
      ** Action is insert/amend/delete.
      **           ===================
      *
     C                   IF        DDACTN = 'I' OR DDACTN = 'A' OR
     C                             DDACTN = 'D'
      *
      ** Last change type
     C                   EVAL      S1CHTP = DDACTN
      *
     C                   ENDIF
      *
      ** Update files.
     C                   CALLB     'SESECSUPD'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** STANDING DATA
      ** =============
      *
      ** SDSTRD - Extel option
     C                   PARM                    BVEXOP
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC
      *
      ** SDBANK - Midas Run Day Number
     C                   PARM                    BJRDNB
      *
      ** SDBANK - Date Format Indicator
     C                   PARM                    BJDFIN
      *
      ** ZMUSER - Default Branch
     C                   PARM                    PDBRN
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Corporate Actions
     C                   PARM                    CSE007
      *
      ** Securities Redenomination
     C                   PARM                    CEU017
      *
      ** Market migration
     C                   PARM                    S01511
      ** MDF                                                                                  CSD006
     C                   PARM                    CSD006            1                          CSD006
      *                                                                                       CSE031
      ** Coupon Fixing for Floating Rate Notes                                                CSE031
     C                   PARM                    CSE031                                       CSE031
      *                                                                                       CSE037
      ** Countervalue rounding                                                                CSE037
     C                   PARM                    CSE037                                       CSE037
      *                                                                                       CER001
      ** If no error found and LUX switchable feature is on                                   CER001
      ** update extension file                                                                CER001
      *                                                                                       CER001
     C                   IF        RetCodeOut = *BLANK And ULX610 = 'Y'                       CER001
      *                                                                                       CER001
     C                   IF        ULX004     = 'Y'                                           CER001
     C                   EXSR      SRUPD2                                                     CER001
      *                                                                                       CER001
     C                   IF        RetCodeOut = *BLANK                                        CER001
     C                   EXSR      SRUPD3                                                     CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   IF        RetCodeOut = *BLANK And ULX043 = 'Y'                       CER001
     C                   EXSR      SRUPD4                                                     CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *
      ** If errors occurred on update, rollback uncommitted file
      ** changes.
     C/COPY WNCPYSRC,SESECSRC01
      *
     C                   IF        RetCodeOut <> *BLANKS AND
     C                             RetCodeOut <> '*RECUPD'
      *                                                                                       CSC022
     C                   If        (CSC022 <> 'Y')                                            CSC022
     C                             or (CSC022 = 'Y' and WCommitSkip <> 'Y')                   CSC022
     C                   ROLBK
     C                   EndIf                                                                CSC022
     C                   EXSR      *PSSR
     C                   ELSE
     C                   IF        RetCodeOut = '*RECUPD'
      *                                                                                       CSC022
     C                   If        (CSC022 <> 'Y')                                            CSC022
     C                   ROLBK
     C                   Else                                                                 CSC022
     C                   If        (WCommitSkip <> 'Y')                                       CSC022
     C                   ROLBK                                                                CSC022
     C                   Else                                                                 CSC022
     C                   Seton                                        U7U8                    CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CSC022
     C                   ENDIF
     C     ZATRNKD0      CHAIN     SEISECSL1                          99
     C                   IF        *IN99 = *OFF
     C                   DELETE    SEISECSL1
                                                                                              CSC011
      ** Delete the record from the APILOGPD file                                             CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y' and S1SUPP = LIBR                             CSC011
     C                   EVAL      KMsgType = 'SESECS'                                        CSC011
     C                   EVAL      KFrntOffID = PFOTranSel                                    CSC011
     C                   EVAL      KTimeStamp = PTmeStpSel                                    CSC011
                                                                                              CSC011
     C     KAPILOG       CHAIN     APILOGL0                           89                      CSC011
                                                                                              CSC011
     C                   IF        *IN89 = *Off                                               CSC011
     C                   DELETE    APILOGL0                                                   CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF
      *                                                                                       CER001
      ** Delete extension record if LUX switchable is on                                      CER001
      *                                                                                       CER001
     C                   IF        ULX610  = 'Y'                                              CER001
      *                                                                                       CER001
      ** Delete IML extension files                                                           CER001
      *                                                                                       CER001
     C                   IF        ULX004   = 'Y'                                             CER001
     C     K@KEY1        CHAIN     RTVIDX1                                                    CER001
     C                   IF        %FOUND()                                                   CER001
     C                   DELETE    RTVIDX1                                                    CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C     K@KEY1        CHAIN     RTVIDX2                                                    CER001
     C                   IF        %FOUND()                                                   CER001
     C                   DELETE    RTVIDX2                                                    CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** Delete IBLC extension file                                                           CER001
      *                                                                                       CER001
     C                   IF        ULX043  = 'Y'                                              CER001
     C     K@KEY1        CHAIN     RTVIDX3                                                    CER001
     C                   IF        %FOUND()                                                   CER001
     C                   DELETE    RTVIDX3                                                    CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C/COPY WNCPYSRC,SESECSRC02
      *                                                                                      LLN022A
      ** If BOE installed delete extra data on the invalid file                              LLN022A
      *                                                                                      LLN022A
     C                   IF        LLN022 = 'Y'                                              LLN022A
     C     ZATRNKX0      CHAIN     ISECSD0                            99                     LLN022A
     C  N99              DELETE    ISECSD0                                                   LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                       CSC022
     C                   If        (CSC022 <> 'Y')                                            CSC022
     C                             or (CSC022 = 'Y' and WCommitSkip <> 'Y')                   CSC022
     C                   COMMIT
     C                   EndIf                                                                CSC022
     C                   ENDIF
      *
      ** If update not done due to record being updated by another
      ** workstation, display message "The last transaction was not
      ** applied to the database." to the next screen.
     C                   IF        RetCodeOut = '*RECUPD'
     C                   EVAL      PERRUP = 'Y'
     C                   ELSE
     C                   EVAL      PERRUP = 'N'
     C                   ENDIF
      *
      ** Read Next Subfile record or display Browse screen.
     C                   IF        PRDNB = 'Y'
     C                   EVAL      WSCRN = 'R'
     C                   ELSE
     C                   EVAL      WSCRN = 'B'
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       CER001
      *                                                               *                       CER001
      *  SRUPD2 -  Update the extension file 1                        *                       CER001
      *                                                               *                       CER001
      *****************************************************************                       CER001
     C     SRUPD2        BEGSR                                                                CER001
      *                                                                                       CER001
     C                   CALLB     'SESECS2UP'                                                CER001
     C                   PARM      DDACTN        ACTN                                         CER001
     C                   PARM      *BLANK        @RTCD                                        CER001
     C                   PARM      'Y'           WFIND                                        CER001
     C                   PARM                    NwExFilFmt2                                  CER001
     C                   PARM                    CrExFilFmt2                                  CER001
      *                                                                                       CER001
     C                   EVAL      RetCodeOut = @RTCD                                         CER001
      *                                                                                       CER001
     C                   ENDSR                                                                CER001
      *****************************************************************                       CER001
      /EJECT                                                                                  CER001
      *****************************************************************                       CER001
      *                                                               *                       CER001
      *  SRUPD3 -  Update the extension file 2                        *                       CER001
      *                                                               *                       CER001
      *****************************************************************                       CER001
     C     SRUPD3        BEGSR                                                                CER001
      *                                                                                       CER001
     C                   CALLB     'SESECS3UP'                                                CER001
     C                   PARM      DDACTN        ACTN                                         CER001
     C                   PARM      *BLANK        @RTCD                                        CER001
     C                   PARM      'Y'           WFIND                                        CER001
     C                   PARM                    NwExFilFmt3                                  CER001
     C                   PARM                    CrExFilFmt3                                  CER001
      *                                                                                       CER001
     C                   EVAL      RetCodeOut = @RTCD                                         CER001
      *                                                                                       CER001
     C                   ENDSR                                                                CER001
      *****************************************************************                       CER001
      /EJECT                                                                                  CER001
      *****************************************************************                       CER001
      *                                                               *                       CER001
      *  SRUPD4 - Update the extension file                           *                       CER001
      *                                                               *                       CER001
      *****************************************************************                       CER001
     C     SRUPD4        BEGSR                                                                CER001
      *                                                                                       CER001
     C                   CALLB     'SESECS4UP'                                                CER001
     C                   PARM      DDACTN        ACTN                                         CER001
     C                   PARM      *BLANK        @RTCD                                        CER001
     C                   PARM      'Y'           WFIND                                        CER001
     C                   PARM                    NwExFilFmt4                                  CER001
     C                   PARM                    CrExFilFmt4                                  CER001
      *                                                                                       CER001
     C                   EVAL      RetCodeOut = @RTCD                                         CER001
      *                                                                                       CER001
     C                   ENDSR                                                                CER001
      *****************************************************************                       CER001
      /EJECT                                                                                  CER001
      *****************************************************************
      *                                                               *
      *  SRRTVSecty - Retrieve security details                       *
      *                                                               *
      *****************************************************************
     C     SRRtvSecty    BEGSR

     C                   CALLB     'SESECSRTV'
      *                             =========
      *
      ** INPUT
      ** =====
      *
     C                   PARM                    RetCodeOut
      *
      ** Mode = '*FRONT' (Front office transaction interface)
      ** Mode = '      ' (Not front office transaction interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** Response mode
     C                   PARM                    PResponse
      *
      ** Action code
     C                   PARM                    DDACTN
      *
      ** Front office transaction Id
     C                   PARM                    PFOTRID
      *
      ** Security shortname
     C                   PARM                    DDSESN
      *
      ** Old Security from link proccessing
     C                   PARM      *BLANKS       POSESN
      *
      ** Process old security details indicator
     C                   PARM      'N'           PPOldSecDtl
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - single branch code
     C                   PARM                    BJSBRC
      *
      ** ZMUSER - default branch
     C                   PARM                    PDBRN
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM      *BLANKS       FldNameArr
     C                   PARM      *BLANKS       MsgIdArr
     C                   PARM      *BLANKS       MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM      0             IdX
      *
      ** OK action code
     C                   PARM      'Y'           OKACTN
      *
      ** OK security shortname
     C                   PARM      'Y'           OKSESN
      *
      ** Securities retrieved from file - file format
     C                   PARM      *BLANKS       CrSEFilFmt
      *
      ** Investment type details
     C                   PARM      *BLANKS       PINVTPD

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCvtSecty - Convert security details to screen format       *
      *                                                               *
      *****************************************************************
     C     SRCvtSecty    BEGSR

     C                   CALLB     'SESECSCVT'
      *                             =========
      *
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Securities retrieved from file - file format
     C                   PARM                    CrSEFilFmt
      *
      ** Investment processing type from PF/INVTPD
     C                   PARM                    F1PROT
      *
      ** Action Code
     C                   PARM                    DDACTN
      *
      ** Passed other information coming from link proccessing
     C                   PARM      *BLANKS       POthInf
      *
      ** Process old security details indicator
     C                   PARM      'N'           PPOldSecDtl
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - date format indicator
     C                   PARM                    BJDFIN
      *
      ** SDBANK - midas run day number
     C                   PARM                    BJRDNB
      *
      ** SDMMOD - interest risk management
     C                   PARM                    BGRKMG
      *
      ** SDGELR - plato interface
     C                   PARM                    BGN2ST
      *
      ** SDMMOD - private banking
     C                   PARM                    BGN4ST
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** EMU securities decimals on nominals
     C                   PARM                    CEU018
      *
      ** Effect of holidays on FRN coupon dates
     C                   PARM                    CSE005
      *
      ** MT5xx message generation
     C                   PARM                    S01401
      *                                                                         CSE023
      ** US Withholding tax treaty                                              CSE023
     C                   PARM                    CSE023                         CSE023
      *                                                                                       CSD006
      ** Market Data Feed                                                                     CSD006
     C                   PARM                    CSD006                                       CSD006
      *                                                                                       CAP060
      ** Midas APIs Sec Prices                                                                CAP060
     C                   PARM                    CAP060                                       CAP060
      *                                                                                       CSE031
      ** Coupon Fixing for Floating Rate Notes                                                CSE031
     C                   PARM                    CSE031                                       CSE031
                                                                                              CAS006
      ** Hedge Accounting Phase B                                                             CAS006
     C                   PARM                    CAS006                                       CAS006
      *                                                                                       CSE037
      ** Countervalue rounding                                                                CSE037
     C                   PARM                    CSE037                                       CSE037
                                                                                              CGL014
      ** Collaterals Processing                                                               CGL014
     C                   PARM                    CGL014                                       CGL014
      *                                                                                      BUG9530
      ** Multiple Holidays                                                                   BUG9530
      *                                                                                      BUG9530
     C                   PARM                    CSE071                                      BUG9530
                                                                                              248555
      ** Taxation on Savings Income                                                           248555
     C                   PARM                    CGL032                                       248555
      *
      ** OUTPUT
      ** ======
      *
      ** Security screen 1 details retrieved from file - screen format
     C                   PARM                    CrSE1ScnFmt
      *
      ** Security screen 2 details retrieved from file - screen format
     C                   PARM                    CrSE2ScnFmt
      *
      ** Security screen 3 details retrieved from file - screen format
     C                   PARM                    CrSE3ScnFmt
      *                                                                                       CSE031
      ** Security screen 4 details retrieved from file - screen format                        CSE031
     C                   PARM                    CrSE4ScnFmt                                  CSE031
                                                                                              CAS006
      ** Security Screen 5 Details Retrieved From File - Screen Format                        CAS006
     C                   PARM                    CrSE5ScnFmt                                  CAS006
      *                                                                                      BUG9530
      ** Security Screen 6 Details Retrieved From File - Screen Format                       BUG9530
      *                                                                                      BUG9530
     C                   PARM                    CrSE6ScnFmt                                 BUG9530
      *
      ** Last Coupon Date
     C                   PARM      *BLANKS       PLCPN
      *
      ** Next Coupon Date
     C                   PARM      *BLANKS       PNCD
                                                                                              CSC011
      ** Linked Maintenance Flag                                                              CSC011
                                                                                              CSC011
     C                   PARM                    PParmLink                                    CSC011

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDTASUBS - Data Substitution                                *
      *                                                               *
      *****************************************************************
     C     SRDtaSubs     BEGSR
      *
      ** Substitute the data for the various parts of the transaction.
     C                   IF        WSUBSE1 = 'Y'

     C                   CLEAR                   PIncData
     C                   CLEAR                   PCurData

     C                   CALLB     'APDTASUBS'
      *                             =========
      ** Return Code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Substitution Character
     C                   PARM                    GHSUBS
      *
      ** Incoming Data
     C                   PARM      NwSE1ScnFmt   PIncData
      *
      ** Current Data
     C                   PARM      CrSE1ScnFmt   PCurData

     C                   MOVEL     PIncData      NwSE1ScnFmt

     C                   ENDIF

     C                   IF        WSUBSE2 = 'Y'

     C                   CLEAR                   PIncData
     C                   CLEAR                   PCurData

     C                   CALLB     'APDTASUBS'
      *                             =========
      ** Return Code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Substitution Character
     C                   PARM                    GHSUBS
      *
      ** Incoming Data
     C                   PARM      NwSE2ScnFmt   PIncData
      *
      ** Current Data
     C                   PARM      CrSE2ScnFmt   PCurData

     C                   MOVEL     PIncData      NwSE2ScnFmt

     C                   ENDIF

     C                   IF        WSUBSE3 = 'Y'

     C                   CLEAR                   PIncData
     C                   CLEAR                   PCurData

     C                   CALLB     'APDTASUBS'
      *                             =========
      ** Return Code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Substitution Character
     C                   PARM                    GHSUBS
      *
      ** Incoming Data
     C                   PARM      NwSE3ScnFmt   PIncData
      *
      ** Current Data
     C                   PARM      CrSE3ScnFmt   PCurData

     C                   MOVEL     PIncData      NwSE3ScnFmt

     C                   ENDIF
                                                                                              CAS006
     C                   IF        WSUBSE4 = 'Y'                                              CAS006
                                                                                              CAS006
     C                   CLEAR                   PIncData                                     CAS006
     C                   CLEAR                   PCurData                                     CAS006
                                                                                              CAS006
     C                   CALLB     'APDTASUBS'                                                CAS006
      *                             =========                                                 CAS006
      ** Return Code                                                                          CAS006
     C                   PARM      *BLANKS       RetCodeOut                                   CAS006
      *                                                                                       CAS006
      ** Substitution Character                                                               CAS006
     C                   PARM                    GHSUBS                                       CAS006
      *                                                                                       CAS006
      ** Incoming Data                                                                        CAS006
     C                   PARM      NwSE4ScnFmt   PIncData                                     CAS006
      *                                                                                       CAS006
      ** Current Data                                                                         CAS006
     C                   PARM      CrSE4ScnFmt   PCurData                                     CAS006
                                                                                              CAS006
     C                   MOVEL     PIncData      NwSE4ScnFmt                                  CAS006
                                                                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   IF        WSUBSE5 = 'Y'                                              CAS006
                                                                                              CAS006
     C                   CLEAR                   PIncData                                     CAS006
     C                   CLEAR                   PCurData                                     CAS006
                                                                                              CAS006
     C                   CALLB     'APDTASUBS'                                                CAS006
      *                             =========                                                 CAS006
      ** Return Code                                                                          CAS006
     C                   PARM      *BLANKS       RetCodeOut                                   CAS006
      *                                                                                       CAS006
      ** Substitution Character                                                               CAS006
     C                   PARM                    GHSUBS                                       CAS006
      *                                                                                       CAS006
      ** Incoming Data                                                                        CAS006
     C                   PARM      NwSE5ScnFmt   PIncData                                     CAS006
      *                                                                                       CAS006
      ** Current Data                                                                         CAS006
     C                   PARM      CrSE5ScnFmt   PCurData                                     CAS006
                                                                                              CAS006
     C                   MOVEL     PIncData      NwSE5ScnFmt                                  CAS006
                                                                                              CAS006
     C                   ENDIF                                                                CAS006

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSNDM1 - Send error message to 1st screen                   *
      *                                                               *
      *****************************************************************
     C     SRSndM1       BEGSR
      *
      ** Reset array index.
     C                   EVAL      Ex = 0
      *
      ** If error occurred in updating last transaction,
      ** display error message on the screen (first message).
      *
     C                   IF        PERRUP = 'Y'
     C                   ADD       1             Ex
     C                   MOVEL     '*ANY'        FldNameArr(Ex)
     C                   MOVEL     'APM1000'     MsgIdArr(Ex)
     C                   MOVE      'N'           PERRUP
     C                   ENDIF
      *
      ** If there are fundamental errors in this transaction, identify
      ** this fact.
     C                   IF        OKACTN = 'N' OR OKSESN = 'N'
     C                   EVAL      Ex = Ex + 1
     C                   MOVE      '*ANY'        FldNameArr(Ex)
     C                   MOVE      'APM0110'     MsgIdArr(Ex)
     C                   ENDIF
      *
      ** Initialise work array for error indicators.
     C                   MOVEA     SEESEC1       WEI
      *
      ** Read security details validation error messages for
      ** 1st screen.
     C                   EVAL      KABFIELDID = 0

     C     ZATRNKD1      SETLL     ZATRNERRD0
     C     ZATRNKD0      READE     ZATRNERRD0                             99
      *
      ** Add error message read for 1st screen to array and set
      ** OK flag for field to 'N'.
     C/COPY WNCPYSRC,SESECSRC03
     C                   DOW       *IN99 = *OFF AND
     C                             ABFIELDID <= WFldOffSet2

     C/COPY WNCPYSRC,SESECSRC06
      *                                                                                      LLN022A
      ** If BOE installed                                                                    LLN022A
      *                                                                                      LLN022A
     C                   IF        LLN022 = 'Y'                                              LLN022A
      *                                                                                      LLN022A
      ** Only do current processing if the field in error is not                             LLN022A
      ** one of the extra data fields.                                                       LLN022A
      *                                                                                      LLN022A
     C                   MOVEL     ABFIELDNAM    ULPRE             2                         LLN022A
     C     ULPRE         IFEQ      '#S'                                                      LLN022A
     C                   GOTO      SKIPPROC                                                  LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                      LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                      LLN022A
     C     ABMSGID       LOOKUP    MsgIdArr(1)                            98
      *
      ** If message already present in array, disregard it
      ** to avoid duplicate messages from being displayed.
     C                   IF        *IN98 <> *ON
     C                   ADD       1             Ex
     C                   MOVEL     ABFIELDNAM    FldNameArr(Ex)
     C                   MOVEL     ABMSGID       MsgIdArr(Ex)
     C                   ENDIF

     C                   Z-ADD     ABFIELDID     Fx
     C                   SUB       WFldOffset1   Fx

     C                   IF        Fx < 1 OR Fx > 60
     C                   Z-ADD     1             Fx
     C                   ENDIF
     C/COPY WNCPYSRC,SESECSRC04

     C                   MOVE      'N'           WEI(Fx)
     C/COPY WNCPYSRC,SESECSRC05
      *                                                                                      LLN022A
     C     SKIPPROC      TAG                                                                 LLN022A
      *                                                                                      LLN022A
     C     ZATRNKD0      READE     ZATRNERRD0                             99

     C                   ENDDO
      *
      ** Update error indicators using work array.
     C                   MOVEA     WEI           SEESEC1
      *
      ** Save error indicators and messages on 1st screen.
     C                   MOVE      SEESEC1       SEESEC1x
     C                   MOVEA     FldNameArr    FldNameAr1
     C                   MOVEA     MsgIdArr      MsgIdAr1
     C                   MOVEA     MsgDtaArr     MsgDtaAr1
     C                   EVAL      ID1 = Ex

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSNDM2 - Send error message to 2nd screen                   *
      *                                                               *
      *****************************************************************
     C     SRSndM2       BEGSR
      *
      ** Reset array index.
     C                   EVAL      Ex = 0
      *
      ** Initialise work array for error indicators.
     C                   MOVEA     SEESEC2       WEI
      *
      ** Read security details validation error messages for
      ** 2nd screen.
     C                   EVAL      KABFIELDID = WfldOffset2

     C     ZATRNKD1      SETLL     ZATRNERRD0
     C     ZATRNKD0      READE     ZATRNERRD0                             99
      *
      ** Add error message read for 2nd screen to array and set
      ** OK flag for field to 'N'.
     C                   DOW       *IN99 = *OFF AND
     C                             ABFIELDID > WFldOffSet2 AND
     C                             ABFIELDID <= WFldOffSet3

     C     ABMSGID       LOOKUP    MsgIdArr(1)                            98
      *
      ** If message already present in array, disregard it
      ** to avoid duplicate messages from being displayed.
     C                   IF        *IN98 <> *ON
     C                   ADD       1             Ex
     C                   MOVEL     ABFIELDNAM    FldNameArr(Ex)
     C                   MOVEL     ABMSGID       MsgIdArr(Ex)
     C                   ENDIF

     C                   Z-ADD     ABFIELDID     Fx
     C                   SUB       WFldOffset2   Fx

     C**********         IF        Fx < 1 OR Fx > 60                                          CAS006
     C                   IF        Fx < 1 OR Fx > 64                                          CAS006
     C                   Z-ADD     1             Fx
     C                   ENDIF

     C                   MOVE      'N'           WEI(Fx)
     C     ZATRNKD0      READE     ZATRNERRD0                             99

     C                   ENDDO
      *
      ** Update error indicators using work array.
     C                   MOVEA     WEI           SEESEC2
      *
      ** Save error indicators and messages on 2nd screen.
     C                   MOVE      SEESEC2       SEESEC2x
     C                   MOVEA     FldNameArr    FldNameAr2
     C                   MOVEA     MsgIdArr      MsgIdAr2
     C                   MOVEA     MsgDtaArr     MsgDtaAr2
     C                   EVAL      ID2 = Ex

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSNDM3 - Send error message to 3rd screen                   *
      *                                                               *
      *****************************************************************
     C     SRSndM3       BEGSR
      *
      ** Reset array index.
     C                   EVAL      Ex = 0
      *
      ** Initialise work array for error indicators.
     C                   MOVEA     SEESEC3       WEI
      *
      ** Read security details validation error messages for
      ** 3rd screen.
     C                   EVAL      KABFIELDID = WfldOffset3

     C     ZATRNKD1      SETLL     ZATRNERRD0
     C     ZATRNKD0      READE     ZATRNERRD0                             99
      *
      ** Add error message read for 3rd screen to array and set
      ** OK flag for field to 'N'.
     C                   DOW       *IN99 = *OFF AND
     C                             ABFIELDID > WFldOffSet3
     C                             And ABFIELDID <= WFldOffSet4                               CER001

     C     ABMSGID       LOOKUP    MsgIdArr(1)                            98
      *
      ** If message already present in array, disregard it
      ** to avoid duplicate messages from being displayed.
     C                   IF        *IN98 <> *ON
     C                   ADD       1             Ex
     C                   MOVEL     ABFIELDNAM    FldNameArr(Ex)
     C                   MOVEL     ABMSGID       MsgIdArr(Ex)
     C                   ENDIF

     C                   Z-ADD     ABFIELDID     Fx
     C                   SUB       WFldOffset3   Fx

     C                   IF        Fx < 1 OR Fx > 60
     C                   Z-ADD     1             Fx
     C                   ENDIF

     C                   MOVE      'N'           WEI(Fx)
     C     ZATRNKD0      READE     ZATRNERRD0                             99

     C                   ENDDO
      *
      ** Update error indicators using work array.
     C                   MOVEA     WEI           SEESEC3
      *
      ** Save error indicators and messages on 3rd screen.
     C                   MOVE      SEESEC3       SEESEC3x
     C                   MOVEA     FldNameArr    FldNameAr3
     C                   MOVEA     MsgIdArr      MsgIdAr3
     C                   MOVEA     MsgDtaArr     MsgDtaAr3
     C                   EVAL      ID3 = Ex

     C                   ENDSR
      *****************************************************************                       CAS006
      /EJECT                                                                                  CAS006
      *****************************************************************                       CAS006
      *                                                               *                       CAS006
      *  SRSndM5 - Send error messages to the 5th screen.             *                       CAS006
      *                                                               *                       CAS006
      *****************************************************************                       CAS006
     C     SRSndM5       BEGSR                                                                CAS006
                                                                                              CAS006
      ** Reset array index.                                                                   CAS006
     C                   EVAL      Ex = 0                                                     CAS006
                                                                                              CAS006
      ** Initialise work array for error indicators.                                          CAS006
     C                   MOVEA     SEESEC5       WEI                                          CAS006
                                                                                              CAS006
      ** Read security details validation error messages for                                  CAS006
      ** 3rd screen.                                                                          CAS006
     C                   EVAL      KABFIELDID = WfldOffset5                                   CAS006
                                                                                              CAS006
     C     ZATRNKD1      SETLL     ZATRNERRD0                                                 CAS006
     C     ZATRNKD0      READE     ZATRNERRD0                             99                  CAS006
                                                                                              CAS006
      ** Add error message read for 5rd screen to array and set                               CAS006
      ** the OK flag for field to 'N'.                                                        CAS006
     C                   DOW       *IN99 = *OFF AND                                           CAS006
     C                             ABFIELDID > WFldOffSet5                                    CAS006
     C                   IF        ULX610  = 'N' Or                                           CER001
     C                             ULX610  = 'Y' And ABFIELDID <= WFldOffsetExt               CER001
                                                                                              CAS006
     C     ABMSGID       LOOKUP    MsgIdArr(1)                            98                  CAS006
                                                                                              CAS006
      ** If message already present in array, disregard it                                    CAS006
      ** to avoid duplicate messages from being displayed.                                    CAS006
     C                   IF        *IN98 <> *ON                                               CAS006
     C                   ADD       1             Ex                                           CAS006
     C                   MOVEL     ABFIELDNAM    FldNameArr(Ex)                               CAS006
     C                   MOVEL     ABMSGID       MsgIdArr(Ex)                                 CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   Z-ADD     ABFIELDID     Fx                                           CAS006
     C                   SUB       WFldOffset5   Fx                                           CAS006
                                                                                              CAS006
     C                   IF        Fx < 1 OR Fx > 2                                           CAS006
     C                   Z-ADD     1             Fx                                           CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   MOVE      'N'           WEI(Fx)                                      CAS006
     C                   ENDIF                                                                CER001
     C     ZATRNKD0      READE     ZATRNERRD0                             99                  CAS006
                                                                                              CAS006
     C                   ENDDO                                                                CAS006
                                                                                              CAS006
      ** Update error indicators using work array.                                            CAS006
     C                   MOVEA     WEI           SEESEC5                                      CAS006
                                                                                              CAS006
      ** Save error indicators and messages on 5th screen.                                    CAS006
     C                   MOVE      SEESEC5       SEESEC5x                                     CAS006
     C                   MOVEA     FldNameArr    FldNameAr5                                   CAS006
     C                   MOVEA     MsgIdArr      MsgIdAr5                                     CAS006
     C                   MOVEA     MsgDtaArr     MsgDtaAr5                                    CAS006
     C                   EVAL      ID5 = Ex                                                   CAS006
                                                                                              CAS006
     C                   ENDSR                                                                CAS006
      *****************************************************************
      *****************************************************************                       CER001
      /EJECT                                                                                  CER001
      *****************************************************************                       CER001
      *                                                               *                       CER001
      *  SRRTVLUX - Retrieve LUX invalid records                      *                       CER001
      *                                                               *                       CER001
      *****************************************************************                       CER001
     C     SRRTVLUX      BEGSR                                                                CER001
     C                   EVAL      L1SESN  = DDSESN                                           CER001
     C                   EVAL      L1FOTR  = PFOTranSel                                       CER001
     C                   EVAL      PDTMST  = PTmeStpSel                                       CER001
     C                   EVAL      L1ISNO  = S1ISNO                                           CER001
     C                   EVAL      WFIND   =  'Y'                                             CER001
      *                                                                                       CER001
      ** ER securities details                                                                CER001
      *                                                                                       CER001
     C                   IF        ULX004   = 'Y'                                             CER001
     C     K@KEY1        CHAIN(N)  RTVIDX1                                                    CER001
     C                   IF        %FOUND()                                                   CER001
     C                   EVAL      L4LXPORE = #4LXPORE                                        CER001
     C                   EVAL      #1DEXT   = 'Y'                                             CER001
     C                   ELSE                                                                 CER001
     C                   EVAL      WFIND    = *BLANKS                                         CER001
     C                   EVAL      L4LXPORE = 'N'                                             CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** ER securities detials                                                                CER001
      *                                                                                       CER001
     C     K@KEY1        CHAIN(N)  RTVIDX2                                                    CER001
     C                   IF        %FOUND                                                     CER001
     C                   EXSR      SRFTOSIDX5                                                 CER001
     C                   ELSE                                                                 CER001
     C                   EXSR      SRINZIDX5                                                  CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** IBLC 2002 Issuer Type                                                                CER001
      *                                                                                       CER001
     C                   IF        ULX043   = 'Y'                                             CER001
     C     K@KEY1        CHAIN(N)  RTVIDX3                                                    CER001
     C                   IF        %FOUND()                                                   CER001
     C                   EVAL      LLLXISTP = #LLXISTP                                        CER001
     C                   EVAL      #3DEXT   = 'Y'                                             CER001
     C                   ELSE                                                                 CER001
     C                   EVAL      WFIND    = *BLANKS                                         CER001
     C                   EVAL      LLLXISTP = 'BO'                                            CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDSR                                                                CER001
      *****************************************************************                       CER001
      /EJECT                                                                                  CER001
      *****************************************************************                       CER001
      *                                                               *                       CER001
      *  SRFTOSIDX5 - Move file fields to screen (SECTYDY6)           *                       CER001
      *                                                               *                       CER001
      *****************************************************************                       CER001
     C     SRFTOSIDX5    BEGSR                                                                CER001
     C                   EVAL      L6LXLUSU = %CHAR(#6LXLUSU)                                 CER001
     C                   EVAL      L6LXSUBR = #6LXSUBR                                        CER001
     C                   EVAL      L6LXIM93 = %CHAR(#6LXIM93)                                 CER001
     C                   EVAL      L6LXCLAT = %CHAR(#6LXCLAT)                                 CER001
     C                   EVAL      L6LXSECT = %CHAR(#6LXSECT)                                 CER001
     C                   EVAL      L6LXROFC = #6LXROFC                                        CER001
     C                   EVAL      L6LXRATC = #6LXRATC                                        CER001
     C                   EVAL      L6LXVOTR = #6LXVOTR                                        CER001
     C                   EVAL      L6LXSECD = #6LXSECD                                        CER001
     C                   EVAL      L6LXSNCD = #6LXSNCD                                        CER001
     C                   EVAL      L6LXEEEM = #6LXEEEM                                        CER001
     C                   EVAL      L6LXQUOT = #6LXQUOT                                        CER001
     C                   EVAL      #2DEXT   = 'Y'                                             CER001
     C                   ENDSR                                                                CER001
      *****************************************************************                       CER001
      /EJECT                                                                                  CER001
      *****************************************************************                       CER001
      *                                                               *                       CER001
      *  SRINZIDX5 - Initialize screen fields  (SECTYDY6)             *                       CER001
      *                                                               *                       CER001
      *****************************************************************                       CER001
     C     SRINZIDX5     BEGSR                                                                CER001
     C                   EVAL      WFIND    = *BLANKS                                         CER001
     C                   EVAL      L6LXLUSU = *ZERO                                           CER001
     C                   EVAL      L6LXSUBR = 'N'                                             CER001
     C                   EVAL      L6LXIM93 = *ZERO                                           CER001
     C                   EVAL      L6LXCLAT = *ZERO                                           CER001
     C                   EVAL      L6LXSECT = *ZERO                                           CER001
     C                   EVAL      L6LXROFC = *BLANKS                                         CER001
     C                   EVAL      L6LXRATC = *BLANKS                                         CER001
     C                   EVAL      L6LXVOTR = *BLANKS                                         CER001
     C                   EVAL      L6LXSECD = *BLANKS                                         CER001
     C                   EVAL      L6LXSNCD = *BLANKS                                         CER001
      *                                                                                       CER001
      ** Note: the fix 207361 change the default value of EEEM (see                           CER001
      **       SESELXSX6) but, when a default is changed, it should be                        CER001
      **       changed everywhere. Hence the following change:                                CER001
      *                                                                                       CER001
     C                   EVAL      L6LXEEEM = 'N'                                             CER001
      *                                                                                       CER001
      ** Now, the normal ULX046 changes:                                                      CER001
      *                                                                                       CER001
     C                   IF        ULX046   = 'Y'                                             CER001
     C                   EVAL      L6LXQUOT = 'Y'                                             CER001
     C                   ELSE                                                                 CER001
     C                   EVAL      L6LXQUOT = *BLANK                                          CER001
     C                   ENDIF                                                                CER001
     C                   ENDSR                                                                CER001
      *****************************************************************                       CER001
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRENDP - Set Program to End                                  *
      *                                                               *
      *****************************************************************
     C     SREndP        BEGSR
      *
      ** Rollback uncommitted file changes.
      *                                                                                       CSC022
     C                   If        (CSC022 <> 'Y')                                            CSC022
     C                             or (CSC022 = 'Y' and WCommitSkip <> 'Y')                   CSC022
     C                   ROLBK
     C                   EndIf                                                                CSC022
     C                   EVAL      WSCRN = 'T'

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRESETERR - Reset Error Fields                              *
      *                                                               *
      *****************************************************************
     C     SRResetErr    BEGSR

     C                   CLEAR                   FldNameArr
     C                   CLEAR                   MsgIdArr
     C                   CLEAR                   MsgDtaArr
     C                   CLEAR                   IDx

     C                   CLEAR                   WFldNamArr
     C                   CLEAR                   WMsgIdArr
     C                   CLEAR                   WMsgDtaArr
     C                   CLEAR                   WIDx

     C                   MOVE      *ALL'Y'       SEESEC1
     C                   MOVE      *ALL'Y'       SEESEC2
     C                   MOVE      *ALL'Y'       SEESEC3
     C                   MOVE      *ALL'Y'       SEESEC4                                      CAS006
     C                   MOVE      *ALL'Y'       SEESEC5                                      CAS006

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Access Bank details.
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error.
     C     PRTCD         IFNE      *BLANKS
     C                   EVAL      DBKey = POPTN
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   Z-ADD     1             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access Midas Modules details.
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** Database error.
     C     PRTCD         IFNE      *BLANKS
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBFile = 'SDMMODPD'
     C                   Z-ADD     2             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access ICD details for securities trading.
     C                   CALL      'AOSTRDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDSTRD        PARM      SDSTRD        DSSDY
      *
      ** Database error
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBKey = POPTN
     C                   EVAL      DBFile = 'SDSTRDPD'
     C                   Z-ADD     3             DBase
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access API ICD details.
     C                   CALLB     'AOAPIR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDAPI         PARM      SDAPI         DSFDY
      *
      ** Database error.
     C     PRTCD         IFNE      *BLANKS
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBFile = 'SDAPIPD'
     C                   Z-ADD     4             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access SAR file to determine if CSE005 (Effect of holidays
      ** on FRN coupon dates) is installed.
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSE005'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C                   EVAL      DBKey = 'CSE005'
     C                   EVAL      DBFile = 'SCSARDPD'
     C                   Z-ADD     5             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF

     C     PRTCD         IFEQ      *BLANK
     C                   EVAL      CSE005 = 'Y'
     C                   ELSE
     C                   EVAL      CSE005 = 'N'
     C                   ENDIF
      *
      ** Access SAR file to determine if CSE007 (Corporate Actions)
      ** is installed.
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSE007'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C                   EVAL      DBKey = 'CSE007'
     C                   EVAL      DBFile = 'SCSARDPD'
     C                   Z-ADD     6             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF

     C     PRTCD         IFEQ      *BLANK
     C                   EVAL      CSE007 = 'Y'
     C                   ELSE
     C                   EVAL      CSE007 = 'N'
     C                   ENDIF
      *
      ** Access SAR file to determine if CSE011 (Duplicate Security
      ** Codes Check) is installed.
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSE011'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C                   EVAL      DBKey = 'CSE011'
     C                   EVAL      DBFile = 'SCSARDPD'
     C                   Z-ADD     7             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF

     C     PRTCD         IFEQ      *BLANK
     C                   EVAL      CSE011 = 'Y'
     C                   ELSE
     C                   EVAL      CSE011 = 'N'
     C                   ENDIF
      *
      ** Access SAR file to determine if CEU017 (Securities Redenomination)
      ** is installed.
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CEU017'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C                   EVAL      DBKey = 'CEU017'
     C                   EVAL      DBFile = 'SCSARDPD'
     C                   Z-ADD     8             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF

     C     PRTCD         IFEQ      *BLANK
     C                   EVAL      CEU017 = 'Y'
     C                   ELSE
     C                   EVAL      CEU017 = 'N'
     C                   ENDIF
      *
      ** Access SAR file to determine if CEU018 (Securities Decimals
      ** on Nominals) is installed.
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CEU018'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C                   EVAL      DBKey = 'CEU018'
     C                   EVAL      DBFile = 'SCSARDPD'
     C                   Z-ADD     9             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF

     C     PRTCD         IFEQ      *BLANK
     C                   EVAL      CEU018 = 'Y'
     C                   ELSE
     C                   EVAL      CEU018 = 'N'
     C                   ENDIF
      *
      ** Access SAR file to determine if S01401 (MT5xx Message Generation)
      ** is installed.
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'S01401'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C                   EVAL      DBKey = 'S01401'
     C                   EVAL      DBFile = 'SCSARDPD'
     C                   Z-ADD     10            DBASE
     C                   EXSR      *PSSR
     C                   ENDIF

     C     PRTCD         IFEQ      *BLANK
     C                   EVAL      S01401 = 'Y'
     C                   ELSE
     C                   EVAL      S01401 = 'N'
     C                   ENDIF
      *
      ** Access SAR file to determine if S01511 (Market Migration)
      ** is installed.
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'S01511'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C                   EVAL      DBKey = 'S01511'
     C                   EVAL      DBFile = 'SCSARDPD'
     C                   Z-ADD     11            DBASE
     C                   EXSR      *PSSR
     C                   ENDIF

     C     PRTCD         IFEQ      *BLANK
     C                   EVAL      S01511 = 'Y'
     C                   ELSE
     C                   EVAL      S01511 = 'N'
     C                   ENDIF
      *                                                                         CSE023
      ** Access SAR file to determine if CSE023                                 CSE023
      ** (US Withholding tax treaty) is installed.                              CSE023
      *                                                                         CSE023
     C                   CALLB     'AOSARDR0'                                   CSE023
     C                   PARM      *BLANKS       PRTCD                          CSE023
     C                   PARM      '*VERIFY'     POPTN                          CSE023
     C                   PARM      'CSE023'      PSARD                          CSE023
     C     SCSARD        PARM      SCSARD        DSFDY                          CSE023
      *                                                                         CSE023
      ** An NRF (No Record Found) return code is valid.                         CSE023
      ** Issue database error only for error return codes.                      CSE023
      *                                                                         CSE023
     C                   IF        PRTCD <> *BLANKS AND                         CSE023
     C                             PRTCD <> '*NRF   '                           CSE023
     C                   EVAL      DBKEY = 'CSE023'                             CSE023
     C                   EVAL      DBFILE = 'SCSARDPD'                          CSE023
     C                   Z-ADD     12            DBASE                          CSE023
     C                   EXSR      *PSSR                                        CSE023
     C                   ENDIF                                                  CSE023
                                                                                CSE023
     C                   IF        PRTCD = *BLANKS                              CSE023
     C                   EVAL      CSE023 = 'Y'                                 CSE023
     C                   ELSE                                                   CSE023
     C                   EVAL      CSE023 = 'N'                                 CSE023
     C                   ENDIF                                                  CSE023
      *                                                                                       CSD006
      ** Access SAR details file to determine if MDF Switchable feature                       CSD006
      ** is switched on                                                                       CSD006
      *                                                                                       CSD006
     C                   CALLB     'AOSARDR0'                                                 CSD006
     C                   PARM      *BLANKS       @RTCD                                        CSD006
     C                   PARM      '*VERIFY'     @OPTN                                        CSD006
     C                   PARM      'CSD006'      @SARD             6                          CSD006
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD006
     C     @RTCD         IFEQ      *BLANK                                                     CSD006
     C                   MOVEL     'Y'           CSD006            1                          CSD006
     C                   ELSE                                                                 CSD006
     C                   MOVEL     'N'           CSD006                                       CSD006
     C                   END                                                                  CSD006
                                                                                              CSD006
      *                                                                                       CSD006
      ** Access SAR details file to determine if Midas APIs Sec Price                         CAP060
      ** is switched on                                                                       CAP060
      *                                                                                       CAP060
     C                   CALLB     'AOSARDR0'                                                 CAP060
     C                   PARM      *BLANKS       @RTCD                                        CAP060
     C                   PARM      '*VERIFY'     @OPTN                                        CAP060
     C                   PARM      'CAP060'      @SARD             6                          CAP060
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP060
     C     @RTCD         IFEQ      *BLANK                                                     CAP060
     C                   MOVEL     'Y'           CAP060            1                          CAP060
     C                   ELSE                                                                 CAP060
     C                   MOVEL     'N'           CAP060                                       CAP060
     C                   END                                                                  CAP060
                                                                                              CAP060
      *                                                                         CSE031
      ** Access SAR file to determine if CSE031                                 CSE031
      ** (Coupon Fixing for Floating Rate Notes) is installed.                  CSE031
      *                                                                         CSE031
     C                   CALLB     'AOSARDR0'                                   CSE031
     C                   PARM      *BLANKS       PRtcd                          CSE031
     C                   PARM      '*VERIFY'     POptn                          CSE031
     C                   PARM      'CSE031'      PSARD                          CSE031
     C     SCSARD        PARM      SCSARD        DSFDY                          CSE031
      *                                                                         CSE031
      ** An NRF (No Record Found) return code is valid.                         CSE031
      ** Issue database error only for error return codes.                      CSE031
      *                                                                         CSE031
     C                   IF        PRtcd <> *BLANKS AND                         CSE031
     C                             PRtcd <> '*NRF   '                           CSE031
     C                   EVAL      DBKey = 'CSE031'                             CSE031
     C                   EVAL      DBFile = 'SCSARDPD'                          CSE031
     C                   Z-ADD     12            DBase                          CSE031
     C                   EXSR      *PSSR                                        CSE031
     C                   ENDIF                                                  CSE031
                                                                                CSE031
     C                   IF        PRtcd = *BLANKS                              CSE031
     C                   EVAL      CSE031 = 'Y'                                 CSE031
     C                   ELSE                                                   CSE031
     C                   EVAL      CSE031 = 'N'                                 CSE031
     C                   ENDIF                                                  CSE031
                                                                                CSE031
      ** Check if CSC011 is installed                                                         CSC011
                                                                                              CSC011
     C                   EVAL      WkDate = BJRDNB                                            CSC011
     C                   EVAL      WkNext = BJDNWD                                            CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
                                                                                              CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *Blanks       PRTCD                                        CSC011
     C                   PARM      '*VERIFY'     POPTN                                        CSC011
     C                   PARM      'CSC011'      PSARD                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
     C                   IF        PRTCD = *Blanks                                            CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
     C                   OPEN      APILOGL0                                                   CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IN        SDSTAT                                                     CSC011
     C                   IF        S1SUPP = LIBR                                              CSC011
     C                   EVAL      WkDate = S1DATE                                            CSC011
     C                   EVAL      WkNext = S1NEXT                                            CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ELSE                                                                 CSC011
                                                                                              CSC011
     C                   IF        PRTCD <> '*NRF   '                                         CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBKEY  = 'CSC011'                                          CSC011
     C                   EVAL      DBASE  = 16                                                CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CAS006
      ** Check if CAS006 is enabled.                                                          CAS006
                                                                                              CAS006
     C                   CALLB     'AOSARDR0'                                                 CAS006
     C                   PARM      *BLANKS       PRTCD                                        CAS006
     C                   PARM      '*VERIFY'     POPTN                                        CAS006
     C                   PARM      'CAS006'      PSARD                                        CAS006
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS006
                                                                                              CAS006
     C                   IF        PRTCD = *BLANKS                                            CAS006
     C                   EVAL      CAS006 = 'Y'                                               CAS006
     C                   ELSE                                                                 CAS006
                                                                                              CAS006
     C                   IF        PRTCD <> '*NRF'                                            CAS006
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS006
     C                   EVAL      DBKEY  = 'CAS006'                                          CAS006
     C                   EVAL      DBASE  = 17                                                CAS006
     C                   EXSR      *PSSR                                                      CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDIF                                                                CAS006
      *                                                                                       CSE037
      ** Access SAR details file to determine if Countervalue rounding is on                  CSE037
      *                                                                                       CSE037
     C                   CALLB     'AOSARDR0'                                                 CSE037
     C                   PARM      *BLANKS       @RTCD                                        CSE037
     C                   PARM      '*VERIFY'     @OPTN                                        CSE037
     C                   PARM      'CSE037'      @SARD                                        CSE037
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE037
     C     @RTCD         IFEQ      *BLANK                                                     CSE037
     C                   MOVEL     'Y'           CSE037                                       CSE037
     C                   ELSE                                                                 CSE037
     C                   MOVEL     'N'           CSE037                                       CSE037
     C                   END                                                                  CSE037
                                                                                              CGL014
      ** Check if enhancement CGL014 (Collaterals Processing) is on                           CGL014
                                                                                              CGL014
     C                   CALLB     'AOSARDR0'                                                 CGL014
     C                   PARM      *BLANKS       PRTCD                                        CGL014
     C                   PARM      '*VERIFY'     POPTN                                        CGL014
     C                   PARM      'CGL014'      PSARD                                        CGL014
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL014
                                                                                              CGL014
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CGL014
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CGL014
     C                   EVAL      DBKEY  = 'CGL014'                                          CGL014
     C                   EVAL      DBASE  = 13                                                CGL014
     C                   EXSR      *PSSR                                                      CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
     C                   IF        PRTCD = *BLANKS                                            CGL014
     C                   EVAL      CGL014 = 'Y'                                               CGL014
     C                   ELSE                                                                 CGL014
     C                   EVAL      CGL014 = 'N'                                               CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL032
      ** Access SAR details file to determine if Automatic Exchange                           CGL032
      ** of Information is switched on                                                        CGL032
                                                                                              CGL032
     C                   CALL      'AOSARDR0'                                                 CGL032
     C                   PARM      *BLANKS       PRTCD                                        CGL032
     C                   PARM      '*VERIFY'     POPTN                                        CGL032
     C                   PARM      'CGL032'      PSARD                                        CGL032
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL032
                                                                                              CGL032
      ** An NRF (No Record Found) return code is valid.                                       CGL032
      ** Issue database error only for error return codes.                                    CGL032
                                                                                              CGL032
     C                   IF        PRTCD <> *BLANKS AND                                       CGL032
     C                             PRTCD <> '*NRF   '                                         CGL032
     C                   EVAL      DBKEY = 'CGL032'                                           CGL032
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CGL032
     C                   Z-ADD     18            DBASE                                        CGL032
     C                   EXSR      *PSSR                                                      CGL032
     C                   ENDIF                                                                CGL032
                                                                                              CGL032
     C                   IF        PRTCD = *BLANKS                                            CGL032
     C                   MOVEL     'Y'           CGL032                                       CGL032
     C                   ELSE                                                                 CGL032
     C                   MOVEL     'N'           CGL032                                       CGL032
     C                   END                                                                  CGL032
                                                                                              CGL032
      ** Access SAR details file to determine if Taxation of                                  CGL031
      ** Savings Income is switched on                                                        CGL031
                                                                                              CGL031
     C                   CALL      'AOSARDR0'                                                 CGL031
     C                   PARM      *BLANKS       PRTCD                                        CGL031
     C                   PARM      '*VERIFY'     POPTN                                        CGL031
     C                   PARM      'CGL031'      PSARD                                        CGL031
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL031
                                                                                              CGL031
      ** An NRF (No Record Found) return code is valid.                                       CGL031
      ** Issue database error only for error return codes.                                    CGL031
                                                                                              CGL031
     C                   IF        PRTCD <> *BLANKS AND                                       CGL031
     C                             PRTCD <> '*NRF   '                                         CGL031
     C                   EVAL      DBKEY = 'CGL031'                                           CGL031
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CGL031
     C                   Z-ADD     19            DBASE                                        CGL031
     C                   EXSR      *PSSR                                                      CGL031
     C                   ENDIF                                                                CGL031
                                                                                              CGL031
     C                   IF        PRTCD = *BLANKS                                            CGL031
     C                   MOVEL     'Y'           CGL031                                       CGL031
     C                   ELSE                                                                 CGL031
     C                   MOVEL     'N'           CGL031                                       CGL031
     C                   END                                                                  CGL031
      *
      ** Access Switchable Features file to determine whether                                LLN022A
      ** LLN022 (Bank of England) processing is installed.                                   LLN022A
      *                                                                                      LLN022A
     C                   MOVE      'N'           LLN022            1                         LLN022A
     C                   CALLB     'AOSARDR0'                                                LLN022A
     C                   PARM      *BLANK        PRTCD                                       LLN022A
     C                   PARM      '*VERIFY'     POPTN                                       LLN022A
     C                   PARM      'LLN022'      PSARD                                       LLN022A
     C     SCSARD        PARM      SCSARD        DSFDY                                       LLN022A
      *                                                                                      LLN022A
     C                   IF        PRTCD = *BLANK                                            LLN022A
     C                   MOVE      'Y'           LLN022                                      LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                      LLN022A
      ** Retrieve ZMUSER details.
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
      *
      ** Get the field number for the first field in 1st screen.
      ** Subtract one from it to give the value to subtract from each
      ** field's number.
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    PFormat
     C                   PARM                    PField1
     C                   PARM                    PFieldNo

     C                   IF        RetCodeOut = *BLANKS
     C                   EVAL      WFldOffset1 = PFieldNo - 1
      *
      ** If there was an error, default the offset to 13.
     C                   ELSE
     C                   EVAL      WFldOffset1 = 13
     C                   ENDIF
      *
      ** Get the field number for the first field in 2nd screen.
      ** Subtract one from it to give the value to subtract from each
      ** field's number.
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    PFormat
     C                   PARM                    PField2
     C                   PARM                    PFieldNo

     C                   IF        RetCodeOut = *BLANKS
     C                   EVAL      WFldOffset2 = PFieldNo - 1
     C                   ENDIF
      *
      ** Get the field number for the first field in 3rd screen.
      ** Subtract one from it to give the value to subtract from each
      ** field's number.
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    PFormat
     C                   PARM                    PField3
     C                   PARM                    PFieldNo

     C                   IF        RetCodeOut = *BLANKS
     C                   EVAL      WFldOffset3 = PFieldNo - 1
     C                   ENDIF
      *                                                                                       CAS006
      ** Get the field number for the first field in 4th screen.                              CAS006
      ** Subtract one from it to give the value to subtract from each                         CAS006
      ** field's number.                                                                      CAS006
     C                   CALLB     'ZACGTFLDNO'                                               CAS006
     C                   PARM      *BLANKS       RetCodeOut                                   CAS006
     C                   PARM                    PFormat                                      CAS006
     C                   PARM                    PField4                                      CAS006
     C                   PARM                    PFieldNo                                     CAS006
                                                                                              CAS006
     C                   IF        RetCodeOut = *BLANKS                                       CAS006
     C                   EVAL      WFldOffset4 = PFieldNo - 1                                 CAS006
     C                   ENDIF                                                                CAS006
      *                                                                                       CAS006
      ** Get the field number for the first field in 5th screen.                              CAS006
      ** Subtract one from it to give the value to subtract from each                         CAS006
      ** field's number.                                                                      CAS006
     C                   CALLB     'ZACGTFLDNO'                                               CAS006
     C                   PARM      *BLANKS       RetCodeOut                                   CAS006
     C                   PARM                    PFormat                                      CAS006
     C                   PARM                    PField5                                      CAS006
     C                   PARM                    PFieldNo                                     CAS006
                                                                                              CAS006
     C                   IF        RetCodeOut = *BLANKS                                       CAS006
     C                   EVAL      WFldOffset5 = PFieldNo - 1                                 CAS006
     C                   ENDIF                                                                CAS006
      *                                                                                       CER001
      ** Get the field number for the first field in LUX screen.                              CER001
      ** Subtract one from it to give the value to subtract from each                         CER001
      ** field's number.                                                                      CER001
      *                                                                                       CER001
     C                   CALLB     'ZACGTFLDNO'                                               CER001
     C                   PARM                    ReturnCode                                   CER001
     C                   PARM                    PFormat                                      CER001
     C                   PARM                    PFieldExt                                    CER001
     C                   PARM                    PFieldNo                                     CER001
                                                                                              CER001
     C                   IF        ReturnCode    = *BLANK                                     CER001
     C                   EVAL      WFldOffsetExt = PFieldNo - 1                               CER001
      *                                                                                       CER001
      ** If there was an error default the offset to 186                                      CER001
      *                                                                                       CER001
     C                   ELSE                                                                 CER001
     C                   EVAL      WFldOffsetExt = 186                                        CER001
     C                   ENDIF                                                                CER001
      *
      ** Define Key Lists.
     C     ZATRNKD0      KLIST
     C                   KFLD                    PFOTRANSEL
     C                   KFLD                    PTMESTPSEL

     C     ZATRNKD1      KLIST
     C                   KFLD                    PFOTRANSEL
     C                   KFLD                    PTMESTPSEL
     C                   KFLD                    KABFIELDID

     C     ZATRNKX0      KLIST
     C                   KFLD                    PTMESTPSEL
     C                   KFLD                    PFOTRANSEL
                                                                                              CSC011
     C     KAPILOG       KLIST                                                                CSC011
     C                   KFLD                    KMsgType                                     CSC011
     C                   KFLD                    KFrntOffID                                   CSC011
     C                   KFLD                    KTimeStamp                                   CSC011
      *                                                                                       CER001
     C     K@KEY         KLIST                                                                CER001
     C                   KFLD                    L1SESN                                       CER001
      *                                                                                       CER001
     C     K@KEY1        KLIST                                                                CER001
     C                   KFLD                    PDTMST                                       CER001
     C                   KFLD                    L1FOTR                                       CER001
      *
      ** Initialise error fields.
     C                   EXSR      SRResetErr
      *
      ** Display Browse screen.
     C                   MOVE      'B'           WSCRN
      *
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
      ** Hook to enable non-core initial processing to be included
      *
      /COPY WNCPYSRC,SESECSR013
      *
      ** Access Switchable Features File, for CSC022                                          CSC022
      *                                                                                       CSC022
     C                   Eval      CSC022 = 'N'                                               CSC022
     C                   CallB     'AOSARDR0'                                                 CSC022
     C                   Parm      *BLANKS       @RTCD                                        CSC022
     C                   Parm      '*VERIFY'     @OPTN                                        CSC022
     C                   Parm      'CSC022'      @SARD                                        CSC022
     C     SCSARD        Parm      SCSARD        DSFDY                                        CSC022
      *                                                                                       CSC022
     C                   If        @RtCd = *Blanks                                            CSC022
     C                   Eval      CSC022 = 'Y'                                               CSC022
     C                   Eval      WCommitSkip = 'N'                                          CSC022
      *                                                                                       CSC022
     C                   In        SCCMTJOB                                                   CSC022
     C                   If        ComitNum > 0                                               CSC022
     C                   MoveA     ComitJob      WCmtJobArr                                   CSC022
      *                                                                                       CSC022
     C     PSJOBNAME     LOOKUP    WCmtJobArr                             87                  CSC022
     C                   If        *IN87 = *ON                                                CSC022
     C                   Eval      WCommitSkip = 'Y'                                          CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CSC022
     C                   Else                                                                 CSC022
      *                                                                                       CSC022
      ** If return code <> *NRF, call program exception error routine                         CSC022
      *                                                                                       CSC022
     C                   If        @RtCd <> '*NRF'                                            CSC022
     C     *LOCK         IN        LDA                                                        CSC022
     C                   EVAL      DBKEY = 'CSC022'                                           CSC022
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC022
     C                   EVAL      DBASE = 18                                                 CSC022
     C                   OUT       LDA                                                        CSC022
     C                   Exsr      *PSSR                                                      CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CER001
      ** Access SAR details file to determine if ULX610 switchable feature                    CER001
      ** is switched on                                                                       CER001
      *                                                                                       CER001
     C                   EVAL      ULX610  = 'N'                                              CER001
     C                   CALLB     'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       PRTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX610'      @SARD                                        CER001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
      *                                                                                       CER001
     C                   IF        PRTCD   = *BLANKS                                          CER001
     C                   EVAL      ULX610  = 'Y'                                              CER001
     C                   ELSE                                                                 CER001
     C                   IF        PRTCD  <> '*NRF'                                           CER001
     C     *LOCK         IN        LDA                                                        CER001
     C                   EVAL      DBKEY   = 'ULX610'                                         CER001
     C                   EVAL      DBFILE  = 'SCSARDPD'                                       CER001
     C                   EVAL      DBASE   = 907                                              CER001
     C                   OUT       LDA                                                        CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** ULX004 - BCL/CSSF Statutory Reporting                                                CER001
      *                                                                                       CER001
     C                   IF        ULX610  = 'Y'                                              CER001
     C                   CALLB     'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       PRTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX004'      @SARD                                        CER001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
      *                                                                                       CER001
     C                   IF        PRTCD   = *BLANK                                           CER001
     C                   EVAL      ULX004  = 'Y'                                              CER001
     C                   ELSE                                                                 CER001
     C                   EVAL      ULX004  = 'N'                                              CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** ULX043 - IBLC 2002 Reporting                                                         CER001
      *                                                                                       CER001
     C                   IF        ULX610  = 'Y'                                              CER001
     C                   CALLB     'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       PRTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX043'      @SARD                                        CER001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
      *                                                                                       CER001
     C                   IF        PRTCD   = *BLANK                                           CER001
     C                   EVAL      ULX043  = 'Y'                                              CER001
     C                   ELSE                                                                 CER001
     C                   EVAL      ULX043  = 'N'                                              CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** ULX046 - Circulars 2002/170-174-175 Integration                                      CER001
      *                                                                                       CER001
     C                   EVAL      ULX046  = 'N'                                              CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       PRTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX046'      @SARD                                        CER001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
                                                                                              CER001
     C                   IF        PRTCD   = *BLANK                                           CER001
     C                   EVAL      ULX046  = 'Y'                                              CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** Open extension file if LUX switchable is on                                          CER001
      *                                                                                       CER001
     C                   IF        ULX610  = 'Y'                                              CER001
      *                                                                                       CER001
     C                   IF        ULX004  = 'Y'                                              CER001
     C                   OPEN      SEISELX2L0                                                 CER001
     C                   OPEN      SEISELX5L0                                                 CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   IF        ULX043  = 'Y'                                              CER001
     C                   OPEN      SEISELX1L0                                                 CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      *                                                                                       CSE065
      ** Check if CSE065 is installed                                                         CSE065
     C                   EVAL      CSE065 = 'N'                                               CSE065
     C                   CALLB     'AOSARDR0'                                                 CSE065
     C                   PARM      *Blanks       PRTCD                                        CSE065
     C                   PARM      '*VERIFY'     POPTN                                        CSE065
     C                   PARM      'CSE065'      PSARD                                        CSE065
     C     SCSARD        PARM      SCSARD        DSSDY                                        CSE065
                                                                                              CSE065
     C                   IF        PRTCD = *Blanks                                            CSE065
     C                   EVAL      CSE065 = 'Y'                                               CSE065
     C                   ELSE                                                                 CSE065
     C                   IF        PRTCD <> '*NRF   '                                         CSE065
     C     *LOCK         IN        LDA                                                        CSE065
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSE065
     C                   EVAL      DBKEY  = 'CSE065'                                          CSE065
     C                   EVAL      DBASE  = 19                                                CSE065
     C                   OUT       LDA                                                        CSE065
     C                   EXSR      *PSSR                                                      CSE065
     C                   ENDIF                                                                CSE065
     C                   ENDIF                                                                CSE065
      *                                                                                       CSC022
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
