     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('SD Yield Rates Details retrieve a record')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDYRATR   - SD Yield Rates Details retrieve a record         *
      *                                                               *
      *  Function:  This module retrieves a record from the file      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No  CRE026  *CREATE    Date 24May06               *
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
 
     DCurTrYrat      E DS                  EXTNAME(SDYRATPD)
     D                                     PREFIX(C_)
      * Yield Rate details in screen format
 
 
      **-----------------------------------------------------------------------
      ** File formats
      **-----------------------------------------------------------------------
 
     D YratFilFmt    E DS                  EXTNAME(SDVYRATPD)
     D                                     PREFIX(V_)
      ** Yield Rates Details in file format
 
      * Extra data in file format
     D ExtData       E DS                  EXTNAME(SDYREXPD)
 
      ** Maturity Date
     D PMatAr          S              7    DIM(98)
      ** Maturity Date
     D PDFcAr          S             14    DIM(98)
      **-----------------------------------------------------------------------
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0
      *
 
      **-----------------------------------------------------------------------
      ** +--- Start of main processing -----------------------------------+
 
     C     *ENTRY        PLIST
     C                   PARM                    AuthComp          1
     C                   PARM                    FwdBck            1
      * This should be a string containing all the keys fields required to identify your record
     C                   PARM                    #0YLDC            5
     C                   PARM                    #0YCCY            3
     C                   PARM                    #0YICM            1
     C                   PARM                    #0YCFQ            1
     C                   PARM                    #0SPDY            2
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
     C/COPY WNCPYSRC,SDYratM02
 
      * If the action code is blank, enquire unless authorising
     C                   CLEAR                   YratFilFmt
     C     #0ACTN        IFEQ      *BLANK
     C     AuthComp      IFEQ      'X'
     C                   MOVEL     'X'           #0ACTN
     C                   ELSE
     C                   MOVEL     'E'           #0ACTN
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
     C                   EXSR      SDYratRED
      *
     C                   IF        @ERRMS = *BLANK
     C                   MOVEL     PKYLDC        @DCRED
     C                   MOVEL     PKYCCY        @CYRED
     C                   MOVEL     PKYICM        @CMRED
     C                   MOVEL     PKYCFQ        @FQRED
     C                   MOVEL     PKSPDY        @DYRED
     C                   ENDIF
      *
     C                   ELSE
      ** MOVE ALL THE KEY FIELDS REQUIRED HERE TO THE @XXXX FORMAT
     C                   MOVEL     #0YLDC        @DCRED            5
     C                   MOVEL     #0YCCY        @CYRED            3
     C                   MOVEL     #0YICM        @CMRED            1
     C                   MOVEL     #0YCFQ        @FQRED            1
     C                   MOVEL     #0SPDY        @DYRED            2
     C                   MOVEL     *BLANK        @ERRMS
     C                   ENDIF
      *
      * If Yield Rates read and no error message returned
     C                   IF        @ERRMS = *BLANK and
     C                             @DCRED <> *Blank  and
     C                             @CYRED <> *Blank  and
     C                             @CMRED <> *Blank  and
     C                             @FQRED <> *Blank
      * Retrieve Yield Rates details (all key fields required for call to rtv module)
     C                   MOVEL     @DCRED        #0YLDC
     C                   MOVEL     @CYRED        #0YCCY
     C                   MOVEL     @CMRED        #0YICM
     C                   MOVEL     @FQRED        #0YCFQ
     C                   MOVEL     @DYRED        #0SPDY
     C                   EXSR      SDYratRTV
 
      *
      * Convert to screeen format
     C     Idx           IFEQ      0
     C                   EXSR      SDYratCVT
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        @ERRMS <> *BLANK
     C                   MOVEL     '0'           APIRetc
     C                   MOVEL     '#0YLDC'      FldNameArr(1)
     C                   MOVEL     @ERRMS        MsgIDArr(1)
     C                   ENDIF
 
      * Build buffer with required output
     C                   MOVE      V_FSTMES      @TimeStamp       26
     C                   EVAL      Buffer = CurTrYrat
     C                                      + @TimeStamp + ExtData
 
     C                   SETON                                        LR
     C                   RETURN
      **********************************************************************
     C     SDYRATRED     BEGSR
     C                   MOVEL     #0ACTN        PKACTN            1
     C                   MOVEL     #0YLDC        PKYLDC            5
     C                   MOVEL     #0YCCY        PKYCCY            3
     C                   MOVEL     #0YICM        PKYICM            1
     C                   MOVEL     #0YCFQ        PKYCFQ            1
     C                   MOVEL     #0SPDY        PKSPDY            2
 
     C                   RESET                   RetCodeOut
      *
     C                   CALLB     'SDYRATRED'
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      ** ACTION CODE
     C                   PARM                    PKACTN
      **
      ** DEAL NUMBER POINTER
     C                   PARM                    PKYLDC
     C                   PARM                    PKYCCY
     C                   PARM                    PKYICM
     C                   PARM                    PKYCFQ
     C                   PARM                    PKSPDY
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
     C                   ENDSR
     ******************************************************************
     ****************************************************************
     C     SDYratRTV     BEGSR
 
     C                   RESET                   RetCodeOut
      *
     C                   CALLB     'SDYRATRTV'
 
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
     C                   PARM                    #0ACTN            1
 
      * Yield Curves
     C                   PARM                    #0YLDC
      * Yield Curves Currency
     C                   PARM                    #0YCCY
      * Yield Int Calc Method
     C                   PARM                    #0YICM
      * Yield Compounding Frequency
     C                   PARM                    #0YCFQ
      * Spot Days
     C                   PARM                    #0SPDY
      *
      * Front Office Transaction ID
     C                   PARM      V_FSFOTR      APFOTranID       20
      * OUTPUTS
 
      * (Current) deal in file format
     C                   PARM                    YratFilFmt
      *
      * OK - Action code
     C                   PARM                    OKACTN            1
      *
      * OK - Yield Curves
     C                   PARM                    OKYLDC            1
      *
      * OK - Yield Curve Currency
     C                   PARM                    OKYCCY            1
      *
      * OK - Yield Int Calc Method
     C                   PARM                    OKYICM            1
      *
      * OK - Yield Compounding Frequency
     C                   PARM                    OKYCFQ            1
      *
      * OK - Spot Days
     C                   PARM                    OKSPDY            1
      *
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
     C                   PARM      'N'           PKYCFQ
     C                   ENDSR
      ****************************************************************
      ***************************************************************
     C     SDYratCVT     BEGSR
 
     C                   RESET                   RetCodeOut
      *
     C                   CALLB     'SDYRATCVT'
 
      * INPUTS
      * Return Code
     C                   PARM                    ReturnCode
      * (Current) Deal in file format
     C                   PARM                    YratFilFmt
 
      * OUTPUTS
      * (Current) Deal in screen format
     C                   PARM                    CurTrYrat
     C                   PARM      *BLANKS       PMatAr
     C                   PARM      *BLANKS       PDFcAr
 
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
(c) Misys International Banking Systems Ltd. 2006
