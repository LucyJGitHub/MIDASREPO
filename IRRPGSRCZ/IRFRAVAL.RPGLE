     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR FRA field validation controller')             *
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Dealing Module                               *
      *                                                               *
      *  IRFRAVAL  - Validate Forward Rate Agreements                 *
      *                                                               *
      *  Function: This Program Validates FRA Deals for Input into    *
      *            the Midas database.                                *
      *            The sequence of validation is based on subroutine  *
      *            VALD02 in Midas program DL1601.                    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 AR569568           Date 22Nov12               *
      *                 CER059             Date 19Jul10               *
      *                 BUG22478           Date 27Jan09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 BUG10704           Date 13Mar06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG9717            Date 29Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CDL029A            Date 09May05               *
      *                 CSW037A            Date 02May05               *
      *                 227562             Date 16Jun04               *
      *                 BUG6124            Date 03Mar05               *
      *                 BUG5443            Date 24Feb05               *
      *                 CSD025             Date 11Jan05               *
      *                 BUG5268            Date 24Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CDL029             Date 23Nov04               *
      *                 CLE025             Date 20Oct03               *
      *                 225811             Date 18Mar04               *
      *                 TDA011             Date 31Mar04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 CAP084             Date 30Jul03               *
      *                 CAS006             Date 21Jan03               *
      *                 217684             Date 12May03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 186676             Date 27Mar02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP056             Date 13Mar02               *
      *                 CIR008             Date 13Mar02               *
      *                 CSC011             Date 18Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 11Oct00               *
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
      *                 CAP004             Date 24Aug98               *
      *                 CAP003  *CREATE    Date 06May98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  AR569568 - CDL006 is not being passed causing zero amount to *
      *             be valid in Insert.  But in amendment, it will    *
      *             issue an error message MMM0372.(Child: AR569569)  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG22478 - Field error during authorization. Applied 245692  *
      *  245692 - Incorrect validation of rates when the decimal se-  *
      *           parator in the Dealing ICD was defined as "," ins-  *
      *           tead of ".".                                        *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG10704 - If entered transaction customer is not valid      *
      *             or does not exist in file, validation of          *
      *             customer VS branch must not be carried out.       *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG9717- Defaulting of class should be done when CDL038      *
      *           feature is currently ON.                            *
      *  CDL038 - Extended Deal Sub Type                              *
      *  CDL029A- Adding new field                                    *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  227562 - Database error occurs when inputting new FRA        *
      *  BUG6124 - Branch code error when CDL029 is set on.           *
      *  BUG5443- Apply code for CDL005 feature                       *
      *  CSD025 - Customer De-Activation                              *
      *  BUG5268 - Cannot authorise FRA when signed on as different   *
      *            user than input user.                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CDL029 - Midas SD Authorised Booking Branches for Customers  *
      *         - LHX010 added a new Interest Calulation Method 7.    *
      *           This now needs to use IntCalcMeth 8 since 7 is used *
      *           in Core.                                            *
      *           Core Hooks Used :                                   *
      *           IRFRAVA030      IRFRAVA031                          *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  225811 - User on FRAs/IRSs sent through APISERVER is ignored *
      *           BG1770 is applying this Release 5.0 fix to MidasPlus*
      *  TDA011 - Rate Fix Ccy writes to the wrong field (Recompile)  *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CAP084 - API wrapper project                                 *
      *         - Re-compile due to change in IRFRAPD                 *
      *  CAS006 - Hedge Accounting Phase B                            *
      *  217684 - Authorisation User Malfunction (Recompile)          *
      *  186676 - Call new IRVDEALTPS to validate the deal type/      *
      *           subtype combination.                                *
      *  CAP056 - Automatic Authorisation of Interface deals          *
      *           (Recompile)                                         *
      *  CIR008 - FRA/IRS Deals Authorisation (Recompile)             *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CSD006 - ZAVCURCODE uses DSSDY as *ENTRY parm, not SDCURRPD  *
      *  CIR005 - FRA/IRS Business Day Conventions                    *
      *  179732 - Only validate profit centre if not Blank OR         *
      *           Only allocate profit centre if the book code and    *
      *           deal subtype are entered.                           *
      *  CSW097 - SWIFT 1997 Changes for FRAIRS MT34* and MT36*.      *
      *  164607 - Amounts in FRA/IRS inputs should not be editted     *
      *           using decimal separator from SDDEALPD               *
      *  168981 - SWIFT 1997 Changes for FRAIRS MT34* and MT36*.      *
      *           (recompiled)                                        *
      *  CPL002 - Midas-Plato Interface (Recompiled)                  *
      *  CAP004 - Set up rate fix days with edited version of field   *
      *           returned from validation module                     *
      *           Add extra parm for Extra Data                       *
      *                                                               *
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
      /COPY WNCPYSRC,IRFRAVA051

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

     D RRatCurOk       S              1    DIM(10)                              CIR005
     D RPayCurOk       S              1    DIM(10)                              CIR005
      *                                                                         CIR005
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

     D ValidDeal     E DS                  EXTNAME(IRVFRAPD)
      * Valid Deals layout

     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
      ** 24X7 status data area                                                                CSC011
                                                                                              CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
      ** SD data area                                                                         CSC011
                                                                                              CSC011
     D ZMUSER          DS            17
     D  ZUSER                  1     10                                                       225811
     D  BRC                   11     13
     D  DEPT                  14     16

     D TranIn        E DS                  EXTNAME(IRFRAPD)
      * Incoming Transaction
     D  RRateCur             131    160                                         CIR005
      ** Currencies for Rate Fixing Convention                                  CIR005
                                                                                CAP004
     D ExtData       E DS                  EXTNAME(IRFREXPD)                    CAP004
      * IR FRA Extra Data - File (D/B) format                                   CAP004

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
     D  SUIcbsOK                      1A
     D  STaxiOK                       1A
     D  SUFrfdOK                      1A
     D  SPrfCOK                       1A
     D  SOrBrOK                       1A
     D  SBySlOK                       1A
     D  SSetFOK                       1A
     D  SRfRteOK                      1A
     D  SCRteOK                       1A
     D  SCAInOK                       1A                                        CSW097
      ** Flag(s) to indicate if Currencies for Rate Fixing Convention are valid CIR005
     D  RRateCurOK                   10A                                        CIR005
      ** Flag(s) to indicate if Risk Value Factor fields are valid                            CAS006
     D  SRKVLOK                       1A                                                      CAS006
     D  SRKSNOK                       1A                                                      CAS006
     D  SCLasOK                       1A                                                      CDL038
     D**SRSetMOK**********************1A                                                      CDL038
     D**SPSetMOK**********************1A                                                      CDL038
     D**SURAccOK**********************1A                                                      CDL038
     D**SROBrOK***********************1A                                                      CDL038
     D**SORAccOK**********************1A                                                      CDL038
     D**SUPAccOK**********************1A                                                      CDL038
     D**SPOBrOK***********************1A                                                      CDL038
     D**SOPAccOK**********************1A                                                      CDL038
     D**SCpPBkOK**********************1A                                                      CDL038
     D**SCpRBkOK**********************1A                                                      CDL038
     D**SFAcOOK***********************1A                                                      CDL038
     D**SSPiOK************************1A                                                      CDL038
      ** Flag(s) to indicate if combinations of transaction fields are valid
     D  DDDltStpOK                    1A

      ** Error flags from Dates validation routine
     D ErrDealDat      S              1A   INZ('N')
     D ErrValDate      S              1A   INZ('N')
     D ErrMatDate      S              1A   INZ('N')
     D ErrNxInDat      S              1A   INZ('N')

      ** Default Round Down indicators for Branch & Currency
     D BrRdfc          S              1A

      ** Portfolio reference (default value, received from AOPLCSR1 in
      ** IRVBOOKCDE)
     D Portref         S              4A

      ** Extended Settlement fields used by IRVVALDATE
     D PMERCD          S            150A

      ** Receive / Pay Settlement Method & Nostro
     D RecSetCcy       S              3A
     D RecSetMeth      S              2S 0
     D***RecNostro       S             12A                                                    CGL029
     D RecNostro       S             18A                                                      CGL029
     D PaySetCcy       S              3A
     D PaySetMeth      S              2S 0
     D***PayNostro       S             12A                                                    CGL029
     D PayNostro       S             18A                                                      CGL029

      ** Flag for whether an error was found in the call to ZDATE1
     D ZDATE1Err       S              1A

      ** Broker currency decimal places  (used by MMVBROKCDE)
      ** Not needed in this program other than as a parm for MMVBROKCDE
     D BrokCcyDp       S              1  0

      ** Broker currency (used by MMVBROKCDE)
      ** Not needed in this program other than as a parm for MMVBROKCDE
     D BrokCcy         S              3A

      ** Deal date in Midas Day number format (set up by IRVVALDATE)
     D   MidasDDat     S              5P 0

      ** Numeric version of spread/rate
     D @SPRD           S             11P 7

      ** A code to indicate the calling function to the lower level modules
     D FRA             S              4A   INZ('FRA ')

      ** Spread/Rate field returned as parameter from IRVCNTRATE
     D SpreadRate      S                   LIKE(FRURTSP)
                                                                                              CAS006
      ** Risk Value Factor field returned as parameter from IRVRISKVL                         CAS006
     D PRiskVal        S                   LIKE(FRRKVL)                                       CAS006

      ** Rate Fix Days field returned as parameter from IRVRATEFIX              CAP004
     D RatFixDays      S              2P 0                                      CAP004
                                                                                CAP004
      ** Dummy parameters used in the call to IRVMATDATE
      ** (these parms are used when validating Cross-ccy IRS only)
     D STCUCY          S              3A   INZ(*BLANK)
     D StCuCyOK        S              1A   INZ('N')
      ** (these parms are used when validating Caps/Floors/Collars only)
     D SAVRAM          S              1A   INZ('N')

      ** Response Mode, received as a parameter from the common header
     D RespMode        S              1A

      ** Amount field in 15,0 format required by MMVAMOUNT
     D Amount15        S             15  0
                                                                                CIR005
     D Ix              S                   LIKE(Idx)                            CIR005
                                                                                CIR005
     D FldNamXar       S             10A   DIM(ArrayMax)                        CIR005
                                                                                CIR005
     D MsgIDXar        S                   DIM(ArrayMax)                        CIR005
     D                                     LIKE(#MsgID)                         CIR005
                                                                                CIR005
     D WFldNamXar      S                   DIM(ArrayMax)                        CIR005
     D                                     LIKE(FldNameArr)                     CIR005
                                                                                CIR005
     D WMsgIDXar       S                   DIM(ArrayMax)                        CIR005
     D                                     LIKE(MsgIdArr)                       CIR005

      ** Fields defined for Enhancement CSC011                                                CSC011
                                                                                              CSC011
     D CSC011          S              1A                                                      CSC011
     D PRtCd           S              7A                                                      CSC011
     D POptn           S              7A                                                      CSC011
     D PSard           S              6A                                                      CSC011
     D WRunDay         S                   LIKE(BJRDNB)                                       CSC011
                                                                                              CAS006
     D CAS006          S              1                                                       CAS006
                                                                                              CDL029
      ** Fields defined for Enhancement CDL029                                                CDL029
     D CDL029          S              1A                                                      CDL029
     D CDL038          S              1A                                                     BUG9717
                                                                                            AR569568
     D CDL006          S              1A                                                    AR569568
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
      /COPY WNCPYSRC,IRFRAVA052

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

      /COPY WNCPYSRC,IRFRAVA001                                                 CAP004
                                                                                CAP004
      * Call Validation Modules in Sequence

      *  *-----------------------------------------------------*
      *  * Validation and Generation of Deal Number.           *
      *  *-----------------------------------------------------*
     C*******************CALL      'MMVACTDEAL'
     C*******************PARM                    RetCodeIn
     C*******************PARM                    MSG1
     C*******************PARM                    RepairLoc
     C*******************PARM                    CnfValFrtO
     C*******************PARM                    ScrnFlds
     C*******************PARM                    ScrnFlags
     C**  GET ZMUSER to access default branch.                                               BUG5268
     C**                                                                                     BUG5268
     C     *DTAARA       DEFINE                  ZMUSER                                      BUG5268
     C                   IN        ZMUSER                                                    BUG5268
     C                   UNLOCK    ZMUSER                                                    BUG5268
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

      /COPY WNCPYSRC,IRFRAVA002                                                 CAP004
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

      /COPY WNCPYSRC,IRFRAVA003                                                 CAP004
                                                                                CAP004
      *  *------------------------*
      *  * Validate Branch Code   *  #02
      *  *------------------------*
     C                   EXSR      RESETERRS

      /COPY WNCPYSRC,IRFRAVA004                                                 CAP004
                                                                                CAP004
     C                   CALLB     'MMVBKGBRCH'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    BJSBRC
     C                   PARM                    BRC
     C                   PARM                    BRRDFC
     C                   PARM                    SACCD
     C                   PARM                    SBRCA
     C                   PARM                    RespMode
     C                   PARM                    FRBRCA
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

      /COPY WNCPYSRC,IRFRAVA005                                                 CAP004
                                                                                CAP004

      *  *------------------------*
      *  * Validate Deal Date     *  #03
      *  *------------------------*

     C                   EXSR      RESETERRS

      /COPY WNCPYSRC,IRFRAVA006                                                 CAP004
                                                                                CAP004
     C                   CALLB     'MMVDLDATE'
     C                   PARM                    ReturnCode
     C                   PARM                    Msg1
     C                   PARM                    Msg2
     C                   PARM                    WMsgid1
     C                   PARM                    FRDDAT
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

      /COPY WNCPYSRC,IRFRAVA007                                                 CAP004
                                                                                CAP004
      *  *------------------------*
      *  * Validate Broker Code   *  #04
      *  *------------------------*
     C                   EXSR      RESETERRS

      /COPY WNCPYSRC,IRFRAVA008                                                 CAP004
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

      /COPY WNCPYSRC,IRFRAVA009                                                 CAP004
                                                                                CAP004
      *  *------------------------*
      *  * Validate Brokerage     *  #05
      *  *------------------------*
     C                   EXSR      RESETERRS

      /COPY WNCPYSRC,IRFRAVA010                                                 CAP004
                                                                                CAP004
     C                   CALLB     'ZAVBROKAGE'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    MSG2
     C                   PARM                    SBrkCOK
     C                   PARM                    SBRKC
     C                   PARM                    SBAGE
     C                   PARM                    A9BRCY
     C                   PARM                    FRBAGE
      ** Decimal separator (1A, from SDDEALPD, via caller
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

      /COPY WNCPYSRC,IRFRAVA011                                                 CAP004
                                                                                CAP004
      *  *----------------------------------*
      *  * Validate Linked Reference Number *  #06
      *  *----------------------------------*
     C                   EXSR      RESETERRS

      /COPY WNCPYSRC,IRFRAVA012                                                 CAP004
                                                                                CAP004
     C                   CALLB     'MMVLINKREF'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    SLNKDN
      ** Decimal separator (1A, from SDDEALPD, via caller
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

      /COPY WNCPYSRC,IRFRAVA013                                                 CAP004
                                                                                CAP004
      *  *------------------------*
      *  * Validate Customer      *  #07
      *  *------------------------*
     C                   EXSR      RESETERRS

      /COPY WNCPYSRC,IRFRAVA014                                                 CAP004
                                                                                CAP004
     C                   CALLB     'IRVCUSTNUM'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    SCNUM
     C                   PARM                    SDCUST
     C                   PARM                    SACCD                                        CSD025
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
     C                   MOVE      BBCUST        FRCNUM
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
      /COPY WNCPYSRC,IRFRAVA015                                                 CAP004
                                                                                CAP004
      *  *------------------------*
      *  * Validate Value Date    *  #08
      *  *------------------------*
     C                   EXSR      RESETERRS

      /COPY WNCPYSRC,IRFRAVA016                                                 CAP004
                                                                                CAP004
     C                   CALLB     'IRVVALDATE'
     C                   PARM                    ReturnCode
     C                   PARM                    Msg1
     C                   PARM                    WMsgid1
     C                   PARM                    WMsgid2
     C                   PARM                    SVDAT
     C                   PARM                    SDDAT
     C                   PARM                    FRVDAT
     C                   PARM                    MidasDDat
     C                   PARM                    BJDFIN
     C**********         PARM                    BJRDNB                                       CSC011
     C                   PARM                    WRunDay                                      CSC011
     C                   PARM                    BJLCCY
     C                   PARM                    BJSLCD
     C                   PARM                    SUCUCY
      ** Deal settlement instruction fields
     C                   PARM                    RecSetCcy
     C                   PARM                    RecSetMeth                     rec settle meth
     C                   PARM                    RecNostro
     C                   PARM                    PaySetCcy
     C                   PARM                    PaySetMeth                     pay settle meth
     C                   PARM                    PayNostro

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

      /COPY WNCPYSRC,IRFRAVA017                                                 CAP004
                                                                                CAP004
      *  *-------------------*
      *  * Validate Currency *  #09
      *  *-------------------*
     C                   EXSR      RESETERRS

      /COPY WNCPYSRC,IRFRAVA018                                                 CAP004
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

      /COPY WNCPYSRC,IRFRAVA019                                                 CAP004
                                                                                CAP004
      *  *------------------------*
      *  * Validate Maturity Date *  #10
      *  *------------------------*
     C                   EXSR      RESETERRS

      /COPY WNCPYSRC,IRFRAVA020                                                 CAP004
                                                                                CAP004
     C                   CALLB     'IRVMATDATE'
     C                   PARM                    ReturnCode
     C                   PARM                    Msg1
     C                   PARM                    WMsgid1
     C                   PARM                    WMsgid2
     C                   PARM                    SMDAT
     C                   PARM                    FRVDAT
     C                   PARM                    SUCUCY
     C                   PARM                    BJLCCY
     C                   PARM                    BJSLCD
     C                   PARM                    SAVRAM
     C**********         PARM                    BJRDNB                                       CSC011
     C                   PARM                    WRunDay                                      CSC011
     C                   PARM                    BJDFIN
     C                   PARM                    SVDatOK
     C                   PARM                    SuCucyOK
     C                   PARM                    FRMDAT
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

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    SMDatOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,IRFRAVA021                                                 CAP004
                                                                                CAP004
      *  *-----------------------------------*
      *  * Validate Account Sequence Number  *  #10.5
      *  *-----------------------------------*
     C                   EXSR      RESETERRS

      /COPY WNCPYSRC,IRFRAVA022                                                 CAP004
                                                                                CAP004
     C                   CALLB     'MMVACSEQ'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    SCDAS
     C                   PARM                    FRCDAS
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

      /COPY WNCPYSRC,IRFRAVA023                                                 CAP004
                                                                                CAP004
      *  *-------------------*
      *  * Validate Amount   *  #11
      *  *-------------------*
     C                   EXSR      RESETERRS

      /COPY WNCPYSRC,IRFRAVA024                                                 CAP004
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
     C                   Z-ADD     Amount15      FRUPAMT
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    SuPAmtOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,IRFRAVA025                                                 CAP004
                                                                                CAP004
      *  *----------------------------------*
      *  * Validate Federal funds indicator *  #12
      *  *----------------------------------*
     C                   EXSR      RESETERRS
      /COPY WNCPYSRC,IRFRAVA026                                                 CAP004
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

      /COPY WNCPYSRC,IRFRAVA027                                                 CAP004
                                                                                CAP004
      *  *--------------------------------------*
      *  * Validate Base Currency Exchange Rate *  #13
      *  *--------------------------------------*
     C                   EXSR      RESETERRS

      /COPY WNCPYSRC,IRFRAVA028                                                 CAP004
                                                                                CAP004
     C                   CALLB     'IRVBCURRAT'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    SUBCXR
     C                   PARM                    A6SPRT
     **Constants passed in by calling programme.
     C                   PARM                    SUCUCY
     C                   PARM                    BJCYCD
     C                   PARM                    FRUBCXR
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

      /COPY WNCPYSRC,IRFRAVA029                                                 CAP004
                                                                                CAP004
      *  *-----------------------------*
      *  * Validate Calculation Basis  *  #14
      *  *-----------------------------*
     C                   EXSR      RESETERRS

      /COPY WNCPYSRC,IRFRAVA030                                                 CAP004
                                                                                CAP004
     C                   CALLB     'IRVFRAINTC'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    SSETF
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

      /COPY WNCPYSRC,IRFRAVA031                                                 CAP004
                                                                                CAP004
      *  *------------------------*
      *  * Validate Book Code     *  #15
      *  *------------------------*
     C                   EXSR      RESETERRS

      /COPY WNCPYSRC,IRFRAVA032                                                 CAP004
                                                                                CAP004
     C                   CALLB     'IRVBOOKCDE'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    SBOKC
     C                   PARM                    SDBOOK
      ** Day Basis field used for Caps/Collars processing only.
     C                   PARM                    DayBasis          1

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

      /COPY WNCPYSRC,IRFRAVA033                                                 CAP004
                                                                                CAP004
      *  *----------------------------*
      *  * Validate Taxable Indicator *  #16
      *  *----------------------------*
     C                   EXSR      RESETERRS

      /COPY WNCPYSRC,IRFRAVA034                                                 CAP004
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

      /COPY WNCPYSRC,IRFRAVA035                                                 CAP004
                                                                                CAP004
      *  *-------------------------------------*                                CIR005
      *  * Validate Currencies for Rate Fixing *                                CIR005
      *  *-------------------------------------*                                CIR005
     C                   IF        (CIR005 = 'Y')                               CIR005
      *                                                                         CIR005
     C                   EXSR      RESETERRS                                    CIR005
     C                   MOVE      *BLANK        Pcode                          CIR005
     C                   MOVE      *BLANK        RPaytCur                       CIR005
      *                                                                         CIR005
     C                   CALLB     'IRVBDYCCY'                                  CIR005
     C                   PARM                    ReturnCode                     CIR005
     C                   PARM                    Pcode             1            CIR005
     C                   PARM                    PLCcy             3            CIR005
     C                   PARM                    RRateCur                       CIR005
     C                   PARM                    RPaytCur         30            CIR005
     C                   PARM                    RRatCurOk                      CIR005
     C                   PARM                    RPayCurOk                      CIR005
     C                   PARM                    MsgIDXar                       CIR005
     C                   PARM                    FldNamXar                      CIR005
     C                   PARM                    WMsgIDXar                      CIR005
     C                   PARM                    WFldNamXar                     CIR005
      *                                                                         CIR005
     C                   MOVEA     RRatCurOk     RRateCurOk                     CIR005
     C                   EVAL      Ix = 1                                       CIR005
     C                   DOW       FldNamXar(Ix) <> *Blanks                     CIR005
     C                   EVAL      Idx = Idx + 1                                CIR005
     C                   EVAL      FldNameArr(Idx) = FldNamXar(Ix)              CIR005
     C                   EVAL      MsgIdArr(Idx) = MsgIDXar(Ix)                 CIR005
     C                   EVAL      Ix = Ix + 1                                  CIR005
     C                   ENDDO                                                  CIR005
                                                                                CIR005
     C                   EVAL      Ix = 1                                       CIR005
     C                   DOW       WFldNamXar(Ix) <> *Blanks                    CIR005
     C                   EVAL      WIdx = WIdx + 1                              CIR005
     C                   EVAL      WFldNamArr(WIdx) = WFldNamXar(Ix)            CIR005
     C                   EVAL      WMsgIdArr(WIdx) = WMsgIDXar(Ix)              CIR005
     C                   EVAL      Ix = Ix + 1                                  CIR005
     C                   ENDDO                                                  CIR005
     C                   ENDIF                                                  CIR005
      *                                                                         CIR005
      *  *------------------------*
      *  * Validate Rate Fix Days *  #17
      *  *------------------------*
     C                   EXSR      RESETERRS

      /COPY WNCPYSRC,IRFRAVA036                                                 CAP004
                                                                                CAP004
     C                   CALLB     'IRVRATEFIX'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    WMsgid1
     C                   PARM                    SUFRFD
     C                   PARM                    SUCUCY
     C                   PARM                    BJLCCY
     C                   PARM                    BLCYCD
     C                   PARM                    SVDatOK
     C                   PARM                    SUFRFDOK
     C                   PARM                    SUCucyOK
     C                   PARM                    FRVDAT
     C                   PARM                    BQCRFH
     C                   PARM                    BJSLCD
     C**********         PARM                    BJRDNB                                       CSC011
     C                   PARM                    WRunDay                                      CSC011
     C                   PARM                    FRUINFD
     C                   PARM                    RatFixDays                     CAP004
     C                   PARM                    RRateCur                       CIR005
     C                   PARM                    RRatCurOk                      CIR005

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SUFRFD'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF

     C     WMSGID1       IFNE      *BLANK
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'SUFRFD'
     C                   EVAL      WMsgIDArr(WIdx) = WMSGID1
     C                   ENDIF

      ** Set up 'Their Interest Fix Date' if no errors.
     C     MSG1          IFEQ      *BLANK
     C     WMSGID1       ANDEQ     *BLANK
     C                   Z-ADD     FRUINFD       FRTINFD
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    SuFRFDOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,IRFRAVA037                                                 CAP004
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

      /COPY WNCPYSRC,IRFRAVA038                                                 CAP004
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

      /COPY WNCPYSRC,IRFRAVA039                                                 CAP004
                                                                                CAP004
      * Endif statement for SBokCOK and SDlstOK = 'Y'                           179732
     C                   ENDIF                                                  179732
      *
      *  *--------------------------------------------*
      *  * Validate Originating Branch                *  #19
      *  *--------------------------------------------*
     C                   EXSR      RESETERRS

      /COPY WNCPYSRC,IRFRAVA040                                                 CAP004
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

      /COPY WNCPYSRC,IRFRAVA041                                                 CAP004
                                                                                CAP004
      *  *------------------------*
      *  * Validate Buy/Sell Ind  *  #20
      *  *------------------------*
     C                   EXSR      RESETERRS

      /COPY WNCPYSRC,IRFRAVA042                                                 CAP004
                                                                                CAP004
     C                   CALLB     'IRVBUYSELL'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    SBYSL

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SBYSL'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    SBySlOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,IRFRAVA043                                                 CAP004
                                                                                CAP004
      *  *----------------------------------*
      *  * Validate Settlement Formula Ind  *  #21
      *  *----------------------------------*
     C                   EXSR      RESETERRS

      /COPY WNCPYSRC,IRFRAVA044                                                 CAP004
                                                                                CAP004
     C                   CALLB     'IRVSETFORM'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    SSETF

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SSETF'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    SSetFOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,IRFRAVA045                                                 CAP004
                                                                                CAP004
      *  *--------------------------*
      *  * Validate Reference Rate  *  #22
      *  *--------------------------*
     C                   EXSR      RESETERRS

      /COPY WNCPYSRC,IRFRAVA046                                                 CAP004
                                                                                CAP004
     C                   CALLB     'IRVREFRATE'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    SRFRTE
     C                   PARM                    SUCUCY
     C                   PARM                    SuCucyOK
     C                   PARM                    SDBSRT

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SRFRTE'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    SRfRteOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,IRFRAVA047                                                 CAP004
                                                                                CAP004
      *  *--------------------------*
      *  * Validate Contract Rate   *  #22
      *  *--------------------------*
     C                   EXSR      RESETERRS

      /COPY WNCPYSRC,IRFRAVA048                                                 CAP004
                                                                                CAP004
     C                   CALLB     'IRVCNTRATE'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    SCRTE
     C                   PARM                    SpreadRate
     C                   PARM                    BNDCSP                                       245692

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SCRTE'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF

     C** Set 'Our' or 'Their' Spread/Rate depending on value of
     C** the Buy/Sell Indicator
     C     Returncode    IFEQ      *BLANK
     C     SBySlOK       ANDEQ     'Y'

     C     SBYSL         IFEQ      'B'
     C                   Z-ADD     SpreadRate    FRURTSP
     C                   Z-ADD     *ZEROS        FRTRTSP
     C                   ELSE
     C                   Z-ADD     SpreadRate    FRTRTSP
     C                   Z-ADD     *ZEROS        FRURTSP
     C                   ENDIF

     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    SCRteOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
                                                                                              CAS006
      ** Validate Risk Value Factor                                                           CAS006
                                                                                              CAS006
     C                   IF        CAS006 = 'Y'                                               CAS006
     C                             AND SRfRteOK = 'Y'                                         227562
                                                                                              CAS006
     C                   EXSR      RESETERRS                                                  CAS006
                                                                                              CAS006
     C                   CALLB     'IRVRISKVL'                                                CAS006
     C                   PARM      *BLANK        ReturnCode                                   CAS006
     C                   PARM      *BLANK        MSG1                                         CAS006
     C                   PARM      *BLANK        MSG2                                         CAS006
     C                   PARM                    SRKVL                                        CAS006
     C                   PARM                    SRKSN                                        CAS006
                                                                                              CAS006
      ** Formatted fields to be used in computation of Net Treasury Rate                      CAS006
     C                   PARM                    SBYSL                                        CAS006
     C                   PARM                    SpreadRate                                   CAS006
     C                   PARM                    BACBSR                                       CAS006
                                                                                              CAS006
     C                   PARM      *ZEROS        PRiskVal                                     CAS006
     C                   PARM                    BNDCSP                                       245692
                                                                                              CAS006
     C     MSG1          IFNE      *BLANK                                                     CAS006
     C                   ADD       1             Idx                                          CAS006
     C                   EVAL      FldNameArr(Idx) = 'SRKVL'                                  CAS006
     C                   EVAL      MsgIDArr(Idx) = MSG1                                       CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C     MSG2          IFNE      *BLANK                                                     CAS006
     C                   ADD       1             Idx                                          CAS006
     C                   EVAL      FldNameArr(Idx) = 'SRKSN'                                  CAS006
     C                   EVAL      MsgIDArr(Idx) = MSG2                                       CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Use the return code's value to set the field's OK flag                               CAS006
                                                                                              CAS006
     C                   IF        MSG1 <> *BLANK                                             CAS006
     C                   CALLB     'ZASETOKFLG'                                               CAS006
     C                   PARM                    SRKVLOK                                      CAS006
     C                   PARM                    ReturnCode                                   CAS006
     C                   PARM                    WarnGlobal                                   CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   IF        MSG2 <> *BLANK                                             CAS006
     C                   CALLB     'ZASETOKFLG'                                               CAS006
     C                   PARM                    SRKSNOK                                      CAS006
     C                   PARM                    ReturnCode                                   CAS006
     C                   PARM                    WarnGlobal                                   CAS006
     C                   ENDIF                                                                CAS006
     C                   ENDIF                                                                CAS006

      /COPY WNCPYSRC,IRFRAVA049                                                 CAP004
      *  *-----------------------------------------*                            CSW097
      *  * Validate Collateral Agreement Indicator *  #23                       CSW097
      *  *-----------------------------------------*                            CSW097
     C                   EXSR      RESETERRS                                    CSW097
                                                                                CSW097
      /COPY WNCPYSRC,IRFRAVA055                                                 CSW097
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
      /COPY WNCPYSRC,IRFRAVA056                                                 CSW097
                                                                                CSW097
                                                                                CAP004
      *  *-------------------------------------------------------*
      *  * If no errors set up outstanding fields for valid file *
      *  *-------------------------------------------------------*

     C                   IF        Idx = 0
     C                   EXSR      SetupValid
     C                   ENDIF

      /COPY WNCPYSRC,IRFRAVA050                                                 CAP004
                                                                                CAP004
     C                   RETURN

      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,IRFRAVA053

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
      * Response mode (1A), from source system common header
     C                   PARM                    RespMode
      * Transaction information (DS) from source system
     C                   PARM                    TranIn
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
                                                                                              CDL029
     C     KBRANCHAUTH   KLIST                                                                CDL029
     C******             KFLD                    BBBRCD                                CDL029CDL029A
     C                   KFLD                    W0BRCD            3                         CDL029A
     C                   KFLD                    W0CUST            6                         CDL029A
     C                   KFLD                    SBRCA                                        CDL029

      * File / Data area Accesses required for calling parameters
      * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     C*
     C****GET*ZMUSER*to*access*default*branch.                                               BUG5268
     C*****************************                                                          BUG5268
     C******DTAARA*******DEFINE                  ZMUSER                                      BUG5268
     C*******************IN********ZMUSER                                                    BUG5268
     C*******************UNLOCK****ZMUSER                                                    BUG5268
     C**
      **  Move program name into *LDA field.
     C     *LOCK         IN        LDA
     C                   MOVEL     'IRFRAVAL'    DBPGM
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
      **EDIT*AMOUNTS*WITH*'.'******************************************                164607 245692
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
      *  Set up the name of the MSGF from which the message handler will
      *   get the messages
     C                   EVAL      #MsgFile = 'DRSMM'
      *                                                                         CIR005
      **  Access SAR details file to determine if Bus. Day Convention is on.    CIR005
      *                                                                         CIR005
     C                   CALL      'AOSARDR0'                                   CIR005
     C                   PARM      *BLANKS       @RTCD                          CIR005
     C                   PARM      '*VERIFY'     @OPTN                          CIR005
     C                   PARM      'CIR005'      @SARD                          CIR005
     C     SCSARD        PARM      SCSARD        DSFDY                          CIR005
      *                                                                         CIR005
     C     @RTCD         IFNE      *BLANKS                                      CIR005
     C     @RTCD         ANDNE     '*NRF   '                                    CIR005
     C     *LOCK         IN        LDA                                          CIR005
     C                   MOVEL     'SCSARDPD'    DBFILE                         CIR005
     C                   Z-ADD     901           DBASE                          CIR005
     C                   MOVEL     'CIR005'      DBKEY                          CIR005
     C                   OUT       LDA                                          CIR005
     C                   EXSR      *PSSR                                        CIR005
     C                   ENDIF                                                  CIR005
      *                                                                         CIR005
     C     @RTCD         IFEQ      *BLANKS                                      CIR005
     C                   MOVEL     'Y'           CIR005            1            CIR005
     C                   ELSE                                                   CIR005
     C                   MOVEL     'N'           CIR005                         CIR005
     C                   ENDIF                                                  CIR005

     C                   EVAL      PLCcy = BJLCCY                               CIR005
                                                                                CIR005
      ** Check if CSC011 is installed                                                         CSC011
                                                                                              CSC011
     C                   EVAL      WRunDay = BJRDNB                                           CSC011
                                                                                              CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRtCd                                        CSC011
     C                   PARM      '*VERIFY'     POptn                                        CSC011
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
     C                   MOVEL     'CSC011'      DBKEY                                        CSC011
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CSC011
     C                   Z-ADD     902           DBASE                                        CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
      ** Access SAR details file to determine if Hedge Accounting Phase B is                  CAS006
      ** installed                                                                            CAS006
                                                                                              CAS006
     C                   CALL      'AOSARDR0'                                                 CAS006
     C                   PARM      *BLANKS       PRTCD                                        CAS006
     C                   PARM      '*VERIFY'     POPTN                                        CAS006
     C                   PARM      'CAS006'      PSARD                                        CAS006
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS006
      *                                                                                       CAS006
     C     PRTCD         IFNE      *BLANKS                                                    CAS006
     C     PRTCD         ANDNE     '*NRF   '                                                  CAS006
     C     *LOCK         IN        LDA                                                        CAS006
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CAS006
     C                   Z-ADD     903           DBASE                                        CAS006
     C                   MOVEL     'CAS006'      DBKEY                                        CAS006
     C                   OUT       LDA                                                        CAS006
     C                   EXSR      *PSSR                                                      CAS006
     C                   ENDIF                                                                CAS006
      *                                                                                       CAS006
     C     PRTCD         IFEQ      *BLANKS                                                    CAS006
     C                   MOVEL     'Y'           CAS006                                       CAS006
     C                   ELSE                                                                 CAS006
     C                   MOVEL     'N'           CAS006                                       CAS006
     C                   ENDIF                                                                CAS006
     C*                                                                                       CDL029
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
                                                                                              CAS006
      ** Access SAR details file to determine if CDL038 is switched on                       BUG9717
                                                                                             BUG9717
     C                   CALLB     'AOSARDR0'                                                BUG9717
     C                   PARM      *BLANKS       PRTCD                                       BUG9717
     C                   PARM      '*VERIFY'     POPTN                                       BUG9717
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
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area

      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,IRFRAVA054

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

     C                   Reset                   MsgIdXar                       CIR005
     C                   Reset                   FldNamXar                      CIR005
     C                   Reset                   WMsgIdXar                      CIR005
     C                   Reset                   WFldNamXar                     CIR005
                                                                                CIR005
     C                   EVAL      ReturnCode = *Blanks

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

      * Other FRxxxx fields are set up during the individual date
      *  validation, such as the ones where the input & database formats
      *  are different, e.g. dates, amounts.
      * This SR sets up the fields with the same (or compatible) attributes

     C********           MOVE      FRDLNO        DealNumber
     C                   MOVE      SDTYP         FRDTYP
     C                   MOVE      SDLST         FRDLST
     C                   MOVE      SBOKC         FRBOKC
     C                   MOVE      SLNKDN        FRLNKDN
     C                   MOVE      SBRKC         FRBRKC
     C                   MOVE      SUCUCY        FRUCUCY
     C                   MOVE      SUCUCY        FRTCUCY
     C                   MOVE      SUICBS        FRUICBS
     C                   MOVE      SUICBS        FRTICBS
     C                   MOVE      SCDAS         FRCDAS
     C                   MOVE      SPRFC         FRPRFC
     C                   MOVE      SORBR         FRORBR
     C                   MOVE      SBYSL         FRBYSL
     C                   MOVE      SSETF         FRSETF
     C                   MOVE      SCAIN         FRCAIN                         CSW097

     C                   Z-ADD     FRUPAMT       FRTPAMT
     C                   Z-ADD     FRUBCXR       FRTBCXR

      ** Taxable Indicator - default 'N' to file if blank entered.
     C     STAXI         IFEQ      'Y'
     C                   MOVE      'Y'           FRTAXI
     C                   ELSE
     C                   MOVE      'N'           FRTAXI
     C                   END

     C** If FRA Buy/Sell Indicator is 'S' set up 'OUR' fields
     C** and move blanks/zeros to 'THEIR' fields, and vice-versa.

     C     SBYSL         IFEQ      'S'
     C*******            MOVE      SUFRFD        FRUFRFD                        CAP004
     C                   Z-ADD     RatFixDays    FRUFRFD                        CAP004
     C                   MOVE      SRFRTE        FRUBRTT
     C                   Z-ADD     *ZEROS        FRTFRFD
     C**********         Z-ADD     *ZEROS        FRTBRTT                                      CSD103
     C                   MOVEL     *BLANKS       FRTBRTT                                      CSD103

     C                   ELSE
     C*******            MOVE      SUFRFD        FRTFRFD                        CAP004
     C                   Z-ADD     RatFixDays    FRTFRFD                        CAP004
     C                   MOVE      SRFRTE        FRTBRTT
     C                   Z-ADD     *ZEROS        FRUFRFD
     C**********         Z-ADD     *ZEROS        FRUBRTT                                      CSD103
     C                   MOVEL     *BLANKS       FRUBRTT                                      CSD103
     C                   END

      **Federal Funds Indicator is a bit setting
     C     SUFFI         IFEQ      'Y'
     C                   BITON     '2'           FRUDSTI
     C                   BITON     '2'           FRTDSTI
     C                   END
                                                                                              CAS006
      ** Risk Value Factor                                                                    CAS006
                                                                                              CAS006
     C                   IF        CAS006 = 'Y'                                               CAS006
     C                   EVAL      FRRKVL = PRiskVal                                          CAS006
     C                   EVAL      FRRKSN = SRKSN                                             CAS006
     C                   ENDIF                                                                CAS006
      *                                                                         CIR005
      ** Move the Business Day Ccy to valid file when CIR005 is on              CIR005
      *                                                                         CIR005
     C     CIR005        IFEQ      'Y'                                          CIR005
     C                   MOVE      SCYR1         FRCYR1                         CIR005
     C                   MOVE      SCYR2         FRCYR2                         CIR005
     C                   MOVE      SCYR3         FRCYR3                         CIR005
     C                   MOVE      SCYR4         FRCYR4                         CIR005
     C                   MOVE      SCYR5         FRCYR5                         CIR005
     C                   MOVE      SCYR6         FRCYR6                         CIR005
     C                   MOVE      SCYR7         FRCYR7                         CIR005
     C                   MOVE      SCYR8         FRCYR8                         CIR005
     C                   MOVE      SCYR9         FRCYR9                         CIR005
     C                   MOVE      SCYR0         FRCYR0                         CIR005
     C                   ENDIF                                                  CIR005
                                                                                              225811
     C     SACCD         IFEQ      'I'                                                        225811
     C                   MOVEL     ZUSER         FRUSRI                                       225811
     C                   ENDIF                                                                225811
      *                                                                                       CDL038
      ** Class                                                                                CDL038
      *                                                                                       CDL038
     C                   MOVE      SCLAS         FRCLAS                                       CDL038

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * #C       - Termination processing.                            *
      *                                                               *
      * CALLS             -                                           *
      *                                                               *
      * CALLED BY  MAIN   - Top level of program.                     *
      *                                                               *
      * FLDS USED  @TERM  - Termination parameter.                    *
      *            PSNoOfParm - No. of parameters program called with.*
      *            @TERM1 - Termination parameter.                    *
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
