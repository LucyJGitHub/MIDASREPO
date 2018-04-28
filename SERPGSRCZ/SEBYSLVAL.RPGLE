     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Buy-sell backs details validation')           *
      *****************************************************************
      *                                                               *
      *  Midas - Security Trading Module.                             *
      *                                                               *
      *  SEBYSLVAL - Buy-Sell Backs Details Validation                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 BUG8550            Date 07Oct05               *
      *                 233708             Date 02Jun05               *
      *                 CGL031             Date 05Jul04               *
      *                 CSE071             Date 19Jul05               *
      *                 CGL029             Date 01Sep03               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011             Date 14Mar02               *
      *                 CSE031             Date 13Dec01               *
      *                 198112             Date 30Nov01               *
      *                 CAP067             Date 24Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CPK014             Date 05Oct01               *
      *                 CSE028             Date 06Jun01               *
      *                 191878             Date 23Apr01               *
      *                 CSE022             Date 29Mar01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 11Oct00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSE023             Date 12Jul00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP137             Date 07Feb00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSE006 *CREATE     Date 21May99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG8550 - Reposition capture of ZMUSER data area             *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  233708 - Addition of Fiscal Price fields for CGL031          *
      *  CGL031 - Taxation of Savings Income (Recompiled)             *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CSE031 - Coupon Fixing for Floating Rate Notes.              *
      *           Recompiled due to changes in SECTYD.                *
      *  198112 - Recompiled over changed SEVTBPRFCN.                 *
      *  CAP067 - Repurchase Agreements API.                          *
      *  CPK014 - Release 4 Packaging. Fix parameter mismatch.        *
      *  CSE028 - Standing Settlement Instructions Enhancement.       *
      *           (Recompiled).                                       *
      *  191878 - Set up default clearance types based on user input  *
      *  CSE022 - Depository Definition Enhancement (Recompile)       *
      *  CSD006 - Recompiled over changed SECTYD.                     *
      *  CSE023 - Treaty Withholding Tax.                             *
      *  CAP137 - Conversion of SE Security inputs into modular       *
      *           structure to use as APIs (SECTYD)                   *
      *  CSE006 - Repurchase Agreements (REPOs) enhancement           *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,SEBYSLV024
 
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
 
      * Trade Purchased in file format - Valid file
     D TPFileFmt     E DS                  EXTNAME(SEVBYSLPPD) PREFIX(TP)
 
      * Trade Sold in file format - Valid file
     D TSFileFmt     E DS                  EXTNAME(SEVBYSLSPD) PREFIX(TS)
 
      ** Buy-Sell Back details in screen format
     D NwBSScnFmt    E DS                  EXTNAME(SEBSTRPD)
 
      ** Buy-Sell Back details OK indicators
     D OKBuySell     E DS                  EXTNAME(SEEBSTRPD)
 
      ** Trade in File Format - Dummy
     D TradFilFmt    E DS                  EXTNAME(TRADSD)
      ** Trade Extension in File Format (A) - Dummy
     D TX1FilFmt     E DS                  EXTNAME(TRADSDX1)
      ** Trade Extension in File Format (A) - Dummy
     D TX1AFilFmt    E DS                  EXTNAME(TRADSDX1)
     D                                     PREFIX(A_)
      ** Trade Extension in File Format (B) - Dummy
     D TX1BFilFmt    E DS                  EXTNAME(TRADSDX1)
     D                                     PREFIX(B_)
 
 
      ** Security Details
     D SECTY         E DS                  EXTNAME(SECTYD)
     D S_RECI        E                     EXTFLD(RECI)
     D S_ZZ005       E                     EXTFLD(ZZ005)
     D S_LCD         E                     EXTFLD(LCD)
     D S_CHTP        E                     EXTFLD(CHTP)
     D S_TNLU        E                     EXTFLD(TNLU)
     D S_REPI        E                     EXTFLD(REPI)
     D S_FRNT        E                     EXTFLD(FRNT)                                       CAP137
     D S_REPA        E                     EXTFLD(REPA)                                       CAP137
     D S_TMST        E                     EXTFLD(TMST)                                       CAP137
 
      ** Investment Type Details
     D INVTP         E DS                  EXTNAME(INVTPD)
     D INV_RECI      E                     EXTFLD(RECI)
     D INV_LCD       E                     EXTFLD(LCD)
     D INV_CHTP      E                     EXTFLD(CHTP)
     D INV_TNLU      E                     EXTFLD(TNLU)
     D INV_NDEC      E                     EXTFLD(NDEC)                                       CAS006
 
      ** The following /COPY includes the customer details data structure
     D/COPY SECPYSRC,SE_CUSTDT
      ** The following /COPY includes the currency details data structures
     D/COPY SECPYSRC,SE_CCYDT
 
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for Midas modules details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      ** Securities Trading ICD
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
 
      ** Portfolio ICD
     D SDPORT        E DS                  EXTNAME(SDPORTPD)
 
      ** External DS for General Ledger details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
 
      ** External DS for Bank Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      **  Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** 24X7 status data area                                                                CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
                                                                                              CSC011
      ** SDSTAT data area                                                                     CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
                                                                                              CSC011
      ** External DS for SAR Details                                                          CSC011
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC011
     D  SCA_LCD      E                     EXTFLD(LCD)                                        CSC011
                                                                                              CSC011
      ** Data structure for MULTIBRANCH Indicator using rundat.
     D RUNDAT          DS
     D  @MBIN                 13     13
 
 
     D ZMUSER          DS            17
     D  USRBCH                11     13
 
 
     D ExtData       E DS                  EXTNAME(SETDEXPD)                    CAP004
      * SE Trades Extra Data - File (D/B) format                                CAP004
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Action code - always 'I' for Buy-Sell Backs Maintenence
     D DDACTN          S              1    INZ('I')
 
      ** Work fields for validation modules
     D*WorkTCNR*       S              6S 0                                                    CSD027
     D*WorkOURD*       S              6S 0                                                    CSD027
     D*WorkCNTD*       S              6S 0                                                    CSD027
     D WorkTCNR        S              6A                                                      CSD027
     D WorkOURD        S              6A                                                      CSD027
     D WorkCNTD        S              6A                                                      CSD027
     D WorkTDDT        S              5P 0
     D WorkTDVD        S              5P 0
     D P@TSTDVD        S              5S 0
     D P@TPTDVD        S              5S 0
 
      ** Fields for renaming field names in SR/RENAMEFLD
     D A               S              3S 0
     D B               S              3S 0
 
     D CSC011          S              1A                                                      CSC011
     D WRunDay         S                   LIKE(BJRDNB)                                       CSC011
     D PRTCD           S              7A                                                      CSC011
     D POPTN           S              7A                                                      CSC011
     D PSARD           S              6A                                                      CSC011
                                                                                              CSC011
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,SETRDPV025
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      **  GET ZMUSER to access default branch.                                               BUG8550
      *                                                                                      BUG8550
     C     *DTAARA       DEFINE                  ZMUSER                                      BUG8550
     C                   IN        ZMUSER                                                    BUG8550
     C                   UNLOCK    ZMUSER                                                    BUG8550
      *                                                                                      BUG8550
 
      /COPY WNCPYSRC,SETRDPV001
 
      * Call Validation Modules in Sequence - Start with fields common to
      * both trades
 
      *
      ** Validate Security Shortname
      *
      /COPY WNCPYSRC,SETRDPV002
      *
     C                   EXSR      VTSECUR
      *
      /COPY WNCPYSRC,SETRDPV003
      *
      * If security in error then no more validation
      *
     C                   IF        DDTDSSok = 'Y'
      *
      ** Validate Counterparty (Customer)
      *
      /COPY WNCPYSRC,SETRDPV006
      *
     C                   EXSR      VTCUST
      *
      /COPY WNCPYSRC,SETRDPV004
      *
      ** Validate Booking Branch
      *
      /COPY WNCPYSRC,SETRDPV004
      *
     C                   EXSR      VTBKGBR
      *
      /COPY WNCPYSRC,SETRDPV007
      *
      ** Validate Book
      *
      /COPY WNCPYSRC,SETRDPV010
      *
     C                   EXSR      VBSBOOK
      *
      /COPY WNCPYSRC,SETRDPV014
      *
      ** Validate Nominal (sold)
      *
      /COPY WNCPYSRC,SETRDPV015
      *
     C                   MOVEL     'TS'          TradeType         2
      *
     C                   EXSR      VTNOMNL
      *
     C                   Z-ADD     WorkNOML      TSNOML
     C                   MOVE      NMDP          TSTNMD
     C                   MOVEL     W#DDNOMLok    DDNOMLok
     C                   Z-ADD     0             WorkNOML
     C                   MOVEL     *Blanks       TradeType
     C                   MOVEL     *Blanks       W#DDNOMLok
      *
      /COPY WNCPYSRC,SETRDPV015
      *
      ** Validate Nominal (purchased trade)
      *
      /COPY WNCPYSRC,SETRDPV022
      *
     C                   MOVEL     'TP'          TradeType
 
     C                   EXSR      VTNOMNL
 
     C                   Z-ADD     WorkNOML      TPNOML
     C                   MOVE      NMDP          TPTNMD
     C                   MOVEL     W#DDNOMLok    DDNOMLok
     C                   Z-ADD     0             WorkNOML
     C                   MOVEL     *Blanks       TradeType
     C                   MOVEL     *Blanks       W#DDNOMLok
      *
      /COPY WNCPYSRC,SETRDPV015
      *
      ** Validate Incomplete Ind.
      *
      /COPY WNCPYSRC,SETRDPV008
      *
     C                   EXSR      VTINCOM
      *
      /COPY WNCPYSRC,SETRDPV005
      *
      ** Validate Our Depot
      *
      /COPY WNCPYSRC,SETRDPV008
      *
     C                   EXSR      VBSDEP1
      *
      ** Validate Counterparty Depot
      *
      /COPY WNCPYSRC,SETRDPV008
      *
     C                   EXSR      VBSDEP2
      *
      /COPY WNCPYSRC,SETRDPV009
      *
      ** Validate Trade Reference Nos. (both trades dealt with here)
      *
      /COPY WNCPYSRC,SETRDPV017
      *
     C                   EXSR      VTRDREF
      *
      /COPY WNCPYSRC,SETRDPV018
      *
      ** Validate Value Date (both trades)
      *
      /COPY WNCPYSRC,SETRDPV019
      *
     C                   EXSR      VBSVDAT
      *
      /COPY WNCPYSRC,SETRDPV020
      *
      ** Validate Trade Date
      *
      /COPY WNCPYSRC,SETRDPV013
      *
     C                   EXSR      VBSTRDDT
      *
      /COPY WNCPYSRC,SETRDPV011
      *
      ** Validate Price/Discount/Yield (sold)
      *
      /COPY WNCPYSRC,SETRDPV021
      *
     C                   Z-ADD     TSTDVD        WorkTDVD
     C                   MOVEL     DDSTPDY       InpTPDY
     C                   MOVEL     'DDSTPDY'     FieldName
 
     C                   EXSR      TPRCDY
 
     C                   Z-ADD     WorkTPDY      TSTPDY
     C                   MOVEL     W#DDTPDYok    DDSTPDYok
     C                   Z-ADD     0             WorkTDVD
     C                   Z-ADD     0             WorkTPDY         15 8
     C                   MOVEL     *Blanks       W#DDTPDYok        1
      *
      /COPY WNCPYSRC,SETRDPV022
      *
      ** Validate Price/Discount/Yield (purchased trade)
      *
      /COPY WNCPYSRC,SETRDPV018
      *
     C                   Z-ADD     TPTDVD        WorkTDVD
     C                   MOVEL     DDPTPDY       InpTPDY
     C                   MOVEL     'DDPTPDY'     FieldName
 
     C                   EXSR      TPRCDY
 
     C                   Z-ADD     WorkTPDY      TPTPDY
     C                   MOVEL     W#DDTPDYok    DDPTPDYok
     C                   Z-ADD     0             WorkTDVD
     C                   Z-ADD     0             WorkTPDY         15 8
     C                   MOVEL     *Blanks       W#DDTPDYok        1
      *
      /COPY WNCPYSRC,SETRDPV019
      *
      ***Validate Market Indicator
      *
      /COPY WNCPYSRC,SETRDPV006
 
     C                   EXSR      VTMARKIN
 
      *
      ** Validate Profit Centre
      *
      /COPY WNCPYSRC,SETRDPV006
      *
     C                   EXSR      VTBPRFCN
      *
      /COPY WNCPYSRC,SETRDPV007
      *
      ** Validate Originating Branch
      *
      /COPY WNCPYSRC,SETRDPV006
      *
     C                   EXSR      VDORBRCH
      *
      /COPY WNCPYSRC,SETRDPV007
      *
      ** Validate Trade Sub-Type
      *
      /COPY WNCPYSRC,SETRDPV006
      *
     C                   EXSR      VTTRDSB
      *
      /COPY WNCPYSRC,SETRDPV007
      *
      ** Validate Capacity
      *
      /COPY WNCPYSRC,SETRDPV006
      *
     C                   EXSR      VTCAPACI
      *
      /COPY WNCPYSRC,SETRDPV007
      *
      ** Validate Fiscal Price                                                                233708
      *                                                                                       233708
     C                   IF        CGL031 = 'Y'                                               233708
     C                   EXSR      VTFSPRICE                                                  233708
     C                   ENDIF                                                                233708
      *
     C                   ENDIF
      *
 
     C                   RETURN
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,SETRDPV026
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VTSECUR - Validate Security Shortname
      *****************************************************************
     C     VTSECUR       BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
      ** Validate Security Shortname
      *
     C                   CALLB     'SEVTSECUR'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Default & Validate (Y or N)
     C                   PARM      'N'           Default           1
     C                   PARM                    Validate          1
      *
      ** Security Shortname
     C                   PARM                    DDTDSS
      *
      ** ICD
     C                   PARM                    CSE003
     C                   PARM                    S01511
     C**********         PARM                    BJRDNB                                       CSC011
     C                   PARM                    WRunDay                                      CSC011
      *
      ** SE Transactions Enhancements
      *
     C                   PARM                    CSE010            1
      *
      ** Action Code
      *
     C                   PARM      'I'           DDACTN            1
      *                                                                                       CAP067
      ** First Buy-sell back indicator                                                        CAP067
     C                   PARM                    PFBYSL            1                          CAP067
      *                                                                                       CAP067
      ** First Buy-sell security shortname                                                    CAP067
     C                   PARM                    PFSESN           10                          CAP067
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Security Shortname - OK
     C                   PARM                    DDTDSSOk
      *
      ** Trade Security Shortname
      *
     C                   PARM                    WorkTDSS         10
      *
      ** Security Details
      ** Investment Type Details
     C                   PARM                    SECTY
     C                   PARM                    INVTP
      *
      ** Nominal Currency Details
     C                   PARM                    NomCcyDts
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
      * Load validated field to each Trade's Valid file
     C                   MOVEL     WorkTDSS      TPTDSS
     C                   MOVEL     WorkTDSS      TSTDSS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VTBKGBR - Validate Booking Branch
      *****************************************************************
     C     VTBKGBR       BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
      ** Validate Booking Branch
      *
     C                   CALLB     'SEVTBKGBR'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Default & Validate (Y or N)
     C                   PARM      'Y'           Default           1
     C                   PARM                    Validate          1
      *
      * Response mode
     C                   PARM                    RespMode          1
      *
      ** Booking Branch
     C                   PARM                    DDTDBA
      *
      ** Action Code
     C                   PARM                    DDACTN            1
      *
      * ICD
     C                   PARM                    @MBIN
     C                   PARM                    USRBCH
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Booking branch - OK
     C                   PARM                    DDTdbaOK
      *
      ** Trade Booking Branch
      *
     C                   PARM                    WorkTDBA          3
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
      * Load validated field to each Trade's Valid file
     C                   MOVEL     WorkTDBA      TPTDBA
     C                   MOVEL     WorkTDBA      TSTDBA
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VTCUST - Validate Counterparty (Customer)
      *****************************************************************
     C     VTCUST        BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
      ** Validate Counterparty
      *
     C                   CALLB     'SEVTCUST'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Default & Validate (Y or N)
     C                   PARM      'N'           Default           1
     C                   PARM                    Validate          1
      *
      ** Trade Screen fields
     C                   PARM                    DDTCNR
     C                   PARM                    DDACTN
     C                   PARM                    DDTINC
      *                                                                                       CAP067
      ** First Buy-sell back indicator                                                        CAP067
     C                   PARM                    PFBYSL            1                          CAP067
      *                                                                                       CAP067
      ** First Buy-sell counterparty                                                          CAP067
     C**********         PARM      *ZEROS        PFTCNR            6 0                 CAP067 CSD027
     C                   PARM      *BLANKS       PFTCNR            6                          CSD027
      *
      ** ICD
     C                   PARM                    BGPFMG            1
     C                   PARM                    FCPORS            1
     C                   PARM                    FCR997            4
     C                   PARM                    BGN4ST            1
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Customer - OK
     C                   PARM                    DDTCNRok
      *
      ** Trade Counterparty
      *
     C**********         PARM                    WorkTCNR          6 0                        CSD027
     C                   PARM                    WorkTCNR          6                          CSD027
      *
      ** Trade Counterparty details
     C                   PARM                    CustDts
      *                                                                                       CPK014
      ** PB Order Number                                                                      CPK014
     C                   PARM                    DDORDE            6                          CPK014
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
      * Load validated field to each Trade's Valid file
     C**********         Z-ADD     WorkTCNR      TPTCNR                                       CSD027
     C**********         Z-ADD     WorkTCNR      TSTCNR                                       CSD027
     C                   EVAL      TPTCNR = WorkTCNR                                          CSD027
     C                   EVAL      TSTCNR = WorkTCNR                                          CSD027
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VTINCOM - Validate Incomplete Ind.
      *****************************************************************
     C     VTINCOM       BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
      ** Validate Incomplete Ind.
      *
     C                   CALLB     'SEVTINCOM'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Default & Validate (Y or N)
     C                   PARM      'Y'           Default           1
     C                   PARM                    Validate          1
      *
      ** Trade Screen fields
     C                   PARM                    DDTINC
      *
      ** Security Details
      *
     C                   PARM                    SECTY
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Incomplete indicator - OK
     C                   PARM                    DDTINCok
      *
      ** Trade Incomplete Indicator
      *
     C                   PARM                    WorkTINC          1
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
      * Load validated field to each Trade's Valid file
     C                   MOVEL     WorkTINC      TPTINC
     C                   MOVEL     WorkTINC      TSTINC
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VBSDEP1 - Validate Our Depot
      *****************************************************************
     C     VBSDEP1       BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
      ** Validate Depot
      *
     C**********         CALLB     'SEVBSDO'                                                  191878
     C                   CALLB     'SEVBSDO01'                                                191878
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Trade Screen fields
     C                   PARM                    DDOURD
      *
      ** Counterparty (file format)
     C                   PARM                    TPTCNR
      *
      ** Field name
     C                   PARM      'DDOURD'      FldName           6
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Depot - OK
     C                   PARM                    DDOURDok
      *
      ** Our Depot (file format)
      *
     C                   PARM                    WorkOURD
      *                                                                                       191878
      ** Customer type                                                                        191878
      *                                                                                       191878
     C                   PARM                    Custcls1                                     191878
                                                                                              191878
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
      * Load validated field to each Trade's Valid file
     C**********         Z-ADD     WorkOURD      TPDELT                                       CSD027
     C**********         Z-ADD     WorkOURD      TSDELF                                       CSD027
     C                   EVAL      TPDELT = WorkOURD                                          CSD027
     C                   EVAL      TSDELF = WorkOURD                                          CSD027
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VBSDEP2 - Validate Counterparty Depot
      *****************************************************************
     C     VBSDEP2       BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
      ** Validate Depot
      *
     C**********         CALLB     'SEVBSDO'                                                  191878
     C                   CALLB     'SEVBSDO01'                                                191878
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Trade Screen fields
     C                   PARM                    DDCNTD
      *
      ** Counterparty (file format)
     C                   PARM                    TPTCNR
      *
      ** Field name
     C                   PARM      'DDCNTD'      FldName           6
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Depot - OK
     C                   PARM                    DDCNTDok
      *
      ** Counterparty Depot (file format)
      *
     C                   PARM                    WorkCNTD
 
      *                                                                                       191878
      ** Customer type                                                                        191878
      *                                                                                       191878
     C                   PARM                    Custcls2                                     191878
                                                                                              191878
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *                                                                                       191878
      **  Set up clearance type based on information keyed in and send to                     191878
      **  apprpropriate trade.                                                                191878
      *                                                                                       191878
     C                   EXSR      CLRTYPS                                                    191878
      *                                                                                       191878
      *
      * Load validated field to each Trade's Valid file
     C**********         Z-ADD     WorkCNTD      TPDELF                                       CSD027
     C**********         Z-ADD     WorkCNTD      TSDELT                                       CSD027
     C                   EVAL      TPDELF = WorkCNTD                                          CSD027
     C                   EVAL      TSDELT = WorkCNTD                                          CSD027
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************                       191878
      ** CLRTYPS - Set up clearance                                                           191878
      *****************************************************************                       191878
     C     CLRTYPS       BEGSR                                                                191878
                                                                                              191878
      * Set up clearance types                                                                191878
                                                                                              191878
                                                                                              191878
      * If our depot has a customer type 'E' and counterparty depot has                       191878
      * a customer type equal to 'E' default clearance type to 1.                             191878
                                                                                              191878
                                                                                              191878
      * If our depot has a customer type 'E' and counterparty depot has                       191878
      * a customer type not equal to 'E' default clearance type to 2.                         191878
                                                                                              191878
                                                                                              191878
      * If our depot has a customer type 'C' and counterparty depot has                       191878
      * a customer type equal to 'C' default clearance type to 3.                             191878
                                                                                              191878
                                                                                              191878
      * If our depot has a customer type 'C' and counterparty depot has                       191878
      * a customer type not equal to 'C' default clearance type to 4.                         191878
                                                                                              191878
      * If our depot has a customer  type not equal to 'C' or 'E'                             191878
      * default clearance type to 5.                                                          191878
                                                                                              191878
     C     Custcls1      IFNE      'C'                                                        191878
     C     Custcls1      ORNE      'E'                                                        191878
     C                   MOVE      '5'           CLRTYP            1                          191878
                                                                                              191878
     C                   END                                                                  191878
                                                                                              191878
     C     Custcls1      IFEQ      'E'                                                        191878
     C     Custcls2      ANDEQ     'E'                                                        191878
     C                   MOVE      '1'           CLRTYP                                       191878
     C                   END                                                                  191878
                                                                                              191878
     C     Custcls1      IFEQ      'E'                                                        191878
     C     Custcls2      ANDNE     'E'                                                        191878
     C                   MOVE      '2'           CLRTYP                                       191878
     C                   END                                                                  191878
                                                                                              191878
     C     Custcls1      IFEQ      'C'                                                        191878
     C     Custcls2      ANDEQ     'C'                                                        191878
     C                   MOVE      '3'           CLRTYP                                       191878
     C                   END                                                                  191878
      *                                                                                       191878
     C     Custcls1      IFEQ      'C'                                                        191878
     C     Custcls2      ANDNE     'C'                                                        191878
     C                   MOVE      '4'           CLRTYP                                       191878
     C                   END                                                                  191878
      *                                                                                       191878
     C     DDTINC        IFEQ      'I'                                                        191878
     C                   MOVE      '0'           CLRTYP                                       191878
     C                   END                                                                  191878
      *                                                                                       191878
     C                   ENDSR                                                                191878
      *****************************************************************                       191878
     C/EJECT                                                                                  191878
      *****************************************************************
      ** VTRDREF - Validate Trade Reference Numbers (BOTH TRADES)
      *****************************************************************
     C     VTRDREF       BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
 
      *         ***** Validate Sold Trade Reference *****
      *
     C                   CALLB     'SETRADRTV'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Mode (*Blanks=Not front office transaction interface)
     C                   PARM      *Blanks       ModeofOp          6
      *
      ** Response Mode
      ** Action Code
      ** Front Office ID
      ** (Midas) Trade Sold Reference
     C                   PARM                    RespMode
     C                   PARM      'I'           DDACTN            1
     C                   PARM                    FOTRID           20
     C                   PARM                    DDSTDRF
      ** ICD
     C                   PARM                    CSW003            1
      *                                                                                       CAP067
      * Buy-sell back                                                                         CAP067
     C                   PARM                    PFBYSL            1                          CAP067
      *                                                                                       CAP067
      * Trade Reference                                                                       CAP067
     C                   PARM                    PFTDRF            6                          CAP067
      *
      * OUTPUTS
      *
      * (Current) trade in file format - dummy field
      * (Current) trade extension in file format - dummy fields
     C                   PARM      *Blanks       TradFilFmt
     C                   PARM      *Blanks       TX1AFilFmt
     C                   PARM      *Blanks       TX1BFilFmt
      *
      ** Action Code - OK
     C                   PARM                    DDACTNOk          1
      *
      ** Trade Sold Reference - OK
     C                   PARM                    DDSTDRFOk
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
 
      * Move validated field into Valid File field
     C                   MOVEL     TDRF          TSTDRF
      *
      * Ensure field name array contains the correct name
     C                   MOVEL     'DDPTDRF'     FieldName
     C                   EXSR      RENAMEFLD
      *
      *
      *       ***** Validate Purchased Trade Reference *****
      *
     C                   CALLB     'SETRADRTV'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Mode (*Blanks=Not front office transaction interface)
     C                   PARM      *Blanks       ModeofOp          6
      *
      ** Response Mode
      ** Action Code
      ** Front Office ID
      ** (Midas) Trade Purchased Reference
     C                   PARM                    RespMode
     C                   PARM      'I'           DDACTN            1
     C                   PARM                    FOTRID           20
     C                   PARM                    DDPTDRF
      ** ICD
     C                   PARM                    CSW003
      *                                                                                       CAP067
      * Buy-sell back                                                                         CAP067
     C                   PARM                    PFBYSL            1                          CAP067
      *                                                                                       CAP067
      * Trade Reference                                                                       CAP067
     C                   PARM                    PFTDRF            6                          CAP067
      *
      * OUTPUTS
      *
      * (Current) trade in file format - dummy field
      * (Current) trade extension in file format - dummy fields
     C                   PARM      *Blanks       TradFilFmt
     C                   PARM      *Blanks       TX1AFilFmt
     C                   PARM      *Blanks       TX1BFilFmt
      *
      ** Action Code - OK
     C                   PARM                    DDACTNOk          1
      *
      ** Trade Purchased Reference - OK
     C                   PARM                    DDPTDRFOk
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      * Move validated field into Valid File field
     C                   MOVEL     TDRF          TPTDRF
      *
      * Ensure field name array contains the correct name
     C                   MOVEL     'DDPTDRF'     FieldName
     C                   EXSR      RENAMEFLD
 
 
      * Trade Reference for Sold trade cannot be the same as that of
      * Purchased trade (unless they are both blank)
     C                   IF        DDPTDRF = DDSTDRF and DDSTDRF <> *Blanks
     C                   ADD       1             Idx
     C                   MOVE      'N'           DDSTDRFok
     C                   MOVEL     'DDSTDRF'     FldNamXAr(Idx)
     C                   MOVEL     'MMA1107'     MsgIdXAr(Idx)
     C                   ADD       1             Idx
     C                   MOVE      'N'           DDPTDRFok
     C                   MOVEL     'DDPTDRF'     FldNamXAr(Idx)
     C                   MOVEL     'MMA1107'     MsgIdXAr(Idx)
     C                   ENDIF
 
      * Update error info
 
     C                   EXSR      UPDATERRS
      *
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VTNOMNL - Validate Nominal
      *****************************************************************
     C     VTNOMNL       BEGSR
 
      *
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
 
     C** Access no of decimal places of Nominal currency
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      NMCY          @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
     C
     C                   MOVE      A6NBDP        NomCcyDec
 
      *
      ** Validate Nominal
      *
     C                   CALLB     'SEVTNOMNL'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Default & Validate (Y or N)
     C                   PARM      'N'           Default           1
     C                   PARM                    Validate          1
      *
      ** Trade Screen fields
      ** Nominal (12A)
      ** Branch (3A)
      ** Trade Type (2A)
     C                   PARM                    DDNOML
     C                   PARM                    DDTDBA
     C                   PARM                    TradeType
 
      ** Trade Details:
      ** Customer (6S 0)
      ** Customer Details
     C                   PARM                    WorkTCNR
     C                   PARM                    CustDts                                       S0111
 
      ** Security Details
      ** Nominal Currency Decimal Places (1P 0)
 
     C                   PARM                    SECTY
     C                   PARM                    NomCcyDec
 
      ** System Input
 
      ** Portfolio Mgmt Indicator (1A)
      ** Run Date (5P 0)
      ** S01496 Indicator (PB SE enhancements)
      ** CSE007 Indicator (Corporate Actions)
      ** CEU017 Indicator (SE Rednomination Euro changes)
      ** BGN4ST Indicator (Private Banking Module)
 
     C                   PARM                    BGPFMG
     C**********         PARM                    BJRDNB                                       CSC011
     C                   PARM                    WRunDay                                      CSC011
     C                   PARM                    S01496
     C                   PARM                    CSE007
     C                   PARM                    CEU017
     C                   PARM                    BGN4ST            1
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
 
      ** Nominal Ok Indicator  (1A)
      ** Nominal Amount  (11P 0)
     C                   PARM                    W#DDNomlOK        1
     C                   PARM                    WorkNOML         11 0
     C                   PARM                    @PCOLF            1
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VBSTRDDT - Validate Trade Date
      *****************************************************************
     C     VBSTRDDT      BEGSR
 
      * Decide which Value Date is earliest
     C                   IF        TPTDVD > TSTDVD
     C                   MOVE      TSTDVD        WorkTDVD
     C                   ELSE
     C                   MOVE      TPTDVD        WorkTDVD
     C                   ENDIF
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
      ** Validate Trade Date
      *
     C                   CALLB     'SEVBSDT01'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Default & Validate (Y or N)
     C                   PARM      'Y'           Default           1
     C                   PARM                    Validate          1
      *
      ** Trade Screen fields
     C                   PARM                    DDTDDT
      *
      ** Trade value date
     C                   PARM                    WorkTDVD
      *
      ** ICD
      ** run date, date format, local currency, system location, bv period
     C**********         PARM                    BJRDNB                                       CSC011
     C                   PARM                    WRunDay                                      CSC011
     C                   PARM                    BJDFIN
     C                   PARM                    BJLCCY
     C                   PARM                    BJSLCD
     C                   PARM                    BVBVP             3 0
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
      ** Trade Value Date - OK
     C                   PARM                    DDTDDTok
      *
      ** Trade Date
     C                   PARM                    WorkTDDT
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
      * Move validated fields into Valid File fields
     C                   Z-ADD     WorkTDDT      TSTDDT
     C                   Z-ADD     WorkTDDT      TPTDDT
     C                   Z-ADD     0             WorkTDVD
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** TPRCDY - Validate Price/Discount/Yield
      *****************************************************************
     C     TPRCDY        BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
      ** Validate Price/Discount/Yield
      *
     C                   CALLB     'SEVTPRCDY'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Default & Validate (Y or N)
     C                   PARM      'N'           Default           1
     C                   PARM                    Validate          1
      *
      ** Trade Screen fields
      ** Price/Discount/Yield
      ** Complete/Incomplete Indicator
     C                   PARM                    InpTPDY          16
     C                   PARM                    DDTINC
      *
      ** Trade Details
      ** -------------
      ** Value Date
     C                   PARM                    WorkTDVD
      *
      ** Security Details
      ** Investment Type Price Tolerance
     C                   PARM                    SECTY
     C                   PARM                    PRTO
      *
      ** System Info
      ** -----------
      ** System Run date
      ** SAR S01496 Indicator
     C**********         PARM                    BJRDNB                                       CSC011
     C                   PARM                    WRunDay                                      CSC011
     C                   PARM                    S01496
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
      ** Price/Discount/Yield Indicator
     C                   PARM                    W#DDTPDYok
      *
      ** Price/Discount/Yield
     C                   PARM                    WorkTPDY
 
      * Ensure correct field name is in FldNamXAr
     C                   EXSR      RENAMEFLD
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VBSBOOK - Validate Book
      *****************************************************************
     C     VBSBOOK       BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
      ** Validate Book
      *
     C                   CALLB     'SEVBSBK02'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Default & Validate (Y or N)
     C                   PARM      'N'           Default           1
     C                   PARM                    Validate          1
      *
      ** Trade Screen fields
     C                   PARM                    DDTDBK
     C                   PARM                    DDACTN
     C                   PARM                    DDBLKR            6
     C                   PARM                    DDTDBA
      *
      ** Trade details
     C                   PARM                    DDTCNR
      *
      ** Security Day Basis
     C                   PARM                    DYBS
      *
      ** ICD
     C                   PARM                    BGPFMG
     C                   PARM                    FCPORS
     C                   PARM                    FCR997
     C                   PARM                    BVATBK
     C                   PARM                    BVDMBC
     C                   PARM                    BVDPBC
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Book portfolio details
     C                   PARM                    PortCust
     C                   PARM                    PortRef
     C                   PARM                    PortCcy
     C                   PARM                    PortDecp
      *
      ** Book - OK
     C                   PARM                    DDTDBKok
      *
      ** Trade Book
      *
     C                   PARM                    WorkTDBK          2
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
      * Load validated field to each Trade's Valid file
     C                   MOVEL     WorkTDBK      TPTDBK
     C                   MOVEL     WorkTDBK      TSTDBK
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** VBSVDAT - Validate Value Dates
      *****************************************************************
     C     VBSVDAT       BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
      ** Validate Value Date
      *
     C                   CALLB     'SEVBSDT02'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Trade Screen fields
     C                   PARM                    DDPTDVD
     C                   PARM                    DDSTDVD
      *
      ** Security Details
      *
     C                   PARM                    SECTY
     C                   PARM                    PROT              1
      *
      ** ICD
     C**********         PARM                    BJRDNB            5 0                        CSC011
     C                   PARM                    WRunDay                                      CSC011
     C                   PARM                    BJDFIN            1
     C                   PARM                    BVBVP             3 0
     C                   PARM                    BVRCPN            1
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
      ** Trade Value Date - OK flags (both fields)
     C                   PARM                    DDPTDVDok         1
     C                   PARM                    DDSTDVDok         1
      *
      ** Trade Value Date (both trades)
     C                   PARM                    P@TPTDVD
     C                   PARM                    P@TSTDVD
      *
      ** Trade Coupon Rate (for each trade)
      ** Trade Current Factor (for each trade)
     C                   PARM                    TPTDCR           11 7
     C                   PARM                    TPTCFC           10 9
     C                   PARM                    TSTDCR           11 7
     C                   PARM                    TSTCFC           10 9
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
      * Move the zoned form of value date to the packed (file) form
     C                   Z-ADD     P@TSTDVD      TSTDVD
     C                   Z-ADD     P@TPTDVD      TPTDVD
 
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VTBPRFCN - Validate Booking Profit Centre                     *
      *****************************************************************
     C     VTBPRFCN      BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
      ** Validate Profit Centre
      *
     C                   CALLB     'SEVTBPRFCN'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Default & Validate (Y or N)
     C                   PARM      'Y'           Default
     C                   PARM                    Validate
 
      ** Booking profit centre
     C                   PARM                    DDBPRC
 
      ** Security
      ** Trade Type
      ** Branch code
      ** Book code
      ** Market Indicator
      ** Trade Sub Type
     C                   PARM                    DDTDSS
     C                   PARM                    DDTDTP            2
     C                   PARM                    DDTDBA
     C                   PARM                    DDTDBK
     C                   PARM                    DDTDMI
     C                   PARM                    DDTSUB
      *
      ** Trade Customer
     C                   PARM                    TCNR
      *
      ** ICD
     C                   PARM                    BKPCDU            1
     C                   PARM                    CAC005            1
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
      ** Booking profit centre - OK
     C                   PARM                    DDBPRCok
      *
      ** Trade Booking profit centre
      *
     C                   PARM                    WorkBPRC          4
      *
      ** Trade Book
     C                   PARM                    TDBK              2            CAC005
      *
      *
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
      * Load validated field to each Trade's Valid file
     C                   MOVEL     WorkBPRC      TPBPRC
     C                   MOVEL     WorkBPRC      TSBPRC
      *
      * Move returned value back to screen field
     C                   MOVEL     WorkBPRC      DDBPRC
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VTMARKIN - Validate Market Indicator                          *
      *****************************************************************
     C     VTMARKIN      BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
      ** Validate Market Indicator
      *
     C                   CALLB     'SEVTMARKIN'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Default & Validate (Y or N)
     C                   PARM      'Y'           Default
     C                   PARM                    Validate
      *
      ** Trade Screen fields
     C                   PARM                    DDTDMI
      *
      ** Security Market Indicator
     C                   PARM                    MKTI
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Market Indicator - OK
     C                   PARM                    DDTDMIok
      *
      ** Trade Market Indicator
      *
     C                   PARM                    WorkTDMI          1
      *
      *
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
      * Load validated field to each Trade's Valid file
     C                   MOVEL     WorkTDMI      TPTDMI
     C                   MOVEL     WorkTDMI      TSTDMI
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VDORBRCH - Validate Originating Branch                        *
      *****************************************************************
     C     VDORBRCH      BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
      ** Validate Originating Branch
      *
     C                   CALLB     'SEVDORBRCH'
      *
      * INPUTS
      *
      ** Return code
     C                   PARM                    RetCodeOut
 
      ** Screen Fields **
      *  Originating Branch (3A)
     C                   PARM                    DDORBR
 
      ** Transaction details
      *  Booking Branch Code (3A)
     C                   PARM                    DDTDBA
 
      ** ICD
      ** System Info
      *  Multi-Branch Indicator  (1A)
      *  Originating Branch used indicator (1A)
      *  Originating Branch User/Validation required indicator (1A)
      *  Response Mode (A/S) (1A)
 
     C                   PARM                    @MBIN
     C                   PARM                    BKOBRU
     C                   PARM                    BKOBUV
     C                   PARM                    RespMode          1
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Originating Branch Ok Indicator (1A)
      ** Originating Branch Code (3A)
 
     C                   PARM                    DDORBRok
     C                   PARM                    WorkORBR          3
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
      * Load validated field to each Trade's Valid file and screen field
     C                   MOVEL     WorkORBR      TPORBR
     C                   MOVEL     WorkORBR      TSORBR
     C                   MOVEL     WorkORBR      DDORBR
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VTTRDSB - Validate Trade Sub-Type                            *
      *****************************************************************
     C     VTTRDSB       BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
      ** Validate Originating Branch
      *
     C                   CALLB     'SEVTTRDSB'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Default & Validate (Y or N)
     C                   PARM      'Y'           Default
     C                   PARM                    Validate
      *
      ** Trade Screen fields
     C                   PARM                    DDTSUB
      *
      ** Customer classification
      ** Market Deal Sub Type
      ** Portfolio Deal Sub Type
      *
     C                   PARM                    CustClass         1
     C                   PARM                    BVDMKS            2
     C                   PARM                    BVDPFS            2
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Trade Sub Type - OK
     C                   PARM                    DDTsubOK
      *
      ** Trade Sub Type
      *
     C                   PARM                    WorkTSUB          2
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
      * Load validated field to each Trade's Valid file
     C                   MOVEL     WorkTSUB      TPTSUB
     C                   MOVEL     WorkTSUB      TSTSUB
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VTCAPACI - Validate Capacity                                  *
      *****************************************************************
     C     VTCAPACI      BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
      ** Validate Originating Branch
      *
     C                   CALLB     'SEVTCAPACI'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Default & Validate (Y or N)
     C                   PARM      'N'           Default
     C                   PARM                    Validate
      *
      ** Trade Screen fields
     C                   PARM                    DDTCAP
     C                   PARM                    DDBLKR            6
     C                   PARM                    DDTDTP            2
      *
      ** Agency trade ID
      ** Bulk input option
     C                   PARM                    ATRD              1
     C                   PARM                    BVBIOP            1
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Capacity Ind. - OK
     C                   PARM                    DDTCAPok
      *
      ** Capacity Ind.
      *
     C                   PARM                    WorkTCAP          1
      *
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
      * Load validated field to each Trade's Valid file
     C                   MOVEL     WorkTCAP      TPTCAP
     C                   MOVEL     WorkTCAP      TSTCAP
 
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  233708
      *****************************************************************                       233708
      * VTFSPRICE - Validate Buy/Sell Fiscal Price                    *                       233708
      *****************************************************************                       233708
     C     VTFSPRICE     BEGSR                                                                233708
                                                                                              233708
      ** Validate Fiscal Price - Purchase                                                     233708
                                                                                              233708
     C                   EXSR      RESETERRS                                                  233708
                                                                                              233708
     C                   MOVE      DDPFSPR       DDFSPR                                       233708
     C                   Z-ADD     TPTDVD        WorkTDVD                                     233708
     C                   EXSR      CallVMod                                                   233708
     C                   IF        Idx <> 0                                                   233708
     C                   Z-ADD     1             I                                            233708
     C     'DDFSPR    '  LOOKUP    FldNameArr(I)                          99                  233708
     C     *IN99         IFEQ      '1'                                                        233708
     C                   EVAL      FlDNameArr(I) = 'DDPFSPR   '                               233708
     C                   ENDIF                                                                233708
     C                   ENDIF                                                                233708
     C                   MOVE      DDFSPROK      DDPFSPOK                                     233708
     C                   IF        DDFsprOK <> 'N'                                            233708
     C                   EVAL      TPFSPR = FSPR                                              233708
     C                   EVAL      TPFSPP = FSPP                                              233708
     C                   ENDIF                                                                233708
                                                                                              233708
      ** Update error info with that returned from the validation module                      233708
                                                                                              233708
     C                   EXSR      UPDATERRS                                                  233708
      *                                                                                       233708
      ** Validate Fiscal Price - Sale                                                         233708
                                                                                              233708
     C                   EXSR      RESETERRS                                                  233708
                                                                                              233708
     C                   MOVE      DDSFSPR       DDFSPR                                       233708
     C                   Z-ADD     TSTDVD        WorkTDVD                                     233708
     C                   EXSR      CallVMod                                                   233708
     C                   IF        Idx <> 0                                                   233708
     C                   Z-ADD     1             I                                            233708
     C     'DDFSPR    '  LOOKUP    FldNameArr(I)                          99                  233708
     C     *IN99         IFEQ      '1'                                                        233708
     C                   EVAL      FlDNameArr(I) = 'DDSFSPR   '                               233708
     C                   ENDIF                                                                233708
     C                   ENDIF                                                                233708
     C                   MOVE      DDFSPROK      DDSFSPOK                                     233708
     C                   IF        DDFsprOK <> 'N'                                            233708
     C                   EVAL      TSFSPR = FSPR                                              233708
     C                   EVAL      TSFSPP = FSPP                                              233708
     C                   ENDIF                                                                233708
                                                                                              233708
     C                   EXSR      UPDATERRS                                                  233708
                                                                                              233708
     C                   ENDSR                                                                233708
      *****************************************************************                       233708
      /EJECT                                                                                  233708
      *****************************************************************                       233708
      * CallVMod  - Call Validate Fiscal Price Module                 *                       233708
      *****************************************************************                       233708
     C     CallVMod      BEGSR                                                                233708
                                                                                              233708
     C                   CALLB     'SEVSEFSPR2'                                               233708
                                                                                              233708
      ** INPUTS                                                                               233708
      ** Return Code                                                                          233708
     C                   PARM                    RetCodeOut                                   233708
                                                                                              233708
      ** Default & Validate (Y or N)                                                          233708
                                                                                              233708
     C                   PARM                    Default                                      233708
     C                   PARM                    Validate                                     233708
                                                                                              233708
      ** Fiscal Price  (16A)                                                                  233708
                                                                                              233708
     C                   PARM                    DDFSPR           16                          233708
                                                                                              233708
      ** Trade Date (5P 0)                                                                    233708
                                                                                              233708
     C                   PARM                    WorkTDVD                                     233708
                                                                                              233708
      ** Security Details                                                                     233708
                                                                                              233708
     C                   PARM                    SECTY                                        233708
                                                                                              233708
      ** Investment Type Details                                                              233708
                                                                                              233708
     C                   PARM                    INVTP                                        233708
                                                                                              233708
      ** Customer (Counterparty) Details                                                      233708
                                                                                              233708
     C                   PARM                    CustDts                                      233708
     C                   PARM                    BJDFIN                                       233708
                                                                                              233708
      ** OUTPUTS                                                                              233708
      ** Error fields/message IDs/message data (arrays) from/to caller                        233708
                                                                                              233708
     C                   PARM                    FldNamXAr                                    233708
     C                   PARM                    MsgIDXAr                                     233708
     C                   PARM                    MsgDtaXAr                                    233708
                                                                                              233708
      ** Warning fields/message IDs/message data (arrays) from/to caller                      233708
                                                                                              233708
     C                   PARM                    WFldNmXAr                                    233708
     C                   PARM                    WMsgIDXAr                                    233708
     C                   PARM                    WMsgDtXAr                                    233708
                                                                                              233708
      ** Price Ok INdicator (1A)                                                              233708
      ** Price (15P 8)                                                                        233708
                                                                                              233708
     C                   PARM                    DDFsprOk          1                          233708
     C                   PARM                    FSPR                                         233708
     C                   PARM                    FSPP                                         233708
                                                                                              233708
     C                   ENDSR                                                                233708
      *****************************************************************                       233708
      /EJECT
      *****************************************************************
      * RENAMEFLD - Change entries in FldNamXAr to value appropriate  *
      *             for that field.                                   *
      *****************************************************************
     C     RENAMEFLD     BEGSR
 
     C                   Z-ADD     1             A
     C     *Blanks       LOOKUP    FldNamXAr(A)                           99
 
     C                   CLEAR                   FldNamXAr
     C                   EVAL      B = A - 1
     C                   DO        B
     C                   MOVEL     FieldName     FldNamXAr(B)
     C                   ENDDO
 
     C                   MOVEL     *Blanks       FieldName        10
 
     C                   ENDSR
      *****************************************************************
      * RESETERRS - Reset error information that is received back     *
      *    from each validation module.                               *
      *****************************************************************
     C     RESETERRS     BEGSR
 
     C                   EVAL      RetCodeOut = *Blanks
      *
      * Reset error & warning fields/message IDs/message data (arrays)
     C                   MOVEL     *BLANK        FldNamXAr
     C                   MOVEL     *BLANK        MsgIDXAr
     C                   MOVEL     *BLANK        MsgDtaXAr
     C                   MOVEL     *BLANK        WFldNmXAr
     C                   MOVEL     *BLANK        WMsgIDXAr
     C                   MOVEL     *BLANK        WMsgDtXAr
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * UPDATERRS - Update error information with that received back  *
      *    from each validation module.                               *
      *****************************************************************
     C     UPDATERRS     BEGSR
      *
      * Update error fields/message IDs/message data (arrays)
      *
     C                   Z-ADD     1             I                 3 0
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     *IN99         IFEQ      '1'
     C                   MOVEA     FldNamXAr     FlDNameArr(I)
     C                   MOVEA     MsgIDXAr      MsgIdArr(I)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(I)
     C                   END
      *
      * Set Error Index
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     I             SUB       1             Idx
      *
      * Update warning fields/message IDs/message data (arrays)
      *
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C     *IN99         IFEQ      '1'
     C                   MOVEA     WFldNmXAr     WFldNamArr(I)
     C                   MOVEA     WMsgIDXAr     WMsgIDArr(I)
     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(I)
     C                   END
      *
      * Set Warning Index
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C     I             SUB       1             WIdx              3 0
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *inzsr        BEGSR
 
     C     *Entry        PLIST
 
      * INPUTS
 
      * Response mode
     C                   PARM                    RespMode          1
 
      ** Trade Primary Details
     C                   PARM                    NwBSScnFmt
 
      ** Default & Validate (Y or N)
     C                   PARM                    Default
     C                   PARM                    Validate
     C                   PARM                    CGL031            1                          233708
 
      * OUTPUTS
 
      ** Security details
     C                   PARM                    SECTY
      ** Buy-Sell Backs Details OK inds
     C                   PARM                    OKBuySell
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
 
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx
      * Valid layout (for both trades) to/from caller
     C                   PARM                    TPFileFmt
     C                   PARM                    TSFileFmt
      * Collect clearance type data.                                                          191878
     C                   PARM                    CLRTYP                                       191878
 
      **  GET ZMUSER to access default branch.
      *
     C******DTAARA       DEFINE                  ZMUSER                                      BUG8550
     C**********         IN        ZMUSER                                                    BUG8550
     C**********         UNLOCK    ZMUSER                                                    BUG8550
      *
      **  Move program name into *LDA field.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'SEBYSLVAL'   DBPGM
     C                   OUT       LDA
      *
      **  Read data area - RUNDAT
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
      ** Get Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*FIRST '     DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '900'         DBASE
     C                   EXSR      SRERR
     C                   END
      *
      ** GET MODULE DETAILS
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST'      @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*FIRST '     DBKEY
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   EXSR      SRERR
     C                   END
      *
      ** Securities Trading
      *
     C                   CALL      'AOSTRDR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDSTRD        PARM      SDSTRD        DSSDY
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*FIRST '     DBKEY
     C                   MOVEL     'SDSTRDPD'    DBFILE
     C                   MOVEL     '902'         DBASE
     C                   EXSR      SRERR
     C                   END
      *
      ** Portfolio Management
      *
     C     BGPFMG        IFEQ      'Y'
     C                   CALL      'AOPORTR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDPORT        PARM      SDPORT        DSFDY
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*FIRST '     DBKEY
     C                   MOVEL     'SDPORTPD'    DBFILE
     C                   MOVEL     '903'         DBASE
     C                   EXSR      SRERR
     C                   END
     C                   END
      *
      ** Get General Ledger Details
      *
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*FIRST '     DBKEY
     C                   MOVEL     'SDGELRPD'    DBFILE
     C                   MOVEL     '904'         DBASE
     C                   EXSR      SRERR
     C                   END
      *
      ** Check if switchable feature S01496 is switched on.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01496'      @SARD
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'S01496'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '910'         DBASE
     C                   EXSR      SRERR
     C                   END
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           S01496            1
     C                   ELSE
     C                   MOVE      'N'           S01496
     C                   END
      *
      ** Check if switchable feature S01509 is switched on.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01509'      @SARD
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'S01509'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '905'         DBASE
     C                   EXSR      SRERR
     C                   END
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           S01509
     C                   ELSE
     C                   MOVE      'N'           S01509            1
     C                   END
      *
      ** Check if switchable feature S01511 is switched on.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01511'      @SARD
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'S01511'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '906'         DBASE
     C                   EXSR      SRERR
     C                   END
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           S01511
     C                   ELSE
     C                   MOVE      'N'           S01511            1
     C                   END
      *
      ** Check if switchable feature CSE003 is switched on.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSE003'      @SARD
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CSE003'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '907'         DBASE
     C                   EXSR      SRERR
     C                   END
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CSE003
     C                   ELSE
     C                   MOVE      'N'           CSE003            1
     C                   END
      *
      ** Check if switchable feature CSE007 is switched on.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSE007'      @SARD
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CSE007'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '908'         DBASE
     C                   EXSR      SRERR
     C                   END
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CSE007
     C                   ELSE
     C                   MOVE      'N'           CSE007            1
     C                   END
      *
      ** Check if switchable feature CEU017 is switched on.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU017'      @SARD
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CEU017'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '909'         DBASE
     C                   EXSR      SRERR
     C                   END
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CEU017
     C                   ELSE
     C                   MOVE      'N'           CEU017            1
     C                   END
      *
      ** Check if switchable feature CSE010 is switched on.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSE010'      @SARD
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CSE010'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '511'         DBASE
     C                   EXSR      SRERR
     C                   END
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CSE010            1
     C                   ELSE
     C                   MOVE      'N'           CSE010
     C                   END
 
      ** Check if CSC011 is installed                                                         CSC011
                                                                                              CSC011
     C                   EVAL      WRunDay = BJRDNB                                           CSC011
                                                                                              CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRTCD                                        CSC011
     C                   PARM      '*VERIFY'     POPTN                                        CSC011
     C                   PARM      'CSC011'      PSARD                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
     C                   IF        PRTCD = *Blanks                                            CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IN        SDSTAT                                                     CSC011
     C                   IF        LIBR = S1SUPP                                              CSC011
     C                   EVAL      WRunDay = S1DATE                                           CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
     C                   IF        PRTCD <> '*NRF'                                            CSC011
     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBASE = 913                                                CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
      *                                                                                       191878
      **  Clear work fields                                                                   191878
      *                                                                                       191878
     C                   MOVE      *BLANKS       Custcls1          1                          191878
     C                   MOVE      *BLANKS       Custcls2          1                          191878
                                                                                              191878
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SETRDPV027
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRERR - EXCEPTION ERRORS                                      *
      *                                                               *
      *****************************************************************
     C     SRERR         BEGSR
      *
     C                   MOVEL     'SEBYSLVAL'   DBPGM
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   DUMP
      *
      **  Terminate the program
      *
     C                   RETURN
      *
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
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
