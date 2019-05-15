     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Alternative Names & Addresses Details Read.')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDALNARED - SD Customer Alternative Names & Addresses Details*
      *              Read                                             *
      *                                                               *
      *  Function:  This module reads forwards and backwards          *
      *             through the Customer Alternative Names & Addresses*
      *             Details file                                      *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. CRE026  *CREATE    Date 24May06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE026 - Consumer Banking                                    *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Customer Alternative Names & Addresses details file -
      ** by Customer Number & Address Code
     FSDALTNL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(@BCREDE:TrnFmat)
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **---------------------------------------------------------------
      ** The following /COPY includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY includes the standard API declares:
     D/COPY ZACPYSRC,STDDECLARE
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
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
 
     D DDACTN          S              1A
     D DDCUST          S              6A
     D DDADCD          S              1A
     D @RDFWD          S              1A
     D @RDBCK          S              1A
     D @ERRMS          S              7A
     D @CNRED          S              6A
     D @ACRED          S              1A
     D @FTRED          S             20A
 
     D ZACTN           S              1A
     D @@ERR           S              1P 0
 
      ** Parameters for AOBANKR0
 
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
      ** ¦ Initial processing is performed automatically: *INZSR is   ¦
      ** ¦ executed at program activation.                            ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      * Initialise outputs
     C                   EVAL      @ERRMS = *BLANK
     C                   EVAL      @CNRED = *BLANK
     C                   EVAL      @ACRED = *BLANK
      *
      * Check for user authority to browse if not multi-branching
     C                   IF        BJSBRC <> *BLANK
     C                   EXSR      CHAUTN
     C                   ENDIF
      *
      * Validate transaction reference
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
 
      ** Input parameters :
      ** Return code
 
     C                   PARM                    RetCodeIn
 
      ** Action code
 
     C                   PARM                    DDACTN
 
      ** Customer Number reference
 
     C                   PARM                    DDCUST
 
      ** Address Code reference
 
     C                   PARM                    DDADCD
 
      ** Read forwards
 
     C                   PARM                    @RDFWD
 
      ** Read backwards
 
     C                   PARM                    @RDBCK
 
      ** Output Parameters :
      ** Error meassage
 
     C                   PARM                    @ERRMS
 
      ** Customer Number read
 
     C                   PARM                    @CNRED
 
      ** Address Code read
 
     C                   PARM                    @ACRED
 
      ** Front Office ID READ
 
     C                   PARM                    @FTRED
 
      ** Initialise program name
 
     C                   EVAL      DBPGM = 'SDALNARED'
 
      ** Access bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 900
     C                   EVAL      DBKEY = @OPTN
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Key List
 
     C     KALTN         KLIST
     C                   KFLD                    DDCUST
     C                   KFLD                    DDADCD
     C                   ENDSR
      /EJECT
      *****************************************************************
      * RDFWD - Read forwards through transaction details file
      *****************************************************************
     C     RDFWD         BEGSR
      *
      * Position to current record on file
     C     KALTN         SETGT     TRNFMAT
      *
      * Read until end of file or a valid record is found or an error
     C                   DOU       *IN99 = '1' OR
     C                             (BCCUST <> *BLANKS AND
     C                             BCADCD <> *BLANKS) AND
     C                             @@ERR = *ZERO AND
     C                             BCTYLC <> 'D'
      *
      * Read next transaction
     C                   READ      TRNFMAT                                99
      *
     C                   ENDDO
      *
      * If end of file was encountered, report this fact
     C                   IF        *IN99 = '1'
     C                   EVAL      @ERRMS = 'MMM1002'
      *
      * Else, return the Customer Number & Address Code read
     C                   ELSE
     C                   MOVE      BCCUST        @CNRED
     C                   MOVE      BCADCD        @ACRED
     C                   MOVE      BCFRNT        @FTRED
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
     C     KALTN         SETLL     TRNFMAT
      *
      * Read until end of file or a valid record is found or an error
     C                   DOU       *IN99 = '1' OR
     C                             (BCCUST <> *BLANKS AND
     C                             BCADCD <> *BLANKS) AND
     C                             @@ERR = *ZERO AND
     C                             BCTYLC <> 'D'
      *
      * Read next transaction
     C                   READP     TRNFMAT                                99
      *
     C                   ENDDO
      *
      * If start of file was encountered, report this fact
     C                   IF        *IN99 = '1'
     C                   EVAL      @ERRMS = 'MMM1003'
      *
      * Else, return the Customer Number & Address Code read
     C                   ELSE
     C                   MOVE      BCCUST        @CNRED
     C                   MOVE      BCADCD        @ACRED
     C                   MOVE      BCFRNT        @FTRED
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
     C                   PARM      'E'           ZACTN
     C                   PARM                    @@ERR
 
      ** Return error message
 
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
      ** subroutine, excluding a bound call to the DBERRCTL module
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILENE
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2006
