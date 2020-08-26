     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Cross ccy IRS field valdation controller')    *
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Dealing Module                               *
      *                                                               *
      *  IRCIRSVAL  - Validate Cross Currency Interest Rate Swaps     *
      *                                                               *
      *  Function: This Program Validates IRS Deals for Input into    *
      *            the Midas database.                                *
      *            The sequence of validation is based on subroutine  *
      *            VALD08 in Midas program DL1603.                    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD053400           Date 03Jul19               *
      *                 MD051346           Date 17Jul18               *
      *                 MD046248           Date 27Oct17               *
      *                 MD033488           Date 12Mar15               *
      *                 CIR018             Date 11Aug14               *
      *                 MD026686           Date 08May14               *
      *                 CIR017             Date 10Apr14               *
      *                 245692             Date 11Dec13               *
      *                 AR569568           Date 22Nov12               *
      *                 262587             Date 17Sep10
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CIR014             Date 11May06               *
      *                 BUG11457           Date 11May06               *
      *                 CSD031             Date 10Apr06               *
      *                 BUG8550            Date 07Oct05               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG10704           Date 13Mar06               *
      *                 BUG9717            Date 29Dec05               *
      *                 BUG8266            Date 08Sep05               *
      *                 CDL038             Date 10May05               *
      *                 BUG7325            Date 25May05               *
      *                 CDL029A            Date 09May05               *
      *                 CSW037A            Date 02May05               *
      *                 BUG6472            Date 20Apr05               *
      *                 CDL028             Date 07Feb05               *
      *                 CAS008             Date 16Jun04               *
      *                 226002             Date 24Mar04               *
      *                 225997             Date 24Mar04               *
      *                 BUG6124            Date 03Mar05               *
      *                 BUG5443            Date 24Feb05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CDL029             Date 23NOV04               *
      *                 BUG5291            Date 20Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 222373             Date 31Oct03               *
      *                 CAS005             Date 16Dec02               *
      *                 218641             Date 10Jun03               *
      *                 217684             Date 12May03               *
      *                 215904             Date 25Mar03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 186676             Date 27Mar02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP055             Date 13Mar02               *
      *                 CAP056             Date 13Mar02               *
      *                 CIR008             Date 13Mar02               *
      *                 CAS001             Date 23Nov01               *
      *                 CAP041             Date 07Jan02               *
      *                 CSC011             Date 18Sep01               *
      *                 199730             Date 13Dec01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CIR007             Date 11May01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 11Oct00               *
      *                 185057             Date 23Jan01               *
      *                 184560             Date 23Jan01               *
      *                 CIR003             Date 13Sep00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 187606             Date 12Dec00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CIR005             Date 21Jan00               *
      *                 179732             Date 26Jun00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSW097             Date 02Dec99               *
      *                 164607             Date 19Jul99               *
      * Midas DBA 3.01 -----------------------------------------------*
      *       Amend No. 168981             Date 20May99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CPL002             Date 08Mar99               *
      *                 CAP004             Date 07Sep98               *
      *                 CAP003  *CREATE    Date 06Jun98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD053400 - Details are not correctly reverted back when the  *
      *             amended transaction is rejected in WIP. Skip      *
      *             validation if action is Reject.                   *
      *  MD051346 - The system does not allow to change the maturity  *
      *             date in OIS deal.                                 *
      *           - Ensure zero short term rate is accepted by the    *
      *             system during amend of OIS deals inserted in the  *
      *             past.                                             *
      *  MD046248 - Finastra Rebranding                               *
      *  MD033488 - Allow negative rates. Remove last parameter of    *
      *             program IRVSTERMRT to match entry parameter.      *
      *  CIR018 - Daily Rate Change Frequency on SIRS                 *
      *  MD026686 - Currency must not be blank in                     *
      *             Business Day Conventions Tab                      *
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
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  CIR014 - Mark to Market Cross-currency Interest Rate Swaps   *
      *           (Recompile)                                         *
      *  BUG11457-Transaction ccy is not passed by callers            *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG8550 - Reposition capture of ZMUSER data area             *
      *            (code fix included in CDL038)                      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10704 - If entered transaction customer is not valid      *
      *             or does not exist in file, validation of          *
      *             customer VS branch must not be carried out.       *
      *  BUG9717- Defaulting of class should be done when CDL038      *
      *           feature is currently ON.                            *
      *  BUG8266- Serious Midas error occur.DlNo in extension file    *
      *           is zero.                                            *
      *  CDL038 - Extended Deal Sub Type                              *
      *  BUG7325- Do not call IRVRTCHGDT in edit mode                 *
      *  CDL029A- Adding new field                                    *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG6472- Added a sign field to short term rate               *
      *  CDL028 - Automatic Rate Interpolations                       *
      *  CAS008 - IAS 39 Enhancements                                 *
      *  226002 - Revaluation yield curve should be of any type and   *
      *           of any interpolation type                           *
      *  225997 - Forward yield curve is populated in DEALSDG on      *
      *           update for the fixed leg when field is mandatory    *
      *  BUG6124 - Branch code error when CDL029 is set on.           *
      *  BUG5443- Apply code for CDL005 feature                       *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CDL029 - Midas SD Authorised Booking Branches for Customers  *
      *  BUG5291- Validate Business Day Conv. details in MidasPlus    *
      *  CLE025 - Credit Lines                                        *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  222373 - Correct parameters on program calls                 *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *  218641 - Adjust Yield Curve field position in the definition *
      *           file                                                *
      *  217684 - Authorisation User Malfunction (Recompile)          *
      *  215904 - Cannot input a Cross-Currency IRS due to tolerance  *
      *           levels. Fix is to change the error message to a     *
      *           warning message that could be overridden.           *
      *  186676 - Call new IRVDEALTPS to validate the deal type/      *
      *           subtype combination.                                *
      *  CAP055 - APIs for FRA/IRS Caps/Collars/Floors                *
      *           Add extra parameter to IRVRTFXDAY and IRVSPRRATE    *
      *           modules                                             *
      *  CAP056 - Automatic Authorisation of Interface deals          *
      *           (Recompile)                                         *
      *  CIR008 - FRA/IRS Deals Authorisation (Recompile)             *
      *  CAS001 - Net Present Value (NPV) Accounting.                 *
      *  CAP041 - APIs for IRS Fees/Buy-Outs/Processing Method/Next   *
      *           Principal Change Date. (Recompiled)                 *
      *  CSC011 - 24x7 Midas Availability                             *
      *  199730 - Maturity date can be amended to be less than the    *
      *           last payment date.  Do not skip validation if       *
      *           ReturnCode is 'Warning'.                            *
      *  CIR007 - Overnight Index Swaps                               *
      *  CSD006 - ZAVCURCODE uses DSSDY as *ENTRY parm, not SDCURRPD  *
      *  185057 - Don't revalidate Rate Change Date if Rate has been  *
      *           fixed.                                              *
      *  184560 - Validate Maturity date correctly against            *
      *           Our and Their Start/Last Int Pay Date.              *
      *  CIR003 - Principal Exchange on Cross Currencies IRS.         *
      *  187606 - Do not validate the Amount/Base Currency Rate       *
      *           in Amend mode.                                      *
      *  CIR005 - FRA/IRS Business Day Conventions                    *
      *  179732 - Only validate profit centre if not Blank OR         *
      *           Only allocate profit centre if the book code and    *
      *           deal subtype are entered.                           *
      *  CSW097 - SWIFT97 changes to MT340s and MT360s                *
      *  164607 - Amounts in FRA/IRS inputs should not be editted     *
      *           using decimal separator from SDDEALPD               *
      *  168981 - SWIFT 1997 Changes for FRAIRS MT34* and MT36*.      *
      *           (recompiled)                                        *
      *  CPL002 - Midas-Plato Interface (Recompiled)                  *
      *  CAP004 - API's Phase 3.                                      *
      *           Add extra parm for Extra Data                       *
      *  CAP003 - Conversion of DL inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
                                                                                              CDL029
     FSDABBCL0  IF   E           K DISK    INFSR(*PSSR)                                       CDL029
      ** Midas SD Authorised Booking Branches for Customers)                                  CDL029

      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,IRCIRSV099

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
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.

     D/COPY ZACPYSRC,PROCPARMS

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

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
      ** EXTERNAL DS FOR DEALING DETAILS
      *
     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
      ** EXTERNAL DS FOR TRADING DETAILS
     D  QQACCD1      E                     EXTFLD(QQACCD)                                     CGL029
      *
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
      ** EXTERNAL DS FOR RETAIL DETAILS
     D  QQACCD2      E                     EXTFLD(QQACCD)                                     CGL029
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
      *
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS
      *
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS
     D  QQACCD3      E                     EXTFLD(QQACCD)                                     CGL029
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** EXTERNAL DS FOR SAR DETAILS
      *
     D SDYLDC        E DS                  EXTNAME(SDYLDCPD)                                  CAS001
      ** External DS for yield curve file                                                     CAS001
                                                                                              CAS001
     D SDPORT        E DS                  EXTNAME(SDPORTPD)
      **  Data structure for Portfolio Management ICD File

     D SDPLCS        E DS                  EXTNAME(SDPLCSPD)
      ** External data structure for portfolio management details

     D SDDLST        E DS                  EXTNAME(SDDLSTPD)
      ** EXTERNAL DS FOR DEAL SUBTYPE DETAILS

     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** External data structure for customer details

     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External data structure for currency details

     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** External data structure for branch details
     D  QQDFAC1      E                     EXTFLD(QQDFAC)                                     CGL029

     D SDBROK        E DS                  EXTNAME(SDBROKPD)
      ** External data structure for broker details

     D SDBOOK        E DS                  EXTNAME(SDBOOKPD)
      ** External data structure for book details

     D SDFAIS        E DS                  EXTNAME(SDFAISPD)
      ** External data structure for FRA/IRS I.C.D. details
     I*
     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)
      ** External data structure for Base Rate details
     I*
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE

     D DSSDY         E DS                  EXTNAME(DSSDY)
      * SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE

     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
      ** 24X7 status data area                                                                CSC011
                                                                                              CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
      ** SD data area                                                                         CSC011
                                                                                              CSC011
     D ValidDeal     E DS                  EXTNAME(IRVCIRSPD)
      * Valid Deals layout
     D  RXBDY               2063   2190                                         CIR005
      ** Business Day Convention Cross Currency fields file format              CIR005

     D ValidXDeal    E DS                  EXTNAME(IRVXSIRPD)                                 CLE025
      * Valid Deals layout                                                                    CLE025
                                                                                              CLE025
     D ZMUSER          DS            17
     D  BRC                   11     13
     D  DEPT                  14     16

     D TranIn        E DS                  EXTNAME(IRCIRSPD)
      * Incoming Transaction
                                                                                CIR005
     D*BsDayConv*************243    370                                                CIR005 218641
     D*BsDayConv*************253    380                                                218641 CAS005
     D*BsDayConv*************263    390                                                CAS005 CLE025
     D*BsDayConv             278    405                                                CLE025 CAS008
     D BsDayConv             288    415                                                       CAS008
      ** Cross Currency Business Day Conventions layout                         CIR005
                                                                                CIR005
     D  BsDayLeg1                    64    OVERLAY(BsDayConv:1)                 CIR005
      ** Business Day Currencies for Leg 1                                      CIR005
                                                                                CIR005
     D   CcyPayLeg1                  30    OVERLAY(BsDayConv:1)                 CIR005
      ** Currencies for Payment Convention - leg 1                              CIR005
                                                                                CIR005
     D   CcyRteLeg1                  30    OVERLAY(BsDayConv:35)                CIR005
      ** Currencies for Rate Fixing Convention - leg 1                          CIR005
                                                                                CIR005
     D  BsDayLeg2                    64    OVERLAY(BsDayConv:65)                CIR005
      ** Business Day Currencies for Leg 2                                      CIR005
                                                                                CIR005
     D   CcyPayLeg2                  30    OVERLAY(BsDayConv:65)                CIR005
      ** Currencies for Payment Convention - leg 2                              CIR005
                                                                                CIR005
     D   CcyRteLeg2                  30    OVERLAY(BsDayConv:99)                CIR005
      ** Currencies for Rate Fixing Convention - leg 2                          CIR005
                                                                                CAP004
     D ExtData       E DS                  EXTNAME(IRCSEXPD)                    CAP004
      * IR CIRS Extra Data - File (D/B) format                                  CAP004
                                                                                              185057
      * (Current) Deal in Screen Format                                                       185057
     D DealScnFmt    E DS                  EXTNAME(IRCIRSPD)                                  185057
     D                                     PREFIX(@)                                          185057

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Error message fields received as parameters
     D     Msg1        S                   LIKE(#MsgID)
     D     Msg2        S                   LIKE(#MsgID)
     D     Msg3        S                   LIKE(#MsgID)
     D     Msg4        S                   LIKE(#MsgID)
     D     Msg5        S                   LIKE(#MsgID)
     D     Msg6        S                   LIKE(#MsgID)
     D     Msg7        S                   LIKE(#MsgID)

      ** Warning error message fields received as parameters
     D     WMSGID1     S                   LIKE(#MsgID)
     D     WMSGID2     S                   LIKE(#MsgID)
     D     WMSGID3     S                   LIKE(#MsgID)
     D     WMSGID4     S                   LIKE(#MsgID)
     D     WMSGID5     S                   LIKE(#MsgID)

      ** Error message substitution data received as a parameter
     D MSGDATA         S                   LIKE(#MsgData)
                                                                                CIR005
      ** Warning message data to be passed back to the calling module           CIR005
     D  WMsgData       S                   LIKE(#MsgData)                       CIR005

      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0

      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
                                                                                             CIR018
     D PActCode        S              1A                                                     CIR018
     D POred           S              5A                                                     CIR018

      ** Flags to indicate whether transaction fields are valid
      ** These have been declared for all DL1600D3 fields, some may not
      **  actually be needed if the field is not used/not validated
     D OKFlagsDS       DS
     D  SAccdOK                       1A
     D  SDlnoOK                       1A
     D  SDTypOK                       1A
     D  SDlstOK                       1A
     D  SDDatOK                       1A
     D  SBrcaOK                       1A
     D  SBrkcOK                       1A
     D  SBageOK                       1A
     D  SLnkDnOK                      1A
     D  SCnumOK                       1A
     D  SVDatOK                       1A
     D  SMDatOK                       1A
     D  SCdasOK                       1A
     D  SBokCOK                       1A
     D  STaxiOK                       1A
     D  SPrfCOK                       1A
     D  SOrBrOK                       1A
     D  SVDEIOK                       1A
     D  SMDEIOK                       1A
     D  SPDEIOK                       1A
     D  SUCucyOK                      1A
     D  SUPamtOK                      1A
     D  SUFfiOK                       1A
     D  SUBcxrOK                      1A
     D  SuBrttOK                      1A
     D  SuRtSpOK                      1A
     D  SuSpInOK                      1A
     D  SuFrfdOK                      1A
     D  SuNICDOK                      1A
     D  SuICFrOK                      1A
     D  SuICFDOK                      1A
     D  SuEInROK                      1A
     D  SuNIPDOK                      1A
     D  SuIPFrOK                      1A
     D  SuIPFDOK                      1A
     D  SuIcbsOK                      1A
     D  StCucyOK                      1A
     D  StPamtOK                      1A
     D  StFfiOK                       1A
     D  StBcxrOK                      1A
     D  StBrttOK                      1A
     D  StRtSpOK                      1A
     D  StSpInOK                      1A
     D  StFrfdOK                      1A
     D  StNICDOK                      1A
     D  StICFrOK                      1A
     D  StICFDOK                      1A
     D  StEInROK                      1A
     D  StNIPDOK                      1A
     D  StIPFrOK                      1A
     D  StIPFDOK                      1A
     D  StIcbsOK                      1A
     D  SCAInOK                       1A                                        CSW097
     D  OKOYLC                        1A                                                      218641
     D  OKTYLC                        1A                                                      218641
     D  OKOFYC                        1A                                                      CAS005
     D  OKTFYC                        1A                                                      CAS005
     D  SFCCUOK                       1A                                                      CLE025
     D  SFACTOK                       1A                                                      CLE025
     D  SFCNOOK                       1A                                                      CLE025
     D  OKOFCC                        1A                                                      CAS008
     D  OKTFCC                        1A                                                      CAS008
     D  OKFlgPay1                    10A                                        CIR005
     D  OKPayDat1                     1A                                        CIR005
     D  OKAmtCde1                     1A                                        CIR005
     D  OKFlgRte1                    10A                                        CIR005
     D  OKFlgPay2                    10A                                        CIR005
     D  OKPayDat2                     1A                                        CIR005
     D  OKAmtCde2                     1A                                        CIR005
     D  OKFlgRte2                    10A                                        CIR005
     D  SUFVDOK                       1A                                                      CDL038
     D  SUFEEOK                       1A                                                      CDL038
     D  SUFPROK                       1A                                                      CDL038
     D  SBOVDOK                       1A                                                      CDL038
     D  SBUYAOK                       1A                                                      CDL038
     D  SBOPROK                       1A                                                      CDL038
     D  SONPCDOK                      1A                                                      CDL038
     D  SOIPMOK                       1A                                                      CDL038
     D  STNPCDOK                      1A                                                      CDL038
     D  STIPMOK                       1A                                                      CDL038
     D  SCLASOK                       1A                                                      CDL038
     D**OKOYLC**                      1A                                               CAS001 218641
     D**OKTYLC**                      1A                                               CAS001 218641
     D**SRSetMOK**********************1A                                                      CDL038
     D**SPSetMOK**********************1A                                                      CDL038
     D**SURAccOK**********************1A                                                      CDL038
     D**SROBrOK***********************1A                                                      CDL038
     D**S@RAccOK**********************1A                                                      CDL038
     D**SUPAccOK**********************1A                                                      CDL038
     D**SPOBrOK***********************1A                                                      CDL038
     D**S@PAccOK**********************1A                                                      CDL038
     D**SCpPBkOK**********************1A                                                      CDL038
     D**SCpRBkOK**********************1A                                                      CDL038
     D**SFAcOOK***********************1A                                                      CDL038
     D**SSPiOK************************1A                                                      CDL038

      ** Flag to indicate if Exchange Indicators are valid
     D  SExInOK                       1A

      ** Flag to indicate Base Currency Equivalent fields are within
      ** 10% of each other
     D  SBCcyEqOK                     1A

      ** Flag(s) to indicate if combinations of transaction fields are valid
     D  DDDltStpOK                    1A

      ** Error flags from Dates validation routine
     D ErrDealDat      S              1A   INZ('N')
     D ErrValDate      S              1A   INZ('N')
     D ErrMatDate      S              1A   INZ('N')
     D ErrNxInDat      S              1A   INZ('N')

      ** Default Round Down indicators for Branch & Currency
     D BrRdfc          S              1A

      ** Day Basis field, required by IRVBOOKCDE for Caps/Collars validation
      ** (Not set up in this program)
     D DayBasis        S              1A

      ** Day number field, required by various modules for Caps/Collars
      ** (Not used in this program)
     D ZDAYX           S              2  0

      ** Receive / Pay Settlement Method & Nostro
     D RecSetCcy       S              3A
     D RecSetMeth      S              2S 0
     D***RecNostro       S             12A                                                    CGL029
     D RecNostro       S             18A                                                      CGL029
     D PaySetCcy       S              3A
     D PaySetMeth      S              2S 0
     D***PayNostro       S             12A                                                    CGL029
     D PayNostro       S             18A                                                      CGL029

      ** Broker currency decimal places  (used by MMVBROKCDE)
      ** Not needed in this program other than as a parm for MMVBROKCDE
     D BrokCcyDp       S              1  0

      ** Broker currency (used by MMVBROKCDE)
      ** Not needed in this program other than as a parm for MMVBROKCDE
     D BrokCcy         S              3A

      ** Deal date in Midas Day number format (set up by IRVIRSVDAT)
     D   MidasDDat     S              5P 0

      ** A code to indicate the calling function to the lower level modules
     D IRS             S              4A   INZ('CIRS')

      ** Average Rate Method, required by various modules for Caps/Collars
      ** (Not used in this program)
     D SAVRAM          S              1A   INZ('N')

      ** Response Mode, received as a parameter from the common header
     D RespMode        S              1A

      ** Amount field in 15,0 format required by MMVAMOUNT
     D Amount15        S             15  0

      ** Our/Their currency spot base rates & decimal places from SDCURRPD
     D    OurCcySpot   S             13  8
     D    OurCcyDecP   S              1S 0
     D    ThrCcySpot   S             13  8
     D    ThrCcyDecP   S              1S 0

      ** Validate Business Day Convention flag                                  CIR005
     D WValBDC         S              1A                                        CIR005
                                                                                CIR005
     D Ix              S                   LIKE(Idx)                            CIR005
                                                                                CIR005
     D FldNamXar       S             10A   DIM(ArrayMax)                        CIR005
                                                                                CIR005
     D MsgIDXar        S                   DIM(ArrayMax)                        CIR005
     D                                     LIKE(#MsgID)                         CIR005
                                                                                CIR005
     D WFldNamXar      S             10A   DIM(ArrayMax)                        CIR005
                                                                                CIR005
     D WMsgIDXar       S                   DIM(ArrayMax)                        CIR005
     D                                     LIKE(MsgIdArr)                       CIR005
      ** Business Day Currencies parameter                                      CIR005
     D PCcy1           S             30                                         CIR005
     D PCcy2           S             30                                         CIR005
      *                                                                         CIR005
      ** Mode of operation received from controller                             CIR005
     D ModeOfOp        S              6A                                        CIR005
                                                                                CIR005
      ** OVERNIGHT INDEX SWAPS                                                                CIR007
     DCIR007           S              1A                                                      CIR007
                                                                                              CIR007
      ** Return Code Field used as Parameter                                                  CIR007
     DPRTCD            S              7A                                                      CIR007
                                                                                              CIR007
      ** Option Field used as Parameter                                                       CIR007
     DPOption          S              7A                                                      CIR007
                                                                                              CIR007
      ** SAR Field used as Parameter to access its details                                    CIR007
     DPSard            S              6A                                                      CIR007
                                                                                              CIR007
      ** Action Code Field used as Parameter                                                  CIR007
     DPActnCde         S              1A                                                      CIR007
                                                                                              CIR007
      ** Deal Number Field used as Parameter                                                  CIR007
     DPDealNo          S              6A                                                      CIR007
                                                                                              CIR007
      ** Ourside/Theirside Indicator used as Parameter                                        CIR007
     DPOTInd           S              1A                                                      CIR007
                                                                                              CIR007
      ** Deal Type used as Parameter                                                          CIR007
     DPDealTyp         S              2A                                                      CIR007
                                                                                              CIR007
      ** Rate Change Frequency Code Field used as Parameter                                   CIR007
     DPRatChgFq        S              1A                                                      CIR007
                                                                                              CSC011
     D CSC011          S              1A                                                      CSC011
     D WRunDay         S                   LIKE(BJRDNB)                                       CSC011
                                                                                              CSC011
      ** Define fields used in CAS001                                                         CAS001
     DCAS001           S              1A                                                      CAS001
     DPYcFn            S              6A                                                      CAS001
     DPErTp            S              1A                                                      CAS001
     DPFwRv            S              1A                                                      CAS005
     DPFwYC            S              5A                                                      CAS005
     DWkSOFYC          S              5A                                                      CAS005
     DWkSTFYC          S              5A                                                      CAS005
                                                                                              CAS001
      ** Define fields used in CAS005                                                         CAS005
     D CAS005          S              1A                                                      CAS005
                                                                                              CAS005
     D CLE025          S              1A                                                      CLE025
     D Module          S              4A                                                      CLE025
                                                                                              CLE025
      ** Define fields used in CAS008                                                         CAS008
     D CAS008          S              1A                                                      CAS008
     D PFCRv           S              1A                                                      CAS008
                                                                                              CAS008
      ** Fields defined for Enhancement CDL029                                                CDL029
     D CDL029          S              1A                                                      CDL029
                                                                                              CDL029
      ** Fields defined for Enhancement CDL028                                                CDL028
     D CDL028          S              1A                                                      CDL028
     D CDL038          S              1A                                                     BUG9717
                                                                                            AR569568
     D CDL006          S              1A                                                    AR569568
      ** Fields defined for Enhancement CIR017                                                CIR017
     D CIR017          S              1A                                                      CIR017
     ** New parameter for IRVRTCHGDT due to fmt change in IRSBDYPD                            CIR017
     D*BsDayConv*******S************128A                                                      CIR017
     D BsDayConv128    S            128A                                                    MD026686
                                                                                              CIR017
      ** Parameter list for ZA0840                                                          MD053400
      ** =========================                                                          MD053400
      ** Return code for numeric validation module call                                     MD053400
     D @Rtcde          S             10A                                                    MD053400
      ** Alpha field for numeric validation                                                 MD053400
     D @@ALPH          S             16A                                                    MD053400
      ** Number of decimal places field for numeric validation                              MD053400
     D @@IDP           S              2  0                                                  MD053400
      ** Number of integers field for numeric validation                                    MD053400
     D @@IINT          S              2  0                                                  MD053400
      ** Millions/Thousands id (Y=function on)                                              MD053400
     D @@MTID          S              1A                                                    MD053400
      ** Amount calculation field                                                           MD053400
     D @@AMT           S             15  0                                                  MD053400
      ** Error return code for ZA0840 module                                                MD053400
     D @@ERCD          S              1  0                                                  MD053400
      **Decimal data length passed as a parameter to ZALIGN                                 MD053400
     D   ZADEC         S              1  0                                                  MD053400
                                                                                            MD053400
      **Digital data length passed as a parameter to ZALIGN                                 MD053400
     D   ZADIG         S              2  0                                                  MD053400
                                                                                            MD053400
      **Field Passed to ZALIGN on which the work is done                                    MD053400
     D   ZFIELD        S             16A                                                    MD053400
                                                                                            MD053400
      **Indicator to show whether or not ZALIGN was successful                              MD053400
     D   ZALIGNok      S              1A                                                    MD053400
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,IRCIRSV100

      *****************************************************************
      /EJECT
      *****************************************************************
     I*
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      /COPY WNCPYSRC,IRCIRSV001                                                 CAP004
                                                                                CAP004
      * Call Validation Modules in Sequence

      *  *-----------------------------------------------------*
      *  * Validation and Generation of Deal Number.           *
      *  *-----------------------------------------------------*
     C*******************CALL      'MMVACTDEAL'
     C*******************PARM                    ReturnCode
     C*******************PARM                    MSG1
     C*******************PARM                    RepairLoc
     C*******************PARM                    CnfValFrtO
     C*******************PARM                    ScrnFlds
     C*******************PARM                    ScrnFlags
     C**  GET ZMUSER to access default branch.                                                CDL038
     C**                                                                                      CDL038
     C     *DTAARA       DEFINE                  ZMUSER                                       CDL038
     C                   IN        ZMUSER                                                     CDL038
     C                   UNLOCK    ZMUSER                                                     CDL038
      *                                                                                     MD053400
      ** Skip validation if action is 'REJECT'                                              MD053400
      *                                                                                     MD053400
     C     ACTRJ         IFEQ      'Y'                                                      MD053400
     C                   EXSR      SRRSFD                                                   MD053400
     C                   EXSR      SetupValid                                               MD053400
     C                   RETURN                                                             MD053400
     C                   ENDIF                                                              MD053400
      *                                                                                       CDL038
      *  *-------------------------------*                                                    CDL038
      *  * Default Sub Type and Class                                                         CDL038
      *  *-------------------------------*                                                    CDL038
      *                                                                                       CDL038
     C                   IF        CDL038 = 'Y'                                              BUG9717
     C                   EXSR      DSUBTCLAS                                                  CDL038
     C                   ENDIF                                                               BUG9717

      *  *-------------------------------*
      *  * Validate Deal Sub-Type        *  #01
      *  *-------------------------------*

      * Reset variables updated by each module before each call
     C                   EXSR      RESETERRS

      /COPY WNCPYSRC,IRCIRSV002                                                 CAP004
                                                                                CAP004
     C                   CALLB     'MMVDLSTYPE'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    SDLST
     C                   PARM                    SDDLST

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SDLST '
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   MOVE      'N'           SDlstOK                                      CDL038
                                                                                              186676
     C                   ELSE                                                                 186676
     C                   CALLB     'IRVDEALTPS'                                               186676
     C                   PARM                    ReturnCode                                   186676
     C                   PARM                    MSG1                                         186676
     C                   PARM                    MSG2                                         CDL038
     C                   PARM                    SDTYP                                        186676
     C                   PARM                    SDLST                                        186676
     C                   PARM                    SCLAS                                        CDL038
                                                                                              186676
     C     MSG1          IFNE      *BLANK                                                     CDL038
     C                   ADD       1             Idx                                          CDL038
     C                   EVAL      FldNameArr(Idx) = 'SCLAS '                                 CDL038
     C                   EVAL      MsgIDArr(Idx) = MSG1                                       CDL038
     C                   MOVE      'N'           SClasOK                                      CDL038
     C                   ENDIF                                                                CDL038
     C     MSG2          IFNE      *BLANK                                                     CDL038
     C                   ADD       1             Idx                                          CDL038
     C                   EVAL      FldNameArr(Idx) = 'SDTYP '                                 CDL038
     C                   EVAL      MsgIDArr(Idx) = MSG2                                       CDL038
     C                   MOVE      'N'           SDTypOK                                      CDL038
     C                   MOVE      'N'           SDlstOK                                      CDL038
     C                   MOVE      'N'           SClasOK                                      CDL038
     C                   ENDIF                                                                CDL038
     C*****MSG1**********IFNE      *BLANK                                              186676 CDL038
     C*******************ADD       1             Idx                                   186676 CDL038
     C*******************EVAL      FldNameArr(Idx) = 'SDLST '                          186676 CDL038
     C*******************EVAL      MsgIDArr(Idx) = MSG1                                186676 CDL038
     C*******************ENDIF                                                         186676 CDL038
                                                                                              186676
     C                   ENDIF

      ***Use*the*return*code's value to set the field's OK flag                               CDL038
     C*******************CALLB     'ZASETOKFLG'                                               CDL038
     C*******************PARM                    SDlStOK                                      CDL038
     C*******************PARM                    ReturnCode                                   CDL038
     C*******************PARM                    WarnGlobal                                   CDL038

      /COPY WNCPYSRC,IRCIRSV003                                                 CAP004
                                                                                CAP004
      *  *------------------------*
      *  * Validate Branch Code   *  #02
      *  *------------------------*
     C                   EXSR      RESETERRS

      /COPY WNCPYSRC,IRCIRSV004                                                 CAP004
                                                                                CAP004
     C                   CALLB     'MMVBKGBRCH'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    BJSBRC
     C                   PARM                    BRC
     C                   PARM                    BrRdFc
     C                   PARM                    SACCD
     C                   PARM                    SBRCA
     C                   PARM                    RespMode
     C                   PARM                    RXBRCA
     C                   PARM                    SDBRCH

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SBRCA'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
      **********                                                                      CDL029 BUG6124
     C**********         IF        CDL029 ='Y'                                        CDL029 BUG6124
      **********                                                                      CDL029 BUG6124
     C*****KBRANCHAUTH   CHAIN     SDABBCL0                           91              CDL029 BUG6124
     C**********         IF        *IN91 = '1'                                        CDL029 BUG6124
     C**********         EVAL      ReturnCode = 'Error'                               CDL029 BUG6124
     C**********         ADD       1             Idx                                  CDL029 BUG6124
     C**********         EVAL      FldNameArr(Idx) = 'SBRCA'                          CDL029 BUG6124
     C**********         EVAL      MsgIDArr(Idx) = 'FXM7001'                          CDL029 BUG6124
     C**********         END                                                          CDL029 BUG6124
      **********                                                                      CDL029 BUG6124
     C**********         END                                                          CDL029 BUG6124

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    SBRCAOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,IRCIRSV005                                                 CAP004
                                                                                CAP004
      *  *------------------------*
      *  * Validate Deal Date     *  #03
      *  *------------------------*

     C                   EXSR      RESETERRS

      /COPY WNCPYSRC,IRCIRSV006                                                 CAP004
                                                                                CAP004
     C                   CALLB     'MMVDLDATE'
     C                   PARM                    ReturnCode
     C                   PARM                    Msg1
     C                   PARM                    Msg2
     C                   PARM                    WMsgid1
     C                   PARM                    RXDDAT
     C                   PARM                    SDDAT
     C**********         PARM                    BJRdnb                                       CSC011
     C                   PARM                    WRunDay                                      CSC011
     C                   PARM                    BJDfin
      ** Global warming flag (1A)
     C                   PARM                    WarnGlobal
      ** Local currency (3A, from SDBANKPD)
     C                   PARM                    BJLCCY
      ** Local location code (3A, from SDBRCHPD)
     C                   PARM                    A8LCCD

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SDDAT'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
     C     MSG2          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SDDAT'
     C                   EVAL      MsgIDArr(Idx) = MSG2
     C                   ENDIF

     C     WMSGID1       IFNE      *BLANK
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'SDDAT'
     C                   EVAL      WMsgIDArr(WIdx) = WMSGID1
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    SDDatOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,IRCIRSV007                                                 CAP004
                                                                                CAP004
      *  *------------------------*
      *  * Validate Broker Code   *  #04
      *  *------------------------*
     C                   EXSR      RESETERRS

      /COPY WNCPYSRC,IRCIRSV008                                                 CAP004
                                                                                CAP004
     C                   CALLB     'MMVBROKCDE'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    SBRKC
     C                   PARM                    BrokCcy
     C                   PARM                    BrokCcyDp
     C                   PARM                    SDBROK

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SBRKC'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    SBrkCOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,IRCIRSV009                                                 CAP004
                                                                                CAP004
      *  *------------------------*
      *  * Validate Brokerage     *  #05
      *  *------------------------*
     C                   EXSR      RESETERRS

      /COPY WNCPYSRC,IRCIRSV010                                                 CAP004
                                                                                CAP004
     C                   CALLB     'ZAVBROKAGE'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    MSG2
     C                   PARM                    SBrkCOK
     C                   PARM                    SBRKC
     C                   PARM                    SBAGE
     C                   PARM                    A9BRCY
     C                   PARM                    RXBAGE
      ** Decimal separator (1A, from SDDEALPD, via caller)
     C                   PARM                    BNDCSP

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SBAGE'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF

     C     MSG2          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SBAGE'
     C                   EVAL      MsgIDArr(Idx) = MSG2
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    SBageOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,IRCIRSV011                                                 CAP004
                                                                                CAP004
      *  *----------------------------------*
      *  * Validate Linked Reference Number *  #06
      *  *----------------------------------*
     C                   EXSR      RESETERRS

      /COPY WNCPYSRC,IRCIRSV012                                                 CAP004
                                                                                CAP004
     C                   CALLB     'MMVLINKREF'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    SLNKDN
      ** Decimal separator (1A, from SDDEALPD, via caller)
     C                   PARM                    BNDCSP

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SLNKDN'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    SLnkDNOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,IRCIRSV013                                                 CAP004
                                                                                CAP004
      *  *------------------------*
      *  * Validate Customer      *  #07
      *  *------------------------*
     C                   EXSR      RESETERRS

      /COPY WNCPYSRC,IRCIRSV014                                                 CAP004
                                                                                CAP004
     C                   CALLB     'IRVCUSTNUM'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    SCNUM
     C                   PARM                    SDCUST
     C                   PARM                    SACCD                                       BUG5443
      * customer format                                                                      BUG5443
      * N = customer number, else customer shortname                                         BUG5443
     C                   PARM                    CustFormat        1                         BUG5443

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SCNUM'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF

     C** set up file field
     C     ReturnCode    IFEQ      *BLANK
     C                   MOVE      BBCUST        RXCNUM
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    SCNumOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      *                                                                                      BUG6124
     C                   IF        CDL029 ='Y'                                               BUG6124
     C                             AND SCNumOK = 'Y'                                        BUG10704
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
     C                   EVAL      ReturnCode = 'Error'                                      BUG6124
     C                   ADD       1             Idx                                         BUG6124
     C                   EVAL      FldNameArr(Idx) = 'SBRCA'                                 BUG6124
     C                   EVAL      MsgIDArr(Idx) = 'FXM7001'                                 BUG6124
     C                   END                                                                 BUG6124
      *                                                                                      BUG6124
      ** Use the return code's value to set the field's OK flag                              CDL029A
     C                   CALLB     'ZASETOKFLG'                                              CDL029A
     C                   PARM                    SCNumOK                                     CDL029A
     C                   PARM                    ReturnCode                                  CDL029A
     C                   PARM                    WarnGlobal                                  CDL029A
                                                                                             CDL029A
     C                   END                                                                 BUG6124
      /COPY WNCPYSRC,IRCIRSV015                                                 CAP004
                                                                                CAP004
      *  *------------------------*
      *  * Validate Value Date    *  #08
      *  *------------------------*
     C                   EXSR      RESETERRS

      /COPY WNCPYSRC,IRCIRSV016                                                 CAP004
                                                                                CAP004
     C                   CALLB     'IRVIRSVDAT'
     C                   PARM                    ReturnCode
     C                   PARM                    Msg1
     C                   PARM                    WMsgid1
     C                   PARM                    WMsgid2
     C                   PARM                    SVDAT
     C                   PARM                    SDDAT
     C                   PARM                    RXVDAT
     C                   PARM                    MidasDDat
     C                   PARM                    BJDFIN
     C**********         PARM                    BJRDNB                                       CSC011
     C                   PARM                    WRunDay                                      CSC011
     C                   PARM                    BJLCCY
     C                   PARM                    BJSLCD
     C                   PARM                    SUCUCY
     C                   PARM                    STCUCY
      ** Deal settlement instruction fields
     C                   PARM                    RecSetCcy
     C                   PARM                    RecSetMeth                     rec settle meth
     C                   PARM                    RecNostro
     C                   PARM                    PaySetCcy
     C                   PARM                    PaySetMeth                     pay settle meth
     C                   PARM                    PayNostro
     C/COPY WNCPYSRC,IRH00081

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SVDAT'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF

     C     WMSGID1       IFNE      *BLANK
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'SVDAT'
     C                   EVAL      WMsgIDArr(WIdx) = WMSGID1
     C                   ENDIF

     C     WMSGID2       IFNE      *BLANK
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'SVDAT'
     C                   EVAL      WMsgIDArr(WIdx) = WMSGID2
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    SVDatOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,IRCIRSV017                                                 CAP004
                                                                                CAP004
      *  *-----------------------*
      *  * Validate Our Currency *  #09
      *  *-----------------------*
     C                   EXSR      RESETERRS

      /COPY WNCPYSRC,IRCIRSV018                                                 CAP004
                                                                                CAP004
     C                   CALLB     'ZAVCURCODE'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    SUCUCY
     C*******************PARM                    SDCURR                                       CSD006
     C     SDCURR        PARM                    DSSDY                                        CSD006

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SUCUCY'
     C                   EVAL      MsgIDArr(Idx) = MSG1

     C                   ELSE
      ** Store 'our currency' spot rate & number of decimal places.
     C                   Z-ADD     A6SPRT        OurCcySpot
     C                   Z-ADD     A6NBDP        OurCcyDecP
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    SuCucyOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,IRCIRSV019                                                 CAP004
                                                                                CAP004

      *  *-------------------------*
      *  * Validate Their Currency *  #09.5
      *  *-------------------------*
     C                   EXSR      RESETERRS

      /COPY WNCPYSRC,IRCIRSV020                                                 CAP004
                                                                                CAP004
     C                   CALLB     'ZAVCURCODE'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    STCUCY
     C*******************PARM                    SDCURR                                       CSD006
     C     SDCURR        PARM                    DSSDY                                        CSD006

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'STCUCY'
     C                   EVAL      MsgIDArr(Idx) = MSG1

     C                   ELSE
      ** Store 'their currency' spot rate & number of decimal places.
     C                   Z-ADD     A6SPRT        ThrCcySpot
     C                   Z-ADD     A6NBDP        ThrCcyDecP
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    StCucyOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,IRCIRSV021                                                 CAP004
                                                                                CAP004
      *  *------------------------*
      *  * Validate Maturity Date *  #10
      *  *------------------------*
     C                   EXSR      RESETERRS

      /COPY WNCPYSRC,IRCIRSV022                                                 CAP004
                                                                                CAP004
     C                   CALLB     'IRVMATDATE'
     C                   PARM                    ReturnCode
     C                   PARM                    Msg1
     C                   PARM                    WMsgid1
     C                   PARM                    WMsgid2
     C                   PARM                    SMDAT
     C                   PARM                    RXVDAT
     C                   PARM                    SUCUCY
     C                   PARM                    BJLCCY
     C                   PARM                    BJSLCD
     C                   PARM                    SAVRAM
     C**********         PARM                    BJRDNB                                       CSC011
     C                   PARM                    WRunday                                      CSC011
     C                   PARM                    BJDFIN
     C                   PARM                    SVDatOK
     C                   PARM                    SuCucyOK
     C                   PARM                    RXMDAT
     C                   PARM                    STCUCY
     C                   PARM                    StCucyOK

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SMDAT'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF

     C     WMSGID1       IFNE      *BLANK
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'SMDAT'
     C                   EVAL      WMsgIDArr(WIdx) = WMSGID1
     C                   ENDIF

     C     WMSGID2       IFNE      *BLANK
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'SMDAT'
     C                   EVAL      WMsgIDArr(WIdx) = WMSGID2
     C                   ENDIF
     C*                                                                                       184560
     C* Maturity date must not be earlier than Our Start/Last Int                             184560
     C* Pay Date or Their Start/Last Int Pay Date.                                            184560
     C*                                                                                       184560
     C     ACTNCD        IFEQ      'A'                                                        184560
     C     ReturnCode    IFEQ      *BLANK                                                     184560
     C     ReturnCode    OREQ      'Warning'                                                  199730
     C     RXMDAT        IFLT      PUSLIP                                                     184560
     C     RXMDAT        ORLT      PTSLIP                                                     184560
     C                   ADD       1             Idx                                          184560
     C                   EVAL      FldNameArr(Idx) = 'SMDAT'                                  184560
     C                   EVAL      MsgIDArr(Idx) = 'MMM3333'                                  184560
     C                   EVAL      ReturnCode = 'Error'                                       184560
     C                   ENDIF                                                                184560
     C                   ENDIF                                                                184560
     C                   ENDIF                                                                184560

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    SMDatOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,IRCIRSV023                                                 CAP004
                                                                                CAP004
      *  *-----------------------------------*
      *  * Validate Account Sequence Number  *  #11
      *  *-----------------------------------*
     C                   EXSR      RESETERRS

      /COPY WNCPYSRC,IRCIRSV024                                                 CAP004
                                                                                CAP004
     C                   CALLB     'MMVACSEQ'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    SCDAS
     C                   PARM                    RXCDAS
      ** Currency separator (1A, from SDDEALPD, via caller)
     C                   PARM                    BNDCSP

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SCDAS'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    SCdasOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,IRCIRSV025                                                 CAP004
                                                                                CAP004
      *  *------------------------*
      *  * Validate Book Code     *  #12
      *  *------------------------*
     C                   EXSR      RESETERRS

      /COPY WNCPYSRC,IRCIRSV026                                                 CAP004
                                                                                CAP004
     C                   CALLB     'IRVBOOKCDE'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    SBOKC
     C                   PARM                    SDBOOK
      ** Day Basis field used for Caps/Collars processing only.
     C                   PARM                    DayBasis

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SBOKC'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    SBokcOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,IRCIRSV027                                                 CAP004
                                                                                CAP004
      *  *----------------------------*
      *  * Validate Taxable Indicator *  #13
      *  *----------------------------*
     C                   EXSR      RESETERRS

      /COPY WNCPYSRC,IRCIRSV028                                                 CAP004
                                                                                CAP004
     C                   CALLB     'ZAVTAXIND'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    SCNumOK
     C                   PARM                    STAXI
     C                   PARM                    BBTAIN

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'STAXI'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    STaxIOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,IRCIRSV029                                                 CAP004
                                                                                CAP004
      *  *---------------------------*
      *  * Validate Profit Centre    *  #18
      *  *---------------------------*
      *                                                                         179732
      * Validate Profit Centre if not blank OR                                  179732
      * if blank and Book Code and Deal Subtype OK.                             179732
     C                   IF        SPrfC <> *Blanks OR                          179732
     C                             SBokCOK = 'Y' AND                            179732
     C                             SDlstOK = 'Y' AND                            179732
     C                             SPrfC = *Blanks                              179732
      *                                                                         179732
     C                   EXSR      RESETERRS

      /COPY WNCPYSRC,IRCIRSV030                                                 CAP004
                                                                                CAP004
     C                   CALLB     'ZAVPROFITC'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    SPRFC
     C                   PARM                    BKPRCU
     C                   PARM                    BKPRCA
     C                   PARM                    BKPCDU
     C                   PARM                    SDTYP
     C                   PARM                    BBACOC
     C                   PARM                    BBCUST
     C                   PARM                    SBOKC
     C                   PARM                    SDLST
     C                   PARM                    SBRCA
     C                   PARM                    DEPT
     C                   PARM                    PSUser
     C                   PARM                    SCNumOK
     C                   PARM                    BGN0ST

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SPRFC'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    SPrfCOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,IRCIRSV031                                                 CAP004
                                                                                CAP004
      * Endif statement for SBokCOK and SDlstOK = 'Y'                           179732
     C                   ENDIF                                                  179732
      *                                                                         179732
      *  *-----------------------------*
      *  * Validate Originating Branch *  #15
      *  *-----------------------------*
     C                   EXSR      RESETERRS

      /COPY WNCPYSRC,IRCIRSV032                                                 CAP004
                                                                                CAP004
     C                   CALLB     'ZAVORGBRCH'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    SORBR
     C                   PARM                    SBrCAOK
     C                   PARM                    SBRCA
     C                   PARM                    BGMBIN
     C                   PARM                    BKOBRU
     C                   PARM                    BKOBUV
     C                   PARM                    RespMode

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SORBR'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    SOrBrOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,IRCIRSV033                                                 CAP004
                                                                                CAP004
      *  *------------------------------*
      *  * Validate Exchange Indicators *  #16
      *  *------------------------------*
     C                   EXSR      RESETERRS

      /COPY WNCPYSRC,IRCIRSV034                                                 CAP004
                                                                                CAP004
     C                   CALLB     'IRVEXCHIND'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    MSG2
     C                   PARM                    MSG3
     C                   PARM                    CSW005
     C                   PARM                    SVDEI
     C                   PARM                    SMDEI
     C                   PARM                    CIR001
     C                   PARM                    SPDEI
     C                   PARM                    CIR003                                       CIR003
     C                   PARM                    RXVDEI                                       CIR003
     C                   PARM                    RXMDEI                                       CIR003
     C                   PARM                    RXPDEI                                       CIR003
      *                                                                                       CIR003
     C     CIR003        IFEQ      'Y'                                                        CIR003
     C     ReturnCode    ANDEQ     'Warning'                                                  CIR003
      *                                                                                       CIR003
     C     RXVDEI        IFEQ      'Y'                                                        CIR003
     C     SVDEI         ANDEQ     'N'                                                        CIR003
     C                   ADD       1             Widx                                         CIR003
     C                   EVAL      WfldNamArr(Widx)= 'SVDEI'                                  CIR003
     C                   EVAL      WmsgIdArr(Widx) = MSG1                                     CIR003
     C                   EVAL      SVDEIOk = 'W'                                              CIR003
     C                   ENDIF                                                                CIR003
      *                                                                                       CIR003
     C     RXMDEI        IFEQ      'Y'                                                        CIR003
     C     SMDEI         ANDEQ     'N'                                                        CIR003
     C                   ADD       1             Widx                                         CIR003
     C                   EVAL      WfldNamArr(Widx)= 'SMDEI'                                  CIR003
     C                   EVAL      WmsgIdArr(Widx) = MSG1                                     CIR003
     C                   EVAL      SMDEIOk = 'W'                                              CIR003
     C                   ENDIF                                                                CIR003
      *                                                                                       CIR003
     C     RXPDEI        IFEQ      'Y'                                                        CIR003
     C     SPDEI         ANDEQ     'N'                                                        CIR003
     C                   ADD       1             Widx                                         CIR003
     C                   EVAL      WfldNamArr(Widx)= 'SPDEI'                                  CIR003
     C                   EVAL      WmsgIdArr(Widx) = MSG1                                     CIR003
     C                   EVAL      SPDEIOk = 'W'                                              CIR003
     C                   ENDIF                                                                CIR003
      *                                                                                       CIR003
     C                   ELSE                                                                 CIR003

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SVDEI'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   EVAL      SVDEIOK = 'N'
     C                   ENDIF

     C     MSG2          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SMDEI'
     C                   EVAL      MsgIDArr(Idx) = MSG2
     C                   EVAL      SMDEIOK = 'N'
     C                   ENDIF

     C     MSG3          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SPDEI'
     C                   EVAL      MsgIDArr(Idx) = MSG3
     C                   EVAL      SPDEIOK = 'N'
     C                   ENDIF
      *                                                                                       CIR003
     C                   ENDIF                                                                CIR003

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    SExInOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,IRCIRSV035                                                 CAP004
                                                                                CAP004
      *  *----------------------------*                                                       CLE025
      *  * Validate Facility Details  *                                                       CLE025
      *  *----------------------------*                                                       CLE025
                                                                                              CLE025
     C     CLE025        IFEQ      'Y'                                                        CLE025
     C                   EXSR      RESETERRS                                                  CLE025
                                                                                              CLE025
     C                   MOVEA     *BLANKS       FldNamXar                                    CLE025
     C                   MOVEA     *BLANKS       MsgIdXar                                     CLE025
     C                   MOVEA     *BLANKS       WFldNamXar                                   CLE025
     C                   MOVEA     *BLANKS       WMsgIdXar                                    CLE025
                                                                                              CLE025
     C                   CALLB     'IRVFACNUM'                                                CLE025
     C                   PARM                    RetCodeIn                                    CLE025
                                                                                              CLE025
      ** INPUTS                                                                               CLE025
      ** Module                                                                               CLE025
      ** Action Code                                                                          CLE025
      ** Transaction Customer                                                                 CLE025
      ** Branch Code                                                                          CLE025
      ** Deal Type                                                                            CLE025
      ** Deal Subtype                                                                         CLE025
      ** Deal Class                                                                           CDL038
     C                   PARM      'CIRS'        Module                                       CLE025
     C                   PARM                    SACCD                                        CLE025
     C                   PARM                    SCNUM                                        CLE025
     C                   PARM                    SBRCA                                        CLE025
     C                   PARM                    SDTYP                                        CLE025
     C                   PARM                    SDLST                                        CLE025
     C                   PARM                    SCLAS                                        CDL038
                                                                                              CLE025
      ** Our Currency                                                                         CLE025
      ** Their Currency                                                                       CLE025
      ** Deal Date (Midas format 5 0)                                                         CLE025
      ** Deal Maturity Date                                                                   CLE025
      ** Maturity Date (Midas format 5 0)                                                     CLE025
     C                   PARM                    SUCUCY                                       CLE025
     C                   PARM                    STCUCY                                       CLE025
     C                   PARM                    RXDDAT                                       CLE025
     C                   PARM                    SMDAT                                        CLE025
     C                   PARM                    RXMDAT                                       CLE025
                                                                                              CLE025
      ** Facility Customer                                                                    CLE025
      ** Facility Type                                                                        CLE025
      ** Facility Number                                                                      CLE025
     C                   PARM                    SFCCU                                        CLE025
     C                   PARM                    SFACT                                        CLE025
     C                   PARM                    SFCNO                                        CLE025
                                                                                              CLE025
     C                   PARM                    WRunDay                                      CLE025
     C                   PARM                    ValidXDeal                                   CLE025
                                                                                              CLE025
      ** OK fields Input                                                                      CLE025
     C                   PARM                    SCNUMOK                                      CLE025
     C                   PARM                    SBRCAOK                                      CLE025
     C                   PARM                    SDLSTOK                                      CLE025
     C                   PARM                    SCLASOK                                      CDL038
     C                   PARM                    SDDATOK                                      CLE025
     C                   PARM                    SMDATOK                                      CLE025
     C                   PARM                    SUCUCYOK                                     CLE025
     C                   PARM                    STCUCYOK                                     CLE025
                                                                                              CLE025
      ** OUTPUTS                                                                              CLE025
      ** OK fields of facility                                                                CLE025
     C                   PARM                    SFCCUOK                                      CLE025
     C                   PARM                    SFACTOK                                      CLE025
     C                   PARM                    SFCNOOK                                      CLE025
                                                                                              CLE025
      ** Error fields/message IDs/message data (arrays) from/to c                             CLE025
     C                   PARM                    FldNamXar                                    CLE025
     C                   PARM                    MsgIDXar                                     CLE025
     C                   PARM                    WFldNamXar                                   CLE025
     C                   PARM                    WMsgIDXar                                    CLE025
                                                                                              CLE025
      ** Log error messages                                                                   CLE025
                                                                                              CLE025
     C                   EVAL      Ix = 1                                                     CLE025
     C                   DOW       FldNamXar(Ix) <> *Blanks                                   CLE025
     C                   EVAL      Idx = Idx + 1                                              CLE025
     C                   EVAL      FldNameArr(Idx) = FldNamXar(Ix)                            CLE025
     C                   EVAL      MsgIdArr(Idx) = MsgIDXar(Ix)                               CLE025
     C                   EVAL      Ix = Ix + 1                                                CLE025
     C                   ENDDO                                                                CLE025
                                                                                              CLE025
      ** Log warning messages                                                                 CLE025
                                                                                              CLE025
     C                   EVAL      Ix = 1                                                     CLE025
     C                   DOW       FldNamXar(Ix) <> *Blanks                                   CLE025
     C                   EVAL      WIdx = WIdx + 1                                            CLE025
     C                   EVAL      WFldNamArr(WIdx) = WFldNamXar(Ix)                          CLE025
     C                   EVAL      WMsgIdArr(WIdx) = WMsgIDXar(Ix)                            CLE025
     C                   EVAL      Ix = Ix + 1                                                CLE025
     C                   ENDDO                                                                CLE025
                                                                                              CLE025
     C                   MOVEA     *Blanks       FldNamXar                                    CLE025
     C                   MOVEA     *Blanks       MsgIDXar                                     CLE025
     C                   ENDIF                                                                CLE025
                                                                                              CLE025
      *  *-----------------------*
      *  * Validate Our Amount   *  #17
      *  *-----------------------*
     C                   EXSR      RESETERRS

      /COPY WNCPYSRC,IRCIRSV036                                                 CAP004
                                                                                CAP004
     C                   CALLB     'MMVAMOUNT'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    SUPAMT
     C                   PARM                    SuCucyOK
     C                   PARM                    OurCcyDecP
     C                   PARM                    SDTYP
     C                   PARM                    Amount15
      ** Currency separator (1A, from SDDEALPD, via caller)
     C                   PARM                    BNDCSP
     C                   PARM                    PActnCde                                   AR569568
     C                   PARM                    CDL006                                     AR569568

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SUPAMT'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ELSE
      ** Set up output field in 13,0 format
     C                   Z-ADD     Amount15      RXUPAMT
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    SuPAmtOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,IRCIRSV037                                                 CAP004
                                                                                CAP004
      *  *--------------------------------------*
      *  * Validate Our Federal funds indicator *  #18
      *  *--------------------------------------*
     C                   EXSR      RESETERRS
      /COPY WNCPYSRC,IRCIRSV038                                                 CAP004
                                                                                CAP004
     C                   CALLB     'MMVFEDFUND'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
      ** Federal funds indicator
     C                   PARM                    SUFFI
      ** Currency code
     C                   PARM                    SUCUCY
      ** US Currency code
     C                   PARM                    BLUSCY

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SUFFI'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    SuFFIOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,IRCIRSV039                                                 CAP004
                                                                                CAP004
      *  *------------------------------------------*
      *  * Validate Our Base Currency Exchange Rate *  #19
      *  *------------------------------------------*
      *                                                                                       187606
      * Should be validated in Insert only.                                                   187606
      *                                                                                       187606
     C     ACTNCD        IFEQ      'I'                                                        187606
     C     ACTNCD        OREQ      'A'                                                        221963
     C     RXORED        ANDEQ     BJRDNB                                                     221963
     C     ACTNCD        OREQ      'A'                                                        221963
     C     RXORED        ANDNE     BJRDNB                                                     221963
     C     SUBCXR        ANDNE     @SUBCXR                                                    221963
      *                                                                                       187606
     C                   EXSR      RESETERRS

      /COPY WNCPYSRC,IRCIRSV040                                                 CAP004
                                                                                CAP004
     C                   CALLB     'IRVBCURRAT'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    SUBCXR
     C                   PARM                    OurCcySpot
     **Constants passed in by calling programme.
     C                   PARM                    SUCUCY
     C                   PARM                    BJCYCD
     C                   PARM                    RXUBCXR
     C                   PARM                    BNDCSP                                       245692

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SUBCXR'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    SuBCXROK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
      *                                                                                       187606
     C                   ENDIF                                                                187606

      /COPY WNCPYSRC,IRCIRSV041                                                 CAP004
                                                                                CAP004
      *  *------------------------------------------*
      *  * Validate Our Interest Calculation Basis  *  #20
      *  *------------------------------------------*
     C                   EXSR      RESETERRS

      /COPY WNCPYSRC,IRCIRSV042                                                 CAP004
                                                                                CAP004
     C                   CALLB     'IRVIRSINTC'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    CIR001
     C                   PARM                    SUIPFR
     C                   PARM                    SUICBS

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SUICBS'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    SuICBsOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,IRCIRSV043                                                 CAP004
                                                                                CAP004
      ** If CAS001 is on and deal sub type is ok, then validate                               CAS001
      ** yield curve                                                                          CAS001
                                                                                              CAS001
     C                   IF        CAS001 = 'Y' AND                                           CAS001
     C                             SDlstOK <> 'N' AND                                         CDL038
     C                             SCLasOK <> 'N'                                             CDL038
     C*****************************SDlstOK <> 'N'                                      CAS001 CDL038
                                                                                              CAS005
      ** If CAS005 is installed, populate new parameter fields with values                    CAS005
                                                                                              CAS005
     C                   IF        CAS005 = 'Y'                                               CAS005
     C                   EVAL      PFwRv = 'R'                                                CAS005
     C                   EVAL      PFwYC = SOFYC                                              CAS005
     C                   ELSE                                                                 CAS005
     C                   EVAL      PFwRv = *BLANKS                                            CAS005
     C                   EVAL      PFwYC = *BLANKS                                            CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS001
      *  *--------------------------*                                                         CAS001
      *  * Validate Our Yield Curve *                                                         CAS001
      *  *--------------------------*                                                         CAS001
                                                                                              CAS001
     C                   EXSR      RESETERRS                                                  CAS001
                                                                                              CAS001
     C                   CALLB     'ZAVYLDC01'                                                CAS001
     C                   PARM                    ReturnCode                                   CAS001
     C                   PARM                    SDTYP                                        CAS001
     C                   PARM                    SDLST                                        CAS001
     C                   PARM                    SCLAS                                        CDL038
     C                   PARM                    SOYLC                                        CAS001
     C                   PARM      'DDOYLC'      PYcFn                                        CAS001
     C                   PARM                    PFwRv                                        CAS005
     C                   PARM                    PFwYC                                        CAS005
     C                   PARM      *BLANKS       PFCRv                                        CAS008
     C                   PARM      'Y'           OKOYLC                                       CAS001
      ** Error Type                                                                           CAS001
     C                   PARM      *BLANKS       PErTp                                        CAS001
      ** Yield Curve                                                                          CAS001
     C                   PARM      *BLANKS       RXOYLC                                       CAS001
                                                                                              CAS001
     C**********         IF        ReturnCode = *BLANK                                 CAS001 226002
     C**********         CLEAR                   WkYLDC            5                   CAS001 226002
     C**********         EVAL      WkYLDC = RXOYLC                                     CAS001 226002
     C**********         EXSR      SrAccesYldC                                         CAS001 226002
     C**********         ENDIF                                                         CAS001 226002
                                                                                              CAS001
     C                   IF        ReturnCode <> *BLANK                                       CAS001
     C                   EVAL      Idx = Idx + 1                                              CAS001
     C                   EVAL      FldNameArr(Idx) = 'SOYLC'                                  CAS001
                                                                                              CAS001
     C                   SELECT                                                               CAS001
     C                   WHEN      PERTP = '1'                                                CAS001
     C                   EVAL      MsgIDArr(Idx) = 'FXM5055'                                  CAS001
     C**********         WHEN      PERTP = '3'                                         CAS001 226002
     C**********         EVAL      MsgIDArr(Idx) = 'FXM5059'                           CAS001 226002
     C                   WHEN      PERTP = '4'                                                CAS005
     C                   EVAL      MsgIDArr(Idx) = 'RS00061'                                  CAS005
     C                   OTHER                                                                CAS001
     C                   EVAL      MsgIDArr(Idx) = 'FXM5057'                                  CAS001
     C                   ENDSL                                                                CAS001
      *                                                                                       CAS001
     C                   ENDIF                                                                CAS001
                                                                                              CAS001
      ** Use the return code's value to set the field's OK flag                               CAS001
                                                                                              CAS001
     C                   CALLB     'ZASETOKFLG'                                               CAS001
     C                   PARM                    OKOYLC                                       CAS001
     C                   PARM                    ReturnCode                                   CAS001
     C                   PARM                    WarnGlobal                                   CAS001
                                                                                              CAS001
      ** If CAS005 is on, validate forward yield curve                                        CAS005
                                                                                              CAS005
     C                   IF        CAS005 = 'Y'                                               CAS005
                                                                                              CAS005
      *  *----------------------------------*                                                 CAS005
      *  * Validate Our Forward Yield Curve *                                                 CAS005
      *  *----------------------------------*                                                 CAS005
                                                                                              CAS005
     C                   EXSR      RESETERRS                                                  CAS005
                                                                                              CAS005
      ** Save initial screen value of forward yield curve                                     CAS005
                                                                                              CAS005
     C                   EVAL      WkSOFYC = SOFYC                                            CAS005
                                                                                              CAS005
     C                   CALLB     'ZAVYLDC01'                                                CAS005
     C                   PARM                    ReturnCode                                   CAS005
     C                   PARM                    SDTYP                                        CAS005
     C                   PARM                    SDLST                                        CAS005
     C                   PARM                    SCLAS                                        CDL038
     C                   PARM                    SOFYC                                        CAS005
     C                   PARM      'DDOFYC'      PYcFn                                        CAS005
     C                   PARM      'F'           PFwRv                                        CAS005
     C                   PARM      *BLANKS       PFwYC                                        CAS005
     C                   PARM      *BLANKS       PFCRv                                        CAS008
     C                   PARM      'Y'           OKOFYC                                       CAS005
      ** Error Type                                                                           CAS005
     C                   PARM      *BLANKS       PErTp                                        CAS005
      ** Forward Yield Curve                                                                  CAS005
     C                   PARM      *BLANKS       RXOFYC                                       CAS005
                                                                                              CAS005
      ** Prevent defaulting if the leg is not attached to a base rate                         CAS005
                                                                                              CAS005
     C**********         IF        SUBRTT = *BLANKS OR SUBRTT = '00'                   CAS005 CSD103
     C                   IF        SUBRTT = *BLANKS                                           CSD103
     C                   IF        WkSOFYC = *BLANKS                                          CAS005
     C                   EVAL      SOFYC = *BLANKS                                            CAS005
     C                   EVAL      RXOFYC = *BLANKS                                           225997
     C                   EVAL      ReturnCode = *BLANKS                                       CAS005
     C                   EVAL      PERTP = *BLANKS                                            CAS005
     C                   EVAL      OKOFYC = 'Y'                                               CAS005
     C                   ENDIF                                                                CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   IF        ReturnCode <> *BLANK                                       CAS005
     C                   EVAL      Idx = Idx + 1                                              CAS005
     C                   EVAL      FldNameArr(Idx) = 'SOFYC'                                  CAS005
                                                                                              CAS005
     C                   SELECT                                                               CAS005
     C                   WHEN      PERTP = '1'                                                CAS005
     C                   EVAL      MsgIDArr(Idx) = 'RS00063'                                  CAS005
     C                   OTHER                                                                CAS005
     C                   EVAL      MsgIDArr(Idx) = 'RS00065'                                  CAS005
     C                   ENDSL                                                                CAS005
      *                                                                                       CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
      ** If the leg is not attached to a base rate, forward yield curve must                  CAS005
      ** not be populated                                                                     CAS005
                                                                                              CAS005
     C**********         IF        (SUBRTT = *BLANKS OR SUBRTT = '00') AND             CAS005 CSD103
     C                   IF        SUBRTT = *BLANKS                                           CSD103
     C                             SOFYC <> *BLANKS                                           CAS005
     C                   EVAL      ReturnCode = 'Error'                                       CAS005
     C                   EVAL      Idx = Idx + 1                                              CAS005
     C                   EVAL      FldNameArr(Idx) = 'SOFYC'                                  CAS005
     C                   EVAL      MsgIDArr(Idx) = 'RS00067'                                  CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
      ** If Forward yield curve is entered, revaluation yield curve is mandatory              CAS005
                                                                                              CAS005
     C                   IF        SOYLC = *BLANKS AND SOFYC <> *BLANKS                       CAS005
     C                   EVAL      ReturnCode = 'Error'                                       CAS005
     C                   EVAL      Idx = Idx + 1                                              CAS005
     C                   EVAL      FldNameArr(Idx) = 'SOFYC'                                  CAS005
     C                   EVAL      MsgIDArr(Idx) = 'RS00061'                                  CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
      ** Use the return code's value to set the field's OK flag                               CAS005
                                                                                              CAS005
     C                   CALLB     'ZASETOKFLG'                                               CAS005
     C                   PARM                    OKOFYC                                       CAS005
     C                   PARM                    ReturnCode                                   CAS005
     C                   PARM                    WarnGlobal                                   CAS005
                                                                                              CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   IF        CAS008 = 'Y' AND                                           CAS008
     C                             CIR003 = 'Y'                                               CAS008
                                                                                              CAS008
      *  *---------------------------------------------*                                      CAS008
      *  * Validate Our Forward Commitment Yield Curve *                                      CAS008
      *  *---------------------------------------------*                                      CAS008
                                                                                              CAS008
     C                   EXSR      RESETERRS                                                  CAS008
                                                                                              CAS008
     C                   CALLB     'ZAVYLDC01'                                                CAS008
     C                   PARM                    ReturnCode                                   CAS008
     C                   PARM                    SDTYP                                        CAS008
     C                   PARM                    SDLST                                        CAS008
     C                   PARM                    SCLAS                                        CDL038
     C                   PARM                    SOFCC                                        CAS008
     C                   PARM      'DDOFCC'      PYcFn                                        CAS008
     C                   PARM      *BLANKS       PFwRv                                        CAS008
     C                   PARM      *BLANKS       PFwYC                                        CAS008
     C                   PARM      'C'           PFCRv                                        CAS008
     C                   PARM      'Y'           OKOFCC                                       CAS008
                                                                                              CAS008
      ** Error Type                                                                           CAS008
      ** Forward Cmt Yield Curve                                                              CAS008
                                                                                              CAS008
     C                   PARM      *BLANKS       PErTp                                        CAS008
     C                   PARM      *BLANKS       RXOFCC                                       CAS008
                                                                                              CAS008
     C                   IF        ReturnCode <> *BLANK                                       CAS008
     C                   EVAL      Idx = Idx + 1                                              CAS008
     C                   EVAL      FldNameArr(Idx) = 'SOFCC'                                  CAS008
                                                                                              CAS008
     C                   SELECT                                                               CAS008
     C                   WHEN      PERTP = '1'                                                CAS008
     C                   EVAL      MsgIDArr(Idx) = 'RS00069'                                  CAS008
     C                   OTHER                                                                CAS008
     C                   EVAL      MsgIDArr(Idx) = 'RS00075'                                  CAS008
     C                   ENDSL                                                                CAS008
                                                                                              CAS008
     C                   ENDIF                                                                CAS008
                                                                                              CAS008
      ** If Forward Commitment yield curve is entered, revaluation yield curve                CAS008
      ** is mandatory.                                                                        CAS008
                                                                                              CAS008
     C                   IF        SOYLC = *BLANKS AND SOFCC <> *BLANKS                       CAS008
     C                   EVAL      ReturnCode = 'Error'                                       CAS008
     C                   EVAL      Idx = Idx + 1                                              CAS008
     C                   EVAL      FldNameArr(Idx) = 'SOFCC'                                  CAS008
     C                   EVAL      MsgIDArr(Idx) = 'RS00073'                                  CAS008
     C                   EVAL      OKOYLC = 'N'                                               CAS008
     C                   ENDIF                                                                CAS008
                                                                                              CAS008
      ** Use the return code's value to set the field's OK flag                               CAS008
                                                                                              CAS008
     C                   CALLB     'ZASETOKFLG'                                               CAS008
     C                   PARM                    OKOFCC                                       CAS008
     C                   PARM                    ReturnCode                                   CAS008
     C                   PARM                    WarnGlobal                                   CAS008
                                                                                              CAS008
     C                   ENDIF                                                                CAS008
                                                                                              CAS008
     C                   ENDIF                                                                CAS001
                                                                                              CAS001
      *  *------------------------------*
      *  * Validate Our Base Rate Code  *  #21
      *  *------------------------------*
     C                   EXSR      RESETERRS

      /COPY WNCPYSRC,IRCIRSV044                                                 CAP004
                                                                                CAP004
     C                   EVAL      PRatChgFq = SUICFR                                         CIR007
                                                                                              CIR007
     C                   CALLB     'IRVBRATCDE'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    MSG2
     C                   PARM                    SUBRTT
     C                   PARM                    SuCuCyOK
     C                   PARM                    SUCUCY
     C                   PARM                    CIR001
     C                   PARM                    SUIPFR
     C                   PARM                    PRatChgFq                                    CIR007
     C                   PARM      SDTYP         PDealTyp                                     CIR007
     C                   PARM                    CIR007                                       CIR007

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SUBRTT'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF

     C     MSG2          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SUBRTT'
     C                   EVAL      MsgIDArr(Idx) = MSG2
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    SuBrttOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,IRCIRSV045                                                 CAP004
                                                                                CAP004
      *  *------------------------------*
      *  * Validate Our Spread Rate     *  #22
      *  *------------------------------*
     C                   EXSR      RESETERRS

      /COPY WNCPYSRC,IRCIRSV046                                                 CAP004
                                                                                CAP004
     C                   CALLB     'IRVSPRRATE'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    SURTSP
     C                   PARM                    CIR001
     C                   PARM                    SUIPFR
     C                   PARM                    SUBRTT
     C                   PARM      SDTYP         PDealTyp                                     CAP055
     C                   PARM                    RXURTSP
     C                   PARM                    BNDCSP                                       245692

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SURTSP'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    SuRtSpOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,IRCIRSV047                                                 CAP004
                                                                                CAP004
      *  *-------------------------------*
      *  * Validate Our Spread Indicator *  #23
      *  *-------------------------------*
     C                   EXSR      RESETERRS

      /COPY WNCPYSRC,IRCIRSV048                                                 CAP004
                                                                                CAP004
     C                   CALLB     'IRVSPRDIND'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    SUSPIN
     C                   PARM                    SURTSP
     C                   PARM                    SUBRTT

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SUSPIN'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    SuSpInOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,IRCIRSV049                                                 CAP004
                                                                                CAP004
      *  *----------------------------*
      *  * Validate Our Rate Fix Days *  #24
      *  *----------------------------*
     C                   EXSR      RESETERRS

      /COPY WNCPYSRC,IRCIRSV050                                                 CAP004
                                                                                CAP004
     C                   EVAL      PRatChgFq = SUICFR                                         CIR007
                                                                                              CIR007
     C                   CALLB     'IRVRTFXDAY'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    SUFRFD
     C                   PARM                    SUBRTT
     C                   PARM                    SUCUCY
     C                   PARM                    BLCYCD
     C                   PARM                    BJLCCY
     C                   PARM                    RXUFRFD
     C                   PARM                    PRatChgFq                                    CIR007
     C                   PARM      SDTYP         PDealTyp                                     CIR007
     C                   PARM                    CIR007                                       CIR007
     C                   PARM                    SAVRAM                                       CAP055

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SUFRFD'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    SuFRFDOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,IRCIRSV051                                                 CAP004
                                                                                CAP004
      *  *-------------------------------*
      *  * Validate Our Rate Change Date *  #25
      *  *-------------------------------*
     C                   EXSR      RESETERRS
      *                                                                         CIR005
      ** If Business Day Convention is on and called from CTL,                  CIR005
      ** validate business day convention fields.                               CIR005
     C                   IF        CIR005 = 'Y' and                             CIR005
     C**********                   ModeOfOp = '*FRONT'                          CIR005       BUG5291
     C                             ModeOfOp = '*FRONT' Or                                    BUG5291
     C                             CIR005 = 'Y' and                                          BUG5291
     C                             ModeOfOp <> '*SIN'                                        BUG5291
      *                                                                         CIR005
      ** Validate Currencies for Rate Fixing Convention - Leg 1                 CIR005
     C                   CALLB     'IRVBDYCCY'                                  CIR005
     C                   PARM      *Blanks       RetCodeOut                     CIR005
     C                   PARM      'B'           PCode             1            CIR005
     C                   Parm                    PLCcy             3            CIR005
     C                   PARM      CcyRteLeg1    Pccy1                          CIR005
     C                   PARM      CcyPayLeg1    Pccy2                          CIR005
     C                   PARM                    OkFlgRte1                      CIR005
     C                   PARM                    OKFlgPay1                      CIR005
     C                   PARM      *Blanks       MsgIdXar                       CIR005
     C                   PARM      *Blanks       FldNamXar                      CIR005
     C                   PARM      *Blanks       WMsgIdXar                      CIR005
     C                   PARM      *Blanks       WFldNamXar                     CIR005
      *                                                                         CIR005
     C                   EVAL      Ix = 1                                       CIR005
     C                   DOW       FldNamXar(Ix) <> *Blanks                     CIR005
     C                   EVAL      Idx = Idx + 1                                CIR005
     C                   MOVE      '1'           WSuffix           1            CIR005
     C                   CAT(P)    WSuffix:0     FldNamXar(Ix)                  CIR005
     C                   EVAL      FldNameArr(Idx) = FldNamXar(Ix)              CIR005
     C                   EVAL      MsgIdArr(Idx) = MsgIDXar(Ix)                 CIR005
     C                   EVAL      Ix = Ix + 1                                  CIR005
     C                   ENDDO                                                  CIR005
      *                                                                         CIR005
      ** Validate Payment Date and Amount Codes - Leg 1                         CIR005
     C                   CALLB     'IRVPAMCNV'                                  CIR005
     C                   PARM      *Blanks       RetCodeOut                     CIR005
     C                   PARM                    SPDC1                          CIR005
     C                   PARM                    SAMC1                          CIR005
     C                   PARM                    OkPayDat1                      CIR005
     C                   PARM                    OKAmtCde1                      CIR005
     C                   PARM      *Blanks       MsgIdXar                       CIR005
     C                   PARM      *Blanks       FldNamXar                      CIR005
      *                                                                         CIR005
     C                   EVAL      Ix = 1                                       CIR005
     C                   DOW       FldNamXar(Ix) <> *Blanks                     CIR005
     C                   EVAL      Idx = Idx + 1                                CIR005
     C                   MOVE      '1'           WSuffix                        CIR005
     C                   CAT(P)    WSuffix:0     FldNamXar(Ix)                  CIR005
     C                   EVAL      FldNameArr(Idx) = FldNamXar(Ix)              CIR005
     C                   EVAL      MsgIdArr(Idx) = MsgIDXar(Ix)                 CIR005
     C                   EVAL      Ix = Ix + 1                                  CIR005
     C                   ENDDO                                                  CIR005
      *                                                                         CIR005
     C                   ENDIF                                                  CIR005

      /COPY WNCPYSRC,IRCIRSV052                                                 CAP004
                                                                                CAP004
     C                   EVAL      PRatChgFq = SUICFR                                         CIR007
                                                                                              CIR007
      ** Use field that is 128 long due to change in IRSBDYPD                                 CIR017
      ** The entry parm for IRVRTCHGDT is the IRSBDYPD layout                                 CIR017
                                                                                              CIR017
     C**********         EVAL      BsDayConv = BsDayLeg1                             CIR017 MD026686
     C                   EVAL      BsDayConv128 = BsDayLeg1                                 MD026686
                                                                                              CIR017
      * No need to call this in authorise mode                                               BUG7325
     C                   If        ACTNCD <> 'X'                                             BUG7325
     C                   CALLB     'IRVRTCHGDT'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    WMsgid1
     C                   PARM                    WMsgid2
     C                   PARM                    WMsgid3                        CIR005
     C                   PARM                    WMsgData                       CIR005
     C                   PARM                    RXUNICD
     C                   PARM                    SUNICD
     C                   PARM                    SUBRTT
     C**********         PARM                    BJRDNB                                       CSC011
     C                   PARM                    WRunday                                      CSC011
     C                   PARM                    RXVDAT
     C                   PARM                    RXMDAT
     C                   PARM                    BQCRFH
     C                   PARM                    BJLCCY
     C                   PARM                    BLCYCD
     C                   PARM                    BJSLCD
     C                   PARM                    SUCUCY
     C                   PARM                    RXUFRFD
     C                   PARM                    SVDatOK
     C                   PARM                    SMDatOK
     C                   PARM                    SuFrFdOK
     C                   PARM                    SuCuCyOK
     C                   PARM                    BJDFIN
     C** Day number passed back from module (needed for Caps/Collars but
     C** not used in this program)
     C                   PARM                    ZDAYX
     C** Average Rate Method (parameter from Caps/Collars input
     C** not used in this program)
     C                   PARM                    SAVRAM
      ** Mode of operation                                                      CIR005
     C                   PARM                    ModeOfOp                       CIR005
      ** Business Day Convention Validation                                     CIR005
     C                   PARM                    WValBDC                        CIR005
      ** Business Day Currencies for Leg 1                                      CIR005
     C**********         PARM                    BsDayLeg1                      CIR005        CIR017
     C**********         PARM                    BsDayConv                           CIR017 MD026686
     C                   PARM                    BsDayConv128                               MD026686
     C                   PARM                    @SUFRFD                                      185057
     C                   PARM                    @SUNICD                                      185057
     C                   PARM                    PRatChgFq                                    CIR007
     C                   PARM      SDTYP         PDealTyp                                     CIR007
     C                   PARM                    CIR007                                       CIR007
     C                   PARM                    PActCode                                     CIR018
     C                   PARM                    POred                                        CIR018

      ** Reset original field for subsequent processing                                       CIR017
     C**********         EVAL      BsDayLeg1 = BsDayConv                             CIR017 MD026686
     C                   EVAL      BsDayLeg1 = BsDayConv128                          CIR017 MD026686
                                                                                              CIR017
     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SUNICD'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF

     C     WMSGID1       IFNE      *BLANK
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'SUNICD'
     C                   EVAL      WMsgIDArr(WIdx) = WMSGID1
     C                   ENDIF

     C     WMSGID2       IFNE      *BLANK
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'SUNICD'
     C                   EVAL      WMsgIDArr(WIdx) = WMSGID2
     C                   ENDIF
      *                                                                         CIR005
     C                   IF        WMSGID3 <> *BLANK                            CIR005
     C                   ADD       1             WIdx                           CIR005
     C                   EVAL      WFldNamArr(WIdx) = 'SUNICD'                  CIR005
     C                   EVAL      WMsgIDArr(WIdx) = WMSGID3                    CIR005
     C                   EVAL      WMsgDtaArr(WIdx) = WMsgData                  CIR005
     C                   ENDIF                                                  CIR005

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    SuNICDOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
                                                                                             BUG7325
     C                   EndIf                                                               BUG7325

      /COPY WNCPYSRC,IRCIRSV053                                                 CAP004
                                                                                CAP004
      *  *------------------------------------*
      *  * Validate Our Rate Change Frequency *  #26
      *  *------------------------------------*
     C                   EXSR      RESETERRS

      /COPY WNCPYSRC,IRCIRSV054                                                 CAP004
                                                                                CAP004
     C                   EVAL      PActnCde = SACCD                                           CIR007
     C                   EVAL      PDealNo = SDLNO                                            CIR007
                                                                                              CIR007
     C                   CALLB     'IRVRTCHGFQ'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    CIR001
     C                   PARM                    SUICFR
     C                   PARM                    SUNICD
     C                   PARM                    PActnCde                                     CIR007
     C                   PARM                    PDealNo                                      CIR007
     C                   PARM      'O'           POTInd                                       CIR007
     C                   PARM      SDTYP         PDealTyp                                     CIR007
     C                   PARM                    CIR007                                       CIR007

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SUICFR'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    SuICFROK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,IRCIRSV055                                                 CAP004
                                                                                CAP004
      *  *-------------------------------------------------*
      *  * Validate Our Rate Change Frequency Day in Month *  #27
      *  *-------------------------------------------------*
     C                   EXSR      RESETERRS

      /COPY WNCPYSRC,IRCIRSV056                                                 CAP004
                                                                                CAP004
     C                   CALLB     'IRVRTCHGDY'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    SUICFR
     C                   PARM                    SUNICD
     C                   PARM                    SUICFD
     C                   PARM                    RXUNICD
     C** Day number passed back from module (needed for Caps/Collars but
     C** not used in this program)
     C                   PARM                    ZDAYX
     C                   PARM                    RXUICFD
     C                   PARM      SDTYP         PDealTyp                                     CIR007
     C                   PARM                    CIR007                                       CIR007

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SUICFD'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    SuICFDOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,IRCIRSV057                                                 CAP004
                                                                                CAP004
      *  *------------------------------*
      *  * Validate Our Short Term Rate *  #28
      *  *------------------------------*
     C                   EXSR      RESETERRS

      /COPY WNCPYSRC,IRCIRSV058                                                 CAP004
                                                                                CAP004
     C                   EVAL      PRatChgFq = SUICFR                                         CIR007
                                                                                              CIR007
     C                   CALLB     'IRVSTERMRT'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    SVDatOK
     C                   PARM                    SuCuCyOK
     C                   PARM                    SuFRFDOK
     C                   PARM                    SuBRTTOK
     C                   PARM                    RXVDAT
     C                   PARM                    BJLCCY
     C                   PARM                    BLCYCD
     C                   PARM                    BQCRFH
     C                   PARM                    BJSLCD
     C**********         PARM                    BJRDNB                                       CSC011
     C                   PARM                    WRunday                                      CSC011
     C                   PARM                    SUEINR
     C                   PARM                    SUBRTT
     C                   PARM                    RXUFRFD
     C                   PARM                    RXUEINR
     C                   PARM                    ModeOfOp                       CIR005
     C                   PARM                    WValBDC                        CIR005
     C                   PARM                    CcyRteLeg1                     CIR005
     C                   PARM                    PRatChgFq                                    CIR007
     C                   PARM      SDTYP         PDealTyp                                     CIR007
     C                   PARM                    CIR007                                       CIR007
     C                   PARM                    SAVRAM                                       222373
      ** Sign of Our Short Term Rate                                                         BUG6472
     C                   PARM                    SUSSGN                                      BUG6472
     C                   PARM                    BNDCSP                                       245692
      ***Transaction*currency******************************************            BUG11457 MD033488
     C**********         PARM                    SUCUCY                            BUG11457 MD033488
     C                   PARM                    RXORED                                     MD051346
     C                   PARM                    SACCD                                      MD051346

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SUEINR'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    SuEInROK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,IRCIRSV059                                                 CAP004
                                                                                CAP004
      *  *------------------------------------*
      *  * Validate Our Interest Payment Date *  #29
      *  *------------------------------------*
     C                   EXSR      RESETERRS

      /COPY WNCPYSRC,IRCIRSV060                                                 CAP004
                                                                                CAP004
     C                   CALLB     'IRVINTPYDT'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    SUNIPD
     C                   PARM                    RXVDAT
     C                   PARM                    RXMDAT
     C                   PARM                    SVDatOK
     C                   PARM                    SMDatOK
     C                   PARM                    RXUNIPD
     C***********        PARM                    BJDFIN                         CIR005
     C                   PARM                    RXUNICD
     C** Average Rate Method (parameter from Caps/Collars input
     C** not used in this program)
     C                   PARM                    SAVRAM
     C                   PARM                    RXUICFD
     C                   PARM                    SUICFR
     C                   PARM                    SUCUCY
     C** Day number passed back from module (needed for Caps/Collars but
     C** not used in this program)
     C                   PARM                    ZDAYX
     C                   PARM                    SuICFrOK
     C                   PARM                    SuNICDOK
     C                   PARM                    SuICFDOK
     C                   PARM                    ModeOfOp                       CIR005
     C                   PARM                    WValBDC                        CIR005
     C                   PARM                    CcyPayLeg1                     CIR005
     C                   PARM                    WMsgId1                        CIR005
     C                   PARM                    WMsgData                       CIR005
     C** General Ledger ICD data accessed in ZFREQB (called from IRVINTPYDT)
     C     SDGELR        PARM                    SDGELR
     C     SDBANK        PARM                    SDBANK                         CIR005

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SUNIPD'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
                                                                                CIR005
     C                   IF        WMsgId1 <> *BLANK                            CIR005
     C                   ADD       1             WIdx                           CIR005
     C                   EVAL      WFldNamArr(WIdx) = 'SUNIPD'                  CIR005
     C                   EVAL      WMsgIDArr(WIdx) = WMsgId1                    CIR005
     C                   EVAL      WMsgDtaArr(WIdx) = WMsgData                  CIR005
     C                   ENDIF                                                  CIR005

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    SuNIPDOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,IRCIRSV061                                                 CAP004
                                                                                CAP004
      *  *-----------------------------------------*
      *  * Validate Our Interest Payment Frequency *  #30
      *  *-----------------------------------------*
     C                   EXSR      RESETERRS

      /COPY WNCPYSRC,IRCIRSV062                                                 CAP004
                                                                                CAP004
     C                   CALLB     'IRVINTPYFQ'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    MSG2
     C                   PARM                    SUIPFR
     C                   PARM                    SUNIPD
     C                   PARM                    CIR001
      * Following parameters relevant to IRS collars, caps and floors only.
     C                   PARM                    SuIPFrOK
     C                   PARM                    SuICFDOK
     C                   PARM                    SAVRAM
     C                   PARM                    SUICFR
     C                   PARM      SDTYP         PDealTyp                                     CIR007
     C                   PARM                    CIR007                                       CIR007

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SUIPFR'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF

     C     MSG2          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SUIPFR'
     C                   EVAL      MsgIDArr(Idx) = MSG2
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    SuIPFrOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,IRCIRSV063                                                 CAP004
                                                                                CAP004
      *  *------------------------------------------------------*
      *  * Validate Our Interest Payment Frequency Day in Month *  #31
      *  *------------------------------------------------------*
     C                   EXSR      RESETERRS

      /COPY WNCPYSRC,IRCIRSV064                                                 CAP004
                                                                                CAP004
     C                   CALLB     'IRVINTPYDY'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    MSG2
     C** Average Rate Method (parameter from Caps/Collars input
     C** not used in this program) blank parameter causes relevant code
     C** to be skipped in IRVINTPYDY.
     C                   PARM                    SAVRAM
     C                   PARM                    SUIPFD
     C                   PARM                    SUIPFR
     C                   PARM                    RXUIPFD
     C                   PARM                    RXUNICD
     C                   PARM                    RXUNIPD
     C                   PARM                    RXUICFD

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SUIPFD'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF

     C     MSG2          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SUIPFD'
     C                   EVAL      MsgIDArr(Idx) = MSG2
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    SuIPFDOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,IRCIRSV065                                                 CAP004
                                                                                CAP004
      *  *-------------------------*
      *  * Validate Their Amount   *  #32
      *  *-------------------------*
     C                   EXSR      RESETERRS

      /COPY WNCPYSRC,IRCIRSV066                                                 CAP004
                                                                                CAP004
     C                   CALLB     'MMVAMOUNT'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    STPAMT
     C                   PARM                    StCucyOK
     C                   PARM                    ThrCcyDecP
     C                   PARM                    SDTYP
     C                   PARM                    Amount15
      ** Currency separator (1A, from SDDEALPD, via caller)
     C                   PARM                    BNDCSP
     C                   PARM                    PActnCde                                   AR569568
     C                   PARM                    CDL006                                     AR569568

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'STPAMT'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ELSE
      ** Set up output field in 13,0 format
     C                   Z-ADD     Amount15      RXTPAMT
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    StPAmtOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,IRCIRSV067                                                 CAP004
                                                                                CAP004
      *  *----------------------------------------*
      *  * Validate Their Federal funds indicator *  #33
      *  *----------------------------------------*
     C                   EXSR      RESETERRS
      /COPY WNCPYSRC,IRCIRSV068                                                 CAP004
                                                                                CAP004
     C                   CALLB     'MMVFEDFUND'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
      ** Federal funds indicator
     C                   PARM                    STFFI
      ** Currency code
     C                   PARM                    STCUCY
      ** US Currency code
     C                   PARM                    BLUSCY

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'STFFI'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    StFFIOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,IRCIRSV069                                                 CAP004
                                                                                CAP004
      *  *--------------------------------------------*
      *  * Validate Their Base Currency Exchange Rate *  #34
      *  *--------------------------------------------*
      *                                                                                       187606
      * Should be validated in Insert only.                                                   187606
      *                                                                                       187606
     C     ACTNCD        IFEQ      'I'                                                        187606
     C     ACTNCD        OREQ      'A'                                                        221963
     C     RXORED        ANDEQ     BJRDNB                                                     221963
     C     ACTNCD        OREQ      'A'                                                        221963
     C     RXORED        ANDNE     BJRDNB                                                     221963
     C     STBCXR        ANDNE     @STBCXR                                                    221963
      *                                                                                       187606
     C                   EXSR      RESETERRS

      /COPY WNCPYSRC,IRCIRSV070                                                 CAP004
                                                                                CAP004
     C                   CALLB     'IRVBCURRAT'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    STBCXR
     C                   PARM                    ThrCcySpot
     **Constants passed in by calling programme.
     C                   PARM                    STCUCY
     C                   PARM                    BJCYCD
     C                   PARM                    RXTBCXR
     C                   PARM                    BNDCSP                                       245692

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'STBCXR'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    StBCXROK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
      *                                                                                       187606
     C                   ENDIF                                                                187606

      /COPY WNCPYSRC,IRCIRSV071                                                 CAP004
                                                                                CAP004
      *  *------------------------------------------------------------*
      *  * Validate Base Ccy Equivalents are within 10% of each other * #35
      *  *------------------------------------------------------------*
      *                                                                                       187606
      * Should be validated in Insert only.                                                   187606
      *                                                                                       187606
     C     ACTNCD        IFEQ      'I'                                                        187606
      *                                                                                       187606
     C                   EXSR      RESETERRS

      /COPY WNCPYSRC,IRCIRSV072                                                 CAP004
                                                                                CAP004
     C                   CALLB     'IRVCURAMT'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    SuCuCyOK
     C                   PARM                    SuPAmtOK
     C                   PARM                    SuBCXROK
     C                   PARM                    StCuCyOK
     C                   PARM                    StPAmtOK
     C                   PARM                    StBCXROK
     C                   PARM                    BJCYCD
     C                   PARM                    SUCUCY
     C                   PARM                    STCUCY
     C                   PARM                    SUBCXR
     C                   PARM                    STBCXR
     C                   PARM                    RXUBCXR
     C                   PARM                    RXTBCXR
     C                   PARM                    RXUPAMT
     C                   PARM                    RXTPAMT

      *                                                                                       215904
      ** A warning message will be issued instead of an error message                         215904
      *                                                                                       215904
     C     MSG1          IFNE      *BLANK
     C**********         ADD       1             Idx                                          215904
     C**********         EVAL      FldNameArr(Idx) = 'SUBCXR'                                 215904
     C**********         EVAL      MsgIDArr(Idx) = MSG1                                       215904
     C                   ADD       1             WIdx                                         215904
     C                   EVAL      WFldNamArr(WIdx) = 'SUBCXR'                                215904
     C                   EVAL      WMsgIDArr(WIdx) = MSG1                                     215904
     C**********         ADD       1             Idx                                          215904
     C**********         EVAL      FldNameArr(Idx) = 'STBCXR'                                 215904
     C**********         EVAL      MsgIDArr(Idx) = MSG1                                       215904
     C                   ADD       1             WIdx                                         215904
     C                   EVAL      WFldNamArr(WIdx) = 'STBCXR'                                215904
     C                   EVAL      WMsgIDArr(WIdx) = MSG1                                     215904
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    SBCcyEqOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
      *                                                                                       187606
     C                   ENDIF                                                                187606

      /COPY WNCPYSRC,IRCIRSV073                                                 CAP004
                                                                                CAP004
      *  *--------------------------------------------*
      *  * Validate Their Interest Calculation Basis  *  #36
      *  *--------------------------------------------*
     C                   EXSR      RESETERRS

      /COPY WNCPYSRC,IRCIRSV074                                                 CAP004
                                                                                CAP004
     C                   CALLB     'IRVIRSINTC'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    CIR001
     C                   PARM                    STIPFR
     C                   PARM                    STICBS

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'STICBS'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    StICBsOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,IRCIRSV075                                                 CAP004
                                                                                CAP004
      ** If CAS001 is on, validate yield curve                                                CAS001
                                                                                              CAS001
     C                   IF        CAS001 = 'Y' AND                                           CAS001
     C                             SDlstOK <> 'N' AND                                         CDL038
     C                             SCLasOK <> 'N'                                             CDL038
     C*****************************SDlstOK <> 'N'                                      CAS001 CDL038
                                                                                              CAS005
      ** If CAS005 is installed, populate new parameter fields with values                    CAS005
                                                                                              CAS005
     C                   IF        CAS005 = 'Y'                                               CAS005
     C                   EVAL      PFwRv = 'R'                                                CAS005
     C                   EVAL      PFwYC = STFYC                                              CAS005
     C                   ELSE                                                                 CAS005
     C                   EVAL      PFwRv = *BLANKS                                            CAS005
     C                   EVAL      PFwYC = *BLANKS                                            CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS001
      *  *----------------------------*                                                       CAS001
      *  * Validate Their Yield Curve *                                                       CAS001
      *  *----------------------------*                                                       CAS001
                                                                                              CAS001
     C                   EXSR      RESETERRS                                                  CAS001
                                                                                              CAS001
     C                   CALLB     'ZAVYLDC01'                                                CAS001
     C                   PARM                    ReturnCode                                   CAS001
     C                   PARM                    SDTYP                                        CAS001
     C                   PARM                    SDLST                                        CAS001
     C                   PARM                    SCLAS                                        CDL038
     C                   PARM                    STYLC                                        CAS001
     C                   PARM      'DDTYLC'      PYcFn                                        CAS001
     C                   PARM      'R'           PFwRv                                        CAS005
     C                   PARM                    PFwYC                                        CAS005
     C                   PARM      *BLANKS       PFCRv                                        CAS008
     C                   PARM      'Y'           OKTYLC                                       CAS001
      ** Error Type                                                                           CAS001
     C                   PARM      *BLANKS       PErTp                                        CAS001
      ** Yield Curve                                                                          CAS001
     C                   PARM      *BLANKS       RXTYLC                                       CAS001
                                                                                              CAS001
     C**********         IF        ReturnCode = *BLANK                                 CAS001 226002
     C**********         CLEAR                   WkYLDC                                CAS001 226002
     C**********         EVAL      WkYLDC = RXTYLC                                     CAS001 226002
     C**********         EXSR      SrAccesYldC                                         CAS001 226002
     C**********         ENDIF                                                         CAS001 226002
                                                                                              CAS001
     C                   IF        ReturnCode <> *BLANK                                       CAS001
     C                   EVAL      Idx = Idx + 1                                              CAS001
     C                   EVAL      FldNameArr(Idx) = 'STYLC'                                  CAS001
                                                                                              CAS001
     C                   SELECT                                                               CAS001
     C                   WHEN      PERTP = '1'                                                CAS001
     C                   EVAL      MsgIDArr(Idx) = 'FXM5056'                                  CAS001
     C**********         WHEN      PERTP = '3'                                         CAS001 226002
     C**********         EVAL      MsgIDArr(Idx) = 'FXM5059'                           CAS001 226002
     C                   WHEN      PERTP = '4'                                                CAS005
     C                   EVAL      MsgIDArr(Idx) = 'RS00062'                                  CAS005
     C                   OTHER                                                                CAS001
     C                   EVAL      MsgIDArr(Idx) = 'FXM5058'                                  CAS001
     C                   ENDSL                                                                CAS001
                                                                                              CAS001
     C                   ENDIF                                                                CAS001
                                                                                              CAS001
      ** Use the return code's value to set the field's OK flag                               CAS001
                                                                                              CAS001
     C                   CALLB     'ZASETOKFLG'                                               CAS001
     C                   PARM                    OKTYLC                                       CAS001
     C                   PARM                    ReturnCode                                   CAS001
     C                   PARM                    WarnGlobal                                   CAS001
                                                                                              CAS005
      ** If CAS005 is on, validate forward yield curve                                        CAS005
                                                                                              CAS005
     C                   IF        CAS005 = 'Y'                                               CAS005
                                                                                              CAS005
      *  *-----------------------------------*                                                CAS005
      *  * Validate Their Forward Yield Curve*                                                CAS005
      *  *----------------------------------**                                                CAS005
                                                                                              CAS005
     C                   EXSR      RESETERRS                                                  CAS005
                                                                                              CAS005
      ** Save initial screen value of forward yield curve                                     CAS005
                                                                                              CAS005
     C                   EVAL      WkSTFYC = STFYC                                            CAS005
                                                                                              CAS005
     C                   CALLB     'ZAVYLDC01'                                                CAS005
     C                   PARM                    ReturnCode                                   CAS005
     C                   PARM                    SDTYP                                        CAS005
     C                   PARM                    SDLST                                        CAS005
     C                   PARM                    SCLAS                                        CDL038
     C                   PARM                    STFYC                                        CAS005
     C                   PARM      'DDTFYC'      PYcFn                                        CAS005
     C                   PARM      'F'           PFwRv                                        CAS005
     C                   PARM      *BLANKS       PFwYC                                        CAS005
     C                   PARM      *BLANKS       PFCRv                                        CAS008
     C                   PARM      'Y'           OKTFYC                                       CAS005
      ** Error Type                                                                           CAS005
     C                   PARM      *BLANKS       PErTp                                        CAS005
      ** Forward Yield Curve                                                                  CAS005
     C                   PARM      *BLANKS       RXTFYC                                       CAS005
                                                                                              CAS005
      ** Prevent defaulting if the leg is not attached to a base rate                         CAS005
                                                                                              CAS005
     C**********         IF        STBRTT = *BLANKS OR STBRTT = '00'                   CAS005 CSD103
     C                   IF        STBRTT = *BLANKS                                           CSD103
     C                   IF        WkSTFYC = *BLANKS                                          CAS005
     C                   EVAL      STFYC = *BLANKS                                            CAS005
     C                   EVAL      RXTFYC = *BLANKS                                           225997
     C                   EVAL      ReturnCode = *BLANKS                                       CAS005
     C                   EVAL      PERTP = *BLANKS                                            CAS005
     C                   EVAL      OKTFYC = 'Y'                                               CAS005
     C                   ENDIF                                                                CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   IF        ReturnCode <> *BLANK                                       CAS005
     C                   EVAL      Idx = Idx + 1                                              CAS005
     C                   EVAL      FldNameArr(Idx) = 'STFYC'                                  CAS005
                                                                                              CAS005
     C                   SELECT                                                               CAS005
     C                   WHEN      PERTP = '1'                                                CAS005
     C                   EVAL      MsgIDArr(Idx) = 'RS00064'                                  CAS005
     C                   OTHER                                                                CAS005
     C                   EVAL      MsgIDArr(Idx) = 'RS00066'                                  CAS005
     C                   ENDSL                                                                CAS005
      *                                                                                       CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
      ** If the leg is not attached to a base rate, forward yield curve must                  CAS005
      ** not be populated                                                                     CAS005
                                                                                              CAS005
     C**********         IF        (STBRTT = *BLANKS OR STBRTT = '00') AND             CAS005 CSD103
     C                   IF        STBRTT = *BLANKS AND                                       CSD103
     C                             STFYC <> *BLANKS                                           CAS005
     C                   EVAL      ReturnCode = 'Error'                                       CAS005
     C                   EVAL      Idx = Idx + 1                                              CAS005
     C                   EVAL      FldNameArr(Idx) = 'STFYC'                                  CAS005
     C                   EVAL      MsgIDArr(Idx) = 'RS00068'                                  CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
      ** If Forward yield curve is entered, revaluation yield curve is mandatory              CAS005
                                                                                              CAS005
     C                   IF        STYLC = *BLANKS AND STFYC <> *BLANKS                       CAS005
     C                   EVAL      ReturnCode = 'Error'                                       CAS005
     C                   EVAL      Idx = Idx + 1                                              CAS005
     C                   EVAL      FldNameArr(Idx) = 'STFYC'                                  CAS005
     C                   EVAL      MsgIDArr(Idx) = 'RS00062'                                  CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
      ** Use the return code's value to set the field's OK flag                               CAS005
                                                                                              CAS005
     C                   CALLB     'ZASETOKFLG'                                               CAS005
     C                   PARM                    OKTFYC                                       CAS005
     C                   PARM                    ReturnCode                                   CAS005
     C                   PARM                    WarnGlobal                                   CAS005
                                                                                              CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS001
     C                   IF        CAS008 = 'Y' AND                                           CAS008
     C                             CIR003 = 'Y'                                               CAS008
                                                                                              CAS008
      *  *-----------------------------------------------*                                    CAS008
      *  * Validate Their Forward Commitment Yield Curve *                                    CAS008
      *  *-----------------------------------------------*                                    CAS008
                                                                                              CAS008
     C                   EXSR      RESETERRS                                                  CAS008
                                                                                              CAS008
     C                   CALLB     'ZAVYLDC01'                                                CAS008
     C                   PARM                    ReturnCode                                   CAS008
     C                   PARM                    SDTYP                                        CAS008
     C                   PARM                    SDLST                                        CAS008
     C                   PARM                    SCLAS                                        CDL038
     C                   PARM                    STFCC                                        CAS008
     C                   PARM      'DDTFCC'      PYcFn                                        CAS008
     C                   PARM      *BLANKS       PFwRv                                        CAS008
     C                   PARM      *BLANKS       PFwYC                                        CAS008
     C                   PARM      'C'           PFCRv                                        CAS008
     C                   PARM      'Y'           OKTFCC                                       CAS008
                                                                                              CAS008
      ** Error Type                                                                           CAS008
      ** Forward Cmt Yield Curve                                                              CAS008
                                                                                              CAS008
     C                   PARM      *BLANKS       PErTp                                        CAS008
     C                   PARM      *BLANKS       RXTFCC                                       CAS008
                                                                                              CAS008
     C                   IF        ReturnCode <> *BLANK                                       CAS008
     C                   EVAL      Idx = Idx + 1                                              CAS008
     C                   EVAL      FldNameArr(Idx) = 'STFCC'                                  CAS008
                                                                                              CAS008
     C                   SELECT                                                               CAS008
     C                   WHEN      PERTP = '1'                                                CAS008
     C                   EVAL      MsgIDArr(Idx) = 'RS00071'                                  CAS008
     C                   OTHER                                                                CAS008
     C                   EVAL      MsgIDArr(Idx) = 'RS00072'                                  CAS008
     C                   ENDSL                                                                CAS008
                                                                                              CAS008
     C                   ENDIF                                                                CAS008
                                                                                              CAS008
      ** If Forward Commitment yield curve is entered, revaluation yield curve                CAS008
      ** is mandatory.                                                                        CAS008
                                                                                              CAS008
     C                   IF        STYLC = *BLANKS AND STFCC <> *BLANKS                       CAS008
     C                   EVAL      ReturnCode = 'Error'                                       CAS008
     C                   EVAL      Idx = Idx + 1                                              CAS008
     C                   EVAL      FldNameArr(Idx) = 'STFCC'                                  CAS008
     C                   EVAL      MsgIDArr(Idx) = 'RS00074'                                  CAS008
     C                   EVAL      OKTYLC = 'N'                                               CAS008
     C                   ENDIF                                                                CAS008
                                                                                              CAS008
      ** Use the return code's value to set the field's OK flag                               CAS008
                                                                                              CAS008
     C                   CALLB     'ZASETOKFLG'                                               CAS008
     C                   PARM                    OKTFCC                                       CAS008
     C                   PARM                    ReturnCode                                   CAS008
     C                   PARM                    WarnGlobal                                   CAS008
                                                                                              CAS008
     C                   ENDIF                                                                CAS008
                                                                                              CAS008
     C                   ENDIF                                                                CAS001
                                                                                              CAS001
      *  *--------------------------------*
      *  * Validate their Base Rate Code  *  #37
      *  *--------------------------------*
     C                   EXSR      RESETERRS

      /COPY WNCPYSRC,IRCIRSV076                                                 CAP004
                                                                                CAP004
     C                   EVAL      PRatChgFq = STICFR                                         CIR007
                                                                                              CIR007
     C                   CALLB     'IRVBRATCDE'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    MSG2
     C                   PARM                    STBRTT
     C                   PARM                    StCuCyOK
     C                   PARM                    STCUCY
     C                   PARM                    CIR001
     C                   PARM                    STIPFR
     C                   PARM                    PRatChgFq                                    CIR007
     C                   PARM      SDTYP         PDealTyp                                     CIR007
     C                   PARM                    CIR007                                       CIR007

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'STBRTT'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF

     C     MSG2          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'STBRTT'
     C                   EVAL      MsgIDArr(Idx) = MSG2
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    StBrttOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,IRCIRSV077                                                 CAP004
                                                                                CAP004
      *  *--------------------------------*
      *  * Validate their Spread Rate     *  #38
      *  *--------------------------------*
     C                   EXSR      RESETERRS

      /COPY WNCPYSRC,IRCIRSV078                                                 CAP004
                                                                                CAP004
     C                   CALLB     'IRVSPRRATE'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    STRTSP
     C                   PARM                    CIR001
     C                   PARM                    STIPFR
     C                   PARM                    STBRTT
     C                   PARM      SDTYP         PDealTyp                                     CAP055
     C                   PARM                    RXTRTSP
     C                   PARM                    BNDCSP                                       245692

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'STRTSP'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    StRtSpOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,IRCIRSV079                                                 CAP004
                                                                                CAP004
      *  *---------------------------------*
      *  * Validate their Spread Indicator *  #39
      *  *---------------------------------*
     C                   EXSR      RESETERRS

      /COPY WNCPYSRC,IRCIRSV080                                                 CAP004
                                                                                CAP004
     C                   CALLB     'IRVSPRDIND'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    STSPIN
     C                   PARM                    STRTSP
     C                   PARM                    STBRTT

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'STSPIN'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    StSpInOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,IRCIRSV081                                                 CAP004
                                                                                CAP004
      *  *------------------------------*
      *  * Validate their Rate Fix Days *  #40
      *  *------------------------------*
     C                   EXSR      RESETERRS

      /COPY WNCPYSRC,IRCIRSV082                                                 CAP004
                                                                                CAP004
     C                   EVAL      PRatChgFq = STICFR                                         CIR007
                                                                                              CIR007
     C                   CALLB     'IRVRTFXDAY'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    STFRFD
     C                   PARM                    STBRTT
     C                   PARM                    STCUCY
     C                   PARM                    BLCYCD
     C                   PARM                    BJLCCY
     C                   PARM                    RXTFRFD
     C                   PARM                    PRatChgFq                                    CIR007
     C                   PARM      SDTYP         PDealTyp                                     CIR007
     C                   PARM                    CIR007                                       CIR007
     C                   PARM                    SAVRAM                                       CAP055

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'STFRFD'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    StFRFDOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,IRCIRSV083                                                 CAP004
                                                                                CAP004
      *  *---------------------------------*
      *  * Validate their Rate Change Date *  #41
      *  *---------------------------------*
     C                   EXSR      RESETERRS
      *                                                                         CIR005
      ** If Business Day Convention is on and called from CTL,                  CIR005
      ** validate business day convention fields.                               CIR005
     C                   IF        CIR005 = 'Y'                                 CIR005
     C**********                   and ModeOfOp = '*FRONT'                      CIR005       BUG5291
     C                             and ModeOfOp = '*FRONT' Or                                BUG5291
     C                             CIR005 = 'Y' and                                          BUG5291
     C                             ModeOfOp <> '*SIN'                                        BUG5291
      *                                                                         CIR005
      ** Validate Currencies for Rate Fixing Convention - Leg 2                 CIR005
     C                   CALLB     'IRVBDYCCY'                                  CIR005
     C                   PARM      *Blanks       RetCodeOut                     CIR005
     C                   PARM      'B'           PCode                          CIR005
     C                   Parm                    PLCcy             3            CIR005
     C                   PARM      CcyRteLeg2    Pccy1                          CIR005
     C                   PARM      CcyPayLeg2    Pccy2                          CIR005
     C                   PARM                    OkFlgRte2                      CIR005
     C                   PARM                    OKFlgPay2                      CIR005
     C                   PARM      *Blanks       MsgIdXar                       CIR005
     C                   PARM      *Blanks       FldNamXar                      CIR005
     C                   PARM      *Blanks       WMsgIdXar                      CIR005
     C                   PARM      *Blanks       WFldNamXar                     CIR005
      *                                                                         CIR005
     C                   EVAL      Ix = 1                                       CIR005
     C                   DOW       FldNamXar(Ix) <> *Blanks                     CIR005
     C                   EVAL      Idx = Idx + 1                                CIR005
     C                   MOVE      '2'           WSuffix                        CIR005
     C                   CAT(P)    WSuffix:0     FldNamXar(Ix)                  CIR005
     C                   EVAL      FldNameArr(Idx) = FldNamXar(Ix)              CIR005
     C                   EVAL      MsgIdArr(Idx) = MsgIDXar(Ix)                 CIR005
     C                   EVAL      Ix = Ix + 1                                  CIR005
     C                   ENDDO                                                  CIR005
      *                                                                         CIR005
      ** Validate Payment Date and Amount Codes - Leg 2                         CIR005
     C                   CALLB     'IRVPAMCNV'                                  CIR005
     C                   PARM      *Blanks       RetCodeOut                     CIR005
     C                   PARM                    SPDC2                          CIR005
     C                   PARM                    SAMC2                          CIR005
     C                   PARM                    OkPayDat2                      CIR005
     C                   PARM                    OKAmtCde2                      CIR005
     C                   PARM      *Blanks       MsgIdXar                       CIR005
     C                   PARM      *Blanks       FldNamXar                      CIR005
      *                                                                         CIR005
     C                   EVAL      Ix = 1                                       CIR005
     C                   DOW       FldNamXar(Ix) <> *Blanks                     CIR005
     C                   EVAL      Idx = Idx + 1                                CIR005
     C                   MOVE      '2'           WSuffix                        CIR005
     C                   CAT(P)    WSuffix:0     FldNamXar(Ix)                  CIR005
     C                   EVAL      FldNameArr(Idx) = FldNamXar(Ix)              CIR005
     C                   EVAL      MsgIdArr(Idx) = MsgIDXar(Ix)                 CIR005
     C                   EVAL      Ix = Ix + 1                                  CIR005
     C                   ENDDO                                                  CIR005
      *                                                                         CIR005
     C                   ENDIF                                                  CIR005

      /COPY WNCPYSRC,IRCIRSV084                                                 CAP004
                                                                                CAP004
     C                   EVAL      PRatChgFq = STICFR                                         CIR007
                                                                                              CIR007
      ** Use field that is 128 long due to change in IRSBDYPD                                 CIR017
      ** The entry parm for IRVRTCHGDT is the IRSBDYPD layout                                 CIR017
      **                                                                                      CIR017
     C**********         EVAL      BsDayConv = BsDayLeg2                                      CIR017
     C                   EVAL      BsDayConv128 = BsDayLeg2                                   CIR017
                                                                                              CIR017
      * No need to call this in authorise mode                                               BUG7325
     C                   If        ACTNCD <> 'X'                                             BUG7325
     C                   CALLB     'IRVRTCHGDT'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    WMsgid1
     C                   PARM                    WMsgid2
     C                   PARM                    WMsgid3                        CIR005
     C                   PARM                    WMsgData                       CIR005
     C                   PARM                    RXTNICD
     C                   PARM                    STNICD
     C                   PARM                    STBRTT
     C**********         PARM                    BJRDNB                                       CSC011
     C                   PARM                    WRunday                                      CSC011
     C                   PARM                    RXVDAT
     C                   PARM                    RXMDAT
     C                   PARM                    BQCRFH
     C                   PARM                    BJLCCY
     C                   PARM                    BLCYCD
     C                   PARM                    BJSLCD
     C                   PARM                    STCUCY
     C                   PARM                    RXTFRFD
     C                   PARM                    SVDatOK
     C                   PARM                    SMDatOK
     C                   PARM                    StFrFdOK
     C                   PARM                    StCuCyOK
     C                   PARM                    BJDFIN
     C** Day number passed back from module (needed for Caps/Collars but
     C** not used in this program)
     C                   PARM                    ZDAYX
     C** Average Rate Method (parameter from Caps/Collars input
     C** not used in this program)
     C                   PARM                    SAVRAM
      ** Mode of operation                                                      CIR005
     C                   PARM                    ModeOfOp                       CIR005
      ** Business Day Convention Validation                                     CIR005
     C                   PARM                    WValBDC                        CIR005
      ** Business Day Currencies for Leg 2                                      CIR005
     C**********         PARM                    BsDayLeg2                      CIR005        CIR017
     C**********         PARM                    BSDayConv                                    CIR017
     C                   PARM                    BSDayConv128                                 CIR017
     C                   PARM                    @STFRFD                                      185057
     C                   PARM                    @STNICD                                      185057
     C                   PARM                    PRatChgFq                                    CIR007
     C                   PARM      SDTYP         PDealTyp                                     CIR007
     C                   PARM                    CIR007                                       CIR007
     C                   PARM                    PActCode                                     CIR018
     C                   PARM                    POred                                        CIR018

      ** Reset original field for subsequent processing                                       CIR017
     C**********         EVAL      BsDayLeg2 = BsDayConv                             CIR017 MD026686
     C                   EVAL      BsDayLeg2 = BSDayConv128                                 MD026686
                                                                                              CIR017
     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'STNICD'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF

     C     WMSGID1       IFNE      *BLANK
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'STNICD'
     C                   EVAL      WMsgIDArr(WIdx) = WMSGID1
     C                   ENDIF

     C     WMSGID2       IFNE      *BLANK
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'STNICD'
     C                   EVAL      WMsgIDArr(WIdx) = WMSGID2
     C                   ENDIF
      *                                                                         CIR005
     C                   IF        WMsgID3 <> *BLANK                            CIR005
     C                   ADD       1             WIdx                           CIR005
     C                   EVAL      WFldNamArr(WIdx) = 'STNICD'                  CIR005
     C                   EVAL      WMsgIDArr(WIdx) = WMSGID3                    CIR005
     C                   EVAL      WMsgDtaArr(WIdx) = WMsgData                  CIR005
     C                   ENDIF                                                  CIR005

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    StNICDOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
                                                                                             BUG7325
     C                   EndIf                                                               BUG7325

      /COPY WNCPYSRC,IRCIRSV085                                                 CAP004
                                                                                CAP004
      *  *--------------------------------------*
      *  * Validate their Rate Change Frequency *  #42
      *  *--------------------------------------*
     C                   EXSR      RESETERRS

      /COPY WNCPYSRC,IRCIRSV086                                                 CAP004
                                                                                CAP004
     C                   EVAL      PActnCde = SACCD                                           CIR007
     C                   EVAL      PDealNo = SDLNO                                            CIR007
                                                                                              CIR007
     C                   CALLB     'IRVRTCHGFQ'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    CIR001
     C                   PARM                    STICFR
     C                   PARM                    STNICD
     C                   PARM                    PActnCde                                     CIR007
     C                   PARM                    PDealNo                                      CIR007
     C                   PARM      'T'           POTInd                                       CIR007
     C                   PARM      SDTYP         PDealTyp                                     CIR007
     C                   PARM                    CIR007                                       CIR007

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'STICFR'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    StICFROK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,IRCIRSV087                                                 CAP004
                                                                                CAP004
      *  *---------------------------------------------------*
      *  * Validate their Rate Change Frequency Day in Month *  #43
      *  *---------------------------------------------------*
     C                   EXSR      RESETERRS

      /COPY WNCPYSRC,IRCIRSV088                                                 CAP004
                                                                                CAP004
     C                   CALLB     'IRVRTCHGDY'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    STICFR
     C                   PARM                    STNICD
     C                   PARM                    STICFD
     C                   PARM                    RXTNICD
     C** Day number passed back from module (needed for Caps/Collars but
     C** not used in this program)
     C                   PARM                    ZDAYX
     C                   PARM                    RXTICFD
     C                   PARM      SDTYP         PDealTyp                                     CIR007
     C                   PARM                    CIR007                                       CIR007

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'STICFD'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    StICFDOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,IRCIRSV089                                                 CAP004
                                                                                CAP004
      *  *--------------------------------*
      *  * Validate their Short Term Rate *  #44
      *  *--------------------------------*
     C                   EXSR      RESETERRS

      /COPY WNCPYSRC,IRCIRSV090                                                 CAP004
                                                                                CAP004
     C                   EVAL      PRatChgFq = STICFR                                         CIR007
                                                                                              CIR007
     C                   CALLB     'IRVSTERMRT'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    SVDatOK
     C                   PARM                    StCuCyOK
     C                   PARM                    StFRFDOK
     C                   PARM                    StBRTTOK
     C                   PARM                    RXVDAT
     C                   PARM                    BJLCCY
     C                   PARM                    BLCYCD
     C                   PARM                    BQCRFH
     C                   PARM                    BJSLCD
     C**********         PARM                    BJRDNB                                       CSC011
     C                   PARM                    WRunday                                      CSC011
     C                   PARM                    STEINR
     C                   PARM                    STBRTT
     C                   PARM                    RXTFRFD
     C                   PARM                    RXTEINR
     C                   PARM                    ModeOfOp                       CIR005
     C                   PARM                    WValBDC                        CIR005
     C                   PARM                    CcyRteLeg2                     CIR005
     C                   PARM                    PRatChgFq                                    CIR007
     C                   PARM      SDTYP         PDealTyp                                     CIR007
     C                   PARM                    CIR007                                       CIR007
     C                   PARM                    SAVRAM                                       222373
      ** Sign of Their Short Term Rate                                                       BUG6472
     C                   PARM                    STSSGN                                      BUG6472
     C                   PARM                    BNDCSP                                       245692
      ***Transaction*currency******************************************            BUG11457 MD033488
     C**********         PARM                    STCUCY                            BUG11457 MD033488
     C                   PARM                    RXORED                                     MD051346
     C                   PARM                    SACCD                                      MD051346

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'STEINR'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    StEInROK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,IRCIRSV091                                                 CAP004
                                                                                CAP004
      *  *--------------------------------------*
      *  * Validate their Interest Payment Date *  #45
      *  *--------------------------------------*
     C                   EXSR      RESETERRS

      /COPY WNCPYSRC,IRCIRSV092                                                 CAP004
                                                                                CAP004
     C                   CALLB     'IRVINTPYDT'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    STNIPD
     C                   PARM                    RXVDAT
     C                   PARM                    RXMDAT
     C                   PARM                    SVDatOK
     C                   PARM                    SMDatOK
     C                   PARM                    RXTNIPD
     C***********        PARM                    BJDFIN                         CIR005
     C                   PARM                    RXTNICD
     C** Average Rate Method (parameter from Caps/Collars input
     C** not used in this program)
     C                   PARM                    SAVRAM
     C                   PARM                    RXTICFD
     C                   PARM                    STICFR
     C                   PARM                    STCUCY
     C** Day number passed back from module (needed for Caps/Collars but
     C** not used in this program)
     C                   PARM                    ZDAYX
     C                   PARM                    StICFrOK
     C                   PARM                    StNICDOK
     C                   PARM                    StICFDOK
     C                   PARM                    ModeOfOp                       CIR005
     C                   PARM                    WValBDC                        CIR005
     C                   PARM                    CcyPayLeg2                     CIR005
     C                   PARM                    WMsgId1                        CIR005
     C                   PARM                    WMsgData                       CIR005
     C** General Ledger ICD data accessed in ZFREQB (called from IRVINTPYDT)
     C     SDGELR        PARM                    SDGELR
     C     SDBANK        PARM                    SDBANK                         CIR005

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'STNIPD'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
                                                                                CIR005
     C                   IF        WMsgId1 <> *BLANK                            CIR005
     C                   ADD       1             WIdx                           CIR005
     C                   EVAL      WFldNamArr(WIdx) = 'STNIPD'                  CIR005
     C                   EVAL      WMsgIDArr(WIdx) = WMsgId1                    CIR005
     C                   EVAL      WMsgDtaArr(WIdx) = WMsgData                  CIR005
     C                   ENDIF                                                  CIR005

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    StNIPDOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,IRCIRSV093                                                 CAP004
                                                                                CAP004
      *  *-------------------------------------------*
      *  * Validate their Interest Payment Frequency *  #46
      *  *-------------------------------------------*
     C                   EXSR      RESETERRS

      /COPY WNCPYSRC,IRCIRSV094                                                 CAP004
                                                                                CAP004
     C                   CALLB     'IRVINTPYFQ'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    MSG2
     C                   PARM                    STIPFR
     C                   PARM                    STNIPD
     C                   PARM                    CIR001
      * Following parameters relevant to IRS collars, caps and floors only.
     C                   PARM                    StIPFrOK
     C                   PARM                    StICFDOK
     C                   PARM                    SAVRAM
     C                   PARM                    STICFR
     C                   PARM      SDTYP         PDealTyp                                     CIR007
     C                   PARM                    CIR007                                       CIR007

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'STIPFR'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF

     C     MSG2          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'STIPFR'
     C                   EVAL      MsgIDArr(Idx) = MSG2
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    StIPFrOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,IRCIRSV095                                                 CAP004
                                                                                CAP004
      *  *--------------------------------------------------------*
      *  * Validate their Interest Payment Frequency Day in Month *  #47
      *  *--------------------------------------------------------*
     C                   EXSR      RESETERRS

      /COPY WNCPYSRC,IRCIRSV096                                                 CAP004
                                                                                CAP004
     C                   CALLB     'IRVINTPYDY'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    MSG2
     C** Average Rate Method (parameter from Caps/Collars input
     C** not used in this program) blank parameter causes relevant code
     C** to be skipped in IRVINTPYDY.
     C                   PARM                    SAVRAM
     C                   PARM                    STIPFD
     C                   PARM                    STIPFR
     C                   PARM                    RXTIPFD
     C                   PARM                    RXTNICD
     C                   PARM                    RXTNIPD
     C                   PARM                    RXTICFD

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'STIPFD'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF

     C     MSG2          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'STIPFD'
     C                   EVAL      MsgIDArr(Idx) = MSG2
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    StIPFDOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,IRCIRSV097                                                 CAP004
                                                                                CAP004
      *  *-----------------------------------------*                            CSW097
      *  * Validate Collateral Agreement Indicator *  #48                       CSW097
      *  *-----------------------------------------*                            CSW097
     C                   EXSR      RESETERRS                                    CSW097
                                                                                CSW097
      /COPY WNCPYSRC,IRCIRSV103                                                 CSW097
                                                                                CSW097
     C                   CALLB     'IRVCOLAGRE'                                 CSW097
     C                   PARM                    ReturnCode                     CSW097
     C                   PARM                    MSG1                           CSW097
     C                   PARM                    SCAIN                          CSW097
                                                                                CSW097
     C     MSG1          IFNE      *BLANK                                       CSW097
     C                   ADD       1             Idx                            CSW097
     C                   EVAL      FldNameArr(Idx) = 'SCAIN'                    CSW097
     C                   EVAL      MsgIDArr(Idx) = MSG1                         CSW097
     C                   ENDIF                                                  CSW097
                                                                                CSW097
      ** Use the return code's value to set the field's OK flag                 CSW097
     C                   CALLB     'ZASETOKFLG'                                 CSW097
     C                   PARM                    SCAInOK                        CSW097
     C                   PARM                    ReturnCode                     CSW097
     C                   PARM                    WarnGlobal                     CSW097
                                                                                CSW097
      /COPY WNCPYSRC,IRCIRSV104                                                 CSW097
                                                                                CSW097
      ** Validate CDL028 fields                                                               CDL028
     C                   IF        CDL028 = 'Y'                                               CDL028
                                                                                              CDL028
      *  *-----------------------------------------*                                          CDL028
      *  * Validate Our Start Date                 *  #49                                     CDL028
      *  *-----------------------------------------*                                          CDL028
     C                   EXSR      RESETERRS                                                  CDL028
                                                                                              CDL028
     C                   CALLB     'IRVSTUBDTE'                                               CDL028
     C                   PARM                    ReturnCode                                   CDL028
     C                   PARM                    MSG1                                         CDL028
     C                   PARM                    BJDFIN                                       CDL028
     C                   PARM                    SOSDT                                        CDL028
     C                   PARM                    RXOSDT                                       CDL028
                                                                                              CDL028
     C     MSG1          IFNE      *BLANK                                                     CDL028
     C                   ADD       1             Idx                                          CDL028
     C                   EVAL      FldNameArr(Idx) = 'SOSDT'                                  CDL028
     C                   EVAL      MsgIDArr(Idx) = MSG1                                       CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CDL028
      *  *----------------------------------------------*                                     CDL028
      *  * Validate Our Start - 1st Term Base Rate Code *  #50                                CDL028
      *  *----------------------------------------------*                                     CDL028
     C                   EXSR      RESETERRS                                                  CDL028
                                                                                              CDL028
     C                   CALLB     'IRVSTUBBRC'                                               CDL028
     C                   PARM                    ReturnCode                                   CDL028
     C                   PARM                    MSG1                                         CDL028
     C                   PARM                    SOS1B                                        CDL028
     C                   PARM                    SUCUCY                                       CDL028
                                                                                              CDL028
     C     MSG1          IFEQ      *BLANK                                                     CDL028
     C                   MOVE      SOS1B         RXOS1B                                       CDL028
      *                                                                                       CDL028
     C                   ELSE                                                                 CDL028
     C                   ADD       1             Idx                                          CDL028
     C                   EVAL      FldNameArr(Idx) = 'SOS1B'                                  CDL028
     C                   EVAL      MsgIDArr(Idx) = MSG1                                       CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CDL028
      *  *-----------------------------------------*                                          CDL028
      *  * Validate Our Start - 1st Term End Date  *  #51                                     CDL028
      *  *-----------------------------------------*                                          CDL028
     C                   EXSR      RESETERRS                                                  CDL028
                                                                                              CDL028
     C                   CALLB     'IRVSTUBDTE'                                               CDL028
     C                   PARM                    ReturnCode                                   CDL028
     C                   PARM                    MSG1                                         CDL028
     C                   PARM                    BJDFIN                                       CDL028
     C                   PARM                    SOS1D                                        CDL028
     C                   PARM                    RXOS1D                                       CDL028
                                                                                              CDL028
     C     MSG1          IFNE      *BLANK                                                     CDL028
     C                   ADD       1             Idx                                          CDL028
     C                   EVAL      FldNameArr(Idx) = 'SOS1D'                                  CDL028
     C                   EVAL      MsgIDArr(Idx) = MSG1                                       CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CDL028
      *  *----------------------------------------------*                                     CDL028
      *  * Validate Our Start - 2nd Term Base Rate Code *  #52                                CDL028
      *  *----------------------------------------------*                                     CDL028
     C                   EXSR      RESETERRS                                                  CDL028
                                                                                              CDL028
     C                   CALLB     'IRVSTUBBRC'                                               CDL028
     C                   PARM                    ReturnCode                                   CDL028
     C                   PARM                    MSG1                                         CDL028
     C                   PARM                    SOS2B                                        CDL028
     C                   PARM                    SUCUCY                                       CDL028
                                                                                              CDL028
     C     MSG1          IFEQ      *BLANK                                                     CDL028
     C                   MOVE      SOS2B         RXOS2B                                       CDL028
      *                                                                                       CDL028
     C                   ELSE                                                                 CDL028
     C                   ADD       1             Idx                                          CDL028
     C                   EVAL      FldNameArr(Idx) = 'SOS2B'                                  CDL028
     C                   EVAL      MsgIDArr(Idx) = MSG1                                       CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CDL028
      *  *-----------------------------------------*                                          CDL028
      *  * Validate Our Start - 2nd Term End Date  *  #53                                     CDL028
      *  *-----------------------------------------*                                          CDL028
     C                   EXSR      RESETERRS                                                  CDL028
                                                                                              CDL028
     C                   CALLB     'IRVSTUBDTE'                                               CDL028
     C                   PARM                    ReturnCode                                   CDL028
     C                   PARM                    MSG1                                         CDL028
     C                   PARM                    BJDFIN                                       CDL028
     C                   PARM                    SOS2D                                        CDL028
     C                   PARM                    RXOS2D                                       CDL028
                                                                                              CDL028
     C     MSG1          IFNE      *BLANK                                                     CDL028
     C                   ADD       1             Idx                                          CDL028
     C                   EVAL      FldNameArr(Idx) = 'SOS2D'                                  CDL028
     C                   EVAL      MsgIDArr(Idx) = MSG1                                       CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CDL028
      *  *-----------------------------------------*                                          CDL028
      *  * Validate Our End Date                   *  #54                                     CDL028
      *  *-----------------------------------------*                                          CDL028
     C                   EXSR      RESETERRS                                                  CDL028
                                                                                              CDL028
     C                   CALLB     'IRVSTUBDTE'                                               CDL028
     C                   PARM                    ReturnCode                                   CDL028
     C                   PARM                    MSG1                                         CDL028
     C                   PARM                    BJDFIN                                       CDL028
     C                   PARM                    SOEDT                                        CDL028
     C                   PARM                    RXOEDT                                       CDL028
                                                                                              CDL028
     C     MSG1          IFNE      *BLANK                                                     CDL028
     C                   ADD       1             Idx                                          CDL028
     C                   EVAL      FldNameArr(Idx) = 'SOEDT'                                  CDL028
     C                   EVAL      MsgIDArr(Idx) = MSG1                                       CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CDL028
      *  *--------------------------------------------*                                       CDL028
      *  * Validate Our End - 1st Term Base Rate Code *  #55                                  CDL028
      *  *--------------------------------------------*                                       CDL028
     C                   EXSR      RESETERRS                                                  CDL028
                                                                                              CDL028
     C                   CALLB     'IRVSTUBBRC'                                               CDL028
     C                   PARM                    ReturnCode                                   CDL028
     C                   PARM                    MSG1                                         CDL028
     C                   PARM                    SOE1B                                        CDL028
     C                   PARM                    SUCUCY                                       CDL028
                                                                                              CDL028
     C     MSG1          IFEQ      *BLANK                                                     CDL028
     C                   MOVE      SOE1B         RXOE1B                                       CDL028
      *                                                                                       CDL028
     C                   ELSE                                                                 CDL028
     C                   ADD       1             Idx                                          CDL028
     C                   EVAL      FldNameArr(Idx) = 'SOE1B'                                  CDL028
     C                   EVAL      MsgIDArr(Idx) = MSG1                                       CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CDL028
      *  *-----------------------------------------*                                          CDL028
      *  * Validate Our End - 1st Term End Date    *  #56                                     CDL028
      *  *-----------------------------------------*                                          CDL028
     C                   EXSR      RESETERRS                                                  CDL028
                                                                                              CDL028
     C                   CALLB     'IRVSTUBDTE'                                               CDL028
     C                   PARM                    ReturnCode                                   CDL028
     C                   PARM                    MSG1                                         CDL028
     C                   PARM                    BJDFIN                                       CDL028
     C                   PARM                    SOE1D                                        CDL028
     C                   PARM                    RXOE1D                                       CDL028
                                                                                              CDL028
     C     MSG1          IFNE      *BLANK                                                     CDL028
     C                   ADD       1             Idx                                          CDL028
     C                   EVAL      FldNameArr(Idx) = 'SOE1D'                                  CDL028
     C                   EVAL      MsgIDArr(Idx) = MSG1                                       CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CDL028
      *  *--------------------------------------------*                                       CDL028
      *  * Validate Our End - 2nd Term Base Rate Code *  #57                                  CDL028
      *  *--------------------------------------------*                                       CDL028
     C                   EXSR      RESETERRS                                                  CDL028
                                                                                              CDL028
     C                   CALLB     'IRVSTUBBRC'                                               CDL028
     C                   PARM                    ReturnCode                                   CDL028
     C                   PARM                    MSG1                                         CDL028
     C                   PARM                    SOE2B                                        CDL028
     C                   PARM                    SUCUCY                                       CDL028
                                                                                              CDL028
     C     MSG1          IFEQ      *BLANK                                                     CDL028
     C                   MOVE      SOE2B         RXOE2B                                       CDL028
      *                                                                                       CDL028
     C                   ELSE                                                                 CDL028
     C                   ADD       1             Idx                                          CDL028
     C                   EVAL      FldNameArr(Idx) = 'SOE2B'                                  CDL028
     C                   EVAL      MsgIDArr(Idx) = MSG1                                       CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CDL028
      *  *-----------------------------------------*                                          CDL028
      *  * Validate Our End - 2nd Term End Date    *  #58                                     CDL028
      *  *-----------------------------------------*                                          CDL028
     C                   EXSR      RESETERRS                                                  CDL028
                                                                                              CDL028
     C                   CALLB     'IRVSTUBDTE'                                               CDL028
     C                   PARM                    ReturnCode                                   CDL028
     C                   PARM                    MSG1                                         CDL028
     C                   PARM                    BJDFIN                                       CDL028
     C                   PARM                    SOE2D                                        CDL028
     C                   PARM                    RXOE2D                                       CDL028
                                                                                              CDL028
     C     MSG1          IFNE      *BLANK                                                     CDL028
     C                   ADD       1             Idx                                          CDL028
     C                   EVAL      FldNameArr(Idx) = 'SOE2D'                                  CDL028
     C                   EVAL      MsgIDArr(Idx) = MSG1                                       CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CDL028
      *  *-----------------------------------------*                                          CDL028
      *  * Validate Their Start Date               *  #59                                     CDL028
      *  *-----------------------------------------*                                          CDL028
     C                   EXSR      RESETERRS                                                  CDL028
                                                                                              CDL028
     C                   CALLB     'IRVSTUBDTE'                                               CDL028
     C                   PARM                    ReturnCode                                   CDL028
     C                   PARM                    MSG1                                         CDL028
     C                   PARM                    BJDFIN                                       CDL028
     C                   PARM                    STSDT                                        CDL028
     C                   PARM                    RXTSDT                                       CDL028
                                                                                              CDL028
     C     MSG1          IFNE      *BLANK                                                     CDL028
     C                   ADD       1             Idx                                          CDL028
     C                   EVAL      FldNameArr(Idx) = 'STSDT'                                  CDL028
     C                   EVAL      MsgIDArr(Idx) = MSG1                                       CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CDL028
      *  *------------------------------------------------*                                   CDL028
      *  * Validate Their Start - 1st Term Base Rate Code *  #60                              CDL028
      *  *------------------------------------------------*                                   CDL028
     C                   EXSR      RESETERRS                                                  CDL028
                                                                                              CDL028
     C                   CALLB     'IRVSTUBBRC'                                               CDL028
     C                   PARM                    ReturnCode                                   CDL028
     C                   PARM                    MSG1                                         CDL028
     C                   PARM                    STS1B                                        CDL028
     C                   PARM                    STCUCY                                       CDL028
                                                                                              CDL028
     C     MSG1          IFEQ      *BLANK                                                     CDL028
     C                   MOVE      STS1B         RXTS1B                                       CDL028
      *                                                                                       CDL028
     C                   ELSE                                                                 CDL028
     C                   ADD       1             Idx                                          CDL028
     C                   EVAL      FldNameArr(Idx) = 'STS1B'                                  CDL028
     C                   EVAL      MsgIDArr(Idx) = MSG1                                       CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CDL028
      *  *------------------------------------------*                                         CDL028
      *  * Validate Their Start - 1st Term End Date *  #61                                    CDL028
      *  *------------------------------------------*                                         CDL028
     C                   EXSR      RESETERRS                                                  CDL028
                                                                                              CDL028
     C                   CALLB     'IRVSTUBDTE'                                               CDL028
     C                   PARM                    ReturnCode                                   CDL028
     C                   PARM                    MSG1                                         CDL028
     C                   PARM                    BJDFIN                                       CDL028
     C                   PARM                    STS1D                                        CDL028
     C                   PARM                    RXTS1D                                       CDL028
                                                                                              CDL028
     C     MSG1          IFNE      *BLANK                                                     CDL028
     C                   ADD       1             Idx                                          CDL028
     C                   EVAL      FldNameArr(Idx) = 'STS1D'                                  CDL028
     C                   EVAL      MsgIDArr(Idx) = MSG1                                       CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CDL028
      *  *------------------------------------------------*                                   CDL028
      *  * Validate Their Start - 2nd Term Base Rate Code *  #62                              CDL028
      *  *------------------------------------------------*                                   CDL028
     C                   EXSR      RESETERRS                                                  CDL028
                                                                                              CDL028
     C                   CALLB     'IRVSTUBBRC'                                               CDL028
     C                   PARM                    ReturnCode                                   CDL028
     C                   PARM                    MSG1                                         CDL028
     C                   PARM                    STS2B                                        CDL028
     C                   PARM                    STCUCY                                       CDL028
                                                                                              CDL028
     C     MSG1          IFEQ      *BLANK                                                     CDL028
     C                   MOVE      STS2B         RXTS2B                                       CDL028
      *                                                                                       CDL028
     C                   ELSE                                                                 CDL028
     C                   ADD       1             Idx                                          CDL028
     C                   EVAL      FldNameArr(Idx) = 'STS2B'                                  CDL028
     C                   EVAL      MsgIDArr(Idx) = MSG1                                       CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CDL028
      *  *-------------------------------------------*                                        CDL028
      *  * Validate Their Start - 2nd Term End Date  *  #63                                   CDL028
      *  *-------------------------------------------*                                        CDL028
     C                   EXSR      RESETERRS                                                  CDL028
                                                                                              CDL028
     C                   CALLB     'IRVSTUBDTE'                                               CDL028
     C                   PARM                    ReturnCode                                   CDL028
     C                   PARM                    MSG1                                         CDL028
     C                   PARM                    BJDFIN                                       CDL028
     C                   PARM                    STS2D                                        CDL028
     C                   PARM                    RXTS2D                                       CDL028
                                                                                              CDL028
     C     MSG1          IFNE      *BLANK                                                     CDL028
     C                   ADD       1             Idx                                          CDL028
     C                   EVAL      FldNameArr(Idx) = 'STS2D'                                  CDL028
     C                   EVAL      MsgIDArr(Idx) = MSG1                                       CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CDL028
      *  *-----------------------------------------*                                          CDL028
      *  * Validate Their End Date                 *  #64                                     CDL028
      *  *-----------------------------------------*                                          CDL028
     C                   EXSR      RESETERRS                                                  CDL028
                                                                                              CDL028
     C                   CALLB     'IRVSTUBDTE'                                               CDL028
     C                   PARM                    ReturnCode                                   CDL028
     C                   PARM                    MSG1                                         CDL028
     C                   PARM                    BJDFIN                                       CDL028
     C                   PARM                    STEDT                                        CDL028
     C                   PARM                    RXTEDT                                       CDL028
                                                                                              CDL028
     C     MSG1          IFNE      *BLANK                                                     CDL028
     C                   ADD       1             Idx                                          CDL028
     C                   EVAL      FldNameArr(Idx) = 'STEDT'                                  CDL028
     C                   EVAL      MsgIDArr(Idx) = MSG1                                       CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CDL028
      *  *----------------------------------------------*                                     CDL028
      *  * Validate Their End - 1st Term Base Rate Code *  #65                                CDL028
      *  *----------------------------------------------*                                     CDL028
     C                   EXSR      RESETERRS                                                  CDL028
                                                                                              CDL028
     C                   CALLB     'IRVSTUBBRC'                                               CDL028
     C                   PARM                    ReturnCode                                   CDL028
     C                   PARM                    MSG1                                         CDL028
     C                   PARM                    STE1B                                        CDL028
     C                   PARM                    STCUCY                                       CDL028
                                                                                              CDL028
     C     MSG1          IFEQ      *BLANK                                                     CDL028
     C                   MOVE      STE1B         RXTE1B                                       CDL028
      *                                                                                       CDL028
     C                   ELSE                                                                 CDL028
     C                   ADD       1             Idx                                          CDL028
     C                   EVAL      FldNameArr(Idx) = 'STE1B'                                  CDL028
     C                   EVAL      MsgIDArr(Idx) = MSG1                                       CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CDL028
      *  *-------------------------------------------*                                        CDL028
      *  * Validate Their - 1st Term End Date        *  #66                                   CDL028
      *  *-------------------------------------------*                                        CDL028
     C                   EXSR      RESETERRS                                                  CDL028
                                                                                              CDL028
     C                   CALLB     'IRVSTUBDTE'                                               CDL028
     C                   PARM                    ReturnCode                                   CDL028
     C                   PARM                    MSG1                                         CDL028
     C                   PARM                    BJDFIN                                       CDL028
     C                   PARM                    STE1D                                        CDL028
     C                   PARM                    RXTE1D                                       CDL028
                                                                                              CDL028
     C     MSG1          IFNE      *BLANK                                                     CDL028
     C                   ADD       1             Idx                                          CDL028
     C                   EVAL      FldNameArr(Idx) = 'STE1D'                                  CDL028
     C                   EVAL      MsgIDArr(Idx) = MSG1                                       CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CDL028
      *  *----------------------------------------------*                                     CDL028
      *  * Validate Their End - 2nd Term Base Rate Code *  #67                                CDL028
      *  *----------------------------------------------*                                     CDL028
     C                   EXSR      RESETERRS                                                  CDL028
                                                                                              CDL028
     C                   CALLB     'IRVSTUBBRC'                                               CDL028
     C                   PARM                    ReturnCode                                   CDL028
     C                   PARM                    MSG1                                         CDL028
     C                   PARM                    STE2B                                        CDL028
     C                   PARM                    STCUCY                                       CDL028
                                                                                              CDL028
     C     MSG1          IFEQ      *BLANK                                                     CDL028
     C                   MOVE      STE2B         RXTE2B                                       CDL028
      *                                                                                       CDL028
     C                   ELSE                                                                 CDL028
     C                   ADD       1             Idx                                          CDL028
     C                   EVAL      FldNameArr(Idx) = 'STE2B'                                  CDL028
     C                   EVAL      MsgIDArr(Idx) = MSG1                                       CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CDL028
      *  *-------------------------------------------*                                        CDL028
      *  * Validate Their End - 2nd Term End Date    *  #68                                   CDL028
      *  *-------------------------------------------*                                        CDL028
     C                   EXSR      RESETERRS                                                  CDL028
                                                                                              CDL028
     C                   CALLB     'IRVSTUBDTE'                                               CDL028
     C                   PARM                    ReturnCode                                   CDL028
     C                   PARM                    MSG1                                         CDL028
     C                   PARM                    BJDFIN                                       CDL028
     C                   PARM                    STE2D                                        CDL028
     C                   PARM                    RXTE2D                                       CDL028
                                                                                              CDL028
     C     MSG1          IFNE      *BLANK                                                     CDL028
     C                   ADD       1             Idx                                          CDL028
     C                   EVAL      FldNameArr(Idx) = 'STE2D'                                  CDL028
     C                   EVAL      MsgIDArr(Idx) = MSG1                                       CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CDL028
      *  *-------------------------------------------------------*
      *  * If no errors set up outstanding fields for valid file *
      *  *-------------------------------------------------------*

     C                   IF        Idx = 0
     C                   EXSR      SetupValid
     C                   ENDIF

      /COPY WNCPYSRC,IRCIRSV098                                                 CAP004
                                                                                CAP004
     C                   RETURN

      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,IRCIRSV101

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

     C     *ENTRY        PLIST
      * Mode of operation                                                       CIR005
     C                   PARM                    ModeOfOp                       CIR005
      * Response mode (1A), from source system common header
     C                   PARM                    RespMode
      * Transaction information (DS) from source system
     C                   PARM                    TranIn
     C                   PARM                    ACTRJ             1                        MD053400
      * Receive Settlement Method & Nostro and  Pay Settlement Method &
      *  Nostro, from default (Action = I) or valid deal (Action = A)
     C                   PARM                    RecSetCcy
     C                   PARM                    RecSetMeth
     C                   PARM                    RecNostro
     C                   PARM                    PaySetCcy
     C                   PARM                    PaySetMeth
     C                   PARM                    PayNostro
     C                   PARM                    ExtData                        CAP004
      * Business Day Validation                                                 CIR005
     C                   PARM                    WValBDC                        CIR005
      * Field OK flags (DS) from/to caller
     C                   PARM                    OKFlagsDS
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
      * Valid Deals layout (DS) from/to caller
     C                   PARM                    ValidDeal
     C                   PARM                    ValidXDeal                                   CLE025
     C                   PARM                    ACTNCD            1                          187606
     C                   PARM                    PUSLIP            5 0                        184560
     C                   PARM                    PTSLIP            5 0                        184560
      *                                                                                       185057
      * Current Deal in Screen Format                                                         185057
     C                   PARM                    DealScnFmt                                   185057
                                                                                              CDL029
     C     KBRANCHAUTH   KLIST                                                                CDL029
     C******             KFLD                    BBBRCD                                CDL029CDL029A
     C                   KFLD                    W0BRCD            3                         CDL029A
     C                   KFLD                    W0CUST            6                         CDL029A
     C                   KFLD                    SBRCA                                        CDL029

      * File / Data area Accesses required for calling parameters
      * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     C*
     C****GET*ZMUSER*to*access*default*branch.                                                CDL038
     C*****************************                                                           CDL038
     C******DTAARA*******DEFINE                  ZMUSER                                       CDL038
     C*******************IN********ZMUSER                                                     CDL038
     C*******************UNLOCK****ZMUSER                                                     CDL038
     C**
      **  Move program name into *LDA field.
     C     *LOCK         IN        LDA
     C                   MOVEL     'IRCIRSVAL'   DBPGM
     C                   OUT       LDA

      ** Access Dealing details via access program
      *  (database error handling done in access program)
     C**********         CALLB     'AODEALR0'                                                 CGL029
     C                   CALLB     'AODEALR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
      **********                                                                       164607 245692
      **EDIT*AMOUNTS*WITH '.'*****************************************                 164607 245692
      **********                                                                       164607 245692
     C**********         MOVE      '.'           BNDCSP                                164607 245692
      *
      ** Access General Ledger details via access program
      *  (database error handling done in access program)
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029

      ** Access Trading Details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOTRADR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDTRAD        PARM      SDTRAD        DSFDY

      ** Call Access Program for FRA/IRS I.C.D. details
      *
     C                   CALL      'AOFAISR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDFAIS        PARM      SDFAIS        DSFDY
     C*
     C**
      **  Access SAR details file to determine if Interest Rate
      **  Callenders is switched on.                                   CI
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CIR001'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE                         ***************
     C                   MOVEL     '024'         DBASE                          * DB ERROR 24 *
     C                   MOVEL     'CIR001'      DBKEY                          ***************
     C                   EXSR      #C
     C                   END
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           CIR001            1
     C                   MOVE      '1'           *IN71
     C                   ELSE
     C                   MOVEL     'N'           CIR001
     C                   MOVE      '0'           *IN71
     C                   END
      *
      **  Access SAR details file to determine if FRAIRS
      **  Message Generation is switched on.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSW005'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE                         ***************
     C                   MOVEL     '025'         DBASE                          * DB ERROR 25 *
     C                   MOVEL     'CSW005'      DBKEY                          ***************
     C                   EXSR      #C
     C                   ENDIF
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           CSW005            1
     C                   MOVE      '1'           *IN74
     C                   ELSE
     C                   MOVEL     'N'           CSW005
     C                   MOVE      '0'           *IN74
     C                   ENDIF
      *                                                                         CIR005
      **  Access SAR details file to determine if Business                      CIR005
      **  Day Conventions is switched on.                                       CIR005
      *                                                                         CIR005
     C                   CALL      'AOSARDR0'                                   CIR005
     C                   PARM      *BLANKS       @RTCD                          CIR005
     C                   PARM      '*VERIFY'     @OPTN                          CIR005
     C                   PARM      'CIR005'      @SARD                          CIR005
     C     SCSARD        PARM      SCSARD        DSFDY                          CIR005
      *                                                                         CIR005
     C                   IF        @RTCD <> *Blanks and @RTCD <> '*NRF   '      CIR005
     C     *LOCK         IN        LDA                                          CIR005
     C                   MOVEL     'SCSARDPD'    DBFILE                         CIR005
     C                   Z-ADD     26            DBASE                          CIR005
     C                   MOVEL     'CIR005'      DBKEY                          CIR005
     C                   OUT       LDA                                          CIR005
     C                   EXSR      #C                                           CIR005
     C                   ENDIF                                                  CIR005
      *                                                                         CIR005
     C                   IF        @RTCD = *BLANKS                              CIR005
     C                   MOVEL     'Y'           CIR005            1            CIR005
     C                   ELSE                                                   CIR005
     C                   MOVEL     'N'           CIR005                         CIR005
     C                   ENDIF                                                  CIR005
      *                                                                                       CIR003
      **  Access SAR details file to determine if Add'l Pay/Rcv Msgs for                      CIR003
      **  Principal Exchange on Cross Ccy IRS is On                                           CIR003
      *                                                                                       CIR003
     C                   CALL      'AOSARDR0'                                                 CIR003
     C                   PARM      *BLANKS       @RTCD                                        CIR003
     C                   PARM      '*VERIFY'     @OPTN                                        CIR003
     C                   PARM      'CIR003'      @SARD                                        CIR003
     C     SCSARD        PARM      SCSARD        DSFDY                                        CIR003
      *                                                                                       CIR003
     C                   IF        @RTCD <> *Blanks and @RTCD <> '*NRF   '                    CIR003
     C     *LOCK         IN        LDA                                                        CIR003
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CIR003
     C                   Z-ADD     27            DBASE                                        CIR003
     C                   MOVEL     'CIR003'      DBKEY                                        CIR003
     C                   OUT       LDA                                                        CIR003
     C                   EXSR      #C                                                         CIR003
     C                   ENDIF                                                                CIR003
      *                                                                                       CIR003
     C                   IF        @RTCD = *BLANKS                                            CIR003
     C                   MOVEL     'Y'           CIR003            1                          CIR003
     C                   ELSE                                                                 CIR003
     C                   MOVEL     'N'           CIR003                                       CIR003
     C                   ENDIF                                                                CIR003
                                                                                              CIR007
      ** Access SAR details file to determine if CIR007                                       CIR007
      ** (Overnight Index Swaps) is switched on.                                              CIR007
                                                                                              CIR007
     C                   CALLB     'AOSARDR0'                                                 CIR007
     C                   PARM      *BLANKS       PRTCD                                        CIR007
     C                   PARM      '*VERIFY'     POption                                      CIR007
     C                   PARM      'CIR007'      PSard                                        CIR007
     C     SCSARD        PARM      SCSARD        DSFDY                                        CIR007
                                                                                              CIR007
      ** Database Error                                                                       CIR007
                                                                                              CIR007
     C                   IF        PRTCD <> *BLANKS AND                                       CIR007
     C                             PRTCD <> '*NRF   '                                         CIR007
                                                                                              CIR007
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CIR007
     C                   MOVEL     '028'         DBASE                                        CIR007
     C                   MOVEL     'CIR007'      DBKEY                                        CIR007
     C                   EXSR      *PSSR                                                      CIR007
                                                                                              CIR007
     C                   ENDIF                                                                CIR007
                                                                                              CIR007
     C                   IF        PRTCD = *BLANKS                                            CIR007
                                                                                              CIR007
     C                   EVAL      CIR007 = 'Y'                                               CIR007
                                                                                              CIR007
     C                   ELSE                                                                 CIR007
                                                                                              CIR007
     C                   EVAL      CIR007 = 'N'                                               CIR007
                                                                                              CIR007
     C                   ENDIF                                                                CIR007
                                                                                              CAS001
      ** Access SAR details file to determine if CAS001 (NPV Accounting)                      CAS001
      ** is switched on.                                                                      CAS001
                                                                                              CAS001
     C                   CALLB     'AOSARDR0'                                                 CAS001
     C                   PARM      *BLANKS       PRTCD                                        CAS001
     C                   PARM      '*VERIFY'     POption                                      CAS001
     C                   PARM      'CAS001'      PSard                                        CAS001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS001
                                                                                              CAS001
      ** Database Error                                                                       CAS001
                                                                                              CAS001
     C                   IF        PRTCD <> *BLANKS AND                                       CAS001
     C                             PRTCD <> '*NRF   '                                         CAS001
                                                                                              CAS001
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CAS001
     C                   MOVEL     '029'         DBASE                                        CAS001
     C                   MOVEL     'CAS001'      DBKEY                                        CAS001
     C                   EXSR      *PSSR                                                      CAS001
                                                                                              CAS001
     C                   ENDIF                                                                CAS001
                                                                                              CAS001
     C                   IF        PRTCD = *BLANKS                                            CAS001
     C                   EVAL      CAS001 = 'Y'                                               CAS001
     C                   ELSE                                                                 CAS001
     C                   EVAL      CAS001 = 'N'                                               CAS001
     C                   ENDIF                                                                CAS001
                                                                                              CAS005
      ** Access SAR details file to determine if Enhancements to CAS001, CAS002               CAS005
      ** and CAS004 is switched on.                                                           CAS005
                                                                                              CAS005
     C                   CALLB     'AOSARDR0'                                                 CAS005
     C                   PARM      *BLANKS       PRTCD                                        CAS005
     C                   PARM      '*VERIFY'     POption                                      CAS005
     C                   PARM      'CAS005'      PSard                                        CAS005
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS005
                                                                                              CAS005
      ** Database Error                                                                       CAS005
                                                                                              CAS005
     C                   IF        PRTCD <> *BLANKS AND                                       CAS005
     C                             PRTCD <> '*NRF   '                                         CAS005
                                                                                              CAS005
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CAS005
     C                   MOVEL     '030'         DBASE                                        CAS005
     C                   MOVEL     'CAS005'      DBKEY                                        CAS005
     C                   EXSR      *PSSR                                                      CAS005
                                                                                              CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   IF        PRTCD = *BLANKS                                            CAS005
     C                   EVAL      CAS005 = 'Y'                                               CAS005
     C                   ELSE                                                                 CAS005
     C                   EVAL      CAS005 = 'N'                                               CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS008
      ** Access SAR details file to determine if IAS39 Enhancement                            CAS008
      ** is switched on.                                                                      CAS008
                                                                                              CAS008
     C                   CALLB     'AOSARDR0'                                                 CAS008
     C                   PARM      *BLANKS       PRTCD                                        CAS008
     C                   PARM      '*VERIFY'     POption                                      CAS008
     C                   PARM      'CAS008'      PSard                                        CAS008
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS008
                                                                                              CAS008
      ** Database Error                                                                       CAS008
                                                                                              CAS008
     C                   IF        PRTCD <> *BLANKS AND                                       CAS008
     C                             PRTCD <> '*NRF   '                                         CAS008
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS008
     C                   EVAL      DBASE  = 031                                               CAS008
     C                   EVAL      DBKEY  = 'CAS008'                                          CAS008
     C                   EXSR      *PSSR                                                      CAS008
     C                   ENDIF                                                                CAS008
                                                                                              CAS008
     C                   IF        PRTCD = *BLANKS                                            CAS008
     C                   EVAL      CAS008 = 'Y'                                               CAS008
     C                   ELSE                                                                 CAS008
     C                   EVAL      CAS008 = 'N'                                               CAS008
     C                   ENDIF                                                                CAS008
                                                                                            AR569568
     C                   CALL      'AOSARDR0'                                               AR569568
     C                   PARM      *BLANKS       @RTCD                                      AR569568
     C                   PARM      '*VERIFY'     @OPTN                                      AR569568
     C                   PARM      'CDL006'      @SARD                                      AR569568
     C     SCSARD        PARM      SCSARD        DSFDY                                      AR569568
                                                                                            AR569568
     C                   IF        @RTCD <> *BLANKS AND                                     AR569568
     C                             @RTCD <> '*NRF   '                                       AR569568
     C                   EVAL      DBKEY = 'CDL006'                                         AR569568
     C                   EVAL      DBFILE = 'SCSARDPD'                                      AR569568
     C                   EVAL      DBASE = 001                                              AR569568
     C                   EXSR      *PSSR                                                    AR569568
     C                   ENDIF                                                              AR569568
                                                                                            AR569568
     C                   IF        @RTCD = *BLANKS                                          AR569568
     C                   EVAL      CDL006 = 'Y'                                             AR569568
     C                   ELSE                                                               AR569568
     C                   EVAL      CDL006 = 'N'                                             AR569568
     C                   ENDIF                                                              AR569568
      *
      ** Access Bank details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      **
      ** Access MIDAS Modules details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOMMODR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDMMOD        PARM      SDMMOD        DSFDY
      **
     C*
      *  Set up the name of the MSGF from which the message handler will
      *   get the messages
     C                   EVAL      #MsgFile = 'DRSMM'
     C                   EVAL      MsgFArray(1) = 'DRSMM'                                     CLE025
     C                   EVAL      MsgFArray(2) = 'LERMSGF'                                   CLE025
     C                   EVAL      PLCcy = BJLCCY                               CIR005
                                                                                              CSC011
      ** Check if CSC011 is installed                                                         CSC011
                                                                                              CSC011
     C                   EVAL      WRunDay = BJRDNB                                           CSC011
                                                                                              CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRtCd                                        CSC011
     C                   PARM      '*VERIFY'     POption                                      CSC011
     C                   PARM      'CSC011'      PSard                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
     C                   IF        PRtCd = *Blanks                                            CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IN        SDSTAT                                                     CSC011
     C                   IF        S1SUPP = LIBR                                              CSC011
     C                   EVAL      WRunDay = S1DATE                                           CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
     C                   IF        PRtCd <> '*NRF'                                            CSC011
     C     *LOCK         IN        LDA                                                        CSC011
     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBASE = 029                                                CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CLE025
      ** Check if enhancement CLE025 (Credit Lines) is on                                     CLE025
                                                                                              CLE025
     C                   CALL      'AOSARDR0'                                                 CLE025
     C                   PARM      *BLANKS       PRtCd                                        CLE025
     C                   PARM      '*VERIFY'     POption                                      CLE025
     C                   PARM      'CLE025'      PSard                                        CLE025
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE025
                                                                                              CLE025
     C                   IF        PRtCd <> *BLANKS AND PRtCd <> '*NRF   '                    CLE025
     C     *LOCK         IN        LDA                                                        CLE025
     C                   EVAL      DBKEY = 'CLE025'                                           CLE025
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CLE025
     C                   EVAL      DBASE = 031                                                CLE025
     C                   OUT       LDA                                                        CLE025
     C                   EXSR      *PSSR                                                      CLE025
     C                   ENDIF                                                                CLE025
                                                                                              CLE025
     C                   IF        PRtCd = *BLANKS                                            CLE025
     C                   EVAL      CLE025 = 'Y'                                               CLE025
     C                   ELSE                                                                 CLE025
     C                   EVAL      CLE025 = 'N'                                               CLE025
     C                   ENDIF                                                                CLE025
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
     C                   EVAL      DBASE = 030                                                CDL029
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
     C                   MOVEL     'SCSARDPD'    DBFILE                      * DBERROR 031 * BUG5443
     C                   MOVEL     '031'         DBASE                                       BUG5443
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
      ** Access SAR details file to determine if CDL028                                       CDL028
      ** (Automatic Rate Interpolation) is switched on.                                       CDL028
                                                                                              CDL028
     C                   CALLB     'AOSARDR0'                                                 CDL028
     C                   PARM      *BLANKS       PRTCD                                        CDL028
     C                   PARM      '*VERIFY'     POption                                      CDL028
     C                   PARM      'CDL028'      PSard                                        CDL028
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL028
                                                                                              CDL028
      ** Database Error                                                                       CDL028
                                                                                              CDL028
     C                   IF        PRTCD <> *BLANKS AND                                       CDL028
     C                             PRTCD <> '*NRF   '                                         CDL028
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CDL028
     C                   MOVEL     '032'         DBASE                                        CDL028
     C                   MOVEL     'CDL028'      DBKEY                                        CDL028
     C                   EXSR      *PSSR                                                      CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CDL028
     C                   EVAL      CDL028 = 'N'                                               CDL028
     C                   IF        PRTCD = *BLANKS                                            CDL028
     C                   EVAL      CDL028 = 'Y'                                               CDL028
     C                   ENDIF                                                                CDL028

      ** Access SAR details file to determine if CDL038 is switched on                       BUG9717
                                                                                             BUG9717
     C                   CALLB     'AOSARDR0'                                                BUG9717
     C                   PARM      *BLANKS       PRTCD                                       BUG9717
     C                   PARM      '*VERIFY'     POPTION                                     BUG9717
     C                   PARM      'CDL038'      PSARD                                       BUG9717
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG9717
                                                                                             BUG9717
     C                   IF        PRTCD <> *BLANKS AND                                      BUG9717
     C                             PRTCD <> '*NRF   '                                        BUG9717
     C     *LOCK         IN        LDA                                                       BUG9717
     C                   EVAL      DBFILE = 'SCSARDPD'                                       BUG9717
     C                   EVAL      DBASE = 908                                               BUG9717
     C                   EVAL      DBKEY = 'CDL038'                                          BUG9717
     C                   OUT       LDA                                                       BUG9717
     C                   EXSR      *PSSR                                                     BUG9717
     C                   ENDIF                                                               BUG9717
                                                                                             BUG9717
     C                   IF        PRTCD = *BLANKS                                           BUG9717
     C                   EVAL      CDL038 = 'Y'                                              BUG9717
     C                   ELSE                                                                BUG9717
     C                   EVAL      CDL038 = 'N'                                              BUG9717
     C                   ENDIF                                                               BUG9717
                                                                                             BUG9717
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area

      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,IRCIRSV102

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * RESETERRS - Reset error information that is received back     *
      *    from each validation module.                               *
      *                                                               *
      * Called by: Main processing, before each validation module     *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     RESETERRS     BEGSR

     C                   RESET                   Msg1
     C                   RESET                   Msg2
     C                   RESET                   Msg3
     C                   RESET                   Msg4
     C                   RESET                   Msg5
     C                   RESET                   Msg6
     C                   RESET                   Msg7

     C                   RESET                   WMsgID1
     C                   RESET                   WMsgID2
     C                   RESET                   WMsgID3
     C                   RESET                   WMsgID4

     C                   RESET                   MSGDATA
     C                   RESET                   WMsgData                       CIR005

     C                   EVAL      ReturnCode= *Blanks

     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  CDL038
      *****************************************************************                       CDL038
      * Default Sub Type and Class                                                            CDL038
      *****************************************************************                       CDL038
     C     DSUBTCLAS     BEGSR                                                                CDL038
      *                                                                                       CDL038
     C                   CALL      'DL002000'                                                 CDL038
      * Inputs                                                                                CDL038
     C                   PARM                    SACCD                                        CDL038
     C                   PARM                    SDTYP                                        CDL038
     C                   PARM                    SCNUM                                        CDL038
     C                   PARM                    SVDAT                                        CDL038
     C                   PARM                    SMDAT                                        CDL038
     C                   PARM                    SBOKC                                        CDL038
     C                   PARM                    SPRFC                                        CDL038
     C                   PARM                    SUCUCY                                       CDL038
     C                   PARM                    STCUCY                                       CDL038
     C                   PARM      *BLANK        @RelatedDeal      6                          CDL038
      * Inputs/Outputs                                                                        CDL038
     C                   PARM                    SDLST                                        CDL038
     C                   PARM                    SCLAS                                        CDL038
      *                                                                                       CDL038
     C                   ENDSR                                                                CDL038
      *****************************************************************                       CDL038
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPVALID - Set up additional fields that are needed on the  *
      *    Valid file record.                                         *
      *                                                               *
      *****************************************************************

     C     SETUPVALID    BEGSR

      * Other RSxxxx fields are set up during the individual date
      *  validation, such as the ones where the input & database formats
      *  are different, e.g. dates, amounts.
      * This SR sets up the fields with the same (or compatible) attributes

     C********           MOVE      RXDLNO        DealNumber
     C                   MOVE      SDTYP         RXDTYP
     C                   MOVE      SDLST         RXDLST
     C                   MOVE      SBOKC         RXBOKC
     C                   MOVE      SLNKDN        RXLNKDN
     C                   MOVE      SBRKC         RXBRKC
     C                   MOVE      SUCUCY        RXUCUCY
     C                   MOVE      STCUCY        RXTCUCY
     C                   MOVE      SUICBS        RXUICBS
     C                   MOVE      STICBS        RXTICBS
     C                   MOVE      SPRFC         RXPRFC
     C                   MOVE      SORBR         RXORBR
     C                   MOVE      SVDEI         RXVDEI
     C                   MOVE      SMDEI         RXMDEI
     C                   MOVE      SPDEI         RXPDEI
     C                   MOVE      SUBRTT        RXUBRTT
     C                   MOVE      SUSPIN        RXUSPIN
     C                   MOVE      SUICFR        RXUICFR
     C                   MOVE      SUIPFR        RXUIPFR
     C                   MOVE      STBRTT        RXTBRTT
     C                   MOVE      STSPIN        RXTSPIN
     C                   MOVE      STICFR        RXTICFR
     C                   MOVE      STIPFR        RXTIPFR
     C                   MOVE      SCAIN         RXCAIN                         CSW097

      ** Taxable Indicator - default 'N' to file if blank entered.
     C     STAXI         IFEQ      'Y'
     C                   MOVE      'Y'           RXTAXI
     C                   ELSE
     C                   MOVE      'N'           RXTAXI
     C                   END

      **Federal Funds Indicator is a bit setting
     C     SUFFI         IFEQ      'Y'
     C                   BITON     '2'           RXUDSTI
     C                   END

     C     STFFI         IFEQ      'Y'
     C                   BITON     '2'           RXTDSTI
     C                   END
      *                                                                         CIR005
      ** Business Day Conventions cross currency fields                         CIR005
     C     CIR005        IFEQ      'Y'                                          CIR005
     C                   EVAL      RXBDY = BsDayConv                            CIR005
     C                   ENDIF                                                  CIR005
                                                                                              CLE025
     C     CLE025        IFEQ      'Y'                                                        CLE025
     C                   MOVE      RXBRCA        RBRCA                                        CLE025
     C**********         MOVE      RXDLNO        RDLNO                                CLE025 BUG8266
     C                   MOVE      SDLNO         RDLNO                                       BUG8266
     C                   MOVEL     SFCCU         RFCCU                                        CLE025
     C                   MOVE      SFACT         RFACT                                        CLE025
     C                   MOVE      SFCNO         RFCNO                                        CLE025
     C                   ENDIF                                                                CLE025
      *                                                                                       CDL038
      ** Class                                                                                CDL038
      *                                                                                       CDL038
     C                   MOVE      SCLAS         RXCLAS                                       CDL038

     C                   ENDSR
      *****************************************************************
      ***/EJECT                                                                        CAS001 226002
      *****************************************************************                CAS001 226002
      *****************************************************************                CAS001 226002
      **SrAccesYldC*-*Access*Yield*Curve*Details***********************                CAS001 226002
      *****************************************************************                CAS001 226002
      **Called*By*:****************************************************                CAS001 226002
      *****************************************************************                CAS001 226002
      **Calls*:********************************************************                CAS001 226002
      *****************************************************************                CAS001 226002
      *****************************************************************                CAS001 226002
     C*****SrAccesYldC   BEGSR                                                         CAS001 226002
      **********                                                                       CAS001 226002
      ***Get*details*via*calling*the*access*object*********************                CAS001 226002
      **********                                                                       CAS001 226002
     C**********         CALL      'AOYLDCR0'                                          CAS001 226002
     C**********         PARM      *BLANK        PRTCD             7                   CAS001 226002
     C**********         PARM      '*KEY   '     POPTN             7                   CAS001 226002
     C**********         PARM      WkYLDC        PYLDC             5                   CAS001 226002
     C*****SDYLDC        PARM      SDYLDC        DSFDY                                 CAS001 226002
      **********                                                                       CAS001 226002
     C**********         IF        PRTCD = *BLANKS                                     CAS001 226002
     C**********         IF        FSYLDT <> 'Z' OR FSINTP <> 'E'                      CAS001 226002
     C**********         EVAL      ReturnCode = 'Error'                                CAS001 226002
     C**********         EVAL      PERTP = '3'                                         CAS001 226002
     C**********         ENDIF                                                         CAS001 226002
     C**********         ENDIF                                                         CAS001 226002
      **********                                                                       CAS001 226002
     C**********         ENDSR                                                         CAS001 226002
      *****************************************************************                CAS001 226002
      /EJECT                                                                                MD053400
      *****************************************************************                     MD053400
      *                                                               *                     MD053400
      * SRRSFD  -  Restore orignal details (for Reject Action)        *                     MD053400
      *                                                               *                     MD053400
      *****************************************************************                     MD053400
     C     SRRSFD        BEGSR                                                              MD053400
      *                                                                                     MD053400
      ** Maturity Date                                                                      MD053400
      *                                                                                     MD053400
     C                   MOVE      SMDAT         ZDATE             6 0                      MD053400
     C                   MOVE      BJDFIN        ZDATFM            1                        MD053400
     C                   CALL      'ZDATE1'                                                 MD053400
     C                   PARM      *BLANKS       ZERR              7                        MD053400
     C                   PARM                    ZDATE                                      MD053400
     C                   PARM                    ZDATFM                                     MD053400
     C                   PARM                    ZDAYNO            5 0                      MD053400
     C                   Z-ADD     ZDAYNO        RXMDAT                                     MD053400
      *                                                                                     MD053400
      ** Base Currency Rate                                                                 MD053400
      *                                                                                     MD053400
     C                   MOVE      *BLANKS       @@ALPH                                     MD053400
     C                   MOVEL     SUBCXR        @@ALPH                                     MD053400
     C                   Z-ADD     8             @@IDP                                      MD053400
     C                   Z-ADD     5             @@IINT                                     MD053400
     C                   MOVE      'N'           @@MTID                                     MD053400
     C                   CALLB     'ZA0840'                                                 MD053400
     C                   PARM                    @Rtcde                                     MD053400
     C                   PARM                    @@ALPH                                     MD053400
     C                   PARM                    @@IDP                                      MD053400
     C                   PARM                    @@IINT                                     MD053400
     C                   PARM                    @@MTID                                     MD053400
     C                   PARM                    @@ERCD                                     MD053400
     C                   PARM                    @@AMT                                      MD053400
     C                   PARM                    BNDCSP                                     MD053400
     C                   MOVE      @@AMT         RXUBCXR                                    MD053400
      *                                                                                     MD053400
      ** Our Spread/Rate                                                                    MD053400
      *                                                                                     MD053400
     C                   Z-ADD     0             @@AMT                                      MD053400
     C                   Z-ADD     0             @@ERCD                                     MD053400
     C     SURTSP        IFNE      *BLANKS                                                  MD053400
     C                   MOVE      *BLANKS       @@ALPH                                     MD053400
     C                   MOVEL     SURTSP        @@ALPH                                     MD053400
     C                   Z-ADD     7             @@IDP                                      MD053400
     C                   Z-ADD     4             @@IINT                                     MD053400
     C                   MOVE      'N'           @@MTID                                     MD053400
     C                   MOVE      *BLANKS       @Rtcde                                     MD053400
     C                   CALLB     'ZA0841'                                                 MD053400
     C                   PARM                    @Rtcde                                     MD053400
     C                   PARM                    @@ALPH                                     MD053400
     C                   PARM                    @@IDP                                      MD053400
     C                   PARM                    @@IINT                                     MD053400
     C                   PARM                    @@MTID                                     MD053400
     C                   PARM                    @@ERCD                                     MD053400
     C                   PARM                    @@AMT                                      MD053400
     C                   PARM                    BNDCSP                                     MD053400
     C                   MOVE      @@AMT         RXURTSP                                    MD053400
     C                   ElSE                                                               MD053400
     C                   Z-ADD     0             RXURTSP                                    MD053400
     C                   ENDIF                                                              MD053400
      *                                                                                     MD053400
      ** Our Rate Fix Days                                                                  MD053400
      *                                                                                     MD053400
     C                   MOVE      *BLANK        ZFIELD                                     MD053400
     C                   Z-ADD     0             ZADEC                                      MD053400
     C                   Z-ADD     02            ZADIG                                      MD053400
     C                   MOVE      SUFRFD        ZFIELD                                     MD053400
     C                   CALLB     'ZALIGN'                                                 MD053400
     C                   PARM                    ZALIGNok                                   MD053400
     C                   PARM                    ZFIELD                                     MD053400
     C                   PARM                    ZADEC                                      MD053400
     C                   PARM                    ZADIG                                      MD053400
     C                   MOVE      ZFIELD        RXUFRFD                                    MD053400
      *                                                                                     MD053400
      ** Our Rate Change Date                                                               MD053400
      *                                                                                     MD053400
     C     SUNICD        IFNE      *BLANKS                                                  MD053400
     C                   MOVE      SUNICD        ZDATE                                      MD053400
     C                   MOVE      BJDFIN        ZDATFM                                     MD053400
     C                   CALL      'ZDATE1'                                                 MD053400
     C                   PARM      *BLANKS       ZERR                                       MD053400
     C                   PARM                    ZDATE                                      MD053400
     C                   PARM                    ZDATFM                                     MD053400
     C                   PARM                    ZDAYNO                                     MD053400
     C                   Z-ADD     ZDAYNO        RXUNICD                                    MD053400
     C                   ElSE                                                               MD053400
     C                   Z-ADD     0             RXUNICD                                    MD053400
     C                   ENDIF                                                              MD053400
      *                                                                                     MD053400
      ** Our Rate Change Day in Month                                                       MD053400
      *                                                                                     MD053400
     C                   MOVE      *BLANK        ZFIELD                                     MD053400
     C                   Z-ADD     0             ZADEC                                      MD053400
     C                   Z-ADD     02            ZADIG                                      MD053400
     C                   MOVE      SUICFD        ZFIELD                                     MD053400
     C                   CALLB     'ZALIGN'                                                 MD053400
     C                   PARM                    ZALIGNok                                   MD053400
     C                   PARM                    ZFIELD                                     MD053400
     C                   PARM                    ZADEC                                      MD053400
     C                   PARM                    ZADIG                                      MD053400
     C                   MOVE      ZFIELD        RXUICFD                                    MD053400
      *                                                                                     MD053400
      ** Our Short Term Rate                                                                MD053400
      *                                                                                     MD053400
     C                   Z-ADD     0             @@AMT                                      MD053400
     C                   Z-ADD     0             @@ERCD                                     MD053400
     C     SUEINR        IFNE      *BLANKS                                                  MD053400
     C                   MOVE      *BLANKS       @@ALPH                                     MD053400
     C                   MOVEL     SUEINR        @@ALPH                                     MD053400
     C                   Z-ADD     7             @@IDP                                      MD053400
     C                   Z-ADD     4             @@IINT                                     MD053400
     C                   MOVE      'N'           @@MTID                                     MD053400
     C                   MOVE      *BLANKS       @Rtcde                                     MD053400
     C                   CALLB     'ZA0841'                                                 MD053400
     C                   PARM                    @Rtcde                                     MD053400
     C                   PARM                    @@ALPH                                     MD053400
     C                   PARM                    @@IDP                                      MD053400
     C                   PARM                    @@IINT                                     MD053400
     C                   PARM                    @@MTID                                     MD053400
     C                   PARM                    @@ERCD                                     MD053400
     C                   PARM                    @@AMT                                      MD053400
     C                   PARM                    BNDCSP                                     MD053400
     C                   MOVE      @@AMT         RXUEINR                                    MD053400
     C                   ElSE                                                               MD053400
     C                   Z-ADD     0             RXUEINR                                    MD053400
     C                   ENDIF                                                              MD053400
      *                                                                                     MD053400
      ** Our Interest Payment Date                                                          MD053400
      *                                                                                     MD053400
     C     SUNIPD        IFNE      *BLANKS                                                  MD053400
     C                   MOVE      SUNIPD        ZDATE                                      MD053400
     C                   MOVE      BJDFIN        ZDATFM                                     MD053400
     C                   CALL      'ZDATE1'                                                 MD053400
     C                   PARM      *BLANKS       ZERR                                       MD053400
     C                   PARM                    ZDATE                                      MD053400
     C                   PARM                    ZDATFM                                     MD053400
     C                   PARM                    ZDAYNO                                     MD053400
     C                   Z-ADD     ZDAYNO        RXUNIPD                                    MD053400
     C                   ElSE                                                               MD053400
     C                   Z-ADD     0             RXUNIPD                                    MD053400
     C                   ENDIF                                                              MD053400
      *                                                                                     MD053400
      ** Our Interest Payment Day in Month                                                  MD053400
      *                                                                                     MD053400
     C                   MOVE      *BLANK        ZFIELD                                     MD053400
     C                   Z-ADD     0             ZADEC                                      MD053400
     C                   Z-ADD     02            ZADIG                                      MD053400
     C                   MOVE      SUIPFD        ZFIELD                                     MD053400
     C                   CALLB     'ZALIGN'                                                 MD053400
     C                   PARM                    ZALIGNok                                   MD053400
     C                   PARM                    ZFIELD                                     MD053400
     C                   PARM                    ZADEC                                      MD053400
     C                   PARM                    ZADIG                                      MD053400
     C                   MOVE      ZFIELD        RXUIPFD                                    MD053400
      *                                                                                     MD053400
      ** Base Currency Rate                                                                 MD053400
      *                                                                                     MD053400
     C                   MOVE      *BLANKS       @@ALPH                                     MD053400
     C                   MOVEL     STBCXR        @@ALPH                                     MD053400
     C                   Z-ADD     8             @@IDP                                      MD053400
     C                   Z-ADD     5             @@IINT                                     MD053400
     C                   MOVE      'N'           @@MTID                                     MD053400
     C                   CALLB     'ZA0840'                                                 MD053400
     C                   PARM                    @Rtcde                                     MD053400
     C                   PARM                    @@ALPH                                     MD053400
     C                   PARM                    @@IDP                                      MD053400
     C                   PARM                    @@IINT                                     MD053400
     C                   PARM                    @@MTID                                     MD053400
     C                   PARM                    @@ERCD                                     MD053400
     C                   PARM                    @@AMT                                      MD053400
     C                   PARM                    BNDCSP                                     MD053400
     C                   MOVE      @@AMT         RXTBCXR                                    MD053400
      *                                                                                     MD053400
      ** Their Spread/Rate                                                                  MD053400
      *                                                                                     MD053400
     C                   Z-ADD     0             @@AMT                                      MD053400
     C                   Z-ADD     0             @@ERCD                                     MD053400
     C     STRTSP        IFNE      *BLANKS                                                  MD053400
     C                   MOVE      *BLANKS       @@ALPH                                     MD053400
     C                   MOVEL     STRTSP        @@ALPH                                     MD053400
     C                   Z-ADD     7             @@IDP                                      MD053400
     C                   Z-ADD     4             @@IINT                                     MD053400
     C                   MOVE      'N'           @@MTID                                     MD053400
     C                   MOVE      *BLANKS       @Rtcde                                     MD053400
     C                   CALLB     'ZA0841'                                                 MD053400
     C                   PARM                    @Rtcde                                     MD053400
     C                   PARM                    @@ALPH                                     MD053400
     C                   PARM                    @@IDP                                      MD053400
     C                   PARM                    @@IINT                                     MD053400
     C                   PARM                    @@MTID                                     MD053400
     C                   PARM                    @@ERCD                                     MD053400
     C                   PARM                    @@AMT                                      MD053400
     C                   PARM                    BNDCSP                                     MD053400
     C                   MOVE      @@AMT         RXTRTSP                                    MD053400
     C                   ElSE                                                               MD053400
     C                   Z-ADD     0             RXTRTSP                                    MD053400
     C                   ENDIF                                                              MD053400
      *                                                                                     MD053400
      ** Their Rate Fix Days                                                                MD053400
      *                                                                                     MD053400
     C                   MOVE      *BLANK        ZFIELD                                     MD053400
     C                   Z-ADD     0             ZADEC                                      MD053400
     C                   Z-ADD     02            ZADIG                                      MD053400
     C                   MOVE      STFRFD        ZFIELD                                     MD053400
     C                   CALLB     'ZALIGN'                                                 MD053400
     C                   PARM                    ZALIGNok                                   MD053400
     C                   PARM                    ZFIELD                                     MD053400
     C                   PARM                    ZADEC                                      MD053400
     C                   PARM                    ZADIG                                      MD053400
     C                   MOVE      ZFIELD        RXTFRFD                                    MD053400
      *                                                                                     MD053400
      ** Their Rate Change Date                                                             MD053400
      *                                                                                     MD053400
     C     STNICD        IFNE      *BLANKS                                                  MD053400
     C                   MOVE      STNICD        ZDATE                                      MD053400
     C                   MOVE      BJDFIN        ZDATFM                                     MD053400
     C                   CALL      'ZDATE1'                                                 MD053400
     C                   PARM      *BLANKS       ZERR                                       MD053400
     C                   PARM                    ZDATE                                      MD053400
     C                   PARM                    ZDATFM                                     MD053400
     C                   PARM                    ZDAYNO                                     MD053400
     C                   Z-ADD     ZDAYNO        RXTNICD                                    MD053400
     C                   ElSE                                                               MD053400
     C                   Z-ADD     0             RXTNICD                                    MD053400
     C                   ENDIF                                                              MD053400
      *                                                                                     MD053400
      ** Their Rate Change Day in Month                                                     MD053400
      *                                                                                     MD053400
     C                   MOVE      *BLANK        ZFIELD                                     MD053400
     C                   Z-ADD     0             ZADEC                                      MD053400
     C                   Z-ADD     02            ZADIG                                      MD053400
     C                   MOVE      STICFD        ZFIELD                                     MD053400
     C                   CALLB     'ZALIGN'                                                 MD053400
     C                   PARM                    ZALIGNok                                   MD053400
     C                   PARM                    ZFIELD                                     MD053400
     C                   PARM                    ZADEC                                      MD053400
     C                   PARM                    ZADIG                                      MD053400
     C                   MOVE      ZFIELD        RXTICFD                                    MD053400
      *                                                                                     MD053400
      ** Their Short Term Rate                                                              MD053400
      *                                                                                     MD053400
     C                   Z-ADD     0             @@AMT                                      MD053400
     C                   Z-ADD     0             @@ERCD                                     MD053400
     C     STEINR        IFNE      *BLANKS                                                  MD053400
     C                   MOVE      *BLANKS       @@ALPH                                     MD053400
     C                   MOVEL     STEINR        @@ALPH                                     MD053400
     C                   Z-ADD     7             @@IDP                                      MD053400
     C                   Z-ADD     4             @@IINT                                     MD053400
     C                   MOVE      'N'           @@MTID                                     MD053400
     C                   MOVE      *BLANKS       @Rtcde                                     MD053400
     C                   CALLB     'ZA0841'                                                 MD053400
     C                   PARM                    @Rtcde                                     MD053400
     C                   PARM                    @@ALPH                                     MD053400
     C                   PARM                    @@IDP                                      MD053400
     C                   PARM                    @@IINT                                     MD053400
     C                   PARM                    @@MTID                                     MD053400
     C                   PARM                    @@ERCD                                     MD053400
     C                   PARM                    @@AMT                                      MD053400
     C                   PARM                    BNDCSP                                     MD053400
     C                   MOVE      @@AMT         RXTEINR                                    MD053400
     C                   ElSE                                                               MD053400
     C                   Z-ADD     0             RXTEINR                                    MD053400
     C                   ENDIF                                                              MD053400
      *                                                                                     MD053400
      ** Their Interest Payment Date                                                        MD053400
      *                                                                                     MD053400
     C     STNIPD        IFNE      *BLANKS                                                  MD053400
     C                   MOVE      STNIPD        ZDATE                                      MD053400
     C                   MOVE      BJDFIN        ZDATFM                                     MD053400
     C                   CALL      'ZDATE1'                                                 MD053400
     C                   PARM      *BLANKS       ZERR                                       MD053400
     C                   PARM                    ZDATE                                      MD053400
     C                   PARM                    ZDATFM                                     MD053400
     C                   PARM                    ZDAYNO                                     MD053400
     C                   Z-ADD     ZDAYNO        RXTNIPD                                    MD053400
     C                   ElSE                                                               MD053400
     C                   Z-ADD     0             RXTNIPD                                    MD053400
     C                   ENDIF                                                              MD053400
      *                                                                                     MD053400
      ** Their Interest Payment Day in Month                                                MD053400
      *                                                                                     MD053400
     C                   MOVE      *BLANK        ZFIELD                                     MD053400
     C                   Z-ADD     0             ZADEC                                      MD053400
     C                   Z-ADD     02            ZADIG                                      MD053400
     C                   MOVE      STIPFD        ZFIELD                                     MD053400
     C                   CALLB     'ZALIGN'                                                 MD053400
     C                   PARM                    ZALIGNok                                   MD053400
     C                   PARM                    ZFIELD                                     MD053400
     C                   PARM                    ZADEC                                      MD053400
     C                   PARM                    ZADIG                                      MD053400
     C                   MOVE      ZFIELD        RXTIPFD                                    MD053400
      *                                                                                     MD053400
      ** Our Yield Curve                                                                    MD053400
      *                                                                                     MD053400
     C                   MOVEL     SOYLC         RXOYLC                                     MD053400
      *                                                                                     MD053400
      ** Our Forward Yield Curve                                                            MD053400
      *                                                                                     MD053400
     C                   MOVEL     SOFYC         RXOFYC                                     MD053400
      *                                                                                     MD053400
      ** Their Yield Curve                                                                  MD053400
      *                                                                                     MD053400
     C                   MOVEL     STYLC         RXTYLC                                     MD053400
      *                                                                                     MD053400
      ** Their Forward Yield Curve                                                          MD053400
      *                                                                                     MD053400
     C                   MOVEL     STFYC         RXTFYC                                     MD053400
      *                                                                                     MD053400
      ** Start Date                                                                         MD053400
      *                                                                                     MD053400
     C     SOSDT         IFNE      *BLANKS                                                  MD053400
     C                   MOVE      SOSDT         ZDATE                                      MD053400
     C                   MOVE      BJDFIN        ZDATFM                                     MD053400
     C                   CALL      'ZDATE1'                                                 MD053400
     C                   PARM      *BLANKS       ZERR                                       MD053400
     C                   PARM                    ZDATE                                      MD053400
     C                   PARM                    ZDATFM                                     MD053400
     C                   PARM                    ZDAYNO                                     MD053400
     C                   Z-ADD     ZDAYNO        RXOSDT                                     MD053400
     C                   ElSE                                                               MD053400
     C                   Z-ADD     0             RXOSDT                                     MD053400
     C                   ENDIF                                                              MD053400
      *                                                                                     MD053400
      ** 1st Term Base Rate Code                                                            MD053400
      *                                                                                     MD053400
     C                   MOVE      *BLANK        ZFIELD                                     MD053400
     C                   Z-ADD     0             ZADEC                                      MD053400
     C                   Z-ADD     02            ZADIG                                      MD053400
     C                   MOVE      SOS1B         ZFIELD                                     MD053400
     C                   CALLB     'ZALIGN'                                                 MD053400
     C                   PARM                    ZALIGNok                                   MD053400
     C                   PARM                    ZFIELD                                     MD053400
     C                   PARM                    ZADEC                                      MD053400
     C                   PARM                    ZADIG                                      MD053400
     C                   MOVE      ZFIELD        RXOS1B                                     MD053400
      *                                                                                     MD053400
      ** 1st Term End Date                                                                  MD053400
      *                                                                                     MD053400
     C     SOS1D         IFNE      *BLANKS                                                  MD053400
     C                   MOVE      SOS1D         ZDATE                                      MD053400
     C                   MOVE      BJDFIN        ZDATFM                                     MD053400
     C                   CALL      'ZDATE1'                                                 MD053400
     C                   PARM      *BLANKS       ZERR                                       MD053400
     C                   PARM                    ZDATE                                      MD053400
     C                   PARM                    ZDATFM                                     MD053400
     C                   PARM                    ZDAYNO                                     MD053400
     C                   Z-ADD     ZDAYNO        RXOS1D                                     MD053400
     C                   ElSE                                                               MD053400
     C                   Z-ADD     0             RXOS1D                                     MD053400
     C                   ENDIF                                                              MD053400
      *                                                                                     MD053400
      ** 2nd Term Base Rate Code                                                            MD053400
      *                                                                                     MD053400
     C                   MOVE      *BLANK        ZFIELD                                     MD053400
     C                   Z-ADD     0             ZADEC                                      MD053400
     C                   Z-ADD     02            ZADIG                                      MD053400
     C                   MOVE      SOS2B         ZFIELD                                     MD053400
     C                   CALLB     'ZALIGN'                                                 MD053400
     C                   PARM                    ZALIGNok                                   MD053400
     C                   PARM                    ZFIELD                                     MD053400
     C                   PARM                    ZADEC                                      MD053400
     C                   PARM                    ZADIG                                      MD053400
     C                   MOVE      ZFIELD        RXOS2B                                     MD053400
      *                                                                                     MD053400
      ** 2nd Term End Date                                                                  MD053400
      *                                                                                     MD053400
     C     SOS2D         IFNE      *BLANKS                                                  MD053400
     C                   MOVE      SOS2D         ZDATE                                      MD053400
     C                   MOVE      BJDFIN        ZDATFM                                     MD053400
     C                   CALL      'ZDATE1'                                                 MD053400
     C                   PARM      *BLANKS       ZERR                                       MD053400
     C                   PARM                    ZDATE                                      MD053400
     C                   PARM                    ZDATFM                                     MD053400
     C                   PARM                    ZDAYNO                                     MD053400
     C                   Z-ADD     ZDAYNO        RXOS2D                                     MD053400
     C                   ElSE                                                               MD053400
     C                   Z-ADD     0             RXOS2D                                     MD053400
     C                   ENDIF                                                              MD053400
      *                                                                                     MD053400
      ** End Date                                                                           MD053400
      *                                                                                     MD053400
     C     SOEDT         IFNE      *BLANKS                                                  MD053400
     C                   MOVE      SOEDT         ZDATE                                      MD053400
     C                   MOVE      BJDFIN        ZDATFM                                     MD053400
     C                   CALL      'ZDATE1'                                                 MD053400
     C                   PARM      *BLANKS       ZERR                                       MD053400
     C                   PARM                    ZDATE                                      MD053400
     C                   PARM                    ZDATFM                                     MD053400
     C                   PARM                    ZDAYNO                                     MD053400
     C                   Z-ADD     ZDAYNO        RXOEDT                                     MD053400
     C                   ElSE                                                               MD053400
     C                   Z-ADD     0             RXOEDT                                     MD053400
     C                   ENDIF                                                              MD053400
      *                                                                                     MD053400
      ** 1st Term Base Rate Code                                                            MD053400
      *                                                                                     MD053400
     C                   MOVE      *BLANK        ZFIELD                                     MD053400
     C                   Z-ADD     0             ZADEC                                      MD053400
     C                   Z-ADD     02            ZADIG                                      MD053400
     C                   MOVE      SOE1B         ZFIELD                                     MD053400
     C                   CALLB     'ZALIGN'                                                 MD053400
     C                   PARM                    ZALIGNok                                   MD053400
     C                   PARM                    ZFIELD                                     MD053400
     C                   PARM                    ZADEC                                      MD053400
     C                   PARM                    ZADIG                                      MD053400
     C                   MOVE      ZFIELD        RXOE1B                                     MD053400
      *                                                                                     MD053400
      ** 1st Term End Date                                                                  MD053400
      *                                                                                     MD053400
     C     SOE1D         IFNE      *BLANKS                                                  MD053400
     C                   MOVE      SOE1D         ZDATE                                      MD053400
     C                   MOVE      BJDFIN        ZDATFM                                     MD053400
     C                   CALL      'ZDATE1'                                                 MD053400
     C                   PARM      *BLANKS       ZERR                                       MD053400
     C                   PARM                    ZDATE                                      MD053400
     C                   PARM                    ZDATFM                                     MD053400
     C                   PARM                    ZDAYNO                                     MD053400
     C                   Z-ADD     ZDAYNO        RXOE1D                                     MD053400
     C                   ElSE                                                               MD053400
     C                   Z-ADD     0             RXOE1D                                     MD053400
     C                   ENDIF                                                              MD053400
      *                                                                                     MD053400
      ** 2nd Term Base Rate Code                                                            MD053400
      *                                                                                     MD053400
     C                   MOVE      *BLANK        ZFIELD                                     MD053400
     C                   Z-ADD     0             ZADEC                                      MD053400
     C                   Z-ADD     02            ZADIG                                      MD053400
     C                   MOVE      SOE2B         ZFIELD                                     MD053400
     C                   CALLB     'ZALIGN'                                                 MD053400
     C                   PARM                    ZALIGNok                                   MD053400
     C                   PARM                    ZFIELD                                     MD053400
     C                   PARM                    ZADEC                                      MD053400
     C                   PARM                    ZADIG                                      MD053400
     C                   MOVE      ZFIELD        RXOE2B                                     MD053400
      *                                                                                     MD053400
      ** 2nd Term End Date                                                                  MD053400
      *                                                                                     MD053400
     C     SOE2D         IFNE      *BLANKS                                                  MD053400
     C                   MOVE      SOS2D         ZDATE                                      MD053400
     C                   MOVE      BJDFIN        ZDATFM                                     MD053400
     C                   CALL      'ZDATE1'                                                 MD053400
     C                   PARM      *BLANKS       ZERR                                       MD053400
     C                   PARM                    ZDATE                                      MD053400
     C                   PARM                    ZDATFM                                     MD053400
     C                   PARM                    ZDAYNO                                     MD053400
     C                   Z-ADD     ZDAYNO        RXOE2D                                     MD053400
     C                   ElSE                                                               MD053400
     C                   Z-ADD     0             RXOE2D                                     MD053400
     C                   ENDIF                                                              MD053400
      *                                                                                     MD053400
      ** End Date                                                                           MD053400
      *                                                                                     MD053400
     C     STSDT         IFNE      *BLANKS                                                  MD053400
     C                   MOVE      STSDT         ZDATE                                      MD053400
     C                   MOVE      BJDFIN        ZDATFM                                     MD053400
     C                   CALL      'ZDATE1'                                                 MD053400
     C                   PARM      *BLANKS       ZERR                                       MD053400
     C                   PARM                    ZDATE                                      MD053400
     C                   PARM                    ZDATFM                                     MD053400
     C                   PARM                    ZDAYNO                                     MD053400
     C                   Z-ADD     ZDAYNO        RXTSDT                                     MD053400
     C                   ElSE                                                               MD053400
     C                   Z-ADD     0             RXTSDT                                     MD053400
     C                   ENDIF                                                              MD053400
      *                                                                                     MD053400
      ** 1st Term Base Rate Code                                                            MD053400
      *                                                                                     MD053400
     C                   MOVE      *BLANK        ZFIELD                                     MD053400
     C                   Z-ADD     0             ZADEC                                      MD053400
     C                   Z-ADD     02            ZADIG                                      MD053400
     C                   MOVE      STS1B         ZFIELD                                     MD053400
     C                   CALLB     'ZALIGN'                                                 MD053400
     C                   PARM                    ZALIGNok                                   MD053400
     C                   PARM                    ZFIELD                                     MD053400
     C                   PARM                    ZADEC                                      MD053400
     C                   PARM                    ZADIG                                      MD053400
     C                   MOVE      ZFIELD        RXTS1B                                     MD053400
      *                                                                                     MD053400
      ** 1st Term End Date                                                                  MD053400
      *                                                                                     MD053400
     C     STS1D         IFNE      *BLANKS                                                  MD053400
     C                   MOVE      STS1D         ZDATE                                      MD053400
     C                   MOVE      BJDFIN        ZDATFM                                     MD053400
     C                   CALL      'ZDATE1'                                                 MD053400
     C                   PARM      *BLANKS       ZERR                                       MD053400
     C                   PARM                    ZDATE                                      MD053400
     C                   PARM                    ZDATFM                                     MD053400
     C                   PARM                    ZDAYNO                                     MD053400
     C                   Z-ADD     ZDAYNO        RXTS1D                                     MD053400
     C                   ElSE                                                               MD053400
     C                   Z-ADD     0             RXTS1D                                     MD053400
     C                   ENDIF                                                              MD053400
      *                                                                                     MD053400
      ** 2nd Term Base Rate Code                                                            MD053400
      *                                                                                     MD053400
     C     STS2B         IFNE      *BLANKS                                                  MD053400
     C                   MOVE      STS2B         ZDATE                                      MD053400
     C                   MOVE      BJDFIN        ZDATFM                                     MD053400
     C                   CALL      'ZDATE1'                                                 MD053400
     C                   PARM      *BLANKS       ZERR                                       MD053400
     C                   PARM                    ZDATE                                      MD053400
     C                   PARM                    ZDATFM                                     MD053400
     C                   PARM                    ZDAYNO                                     MD053400
     C                   Z-ADD     ZDAYNO        RXTS2B                                     MD053400
     C                   ElSE                                                               MD053400
     C                   Z-ADD     0             RXTS2B                                     MD053400
     C                   ENDIF                                                              MD053400
      *                                                                                     MD053400
      ** 2nd Term End Date                                                                  MD053400
      *                                                                                     MD053400
     C     STS2D         IFNE      *BLANKS                                                  MD053400
     C                   MOVE      STS2D         ZDATE                                      MD053400
     C                   MOVE      BJDFIN        ZDATFM                                     MD053400
     C                   CALL      'ZDATE1'                                                 MD053400
     C                   PARM      *BLANKS       ZERR                                       MD053400
     C                   PARM                    ZDATE                                      MD053400
     C                   PARM                    ZDATFM                                     MD053400
     C                   PARM                    ZDAYNO                                     MD053400
     C                   Z-ADD     ZDAYNO        RXTS2D                                     MD053400
     C                   ElSE                                                               MD053400
     C                   Z-ADD     0             RXTS2D                                     MD053400
     C                   ENDIF                                                              MD053400
      *                                                                                     MD053400
      ** End Date                                                                           MD053400
      *                                                                                     MD053400
     C     STEDT         IFNE      *BLANKS                                                  MD053400
     C                   MOVE      STEDT         ZDATE                                      MD053400
     C                   MOVE      BJDFIN        ZDATFM                                     MD053400
     C                   CALL      'ZDATE1'                                                 MD053400
     C                   PARM      *BLANKS       ZERR                                       MD053400
     C                   PARM                    ZDATE                                      MD053400
     C                   PARM                    ZDATFM                                     MD053400
     C                   PARM                    ZDAYNO                                     MD053400
     C                   Z-ADD     ZDAYNO        RXTEDT                                     MD053400
     C                   ElSE                                                               MD053400
     C                   Z-ADD     0             RXTEDT                                     MD053400
     C                   ENDIF                                                              MD053400
      *                                                                                     MD053400
      ** 1st Term Base Rate Code                                                            MD053400
      *                                                                                     MD053400
     C     STE1B         IFNE      *BLANKS                                                  MD053400
     C                   MOVE      STE1B         ZDATE                                      MD053400
     C                   MOVE      BJDFIN        ZDATFM                                     MD053400
     C                   CALL      'ZDATE1'                                                 MD053400
     C                   PARM      *BLANKS       ZERR                                       MD053400
     C                   PARM                    ZDATE                                      MD053400
     C                   PARM                    ZDATFM                                     MD053400
     C                   PARM                    ZDAYNO                                     MD053400
     C                   Z-ADD     ZDAYNO        RXTE1B                                     MD053400
     C                   ElSE                                                               MD053400
     C                   Z-ADD     0             RXTE1B                                     MD053400
     C                   ENDIF                                                              MD053400
      *                                                                                     MD053400
      ** 1st Term End Date                                                                  MD053400
      *                                                                                     MD053400
     C     STE1D         IFNE      *BLANKS                                                  MD053400
     C                   MOVE      STE1D         ZDATE                                      MD053400
     C                   MOVE      BJDFIN        ZDATFM                                     MD053400
     C                   CALL      'ZDATE1'                                                 MD053400
     C                   PARM      *BLANKS       ZERR                                       MD053400
     C                   PARM                    ZDATE                                      MD053400
     C                   PARM                    ZDATFM                                     MD053400
     C                   PARM                    ZDAYNO                                     MD053400
     C                   Z-ADD     ZDAYNO        RXTE1D                                     MD053400
     C                   ElSE                                                               MD053400
     C                   Z-ADD     0             RXTE1D                                     MD053400
     C                   ENDIF                                                              MD053400
      *                                                                                     MD053400
      ** 2nd Term Base Rate Code                                                            MD053400
      *                                                                                     MD053400
     C     STE2B         IFNE      *BLANKS                                                  MD053400
     C                   MOVE      STE2B         ZDATE                                      MD053400
     C                   MOVE      BJDFIN        ZDATFM                                     MD053400
     C                   CALL      'ZDATE1'                                                 MD053400
     C                   PARM      *BLANKS       ZERR                                       MD053400
     C                   PARM                    ZDATE                                      MD053400
     C                   PARM                    ZDATFM                                     MD053400
     C                   PARM                    ZDAYNO                                     MD053400
     C                   Z-ADD     ZDAYNO        RXTE2B                                     MD053400
     C                   ElSE                                                               MD053400
     C                   Z-ADD     0             RXTE2B                                     MD053400
     C                   ENDIF                                                              MD053400
      *                                                                                     MD053400
      ** 1st Term End Date                                                                  MD053400
      *                                                                                     MD053400
     C     STE1D         IFNE      *BLANKS                                                  MD053400
     C                   MOVE      STE1D         ZDATE                                      MD053400
     C                   MOVE      BJDFIN        ZDATFM                                     MD053400
     C                   CALL      'ZDATE1'                                                 MD053400
     C                   PARM      *BLANKS       ZERR                                       MD053400
     C                   PARM                    ZDATE                                      MD053400
     C                   PARM                    ZDATFM                                     MD053400
     C                   PARM                    ZDAYNO                                     MD053400
     C                   Z-ADD     ZDAYNO        RXTE1D                                     MD053400
     C                   ElSE                                                               MD053400
     C                   Z-ADD     0             RXTE1D                                     MD053400
     C                   ENDIF                                                              MD053400
     C                   ENDSR                                                              MD053400
      /EJECT
      *****************************************************************
      *                                                               *
      * #C       - Termination processing.                            *
      *                                                               *
      * CALLS             -                                           *
      *                                                               *
      * CALLED BY  MAIN   - Top level of program.                     *
      *                                                               *
      *****************************************************************
     C     #C            BEGSR
      *
      **  Terminate program
      *
     C     *INU7         IFEQ      '1'
     C                   DUMP
     C                   END
      *
     C                   RETURN
      *
     C     #C9           ENDSR
      /EJECT

      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,DBERREXIT
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      /EJECT
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001