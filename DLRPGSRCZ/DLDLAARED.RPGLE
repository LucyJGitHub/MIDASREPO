     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('DL Adjustment Accrued Interest Read')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DLDLAARED - Midas DL Adjustment to Accrued Interest          *
      *              Details Read                                     *
      *                                                               *
      *  Function:  This module reads forwards and backwards          *
      *             through the DLSTRANFPD Details File               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. AR1096788          Date 18Mar13               *
      *  Prev Amend No. CAP210  *CREATE    Date 28Sep12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR1096788 - DLAA details should be written in core STRANF    *
      *              file instead of the new DLSTRANFPD file          *
      *  CAP210 - Adjustment to Accrued Interests API                 *
      *                                                               *
      *****************************************************************
      *
      ** Transaction Details File - by transaction Number
     F***DLSTRANLL0IF   E           K DISK    INFSR(*PSSR)                                 AR1096788
     F**********                           RENAME(DLDTRANFF:TrnFMAT)                       AR1096788
     FSTRANFL0  IF   E           K DISK    INFSR(*PSSR)                                    AR1096788
     F                                     RENAME(STRANFF:TrnFMAT)                         AR1096788
      ** Customer Details File
     FSDCUSTL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(@BBREBF:CUSNUM)
      *****************************************************************
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** External DS For Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** First DS for Access Programs, Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Externally described DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *
     D WCOUNTER        S              6P 0
     D KTNLU           S                   LIKE(TNLU)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Start of Main processing
      *
      ** Initialize outputs
      *
     C                   EVAL      @ERRMS = *BLANK
     C                   EVAL      @TRRED = *BLANK
      *
      ** Check for user authority to browse if not multi-branching
      *
     C                   IF        BJSBRC <> *BLANK
     C                   EXSR      CHAUTN
     C                   ENDIF
      *
      ** Validate Transaction Reference (for pointer)
      *
     C                   EXSR      VALTRN
      *
      ** Read forwards
      *
     C                   IF        @RDFWD = 'Y'
     C                   EXSR      RDFWD
     C                   ELSE
      *
      ** Read backwards
      *
     C                   IF        @RDBCK = 'Y'
     C                   EXSR      RDBCK
     C                   ENDIF
     C                   ENDIF
      *
      ** Return
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
      ** Check the authorized file
      *
     C     DDTRNN        SETGT     TRNFMAT
      *
      ** Read until end of file or a valid record is found or an error
      *
     C                   DOU       *IN99 = '1' OR
     C                             DLNO   <> *ZERO   AND
     C                             @@ERR = *ZERO AND
     C                             FLTYLC <> 'D'
      *
      ** Read next transaction
      *
     C                   READ      TRNFMAT                                99
      *
     C                   ENDDO
      *
      ** If end of file was encountered, report this fact
      *
     C**********         IF        %EOF(DLSTRANLL0)                                        AR1096788
     C                   IF        %EOF(STRANFL0)                                          AR1096788
     C                   EVAL      @ERRMS = 'MMM1002'
     C                   ELSE
      *
      ** Else, return the transaction reference read
      *
     C                   EVAL      @TRRED = FLTRNN
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
      ** Position to current record on file
      *
     C     DDTRNN        SETLL     TRNFMAT
      *
      ** Read until end of file or a valid record is found or an error
      *
     C                   DOU       *IN99 = '1' OR
     C                             DLNO   <> *ZERO   AND
     C                             @@ERR = *ZERO AND
     C                             FLTYLC <> 'D'
      *
      ** Read previous transaction
      *
     C                   READP     TRNFMAT                                99
      *
     C                   ENDDO
      *
      ** If start of file was encountered, report this fact
      *
     C                   IF        *IN99 = '1'
     C                   EVAL      @ERRMS = 'MMM1003'
      *
      ** Else, return the transaction reference read
      *
     C                   ELSE
      *
     C                   EVAL      @TRRED = FLTRNN
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
      ** Return Error Message
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
      ** Input Parameters :
      ** Return Code
      ** Action Code
      ** Transaction reference pointer
      ** Read Forwards
      ** Read Backwards
      *
     C                   PARM                    RetCodeIn
     C                   PARM                    DDACTN            1
     C                   PARM                    DDTRNN            6
     C                   PARM                    @RDFWD            1
     C                   PARM                    @RDBCK            1
      ** Output Parameters :
      ** Error meassage
      ** Transaction read
     C                   PARM                    @ERRMS            7
     C                   PARM                    @TRRED            6
      *
      ** Initialize program name
      *
     C                   EVAL      DBPGM = 'DLDLAARED'
      *
      ** Access Bamk Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database Error
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
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
