     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Collateral details read')                     *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLCOLLRED - GL Collateral details read                       *
      *                                                               *
      *  Function:  This module reads forwards and backwards          *
      *             through the Collateral Details File               *
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
      *                 CSW037A            Date 02May05               *
      *                 BUG6198            Date 04Apr05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CAP084  *CREATE    Date 08Sep03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG6198- Cannot save new Details for CUSD (Recompile)        *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CAP084 - Conversion of Mm inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FGLCOLLL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLCOLLD0:TRNFMAT)
      * Transaction Details File - by transaction Number
 
     FSDCUSTL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(@BBREBF:CUSNUM)
      * Customer Details File
 
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
      ** The following /COPY includes the MM standard declares:
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
      ** EXTERNAL DS FOR BANK DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
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
      *
     C                   EVAL      @ERRMS = *BLANK
     C                   EVAL      @TRRED = *BLANK
     C                   EVAL      @FTRED = *BLANK
      *
      * Check for user authority to browse if not multi-branching
      *
     C                   IF        BJSBRC <> *BLANK
     C                   EXSR      CHAUTN
     C                   ENDIF
      *
      * Validate Transaction Reference (for pointer)
      *
     C                   EXSR      VALTRN
      *
      * Read forwards
      *
     C                   IF        @RDFWD = 'Y'
     C                   EXSR      RDFWD
     C                   ELSE
      *
      * Read backwards
      *
     C                   IF        @RDBCK = 'Y'
     C                   EXSR      RDBCK
     C                   ENDIF
     C                   ENDIF
      *
      * Return
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDFWD - READ FORWARDS THROUGH TRANSACTIONS DETAILS FILE
      *****************************************************************
     C     RDFWD         BEGSR
      *
      * Position to current record on file
      *
     C     @@TRNN        SETGT     TRNFMAT
      *
      * Read until end of file or a valid record is found or an error
      *
     C                   DOU       *IN99 = '1' OR
     C                             CDCREF <> *BLANKS AND
     C                             @@ERR = *ZERO AND
     C                             CDTYLC <> 'D'
      *
      * Read next transaction
     C                   READ      TRNFMAT                                99
      *
     C                   ENDDO
      *
      * If end of file was encountered, report this fact
      *
     C                   IF        *IN99 = '1'
     C                   EVAL      @ERRMS = 'MMM1002'
      *
      * Else, return the transaction reference read
      *
     C                   ELSE
     C                   MOVE      CDCREF        @TRRED
     C                   MOVE      CDFRNT        @FTRED
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDBCK - READ BACKWARDS THROUGH TRANSACTIONS DETAILS FILE
      *****************************************************************
     C     RDBCK         BEGSR
      *
      * Position to current record on file
      *
     C     @@TRNN        SETLL     TRNFMAT
      *
      * Read until end of file or a valid record is found or an error
      *
     C                   DOU       *IN99 = '1' OR
     C                             CDCREF <> *BLANKS AND
     C                             @@ERR = *ZERO AND
     C                             CDTYLC <> 'D'
      *
      * Read previous transaction
      *
     C                   READP     TRNFMAT                                99
      *
     C                   ENDDO
      *
      * If start of file was encountered, report this fact
      *
     C                   IF        *IN99 = '1'
     C                   EVAL      @ERRMS = 'MMM1003'
      *
      * Else, return the transaction reference read
      *
     C                   ELSE
      *
     C                   EVAL      @TRRED = CDCREF
     C                   EVAL      @FTRED = CDFRNT
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CHAUTN - CHECK FOR USER AUTHORITY IF NOT MULTI-BRANCHING
      *****************************************************************
     C     CHAUTN        BEGSR
      *
     C                   CALL      'ZVACTU'
     C                   PARM      'E'           ZACTN             1
     C                   PARM                    @@ERR             1 0
      *
      * Return Error Message
      *
     C                   IF        @@ERR = 1
     C                   EVAL      @ERRMS = 'FXM0292'
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALTRN - VALIDATE TRANSACTION REFERENCE POINTER
      *****************************************************************
     C     VALTRN        BEGSR
      *
      **  Validate that the transaction reference is numeric or blank.
      *
     C                   TESTN                   DDTRNN               98
     C                   MOVE      DDTRNN        @@TEST            1
     C                   TESTZ                   @@TEST                   99
     C                   IF        DDTRNN = *BLANKS OR
     C                             *IN98 = '1' AND
     C                             *IN99 = '1'
     C                   MOVE      DDTRNN        @@TRNN           10
     C                   MOVE      DDFOID        @@FOID           20
      *
      ** Return error message
      *
     C                   ELSE
     C                   EVAL      @ERRMS = 'MMM0162'
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      *
     C     *ENTRY        PLIST
      *
      * Input Parameters :
      * Return Code
      * Action Code
      * Transaction reference pointer
      * Read Forwards
      * Read Backwards
     C                   PARM                    RetCodeIn
     C                   PARM                    DDACTN            1
     C                   PARM                    DDTRNN           10
     C                   PARM                    DDFOID           20
     C                   PARM                    @RDFWD            1
     C                   PARM                    @RDBCK            1
      * Output Parameters :
      * Error meassage
      * Transaction read
     C                   PARM                    @ERRMS            7
     C                   PARM                    @TRRED           10
     C                   PARM                    @FTRED           20
      *
      ** Initialise program name
      *
     C                   EVAL      DBPGM = 'GLCOLLRED'
      *
      ** Access Bamk Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * Database Error
      *
     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 900
     C                   EVAL      DBKEY = @OPTN
     C                   EXSR      *PSSR
     C                   ENDIF
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
