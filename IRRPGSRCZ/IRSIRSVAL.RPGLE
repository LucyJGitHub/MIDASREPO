     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Single ccy IRS field validatn controller')    *
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Dealing Module                               *
      *                                                               *
      *  IRSIRSVAL  - Validate Single Currency Interest Rate Swaps    *
      *                                                               *
      *  Function: This Program Validates IRS Deals for Input into    *
      *            the Midas database.                                *
      *            The sequence of validation is based on subroutine  *
      *            VALD04 in Midas program DL1602.                    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD053400           Date 03Jul19               *
      *  Prev Amend No. MD051346           Date 17Jul18               *
      *                 MD046248           Date 27Oct17               *
      *                 MD030847           Date 03Dec14               *
      *                 CIR018             Date 25Nov14               *
      *                 CIR017             Date 10Apr14               *
      *                 245692             Date 11Dec13               *
      *                 AR569568           Date 22Nov12               *
      *                 262587             Date 17Sep10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CIR014             Date 11May06               *
      *                 BUG11457           Date 11May06               *
      *                 CSD031             Date 10Apr06               *
      *                 BUG8550            Date 05Oct05               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG10704           Date 13Mar06               *
      *                 BUG9717            Date 29Dec05               *
      *                 BUG8266            Date 08Sep05               *
      *                 CDL038             Date 10May05               *
      *                 BUG7325            Date 25May05               *
      *                 CDL029A            Date 09May05               *
      *                 CSW037A            Date 02May05               *
      *                 BUG6472            Date 22Apr05               *
      *                 CDL028             Date 07Feb05               *
      *                 CAS008             Date 16Jun04               *
      *                 226002             Date 24Mar04               *
      *                 225997             Date 24Mar04               *
      *                 BUG6124            Date 03Mar05               *
      *                 BUG5443            Date 24Feb05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CDL029             Date 23Nov04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 222373             Date 31Oct03               *
      *                 CAS005             Date 16Dec02               *
      *                 218641             Date 10Jun03               *
      *                 217684             Date 12May03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 186676             Date 27Mar02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP056             Date 13Mar02               *
      *                 CIR008             Date 13Mar02               *
      *                 CAP055             Date 13Mar02               *
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
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CIR005             Date 21Jan00               *
      *                 179732             Date 26Jun00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSW097             Date 02Dec99               *
      *                 164607             Date 19Jul99               *
      * Midas DBA 3.01 -----------------------------------------------*
      *                 168981             Date 20May99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CPL002             Date 08Mar99               *
      *                 CAP004             Date 09Sep98               *
      *                 CAP003  *CREATE    Date 06Jun98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD053400 - Details are not correctly reverted back when the  *
      *             amended transaction is rejected in WIP. Skip      *
      *             validation if action is Reject.                   *
      *  MD051346 - The system does not allow to change the maturity  *
      *             date in OIS deal.                                 *
      *           - Ensure zero short term rate is accepted by the    *
      *             system during amend of inserted OIS deals in the  *
      *             past.                                             *
      *  MD046248 - Finastra Rebranding                               *
      *  MD030847 - BFM2.1SP4.2_T2-Bug (critical): SIRS Input: THEIR  *
      *             short term rate 0 not able to release/authorise   *
      *             (remark: Kondor+ - imported SIRS).                *
      *           - No need to validate short term rate on authorise. *
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
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  CIR014 - Mark to Market Cross-currency Interest Rate Swaps   *
      *           (Recompile)                                         *
      *  BUG11457-Transaction ccy is not passed by callers            *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG8550 - Reposition capture of ZMUSER data area             *
      *            (fix included in CDL038)                           *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10704 - If entered transaction customer is not valid      *
      *             or does not exist in file, validation of          *
      *             customer VS branch must not be carried out.       *
      *  BUG9717- Defaulting of class should be done when CDL038      *
      *           feature is currently ON.                            *
      *  BUG8266- Serious Midas error occur.DlNo in extension file    *
      *           is zero.                                            *
      *  CDL038 - Extended Deal Sub Type                              *
      *  BUG7325- Do not call IRVRTCHGDT in authorise mode            *
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
      *         - LHX010 added a new Interest Calulation Method 7.    *
      *           This now needs to use IntCalcMeth 8 since 7 is used *
      *           in Core.                                            *
      *           Core Hooks Used :                                   *
      *           IRSIRSV032      IRSIRSV033      IRSIRSV034          *
      *           IRSIRSV035                                          *
      *  CLE025 - Credit Lines                                        *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  222373 - Correct parameters on program calls                 *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *  218641 - Adjust Yield Curve field position in the definition *
      *           file                                                *
      *  217684 - Authorisation User Malfunction (Recompile)          *
      *  186676 - Call new IRVDEALTPS to validate the deal type/      *
      *           subtype combination.                                *
      *  CAP056 - Automatic Authorisation of Interface deals          *
      *           (Recompile)                                         *
      *  CIR008 - FRA/IRS Deals Authorisation (Recompile)             *
      *  CAP055 - APIs for FRA/IRS Caps/Collars/Floors                *
      *           Add extra parameter to IRVRTFXDAY and IRVSPRRATE    *
      *           modules                                             *
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
      *  CIR005 - FRA/IRS Business Day Conventions.                   *
      *  179732 - Only validate profit centre if not Blank OR         *
      *           Only allocate profit centre if the book code and    *
      *           deal subtype are entered.                           *
      *  CSW097 - SWIFT 1997 Changes for FRAIRS MT34* and MT36*.      *
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
      /COPY WNCPYSRC,IRSIRSV087
 
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
     D  QQACC1       E                     EXTFLD(QQACCD)                                     CGL029
      *
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
      ** EXTERNAL DS FOR RETAIL DETAILS
     D  QQACC2       E                     EXTFLD(QQACCD)                                     CGL029
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
      *
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS
      *
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS
     D  QQACC3       E                     EXTFLD(QQACCD)                                     CGL029
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
     D  QQDFA1       E                     EXTFLD(QQDFAC)                                     CGL029
 
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
 
     D ValidDeal     E DS                  EXTNAME(IRVSIRSPD)
      * Valid Deals layout
     D  VldBsDyC            2063   2126                                         CIR005
      ** Business Day Convention Single Currency fields file format             CIR005
                                                                                              CIR017
     D  VldBsDyC2           2127   2190                                                       CIR017
      ** Business Day Convention Single Currency fields file format Leg 2                     CIR017
                                                                                              CSC011
     D ValidXDeal    E DS                  EXTNAME(IRVXSIRPD)                                 CLE025
      * Valid Deals layout                                                                    CLE025
                                                                                              CLE025
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
      ** 24X7 status data area                                                                CSC011
                                                                                              CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
      ** SD data area                                                                         CSC011
 
     D ZMUSER          DS            17
     D  BRC                   11     13
     D  DEPT                  14     16
 
     D TranIn        E DS                  EXTNAME(IRSIRSPD)
      * Incoming Transaction
                                                                                CAP004
     D*BsDayConv*************208    271                                                CIR005 218641
     D*BsDayConv*************213    276                                                218641 CAS005
     D*BsDayConv*************228    291                                                CAS005 CLE025
     D BsDayConv             243    306                                                       CLE025
      ** Single Currency Business Day Conventions layout                        CIR005
                                                                                CIR005
     D BsDayConv2            457    520                                                       CIR017
      ** Single CCY Business Day Conventions layout - Their Side details                      CIR017
      **                                                                                      CIR017
     D**PayCurr**************208    237                                                CIR005 218641
     D**PayCurr**************213    242                                                218641 CAS005
     D**PayCurr**************228    257                                                CAS005 CLE025
     D  PayCurr              243    272                                                       CLE025
      ** Currencies for Payment Conventions Leg1                                CIR005
                                                                                CIR005
     D**RateCurr*************242    271                                                CIR005 218641
     D**RateCurr*************247    276                                                218641 CAS005
     D**RateCurr*************262    291                                                CAS005 CLE025
     D  RateCurr             277    306                                                       CLE025
      ** Currencies for Rate Fixing Conventions Leg1                            CIR005
                                                                                CIR005
      ** Establish Pay and Rate Fix Currency - Leg 2                                          CIR017
     D  PayCurr2             457    486                                                       CIR017
      ** Currencies for Payment Conventions - Leg 2                                           CIR017
      **                                                                                      CIR017
     D  RateCurr2            491    520                                                       CIR017
      ** Currencies for Rate Fixing Conventions - Leg 2                                       CIR017
      **                                                                                      CIR017
     D ExtData       E DS                  EXTNAME(IRSSEXPD)                    CAP004
      * IR SIRS Extra Data - File (D/B) format                                  CAP004
                                                                                              185057
      * (Current) Deal in Screen Format                                                       185057
     D DealScnFmt    E DS                  EXTNAME(IRSIRSPD)                                  185057
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
                                                                                CIR005
      ** Validate Business Day Convention flag                                  CIR005
     D  WValBDC        S              1A                                        CIR005
                                                                                CIR005
      ** Index for arrays of error message ids etc                              CIR005
     D Ix              S                   LIKE(Idx)                            CIR005
                                                                                CIR005
      ** Array for error message ids                                            CIR005
     D MsgIdErr        S                   DIM(ArrayMax)                        CIR005
     D                                     LIKE(#MsgID)                         CIR005
                                                                                CIR005
      ** Array for fields in error                                              CIR005
     D FldNamErr       S             10A   DIM(ArrayMax)                        CIR005
                                                                                CIR005
      ** Array for error message ids                                            CIR005
     D WMsgIdErr       S                   DIM(ArrayMax)                        CIR005
     D                                     LIKE(MsgIdArr)                       CIR005
                                                                                CIR005
      ** Array for fields in error                                              CIR005
     D WFldNamErr      S                   DIM(ArrayMax)                        CIR005
     D                                     LIKE(FldNameArr)                     CIR005
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
 
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
     D  SUCucyOK                      1A
     D  SUPamtOK                      1A
     D  SUFfiOK                       1A
     D  SUBcxrOK                      1A
     D  SBokCOK                       1A
     D  STaxiOK                       1A
     D  SPrfCOK                       1A
     D  SOrBrOK                       1A
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
     D  SUIcbsOK                      1A
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
     D  OKOYLC                        1A                                                      CAS001
     D  OKTYLC                        1A                                                      CAS005
     D  OKOFYC                        1A                                                      CAS005
     D  OKTFYC                        1A                                                      CAS005
     D  SFCCUOK                       1A                                                      CLE025
     D  SFACTOK                       1A                                                      CLE025
     D  SFCNOOK                       1A                                                      CLE025
     D  OKFlgPay1                    10A                                        CIR005
     D  OKPayDat1                     1A                                        CIR005
     D  OKAmtCde1                     1A                                        CIR005
     D  OKFlgRte1                    10A                                        CIR005
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
      ** OK Flags - Currencies for Payment Convention Leg2                                    CIR017
     D  OKFlgPay2                    10A                                                      CIR017
      ** OK Flags - Payment and Amount Convention Leg2                                        CIR017
     D  OKPayDat2                     1A                                                      CIR017
     D  OKAmtCde2                     1A                                                      CIR017
      ** OK Flags - Currencies for Rate Fixing Convention Leg2                                CIR017
     D  OKFlgRte2                    10A                                                      CIR017
      **                                                                                      CIR017
 
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
 
      ** Extended Settlement fields used by IRVIRSVDAT
     D PMERCD          S            150A
     D***PMPONS*         S             12A                                                    CGL029
     D PMPONS          S             18A                                                      CGL029
     D PMPSTM          S              2S 0
     D***PMRONS*         S             12A                                                    CGL029
     D PMRONS          S             18A                                                      CGL029
     D PMRSTM          S              2S 0
 
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
     D IRS             S              4A   INZ('SIRS')
 
      ** Dummy parameters used in the call to IRVMATDATE
      ** (these parms are used when validating Cross-ccy IRS only)
     D STCUCY          S              3A   INZ(*BLANK)
     D StCuCyOK        S              1A   INZ('N')
 
      ** Average Rate Method, required by various modules for Caps/Collars
      ** (Not used in this program)
     D SAVRAM          S              1A   INZ('N')
 
      ** Response Mode, received as a parameter from the common header
     D RespMode        S              1A
 
      ** Amount field in 15,0 format required by MMVAMOUNT
     D Amount15        S             15  0
                                                                                CIR005
      ** Mode of operation received from controller                             CIR005
     D ModeOfOp        S              6A                                        CIR005
 
      ** Separate Business Day Convention for SIRS                                            CIR017
     D CIR017          S              1A                                                      CIR017
     D BusDaySide      S                   LIKE(BsDayConv)                                    CIR017
      **                                                                                      CIR017
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
     DPFCRv            S              1A                                                      CAS008
     DPFwYC            S              5A                                                      CAS005
     DWkSOFYC          S              5A                                                      CAS005
     DWkSTFYC          S              5A                                                      CAS005
                                                                                              CAS001
      ** Define fields used in CAS005                                                         CAS005
                                                                                              CAS005
     D CAS005          S              1A                                                      CAS005
     D CLE025          S              1A                                                      CLE025
     D Module          S              4A                                                      CLE025
                                                                                              CDL029
      ** Fields defined for Enhancement CDL029                                                CDL029
     D CDL029          S              1A                                                      CDL029
                                                                                              CAS005
      ** Fields defined for Enhancement CDL028                                                CDL028
     D CDL028          S              1A                                                      CDL028
     D CDL038          S              1A                                                     BUG9717
                                                                                            AR569568
     D CDL006          S              1A                                                    AR569568
                                                                                            AR569568
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
      /COPY WNCPYSRC,IRSIRSV088
 
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
 
      /COPY WNCPYSRC,IRSIRSV001                                                 CAP004
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
 
      /COPY WNCPYSRC,IRSIRSV002                                                 CAP004
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
 
      /COPY WNCPYSRC,IRSIRSV003                                                 CAP004
                                                                                CAP004
      *  *------------------------*
      *  * Validate Branch Code   *  #02
      *  *------------------------*
     C                   EXSR      RESETERRS
 
      /COPY WNCPYSRC,IRSIRSV004                                                 CAP004
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
     C                   PARM                    RSBRCA
     C                   PARM                    SDBRCH
 
     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SBRCA'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
      *****                                                                           CDL029 BUG6124
     C*****              IF        CDL029 ='Y'                                        CDL029 BUG6124
      *****                                                                           CDL029 BUG6124
     C*****KBRANCHAUTH   CHAIN     SDABBCL0                           91              CDL029 BUG6124
     C*****              IF        *IN91 = '1'                                        CDL029 BUG6124
     C*****              EVAL      ReturnCode = 'Error'                               CDL029 BUG6124
     C*****              ADD       1             Idx                                  CDL029 BUG6124
     C*****              EVAL      FldNameArr(Idx) = 'SBRCA'                          CDL029 BUG6124
     C*****              EVAL      MsgIDArr(Idx) = 'FXM7001'                          CDL029 BUG6124
     C*****              END                                                          CDL029 BUG6124
      *****                                                                           CDL029 BUG6124
     C*****              END                                                          CDL029 BUG6124
      *****                                                                           CDL029 BUG6124
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    SBRCAOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
      /COPY WNCPYSRC,IRSIRSV005                                                 CAP004
                                                                                CAP004
      *  *------------------------*
      *  * Validate Deal Date     *  #03
      *  *------------------------*
 
     C                   EXSR      RESETERRS
 
      /COPY WNCPYSRC,IRSIRSV006                                                 CAP004
                                                                                CAP004
     C                   CALLB     'MMVDLDATE'
     C                   PARM                    ReturnCode
     C                   PARM                    Msg1
     C                   PARM                    Msg2
     C                   PARM                    WMsgid1
     C                   PARM                    RSDDAT
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
 
      /COPY WNCPYSRC,IRSIRSV007                                                 CAP004
                                                                                CAP004
      *  *------------------------*
      *  * Validate Broker Code   *  #04
      *  *------------------------*
     C                   EXSR      RESETERRS
 
      /COPY WNCPYSRC,IRSIRSV008                                                 CAP004
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
 
      /COPY WNCPYSRC,IRSIRSV009                                                 CAP004
                                                                                CAP004
      *  *------------------------*
      *  * Validate Brokerage     *  #05
      *  *------------------------*
     C                   EXSR      RESETERRS
 
      /COPY WNCPYSRC,IRSIRSV010                                                 CAP004
                                                                                CAP004
     C                   CALLB     'ZAVBROKAGE'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    MSG2
     C                   PARM                    SBrkCOK
     C                   PARM                    SBRKC
     C                   PARM                    SBAGE
     C                   PARM                    A9BRCY
     C                   PARM                    RSBAGE
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
 
      /COPY WNCPYSRC,IRSIRSV011                                                 CAP004
                                                                                CAP004
      *  *----------------------------------*
      *  * Validate Linked Reference Number *  #06
      *  *----------------------------------*
     C                   EXSR      RESETERRS
 
      /COPY WNCPYSRC,IRSIRSV012                                                 CAP004
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
 
      /COPY WNCPYSRC,IRSIRSV013                                                 CAP004
                                                                                CAP004
      *  *------------------------*
      *  * Validate Customer      *  #07
      *  *------------------------*
     C                   EXSR      RESETERRS
 
      /COPY WNCPYSRC,IRSIRSV014                                                 CAP004
                                                                                CAP004
     C                   CALLB     'IRVCUSTNUM'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    SCNUM
     C                   PARM                    SDCUST
     C                   PARM                    ACTNCD                                       CSD025
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
     C                   MOVE      BBCUST        RSCNUM
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
      *                                                                                      BUG6124
      /COPY WNCPYSRC,IRSIRSV015                                                 CAP004
                                                                                CAP004
      *  *------------------------*
      *  * Validate Value Date    *  #08
      *  *------------------------*
     C                   EXSR      RESETERRS
 
      /COPY WNCPYSRC,IRSIRSV016                                                 CAP004
                                                                                CAP004
     C                   CALLB     'IRVIRSVDAT'
     C                   PARM                    ReturnCode
     C                   PARM                    Msg1
     C                   PARM                    WMsgid1
     C                   PARM                    WMsgid2
     C                   PARM                    SVDAT
     C                   PARM                    SDDAT
     C                   PARM                    RSVDAT
     C                   PARM                    MidasDDat
     C                   PARM                    BJDFIN
     C**********         PARM                    BJRDNB                                       CSC011
     C                   PARM                    WRunday                                      CSC011
     C                   PARM                    BJLCCY
     C                   PARM                    BJSLCD
     C                   PARM                    SUCUCY
     C                   PARM                    SUCUCY
      ** Deal settlement instruction fields
     C                   PARM                    RecSetCcy
     C                   PARM                    RecSetMeth                     rec settle meth
     C                   PARM                    RecNostro
     C                   PARM                    PaySetCcy
     C                   PARM                    PaySetMeth                     pay settle meth
     C                   PARM                    PayNostro
     C/COPY WNCPYSRC,IRH00082
 
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
 
      /COPY WNCPYSRC,IRSIRSV017                                                 CAP004
                                                                                CAP004
      *  *-------------------*
      *  * Validate Currency *  #09
      *  *-------------------*
     C                   EXSR      RESETERRS
 
      /COPY WNCPYSRC,IRSIRSV018                                                 CAP004
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
     C                   ENDIF
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    SuCucyOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
      /COPY WNCPYSRC,IRSIRSV019                                                 CAP004
                                                                                CAP004
      *  *------------------------*
      *  * Validate Maturity Date *  #10
      *  *------------------------*
     C                   EXSR      RESETERRS
 
      /COPY WNCPYSRC,IRSIRSV020                                                 CAP004
                                                                                CAP004
     C                   CALLB     'IRVMATDATE'
     C                   PARM                    ReturnCode
     C                   PARM                    Msg1
     C                   PARM                    WMsgid1
     C                   PARM                    WMsgid2
     C                   PARM                    SMDAT
     C                   PARM                    RSVDAT
     C                   PARM                    SUCUCY
     C                   PARM                    BJLCCY
     C                   PARM                    BJSLCD
     C                   PARM                    SAVRAM
     C**********         PARM                    BJRDNB                                       CSC011
     C                   PARM                    WRunDay                                      CSC011
     C                   PARM                    BJDFIN
     C                   PARM                    SVDatOK
     C                   PARM                    SuCucyOK
     C                   PARM                    RSMDAT
      ** Dummy parameters set up when validating Cross-ccy IRS only
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
     C     RSMDAT        IFLT      PUSLIP                                                     184560
     C     RSMDAT        ORLT      PTSLIP                                                     184560
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
 
      /COPY WNCPYSRC,IRSIRSV021                                                 CAP004
                                                                                CAP004
      *  *-----------------------------------*
      *  * Validate Account Sequence Number  *  #11
      *  *-----------------------------------*
     C                   EXSR      RESETERRS
 
      /COPY WNCPYSRC,IRSIRSV022                                                 CAP004
                                                                                CAP004
     C                   CALLB     'MMVACSEQ'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    SCDAS
     C                   PARM                    RSCDAS
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
 
      /COPY WNCPYSRC,IRSIRSV023                                                 CAP004
                                                                                CAP004
      *  *-------------------*
      *  * Validate Amount   *  #12
      *  *-------------------*
     C                   EXSR      RESETERRS
 
      /COPY WNCPYSRC,IRSIRSV024                                                 CAP004
                                                                                CAP004
     C                   CALLB     'MMVAMOUNT'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    SUPAMT
     C                   PARM                    SuCucyOK
     C                   PARM                    A6NBDP
     C                   PARM                    SDTYP
     C                   PARM                    Amount15
      ** Currency separator (1A, from SDDEALPD, via caller)
     C                   PARM                    BNDCSP
     C                   PARM                    SAccd                                      AR569568
     C                   PARM                    CDL006                                     AR569568
 
     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SUPAMT'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ELSE
      ** Set up output field in 13,0 format
     C                   Z-ADD     Amount15      RSUPAMT
     C                   ENDIF
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    SuPAmtOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
      /COPY WNCPYSRC,IRSIRSV025                                                 CAP004
                                                                                CAP004
      *  *----------------------------------*
      *  * Validate Federal funds indicator *  #13
      *  *----------------------------------*
     C                   EXSR      RESETERRS
      /COPY WNCPYSRC,IRSIRSV026                                                 CAP004
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
 
      /COPY WNCPYSRC,IRSIRSV027                                                 CAP004
                                                                                CAP004
      *  *--------------------------------------*
      *  * Validate Base Currency Exchange Rate *  #14
      *  *--------------------------------------*
      *                                                                                       221963
     C     ACTNCD        IFEQ      'I'                                                        221963
     C     ACTNCD        OREQ      'A'                                                        221963
     C     RSORED        ANDEQ     BJRDNB                                                     221963
     C     ACTNCD        OREQ      'A'                                                        221963
     C     RSORED        ANDNE     BJRDNB                                                     221963
     C     SUBCXR        ANDNE     @SUBCXR                                                    221963
      *                                                                                       221963
     C                   EXSR      RESETERRS
 
      /COPY WNCPYSRC,IRSIRSV028                                                 CAP004
                                                                                CAP004
     C                   CALLB     'IRVBCURRAT'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    SUBCXR
     C                   PARM                    A6SPRT
     **Constants passed in by calling programme.
     C                   PARM                    SUCUCY
     C                   PARM                    BJCYCD
     C                   PARM                    RSUBCXR
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
      *                                                                                       221963
     C                   ENDIF                                                                221963
 
      /COPY WNCPYSRC,IRSIRSV029                                                 CAP004
                                                                                CAP004
      *  *------------------------*
      *  * Validate Book Code     *  #15
      *  *------------------------*
     C                   EXSR      RESETERRS
 
      /COPY WNCPYSRC,IRSIRSV030                                                 CAP004
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
 
      /COPY WNCPYSRC,IRSIRSV031                                                 CAP004
                                                                                CAP004
      *  *----------------------------*                                                       CLE025
      *  * Validate Facility Details  *                                                       CLE025
      *  *----------------------------*                                                       CLE025
                                                                                              CLE025
     C     CLE025        IFEQ      'Y'                                                        CLE025
     C                   EXSR      RESETERRS                                                  CLE025
                                                                                              CLE025
     C                   MOVEA     *Blanks       FldNamErr                                    CLE025
     C                   MOVEA     *Blanks       MsgIdErr                                     CLE025
     C                   MOVEA     *Blanks       WFldNamErr                                   CLE025
     C                   MOVEA     *Blanks       WMsgIdErr                                    CLE025
                                                                                              CLE025
     C                   CALLB     'IRVFACNUM'                                                CLE025
     C                   PARM                    RetCodeIn                                    CLE025
                                                                                              CLE025
      ** INPUTS                                                                               CLE025
      ** Module                                                                               CLE025
      ** Action Code                                                                          CLE025
      ** Transaction Customer                                                                 CLE025
      ** Branch                                                                               CLE025
      ** Deal Type                                                                            CLE025
      ** Deal Subtype                                                                         CLE025
      ** Deal Class                                                                           CDL038
     C                   PARM      'SIRS'        Module                                       CLE025
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
     C                   PARM      *BLANKS       STCUCY                                       CLE025
     C                   PARM                    RSDDAT                                       CLE025
     C                   PARM                    SMDAT                                        CLE025
     C                   PARM                    RSMDAT                                       CLE025
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
     C                   PARM      'Y'           STCUCYOK                                     CLE025
                                                                                              CLE025
      ** OUTPUTS                                                                              CLE025
      ** OK fields of facility                                                                CLE025
     C                   PARM                    SFCCUOK                                      CLE025
     C                   PARM                    SFACTOK                                      CLE025
     C                   PARM                    SFCNOOK                                      CLE025
                                                                                              CLE025
      ** Error fields/message IDs/message data (arrays) from/to c                             CLE025
     C                   PARM                    FldNamErr                                    CLE025
     C                   PARM                    MsgIdErr                                     CLE025
     C                   PARM                    WFldNamErr                                   CLE025
     C                   PARM                    WMsgIdErr                                    CLE025
                                                                                              CLE025
      ** Log error messages                                                                   CLE025
                                                                                              CLE025
     C                   EVAL      Ix = 1                                                     CLE025
     C                   DOW       FldNamErr(Ix) <> *Blanks                                   CLE025
     C                   EVAL      Idx = Idx + 1                                              CLE025
     C                   EVAL      FldNameArr(Idx) = FldNamErr(Ix)                            CLE025
     C                   EVAL      MsgIdArr(Idx) = MsgIdErr(Ix)                               CLE025
     C                   EVAL      Ix = Ix + 1                                                CLE025
     C                   ENDDO                                                                CLE025
                                                                                              CLE025
      ** Log warning messages                                                                 CLE025
                                                                                              CLE025
     C                   EVAL      Ix = 1                                                     CLE025
     C                   DOW       FldNamErr(Ix) <> *Blanks                                   CLE025
     C                   EVAL      WIdx = WIdx + 1                                            CLE025
     C                   EVAL      WFldNamArr(WIdx) = WFldNamErr(Ix)                          CLE025
     C                   EVAL      WMsgIdArr(WIdx) = WMsgIdErr(Ix)                            CLE025
     C                   EVAL      Ix = Ix + 1                                                CLE025
     C                   ENDDO                                                                CLE025
                                                                                              CLE025
     C                   MOVEA     *Blanks       FldNamErr                                    CLE025
     C                   MOVEA     *Blanks       MsgIdErr                                     CLE025
                                                                                              CLE025
     C                   ENDIF                                                                CLE025
                                                                                              CLE025
      *  *------------------------------------------*
      *  * Validate Our Interest Calculation Basis  *  #16
      *  *------------------------------------------*
     C                   EXSR      RESETERRS
 
      /COPY WNCPYSRC,IRSIRSV032                                                 CAP004
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
 
      /COPY WNCPYSRC,IRSIRSV033                                                 CAP004
                                                                                CAP004
      ** If CAS001 is on, validate yield curve                                                CAS001
                                                                                              CAS001
     C                   IF        CAS001 = 'Y' AND                                           CAS001
     C                             SDlstOK = 'Y' AND                                          CDL038
     C                             SCLasOK = 'Y'                                              CDL038
     C*****************************SDlstOK = 'Y'                                       CAS001 CDL038
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
     C                   PARM      *BLANKS       RSOYLC                                       CAS001
                                                                                              CAS001
     C**********         IF        ReturnCode = *BLANK                                 CAS001 226002
     C**********         CLEAR                   WkYLDC            5                   CAS001 226002
     C**********         EVAL      WkYLDC = RSOYLC                                     CAS001 226002
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
     C                   PARM      *BLANKS       RSOFYC                                       CAS005
                                                                                              CAS005
      ** Prevent defaulting if the leg is not attached to a base rate                         CAS005
                                                                                              CAS005
     C                   IF        SUBRTT = *BLANKS OR SUBRTT = '00'                          CAS005
     C                   IF        WkSOFYC = *BLANKS                                          CAS005
     C                   EVAL      SOFYC = *BLANKS                                            CAS005
     C                   EVAL      RSOFYC = *BLANKS                                           225997
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
     C                   IF        (SUBRTT = *BLANKS OR SUBRTT = '00') AND                    CAS005
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
     C                   ENDIF                                                                CAS001
                                                                                              CAS001
      *  *--------------------------------------------*
      *  * Validate Their Interest Calculation Basis  *  #16.5
      *  *--------------------------------------------*
     C                   EXSR      RESETERRS
 
      /COPY WNCPYSRC,IRSIRSV034                                                 CAP004
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
 
      /COPY WNCPYSRC,IRSIRSV035                                                 CAP004
                                                                                CAP004
      ** If CAS005 is on, validate yield curve                                                CAS005
                                                                                              CAS005
     C                   IF        CAS005 = 'Y' AND                                           CAS005
     C                             SDlstOK = 'Y' AND                                          CDL038
     C                             SCLasOK = 'Y'                                              CDL038
     C*****************************SDlstOK = 'Y'                                       CAS005 CDL038
                                                                                              CAS005
      *  *----------------------------*                                                       CAS005
      *  * Validate Their Yield Curve *                                                       CAS005
      *  *----------------------------*                                                       CAS005
                                                                                              CAS005
     C                   EXSR      RESETERRS                                                  CAS005
                                                                                              CAS005
     C                   CALLB     'ZAVYLDC01'                                                CAS005
     C                   PARM                    ReturnCode                                   CAS005
     C                   PARM                    SDTYP                                        CAS005
     C                   PARM                    SDLST                                        CAS005
     C                   PARM                    SCLAS                                        CDL038
     C                   PARM                    STYLC                                        CAS005
     C                   PARM      'DDTYLC'      PYcFn                                        CAS005
     C                   PARM      'R'           PFwRv                                        CAS005
     C                   PARM                    STFYC                                        CAS005
     C                   PARM      *BLANKS       PFCRv                                        CAS008
     C                   PARM      'Y'           OKTYLC                                       CAS005
                                                                                              CAS005
      ** Error Type                                                                           CAS005
                                                                                              CAS005
     C                   PARM      *BLANKS       PErTp                                        CAS005
                                                                                              CAS005
      ** Yield Curve                                                                          CAS005
                                                                                              CAS005
     C                   PARM      *BLANKS       RSTYLC                                       CAS005
                                                                                              CAS005
     C**********         IF        ReturnCode = *BLANK                                 CAS005 226002
     C**********         CLEAR                   WkYLDC                                CAS005 226002
     C**********         EVAL      WkYLDC = RSTYLC                                     CAS005 226002
     C**********         EXSR      SrAccesYldC                                         CAS005 226002
     C**********         ENDIF                                                         CAS005 226002
                                                                                              CAS005
     C                   IF        ReturnCode <> *BLANK                                       CAS005
     C                   EVAL      Idx = Idx + 1                                              CAS005
     C                   EVAL      FldNameArr(Idx) = 'STYLC'                                  CAS005
                                                                                              CAS005
     C                   SELECT                                                               CAS005
     C                   WHEN      PERTP = '1'                                                CAS005
     C                   EVAL      MsgIDArr(Idx) = 'FXM5056'                                  CAS005
     C**********         WHEN      PERTP = '3'                                         CAS005 226002
     C**********         EVAL      MsgIDArr(Idx) = 'FXM5059'                           CAS005 226002
     C                   WHEN      PERTP = '4'                                                CAS005
     C                   EVAL      MsgIDArr(Idx) = 'RS00062'                                  CAS005
     C                   OTHER                                                                CAS005
     C                   EVAL      MsgIDArr(Idx) = 'FXM5058'                                  CAS005
     C                   ENDSL                                                                CAS005
                                                                                              CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
      ** Use the return code's value to set the field's OK flag                               CAS005
                                                                                              CAS005
     C                   CALLB     'ZASETOKFLG'                                               CAS005
     C                   PARM                    OKTYLC                                       CAS005
     C                   PARM                    ReturnCode                                   CAS005
     C                   PARM                    WarnGlobal                                   CAS005
                                                                                              CAS005
      *  *------------------------------------*                                               CAS005
      *  * Validate Their Forward Yield Curve *                                               CAS005
      *  *------------------------------------*                                               CAS005
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
     C                   PARM      *BLANKS       RSTFYC                                       CAS005
                                                                                              CAS005
      ** Prevent defaulting if the leg is not attached to a base rate                         CAS005
                                                                                              CAS005
     C                   IF        STBRTT = *BLANKS OR STBRTT = '00'                          CAS005
     C                   IF        WkSTFYC = *BLANKS                                          CAS005
     C                   EVAL      STFYC = *BLANKS                                            CAS005
     C                   EVAL      RSTFYC = *BLANKS                                           225997
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
     C                   IF        (STBRTT = *BLANKS OR STBRTT = '00') AND                    CAS005
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
                                                                                              CAS005
      *  *----------------------------*
      *  * Validate Taxable Indicator *  #17
      *  *----------------------------*
     C                   EXSR      RESETERRS
 
      /COPY WNCPYSRC,IRSIRSV036                                                 CAP004
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
 
      /COPY WNCPYSRC,IRSIRSV037                                                 CAP004
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
 
      /COPY WNCPYSRC,IRSIRSV038                                                 CAP004
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
     C                   PARM                    BGN0st
 
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
 
      /COPY WNCPYSRC,IRSIRSV039                                                 CAP004
                                                                                CAP004
      * Endif statement for SBokCOK and SDlstOK = 'Y'                           179732
     C                   ENDIF                                                  179732
      *                                                                         179732
      *  *-----------------------------*
      *  * Validate Originating Branch *  #19
      *  *-----------------------------*
     C                   EXSR      RESETERRS
 
      /COPY WNCPYSRC,IRSIRSV040                                                 CAP004
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
 
      /COPY WNCPYSRC,IRSIRSV041                                                 CAP004
                                                                                CAP004
      *  *------------------------------*
      *  * Validate Our Base Rate Code  *  #20
      *  *------------------------------*
     C                   EXSR      RESETERRS
 
      /COPY WNCPYSRC,IRSIRSV042                                                 CAP004
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
 
      /COPY WNCPYSRC,IRSIRSV043                                                 CAP004
                                                                                CAP004
      *  *------------------------------*
      *  * Validate Our Spread Rate     *  #21
      *  *------------------------------*
     C                   EXSR      RESETERRS
 
      /COPY WNCPYSRC,IRSIRSV044                                                 CAP004
                                                                                CAP004
     C                   CALLB     'IRVSPRRATE'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    SURTSP
     C                   PARM                    CIR001
     C                   PARM                    SUIPFR
     C                   PARM                    SUBRTT
     C                   PARM      SDTYP         PDealTyp                                     CAP055
     C                   PARM                    RSURTSP
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
 
      /COPY WNCPYSRC,IRSIRSV045                                                 CAP004
                                                                                CAP004
      *  *-------------------------------*
      *  * Validate Our Spread Indicator *  #22
      *  *-------------------------------*
     C                   EXSR      RESETERRS
 
      /COPY WNCPYSRC,IRSIRSV046                                                 CAP004
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
 
      /COPY WNCPYSRC,IRSIRSV047                                                 CAP004
                                                                                CAP004
      *  *----------------------------*
      *  * Validate Our Rate Fix Days *  #23
      *  *----------------------------*
     C                   EXSR      RESETERRS
 
      /COPY WNCPYSRC,IRSIRSV048                                                 CAP004
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
     C                   PARM                    RSUFRFD
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
 
      /COPY WNCPYSRC,IRSIRSV049                                                 CAP004
                                                                                CAP004
      *  *-------------------------------*
      *  * Validate Our Rate Change Date *  #24
      *  *-------------------------------*
     C                   EXSR      RESETERRS
                                                                                CIR005
      ** Business Day Convention enhancement is switched on and this            CIR005
      ** module is called from CTL module, validate business day con            CIR005
      ** ventions fields.                                                       CIR005
                                                                                CIR005
     C                   IF        (CIR005 = 'Y') And (ModeOfOp = '*FRONT')     CIR005
     C                   MOVEA     *Blanks       FldNamErr                      CIR005
     C                   MOVEA     *Blanks       MsgIdErr                       CIR005
     C                   MOVEA     *Blanks       WFldNamErr                     CIR005
     C                   MOVEA     *Blanks       WMsgIdErr                      CIR005
     C                   Z-ADD     *Zero         ErrorCnt          2 0                        CIR017
                                                                                CIR005
     C                   CALLB     'IRVBDYCCY'   PIrvBDyCcy                     CIR005
                                                                                CIR005
      ** Log error messages                                                     CIR005
                                                                                CIR005
     C                   EVAL      Ix = 1                                       CIR005
     C                   DOW       FldNamErr(Ix) <> *Blanks                     CIR005
     C                   EVAL      Idx = Idx + 1                                CIR005
     C                   MOVE      '1'           WSuffix           1            CIR005
     C                   CAT(P)    WSuffix:0     FldNamErr(Ix)                  CIR005
     C                   EVAL      FldNameArr(Idx) = FldNamErr(Ix)              CIR005
     C                   EVAL      MsgIdArr(Idx) = MsgIdErr(Ix)                 CIR005
      **                                                                                      CIR017
      ** For CIR017, check if errors in 'Our details' Business Day Convention                 CIR017
     C                   IF        CIR017 = 'Y'                                               CIR017
     C                   ADD       1             ErrorCnt                                     CIR017
     C                   ENDIF                                                                CIR017
      *                                                                                       CIR017
     C                   EVAL      Ix = Ix + 1                                  CIR005
     C                   ENDDO                                                  CIR005
                                                                                CIR005
      ** Log warning messages                                                   CIR005
                                                                                CIR005
     C                   EVAL      Ix = 1                                       CIR005
     C                   DOW       FldNamErr(Ix) <> *Blanks                     CIR005
     C                   EVAL      WIdx = WIdx + 1                              CIR005
     C                   MOVE      '1'           WSuffix           1            CIR005
     C                   CAT(P)    WSuffix:0     FldNamErr(Ix)                  CIR005
     C                   EVAL      WFldNamArr(WIdx) = WFldNamErr(Ix)            CIR005
     C                   EVAL      WMsgIdArr(WIdx) = WMsgIdErr(Ix)              CIR005
     C                   EVAL      Ix = Ix + 1                                  CIR005
     C                   ENDDO                                                  CIR005
     C                                                                          CIR005
     C                   MOVEA     *Blanks       FldNamErr                      CIR005
     C                   MOVEA     *Blanks       MsgIdErr                       CIR005
     C                                                                          CIR005
     C                   CALLB     'IRVPAMCNV'   PIrvPAmCnv                     CIR005
                                                                                CIR005
      ** Log error messages                                                     CIR005
                                                                                CIR005
     C                   EVAL      Ix = 1                                       CIR005
     C                   DOW       FldNamErr(Ix) <> *Blanks                     CIR005
     C                   EVAL      Idx = Idx + 1                                CIR005
     C                   MOVE      '1'           WSuffix                        CIR005
     C                   CAT(P)    WSuffix:0     FldNamErr(Ix)                  CIR005
     C                   EVAL      FldNameArr(Idx) = FldNamErr(Ix)              CIR005
     C                   EVAL      MsgIdArr(Idx) = MsgIdErr(Ix)                 CIR005
      **                                                                                      CIR017
      ** For CIR017, check if errors in 'Our details' Business Day Convention                 CIR017
     C                   IF        CIR017 = 'Y'                                               CIR017
     C                   ADD       1             ErrorCnt                                     CIR017
     C                   ENDIF                                                                CIR017
      *                                                                                       CIR017
     C                   EVAL      Ix = Ix + 1                                  CIR005
     C                   ENDDO                                                  CIR005
     C                   ENDIF                                                  CIR005
 
      /COPY WNCPYSRC,IRSIRSV050                                                 CAP004
                                                                                CAP004
      ** If CIR005 = ON AND CIR017 = ON and the validation has been called from               CIR017
      ** Single Currency IRS API Input validate Leg2 Convention Fields                        CIR017
                                                                                              CIR017
      ** NOTE: When IRSIRSVAL is called from the SIRS Input/Repair                            CIR017
      **       IRSBDYVAL is used to manage the Convention and Currency fields.                CIR017
      **       But for API function (managed by CTL module), code separately                  CIR017
      **       to avoid blanking out the fields when they are controlled by IRSBDYVAL         CIR017
                                                                                              CIR017
 B1  C                   If        CIR005 = 'Y' And CIR017 = 'Y'                              CIR017
 B1  C                   IF        ModeOfOp ='*FRONT'                                         CIR017
      *                                                                                       CIR017
      ** If no errors in 'Our Side' Business Day Convention validation,                       CIR017
      ** and 'Their Side' was left blank, default Our details to Their Details                CIR017
      *                                                                                       CIR017
     C                   IF        ErrorCnt = 0  AND BsDayConv2 = *BLANKS                     CIR017
     C                   EVAL      BsDayConv2 = BsDayConv                                     CIR017
      *                                                                                       CIR017
      ** If there are errors in Our details, proceed to validate Their Details                CIR017
      *                                                                                       CIR017
     C                   ELSE                                                                 CIR017
      *                                                                                       CIR017
      ** Validate 'Their details' Rate Fixing and Payment Convention currencies               CIR017
      *                                                                                       CIR017
     C                   MOVEA     *Blanks       FldNamErr                                    CIR017
     C                   MOVEA     *Blanks       MsgIdErr                                     CIR017
     C                   MOVEA     *Blanks       WFldNamErr                                   CIR017
     C                   MOVEA     *Blanks       WMsgIdErr                                    CIR017
                                                                                              CIR017
     C                   CALLB     'IRVBDYCCY'   PIrvBDyCcy2                                  CIR017
                                                                                              CIR017
      ** Log error messages                                                                   CIR017
                                                                                              CIR017
     C                   EVAL      Ix = 1                                                     CIR017
     C                   DOW       FldNamErr(Ix) <> *Blanks                                   CIR017
     C                   EVAL      Idx = Idx + 1                                              CIR017
     C                   MOVE      '2'           WSuffix                                      CIR017
     C                   CAT(P)    WSuffix:0     FldNamErr(Ix)                                CIR017
     C                   EVAL      FldNameArr(Idx) = FldNamErr(Ix)                            CIR017
     C                   EVAL      MsgIdArr(Idx) = MsgIdErr(Ix)                               CIR017
     C                   EVAL      Ix = Ix + 1                                                CIR017
     C                   ENDDO                                                                CIR017
                                                                                              CIR017
      ** Log warning messages                                                                 CIR017
                                                                                              CIR017
     C                   EVAL      Ix = 1                                                     CIR017
     C                   DOW       FldNamErr(Ix) <> *Blanks                                   CIR017
     C                   EVAL      WIdx = WIdx + 1                                            CIR017
     C                   MOVE      '2'           WSuffix           1                          CIR017
     C                   CAT(P)    WSuffix:0     FldNamErr(Ix)                                CIR017
     C                   EVAL      WFldNamArr(WIdx) = WFldNamErr(Ix)                          CIR017
     C                   EVAL      WMsgIdArr(WIdx) = WMsgIdErr(Ix)                            CIR017
     C                   EVAL      Ix = Ix + 1                                                CIR017
     C                   ENDDO                                                                CIR017
      *                                                                                       CIR017
      ** Validate Their Payment Date and Amount Convention                                    CIR017
      *                                                                                       CIR017
     C                   MoveA     *Blanks       FldNamErr                                    CIR017
     C                   MoveA     *Blanks       MsgIdErr                                     CIR017
                                                                                              CIR017
     C                   CallB     'IRVPAMCNV'   PIrvPAmCnv2                                  CIR017
                                                                                              CIR017
     C                   Eval      Ix = 1                                                     CIR017
 B3  C                   DoW       FldNamErr(Ix) <> *Blanks                                   CIR017
     C                   Eval      Idx = Idx + 1                                              CIR017
     C                   Cat (P)   '2':0         FldNamErr(Ix)                                CIR017
     C                   Eval      FldNameArr(Idx) = FldNamErr(Ix)                            CIR017
     C                   Eval      MsgIdArr(Idx) = MsgIdErr(Ix)                               CIR017
     C                   Eval      Ix = Ix + 1                                                CIR017
 E3  C                   EndDo                                                                CIR017
      *                                                                                       CIR017
      ** End IF ErrorCnt > 0                                                                  CIR017
     C                   ENDIF                                                                CIR017
                                                                                              CIR017
      ** End IF ModeOfOp                                                                      CIR017
     C                   ENDIF                                                                CIR017
                                                                                              CIR017
      ** Else CIR017 = OFF, set Leg2 fields to *blanks                                        CIR017
 X2  C                   Else                                                                 CIR017
     C                   EVAL      BsDayConv2 = *Blanks                                       CIR017
 E2  C                   EndIf                                                                CIR017
      *                                                                                       CIR017
     C                   EVAL      PRatChgFq = SUICFR                                         CIR007
                                                                                              CIR007
      ** Validate Leg1 Rate Change Date using Leg1 Bus Day Convention fields                  CIR017
      ** No code change required for CIR017                                                   CIR017
      *                                                                                       CIR017
      * Do not call IRVRTCHGDT in authorise mode                                             BUG7325
     C                   If        ACTNCD <> 'X'                                             BUG7325
     C                   move      *Blanks       POred             5                          CIR018
     C                   move      RSORED        POred                                        CIR018
     C                   CALLB     'IRVRTCHGDT'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    WMsgid1
     C                   PARM                    WMsgid2
     C                   PARM                    WMsgid3                        CIR005
     C                   PARM                    WMsgData                       CIR005
     C                   PARM                    RSUNICD
     C                   PARM                    SUNICD
     C                   PARM                    SUBRTT
     C**********         PARM                    BJRDNB                                       CSC011
     C                   PARM                    WRunDay                                      CSC011
     C                   PARM                    RSVDAT
     C                   PARM                    RSMDAT
     C                   PARM                    BQCRFH
     C                   PARM                    BJLCCY
     C                   PARM                    BLCYCD
     C                   PARM                    BJSLCD
     C                   PARM                    SUCUCY
     C                   PARM                    RSUFRFD
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
     C                   PARM                    ModeOfOp                       CIR005
     C                   PARM                    WValBDC                        CIR005
     C                   PARM                    BsDayConv                      CIR005
     C                   PARM                    @SUFRFD                                      185057
     C                   PARM                    @SUNICD                                      185057
     C                   PARM                    PRatChgFq                                    CIR007
     C                   PARM      SDTYP         PDealTyp                                     CIR007
     C                   PARM                    CIR007                                       CIR007
     C                   PARM                    SACCD                                        CIR018
     C                   PARM                    POred                                        CIR018
 
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
                                                                                CIR005
     C     WMSGID3       IFNE      *BLANK                                       CIR005
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
 
      /COPY WNCPYSRC,IRSIRSV051                                                 CAP004
                                                                                CAP004
      *  *------------------------------------*
      *  * Validate Our Rate Change Frequency *  #25
      *  *------------------------------------*
     C                   EXSR      RESETERRS
 
      /COPY WNCPYSRC,IRSIRSV052                                                 CAP004
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
 
      /COPY WNCPYSRC,IRSIRSV053                                                 CAP004
                                                                                CAP004
      *  *-------------------------------------------------*
      *  * Validate Our Rate Change Frequency Day in Month *  #26
      *  *-------------------------------------------------*
     C                   EXSR      RESETERRS
 
      /COPY WNCPYSRC,IRSIRSV054                                                 CAP004
                                                                                CAP004
     C                   CALLB     'IRVRTCHGDY'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    SUICFR
     C                   PARM                    SUNICD
     C                   PARM                    SUICFD
     C                   PARM                    RSUNICD
     C** Day number passed back from module (needed for Caps/Collars but
     C** not used in this program)
     C                   PARM                    ZDAYX
     C                   PARM                    RSUICFD
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
 
      /COPY WNCPYSRC,IRSIRSV055                                                 CAP004
                                                                                CAP004
      *  *------------------------------*
      *  * Validate Our Short Term Rate *  #27
      *  *------------------------------*
     C                   EXSR      RESETERRS
 
      /COPY WNCPYSRC,IRSIRSV056                                                 CAP004
                                                                                CAP004
      * No need to validate Short Term Rate when 'Authorise' mode.                          MD030847
     C                   If        ACTNCD <> 'X'                                            MD030847
     C                   EVAL      PRatChgFq = SUICFR                                         CIR007
                                                                                              CIR007
     C                   CALLB     'IRVSTERMRT'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    SVDatOK
     C                   PARM                    SuCuCyOK
     C                   PARM                    SuFRFDOK
     C                   PARM                    SuBRTTOK
     C                   PARM                    RSVDAT
     C                   PARM                    BJLCCY
     C                   PARM                    BLCYCD
     C                   PARM                    BQCRFH
     C                   PARM                    BJSLCD
     C**********         PARM                    BJRDNB                                       CSC011
     C                   PARM                    WRunDay                                      CSC011
     C                   PARM                    SUEINR
     C                   PARM                    SUBRTT
     C                   PARM                    RSUFRFD
     C                   PARM                    RSUEINR
     C                   PARM                    ModeOfOp                       CIR005
     C                   PARM                    WValBDC                        CIR005
     C                   PARM                    RateCurr                       CIR005
     C                   PARM                    PRatChgFq                                    CIR007
     C                   PARM      SDTYP         PDealTyp                                     CIR007
     C                   PARM                    CIR007                                       CIR007
     C                   PARM                    SAVRAM                                       222373
      ** Sign of Our Short Term Rate                                                         BUG6472
     C                   PARM                    SUSSGN                                      BUG6472
     C                   PARM                    BNDCSP                                       245692
     C                   PARM                    RSORED                                     MD051346
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
 
      *                                                                                     MD030847
     C                   ENDIF                                                              MD030847
      *                                                                                     MD030847
      /COPY WNCPYSRC,IRSIRSV057                                                 CAP004
                                                                                CAP004
      *  *------------------------------------*
      *  * Validate Our Interest Payment Date *  #28
      *  *------------------------------------*
     C                   EXSR      RESETERRS
 
      /COPY WNCPYSRC,IRSIRSV058                                                 CAP004
                                                                                CAP004
     C                   CALLB     'IRVINTPYDT'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    SUNIPD
     C                   PARM                    RSVDAT
     C                   PARM                    RSMDAT
     C                   PARM                    SVDatOK
     C                   PARM                    SMDatOK
     C                   PARM                    RSUNIPD
     C***********        PARM                    BJDFIN                         CIR005
     C                   PARM                    RSUNICD
     C** Average Rate Method (parameter from Caps/Collars input
     C** not used in this program)
     C                   PARM                    SAVRAM
     C                   PARM                    RSUICFD
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
     C                   PARM                    PayCurr                        CIR005
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
     C     WMsgId1       IFNE      *BLANK                                       CIR005
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
 
      /COPY WNCPYSRC,IRSIRSV059                                                 CAP004
                                                                                CAP004
      *  *-----------------------------------------*
      *  * Validate Our Interest Payment Frequency *  #29
      *  *-----------------------------------------*
     C                   EXSR      RESETERRS
 
      /COPY WNCPYSRC,IRSIRSV060                                                 CAP004
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
 
      /COPY WNCPYSRC,IRSIRSV061                                                 CAP004
                                                                                CAP004
      *  *------------------------------------------------------*
      *  * Validate Our Interest Payment Frequency Day in Month *  #30
      *  *------------------------------------------------------*
     C                   EXSR      RESETERRS
 
      /COPY WNCPYSRC,IRSIRSV062                                                 CAP004
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
     C                   PARM                    RSUIPFD
     C                   PARM                    RSUNICD
     C                   PARM                    RSUNIPD
     C                   PARM                    RSUICFD
 
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
 
      /COPY WNCPYSRC,IRSIRSV063                                                 CAP004
                                                                                CAP004
      *  *--------------------------------*
      *  * Validate their Base Rate Code  *  #30
      *  *--------------------------------*
     C                   EXSR      RESETERRS
 
      /COPY WNCPYSRC,IRSIRSV064                                                 CAP004
                                                                                CAP004
     C                   EVAL      PRatChgFq = STICFR                                         CIR007
                                                                                              CIR007
     C                   CALLB     'IRVBRATCDE'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    MSG2
     C                   PARM                    STBRTT
     C                   PARM                    SuCuCyOK
     C                   PARM                    SUCUCY
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
 
      /COPY WNCPYSRC,IRSIRSV065                                                 CAP004
                                                                                CAP004
      *  *--------------------------------*
      *  * Validate their Spread Rate     *  #31
      *  *--------------------------------*
     C                   EXSR      RESETERRS
 
      /COPY WNCPYSRC,IRSIRSV066                                                 CAP004
                                                                                CAP004
     C                   CALLB     'IRVSPRRATE'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    STRTSP
     C                   PARM                    CIR001
     C                   PARM                    STIPFR
     C                   PARM                    STBRTT
     C                   PARM      SDTYP         PDealTyp                                     CAP055
     C                   PARM                    RSTRTSP
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
 
      /COPY WNCPYSRC,IRSIRSV067                                                 CAP004
                                                                                CAP004
      *  *---------------------------------*
      *  * Validate their Spread Indicator *  #32
      *  *---------------------------------*
     C                   EXSR      RESETERRS
 
      /COPY WNCPYSRC,IRSIRSV068                                                 CAP004
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
 
      /COPY WNCPYSRC,IRSIRSV069                                                 CAP004
                                                                                CAP004
      *  *------------------------------*
      *  * Validate their Rate Fix Days *  #33
      *  *------------------------------*
     C                   EXSR      RESETERRS
 
      /COPY WNCPYSRC,IRSIRSV070                                                 CAP004
                                                                                CAP004
     C                   EVAL      PRatChgFq = STICFR                                         CIR007
                                                                                              CIR007
     C                   CALLB     'IRVRTFXDAY'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    STFRFD
     C                   PARM                    STBRTT
     C                   PARM                    SUCUCY
     C                   PARM                    BLCYCD
     C                   PARM                    BJLCCY
     C                   PARM                    RSTFRFD
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
 
      /COPY WNCPYSRC,IRSIRSV071                                                 CAP004
                                                                                CAP004
      *  *---------------------------------*
      *  * Validate their Rate Change Date *  #34
      *  *---------------------------------*
     C                   EXSR      RESETERRS
 
      /COPY WNCPYSRC,IRSIRSV072                                                 CAP004
                                                                                CAP004
     C                   EVAL      PRatChgFq = STICFR                                         CIR007
                                                                                              CIR007
      ** IF CIR017 is ON validate Their Rate Change date using Their                          CIR017
      ** Business Day Convention fields                                                       CIR017
      *                                                                                       CIR017
     C                   IF        CIR017 = 'N'                                               CIR017
     C                   MOVEL     BsDayConv     BusDaySide                                   CIR017
     C                   ELSE                                                                 CIR017
     C                   MOVEL     BsDayConv2    BusDaySide                                   CIR017
     C                   END                                                                  CIR017
      *
      * Do not call IRVRTCHGDT in authorise mode                                             BUG7325
     C                   If        ACTNCD <> 'X'                                             BUG7325
     C                   move      *Blanks       POred                                        CIR018
     C                   move      RSORED        POred                                        CIR018
     C                   CALLB     'IRVRTCHGDT'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    WMsgid1
     C                   PARM                    WMsgid2
     C                   PARM                    WMsgid3                        CIR005
     C                   PARM                    WMsgData                       CIR005
     C                   PARM                    RSTNICD
     C                   PARM                    STNICD
     C                   PARM                    STBRTT
     C**********         PARM                    BJRDNB                                       CSC011
     C                   PARM                    WRunDay                                      CSC011
     C                   PARM                    RSVDAT
     C                   PARM                    RSMDAT
     C                   PARM                    BQCRFH
     C                   PARM                    BJLCCY
     C                   PARM                    BLCYCD
     C                   PARM                    BJSLCD
     C                   PARM                    SUCUCY
     C                   PARM                    RSTFRFD
     C                   PARM                    SVDatOK
     C                   PARM                    SMDatOK
     C                   PARM                    StFrFdOK
     C                   PARM                    SuCuCyOK
     C                   PARM                    BJDFIN
     C** Day number passed back from module (needed for Caps/Collars but
     C** not used in this program)
     C                   PARM                    ZDAYX
     C** Average Rate Method (parameter from Caps/Collars input
     C** not used in this program)
     C                   PARM                    SAVRAM
     C                   PARM                    ModeOfOp                       CIR005
     C                   PARM                    WValBDC                        CIR005
     C**********         PARM                    BsDayConv                             CIR005 CIR017
     C                   PARM                    BusDaySide                                   CIR017
     C                   PARM                    @STFRFD                                      185057
     C                   PARM                    @STNICD                                      185057
     C                   PARM                    PRatChgFq                                    CIR007
     C                   PARM      SDTYP         PDealTyp                                     CIR007
     C                   PARM                    CIR007                                       CIR007
     C                   PARM                    SACCD                                        CIR018
     C                   PARM                    POred                                        CIR018
 
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
     C                   ADD       1             Widx
     C                   EVAL      WFldNamArr(WIdx) = 'STNICD'
     C                   EVAL      WMsgIDArr(WIdx) = WMSGID2
     C                   ENDIF
                                                                                CIR005
     C     WMSGID3       IFNE      *BLANK                                       CIR005
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
 
      /COPY WNCPYSRC,IRSIRSV073                                                 CAP004
                                                                                CAP004
      *  *--------------------------------------*
      *  * Validate their Rate Change Frequency *  #35
      *  *--------------------------------------*
     C                   EXSR      RESETERRS
 
      /COPY WNCPYSRC,IRSIRSV074                                                 CAP004
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
 
      /COPY WNCPYSRC,IRSIRSV075                                                 CAP004
                                                                                CAP004
      *  *---------------------------------------------------*
      *  * Validate their Rate Change Frequency Day in Month *  #36
      *  *---------------------------------------------------*
     C                   EXSR      RESETERRS
 
      /COPY WNCPYSRC,IRSIRSV076                                                 CAP004
                                                                                CAP004
     C                   CALLB     'IRVRTCHGDY'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    STICFR
     C                   PARM                    STNICD
     C                   PARM                    STICFD
     C                   PARM                    RSTNICD
     C** Day number passed back from module (needed for Caps/Collars but
     C** not used in this program)
     C                   PARM                    ZDAYX
     C                   PARM                    RSTICFD
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
 
      /COPY WNCPYSRC,IRSIRSV077                                                 CAP004
                                                                                CAP004
      *  *--------------------------------*
      *  * Validate their Short Term Rate *  #37
      *  *--------------------------------*
     C                   EXSR      RESETERRS
 
      /COPY WNCPYSRC,IRSIRSV078                                                 CAP004
                                                                                CAP004
      * No need to validate Short Term Rate when 'Authorise' mode.                          MD030847
     C                   If        ACTNCD <> 'X'                                            MD030847
      *                                                                                     MD030847
     C                   EVAL      PRatChgFq = STICFR                                         CIR007
                                                                                              CIR007
     C                   CALLB     'IRVSTERMRT'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    SVDatOK
     C                   PARM                    SuCuCyOK
     C                   PARM                    StFRFDOK
     C                   PARM                    StBRTTOK
     C                   PARM                    RSVDAT
     C                   PARM                    BJLCCY
     C                   PARM                    BLCYCD
     C                   PARM                    BQCRFH
     C                   PARM                    BJSLCD
     C**********         PARM                    BJRDNB                                       CSC011
     C                   PARM                    WRunDay                                      CSC011
     C                   PARM                    STEINR
     C                   PARM                    STBRTT
     C                   PARM                    RSTFRFD
     C                   PARM                    RSTEINR
     C                   PARM                    ModeOfOp                       CIR005
     C                   PARM                    WValBDC                        CIR005
     C                   PARM                    RateCurr                       CIR005
     C                   PARM                    PRatChgFq                                    CIR007
     C                   PARM      SDTYP         PDealTyp                                     CIR007
     C                   PARM                    CIR007                                       CIR007
     C                   PARM                    SAVRAM                                       222373
      ** Sign of Their Short Term Rate                                                       BUG6472
     C                   PARM                    STSSGN                                      BUG6472
     C                   PARM                    BNDCSP                                       245692
     C                   PARM                    RSORED                                     MD051346
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
      *                                                                                     MD030847
     C                   ENDIF                                                              MD030847
 
      /COPY WNCPYSRC,IRSIRSV079                                                 CAP004
                                                                                CAP004
      *  *--------------------------------------*
      *  * Validate their Interest Payment Date *  #38
      *  *--------------------------------------*
     C                   EXSR      RESETERRS
 
      /COPY WNCPYSRC,IRSIRSV080                                                 CAP004
                                                                                CAP004
     C                   CALLB     'IRVINTPYDT'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    STNIPD
     C                   PARM                    RSVDAT
     C                   PARM                    RSMDAT
     C                   PARM                    SVDatOK
     C                   PARM                    SMDatOK
     C                   PARM                    RSTNIPD
     C***********        PARM                    BJDFIN                         CIR005
     C                   PARM                    RSTNICD
     C** Average Rate Method (parameter from Caps/Collars input
     C** not used in this program)
     C                   PARM                    SAVRAM
     C                   PARM                    RSTICFD
     C                   PARM                    STICFR
     C                   PARM                    SUCUCY
     C** Day number passed back from module (needed for Caps/Collars but
     C** not used in this program)
     C                   PARM                    ZDAYX
     C                   PARM                    StICFrOK
     C                   PARM                    StNICDOK
     C                   PARM                    StICFDOK
     C                   PARM                    ModeOfOp                       CIR005
     C                   PARM                    WValBDC                        CIR005
     C                   PARM                    PayCurr                        CIR005
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
     C     WMsgId1       IFNE      *BLANK                                       CIR005
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
 
      /COPY WNCPYSRC,IRSIRSV081                                                 CAP004
                                                                                CAP004
      *  *-------------------------------------------*
      *  * Validate their Interest Payment Frequency *  #39
      *  *-------------------------------------------*
     C                   EXSR      RESETERRS
 
      /COPY WNCPYSRC,IRSIRSV082                                                 CAP004
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
 
      /COPY WNCPYSRC,IRSIRSV083                                                 CAP004
                                                                                CAP004
      *  *--------------------------------------------------------*
      *  * Validate their Interest Payment Frequency Day in Month *  #40
      *  *--------------------------------------------------------*
     C                   EXSR      RESETERRS
 
      /COPY WNCPYSRC,IRSIRSV084                                                 CAP004
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
     C                   PARM                    RSTIPFD
     C                   PARM                    RSTNICD
     C                   PARM                    RSTNIPD
     C                   PARM                    RSTICFD
 
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
 
      /COPY WNCPYSRC,IRSIRSV085                                                 CAP004
                                                                                CAP004
      *  *-----------------------------------------*                            CSW097
      *  * Validate Collateral Agreement Indicator *  #41                       CSW097
      *  *-----------------------------------------*                            CSW097
     C                   EXSR      RESETERRS                                    CSW097
                                                                                CSW097
      /COPY WNCPYSRC,IRSIRSV091                                                 CSW097
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
      /COPY WNCPYSRC,IRSIRSV092                                                 CSW097
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
     C                   PARM                    RSOSDT                                       CDL028
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
     C                   MOVE      SOS1B         RSOS1B                                       CDL028
                                                                                              CDL028
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
     C                   PARM                    RSOS1D                                       CDL028
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
     C                   MOVE      SOS2B         RSOS2B                                       CDL028
                                                                                              CDL028
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
     C                   PARM                    RSOS2D                                       CDL028
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
     C                   PARM                    RSOEDT                                       CDL028
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
     C                   MOVE      SOE1B         RSOE1B                                       CDL028
                                                                                              CDL028
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
     C                   PARM                    RSOE1D                                       CDL028
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
     C                   MOVE      SOE2B         RSOE2B                                       CDL028
                                                                                              CDL028
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
     C                   PARM                    RSOE2D                                       CDL028
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
     C                   PARM                    RSTSDT                                       CDL028
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
     C                   PARM                    SUCUCY                                       CDL028
                                                                                              CDL028
     C     MSG1          IFEQ      *BLANK                                                     CDL028
     C                   MOVE      STS1B         RSTS1B                                       CDL028
                                                                                              CDL028
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
     C                   PARM                    RSTS1D                                       CDL028
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
     C                   PARM                    SUCUCY                                       CDL028
                                                                                              CDL028
     C     MSG1          IFEQ      *BLANK                                                     CDL028
     C                   MOVE      STS2B         RSTS2B                                       CDL028
                                                                                              CDL028
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
     C                   PARM                    RSTS2D                                       CDL028
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
     C                   PARM                    RSTEDT                                       CDL028
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
     C                   PARM                    SUCUCY                                       CDL028
                                                                                              CDL028
     C     MSG1          IFEQ      *BLANK                                                     CDL028
     C                   MOVE      STE1B         RSTE1B                                       CDL028
                                                                                              CDL028
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
     C                   PARM                    RSTE1D                                       CDL028
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
     C                   PARM                    SUCUCY                                       CDL028
                                                                                              CDL028
     C     MSG1          IFEQ      *BLANK                                                     CDL028
     C                   MOVE      STE2B         RSTE2B                                       CDL028
                                                                                              CDL028
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
     C                   PARM                    RSTE2D                                       CDL028
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
 
      /COPY WNCPYSRC,IRSIRSV086                                                 CAP004
                                                                                CAP004
     C                   RETURN
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,IRSIRSV089
 
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
     C                   PARM                    ModeOfOp                       CIR005
      * Response mode (1A), from source system common header
     C                   PARM                    RespMode
      * Transaction information (DS) from source system
     C                   PARM                    TranIn
     C                   PARM                    ACTRJ             1                        MD053400
      * Receive Settlement Ccy, Method & Nostro and  Pay Settlement Ccy,
      * Method & Nostro, from default or valid deal
     C                   PARM                    RecSetCcy
     C                   PARM                    RecSetMeth
     C                   PARM                    RecNostro
     C                   PARM                    PaySetCcy
     C                   PARM                    PaySetMeth
     C                   PARM                    PayNostro
     C                   PARM                    ExtData                        CAP004
      * Field OK flags (DS) from/to caller
     C                   PARM                    OKFlagsDS
                                                                                CIR005
      ** Validate business day convention flag                                  CIR005
                                                                                CIR005
     C                   PARM                    WValBDC                        CIR005
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
     C                   PARM                    ACTNCD            1                          184560
     C                   PARM                    PUSLIP            5 0                        184560
     C                   PARM                    PTSLIP            5 0                        184560
      *                                                                                       185057
      * Current Deal in Screen Format                                                         185057
     C                   PARM                    DealScnFmt                                   185057
                                                                                CIR005
      ** Parameter lists for module IRVPAMCNV                                   CIR005
                                                                                CIR005
     C     PIrvPAmCnv    PLIST                                                  CIR005
     C                   PARM                    RetCodeOut                     CIR005
     C                   PARM                    SPDC1                          CIR005
     C                   PARM                    SAMC1                          CIR005
     C                   PARM                    OKPayDat1                      CIR005
     C                   PARM                    OKAmtCde1                      CIR005
     C                   PARM                    MsgIdErr                       CIR005
     C                   PARM                    FldNamErr                      CIR005
                                                                                CIR005
      ** Parameter lists for module IRVPAMCNV - if CIR017 is ON                               CIR017
                                                                                              CIR017
     C     PIrvPAmCnv2   PLIST                                                                CIR017
     C                   PARM                    RetCodeOut                                   CIR017
     C                   PARM                    SPDC2                                        CIR017
     C                   PARM                    SAMC2                                        CIR017
     C                   PARM                    OKPayDat2                                    CIR017
     C                   PARM                    OKAmtCde2                                    CIR017
     C                   PARM                    MsgIdErr                                     CIR017
     C                   PARM                    FldNamErr                                    CIR017
      *                                                                                       CIR017
      ** Parameter lists for module IRVBDYCCY                                   CIR005
                                                                                CIR005
     C     PIrvBDyCcy    PLIST                                                  CIR005
     C                   PARM                    RetCodeOut                     CIR005
     C                   PARM      'B'           WCode             1            CIR005
     C                   PARM                    PLCcy             3            CIR005
     C                   PARM                    RateCurr                       CIR005
     C                   PARM                    PayCurr                        CIR005
     C                   PARM                    OkFlgRte1                      CIR005
     C                   PARM                    OkFlgPay1                      CIR005
     C                   PARM                    MsgIdErr                       CIR005
     C                   PARM                    FldNamErr                      CIR005
     C                   PARM                    WMsgIdErr                      CIR005
     C                   PARM                    WFldNamErr                     CIR005
      *                                                                                       CIR017
      ** Parameter list for module IRVBDYCCY - if CIR017 is ON                                CIR017
                                                                                              CIR017
     C     PIrvBDyCcy2   PLIST                                                                CIR017
     C                   PARM                    RetCodeOut                                   CIR017
     C                   PARM      'B'           WCode                                        CIR017
     C                   PARM                    PLCcy                                        CIR017
     C                   PARM                    RateCurr2                                    CIR017
     C                   PARM                    PayCurr2                                     CIR017
     C                   PARM                    OkFlgRte2                                    CIR017
     C                   PARM                    OkFlgPay2                                    CIR017
     C                   PARM                    MsgIdErr                                     CIR017
     C                   PARM                    FldNamErr                                    CIR017
     C                   PARM                    WMsgIdErr                                    CIR017
     C                   PARM                    WFldNamErr                                   CIR017
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
     C                   MOVEL     'IRSIRSVAL'   DBPGM
     C                   OUT       LDA
 
      ** Access Dealing details via access program
      *  (database error handling done in access program)
     C**********         CALLB     'AODEALR0'                                                 CGL029
     C                   CALLB     'AODEALR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
      **********                                                                164607        245692
      **EDIT*AMOUNTS*WITH*'.'*****************************************          164607        245692
      **********                                                                164607        245692
     C**********         MOVE      '.'           BNDCSP                         164607        245692
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
                                                                                CIR005
      ** Access SAR details file to determine if FRA/IRS Business Day           CIR005
      ** Day Convention is switched on.                                         CIR005
                                                                                CIR005
     C                   CALL      'AOSARDR0'                                   CIR005
     C                   PARM      *BLANKS       @RTCD                          CIR005
     C                   PARM      '*VERIFY'     @OPTN                          CIR005
     C                   PARM      'CIR005'      @SARD                          CIR005
     C     SCSARD        PARM      SCSARD        DSFDY                          CIR005
                                                                                CIR005
     C                   IF        (@RTCD <> *BLANKS) And (@RTCD <> '*NRF   ')  CIR005
     C                   MOVEL     'SCSARDPD'    DBFILE                         CIR005
     C                   MOVEL     '025'         DBASE                          CIR005
     C                   MOVEL     'CIR005'      DBKEY                          CIR005
     C                   EXSR      *PSSR                                        CIR005
     C                   ENDIF                                                  CIR005
                                                                                CIR005
     C                   IF        @RTCD = *BLANKS                              CIR005
     C                   MOVEL     'Y'           CIR005            1            CIR005
     C                   ELSE                                                   CIR005
     C                   MOVEL     'N'           CIR005                         CIR005
     C                   ENDIF                                                  CIR005
                                                                                              CIR017
      ** Check if CIR017 - Separate Business Day Convention for SIRS                          CIR017
                                                                                              CIR017
     C                   CALL      'AOSARDR0'                                                 CIR017
     C                   PARM      *BLANKS       @RTCD                                        CIR017
     C                   PARM      '*VERIFY'     @OPTN                                        CIR017
     C                   PARM      'CIR017'      PSARD                                        CIR017
     C     SCSARD        PARM      SCSARD        DSFDY                                        CIR017
                                                                                              CIR017
     C                   IF        @RTCD <> *BLANKS AND                                       CIR017
     C                             @RTCD <> '*NRF   '                                         CIR017
     C     *LOCK         IN        LDA                                                        CIR017
     C                   EVAL      DBASE = 30                                                 CIR017
     C                   EVAL      DBKEY = 'CIR017'                                           CIR017
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CIR017
     C                   OUT       LDA                                                        CIR017
     C                   EXSR      *PSSR                                                      CIR017
     C                   ENDIF                                                                CIR017
                                                                                              CIR017
     C                   IF        @RTCD = *BLANKS                                            CIR017
     C                   EVAL      CIR017 = 'Y'                                               CIR017
     C                   ELSE                                                                 CIR017
     C                   EVAL      CIR017 = 'N'                                               CIR017
     C                   ENDIF                                                                CIR017
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
     C                   MOVEL     '026'         DBASE                                        CIR007
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
     C                   MOVEL     '027'         DBASE                                        CAS001
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
      ** Access SAR details file to determine if CAS005 is installed                          CAS005
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
     C                   Z-ADD     28            DBASE                                        CAS005
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
                                                                                              CLE025
      ** Access SAR details file to determine if CLE025 is installed                          CLE025
                                                                                              CLE025
     C                   CALLB     'AOSARDR0'                                                 CLE025
     C                   PARM      *BLANKS       PRTCD                                        CLE025
     C                   PARM      '*VERIFY'     POption                                      CLE025
     C                   PARM      'CLE025'      PSard                                        CLE025
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE025
                                                                                              CLE025
      ** Database Error                                                                       CLE025
                                                                                              CLE025
     C                   IF        PRTCD <> *BLANKS AND                                       CLE025
     C                             PRTCD <> '*NRF   '                                         CLE025
                                                                                              CLE025
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CLE025
     C                   Z-ADD     50            DBASE                                        CLE025
     C                   MOVEL     'CLE025'      DBKEY                                        CLE025
     C                   EXSR      *PSSR                                                      CLE025
                                                                                              CLE025
     C                   ENDIF                                                                CLE025
                                                                                              CLE025
     C                   IF        PRTCD = *BLANKS                                            CLE025
     C                   EVAL      CLE025 = 'Y'                                               CLE025
     C                   ELSE                                                                 CLE025
     C                   EVAL      CLE025 = 'N'                                               CLE025
     C                   ENDIF                                                                CLE025
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
     C                   EVAL      DBASE = 027                                                CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
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
     C                   EVAL      DBASE = 903                                                CDL029
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
     C                   MOVEL     '029'         DBASE                                        CDL028
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
      /COPY WNCPYSRC,IRSIRSV090
 
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
     C                   PARM      *BLANK        @Currency2        3                          CDL038
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
 
     C********           MOVE      RSDLNO        DealNumber
     C                   MOVE      SDTYP         RSDTYP
     C                   MOVE      SDLST         RSDLST
     C                   MOVE      SBOKC         RSBOKC
     C                   MOVE      SLNKDN        RSLNKDN
     C                   MOVE      SBRKC         RSBRKC
     C                   MOVE      SUCUCY        RSUCUCY
     C                   MOVE      SUCUCY        RSTCUCY
     C                   MOVE      SUICBS        RSUICBS
     C                   MOVE      STICBS        RSTICBS
     C                   MOVE      SPRFC         RSPRFC
     C                   MOVE      SORBR         RSORBR
     C                   MOVE      SUBRTT        RSUBRTT
     C                   MOVE      SUSPIN        RSUSPIN
     C                   MOVE      SUICFR        RSUICFR
     C                   MOVE      SUIPFR        RSUIPFR
     C                   MOVE      STBRTT        RSTBRTT
     C                   MOVE      STSPIN        RSTSPIN
     C                   MOVE      STICFR        RSTICFR
     C                   MOVE      STIPFR        RSTIPFR
     C                   MOVE      SCAIN         RSCAIN                         CSW097
 
     C                   Z-ADD     RSUPAMT       RSTPAMT
     C                   Z-ADD     RSUBCXR       RSTBCXR
 
      ** Taxable Indicator - default 'N' to file if blank entered.
     C     STAXI         IFEQ      'Y'
     C                   MOVE      'Y'           RSTAXI
     C                   ELSE
     C                   MOVE      'N'           RSTAXI
     C                   END
 
      **Federal Funds Indicator is a bit setting
     C     SUFFI         IFEQ      'Y'
     C                   BITON     '2'           RSUDSTI
     C                   BITON     '2'           RSTDSTI
     C                   END
                                                                                CIR005
      ** Business Day Conventions single currency fields                        CIR005
                                                                                CIR005
     C     CIR005        IFEQ      'Y'                                          CIR005
     C                   EVAL      VldBsDyC = BsDayConv                         CIR005
      *                                                                                       CIR017
      ** Update Business Day Convention Leg 2 fields with                                     CIR017
      ** values from the screen. IF CIR017 OFF, fields will be blank                          CIR017
     C                   IF        CIR017 = 'Y'                                               CIR017
     C                   EVAL      VldBsDyC2  = BsDayConv2                                    CIR017
     C                   EndIf                                                                CIR017
      *                                                                                       CIR017
     C                   ENDIF                                                  CIR005
 
     C     CLE025        IFEQ      'Y'                                                        CLE025
     C                   MOVE      RSBRCA        RBRCA                                        CLE025
     C**********         MOVE      RSDLNO        RDLNO                                CLE025 BUG8266
     C                   MOVE      SDLNO         RDLNO                                       BUG8266
     C                   MOVEL     SFCCU         RFCCU                                        CLE025
     C                   MOVE      SFACT         RFACT                                        CLE025
     C                   MOVE      SFCNO         RFCNO                                        CLE025
     C                   ENDIF                                                                CLE025
      *                                                                                       CDL038
      ** Class                                                                                CDL038
      *                                                                                       CDL038
     C                   MOVE      SCLAS         RSCLAS                                       CDL038
                                                                                              CLE025
     C                   ENDSR
      *****************************************************************
      ***/EJECT                                                                        CAS001 226002
      *****************************************************************                CAS001 226002
      *****************************************************************                CAS001 226002
      **SrAccesYldC*-*Access*Yield*Curve*Details***********************                CAS001 226002
      *****************************************************************                CAS001 226002
      **Called*By*:*Main***********************************************                CAS001 226002
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
     C                   Z-ADD     ZDAYNO        RSMDAT                                     MD053400
     C*                  MOVE      WSVRP         CCLNRPD                                    MD053400
      *                                                                                     MD053400
      ** Base Currency Rate                                                                 MD053400
      *                                                                                     MD053400
     C                   MOVE      *BLANKS       @@ALPH                                     MD053400
     C                   MOVEL     SUBCXR        @@ALPH                                     MD053400
     C                   Z-ADD     8             @@IDP                                      MD053400
     C                   Z-ADD     5             @@IINT                                     MD053400
     C                   MOVE      'N'           @@MTID                                     MD053400
     C*                  MOVE      'N'           ZAOPT                                      MD053400
     C                   CALLB     'ZA0840'                                                 MD053400
     C                   PARM                    @Rtcde                                     MD053400
     C                   PARM                    @@ALPH                                     MD053400
     C                   PARM                    @@IDP                                      MD053400
     C                   PARM                    @@IINT                                     MD053400
     C                   PARM                    @@MTID                                     MD053400
     C                   PARM                    @@ERCD                                     MD053400
     C                   PARM                    @@AMT                                      MD053400
     C                   PARM                    BNDCSP                                     MD053400
     C                   MOVE      @@AMT         RSUBCXR                                    MD053400
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
     C                   MOVE      @@AMT         RSURTSP                                    MD053400
     C                   ElSE                                                               MD053400
     C                   Z-ADD     0             RSURTSP                                    MD053400
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
     C                   MOVE      ZFIELD        RSUFRFD                                    MD053400
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
     C                   Z-ADD     ZDAYNO        RSUNICD                                    MD053400
     C                   ElSE                                                               MD053400
     C                   Z-ADD     0             RSUNICD                                    MD053400
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
     C                   MOVE      ZFIELD        RSUICFD                                    MD053400
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
     C                   MOVE      @@AMT         RSUEINR                                    MD053400
     C                   ElSE                                                               MD053400
     C                   Z-ADD     0             RSUEINR                                    MD053400
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
     C                   Z-ADD     ZDAYNO        RSUNIPD                                    MD053400
     C                   ElSE                                                               MD053400
     C                   Z-ADD     0             RSUNIPD                                    MD053400
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
     C                   MOVE      ZFIELD        RSUIPFD                                    MD053400
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
     C                   MOVE      @@AMT         RSTRTSP                                    MD053400
     C                   ElSE                                                               MD053400
     C                   Z-ADD     0             RSTRTSP                                    MD053400
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
     C                   MOVE      ZFIELD        RSTFRFD                                    MD053400
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
     C                   Z-ADD     ZDAYNO        RSTNICD                                    MD053400
     C                   ElSE                                                               MD053400
     C                   Z-ADD     0             RSTNICD                                    MD053400
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
     C                   MOVE      ZFIELD        RSTICFD                                    MD053400
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
     C                   MOVE      @@AMT         RSTEINR                                    MD053400
     C                   ElSE                                                               MD053400
     C                   Z-ADD     0             RSTEINR                                    MD053400
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
     C                   Z-ADD     ZDAYNO        RSTNIPD                                    MD053400
     C                   ElSE                                                               MD053400
     C                   Z-ADD     0             RSTNIPD                                    MD053400
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
     C                   MOVE      ZFIELD        RSTIPFD                                    MD053400
      *                                                                                     MD053400
      ** Our Yield Curve                                                                    MD053400
      *                                                                                     MD053400
     C                   MOVEL     SOYLC         RSOYLC                                     MD053400
      *                                                                                     MD053400
      ** Our Forward Yield Curve                                                            MD053400
      *                                                                                     MD053400
     C                   MOVEL     SOFYC         RSOFYC                                     MD053400
      *                                                                                     MD053400
      ** Their Yield Curve                                                                  MD053400
      *                                                                                     MD053400
     C                   MOVEL     STYLC         RSTYLC                                     MD053400
      *                                                                                     MD053400
      ** Their Forward Yield Curve                                                          MD053400
      *                                                                                     MD053400
     C                   MOVEL     STFYC         RSTFYC                                     MD053400
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
     C                   Z-ADD     ZDAYNO        RSOSDT                                     MD053400
     C                   ElSE                                                               MD053400
     C                   Z-ADD     0             RSOSDT                                     MD053400
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
     C                   MOVE      ZFIELD        RSOS1B                                     MD053400
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
     C                   Z-ADD     ZDAYNO        RSOS1D                                     MD053400
     C                   ElSE                                                               MD053400
     C                   Z-ADD     0             RSOS1D                                     MD053400
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
     C                   MOVE      ZFIELD        RSOS2B                                     MD053400
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
     C                   Z-ADD     ZDAYNO        RSOS2D                                     MD053400
     C                   ElSE                                                               MD053400
     C                   Z-ADD     0             RSOS2D                                     MD053400
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
     C                   Z-ADD     ZDAYNO        RSOEDT                                     MD053400
     C                   ElSE                                                               MD053400
     C                   Z-ADD     0             RSOEDT                                     MD053400
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
     C                   MOVE      ZFIELD        RSOE1B                                     MD053400
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
     C                   Z-ADD     ZDAYNO        RSOE1D                                     MD053400
     C                   ElSE                                                               MD053400
     C                   Z-ADD     0             RSOE1D                                     MD053400
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
     C                   MOVE      ZFIELD        RSOE2B                                     MD053400
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
     C                   Z-ADD     ZDAYNO        RSOE2D                                     MD053400
     C                   ElSE                                                               MD053400
     C                   Z-ADD     0             RSOE2D                                     MD053400
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
     C                   Z-ADD     ZDAYNO        RSTSDT                                     MD053400
     C                   ElSE                                                               MD053400
     C                   Z-ADD     0             RSTSDT                                     MD053400
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
     C                   MOVE      ZFIELD        RSTS1B                                     MD053400
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
     C                   Z-ADD     ZDAYNO        RSTS1D                                     MD053400
     C                   ElSE                                                               MD053400
     C                   Z-ADD     0             RSTS1D                                     MD053400
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
     C                   Z-ADD     ZDAYNO        RSTS2B                                     MD053400
     C                   ElSE                                                               MD053400
     C                   Z-ADD     0             RSTS2B                                     MD053400
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
     C                   Z-ADD     ZDAYNO        RSTS2D                                     MD053400
     C                   ElSE                                                               MD053400
     C                   Z-ADD     0             RSTS2D                                     MD053400
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
     C                   Z-ADD     ZDAYNO        RSTEDT                                     MD053400
     C                   ElSE                                                               MD053400
     C                   Z-ADD     0             RSTEDT                                     MD053400
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
     C                   Z-ADD     ZDAYNO        RSTE1B                                     MD053400
     C                   ElSE                                                               MD053400
     C                   Z-ADD     0             RSTE1B                                     MD053400
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
     C                   Z-ADD     ZDAYNO        RSTE1D                                     MD053400
     C                   ElSE                                                               MD053400
     C                   Z-ADD     0             RSTE1D                                     MD053400
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
     C                   Z-ADD     ZDAYNO        RSTE2B                                     MD053400
     C                   ElSE                                                               MD053400
     C                   Z-ADD     0             RSTE2B                                     MD053400
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
     C                   Z-ADD     ZDAYNO        RSTE1D                                     MD053400
     C                   ElSE                                                               MD053400
     C                   Z-ADD     0             RSTE1D                                     MD053400
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
