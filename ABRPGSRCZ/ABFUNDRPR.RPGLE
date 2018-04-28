     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AB Invalid internal funding deals repair')       *
      *****************************************************************
      *                                                               *
      *  Midas - Internal Funding Module                              *
      *                                                               *
      *  ABFUNDRPR - Invalid Internal Funding Deals Repair            *
      *                                                               *
      *  Function:  This function allows invalid or incomplete        *
      *             Internal Funding Deals, previously processed by   *
      *             the API function, to be corrected and then        *
      *             applied to the Midas database.  The module will   *
      *             display a screen that will show a list of invalid *
      *             or incomplete Internal Funding Deals from the     *
      *             invalid transaction file                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CDL096             Date 22Sep14               *
      *  Prev Amend No. CDL094             Date 11Jun14               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 261140             Date 16Sep09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 04Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CGL014             Date 20Oct03               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 CAP076             Date 03Jun02               *
      *                 CAS005             Date 16Dec02               *
      *                 CAS004             Date 26Jun02               *
      * Midas Release 4.01.03-----------------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *                 199787             Date 06Nov01               *
      *                 CSC011             Date 18Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 195001             Date 09Jul01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CAP042  *CREATE    Date 08Jan01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompiled)                                        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  261140 - Missing Front Office ID / Assoc Front Office ID     *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CDL020 - Apply Base Rate at Value Date                       *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *  CAP076 - Lending API enhancements - Rollover details         *
      *           Recompile due to change in MM1010                   *
      *           (new parameter to ZINTDY)                           *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CAS004 - Hedge Accounting Phase A                            *
      *  199787 - Error in parameter passed                          *
      *  CSC011 - 24X7 Midas Availability                             *
      *  195001 - Don't access SDBRTDPD if BRT not switched on.       *
      *  CAP042 - Conversion of Internal Funding Deal inputs into     *
      *           modular structure to use as APIs.                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of Indicator                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRCanC    - Cancel on Confirmation Screen                    *
      *  SRCanM    - Cancel on Main Details Screen                    *
      *  SREndP    - End program                                      *
      *  SRExit    - Exit from Confirmation Screen                    *
      *  SRPutDl   - Put a deal on the main details screen            *
      *  SRRdnBrw  - Read next browse subfile record                  *
      *  SRRtvDel  - Retrieve Deal                                    *
      *  SRScrnB   - Browse invalid deals                             *
      *  SRScrnC   - Confirmation of input evoked for inserts & amend *
      *  SRScrnM   - Process Screen: Main Details                     *
      *  SRSetIMAT - Calculate Interest at Maturity                   *
      *  SRSndM    - Send a message to main details screen            *
      *  SRSubsDta - Transaction Details Data substitution            *
      *  SRUpdat   - Updates                                          *
      *  SRValM    - Validate input to main details screen            *
      *  SRWindow  - Call Window Manager                              *
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
 
      ** Transaction Errors file keyed on Front Office Transaction Id,
      ** Timestamp and Transaction Field Identifier
     FZATRNERRL0IF   E           K DISK    INFSR(*PSSR)
 
      ** Invalid Internal Funding Deals File - for record retrieval
     FABIFUNDL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(ABIFUNDD0:ABIFUNDX0)
     F                                     PREFIX(DD:2)
 
      ** Invalid Internal Funding Deals File - for record update
     FABIFUNDL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(DD:2)
     F                                     COMMIT
 
      ** BRT Control Data
     FSDBRTDL1  IF A E           K DISK    INFSR(*PSSR)
 
      ** API Invalid Log File
     FAPILOGL0  UF   E           K DISK    INFSR(*PSSR) USROPN                                CSC011
     F                                     COMMIT                                             CSC011
                                                                                              CSC011
      ** Hook to enable non-core files to be included
      /COPY WNCPYSRC,ABFUNDR001
 
 
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
 
      ** External DS for Midas Modules
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      ** External DS for API ICD
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
 
      ** External DS for General Ledger ICD
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
 
      ** External SD Trading ICD
     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
     D  QQAccd1      E                     EXTFLD(QQACCD)                                     CGL029
 
      ** External SD Dealing Data
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
     D  QQAccd2      E                     EXTFLD(QQACCD)                                     CGL029
 
      ** Externam DS SC Switchable Features
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** New Deal in Screen Format
     D NwDlScnFmt    E DS                  EXTNAME(ABFUNDPD)
     D                                     PREFIX(DD:2)
 
      * New Deal in File Format 1
     D NwDlFilFmt1   E DS                  EXTNAME(MMVLDNIPD)
     D                                     PREFIX(N1:2)
     D  QQDoriN1     E                     EXTFLD(QQDORI)                                     CGL029
     D  QQMoriN1     E                     EXTFLD(QQMORI)                                     CGL029
     D  QQDopiN1     E                     EXTFLD(QQDOPI)                                     CGL029
     D  QQMopiN1     E                     EXTFLD(QQMOPI)                                     CGL029
     D  QQRonsN1     E                     EXTFLD(QQRONS)                                     CGL029
     D  QQPonsN1     E                     EXTFLD(QQPONS)                                     CGL029
     D  QQInsaN1     E                     EXTFLD(QQINSA)                                     CGL029
 
      * New Deal in File Format 2
     D NwDlFilFmt2   E DS                  EXTNAME(MMVLDNIPD)
     D                                     PREFIX(N2:2)
     D  QQDoriN2     E                     EXTFLD(QQDORI)                                     CGL029
     D  QQMoriN2     E                     EXTFLD(QQMORI)                                     CGL029
     D  QQDopiN2     E                     EXTFLD(QQDOPI)                                     CGL029
     D  QQMopiN2     E                     EXTFLD(QQMOPI)                                     CGL029
     D  QQRonsN2     E                     EXTFLD(QQRONS)                                     CGL029
     D  QQPonsN2     E                     EXTFLD(QQPONS)                                     CGL029
     D  QQInsaN2     E                     EXTFLD(QQINSA)                                     CGL029
 
      ** Valid Deal for Update
     D ValidDeal     E DS                  EXTNAME(MMVLDNIPD)
 
      ** Current Deal in File Format 1
     D CrDlFilFmt1   E DS                  EXTNAME(MMDELDPP)
     D                                     PREFIX(D1)
 
      ** Current Deal in File Format 2
     D CrDlFilFmt2   E DS                  EXTNAME(MMDELDPP)
     D                                     PREFIX(D2)
 
      ** Current Deal in Screen Format
     D CrDlScnFmt    E DS                  EXTNAME(ABFUNDPD)
     D                                     PREFIX(Cr)
 
      ** Internal Funding Deals Error Indicators File
     D OkFlags       E DS                  EXTNAME(ABEFUNDPD)
 
      ** Internal Funding Deals Extra Data Layout FiLe
     D ExtData       E DS                  EXTNAME(ABFUEXPD)
 
      ** Data Area giving Installation Control Details
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
 
     D ZMUSER        E DS                  EXTNAME(ZMUSER)
 
     D WkEi            S              1    DIM(60)
 
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
 
     D PRTCD           S              7A
     D POPTN           S              7A
     D PAmendOk        S              1A
     D PResetErrs      S              1A
     D PStatus         S              7A
     D PLnkFlag        S              1A
     D PValFlg         S              1A
 
      ** Index for arrays of error message ids
     D Idx             S              3P 0
 
      ** Index for arrays of warning message ids
     D WIdx            S              3P 0
 
      ** Function Keys
     D PINKC           S              1A
     D PINKG           S              1A
     D PINKH           S              1A
     D PINKJ           S              1A
     D PINKL           S              1A
     D PINKN           S              1A
     D PINKP           S              1A
     D PINKT           S              1A
 
      ** Enable Function Keys
     D PEINKG          S              1A
     D PEINKH          S              1A
     D PEINKJ          S              1A
     D PEINKN          S              1A
     D PEINKP          S              1A
     D PEINKT          S              1A
 
     D PEKyFd          S              1A
     D PEDtFd          S              1A
 
      ** Work Variables
     D E               S              3  0
     D F               S              3  0
     D PScrn           S              1A
     D WkRdNB          S              1A
     D PKey            S              1A
     D PReDsp          S              1A
     D PSARD           S              6A
 
      ** Deal Status
     D DDSTS           S              7A
 
      ** Build subifle indicator
     D PBdSfl          S              1A
 
      ** Read subfile record
     D PRdSfl          S              1A
 
      ** Error in update of previous deal
     D PErrUp          S              1A
 
      ** Error message
     D PErrMs          S              7A
 
      ** Option Selected
     D POpSel          S              1A
 
      ** Action Selected
     D PAcSel          S              1A
 
      ** FO Transaction ID selected
     D PFOTranSel      S             20A
 
      ** FO Associated transaction ID selected
     D PFOAsocSel      S             20A
 
      ** Timestamp
     D PTmeStpSel      S             26Z
 
      ** Successfully inserted deal
     D PSidN           S              6A
 
      ** Mode of Operation
     D PModeOfOp       S              6A
 
      ** Response mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D PRespMode       S              1A   INZ('S')
 
      ** Front Office Transaction ID
     D FOTRID          S             20A
 
      ** Front Office Associated Transaction ID
     D FOASID          S             20A
 
      ** Substitution Characted
     D SubsChar        S              1A
 
      ** Incoming Data
     D IncDATA         S           2000A
 
      ** Current Data
     D CurDATA         S           2000A
 
     D Pgm             S             10A
     D PFkey           S              2A
     D PAction         S              1A
     D/COPY WNCPYSRC,ABFUNDRD01
     D DATA            S            256A
     D/COPY WNCPYSRC,ABFUNDRD02
     D PRtrn           S              7A
     D SPAREW          S            256A
 
     D WSetFld         S              1A
     D IDDDLNO         S              6A
     D WkDDDLNO        S              6A
     D WkDDDADN        S              6A
     D PMsg1           S              7A
 
      ** Profit Centre Description
     D PPCDesc1        S             30A
     D PPCDesc2        S             30A
     D DDPCD1          S             30A
     D DDPCD2          S             30A
 
      ** Front Office Transaction ID                                                          261140
     D FRNT            S             20A                                                      261140
     D AFRT            S             20A                                                      261140
                                                                                              261140
      ** Fields for getting the starting field number from file (parameters
      ** to ZAGETFLDNO, plus the offset to the requested field).
     D Format          S             10A   INZ('ABFUNDPD')
     D Field           S             10A   INZ('#1ACTN')
     D FieldNo         S              5P 0
     D FldOffset       S              5P 0
 
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
 
      ** Parameters for ZDATE2
     D PDaynoIn        S              5P 0
     D PRetCode        S              1  0
 
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
 
     D CSC011          S              1A                                                      CSC011
     D CSC022          S              1A   INZ('N')                                           CSC022
     D CNT             S              3  0                                                    CSC022
     D COMITSKIP       S              1A                                                      CSC022
     D KMsgType        S              8A                                                      CSC011
     D KFrntOffID      S             20A                                                      CSC011
     D KTimeStamp      S                   LIKE(ABTMESTMP)                                    CSC011
     D WRunDay         S                   LIKE(BJRDNB)                                       CSC011
                                                                                              CSC011
     D CAS004          S              1A                                                      CAS004
                                                                                              CAS004
     D CDL019          S              1A                                                      CDL019
                                                                                              CDL019
     D CDL020          S              1A                                                      CDL020
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
                                                                                              CDL020
      /COPY WNCPYSRC,ABFUNDR002
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
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
 
      /COPY WNCPYSRC,ABFUNDR003
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      ** Do screen: Browse Invalid Deals
 
     C                   IF        PScrn = 'B'
     C                   EXSR      SRScrnB
     C                   END
 
      /COPY WNCPYSRC,ABFUNDR004
 
      ** Read Next Browse Subfile record
 
     C                   IF        PScrn = 'R'
     C                   EXSR      SRRdnBrw
     C                   END
 
      /COPY WNCPYSRC,ABFUNDR005
 
      ** Do while screen: Main Details
 
     C                   DOW       PScrn = 'M'
     C                   EXSR      SRScrnM
     C                   END
 
      /COPY WNCPYSRC,ABFUNDR006
 
      ** Screen: SRWindow
 
     C                   IF        PScrn = 'W'
     C                   EXSR      SRWindow
     C                   END
 
      /COPY WNCPYSRC,ABFUNDR007
 
      ** Screen: Confirmation of input
 
     C                   IF        PScrn = 'C'
     C                   EXSR      SRScrnC
     C                   END
 
      /COPY WNCPYSRC,ABFUNDR008
 
      ** Do file updates
 
     C                   IF        PScrn = 'U'
     C                   EXSR      SRUpdat
     C                   END
 
      /COPY WNCPYSRC,ABFUNDR009
 
      ** Terminate program
 
     C                   IF        PScrn = 'T'
     C                   EVAL      *INLR = *On
     C                   END
 
      ** Hook to enable non-core subroutines to be included
 
      /COPY WNCPYSRC,ABFUNDR010
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRScrnB - Browse invalid deals                                *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls:     SREndP                                             *
      *                                                               *
      *****************************************************************
     C     SRScrnB       BEGSR
 
      ** Reset Read Next Browse Subfile Record
 
     C                   EVAL      WkRdNb = *Blanks
 
      ** Build Browse subfile
 
     C                   CALLB     'ABFUNDRPB'
 
      ** Input Parameters
      ** Return Code
      ** Build sub-file
      ** Read subfile record
      ** Error in update of previous deal
 
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM      'Y'           PBdSfl
     C                   PARM      *BLANK        PRdSfl
     C                   PARM                    PErrUp
 
      ** SDBANKPD fields
      ** Single Branch Code
      ** Midas Run Date
 
     C                   PARM                    BJSBRC
     C                   PARM                    BJMRDT
 
      ** Output Parameters
      ** Error Message
      ** Option Selected
      ** Action selected
      ** FO Transaction ID selected
      ** FO Associated transaction ID selected
      ** Timestamp of Transaction selected
 
     C                   PARM      *BLANK        PErrMs
     C                   PARM                    POpSel
     C                   PARM                    PAcSel
     C                   PARM                    PFOTranSel
     C                   PARM                    PFOAsocSel
     C                   PARM                    PTmeStpSel
 
      ** Command keys
 
     C                   PARM      '0'           PINKC
 
      ** Successfully Inserted Deal Number
 
     C                   PARM                    PSidN
 
      ** CSC011 Enhancement is installed                                                      CSC011
                                                                                              CSC011
     C                   PARM                    CSC011                                       CSC011
                                                                                              CSC022
      ** CSC022 Enhancement is installed                                                      CSC022
                                                                                              CSC022
     C                   PARM                    CSC022                                       CSC022
                                                                                              CSC011
      ** If error set on external switches
 
     C                   IF        PErrMs <> *Blanks
     C                   EVAL      *INU6 = *On
     C                   END
 
      ** If CK/3 or CK/12 taken in browse, or error message
      ** End program
 
     C                   IF        PINKC = *On or PErrMs <> *Blanks
     C                   EXSR      SREndP
     C                   GOTO      ESRScrnB
     C                   ELSE
 
      ** Read next browse subfile record
 
     C                   EVAL      WkRdNb = 'Y'
     C                   EVAL      PScrn =  'R'
     C                   END
 
     C     ESRScrnB      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRScrnM- Process Screen: Main Details                         *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls:     SREndP                                             *
      *            SRCanM                                             *
      *            SRValM                                             *
      *                                                               *
      *****************************************************************
     C     SRScrnM       BEGSR
 
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
     C                   END
 
      ** Enable/disable detail fields on main details screen
      ** if changes to the data are allowed
      ** (key fields = action code & deal number; detail fields = rest)
      ** (Action code can only be 'I', 'A' or 'D')
 
     C                   IF        DDACTN = 'I' and POpSel = 'U' or
     C                             DDACTN = 'A' and POpSel = 'U'
     C                   EVAL      PEDtFd = 'Y'
     C                   ELSE
     C                   EVAL      PEDtFd = 'N'
     C                   ENDIF
 
      ** Enable/Disable Key fields and Action code
 
     C                   IF        OkACTN = 'N' or OkDLNO = 'N'
     C                   EVAL      PEKyFd = 'N'
     C                   ELSE
     C                   EVAL      PEKyFd = 'Y'
     C                   ENDIF
 
      ** KJ = Command Key 10 = Confirm Delete
 
     C                   IF        DDACTN = 'D'
     C                   EVAL      PEINKJ = 'Y'
     C                   ELSE
     C                   EVAL      PEINKJ = 'N'
     C                   ENDIF
 
      ** Write/Read Display screen
 
     C                   CALLB     'ABFUNDDSP'
 
      ** Input Parameters
      ** Return Code
      ** Deal (in screen format)
      ** Fields in error
 
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    NwDlScnFmt
     C                   PARM                    DDSTS
     C                   PARM                    DDPCD1
     C                   PARM                    DDPCD2
     C                   PARM                    OkFlags
 
      ** Errors
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Warnings
 
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
 
      ** Enable Key & Detail Fields
 
     C                   PARM                    PEKyFd
     C                   PARM                    PEDtFd
 
      ** Enable function keys
 
     C                   PARM      'N'           PEINKG
     C                   PARM      'N'           PEINKH
     C                   PARM                    PEINKJ
     C                   PARM      'N'           PEINKP
 
      ** Successful insert deal
 
     C                   PARM                    PSidN
 
      ** Linked maintenance flag
 
     C                   PARM                    PLnkFlag
 
      ** Write screen with no read indicator
 
     C                   PARM      'N'           WriteOnly
 
      ** Standing Data
      ** =============
      ** SDBANKPD
 
     C                   PARM                    BJMRDT
 
      ** SDGELRPD
 
     C                   PARM                    BKOBRU
     C                   PARM                    BKPRCU
 
      ** RUNDAT
 
     C                   PARM                    AGMBIN
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
 
      ** Reset Errors
 
     C                   EXSR      SRResetErr
 
     C                   SELECT
 
      ** CK/3 - End Program
 
     C     PINKC         WHENEQ    *On
     C                   EXSR      SREndP
 
      ** CK/12 - Cancel on Main details screen
 
     C     PINKL         WHENEQ    *On
     C                   EXSR      SRCanM
 
      ** Validate input to main details screen only if option
      ** selected is amend, action code of transaction is not enquire
      ** and key fields are not in error (key fields = action code,
      ** & deal number).  Else, read records from the subfile or
      ** return to browse screen.
 
     C                   OTHER
 
     C     POpSel        IFEQ      'U'
     C     DDACTN        ANDNE     'E'
     C     DDACTN        ANDNE     ' '
 
     C                   EXSR      SRValM
 
     C                   ELSE
 
     C                   EXSR      SRCanM
 
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRScrnC - Process Screen: Confirmation of input               *
      *          evoked for inserts & amends                          *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls:     SREndP                                             *
      *            SRRtvDel                                           *
      *            SRPutDl                                            *
      *                                                               *
      *****************************************************************
     C     SRScrnC       BEGSR
 
      ** Send Confirmation Message
 
     C                   EVAL      WMsgIdArr(1) = 'MMM1030'
     C                   EVAL      WFldNamArr(1) = '*ANY'
 
      ** Write/Read Display screen
 
     C                   CALLB     'ABFUNDDSP'
 
      ** Input Parameters
      ** Return Code
      ** Deal (in screen format)
      ** Fields in error
 
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    NwDlScnFmt
     C                   PARM                    DDSTS
     C                   PARM                    DDPCD1
     C                   PARM                    DDPCD2
     C                   PARM                    OkFlags
 
      ** Errors
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Warnings
 
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
 
      ** Enable Key & Detail Fields
 
     C                   PARM      'N'           PEKyFd
     C                   PARM      'N'           PEDtFd
 
      ** Enable function keys
 
     C                   PARM      'N'           PEINKG
     C                   PARM      'N'           PEINKH
     C                   PARM      'N'           PEINKJ
     C                   PARM      'N'           PEINKP
 
      ** Successful insert deal
 
     C                   PARM                    PSidN
 
      ** Linked maintenance flag
 
     C                   PARM                    PLnkFlag
 
      ** Write screen with no read indicator
 
     C                   PARM      'N'           WriteOnly
 
      ** Standing Data
      ** SDBANKPD
 
     C                   PARM                    BJMRDT
 
      ** SDGELRPD
 
     C                   PARM                    BKOBRU
     C                   PARM                    BKPRCU
 
      ** RUNDAT
 
     C                   PARM                    AGMBIN
                                                                                              CAS004
     C                   PARM                    CAS004                                       CAS004
                                                                                              CDL019
     C                   PARM                    CDL019                                       CDL019
                                                                                              CDL020
     C                   PARM                    CDL020                                       CDL020
 
      ** Output Parameters
      ** Function Keys
 
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKG
     C                   PARM      '0'           PINKH
     C                   PARM      '0'           PINKJ
     C                   PARM      '0'           PINKL
     C                   PARM      '0'           PINKP
 
      ** Reset Errors
 
     C                   EXSR      SRResetErr
 
      ** F3 - End Program
 
     C     PINKC         CASEQ     *On           SREndP
 
      ** F12 - Cancel on Confirmation Screen
 
     C     PINKL         CASEQ     *On           SRCanC
 
      ** Exit Confirmation Screen
 
     C                   CAS                     SRExit
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRUpdat- Updates                                              *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls:     SREndP                                             *
      *            SRRtvDel                                           *
      *            SRPutDl                                            *
      *                                                               *
      *****************************************************************
     C     SRUpdat       BEGSR
 
     C                   EVAL      WSetFld = '1'
     C                   EXSR      SRUpdFlds
 
      ** Update Deal
      ** Money market Database updates
 
     C                   CALLB     'MMLDNIUPM'
     C                   PARM      *BLANK        PRTCD
     C                   PARM                    NwDlFilFmt1
 
      ** Deals Updates
 
     C                   IF        PRTCD = *Blanks
     C                   CALLB     'MMLDNIUPD'
     C                   PARM                    PRTCD
     C                   PARM                    NwDlFilFmt1
     C                   END
 
      ** Update Associated Deal
 
     C                   IF        PRTCD = *Blanks
     C                   CALLB     'MMLDNIUPM'
     C                   PARM      *BLANK        PRTCD
     C                   PARM                    NwDlFilFmt2
 
      ** Deals Updates
 
     C                   IF        PRTCD = *Blanks
     C                   CALLB     'MMLDNIUPD'
     C                   PARM                    PRTCD
     C                   PARM                    NwDlFilFmt2
     C                   ENDIF
 
     C                   ENDIF
 
      ** If there were any errors in the update functions, rollback any
      ** updates and end this program.
      ** Otherwise delete the invalid MM Deal actioned & commit the updates
 
     C                   IF        PRTCD <> *Blanks
     C     CSC022        IFEQ      'N'                                                        CSC022
     C                   ROLBK
     C                   ELSE                                                                 CSC022
     C     COMITSKIP     IFNE      'Y'                                                        CSC022
     C                   ROLBK                                                                CSC022
     C                   ELSE                                                                 CSC022
     C                   SETON                                        U7U8                    CSC022
     C                   END                                                                  CSC022
     C                   ENDIF                                                                CSC022
     C                   IF        PRTCD <> '*RECUPD'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ELSE
     C     ZATRNKD0      CHAIN     ABIFUNDD0                          99
     C                   IF        *IN99 = *Off
     C                   DELETE    ABIFUNDD0
                                                                                              CSC011
      ** Delete invalid record from the log file.                                             CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y' and S1SUPP = LIBR                             CSC011
                                                                                              CSC011
     C                   EVAL      KMsgType = 'ABFUND'                                        CSC011
     C                   EVAL      KFrntOffID = PFOTranSel                                    CSC011
     C                   EVAL      KTimeStamp = PTmeStpSel                                    CSC011
                                                                                              CSC011
     C     KAPILOGL0     CHAIN     APILOGL0                           99                      CSC011
     C                   IF        *IN99 = *OFF                                               CSC011
     C                   DELETE    APILOGL0                                                   CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF
 
     C/COPY WNCPYSRC,ABFUNDRC07
     C     CSC022        IFEQ      'N'                                                        CSC022
     C                   COMMIT
     C                   ELSE                                                                 CSC022
     C     COMITSKIP     IFNE      'Y'                                                        CSC022
     C                   COMMIT                                                               CSC022
     C                   END                                                                  CSC022
     C                   ENDIF                                                                CSC022
     C/COPY WNCPYSRC,ABFUNDRC02
     C                   END
 
      ** If error occurred in updating last transaction set on flag to
      ** display message on 'browse' screen.
 
     C                   IF        PRTCD = '*RECUPD'
     C                   EVAL      PErrUp = 'Y'
     C                   ELSE
     C                   EVAL      PErrUp = 'N'
     C                   END
 
      ** If records are still to be read from the subfile, read them
 
     C                   IF        WkRdNb = 'Y'
     C                   EVAL      PScrn = 'R'
     C                   ELSE
 
      ** else, return to the browse screen
 
     C                   EVAL      PScrn = 'B'
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * RDNBRW - Read next browse subfile record                      *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls:     SREndP                                             *
      *            SRRtvDel                                           *
      *            SRPutDl                                            *
      *                                                               *
      *****************************************************************
     C     SRRdnBrw      BEGSR
 
      ** Read next subfile record
 
     C                   CALLB     'ABFUNDRPB'
 
      ** Input Paramters
      ** Return Code
      ** Build sub-file
      ** Read subfile record
      ** Error in update of previous deal
 
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM      *BLANK        PBdSfl
     C                   PARM      'Y'           PRdSfl
     C                   PARM                    PErrUp
 
      ** SDBANKPD fields
      ** Single Branch Code
      ** Midas Run Date
 
     C                   PARM                    BJSBRC
     C                   PARM                    BJMRDT
 
      ** Output parameters
      ** Error message
      ** Option selected
      ** Action selected
      ** FO Transaction ID selected
      ** FO Associated transaction ID selected
      ** Timestamp of Transaction selected
 
     C                   PARM      *BLANK        PErrMs
     C                   PARM      *BLANK        POpSel
     C                   PARM      *BLANK        PAcSel
     C                   PARM      *BLANK        PFOTranSel
     C                   PARM      *BLANK        PFOAsocSel
     C                   PARM                    PTmeStpSel
 
      ** Command keys
 
     C                   PARM      '0'           PINKC
     C**********         PARM      '0'           PINKL                                        199787
 
      ** Successfully Inserted Deal Number
 
     C                   PARM                    PSidN
 
      ** CSC011 Enhancement is installed                                                      CSC011
                                                                                              CSC011
     C                   PARM                    CSC011                                       CSC011
                                                                                              CSC011
      ** CSC022 Enhancement is installed                                                      CSC022
                                                                                              CSC022
     C                   PARM                    CSC022                                       CSC022
                                                                                              CSC022
      ** If CK/3 taken within invalid transaction deletion function,
      ** End program
 
     C                   IF        PINKC = *On
     C                   EXSR      SREndP
     C                   GOTO      ESRRdnBrw
     C                   END
 
      ** If invalid deal read from subfile
 
     C                   IF        POpSel <> *Blanks
 
      ** Blank the main details screen
 
     C                   EVAL      NwDlScnFmt = *Blanks
 
      ** Reset Errors
 
     C                   EXSR      SRResetErr
 
      ** Retrieve deal details
 
     C                   EVAL      DDACTN = PAcSel
     C                   EVAL      FOTRID = PFOTranSel
     C                   EVAL      FOASID = PFOAsocSel
 
      ** Make sure Invalid transaction's  details are passed to 'Retreive'
      ** module for SPF checking .
 
     C     ZATRNKX0      CHAIN     ABIFUNDX0                          99
 
      ** Set retrieve mode to '*FRONT' (Access using Front Office ID)
      **  if insert
      **  if not insert and Midas transaction ID is not present
      ** Otherwise
      **  Set retrieve mode to blank  (Access using Midas transaction ID).
 
     C                   IF        DDACTN = 'I'
     C                   EVAL      PModeOfOp = '*FRONT'
     C                   ELSE
 
     C                   IF        DDDLNO = *Blanks
     C                   EVAL      PModeOfOp = '*FRONT'
     C                   ELSE
     C                   EVAL      PModeOfOp = *Blanks
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EXSR      SRRtvDel
 
      ** If deal details were retrieved
      ** Put the deal on the main details screen
 
     C                   IF        D1HKRCID <> *Blanks  and DDACTN <> 'I'
     C                   EXSR      SRPutDl
     C                   END
 
      ** Now overwite the fields on the main details screen with those
      ** on the invalid deals file (except for the Midas deal number
      ** and Midas associated deal number retrieved above using the
      ** front office transaction and associated transaction IDs).
      ** Access invalid deal with timestamp and front office transaction ID.
 
     C                   EVAL      WkDDDLNO = DDDLNO
     C                   EVAL      WkDDDADN = DDDADN
     C     ZATRNKX0      CHAIN     ABIFUNDX0                          99
     C                   IF        D1HKRCID <> *Blanks  and DDACTN <> 'I'
     C                   EVAL      DDDLNO = WkDDDLNO
     C                   EVAL      DDDADN = WkDDDADN
     C                   END
 
      ** If deal details were retrieved and this is an amendment
 
     C                   IF        D1HKRCID <> *Blanks and DDACTN = 'A'
 
      ** Data Substitution - Transaction Details
 
     C                   IF        GHSUBS <> *Blanks
 
     C     GHSUBS        SCAN      NwDlScnFmt                             99
     C                   IF        *IN99 = *ON
     C                   EXSR      SRSubsDta
     C                   END
 
     C                   END
 
     C                   END
 
      ** If action code, or deal number were NOT OK
      ** blank out action code so that the input cannot proceed
 
     C                   IF        OkACTN = 'N' or OkDLNO = 'N'
     C                   EVAL      DDACTN = *Blanks
     C                   END
 
      ** Send the deals error messages to the main details screen
 
     C                   EXSR      SRSndM
 
      ** Go to main details screen
 
     C                   EVAL      PScrn = 'M'
 
      ** Else if no invalid deal read from subfile
 
     C                   ELSE
 
      ** Go to browse screen
 
     C                   EVAL      PScrn = 'B'
     C                   END
 
     C     ESRRdnBrw     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRRtvDel  Retrieve Deal                                       *
      *                                                               *
      * Called by: SRRdnBrw                                           *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRRtvDel      BEGSR
 
      ** Retrieve Deal
 
     C                   CALLB     'ABFUNDRTV'
 
      ** Inputs
      ** ======
      ** Return code
 
     C                   PARM      *BLANK        RetCodeOut
 
      ** Mode = '*FRONT' (Front office transaction interface)
      ** Mode = '      ' (Not front office transaction interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen Input function)
 
     C                   PARM                    PModeOfOp
 
      ** Response mode
      ** Action Code
      ** Front Office Transaction ID
      ** Front Office Associated Transaction Id
      ** (Midas) Deal Number
      ** (Midas) Associated Deal Number
      ** (Midas) Booking Branch
      ** (Midas) Booking Branch for Associated Deal
      ** Linked Maintenance Flag
 
     C                   PARM                    PRespMode
     C                   PARM                    DDACTN
     C                   PARM                    FOTRID
     C                   PARM                    FOASID
     C                   PARM                    DDDLNO
     C                   PARM                    DDDADN
     C                   PARM                    DDBRC1
     C                   PARM                    DDBRC2
     C                   PARM                    PLnkFlag
 
      ** Standing Data
      ** SDBANKPD
 
     C                   PARM                    BJSBRC
 
      ** SDGELRPD
 
     C                   PARM                    BKOBUV
 
      ** ZMUSER
 
     C                   PARM                    DBRN
 
      ** Outputs
      ** =======
      ** Current deal in file format
      ** Current associated deal in file format
      ** OK - Action code
      ** OK - Deal Number
      ** OK - Booking branch
      ** OK - Booking branch for associated deal number
 
     C                   PARM                    CrDlFilFmt1
     C                   PARM                    CrDlFilFmt2
     C                   PARM      *BLANK        OKACTN
     C                   PARM      *BLANK        OKDLNO
     C                   PARM      *BLANK        OKBRC1
     C                   PARM                    OKBRC2
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM      *ZERO         Idx
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRCanC - CANCEL ON CONFIRMATION SCREEN
      *                                                               *
      * Called by: SRScrnM                                            *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRCanC        BEGSR
 
      ** Return to main details screen
 
     C                   EVAL      PScrn = 'M'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRExit - EXIT FROM CONFIRMATION SCREEN                        *
      *                                                               *
      * Called by: SRScrnM                                            *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRExit        BEGSR
 
      ** If no errors in validation
 
     C                   IF        Idx = *Zeros
 
      ** Continue with updates
 
     C                   EVAL      PScrn = 'U'
 
      ** Else, Return to main details screen
 
     C                   ELSE
     C                   EVAL      PScrn = 'M'
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRCanM - CANCEL ON MAIN DETAILS SCREEN                        *
      *                                                               *
      * Called by: SRScrnM                                            *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRCanM        BEGSR
 
      ** If records are still to be read from the subfile, read them
 
     C                   IF        WkRdNb = 'Y'
     C                   EVAL      PScrn = 'R'
     C                   ELSE
 
      ** Else, return to the browse screen
 
     C                   EVAL      PScrn = 'B'
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPutDl- Put a deal on the main details screen                *
      *                                                               *
      * Called by: SRRdnBrw                                           *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRPutDl       BEGSR
 
      ** Call program to fill screen fields with data from MMDELDPP
 
     C                   CALLB     'ABFUNDCVT'
 
      ** Inputs
      ** ======
      ** Return Code
      ** Action Code
      ** Deal in file format
 
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    ActionCode
     C                   PARM                    CrDlFilFmt1
     C                   PARM                    CrDlFilFmt2
 
      ** Standing Data
      ** SDBANKPD
 
     C                   PARM                    BJDFIN
 
      ** SDDEALPD
 
     C                   PARM                    BNDCSP
                                                                                              CAS004
     C                   PARM                    CAS004                                       CAS004
                                                                                              CDL019
     C                   PARM                    CDL019                                       CDL019
                                                                                              CDL020
     C                   PARM                    CDL020                                       CDL020
 
      ** Outputs
      ** =======
      ** Deal in screen format
      ** Deal Status
 
     C                   PARM                    NwDlScnFmt
     C                   PARM                    PStatus
 
      ** Profit Centre Description 1
      ** Profit Centre Description 2
 
     C                   PARM                    PPCDesc1
     C                   PARM                    PPCDesc2
 
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
      *                                                               *
      * SRSndM - Send a message to main details screen                *
      *                                                               *
      * Called by: SRRdnBrw                                           *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRSndM        BEGSR
 
     C                   Z-ADD     Idx           E
 
      ** If there are fundamental errors in this transaction
      ** Identify this fact.
 
     C                   IF        OkACTN = 'N' or OkDLNO = 'N'
     C                   ADD       1             E
     C                   EVAL      FldNameArr(E) = '*ANY'
     C                   EVAL      MsgIdArr(E) = 'APM0110'
     C                   ENDIF
 
      ** Initialize error indicators
 
     C                   MOVEA     OkFlags       WkEI
 
      ** Read error messages for deal
 
     C     ZATRNKD0      SETLL     ZATRNERRD0
     C     ZATRNKD0      READE     ZATRNERRD0                             99
 
      ** Add error message to array passed to detail screen
      ** and set OK flag for field to 'N'
 
     C                   DOW       *IN99 = *Off and
     C                             ABFIELDID > FldOffSet
     C     ABMSGID       LOOKUP    MsgIdArr(1)                            98
     C                   IF        *IN98 = *Off
     C                   ADD       1             E
     C                   EVAL      FldNameArr(E) = ABFIELDNAM
     C                   EVAL      MsgIdArr(E) = ABMSGID
     C                   ENDIF
 
     C                   Z-ADD     ABFIELDID     F
     C                   SUB       FldOffset     F
     C                   IF        F < 1 or F > 60
     C                   Z-ADD     1             F
     C                   ENDIF
 
     C                   EVAL      WkEI(F) = 'N'
     C     ZATRNKD0      READE     ZATRNERRD0                             99
     C                   END
 
     C                   MOVEA     WkEI          OkFlags
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValM - Validate input to main details screen                *
      *                                                               *
      * Called by: SRScrnM                                            *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRValM        BEGSR
 
      ** If Delete
 
     C                   IF        DDACTN = 'D'
 
      ** Update Deal in File Format
 
     C                   EVAL      ValidDeal = CrDlFilFmt1
 
      ** If F10 taken, go onto update
 
     C                   IF        PINKJ = *On
     C                   EVAL      PScrn = 'U'
     C                   END
     C                   GOTO      ESRValM
     C                   END
 
      ** If Insert or Amend
 
     C                   IF        DDACTN = 'I' or DDACTN = 'A'
 
      ** Prior to validation, initialize error indicators as 'OK'
      ** and clear Deal in File Format
 
     C                   Z-ADD     *ZERO         Idx
     C                   Z-ADD     *ZERO         WIdx
     C                   MOVE      *ALL'Y'       OkFlags
     C                   CLEAR                   NwDlFilFmt1
     C                   CLEAR                   NwDlFilFmt2
 
      ** Save Current Format from Retrieve
 
     C                   EVAL      NwDlFilFmt1 = CrDlFilFmt1
     C                   EVAL      NwDlFilFmt2 = CrDlFilFmt2
 
      ** If Amend
 
     C                   IF        DDACTN = 'A'
 
      ** Validate whether non-amenable fields have been changed
 
     C                   CALLB     'ABFUNDAMD'
 
      ** Inputs
      ** ======
      ** Return Code
      ** New Deal in Screen Format
      ** Current Deal in Screen Format
      ** Reset of Fields in Error Required (Y/N)
      ** Originating Branch Used
      ** Decimal Separator
 
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    NwDlScnFmt
     C                   PARM                    CrDlScnFmt
     C                   PARM      'Y'           PResetErrs
     C                   PARM                    BKOBRU
     C                   PARM                    BNDCSP
     C                   PARM                    CDL019                                       CDL019
     C                   PARM                    CDL020                                       CDL020
 
      ** Outputs
      ** =======
      ** Field OK flags (DS) from/to caller
 
     C                   PARM                    OkFlags
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
      ** Amendments OK
 
     C                   PARM                    Idx
     C                   PARM                    PAmendOk
 
      ** Amended by validation module flag
 
     C                   PARM                    PValFlg
 
     C                   END
 
      ** Validate deal details
 
     C                   CALLB     'ABFUNDVAL'
 
      ** Input
      ** =====
      ** Return Code
 
     C                   PARM                    ReturnCode
 
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen Input function)
 
     C                   PARM                    PModeOfOp
 
      ** Response mode (1A), from source system common header
 
     C                   PARM                    PRespMode
 
      ** Transaction information (DS) from source system
 
     C                   PARM                    NwDlScnFmt
 
      ** Current Screen Format
 
     C                   PARM                    CrDlScnFmt
 
      ** Current File Format 1
      ** Current File Format 2
 
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
 
      ** RUNDAT: Multibranching Indicator
 
     C                   PARM                    AGMBIN
 
      ** ZMUSER
      ** ======
      ** Default Branch
      ** Department Code
 
     C                   PARM                    DBRN
     C                   PARM                    DPPT
                                                                                              CAS004
     C                   PARM                    CAS004                                       CAS004
                                                                                              CDL019
     C                   PARM                    CDL019                                       CDL019
                                                                                              CDL020
     C                   PARM                    CDL020                                       CDL020
 
      ** Output
      ** ======
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM                    Idx
 
      ** Warning fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM                    WIdx
 
      ** AB Internal Funding screen error indicators
 
     C                   PARM                    OkFlags
 
      ** AB Internal Funding for file update - file format
 
     C                   PARM                    NwDlFilFmt1
 
      ** Associated Deal Number fields
 
     C                   PARM                    NwDlFilFmt2
 
      ** Redisplay flag
 
     C                   PARM                    PReDsp
 
      ** Profit Centre Description 1
      ** Profit Centre Description 2
     C                   PARM                    PPCDesc1
     C                   PARM                    PPCDesc2
 
      ** Amended by validation module flag
 
     C                   PARM                    PValFlg
 
      ** If errors returned
 
     C                   IF        Idx <> 0
     C                   GOTO      ESRValM
     C                   END
 
      ** If windows processing on, call window routine
      ** otherwise, continue to settlements screen
 
     C                   IF        BGWDPR = 'Y'
     C                   EVAL      PScrn = 'W'
     C                   ELSE
     C                   EVAL      PScrn = 'C'
     C                   END
 
     C                   END
 
     C     ESRValM       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRWindow - Call Window Manager                                *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls:     SREndP                                             *
      *                                                               *
      *****************************************************************
     C     SRWindow      BEGSR
 
      ** Reset Errors
 
     C                   EXSR      SRResetErr
 
      ** Write out screen to remove error messages
 
     C                   CALLB     'ABFUNDDSP'
 
      ** Input Parameters
      ** Return Code
      ** Deal (in screen format)
      ** Fields in error
 
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    NwDlScnFmt
     C                   PARM                    DDSTS
     C                   PARM                    DDPCD1
     C                   PARM                    DDPCD2
     C                   PARM                    OkFlags
 
      ** Errors
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Warnings
 
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
 
      ** Enable Key & Detail Fields
 
     C                   PARM      'Y'           PEKyFd
     C                   PARM                    PEDtFd
 
      ** Enable function keys
 
     C                   PARM      'N'           PEINKG
     C                   PARM      'N'           PEINKH
     C                   PARM                    PEINKJ
     C                   PARM      'N'           PEINKP
 
      ** Successful insert deal
 
     C                   PARM                    PSidN
 
      ** Linked maintenance flag
 
     C                   PARM                    PLnkFlag
 
      ** Write screen with no read indicator
 
     C                   PARM      'Y'           WriteOnly
 
      ** Standing Data
      ** SDBANKPD
 
     C                   PARM                    BJMRDT
 
      ** SDGELRPD
 
     C                   PARM                    BKOBRU
     C                   PARM                    BKPRCU
 
      ** RUNDAT
 
     C                   PARM                    AGMBIN
                                                                                              CAS004
     C                   PARM                    CAS004                                       CAS004
                                                                                              CDL019
     C                   PARM                    CDL019                                       CDL019
                                                                                              CDL020
     C                   PARM                    CDL020                                       CDL020
 
      ** Output Parameters
      ** Function Keys
 
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKG
     C                   PARM      '0'           PINKH
     C                   PARM      '0'           PINKJ
     C                   PARM      '0'           PINKL
     C                   PARM      '0'           PINKP
 
     C/COPY WNCPYSRC,ABFUNDRC01
     C                   CALL      'WN0010'
     C                   PARM      'ABFUNDRPR'   Pgm
     C                   PARM                    PFkey
     C                   PARM      DDACTN        PAction
     C                   PARM                    DATA
     C                   PARM      *BLANKS       PRtrn
     C                   PARM                    SPAREW
 
      * Process returned command keys
 
     C                   SELECT
     C                   WHEN      PRtrn = 'Y2U9999'
     C                   EXSR      SREndP
 
     C                   WHEN      PRtrn = 'USR0790'
     C                   EVAL      PScrn = 'M'
 
     C                   OTHER
 
      ** Action is Amend or Insert - proceed to confirmation screen.
 
     C                   IF        DDACTN = 'I' AND POpSel = 'U' OR
     C                             DDACTN = 'A' AND POpSel = 'U'
     C                   EVAL      PScrn = 'C'
     C                   ELSE
 
      ** Read next browse subfile record if pending option still exist.
      ** Otherwise, display browse screen
 
     C                   IF        WkRdNb = 'Y'
     C                   EVAL      PScrn = 'R'
     C                   ELSE
     C                   EVAL      PScrn = 'B'
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSubsDta  - Transaction Details Data Substitution            *
      *                                                               *
      * Called by: SRRdnBrw                                           *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRSubsDta     BEGSR
 
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'
 
      ** Return Code
      ** Substitution character
      ** Incoming Data
      ** Current Data
 
     C                   PARM                    ReturnCode
     C                   PARM      GHSUBS        SubsChar
     C                   PARM      NwDlScnFmt    IncDATA
     C                   PARM      CrDlScnfmt    CurDATA
 
     C                   MOVEL     IncDATA       NwDlScnFmt
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SREndP - End Program                                          *
      *                                                               *
      * Called by: SRScrnB- Browse invalid deals                      *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SREndP        BEGSR
 
     C                   EVAL      PScrn = 'T'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRGetNxtDl                                                    *
      *                                                               *
      * Called by: SRUpdat                                            *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRGetNxtDl    BEGSR
 
     C                   CALLB     'CAGETNXTDL'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM      *BLANKS       PMsg1
     C                   PARM                    DDDLNO
     C                   PARM      *ZERO         IKDN38
 
      ** Database error
 
     C                   IF        PMsg1 <> *Blanks
     C                   EVAL      DBFILE = 'CAGTNXDL'
     C                   EVAL      DBKEY = DDDLNO
     C                   EVAL      DBASE = 005
     C                   EXSR      *PSSR
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUpdFlds - Update other fields                               *
      *                                                               *
      * Called by: SRUpdat                                            *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRUpdFlds     BEGSR
 
      ** If deal number not defined (on insert),
      ** get next available deal number
 
     C                   IF        DDDLNO = *BLANK  and DDACTN = 'I'
 
     C/COPY WNCPYSRC,ABFUNDRC03
     C                   EXSR      SRGetNxtDl
     C                   EVAL      N1DN38 = IKDN38
     C/COPY WNCPYSRC,ABFUNDRC04
     C                   MOVE      IKDN38        N1PCDN
     C                   MOVE      IKDN38        N2DADN
     C                   ELSE
     C                   MOVE      DDDLNO        N1DN38
     C                   MOVE      DDDLNO        N1PCDN
     C                   MOVE      DDDLNO        N2DADN
     C                   ENDIF
 
      ** If Insert deal associated number not defined ,
      ** get next available deal associated number
 
     C                   IF        DDACTN = 'I' AND DDDADN = *BLANK
 
     C/COPY WNCPYSRC,ABFUNDRC05
     C                   EXSR      SRGetNxtDl
     C                   EVAL      N2DN38 = IKDN38
     C/COPY WNCPYSRC,ABFUNDRC06
     C                   MOVE      IKDN38        N2PCDN
     C                   MOVE      IKDN38        N1DADN
     C                   ELSE
     C                   MOVE      DDDADN        N2DN38
     C                   MOVE      DDDADN        N2PCDN
     C                   MOVE      DDDADN        N1DADN
 
     C                   ENDIF
 
      ** Setup other fields prior to update.
 
     C                   DOW       WSetFld <> 'N'
 
     C                   IF        WSetFld = '1'
 
      ** Setup fields for Deal Number 1
 
     C                   EVAL      ValidDeal = NwDlFilFmt1
     C                   EVAL      IKMTYP = 'IL'
     C                   EVAL      IKTYPE = 'IL'
     C                   EVAL      IKPOBR = N2BRCA
     C                   EVAL      IKROBR = N2BRCA
     C                   Z-SUB     IKAMNP        IKAMNP
                                                                                              CAS004
     C                   IF        CAS004 = 'Y'                                               CAS004
     C                   EVAL      IKOYLC = N1OYLC                                            CAS004
     C                   ENDIF                                                                CAS004
 
      ** Setup fields for Associated Deal
 
     C                   ELSE
     C                   EVAL      ValidDeal = NwDlFilFmt2
     C                   EVAL      IKMTYP = 'ID'
     C                   EVAL      IKTYPE = 'ID'
     C                   EVAL      IKPOBR = N1BRCA
     C                   EVAL      IKROBR = N1BRCA
                                                                                              CAS004
     C                   IF        CAS004 = 'Y'                                               CAS004
     C                   EVAL      IKOYLC = N2OYLC                                            CAS004
     C                   ENDIF                                                                CAS004
                                                                                              CAS004
     C                   IF        IKMTTI > 0
     C                   Z-SUB     IKMTTI        IKMTTI
     C                   ENDIF
     C                   ENDIF
 
      ** Last Action Code
 
     C                   EVAL      IKLACT = DDACTN
 
      ** Update Valid deal: Front Office Transaction ID
 
     C                   EVAL      IKFRNT = PFOTranSel
 
      ** Update Valid Deal: Front Office Associated Transaction ID
 
     C                   EVAL      IKAFRT = PFOAsocSel
 
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
 
     C                   EVAL      IKCHTP = DDACTN
 
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
 
      ** Input Interest Rate
 
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
 
      ** Automatic Authorisation
 
     C                   EVAL      IKAUTH = 'Y'
 
      ** If first time around setup WSetFld to '2'
      ** If WSetFld = '2' set it to 'N'
 
     C                   IF        WSetFld = '1'
     C                   EVAL      NwDlFilFmt1 = ValidDeal
     C                   EVAL      WSetFld = '2'
     C                   ELSE
     C                   EVAL      NwDlFilFmt2 = ValidDeal
     C                   EVAL      WSetFld = 'N'
     C                   ENDIF
 
     C                   ENDDO
 
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
      *                                                               *
      *  SRResetErr - Reset error fields                              *
      *                                                               *
      *****************************************************************
     C     SRResetErr    BEGSR
 
      ** Reset Error
 
     C                   MOVE      *ALL'Y'       OkFlags
     C                   EVAL      FldNameArr = *Blanks
     C                   EVAL      MsgDtaArr = *Blanks
     C                   EVAL      MsgIdArr = *Blanks
     C                   EVAL      WFldNamArr = *Blanks
     C                   EVAL      WMsgDtaArr = *Blanks
     C                   EVAL      WMsgIdArr = *Blanks
     C                   EVAL      PValFlg   = *Blanks
 
     C                   ENDSR
      *****************************************************************
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
 
      ** Access Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Databse error
 
     C                   IF        PRTCD <> *Blanks
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBASE = 001
     C                   EXSR      *PSSR
     C                   END
 
      ** Access Module Details
 
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
 
      ** Database Error
 
     C                   IF        PRTCD <> *Blanks
     C                   EVAL      DBFILE = 'SDMMODPD'
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBASE = 002
     C                   EXSR      *PSSR
     C                   END
 
      ** Access API ICD Details
 
     C                   CALLB     'AOAPIR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDAPI         PARM      SDAPI         DSFDY
 
      ** Database Error
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDAPIPD '
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBASE = 003
     C                   EXSR      *PSSR
     C                   END
 
      ** Access General Ledger ICD
 
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
 
      ** Database Error
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDGELRPD'
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBASE = 004
     C                   EXSR      *PSSR
     C                   END
 
      ** Access SD Dealing Data via access program
 
     C**********         CALLB     'AODEALR0'                                                 CGL029
     C                   CALLB     'AODEALR1'                                                 CGL029
     C                   PARM      '*BLANKS'     PRTCD
     C                   PARM      '*FIRST '     POPTN
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
 
      ** Database Error
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDGELRPD'
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBASE = 005
     C                   EXSR      *PSSR
     C                   END
 
      ** Access SD Trading ICD  via access program
 
     C                   CALLB     'AOTRADR0'
     C                   PARM      '*BLANKS'     PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDTRAD        PARM      SDTRAD        DSFDY
 
      ** Database Error
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDGELRPD'
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBASE = 006
     C                   EXSR      *PSSR
     C                   END
 
      ** Check if S01383 is installed                                                         195001
                                                                                              195001
     C                   EVAL      S01383 = 'N'                                               195001
     C                   CALL      'AOSARDR0'                                                 195001
     C                   PARM      *Blanks       PRTCD                                        195001
     C                   PARM      '*VERIFY'     POPTN                                        195001
     C                   PARM      'S01383'      PSARD                                        195001
     C     SCSARD        PARM      SCSARD        DSFDY                                        195001
                                                                                              195001
     C                   IF        PRTCD = *Blanks                                            195001
     C                   EVAL      S01383 = 'Y'                                               195001
     C                   ELSE                                                                 195001
     C                   EVAL      S01383 = 'N'                                               195001
     C                   ENDIF                                                                195001
                                                                                              195001
      ** Database error.                                                                      195001
                                                                                              195001
     C                   IF        PRTCD <> *BLANKS  AND                                      195001
     C                             PRTCD <> '*NRF   '                                         195001
     C                   EVAL      DBKEY = PSARD                                              195001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        195001
     C                   EVAL      DBASE = 008                                                195001
     C                   EXSR      *PSSR                                                      195001
     C                   ENDIF                                                                195001
                                                                                              195001
      ** Access SD BRT Control Data
 
     C                   IF        S01383 = 'Y'                                               195001
     C                   EVAL      PKey = 'D'
     C     PKey          CHAIN     SDBRTDL1                           02
 
      ** Database error.
 
     C                   IF        *IN02 = *On  OR
     C                             RECI <> 'D'
     C                   EVAL      DBKEY = PKey
     C                   EVAL      DBFILE = 'SDBRTDPD'
     C                   EVAL      DBASE = 007
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF                                                                195001
 
      *                                                                                       CSC022
      ** Access SAR details file to determine if CSC022 switchable feature                    CSC022
      *  is switched on                                                                       CSC022
     C                   CALLB     'AOSARDR0'                                                 CSC022
     C                   PARM      *BLANKS       PRTCD                                        CSC022
     C                   PARM      '*VERIFY'     POPTN                                        CSC022
     C                   PARM      'CSC022'      PSARD                                        CSC022
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC022
                                                                                              CSC022
     C                   IF        PRTCD = *Blanks                                            CSC022
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
     C                   IF        PRTCD <> '*NRF'                                            CSC022
     C     *LOCK         IN        LDA                                                        CSC022
     C                   EVAL      DBKEY = 'CSC022'                                           CSC022
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC022
     C                   EVAL      DBASE = 011                                                CSC022
     C                   OUT       LDA                                                        CSC022
     C                   EXSR      *PSSR                                                      CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ENDIF                                                                CSC022
 
      ***Check*if*S01383*is*installed                                                         195001
      **********                                                                              195001
     C**********         EVAL      S01383 = 'N'                                               195001
     C**********         CALL      'AOSARDR0'                                                 195001
     C**********         PARM      *Blanks       PRTCD                                        195001
     C**********         PARM      '*VERIFY'     POPTN                                        195001
     C**********         PARM      'S01383'      PSARD                                        195001
     C*****SCSARD        PARM      SCSARD        DSFDY                                        195001
      **********                                                                              195001
     C**********         IF        PRTCD = *Blanks                                            195001
     C**********         EVAL      S01383 = 'Y'                                               195001
     C**********         ENDIF                                                                195001
      **********                                                                              195001
      ***Database*error.                                                                      195001
      **********                                                                              195001
     C**********         IF        PRTCD <> *BLANKS  AND                                      195001
     C**********                   PRTCD <> '*NRF   '                                         195001
     C**********         EVAL      DBKEY = PSARD                                              195001
     C**********         EVAL      DBFILE = 'SCSARDPD'                                        195001
     C**********         EVAL      DBASE = 008                                                195001
     C**********         EXSR      *PSSR                                                      195001
     C**********         ENDIF                                                                195001
 
      ** Export CDL006 field
 
     C                   CALLB     'MMFIDINIT'
     C                   PARM      *Blanks       PRTCD
 
     C                   IF        PRTCD <> *Blanks
     C                   EVAL      RunBefore = 'Y'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Key Lists
 
     C     ZATRNKD0      KLIST
     C                   KFLD                    PFOTranSel
     C                   KFLD                    PTmeStpSel
 
     C     ZATRNKX0      KLIST
     C                   KFLD                    PTmeStpSel
     C                   KFLD                    PFOTranSel
                                                                                              CSC011
     C     KAPILOGL0     KLIST                                                                CSC011
     C                   KFLD                    KMsgType                                     CSC011
     C                   KFLD                    KFrntOffID                                   CSC011
     C                   KFLD                    KTimeStamp                                   CSC011
 
      ** Retrieve RUNDAT details.
 
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
 
      ** Retrieve ZMUSER details.
 
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
 
      ** Save Midas Run Date
 
     C                   EVAL      WkBJMRDT = BJMRDT
                                                                                              CSC011
      ** Check if CSC011 is installed                                                         CSC011
      ** If CSC011 is installed and in switchover mode, use                                   CSC011
      ** S1DATE from DTAARA/SC24x7 as the rundate.                                            CSC011
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
     C                   OPEN      APILOGL0                                                   CSC011
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
     C                   EVAL      DBASE = 009                                                CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CAS004
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
     C                   EVAL      DBASE = 10                                                 CAS004
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
                                                                                              CDL020
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
 
      ** Convert Midas Day Number to YYYYMMDD format
 
     C                   CALLB     'ZDATE9'
     C**********         PARM      BJRDNB        PDayNoIn                                     CSC011
     C                   PARM      WRunDay       PDayNoIn                                     CSC011
     C                   PARM      *ZERO         PDateOutZ9
     C                   PARM                    PRetCode
 
      ** Get the field number for the action code field; the screen fields
      ** start from that number.  Subtract one from it to give the value
      ** to subtract from each field's number.
 
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM                    ReturnCode
     C                   PARM                    Format
     C                   PARM                    Field
     C                   PARM                    FieldNo
 
     C                   IF        ReturnCode = *blank
     C                   EVAL      FldOffset = FieldNo - 1
 
      ** If there was an error default the offset to 13
 
     C                   ELSE
     C                   EVAL      FldOffset = 13
     C                   ENDIF
 
      ** Start on Browse Screen
 
     C                   EVAL      PScrn = 'B'
 
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
 
      /COPY ZACPYSRC,DBFIELDS
 
      ** Hook to enable non-core initial processing to be included
 
      /COPY WNCPYSRC,ABFUNDR011
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
 
     C/COPY ZACPYSRC,PSSR_ILE
 
      ********************************************************************
      *
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
