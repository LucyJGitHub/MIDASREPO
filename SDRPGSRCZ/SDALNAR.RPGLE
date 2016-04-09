     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Customer Alternative Names & Addr Dtls Retrieve.')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDALNAR   - SD Customer Alternative Names & Addresses Details*
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
      **---------------------------------------------------------------
      ** The following /COPY includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY includes the standard API declares:
     D/COPY ZACPYSRC,STDDECLARE
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
     D/COPY ZACPYSRC,ERR_ARRAYS
      **---------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      **---------------------------------------------------------------
      ** Screen formats
      **---------------------------------------------------------------
 
     D AlnaScnFmt    E DS                  EXTNAME(SDALNAPD)
      * Customer Alternative Names & Addresses details in screen format
 
 
      **---------------------------------------------------------------
      ** File formats
      **---------------------------------------------------------------
 
     D AlnaFilFmt    E DS                  EXTNAME(SDAltnPD)
      ** Customer Alternative Names & Addresses Details in file format
      * Extra data in file format
     D ExtData       E DS                  EXTNAME(SDAlEXPD)
 
      **---------------------------------------------------------------
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0
 
     D AuthComp        S              1A
     D FwdBck          S              1A
     D DDCUST_In       S              6A
     D DDADCD_In       S              1A
     D Buffer          S           6000A
     D APIRetc         S              1A
 
     D @TimeStamp      S             26A
 
     D @RDFWD          S              1A
     D @RDBCK          S              1A
     D @ERRMS          S              7A
     D @CNRED          S              6A
     D @ACRED          S              1A
     D @FTRED          S             20A
 
     D ModeofOp        S              6A
     D APRESPMODE      S              1A
     D DDActnOK        S              1A
     D DDCustOK        S              1A
     D DDAdcdOK        S              1A
 
      **---------------------------------------------------------------
      ** +--- Start of main processing -------------------------------+
 
     C     *ENTRY        PLIST
     C                   PARM                    AuthComp
     C                   PARM                    FwdBck
      ** This should be a string containing all the keys fields
      ** required to identify your record
     C                   PARM                    DDCUST_In
     C                   PARM                    DDADCD_In
     C                   PARM                    Buffer
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetc
 
      * Set up the name of the primary and secondary message files from
      * which the message handler will get the messages
     C                   EVAL      MsgFArray(1) = 'SDUSRMSG'
     C                   EVAL      MsgFArray(2) = 'DRSMM'
 
      *  Hook to enable non-core message files to be included
     C/COPY WNCPYSRC,SDALNAM02
 
      * If the action code is blank, enquire unless authorising
     C                   CLEAR                   AlnaFilFmt
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
     C                   EXSR      SDAlnaRED
     C                   ELSE
      ** MOVE ALL THE KEY FIELDS REQUIRED HERE TO THE @XXXX FORMAT
     C                   MOVEL     DDCUST_In     @CNRED
     C                   MOVEL     DDADCD_In     @ACRED
     C                   MOVEL     *BLANK        @ERRMS
     C                   ENDIF
      *
      * If Name & Address read and no error message returned
     C                   IF        @ERRMS = *BLANK and
     C                             @CNRED <> *Blank   And
     C                             @ACRED <> *Blank
      *
      ** Retrieve Customer Alternative Names & Addresses details
      ** (all key fields required for call to rtv module)
     C                   MOVEL     @CNRED        DDCUST
     C                   MOVEL     @ACRED        DDADCD
     C                   EXSR      SDAlnaRTV
      *
      * Convert to screeen format
     C     Idx           IFEQ      0
     C                   EXSR      SDAlnaCVT
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        @ERRMS <> *BLANK
     C                   MOVEL     '0'           APIRetc
     C                   MOVEL     'DDCUST'      FldNameArr(1)
     C                   MOVEL     @ERRMS        MsgIDArr(1)
     C                   ENDIF
 
      * Build buffer with required output
     C                   MOVE      BCTMST        @TimeStamp
     C                   EVAL      Buffer = AlnaScnFmt
     C                                      + @TimeStamp + EXTDATA
 
     C                   SETON                                        LR
     C                   RETURN
      *****************************************************************
      *                                                               *
      * SDALNARED - Customer Alternative Names & Addresses Details    *
      *                                                               *
      *****************************************************************
     C     SDALNARED     BEGSR
      *
     C                   RESET                   RetCodeOut
      *
     C                   CALLB     'SDALNARED'
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * ACTION CODE
     C                   PARM                    DDACTN
      *
      * Customer Number
     C                   PARM      DDCUST_In     DDCUST
      * Address Code
     C                   PARM      DDADCD_In     DDADCD
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
      * Customer Number READ
     C                   PARM      *BLANK        @CNRED
      * Address Code READ
     C                   PARM      *BLANK        @ACRED
      *
      * Front Office ID READ
     C                   PARM      *BLANK        @FTRED
 
     C                   ENDSR
      *****************************************************************
      /Eject
      *****************************************************************
      *                                                               *
      *SDAlnaRTV -Retrieve Customer Alternative Names & Addresses     *
      *Detail                                                         *
      *                                                               *
      *****************************************************************
     C     SDAlnaRTV     BEGSR
 
     C                   RESET                   RetCodeOut
      *
     C                   CALLB     'SDALNARTV'
 
      * INPUTS
 
      * Return code
     C                   PARM                    ReturnCode
 
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM                    ModeofOp
      *
      * Response mode
     C                   PARM      'S'           APRESPMODE
 
      * Action Code
      * Action Code
     C                   PARM                    DDACTN
 
      * Front office id
     C                   PARM                    @FTRED
 
      * Parm all Key fields required e.g.
     C                   PARM                    DDCUST
     C                   PARM                    DDADCD
 
      * OUTPUTS
 
      * (Current) deal in file format
     C                   PARM                    AlnaFilFmt
 
      * OK - Action code
     C                   PARM                    DDActnOK
 
      * OK - Customer Number
     C                   PARM                    DDCustOK
      * OK - Address Code
     C                   PARM                    DDAdcdOK
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
 
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *SDAlnaCVT -Convert to screen format                            *
      *                                                               *
      *****************************************************************
     C     SDAlnaCVT     BEGSR
 
     C                   RESET                   RetCodeOut
      *
     C                   CALLB     'SDALNACVT'
 
      * INPUTS
      * Return Code
     C                   PARM                    ReturnCode
      * (Current) Deal in file format
     C                   PARM                    AlnaFilFmt
 
      * OUTPUTS
      * (Current) Deal in screen format
     C                   PARM                    AlnaScnfmt
 
      ** AMEND CHECKING
     C                   RESET                   ReturnCode
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ** The following /COPY contains the standard program status
      ** subroutine, excluding a bound call to the DBERRCTL module
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILENE
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2006
