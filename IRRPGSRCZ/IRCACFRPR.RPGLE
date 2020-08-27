     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Caps/collars/floors repair')                  *
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Module                                       *
      *                                                               *
      *  IRCACFRPR - Invalid Caps/Colalrs/Floors Details              *
      *              Repair Function                                  *
      *                                                               *
      *  Function:  This function allows invalid Caps/Collars/Floors  *
      *             deals to be 'repaired' and applied to the Midas   *
      *             database.                                         *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD054117           Date 12Sep19               *
      *                 MD046248           Date 27Oct17               *
      *                 MD036070           Date 19Oct15               *
      *                 CDL094             Date 11Jun14               *
      *                 CIR017             Date 10Apr14               *
      *                 CSD095             Date 08Apr14               *
      *                 AR314712           Date 13Apr10               *
      *                 AR218555           Date 26Mar10               *
      *                 245692             Date 11Dec13               *
      *                 CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 247888             Date 18May07               *
      *                 245219             Date 14Mar07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 233467             Date 06Jun05               *
      *                 BUG7166            Date 12May05               *
      *                 CDL038             Date 10May05               *
      *                 CLE031             Date 26Apr05               *
      *                 BUG6472            Date 23Apr05               *
      *                 CDL028             Date 07Feb05               *
      *                 BUG5707            Date 28jan05               *
      *                 BUG2603            Date 12May04               *
      *                 CDL018             Date 03Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 222373             Date 30Oct03               *
      *                 CAS005             Date 16Dec02               *
      *                 CAS004             Date 26Jun02               *
      *                 CAP043             Date 02May02               *
      *                 217684             Date 12May03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 209375             Date 09Sep02               *
      *                 209372             Date 09Sep02               *
      *                 185064             Date 05Aug02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP056             Date 13Mar02               *
      *                 CIR008             Date 13Mar02               *
      *                 CAP055  *CREATE    Date 13Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD054117 - Principal change Increase/Decrease capability     *
      *  MD046248 - Finastra Rebranding                               *
      *  MD036070 - No way to go back to main deal details screen     *
      *             after reaching settlement screen.  Introduce new  *
      *             function key F11.                                 *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CIR017 - SIRS Business Day Conventions for both Legs         *
      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
      *  AR314712 - Missing Account Key for Caps/Floors Deals.        *
      *             Default Up-front fee pay/rcv based on buy/sell    *
      *             indicator.                                        *
      *  AR218555 - Cannot authorise/edit Caps, Collars, Floors in    *
      *           WIP. It issues error message RS00018.               *
      *           - Do not validate the Fees and Buy out fields       *
      *           if CIR006 is switched off.                          *
      *  245692 - Incorrect validation of rates when the decimal se-  *
      *           parator in the Dealing ICD was defined as "," ins-  *
      *           tead of ".".                                        *
      *         - Applied for MD23981.                                *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  247888 - Missing record in CLE025 files.                     *
      *  245219 - Missing deals in extension file DLDLDGQD (done from *
      *           Java layer).                                        *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  233467 - Add parameter on call to IRSFBOVAL                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG7166- Valid file does not match DEALSDG (Recompile)       *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
      *  BUG6472- Added a sign field for short term rate              *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  BUG5707 - Parameter mismatch in IRCACFVAL and IRCACFCVT      *
      *  BUG2603- Commitment Control Changes for Midas Plus           *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  222373 - Correct parameters on program calls                 *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CAS004 - Hedge Accounting Phase A (Recompile)                *
      *  CAP043 - Additional APIs for IRS Schedules                   *
      *  217684 - Authorisation User Malfunction (Recompile)          *
      *  209375 - Successfully inserted deal number via repair main-  *
      *           tenance should be displayed in the repair browse    *
      *           screen                                              *
      *  209372 - Error related to calling of IRFEBOSIN               *
      *  185064 - Old up-front fee details should be saved in         *
      *           DLDGUPFE.                                           *
      *  CAP056 - Automatic Authorisation of Interface deals          *
      *  CIR008 - FRA/IRS Deals Authorisations                        *
      *  CAP055 - APIs for FRA/IRS Caps/Collars/Floors                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    80         No record found for CHAIN operation             *
      *    81         End of file for READE operation                 *
      *    82         String found for SCAN operation                 *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SrBsDyC    - Business Day Convention Processing              *
      *  SrCancC    - Cancel on Confirmation Screen                   *
      *  SrCancM    - Cancel on Main Details Screen                   *
      *  SrCancS    - Cancel on Settlement Details Screen             *
      *  SrDtaSubsS - Settlement Details Data Substitution            *
      *  SrDtaSubsT - Transaction Details Data Substitution           *
      *  SrEndPgm   - End Program                                     *
      *  SrExitC    - Exit from Confirmation Screen                   *
      *  SrExitS    - Exit from Settlement Details Screen             *
      *  SrFBConv   - Convert Fees and Buy-out Screen                 *
      *  SrFBProc   - Fees and Buy-outs Processing                    *
      *  SrFileFlds - Set up Up-front Fee Details File Fields         *
      *  SrParmS    - Determine Parameters for Settlement Details     *
      *               Screen                                          *
      *  SrSetupPCSC- Setup Principal Change Schedules                *                       CAP043
      *  SrPrinSked - Validate Principal Change Schedules             *
      *  SrPutDlM   - Put a Deal on the Main Details Screen           *
      *  SrRdNxtB   - Read Next Browse Subfile Record                 *
      *  SrRtvDeal  - Retrieve a Deal from the Database               *
      *  SrScrnB    - Browse Invalid Deals                            *
      *  SrScrnC    - Confirmation of Input Evoked for Inserts,       *
      *               Amends & Authorisations                         *
      *  SrScrnM    - Main Detail Screen                              *
      *  SrScrnS    - Settlement Details Evoked for Inserts, Amends,  *
      *               Enquiries & Authorisations                      *
      *  SrSndmB    - Send Messages to Business Day Convention Screen *
      *  SrSndmF    - Send Messages to Fees and Buy-out Details Screen*
      *  SrSndmM    - Send Messages to Main Details Screen            *
      *  SrSSIAmd   - Setup Settlement Instructions on Amendment      *
      *  SrUpdate   - File Updates                                    *
      *  SrIPCSC    - Call to IRIPCSCRT                               *                       CAP043
      *  SrDelInIRC - Delete Invalid Principal Change Date Records    *                       CAP043
      *  SrUpdUpF   - Write into PF/DLDGUPFE old values of up-front   *
      *               value date, fee and P/R indicator               *
      *  SrValF     - Validate Fees and Buy-out Details               *
      *  SrValM     - Validate Input to Main Details Screen           *
      *  SrWindow   - Call Window Manager                             *
      * *PSSR       - Error processing                                *
      * *INZSR      - Initialise                                      *
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
     FZATRNERRL0IF   E           K DISK    INFSR(*PSSR)
 
     FIRICACFL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(IRICACFD0:IRICACFX0)
 
     FIRICACFL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
     FAPIDSETL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(APIDSETD0:APIDSETX0)
 
     FAPIDSETL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
     FDLDGUPFE  O    E           K DISK    INFSR(*PSSR)
     F                                     RENAME(DLDGREF:DLDGREFF)
     F                                     COMMIT
 
     FDLDGUPL1  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
     FAPILOGL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
     FIRIPCSCL0 IF   E           K DISK    INFSR(*PSSR)                                       CAP043
     F                                     RENAME(IRIPCSCD0 : IRIPCSCX0)                      CAP043
     F                                     PREFIX(PI)                                         CAP043
     FIRIPCSCL1 UF   E           K DISK    INFSR(*PSSR)                                       CAP043
     F                                     PREFIX(PI)                                         CAP043
     F                                     COMMIT                                             CAP043
                                                                                              CAP043
      ** Midas IR Deals Extension Details.                                                    245219
     FDLDEALL5  UF A E           K DISK    INFSR(*PSSR)                                       245219
     F                                     IGNORE(DLDLDBD0)                                   245219
     F                                     IGNORE(DLDLDCD0)                                   245219
      ** Hook to enable non-core files to be included
      /COPY WNCPYSRC,IRCACFR001
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
      /COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
      /COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
      /COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      /COPY ZACPYSRC,ERR_ARRAYS
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
 
      ** Data structure for data area commitment control                                     BUG2603
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                BUG2603
     D  ComitJobs              4    103A                                                     BUG2603
                                                                                             BUG2603
     D JobCmtCtlDS     S             10A   DIM(10)                                           BUG2603
      * MIDAS SC Jobs Handling Commitment Control Data Structure                             BUG2603
                                                                                             BUG2603
      ** Error and warning arrays used by IRSBSDYVAL
     D MsgIdArr2       S                   DIM(ArrayMax)
     D                                     LIKE(MsgIdArr)
     D FldNameArr2     S                   DIM(ArrayMax)
     D                                     LIKE(FldNameArr)
     D WMsgIDArr2      S                   DIM(ArrayMax)
     D                                     LIKE(MsgIdArr)
     D WFldNamArr2     S                   DIM(ArrayMax)
     D                                     LIKE(FldNameArr)
 
      ** Work array for warning message Ids
     D WPrvWarnAr      S                   Dim(ArrayMax)
     D                                     Like(WMsgIDArr)
 
     D Arr_ErrFlag     S              1    DIM(61)
 
      ** Current Caps/Collars/Floors deal in file format
     D CrIRFilFmt    E DS                  EXTNAME(DEALSDG)
     D   CrRecSSI            716    784
     D   CrPaySSI            785   1343
     D   CrIRSSSI           1345   1992
 
      ** Current Caps/Collars/Floors deal in screen format
     D CrIRScnFmt    E DS                  EXTNAME(IRCACFPD)
     D                                     PREFIX(C_)
 
      ** New Caps/Collars/Floors deal in file format
     D NwIRFilFmt    E DS                  EXTNAME(IRVCACFPD)
     D   NwRcvSSI            716    784
     D   NwPaySSI            785   1343
     D   NwIRSSSI           1345   1992
 
      ** New Caps/Collars/Floors deal in screen format
     D NwIRScnFmt    E DS                  EXTNAME(IRCACFPD)
     D   BsDayConv           205    268
     D   RtFxConv            239    268
     D   BsDayConP           205    234                                                       CAP043
 
      ** Error indicators/OK flags
     D IRECACF       E DS                  EXTNAME(IRECACFPD)
 
      ** Pay/Rcv/FRA-IRS Settlement instructions in File format
     D ##RECF        E DS                  EXTNAME(SDESFRPD)
     D***FlRcvIns              1     69                                                       CGL029
     D   FlRcvIns              1     75                                                       CGL029
     D ##PAYF        E DS                  EXTNAME(SDESFPPD)
     D***FlPayIns              1    559                                                       CGL029
     D   FlPayIns              1    575                                                       CGL029
     D ##RSIF        E DS                  EXTNAME(SDESFFPD)
     D   FlIRSIns              1    650
 
      ** Pay/Rcv/FRA-IRS Settlement instructions in Screen format
     D ##RECS        E DS                  EXTNAME(SDESSRPD)
     D ##PAYS        E DS                  EXTNAME(SDESSPPD)
     D ##RSIS        E DS                  EXTNAME(SDESSFPD)
 
      ** Current Pay/Rcv/FRA-IRS Settlement Instructions
     D CrPaySttmt    E DS                  EXTNAME(SDESSPPD)
     D                                     PREFIX(@)
     D CrRecSttmt    E DS                  EXTNAME(SDESSRPD)
     D                                     PREFIX(@)
     D CrFRASttmt    E DS                  EXTNAME(SDESSFPD)
     D                                     PREFIX(@)
 
      ** IR CACF Extra Data - File (D/B) format
     D ExtData       E DS                  EXTNAME(IRCPEXPD)
 
      ** Transaction Details in screen format
     D NwFBScnFmt    E DS                  EXTNAME(IRFEBOPD)
     D                                     PREFIX(SF)
 
      ** Transaction Details in screen format
     D CrFBScnFmt    E DS                  EXTNAME(IRFEBOPD)
     D                                     PREFIX(O)
 
      ** Transaction Details in screen format
     D NwFBScnFld    E DS                  EXTNAME(IRFEB1PD)
     D                                     PREFIX(SF)
 
      ** Transaction Details OK indicators
     D OKFEBO        E DS                  EXTNAME(IREFEBOPD)
     D                                     PREFIX(SF)
 
      ** Pay/Rcv Settlement Currency, Method & Nostro
     D DSSettIns       DS
     D   RecSetCcy             1      3
     D   RecSetMeth            4      5  0
     D***RecNostro             6     17                                                       CGL029
     D***PaySetCcy            18     20                                                       CGL029
     D***PaySetMeth           21     22  0                                                    CGL029
     D***PayNostro            23     34                                                       CGL029
     D   RecNostro             6     23                                                       CGL029
     D   PaySetCcy            24     26                                                       CGL029
     D   PaySetMeth           27     28  0                                                    CGL029
     D   PayNostro            29     40                                                       CGL029
                                                                                              CAP043
     D PErrorFndPr     DS                                                                     CAP043
     D   OurPrinEr             1      1                                                       CAP043
     D   ThrPrinEr             2      2                                                       CAP043
 
      ** External DS for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for Module details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      ** External DS for Deal details
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
 
      ** External DS for General Ledger details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D  GelrACCD     E                     EXTFLD(QQACCD)                                     CGL029
 
      ** External DS for API ICD
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
 
      ** External DS for Trading details
     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
     D  TradACCD     E                     EXTFLD(QQACCD)                                     CGL029
 
      ** External DS for FRA/IRS ICD details
     D SDFAIS        E DS                  EXTNAME(SDFAISPD)
 
      ** External DS Retail details
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
     D  RetlACCD     E                     EXTFLD(QQACCD)                                     CGL029
 
      ** Currency details file
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** External DS for Nostro Details
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
     D  NostACCD     E                     EXTFLD(QQACCD)                                     CGL029
 
      ** External DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D   SCLCD       E                     EXTFLD(LCD)
 
      ** 24X7 status data area
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
 
      ** SD data area
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
 
      ** ZMUSER data area
     D ZMUSER        E DS                  EXTNAME(ZMUSER) DTAARA(ZMUSER)
 
      ** Short DS for Access Programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long DS for Access Programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D PInPCSCDS     E DS                  EXTNAME(IRIPCSCPD)                                 CAP043
     D                                     PREFIX(PI)                                         CAP043
      ** Invalid PCSC definition file                                                         CAP043
                                                                                              CAP043
     D/COPY QWINDSRC,IRCACFDTA
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Timestamp selected
     D PTmestpSel      S             26Z
 
      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')
 
      ** -------------------------------------------------------------------
      ** Fields for getting the starting field number from file (parameters
      ** to ZAGETFLDNO, plus the offset to the requested field).
     D Format          S             10A   INZ('IRCACFPD')
     D Field           S             10A   INZ('#0ACCD')
     D FieldB          S             10A   INZ('#0C1P1')
     D*FieldF***       S             10A   INZ('SUFVD')                                       209372
     D FieldF          S             10A   INZ('#0UFVD')                                      209372
     D FieldNo         S              5P 0
     D FldOffset       S              5P 0
     D FldOffsetB      S              5P 0
     D FldOffsetF      S              5P 0
 
      ** End of fields for getting starting field number
      ** -------------------------------------------------------------------
 
      ** For Business Day Convention screen
     D WSndScn2        S              1A   INZ('N')
     D POKFlags        S             25A
     D POKFlags2       S             22A
     D IRESBDY         S             22A
      ** Work fields used by CIR017                                                           CIR017
     D BsDayConv2      S            128A                                                      CIR017
     D POkFlagExt      S             44A                                                      CIR017
 
      ** Message type field for chaining to APIDSETPD; defined in terms
      ** of the file field when the file field was changed.
     D KMsgType        S                   LIKE(DDMSGTYPE)
 
      ** Parameters
     D*PAccd**         S              4A                                                      CGL029
     D PAccd           S             10A                                                      CGL029
     D PAcSel          S              1A
     D PAcsn           S              2A
     D PActCode        S              1A
     D PAction         S              1A
     D PAmendsOK       S              1A
     D PBldSfl         S              1A
     D PBranch         S              3A
     D PBrcd           S              3A
     D PCallgPgm       S              4A
     D PCcy            S              3A
     D PCssn           S             10A
     D PCust           S              6A
     D PCustSName      S             10A
     D PDealNo         S              6A
     D PEDtFld         S              1A
     D PEINKG          S              1A
     D PEINKH          S              1A
     D PEINKJ          S              1A
     D PEINKN          S              1A
     D PEINKP          S              1A
     D PEKYFD          S              1A
     D PErrMs          S              7A
     D PErrUp          S              1A
     D PFedFund        S              1A
     D PFKey           S              2A
     D PFOTranSel      S             20A
     D PFOAsocSel      S             20A
     D PGNDlno         S              6A
     D PINKC           S              1A
     D PINKG           S              1A
     D PINKH           S              1A
     D PINKJ           S              1A
     D PINKK           S              1A                                                    MD036070
     D PINKL           S              1A
     D PINKN           S              1A
     D PINKP           S              1A
     D Pinoy           S              1A
     D PLCcy           S              3A
     D PNost           S              2P 0
     D POptn           S              7A
     D POptSel         S              1A
     D PPayCcy         S              3A
     D PPgm            S             10A
     D PProtectPay     S              1A
     D PProtectRec     S              1A
     D PPymtDt         S              5P 0
     D PRcptDt         S              5P 0
     D PRcvCcy         S              3A
     D PRdSfl          S              1A
     D PResetErrs      S              1A
     D PResetFld       S              1A
     D PRtCd           S              7A
     D PSarD           S              6A
     D PSIDN           S              6A
     D PTransTyp       S              1A
     D BlankSTYP       S              2A                                                      CSD095
     D BlankBRCA       S              3A                                                      CSD095
 
      ** Work variables
     D CAP041          S              1A
     D CAP056          S              1A                                                      CAP056
     D CDE001          S              1A
     D CEU003          S              1A
     D CIR001          S              1A
     D CIR005          S              1A
     D CIR006          S              1A
     D CIR007          S              1A
     D CIR008          S              1A                                                      CIR008
     D CSC011          S              1A
     D CurDATA         S           2000A
     D DDSTS           S             24A
     D E               S              3P 0
     D F               S              3P 0
     D FOASID          S             20A
     D FOTRID          S             20A
     D Idx             S              3P 0
     D IncDATA         S           2000A
     D ModeOfOp        S              6A
     D MsgID1          S                   LIKE(#MsgID)
     D RtnCde10A       S             10A
     D WIdx            S              3P 0
 
     D W_Accd          S              1A
     D W_Dlno          S              6A
     D WDlno           S              6P 0
     D WFntKey         S              2A
     D WarnFlag        S              1A   INZ('N')
     D WFirstPass      S              1A   INZ('Y')
     D WRdNB           S              1A
     D WSavBDC         S             64A
     D WSavRC          S             30A
     D WScrn           S              1A
     D WSpareW         S            256A
     D WSubsChar       S              1A
     D WValBDC         S              1A
 
      ** Fields used for 24x7 Midas Availability
     D KMsgTyp         S              8A
     D KFrntOffID      S             20A
     D KTimeStamp      S                   LIKE(PTmestpSel)
 
      ** Work variables for Fees and Buy-outs processing
     D PWUCDP          S              1P 0
     D PWTCDP          S              1P 0
     D PWPSCY          S              3A
     D PWRSCY          S              3A
     D PWPNLOC         S              3A
     D PWRNLOC         S              3A
     D WRedisplay      S              1A
     D PAmendOK        S              1A
     D WIx             S              3P 0
     D WRsnd           S              1A
 
      ** Work fields used by CAP043                                                           CAP043
     D CAP043          S              1A                                                      CAP043
     D PPrevDate       S              5P 0                                                    CAP043
     D PCurrency       S              3A                                                      CAP043
     D WOurThr         S              1A                                                      CAP043
     D PUpdate         S              1A                                                      CAP043
     D PScreenInpt     S              1A                                                      CAP043
     D PCtlDate        S              5P 0                                                    CAP043
     D PPAmt           S             15P 0                                                    CAP043
                                                                                              CAP043
      ** Business Day Convention currencies                                                   CAP043
     D PBDConvtn       S             30A                                                      CAP043
                                                                                              CAP043
      ** Define workfields for Commitment Control Changes for Midas Plus                     BUG2603
     D CSC022          S              1A                                                     BUG2603
     D WSkpCom         S              1A                                                     BUG2603
     D WPos            S              2S 0                                                   BUG2603
                                                                                             BUG2603
      ** Additional Parameter for IRSFBOVAL                                                   233467
     D vDLNO           S              6A   INZ(*BLANKS)                                       233467
                                                                                             CSF011A
     D InRCCY          S              3A                                                     CSF011A
     D InPCCY          S              3A                                                     CSF011A
      *                                                                                     MD054117
     D PSYSVAL1        C                   CONST('DspPrinInDecInd')                         MD054117
     D PRETURN         S              7A                                                    MD054117
     D POP01           S             20A                                                    MD054117
     D PVL01           S            200A                                                    MD054117
     D POP02           S             20A                                                    MD054117
     D PVL02           S            200A                                                    MD054117
     D POP03           S             20A                                                    MD054117
     D PVL03           S            200A                                                    MD054117
     D POP04           S             20A                                                    MD054117
     D PVL04           S            200A                                                    MD054117
     D POP05           S             20A                                                    MD054117
     D PVL05           S            200A                                                    MD054117
     D POP06           S             20A                                                    MD054117
     D PVL06           S            200A                                                    MD054117
     D POP07           S             20A                                                    MD054117
     D PVL07           S            200A                                                    MD054117
     D POP08           S             20A                                                    MD054117
     D PVL08           S            200A                                                    MD054117
     D POP09           S             20A                                                    MD054117
     D PVL09           S            200A                                                    MD054117
     D POP10           S             20A                                                    MD054117
     D PVL10           S            200A                                                    MD054117
     D PCIDCF          S              1A                                                    MD054117
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,IRCACFR002
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      /COPY WNCPYSRC,IRCACFR003
      ** Do Screen: Browse invalid deals
 
     C                   IF        WScrn = 'B'
     C                   EXSR      SrScrnB
     C                   ENDIF
 
      /COPY WNCPYSRC,IRCACFR004
      ** Read next Browse subfile record
 
     C                   IF        WScrn = 'R'
     C                   EXSR      SrRdNxtB
     C                   ENDIF
 
      /COPY WNCPYSRC,IRCACFR005
      ** Do While Screen: Main details
 
     C                   DOW       WScrn = 'M'
     C                   EXSR      SrScrnM
     C                   ENDDO
 
      /COPY WNCPYSRC,IRCACFR006
      ** Do While Screen: Fees/Buy-Outs details
 
     C                   DOW       WScrn = 'F'
     C                   EXSR      SrFBProc
     C                   ENDDO
 
      /COPY WNCPYSRC,IRCACFR007
      ** Screen: Window
 
     C                   IF        WScrn = 'W'
     C                   EXSR      SrWindow
     C                   ENDIF
 
      /COPY WNCPYSRC,IRCACFR008
      ** Do While Screen: Settlement details
 
     C                   DOW       WScrn = 'S'
     C                   EXSR      SrScrnS
     C                   ENDDO
 
      /COPY WNCPYSRC,IRCACFR009
      ** Screen: Confirmation of input
 
     C                   IF        WScrn = 'C'
     C                   EXSR      SrScrnC
     C                   ENDIF
 
      /COPY WNCPYSRC,IRCACFR010
      ** Do file updates
 
     C                   IF        WScrn = 'U'
     C                   EXSR      SrUpdate
     C                   ENDIF
 
      /COPY WNCPYSRC,IRCACFR011
      ** Terminate program
 
     C                   IF        WScrn = 'T'
     C                   MOVE      '1'           *INLR
     C                   ENDIF
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,IRCACFR012
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrScrnB - Browse Invalid Deals                               *
      *****************************************************************
     C     SrScrnB       BEGSR
 
     C                   EVAL      WRdNB = *BLANKS
 
     C                   CALLB     'IRCACFRPB'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM      'Y'           PBldSfl
     C                   PARM      *BLANKS       PRdSfl
     C                   PARM                    PErrUp
     C                   PARM                    BJSBRC
     C                   PARM                    CSC011
     C                   PARM      *BLANKS       PErrMs
     C                   PARM                    POptSel
     C                   PARM                    PAcSel
     C                   PARM                    PFOTranSel
     C                   PARM                    PFOAsocSel
     C                   PARM                    PTmestpSel
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKL
     C                   PARM                    PSIDN
     C                   PARM                    CAP041                                       CAP043
     C                   PARM                    CAP043                                       CAP043
 
      ** If error, set on external switches
 
     C                   IF        PErrMs <> *BLANKS
     C                   EVAL      *INU6 = *ON
     C                   ENDIF
 
      ** If F3 or F12 taken in Browse or error message, end program
 
     C                   IF        PINKC = '1' OR PINKL = '1' OR
     C                             PErrMs <> *BLANKS
     C                   EXSR      SrEndPgm
     C                   GOTO      ESrScrnB
     C                   ENDIF
 
      ** Read next browse subfile record
 
     C                   EVAL      WRdNB = 'Y'
     C                   EVAL      WScrn = 'R'
 
     C     ESrScrnB      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrRdNxtB - Read Next Browse Subfile Record                   *
      *****************************************************************
     C     SrRdNxtB      BEGSR
 
     C                   CALLB     'IRCACFRPB'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM      *BLANKS       PBldSfl
     C                   PARM      'Y'           PRdSfl
     C                   PARM                    PErrUp
     C                   PARM                    BJSBRC
     C                   PARM                    CSC011
     C                   PARM      *BLANKS       PErrMs
     C                   PARM      *BLANKS       POptSel
     C                   PARM      *BLANKS       PAcSel
     C                   PARM      *BLANKS       PFOTranSel
     C                   PARM      *BLANKS       PFOAsocSel
     C                   PARM                    PTmestpSel
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKL
     C                   PARM                    PSIDN
     C                   PARM                    CAP041                                       222373
     C                   PARM                    CAP043                                       222373
 
      ** If F3 taken within invalid transaction deletion function,
      ** end program
 
     C                   IF        PINKC = '1'
     C                   EXSR      SrEndPgm
     C                   GOTO      ESrRdNxtB
     C                   ENDIF
 
      ** If invalid deal read from subfile, blank the Main screen
 
     C                   IF        POptSel <> *BLANKS
     C                   EVAL      NwIRScnFmt = *BLANKS
     C                   EVAL      DDSTS = *BLANKS
     C                   EVAL      IRECACF = *ALL'Y'
     C                   MOVEA     *BLANKS       FldNameArr
     C                   MOVEA     *BLANKS       MsgIdArr
     C                   MOVEA     *BLANKS       MsgDtaArr
     C                   MOVEA     *BLANKS       WFldNamArr
     C                   MOVEA     *BLANKS       WMsgIdArr
     C                   MOVEA     *BLANKS       WMsgDtaArr
 
      ** Retrieve deal details
 
     C                   EVAL      #0ACCD = PAcSel
     C                   EVAL      FOTRID = PFOTranSel
     C                   EVAL      FOASID = PFOAsocSel
 
      ** Make sure Invalid transaction's  details are passed to RTV
      ** module for SPF checking
 
     C     ZATRNKX0      CHAIN     IRICACFX0                          80
 
      ** Set retrieve mode to '*FRONT' (Access using FOID) if Insert,
      ** or if not insert and Midas deal number is not present
      ** Otherwise set retrieve mode to blanks (Access using Midas deal number)
 
     C                   IF        #0ACCD = 'I'
     C                   EVAL      ModeOfOp = '*FRONT'
     C                   ELSE
     C                   IF        #0DLNO = *BLANKS
     C                   EVAL      ModeOfOp = '*FRONT'
     C                   ELSE
     C                   EVAL      ModeOfOp = *BLANKS
     C                   ENDIF
     C                   ENDIF
 
     C                   EXSR      SrRtvDeal
 
     C                   EVAL      ModeOfOp = '*RPR  '
 
     C                   IF        CIR005 = 'Y'
     C                   CLEAR                   BsDayConv
     C                   ENDIF
 
      ** If deal details were retrieved, put deal on the Main screen
 
     C                   IF        RECI <> *BLANKS AND #0ACCD <> 'I'
     C                   EXSR      SrPutDlM
     C                   ENDIF
 
      ** Now overwite the fields on the main details screen with those
      ** on the invalid deals file (except for the Midas deal number
      ** retrieved above using the FOIDs and Associated FOIDs)
      ** Access invalid deal with timestamp and FOID.
 
     C                   EVAL      W_Dlno = #0DLNO
     C     ZATRNKX0      CHAIN     IRICACFX0                          80
     C                   IF        RECI <> *BLANKS AND #0ACCD <> 'I'
     C                   EVAL      #0DLNO = W_Dlno
     C                   ENDIF
 
      ** Access invalid deal settlement instructions
 
     C                   CLEAR                   ##PAYS
     C                   CLEAR                   ##RECS
     C     APDSETKX      CHAIN     APIDSETX0                          80
 
      ** If deal details were retrieved and this is an amendment,
 
     C                   IF        RECI <> *BLANKS AND #0ACCD = 'A'
 
      ** Data Substitution - Transaction Details
 
     C                   IF        GHSUBS <> *BLANKS
     C     GHSUBS        SCAN      NwIRScnFmt                             82
     C                   IF        *IN82 = *ON
     C                   EXSR      SrDtaSubsT
     C                   ENDIF
     C                   ENDIF
 
      ** Setup settlement instructions on amend
 
     C                   EXSR      SrSSIAmd
 
      ** Data Substitution - Settlement Details
 
     C                   IF        GHSUBS <> *BLANKS
     C     GHSUBS        SCAN      ##PAYS                                 82
     C                   IF        *IN82 = *OFF
     C     GHSUBS        SCAN      ##RECS                                 82
     C                   ENDIF
     C                   IF        *IN82 = *OFF
     C     GHSUBS        SCAN      ##RSIS                                 82
     C                   ENDIF
     C                   IF        *IN82 = *ON
     C                   EXSR      SrDtaSubsS
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
      ** If action code or deal number were not ok, blank out
      ** Action code so that the input cannot proceed
 
     C                   IF        OKACCD = 'N' OR OKDLNO = 'N'
     C                   EVAL      #0ACCD = *BLANKS
     C                   ENDIF
 
      ** Send error messages and go to the Main details screen
 
     C                   EXSR      SrSndmM
     C                   EVAL      WScrn = 'M'
 
      ** Else if no invalid deal read from subfile, go to Browse screen
 
     C                   ELSE
     C                   EVAL      WScrn = 'B'
     C                   ENDIF
 
     C                   IF        CIR005 = 'Y'
     C                   EVAL      WFirstPass = 'Y'
     C                   EVAL      WSndScn2 = 'N'
     C                   ENDIF
 
     C                   EVAL      WRsnd = 'N'
 
     C     ESrRdNxtB     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrSndmM - Send Messages to Main Details Screen               *
      *****************************************************************
     C     SrSndmM       BEGSR
 
     C                   EVAL      E = Idx
 
      ** If there are fundamental errors in this transaction,
      ** identify this fact
 
     C                   IF        OKACCD = 'N' OR OKDLNO = 'N'
     C                   ADD       1             E
     C                   EVAL      FldNameArr(E) = '*ANY'
     C                   EVAL      MsgIdArr(E) = 'APM0110'
     C                   ENDIF
 
      ** Initialize error indicators
 
     C                   MOVEA     IRECACF       Arr_ErrFlag
 
      ** Read error messages for deal
 
     C     ZATRNKD0      SETLL     ZATRNERRD0
     C     ZATRNKD0      READE     ZATRNERRD0                             81
 
      ** Add error message to array passed to detail screen
      ** and set OK flag for field to 'N'
 
     C                   DOW       *IN81 = *OFF
     C                   IF        CIR005 = 'N' OR
     C                             ABFIELDID < FldOffsetB AND
     C                             CIR005 = 'Y'
     C                   ADD       1             E
     C                   EVAL      FldNameArr(E) = ABFIELDNAM
     C                   EVAL      MsgIdArr(E) = ABMSGID
     C                   Z-ADD     ABFIELDID     F
     C                   SUB       FldOffset     F
     C                   IF        F < 1  OR F > 60
     C                   EVAL      F = 1
     C                   ENDIF
     C                   EVAL      Arr_ErrFlag(F) = 'N'
     C                   ENDIF                                                  CIR005
     C     ZATRNKD0      READE     ZATRNERRD0                             81
     C                   ENDDO
 
     C                   MOVEA     Arr_ErrFlag   IRECACF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrSndmB - Send Messages to Business Day Convention Screen    *
      *****************************************************************
     C     SrSndmB       BEGSR
 
     C                   EVAL      E = 0
 
      ** Initialize error indicators
 
     C                   EVAL      IRESBDY = *ALL'Y'
     C                   MOVEA     IRESBDY       Arr_ErrFlag
 
      ** Read error messages for deal
 
     C     ZATRNKD0      SETLL     ZATRNERRD0
     C     ZATRNKD0      READE     ZATRNERRD0                             81
 
      ** Add error message to array passed to detail screen
      ** and set OK flag for field to 'N'
 
     C                   DOW       *IN81 = *OFF
     C                   IF        ABFIELDID > FldOffSetB
     C                             AND ABFIELDID <= FldOffSetF
     C                   ADD       1             E
     C                   EVAL      FldNameArr2(E) = ABFIELDNAM
     C                   EVAL      MsgIdArr2(E) = ABMSGID
     C                   Z-ADD     ABFIELDID     F
     C                   SUB       FldOffsetB    F
     C                   IF        F < 1 OR F > 60
     C                   EVAL      F = 1
     C                   ENDIF
     C                   EVAL      Arr_ErrFlag(F) = 'N'
     C                   ENDIF
     C     ZATRNKD0      READE     ZATRNERRD0                             81
     C                   ENDDO
 
     C                   MOVEA     Arr_ErrFlag   IRESBDY
     C                   EVAL      POkFlags = %SUBST(IRESBDY:13:10) +
     C                                        %SUBST(IRESBDY:1:10) +
     C                                        %SUBST(IRESBDY:11:2)
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrSndmF - Send Messages to Fees and Buy-out Details Screen   *
      *****************************************************************
     C     SrSndmF       BEGSR
 
     C                   EVAL      E = 0
     C                   EVAL      WRsnd = 'Y'
 
      ** Initialize error indicators
 
     C                   EVAL      OKFEBO  = *ALL'Y'
     C                   MOVEA     OKFEBO        Arr_ErrFlag
     C                   MOVEL     *BLANKS       FldNameArr
     C                   MOVEL     *BLANKS       MsgIdArr
     C                   MOVEL     *BLANKS       MsgDtaArr
     C                   MOVEL     *BLANKS       WFldNamArr
     C                   MOVEL     *BLANKS       WMsgIdArr
     C                   MOVEL     *BLANKS       WMsgDtaArr
 
      ** Read error messages for deal
 
     C     ZATRNKD0      SETLL     ZATRNERRD0
     C     ZATRNKD0      READE     ZATRNERRD0                             81
 
      ** Add error message to array passed to detail screen
      ** and set OK flag for field to 'N'
 
     C                   DOW       *IN81 = *OFF
     C                   IF        ABFIELDID > FldOffSetF
     C                   ADD       1             E
     C                   MOVEL     ABFIELDNAM    FldNameArr(E)
     C                   MOVEL     ABMSGID       MsgIdArr(E)
     C                   Z-ADD     ABFIELDID     F
     C                   SUB       FldOffsetF    F
     C                   IF        F < 1 OR F > 60
     C                   Z-ADD     1             F
     C                   ENDIF
     C                   EVAL      Arr_ErrFlag(F) = 'N'
     C                   ENDIF
     C     ZATRNKD0      READE     ZATRNERRD0                             81
     C                   ENDDO
 
     C                   MOVEA     Arr_ErrFlag   OKFEBO
     C                   EVAL      %SUBST(IRECACF:62:10) = OKFEBO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrScrnM - Main Detail Screen                                 *
      *****************************************************************
     C     SrScrnM       BEGSR
 
      ** Issue rollback to clear any possible updates in window function
 
     C                   IF        BGWDPR = 'Y'
                                                                                             BUG2603
     C     CSC022        IFEQ      'N'                                                       BUG2603
     C                   ROLBK
     C                   ELSE                                                                BUG2603
     C     WSkpCom       IFNE      'Y'                                                       BUG2603
     C                   ROLBK                                                               BUG2603
     C                   ELSE                                                                BUG2603
     C                   SETON                                        U7U8                   BUG2603
     C                   ENDIF                                                               BUG2603
     C                   ENDIF                                                               BUG2603
     C                   ENDIF
 
      ** Enable/disable detail fields on main details screen
      ** if changes to the data are allowed
      ** (key fields = action code & deal number; detail fields = rest)
      ** (Action code can only be 'I', 'A', 'D', or 'X')
 
     C                   IF        #0ACCD = 'I' AND POptSel = 'U' OR
     C                             #0ACCD = 'A' AND POptSel = 'U'
     C                   EVAL      PEDtFld = 'Y'
     C                   ELSE
     C                   EVAL      PEDtFld = 'N'
     C                   ENDIF
 
      ** KJ = Command Key 10 = Confirm Delete
 
     C                   IF        #0ACCD = 'R'
     C                   EVAL      PEINKJ = 'Y'
     C                   ELSE
     C                   EVAL      PEINKJ = 'N'
     C                   ENDIF
 
      ** Write/read display screen
 
     C                   CALLB     'IRCACF1DP'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    NwIRScnFmt
     C                   PARM                    CrIRFilFmt
     C                   PARM                    DDSTS
     C                   PARM                    IRECACF
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM      'N'           PEKYFD
     C                   PARM                    PEDtFld
     C                   PARM      'N'           PEINKG
     C                   PARM      'N'           PEINKH
     C                   PARM                    PEINKJ
     C                   PARM      'N'           PEINKN
     C                   PARM      'N'           PEINKP
     C                   PARM                    CIR006
     C                   PARM                    CEU003
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKG
     C                   PARM      '0'           PINKH
     C                   PARM      '0'           PINKJ
     C                   PARM      '0'           PINKL
     C                   PARM      '0'           PINKN
     C                   PARM      '0'           PINKP
     C                   PARM      'N'           WriteOnly
 
      ** Reset errors
 
     C                   EVAL      IRECACF = *ALL'Y'
     C                   MOVEA     *BLANKS       FldNameArr
     C                   MOVEA     *BLANKS       MsgIdArr
     C                   MOVEA     *BLANKS       MsgDtaArr
     C                   MOVEA     *BLANKS       WFldNamArr
     C                   MOVEA     *BLANKS       WMsgIdArr
     C                   MOVEA     *BLANKS       WMsgDtaArr
 
      ** If F3 pressed, end program
 
     C     PINKC         CASEQ     '1'           SrEndPgm
 
      ** If F12 pressed, cancel on Main details screen
 
     C     PINKL         CASEQ     '1'           SrCancM
 
      ** Otherwise, validate input to Main details screen
 
     C                   CAS                     SrValM
     C                   ENDCS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrValM - Validate Input to Main Details Screen               *
      *****************************************************************
     C     SrValM        BEGSR
 
      ** Retrieve deal details
 
     C                   EXSR      SrRtvDeal
 
      ** If action code or deal number are not ok,
      ** re-output screen with error messages on it
 
     C                   IF        OKACCD = 'N' OR OKDLNO = 'N'
     C                   GOTO      ESrValM
     C                   ENDIF
 
      ** If Delete, update deal in file format
 
     C                   IF        #0ACCD = 'R'
     C                   EVAL      NwIRFilFmt = CrIRFilFmt
 
      ** If F10 taken, go onto updates
 
     C                   IF        PINKJ = '1'
     C                   EVAL      WScrn = 'U'
     C                   ELSE
 
     C                   IF        CIR005 = 'Y' AND BsDayConv <> *BLANKS
     C                   EXSR      SrBsDyC
 
      ** F12 pressed, back to main screen
 
     C                   IF        WFntKey = '12'
     C                   EVAL      WScrn = 'M'
     C                   EVAL      WFntKey = *BLANKS
     C                   GOTO      ESrValM
     C                   ENDIF
 
      ** F3 pressed, end program
 
     C                   IF        WFntKey = '03'
     C                   EXSR      SrEndPgm
     C                   GOTO      ESrValM
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C                   GOTO      ESrValM
     C                   ENDIF
                                                                                              CIR008
      ** If Authorize                                                                         CIR008
                                                                                              CIR008
     C                   IF        CIR008 = 'Y' AND #0ACCD = 'X'                              CIR008
     C                   EXSR      SrPutDlM                                                   CIR008
                                                                                              CIR008
      ** Update Deal in File Format                                                           CIR008
                                                                                              CIR008
     C                   EVAL      NwIRFilFmt = CrIRFilFmt                                    CIR008
                                                                                              CIR008
      ** If windows processing on, call window routine                                        CIR008
      ** otherwise, continue to confirmation screen                                           CIR008
                                                                                              CIR008
     C                   IF        BGWDPR = 'Y' AND CIR006 = 'Y'                              CIR008
     C                   EVAL      WScrn = 'W'                                                CIR008
     C                   ELSE                                                                 CIR008
     C                   EVAL      WScrn = 'C'                                                CIR008
     C                   ENDIF                                                                CIR008
                                                                                              CIR008
     C                   IF        CIR005 = 'Y' AND BsDayConv <> *BLANKS                      CIR008
     C                   EXSR      SrBsDyC                                                    CIR008
                                                                                              CIR008
      ** F12 pressed, back to main screen                                                     CIR008
                                                                                              CIR008
     C                   IF        WFntKey = '12'                                             CIR008
     C                   EVAL      WScrn = 'M'                                                CIR008
     C                   EVAL      WFntKey = *BLANKS                                          CIR008
     C                   GOTO      ESrValM                                                    CIR008
     C                   ENDIF                                                                CIR008
                                                                                              CIR008
      ** F3 pressed, end program                                                              CIR008
                                                                                              CIR008
     C                   IF        WFntKey = '03'                                             CIR008
     C                   EXSR      SrEndPgm                                                   CIR008
     C                   GOTO      ESrValM                                                    CIR008
     C                   ENDIF                                                                CIR008
     C                   ENDIF                                                                CIR008
                                                                                              CIR008
     C                   GOTO      ESrValM                                                    CIR008
     C                   ENDIF                                                                CIR008
 
      ** If Insert or Amend, prior to validation initialize OK flags
      ** and clear deal in file format
 
     C                   IF        #0ACCD = 'I' OR #0ACCD = 'A'
     C                   EVAL      Idx = *ZERO
     C                   EVAL      WIdx = *ZERO
     C                   EVAL      IRECACF = *ALL'Y'
     C                   CLEAR                   NwIRFilFmt
     C                   EVAL      RPRSTM = *ZERO
     C**********         EVAL      RPROBN = *ZERO                                             CSD027
     C**********         EVAL      RPROCN = *ZERO                                             CSD027
     C                   EVAL      RPROBN = *BLANKS                                           CSD027
     C                   EVAL      RPROCN = *BLANKS                                           CSD027
     C                   EVAL      RPPSTM = *ZERO
     C**********         EVAL      RPPOBN = *ZERO                                             CSD027
     C**********         EVAL      RPPOCN = *ZERO                                             CSD027
     C                   EVAL      RPPOBN = *BLANKS                                           CSD027
     C                   EVAL      RPPOCN = *BLANKS                                           CSD027
 
      ** If first pass to the main screen and Business Day Conventions
      ** enhancement is switched on, skip validation of rate change
      ** dates and interest payment dates against the Business Day
      ** Convention currencies (WValBDC = 'N').
 
     C                   IF        CIR005 = 'Y' AND WFirstPass = 'Y'
     C                   EVAL      WValBDC = 'N'
     C                   ENDIF
 
      ** If Amend, update deal in file format
 
     C     #0ACCD        IFEQ      'A'
     C                   EVAL      NwIRFilFmt = CrIRFilFmt
 
      ** Validate whether non-amenable fields have been changed
 
     C                   CALLB     'IRCACFAMD'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    NwIRScnFmt
     C                   PARM                    CrIRScnFmt
     C                   PARM                    CrIRFilFmt
     C                   PARM      'Y'           PResetErrs
     C                   PARM                    BJRDNB
     C                   PARM                    BGPFMG
     C                   PARM                    BGMBIN                                       222373
     C                   PARM                    BKPRCU
     C                   PARM                    BKPRCA
     C                   PARM                    BKOBRU                                       222373
      ** Interest Rate Calendars                                                              222373
     C                   PARM                    CIR001                                       222373
      ** Amortisation of Caps, Collars, Floors and                                            222373
      ** Individual Compounding Swaps                                                         222373
     C                   PARM                    CIR006                                       222373
     C                   PARM                    IRECACF
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    PAmendsOK
 
     C                   ENDIF
 
      ** Validate deal details
 
     C                   CALLB     'IRCACFVAL'
     C                   PARM                    ModeOfOp
     C                   PARM                    RespMode
     C                   PARM                    CrIRScnFmt
     C                   PARM                    NwIRScnFmt
     C                   PARM      RPRSCY        RecSetCcy
     C                   PARM      RPRSTM        RecSetMeth
     C                   PARM      RPRONS        RecNostro
     C                   PARM      RPPSCY        PaySetCcy
     C                   PARM      RPPSTM        PaySetMeth
     C                   PARM      RPPONS        PayNostro
     C                   PARM                    ExtData
     C                   PARM                    WValBDC
     C                   PARM                    SDBANK
     C                   PARM                    SDMMOD
     C                   PARM                    SDDEAL
     C                   PARM                    SDGELR
     C                   PARM                    SDTRAD
     C                   PARM                    SDFAIS
     C                   PARM                    ZMUSER
     C                   PARM                    CIR001
     C                   PARM                    CIR005
     C                   PARM                    CIR006
     C                   PARM                    CIR007
     C                   PARM                    IRECACF
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    NwIRFilFmt
      ***Sign*of Short Term Rate                                                     BUG5707 BUG6472
     C**********         PARM                    #0SIGN                              BUG5707 BUG6472
 
      ** If errors returned
 
     C                   IF        Idx <> *ZERO
     C                   GOTO      ESrValM
     C                   ENDIF
 
      ** If no error on validation, display BDC input screen
 
     C                   IF        CIR005 = 'Y' AND WFirstPass = 'Y'
 
      ** Save previous Business Day Convention input
 
     C                   IF        BsDayConv <> *BLANKS
     C                   MOVEL     BsDayConv     WSavBDC
     C                   ENDIF
 
      ** If no changes are allowed, protect (but still validate)
      ** all business day convetion fields by passing an 'E' to action code
 
     C                   IF        POptSel = 'N'
     C                   EVAL      W_Accd = #0ACCD
     C                   EVAL      #0ACCD = 'E'
     C                   ENDIF
 
      ** First pass, display BDC input screen
 
     C                   EXSR      SrBsDyC
 
      ** Put back original action code when no changes are allowed
 
     C                   IF        POptSel = 'N'
     C                   EVAL      #0ACCD = W_Accd
     C                   ENDIF
 
     C                   IF        WFntKey = *BLANKS AND WSndScn2 = 'N'
     C                   EVAL      WSndScn2 = 'Y'
     C                   ENDIF
 
      ** If F12 pressed, back to main screen. Put back BDC details
      ** only when the previous detail workfield is not blank
 
     C                   IF        WFntKey = '12'
     C                   EVAL      WScrn = 'M'
     C                   IF        WSavBDC <> *BLANKS
     C                   EVAL      BsDayConv = WSavBDC
     C                   ELSE
     C                   EVAL      BsDayConv = *BLANKS
     C                   ENDIF
     C                   EVAL      WFntKey = *BLANKS
     C                   GOTO      ESrValM
     C                   ENDIF
 
      ** If F3 pressed, end program
 
     C                   IF        WFntKey = '03'
     C                   EXSR      SrEndPgm
     C                   GOTO      ESrValM
     C                   ENDIF
 
      ** If no error found on call to Business Day Convention
 
     C                   IF        WValBDC = 'N' AND WFirstPass = 'Y'
     C                   EVAL      WValBDC = 'Y'
     C                   EVAL      WFirstPass = 'N'
     C                   EVAL      WScrn = 'M'
     C                   GOTO      ESrValM
     C                   ENDIF
 
     C                   GOTO      ESrValM
     C                   ENDIF
 
      ** If CAP041 is installed, call Fees and Buy-out processing
      ** Else, if windows processing is on, call window routine
      ** Else, continue to settlements screen
 
     C                   IF        CAP041 = 'Y'
     C                             AND CIR006 = 'Y'                                         AR218555
     C                   EVAL      WScrn = 'F'
     C                   ELSE
     C                   IF        BGWDPR = 'Y' AND CIR006 = 'Y'
     C                   EVAL      WScrn = 'W'
     C                   ELSE
     C                   IF        CIR001 = 'Y'
     C                   EVAL      RPOUSI = *ZERO
     C                   EVAL      RPOUSA = *ZERO
     C                   EVAL      RPTUSI = *ZERO
     C                   EVAL      RPTUSA = *ZERO
     C                   ENDIF
     C                   EVAL      WScrn = 'S'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C     ESrValM       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrBsDyC - Business Day Convention Processing                 *
      *****************************************************************
     C     SrBsDyC       BEGSR
 
     C                   EVAL      POkFlags = *ALL'Y'
     C                   EVAL      IRECACF = *ALL'Y'
     C                   EVAL      FldNameArr2 = *BLANKS
     C                   EVAL      MsgIdArr2 = *BLANKS
     C                   EVAL      WFldNamArr2 = *BLANKS
     C                   EVAL      WMsgIDArr2 = *BLANKS
     C                   EVAL      WSavRC = *BLANKS
 
      ** Send error messages to second screen
 
     C                   IF        CIR005 = 'Y' AND WSndScn2 = 'N'
     C                   EXSR      SrSndmB
     C                   ENDIF
 
      ** Do until F3 or F12 is pressed or all screen fields are valid
 
     C                   DOU       MsgIdArr2(1) = *BLANKS AND
     C                             WarnFlag = 'N'  OR WFntKey = '03' OR
     C                             WFntKey = '12'
     C                   EVAL      WarnFlag = 'N'
 
      ** Display Business Day Convention fields
      *
      ** Use extended fields due to change in layout in PF/IRSBDYPD                           CIR017
      *                                                                                       CIR017
     C                   EVAL      BsDayConv2 = BsDayConv                                     CIR017
     C                   EVAL      POkFlagExt = POKFlags                                      CIR017
      *                                                                                       CIR017
     C                   CALLB     'IRSBDYDSP'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    #0ACCD
     C                   PARM                    #0DLNO
     C**********         PARM                    POkFlags                                     CIR017
     C                   PARM                    POkFlagExt                                   CIR017
     C                   PARM                    MsgIdArr2
     C                   PARM                    WMsgIdArr2
     C                   PARM                    BJMRDT
     C**********         PARM                    BsDayConv                                    CIR017
     C                   PARM                    BsDayConv2                                   CIR017
     C                   PARM      *BLANKS       WFntKey
 
     C                   IF        RetCodeOut <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'IRCBDYDSP'
     C                   EVAL      DBASE = 001
     C                   EVAL      DBKEY = #0DLNO
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Validate all screen fields when action code is I or A.
 
     C                   IF        WFntKey <> '03' AND WFntKey <> '12'
     C                             AND #0ACCD = 'I' OR
     C                             WFntKey <> '03' AND WFntKey <> '12'
     C                             AND #0ACCD = 'A'  OR
     C                             WFntKey <> '03' AND WFntKey <> '12'
     C                             AND POptSel = 'N' AND #0ACCD = 'E'
 
     C                   MOVEL     POKFlags      POKFlags2
                                                                                              CIR017
      ** Reset original values for subsequent processing                                      CIR017
     C                   EVAL      BsDayConv  = BsDayConv2                                    CIR017
     C                   EVAL      POkFlags   = POKFlagExt                                    CIR017
 
      ** Use extended fields due to change in layout in PF/IRSBDYPD                           CIR017
     C                   EVAL      BsDayConv2 = BsDayConv                                     CIR017
     C                   EVAL      POkFlagExt = POKFlags2                                     CIR017
 
     C                   CALLB     'IRSBDYVAL'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    #0ACCD
     C                   PARM                    PLCcy
     C**********         PARM                    POkFlags2                                    CIR017
     C                   PARM                    POkFlagExt                                   CIR017
     C                   PARM      *BLANKS       MsgIdArr2
     C                   PARM                    FldNameArr2
     C                   PARM      *BLANKS       WMsgIdArr2
     C                   PARM                    WFldNamArr2
     C**********         PARM                    BsDayConv                                    CIR017
     C                   PARM                    BsDayConv2                                   CIR017
 
     C                   MOVEL     POKFlags2     POKFlags
      *                                                                                       CIR017
      ** Reset original values for subsequent processing                                      CIR017
      *                                                                                       CIR017
     C                   EVAL      BsDayConv  = BsDayConv2                                    CIR017
     C                   EVAL      POkFlags2  = POKFlagExt                                    CIR017
 
     C                   IF        RetCodeOut <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'IRCBDYDSP'
     C                   EVAL      DBASE = 002
     C                   EVAL      DBKEY = #0DLNO
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        WMsgIdArr2(1) <> *BLANKS AND
     C                             WSavRC <> RtFxConv
     C                   EVAL      WarnFlag = 'Y'
     C                   ENDIF
 
     C                   EVAL      WSavRC = RtFxConv
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrFBProc - Fees and Buy-outs Processing                      *
      *****************************************************************
     C     SrFBProc      BEGSR
 
      ** Disable detail fields if action is 'I' or 'A' and option
      ** is not 'U'
 
     C                   IF        POptSel = 'U' AND
     C                             (#0ACCD = 'A' OR #0ACCD = 'I')
     C                   EVAL      PEDtFld = 'Y'
     C                   ELSE
     C                   EVAL      PEDtFld = 'N'
     C                   ENDIF
 
      ** Send error messages to Fees and Buy-outs screen
 
     C                   IF        WRsnd <> 'Y'
     C                   EXSR      SrSndmF
     C                   ENDIF
 
      ** Convert Fees and Buy-out screen
 
     C                   EXSR      SrFBConv
 
      ** Display Fees/Buy-Outs screen fields
 
     C                   CALLB     'IRFEBODSP'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    NwFBScnFmt
     C                   PARM                    NwFBScnFld
     C                   PARM                    OKFEBO
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    PEDtFld
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKH
     C                   PARM      '0'           PINKL
     C                   PARM                    DATA
 
     C                   MOVEA     WMsgIDArr     WPrvWarnAr
 
      ** Reset error fields
 
     C                   EVAL      Idx = *ZERO
     C                   EVAL      WIdx = *ZERO
     C                   EVAL      OKFEBO = *ALL'Y'
     C                   EVAL      FldNameArr = *BLANKS
     C                   EVAL      MsgIdArr = *BLANKS
     C                   EVAL      MsgDtaArr = *BLANKS
     C                   EVAL      WFldNamArr = *BLANKS
     C                   EVAL      WMsgIdArr = *BLANKS
     C                   EVAL      WMsgDtaArr = *BLANKS
 
     C                   SELECT
 
      ** F3 - End program
 
     C                   WHEN      PINKC = *ON
     C                   EXSR      SrEndPgm
 
      ** F12 - Cancel
 
     C                   WHEN      PINKL = *ON
     C**********         IF        CIR001 = 'Y'                                               209372
     C**********         EVAL      WScrn = 'X'                                                209372
     C**********         ELSE                                                                 209372
     C                   EVAL      WScrn = 'M'
     C**********         ENDIF                                                                209372
 
     C                   OTHER
 
      ** Validate if action is Insert or Amend
 
     C                   IF        POptSel = 'U' AND
     C                             (#0ACCD = 'A' OR #0ACCD = 'I')
     C                   EXSR      SrValF
     C                   GOTO      ESrSndmF
     C                   ENDIF
 
      ** Go to window processing if window flag is 'Y'
 
     C                   IF        BGWDPR = 'Y' AND CIR006 = 'Y'
     C                   EVAL      WScrn = 'W'
     C                   GOTO      ESrSndmF
     C                   ENDIF
 
      ** Go to extended settlement screen if not enquiry
 
     C                   IF        #0ACCD <> 'E'
     C                   EXSR      SrFileFlds
     C                   EVAL      WScrn = 'S'
     C                   GOTO      ESrSndmF
     C                   ENDIF
 
      ** If records are still to be read from the subfile read them
      ** Else return to browse screen
 
     C                   IF        WRdNB = 'Y'
     C                   EVAL      WScrn = 'R'
     C                   ELSE
     C                   EVAL      WScrn = 'B'
     C                   ENDIF
 
     C                   ENDSL
 
     C     ESrSndmF      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrFBConv - Convert Fees and Buy-out Screen                   *
      *****************************************************************
     C     SrFBConv      BEGSR
 
     C**********         IF        CAP041 <> 'Y'                                              209372
     C/COPY QWINDSRC,IRCACFMOV1
     C**********         ENDIF                                                                209372
 
      ** Set up Our/Their number of decimal places
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      #1UCUC        PCcy
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   EVAL      PWUCDP = A6NBDP
 
     C                   IF        #1TCUC <> *BLANKS
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      #1TCUC        PCcy
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   EVAL      PWTCDP = A6NBDP
     C                   ELSE
     C                   EVAL      PWTCDP = A6NBDP
     C                   ENDIF
 
      ** Set up Settlement & Receivers currency
 
     C                   IF        CEU003 = 'Y' AND #1PSCY <> *BLANKS
     C                   MOVEL     #1PSCY        PWPSCY
     C                   ELSE
     C                   MOVEL     #1UCUC        PWPSCY
     C                   ENDIF
 
     C                   IF        CEU003 = 'Y' AND #1RSCY <> *BLANKS
     C                   MOVEL     #1RSCY        PWRSCY
     C                   ELSE
     C                   MOVEL     #1TCUC        PWRSCY
     C                   ENDIF
 
      ** Access nostro location for our-effective-settlement-currency
 
     C                   IF        PWPSCY <> *BLANKS
 
     C                   CALL      'AONOSTR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      *BLANK        PCust
     C                   PARM      PWPSCY        PCcy
     C                   PARM      *BLANKS       PAccd
     C                   PARM      *BLANKS       PAcsn
     C                   PARM      #1UNON        PNost
     C                   PARM      *BLANKS       PBrcd
     C                   PARM      *BLANKS       PCssn
     C                   PARM      *BLANKS       Pinoy
     C     SDNOST        PARM      SDNOST        DSFDY
 
     C                   IF        PRtcd = *BLANKS
     C                   MOVE      A7NOSN        PWPNLOC
     C                   ELSE
     C                   MOVE      *BLANKS       PWPNLOC
     C                   ENDIF
 
     C                   ENDIF
 
      ** Access nostro location for their-effective-settlement-currency
 
     C                   IF        PWRSCY <> *BLANKS
 
     C                   CALL      'AONOSTR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      *BLANK        PCust
     C                   PARM      PWRSCY        PCcy
     C                   PARM      *BLANKS       PAccd
     C                   PARM      *BLANKS       PAcsn
     C                   PARM      #1TNON        PNost
     C                   PARM      *BLANKS       PBrcd
     C                   PARM      *BLANKS       PCssn
     C                   PARM      *BLANKS       Pinoy
     C     SDNOST        PARM      SDNOST        DSFDY
 
     C                   IF        PRtcd = *BLANKS
     C                   MOVE      A7NOSN        PWRNLOC
     C                   ELSE
     C                   MOVE      A7NOSN        PWRNLOC
     C                   ENDIF
 
     C                   ENDIF
 
      ** Set up other fields
 
     C                   EVAL      SFSDLNO  = #0DLNO
     C                   EVAL      SFSACTN  = #0ACCD
     C                   EVAL      SFSDTYP  = #0DTYP
     C                   EVAL      SFSDLST  = #0DLST
     C                   EVAL      SFSDDAT  = #0DDAT
     C                   EVAL      SFSBRCA  = #0BRCA
     C                   EVAL      SFSBRKC  = #0BRKC
     C                   EVAL      SFSBAGE  = #0BAGE
     C                   EVAL      SFSLNKDN = #0LNKD
     C                   EVAL      SFSCNUM  = #0CNUM
     C                   EVAL      SFSVDAT  = #0VDAT
     C                   EVAL      SFSMDAT  = #0MDAT
     C                   EVAL      SFSCDAS  = #0CDAS
     C                   EVAL      SFSUCUCY = #0CUCY
     C                   EVAL      SFSUPAMT = #0PAMT
     C                   EVAL      SFSUICF  = #0ICFR
     C                   EVAL      SFSTICF  = #0ICFR
     C                   EVAL      SFSOREDM = ORED
     C                   MOVEL     TUSI          SFSTUSI
     C                   MOVEL     TUSA          SFSTUSA
     C                   MOVEL     OUSI          SFSOUSI
     C                   MOVEL     OUSA          SFSOUSA
 
     C                   EVAL      SFSOIPM  = #0OIPM
     C                   EVAL      SFSONPCD = #0ONPCD
     C                   EVAL      SFSTIPM  = #0TIPM
     C                   EVAL      SFSTNPCD = #0TNPCD
     C                   EVAL      SFSUFVD  = #0UFVD
     C                   EVAL      SFSUFEE  = #0UFEE
     C                   EVAL      SFSUFPR  = #0UFPR
     C                   EVAL      SFSBOVD  = #0BOVD
     C                   EVAL      SFSBUYA  = #0BUYA
     C                   EVAL      SFSBOPR  = #0BOPR
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrValF - Validate Fees and Buy-out Details                   *
      *****************************************************************
     C     SrValF        BEGSR
 
      ** Check for amendable fields
 
     C                   CALLB     'IRSFBOAMD'
     C                   PARM                    RetCodeOut
     C                   PARM                    NwFBScnFmt
     C                   PARM                    CrFBScnFmt
     C                   PARM                    DATA
     C                   PARM      'N'           PResetFld
     C                   PARM                    PWUCDP
     C                   PARM                    PWTCDP
     C                   PARM                    BJRDNB
     C                   PARM                    CIR007
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    OKFEBO
     C                   PARM                    PAmendOk
     C                   PARM                    BNDCSP                                       245692
 
     C                   CALLB     'IRSFBOVAL'
     C                   PARM                    RespMode
     C                   PARM                    NwFBScnFmt
     C                   PARM                    vDLNO                                        233467
     C                   PARM                    PWUCDP
     C                   PARM                    PWTCDP
     C                   PARM                    PWPSCY
     C                   PARM                    PWRSCY
     C                   PARM                    PWPNLOC
     C                   PARM                    PWRNLOC
     C                   PARM                    OKFEBO
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    DATA
     C                   PARM                    BNDCSP                                       245692
 
      ** If no errors occurred during validation of fields
      ** check if there are warnings which have not been
      ** displayed yet
 
     C                   EVAL      WRedisplay = *BLANKS
     C                   IF        IdX = 0
     C                   Z-ADD     1             WiX
     C                   DOW       WiX <= WIdX AND WRedisplay = *BLANK
     C                   IF        WMsgIdArr(WiX) <> WPrvWarnAr(WiX)
     C                   EVAL      WRedisplay = 'Y'
     C                   ELSE
     C                   EVAL      WiX = WiX + 1
     C                   ENDIF
     C                   ENDDO
 
      ** Reset errors
 
     C                   IF        WRedisplay <> 'Y'
     C                   Z-ADD     0             Idx
     C                   Z-ADD     0             WIdx
     C                   MOVE      *ALL'Y'       OKFEBO
     C                   MOVEA     *BLANKS       FldNameArr
     C                   MOVEA     *BLANKS       MsgIdArr
     C                   MOVEA     *BLANKS       MsgDtaArr
     C                   MOVEA     *BLANKS       WFldNamArr
     C                   MOVEA     *BLANKS       WMsgIdArr
     C                   MOVEA     *BLANKS       WMsgDtaArr
     C                   ENDIF
 
     C                   ENDIF
 
      ** Redisplay Level 1 screen if there are errors or if there
      ** are warnings which have not been displayed yet
 
     C                   IF        IdX <> 0 OR WRedisplay = 'Y'
     C                   GOTO      ESrValF
     C                   ENDIF
 
      ** Process principal rate change schedules if no errors
 
     C                   IF        SFSONPCD <> *BLANKS
     C                   IF        OKONPCD = 'Y'                                              CAP043
     C                   EXSR      SRSetupPCSC                                                CAP043
     C                   ENDIF                                                                CAP043
     C                   EXSR      SrPrinSked
 
      ** F3 - Terminate program
 
     C                   IF        PRtCd = 'Y2U9999'
     C                   EXSR      SrEndPgm
     C                   GOTO      ESRValF
     C                   ENDIF
 
      ** F12 or there are outstanding errors, redisplay screen
 
     C                   IF        PRtCd = 'USR0790' OR
     C                             OKONPCD = 'N'
     C                   GOTO      ESRValF
     C                   ENDIF
 
     C                   ENDIF
 
      ** If no errors, set file fields
 
     C                   EXSR      SrFileFlds
     C                   IF        BGWDPR = 'Y' AND CIR006 = 'Y'
     C                   EVAL      WScrn = 'W'
     C                   ELSE
     C                   EVAL      WScrn = 'S'
     C                   ENDIF
 
     C     ESrValF       ENDSR
      *****************************************************************                       CAP043
      /EJECT                                                                                  CAP043
      *****************************************************************                       CAP043
      *  SrSetupPCSC - Setup Principal Change Schedules               *                       CAP043
      *****************************************************************                       CAP043
     C     SrSetupPCSC   BEGSR                                                                CAP043
                                                                                              CAP043
      ** If deal number not defined (on insert), get the next available                       CAP043
                                                                                              CAP043
     C                   IF        #0DLNO = *BLANKS                                           CAP043
     C                   CALLB     'CAGETNXTDL'                                               CAP043
     C                   PARM      *BLANKS       RetCodeOut                                   CAP043
     C                   PARM      *BLANKS       MsgID1                                       CAP043
     C                   PARM                    PGNDlno                                      CAP043
     C                   PARM      *ZERO         RPDLNO                                       CAP043
     C                   IF        MsgID1 <> *BLANKS                                          CAP043
     C     *LOCK         IN        LDA                                                        CAP043
     C                   EVAL      DBFILE = 'CAGTNXDL'                                        CAP043
     C                   EVAL      DBASE = 024                                                CAP043
     C                   EVAL      DBKEY = #0DLNO                                             CAP043
     C                   OUT       LDA                                                        CAP043
     C                   EXSR      *PSSR                                                      CAP043
     C                   ENDIF                                                                CAP043
     C                   EVAL      #0DLNO = PGNDlno                                           CAP043
     C                   MOVE      #0DLNO        #1DLNO                                       CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
      ** Do until all corresponding records from IRIPCSCPD have been processed                CAP043
                                                                                              CAP043
     C                   IF        CAP043 = 'Y'                                               CAP043
     C                   IF        CAP041 = 'Y'                                               CAP043
     C     ZATRNKD0      SETLL     IRIPCSCL0                                                  CAP043
     C     ZATRNKD0      READE     IRIPCSCL0                                                  CAP043
                                                                                              CAP043
      ** Initialise previous date parameter field                                             CAP043
                                                                                              CAP043
     C                   EVAL      PPrevDate = *ZERO                                          CAP043
     C                   EVAL      PUpdate = 'N'                                              CAP043
     C                   EVAL      PErrorFndPr = 'NN'                                         CAP043
                                                                                              CAP043
     C                   DOW       NOT %EOF(IRIPCSCL0)                                        CAP043
                                                                                              CAP043
      ** Set currency parameter and business day convention fields according to               CAP043
      ** our/their indicator                                                                  CAP043
                                                                                              CAP043
     C                   EVAL      PCurrency = #0CUCY                                         CAP043
     C                   EVAL      PBDConvtn = BsDayConP                                      CAP043
     C                   EVAL      PCtlDate = RPUNPCD                                         CAP043
     C                   EVAL      PPAmt = RPUPAMT                                            CAP043
                                                                                              CAP043
     C                   EXSR      SRIPCSC                                                    CAP043
                                                                                              CAP043
     C                   EVAL      WOurThr = PITOURTHR                                        CAP043
                                                                                              CAP043
     C     ZATRNKD0      READE     IRIPCSCL0                                                  CAP043
                                                                                              CAP043
      ** Initialise PPrevDate when key fields change                                          CAP043
                                                                                              CAP043
     C                   IF        NOT %EOF(IRIPCSCL0)                                        CAP043
     C                   IF        WOurThr <> PITOURTHR                                       CAP043
     C                   EVAL      PPrevDate = *ZERO                                          CAP043
     C                   ENDIF                                                                CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
      ** If *EOF or an error occurred upon call to IRIPCSCRT set update                       CAP043
      ** indicator to 'Y'                                                                     CAP043
                                                                                              CAP043
     C                   IF        %EOF(IRIPCSCL0)                                            CAP043
     C                   EVAL      PUpdate = 'Y'                                              CAP043
     C                   EXSR      SRIPCSC                                                    CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C                   ENDDO                                                                CAP043
     C                   ENDIF                                                                CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C                   ENDSR                                                                CAP043
                                                                                              CAP043
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrPrinSked - Validate Principal Change Schedules             *
      *****************************************************************
     C     SrPrinSked    BEGSR
 
     C                   CALLB     'IRSPCDSHD'
     C                   PARM                    PRtCd
     C                   PARM                    NwFBScnFmt
     C                   PARM                    PWPSCY
     C                   PARM                    PWUCDP
     C                   PARM                    BJDFIN
     C                   PARM                    CIR006
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    OKFEBO
     C                   PARM                    DATA
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrFileFlds - Set up Set up Up-front Fee Details File Fields  *
      *****************************************************************
     C     SrFileFlds    BEGSR
 
      ** If any of the Up-front fee details have been
      ** amended, set Confirmation Required indicator to Y
      ** otherwise, set to N.
 
     C                   IF        #1UPVD <> RPUPVD OR
     C                             #1UPFE <> RPUPFE OR
     C                             #1UPPR <> RPUPPR
     C                   EVAL      #1CNRQ = 'Y'
     C                   EXSR      SrUpdUpF
     C                   ELSE
     C                   EVAL      #1CNRQ = 'N'
     C                   ENDIF
 
     C                   EVAL      #0OIPM  = SFSOIPM
     C                   EVAL      #0ONPCD = SFSONPCD
     C                   EVAL      #0TIPM  = SFSTIPM
     C                   EVAL      #0TNPCD = SFSTNPCD
     C                   EVAL      #0UFVD  = SFSUFVD
     C                   EVAL      #0UFEE  = SFSUFEE
     C                   EVAL      #0UFPR  = SFSUFPR
     C                   EVAL      #0BOVD  = SFSBOVD
     C                   EVAL      #0BUYA  = SFSBUYA
     C                   EVAL      #0BOPR  = SFSBOPR
 
     C/COPY QWINDSRC,IRCACFMOV2
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrUpdUpF -  Write into PF/DLDGUPFE old values of up-front    *
      *              value date, fee and P/R indicator                *
      *****************************************************************
     C     SrUpdUpF      BEGSR
 
     C     #1ACTN        IFEQ      'A'
     C                   MOVE      #1DLNO        WDlno
     C     WDlno         CHAIN     DLDGUPL1                           80
 
     C                   IF        *IN80 = *ON
     C                   MOVE      WDlno         DLNO
     C**********         MOVE      #1UPVD        UPVD                                         185064
     C**********         MOVE      #1UPFE        UPFE                                         185064
     C**********         MOVE      #1UPPR        UPPR                                         185064
     C                   MOVE      RPUPVD        UPVD                                         185064
     C                   MOVE      RPUPFE        UPFE                                         185064
     C                   MOVE      RPUPPR        UPPR                                         185064
     C                   WRITE     DLDGREFF
     C                   ELSE
     C**********         MOVE      #1UPFE        UPFE                                         185064
     C**********         MOVE      #1UPVD        UPVD                                         185064
     C**********         MOVE      #1UPPR        UPPR                                         185064
     C                   MOVE      RPUPVD        UPVD                                         185064
     C                   MOVE      RPUPFE        UPFE                                         185064
     C                   MOVE      RPUPPR        UPPR                                         185064
     C                   UPDATE    DLDGREF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrWindow - Call Window Manager                               *
      *****************************************************************
     C     SrWindow      BEGSR
 
      ** Reset errors
 
     C                   EVAL      IRECACF = *ALL'Y'
     C                   MOVEA     *BLANKS       FldNameArr
     C                   MOVEA     *BLANKS       MsgIdArr
     C                   MOVEA     *BLANKS       MsgDtaArr
     C                   MOVEA     *BLANKS       WFldNamArr
     C                   MOVEA     *BLANKS       WMsgIdArr
     C                   MOVEA     *BLANKS       WMsgDtaArr
 
      ** Write out screen to remove error messages
 
     C                   CALLB     'IRCACF1DP'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    NwIRScnFmt
     C                   PARM                    CrIRFilFmt
     C                   PARM                    DDSTS
     C                   PARM                    IRECACF
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    PEKYFD
     C                   PARM                    PEDtFld
     C                   PARM                    PEINKG
     C                   PARM                    PEINKH
     C                   PARM                    PEINKJ
     C                   PARM                    PEINKN
     C                   PARM                    PEINKP
     C                   PARM                    CIR006
     C                   PARM                    CEU003
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKG
     C                   PARM      '0'           PINKH
     C                   PARM      '0'           PINKJ
     C                   PARM      '0'           PINKL
     C                   PARM      '0'           PINKN
     C                   PARM      '0'           PINKP
     C                   PARM      'Y'           WriteOnly
 
      ** If deal number not defined (on insert), get the next available
 
     C                   IF        #0DLNO = *BLANKS
     C                   CALLB     'CAGETNXTDL'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM      *BLANKS       MsgID1
     C                   PARM                    PGNDlno
     C                   PARM      *ZERO         RPDLNO
     C                   IF        MsgID1 <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'CAGTNXDL'
     C                   EVAL      DBASE = 003
     C                   EVAL      DBKEY = #0DLNO
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   EVAL      #0DLNO = PGNDlno
     C                   ENDIF
 
      ** If CAP041 is switched on, set window program to 'IRCACFRPX'
      ** This will bypass the calling of DL1600WC attached to
      ** 'IRCACFRPR' in SDMREFPD window file.
 
     C                   IF        CAP041 = 'Y'
     C                   MOVEL     'IRCACFRPX'   PPgm
     C                   ELSE
     C                   MOVEL     'IRCACFRPR'   PPgm
     C/COPY QWINDSRC,IRCACFMOV1
     C                   ENDIF
 
     C                   CALL      'WN0010'
     C**********         PARM      'IRCACFRPR'   PPgm                                         CIR008
     C                   PARM                    PPgm                                         CIR008
     C                   PARM                    PFKey
     C                   PARM      #0ACCD        PAction
     C                   PARM                    DATA
     C                   PARM      *BLANKS       PRtCd
     C                   PARM                    WSpareW
 
      ** Process returned command keys
 
     C                   IF        PRtCd = 'Y2U9999'
     C                   EXSR      SrEndPgm
     C                   ELSE
 
      ** If Cmd12 pressed, go to Main screen
 
     C                   IF        PRtCd = 'USR0790'
 
     C                   EVAL      WScrn = 'M'
     C                   IF        CIR005 = 'Y'
     C                   EVAL      WFirstPass = 'Y'
     C                   ENDIF
 
     C                   ELSE
 
      ** Else if Cmd12 not pressed;
      **   If Enquiry mode, go to Main screen or Read next browse record
      **   Otherwise, go to Settlements screen
 
     C                   IF        #0accd = 'E'
 
     C                   IF        WRdNB = 'Y'
     C                   EVAL      WScrn = 'R'
     C                   ELSE
     C                   EVAL      WScrn = 'M'
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        CAP041 <> 'Y'
     C/COPY QWINDSRC,IRCACFMOV2
     C                   ENDIF
 
     C                   EVAL      WScrn = 'S'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C     ESrWindow     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrRtvDeal - Retrieve a Deal from the Database                *
      *****************************************************************
     C     SrRtvDeal     BEGSR
 
     C                   CALLB     'IRCACFRTV'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    ModeOfOp
     C                   PARM                    RespMode
     C                   PARM                    #0ACCD
     C                   PARM                    FOTRID
     C                   PARM                    FOASID
     C                   PARM                    #0DLNO
     C                   PARM                    #0LNKD
     C                   PARM                    #0BRCA
     C                   PARM                    #0DTYP
     C                   PARM                    BJSBRC
     C                   PARM                    DBRN
     C                   PARM                    BKOBUV
     C                   PARM                    BQFIAU                                       CIR008
     C                   PARM                    BQFIRA                                       CIR008
     C                   PARM                    CIR008                                       CIR008
     C                   PARM                    CrIRFilFmt
     C                   PARM      *BLANKS       OKACCD
     C                   PARM      *BLANKS       OKDLNO
     C                   PARM      *BLANKS       OKBRCA
     C                   PARM      *BLANKS       OKDTYP
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM      *ZERO         Idx
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrPutDlM - Put a Deal on the Main Details Screen             *
      *****************************************************************
     C     SrPutDlM      BEGSR
 
     C                   CALLB     'IRCACFCVT'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM      #0ACCD        PActCode
     C                   PARM                    CrIRFilFmt
     C                   PARM                    CIR005
     C                   PARM                    CIR006
     C                   PARM                    CIR008                                       CIR008
     C                   PARM                    BJDFIN
     C                   PARM                    BGPFMG
     C                   PARM                    BNDCSP
     C                   PARM                    NwIRScnFmt
     C                   PARM                    DDSTS
      ** Sign of Short Term Rate                                                             BUG5707
     C                   PARM                    #0SIGN                                      BUG5707
 
      ** Update Current deal with deal in Screen format
 
     C                   EVAL      CrIrScnFmt = NwIRScnFmt
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrCancM - Cancel on Main Details Screen                      *
      *****************************************************************
     C     SrCancM       BEGSR
 
      ** If records are still to be read from the subfile, read them
      ** Else, return to the Browse screen
 
     C                   IF        WRdNB = 'Y'
     C                   EVAL      WScrn = 'R'
     C                   ELSE
     C                   EVAL      WScrn = 'B'
     C                   ENDIF
 
     C                   IF        CIR005 = 'Y'
     C                   EVAL      WFirstPass = 'Y'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrScrnS - Settlement Details Evoked for Inserts, Amends,     *
      *            Enquiries & Authorisations                         *
      *****************************************************************
     C     SrScrnS       BEGSR
 
      ** If first time for Actn, Dlno, Ccy, Cust or Fefi Repaired,
      ** determine parameters for Settlement details input
 
     C                   IF        #0ACCD <> PActCode OR
     C                             #0DLNO <> PDealNo OR
     C                             #0CUCY <> PPayCcy OR
     C                             #0CNUM <> PCustSName OR
     C                             #0FEFI <> PFedFund
     C                   EXSR      SrParmS
     C                   ENDIF
 
      ** If no changes are allowed, protect (but still validate)
      ** all instructions by passing action code 'X' to ZASETINSIN
 
     C                   IF        POptSel = 'N'
     C                   EVAL      PActCode = 'X'
     C                   ELSE
     C                   EVAL      PActCode = #0ACCD
     C                   ENDIF
 
      ** Settlement instructions input
 
     C                   CALLB     'ZASETINSIN'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    PActCode
     C                   PARM      #0DLNO        PDealNo
     C                   PARM                    PProtectPay
     C                   PARM                    PProtectRec
     C                   PARM      'CACF'        PCallgPgm
     C                   PARM      #0CUCY        PPayCcy
     C                   PARM      #0CUCY        PRcvCcy
     C                   PARM      #0CNUM        PCustSName
     C                   PARM      #0DTYP        PTransTyp
     C                   PARM      #0FEFI        PFedFund
     C                   PARM      #0BRCA        PBranch
     C                   PARM                    PRcptDt
     C                   PARM                    PPymtDt
     C                   PARM                    ##PAYS
     C                   PARM                    ##RECS
     C                   PARM                    ##RSIS
     C                   PARM                    ##PAYF
     C                   PARM                    ##RECF
     C                   PARM                    ##RSIF
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKK                                      MD036070
     C                   PARM      '0'           PINKL
 
      ** If F3 pressed, end program
 
     C     PINKC         CASEQ     '1'           SrEndPgm
 
      ** If F12 pressed, cancel on Settlement details
 
     C     PINKK         CASEQ     '1'           SrCancS                                    MD036070
     C     PINKL         CASEQ     '1'           SrCancS
 
      ** Otherwise, exit from Settlement details
 
     C                   CAS                     SrExitS
     C                   ENDCS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrParmS - Determine Parameters for Settlement Details Screen *
      *****************************************************************
     C     SrParmS       BEGSR
 
      ** Set pay/receive protection indicators and dates
 
     C                   EVAL      PProtectPay = 'N'
     C                   EVAL      PProtectRec = 'N'
     C                   EVAL      PPymtDt = BJRDNB
     C                   EVAL      PRcptDt = BJRDNB
 
      ** If payment or receipt instructions already present (on Invalid
      ** deal settlement instructions file) then bypass defaulting
 
     C                   IF        ##PAYS <> *BLANKS OR
     C                             ##RECS <> *BLANKS
     C                             OR CIR008 = 'Y' AND #0ACCD = 'X'                           CIR008
     C                   GOTO      ESrParmS
     C                   ENDIF
 
      ** Setup payment instructions from Deal
      ** (on Insertions, these fields are zero/blank)
 
     C**********         MOVEL     NwPaySSI      FlPayIns                                     CGL029
     C                   EVAL      %SUBST(FlPayIns:1:2) = %SUBST(NwPaySSI:1:2)                CGL029
     C                   EVAL      %SUBST(FlPayIns:3:18) = RPPONS                             CGL029
     C                   EVAL      %SUBST(FlPayIns:21:544) =                                  CGL029
     C                                     %SUBST(NwPaySSI:15:544)                            CGL029
     C                   EVAL      FLPOBR = RPPOBR
     C                   EVAL      FLCVMR = RPCVMR
     C                   EVAL      FLPSCY = RPPSCY
     C                   EVAL      FLIC72 = RPIC72
 
      ** Setup receive instructions from Deal
      ** (on Insertions, these fields are zero/blank)
 
     C**********         MOVEL     NwRcvSSI      FlRcvIns                                     CGL029
     C                   EVAL      %SUBST(FlRcvIns:1:2) = %SUBST(NwRcvSSI:1:2)                CGL029
     C                   EVAL      %SUBST(FlRcvIns:21:54) =                                   CGL029
     C                                     %SUBST(NwRcvSSI:15:54)                             CGL029
     C                   EVAL      FLRONS = RPRONS                                            CGL029
     C                   EVAL      FLROBR = RPROBR
     C                   EVAL      FLRSCY = RPRSCY
 
      ** Setup FRA/IRS specific data
      ** (on Insertions, these fields are zero/blank)
 
     C                   MOVEL     NwIRSSSI      FlIRSIns
     C                   MOVE      RPAGVC        FLAGVC
 
      ** If Settlement instructions are not defined and payment/receipt
      ** dates are not in the past, default them
 
     C                   IF        FLPSTM = *ZERO AND
     C                             PProtectPay <> 'Y' AND
     C                             FLRSTM = *ZERO AND
     C                             PProtectRec <> 'Y'
     C                             AND CIR008 = 'N' OR                                        CIR008
     C                             FLPSTM = *ZERO AND                                         CIR008
     C                             PProtectPay <> 'Y' AND                                     CIR008
     C                             FLRSTM = *ZERO AND                                         CIR008
     C                             PProtectRec <> 'Y' AND                                     CIR008
     C                             #0ACCD <> 'X' AND CIR008 = 'Y'                             CIR008
 
     C                   CALLB     'ZASETINDFT'
     C                   PARM      'CACF'        PCallgPgm
     C                   PARM      #0CUCY        PPayCcy
     C                   PARM      #0CUCY        PRcvCcy
     C                   PARM      #0CNUM        PCustSName
     C                   PARM      #0DTYP        PTransTyp
     C                   PARM      #0FEFI        PFedFund
     C                   PARM                    BQISDA
     C                   PARM                    BQAGTY
     C                   PARM                    BQAGDT
     C                   PARM                    BQAGVV
     C                   PARM                    BQAGVC
                                                                                              CSD095
      ** Deal Subtype                                                                         CSD095
     C                   PARM      *BLANK        BlankSTYP                                    CSD095
                                                                                              CSD095
      ** Branch                                                                               CSD095
     C                   PARM      *BLANK        BlankBRCA                                    CSD095
                                                                                              CSD095
     C                   PARM                    ##PAYF
     C                   PARM                    ##RECF
     C                   PARM                    ##RSIF
 
     C                   ENDIF
 
      ** Convert Settlement details from File to Screen format
 
     C                   CALLB     'ZASETINCVT'
     C                   PARM                    ##PAYF
     C                   PARM                    ##RECF
     C                   PARM                    ##RSIF
     C                   PARM      *BLANKS       ##PAYS
     C                   PARM      *BLANKS       ##RECS
     C                   PARM      *BLANKS       ##RSIS
     C                   PARM      #0CUCY        InRCCY                                      CSF011A
     C                   PARM      #0CUCY        InPCCY                                      CSF011A
 
      ** Set screen numeric fields to blank, if zero on file
 
     C                   IF        #0ACCD <> 'I'
     C                   IF        AGDT = *ZERO
     C                   EVAL      DDAGDT = *BLANKS
     C                   ENDIF
     C                   IF        AGVV = *ZERO AND AGVC = *ZERO
     C                   EVAL      DDAGVV = *BLANKS
     C                   ENDIF
     C                   ENDIF
 
     C     ESrParmS      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrCancS - Cancel on Settlement Details Screen                *
      *****************************************************************
     C     SrCancS       BEGSR
 
     C                   EVAL      WScrn = 'M'
 
     C                   IF        CIR005 = 'Y'
     C                   EVAL      WFirstPass = 'Y'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrExitS - Exit from Settlement Details Screen                *
      *****************************************************************
     C     SrExitS       BEGSR
 
      ** If option selected is 'N' then go check if records are
      ** still to be read from the subfile. Read them else
      ** return to browse screen
 
     C                   IF        POptSel = 'N'
     C                   IF        WRdNB = 'Y'
     C                   EVAL      WScrn = 'R'
     C                   ELSE
     C                   EVAL      WScrn = 'B'
     C                   ENDIF
     C                   GOTO      ESrExitS
     C                   ENDIF
 
      ** If Settlement details invalid, return to Main details screen
 
     C                   IF        RetCodeOut = '*ERRORS'
     C                   EVAL      WScrn = 'M'
 
      ** Else, continue with Confirmation screen
 
     C                   ELSE
     C                   EVAL      WScrn = 'C'
 
      ** Update Valid deal: Payment SSIs
 
     C**********         MOVEL     FlPayIns      NwPaySSI                                     CGL029
     C                   EVAL      %SUBST(NwPaySSI:1:2) = %SUBST(FlPayIns:1:2)                CGL029
     C                   EVAL      RPPONS = FLPONS                                            CGL029
     C                   EVAL      %SUBST(NwPaySSI:15:544) =                                  CGL029
     C                                     %SUBST(FlPayIns:21:544)                            CGL029
     C                   EVAL      RPPOBR = FLPOBR
     C                   EVAL      RPCVMR = FLCVMR
 
      ** Update Valid deal: Receipt SSIs
 
     C**********         MOVEL     FlRcvIns      NwRcvSSI                                     CGL029
     C                   EVAL      RPRONS = FLRONS                                            CGL029
     C                   EVAL      %SUBST(NwRcvSSI:1:2) = %SUBST(FlRcvIns:1:2)                CGL029
     C                   EVAL      %SUBST(NwRcvSSI:15:54) =                                   CGL029
     C                                     %SUBST(FlRcvIns:21:54)                             CGL029
     C                   EVAL      RPROBR = FLROBR
 
      ** Update Valid deal: Settlement ccy & 'IN' ccy in Field 72
 
     C                   EVAL      RPRSCY = FLRSCY
     C                   EVAL      RPPSCY = FLPSCY
     C                   EVAL      RPIC72 = FLIC72
 
      ** Update Valid deal: FRA/IRS details
 
     C                   MOVEL     FlIRSIns      NwIRSSSI
     C                   MOVE      FLAGVC        RPAGVC
 
      ** Zeroise numeric fields in NwIRSSSI for update
      ** (these fields may be blank if type is OTHER)
 
     C                   IF        FLAGDT = *BLANKS
     C                   EVAL      RPAGDT = *ZERO
     C                   ENDIF
     C                   IF        FLAGVV = *BLANKS
     C                   EVAL      RPAGVV = *ZERO
     C                   ENDIF
     C                   IF        FLAGVC = *BLANKS
     C                   EVAL      RPAGVC = *ZERO
     C                   ENDIF
 
     C                   ENDIF
 
     C     ESrExitS      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrScrnC - Confirmation of Input Evoked for Inserts, Amends & *
      *            Authorisations                                     *
      *****************************************************************
     C     SrScrnC       BEGSR
 
      ** Prior to validation, initialize error indicators as 'OK'
 
     C                   EVAL      IRECACF = *ALL'Y'
 
      ** Validate deal details
 
     C                   CALLB     'IRCACFVAL'
     C                   PARM                    ModeOfOp
     C                   PARM                    RespMode
     C                   PARM                    CrIRScnFmt
     C                   PARM                    NwIRScnFmt
     C                   PARM      RPRSCY        RecSetCcy
     C                   PARM      RPRSTM        RecSetMeth
     C                   PARM      RPRONS        RecNostro
     C                   PARM      RPPSCY        PaySetCcy
     C                   PARM      RPPSTM        PaySetMeth
     C                   PARM      RPPONS        PayNostro
     C                   PARM                    ExtData
     C                   PARM                    WValBDC
     C                   PARM                    SDBANK
     C                   PARM                    SDMMOD
     C                   PARM                    SDDEAL
     C                   PARM                    SDGELR
     C                   PARM                    SDTRAD
     C                   PARM                    SDFAIS
     C                   PARM                    ZMUSER
     C                   PARM                    CIR001
     C                   PARM                    CIR005
     C                   PARM                    CIR006
     C                   PARM                    CIR007
     C                   PARM                    IRECACF
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM      *ZERO         Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM      *ZERO         WIdx
     C                   PARM                    NwIRFilFmt
      ***Sign*of Short Term Rate                                                     BUG5707 BUG6472
     C**********         PARM                    #0SIGN            1                 BUG5707 BUG6472
 
      ** If transaction is valid, display 'Press enter to accept'
 
     C                   IF        Idx = *ZERO
     C                   EVAL      FldNameArr(1) = '*ANY'
     C                   EVAL      MsgIdArr(1) = 'MMM1030'
     C                   ENDIF
 
      ** Write/read display screen
 
     C                   CALLB     'IRCACF1DP'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    NwIRScnFmt
     C                   PARM                    CrIRFilFmt
     C                   PARM                    DDSTS
     C                   PARM                    IRECACF
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM      'N'           PEKYFD
     C                   PARM      'N'           PEDtFld
     C                   PARM      'N'           PEINKG
     C                   PARM      'N'           PEINKH
     C                   PARM      'N'           PEINKJ
     C                   PARM      'N'           PEINKN
     C                   PARM      'N'           PEINKP
     C                   PARM                    CIR006
     C                   PARM                    CEU003
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKG
     C                   PARM      '0'           PINKH
     C                   PARM      '0'           PINKJ
     C                   PARM      '0'           PINKL
     C                   PARM      '0'           PINKN
     C                   PARM      '0'           PINKP
     C                   PARM      'N'           WriteOnly
 
      ** Reset errors
 
     C                   EVAL      IRECACF = *ALL'Y'
     C                   MOVEA     *BLANKS       FldNameArr
     C                   MOVEA     *BLANKS       MsgIdArr
     C                   MOVEA     *BLANKS       MsgDtaArr
     C                   MOVEA     *BLANKS       WFldNamArr
     C                   MOVEA     *BLANKS       WMsgIdArr
     C                   MOVEA     *BLANKS       WMsgDtaArr
 
      ** If F3 pressed, end program
 
     C     PINKC         CASEQ     '1'           SrEndPgm
 
      ** If F12 pressed, cancel on Confirmation screen
 
     C     PINKL         CASEQ     '1'           SrCancC
 
      ** Else, exit Confirmation screen
 
     C                   CAS                     SrExitC
     C                   ENDCS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrCancC - Cancel on Confirmation Screen                      *
      *****************************************************************
     C     SrCancC       BEGSR
 
     C                   EVAL      WScrn = 'M'
 
     C                   IF        CIR005 = 'Y'
     C                   EVAL      WFirstPass = 'Y'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrExitC - Exit from Confirmation Screen                      *
      *****************************************************************
     C     SrExitC       BEGSR
 
      ** If no errors in validation, continue with updates
      ** Else, return to Main details screen
 
     C                   IF        Idx = *ZERO
     C                   EVAL      WScrn = 'U'
     C                   ELSE
     C                   EVAL      WScrn = 'M'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrUpdate - File Updates                                      *
      *****************************************************************
     C     SrUpdate      BEGSR
 
      ** If deal number not defined (on Insert), get the next available
 
     C                   IF        #0DLNO = *BLANKS
 
     C                   IF        PGNDlno <> *BLANKS
     C                   EVAL      #0DLNO = PGNDlno
     C                   ELSE
     C                   CALLB     'CAGETNXTDL'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM      *BLANKS       MsgID1
     C                   PARM                    #0DLNO
     C                   PARM      *ZERO         RPDLNO
     C                   IF        MsgID1 <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'CAGTNXDL'
     C                   EVAL      DBASE = 004
     C                   EVAL      DBKEY = #0DLNO
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C**********         EVAL      #0DLNO = PGNDlno                                           245219
     C                   ENDIF
 
     C                   EVAL      PSIDN = #0DLNO
     C                   ENDIF
 
      ** Default Up-Front Fee Pay/Receive indicator                                         AR314712
                                                                                            AR314712
     C                   IF        CIR001 = 'Y'                                             AR314712
     C                             AND RPUPPR = *BLANKS                                     AR314712
     C                             AND RPUPFE <> *ZERO                                      AR314712
     C                             AND RPUPVD <> *ZERO                                      AR314712
     C                   IF        #0BYSL = 'B'                                             AR314712
     C                   EVAL      RPUPPR = 'P'                                             AR314712
     C                   ELSE                                                               AR314712
     C                   EVAL      RPUPPR = 'R'                                             AR314712
     C                   ENDIF                                                              AR314712
     C                   ENDIF                                                              AR314712
                                                                                            AR314712
      ** Update Valid fields
 
     C                   MOVEL     #0DLNO        RPDLNO
     C                   EVAL      RPCHTP = #0ACCD
     C                   EVAL      RPFRNT = PFOTranSel
                                                                                              CAP056
      ** If Automatic deal authorisation is installed, move value of                          CAP056
      ** Automatic authorisation from Invalids file to Valids file                            CAP056
                                                                                              CAP056
     C                   IF        CAP056 = 'Y'                                               CAP056
     C                   EVAL      RPAUTH = #0AUTH                                            CAP056
     C                   ENDIF                                                                CAP056
 
      ** Deals file Updates
 
     C                   CALLB     'IRCACFUPD'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    ModeOfOp                                     CAP056
     C                   PARM                    NwIRFilFmt
     C                   PARM      'Y'           PScreenInpt                                  CAP043
     C                   PARM                    DBRN
     C                   PARM                    SDBANK
     C                   PARM                    SDGELR
     C                   PARM                    SDTRAD
     C                   PARM                    SDRETL
     C                   PARM                    SDFAIS
     C                   PARM                    CIR005
     C                   PARM                    CIR006
     C                   PARM                    CSC011
     C                   PARM                    CDE001
     C                   PARM                    CIR008                                       CIR008
     C                   PARM                    CAP056                                       CAP056
                                                                                              209375
      ** If update is successful and action is insert, move deal number to                    209375
      ** successfully inserted deal number to display this on browse screen                   209375
                                                                                              209375
     C                   IF        RetCodeOut=*BLANKS AND #0ACCD='I'                          209375
     C                   EVAL      PSIDN = #0DLNO                                             209375
     C                   ENDIF                                                                209375
 
      ** If there were any errors in the Update function,
      ** rollback and end this program
 
     C                   IF        RetCodeOut <> *BLANKS
     C     CSC022        IFEQ      'N'                                                       BUG2603
     C                   ROLBK
     C                   ELSE                                                                BUG2603
     C     WSkpCom       IFNE      'Y'                                                       BUG2603
     C                   ROLBK                                                               BUG2603
     C                   ELSE                                                                BUG2603
     C                   SETON                                        U7U8                   BUG2603
     C                   ENDIF                                                               BUG2603
     C                   ENDIF                                                               BUG2603
     C                   IF        RetCodeOut <> '*RECUPD'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Otherwise, delete the Invalid IRS deal actioned and Commit
 
     C                   ELSE
                                                                                              245219
      ** Add record within Deals Master Extension File (done from Java layer).                245219
     C**********         IF        #0ACCD = 'I'                                         245219247888
     C                   IF        #0ACCD = 'I' AND CLE025 = 'Y'                              247888
     C                   EXSR      WriteDLDLDG                                                245219
     C                   END                                                                  245219
                                                                                              245219
     C     ZATRNKD0      CHAIN     IRICACFD0                          80
     C                   IF        *IN80 = *OFF
     C                   DELETE    IRICACFD0
     C                   ENDIF
     C     APDSETK0      CHAIN     APIDSETD0                          80
     C                   IF        *IN80 = *OFF
     C                   DELETE    APIDSETD0
 
      ** Delete invalid record from the log file
 
     C                   IF        CSC011 = 'Y' AND S1SUPP = LIBR
 
     C                   EVAL      KMsgTyp = KMsgType
     C                   EVAL      KFrntOffID = PFOTranSel
     C                   EVAL      KTimeStamp = PTmestpSel
 
     C     KAPILOG       CHAIN     APILOGL0                           80
     C                   IF        *IN80 = *OFF
     C                   DELETE    APILOGL0
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
                                                                                              CAP043
      ** Delete invalid records from the invalids file                                        CAP043
                                                                                              CAP043
     C                   IF        CAP043 = 'Y' AND CAP041 = 'Y'                              CAP043
     C                   EXSR      SRDelInIRC                                                 CAP043
     C                   ENDIF                                                                CAP043
      *                                                                                      BUG2603
     C                   IF        CSC022 = 'N' OR                                           BUG2603
     C                             CSC022 = 'Y' AND WSkpCom = 'N'                            BUG2603
     C                   COMMIT
     C                   ENDIF                                                               BUG2603
     C                   ENDIF
 
      ** If error occurred in updating last transaction,
      ** set on flag to display message on Browse screen
 
     C                   IF        RetCodeOut = '*RECUPD'
     C                   EVAL      PErrUp = 'Y'
     C                   ELSE
     C                   EVAL      PErrUp = 'N'
     C                   ENDIF
 
      ** Blank the Business Day Convention fields
 
     C                   IF        CIR005 = 'Y'
     C                   EVAL      BsDayConv = *BLANKS
     C                   EVAL      WFirstPass = 'Y'
     C                   ENDIF
 
      ** If records are still to be read from the subfile, read them
      ** Else, return to Browse screen
 
     C                   IF        WRdNB = 'Y'
     C                   EVAL      WScrn = 'R'
     C                   ELSE
     C                   EVAL      WScrn = 'B'
     C                   ENDIF
 
     C                   ENDSR
                                                                                              CAP043
      ********************************************************************                    CAP043
      /EJECT                                                                                  CAP043
      ********************************************************************                    CAP043
      *                                                                  *                    CAP043
      * SRIPCSC - Call to IRIPCSCRT                                      *                    CAP043
      *                                                                  *                    CAP043
      ********************************************************************                    CAP043
                                                                                              CAP043
     C     SRIPCSC       BEGSR                                                                CAP043
                                                                                              CAP043
     C                   CALLB     'IRIPCSCRT'                                                CAP043
     C                   PARM                    ReturnCode                                   CAP043
     C                   PARM                    #0DLNO                                       CAP043
     C                   PARM                    PGNDlno                                      CAP043
     C                   PARM                    RPVDAT                                       CAP043
     C                   PARM                    RPMDAT                                       CAP043
     C**********         PARM                    BGN2ST                              CAP043 MD054117
     C                   PARM                    PCIDCF                                     MD054117
     C                   PARM                    PCtlDate                                     CAP043
     C                   PARM                    PPAmt                                        CAP043
     C                   PARM                    BJDFIN                                       CAP043
     C                   PARM      #0ACCD        PAction                                      CAP043
     C                   PARM                    PUpdate                                      CAP043
     C                   PARM                    PErrorFndPr                                  CAP043
     C                   PARM                    PInPCSCDS                                    CAP043
     C                   PARM                    PPrevDate                                    CAP043
     C                   PARM                    PCurrency                                    CAP043
     C                   PARM                    PBDConvtn                                    CAP043
                                                                                              CAP043
     C                   ENDSR                                                                CAP043
                                                                                              CAP043
      ********************************************************************                    CAP043
      /EJECT                                                                                  CAP043
      ********************************************************************                    CAP043
      *                                                                  *                    CAP043
      * SRDelInIRC - Delete Invalid Principal Change Date Records        *                    CAP043
      *                                                                  *                    CAP043
      ********************************************************************                    CAP043
                                                                                              CAP043
     C     SRDelInIRC    BEGSR                                                                CAP043
                                                                                              CAP043
     C                   IF        CSC011 = 'Y'                                               CAP043
     C                   MOVEL     'IRCAPC'      KMsgTyp                                      CAP043
     C     KAPILOG       SETLL     APILOGL0                                                   CAP043
     C     KAPILOG       READE     APILOGL0                                                   CAP043
     C                   DOW       NOT %EOF                                                   CAP043
     C                   DELETE    APILOGD0                                                   CAP043
     C     KAPILOG       READE     APILOGL0                                                   CAP043
     C                   ENDDO                                                                CAP043
                                                                                              CAP043
     C                   MOVEL     'IRCATR'      KMsgTyp                                      CAP043
     C     KAPILOG       SETLL     APILOGL0                                                   CAP043
     C     KAPILOG       READE     APILOGL0                                                   CAP043
     C                   DOW       NOT %EOF                                                   CAP043
     C                   DELETE    APILOGD0                                                   CAP043
     C     KAPILOG       READE     APILOGL0                                                   CAP043
     C                   ENDDO                                                                CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
      ** PCSC invalid file                                                                    CAP043
                                                                                              CAP043
     C     ZATRNKD0      SETLL     IRIPCSCD0                                                  CAP043
     C     ZATRNKD0      READE     IRIPCSCD0                                                  CAP043
     C                   DOW       NOT %EOF                                                   CAP043
     C                   DELETE    IRIPCSCD0                                                  CAP043
     C     ZATRNKD0      READE     IRIPCSCD0                                                  CAP043
     C                   ENDDO                                                                CAP043
                                                                                              CAP043
     C                   ENDSR                                                                CAP043
                                                                                              CAP043
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrEndPgm - End Program                                       *
      *****************************************************************
     C     SrEndPgm      BEGSR
 
     C                   IF        BGWDPR = 'Y'
     C     CSC022        IFEQ      'N'                                                       BUG2603
     C                   ROLBK
     C                   ELSE                                                                BUG2603
     C     WSkpCom       IFNE      'Y'                                                       BUG2603
     C                   ROLBK                                                               BUG2603
     C                   ELSE                                                                BUG2603
     C                   SETON                                        U7U8                   BUG2603
     C                   ENDIF                                                               BUG2603
     C                   ENDIF                                                               BUG2603
     C                   ENDIF
 
     C                   EVAL      WScrn = 'T'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrDtaSubsT - Transaction Details Data Substitution           *
      *****************************************************************
     C     SrDtaSubsT    BEGSR
 
     C                   RESET                   RtnCde10A
 
     C                   CALLB     'APDTASUBS'
     C                   PARM                    RtnCde10A
     C                   PARM      GHSUBS        WSubsChar
     C                   PARM      NwIRScnFmt    IncDATA
     C                   PARM      CrIRScnfmt    CurDATA
 
     C                   EVAL      NwIRScnFmt = IncDATA
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrSSIAmd - Setup Settlement Instructions on Amendment        *
      *****************************************************************
     C     SrSSIAmd      BEGSR
 
      ** Conversion of File fields to Screen format
 
     C**********         MOVEL     CrRecSSI      FlRcvIns                                     CGL029
     C                   EVAL      %SUBST(FlRcvIns:1:2) = %SUBST(CrRecSSI:1:2)                CGL029
     C                   EVAL      %SUBST(FlRcvIns:21:54) =                                   CGL029
     C                                     %SUBST(CrRecSSI:15:54)                             CGL029
     C                   EVAL      FLRONS = RONS                                              CGL029
     C                   EVAL      FLROBR = ROBR
     C                   EVAL      FLRSCY = RSCY
     C                   MOVEL     CrIRSSSI      FlIRSIns
     C                   MOVEL     AGVC          FLAGVC
     C**********         MOVEL     CrPaySSI      FlPayIns                                     CGL029
     C                   EVAL      %SUBST(FlPayIns:1:2) = %SUBST(NwPaySSI:1:2)                CGL029
     C                   EVAL      %SUBST(FlPayIns:3:20) = PONS                               CGL029
     C                   EVAL      %SUBST(FlPayIns:21:544) =                                  CGL029
     C                                     %SUBST(NwPaySSI:15:544)                            CGL029
     C                   EVAL      FLPOBR = POBR
     C                   EVAL      FLCVMR = CVMR
     C                   EVAL      FLPSCY = PSCY
     C                   EVAL      FLIC72 = IC72
 
     C                   CALLB     'ZASETINCVT'
     C                   PARM                    ##PAYF
     C                   PARM                    ##RECF
     C                   PARM                    ##RSIF
     C                   PARM      *BLANKS       CrPaySttmt
     C                   PARM      *BLANKS       CrRecSttmt
     C                   PARM      *BLANKS       CrFRASttmt
     C                   PARM      #0CUCY        InRCCY                                      CSF011A
     C                   PARM      #0CUCY        InPCCY                                      CSF011A
 
      ** If no Payment or Receive instructions have been supplied,
      ** default them to those currently on the deal
 
     C                   IF        ##PAYS = *BLANKS
     C                   EVAL      ##PAYS = CrPaySttmt
     C                   ENDIF
 
     C                   IF        ##RECS = *BLANKS
     C                   EVAL      ##RECS = CrRecSttmt
     C                   ENDIF
 
     C                   IF        ##RSIS = *BLANKS
     C                   EVAL      ##RSIS = CrFRASttmt
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrDtaSubsS - Settlement Details Data Substitution            *
      *****************************************************************
     C     SrDtaSubsS    BEGSR
 
      ** Payment instructions
 
     C                   RESET                   RtnCde10A
 
     C                   CALLB     'APDTASUBS'
     C                   PARM                    RtnCde10A
     C                   PARM      GHSUBS        WSubsChar
     C                   PARM      ##PAYS        IncDATA
     C                   PARM      CrPaySttmt    CurDATA
 
     C                   MOVEL     IncDATA       ##PAYS
 
      ** Receipt instructions
 
     C                   RESET                   RtnCde10A
 
     C                   CALLB     'APDTASUBS'
     C                   PARM                    RtnCde10A
     C                   PARM      GHSUBS        WSubsChar
     C                   PARM      ##RECS        IncDATA
     C                   PARM      CrRecSttmt    CurDATA
 
     C                   MOVEL     IncDATA       ##RECS
 
      ** FRA/IRS instructions
 
     C                   RESET                   RtnCde10A
 
     C                   CALLB     'APDTASUBS'
     C                   PARM                    RtnCde10A
     C                   PARM      GHSUBS        WSubsChar
     C                   PARM      ##RSIS        IncDATA
     C                   PARM      CrFRASttmt    CurDATA
 
     C                   MOVEL     IncDATA       ##RSIS
 
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  245219
      *****************************************************************                       245219
      *                                                               *                       245219
      * WriteDLDLDG - WRITE IRS Extension record                      *                       245219
      *               (usually done from java layer)                  *                       245219
      *                                                               *                       245219
      *****************************************************************                       245219
     C     WriteDLDLDG   BEGSR                                                                245219
      *                                                                                       245219
      ** When opening new deals within DEALSDG, write a corresponding                         245219
      ** record in the Deals details extension file DLDLDGQD.                                 245219
      *                                                                                       245219
     C     @KeyDealL5    KLIST                                                                245219
     C                   KFLD                    F1DLNO                                       245219
      *                                                                                       245219
     C                   MOVE      #0DLNO        F1DLNO                                       245219
     C     @KeyDealL5    CHAIN     DLDLDGD0                           82                      245219
      *                                                                                       245219
     C     *IN82         IFEQ      *ON                                                        245219
     C                   EVAL      F1BRCA = #0BRCA                                            245219
     C                   WRITE     DLDLDGD0                                                   245219
                                                                                              245219
     C                   ENDIF                                                                245219
                                                                                              245219
     C                   ENDSR                                                                245219
      *****************************************************************                       245219
      /EJECT
      *****************************************************************
      * *INZSR - Initial Processing                                   *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C                   IN        ZMUSER
     C                   UNLOCK    ZMUSER
 
     C                   EVAL      DBPGM = 'IRCACFRPR'
 
      ** Access Bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 005
     C                   EVAL      DBKEY = POptn
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access Module details
 
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDMMOD        PARM      SDMMOD        DSFDY
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDMMODPD'
     C                   EVAL      DBASE = 006
     C                   EVAL      DBKEY = POptn
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access Dealing details
 
     C**********         CALL      'AODEALR0'                                                 CGL029
     C                   CALL      'AODEALR1'                                                 CGL029
     C                   PARM      '*DBERR '     PRtCd
     C                   PARM      '*FIRST '     POptn
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDDEALPD'
     C                   EVAL      DBASE  = 007
     C                   EVAL      DBKEY  = POptn
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access General Ledger details
 
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR '     PRtCd
     C                   PARM      '*FIRST '     POptn
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDGELRPD'
     C                   EVAL      DBASE  = 008
     C                   EVAL      DBKEY  = POptn
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access API ICD details
 
     C                   CALL      'AOAPIR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDAPI         PARM      SDAPI         DSFDY
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDAPIPD'
     C                   EVAL      DBASE = 009
     C                   EVAL      DBKEY = POptn
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access Trading details
 
     C                   CALL      'AOTRADR0'
     C                   PARM      '*DBERR '     PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDTRAD        PARM      SDTRAD        DSFDY
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDTRADPD'
     C                   EVAL      DBASE  = 010
     C                   EVAL      DBKEY  = POptn
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access FRA/IRS ICD details
 
     C                   CALL      'AOFAISR0'
     C                   PARM      '*DBERR '     PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDFAIS        PARM      SDFAIS        DSFDY
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDFAISPD'
     C                   EVAL      DBASE  = 011
     C                   EVAL      DBKEY  = POptn
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access Retail details
 
     C                   CALLB     'AORETLR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDRETL        PARM      SDRETL        DSFDY
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDRETLPD'
     C                   EVAL      DBASE  = 012
     C                   EVAL      DBKEY  = POptn
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Check if Dealing Transaction Settlements is installed
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CEU003'      PSarD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRtCd <> *BLANKS AND
     C                             PRtCd <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 013
     C                   EVAL      DBKEY = PSarD
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      CEU003 = 'Y'
     C                   ELSE
     C                   EVAL      CEU003 = 'N'
     C                   ENDIF
 
      ** Check if Interest Rate Calendars is installed
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CIR001'      PSarD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRtCd <> *BLANKS AND
     C                             PRtCd <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 014
     C                   EVAL      DBKEY = PSarD
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      CIR001 = 'Y'
     C                   ELSE
     C                   EVAL      CIR001 = 'N'
     C                   ENDIF
 
      ** Check if FRA/IRS Business Day Convention is installed
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CIR005'      PSarD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRtCd <> *BLANKS AND
     C                             PRtCd <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 015
     C                   EVAL      DBKEY = PSarD
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtCd = *BLANKS
     C                   MOVEL     'Y'           CIR005
     C                   ELSE
     C                   MOVEL     'N'           CIR005
     C                   ENDIF
 
      ** Check if Amortisation of Caps, Collars, Floors and
      ** Individual Compounding Swaps is installed
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CIR006'      PSarD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRtCd <> *BLANKS AND
     C                             PRtCd <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 016
     C                   EVAL      DBKEY = PSarD
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      CIR006 = 'Y'
     C                   ELSE
     C                   EVAL      CIR006 = 'N'
     C                   ENDIF
 
      ** Check if Overnight Index Swaps is installed
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CIR007'      PSarD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRtCd <> *BLANKS AND
     C                             PRtCd <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 017
     C                   EVAL      DBKEY = PSarD
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      CIR007 = 'Y'
     C                   ELSE
     C                   EVAL      CIR007 = 'N'
     C                   ENDIF
 
      ** Check if 24x7 Midas Availability is installed
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CSC011'      PSarD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRtCd <> *BLANKS AND
     C                             PRtCd <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 018
     C                   EVAL      DBKEY = PSarD
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      CSC011 = 'Y'
     C                   IN        SDSTAT
     C                   IN        SC24X7
     C                   ELSE
     C                   EVAL      CSC011 = 'N'
     C                   ENDIF
 
      ** Check if CCRM Limits feature is installed
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CDE001'      PSarD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRtCd <> *BLANKS AND
     C                             PRtCd <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 019
     C                   EVAL      DBKEY = PSarD
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      CDE001 = 'Y'
     C                   ELSE
     C                   EVAL      CDE001 = 'N'
     C                   ENDIF
 
      ** Check if FEBO/Proc.Method/Nxt Prin.Chg Date APIs is installed
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CAP041'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRtCd <> *BLANKS and PRtCd <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 022
     C                   EVAL      DBKEY = PSard
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      CAP041 = 'Y'
     C                   ELSE
     C                   EVAL      CAP041 = 'N'
     C                   ENDIF
                                                                                              CIR008
      ** Check if FRA/IRS Deals Authorisations is installed                                   CIR008
                                                                                              CIR008
     C                   CALL      'AOSARDR0'                                                 CIR008
     C                   PARM      *BLANKS       PRtCd                                        CIR008
     C                   PARM      '*VERIFY'     POptn                                        CIR008
     C                   PARM      'CIR008'      PSarD                                        CIR008
     C     SCSARD        PARM      SCSARD        DSFDY                                        CIR008
                                                                                              CIR008
     C                   IF        PRtCd <> *BLANKS AND                                       CIR008
     C                             PRtCd <> '*NRF   '                                         CIR008
     C     *LOCK         IN        LDA                                                        CIR008
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CIR008
     C                   EVAL      DBASE  = 020                                               CIR008
     C                   EVAL      DBKEY  = PSarD                                             CIR008
     C                   OUT       LDA                                                        CIR008
     C                   EXSR      *PSSR                                                      CIR008
     C                   ENDIF                                                                CIR008
                                                                                              CIR008
     C                   IF        PRtCd = *BLANKS                                            CIR008
     C                   EVAL      CIR008 = 'Y'                                               CIR008
     C                   ELSE                                                                 CIR008
     C                   EVAL      CIR008 = 'N'                                               CIR008
     C                   ENDIF                                                                CIR008
                                                                                              CAP056
      ** Check if Automatic Authorisation of Interface deals is installed                     CAP056
                                                                                              CAP056
     C                   CALL      'AOSARDR0'                                                 CAP056
     C                   PARM      *BLANKS       PRtCd                                        CAP056
     C                   PARM      '*VERIFY'     POptn                                        CAP056
     C                   PARM      'CAP056'      PSarD                                        CAP056
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP056
                                                                                              CAP056
     C                   IF        PRtCd <> *BLANKS AND                                       CAP056
     C                             PRtCd <> '*NRF   '                                         CAP056
     C     *LOCK         IN        LDA                                                        CAP056
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAP056
     C                   EVAL      DBASE  = 021                                               CAP056
     C                   EVAL      DBKEY  = PSarD                                             CAP056
     C                   OUT       LDA                                                        CAP056
     C                   EXSR      *PSSR                                                      CAP056
     C                   ENDIF                                                                CAP056
                                                                                              CAP056
     C                   IF        PRtCd = *BLANKS                                            CAP056
     C                   EVAL      CAP056 = 'Y'                                               CAP056
     C                   ELSE                                                                 CAP056
     C                   EVAL      CAP056 = 'N'                                               CAP056
     C                   ENDIF                                                                CAP056
                                                                                              CAP043
      ** Check if CAP043 is installed                                                         CAP043
                                                                                              CAP043
     C                   CALL      'AOSARDR0'                                                 CAP043
     C                   PARM      *BLANKS       PRtCd                                        CAP043
     C                   PARM      '*VERIFY'     POptn                                        CAP043
     C                   PARM      'CAP043'      PSard                                        CAP043
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP043
                                                                                              CAP043
     C                   IF        PRtCd = *Blanks                                            CAP043
     C                   EVAL      CAP043 = 'Y'                                               CAP043
     C                   ELSE                                                                 CAP043
     C                   EVAL      CAP043 = 'N'                                               CAP043
                                                                                              CAP043
     C                   IF        PRtCd <> '*NRF'                                            CAP043
     C     *LOCK         IN        LDA                                                        CAP043
     C                   EVAL      DBKEY = 'CAP043'                                           CAP043
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAP043
     C                   EVAL      DBASE = 023                                                CAP043
     C                   OUT       LDA                                                        CAP043
     C                   EXSR      *PSSR                                                      CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C                   ENDIF                                                                CAP043
 
      *                                                                                      BUG2603
      ** Determine if enhancement CSC022 is switched on                                      BUG2603
      *                                                                                      BUG2603
     C                   CALLB     'AOSARDR0'                                                BUG2603
     C                   PARM      *BLANKS       PRTCD                                       BUG2603
     C                   PARM      '*VERIFY'     POPTN                                       BUG2603
     C                   PARM      'CSC022'      PSARD                                       BUG2603
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG2603
      *                                                                                      BUG2603
      ** Initialize work fields                                                              BUG2603
      *                                                                                      BUG2603
     C                   EVAL      CSC022 = 'N'                                              BUG2603
     C                   EVAL      WSkpCom = 'N'                                             BUG2603
      *                                                                                      BUG2603
     C                   IF        PRTCD = *Blanks                                           BUG2603
     C                   EVAL      CSC022 = 'Y'                                              BUG2603
      *                                                                                      BUG2603
     C                   IN        SCCMTJOB                                                  BUG2603
      *                                                                                      BUG2603
     C                   IF        COMITNUM <> 0                                             BUG2603
     C                   MOVEA     Comitjobs     JobCmtctlDS                                 BUG2603
     C                   EVAL      WPos = %Lookup(PSJOBNAME:JobCmtCtlDS)                     BUG2603
     C                   IF        WPos > 0                                                  BUG2603
     C                   EVAL      WSkpCom = 'Y'                                             BUG2603
     C                   ENDIF                                                               BUG2603
     C                   ENDIF                                                               BUG2603
     C                   ELSE                                                                BUG2603
      *                                                                                      BUG2603
      ** An NRF (No Record Found) return code is valid.                                      BUG2603
      ** Issue database error only for error return codes.                                   BUG2603
      *                                                                                      BUG2603
     C                   IF        PRTCD <> '*NRF'                                           BUG2603
     C                   EVAL      DBFILE = 'SCSARDPD'                                       BUG2603
     C                   EVAL      DBKEY = 'CSC022'                                          BUG2603
     C                   EVAL      DBASE = 025                                               BUG2603
     C                   EXSR      *PSSR                                                     BUG2603
     C                   ENDIF                                                               BUG2603
     C                   ENDIF                                                               BUG2603
                                                                                              247888
      ** Check if CLE025 is installed                                                         247888
                                                                                              247888
     C                   CALL      'AOSARDR0'                                                 247888
     C                   PARM      *BLANKS       @RTCD                                        247888
     C                   PARM      '*VERIFY'     @OPTN                                        247888
     C                   PARM      'CLE025'      @SARD                                        247888
     C     SCSARD        PARM      SCSARD        DSFDY                                        247888
                                                                                              247888
     C     @RTCD         IFEQ      *BLANK                                                     247888
     C                   MOVEL     'Y'           CLE025            1                          247888
     C                   ELSE                                                                 247888
     C                   MOVEL     'N'           CLE025                                       247888
     C                   ENDIF                                                                247888
                                                                                              247888
                                                                                            MD054117
     C                   CALL      'AOSVALR0'                                               MD054117
     C                   PARM      *BLANKS       PRETURN                                    MD054117
     C                   PARM      PSYSVAL1      POP01                                      MD054117
     C                   PARM      *BLANKS       PVL01                                      MD054117
     C                   PARM      *BLANKS       POP02                                      MD054117
     C                   PARM      *BLANKS       PVL02                                      MD054117
     C                   PARM      *BLANKS       POP03                                      MD054117
     C                   PARM      *BLANKS       PVL03                                      MD054117
     C                   PARM      *BLANKS       POP04                                      MD054117
     C                   PARM      *BLANKS       PVL04                                      MD054117
     C                   PARM      *BLANKS       POP05                                      MD054117
     C                   PARM      *BLANKS       PVL05                                      MD054117
     C                   PARM      *BLANKS       POP06                                      MD054117
     C                   PARM      *BLANKS       PVL06                                      MD054117
     C                   PARM      *BLANKS       POP07                                      MD054117
     C                   PARM      *BLANKS       PVL07                                      MD054117
     C                   PARM      *BLANKS       POP08                                      MD054117
     C                   PARM      *BLANKS       PVL08                                      MD054117
     C                   PARM      *BLANKS       POP09                                      MD054117
     C                   PARM      *BLANKS       PVL09                                      MD054117
     C                   PARM      *BLANKS       POP10                                      MD054117
     C                   PARM      *BLANKS       PVL10                                      MD054117
      *                                                                                     MD054117
     C                   EVAL      PCIDCF = 'N'                                             MD054117
     C                   IF        PRETURN <> *BLANKS                                       MD054117
     C                   EVAL      DBFILE = 'SDSVALPD'                                      MD054117
     C                   EVAL      DBKEY = PSYSVAL1                                         MD054117
     C                   EVAL      DBASE = 26                                               MD054117
     C                   OUT       LDA                                                      MD054117
     C                   EXSR      *PSSR                                                    MD054117
     C                   ENDIF                                                              MD054117
      *                                                                                     MD054117
     C                   MOVEL     PVL01         PCIDCF                                     MD054117
      *                                                                                     MD054117
      ** Key Lists
 
     C     ZATRNKD0      KLIST
     C                   KFLD                    PFOTranSel
     C                   KFLD                    PTmestpSel
 
     C     ZATRNKX0      KLIST
     C                   KFLD                    PTmestpSel
     C                   KFLD                    PFOTranSel
 
     C     APDSETK0      KLIST
     C                   KFLD                    KMsgType
     C                   KFLD                    PFOTranSel
     C                   KFLD                    PTmestpSel
 
     C     APDSETKX      KLIST
     C                   KFLD                    KMsgType
     C                   KFLD                    PTmestpSel
     C                   KFLD                    PFOTranSel
 
     C     KAPILOG       KLIST
     C                   KFLD                    KMsgTyp
     C                   KFLD                    KFrntOffID
     C                   KFLD                    KTimeStamp
 
      ** Message Type
 
     C                   EVAL      KMsgType = 'IRCACF'
 
      ** Get the field number for the Action code field; the screen
      ** fields start from that number. Subtract one from it to give
      ** the value to subtract from each field's number
 
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM                    RtnCde10A
     C                   PARM                    Format
     C                   PARM                    Field
     C                   PARM                    FieldNo
 
      ** If there was an error default the offset to 13
 
     C                   IF        RtnCde10A = *BLANKS
     C                   EVAL      FldOffset = FieldNo - 1
     C                   ELSE
     C                   EVAL      FldOffset = 13
     C                   ENDIF
 
      ** Get the field number for the first field in BDC screen.
      ** Subtract one from it to give the value to subtract from each
      ** field's number
 
     C                   IF        CIR005 = 'Y'
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM                    RtnCde10A
     C                   PARM                    Format
     C                   PARM                    FieldB
     C                   PARM                    FieldNo
     C                   IF        RtnCde10A = *BLANKS
     C                   EVAL      FldOffsetB = FieldNo - 1
     C                   ENDIF
     C                   ENDIF
 
      ** Get the field number for the first field in Fees/Buy-outs screen.
      ** Subtract one from it to give the value to subtract from each
      ** field's number.
 
     C                   IF        CAP041 = 'Y'
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM                    RtnCde10A
     C                   PARM                    Format
     C                   PARM                    FieldF
     C                   PARM                    FieldNo
     C                   IF        RtnCde10A = *BLANKS
     C                   EVAL      FldOffsetF = FieldNo - 1
     C                   ENDIF
     C                   ENDIF
 
      ** Start on Browse Screen
 
     C                   MOVEL     'B'           WScrn
     C                   EVAL      ModeOfOp = '*RPR  '
     C                   EVAL      PLCcy = BJLCCY
 
      ** Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,IRCACFR013
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2002
