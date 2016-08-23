     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Trade retrieve + act/tdrf validation')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SETRADRTV - SECURITIES TRADE RETRIEVE                        *
      *              (WITH ACTION CODE VERSUS TRADE REF VALIDATION    *
      *                                                               *
      *  Function:  This module retrieves a trade from                *
      *             the database. As it does so, it validates the     *
      *             action code and trade reference.                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CSD083             Date 27May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 234300             Date 29Sep06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CGL031             Date 05Jul04               *
      *                 CSE075             Date 17Nov05               *
      *                 BUG8102R           Date 17Aug05               *
      *                 BUG7703            Date 09Sep05               *
      *                 BUG8102            Date 04Aug05               *
      *                 BUG8260            Date 26Aug05               *
      *                 CAS010R            Date 04Jul05               *
      *                 BUG7029            Date 10Jun05               *
      *                 215727             Date 27Aug02               *
      *                 TDA035             Date 02Apr04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084             Date 07Jul03               *
      *                 CAS006             Date 21Jan03               *
      *                 CSD015             Date 14Oct02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 196903             Date 22Aug01               *
      *                 CAP067             Date 24Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSE028             Date 06Jun01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSE023             Date 12Jul00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP051             Date 16Nov99               *
      *                 CPB001             Date 01Jun99               *
      *                 158846             Date 23Aug99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 154562             Date 01Feb99               *
      *                 CAP003  *CREATE    Date 03Jun98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD083 - Watch List Compliance Upgrade                       *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  234300 - Recompiled over changed in PF/HSTTRD.               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL031 - Taxation of Savings Income (Recompile)              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  BUG8102R - Line was missing which sets up PSUser.            *
      *             Fix included by Bug 7703 already, so no codings.  *
      *  BUG7703 - Serious Midas Error occurred during INSERT         *
      *  BUG8102 - Move other processing dependent on ZMUSER.         *
      *  BUG8260 - Serious Midas Error occurred                       *
      *  CAS010R - Duplicate Message ID.                              *
      *  BUG7029 - Ensure ZMUSER is re-checked on every call,         *
      *            move out of *INZSR.                                *
      *  215727 - Do not allow authorisation of incomplete trades.    *
      *           Upgrade fix 114713 to API version.                  *
      *  TDA035 - RTS Signon changes for MidasPlus. (Recompile)       *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - Synchronous calling of APIs                         *
      *           Get user from ZMUSER DTAARA                         *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *  196903 - An incomplete trade cannot be approved or authorised*
      *           Add msg MMA1214 in msgf GBDRSMM                     *
      *  CAP067 - Repurchase Agreements API.                          *
      *  CSE028 - Standing Settlement Instructions Enhancement.       *
      *           (Recompiled).                                       *
      *  CSE023 - Treaty Withholding Tax. (Recompiled)                *
      *  CAP051 - Automatic Authorisation (SE Trades Part)            *
      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
      *           Recompiled due to database changes                  *
      *  158846 - Pgm used incorrectly RECI field frm TRAUTD file     *
      *           when doing validation for action codes 'Y'- Authorise
      *           and 'P'- Approve . It should use TRADSD 's   RECI . *
      *           Rename RECI frm TRAUTD so that itsn't used for trade*
      *           Authorisation/ Approval .                           *
      *  154562 - Only 1 record is needed on TRADSDX1 if CSW003 is off*
      *  CAP003 - Conversion of SE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSETRADL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(TRADSDF:SETRDFOI)
     FTRADHS    IF   E           K DISK                                         E16096
     F                                     RENAME(TRADSDF:TRADSDFX)
     FTRAUT     IF   E           K DISK                                         S01269
     FTRADSDY1  IF   E           K DISK                                         S01401
     FBULKR     IF   E           K DISK                                         S01169
     FMUSER     IF   E           K DISK                                         S01269
 
     FSDCWHTL1  IF   E           K DISK    INFSR(*PSSR)                                       CSD015
      ** Compliance Watch Hit List by Function                                                CSD015
                                                                                              CSD015
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
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
 
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
      ** EXTERNAL DS FOR SECURITIES TRADING DETAILS
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** EXTERNAL DS FOR CURRENCY DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
      *                                                                                       CAP084
      ** DS for ZMUSER details                                                                CAP084
     D ZMUSER          DS            17                                                       CAP084
     D  PUSRID                 1     10                                                       CAP084
     D  PDBRN                 11     13                                                       CAP084
     D  PDPPT                 14     16                                                       CAP084
 
      ** Trade in File Format
     D TradFilFmt    E DS                  EXTNAME(TRADSD)
      ** Trade Extension in File Format (A)
     D TX1FilFmt     E DS                  EXTNAME(TRADSDX1)
      ** Trade Extension in File Format (A)
     D TX1AFilFmt    E DS                  EXTNAME(TRADSDX1)
     D                                     PREFIX(A_)
      ** Trade Extension in File Format (B)
     D TX1BFilFmt    E DS                  EXTNAME(TRADSDX1)
     D                                     PREFIX(B_)
                                                                                              CSD015
      ** Midas Functions for Watch List Checking Details File                                 CSD015
     D SDWLCC        E DS                  EXTNAME(SDWLCCPD)                                  CSD015
                                                                                              CSD015
      ** External DS for SAR Details                                                          CSD015
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSD015
     D                                     PREFIX(S_)                                         CSD015
 
      ** 24X7 status data area                                                                CSD015
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSD015
                                                                                              CSD015
      ** SDSTAT data area                                                                     CSD015
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSD015
                                                                                              CSD015
      ** Declared variables                                                                   CSD015
     D PRtCd           S              7                                                       CSD015
     D POptn           S              7                                                       CSD015
     D PFunc           S              8                                                       CSD015
     D PSard           S              6                                                       CSD015
                                                                                              CSD015
     D CSC011          S              1                                                       CSD015
     D CSD015          S              1                                                       CSD015
     D WFunction       S              8                                                       CSD015
     D WIdentifier     S             40                                                       CSD015
     D WBranch         S              3                                                       CSD015
                                                                                              CSD015
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Ix              S              3P 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
     ITRAUTDF                                                                   158846
     I              RECI                        WURECI                          158846
 
      *****************************************************************
      /EJECT
     C**************************************************************
      *
      * INITIALIZATION
      *
     C                   EXSR      INIT
      *
      * IF THE MODE IS 'FRONT OFFICE TRANSACTION INTERFACE'
      * DO (EXTRA) VALIDATION FOR FRONT OFFICE TRANSACTION INTERFACE
      *
     C     ModeofOp      IFEQ      '*FRONT'
     C                   EXSR      VFRNT
      *
      **  Carry out no further validation if errors have occurred.
      *
     C     OKACTN        IFEQ      'N'
     C     OKTDRF        OREQ      'N'
     C                   RETURN
     C                   END
     C                   END
      *
      * VALIDATE ACTION CODE & TRADE REFERENCE
      *
     C                   EXSR      VAL
      *
      **  Carry out no further validation if errors have occurred.
      *
     C     OKACTN        IFEQ      'N'
     C     OKTDRF        OREQ      'N'
     C                   RETURN
     C                   END
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'I' *
      *  *--------------------------------*
      *  (only if the trade reference is not to be generated.)
      *
     C     DDACTN        IFEQ      'I'
     C     DDTDRF        ANDNE     *BLANKS
     C                   EXSR      VALACI
     C                   END
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'E' *
      *  *--------------------------------*
      *
     C     DDACTN        IFEQ      'E'
     C                   EXSR      VALACE
     C                   END
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'A' *
      *  *--------------------------------*
      *
     C     DDACTN        IFEQ      'A'
     C                   EXSR      VALACA
     C                   END
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'C' *
      *  *--------------------------------*
      *
     C     DDACTN        IFEQ      'C'
     C                   EXSR      VALACC
     C                   END
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'D' *
      *  *--------------------------------*
      *
     C     DDACTN        IFEQ      'D'
     C                   EXSR      VALACD
     C                   END
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'P' *
      *  *--------------------------------*
      *
     C     DDACTN        IFEQ      'P'
     C                   EXSR      VALACP
     C                   END
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'Y' *
      *  *--------------------------------*
      *
     C     DDACTN        IFEQ      'Y'
     C                   EXSR      VALACY
     C                   END
      *
      *  *--------------------------------*
      *  * Validation of Back Valuation   *
      *  *--------------------------------*
      *
     C     DDACTN        IFNE      'I'
     C     DDACTN        ANDNE     'E'
     C                   EXSR      VALBACKV
     C                   END
      *
      **  Carry out no further validation if errors occurred.
      *
     C     OKACTN        IFEQ      'N'
     C     OKTDRF        OREQ      'N'
     C                   RETURN
     C                   END
      *
      *  *-----------------------------------------------*
      *  * Get Trade Extension Details (if present)      *
      *  *-----------------------------------------------*
      *
     C     DDACTN        IFNE      'I'
     C     CSW003        IFEQ      'Y'                                          154562
     C                   MOVEL     'A'           T1WHEN
     C                   ELSE                                                   154562
     C                   MOVEL     ' '           T1WHEN                         154562
     C                   END                                                    154562
     C     TRADSY1K      CHAIN     TRADSDY1                           99                       S0140
     C  N99              MOVEL     TX1FilFmt     TX1AFilFmt
     C                   MOVEL     'B'           T1WHEN
     C     TRADSY1K      CHAIN     TRADSDY1                           99                       S0140
     C  N99              MOVEL     TX1FilFmt     TX1BFilFmt
     C                   END
      *
      *  *-----------------------------------------------*
      *  * Access Security Checking                      *
      *  *-----------------------------------------------*
      *
     C     RespMode      IFEQ      'S'
      *
      ** If single branching
      ** ACCESS SECURITY CHECKING - SINGLE BRANCHING
      *
     C     BJSBRC        IFNE      *BLANK
     C                   EXSR      ACSSES
     C                   END
      *
      ** If multibranching
      ** ACCESS SECURITY CHECKING - MULTI-BRANCHING
      *
     C     BJSBRC        IFEQ      *BLANK
     C     DDACTN        ANDNE     'I'
     C                   EXSR      ACSSEM
     C                   END
     C                   END
                                                                                CAP051
      * IF THE MODE IS 'FRONT OFFICE TRANSACTION INTERFACE'                     CAP051
      * DO AUTHORISATION ARE REQUIRED                                           CAP051
     C     ModeofOp      IFEQ      '      '                                     CAP051
     C                   MOVE      *BLANKS       AUTH                           CAP051
     C                   ENDIF                                                  CAP051
      *
      * Return
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * VFRNT - VALIDATION FOR FRONT OFFICE TRANSACTION INTERFACE
      *****************************************************************
     C     VFRNT         BEGSR
      *
      * ERROR IF ACTION CODE IS NOT 'I','A','C','D','P' OR 'Y'
      *
     C     DDACTN        IFNE      'I'
     C     DDACTN        ANDNE     'A'
     C     DDACTN        ANDNE     'C'
     C     DDACTN        ANDNE     'D'
     C     DDACTN        ANDNE     'P'
     C     DDACTN        ANDNE     'Y'
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0200'     MsgIdArr(Ix)
     C                   END
      *
      * ERROR IF FRONT OFFICE TRANSACTION ID IS BLANK
      *
     C     FOTRID        IFEQ      *BLANK
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0201'     MsgIdArr(Ix)
     C                   GOTO      EVFRNT
     C                   END
      *
      * ACCESS TRADE WITH FRONT OFFICE TRANSACTION ID
      *
     C     FOTRID        CHAIN     SETRDFOI                           99
      *
      * IF INSERT
      *
     C     DDACTN        IFEQ      'I'
      *
      * FRONT OFFICE TRANSACTION ID CAN'T BE PRESENT ALREADY
      *
     C     *IN99         IFEQ      '0'
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0202'     MsgIdArr(Ix)
     C                   MOVEL     FOTRID        MsgDtaArr(Ix)
     C                   GOTO      EVFRNT
     C                   END
      *
     C                   ELSE
      *
      * IF NOT INSERT, FRONT OFFICE TRANSACTION ID MUST BE PRESENT
      *
     C     *IN99         IFEQ      '1'
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0203'     MsgIdArr(Ix)
     C                   MOVEL     FOTRID        MsgDtaArr(Ix)
     C                   GOTO      EVFRNT
     C                   END
      *
      * IF NOT INSERT, UPDATE MIDAS TRADE REFERENCE
      *
     C                   MOVEL     TDRF          DDTDRF
 
     C                   END
      *
     C     EVFRNT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL - VALIDATION OF ACTION CODE AND TRADE REFERENCE
      *****************************************************************
     C     VAL           BEGSR
      *
      * Action Code
      *
      *  .. must be 'I','A','C','D','E','P' or 'Y'
      *
     C     DDACTN        IFNE      'I'
     C     DDACTN        ANDNE     'A'
     C     DDACTN        ANDNE     'C'
     C     DDACTN        ANDNE     'D'
     C     DDACTN        ANDNE     'E'
     C     DDACTN        ANDNE     'P'
     C     DDACTN        ANDNE     'Y'
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'MMA0079'     MsgIdArr(Ix)
     C                   END
      *
      *  If 'Y', trade authorisation must be selected in ICD
      *
     C     DDACTN        IFEQ      'Y'
     C     BVAUTH        ANDEQ     '00'
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'MMA0082'     MsgIdArr(Ix)
     C                   END
      *
      *  If 'Y', trade authorisation must not be '15'
      *
     C     DDACTN        IFEQ      'Y'
     C     BVAUTH        ANDEQ     '15'
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'MMA0082'     MsgIdArr(Ix)
     C                   END
      *
      *  If 'P', trade authorisation must be '20'
      *
     C     DDACTN        IFEQ      'P'
     C     BVAUTH        ANDNE     '20'
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'MMA0083'     MsgIdArr(Ix)
     C                   END
      *
      * Trade Reference
      *
      *  If the trade reference is not blank, check that it is numeric.
      *
     C                   TESTN                   DDTDRF               98
     C                   MOVE      DDTDRF        @@TEST            1
     C                   TESTZ                   @@TEST                   99
     C     DDTDRF        IFNE      *BLANKS
     C     *IN98         ANDEQ     '0'
     C     DDTDRF        ORNE      *BLANKS
     C     *IN99         ANDEQ     '0'
     C                   MOVEL     'N'           OKTDRF
     C                   ADD       1             Ix
     C                   MOVEL     'DDTDRF'      FldNameArr(Ix)
     C                   MOVEL     'MMA0087'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   END
      *                                                                                       CAP067
     C     DDTDRF        IFNE      *BLANKS                                                    CAP067
      *                                                                                       CAP067
      ** If transaction comes from buy-sell back API and is the first leg,                    CAP067
      ** store trade reference                                                                CAP067
      *                                                                                       CAP067
     C     PFBYSL        IFEQ      'Y'                                                        CAP067
     C                   MOVE      DDTDRF        PFTDRF                                       CAP067
     C                   ENDIF                                                                CAP067
      *                                                                                       CAP067
      ** If transaction comes from buy-sell back API and is the second leg,                   CAP067
      ** it must be different from its first leg's trade reference, else error                CAP067
      *                                                                                       CAP067
     C     PFBYSL        IFEQ      'N'                                                        CAP067
     C     DDTDRF        IFEQ      PFTDRF                                                     CAP067
     C                   MOVEL     'N'           OKTDRF                                       CAP067
     C                   ADD       1             Ix                                           CAP067
     C                   MOVEL     'DDTDRF'      FldNameArr(Ix)                               CAP067
     C                   MOVEL     'MMA1107'     MsgIdArr(Ix)                                 CAP067
     C                   ENDIF                                                                CAP067
     C                   ENDIF                                                                CAP067
      *                                                                                       CAP067
     C                   ENDIF                                                                CAP067
      *
      *  Check for Trades  existing on the Bulk file
      *
     C     BVBIOP        IFEQ      'Y'
     C                   EXSR      BULKTCHK
     C                   END
      *
     C     EVAL          ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * BULKTCHK - CHECK FOR TRADES ON THE BULK TRADES FILE
      *****************************************************************
     C     BULKTCHK      BEGSR
      *
      *  Trade mustn't exist as an unprocessed bulk trade
      *
     C     DDTDRF        CHAIN     BULKTDF                            44
     C     *IN44         IFEQ      '0'
     C     RECI          IFEQ      ' '
     C     RECI          OREQ      'D'
     C                   MOVEL     'N'           OKTDRF
     C                   ADD       1             Ix
     C                   MOVEL     'DDTDRF'      FldNameArr(Ix)
     C                   MOVEL     'MMA0103'     MsgIdArr(Ix)
     C                   END
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACI - VALIDATION OF ACTION CODE 'I'
      *****************************************************************
     C     VALACI        BEGSR
      *
      * Access trade from the trades file
      *
     C     DDTDRF        CHAIN     TRADSDFX                           44
      *
      * Error if present already
      *
     C     *IN44         IFEQ      '0'
     C                   MOVEL     'N'           OKTDRF
     C                   ADD       1             Ix
     C                   MOVEL     'DDTDRF'      FldNameArr(Ix)
     C                   MOVEL     'MMA0088'     MsgIdArr(Ix)
     C                   END
      *
      * Must not reference an historic trade in HSTTRD
      *
     C     *IN44         IFEQ      '1'
     C     DDTDRF        CHAIN     HSTTRDF                            45
     C     *IN45         IFEQ      '0'
     C                   MOVEL     'N'           OKTDRF
     C                   ADD       1             Ix
     C                   MOVEL     'DDTDRF'      FldNameArr(Ix)
     C                   MOVEL     'MMA0088'     MsgIdArr(Ix)
     C                   END
     C                   END
      *
     C     EVALAI        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACE - VALIDATION OF ACTION CODE 'E'
      *****************************************************************
     C     VALACE        BEGSR
      *
      * Access trade from the trades file
      * (First look for it on the historic trades file)
      *
     C     DDTDRF        CHAIN     HSTTRDF                            44
     C     *IN44         IFEQ      '1'
     C     DDTDRF        CHAIN     TRADSDFX                           44
     C                   END
      *
      * Must reference a record on TRADS
      *
     C     *IN44         IFEQ      '1'                                                      *
     C                   MOVEL     'N'           OKTDRF
     C                   ADD       1             Ix
     C                   MOVEL     'DDTDRF'      FldNameArr(Ix)
     C                   MOVEL     'MMA0090'     MsgIdArr(Ix)
     C                   END
      *
     C     EVALAE        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACA - VALIDATION OF ACTION CODE 'A'
      *****************************************************************
     C     VALACA        BEGSR
      *
      * Access trade from the trades file
      *
     C     DDTDRF        CHAIN     TRADSDFX                           44
      *
      * Must reference an active trade
      *
     C     *IN44         IFEQ      '0'
     C     RECI          ANDNE     'A'
     C     RECI          ANDNE     'D'
     C     RECI          ANDNE     'L'
     C     RECI          ANDNE     'P'
     C     *IN44         OREQ      '1'
     C                   MOVEL     'N'           OKTDRF
     C                   ADD       1             Ix
     C                   MOVEL     'DDTDRF'      FldNameArr(Ix)
     C                   MOVEL     'MMA0089'     MsgIdArr(Ix)
     C                   END
      *
      * Do not allow action 'A' if settlements have been entered;
      * system only backs out prior settlements for action code 'C'.
      *
     C     OKTDRF        IFNE      'N'
     C                   Z-ADD     0             W_SETT           15 0
     C     TNSN          ADD       TNSP          W_SETT
     C     TVSN          ADD       TVSP          W_SETT
     C     TOSN          IFNE      NOML
     C     W_SETT        ORNE      0
     C                   MOVEL     'N'           OKTDRF
     C                   ADD       1             Ix
     C                   MOVEL     'DDTDRF'      FldNameArr(Ix)
     C                   MOVEL     'MMA0080'     MsgIdArr(Ix)
     C                   END
     C                   END
 
     C     EVALAA        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACC - VALIDATION OF ACTION CODE 'C'
      *****************************************************************
     C     VALACC        BEGSR
      *
      * Access trade from the trades file
      *
     C     DDTDRF        CHAIN     TRADSDFX                           44
      *
      * Must reference an active or fully settled trade
      *
     C     *IN44         IFEQ      '0'
     C     RECI          ANDNE     'A'
     C     RECI          ANDNE     'D'
     C     RECI          ANDNE     'S'
     C     RECI          ANDNE     'L'
     C     RECI          ANDNE     'P'
     C     *IN44         OREQ      '1'
     C                   MOVEL     'N'           OKTDRF
     C                   ADD       1             Ix
     C                   MOVEL     'DDTDRF'      FldNameArr(Ix)
     C                   MOVEL     'MMA0089'     MsgIdArr(Ix)
     C                   END
 
     C     EVALAC        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACD - VALIDATION OF ACTION CODE 'D'
      *****************************************************************
     C     VALACD        BEGSR
      *
      * Access trade from the trades file
      *
     C     DDTDRF        CHAIN     TRADSDFX                           44
      *
      * Must reference an active or fully settled trade
      *
     C     *IN44         IFEQ      '0'
     C     RECI          ANDNE     'A'
     C     RECI          ANDNE     'D'
     C     RECI          ANDNE     'S'
     C     RECI          ANDNE     'L'
     C     RECI          ANDNE     'P'
     C     *IN44         OREQ      '1'
     C                   MOVEL     'N'           OKTDRF
     C                   ADD       1             Ix
     C                   MOVEL     'DDTDRF'      FldNameArr(Ix)
     C                   MOVEL     'MMA0089'     MsgIdArr(Ix)
     C                   END
 
     C     EVALAD        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACP - VALIDATION OF ACTION CODE 'P'
      *****************************************************************
     C     VALACP        BEGSR
      *
      * Access trade from the trades file
      *
     C     DDTDRF        CHAIN     TRADSDFX                           44
      *                                                                         196903
      *  Trade must be complete                                                 196903
      *                                                                         196903
     C     TINC          IFEQ      'I'                                          196903
     C                   MOVEL     'N'           OKACTN                         196903
     C                   ADD       1             Ix                             196903
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)                 196903
     C                   MOVEL     'MMA1214'     MsgIdArr(Ix)                   196903
     C                   END                                                    196903
      *
      *  Trade must be awaiting approval
      *
     C     RECI          IFNE      'L'
     C     *IN44         OREQ      '1'
     C                   MOVEL     'N'           OKTDRF
     C                   ADD       1             Ix
     C                   MOVEL     'DDTDRF'      FldNameArr(Ix)
     C                   MOVEL     'MMA0092'     MsgIdArr(Ix)
     C                   ELSE
      *
      *  Trade must not already be approved
      *
     C     TDRF          SETGT     TRAUTDF
     C                   READP     TRAUTDF                                44
      *
     C     *IN44         IFEQ      '1'
     C     TRDRF         ORNE      TDRF
      *
     C                   MOVEL     'N'           OKTDRF
     C                   ADD       1             Ix
     C                   MOVEL     'DDTDRF'      FldNameArr(Ix)
     C                   MOVEL     'MMA0093'     MsgIdArr(Ix)
      *
     C                   ELSE
     C     TATYP         IFEQ      'AP'
     C                   MOVEL     'N'           OKTDRF
     C                   ADD       1             Ix
     C                   MOVEL     'DDTDRF'      FldNameArr(Ix)
     C                   MOVEL     'MMA0093'     MsgIdArr(Ix)
     C                   ELSE
      *
      * Current user must be different from entering/amending user
      *
     C     TDRF          SETGT     TRAUTDF
     C     *IN44         DOUEQ     '1'
     C     TRDRF         ORNE      TDRF
     C     PSUser        OREQ      TAUSR
     C                   READP     TRAUTDF                                44
     C                   END
     C                   SETOFF                                       44
     C     PSUser        IFEQ      TAUSR
     C     TRDRF         ANDEQ     TDRF
     C                   MOVEL     'N'           OKTDRF
     C                   ADD       1             Ix
     C                   MOVEL     'DDTDRF'      FldNameArr(Ix)
     C                   MOVEL     'MMA0096'     MsgIdArr(Ix)
     C                   END
     C                   END
     C                   END
     C                   END
 
      * Exit if trade not valid
 
     C     OKTDRF        CABEQ     'N'           EVALAP
      *
      * Convert countervalue to base currency
      *
     C     TNMC          IFNE      BJCYCD
     C                   EXSR      CONVCVAL
     C                   Z-ADD     ZAMTCO        W_LIMIT          15 0
     C                   ELSE
     C                   Z-ADD     TCTR          W_LIMIT
     C                   END
      *
      * must not exceed authorisation threshold on MUSER
      *
     C     W_LIMIT       IFGT      AUT1
     C                   MOVEL     'N'           OKTDRF
     C                   ADD       1             Ix
     C                   MOVEL     'DDTDRF'      FldNameArr(Ix)
     C                   MOVEL     'MMA0097'     MsgIdArr(Ix)
     C                   END
 
      ** Do not allow authorisation on an incomplete trade                                    215727
      *                                                                                       215727
     C     TINC          IFEQ      'I'                                                        215727
     C                   MOVEL     'N'           OKTDRF                                       215727
     C                   ADD       1             Ix                                           215727
     C                   MOVEL     'DDTDRF'      FldNameArr(Ix)                               215727
     C**********         MOVEL     'MMA1315'     MsgIdArr(Ix)                         215727 CAS010R
     C                   MOVEL     'MMA1316'     MsgIdArr(Ix)                                CAS010R
     C                   ENDIF                                                                215727
      *                                                                                       215727
     C     EVALAP        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACY - VALIDATION OF ACTION CODE 'Y'
      *****************************************************************
     C     VALACY        BEGSR
      *
      * Access trade from the trades file
      *
     C     DDTDRF        CHAIN     TRADSDFX                           44
      *                                                                         196903
      *  Trade must be complete                                                 196903
      *                                                                         196903
     C     TINC          IFEQ      'I'                                          196903
     C                   MOVEL     'N'           OKACTN                         196903
     C                   ADD       1             Ix                             196903
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)                 196903
     C                   MOVEL     'MMA1214'     MsgIdArr(Ix)                   196903
     C                   END                                                    196903
      *
      *  Trade must be awaiting authorization
      *
     C     RECI          IFNE      'L'
     C     RECI          ANDNE     'P'
     C     RECI          ANDNE     'R'
     C     *IN44         OREQ      '1'
      *
     C                   MOVEL     'N'           OKTDRF
     C                   ADD       1             Ix
     C                   MOVEL     'DDTDRF'      FldNameArr(Ix)
     C                   MOVEL     'MMA0094'     MsgIdArr(Ix)
      *
     C                   ELSE
      *
      *  Trade must be approved if approval is needed
      *
     C     RECI          IFEQ      'L'
     C     BVAUTH        IFEQ      '20'
     C     BVAUTH        OREQ      '25'
     C     TDRF          SETGT     TRAUTDF
     C                   READP     TRAUTDF                                44
     C     *IN44         IFEQ      '1'
     C     TRDRF         ORNE      TDRF
     C*
     C                   MOVEL     'N'           OKTDRF
     C                   ADD       1             Ix
     C                   MOVEL     'DDTDRF'      FldNameArr(Ix)
     C                   MOVEL     'MMA0095'     MsgIdArr(Ix)
     C*
     C                   ELSE
     C     TATYP         IFNE      'AP'
     C                   MOVEL     'N'           OKTDRF
     C                   ADD       1             Ix
     C                   MOVEL     'DDTDRF'      FldNameArr(Ix)
     C                   MOVEL     'MMA0095'     MsgIdArr(Ix)
     C                   END
     C                   END
     C                   END
      *
      * current user must be different from entering/amending user
      *
     C     TDRF          SETGT     TRAUTDF
     C     *IN44         DOUEQ     '1'
     C     TRDRF         ORNE      TDRF
     C     PSUser        OREQ      TAUSR
     C                   READP     TRAUTDF                                44
     C                   END
     C                   SETOFF                                       44
     C     PSUser        IFEQ      TAUSR
     C     TRDRF         ANDEQ     TDRF
     C                   MOVEL     'N'           OKTDRF
     C                   ADD       1             Ix
     C                   MOVEL     'DDTDRF'      FldNameArr(Ix)
     C                   MOVEL     'MMA0096'     MsgIdArr(Ix)
     C                   END
     C                   END
      *
      * If authorising a cancellation user must be different from
      *   cancelling user
      *
     C     RECI          IFEQ      'R'
     C*
     C     TDRF          SETGT     TRAUTDF
     C                   READP     TRAUTDF                                44
     C     *IN44         IFEQ      '1'
     C     TRDRF         ORNE      TDRF
     C     TATYP         ORNE      'DL'
     C*
     C                   MOVEL     'N'           OKTDRF
     C                   ADD       1             Ix
     C                   MOVEL     'DDTDRF'      FldNameArr(Ix)
     C                   MOVEL     'MMA0096'     MsgIdArr(Ix)
     C*
     C                   ELSE
     C     PSUser        IFEQ      TAUSR
     C                   MOVEL     'N'           OKTDRF
     C                   ADD       1             Ix
     C                   MOVEL     'DDTDRF'      FldNameArr(Ix)
     C                   MOVEL     'MMA0096'     MsgIdArr(Ix)
     C                   END
     C                   END
     C*
     C                   END
      *
      * If authorising a change user must be different from each user
      *   since last authorisation
      *
     C     RECI          IFEQ      'P'
     C*
     C     TDRF          SETGT     TRAUTDF
     C     *IN44         DOUEQ     '1'
     C     TRDRF         ORNE      TDRF
     C     PSUser        OREQ      TAUSR
     C     TATYP         OREQ      'AU'
     C     TATYP         OREQ      'RV'
     C                   READP     TRAUTDF                                44
     C                   END
     C                   SETOFF                                       44
     C*
     C     PSUser        IFEQ      TAUSR
     C     TATYP         ANDNE     'AU'
     C     TATYP         ANDNE     'RV'
     C     TRDRF         ANDEQ     TDRF
     C                   MOVEL     'N'           OKTDRF
     C                   ADD       1             Ix
     C                   MOVEL     'DDTDRF'      FldNameArr(Ix)
     C                   MOVEL     'MMA0096'     MsgIdArr(Ix)
     C                   END
     C                   END
     C*
     C                   END
 
      * Exit if trade not valid
 
     C     OKTDRF        CABEQ     'N'           EVALAY
      *
      * Convert countervalue to base currency
      *
     C     TNMC          IFNE      BJCYCD
     C                   EXSR      CONVCVAL
     C                   Z-ADD     ZAMTCO        W_LIMIT          15 0
     C                   ELSE
     C                   Z-ADD     TCTR          W_LIMIT
     C                   END
      *
      * must not exceed authorisation threshold on MUSER
      *
     C     W_LIMIT       IFGT      AUT2
     C                   MOVEL     'N'           OKTDRF
     C                   ADD       1             Ix
     C                   MOVEL     'DDTDRF'      FldNameArr(Ix)
     C                   MOVEL     'MMA0098'     MsgIdArr(Ix)
     C                   END
                                                                                              CSD015
      ** Check transaction for Compliance watch                                               CSD015
                                                                                              CSD015
     C                   IF        CSD015 = 'Y' and W1EWLC = 'Y'                              CSD015
                                                                                              CSD015
     C                   IF        CSC011 = 'N' or                                            CSD015
     C                             CSC011 = 'Y' and S1MAIN = LIBR                             CSD015
                                                                                              CSD015
     C                   EVAL      WFunction = 'TRADSD  '                                     CSD015
     C                   EVAL      WIdentifier = TDRF                                         CSD015
     C                   EVAL      WBranch = TDBA                                             CSD015
                                                                                              CSD015
     C     KTradChk      CHAIN     SDCWHTL1                                                   CSD015
                                                                                              CSD015
      ** If record found and trade under investigation, display error message                 CSD015
      ** 'Details still being reviewed by the Compliance Officer'.                            CSD015
                                                                                              CSD015
     C                   IF        %FOUND(SDCWHTL1) and W3TREL <> 'Y'                         CSD015
     C                   EVAL      OKTDRF = 'N'                                               CSD015
     C                   EVAL      Ix = Ix + 1                                                CSD015
     C                   EVAL      FldNameArr(Ix) = 'DDTDRF'                                  CSD015
     C                   EVAL      MsgIdArr(Ix) = 'MMM0797'                                   CSD015
     C                   GOTO      EVALAY                                                     CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
 
      ** Do not allow authorisation on an incomplete trade                                    215727
      *                                                                                       215727
     C     TINC          IFEQ      'I'                                                        215727
     C                   MOVEL     'N'           OKTDRF                                       215727
     C                   ADD       1             Ix                                           215727
     C                   MOVEL     'DDTDRF'      FldNameArr(Ix)                               215727
     C**********         MOVEL     'MMA1315'     MsgIdArr(Ix)                         215727 CAS010R
     C                   MOVEL     'MMA1316'     MsgIdArr(Ix)                                CAS010R
     C                   ENDIF                                                                215727
      *                                                                                       215727
     C     EVALAY        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALBACKV - VALIDATION OF BACK-VALUATION
      *****************************************************************
     C     VALBACKV      BEGSR
      *
      *  No action on any trade with a trade date before the
      *  backvalue period can be allowed
      *  (the positions will be corrupted otherwise)
      *
     C     TDDT          IFLT      W_BKVP
     C                   MOVEL     'N'           OKTDRF
     C                   ADD       1             Ix
     C                   MOVEL     'DDTDRF'      FldNameArr(Ix)
     C                   MOVEL     'MMA0091'     MsgIdArr(Ix)
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ACSSES - ACCESS SECURITY CHECKING - SINGLE BRANCHING
      *****************************************************************
     C     ACSSES        BEGSR
      *
      **  Check user's authority for the action.
      *
     C                   CALL      'ZVACTU'
     C                   PARM      DDACTN        ZACTN             1
     C                   PARM                    ERR               1 0
      *
      **  If action invalid for user
      *
     C     ERR           IFEQ      1
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'MMA0084'     MsgIdArr(Ix)
     C                   END
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * ACSSEM - ACCESS SECURITY CHECKING - MULTI-BRANCHING
      *****************************************************************
     C     ACSSEM        BEGSR
      *
      **  Check user's authority for the action & Booking Branch.
      *
     C                   CALL      'ZVACTBU'
     C                   PARM      DDACTN        ZACTN             1
     C                   PARM      TDBA          ZBR               3
     C                   PARM                    ERR               1 0
      *
      **   If action invalid for user
      *
     C     ERR           IFEQ      1
     C                   MOVEL     'N'           OKACTN
     C                   MOVEL     'N'           OKTDRF
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'MMA0085'     MsgIdArr(Ix)
     C                   ELSE
     C     ERR           IFEQ      2
     C                   MOVEL     'N'           OKACTN
     C                   MOVEL     'N'           OKTDRF
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'MMA0086'     MsgIdArr(Ix)
     C                   END
     C                   END
      *
      **   If Originating Branch used = 'Y',
      **   &  Originating Branch/User Validation = 'Y'
      **   Check user's authority for the Originating Branch.
      *
     C     BKOBRU        IFEQ      'Y'
     C     BKOBUV        ANDEQ     'Y'
     C                   CALL      'ZVOBU'
     C                   PARM      ORBR          ZOBRX             3
     C                   PARM                    ERR               1 0
      *
      **   If action invalid for user
      *
     C     ERR           IFEQ      1
     C                   MOVEL     'N'           OKACTN
     C                   MOVEL     'N'           OKTDRF
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'MMA0101'     MsgIdArr(Ix)
     C                   ELSE
     C     ERR           IFEQ      2
     C                   MOVEL     'N'           OKACTN
     C                   MOVEL     'N'           OKTDRF
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'MMA0102'     MsgIdArr(Ix)
     C                   END
     C                   END
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
     C*****************************************************************
     C* CONVCVAL - CONVERT COUNTERVALUE
     C*****************************************************************
     C     CONVCVAL      BEGSR
      *
      * ACCESS NOMINAL CURRENCY DETAILS
      *
     C                   CALL      'AOCURRR0'                                                  S0111
     C                   PARM      *BLANKS       @RTCD             7                           S0111
     C                   PARM      '*KEY   '     @OPTN             7                           S0111
     C                   PARM      TNMC          @AJCD             3                           S0111
     C     SDCURR        PARM      SDCURR        DSSDY                                         S0111
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDCURRPD'    DBFILE                         ************
     C**********         MOVEL     '800'         DBASE                          * DBERR 902* BUG8102
     C                   MOVEL     '800'         DBASE                          * DBERR 800* BUG8102
     C                   MOVEL     @AJCD         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
 
      * Convert countervalue in nominal currency to base currency
 
     C                   CALLB     'ZCONV'
     C                   PARM      TCTR          ZAMTCI           15 0
     C                   PARM      TBCR          ZEXCH            13 8
     C                   PARM      A6MDIN        ZMD               1
     C                   PARM      TNMC          ZCCYI             3
     C                   PARM      BJCYCD        ZCCYO             3
     C                   PARM      A6NBDP        ZCDPI             1 0
     C                   PARM      BasCcyDec     ZCDPO             1 0
     C                   PARM      *ZERO         ZAMTCO           15 0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
     C*****************************************************************
     C* INIT - INITIALIZATION
     C*****************************************************************
     C     INIT          BEGSR
      *                                                                                      BUG7029
      ** Retrieve ZMUSER details.                                                            BUG7029
      *                                                                                      BUG7029
     C     *DTAARA       DEFINE                  ZMUSER                                      BUG7029
     C                   IN        ZMUSER                                                    BUG7029
                                                                                             BUG8260
      ** Access Midas User Details                                                           BUG8260
                                                                                             BUG8260
     C                   EVAL      PSUser = PUSRID                                           BUG8260
     C     PSUser        CHAIN     MUSER                              99                     BUG8260
                                                                                             BUG8260
      ** Database error                                                                      BUG8260
                                                                                             BUG8260
     C                   IF        *IN99 = *ON                                               BUG8260
     C                             OR RECI <> 'D'                                            BUG8260
     C                   EVAL      DBFILE = 'MUSERDD '                                       BUG8260
     C                   EVAL      DBASE  = 904                                              BUG8260
     C                   EVAL      DBKEY  = PSUser                                           BUG8260
     C                   EXSR      *PSSR                                                     BUG8260
     C                   ENDIF                                                               BUG8260
      *
      * CLEAR OUTPUTS
      *
     C                   CLEAR                   TradFilFmt
     C                   CLEAR                   TX1AFilFmt
     C                   CLEAR                   TX1BFilFmt
     C                   MOVEL     'Y'           OKACTN
     C                   MOVEL     'Y'           OKTDRF
      *
     C                   ENDSR
     C********************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      * Parameters
      *
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      * Return code
     C                   PARM                    RetCodeIn
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM                    ModeofOp          6
      *
      * Response mode
     C                   PARM                    RespMode          1
      *
      * Action Code
     C                   PARM                    DDACTN            1
      *
      * Front Office Transaction ID
     C                   PARM                    FOTRID           20
      *
      * (Midas) Trade Reference
     C                   PARM                    DDTDRF            6
      *                                                                         154562
      * MT5XX - Phase 2 Message Generation is on.                               154562
     C                   PARM                    CSW003            1            154562
      *                                                                                       CAP067
      * Buy-sell back                                                                         CAP067
     C                   PARM                    PFBYSL            1                          CAP067
      *                                                                                       CAP067
      * Trade Reference                                                                       CAP067
     C                   PARM                    PFTDRF            6                          CAP067
      *
      * OUTPUTS
      *
      * (Current) trade in file format
      * (Current) trade extension in file format
     C                   PARM                    TradFilFmt
     C                   PARM                    TX1AFilFmt
     C                   PARM                    TX1BFilFmt
      *
      * OK - Action code
     C                   PARM                    OKACTN            1
      *
      * OK - Deal Number
     C                   PARM                    OKTDRF            1
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Ix
      *
      ** Initialize program name
      *
     C                   MOVEL     'SETRADRTV'   DBPGM
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
     C                   MOVEL     '901'         DBASE                          * DBERR 901*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
      *
      ** ACCESS GENERAL LEDGER DETAILS
      *
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDGELRPD'    DBFILE                         ************
     C                   MOVEL     '902'         DBASE                          * DBERR 902*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
      *
      ** ACCESS SECURITIES TRADING DETAILS
      *
     C                   CALL      'AOSTRDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDSTRD        PARM      SDSTRD        DSSDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDSTRDPD'    DBFILE                         ************
     C**********         MOVEL     '903'         DBASE                          * DBERR 902* BUG8102
     C                   MOVEL     '903'         DBASE                          * DBERR 903* BUG8102
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
      **********                                                                      CAP084 BUG7029
     C******DTAARA       DEFINE                  ZMUSER                               CAP084 BUG7029
     C**********         IN        ZMUSER                                             CAP084 BUG7029
     C**********         EVAL      PSUser = PUSRID                                    CAP084 BUG7029
      **********                                                                      CAP084 BUG7029
      *****************************************************************                      BUG8260
      **ACCESS*MIDAS*USER*DETAILS**************************************                      BUG8260
      *****************************************************************                      BUG8260
     C*****PSUser        CHAIN     MUSER                              99                     BUG8260
      **********                                                                             BUG8260
      **DATABASE*ERROR*************************************************                      BUG8260
      **********                                                                             BUG8260
     C******IN99         IFEQ      '1'                                                       BUG8260
     C*****RECI*         ORNE      'D'                                                       BUG8260
     C**********         MOVEL     'MUSERDD '    DBFILE                         ************ BUG8260
     C**********         MOVEL     '904'         DBASE                          * DBERR 902* BUG8260
     C**********         MOVEL     PSUser        DBKEY                          ************ BUG8260
     C**********         EXSR      *PSSR                                                     BUG8260
     C**********         END                                                                 BUG8260
      *
      * ACCESS BASE CURRENCY DETAILS
      *
     C                   CALL      'AOCURRR0'                                                  S0111
     C                   PARM      *BLANKS       @RTCD             7                           S0111
     C                   PARM      '*KEY   '     @OPTN             7                           S0111
     C                   PARM      BJCYCD        @AJCD             3                           S0111
     C     SDCURR        PARM      SDCURR        DSSDY                                         S0111
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDCURRPD'    DBFILE                         ************
     C**********         MOVEL     '905'         DBASE                          * DBERR 902* BUG8102
     C                   MOVEL     '905'         DBASE                          * DBERR 905* BUG8102
     C                   MOVEL     @AJCD         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
      *
      * BASE CURRENCY DECIMAL PLACES
      *
     C                   Z-ADD     A6NBDP        BasCcyDec         1 0
      *
      * BACKVALUE DATE
      *
     C     BJRDNB        SUB       BVBVP         W_BKVP            5 0
      *
     C     TRADSY1K      KLIST
     C                   KFLD                    TDRF
     C                   KFLD                    T1WHEN
      *
      ** Parameters in chaining SDCWHTPD                                                      CSD015
                                                                                              CSD015
     C     KTradChk      KLIST                                                                CSD015
     C                   KFLD                    WFunction                                    CSD015
     C                   KFLD                    WIdentifier                                  CSD015
     C                   KFLD                    WBranch                                      CSD015
                                                                                              CSD015
      ** Check if 24x7 is installed                                                           CSD015
                                                                                              CSD015
     C                   CALLB     'AOSARDR0'                                                 CSD015
     C                   PARM      *Blank        PRtCd                                        CSD015
     C                   PARM      '*VERIFY'     POptn                                        CSD015
     C                   PARM      'CSC011'      PSard                                        CSD015
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD015
                                                                                              CSD015
      ** Database error                                                                       CSD015
                                                                                              CSD015
     C                   IF        (PRtCd <> *BLANKS) and                                     CSD015
     C                             (PRtCd <> '*NRF   ')                                       CSD015
     C                   EVAL      DBKey = 'CSC011'                                           CSD015
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSD015
     C                   EVAL      DBase = 906                                                CSD015
     C                   EXSR      *PSSR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        PRtCd = *Blank                                             CSD015
     C                   EVAL      CSC011 = 'Y'                                               CSD015
     C                   IN        SC24X7                                                     CSD015
     C                   ELSE                                                                 CSD015
     C                   EVAL      CSC011 = 'N'                                               CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IN        SDSTAT                                                     CSD015
                                                                                              CSD015
      ** Check if Compliance Watch Enhancement (CSD015) is installed                          CSD015
                                                                                              CSD015
     C                   EVAL      CSD015 = 'N'                                               CSD015
                                                                                              CSD015
     C                   CALLB     'AOSARDR0'                                                 CSD015
     C                   PARM      *Blank        PRtCd                                        CSD015
     C                   PARM      '*VERIFY'     POptn                                        CSD015
     C                   PARM      'CSD015'      PSard                                        CSD015
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD015
                                                                                              CSD015
      ** Database error                                                                       CSD015
                                                                                              CSD015
     C                   IF        (PRtCd <> *BLANKS) and                                     CSD015
     C                             (PRtCd <> '*NRF   ')                                       CSD015
     C                   EVAL      DBKey = 'CSD015'                                           CSD015
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSD015
     C                   EVAL      DBase = 907                                                CSD015
     C                   EXSR      *PSSR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        PRtCd = *Blank                                             CSD015
     C                   EVAL      CSD015 = 'Y'                                               CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Check if function code is being monitored by the compliance watch                    CSD015
                                                                                              CSD015
     C                   IF        CSD015 = 'Y'                                               CSD015
     C                   CALLB     'AOWLCCR0'                                                 CSD015
     C                   PARM      *Blank        PRtCd                                        CSD015
     C                   PARM      '*KEY   '     POptn                                        CSD015
     C                   PARM      'SECTTRAD'    PFunc                                        CSD015
     C     SDWLCC        PARM      SDWLCC        DSFDY                                        CSD015
                                                                                              CSD015
      ** Database error                                                                       CSD015
                                                                                              CSD015
     C                   IF        (PRtCd <> *BLANKS) and                                     CSD015
     C                             (PRtCd <> '*NRF   ')                                       CSD015
     C                   EVAL      DBKey = 'SECTTRAD'                                         CSD015
     C                   EVAL      DBFile = 'SDWLCCPD'                                        CSD015
     C                   EVAL      DBase = 908                                                CSD015
     C                   EXSR      *PSSR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Check if Watch List Element (CSD083) is on                                           CSD083
                                                                                              CSD083
     C                   CALLB     'AOSARDR0'                                                 CSD083
     C                   PARM      *BLANKS       PRtCd                                        CSD083
     C                   PARM      '*VERIFY'     POptn                                        CSD083
     C                   PARM      'CSD083'      PSARD                                        CSD083
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD083
                                                                                              CSD083
     C                   IF        PRtCd <> *BLANKS AND                                       CSD083
     C                             PRtCd <> '*NRF'                                            CSD083
     C     *LOCK         IN        LDA                                                        CSD083
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSD083
     C                   EVAL      DBKey = 'CSD083'                                           CSD083
     C                   EVAL      DBase = 909                                                CSD083
     C                   OUT       LDA                                                        CSD083
     C                   EXSR      *PSSR                                                      CSD083
     C                   ENDIF                                                                CSD083
                                                                                              CSD083
     C                   IF        PRtCd = *BLANKS                                            CSD083
     C                   EVAL      CSD015 = 'N'                                               CSD083
     C                   ENDIF                                                                CSD083
                                                                                              CSD083
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
