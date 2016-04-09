     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE PDCL Conversion - Retrieve')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Lending Module                                       *
      *                                                               *
      *  LEPDCLR - Past Due Call Loan Conversion: retrieve a record   *
      *                                                               *
      *  Function:  This module retrieves a record from the file      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. AR1078092          Date 20Jan12               *
      *  Prev Amend No. 264044             Date 01Aug12               *
      *                 CLE134  *CREATE    Date 01Aug12               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  AR1078092 - Event Code of 45021706 (settlement account is    *
      *              (blocked) is not user configurable               *
      *  264044 - CLE134 Test PDCL SOAP API                           *
      *  CLE134 - Past Due Call Loan Processing                       *
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
 
      ** The following /COPY includes (among others) the LDA layout
      ** and the copyright array definition:
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** The following /COPY includes the standard API declares:
 
     D/COPY ZACPYSRC,STDDECLARE
 
 
      ** The following /COPY includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
     D/COPY ZACPYSRC,ERR_ARRAYS
 
      ** End of automatically included D-specs
 
      ** Screen formats
 
      ** Past Due Call Loan Conversion screen format
 
     D PDCLScnFmt    E DS                  EXTNAME(LEPDCLPD)
 
      ** File formats
 
      ** Past Due & Original Loan Link File Format
 
     D PDCLFilFmtLnkLE DS                  EXTNAME(LEPDUEPD)
     D                                     PREFIX(X_)
 
      ** Past Due & Original Fees Link File Format
 
     D PDCLFilFmtLnkFE DS                  EXTNAME(LEPDUFPD)
     D                                     PREFIX(Z_)
 
      ** Loans File Format
 
     D PDCLFilFmtLoanE DS                  EXTNAME(CLOANCL)
     D                                     PREFIX(C_)
 
      ** Loans File Format 2
 
     D PDCLFilFmtLoaKE DS                  EXTNAME(CLOANCK)
     D                                     PREFIX(K_)
 
      ** Fees File Format
 
     D PDCLFilFmtFee E DS                  EXTNAME(LEFEED)
     D                                     PREFIX(E_)
 
      ** Facilities File Format
 
     D PDCLFilFmtFctyE DS                  EXTNAME(FCLTYFM)
     D                                     PREFIX(M_)
 
     D OKTrnDets     E DS                  EXTNAME(LEEPDCLPD)
 
     D HeadIn        E DS                  EXTNAME(APHEADPD)                               AR1078092
                                                                                           AR1078092
      ** Index for arrays of error message ids etc
 
     D Idx             S              3P 0
 
      ** Index for arrays of warning message ids etc
 
     D WIdx            S              3P 0
 
     D AuthComp        S              1A
     D FwdBck          S              1A
 
     D Buffer          S           6000A
     D APIRetc         S              1A
 
     D @TimeStamp      S             26A
 
     D @RDFWD          S              1A
     D @RDBCK          S              1A
     D @ERRMS          S              7A
 
     D @KYRED          DS
     D  @ORLN                         6
     D  @FECU                         6
     D  @FFAC                         5
     D  @FSEQ                         2
     D  @FLNO                         6
     D  @PLON                         6
     D  @PLO2                         6
 
     D DDORLN_IN       S              6A
     D DDFECU_IN       S              6A
     D DDFFAC_IN       S              5A
     D DDFSEQ_IN       S              2A
     D DDFLNO_IN       S              6A
     D***DDPLON_IN       S              6P 0                                                  264044
     D***DDPLO2_IN       S              6P 0                                                  264044
     D DDPLON_IN       S              6A                                                      264044
     D DDPLO2_IN       S              6A                                                      264044
     D DDPLON_NN       S              6A
     D DDPLO2_NN       S              6A
     D DDACTN_IN       S              1
 
     D @FTRED          S             20A
 
     D DDTMST          S             26Z
 
     D ModeofOp        S              6A
     D*APRESPMODE      S              1A                                                   AR1078092
 
     D RecordType      S              1A
     D COBMode         S              1A                                                   AR1078092
 
      ** Additional Field Definitions
     D WUSR            S             10
 
      ** Start of main processing
 
     C     *ENTRY        PLIST
     C                   PARM                    AuthComp
     C                   PARM                    FwdBck
     C                   PARM                    HeadIn                                    AR1078092
 
      ** Key fields
 
     C                   PARM                    DDORLN_IN
     C                   PARM                    DDFECU_IN
     C                   PARM                    DDFFAC_IN
     C                   PARM                    DDFSEQ_IN
     C                   PARM                    DDFLNO_IN
     C                   PARM                    DDPLON_IN
     C                   PARM                    DDPLO2_IN
 
     C                   PARM                    DDACTN_IN
 
      ** Buffers
 
     C                   PARM                    Buffer
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetc
                                                                                           AR1078092
     C                   EVAL      COBMode = *BLANKS                                       AR1078092
     C                   IF        APSRCSYS = 'MIDASCOB'                                   AR1078092
     C                   EVAL      COBMode = 'Y'                                           AR1078092
     C                   ENDIF                                                             AR1078092
 
      ** Set up the name of the primary and secondary message files
      ** from which the message handler will get the messages
 
     C                   EVAL      MsgFArray(1) = 'LERMSGF '
     C                   EVAL      MsgFArray(2) = 'DRSMM'
     C                   EVAL      MsgFArray(3) = 'Y2USRMSG'
 
      ** add here local message files
 
      ** If the action code is blank, enquire unless authorising
 
     C                   CLEAR                   PDCLFilFmtLnkL
     C                   CLEAR                   PDCLFilFmtLnkF
     C                   CLEAR                   PDCLFilFmtLoan
     C                   CLEAR                   PDCLFilFmtLoaK
     C                   CLEAR                   PDCLFilFmtFee
     C                   CLEAR                   PDCLFilFmtFcty
 
     C                   MOVE      DDACTN_IN     DDACTN
 
     C     DDACTN_IN     IFEQ      *BLANK
     C     AuthComp      IFEQ      'X'
     C                   MOVEL     'X'           DDACTN
     C                   ELSE
     C                   MOVEL     'E'           DDACTN
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
     C                   EXSR      LEPDCLRED
     C                   ELSE
 
      ** Move all the key fields required here to the @KYRED format
 
     C                   MOVEL     DDORLN_IN     @ORLN
     C                   MOVEL     DDFECU_IN     @FECU
     C                   MOVEL     DDFFAC_IN     @FFAC
     C                   MOVEL     DDFSEQ_IN     @FSEQ
     C                   MOVEL     DDFLNO_IN     @FLNO
     C                   MOVEL     DDPLON_IN     @PLON                                        264044
     C                   MOVEL     DDPLO2_IN     @PLO2                                        264044
 
     C                   MOVEL     *BLANK        @ERRMS
     C                   ENDIF
 
      ** If PDCL read and no error message returned
 
     C                   IF            @ERRMS  = *blanks
     C                             and (@ORLN  <> *blanks
     C                             or @FECU  <> *blanks
     C                             or @FFAC  <> *blanks
     C                             or @FSEQ  <> *blanks
     C                             or @FLNO  <> *blanks)
 
      ** Retrieve PDCL details
      ** (all key fields required for call to rtv module)
 
     C                   MOVEL     @ORLN         DDORLN
     C                   MOVEL     @FECU         DDFECU
     C                   MOVEL     @FFAC         DDFFAC
     C                   MOVEL     @FSEQ         DDFSEQ
     C                   MOVEL     @FLNO         DDFLNO
     C                   MOVEL     @PLON         DDPLON_NN                                    264044
     C                   MOVEL     @PLO2         DDPLO2_NN                                    264044
     C                   EXSR      LEPDCLRTV
 
      ** Convert to screeen format
 
     C                   IF        RetCodeOut = *BLANKS
     C                   EXSR      LEPDCLCVT
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        @ERRMS <> *BLANKS
     C                   MOVEL     '0'           APIRetc
     C                   MOVEL     'XXXXXX'      FldNameArr(1)
     C                   MOVEL     @ERRMS        MsgIDArr(1)
     C                   ENDIF
 
      ** Build buffer with required output
 
     C                   MOVE      DDTMST        @TimeStamp
     C                   EVAL      Buffer    = PDCLScnFmt + @TimeStamp
 
     C                   SETON                                        LR
     C                   RETURN
      *****************************************************************
      *                                                               *
      * LEPDCLRED - Past Due Call Loan Details                        *
      *                                                               *
      *****************************************************************
     C     LEPDCLRED     BEGSR
 
     C                   RESET                   RetCodeOut
 
     C                   CALLB     'LEPDCLRED'
 
      ** Input parameters
 
      ** Return code
 
     C                   PARM                    RetCodeOut
 
      ** Action code
 
     C                   PARM                    DDACTN
 
      ** Keys
 
     C                   PARM                    DDORLN
     C                   PARM                    DDFECU
     C                   PARM                    DDFFAC
     C                   PARM                    DDFSEQ
     C                   PARM                    DDFLNO
 
      ** Read forwards
 
     C                   PARM                    @RDFWD
 
      ** Read Backwards
 
     C                   PARM                    @RDBCK
 
      ** Output parameters
 
      ** Error message
 
     C                   PARM      *BLANK        @ERRMS
 
     C                   PARM      *BLANK        @KYRED
 
      ** Front Office ID Read
 
     C                   PARM      *BLANK        @FTRED
 
     C                   ENDSR
      *****************************************************************
      /Eject
      *****************************************************************
      *                                                               *
      * LEPDCLRTV - Retrieve Past Due Call Loan Details               *
      *                                                               *
      *****************************************************************
     C     LEPDCLRTV     BEGSR
 
     C                   RESET                   RetCodeOut
 
     C                   CALLB     'LEPDCLRTV'
 
      ** Inputs
 
      ** Return code
 
     C                   PARM                    RetCodeOut
 
      ** Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ** Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
 
     C                   PARM                    ModeofOp
 
      ** Response mode
 
     C                   PARM      'S'           APRESPMODE
 
      ** Action Code
 
     C                   PARM                    DDACTN
 
      ** Front office id
 
     C                   PARM                    @FTRED
 
      ** User ID
 
     C                   PARM                    WUSR
 
      ** Key fields required
 
     C                   PARM                    DDORLN
     C                   PARM                    DDFECU
     C                   PARM                    DDFFAC
     C                   PARM                    DDFSEQ
     C                   PARM                    DDFLNO
 
     C**********         PARM                    DDPLON_IN                                    264044
     C**********         PARM                    DDPLO2_IN                                    264044
     C                   PARM                    DDPLON_NN                                    264044
     C                   PARM                    DDPLO2_NN                                    264044
     C                   PARM                    DDSEIN                                       CLE134
     C                   PARM                    COBMode                                   AR1078092
 
      ** OUTPUTS
 
      ** Transaction Type
 
     C                   PARM                    RecordType
 
      ** Loans File Format
 
     C                   PARM                    PDCLFilFmtLoan
 
      ** Loans File Format 2
 
     C                   PARM                    PDCLFilFmtLoaK
 
      ** Fee File Format
 
     C                   PARM                    PDCLFilFmtFee
 
      ** Facility File Format
 
     C                   PARM                    PDCLFilFmtFcty
 
      ** Past Due & Original Loan Link File Format
 
     C                   PARM                    PDCLFilFmtLnkL
 
      ** Past Due & Original Fees Link File Format
 
     C                   PARM                    PDCLFilFmtLnkF
 
      ** PDCL Details OK inds
 
     C                   PARM                    OKTrnDets
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM                    Idx
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * LEPDCLCVT -Convert to screen format                           *
      *                                                               *
      *****************************************************************
     C     LEPDCLCVT     BEGSR
 
     C                   RESET                   RetCodeOut
 
     C                   CALLB     'LEPDCLCVT'
 
      ** INPUTS
      ** Return Code
 
     C                   PARM                    RetCodeOut
 
      ** Keys
 
     C                   PARM                    DDORLN
     C                   PARM                    DDFECU
     C                   PARM                    DDFFAC
     C                   PARM                    DDFSEQ
     C                   PARM                    DDFLNO
 
     C**********         PARM                    DDPLON                                       264044
     C**********         PARM                    DDPLO2                                       264044
     C                   PARM      DDPLON_IN     DDPLON                                       264044
     C                   PARM      DDPLO2_IN     DDPLO2                                       264044
 
     C                   PARM                    RecordType
 
      ** Past Due & Original Loan Link File Format
 
     C                   PARM                    PDCLFilFmtLnkL
 
      ** Past Due & Original Fees Link File Format
 
     C                   PARM                    PDCLFilFmtLnkF
 
      ** Loans File Format
 
     C                   PARM                    PDCLFilFmtLoan
 
      ** Loans File Format 2
 
     C                   PARM                    PDCLFilFmtLoaK
 
      ** Fee File Format
 
     C                   PARM                    PDCLFilFmtFee
 
      ** Facility File Format
 
     C                   PARM                    PDCLFilFmtFcty
 
      ** OUTPUTS
      ** (Current) Deal in screen format
 
     C                   PARM                    PDCLScnFmt
 
      ** Timestamp
 
     C                   PARM                    DDTMST
 
      ** AMEND CHECKING
 
     C                   RESET                   RetCodeOut
 
     C                   ENDSR
      *****************************************************************
      /EJECT
 
      ** The following /COPY contains the standard program status
      ** subroutine, excluding a bound call to the DBERRCTL module
 
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILENE
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) MIsys International Banking Systems Ltd. 2012
