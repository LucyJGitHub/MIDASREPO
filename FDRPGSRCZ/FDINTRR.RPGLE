     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FD MM Int. Rates Retrieve')
      *****************************************************************
      *                                                               *
      *  Midas - Fixed Data Module                                    *
      *                                                               *
      *  FDINTRR   - FD MM Interest Rates  retrieve a record          *
      *                                                               *
      *  Function:  This module retrieves a record from the file      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. BUG4469            Date 06Oct04               *
      *  Prev Amend No. CAP084  *CREATE    Date 04Jan04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG4469- Stopping changes being overwritten by other user    *
      *           when try to amend the record at the same time by    *
      *           passing the Timestamp out to API.                   *
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
 
     D IntrScnFmt    E DS                  EXTNAME(FDINTRPD)
      * MM Rates in screen format
 
      **-----------------------------------------------------------------------
      ** File formats
      **-----------------------------------------------------------------------
 
     D IntrFilFmt    E DS                  EXTNAME(FDVINTRPD)
      ** MM Rates in file format
 
     D ValWrkFlds    E DS                  EXTNAME(FDWINTRPD)
      ** Interest Rates Validation Workfields
 
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
     C                   PARM                    DDCYCD_In         3
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
     C/COPY WNCPYSRC,FDINTRM02
 
      * If the action code is blank, enquire unless authorising
     C                   CLEAR                   IntrFilFmt
     C                   CLEAR                   IntrScnFmt
 
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
     C                   EXSR      FDINTRRED
     C                   ELSE
     C                   MOVEL     DDCYCD_In     @CYCDRed
     C                   MOVEL     *BLANK        @ERRMS
     C                   ENDIF
      *
      * If currency read and no error message returned
     C                   IF        @ERRMS = *BLANK and
     C                             @CYCDRed <> *Blank
      *
      * Retrieve interest details (all key fields required for call to rtv module)
     C                   MOVEL     @CYCDRed      DDCYCD
     C                   EXSR      FDINTRRTV
      *
      * Convert to screeen format
     C     Idx           IFEQ      0
     C                   EXSR      FDINTRCVT
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        ReturnCode <> *BLANK
     C                   MOVEL     '0'           APIRetc
     C                   MOVEL     'DDCYCD'      FldNameArr(1)
     C                   MOVEL     @ERRMS        MsgIDArr(1)
     C                   ENDIF
 
      * Build buffer with required output
     C                   MOVE      FYTMESTMP     @TimeStamp       26                         BUG4469
     C                   EVAL                    Buffer = IntrScnFmt
     C                                                     + @TimeStamp                      BUG4469
 
     C                   SETON                                        LR
     C                   RETURN
      **********************************************************************
     C     FDINTRRED     BEGSR
      *
     C                   RESET                   RetCodeOut
      *
     C                   CALLB     'FDINTRRED'
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * ACTION CODE
     C                   PARM                    DDACTN            1
      *
      * CURRENCY CODE
     C                   PARM      DDCYCD_In     DDCYCD            3
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
     C                   PARM      *BLANK        @CYCDRed          3
 
     C                   ENDSR
      **********************************************************************
     C     FDINTRRTV     BEGSR
 
     C                   RESET                   RetCodeOut
      *
     C                   MOVEL     *BLANKS       ValWrkFlds
      *
     C                   CALLB     'FDINTRRTV'
 
      * INPUTS
 
      * Return code
     C                   PARM      *BLANKS       ReturnCode
 
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM                    ModeofOp          6
      *
      * Response mode
     C                   PARM      'S'           APRESPMODE        1
 
      * Action Code
     C                   PARM                    DDACTN            1
 
      * Parm all Key fields required e.g.
     C                   PARM                    DDCYCD            3
 
      * Currency name
     C                   PARM                    DDCYNM           32
 
      * Front Office Id
     C                   PARM                    PFOTRID           2 0
 
      * OUTPUTS
 
      * Interest details in file format
     C                   PARM                    IntrFilFmt
 
      * OK - Action code
     C                   PARM                    DDActnOK          1
 
      * OK - Currency code
     C                   PARM                    DDCycdOK          1
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
 
      * Validation workfields
     C                   PARM                    ValWrkFlds
 
 
     C                   ENDSR
      **********************************************************************
     C     FDINTRCVT     BEGSR
 
     C                   RESET                   RetCodeOut
      *
     C                   MOVEL     *BLANKS       IntrScnFmt
      *
     C                   CALLB     'FDINTRCVT'
      *
      * INPUTS
      * Return Code
     C                   PARM                    ReturnCode
      * Interest Rates in file format
     C                   PARM                    IntrFilFmt
 
      * Interest Rates in screen format
     C                   PARM                    IntrScnFmt
 
      * Interest Rates validation fields
     C                   PARM                    ValWrkFlds
 
      * OUTPUTS
      * Interest Rate in screen format
     C                   PARM                    IntrScnFmt
      *
     C                   MOVEL     DDCYCD        DDCCY
 
      ** AMEND CHECKING
     C                   RESET                   ReturnCode
 
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
**  CPY@
(c) Misys International Banking Systems Ltd. 2003
