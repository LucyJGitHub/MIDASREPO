     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Nostro Transfer Retrieve')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTFTNTR - Midas FT Nostro Transfer Retrieve                  *
      *                                                               *
      *  Function:  This module retrieves a record from the file      *
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
 
      **-----------------------------------------------------------------------
     D/COPY ZACPYSRC,ERR_ARRAYS
      **-----------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      **-----------------------------------------------------------------------
      ** Screen formats
      **-----------------------------------------------------------------------
 
     D NoTrScnFmt    E DS                  EXTNAME(FTFTNTPD)
      * Transaction in screen format
 
      **-----------------------------------------------------------------------
      ** File formats
      **-----------------------------------------------------------------------
 
     D NoTrFilFmt    E DS                  EXTNAME(NTRANDD)
      ** Transaction in file format
 
     D ExtData       E DS                  EXTNAME(FTFTEXPD)
      ** Extra Data
 
      **-----------------------------------------------------------------------
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** External DS for Customer Details
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Long DS for access programs
 
      **-----------------------------------------------------------------------
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0
 
     D AuthComp        S              1
     D FwdBck          S              1
     D DDTFRF_In       S             15
     D DDACTN_In       S              1
     D Buffer          S           6000
     D APIRetc         S              1
     D @TFRF           S             15
     D @TimeStamp      S             26
     D @RDFWD          S              1
     D @RDBCK          S              1
     D @ERRMS          S              7
     D @FRNT           S             20
     D ModeofOp        S              6
     D APRESPMODE      S              1
     D OKACTN          S              1
     D OKTFRF          S              1
 
     D PRTCD           S              7
     D POPTN           S              7
     D PCNUM           S             10
     D PKYST           S              7
 
      **-----------------------------------------------------------------------
      ** +--- Start of main processing -----------------------------------+
 
     C     *ENTRY        PLIST
     C                   PARM                    AuthComp
     C                   PARM                    FwdBck
     C                   PARM                    DDTFRF_In
     C                   PARM                    DDACTN_In
     C                   PARM                    Buffer
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetc
 
      * Set up the name of the primary and secondary message files from
      * which the message handler will get the messages
     C                   EVAL      MsgFArray(1) = 'FTUSRMSG'
     C                   EVAL      MsgFArray(2) = 'DRSMM'
 
      * If the action code is blank, enquire unless authorising
     C                   CLEAR                   NoTrFilFmt
     C     DDACTN_In     IFEQ      *BLANK
     C     AuthComp      IFEQ      'X'
     C                   MOVEL     'X'           NTACTN
     C                   ELSE
     C                   MOVEL     'E'           NTACTN
     C                   ENDIF
     C                   ENDIF
 
     C     FwdBck        IFEQ      'F'
     C                   MOVEL     'Y'           @RDFWD
     C                   MOVEL     'N'           @RDBCK
     C                   ELSE
     C     FwdBck        IFEQ      'B'
     C                   MOVEL     'N'           @RDFWD
     C                   MOVEL     'Y'           @RDBCK
     C                   ELSE
     C                   MOVEL     'N'           @RDFWD
     C                   MOVEL     'N'           @RDBCK
     C                   ENDIF
     C                   ENDIF
 
     C     @RDFWD        IFEQ      'Y'
     C     @RDBCK        OREQ      'Y'
     C                   EXSR      FTFTNTRED
     C                   ELSE
      ** MOVE ALL THE KEY FIELDS REQUIRED HERE TO THE @XXXX FORMAT
     C                   MOVEL     DDTFRF_In     @TFRF
     C                   MOVEL     *BLANK        @ERRMS
     C                   ENDIF
      *
      * If nostro transfer read and no error message returned
     C                   IF        @ERRMS = *BLANK and
     C                             @TFRF <> *Blank
      *
      * Retrieve transaction details
     C                   MOVEL     @TFRF         TFRF
     C                   EXSR      FTFTNTRTV
      *
      * Convert to screeen format
     C     Idx           IFEQ      0
     C                   EXSR      FTFTNTCVT
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        @ERRMS <> *BLANK
     C                   MOVEL     '0'           APIRetc
     C                   MOVEL     'TFRF  '      FldNameArr(1)
     C                   MOVEL     @ERRMS        MsgIDArr(1)
     C                   ENDIF
 
      ** Populate customer details
     C                   IF        NTINBT = 'C'
      *
     C                   IF        %SUBST(NTINB1:1:1) <> '/'
     C                   MOVEL     NTINB1        PCNUM
     C                   ELSE
     C                   MOVEL     NTINB2        PCNUM
     C                   ENDIF
      *
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PCNUM
     C                   PARM      *BLANKS       PKYST
     C     SDCUST        PARM      *BLANKS       DSSDY
      *
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      NTIBSN = BBCSSN
     C                   EVAL      NTIBNM = BBCRNM
     C                   EVAL      NTIBTN = BBCRTN
     C                   EVAL      NTIBID = BBCSID
     C                   ENDIF
      *
     C                   ENDIF
 
      * Build buffer with required output
     C                   MOVE      TMST          @TimeStamp
     C                   EVAL                    Buffer = NoTrScnFmt
     C                                           + ExtData + @TimeStamp
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
      **********************************************************************
     C     FTFTNTRED     BEGSR
      *
     C                   CALLB     'FTFTNTRED'
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        ReturnCode
      *
      * ACTION CODE
     C                   PARM                    NTACTN
      *
      * TRANSFER REFERENCE POINTER
     C                   PARM                    DDTFRF_In
      *
      * READ FORWARDS
     C                   PARM                    @RDFWD
      *
      * READ BACKWARDS
     C                   PARM                    @RDBCK
      *
      * OUTPUT PARAMETERS
      *
      * ERROR MESSAGE
     C                   PARM      *BLANK        @ERRMS
      *
      * TRANSFER REF READ
     C                   PARM      *BLANK        @TFRF
      *
      * Front Office ID READ
     C                   PARM      *BLANK        @FRNT
 
     C                   ENDSR
      **********************************************************************
     C     FTFTNTRTV     BEGSR
 
     C                   CALLB     'FTFTNTRTV'
 
      * INPUTS
 
      * Return code
     C                   PARM      *BLANKS       ReturnCode
 
     C                   PARM                    ModeofOp
      * Response mode
     C                   PARM      'S'           APRESPMODE
      * Action Code
     C                   PARM                    NTACTN
      * Front Office ID
     C                   PARM      *BLANKS       FRNT
      * Transfer Reference
     C                   PARM                    TFRF
 
      * OUTPUTS
 
      * (Current) Transaction in file format
     C                   PARM                    NoTrFilFmt
      * OK - Action code
     C                   PARM                    OKACTN
      * OK - Transfer Reference
     C                   PARM                    OKTFRF
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
 
 
     C                   ENDSR
      **********************************************************************
     C     FTFTNTCVT     BEGSR
 
     C                   CALLB     'FTFTNTCVT'
 
      * INPUTS
      * Return Code
     C                   PARM      *BLANKS       ReturnCode
      * (Current) Transaction in file format
     C                   PARM                    NoTrFilFmt
 
      * OUTPUTS
      * (Current) Transaction in screen format
     C                   PARM                    NoTrScnfmt
 
     C                   ENDSR
      **********************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, excluding a bound call to the DBERRCTL module.
      *********************************************************************
     C/COPY ZACPYSRC,PSSR_ILENE
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
