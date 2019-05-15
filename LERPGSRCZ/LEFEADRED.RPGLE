     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Fee adjustment read')                         *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LEFEADRED - Fee Adjustment details read                      *
      *                                                               *
      *  Function:  This module reads forwards and backwards          *
      *             through the Fee Adjustment details file           *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CAP086             Date 08Jun05               *
      *                 CSW037A            Date 02May05               *
      *                 BUG6198            Date 04Apr05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CAP084  *CREATE    Date 06Aug03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAP086 - Introduce Auto Autorisation to the API's            *
      *           without it (Recompile)                              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG6198- Cannot save new Details for CUSD (Recompile)        *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CAP084 - Synchronous calling of APIs                         *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Fee Adjustments - keyed by transaction reference
     FLEFEEAL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LEFEEADF:FEADFmt)
 
      ** Fee Adjustments - keyed by Front Office Id
     FLEFEEAL6  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LEFEEADF:FoIdFmt)
 
     FSDCUSTL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(@BBREBF:CUSNUM)
      * Customer details file
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **-----------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
      ** The following /COPY includes the standard API declares:
     D/COPY ZACPYSRC,STDDECLARE
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **-----------------------------------------------------------------------
 
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
      ** External DS for bank details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, short data structure
 
 
      ** DS to create key parameter for LEFEEAL2
     D                 DS
     D @@FACL                  1      5  0
     D  @@FACT                 1      3
     D  @@FACN                 4      5
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *                                                                                       CLE148
      ** Parameters for calling LELOANISO (Validate Loan Number)                              CLE148
      *                                                                                       CLE148
     D PLNRF           S              6A                                                      CLE148
     D PValid          S              6A                                                      CLE148
     D PChkDigit       S              1A                                                      CLE148
     D PData           S              2A                                                      CLE148
      *                                                                                       CLE148
     D wLoanAlpha      S              1A                                                      CLE148
     D @ERRDTA         S              2A                                                      CLE148
 
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
      *
      * Initialise outputs
     C                   EVAL      @ERRMS = *BLANK
     C                   EVAL      @CNRED = *BLANK
     C                   EVAL      @FTRED = *BLANK
     C                   EVAL      @FNRED = *BLANK
     C                   EVAL      @LNRED = *BLANK
     C                   EVAL      @SQRED = *BLANK
      *
      * Check for user authority to browse if not multi-branching
     C                   IF        BJSBRC <> *BLANK
     C                   EXSR      CHAUTN
     C                   ENDIF
      *
      * Validate transaction reference
     C                   EXSR      VALTRN
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
      *
      * If no error, return the transaction reference read
     C                   If        @ERRMS = *BLANK
     C                   MOVEL     FACNUM        @CNRED
     C                   MOVEL     FAFACL        @FTRED
     C                   MOVE      FAFACL        @FNRED
     C                   MOVEL     FALOAN        @LNRED
     C                   MOVEL     FAFSEQ        @SQRED
     C                   MOVEL     FRNT          @FORED
     C                   ENDIF
     C                   ENDIF
      *
      * Return
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial processing
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      * Input parameters :
      *
      * Mode = '*FRONT' (Front Office Transaction Interface)
      * Mode = '      ' (Not Front Office Transaction Interface)
     C                   PARM                    ModeofOp          6
 
      * Return code
     C                   PARM                    RetCodeIn
 
      * Action code
     C                   PARM                    DDACTN            1
 
      * Fee Adjustment reference:
      * Customer, facility, loan, sequence
     C                   PARM                    DDCNUM            6
     C                   PARM                    DDFACT            3
     C                   PARM                    DDFACN            2
     C                   PARM                    DDLOAN            6
     C                   PARM                    DDSEQN            2
      *
      ***  Front Office Transaction ID
     C                   PARM                    DDFRNT           20
 
      * Read forwards
     C                   PARM                    @RDFWD            1
 
      * Read backwards
     C                   PARM                    @RDBCK            1
 
      * Output Parameters :
      * Error meassage
     C                   PARM                    wLoanAlpha                                   CLE148
     C                   PARM                    @ERRMS            7
     C                   PARM                    @ERRDTA                                      CLE148
 
      * Fee Adjustment read:
      * Customer, facility, loan, sequence
     C                   PARM                    @CNRED            6
     C                   PARM                    @FTRED            3
     C                   PARM                    @FNRED            2
     C                   PARM                    @LNRED            6
     C                   PARM                    @SQRED            2
      *
      * Front Office Transaction ID read
     C                   PARM                    @FORED           20
      *
      * Initialise program name
     C                   EVAL      DBPGM = 'LEFEADRED'
      *
      * Access bank details
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * Database error
     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 900
     C                   EVAL      DBKEY = @OPTN
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      *  Keylists
     C     @@FKey        KLIST
     C**********         KFLD                    @@CNUM            6 0                        CSD027
     C                   KFLD                    @@CNUM            6                          CSD027
     C                   KFLD                    @@FACL            5 0
     C**********         KFLD                    @@LOAN            6 0                        CLE148
     C                   KFLD                    @@LOAN            6                          CLE148
     C                   KFLD                    @@FSEQ            2 0
     C                   KFLD                    @@VDAT            5 0
      *                                                                                       CLE148
      ** Parameter list for calling LELOANISO                                                 CLE148
      *                                                                                       CLE148
     C     P_LELOANISO   PLIST                                                                CLE148
      ** Loan Number (Input)                                                                  CLE148
     C                   PARM                    PLNRF                                        CLE148
      ** Validity Flags (Output)                                                              CLE148
     C                   PARM                    PValid                                       CLE148
      ** Check Digit (Output)                                                                 CLE148
     C                   PARM                    PChkDigit                                    CLE148
     C                   PARM                    PData                                        CLE148
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALTRN - Validate Fee Adjustment pointer
      *****************************************************************
     C     VALTRN        BEGSR
      *
      * Check that the customer number is numeric or blank.
     C**********         TESTN                   DDCNUM               98                      CSD027
     C**********         MOVE      DDCNUM        @@TEST            1                          CSD027
     C**********         TESTZ                   @@TEST                   99                  CSD027
     C**********         IF        DDCNUM = *BLANKS OR                                        CSD027
     C**********                   *IN98 = '1' AND                                            CSD027
     C**********                   *IN99 = '1'                                                CSD027
     C                   MOVE      DDCNUM        @@CNUM
      *
      * Return error message
     C**********         ELSE                                                                 CSD027
     C**********         EVAL      @ERRMS = 'LEV9004'                                         CSD027
     C**********         RETURN                                                               CSD027
     C**********         ENDIF                                                                CSD027
      *
      * Check that the facility type is numeric or blank.
     C                   TESTN                   DDFACT               98
     C                   MOVE      DDFACT        @@TEST            1
     C                   TESTZ                   @@TEST                   99
     C                   IF        DDFACT = *BLANKS OR
     C                             *IN98 = '1' AND
     C                             *IN99 = '1'
     C                   MOVE      DDFACT        @@FACT
      *
      * Return error message
     C                   ELSE
     C                   EVAL      @ERRMS = 'LEU0015'
     C                   RETURN
     C                   ENDIF
      *
      * Check that the facility number is numeric or blank.
     C                   TESTN                   DDFACN               98
     C                   MOVE      DDFACN        @@TEST            1
     C                   TESTZ                   @@TEST                   99
     C                   IF        DDFACN = *BLANKS OR
     C                             *IN98 = '1' AND
     C                             *IN99 = '1'
     C                   MOVE      DDFACN        @@FACN
      *
      * Return error message
     C                   ELSE
     C                   EVAL      @ERRMS = 'LEU0015'
     C                   RETURN
     C                   ENDIF
      *
      * Check that the loan number is numeric or blank.
     C                   TESTN                   DDLOAN               98
     C                   MOVE      DDLOAN        @@TEST            1
     C                   TESTZ                   @@TEST                   99
     C**********         IF        DDLOAN = *BLANKS OR                                        CLE148
     C**********                   *IN98 = '1' AND                                            CLE148
     C**********                   *IN99 = '1'                                                CLE148
     C**********         MOVE      DDLOAN        @@LOAN                                       CLE148
      *
      **Return*error*message*******************************************                       CLE148
     C**********         ELSE                                                                 CLE148
     C**********         EVAL      @ERRMS = 'LEL0601'                                         CLE148
     C**********         RETURN                                                               CLE148
     C**********         ENDIF                                                                CLE148
                                                                                              CLE148
     C                   IF        wLoanAlpha = 'Y'                                           CLE148
      *                                                                                       CLE148
      ** Call program 'LELOANISO' to validate the number.                                     CLE148
      *                                                                                       CLE148
     C                   EVAL      PLNRF = DDLOAN                                             CLE148
     C                   EVAL      PValid = *BLANKS                                           CLE148
     C                   EVAL      PChkDigit = *BLANK                                         CLE148
     C                   EVAL      PData = *BLANKS                                            CLE148
                                                                                              CLE148
     C                   Call(E)   'LELOANISO'   P_LELOANISO                                  CLE148
     C                   ENDIF                                                                CLE148
                                                                                              CLE148
     C                   IF        DDLOAN = *BLANK                                            CLE148
     C                              OR (wLoanAlpha = 'N' AND *IN98 = *ON                      CLE148
     C                              AND *IN99 = *ON) OR (wLoanAlpha = 'Y'                     CLE148
     C                              AND PValid = *BLANKS)                                     CLE148
     C                   MOVEL     DDLOAN        @@LOAN                                       CLE148
     C                   ELSE                                                                 CLE148
      *                                                                                       CLE148
     C                   IF        wLoanAlpha = 'N'                                           CLE148
     C                   MOVEL     '5045550'     @ERRMS                                       CLE148
     C                   ELSE                                                                 CLE148
      *                                                                                       CLE148
     C                   MOVEL     '5045548'     @ERRMS                                       CLE148
     C                   MOVEL     PData         @ERRDTA                                      CLE148
     C                   ENDIF                                                                CLE148
                                                                                              CLE148
     C                   RETURN                                                               CLE148
     C                   ENDIF                                                                CLE148
      *
      * Check that the sequence number is numeric or blank.
     C                   TESTN                   DDSEQN               98
     C                   MOVE      DDSEQN        @@TEST            1
     C                   TESTZ                   @@TEST                   99
     C                   IF        DDSEQN = *BLANKS OR
     C                             *IN98 = '1' AND
     C                             *IN99 = '1'
     C                   MOVE      DDSEQN        @@FSEQ
      *
      * Return error message
     C                   ELSE
     C                   EVAL      @ERRMS = 'LES0609'
     C                   RETURN
     C                   ENDIF
      *
      * Front office ID
     C                   MOVE      DDFRNT        @@FRNT           20
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDFWD - Read forwards through fee Adjustment file
      *****************************************************************
     C     RDFWD         BEGSR
      *
      *  If the Mode is 'Front office transaction interface'
      *  position with front office ID on file
     C                   IF        ModeofOp = '*FRONT'
     C     @@FRNT        SETGT     FoIdFmt
     C                   ELSE
     C     @@FKEY        SETGT     FEADFmt
     C                   ENDIF
      *
      * Read until end of file or a valid record is found or an error
     C                   DOU       *IN99 = '1' or
     C                             FARECI <> '*' and
     C                             @@ERR = *Zero
      *
      * Read next transaction
     C                   IF        ModeofOp = '*FRONT'
     C                   READ      FoIdFmt                                99
     C                   ELSE
     C                   READ      FEADFmt                                99
     C                   EndIf
 
      * If multi-branching, check if authorised to look at loan (based
      * on branch) but if invalid continue searching for valid branch
     C     BJSBRC        IFEQ      *BLANK
     C                   CALL      'ZVACTBU'
     C                   PARM      'E'           ZACTN
     C                   PARM                    FABRCA
     C                   PARM                    @@ERR
     C                   ENDIF
      *
     C                   ENDDO
      *
      * If end of file was encountered, report this fact
     C                   IF        *IN99 = '1'
     C                   IF        DDCNUM = *BLANKS and
     C                             DDFRNT = *BLANKS
     C                   EVAL      @ERRMS = 'LEV9001'
     C                   ELSE
     C                   EVAL      @ERRMS = 'LEV9001'
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDBCK - Read backwards through fee Adjustment file
      *****************************************************************
     C     RDBCK         BEGSR
      *
      * If the Mode is 'Front office transaction interface'
      * position with front office ID on file
     C                   If        ModeofOp = '*FRONT'
     C     @@FRNT        SETLL     FoIdFmt
     C                   ELSE
     C     @@FKEY        SETLL     FEADFmt
     C                   EndIf
      *
      * Read until end of file or a valid record is found or an error
     C                   DOU       *IN99 = '1' or
     C                             FARECI <> '*' and
     C                             @@ERR = *Zero
      *
      * Read previous transaction
     C                   IF        ModeofOp = '*FRONT'
     C                   READP     FoIdFmt                                99
     C                   ELSE
     C                   READP     FEADFmt                                99
     C                   EndIf
 
      * If multi-branching, check if authorised to look at loan (based
      * on branch) but if invalid continue searching for valid branch
     C     BJSBRC        IFEQ      *BLANK
     C                   CALL      'ZVACTBU'
     C                   PARM      'E'           ZACTN
     C                   PARM                    FABRCA
     C                   PARM                    @@ERR
     C                   ENDIF
      *
     C                   ENDDO
      *
      * If start of file was encountered, report this fact
     C                   IF        *IN99 = '1'
     C                   EVAL      @ERRMS = 'LEV9002'
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
      * Return error message
     C                   IF        @@ERR = 1
     C                   EVAL      @ERRMS = 'FXM0292'
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, excluding a bound call to the DBERRCTL module.
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILENE
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2003
