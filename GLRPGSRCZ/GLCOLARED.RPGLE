     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Collateral details read')                     *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLCOLARED - GL Collateral Allocations details read           *
      *                                                               *
      *  Function:  This module reads forwards and backwards          *
      *             through the Collateral Details File               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084  *CREATE    Date 20Aug03               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - Synchronous calling of APIs                         *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      * Transaction details file - by transaction number
     FGLCOLAL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLCOLAD0:TRNFMAT)
 
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
 
     D @@TRNN          DS
      ** First DS for access programs, short data structure
     D  KCREF                  1     10
     D  KBRCA                 11     13
     D**KCNUM***              14     19  0                                                    CSD027
     D  KCNUM                 14     19A                                                      CSD027
     D  KMODS                 20     21
     D**KFCUS***              22     27  0                                                    CSD027
     D  KFCUS                 22     27A                                                      CSD027
     D  KFTYP                 28     30  0
     D  KFSEQ                 31     32  0
     D**KLNLM***              33     38  0                                                    CLE148
     D  KLNLM                 33     38                                                       CLE148
     D  KSBRC                 39     41
     D**KSCNM***              42     47  0                                                    CSD027
     D  KSCNM                 42     47A                                                      CSD027
     D  KSCCY                 48     50
     D***KSACD**               51     54  0                                                   CGL029
     D***KSSEQ**               55     56  0                                                   CGL029
     D  KSACD                 51     60  0                                                    CGL029
     D  KSSEQ                 61     62  0                                                    CGL029
 
     D PARKEY          DS
      ** DS of all key fields read from GLCOLAPD
     D  CACREF                 1     10
     D  CABRCA                11     13
     D**CACNUM**              14     19  0                                                    CSD027
     D  CACNUM                14     19A                                                      CSD027
     D  CAMODS                20     21
     D**CAFCUS**              22     27  0                                                    CSD027
     D  CAFCUS                22     27A                                                      CSD027
     D  CAFTYP                28     30  0
     D  CAFSEQ                31     32  0
     D**CALNLM**              33     38  0                                                    CLE148
     D  CALNLM                33     38                                                       CLE148
     D  CASBRC                39     41
     D**CASCNM**              42     47  0                                                    CSD027
     D  CASCNM                42     47A                                                      CSD027
     D  CASCCY                48     50
     D***CASACD*               51     54  0                                                   CGL029
     D***CASSEQ*               55     56  0                                                   CGL029
     D  CASACD                51     60  0                                                    CGL029
     D  CASSEQ                61     62  0                                                    CGL029
 
     D DDTRNN          DS
      ** DS of all key fields incoming from *PLIST
     D  CACREF_IN              1     10
     D  CABRCA_IN             11     13
     D**CACNUM_IN*******      14     19  0                                                    CSD027
     D  CACNUM_IN             14     19                                                       CSD027
     D  CAMODS_IN             20     21
     D**CAFCUS_IN*******      22     27  0                                                    CSD027
     D  CAFCUS_IN             22     27                                                       CSD027
     D  CAFTYP_IN             28     30  0
     D  CAFSEQ_IN             31     32  0
     D**CALNLM_IN             33     38  0                                                    CLE148
     D  CALNLM_IN             33     38                                                       CLE148
     D  CASBRC_IN             39     41
     D**CASCNM_IN*******      42     47  0                                                    CSD027
     D  CASCNM_IN             42     47                                                       CSD027
     D  CASCCY_IN             48     50
     D***CASACD_IN             51     54  0                                                   CGL029
     D***CASSEQ_IN             55     56  0                                                   CGL029
     D  CASACD_IN             51     60  0                                                    CGL029
     D  CASSEQ_IN             61     62  0                                                    CGL029
 
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
     C                   EVAL      @TRRED = *BLANK
      *
      * LECOLAL1 key list
     C     KTRNN         KLIST
     C                   KFLD                    KCREF
     C                   KFLD                    KBRCA
     C                   KFLD                    KCNUM
     C                   KFLD                    KMODS
     C                   KFLD                    KFCUS
     C                   KFLD                    KFTYP
     C                   KFLD                    KFSEQ
     C                   KFLD                    KLNLM
     C                   KFLD                    KSBRC
     C                   KFLD                    KSCNM
     C                   KFLD                    KSCCY
     C                   KFLD                    KSACD
     C                   KFLD                    KSSEQ
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
     C                   PARM                    DDCREF           10
     C                   PARM                    DDBRCA            3
     C                   PARM                    DDCNUM            6
     C                   PARM                    DDMODS            2
     C                   PARM                    DDFCUS            6
     C                   PARM                    DDFTYP            3
     C                   PARM                    DDFSEQ            2
     C                   PARM                    DDLNLM            6
     C                   PARM                    DDSBRC            3
     C                   PARM                    DDSCNM            6
     C                   PARM                    DDSCCY            3
     C**********         PARM                    DDSACD            4                          CGL029
     C                   PARM                    DDSACD           10                          CGL029
     C                   PARM                    DDSSEQ            2
 
      * Read forwards
     C                   PARM                    @RDFWD            1
 
      * Read backwards
     C                   PARM                    @RDBCK            1
 
      * Output Parameters :
      * Error meassage
     C                   PARM      *BLANK        @ERRMS            7
 
      * Transaction read
     C                   PARM      *BLANK        @TRRED           56
 
      * Front Office ID READ
     C                   PARM      *BLANK        @FTRED           20
      *
      ** Initialise program name
     C                   EVAL      DBPGM = 'GLCOLARED'
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
     C                   ENDSR
      /EJECT
      *****************************************************************
      * RDFWD - Read forwards through transaction details file
      *****************************************************************
     C     RDFWD         BEGSR
      *
      * Position to current record on file
     C     KTRNN         SETGT     TRNFMAT
      *
      * Read until end of file or a valid record is found or an error
     C                   DOU       *IN99 = '1' OR
     C**********                   CACNUM <> *ZEROS                                           CSD027
     C                             CACNUM <> *BLANKS                                          CSD027
      *
      * Read next transaction
     C                   READ      TRNFMAT                                99
      *
     C                   ENDDO
      *
      * If end of file was encountered, report this fact
     C                   IF        *IN99 = '1'
     C                   EVAL      @ERRMS = 'MMM1002'
     C                   EVAL      @@ERR = 1
      *
      * Else, return the transaction reference read
     C                   ELSE
     C                   MOVE      PARKEY        @TRRED
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
     C     KTRNN         SETLL     TRNFMAT
      *
      * Read until end of file or a valid record is found or an error
     C                   DOU       *IN99 = '1' OR
     C**********                   CACNUM <> *ZEROS                                           CSD027
     C                             CACNUM <> *BLANKS                                          CSD027
      *
      * Read previous transaction
     C                   READP     TRNFMAT                                99
      *
     C                   ENDDO
      *
      * If start of file was encountered, report this fact
     C                   IF        *IN99 = '1'
     C                   EVAL      @ERRMS = 'MMM1003'
     C                   EVAL      @@ERR = 1
      *
      * Else, return the transaction reference read
     C                   ELSE
      *
     C                   MOVE      PARKEY        @TRRED
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
      * Check that the transaction reference is set up.
     C**********         IF        CACNUM <> *ZEROS                                           CSD027
     C**********         Z-ADD     CACNUM        KCNUM                                        CSD027
     C                   IF        CACNUM <> *BLANKS                                          CSD027
     C                   EVAL      KCNUM = CACNUM                                             CSD027
      *
      * Return error message
     C                   ELSE
     C                   EVAL      @ERRMS = 'MMM0162'
     C                   EVAL      @@ERR = 1
     C                   RETURN
     C                   ENDIF
      *
     C                   IF        @@ERR <> 1
     C                   MOVEL     DDCREF        CACREF_IN
     C                   MOVEL     DDBRCA        CABRCA_IN
     C                   MOVEL     DDCNUM        CACNUM_IN
     C                   MOVEL     DDMODS        CAMODS_IN
     C                   MOVEL     DDFCUS        CAFCUS_IN
     C                   MOVEL     DDFTYP        CAFTYP_IN
     C                   MOVEL     DDFSEQ        CAFSEQ_IN
     C                   MOVEL     DDLNLM        CALNLM_IN
     C                   MOVEL     DDSBRC        CASBRC_IN
     C                   MOVEL     DDSCNM        CASCNM_IN
     C                   MOVEL     DDSCCY        CASCCY_IN
     C                   MOVEL     DDSACD        CASACD_IN
     C                   MOVEL     DDSSEQ        CASSEQ_IN
     C                   ELSE
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
(c) Misys International Banking Systems Ltd. 2003
