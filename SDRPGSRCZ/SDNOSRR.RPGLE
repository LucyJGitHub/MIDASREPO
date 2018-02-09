     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Nostro Codes Details retrieve a record')               *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDNOSRR   - SD Nostro Code Details retrieve a record         *
      *                                                               *
      *  Function:  This module retrieves a record from the file      *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CDL094             Date 30May14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CRE026  *CREATE    Date 24May06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL094 - Enhance  Receive Settlement Instructions (Recompile)*
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
 
     D NosrScnFmt    E DS                  EXTNAME(SDNOSRPD)
      * Nostro Codes details in screen format
 
 
      **-----------------------------------------------------------------------
      ** File formats
      **-----------------------------------------------------------------------
 
 
     D NosrFilFmt    E DS                  EXTNAME(SDNostPD)
      ** Nostro Code Details in file format
      * Extra data in file format
     D ExtData       E DS                  EXTNAME(SDNVEXPD)
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
      * This should be a string containing all the keys fields required to identify your record
     C                   PARM                    DDCYCD_In         3
     C                   PARM                    DDNONB_In         2
     C                   PARM                    Buffer         6000
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetc           1
 
      * Set up the name of the primary and secondary message files from
      * which the message handler will get the messages
     C                   EVAL      MsgFArray(1) = 'SDUSRMSG'
     C                   EVAL      MsgFArray(2) = 'DRSMM'
 
      *  Hook to enable non-core message files to be included
     C/COPY WNCPYSRC,SDNOSRM02
 
      * If the action code is blank, enquire unless authorising
     C                   CLEAR                   NosrFilFmt
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
     C                   EXSR      SDNosrRED
     C                   ELSE
      ** MOVE ALL THE KEY FIELDS REQUIRED HERE TO THE @XXXX FORMAT
     C                   MOVEL     DDCYCD_In     @NCRED            3
     C                   MOVEL     DDNONB_In     @NNRED            2
     C                   MOVEL     *BLANK        @ERRMS            7
     C                   ENDIF
      *
      * If Nostro Detail read and no error message returned
     C                   IF        @ERRMS = *BLANK AND
     C                             @NCRED <> *Blank    AND
     C                             @NNRED <> *Blank
      *
      * Retrieve Nostro details (all key fields required for call to rtv module)
     C                   MOVEL     @NCRED        DDCYCD
     C                   MOVEL     @NNRED        DDNONB
     C                   EXSR      SDNosrRTV
      *
      * Convert to screeen format
     C     Idx           IFEQ      0
     C                   EXSR      SDNosrCVT
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        @ERRMS <> *BLANK
     C                   MOVEL     '0'           APIRetc
     C                   MOVEL     'DDNONB'      FldNameArr(1)
     C                   MOVEL     @ERRMS        MsgIDArr(1)
     C                   ENDIF
 
      * Build buffer with required output
     C                   MOVE      A7TMST        @TimeStamp       26
     C                   EVAL      Buffer = NosrScnFmt
     C                                      + @TimeStamp + EXTDATA
 
     C                   SETON                                        LR
     C                   RETURN
     ****************************************************************
     C     SDNOSRRED     BEGSR
      *
     C                   RESET                   RetCodeOut
      *
     C                   CALLB     'SDNOSRRED'
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * ACTION CODE
     C                   PARM                    DDACTN            1
      *
      * NOSTRO CURRENCY CODE POINTER
     C                   PARM      DDCYCD_In     DDCYCD            3
      * NOSTRO NUMBER POINTER
     C                   PARM      DDNONB_In     DDNONB            2
 
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
      * NOSTRO CURRENCY CODE READ
     C                   PARM      *BLANK        @NCRED            3
      * NOSTRO NUMBER READ
     C                   PARM      *BLANK        @NNRED            2
      *
      * Front Office ID READ
     C                   PARM      *BLANK        @FTRED           20
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
     C     SDNosrRTV     BEGSR
 
     C                   RESET                   RetCodeOut
      *
     C                   CALLB     'SDNOSRRTV'
 
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
     C                   PARM                    DDCYCD
 
     C                   PARM                    DDNONB
 
      * OUTPUTS
      * (Current) deal in file format
     C                   PARM                    NosrFilFmt
 
      * OK - Action code
     C                   PARM                    DDActnOK          1
 
      * OK - Nostro Currency code
     C                   PARM                    DDCycdOK          1
 
      * OK - Nostro Number
     C                   PARM                    DDNonbOK          1
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
 
 
     C                   ENDSR
      ****************************************************************
      /EJECT
     ****************************************************************
     C     SDNosrCVT     BEGSR
 
     C                   RESET                   RetCodeOut
      *
     C                   CALLB     'SDNOSRCVT'
     C
      * INPUTS
      * Return Code
     C                   PARM                    ReturnCode
      * (Current) Nostro Code Details in file format
     C                   PARM                    NosrFilFmt
 
      * OUTPUTS
      * (Current) Nostro Code Details in screen format
     C                   PARM                    NosrScnfmt
 
      ** AMEND CHECKING
     C                   RESET                   ReturnCode
 
     C                   ENDSR
      ****************************************************************
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
(c) Finastra International Limited 2006
