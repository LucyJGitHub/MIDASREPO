     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FD Forward Rates Retrieve a record')
      *****************************************************************
      *                                                               *
      *  Midas - Fixed Data Module                                    *
      *                                                               *
      *  FDFWRTR - FD Forward Rates Retrieve a record                 *
      *                                                               *
      *  Function:  This module retrieves a record from the file      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. BUG1056            Date 06May04               *
      *  Prev Amend No. CAP084  *CREATE    Date 05Jan04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG1056 - Midas Plus API development.                        *
      *            Switch on APIRETC in subroutine *PSSR.             *
      *  CAP084 - Synchronous calling of APIs                         *
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
 
     D FwrtScnFmt    E DS                  EXTNAME(FDFWRTPD)
      * Forward rates in screen format
 
      **-----------------------------------------------------------------------
      ** File formats
      **-----------------------------------------------------------------------
 
     D FwrtFilFmt    E DS                  EXTNAME(FWDRTFE)
      ** Forward rates in file format
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
      **-----------------------------------------------------------------------
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0
 
      **-----------------------------------------------------------------------
      ** +--- Start of main processing -----------------------------------+
 
     C     *ENTRY        PLIST
     C                   PARM                    AuthComp          1
     C                   PARM                    FwdBck            1
     C                   PARM                    DDCCY_In          3
     C                   PARM                    Buffer         6000
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetc           1
 
      * Set up the name of the primary and secondary message files from
      * which the message handler will get the messages
     C                   EVAL      MsgFArray(1) = 'DRSMM'
 
      *  Hook to enable non-core message files to be included
     C/COPY WNCPYSRC,FDFWRTM02
 
      * If the action code is blank, enquire unless authorising
     C                   CLEAR                   FwrtFilFmt
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
     C                   EXSR      FDFWRTRED
     C                   ELSE
     C                   MOVEL     DDCCY_In      @CCYRED
     C                   MOVEL     *BLANK        @ERRMS
     C                   ENDIF
      *
      * If currency read and no error message returned
     C                   IF        ReturnCode = *BLANK and
     C                             @CCYRED <> *Blank
      *
      * Retrieve currency details (all key fields required for call to rtv module)
     C                   MOVEL     @CCYRED       DDCCY
     C                   EXSR      FDFWRTRTV
      *
      * Convert to screen format
     C     Idx           IFEQ      0
     C                   EXSR      FDFWRTCVT
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        ReturnCode <> *BLANK
     C                   MOVEL     '0'           APIRetc
     C                   MOVEL     'DDCCY'       FldNameArr(1)
     C                   MOVEL     @ERRMS        MsgIDArr(1)
     C                   ENDIF
 
      * Build buffer with required output
     C                   EVAL                    Buffer = FwrtScnFmt
 
     C                   SETON                                        LR
     C                   RETURN
      **********************************************************************
     C     FDFWRTRED     BEGSR
      *
     C                   RESET                   RetCodeOut
      *
     C                   CALLB     'FDFWRTRED'
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * ACTION CODE
     C                   PARM                    DDACTN            1
      *
      * CURRENCY POINTER
     C                   PARM      DDCCY_In      DDCCY             3
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
      * CURRENCY READ
     C                   PARM      *BLANK        @CCYRED           3
      *
 
     C                   ENDSR
      **********************************************************************
     C     FDFWRTRTV     BEGSR
 
     C                   RESET                   RetCodeOut
      *
     C                   CALLB     'FDFWRTRTV'
 
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
 
      * Parm all Key fields required e.g.
     C                   PARM                    DDCCY
 
      * Front Office Transaction Id
     C                   PARM                    FOTRID           20
 
      * OUTPUTS
 
      * Forward rates in file format
     C                   PARM                    FwrtFilFmt
 
      * OK - Action code
     C                   PARM                    DDActnOK          1
 
      * OK - Currency
     C                   PARM                    DDDccyOK          1
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
 
 
     C                   ENDSR
      **********************************************************************
     C     FDFWRTCVT     BEGSR
 
     C                   RESET                   RetCodeOut
      *
     C                   CALLB     'FDFWRTCVT'
 
      * INPUTS
      * Return Code
     C                   PARM                    ReturnCode
      * Forward rates in file format
     C                   PARM                    FwrtFilFmt
 
      * OUTPUTS
      * Forward rates in screen format
     C                   PARM                    FwrtScnfmt
 
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
     C                   EVAL      APIRETC = '0'                                             BUG1056
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2004
