     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2007')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Customer Withholding Tax Detail retrieve a record')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDCUWTR - SD Customer Withholding Tax Details                *
      *            retrieve a record                                  *
      *                                                               *
      *  Function:  This module retrieves a record from the file      *
      *                                                               *
      *  (c) Finastra International Limited 2007                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. CSD079  *CREATE    Date 05Feb07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD079 - Enhanced Customer Maintenance API                   *
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
 
     DCUWTScnFmt     E DS                  EXTNAME(SDCUWTPD)
      ** Customer Withholding Tax details in screen format
 
      **-----------------------------------------------------------------------
      ** File formats
      **-----------------------------------------------------------------------
 
     DCUWTFilFmt     E DS                  EXTNAME(SDVCUWTPD)
      ** Customer Withholding Tax Details in valid file format
      **-----------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0
 
      ** Entry parameters
     D AuthComp        S              1A
     D FwdBck          S              1A
     D DDCSNO_In       S              6A
     D Buffer          S           6000A
     D APIRetc         S              1A
 
      ** Parameters for call to SDCUWTRED
     D PRDFWD          S              1A
     D PRDBCK          S              1A
     D PERRMS          S              7A
     D PCSRED          S              6A
 
      ** Parameters for call to SDCUWTRED
     D ModeofOp        S              6A
     D APRESPMODE      S              1A
     D DDACTNOK        S              1A
     D DDCSNOOK        S              1A
 
      ** Work variables
     D @Timestamp      S             26A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      **-----------------------------------------------------------------------
      ** +--- Start of main processing -----------------------------------+
 
     C     *ENTRY        PLIST
     C                   PARM                    AuthComp
     C                   PARM                    FwdBck
 
      ** This should be a string containing all the keys fields
      ** required to identify your record
 
     C                   PARM                    DDCSNO_In
     C                   PARM                    Buffer
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetc
 
      ** Set up the name of the primary and secondary message files
      ** from which the message handler will get the messages
 
     C                   EVAL      MsgFArray(1) = 'SDUSRMSG'
     C                   EVAL      MsgFArray(2) = 'DRSMM'
 
      ** Hook to enable non-core message files to be included
 
     C/COPY WNCPYSRC,SDCUWTM02
 
      ** If the action code is blank, enquire unless authorising
 
     C                   CLEAR                   CUWTFilFmt
     C     DDACTN        IFEQ      *BLANK
     C     AuthComp      IFEQ      'X'
     C                   MOVEL     'X'           DDACTN
     C                   ELSE
     C                   MOVEL     'E'           DDACTN
     C                   ENDIF
     C                   ENDIF
 
     C     FwdBck        IFEQ      'F'
     C                   MOVEL     'Y'           PRDFWD
     C                   MOVEL     'N'           PRDBCK
     C                   ELSE
     C     FwdBck        IFEQ      'B'
     C                   MOVEL     'N'           PRDFWD
     C                   MOVEL     'Y'           PRDBCK
     C                   ELSE
     C                   MOVEL     'N'           PRDFWD
     C                   MOVEL     'N'           PRDBCK
     C                   ENDIF
     C                   ENDIF
 
     C     PRDFWD        IFEQ      'Y'
     C     PRDBCK        OREQ      'Y'
     C                   EXSR      SDCUWTRED
     C                   ELSE
 
      ** Move all the key fields required here to the @XXXX Format
 
     C                   MOVEL     DDCSNO_In     PCSRED
     C                   MOVEL     *BLANK        PERRMS
     C                   ENDIF
 
      ** If Cus. Number read and no error message returned
 
     C                   IF        PERRMS = *BLANK and
     C                             PCSRED <> *Blank
 
      ** Retrieve Customer Withholding Tax details (all key fields
      ** required for call to rtv module)
 
     C                   MOVEL     PCSRED        DDCSNO
     C                   EXSR      SDCUWTRTV
 
      ** Convert to screeen format
 
     C     Idx           IFEQ      0
     C                   EXSR      SDCUWTCVT
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   IF        PERRMS <> *BLANK
     C                   MOVEL     '0'           APIRetc
     C                   MOVEL     'DDCSNO'      FldNameArr(1)
     C                   MOVEL     PERRMS        MsgIDArr(1)
     C                   ENDIF
 
      ** Build buffer with required output
 
     C                   MOVE      WTTMST        @TimeStamp
     C                   EVAL      Buffer = @TimeStamp
     C                                      + CUWTScnFmt
 
     C                   MOVE      *ON           *INLR
     C                   RETURN
 
      *****************************************************************
      *                                                               *
      *   SDCUWTRED - Customer Withholding Tax Details Read           *
      *                                                               *
      *****************************************************************
     C     SDCUWTRED     BEGSR
      *
     C                   RESET                   RetCodeOut
      *
     C                   CALLB     'SDCUWTRED'
 
      ** INPUT PARAMETERS
      ** Return Code
 
     C                   PARM      *BLANK        RetCodeOut
 
      ** Action Code
 
     C                   PARM                    DDACTN
 
      ** Customer Number
 
     C                   PARM      DDCSNO_In     DDCSNO
 
      ** Read Forwards
 
     C                   PARM                    PRDFWD
 
      ** Read Backwards
 
     C                   PARM                    PRDBCK
 
      ** OUTPUT PARAMETERS
      ** Error Message
 
     C                   PARM      *BLANK        PERRMS
 
      * Customer Number READ
 
     C                   PARM      *BLANK        PCSRED
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *   SDCUWTRTV - Retrieve Customer Withholding Tax Details       *
      *                                                               *
      *****************************************************************
     C     SDCUWTRTV     BEGSR
      *
     C                   RESET                   RetCodeOut
      *
     C                   CALLB     'SDCUWTRTV'
 
      ** INPUTS
      ** Return code
 
     C                   PARM                    ReturnCode
 
      ** Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ** Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
 
     C                   PARM                    ModeofOp
 
      ** Response mode
 
     C                   PARM      'S'           APRESPMODE
 
      ** Action Code
 
     C                   PARM                    DDACTN
 
      ** Customer Number
 
     C                   PARM                    DDCSNO
 
      ** Securities Classifications
 
     C                   PARM      'D'           DDCLAS
 
      ** OUTPUTS
      ** (Current) Withholding Details in valid file format
 
     C                   PARM                    CUWTFilFmt
 
      ** OK - Action code
 
     C                   PARM                    DDACTNOK
 
      ** OK - Customer Number
 
     C                   PARM                    DDCSNOOK
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM                    Idx
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *   SDCUWTCVT - Convert to screen format                        *
      *                                                               *
      *****************************************************************
     C     SDCUWTCVT     BEGSR
 
     C                   RESET                   RetCodeOut
      *
     C                   CALLB     'SDCUWTCVT'
 
      ** INPUTS
      ** Return Code
 
     C                   PARM                    ReturnCode
 
      ** (Current) Withholding Tax in valid file format
 
     C                   PARM                    CUWTFilFmt
 
      ** OUTPUTS
      ** (Current) Withholding Tax in screen format
 
     C                   PARM                    CUWTScnfmt
 
      ** Amend Checking
 
     C                   RESET                   ReturnCode
 
     C                   ENDSR
      ****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, excluding a bound call to the DBERRCTL module.
      *********************************************************************
     C/COPY ZACPYSRC,PSSR_ILENE
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2007
