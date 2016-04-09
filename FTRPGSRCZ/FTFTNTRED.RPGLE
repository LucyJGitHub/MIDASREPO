     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Nostro Transfer Read')                        *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTFTNTRED - Midas FT Nostro Transfer Read                    *
      *                                                               *
      *  Function:  This module reads forwards and backwards          *
      *             through the Nostro Transfer details file          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2014            *
      *                                                               *
      *  Last Amend No. CAP212  *CREATE    Date 15Sep14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAP212 - FT Nostro Transfer API                              *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      * Transaction details file - by transfer reference
     FNTRAN     IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(NTRANDDF:TrnFmat)
 
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
 
     D DDACTN          S              1
     D DDTFRF          S             15
     D @RDFWD          S              1
     D @RDBCK          S              1
     D @ERRMS          S              7
     D @TFRF           S              6
     D @FRNT           S             20
     D ZACTN           S              1
     D @@ERR           S              1  0
 
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
     C                   EVAL      @TFRF = *BLANK
      *
      * Check for user authority to browse if not multi-branching
     C                   IF        BJSBRC <> *BLANK
     C                   EXSR      CHAUTN
     C                   ENDIF
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
     C                   PARM                    DDACTN
 
      * Transaction reference
     C                   PARM                    DDTFRF
 
      * Read forwards
     C                   PARM                    @RDFWD
 
      * Read backwards
     C                   PARM                    @RDBCK
 
      * Output Parameters :
      * Error meassage
     C                   PARM      *BLANK        @ERRMS
 
      * Transaction read
     C                   PARM      *BLANK        @TFRF
 
      * Front Office ID READ
     C                   PARM      *BLANK        @FRNT
      *
      ** Initialise program name
     C                   EVAL      DBPGM = 'FTFTNTRED'
      *
      ** Access bank details
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * Database error
     C                   IF        @RtCd <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 900
     C                   EVAL      DBKEY = @Optn
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
     C     DDTFRF        SETGT     TRNFMAT
      *
      * Read until end of file or a valid record is found or an error
     C                   DOU       *IN99 = '1' OR
     C                             TFRF <> *BLANKS AND
     C                             @@ERR = *ZERO AND
     C                             CHTP <> 'D'
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
      * Else, return the transaction reference read
     C                   ELSE
     C                   MOVE      TFRF          @TFRF
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
     C     DDTFRF        SETLL     TRNFMAT
      *
      * Read until end of file or a valid record is found or an error
     C                   DOU       *IN99 = '1' OR
     C                             TFRF <> *BLANKS AND
     C                             @@ERR = *ZERO AND
     C                             CHTP <> 'D'
      *
      * Read previous transaction
     C                   READP     TRNFMAT                                99
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
     C                   EVAL      @TFRF = TFRF
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
