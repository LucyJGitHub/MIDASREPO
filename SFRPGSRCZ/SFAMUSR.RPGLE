     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('User Maintenance + Menu Items Details retrieve rec')
      *****************************************************************
      *                                                               *
      *  Midas - Security Profile Function ILE Module                 *
      *                                                               *
      *  SFAMUSR   - SF User Maintenance + Menu Items Details         *
      *              retrieve a record                                *
      *                                                               *
      *  Function:  This module retrieves a record from the file      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. CRE026  *CREATE    Date 24May06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE026 - Consumer Banking                                    *
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
 
     D AMUSScnFmt    E DS                  EXTNAME(SFAMUSPD)
      * User Definition + Menu Items details in screen format
     D BBRCScnFmt    E DS                  EXTNAME(SFBBRCPD)
     D                                     PREFIX(B1)
      * User Booking Branch details in screen format
     D OBRCScnFmt    E DS                  EXTNAME(SFOBRCPD)
     D                                     PREFIX(O1)
      * User Originating Branch details in screen format
     D COMPScnFmt    E DS                  EXTNAME(SFCOMPPD)
     D                                     PREFIX(C1)
      * User Companies details in screen format
 
 
      **-----------------------------------------------------------------------
      ** File formats
      **-----------------------------------------------------------------------
 
     D AMUSFilFmt    E DS                  EXTNAME(MUSERDD)
      ** User Maintenance + Menu Items Details in file format
     D BBRCFilFmt    E DS                  EXTNAME(MBRBSDD)
     D                                     PREFIX(B_)
      ** User Booking Branch Details in file format
     D OBRCFilFmt    E DS                  EXTNAME(MBROSDD)
     D                                     PREFIX(O_)
      ** User Originating Branch Details in file format
     D COMPFilFmt    E DS                  EXTNAME(MCMPSDD)
     D                                     PREFIX(C_)
      ** User Companies Details in file format
      *
     D ExtData       E DS                  EXTNAME(SFUSEXPD)
      ** User Extra Data File Layout
 
      **-----------------------------------------------------------------------
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0
      * Total Buffer for Screen Formats
     D BufferX         S          10000
 
      **-----------------------------------------------------------------------
      ** +--- Start of main processing -----------------------------------+
 
     C     *ENTRY        PLIST
     C                   PARM                    AuthComp          1
     C                   PARM                    FwdBck            1
      * This should be a string containing all the keys fields required to identify your record
     C                   PARM                    DDUSRP_In        10
     C                   PARM                    Buffer         6000
     C                   PARM                    Buffer2        3999
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetc           1
 
      * Set up the name of the primary and secondary message files from
      * which the message handler will get the messages
     C                   EVAL      MsgFArray(1) = 'SFUSRMSG'
     C                   EVAL      MsgFArray(2) = 'DRSMM'
 
      *  Hook to enable non-core message files to be included
     C/COPY WNCPYSRC,SFAMUSM02
 
      * If the action code is blank, enquire unless authorising
     C                   CLEAR                   AMUSFilFmt
     C                   CLEAR                   BBRCFilFmt
     C                   CLEAR                   OBRCFilFmt
     C                   CLEAR                   COMPFilFmt
      *
     C     DDACTN        IFEQ      *BLANK
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
     C                   EXSR      SFAMUSRED
     C                   ELSE
      ** MOVE ALL THE KEY FIELDS REQUIRED HERE TO THE @XXXX FORMAT
     C                   MOVEL     DDUSRP_In     @USRED           10
     C                   MOVEL     *BLANK        @ERRMS            7
     C                   ENDIF
      *
      * If User Detail read and no error message returned
     C                   IF        @ERRMS = *BLANK and
     C                             @USRED <> *Blank
      *
      * Retrieve User details (all key fields required for call to rtv module)
     C                   MOVEL     @USRED        DDUSRP
     C                   EXSR      SFAMUSRTV
 
      *
      * Convert to screeen format
     C     Idx           IFEQ      0
     C                   EXSR      SFAMUSCVT
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   IF        @ERRMS <> *BLANK
     C                   MOVEL     '0'           APIRetc
     C                   MOVEL     'DDUSRP'      FldNameArr(1)
     C                   MOVEL     @ERRMS        MsgIDArr(1)
     C                   ENDIF
 
      * Build buffer with required output
     C                   MOVE      USTMST        @TimeStamp       26
     C                   EVAL      BufferX = AMUSScnFmt + BBRCScnFmt
     C                                     + OBRCScnFmt + COMPScnFmt
     C                                     + @TimeStamp + EXTDATA
     C                   EVAL      Buffer  = %SUBST(BufferX:1:6000)
     C                   EVAL      Buffer2 = %SUBST(BufferX:6001:3999)
 
     C                   SETON                                        LR
     C                   RETURN
      ****************************************************************
     C     SFAMUSRED     BEGSR
      *
     C                   RESET                   RetCodeOut
      *
     C                   CALLB     'SFAMUSRED'
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * ACTION CODE
     C                   PARM                    DDACTN            1
      *
      * USER POINTER
     C                   PARM      DDUSRP_In     DDUSRP           10
      *
      * READ FORWARDS
     C                   PARM                    @RDFWD            1
      *
      * READ BACKWARDS
     C                   PARM                    @RDBCK            1
      *
      * OUTPUT PARAMETERS
      *
      * ERROR MESSAGE
     C                   PARM      *BLANK        @ERRMS            7
      *
      * USER READ
     C                   PARM      *BLANK        @USRED           10
      * Front Office ID READ
     C                   PARM      *BLANK        @FTRED           20
      *
     C                   ENDSR
      /EJECT
     *****************************************************************
     C     SFAMUSRTV     BEGSR
 
     C                   RESET                   RetCodeOut
      *
     C                   CALLB     'SFAMUSRTV'
 
      * INPUTS
 
      * Return code
     C                   PARM                    ReturnCode
 
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM                    ModeofOp          6
      *
      * Response mode
     C                   PARM      'S'           APRESPMODE        1
 
      * Action Code
     C                   PARM                    DDACTN            1
 
      * Front Office Transaction Office ID
     C                   PARM                    @FTRED           20
 
      * Parm all Key fields required e.g.
     C                   PARM                    DDUSRP
      * User Security Level
     C                   PARM                    DDSECL
      *
      * OUTPUTS
 
      * (Current) User Definition + Menu Item in file format
     C                   PARM                    AMUSFilFmt
      * (Current) User Booking Branch in file format
     C                   PARM                    BBRCFilFmt
      * (Current) User Originating Branch in file format
     C                   PARM                    OBRCFilFmt
      * (Current) User Companies in file format
     C                   PARM                    COMPFilFmt
 
      * OK - Action code
     C                   PARM                    DDActnOK          1
 
      * OK - User code
     C                   PARM                    DDUsrpOK          1
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
 
 
     C                   ENDSR
 
     ***************************************************************
      /EJECT
     ***************************************************************
     C     SFAMUSCVT     BEGSR
 
     C                   RESET                   RetCodeOut
      *
     C                   CALLB     'SFAMUSCVT'
 
      * INPUTS
      * Return Code
     C                   PARM                    ReturnCode
      * (Current) User Maintenance + Menu Items Details in file
      * format
     C                   PARM                    AMUSFilFmt
      * (Current) User Booking Branch Details in file format
     C                   PARM                    BBRCFilFmt
      * (Current) User Originating Branch Details in file format
     C                   PARM                    OBRCFilFmt
      * (Current) User Companies Details in file format
     C                   PARM                    COMPFilFmt
 
      * OUTPUTS
      * (Current) User Maintenance + Menu Items Details in screen
      * format
     C                   PARM                    AMUSScnfmt
      * (Current) User Booking Branch Details in Screen format
     C                   PARM                    BBRCScnFmt
      * (Current) User Originating Branch Details in Screen format
     C                   PARM                    OBRCScnFmt
      * (Current) User Companies Details in Screen format
     C                   PARM                    COMPScnFmt
 
      ** AMEND CHECKING
     C                   RESET                   ReturnCode
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      **********************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, excluding a bound call to the DBERRCTL module.
      *********************************************************************
     C/COPY ZACPYSRC,PSSR_ILENE
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2006
