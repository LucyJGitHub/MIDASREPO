     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Invalid securities prices repair')            *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Module                                    *
      *                                                               *
      *  SEPRCSRPR - INVALID SECURITIES PRICES DETAILS                *
      *              REPAIR FUNCTION                                  *
      *                                                               *
      *  Function:  This function allows invalid Securities Prices    *
      *             details to be 'repaired' and applied to the       *
      *             Midas database.                                   *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CGL031             Date 05Jul04               *
      *                 BUG2812            Date 01Jun04               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSD010             Date 03May02               *
      *                 CSC011             Date 18Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CAP060  *CREATE    Date 03Oct00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL031 - Taxation on Savings Income                          *
      *  BUG2812 - Commitment Control Changes for MidasPlus (CSC022)  *
      *  CAS006 - Hedge Accounting Phase B                            *
      *  CSD010 - Collateralised Lending (Securities and FX Pricing)  *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CAP060 - Conversion of Midas Screen Input Program into full  *
      *           API, including repair program which CAP030 does not *
      *           include                                             *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FZATRNERRL0IF   E           K DISK    INFSR(*PSSR)
 
     FSEIPRCSL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SEIPRCSD0:SEIPRCSX0)
     FSEIPRCSL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
                                                                                              CSC011
      ** API Invalid Log File by Type/FO ID/Timestamp                                         CSC011
     FAPILOGL0  UF   E           K DISK    INFSR(*PSSR) USROPN                                CSC011
     F                                     COMMIT                                             CSC011
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,SEPRCSR001
 
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
 
     D @EI             S              1    DIM(60)
 
      ** Array of Fields in error, temporary store
     D TmpFldNmAr      S             10A   DIM(ArrayMax)
 
      ** Array of error message IDs, temporary store
     D TmpMsgIdAr      S                   DIM(ArrayMax)
     D                                     LIKE(#MsgID)
                                                                                             BUG2812
     D WCmtJobArr      S             10A   DIM(10)                                           BUG2812
      ** Array for commitment job names                                                      BUG2812
 
      * Current Securities Price details in File Format
     D CrDlFilFmt    E DS                  EXTNAME(PRICED)
     D                                     PREFIX(C_)
 
      * Current Securities Price details in Screen Format
     D CurTrScrn     E DS                  EXTNAME(SEPRCSPD)
     D                                     PREFIX(@)
 
      * New Securities Price details in File Format
     D NwDlFilFmt    E DS                  EXTNAME(SEVPRCSPD)
 
      * New Securities Price details in Screen Format
     D NewTrScrn     E DS                  EXTNAME(SEPRCSPD)
 
      * Previous Securities Price details in Screen Format
     D PrvTrScrn     E DS                  EXTNAME(SEPRCSPD)
     D                                     PREFIX(@P)
 
      * Error indicators
     D OKTrPRCS      E DS                  EXTNAME(SEEPRCSPD)
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_LCD       E                     EXTFLD(LCD)
      ** EXTERNAL DS FOR SAR DETAILS
 
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
      ** EXTERNAL DS FOR API ICD
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
     D ExtData       E DS                  EXTNAME(SEPREXPD)
      * SE Transaction Extra Data - File (D/B) format
 
      ** Changed Party Names Array
     D ChgNamArr       S              1    DIM(5)
 
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
     D** Security Trading Detail
 
     D NwExFilFmt    E DS                  EXTNAME(SEVEXVLPD)
      ** New Extel Details in file format
 
     D ValidPRXT     E DS                  EXTNAME(SEVPRXTPD)
                                                                                              CSC011
      ** 24x7 Status Data Area                                                                CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
                                                                                              CSC011
      ** SD Data Area                                                                         CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
 
     D @CCI@M          DS
      ** CURRENT CONTROL INDICATORS FOR MAIN DETAIL SCREEN
     D  @EKYFD                 1      1
     D  @EDTFD                 2      2
     D  @EINKC                 3      3
     D  @EINKG                 4      4
     D  @EINKH                 5      5
     D  @EINKJ                 6      6
     D  @EINKL                 7      7
     D  @EINKP                 8      8
 
     D SCCMTJOB      E DS           256    DTAARA(SCCMTJOB)                                  BUG2812
     D  ComitJob               4    103                                                      BUG2812
      ** Midas SC Jobs handling commitment control data area                                 BUG2812
                                                                                             BUG2812
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      **   Timestamp selected
     D @TMESTPSEL      S             26Z
 
      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')
     D*PCNM*****       S              6S 0                                                    CSD027
     D PCNM            S              6A                                                      CSD027
                                                                                              CGL031
     D PSARd           S              6A                                                      CGL031
     D PRtcd           S              7A                                                      CGL031
     D POptn           S              7A                                                      CGL031
 
      ** -------------------------------------------------------------------
      ** Fields for getting the starting field number from file (parameters
      ** to ZACGTFLDNO, plus the offset to the requested field).
     D FormatA         S             10A   INZ('SEPRCSPD')
 
     D FieldA          S             10A   INZ('DDACTN')
 
     D FldOffsetA      S              5P 0
 
     D FieldNo         S              5P 0
 
      ** End of fields for getting starting field number
 
 
     D* Profit Centre Switchable Feature
     D CAC005          S              1A
 
     D* Market Data Feed
     D CSD006          S              1A
                                                                                              CGL031
      ** Taxation on Savings Income                                                           CGL031
     D CGL031          S              1A                                                      CGL031
 
     D* Clear Screen (Y / N)
     D CLRSCRN         S              1A
 
     D* Display detail part of screen (Y / N)
     D DSPDTL          S              1A
 
     D FCR997          S              4A
     D @CR997          S                   LIKE(FCR997)
      ** -------------------------------------------------------------------
 
     D WKPSSN          S                   LIKE(DDPSSN)
 
      ** Flags to indicate whether substitution is required in
      ** each of the various parts the transaction
     D RepPRCS         S              1A   inz('N')
      ** -------------------------------------------------------------------
                                                                                              CSC011
     D CSC011          S              1A                                                      CSC011
                                                                                              CSC011
     D KMsgType        S              8A                                                      CSC011
     D KFrntOffID      S             20A                                                      CSC011
     D KTimeStamp      S               Z                                                      CSC011
                                                                                              CSC011
     D PRetCode        S              7A                                                      CSC011
     D POption         S              7A                                                      CSC011
     D PKey            S              6A                                                      CSC011
 
     D CSD010          S              1A                                                      CSD010
     D HBDPR           S                   LIKE(PRBDPR)                                       CSD010
     D HOFPR           S                   LIKE(PROFPR)                                       CSD010
     D HCLPR           S                   LIKE(PRCLPR)                                       CSD010
                                                                                              CSD010
      ** Hedge Accounting Phase B Switchable Feature                                          CAS006
     D CAS006          S              1A                                                      CAS006
                                                                                              CAS006
     D CSC022          S              1A                                                     BUG2812
                                                                                             BUG2812
     D WCommitSkip     S              1A                                                     BUG2812
      ** Commitment Skip Field                                                               BUG2812
                                                                                             BUG2812
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,SEPRCSR002
 
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
      *
      /COPY WNCPYSRC,SEPRCSR003
      *
      * Issue rollback to clear any possible updates in window functions
      *
     C     @INKL         IFEQ      '1'
     C                   If        (CSC022 <> 'Y')                                           BUG2812
     C                   ROLBK
     C                   Else                                                                BUG2812
     C                   If        (WCommitSkip <> 'Y')                                      BUG2812
     C                   ROLBK                                                               BUG2812
     C                   Else                                                                BUG2812
     C                   Seton                                        U7U8                   BUG2812
     C                   Endif                                                               BUG2812
     C                   Endif                                                               BUG2812
     C                   END
      *
      /COPY WNCPYSRC,SEPRCSR004
      *
      * DO SCREEN: BROWSE INVALID INPUTS
      *
     C     @SCRN         IFEQ      'I'
     C                   EXSR      SCRN@I
     C                   END
      *
      /COPY WNCPYSRC,SEPRCSR005
      *
      ** Read next browse subfile record
      *
     C     @SCRN         IFEQ      'R'
     C                   EXSR      RDNBRW
     C                   ENDIF
      *
      /COPY WNCPYSRC,SEPRCSR006
      *
      ** DO WHILE screen
      *
     C     @SCRN         DOWEQ     'A'
     C                   EXSR      SCRN@A
     C                   ENDDO
      *
      /COPY WNCPYSRC,SEPRCSR011
      *
      ** Do File updates
      *
     C     @SCRN         IFEQ      'U'
     C                   EXSR      UPDATS
     C                   ENDIF
      *
      /COPY WNCPYSRC,SEPRCSR012
      *
      ** Terminate program
      *
     C     @SCRN         IFEQ      'T'
     C                   MOVE      *ON           *INLR
     C                   ENDIF
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,SEPRCSR013
 
      /EJECT
      *****************************************************************
      * SCRN@I - BROWSE INVALID TRANSACTIONS
      *****************************************************************
     C     SCRN@I        BEGSR
      *
      * RESET READ NEXT BROWSE SUBFILE RECORD
      *
     C                   MOVEL     *BLANK        @RDNB             1
      *
      * BUILD BROWSE SUBFILE
      *
     C                   CALLB     'SEPRCSRPB'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * BUILD SUB-FILE
     C                   PARM      'Y'           @BDSFL            1
      *
      * READ SUBFILE RECORD
     C                   PARM      *BLANK        @RDSFL            1
      *
      * Error in update of previous recd
     C                   PARM                    @ERRUP            1
      *
      * OUTPUT PARAMETERS
      *
      * ERROR MESSAGE
     C                   PARM      *BLANK        @ERRMS            7
      *
      * OPTION SELECTED
     C                   PARM                    @OPSEL            1
      *
      * ACTION SELECTED
     C                   PARM                    @ACSEL            1
      *
      * FO TRANSACTION ID SELECTED
     C                   PARM                    @FOTRANSEL       20
      *
      * Midas Transaction Number
     C                   PARM      *blanks       DDPSSN
      *
      * TIMESTAMP OF TRANSACTION SELECTED
     C                   PARM                    @TMESTPSEL
      *
      * COMMAND KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
                                                                                              CSC011
      ** Switchable feature CSC011                                                            CSC011
                                                                                              CSC011
     C                   PARM                    CSC011                                       CSC011
      *
      * If error set on external switches
      *
     C     @ERRMS        IFNE      *BLANK
     C                   MOVE      '1'           *INU6
     C                   END
      *
      * If CK/3 or CK/12 taken in browse, or error message
      * End program
      *
     C     @INKC         IFEQ      '1'
     C     @INKL         OREQ      '1'
     C     @ERRMS        ORNE      *BLANK
     C                   EXSR      ENDA
     C                   GOTO      ESCRN@I
     C                   END
      *
      * Read next browse subfile record
      *
     C                   MOVE      'Y'           @RDNB
     C                   MOVE      'R'           @SCRN
      *
     C     ESCRN@I       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDNBRW - READ NEXT BROWSE SUBFILE RECORD
      *****************************************************************
     C     RDNBRW        BEGSR
      *
      * READ NEXT SUBFILE RECORD
      *
     C                   CALLB     'SEPRCSRPB'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * BUILD SUB-FILE
     C                   PARM      *BLANK        @BDSFL
      *
      * READ SUBFILE RECORD
     C                   PARM      'Y'           @RDSFL
      *
      * Error in update of previous recd
     C                   PARM                    @ERRUP
      *
      * OUTPUT PARAMETERS
      *
      * ERROR MESSAGE
     C                   PARM      *BLANK        @ERRMS
      *
      * OPTION SELECTED
     C                   PARM      *BLANK        @OPSEL
      *
      * ACTION SELECTED
     C                   PARM      *BLANK        @ACSEL
      *
      * FO TRANSACTION ID SELECTED
     C                   PARM      *BLANK        @FOTRANSEL
      *
      * MIDAS TRANSACTION NUMBER
     C                   PARM      *BLANK        DDPSSN
      *
      * TIMESTAMP OF TRANSACTION SELECTED
     C                   PARM                    @TMESTPSEL
      *
      * COMMAND KEYS
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKL
                                                                                              CSC011
      ** Switchable feature CSC011                                                            CSC011
                                                                                              CSC011
     C                   PARM                    CSC011                                       CSC011
      *
      * If CK/3 taken within invalid transaction deletion function,
      * End program
      *
     C     @INKC         IFEQ      '1'
     C                   EXSR      ENDA
     C                   GOTO      ERDNBRW
     C                   END
      *
      * IF INVALID CUSTOMER READ FROM SUBFILE
      *
     C     @OPSEL        IFNE      *BLANK
      *
      * Clear file formats
     C                   CLEAR                   NwDlFilFmt
      *
      * BLANK THE SCREENS
      *
     C                   Eval      WKPSSN = DDPSSN
     C                   CLEAR                   NewTrScrn
      *
      * RESET ERRORS
      *
     C                   MOVE      *ALL'Y'       OKTrPRCS
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      * Retrieve Transaction details
      *
     C                   Eval      DDPSSN =WKPSSN
     C                   MOVEL     @ACSEL        DDACTN
     C                   MOVEL     @FOTRANSEL    SEFRNT
      *
      * Make sure Invalid transaction's  details are passed to 'Retreive'
      * module for SPF checking .
      *
     C     ZATRNKX0      CHAIN     SEIPRCSX0                          99
      *
      * Set retrieve mode to '*FRONT' (Access using Front Office ID)
      *  if insert
      *  if not insert and Midas transaction ID is not present
      * Otherwise
      *  Set retrieve mode to blank  (Access using Midas transaction ID).
      *
     C     DDACTN        IFEQ      'I'
     C                   MOVEL     '*FRONT'      @@MODE
     C                   ELSE
     C     DDPSSN        IFEQ      *BLANK
     C                   MOVEL     '*FRONT'      @@MODE
     C                   ELSE
     C                   MOVEL     '      '      @@MODE
     C                   ENDIF
     C                   ENDIF
      *
     C                   EXSR      RTVTRN
      *
      * If Securities Prices details were retrieved
      * Convert to screen format.
      *
     C     C_PSSN        IFNE      *BLANK
     C     DDACTN        ANDNE     'I'
     C                   EXSR      CVTTRN
     C                   EXSR      SRMVVL
     C                   ENDIF
      *
      * Now overwite the fields on the main details screen with those
      * on the invalid Transactions file (except for the Midas Transaction
      * reference retrieved above using the front office transaction ID).
      * Access invalid transaction with timestamp and front office transaction ID.
      *
      * Transaction details:
     C                   MOVEL     DDPSSN        ##DDPSSN         10
     C     ZATRNKX0      CHAIN     SEIPRCSX0                          99
      *
      * If Transaction details were retrieved and this is an amendment
      *
     C     C_PSSN        IFNE      *BLANK
     C     DDACTN        ANDEQ     'A'
 
      * Data Substitution - Transaction Details
 
     C     GHSUBS        IFNE      *BLANK
 
     C     GHSUBS        SCAN      NewTrScrn                              99
     C                   IF        *IN99
     C                   EVAL      RepPRCS = 'Y'
     C                   ENDIF
 
      ** If any of the flags set above is true, do the data
      ** substution subroutine.
     C                   IF        RepPRCS = 'Y'
     C                   EXSR      TDtDtaSubs
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      * Send the Transactions error messages to the details screen
      * and GO TO DETAILS SCREEN
      *
     C                   EXSR      SNDM@A
     C                   MOVE      'A'           @SCRN
 
      * ELSE IF NO INVALID Transaction READ FROM SUBFILE
      *
     C                   ELSE
      *
      * GO TO BROWSE SCREEN
      *
     C                   MOVE      'I'           @SCRN
     C                   END
      *
     C     ERDNBRW       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SNDM@A - SEND A MESSAGE TO DETAILS SCREEN
      *****************************************************************
     C     SNDM@A        BEGSR
 
      *
      ** If there are fundamental errors in this transaction
      ** Identify this fact.
      *
     C                   IF        DDACTNOK = 'N' OR
     C                             DDSSNOK  = 'N' OR
     C                             DDPCNMOK = 'N' OR
     C                             DDPMKTOK = 'N' OR
     C                             DDPBRAOK = 'N' OR
     C                             DDPBOKOK = 'N' OR
     C                             DDPRFCOK = 'N' OR
     C                             DDPRTOK  = 'N' OR
     C                             DDPTFROK = 'N'
 
     C                   Z-ADD     1             E                 3 0
     C                   Z-ADD     1             Idx
     C                   MOVE      *ALL'Y'       OKTrPRCS
     C                   MOVE      *ALL'Y'       @EI
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     '*ANY'        FldNameArr(E)
     C                   MOVEL     'APM0110'     MsgIdArr(E)
     C                   ELSE
     C                   Z-ADD     *ZERO         E
     C                   Z-ADD     *ZERO         Idx
     C                   MOVE      *ALL'Y'       OKTrPRCS
     C                   MOVE      *ALL'Y'       @EI
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   ENDIF
      *
      ** Read error messages for Transactions
      *
     C     ZATRNKD0      SETLL     ZATRNERRD0
     C     ZATRNKD0      READE     ZATRNERRD0                             99
      *
      ** Add error message to array passed to detail screen
      ** and set OK flag for field to 'N'
      *
     C     *IN99         DOWEQ     '0'
 
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM      *BLANK        ReturnCode
     C                   PARM                    FormatA
     C                   PARM                    ABFIELDNAM
     C                   PARM      *ZERO         FieldNo
 
     C                   IF        ReturnCode = *blank
     C                   ADD       1             E
     C                   MOVEL     ABFIELDNAM    FldNameArr(E)
     C                   MOVEL     ABMSGID       MsgIdArr(E)
     C                   Z-ADD     ABFIELDID     F                 3 0
     C                   SUB       FldOffsetA    F
     C     F             IFLT      1
     C     F             ORGT      60
     C                   Z-ADD     1             F
     C                   END
     C                   MOVE      'N'           @EI(F)
     C                   ENDIF
 
     C     ZATRNKD0      READE     ZATRNERRD0                             99
     C                   ENDDO
      *
     C                   MOVEA     @EI           OKTrPRCS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@A - PROCESS SCREEN
      *****************************************************************
     C     SCRN@A        BEGSR
      *
      * Enable/disable detail fields on primary details screen
      * if changes to the data are allowed
      * (key fields = action code & Transaction reference; detail fields = rest)
      * (Action code can only be 'I', 'A', 'D', or 'E')
      *
     C     DDACTN        IFEQ      'I'
     C     @OPSEL        ANDEQ     'U'
     C     DDACTN        OREQ      'A'
     C     @OPSEL        ANDEQ     'U'
     C                   MOVEL     'Y'           @EDTFD
     C                   ELSE
     C                   MOVEL     'N'           @EDTFD
     C                   END
      *
      * KJ = COMMAND KEY 10 = CONFIRM DELETE
     C     DDACTN        IFEQ      'D'
     C                   MOVEL     'Y'           @EINKJ
     C                   ELSE
     C                   MOVEL     'N'           @EINKJ
     C                   END
 
      * Update 'previous' screen
     C                   MOVEL     NewTrScrn     PrvTrScrn
      *
      * Set function key status on PRIMARY screen
     C                   EXSR      SFKEYS
      *
      ** WRITE/READ DISPLAY SCREEN
      *
     C                   CALLB     'SEPRCSDSP'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    NewTrScrn
     C                   PARM                    OKTrPRCS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    @EKYFD
     C                   PARM                    @EDTFD
     C                   PARM                    @EINKG
     C                   PARM                    @EINKH
     C                   PARM                    @EINKJ
     C                   PARM                    @EINKP
                                                                                              CAS006
      ** SWITCHABLE FEATURES:                                                                 CAS006
      ** ====================                                                                 CAS006
                                                                                              CAS006
      ** Profit Centre Switchable Feature                                                     CAS006
                                                                                              CAS006
     C                   PARM                    CAC005                                       CAS006
                                                                                              CGL031
      ** Taxation on Savings Income                                                           CGL031
                                                                                              CGL031
     C                   PARM                    CGL031                                       CGL031
      *
      * OUTPUT PARAMETERS
      *
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKG             1
     C                   PARM      '0'           @INKH             1
     C                   PARM      '0'           @INKJ             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKP             1
     C                   PARM                    DDSTS             8
     C                   PARM      'N'           CLRSCRN
     C                   PARM      'Y'           DSPDTL
 
     C                   MOVE      *ALL'Y'       OKTrPRCS
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      * F3 - End Program
     C     @INKC         CASEQ     '1'           ENDA
      *
      * F12 - Cancel on Screen
     C     @INKL         CASEQ     '1'           CANC@A
      *
      * Validate input to screen
     C                   CAS                     VAL@A
     C                   ENDCS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@A  - VALIDATE INPUT TO DETAILS SCREEN
      *****************************************************************
     C     VAL@A         BEGSR
     C                   MOVEL     '      '      @@MODE
      *
      * Retrieve Securities Prices details
      *
     C                   EXSR      RTVTRN
 
     C                   IF        DDACTNOK = 'Y' AND
     C                             DDSSNOK  = 'Y' AND
     C                             DDPCNMOK = 'Y' AND
     C                             DDPMKTOK = 'Y' AND
     C                             DDPBRAOK = 'Y' AND
     C                             DDPBOKOK = 'Y' AND
     C                             DDPRFCOK = 'Y' AND
     C                             DDPRTOK  = 'Y' AND
     C                             DDPTFROK = 'Y'
     C                   IF        DDLPRI  = *BLANKS AND
     C                             DDUPRI  = *BLANKS AND
     C                             DDPCEN  = *BLANKS AND
     C                             DDAPND  = *BLANKS AND
     C                             DDPSRC  = *BLANKS
 
      * Default Extel details
     C                   EXSR      SRDFT
 
     C                   ENDIF
     C                   ENDIF
      *
      *
      * If key fields are not OK
      * Re-output screen with error messages on it
      *
     C                   IF        DDACTNOK = 'N' OR
     C                             DDSSNOK  = 'N' OR
     C                             DDPCNMOK = 'N' OR
     C                             DDPMKTOK = 'N' OR
     C                             DDPBRAOK = 'N' OR
     C                             DDPBOKOK = 'N' OR
     C                             DDPRFCOK = 'N' OR
     C                             DDPRTOK  = 'N' OR
     C                             DDPTFROK = 'N'
     C                   GOTO      EndVAL@A
     C                   ENDIF
     C/COPY WNCPYSRC,SEH00054
      *
      *----------------------------------------------------------------
      * IF DELETE
      *
     C     DDACTN        IFEQ      'D'
      *
      * IF CK/10 TAKEN, GO ONTO UPDATES
      *
     C     @EINKJ        IFEQ      'Y'
     C                   MOVEL     'U'           @SCRN
     C                   END
     C                   GOTO      EndVAL@A
     C                   END
      *
      *----------------------------------------------------------------
      * Prior to validation, initialize error indicators as 'OK'
      * and clear Transaction in File Format
      *
     C                   Z-ADD     *ZERO         Idx               3 0
     C                   Z-ADD     *ZERO         WIdx              3 0
     C                   MOVE      *ALL'Y'       OKTrPRCS
     C                   CLEAR                   NwDlFilFmt
      *
      * Validate Securities Prices details
      *
 
      * Update Deal in File Format
      *
     C                   EXSR      SRMVVL
 
     C                   CALLB     'SEPRCSVAL'
     C                   PARM                    RespMode
     C                   PARM                    NewTrScrn
     C                   PARM                    ExtData
     C                   PARM                    OkTrPRCS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM      *ZERO         Idx               3 0
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM      *ZERO         WIdx              3 0
     C                   PARM                    NwDlFilFmt
     C                   PARM                    NwExFilFmt
     C                   PARM                    ValidPRXT
     C                   PARM                    HPPRC
     C                   PARM                    CAC005
                                                                                              CGL031
      ** Taxation on Savings Income                                                           CGL031
                                                                                              CGL031
     C                   PARM                    CGL031                                       CGL031
      *
      * If errors returned
     C                   IF        IDX <> 0 or  WIDX <> 0
     C                   GOTO      EndVAL@A
     C                   END
      *
      *
      * If the screen has changed in the course of the validation
      * or if there are warnings which have not been displayed
      * re-display the screen
      *
     C     NewTrScrn     IFNE      PrvTrScrn
     C                   GOTO      EndVAL@A
     C                   END
      *
      * Clear any warning messages
      *
     C                   MOVE      *ALL'Y'       OKTrPRCS
     C                   MOVE      'U'           @SCRN
      *
     C     EndVAL@A      ENDSR
     C/COPY WNCPYSRC,SEH00055
      *****************************************************************
      * SRDFT   - DEFAULTING FOR EXTEL DETAILS
      *****************************************************************
     C     SRDFT         BEGSR
 
     C                   CALLB     'SEPRCSDFT'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM                    RetCodeIn
      ** Action Code
     C                   PARM                    DDACTN            1
      ** Security Shortname
     C                   PARM                    DDPSSN           10
      ** Price Type
     C                   PARM                    DDPPRT            2
 
      * Account in file format
     C                   PARM                    CrDlFilFmt
      * ICD
     C                   PARM                    BVEXOP
 
      * OUTPUTS
      * Screen Output
      *
      ** Price Source
     C                   PARM      *BLANKS       DDPSRC            1
      ** Auto-Price Indicator
     C                   PARM      *BLANKS       DDAPND            1
      ** Lower Price Boundary
     C                   PARM      *BLANKS       DDLPRI           16
      ** Upper Price Boundary
     C                   PARM      *BLANKS       DDUPRI           16
      ** Percentage
     C                   PARM      *BLANKS       DDPCEN           10
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    IDX
      ** Security shortname OK flag
     C                   PARM      *BLANK        DDSSNOK
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRMVVL - MOVE DATABASE FIELDS TO VALID FILE
      *****************************************************************
     C     SRMVVL        BEGSR
 
      * Usually, the move of data from the data base file to the valid file
      * can be done in one step:
      **
      ***   e.g.,      MOVEL     CrDlFilFmt    NwDlFilFmt
      **
      * However, if CAC005 is on, two files are updated: SEPRICPD and PRICED.
      * We need to add profit centre and pseudo book to the latter file.
      * We also need these fields to appear on the Valid Errors file, which is compiled
      * with the same format as the Valid file. These fields need to be moved manually.
      *
     C
     C                   MOVE      C_RECI        PRRECI
     C                   MOVEL(P)  C_PSSN        PRPSSN
     C                   MOVEL(P)  C_PPRT        PRPPRT
     C                   Z-ADD     C_PVDT        PRPVDT
     C**********         Z-ADD     PCNM          PRPCNM                                       CSD027
     C                   EVAL      PRPCNM = PCNM                                              CSD027
     C                   MOVEL     C_PMKT        PRPMKT
     C                   MOVEL     C_PBRA        PRPBRA
     C                   MOVEL     PBOK          PRPBOK
     C                   Z-ADD     C_PPRC        PRPPRC
     C                   MOVEL     C_PNTV        PRPNTV
     C                   Z-ADD     C_LCD         PRLCD
     C                   MOVE      C_CHTP        PRCHTP
     C                   Z-ADD     C_TNLU        PRTNLU
     C                   MOVE      C_PSRC        PRPSRC
     C                   MOVE      C_PBWN        PRPBWN
     C                   MOVE      C_PPWN        PRPPWN
     C                   MOVEL     C_PTFR        PRPTFR
     C                   Z-ADD     C_NPXR        PRNPXR
     C                   MOVE      C_NPMD        PRNPMD
     C                   MOVE      C_PRTMST      PRTMESTMP
     C                   Z-ADD     C_PRDFTS      PRDFTS
     C                   MOVEL     C_PRFRNT      PRFRNT
     C                   MOVEL     C_PRAFRT      PRAFRT
     C                   MOVEL     C_PRREPA      PRREPA
     C                   MOVEL     C_PRDTFR      PRDTFR
     C                   MOVEL     C_PRTLEX      PRTLEX
     C                   MOVEL     PRFC          PRPRFC
     C                   MOVEL     PBCD          PRPBCD
                                                                                              CGL031
     C                   IF        CGL031 = 'Y'                                               CGL031
     C                   Z-ADD     C_PEXI        PRPEXI                                       CGL031
     C                   ENDIF                                                                CGL031
                                                                                              CAS006
      ** If Hedge Accounting Phase B is installed and Price Type is                           CAS006
      ** 'V', 'DT' or 'DV', move Credit Risk Spread and Liquidity                             CAS006
      ** Premium fields.                                                                      CAS006
                                                                                              CAS006
     C                   IF        CAS006 = 'Y' AND (DDPPRT = 'V'                             CAS006
     C                             OR DDPPRT = 'DT' OR DDPPRT = 'DV')                         CAS006
     C                   EVAL      PRCRSK = C_PRCRSK                                          CAS006
     C                   EVAL      PRLQPR = C_PRLQPR                                          CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CSD010
     C                   IF        CSD010 = 'Y'                                               CSD010
     C                   Z-ADD     C_PRBDPR      PRBDPR                                       CSD010
     C                   Z-ADD     C_PROFPR      PROFPR                                       CSD010
     C                   Z-ADD     C_PRCLPR      PRCLPR                                       CSD010
     C                   ENDIF                                                                CSD010
     C
     C     ENWDL         ENDSR
      /EJECT
      *****************************************************************
      /EJECT
      *****************************************************************
      * RTVTRN - RETRIEVE Transaction
      *****************************************************************
     C     RTVTRN        BEGSR
      *
      * RETRIEVE Transaction
      *
     C/COPY WNCPYSRC,SEH00056
     C                   CALLB     'SEPRCSRTV'
      *
      * INPUTS
      *
      * Return code
     C/COPY WNCPYSRC,SEH00057
     C                   PARM      *BLANK        RetCodeOut
     C/COPY WNCPYSRC,SEH00058
     C                   PARM                    @@MODE            6
     C                   PARM      'S'           @@RSMD            1
     C                   PARM      @FOTRANSEL    SEFRNT           20
     C                   PARM                    DDACTN            1
     C                   PARM                    DDPSSN           10
     C                   PARM                    DDPCNM           10
     C                   PARM                    DDPMKT            1
     C                   PARM                    DDPBRA            3
     C                   PARM                    DDPBOK            2
     C                   PARM                    DDPRFC            4
     C                   PARM                    DDPPRT            2
     C                   PARM                    DDPTFR            4
     C                   PARM                    BVEXOP
      *
      * OUTPUTS
      *
      * (Current) recd in file format
     C                   PARM                    CrDlFilFmt
     C                   PARM                    PBCD              2
     C                   PARM                    PBOK              2
     C                   PARM                    PRFC              4
     C                   PARM                    PCNM
     C                   PARM                    DDCURP           16
      *
      * OK flags
     C                   PARM      *BLANK        DDACTNOK
     C                   PARM      *BLANK        DDSSNOK
     C                   PARM      *BLANK        DDPCNMOK
     C                   PARM      *BLANK        DDPMKTOK
     C                   PARM      *BLANK        DDPBRAOK
     C                   PARM      *BLANK        DDPBOKOK
     C                   PARM      *BLANK        DDPRFCOK
     C                   PARM      *BLANK        DDPRTOK
     C                   PARM      *BLANK        DDPTFROK
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Warnings
      *
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM      *ZERO         Idx
     C                   PARM      *ZERO         WIdx
     C                   PARM      FCR997        @CR997
      *
      *
     C     EndRTVTRN     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CVTTRN - PUT A Transaction ON THE SCREEN
      *****************************************************************
     C     CVTTRN        BEGSR
      *
      * Call program to fill screen fields with data
      *
     C                   CALLB     'SEPRCSCVT'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM                    DDSTS
     C                   PARM      *BLANK        RetCodeOut
      *
      * Record in file format
     C                   PARM                    CrDlFilFmt
     C                   PARM                    PBOK
                                                                                              CGL031
      ** Taxation on Savings Income                                                           CGL031
                                                                                              CGL031
     C                   PARM                    CGL031                                       CGL031
      *
      * OUTPUTS
      *
      * Record in screen format
     C                   PARM                    NewTrScrn
     C                   PARM                    HPPRC
                                                                                              CSD010
      ** Switchable feature CSD010 parameters                                                 CSD010
     C                   PARM                    HBDPR                                        CSD010
     C                   PARM                    HOFPR                                        CSD010
     C                   PARM                    HCLPR                                        CSD010
     C                   PARM                    CSD010                                       CSD010
      *
      * Update 'Current' recd with recd in Screen Format
      *
     C                   MOVEL     NewTrScrn     CurTrScrn
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@A - CANCEL ON DETAILS SCREEN
      *****************************************************************
     C     CANC@A        BEGSR
      *
      * IF RECORDS ARE STILL TO BE READ FROM THE SUBFILE, READ THEM
      *
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
      *
      * ELSE, RETURN TO THE BROWSE SCREEN
      *
     C                   MOVEL     'I'           @SCRN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * UPDATS - UPDATES
      *****************************************************************
     C     UPDATS        BEGSR
 
     C                   MOVEL     *BLANK        @RTCD
     C                   MOVEL     DDACTN        PRCHTP
     C                   MOVEL     @FOTRANSEL    PRFRNT
     C/COPY WNCPYSRC,SEH00059
      *
      * Securities Prices details updates
      *
     C                   CALLB     'SEPRCSUPD'
     C/COPY WNCPYSRC,SEH00060
     C                   PARM      *BLANKS       @RTCD
     C/COPY WNCPYSRC,SEH00061
     C                   PARM                    NwDlFilFmt
     C                   PARM                    NwExFilFmt
     C                   PARM                    ValidPRXT
     C                   PARM                    CAC005
                                                                                              CGL031
      ** Taxation on Savings Income                                                           CGL031
                                                                                              CGL031
     C                   PARM                    CGL031                                       CGL031
      *
      * IF THERE WERE ANY ERRORS IN THE UPDATE FUNCTIONS, ROLLBACK ANY
      * UPDATES AND END THIS PROGRAM.
      * OTHERWISE DELETE THE INVALID transaction ACTIONED & COMMIT THE UPDATES
      *
     C     @RTCD         IFNE      *BLANK
     C                   If        (CSC022 <> 'Y')                                           BUG2812
     C                   ROLBK
     C                   Else                                                                BUG2812
     C                   If        (WCommitSkip <> 'Y')                                      BUG2812
     C                   ROLBK                                                               BUG2812
     C                   Else                                                                BUG2812
     C                   Seton                                        U7U8                   BUG2812
     C                   Endif                                                               BUG2812
     C                   EndIf                                                               BUG2812
     C     @RTCD         IFNE      '*RECUPD'
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ELSE
     C     ZATRNKD0      CHAIN     SEIPRCSD0                          99
     C  N99              DELETE    SEIPRCSD0
                                                                                              CSC011
      ** Delete the record from the APILOGPD file                                             CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y' and S1SUPP = LIBR                             CSC011
     C                   EVAL      KMsgType = 'SEPRCS'                                        CSC011
     C                   EVAL      KFrntOffID = @FOTranSel                                    CSC011
     C                   EVAL      KTimeStamp = @TmeStpSel                                    CSC011
                                                                                              CSC011
     C     KAPILOG       CHAIN     APILOGL0                           89                      CSC011
                                                                                              CSC011
     C                   IF        *IN89 = *Off                                               CSC011
     C                   DELETE    APILOGL0                                                   CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   If        (CSC022 <> 'Y')                                           BUG2812
     C                             or (CSC022 = 'Y' and WCommitSkip <> 'Y')                  BUG2812
     C                   COMMIT
     C                   EndIf                                                               BUG2812
     C                   END
      *
      * If error occurred in updating last transaction set on flag to
      * display message on 'browse' screen.
     C     @RTCD         IFEQ      '*RECUPD'
     C                   MOVE      'Y'           @ERRUP
     C                   ELSE
     C                   MOVE      'N'           @ERRUP
     C                   END
     C
      * IF RECORDS ARE STILL TO BE READ FROM THE SUBFILE, READ THEM
      *
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
      *
      * ELSE, RETURN TO THE BROWSE SCREEN
      *
     C                   MOVEL     'I'           @SCRN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SFKEYS - SET FUNCTION KEY STATUS ON SCREEN
      *****************************************************************
     C     SFKEYS        BEGSR
      *
      * Enable/disable function keys
      *
      * KG = COMMAND KEY 07 = READ PREVIOUS TRANSACTION
      * KH = COMMAND KEY 08 = READ NEXT TRANSACTION
      *
     C                   MOVEL     '0'           @INKG
     C                   MOVEL     '0'           @INKH
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ENDA - End Program
      *****************************************************************
     C     ENDA          BEGSR
      *
     C                   MOVEL     'T'           @SCRN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * TDtDtaSubs - Transaction Details Data Substitution            *
      *                                                               *
      *****************************************************************
 
     C     TDtDtaSubs    BEGSR
 
      ** Substitute the data for the various parts of the transaction,
      ** dependent on the flags that were set earlier.
 
     C                   if        RepPRCS = 'Y'
 
     C                   RESET                   ReturnCode
     C                   clear                   IncData
     C                   clear                   CurData
     C                   CALLB     'APDTASUBS'
 
      * Return Code
     C                   PARM                    ReturnCode       10
      * Substitution character
     C                   PARM      GHSUBS        SubsChar          1
      * Incoming Data
     C                   PARM      NewTrScrn     IncDATA        2000
      * Current Data
     C                   PARM      CurTrScrn     CurDATA        2000
 
     C                   MOVEL     IncDATA       NewTrScrn
 
     C                   endif
 
 
     C                   ENDSR
      *****************************************************************
      *****************************************************************
      /EJECT
      *****************************************************************
      * INITIAL Go To Initial Screen
      *****************************************************************
     C     INITIAL       BEGSR
      *
      * GO TO PRIMARY SCREEN
     C                   MOVEL     'A'           @SCRN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Initialize program name
      *
     C                   MOVEL     'SEPRCSRPR'   DBPGM
     C     *LIKE         DEFINE    C_PPRC        HPPRC
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
      ** Access Module Details
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE                         ************
     C                   MOVEL     '902'         DBASE                          * DBERR 901*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
 
      ***  Check if CAC005 is on
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CAC005'      @SARD             6
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CAC005
     C                   ELSE
     C                   MOVE      'N'           CAC005
     C                   ENDIF
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSD006'      @SARD             6
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CSD006
     C                   ELSE
     C                   MOVE      'N'           CSD006
     C                   ENDIF
                                                                                              CSC011
      ** Check if CSC011 is installed                                                         CSC011
                                                                                              CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
     C                   CALL      'AOSARDR0'                                                 CSC011
     C                   PARM      *Blanks       PRetCode                                     CSC011
     C                   PARM      '*VERIFY'     POption                                      CSC011
     C                   PARM      'CSC011'      PKey                                         CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
     C                   IF        PRetCode = *Blanks                                         CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
     C                   OPEN      APILOGL0                                                   CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IN        SDSTAT                                                     CSC011
     C                   ELSE                                                                 CSC011
                                                                                              CSC011
     C                   IF        PRetCode <> '*NRF   '                                      CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBKEY  = 'CSC011'                                          CSC011
     C                   EVAL      DBASE  = 903                                               CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
 
      ** Access switchable features file - Collateralised Lending (CSD010)                    CSD010
                                                                                              CSD010
     C                   CALL      'AOSARDR0'                                                 CSD010
     C                   PARM      *BLANKS       PRetCode                                     CSD010
     C                   PARM      '*VERIFY'     POption                                      CSD010
     C                   PARM      'CSD010'      PKey                                         CSD010
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD010
                                                                                              CSD010
     C                   IF        PRetCode <> *BLANKS AND                                    CSD010
     C                             PRetCode <> '*NRF   '                                      CSD010
     C                   EVAL      DBASE = 904                                                CSD010
     C                   EVAL      DBKEY = 'CSD010'                                           CSD010
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD010
     C                   EXSR      *PSSR                                                      CSD010
     C                   ENDIF                                                                CSD010
     C                                                                                        CSD010
     C                   IF        PRetCode = *BLANKS                                         CSD010
     C                   EVAL      CSD010 = 'Y'                                               CSD010
     C                   ELSE                                                                 CSD010
     C                   EVAL      CSD010 = 'N'                                               CSD010
     C                   ENDIF                                                                CSD010
                                                                                              CSD010
      ** Access switchable features file - Hedge Accounting Phase B (CAS006)                  CAS006
                                                                                              CAS006
     C                   CALL      'AOSARDR0'                                                 CAS006
     C                   PARM      *BLANKS       PRetCode                                     CAS006
     C                   PARM      '*VERIFY'     POption                                      CAS006
     C                   PARM      'CAS006'      PKey                                         CAS006
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS006
                                                                                              CAS006
     C                   IF        PRetCode <> *BLANKS AND                                    CAS006
     C                             PRetCode <> '*NRF   '                                      CAS006
     C                   EVAL      DBASE = 905                                                CAS006
     C                   EVAL      DBKEY = 'CAS006'                                           CAS006
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS006
     C                   EVAL      DBMOD = 'SEPRCSRPR'                                        CAS006
     C                   EXSR      *PSSR                                                      CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   IF        PRetCode = *BLANKS                                         CAS006
     C                   EVAL      CAS006 = 'Y'                                               CAS006
     C                   ELSE                                                                 CAS006
     C                   EVAL      CAS006 = 'N'                                               CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   CALL      'AOSARDR0'                                                 CGL031
     C                   PARM      *BLANKS       PRtcd                                        CGL031
     C                   PARM      '*VERIFY'     POptn                                        CGL031
     C                   PARM      'CGL031'      PSARd                                        CGL031
                                                                                              CGL031
     C     PRtcd         IFEQ      *BLANKS                                                    CGL031
     C                   MOVE      'Y'           CGL031                                       CGL031
     C                   ELSE                                                                 CGL031
     C                   MOVE      'N'           CGL031                                       CGL031
     C                   ENDIF                                                                CGL031
                                                                                              CGL031
      * Check if EXTEL indicator is on, BVEXOP
 
     C                   CALL      'AOSTRDR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDSTRD        PARM      SDSTRD        DSSDY
 
      * Key Lists
      *
     C     ZATRNKD0      KLIST
     C                   KFLD                    @FOTRANSEL
     C                   KFLD                    @TMESTPSEL
     C     ZATRNKX0      KLIST
     C                   KFLD                    @TMESTPSEL
     C                   KFLD                    @FOTRANSEL
 
     C     KAPILOG       KLIST                                                                CSC011
     C                   KFLD                    KMsgType                                     CSC011
     C                   KFLD                    KFrntOffID                                   CSC011
     C                   KFLD                    KTimeStamp                                   CSC011
 
      ** Get the field number for the action code field; the primary
      ** screen fields start from that number.  Subtract one from it to
      ** give the value to subtract from each field's number.
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM                    ReturnCode
     C                   PARM                    FormatA
     C                   PARM                    FieldA
     C                   PARM      *ZERO         FieldNo
 
     C                   IF        ReturnCode = *blank
     C                   EVAL      FldOffsetA = FieldNo - 1
     C                   ENDIF
      *
      * Start on Browse Screen
      *
     C                   MOVEL     'I'           @SCRN             1
      *
      ** Access Switchable Features File, for CSC022                                         BUG2812
      *                                                                                      BUG2812
     C                   Eval      CSC022 = 'N'                                              BUG2812
     C                   CallB     'AOSARDR0'                                                BUG2812
     C                   Parm      *BLANKS       @RTCD                                       BUG2812
     C                   Parm      '*VERIFY'     @OPTN                                       BUG2812
     C                   Parm      'CSC022'      @SARD                                       BUG2812
     C     SCSARD        Parm      SCSARD        DSFDY                                       BUG2812
      *                                                                                      BUG2812
     C                   If        @RTCD = *Blanks                                           BUG2812
     C                   Eval      CSC022 = 'Y'                                              BUG2812
     C                   Eval      WCommitSkip = 'N'                                         BUG2812
      *                                                                                      BUG2812
     C                   In        SCCMTJOB                                                  BUG2812
     C                   If        ComitNum > 0                                              BUG2812
     C                   MoveA     ComitJob      WCmtJobArr                                  BUG2812
      *                                                                                      BUG2812
     C     PSJOBNAME     LOOKUP    WCmtJobArr                             87                 BUG2812
     C                   If        *IN87 = *ON                                               BUG2812
     C                   Eval      WCommitSkip = 'Y'                                         BUG2812
     C                   EndIf                                                               BUG2812
     C                   EndIf                                                               BUG2812
      *                                                                                      BUG2812
     C                   Else                                                                BUG2812
      *                                                                                      BUG2812
      ** If return code <> *NRF, call program exception error routine                        BUG2812
      *                                                                                      BUG2812
     C                   If        @RTCD <> '*NRF'                                           BUG2812
     C     *LOCK         IN        LDA                                                       BUG2812
     C                   EVAL      DBKEY = 'CSC022'                                          BUG2812
     C                   EVAL      DBFILE = 'SCSARDPD'                                       BUG2812
     C                   EVAL      DBASE = 906                                               BUG2812
     C                   OUT       LDA                                                       BUG2812
     C                   Exsr      *PSSR                                                     BUG2812
     C                   EndIf                                                               BUG2812
     C                   EndIf                                                               BUG2812
      *                                                                                      BUG2812
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SEPRCSR014
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
