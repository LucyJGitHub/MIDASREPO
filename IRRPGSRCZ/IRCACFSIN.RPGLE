     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Caps/collars/floors screen input')            *
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Dealing Module                               *
      *                                                               *
      *  IRCACFSIN - Caps/Collars/Floors Screen Input                 *
      *                                                               *
      *  Function:  This is the main screen input function            *
      *             for IRS Caps/Collars/Floors deals.                *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD036070           Date 19Oct15               *
      *                 CDL094             Date 11Jun14               *
      *                 CIR017             Date 10Apr14               *
      *                 CSD095             Date 08Apr14               *
      *                 AR314712           Date 13Apr10               *
      *                 AR218555           Date 26Mar10               *
      *                 CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG11376           Date 11May06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE031             Date 26Apr05               *
      *                 CDL038             Date 10May05               *
      *                 BUG7166            Date 12May05               *
      *                 BUG6472            Date 23Apr05               *
      *                 CDL028             Date 07Feb05               *
      *                 BUG5707            Date 28Jan05               *
      *                 BUG2603            Date 12May04               *
      *                 CDL018             Date 03Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 CAS005             Date 16Dec02               *
      *                 CAS004             Date 26Jun02               *
      *                 CAP043             Date 02May02               *
      *                 217684             Date 12May03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 209372             Date 09Sep02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP056             Date 13Mar02               *
      *                 CIR008             Date 13Mar02               *
      *                 CAP055  *CREATE    Date 13Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
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
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  BUG11376-Remove the incorrect declaration of STDDECLARE      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  BUG7166- Valid file does not match DEALSDG (Recompile)       *
      *  BUG6472- Added a sign field for short term rate              *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  BUG5707 - Parameter mismatch in IRCACFVAL and IRCACFCVT      *
      *  BUG2603- Commitment Control Changes for Midas Plus           *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CAS004 - Hedge Accounting Phase A (Recompile)                *
      *  CAP043 - Additional APIs for IRS Schedules                   *
      *  217684 - Authorisation User Malfunction (Recompile).         *
      *  209372 - Error related to calling of IRFEBOSIN               *
      *           Wrong conditioning for move of fee and buy-out      *
      *           fields                                              *
      *  CAP056 - Automatic Authorisation of Interface Deals          *
      *  CIR008 - FRA/IRS Deals Authorisation                         *
      *  CAP055 - Caps/Collars/Floors API                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SrProcInit - Process Initial Screen                          *
      *  SrValidInit - Validate Input to Initial Screen               *
      *  SRClrInit - Clear Initial Screen                             *
      *  SrProcMnDet - Process Main Screen Details                    *
      *  SrValidMain - Validate Input to Main Details Screen          *
      *  SrProcBusDy - Proess Business Day Convention                 *
      *  SrProcWin - Process Window Screen                            *
      *  SrRolBckFwd- Roll Backwards & Forwards through the file      *
      *  SrBldBrw - Build Browse Subfile                              *
      *  SrRdNBrw - Read Next Browse Subfile Record                   *
      *  SrRtvDlDet -  Retrieve Deal Details                          *
      *  SrCvtToScn - Convert Deal Details from File to Screen Format *
      *  SrSetFldSt - Set Field Status on Main Details Screen Accor-  *
      *               ding to Action Code                             *
      *  SrSetFKSt - Set Function Key Status on Main Details Screen   *
      *              According to Action Code                         *
      *  SrEnblFld - Initialise Field Status on Main Details Screen   *
      *  SrInitFKSt - Initialise Function Key Status on the Main      *
      *               Details Screen                                  *
      *  SrCancelMain - Cancel on Main Details Screen                 *
      *  SrSndMsgMn - Send a Message to Main Details Screen           *
      *  SrDefWinFld - Default Window Fields                          *
      *  SrProcSettD - Process Settlement Screen Details              *
      *  SrDetPrmSett - Determine Parameters for Settlement Details   *
      *                 Screen                                        *
      *  SrCancelSett - Cancel on Settlement Details Screen           *
      *  SrExitSett - Exit From Settlement Details Screen             *
      *  SrProcConf - Process Confirmation of Input Screen            *
      *  SrCancelCnf - Cancel on Confirmation Screen                  *
      *  SrExitCnf - Exit from Confirmation Screen                    *
      *  SrUpdate - Update                                            *
      *  SRFeeBuy - Process Fees and Buyout details                   *
      *  SrEndPgm - End Program                                       *
      *  SRResetErr - Reset error fields                              *
      *  *INZSR - Program Initialisation routine                      *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layou
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** Include the FRA/IRS standard declares
     D***/COPY IRCPYSRC,STDDECLARE                                                          BUG11376
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
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
 
 
      ** Error array used by IRSBSDYVAL
     D MsgIdErr        S                   DIM(ArrayMax)
     D                                     LIKE(#MsgID)
 
      ** Array for fields in error
     D FldNamErr       S             10A   DIM(ArrayMax)
 
      ** Warning array used by IRSBSDYVAL
     D WMsgIdErr       S                   DIM(ArrayMax)
     D                                     LIKE(MsgIdArr)
 
      ** Array for fields in warning
     D WFldNamErr      S                   DIM(ArrayMax)
     D                                     LIKE(FldNameArr)
      **--------------------------------------------------------------------------------------------
 
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
      ** ZMUSER Data Area
     D ZMUSER          DS            17
     D  PkDBRC                11     13
 
      ** Current Deal in File Format
     D CrIRFilFmt    E DS                  EXTNAME(DEALSDG)
     D  WkCrAutDet          2201   2212                                                       CGL029
 
      ** Current Deal in Screen Format
     D CrIRScnFmt    E DS                  EXTNAME(IRCACFPD)
     D                                     PREFIX(@)
 
      ** New Deal in File Format
     D NwIRFilFmt    E DS                  EXTNAME(IRVCACFPD)
     D**RPREC***             716    784                                                       CGL029
     D**RPPAY***             785   1343                                                       CGL029
     D  RPREC                730    784                                                       CGL029
     D  RPPAY                799   1343                                                       CGL029
     D  RPIRS               1345   1992
     D  WkNwAutDet          2191   2202                                                       CGL029
 
      ** New Deal in Screen Format
     D NwIRScnFmt    E DS                  EXTNAME(IRCACFPD)
 
      ** Business Day Conventions layout
     D  BsDayConv            205    268
     D  RCcy1                239    268
 
      * Error indicators
     D IRECACF       E DS                  EXTNAME(IRECACFPD)
 
      ** File Receive instructions
     D PSRecF        E DS                  EXTNAME(SDESFRPD)
     D**FLREC**                1     69                                                       CGL029
     D  FLREC                 21     75                                                       CGL029
 
      ** File Payment Instructions
     D PSPayF        E DS                  EXTNAME(SDESFPPD)
     D**FLPAY**                1    559                                                       CGL029
     D   FLPAY                21    575                                                       CGL029
 
      ** File FRA/IRS Instructions
     D PSRsIF        E DS                  EXTNAME(SDESFFPD)
     D  FLIRS                  1    650
 
      ** Screen Reveive Instructions
     D PSRecS        E DS                  EXTNAME(SDESSRPD)
 
      ** Screen Payment Instructions
     D PSPayS        E DS                  EXTNAME(SDESSPPD)
 
      ** Screen FRA/IRS Instructions
     D PSRsIS        E DS                  EXTNAME(SDESSFPD)
 
      ** Caps/Collars/Floors Extra Data Layout - File (D/B) format
     D ExtData       E DS                  EXTNAME(IRCPEXPD)
 
      ** Receive / Pay Settlement Method & Nostro
     D PSETIN          DS
     D  PrRSCY                 1      3
     D  PrRSTM                 4      5  0
     D**PrRONS*                6     17                                                       CGL029
     D**PrPSCY*               18     20                                                       CGL029
     D**PrPSTM*               21     22  0                                                    CGL029
     D**PrPONS*               23     34                                                       CGL029
     D  PrRONS                 6     23                                                       CGL029
     D  PrPSCY                24     26                                                       CGL029
     D  PrPSTM                27     28  0                                                    CGL029
     D  PrPONS                39     46                                                       CGL029
 
      ** Current Control Indicators for Main Details Screen
     D WDSCurrInd      DS
     D  PEKyFd                 1      1
     D  PEDtFd                 2      2
     D  PEINKG                 3      3
     D  PEINKH                 4      4
     D  PEINKJ                 5      5
     D  PEINKN                 6      6
     D  PEINKP                 7      7
 
      ** Previous Control Indicators for Main Detail Screen
     D WDSPrevInd      DS             7
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Midas Modules Details Accessed via Access Program
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      ** External DS for Dealing Details
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
 
      ** External DS for SAR Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D  SCLCD        E                     EXTFLD(LCD)
 
      ** External DS for General Ledger Details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D  GelrACCD     E                     EXTFLD(QQACCD)                                     CGL029
 
      ** External data structure for FRA/IRS I.C.D. details
     D SDFAIS        E DS                  EXTNAME(SDFAISPD)
 
      ** External DS for Trade Details
     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
     D  TradACCD     E                     EXTFLD(QQACCD)                                     CGL029
 
      ** External data structure for Retail details
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
     D  RetlACCD     E                     EXTFLD(QQACCD)                                     CGL029
 
      ** First DS for Access Programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
     D/COPY QWINDSRC,IRCACFDTA
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')
 
      ** First pass flag
     D WFrstPas        S              1A   INZ('Y')
 
      ** Validate Business Day Convention flag
     D WValBDC         S              1A   INZ('N')
 
     D WrnFlag         S              1    INZ('N')
 
     D WSavRC1         S             30A
 
      ** Mode of operation received from controller
     D ModeOfOp        S              6A
 
      ** Parameters for Access Objects
     D PRtCd           S              7A
     D POptn           S              7A
     D PSarD           S              6A
 
      ** Parameters for Window
     D PPgm            S             10A
     D PFKey           S              2A
     D PAction         S              1A
     D PRtrn           S              7A
     D PSpareW         S            256A
 
      ** Parameters for IRCACFBRW
     D PBdSfl          S              1A
     D PRdSfl          S              1A
     D PErrMs          S              7A
     D POpSel          S              1A
     D PDlSel          S              6A
     D PINKC           S              1A
     D PINKL           S              1A
 
     D PEINKE          S              1A
     D PEINKL          S              1A
 
      ** Parameters for IRCACFRTV
     D PFOTrId         S             20A
     D PFOAsId         S             20A
 
      ** Parameters for IRCACFRED
     D PRdFwd          S              1A
     D PRdBck          S              1A
     D PDlRed          S              6A
     D PDlTyp          S              2A
     D PSingBrCd       S              3A
 
      ** Parameters for IRCACFAMD
     D PResetErrs      S              1A
     D PAmendOK        S              1A
 
      ** Parameters for ZASETINSIN
     D PSRtCd          S             10A
     D PSActn          S              1A
     D PSDlNo          S              6A
     D PSPPay          S              1A
     D PSPRec          S              1A
     D PSCalP          S              4A
     D PSPCcy          S              3A
     D PSRCcy          S              3A
     D PSCsNm          S             10A
     D PSTTyp          S              2A
     D PSFFnd          S              1A
     D PSBrcA          S              3A
     D PSDatR          S              5  0
     D PSDatP          S              5  0
 
      ** Parameters for ZASETINDFT
     D PBQISDA         S              4A
     D PBQAGTY         S              6A
     D PBQAGDT         S              6A
     D PBQAGVV         S              2A
     D PBQAGVC         S              2A
     D BlankSTYP       S              2A                                                      CSD095
     D BlankBRCA       S              3A                                                      CSD095
 
      ** Function keys
     D PINKE           S              1A
     D PINKG           S              1A
     D PINKH           S              1A
     D PINKJ           S              1A
     D PINKK           S              1A                                                    MD036070
     D PINKN           S              1A
     D PINKP           S              1A
 
      ** Switchable features
     D CDE001          S              1A
     D CEU003          S              1A
     D CIR001          S              1A
     D CIR005          S              1A
     D CIR006          S              1A
     D CIR008          S              1A                                                      CIR008
     D CAP041          S              1A
     D CAP056          S              1A                                                      CAP056
     D CSC011          S              1A
     D CIR007          S              1A
 
      ** Work fields used by CIR017                                                           CIR017
     D BsDayConv2      S            128A                                                      CIR017
     D POkFlagExt      S             44A                                                      CIR017
                                                                                              CIR017
      ** Other work variables
     D Idx             S              3  0
     D WIdx            S              3  0
     D WkScrn          S              1A
     D WkFRun          S              1A
     D WRdNBr          S              1A
     D WPrvScrn        S              1A
     D WPrvDNo         S              6A
     D WPrvACd         S              1A
     D WkMsg1          S              7A
     D WFntKey         S              2A
     D WSavBDC         S             64A
     D PGnDlNo         S              6A
     D PLCcy           S              3A
     D POKFlags        S             25A
     D POKFlags2       S             22A
     D PSucInsDN       S              6A
     D #1STAT          S             24A
     D W#DlNo          S              6  0
     D CANCFM          S              1A
     D E               S              3  0
     D PScreenInpt     S              1A                                                      CAP043
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
 
      ** Define workfields for Commitment Control Changes for Midas Plus                     BUG2603
     D CSC022          S              1A                                                     BUG2603
     D WSkpCom         S              1A                                                     BUG2603
     D WPos            S              2S 0                                                   BUG2603
                                                                                             BUG2603
     D InRCCY          S              3A                                                     CSF011A
     D InPCCY          S              3A                                                     CSF011A
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,IRCACFS009
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Read next browse subfile record
 
     C                   IF        WkScrn = 'R'
     C                   EXSR      SrRdNBrw
 
      ** If error is encountered, go back to initial screen and display the error
 
     C                   IF        Idx <> 0
     C                   EVAL      WkScrn = 'I'
     C                   ENDIF
 
     C                   ENDIF
 
      /COPY WNCPYSRC,IRCACF001
 
      ** Do while screen: Initial screen
 
     C                   DOW       WkScrn = 'I'
     C                   EXSR      SrProcInit
     C                   ENDDO
 
      /COPY WNCPYSRC,IRCACF002
 
      ** Do while screen: Main details
 
     C                   DOW       WkScrn = 'M'
     C                   EXSR      SrProcMnDet
     C                   ENDDO
 
      /COPY WNCPYSRC,IRCACF003
 
      ** Show fees/buyout Details if switched on
 
     C                   IF        WkScrn = 'F'
     C                   EXSR      SRFeeBuy
     C                   ENDIF
 
      ** Screen: Window
 
     C                   IF        WkScrn = 'W'
     C                   EXSR      SrProcWin
     C                   ENDIF
 
      /COPY WNCPYSRC,IRCACF004
 
      ** Do while screen: Settlement Details
 
     C                   DOW       WkScrn = 'S'
     C                   EXSR      SrProcSettD
     C                   ENDDO
 
      /COPY WNCPYSRC,IRCACF005
 
      ** Screen: Confirmation of Input
 
     C                   IF        WkScrn = 'C'
     C                   EXSR      SrProcConf
     C                   ENDIF
 
      /COPY WNCPYSRC,IRCACF006
 
      ** Perform File Updates
 
     C                   IF        WkScrn = 'U'
     C                   EXSR      SrUpdate
     C                   ENDIF
 
      /COPY WNCPYSRC,IRCACF007
 
      ** Terminate Program
 
     C                   IF        WkScrn = 'T'
     C                   EVAL      *INLR = *ON
     C                   ENDIF
 
      /COPY WNCPYSRC,IRCACF008
 
      *****************************************************************
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,IRCACFS010
 
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrProcInit - Process Initial Screen                          *
      *                                                               *
      *****************************************************************
     C     SrProcInit    BEGSR
 
      ** If windows processing is on, clear any possible updates
      ** in window function.
 
     C                   IF        BGWDPR = 'Y' AND CIR006 = 'Y'
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
 
      ** Enable all fields on initial screen as well as all function keys.
 
     C                   EVAL      PEINKE  = 'Y'
     C                   EVAL      PEINKG  = 'Y'
     C                   EVAL      PEINKH  = 'Y'
     C                   EVAL      PEINKP  = 'Y'
     C                   EVAL      PEINKL  = 'Y'
 
      ** Display initial screen.
 
     C                   CALLB     'IRCACFIDP'
 
      ** Input:
      ** Return Code
      ** Action code
      ** Deal Number
      ** Deal Type
      ** Succesful Insert Deal
 
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    #0DLNO
     C                   PARM                    #0ACCD
     C                   PARM                    #0DTYP
     C                   PARM                    PSucInsDN
 
      ** Enable function keys
      ** KE = Command key 05 = Refresh
      ** KG = Command key 07 = Read Previous
      ** KH = Command key 08 = Read Next
      ** KL = Command key 12 = Cancel
      ** KP = Command key 15 = Browse
 
     C                   PARM                    PEINKE
     C                   PARM                    PEINKG
     C                   PARM                    PEINKH
     C                   PARM                    PEINKL
     C                   PARM                    PEINKP
 
      ** OK Deal Number
      ** OK Action code
      ** OK Deal Type
 
     C                   PARM                    OKDLNO
     C                   PARM                    OKACCD
     C                   PARM                    OKDTYP
 
      ** Errors
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Warning
 
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
 
      ** Standing Data - System Run Date
 
     C                   PARM                    BJMRDT
 
      ** Output Parameters :
      ** Function keys enabled
      ** KC = Command key 03 = Exit
      ** KE = Command key 05 = Refresh
      ** KG = Command key 07 = Read Previous
      ** KH = Command key 08 = Read Next
      ** KL = Command key 12 = Cancel
      ** KP = Command key 15 = Browse
 
     C                   PARM                    PINKC
     C                   PARM                    PINKE
     C                   PARM                    PINKG
     C                   PARM                    PINKH
     C                   PARM                    PINKL
     C                   PARM                    PINKP
 
      ** Reset error fields.
 
     C                   EXSR      SrResetErr
 
     C                   SELECT
 
      ** F3 - end program
 
     C                   WHEN      PINKC = *ON
     C                   EXSR      SrEndPgm
 
      ** F5 - refresh initial screen details.
 
     C                   WHEN      PINKE = *ON
     C                   EVAL      #0ACCD = *BLANKS
     C                   EVAL      #0DLNO = *BLANKS
     C                   EVAL      #0DTYP = *BLANKS
 
      ** F7 - roll backwards
 
     C                   WHEN      PINKG = *ON
     C                   EXSR      SrRolBckFwd
     C                   IF        PDlRed <> *BLANKS AND Idx = 0
     C                   EVAL      WkScrn = 'M'
     C                   ENDIF
 
      ** F8 - roll forwards
 
     C                   WHEN      PINKH = *ON
     C                   EXSR      SrRolBckFwd
     C                   IF        PDlRed <> *BLANKS AND Idx = 0
     C                   EVAL      WkScrn = 'M'
     C                   ENDIF
 
      ** F12 - cancel on initial screen.
 
     C                   WHEN      PINKL = *ON
 
      ** Display initial screen with blank fields.
      ** Reset read next browse subfile record indicator.
 
     C                   EXSR      SRClrInit
     C                   EVAL      WRdNBr  = *BLANK
     C                   EVAL      WkScrn  = 'I'
 
      ** F15 - build browse.
 
     C                   WHEN      PINKP = *ON
     C                   EVAL      WPrvScrn = 'I'
     C                   EXSR      SrBldBrw
 
      ** Enter key was pressed.  Validate input to initial screen.
 
     C                   OTHER
 
     C                   EXSR      SrValidInit
 
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrValidInit - Validate Input to Initial Screen               *
      *                                                               *
      *****************************************************************
     C     SrValidInit   BEGSR
 
      ** Validate key fields and retrieve deal details
 
     C                   EXSR      SrRtvDlDet
 
      ** If action code, deal number or booking branch are NOT OK
      ** Re-output screen with error messages on it
 
     C                   IF        OKACCD = 'N' OR OKDLNO = 'N' OR
     C                             OKBRCA = 'N' OR OKDTYP = 'N'
     C                   GOTO      EValidInit
     C                   ENDIF
 
      ** Set field and function key status on main details screen
      ** (according to action code)
 
     C                   EXSR      SrSetFldSt
     C                   EXSR      SrSetFKSt
 
      ** New deal selected, Reset first pass flag and clear business
      ** day convention screen fields
 
     C                   IF        (CIR005 = 'Y') AND
     C                             ((#0DLNO <> WPrvDNo) OR (#0ACCD <> WPrvACd))
     C                             AND ((#0ACCD = 'I') OR (#0ACCD = 'A'))
     C                   EVAL      WFrstPas = 'Y'
     C                   EVAL      WSavBDC = *BLANKS
     C                   EVAL      BsDayConv = *BLANKS
     C                   ENDIF
 
      ** If action code is delete  or enquire or amend
      ** or Authorise and CIR008 is installed                                                 CIR008
      ** Put the deal on the main details screen
 
     C                   IF        #0ACCD = 'R' OR #0ACCD = 'E' OR
     C                             #0ACCD = 'A'
     C                             OR #0ACCD = 'X' AND CIR008 = 'Y'                           CIR008
     C                   EXSR      SrCvtToScn
     C                   ENDIF
 
     C                   EVAL      WkScrn = 'M'
 
     C     EValidInit    ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRClrInit - Clear Initial Screen                             *
      *                                                               *
      *****************************************************************
     C     SRClrInit     BEGSR
 
     C                   CLEAR                   #0DLNO
     C                   CLEAR                   #0ACCD
     C                   CLEAR                   #0DTYP
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrProcMnDet - Process Main Screen Details                    *
      *                                                               *
      *****************************************************************
     C     SrProcMnDet   BEGSR
 
      ** Issue rollback to clear any possible updates in window function
      ** Only required if deal number or action code has been changed
      ** (this check will also cater for F12 taken from main screen)
 
     C                   IF        BGWDPR = 'Y' AND CIR006 = 'Y'
     C                   IF        #0DLNO <> WPrvDNo OR #0ACCD <> WPrvACd OR
     C                             WDSCurrInd <> WDSPrevInd OR WkFRun = 'Y'
 
     C     CSC022        IFEQ      'N'                                                       BUG2603
     C                   ROLBK
     C                   ELSE                                                                BUG2603
     C     WSkpCom       IFNE      'Y'                                                       BUG2603
     C                   ROLBK                                                               BUG2603
     C                   ELSE                                                                BUG2603
     C                   SETON                                        U7U8                   BUG2603
     C                   ENDIF                                                               BUG2603
     C                   ENDIF                                                               BUG2603
     C                   EVAL      WkFRun = *BLANKS
 
     C                   ENDIF
     C                   ENDIF
 
      ** Update 'previous' deal number & screen control indicator
 
     C                   MOVEL     #0DLNO        WPrvDNo
     C                   MOVEL     #0ACCD        WPrvACd
     C                   MOVEL     WDSCurrInd    WDSPrevInd
 
      ** Write/Read Display Screen
 
     C                   CALLB     'IRCACF1DP'
 
      ** Input:
      ** Return Code
      ** Deal (screen format)
      ** Current Deal in file format
      ** Deal status
      ** Fields in error
 
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    NwIRScnFmt
     C                   PARM                    CrIRFilFmt
     C                   PARM                    #1STAT
     C                   PARM                    IRECACF
 
      ** Errors
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Warnings
 
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
 
      ** Enable Key and Detail Fields
 
     C                   PARM                    PEKyFd
     C                   PARM                    PEDtFd
 
      ** Enable Function Keys
 
     C                   PARM                    PEINKG
     C                   PARM                    PEINKH
     C                   PARM                    PEINKJ
     C                   PARM                    PEINKN
     C                   PARM                    PEINKP
 
      ** Amortisation of Caps/Collars/Floors
      ** EMU Dealing Settlement Ccy Conversion
 
     C                   PARM                    CIR006
     C                   PARM                    CEU003
 
      ** Outputs:
      ** Function Keys
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKG
     C                   PARM      '0'           PINKH
     C                   PARM      '0'           PINKJ
     C                   PARM      '0'           PINKL
     C                   PARM      '0'           PINKN
     C                   PARM      '0'           PINKP
     C                   PARM      'N'           WriteOnly
 
      ** Reset errors
 
     C                   EXSR      SrResetErr
 
     C                   SELECT
 
      ** F3 to Exit
 
     C                   WHEN      PINKC = '1'
     C                   EXSR      SrEndPgm
 
      ** F7 to Roll Backwards
 
     C                   WHEN      PINKG = '1'
     C                   EXSR      SrRolBckFwd
     C                   IF        Idx <> 0
     C                   EVAL      WkScrn = 'I'
     C                   ENDIF
 
      ** F8 to Roll Forwards
 
     C                   WHEN      PINKH = '1'
     C                   EXSR      SrRolBckFwd
     C                   IF        Idx <> 0
     C                   EVAL      WkScrn = 'I'
     C                   ENDIF
 
      ** F12 to Cancel on main details screen
 
     C                   WHEN      PINKL = '1'
     C                   EXSR      SrCancelMain
 
      ** F15 to Build Browse
 
     C                   WHEN      PINKP = '1'
     C                   EVAL      WPrvScrn = 'M'
     C                   EXSR      SrBldBrw
 
      ** Validate input to main details screen
 
     C                   OTHER
 
     C                   EXSR      SrValidMain
 
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrValidMain - Validate Input to Main Details Screen          *
      *                                                               *
      *****************************************************************
     C     SrValidMain   BEGSR
 
      ** If deal number or screen control indicators have changed
      ** Re-output screen
 
     C                   IF        #0DLNO <> WPrvDNo AND #0ACCD <> 'I' OR
     C                             #0ACCD <> WPrvACd OR
     C                             WDSCurrInd <> WDSPrevInd
     C                   GOTO      EValidMain
     C                   ENDIF
 
      ** If Delete
 
     C                   IF        #0ACCD = 'R'
 
      ** Update Deal in File Format
 
     C                   EVAL      NwIRFilFmt = CrIRFilFmt
     C                   EVAL      WkNwAutDet = WkCrAutDet                                    CGL029
     C                   MOVEL     URACC         RPURACC                                      CGL029
     C                   MOVEL     UPACC         RPUPACC                                      CGL029
     C                   MOVEL     RONS          RPRONS                                       CGL029
     C                   MOVEL     PONS          RPPONS                                       CGL029
 
      ** If F10 is taken, go to updates
 
     C                   IF        PINKJ = '1'
     C                   EVAL      WkScrn = 'U'
     C                   ELSE
     C                   IF        (CIR005 = 'Y') And (BsDayConv <> *Blank)
     C                   EXSR      SrProcBusDy
 
      ** F12 pressed, back to main screen
 
     C                   IF        WFntKey = '12'
     C                   EVAL      WkScrn = 'M'
     C                   EVAL      WFntKey = *Blank
     C                   GOTO      EValidMain
     C                   ENDIF
 
      ** F3 pressed, end program
 
     C                   IF        WFntKey = '03'
     C                   EXSR      SrEndPgm
     C                   GOTO      EValidMain
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
     C                   GOTO      EValidMain
     C                   ENDIF
 
      ** If Enquire
 
     C                   IF        #0ACCD = 'E'
 
      ** Update Deal in File Format
 
     C                   EVAL      NwIRFilFmt = CrIRFilFmt
     C                   EVAL      WkNwAutDet = WkCrAutDet                                    CGL029
     C                   MOVEL     URACC         RPURACC                                      CGL029
     C                   MOVEL     UPACC         RPUPACC                                      CGL029
     C                   MOVEL     RONS          RPRONS                                       CGL029
     C                   MOVEL     PONS          RPPONS                                       CGL029
 
      ** If F14 taken, continute to settlements screen
      ** If Fees/buyouts switched on, show the details
      ** If windows processing on, call window routine
      ** If Browse outstanding, read next browse subfile record
 
     C                   IF        PINKN = '1'
     C                   EVAL      WkScrn = 'S'
     C                   ELSE
 
     C                   IF        CAP041 = 'Y'
     C                             AND CIR006 = 'Y'                                         AR218555
     C                   EVAL      WkScrn = 'F'
     C                   ELSE
 
     C                   IF        BGWDPR = 'Y' AND CIR006 = 'Y'
     C                   EVAL      WkScrn = 'W'
     C                   ELSE
 
     C                   IF        WRdNBr = 'Y'
     C                   EVAL      WkScrn = 'R'
     C                   ENDIF
     C
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        (CIR005 = 'Y') And (PINKN = '0') AND
     C                             (BsDayConv <> *Blank)
     C                   EXSR      SrProcBusDy
 
      ** F12 pressed, back to main screen
 
     C                   IF        WFntKey = '12'
     C                   EVAL      WkScrn= 'M'
     C                   EVAL      WFntKey = *Blank
     C                   GOTO      EValidMain
     C                   ENDIF
 
      ** F3 pressed, end program
 
     C                   IF        WFntKey = '03'
     C                   EXSR      SrEndPgm
     C                   GOTO      EValidMain
     C                   ENDIF
 
     C                   ENDIF
 
     C                   GOTO      EValidMain
     C                   ENDIF
                                                                                              CIR008
      ** If Authorise                                                                         CIR008
                                                                                              CIR008
     C                   IF        #0ACCD = 'X'                                               CIR008
                                                                                              CIR008
      ** Update Deal in File Format                                                           CIR008
                                                                                              CIR008
     C                   EVAL      NwIRFilFmt = CrIRFilFmt                                    CIR008
     C                   EVAL      WkNwAutDet = WkCrAutDet                                    CGL029
     C                   MOVEL     URACC         RPURACC                                      CGL029
     C                   MOVEL     UPACC         RPUPACC                                      CGL029
     C                   MOVEL     RONS          RPRONS                                       CGL029
     C                   MOVEL     PONS          RPPONS                                       CGL029
                                                                                              CIR008
      ** If windows processing on, call window routine                                        CIR008
      ** If Browse outstanding, read next browse subfile record                               CIR008
                                                                                              CIR008
     C                   IF        BGWDPR = 'Y' AND CIR006 = 'Y'                              CIR008
     C                   EVAL      WkScrn = 'W'                                               CIR008
     C                   ELSE                                                                 CIR008
                                                                                              CIR008
     C                   IF        WRdNBr = 'Y'                                               CIR008
     C                   EVAL      WkScrn = 'R'                                               CIR008
     C                   ELSE                                                                 CIR008
     C                   EVAL      WkScrn = 'S'                                               CIR008
     C                   ENDIF                                                                CIR008
                                                                                              CIR008
     C                   ENDIF                                                                CIR008
                                                                                              CIR008
     C                   IF        (CIR005 = 'Y') And                                         CIR008
     C                             (BsDayConv <> *Blank)                                      CIR008
     C                   EXSR      SrProcBusDy                                                CIR008
                                                                                              CIR008
      ** F12 pressed, back to main screen                                                     CIR008
                                                                                              CIR008
     C                   IF        WFntKey = '12'                                             CIR008
     C                   EVAL      WkScrn= 'M'                                                CIR008
     C                   EVAL      WFntKey = *Blank                                           CIR008
     C                   GOTO      EValidMain                                                 CIR008
     C                   ENDIF                                                                CIR008
                                                                                              CIR008
      ** F3 pressed, end program                                                              CIR008
                                                                                              CIR008
     C                   IF        WFntKey = '03'                                             CIR008
     C                   EXSR      SrEndPgm                                                   CIR008
     C                   GOTO      EValidMain                                                 CIR008
     C                   ENDIF                                                                CIR008
     C                   ENDIF                                                                CIR008
                                                                                              CIR008
     C                   GOTO      EValidMain                                                 CIR008
     C                   ENDIF                                                                CIR008
 
      ** If Insert or Amend
 
     C                   IF        #0ACCD = 'I' OR #0ACCD = 'A'
 
      ** Prior to validation, initialize error indicators as 'OK'
      ** and clear Deal in File Format
 
     C                   Z-ADD     *ZERO         Idx
     C                   Z-ADD     *ZERO         WIdx
     C                   MOVE      *ALL'Y'       IRECACF
     C                   CLEAR                   NwIRFilFmt
     C                   Z-ADD     *ZERO         RPRSTM
     C**********         Z-ADD     *ZERO         RPROBN                                       CSD027
     C**********         Z-ADD     *ZERO         RPROCN                                       CSD027
     C                   Z-ADD     *ZERO         RPPSTM
     C**********         Z-ADD     *ZERO         RPPOBN                                       CSD027
     C**********         Z-ADD     *ZERO         RPPOCN                                       CSD027
     C                   Z-ADD     *ZERO         RPUNPCD                                      CAP043
     C                   Z-ADD     *ZERO         RPTNPCD                                      CAP043
 
      ** If first pass to the main screen and Business Day Conventions
      ** enhancement is switched on, skip validation of rate change
      ** dates and interest payment dates against the Business Day
      ** Convention currencies (WValBDC = 'N').
 
     C                   IF        (CIR005 = 'Y') And (WFrstPas = 'Y')
     C                   EVAL      WValBDC = 'N'
     C                   ENDIF
 
      ** If Amend
 
     C                   IF        #0ACCD = 'A'
 
      ** Update Deal in File Format
 
     C                   MOVEL     CrIRFilFmt    NwIRFilFmt
     C                   EVAL      WkNwAutDet = WkCrAutDet                                    CGL029
     C                   MOVEL     URACC         RPURACC                                      CGL029
     C                   MOVEL     UPACC         RPUPACC                                      CGL029
     C                   MOVEL     RONS          RPRONS                                       CGL029
     C                   MOVEL     PONS          RPPONS                                       CGL029
 
      ** Validate whether non-amenable fields have been changed
 
     C                   CALLB     'IRCACFAMD'
 
      ** Inputs:
      ** Return Code
      ** New Deal in Screen Format
      ** Current Deal in Screen Format
      ** Current Deal in file format
      ** Reset of Fields in Error Required (Y/N)
 
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    NwIRScnFmt
     C                   PARM                    CrIRScnFmt
     C                   PARM                    CrIRFilFmt
     C                   PARM      'Y'           PResetErrs
 
      ** Run Day number from SDBANKPD
      ** Portfolio Management module (from SDMMODPD)
      ** Multi Branching Indicator From SDMMODPD
      ** Profit Centres Used from SDGELRPD
      ** Profit Centres Amendable from SDGELRPD
      ** Originating Branch Used from SDGELRPD
 
     C                   PARM                    BJRDNB
     C                   PARM                    BGPFMG
     C                   PARM                    BGMBIN
     C                   PARM                    BKPRCU
     C                   PARM                    BKPRCA
     C                   PARM                    BKOBRU
      ** Interest Rate Calendars
      ** Amortisation of Caps/Collars/Floors & Indiv. Compounding Swaps
      **
     C                   PARM                    CIR001
     C                   PARM                    CIR006
 
      ** Outputs:
      ** Field OK flags (DS) from/to caller
 
     C                   PARM                    IRECACF
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM      0             Idx
 
      ** Amendments OK
 
     C                   PARM                    PAmendOk
 
      ** Reset of Fields in Error Required (Y/N)
 
     C                   ENDIF
 
      ** Validate deal details
 
     C                   CALLB     'IRCACFVAL'
 
      ** Inputs:
      ** Mode of Operation Received from Controller
      ** Response Mode
      ** Current Caps/Collars/Florrs deal Screen format
      ** New Caps/Collars/Floors deal Screen format
 
     C                   PARM                    ModeOfOp
     C                   PARM                    RespMode
     C                   PARM                    CrIRScnFmt
     C                   PARM                    NwIRScnFmt
 
      ** Receipt Settlement Currency
      ** Receipt Settlement Method
      ** Receipt Settlement Nostro
      ** Pay Settlement Currency
      ** Pay Settlement Method
      ** Pay Settlement Nostro
      ** Caps/Collars/Floors Extra Data Layout File
      ** Validate Business Day Convention flag
 
     C                   PARM      RPRSCY        PrRSCY
     C                   PARM      RPRSTM        PrRSTM
     C                   PARM      RPRONS        PrRONS
     C                   PARM      RPPSCY        PrPSCY
     C                   PARM      RPPSTM        PrPSTM
     C                   PARM      RPPONS        PrPONS
     C                   PARM                    ExtData
     C                   PARM                    WValBDC
 
      ** Bank details
      ** Module details
      ** Deal details
      ** General Ledger details
      ** Trading details
      ** FRA/IRS ICD details
      ** ZMUSER Data Area
 
     C                   PARM                    SDBANK
     C                   PARM                    SDMMOD
     C                   PARM                    SDDEAL
     C                   PARM                    SDGELR
     C                   PARM                    SDTRAD
     C                   PARM                    SDFAIS
     C                   PARM                    ZMUSER
 
      ** Switchable Features
 
     C                   PARM                    CIR001
     C                   PARM                    CIR005
     C                   PARM                    CIR006
     C                   PARM                    CIR007
 
      ** Outputs:
      ** Caps/Collars/Floors deal OK Indicators
 
     C                   PARM                    IRECACF
 
      ** Error Message Arrays and Index
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
 
      ** Warning Message Arrays and Index
 
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
 
      ** Valid Caps/Collars/Floors deal File format
 
     C                   PARM                    NwIRFilFmt
      ***Sign*of Short Term Rate                                                     BUG5707 BUG6472
     C**********         PARM                    #0SIGN            1                 BUG5707 BUG6472
 
      ** If errors returned
 
     C                   IF        Idx <> 0
     C                   GOTO      EValidMain
     C                   ENDIF
 
      ** No error on validation, display business day convention input
      ** screen.
 
     C                   IF        (CIR005 = 'Y') And (WFrstPas = 'Y')
 
      ** Save previous Business Day Convention input
 
     C                   IF        BsDayConv <> *BLANKS
     C                   MOVEL     BsDayConv     WSavBDC
     C                   ENDIF
 
      ** First pass, display BDC input screen
 
     C                   EXSR      SrProcBusDy
 
      ** F12 pressed, back to main screen
 
     C                   IF        WFntKey = '12'
     C                   EVAL      WkScrn= 'M'
     C                   EVAL      WFntKey = *Blank
 
      ** Put back business day convention details only when the previous
      ** detail workfield is not blank
 
     C                   IF        WSavBDC <> *Blank
     C                   EVAL      BsDayConv = WSavBDC
     C                   ELSE
     C                   EVAL      BsDayConv = *Blank
     C                   ENDIF
 
     C                   GOTO      EValidMain
     C                   ENDIF
 
      ** F3 pressed, end program
 
     C                   IF        WFntKey = '03'
     C                   EXSR      SrEndPgm
     C                   GOTO      EValidMain
     C                   ENDIF
 
      ** No error found on call to Business Day Convention
 
     C                   IF        WFrstPas = 'Y' AND WValBDC = 'N'
     C                   EVAL      WValBDC = 'Y'
     C                   EVAL      WFrstPas = 'N'
     C                   EVAL      WkScrn= 'M'
     C                   GOTO      EValidMain
     C                   ENDIF
 
     C                   GOTO      EValidMain
 
     C                   ENDIF
 
      ** If CAP041 is On, display screen for buy-out else check windows
      ** processing
     C                   IF        CAP041 = 'Y'
     C                             AND CIR006 = 'Y'                                         AR218555
     C                   EVAL      WkScrn = 'F'
     C                   ELSE
 
      ** If windows processing on, call window routine
      ** otherwise, continue to settlements screen
 
     C                   IF        BGWDPR = 'Y' AND CIR006 = 'Y'
     C                   EVAL      WkScrn = 'W'
     C                   ELSE
 
      ** If insert and CIR001 is switched, default window fields
 
     C                   IF        #0ACCD = 'I' AND CIR001 = 'Y'
     C                   EXSR      SrDefWinFld
     C                   ENDIF
 
     C                   EVAL      WkScrn = 'S'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C     EValidMain    ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFeeBuy - Process Fees and Buyout details                   *
      *                                                               *
      *****************************************************************
     C     SRFeeBuy      BEGSR
                                                                                              209372
      ** If deal number not defined (on insert), get next available deal number               209372
                                                                                              209372
     C                   IF        #0DLNO = *BLANK AND #0ACCD = 'I' AND                       209372
     C                             WKFRUN <> 'Y'                                              209372
                                                                                              209372
     C                   CALLB     'CAGETNXTDL'                                               209372
     C                   PARM      *BLANKS       RetCodeOut                                   209372
     C                   PARM      *BLANKS       WkMsg1                                       209372
     C                   PARM                    PGnDlNo                                      209372
     C                   PARM      *ZERO         RPDLNO                                       209372
                                                                                              209372
     C                   IF        WkMsg1 <> *BLANK                                           209372
     C     *LOCK         IN        LDA                                                        209372
     C                   EVAL      DBFILE = 'CAGTNXDL'                                        209372
     C                   EVAL      DBASE = 21                                                 209372
     C                   EVAL      DBKEY = #0DLNO                                             209372
     C                   OUT       LDA                                                        209372
     C                   EXSR      *PSSR                                                      209372
     C                   ENDIF                                                                209372
                                                                                              209372
     C                   MOVE      PGnDlNo       #0DLNO                                       209372
                                                                                              209372
      ** Set up the work field indicating the Deal No. allocation has run                     209372
                                                                                              209372
     C                   EVAL      WkFRun = 'Y'                                               209372
                                                                                              209372
     C                   ENDIF                                                                209372
 
      ** If details have changed, populate fields
 
     C                   MOVE      #0DLNO        W#DlNo
     C                   IF        #0ACCD <> #1ACTN OR W#DlNo <> #1DLNO AND
     C                             W#DlNo <> *ZEROS
     C                   EVAL      CANCFM = 'N'
     C                   ENDIF
 
      ** Populate fields in 'DATA' to be passed to IRS details pgm
      ** (If cancel not taken from confirmation screen)
 
     C                   IF        CANCFM <> 'Y'
 
     C/COPY QWINDSRC,IRCACFMOV1
 
     C                   ENDIF
 
      ** Call Fees and Buyouts program
 
     C                   CALL      'IRFEBOSIN'
     C                   PARM      *BLANKS       PRtrn
     C                   PARM                    DATA
     C                   PARM                    CANCFM
     C
      *
      ** Process returned command keys
      *
     C                   SELECT
      *
      ** F3 pressed
     C                   WHEN      PRtrn = 'Y2U9999'
     C                   EXSR      SrEndPgm
 
     C                   WHEN      PRtrn = 'USR0790'
 
      ** If read next browse is 'Y', browse next record
     C                   IF        WRdNBr = 'Y'
     C                   EVAL      WkScrn = 'R'
     C                   GOTO      EndFeeBuy
     C                   ENDIF
      *
      ** Else, go to main screen
     C                   EVAL      WkScrn = 'M'
 
     C                   IF        CIR005 = 'Y'
     C                   EVAL      WFrstPas = 'Y'
     C                   ENDIF
 
     C                   OTHER
 
     C**********         IF        #0ACCD = 'E'                                               209372
     C                   IF        #0ACCD <> 'E'                                              209372
 
     C/COPY QWINDSRC,IRCACFMOV2
 
     C                   ENDIF
 
      ** If Window processing on show window, otherwise
 
     C                   IF        BGWDPR = 'Y'
     C                   EVAL      WkScrn = 'W'
     C                   GOTO      EndFeeBuy
     C                   ENDIF
 
      ** If in enquiry mode, go to main screen or read next browse record
 
     C                   IF        #0ACCD = 'E'
 
     C                   IF        WRdNBr = 'Y'
     C                   EVAL      WkScrn = 'R'
     C                   ELSE
     C                   EVAL      WkScrn = 'M'
     C                   ENDIF
 
     C                   GOTO      EndFeeBuy
     C                   ENDIF
 
      ** Otherwise, go to settlements screen
 
     C                   EVAL      WkScrn = 'S'
     C
     C                   ENDSL
 
     C     EndFEEBUY     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrProcBusDy - Proess Business Day Convention                 *
      *                                                               *
      *****************************************************************
     C     SrProcBusDy   BEGSR
 
     C                   EVAL      POkFlags = *All'Y'
     C                   EVAL      WMsgIdErr = *BLANKS
     C                   EVAL      WSavRC1 = *BLANKS
     C                   EVAL      MsgIdErr = *BLANKS
 
      ** Do until F3 or F12 is pressed or all screen fields are valid.
 
     C                   DOU       MsgIdErr(1) = *BLANKS AND
     C                             WrnFlag = 'N'  OR
     C                             WFntKey = '03' OR
     C                             WFntKey = '12'
 
     C                   EVAL      WrnFlag = 'N'
 
      ** Display screen fields
 
      ** Use extended fields due to change in layout in PF/IRSBDYPD                           CIR017
      ** and additional fields to validate on display when CIR017                             CIR017
      ** is incorporated                                                                      CIR017
                                                                                              CIR017
     C                   EVAL      BsDayConv2 = BsDayConv                                     CIR017
     C                   EVAL      POkFlagExt = POKFlags                                      CIR017
      *                                                                                       CIR017
     C                   CALLB     'IRSBDYDSP'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    #0ACCD
     C                   PARM                    #0DLNO
     C**********         PARM                    POkFlags                                     CIR017
     C                   PARM                    POkFlagExt                                   CIR017
     C                   PARM                    MsgIdErr
     C                   PARM                    WMsgIdErr
     C                   PARM                    BJMRDT
     C**********         PARM                    BsDayConv                                    CIR017
     C                   PARM                    BsDayConv2                                   CIR017
     C                   PARM      *BLANKS       WFntKey
 
     C                   If        WFntKey <> '03' AND WFntKey <> '12' AND
     C                             #0ACCD = 'I' OR WFntKey <> '03' AND
     C                             WFntKey <> '12' AND #0ACCD = 'A'
 
     C                   MOVEL     POKFlags      POKFlags2
                                                                                              CIR017
      ** Reset original values for subsequent processing                                      CIR017
     C                   EVAL      BsDayConv  = BsDayConv2                                    CIR017
     C                   EVAL      POkFlags   = POKFlagExt                                    CIR017
 
      ** Validate all screen fields when action code is I or A.
 
      ** Use extended fields due to change in layout in PF/IRSBDYPD                           CIR017
     C                   EVAL      BsDayConv2 = BsDayConv                                     CIR017
     C                   EVAL      POkFlagExt = POKFlags2                                     CIR017
      *
     C                   CALLB     'IRSBDYVAL'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    #0ACCD
     C                   PARM                    PLCcy
     C**********         PARM                    POkFlags2                                    CIR017
     C                   PARM                    POkFlagExt                                   CIR017
     C                   PARM      *BLANKS       MsgIdErr
     C                   PARM                    FldNamErr
     C                   PARM      *BLANKS       WMsgIdErr
     C                   PARM                    WFldNamErr
     C**********         PARM                    BsDayConv                                    CIR017
     C                   PARM                    BsDayConv2                                   CIR017
 
     C                   MOVEL     POKFlags2     POKFlags
                                                                                              CIR017
      ** Reset original values for subsequent processing                                      CIR017
     C                   EVAL      BsDayConv  = BsDayConv2                                    CIR017
     C                   EVAL      POkFlags2  = POKFlagExt                                    CIR017
 
     C                   IF        WMsgIdErr(1) <> *BLANKS AND
     C                             WSavRC1 <> RCcy1
     C                   EVAL      WrnFlag = 'Y'
     C                   ENDIF
 
     C                   EVAL      WSavRC1 = RCcy1
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrProcWin - Process Window Screen                            *
      *                                                               *
      *****************************************************************
     C     SrProcWin     BEGSR
 
      ** Reset erros
 
     C                   EXSR      SrResetErr
 
      ** Write out screen to remove error messages
 
     C                   CALLB     'IRCACF1DP'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    NwIRScnFmt
     C                   PARM                    CrIRFilFmt
     C                   PARM                    #1STAT
     C                   PARM                    IRECACF
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    PEKyFd
     C                   PARM                    PEDtFd
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
 
      ** If deal number not defined (on insert), get next available deal number
 
     C                   IF        #0DLNO = *BLANK
 
     C                   CALLB     'CAGETNXTDL'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM      *BLANKS       WkMsg1
     C                   PARM                    PGnDlNo
     C                   PARM      *ZERO         RPDLNO
 
     C                   IF        WkMsg1 <> *BLANK
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'CAGTNXDL'
     C                   EVAL      DBASE = 19
     C                   EVAL      DBKEY = #0DLNO
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Set up the work field indicating the Deal No. allocation has run
 
     C                   EVAL      WkFRun = 'Y'
 
     C                   ENDIF
 
     C                   IF        CAP041 = 'Y'
     C                   MOVEL     'IRCACFSINX'  PPgm
     C                   ELSE
     C                   MOVEL     'IRCACFSIN'   PPgm
 
     C/COPY QWINDSRC,IRCACFMOV1
     C                   ENDIF
 
     C                   CALL      'WN0010'
     C                   PARM                    PPgm
     C                   PARM                    PFKey
     C                   PARM      #0ACCD        PAction
     C                   PARM                    DATA
     C                   PARM      *BLANKS       PRtrn
     C                   PARM                    PSpareW
 
      ** Process returned command keys
 
     C                   IF        PRtrn = 'Y2U9999'
     C                   EXSR      SrEndPgm
     C                   ELSE
 
      ** If Cmd12 pressed AND Fee/Buyout is on, show F/B details otherwise
      ** go to main screen or read next browse record
 
     C                   IF        PRtrn = 'USR0790'
      *
     C                   IF        CAP041 = 'Y'
     C                             AND CIR006 = 'Y'                                         AR218555
     C                   EVAL      WkScrn = 'F'
     C                   ELSE
 
     C                   IF        WRdNBr = 'Y'
     C                   EVAL      WkScrn = 'R'
     C                   ELSE
 
     C                   EVAL      WkScrn = 'M'
 
     C                   IF        CIR005 = 'Y'
     C                   EVAL      WFrstPas = 'Y'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ELSE
 
      ** If Cmd12 not pressed;
      ** If in enquiry mode, go to main screen or read next browse record
      ** otherwise, go to settlements screen
 
     C                   IF        #0ACCD = 'E'
 
     C                   IF        WRdNBr = 'Y'
     C                   EVAL      WkScrn = 'R'
     C                   ELSE
     C                   EVAL      WkScrn = 'M'
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        CAP041 <> 'Y'
     C/COPY QWINDSRC,IRCACFMOV2
     C                   ENDIF
 
     C                   EVAL      WkScrn = 'S'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C     EWind         ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrRolBckFwd- Roll Backwards & Forwards through the file      *
      *                                                               *
      *****************************************************************
     C     SrRolBckFwd   BEGSR
 
      ** Default action code to enquiry if not valid
 
     C                   IF        #0ACCD <> 'A' AND #0ACCD <> 'R'
     C                             AND CIR008 = 'N' OR                                        CIR008
     C                             #0ACCD <> 'A' AND #0ACCD <> 'R' AND                        CIR008
     C                             #0ACCD <> 'X' AND CIR008 = 'Y'                             CIR008
     C                   EVAL      #0ACCD = 'E'
     C                   ENDIF
 
      ** Read next(if F8) or previous(if F7) record on Deals file
 
     C                   IF        PINKG = '1'
     C                   EVAL      PRdFwd = *BLANK
     C                   EVAL      PRdBck = 'Y'
     C                   ELSE
     C                   EVAL      PRdFwd = 'Y'
     C                   EVAL      PRdBck = *BLANK
     C                   ENDIF
 
     C                   CALLB     'IRCACFRED'
 
      ** Input:
      ** Return Code
      ** Action Code
      ** Deal Number pointer
 
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    #0ACCD
     C                   PARM                    #0DLNO
 
      ** Read Forwards
      ** Read Backwards
      ** Single Branch Code from SDBANKPD
      ** FRA/IRS Deals Authorisation                                                          CIR008
 
     C                   PARM                    PRdFwd
     C                   PARM                    PRdBck
     C                   PARM                    PSingBrCd
     C                   PARM                    CIR008                                       CIR008
 
      ** Output:
      ** Error meassage
      ** Deal read
      ** Deal Type
 
     C                   PARM      *BLANK        PErrMs
     C                   PARM      *BLANK        PDlRed
     C                   PARM      *BLANK        PDlTyp
 
     C                   IF        PDlRed <> *BLANKS
     C                   EVAL      #0DTYP = PDlTyp
     C                   ENDIF
 
      ** If error message returned from read, send it to detail screen
 
     C                   IF        PErrMs <> *BLANKS
     C                   EXSR      SrSndMsgMn
     C                   GOTO      ERoll
     C                   ENDIF
 
      ** If deal read
 
     C                   IF        PDlRed <> *BLANKS
 
      ** Retrieve deal details
 
     C                   MOVEL     PDlRed        #0DLNO
     C                   EXSR      SrRtvDlDet
     C                   IF        Idx <> 0
     C                   GOTO      ERoll
     C                   ENDIF
 
      ** Set field and function key status on main details screen
      ** (according to action code)
 
     C                   EXSR      SrSetFldSt
     C                   EXSR      SrSetFKSt
 
     C                   IF        CIR005 = 'Y'
     C                   CLEAR                   BsDayConv
     C                   ENDIF
 
      ** Put the deal on the main details screen
 
     C                   EXSR      SrCvtToScn
     C                   ENDIF
 
     C     ERoll         ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrBldBrw - Build Browse Subfile                              *
      *                                                               *
      *****************************************************************
     C     SrBldBrw      BEGSR
 
      ** Reset read next browse subfile record
 
     C                   MOVEL     *BLANK        WRdNBr
 
      ** Build browse subfile
 
     C                   CALLB     'IRCACFBRW'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    #0ACCD
     C                   PARM                    #0DLNO
     C                   PARM                    #0DTYP
     C                   PARM      'Y'           PBdSfl
     C                   PARM      *BLANK        PRdSfl
     C                   PARM                    CIR008                                       CIR008
     C                   PARM      *BLANK        PErrMs
     C                   PARM      *BLANK        POpSel
     C                   PARM      *BLANK        PDlSel
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKL
 
      ** F3 to Exit
 
     C                   IF        PINKC = '1'
     C                   EXSR      SrEndPgm
     C                   GOTO      EBldBr
     C                   ENDIF
 
     C                   IF        PINKL = '1'
     C                   EVAL      WkScrn = WPrvScrn
     C                   GOTO      EBldBr
     C                   ENDIF
 
      ** If error message returned from browse, send it to detail screen
 
     C                   IF        PErrMs <> *BLANKS
     C                   EXSR      SrSndMsgMn
     C                   GOTO      EBldBr
     C                   ENDIF
 
      ** If CK/12 not taken in browse
      ** Read next browse subfile record
 
     C                   IF        PINKL <> '1'
     C                   EVAL      WRdNBr = 'Y'
     C                   EVAL      WkScrn = 'R'
     C                   ENDIF
 
     C     EBldBr        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrRdNBrw - Read Next Browse Subfile Record                   *
      *                                                               *
      *****************************************************************
     C     SrRdNBrw      BEGSR
 
      ** Read Next Subfile record
 
     C                   CALLB     'IRCACFBRW'
 
      ** Input:
      ** Return Code
      ** Action Code
      ** Deal Number Pointer
      ** Build Subfile
      ** Read Subfile record
      ** FRA/IRS Deals Authorisation                                                          CIR008
 
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    #0ACCD
     C                   PARM                    #0DLNO
     C                   PARM                    #0DTYP
     C                   PARM      *BLANK        PBdSfl
     C                   PARM      'Y'           PRdSfl
     C                   PARM                    CIR008                                       CIR008
 
      ** Output:
      ** Error Message
      ** Option Selected
      ** Deal Number Selected
 
     C                   PARM      *BLANK        PErrMs
     C                   PARM      *BLANK        POpSel
     C                   PARM      *BLANK        PDlSel
 
      ** Command Keys
 
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKL
 
      ** If a deal is read from subfile
 
     C                   IF        PDlSel <> *BLANK
 
      ** Retrieve deal details
 
     C                   MOVEL     POpSel        #0ACCD
     C                   MOVEL     PDlSel        #0DLNO
     C                   EXSR      SrRtvDlDet
     C                   IF        Idx <> 0
     C                   GOTO      ERdNBrw
     C                   ENDIF
 
      ** Set field and function key status on main details screen
      ** (according to action code)
 
     C                   EXSR      SrSetFldSt
     C                   EXSR      SrSetFKSt
 
      ** Put the deal on the main details screen
 
     C                   EXSR      SrCvtToScn
 
      ** Else, reset read next browse subfile record
 
     C                   ELSE
     C                   EVAL      WRdNBr = *BLANKS
     C                   ENDIF
 
     C                   IF        WRdNBr = *BLANKS
     C                   EVAL      WkScrn = 'I'
     C                   ELSE
     C                   EVAL      WkScrn = 'M'
     C                   ENDIF
 
     C                   IF        CIR005 = 'Y'
     C                   EVAL      WFrstPas = 'Y'
     C                   ENDIF
 
     C     ERdNBrw       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrRtvDlDet -  Retrieve Deal Details                          *
      *                                                               *
      *****************************************************************
     C     SrRtvDlDet    BEGSR
 
     C                   CALLB     'IRCACFRTV'
 
      ** Input:
      ** Return code
      ** Mode = '*FRONT' or *BLANK
      ** Response mode
 
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM      '      '      ModeOfOp
     C                   PARM      'S'           RespMode
 
      ** Action Code
      ** Front Office Transaction ID
      ** Front Office Associated Transaction Id
      ** (Midas) Deal Number
      ** (Midas) Associated Deal Number
      ** Booking branch
      ** Deal Type
 
     C                   PARM                    #0ACCD
     C                   PARM                    PFOTrId
     C                   PARM                    PFOAsId
     C                   PARM                    #0DLNO
     C                   PARM                    #0LNKD
     C                   PARM                    #0BRCA
     C                   PARM                    #0DTYP
 
      ** Single Branch Code from SDBANKPD
      ** Default Branch for ZMUSER
      ** Originating Branch/User Validation Required for SDGELRPD
      ** FRA/IRS Authorisation Required                                                       CIR008
      ** FRA/IRS Re-authorise Amended Deals                                                   CIR008
      ** FRA/IRS Deals Authorisation                                                          CIR008
 
     C                   PARM                    BJSBRC
     C                   PARM                    PkDBRC
     C                   PARM                    BKOBUV
     C                   PARM                    BQFIAU                                       CIR008
     C                   PARM                    BQFIRA                                       CIR008
     C                   PARM                    CIR008                                       CIR008
 
      ** Outputs:
      ** Current Deal in File Format
      ** Action Code OK flag
      ** Deal Number OK flag
      ** Deal Type OK flag
 
     C                   PARM                    CrIRFilFmt
     C                   PARM      *BLANK        OKACCD
     C                   PARM      *BLANK        OKDLNO
     C                   PARM      *BLANK        OKBRCA
     C                   PARM      *BLANK        OKDTYP
 
      ** Error arrays
      ** Array index (3P0) from/to caller
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM      *ZERO         Idx
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCvtToScn - Convert Deal Details from File to Screen Format *
      *                                                               *
      *****************************************************************
     C     SrCvtToScn    BEGSR
 
      ** Call program to fill screen fields with data from DEALSDG
 
     C                   CALLB     'IRCACFCVT'
 
      ** Inputs:
      ** Return Code
      ** Action Code
      ** Transaction record in file format
 
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    #0ACCD
     C                   PARM                    CrIRFilFmt
 
      ** Business Day Convention
      ** Amortisation of Caps, Collars, Floors and Ind. Compounding Swaps
      ** FRA/IRS Deals Authorisation                                                          CIR008
 
     C                   PARM                    CIR005
     C                   PARM                    CIR006
     C                   PARM                    CIR008                                       CIR008
 
      ** Date Format (from SDBANKPD)
      ** Portfolio Management module (from SDMMODPD)
      ** Decimal Separator (from SDDEALPD)
 
     C                   PARM                    BJDFIN
     C                   PARM                    BGPFMG
     C                   PARM                    BNDCSP
 
      ** Outputs:
      ** Transaction record in screen format
      ** Deal Status
 
     C                   PARM                    CrIRScnFmt
     C                   PARM      *BLANKS       #1STAT
      ***Sign*of Short Term Rate                                                     BUG5707 BUG6472
     C**********         PARM                    #0SIGN                              BUG5707 BUG6472
 
      ** Update 'New' Deal with Deal in Screen Format
 
     C                   MOVEL     CrIRScnFmt    NwIRScnFmt
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrSetFldSt - Set Field Status on Main Details Screen Accor-  *
      *               ding to Action Code                             *
      *                                                               *
      *****************************************************************
     C     SrSetFldSt    BEGSR
 
      ** Enable/disable key & detail fields on main details screen
      ** (key fields = action code & deal number; detail fields = rest)
      ** (Action code can only be 'I', 'A', 'E', or 'R')
 
     C                   IF        #0ACCD = 'I' OR #0ACCD = 'A'
     C                   EVAL      PEKyFd = 'Y'
     C                   EVAL      PEDtFd = 'Y'
     C                   ELSE
     C                   EVAL      PEKyFd = 'N'
     C                   EVAL      PEDtFd = 'N'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrSetFKSt - Set Function Key Status on Main Details Screen   *
      *              According to Action Code                         *
      *                                                               *
      *****************************************************************
     C     SrSetFKSt     BEGSR
 
      ** Enable/disable function keys on main details screen
 
      ** KG = Command Key 07 = Read Previous
      ** KH = Command Key 08 = Read Next
 
     C                   MOVEL     'Y'           PEINKG
     C                   MOVEL     'Y'           PEINKH
 
      ** KJ = Command Key 10 = Confirm Delete
 
     C                   IF        #0ACCD = 'R'
     C                   EVAL      PEINKJ = 'Y'
     C                   ELSE
     C                   EVAL      PEINKJ = 'N'
     C                   ENDIF
 
      ** KN = COMMAND KEY 14 = SETTLEMENT DETAILS
      ** (Action codes I and A display settlement details automatically)
      ** (No futher screens are available from action code D)
 
     C                   IF        #0ACCD = 'E'
     C                   EVAL      PEINKN = 'Y'
     C                   ELSE
     C                   EVAL      PEINKN = 'N'
     C                   ENDIF
 
      ** KP = Command Key 15 = Browse
 
     C                   MOVEL     'Y'           PEINKP
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrEnblFld - Initialise Field Status on Main Details Screen   *
      *                                                               *
      *****************************************************************
     C     SrEnblFld     BEGSR
 
      ** Enable key & detail fields on main details screen
 
     C                   EVAL      PEKyFd = 'Y'
     C                   EVAL      PEDtFd = 'Y'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrInitFKSt - Initialise Function Key Status on the Main      *
      *               Details Screen                                  *
      *                                                               *
      *****************************************************************
     C     SrInitFKSt    BEGSR
 
      ** Enable/Disable Function Keys on Main Details Screen
      ** KG = Command key 07 = Read previous
      ** KH = Command key 08 = Read next
      ** KJ = Command key 10 = Confirm delete
      ** KN = Command key 14 = Settlement details
      ** KP = Command key 15 = Browse
 
     C                   EVAL      PEINKG = 'Y'
     C                   EVAL      PEINKH = 'Y'
     C                   EVAL      PEINKJ = 'N'
     C                   EVAL      PEINKN = 'N'
     C                   EVAL      PEINKP = 'Y'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCancelMain - Cancel on Main Details Screen                 *
      *                                                               *
      *****************************************************************
     C     SrCancelMain  BEGSR
 
      ** Reset Read Next Browse Subfile Record (if active)
 
     C                   EVAL      WRdNBr = *BLANK
 
      ** Reset 'Cancel taken from Confirm Screen' indicator
 
     C                   EVAL      CANCFM = 'N'
      *
      ** If input fields are enabled
      ** Blank the main details screen
 
     C                   MOVEL     *BLANK        NwIRScnFmt
     C                   MOVEL     *BLANK        #1STAT
 
      ** Initialize field and function key status on main details screen
 
     C                   EXSR      SrEnblFld
     C                   EXSR      SrInitFKSt
 
     C                   IF        CIR005 = 'Y'
     C                   EVAL      WFrstPas = 'Y'
     C                   EVAL      WSavBDC = *BLANKS
     C                   ENDIF
 
      ** Go back to initial screen
 
     C                   EVAL      WkScrn = 'I'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrSndMsgMn - Send a Message to Main Details Screen           *
      *                                                               *
      *****************************************************************
     C     SrSndMsgMn    BEGSR
 
      ** If single branching, user can't browse file
 
     C                   IF        PErrMs = 'FXM0292'
     C                   EVAL      OKACCD = 'N'
     C                   ENDIF
 
      ** Deal number on screen must be blank or numeric for pointer
 
     C                   IF        PErrMs = 'MMM0162'
     C                   EVAL      OKDLNO = 'N'
     C                   ENDIF
 
      ** Add error message to array passed to detail screen
 
     C                   Z-ADD     1             E                 3 0
     C     *BLANK        LOOKUP    FldNameArr(E)                          99
     C                   MOVEL     '*ANY'        FldNameArr(E)
     C                   MOVEL     PErrMs        MsgIdArr(E)
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrDefWinFld - Default Window Fields                          *
      *                                                               *
      *****************************************************************
     C     SrDefWinFld   BEGSR
 
     C                   IF        CIR001 = 'Y'                                             AR314712
     C                             AND RPUPPR = *BLANKS                                     AR314712
     C                             AND RPUPFE <> *ZERO                                      AR314712
     C                             AND RPUPVD <> *ZERO                                      AR314712
     C                   IF        #0BYSL = 'B'
     C                   EVAL      RPUPPR = 'P'
     C                   ELSE
     C                   EVAL      RPUPPR = 'R'
     C                   ENDIF
     C                   ENDIF                                                              AR314712
 
     C                   IF        #0ACCD = 'A'
     C                   IF        UPFE <> RPUPFE  OR UPVD <> RPUPFE
     C                   BITOFF    '0'           RPCNFI
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #0ACCD = 'I'
     C                   EVAL      RPUNPCD = 0
     C                   EVAL      RPTNPCD = 0
     C                   EVAL      RPUPAD = 0
     C                   EVAL      RPBOAM = 0
     C                   EVAL      RPBOVD = 0
     C                   EVAL      RPBODD = 0
     C                   EVAL      RPBAPR = *BLANKS
     C                   EVAL      RPOUSI = 0
     C                   EVAL      RPOUSA = 0
     C                   EVAL      RPTUSI = 0
     C                   EVAL      RPTUSA = 0
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrProcSettD - Process Settlement Screen Details              *
      *              - Evoked for Inserts, Amends, Enquiries &        *
      *                Authorisations                                 *
      *                                                               *
      *****************************************************************
     C     SrProcSettD   BEGSR
 
      ** If first time for action code, deal number, currency or customer
 
     C                   IF        #0ACCD <>  PSActn OR #0DLNO <> PSDlno OR
     C                             #0CUCY <> PSPCcy  OR #0CNUM <> PSCsNm
 
      ** Determine parameters for settlement details input
 
     C                   EXSR      SrDetPrmSett
     C                   ENDIF
 
      ** Settlement instructions input
 
     C/COPY WNCPYSRC,IRCACFSC01
 
     C                   CALLB     'ZASETINSIN'
 
      ** Inputs:
      ** Return Code
      ** Action code
      ** Deal number
 
     C                   PARM      *BLANK        PSRtCd
     C                   PARM      #0ACCD        PSActn
     C                   PARM      #0DLNO        PSDlNo
 
      ** Protect Payment
      ** Protect Receive
      ** Calling program
      ** Payment currency
      ** Receive currency
      ** Customer shortname
      ** Transaction Type
      ** Federal Funds Ind.
      ** Booking branch
 
     C                   PARM                    PSPPay
     C                   PARM                    PSPRec
     C                   PARM      'CACF'        PSCalP
     C                   PARM      #0CUCY        PSPCcy
     C                   PARM      #0CUCY        PSRCcy
     C                   PARM      #0CNUM        PSCsNm
     C                   PARM      #0DTYP        PSTTyp
     C                   PARM      #0FEFI        PSFFnd
     C                   PARM      #0BRCA        PSBrcA
 
      ** Receipt Date
      ** Payment Date
      ** Payment instructions
      ** Receive instructions
      ** FRA/IRS instructions
 
     C                   PARM                    PSDatR
     C                   PARM                    PSDatP
     C                   PARM                    PSPayS
     C                   PARM                    PSRecS
     C                   PARM                    PSRsIS
 
      ** Outputs:
      ** Payment instructions
      ** Receive instructions
      ** FRA/IRS instructions
 
     C                   PARM                    PSPayF
     C                   PARM                    PSRecF
     C                   PARM                    PSRsIF
 
      ** Functions Keys
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKK                                      MD036070
     C                   PARM      '0'           PINKL
 
      ** F3 to Exit
 
     C     PINKC         CASEQ     '1'           SrEndPgm
 
      ** F12 to Cancel on settlement details
 
     C     PINKK         CASEQ     '1'           SrCancelSett                               MD036070
     C     PINKL         CASEQ     '1'           SrCancelSett
 
      ** Exit from settlement details
 
     C                   CAS                     SrExitSett
 
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrDetPrmSett - Determine Parameters for Settlement Details   *
      *                 Screen                                        *
      *                                                               *
      *****************************************************************
     C     SrDetPrmSett  BEGSR
 
      ** Set Pay/Receive protection indicator and dates
 
     C                   EVAL      PSPPay = 'N'
     C                   EVAL      PSPRec = 'N'
     C                   EVAL      PSDatP = BJRDNB
     C                   EVAL      PSDatR = BJRDNB
 
      ** Set up payment instructions from deal
      ** (on insertions, these fields will be zero/blank)
 
     C                   EVAL      FLPAY = RPPAY
     C                   EVAL      FLPSTM = RPPSTM                                            CGL029
     C                   EVAL      FLPONS = RPPONS                                            CGL029
     C                                                                                        CGL029
     C                   EVAL      FLPOBR = RPPOBR
     C                   EVAL      FLCVMR = RPCVMR
     C                   EVAL      FLPSCY = RPPSCY
     C                   EVAL      FLIC72 = RPIC72
 
      ** Set up Receive instructions from deal
      ** (on insertions, these fields will be zero/blank)
 
     C                   EVAL      FLREC = RPREC
     C                   EVAL      FLRSTM = RPRSTM                                            CGL029
     C                   EVAL      FLRONS = RPRONS                                            CGL029
     C                   EVAL      FLROBR = RPROBR
     C                   EVAL      FLRSCY = RPRSCY
 
      ** Set up FRA/IRS specific date
      ** (On insertions, these fields will be zero/blank)
 
     C                   MOVEL     RPIRS         FLIRS
     C                   MOVE      RPAGVC        FLAGVC
 
      ** If Settlement instructions are not defined,
      ** and payment/receipt dates are not in the past, default them
 
     C                   IF        FLPSTM = *ZERO AND PSPPay <> 'Y' AND
     C                             FLRSTM = *ZERO AND PSPRec <> 'Y' AND
     C                             #0ACCD <> 'E'
     C                             AND CIR008 = 'N' OR                                        CIR008
     C                             FLPSTM = *ZERO AND PSPPay <> 'Y' AND                       CIR008
     C                             FLRSTM = *ZERO AND PSPRec <> 'Y' AND                       CIR008
     C                             #0ACCD <> 'E'  AND #0ACCD <> 'X' AND                       CIR008
     C                             CIR008 = 'Y'                                               CIR008
 
     C                   CALLB     'ZASETINDFT'
 
      ** Inputs:
      ** Calling program
      ** Payment currency
      ** Receive currency
      ** Customer shortname
      ** Transaction Type
      ** Federal Funds Ind.
 
     C                   PARM      'CACF'        PSCalP
     C                   PARM      #0CUCY        PSPCcy
     C                   PARM      #0CUCY        PSRCcy
     C                   PARM      #0CNUM        PSCsNm
     C                   PARM      #0DTYP        PSTTyp
     C                   PARM      #0FEFI        PSFFnd
 
      ** Version of ISDA Rules govern
      ** Type of ISDA agreement
      ** Date of ISDA Agreement
      ** Version of ISDA Agreement
      ** Version of ISDA Agreement century
 
     C                   PARM                    PBQISDA
     C                   PARM                    PBQAGTY
     C                   PARM                    PBQAGDT
     C                   PARM                    PBQAGVV
     C                   PARM                    PBQAGVC
                                                                                              CSD095
      ** Deal Subtype                                                                         CSD095
     C                   PARM      *BLANK        BlankSTYP                                    CSD095
                                                                                              CSD095
      ** Branch                                                                               CSD095
     C                   PARM      *BLANK        BlankBRCA                                    CSD095
 
      ** Outputs:
      ** Payment instructions
      ** Receive instructions
      ** FRA/IRS instructions
 
     C                   PARM                    PSPayF
     C                   PARM                    PSRecF
     C                   PARM                    PSRsIF
 
     C                   ENDIF
 
      ** Convert Settlement Details from file to screen format
 
     C                   CALLB     'ZASETINCVT'
 
      ** Inputs:
      ** File Payment Settlement Instruction
      ** File Receipt Settlement Instruction
      ** File FRA/IRS Settlement Instruction
 
     C                   PARM                    PSPayF
     C                   PARM                    PSRecF
     C                   PARM                    PSRsIF
 
      ** Outputs:
      ** Screen Payment Settlement Instruction
      ** Screen Receipt Settlement Instruction
      ** Screen FRA/IRS Settlement Instruction
 
     C                   PARM      *BLANK        PSPayS
     C                   PARM      *BLANK        PSRecS
     C                   PARM      *BLANK        PSRsIS
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
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCancelSett - Cancel on Settlement Details Screen           *
      *                                                               *
      *****************************************************************
     C     SrCancelSett  BEGSR
 
      ** Return to Main Details Screen
 
     C                   EVAL      WkScrn = 'M'
 
     C                   IF        CIR005 = 'Y'
     C                   EVAL      WFrstPas = 'Y'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrExitSett - Exit From Settlement Details Screen             *
      *                                                               *
      *****************************************************************
     C     SrExitSett    BEGSR
 
      ** If Settlement Details Invalid
 
     C                   IF        PSRtCd = '*ERRORS'
 
      ** Return to main details screen
 
     C                   EVAL      WkScrn = 'M'
     C                   ELSE
 
      ** Else, continue with confirmation screen
 
     C                   EVAL      WkScrn = 'C'
 
      ** Update valid deal: payment settlement instructions
 
     C                   MOVEL     FLPAY         RPPAY
     C                   EVAL      RPPSTM = FLPSTM                                            CGL029
     C                   EVAL      RPPONS = FLPONS                                            CGL029
     C                   MOVEL     FLPOBR        RPPOBR
     C                   MOVEL     FLCVMR        RPCVMR
 
      ** Update valid deal: receipt settlement instructions
 
     C                   MOVEL     FLREC         RPREC
     C                   EVAL      RPRSTM = FLRSTM                                            CGL029
     C                   EVAL      RPRONS = FLRONS                                            CGL029
     C                   MOVEL     FLROBR        RPROBR
 
      ** Update valid deal: settlement currency & 'IN' ccy in field 72
 
     C                   MOVEL     FLRSCY        RPRSCY
     C                   MOVEL     FLPSCY        RPPSCY
     C                   MOVEL     FLIC72        RPIC72
 
      ** Update valid deal: FRA/IRS Details
 
     C                   MOVEL     FLIRS         RPIRS
     C                   MOVE      FLAGVC        RPAGVC
 
      ** Zeroise numeric fields in RPIRS for update (these fields may be
      ** blank if type is OTHER)
 
     C                   IF        FLISDA = *BLANKS
     C                   EVAL      RPISDA = 0
     C                   ENDIF
 
     C                   IF        FLAGDT = *BLANKS
     C                   EVAL      RPAGDT = 0
     C                   ENDIF
 
     C                   IF        FLAGVV = *BLANKS
     C                   EVAL      RPAGVV = 0
     C                   ENDIF
 
     C                   IF        FLAGVC = *BLANKS
     C                   EVAL      RPAGVC = 0
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrProcConf - Process Confirmation of Input Screen            *
      *             - Evoked for Inserts, Amends & Authorisations     *
      *                                                               *
      *****************************************************************
     C     SrProcConf    BEGSR
 
      ** Prior to validation, initialize error indicators as 'OK'
 
     C                   MOVE      *ALL'Y'       IRECACF
 
      ** Validate deal details
 
     C                   CALLB     'IRCACFVAL'
     C                   PARM                    ModeOfOp
     C                   PARM                    RespMode
     C                   PARM                    CrIRScnFmt
     C                   PARM                    NwIRScnFmt
     C                   PARM      RPRSCY        PrRSCY
     C                   PARM      RPRSTM        PrRSTM
     C                   PARM      RPRONS        PrRONS
     C                   PARM      RPPSCY        PrPSCY
     C                   PARM      RPPSTM        PrPSTM
     C                   PARM      RPPONS        PrPONS
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
     C                   PARM      *ZERO         Idx               3 0
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM      *ZERO         WIdx              3 0
     C                   PARM                    NwIRFilFmt
      ***Sign*of Short Term Rate                                                     BUG5707 BUG6472
     C**********         PARM                    #0SIGN                              BUG5707 BUG6472
 
      ** If transaction is valid output message 'Press enter to accept'
 
     C                   IF        Idx = *ZERO
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'MMM1030'     MsgIdArr(1)
     C                   ENDIF
 
      ** Write/Read Display screen
 
     C                   CALLB     'IRCACF1DP'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    NwIRScnFmt
     C                   PARM                    CrIRFilFmt
     C                   PARM                    #1STAT
     C                   PARM                    IRECACF
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM      'N'           PEKyFd
     C                   PARM      'N'           PEDtFd
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
 
     C                   MOVE      *ALL'Y'       IRECACF
     C                   EVAL      FldNameArr = *BLANK
     C                   EVAL      MsgIdArr = *BLANK
     C                   EVAL      MsgDtaArr = *BLANK
     C                   EVAL      WFldNamArr = *BLANK
     C                   EVAL      WMsgIdArr = *BLANK
     C                   EVAL      WMsgDtaArr = *BLANK
 
      ** F3 to Exit
 
     C     PINKC         CASEQ     '1'           SrEndPgm
 
      ** F12 to Cancel on confirmation screen
 
     C     PINKL         CASEQ     '1'           SrCancelCnf
 
      ** Exit confirmation screen
 
     C                   CAS                     SrExitCnf
 
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCancelCnf - Cancel on Confirmation Screen                  *
      *                                                               *
      *****************************************************************
     C     SrCancelCnf   BEGSR
 
     C                   EVAL      CANCFM = 'Y'
      *
      ** Return to main details screen
 
     C                   EVAL      WkScrn = 'M'
 
      ** Initialize field status on main details screen
 
     C                   EXSR      SrEnblFld
 
      ** Set function key status on main details screen
      ** (according to action code)
 
     C                   EXSR      SrSetFKSt
 
     C                   IF        CIR005 = 'Y'
     C                   EVAL      WFrstPas = 'Y'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrExitCnf - Exit from Confirmation Screen                    *
      *                                                               *
      *****************************************************************
     C     SrExitCnf     BEGSR
 
      ** If no errors in validation
 
     C                   IF        Idx = *ZERO
 
      ** Continue with updates
 
     C                   EVAL      WkScrn = 'U'
 
      ** Reset 'Cancel taken from Confirm Screen' indicator
 
     C                   EVAL      CANCFM = 'N'
 
      ** else, return to main details screen
 
     C                   ELSE
 
     C                   EVAL      WkScrn = 'M'
 
      ** Initialize field status on main details screen
 
     C                   EXSR      SrEnblFld
 
      ** Set function key status on main details screen
      ** (according to action code)
 
     C                   EXSR      SrSetFKSt
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrUpdate - Update                                            *
      *                                                               *
      *****************************************************************
     C     SrUpdate      BEGSR
 
      ** If deal number is not defined (on insert), get next
      ** available deal number
 
     C                   IF        #0DLNO = *BLANK
 
     C                   IF        PGnDlNo <>  *BLANK
     C                   MOVEL     PGnDlNo       #0DLNO
     C                   ELSE
 
     C                   CALLB     'CAGETNXTDL'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM      *BLANKS       WkMsg1
     C                   PARM                    #0DLNO
     C                   PARM      *ZERO         RPDLNO
 
      ** Database error
 
     C                   IF         WkMsg1 <> *BLANK
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'CAGTNXDL'
     C                   EVAL      DBASE = 20
     C                   EVAL      DBKEY = #0DLNO
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Update Valid deal: deal number
 
     C                   MOVEL     #0DLNO        RPDLNO
 
      ** Update Valid deal: Last Action code
 
     C                   EVAL      RPCHTP = #0ACCD
 
      ** Deal Updates
 
     C                   CALLB     'IRCACFUPD'
 
      ** Input:
      ** Return Code
      ** Mode of Operation                                                                    CAP056
      ** Deal Transaction in File format
 
     C                   PARM      *BLANKS       PRtCd
     C                   PARM                    ModeOfOp                                     CAP056
     C                   PARM                    NwIRFilFmt
     C                   PARM      'Y'           PScreenInpt                                  CAP043
 
      ** Default Branch for ZMUSER
      ** Bank Details (SDBANKPD)
      ** General Ledger ICD (SDGELRPD)
      ** Trading ICD (SDTRADPD)
      ** Retail ICD (SDRETLPD)
      ** FRA/IRS ICD (SDFAISPD)
 
     C                   PARM                    PkDBRC
     C                   PARM                    SDBANK
     C                   PARM                    SDGELR
     C                   PARM                    SDTRAD
     C                   PARM                    SDRETL
     C                   PARM                    SDFAIS
 
      ** Business Day Convention
      ** Amortisation of Caps/Collars/Floors
      ** 24x7 Midas Availability
      ** CCRM Limits
      ** FRA/IRS Deals Authorisations                                                         CIR008
      ** Automatic Authorisation of Interface deals                                           CAP056
 
     C                   PARM                    CIR005
     C                   PARM                    CIR006
     C                   PARM                    CSC011
     C                   PARM                    CDE001
     C                   PARM                    CIR008                                       CIR008
     C                   PARM                    CAP056                                       CAP056
 
      ** If there were any errors in the update function, rollback any
      ** updates and end this program. Otherwise, commit the updates
 
     C                   IF        PRtCd <> *BLANK AND PRtCd <> '*RECUPD'
                                                                                             BUG2603
     C     CSC022        IFEQ      'N'                                                       BUG2603
     C                   ROLBK
     C                   ELSE                                                                BUG2603
     C     WSkpCom       IFNE      'Y'                                                       BUG2603
     C                   ROLBK                                                               BUG2603
     C                   ENDIF                                                               BUG2603
     C                   ENDIF                                                               BUG2603
     C                   EXSR      *PSSR
     C                   ELSE
      *                                                                                      BUG2603
     C                   IF        CSC022 = 'N' OR                                           BUG2603
     C                             CSC022 = 'Y' AND WSkpCom = 'N'                            BUG2603
     C                   COMMIT
     C                   ENDIF                                                               BUG2603
 
     C                   IF        #0ACCD = 'I'
     C                   EVAL      PSucInsDN = #0DLNO
     C                   ENDIF
 
     C                   ENDIF
 
      ** If update not done due to record being updated by another
      ** workstation send message to screen.
 
     C                   IF        PRtCd = '*RECUPD'
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'MMM1067'     MsgIdArr(1)
     C                   ENDIF
 
      ** Clear the main details screen
 
     C                   EVAL      NwIRScnFmt = *BLANKS
     C                   EVAL      #1STAT = *BLANKS
     C                   EVAL      DATA = *BLANKS
 
      ** Blank the Business Day Currency Convention fields
 
     C                   IF        CIR005 = 'Y'
     C                   EVAL      BsDayConv = *BLANKS
     C                   EVAL      WSavBDC = *BLANKS
     C                   EVAL      WFrstPas = 'Y'
     C                   ENDIF
 
      ** Initialize field and function key status on main details screen
 
     C                   EXSR      SrEnblFld
     C                   EXSR      SrInitFKSt
 
      ** If records are still to be read from the subfile, then read,
 
     C                   IF        WRdNBr = 'Y'
     C                   EVAL      WkScrn = 'R'
     C                   ELSE
 
      ** else, return to initial screen
 
     C                   EVAL      WkScrn = 'I'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrEndPgm - End Program                                       *
      *                                                               *
      *****************************************************************
     C     SrEndPgm      BEGSR
 
      ** Issue rollback to clear any possible updates in window function
 
     C                   IF        BGWDPR = 'Y' AND CIR006 = 'Y'
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
 
     C                   EVAL      WkScrn = 'T'
 
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
     C                   CLEAR                   IDx
 
     C                   CLEAR                   WFldNamArr
     C                   CLEAR                   WMsgIdArr
     C                   CLEAR                   WMsgDtaArr
     C                   CLEAR                   WIDx
 
      ** Initialise screen fields error indicators.
 
     C                   EVAL      IRECACF = *ALL'Y'
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Initialize program name
 
     C                   MOVEL     'IRCACFSIN'   DBPGM
 
      ** Get ZMUSER to access default branch
 
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
     C                   UNLOCK    ZMUSER
 
      ** Access Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRtCd <> *BLANK
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  = 1
     C                   EVAL      DBKEY  = POptn
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access Module Details
      ** (database error handling done in access program)
 
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDMMOD        PARM      SDMMOD        DSFDY
 
     C                   IF        PRtCd <> *BLANK
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDMMODPD'
     C                   EVAL      DBASE  = 2
     C                   EVAL      DBKEY  = POptn
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access Dealing Details
      ** (database error handling done in access program)
 
     C**********         CALLB     'AODEALR0'                                                 CGL029
     C                   CALLB     'AODEALR1'                                                 CGL029
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
 
     C                   IF        PRtCd <> *BLANK
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDDEALPD'
     C                   EVAL      DBASE  = 3
     C                   EVAL      DBKEY  = POptn
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access General Ledger details via access program
      ** (database error handling done in access program)
 
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
 
     C                   IF        PRtCd <> *BLANK
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDGELRPD'
     C                   EVAL      DBASE  = 4
     C                   EVAL      DBKEY  = POptn
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access FRA/IRS ICD details
 
     C                   CALLB     'AOFAISR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDFAIS        PARM      SDFAIS        DSFDY
 
     C                   IF        PRtCd <> *BLANK
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDFAISPD'
     C                   EVAL      DBASE  = 5
     C                   EVAL      DBKEY  = POptn
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access Tranding Details
 
     C                   CALLB     'AOTRADR0'
     C                   PARM      '*MSG   '     PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDTRAD        PARM      SDTRAD        DSFDY
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDTRADPD'
     C                   EVAL      DBASE  = 6
     C                   EVAL      DBKEY  = POptn
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access Retail details via access program
 
     C                   CALLB     'AORETLR0'
     C                   PARM      *BLANK        PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDRETL        PARM      SDRETL        DSFDY
 
     C                   IF        PRtCd <> *BLANK
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDRETLPD'
     C                   EVAL      DBASE  = 7
     C                   EVAL      DBKEY  = POptn
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access SAR details file to determine EMU Dealing Settlement Ccy
      ** Conversion feature is switched on.
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CEU003'      PSarD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRtCd <> *BLANKS AND PRtCd <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 8
     C                   EVAL      DBKEY = 'CEU003'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      CEU003 = 'Y'
     C                   ELSE
     C                   EVAL      CEU003 = 'N'
     C                   ENDIF
 
      ** Access SAR details file to determine if Interest Rate Calendar is On
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CIR001'      PSarD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRtCd <> *BLANKS AND PRtCd <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 9
     C                   EVAL      DBKEY = 'CIR001'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      CIR001 = 'Y'
     C                   ELSE
     C                   EVAL      CIR001 = 'N'
     C                   ENDIF
 
      ** Access SAR details file to determine if FRA/IRS Business Day Convention
      ** is switched on.
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CIR005'      PSarD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRtCd <> *BLANKS AND PRtCd <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 10
     C                   EVAL      DBKEY = 'CIR005'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      CIR005 = 'Y'
     C                   ELSE
     C                   EVAL      CIR005 = 'N'
     C                   ENDIF
 
      ** Access SAR details file to determine if Amortisation of Caps/Collars/
      ** Floors & Individual Compounding Swaps feature is installed.
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CIR006'      PSarD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRtCd <> *BLANKS AND PRtCd <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 11
     C                   EVAL      DBKEY = 'CIR006'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      CIR006 = 'Y'
     C                   ELSE
     C                   EVAL      CIR006 = 'N'
     C                   ENDIF
 
      ** Access SAR details file to determine if 24x7 Midas Availability is
      ** switched on
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CSC011'      PSarD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRtCd <> *BLANKS AND PRtCd <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 12
     C                   EVAL      DBKEY = 'CSC011'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      CSC011 = 'Y'
     C                   ELSE
     C                   EVAL      CSC011 = 'N'
     C                   ENDIF
 
      ** Access SAR details file to determine if CCRM Limits feature is
      ** switched on
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CDE001'      PSarD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRtCd <> *BLANKS AND PRtCd <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 13
     C                   EVAL      DBKEY = 'CDE001'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      CDE001 = 'Y'
     C                   ELSE
     C                   EVAL      CDE001 = 'N'
     C                   ENDIF
 
      ** Check if APIs for IRS Fees/Buy-Outs/Processing Method/Next
      ** Principal Change Date feature is switched on
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CAP041'      PSarD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRtCd <> *BLANKS AND PRtCd <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 14
     C                   EVAL      DBKEY = 'CAP041'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      CAP041 = 'Y'
     C                   ELSE
     C                   EVAL      CAP041 = 'N'
     C                   ENDIF
                                                                                              CIR008
      ** Check if FRA/IRS Deals Authorisation is installed                                    CIR008
                                                                                              CIR008
     C                   CALLB     'AOSARDR0'                                                 CIR008
     C                   PARM      *BLANKS       PRtCd                                        CIR008
     C                   PARM      '*VERIFY'     POptn                                        CIR008
     C                   PARM      'CIR008'      PSarD                                        CIR008
     C     SCSARD        PARM      SCSARD        DSFDY                                        CIR008
                                                                                              CIR008
     C                   IF        PRtCd <> *BLANKS AND PRtCd <> '*NRF   '                    CIR008
     C     *LOCK         IN        LDA                                                        CIR008
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CIR008
     C                   EVAL      DBASE = 15                                                 CIR008
     C                   EVAL      DBKEY = 'CIR008'                                           CIR008
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
      ** Check if Automatic Authorisation feature is installed                                CAP056
                                                                                              CAP056
     C                   CALLB     'AOSARDR0'                                                 CAP056
     C                   PARM      *BLANKS       PRtCd                                        CAP056
     C                   PARM      '*VERIFY'     POptn                                        CAP056
     C                   PARM      'CAP056'      PSarD                                        CAP056
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP056
                                                                                              CAP056
     C                   IF        PRtCd <> *BLANKS AND PRtCd <> '*NRF   '                    CAP056
     C     *LOCK         IN        LDA                                                        CAP056
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAP056
     C                   EVAL      DBASE = 16                                                 CAP056
     C                   EVAL      DBKEY = 'CAP056'                                           CAP056
     C                   OUT       LDA                                                        CAP056
     C                   EXSR      *PSSR                                                      CAP056
     C                   ENDIF                                                                CAP056
                                                                                              CAP056
     C                   IF        PRtCd = *BLANKS                                            CAP056
     C                   EVAL      CAP056 = 'Y'                                               CAP056
     C                   ELSE                                                                 CAP056
     C                   EVAL      CAP056 = 'N'                                               CAP056
     C                   ENDIF                                                                CAP056
 
      ** Check if Overnight Index Swaps is installed
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CIR007'      PSarD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRtCd <> *BLANKS AND PRtCd <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 17
     C                   EVAL      DBKEY = 'CIR007'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      CIR007 = 'Y'
     C                   ELSE
     C                   EVAL      CIR007 = 'N'
     C                   ENDIF
 
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
     C                   EVAL      DBASE = 022                                               BUG2603
     C                   EXSR      *PSSR                                                     BUG2603
     C                   ENDIF                                                               BUG2603
     C                   ENDIF                                                               BUG2603
      *                                                                                      BUG2603
     C                   ClEAR                   DATA
 
      ** Start on Initial Screen
 
     C                   EVAL      WkScrn = 'I'
     C                   EXSR      SrEnblFld
     C                   EXSR      SrInitFKSt
 
      ** Store local currency
 
     C                   EVAL      PLCcy = BJLCCY
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
      /COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,IRCACFS011
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
