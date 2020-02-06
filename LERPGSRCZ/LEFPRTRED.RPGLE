     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Funding participant code read')
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LEFPRTRED -  LE Funding participant details read             *
      *                                                               *
      *  Function:  This module reads forwards and backwards          *
      *             through the Funding participant details file      *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CAP084  *CREATE    Date 15Apr03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CAP084 - Synchronous calling of APIs                         *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FLEFCLTL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FCLTYFMF:TrnFmat)
      * Funding participant - keyed by transaction reference
 
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
     C                   EVAL      @ERRMS = *BLANK
     C                   EVAL      @BRCA = *BLANK
     C                   EVAL      @PMFC = *BLANK
     C                   EVAL      @PMFT = *BLANK
     C                   EVAL      @PMFN = *BLANK
     C                   EVAL      @CNUM = *BLANK
     C                   EVAL      @FACT = *BLANK
     C                   EVAL      @FCNO = *BLANK
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
      * Return code
     C                   PARM                    RetCodeIn
 
      * Action code
     C                   PARM                    DDACTN            1
 
      * Funding participant reference:
     C                   PARM                    DDPMFC            6
     C                   PARM                    DDPMFT            3
     C                   PARM                    DDPMFN            2
     C                   PARM                    DDCNUM           10
 
      * Front Office Transaction ID
     C                   PARM                    DDFRNT           20
 
      * Read forwards
     C                   PARM                    @RDFWD            1
 
      * Read backwards
     C                   PARM                    @RDBCK            1
 
      * Output Parameters :
      * Error meassage
     C                   PARM                    @ERRMS            7
 
      * Funding participant read:
      * Customer, facility
     C                   PARM                    @PMFC             6
     C                   PARM                    @PMFT             3
     C                   PARM                    @PMFN             2
     C                   PARM                    @CNUM             6
     C                   PARM                    @FACT             3
     C                   PARM                    @FCNO             2
      *
      ** Initialise program name
     C                   EVAL      DBPGM = 'LEFPRTRED'
      *
      ** Access bank details
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
     C                   KFLD                    @@BRCA            3
     C**********         KFLD                    @@PMFC            6 0                        CSD027
     C                   KFLD                    @@PMFC            6                          CSD027
     C                   KFLD                    @@PMFT            3 0
     C                   KFLD                    @@PMFN            2 0
     C**********         KFLD                    @@CNUM            6 0                        CSD027
     C                   KFLD                    @@CNUM            6                          CSD027
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * RDFWD - Read forwards through transaction details file
      *****************************************************************
     C     RDFWD         BEGSR
      *
      * Position to current record on file
     C     @@FKEY        SETGT     TrnFmat
      *
      * Read until end of file or a valid record is found or an error
     C                   DOU       *IN99 = '1' OR
     C                             RECI <> *BLANKS AND
     C                             @@ERR = *ZERO
      *
      * Read next transaction
     C                   READ      TrnFmat                                99
      *
     C                   ENDDO
      *
      * If end of file was encountered, report this fact
     C                   IF        *IN99 = '1'
     C                   EVAL      @ERRMS = 'MMM1002'
      *
      * Else, return the transaction reference read
     C                   ELSE
     C                   MOVE      BRCA          @BRCA             3
     C                   MOVE      PMFC          @PMFC
     C                   MOVE      PMFT          @PMFT
     C                   MOVE      PMFN          @PMFN
     C                   MOVE      CNUM          @CNUM
     C                   MOVE      FACT          @FACT
     C                   MOVE      FCNO          @FCNO
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDBCK - Read backwards through transaction details file
      *****************************************************************
     C     RDBCK         BEGSR
      *
      * Position to current record on file
     C     @@FKEY        SETLL     TrnFmat
      *
      * Read until end of file or a valid record is found or an error
     C                   DOU       *IN99 = '1' OR
     C                             RECI <> *BLANKS AND
     C                             @@ERR = *ZERO
      *
      * Read previous transaction
     C                   READP     TrnFmat                                99
      *
     C                   ENDDO
      *
      * If start of file was encountered, report this fact
     C                   IF        *IN99 = '1'
     C                   EVAL      @ERRMS = 'MMM1003'
      *
      * Else, return the transaction reference read
     C                   ELSE
      *
     C                   MOVE      BRCA          @BRCA
     C                   MOVE      PMFC          @PMFC
     C                   MOVE      PMFT          @PMFT
     C                   MOVE      PMFN          @PMFN
     C                   MOVE      CNUM          @CNUM
     C                   MOVE      FACT          @FACT
     C                   MOVE      FCNO          @FCNO
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
      * VALTRN - validate transaction reference
      *****************************************************************
     C     VALTRN        BEGSR
      *
      * Check that the transaction reference is numeric or blank.
     C**********         TESTN                   DDPMFC               98                      CSD027
     C**********         MOVE      DDPMFC        @@TEST            1                          CSD027
     C**********         TESTZ                   @@TEST                   99                  CSD027
     C**********         IF        DDPMFC = *BLANKS OR                                        CSD027
     C**********                   *IN98 = '1' AND                                            CSD027
     C**********                   *IN99 = '1'                                                CSD027
     C                   MOVE      DDPMFC        @@PMFC
      *
      * Return error message
     C**********         ELSE                                                                 CSD027
     C**********         EVAL      @ERRMS = 'MMM0162'                                         CSD027
     C**********         RETURN                                                               CSD027
     C**********         ENDIF                                                                CSD027
      *
      * Check that the facility type is numeric or blank.
     C                   TESTN                   DDPMFT               98
     C                   MOVE      DDPMFT        @@TEST            1
     C                   TESTZ                   @@TEST                   99
     C                   IF        DDPMFT = *BLANKS OR
     C                             *IN98 = '1' AND
     C                             *IN99 = '1'
     C                   MOVE      DDPMFT        @@PMFT
      *
      * Return error message
     C                   ELSE
     C                   EVAL      @ERRMS = 'LEU0015'
     C                   RETURN
     C                   ENDIF
      *
      * Check that the facility number is numeric or blank.
     C                   TESTN                   DDPMFN               98
     C                   MOVE      DDPMFN        @@TEST            1
     C                   TESTZ                   @@TEST                   99
     C                   IF        DDPMFN = *BLANKS OR
     C                             *IN98 = '1' AND
     C                             *IN99 = '1'
     C                   MOVE      DDPMFN        @@PMFN
      *
      * Return error message
     C                   ELSE
     C                   EVAL      @ERRMS = 'LEU0015'
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
