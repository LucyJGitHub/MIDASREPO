     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXS *  RPGCVTOPT2                                                   *                       CSD053
/*EXI *  TEXT('Midas SD Watch list bulk data checking module (SD)')   *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000010 - Watch List Bulk Data Checking module for Standing *
      *             Data                                              *
      *                                                               *
      *  Function:  This module will check all data per function code *
      *             for Standing Data                                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. CER070             Date 19Aug14               *
      *  Prev Amend No. CSD095             Date 08Apr14               *
      *                 CLE134             Date 01Aug12               *
      *                 AR702741           Date 02Feb11               *
      *                 CER059             Date 19Jul10               *
      *                 CER045             Date 20Jul09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD053             Date 01Jun06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 BUG6198            Date 04Apr05               *
      *                 CSD025             Date 11Jan05               *
      *                 CDL031             Date 05Dec04               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CSD015  *CREATE    Date 14Oct02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
      *           (Recompile)                                         *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  AR702741 - Include location as parameter in ZFREQB to        *
      *             determine the next settlement date                *
      *             (Child: AR702742)                                 *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER045 - German Features - Reporting Bundesbank (Recompile)  *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  CSD053 - Correspondence Manager Multilanguage Upgrade        *
      *         - (Recompile)                                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG6198- Cannot save new Details for CUSD (Recompile)        *
      *  CSD025 - Customer De-Activation                              *
      *  CDL031 - Effective Date on Extended SSI (Recompile)          *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
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
 
     FSDCWHTL0  IF   E           K DISK    INFSR(*PSSR)
 
     FSDCUSTL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
 
     FSDACUSL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
 
     FSDALTNL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
 
     FCGCORRL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
 
     FGLAMADL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
 
     FSDEXSTL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
 
     FSDWLCCL0  UF   E           K DISK    INFSR(*PSSR)
 
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
 
      **---------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **---------------------------------------------------------------
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** DS for Bank Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** External DS for SAR Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** Fisrt DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Fisrt DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** External DS for Watch List Configuration Data File
     D SDCWCD        E DS                  EXTNAME(SDCWCDPD)
 
      ** Midas Watch List Transaction Details File
     D SDWLTD        E DS                  EXTNAME(SDWLTDPD)
 
      ** Midas Watch List Transaction Details File
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
 
      ** Standing Data Dataarea
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
 
      ** 24x7 Status Dataarea
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
 
      ** Compliance Engine Free Format String Parameter
     D PFreeFmtStr     S          30000A
 
      ** Array Size Definition
     D Elements        C                   CONST(25)
 
      ** XML Opening Tags for the Compliance Engine
     D XOT             S             25A   DIM(Elements) PERRCD(1) CTDATA
 
      ** XML Closing Tags for the Compliance Engine
     D XCT             S             25A   DIM(Elements) PERRCD(1) CTDATA
 
      ** SAR Flags
     D CSC011          S              1
     D CCF001          S              1
 
     D PRetCode        S              7
     D PRetCode1       S              1
     D POption         S              7
     D PFuncCode       S              8
     D PInput          S             35
     D PSard           S              6
     D PAmt            S             15
     D PDate           S              5
     D PDate1          S              7
     D PDate2          S              8
     D PDate8          S              8  0
     D PDFormat        S              1
     D PMsg            S            132A
     D PMsgId          S              7A
     D PMsgF           S             10A
     D PMsgQ           S             10A
     D PSrvContext     S               *
 
      ** Dummy Parameters
     D PDummy6         S              6
     D PDummy8         S              8
     D PDummy10        S             10
     D PDummy16        S             16
     D PDummy35        S             35
 
      ** ZFREQB Parameters
     D ZFREQ           S              1
     D ZDAYNO          S              5  0
     D ZCCY            S              3
     D ZLOC            S              3
     D ZMDAY           S              2  0
 
      ** Working Fields
     D ConvertedAmt    S             18P 3
     D ConvertedDate   S               D
     D WFuncType       S              8
     D WIdntifier      S             40
     D WBranch         S              3
     D WData           S            216
     D WDOB            S              9
     D WDOBtemp        S              4
     D WCNUM           S              6
     D*WACOD****       S              4                                                       CGL029
     D WACOD           S             10                                                       CGL029
     D WACSQ           S              2
     D WDBASE          S              3  0
     D WDBNUM          S              3  0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Open OFAC server
 
     C                   CALL      'SDOFACOP'
     C                   PARM      *BLANK        PRetCode
     C                   PARM                    PSrvContext
 
      ** Error calling SDOFACOP
 
     C                   IF        PRetCode <> *BLANK
 
     C                   SELECT
 
     C                   WHEN      PRetCode = '*INIT  '
     C                   EVAL      WDBASE = 53
     C                   EVAL      PMsgId = 'USR9686'
     C                   EXSR      SRSndErr
 
     C                   WHEN      PRetCode = '*OPEN  '
     C                   EVAL      WDBASE = 54
     C                   EVAL      PMsgID = 'USR9687'
     C                   EXSR      SRSndErr
 
     C                   WHEN      PRetCode = '*NREADY'
     C                   EVAL      WDBASE = 55
     C                   EVAL      PMsgID = 'USR9688'
     C                   EXSR      SRSndErr
 
     C                   ENDSL
 
      ** Perform database error
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = WDBASE
     C                   EVAL      DBKEY = PRetCode
     C                   EVAL      DBFile = 'SDOFACOP'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Open Customer Primary File
 
     C                   Open      SDCUSTL1
 
      ** Check if function code 'SDCUSD' is to be processed for Bulk
      ** Checking today.
 
     C                   EVAL      WFuncType = 'SDCUSD'
     C     WFuncType     Chain     SDWLCCL0
 
     C                   If        %FOUND(SDWLCCL0)
 
     C                   If        W1PFRQ <> *BLANKS AND W1NPCD <= BJRDNB
     C                   Exsr      SrCustDtls
     C                   Exsr      SrCheckFreq
     C                   EndIf
 
     C                   EndIf
 
      ** Check if function code 'CUSTALTA' is to be processed for Bulk
      ** Checking today.
 
     C                   EVAL      WFuncType = 'CUSTALTA'
     C     WFuncType     Chain     SDWLCCL0
 
     C                   If        %FOUND(SDWLCCL0)
 
     C                   If        W1PFRQ <> *BLANKS AND W1NPCD <= BJRDNB
     C                   Exsr      SrAltAddr
     C                   Exsr      SrCheckFreq
     C                   EndIf
 
     C                   EndIf
 
      ** Check if function code 'CORRECIP' is to be processed for Bulk
      ** Checking today.
 
     C                   EVAL      WFuncType = 'CORRECIP'
     C     WFuncType     Chain     SDWLCCL0
 
     C                   If        %FOUND(SDWLCCL0)
 
     C                   If        W1PFRQ <> *BLANKS AND W1NPCD <= BJRDNB
     C                   Exsr      SrCorresp
     C                   Exsr      SrCheckFreq
     C                   EndIf
 
     C                   EndIf
 
      ** Check if function code 'GLAMAN  ' is to be processed for Bulk
      ** Checking today.
 
     C                   EVAL      WFuncType = 'GLAMAD  '
     C     WFuncType     Chain     SDWLCCL0
 
     C                   If        %FOUND(SDWLCCL0)
 
     C                   If        W1PFRQ <> *BLANKS AND W1NPCD <= BJRDNB
     C                   Exsr      SrAcctUpd
     C                   Exsr      SrCheckFreq
     C                   EndIf
 
     C                   EndIf
 
      ** Check if function code 'EXTSETLL' is to be processed for Bulk
      ** Checking today.
 
     C                   EVAL      WFuncType = 'EXTSETTL'
     C     WFuncType     Chain     SDWLCCL0
 
     C                   If        %FOUND(SDWLCCL0)
 
     C                   If        W1PFRQ <> *BLANKS AND W1NPCD <= BJRDNB
     C                   Exsr      SrExtStlmnt
     C                   Exsr      SrCheckFreq
     C                   EndIf
 
     C                   EndIf
 
     C                   Close     SDCUSTL1
 
      ** Close connection with the server
 
     C                   CALL      'SDOFACCL'
     C                   PARM      *BLANK        PRetCode
     C                   PARM                    PSrvContext
 
     C                   Eval      *INLR = *On
 
     C                   Return
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrCustDtls - Parameter formatting for Customer Details        *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SrSetCusParms; SrSetAdCusPrms                          *
      *                                                               *
      *****************************************************************
 
     C     SrCustDtls    Begsr
 
     C                   Read      SDCUSTL1
 
     ** Process all live customer records
 
     C                   DoW       NOT %EOF(SDCUSTL1)
 
     C                   EVAL      WFuncType = 'SDCUSTPD'
     C                   MOVEL     BBCUST        WIdntifier
     C                   EVAL      WBranch = BBBRCD
 
     C     KCwFld        CHAIN     SDCWHTL0
 
     C                   If        %FOUND(SDCWHTL0) AND W3LWCD < W1LUDT
     C                             OR  NOT %FOUND(SDCWHTL0) AND W1LPCD < W1LUDT
     C                   Exsr      SrSetCusParms
     C                   Endif
 
     C                   Read      SDCUSTL1
 
     C                   ENDDO
 
     ** Process Additional Customer Details
 
     C                   Open      SDACUSL1
     C                   Read      SDACUSL1
 
     ** Read all records from SDACUSL1
 
     C                   DoW       NOT %EOF(SDACUSL1)
 
     ** Process if record is live
 
     C                   If        E5TYLC <> 'D'
 
     C     E5CUST        CHAIN     SDCUSTL1
 
     C                   If        NOT %FOUND(SDCUSTL1)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDCUSTPD'
     C                   EVAL      DBase = 010
     C                   EVAL      DBKey = E5CUST
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   EndIf
 
     C                   EVAL      WFuncType = 'SDACUSPD'
     C                   MOVEL     E5CUST        WIdntifier
     C                   EVAL      WBranch = BBBRCD
     C     KCwFld        CHAIN     SDCWHTL0
 
     C                   If        %FOUND(SDCWHTL0) AND W3LWCD < W1LUDT
     C                             OR  NOT %FOUND(SDCWHTL0) AND W1LPCD < W1LUDT
     C                   Exsr      SrSetAdCusPrms
     C                   Endif
 
     C                   EndIf
 
     C                   Read      SDACUSL1
 
     C                   EndDo
 
     C                   Close     SDACUSL1
 
     C                   Endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrSetCusParms - Compliance Check for Customer Details         *
      *                                                               *
      * Called by: SrCustDtls                                         *
      *                                                               *
      * Calls: SrEngine                                               *
      *                                                               *
      *****************************************************************
 
     C     SrSetCusParms Begsr
 
      ** Initialise the Transaction Details parameter.
 
     C                   CLEAR                   SDWLTD
 
      ** Setup First Parameter
 
     C                   EVAL      W4ITEM = 'SDCUSD'
 
     C                   MOVEL     BBCUST        W4IDEN
     C                   MOVEL     BBBRCD        W4BRCH
 
     C                   IF        CSC011 = 'Y'
     C                   EVAL      W4SYSM = S1MAIN
     C                   ELSE
     C                   EVAL      W4SYSM = LIBR
     C                   ENDIF
 
     C                   EVAL      W4FUNT = 'SDCUSTPD'
 
     C                   MOVE      BBCUST        W4CNUM
 
      ** Determine Counterparty Type
 
     C                   IF        CCF001 = 'Y'
     C                   IF        BBCRPC = 'Y'
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF
     C                   ELSE
     C                   IF        BBLICD <> *BLANKS
     C                             AND BBLICD <> W1IND1
     C                             AND BBLICD <> W1IND2
     C                             AND BBLICD <> W1IND3
     C                             AND BBLICD <> W1IND4
     C                             AND BBLICD <> W1IND5
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      W4CUST = BBCRNM + BBCRTN
 
      ** Build the free format string.
 
     C                   Eval      PFreeFmtStr = *BLANKS
 
     C                   If        BBCNA1 <> *BLANKS
     C                   CAT       XOT(1):0      PFreeFmtStr
     C                   CAT       BBCNA1:0      PFreeFmtStr
     C                   CAT       XCT(1):0      PFreeFmtStr
     C                   EndIf
 
     C                   If        BBCNA2 <> *BLANKS
     C                             OR BBCNA3 <> *BLANKS
     C                             OR BBCNA4 <> *BLANKS
     C                   CAT       XOT(2):0      PFreeFmtStr
     C                   CAT       BBCNA2:0      PFreeFmtStr
     C                   CAT       BBCNA3:1      PFreeFmtStr
     C                   CAT       BBCNA4:1      PFreeFmtStr
     C                   CAT       XCT(2):0      PFreeFmtStr
     C                   EndIf
 
     C                   If        BBCSID <> *BLANKS
     C                   CAT       XOT(3):0      PFreeFmtStr
     C                   CAT       BBCSID:0      PFreeFmtStr
     C                   CAT       XCT(3):0      PFreeFmtStr
     C                   EndIf
 
     C                   If        BBCNCZ <> *BLANKS
     C                   CAT       XOT(4):0      PFreeFmtStr
     C                   CAT       BBCNCZ:0      PFreeFmtStr
     C                   CAT       XCT(4):0      PFreeFmtStr
     C                   EndIf
 
     C                   If        BBCOLC <> *BLANKS
     C                   CAT       XOT(5):0      PFreeFmtStr
     C                   CAT       BBCOLC:0      PFreeFmtStr
     C                   CAT       XCT(5):0      PFreeFmtStr
     C                   EndIf
 
     C                   If        PFreeFmtStr <> *BLANKS
     C                   EVAL      WDBNUM = 17
     C                   EXSR      SREngine
     C                   EndIf
 
     C                   Endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrSetAdCusPrms - Compliance Check for Additional Customer     *
      *                  Details                                      *
      *                                                               *
      * Called by: SrCustDtls                                         *
      *                                                               *
      * Calls: SrEngine                                               *
      *                                                               *
      *****************************************************************
 
     C     SrSetAdCusPrmsBegsr
 
      ** Initialise the Transaction Details parameter.
 
     C                   CLEAR                   SDWLTD
 
      ** Setup First Parameter
 
     C                   EVAL      W4ITEM = 'SDCUSA'
 
     C                   MOVEL     E5CUST        W4IDEN
     C                   MOVEL     BBBRCD        W4BRCH
 
     C                   IF        CSC011 = 'Y'
     C                   EVAL      W4SYSM = S1MAIN
     C                   ELSE
     C                   EVAL      W4SYSM = LIBR
     C                   ENDIF
 
     C                   EVAL      W4FUNT = 'SDACUSPD'
 
     C                   MOVE      BBCUST        W4CNUM
 
      ** Determine Counterparty Type
 
     C                   IF        CCF001 = 'Y'
     C                   IF        BBCRPC = 'Y'
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF
     C                   ELSE
     C                   IF        BBLICD <> *BLANKS
     C                             AND BBLICD <> W1IND1
     C                             AND BBLICD <> W1IND2
     C                             AND BBLICD <> W1IND3
     C                             AND BBLICD <> W1IND4
     C                             AND BBLICD <> W1IND5
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      W4CUST = BBCRNM + BBCRTN
 
     C                   EVAL      W4AMT1 = *ZERO
     C                   EVAL      W4AMT2 = *ZERO
 
      ** Build the free format string.
 
     C                   Eval      PFreeFmtStr = *BLANKS
 
     C                   If        E5CNA1 <> *BLANKS
     C                   CAT       XOT(1):0      PFreeFmtStr
     C                   CAT       E5CNA1:0      PFreeFmtStr
     C                   CAT       XCT(1):0      PFreeFmtStr
     C                   EndIf
 
     C                   If        E5CNA2 <> *BLANKS
     C                             OR E5CNA3 <> *BLANKS
     C                             OR E5CNA4 <> *BLANKS
     C                   CAT       XOT(2):0      PFreeFmtStr
     C                   CAT       E5CNA2:0      PFreeFmtStr
     C                   CAT       E5CNA3:1      PFreeFmtStr
     C                   CAT       E5CNA4:1      PFreeFmtStr
     C                   CAT       XCT(2):0      PFreeFmtStr
     C                   EndIf
 
     C                   If        E5IDNO <> *BLANKS
     C                   CAT       XOT(6):0      PFreeFmtStr
     C                   CAT       E5IDNO:0      PFreeFmtStr
     C                   CAT       XCT(6):0      PFreeFmtStr
     C                   EndIf
 
     C                   If        E5BRTH <> *ZERO
 
     C                   CALLB     'ZA0140M'
     C                   PARM                    PRetCode1
     C                   PARM                    E5BRTH
     C                   PARM                    PDFormat
     C                   PARM                    PDummy6
     C                   PARM                    PDate1
     C                   PARM                    PDate8
     C                   PARM                    PDummy8
 
     C                   Move      PDate8        PDate2
     C                   Eval      WDOB = %SUBST(PDate1:1:5)
     C                   Eval      WDOBtemp = %SUBST(PDate2:1:4)
     C                   CAT       WDOBtemp:0    WDOB
 
     C                   CAT       XOT(7):0      PFreeFmtStr
     C                   CAT       WDOB:0        PFreeFmtStr
     C                   CAT       XCT(7):0      PFreeFmtStr
     C                   EndIf
 
     C                   If        PFreeFmtStr <> *BLANKS
     C                   EVAL      WDBNUM = 23
     C                   EXSR      SREngine
     C                   EndIf
 
     C                   Endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrAltAddr - Parameter formatting for Alternate Address        *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SrSetAltAddr                                           *
      *                                                               *
      *****************************************************************
 
     C     SrAltAddr     Begsr
 
     C                   Open      SDALTNL3
     C                   Read      SDALTNL3
 
     ** Read all records from SDALTNL3
 
     C                   DoW       NOT %EOF(SDALTNL3)
 
     C     BCCUST        CHAIN     SDCUSTL1
 
     C                   If        NOT %FOUND(SDCUSTL1)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDCUSTPD'
     C                   EVAL      DBase = 011
     C                   EVAL      DBKey = BCCUST
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   EndIf
 
     C                   EVAL      WFuncType = 'SDALTNPD'
     C                   EVAL      WIdntifier = %TRIM(BCCUST) + BCADCD
     C                   EVAL      WBranch = BBBRCD
     C     KCwFld        CHAIN     SDCWHTL0
 
     C                   If        %FOUND(SDCWHTL0) AND W3LWCD < W1LUDT
     C                             OR  NOT %FOUND(SDCWHTL0) AND W1LPCD < W1LUDT
     C                   Exsr      SrSetAltAddr
     C                   Endif
 
     C                   Read      SDALTNL3
 
     C                   EndDo
 
     C                   Close     SDALTNL3
 
 
     C                   Endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrSetAltAddr - Compliance Check for Alternate Address         *
      *                Details File                                   *
      *                                                               *
      * Called by: SrAltAddr                                          *
      *                                                               *
      * Calls: SrEngine                                               *
      *                                                               *
      *****************************************************************
 
     C     SrSetAltAddr  Begsr
 
      ** Initialise the Transaction Details parameter.
 
     C                   CLEAR                   SDWLTD
 
      ** Setup First Parameter
 
     C                   EVAL      W4ITEM = 'SDCALT'
 
     C                   EVAL      W4IDEN = %TRIM(BCCUST) + BCADCD
     C                   MOVEL     BBBRCD        W4BRCH
 
     C                   IF        CSC011 = 'Y'
     C                   EVAL      W4SYSM = S1MAIN
     C                   ELSE
     C                   EVAL      W4SYSM = LIBR
     C                   ENDIF
 
     C                   EVAL      W4FUNT = 'SDALTNPD'
 
     C                   MOVE      BBCUST        W4CNUM
 
      ** Determine Counterparty Type
 
     C                   IF        CCF001 = 'Y'
     C                   IF        BBCRPC = 'Y'
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF
     C                   ELSE
     C                   IF        BBLICD <> *BLANKS
     C                             AND BBLICD <> W1IND1
     C                             AND BBLICD <> W1IND2
     C                             AND BBLICD <> W1IND3
     C                             AND BBLICD <> W1IND4
     C                             AND BBLICD <> W1IND5
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      W4CUST = BBCRNM + BBCRTN
 
     C                   EVAL      W4AMT1 = *ZERO
     C                   EVAL      W4AMT2 = *ZERO
 
      ** Build the free format string.
 
     C                   Eval      PFreeFmtStr = *BLANKS
 
     C                   If        BCCNA1 <> *BLANKS
     C                   CAT       XOT(8):0      PFreeFmtStr
     C                   CAT       BCCNA1:0      PFreeFmtStr
     C                   CAT       XCT(8):0      PFreeFmtStr
     C                   EndIf
 
     C                   If        BCCNA2 <> *BLANKS
     C                             OR BCCNA3 <> *BLANKS
     C                             OR BCCNA4 <> *BLANKS
     C                   CAT       XOT(2):0      PFreeFmtStr
     C                   CAT       BCCNA2:0      PFreeFmtStr
     C                   CAT       BCCNA3:1      PFreeFmtStr
     C                   CAT       BCCNA4:1      PFreeFmtStr
     C                   CAT       XCT(2):0      PFreeFmtStr
     C                   EndIf
 
     C                   If        BCCNCD <> *BLANKS
     C                   CAT       XOT(5):0      PFreeFmtStr
     C                   CAT       BCCNCD:0      PFreeFmtStr
     C                   CAT       XCT(5):0      PFreeFmtStr
     C                   EndIf
 
     C                   If        PFreeFmtStr <> *BLANKS
     C                   EVAL      WDBNUM = 29
     C                   EXSR      SREngine
     C                   EndIf
 
     C                   Endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrCorresp - Parameter formatting for Correspondence Reciepient*
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SrSetCorresp                                           *
      *                                                               *
      *****************************************************************
 
     C     SrCorresp     Begsr
 
     ** Access SDGELRPD for alternate branch
 
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST'      POption
     C*****SDGELR        PARM                    DSFDY                                        CGL029
     C     SDGELR        PARM                    DSSDY                                        CGL029
 
     C                   If        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDGELRPD'
     C                   EVAL      DBase = 013
     C                   EVAL      DBKey = POption
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   EndIf
 
     C                   Open      CGCORRL1
     C                   Read      CGCORRL1
 
     ** Read all live records from CGCORRL1
 
     C                   DoW       NOT %EOF(CGCORRL1)
 
     C                   IF        CDCUST <> *Blanks
 
     C     CDCUST        CHAIN     SDCUSTL1
 
     C                   If        NOT %FOUND(SDCUSTL1)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDCUSTPD'
     C                   EVAL      DBase = 016
     C                   EVAL      DBKey = CDCUST
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   EndIf
 
     C                   Endif
 
     C                   EVAL      WFuncType = 'CGCORRPD'
     C                   MOVEL     CDCORR        WIdntifier
     C                   EVAL      WBranch = BKMABR
 
     C     KCwFld        CHAIN     SDCWHTL0
 
     C                   If        %FOUND(SDCWHTL0) AND W3LWCD < W1LUDT
     C                             OR  NOT %FOUND(SDCWHTL0) AND W1LPCD < W1LUDT
     C                   Exsr      SrSetCorresp
     C                   Endif
 
     C                   Read      CGCORRL1
 
     C                   EndDo
 
     C                   Close     CGCORRL1
 
     C                   Endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrSetCorresp - Compliance Check for Correspondence Manager    *
      *                                                               *
      * Called by: SrCorresp                                          *
      *                                                               *
      * Calls: SrEngine                                               *
      *                                                               *
      *****************************************************************
 
     C     SrSetCorresp  Begsr
 
      ** Initialise the Transaction Details parameter.
 
     C                   CLEAR                   SDWLTD
 
      ** Setup First Parameter
 
     C                   EVAL      W4ITEM = 'CGRECP'
 
     C                   MOVEL     CDCORR        W4IDEN
     C                   MOVEL     WBranch       W4BRCH
 
     C                   IF        CSC011 = 'Y'
     C                   EVAL      W4SYSM = S1MAIN
     C                   ELSE
     C                   EVAL      W4SYSM = LIBR
     C                   ENDIF
 
     C                   EVAL      W4FUNT = 'CGCORRPD'
 
     C                   If        CDCUST <> *Blanks
 
     C                   MOVE      CDCUST        W4CNUM
 
      ** Determine Counterparty Type
 
     C                   IF        CCF001 = 'Y'
     C                   IF        BBCRPC = 'Y'
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF
     C                   ELSE
     C                   IF        BBLICD <> *BLANKS
     C                             AND BBLICD <> W1IND1
     C                             AND BBLICD <> W1IND2
     C                             AND BBLICD <> W1IND3
     C                             AND BBLICD <> W1IND4
     C                             AND BBLICD <> W1IND5
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      W4CUST = BBCRNM + BBCRTN
 
     C                   EndIf
 
     C                   EVAL      W4AMT1 = *ZERO
     C                   EVAL      W4AMT2 = *ZERO
 
      ** Build the free format string.
 
     C                   Eval      PFreeFmtStr = *BLANKS
 
     C                   If        CDCORN <> *BLANKS
     C                   CAT       XOT(9):0      PFreeFmtStr
     C                   CAT       CDCORN:0      PFreeFmtStr
     C                   CAT       XCT(9):0      PFreeFmtStr
     C                   EndIf
 
     C                   If        CDADD1 <> *BLANKS
     C                             OR CDADD2 <> *BLANKS
     C                             OR CDADD3 <> *BLANKS
     C                             OR CDADD4 <> *BLANKS
     C                             OR CDADD5 <> *BLANKS
     C                             OR CDADD6 <> *BLANKS
     C                             OR CDADD7 <> *BLANKS
     C                   CAT       XOT(2):0      PFreeFmtStr
     C                   CAT       CDADD1:0      PFreeFmtStr
     C                   CAT       CDADD2:1      PFreeFmtStr
     C                   CAT       CDADD3:1      PFreeFmtStr
     C                   CAT       CDADD4:1      PFreeFmtStr
     C                   CAT       CDADD5:1      PFreeFmtStr
     C                   CAT       CDADD6:1      PFreeFmtStr
     C                   CAT       CDADD7:1      PFreeFmtStr
     C                   CAT       XCT(2):0      PFreeFmtStr
     C                   EndIf
 
     C                   If        CDZIP <> *BLANKS
     C                   CAT       XOT(10):0     PFreeFmtStr
     C                   CAT       CDZIP:0       PFreeFmtStr
     C                   CAT       XCT(10):0     PFreeFmtStr
     C                   EndIf
 
     C                   If        CDFATT <> *BLANKS
     C                   MOVE      *BLANKS       PInput
     C                   MOVE      CDFATT        PInput
     C                   Exsr      SrFmt
     C                   CAT       XOT(11):0     PFreeFmtStr
     C                   CAT       WData:0       PFreeFmtStr
     C                   CAT       XCT(11):0     PFreeFmtStr
     C                   EndIf
 
     C                   If        PFreeFmtStr <> *BLANKS
     C                   EVAL      WDBNUM = 35
     C                   EXSR      SREngine
     C                   EndIf
 
     C                   Endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrAcctUpd - Parameter formatting for Accounts Detail          *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SrSetAcctUpd                                           *
      *                                                               *
      *****************************************************************
 
     C     SrAcctUpd     Begsr
 
     C                   Open      GLAMADL0
     C                   Read      GLAMADL0
 
     ** Read all records from GLAMADPD
 
     C                   DoW       NOT %EOF(GLAMADL0)
 
     ** Check if record is live
 
     C                   If        RECI <> '*'
 
     C                   Move      CNUM          PDummy6
     C     PDummy6       CHAIN     SDCUSTL1
 
     C                   If        NOT %FOUND(SDCUSTL1)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDCUSTPD'
     C                   EVAL      DBase = 014
     C                   EVAL      DBKey = PDummy6
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   EndIf
 
     C                   EVAL      WFuncType = 'ACCNTAB'
     C                   Move      CNUM          WCNUM
     C                   Move      ACOD          WACOD
     C                   Move      ACSQ          WACSQ
     C                   Eval      WIdntifier = BRCA + WCNUM + CCY + WACOD
     C                                   + WACSQ
     C                   EVAL      WBranch = BRCA
     C     KCwFld        CHAIN     SDCWHTL0
 
     C                   If        %FOUND(SDCWHTL0) AND W3LWCD < W1LUDT
     C                             OR  NOT %FOUND(SDCWHTL0) AND W1LPCD < W1LUDT
     C                   Exsr      SrSetAcctUpd
     C                   Endif
 
     C                   EndIf
 
     C                   Read      GLAMADL0
 
     C                   EndDo
 
     C                   Close     GLAMADL0
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrSetAcctUpd - Compliance Check for Accounts Update           *
      *                                                               *
      * Called by: SrAcctUpd                                          *
      *                                                               *
      * Calls: SrEngine                                               *
      *                                                               *
      *****************************************************************
 
     C     SrSetAcctUpd  Begsr
 
      ** Initialise the Transaction Details parameter.
 
     C                   CLEAR                   SDWLTD
 
      ** Setup First Parameter
 
     C                   EVAL      W4ITEM = 'GLACCT'
 
     C                   Move      CNUM          WCNUM
     C                   Move      ACOD          WACOD
     C                   Move      ACSQ          WACSQ
     C                   Eval      W4IDEN = BRCA + WCNUM + CCY + WACOD
     C                                   + WACSQ
 
     C                   MOVEL     BRCA          W4BRCH
 
     C                   IF        CSC011 = 'Y'
     C                   EVAL      W4SYSM = S1MAIN
     C                   ELSE
     C                   EVAL      W4SYSM = LIBR
     C                   ENDIF
 
     C                   EVAL      W4FUNT = 'ACCNTAB'
 
     C                   MOVE      CNUM          W4CNUM
 
      ** Determine Counterparty Type
 
     C                   IF        CCF001 = 'Y'
     C                   IF        BBCRPC = 'Y'
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF
     C                   ELSE
     C                   IF        BBLICD <> *BLANKS
     C                             AND BBLICD <> W1IND1
     C                             AND BBLICD <> W1IND2
     C                             AND BBLICD <> W1IND3
     C                             AND BBLICD <> W1IND4
     C                             AND BBLICD <> W1IND5
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      W4CUST = BBCRNM + BBCRTN
 
     C                   MOVE      DACO          PDate
     C                   CALLB     'ZACVTDATE'
     C                   PARM                    PRetCode
     C                   PARM                    PDate
     C                   PARM                    ConvertedDate
     C                   PARM                    PDummy10
     C                   EVAL      W4VDAT = ConvertedDate
 
     C                   MOVE      DACC          PDate
     C                   CALLB     'ZACVTDATE'
     C                   PARM                    PRetCode
     C                   PARM                    PDate
     C                   PARM                    ConvertedDate
     C                   PARM                    PDummy10
     C                   EVAL      W4MDAT = ConvertedDate
 
     C                   EVAL      W4DEN1 = CCY
 
     C                   CALL      'ZACVTAMT'
     C                   PARM                    PRetCode
     C                   PARM                    CCY
     C                   PARM                    LDBL
     C                   PARM                    ConvertedAmt
     C                   PARM                    PDummy16
 
     C                   EVAL      W4AMT1 = ConvertedAmt
     C                   EVAL      W4AMT2 = *ZERO
 
      ** Build the free format string.
 
     C                   Eval      PFreeFmtStr = *BLANKS
 
     C                   If        ANAM <> *BLANKS
     C                   CAT       XOT(12):0     PFreeFmtStr
     C                   CAT       ANAM:0        PFreeFmtStr
     C                   CAT       XCT(12):0     PFreeFmtStr
     C                   EndIf
 
     C                   If        PFreeFmtStr <> *BLANKS
     C                   EVAL      WDBNUM = 41
     C                   EXSR      SREngine
     C                   EndIf
 
     C                   Endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrExtStlmnt - Parameter formatting for Extended Settlements   *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SrSetExtStlmnt                                         *
      *                                                               *
      *****************************************************************
 
     C     SrExtStlmnt   Begsr
 
     C                   Open      SDEXSTL1
     C                   Read      SDEXSTL1
 
     ** Read all records from extended settlements file
 
     C                   DoW       NOT %EOF(SDEXSTL1)
 
     ** Check if record is live
 
     C                   If        BYTYLC <> 'D'
 
     C     BYCUST        CHAIN     SDCUSTL1
 
     C                   If        NOT %FOUND(SDCUSTL1)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDCUSTPD'
     C                   EVAL      DBase = 015
     C                   EVAL      DBKey = BYCUST
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   EndIf
 
     C                   EVAL      WFuncType = 'SDEXSTPD'
     C                   EVAL      WIdntifier = BYCYCD + BYCUST + BYTRTY
     C                   EVAL      WBranch = BBBRCD
     C     KCwFld        CHAIN     SDCWHTL0
 
     C                   If        %FOUND(SDCWHTL0) AND W3LWCD < W1LUDT
     C                             OR  NOT %FOUND(SDCWHTL0) AND W1LPCD < W1LUDT
     C                   Exsr      SrSetExtStlmnt
     C                   Endif
 
     C                   EndIf
 
     C                   Read      SDEXSTL1
 
     C                   EndDo
 
     C                   Close     SDEXSTL1
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrSetExtStlmnt - Compliance Check for Extended Settlements    *
      *                                                               *
      * Called by: SrExtStlmnt                                        *
      *                                                               *
      * Calls: SrEngine                                               *
      *                                                               *
      *****************************************************************
 
     C     SrSetExtStlmntBegsr
 
      ** Initialise the Transaction Details parameter.
 
     C                   CLEAR                   SDWLTD
 
      ** Setup First Parameter
 
     C                   EVAL      W4ITEM = 'SDXSET'
     C                   EVAL      W4IDEN = BYCYCD + BYCUST + BYTRTY
     C                   MOVEL     BBBRCD        W4BRCH
 
     C                   IF        CSC011 = 'Y'
     C                   EVAL      W4SYSM = S1MAIN
     C                   ELSE
     C                   EVAL      W4SYSM = LIBR
     C                   ENDIF
 
     C                   EVAL      W4FUNT = 'SDEXSTPD'
 
     C                   MOVE      BYCUST        W4CNUM
 
      ** Determine Counterparty Type
 
     C                   IF        CCF001 = 'Y'
     C                   IF        BBCRPC = 'Y'
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF
     C                   ELSE
     C                   IF        BBLICD <> *BLANKS
     C                             AND BBLICD <> W1IND1
     C                             AND BBLICD <> W1IND2
     C                             AND BBLICD <> W1IND3
     C                             AND BBLICD <> W1IND4
     C                             AND BBLICD <> W1IND5
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      W4CUST = BBCRNM + BBCRTN
 
     C                   EVAL      W4DEN1 = BYCYCD
     C                   EVAL      W4AMT1 = *ZERO
     C                   EVAL      W4AMT2 = *ZERO
 
      ** Build the free format string.
 
     C                   Eval      PFreeFmtStr = *BLANKS
 
     C                   If        BYRONO <> *BLANKS
     C                   MOVE      *BLANKS       PInput
     C                   MOVEL     BYRONO        PInput
     C                   Exsr      SrFmt
     C                   CAT       XOT(13):0     PFreeFmtStr
     C                   CAT       WData:0       PFreeFmtStr
     C                   CAT       XCT(13):0     PFreeFmtStr
     C                   EndIf
 
     C                   If        BYROCS <> *BLANKS
     C                   MOVE      *BLANKS       PInput
     C                   MOVEL     BYROCS        PInput
     C                   Exsr      SrFmt
     C                   CAT       XOT(14):0     PFreeFmtStr
     C                   CAT       WData:0       PFreeFmtStr
     C                   CAT       XCT(14):0     PFreeFmtStr
     C                   EndIf
 
     C                   If        BYRIBN <> *BLANKS
     C                   MOVE      *BLANKS       PInput
     C                   MOVEL     BYRIBN        PInput
     C                   Exsr      SrFmt
     C                   CAT       XOT(15):0     PFreeFmtStr
     C                   CAT       WData:0       PFreeFmtStr
     C                   CAT       BYRIBL:1      PFreeFmtStr
     C                   CAT       XCT(15):0     PFreeFmtStr
     C                   EndIf
 
     C                   If        BYROBN <> *BLANKS
     C                   MOVE      *BLANKS       PInput
     C                   MOVEL     BYROBN        PInput
     C                   Exsr      SrFmt
     C                   CAT       XOT(16):0     PFreeFmtStr
     C                   CAT       WData:0       PFreeFmtStr
     C                   CAT       XCT(16):0     PFreeFmtStr
     C                   EndIf
 
     C                   If        BYPONO <> *BLANKS
     C                   MOVE      *BLANKS       PInput
     C                   MOVEL     BYPONO        PInput
     C                   Exsr      SrFmt
     C                   CAT       XOT(17):0     PFreeFmtStr
     C                   CAT       WData:0       PFreeFmtStr
     C                   CAT       XCT(17):0     PFreeFmtStr
     C                   EndIf
 
     C                   If        BYPOCS <> *BLANKS
     C                   MOVE      *BLANKS       PInput
     C                   MOVEL     BYPOCS        PInput
     C                   Exsr      SrFmt
     C                   CAT       XOT(18):0     PFreeFmtStr
     C                   CAT       WData:0       PFreeFmtStr
     C                   CAT       XCT(18):0     PFreeFmtStr
     C                   EndIf
 
     C                   If        BYRCNB <> *BLANKS
     C                   MOVE      *BLANKS       PInput
     C                   MOVEL     BYRCNB        PInput
     C                   Exsr      SrFmt
     C                   CAT       XOT(19):0     PFreeFmtStr
     C                   CAT       WData:0       PFreeFmtStr
     C                   CAT       XCT(19):0     PFreeFmtStr
     C                   EndIf
 
     C                   If        BYRCNO <> *BLANKS
     C                   MOVE      *BLANKS       PInput
     C                   MOVEL     BYRCNO        PInput
     C                   Exsr      SrFmt
     C                   CAT       XOT(20):0     PFreeFmtStr
     C                   CAT       WData:0       PFreeFmtStr
     C                   CAT       BYRCAL:1      PFreeFmtStr
     C                   CAT       XCT(20):0     PFreeFmtStr
     C                   EndIf
 
     C                   If        BYPIBN <> *BLANKS
     C                   MOVE      *BLANKS       PInput
     C                   MOVEL     BYPIBN        PInput
     C                   Exsr      SrFmt
     C                   CAT       XOT(21):0     PFreeFmtStr
     C                   CAT       WData:0       PFreeFmtStr
     C                   CAT       BYPIBA:1      PFreeFmtStr
     C                   CAT       XCT(21):0     PFreeFmtStr
     C                   EndIf
 
     C                   If        BYPOBN <> *BLANKS
     C                   MOVE      *BLANKS       PInput
     C                   MOVEL     BYPOBN        PInput
     C                   Exsr      SrFmt
     C                   CAT       XOT(22):0     PFreeFmtStr
     C                   CAT       WData:0       PFreeFmtStr
     C                   CAT       XCT(22):0     PFreeFmtStr
     C                   EndIf
 
     C                   If        BYACBN <> *BLANKS
     C                   MOVE      *BLANKS       PInput
     C                   MOVEL     BYACBN        PInput
     C                   Exsr      SrFmt
     C                   CAT       XOT(23):0     PFreeFmtStr
     C                   CAT       WData:0       PFreeFmtStr
     C                   CAT       BYACBL:1      PFreeFmtStr
     C                   CAT       XCT(23):0     PFreeFmtStr
     C                   EndIf
 
     C                   If        BYBYNB <> *BLANKS
     C                   MOVE      *BLANKS       PInput
     C                   MOVEL     BYBYNB        PInput
     C                   Exsr      SrFmt
     C                   CAT       XOT(24):0     PFreeFmtStr
     C                   CAT       WData:0       PFreeFmtStr
     C                   CAT       BYBACL:1      PFreeFmtStr
     C                   CAT       XCT(24):0     PFreeFmtStr
     C                   EndIf
 
     C                   If        BYDPY1 <> *BLANKS OR BYDPY2 <> *BLANKS
     C                             OR BYDPY3 <> *BLANKS OR BYDPY4 <> *BLANKS
     C                   CAT       XOT(25):0     PFreeFmtStr
     C                   CAT       BYDPY1:0      PFreeFmtStr
     C                   CAT       BYDPY2:1      PFreeFmtStr
     C                   CAT       BYDPY3:1      PFreeFmtStr
     C                   CAT       BYDPY4:1      PFreeFmtStr
     C                   CAT       XCT(25):0     PFreeFmtStr
     C                   EndIf
 
     C                   If        PFreeFmtStr <> *BLANKS
     C                   EVAL      WDBNUM = 47
     C                   EXSR      SREngine
     C                   EndIf
 
     C                   Endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrEngine - Calls Watch List Engine                            *
      *                                                               *
      * Called by: SrSetCusParms, SrCustDtls, SrSetAltAddr,           *
      *            SrSetCorresp, SrSetAcctUpd, SrSetExtStlmnt         *
      *                                                               *
      * Calls: SDWLENGN                                               *
      *                                                               *
      *****************************************************************
     C     SrEngine      Begsr
 
     C                   Call      'SDWLENGN'
     C                   PARM      *BLANK        PRetCode
     C                   PARM                    PSrvContext
     C                   PARM                    SDWLTD
     C                   PARM                    PFreeFmtStr
 
      ** Error calling SDWLENGN
 
     C                   IF        PRetCode <> *BLANK
     C                   SELECT
 
     C                   WHEN      PRetCode = '*ERROR '
     C                   EVAL      WDBASE = WDBNUM
 
     C                   WHEN      PRetCode = '*FOFEXE'
     C                   EVAL      WDBASE = WDBNUM + 1
     C                   EVAL      PMsgID = 'USR9680'
     C                   EXSR      SRSndErr
 
     C                   WHEN      PRetCode = '*SRVNAM'
     C                   EVAL      WDBASE = WDBNUM + 2
     C                   EVAL      PMsgID = 'USR9681'
     C                   EXSR      SRSndErr
 
     C                   WHEN      PRetCode = '*DBNAME'
     C                   EVAL      WDBASE = WDBNUM + 3
     C                   EVAL      PMsgID = 'USR9682'
     C                   EXSR      SRSndErr
 
     C                   WHEN      PRetCode = '*USRNAM'
     C                   EVAL      WDBASE = WDBNUM + 4
     C                   EVAL      PMsgID = 'USR9683'
     C                   EXSR      SRSndErr
 
     C                   WHEN      PRetCode = '*PASSWD'
     C                   EVAL      WDBASE = WDBNUM + 5
     C                   EVAL      PMsgID = 'USR9684'
     C                   EXSR      SRSndErr
 
     C                   OTHER
     C                   EVAL      PMsgID = 'USR9685'
     C                   EXSR      SRSndErr
     C                   ENDSL
 
      ** Perform database error either of the following return code is true
 
     C                   IF        PRetCode = '*ERROR ' OR
     C                             PRetCode = '*FOFEXE' OR
     C                             PRetCode = '*SRVNAM' OR
     C                             PRetCode = '*DBNAME' OR
     C                             PRetCode = '*USRNAM' OR
     C                             PRetCode = '*PASSWD'
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = WDBASE
     C                   EVAL      DBKEY = SDWLTD
     C                   EVAL      DBFile = 'SDWLENGN'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrFmt - SDCWLFMT Calling subroutine                           *
      *                                                               *
      * Called by: SrSetExtStlmnt                                     *
      *                                                               *
      * Calls: SDCWLFMT                                               *
      *                                                               *
      *****************************************************************
     C     SrFmt         Begsr
 
     C                   CALL      'SDCWLFMT'
     C                   PARM                    PRetCode
     C                   PARM                    PInput
     C                   PARM                    PDummy35
     C                   PARM                    PDummy35
     C                   PARM                    PDummy35
     C                   PARM                    PDummy35
     C                   PARM                    PDummy35
     C                   PARM                    BYCYCD
     C                   PARM                    WData
     C                   PARM                    PDummy6
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrCheckFreq - Determine next periodic check date for function *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: ZFREQB                                                 *
      *                                                               *
      *****************************************************************
 
     C     SrCheckFreq   Begsr
 
      ** Set Last Periodic Check Date = Run date
 
     C                   Eval      W1LPCD = BJRDNB
 
      ** Determine next periodic check date for function
 
     C                   Eval      ZFREQ = W1PFRQ
     C                   Eval      ZDAYNO = W1NPCD
     C                   Eval      ZMDAY = W1PDYN
     C                   Eval      ZCCY = BJLCCY
 
     C                   CallB     'ZFREQB'
     C                   PARM                    ReturnCode
     C                   PARM                    ZFREQ
     C                   PARM                    ZDAYNO
     C                   PARM                    ZCCY
     C                   PARM      *BLANKS       ZLOC                                       AR702741
     C                   PARM                    ZMDAY
     C                   PARM                    BJDFIN
     C     SDGELR        PARM                    SDGELR
 
      ** Update the Next Periodic Check Date field on file SDWLCCL0
 
     C                   Eval      W1NPCD = ZDAYNO
     C                   Update    SDWLCCD0
 
     C                   Endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSndErr - Send error message to *SYSOPR                      *
      *                                                               *
      *****************************************************************
 
     C     SRSndErr      BEGSR
 
     C                   CALLB     'ZAMSGTOMSQ'
     C                   PARM                    RetCodeOut
     C                   PARM      'SD000010'    PMsg
     C                   PARM                    PMsgId
     C                   PARM      'GBSDUSRMSG'  PMsgF
     C                   PARM      'MOPERQ    '  PMsgQ
 
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
 
      ** Access Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDBank        PARM      SDBank        DSFDY
 
      ** Database Error
 
     C                   IF        PRetCode <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBase = 001
     C                   EVAL      DBKey = POption
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Check if 24x7 Enhancement (CSC011) is installed
 
     C                   EVAL      CSC011 = 'N'
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *Blank        PRetCode
     C                   PARM      '*VERIFY'     POption
     C                   PARM      'CSC011'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY
 
      ** Database error
 
     C                   IF        PRetCode <> *BLANKS
     C                             AND PRetCode <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = 'CSC011'
     C                   EVAL      DBFile = 'SCSARDPD'
     C                   EVAL      DBase = 002
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRetCode = *BLANKS
     C                   EVAL      CSC011 = 'Y'
     C                   IN        SC24X7
     C                   ENDIF
 
     C                   IN        SDSTAT
 
      ** Check if Concord Interface Development (CCF001) is installed
 
     C                   EVAL      CCF001 = 'N'
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *Blank        PRetCode
     C                   PARM      '*VERIFY'     POption
     C                   PARM      'CCF001'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY
 
      ** Database error
 
     C                   IF        PRetCode <> *BLANKS
     C                             AND PRetCode <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = 'CCF001'
     C                   EVAL      DBFile = 'SCSARDPD'
     C                   EVAL      DBase = 009
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRetCode = *BLANKS
     C                   EVAL      CCF001 = 'Y'
     C                   ENDIF
 
      ** Retrieve compliance watch configuration data file
 
     C                   CALL      'AOCWCDR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST'      POption
     C     SDCWCD        PARM      SDCWCD        DSSDY
 
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = POption
     C                   EVAL      DBFILE = 'SDCWCDPD'
     C                   EVAL      DBASE = 003
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Key List for SDCWHTL0
 
     C     KCwFld        KLIST
     C                   KFLD                    WFuncType
     C                   KFLD                    WIdntifier
     C                   KFLD                    WBranch
 
      *****************************************************************
      ** Program, module and procedure names for database error
      ** processing.
      ** ==============================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      *********************************************************************
 
     C     *PSSR         BEGSR
 
      ** Close connection with the server
 
     C                   CALL      'SDOFACCL'
     C                   PARM      *BLANK        PRetCode
     C                   PARM                    PSrvContext
 
     C                   DUMP
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
 
     C                   CALLB     'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2002
** CTDATA XOT - XML Opening Tags for the Compliance Engine.
<Customer Name>
<Addr Lines>
<SWIFT Id>
<Ctry of Citizenship>
<Ctry of Domicile>
<Identity Number>
<Date of Birth>
<Cust Alt Name>
<Correspondent's Name>
<Zip Code>
<For attention of>
<Account Name>
<Receipt Our Nostro>
<Receipt Ord Customer>
<Receipt Int Bank>
<Receipt Ord Bank>
<Payment Our Nostro>
<Payment Ord Customer>
<Payment Receiver>
<Payment R Corespondent>
<Payment Int Bank>
<Payment Ord Bank>
<Payment A/C with Bank>
<Payment Beneficiary>
<Payment Details of Pay>
** CTDATA XCT - XML Closing Tags for the Compliance Engine.
</Customer Name>
</Addr Lines>
</SWIFT Id>
</Ctry of Citizenship>
</Ctry of Domicile>
</Identity Number>
</Date of Birth>
</Cust Alt Name>
</Correspondent's Name>
</Zip Code>
</For attention of>
</Account Name>
</Receipt Our Nostro>
</Receipt Ord Customer>
</Receipt Int Bank>
</Receipt Ord Bank>
</Payment Our Nostro>
</Payment Ord Customer>
</Payment Receiver>
</Payment R Corespondent>
</Payment Int Bank>
</Payment Ord Bank>
</Payment A/C with Bank>
</Payment Beneficiary>
</Payment Details of Pay>
