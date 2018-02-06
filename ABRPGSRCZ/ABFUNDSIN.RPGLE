     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AB Internal Funding Deals Maintenance')          *
      *****************************************************************
      *                                                               *
      *  Midas - Internal Funding Module                              *
      *                                                               *
      *  ABFUNDSIN - Internal Funding Deals Maintenance               *
      *                                                               *
      *  Function:  This module will be the entry module for screen-  *
      *             input function for Internal Funding Deals.        *
      *                                                               *
      *  Component of: ABFUNDSIN - Internal Funding Deals Maintenance *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 261140             Date 16Sep09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 04Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CGL014             Date 20Oct03               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 222727             Date 05Nov03               *
      *                 CAP076             Date 03Jun02               *
      *                 CAS005             Date 16Dec02               *
      *                 CAS004             Date 26Jun02               *
      * Midas Release 4.01.03-----------------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011             Date 18Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 195001             Date 09Jul01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CAP042  *CREATE    Date 08Jan01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompiled)                                        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  261140 - Missing Front Office ID / Assoc Front Office ID     *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CDL020 - Apply Base Rate at Value Date                       *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CAP076 - Lending API enhancements - Rollover details         *
      *           Recompile due to change in MM1010                   *
      *           (new parameter to ZINTDY)                           *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CAS004 - Hedge Accounting Phase A                            *
      *  CSC011 - 24x7 Midas Availability                             *
      *  195001 - Don't access SDBRTDPD if BRT not switched on.       *
      *  CAP042 - Conversion of Internal Funding Deal inputs into     *
      *           modular structure to use as APIs.                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    02         Indicator for CHAIN operation                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRScnMain  - Process screen: Main details                    *
      *  SRValMain  - Validate input to Main details screen           *
      *  SRWindow   - Call window manager                             *
      *  SRRoll     - Roll backwards and forwards through deals file  *
      *  SRBldBrw   - Build browse subfile                            *
      *  SRRdNBrw   - Read next browse subfile record                 *
      *  SRRtvDl    - Retrieve deal                                   *
      *  SRCvtoScn  - Convert from file to screen format              *
      *  SRSetFldS  - Set field status on main details screen         *
      *               according to action code                        *
      *  SRSetKeyS  - Set function key status on main details screen  *
      *               according to action code                        *
      *  SRInzFldS  - Initialise field status on main details screen  *
      *  SRInzKeyS  - Initialise function key status on main details  *
      *               screen                                          *
      *  SRCancM    - Cancel on main details screen                   *
      *  SRSndMsgM  - Send a message to main details screen           *
      *  SRScnConf  - Process screen: Confirmation of input evoked    *
      *               for inputs and amends                           *
      *  SRCancC    - Cancel on confirmation screen                   *
      *  SRExitC    - Exit from confirmation screen                   *
      *  SRUpdate   - Update file                                     *
      *  SRSetValid - Set up additional fields that are needed on the *
      *               valid file record                               *
      *  SRSetIMAT  - Calculate Interest at Maturity                  *
      *  SREndP     - End program                                     *
      *                                                               *
      *  *PSSR - Error processing                                     *
      *  *INZSR - Initialise                                          *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
 
      ** Hook to enable non-core files to be included
      /COPY WNCPYSRC,ABFUND001
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** BRT Control Data
     FSDBRTDL1  IF A E           K DISK    INFSR(*PSSR)
 
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
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
 
     D/COPY ZACPYSRC,ERR_ARRAYS
 
      ** The following /COPY includes the MM standard declares:
 
     D/COPY ZACPYSRC,STDDECLARE
 
      ** The following /COPY line includes the definitions of data
      ** structure used to pass data to window program
 
     D/COPY QWINDSRC,ABFUNDDTA
 
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
 
      ** External DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for general ledger details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
 
      ** External DS for dealing details
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
     D  QQAccd1      E                     EXTFLD(QQACCD)                                     CGL029
 
      ** External DS for Midas modules details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      ** External DS for Trading ICD
     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
     D  QQAccd2      E                     EXTFLD(QQACCD)                                     CGL029
 
      ** External DS for branch details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
      ** External DS for currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** Externam DS SC Switchable Features
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Current Deal in File Format of main deal
     D CrDlFilFmt1   E DS                  EXTNAME(MMDELDPP)
     D                                     Prefix(D1:2)
     D  QQDoriD1     E                     EXTFLD(QQDORI)                                     CGL029
     D  QQMoriD1     E                     EXTFLD(QQMORI)                                     CGL029
     D  QQDopiD1     E                     EXTFLD(QQDOPI)                                     CGL029
     D  QQMopiD1     E                     EXTFLD(QQMOPI)                                     CGL029
     D  QQRonsD1     E                     EXTFLD(QQRONS)                                     CGL029
     D  QQPonsD1     E                     EXTFLD(QQPONS)                                     CGL029
     D  QQInsaD1     E                     EXTFLD(QQINSA)                                     CGL029
 
      ** Current Deal in File Format of associated deal
     D CrDlFilFmt2   E DS                  EXTNAME(MMDELDPP)
     D                                     Prefix(D2:2)
     D  QQDoriD2     E                     EXTFLD(QQDORI)                                     CGL029
     D  QQMoriD2     E                     EXTFLD(QQMORI)                                     CGL029
     D  QQDopiD2     E                     EXTFLD(QQDOPI)                                     CGL029
     D  QQMopiD2     E                     EXTFLD(QQMOPI)                                     CGL029
     D  QQRonsD2     E                     EXTFLD(QQRONS)                                     CGL029
     D  QQPonsD2     E                     EXTFLD(QQPONS)                                     CGL029
     D  QQInsaD2     E                     EXTFLD(QQINSA)                                     CGL029
 
      ** New Deal in File Format of main deal
     D NwDlFilFmt1   E DS                  EXTNAME(MMVLDNIPD)
     D                                     Prefix(N1:2)
     D  QQDoriN1     E                     EXTFLD(QQDORI)                                     CGL029
     D  QQMoriN1     E                     EXTFLD(QQMORI)                                     CGL029
     D  QQDopiN1     E                     EXTFLD(QQDOPI)                                     CGL029
     D  QQMopiN1     E                     EXTFLD(QQMOPI)                                     CGL029
     D  QQRonsN1     E                     EXTFLD(QQRONS)                                     CGL029
     D  QQPonsN1     E                     EXTFLD(QQPONS)                                     CGL029
     D  QQInsaN1     E                     EXTFLD(QQINSA)                                     CGL029
 
      ** New Deal in File Format of associated deal
     D NwDlFilFmt2   E DS                  EXTNAME(MMVLDNIPD)
     D                                     Prefix(N2:2)
     D  QQDoriN2     E                     EXTFLD(QQDORI)                                     CGL029
     D  QQMoriN2     E                     EXTFLD(QQMORI)                                     CGL029
     D  QQDopiN2     E                     EXTFLD(QQDOPI)                                     CGL029
     D  QQMopiN2     E                     EXTFLD(QQMOPI)                                     CGL029
     D  QQRonsN2     E                     EXTFLD(QQRONS)                                     CGL029
     D  QQPonsN2     E                     EXTFLD(QQPONS)                                     CGL029
     D  QQInsaN2     E                     EXTFLD(QQINSA)                                     CGL029
 
      ** Deal file format use for update
     D UpdDlFilFmt   E DS                  EXTNAME(MMVLDNIPD)
 
      ** Current Deal in Screen Format
     D CrDlScnFmt    E DS                  EXTNAME(ABFUNDPD)
     D                                     PREFIX(DC:2)
 
      ** New Deal in Screen Format
     D NwDlScnFmt    E DS                  EXTNAME(ABFUNDPD)
     D                                     PREFIX(DD:2)
 
      ** Internal funding deals error indicator file
     D OkFlags       E DS                  EXTNAME(ABEFUNDPD)
 
      ** Current control indicators for main detail screen
     D WCtlInd         DS
     D  PKeyFld                1      1
     D  PDetFld                2      2
     D  PEINKG                 3      3
     D  PEINKH                 4      4
     D  PEINKJ                 5      5
     D  PEINKP                 6      6
 
      ** Previous control indicators for main detail screen
     D WPrvCtlIn       DS             6
 
      ** AB (FUND) Extra Data - File (D/B) format
     D ExtData       E DS                  EXTNAME(ABFUEXPD)
 
      ** Data structure for ZMUSER details
     D ZMUSER          DS            17
     D  PUSRID                 1     10A
     D  PDBRN                 11     13A
     D  PDPPT                 14     16A
 
      ** Data structure for RUNDAT details
     D RUNDAT          DS            13
     D  PAGMRDT                1      7A
     D  PAGRDNB                8     10  0
     D  PAGSUC                11     11A
     D  PAGDFF                12     12A
     D  PAGMBIN               13     13A
 
      ** Midas Run Date
     D                 DS
     D WkBJMRDT                1      7
     D WkDLUP                  1      2  0
     D WkMLUP                  3      5
     D WkYLUP                  6      7  0
 
      ** YYYYMMDD date format of Deal Date
     D PDateOutZ9      DS
     D  DDATYr                 1      4  0
     D  DDATMn                 5      6  0
     D  DDATDy                 7      8  0
 
      ** Data structure to hold the data for screen messages.
     D WData           DS            45
     D  WData1                 1      6
     D  WData2                 7     12
 
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  RecNotFnd             02     02
 
      ** 24X7 status data area                                                                CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
                                                                                              CSC011
      ** SD Data Area                                                                         CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
                                                                                              CSC022
      ** Jobs Handling Commitment Control                                                     CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  COMITARR               4    103                                                       CSC022
                                                                                              CSC022
      ** Array of Commitment Job Names                                                        CSC022
     D COMITJOB        S             10A   DIM(10)                                            CSC022
                                                                                              CSC011
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     ** Entry Parameter
     D PAction         S              1A
     D PDealNo         S              6A
     D PLnkFlag        S              1A
 
      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D PRespMode       S              1A   INZ('S')
 
     D PINKC           S              1A
     D PINKG           S              1A
     D PINKH           S              1A
     D PINKJ           S              1A
     D PINKL           S              1A
     D PINKP           S              1A
     D PSIDN           S              6A
     D PAmdOk          S              1A
     D PRstErr         S              1A
     D PModeOfOp       S              6A
     D PDDDLNO         S              6A
     D PDealNum        S              6S 0
     D PMsgID          S              7A
     D PDDSTS          S              7A
     D PPRF1D          S             30A
     D PPRF2D          S             30A
     D PRdFwd          S              1A
     D PRdBck          S              1A
     D PErrMsg         S              7A
     D PRdDeal         S              6A
     D PRdFrntID       S             20A
     D PBdSfl          S              1A
     D PRdSfl          S              1A
     D POpSel          S              1A
     D PDlSel          S              6A
     D PFrntId         S             20A
     D PFrntAsId       S             20A
     D PDaynoIn        S              5P 0
     D PRetCode        S              1  0
     D PReDsp          S              1A
     D PKey            S              1A
     D FRNT            S             20A                                                      261140
     D AFRT            S             20A                                                      261140
 
      ** Parameters for WN0010
     D PWPgm           S             10A   INZ('ABFUNDSIN')
     D PWKey           S              2A
     D PWAction        S              1A
     D PWRtn           S              7A
     D PWSpare         S            256A
 
      ** Parameters for MM1010
     D PMTTI           S             15P 0
     D PINTD           S             13P 0
     D PIPFQ           S              1A
     D PNIPD           S              5P 0
     D PDVSD           S              5P 0
     D PICMT           S              1A
     D PAMNP           S             15P 0
     D PINTR           S             11P 7
     D PRDFC           S              1A
     D PMTAX           S              1A
     D PDeal           S              6  0
     D PBRMD           S              5P 0
     D S01383          S              1A
     D*PCNUM****       S              6  0                                                    CSD027
     D PCNUM           S              6A                                                      CSD027
     D PZCCY           S              3A
     D PZLOC           S              3A
     D PIMAT           S             15  0
     D PValFlg         S              1A
 
     D WPDLNO          S              6
     D WPACTN          S              1
     D WScrn           S              1
     D WRdnb           S              1
     D WReDisplay      S              1A
     D WIx             S              3P 0
     D WSetFld         S              1A
 
      ** Work array for warning message Ids
     D WPrvWarnAr      S                   Dim(ArrayMax)
     D                                     Like(WMsgIDArr)
 
      ** Index for arrays of error message ids etc
     D WkIdx           S              3P 0
 
      ** Index for arrays of warning message ids etc
     D WkWIdx          S              3P 0
 
      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))
 
     D CSC011          S              1A                                                      CSC011
     D CSC022          S              1A   INZ('N')                                           CSC022
     D CNT             S              3  0                                                    CSC022
     D COMITSKIP       S              1A                                                      CSC022
     D PRtCd           S              7A                                                      CSC011
     D POptn           S              7A                                                      CSC011
     D PSard           S              6A                                                      CSC011
     D WRunDay         S                   LIKE(BJRDNB)                                       CSC011
                                                                                              CSC011
     D CAS004          S              1A                                                      CAS004
                                                                                              CDL019
     D CDL019          S              1A                                                      CDL019
                                                                                              CDL020
     D CDL020          S              1A                                                      CDL020
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      /COPY WNCPYSRC,ABFUND002
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * Main Procedure                                                    *
      *********************************************************************
 
      /COPY WNCPYSRC,ABFUND003
 
      ** Read next browse subfile record
 
     C     WScrn         IFEQ      'R'
     C                   EXSR      SRRdNBrw
     C                   ENDIF
 
      /COPY WNCPYSRC,ABFUND004
 
      ** Do while screen: Main Details
 
     C     WScrn         DOWEQ     'M'
     C                   EXSR      SRScnMain
     C                   ENDDO
 
      /COPY WNCPYSRC,ABFUND005
 
      ** Screen: Window
 
     C     WScrn         IFEQ      'W'
     C                   EXSR      SRWindow
     C                   ENDIF
 
      /COPY WNCPYSRC,ABFUND006
 
      **  Screen: Confirmation of Input
 
     C     WScrn         IFEQ      'C'
     C                   EXSR      SRScnConf
     C                   ENDIF
 
      /COPY WNCPYSRC,ABFUND007
 
      **  Do file updates
 
     C     WScrn         IFEQ      'U'
     C                   EXSR      SRUpdate
     C                   ENDIF
 
      /COPY WNCPYSRC,ABFUND008
 
      ** Terminate program
 
     C     WScrn         IFEQ      'T'
     C                   EVAL      *INLR = '1'
     C                   ENDIF
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Hook to enable non-core subroutines to be included
 
      /COPY WNCPYSRC,ABFUND009
 
      *****************************************************************
      *                                                               *
      ** SRScnMain - Process screen: Main details                     *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: SRValMain                                              *
      *                                                               *
      *****************************************************************
     C     SRScnMain     BEGSR
 
      ** Issue rollback to clear any possible updates in window function
      ** Only required if deal number or action code has been changed
      ** (this check will also cater for F12 taken from main screen)
 
     C                   IF        BGWDPR = 'Y'
     C                   IF        DDDLNO <> WPDLNO OR DDACTN <> WPACTN OR
     C                             WCtlInd <> WPrvCtlIn
     C     CSC022        IFEQ      'N'                                                        CSC022
     C                   ROLBK
     C                   ELSE                                                                 CSC022
     C     COMITSKIP     IFNE      'Y'                                                        CSC022
     C                   ROLBK                                                                CSC022
     C                   ELSE                                                                 CSC022
     C                   SETON                                        U7U8                    CSC022
     C                   END                                                                  CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF
     C                   ENDIF
 
      ** Update 'previous' deal number & screen control indicator
 
     C                   EVAL      WPDLNO = DDDLNO
     C                   EVAL      WPACTN = DDACTN
     C                   EVAL      WPrvCtlIn = WCtlInd
 
      ** Write/Read Display Screen
 
     C                   CALLB     'ABFUNDDSP'
 
      ** Input Parameters
      ** ================
      ** Return Code
 
     C                   PARM      *BLANK        RetCodeOut
 
      ** Deal (in screen format)
 
     C                   PARM                    NwDlScnFmt
 
      ** Deal Status
      ** Profit Centre Description 1
      ** Profit Centre Description 2
 
     C                   PARM                    PDDSTS
     C                   PARM                    PPRF1D
     C                   PARM                    PPRF2D
 
      ** Fields in error
 
     C                   PARM                    OkFlags
 
      ** Errors
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Warnings
 
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
 
      ** Enabled key and detail fields
      ** Enabled function keys
 
     C                   PARM                    PKeyFld
     C                   PARM                    PDetFld
     C                   PARM                    PEINKG
     C                   PARM                    PEINKH
     C                   PARM                    PEINKJ
     C                   PARM                    PEINKP
 
      ** Successful insert deal
 
     C                   PARM                    PSIDN
 
      ** Linked maintenance flag
 
     C                   PARM                    PLnkFlag
 
      ** Write screen with no read indicator
 
     C                   PARM      'N'           WriteOnly
 
      ** Standing Data
      ** =============
      ** SDBANKPD
      ** ========
 
     C                   PARM                    BJMRDT
 
      ** SDGELRPD
      ** ========
 
     C                   PARM                    BKOBRU
     C                   PARM                    BKPRCU
 
      ** RUNDAT
      ** ======
 
      ** Multibranching Indicator
     C                   PARM                    PAGMBIN
                                                                                              CAS004
     C                   PARM                    CAS004                                       CAS004
                                                                                              CDL019
     C                   PARM                    CDL019                                       CDL019
                                                                                              CDL020
     C                   PARM                    CDL020                                       CDL020
 
      ** Output Parameters
      ** =================
      ** Function Keys
 
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKG
     C                   PARM      '0'           PINKH
     C                   PARM      '0'           PINKJ
     C                   PARM      '0'           PINKL
     C                   PARM      '0'           PINKP
 
      ** Save warning message ids array of this screen.
 
     C                   MOVEA     WMsgIDArr     WPrvWarnAr
 
      ** Reset Errors
 
     C                   EXSR      SRResetErr
     C                   EVAL      PValFlg = *BLANK
 
      ** CK/12 - Cancel on Main Details Screen
 
     C                   IF        PINKL = '1'
 
     C                   IF        PLnkFlag = 'Y'
 
      ** If called as a linked enquiry return to calling program
 
     C                   EXSR      SREndP
     C                   ELSE
     C                   EXSR      SRCancM
     C                   ENDIF
 
     C                   GOTO      ESCRN@M
     C                   ENDIF
 
      ** CK/3 - End Program
 
     C                   IF        PINKC = '1'
     C                   EXSR      SREndP
     C                   GOTO      ESCRN@M
     C                   ENDIF
 
      ** CK/7 - Roll Backwards
 
     C                   IF        PINKG = '1'
     C                   EXSR      SRRoll
     C                   GOTO      ESCRN@M
     C                   ENDIF
 
      ** CK/8 - Roll Forwards
 
     C                   IF        PINKH = '1'
     C                   EXSR      SRRoll
     C                   GOTO      ESCRN@M
     C                   ENDIF
 
      ** CK/15 - Build Browse
 
     C                   IF        PINKP = '1'
     C                   EXSR      SRBldBrw
     C                   GOTO      ESCRN@M
     C                   ENDIF
 
      ** CK/10 - go onto update, delete record
 
     C                   IF        PINKJ = '1'
 
      ** Update Deal in File Format
 
     C                   EVAL      NwDlFilFmt1 = CrDlFilFmt1
     C                   EVAL      NwDlFilFmt2 = CrDlFilFmt2
     C                   EVAL      N1DDLT = 'D'
     C                   EVAL      N2DDLT = 'D'
     C                   EVAL      N1LACT = 'D'
     C                   EVAL      N2LACT = 'D'
     C                   EVAL      IKLUID = PSUser
 
     C                   EVAL      WScrn = 'U'
     C                   GOTO      ESCRN@M
     C                   ENDIF
 
      ** Validate input to Main Details Screen
 
     C                   EXSR      SRValMain
 
     C     ESCRN@M       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRValMain - Validate input to Main Details Screen
      *****************************************************************
     C     SRValMain     BEGSR
 
      ** Retrieve deal details
 
     C                   EXSR      SRRtvDl
 
      ** If action code, deal number or booking branch are NOT OK
      ** Re-output screen with error messages on it
 
     C                   IF        OKACTN = 'N' OR OKDLNO = 'N'
     C                   GOTO      EVAL@M
     C                   ENDIF
 
      ** Set field and function key status on main details screen
      ** (according to action code)
 
     C                   EXSR      SRSetFldS
     C                   EXSR      SRSetKeyS
 
      ** If action code is delete, enquire
      ** or action code is amend and deal number has changed
      ** Put the deal on the main details screen
 
     C                   IF        DDACTN = 'D' OR DDACTN = 'E' OR
     C                             DDACTN = 'A' AND DDDLNO <> WPDLNO OR
     C                             DDACTN = 'A' AND DDACTN <> WPACTN
     C                   EXSR      SRCvtoScn
     C                   ENDIF
 
      ** If deal number or screen control indicators have changed
      **   Re-output screen
 
     C                   IF        DDDLNO <> WPDLNO AND DDACTN <> 'I' OR
     C                             WCtlInd <> WPrvCtlIn
     C                   GOTO      EVAL@M
     C                   ENDIF
 
      ** If Enquire
 
     C                   IF        DDACTN = 'E'
 
      ** Update Deal in File Format
 
     C                   EVAL      NwDlFilFmt1 = CrDlFilFmt1
     C                   EVAL      NwDlFilFmt2 = CrDlFilFmt2
 
      ** If windows processing on, call window routine
      ** If browse outstanding, read next browse subfile record
 
     C                   IF        BGWDPR = 'Y'
     C                   EVAL      WScrn = 'W'
     C                   ELSE
     C                   IF        WRdnb = 'Y'
     C                   EVAL      WScrn = 'R'
     C                   ENDIF
     C                   ENDIF
 
     C                   GOTO      EVAL@M
 
      ** End of Enquire
 
     C                   ENDIF
 
      ** If insert or amend
 
     C                   IF        DDACTN = 'I' OR DDACTN = 'A'
 
      * Prior to validation, initialize error indicators as 'OK'
      * and clear Deal in File Format
 
     C                   EXSR      SRResetErr
     C                   CLEAR                   NwDlFilFmt1
     C                   CLEAR                   NwDlFilFmt2
 
      ** If Amemd
 
     C                   IF        DDACTN = 'A'
 
      ** Update Deal in File Format
 
     C                   EVAL      NwDlFilFmt1 = CrDlFilFmt1
     C                   EVAL      NwDlFilFmt2 = CrDlFilFmt2
 
      ** Validate whether non-amenable fields have been changed
 
     C                   CALLB     'ABFUNDAMD'
 
      ** Input Parameters
      ** ================
      ** Return Code
 
     C                   PARM      *BLANK        RetCodeOut
 
      ** New Deal in Screen Format
      ** Current Deal in Screen Format
      ** Reset of Fields in Error Required (Y/N)
 
     C                   PARM                    NwDlScnFmt
     C                   PARM                    CrDlScnFmt
     C                   PARM      'Y'           PRstErr
 
      ** SDGELRPD
      ** ========
 
      ** Originating Branch Used
 
     C                   PARM                    BKOBRU
 
      ** SDDEALPD
      ** ========
 
      ** Decimal Separator
 
     C                   PARM                    BNDCSP
                                                                                              CDL019
      ** Allow Base Rate Changes on Fixed Deposits/Loans                                      CDL019
     C                   PARM                    CDL019                                       CDL019
                                                                                              CDL020
      ** Apply Base Rate at Value Date                                                        CDL020
     C                   PARM                    CDL020                                       CDL020
 
      ** Output Parameters
      ** =================
      ** Field OK flags (DS) from/to caller
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** Array index (3P0) from/to caller
 
     C                   PARM                    OkFlags
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WkIdx
 
      ** Amendments OK
 
     C                   PARM      'Y'           PAmdOk
 
      ** Amended by validation module flag
 
     C                   PARM                    PValFlg
 
     C                   IF        PAmdOk <> 'Y'
     C                   GOTO      EVAL@M
     C                   ENDIF
 
      ** End of If Amend (access to ABFUNDAMD)
 
     C                   ENDIF
 
      ** Validate deal details
      ** =====================
 
     C                   CALLB     'ABFUNDVAL'
 
      ** Return Code
 
     C                   PARM      *BLANK        RetCodeOut
 
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen Input function)
 
     C                   PARM                    PModeOfOp
 
      ** Response mode (1A, from caller (A=Asynchronous, S=Synchronous))
 
     C                   PARM                    PRespMode
 
      ** AB Internal Funding screen details from incoming
      ** transaction - screen format
 
     C                   PARM                    NwDlScnFmt
 
      ** Current Screen Format
      ** Current File Format 1
      ** Current File Format 2
 
     C                   PARM                    CrDlScnFmt
     C                   PARM                    CrDlFilFmt1
     C                   PARM                    CrDlFilFmt2
 
      ** STANDING DATA
      ** =============
 
      ** SDBANKPD
      ** ========
 
      ** Date Format Indicator
      ** Currency Code
      ** Single Branch Code
      ** System Location Code
      ** Local Currency Code
      ** Customer Number
      ** Run Day Number
      ** Back Value Period in Days
 
     C                   PARM                    BJDFIN
     C                   PARM                    BJCYCD
     C                   PARM                    BJSBRC
     C                   PARM                    BJSLCD
     C                   PARM                    BJLCCY
     C                   PARM                    BJCUST
     C**********         PARM                    BJRDNB                                       CSC011
     C                   PARM                    WRunDay                                      CSC011
     C                   PARM                    BJBVPD
 
      ** SDGELRPD
      ** ========
 
      ** Profit Centres Used
      ** Originating Branch Used
      ** Originating Branch/User Valid
      ** Profit Centres Amendable
      ** Profit Centre Deafults Used
 
     C                   PARM                    BKPRCU
     C                   PARM                    BKOBRU
     C                   PARM                    BKOBUV
     C                   PARM                    BKPRCA
     C                   PARM                    BKPCDU
 
      ** SDDEALPD
      ** ========
 
      ** Decimal Separator
 
     C                   PARM                    BNDCSP
 
      ** SDMMODPD
      ** ========
 
      ** Leo Letters of Credit
 
     C                   PARM                    BGNOST
 
      ** SDTRADPD
      ** ========
 
      ** Base Rate Change Facility
 
     C                   PARM                    BLBRCF
 
      ** RUNDAT
      ** ======
 
      ** Multibranching Indicator
     C                   PARM                    PAGMBIN
 
      ** ZMUSER
      ** ======
 
      ** Default Branch
      ** Department Code
 
     C                   PARM                    PDBRN
     C                   PARM                    PDPPT
                                                                                              CAS004
     C                   PARM                    CAS004                                       CAS004
                                                                                              CDL019
     C                   PARM                    CDL019                                       CDL019
                                                                                              CDL020
     C                   PARM                    CDL020                                       CDL020
 
      ** Output Parameters
      ** =================
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM                    WkIdx
 
      ** Warning flds/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM                    WkWIdx
 
      ** AB Internal Funding screen error indicators
 
     C                   PARM                    OkFlags
 
      ** AB Internal Funding for file update - file format 1
 
     C                   PARM                    NwDlFilFmt1
 
      ** AB Internal Funding for file update - file format 2
 
     C                   PARM                    NwDlFilFmt2
 
      ** Redisplay Flag
 
     C                   PARM      *BLANK        PReDsp
 
      ** Profit Centre Description 1
      ** Profit Centre Description 2
 
     C                   PARM                    PPRF1D
     C                   PARM                    PPRF2D
 
      ** Amended by validation module flag
 
     C                   PARM                    PValFlg
 
     C                   EVAL      WReDisplay = *BLANK
 
      ** If no errors occurred during validation of main screen
      ** fields, check if there are warnings which have not been
      ** displayed yet.
 
     C                   IF        WkIdx = 0
 
     C                   Z-ADD     1             WIx
 
     C                   DOW       WIx <= WkWIdx AND WReDisplay = *BLANK
 
     C                   IF        WMsgIdArr(WIx) <> WPrvWarnAr(WIx)
     C                   EVAL      WReDisplay = 'Y'
     C                   ELSE
     C                   EVAL      WIx = WIx + 1
     C                   ENDIF
 
     C                   ENDDO
 
     C                   IF        WReDisplay <> 'Y'
     C                   EXSR      SRResetErr
     C                   ENDIF
 
     C                   ENDIF
 
      ** Redisplay main screen if there are errors or if there
      ** are warnings which have not been displayed yet.
 
     C                   IF        WkIdx <> *ZERO OR WReDisplay = 'Y' OR
     C                             PReDsp = 'Y'
     C                   GOTO      EVAL@M
     C                   ENDIF
      *
      ** If windows processing on, call SRWindow routine
      ** otherwise, continue to confirmation screen
 
     C                   IF        BGWDPR = 'Y'
     C                   EVAL      WScrn = 'W'
     C                   ELSE
     C                   EVAL      WScrn = 'C'
     C                   ENDIF
 
      ** End of If insert or amend
 
     C                   ENDIF
 
     C     EVAL@M        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRWindow - Call window manager
      *****************************************************************
     C     SRWindow      BEGSR
 
      ** Reset erros
 
     C                   EXSR      SRResetErr
 
      ** Write out screen to remove error messages
 
     C                   CALLB     'ABFUNDDSP'
 
      ** Input Parameters
      ** ================
      ** Return Code
 
     C                   PARM      *BLANK        RetCodeOut
 
      ** Deal (in screen format)
 
     C                   PARM                    NwDlScnFmt
 
      ** Deal Status
      ** Profit Centre Description 1
      ** Profit Centre Description 2
 
     C                   PARM                    PDDSTS
     C                   PARM                    PPRF1D
     C                   PARM                    PPRF2D
 
      ** Fields in error
 
     C                   PARM                    OkFlags
 
      ** Errors
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Warnings
 
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
 
      ** Enabled key and detail fields
 
     C                   PARM                    PKeyFld
     C                   PARM                    PDetFld
 
      ** Enabled function keys
 
     C                   PARM                    PEINKG
     C                   PARM                    PEINKH
     C                   PARM                    PEINKJ
     C                   PARM                    PEINKP
 
      ** Successful insert deal
 
     C                   PARM                    PSIDN
 
      ** Linked maintenance flag
 
     C                   PARM                    PLnkFlag
 
      ** Write screen with no read indicator
 
     C                   PARM      'Y'           WriteOnly
 
      ** Standing Data
      ** =============
      ** SDBANKPD
      ** ========
 
     C                   PARM                    BJMRDT
 
      ** SDGELRPD
      ** ========
 
     C                   PARM                    BKOBRU
     C                   PARM                    BKPRCU
 
      ** RUNDAT
      ** ======
 
      ** Multibranching Indicator
     C                   PARM                    PAGMBIN
                                                                                              CAS004
     C                   PARM                    CAS004                                       CAS004
                                                                                              CDL019
     C                   PARM                    CDL019                                       CDL019
                                                                                              CDL020
     C                   PARM                    CDL020                                       CDL020
 
      ** Output Parameters
      ** =================
      ** Function Keys
 
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKG
     C                   PARM      '0'           PINKH
     C                   PARM      '0'           PINKJ
     C                   PARM      '0'           PINKL
     C                   PARM      '0'           PINKP
 
      /COPY WNCPYSRC,ABFUNDMV1
 
      ** Call window manager
 
     C                   CALL      'WN0010'
     C                   PARM                    PWPgm
     C                   PARM                    PWKey
     C                   PARM      DDACTN        PWAction
     C                   PARM                    Data
     C                   PARM      *BLANKS       PWRtn
     C                   PARM                    PWSpare
 
      ** Process returned command keys
 
     C                   IF        PWRtn = 'Y2U9999'
     C                   EXSR      SREndP
     C                   ELSE
 
      ** If Cmd12 pressed, or in enquiry, return to main details screen;
      ** otherwise, go to confirmation screen
 
     C                   IF        PWRtn = 'USR0790' OR DDACTN = 'E'
 
     C                   IF        WRdnb = 'Y'
     C                   EVAL      WScrn = 'R'
     C                   ELSE
     C                   EVAL      WScrn = 'M'
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      WScrn = 'C'
     C                   ENDIF
     C                   ENDIF
 
     C     EWINDOW       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRRoll - Roll backwards & forwards through deals file
      *****************************************************************
     C     SRRoll        BEGSR
 
      ** Default action code to enquiry if not valid
 
     C                   IF        DDACTN <> 'A' AND DDACTN <> 'D' AND
     C                             DDACTN <> 'I'
     C                   EVAL      DDACTN = 'E'
     C                   ENDIF
 
      ** Read next or previous record on deals file
      ** according to command key taken (CK/7 or CK/8)
 
     C                   IF        PINKG = '1'
     C                   EVAL      PRdFwd = *BLANK
     C                   EVAL      PRdBck = 'Y'
     C                   ELSE
     C                   EVAL      PRdFwd = 'Y'
     C                   EVAL      PRdBck = *BLANK
     C                   ENDIF
 
     C                   CALLB     'ABFUNDRED'
 
      ** Input Parameters
      ** ================
      ** Return Code
 
     C                   PARM      *BLANK        RetCodeOut
 
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen Input function)
 
     C                   PARM      '      '      PModeOfOp
 
      ** Deal Number Pointer
      ** Front Office ID
 
     C                   PARM                    DDDLNO
     C                   PARM                    PFrntId
 
      ** Read Forwards
      ** Read Backwards
 
     C                   PARM                    PRdFwd
     C                   PARM                    PrdBck
 
      ** Standing Data
      ** =============
      ** SDBANKPD
      ** ========
 
     C                   PARM                    BJSBRC
 
      ** Output Parameters
      ** =================
      ** Error Message
      ** Deal Number Read
      ** Front Office ID READ
 
     C                   PARM      *BLANK        PErrMsg
     C                   PARM      *BLANK        PRdDeal
     C                   PARM      *BLANK        PRdFrntID
 
      ** If error message returned from read, send it to detail screen
 
     C                   IF        PErrMsg <> *BLANK
     C                   EXSR      SRSndMsgM
     C                   GOTO      EROLL
     C                   ENDIF
 
      ** If deal read
     C                   IF        PRdDeal <> *BLANK
 
      ** Retrieve deal details
 
     C                   EVAL      DDDLNO = PRdDeal
     C                   EXSR      SRRtvDl
 
      ** Set field and function key status on main details screen
      ** (according to action code)
 
     C                   EXSR      SRSetFldS
     C                   EXSR      SRSetKeyS
 
      ** Put the deal on the main details screen
 
     C                   EXSR      SRCvtoScn
     C                   ENDIF
 
     C     EROLL         ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRBldBrw -  Build Browse Subfile
      *****************************************************************
     C     SRBldBrw      BEGSR
 
      ** Reset read next browse subfile record
     C                   EVAL      WRdnb = *BLANK
 
      ** Build browse subfile
 
     C                   CALLB     'ABFUNDBRW'
 
      ** Input Parameters
      ** ================
      ** Return Code
 
     C                   PARM      *BLANK        RetCodeOut
 
      ** Deal Number Pointer
 
     C                   PARM                    DDDLNO
 
      ** Build sub-file
 
     C                   PARM      'Y'           PBdSfl
 
      ** Read subfile record
 
     C                   PARM      *BLANK        PRdSfl
 
      ** Standing Data
      ** =============
      ** SDBANKPD
      ** ========
 
     C                   PARM                    BJSBRC
     C                   PARM                    BJDFIN
     C                   PARM                    BJMRDT
 
      ** SDGELRPD
      ** ========
 
     C                   PARM                    BKOBUV
 
      ** SDDEALPD
      ** ========
 
     C                   PARM                    BNDCSP
     C                   PARM                    BNTHSP
 
      ** Output Parameters
      ** =================
      ** Error Message
 
     C                   PARM      *BLANK        PErrMsg
 
      ** Option Selected
 
     C                   PARM      *BLANK        POpSel
 
      ** Deal Number Selected
 
     C                   PARM      *BLANK        PDlSel
 
      ** Command Keys
 
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKL
 
      ** If CK/3 taken in browse, end program
 
     C                   IF        PINKC = '1'
     C                   EXSR      SREndP
     C                   GOTO      EBLDBR
     C                   ENDIF
 
      ** If error message returned from browse, send it to detail screen
 
     C                   IF        PErrMsg <> *BLANK
     C                   EXSR      SRSndMsgM
     C                   GOTO      EBLDBR
     C                   ENDIF
 
      ** If CK/12 not taken in browse
      ** Read next browse subfile record
 
     C                   IF        PINKL <> '1'
     C                   EVAL      WRdnb = 'Y'
     C                   EVAL      WScrn = 'R'
     C                   GOTO      EBLDBR
 
     C                   ELSE
 
      ** Set NwDlScnFmt
      ** Set field and function key status on main details screen
      ** (according to action code)
 
     C                   IF        DDACTN <> *BLANK
 
     C                   EVAL      NwDlScnFmt = CrDlScnFmt
     C                   EXSR      SRSetFldS
     C                   EXSR      SRSetKeyS
 
     C                   ELSE
 
     C                   CLEAR                   NwDlScnFmt
     C                   EXSR      SRInzFldS
     C                   EXSR      SRInzKeyS
 
     C                   ENDIF
     C                   ENDIF
 
     C     EBLDBR        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRRdNBrw - Read next browse subfile record
      *****************************************************************
     C     SRRdNBrw      BEGSR
 
      ** Read next subfile record
     C                   CALLB     'ABFUNDBRW'
 
      ** Input Parameters
      ** ================
      ** Return Code
 
     C                   PARM      *BLANK        RetCodeOut
 
      ** Deal Number Pointer
 
     C                   PARM                    DDDLNO
 
      ** Build sub-file
 
     C                   PARM      *BLANK        PBdSfl
 
      ** Read subfile record
 
     C                   PARM      'Y'           PRdSfl
 
      ** Standing Data
      ** =============
      ** SDBANKPD
      ** ========
 
     C                   PARM                    BJSBRC
     C                   PARM                    BJDFIN
     C                   PARM                    BJMRDT
 
      ** SDGELRPD
      ** ========
 
     C                   PARM                    BKOBUV
 
      ** SDDEALPD
      ** ========
 
     C                   PARM                    BNDCSP
     C                   PARM                    BNTHSP
 
      ** Output Parameters
      ** =================
      ** Error Message
 
     C                   PARM      *BLANK        PErrMsg
 
      ** Option Selected
 
     C                   PARM      *BLANK        POpSel
 
      ** Deal Number Selected
 
     C                   PARM      *BLANK        PDlSel
 
      ** Command Keys
 
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKL
 
      ** If deal read from subfile
 
     C                   IF        PDlSel <> *BLANK
 
      ** Retrieve deal details
 
     C                   EVAL      DDACTN = POpSel
     C                   EVAL      DDDLNO = PDlSel
     C                   EXSR      SRRtvDl
 
      ** Set field and function key status on main details screen
      ** (according to action code)
 
     C                   EXSR      SRSetFldS
     C                   EXSR      SRSetKeyS
 
      ** Put the deal on the main details screen
 
     C                   EXSR      SRCvtoScn
 
      ** Else, reset read next browse subfile record
 
     C                   ELSE
     C                   EVAL      WRdnb = *BLANK
     C                   ENDIF
 
      ** Go to main details screen
 
     C                   EVAL      WScrn = 'M'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRRtvDl - Retrieve Deal
      *****************************************************************
     C     SRRtvDl       BEGSR
 
      ** RETRIEVE DEAL
 
     C                   CALLB     'ABFUNDRTV'
 
      ** Input Parameters
      ** ================
      * Return code
 
     C                   PARM      *BLANK        RetCodeOut
 
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen Input function)
 
     C                   PARM      '*SIN  '      PModeOfOp
 
      ** Response mode
 
     C                   PARM      'S'           PRespMode
 
      ** Action Code
      ** Front Office Transaction ID
      ** Front Office Associated Transaction Id
      ** (Midas) Deal Number
      ** (Midas) Associated Deal Number
      ** (Midas) Booking Branch
      ** (Midas) Booking Branch for Associated Deal
      ** Linked maintenance flag
 
     C                   PARM                    DDACTN
     C                   PARM                    PFrntId
     C                   PARM                    PFrntAsId
     C                   PARM                    DDDLNO
     C                   PARM                    DDDADN
     C                   PARM                    DDBRC1
     C                   PARM                    DDBRC2
     C                   PARM                    PLnkFlag
 
      ** Standing Data
      ** =============
      ** SDBANKPD
      ** ========
 
     C                   PARM                    BJSBRC
 
      ** SDGELRPD
      ** ========
 
     C                   PARM                    BKOBUV
 
      ** ZMUSER
      ** ========
 
     C                   PARM                    PDBRN
 
      ** Output Parameters
      ** =================
      ** (Current) deal in file format of deal
      ** (Current) deal in file format of deal of associated deal
      ** OK - Action code
      ** OK - Deal Number
      ** OK - Booking branch
      ** OK - Booking branch for associated deal number
 
     C                   PARM                    CrDlFilFmt1
     C                   PARM                    CrDlFilFmt2
     C                   PARM      *BLANK        OKACTN
     C                   PARM      *BLANK        OKDLNO
     C                   PARM      *BLANK        OKBRC1
     C                   PARM      *BLANK        OKBRC2
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM      *ZERO         WkIdx
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRCvtoScn - Put a deal on the main details screen
      *****************************************************************
     C     SRCvtoScn     BEGSR
 
      ** Call program to fill screen fields with data from MMDELDPP
 
     C                   CALLB     'ABFUNDCVT'
 
      ** Input Parameter
      ** ================
      ** Return Code
 
     C                   PARM      *BLANK        RetCodeOut
 
      ** Action Code
 
     C                   PARM                    DDACTN
 
      ** Deal in file format of deal
      ** Deal in file format of associated deal
 
     C                   PARM                    CrDlFilFmt1
     C                   PARM                    CrDlFilFmt2
 
      ** Standing Data
      ** =============
      ** SDBANKPD
      ** ========
 
     C                   PARM                    BJDFIN
 
      ** SDDEALPD
      ** ========
 
     C                   PARM                    BNDCSP
                                                                                              CAS004
     C                   PARM                    CAS004                                       CAS004
                                                                                              CDL019
     C                   PARM                    CDL019                                       CDL019
                                                                                              CDL020
     C                   PARM                    CDL020                                       CDL020
 
      ** Output Parameters
      ** =================
      ** Deal in screen format
 
     C                   PARM                    NwDlScnFmt
 
      ** Deal Status
 
     C                   PARM                    PDDSTS
 
      ** Profit Centre Description 1
      ** Profit Centre Description 2
 
     C                   PARM                    PPRF1D
     C                   PARM                    PPRF2D
 
      ** Front Office Transaction ID                                                          261140
     C                   PARM                    FRNT                                         261140
                                                                                              261140
      ** Associated Front Office Transaction ID                                               261140
     C                   PARM                    AFRT                                         261140
                                                                                              261140
      ** Update 'Current' Deal with Deal in Screen Format
 
     C                   EVAL      CrDlScnFmt = NwDlScnFmt
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRSetFldS - Set field status on main details screen
      *          according to action code
      *****************************************************************
     C     SRSetFldS     BEGSR
 
      ** Enable/disable key & detail fields on main details screen
      ** (key fields = action code & deal number; detail fields = rest)
      ** (Action code can only be 'I', 'A', 'E',  or 'D')
 
     C                   IF        PLnkFlag = 'Y'
     C                   EVAL      PKeyFld = 'N'
     C                   EVAL      PDetFld = 'N'
     C                   GOTO      ESETFLD
     C                   ENDIF
 
     C                   IF        DDACTN = 'I' OR DDACTN = 'A'
     C                   EVAL      PKeyFld = 'Y'
     C                   EVAL      PDetFld = 'Y'
     C                   ELSE
     C                   EVAL      PKeyFld = 'N'
     C                   EVAL      PDetFld = 'N'
     C                   ENDIF
 
     C     ESETFLD       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRSetKeyS - Set function key status on main details screen
      *          according to action code
      *****************************************************************
     C     SRSetKeyS     BEGSR
 
      ** Enable/disable function keys on main details screen
 
      ** KG = Command key 07 = Read Previous
      ** KH = Command key 08 = Read Next
 
     C                   IF        PLnkFlag = 'Y'
     C                   EVAL      PEINKG  = 'N'
     C                   EVAL      PEINKH  = 'N'
     C                   EVAL      PEINKP  = 'N'
     C                   EVAL      PEINKJ  = 'N'
     C                   GOTO      ESETKEY
     C                   ENDIF
 
     C                   EVAL      PEINKG = 'Y'
     C                   EVAL      PEINKH = 'Y'
 
      ** KJ = Command key 10 = Confirm Delete
 
     C                   IF        DDACTN = 'D'
     C                   EVAL      PEINKJ = 'Y'
     C                   ELSE
     C                   EVAL      PEINKJ = 'N'
     C                   ENDIF
 
      ** KP = Command key 15 = Browse
 
     C                   EVAL      PEINKP = 'Y'
 
     C     ESETKEY       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRInzFldS - Initialize field status on main details screen
      *****************************************************************
     C     SRInzFldS     BEGSR
 
      ** Enable key & details fields on main details screen
 
     C                   EVAL      PKeyFld = 'Y'
     C                   EVAL      PDetFld = 'Y'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRInzKeyS - Initialise function key status on main details screen
      *****************************************************************
     C     SRInzKeyS     BEGSR
 
      ** Enable/Disable function keys on main details screen
      ** KG = Command key 07 = Read previous
      ** KH = Command Key 08 = Read next
      ** KJ = Command Key 10 = Confirm Delete
      ** KP = Command Key 15 = Browse
 
     C                   EVAL      PEINKG = 'Y'
     C                   EVAL      PEINKH = 'Y'
     C                   EVAL      PEINKJ = 'N'
     C                   EVAL      PEINKP = 'Y'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRCancM - Cancel on main details screen
      *****************************************************************
     C     SRCancM       BEGSR
 
      ** Reset Read Next Browse Subfile Record (if active)
 
     C                   EVAL      WRdnb = *BLANK
 
      ** Blank the main details screen
 
     C                   EVAL      NwDlScnFmt = *BLANK
     C                   EVAL      PDDSTS = *BLANK
     C                   EVAL      PPRF1D = *BLANK
     C                   EVAL      PPRF2D = *BLANK
 
      ** Initialize field and function key status on main details screen
 
     C                   EXSR      SRInzFldS
     C                   EXSR      SRInzKeyS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRSndMsgM - Send a message to main details screen
      *****************************************************************
     C     SRSndMsgM     BEGSR
 
      ** If single branching, user can't browse file
 
     C                   IF        PErrMsg = 'FXM0292'
     C                   EVAL      OKACTN = 'N'
     C                   ENDIF
 
      ** Deal number on screen must be blank or numeric for pointer
 
     C                   IF        PErrMsg = 'MMM0162'
     C                   EVAL      OKDLNO = 'N'
     C                   ENDIF
 
      ** Add error message to array passed to detail screen
 
     C                   Z-ADD     1             E                 3 0
     C     *BLANK        LOOKUP    FldNameArr(E)                          99
     C                   EVAL      FldNameArr(E) = '*ANY'
     C                   EVAL      MsgIdArr(E) = PErrMsg
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRScnConf - Process screen: Confirmation of input
      *          evoked for inserts and amends
      *****************************************************************
     C     SRScnConf     BEGSR
 
      ** Output message 'Press enter to accept'
 
     C                   EVAL      WkWIdx = 1
     C                   EVAL      WFldNamArr(WkWIdx) = '*ANY'
     C                   EVAL      WMsgIdArr(WkWIdx) = 'MMM1030'
 
      ** Write/Read display screen
 
     C                   CALLB     'ABFUNDDSP'
 
      ** Input Parameters
      ** ================
      ** Return Code
     C                   PARM      *BLANK        RetCodeOut
 
      ** Deal (in screen format)
 
     C                   PARM                    NwDlScnFmt
 
      ** Deal Status
      ** Profit Centre Description 1
      ** Profit Centre Description 2
 
     C                   PARM                    PDDSTS
     C                   PARM                    PPRF1D
     C                   PARM                    PPRF2D
 
      ** Fields in error
 
     C                   PARM                    OkFlags
 
      ** Errors
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Warnings
 
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
 
      ** Enabled key and detail fields
 
     C                   PARM      'N'           PKeyFld
     C                   PARM      'N'           PDetFld
 
      ** Enabled function keys
 
     C                   PARM      'N'           PEINKG
     C                   PARM      'N'           PEINKH
     C                   PARM      'N'           PEINKJ
     C                   PARM      'N'           PEINKP
 
      ** Successful insert deal
 
     C                   PARM                    PSIDN
 
      ** Linked maintenance flag
 
     C                   PARM                    PLnkFlag
 
      ** Write screen with no read indicator
 
     C                   PARM      'N'           WriteOnly         1
 
      ** Standing Data
      ** =============
      ** SDBANKPD
      ** ========
 
     C                   PARM                    BJMRDT
 
      ** SDGELRPD
      ** ========
 
     C                   PARM                    BKOBRU
     C                   PARM                    BKPRCU
 
      ** RUNDAT
      ** ======
 
      ** Multibranching Indicator
     C                   PARM                    PAGMBIN
                                                                                              CAS004
     C                   PARM                    CAS004                                       CAS004
 
     C                   PARM                    CDL019                                       CDL019
                                                                                              CDL020
     C                   PARM                    CDL020                                       CDL020
 
      ** Output Parameters
      ** =================
      ** Function Keys
 
     C                   PARM      '0'           PINKC             1
     C                   PARM      '0'           PINKG             1
     C                   PARM      '0'           PINKH             1
     C                   PARM      '0'           PINKJ             1
     C                   PARM      '0'           PINKL             1
     C                   PARM      '0'           PINKP             1
 
      ** Reset Errors
 
     C                   EXSR      SRResetErr
 
      ** CK/3 - End Program
 
     C                   IF        PINKC = '1'
     C                   EXSR      SREndP
     C                   GOTO      ESCRN@C
     C                   ENDIF
 
      ** CK/12 - Cancel on Confirmation Screen
 
     C                   IF        PINKL = '1'
     C                   EXSR      SRCancC
     C                   GOTO      ESCRN@C
     C                   ENDIF
 
      ** Exit confirmation screen
 
     C                   EXSR      SRExitC
 
     C     ESCRN@C       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRCancC - Cancel on confirmation screen
      *****************************************************************
     C     SRCancC       BEGSR
 
      ** Return to main details screen
 
     C                   EVAL      WScrn = 'M'
 
      ** Initialize field status on main details screen
 
     C                   EXSR      SRInzFldS
 
      ** Set function key status on main details screen
      ** (according to action code)
 
     C                   EXSR      SRSetKeyS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRExitC - Exit from confirmation screen
      *****************************************************************
     C     SRExitC       BEGSR
 
      ** if no errors in validation
 
     C                   IF        WkIdx = 0
 
      ** Continue with updates
 
     C                   EVAL      WScrn = 'U'
 
      ** Else, return to main details screen
 
     C                   ELSE
     C                   EVAL      WScrn = 'M'
 
      ** Initialize field status on main details screen
 
     C                   EXSR      SRInzFldS
 
      ** Set function key status on main details screen
      ** (according to action code)
 
     C                   EXSR      SRSetKeyS
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRUpdate - Updates
      *****************************************************************
     C     SRUpdate      BEGSR
 
      ** If Insert or Amend
 
     C                   IF        DDACTN = 'I' OR DDACTN = 'A'
 
     C                   EVAL      WSetFld = '1'
     C                   EXSR      SRSetValid
 
     C                   ENDIF
 
      ** Update deal
      ** Money Market updates
 
     C                   CALLB     'MMLDNIUPM'
     C                   PARM      *BLANK        @RtCd
     C                   PARM                    NwDlFilFmt1
 
      ** Deals updates
 
     C                   IF        @RtCd = *BLANK
     C                   CALLB     'MMLDNIUPD'
     C                   PARM                    @RtCd
     C                   PARM                    NwDlFilFmt1
     C                   ENDIF
 
      ** Update associated deal
 
     C                   IF        @RtCd = *BLANK
 
      ** Money Market updates for associated deal
 
     C                   CALLB     'MMLDNIUPM'
     C                   PARM      *BLANK        @RtCd
     C                   PARM                    NwDlFilFmt2
 
      ** Deals updates for associated deal
 
     C                   IF        @RtCd = *BLANK
     C                   CALLB     'MMLDNIUPD'
     C                   PARM                    @RtCd
     C                   PARM                    NwDlFilFmt2
     C                   ENDIF
 
     C                   ENDIF
 
      ** If there were any errors in the update functions, rollback any
      ** updates and end this program.  Otherwise, commit the updates
 
     C                   IF        @RtCd <> *BLANK AND @RtCd <> '*RECUPD'
     C     CSC022        IFEQ      'N'                                                        CSC022
     C                   ROLBK
     C                   ELSE                                                                 CSC022
     C     COMITSKIP     IFNE      'Y'                                                        CSC022
     C                   ROLBK                                                                CSC022
     C                   ELSE                                                                 CSC022
     C                   SETON                                        U7U8                    CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF                                                                CSC022
     C                   EXSR      *PSSR
     C                   ELSE
 
     C                   IF        @RtCd = '*RECUPD'
     C     CSC022        IFEQ      'N'                                                        CSC022
     C                   ROLBK
     C                   ELSE                                                                 CSC022
     C     COMITSKIP     IFNE      'Y'                                                        CSC022
     C                   ROLBK                                                                CSC022
     C                   ELSE                                                                 CSC022
     C                   SETON                                        U7U8                    CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF                                                                CSC022
     C                   ELSE
     C     CSC022        IFEQ      'N'                                                        CSC022
     C                   COMMIT
     C                   ELSE                                                                 CSC022
     C     COMITSKIP     IFNE      'Y'                                                        CSC022
     C                   COMMIT                                                               CSC022
     C                   END                                                                  CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF
 
     C                   ENDIF
 
      ** If update not done due to record being updated by another
      ** workstation send message to screen.
 
     C
     C                   IF        @RtCd = '*RECUPD'
     C
     C                   EVAL      FldNameArr(1) = '*ANY'
     C                   EVAL      MsgIdArr(1)   = 'MMM1023'
     C
     C                   ENDIF
     C
 
      ** Blank the main details screen if insert or delete
 
     C                   IF        DDACTN = 'I' AND @RtCd = *BLANK
     C                   EVAL      NwDlScnFmt = *BLANKS
     C                   EVAL      FldNameArr(1) = '*ANY'
     C                   MOVE      N1DN38        WData1
     C                   MOVE      N1DADN        WData2
     C                   EVAL      MsgDtaArr(1)   = WData
     C                   EVAL      MsgIdArr(1)   = 'ABM0200'
     C/COPY WNCPYSRC,ABFUNDSC01
     C                   ENDIF
 
     C                   IF        DDACTN = 'D' AND @RtCd = *BLANK
     C                   EVAL      NwDlScnFmt = *BLANKS
     C                   EVAL      FldNameArr(1) = '*ANY'
     C                   EVAL      MsgIdArr(1)   = 'DLM0160'
     C                   ENDIF
 
      ** Leave screen details after amendment of deal
 
     C                   IF        DDACTN = 'A' AND @RtCd = *BLANK
     C                   EVAL      FldNameArr(1) = '*ANY'
     C                   EVAL      MsgIdArr(1)   = 'FDM8050'
     C                   ENDIF
 
      ** Initialize field and function key status on main details screen
 
     C                   EXSR      SRInzFldS
     C                   EXSR      SRInzKeyS
 
      ** If records are still to be read from the subfile, read them
 
     C                   IF        WRdnb = 'Y'
     C                   EVAL      WScrn = 'R'
     C                   ELSE
 
      ** else, return to main details screen
 
     C                   EVAL      WScrn = 'M'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRGetNxtDl - Get next deal number
      *****************************************************************
     C     SRGetNxtDl    BEGSR
 
      ** Get next deal number
 
     C                   CALLB     'CAGETNXTDL'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM      *BLANKS       PMsgId
     C                   PARM                    PDDDLNO
     C                   PARM      *ZERO         PDealNum
 
      ** Database error
 
     C                   IF        PMsgId <> *BLANK
     C                   EVAL      DBKEY = PDDDLNO                              ************
     C                   EVAL      DBFILE = 'CAGTNXDL'                          * DBERR 006*
     C                   EVAL      DBASE = 006                                  ************
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSetValid - Set up additional fields that are needed on the  *
      *    Valid file record.                                         *
      *                                                               *
      * Called by: SRUpdate                                           *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRSetValid    BEGSR
 
      ** If Insert and deal number not defined,
      ** get next available deal number
 
     C                   IF        DDACTN = 'I' AND DDDLNO = *BLANK
 
     C/COPY WNCPYSRC,ABFUNDSC02
     C                   EXSR      SRGetNxtDl
     C                   EVAL      N1DN38 = PDealNum
     C/COPY WNCPYSRC,ABFUNDSC03
     C                   MOVE      PDealNum      N1PCDN
     C                   MOVE      PDealNum      N2DADN
     C                   ELSE
     C                   MOVE      DDDLNO        N1DN38
     C                   MOVE      DDDLNO        N1PCDN
     C                   MOVE      DDDLNO        N2DADN
 
     C                   ENDIF
 
      ** If Insert deal associated number not defined ,
      ** get next available deal associated number
 
     C                   IF        DDACTN = 'I' AND DDDADN = *BLANK
 
     C/COPY WNCPYSRC,ABFUNDSC04
     C                   EXSR      SRGetNxtDl
     C                   EVAL      N2DN38 = PDealNum
     C/COPY WNCPYSRC,ABFUNDSC05
     C                   MOVE      PDealNum      N2PCDN
     C                   MOVE      PDealNum      N1DADN
     C                   ELSE
     C                   MOVE      DDDADN        N2DN38
     C                   MOVE      DDDADN        N2PCDN
     C                   MOVE      DDDADN        N1DADN
 
     C                   ENDIF
 
      ** Setup other fields prior to update.
 
     C                   DOW       WSetFld <> 'N'
 
     C                   IF        WSetFld = '1'
 
     C                   EVAL      UpdDlFilFmt = NwDlFilFmt1
     C                   EVAL      IKMTYP = 'IL'
     C                   EVAL      IKTYPE = 'IL'
     C                   EVAL      IKPOBR = N2BRCA
     C                   EVAL      IKROBR = N2BRCA
     C                   Z-SUB     IKAMNP        IKAMNP
                                                                                              CAS004
     C                   IF        CAS004 = 'Y'                                               CAS004
     C                   EVAL      IKOYLC = N1OYLC                                            CAS004
     C                   ENDIF                                                                CAS004
                                                                                              CAS004
     C                   ELSE
     C                   EVAL      UpdDlFilFmt = NwDlFilFmt2
     C                   EVAL      IKMTYP = 'ID'
     C                   EVAL      IKTYPE = 'ID'
     C                   EVAL      IKPOBR = N1BRCA
     C                   EVAL      IKROBR = N1BRCA
     C                   Z-SUB     IKMTTI        IKMTTI
                                                                                              CAS004
     C                   IF        CAS004 = 'Y'                                               CAS004
     C                   EVAL      IKOYLC = N2OYLC                                            CAS004
     C                   ENDIF                                                                CAS004
                                                                                              CAS004
     C                   ENDIF
 
      ** Time of Input
 
     C                   TIME                    IKTIME
 
      ** Record Identifier
 
     C                   EVAL      IKRCID = 'HK'
 
      ** Logical Delete Flag
 
     C                   EVAL      IKDLTF = ' '
 
      ** Date and Time of Last Update
 
     C                   EVAL      IKDLUP = WkDLUP
     C                   EVAL      IKMLUP = WkMLUP
     C                   EVAL      IKYLUP = WkYLUP
     C                   TIME                    IKTLUP
 
      ** Type of last change
 
     C                   IF        DDACTN <> 'E'
     C                   EVAL      IKCHTP = DDACTN
     C                   ENDIF
 
      ** Last Change Date
 
     C**********         EVAL      IKLCD  = BJRDNB                                            CSC011
     C                   EVAL      IKLCD  = WRunDay                                           CSC011
 
      ** Last Update User ID
 
     C                   EVAL      IKLUID = PSUser
 
      ** Broker Code
 
     C                   EVAL      IKBKCD = 'PHON'
 
      ** Deal Transaction Date
 
     C                   EVAL      IKDTYY = DDATYr
     C                   EVAL      IKDTMM = DDATMn
     C                   EVAL      IKDTDD = DDATDy
 
      ** Deal Deleted indicator
 
     C                   EVAL      IKDDLT = ' '
 
      ** Deal Status Indicator
 
     C                   EVAL      IKDSTS = 'A'
 
      ** Rollover indicator
 
     C                   EVAL      IKRBSI = ' '
 
      ** Deal PC Transaction number
 
     C                   EVAL      IKPCTN = *Zeros
 
      ** Deal last action
 
     C                   EVAL      IKLACT = DDACTN
 
      ** Deal Brokerage
 
     C                   MOVE      *ALL'9'       IKBRKG
 
      ** Deal User Code
      ** Deal authorisation officer
 
     C                   EVAL      IKDUSC = PSUser
     C                   EVAL      IKAOFR = PSUser
 
      ** Deal action date
 
     C                   MOVE      PDateOutZ9    IKLDAT
 
      ** Start/Last interest date = Deal value date
 
     C                   EVAL      IKSLYY = IKVDYY
     C                   EVAL      IKSLMM = IKVDMM
     C                   EVAL      IKSLDD = IKVDDD
 
      ** Input interest rate
 
     C                   Z-ADD     IKINTR        IKIIRT
 
      ** Account Sequence Number
 
     C                   EVAL      IKACSQ = 1
 
      ** Negative Interest Indicator
 
     C                   IF        IKINTR < 0
     C                   EVAL      IKNGVI = 'Y'
     C                   ENDIF
 
      ** Midas Taxable Indicator
 
     C                   EVAL      IKMTAX = 'N'
 
      ** Interest accrual contr year = Deal value date
 
     C                   EVAL      IKIAYY = IKVDYY
     C                   EVAL      IKIAMM = IKVDMM
     C                   EVAL      IKIADD = IKVDDD
 
      ** Interest at maturity
 
     C*                  Z-ADD     IKINTR        PINTD
     C                   EXSR      SRSetIMAT
 
      ** If Amount is negative
 
     C                   IF        IKAMNP < 0
 
     C                   IF        PIMAT < 0
     C                   Z-SUB     PIMAT         IKIMAT
     C                   ELSE
     C                   Z-ADD     PIMAT         IKIMAT
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        PIMAT < 0
     C                   Z-ADD     PIMAT         IKIMAT
     C                   ELSE
     C                   Z-SUB     PIMAT         IKIMAT
     C                   ENDIF
 
     C                   ENDIF
 
      ** Ensure Interest at Maturity is same sign as amt if -VE INT.
 
     C                   IF        IKNGVI = 'Y'
     C                   IF        IKAMNP < 0
 
     C                   IF        PIMAT < 0
     C                   Z-ADD     PIMAT         IKIMAT
     C                   ELSE
     C                   Z-SUB     PIMAT         IKIMAT
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        PIMAT < 0
     C                   Z-SUB     PIMAT         IKIMAT
     C                   ELSE
     C                   Z-ADD     PIMAT         IKIMAT
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
      ** Set automatic authorisation flag to 'Y'
 
     C                   EVAL      IKAUTH = 'Y'
 
      ** If first time around setup WSetFld to '2'
      ** If WSetFld = '2' set it to 'N'
 
     C                   IF        WSetFld = '1'
     C                   EVAL      NwDlFilFmt1 = UpdDlFilFmt
     C                   EVAL      WSetFld = '2'
     C                   ELSE
     C                   EVAL      NwDlFilFmt2 = UpdDlFilFmt
     C                   EVAL      WSetFld = 'N'
     C                   ENDIF
 
     C                   ENDDO
 
      /COPY WNCPYSRC,ABFUNDC019
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSetIMAT - Calulate Interest at Maturity                     *
      *                                                               *
      * Called by: SRSetValid                                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *                                                               *
      *****************************************************************
     C     SRSetIMAT     BEGSR
 
     C                   CALLB     'MM1010'
 
      ** Input Parameters
      ** ================
      ** Total Interest
      ** Interest to date
      ** Interest Payment Frequency
      ** Next interest payment date
      ** Value Date
      ** Interest Calculation Method
      ** Deal Amount
      ** Effective Interest rate
      ** Round Down Interest Indicator
      ** Taxable Indicator
      ** Deal Number
 
     C                   PARM      IKMTTI        PMTTI
     C                   PARM                    PINTD
     C                   PARM      IKIPFQ        PIPFQ
     C                   PARM      IKNIPD        PNIPD
     C                   PARM      IKDVSD        PDVSD
     C                   PARM      IKICMT        PICMT
     C                   PARM      IKAMNP        PAMNP
     C                   PARM      IKINTR        PINTR
     C                   PARM      IKRDFC        PRDFC
     C                   PARM      IKMTAX        PMTAX
     C                   PARM      IKDN38        PDeal
 
      ** Maturity Date for BRT Calculation
 
     C                   PARM                    PBRMD
 
      **  Hong Kong Tax Rate from Dealing ICD
 
     C                   PARM                    BNHKTR
     C                   PARM                    S01383
 
      ** SDBRTDPD
      ** ========
      ** BRT Rate
      ** Date Effective From
      ** BRT Rate - Previous
 
     C                   PARM                    BRTR
     C                   PARM                    DEFF
     C                   PARM                    PBRTR
 
      ** Customer Number
 
     C                   PARM      IKCNUM        PCNUM
 
      ** Currency Code
      ** Location Code
 
     C                   PARM                    PZCCY
     C                   PARM                    PZLOC
 
      ** Interest at Maturity
 
     C                   PARM                    PIMAT
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SREndP - End program
      *****************************************************************
     C     SREndP        BEGSR
 
      ** Issue rollback to clear any possible updates in window function
 
     C                   IF        BGWDPR = 'Y'
     C     CSC022        IFEQ      'N'                                                        CSC022
     C                   ROLBK
     C                   ELSE                                                                 CSC022
     C     COMITSKIP     IFNE      'Y'                                                        CSC022
     C                   ROLBK                                                                CSC022
     C                   ELSE                                                                 CSC022
     C                   SETON                                        U7U8                    CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF
 
      ** If called as a linked enquiry set ReturnCode
 
     C                   IF        PLnkFlag = 'Y'
 
     C                   SELECT
 
      ** CK/12 - set ReturnCode to 'U'
 
     C                   WHEN      PINKL = '1'
     C                   EVAL      ReturnCode = 'U'
 
      ** CK/03 - set ReturnCode to 'Q'
 
     C                   WHEN      PINKC = '1'
     C                   EVAL      ReturnCode = 'Q'
 
     C                   ENDSL
 
     C                   ENDIF
 
     C                   EVAL      WScrn = 'T'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRResetErr - Reset error fields                              *
      *                                                               *
      *****************************************************************
     C     SRResetErr    BEGSR
 
      ** Reset error fields.
 
     C                   CLEAR                   FldNameArr
     C                   CLEAR                   MsgIDArr
     C                   CLEAR                   MsgDtaArr
     C                   Z-ADD     *ZERO         WkIdx
 
     C                   CLEAR                   WFldNamArr
     C                   CLEAR                   WMsgIdArr
     C                   CLEAR                   WMsgDtaArr
     C                   Z-ADD     *ZERO         WkWIdx
 
 
      ** Initialise screen fields error indicators.
 
     C                   EVAL      OkFlags = *ALL'Y'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial Processing
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Receive entry parameters.
 
     C     *ENTRY        PLIST
 
      ** Return code
 
     C                   PARM                    ReturnCode
 
      ** Action code
 
     C                   PARM                    PAction
 
      ** Internal Deal Number
 
     C                   PARM                    PDealNo
 
      ** Linked maintenance flag
 
     C                   PARM                    PLnkFlag
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        @RtCd <> *BLANKS
     C                   EVAL      DBKEY  =  @Optn                              ************
     C                   EVAL      DBFILE =  'SDBANKPD'                         * DBERR 001*
     C                   EVAL      DBASE  =  001                                ************
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access Module Details
 
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDMMOD        PARM      SDMMOD        DSFDY
 
      ** Database Error
 
     C                   IF        @RtCd <> *BLANKS
     C                   EVAL      DBKEY  =  @Optn                              ************
     C                   EVAL      DBFILE =  'SDMMODPD'                         * DBERR 002*
     C                   EVAL      DBASE  =  002                                ************
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access General Ledger Details
 
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST '     @Optn
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
 
      ** Database Error
 
     C                   IF        @RtCd <> *BLANKS
     C                   EVAL      DBKEY  =  @Optn                              ************
     C                   EVAL      DBFILE =  'SDGELRPD'                         * DBERR 003*
     C                   EVAL      DBASE  =  003                                ************
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access Dealing Data Details
 
     C**********         CALL      'AODEALR0'                                                 CGL029
     C                   CALL      'AODEALR1'                                                 CGL029
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST '     @Optn
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
 
      ** Database Error
 
     C                   IF        @RtCd <> *BLANKS
     C                   EVAL      DBKEY  =  @Optn                              ************
     C                   EVAL      DBFILE =  'SDDEALPD'                         * DBERR 004*
     C                   EVAL      DBASE  =  004                                ************
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access Trading Details
 
     C                   CALL      'AOTRADR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDTRAD        PARM      SDTRAD        DSFDY
 
      ** Database Error
 
     C                   IF        @RtCd <> *BLANKS
     C                   EVAL      DBKEY  =  @Optn                              ************
     C                   EVAL      DBFILE =  'SDTRADPD'                         * DBERR 005*
     C                   EVAL      DBASE  =  005                                ************
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Check if S01383 is installed                                                         195001
                                                                                              195001
     C                   EVAL      S01383 = 'N'                                               195001
     C                   CALL      'AOSARDR0'                                                 195001
     C                   PARM      *Blanks       @RtCd                                        195001
     C                   PARM      '*VERIFY'     @Optn                                        195001
     C                   PARM      'S01383'      @SARD                                        195001
     C     SCSARD        PARM      SCSARD        DSFDY                                        195001
                                                                                              195001
     C                   IF        @RtCd = *Blanks                                            195001
     C                   EVAL      S01383 = 'Y'                                               195001
     C                   ENDIF                                                                195001
                                                                                              195001
      ** Database error.                                                                      195001
                                                                                              195001
     C                   IF        @RtCd <> *BLANKS  AND                                      195001
     C                             @RtCd <> '*NRF   '                                         195001
     C                   EVAL      DBKEY = @SARD                                ************  195001
     C                   EVAL      DBFILE = 'SCSARDPD'                          * DBASE 007*  195001
     C                   EVAL      DBASE  =  007                                ************  195001
     C                   EXSR      *PSSR                                                      195001
     C                   ENDIF                                                                195001
                                                                                              195001
      ** Access SD BRT Control Data
 
     C                   IF        S01383 = 'Y'                                               195001
     C                   EVAL      PKey = 'D'
     C     PKey          CHAIN     SDBRTDL1                           02
 
      ** Database error.
 
     C                   IF        RecNotFnd = True  OR
     C                             RECI <> 'D'
     C                   EVAL      DBKEY = PKey                                 ************
     C                   EVAL      DBFILE = 'SDBRTDPD'                          * DBERR 006*
     C                   EVAL      DBASE  =  006                                ************
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF                                                                195001
 
      ***Check*if*S01383*is*installed                                                         195001
      **********                                                                              195001
     C**********         EVAL      S01383 = 'N'                                               195001
     C**********         CALL      'AOSARDR0'                                                 195001
     C**********         PARM      *Blanks       @RtCd                                        195001
     C**********         PARM      '*VERIFY'     @Optn                                        195001
     C**********         PARM      'S01383'      @SARD                                        195001
     C*****SCSARD        PARM      SCSARD        DSFDY                                        195001
      **********                                                                              195001
     C**********         IF        @RtCd = *Blanks                                            195001
     C**********         EVAL      S01383 = 'Y'                                               195001
     C**********         ENDIF                                                                195001
      **********                                                                              195001
      ***Database error.                                                                      195001
      **********                                                                              195001
     C**********         IF        @RtCd <> *BLANKS  AND                                      195001
     C**********                   @RtCd <> '*NRF   '                                         195001
     C**********         EVAL      DBKEY = @SARD                                ************  195001
     C**********         EVAL      DBFILE = 'SCSARDPD'                          * DBASE 007*  195001
     C**********         EVAL      DBASE  =  007                                ************  195001
     C**********         EXSR      *PSSR                                                      195001
     C**********         ENDIF                                                                195001
 
     C                   CALLB     'MMFIDINIT'
     C                   PARM      *BLANKS       @RTCD
 
     C                   IF        @RtCd <> *BLANKS
     C                   EVAL      RunBefore = 'Y'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Retrieve ZMUSER details.
 
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
 
      ** Retrieve RUNDAT details.
 
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
 
      ** Start on Main Details Screen
 
     C                   EVAL      WScrn  =  'M'
 
      ** Initialize field and function key status on main details screen
 
     C                   EXSR      SRInzFldS
     C                   EXSR      SRInzKeyS
 
      ** Save Midas Run Date
 
     C                   EVAL      WkBJMRDT = BJMRDT
 
      ** Check if CSC011 is installed                                                         CSC011
                                                                                              CSC011
     C                   EVAL      WRunDay = BJRDNB                                           CSC011
                                                                                              CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRtCd                                        CSC011
     C                   PARM      '*VERIFY'     POptn                                        CSC011
     C                   PARM      'CSC011'      PSard                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
     C                   IF        PRtCd = *Blanks                                            CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IN        SDSTAT                                                     CSC011
     C                   IF        S1SUPP = LIBR                                              CSC011
     C                   EVAL      WRunDay = S1DATE                                           CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
     C                   IF        PRtCd <> '*NRF'                                            CSC011
     C     *LOCK         IN        LDA                                                        CSC011
     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBASE = 008                                                CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
      *                                                                                       CSC022
      ** Access SAR details file to determine if CSC022 switchable feature                    CSC022
      ** is switched on                                                                       CSC022
     C                   CALLB     'AOSARDR0'                                                 CSC022
     C                   PARM      *BLANKS       PRtCd                                        CSC022
     C                   PARM      '*VERIFY'     POptn                                        CSC022
     C                   PARM      'CSC022'      PSard                                        CSC022
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC022
                                                                                              CSC022
     C                   IF        PRtCd = *Blanks                                            CSC022
                                                                                              CSC022
     C                   EVAL      CSC022 = 'Y'                                               CSC022
     C                   IN        SCCMTJOB                                                   CSC022
     C                   Z-ADD     1             CNT                                          CSC022
     C                   MOVEL     *BLANKS       COMITSKIP                                    CSC022
     C                   MOVEA     COMITARR      COMITJOB                                     CSC022
     C     COMITNUM      IFGT      0                                                          CSC022
     C     CNT           DOWLE     COMITNUM                                                   CSC022
     C     PSJOBNAME     IFEQ      COMITJOB(CNT)                                              CSC022
     C                   MOVEL     'Y'           COMITSKIP                                    CSC022
     C                   ENDIF                                                                CSC022
     C                   ADD       1             CNT                                          CSC022
     C                   ENDDO                                                                CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ELSE                                                                 CSC022
      ** Database error                                                                       CSC022
                                                                                              CSC022
     C                   IF        PRtCd <> '*NRF'                                            CSC022
     C     *LOCK         IN        LDA                                                        CSC022
     C                   EVAL      DBKEY = PSard                                              CSC022
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC022
     C                   EVAL      DBASE = 011                                                CSC022
     C                   OUT       LDA                                                        CSC022
     C                   EXSR      *PSSR                                                      CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC011
      ** Check if CAS004 is installed                                                         CAS004
                                                                                              CAS004
     C                   CALLB     'AOSARDR0'                                                 CAS004
     C                   PARM      *BLANKS       PRtCd                                        CAS004
     C                   PARM      '*VERIFY'     POptn                                        CAS004
     C                   PARM      'CAS004'      PSard                                        CAS004
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS004
                                                                                              CAS004
     C                   IF        PRtCd <> *BLANKS  and                                      CAS004
     C                             PRtCd <> '*NRF   '                                         CAS004
     C                   EVAL      DBKEY = PSard                                              CAS004
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS004
     C                   EVAL      DBASE = 9                                                  CAS004
     C                   EXSR      *PSSR                                                      CAS004
     C                   ENDIF                                                                CAS004
                                                                                              CAS004
     C                   IF        PRtCd = *Blanks                                            CAS004
     C                   EVAL      CAS004 = 'Y'                                               CAS004
     C                   ELSE                                                                 CAS004
     C                   EVAL      CAS004 = 'N'                                               CAS004
     C                   ENDIF                                                                CAS004
                                                                                              CDL019
      ** Check if CDL019 is installed                                                         CDL019
                                                                                              CDL019
     C                   CALLB     'AOSARDR0'                                                 CDL019
     C                   PARM      *BLANKS       PRtCd                                        CDL019
     C                   PARM      '*VERIFY'     POptn                                        CDL019
     C                   PARM      'CDL019'      PSard                                        CDL019
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL019
                                                                                              CDL019
     C                   IF        PRtCd = *Blanks                                            CDL019
     C                   EVAL      CDL019 = 'Y'                                               CDL019
     C                   ELSE                                                                 CDL019
     C                   EVAL      CDL019 = 'N'                                               CDL019
     C                   ENDIF                                                                CDL019
                                                                                              CDL019
      ** Check if CDL020 is installed                                                         CDL020
                                                                                              CDL020
     C                   CALLB     'AOSARDR0'                                                 CDL020
     C                   PARM      *BLANKS       PRtCd                                        CDL020
     C                   PARM      '*VERIFY'     POptn                                        CDL020
     C                   PARM      'CDL020'      PSard                                        CDL020
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL020
                                                                                              CDL020
     C                   IF        PRtCd = *Blanks                                            CDL020
     C                   EVAL      CDL020 = 'Y'                                               CDL020
     C                   ELSE                                                                 CDL020
     C                   EVAL      CDL020 = 'N'                                               CDL020
     C                   ENDIF                                                                CDL020
                                                                                              CDL020
      ** Convert Midas Day Number to YYYYMMDD format
 
     C                   CALLB     'ZDATE9'
     C**********         PARM      BJRDNB        PDayNoIn                                     CSC011
     C                   PARM      WRunDay       PDayNoIn                                     CSC011
     C                   PARM      *ZERO         PDateOutZ9
     C                   PARM                    PRetCode
 
      ** If called sa a link enquiry bypass initial screen
 
     C                   IF        PLnkFlag = 'Y'
     C                   EVAL      DDACTN = 'E'
     C                   EVAL      DDDLNO = PDealNo
     C                   EXSR      SRValMain
     C                   ENDIF
 
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
 
      /COPY ZACPYSRC,DBFIELDS
 
      ** Hook to enable non-core initial processing to be included
 
      /COPY WNCPYSRC,ABFUND010
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
 
     C/COPY ZACPYSRC,PSSR_ILE
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
**  CPY@
(c) Finastra International Limited 2001
