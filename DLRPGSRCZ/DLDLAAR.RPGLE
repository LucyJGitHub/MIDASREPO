     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DL Adjustment Accrued Interest Retrieve')        *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DLDLAAR - Midas DL Adjustment Accrued Interest Retrieve      *
      *                                                               *
      *  Function:  This module retrieves a record from the file      *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR1096788          Date 18Mar13               *
      *                 CAP210  *CREATE    Date 28Sep12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR1096788 - DLAA details should be written in core STRANF    *
      *              file instead of the new DLSTRANFPD file          *
      *  CAP210 - Adjustment to Accrued Interests API                 *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
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
      *
      **-----------------------------------------------------------------------
      ** The following /COPY includes the standard API declares:
     D/COPY ZACPYSRC,STDDECLARE
      **-----------------------------------------------------------------------
      *
      **-----------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **-----------------------------------------------------------------------
      *
      **-----------------------------------------------------------------------
     D/COPY ZACPYSRC,ERR_ARRAYS
      **-----------------------------------------------------------------------
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      **-----------------------------------------------------------------------
      ** Screen formats
      **-----------------------------------------------------------------------
      *
      * DLAA in screen format
     D DLAAScnFmt    E DS                  EXTNAME(DLDLAAPD)
      **-----------------------------------------------------------------------
      ** File formats
      **-----------------------------------------------------------------------
      *
      ** DLAA in File Format
     D*DLAAFilFmt    E DS                  EXTNAME(DLSTRANFPD)                             AR1096788
     D DLAAFilFmt    E DS                  EXTNAME(STRANF)                                 AR1096788
      *
      **-----------------------------------------------------------------------
      *
      ** Index for arrays of of error message ids etc
      *
     D Idx             S              3P 0
      *
      ** Index for arrays of warning message ids etc
      *
     D WIdx            S              3P 0
     D @@MODE          S              6
     D APRESPMODE      S              1
     D MODEOFOP        S              6A
     D FOTRID          S             20
     D DTRNN           S              6
     D @RDFWD          S              1
     D @RDBCK          S              1
     D @ERRMS          S              7
     D @TRRED          S              6
     D Buffer          S           6000A
     D AuthComp        S              1
     D FwdBck          S              1
     D APIRetc         S              1
     D DDActnOK        S              1
     D DDTRNNOK        S              1
     D @DLRED          S              6
     D PDDTRNN         S              6
      *
      ** Start of Main Processing
      *
      ** If the action code is blank, enquire unless authorising
      *
     C                   CLEAR                   DLAAFilFmt
     C     DDACTN        IFEQ      *BLANK
     C     AuthComp      IFEQ      'X'
     C                   MOVEL     'X'           DDACTN
     C                   ELSE
     C                   MOVEL     'E'           DDACTN
     C                   ENDIF
     C                   ENDIF
      *
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
      *
     C     @RDFWD        IFEQ      'Y'
     C     @RDBCK        OREQ      'Y'
     C                   EXSR      SRDLAARED
     C                   ELSE
      *
      ** Move all the key fields required here to the @XXXX format
      *
     C                   MOVEL     PDDTRNN       @DLRED
     C                   MOVEL     *BLANKS       @ERRMS
     C                   ENDIF
      *
      ** If deal read and no error message returned
      *
     C                   IF        ReturnCode = *BLANK and
     C                             @DLRED <> *Blank
      *
      ** Retrieve deal details (all key fields required for call to rtv module)
      *
     C                   MOVEL     @DLRED        PDDTRNN
     C                   EXSR      SRDLAARTV
      *
      ** Convert to screeen format
      *
     C     Idx           IFEQ      0
     C                   EXSR      SRDLAACVT
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   IF        ReturnCode <> *BLANK
     C                   MOVEL     '0'           APIRetc
     C                   MOVEL     'DDTRNN'      FldNameArr(1)
     C                   MOVEL     @ERRMS        MsgIDArr(1)
     C                   ENDIF
      *
      ** Build buffer with required output
      *
     C                   EVAL                    Buffer = DLAAScnFmt
      *
     C                   SETON                                        LR
     C                   RETURN
      ****************************************************************
      /EJECT
      ****************************************************************
      * SRDLAARED - Read Adjustment Accrued Interest
      ****************************************************************
     C     SRDLAARED     BEGSR
      *
     C                   RESET                   RetCodeOut
      *
     C                   CALLB     'DLDLAARED'
      *
      ** INPUT PARAMETERS
      *
      ** RETURN CODE
      *
     C                   PARM      *BLANK        RetCodeOut
      *
      * ACTION CODE
     C                   PARM                    DDACTN
      *
      ** Transaction Number
      *
     C                   PARM                    PDDTRNN
      *
      ** READ FORWARDS
      *
     C                   PARM                    @RDFWD
      *
      ** READ BACKWARDS
      *
     C                   PARM                    @RDBCK
      *
      ** OUTPUT PARAMETERS
      *
      ** ERROR MESSAGE
     C                   PARM      *BLANK        @ERRMS
      ** Transaction Read
     C                   PARM      *BLANK        @TRRED
      *
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      * SRDLAARTV - Retrieve Adjustment Accrued Interest
      ****************************************************************
     C     SRDLAARTV     BEGSR
      *
     C                   RESET                   RetCodeOut
      *
     C                   CALLB     'DLDLAARTV'
      *
      ** INPUTS
      ** Return code
     C                   PARM                    ReturnCode
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      *
     C                   PARM                    ModeofOp
      *
      ** Response mode
      *
     C                   PARM      'S'           APRESPMODE
      *
      ** Action Code
      *
     C                   PARM                    DDACTN
      ** Front Office Transaction ID
     C                   PARM                    FOTRID
      ** Transaction Number
     C                   PARM                    PDDTRNN
      ** OUTPUTS
      ** (Current) deal in file format
     C                   PARM                    DLAAFilFmt
      ** OK - Action code
     C                   PARM                    DDActnOK
      ** OK - Transaction Number
     C                   PARM                    DDTRNNOK
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      * SRDLAACVT - Convert File to Screen Format
      ****************************************************************
     C     SRDLAACVT     BEGSR
      *
     C                   RESET                   RetCodeOut
      *
     C                   CALLB     'DLDLAACVT'
      ** INPUTS
      ** Return Code
     C                   PARM                    ReturnCode
      ** (Current) Deal in file format
     C                   PARM                    DLAAFilFmt
      ** OUTPUTS
      ** (Current) Deal in screen format
     C                   PARM                    DLAAScnfmt
      ** AMEND CHECKING
     C                   RESET                   ReturnCode
      *
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, excluding a bound call to the DBERRCTL module.
      ****************************************************************
     C/COPY ZACPYSRC,PSSR_ILENE
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      *
     C     *ENTRY        PLIST
     C                   PARM                    AuthComp
     C                   PARM                    FwdBck
     C                   PARM                    PDDTRNN
     C                   PARM                    Buffer
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetc
      *
      ** Set up the name of the primary and secondary message files from
      ** which the message handler will get the messages
      *
     C                   EVAL      MsgFArray(1) = 'DRSMM'
     C                   EVAL      MsgFArray(2) = 'DLUSRMSG'
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
