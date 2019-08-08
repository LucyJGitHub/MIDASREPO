     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Spot rate repair')                            *
      *****************************************************************
      *                                                               *
      *  Midas - Module name ILE Module                               *
      *                                                               *
      *  SDSPTRRPR - INVALID SPOT RATE DETAILS                        *
      *              REPAIR FUNCTION                                  *
      *                                                               *
      *  Function:  This function allows invalid Spot Rate details to *
      *             be 'repaired' and applied to the Midas database.  *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD054039           Date 05Aug19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CFT147             Date 14Jan13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 BUG8205            Date 22Aug05               *
      *                 BUG8130            Date 11Aug05               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084             Date 26Aug03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 204923             Date 29Apr02               *
      *                 200420             Date 22Nov01               *
      *                 CSC011             Date 18Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 25Oct00               *
      *                 CAP057  *CREATE    Date 25Oct00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD054039 - DBU_SPTR did not update the spot rate (Recompile) *
      *  MD046248 - Finastra Rebranding                               *
      *  CFT147 - Automatic update of payment charges definitions     *
      *           Added hooks: CFT147_025, CFT147_026                 *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG8205 - Recompiled due to changes in file SDVSPTRPD        *
      *            Applied fix 209061                                 *
      *  BUG8130- Recompiled due to changes in SDVSPTRPD              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - API Wrapper project.  Override file SDCURRL0.       *
      *  204923 - Rate Fix Days Adjustment (OIS)                      *
      *           (Recompiled over changed SDVSPTRPD)                 *
      *  200420 - Database error due to inconsistency in commitment   *
      *           control on file SDCURRL1                            *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CSD006 - Market Data Feeds                                   *
      *  CAP057 - Conversion of SPOT Rates into Modular APIs         *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FZATRNERRL0IF   E           K DISK    INFSR(*PSSR)

     FSDISPTRL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDISPTRD0:SDISPTRX0)
     FSDISPTRL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
                                                                                              CSC011
      ** API Invalid log file by Type/FO Id/Time                                              CSC011
     FAPILOGL0  UF   E           K DISK    INFSR(*PSSR) USROPN                                CSC011
     F                                     COMMIT                                             CSC011

      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,SDSPTRR001

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

      * Current Spot Rate Transaction in File Format
     D CrTrFilFmt    E DS                  EXTNAME(SDCURRPD)
     D                                     PREFIX(C_)

      * Current Spot Rate Transaction in Screen Format
     D CurTrScrn     E DS                  EXTNAME(SDSPTRPD)
     D                                     PREFIX(@)

      * New Spot Rate Transaction in File Format
     D NwTrFilFmt    E DS                  EXTNAME(SDVSPTRPD)

      * New Spot Rate Transaction in Screen Format
     D NewTrScrn     E DS                  EXTNAME(SDSPTRPD)



      * Previous Spot Rate Transaction in Screen Format
     D PrvTrScrn     E DS                  EXTNAME(SDSPTRPD)
     D                                     PREFIX(@P)


      * Error indicators
     D OkTrTran      E DS                  EXTNAME(SDESPTRPD)


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

     D ExtData       E DS                  EXTNAME(SDSPTXPD)
      * Mm Transaction Extra Data - File (D/B) format
                                                                                              CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
      ** 24X7 status data area                                                                CSC011
                                                                                              CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
      ** SD data area                                                                         CSC011
                                                                                              CSC011
     D*PCMD************S            100    DIM(2) CTDATA PERRCD(1)                     200420 CAP084
     D PCMD            S            100    DIM(4) CTDATA PERRCD(1)                            CAP084
      ** Override Database Table                                                              200420

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      **   Timestamp selected
     D @TMESTPSEL      S             26Z

      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')

      ** -------------------------------------------------------------------
      ** Fields for getting the starting field number from file (parameters
      ** to ZACGTFLDNO, plus the offset to the requested field).
     D FormatA         S             10A   INZ('SDSPTRPD')

     D Field1          S             10A   INZ('DDDTFR')

     D FldOffsetA      S              5P 0

     D FieldNo         S              5P 0

      ** End of fields for getting starting field number

      ** Define module parameter fields for CVT output and DSP input

     D SDCURR        E DS                  EXTNAME(SDCURRPD)
     D QQSPAE1       E                     EXTFLD(QQSPAE)                                     CGL029
     D QQFTAE1       E                     EXTFLD(QQFTAE)                                     CGL029
     D QQSWAE1       E                     EXTFLD(QQSWAE)                                     CGL029
     D QQTAC41       E                     EXTFLD(QQTAC4)                                     CGL029
     D QQTAC51       E                     EXTFLD(QQTAC5)                                     CGL029
     D QQCSCD1       E                     EXTFLD(QQCSCD)                                     CGL029
     D DDDCY2          S                   LIKE(A6DLCI)
     D DDSWC2          S                   LIKE(A6SWCY)
     D DDVSEU          S                   LIKE(A6CYCD)
     D DDMDI2          S                   LIKE(A6MDIN)
     D DDSPR2          S                   LIKE(DDSPRT)
     D DDCYNM          S                   LIKE(A6CYNM)
     D DDDLCY          S                   LIKE(A6DLCI)
     D DDSWCY          S                   LIKE(A6SWCY)

      ** -------------------------------------------------------------------

     D WKCYCD          S                   LIKE(DDCYCD)

      ** Flags to indicate whether substitution is required in
      ** each of the various parts the transaction
     D RepSPTR         S              1A   inz('N')
                                                                                              CSC011
     D CSC011          S              1A   INZ('N')                                           CSC011
     D KMsgType        S              8A                                                      CSC011
     D KFrntOffID      S             20A                                                      CSC011
     D KTimeStamp      S                   LIKE(@TMESTPSEL)                                   CSC011
     D PRTCD           S              7A                                                      CSC011
     D POPTN           S              7A                                                      CSC011
     D PSARD           S              6A                                                      CSC011
     D PCMDLEN         S             15  5                                                    200420
                                                                                              200420
     D/COPY OFCPYSRCZ,CFT147_025                                                              CFT147
      ** -------------------------------------------------------------------

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,SDSPTRR002

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
      /COPY WNCPYSRC,SDSPTRR003
      *
      * Issue rollback to clear any possible updates in window functions
      *
     C     @INKL         IFEQ      '1'
     C                   ROLBK
     C                   ENDIF
      *
      /COPY WNCPYSRC,SDSPTRR004
      *
      * DO SCREEN: BROWSE INVALID Inputs
      *
     C     @SCRN         IFEQ      'I'
     C                   EXSR      SCRN@I
     C                   ENDIF
      *
      /COPY WNCPYSRC,SDSPTRR005
      *
      ** Read next browse subfile record
      *
     C     @SCRN         IFEQ      'R'
     C                   EXSR      RDNBRW
     C                   ENDIF
      *
      /COPY WNCPYSRC,SDSPTRR006
      *
      ** DO WHILE screen
      *
     C                   EXSR      SNDM@A
     C                   Z-ADD     *ZERO         WIdx              3 0
     C     @SCRN         DOWEQ     'A'
     C                   EXSR      SCRN@A
     C                   ENDDO
      *
      /COPY WNCPYSRC,SDSPTRR011
      *
      ** Do File updates
      *
     C     @SCRN         IFEQ      'U'
     C                   EXSR      UPDATS
     C                   ENDIF
      *
      /COPY WNCPYSRC,SDSPTRR012
      *
      ** Terminate program
      *
     C     @SCRN         IFEQ      'T'
     C                   MOVE      *ON           *INLR
     C                   ENDIF

      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,SDSPTRR013

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
     C                   CALLB     'SDSPTRRPB'
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
     C                   PARM      *blanks       DDCYCD
      *
      * TIMESTAMP OF TRANSACTION SELECTED
     C                   PARM                    @TMESTPSEL
      *
      * COMMAND KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
      *                                                                                       CSC011
     C                   PARM                    CSC011                                       CSC011
      *
      * If error set on external switches
      *
     C     @ERRMS        IFNE      *BLANK
     C                   MOVE      '1'           *INU6
     C                   ENDIF
      *
      * If CK/3 or CK/12 taken in browse, or error message
      * End program
      *
     C     @INKC         IFEQ      '1'
     C     @INKL         OREQ      '1'
     C     @ERRMS        ORNE      *BLANK
     C                   EXSR      ENDA
     C                   GOTO      ESCRN@I
     C                   ENDIF
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
     C                   CALLB     'SDSPTRRPB'
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
     C                   PARM      *BLANK        DDCYCD

      * Timestamp of transaction selected
     C                   PARM                    @TMESTPSEL

      * Command keys
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKL
      *                                                                                       CSC011
     C                   PARM                    CSC011                                       CSC011

      * If CK/3 taken within invalid transaction deletion function,
      * End program

     C     @INKC         IFEQ      '1'
     C                   EXSR      ENDA
     C                   GOTO      ERDNBRW
     C                   ENDIF

      * If invalid customer read from subfile

     C     @OPSEL        IFNE      *BLANK

      * Clear file formats
     C                   CLEAR                   NwTrFilFmt

      * Black the screen

     C                   Eval      WKCYCD = DDCYCD
     C                   CLEAR                   NewTrScrn

      * Reset errors

     C                   MOVE      *ALL'Y'       OkTrTran
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr

      * Retrieve Transaction details

     C                   Eval      DDCYCD = WKCYCD
     C                   Eval      DDACTN = @ACSEL
     C                   Eval      AVFOTRANID = @FOTRANSEL

      * Make sure Invalid transaction's details are passed to 'Retrieve'
      * module for SPF checking .
      *
     C     ZATRNKX0      CHAIN     SDISPTRX0                          99
      *
      *  Set retrieve mode to blank  (Access using Midas transaction ID).
      *
     C                   MOVEL     '      '      @@MODE
      *
     C                   EXSR      RTVTRN
      *
      * If Spot Rate Transaction details were retrieved
      * Convert to screen format.
      *
     C     C_A6CYCD      IFNE      *BLANK
     C                   EXSR      CVTTRN
     C                   ENDIF
      *
      * Now overwite the fields on the main details screen with those
      * on the invalid Transactions file (except for the Midas Transaction
      * reference retrieved above using the front office transaction ID).
      * Access invalid transaction with timestamp and front office transaction ID.
      *
      * Transaction details:
     C                   MOVEL     DDCYCD        ##DDCYCD          6
     C     ZATRNKX0      CHAIN     SDISPTRX0                          99
      *
      * If Transaction details were retrieved
      *
     C     C_A6CYCD      IFNE      *BLANK

      * Data Substitution - Transaction Details

     C     GHSUBS        IFNE      *BLANK

     C     GHSUBS        SCAN      NewTrScrn                              99
     C                   IF        *IN99
     C                   EVAL      RepSPTR = 'Y'
     C                   ENDIF

      ** If any of the flags set above is true, do the data
      ** substution subroutine.

     C                   IF        (RepSPTR = 'Y')
     C                   EXSR      TDtDtaSubs
     C                   ENDIF

     C                   ENDIF


     C                   ENDIF
      *
      * If action code, or Transaction reference were NOT OK
      * blank out action code so that the input cannot proceed
      *
     C     DDACTNOK      IFEQ      'N'
     C     DDCYCDOK      OREQ      'N'
     C                   MOVEL     *BLANK        DDACTN
     C                   ENDIF

      * Go to the Detail screen

     C                   MOVE      'A'           @SCRN

      * Else if no invalid transaction read from subfile

     C                   ELSE

      * Go to browse screen

     C                   MOVE      'I'           @SCRN
     C                   ENDIF

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
     C     DDCYCDOK      OREQ      'N'
     C                   ADD       1             E
      *
      * Ensure that the message 'TRANSACTION CANNOT PROCEED' is seen
      * first by the user
      *
     C                   EVAL      TmpfldNmAr = *BLANKS
     C                   EVAL      TmpMsgIdAr = *BLANKS
     C                   MOVEA     FldNameArr    TmpFldNmAr
     C                   MOVE      *BLANKS       FldNameArr(1)
     C                   MOVEA     TmpFldNmAr    FldNameArr(2)
     C                   MOVEA     MsgIdArr      TmpMsgIdAr
     C                   MOVE      *BLANKS       MsgIdArr(1)
     C                   MOVEA     TmpMsgIdAr    MsgIdArr(2)
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'APM0110'     MsgIdArr(1)
     C                   ENDIF
      *
      ** Initialize error indicators
      *
     C                   MOVEA     OkTrTran      @EI
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
     C                   Z-ADD     FieldNo       F                 3 0
     C                   SUB       FldOffsetA    F
     C     F             IFLT      1
     C     F             ORGT      60
     C                   Z-ADD     1             F
     C                   END
     C                   MOVE      'N'           @EI(F)
     C                   ENDIF

     C     ZATRNKD0      READE     ZATRNERRD0                             99
     C                   ENDDO

     C                   MOVEA     @EI           OkTrTran

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
      * (Action code can only be  'A')
      *
     C     DDACTN        IFEQ      'A'
     C     @OPSEL        ANDEQ     'U'
     C     DDCYCDOK      ANDEQ     'Y'
     C                   MOVEL     'Y'           @EDTFD
     C                   ELSE
     C                   MOVEL     'N'           @EDTFD
     C                   ENDIF
      *
      * Enable Euro fields ?
     C                   IF        DDSPR2 <> *BLANK
     C                   EVAL      @DERFD = 'Y'
     C                   ELSE
     C                   EVAL      @DERFD = 'N'
     C                   ENDIF

      * Update 'previous' screen
     C                   MOVEL     NewTrScrn     PrvTrScrn
      *
      ** WRITE/READ DISPLAY SCREEN
      *
     C                   CALLB     'SDSPTRDSP'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUT PARAMETERS :
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Transaction (IN SCREEN FORMAT - Primary)
     C                   PARM                    NewTrScrn
      *
      ** BKEURO currency
     C                   PARM                    DDVSEU

      ** Swift currency code (output screen field)
     C                   PARM                    DDSWCY

      ** Dealing Currency (screen field)
     C                   PARM                    DDDLCY

      ** Currency name (output screen field)
     C                   PARM                    DDCYNM

      ** Spot Rate against base currency (when DDSPRT is against BKEURO)
      ** (output screen field)
     C                   PARM                    DDSPR2

      ** Multiply divide indicator tied to DDSPR2
      ** (output screen field)
     C                   PARM                    DDMDI2

      ** Swift currency code tied to DDSPR2 (output screen field)
     C                   PARM                    DDSWC2

      ** Dealing currency tied to DDSPR2 (output screen field)
     C                   PARM                    DDDCY2

      * Fields in error
     C                   PARM                    OKTrTran
      *
      * Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      *
      * Protect action code field
      * Enabled key fields
      * Enabled detail fields
     C                   PARM      'N'           @EACTN            1
     C                   PARM      'N'           @EKYFD            1
     C                   PARM                    @EDTFD            1
      *
      * Display details fields
     C                   PARM      'N'           @HDTFD            1
      *
      * Enabled function keys
      * KJ = delete
      * KG = command key 07 = read previous
      * KH = command key 08 = read next
      * KP = F15 select
     C                   PARM      'N'           @EINKJ            1
     C                   PARM      'N'           @EINKG            1
     C                   PARM      'N'           @EINKH            1
     C                   PARM      'N'           @EINKP            1
      *
      * Display fields related to Euro rates
      *
     C                   PARM                    @DERFD            1

      * OUTPUT PARAMETERS :
      * Function Keys
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKG             1
     C                   PARM      '0'           @INKH             1
     C                   PARM      '0'           @INKJ             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKP             1
      *
      *
      * Reset errors and warnings
      *
     C                   MOVE      *ALL'Y'       OkTrTran
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
      *
      * Retrieve Spot Rate Transaction details
      *
     C                   EXSR      RTVTRN
      *
      * If action code, or Transaction reference are NOT OK
      * Re-output screen with error messages on it
      *
     C     DDACTNOK      IFEQ      'N'
     C     DDCYCDOK      OREQ      'N'
     C                   GOTO      EndVAL@A
     C                   ENDIF

      *----------------------------------------------------------------
      * Prior to validation, initialize error indicators as 'OK'

     C                   MOVE      *ALL'Y'       OkTrTran
     C                   Z-ADD     *ZERO         Idx               3 0

      * Record current number of warnings and reset
     C                   Z-ADD     WIdx          PrvN_Warn         3 0
     C                   Z-ADD     *ZERO         WIdx              3 0

      * Validation always works with the file format returned from the
      * RTV module, i.e. unchanged by any intermediate validation.

     C                   MOVEL     CrTrFilFmt    NwTrFilFmt

      * Validate Spot Rate Transaction details


     C                   CALLB     'SDSPTRVAL'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUTS :
      *
      * Response mode
     C                   PARM                    RespMode
      *
      ** Transaction Primary Details
     C                   PARM                    NewTrScrn
      *
      * OUTPUTS :
      *
      ** Transaction Details OK inds
     C                   PARM                    OkTrTran
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx
      * Valid Transaction layout (DS) from/to caller
     C                   PARM                    NwTrFilFmt

      *
      * If errors returned
     C     Idx           IFNE      0
     C                   GOTO      EndVAL@A
     C                   ENDIF
      *
      *
      * If the screen has changed in the course of the validation
      * or if there are warnings which have not been displayed
      * re-display the screen
      *
     C     NewTrScrn     IFNE      PrvTrScrn
     C     WIdx          ORNE      PrvN_Warn
     C                   GOTO      EndVAL@A
     C                   ENDIF
      *
      * Clear any warning messages
      *
     C                   MOVE      *ALL'Y'       OKTrTran
     C                   MOVE      'U'           @SCRN
      *
     C     EndVAL@A      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RTVTRN - RETRIEVE Transaction
      *****************************************************************
     C     RTVTRN        BEGSR
      *
      * RETRIEVE Transaction
      *
     C                   CALLB     'SDSPTRRTV'
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
      * Front Office Transaction ID
     C                   PARM      @FOTRANSEL    AVFOTRANID
      *
      * (Midas) Transaction item i.e. currency code
     C                   PARM                    DDCYCD
      *
      * OUTPUTS :
      *
      * (Current) Transaction in file format
     C                   PARM                    CrTrFilFmt
      *
      * OK - Action code
     C                   PARM      *BLANK        DDACTNOK
      *
      * OK - Transaction Reference
     C                   PARM      *BLANK        DDCYCDOK
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM      *ZERO         Idx
      *
      * Reset error arrays to avoid duplication of error messages
      *
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
      *
     C     EndRTVTRN     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CVTTRN - Put a Transaction on the screen
      *****************************************************************
     C     CVTTRN        BEGSR
      *
      * Call program to fill screen fields with data
      *
     C                   CALLB     'SDSPTRCVT'
      *
      * INPUTS :
      * Return Code
      * Transaction in file format
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    CrTrFilFmt
      * OUTPUTS
      * Transaction - screen formats
     C                   PARM                    NewTrScrn

      * Currency Name
     C                   PARM                    DDCYNM

      * Dealing currency
     C                   PARM                    DDDLCY

      * SWIFT currency code
     C                   PARM                    DDSWCY

      * BKEURO currency
     C                   PARM                    DDVSEU

      * Spot Rate against base currency (when DDSPRT is against BKEURO)
      * (output screen field)
     C                   PARM                    DDSPR2

      * Multiply divide indicator tied to DDSPR2
      * (output screen field)
     C                   PARM                    DDMDI2

      * Dealing currency tied to DDSPR2 (output screen field)
     C                   PARM                    DDDCY2

      * Swift currency code tied to DDSPR2 (output screen field)
     C                   PARM                    DDSWC2


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
     C                   ENDIF
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
     C                   MOVEL     DDCYCD        AVCYCD
     C                   MOVEL     DDACTN        AVTYLC
      *
      ** Override SDCURRL0                                                                    CAP084
     C                   Z-ADD     32            PCMDLEN                                      CAP084
     C                   CALL      'QCMDEXC'                                                  CAP084
     C                   PARM                    PCMD(3)                                      CAP084
     C                   PARM                    PCMDLEN                                      CAP084
      ** Override SDCURRL1                                                                    200420
     C                   Z-ADD     32            PCMDLEN                                      200420
     C                   CALL      'QCMDEXC'                                                  200420
     C                   PARM                    PCMD(1)                                      200420
     C                   PARM                    PCMDLEN                                      200420
      *
      * SPOT RATE TRANSACTION DETAILS UPDATES
      *
     C                   MOVEL     *BLANK        @RTCD
     C                   CALLB     'SDSPTRUPD'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    NwTrFilFmt
     C/COPY OFCPYSRCZ,CFT147_026                                                              CFT147
      *                                                                                       200420
      ** Delete override of SDCURRL0                                                          CAP084
     C                   Z-ADD     21            PCMDLEN                                      CAP084
     C                   CALL      'QCMDEXC'                                                  CAP084
     C                   PARM                    PCMD(4)                                      CAP084
     C                   PARM                    PCMDLEN                                      CAP084
      ** Delete override of SDCURRL1                                                          200420
     C                   Z-ADD     21            PCMDLEN                                      200420
     C                   CALL      'QCMDEXC'                                                  200420
     C                   PARM                    PCMD(2)                                      200420
     C                   PARM                    PCMDLEN                                      200420
      *
      * If there were any errors in the update functions, rollback any
      * updates and end this program.
      * Otherwise delete the invalid transaction actioned & commit the updates
      *
     C     @RTCD         IFNE      *BLANK
     C     @RTCD         ANDNE     '*RECUPD'                                    6
     C                   ROLBK
     C                   EXSR      *PSSR
     C                   ELSE
     C     ZATRNKD0      CHAIN     SDISPTRD0                          99
     C  N99              DELETE    SDISPTRD0
                                                                                              CSC011
      ** Delete invalid record from the log file                                              CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y' AND                                           CSC011
     C                             S1SUPP = LIBR                                              CSC011
                                                                                              CSC011
     C                   EVAL      KMsgType = 'SDSPTR'                                        CSC011
     C                   EVAL      KFrntOffID = @FOTRANSEL                                    CSC011
     C                   EVAL      KTimeStamp = @TMESTPSEL                                    CSC011
                                                                                              CSC011
     C     KAPLOG        CHAIN     APILOGL0                           99                      CSC011
                                                                                              CSC011
     C                   IF        *IN99 = *OFF                                               CSC011
     C                   DELETE    APILOGL0                                                   CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   COMMIT
     C                   ENDIF
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
     C                   ENDIF
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

     C                   IF        RepSPTR = 'Y'

     C                   RESET                   ReturnCode
     C                   CLEAR                   IncData
     C                   CLEAR                   CurData
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

     C                   ENDIF


     C                   ENDSR
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
     C                   MOVEL     'SDSPTRRPR'   DBPGM
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
     C                   PARM      *BLANKS       PRTCD                                        CSC011
     C                   PARM      '*VERIFY'     POPTN                                        CSC011
     C                   PARM      'CSC011'      PSARD                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
     C                   IF        PRTCD = *Blanks                                            CSC011
                                                                                              CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
                                                                                              CSC011
     C                   OPEN      APILOGL0                                                   CSC011
                                                                                              CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IN        SDSTAT                                                     CSC011
                                                                                              CSC011
     C                   ELSE                                                                 CSC011
                                                                                              CSC011
      ** Database error                                                                       CSC011
                                                                                              CSC011
     C                   IF        PRTCD <> '*NRF'                                            CSC011
     C     *LOCK         IN        LDA                                                        CSC011
     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBASE = 902                                                CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
      *
      * Key Lists
      *
     C     ZATRNKD0      KLIST
     C                   KFLD                    @FOTRANSEL
     C                   KFLD                    @TMESTPSEL
     C     ZATRNKX0      KLIST
     C                   KFLD                    @TMESTPSEL
     C                   KFLD                    @FOTRANSEL
                                                                                              CSC011
     C     KAPLOG        KLIST                                                                CSC011
     C                   KFLD                    KMsgType                                     CSC011
     C                   KFLD                    KFrntOffID                                   CSC011
     C                   KFLD                    KTimeStamp                                   CSC011


      ** Get the field number for the action code field; the
      ** screen fields start from that number.  Subtract one from it to
      ** give the value to subtract from each field's number.
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM                    ReturnCode
     C                   PARM                    FormatA
     C                   PARM                    Field1
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
      /COPY WNCPYSRC,SDSPTRR014

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
(c) Finastra International Limited 2001
** PCMD                                                                                       200420
OVRDBF FILE(SDCURRL1) SHARE(*NO)                                                              200420
DLTOVR FILE(SDCURRL1)                                                                         200420
OVRDBF FILE(SDCURRL0) SHARE(*NO)                                                              CAP084
DLTOVR FILE(SDCURRL0)                                                                         CAP084
