     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AB Internal Funding Deals Validation')           *
      *****************************************************************
      *                                                               *
      *  Midas - Internal Funding Module                              *
      *                                                               *
      *  ABFUNDVAL - Internal Funding Deals Validation Controller     *
      *                                                               *
      *  Function:  This module will be the main module for the       *
      *             validation of the Internal Funding Deal fields    *
      *             for input into the Midas database.                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CGL165             Date 17Feb15               *
      *  Prev Amend No. CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 AR1083027          Date 31Jan13               *
      *                 CRE073             Date 06Dec10               *
      *                 260972             Date 07Jul09               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG24184           Date 15Jun09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 04Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG9717            Date 29Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CAS008             Date 16Jun04               *
      *                 CGL014             Date 23Apr04               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 CAS005             Date 16Dec02               *
      *                 CAS004             Date 26Jun02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CAP042  *CREATE    Date 08Jan01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompiled)                                        *
      *  AR1083027 - Fix Base Rate error appeared when another field  *
      *              is being amended                                 *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  260972 - Amended program so that it will not check for pro-  *
      *           fit center description and will issue an error mes  *
      *           sage if it is blank and default profit centre is N. *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  BUG24184 - Ensures that Profit Centre will have a value even *
      *             if BKPRCU is equal to 'N'                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG9717- Defaulting of class should be done when CDL038      *
      *           feature is currently ON.                            *
      *  CDL038 - Extended Deal Sub Type                              *
      *  CAS008 - IAS 39 Enhancements                                 *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CDL020 - Apply Base Rate at Value Date                       *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *  CAS004 - Hedge Accounting Phase A                            *
      *  CAP042 - Conversion of Internal Funding Deal inputs into     *
      *           modular structure to use as APIs.                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    05         SCAN: String '?' found indicator                *
      *    10         LOOKUP: Equal Indicator                         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRBRC1      - Validate Branch Code 1                          *
      * SRDSTP      - Validate Deal Subtype 1 & 2                     *
      * SRBOK1      - Validate Book Code 1                            *
      * SRPRFC      - Validate Profit Centre 1 & 2                    *
      * SRPRFCDesc  - Get Profit Centre Description                   *
      * SRDADN      - Validate Associated Deal Number                 *
      * SRBRC2      - Validate Branch Code 2                          *
      * SRBOK2      - Validate Book Code 2                            *
      * SRDDAT      - Validate Deal Date                              *
      * SRVDAT      - Validate Value Date                             *
      * SRMDAT      - Validate Maturity Date                          *
      * SRNTCE      - Validate Notice Days                            *
      * SRCURR      - Validate Currency Code                          *
      * SRAMNP      - Validate Principal Amount                       *
      * SRBCXR      - Validate Base Currency Rate                     *
      * SRBRTT      - Validate Base Rate Code                         *
      * SRRTSP      - Validate Rate/Spread                            *
      * SRICBS      - Validate Interest Calculation Basis             *
      * SRIPFR      - Validate Interest Payment Frequency             *
      * SRNIDT      - Validate Next Interest Date                     *
      * SRTOTI      - Validate Total Interest                         *
      * SRINTF      - Validate Interest Frequency Day in Month        *
      * SRCPTI      - Validate Capitalise Interest Indicator          *
      * SRLNKR      - Validate Linked Deal Number                     *
      * SRORBR      - Validate Originating Branch Code                *
      * SRResetErrs - Reset Error Information                         *
      * SRUpdatErrs - Update Error Information                        *
      * SRSetErrFld - Setup error fields for reuse modules            *
      * SRFixBsRte  - Validate Fix Base Rate                          *                       CDL019
      * SRActInRte  - Validate Actual Interest Rate                   *                       CDL020
      * *PSSR       - Error processing                                *
      * *INZSR      - Initialise                                      *
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
 
      ** Hook to enable non-core files to be included
      /COPY WNCPYSRC,ABFUNDV001
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      ** Standard D-specs
      ** ================
 
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *On (for indicator processing)
      **    False      logical = *Off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
      /COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
      /COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
 
      /COPY ZACPYSRC,ERR_ARRAYS
 
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
 
      /COPY ZACPYSRC,ERR_XARRYS
 
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
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ ===================================  ¦
      ** +--------------------------------------+
 
      ** External DS for profit centre details
     D SDPRFC        E DS                  EXTNAME(SDPRFCPD)
                                                                                              CDL020
      ** External DS For midas modules details                                                CDL020
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                                  CDL020
     D  @BGNOST      E                     EXTFLD(BGNOST)                                     CDL020
                                                                                              CDL020
      ** First DS for access programs, short data structure                                   CDL020
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CDL020
 
      *                                                                                      BUG9171
      ** External DS for SAR Details                                                         BUG9171
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                 BUG9171
      *                                                                                      BUG9171
      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** New Deal in Screen Format
     D NwDlScnFmt    E DS                  EXTNAME(ABFUNDPD)
     D                                     PREFIX(DD:2)
 
      ** Current Deal in Screen Format
     D CrDlScnFmt    E DS                  EXTNAME(ABFUNDPD)
     D                                     PREFIX(DC:2)
 
      ** Internal funding deals error indicator file
     D OkFlags       E DS                  EXTNAME(ABEFUNDPD)
 
      ** New Deal in File Format of main deal
     D NwDlFilFmt1   E DS                  EXTNAME(MMVLDNIPD)
     D                                     Prefix(N1:2)
     D  QQDoriN1     E                     EXTFLD(QQDORI)                                     CGL029
     D  QQMoriN1     E                     EXTFLD(QQMORI)                                     CGL029
     D  QQDopiN1     E                     EXTFLD(QQDOPI)                                     CGL029
     D  QQMopiN1     E                     EXTFLD(QQMOPI)                                     CGL029
     D  QQRonsN1     E                     EXTFLD(QQRONS)                                     CGL029
     D  QQPonsN1     E                     EXTFLD(QQPONS)                                     CGL029
     D  QQInsaN1     E                     EXTFLD(QQINSA)                                     CGL029
 
      ** New Deal in File Format of associated deal
     D NwDlFilFmt2   E DS                  EXTNAME(MMVLDNIPD)
     D                                     Prefix(N2:2)
     D  QQDoriN2     E                     EXTFLD(QQDORI)                                     CGL029
     D  QQMoriN2     E                     EXTFLD(QQMORI)                                     CGL029
     D  QQDopiN2     E                     EXTFLD(QQDOPI)                                     CGL029
     D  QQMopiN2     E                     EXTFLD(QQMOPI)                                     CGL029
     D  QQRonsN2     E                     EXTFLD(QQRONS)                                     CGL029
     D  QQPonsN2     E                     EXTFLD(QQPONS)                                     CGL029
     D  QQInsaN2     E                     EXTFLD(QQINSA)                                     CGL029
 
      ** Current Deal in File Format of main deal
     D CrDlFilFmt1   E DS                  EXTNAME(MMDELDPP)
     D                                     Prefix(D1:2)
     D  QQDoriD1     E                     EXTFLD(QQDORI)                                     CGL029
     D  QQMoriD1     E                     EXTFLD(QQMORI)                                     CGL029
     D  QQDopiD1     E                     EXTFLD(QQDOPI)                                     CGL029
     D  QQMopiD1     E                     EXTFLD(QQMOPI)                                     CGL029
     D  QQRonsD1     E                     EXTFLD(QQRONS)                                     CGL029
     D  QQPonsD1     E                     EXTFLD(QQPONS)                                     CGL029
     D  QQInsaD1     E                     EXTFLD(QQINSA)                                     CGL029
 
      ** Current Deal in File Format of associated deal
     D CrDlFilFmt2   E DS                  EXTNAME(MMDELDPP)
     D                                     Prefix(D2:2)
     D  QQDoriD2     E                     EXTFLD(QQDORI)                                     CGL029
     D  QQMoriD2     E                     EXTFLD(QQMORI)                                     CGL029
     D  QQDopiD2     E                     EXTFLD(QQDOPI)                                     CGL029
     D  QQMopiD2     E                     EXTFLD(QQMOPI)                                     CGL029
     D  QQRonsD2     E                     EXTFLD(QQRONS)                                     CGL029
     D  QQPonsD2     E                     EXTFLD(QQPONS)                                     CGL029
     D  QQInsaD2     E                     EXTFLD(QQINSA)                                     CGL029
 
      ** External data structure for Deal Subtype details
     D SDDLST        E DS                  EXTNAME(SDDLSTPD)
 
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  StrFoundIn            05     05
     D  EqualInd              10     10
 
      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0
 
      ** Index for arrays of warning error message ids, etc.
     D WIDx            S              3P 0
 
      ** Update error index
     D Ix              S              3P 0
 
      ** Mode of processing
     D PMode           S              6A
 
      ** Response Mode, received as a parameter from the common header
     D PResponse       S              1A
 
      ** Redisplay screen flag
     D PReDsp          S              1A
 
      ** Standing Data
     D BJDFIN          S              1A
     D BJCYCD          S              3A
     D BJSBRC          S              3A
     D BJSLCD          S              3A
     D BJLCCY          S              3A
     D BJCUST          S              6A
     D BJRDNB          S              5P 0
     D BJBVPD          S              3P 0
     D BKPRCU          S              1A
     D BKOBRU          S              1A
     D BKOBUV          S              1A
     D BKPRCA          S              1A
     D BKPCDU          S              1A
     D BNDCSP          S              1A
     D BGNOST          S              1A
     D BLBRCF          S              1A
 
      ** Work Parameters
     D PDealDate       S              5P 0
     D PValDate        S              5P 0
     D PMatDate        S              5P 0
     D POREDDayNo      S              5P 0
     D PSLIDDayNo      S              5P 0
     D PIACDDayNo      S              5P 0
     D PNtceDay        S              3  0
     D PSpotRate       S             13P 8
     D PDecPlace       S              1  0
     D PMulDivIn       S              1A
     D PScaleExp       S              1  0
     D PIntCalcB       S              1A
     D PAcntOfr1       S              2A
     D PAcntOfr2       S              2A
     D PCustNo1        S              6A
     D PCustNo2        S              6A
     D PLCcyCode1      S              3A
     D PLCcyCode2      S              3A
     D PLocnCode1      S              3A
     D PLocnCode2      S              3A
     D PACOC           S              2A
     D PRATE           S             11P 7
     D DBRN            S              3A
     D DPPT            S              3A
     D AGMBIN          S              1A
     D PPCCd           S              4A
     D WPRFCd          S              4A
     D WPCDesc         S             30A
     D PPCDesc1        S             30A
     D PPCDesc2        S             30A
     D PValFlg         S              1A
 
      ** Work variables
     D PMsgID          S                   LIKE(#MSGID)
     D PWMsgID         S                   LIKE(#MSGID)
     D WStypInd        S              1A
     D WPrCnInd        S              1A
     D WSFldNam        S              6A
     D DDPRFC          S              4A
     D DDTYPE          S              2A
     D PCUST           S              6A
     D DDBOKC          S              2A
     D DDSTYP          S              2A
     D DDCLAS          S              4A                                                      CDL038
     D DDBRCA          S              3A
     D WCustOk         S              1A
 
      ** Parameters for ZA0840
     D PRetCode        S                   LIKE(ReturnCode)
     D PAlpha          S             16A
     D PIDP            S              3  0
     D PIINT           S              3  0
     D PIMTID          S              1A
     D POErrCde        S              1  0
     D POAmount        S             15  0
      * (BNDCSP)
 
      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))
 
     D CAS004          S              1A                                                      CAS004
     D PDealType       S              2A                                                      CAS004
     D PERTP           S              1A                                                      CAS004
     D PYCFN           S              6A                                                      CAS004
     D PYLDC           S              5A                                                      CAS004
     D PFwRv           S              1A                                                      CAS005
     D PFwYC           S              5A                                                      CAS005
     D PFCRv           S              1A                                                      CAS008
 
     D CDL019          S              1A                                                      CDL019
     D CDL020          S              1A                                                      CDL020
     D PSARD           S              6A                                                     BUG9717
     D PRTCD           S              7A                                                     BUG9717
     D POPTN           S              7A                                                     BUG9717
     D CDL038          S              1A                                                     BUG9717
 
      /COPY WNCPYSRC,ABFUNDV002
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      /COPY WNCPYSRC,ABFUNDV003
 
      *  *------------------------*
      *  * Validate Branch Code 1 *
      *  *------------------------*
 
      /COPY WNCPYSRC,ABFUNDV004
 
     C                   EXSR      SRBRC1
 
      /COPY WNCPYSRC,ABFUNDV005
 
      *  *--------------------------*
      *  * Validate Deal Sub-Type 1 *
      *  *          and Class 1     *                                                         CDL038
      *  *--------------------------*
 
      /COPY WNCPYSRC,ABFUNDV006
 
     C                   EVAL      WStypInd = '1'
 
     C                   EVAL      DDType = 'IL'                                              CDL038
     C                   EVAL      DDStyp = DDSTP1
     C                   EVAL      DDClas = DDCLS1                                            CDL038
     C                   EVAL      DDBokc = DDBOK1                                            CDL038
     C                   EVAL      DDPrfc = DDPRF1                                            CDL038
 
     C                   EXSR      SRDSTP
 
      /COPY WNCPYSRC,ABFUNDV007
 
      *  *----------------------*
      *  * Validate Book Code 1 *
      *  *----------------------*
 
      /COPY WNCPYSRC,ABFUNDV008
 
     C                   EXSR      SRBOK1
 
      /COPY WNCPYSRC,ABFUNDV009
 
      *  *--------------------------*
      *  * Validate Profit Centre 1 *
      *  *--------------------------*
 
      /COPY WNCPYSRC,ABFUNDV010
 
     C                   EVAL      WPrCnInd = '1'
 
     C                   EVAL      DDPRFC = DDPRF1
     C                   EVAL      DDTYPE = 'IL'
     C                   EVAL      PACOC = PAcntOfr1
     C                   EVAL      PCUST  = PCustNo1
     C                   EVAL      DDBOKC = DDBOK1
     C                   EVAL      DDSTYP  = DDSTP1
     C                   EVAL      DDBRCA = DDBRC1
 
     C                   EXSR      SRPRFC
 
      /COPY WNCPYSRC,ABFUNDV011
 
      *  *---------------------------------*
      *  * Validate Associated Deal Number *
      *  *---------------------------------*
 
      /COPY WNCPYSRC,ABFUNDV012
 
     C                   EXSR      SRDADN
 
      /COPY WNCPYSRC,ABFUNDV013
 
      *  *------------------------*
      *  * Validate Branch Code 2 *
      *  *------------------------*
 
      /COPY WNCPYSRC,ABFUNDV014
 
     C                   EXSR      SRBRC2
 
      /COPY WNCPYSRC,ABFUNDV015
 
      *  *--------------------------*
      *  * Validate Deal Sub-Type 2 *
      *  *          and Class 2     *                                                         CDL038
      *  *--------------------------*
 
      /COPY WNCPYSRC,ABFUNDV016
 
     C                   EVAL      WStypInd = '2'
 
     C                   EVAL      DDType = 'ID'                                              CDL038
     C                   Eval      DDStyp = DDSTP2
     C                   EVAL      DDClas = DDCLS2                                            CDL038
     C                   EVAL      DDBokc = DDBOK2                                            CDL038
     C                   EVAL      DDPrfc = DDPRF2                                            CDL038
 
     C                   EXSR      SRDSTP
 
      /COPY WNCPYSRC,ABFUNDV017
 
      *  *----------------------*
      *  * Validate Book Code 2 *
      *  *----------------------*
 
      /COPY WNCPYSRC,ABFUNDV018
 
     C                   EXSR      SRBOK2
 
      /COPY WNCPYSRC,ABFUNDV019
 
      *  *--------------------------*
      *  * Validate Profit Centre 2 *
      *  *--------------------------*
 
      /COPY WNCPYSRC,ABFUNDV020
 
     C                   EVAL      WPrCnInd = '2'
 
     C                   EVAL      DDPRFC = DDPRF2
     C                   EVAL      DDTYPE = 'ID'
     C                   EVAL      PACOC = PAcntOfr2
     C                   EVAL      PCUST  = PCustNo2
     C                   EVAL      DDBOKC = DDBOK2
     C                   EVAL      DDSTYP  = DDSTP2
     C                   EVAL      DDBRCA = DDBRC2
 
     C                   EXSR      SRPRFC
 
      /COPY WNCPYSRC,ABFUNDV021
 
      *  *--------------------*
      *  * Validate Deal Date *
      *  *--------------------*
 
      /COPY WNCPYSRC,ABFUNDV022
 
     C                   EXSR      SRDDAT
 
      /COPY WNCPYSRC,ABFUNDV023
 
      *  *---------------------*
      *  * Validate Value Date *
      *  *---------------------*
 
      /COPY WNCPYSRC,ABFUNDV024
 
     C                   EXSR      SRVDAT
 
      /COPY WNCPYSRC,ABFUNDV025
 
      *  *------------------------*
      *  * Validate Maturity Date *
      *  *------------------------*
 
      /COPY WNCPYSRC,ABFUNDV026
 
     C                   EXSR      SRMDAT
 
      /COPY WNCPYSRC,ABFUNDV027
 
      *  *----------------------*
      *  * Validate Notice Days *
      *  *----------------------*
 
      /COPY WNCPYSRC,ABFUNDV028
 
     C                   IF        OKMDAT <> 'N'
 
     C                   EXSR      SRNTCE
 
     C                   ENDIF
 
      /COPY WNCPYSRC,ABFUNDV029
 
      *  *------------------------*
      *  * Validate Currency Code *
      *  *------------------------*
 
      /COPY WNCPYSRC,ABFUNDV030
 
     C                   EXSR      SRCURR
 
      /COPY WNCPYSRC,ABFUNDV031
 
      *  *---------------------------*
      *  * Validate Principal Amount *
      *  *---------------------------*
 
      /COPY WNCPYSRC,ABFUNDV032
 
     C                   IF        OKCCY <> 'N'
 
     C                   EXSR      SRAMNP
 
     C                   ENDIF
 
      /COPY WNCPYSRC,ABFUNDV033
 
      *  *-----------------------------*
      *  * Validate Base Currency Rate *
      *  *-----------------------------*
 
      /COPY WNCPYSRC,ABFUNDV034
 
     C                   IF        DDCCY <> *BLank AND
     C                             OKCCY <> 'N'
 
     C                   EXSR      SRBCXR
 
     C                   ENDIF
 
      /COPY WNCPYSRC,ABFUNDV035
 
      *  *-------------------------*
      *  * Validate Base Rate Code *
      *  *-------------------------*
 
      /COPY WNCPYSRC,ABFUNDV036
 
     C                   EXSR      SRBRTT
 
      /COPY WNCPYSRC,ABFUNDV037
 
      *  *----------------------*
      *  * Validate Rate/Spread *
      *  *----------------------*
 
      /COPY WNCPYSRC,ABFUNDV038
 
     C                   EXSR      SRRTSP
 
      /COPY WNCPYSRC,ABFUNDV039
 
      *  *-------------------------------*                                                    CDL020
      *  * Validate Actual Interest Rate *                                                    CDL020
      *  *-------------------------------*                                                    CDL020
                                                                                              CDL020
     C                   IF        CDL020 = 'Y'                                               CDL020
     C                   EXSR      SRActInRte                                                 CDL020
     C                   ENDIF                                                                CDL020
                                                                                              CDL020
      *  *-------------------------------------*
      *  * Validate Interest Calculation Basis *
      *  *-------------------------------------*
 
      /COPY WNCPYSRC,ABFUNDV040
 
     C                   EXSR      SRICBS
 
      /COPY WNCPYSRC,ABFUNDV041
 
      *  *-------------------------------------*
      *  * Validate Interest Payment Frequency *
      *  *-------------------------------------*
 
      /COPY WNCPYSRC,ABFUNDV042
 
     C                   EXSR      SRIPFR
 
      /COPY WNCPYSRC,ABFUNDV043
 
      *  *-----------------------------*
      *  * Validate Next Interest Date *
      *  *-----------------------------*
 
      /COPY WNCPYSRC,ABFUNDV044
 
     C                   EXSR      SRNIDT
 
      /COPY WNCPYSRC,ABFUNDV045
 
      *  *-------------------------*
      *  * Validate Total Interest *
      *  *-------------------------*
 
      /COPY WNCPYSRC,ABFUNDV046
 
     C                   EXSR      SRTOTI
 
      /COPY WNCPYSRC,ABFUNDV047
 
      *  *------------------------------------------*
      *  * Validate Interest Frequency Day in Month *
      *  *------------------------------------------*
 
      /COPY WNCPYSRC,ABFUNDV048
 
     C                   EXSR      SRINTF
 
      /COPY WNCPYSRC,ABFUNDV049
 
      *  *----------------------------------------*
      *  * Validate Capitalise Interest Indicator *
      *  *----------------------------------------*
 
      /COPY WNCPYSRC,ABFUNDV050
 
     C                   EXSR      SRCPTI
 
      /COPY WNCPYSRC,ABFUNDV051
 
      *  *-----------------------------*
      *  * Validate Linked Deal Number *
      *  *-----------------------------*
 
      /COPY WNCPYSRC,ABFUNDV052
 
     C                   EXSR      SRLNKR
 
      /COPY WNCPYSRC,ABFUNDV053
 
      *  *----------------------------------*
      *  * Validate Originating Branch Code *
      *  *----------------------------------*
 
      /COPY WNCPYSRC,ABFUNDV054
 
     C                   EXSR      SRORBR
                                                                                              CAS004
     C                   IF        CAS004 = 'Y'                                               CAS004
     C                   EXSR      SRYldCurve                                                 CAS004
     C                   ENDIF                                                                CAS004
                                                                                              CDL019
      *  *------------------------*                                                           CDL019
      *  * Validate Fix Base Rate *                                                           CDL019
      *  *------------------------*                                                           CDL019
                                                                                              CDL019
     C                   IF        CDL019 = 'Y'                                               CDL019
     C                   EXSR      SRFixBsRte                                                 CDL019
     C                   ENDIF                                                                CDL019
 
      *                  ======
     C                   RETURN
      *                  ======
 
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
      /EJECT
      /COPY WNCPYSRC,ABFUNDV055
      *****************************************************************
      *                                                               *
      *  SRBRC1 - Branch Code 1                                       *
      *                                                               *
      *****************************************************************
 
     C     SRBRC1        BEGSR
 
      ** Reset variables updated by each module
 
     C                   EXSR      SRResetErrs
 
      ** Call validation module
 
     C                   CALLB     'ABVBKBH01'
      *                             =========
      ** INPUTS
      ** ======
 
      ** Return code
     C                   PARM                    RetCodeOut
 
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
 
      ** Response Mode
     C                   PARM                    PResponse
 
      ** New Deal in Screen Format
     C                   PARM                    NwDlScnFmt
 
      ** Standing Data
      ** =============
      ** SDBANK: Single Branch Code
     C                   PARM                    BJSBRC
      ** SDBANK: System Location Code
     C                   PARM                    BJSLCD
      ** SDBANK: Local Currency Code
     C                   PARM                    BJLCCY
      ** SDBANK: Customer Number
     C                   PARM                    BJCUST
 
      ** RUNDAT: Multibranching Indicator
     C                   PARM                    AGMBIN
 
      ** ZMUSER: Default Branch
     C                   PARM                    DBRN
 
      ** OUTPUT
      ** ======
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Internal funding deals error indicator file
     C                   PARM                    OkFlags
 
      ** New Deal in File Format of main deal
     C                   PARM                    NwDlFilFmt1
 
      ** New Deal in File Format of associated deal
     C                   PARM                    NwDlFilFmt2
 
      ** Redisplay screen flag
     C                   PARM                    PReDsp
 
      ** Account Officer
     C                   PARM                    PAcntOfr2
 
      ** Branch Internal Customer
     C                   PARM                    PCustNo2
 
      ** Local Currency Code 1
     C                   PARM                    PLCcyCode1
 
      ** Location Code 1
     C                   PARM                    PLocnCode1
 
      ** Update error info with that returned from the validation module
 
     C                   IF        RetCodeOut <> *Blanks
 
     C                   EXSR      SRUpdatErrs
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDSTP - Deal Sub-types                                      *
      *                                                               *
      *****************************************************************
 
     C     SRDSTP        BEGSR
      *                                                                                       CDL038
      *  *-------------------------------*                                                    CDL038
      *  * Default Sub Type and Class                                                         CDL038
      *  *-------------------------------*                                                    CDL038
      *                                                                                       CDL038
     C                   IF        CDL038 = 'Y'                                              BUG9717
     C                   EXSR      DSUBTCLAS                                                  CDL038
     C                   ENDIF                                                               BUG9717
 
      ** Reset variables updated by each module
 
     C                   EXSR      SRResetErrs
 
     C     '?'           SCAN      DDStyp                                 05
 
     C                   IF        StrFoundIn = True
 
     C                   EVAL      PReDsp = 'Y'
 
     C                   IF        PMode = '*FRONT'
 
     C                   EVAL      PMsgID = 'MMM0113'
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        PMsgID = *Blank
 
      ** Call validation module
 
     C                   CALLB     'MMVDLSTYPE'
      *                             ==========
 
     C                   PARM                    RetCodeOut
     C                   PARM                    PMsgID
     C                   PARM                    DDStyp
     C                   PARM                    SDDLST
 
      ** If no select
 
     C                   IF        StrFoundIn = True
 
     C     '?'           SCAN      DDStyp                                 05
 
     C                   IF        StrFoundIn = True
 
     C                   EVAL      PMsgID = 'MMM0246'
 
     C                   IF        WStypInd = '1'
 
     C                   EVAL      DDSTP1 = *Blanks
 
     C                   ELSE
 
     C                   EVAL      DDSTP2 = *Blanks
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Update error info with that returned from the validation module
 
     C                   IF        PMsgID <> *Blanks
 
      ** Error in Deal Subtype 1
 
     C                   IF        WStypInd = '1'
 
     C                   EVAL      OKSTP1 = 'N'
     C                   EVAL      WSFldNam = '#1STP1'
 
     C                   ELSE
 
      ** Error in Deal Subtype 2
 
     C                   EVAL      OKSTP2 = 'N'
     C                   EVAL      WSFldNam = '#1STP2'
 
     C                   ENDIF
 
     C                   EXSR      SRSetErrFld
     C                   EXSR      SRUpdatErrs
 
      ** No error
 
     C                   ELSE
 
      ** Deal subtype 1
 
     C                   IF        WStypInd = '1'
 
     C                   EVAL      N1STYP = DDStyp
     C                   EVAL      DDSTP1 = DDStyp
 
     C                   ELSE
 
      ** Deal subtype 2
 
     C                   EVAL      N2STYP = DDStyp
     C                   EVAL      DDSTP2 = DDStyp
 
     C                   ENDIF
 
     C                   ENDIF
                                                                                              CDL038
      ** Validate sub-type and class                                                          CDL038
                                                                                              CDL038
     C                   IF        PMsgID = *Blank                                            CDL038
     C                   CALLB     'IRVDEALTPS'                                               CDL038
     C                   PARM      *BLANK        RetCodeOut                                   CDL038
     C                   PARM      *BLANK        PmsgID1           7                          CDL038
     C                   PARM      *BLANK        PmsgID2           7                          CDL038
     C                   PARM                    DDType                                       CDL038
     C                   PARM                    DDStyp                                       CDL038
     C                   PARM                    DDClas                                       CDL038
                                                                                              CDL038
     C     PmsgID1       IFNE      *BLANK                                                     CDL038
     C                   IF        WStypInd = '1'                                             CDL038
     C                   EVAL      OKCLS1 = 'N'                                               CDL038
     C                   EVAL      WSFldNam = '#1CLS1'                                        CDL038
     C                   ELSE                                                                 CDL038
     C                   EVAL      OKCLS2 = 'N'                                               CDL038
     C                   EVAL      WSFldNam = '#1CLS2'                                        CDL038
     C                   ENDIF                                                                CDL038
     C                   EVAL      PMsgID = PmsgID1                                           CDL038
     C                   EXSR      SRSetErrFld                                                CDL038
     C                   EXSR      SRUpdatErrs                                                CDL038
     C                   ENDIF                                                                CDL038
     C     PmsgID2       IFNE      *BLANK                                                     CDL038
     C                   EXSR      SRResetErrs                                                CDL038
     C                   IF        WStypInd = '1'                                             CDL038
     C                   EVAL      OKSTP1 = 'N'                                               CDL038
     C                   EVAL      OKCLS1 = 'N'                                               CDL038
     C                   EVAL      WSFldNam = '#1STP1'                                        CDL038
     C                   ELSE                                                                 CDL038
     C                   EVAL      OKSTP2 = 'N'                                               CDL038
     C                   EVAL      OKCLS2 = 'N'                                               CDL038
     C                   EVAL      WSFldNam = '#1STP2'                                        CDL038
     C                   ENDIF                                                                CDL038
     C                   EVAL      PMsgID = PmsgID2                                           CDL038
     C                   EXSR      SRSetErrFld                                                CDL038
     C                   EXSR      SRUpdatErrs                                                CDL038
     C                   ENDIF                                                                CDL038
                                                                                              CDL038
     C                   ENDIF                                                                CDL038
                                                                                              CDL038
      ** Class 1 and Class 2                                                                  CDL038
                                                                                              CDL038
     C                   IF        WStypInd = '1'                                             CDL038
     C                   EVAL      N1CLAS = DDClas                                            CDL038
     C                   EVAL      DDCLS1 = DDClas                                            CDL038
     C                   ELSE                                                                 CDL038
     C                   EVAL      N2CLAS = DDClas                                            CDL038
     C                   EVAL      DDCLS2 = DDClas                                            CDL038
     C                   ENDIF                                                                CDL038
 
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
     C                   PARM                    DDACTN                                       CDL038
     C                   PARM                    DDType                                       CDL038
     C                   PARM                    @Customer        10                          CDL038
     C                   PARM                    DDVDAT                                       CDL038
     C                   PARM                    DDMDAT                                       CDL038
     C                   PARM                    DDBokc                                       CDL038
     C                   PARM                    DDPrfc                                       CDL038
     C                   PARM                    DDCCY                                        CDL038
     C                   PARM      *BLANK        @Currency2        3                          CDL038
     C                   PARM      *BLANK        @RelatedDeal      6                          CDL038
      * Inputs/Outputs                                                                        CDL038
     C                   PARM                    DDStyp                                       CDL038
     C                   PARM                    DDClas                                       CDL038
      *                                                                                       CDL038
     C                   ENDSR                                                                CDL038
      *****************************************************************                       CDL038
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBOK1 - Book Code 1                                         *
      *                                                               *
      *****************************************************************
 
     C     SRBOK1        BEGSR
 
      ** Reset variables updated by each module
 
     C                   EXSR      SRResetErrs
 
      ** Call validation module
 
     C                   CALLB     'ABVBKCD01'
      *                             =========
      ** INPUTS
      ** ======
 
      ** Return code
     C                   PARM                    RetCodeOut
 
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
 
      ** New Deal in Screen Format
     C                   PARM                    NwDlScnFmt
 
      ** OUTPUT
      ** ======
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Internal funding deals error indicator file
     C                   PARM                    OkFLags
 
      ** New Deal in File Format of main deal
     C                   PARM                    NwDlFilFmt1
 
      ** Redisplay screen flag
     C                   PARM                    PReDsp
 
      ** Update error info with that returned from the validation module
 
     C                   IF        RetCodeOut <> *Blanks
 
     C                   EXSR      SRUpdatErrs
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPRFC - Profit Centres                                      *
      *                                                               *
      *****************************************************************
 
     C     SRPRFC        BEGSR
 
      ** Reset variables updated by each module
 
     C                   EXSR      SRResetErrs
 
     C     '?'           SCAN      DDPRFC                                 05
 
     C                   IF        StrFoundIn = True
 
     C                   EVAL      PReDsp = 'Y'
 
     C                   IF        PMode = '*FRONT'
 
     C                   EVAL      PMsgID = 'FXM4001'
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        PMsgID = *Blank
 
      ** Call validation module
 
     C                   CALLB     'ZAVPROFITC'
      *                             ==========
 
     C                   PARM                    RetCodeOut
     C                   PARM                    PMsgID
     C                   PARM                    DDPRFC
     C                   PARM                    BKPRCU
     C                   PARM                    BKPRCA
     C                   PARM                    BKPCDU
     C                   PARM                    DDTYPE
     C                   PARM                    PACOC
     C                   PARM                    PCUST
     C                   PARM                    DDBOKC
     C                   PARM                    DDSTYP
     C                   PARM                    DDBRCA
     C                   PARM                    DPPT
     C                   PARM                    PSUSER
     C                   PARM      'Y'           WCustOk
     C                   PARM                    BGNOST
 
      ** If no select
 
     C                   IF        StrFoundIn = True
 
     C     '?'           SCAN      DDPRFC                                 05
 
     C                   IF        StrFoundIn = True
 
      ** If profit centre defaults used is on
 
     C                   IF        BKPCDU = 'Y'
 
      ** Call ZAVPROFITC again to get default value
 
     C                   EVAL      PMsgID = *Blank
     C                   EVAL      DDPRFC = *Blank
 
     C                   CALLB     'ZAVPROFITC'
      *                             ==========
 
     C                   PARM                    RetCodeOut
     C                   PARM                    PMsgID
     C                   PARM                    DDPRFC
     C                   PARM                    BKPRCU
     C                   PARM                    BKPRCA
     C                   PARM                    BKPCDU
     C                   PARM                    DDTYPE
     C                   PARM                    PACOC
     C                   PARM                    PCUST
     C                   PARM                    DDBOKC
     C                   PARM                    DDSTYP
     C                   PARM                    DDBRCA
     C                   PARM                    DPPT
     C                   PARM                    PSUSER
     C                   PARM      'Y'           WCustOk
     C                   PARM                    BGNOST
 
      ** If there is no default value, clear '?' from the screen then
      ** send error message
 
     C                   IF        DDPRFC = *Blank
 
     C                   IF        WPrCnInd = '1'
 
     C                   EVAL      DDPRF1 = *Blanks
 
     C                   ELSE
 
     C                   EVAL      DDPRF2 = *Blanks
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ELSE
 
      ** Profit centre defaults used is off
 
     C                   EVAL      PMsgID = 'FXM4001'
 
     C                   IF        WPrCnInd = '1'
 
     C                   EVAL      DDPRF1 = *Blanks
 
     C                   ELSE
 
     C                   EVAL      DDPRF2 = *Blanks
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Update error info with that returned from the validation module
 
     C                   IF        PMsgID <> *Blanks
 
      ** Error in Profit Centre 1
 
     C                   IF        WPrCnInd = '1'
 
     C                   EVAL      OKPRF1 = 'N'
     C                   EVAL      WSFldNam = '#1PRF1'
 
     C                   ELSE
 
      ** Error in Profit Centre 2
 
     C                   EVAL      OKPRF2 = 'N'
     C                   EVAL      WSFldNam = '#1PRF2'
 
     C                   ENDIF
 
     C                   EXSR      SRSetErrFld
     C                   EXSR      SRUpdatErrs
 
      ** No error
 
     C                   ELSE
 
      ** Don't get profit centre description if profit centre not used
 
     C                   IF        BKPRCU <> 'N'
 
      ** Profit Centre 1
 
     C                   IF        WPrCnInd = '1'
 
     C                   IF        DDPRFC <> *Blanks                                          260972
      *                                                                                       260972
     C                   EVAL      N1PRFC = DDPRFC
     C                   EVAL      DDPRF1 = DDPRFC
 
      ** Get profit centre description
 
     C                   EVAL      WPRFCd = DDPRFC
     C                   EVAL      WPCDesc = *BLANK
     C                   EXSR      SRPRFCDesc
     C                   EVAL      PPCDesc1 = WPCDesc
      *                                                                                       260972
     C                   ELSE                                                                 260972
     C                   EVAL      PMsgID = 'FXM4001'                                         260972
     C                   EVAL      OKPRF1 = 'N'                                               260972
     C                   EVAL      WSFldNam = '#1PRF1'                                        260972
     C                   EXSR      SRSetErrFld                                                260972
     C                   EXSR      SRUpdatErrs                                                260972
      *                                                                                       260972
     C                   ENDIF                                                                260972
     C
     C                   ELSE
 
      ** Profit Centre 2
 
     C                   IF        DDPRFC <> *Blanks                                          260972
      *                                                                                       260972
     C                   EVAL      N2PRFC = DDPRFC
     C                   EVAL      DDPRF2 = DDPRFC
 
      ** Get profict centre description
 
     C                   EVAL      WPRFCd = DDPRFC
     C                   EVAL      WPCDesc = *BLANK
     C                   EXSR      SRPRFCDesc
     C                   EVAL      PPCDesc2 = WPCDesc
      *                                                                                       260972
     C                   ELSE                                                                 260972
     C                   EVAL      PMsgID = 'FXM4001'                                         260972
     C                   EVAL      OKPRF2 = 'N'                                               260972
     C                   EVAL      WSFldNam = '#1PRF2'                                        260972
     C                   EXSR      SRSetErrFld                                                260972
     C                   EXSR      SRUpdatErrs                                                260972
      *                                                                                       260972
     C                   ENDIF                                                                260972
 
     C                   ENDIF
 
     C                   ELSE                                                               BUG24184
     C                   IF        WPrCnInd = '1'                                           BUG24184
     C                   EVAL      N1PRFC = DDPRFC                                          BUG24184
     C                   ELSE                                                               BUG24184
     C                   EVAL      N2PRFC = DDPRFC                                          BUG24184
     C                   ENDIF                                                              BUG24184
                                                                                            BUG24184
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPRFCDesc - Get profit centre description                   *
      *                                                               *
      *****************************************************************
 
     C     SRPRFCDesc    BEGSR
 
      **  Access the profit centre file to find the description of
      **  the profit centre code
 
     C                   CALLB     'AOPRFCR0'
     C                   PARM      *BLANK        @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM      WPRFCd        PPCCd
     C     SDPRFC        PARM      SDPRFC        DSSDY
 
      ** Database Error
 
     C                   IF        @RtCd <> *BLANK
     C                   EVAL      DBKEY = WPRFCd                               *************
     C                   EVAL      DBFILE = 'SDPRFCPD'                          * DBERR 001 *
     C                   EVAL      DBASE  = 001                                 *************
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      WPCDesc = DSPCDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDADN - Associated Deal Number                              *
      *                                                               *
      *****************************************************************
 
     C     SRDADN        BEGSR
 
      ** Reset variables updated by each module
 
     C                   EXSR      SRResetErrs
 
      ** Call validation module
 
     C                   CALLB     'ABVASDL01'
      *                             =========
 
      ** INPUTS
      ** ======
 
      ** Return code
     C                   PARM                    RetCodeOut
 
      ** New Deal in Screen Format
     C                   PARM                    NwDlScnFmt
 
      ** OUTPUT
      ** ======
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Internal funding deals error indicator file
     C                   PARM                    OkFlags
 
      ** New Deal in File Format of main deal
     C                   PARM                    NwDlFilFmt1
 
      ** New Deal in File Format of associated deal
     C                   PARM                    NwDlFilFmt2
 
      ** Update error info with that returned from the validation module
 
     C                   IF        RetCodeOut <> *Blanks
 
     C                   EXSR      SRUpdatErrs
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBRC2 - Branch Code 2                                       *
      *                                                               *
      *****************************************************************
 
     C     SRBRC2        BEGSR
 
      ** Reset variables updated by each module
 
     C                   EXSR      SRResetErrs
 
      ** Call validation module
 
     C                   CALLB     'ABVBKBH02'
      *                             =========
      ** INPUTS
      ** ======
 
      ** Return code
     C                   PARM                    RetCodeOut
 
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
 
      ** Response Mode
     C                   PARM                    PResponse
 
      ** New Deal in Screen Format
     C                   PARM                    NwDlScnFmt
 
      ** Standing Data
      ** =============
 
      ** SDBANK: Single Branch Code
     C                   PARM                    BJSBRC
      ** SDBANK: System Location Code
     C                   PARM                    BJSLCD
      ** SDBANK: Local Currency Code
     C                   PARM                    BJLCCY
      ** SDBANK: Customer Number
     C                   PARM                    BJCUST
 
      ** RUNDAT: Multibranching Indicator
     C                   PARM                    AGMBIN
 
      ** ZMUSER: Default Branch
     C                   PARM                    DBRN
 
      ** OUTPUT
      ** ======
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Internal funding deals error indicator file
     C                   PARM                    OkFlags
 
      ** New Deal in File Format of main deal
     C                   PARM                    NwDlFilFmt1
 
      ** New Deal in File Format of associated deal
     C                   PARM                    NwDlFilFmt2
 
      ** Redisplay screen flag
     C                   PARM                    PReDsp
 
      ** Account Officer
     C                   PARM                    PAcntOfr1
 
      ** Branch Internal Customer
     C                   PARM                    PCustNo1
 
      ** Local Currency Code 2
     C                   PARM                    PLCcyCode2
 
      ** Location Code 2
     C                   PARM                    PLocnCode2
 
      ** Update error info with that returned from the validation module
 
     C                   IF        RetCodeOut <> *Blanks
 
     C                   EXSR      SRUpdatErrs
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBOK2 - Book Code 2                                         *
      *                                                               *
      *****************************************************************
 
     C     SRBOK2        BEGSR
 
      ** Reset variables updated by each module
 
     C                   EXSR      SRResetErrs
 
      ** Call validation module
 
     C                   CALLB     'ABVBKCD02'
      *                             =========
      ** INPUTS
      ** ======
 
      ** Return code
     C                   PARM                    RetCodeOut
 
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
 
      ** New Deal in Screen Format
     C                   PARM                    NwDlScnFmt
 
      ** OUTPUT
      ** ======
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Internal funding deals error indicator file
     C                   PARM                    OkFlags
 
      ** New Deal in File Format of associated deal
     C                   PARM                    NwDlFilFmt2
 
      ** Redisplay screen flag
     C                   PARM                    PReDsp
 
      ** Update error info with that returned from the validation module
 
     C                   IF        RetCodeOut <> *Blanks
 
     C                   EXSR      SRUpdatErrs
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDDAT - Deal Date                                           *
      *                                                               *
      *****************************************************************
 
     C     SRDDAT        BEGSR
 
      ** Reset variables updated by each module
 
     C                   EXSR      SRResetErrs
 
      ** Call validation module
 
     C                   CALLB     'ABVDLDT01'
      *                             =========
      ** INPUTS
      ** ======
 
      ** Return code
     C                   PARM                    RetCodeOut
 
      ** New Deal in Screen Format
     C                   PARM                    NwDlScnFmt
 
      ** Standing Data
      ** =============
 
      ** SDBANK: Date Format Indicator
     C                   PARM                    BJDFIN
      ** SDBANK: Run Day Number
     C                   PARM                    BJRDNB
      ** SDBANK: Back Value Period in Days
     C                   PARM                    BJBVPD
 
      ** Local Currency Code1
     C                   PARM                    PLCcyCode1
 
      ** Location Code 1
     C                   PARM                    PLocnCode1
 
      ** Local Currency Code2
     C                   PARM                    PLCcyCode2
 
      ** Location Code 2
     C                   PARM                    PLocnCode2
 
      ** OUTPUT
      ** ======
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Internal funding deals error indicator file
     C                   PARM                    OkFlags
 
      ** New Deal in File Format of main deal
     C                   PARM                    NwDlFilFmt1
 
      ** New Deal in File Format of associated deal
     C                   PARM                    NwDlFilFmt2
 
      ** Deal Date in Midas Day no. format
     C                   PARM                    PDealDate
 
      ** Update error info with that returned from the validation module
 
     C                   IF        RetCodeOut <> *Blanks
 
     C                   EXSR      SRUpdatErrs
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVDAT - Value Date                                          *
      *                                                               *
      *****************************************************************
 
     C     SRVDAT        BEGSR
 
      ** Reset variables updated by each module
 
     C                   EXSR      SRResetErrs
 
      ** Call validation module
 
     C                   CALLB     'ABVVLDT01'
      *                             =========
      ** INPUTS
      ** ======
 
      ** Return code
     C                   PARM                    RetCodeOut
 
      ** New Deal in Screen Format
     C                   PARM                    NwDlScnFmt
 
      ** Standing Data
      ** =============
 
      ** SDBANK: Date Format Indicator
     C                   PARM                    BJDFIN
      ** SDBANK: Run Day Number
     C                   PARM                    BJRDNB
      ** SDBANK: Local Currency Code
     C                   PARM                    BJLCCY
 
      ** Deal Date in Midas Day no. format
     C                   PARM                    PDealDate
 
      ** OUTPUT
      ** ======
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Warning flds/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIdXAr
     C                   PARM                    WMsgDtXAr
 
      ** Internal funding deals error indicator file
     C                   PARM                    OkFlags
 
      ** New Deal in File Format of main deal
     C                   PARM                    NwDlFilFmt1
 
      ** New Deal in File Format of associated deal
     C                   PARM                    NwDlFilFmt2
 
      ** Value Date in Midas Day no. format
     C                   PARM                    PValDate
 
      ** Update error info with that returned from the validation module
 
     C                   IF        RetCodeOut <> *Blanks
 
     C                   EXSR      SRUpdatErrs
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMDAT - Maturity Date                                       *
      *                                                               *
      *****************************************************************
 
     C     SRMDAT        BEGSR
 
      ** Reset variables updated by each module
 
     C                   EXSR      SRResetErrs
 
      ** Call validation module
 
     C                   CALLB     'ABVMTDT01'
      *                             =========
      ** INPUTS
      ** ======
 
      ** Return code
     C                   PARM                    RetCodeOut
 
      ** New Deal in Screen Format
     C                   PARM                    NwDlScnFmt
 
      ** Current Deal in Screen Format
     C                   PARM                    CrDlScnFmt
 
      ** Current Deal in File Format of main deal
     C                   PARM                    CrDlFilFmt1
 
      ** Standing Data
      ** =============
 
      ** SDBANK: Date Format Indicator
     C                   PARM                    BJDFIN
      ** SDBANK: Run Day Number
     C                   PARM                    BJRDNB
      ** SDBANK: Local Currency Code
     C                   PARM                    BJLCCY
 
      ** Value Date in Midas Day no. format
     C                   PARM                    PValDate
 
      ** OUTPUT
      ** ======
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Warning flds/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIdXAr
     C                   PARM                    WMsgDtXAr
 
      ** Internal funding deals error indicator file
     C                   PARM                    OkFlags
 
      ** New Deal in File Format of main deal
     C                   PARM                    NwDlFilFmt1
 
      ** New Deal in File Format of associated deal
     C                   PARM                    NwDlFilFmt2
 
      ** Maturity Date in Midas Day no. format
     C                   PARM                    PMatDate
 
      ** Original Entry Date in Midas Day format
     C                   PARM                    POREDDayNo
 
      ** Start/Last Interest Date in Midas Day format
     C                   PARM                    PSLIDDayNo
 
      ** Interest Accrual Control Date in Midas Day format
     C                   PARM                    PIACDDayNo
 
      ** Update error info with that returned from the validation module
 
     C                   IF        RetCodeOut <> *Blanks
 
     C                   EXSR      SRUpdatErrs
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNTCE - Notice Days                                         *
      *                                                               *
      *****************************************************************
 
     C     SRNTCE        BEGSR
 
      ** Reset variables updated by each module
 
     C                   EXSR      SRResetErrs
 
      ** Call validation module
 
     C                   CALLB     'ABVNTDY01'
      *                             =========
      ** INPUTS
      ** ======
 
      ** Return code
     C                   PARM                    RetCodeOut
 
      ** New Deal in Screen Format
     C                   PARM                    NwDlScnFmt
 
      ** Current Deal in File Format of main deal
     C                   PARM                    CrDlFilFmt1
 
      ** Standing Data
      ** =============
 
      ** SDBANK: Run Day Number
     C                   PARM                    BJRDNB
 
      ** Maturity Date in Midas Day no. format
     C                   PARM                    PMatDate
 
      ** OUTPUT
      ** ======
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Warning flds/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIdXAr
     C                   PARM                    WMsgDtXAr
 
      ** Internal funding deals error indicator file
     C                   PARM                    OkFlags
 
      ** New Deal in File Format of main deal
     C                   PARM                    NwDlFilFmt1
 
      ** New Deal in File Format of associated deal
     C                   PARM                    NwDlFilFmt2
 
      ** Notice Days
     C                   PARM                    PNtceDay
 
      ** Amended by validation module flag
 
     C                   PARM      *BLANK        PValFlg
 
      ** Update error info with that returned from the validation module
 
     C                   IF        RetCodeOut <> *Blanks
 
     C                   EXSR      SRUpdatErrs
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCURR - Currency Code                                       *
      *                                                               *
      *****************************************************************
 
     C     SRCURR        BEGSR
 
      ** Reset variables updated by each module
 
     C                   EXSR      SRResetErrs
 
      ** Call validation module
 
     C                   CALLB     'ABVCYCD01'
      *                             =========
      ** INPUTS
      ** ======
 
      ** Return code
     C                   PARM                    RetCodeOut
 
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
 
      ** New Deal in Screen Format
     C                   PARM                    NwDlScnFmt
 
      ** OUTPUT
      ** ======
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Internal funding deals error indicator file
     C                   PARM                    OkFlags
 
      ** New Deal in File Format of main deal
     C                   PARM                    NwDlFilFmt1
 
      ** New Deal in File Format of associated deal
     C                   PARM                    NwDlFilFmt2
 
      ** Redisplay screen flag
     C                   PARM                    PReDsp
 
      ** Deal Currency Details
     C                   PARM                    PSpotRate
     C                   PARM                    PDecPlace
     C                   PARM                    PMulDivIn
     C                   PARM                    PScaleExp
     C                   PARM                    PIntCalcB
 
      ** Update error info with that returned from the validation module
 
     C                   IF        RetCodeOut <> *Blanks
 
     C                   EXSR      SRUpdatErrs
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAMNP - Principal Amount                                    *
      *                                                               *
      *****************************************************************
 
     C     SRAMNP        BEGSR
 
      ** Reset variables updated by each module
 
     C                   EXSR      SRResetErrs
 
      ** Call validation module
 
     C                   CALLB     'ABVDLAM01'
      *                             =========
      ** INPUTS
      ** ======
 
      ** Return code
     C                   PARM                    RetCodeOut
 
      ** New Deal in Screen Format
     C                   PARM                    NwDlScnFmt
 
      ** Deal Currency Decimal Place
     C                   PARM                    PDecPlace
 
      ** Standing Data
      ** =============
      ** SDDEAL: Decimal Separator
     C                   PARM                    BNDCSP
 
      ** OUTPUT
      ** ======
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Internal funding deals error indicator file
     C                   PARM                    OkFlags
 
      ** New Deal in File Format of main deal
     C                   PARM                    NwDlFilFmt1
 
      ** New Deal in File Format of associated deal
     C                   PARM                    NwDlFilFmt2
 
      ** Update error info with that returned from the validation module
 
     C                   IF        RetCodeOut <> *Blanks
 
     C                   EXSR      SRUpdatErrs
 
     C                   ENDIF
 
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBCXR - Base Currency Rate                                  *
      *                                                               *
      *****************************************************************
 
     C     SRBCXR        BEGSR
 
      ** Reset variables updated by each module
 
     C                   EXSR      SRResetErrs
 
      ** Call validation module
 
     C                   CALLB     'ABVBSRT01'
      *                             =========
      ** INPUTS
      ** ======
 
      ** Return code
     C                   PARM                    RetCodeOut
 
      ** New Deal in Screen Format
     C                   PARM                    NwDlScnFmt
 
      ** Standing Data
      ** =============
 
      ** SDBANK: Currency Code
     C                   PARM                    BJCYCD
      ** SDDEAL: Decimal Separator
     C                   PARM                    BNDCSP
 
      ** Deal Currency Details
     C                   PARM                    PSpotRate
     C                   PARM                    PDecPlace
     C                   PARM                    PMulDivIn
     C                   PARM                    PScaleExp
 
      ** OUTPUT
      ** ======
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Internal funding deals error indicator file
     C                   PARM                    Okflags
 
      ** New Deal in File Format of main deal
     C                   PARM                    NwDlFilFmt1
 
      ** New Deal in File Format of associated deal
     C                   PARM                    NwDlFilFmt2
 
      ** Update error info with that returned from the validation module
 
     C                   IF        RetCodeOut <> *Blanks
 
     C                   EXSR      SRUpdatErrs
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBRTT - Base Rate Code                                      *
      *                                                               *
      *****************************************************************
 
     C     SRBRTT        BEGSR
 
      ** Reset variables updated by each module
 
     C                   EXSR      SRResetErrs
 
     C     '?'           SCAN      DDBRTT                                 05
 
     C                   IF        StrFoundIn = True
 
     C                   EVAL      PReDsp = 'Y'
 
     C                   IF        PMode = '*FRONT'
 
     C                   EVAL      PMsgID = 'MMM0417'
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        PMsgID = *Blank
 
      ** Call validation module
 
     C                   CALLB     'ZAVBRATCDE'
      *                             ==========
 
     C                   PARM                    RetCodeOut
     C                   PARM                    PMsgId
     C                   PARM                    PWMsgID
     C                   PARM                    PRATE
     C                   PARM                    N1DBSR
     C                   PARM                    DDBRTT
     C                   PARM                    OKCCY
     C                   PARM                    PValDate
     C                   PARM                    OKVDAT
     C                   PARM                    BLBRCF
     C                   PARM                    DDCCY
 
      ** If no select
 
     C                   IF        StrFoundIn = True
 
     C     '?'           SCAN      DDBRTT                                 05
 
     C                   IF        StrFoundIn = True
 
     C                   EVAL      PMsgID = *Blank
     C                   EVAL      DDBRTT = *Blank
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Update error info with that returned from the validation module
 
     C                   IF        PMsgID <> *Blanks
 
      ** Error in Base Rate Code
 
     C                   EVAL      OKBRTT = 'N'
     C                   EVAL      WSFldNam = '#1BRTT'
     C                   EXSR      SRSetErrFld
     C                   EXSR      SRUpdatErrs
 
      ** No error
     C                   ELSE
 
     C                   EVAL      N1BSRC = DDBRTT
     C                   EVAL      N2BSRC = DDBRTT
     C                   EVAL      N2DBSR = N1DBSR
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRTSP - Rate/Spread                                         *
      *                                                               *
      *****************************************************************
 
     C     SRRTSP        BEGSR
 
      ** Reset variables updated by each module
 
     C                   EXSR      SRResetErrs
 
      ** Call validation module
 
     C                   CALLB     'ABVRTSP01'
      *                             =========
      ** INPUTS
      ** ======
 
      ** Return code
     C                   PARM                    RetCodeOut
 
      ** New Deal in Screen Format
     C                   PARM                    NwDlScnFmt
 
      ** Rate from ZAVBRATCDE
     C                   PARM                    PRate
 
      ** Standing Data
      ** =============
 
      ** SDDEAL: Decimal Separator
     C                   PARM                    BNDCSP
 
      ** OUTPUT
      ** ======
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Internal funding deals error indicator file
     C                   PARM                    OkFlags
 
      ** New Deal in File Format of main deal
     C                   PARM                    NwDlFilFmt1
 
      ** New Deal in File Format of associated deal
     C                   PARM                    NwDlFilFmt2
 
      ** Update error info with that returned from the validation module
 
     C                   IF        RetCodeOut <> *Blanks
 
     C                   EXSR      SRUpdatErrs
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRICBS - Interest Calculation Basis                          *
      *                                                               *
      *****************************************************************
 
     C     SRICBS        BEGSR
 
      ** Reset variables updated by each module
 
     C                   EXSR      SRResetErrs
 
      ** Call validation module
 
     C                   CALLB     'ZAVINTCALC'
      *                             ==========
 
     C                   PARM                    RetCodeOut
     C                   PARM                    PMsgID
     C                   PARM                    DDICBS
     C                   PARM                    PIntCalcB
 
      ** Update error info with that returned from the validation module
 
     C                   IF        PMsgID <> *Blanks
 
      ** Error in Interest Calculation Basis
 
     C                   EVAL      OKICBS = 'N'
     C                   EVAL      WSFldNam = '#1ICBS'
     C                   EXSR      SRSetErrFld
     C                   EXSR      SRUpdatErrs
 
     C                   ELSE
 
     C                   MOVE      DDICBS        N1ICMT
     C                   MOVE      DDICBS        N2ICMT
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRIPFR - Interest Payment Frequency                          *
      *                                                               *
      *****************************************************************
 
     C     SRIPFR        BEGSR
 
      ** Reset variables updated by each module
 
     C                   EXSR      SRResetErrs
 
      ** Call validation module
 
     C                   CALLB     'ABVPYFQ01'
      *                             =========
      ** INPUTS
      ** ======
 
      ** Return code
     C                   PARM                    RetCodeOut
 
      ** New Deal in Screen Format
     C                   PARM                    NwDlScnFmt
 
      ** OUTPUT
      ** ======
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Internal funding deals error indicator file
     C                   PARM                    OkFlags
 
      ** New Deal in File Format of main deal
     C                   PARM                    NwDlFilFmt1
 
      ** New Deal in File Format of associated deal
     C                   PARM                    NwDlFilFmt2
 
      ** Update error info with that returned from the validation module
 
     C                   IF        RetCodeOut <> *Blanks
 
     C                   EXSR      SRUpdatErrs
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNIDT - Next Interest Date                                  *
      *                                                               *
      *****************************************************************
 
     C     SRNIDT        BEGSR
 
      ** Reset variables updated by each module
 
     C                   EXSR      SRResetErrs
 
      ** Call validation module
 
     C                   CALLB     'ABVNXDT01'
      *                             =========
      ** INPUTS
      ** ======
 
      ** Return code
     C                   PARM                    RetCodeOut
 
      ** New Deal in Screen Format
     C                   PARM                    NwDlScnFmt
 
      ** Current Deal in Screen Format
     C                   PARM                    CrDlScnFmt
 
      ** Standing Data
      ** =============
 
      ** SDBANK: Date Format Indicator
     C                   PARM                    BJDFIN
      ** SDBANK: Run Day Number
     C                   PARM                    BJRDNB
      ** SDBANK: Local Currency Code
     C                   PARM                    BJLCCY
 
      ** Value Date in Midas Day no. format
     C                   PARM                    PValDate
 
      ** Maturity Date in Midas Day no. format
     C                   PARM                    PMatDate
 
      ** Original Entry Date in Midas Day format
     C                   PARM                    POREDDayNo
 
      ** Start/Last Interest Date in Midas Day format
     C                   PARM                    PSLIDDayNo
 
      ** Interest Accrual Control Date in Midas Day format
     C                   PARM                    PIACDDayNo
 
      ** OUTPUT
      ** ======
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Warning flds/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIdXAr
     C                   PARM                    WMsgDtXAr
 
      ** Internal funding deals error indicator file
     C                   PARM                    OkFlags
 
      ** New Deal in File Format of main deal
     C                   PARM                    NwDlFilFmt1
 
      ** New Deal in File Format of associated deal
     C                   PARM                    NwDlFilFmt2
 
      ** Update error info with that returned from the validation module
 
     C                   IF        RetCodeOut <> *Blanks
 
     C                   EXSR      SRUpdatErrs
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTOTI - Total Interest                                      *
      *                                                               *
      *****************************************************************
 
     C     SRTOTI        BEGSR
 
      ** Reset variables updated by each module
 
     C                   EXSR      SRResetErrs
 
      ** Call validation module
 
     C                   CALLB     'ABVTOIT01'
      *                             =========
      ** INPUTS
      ** ======
 
      ** Return code
     C                   PARM                    RetCodeOut
 
      ** New Deal in Screen Format
     C                   PARM                    NwDlScnFmt
 
      ** Value Date in Midas Day no. format
     C                   PARM                    PValDate
 
      ** Maturity Date in Midas Day no. format
     C                   PARM                    PMatDate
 
      ** Notice Days
     C                   PARM                    PNtceDay
 
      ** Decimal Place
     C                   PARM                    PDecPlace
 
      ** Standing Data
      ** =============
 
      ** SDDEAL: Decimal Separator
     C                   PARM                    BNDCSP
 
      ** OUTPUT
      ** ======
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Internal funding deals error indicator file
     C                   PARM                    OkFlags
 
      ** New Deal in File Format of main deal
     C                   PARM                    NwDlFilFmt1
 
      ** New Deal in File Format of associated deal
     C                   PARM                    NwDlFilFmt2
 
      ** Update error info with that returned from the validation module
 
     C                   IF        RetCodeOut <> *Blanks
 
     C                   EXSR      SRUpdatErrs
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINTF - Interest Frequency Day in Month                     *
      *                                                               *
      *****************************************************************
 
     C     SRINTF        BEGSR
 
      ** Reset variables updated by each module
 
     C                   EXSR      SRResetErrs
 
      ** Call validation module
 
     C                   CALLB     'ABVITFQ01'
      *                             =========
      ** INPUTS
      ** ======
 
      ** Return code
     C                   PARM                    RetCodeOut
 
      ** New Deal in Screen Format
     C                   PARM                    NwDlScnFmt
 
      ** Standing Data
      ** =============
 
      ** SDBANK: Date Format Indicator
     C                   PARM                    BJDFIN
      ** SDDEAL: Decimal Separator
     C                   PARM                    BNDCSP
 
      ** OUTPUT
      ** ======
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Internal funding deals error indicator file
     C                   PARM                    OkFlags
 
      ** New Deal in File Format of main deal
     C                   PARM                    NwDlFilFmt1
 
      ** New Deal in File Format of associated deal
     C                   PARM                    NwDlFilFmt2
 
      ** Update error info with that returned from the validation module
 
     C                   IF        RetCodeOut <> *Blanks
 
     C                   EXSR      SRUpdatErrs
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCPTI - Capitalise Interest Indicator                       *
      *                                                               *
      *****************************************************************
 
     C     SRCPTI        BEGSR
 
      ** Reset variables updated by each module
 
     C                   EXSR      SRResetErrs
 
      ** Call validation module
 
     C                   CALLB     'ABVCAIN01'
      *                             =========
      ** INPUTS
      ** ======
 
      ** Return code
     C                   PARM                    RetCodeOut
 
      ** New Deal in Screen Format
     C                   PARM                    NwDlScnFmt
 
      ** OUTPUT
      ** ======
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Internal funding deals error indicator file
     C                   PARM                    OkFlags
 
      ** New Deal in File Format of main deal
     C                   PARM                    NwDlFilFmt1
 
      ** New Deal in File Format of associated deal
     C                   PARM                    NwDlFilFmt2
 
      ** Update error info with that returned from the validation module
 
     C                   IF        RetCodeOut <> *Blanks
 
     C                   EXSR      SRUpdatErrs
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRLNKR - Linked Deal Number                                  *
      *                                                               *
      *****************************************************************
 
     C     SRLNKR        BEGSR
 
      ** Reset variables updated by each module
 
     C                   EXSR      SRResetErrs
 
     C                   IF        DDLNKR <> *Blank
 
     C                   EXSR      SRFmtDlNo
 
     C                   ENDIF
 
      ** Call validation module
 
     C                   CALLB     'MMVLINKREF'
      *                             ==========
 
     C                   PARM                    RetCodeOut
     C                   PARM                    PMsgID
     C                   PARM                    DDLNKR
     C                   PARM                    BNDCSP
 
      ** Update error info with that returned from the validation module
 
     C                   IF        PMsgID <> *Blanks
 
      ** Error in Linked Reference Number
 
     C                   EVAL      OKLNKR = 'N'
     C                   EVAL      WSFldNam = '#1LNKR'
     C                   EXSR      SRSetErrFld
     C                   EXSR      SRUpdatErrs
 
     C                   ELSE
 
     C                   MOVE      DDLNKR        N1LNKN
     C                   MOVE      DDLNKR        N2LNKN
 
      ** Redisplay Reference number justified/zero filled
 
     C                   IF        N1LNKN <> *Zeros
 
     C                   MOVE      N1LNKN        DDLNKR
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRORBR - Originating Branch Code                             *
      *                                                               *
      *****************************************************************
 
     C     SRORBR        BEGSR
 
      ** Reset variables updated by each module
 
     C                   EXSR      SRResetErrs
 
     C     '?'           SCAN      DDORBR                                 05
 
     C                   IF        StrFoundIn = True
 
     C                   EVAL      PReDsp = 'Y'
 
     C                   IF        PMode = '*FRONT'
 
     C                   EVAL      PMsgID = 'FXM0289'
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        PMsgID = *Blank
 
      ** Call validation module
 
     C                   CALLB     'ZAVORGBRCH'
      *                             ==========
 
     C                   PARM                    RetCodeOut
     C                   PARM                    PMsgID
     C                   PARM                    DDORBR
     C                   PARM                    OKBRC1
     C                   PARM                    DDBRC1
     C                   PARM                    AGMBIN
     C                   PARM                    BKOBRU
     C                   PARM                    BKOBUV
      ** Response mode (1A, from caller (A=Asynchronous, S=Synchronous))
     C                   PARM                    PResponse
 
      ** If no select
 
     C                   IF        StrFoundIn = True
 
     C     '?'           SCAN      DDORBR                                 05
 
     C                   IF        StrFoundIn = True
 
      ** If no error in booking branch 1, default the originating branch
      ** to booking branch 1
 
     C                   IF        OKBRC1 <> 'N'
 
     C                   EVAL      PMsgID = *Blank
     C                   EVAL      DDORBR = DDBRC1
 
     C                   ELSE
 
     C                   EVAL      PMsgID = 'FXM0289'
     C                   EVAL      DDORBR = *Blank
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Update error info with that returned from the validation module
 
     C                   IF        PMsgID <> *Blanks
 
      ** Error in Originating Branch
 
     C                   EVAL      OKORBR = 'N'
     C                   EVAL      WSFldNam = '#1ORBR'
     C                   EXSR      SRSetErrFld
     C                   EXSR      SRUpdatErrs
 
     C                   ELSE
 
      ** No error
 
     C                   EVAL      N1ORBR = DDORBR
     C                   EVAL      N2ORBR = DDORBR
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRFmtDlNo - Format entry deal no. before validation           *
      *                                                               *
      *****************************************************************
 
     C     SRFmtDlNo     BEGSR
 
     C                   Z-ADD     0             PIDP
     C                   Z-ADD     6             PIINT
     C                   MOVE      *Blanks       PAlpha
     C                   MOVE      DDLNKR        PAlpha
     C                   Z-ADD     *Zero         POAmount
     C                   MOVE      'N'           PIMTID
 
     C                   CALLB     'ZA0840'
     C                   PARM                    PRetCode
     C                   PARM                    PAlpha
     C                   PARM                    PIDP
     C                   PARM                    PIINT
     C                   PARM                    PIMTID
     C                   PARM                    POErrCde
     C                   PARM                    POAmount
     C                   PARM                    BNDCSP
 
     C                   IF        POErrCde = 0
 
     C                   MOVE      POAmount      DDLNKR
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************                       CAS004
      /EJECT                                                                                  CAS004
      *****************************************************************                       CAS004
      *                                                               *                       CAS004
      *  SRYldCurve- Validate Yield Curve                             *                       CAS004
      *                                                               *                       CAS004
      *****************************************************************                       CAS004
                                                                                              CAS004
     C     SRYldCurve    BEGSR                                                                CAS004
                                                                                              CAS004
      ** Reset variables updated by each module                                               CAS004
                                                                                              CAS004
     C                   EXSR      SRResetErrs                                                CAS004
                                                                                              CAS004
      ** Call validation module for Loan Yield Curve                                          CAS004
                                                                                              CAS004
     C                   CALLB     'ZAVYLDC01'                                                CAS004
                                                                                              CAS004
      ** INPUTS                                                                               CAS004
      ** ======                                                                               CAS004
                                                                                              CAS004
      ** Return code                                                                          CAS004
     C                   PARM                    RetCodeOut                                   CAS004
                                                                                              CAS004
      ** Deal Screen Fields                                                                   CAS004
     C                   PARM      'IL'          PDealType                                    CAS004
     C                   PARM                    DDSTP1                                       CAS004
     C                   PARM                    DDCLS1                                       CDL038
     C                   PARM                    DDOYC1                                       CAS004
                                                                                              CAS004
      ** Field name                                                                           CAS004
     C                   PARM      'DDOYLC'      PYCFN                                        CAS004
                                                                                              CAS005
      ** Forward/Revaluation Flag                                                             CAS005
                                                                                              CAS005
     C                   PARM      *BLANKS       PFwRv                                        CAS005
                                                                                              CAS005
      ** Forward Yield Curve, to be checked if validating Reval Yield Curve                   CAS005
                                                                                              CAS005
     C                   PARM      *BLANKS       PFwYC                                        CAS005
                                                                                              CAS008
      ** Forward Commitment/Revaluation Flag                                                  CAS008
                                                                                              CAS008
     C                   PARM      *BLANKS       PFCRv                                        CAS008
                                                                                              CAS004
      ** OUTPUTS                                                                              CAS004
      ** =======                                                                              CAS004
                                                                                              CAS004
      ** Yield Curve - OK                                                                     CAS004
     C                   PARM                    OKOYC1                                       CAS004
      ** Error Type                                                                           CAS004
     C                   PARM      *BLANKS       PERTP                                        CAS004
      ** Yield Curve                                                                          CAS004
     C                   PARM                    PYLDC                                        CAS004
                                                                                              CAS004
      ** Update error info with that returned from the validation module                      CAS004
                                                                                              CAS004
     C                   IF        RetCodeOut <> *Blanks                                      CAS004
     C                   IF        PERTP = '1'                                                CAS004
     C                   EVAL      PMsgID = 'ABM0600'                                         CAS004
     C                   ELSE                                                                 CAS004
     C                   EVAL      PMsgID = 'ABM0602'                                         CAS004
     C                   ENDIF                                                                CAS004
     C                   EVAL      WSFldNam = '#1OYC1'                                        CAS004
     C                   EXSR      SRSetErrFld                                                CAS004
     C                   EXSR      SRUpdatErrs                                                CAS004
     C                   ELSE                                                                 CAS004
     C                   EVAL      N1OYLC = DDOYC1                                            CAS004
     C                   ENDIF                                                                CAS004
                                                                                              CAS004
      ** Reset variables updated by each module                                               CAS004
                                                                                              CAS004
     C                   EXSR      SRResetErrs                                                CAS004
                                                                                              CAS004
      ** Call validation module for Deposit Yield Curve                                       CAS004
                                                                                              CAS004
     C                   CALLB     'ZAVYLDC01'                                                CAS004
                                                                                              CAS004
      ** INPUTS                                                                               CAS004
      ** ======                                                                               CAS004
                                                                                              CAS004
      ** Return code                                                                          CAS004
     C                   PARM                    RetCodeOut                                   CAS004
                                                                                              CAS004
      ** Deal Screen Fields                                                                   CAS004
     C                   PARM      'ID'          PDealType                                    CAS004
     C                   PARM                    DDSTP2                                       CAS004
     C                   PARM                    DDCLS2                                       CDL038
     C                   PARM                    DDOYC2                                       CAS004
                                                                                              CAS004
      ** Field name                                                                           CAS004
     C                   PARM      'DDOYLC'      PYCFN                                        CAS004
                                                                                              CAS005
      ** Forward/Revaluation Flag                                                             CAS005
                                                                                              CAS005
     C                   PARM      *BLANKS       PFwRv                                        CAS005
                                                                                              CAS005
      ** Forward Yield Curve, to be checked if validating Reval Yield Curve                   CAS005
                                                                                              CAS005
     C                   PARM      *BLANKS       PFwYC                                        CAS005
                                                                                              CAS008
      ** Forward Commitment/Revaluation Flag                                                  CAS008
                                                                                              CAS008
     C                   PARM      *BLANKS       PFCRv                                        CAS008
                                                                                              CAS004
      ** OUTPUTS                                                                              CAS004
      ** =======                                                                              CAS004
                                                                                              CAS004
      ** Yield Curve - OK                                                                     CAS004
     C                   PARM                    OKOYC2                                       CAS004
      ** Error Type                                                                           CAS004
     C                   PARM      *BLANKS       PERTP                                        CAS004
      ** Yield Curve                                                                          CAS004
     C                   PARM                    PYLDC                                        CAS004
                                                                                              CAS004
      ** Update error info with that returned from the validation module                      CAS004
                                                                                              CAS004
     C                   IF        RetCodeOut <> *Blanks                                      CAS004
     C                   IF        PERTP = '1'                                                CAS004
     C                   EVAL      PMsgID = 'ABM0601'                                         CAS004
     C                   ELSE                                                                 CAS004
     C                   EVAL      PMsgID = 'ABM0603'                                         CAS004
     C                   ENDIF                                                                CAS004
     C                   EVAL      WSFldNam = '#1OYC2'                                        CAS004
     C                   EXSR      SRSetErrFld                                                CAS004
     C                   EXSR      SRUpdatErrs                                                CAS004
     C                   ELSE                                                                 CAS004
     C                   EVAL      N2OYLC = DDOYC2                                            CAS004
     C                   ENDIF                                                                CAS004
                                                                                              CAS004
     C                   ENDSR                                                                CAS004
 
      *****************************************************************                       CDL019
      /EJECT                                                                                  CDL019
      *****************************************************************                       CDL019
      *                                                               *                       CDL019
      *  SRFixBsRte - Validate Fix Base Rate                          *                       CDL019
      *                                                               *                       CDL019
      *****************************************************************                       CDL019
                                                                                              CDL019
     C     SRFixBsRte    BEGSR                                                                CDL019
                                                                                              CDL019
      ** Reset variables updated by each module                                               CDL019
                                                                                              CDL019
     C                   EXSR      SRResetErrs                                                CDL019
                                                                                              CDL019
      ** Call validation module for Fix Base Rate                                             CDL019
                                                                                              CDL019
     C                   CALLB     'MMVFIXBSRT'                                               CDL019
     C                   PARM                    RetCodeOut                                   CDL019
     C                   PARM                    PMsgID                                       CDL019
     C                   PARM                    DDFBRT                                       CDL019
     C                   PARM      'ID'          @DTYPE            2                          CDL019
     C                   PARM      DDSTP2        @DSTYP            2                          CDL038
     C                   PARM      DDCLS2        @DCLAS            4                          CDL038
     C*******************PARM      *BLANKS       @DSTYP            2                   CDL019 CDL038
     C                   PARM                    DDBRTT                                       CDL019
     C                   PARM                    PMatDate                                     CDL019
                                                                                              CDL019
     C                   IF        RetCodeOut <> *Blanks                                      CDL019
     C                   EVAL      WSFldNam = '#1FBRT'                                        CDL019
     C                   MOVE      'N'           OKFBRT                                       CDL019
     C**********         EXSR      SRSetErrFld                                      CDL019 AR1083027
     C                   IF        RetCodeOut = 'Warning'                                  AR1083027
     C                   EVAL      WFldNmXAr(1)= WSFldNam                                  AR1083027
     C                   EVAL      WMsgIdXAr(1) = PMsgID                                   AR1083027
     C                   ELSE                                                              AR1083027
     C                   EVAL      FldNamXAr(1)= WSFldNam                                  AR1083027
     C                   EVAL      MsgIdXAr(1) = PMsgID                                    AR1083027
     C                   ENDIF                                                             AR1083027
                                                                                           AR1083027
     C                   EXSR      SRUpdatErrs                                                CDL019
     C                   ELSE                                                                 CDL019
     C                   EVAL      N1FBRT = DDFBRT                                            CDL019
     C                   EVAL      N2FBRT = DDFBRT                                            CDL019
     C                   ENDIF                                                                CDL019
                                                                                              CDL019
     C                   ENDSR                                                                CDL019
                                                                                              CDL019
      *****************************************************************                       CDL020
      /EJECT                                                                                  CDL020
      *****************************************************************                       CDL020
      *                                                               *                       CDL020
      *  SRActInRte - Validate Actual Interest Rate                   *                       CDL020
      *                                                               *                       CDL020
      *****************************************************************                       CDL020
                                                                                              CDL020
     C     SRActInRte    BEGSR                                                                CDL020
                                                                                              CDL020
      ** Reset variables updated by each module                                               CDL020
                                                                                              CDL020
     C                   EXSR      SRResetErrs                                                CDL020
                                                                                              CDL020
      ** Call validation module for Actual Interest rate                                      CDL020
                                                                                              CDL020
     C                   CALLB     'MMVACTINTR'                                               CDL020
     C                   PARM                    RetCodeOut                                   CDL020
     C                   PARM                    PMsgID                                       CDL020
     C                   PARM                    DDAIR                                        CDL020
     C                   PARM                    BGN0ST                                       CDL020
     C                   PARM                    BNDCSP                                       CDL020
     C                   PARM                    DDCCY                                        CDL020
     C                   PARM                    DDBRTT                                       CDL020
     C                   PARM                    PValDate                                     CDL020
     C                   PARM                    BJRDNB                                       CDL020
     C                   PARM                    N1SPRD                                       CDL020
     C                   PARM      N1INTR        PPINTR           11 7                        CDL038
     C*******************PARM                    PPINTR           11 7                 CDL020 CDL038
                                                                                              CDL020
     C                   IF        RetCodeOut <> *Blanks                                      CDL020
     C                   EVAL      WSFldNam = '#1AIR'                                         CDL020
     C                   MOVE      'N'           OKAIR                                        CDL020
     C                   EXSR      SRSetErrFld                                                CDL020
     C                   EXSR      SRUpdatErrs                                                CDL020
     C                   ELSE                                                                 CDL020
     C                   EVAL      N1INTR = PPINTR                                            CDL020
     C                   EVAL      N2INTR = PPINTR                                            CDL020
     C                   ENDIF                                                                CDL020
                                                                                              CDL020
     C                   ENDSR                                                                CDL020
                                                                                              CDL020
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSetErrFld - Setup error fields for reuse modules            *
      *                                                               *
      *****************************************************************
 
     C     SRSetErrFld   BEGSR
 
     C                   EVAL      FldNamXAr(1)= WSFldNam
     C                   EVAL      MsgIdXAr(1) = PMsgID
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRResetErrs - Routine to reset Error Information that is     *
      *                received from each validation module           *
      *                                                               *
      *****************************************************************
 
     C     SRResetErrs   BEGSR
 
     C                   EVAL      RetCodeOut = *Blanks
 
      ** Reset error and warning fields/message IDs/message
      ** data (arrays)
 
     C                   EVAL      FldNamXAr = *Blanks
     C                   EVAL      MsgIDXAr  = *Blanks
     C                   EVAL      MsgDtaXAr = *Blanks
 
     C                   EVAL      WFldNmXAr = *Blanks
     C                   EVAL      WMsgIDXAr = *Blanks
     C                   EVAL      WMsgDtXAr = *Blanks
 
     C                   EVAL      PMsgID = *Blanks
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdatErrs - Routine to update Error Information with that  *
      *                received back from each validation module      *
      *                                                               *
      *****************************************************************
 
     C     SRUpdatErrs   BEGSR
 
      ** Update error fields/message IDs/message data (arrays)
 
     C                   EVAL      Ix = 1
     C     *BLANK        LOOKUP    FldNameArr(Ix)                         10
 
     C                   IF        EqualInd = True
 
     C                   MOVEA     FldNamXar     FldNameArr(Ix)
     C                   MOVEA     MsgIDXAr      MsgIdArr(Ix)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(Ix)
 
     C                   ENDIF
 
      ** Set Error Index
 
     C                   EVAL      Ix = 1
     C     *BLANK        LOOKUP    FLDNAMEARR(Ix)                         10
 
     C                   IF        EqualInd = True
 
     C     Ix            SUB       1             IDx
 
     C                   ELSE
 
     C                   EVAL      Ix = ArrayMax
     C                   MOVE      *Blanks       FLDNAMEARR(Ix)
     C                   MOVE      *Blanks       MSGIDARR(Ix)
     C                   MOVE      *Blanks       MSGDTAARR(Ix)
     C                   EVAL      IDx = ArrayMax - 1
 
     C                   ENDIF
 
      ** Update warning fields/message IDs/message data (arrays)
 
     C                   EVAL      Ix = 1
     C     *Blank        LOOKUP    WFldNamArr(Ix)                         10
 
     C                   IF        EqualInd = True
 
     C                   MOVEA     WFldNmXAr     WFldNamArr(Ix)
     C                   MOVEA     WMsgIDXAr     WMsgIDArr(Ix)
     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(Ix)
 
     C                   ENDIF
 
      ** Set Warning Index
 
     C                   EVAL      Ix = 1
     C     *BLANK        LOOKUP    WFLDNAMARR(Ix)                         10
 
     C                   IF        EqualInd = True
 
     C     Ix            SUB       1             WIDx
 
     C                   ELSE
 
     C                   EVAL      Ix = ArrayMax
     C                   MOVE      *Blanks       WFLDNAMARR(Ix)
     C                   MOVE      *Blanks       WMSGIDARR(Ix)
     C                   MOVE      *Blanks       WMSGDTAARR(Ix)
     C                   EVAL      WIDx = ArrayMax - 1
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** INPUT
      ** =====
 
      ** Return Code
     C                   PARM                    RetCodeIn
 
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen Input function)
     C                   PARM                    PMode
 
      ** Response mode (1A, from caller (A=Asynchronous, S=Synchronous))
     C                   PARM                    PResponse
 
      ** New Deal in Screen Format
     C                   PARM                    NwDlScnFmt
 
      ** Current Deal in Screen Format
     C                   PARM                    CrDlScnFmt
 
      ** Current Deal in File Format of main deal
     C                   PARM                    CrDlFilFmt1
 
      ** Current Deal in File Format of associated deal
     C                   PARM                    CrDlFilFmt2
 
      ** Standing Data
      ** =============
 
      ** SDBANKPD **
      ** ======== **
      ** Date Format Indicator
     C                   PARM                    BJDFIN
      ** Currency Code
     C                   PARM                    BJCYCD
      ** Single Branch Code
     C                   PARM                    BJSBRC
      ** System Location Code
     C                   PARM                    BJSLCD
      ** Local Currency Code
     C                   PARM                    BJLCCY
      ** Customer Number
     C                   PARM                    BJCUST
      ** Run Day Number
     C                   PARM                    BJRDNB
      ** Back Value Period in Days
     C                   PARM                    BJBVPD
      ** SDGELRPD **
      ** ======== **
      ** Profit Centres Used
     C                   PARM                    BKPRCU
      ** Originating Branch Used
     C                   PARM                    BKOBRU
      ** Originating Branch/User Valid
     C                   PARM                    BKOBUV
      ** Profit Centres Amendable
     C                   PARM                    BKPRCA
      ** Profit Centre Deafults Used
     C                   PARM                    BKPCDU
      ** SDDEALPD **
      ** ======== **
      ** Decimal Separator
     C                   PARM                    BNDCSP
      ** SDMMODPD **
      ** ======== **
      ** Leo Letters of Credit
     C                   PARM                    BGNOST
      ** SDTRADPD **
      ** ======== **
      ** Base Rate Change Facility
     C                   PARM                    BLBRCF
 
      ** RUNDAT:
      ** ======
      ** Multibranching Indicator
     C                   PARM                    AGMBIN
 
      ** ZMUSER:
      ** ======
      ** Default Branch
     C                   PARM                    DBRN
      ** Department Code
     C                   PARM                    DPPT
                                                                                              CAS004
     C                   PARM                    CAS004                                       CAS004
                                                                                              CDL019
     C                   PARM                    CDL019                                       CDL019
                                                                                              CDL020
     C                   PARM                    CDL020                                       CDL020
 
      ** OUTPUT
      ** ======
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
     C                   PARM                    IDx
 
      ** Warning flds/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
 
      ** Array index (3P0) from/to caller
     C                   PARM                    WIDx
 
      ** Internal funding deals error indicator file
     C                   PARM                    OkFlags
 
      ** New Deal in File Format of main deal
     C                   PARM                    NwDlFilFmt1
 
      ** New Deal in File Format of associated deal
     C                   PARM                    NwDlFilFmt2
 
      ** Redisplay screen flag
     C                   PARM                    PReDsp
 
      ** Profit Centre Description 1
      ** Profit Centre Description 2
     C                   PARM                    PPCDesc1
     C                   PARM                    PPCDesc2
 
      ** Amended by validation module flag
 
     C                   PARM                    PValFlg
 
      ** Access MIDAS Modules details via access program                                      CDL020
      *  (database error handling done in access program)                                     CDL020
                                                                                              CDL020
     C                   CALLB     'AOMMODR0'                                                 CDL020
     C                   PARM      '*DBERR '     @RTCD             7                          CDL020
     C                   PARM      '*FIRST '     @OPTN             7                          CDL020
     C     SDMMOD        PARM      SDMMOD        DSFDY                                        CDL020
 
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
     C                   EVAL      DBASE = 901                                               BUG9717
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
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
 
      /COPY ZACPYSRC,DBFIELDS
 
      ** Hook to enable non-core files to be included
      /COPY WNCPYSRC,ABFUNDV056
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
 
      /COPY ZACPYSRC,PSSR_ILE
 
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
