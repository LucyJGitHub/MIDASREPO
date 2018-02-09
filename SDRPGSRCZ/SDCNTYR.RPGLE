     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Country Details retrieve a record')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDCNTYR   - SD Country Details retrieve a record             *
      *                                                               *
      *  Function:  This module retrieves a record from the file      *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. CRE026  *CREATE    Date 24May06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
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
 
     D CntyScnFmt    E DS                  EXTNAME(SDCNTYPD)
      * Country details in screen format
     D Ctx1ScnFmt    E DS                  EXTNAME(SDCNT3PD)
     D                                     PREFIX(S1_)
      * BCL Country details in screen format
     D Ctx2ScnFmt    E DS                  EXTNAME(SDCNT2PD)
     D                                     PREFIX(S2_)
      * Eur Country details in screen format
 
 
      **-----------------------------------------------------------------------
      ** File formats
      **-----------------------------------------------------------------------
 
     D CntyFilFmt    E DS                  EXTNAME(SDCtryPD)
      ** Country Details in file format
     D Ctx1FilFmt    E DS                  EXTNAME(SDCtx1PD)
      ** BCL Country Details in file format
     D Ctx2FilFmt    E DS                  EXTNAME(SDCtx2PD)
      ** Eur Country Details in file format
     D ExtData       E DS                  EXTNAME(SDCtEXPD)
      ** Extra data in format
 
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
     C                   PARM                    DDCNCD_In         2
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
     C/COPY WNCPYSRC,SDCNTYM02
 
      * If the action code is blank, enquire unless authorising
     C                   CLEAR                   CntyFilFmt
     C                   CLEAR                   Ctx1FilFmt
     C                   CLEAR                   Ctx2FilFmt
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
     C                   EXSR      SDCntyRED
     C                   ELSE
      ** MOVE ALL THE KEY FIELDS REQUIRED HERE TO THE @XXXX FORMAT
     C                   MOVEL     DDCNCD_In     @CNRED
     C                   MOVEL     *BLANK        @ERRMS
     C                   ENDIF
      *
      * If deal read and no error message returned
     C                   IF        @ERRMS = *BLANK and
     C                             @CNRED <> *Blank
      * Retrieve country details (all key fields required for call to
      * rtv module)
     C                   MOVEL     @CNRED        DDCNCD
     C                   EXSR      SDCntyRTV
 
      *
      * Convert to screeen format
     C     Idx           IFEQ      0
     C                   EXSR      SDCntyCVT
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        @ERRMS <> *BLANK
     C                   MOVEL     '0'           APIRetc
     C                   MOVEL     'DDCNCD'      FldNameArr(1)
     C                   MOVEL     @ERRMS        MsgIDArr(1)
     C                   ENDIF
 
      * Build buffer with required output
     C                   MOVE      A4TMST        @TimeStamp       26
     C                   EVAL      Buffer = CntyScnFmt + Ctx1ScnFmt
     C                                      + Ctx2ScnFmt
     C                                      + @TimeStamp + EXTDATA
 
     C                   SETON                                        LR
     C                   RETURN
     ****************************************************************
     C     SDCNTYRED     BEGSR
      *
     C                   RESET                   RetCodeOut
      *
     C                   CALLB     'SDCNTYRED'
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * ACTION CODE
     C                   PARM                    DDACTN            1
      *
      * Country code
     C                   PARM      DDCNCD_In     DDCNCD            2
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
      * COUNTRY CODE READ
     C                   PARM      *BLANK        @CNRED            2
      * Front Office ID READ
     C                   PARM      *BLANK        @FTRED           20
 
     C                   ENDSR
     ****************************************************************
     C     SDCntyRTV     BEGSR
 
     C                   RESET                   RetCodeOut
      *
     C                   CALLB     'SDCNTYRTV'
 
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
 
      * Front office id
     C                   PARM                    @FTRED           20
 
      * Parm all Key fields required e.g.
     C                   PARM                    DDCNCD
 
      * OUTPUTS
 
      * (Current) deal in file format
     C                   PARM                    CntyFilFmt
     C                   PARM                    Ctx1FilFmt
     C                   PARM                    Ctx2FilFmt
      * Extdata
     C                   PARM                    ExtData
 
      * OK - Action code
     C                   PARM                    DDActnOK          1
 
      * OK - Country code
     C                   PARM                    DDCncdOK          1
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
 
 
     C                   ENDSR
      ****************************************************************
      ****************************************************************
     C     SDCntyCVT     BEGSR
 
     C                   RESET                   RetCodeOut
      *
     C                   CALLB     'SDCNTYCVT'
 
      * INPUTS
      * Return Code
     C                   PARM                    ReturnCode
      * (Current) Deal in file format
     C                   PARM                    CntyFilFmt
     C                   PARM                    Ctx1FilFmt
     C                   PARM                    Ctx2FilFmt
 
      * OUTPUTS
      * (Current) Deal in screen format
     C                   PARM                    CntyScnfmt
     C                   PARM                    Ctx1Scnfmt
     C                   PARM                    Ctx2Scnfmt
 
      ** AMEND CHECKING
     C                   RESET                   ReturnCode
 
     C                   ENDSR
      ****************************************************************
      /EJECT
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
