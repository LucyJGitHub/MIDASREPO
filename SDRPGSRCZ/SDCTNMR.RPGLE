     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('SD Currency/Time of Netting Retrieve a Record')        *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDCTNMR   - SD Currency/Time of Netting Details              *
      *              Retrieve a Record                                *
      *                                                               *
      *  Function:  This module retrieves a record from the file      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. AR1086546 *CREATE  Date 19Jun13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR1086546 - Upgrade of CDL025 to MP1.4 (Child: AR1086547).   *
      *              Applied for MD021813                             *
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
 
     D CtnmScnFmt    E DS                  EXTNAME(SDCCTNPD)
      ** Currency/Time of Netting Details in screen format
 
      **-----------------------------------------------------------------------
      ** File formats
      **-----------------------------------------------------------------------
 
     D CtnmFilFmt    E DS                  EXTNAME(SDVCTNMPD)
      ** Currency/Time of Netting Details in file format
 
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
     D Fwdbck          S              1A
     D DDCUST_In       S              6A
     D Buffer          S           6000A
     D APIRetc         S              1A
 
     D PRDFWD          S              1A
     D PRDBCK          S              1A
     D PERRMS          S              7A
     D PCNRED          S              6A
 
     D ModeofOp        S              6A
     D Aprespmode      S              1A
     D From_Cust       S              1A
     D DDACTNOK        S              1A
     D DDCUSTOK        S              1A
 
      **-----------------------------------------------------------------------
      ** +--- Start of main processing -----------------------------------+
 
     C     *ENTRY        PLIST
     C                   PARM                    AuthComp
     C                   PARM                    FwdBck
     C                   PARM                    DDCUST_In
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
 
      ** If the action code is blank, enquire unless authorising
 
     C                   CLEAR                   CtnmFilFmt
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
     C                   EXSR      SDCTNMRED
     C                   ELSE
 
      ** Move all the Key Fields required here to the @XXXX Format
 
     C                   MOVEL     DDCUST_In     PCNRED
     C                   MOVEL     *BLANK        PERRMS
     C                   ENDIF
 
      ** If Currency/Time of Netting read and no error message
      ** returned
 
     C                   IF        PERRMS = *BLANK and
     C                             PCNRED <> *Blank
 
      ** Retrieve Currency/Time of Netting Details (all key
      ** fields required for call to rtv module)
 
     C                   MOVEL     PCNRED        DDCUST
     C                   EXSR      SDCTNMRTV
 
      ** Convert to screeen format
 
     C     Idx           IFEQ      0
     C                   EXSR      SDCTNMCVT
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        PERRMS <> *BLANK
     C                   MOVEL     '0'           APIRetc
     C                   MOVEL     'DDCUST'      FldNameArr(1)
     C                   MOVEL     PERRMS        MsgIDArr(1)
     C                   ENDIF
 
      ** Build buffer with required output
 
     C                   EVAL      Buffer = CtnmScnFmt
 
     C                   SETON                                        LR
     C                   RETURN
      *****************************************************************
      *                                                               *
      *  SDCTNMRED - Currency/Time of Netting Details Read            *
      *                                                               *
      *****************************************************************
     C     SDCTNMRED     BEGSR
 
     C                   RESET                   RetCodeOut
 
     C                   CALLB     'SDCTNMRED'
 
      * Input Parameters
      * Return Code
 
     C                   PARM      *BLANK        RetCodeOut
 
      ** Action Code
 
     C                   PARM                    DDACTN
 
      ** Customer Number
 
     C                   PARM      DDCUST_In     DDCUST
 
      ** Read Forwards
 
     C                   PARM                    PRDFWD
 
      ** Read Backwards
 
     C                   PARM                    PRDBCK
 
      ** Output Parameters
      ** Error Message
 
     C                   PARM      *BLANK        PERRMS
 
      ** Customer READ
 
     C                   PARM      *BLANK        PCNRED
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  SDCTNMRTV - Retrieve Currency/Time of Netting Details        *
      *                                                               *
      *****************************************************************
     C     SDCTNMRTV     BEGSR
 
     C                   RESET                   RetCodeOut
      *
     C                   CALLB     'SDCTNMRTV'
 
      ** Inputs
      ** Return code
 
     C                   PARM                    ReturnCode
 
      ** Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ** Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
 
     C                   PARM                    ModeofOp
 
      ** Response mode
 
     C                   PARM      'S'           APRESPMODE
 
      ** Action Code
 
     C                   PARM                    DDACTN
 
     C                   PARM                    DDCUST
 
      ** From Customer Flag
 
     C                   PARM      'N'           From_Cust
 
      ** OUTPUTS
      ** (Current) deal in file format
 
     C                   PARM                    CtnmFilFmt
 
      ** OK - Action code
 
     C                   PARM                    DDActnOK
 
      ** OK - Customer Number
 
     C                   PARM                    DDCustOK
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM                    Idx
 
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  SDCTNMCVT - Convert to screen format                         *
      *                                                               *
      *****************************************************************
     C     SDCTNMCVT     BEGSR
 
     C                   RESET                   RetCodeOut
      *
     C                   CALLB     'SDCTNMCVT'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    ReturnCode
 
      ** (Current) Deal in file format
 
     C                   PARM                    CtnmFilFmt
 
      ** Outputs
      ** (Current) Deal in screen format
 
     C                   PARM                    CtnmScnfmt
 
      ** Amend Checking
 
     C                   RESET                   ReturnCode
 
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
(c) Misys International Banking Systems Ltd. 2013
