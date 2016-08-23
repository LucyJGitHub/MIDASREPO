     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Loan amendments read')                        *
      *****************************************************************
      *                                                               *
      *  Midas - Module name   ILE Module                             *
      *                                                               *
      *  LELOAMRED - Loan amendments read                             *
      *                                                               *
      *  Function:  This module reads forwards and backwards          *
      *             through the loan amendments file                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. CLE134             Date 01Aug12               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE036             Date 22Sep03               *
      *                 CLE034             Date 05May03               *
      *                 CLE031             Date 03Feb03               *
      *                 CAP086             Date 08Jun05               *
      *                 CAP075  *CREATE    Date 21Aug02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE106 - Syndications Manager. (Recompiled)                  *
      *  CLE036 - Lending Enhancements for Nordea Phase 1 Priority 2  *
      *           Allow specific base rates  (Recompile)              *
      *  CLE034 - Lending Enhancements Phase 1 Priority 1A            *
      *           (Recompile)                                         *
      *  CLE031 - Lending Enhancements (Recompile)                    *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it (Recompile)                              *
      *  CAP075 - Conversion of LE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FLOAMS     IF   E           K DISK    INFSR(*PSSR)
      ***  Midas LE Loan Amendments File
     F                                     INCLUDE(LOAMSDKF)
      *
     FCLOAN     IF   E           K DISK    INFSR(*PSSR)
      ***  Midas LE Loans Detail Files
     F                                     IGNORE(CLOANHHF)
     F                                     IGNORE(CLOANZ1F)
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **----------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **----------------------------------------------------------------
 
      **----------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **----------------------------------------------------------------
 
      **----------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **----------------------------------------------------------------
 
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
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D wLoanAlpha      S              1A                                                      CLE148
     D PLNRF           S              6A                                                      CLE148
     D PValid          S              6A                                                      CLE148
     D PChkDigit       S              1A                                                      CLE148
     D PData           S              2A                                                      CLE148
      *                                                                                       CLE148
     D RTNCDE          S              7A                                                      CLE148
     D SVALK1          S             20A                                                      CLE148
     D SVAL1           S            200A                                                      CLE148
     D SVALK2          S             20A                                                      CLE148
     D SVAL2           S            200A                                                      CLE148
     D SVALK3          S             20A                                                      CLE148
     D SVAL3           S            200A                                                      CLE148
     D SVALK4          S             20A                                                      CLE148
     D SVAL4           S            200A                                                      CLE148
     D SVALK5          S             20A                                                      CLE148
     D SVAL5           S            200A                                                      CLE148
     D SVALK6          S             20A                                                      CLE148
     D SVAL6           S            200A                                                      CLE148
     D SVALK7          S             20A                                                      CLE148
     D SVAL7           S            200A                                                      CLE148
     D SVALK8          S             20A                                                      CLE148
     D SVAL8           S            200A                                                      CLE148
     D SVALK9          S             20A                                                      CLE148
     D SVAL9           S            200A                                                      CLE148
     D SVALK0          S             20A                                                      CLE148
     D SVAL10          S            200A                                                      CLE148
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** ¦ Note that this module uses logic-cycle processing; it will ¦
      ** ¦ repeat the main processing until 'return' is specified.    ¦
      ** ¦ It will also only execute the *INZSR once, on activation,  ¦
      ** ¦ not every time it is called.                               ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      * Initialisation
     C                   EXSR      Reset
      *
      * Check for user authority to browse if not multi-branching
     C                   IF        BGMBIN = 'N'
     C                   EXSR      CHAUTN
     C                   ENDIF
      *
      * Validate key details
     C                   EXSR      VALKEY
      *
      * Read forwards
     C                   IF        @RDFWD = 'Y'
     C                   EXSR      RDFWD
     C                   ELSE
      *
      * Read backwards
     C                   IF        @RDBCK = 'Y'
     C                   EXSR      RDBCK
     C                   ENDIF
     C                   ENDIF
      *
      * Return
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      ********************************************************************
      * Reset - Clear outputs
      ********************************************************************
     C     Reset         BEGSR
      *
      * Initialise outputs
     C                   EVAL      @LOAN  = *blanks
     C                   EVAL      @VDAT  = *blanks
     C                   EVAL      @LASN  = *blanks
     C**********         EVAL      LNRF = *ZEROS                                              CLE148
     C                   EVAL      LNRF = *BLANKS                                             CLE148
     C                   EVAL      VDAT = *ZEROS
     C                   EVAL      LASN = *ZEROS
      *
      * Initialise key lists
     C                   MOVEL     DDLOAN        WKLNR
 
      *  The value date key is initialised after the convert to a dayno.
     C                   MOVEL     DDSEQN        WKLSN
     C                   EVAL      WRCDT  = 'A'
 
     C                   ENDSR
      ********************************************************************
      /EJECT
      *****************************************************************
      * RDFWD - Read forwards
      *****************************************************************
     C     RDFWD         BEGSR
 
     C                   MOVE      'N'           @Valid            1
      *
      * Position to current record on file
     C     KLAKEY        SETGT     LOAMS
      *
      * Read until end of file or a valid record is found or an error
     C                   DOU       *IN99 = '1' OR
     C                             @VALID = 'Y'
      *
      * Read next transaction
     C                   READ      LOAMS                                  99
     C                   MOVE      'Y'           @Valid
      *
      ** Check for valid record - valid amendment type
     C                   IF        AMTP <> 'PI' and
     C                             AMTP <> 'SC' and
     C                             AMTP <> 'BC' and
     C                             AMTP <> 'SA' and
     C                             AMTP <> 'LS'
     C                   MOVE      'N'           @Valid
     C                   EndIf
      *
     C                   ENDDO
      *
      * If end of file was encountered, report this fact
     C                   IF        *IN99 = '1'
     C                   EVAL      RetCodeIn = 'LEV9001'
      *
      * Else, return the key read
     C                   ELSE
     C                   MOVEL     LNRF          @LOAN
     C                   MOVEL     LASN          @LASN
 
      *** Convert the dayno to date format first
     C     VDAT          IFNE      *ZERO
     C                   CALLB     'ZDATE2'
     C                   PARM      VDAT          ZDAYNO            5 0
     C                   PARM      BJDFIN        DateFmt           1
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
     C                   MOVEL     ZDATE         @VDAT
     C                   ENDIF
 
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDBCK - Read backwards
      *****************************************************************
     C     RDBCK         BEGSR
      *
     C                   MOVE      'N'           @Valid
 
      * Position to current record on file
     C     KLAKEY        SETLL     LOAMS
      *
      * Read until end of file or a valid record is found or an error
     C                   DOU       *IN99 = '1' OR
     C                             @VALID = 'Y'
      *
      * Read previous transaction
     C                   READP     LOAMS                                  99
     C                   MOVE      'Y'           @Valid
      *
      ** Check for valid record - valid amendment type
     C                   IF        AMTP <> 'PI' and
     C                             AMTP <> 'SC' and
     C                             AMTP <> 'BC' and
     C                             AMTP <> 'SA' and
     C                             AMTP <> 'LS'
     C                   MOVE      'N'           @Valid
     C                   EndIf
      *
     C                   ENDDO
      *
      * If start of file was encountered, report this fact
     C                   IF        *IN99 = '1'
     C                   EVAL      RetCodeIn = 'LEV9002'
      *
      * Else, return the transaction reference read
     C                   ELSE
      *
     C                   MOVEL     LNRF          @LOAN
     C                   MOVEL     LASN          @LASN
 
      *** Convert the dayno to date format first
     C     VDAT          IFNE      *ZERO
     C                   CALLB     'ZDATE2'
     C                   PARM      VDAT          ZDAYNO            5 0
     C                   PARM      BJDFIN        DateFmt
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
     C                   MOVEL     ZDATE         @VDAT             6
     C                   ENDIF
 
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CHAUTN - Check for user authority if not multi-branching
      *****************************************************************
     C     CHAUTN        BEGSR
      *
     C                   CALL      'ZVACTU'
     C                   PARM      'E'           ZACTN             1
     C                   PARM                    @@ERR             1 0
      *
      * Return Error Message
     C                   IF        @@ERR = 1
     C                   EVAL      RetCodeIn  =  'LEV9003'
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALKEY - Validate key details
      *****************************************************************
     C     VALKEY        BEGSR
      *                                                                                       CLE148
     C                   IF        wLoanAlpha = 'N'                                           CLE148
      *
      ** Validate loan number
     C                   EVAL      ZFIELD = DDLOAN
     C                   CALLB     'ZALIGN'
     C                   PARM      *BLANK        ZALIGNok          1
     C                   PARM                    ZFIELD           16
     C                   PARM      0             ZADEC             1 0
     C                   PARM      6             ZADIG             2 0
      *
      ** Entry is not a valid number
 B1  C     ZALIGNok      IFEQ      'N'
     C                   MOVEL     'LEA0025'     RetCodeIn
     C                   GOTO      EVAL
 E1  C                   ENDIF
      *                                                                                       CLE148
     C                   ELSE                                                                 CLE148
      *                                                                                       CLE148
      ** Call program 'LELOANISO' to validate the number.                                     CLE148
      *                                                                                       CLE148
     C                   EVAL      PLNRF = DDLOAN                                             CLE148
     C                   EVAL      PValid = *BLANKS                                           CLE148
     C                   EVAL      PChkDigit = *BLANK                                         CLE148
     C                   EVAL      PData = *BLANKS                                            CLE148
      *                                                                                       CLE148
     C                   CALL(E)   'LELOANISO'   P_LELOANISO                                  CLE148
      *                                                                                       CLE148
     C     PValid        IFNE      *BLANKS                                                    CLE148
     C                   MOVEL     '5045549'     RetCodeIn                                    CLE148
     C                   ENDIF                                                                CLE148
      *                                                                                       CLE148
     C                   ENDIF                                                                CLE148
      *
      ** Number must be greater than zero
     C*****WKLNR         IFLT      0                                                          CLE148
     C     WKLNR         IFLT      *BLANKS                                                    CLE148
     C                   MOVEL     'LEA0030'     RetCodeIn
     C                   GOTO      EVAL
 E1  C                   ENDIF
      *
      ** Loan must exist in loans file
      *
      *
      ** Validate Value date
     C                   IF        DDVDAT <> *BLANKS
     C                   MOVEL     DDVDAT        NUM7              7 0
     C                   MOVEL     NUM7          ALF6              6
      *
     C                   CALLB     'ZDATE1'
     C                   PARM      ALF6          ZDATEA            6
     C                   PARM                    ZDAYNO            5 0
     C                   PARM      BJDFIN        DateFmt
     C                   PARM                    ErrorFlag         1
      *
 B1  C                   IF        ErrorFlag = 'Y'
     C                   MOVEL     'LEA0105'     RetCodeIn
     C                   GOTO      EVAL
     C                   ELSE
     C                   MOVE      ZDAYNO        WKVDT
 E1  C                   ENDIF
     C                   ENDIF
 
      ** Check if sequence no. is valid
     C     WKLSN         IFLT      0
     C                   MOVEL     'LEA0031'     RetCodeIn
 E2  C                   ENDIF
      *
     C     EVAL          ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initialisation
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      * Input Parameters :
      * Return Code
      * Action Code
      * Read Forwards
      * Read Backwards
     C                   PARM                    RetCodeIn
     C                   PARM                    DDACTN            1
     C                   PARM                    @RDFWD            1
     C                   PARM                    @RDBCK            1
      *
      * Loan number / value date / sequence
     C                   PARM                    DDLOAN            6
     C                   PARM                    DDVDAT            6
     C                   PARM                    DDSEQN            3
 
      * Multi-branching/date format indicators
     C                   PARM                    BGMBIN            1
     C                   PARM                    BJDFIN            1
 
      * Output Parameters :
 
      * Loan number / value date / sequence / amendment type read
     C                   PARM                    @LOAN             6
     C                   PARM                    @VDAT             6
     C                   PARM                    @LASN             3
      *
      ** Initialise program name
     C                   EVAL      DBPGM = 'LELOAMRED'
      *                                                                                       CLE148
      ** Check System Value: LoanAlphaAllow                                                   CLE148
      *                                                                                       CLE148
     C                   EVAL      SVALK1 = 'LoanAlphaAllow'                                  CLE148
      *                                                                                       CLE148
     C                   CALL      'AOSVALR0'                                                 CLE148
     C                   PARM                    RTNCDE                                       CLE148
     C                   PARM                    SVALK1                                       CLE148
     C                   PARM                    SVAL1                                        CLE148
     C                   PARM                    SVALK2                                       CLE148
     C                   PARM                    SVAL2                                        CLE148
     C                   PARM                    SVALK3                                       CLE148
     C                   PARM                    SVAL3                                        CLE148
     C                   PARM                    SVALK4                                       CLE148
     C                   PARM                    SVAL4                                        CLE148
     C                   PARM                    SVALK5                                       CLE148
     C                   PARM                    SVAL5                                        CLE148
     C                   PARM                    SVALK6                                       CLE148
     C                   PARM                    SVAL6                                        CLE148
     C                   PARM                    SVALK7                                       CLE148
     C                   PARM                    SVAL7                                        CLE148
     C                   PARM                    SVALK8                                       CLE148
     C                   PARM                    SVAL8                                        CLE148
     C                   PARM                    SVALK9                                       CLE148
     C                   PARM                    SVAL9                                        CLE148
     C                   PARM                    SVALK0                                       CLE148
     C                   PARM                    SVAL10                                       CLE148
      *                                                                                       CLE148
      ** If the system value is not found then issue a database error                         CLE148
      *                                                                                       CLE148
     C                   IF        RTNCDE <> *BLANKS                                          CLE148
     C                   EVAL      DBFile = 'SDSVALPD'                                        CLE148
     C                   EVAL      DBKey  = '*FIRST  '                                        CLE148
     C                   EVAL      DBase  = 3                                                 CLE148
     C                   EXSR      *PSSR                                                      CLE148
      *                                                                                       CLE148
     C                   ELSE                                                                 CLE148
     C                   MOVEL     SVAL1         wLoanAlpha                                   CLE148
     C                   ENDIF                                                                CLE148
      *                                                                                       CLE148
     C     P_LELOANISO   PLIST                                                                CLE148
      *                                                                                       CLE148
      ** Loan Number (Input)                                                                  CLE148
      *                                                                                       CLE148
     C                   PARM                    PLNRF                                        CLE148
      *                                                                                       CLE148
      ** Validity Flags (Output)                                                              CLE148
      *                                                                                       CLE148
     C                   PARM                    PValid                                       CLE148
      *                                                                                       CLE148
      ** Check Digit (Output)                                                                 CLE148
      *                                                                                       CLE148
     C                   PARM                    PChkDigit                                    CLE148
     C                   PARM                    PData                                        CLE148
      *
      ***  Key Lists
     C     KLKEY         KLIST
     C**********         KFLD                    WKLNR             6 0                        CLE148
     C                   KFLD                    WKLNR             6                          CLE148
     C                   KFLD                    WRCDT             1
      *
     C     KLAKEY        KLIST
     C**********         KFLD                    WKLNR             6 0                        CLE148
     C                   KFLD                    WKLNR             6                          CLE148
     C                   KFLD                    WKVDT             5 0
     C                   KFLD                    WKLSN             3 0
      *
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
