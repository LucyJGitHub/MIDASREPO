     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Collateral 2nd detail screen validation')     *
/*OVR *  OVRDBF FILE(FOCLTLXX) TOFILE(FOCLT) SHARE(*NO)               *
/*OVR *  OVRDBF FILE(FCLTYLXX) TOFILE(FCLTY) SHARE(*NO)               *
/*OVR *  OVRDBF FILE(CLOANLXX) TOFILE(CLOAN) SHARE(*NO)               *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLCOLL2VL - Collateral Second Detail Screen Validation       *
      *                                                               *
      *  Function: This module will perform validation on the second  *
      *            detail screen and return any error conditions or   *
      *            messages to the screen input module.               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CGL165             Date 17Feb15               *
      *  Prev Amend No. CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CRE075             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CPK025             Date 28Aug06               *
      *                 CGL072             Date 10Jul06               *
      *                 CDL049             Date 07Jul06               *
      *                 211966             Date 06Jun06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CDL038             Date 10May05               *
      *                 237063             Date 20Nov05               *
      *                 BUG7411            Date 01Jun05               *
      *                 CSW037A            Date 02May05               *
      *                 CDL028             Date 07Feb05               *
      *                 229544             Date 15Sep04               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 CDL018             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL016             Date 03Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 CGL018             Date 01Oct02               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 208640             Date 06Jan03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *                 176613             Date 24Mar00               *
      *                 176608             Date 22Mar00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CGL011  *CREATE    Date 20Sep99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CPK025 - MidasPlus 1.3 packaging.  Customer number change.   *
      *  CGL072 - Allow GL Accounts in Collateral                     *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  211966 - If secured LE ref. changed from loan to facility or *
      *           vice versa, original ref. is not cleared on file.   *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  237063 - EU Tax fixes upgrade to MP build 103 (Recompile).   *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG7411- CDL028 fields missing from DLGHISPD (Recompile)     *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  229544 - Recompiled due to inserted fields in DLCHISPD.      *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CDL020 - Apply Base Rate at Value Date (Recompile)           *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *           (Recompile)                                         *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *           (Recompile)                                         *
      *  CDL016 - Automatic rollover of Fixed Term Loans/Deposits     *
      *           (Recompile)                                         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CGL018 - Risk Weighted Assets                                *
      *  208640 - Check if RETAIL ins ON before reading AORETL0.      *
      *  176613 - Warning message should be displayed if the security *
      *           position starts after the signing date.             *
      *  176608 - Wrong error message narrative.                      *
      *  CGL011 - Collateral Processing for Midas (Phase 1)           *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Futures and Options Client Details File
     FFOCLTLXX  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Faciltiy Details File
     FFCLTYLXX  IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(FCLTYHHF:FCLTYFNF:FCLTYZZF)
      *
      ** Loan Details File
     FCLOANLXX  IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(CLOANHHF:CLOANCKF:CLOANZ1F)
      *
      ** Deal Details File
     FDEALSALL  IF   E           K DISK    INFSR(*PSSR)
     F                                     INFDS(FmtRead)                       176608
      *
      ** Customer Positions File
     FCPOSN     IF   E           K DISK    INFSR(*PSSR)
      *
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
      **    True       logical = *on (for indcator processing)
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
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
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
      ** File format data structure
     D FmtRead         DS                                                       176608
     D  WRecFmt          *RECORD                                                176608
      ** Transaction/Account Number breakdown
     D ACKEY           DS
      ** Collateral Account
     D  WBRCA                  1      3
     D  WCNUM                  4      9
     D  WCUCD                 10     12
     D***WACCD                 13     16                                                      CGL029
     D***WACSQ                 17     18                                                      CGL029
     D  WACCD                 13     22                                                       CGL029
     D  WACSQ                 23     24                                                       CGL029
     D  WRETL                  1     10
     D***WLAST8                11     18                                                      CGL029
     D***WLAST9                11     19                                                      CGL029
     D***WLAST1                19     19                                                      CGL029
     D  WLAST14               11     24                                                       CGL029
     D  WLAST15               11     25                                                       CGL029
     D  WLAST1                25     25                                                       CGL029
      ** Collateral Transaction
     D  WDLNO                  1      6
     D  WLAST13                7     19
      ** Customer Positions
     D  WCSBA                  1      3
     D  WCSSC                  4     13
     D  WCSCN                 14     19
      *
     D Indicators      DS                  BASED(IndicatorP)
     D  ValdNumrc             87     87
     D  EntryFnd              88     88
     D  RcdNotFnd             89     89
      *
      ** Array of Valid Provider Customer
     D ValProv         S             10    DIM(12)
      *
      ** Collateral File Definition Details
     D NwCoFilFmt    E DS                  EXTNAME(GLCOLLPD)
      *
      ** Collateral Screen Definition Details
     D NwCoScnFmt    E DS                  EXTNAME(GLSCOLPD)
      ** Customer Number
     D  WCNUMA                77     82
      ** Array for Provider Customer in screen
     D  DDPROV               307    426    dim(12)
      *
      ** Error indicator for Collateral Details
     D OkCoScnFld    E DS                  EXTNAME(GLECOLPD)
      ** Indicator array for Provider Customer
     D  IndProv               44     55    dim(12)
      *
      ** Externally described DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Externally described DS for Midas Modules Details                                    208640
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                                  208640
      *                                                                                       208640
      ** Externally described DS for Retail Details
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
      *
      ** Externally described DS for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      ** Externally described DS for Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      ** Externally described DS for Client Limits Details
     D SDCLLM        E DS                  EXTNAME(SDCLLMPD)
      *
      ** Externally described DS for Facility Types Details
     D SDFACT        E DS                  EXTNAME(SDFACTPD)
      *
      ** Externally described DS for Account Details
     D SDACCT        E DS                  EXTNAME(ACCNTAB)
      *
      ** SAR file details accessed via access program  AOSARDR0                               CGL018
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CGL018
     D                                     PREFIX(S)                                          CGL018
      *
      ** DS for Access Programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS for Access Programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** DS for Access Programs
     D DSLDY         E DS                  EXTNAME(DSLDY)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message IDs
     D Ix              S              3P 0
      *
      ** Index for arrays of warning messages
     D WIx             S              3P 0
      *
      ** Indicator Array
     DIndicatorP       S               *   INZ(%ADDR(*IN))
      *
      ** Parameters for ZALIGN
     D ZAlignOk        S              1A
     D ZFIELD          S             16A
     D ZADEC           S              1P 0
     D ZADIG           S              2P 0
      *
     D WWACCR          S                   LIKE(CDACCR)
     D WWIAMT          S                   LIKE(CDIAMT)
     D WWLNLM          S                   LIKE(CDLNLM)
      *
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
      ** Perform detail validation process
     C                   EXSR      SRDETVAL
      *
      ** If no errors, set up outstanding fields for valid file.
     C     IX            IFEQ      0
     C                   EXSR      SRSETUPVLD
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDETVAL - Detail Validation processing                      *
      *                                                               *
      *****************************************************************
     C     SRDETVAL      BEGSR
      *
     C                   EXSR      SRPROV
      *
     C     CDCOPT        IFEQ      'P'
     C                   EXSR      SRPRICE
     C                   ENDIF
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*DBERR '     PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      DDCCY         PCCY              3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C                   EXSR      SRACCR
      *
     C     CDCOPT        IFEQ      'M'
     C                   EXSR      SRINCOME
     C                   ENDIF
      *
     C     DDGNSP        IFEQ      'S'
     C                   EXSR      SRMODULE
     C                   EXSR      SRFCLTY
     C                   EXSR      SRLOAN
     C                   EXSR      SRACNT
     C                   ENDIF
      *
     C     CDCOPT        IFEQ      'A'
     C     CDCOPT        OREQ      'D'
     C     CDCOPT        OREQ      'P'
     C                   EXSR      SRTRAN
     C                   EXSR      SRINEX
     C                   ENDIF
      *
     C                   MOVEL     'Y'           DDIRF1OK
     C                   MOVEL     'Y'           DDIRF2OK
     C                   MOVEL     'Y'           DDIRF3OK
     C                   MOVEL     'Y'           DDIRF4OK
     C                   MOVEL     'Y'           DDIRF5OK
     C                   MOVEL     'Y'           DDIRF6OK
     C                   MOVEL     'Y'           DDDORFOK
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPROV - Provider Details Validation process                 *
      *                                                               *
      *****************************************************************
     C     SRPROV        BEGSR
      *
     C                   CLEAR                   ValProv
      *
     C     DDPR01        IFEQ      *BLANKS
     C     DDPR02        ANDEQ     *BLANKS
     C     DDPR03        ANDEQ     *BLANKS
     C     DDPR04        ANDEQ     *BLANKS
     C     DDPR05        ANDEQ     *BLANKS
     C     DDPR06        ANDEQ     *BLANKS
     C     DDPR07        ANDEQ     *BLANKS
     C     DDPR08        ANDEQ     *BLANKS
     C     DDPR09        ANDEQ     *BLANKS
     C     DDPR10        ANDEQ     *BLANKS
     C     DDPR11        ANDEQ     *BLANKS
     C     DDPR12        ANDEQ     *BLANKS
     C                   MOVEL     'N'           DDPR01OK
     C                   ADD       1             Ix
     C                   MOVEL     'DDPROV'      FldNameArr(Ix)
     C                   MOVEL     'COL0074'     MsgIdArr(Ix)
      *
     C                   ELSE
      *
     C                   Z-ADD     1             PIX               2 0
      *
     C     PIX           DOWLT     13
      *
     C                   MOVEL     DDPROV(PIX)   @PROV            10
      *
     C     @PROV         IFNE      *BLANKS
     C                   CALLB     'AOCUSTR1'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      @PROV         PKEY1
     C                   PARM      *Blanks       PKYST
     C     SDCUST        PARM      SDCUST        DSLDY
      *
     C     PRTCD         IFNE      *BLANKS
     C     BBPAIN        OREQ      'P'
     C                   MOVE      'N'           INDPROV(PIX)
     C                   ADD       1             Ix
     C                   MOVEL     'DDPRxx'      FldNameArr(Ix)
     C                   MOVE      PIX           FldNameArr(Ix)
     C                   MOVEL     'COL0075'     MsgIdArr(Ix)
      *
     C                   ELSE
      *
     C                   MOVEL     *BLANKS       DDPROV(PIX)
     C                   MOVEL     BBCUST        DDPROV(PIX)
     C     DDPROV(PIX)   LOOKUP    VALPROV                                88
      *
     C     EntryFnd      IFEQ      True
     C                   MOVE      'N'           INDPROV(PIX)
     C                   ADD       1             Ix
     C                   MOVEL     'DDPRxx'      FldNameArr(Ix)
     C                   MOVE      PIX           FldNameArr(Ix)
     C                   MOVEL     'COL0076'     MsgIdArr(Ix)
     C                   ELSE
     C                   MOVEL     DDPROV(PIX)   ValProv(PIX)
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   ADD       1             PIX
      *
     C                   ENDDO
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPRICE - Price Feed Link Validation process                 *
      *                                                               *
      *****************************************************************
     C     SRPRICE       BEGSR
      *
     C     DDPFLK        IFNE      *BLANK
     C     DDPFLK        ANDNE     'Y'
     C     DDPFLK        ANDNE     'N'
     C                   MOVEL     'N'           DDPFLKOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDPFLK'      FldNameArr(Ix)
     C                   MOVEL     'COL0077'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C     DDPFLK        IFEQ      *BLANK
     C                   MOVE      'N'           DDPFLK
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRACCR - Accrued Interest Validation process                 *
      *                                                               *
      *****************************************************************
     C     SRACCR        BEGSR
      *
     C                   Z-ADD     0             WWACCR
      *
     C     DDACCR        IFNE      *BLANKS
     C                   MOVEL     *Blanks       ZFIELD
     C                   MOVEL     DDACCR        ZFIELD
     C                   Z-ADD     A6NBDP        ZADEC
     C     13            SUB       ZADEC         ZADIG
     C                   EXSR      SRZALIGN
     C     ZALIGNOK      IFNE      'Y'
     C                   MOVEL     'N'           DDACCROK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACCR'      FldNameArr(Ix)
     C                   MOVEL     'COL0078'     MsgIdArr(Ix)
     C                   ELSE
     C                   MOVE      ZFIELD        WWACCR
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINCOME - Income Rate/Amount Validation process             *
      *                                                               *
      *****************************************************************
     C     SRINCOME      BEGSR
      *
     C                   Z-ADD     0             WWIAMT
      *
     C     DDIAMT        IFNE      *BLANKS
     C                   MOVEL     *Blanks       ZFIELD
     C                   MOVEL     DDIAMT        ZFIELD
     C                   Z-ADD     A6NBDP        ZADEC
     C     15            SUB       ZADEC         ZADIG
     C                   EXSR      SRZALIGN
     C     ZALIGNOK      IFNE      'Y'
     C                   MOVEL     'N'           DDIAMTOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDIAMT'      FldNameArr(Ix)
     C                   MOVEL     'COL0079'     MsgIdArr(Ix)
     C                   ELSE
     C                   MOVE      ZFIELD        WWIAMT
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMODULE - Module Validation process                         *
      *                                                               *
      *****************************************************************
     C     SRMODULE      BEGSR
      *
     C     DDACTN        IFNE      'I'
     C     DDMODS        ANDNE     CDMODS
     C     CDMODS        ANDNE     *BLANKS
     C                   MOVEL     'N'           DDMODSOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDMODS'      FldNameArr(Ix)
     C                   MOVEL     'COL0123'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C/COPY WNCPYSRC,GLCOL2VC01
     C                   IF        CGL072 = 'Y'                                               CGL072
      *                                                                                       CGL072
      ***  If CGL072 is switched on allow GL accounts                                         CGL072
      ***  Module secured must be 'LE','RE','MM','FX','FO','CM' or 'GL'                       CGL072
      *                                                                                       CGL072
     C     DDMODS        IFNE      'LE'                                                       CGL072
     C     DDMODS        ANDNE     'RE'                                                       CGL072
     C     DDMODS        ANDNE     'MM'                                                       CGL072
     C     DDMODS        ANDNE     'FX'                                                       CGL072
     C     DDMODS        ANDNE     'FO'                                                       CGL072
     C     DDMODS        ANDNE     'RE'                                                       CGL072
     C     DDMODS        ANDNE     'GL'                                                       CGL072
     C                   MOVEL     'N'           DDMODSOK                                     CGL072
     C                   ADD       1             Ix                                           CGL072
     C                   MOVEL     'DDMODS'      FldNameArr(Ix)                               CGL072
     C                   MOVEL     'GLM0254'     MsgIdArr(Ix)                                 CGL072
     C                   ENDIF                                                                CGL072
     C                   ELSE                                                                 CGL072
      *                                                                                       CGL072
     C     DDMODS        IFNE      'LE'
     C     DDMODS        ANDNE     'RE'
     C     DDMODS        ANDNE     'MM'
     C     DDMODS        ANDNE     'FX'
     C     DDMODS        ANDNE     'FO'
     C     DDMODS        ANDNE     'CM'
     C                   MOVEL     'N'           DDMODSOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDMODS'      FldNameArr(Ix)
     C                   MOVEL     'COL0080'     MsgIdArr(Ix)
     C                   ENDIF
      *                                                                                       CGL072
     C                   ENDIF                                                                CGL072
      *                                                                                       CGL072
     C/COPY WNCPYSRC,GLCOL2VC02
      *
     C     DDMODS        IFEQ      'FX'
     C     DDMODS        OREQ      'MM'
     C     CGL018        ANDNE     'Y'                                          CGL018
      *
     C     DDENTY        IFEQ      'K'
     C                   MOVE      'S'           @LEVEL            1
     C                   MOVE      'SYS'         @ENTITY           3
     C                   ELSE
     C                   MOVE      DDENTY        @LEVEL
     C     @LEVEL        IFEQ      'C'
     C                   MOVE      DDCMPY        @ENTITY
     C                   ELSE
     C                   MOVE      DDBRCA        @ENTITY
     C                   ENDIF
     C                   ENDIF
      *
     C                   CALL      'AOCLLMR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      WCNUMA        PCNUM             6
     C                   PARM                    @LEVEL
     C                   PARM                    @ENTITY
     C     SDCLLM        PARM      SDCLLM        DSFDY
      *
     C     DDMODS        IFEQ      'FX'
     C     PRTCD         IFNE      *BLANKS
     C     DZFLAM        OREQ      *ZERO
     C                   MOVEL     'W'           DDMODSOK
     C                   ADD       1             WIx
     C                   EVAL      WFldNamArr(WIx) = 'DDMODS'
     C                   EVAL      WMsgIdArr(WIx)  = 'COL0081'
     C                   ENDIF
     C                   ENDIF
      *
     C     DDMODS        IFEQ      'MM'
     C     PRTCD         IFNE      *BLANKS
     C     DZLLAM        OREQ      *ZERO
     C                   MOVEL     'W'           DDMODSOK
     C                   ADD       1             WIx
     C                   EVAL      WFldNamArr(WIx) = 'DDMODS'
     C                   EVAL      WMsgIdArr(WIx)  = 'COL0082'
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     DDMODS        IFEQ      'FO'
      *
     C**********         TESTN                   WCNUMA               87                      CSD027
     C*****ValdNumrc     IFEQ      False                                                      CSD027
     C**********         Z-ADD     0             WCNUM#            6 0                        CSD027
     C**********         ELSE                                                                 CSD027
     C**********         MOVE      WCNUMA        WCNUM#                                       CSD027
     C**********         ENDIF                                                                CSD027
     C                   MOVE      WCNUMA        WCNUM#            6                          CSD027
      *
     C     WCNUM#        CHAIN     FOCLTLXX                           89
      *
     C     RcdNotFnd     IFEQ      True
     C     RcdNotFnd     OREQ      False
     C     RECI          ANDNE     'D'
     C                   MOVEL     'W'           DDMODSOK
     C                   ADD       1             WIx
     C                   EVAL      WFldNamArr(WIx) = 'DDMODS'
     C                   EVAL      WMsgIdArr(WIx)  = 'COL0083'
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFCLTY - Facility Validation process                        *
      *                                                               *
      *****************************************************************
     C     SRFCLTY       BEGSR
      *
     C                   MOVEL     *BLANKS       WFCLTY           11
     C                   EVAL      WFCLTY = DDFCUS + DDFTYP + DDFSEQ
      *
     C     DDMODS        IFNE      'LE'
     C     WFCLTY        ANDNE     *BLANKS
     C                   MOVEL     'N'           DDFCUSOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDFCUS'      FldNameArr(Ix)
     C                   MOVEL     'COL0084'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C     DDMODS        IFEQ      'LE'
     C     WFCLTY        ANDNE     *BLANKS
      *
     C                   CALLB     'AOCUSTR1'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      DDFCUS        PKEY1            10
     C                   PARM      *Blanks       PKYST             7
     C     SDCUST        PARM      SDCUST        DSLDY
      *
     C     PRTCD         IFNE      *BLANKS
     C     BBPAIN        OREQ      'P'
     C                   MOVE      'N'           DDFCUSOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDFCUS'      FldNameArr(Ix)
     C                   MOVEL     'COL0085'     MsgIdArr(Ix)
     C                   ELSE
     C                   MOVEL     BBCUST        DDFCUS
     C                   ENDIF
      *
     C                   CALL      'AOFACTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      DDFTYP        PFCTY             3
     C     SDFACT        PARM      SDFACT        DSFDY
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVE      'N'           DDFTYPOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDFTYP'      FldNameArr(Ix)
     C                   MOVEL     'COL0086'     MsgIdArr(Ix)
     C                   ELSE
     C                   MOVEL     AMFCTY        DDFTYP
     C                   ENDIF
      *
     C                   MOVE      DDFSEQ        WWNUM2            2 0
     C     WWNUM2        IFLT      01
     C     WWNUM2        ORGT      99
     C                   MOVE      'N'           DDFSEQOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDFSEQ'      FldNameArr(Ix)
     C                   MOVEL     'COL0087'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C     DDFCUSOK      IFEQ      'Y'
     C     DDFTYPOK      ANDEQ     'Y'
     C     DDFSEQOK      ANDEQ     'Y'
     C                   MOVEL     DDFCUS        KFCUS
     C                   MOVEL     DDFTYP        KFTYP
     C                   MOVEL     DDFSEQ        KFSEQ
     C                   MOVEL     'A'           KRCDT
     C     KFCLTY        CHAIN     FCLTYLXX                           89
      *
     C     RcdNotFnd     IFEQ      True
     C     RcdNotFnd     OREQ      False
     C     RECI          ANDNE     'D'
     C                   MOVE      'W'           DDFCUSOK
     C                   ADD       1             WIx
     C                   EVAL      WFldNamArr(WIx) = 'DDFCUS'
     C                   EVAL      WMsgIdArr(WIx)  = 'COL0088'
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRLOAN - Loan/Limit Validation process                       *
      *                                                               *
      *****************************************************************
     C     SRLOAN        BEGSR
      *
     C                   MOVEL     DDLNLM        WWLNLM
      *
     C     DDMODS        IFNE      'LE'
     C     DDMODS        ANDNE     'CM'
     C     DDLNLM        ANDNE     *BLANKS
     C     CGL018        ANDNE     'Y'                                                        CGL018
     C     CGL018        OREQ      'Y'                                                        CGL018
     C     DDMODS        ANDNE     'LE'                                                       CGL018
     C     DDMODS        ANDNE     'CM'                                                       CGL018
     C     DDMODS        ANDNE     'MM'                                                       CGL018
     C     DDLNLM        ANDNE     *BLANKS                                                    CGL018
     C                   MOVE      'N'           DDLNLMOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDLNLM'      FldNameArr(Ix)
     C                   MOVEL     'COL0089'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C     DDMODS        IFEQ      'LE'
     C     WFCLTY        ANDNE     *BLANKS
     C     DDLNLM        ANDNE     *BLANKS
     C                   MOVE      'N'           DDLNLMOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDLNLM'      FldNameArr(Ix)
     C                   MOVEL     'COL0090'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C     DDMODS        IFEQ      'LE'
     C     WFCLTY        ANDEQ     *BLANKS
     C     DDLNLM        ANDEQ     *BLANKS
     C                   MOVE      'N'           DDLNLMOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDLNLM'      FldNameArr(Ix)
     C                   MOVEL     'COL0091'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C     DDMODS        IFEQ      'LE'
     C     WFCLTY        ANDEQ     *BLANKS
     C     DDLNLM        ANDNE     *BLANKS
      *
     C*****WWLNLM        IFLT      000001                                                     CLE148
     C*****WWLNLM        ORGT      999999                                                     CLE148
     C                   IF        (WLoanAlpha = 'N' AND                                      CLE148
     C                             (WWLNLM < '000001' OR WWLNLM > '999999'))                  CLE148
     C                             OR                                                         CLE148
     C                             (WLoanAlpha = 'Y' AND                                      CLE148
     C                             (WWLNLM < 'AAAAAA' OR WWLNLM > '999999'))                  CLE148
     C                   MOVE      'N'           DDLNLMOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDLNLM'      FldNameArr(Ix)
     C                   MOVEL     'COL0092'     MsgIdArr(Ix)
      *
     C                   ELSE
      *
     C                   MOVEL     DDLNLM        KLNRF
     C                   MOVEL     'A'           KRCDT
     C     KCLOAN        CHAIN     CLOANLXX                           89
      *
     C     RcdNotFnd     IFEQ      TRUE
     C     RcdNotFnd     OREQ      False
     C     RECI          ANDNE     'D'
     C                   MOVE      'W'           DDLNLMOK
     C                   ADD       1             WIx
     C                   EVAL      WFldNamArr(WIx) = 'DDLNLM'
     C                   EVAL      WMsgIdArr(WIx)  = 'COL0093'
      *
     C                   ELSE
      *
     C     PTYP          IFEQ      66
     C     PTYP          OREQ      67
     C     PTYP          OREQ      69
     C     PTYP          OREQ      72
     C                   MOVE      'N'           DDLNLMOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDLNLM'      FldNameArr(Ix)
     C                   MOVEL     'COL0094'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C     CGL018        IFEQ      'Y'                                                        CGL018
     C     DDMODS        ANDEQ     'MM'                                                       CGL018
      *                                                                                       CGL018
     C*****WWLNLM        IFLT      000001                                              CGL018 CLE148
     C*****WWLNLM        ORGT      999999                                              CGL018 CLE148
     C     WWLNLM        IFLT      '000001'                                                   CLE148
     C     WWLNLM        ORGT      '999999'                                                   CLE148
     C     DDLNLM        OREQ      *BLANKS                                                    CGL018
     C                   MOVE      'N'           DDLNLMOK                                     CGL018
     C                   ADD       1             Ix                                           CGL018
     C                   MOVEL     'DDLNLM'      FldNameArr(Ix)                               CGL018
     C                   MOVEL     'COL0092'     MsgIdArr(Ix)                                 CGL018
      *                                                                                       CGL018
     C                   ELSE                                                                 CGL018
      *                                                                                       CGL018
     C*****WWLNLM        CHAIN     DEALSALL                           89               CGL018 CLE148
     C     *LIKE         DEFINE    DLNO          WWLNLM2                                      CLE148
     C                   MOVEL     WWLNLM        WWLNLM2                                      CLE148
     C     WWLNLM2       CHAIN     DEALSALL                           89                      CLE148
      *                                                                                       CGL018
     C     RcdNotFnd     IFEQ      TRUE                                                       CGL018
     C     RcdNotFnd     OREQ      False                                                      CGL018
     C     RECI          ANDNE     'D'                                                        CGL018
     C                   MOVE      'W'           DDLNLMOK                                     CGL018
     C                   ADD       1             WIx                                          CGL018
     C                   EVAL      WFldNamArr(WIx) = 'DDLNLM'                                 CGL018
     C                   EVAL      WMsgIdArr(WIx)  = 'COL0130'                                CGL018
      *                                                                                       CGL018
     C                   ELSE                                                                 CGL018
      *                                                                                       CGL018
     C     DTYP          IFNE      'IP'                                                       CGL018
     C     DTYP          ANDNE     'CL'                                                       CGL018
     C     DTYP          ANDNE     'TI'                                                       CGL018
     C                   MOVE      'N'           DDLNLMOK                                     CGL018
     C                   ADD       1             Ix                                           CGL018
     C                   MOVEL     'DDLNLM'      FldNameArr(Ix)                               CGL018
     C                   MOVEL     'COL0131'     MsgIdArr(Ix)                                 CGL018
     C                   ENDIF                                                                CGL018
     C                   ENDIF                                                                CGL018
     C                   ENDIF                                                                CGL018
     C                   ENDIF                                                                CGL018
      *                                                                                       CGL018
     C     DDMODS        IFEQ      'CM'
     C     DDLNLM        ANDEQ     *BLANKS
     C                   MOVE      'N'           DDLNLMOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDLNLM'      FldNameArr(Ix)
     C                   MOVEL     'COL0095'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C     DDMODS        IFEQ      'CM'
     C     DDLNLM        ANDNE     *BLANKS
     C*****WWLNLM        IFLT      000001                                                     CLE148
     C*****WWLNLM        ORGT      999999                                                     CLE148
     C     WWLNLM        IFLT      '000001'                                                   CLE148
     C     WWLNLM        ORGT      '999999'                                                   CLE148
     C                   MOVE      'N'           DDLNLMOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDLNLM'      FldNameArr(Ix)
     C                   MOVEL     'COL0096'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRACNT - Account Validation process                          *
      *                                                               *
      *****************************************************************
     C     SRACNT        BEGSR
      *
     C     DDMODS        IFNE      'RE'
     C     DDACNT        ANDNE     *BLANKS
      *** IF CGL072 is on then allow GL accounts                                              CGL072
      *** Secured Retail Account must be blank if Module Secured is                           CGL072
      *** not 'RE' or 'GL'                                                                    CGL072
      *                                                                                       CGL072
     C                   IF        CGL072 = 'Y' AND DDMODS = 'GL'                             CGL072
     C                             AND (DDACNT <> *BLANKS)                                    CGL072
     C                   ELSE                                                                 CGL072
      *                                                                                       CGL072
     C/COPY WNCPYSRC,GLCOL2VC03
     C                   MOVE      'N'           DDACNTOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACNT'      FldNameArr(Ix)
     C                   MOVEL     'COL0097'     MsgIdArr(Ix)
      *                                                                                       CGL072
     C                   IF        CGL072 = 'Y'                                               CGL072
     C                   MOVEL     'GLM0256'     MsgIdArr(Ix)                                 CGL072
     C                   ENDIF                                                                CGL072
     C                   ENDIF                                                                CGL072
      *                                                                                       CGL072
     C/COPY WNCPYSRC,GLCOL2VC04
     C                   ENDIF
      *
     C     DDMODS        IFEQ      'RE'
     C     DDACNT        ANDEQ     *BLANKS
     C                   MOVE      'N'           DDACNTOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACNT'      FldNameArr(Ix)
     C                   MOVEL     'COL0098'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C     DDMODS        IFEQ      'RE'
     C     DDACNT        ANDNE     *BLANKS
      *                                                                                       CGL072
     C     DDMODS        OREQ      'GL'                                                       CGL072
     C     CGL072        ANDEQ     'Y'                                                        CGL072
     C     DDACNT        ANDNE     *BLANKS                                                    CGL072
      *                                                                                       CGL072
     C/COPY WNCPYSRC,GLCOL2VC05
      *
     C                   MOVEL     DDACNT        ACKEY
      *
     C     @RETNO        IFEQ      'Y'
     C*****WLAST8        ANDEQ     *BLANKS                                                    CGL029
     C     WLAST14       ANDEQ     *BLANKS                                                    CGL029
      *
     C                   CALLB     'AOACCTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      WRETL         PRETL            10
     C                   PARM      *BLANKS       PCNUM             6
     C                   PARM      *BLANKS       PCUCD             3
     C**********         PARM      *BLANKS       PACCD             4                          CGL029
     C                   PARM      *BLANKS       PACCD            10                          CGL029
     C                   PARM      *BLANKS       PACSQ             2
     C                   PARM      *BLANKS       PBRCA             3
     C     SDACCT        PARM      SDACCT        DSSDY
      *
     C                   ELSE
      *
     C                   CALLB     'AOACCTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      *BLANKS       PRETL
     C                   PARM      WCNUM         PCNUM
     C                   PARM      WCUCD         PCUCD
     C                   PARM      WACCD         PACCD
     C                   PARM      WACSQ         PACSQ
     C                   PARM      WBRCA         PBRCA
     C     SDACCT        PARM      SDACCT        DSSDY
      *
     C                   ENDIF
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVE      'W'           DDACNTOK
     C                   ADD       1             WIx
     C                   EVAL      WFldNamArr(WIx) = 'DDACNT'
     C                   EVAL      WMsgIdArr(WIx)  = 'COL0099'
     C                   ELSE
     C                   SELECT
     C     ATYP          WHENNE    'R'
     C/COPY WNCPYSRC,GLCOL2VC06
      *                                                                                       CGL072
     C                   IF        CGL072 = 'Y'                                               CGL072
      *                                                                                       CGL072
      *** IF CGL072 is on then allow GL accounts                                              CGL072
      *** Therefore no need to check if ATYP is Retail.                                       CGL072
      *                                                                                       CGL072
      *                                                                                       CGL072
     C                   ELSE                                                                 CGL072
      *                                                                                       CGL072
     C                   MOVE      'N'           DDACNTOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACNT'      FldNameArr(Ix)
     C                   MOVEL     'COL0100'     MsgIdArr(Ix)
      *                                                                                       CGL072
     C                   ENDIF                                                                CGL072
      *                                                                                       CGL072
     C/COPY WNCPYSRC,GLCOL2VC07
     C     RECI          WHENNE    'D'
     C     ACST          OREQ      'C'
     C                   MOVE      'W'           DDACNTOK
     C                   ADD       1             WIx
     C                   EVAL      WFldNamArr(WIx) = 'DDACNT'
     C                   EVAL      WMsgIdArr(WIx)  = 'COL0099'
     C     CLBL          WHENGE    0
     C                   MOVE      'W'           DDACNTOK
     C                   ADD       1             WIx
     C                   EVAL      WFldNamArr(WIx) = 'DDACNT'
     C                   EVAL      WMsgIdArr(WIx)  = 'COL0125'
     C                   ENDSL
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTRAN - Collateral Transaction/Account Validation process   *
      *                                                               *
      *****************************************************************
     C     SRTRAN        BEGSR
      *
     C     DDCTRN        IFEQ      *BLANKS
     C                   MOVE      'N'           DDCTRNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDCTRN'      FldNameArr(Ix)
     C                   MOVEL     'COL0101'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C                   MOVEL     DDCTRN        ACKEY
      *
     C     CDCOPT        IFEQ      'A'
     C     DDCTRN        ANDNE     *BLANKS
      *
     C     WLAST1        IFNE      *BLANK
     C                   MOVE      'N'           DDCTRNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDCTRN'      FldNameArr(Ix)
     C                   MOVEL     'COL0102'     MsgIdArr(Ix)
      *
     C                   ELSE
      *
     C     @RETNO        IFEQ      'Y'
     C*****WLAST9        ANDEQ     *BLANKS                                                    CGL029
     C     WLAST15       ANDEQ     *BLANKS                                                    CGL029
      *
     C                   CALLB     'AOACCTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      WRETL         PRETL
     C                   PARM      *BLANKS       PCNUM
     C                   PARM      *BLANKS       PCUCD
     C                   PARM      *BLANKS       PACCD
     C                   PARM      *BLANKS       PACSQ
     C                   PARM      *BLANKS       PBRCA
     C     SDACCT        PARM      SDACCT        DSSDY
      *
     C                   ELSE
      *
     C                   CALLB     'AOACCTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      *BLANKS       PRETL
     C                   PARM      WCNUM         PCNUM
     C                   PARM      WCUCD         PCUCD
     C                   PARM      WACCD         PACCD
     C                   PARM      WACSQ         PACSQ
     C                   PARM      WBRCA         PBRCA
     C     SDACCT        PARM      SDACCT        DSSDY
      *
     C                   ENDIF
      *
     C     PRTCD         IFNE      *BLANKS
     C     RECI          ORNE      'D'
     C     ACST          OREQ      'C'
     C                   MOVE      'N'           DDCTRNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDCTRN'      FldNameArr(Ix)
     C                   MOVEL     'COL0103'     MsgIdArr(Ix)
     C                   ELSE
     C     ATYP          IFNE      'R'
     C/COPY WNCPYSRC,GLCOL2VC09
      *                                                                                       CGL072
     C                   IF        CGL072 = 'Y'                                               CGL072
      *                                                                                       CGL072
      *** IF CGL072 is on then allow GL accounts                                              CGL072
      *** Therefore no need to check if ATYP is Retail.                                       CGL072
      *                                                                                       CGL072
      *                                                                                       CGL072
     C                   ELSE                                                                 CGL072
      *                                                                                       CGL072
     C                   MOVE      'N'           DDCTRNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDCTRN'      FldNameArr(Ix)
     C                   MOVEL     'COL0104'     MsgIdArr(Ix)
     C/COPY WNCPYSRC,GLCOL2VC10
      *                                                                                       CGL072
     C                   ENDIF                                                                CGL072
      *                                                                                       CGL072
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
     C     CDCOPT        IFEQ      'D'
     C     DDCTRN        ANDNE     *BLANKS
      *
     C                   TESTN                   WDLNO                87
      *
     C     WLAST13       IFNE      *BLANKS
     C     ValdNumrc     OREQ      False
     C                   MOVE      'N'           DDCTRNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDCTRN'      FldNameArr(Ix)
     C                   MOVEL     'COL0105'     MsgIdArr(Ix)
     C                   ELSE
      *
     C                   MOVE      WDLNO         WDLNO#            6 0
      *
     C     WDLNO#        IFLT      000001
     C     WDLNO#        ORGT      999999
     C                   MOVE      'N'           DDCTRNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDCTRN'      FldNameArr(Ix)
     C                   MOVEL     'COL0106'     MsgIdArr(Ix)
      *
     C                   ELSE
      *
     C     WDLNO#        CHAIN     DEALSALL                           89
      *
     C     RcdNotFnd     IFEQ      TRUE
     C     RcdNotFnd     OREQ      False
     C     WRecFmt       ANDEQ     'MMDELDP0'                                   176608
     C     HKDDLT        ANDNE     *Blank                                       176608
     C     RcdNotFnd     OREQ      False                                        176608
     C     WRecFmt       ANDEQ     'DEALSDCF'                                   176608
     C     RECI          ANDNE     'D'
     C                   MOVE      'N'           DDCTRNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDCTRN'      FldNameArr(Ix)
     C                   MOVEL     'COL0107'     MsgIdArr(Ix)
     C                   ELSE
     C     RcdNotFnd     IFEQ      False                                        176608
     C     WRecFmt       IFEQ      'DEALSDCF'                                   176608
     C     DTYP          IFNE      'IT'
     C     DTYP          ANDNE     'TD'
     C     DTYP          ANDNE     'CD'
     C     DTYP          ANDNE     'CI'
     C     DTYP          ANDNE     'FT'
     C     DTYP          ANDNE     'DT'
     C     DTYP          ANDNE     'LT'
     C                   MOVE      'N'           DDCTRNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDCTRN'      FldNameArr(Ix)
     C                   MOVEL     'COL0108'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ELSE                                                   176608
                                                                                176608
      ** Deal not yet authorised or invalid deal type, send appropriate         176608
      ** message                                                                176608
                                                                                176608
     C     WRecFmt       IFEQ      'MMDELDP0'                                   176608
     C     HKMTYP        IFNE      'IT'                                         176608
     C     HKMTYP        ANDNE     'TD'                                         176608
     C     HKMTYP        ANDNE     'CD'                                         176608
     C     HKMTYP        ANDNE     'CI'                                         176608
     C     HKMTYP        ANDNE     'FT'                                         176608
     C     HKMTYP        ANDNE     'DT'                                         176608
     C     HKMTYP        ANDNE     'LT'                                         176608
     C                   MOVE      'N'           DDCTRNOK                       176608
     C                   ADD       1             Ix                             176608
     C                   MOVEL     'DDCTRN'      FldNameArr(Ix)                 176608
     C                   MOVEL     'COL0108'     MsgIdArr(Ix)                   176608
     C                   ELSE                                                   176608
     C                   MOVE      'W'           DDCTRNOK                       176608
     C                   ADD       1             WIx                            176608
     C                   EVAL      WFldNamArr(WIx) = 'DDCTRN'                   176608
     C                   EVAL      WMsgIdArr(WIx)  = 'COL0129'                  176608
     C                   ENDIF                                                  176608
     C                   ENDIF                                                  176608
     C                   ENDIF                                                  176608
     C                   ENDIF                                                  176608
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C     CDCOPT        IFEQ      'P'
     C     DDCTRN        ANDNE     *BLANKS
      *
     C**********         TESTN                   WCSCN                87                      CSD027
     C*****ValdNumrc     IFEQ      False                                                      CSD027
     C**********         Z-ADD     0             WCSCN#            6 0                        CSD027
     C**********         ELSE                                                                 CSD027
     C**********         MOVE      WCSCN         WCSCN#                                       CSD027
     C**********         ENDIF                                                                CSD027
     C                   MOVE      WCSCN         WCSCN#            6                          CSD027
      *
     C     KCPOSN        CHAIN     CPOSN                              89
      *
     C     RcdNotFnd     IFEQ      True
     C     RcdNotFnd     OREQ      False
     C     RECI          ANDNE     'D'
     C                   MOVE      'N'           DDCTRNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDCTRN'      FldNameArr(Ix)
     C                   MOVEL     'COL0109'     MsgIdArr(Ix)
     C                   ELSE
     C     CSDA          IFGT      CDSDAT                                       176613
     C                   MOVE      'W'           DDCTRNOK                       176613
     C                   ADD       1             WIx                            176613
     C                   EVAL      WFldNamArr(WIx) = 'DDCTRN'                   176613
     C                   EVAL      WMsgIdArr(WIx)  = 'COL0130'                  176613
     C                   ENDIF                                                  176613
     C     CSNT          IFLE      0
     C                   MOVE      'W'           DDCTRNOK
     C                   ADD       1             WIx
     C                   EVAL      WFldNamArr(WIx) = 'DDCTRN'
     C                   EVAL      WMsgIdArr(WIx)  = 'COL0126'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINEX - Inclusive/Exclusive if Interest/Charges Indicator   *
      *           Validation process                                  *
      *                                                               *
      *****************************************************************
     C     SRINEX        BEGSR
      *
     C     DDINEX        IFNE      *BLANK
     C     DDINEX        ANDNE     'I'
     C     DDINEX        ANDNE     'E'
     C                   MOVEL     'N'           DDINEXOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDINEX'      FldNameArr(Ix)
     C                   MOVEL     'COL0110'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C     DDINEX        IFEQ      *BLANK
     C                   MOVE      'I'           DDINEX
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZALIGN - Validate/Right allign numeric field               *
      *                                                               *
      *****************************************************************
     C     SRZALIGN      BEGSR
      *
     C                   CALLB     'ZALIGN'
     C                   PARM      'Y'           ZAlignOk
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSETUPVLD - Set up validated fields for the valid file.     *
      *                                                               *
      *****************************************************************
     C     SRSETUPVLD    BEGSR
      *
     C     DDPR01        IFNE      *BLANKS
     C                   MOVEL     DDPR01        CDPR01
     C                   ELSE
     C                   MOVEL     *BLANKS       CDPR01
     C                   ENDIF
     C     DDPR02        IFNE      *BLANKS
     C                   MOVEL     DDPR02        CDPR02
     C                   ELSE
     C                   MOVEL     *BLANKS       CDPR02
     C                   ENDIF
     C     DDPR03        IFNE      *BLANKS
     C                   MOVEL     DDPR03        CDPR03
     C                   ELSE
     C                   MOVEL     *BLANKS       CDPR03
     C                   ENDIF
     C     DDPR04        IFNE      *BLANKS
     C                   MOVEL     DDPR04        CDPR04
     C                   ELSE
     C                   MOVEL     *BLANKS       CDPR04
     C                   ENDIF
     C     DDPR05        IFNE      *BLANKS
     C                   MOVEL     DDPR05        CDPR05
     C                   ELSE
     C                   MOVEL     *BLANKS       CDPR05
     C                   ENDIF
     C     DDPR06        IFNE      *BLANKS
     C                   MOVEL     DDPR06        CDPR06
     C                   ELSE
     C                   MOVEL     *BLANKS       CDPR06
     C                   ENDIF
     C     DDPR07        IFNE      *BLANKS
     C                   MOVEL     DDPR07        CDPR07
     C                   ELSE
     C                   MOVEL     *BLANKS       CDPR07
     C                   ENDIF
     C     DDPR08        IFNE      *BLANKS
     C                   MOVEL     DDPR08        CDPR08
     C                   ELSE
     C                   MOVEL     *BLANKS       CDPR08
     C                   ENDIF
     C     DDPR09        IFNE      *BLANKS
     C                   MOVEL     DDPR09        CDPR09
     C                   ELSE
     C                   MOVEL     *BLANKS       CDPR09
     C                   ENDIF
     C     DDPR10        IFNE      *BLANKS
     C                   MOVEL     DDPR10        CDPR10
     C                   ELSE
     C                   MOVEL     *BLANKS       CDPR10
     C                   ENDIF
     C     DDPR11        IFNE      *BLANKS
     C                   MOVEL     DDPR11        CDPR11
     C                   ELSE
     C                   MOVEL     *BLANKS       CDPR11
     C                   ENDIF
     C     DDPR12        IFNE      *BLANKS
     C                   MOVEL     DDPR12        CDPR12
     C                   ELSE
     C                   MOVEL     *BLANKS       CDPR12
     C                   ENDIF
      *
     C     CDCOPT        IFEQ      'P'
     C                   MOVEL     DDPFLK        CDPFLK
     C                   ENDIF
      *
     C     DDACCR        IFNE      *BLANKS
     C                   Z-ADD     WWACCR        CDACCR
     C                   ENDIF
      *
     C     DDIAMT        IFNE      *BLANKS
     C     CDCOPT        ANDEQ     'M'
     C                   Z-ADD     WWIAMT        CDIAMT
     C                   ENDIF
      *
     C     DDGNSP        IFEQ      'S'
      *
     C                   MOVEL     DDMODS        CDMODS
     C     DDFCUS        IFNE      *BLANKS
     C                   MOVEL     DDFCUS        CDFCUS
     C                   ELSE                                                   211966
     C*****              EVAL      CDFCUS = 0                                          211966 CPK025
     C                   EVAL      CDFCUS = *blanks                                           CPK025
     C                   ENDIF
     C     DDFTYP        IFNE      *BLANKS
     C                   MOVEL     DDFTYP        CDFTYP
     C                   ELSE                                                   211966
     C                   EVAL      CDFTYP = 0                                   211966
     C                   ENDIF
     C     DDFSEQ        IFNE      *BLANKS
     C                   MOVEL     DDFSEQ        CDFSEQ
     C                   ELSE                                                   211966
     C                   EVAL      CDFSEQ = 0                                   211966
     C                   ENDIF
     C     DDLNLM        IFNE      *BLANKS
     C                   MOVEL     DDLNLM        CDLNLM
     C                   ELSE                                                   211966
     C**********         EVAL      CDLNLM = 0                                          211966 CLE148
     C                   EVAL      CDLNLM = *BLANKS                                           CLE148
     C                   ENDIF
      *
     C                   MOVEL     DDACNT        ACKEY
      *
     C     @RETNO        IFEQ      'Y'
     C*****WLAST8        ANDEQ     *BLANKS                                                    CGL029
     C     WLAST14       ANDEQ     *BLANKS                                                    CGL029
     C                   MOVE      WRETL         CDSACN
     C                   ELSE
     C                   MOVE      WBRCA         CDSBRC
     C                   MOVE      WCNUM         CDSCNM
     C                   MOVE      WCUCD         CDSCCY
     C                   MOVE      WACCD         CDSACD
     C                   MOVE      WACSQ         CDSSEQ
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     CDCOPT        IFEQ      'A'
     C     CDCOPT        OREQ      'D'
     C     CDCOPT        OREQ      'P'
      *
     C                   MOVEL     DDCTRN        ACKEY
      *
     C     DDCTRN        IFNE      *BLANKS
      *
     C                   SELECT
      *
     C     CDCOPT        WHENEQ    'A'
     C     @RETNO        IFEQ      'Y'
     C*****WLAST9        ANDEQ     *BLANKS                                                    CGL029
     C     WLAST15       ANDEQ     *BLANKS                                                    CGL029
     C                   MOVE      WRETL         CDCACN
     C                   ELSE
     C                   MOVE      WBRCA         CDCBRC
     C                   MOVE      WCNUM         CDCCNM
     C                   MOVE      WCUCD         CDCCCY
     C                   MOVE      WACCD         CDCACD
     C                   MOVE      WACSQ         CDCSEQ
     C                   ENDIF
      *
     C     CDCOPT        WHENEQ    'D'
     C                   MOVEL     DDCTRN        CDDEAL
      *
     C     CDCOPT        WHENEQ    'P'
     C                   MOVE      WCSBA         CDCSBR
     C                   MOVE      WCSSC         CDCSEC
     C**********         Z-ADD     WCSCN#        CDCSCN                                       CSD027
     C                   EVAL      CDCSCN = WCSCN#                                            CSD027
      *
     C                   ENDSL
      *
     C                   ELSE
     C                   MOVEL     *BLANKS       CDCBRC
     C**********         Z-ADD     0             CDCCNM                                       CSD027
     C                   EVAL      CDCCNM = *BLANKS                                           CSD027
     C                   MOVEL     *BLANKS       CDCCCY
     C                   Z-ADD     0             CDCACD
     C                   Z-ADD     0             CDCSEQ
     C                   Z-ADD     0             CDCACN
     C                   Z-ADD     0             CDDEAL
     C                   MOVE      *BLANKS       CDCSBR
     C                   MOVE      *BLANKS       CDCSEC
     C**********         Z-ADD     0             CDCSCN                                       CSD027
     C                   EVAL      CDCSCN = *BLANKS                                           CSD027
     C                   ENDIF
      *
     C                   MOVEL     DDINEX        CDINEX
      *
     C                   ENDIF
      *
     C                   MOVEL     DDIRF1        CDIRF1
     C                   MOVEL     DDIRF2        CDIRF2
     C                   MOVEL     DDIRF3        CDIRF3
     C                   MOVEL     DDIRF4        CDIRF4
     C                   MOVEL     DDIRF5        CDIRF5
     C                   MOVEL     DDIRF6        CDIRF6
     C                   MOVEL     DDDORF        CDDORF
      *
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
     C     *ENTRY        PLIST
      *
      ** Transaction Screen Format
     C                   PARM                    NwCoScnFmt
      *
      ** Transaction Status
     C                   PARM                    TransStat         7
      *
      ** Mode of Operation
     C                   PARM                    RespMode          1
      *
      ** New Collateral Record
     C                   PARM                    NwCoFilFmt
      *
      ** Fields OK indicators
     C                   PARM                    OKCoScnFld
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    Ix
      *
      ** Warning fields/message Ids/message data (arrays) from/to
      ** caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    WIx
     C                   PARM                    CGL072            1                         CGL072
      *
      ** Key list for FCLTY
     C     KFCLTY        KLIST
     C**********         KFLD                    KFCUS             6 0                        CSD027
     C                   KFLD                    KFCUS             6                          CSD027
     C                   KFLD                    KFTYP             3 0
     C                   KFLD                    KFSEQ             2 0
     C                   KFLD                    KRCDT             1
      *
      ** Key list for CLOAN
     C     KCLOAN        KLIST
     C**********         KFLD                    KLNRF             6 0                        CLE148
     C                   KFLD                    KLNRF             6                          CLE148
     C                   KFLD                    KRCDT
      *
      ** Key list for CPOSN
     C     KCPOSN        KLIST
     C                   KFLD                    WCSBA
     C                   KFLD                    WCSSC
     C                   KFLD                    WCSCN#
      *
      ** Move program name into *LDA field.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'GLCOLL2VAL ' DBPGM
     C                   OUT       LDA
      *
      ** Access Bank details.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     POPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   Z-ADD     001           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access Midas Modules details.                                                        208640
      *                                                                                       208640
     C                   CALLB     'AOMMODR0'                                                 208640
     C                   PARM      *BLANKS       PRTCD                                        208640
     C                   PARM      '*FIRST '     POPTN                                        208640
     C     SDMMOD        PARM      SDMMOD        DSFDY                                        208640
      *                                                                                       208640
      ** Database error                                                                       208640
      *                                                                                       208640
     C     PRTCD         IFNE      *BLANKS                                                    208640
     C                   MOVEL     POPTN         DBKEY                                        208640
     C                   MOVEL     'SDMMODPD'    DBFILE                                       208640
     C                   Z-ADD     003           DBASE                                        208640
     C                   EXSR      *PSSR                                                      208640
     C                   ENDIF                                                                208640
      *                                                                                       208640
      ** Access Retail details.
      *
     C     BGRTBN        IFEQ      'Y'                                                        208640
     C                   MOVE      'N'           @RETNO            1
     C                   CALLB     'AORETLR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDRETL        PARM      SDRETL        DSFDY
      *
      ** Database error
      *
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C                   MOVEL     POPTN         DBKEY
     C                   MOVEL     'SDRETLPD'    DBFILE
     C                   Z-ADD     002           DBASE
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVE      BMRANR        @RETNO
     C                   ENDIF
     C                   ENDIF                                                                208640
      *
      ** Access SAR details file to determine if CGL018 is on.                                CGL018
      *                                                                                       CGL018
     C                   CALLB     'AOSARDR0'                                                 CGL018
     C                   PARM      *BLANKS       @RTCD                                        CGL018
     C                   PARM      '*VERIFY'     @OPTN                                        CGL018
     C                   PARM      'CGL018'      @SARD                                        CGL018
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL018
      *                                                                                       CGL018
      ** Database Error                                                                       CGL018
      *                                                                                       CGL018
     C     @RTCD         IFNE      *BLANKS                                                    CGL018
     C     @RTCD         ANDNE     '*NRF   '                                                  CGL018
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CGL018
     C                   Z-ADD     12            DBASE                                        CGL018
     C                   MOVEL     'CGL018'      DBKEY                                        CGL018
     C                   EXSR      *PSSR                                                      CGL018
     C                   END                                                                  CGL018
      *                                                                                       CGL018
     C     @RTCD         IFEQ      *BLANK                                                     CGL018
     C                   MOVE      'Y'           CGL018            1                          CGL018
     C                   ELSE                                                                 CGL018
     C                   MOVE      'N'           CGL018                                       CGL018
     C                   END                                                                  CGL018
 
     C     P_AOSVALR0    PLIST                                                                CLE148
      *                                                                                       CLE148
      ** Return Code (Output)                                                                 CLE148
      *                                                                                       CLE148
     C                   PARM                    PRetCode          7                          CLE148
     C                   PARM                    PSysValK1        20                          CLE148
     C                   PARM                    PSysVal1        200                          CLE148
     C                   PARM                    PSysValK2        20                          CLE148
     C                   PARM                    PSysVal2        200                          CLE148
     C                   PARM                    PSysValK3        20                          CLE148
     C                   PARM                    PSysVal3        200                          CLE148
     C                   PARM                    PSysValK4        20                          CLE148
     C                   PARM                    PSysVal4        200                          CLE148
     C                   PARM                    PSysValK5        20                          CLE148
     C                   PARM                    PSysVal5        200                          CLE148
     C                   PARM                    PSysValK6        20                          CLE148
     C                   PARM                    PSysVal6        200                          CLE148
     C                   PARM                    PSysValK7        20                          CLE148
     C                   PARM                    PSysVal7        200                          CLE148
     C                   PARM                    PSysValK8        20                          CLE148
     C                   PARM                    PSysVal8        200                          CLE148
     C                   PARM                    PSysValK9        20                          CLE148
     C                   PARM                    PSysVal9        200                          CLE148
     C                   PARM                    PSysValK10       20                          CLE148
     C                   PARM                    PSysVal10       200                          CLE148
      *                                                                                       CLE148
      ** Retrieve System Value 'LoanAlphaAllow'                                               CLE148
      *                                                                                       CLE148
     C                   EVAL      PRetCode = *BLANKS                                         CLE148
     C                   EVAL      PSysValK1 = 'LoanAlphaAllow'                               CLE148
     C                   EVAL      PSysVal1 = *BLANKS                                         CLE148
      *                                                                                       CLE148
     C                   CALL (E)  'AOSVALR0'    P_AOSVALR0                                   CLE148
      *                                                                                       CLE148
      ** If Error retrieving the System values                                                CLE148
      *                                                                                       CLE148
     C                   IF        %Error Or PRetCode <> *BLANKS                              CLE148
     C                             OR (*INU7 = *ON And *INU8 = *ON)                           CLE148
     C     *LOCK         IN        LDA                                                        CLE148
     C                   EVAL      DBFILE = 'SDSVALR0'                                        CLE148
     C                   EVAL      DBASE = 1                                                  CLE148
     C                   EVAL      DBKEY = 'LoanAlpha(Allow/Chksum)'                          CLE148
     C                   EVAL      DBPGM = PsProcPgm                                          CLE148
     C                   OUT       LDA                                                        CLE148
     C                   EXSR      *PSSR                                                      CLE148
     C                   ENDIF                                                                CLE148
      *                                                                                       CLE148
     C                   MOVEL     PSysVal1      wLoanAlpha        1                          CLE148
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
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
