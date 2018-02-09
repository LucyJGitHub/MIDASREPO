     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL JE read')                                     *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger ILE Module                            *
      *                                                               *
      *  GLBITHRED - Batch Header details read                        *
      *                                                               *
      *  Function:  This module reads forwards and backwards          *
      *             through the Batch Header details file             *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL130             Date 28Sep12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSW037A            Date 02May05               *
      *                 BUG6198            Date 04Apr05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CAP084  *CREATE    Date 12Aug03               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL130 - GL Batch Number Using Alphabetical Characters       *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG6198- Cannot save new Details for CUSD (Recompile)        *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CAP084 - MidasPlus Changes                                   *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      * Transaction details file - by transaction number
     FGLJENHL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(@BRREAH:JENHL1)
 
      * Transaction details file - by Front Office ID
     FGLJENHL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(@BRREMA:JENHL3)
 
      * Customer details file
     FSDCUSTL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(@BBREBF:CUSNUM)
 
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
      *                                                                                       CGL130
      ** Valid Characters                                                                     CGL130
      *                                                                                       CGL130
     D #VLDVL          C                   CONST('ABCDEFGHIJKLMNOPQRSTUVWXYZ012-              CGL130
     D                                     3456789')                                          CGL130
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for bank details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, short data structure
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CGL130
      *                                                                                       CGL130
      ** External DS for SAR Details                                                          CGL130
      *                                                                                       CGL130
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D/COPY WNCPYSRC,GLH00769
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
     C                   EVAL      @TRRED = *BLANK
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
 
      * Transaction reference
     C                   PARM                    DDBTNB            3
 
      * Read forwards
     C                   PARM                    @RDFWD            1
 
      * Read backwards
     C                   PARM                    @RDBCK            1
 
      * Output Parameters :
      * Error meassage
     C                   PARM      *BLANK        @ERRMS            7
 
      * Transaction read
     C                   PARM      *BLANK        @TRRED            6
 
      * Front Office ID READ
     C                   PARM      *BLANK        @FTRED           20
      *
      ** Initialise program name
     C                   EVAL      DBPGM = 'GLBITHRED'
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
      *                                                                                       CGL130
      ** Check if enhancement CGL130 is on                                                    CGL130
      *                                                                                       CGL130
     C                   MOVE      'N'           CGL130            1                          CGL130
      *                                                                                       CGL130
     C                   CALLB     'AOSARDR0'                                                 CGL130
     C                   PARM      *BLANKS       @RTCD                                        CGL130
     C                   PARM      '*VERIFY'     @OPTN                                        CGL130
     C                   PARM      'CGL130'      @SARD             6                          CGL130
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL130
      *                                                                                       CGL130
     C                   IF        (@RTCD <> *BLANKS) AND (@RTCD <> '*NRF')                   CGL130
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CGL130
     C                   EVAL      DBKEY = 'CGL130'                                           CGL130
     C                   EVAL      DBASE = 901                                                CGL130
     C                   EXSR      *PSSR                                                      CGL130
     C                   ENDIF                                                                CGL130
      *                                                                                       CGL130
     C                   IF        @RTCD = *BLANKS                                            CGL130
     C                   EVAL      CGL130 = 'Y'                                               CGL130
     C                   ENDIF                                                                CGL130
      *
     C/COPY WNCPYSRC,GLH00770
     C                   ENDSR
      /EJECT
      *****************************************************************
      * RDFWD - Read forwards through transaction details file
      *****************************************************************
     C     RDFWD         BEGSR
      *
      * Position to current record on file
     C     @@TRNN        SETGT     JENHL1
      *
      * Read until end of file or a valid record is found or an error
     C                   DOU       *IN99 = '1' OR
     C                             BRBTNB <> *BLANKS AND
     C                             @@ERR = *ZERO
      *
      * Read next transaction
     C                   READ      JENHL1                                 99
      *
     C                   ENDDO
      *
      * If end of file was encountered, report this fact
     C                   IF        *IN99 = '1'
     C                   EVAL      @ERRMS = 'MMM1002'
      *
      * Else, return the transaction reference read
     C                   ELSE
     C                   MOVE      BRBTNB        @TRRED
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
     C     @@TRNN        SETLL     JENHL1
      *
      * Read until end of file or a valid record is found or an error
     C                   DOU       *IN99 = '1' OR
     C                             BRBTNB <> *BLANKS AND
     C                             @@ERR = *ZERO
      *
      * Read previous transaction
     C                   READP     JENHL1                                 99
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
     C                   EVAL      @TRRED = BRBTNB
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
      *                                                                                       CGL130
      ** If CGL130 is on                                                                      CGL130
      *                                                                                       CGL130
     C                   IF        CGL130 = 'Y'                                               CGL130
     C                   IF        DDBTNB = '000'                                             CGL130
     C                   EVAL      @ERRMS = 'GLX0431'                                         CGL130
     C                   RETURN                                                               CGL130
     C                   ELSE                                                                 CGL130
      *                                                                                       CGL130
      ** Check if batch number is alpha numeric                                               CGL130
      *                                                                                       CGL130
     C                   MOVE      'Y'           #OK               1                          CGL130
     C                   Z-ADD     1             #X                1 0                        CGL130
     C                   DOW       (#OK = 'Y') AND (#X < 4)                                   CGL130
      *                                                                                       CGL130
      ** Check for valid values                                                               CGL130
      *                                                                                       CGL130
     C     1             SUBST     DDBTNB:#X     #CH               1                          CGL130
     C     #CH           SCAN      #VLDVL:1      #P                2 0    50                  CGL130
     C                   IF        *IN50 = *OFF                                               CGL130
     C                   MOVE      'N'           #OK                                          CGL130
     C                   ENDIF                                                                CGL130
     C                   ADD       1             #X                                           CGL130
     C                   ENDDO                                                                CGL130
      *                                                                                       CGL130
      ** Send error message if one of the characters is not valid                             CGL130
      *                                                                                       CGL130
     C                   IF        #OK = 'N'                                                  CGL130
     C                   EVAL      @ERRMS = 'GLX0431'                                         CGL130
     C                   RETURN                                                               CGL130
     C                   ENDIF                                                                CGL130
     C                   ENDIF                                                                CGL130
     C                   ELSE                                                                 CGL130
      *
     C/COPY WNCPYSRC,GLH00771
      * Check that the transaction reference is numeric or blank.
     C                   TESTN                   DDBTNB               98
     C                   MOVE      DDBTNB        @@TEST            1
     C                   TESTZ                   @@TEST                   99
     C                   IF        DDBTNB = *BLANKS OR
     C                             *IN98 = '1' AND
     C                             *IN99 = '1'
     C                   MOVE      DDBTNB        @@TRNN            3
      *
      * Return error message
     C                   ELSE
     C                   EVAL      @ERRMS = 'MMM0162'
     C                   RETURN
     C                   ENDIF
     C                   ENDIF                                                                CGL130
     C/COPY WNCPYSRC,GLH00772
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
