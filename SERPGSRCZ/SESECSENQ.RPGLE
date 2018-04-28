     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Securities Transactions Details Enquiry')     *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SESECSENQ - Securities Transactions Details Enquiry          *
      *                                                               *
      *  Function: This will allow the user to enquire upon           *
      *            the details of a Securities transaction.           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CLE134             Date 01Aug12               *
      *  Prev Amend No. CRE073             Date 10Dec06               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 BUG10218           Date 09Feb06               *
      *                 BUG9530            Date 17Nov05               *
      *                 BUG9529            Date 17Nov05               *
      *                 CSE074             Date 30Aug05               *
      *                 CSE071             Date 19Jul05               *
      *                 BUG7029            Date 09Jun05               *
      *                 CGL035             Date 01Mar05               *
      *                 CGL014  *CREATE    Date 20Oct03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10218-parm mismatch on call to SESECSCVT                  *
      *  BUG9530 - Corrupted screen fields values due to missing      *
      *            parameter when calling SESECSCVT                   *
      *  BUG9529 - Use full length of SEVSECSPD data structure        *
      *  CSE074 - Const. Yield Amort. on Mortgage backed assets       *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  BUG7029 - Ensure ZMUSER is re-checked on every call,         *
      *            move out of *INZSR.                                *
      *  CGL035 - EUSD Upgrade to MidasPlus                           *
      *  CGL014 - Collaterals Processing                              *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Hook to enable non-core files to be included
      /COPY WNCPYSRC,SESECS001
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *ON (for indicator processing)
      **    False      logical = *OFF (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
      /COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
      /COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
 
      /COPY ZACPYSRC,ERR_ARRAYS
 
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
 
      /COPY ZACPYSRC,ERR_XARRYS
 
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
 
      ** Securities for file update- file format
     D NwSEFilFmt    E DS                  EXTNAME(SEVSECSPD)
     D*NwSEFilFmt1             1    899                                               CSE074 BUG9529
 
      ** Security details for file update- file format
     D NwSEFilFmtOld E DS                  EXTNAME(SEVSECSPD)
     D                                     PREFIX(O)
 
      ** Securities retrieved from file - file format
     D CrSEFilFmt    E DS                  EXTNAME(SECTYD)
     D*CrSEFilFmt1             1    899                                               CSE074 BUG9529
 
      ** Security screen 1 details from incoming transaction - screen format
     D NwSE1ScnFmt   E DS                  EXTNAME(SESEC1PD)
 
      ** Security screen 2 details from incoming transaction - screen format
     D NwSE2ScnFmt   E DS                  EXTNAME(SESEC2PD)
 
      ** Security screen 3 details from incoming transaction - screen format
     D NwSE3ScnFmt   E DS                  EXTNAME(SESEC3PD)
 
      ** Security screen 4 details from incoming transaction - screen format
     D NwSE4ScnFmt   E DS                  EXTNAME(SESEC4PD)
 
      ** Security Screen 5 Details From Incoming Transaction - Screen Format
     D NwSE5ScnFmt   E DS                  EXTNAME(SESEC5PD)
 
      ** Security screen 1 details retrieved from file - screen format
     D CrSE1ScnFmt   E DS                  EXTNAME(SESEC1PD)
     D                                     PREFIX(O:1)
 
      ** Security screen 2 details retrieved from file - screen format
     D CrSE2ScnFmt   E DS                  EXTNAME(SESEC2PD)
     D                                     PREFIX(O:1)
 
      ** Security screen 3 details retrieved from file - screen format
     D CrSE3ScnFmt   E DS                  EXTNAME(SESEC3PD)
     D                                     PREFIX(O:1)
 
      ** Security screen 4 details retrieved from file - screen format
     D CrSE4ScnFmt   E DS                  EXTNAME(SESEC4PD)
     D                                     PREFIX(O:1)
 
      ** Security screen 5 details retrieved from file - screen format
     D CrSE5ScnFmt   E DS                  EXTNAME(SESEC5PD)
     D                                     PREFIX(O:1)
                                                                                            BUG10218
      ** Securities Screen 6 Details Retrieved From File                                    BUG10218
      ** - Screen Format                                                                    BUG10218
     D CrSE6ScnFmt   E DS                  EXTNAME(SESEC6PD)                                BUG10218
 
      ** Securities screen 1 error indicators
     D SEESEC1       E DS                  EXTNAME(SEESEC1PD)
 
      ** Securities screen 2 error indicators
     D SEESEC2       E DS                  EXTNAME(SEESEC2PD)
 
      ** Securities screen 3 error indicators
     D SEESEC3       E DS                  EXTNAME(SEESEC3PD)
 
      ** Securities screen 4 error indicators
     D SEESEC4       E DS                  EXTNAME(SEESEC4PD)
 
      ** Securities Screen 5 Error Indicators
     D SEESEC5       E DS                  EXTNAME(SEESEC5PD)
 
      ** Securities extra data
     D PExtData      E DS                  EXTNAME(SESEEXPD)
 
      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Externally described DS for securities trading ICD details
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
 
      ** Externally described DS for Midas modules details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      ** Externally described DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SLCD          E                     EXTFLD(LCD)
 
      ** Externally described DS for investment types
     D PINVTP        E DS                  EXTNAME(INVTPD)
     D                                     PREFIX(P)
 
      ** DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** DS for access programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Passed other information
     D POthInf         DS           156
 
      ** DS of fields for output only
     D POutFlds        DS
     D  WCSNM1                       10A
     D  WCSNM2                       10A
     D  WCSNM3                       10A
     D  WMKTN                        20A
     D  WSTBS                         1A
 
      ** Data structure for ZMUSER details
     D ZMUSER          DS            17
     D  PUSRID                 1     10A
     D  PDBRN                 11     13A
     D  PDPPT                 14     16A
 
      ** Data structure for key fields and key selections
     D KeyLists        DS
     D  WDSESN                 1     10A
     D  WDSRPN                11     30A
 
     D KeySelect       DS
     D  WDISSR                 1      6A
     D  WDNMCY                 7      9A
     D  WDSITP                10     12A
     D  WDPRTP                13     13A
     D  WDINCS                14     14A
     D  WDISIN                15     26A
     D  WDT2RF                27     38A
     D  WDSTAT                39     48A
 
      ** 24x7 Status Data Area
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
 
      ** SD Data Area
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Parameter and work variable declarations
     D PParmLink       S              1A
     D PParmActn       S              1A
     D PParmRtcd       S              7A
     D PParmSESN       S             10A
     D PParOSESN       S             10A
     D PParOther       S            156A
 
     D POpSel          S              1A
     D PErrMS          S              7A
     D PSESNSel        S             10A
 
     D PEDtFld         S              1A
     D PEKyFld         S              1A
     D PResetFld       S              1A
 
     D PRdNb           S              1A
     D PSARd           S              6A
     D PRtcd           S              7A
     D POptn           S              7A
     D PMktN           S             20A
     D PSesn           S             10A
 
     D PKey            S              2A   INZ(*BLANKS)
     D PPgm            S             10A   INZ('SESECSENQ')
     D PAction         S              1A
     D PSpareW         S            256A   INZ(*BLANKS)
 
     D PRdBck          S              1A
     D PRdFwd          S              1A
     D PBdSfl          S              1A
     D PRdSfl          S              1A
 
     D PNCD            S              6A
     D PLCPN           S              6A
     D PNMDP           S              1P 0
     D PVLDP           S              1P 0
 
     D PPrCpn          S              1A
     D PAmendOk        S              1A
 
     D PINKC           S              1A
     D PINKE           S              1A
     D PINKF           S              1A
     D PINKG           S              1A
     D PINKH           S              1A
     D PINKI           S              1A
     D PINKJ           S              1A
     D PINKL           S              1A
     D PINKP           S              1A
 
     D PEINKE          S              1A
     D PEINKF          S              1A
     D PEINKG          S              1A
     D PEINKH          S              1A
     D PEINKI          S              1A
     D PEINKJ          S              1A
     D PEINKL          S              1A
     D PEINKP          S              1A
 
     D CSE005          S              1A
     D CSE007          S              1A
     D CSE011          S              1A
     D CEU017          S              1A
     D CEU018          S              1A
     D S01401          S              1A
     D S01511          S              1A
     D CSE023          S              1A
     D CSE031          S              1A
     D CGL018          S              1A
     D CAS006          S              1A
     D CSE037          S              1A
     D*CSE065***       S              1A   INZ('N')                                   CSE074 BUG9529
     D CSE071          S              1A                                                     BUG9530
     D CGL032          S              1A                                                      CGL035
 
     D WScrn           S              1A
     D WOScrn          S              1A
 
     D WRats           S              1A   INZ(*BLANK)
 
      ** Redisplay screen flag and indicator
     D PReDsp          S              1A
     D WReDisplay      S              1A   INZ(*BLANK)
 
      ** Process old security details indicator
     D PPOldSecDtl     S              1A   INZ(*BLANK)
 
      ** Index for arrays of error message IDs
     D IdX             S              3P 0
 
      ** Index for arrays of warning messages
     D Ex              S              3P 0
     D WiX             S              3P 0
     D WIdX            S              3P 0
     D WPrvIdX         S              3P 0
     D WCurIdX         S              3P 0
 
     D WISSA1          S             11P 0
 
      ** Work array for warning message Ids
     D WPrvWarnAr      S                   Dim(ArrayMax)
     D                                     Like(WMsgIDArr)
 
      ** Mode = '*FRONT' (front office transaction interface)
      ** Mode = '      ' (not front office transaction interface)
      ** Mode = '*RPR  ' (repair function)
      ** Mode = '*SIN  ' (screen input function)
     D PMode           S              6A   INZ('*SIN  ')
 
      ** Response mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for synchronous.
     D PRespMode       S              1A   INZ('S')
 
      ** Midas APIs Sec Prices
     D CAP060          S              1A
 
      ** Market Data Feed
     D CSD006          S              1A
 
     D CSC011          S              1A
     D WkDate          S              5  0
     D WkNext          S              5  0
 
     D CGL014          S              1A
 
      ** +--------------------------------------+
      ** ¦ /COPYs                               ¦
      ** ¦ ======                               ¦
      ** +--------------------------------------+
 
      /COPY QWINDSRC,SESECSDTA
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
 
      /COPY WNCPYSRC,SESECS002
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      ** Retrieve ZMUSER details                                                             BUG7029
                                                                                             BUG7029
     C     *DTAARA       DEFINE                  ZMUSER                                      BUG7029
     C                   IN        ZMUSER                                                    BUG7029
                                                                                             BUG7029
      /COPY WNCPYSRC,SESECS003
 
      ** Build browse subfile record.
 
     C                   IF        WScrn = 'B'
     C                   EXSR      SRBldBrw
     C                   ENDIF
 
      /COPY WNCPYSRC,SESECS004
 
      ** Read next browse subfile record.
 
     C                   IF        WScrn = 'R'
     C                   EXSR      SRRdnBrw
     C                   ENDIF
 
      /COPY WNCPYSRC,SESECS005
 
      ** DO WHILE screen: level 1 screen initial details only.
 
     C                   DOW       WScrn = 'I'
     C                   EXSR      SRScrn_I
     C                   ENDDO
 
      /COPY WNCPYSRC,SESECS006
 
      ** DO WHILE screen: level 1 screen details.
 
     C                   DOW       WScrn = 'P'
     C                   EXSR      SRScrn_P
     C                   ENDDO
 
      /COPY WNCPYSRC,SESECS007
 
      ** DO WHILE screen: level 2 screen details.
 
     C                   DOW       WScrn = 'S'
     C                   EXSR      SRScrn_S
     C                   ENDDO
 
      ** DO WHILE screen: Level 5 Screen Details.
 
     C                   DOW       WScrn = 'H'
     C                   EXSR      SRScrn_H
     C                   ENDDO
 
      /COPY WNCPYSRC,SESECS008
 
      ** DO WHILE screen: level 4 screen details.
 
     C                   DOW       WScrn = 'G'
     C                   EXSR      SRScrn_G
     C                   ENDDO
 
      ** DO WHILE screen: level 3 screen details.
 
     C                   DOW       WScrn = 'T'
     C                   EXSR      SRScrn_T
     C                   ENDDO
 
      /COPY WNCPYSRC,SESECS009
 
      ** Screen: Window processing.
 
     C                   IF        WScrn = 'W'
     C                   EXSR      SRWindow
     C                   ENDIF
 
      /COPY WNCPYSRC,SESECS010
 
      ** Terminate program.
 
     C                   IF        WScrn = 'E'
 
     C                   EVAL      *INLR = *ON
 
     C                   ENDIF
      *
      ** Screen: RWA Processing
      *
     C                   IF        WScrn = 'Z'
     C                   EXSR      SRScrn_Z
     C                   ENDIF
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,SESECS011
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBldBrw - Build browse subfile record                       *
      *                                                               *
      *****************************************************************
 
     C     SRBldBrw      BEGSR
 
      ** Reset Read Next Browse Subfile Record indicator
 
     C                   EVAL      PRdNb = *BLANK
 
      ** Display browse screen
 
     C                   CALLB     'SESECSBRW'
 
      ** INPUTS
      ** Return code
 
     C                   PARM      *BLANKS       RetCodeOut
 
      ** Key fields (file pointer)
      ** Selection fields (file select)
 
     C                   PARM                    KeyLists
     C                   PARM                    KeySelect
 
      ** Build subfile
      ** Read subfile record
 
     C                   PARM      'Y'           PBdSfl
     C                   PARM      *BLANK        PRdSfl
 
      ** System run date (SDBANK)
      ** Single branch code (SDBANK)
      ** Default user branch (ZMUSER)
 
     C                   PARM                    BJMRDT
     C                   PARM                    BJSBRC
     C                   PARM                    PDBRN
 
      ** OUTPUTS
      ** Error message
 
     C                   PARM                    PErrMs
 
      ** Option selected
      ** Security selected
 
     C                   PARM                    PopSel
     C                   PARM                    PSESNSel
 
      ** Function keys
 
     C                   PARM                    PINKC
     C                   PARM                    PINKL
 
     C                   SELECT
 
      ** F3 - End program
 
     C                   WHEN      PINKC = *ON
     C                   EVAL      WScrn = 'E'
 
      ** Error message returned from browse
 
     C                   WHEN      PErrMs <> *BLANKS
     C                   EXSR      SRSndM
 
      ** F12 - Cancel
 
     C                   WHEN      PINKL = *ON
     C                   EXSR      SRClearScn
     C                   EVAL      WScrn = 'B'
 
      ** Enter - read selected subfile records.
 
     C                   OTHER
     C                   EVAL      PRdNb = 'Y'
     C                   EVAL      WScrn = 'R'
     C                   ENDSL
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRdNBrw - Read next browse subfile record                   *
      *                                                               *
      *****************************************************************
 
     C     SRRdNBrw      BEGSR
 
     C                   CALLB     'SESECSBRW'
 
      ** INPUTS
      ** Return code
 
     C                   PARM      *BLANKS       RetCodeOut
 
      ** Key fields (file pointer)
      ** Selection fields (file select)
 
     C                   PARM      *BLANKS       KeyLists
     C                   PARM      *BLANKS       KeySelect
 
      ** Build subfile
      ** Read subfile record
 
     C                   PARM      *BLANK        PBdSfl
     C                   PARM      'Y'           PRdSfl
 
      ** System run date (SDBANK)
 
     C                   PARM                    BJMRDT
 
      ** Single branch code (SDBANK)
      ** Default user branch (ZMUSER)
 
     C                   PARM                    BJSBRC
     C                   PARM                    PDBRN
 
      ** OUTPUTS
      ** Error message
 
     C                   PARM                    PErrMs
 
      ** Option selected
      ** Security selected
 
     C                   PARM                    PopSel
     C                   PARM                    PSESNSel
 
      ** Function keys enabled
 
     C                   PARM                    PINKC
     C                   PARM                    PINKL
 
      ** If no security detail selected from subfile, reset
      ** read next browse subfile record indicator and then
      ** display initial screen with blank key fields.
 
     C                   IF        POpSel = *BLANK
     C                   CLEAR                   CrSE1ScnFmt
     C                   CLEAR                   NwSE1ScnFmt
     C                   EVAL      PRdNb = *BLANK
     C                   EVAL      WScrn = 'B'
     C                   ELSE
 
      ** Set action to enquiry then retrive security details
 
     C                   EVAL      DDACTN = 'E'
     C                   EVAL      DDSESN = PSESNSel
 
     C                   EXSR      SRRtvSESN
 
      ** If errors occurred in the retrieve module, display
      ** error messages on the initial screen
 
     C                   IF        IdX = 1 or IdX > 1 AND
     C                             MsgIdArr(1) <> 'APM1000'
     C                   EVAL      WScrn = 'I'
     C                   ELSE
 
      ** Move the security details from the master database file
      ** into the update file record
 
     C**********         EVAL      NwSEFilFmt = CrSEFilFmt                                    CSE074
     C**********         EVAL      NwSEFilFmt1 = CrSEFilFmt1                          CSE074 BUG9529
      *                                                                                       CSE074
     C**********         IF        CSE065 = 'Y'                                       CSE074 BUG9529
     C**********         Z-ADD     ALDT          S1ALDT                               CSE074 BUG9529
     C**********         ELSE                                                         CSE074 BUG9529
     C**********         Z-ADD     *ZEROS        S1ALDT                               CSE074 BUG9529
     C**********         ENDIF                                                        CSE074 BUG9529
     C                   EVAL      NwSEFilFmt = CrSEFilFmt                                   BUG9529
      *                                                                                       CSE074
 
      ** Put security details on the screen
 
     C                   EXSR      SRPutSec
 
      ** Display primary screen maintenance
 
     C                   EVAL      WScrn = 'P'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRScrn_I - Process screen 1 initial details only             *
      *                                                               *
      *****************************************************************
 
     C     SRScrn_I      BEGSR
 
      ** Enable all fields on the initial screen as well as all function
      ** keys
 
     C                   EVAL      PEdtFld = 'Y'
     C                   EVAL      PEKyFld = 'Y'
     C                   EVAL      PEINKE  = 'N'
     C                   EVAL      PEINKG  = 'Y'
     C                   EVAL      PEINKH  = 'Y'
     C                   EVAL      PEINKJ  = 'N'
     C                   EVAL      PEINKP  = 'Y'
     C                   EVAL      PEINKL  = 'Y'
 
      ** Process 1st screen
 
     C                   CALLB     'SESECS1DP'
 
      ** INPUTS
      ** Return code
 
     C                   PARM                    RetCodeOut
 
      ** Security 1st screen details from incoming transaction
      ** - screen format
 
     C                   PARM                    NwSE1ScnFmt
 
      ** Securities retrieved from file - file format
 
     C                   PARM                    CrSEFilFmt
 
      ** Enable detail fields indicator
      ** Enable key fields indicator
 
     C                   PARM                    PEDtFld
     C                   PARM                    PEKyFld
 
      ** Enable function keys
 
     C                   PARM                    PEINKE
     C                   PARM                    PEINKG
     C                   PARM                    PEINKH
     C                   PARM                    PEINKJ
     C                   PARM                    PEINKL
     C                   PARM                    PEINKP
 
      ** Security 1st screen error indicators
 
     C                   PARM                    SEESEC1
 
      ** Error fields/message Ids/message data (arrays) from/to caller
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Warning fields/message Ids/message data (arrays) from/to
      ** caller
 
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
 
      ** Write screen with no read indicator
 
     C                   PARM      'N'           WriteOnly
 
      ** System run date (SDBANK)
      ** Plato interface (SDMMOD)
 
     C                   PARM                    BJMRDT
     C                   PARM                    BGN2ST
 
      ** Switchable features
 
     C                   PARM                    CEU018
     C                   PARM                    S01401
     C                   PARM                    CSD006
     C                   PARM                    CGL032                                       CGL035
 
      ** OUTPUTS
      ** Function keys enabled
 
     C                   PARM                    PINKC
     C                   PARM                    PINKE
     C                   PARM                    PINKG
     C                   PARM                    PINKH
     C                   PARM                    PINKJ
     C                   PARM                    PINKL
     C                   PARM                    PINKP
 
      ** Private Banking
 
     C                   PARM                    BGN4ST
 
      ** Reset error fields
 
     C                   EXSR      SRResetErr
 
     C                   SELECT
 
      ** F3 - end program
 
     C                   WHEN      PINKC = *ON
     C                   EVAL      WScrn = 'E'
 
      ** F7 - roll backwards
 
     C                   WHEN      PINKG = *ON
     C                   EXSR      SRRoll
 
      ** F8 - roll forwards
 
     C                   WHEN      PINKH = *ON
     C                   EXSR      SRRoll
 
      ** F12 - cancel on initial screen
 
     C                   WHEN      PINKL = *ON
 
      ** Display browse subfile screen
 
     C                   EXSR      SRClearScn
     C                   EVAL      WScrn = 'B'
     C                   EVAL      WRats = *BLANK
     C                   EVAL      PRdNb = *BLANK
 
      ** F15 - build browse
 
     C                   WHEN      PINKP = *ON
     C                   EXSR      SRSetupKey
     C                   EXSR      SRClearScn
     C                   EVAL      WScrn = 'B'
 
      ** Enter key was pressed, display next screen
 
     C                   OTHER
     C                   EVAL      WScrn = 'P'
     C                   ENDSL
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDefScn1 - Default fields in 1st screen                     *
      *                                                               *
      *****************************************************************
 
     C     SRDefScn1     BEGSR
 
     C                   CALLB     'SESECS1DT'
 
      ** INPUTS
      ** Securities retrieved from file - file format
 
     C                   PARM                    CrSEFilFmt
 
      ** Investment type details
 
     C                   PARM                    PINVTP
 
      ** Redisplay screen indicator
 
     C                   PARM                    PReDsp
 
      ** OUTPUTS
      ** Securities screen 1 details retrieved from file - screen format
 
     C                   PARM                    NwSE1ScnFmt
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRScrn_P - Process screen 1                                  *
      *                                                               *
      *****************************************************************
 
     C     SRScrn_P      BEGSR
 
     C                   EVAL      PEINKE  = 'N'
     C                   EVAL      PEINKG  = 'Y'
     C                   EVAL      PEINKH  = 'Y'
     C                   EVAL      PEINKJ  = 'N'
     C                   EVAL      PEINKL  = 'Y'
     C                   EVAL      PEINKP  = 'Y'
 
     C                   EVAL      PEdtFld = 'N'
     C                   EVAL      PEKyFld = 'N'
 
      ** Process defaulting of 1st screen details before going to 1st screen
 
     C                   EXSR      SRDefScn1
 
      ** Process 1st screen
 
     C                   CALLB     'SESECS1DP'
 
      ** INPUTS
      ** Return code
 
     C                   PARM                    RetCodeOut
 
      ** Security 1st screen details from incoming transaction
      ** - screen format
 
     C                   PARM                    NwSE1ScnFmt
 
      ** Securities retrieved from file - file format
 
     C                   PARM                    CrSEFilFmt
 
      ** Enable detail fields indicator
      ** Enable key fields indicator
 
     C                   PARM                    PEDtFld
     C                   PARM                    PEKyFld
 
      ** Enable function keys
 
     C                   PARM                    PEINKE
     C                   PARM                    PEINKG
     C                   PARM                    PEINKH
     C                   PARM                    PEINKJ
     C                   PARM                    PEINKL
     C                   PARM                    PEINKP
 
      ** Security 1st screen error indicators
 
     C                   PARM                    SEESEC1
 
      ** Error fields/message Ids/message data (arrays) from/to caller
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Warning fields/message Ids/message data (arrays) from/to
      ** caller
 
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
 
      ** Write screen with no read indicator
 
     C                   PARM      'N'           WriteOnly
 
      ** System run date (SDBANK)
      ** Plato interface (SDMMOD)
 
     C                   PARM                    BJMRDT
     C                   PARM                    BGN2ST
 
      ** Switchable features
 
     C                   PARM                    CEU018
     C                   PARM                    S01401
     C                   PARM                    CSD006
     C                   PARM                    CGL032                                       CGL035
 
      ** OUTPUTS
      ** Function keys enabled
 
     C                   PARM                    PINKC
     C                   PARM                    PINKE
     C                   PARM                    PINKG
     C                   PARM                    PINKH
     C                   PARM                    PINKJ
     C                   PARM                    PINKL
     C                   PARM                    PINKP
 
      ** Private Banking
 
     C                   PARM                    BGN4ST
 
     C                   SELECT
 
      ** F3 - end program
 
     C                   WHEN      PINKC = *ON
     C                   EVAL      WScrn = 'E'
 
      ** F7 - roll backwards
 
     C                   WHEN      PINKG = *ON
     C                   EXSR      SRRoll
 
      ** F8 - roll forwards.
 
     C                   WHEN      PINKH = *ON
     C                   EXSR      SRRoll
 
      ** F12 - cancel on primary screen
 
     C                   WHEN      PINKL = *ON
 
      ** Display browse subfile screen
 
     C                   EXSR      SRClearScn
     C                   EVAL      WScrn = 'B'
     C                   EVAL      WRats = *BLANK
     C                   EVAL      PRdNb = *BLANK
 
      ** F15 - build browse
 
     C                   WHEN      PINKP = *ON
     C                   EXSR      SRClearScn
     C                   EXSR      SRBldBrw
 
      ** Enter key was pressed, display next screen
 
     C                   OTHER
     C                   EVAL      WScrn = 'S'
     C                   EXSR      SRDefScn2
     C                   ENDSL
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDefScn2 - Default fields in 2nd screen                     *
      *                                                               *
      *****************************************************************
 
     C     SRDefScn2     BEGSR
 
     C                   CALLB     'SESECS2DT'
 
      ** INPUTS
      ** Details retrieved from file - screen 1
 
     C                   PARM                    NwSE1ScnFmt
 
      ** Securities retrieved from file - file format
 
     C                   PARM                    CrSEFilFmt
 
      ** Passed other information coming from link programs
 
     C                   PARM                    POthInf
 
      ** Externally described DS for investment types
 
     C                   PARM                    PINVTP
 
      ** Risk Management (SDMMOD)
 
     C                   PARM                    BGRKMG
 
      ** Switchable features
 
     C                   PARM                    CSE031
 
      ** OUTPUTS
      ** Security screen 2 details retrieved from file - screen format
 
     C                   PARM                    NwSE2ScnFmt
 
      ** Securities for file update - file format
 
     C                   PARM                    NwSEFilFmt
 
      ** Fields for display only
 
     C                   PARM                    POutFlds
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRScrn_S - Process screen 2                                  *
      *                                                               *
      *****************************************************************
 
     C     SRScrn_S      BEGSR
 
     C                   EVAL      PEINKE  = 'N'
     C                   EVAL      PEINKF  = 'Y'
     C                   EVAL      PEINKG  = 'Y'
     C                   EVAL      PEINKH  = 'Y'
     C                   EVAL      PEINKL  = 'Y'
     C                   EVAL      PEINKP  = 'Y'
 
      ** Only enable F9 (Additional Information) if CSE031 is ON and
      ** the processing type is 3 or 8
 
     C                   IF        CSE031  = 'Y'
     C                   IF        PPROT = '3' OR PPROT = '8'
     C                   EVAL      PEINKI  = 'Y'
     C                   ELSE
     C                   EVAL      PEINKI  = 'N'
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      PEdtFld = 'N'
 
      ** Process 2nd screen
 
     C                   CALLB     'SESECS2DP'
 
      ** INPUTS
      ** Return code
 
     C                   PARM                    RetCodeOut
 
      ** Security 2nd screen details from incoming transaction
      ** - screen format
 
     C                   PARM                    NwSE2ScnFmt
 
      ** Securities retrieved from file - file format
 
     C                   PARM                    CrSEFilFmt
 
      ** Externally described DS for investment types
 
     C                   PARM                    PINVTP
 
      ** Fields for display only
 
     C                   PARM                    POutFlds
 
      ** Last coupon date
      ** Next coupon date
 
     C                   PARM                    PLCPN
     C                   PARM                    PNCD
 
      ** Enable detail fields indicator
 
     C                   PARM                    PEDtFld
 
      ** Securities screen 1 details from incoming transaction
      ** - screen format
 
     C                   PARM                    NwSE1ScnFmt
 
      ** Enable function keys
 
     C                   PARM                    PEINKE
     C                   PARM                    PEINKF
     C                   PARM                    PEINKG
     C                   PARM                    PEINKH
     C                   PARM                    PEINKL
     C                   PARM                    PEINKP
     C                   PARM                    PEINKI
 
      ** Security 2nd screen error indicators
 
     C                   PARM                    SEESEC2
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Warning fields/message Ids/message data (arrays) from/to
      ** caller
 
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
 
      ** Write screen with no read indicator
 
     C                   PARM      'N'           WriteOnly
 
      ** System run date (SDBANK)
      ** Interest Risk Management (SDMMOD)
 
     C                   PARM                    BJMRDT
     C                   PARM                    BGRKMG
 
      ** Switchable features
 
     C                   PARM                    CSE005
     C                   PARM                    CSE007
     C                   PARM                    CEU017
     C                   PARM                    CSE031
     C                   PARM                    CSE037
 
      ** OUTPUTS
      ** Function keys enabled
 
     C                   PARM                    PINKC
     C                   PARM                    PINKE
     C                   PARM                    PINKF
     C                   PARM                    PINKG
     C                   PARM                    PINKH
     C                   PARM                    PINKL
     C                   PARM                    PINKP
     C                   PARM                    PINKI
 
     C                   SELECT
 
      ** F3 - end program
 
     C                   WHEN      PINKC = *ON
     C                   EVAL      WScrn = 'E'
 
      ** F6 - go back to browse subfile screen
 
     C                   WHEN      PINKF = *ON
     C                   EXSR      SRClearScn
     C                   EVAL      WScrn = 'B'
 
      ** F7 - roll backwards
 
     C                   WHEN      PINKG = *ON
     C                   EXSR      SRRoll
 
      ** F8 - roll forwards
 
     C                   WHEN      PINKH = *ON
     C                   EXSR      SRRoll
 
      ** F9 - Additional Information - Display 4th Screen.
 
     C                   WHEN      PINKI = *ON
 
     C                   EVAL      NwSeFilFmtOld = NwSEFilFmt
     C                   EVAL      WScrn = 'G'
 
      ** F12 - cancel on 2nd screen
 
     C                   WHEN      PINKL = *ON
 
      ** Refresh and redisplay screen 1
 
     C                   EVAL      WScrn = 'P'
 
      ** F15 - build browse
 
     C                   WHEN      PINKP = *ON
     C                   EXSR      SRClearScn
     C                   EXSR      SRBldBrw
 
      ** Enter key was pressed
 
     C                   OTHER
 
      ** Display the 5th Screen.
 
     C                   EVAL      WScrn = 'H'
     C                   ENDSL
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRScrn_T - Process screen 3                                  *
      *                                                               *
      *****************************************************************
 
     C     SRScrn_T      BEGSR
 
     C                   EVAL      PEINKE  = 'N'
     C                   EVAL      PEINKF  = 'Y'
     C                   EVAL      PEINKG  = 'Y'
     C                   EVAL      PEINKH  = 'Y'
     C                   EVAL      PEINKL  = 'Y'
     C                   EVAL      PEINKP  = 'Y'
     C                   EVAL      PEdtFld = 'N'
 
      ** Process 3rd screen
 
     C                   CALLB     'SESECS3DP'
 
      ** INPUTS
      ** Return code
 
     C                   PARM                    RetCodeOut
 
      ** Security 1st screen details from incoming transaction
      ** - screen format
 
     C                   PARM                    NwSE1ScnFmt
 
      ** Security 3rd screen details from incoming transaction
      ** - screen format
 
     C                   PARM                    NwSE3ScnFmt
 
      ** Enable detail fields indicator
 
     C                   PARM                    PEDtFld
     C                   PARM                    PPROT                                       BUG9530
 
      ** Enable function keys
 
     C                   PARM                    PEINKE
     C                   PARM                    PEINKF
     C                   PARM                    PEINKG
     C                   PARM                    PEINKH
     C                   PARM                    PEINKL
     C                   PARM                    PEINKP
 
      ** Security 3rd screen error indicators
 
     C                   PARM                    SEESEC3
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Warning fields/message Ids/message data (arrays) from/to
      ** caller
 
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
 
      ** Write screen with no read indicator
 
     C                   PARM      'N'           WriteOnly
 
      ** System run date (SDBANK)
      ** Private banking (SDMMOD)
 
     C                   PARM                    BJMRDT
     C                   PARM                    BGN4ST
 
      ** Switchable features
 
     C                   PARM                    CGL014
     C                   PARM                    CGL032                                       CGL035
 
      ** OUTPUTS
      ** Function keys enabled
 
     C                   PARM                    PINKC
     C                   PARM                    PINKE
     C                   PARM                    PINKF
     C                   PARM                    PINKG
     C                   PARM                    PINKH
     C                   PARM                    PINKL
     C                   PARM                    PINKP
 
     C                   SELECT
 
      ** F3 - end program
 
     C                   WHEN      PINKC = *ON
     C                   EVAL      WScrn = 'E'
 
      ** F6 - go back to browse subfile screen
 
     C                   WHEN      PINKF = *ON
     C                   EXSR      SRClearScn
     C                   EVAL      WScrn = 'B'
 
      ** F3 - Exit
 
     C                   WHEN      PINKC = *ON
     C                   EXSR      SRRoll
 
      ** F7 - roll backwards
 
     C                   WHEN      PINKG = *ON
     C                   EXSR      SRRoll
 
      ** F8 - roll forwards
 
     C                   WHEN      PINKH = *ON
     C                   EXSR      SRRoll
 
      ** F12 - cancel on 3rd screen
 
     C                   WHEN      PINKL = *ON
 
      ** Refresh, return old values for file update and redisplay screen 2
      ** Set up Issue amount 1 to be equal to Issue amount on third screen
      ** only if Risk Management is on and early repayment and new issue.
 
     C                   EVAL      NwSEFilFmt = NwSeFilFmtOld
     C                   MOVE      DDISA1        WISSA1
     C                   IF        BGRKMG = 'Y'  AND  DDERPY ='Y' AND
     C                             DDNISS = 'Y'  AND  WISSA1 = *ZEROS
     C                   EVAL      DDISA1 = DDISA2
     C                   ENDIF
     C                   EVAL      WScrn = 'H'
 
      ** F15 - build browse
 
     C                   WHEN      PINKP = *ON
     C                   EXSR      SRClearScn
     C                   EVAL      WScrn = 'B'
 
      ** Enter key was pressed
 
     C                   OTHER
 
      ** Windows 2000 processing
 
     C                   IF        BGWDPR = 'Y'
     C                   EVAL      WOScrn = WScrn
     C                   EVAL      WScrn = 'W'
     C                   ELSE
 
      ** Read Next Browse Subfile record
 
     C                   IF        PRdNb = 'Y'
     C                   EVAL      WScrn = 'R'
     C                   ELSE
 
      ** Redisplay Browse subfile screen
 
     C                   EXSR      SRClearScn
     C                   EVAL      WScrn = 'B'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRScrn_G - Process screen 4                                  *
      *                                                               *
      *****************************************************************
 
     C     SRScrn_G      BEGSR
 
     C                   EVAL      PEINKE  = 'N'
     C                   EVAL      PEINKF  = 'Y'
     C                   EVAL      PEINKG  = 'Y'
     C                   EVAL      PEINKH  = 'Y'
     C                   EVAL      PEINKL  = 'Y'
     C                   EVAL      PEINKP  = 'Y'
     C                   EVAL      PEdtFld = 'N'
 
      ** Process 4th screen
 
     C                   CALLB     'SESECS4DP'
 
      ** INPUTS
      ** Return code
 
     C                   PARM                    RetCodeOut
 
      ** Security 1st screen details from incoming transaction
      ** - screen format
 
     C                   PARM                    NwSE1ScnFmt
 
      ** Security 2nd screen details from incoming transaction
      ** - screen format
 
     C                   PARM                    NwSE2ScnFmt
 
      ** Security 4th screen details from incoming transaction
      ** - screen format
 
     C                   PARM                    NwSE4ScnFmt
 
      ** Securities retrieved from file - file format
 
     C                   PARM                    CrSEFilFmt
 
      ** Enable detail fields indicator
 
     C                   PARM                    PEDtFld
 
      ** Enable function keys
 
     C                   PARM                    PEINKE
     C                   PARM                    PEINKF
     C                   PARM                    PEINKG
     C                   PARM                    PEINKH
     C                   PARM                    PEINKL
     C                   PARM                    PEINKP
 
      ** Security 4th screen error indicators
 
     C                   PARM                    SEESEC4
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Warning fields/message Ids/message data (arrays) from/to
      ** caller
 
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
 
      ** Write screen with no read indicator
 
     C                   PARM      'N'           WriteOnly
 
      ** System run date (SDBANK)
 
     C                   PARM                    BJMRDT
 
      ** OUTPUTS
      ** Function keys enabled
 
     C                   PARM                    PINKC
     C                   PARM                    PINKE
     C                   PARM                    PINKF
     C                   PARM                    PINKG
     C                   PARM                    PINKH
     C                   PARM                    PINKL
     C                   PARM                    PINKP
 
     C                   SELECT
 
      ** F3 - end program
 
     C                   WHEN      PINKC = *ON
     C                   EVAL      WScrn = 'E'
 
      ** F6 - go back to browse subfile screen
 
     C                   WHEN      PINKF = *ON
     C                   EXSR      SRClearScn
     C                   EVAL      WScrn = 'B'
 
      ** F7 - roll backwards
 
     C                   WHEN      PINKG = *ON
     C                   EXSR      SRRoll
 
      ** F8 - roll forwards
 
     C                   WHEN      PINKH = *ON
     C                   EXSR      SRRoll
 
      ** F12 - cancel on 4th screen, display 2nd Screen
 
     C                   WHEN      PINKL = *ON
 
      ** Redisplay screen 2
 
     C                   EVAL      NwSEFilFmt = NwSeFilFmtOld
     C                   EVAL      WScrn = 'S'
 
      ** F15 - build Select
 
     C                   WHEN      PINKP = *ON
     C                   EXSR      SRClearScn
     C                   EVAL      WScrn = 'B'
 
      ** Enter key was pressed
 
     C                   OTHER
 
      ** Redisplay 2nd screen.
 
     C                   EVAL      WSCRN = 'S'
     C                   ENDSL
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRScrn_H - Process Screen 5.                                 *
      *                                                               *
      *****************************************************************
     C     SRScrn_H      BEGSR
 
      ** Disable the Function Keys if necessary.
 
     C                   EVAL      PEINKF  = 'Y'
     C                   EVAL      PEINKG  = 'Y'
     C                   EVAL      PEINKH  = 'Y'
     C                   EVAL      PEINKP  = 'Y'
     C                   EVAL      PEINKL  = 'Y'
     C                   EVAL      PEdtFld = 'N'
     C                   EVAL      PEINKE  = 'N'
 
      ** Process the 5th Screen.
 
     C                   CALLB     'SESECS5DP'
      *                  ---------------------
 
      ** Input Parameters
      ** ================
 
      ** Return Code
     C                   PARM      *BLANKS       RetCodeOut
 
      ** Securities Screen 1 Details From Incoming Transaction
      ** - Screen Format
     C                   PARM                    NwSE1ScnFmt
 
      ** Securities Screen 5 Details From Incoming Transaction
      ** - Screen Format
     C                   PARM                    NwSE5ScnFmt
 
      ** Securities Details Retrieved From File - File Format
     C                   PARM                    CrSEFilFmt
 
      ** Investment Type Details
     C                   PARM                    PINVTP
 
      ** Display-Only Details
     C                   PARM                    POutFlds
 
      ** Edit Indicator
     C                   PARM                    PEDtFld
 
      ** Function Key Indicators:
 
      ** KE (F05) = Refresh
      ** KF (F06) = Initial Screen
      ** KG (F07) = Read Previous
      ** KH (F08) = Read Next
      ** KL (F12) = Cancel
      ** KP (F15) = Select
     C                   PARM                    PEINKE
     C                   PARM                    PEINKF
     C                   PARM                    PEINKG
     C                   PARM                    PEINKH
     C                   PARM                    PEINKL
     C                   PARM                    PEINKP
 
      ** Securities Screen 5 Error Indicators
     C                   PARM                    SEESEC5
 
      ** Error Fields/Msg. IDs/Msg. Data (Arrays) From/To Caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Warning Fields/Msg. IDs/Msg. Data (Arrays) From/To Caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
 
      ** Write Only Indicator
     C                   PARM      'N'           WriteOnly
 
      ** Standing Data:
 
      ** System Run Date
     C                   PARM                    BJMRDT
 
      ** Switchable Features:
 
      ** Hedge Accounting Phase B
     C                   PARM                    CAS006
 
      ** Output Parameters
      ** =================
 
      ** KC (F03) = Exit
      ** KE (F05) = Refresh
      ** KF (F06) = Initial Screen
      ** KG (F07) = Read Previous
      ** KH (F08) = Read Next
      ** KL (F12) = Cancel
      ** KP (F15) = Select
     C                   PARM                    PINKC
     C                   PARM                    PINKE
     C                   PARM                    PINKF
     C                   PARM                    PINKG
     C                   PARM                    PINKH
     C                   PARM                    PINKL
     C                   PARM                    PINKP
 
      ** Save the Warning Message ID Array.
 
     C                   MOVEA     WMsgIDArr     WPrvWarnAr
 
      ** Reset the Error Fields.
 
     C                   EXSR      SRResetErr
 
      ** Begin Function Key Selection
      ** ============================
 
     C                   SELECT
 
      ** F03 - End Program
      ** -----------------
 
     C                   WHEN      PINKC = *ON
     C                   EVAL      WScrn = 'E'
 
      ** F06 - Initial Screen
      ** --------------------
 
     C                   WHEN      PINKF = *ON
     C                   EXSR      SRClearScn
     C                   EVAL      WScrn = 'I'
 
      ** F07 - Roll Backwards
      ** --------------------
 
     C                   WHEN      PINKG = *ON
     C                   EXSR      SRRoll
 
      ** F08 - Roll Forwards
      ** -------------------
 
     C                   WHEN      PINKH = *ON
     C                   EXSR      SRRoll
 
      ** F12 - Cancel
      ** ------------
 
     C                   WHEN      PINKL = *ON
 
      ** Refresh and redisplay Screen 2.
 
     C                   EVAL      WScrn = 'S'
 
      ** F15 - Build Subfile Browse
      ** --------------------------
 
     C                   WHEN      PINKP = *ON
     C                   EXSR      SRClearScn
     C                   EXSR      SRBldBrw
 
      ** The Enter Key was pressed.
 
     C                   OTHER
 
      ** If Action is Enquire and the Security is a new issue or if
      ** Private Banking is enabled, display the 3rd Screen.
 
     C                   IF        (DDACTN = 'E' AND DDNISS = 'Y') OR
     C                             (DDACTN = 'E' AND BGN4ST = 'Y') OR
     C                             (DDACTN = 'E' AND CGL014 = 'Y')
     C                   EVAL      WScrn  = 'T'
     C                   ELSE
 
      ** Display the SE Risk Weighted Asset Codes MNT if CGL018 = 'Y'
      ** and Action Code = 'E'.
 
     C                   IF        CGL018 = 'Y' AND
     C                             DDACTN = 'E'
     C                   EVAL      WOScrn = WScrn
     C                   EVAL      WScrn  = 'Z'
     C                   LEAVESR
     C                   ENDIF
 
      ** Windows 2000 Processing.
 
     C                   IF        BGWDPR = 'Y'
     C                   EVAL      WOScrn = WScrn
     C                   EVAL      WScrn = 'W'
     C                   LEAVESR
     C                   ENDIF
 
      ** Read Next Browse Subfile record.
 
     C                   IF        PRdNb = 'Y'
     C                   EVAL      WScrn = 'R'
     C                   LEAVESR
     C                   ENDIF
 
      ** Redisplay the initial screen with blank fields.
 
     C                   EXSR      SRClearScn
     C                   EVAL      WScrn = 'I'
     C                   ENDIF
 
     C                   ENDSL
 
      ** End Function Key Selection
      ** ==========================
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRoll - Roll backward or forward through the security       *
      *           details file                                        *
      *                                                               *
      *****************************************************************
 
     C     SRRoll        BEGSR
 
      ** Reset/clear previous error warning messages for every new record
 
     C                   EXSR      SRResetErr
 
      ** Read next or previous record in the securities file
      ** according to function key taken (F7=INKG or F8=INKH)
 
     C                   IF        PINKG = *ON
     C                   EVAL      PRdBck = 'Y'
     C                   EVAL      PRdFwd = *BLANK
     C                   ELSE
     C                   EVAL      PRdBck = *BLANK
     C                   EVAL      PRdFwd = 'Y'
     C                   ENDIF
 
     C                   CALLB     'SESECSRED'
 
      ** INPUTS
      ** Return code
 
     C                   PARM                    RetCodeOut
 
      ** Security shortname (file pointer)
      ** Read backwards
      ** Read forwards
 
     C                   PARM                    DDSESN
     C                   PARM                    PRdBck
     C                   PARM                    PRdFwd
 
      ** Single branch code (SDBANK)
      ** Default user branch (ZMUSER)
 
     C                   PARM                    BJSBRC
     C                   PARM                    PDBRN
 
      ** OUTPUTS
      ** Error message
 
     C                   PARM                    PErrMs
 
      ** Security shortname read
 
     C                   PARM                    PSeSnSel
 
      ** If error message returned from read, send it to screen.
 
     C                   IF        PErrMs <> *BLANKS
     C                   EXSR      SRSndM
     C                   ELSE
 
      ** Retrieve security details.
 
     C                   EVAL      DDACTN = 'E'
     C                   MOVE      PSeSnSel      DDSESN
 
     C                   EXSR      SRRtvSESN
 
      ** If errors occurred in the retrieval of security
      ** details, display error messages on the primary screen
 
     C                   IF        IdX <> *ZERO
     C                   EVAL      WScrn = 'I'
     C                   ELSE
 
      ** Move security details retrieved from the master database file
      ** into the update file record
 
     C**********         MOVEL     CrSEFilFmt    NwSEFilFmt                                   CSE074
     C**********         MOVEL     CrSEFilFmt1   NwSEFilFmt1                          CSE074 BUG9529
      *                                                                                       CSE074
     C**********         IF        CSE065 = 'Y'                                       CSE074 BUG9529
     C**********         Z-ADD     ALDT          S1ALDT                               CSE074 BUG9529
     C**********         ELSE                                                         CSE074 BUG9529
     C**********         Z-ADD     *ZEROS        S1ALDT                               CSE074 BUG9529
     C**********         ENDIF                                                        CSE074 BUG9529
     C                   MOVEL     CrSEFilFmt    NwSEFilFmt                                  BUG9529
 
      ** Put security details on the screen
 
     C                   EXSR      SRPutSec
 
     C                   EVAL      WScrn = 'P'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRtvSESN - Retrieve security details                        *
      *                                                               *
      *****************************************************************
 
     C     SRRtvSESN     BEGSR
 
     C                   CALLB     'SESECSRTV'
 
      ** INPUTS
      ** Return code
 
     C                   PARM                    RetCodeOut
 
      ** Mode = '*SIN  ' (screen input function)
      ** Response mode
 
     C                   PARM                    PMode
     C                   PARM                    PRespMode
 
      ** Action code
 
     C                   PARM                    DDACTN
 
      ** Security shortname
      ** Front office transaction Id
      ** Old security shortname
 
     C                   PARM                    FRNT
     C                   PARM                    DDSESN
     C                   PARM                    PParOSESN
 
      ** Process old security details indicator
 
     C                   PARM                    PPOldSecDtl
 
      ** Single branch code (SDBANK)
      ** Default user branch (ZMUSER)
 
     C                   PARM                    BJSBRC
     C                   PARM                    PDBRN
 
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM                    IdX
 
      ** OK action code
      ** OK security shortname
 
     C                   PARM                    OKACTN
     C                   PARM                    OKSESN
 
      ** Securities retrieved from file - file format
 
     C                   PARM                    CrSEFilFmt
 
      ** Externally described DS for investment types
 
     C                   PARM                    PINVTP
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPutSec - Convert securities details from file to screen    *
      *             format                                            *
      *                                                               *
      *****************************************************************
 
     C     SRPutSec      BEGSR
 
     C                   CALLB     'SESECSCVT'
 
      ** INPUTS
      ** Return code
 
     C                   PARM                    RetCodeOut
 
      ** Securities retrieved from file - file format
 
     C                   PARM                    CrSEFilFmt
 
      ** Processing type - from file INVTPD
 
     C                   PARM                    PPROT
 
      ** Action code
 
     C                   PARM                    DDACTN
 
      ** Passed other information coming from link programs
 
     C                   PARM                    POthInf
 
      ** Process old security details indicator
 
     C                   PARM                    PPOldSecDtl
 
      ** Date format indicator (SDBANK)
      ** Midas run day number (SDBANK)
      ** Interest Risk Management (SDMMOD)
      ** Plato Interface (SDMMOD)
      ** Private Banking (SDMMOD)
 
     C                   PARM                    BJDFIN
     C                   PARM                    BJRDNB
     C                   PARM                    BGRKMG
     C                   PARM                    BGN2ST
     C                   PARM                    BGN4ST
 
      ** Switchnble Features
 
     C                   PARM                    CEU018
     C                   PARM                    CSE005
     C                   PARM                    S01401
     C                   PARM                    CSE023
     C                   PARM                    CSD006
     C                   PARM                    CAP060
     C                   PARM                    CSE031
     C                   PARM                    CAS006
     C                   PARM                    CSE037
     C                   PARM                    CGL014
     C                   PARM                    CSE071                                      BUG9530
     C                   PARM                    CGL032                                       CGL035
 
      ** OUTPUTS
      ** Details retrieved from file - screens 1-4
 
     C                   PARM                    CrSE1ScnFmt
     C                   PARM                    CrSE2ScnFmt
     C                   PARM                    CrSE3ScnFmt
     C                   PARM                    CrSE4ScnFmt
     C                   PARM                    CrSE5ScnFmt
                                                                                            BUG10218
      ** Securities Screen 6 Details Retrieved From File                                    BUG10218
      ** - Screen Format                                                                    BUG10218
     C                   PARM                    CrSE6ScnFmt                                BUG10218
 
      ** Last coupon date
      ** Next coupon date
 
     C                   PARM                    PLCPN
     C                   PARM                    PNCD
 
      ** Linked maintenance flag
 
     C                   PARM      *BLANK        PParmLink
 
     C                   EVAL      NwSe1ScnFmt = CrSe1ScnFmt
     C                   EVAL      NwSe2ScnFmt = CrSe2ScnFmt
     C                   EVAL      NwSe3ScnFmt = CrSe3ScnFmt
     C                   EVAL      NwSe4ScnFmt = CrSe4ScnFmt
     C                   EVAL      NwSe5ScnFmt = CrSe5ScnFmt
 
      ** Pass data to Windrow program
 
     C                   IF        CSE023 = 'Y'
     C                   CLEAR                   DATA
     C                   EVAL      #1CRTT = DDCRTT
     C                   EVAL      #1INCT = DDINCT
     C                   EVAL      #1EXCD = DDEXCD
     C                   EVAL      #1OIDI = DDOIDI
     C                   EVAL      #1APIE = DDAPIE
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSndM - Send error message to screen                        *
      *                                                               *
      *****************************************************************
 
     C     SRSndM        BEGSR
 
      ** If single branching, user cannot browse file.
 
     C                   IF        PErrMs = 'FXM0292'
     C                   EVAL      OKACTN = 'N'
     C                   ENDIF
 
      ** Add error message to array passed to screen.
 
     C                   Z-ADD     1             Ex
     C     *BLANK        LOOKUP    FldNameArr(Ex)                         99
     C                   EVAL      FldNameArr(Ex) = '*ANY'
     C                   EVAL      MsgIdArr(Ex) = PErrMs
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetupKey - Setup keys for pointer or selection.            *
      *                                                               *
      *****************************************************************
 
     C     SRSetupKey    BEGSR
 
      ** Setup key/selection fields.
 
     C                   EVAL      WDSESN = DDSESN
     C                   EVAL      WDSRPN = DDSRPN
 
     C                   MOVEL     DDISSR        WDISSR
 
     C                   EVAL      WDNMCY = DDNMCY
     C                   EVAL      WDSITP = DDSITP
     C                   EVAL      WDPRTP = *BLANKS
     C                   EVAL      WDINCS = DDINCS
     C                   EVAL      WDISIN = DDISIN
     C                   EVAL      WDT2RF = DDT2RF
     C                   EVAL      WDSTAT = *BLANKS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRClearScn - Clear screen data structures                    *
      *                                                               *
      *****************************************************************
 
     C     SRClearScn    BEGSR
 
      ** Clear screen data structures for new processing.
 
     C                   CLEAR                   CrSE1ScnFmt
     C                   CLEAR                   CrSE2ScnFmt
     C                   CLEAR                   CrSE3ScnFmt
     C                   CLEAR                   CrSE4ScnFmt
     C                   CLEAR                   CrSE5ScnFmt
 
     C                   CLEAR                   NwSE1ScnFmt
     C                   CLEAR                   NwSE2ScnFmt
     C                   CLEAR                   NwSE3ScnFmt
     C                   CLEAR                   NwSE4ScnFmt
     C                   CLEAR                   NwSE5ScnFmt
 
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
     C                   CLEAR                   IdX
 
     C                   CLEAR                   WFldNamArr
     C                   CLEAR                   WMsgIdArr
     C                   CLEAR                   WMsgDtaArr
     C                   CLEAR                   WIdX
 
      ** Initialise screen fields error indicators.
 
     C                   EVAL      SEESEC1 = *ALL'Y'
     C                   EVAL      SEESEC2 = *ALL'Y'
     C                   EVAL      SEESEC3 = *ALL'Y'
     C                   EVAL      SEESEC4 = *ALL'Y'
     C                   EVAL      SEESEC5 = *ALL'Y'
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRWindow - Call window manager program.                       *
      *                                                               *
      *****************************************************************
 
     C     SRWindow      BEGSR
 
     C                   EVAL      #1PROT = PPROT
     C/COPY WNCPYSRC,SESECSSC01
 
      ** Call window manager
 
     C                   CALL      'WN0010'
     C                   PARM      'SESECSSIN'   PPgm
     C                   PARM                    PKey
     C                   PARM      DDACTN        PAction
     C                   PARM                    Data
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      *BLANKS       PSpareW
 
      ** Process returned command keys
      ** F3, exit and return to calling program
 
     C                   SELECT
     C                   WHEN      PRtcd = 'Y2U9999'
     C                   EVAL      WScrn = 'E'
 
      ** If Cmd12 pressed, return to previous screen;
      ** otherwise, go to confirmation screen
 
     C                   WHEN      PRtcd = 'USR0790'
     C                   EVAL      WScrn = WOScrn
 
     C                   OTHER
 
      ** Read Next Browse Subfile record
 
     C                   IF        PRdNb = 'Y'
     C                   EVAL      WScrn = 'R'
     C                   ELSE
     C                   EXSR      SRClearScn
     C                   EVAL      WScrn = 'B'
     C                   ENDIF
     C                   ENDSL
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************                      CGLL018
      *                                                               *                      CGLL018
      * SRScrn_Z - Call Securities Risk Weighted Asset Codes          *                      CGLL018
      *                                                               *                      CGLL018
      *****************************************************************                      CGLL018
                                                                                             CGLL018
     C     SRScrn_Z      BEGSR                                                               CGLL018
      *                                                                                      CGLL018
      ** Call Securities Risk weighted Asset Codes Maintenance                               CGLL018
      *                                                                                      CGLL018
     C                   CALL      'SEC001300'                                               CGLL018
     C                   PARM      *BLANK        PRtcd                                       CGLL018
     C                   PARM      DDSESN        PSesn                                       CGLL018
     C                   PARM      DDACTN        PAction                                     CGLL018
      *                                                                                      CGLL018
      ** Windows 2000 processing.                                                            CGLL018
     C                   IF        BGWDPR = 'Y'                                              CGLL018
     C                   EVAL      WOScrn = WScrn                                            CGLL018
     C                   EVAL      WScrn = 'W'                                               CGLL018
     C                   ELSE                                                                CGLL018
     C                   EVAL      WScrn = 'F'                                               CGLL018
     C                   ENDIF                                                               CGLL018
                                                                                             CGLL018
     C     ESRScrn_Z     ENDSR                                                               CGLL018
                                                                                             CGLL018
      *****************************************************************                      CGLL018
      /EJECT                                                                                 CGLL018
      *****************************************************************
      *                                                               *
      *  *INZSR - Program initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C                   EVAL      DBPGM = 'SESECSENQ'
 
      ** Access bank details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRtcd <> *BLANKS
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBKey = POptn
     C                   Z-ADD     1             DBase
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access ICD details for securities trading
 
     C                   CALL      'AOSTRDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDSTRD        PARM      SDSTRD        DSSDY
 
     C                   IF        PRtcd <> *BLANKS
     C                   EVAL      DBFile = 'SDSTRDPD'
     C                   EVAL      DBKey = POptn
     C                   Z-ADD     2             DBase
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access midas modules
 
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDMMOD        PARM      SDMMOD        DSFDY
 
     C                   IF        PRtcd <> *BLANKS
     C                   EVAL      DBFile = 'SDMMODPD'
     C                   EVAL      DBKey = POptn
     C                   Z-ADD     3             DBase
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Check if enhancement CSE005 on
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CSE005'      PSARd
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRtcd <> *BLANKS  AND   PRtcd <> '*NRF   '
     C                   EVAL      DBFile = 'SCSARDPD'
     C                   EVAL      DBKey = 'CSE005'
     C                   Z-ADD     4             DBase
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtcd = *BLANKS
     C                   EVAL      CSE005 = 'Y'
     C                   ELSE
     C                   EVAL      CSE005 = 'N'
     C                   ENDIF
 
      ** Check if enhancement CSE007 is on
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CSE007'      PSARd
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRtcd <> *BLANKS  AND  PRtcd <> '*NRF   '
     C                   EVAL      DBFile = 'SCSARDPD'
     C                   EVAL      DBKey = 'CSE007'
     C                   Z-ADD     5             DBase
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtcd = *BLANKS
     C                   EVAL      CSE007 = 'Y'
     C                   ELSE
     C                   EVAL      CSE007 = 'N'
     C                   ENDIF
 
      ** Check if enhancement CEU017 is on
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CEU017'      PSARd
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRtcd <> *BLANKS  AND  PRtcd <> '*NRF   '
     C                   EVAL      DBFile = 'SCSARDPD'
     C                   EVAL      DBKey = 'CEU017'
     C                   Z-ADD     6             DBase
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtcd = *BLANKS
     C                   EVAL      CEU017 = 'Y'
     C                   ELSE
     C                   EVAL      CEU017 = 'N'
     C                   ENDIF
 
      ** Check if enhancement CEU018 is on
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CEU018'      PSARd
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRtcd <> *BLANKS  AND  PRtcd <> '*NRF   '
     C                   EVAL      DBFile = 'SCSARDPD'
     C                   EVAL      DBKey = 'CEU018'
     C                   Z-ADD     7             DBase
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtcd = *BLANKS
     C                   EVAL      CEU018 = 'Y'
     C                   ELSE
     C                   EVAL      CEU018 = 'N'
     C                   ENDIF
 
      ** Check if enhancement S01401 is on
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'S01401'      PSARd
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRtcd <> *BLANKS  AND  PRtcd <> '*NRF   '
     C                   EVAL      DBFile = 'SCSARDPD'
     C                   EVAL      DBKey = 'S01401'
     C                   Z-ADD     8             DBase
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtcd = *BLANKS
     C                   EVAL      S01401 = 'Y'
     C                   ELSE
     C                   EVAL      S01401 = 'N'
     C                   ENDIF
 
      ** Check if enhancement CSE023 is on
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CSE023'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRtcd <> *BLANKS  AND  PRtcd <> '*NRF   '
     C                   EVAL      DBFile = 'SCSARDPD'
     C                   EVAL      DBKey = 'CSE023'
     C                   Z-ADD     9             DBase
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtcd = *BLANKS
     C                   EVAL      CSE023 = 'Y'
     C                   ELSE
     C                   EVAL      CSE023 = 'N'
     C                   ENDIF
 
      ** Check if enhancement CAP060 is on
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CAP060'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRtcd <> *BLANKS  AND  PRtcd <> '*NRF   '
     C                   EVAL      DBFile = 'SCSARDPD'
     C                   EVAL      DBKey = 'CAP060'
     C                   Z-ADD     10            DBase
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtcd = *BLANKS
     C                   EVAL      CAP060 = 'Y'
     C                   ELSE
     C                   EVAL      CAP060 = 'N'
     C                   ENDIF
 
      ** Check if enhancement CSD006 is on
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CSD006'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRtcd <> *BLANKS  AND  PRtcd <> '*NRF   '
     C                   EVAL      DBFile = 'SCSARDPD'
     C                   EVAL      DBKey = 'CSD006'
     C                   Z-ADD     11            DBase
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtcd = *BLANKS
     C                   EVAL      CSD006 = 'Y'
     C                   ELSE
     C                   EVAL      CSD006 = 'N'
     C                   ENDIF
 
      ** Check if enhancement CSE031 is on
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CSE031'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRtcd <> *BLANKS  AND  PRtcd <> '*NRF   '
     C                   EVAL      DBFile = 'SCSARDPD'
     C                   EVAL      DBKey = 'CSE031'
     C                   Z-ADD     12            DBase
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtcd = *BLANKS
     C                   EVAL      CSE031 = 'Y'
     C                   ELSE
     C                   EVAL      CSE031 = 'N'
     C                   ENDIF
 
      ** Check if enhancement CSC011 is on
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *Blanks       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSC011'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBKEY  = 'CSC011'
     C                   EVAL      DBASE  = 13
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CSC011 = 'Y'
     C                   IN        SC24X7
     C                   IN        SDSTAT
 
     C                   IF        S1SUPP = LIBR
     C                   EVAL      WkDate = S1DATE
     C                   EVAL      WkNext = S1NEXT
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      CSC011 = 'N'
     C                   EVAL      WkDate = BJRDNB
     C                   EVAL      WkNext = BJDNWD
     C                   ENDIF
 
      ** Check if enhancement CAS006 is on
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CAS006'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRtcd <> *BLANKS  AND  PRtcd <> '*NRF   '
     C                   EVAL      DBFile = 'SCSARDPD'
     C                   EVAL      DBKey = 'CAS006'
     C                   Z-ADD     14            DBase
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtcd = *BLANKS
     C                   EVAL      CAS006 = 'Y'
     C                   ELSE
     C                   EVAL      CAS006 = 'N'
     C                   ENDIF
 
      ** Check if enhancement CSE037 is on
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CSE037'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRtcd <> *BLANKS  AND  PRtcd <> '*NRF   '
     C                   EVAL      DBFile = 'SCSARDPD'
     C                   EVAL      DBKey = 'CSE037'
     C                   Z-ADD     15            DBase
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtcd = *BLANKS
     C                   EVAL      CSE037 = 'Y'
     C                   ELSE
     C                   EVAL      CSE037 = 'N'
     C                   ENDIF
 
      ** Check if enhancement CGL014 is on
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CGL014'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRtcd <> *BLANKS  AND  PRtcd <> '*NRF   '
     C                   EVAL      DBFile = 'SCSARDPD'
     C                   EVAL      DBKey = 'CGL014'
     C                   Z-ADD     15            DBase
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtcd = *BLANKS
     C                   EVAL      CGL014 = 'Y'
     C                   ELSE
     C                   EVAL      CGL014 = 'N'
     C                   ENDIF
 
      ** Check if enhancement CGL018 is on
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CGL018'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRtcd <> *BLANKS  AND  PRtcd <> '*NRF   '
     C                   EVAL      DBFile = 'SCSARDPD'
     C                   EVAL      DBKey = 'CGL018'
     C                   Z-ADD     15            DBase
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtcd = *BLANKS
     C                   EVAL      CGL018 = 'Y'
     C                   ELSE
     C                   EVAL      CGL018 = 'N'
     C                   ENDIF
      ** Access SAR details to see if CSE065 is enabled.                                      CSE074
                                                                                              CSE074
     C**********         CALLB     'AOSARDR0'                                         CSE074 BUG9529
     C**********         PARM      *BLANKS       PRTCD                                CSE074 BUG9529
     C**********         PARM      '*VERIFY'     POPTN                                CSE074 BUG9529
     C**********         PARM      'CSE065'      PSARD                                CSE074 BUG9529
     C*****SCSARD        PARM      SCSARD        DSFDY                                CSE074 BUG9529
                                                                                              CSE074
     C**********         IF        PRTCD = *BLANKS                                    CSE074 BUG9529
     C**********         EVAL      CSE065 = 'Y'                                       CSE074 BUG9529
     C**********         ELSE                                                         CSE074 BUG9529
                                                                                              CSE074
     C**********         IF        PRTCD <> '*NRF'                                    CSE074 BUG9529
     C**********         EVAL      DBFILE = 'SCSARDPD'                                CSE074 BUG9529
     C**********         EVAL      DBKEY  = 'CSE065'                                  CSE074 BUG9529
     C**********         EVAL      DBASE  = 17                                        CSE074 BUG9529
     C**********         EXSR      *PSSR                                              CSE074 BUG9529
     C**********         ENDIF                                                        CSE074 BUG9529
                                                                                              CSE074
     C**********         ENDIF                                                        CSE074 BUG9529
                                                                                              CSE074
                                                                                              CGL035
      ** Check if enhancement CGL032 is on                                                    CGL035
                                                                                              CGL035
     C                   CALLB     'AOSARDR0'                                                 CGL035
     C                   PARM      *BLANKS       PRtcd                                        CGL035
     C                   PARM      '*VERIFY'     POptn                                        CGL035
     C                   PARM      'CGL032'      PSARD                                        CGL035
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL035
                                                                                              CGL035
     C                   IF        PRtcd <> *BLANKS  AND  PRtcd <> '*NRF   '                  CGL035
     C                   EVAL      DBFile = 'SCSARDPD'                                        CGL035
     C                   EVAL      DBKey = 'CGL032'                                           CGL035
     C                   Z-ADD     16            DBase                                        CGL035
     C                   EXSR      *PSSR                                                      CGL035
     C                   ENDIF                                                                CGL035
                                                                                              CGL035
     C                   IF        PRtcd = *BLANKS                                            CGL035
     C                   EVAL      CGL032 = 'Y'                                               CGL035
     C                   ELSE                                                                 CGL035
     C                   EVAL      CGL032 = 'N'                                               CGL035
     C                   ENDIF                                                                CGL035
      **********                                                                             BUG7029
      ***Retrieve*ZMUSER*details                                                             BUG7029
      **********                                                                             BUG7029
     C******DTAARA       DEFINE                  ZMUSER                                      BUG7029
     C**********         IN        ZMUSER                                                    BUG7029
 
      ** Reset error fields, clear screen
 
     C                   EXSR      SRResetErr
     C                   EXSR      SRClearScn
 
      ** Build browse subfile
 
     C                   EVAL      WScrn = 'B'
 
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
 
      /COPY ZACPYSRC,DBFIELDS
 
      ** Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SESECS012
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
 
      /COPY ZACPYSRC,PSSR_ILE
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
**  CPY@
(c) Misys International Banking Systems Ltd. 2003
