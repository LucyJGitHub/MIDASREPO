     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Caps/Collars/Floors Validation')              *
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Dealing Module                               *
      *                                                               *
      *  IRCACFVAL - Validate Caps/Collars/Floors deals               *
      *                                                               *
      *  Function:  This module validates the screen fields of the    *
      *             Caps/Collars/Floors maintenance, for input into   *
      *             the Midas database.                               *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD051346           Date 17Jul18               *
      *                 MD046248           Date 27Oct17               *
      *                 MD033488           Date 12Mar15               *
      *                 CIR018             Date 11Aug14               *
      *                 CIR017             Date 10Apr14               *
      *                 245692             Date 11Dec13               *
      *                 AR569568           Date 22Nov12               *
      *                 262587             Date 17Sep10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG11457           Date 11May06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG1070            Date 13Mar06               *
      *                 BUG9717            Date 29Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CDL029A            Date 09May05               *
      *                 CSW037A            Date 02May05               *
      *                 BUG6472            Date 23Apr05               *
      *                 CDL028             Date 07Feb05               *
      *                 BUG6124            Date 03Mar05               *
      *                 BUG5443            Date 24Feb05               *
      *                 CSD025             Date 11Jan05               *
      *                 BUG5707            Date 28Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CDL029             Date 23Nov04               *
      *                 CAP084             Date 11Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 222373             Date 31Oct03               *
      *                 217684             Date 12May03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP055  *CREATE    Date 13Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD051346 - The system does not allow to change the maturity  *
      *             date in OIS deal.                                 *
      *           - Ensure zero short term rate is accepted by the    *
      *             system during amend of OIS deals inserted in the  *
      *             past.                                             *
      *  MD046248 - Finastra Rebranding                               *
      *  MD033488 - Allow negative rates. Remove last parameter of    *
      *             program IRVSTERMRT to match entry parameter.      *
      *  CIR018 - Daily Rate Change Frequency on SIRS                 *
      *  CIR017 - SIRS Business Day Conventions for both Legs         *
      *  245692 - Incorrect validation of rates when the decimal se-  *
      *           parator in the Dealing ICD was defined as "," ins-  *
      *           tead of ".".                                        *
      *         - Applied for MD23981.                                *
      *  AR569568 - CDL006 is not being passed causing zero amount to *
      *             be valid in Insert.  But in amendment, it will    *
      *             issue an error message MMM0372.(Child: AR569569)  *
      *  262587 - Applied fix 221963.                                 *
      *  221963 - Validate the Amount/Base Currency Rate in Insert    *
      *           mode, during Amendment and deal is inserted on the  *
      *           same day or if the value of the field had been      *
      *           changed.                                            *
      *  BUG11457-Transaction ccy is not passed by callers            *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10704 - If entered transaction customer is not valid      *
      *             or does not exist in file, validation of          *
      *             customer VS branch must not be carried out.       *
      *  BUG9717- Defaulting of class should be done when CDL038      *
      *           feature is currently ON.                            *
      *  CDL038 - Extended Deal Sub Type                              *
      *  CDL029A- Adding new field                                    *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG6472- Added a sign field for short term rate              *
      *  CDL028 - Automatic Rate Interpolations                       *
      *  BUG6124 - Branch code error when CDL029 is set on            *
      *  BUG5443- Apply code for CDL005 feature                       *
      *  CSD025 - Customer De-Activation                              *
      *  BUG5707- Parameter mismatch                                  *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CDL029 - Midas SD Authorised Booking Branches for Customers  *
      *  CAP084 - ThinClient API enhancement.                         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  222373 - Correct parameters on program calls                 *
      *  217684 - Authorisation User Malfunction                      *
      *  CAP055 - APIs for FRA/IRS Caps/Collars/Floors                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    80         Equal entry found for LOOKUP operation          *
      *    81         Equal entry found for SCAN operation            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SrAcSeq     - Validate Account Sequence Number               *
      *  SrAmount    - Validate Amount                                *
      *  SrAvRtMth   - Average Rate Method                            *
      *  SrBaseRt    - Validate Base Rate                             *
      *  SrBkgBrch   - Validate Booking Branch                        *
      *  SrBook      - Validate Book Code                             *
      *  SrBroker    - Validate Broker Code                           *
      *  SrBrokerage - Validate Broker Code                           *
      *  SrBsCurRt   - Validate Base Currency Rate                    *
      *  SrBusDyCcy  - Validate Business Day Convention Currencies    *
      *  SrBuySell   - Validate Buy/Sell Indicator                    *
      *  SrCalcMeth  - Validate Calculation Method                    *
      *  SrClFlRat   - Validate Ceiling and Floor Rates               *
      *  SrCurCode   - Validate Currency Code                         *
      *  SrCustNum   - Validate Customer Number or Shortname          *
      *  SrDlDate    - Validate Deal Date                             *
      *  SrEffIntRt  - Validate Short Term Rate (but value is written *
      *                to the file as Effective Interest Rate)        *
      *  SrFedFund   - Validate Federal Funds Indicator               *
      *  SrIntPyDay  - Validate Interest Payment Day                  *
      *  SrIntPyDt   - Validate Interest Payment Date                 *
      *  SrIntPyFq   - Validate Interest Payment Frequency            *
      *  SrLinkRef   - Validate Linked Reference Number               *
      *  SrMatDate   - Validate Maturity Date                         *
      *  SrOrigBrch  - Validate Originating Branch                    *
      *  SrProfCtr   - Validate Profit Center                         *
      *  SrPyAmtConv - Validate Payment Date Convention and           *
      *                Amount Convention                              *
      *  SrRtChgDay  - Validate Rate Change Day                       *
      *  SrRtChgDt   - Validate Rate Change Date                      *
      *  SrRtChgFq   - Validate Rate Change Frequency                 *
      *  SrRtFxDay   - Validate Rate Fix Days                         *
      *  SrSprdInd   - Validate Spread Indicator                      *
      *  SrSprdRt    - Validate Spread Rate                           *
      *  SrSubtyp    - Validate Deal Subtype                          *
      *  SrTaxInd    - Validate Taxable Indicator                     *
      *  SrValDate   - Validate Value Date                            *
      *  SrStartDate   - Validate Start Date                          *                       CDL028
      *  SrS1TermBsRtC - Validate Start - 1st Term Base Rate Code     *                       CDL028
      *  SrS1TermEndDt - Validate Start - 1st Term End Date           *                       CDL028
      *  SrS2TermBsRtC - Validate Start - 2nd Term Base Rate Code     *                       CDL028
      *  SrS2TermEndDt - Validate Start - 2nd Term End Date           *                       CDL028
      *  SrEndDate     - Validate End Date                            *                       CDL028
      *  SrE1TermBsRtC - Validate End - 1st Term Base Rate Code       *                       CDL028
      *  SrE1TermEndDt - Validate End - 1st Term End Date             *                       CDL028
      *  SrE2TermBsRtC - Validate End - 2nd Term Base Rate Code       *                       CDL028
      *  SrE2TermEndDt - Validate End - 2nd Term End Date             *                       CDL028
      *  SrResetErrs - Reset error information that is received back  *
      *                from each validation module.                   *
      *  SrUpdatErrs - Update error information with that received    *
      *                back from each validation module.              *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FSDABBCL0  IF   E           K DISK    INFSR(*PSSR)                                       CDL029
      ** Midas SD Authorised Booking Branches for Customers)                                  CDL029
                                                                                              CDL029
      * Hook to enable non-core files to be included
     F/COPY WNCPYSRC,IRCACFV001

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+

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
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
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

      ** Array of OK Flags for the Rate Fixing Convention
     D ArrRtFxOK       S              1A   DIM(10)

      ** Array of OK Flags for Payment and Rate Change Convention
     D ArrPymtOK       S              1A   DIM(10)

      ** Current Caps/Collars/Floors deal Screen format
     D CrIRScnFmt    E DS                  EXTNAME(IRCACFPD)
     D                                     PREFIX(@)

      ** New Caps/Collars/Floors deal Screen format
     D NwIRScnFmt    E DS                  EXTNAME(IRCACFPD)
     D   DSPymtCcys          205    234
     D   DSRtFxCcys          239    268
     D   DSBsDyConv          205    268

      ** Valid Caps/Collars/Floors deal File format
     D NwIRFilFmt    E DS                  EXTNAME(IRVCACFPD)
     D   FilPymtCcys        2063   2092
     D   FilRtFxCcys        2097   2126
     D   FilBsDyConv        2063   2126

      ** Caps/Collars/Floors Extra Data Layout - File (D/B) format
     D ExtData       E DS                  EXTNAME(IRCPEXPD)

      ** Caps/Collars/Floors deal OK Indicators
     D OKFlags       E DS                  EXTNAME(IRECACFPD)
     D   DSPymtOK             40     49
     D   DSRtFxOK             52     61

      ** External DS for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** External DS for Module details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)

      ** External DS for Deal details
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)

      ** External DS for General Ledger details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D  QQACCD1      E                     EXTFLD(QQACCD)                                     CGL029

      ** External DS for Trading details
     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
     D  QQACCD2      E                     EXTFLD(QQACCD)                                     CGL029

      ** External DS for FRA/IRS ICD details
     D SDFAIS        E DS                  EXTNAME(SDFAISPD)

      ** External DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)

      ** External DS for Deal Subtype details
     D SDDLST        E DS                  EXTNAME(SDDLSTPD)

      ** External DS for Branch details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)

      ** External DS for Broker details
     D SDBROK        E DS                  EXTNAME(SDBROKPD)

      ** External DS for Customer details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D  QQDFAC1      E                     EXTFLD(QQDFAC)                                     CGL029

      ** External DS for Currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)

      ** External DS for Book details
     D SDBOOK        E DS                  EXTNAME(SDBOOKPD)

      ** External DS for Nostro details
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
     D  QQACCD3      E                     EXTFLD(QQACCD)                                     CGL029

      ** Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** ZMUSER data area
     D ZMUSER        E DS                  EXTNAME(ZMUSER)

      ** Fees/Buy-Outs in Screen format
     D IRFEBO        E DS                  EXTNAME(IRFEBOPD)
     D                                     PREFIX(FB_)

      ** Fees/Buy-Outs OK Indicators
     D OKFEBO        E DS                  EXTNAME(IREFEBOPD)
     D                                     PREFIX(FB_)

      ** Data structure for Fees/Buy-Outs details
     D/COPY QWINDSRC,IRSIRSGDTA

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D CDL006          S              1A   EXPORT
     D CIR001          S              1A
     D CIR005          S              1A
     D CIR006          S              1A
     D CIR007          S              1A
     D CDL028          S              1A                                                      CDL028
     D I               S              3P 0
     D Idx             S              3P 0
      ** Index for arrays of of error message ids for CDL029                                  CDL029
     D P               S              3P 0                                                    CDL029
     D J               S              3P 0
     D ModeOfOp        S              6A
     D MsgID1          S                   LIKE(#MsgID)
     D MsgID2          S                   LIKE(#MsgID)
     D PayNostro       S             12A
     D PaySetCcy       S              3A
     D PaySetMeth      S              2S 0
     D PWPNLOC         S              3A
     D PWPSCY          S              3A
     D PWRNLOC         S              3A
     D PWRSCY          S              3A
     D PWTCDP          S              1P 0
     D PWUCDP          S              1P 0
     D RecNostro       S             12A
     D RecSetCcy       S              3A
     D RecSetMeth      S              2S 0
     D RespMode        S              1A
     D ValidateBDC     S              1A
     D WarnMsg1        S                   LIKE(#MsgID)
     D WarnMsg2        S                   LIKE(#MsgID)
     D WarnMsg3        S                   LIKE(#MsgID)
     D WarnMsgDta      S                   LIKE(#MsgData)
     D WIdx            S              3P 0

     D W_A8RDFC        S              1A
     D W_CIR001        S              1A
     D W_EINR          S             11P 7
     D W_FRFD          S              2S 0
     D W_ICFD          S              2S 0
     D W_IPFD          S              2S 0
     D W_NICD          S              5P 0
     D W_NIPD          S              5P 0
     D W_RTSP          S             11P 7
     D WAmt15          S             15P 0
     D WBrokCcy        S              3A
     D WBrokCcyDp      S              1S 0
     D WChar1A         S              1A
     D WCode           S              1A
     D WDayBasis       S              1A
     D WIntPyDay       S              2P 0
     D WIntPyFq        S              1A
     D WOurCcy         S              3A
     D WOurCcyOK       S              1A
     D WOurTheir       S              1A
     D WPymtCcys       S             30A
     D WRtChgDy        S              2P 0
     D WRtChgFq        S              1A
     D WRtFxCcys       S             30A
     D WThCcy          S              3A
     D WThCcyOK        S              1A
     D StubDyNo        S              5P 0                                                    CDL028
     D StubRtNo        S             11P 7                                                    CDL028

      ** Average Rate Method                                                                  222373
     D SAVRAM          S              1A                                                      222373
                                                                                              CDL029
      ** Fields defined for Enhancement CDL029                                                CDL029
     D CDL029          S              1A                                                      CDL029
                                                                                              CDL029
     D CDL038          S              1A                                                     BUG9717
      **
      ** New parameter for IRVRTCHGDT due to fmt change in IRSBDYPD                           CIR017
     D BsDayConv       S            128A                                                      CIR017
                                                                                              CIR018
     D PActCode        S              1A                                                      CIR018
     D POred           S              5A                                                      CIR018
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
     D/COPY WNCPYSRC,IRCACFV002
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      /COPY WNCPYSRC,IRCACFV003
                                                                                              CAP084
      ** Check whether user is a web browser user, if so overwrite                            CAP084
                                                                                              CAP084
     C                   CALL      'SFC000026'                                                CAP084
     C                   PARM      *BLANKS       USER             10                          CAP084
                                                                                              CAP084
     C                   IF        USER <> *BLANKS                                            CAP084
     C                   EVAL      PSUSER = USER                                              CAP084
     C                   ENDIF                                                                CAP084
                                                                                              CAP084

      ** Default Sub Type and Class                                                           CDL038
     C                   IF        CDL038 = 'Y'                                              BUG9717
     C                   EXSR      DSUBTCLAS                                                  CDL038
     C                   ENDIF                                                               BUG9717
      ** Validate Deal Subtype
      /COPY WNCPYSRC,IRCACFV004
     C                   EXSR      SrSubtyp
      /COPY WNCPYSRC,IRCACFV005

      ** Validate Booking Branch
      /COPY WNCPYSRC,IRCACFV006
     C                   EXSR      SrBkgBrch
      /COPY WNCPYSRC,IRCACFV007

      ** Validate Deal Date
      /COPY WNCPYSRC,IRCACFV008
     C                   EXSR      SrDlDate
      /COPY WNCPYSRC,IRCACFV009

      ** Validate Broker Code
      /COPY WNCPYSRC,IRCACFV010
     C                   EXSR      SrBroker
      /COPY WNCPYSRC,IRCACFV011

      ** Validate Brokerage Amount
      /COPY WNCPYSRC,IRCACFV012
     C                   EXSR      SrBrokerage
      /COPY WNCPYSRC,IRCACFV013

      ** Validate Linked Reference Number
      /COPY WNCPYSRC,IRCACFV014
     C                   EXSR      SrLinkRef
      /COPY WNCPYSRC,IRCACFV015

      ** Validate Customer Number
      /COPY WNCPYSRC,IRCACFV016
     C                   EXSR      SrCustNum
      /COPY WNCPYSRC,IRCACFV017

      ** Validate Value Date
      /COPY WNCPYSRC,IRCACFV018
     C                   EXSR      SrValDate
      /COPY WNCPYSRC,IRCACFV019

      ** Validate Maturity Date
      /COPY WNCPYSRC,IRCACFV020
     C                   EXSR      SrMatDate
      /COPY WNCPYSRC,IRCACFV021

      ** Validate Account Sequence Number
      /COPY WNCPYSRC,IRCACFV022
     C                   EXSR      SrAcSeq
      /COPY WNCPYSRC,IRCACFV023

      ** Validate Currency
      /COPY WNCPYSRC,IRCACFV024
     C                   EXSR      SrCurCode
      /COPY WNCPYSRC,IRCACFV025

      ** Validate Amount
      /COPY WNCPYSRC,IRCACFV026
     C                   EXSR      SrAmount
      /COPY WNCPYSRC,IRCACFV027

      ** Validate Federal Funds Indicator
      /COPY WNCPYSRC,IRCACFV028
     C                   EXSR      SrFedFund
      /COPY WNCPYSRC,IRCACFV029

      ** Validate Base Currency Rate
      /COPY WNCPYSRC,IRCACFV030
     C                   EXSR      SrBsCurRt
      /COPY WNCPYSRC,IRCACFV031

      ** Validate Book Code
      /COPY WNCPYSRC,IRCACFV032
     C                   EXSR      SrBook
      /COPY WNCPYSRC,IRCACFV033

      ** Validate Calculation Method
      /COPY WNCPYSRC,IRCACFV034
     C                   EXSR      SrCalcMeth
      /COPY WNCPYSRC,IRCACFV035

      ** Validate Taxable Indicator
      /COPY WNCPYSRC,IRCACFV036
     C                   EXSR      SrTaxInd
      /COPY WNCPYSRC,IRCACFV037

      ** Validate Profit Center
      /COPY WNCPYSRC,IRCACFV038
     C                   EXSR      SrProfCtr
      /COPY WNCPYSRC,IRCACFV039

      ** Validate Originating Branch
      /COPY WNCPYSRC,IRCACFV040
     C                   EXSR      SrOrigBrch
      /COPY WNCPYSRC,IRCACFV041

      ** Validate Buy/Sell Indicator
      /COPY WNCPYSRC,IRCACFV042
     C                   EXSR      SrBuySell
      /COPY WNCPYSRC,IRCACFV043

      ** Validate Base Rate
      /COPY WNCPYSRC,IRCACFV044
     C                   EXSR      SrBaseRt
      /COPY WNCPYSRC,IRCACFV045

      ** Validate Spread Rate
      /COPY WNCPYSRC,IRCACFV046
     C                   EXSR      SrSprdRt
      /COPY WNCPYSRC,IRCACFV047

      ** Validate Spread Indicator
      /COPY WNCPYSRC,IRCACFV048
     C                   EXSR      SrSprdInd
      /COPY WNCPYSRC,IRCACFV049

      ** Validate Rate Fix Days
      /COPY WNCPYSRC,IRCACFV050
     C                   EXSR      SrRtFxDay
      /COPY WNCPYSRC,IRCACFV051

      ** Validate Rate Change Date
      /COPY WNCPYSRC,IRCACFV052
     C                   EXSR      SrRtChgDt
      /COPY WNCPYSRC,IRCACFV053

      ** Validate Rate Change Frequency
      /COPY WNCPYSRC,IRCACFV054
     C                   EXSR      SrRtChgFq
      /COPY WNCPYSRC,IRCACFV055

      ** Validate Rate Change Day
      /COPY WNCPYSRC,IRCACFV056
     C                   EXSR      SrRtChgDay
      /COPY WNCPYSRC,IRCACFV057

      ** Validate Interest Payment Date
      /COPY WNCPYSRC,IRCACFV058
     C                   EXSR      SrIntPyDt
      /COPY WNCPYSRC,IRCACFV059

      ** Validate Interest Payment Frequency
      /COPY WNCPYSRC,IRCACFV060
     C                   EXSR      SrIntPyFq
      /COPY WNCPYSRC,IRCACFV061

      ** Validate Interest Payment Day
      /COPY WNCPYSRC,IRCACFV062
     C                   EXSR      SrIntPyDay
      /COPY WNCPYSRC,IRCACFV063

      ** Validate Short Term Rate (but value is written to file as
      ** Effective Interest Rate)
      /COPY WNCPYSRC,IRCACFV064
     C                   EXSR      SrEffIntRt
      /COPY WNCPYSRC,IRCACFV065

      ** Validate Ceiling and Floor Rates
      /COPY WNCPYSRC,IRCACFV066
     C                   EXSR      SrClFlRat
      /COPY WNCPYSRC,IRCACFV067

      ** Validate Average Rate Method
      /COPY WNCPYSRC,IRCACFV068
     C                   EXSR      SrAvRtMth
      /COPY WNCPYSRC,IRCACFV069

      ** Validate Up-front Premium Value Date
      /COPY WNCPYSRC,IRCACFV070
     C                   EXSR      SrUpFVD
      /COPY WNCPYSRC,IRCACFV071

      ** Validate Up-front Premium Fee Amount
      /COPY WNCPYSRC,IRCACFV072
     C                   EXSR      SrUpFFE
      /COPY WNCPYSRC,IRCACFV073

      ** Setup additional fields for the Valids file
      /COPY WNCPYSRC,IRCACFV074
     C                   EXSR      SrSetupVld
      /COPY WNCPYSRC,IRCACFV075

      ** Validate CDL028 fields                                                               CDL028
     C                   IF        CDL028 = 'Y'                                               CDL028
      ** Validate Start Date                                                                  CDL028
     C                   EXSR      SrStartDate                                                CDL028
                                                                                              CDL028
      ** Validate Start - 1st Term Base Rate Code                                             CDL028
     C                   EXSR      SrS1TermBsRtC                                              CDL028
                                                                                              CDL028
      ** Validate Start - 1st Term End Date                                                   CDL028
     C                   EXSR      SrS1TermEndDt                                              CDL028
                                                                                              CDL028
      ** Validate Start - 2nd Term Base Rate Code                                             CDL028
     C                   EXSR      SrS2TermBsRtC                                              CDL028
                                                                                              CDL028
      ** Validate Start - 2nd Term End Date                                                   CDL028
     C                   EXSR      SrS2TermEndDt                                              CDL028
                                                                                              CDL028
      ** Validate End Date                                                                    CDL028
     C                   EXSR      SrEndDate                                                  CDL028
                                                                                              CDL028
      ** Validate End - 1st Term Base Rate Code                                               CDL028
     C                   EXSR      SrE1TermBsRtC                                              CDL028
                                                                                              CDL028
      ** Validate End - 1st Term End Date                                                     CDL028
     C                   EXSR      SrE1TermEndDt                                              CDL028
                                                                                              CDL028
      ** Validate End - 2nd Term Base Rate Code                                               CDL028
     C                   EXSR      SrE2TermBsRtC                                              CDL028
                                                                                              CDL028
      ** Validate End - 2nd Term End Date                                                     CDL028
     C                   EXSR      SrE2TermEndDt                                              CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CDL028
     C                   RETURN

      * Hook to enable non-core subroutines to be included
     C/COPY WNCPYSRC,IRCACFV076
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrSubtyp - Validate Deal Subtype                             *
      *****************************************************************
     C     SrSubtyp      BEGSR

     C                   EXSR      SrResetErrs

     C                   CALLB     'MMVDLSTYPE'
      ** Parameters:
      **    Return code                          (output)
      **    Error Message ID                     (output)
      **    Deal subtype                         (input)
      **    Deal subtype details                 (output)
     C                   PARM                    RetCodeOut
     C                   PARM                    MsgID1
     C                   PARM                    #0DLST
     C                   PARM                    SDDLST

     C*******************IF        MsgID1 = *BLANKS                                           CDL038
     C*******************EVAL      OKDLST = 'Y'                                               CDL038
     C*******************EVAL      RPDLST = #0DLST                                            CDL038
     C*******************GOTO      ESrSubtyp                                                  CDL038
     C*******************ELSE                                                                 CDL038
     C*******************EVAL      MsgIDXAr(1) = MsgID1                                       CDL038
     C*******************EVAL      FldNamXAr(1) = '#0DLST'                                    CDL038
     C*******************EVAL      OKDLST = 'N'                                               CDL038
     C*******************ENDIF                                                                CDL038
                                                                                              CDL038
     C                   IF        MsgID1 <> *BLANKS                                          CDL038
     C                   EVAL      MsgIDXAr(1) = MsgID1                                       CDL038
     C                   EVAL      FldNamXAr(1) = '#0DLST'                                    CDL038
     C                   EVAL      OKDLST = 'N'                                               CDL038
     C                   ELSE                                                                 CDL038
                                                                                              CDL038
     C                   CALLB     'IRVDEALTPS'                                               CDL038
     C                   PARM                    ReturnCode                                   CDL038
     C                   PARM                    MsgID1                                       CDL038
     C                   PARM                    MsgID2                                       CDL038
     C                   PARM                    #0DTYP                                       CDL038
     C                   PARM                    #0DLST                                       CDL038
     C                   PARM                    #0CLAS                                       CDL038
                                                                                              CDL038
     C     MsgID1        IFNE      *BLANK                                                     CDL038
     C                   EVAL      MsgIDXAr(1) = MsgID1                                       CDL038
     C                   EVAL      FldNamXAr(1) = '#0CLAS'                                    CDL038
     C                   EVAL      OKCLAS = 'N'                                               CDL038
     C                   ELSE                                                                 CDL038
     C     MsgID2        IFNE      *BLANK                                                     CDL038
     C                   EVAL      MsgIDXAr(1) = MsgID2                                       CDL038
     C                   EVAL      FldNamXAr(1) = '#0DTYP'                                    CDL038
     C                   EVAL      OKDTYP = 'N'                                               CDL038
     C                   EVAL      OKDLST = 'N'                                               CDL038
     C                   EVAL      OKCLAS = 'N'                                               CDL038
     C                   ELSE                                                                 CDL038
     C                   EVAL      OKDTYP = 'Y'                                               CDL038
     C                   EVAL      OKDLST = 'Y'                                               CDL038
     C                   EVAL      OKCLAS = 'Y'                                               CDL038
     C                   EVAL      RPDLST = #0DLST                                            CDL038
     C                   EVAL      RPCLAS = #0CLAS                                            CDL038
     C                   GOTO      ESrSubtyp                                                  CDL038
     C                   ENDIF                                                                CDL038
     C                   ENDIF                                                                CDL038
     C                   ENDIF                                                                CDL038

     C                   EXSR      SrUpdatErrs

     C     ESrSubtyp     ENDSR
      *****************************************************************
      /EJECT                                                                                  CDL038
      *****************************************************************                       CDL038
      * Default Sub Type and Class                                                            CDL038
      *****************************************************************                       CDL038
     C     DSUBTCLAS     BEGSR                                                                CDL038
      *                                                                                       CDL038
     C                   CALL      'DL002000'                                                 CDL038
      * Inputs                                                                                CDL038
     C                   PARM                    #0ACCD                                       CDL038
     C                   PARM                    #0DTYP                                       CDL038
     C                   PARM                    #0CNUM                                       CDL038
     C                   PARM                    #0VDAT                                       CDL038
     C                   PARM                    #0MDAT                                       CDL038
     C                   PARM                    #0BOKC                                       CDL038
     C                   PARM                    #0PRFC                                       CDL038
     C                   PARM                    #0CUCY                                       CDL038
     C                   PARM      *BLANK        @Currency         3                          CDL038
     C                   PARM      *BLANK        @RelatedDeal      6                          CDL038
      * Inputs/Outputs                                                                        CDL038
     C                   PARM                    #0DLST                                       CDL038
     C                   PARM                    #0CLAS                                       CDL038
      *                                                                                       CDL038
     C                   ENDSR                                                                CDL038
      *****************************************************************                       CDL038
      /EJECT
      *****************************************************************
      *  SrBkgBrch - Validate Booking Branch                          *
      *****************************************************************
     C     SrBkgBrch     BEGSR

     C                   EXSR      SrResetErrs

     C                   CALLB     'MMVBKGBRCH'
      ** Parameters:
      **    Return code                          (output)
      **    Error message ID                     (output)
      **    Single branch code                   (input)
      **    Default branch from ZMUSER           (input)
      **    Round down interest indicator        (output)
      **    Action code                          (input)
      **    Booking branch                       (input)
      **    Response mode                        (input)
      **    Booking branch                       (output)
      **    Branch details                       (output)
     C                   PARM                    RetCodeOut
     C                   PARM                    MsgID1
     C                   PARM                    BJSBRC
     C                   PARM                    DBRN
     C                   PARM                    W_A8RDFC
     C                   PARM                    #0ACCD
     C                   PARM                    #0BRCA
     C                   PARM                    RespMode
     C                   PARM                    RPBRCA
     C                   PARM                    SDBRCH

     C                   IF        MsgID1 = *BLANKS
     C                   EVAL      OKBRCA = 'Y'
     C*                  GOTO      ESrBkgBrch                                                 CDL029
     C                   ELSE
     C                   EVAL      MsgIDXAr(1) = MsgID1
     C*******************EVAL      FldNamXAr(1) = #0BRCA                                      CDL038
     C                   EVAL      FldNamXAr(1) = '#0BRCA'                                    CDL038
     C                   EVAL      OKBRCA = 'N'
     C                   ENDIF

     C                   EXSR      SrUpdatErrs

     C**********         IF        CDL029 ='Y'                                        CDL029 BUG6124
      **********                                                                      CDL029 BUG6124
     C*****KBRANCHAUTH   CHAIN     SDABBCL0                           91              CDL029 BUG6124
     C**********         IF        *IN91 = '1'                                        CDL029 BUG6124
     C**********         EVAL      OKBRCA = 'N'                                       CDL029 BUG6124
     C*****Idx           ADD       1             P                                    CDL029 BUG6124
     C**********         EVAL      FldNameArr(P) = #0BRCA                             CDL029 BUG6124
     C**********         EVAL      FldNamXAr(P) = #0BRCA                              CDL029 BUG6124
     C**********         EVAL      MsgIDArr(P) = 'FXM7001'                            CDL029 BUG6124
     C**********         EVAL      MsgIDXAr(P) = 'FXM7001'                            CDL029 BUG6124
     C**********         END                                                          CDL029 BUG6124
      **********                                                                      CDL029 BUG6124
     C**********         END                                                          CDL029 BUG6124
      **********                                                                      CDL029 BUG6124
     C     ESrBkgBrch    ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrDlDate - Validate Deal Date                                *
      *****************************************************************
     C     SrDlDate      BEGSR

     C                   EXSR      SrResetErrs

     C                   CALLB     'MMVDLDATE'
      ** Parameters:
      **    Return code                          (output)
      **    Error message ID 1                   (output)
      **    Error message ID 2                   (output)
      **    Warning message ID                   (output)
      **    Deal date in File format             (output)
      **    Deal date in Screen format           (input)
      **    Midas rundate                        (input)
      **    Date format indicator                (input)
      **    Global warning flag                  (input)
      **    Local currency                       (input)
      **    Local location code                  (input)
     C                   PARM                    RetCodeOut
     C                   PARM                    MsgID1
     C                   PARM                    MsgID2
     C                   PARM                    WarnMsg1
     C                   PARM                    RPDDAT
     C                   PARM                    #0DDAT
     C                   PARM                    BJRDNB
     C                   PARM                    BJDFIN
     C                   PARM                    WarnGlobal
     C                   PARM                    BJLCCY
     C                   PARM                    A8LCCD

     C                   IF        MsgID1 = *BLANKS AND MsgID2 = *BLANKS
     C                             AND WarnMsg1 = *BLANKS
     C                   EVAL      OKDDAT = 'Y'
     C                   GOTO      ESrDlDate
     C                   ENDIF

     C                   IF        MsgID1 <> *BLANKS
     C                   EVAL      J = J + 1
     C                   EVAL      MsgIDXAr(J) = MsgID1
     C                   EVAL      FldNamXAr(J) = '#0DDAT'
     C                   EVAL      OKDDAT = 'N'
     C                   ENDIF

     C                   IF        MsgID2 <> *BLANKS
     C                   EVAL      J = J + 1
     C                   EVAL      MsgIDXAr(J) = MsgID2
     C                   EVAL      FldNamXAr(J) = '#0DDAT'
     C                   EVAL      OKDDAT = 'N'
     C                   ENDIF

     C                   IF        WarnMsg1 <> *BLANKS
     C                   EVAL      WMsgIDXAr(1) = WarnMsg1
     C                   EVAL      WFldNmXAr(1) = '#0DDAT'
     C                   EVAL      OKDDAT = 'W'
     C                   ENDIF

     C                   EXSR      SrUpdatErrs

     C     ESrDlDate     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrBroker - Validate Broker Code                              *
      *****************************************************************
     C     SrBroker      BEGSR

     C                   EXSR      SrResetErrs

     C                   CALLB     'MMVBROKCDE'
      ** Parameters:
      **    Return code                          (output)
      **    Error message ID                     (output)
      **    Broker code                          (input)
      **    Broker currency                      (output)
      **    Broker currency decimal places       (output)
      **    Broker details                       (output)
     C                   PARM                    RetCodeOut
     C                   PARM                    MsgID1
     C                   PARM                    #0BRKC
     C                   PARM                    WBrokCcy
     C                   PARM                    WBrokCcyDp
     C                   PARM                    SDBROK

     C                   IF        MsgID1 = *BLANKS
     C                   EVAL      OKBRKC = 'Y'
     C                   EVAL      RPBRKC = #0BRKC
     C                   GOTO      ESrBroker
     C                   ELSE
     C                   EVAL      MsgIDXAr(1) = MsgID1
     C                   EVAL      FldNamXAr(1) = '#0BRKC'
     C                   EVAL      OKBRKC = 'N'
     C                   ENDIF

     C                   EXSR      SrUpdatErrs

     C     ESrBroker     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrBrokerage - Validate Broker Code                           *
      *****************************************************************
     C     SrBrokerage   BEGSR

     C                   EXSR      SrResetErrs

     C                   CALLB     'ZAVBROKAGE'
      ** Parameters:
      **    Return code                          (output)
      **    Error message ID 1                   (output)
      **    Error message ID 2                   (output)
      **    Broker code OK flag                  (input)
      **    Broker code                          (input)
      **    Broker amount                        (input)
      **    Broker currency                      (input)
      **    Broker amount in File format         (output)
      **    Decimal separator                    (input)
     C                   PARM                    RetCodeOut
     C                   PARM                    MsgID1
     C                   PARM                    MsgID2
     C                   PARM                    OKBRKC
     C                   PARM                    #0BRKC
     C                   PARM                    #0BAGE
     C                   PARM                    A9BRCY
     C                   PARM                    RPBAGE
     C                   PARM                    BNDCSP

     C                   IF        MsgID1 = *BLANKS AND MsgID2 = *BLANKS
     C                   EVAL      OKBAGE = 'Y'
     C                   GOTO      ESrBrokerage
     C                   ENDIF

     C                   IF        MsgID1 <> *BLANKS
     C                   EVAL      J = J + 1
     C                   EVAL      MsgIDXAr(J) = MsgID1
     C                   EVAL      FldNamXAr(J) = '#0BAGE'
     C                   EVAL      OKBAGE = 'N'
     C                   ENDIF

     C                   IF        MsgID2 <> *BLANKS
     C                   EVAL      J = J + 1
     C                   EVAL      MsgIDXAr(J) = MsgID2
     C                   EVAL      FldNamXAr(J) = '#0BAGE'
     C                   EVAL      OKBAGE = 'N'
     C                   ENDIF

     C                   EXSR      SrUpdatErrs

     C     ESrBrokerage  ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrLinkRef - Validate Linked Reference Number                 *
      *****************************************************************
     C     SrLinkRef     BEGSR

     C                   EXSR      SrResetErrs

     C                   CALLB     'MMVLINKREF'
      ** Parameters:
      **    Return code                          (output)
      **    Error message ID                     (output)
      **    Linked reference number              (input)
      **    Decimal separator                    (input)
     C                   PARM                    RetCodeOut
     C                   PARM                    MsgID1
     C                   PARM                    #0LNKD
     C                   PARM                    BNDCSP

     C                   IF        MsgID1 = *BLANKS
     C                   EVAL      OKLNKD = 'Y'
     C                   MOVE      #0LNKD        RPLNKDN
     C                   GOTO      ESrLinkRef
     C                   ELSE
     C                   EVAL      MsgIDXAr(1) = MsgID1
     C                   EVAL      FldNamXAr(1) = '#0LNKD'
     C                   EVAL      OKLNKD = 'N'
     C                   ENDIF

     C                   EXSR      SrUpdatErrs

     C     ESrLinkRef    ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrCustNum - Validate Customer Number or Shortname            *
      *****************************************************************
     C     SrCustNum     BEGSR

     C                   EXSR      SrResetErrs

     C                   CALLB     'IRVCUSTNUM'
      ** Parameters:
      **    Return code                          (output)
      **    Error message ID                     (output)
      **    Customer Number/Shortname            (input)
      **    Customer details                     (output)
     C                   PARM                    RetCodeOut
     C                   PARM                    MsgID1
     C                   PARM                    #0CNUM
     C                   PARM                    SDCUST
     C                   PARM                    #0ACCD                                      BUG5443
      * customer format                                                                      BUG5443
      * N = customer number, else customer shortname                                         BUG5443
     C                   PARM                    CustFormat        1                         BUG5443

     C                   IF        MsgID1 = *BLANKS
     C                   EVAL      OKCNUM = 'Y'
     C                   MOVE      BBCUST        RPCNUM
     C**********         GOTO      ESrCustNum                                                BUG6124
     C                   ELSE
     C                   EVAL      MsgIDXAr(1) = MsgID1
     C                   EVAL      FldNamXAr(1) = '#0CNUM'
     C                   EVAL      OKCNUM = 'N'
     C                   ENDIF

     C                   IF        CDL029 ='Y'                                               BUG6124
     C                             AND OKCNUM = 'Y'                                         BUG10704
      *                                                                                      BUG6124
     C                   MOVEL     *BLANKS       W0BRCD                                      CDL029A
     C                   MOVEL     BBCUST        W0CUST                                      CDL029A
      *                                                                                      CDL029A
     C     KBRANCHAUTH   CHAIN     SDABBCL0                           91                     CDL029A
      *                                                                                      CDL029A
     C                   IF        *IN91 = '1'                                               CDL029A
      *                                                                                      CDL029A
     C                   MOVEL     BBBRCD        W0BRCD                                      CDL029A
     C                   MOVEL     *BLANKS       W0CUST                                      CDL029A
      *                                                                                      CDL029A
     C     KBRANCHAUTH   CHAIN     SDABBCL0                           91                     BUG6124
      *                                                                                      CDL029A
     C                   ENDIF                                                               CDL029A
      *                                                                                      CDL029A
     C                   IF        *IN91 = '1'                                               BUG6124
     C                   EVAL      OKBRCA = 'N'                                              BUG6124
     C     Idx           ADD       1             P                                           BUG6124
     C                   EVAL      FldNameArr(P) = '#0BRCA'                                  BUG6124
     C                   EVAL      FldNamXAr(P) = '#0BRCA'                                   BUG6124
     C                   EVAL      MsgIDArr(P) = 'FXM7001'                                   BUG6124
     C                   EVAL      MsgIDXAr(P) = 'FXM7001'                                   BUG6124
     C                   END                                                                 BUG6124
      *                                                                                      BUG6124
     C                   END                                                                 BUG6124
      *                                                                                      BUG6124
     C                   EXSR      SrUpdatErrs

     C     ESrCustNum    ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrValDate - Validate Value Date                              *
      *****************************************************************
     C     SrValDate     BEGSR

     C                   EXSR      SrResetErrs

     C/COPY WNCPYSRC,IRH00079
     C                   CALLB     'IRVIRSVDAT'
      ** Parameters:
      **    Return code                          (output)
      **    Error message ID                     (output)
      **    Warning message ID                   (output)
      **    Warning message ID 2                 (output)
      **    Value date in Screen format          (input)
      **    Deal date in Screen format           (input)
      **    Value date in File format            (output)
      **    Deal date in File format             (output)
      **    Date format indicator                (input)
      **    Midas rundate                        (input)
      **    Local currency                       (input)
      **    System location code                 (input)
      **    Our currency code                    (input)
      **    Their currency code                  (input)
      **    Receipt settlement currency          (input)
      **    Receipt settlement method            (input)
      **    Receipt settlement nostro            (input)
      **    Pay settlement currency              (input)
      **    Pay settlement method                (input)
      **    Pay settlement nostro                (input)
     C                   PARM                    RetCodeOut
     C                   PARM                    MsgID1
     C                   PARM                    WarnMsg1
     C                   PARM                    WarnMsg2
     C                   PARM                    #0VDAT
     C                   PARM                    #0DDAT
     C                   PARM                    RPVDAT
     C                   PARM                    RPDDAT
     C                   PARM                    BJDFIN
     C                   PARM                    BJRDNB
     C                   PARM                    BJLCCY
     C                   PARM                    BJSLCD
     C                   PARM      #0CUCY        WOurCcy
     C                   PARM      *BLANKS       WThCcy
     C                   PARM                    RecSetCcy
     C                   PARM                    RecSetMeth
     C                   PARM                    RecNostro
     C                   PARM                    PaySetCcy
     C                   PARM                    PaySetMeth
     C                   PARM                    PayNostro
     C/COPY WNCPYSRC,IRH00080

     C                   IF        MsgID1 = *BLANKS AND
     C                             WarnMsg1 = *BLANKS AND WarnMsg2 = *BLANKS
     C                   EVAL      OKVDAT = 'Y'
     C                   GOTO      ESrValDate
     C                   ENDIF

     C                   IF        MsgID1 <> *BLANKS
     C                   EVAL      MsgIDXAr(1) = MsgID1
     C                   EVAL      FldNamXAr(1) = '#0VDAT'
     C                   EVAL      OKVDAT = 'N'
     C                   ENDIF

     C                   IF        WarnMsg1 <> *BLANKS
     C                   EVAL      J = J + 1
     C                   EVAL      WMsgIDXAr(J) = WarnMsg1
     C                   EVAL      WFldNmXAr(J) = '#0VDAT'
     C                   EVAL      OKVDAT = 'W'
     C                   ENDIF

     C                   IF        WarnMsg2 <> *BLANKS
     C                   EVAL      J = J + 1
     C                   EVAL      WMsgIDXAr(J) = WarnMsg2
     C                   EVAL      WFldNmXAr(J) = '#0VDAT'
     C                   EVAL      OKVDAT = 'W'
     C                   ENDIF

     C                   EXSR      SrUpdatErrs

     C     ESrValDate    ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrMatDate - Validate Maturity Date                           *
      *****************************************************************
     C     SrMatDate     BEGSR

     C                   EXSR      SrResetErrs

     C                   CALLB     'IRVMATDATE'
      ** Parameters:
      **    Return code                          (output)
      **    Error message ID                     (output)
      **    Warning message ID                   (output)
      **    Warning message ID 2                 (output)
      **    Maturity date in Screen format       (input)
      **    Value date in File format            (input)
      **    Our currency code                    (input)
      **    Local currency                       (input)
      **    System location code                 (input)
      **    Average rate method                  (input)
      **    Midas rundate                        (input)
      **    Date format indicator                (input)
      **    Value date OK flag                   (input)
      **    Our currency OK flag                 (input)
      **    Maturity date in File format         (output)
      **    Their currency code                  (input)
      **    Their currency OK flag               (input)
     C                   PARM                    RetCodeOut
     C                   PARM                    MsgID1
     C                   PARM                    WarnMsg1
     C                   PARM                    WarnMsg2
     C                   PARM                    #0MDAT
     C                   PARM                    RPVDAT
     C                   PARM      #0CUCY        WOurCcy
     C                   PARM                    BJLCCY
     C                   PARM                    BJSLCD
     C                   PARM                    #0AVRM
     C                   PARM                    BJRDNB
     C                   PARM                    BJDFIN
     C                   PARM                    OKVDAT
     C                   PARM      OKCUCY        WOurCcyOK
     C                   PARM                    RPMDAT
     C                   PARM      *BLANKS       WThCcy
     C                   PARM      *BLANKS       WThCcyOK

     C                   IF        MsgID1 = *BLANKS AND
     C                             WarnMsg1 = *BLANKS AND WarnMsg2 = *BLANKS
     C                   EVAL      OKMDAT = 'Y'
     C                   GOTO      ESrMatDate
     C                   ENDIF

     C                   IF        MsgID1 <> *BLANKS
     C                   EVAL      MsgIDXAr(1) = MsgID1
     C                   EVAL      FldNamXAr(1) = '#0MDAT'
     C                   EVAL      OKMDAT = 'N'
     C                   ENDIF

     C                   IF        WarnMsg1 <> *BLANKS
     C                   EVAL      J = J + 1
     C                   EVAL      WMsgIDXAr(J) = WarnMsg1
     C                   EVAL      WFldNmXAr(J) = '#0MDAT'
     C                   EVAL      OKMDAT = 'W'
     C                   ENDIF

     C                   IF        WarnMsg2 <> *BLANKS
     C                   EVAL      J = J + 1
     C                   EVAL      WMsgIDXAr(J) = WarnMsg2
     C                   EVAL      WFldNmXAr(J) = '#0MDAT'
     C                   EVAL      OKMDAT = 'W'
     C                   ENDIF

     C                   EXSR      SrUpdatErrs

     C     ESrMatDate    ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrAcSeq - Validate Account Sequence Number                   *
      *****************************************************************
     C     SrAcSeq       BEGSR

     C                   EXSR      SrResetErrs

     C                   CALLB     'MMVACSEQ'
      ** Parameters:
      **    Return code                          (output)
      **    Error message ID                     (output)
      **    Account sequence number - alpha      (input)
      **    Account sequence number - numeric    (output)
      **    Decimal separator                    (input)
     C                   PARM                    RetCodeOut
     C                   PARM                    MsgID1
     C                   PARM                    #0CDAS
     C                   PARM                    RPCDAS
     C                   PARM                    BNDCSP

     C                   IF        MsgID1 = *BLANKS
     C                   EVAL      OKCDAS = 'Y'
     C                   GOTO      ESrAcSeq
     C                   ELSE
     C                   EVAL      MsgIDXAr(1) = MsgID1
     C                   EVAL      FldNamXAr(1) = '#0CDAS'
     C                   EVAL      OKCDAS = 'N'
     C                   ENDIF

     C                   EXSR      SrUpdatErrs

     C     ESrAcSeq      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrCurCode - Validate Currency Code                           *
      *****************************************************************
     C     SrCurCode     BEGSR

     C                   EXSR      SrResetErrs

     C                   CALLB     'ZAVCURCODE'
      ** Parameters:
      **    Return code                          (output)
      **    Error message ID                     (output)
      **    Currency code                        (input)
      **    Currency details                     (output)
     C                   PARM                    RetCodeOut
     C                   PARM                    MsgID1
     C                   PARM                    #0CUCY
     C                   PARM                    SDCURR

     C                   IF        MsgID1 = *BLANKS
     C                   EVAL      OKCUCY = 'Y'
     C                   EVAL      RPUCUCY = #0CUCY
     C                   EVAL      RPTCUCY = #0CUCY
     C                   GOTO      ESrCurCode
     C                   ELSE
     C                   EVAL      MsgIDXAr(1) = MsgID1
     C                   EVAL      FldNamXAr(1) = '#0CUCY'
     C                   EVAL      OKCUCY = 'N'
     C                   ENDIF

     C                   EXSR      SrUpdatErrs

     C     ESrCurCode    ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrAmount - Validate Amount                                   *
      *****************************************************************
     C     SrAmount      BEGSR

     C                   EXSR      SrResetErrs

     C                   CALLB     'MMVAMOUNT'
      ** Parameters:
      **    Return code                          (output)
      **    Error message ID                     (output)
      **    Amount in Screen format              (input)
      **    Currency code OK flag                (input)
      **    Number of decimal places             (input)
      **    Deal type                            (input)
      **    Amount in File format                (output)
      **    Decimal separator                    (input)
     C                   PARM                    RetCodeOut
     C                   PARM                    MsgID1
     C                   PARM                    #0PAMT
     C                   PARM                    OKCUCY
     C                   PARM                    A6NBDP
     C                   PARM                    #0DTYP
     C                   PARM                    WAmt15
     C                   PARM                    BNDCSP
     C                   PARM                    #0ACCD                                     AR569568
     C                   PARM                    CDL006                                     AR569568

     C                   IF        MsgID1 = *BLANKS
     C                   EVAL      OKPAMT = 'Y'
     C                   Z-ADD     WAmt15        RPUPAMT
     C                   Z-ADD     WAmt15        RPTPAMT
     C                   GOTO      ESrAmount
     C                   ELSE
     C                   EVAL      MsgIDXAr(1) = MsgID1
     C                   EVAL      FldNamXAr(1) = '#0PAMT'
     C                   EVAL      OKPAMT = 'N'
     C                   ENDIF

     C                   EXSR      SrUpdatErrs

     C     ESrAmount     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrFedFund - Validate Federal Funds Indicator                 *
      *****************************************************************
     C     SrFedFund     BEGSR

     C                   EXSR      SrResetErrs
     C                   BITOFF    '01234567'    RPUDSTI
     C                   BITOFF    '01234567'    RPTDSTI

     C                   CALLB     'MMVFEDFUND'
      ** Parameters:
      **    Return code                          (output)
      **    Error message ID                     (output)
      **    Federal funds indicator              (input)
      **    Currency code                        (input)
      **    US Currency code                     (input)
     C                   PARM                    RetCodeOut
     C                   PARM                    MsgID1
     C                   PARM                    #0FEFI
     C                   PARM                    #0CUCY
     C                   PARM                    BLUSCY

     C                   IF        MsgID1 = *BLANKS
     C                   IF        #0FEFI = 'Y'
     C                   BITON     '2'           RPUDSTI
     C                   BITON     '2'           RPTDSTI
     C                   ENDIF
     C                   EVAL      OKFEFI = 'Y'
     C                   GOTO      ESrFedFund

     C                   ELSE
     C                   EVAL      MsgIDXAr(1) = MsgID1
     C                   EVAL      FldNamXAr(1) = '#0FEFI'
     C                   EVAL      OKFEFI = 'N'
     C                   ENDIF

     C                   EXSR      SrUpdatErrs

     C     ESrFedFund    ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrBsCurRt - Validate Base Currency Rate                      *
      *****************************************************************
     C     SrBsCurRt     BEGSR

     C     #0ACCD        IFEQ      'I'                                                        221963
     C     #0ACCD        OREQ      'A'                                                        221963
     C     RPORED        ANDEQ     BJRDNB                                                     221963
     C     #0ACCD        OREQ      'A'                                                        221963
     C     RPORED        ANDNE     BJRDNB                                                     221963
     C     #0BCXR        ANDNE     @#0BCXR                                                    221963
      *                                                                                       221963
     C                   EXSR      SrResetErrs

     C                   CALLB     'IRVBCURRAT'
      ** Parameters:
      **    Return code                          (output)
      **    Error message ID                     (output)
      **    Base currency rate in Screen format  (input)
      **    Spot base rate                       (input)
      **    Currency code                        (input)
      **    Base currency for accounting         (input)
      **    Base currency rate in File format    (output)
     C                   PARM                    RetCodeOut
     C                   PARM                    MsgID1
     C                   PARM                    #0BCXR
     C                   PARM                    A6SPRT
     C                   PARM                    #0CUCY
     C                   PARM                    BJCYCD
     C                   PARM                    RPUBCXR
     C                   PARM                    BNDCSP                                       245692

     C                   IF        MsgID1 = *BLANKS
     C                   EVAL      OKBCXR = 'Y'
     C                   EVAL      RPTBCXR = RPUBCXR
     C                   GOTO      ESrBsCurRt
     C                   ELSE
     C                   EVAL      MsgIDXAr(1) = MsgID1
     C                   EVAL      FldNamXAr(1) = '#0BCXR'
     C*******************EVAL      FldNamXAr = '#0BCXR'                                       CDL038
     C                   EVAL      OKBCXR = 'N'
     C                   ENDIF

     C                   EXSR      SrUpdatErrs
      *                                                                                       221963
     C                   ENDIF                                                                221963

     C     ESrBsCurRt    ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrBook - Validate Book Code                                  *
      *****************************************************************
     C     SrBook        BEGSR

     C                   EXSR      SrResetErrs

     C                   CALLB     'IRVBOOKCDE'
      ** Parameters:
      **    Return code                          (output)
      **    Error message ID                     (output)
      **    Book code                            (input)
      **    Book details                         (input)
      **    Day basis                            (input)
     C                   PARM                    RetCodeOut
     C                   PARM                    MsgID1
     C                   PARM                    #0BOKC
     C                   PARM                    SDBOOK
     C                   PARM                    WDayBasis

     C                   IF        MsgID1 = *BLANKS
     C                   EVAL      OKBOKC = 'Y'
     C                   EVAL      RPBOKC = #0BOKC
     C                   GOTO      ESrBook
     C                   ELSE
     C                   EVAL      MsgIDXAr(1) = MsgID1
     C                   EVAL      FldNamXAr(1) = '#0BOKC'
     C                   EVAL      OKBOKC = 'N'
     C                   ENDIF

     C                   EXSR      SrUpdatErrs

     C     ESrBook       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrCalcMeth - Validate Calculation Method                     *
      *****************************************************************
     C     SrCalcMeth    BEGSR

     C                   EXSR      SrResetErrs

     C                   CALLB     'IRVIRSINTC'
      ** Parameters:
      **    Return code                          (output)
      **    Error message ID                     (output)
      **    CIR001 temporary field               (input)
      **    Interest pymt freq. temporary field  (input)
      **    Interest calculation basis           (input)
     C                   PARM                    RetCodeOut
     C                   PARM                    MsgID1
     C                   PARM      'N'           W_CIR001
     C                   PARM      *BLANKS       WIntPyFq
     C                   PARM                    #0ICBS

     C                   IF        MsgID1 = *BLANKS
     C                   EVAL      OKICBS = 'Y'
     C                   MOVE      #0ICBS        RPUICBS
     C                   MOVE      #0ICBS        RPTICBS
     C                   GOTO      ESrCalcMeth
     C                   ELSE
     C                   EVAL      MsgIDXAr(1) = MsgID1
     C                   EVAL      FldNamXAr(1) = '#0ICBS'
     C                   EVAL      OKICBS = 'N'
     C                   ENDIF

     C                   EXSR      SrUpdatErrs

     C     ESrCalcMeth   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrTaxInd - Validate Taxable Indicator                        *
      *****************************************************************
     C     SrTaxInd      BEGSR

     C                   EXSR      SrResetErrs

     C                   CALLB     'ZAVTAXIND'
      ** Parameters:
      **    Return code                          (output)
      **    Error message ID                     (output)
      **    Customer number OK flag              (output)
      **    Taxable indicator                    (input)
      **    Taxable indicator of Customer        (input)
     C                   PARM                    RetCodeOut
     C                   PARM                    MsgID1
     C                   PARM                    OKCNUM
     C                   PARM                    #0TAXI
     C                   PARM                    BBTAIN

     C                   IF        MsgID1 = *BLANKS
     C                   IF        #0TAXI = 'Y'
     C                   EVAL      RPTAXI = 'Y'
     C                   ELSE
     C                   EVAL      RPTAXI = 'N'
     C                   ENDIF
     C                   EVAL      OKTAXI = 'Y'
     C                   GOTO      ESrTaxInd

     C                   ELSE
     C                   EVAL      MsgIDXAr(1) = MsgID1
     C                   EVAL      FldNamXAr(1) = '#0TAXI'
     C                   EVAL      OKTAXI = 'N'
     C                   ENDIF

     C                   EXSR      SrUpdatErrs

     C     ESrTaxInd     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrProfCtr - Validate Profit Center                           *
      *****************************************************************
     C     SrProfCtr     BEGSR

     C                   IF        #0PRFC <> *BLANKS OR
     C                             #0PRFC = *BLANKS AND
     C                             OKBOKC = 'Y' AND OKDLST = 'Y'
     C                   EXSR      SrResetErrs

     C                   CALLB     'ZAVPROFITC'
      ** Parameters:
      **    Return code                          (output)
      **    Error message ID                     (output)
      **    Profit center                        (input)
      **    Profit centers used                  (input)
      **    Profit centers amendable             (input)
      **    Profit centers defaults used         (input)
      **    Deal type                            (input)
      **    Account Officer Code                 (input)
      **    Customer number                      (input)
      **    Book code                            (input)
      **    Deal subtype                         (input)
      **    Booking branch                       (input)
      **    Department from ZMUSER               (input)
      **    User from PSDS                       (input)
      **    Customer number OK flag              (input)
      **    Analytical accounting module         (input)
     C                   PARM                    RetCodeOut
     C                   PARM                    MsgID1
     C                   PARM                    #0PRFC
     C                   PARM                    BKPRCU
     C                   PARM                    BKPRCA
     C                   PARM                    BKPCDU
     C                   PARM                    #0DTYP
     C                   PARM                    BBACOC
     C                   PARM                    BBCUST
     C                   PARM                    #0BOKC
     C                   PARM                    #0DLST
     C                   PARM                    #0BRCA
     C                   PARM                    DPPT
     C                   PARM                    PSUser
     C                   PARM                    OKCNUM
     C                   PARM                    BGN0ST

     C                   IF        MsgID1 = *BLANKS
     C                   EVAL      OKPRFC = 'Y'
     C                   EVAL      RPPRFC = #0PRFC
     C                   GOTO      ESrProfCtr
     C                   ELSE
     C                   EVAL      MsgIDXAr(1) = MsgID1
     C                   EVAL      FldNamXAr(1) = '#0PRFC'
     C                   EVAL      OKPRFC = 'N'
     C                   ENDIF

     C                   EXSR      SrUpdatErrs
     C                   ENDIF

     C     ESrProfCtr    ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrOrigBrch - Validate Originating Branch                     *
      *****************************************************************
     C     SrOrigBrch    BEGSR

     C                   EXSR      SrResetErrs

     C                   CALLB     'ZAVORGBRCH'
      ** Parameters:
      **    Return code                          (output)
      **    Error message ID                     (output)
      **    Originating branch                   (input)
      **    Booking branch OK flag               (input)
      **    Booking branch                       (input)
      **    Multi-branch indicator               (input)
      **    Originating branch used              (input)
      **    Originating branch/user validation   (input)
      **    Response mode                        (input)
     C                   PARM                    RetCodeOut
     C                   PARM                    MsgID1
     C                   PARM                    #0ORBR
     C                   PARM                    OKBRCA
     C                   PARM                    #0BRCA
     C                   PARM                    BGMBIN
     C                   PARM                    BKOBRU
     C                   PARM                    BKOBUV
     C                   PARM                    RespMode

     C                   IF        MsgID1 = *BLANKS
     C                   EVAL      OKORBR = 'Y'
     C                   EVAL      RPORBR = #0ORBR
     C                   GOTO      ESrOrigBrch
     C                   ELSE
     C                   EVAL      MsgIDXAr(1) = MsgID1
     C                   EVAL      FldNamXAr(1) = '#0ORBR'
     C                   EVAL      OKORBR = 'N'
     C                   ENDIF

     C                   EXSR      SrUpdatErrs

     C     ESrOrigBrch   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrBuySell - Validate Buy/Sell Indicator                      *
      *****************************************************************
     C     SrBuySell     BEGSR

     C                   EXSR      SrResetErrs
     C                   EVAL      WOurTheir = *BLANK

     C                   CALLB     'IRVBUYSELL'
      ** Parameters:
      **    Return code                          (output)
      **    Error message ID                     (output)
      **    Buy/Sell indicator                   (input)
     C                   PARM                    RetCodeOut
     C                   PARM                    MsgID1
     C                   PARM                    #0BYSL

     C                   IF        MsgID1 = *BLANKS
     C                   IF        #0DTYP = 'RP' AND #0BYSL = 'B' OR
     C                             #0DTYP = 'RR' AND #0BYSL = 'B' OR
     C                             #0DTYP = 'RF' AND #0BYSL = 'S'
     C                   EVAL      WOurTheir = 'T'
     C                   ELSE
     C                   EVAL      WOurTheir = 'O'
     C                   ENDIF
     C                   EVAL      OKBYSL = 'Y'
     C                   EVAL      RPBYSL = #0BYSL
     C                   GOTO      ESrBuySell

     C                   ELSE
     C                   EVAL      MsgIDXAr(1) = MsgID1
     C                   EVAL      FldNamXAr(1) = '#0BYSL'
     C                   EVAL      OKBYSL = 'N'
     C                   ENDIF

     C                   EXSR      SrUpdatErrs

     C     ESrBuySell    ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrBaseRt - Validate Base Rate                                *
      *****************************************************************
     C     SrBaseRt      BEGSR

     C                   EXSR      SrResetErrs

     C                   CALLB     'IRVBRATCDE'
      ** Parameters:
      **    Return code                          (output)
      **    Error message ID 1                   (output)
      **    Error message ID 2                   (output)
      **    Base rate code                       (input)
      **    Currency code OK flag                (input)
      **    Currency code                        (input)
      **    CIR001 switchable feature            (input)
      **    Interest pymt freq. temporary field  (input)
      **    Rate change freq. temporary field    (input)
      **    Deal type                            (input)
      **    CIR007 switchable feature            (input)
     C                   PARM                    RetCodeOut
     C                   PARM                    MsgID1
     C                   PARM                    MsgID2
     C                   PARM                    #0BRTT
     C                   PARM                    OKCUCY
     C                   PARM                    #0CUCY
     C                   PARM                    CIR001
     C                   PARM      *BLANKS       WIntPyFq
     C                   PARM      *BLANKS       WRtChgFq
     C                   PARM                    #0DTYP
     C                   PARM                    CIR007

     C                   IF        MsgID1 = *BLANKS
     C                   SELECT
     C                   WHEN      WOurTheir = 'O'
     C                   MOVE      #0BRTT        RPUBRTT
     C                   WHEN      WOurTheir = 'T'
     C                   MOVE      #0BRTT        RPTBRTT
     C                   ENDSL
     C                   EVAL      OKBRTT = 'Y'
     C                   GOTO      ESrBaseRt

     C                   ELSE
     C                   EVAL      MsgIDXAr(1) = MsgID1
     C                   EVAL      FldNamXAr(1) = '#0BRTT'
     C                   EVAL      OKBRTT = 'N'
     C                   ENDIF

     C                   EXSR      SrUpdatErrs

     C     ESrBaseRt     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrSprdRt - Validate Spread Rate                              *
      *****************************************************************
     C     SrSprdRt      BEGSR

     C                   EXSR      SrResetErrs

     C                   CALLB     'IRVSPRRATE'
      ** Parameters:
      **    Return code                          (output)
      **    Error message ID                     (output)
      **    Spread rate in Screen format         (input)
      **    CIR001 switchable feature            (input)
      **    Interest payment frequency           (input)
      **    Base rate code                       (input)
      **    Deal Type                            (input)
      **    Spread rate in File format           (output)
     C                   PARM                    RetCodeOut
     C                   PARM                    MsgID1
     C                   PARM                    #0RTSP
     C                   PARM                    CIR001
     C                   PARM                    #0IPFR
     C                   PARM                    #0BRTT
     C                   PARM                    #0DTYP
     C                   PARM                    W_RTSP
     C                   PARM                    BNDCSP                                       245692

     C                   IF        MsgID1 = *BLANKS
     C                   SELECT
     C                   WHEN      WOurTheir = 'O'
     C                   EVAL      RPURTSP = W_RTSP
     C                   WHEN      WOurTheir = 'T'
     C                   EVAL      RPTRTSP = W_RTSP
     C                   ENDSL
     C                   EVAL      OKRTSP = 'Y'
     C                   GOTO      ESrSprdRt

     C                   ELSE
     C                   EVAL      MsgIDXAr(1) = MsgID1
     C                   EVAL      FldNamXAr(1) = '#0RTSP'
     C                   EVAL      OKRTSP = 'N'
     C                   ENDIF

     C                   EXSR      SrUpdatErrs

     C     ESrSprdRt     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrSprdInd - Validate Spread Indicator                        *
      *****************************************************************
     C     SrSprdInd     BEGSR

     C                   EXSR      SrResetErrs

     C                   CALLB     'IRVSPRDIND'
      ** Parameters:
      **    Return code                          (output)
      **    Error message ID                     (output)
      **    Spread indicator                     (input)
      **    Spread rate in Screen format         (input)
      **    Base rate code                       (input)
     C                   PARM                    RetCodeOut
     C                   PARM                    MsgID1
     C                   PARM                    #0SPIN
     C                   PARM                    #0RTSP
     C                   PARM                    #0BRTT

     C                   IF        MsgID1 = *BLANKS
     C                   SELECT
     C                   WHEN      WOurTheir = 'O'
     C                   EVAL      RPUSPIN = #0SPIN
     C                   WHEN      WOurTheir = 'T'
     C                   EVAL      RPTSPIN = #0SPIN
     C                   ENDSL
     C                   EVAL      OKSPIN = 'Y'
     C                   GOTO      ESrSprdInd

     C                   ELSE
     C                   EVAL      MsgIDXAr(1) = MsgID1
     C                   EVAL      FldNamXAr(1) = '#0SPIN'
     C                   EVAL      OKSPIN = 'N'
     C                   ENDIF

     C                   EXSR      SrUpdatErrs

     C     ESrSprdInd    ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrRtFxDay - Validate Rate Fix Days                           *
      *****************************************************************
     C     SrRtFxDay     BEGSR

     C                   EXSR      SrResetErrs

     C                   CALLB     'IRVRTFXDAY'
      ** Parameters:
      **    Return code                          (output)
      **    Error message ID                     (output)
      **    Rate fix days in Screen format       (input)
      **    Base rate code                       (input)
      **    Currency code                        (input)
      **    Trading ICD currency code            (input)
      **    Local currency                       (input)
      **    Rate fix days in File format         (output)
      **    Rate change frequency                (input)
      **    Deal type                            (input)
      **    CIR007 switchable feature            (input)
      **    Average rate method                  (input)
     C                   PARM                    RetCodeOut
     C                   PARM                    MsgID1
     C                   PARM                    #0FRFD
     C                   PARM                    #0BRTT
     C                   PARM                    #0CUCY
     C                   PARM                    BLCYCD
     C                   PARM                    BJLCCY
     C                   PARM                    W_FRFD
     C                   PARM                    #0ICFR
     C                   PARM                    #0DTYP
     C                   PARM                    CIR007
     C                   PARM                    #0AVRM

     C                   IF        MsgID1 = *BLANKS
     C                   SELECT
     C                   WHEN      WOurTheir = 'O'
     C                   EVAL      RPUFRFD = W_FRFD
     C                   WHEN      WOurTheir = 'T'
     C                   EVAL      RPTFRFD = W_FRFD
     C                   ENDSL
     C                   EVAL      OKFRFD = 'Y'
     C                   GOTO      ESrRtFxDay

     C                   ELSE
     C                   EVAL      MsgIDXAr(1) = MsgID1
     C                   EVAL      FldNamXAr(1) = '#0FRFD'
     C                   EVAL      OKFRFD = 'N'
     C                   ENDIF

     C                   EXSR      SrUpdatErrs

     C     ESrRtFxDay    ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrRtChgDt - Validate Rate Change Date                        *
      *****************************************************************
     C     SrRtChgDt     BEGSR

      ** If Business Day Convention enhancement is installed and this
      ** was called from the CTL module, validate BDC fields first

     C                   IF        CIR005 = 'Y' AND ModeOfOp = '*FRONT'
     C                   EXSR      SrBusDyCcy
     C                   EXSR      SrPyAmtConv
     C                   ENDIF

     C                   EXSR      SrResetErrs

      ** Use field that is 128 long due to change in IRSBDYPD                                 CIR017
      ** The entry parm for IRVRTCHGDT is the IRSBDYPD layout                                 CIR017
      **                                                                                      CIR017
     C                   EVAL      BsDayConv = DSBsDyConv                                     CIR017
      **                                                                                      CIR017
     C                   CALLB     'IRVRTCHGDT'
      ** Parameters:
      **    Return code                          (output)
      **    Error message ID                     (output)
      **    Warning message ID 1                 (output)
      **    Warning message ID 2                 (output)
      **    Warning message ID 3                 (output)
      **    Warning message data                 (output)
      **    Rate change date in File format      (output)
      **    Rate change date in Screen format    (input)
      **    Base rate code                       (input)
      **    Midas rundate                        (input)
      **    Value date in File format            (input)
      **    Maturity date in File format         (input)
      **    Currency for rate fix holiday        (input)
      **    Local currency                       (input)
      **    Trading ICD currency code            (input)
      **    System location code                 (input)
      **    Currency code                        (input)
      **    Rate fix days                        (input)
      **    Value date OK flag                   (input)
      **    Maturity date OK flag                (input)
      **    Rate fix days OK flag                (input)
      **    Currency code OK flag                (input)
      **    Date format indicator                (input)
      **    Rate change day                      (output)
      **    Average rate method                  (input)
      **    Mode of operation                    (input)
      **    Validate Business day conv. flag     (input)
      **    Business day convention fields       (input)
      **    Rate fix days (previous)             (input)
      **    Rate change date (previous)          (input)
      **    Rate change frequency                (input)
      **    Deal type                            (input)
      **    CIR007 switchable feature            (input)
      **    Action Code (only used for SIRS)     (input)                                      CIR018
      **    Original Entry Date (only for SIRS)  (input)                                      CIR018
     C                   PARM                    RetCodeOut
     C                   PARM                    MsgID1
     C                   PARM                    WarnMsg1
     C                   PARM                    WarnMsg2
     C                   PARM                    WarnMsg3
     C                   PARM                    WarnMsgDta
     C                   PARM                    W_NICD
     C                   PARM                    #0NICD
     C                   PARM                    #0BRTT
     C                   PARM                    BJRDNB
     C                   PARM                    RPVDAT
     C                   PARM                    RPMDAT
     C                   PARM                    BQCRFH
     C                   PARM                    BJLCCY
     C                   PARM                    BLCYCD
     C                   PARM                    BJSLCD
     C                   PARM                    #0CUCY
     C                   PARM                    #0FRFD
     C                   PARM                    OKVDAT
     C                   PARM                    OKMDAT
     C                   PARM                    OKFRFD
     C                   PARM                    OKCUCY
     C                   PARM                    BJDFIN
     C                   PARM                    W_ICFD
     C                   PARM                    #0AVRM
     C                   PARM                    ModeOfOp
     C                   PARM                    ValidateBDC
     C**********         PARM                    DSBsDyConv                                   CIR017
     C                   PARM                    BsDayConv                                    CIR017
     C                   PARM                    @#0FRFD
     C                   PARM                    @#0NICD
     C                   PARM                    #0ICFR
     C                   PARM                    #0DTYP
     C                   PARM                    CIR007
     C                   PARM                    PActCode                                     CIR018
     C                   PARM                    POred                                        CIR018
      **                                                                                      CIR017
      ** Reset original field for subsequent processing                                       CIR017
     C                   EVAL      DSBsDyConv = BsDayConv                                     CIR017
      **                                                                                      CIR017

     C                   IF        MsgID1 = *BLANKS AND WarnMsg1 = *BLANKS
     C                             AND WarnMsg2 = *BLANKS AND WarnMsg3 = *BLANKS
     C                   SELECT
     C                   WHEN      WOurTheir = 'O'
     C                   EVAL      RPUNICD = W_NICD
     C                   EVAL      RPUICFD = W_ICFD
     C                   WHEN      WOurTheir = 'T'
     C                   EVAL      RPTNICD = W_NICD
     C                   EVAL      RPTICFD = W_ICFD
     C                   ENDSL
     C                   EVAL      OKNICD = 'Y'
     C                   GOTO      ESrRtChgDt
     C                   ENDIF

     C                   IF        MsgID1 <> *BLANKS
     C                   EVAL      MsgIDXAr(1) = MsgID1
     C                   EVAL      FldNamXAr(1) = '#0NICD'
     C                   EVAL      OKNICD = 'N'
     C                   ENDIF

     C                   IF        WarnMsg1 <> *BLANKS OR
     C                             WarnMsg2 = *BLANKS OR
     C                             WarnMsg3 = *BLANKS
     C                   SELECT
     C                   WHEN      WOurTheir = 'O'
     C                   EVAL      RPUNICD = W_NICD
     C                   EVAL      RPUICFD = W_ICFD
     C                   WHEN      WOurTheir = 'T'
     C                   EVAL      RPTNICD = W_NICD
     C                   EVAL      RPTICFD = W_ICFD
     C                   ENDSL
     C                   ENDIF

     C                   IF        WarnMsg1 <> *BLANKS
     C                   EVAL      J = J + 1
     C                   EVAL      WMsgIDXAr(J) = WarnMsg1
     C                   EVAL      WFldNmXAr(J) = '#0NICD'
     C                   EVAL      OKNICD = 'W'
     C                   ENDIF

     C                   IF        WarnMsg2 <> *BLANKS
     C                   EVAL      J = J + 1
     C                   EVAL      WMsgIDXAr(J) = WarnMsg2
     C                   EVAL      WFldNmXAr(J) = '#0NICD'
     C                   EVAL      OKNICD = 'W'
     C                   ENDIF

     C                   IF        WarnMsg3 <> *BLANKS
     C                   EVAL      J = J + 1
     C                   EVAL      WMsgIDXAr(J) = WarnMsg3
     C                   EVAL      WMsgDtXAr(J) = WarnMsgDta
     C                   EVAL      WFldNmXAr(J) = '#0NICD'
     C                   EVAL      OKNICD = 'W'
     C                   ENDIF

     C                   EXSR      SrUpdatErrs

     C     ESrRtChgDt    ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrRtChgFq - Validate Rate Change Frequency                   *
      *****************************************************************
     C     SrRtChgFq     BEGSR

     C                   EXSR      SrResetErrs

     C                   CALLB     'IRVRTCHGFQ'
      ** Parameters:
      **    Return code                          (output)
      **    Error message ID                     (output)
      **    CIR001 switchable feature            (input)
      **    Rate change frequency                (input)
      **    Rate change date                     (input)
      **    Action code                          (input)
      **    Deal number                          (input)
      **    Our/Their side                       (input)
      **    CIR007 switchable feature            (input)
     C                   PARM                    RetCodeOut
     C                   PARM                    MsgID1
     C                   PARM                    CIR001
     C                   PARM                    #0ICFR
     C                   PARM                    #0NICD
     C                   PARM                    #0ACCD
     C                   PARM                    #0DLNO
     C                   PARM      'O'           WChar1A
     C                   PARM                    #0DTYP
     C                   PARM                    CIR007

     C                   IF        MsgID1 = *BLANKS
     C                   SELECT
     C                   WHEN      WOurTheir = 'O'
     C                   EVAL      RPUICFR = #0ICFR
     C                   WHEN      WOurTheir = 'T'
     C                   EVAL      RPTICFR = #0ICFR
     C                   ENDSL
     C                   EVAL      OKICFR = 'Y'
     C                   GOTO      ESrRtChgFq

     C                   ELSE
     C                   EVAL      MsgIDXAr(1) = MsgID1
     C                   EVAL      FldNamXAr(1) = '#0ICFR'
     C                   EVAL      OKICFR = 'N'
     C                   ENDIF

     C                   EXSR      SrUpdatErrs

     C     ESrRtChgFq    ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrRtChgDay - Validate Rate Change Day                        *
      *****************************************************************
     C     SrRtChgDay    BEGSR

     C                   EXSR      SrResetErrs

     C                   CALLB     'IRVRTCHGDY'
      ** Parameters:
      **    Return code                          (output)
      **    Error message ID                     (output)
      **    Rate change frequency                (input)
      **    Rate change date in Screen format    (input)
      **    Rate change day in Screen format     (input)
      **    Rate change date in File format      (input)
      **    Work field for Rate change day       (output)
      **    Rate change day in File format       (output)
      **    Deal type                            (input)
      **    CIR007 switchable feature            (input)
     C                   PARM                    RetCodeOut
     C                   PARM                    MsgID1
     C                   PARM                    #0ICFR
     C                   PARM                    #0NICD
     C                   PARM                    #0ICFD
     C                   PARM                    W_NICD
     C                   PARM                    WRtChgDy
     C                   PARM                    W_ICFD
     C                   PARM                    #0DTYP
     C                   PARM                    CIR007

     C                   IF        MsgID1 = *BLANKS
     C                   SELECT
     C                   WHEN      WOurTheir = 'O'
     C                   EVAL      RPUICFD = W_ICFD
     C                   WHEN      WOurTheir = 'T'
     C                   EVAL      RPTICFD = W_ICFD
     C                   ENDSL
     C                   EVAL      OKICFD = 'Y'
     C                   GOTO      ESrRtChgDay

     C                   ELSE
     C                   EVAL      MsgIDXAr(1) = MsgID1
     C                   EVAL      FldNamXAr(1) = '#0ICFD'
     C                   EVAL      OKICFD = 'N'
     C                   ENDIF

     C                   EXSR      SrUpdatErrs

     C     ESrRtChgDay   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrIntPyDt - Validate Interest Payment Date                   *
      *****************************************************************
     C     SrIntPyDt     BEGSR

     C                   EXSR      SrResetErrs

     C                   CALLB     'IRVINTPYDT'
      ** Parameters:
      **    Return code                          (output)
      **    Error message ID                     (output)
      **    Interest payment date in Screen fmt  (input)
      **    Value date in File format            (input)
      **    Maturity date in File format         (input)
      **    Value date OK flag                   (input)
      **    Maturity date OK flag                (input)
      **    Interest payment date in File format (output)
      **    Rate change date in File format      (input)
      **    Average rate method                  (input)
      **    Rate change day in File format       (input)
      **    Rate change frequency                (input)
      **    Currency code                        (input)
      **    Work field for Interest payment day  (output)
      **    Rate change frequency OK flag        (input)
      **    Rate change date OK flag             (input)
      **    Rate change day OK flag              (input)
      **    Mode of operation                    (input)
      **    Validate Business day conv. flag     (input)
      **    Currencies for Payment convention    (input)
      **    Warning message ID 1                 (output)
      **    Warning message data                 (output)
      **    General ledger details               (output)
      **    Bank details                         (input)
     C                   PARM                    RetCodeOut
     C                   PARM                    MsgID1
     C                   PARM                    #0NIPD
     C                   PARM                    RPVDAT
     C                   PARM                    RPMDAT
     C                   PARM                    OKVDAT
     C                   PARM                    OKMDAT
     C                   PARM                    W_NIPD
     C                   PARM                    W_NICD
     C                   PARM                    #0AVRM
     C                   PARM                    W_ICFD
     C                   PARM                    #0ICFR
     C                   PARM                    #0CUCY
     C                   PARM                    WIntPyDay
     C                   PARM                    OKICFR
     C                   PARM                    OKNICD
     C                   PARM                    OKICFD
     C                   PARM                    ModeOfOp
     C                   PARM                    ValidateBDC
     C                   PARM                    DSPymtCcys
     C                   PARM                    WarnMsg1
     C                   PARM                    WarnMsgDta
     C     SDGELR        PARM                    SDGELR
     C                   PARM                    SDBANK

     C                   IF        MsgID1 = *BLANKS AND WarnMsg1 = *BLANKS
     C                   SELECT
     C                   WHEN      WOurTheir = 'O'
     C                   EVAL      RPUNIPD = W_NIPD
     C                   WHEN      WOurTheir = 'T'
     C                   EVAL      RPTNIPD = W_NIPD
     C                   ENDSL
     C                   EVAL      OKNIPD = 'Y'
     C                   GOTO      ESrIntPyDt
     C                   ENDIF

     C                   IF        MsgID1 <> *BLANKS
     C                   EVAL      MsgIDXAr(1) = MsgID1
     C                   EVAL      FldNamXAr(1) = '#0NIPD'
     C                   EVAL      OKNIPD = 'N'
     C                   ENDIF

     C                   IF        WarnMsg1 <> *BLANKS
     C                   EVAL      WMsgIDXAr(1) = WarnMsg1
     C                   EVAL      WMsgDtXAr(1) = WarnMsgDta
     C                   EVAL      WFldNmXAr(1) = '#0NIPD'
     C                   EVAL      OKNIPD = 'W'
     C                   SELECT
     C                   WHEN      WOurTheir = 'O'
     C                   EVAL      RPUNIPD = W_NIPD
     C                   WHEN      WOurTheir = 'T'
     C                   EVAL      RPTNIPD = W_NIPD
     C                   ENDSL
     C                   ENDIF

     C                   EXSR      SrUpdatErrs

     C     ESrIntPyDt    ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrIntPyFq - Validate Interest Payment Frequency              *
      *****************************************************************
     C     SrIntPyFq     BEGSR

     C                   EXSR      SrResetErrs

     C                   CALLB     'IRVINTPYFQ'
      ** Parameters:
      **    Return code                          (output)
      **    Error message ID 1                   (output)
      **    Error message ID 2                   (output)
      **    Interest payment frequency           (input)
      **    Interest payment date in Screen fmt  (input)
      **    CIR001 switchable feature            (input)
      **    Interest payment frequency OK flag   (output)
      **    Rate change day OK flag              (input)
      **    Average rate method                  (input)
      **    Rate change frequency                (input)
      **    Deal type                            (input)
      **    CIR007 switchable feature            (input)
     C                   PARM                    RetCodeOut
     C                   PARM                    MsgID1
     C                   PARM                    MsgID2
     C                   PARM                    #0IPFR
     C                   PARM                    #0NIPD
     C                   PARM                    CIR001
     C                   PARM                    OKIPFR
     C                   PARM                    OKICFD
     C                   PARM                    #0AVRM
     C                   PARM                    #0ICFR
     C                   PARM                    #0DTYP
     C                   PARM                    CIR007

     C                   IF        MsgID1 = *BLANKS AND MsgID2 = *BLANKS
     C                   SELECT
     C                   WHEN      WOurTheir = 'O'
     C                   EVAL      RPUIPFR = #0IPFR
     C                   WHEN      WOurTheir = 'T'
     C                   EVAL      RPTIPFR = #0IPFR
     C                   ENDSL
     C                   EVAL      OKIPFR = 'Y'
     C                   GOTO      ESrIntPyFq
     C                   ENDIF

     C                   IF        MsgID1 <> *BLANKS
     C                   EVAL      J = J + 1
     C                   EVAL      MsgIDXAr(J) = MsgID1
     C                   EVAL      FldNamXAr(J) = '#0IPFR'
     C                   EVAL      OKIPFR = 'N'
     C                   ENDIF

     C                   IF        MsgID2 <> *BLANKS
     C                   EVAL      J = J + 1
     C                   EVAL      MsgIDXAr(J) = MsgID2
     C                   EVAL      FldNamXAr(J) = '#0IPFR'
     C                   EVAL      OKIPFR = 'N'
     C                   ENDIF

     C                   EXSR      SrUpdatErrs

     C     ESrIntPyFq    ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrIntPyDay - Validate Interest Payment Day                   *
      *****************************************************************
     C     SrIntPyDay    BEGSR

     C                   EXSR      SrResetErrs

     C                   CALLB     'IRVINTPYDY'
      ** Parameters:
      **    Return code                          (output)
      **    Error message ID 1                   (output)
      **    Error message ID 2                   (output)
      **    Average rate method                  (input)
      **    Interest payment day in Screen fmt   (input)
      **    Interest payment frequency           (input)
      **    Interest payment day in File format  (output)
      **    Rate change date in File format      (input)
      **    Interest payment date in File format (input)
      **    Rate change day in File format       (input)
     C                   PARM                    RetCodeOut
     C                   PARM                    MsgID1
     C                   PARM                    MsgID2
     C                   PARM                    #0AVRM
     C                   PARM                    #0IPFD
     C                   PARM                    #0IPFR
     C                   PARM                    W_IPFD
     C                   PARM                    W_NICD
     C                   PARM                    W_NIPD
     C                   PARM                    W_ICFD

     C                   IF        MsgID1 = *BLANKS AND MsgID2 = *BLANKS
     C                   SELECT
     C                   WHEN      WOurTheir = 'O'
     C                   EVAL      RPUIPFD = W_IPFD
     C                   WHEN      WOurTheir = 'T'
     C                   EVAL      RPTIPFD = W_IPFD
     C                   ENDSL
     C                   EVAL      OKIPFD = 'Y'
     C                   GOTO      ESrIntPyDay
     C                   ENDIF

     C                   IF        MsgID1 <> *BLANKS
     C                   EVAL      J = J + 1
     C                   EVAL      MsgIDXAr(J) = MsgID1
     C                   EVAL      FldNamXAr(J) = '#0IPFD'
     C                   EVAL      OKIPFD = 'N'
     C                   ENDIF

     C                   IF        MsgID2 <> *BLANKS
     C                   EVAL      J = J + 1
     C                   EVAL      MsgIDXAr(J) = MsgID2
     C                   EVAL      FldNamXAr(J) = '#0IPFD'
     C                   EVAL      OKIPFD = 'N'
     C                   ENDIF

     C                   EXSR      SrUpdatErrs

     C     ESrIntPyDay   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrEffIntRt - Validate Short Term Rate (but value is written  *
      *               to the file as Effective Interest Rate)         *
      *****************************************************************
     C     SrEffIntRt    BEGSR

     C                   EXSR      SrResetErrs

     C                   CALLB     'IRVSTERMRT'
      ** Parameters:
      **    Return code                          (output)
      **    Error message ID                     (output)
      **    Value date OK flag                   (input)
      **    Currency code OK flag                (input)
      **    Rate fix days OK flag                (input)
      **    Base rate code OK flag               (input)
      **    Value date in File format            (input)
      **    Local currency                       (input)
      **    Trading ICD currency code            (input)
      **    Currency for rate fix holiday        (input)
      **    System location code                 (input)
      **    Midas rundate                        (input)
      **    Short term rate in Screen format     (input)
      **    Base rate code                       (input)
      **    Rate fix days in File format         (input)
      **    Short term rate in File format       (output)
      **    Mode of operation                    (input)
      **    Validate Business day conv. flag     (input)
      **    Currencies for Rate fix convention   (input)
      **    Rate change frequency                (input)
      **    Deal type                            (input)
      **    CIR007 switchable feature            (input)
     C                   PARM                    RetCodeOut
     C                   PARM                    MsgID1
     C                   PARM                    OKVDAT
     C                   PARM                    OKCUCY
     C                   PARM                    OKFRFD
     C                   PARM                    OKBRTT
     C                   PARM                    RPVDAT
     C                   PARM                    BJLCCY
     C                   PARM                    BLCYCD
     C                   PARM                    BQCRFH
     C                   PARM                    BJSLCD
     C                   PARM                    BJRDNB
     C                   PARM                    #0EINR
     C                   PARM                    #0BRTT
     C                   PARM                    W_FRFD
     C                   PARM                    W_EINR
     C                   PARM                    ModeOfOp
     C                   PARM                    ValidateBDC
     C                   PARM                    DSRtFxCcys
     C                   PARM                    #0ICFR
     C                   PARM                    #0DTYP
     C                   PARM                    CIR007
     C                   PARM                    SAVRAM                                       222373
      ** Sign of Short Term Rate                                                             BUG6472
     C                   PARM                    #0SIGN                                      BUG6472
     C                   PARM                    BNDCSP                                       245692
      ** Transaction currency                                                               BUG11457
     C**********         PARM                    #0CUCY                            BUG11457 MD033488
     C                   PARM                    RPORED                                     MD051346
     C                   PARM                    #0ACCD                                     MD051346

     C                   IF        MsgID1 = *BLANKS
     C                   SELECT
     C                   WHEN      #0AVRM = 'Y'
     C                   EVAL      RPAACRT = W_EINR
     C                   WHEN      #0AVRM <> 'Y' AND OKAVRM = 'Y' AND
     C                             WOurTheir = 'O'
     C                   EVAL      RPUEINR = W_EINR
     C                   WHEN      #0AVRM <> 'Y' AND OKAVRM = 'Y' AND
     C                             WOurTheir = 'T'
     C                   EVAL      RPTEINR = W_EINR
     C                   ENDSL
     C                   EVAL      OKEINR = 'Y'
     C                   GOTO      ESrEffIntRt

     C                   ELSE
     C                   IF        MsgID1 = 'MMA0032' AND #0AVRM = 'Y'
     C                   EVAL      MsgID1 = 'MMA1302'
     C                   ENDIF
     C                   EVAL      MsgIDXAr(1) = MsgID1
     C                   EVAL      FldNamXAr(1) = '#0EINR'
     C                   EVAL      OKEINR = 'N'
     C                   ENDIF

     C                   EXSR      SrUpdatErrs

     C     ESrEffIntRt   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrClFlRat - Validate Ceiling and Floor Rates                 *
      *****************************************************************
     C     SrClFlRat     BEGSR

     C                   EXSR      SrResetErrs

     C                   CALLB     'IRVCLFLRAT'
      ** Parameters:
      **    Return code                          (output)
      **    Error message ID 1                   (output)
      **    Error message ID 2                   (output)
      **    Ceiling rate in Screen format        (input)
      **    Floor rate in Screen format          (input)
      **    Deal type                            (input)
      **    Floor rate in File format            (output)
      **    Ceiling rate in File format          (output)
     C                   PARM                    RetCodeOut
     C                   PARM                    MsgID1
     C                   PARM                    MsgID2
     C                   PARM                    #0CRAT
     C                   PARM                    #0FRAT
     C                   PARM                    #0DTYP
     C                   PARM                    RPFLRAT
     C                   PARM                    RPCLRAT
     C                   PARM                    BNDCSP                                       245692

     C                   IF        MsgID1 = *BLANKS AND MsgID2 = *BLANKS
     C                   IF        #0DTYP = 'RF'
     C                   Z-ADD     *HIVAL        RPCLRAT
     C                   ENDIF
     C                   IF        #0FRAT <> *BLANKS
     C                   BITON     '4'           RPUDSTI
     C                   BITON     '4'           RPTDSTI
     C                   ENDIF
     C                   EVAL      OKCRAT = 'Y'
     C                   EVAL      OKFRAT = 'Y'
     C                   GOTO      ESrClFlRat
     C                   ENDIF

     C                   IF        MsgID1 <> *BLANKS
     C                   EVAL      J = J + 1
     C                   EVAL      MsgIDXAr(J) = MsgID1
     C                   SELECT
     C                   WHEN      MsgID1 = 'MMA0052'
     C                   EVAL      FldNamXAr(J) = '#0CRAT'
     C                   EVAL      OKCRAT = 'N'
     C                   WHEN      MsgID1 = 'MMA0053'
     C                   EVAL      FldNamXAr(J) = '#0FRAT'
     C                   EVAL      OKFRAT = 'N'
     C                   ENDSL
     C                   ENDIF

     C                   IF        MsgID2 <> *BLANKS
     C                   EVAL      J = J + 1
     C                   EVAL      MsgIDXAr(J) = MsgID2
     C                   EVAL      FldNamXAr(J) = '#0FRAT'
     C                   EVAL      OKFRAT = 'N'
     C                   ENDIF

     C                   EXSR      SrUpdatErrs

     C     ESrClFlRat    ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrAvRtMth - Validate Average Rate Method                     *
      *****************************************************************
     C     SrAvRtMth     BEGSR

     C                   EXSR      SrResetErrs

     C                   CALLB     'IRVAVRTMTH'
      ** Parameters:
      **    Return code                          (output)
      **    Error message ID                     (output)
      **    Average rate method                  (input)
     C                   PARM                    RetCodeOut
     C                   PARM                    MsgID1
     C                   PARM                    #0AVRM

     C                   IF        MsgID1 = *BLANKS
     C                   IF        #0AVRM = 'Y'
     C                   BITON     '3'           RPUDSTI
     C                   BITON     '3'           RPTDSTI
     C                   END
     C                   EVAL      OKAVRM = 'Y'
     C                   GOTO      ESrAvRtMth

     C                   ELSE
     C                   EVAL      MsgIDXAr(1) = MsgID1
     C                   EVAL      FldNamXAr(1) = '#0AVRM'
     C                   EVAL      OKAVRM = 'N'
     C                   ENDIF

     C                   EXSR      SrUpdatErrs

     C     ESrAvRtMth    ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrUpFVD - Validate Up-front Premium Value Date,              *
      *            only if CIR006 is off                              *
      *****************************************************************
     C     SrUpFVD       BEGSR

     C                   IF        CIR006 = 'Y'
     C                   GOTO      ESrUpFVD
     C                   ENDIF

     C                   EXSR      SrUpFInit
     C                   EXSR      SrResetErrs

     C                   CALLB     'IRVUPVD01'
      ** Parameters:
      **    Return code                          (output)
      **    Fees/Buy-Outs in screen format       (input)
      **    Settlement currency                  (input)
      **    Receiver's currency                  (input)
      **    Pay nostro location                  (input)
      **    Receive nostro location              (input)
      **    Date format indicator                (input)
      **    Local currency                       (input)
      **    System location code                 (input)
      **    Appended field names array           (output)
      **    Appended message IDs array           (output)
      **    Appended message data array          (output)
      **    Appended warning fields array        (output)
      **    Appended warning messages array      (output)
      **    Appended warning message data array  (output)
      **    Fees/Buy-Outs OK flags               (output)
      **    Fees/Buy-Outs data structure         (output)
     C                   PARM                    RetCodeOut
     C                   PARM                    IRFEBO
     C                   PARM                    PWPSCY
     C                   PARM                    PWRSCY
     C                   PARM                    PWPNLOC
     C                   PARM                    PWRNLOC
     C                   PARM                    BJDFIN
     C                   PARM                    BJLCCY
     C                   PARM                    BJSLCD
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIdXAr
     C                   PARM                    WMsgDtXAr
     C                   PARM                    OKFEBO
     C                   PARM                    Data

     C                   EVAL      OKPUPVD = FB_OKUFVD
     C                   EVAL      RPUPVD = #1UPVD

     C                   EXSR      SrUpdatErrs

     C     ESrUpFVD      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrUpFFE - Validate Up-front Premium Amount,                  *
      *            only if CIR006 is off                              *
      *****************************************************************
     C     SrUpFFE       BEGSR

     C                   IF        CIR006 = 'Y'
     C                   GOTO      ESrUpFFE
     C                   ENDIF

     C                   EXSR      SrResetErrs

     C                   CALLB     'IRVUPFE01'
      ** Parameters:
      **    Return code                          (output)
      **    Fees/Buy-Outs in screen format       (input)
      **    Decimal places - Our                 (input)
      **    Decimal places - Their               (input)
      **    Appended field names array           (output)
      **    Appended message IDs array           (output)
      **    Appended message data array          (output)
      **    Appended warning fields array        (output)
      **    Appended warning messages array      (output)
      **    Appended warning message data array  (output)
      **    Fees/Buy-Outs OK flags               (output)
      **    Fees/Buy-Outs data structure         (output)
     C                   PARM                    RetCodeOut
     C                   PARM                    IRFEBO
     C                   PARM                    PWUCDP
     C                   PARM                    PWTCDP
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
     C                   PARM                    OKFEBO
     C                   PARM                    Data
     C                   PARM                    BNDCSP                                       245692

     C                   EVAL      OKPUPFE = FB_OKUFEE
     C                   EVAL      RPUPFE = #1UPFE
     C                   EVAL      #0PUPFE = FB_SUFEE

     C                   EXSR      SrUpdatErrs

     C     ESrUpFFE      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrUpFInit - Initialise Up-front fields needed for validation  *
      *****************************************************************
     C     SrUpFInit     BEGSR

     C                   CLEAR                   Data
     C                   EVAL      OKFEBO = *ALL'Y'

     C                   EVAL      PWPSCY = #0CUCY
     C                   EVAL      PWRSCY = #0CUCY
     C                   EVAL      PWPNLOC = BJSLCD
     C                   EVAL      PWRNLOC = BJSLCD
     C                   Z-ADD     A6NBDP        PWUCDP
     C                   Z-ADD     A6NBDP        PWTCDP

     C                   EVAL      #1DDAT = RPDDAT
     C                   EVAL      #1VDAT = RPVDAT
     C                   EVAL      #1MDAT = RPMDAT
     C                   EVAL      #1USEN = PaySetMeth
     C                   EVAL      #1TSEN = RecSetMeth

     C                   EVAL      FB_SUFVD = #0PUPVD
     C                   EVAL      FB_SUFEE = #0PUPFE
     C                   IF        #0PUPVD = *BLANKS AND
     C                             #0PUPFE = *BLANKS
     C                   EVAL      FB_SUFPR = *BLANKS
     C                   ELSE
     C                   IF        #0BYSL = 'B'
     C                   EVAL      FB_SUFPR = 'P'
     C                   ELSE
     C                   EVAL      FB_SUFPR = 'R'
     C                   ENDIF
     C                   ENDIF

     C     ESrUpFInit    ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrBusDyCcy - Validate Business Day Convention Currencies     *
      *               (if VAL was called from CTL module)             *
      *****************************************************************
     C     SrBusDyCcy    BEGSR

     C                   EXSR      SrResetErrs

     C                   MOVE      DSRtFxCcys    WRtFxCcys
     C                   MOVE      DSPymtCcys    WPymtCcys

     C                   CALLB     'IRVBDYCCY'
      ** Parameters:
      **    Return code                          (output)
      **    Code                                 (input)
      **    Local currency                       (input)
      **    Rate fixing convention Currencies    (input)
      **    Payment convention Currencies        (input)
      **    OK Flags for Rate fixing convention  (output)
      **    OK Flags for Payment convention      (output)
      **    Appended message IDs array           (output)
      **    Appended field names array           (output)
      **    Appended warning messages array      (output)
      **    Appended warning fields array        (output)
     C                   PARM                    RetCodeOut
     C                   PARM      'B'           WCode
     C                   PARM                    BJLCCY
     C                   PARM                    WRtFxCcys
     C                   PARM                    WPymtCcys
     C                   PARM                    ArrRtFxOK
     C                   PARM                    ArrPymtOK
     C                   PARM                    MsgIDXAr
     C                   PARM                    FldNamXAr
     C                   PARM                    WMsgIdXAr
     C                   PARM                    WFldNmXAr

     C                   EVAL      J = 1
     C                   DOW       FldNamXAr(J) <> *BLANKS
     C                   SELECT
     C                   WHEN      FldNamXAr(J) = 'SC1R'
     C                   EVAL      FldNamXAr(J) = '#0C1R1'
     C                   WHEN      FldNamXAr(J) = 'SC2R'
     C                   EVAL      FldNamXAr(J) = '#0C2R1'
     C                   WHEN      FldNamXAr(J) = 'SC3R'
     C                   EVAL      FldNamXAr(J) = '#0C3R1'
     C                   WHEN      FldNamXAr(J) = 'SC4R'
     C                   EVAL      FldNamXAr(J) = '#0C4R1'
     C                   WHEN      FldNamXAr(J) = 'SC5R'
     C                   EVAL      FldNamXAr(J) = '#0C5R1'
     C                   WHEN      FldNamXAr(J) = 'SC6R'
     C                   EVAL      FldNamXAr(J) = '#0C6R1'
     C                   WHEN      FldNamXAr(J) = 'SC7R'
     C                   EVAL      FldNamXAr(J) = '#0C7R1'
     C                   WHEN      FldNamXAr(J) = 'SC8R'
     C                   EVAL      FldNamXAr(J) = '#0C8R1'
     C                   WHEN      FldNamXAr(J) = 'SC9R'
     C                   EVAL      FldNamXAr(J) = '#0C9R1'
     C                   WHEN      FldNamXAr(J) = 'SC0R'
     C                   EVAL      FldNamXAr(J) = '#0C0R1'
     C                   WHEN      FldNamXAr(J) = 'SC1P'
     C                   EVAL      FldNamXAr(J) = '#0C1P1'
     C                   WHEN      FldNamXAr(J) = 'SC2P'
     C                   EVAL      FldNamXAr(J) = '#0C2P1'
     C                   WHEN      FldNamXAr(J) = 'SC3P'
     C                   EVAL      FldNamXAr(J) = '#0C3P1'
     C                   WHEN      FldNamXAr(J) = 'SC4P'
     C                   EVAL      FldNamXAr(J) = '#0C4P1'
     C                   WHEN      FldNamXAr(J) = 'SC5P'
     C                   EVAL      FldNamXAr(J) = '#0C5P1'
     C                   WHEN      FldNamXAr(J) = 'SC6P'
     C                   EVAL      FldNamXAr(J) = '#0C6P1'
     C                   WHEN      FldNamXAr(J) = 'SC7P'
     C                   EVAL      FldNamXAr(J) = '#0C7P1'
     C                   WHEN      FldNamXAr(J) = 'SC8P'
     C                   EVAL      FldNamXAr(J) = '#0C8P1'
     C                   WHEN      FldNamXAr(J) = 'SC9P'
     C                   EVAL      FldNamXAr(J) = '#0C9P1'
     C                   WHEN      FldNamXAr(J) = 'SC0P'
     C                   EVAL      FldNamXAr(J) = '#0C0P1'
     C                   ENDSL
     C                   EVAL      J = J + 1
     C                   ENDDO

     C                   IF        WFldNmXAr(1) = 'SC1R'
     C                   EVAL      WFldNmXAr(1) = '#0C1R1'
     C                   ENDIF

     C                   MOVEA     ArrPymtOK     DSPymtOK
     C                   MOVEA     ArrRtFxOK     DSRtFxOK
     C                   EVAL      FilPymtCcys = WPymtCcys
     C                   EVAL      FilRtFxCcys = WRtFxCcys

     C                   EXSR      SrUpdatErrs

     C     ESrBusDyCcy   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrPyAmtConv - Validate Payment Date Convention and           *
      *                Amount Convention                              *
      *****************************************************************
     C     SrPyAmtConv   BEGSR

     C                   EXSR      SrResetErrs

     C                   CALLB     'IRVPAMCNV'
      ** Parameters:
      **    Return code                          (output)
      **    Payment date convention              (input)
      **    Amount convention                    (input)
      **    Payment date convention OK flag      (output)
      **    Amount convention OK flag            (output)
      **    Appended message IDs array           (output)
      **    Appended field names array           (output)
     C                   PARM                    RetCodeOut
     C                   PARM                    #0PDC1
     C                   PARM                    #0AMC1
     C                   PARM                    OKPDC1
     C                   PARM                    OKAMC1
     C                   PARM                    MsgIdXAr
     C                   PARM                    FldNamXAr

     C                   EVAL      J = 1
     C                   DOW       FldNamXAr(J) <> *BLANKS
     C                   SELECT
     C                   WHEN      FldNamXAr(J) = 'SPDC'
     C                   EVAL      FldNamXAr(J) = '#0PDC1'
     C                   WHEN      FldNamXAr(J) = 'SAMC'
     C                   EVAL      FldNamXAr(J) = '#0AMC1'
     C                   ENDSL
     C                   EVAL      J = J + 1
     C                   ENDDO

     C                   IF        OKPDC1 = 'Y'
     C                   EVAL      RPPDC1 = #0PDC1
     C                   ENDIF
     C                   IF        OKAMC1 = 'Y'
     C                   EVAL      RPAMC1 = #0AMC1
     C                   ENDIF

     C                   EXSR      SrUpdatErrs

     C     ESrPyAmtConv  ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       CDL028
      *  SrStartDate - Validate Start Date                            *                       CDL028
      *****************************************************************                       CDL028
     C     SrStartDate   BEGSR                                                                CDL028
                                                                                              CDL028
     C                   EXSR      SrResetErrs                                                CDL028
                                                                                              CDL028
     C                   CALLB     'IRVSTUBDTE'                                               CDL028
     C                   PARM                    RetCodeOut                                   CDL028
     C                   PARM                    MsgID1                                       CDL028
     C                   PARM                    BJDFIN                                       CDL028
     C                   PARM                    #0OSDT                                       CDL028
     C                   PARM                    StubDyNo                                     CDL028
                                                                                              CDL028
     C                   IF        MsgID1 = *BLANKS                                           CDL028
     C                   SELECT                                                               CDL028
     C                   WHEN      WOurTheir = 'O'                                            CDL028
     C                   Z-ADD     StubDyNo      RPOSDT                                       CDL028
     C                   WHEN      WOurTheir = 'T'                                            CDL028
     C                   Z-ADD     StubDyNo      RPTSDT                                       CDL028
     C                   ENDSL                                                                CDL028
                                                                                              CDL028
     C                   ELSE                                                                 CDL028
     C                   EVAL      J = J + 1                                                  CDL028
     C                   EVAL      MsgIDXAr(J) = MsgID1                                       CDL028
     C                   EVAL      FldNamXAr(J) = '#0OSDT'                                    CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CDL028
     C                   EXSR      SrUpdatErrs                                                CDL028
                                                                                              CDL028
     C                   ENDSR                                                                CDL028
      *****************************************************************                       CDL028
      /EJECT                                                                                  CDL028
      *****************************************************************                       CDL028
      *  SrS1TermBsRtC - Validate Start - 1st Term Base Rate Code     *                       CDL028
      *****************************************************************                       CDL028
     C     SrS1TermBsRtC BEGSR                                                                CDL028
                                                                                              CDL028
     C                   EXSR      SrResetErrs                                                CDL028
                                                                                              CDL028
     C                   CALLB     'IRVSTUBBRC'                                               CDL028
     C                   PARM                    RetCodeOut                                   CDL028
     C                   PARM                    MsgID1                                       CDL028
     C                   PARM                    #0OS1B                                       CDL028
     C                   PARM                    #0CUCY                                       CDL028
                                                                                              CDL028
     C                   IF        MsgID1 = *BLANKS                                           CDL028
     C                   SELECT                                                               CDL028
     C                   WHEN      WOurTheir = 'O'                                            CDL028
     C                   MOVE      #0OS1B        RPOS1B                                       CDL028
     C                   WHEN      WOurTheir = 'T'                                            CDL028
     C                   MOVE      #0OS1B        RPTS1B                                       CDL028
     C                   ENDSL                                                                CDL028
                                                                                              CDL028
     C                   ELSE                                                                 CDL028
     C                   EVAL      J = J + 1                                                  CDL028
     C                   EVAL      MsgIDXAr(J) = MsgID1                                       CDL028
     C                   EVAL      FldNamXAr(J) = '#0OS1B'                                    CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CDL028
     C                   EXSR      SrUpdatErrs                                                CDL028
                                                                                              CDL028
     C                   ENDSR                                                                CDL028
      *****************************************************************                       CDL028
      /EJECT                                                                                  CDL028
      *****************************************************************                       CDL028
      *  SrS1TermEndDt - Validate Start - 1st Term End Date           *                       CDL028
      *****************************************************************                       CDL028
     C     SrS1TermEndDt BEGSR                                                                CDL028
                                                                                              CDL028
     C                   EXSR      SrResetErrs                                                CDL028
                                                                                              CDL028
     C                   CALLB     'IRVSTUBDTE'                                               CDL028
     C                   PARM                    RetCodeOut                                   CDL028
     C                   PARM                    MsgID1                                       CDL028
     C                   PARM                    BJDFIN                                       CDL028
     C                   PARM                    #0OS1D                                       CDL028
     C                   PARM                    StubDyNo                                     CDL028
                                                                                              CDL028
     C                   IF        MsgID1 = *BLANKS                                           CDL028
     C                   SELECT                                                               CDL028
     C                   WHEN      WOurTheir = 'O'                                            CDL028
     C                   Z-ADD     StubDyNo      RPOS1D                                       CDL028
     C                   WHEN      WOurTheir = 'T'                                            CDL028
     C                   Z-ADD     StubDyNo      RPTS1D                                       CDL028
     C                   ENDSL                                                                CDL028
                                                                                              CDL028
     C                   ELSE                                                                 CDL028
     C                   EVAL      J = J + 1                                                  CDL028
     C                   EVAL      MsgIDXAr(J) = MsgID1                                       CDL028
     C                   EVAL      FldNamXAr(J) = '#0OS1D'                                    CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CDL028
     C                   EXSR      SrUpdatErrs                                                CDL028
                                                                                              CDL028
     C                   ENDSR                                                                CDL028
      *****************************************************************                       CDL028
      /EJECT                                                                                  CDL028
      *****************************************************************                       CDL028
      *  SrS2TermBsRtC - Validate Start - 2nd Term Base Rate Code     *                       CDL028
      *****************************************************************                       CDL028
     C     SrS2TermBsRtC BEGSR                                                                CDL028
                                                                                              CDL028
     C                   EXSR      SrResetErrs                                                CDL028
                                                                                              CDL028
     C                   CALLB     'IRVSTUBBRC'                                               CDL028
     C                   PARM                    RetCodeOut                                   CDL028
     C                   PARM                    MsgID1                                       CDL028
     C                   PARM                    #0OS2B                                       CDL028
     C                   PARM                    #0CUCY                                       CDL028
                                                                                              CDL028
     C                   IF        MsgID1 = *BLANKS                                           CDL028
     C                   SELECT                                                               CDL028
     C                   WHEN      WOurTheir = 'O'                                            CDL028
     C                   MOVE      #0OS2B        RPOS2B                                       CDL028
     C                   WHEN      WOurTheir = 'T'                                            CDL028
     C                   MOVE      #0OS2B        RPTS2B                                       CDL028
     C                   ENDSL                                                                CDL028
                                                                                              CDL028
     C                   ELSE                                                                 CDL028
     C                   EVAL      J = J + 1                                                  CDL028
     C                   EVAL      MsgIDXAr(J) = MsgID1                                       CDL028
     C                   EVAL      FldNamXAr(J) = '#0OS2B'                                    CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CDL028
     C                   EXSR      SrUpdatErrs                                                CDL028
                                                                                              CDL028
     C                   ENDSR                                                                CDL028
      *****************************************************************                       CDL028
      /EJECT                                                                                  CDL028
      *****************************************************************                       CDL028
      *  SrS2TermEndDt - Validate Start - 2nd Term End Date           *                       CDL028
      *****************************************************************                       CDL028
     C     SrS2TermEndDt BEGSR                                                                CDL028
                                                                                              CDL028
     C                   EXSR      SrResetErrs                                                CDL028
                                                                                              CDL028
     C                   CALLB     'IRVSTUBDTE'                                               CDL028
     C                   PARM                    RetCodeOut                                   CDL028
     C                   PARM                    MsgID1                                       CDL028
     C                   PARM                    BJDFIN                                       CDL028
     C                   PARM                    #0OS2D                                       CDL028
     C                   PARM                    StubDyNo                                     CDL028
                                                                                              CDL028
     C                   IF        MsgID1 = *BLANKS                                           CDL028
     C                   SELECT                                                               CDL028
     C                   WHEN      WOurTheir = 'O'                                            CDL028
     C                   Z-ADD     StubDyNo      RPOS2D                                       CDL028
     C                   WHEN      WOurTheir = 'T'                                            CDL028
     C                   Z-ADD     StubDyNo      RPTS2D                                       CDL028
     C                   ENDSL                                                                CDL028
                                                                                              CDL028
     C                   ELSE                                                                 CDL028
     C                   EVAL      J = J + 1                                                  CDL028
     C                   EVAL      MsgIDXAr(J) = MsgID1                                       CDL028
     C                   EVAL      FldNamXAr(J) = '#0OS2D'                                    CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CDL028
     C                   EXSR      SrUpdatErrs                                                CDL028
                                                                                              CDL028
     C                   ENDSR                                                                CDL028
      *****************************************************************                       CDL028
      /EJECT                                                                                  CDL028
      *****************************************************************                       CDL028
      *  SrEndDate - Validate End Date                                *                       CDL028
      *****************************************************************                       CDL028
     C     SrEndDate     BEGSR                                                                CDL028
                                                                                              CDL028
     C                   EXSR      SrResetErrs                                                CDL028
                                                                                              CDL028
     C                   CALLB     'IRVSTUBDTE'                                               CDL028
     C                   PARM                    RetCodeOut                                   CDL028
     C                   PARM                    MsgID1                                       CDL028
     C                   PARM                    BJDFIN                                       CDL028
     C                   PARM                    #0OEDT                                       CDL028
     C                   PARM                    StubDyNo                                     CDL028
                                                                                              CDL028
     C                   IF        MsgID1 = *BLANKS                                           CDL028
     C                   SELECT                                                               CDL028
     C                   WHEN      WOurTheir = 'O'                                            CDL028
     C                   Z-ADD     StubDyNo      RPOEDT                                       CDL028
     C                   WHEN      WOurTheir = 'T'                                            CDL028
     C                   Z-ADD     StubDyNo      RPTEDT                                       CDL028
     C                   ENDSL                                                                CDL028
                                                                                              CDL028
     C                   ELSE                                                                 CDL028
     C                   EVAL      J = J + 1                                                  CDL028
     C                   EVAL      MsgIDXAr(J) = MsgID1                                       CDL028
     C                   EVAL      FldNamXAr(J) = '#0OEDT'                                    CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CDL028
     C                   EXSR      SrUpdatErrs                                                CDL028
                                                                                              CDL028
     C                   ENDSR                                                                CDL028
      *****************************************************************                       CDL028
      /EJECT                                                                                  CDL028
      *****************************************************************                       CDL028
      *  SrE1TermBsRtC - Validate End - 1st Term Base Rate Code       *                       CDL028
      *****************************************************************                       CDL028
     C     SrE1TermBsRtC BEGSR                                                                CDL028
                                                                                              CDL028
     C                   EXSR      SrResetErrs                                                CDL028
                                                                                              CDL028
     C                   CALLB     'IRVSTUBBRC'                                               CDL028
     C                   PARM                    RetCodeOut                                   CDL028
     C                   PARM                    MsgID1                                       CDL028
     C                   PARM                    #0OE1B                                       CDL028
     C                   PARM                    #0CUCY                                       CDL028
                                                                                              CDL028
     C                   IF        MsgID1 = *BLANKS                                           CDL028
     C                   SELECT                                                               CDL028
     C                   WHEN      WOurTheir = 'O'                                            CDL028
     C                   MOVE      #0OE1B        RPOE1B                                       CDL028
     C                   WHEN      WOurTheir = 'T'                                            CDL028
     C                   MOVE      #0OE1B        RPTE1B                                       CDL028
     C                   ENDSL                                                                CDL028
                                                                                              CDL028
     C                   ELSE                                                                 CDL028
     C                   EVAL      J = J + 1                                                  CDL028
     C                   EVAL      MsgIDXAr(J) = MsgID1                                       CDL028
     C                   EVAL      FldNamXAr(J) = '#0OE1B'                                    CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CDL028
     C                   EXSR      SrUpdatErrs                                                CDL028
                                                                                              CDL028
     C                   ENDSR                                                                CDL028
      *****************************************************************                       CDL028
      /EJECT                                                                                  CDL028
      *****************************************************************                       CDL028
      *  SrE1TermEndDt - Validate End - 1st Term End Date             *                       CDL028
      *****************************************************************                       CDL028
     C     SrE1TermEndDt BEGSR                                                                CDL028
                                                                                              CDL028
     C                   EXSR      SrResetErrs                                                CDL028
                                                                                              CDL028
     C                   CALLB     'IRVSTUBDTE'                                               CDL028
     C                   PARM                    RetCodeOut                                   CDL028
     C                   PARM                    MsgID1                                       CDL028
     C                   PARM                    BJDFIN                                       CDL028
     C                   PARM                    #0OE1D                                       CDL028
     C                   PARM                    StubDyNo                                     CDL028
                                                                                              CDL028
     C                   IF        MsgID1 = *BLANKS                                           CDL028
     C                   SELECT                                                               CDL028
     C                   WHEN      WOurTheir = 'O'                                            CDL028
     C                   Z-ADD     StubDyNo      RPOE1D                                       CDL028
     C                   WHEN      WOurTheir = 'T'                                            CDL028
     C                   Z-ADD     StubDyNo      RPTE1D                                       CDL028
     C                   ENDSL                                                                CDL028
                                                                                              CDL028
     C                   ELSE                                                                 CDL028
     C                   EVAL      J = J + 1                                                  CDL028
     C                   EVAL      MsgIDXAr(J) = MsgID1                                       CDL028
     C                   EVAL      FldNamXAr(J) = '#0OE1D'                                    CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CDL028
     C                   EXSR      SrUpdatErrs                                                CDL028
                                                                                              CDL028
     C                   ENDSR                                                                CDL028
      *****************************************************************                       CDL028
      /EJECT                                                                                  CDL028
      *****************************************************************                       CDL028
      *  SrE2TermBsRtC - Validate End - 2nd Term Base Rate Code       *                       CDL028
      *****************************************************************                       CDL028
     C     SrE2TermBsRtC BEGSR                                                                CDL028
                                                                                              CDL028
     C                   EXSR      SrResetErrs                                                CDL028
                                                                                              CDL028
     C                   CALLB     'IRVSTUBBRC'                                               CDL028
     C                   PARM                    RetCodeOut                                   CDL028
     C                   PARM                    MsgID1                                       CDL028
     C                   PARM                    #0OE2B                                       CDL028
     C                   PARM                    #0CUCY                                       CDL028
                                                                                              CDL028
     C                   IF        MsgID1 = *BLANKS                                           CDL028
     C                   SELECT                                                               CDL028
     C                   WHEN      WOurTheir = 'O'                                            CDL028
     C                   MOVE      #0OE2B        RPOE2B                                       CDL028
     C                   WHEN      WOurTheir = 'T'                                            CDL028
     C                   MOVE      #0OE2B        RPTE2B                                       CDL028
     C                   ENDSL                                                                CDL028
                                                                                              CDL028
     C                   ELSE                                                                 CDL028
     C                   EVAL      J = J + 1                                                  CDL028
     C                   EVAL      MsgIDXAr(J) = MsgID1                                       CDL028
     C                   EVAL      FldNamXAr(J) = '#0OE2B'                                    CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CDL028
     C                   EXSR      SrUpdatErrs                                                CDL028
                                                                                              CDL028
     C                   ENDSR                                                                CDL028
      *****************************************************************                       CDL028
      /EJECT                                                                                  CDL028
      *****************************************************************                       CDL028
      *  SrE2TermEndDt - Validate End - 2nd Term End Date             *                       CDL028
      *****************************************************************                       CDL028
     C     SrE2TermEndDt BEGSR                                                                CDL028
                                                                                              CDL028
     C                   EXSR      SrResetErrs                                                CDL028
                                                                                              CDL028
     C                   CALLB     'IRVSTUBDTE'                                               CDL028
     C                   PARM                    RetCodeOut                                   CDL028
     C                   PARM                    MsgID1                                       CDL028
     C                   PARM                    BJDFIN                                       CDL028
     C                   PARM                    #0OE2D                                       CDL028
     C                   PARM                    StubDyNo                                     CDL028
                                                                                              CDL028
     C                   IF        MsgID1 = *BLANKS                                           CDL028
     C                   SELECT                                                               CDL028
     C                   WHEN      WOurTheir = 'O'                                            CDL028
     C                   Z-ADD     StubDyNo      RPOE2D                                       CDL028
     C                   WHEN      WOurTheir = 'T'                                            CDL028
     C                   Z-ADD     StubDyNo      RPTE2D                                       CDL028
     C                   ENDSL                                                                CDL028
                                                                                              CDL028
     C                   ELSE                                                                 CDL028
     C                   EVAL      J = J + 1                                                  CDL028
     C                   EVAL      MsgIDXAr(J) = MsgID1                                       CDL028
     C                   EVAL      FldNamXAr(J) = '#0OE2D'                                    CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CDL028
     C                   EXSR      SrUpdatErrs                                                CDL028
                                                                                              CDL028
     C                   ENDSR                                                                CDL028
      *****************************************************************                       CDL028
      /EJECT                                                                                  CDL028
      *****************************************************************
      *  SrSetupVld - Setup Additional Fields needed for Valids File  *
      *****************************************************************
     C     SrSetupVld    BEGSR

     C                   EVAL      RPDTYP = #0DTYP
     C                   EVAL      FilBsDyConv = DSBsDyConv

     C     ESrSetupVld   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrResetErrs - Reset error information that is received back  *
      *                from each validation module.                   *
      *****************************************************************
     C     SrResetErrs   BEGSR

     C                   EVAL      RetCodeOut = *BLANKS
     C                   EVAL      MsgID1 = *BLANKS
     C                   EVAL      MsgID2 = *BLANKS
     C                   EVAL      WarnMsg1 = *BLANKS
     C                   EVAL      WarnMsg2 = *BLANKS
     C                   EVAL      WarnMsg3 = *BLANKS
     C                   EVAL      WarnMsgDta = *BLANKS

     C                   EVAL      J = *ZERO
     C                   EVAL      FldNamXAr = *BLANKS
     C                   EVAL      MsgIDXAr  = *BLANKS
     C                   EVAL      MsgDtaXAr = *BLANKS
     C                   EVAL      WFldNmXAr = *BLANKS
     C                   EVAL      WMsgIDXAr = *BLANKS
     C                   EVAL      WMsgDtXAr = *BLANKS

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrUpdatErrs - Update error information with that received    *
      *                back from each validation module.              *
      *****************************************************************
     C     SrUpdatErrs   BEGSR

      ** Update error fields/message IDs/message data (arrays)

     C                   EVAL      I = 1
     C     *BLANK        LOOKUP    FldNameArr(I)                          80
     C                   IF        *IN80 = *ON
     C                   MOVEA     FldNamXAr     FlDNameArr(I)
     C                   MOVEA     MsgIDXAr      MsgIdArr(I)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(I)
     C                   ENDIF

      ** Set Error Index

     C                   EVAL      I = 1
     C     *BLANK        LOOKUP    FldNameArr(I)                          80
     C                   EVAL      Idx = I - 1

      ** Update warning fields/message IDs/message data (arrays)

     C                   EVAL      I = 1
     C     *BLANK        LOOKUP    WFldNamArr(I)                          80
     C                   IF        *IN80 = *ON
     C                   MOVEA     WFldNmXAr     WFldNamArr(I)
     C                   MOVEA     WMsgIDXAr     WMsgIDArr(I)
     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(I)
     C                   ENDIF

      ** Set Warning Index

     C                   EVAL      I = 1
     C     *BLANK        LOOKUP    WFldNamArr(I)                          80
     C                   EVAL      WIdx = I - 1

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation Routine                       *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST

      ** Inputs:
      **    Mode of Operation Received from Controller
      **    Response Mode
      **    Current Caps/Collars/Florrs deal Screen format
      **    New Caps/Collars/Florrs deal Screen format
      **    Receipt Settlement Currency
      **    Receipt Settlement Method
      **    Receipt Settlement Nostro
      **    Pay Settlement Currency
      **    Pay Settlement Method
      **    Pay Settlement Nostro
      **    Caps/Collars/Floors Extra Data Layout File
      **    Validate Business Day Convention flag
      **    Bank details
      **    Module details
      **    Deal details
      **    General Ledger details
      **    Trading details
      **    FRA/IRS ICD details
      **    ZMUSER data area
      **    CIR001 Switchable Feature
      **    CIR005 Switchable Feature
      **    CIR006 Switchable Feature
      **    CIR007 Switchable Feature
     C                   PARM                    ModeOfOp
     C                   PARM                    RespMode
     C                   PARM                    CrIRScnFmt
     C                   PARM                    NwIRScnFmt
     C                   PARM                    RecSetCcy
     C                   PARM                    RecSetMeth
     C                   PARM                    RecNostro
     C                   PARM                    PaySetCcy
     C                   PARM                    PaySetMeth
     C                   PARM                    PayNostro
     C                   PARM                    ExtData
     C                   PARM                    ValidateBDC
     C                   PARM                    SDBANK
     C                   PARM                    SDMMOD
     C                   PARM                    SDDEAL
     C                   PARM                    SDGELR
     C                   PARM                    SDTRAD
     C                   PARM                    SDFAIS
     C                   PARM                    ZMUSER
     C                   PARM                    CIR001
     C                   PARM                    CIR005
     C                   PARM                    CIR006
     C                   PARM                    CIR007

      ** Outputs:
      **    Caps/Collars/Floors deal OK Indicators
      **    Error fields from/to caller
      **    Error message IDs from/to caller
      **    Error message data (arrays) from/to caller
      **    Error array index (3P0) from/to caller
      **    Warning fields from/to caller
      **    Warning message IDs from/to caller
      **    Warning message data (arrays) from/to caller
      **    Warning array index (3P0) from/to caller
      **    Valid Caps/Collars/Floors deal File format
     C                   PARM                    OKFlags
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    NwIRFilFmt
      ***Sign*of Short Term Rate                                                     BUG5707 BUG6472
     C**********         PARM                    #0SIGN            1                 BUG5707 BUG6472
                                                                                              CDL029
     C     KBRANCHAUTH   KLIST                                                                CDL029
     C******             KFLD                    BBBRCD                                CDL029CDL029A
     C                   KFLD                    W0BRCD            3                         CDL029A
     C                   KFLD                    W0CUST            6                         CDL029A
     C                   KFLD                    #0BRCA                                       CDL029

      ** Check if Dealing Fiduciary is installed (variable CDL006
      ** is exported to MMVAMOUNT validation module)

     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CDL006'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        @RTCD <> *BLANKS AND
     C                             @RTCD <> '*NRF   '
     C                   EVAL      DBKEY = 'CDL006'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 001
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        @RTCD = *BLANKS
     C                   EVAL      CDL006 = 'Y'
     C                   ELSE
     C                   EVAL      CDL006 = 'N'
     C                   ENDIF
                                                                                              CDL029
     C                   CALLB     'AOSARDR0'                                                 CDL029
     C                   PARM      *BLANKS       @RTCD                                        CDL029
     C                   PARM      '*VERIFY'     @OPTN                                        CDL029
     C                   PARM      'CDL029'      @SARD                                        CDL029
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL029
     C                   IF        @RTCD <> *BLANKS AND                                       CDL029
     C                             @RTCD <> '*NRF   '                                         CDL029
     C     *LOCK         IN        LDA                                                        CDL029
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CDL029
     C                   EVAL      DBASE = 002                                                CDL029
     C                   EVAL      DBKEY = 'CDL029'                                           CDL029
     C                   OUT       LDA                                                        CDL029
     C                   EXSR      *PSSR                                                      CDL029
     C                   ENDIF                                                                CDL029
     C                   IF        @RTCD = *BLANKS                                            CDL029
     C                   EVAL      CDL029 = 'Y'                                               CDL029
     C                   ELSE                                                                 CDL029
     C                   EVAL      CDL029 = 'N'                                               CDL029
     C                   ENDIF                                                                CDL029
      *                                                                                      BUG5443
      ** Access SAR details file to determine if CDL005 is on.                               BUG5443
      ** (Customer format in input functions is shortname)                                   BUG5443
      *                                                                                      BUG5443
     C                   CALLB     'AOSARDR0'                                                BUG5443
     C                   PARM      *BLANKS       @RTCD                                       BUG5443
     C                   PARM      '*VERIFY'     @OPTN                                       BUG5443
     C                   PARM      'CDL005'      @SARD                                       BUG5443
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG5443
     C     @RTCD         IFNE      *BLANKS                                                   BUG5443
     C     @RTCD         ANDNE     '*NRF   '                                                 BUG5443
     C     *LOCK         IN        LDA                                                       BUG5443
     C                   MOVEL     'SCSARDPD'    DBFILE                      * DBERROR 003 * BUG5443
     C                   MOVEL     '003'         DBASE                                       BUG5443
     C                   MOVEL     'CDL005'      DBKEY                                       BUG5443
     C                   OUT       LDA                                                       BUG5443
     C                   EXSR      *PSSR                                                     BUG5443
     C                   END                                                                 BUG5443
     C     @RTCD         IFEQ      *BLANK                                                    BUG5443
     C                   MOVEL     'S'           CustFormat                                  BUG5443
     C                   ELSE                                                                BUG5443
     C                   MOVEL     'N'           CustFormat                                  BUG5443
     C                   END                                                                 BUG5443
                                                                                              CDL028
      ** Check if Automatic Rate Interpolation is installed                                   CDL028
                                                                                              CDL028
     C                   CALL      'AOSARDR0'                                                 CDL028
     C                   PARM      *BLANKS       @RTCD                                        CDL028
     C                   PARM      '*VERIFY'     @OPTN                                        CDL028
     C                   PARM      'CDL028'      @SARD                                        CDL028
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL028
                                                                                              CDL028
     C                   EVAL      CDL028 = 'N'                                               CDL028
     C                   IF        @RTCD = *BLANKS                                            CDL028
     C                   EVAL      CDL028 = 'Y'                                               CDL028
     C                   ENDIF                                                                CDL028

      ** Access SAR details file to determine if CDL038 is switched on                       BUG9717
                                                                                             BUG9717
     C                   CALLB     'AOSARDR0'                                                BUG9717
     C                   PARM      *BLANKS       @RTCD                                       BUG9717
     C                   PARM      '*VERIFY'     @OPTN                                       BUG9717
     C                   PARM      'CDL038'      @SARD                                       BUG9717
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG9717
                                                                                             BUG9717
     C                   IF        @RTCD <> *BLANKS AND                                      BUG9717
     C                             @RTCD <> '*NRF   '                                        BUG9717
     C     *LOCK         IN        LDA                                                       BUG9717
     C                   EVAL      DBFILE = 'SCSARDPD'                                       BUG9717
     C                   EVAL      DBASE = 908                                               BUG9717
     C                   EVAL      DBKEY = 'CDL038'                                          BUG9717
     C                   OUT       LDA                                                       BUG9717
     C                   EXSR      *PSSR                                                     BUG9717
     C                   ENDIF                                                               BUG9717
                                                                                             BUG9717
     C                   IF        @RTCD = *BLANKS                                           BUG9717
     C                   EVAL      CDL038 = 'Y'                                              BUG9717
     C                   ELSE                                                                BUG9717
     C                   EVAL      CDL038 = 'N'                                              BUG9717
     C                   ENDIF                                                               BUG9717
                                                                                             BUG9717
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------

      ** Hook to enable non-core initial processing to be included
     C/COPY WNCPYSRC,IRCACFV077

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2002
