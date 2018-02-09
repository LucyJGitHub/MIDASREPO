     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate Exchange Rate/Override Ind.')        *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVEXRT01  - Validate Exchange Rate, Exchange Rate Override  *
      *               Indicator, Payment Amount and Payment Currency  *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CRE075             Date 06Dec10               *
      *                 BUG27895           Date 14Jul10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG26243           Date 30Sep09               *
      *                 BUG24955           Date 15Jul09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG15067           Date 23Oct07               *
      *                 CSW207A            Date 29Jul07               *
      *                 CSW207             Date 08Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 221761             Date 01Apr04               *
      *                 CGL029             Date 01Sep03               *
      *                 220004             Date 24Jul03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185107             Date 17Oct00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CFT006  *CREATE    Date 01Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  BUG27895 - Serious midas error when confirm authorize an     *
      *             RFT type RI Incoming                              *
      *  BUG26243 - Serious midas error occur when authorizing        *
      *             RFTD transactions                                 *
      *  BUG24955 - Generated transaction is not inline with input    *
      *             validation                                        *
      *                                                               *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG15067 - Include currency validation for Outgoing Payment  *
      *  CSW207A - Swift 2007 Standard Changes Fix                    *
      *  CSW207 - SWIFT 2007 Changes                                  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  221761 - Recompiled due to change made in PF/FT101HPD.       *
      *  CGL029 - Increase Account Code to 10 digits (Recompile)      *
      *  220004 - Change call to AOCURRR0 to use DSSDY not DSFDY.     *
      *  185107 - Mapping of details from swift message - Recompile   *
      *  CFT006 - Funds Transfer addition of MT101 messages           *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** Program, procedure and module names for parameters
      ** ==================================================
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions parameter list
      ** for call to FT0010.
     D/COPY FTCPYSRC,FT0010D001
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
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      * Header record in screen format
     D HdrRcdIn      E DS                  EXTNAME(FT101HSPD)
     D  PSNDREF_H    E                     EXTFLD(PSNDREF)
 
      * Detail record in screen format
     D DtlRcdIn      E DS                  EXTNAME(FT101DSPD)
 
      ** External data structure for Bank standing data
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External data structure for Currency standing data
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** External data structure for Funds Transfer ICD
     D SDFTFR        E DS                  EXTNAME(SDFTFRPD)
 
      ** External data structure for access programs (short)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      * Incoming account details from access objects
     D AccRecord     E DS                  EXTNAME(ACCNTAB)
     D N@FMT         E DS                  EXTNAME(SDNOSTPD)
     D C@FMT         E DS                  EXTNAME(SDCUSTPD)
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      * OK Flags for second screen
     D OKFlags       E DS                  EXTNAME(FTE101S2PD)
 
      * DS to split account identifier into components
     D AccntCode       DS
     D  CustNo                 1      6
     D  P@CYCD                 7      9
     D  P@ACCD                10     19                                                       CGL029
     D  P@ACSN                20     21                                                       CGL029
     D  P@BRCA                22     24                                                       CGL029
     D**P@ACCD**              10     13                                                       CGL029
     D**P@ACSN**              14     15                                                       CGL029
     D**P@BRCA**              16     18                                                       CGL029
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIx             S              3P 0
 
      ** Numeric version of Payment Amount (work field)
     D WNumPAYAMT      S             13P 0
      ** Numeric version of Payment Amount
     D NumPAYAMT       S             13P 0
 
      ** Numeric version of Transfer Amount
     D NumTRNAMT       S             13P 0
 
      ** Exchange Rate calculated by the system/numeric version of PXRATE
     D CalcXRATE       S             13P 8
     D NumXRATE        S             13P 8                                                   CSW207A
     D NumORAMT        S             13P 0                                                   CSW207A
     D NXRATE          S             16P 0                                                  BUG24955
 
      ** Exchange Rate from screen but in numeric format
     D ScrnXRATE       S                   LIKE(CalcXRATE)
 
      ** Limit of exchange rate discrepancy
     D RateLimit       S                   LIKE(CalcXRATE)
 
      ** Work field to hold a valid account Id
     D W#Account       S             35A
 
     D CFT004          S              1    INZ('N')
     D CSW207          S              1    INZ('N')                                           CSW207
 
      ** Working version of % rate discrepancy
     D WBtpcrd         S              5  2
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Initial Processing
     C                   EXSR      InitProc
 
      ** Validate Payment Currency if Outgoing RFT                                          BUG15067
      *                                                                                     BUG15067
     C                   IF        PPTYP = 'RO' And PPAYCCY <> *Blanks                      BUG15067
      *                                                                                     BUG15067
     C                   MOVE      'N'           OKPYCY                                     BUG15067
     C                   ADD       1             Idx                                        BUG15067
     C                   MOVEL     'PPAYCCY'     FldNamXAr(Idx)                             BUG15067
     C                   MOVEL     'RFV0388'     MsgIdXAr(Idx)                              BUG15067
      *                                                                                     BUG15067
     C                   ENDIF                                                              BUG15067
      *                                                                                     BUG15067
      ** Only validate the fields if Incoming RFT
     C                   IF        PPTYP = 'RI'
 
      ** Validate Exchange Rate Override Indicator
     C                   EXSR      ValOvrrdIn
 
      ** Validate Payment Currency
     C                   EXSR      ValPayCcy
 
      ** Validate Payment Amount (only do this if the ccy was valid to avoid
      ** database error)
     C                   IF        OKPYCY = 'Y'
     C                   EXSR      ValPayAmt
     C                   ENDIF
 
      ** Validate Exchange Rate (can only be done if both ccys and both
      ** amounts are valid).
     C                   IF        OKPYCY  = 'Y'  and  OKTRCY =  'Y'  and
     C                             OKPYAM <> 'N'  and  OKTRAM <> 'N'  and
     C                             PPAYCCY <> *Blanks and
     C                             PTRNCCY <> *Blanks
     C                   EXSR      ConvAmts
     C                   EXSR      ValXRate
     C                   ENDIF
 
      ** If Payment Amount is left blank, default to Transfer Amount conver-
      ** ted to the Payment Currency at the Exchange Rate.  If no rate has
      ** been entered, use the calculated Exchange Rate.
     C                   IF        OKXRTE = 'Y'
     C                   IF        CalcXRATE <> *Zeros
     C                   IF        PPAYAMT = *blanks
     C     CalcXRate     MULT(H)   NumTRNAMT     NumPAYAMT
      *
      ** Convert to screen format
     C                   EVAL      ZADECP = PayAmtDP
     C                   MOVE (P)  NumPAYAMT     ZFIELD
      *
     C                   CALLB     'ZAEDITM'
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADECP            2 0
      *
     C                   MOVE      ZFIELD        PPAYAMT
 
     C                   ELSE
 
     C     CalcXRate     MULT(H)   NumTRNAMT     WNumPAYAMT
     C                   IF        WNumPAYAMT <> NumPAYAMT
     C                   MOVE      'N'           OKPYAM
     C                   ADD       1             Idx
     C                   MOVEL     'PPAYAMT'     FldNamXAr(Idx)
     C                   MOVEL     'RFV0309'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
 
     C                   Return
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValOvrrdIn - Validate Override Indicator                      *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     ValOvrrdIn    BEGSR
      *
      ** If entered Exchange Rate Override Indicator can only be 'Y' or 'N'.
     C                   IF        PXRATEO <> *Blanks
      *
     C                   IF        PXRATEO <> 'Y' and PXRATEO <> 'N'
     C                   MOVE      'N'           OKXRTO
     C                   ADD       1             Idx
     C                   MOVEL     'PXRATEO'     FldNamXAr(Idx)
     C                   MOVEL     'RFV0155'     MsgIdXAr(Idx)
     C                   ENDIF
      *
      ** If not entered, default to 'N'.
     C                   ELSE
     C                   EVAL      PXRATEO = 'N'
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValXRate - Validate Exchange Rate                             *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
     C     ValXRate      BEGSR
      *
      ** Calculate Exchange Rate whether the user has entered it or not.
      ** It can only be calculated if Transfer Ccy AND Payment Ccy are
      ** both valid.
      ** The value is either used as the default or as a check against the
      ** percent rate discrepancy.  Three possible cases:
     C                   Select
      *
      ** a) Both Transfer Ccy and Payment Ccy are base currency.
     C                   When      PTRNCCY = BJCYCD  and  PPAYCCY = BJCYCD
     C                   EVAL      CalcXRATE = 1
      *
      ** b) Either Transfer Ccy or Payment Ccy is base currency.
     C                   When      PTRNCCY = BJCYCD  or  PPAYCCY = BJCYCD
      *
     C                   IF        PTRNCCY = BJCYCD
     C                   EVAL      @CCY = PPAYCCY
     C                   ELSE
     C                   EVAL      @CCY = PTRNCCY
     C                   ENDIF
      *
      ** Obtain details of the non-base currency
     C                   EXSR      AOCURR
      *
      ** Database error - send screen message if Ex Rate field is blank
     C                   IF        @RTCD <> *Blanks  and  PXRATE = *Blanks
     C                   MOVE      'N'           OKXRTE
     C                   ADD       1             Idx
     C                   MOVEL     DDSName       FldNamXAr(Idx)
     C                   MOVEL     'RFV0156'     MsgIdXAr(Idx)
     C                   EVAL      CalcXRate = *Zeros
     C                   ELSE
      *
      ** Exchange rate in this case is (spot rate + sell spread rate).
     C                   IF        PXRATE = *Blanks and PPAYAMT <> *blanks
     C                             and OKPYAM = 'Y'
     C                   EVAL      CalcXRATE = *zeros
     C                   ELSE
     C                   EVAL      CalcXRATE = A6SPRT + A6SLSR
     C                   ENDIF
      *
     C                   IF        CalcXRATE <> *Zeros  AND  A6MDIN = 'D'
     C                   EVAL      CalcXRATE = (1 / CalcXRATE)
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** c) Neither Transfer Ccy or Payment Ccy is base currency.
     C                   Other
     C                   MOVEL     *Blanks       P#NDCY
     C                   Z-ADD     *Zeros        P#NDAM
     C                   MOVEL     PTRNCCY       P#FRCY
     C                   Z-ADD     NumTRNAMT     P#FRAM
     C                   Z-ADD     BJRDNB        P#FRDT
     C                   MOVEL     PPAYCCY       P#TOCY
     C                   Z-ADD     NumPAYAMT     P#TOAM
     C                   Z-ADD     BJRDNB        P#TODT
     C                   MOVEL     PXRATEO       P#OVRT
     C                   Z-ADD     *Zeros        P#PDAM
     C                   Z-ADD     *Zeros        P#RATE
     C                   Z-ADD     Wbtpcrd       P#RTDS
     C                   MOVEL     'Y'           P#SDIN
      *
     C                   CALLB     'FT0010'
     C                   PARM                    P#0010
      *
     C                   IF        PXRATE = *Blanks and PPAYAMT <> *blanks
     C                             and OKPYAM = 'Y'
     C                   EVAL      CalcXRATE = *zeros
     C                   ELSE
     C                   EVAL      CalcXRATE = P#RATE
     C                   ENDIF
 
     C                   IF        CalcXRATE <> *Zeros  AND  P#MDIN = 0
     C                   EVAL      CalcXRATE = (1 / CalcXRATE)
     C                   ENDIF
      *
     C                   ENDSL
      *
      *
     C                   IF        PXRATE = *Blanks
      *
      ***a)*If*Payment*Amount*has*been*entered, default Exchange Rate to
      ******(Payment*Amount*/*Transaction*Amount).
      *
      ** Exchange rate must be entered if the transfer and payment amounts
      ** are filled in
      *
     C**********         IF        PPAYAMT <> *Blanks  and  OKPYAM = 'Y'                     CSW207A
     C                   IF        NumPAYAMT <> 0    AND                                     CSW207A
     C                             OKPYAM    =  'Y'                                          CSW207A
     C                   MOVE      'N'           OKXRTE
     C                   ADD       1             Idx
     C                   MOVEL     DDSName       FldNamXAr(Idx)
     C                   MOVEL     'RFV0308'     MsgIdXAr(Idx)
     C                   ENDIF
      *                                                                                       CSW207
      ** Exchange rate is mandatory.  Transfer Amount is not zero and                         CSW207
      ** Original Amount is not zero.                                                         CSW207
      *                                                                                       CSW207
     C**********         IF        PTRNAMT <> *Blanks AND                             CSW207 CSW207A
     C**********                   PTOOAMT <> *Blanks AND                             CSW207 CSW207A
     C                   IF        NumTRNAMT <> 0      AND                                   CSW207A
     C                             NumORAMT  <> 0      AND                                   CSW207A
     C                             CSW207 = 'Y'                                               CSW207
     C                   EVAL      OKXRTE         = 'N'                                       CSW207
     C                   EVAL      Idx            = Idx + 1                                   CSW207
     C                   EVAL      FldNamXAr(Idx) = DDSName                                   CSW207
     C                   EVAL      MsgIdXAr(Idx)  = 'RFV0936'                                 CSW207
     C                   ENDIF                                                                CSW207
      *
      ** If not entered, default Exchange Rate to screen depending on:
      ** b) If Payment Amount has not been entered, use the calculated value
     C                   IF        CalcXRATE <> *Zeros
     C                             AND (NumTRNAMT <> 0                                       CSW207A
     C                             OR  NumORAMT   =  0)                                      CSW207A
     C                   MOVE (P)  CalcXRATE     ZFIELD
      *
     C                   CALLB     'ZAEDITM'
     C                   PARM                    ZFIELD           16
     C                   PARM      8             ZADECP            2 0
      *
     C                   MOVE      ZFIELD        PXRATE
     C                   ENDIF
      *
      ** Else the Exchange Rate has been entered...
     C                   ELSE
      *
     C                   EVAL      ZFIELD = *Blanks
     C                   EVAL      ZALIGNok = 'Y'
     C                   MOVE (P)  PXRATE        ZFIELD
      *
      ** ... ensure Exchange Rate is in a valid format
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok          1
     C                   PARM                    ZFIELD           16
     C                   PARM      8             ZADEC             1 0
     C                   PARM      5             ZADIG             2 0
     C                   MOVE      ZFIELD        NXRATE                                     BUG24955
      *
     C                   IF        ZALIGNok <> 'Y'
     C                   MOVE      'N'           OKXRTE
     C                   ADD       1             Idx
     C                   MOVEL     DDSName       FldNamXAr(Idx)
     C                   MOVEL     'RFV0158'     MsgIdXAr(Idx)
      *
     C                   ELSE
                                                                                             CSW207A
     C                   IF        CSW207 = 'Y'                                              CSW207A
      *                                                                                      CSW207A
      ** Exchange rate must not be input.  Transfer Amount is zero and                       CSW207A
      ** Original Amount is not zero.                                                        CSW207A
      *                                                                                      CSW207A
     C                   IF        NumTRNAMT =  0 AND                                        CSW207A
     C                             NumORAMT  <> 0                                            CSW207A
     C                   EVAL      OKXRTE         = 'N'                                      CSW207A
     C                   EVAL      Idx            = Idx + 1                                  CSW207A
     C                   EVAL      FldNamXAr(Idx) = DDSName                                  CSW207A
     C                   EVAL      MsgIdXAr(Idx)  = 'RFV0935'                                CSW207A
     C                   ENDIF                                                               CSW207A
      *                                                                                      CSW207A
      ** Exchange Rate is not allowed.  Original Amount is zero.                             CSW207A
      *                                                                                      CSW207A
     C**********         IF        NumORAMT  =  0                                   CSW207A BUG24955
     C                   IF        NumORAMT  =  0 AND                                       BUG24955
     C                             NXRATE <> 0 AND                                          BUG24955
     C                             PPTYP <> 'RI'                                            BUG24955
     C                   EVAL      OKXRTE         = 'N'                                      CSW207A
     C                   EVAL      Idx            = Idx + 1                                  CSW207A
     C                   EVAL      FldNamXAr(Idx) = DDSName                                  CSW207A
     C                   EVAL      MsgIdXAr(Idx)  = 'RFV0937'                                CSW207A
     C                   ENDIF                                                               CSW207A
      *                                                                                      CSW207A
     C                   ENDIF                                                               CSW207A
      *                                                                                      CSW207A
     C                   IF        OKXRTE  =  'Y'                                            CSW207A
      *
      ** ... ensure Exchange Rate falls within the percentage rate discrep-
      **     ancy of the calculated rate (unless ex. rate override = 'Y')
     C                   MOVE      ZFIELD        ScrnXRATE
     C                   IF        PXRATEO <> 'Y'
      *
     C                   EVAL      RateLimit = (BTPCRD / 100) * CalcXRATE
     C                   IF        ScrnXRATE > (CalcXRATE + RateLimit)  OR
     C                             ScrnXRATE < (CalcXRATE - RateLimit)
     C                   MOVE      'N'           OKXRTE
     C                   ADD       1             Idx
     C                   MOVEL     DDSName       FldNamXAr(Idx)
     C                   MOVEL     'RFV0159'     MsgIdXAr(Idx)
     C                   ENDIF
      *
     C                   ELSE
      *
      ** If the transfer and payment currencies are the same, the exchange
      ** rate must be 1
      *
 b6  C                   IF        PPAYCCY = PTRNCCY AND ScrnXRATE <> 1
     C                   MOVE      'N'           OKXRTE
     C                   ADD       1             Idx
     C                   MOVEL     DDSName       FldNamXAr(Idx)
     C                   MOVEL     'RFV0320'     MsgIdXAr(Idx)
 e5  C                   ENDIF
      **********                                                                      CSW207 CSW207A
     C**********         IF        CSW207 = 'Y'                                       CSW207 CSW207A
      **********                                                                      CSW207 CSW207A
      ***Exchange rate must not be input.  Transfer Amount is zero and                CSW207 CSW207A
      ***Original Amount is not zero.                                                 CSW207 CSW207A
      **********                                                                      CSW207 CSW207A
     C**********         IF        PTRNAMT =  *Blanks AND                             CSW207 CSW207A
     C**********                   PTOOAMT <> *Blanks                                 CSW207 CSW207A
     C**********         EVAL      OKXRTE         = 'N'                               CSW207 CSW207A
     C**********         EVAL      Idx            = Idx + 1                           CSW207 CSW207A
     C**********         EVAL      FldNamXAr(Idx) = DDSName                           CSW207 CSW207A
     C**********         EVAL      MsgIdXAr(Idx)  = 'RFV0935'                         CSW207 CSW207A
     C**********         ENDIF                                                        CSW207 CSW207A
      **********                                                                      CSW207 CSW207A
      ***Exchange Rate is not allowed.  Original Amount is zero.                      CSW207 CSW207A
      **********                                                                      CSW207 CSW207A
     C**********         IF        PTOOAMT =  *Blanks                                 CSW207 CSW207A
     C**********         EVAL      OKXRTE         = 'N'                               CSW207 CSW207A
     C**********         EVAL      Idx            = Idx + 1                           CSW207 CSW207A
     C**********         EVAL      FldNamXAr(Idx) = DDSName                           CSW207 CSW207A
     C**********         EVAL      MsgIdXAr(Idx)  = 'RFV0937'                         CSW207 CSW207A
     C**********         ENDIF                                                        CSW207 CSW207A
      **********                                                                      CSW207 CSW207A
     C**********         ENDIF                                                        CSW207 CSW207A
 
     C                   ENDIF
      *
      **  If the Exchange Rate is valid (all checks are done by now), put
      **  the screen value into CalcXRATE in case Pay. Amount needs to be
      **  defaulted.
     C                   IF        OKXRTE = 'Y'
     C                   EVAL      CalcXRATE = ScrnXRATE
     C                   ENDIF
      *
     C                   ENDIF                                                               CSW207A
      *                                                                                      CSW207A
     C                   ENDIF
      *
      **  If value is in valid format ensure screen field is 13,8 format
     C                   IF        ZALIGNok <> 'N'
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM      8             ZADEC
 
     C                   MOVE      ZFIELD        PXRATE
     C                   ENDIF
      *
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValPayCcy - Validate Payment Currency                         *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: ValAccnt                                               *
      *                                                               *
      *****************************************************************
     C     ValPayCcy     BEGSR
      *
      ** If entered, Payment Currency must be valid on the system
     C                   IF        PPAYCCY <> *Blanks
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *Blanks       @RTCD             7
     C                   PARM      '*KEY'        @OPTN             7
     C                   PARM      PPAYCCY       @CCY              3
     C*****SDCURR        PARM      SDCURR        DSFDY                                        220004
     C     SDCURR        PARM      SDCURR        DSSDY                                        220004
      *
     C                   IF        @RTCD <> *Blanks
     C                   MOVE      'N'           OKPYCY
     C                   ADD       1             Idx
     C                   MOVEL     'PTRNCCY'     FldNamXAr(Idx)
     C                   MOVEL     'RFV0152'     MsgIdXAr(Idx)
     C                   ELSE
     C                   EVAL      PPAYCCY = A6CYCD
     C                   ENDIF
      *
      ** If not entered, Payment Currency defaults to currency of account
      ** specified in Intermediary, A/C with Inst. or Beneficiary.
     C                   ELSE
      *
     C                   IF        PBENTTP <> *Blanks  OR
     C                             PAWITTP <> *Blanks  OR
     C                             PINTTTP <> *Blanks
     C                   SELECT
     C                   WHEN      PBENTTP <> *Blanks
     C                             AND PBENTTP <> 'A'                                       BUG26243
     C                   IF        %Subst(PBNA35:1:1) <> '/'
     C                   EVAL      W#Account = PBNA35
     C                   ELSE
     C**********         SUBST     PBNA35:2      W#Account                                  BUG24955
     C                   EVAL      W#Account = PBNB35                                       BUG24955
     C                   ENDIF
     C                   WHEN      PAwiTtp <> *Blanks
     C                   IF        %Subst(PACA35:1:1) <> '/'
     C                   EVAL      W#Account = PACA35
     C                   ELSE
     C                   SUBST     PACA35:2      W#Account
     C                   ENDIF
     C                   WHEN      PIntttp <> *Blanks
     C                   IF        %Subst(PINST1:1:1) <> '/'
     C                   EVAL      W#Account = PINST1
     C                   ELSE
     C                   SUBST     PINST1:2      W#Account
     C                   ENDIF
     C                   ENDSL
      *
     C                   EXSR      ValAccnt
     C                   EVAL      PPAYCCY = CCY
     C                   ENDIF
                                                                                            BUG27895
      ** Send error message IF Payment Currency defaulting is not possible AND              BUG27895
      ** Generate Outgoing Payments flag is set to 'Y'                                      BUG27895
                                                                                            BUG27895
     C                   IF        PPAYCCY = *BLANKS AND                                    BUG27895
     C                             PGOPFLG = 'Y'                                            BUG27895
     C                   EVAL      OKPYCY  = 'N'                                            BUG27895
     C                   ADD       1             Idx                                        BUG27895
     C                   EVAL      FldNamXAr(Idx) = 'PPAYCCY'                               BUG27895
     C                   EVAL      MsgIdXAr(Idx)  = 'RFV0389'                               BUG27895
     C                   ENDIF                                                              BUG27895
      *
     C                   ENDIF
      *
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValAccnt - Retreive currency of account entered on screen 1   *
      *                                                               *
      * Called by: Validate                                           *
      *                                                               *
      * Calls: AOIBANR2, AOACCTV1                                     *
      *                                                               *
      *****************************************************************
     C     ValAccnt      BEGSR
      *
     C                   EVAL      AccntCode = *Blanks
      *
      ** If CFT004 present, IBANs are allowed.  Else send dummy return code.
     C                   IF        CFT004 = 'Y'
      *
     C                   CALLB     'AOIBANR2'
     C                   PARM      *Blanks       IBANRetCde        7            B:Return code
     C                   PARM      W#Account     P@IBAN           34            I:Option
     C                   PARM      *Blanks       AccRecord                      O:Data Structure
      *
     C                   ELSE
     C                   MOVEL     'Dummy'       IBANRetCde        7            B:Return code
     C                   MOVEL     *Blanks       P@IBAN           34            I:Option
     C                   ENDIF                                                  I:Option
 
     C                   CallB     'AOACCTV1'
     C                   Parm      *Blanks       ACCTRetCde        7
     C                   Parm                    P@TYPE            7
     C                   Parm                    W#Account
     C                   Parm                    DSSDY
 
     C                   Select
     C                   When      P@TYPE = '*NOSTRO'
     C                   Eval      N@FMT = DSSDY
     C                   EVAL      CCY    = A7CYCD                              O:ACCNT Format
     C                   When      P@TYPE = '*RETAIL'
     C                   Eval      ACCRECORD = DSSDY
     C                   When      P@TYPE = '*LEDGER'
     C                   Eval      ACCRECORD = DSSDY
     C                   Endsl
 
 
 
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValPayAmt - Validate Payment Amount                           *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     ValPayAmt     BEGSR
      *
      ** If Payment Amount entered it must be in valid format for the ccy.
     C                   IF        PPAYAMT <> *Blanks
      *
     C                   MOVE (P)  PPAYAMT       ZFIELD                         ************
     C                   EVAL      ZADIG = 15 - A6NBDP                          ************
      *
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok          1
     C                   PARM                    ZFIELD           16
     C                   PARM      A6NBDP        ZADEC             1 0
     C                   PARM                    ZADIG             2 0
      *
     C                   IF        ZALIGNok = 'N'
     C                   MOVE      'N'           OKPYAM
     C                   ADD       1             Idx
     C                   MOVEL     'PPAYAMT'     FldNamXAr(Idx)
     C                   MOVEL     'RFV0154'     MsgIdXAr(Idx)
     C                   ELSE
      *
      ** If Amount is OK format entry to aprropriate decimal places.
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM      A6NBDP        ZADEC
 
     C                   MOVE      ZFIELD        PPAYAMT
      *
     C                   ENDIF
 
      * If pay currency = transfer currency AND pay amount <> transfer
      *  amount, error.
     C                   If        PPAYCCY = PTRNCCY AND
     C**********                   PPAYAMT <> PTRNAMT                                        CSW207A
     C                             NumPAYAMT <> NumTRNAMT                                    CSW207A
     C                   MOVE      'N'           OKPYAM
     C                   ADD       1             Idx
     C                   MOVEL     'PPAYAMT'     FldNamXAr(Idx)
     C                   MOVEL     'RFV0280'     MsgIdXAr(Idx)
     C                   Endif
 
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ConvAmts - Convert screen fields for Payment and Transfer     *
      *            Amounts to numeric (file) format                   *
      *                                                               *
      * Called by: Validate                                           *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     ConvAmts      BEGSR
      *
      ** Obtain Transfer Amount in numeric format
     C                   EVAL      @CCY = PTRNCCY
     C                   EVAL      ZFIELD = *Blanks
     C                   MOVE (P)  PTRNAMT       ZFIELD                         ************
      *
     C                   EXSR      AOCURR
      *
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok          1
     C                   PARM                    ZFIELD           16
     C                   PARM      A6NBDP        ZADEC             1 0
     C                   PARM      13            ZADIG             2 0
      *
     C                   MOVE      ZFIELD        NumTRNAMT
 
 
      ** Obtain Payment Amount in numeric format
     C                   EVAL      @CCY = PPAYCCY
     C                   EVAL      ZFIELD = *Blanks
     C                   MOVE (P)  PPAYAMT       ZFIELD                         ************
      *
     C                   EXSR      AOCURR
     C                   MOVEL     A6NBDP        PayAmtDP          1 0
      *
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok          1
     C                   PARM                    ZFIELD           16
     C                   PARM      PayAmtDP      ZADEC             1 0
     C                   PARM      13            ZADIG             2 0
      *
     C                   MOVE      ZFIELD        NumPAYAMT
                                                                                             CSW207A
      ** Obtain Original Amount in numeric format                                            CSW207A
                                                                                             CSW207A
     C                   EVAL      @CCY = PTOCCY                                             CSW207A
     C                   EVAL      ZFIELD = *Blanks                                          CSW207A
     C                   MOVE(P)   PTOOAMT       ZFIELD                                      CSW207A
      *                                                                                      CSW207A
     C                   EXSR      AOCURR                                                    CSW207A
     C                   MOVEL     A6NBDP        PayAmtDP          1 0                       CSW207A
      *                                                                                      CSW207A
     C                   CALLB     'ZALIGN'                                                  CSW207A
     C                   PARM                    ZALIGNok          1                         CSW207A
     C                   PARM                    ZFIELD           16                         CSW207A
     C                   PARM      PayAmtDP      ZADEC             1 0                       CSW207A
     C                   PARM      13            ZADIG             2 0                       CSW207A
      *                                                                                      CSW207A
     C                   MOVE      ZFIELD        NumORAMT                                    CSW207A
 
     C                   ENDSR                                                  *** InzEnd ***
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * AOCURR - Access currency details                              *
      *                                                               *
      * Called by: ConvAmts                                           *
      *                                                               *
      * Calls: AOCURRR0                                               *
      *                                                               *
      *****************************************************************
     C     AOCURR        BEGSR
      *
     C                   IF        @CCY <> *Blanks
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *Blanks       @RTCD             7
     C                   PARM      '*KEY'        @OPTN             7
     C                   PARM                    @CCY              3
     C*****SDCURR        PARM      SDCURR        DSFDY                                        220004
     C     SDCURR        PARM      SDCURR        DSSDY                                        220004
      *
     C                   ENDIF                                                  *** InzEnd ***
      *
     C                   ENDSR                                                  *** InzEnd ***
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * InitProc - Initial Processing                                 *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     InitProc      BEGSR
      *
     C                   Eval      RetCodeIn  = *Blanks
     C                   Eval      Idx        = 0
     C                   Eval      WIx        = 0
     C                   Eval      OKXRTE     = 'Y'
     C                   Eval      OKXRTO     = 'Y'
     C                   Eval      OKPYAM     = 'Y'
     C                   Eval      OKPYCY     = 'Y'
     C                   Eval      ZALIGNok   = 'Y'
     C                   Eval      CalcXRATE  = 0
     C                   Eval      RateLimit  = 0
     C                   Eval      NumTRNAMT  = 0
     C                   Eval      NumPAYAMT  = 0
     C                   Eval      W#Account  = *Blanks
     C                   Eval      AccntCode  = *Blanks
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *Entry        PLIST
 
      * INPUTS
     C                   Parm                    RetCodeIn
     C                   Parm                    RespMode          1
     C                   Parm                    ActionCode        1
 
      *  Screen fields
     C                   Parm                    HdrRcdIn
     C                   PARM                    DtlRcdIn
 
      * OUTPUTS
 
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtXAr
     C                   Parm                    DDSName          10
     C                   PARM                    OKFlags
 
      ** Access object for Bank details
     C                   CALLB     'AOBANKR0'
     C                   PARM      *Blanks       @RTCD             7
     C                   PARM      '*FIRST'      @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * Database error
     C     @RTCD         IFNE      *Blanks
     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
     C                   MOVEL     '001'         DBASE                          * DBERR 902*
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access object for FT ICD
     C                   CALL      'AOFTFRR0'
     C                   PARM      '*DBERR'      @RTCD             7
     C                   PARM      '*FIRST'      @OPTN             7
     C     SDFTFR        PARM      SDFTFR        DSFDY
      *
      * Database error
     C     @RTCD         IFNE      *Blanks
     C                   MOVEL     'SDFTFRPD'    DBFILE                         ************
     C                   MOVEL     '002'         DBASE                          * DBERR 902*
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      WBtPcRd = BtPcRd / 100
     C                   ENDIF
      *
      ** Check for CFT004 enhancement
     C                   CALL      'AOSARDR0'
     C                   PARM      *Blanks       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CFT004'      @SARD             6
     C                   PARM                    DSFDY
      *
     C                   IF        @RTCD = *Blanks
     C                   EVAL      CFT004 = 'Y'                                 ************
     C                   ELSE                                                   * DBERR 902*
     C                   EVAL      CFT004 = 'N'
     C                   ENDIF
      *
     C                   CALL      'SWIF2007'                                                 CSW207
     C                   PARM                    @RTCD                                        CSW207
      *                                                                                       CSW207
     C                   IF        @RTCD = 'CSW2007'                                          CSW207
     C                   EVAL      CSW207 = 'Y'                                               CSW207
     C                   ELSE                                                                 CSW207
     C                   EVAL      CSW207 = 'N'                                               CSW207
     C                   ENDIF                                                                CSW207
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR                                                  *** InzEnd ***
 
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
