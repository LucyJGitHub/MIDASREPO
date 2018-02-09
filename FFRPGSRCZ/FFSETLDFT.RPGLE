     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Settlement instructions defaulting')          *
      *****************************************************************
      *                                                               *
      *  Midas - Financial Futures and Options module                 *
      *                                                               *
      *  FFSETLDFT - Apply default settlement instructions and        *
      *               charges and commision details.                  *
      *                                                               *
      *  Function:  This module retrieves the default settlement      *
      *             instructions and charges and commission details   *
      *             for a transaction's customer or broker, and       *
      *             applies them to the transaction format.           *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CSD095             Date 08Apr14               *
      *                 CAP208             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 BG9185             Date 08Nov05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CDL031             Date 05Dec04               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 147775             Date 16Nov98               *
      *                 CAP004  *CREATE    Date 01Aug98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
      *           (Recompile)                                         *
      *  CAP208 - F&O Market Instrument API (Recompile)               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BG9185 - Correction to CGL029 (Recompile)                    *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CDL031 - Effective Date on Extended SSI (Recompile)          *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  147775 - General FF API fixes - (Pre-release unnanotated)    *
      *  CAP004 - Conversion of Midas inputs to APIs.                 *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Customer/broker instrument defaults
     FDEFLT     IF   E           K DISK
 
      ** Extended settlement instructions
     FSDEXSTL1  IF   E           K DISK                                         073714
 
      ** Futures and Options clients
     FFOCLT     IF   E           K DISK
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structure.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** +--- Named indicators -------------------------------------------+
      ** ¦                                                                ¦
      ** ¦ Map variable names to indicators to allow use of names instead ¦
      ** ¦ of numbers; base the following data structure on a pointer to  ¦
      ** ¦ the indicator array.                                           ¦
     D Indicators      DS                  BASED(pIndicator)
      ** ¦                                                                ¦
     D  NoRecEXST             97     97
      ** ¦                                                                ¦
     D  NoRecFOCLT            98     98
      ** ¦                                                                ¦
     D  NoRecDEFLT            99     99
      ** ¦                                                                ¦
      ** ¦                                                                ¦
      ** ¦ Set the indicator array pointer                                ¦
     D pIndicator      S               *   INZ(%Addr(*In))
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     D BrokIns       E DS                  EXTNAME(FFBSETPD)
      ** Broker settlement instructions
 
     D CustIns       E DS                  EXTNAME(FFCSETPD)
      ** Customer settlement instructions
 
     D InstTypes     E DS                  EXTNAME(INTYPD)
      ** Instrument types
     D ITRECI        E                     EXTFLD(RECI)
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Flag indicating whether details for customer or broker are
      ** required.
     D CustBrokFl      S              1A
 
      ** Customer or broker number
     D*CustBrokNo      S              6S 0                                                    CSD027
     D CustBrokNo      S              6A                                                      CSD027
 
      ** Market centre
     D MarketCent      S              2A
 
      ** Instrument code
     D InstCode        S              3A
 
      ** Enhanced OTCs feature flag
     D CFF001          S              1A
 
      ** Transaction type (purchase or sale)
     D STRTY           S              1A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
     IFOCLTDF
     I              RECI                        FORECI
     I              SETP                        FOSETP
     I              SETA                        FOSETA
     I              FACO                        FOFACO
     I              CNOS                        FOCNOS
     I              SEBR                        FOSEBR
 
     C     Start         TAG
      ** Note: the above tag is only there to force the first comments in
      ** the C-specs to appear after the D- or I-specs in compiled listings.
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
 
      ** Do the intial processing for this transaction
     C                   EXSR      Initial
 
      ** Proceed according to whether customer or broker instructions
      ** are required
     C                   SELECT
      **                 ------
 
     C                   WHEN      CustBrokFl = 'B'
     C                   EXSR      Broker
 
     C                   WHEN      CustBrokFl = 'C'
     C                   EXSR      Customer
 
     C                   ENDSL
 
      **--------------------------------------------------------------------------------------------
      ** The return code is set in the following /COPY:
     C/COPY ZACPYSRC,SETRETCDE
      **--------------------------------------------------------------------------------------------
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Broker - Processing when broker settlement instructions       *
      *          requested                                            *
      *                                                               *
      *****************************************************************
 
     C     Broker        BEGSR
 
      **   Instrument Defaults
      **   ~~~~~~~~~~~~~~~~~~~
      *
      **   LF/DEFLT record does not exist
      *
     C                   IF        NoRecDEFLT = True OR RECI <> 'D'
 
     C     BCPT          IFNE      ' '
     C                   MOVE      BCMC          SBCMC
     C                   MOVE      BCMS          SBCMS
     C                   ENDIF
 
     C     STRTY         IFEQ      'P'
 
     C     BCGP          IFNE      00
     C                   MOVE      BCGP          SBCHC
     C                   ENDIF
 
     C                   ELSE
      **                 (Else STRTY <> 'P')
 
     C     BCGS          IFNE      00
     C                   MOVE      BCGS          SBCHC
     C                   ENDIF
 
     C                   ENDIF
      **                 (End of "If STRTY = 'P'")
 
     C                   ELSE
      *
      **   Else LF/DEFLT record does exist
      *
      **   - 1. Commission details
     C     CPAT          IFNE      ' '
 
      **    (from LF/DEFLT)
     C                   MOVE      CMCD          SBCMC
     C                   MOVE      CMSD          SBCMS
 
     C                   ELSE
      **                 (Else CPAT = blanks)
 
      **    (from LF/INTYP)
     C     BCPT          IFNE      ' '
     C                   MOVE      BCMC          SBCMC
     C                   MOVE      BCMS          SBCMS
     C                   ENDIF
 
     C                   ENDIF
      **                 (End of "If CPAT <> blanks")
 
      **   - 2. Charge code (Purchase)
     C     STRTY         IFEQ      'P'
 
     C     CGEP          IFNE      00
      **    (from LF/DEFLT)
 
     C                   MOVE      CGEP          SBCHC
     C                   ELSE
      **                 (Else CGEP = 0)
 
      **    (from LF/INTYP)
     C     BCGP          IFNE      00
     C                   MOVE      BCGP          SBCHC
     C                   ENDIF
 
     C                   ENDIF
      **                 (End of "If CGEP <> 0")
 
      **   - 3. Charge code (Sale)
     C                   ELSE
      **                 (Else STRTY <> 'P')
 
     C     CGES          IFNE      00
      **    (from LF/DEFLT)
 
     C                   MOVE      CGES          SBCHC
     C                   ELSE
      **                 (Else CGES = 0)
 
      **    (from LF/INTYP)
     C     BCGS          IFNE      00
     C                   MOVE      BCGS          SBCHC
     C                   ENDIF
 
     C                   ENDIF
      **                 (End of "If CGES <> 0")
 
     C                   ENDIF
      **                 (End of "If STRTY = 'P')
 
     C                   ENDIF
      **                 (End of "If NoRecDEFLT = True OR RECI <> D")
 
      **   Settlement Defaults
      **   ~~~~~~~~~~~~~~~~~~~
     C                   IF        NoRecDEFLT = False AND RECI = 'D'
     C                                                AND SETP <> 0
      **   - from LF/DEFLT
     C                   MOVE      SETP          SBSLT
     C                   MOVE      SETA          SBSLA
     C                   MOVE      FACO          SBFAO
     C                   MOVEL     CNOS          SBCPN
     C                   MOVE      SEBR          SBSBR                                         S0111
 
     C                   ELSE
      **                 (Else no record was found or SETP = 0)
 
      **   - from LF/FOCLT
     C                   MOVE      FOSETP        SBSLT
     C                   MOVE      FOSETA        SBSLA
     C                   MOVE      FOFACO        SBFAO
     C                   MOVEL     FOCNOS        SBCPN
     C                   MOVE      FOSEBR        SBSBR
 
     C                   ENDIF
      **                 (End of "If NoRecDEFLT = False AND SETP <> 0")
 
     C                   ENDSR
 
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Customer - Processing when customer settlement instructions   *
      *            requested                                          *
      *                                                               *
      *****************************************************************
 
     C     Customer      BEGSR
 
      **   Instrument Defaults
      **   ~~~~~~~~~~~~~~~~~~~
      *
      **   LF/DEFLT record does not exist
      *
     C                   IF        NoRecDEFLT = True OR RECI <> 'D'
 
      **   - from LF/INTYP
     C     CCPT          IFNE      ' '
     C                   MOVE      CCMC          SCCMC
     C                   MOVE      CCMS          SCCMS
     C                   ENDIF
 
     C     STRTY         IFEQ      'P'
     C     CCGP          IFNE      00
     C                   MOVE      CCGP          SCCHC
     C                   ENDIF
 
     C                   ELSE
      **                 (Else STRTY <> 'P')
 
     C     CCGS          IFNE      00
     C                   MOVE      CCGS          SCCHC
     C                   ENDIF
 
     C                   ENDIF
      **                 (End of "If STRTY = 'P'")
 
     C                   ELSE
      *
      **   Else LF/DEFLT record does exist
      *
      **   - 1. Commission details
     C     CPAT          IFNE      ' '
      **    (from LF/DEFLT)
     C                   MOVE      CMCD          SCCMC
     C                   MOVE      CMSD          SCCMS
      **
     C                   ELSE
      **                 (Else CPAT = blank)
 
      **    (from LF/INTYP)
     C     CCPT          IFNE      ' '
     C                   MOVE      CCMC          SCCMC
     C                   MOVE      CCMS          SCCMS
     C                   ENDIF
 
     C                   ENDIF
      **                 (End of "If CPAT <> blank)
 
      **   - 2. Charge code (Purchase)
     C     STRTY         IFEQ      'P'
 
     C     CGEP          IFNE      00
 
      **    (from LF/DEFLT)
     C                   MOVE      CGEP          SCCHC
     C                   ELSE
      **                 (Else CGEP = 0)
 
      **    (from LF/INTYP)
     C     CCGP          IFNE      00
     C                   MOVE      CCGP          SCCHC
     C                   ENDIF
 
     C                   ENDIF
      **                 (End of "If CGEP <> 0")
 
      **   - 3. Charge code (Sale)
     C                   ELSE
      **                 (Else STRTY <> 'P')
 
     C     CGES          IFNE      00
 
      **    (from LF/DEFLT)
     C                   MOVE      CGES          SCCHC
     C                   ELSE
      **                 (Else CGES = 0)
 
      **    (from LF/INTYP)
     C     CCGP          IFNE      00
     C                   MOVE      CCGS          SCCHC
     C                   ENDIF
 
     C                   ENDIF
      **                 (End of "If CGES <> 0")
 
     C                   ENDIF
      **                 (End of "If STRTY = 'P')
 
     C                   ENDIF
      **                 (End of "If NoRecDEFLT = True OR RECI <> D")
      **
 
      **   Settlement Defaults
      **   ~~~~~~~~~~~~~~~~~~~
     C                   IF        NoRecDEFLT = False AND RECI = 'D'
     C                                                AND SETP <> 0
 
      **   - from LF/DEFLT
     C                   MOVE      SETP          SCSLT
     C                   MOVE      SETA          SCSLA
     C                   MOVE      FACO          SCFAO
     C                   MOVEL     CNOS          SCCPN
     C                   MOVE      SEBR          SBRSC                                         S0111
 
     C                   ELSE
      **                 (Else no valid record or SETP = 0)
 
      **   - from LF/FOCLT
     C                   MOVE      FOSETP        SCSLT
     C                   MOVE      FOSETA        SCSLA
     C                   MOVE      FOFACO        SCFAO
     C                   MOVEL     FOCNOS        SCCPN
     C                   MOVE      FOSEBR        SBRSC
 
     C                   ENDIF
      **                 (End of "If NoRecDEFLT = False and RECI = 'D' and
      **                  SETP <> 0")
 
      ** For OTCS default settlement instructions
      ** if Enhanced OTC is present
     C                   IF        MarketCent = *blanks AND CFF001 = 'Y'
     C                   EXSR      DOTCST
     C                   ENDIF
 
     C                   ENDSR
 
      ********************************************************************
      /EJECT
      ********************************************************************
      **                                                                 *
      **   DOTCST SR. -  Default OTC Settlement Instructions             *
      **   ~~~~~~~~~                                                     *
      **                                                                 *
      **      Called From                  Calls                         *
      **       SR. ICUDFT                                                *
      **                                                                 *
      ********************************************************************
 
     C     DOTCST        BEGSR
 
      ** Access option transaction settlement instructions
     C                   MOVE      ISCY          BYCYCD
     C                   MOVE      CustBrokNo    BYCUST
     C                   MOVE      'OP'          BYTRTY
 
     C     KEXST         CHAIN     SDEXSTL1                           97
     C                   IF        NoRecEXST = False
 
      ** Pay instructions
     C     STRTY         IFEQ      'P'
     C                   MOVEL     BYPSTY        SCSLT
     C                   MOVEL     BYPONO        SCSLA
     C                   MOVEL     BYBYNB        SCFAO
     C                   MOVEL     BYACBN        SCCPN
     C                   ELSE
 
      ** Receive instructions
     C                   MOVEL     BYRSTY        SCSLT
     C                   MOVEL     BYRONO        SCSLA
     C                   MOVEL     *BLANK        SCFAO
     C                   MOVEL     BYRIBN        SCCPN
     C                   ENDIF
 
      ** Access 'ALL' transaction settlement instructions
     C                   ELSE
     C                   MOVE      'AT'          BYTRTY
 
     C     KEXST         CHAIN     SDEXSTL1                           97
 
     C                   IF        NoRecEXST = False
 
      ** Pay instructions
     C     STRTY         IFEQ      'P'
     C                   MOVEL     BYPSTY        SCSLT
     C                   MOVEL     BYPONO        SCSLA
     C                   MOVEL     BYBYNB        SCFAO
     C                   MOVEL     BYACBN        SCCPN
     C                   ELSE
 
      ** Receive instructions
     C                   MOVEL     BYRSTY        SCSLT
     C                   MOVEL     BYRONO        SCSLA
     C                   MOVEL     *BLANK        SCFAO
     C                   MOVEL     BYRIBN        SCCPN
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Initial - Initial processing for a transaction                *
      *                                                               *
      *****************************************************************
 
     C     Initial       BEGSR
 
     C                   CLEAR                   InstTypes
 
      ** Access the default instructions file.  The fields on the key
      ** list are received as parameters
     C     KDefault      CHAIN     DEFLT                              99
 
      ** If no record on the defaults file, return the values from the
      ** instruments file
     C                   IF        NoRecDEFLT = True OR RECI <> 'D'
 
      ** First retrieve the record from the instruments file, using the
      ** validation function for instruments
      ** If this call returns an error, just ignore it: this is not
      ** the place to validate settlement instructions.  But if there is
      ** an error, have to clear the instrument types structure, to
      ** prevent uninitialised zoned fields causing problems elsewhere
      ** in this module.
     C                   RESET                   ReturnCode
     C                   CALLB     'FFVMKTINS'
      ** Outputs from called procedure
      ** -----------------------------
      ** Return code
     C                   PARM                    ReturnCode
      ** Field name array
     C                   PARM                    FldNamXArr
      ** Error message ID array
     C                   PARM                    MsgIDXArr
      ** Error message data array
     C                   PARM                    MsgDtaXArr
      ** The instrument types format (data strucure)
     C                   PARM                    InstTypes
 
      ** Inputs to called procedure
      ** --------------------------
      ** Instrument type
     C                   PARM                    InstCode
      ** Market ID
     C                   PARM                    MarketCent
 
     C                   IF        ReturnCode <> *blanks
     C                   CLEAR                   InstTypes
     C                   ENDIF
 
     C                   ENDIF
 
      ** Access the Futures and Options clients file for broker or
      ** customer details as required.
     C     CustBrokNo    CHAIN     FOCLT                              98
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *inzsr        BEGSR
 
     C     *entry        PLIST
      ** Outputs from this procedure
      ** ---------------------------
      ** Return code (10A, returned to caller)
     C                   PARM                    ReturnCode
      ** Broker and customer settlement instructions in screen format
      ** (DSs based on FFBSETPD and FFCSETPD)
     C                   PARM                    BrokIns
     C                   PARM                    CustIns
 
      ** Inputs to this procedure
      ** ------------------------
      ** Customer/broker flag (1A)
     C                   PARM                    CustBrokFl
      ** Customer or broker number (6,0S)
     C                   PARM                    CustBrokNo
      ** Market centre (2A)
     C                   PARM                    MarketCent
      ** Instrument code (3A)
     C                   PARM                    InstCode
      ** Transaction type (purchase or sale) (1A)
     C                   PARM                    STRTY
      ** Enhanced OTCs feature flag (1A)
     C                   PARM                    CFF001
 
 
      ** Key list for LF/DEFLT
     C     KDefault      KLIST
     C                   KFLD                    CustBrokNo
     C                   KFLD                    MarketCent
     C                   KFLD                    InstCode
 
      ** Key list for LF/SDEXSTL1
     C     KEXST         KLIST                                                                 07371
     C                   KFLD                    BYCYCD                                        07371
     C                   KFLD                    BYCUST                                        07371
     C                   KFLD                    BYTRTY                                        07371
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      ********************************************************************
      /EJECT
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
