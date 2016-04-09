     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FD Forward rates repair control')
      *****************************************************************
      *                                                               *
      *  Midas - Dealing ILE Module                                   *
      *                                                               *
      *  FDFWRTRPR - Invalid Forward Rates Details                    *
      *              Repair Function                                  *
      *                                                               *
      *  Function:  This function allows invalid Forward Rates        *
      *             details to be 'repaired' and applied to the Midas *
      *             database.                                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *  Last Amend No. 241919             Date 22Dec06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG8233            Date 23Aug05               *
      *                 BUG8141            Date 11Aug05               *
      *                 238595 (Reopen)    Date 03Apr06               *
      *                 BUG1056            Date 20May04               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011             Date 18Sep01               *
      *                 196570             Date 20Jul01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006  *CREATE    Date 17Oct00               *
      *                 CAP059  *CREATE    Date 17Oct00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  241919 - Recompiled due to changes done to FDVFWRTPD.        *
      *  BUG8233- Error in Forward Rates upload via File Adapter API  *
      *           (Recompile)                                         *
      *  BUG8141- Recompiled due to changes to FDVFWRTPD              *
      *  238595 (Reopen) - Pass new parameter to FDFWRTVAL.           *
      *  BUG1056 - (CSC022) Commitment Control Changes for MidasPlus  *
      *  CSC011 - 24x7 Midas Availability                             *
      *  196570 - Patch for Market Data Feed (recompile)              *
      *  CSD006 - Market Data Feed (Recompiled)                       *
      *  CAP059 - Conversion of Forward Rates into Modular APIs       *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FZATRNERRL0IF   E           K DISK    INFSR(*PSSR)
 
     FFDIFWRTL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FDIFWRTD0:FDIFWRTX0)
     FFDIFWRTL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     FAPILOGL0  UF   E           K DISK    INFSR(*PSSR) USROPN                                CSC011
     F                                     COMMIT                                             CSC011
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,FDFWRTR001
 
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
      ** The following /COPY includes the FD standard declares:
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
      ** Commitment Control Job Array                                                        BUG1056
     D WJobs           S             10A   Dim(10)                                           BUG1056
      **                                                                                     BUG1056
 
      * Current Forward Rates Transaction in File Format
     D CrTrFilFmt    E DS                  EXTNAME(FWDRTFE)
     D                                     PREFIX(C_)
 
     D PrvFRFilFmt   E DS                  EXTNAME(FDVFWRTPD)
     D                                     PREFIX(P_)
      ** Previous Forward Rates Detail in File Format
 
      * Current Forward Rates Transaction in Screen Format
     D CurTrScrn     E DS                  EXTNAME(FDFWRTPD)
     D                                     PREFIX(@)
 
      * New Forward Rates Transaction in File Format
     D NwTrFilFmt    E DS                  EXTNAME(FDVFWRTPD)
 
      * New Forward Rates Transaction in Screen Format
     D NewTrScrn     E DS                  EXTNAME(FDFWRTPD)
 
     D CurFRExtDta   E DS                  EXTNAME(FDIREXPD)
      ** Current forward Rates Extra Data
 
      * Previous Forward Rates Transaction in Screen Format
     D PrvTrScrn     E DS                  EXTNAME(FDFWRTPD)
     D                                     PREFIX(@P)
 
 
      * Error indicators
     D OKTrFWRT      E DS                  EXTNAME(FDEFWRTPD)
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_LCD       E                     EXTFLD(LCD)
      ** EXTERNAL DS FOR SAR DETAILS
 
     D SDAPI         E DS                  EXTNAME(SDAPIPD)                     CAP011
      ** EXTERNAL DS FOR API ICD                                                CAP011
                                                                                CAP011
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
      ** 24X7 status data area                                                                CSC011
                                                                                              CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
      ** SD data area                                                                         CSC011
                                                                                              CSC011
      ** SCCMTJOB DataArea Layout                                                            BUG1056
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                BUG1056
     D  WDSJobs                4    103A                                                     BUG1056
      **                                                                                     BUG1056
      ** Changed Party Names Array
     D ChgNamArr       S              1    DIM(5)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      **   Timestamp selected
     D @TMESTPSEL      S             26Z
 
      ** Update Y/N?                                                                          238595
     D UpdateYN        S              1A   INZ(*BLANK)                                        238595
                                                                                              238595
      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')
 
      ** -------------------------------------------------------------------
      ** Fields for getting the starting field number from file (parameters
      ** to ZACGTFLDNO, plus the offset to the requested field).
     D FormatA         S             10A   INZ('FDFWRTPD')
 
     D Field1          S             10A   INZ('DDFLD1')
 
     D FieldA          S             10A   INZ('DDCCY')
 
     D FldOffsetA      S              5P 0
 
     D FieldNo         S              5P 0
 
      ** End of fields for getting starting field number
 
      ** -------------------------------------------------------------------
 
     D WKCCY           S                   LIKE(DDCCY)
 
      ** Flags to indicate whether substitution is required in
      ** each of the various parts the transaction
     D RepFWRT         S              1A   inz('N')
      ** -------------------------------------------------------------------
 
      ** Fields defined for Enhancement CSC011                                                CSC011
                                                                                              CSC011
     D CSC011          S              1A                                                      CSC011
     D PRtCd           S              7A                                                      CSC011
     D POptn           S              7A                                                      CSC011
     D PSard           S              6A                                                      CSC011
     D KMsgType        S              8A                                                      CSC011
     D KFrntOffID      S             20A                                                      CSC011
     D KTimeStamp      S                   LIKE(@TMESTPSEL)                                   CSC011
                                                                                              CSC011
      ** CSC022 work fields                                                                  BUG1056
     D WArrPtr         S              3S 0                                                   BUG1056
     D WSkpComtRolbk   S              1A                                                     BUG1056
      **                                                                                     BUG1056
      ** CSC022 switchable field                                                             BUG1056
     D CSC022          S              1A                                                     BUG1056
      **                                                                                     BUG1056
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,FDFWRTR002
 
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
      /COPY WNCPYSRC,FDFWRTR003
      *
      * Issue rollback to clear any possible updates in window functions
      *
     C     @INKL         IFEQ      '1'
      **                                                                                     BUG1056
      ** Execute rollback if SAR CSC022 is not enrolled or                                   BUG1056
      **   job is not currently running in batch mode                                        BUG1056
      **                                                                                     BUG1056
     C                   If        CSC022 = 'N'                                              BUG1056
     C                   ROLBK
     C                   Else                                                                BUG1056
     C                   If        WSkpComtRolbk = 'N'                                       BUG1056
     C                   RolBk                                                               BUG1056
     C                   Else                                                                BUG1056
     C                   SetOn                                        U7U8                   BUG1056
     C                   EndIf                                                               BUG1056
     C                   EndIf                                                               BUG1056
     C                   END
      *
      /COPY WNCPYSRC,FDFWRTR004
      *
      * DO SCREEN: BROWSE INVALID Inputs
      *
     C     @SCRN         IFEQ      'I'
     C                   EXSR      SCRN@I
     C                   END
      *
      /COPY WNCPYSRC,FDFWRTR005
      *
      ** Read next browse subfile record
      *
     C     @SCRN         IFEQ      'R'
     C                   EXSR      RDNBRW
     C                   ENDIF
      *
      /COPY WNCPYSRC,FDFWRTR006
      *
      ** DO WHILE screen
      *
     C                   EXSR      SNDM@A
     C     @SCRN         DOWEQ     'A'
     C                   EXSR      SCRN@A
     C                   ENDDO
      *
      /COPY WNCPYSRC,FDFWRTR011
      *
      ** Do File updates
      *
     C     @SCRN         IFEQ      'U'
     C                   EXSR      UPDATS
     C                   ENDIF
      *
      /COPY WNCPYSRC,FDFWRTR012
      *
      ** Terminate program
      *
     C     @SCRN         IFEQ      'T'
     C                   MOVE      *ON           *INLR
     C                   ENDIF
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,FDFWRTR013
 
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
     C                   CALLB     'FDFWRTRPB'
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
      * Error in update of previous deal
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
     C                   PARM      *blanks       DDCCY
      *
      * TIMESTAMP OF TRANSACTION SELECTED
     C                   PARM                    @TMESTPSEL
      *
      * COMMAND KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
                                                                                              CSC011
      ** CSC011 Enhancement is installed                                                      CSC011
     C                   PARM                    CSC011                                       CSC011
      ** CSC022 Enhancement is installed                                                     BUG1056
      **                                                                                     BUG1056
     C                   PARM                    CSC022                                      BUG1056
      **                                                                                     BUG1056
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
     C                   CALLB     'FDFWRTRPB'
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
      * Error in update of previous deal
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
     C                   PARM      *BLANK        DDCCY
      *
      * TIMESTAMP OF TRANSACTION SELECTED
     C                   PARM                    @TMESTPSEL
      *
      * COMMAND KEYS
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKL
                                                                                              CSC011
      ** CSC011 Enhancement is installed                                                      CSC011
     C                   PARM                    CSC011                                       CSC011
      ** CSC022 Enhancement is installed                                                     BUG1056
      **                                                                                     BUG1056
     C                   PARM                    CSC022                                      BUG1056
      **                                                                                     BUG1056
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
     C                   CLEAR                   NwTrFilFmt
      *
      * BLANK THE SCREENS
      *
     C                   Eval      WKCCY = DDCCY
     C                   CLEAR                   NewTrScrn
      *
      * RESET ERRORS
      *
     C                   MOVE      *ALL'Y'       OKTrFWRT
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
 
      ** Reset warning fields
 
     C                   RESET                   WFldNamArr
     C                   RESET                   WMsgIdArr
     C                   RESET                   WMsgDtaArr
     C                   RESET                   WIdx              3 0
      *
      * Retrieve Transaction details
      *
     C                   Eval      DDCCY =WKCCY
     C                   MOVEL     @ACSEL        DDACTN
     C                   MOVEL     @FOTRANSEL    FWFRNT
      *
      * Make sure Invalid transaction's  details are passed to 'Retreive'
      * module for SPF checking .
      *
     C     ZATRNKX0      CHAIN     FDIFWRTX0                          99
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
     C     DDCCY         IFEQ      *BLANK
     C                   MOVEL     '*FRONT'      @@MODE
     C                   ELSE
     C                   MOVEL     '      '      @@MODE
     C                   ENDIF
     C                   ENDIF
      *
     C                   EXSR      RTVTRN
      *
      * If Forward Rates Transaction details were retrieved
      * Convert to screen format.
      *
     C     C_CCY         IFNE      *BLANK
     C     DDACTN        ANDNE     'I'
     C     DDACTN        IFEQ      'A'
     C                   MOVEL     CrTrFilFmt    PrvFRFilFmt
     C                   ENDIF
     C                   EXSR      CVTTRN
     C                   MOVEL     CrTrFilFmt    NwTrFilFmt
     C                   END
      *
      * Now overwite the fields on the main details screen with those
      * on the invalid Transactions file (except for the Midas Transaction
      * reference retrieved above using the front office transaction ID).
      * Access invalid transaction with timestamp and front office transaction ID.
      *
      * Transaction details:
     C                   MOVEL     DDCCY         ##DDCCY           3
     C     ZATRNKX0      CHAIN     FDIFWRTX0                          99
      *
      * If Transaction details were retrieved and this is an amendment
      *
     C     C_CCY         IFNE      *BLANK
     C     DDACTN        ANDEQ     'A'
 
      * Data Substitution - Transaction Details
 
     C     GHSUBS        ifne      *blank
 
     C     GHSUBS        SCAN      NewTrScrn                              99
     C                   if        *in99
     C                   eval      RepFWRT = 'Y'
     C                   endif
 
      ** If any of the flags set above is true, do the data
      ** substution subroutine.
     C                   if        (RepFWRT = 'Y')
     C                   EXSR      TDtDtaSubs
     C                   endif
 
     C                   END
 
 
     C                   END
      *
      * If action code, or Transaction reference were NOT OK
      * blank out action code so that the input cannot proceed
      *
     C     DDACTNOK      IFEQ      'N'
     C     DDCCYOK       OREQ      'N'
     C                   MOVEL     *BLANK        DDACTN
     C                   END
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
 
     C                   Z-ADD     Idx           E                 3 0
      *
      ** If there are fundamental errors in this transaction
      ** Identify this fact.
      *
     C     DDACTNOK      IFEQ      'N'
     C     DDCCYOK       OREQ      'N'
     C                   Z-ADD     1             E                 3 0
     C                   Z-ADD     1             Idx
     C                   MOVE      *ALL'Y'       OKTRFWRT
     C                   MOVE      *ALL'Y'       @EI
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     '*ANY'        FldNameArr(E)
     C                   MOVEL     'APM0110'     MsgIdArr(E)
     C                   ELSE
     C                   Z-ADD     *ZERO         E
     C                   Z-ADD     *ZERO         Idx
     C                   MOVE      *ALL'Y'       OKTRFWRT
     C                   MOVE      *ALL'Y'       @EI
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   ENDIF
      *
      ** Initialize error indicators
      *
     C                   MOVEA     OKTrFWRT      @EI
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
     C                   MOVEA     @EI           OKTrFWRT
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
     C                   MOVEL     'N'           @EDTFD
     C                   ELSE
     C                   MOVEL     'Y'           @EDTFD
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
     C                   CALLB     'FDFWRTDSP'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUT PARAMETERS :
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Transaction (IN SCREEN FORMAT - Primary)
     C                   PARM                    NewTrScrn
      *
      * Fields in error
     C                   PARM                    OKTrFwrt
 
      * ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      * ENABLED KEY & DETAIL FIELDS
      *
     C                   PARM      'N'           @EKYFD            1
     C                   PARM                    @EDTFD            1
      *
      *
      * ENABLED FUNCTION KEYS
      * KG = COMMAND KEY 07 = READ PREVIOUS
      * KH = COMMAND KEY 08 = READ NEXT
      * KX = COMMAND KEY 23 = FURTHER DETAILS
     C                   PARM                    @EINKJ            1
      *
      * OUTPUT PARAMETERS :
      * Function Keys
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKG             1
     C                   PARM      '0'           @INKH             1
     C                   PARM      '0'           @INKJ             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKP             1
      *
      * RESET ERRORS ....
      *
     C                   MOVE      *ALL'Y'       OKTrFWRT
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
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
      *
      * Retrieve Forward Rates Transaction details
      *
     C                   EXSR      RTVTRN
      *
      * If action code, or Transaction reference are NOT OK
      * Re-output screen with error messages on it
      *
     C     DDACTNOK      IFEQ      'N'
     C     DDCCYOK       OREQ      'N'
     C                   GOTO      EndVAL@A
     C                   END
      *
     C                   IF        DDACTN = 'I'
     C                   IF        DDRTE1 <>WKRTE1
     C                   EXSR      SrDFT
     C                   GOTO      ENDVAL@A
     C                   ENDIF
     C                   ENDIF
 
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
     C                   MOVE      *ALL'Y'       OKTrFWRT
     C                   CLEAR                   NwTrFilFmt
 
     C                   IF         DDACTN = 'A' OR DDACTN = 'I'
 
     C                   CALLB     'FDFWRTAMD'
     C                   PARM                    RetCodeIn
     C                   PARM                    PRVTRSCRN
     C                   PARM                    NEWTRSCRN
     C                   PARM                    OKTRFWRT
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    AmendOk           1
     C                   PARM      'Y'           ResetErrs         1
 
     C     Idx           IFNE      *ZERO
     C                   GOTO      ENDVAL@A
     C                   ENDIF
 
     C                   ENDIF
      *
      * Validate Forward Rates Transaction details
      *
     C                   CALLB     'FDFWRTVAL'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUTS :
 
      * Response mode
     C                   PARM                    RespMode
 
      ** Transaction Primary Details
     C                   PARM                    NewTrScrn
     C                   PARM                    CurFRExtDta
     C                   PARM                    PrvFRFilFmt
 
      * OUTPUTS :
 
      ** Transaction Primary Details OK inds
     C                   PARM                    OKTrFWRT
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      * Warning Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
      * Valid Transaction layout (DS) from/to caller
     C                   PARM                    NwTrFilFmt
      * Update Y/N                                                                            238595
     C                   PARM                    UpdateYN                                     238595
      *
      * If errors returned
     C     Idx           IFNE      0
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
     C                   MOVE      *ALL'Y'       OKTrFwrt
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
     C                   MOVE      'U'           @SCRN
      *
     C     EndVAL@A      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrDFT - Default first rate                                    *
      *                                                               *
      *****************************************************************
     C     SrDFT         BEGSR
 
      ** Call Retrieve Module
 
     C                   CALLB     'FDFWRTDFT'
      * Return Code
     C                   PARM                    RetCodeIn
      ** Action Code
     C                   PARM                    DDACTN            1
      ** Currency Code
     C                   PARM                    DDCCY             3
      ** First Rate
     C                   PARM                    WKRTE1           14
      * OUTPUTS
      *
      * Field OK flags (DS) from/to caller
     C                   PARM                    OKTrFWRT
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
      *
     C                   PARM                    Idx
      *
      * Reset of Fields in Error Required (Y/N)
     C                   PARM      'Y'           ResetErrs         1
 
     C                   EVAL      DDRTE1 = WKRTE1
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RTVTRN - RETRIEVE Transaction
      *****************************************************************
     C     RTVTRN        BEGSR
      *
      * RETRIEVE Transaction
      *
     C                   CALLB     'FDFWRTRTV'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUTS :
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM                    @@MODE            6
      *
      * Response mode
     C                   PARM      'S'           @@RSMD            1
      *
      * Action Code
     C                   PARM                    DDACTN
      *
      * (Midas) Transaction number
     C                   PARM                    DDCCY             3
      *
      * Front Office Transaction ID
     C                   PARM      @FOTRANSEL    FWFRNT
      *
      * OUTPUTS :
      * (Current) Transaction in file format
     C                   PARM                    CrTrFilFmt
      *
      * OK - Action code
     C                   PARM      *BLANK        DDACTNOK
      *
      * OK - Transaction Reference
     C                   PARM      *BLANK        DDCCYOK
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM      *ZERO         Idx
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
     C                   CALLB     'FDFWRTCVT'
      *
      * INPUTS :
      * Return Code
      * Transaction in file format
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    CrTrFilFmt
      * OUTPUTS
      * Transaction - screen formats
     C                   PARM                    NewTrScrn
 
      *
      * Update 'Current' Transaction with Transaction in Screen Format
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
      *
      * Update valid transaction: transaction reference
      *
     C                   MOVEL     DDCCY         FWCCY
     C                   MOVEL     DDACTN        FWCHTP
     C                   MOVEL     *BLANK        @RTCD
      *
      * Forward Rates Transaction Details Dates
      *
     C                   CALLB     'FDFWRTUPD'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    NwTrFilFmt
      *
      *
      * IF THERE WERE ANY ERRORS IN THE UPDATE FUNCTIONS, ROLLBACK ANY
      * UPDATES AND END THIS PROGRAM.
      * OTHERWISE DELETE THE INVALID transaction ACTIONED & COMMIT THE UPDATES
      *
     C     @RTCD         IFNE      *BLANK
     C     @RTCD         ANDNE     '*RECUPD'                                    6
      **                                                                                     BUG1056
      ** Execute rollback if SAR CSC022 is not enrolled or                                   BUG1056
      **   job is not currently running in batch mode                                        BUG1056
      **                                                                                     BUG1056
     C                   If        CSC022 = 'N'                                              BUG1056
     C                             Or (CSC022 = 'Y' and WSkpComtRolbk = 'N')                 BUG1056
     C                   ROLBK
     C                   EndIf                                                               BUG1056
     C                   EXSR      *PSSR
     C                   ELSE
     C     ZATRNKD0      CHAIN     FDIFWRTD0                          99
     C  N99              DELETE    FDIFWRTD0
                                                                                              CSC011
      ** Delete invalid record from the log file.                                             CSC011
                                                                                              CSC011
     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)                         CSC011
                                                                                              CSC011
     C                   EVAL      KMsgType = 'FDFWRT'                                        CSC011
     C                   EVAL      KFrntOffID = @FOTRANSEL                                    CSC011
     C                   EVAL      KTimeStamp = @TMESTPSEL                                    CSC011
                                                                                              CSC011
     C     KAPILOGL0     CHAIN     APILOGL0                           99                      CSC011
     C                   IF        *IN99 = *OFF                                               CSC011
     C                   DELETE    APILOGL0                                                   CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
      **                                                                                     BUG1056
      ** Execute commit if SAR CSC022 is not enrolled or                                     BUG1056
      **   job is not currently running in batch mode                                        BUG1056
      **                                                                                     BUG1056
     C                   If        CSC022 = 'N'                                              BUG1056
     C                             Or (CSC022 = 'Y' and WSkpComtRolbk = 'N')                 BUG1056
     C                   COMMIT
     C                   EndIf                                                               BUG1056
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
 
     C                   if        RepFWRT = 'Y'
 
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
     C                   MOVEL     'FDFWRTRPR'   DBPGM
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
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
                                                                                              CSC011
      ** Check if CSC011 is installed                                                         CSC011
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
     C                   IN        SDSTAT                                                     CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
                                                                                              CSC011
     C                   IF        PRtCd <> '*NRF'                                            CSC011
     C     *LOCK         IN        LDA                                                        CSC011
     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBASE =  902                                               CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
      **                                                                                     BUG1056
      ** Access SAR details to see if CSC022 is switched on                                  BUG1056
      **                                                                                     BUG1056
     C                   CallB     'AOSARDR0'                                                BUG1056
     C                   Parm      *Blanks       PRtCd                                       BUG1056
     C                   Parm      '*VERIFY'     POptn                                       BUG1056
     C                   Parm      'CSC022'      PSard                                       BUG1056
     C     SCSARD        Parm      SCSARD        DSFDY                                       BUG1056
      ** Initialize CSC022 and Skip Commit Flags                                             BUG1056
     C                   Eval      CSC022 = 'N'                                              BUG1056
     C                   Eval      WSkpComtRolbk = 'N'                                       BUG1056
      **                                                                                     BUG1056
     C                   If        PRtCd = *BLANKS                                           BUG1056
     C                   Eval      CSC022 = 'Y'                                              BUG1056
      **                                                                                     BUG1056
      ** Get Jobs currently running i batch mode using SCCMRJOB dataarea                     BUG1056
      **                                                                                     BUG1056
     C                   In        SCCMTJOB                                                  BUG1056
     C                   If        ComitNum > 0                                              BUG1056
      ** Move committed jobs to arrary for checking                                          BUG1056
     C                   MoveA     WDSJobs       WJobs                                       BUG1056
      ** Verify if job running exists in array                                               BUG1056
     C                   Eval      WArrPtr = %LookUp(PSJobName:WJobs)                        BUG1056
     C                   If        WArrPtr > 0                                               BUG1056
     C                   Eval      WSkpComtRolbk = 'Y'                                       BUG1056
     C                   EndIf                                                               BUG1056
     C                   EndIf                                                               BUG1056
      **                                                                                     BUG1056
     C                   Else                                                                BUG1056
      ** Execute *PSSR if CSC022 is not found or Database error                              BUG1056
     C                   If        PRtCd <> '*NRF'                                           BUG1056
     C     *Lock         In        LDA                                                       BUG1056
     C                   Eval      DBFile = 'SCSARDPD'                                       BUG1056
     C                   Eval      DBPgm  = 'FDFWRTRPR'                                      BUG1056
     C                   Eval      DBKey  = 'CSC022'                                         BUG1056
     C                   Eval      DBase  = 900                                              BUG1056
     C                   Out       LDA                                                       BUG1056
     C                   Exsr      *PSSR                                                     BUG1056
     C                   EndIf                                                               BUG1056
     C                   EndIf                                                               BUG1056
      **                                                                                     BUG1056
      *
      * Key Lists
      *
     C     ZATRNKD0      KLIST
     C                   KFLD                    @FOTRANSEL
     C                   KFLD                    @TMESTPSEL
     C     ZATRNKX0      KLIST
     C                   KFLD                    @TMESTPSEL
     C                   KFLD                    @FOTRANSEL
     C     KAPILOGL0     KLIST                                                                CSC011
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
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,FDFWRTR014
 
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
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
