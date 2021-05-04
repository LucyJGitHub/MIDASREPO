     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR FRA database update')                         *
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Dealing Module                               *
      *                                                               *
      *  IRFRAUPD - Forward Rate Agreements Database Update           *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CSD102             Date 08Jan19               *
      *                 MD046248           Date 27Oct17               *
      *                 CDL099             Date 06Oct17               *
      *                 CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 01Sep14               *
      *                 MD025244           Date 09May14               *
      *                 CRE073             Date 06Dec10               *
      *                 220437             Date 23Aug03               *
      *                 CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 CER048             Date 19May08               *
      *                 CER043             Date 19May08               *
      *                 CSD083             Date 27May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG18701           Date 12May08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 239742             Date 22Sep06               *
      *                 BUG12628           Date 11Nov06               *
      *                 CDL049             Date 07Jul06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG8550            Date 07Oct05               *
      *                 BUG8094            Date 10Aug05               *
      *                 BUG7166            Date 12May05               *
      *                 CDL038             Date 10May05               *
      *                 CSW037A            Date 02May05               *
      *                 CDL028             Date 07Feb05               *
      *                 BUG6877            Date 29Apr05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CGL014             Date 20Oct03               *
      *                 225811             Date 18Mar04               *
      *                 TDA011             Date 31Mar04               *
      *                 225362             Date 30Mar04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 222373             Date 31Oct03               *
      *                 CAP084             Date 30Jul03               *
      *                 CAS006             Date 21Jan03               *
      *                 CAS005             Date 16Dec02               *
      *                 CIR011             Date 15Apr02               *
      *                 CSD015             Date 14Oct02               *
      *                 CAS004             Date 26Jun02               *
      *                 217684             Date 12May03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP056             Date 13Mar02               *
      *                 CIR008             Date 13Mar02               *
      *                 CSC011             Date 18Sep01               *
      *                 194487             Date 16Aug01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 200400             Date 20Nov01               *
      * Midas DBA 3.05 -----------------------------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 179510             Date 06Nov00               *
      *                 CDL008             Date 02May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CIR005             Date 21Jan00               *
      *                 CDE001             Date 12Apr00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSW097             Date 10Feb00               *
      *                 CAP013             Date 07Sep99               *
      *                 168345             Date 13Oct99               *
      *                 161937             Date 07Jun99               *
      * Midas DBA 3.01 -----------------------------------------------*
      *                 168981             Date 20May99               *
      * Midas DBA 3.00 -----------------Base--------------------------*
      *                 CPL002             Date 08Mar99               *
      *                 CAP006             Date 23Feb99               *
      *                 151240             Date 21Dec98               *
      *                 CAP003  *CREATE    Date 01Apr98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  MD025244 - Added parameter in calling ZADLTRLRUD.            *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  220437 - Currencies for rate fixing in FRA transaction was   *
      *           changed but the system did not generate an MT340    *
      *           for the amendement. Need to consider all amendable  *
      *           fields in generating a new confirmation.            *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CSD083 - Watch List Compliance Upgrade                       *
      *  BUG18701 - Implement Auto Authorisation                      *
      *  239742  - No confirmation message for IRS deal amendment.    *
      *  BUG12628 - Fed Fund indicator was reset to blanks upon       *
      *             clicking the Confirm Complete button              *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG8550 - Reposition capture of ZMUSER data area             *
      *  BUG8094 - Update online position when deal is reveresd.      *
      *  BUG7166- Valid file does not match DEALSDG (Recompile)       *
      *  CDL038 - Extended Deal Sub Type                              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  BUG6877 - Ensure confirmation is generated for amendment.    *
      *            Fix is patterned after 227212.                     *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  225811 - User on FRAs/IRSs sent through APISERVER is ignored *
      *           BG1770 is applying this Release 5.0 fix to MidasPlus*
      *  TDA011 - Rate Fix Ccy writes to the wrong field (Recompile)  *
      *  225362 - Recompiled due to changes related to file IRVFRAPD. *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  222373 - Correct parameters on program calls                 *
      *  CAP084 - API wrapper project                                 *
      *  CAS006 - Hedge Accounting Phase B                            *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CIR011 - FRA/IRS Rate Fix Days Adjustment                    *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *  CAS004 - Hedge Accounting Phase A (Recompile)                *
      *  217684 - Authorisation User Malfunction                      *
      *  CAP056 - Automatic Authorisation of Interface Deals.         *
      *  CIR008 - FRA/IRS Deals Authorisation.                        *
      *  CSC011 - 24x7 Midas Availability                             *
      *  194487 - Check other amended fields relevant for generation  *
      *           of an amended confirmation.  And default workfield  *
      *           @@CNRQ to 'N' to prevent a blank CNRQ in DTRIXDD.   *
      *  200400 - Reverse fix 179510 and replace it with a new fix.   *
      *  179510 - For Settlement method 04 , fields  URACC  &  UPACC -*
      *            Our  Receiving/ Payment Account    respectively    *
      *           not  correctly  updated .  Introduced  new  coding  *
      *           to validate  the Settlement Method  when updating   *
      *           the  DEALSDG  file .                                *
      *  CDL008 - Continuous Linked Settlement (Recompiled)           *
      *  CIR005 - FRA/IRS Business Day Conventions                    *
      *  CDE001 - Data Export - CCRM Limits                           *
      *  CSW097 - SWIFT97 Changes to MT34n and MT36n Msg Gen          *
      *  CAP013 - Allow access by Midas transaction ID if not insert  *
      *  168345 - Prevent two users from accessing same transaction   *
      *           in repair screen at the same cycle, and converting  *
      *           it into two different Midas Deal No.s  .            *
      *           Second user should not be allowed to repair the tran-
      *           saction and convert it into a  another Midas Deal . *
      *  161937 - Effective interest rate wrongly zeroized on amend.  *
      *  168981 - SWIFT 1997 Changes for FRAIRS MT34* and MT36*       *
      *           (recompiled)                                        *
      *  CPL002 - Plato Interface                                     *
      *  CAP006 - Check for deal being updated by another workstation *
      *  151240 - Initialise bit settings on insert                   *
      *  CAP003 - Conversion of IR inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
     FDEALALL   UF A E           K DISK
     F                                     COMMIT
     F                                     INCLUDE(DEALSDGF)
     F                                     INCLUDE(DEALSDFF)
     FSDTIX     UF A E           K DISK
     F                                     COMMIT
     F                                     PREFIX(DX)
                                                                                              CSD015
      ** Compliance Watch Hit List                                                            CSD015
     FSDCWHTL1  IF   E           K DISK    INFSR(*PSSR)                                       CSD015
                                                                                              CSD015
     F/COPY WNCPYSRC,IRFRADF001

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

      **------------------------------------------------------------------------CAP006 -------------
      ** The following /COPY line includes the definitions for error and        CAP006
      ** warning message arrays.                                                CAP006
     D/COPY ZACPYSRC,ERR_ARRAYS                                                 CAP006
      **------------------------------------------------------------------------CAP006--------------
                                                                                CAP006
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      *****************************************************************

      **  EXTERNALLY DESCRIBED DATA STRUCTURE FOR VALID FRA
     D IRVFRA        E DS                  EXTNAME(IRVFRAPD)
     D**@FRDET1***************11    715                                                       CAP084
     D**@FRDET1****************2    715                                                CAP084 222727
     D  @FRDET1               11    715                                                       222727
     D  @FRREC               716    784
     D  @FRPY1               785    990
     D  @FRPY2               991   1133
     D  @FRPY3              1134   1343
     D**@FRDET2*************1344   2044                                         CAP013
     D**@FRDET2**           1344   2200                                  CAP013 CIR005
     D  @FRDET2             1344   2062                                         CIR005
     D**@FRRCCY*************2063   2092                                  CIR005 222727
     D  @FRRCCY             2097   2126                                         222727

      **  DEALS FILE - FORWARD RATE AGREEMENTS
     D DEALS         E DS                  EXTNAME(DEALSDG)
     D**@DLDET1***************11    715                                                       CAP084
     D**@DLDET1****************2    715                                                CAP084 222727
     D  @DLDET1               11    715                                                       222727
     D  @DLREC               716    784
     D  @DLPY1               785    990
     D  @DLPY2               991   1133
     D  @DLPY3              1134   1343
     D**@DLDET2*************1344   2044                                         CAP013
     D**@DLDET2**           1344   2200                                  CAP013 CIR005
     D  @DLDET2             1344   2062                                         CIR005
     D  @DLRCUR             2097   2126                                         CIR005

     D ChkDealFmt    E DS                  EXTNAME(DEALSDG)                     CAP006
      ** Rename fields for Transaction No of Last Update Processing             CAP006
     D                                     PREFIX(CH)                           CAP006
                                                                                CAP006
     D IREFRA        E DS                  EXTNAME(IREFRAPD)                    CAP006
      * Error indicators                                                        CAP006
                                                                                CAP006
      **  Time data structure for DTRIX.
     D                 DS
     D  @XTIME                 1      6  0
     D  DXTIM                  1      4  0

      * DATA STRUCTURES FOR USE WITH ACCESS PROGRAMS

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      * DATA STRUCTURE FOR BANK DETAILS

     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
      ** External DS for TRADE Details

     D SDRETL        E DS                  EXTNAME(SDRETLPD)                                  200400
      ** External data structure for RETAIL details                                           200400
     D  QQACCD1      E                     EXTFLD(QQACCD)                                     CGL029
                                                                                              200400
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** External DS for BRANCH Details

     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)
      ** External DS for BASE RATE Details

     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External DS for CURRENCY Details

     D SDBOOK        E DS                  EXTNAME(SDBOOKPD)
      ** External DS for BOOK Details

     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CIR005
     D  WLCD         E                     EXTFLD(LCD)                          CIR005
      ** External DS for SAR Details                                            CIR005
      *                                                                         CIR005
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE

     D DSSDY         E DS                  EXTNAME(DSSDY)
      * SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE

     D SDFAIS        E DS                  EXTNAME(SDFAISPD)                                  CIR008
      ** External data structure for FRA/IRS I.C.D. details                                   CIR008
                                                                                              CIR008
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
      ** 24X7 status data area                                                                CSC011
      *                                                                                       CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
      ** SD data area                                                                         CSC011
      *                                                                                       CSC011
                                                                                              CAP084
     D ZMUSER        E DS                  EXTNAME(ZMUSER) DTAARA(ZMUSER)                     CAP084
      ** Java user information                                                                CAP084
                                                                                              CAP084
     D APHEAD        E DS                  EXTNAME(APHEADPD)                                  CSC011
      ** Midas API Message Header Format Definition                                           CSC011
                                                                                CAP006
      ** Dummy message ID and message file fields for use on the calls to       CAP006
      ** ZAMSGTOOPR                                                             CAP006
     D DummyMsgID      S                   LIKE(#MsgID)                         CAP006
     D DummyMsgF       S             10A                                        CAP006
                                                                                              CIR008
      ** Switchable Feature Parameter                                                         CIR008
     D CIR008          S              1A                                                      CIR008
     D CAP056          S              1A                                                      CAP056
     D CAS006          S              1A                                                      CAS006
     D CAP051          S              1A                                                    BUG18701
                                                                                              CAP056
      ** Parameter fields when calling ZAFUTSTATP                                             CIR008
     D P_ACTN          S              1A                                                      CIR008
     D P_CSTS          S              1A                                                      CIR008
     D P_DSTS          S              1A                                                      CIR008
                                                                                              CIR008
     D WkActn          S              1A                                                      CIR008
     D PModeOfOp       S              6A                                                      CAP056
                                                                                              CSC011
      ** Fields defined for Enhancement CSC011                                                CSC011
     D CSC011          S              1A                                                      CSC011
     D TRANSDTL        S           5800A                                                      CSC011
     D Timestamp       S             26A                                                      CSC011
     D PDealNum        S             18A                                                      CSC011
     D PADealNo        S             18A                                                      CSC011
     D PRtCd           S              7A                                                      CSC011
     D POptn           S              7A                                                      CSC011
     D PSard           S              6A                                                      CSC011
     D WDealNo         S              6A                                                      CSC011
                                                                                              CSC011
     D CIR011          S              1A                                                      CIR011
                                                                                              CIR011
      ** External DS for Compliance Watch Transaction Details                                 CSD015
     D SDWLCC        E DS                  EXTNAME(SDWLCCPD)                                  CSD015
                                                                                              CSD015
      ** Watch List Transaction Details Data Structure                                        CSD015
     D SDWLTD        E DS                  EXTNAME(SDWLTDPD)                                  CSD015
                                                                                              CSD015
      ** External DS for Customer Details                                                     CSD015
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CSD015
     D  QQDFAC1      E                     EXTFLD(QQDFAC)                                     CGL029
                                                                                              CSD015
      ** External DS for Watch List Configuration Data File                                   CSD015
     D SDCWCD        E DS                  EXTNAME(SDCWCDPD)                                  CSD015
                                                                                              CSD015
      ** Compliance Engine Free Format String Parameter                                       CSD015
     D PFreeFmtStr     S          30000A                                                      CSD015
                                                                                              CSD015
      ** Array Size Definition                                                                CSD015
     D Elements        C                   CONST(13)                                          CSD015
                                                                                              CSD015
      ** XML Opening Tags for the Compliance Engine                                           CSD015
     D XOT             S             25A   DIM(Elements) PERRCD(1) CTDATA                     CSD015
                                                                                              CSD015
      ** XML Closing Tags for the Compliance Engine                                           CSD015
     D XCT             S             25A   DIM(Elements) PERRCD(1) CTDATA                     CSD015
                                                                                              CSD015
      ** Watch List Fields Array                                                              CSD015
     D WLF             S             18A   DIM(Elements)                                      CSD015
                                                                                              CSD015
     D CSD015          S              1                                                       CSD015
     D CCF001          S              1                                                       CSD015
     D WFuncType       S              8                                                       CSD015
     D WIdntifier      S             40                                                       CSD015
     D WBranch         S              3                                                       CSD015
     D WLChgFlg        S              1    INZ('N')                                           CSD015
     D WLOKFlg         S              1    INZ('N')                                           CSD015
     D WXMLPacket      S            310                                                       CSD015
     D WData           S            216                                                       CSD015
     D Ctr             S              2P 0                                                    CSD015
     D PRetCode        S              7                                                       CSD015
     D POption         S              7                                                       CSD015
     D PFunc           S              8                                                       CSD015
     D PCUST           S             10                                                       CSD015
     D PSTKEY          S              7                                                       CSD015
     D PDate           S              5                                                       CSD015
     D PAmt            S             15                                                       CSD015
     D PFmtCCY         S              3                                                       CSD015
     D ConvertedDate   S               D                                                      CSD015
     D ConvertedAmt    S             18P 3                                                    CSD015
     D PDummy6         S              6                                                       CSD015
     D PDummy10        S             10                                                       CSD015
     D PDummy16        S             16                                                       CSD015
     D PDummy35        S             35                                                       CSD015
     D Wrk_16          S             16                                                       CGL029
                                                                                              CSD015
      ** Define external data-structures for before and after image                          BUG8094
      **   of deal for on-line updates.                                                      BUG8094
                                                                                             BUG8094
     D Z#BSTS        E DS                  EXTNAME(Z#BST)                                    BUG8094
     D Z#ASTS        E DS                  EXTNAME(Z#AST)                                    BUG8094
                                                                                             BUG8094
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* MAIN - MAIN BODY                                              *
     C*                                                               *
     C*****************************************************************

      ** If the user is connected via a browser, the job user name is the data               BUG8550
      ** source conection name - the actual user name is stored in ZMUSER                    BUG8550
     C                   IN        ZMUSER                                                    BUG8550
                                                                                             BUG8550
      * EXIT IF NOT INSERTION, AMENDMENT OR REVERSAL
      * only when CIR008 is switched off                                                      CIR008

     C                   IF        CIR008 = 'N'                                               CIR008
     C     FRCHTP        IFNE      'I'
     C     FRCHTP        ANDNE     'A'
     C     FRCHTP        ANDNE     'R'
     C                   RETURN
     C                   END
     C                   ENDIF                                                                CIR008
                                                                                              CIR008
      * Include checking of Authorisation when CIR008 is switched on                          CIR008
                                                                                              CIR008
     C                   IF        CIR008 = 'Y'                                               CIR008
     C                   IF        FRCHTP <> 'I'  AND  FRCHTP <> 'A' AND                      CIR008
     C                             FRCHTP <> 'R'  AND  FRCHTP <> 'X'                          CIR008
     C                   RETURN                                                               CIR008
     C                   ENDIF                                                                CIR008
     C                   ENDIF                                                                CIR008
                                                                                              CIR008
      ** Save the action code                                                                 CIR008
                                                                                              CIR008
     C                   EVAL      WkActn = FRCHTP                                            CIR008

      ** Ensure transaction has not been updated by another workstation         CAP006
      ** - if so, bypass updating and return to calling program.                CAP006
     C                   EXSR      CHKOTHUPD                                    CAP006
                                                                                CAP006
     C     @@RTCD        IFNE      *BLANKS                                      CAP006
     C                   GOTO      EXIT                                         CAP006
     C                   END                                                    CAP006
                                                                                CAP006
      ** Set ICD Authorisation of FRA/IRS to 'N'                                              CAP056
      ** if Auto Authorisation on FRA Valid File is 'Y'                                       CAP056
                                                                                              CAP056
     C                   IF        CAP056 = 'Y' AND PModeofOp = '*FRONT' AND                  CAP056
     C                             FRAUTH = 'Y'                                               CAP056
     C                             OR CAP051 = 'Y' AND FRAUTH = 'Y'                         BUG18701
     C                   EVAL      BQFIAU = 'N'                                               CAP056
     C                   EVAL      BQFIRA = 'N'                                               CAP056
     C                   ELSE                                                                 CAP056
     C                   EVAL      BQFIAU = WkFIAU                                            CAP056
     C                   EVAL      BQFIRA = WkFIRA                                            CAP056
     C                   ENDIF                                                                CAP056
     C                                                                                        CAP056
      * INSERT, AMEND, OR REVERSE THE DEAL
      ** or Authorise                                                                         CIR008

     C     FRCHTP        CASEQ     'I'           FRINS
     C     FRCHTP        CASEQ     'A'           FRAMD
     C     FRCHTP        CASEQ     'R'           FRDEL
     C     FRCHTP        CASEQ     'X'           SrAuthorise                                  CIR008
     C                   END

      * SET PAY/RECEIVE INDICATORS TO BE WRITTEN TO DTRIX
      ** when CIR008 is switched off or when reversing a deal                                 CIR008
      ** Or Authorisation/Re-authorisation flags are both 'N'                                 CIR008
                                                                                              CIR008
     C                   IF        FRCHTP <> *BLANKS                                          CIR008

     C                   EXSR      PYRCIN

      * WRITE A DTRIX RECORD
     C/COPY WNCPYSRC,IRFRADC001

     C                   EXSR      WRTDTX
     C/COPY WNCPYSRC,IRFRADC002

      * UPDATE THE DTRIX HEADER RECORD
     C/COPY WNCPYSRC,IRFRADC003

     C                   EXSR      UPDDTH
     C/COPY WNCPYSRC,IRFRADC004
                                                                                              CIR008
     C                   ENDIF                                                                CIR008

      ** UPDATE THE DEALS FILE TRAILER
      ** ON INSERTS AND REVERSALS

     C     FRCHTP        IFEQ      'I'
     C     FRCHTP        OREQ      'R'
     C                   EXSR      UPDTRL
     C                   END
     C/COPY WNCPYSRC,IRFRADC008
                                                                                CDE001
      ** UPDATE ON-LINE POSITION FILES                                          CDE001
      ** only if the deal is authorised                                                       CIR008
                                                                                CDE001
     C                   IF        FRCHTP <> *BLANKS                                          CIR008
     C                   EXSR      UPDOLP                                       CDE001
     C                   ENDIF                                                                CIR008
                                                                                              CSC011
      ** If 24x7 Midas Availability is installed                                              CSC011
      ** and Support System is active                                                         CSC011
                                                                                              CSC011
     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)                         CSC011
                                                                                              CSC011
     C                   CALLB     'IRFRALOG'                                                 CSC011
     C                   PARM      *Blanks       RetCodeOut                                   CSC011
     C                   PARM                    WkActn                                       CIR008
     C                   PARM                    DEALS                                        CSC011
     C                   PARM                    TRANSDTL                                     CSC011
                                                                                              CSC011
      ** If there is no error, write the log file                                             CSC011
                                                                                              CSC011
     C                   IF        RetCodeOut = *Blanks                                       CSC011
     C                   CLEAR                   APHEAD                                       CSC011
     C                   EVAL      APTGTTYPE  = 'IRFRA'                                       CSC011
     C                   EVAL      APFOTRANID = FRFRNT                                        CSC011
     C                   EVAL      APRPRLOCN  = FRREPA                                        CSC011
     C*******************EVAL      APUSERID   = PSUser                                 CSC011 CAP084
     C*******************EVAL      APMIDUSR   = PSUser                                 CSC011 CAP084
     C*******************EVAL      APUSERID   = USRID                                  CAP084 225811
     C*******************EVAL      APMIDUSR   = USRID                                  CAP084 225811
     C                   EVAL      APUSERID   = FRUSRI                                        225811
     C                   EVAL      APMIDUSR   = FRUSRI                                        225811
                                                                                              CSC011
     C                   MOVEL     FRDLNO        PDealNum                                     CSC011
                                                                                              CSC011
     C                   CALLB     'APLOGTRAN'                                                CSC011
     C                   PARM      *BLANKS       RetCodeOut                                   CSC011
     C                   PARM                    APHEAD                                       CSC011
     C                   PARM                    TRANSDTL                                     CSC011
     C                   PARM      *BLANKS       Timestamp                                    CSC011
     C                   PARM                    PDealNum                                     CSC011
     C                   PARM      *BLANKS       PADealNo                                     CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
      ** If there is an error in either log file, end program                                 CSC011
                                                                                              CSC011
     C                   IF        RetCodeOut <> *Blanks                                      CSC011
     C                   EVAL      @@RTCD = '*ERROR'                                          CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
      *
      * EXIT FROM PROGRAM
     C     EXIT          TAG                                                    CAP006
      *
     C                   RETURN
     C****************************************************************
      /EJECT
     C*****************************************************************         CAP006
     C*                                                               *         CAP006
     C* CHKOTHUPD - Check for update by another workstation           *         CAP006
     C*                                                               *         CAP006
     C*****************************************************************         CAP006
     C     CHKOTHUPD     BEGSR                                                  CAP006
                                                                                CAP006
      ** Retrieve current deal details                                          CAP006
                                                                                CAP006
     C                   MOVE      FRDLNO        MidasDlNum        6            CAP006
                                                                                CAP006
      ** Determine whether program is running interactively or in batch         CAP006
      **  ( 0 = batch   1 = interactive)                                        CAP006
      *                                                                         CAP006
     C                   CALLB     'ZARTVJOBA'                                  CAP006
     C                   PARM                    @Return           6            CAP006
     C                   PARM                    @type             1            CAP006
      *                                                                         CAP006
      * Allow access to transaction record by Front-Office ID when in Repair    168345
      * mode for inserts . Set  *RTV module  parameter @@MODE  to   *FRONT      168345
      * if the pgm is:  a) running in Interactive mode - @Type= 1   ~~~~~~      168345
      * and             b) action code is Insert - 'I'                          168345
      * and             c) Front-Office Id is NOT Blank                         168345
      *                                                                         168345
     C     @Type         IFEQ      '1'                                          168345
     C     FRCHTP        ANDEQ     'I'                                          168345
     C     FRFRNT        ANDNE     *BLANKS                                      168345
      *                                                                         168345
     C                   MOVE      '*FRONT'      @@MODE                         168345
      *                                                                         168345
     C                   ELSE                                                   168345
      *                                                                         168345
      * Otherwise, if running in batch use Front-Office ID                      168345
      *            (if insert)                                                  CAP013
      *            else, use Midas Deal Number                                  168345
      *                                                                         168345
     C     @Type         IFEQ      '0'                                          CAP006
     C     FRCHTP        ANDEQ     'I'                                          CAP013
     C                   MOVE      '*FRONT'      @@MODE                         CAP006
     C                   ELSE                                                   CAP006
     C                   MOVE      *BLANKS       @@MODE                         CAP006
     C                   END                                                    CAP006
      *                                                                         168345
     C                   END                                                    168345
                                                                                CAP006
     C                   CALLB     'IRFRARTV'                                   CAP006
      * INPUTS                                                                  CAP006
      *                                                                         CAP006
      * Return code                                                             CAP006
     C                   PARM      *BLANK        RetCodeOut                     CAP006
      *                                                                         CAP006
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)                    CAP006
      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)                CAP006
      *                                                                         CAP006
     C                   PARM                    @@MODE            6            CAP006
      *                                                                         CAP006
      * Response mode                                                           CAP006
     C                   PARM      ' '           @@RSMD            1            CAP006
      *                                                                         CAP006
      * Action Code                                                             CAP006
     C                   PARM                    FRCHTP                         CAP006
      *                                                                         CAP006
      * Front Office Transaction ID                                             CAP006
     C                   PARM      FRFRNT        FOTRID           20            CAP006
      *                                                                         CAP006
      * Front Office Associated Transaction Id                                  CAP006
     C                   PARM                    FOASID           20            CAP006
      *                                                                         CAP006
      * (Midas) Deal Number                                                     CAP006
     C                   PARM                    MidasDlNum                     CAP006
      *                                                                         CAP006
      * (Midas) Swap/Option Deal Number                                         CAP006
     C                   PARM                    DDSDNO            6            CAP006
      *                                                                         CAP006
      * Booking branch                                                          CAP006
     C                   PARM      FRBRCA        DDBRSN            3            CAP006
                                                                                              CIR008
      ** FRA/IRS Deals Authorisation                                                          CIR008
     C                   PARM                    CIR008                                       CIR008
      *                                                                         CAP006
      * OUTPUTS                                                                 CAP006
      *                                                                         CAP006
      * (Current) deal in file format                                           CAP006
     C                   PARM                    ChkDealFmt                     CAP006
      *                                                                         CAP006
      * OK - Action code                                                        CAP006
     C                   PARM      *BLANK        OKACCD                         CAP006
      *                                                                         CAP006
      * OK - Deal Number                                                        CAP006
     C                   PARM      *BLANK        OKDLNO                         CAP006
      *                                                                         CAP006
      * OK - Booking branch                                                     CAP006
     C                   PARM      *BLANK        OKBRCA                         CAP006
      *                                                                         CAP006
      * Error fields/message IDs/message data (arrays) from/to caller           CAP006
     C                   PARM      *BLANK        FldNameArr                     CAP006
     C                   PARM      *BLANK        MsgIdArr                       CAP006
     C                   PARM      *BLANK        MsgDtaArr                      CAP006
      *                                                                         CAP006
      * Array index (3P0) from/to caller                                        CAP006
     C                   PARM      *ZERO         Idx               3 0          CAP006
      *                                                                         CAP006
      *                                                                         CAP006
      ** Error if Transaction No. of Last Update (TNLU) not the same            CAP006
      ** (Record has been changed by another workstation)                       CAP006
                                                                                CAP006
      ** Processing varies according to mode program is running in.             CAP006
      ** In interacive mode simply check whether the TNLU field                 CAP006
      ** has been updated since the original deal was fetched by this           CAP006
      ** program.                                                               CAP006
      ** In batch (API input) check return parameters from Retrieve             CAP006
      ** module for errors, and send message to system operator.                CAP006
                                                                                CAP006
      ** Interactive mode:                                                      CAP006
                                                                                CAP006
     C     @TYPE         IFEQ      '1'                                          CAP006
                                                                                CAP006
     C     CHTNLU        IFNE      FRTNLU                                       CAP006
     C                   MOVEL     '*RECUPD'     @@RTCD                         CAP006
     C                   END                                                    CAP006
                                                                                CAP006
      ** Batch mode:                                                            CAP006
     C                   ELSE                                                   CAP006
     C     OKACCD        IFEQ      'N'                                          CAP006
     C     OKDLNO        OREQ      'N'                                          CAP006
     C                   MOVEL     '*RECUPD'     @@RTCD                         CAP006
     C                   Z-ADD     1             C                 2 0          CAP006
                                                                                CAP006
     C     C             DOWLE     ArrayMax                                     CAP006
     C     FldNameArr(C) ANDNE     *BLANKS                                      CAP006
     C*******************MOVEL     *BLANKS       DBError          28     CAP006 CAP013
     C*******************MOVEL     MsgIDArr(C)   DBError                 CAP006 CAP013
     C                   CLEAR                   DBError         132            CAP013
     C                   EVAL      DBerror = 'Update error: ' + FOTRID          CAP013
     C                   CALLB     'ZAMSGTOOPR'                                 CAP006
     C                   PARM                    MsgSndRtn        10            CAP006
     C                   PARM                    DBError                        CAP006
     C                   PARM                    DummyMsgID                     CAP006
     C                   PARM                    DummyMsgF                      CAP006
     C                   ADD       1             C                              CAP006
     C                   END                                                    CAP006
                                                                                CAP006
     C                   END                                                    CAP006
                                                                                CAP006
     C                   END                                                    CAP006
                                                                                CAP006
     C                   ENDSR                                                  CAP006
     C****************************************************************
     C*                                                              *
     C* FRINS  - INSERT AN FRA                                       *
     C*                                                              *
     C****************************************************************
     C     FRINS         BEGSR

      * SET CONFIRMATION REQUIRED INDICATOR
      * TO BE WRITTEN TO DTRIX
      ** when CIR008 is switched off                                                          CIR008

     C                   IF        CIR008 = 'N' OR                                            CIR008
     C                             CIR008 = 'Y' AND  BQFIAU <> 'Y'                            CIR008
     C                   EXSR      CNFINS
     C                   ENDIF                                                                CIR008
                                                                                              CIR008
      ** Deal Status and Change Type                                                          CIR008
                                                                                              CIR008
     C                   IF        CIR008 = 'Y'                                               CIR008
                                                                                              CIR008
     C                   CALLB     'ZAFUTSTATP'                                               CIR008
     C                   PARM      'I'           P_ACTN                                       CIR008
     C                   PARM      *BLANK        P_CSTS                                       CIR008
     C                   PARM                    BQFIAU                                       CIR008
     C                   PARM                    BQFIRA                                       CIR008
     C                   PARM      *BLANK        P_DSTS                                       CIR008
     C                   PARM      *BLANK        FRCHTP                                       CIR008
                                                                                              CIR008
     C                   ENDIF                                                                CIR008

      * INITIALIZE DEAL

     C                   CLEAR                   DEALS
                                                                                             BUG8094
      ** Initialise "before" status of deal for on-line updates.                             BUG8094
     C                   MOVEL     *BLANK        Z#BSTS                                      BUG8094
     C                   Z-ADD     *ZEROS        Z#BAMT                                      BUG8094

      * RECORD ID

     C                   MOVEL     'D'           RECI

      * DEAL NUMBER & RECORD TYPE

     C                   Z-ADD     FRDLNO        DLNO
     C                   MOVE      'G'           RCDT

      * DEAL RECORD CODE

     C                   Z-ADD     21            RCDC

      *  DEAL DETAILS

     C                   MOVE      @FRDET1       @DLDET1
     C                   MOVEL     FRURACC       URACC                                        CGL029
     C                   MOVEL     FRUPACC       UPACC                                        CGL029
     C                   MOVE      @FRDET2       @DLDET2
                                                                                              CIR008
      ** Deal Status and Insert User                                                          CIR008
                                                                                              CIR008
     C                   IF        CIR008 = 'Y'                                               CIR008
     C*******************EVAL      FIUSRI = PsUser                                     CIR008 CAP084
     C*******************EVAL      FIUSRI = USRID                                      CAP084 225811
     C                   EVAL      FIUSRI = FRUSRI                                            225811
     C                   EVAL      FIDSTS = P_DSTS                                            CIR008
     C                   ENDIF                                                                CIR008
                                                                                              CAP056
      ** Update Auto Authorisation on DEALSDG with value from Valid file                      CAP056
                                                                                              CAP056
     C                   IF        CAP056 = 'Y'                                               CAP056
     C                   EVAL      FIAUTH = FRAUTH                                            CAP056
     C                   ENDIF                                                                CAP056
                                                                                              CAS006
     C                   IF        CAS006 = 'Y'                                               CAS006
     C                   EVAL      FSRKVL = FRRKVL                                            CAS006
     C                   EVAL      FSRKSN = FRRKSN                                            CAS006
     C                   ELSE                                                                 CAS006
     C                   EVAL      FSRKVL = *ZEROS                                            CAS006
     C                   EVAL      FSRKSN = *BLANKS                                           CAS006
     C                   ENDIF                                                                CAS006
      *                                                                         CIR005
      ** Currencies for Rate Fixing Convention                                  CIR005
      *                                                                         CIR005
     C                   IF        (CIR005 = 'Y')                               CIR005
     C                   EVAL      @DLRCUR = @FRRCCY                            CIR005
     C                   ENDIF                                                  CIR005
                                                                                151240
      * INITIALIZE BIT SETTINGS                                                 151240
                                                                                151240
     C                   BITOFF    '01234567'    UDNSI                          151240
     C                   BITOFF    '01234567'    TDNSI                          151240
     C**********         BITOFF    '01234567'    UDSTI                               151240 BUG12628
     C**********         BITOFF    '01234567'    TDSTI                               151240 BUG12628
     C                   BITOFF    '0134567'     UDSTI                                      BUG12628
     C                   BITOFF    '0134567'     TDSTI                                      BUG12628
     C                   BITOFF    '01234567'    ACEI                           151240
     C                   BITOFF    '01234567'    TLXI                           151240
     C                   BITOFF    '01234567'    CNFI                           151240
      *
      *
      * RECEIVE SETTLEMENT INSTRUCTIONS
      *
     C                   MOVEL     @FRREC        @DLREC
     C                   MOVEL     FRRONS        RONS                                         CGL029
      *
      * PAYMENT SETTLEMENT INSTRUCTIONS
      *
     C                   MOVEL     @FRPY1        @DLPY1
     C                   MOVEL     @FRPY2        @DLPY2
     C                   MOVEL     @FRPY3        @DLPY3
     C                   MOVEL     FRPONS        PONS                                         CGL029
      *
      * 'OLD' SETTLEMENT INSTRUCTIONS
      *
     C                   MOVEL     FRRSTM        RSETM
     C                   MOVEL     FRRONS        URACC
      *                                                                                       200400
      ** OUR RECEIVING ACCOUNT = CUSTOMER DEFAULT ACCOUNT, IF METHOD 04                       200400
      *                                                                                       200400
     C     FRRSTM        IFEQ      04                                                         200400
     C**********         MOVEL     FRCNUM        WRK_10           10                   200400 CGL029
     C**********         MOVE      BMACCD        WRK_10                                200400 CGL029
     C**********         MOVEL     WRK_10        URACC                                 200400 CGL029
     C                   MOVEL     FRCNUM        WRK_16                                       CGL029
     C                   MOVE      BMACCD        WRK_16                                       CGL029
     C                   MOVEL     WRK_16        URACC                                        CGL029
     C                   MOVE      '01'          URACC                                        200400
     C                   ENDIF                                                                200400
      ************                                                                     179510 200400
      **For*Settlement*method*04*,*move*the*required*part*of**the****                  179510 200400
      **Data-Structure  into the  correspondent  file  field  .                        179510 200400
      ************                                                                     179510 200400
     C*****FRRSTM*       IFEQ      04                                                  179510 200400
     C************       MOVE      FRURACC       URACC                                 179510 200400
     C************       ENDIF                                                         179510 200400
      ************                                                                     179510 200400
     C***********        MOVEL     FRAWBN        CPPBK                          CSW097
     C                   MOVEL     FRRCRN        CPPBK                          CSW097
     C                   MOVEL     FRPSTM        PSETM
     C                   MOVEL     FRPONS        UPACC
      *                                                                                       200400
      ** OUR PAYMENT ACCOUNT = CUSTOMER DEFAULT ACCOUNT, IF METHOD 04                         200400
      *                                                                                       200400
     C     FRPSTM        IFEQ      04                                                         200400
     C**********         MOVEL     FRCNUM        WRK_10           10                   200400 CGL029
     C**********         MOVE      BMACCD        WRK_10                                200400 CGL029
     C**********         MOVEL     WRK_10        UPACC                                 200400 CGL029
     C                   MOVEL     FRCNUM        WRK_16                                       CGL029
     C                   MOVE      BMACCD        WRK_16                                       CGL029
     C                   MOVEL     WRK_16        UPACC                                        CGL029
     C                   MOVE      '01'          UPACC                                        200400
     C                   ENDIF                                                                200400
      ************                                                                     179510 200400
      **For*Settlement*method*04*,*move*the*required*part*of**the****                  179510 200400
      **Data-Structure  into the  correspondent  file  field  .                        179510 200400
      ************                                                                     179510 200400
     C*****FRPSTM*       IFEQ      04                                                  179510 200400
     C************       MOVE      FRUPACC       UPACC                                 179510 200400
     C************       ENDIF                                                         179510 200400
      ************                                                                     179510 200400
     C***********        MOVEL     FRRIBN        CPRBK                          CSW097
     C                   MOVEL     FRAWBN        CPRBK                          CSW097
     C                   MOVEL     FRBENN        FACO
     C                   MOVEL     FRBTB1        SPI
      *
      * SET UP REQUIRED FIELDS ON DEALSDG THAT WERE NOT SET UP ON
      * VALID FILE
      *
     C                   EXSR      SETREQFLD
      *
      * Original Entry Date & Last Change Date
      *
     C                   Z-ADD     BJRDNB        ORED                                          S0119
     C                   Z-ADD     BJRDNB        LCD                                           S0119
      *
      * Set Transaction No. of Last Update                                      CAP006
     C                   Z-ADD     1             TNLU                           CAP006
                                                                                              CSC011
      ** If CSC011 is installed, supply a Front Office ID for the                             CSC011
      ** transaction even if it originated from SIN module.                                   CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y'                                               CSC011
     C                   IF        FRNT = *BLANKS                                             CSC011
     C                   MOVEL     DLNO          WDealNo                                      CSC011
     C                   EVAL      FRNT = 'MD' + WDealNo                                      CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSD015
     C                   IF        CSD015 = 'Y' AND W1EWLC = 'Y'                              CSD015
     C                             AND (CSC011 = 'N' OR CSC011 = 'Y'                          CSD015
     C                             AND LIBR = S1MAIN)                                         CSD015
                                                                                              CSD015
     C                   MOVEL     RONS          WLF(1)                                       CSD015
     C                   MOVEL     ROCN          WLF(2)                                       CSD015
     C                   MOVEL     RIBN          WLF(3)                                       CSD015
     C                   MOVEL     ROBN          WLF(4)                                       CSD015
     C                   MOVEL     PONS          WLF(5)                                       CSD015
     C                   MOVEL     POCN          WLF(6)                                       CSD015
     C                   MOVEL     RVNO          WLF(7)                                       CSD015
     C                   MOVEL     RCRN          WLF(8)                                       CSD015
     C                   MOVEL     PIBN          WLF(9)                                       CSD015
     C                   MOVEL     POBN          WLF(10)                                      CSD015
     C                   MOVEL     AWBN          WLF(11)                                      CSD015
     C                   MOVEL     BENN          WLF(12)                                      CSD015
                                                                                              CSD015
     C                   EVAL      Ctr = 1                                                    CSD015
     C                   DOU       Ctr > Elements                                             CSD015
                                                                                              CSD015
     C                   IF        WLF(Ctr) <> *BLANKS                                        CSD015
     C                   EVAL      WLOKFlg = 'Y'                                              CSD015
     C                   LEAVE                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   EVAL      Ctr = Ctr + 1                                              CSD015
                                                                                              CSD015
     C                   ENDDO                                                                CSD015
                                                                                              CSD015
     C                   IF        WLOKFlg = 'Y'                                              CSD015
     C                   EXSR      SrWatch                                                    CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      *                                                                                       CDL038
      * Class                                                                                 CDL038
      *                                                                                       CDL038
     C                   MOVEL     FRCLAS        CLAS                                         CDL038
      *
      * WRITE DEAL
      *
     C                   WRITE     DEALSDGF
     C/COPY WNCPYSRC,IRFRADC005
      *                                                                                      BUG8094
      ** Setup deal activity for on-line updates.                                            BUG8094
      ** only if the deal is authorised. Else perform in SrAuthorise.                        BUG8094
      *                                                                                      BUG8094
     C                   IF        FRCHTP <> *BLANKS                                         BUG8094
     C                   MOVEL     DEALS         Z#ASTS                                      BUG8094
     C                   Z-ADD     *ZEROS        Z#AAMT                                      BUG8094
     C                   ENDIF                                                               BUG8094
      *
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* FRAMD  - AMEND AN FRA                                        *
     C*                                                              *
     C****************************************************************
     C     FRAMD         BEGSR
      *
      * ACCESS DEAL
      *
     C     FRDLNO        CHAIN     DEALSDGF                           99
      *
      ** DATABASE ERROR
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     FRDLNO        DBKEY
     C                   MOVEL     'DEALSDG '    DBFILE                         ************
     C                   MOVEL     '002'         DBASE                          * DBERR 002*
     C                   EXSR      SRERR                                        ************
     C                   END
                                                                                              CIR008
      ** Deal Status and Change Type                                                          CIR008
                                                                                              CIR008
     C                   IF        CIR008  = 'Y'                                              CIR008
                                                                                              CIR008
     C                   CALLB     'ZAFUTSTATP'                                               CIR008
     C                   PARM      'A'           P_ACTN                                       CIR008
     C                   PARM      FIDSTS        P_CSTS                                       CIR008
     C                   PARM                    BQFIAU                                       CIR008
     C                   PARM                    BQFIRA                                       CIR008
     C                   PARM      *BLANK        FIDSTS                                       CIR008
     C                   PARM      *BLANK        FRCHTP                                       CIR008
                                                                                              CIR008
      ** Amend User                                                                           217684
     C*******************EVAL      FIUSRA = PsUser                                     217684 CAP084
     C*******************EVAL      FIUSRA = USRID                                      CAP084 225811
     C                   EVAL      FIUSRA = FRUSRA                                            225811
                                                                                              217684
     C                   ENDIF                                                                CIR008
                                                                                              CAP056
      ** Update Auto Authorisation on DEALSDG with value from Valid file                      CAP056
                                                                                              CAP056
     C                   IF        CAP056 = 'Y'                                               CAP056
     C                   EVAL      FIAUTH = FRAUTH                                            CAP056
     C                   ENDIF                                                                CAP056
                                                                                             BUG8094
      ** Set up "before" status of deal for on-line updates.                                 BUG8094
                                                                                             BUG8094
     C                   MOVEL     DEALS         Z#BSTS                                      BUG8094
     C                   Z-ADD     *ZEROS        Z#BAMT                                      BUG8094
      *
      * SET CONFIRMATION BIT ON DEAL
      * AND CONFIRMATION REQUIRED INDICATOR
      * TO BE WRITTEN TO DTRIX
      ** When CIR008 is switched off                                                          CIR008
      *
     C                   IF        CIR008 = 'N'  OR                                           CIR008
     C                             CIR008 = 'Y'  AND  BQFIRA <> 'Y'                           CIR008
     C                   EXSR      CNFAMD
     C                   ENDIF                                                                CIR008
      *
      *  DEAL DETAILS

     C                   MOVE      @FRDET1       @DLDET1
     C                   MOVEL     FRURACC       URACC                                        CGL029
     C                   MOVEL     FRUPACC       UPACC                                        CGL029
     C                   MOVE      @FRDET2       @DLDET2
                                                                                              CAS006
     C                   IF        CAS006 = 'Y'                                               CAS006
     C                   EVAL      FSRKVL = FRRKVL                                            CAS006
     C                   EVAL      FSRKSN = FRRKSN                                            CAS006
     C                   ENDIF                                                                CAS006
      *                                                                         CIR005
      ** Currencies for Rate Fixing Convention                                  CIR005
      *                                                                         CIR005
     C                   IF        (CIR005 = 'Y')                               CIR005
     C                   EVAL      @DLRCUR = @FRRCCY                            CIR005
     C                   ENDIF                                                  CIR005
      *
      * RECEIVE SETTLEMENT INSTRUCTIONS
      *
     C                   MOVEL     @FRREC        @DLREC
     C                   MOVEL     FRRONS        RONS                                         CGL029
      *
      * PAYMENT SETTLEMENT INSTRUCTIONS
      *
     C                   MOVEL     @FRPY1        @DLPY1
     C                   MOVEL     @FRPY2        @DLPY2
     C                   MOVEL     @FRPY3        @DLPY3
     C                   MOVEL     FRPONS        PONS                                         CGL029
      *
      * 'OLD' SETTLEMENT INSTRUCTIONS
      *
     C                   MOVEL     FRRSTM        RSETM
     C                   MOVEL     FRRONS        URACC
      *                                                                                       200400
      ** OUR RECEIVING ACCOUNT = CUSTOMER DEFAULT ACCOUNT, IF METHOD 04                       200400
      *                                                                                       200400
     C     FRRSTM        IFEQ      04                                                         200400
     C**********         MOVEL     FRCNUM        WRK_10           10                   200400 CGL029
     C**********         MOVE      BMACCD        WRK_10                                200400 CGL029
     C**********         MOVEL     WRK_10        URACC                                 200400 CGL029
     C                   MOVEL     FRCNUM        WRK_16                                       CGL029
     C                   MOVE      BMACCD        WRK_16                                       CGL029
     C                   MOVEL     WRK_16        URACC                                        CGL029
     C                   MOVE      '01'          URACC                                        200400
     C                   ENDIF                                                                200400
      ************                                                                     179510 200400
      **For*Settlement*method*04*,*move*the*required*part*of**the****                  179510 200400
      **Data-Structure  into the  correspondent  file  field  .                        179510 200400
      ************                                                                     179510 200400
     C*****FRRSTM*       IFEQ      04                                                  179510 200400
     C************       MOVE      FRURACC       URACC                                 179510 200400
     C************       ENDIF                                                         179510 200400
      ************                                                                     179510 200400
     C***********        MOVEL     FRAWBN        CPPBK                          CSW097
     C                   MOVEL     FRRCRN        CPPBK                          CSW097
     C                   MOVEL     FRPSTM        PSETM
     C                   MOVEL     FRPONS        UPACC
      *                                                                                       200400
      ** OUR PAYMENT ACCOUNT = CUSTOMER DEFAULT ACCOUNT, IF METHOD 04                         200400
      *                                                                                       200400
     C     FRPSTM        IFEQ      04                                                         200400
     C**********         MOVEL     FRCNUM        WRK_10           10                   200400 CGL029
     C**********         MOVE      BMACCD        WRK_10                                200400 CGL029
     C**********         MOVEL     WRK_10        UPACC                                 200400 CGL029
     C                   MOVEL     FRCNUM        WRK_16                                       CGL029
     C                   MOVE      BMACCD        WRK_16                                       CGL029
     C                   MOVEL     WRK_16        UPACC                                        CGL029
     C                   MOVE      '01'          UPACC                                        200400
     C                   ENDIF                                                                200400
      ************                                                                     179510 200400
      **For*Settlement*method*04*,*move*the*required*part*of**the****                  179510 200400
      **Data-Structure  into the  correspondent  file  field  .                        179510 200400
      ************                                                                     179510 200400
     C*****FRPSTM*       IFEQ      04                                                  179510 200400
     C************       MOVE      FRUPACC       UPACC                                 179510 200400
     C************       ENDIF                                                         179510 200400
      ************                                                                     179510 200400
     C***********        MOVEL     FRRIBN        CPRBK                          CSW097
     C                   MOVEL     FRAWBN        CPRBK                          CSW097
     C                   MOVEL     FRBENN        FACO
     C                   MOVEL     FRBTB1        SPI
      *
      * SET UP REQUIRED FIELDS ON DEALSDG THAT WERE NOT SET UP ON
      * VALID FILE
      *
     C                   EXSR      SETREQFLD
      *
      * Last Change Date & Last Change Type
      *
     C                   Z-ADD     BJRDNB        LCD                                           S0119
     C**********         MOVE      'A'           CHTP                                         CIR008
      *
      * Set Transaction No. of Last Update                                      CAP006
     C                   ADD       1             TNLU                           CAP006
                                                                                              CSD015
     C                   If        CSD015 = 'Y' AND W1EWLC = 'Y'                              CSD015
     C                             AND (CSC011 = 'N' OR CSC011 = 'Y'                          CSD015
     C                             AND LIBR = S1MAIN)                                         CSD015
                                                                                              CSD015
     C                   EVAL      WFuncType ='DEALSDG'                                       CSD015
     C                   MOVEL     DLNO          WIdntifier                                   CSD015
     C                   EVAL      WBranch = BRCA                                             CSD015
                                                                                              CSD015
     C     KCwFld        CHAIN     SDCWHTL1                                                   CSD015
                                                                                              CSD015
     C                   IF        %FOUND(SDCWHTL1) AND W3UNCF = 'Y'                          CSD015
     C                   MOVEL     RONS          WLF(1)                                       CSD015
     C                   MOVEL     ROCN          WLF(2)                                       CSD015
     C                   MOVEL     RIBN          WLF(3)                                       CSD015
     C                   MOVEL     ROBN          WLF(4)                                       CSD015
     C                   MOVEL     PONS          WLF(5)                                       CSD015
     C                   MOVEL     POCN          WLF(6)                                       CSD015
     C                   MOVEL     RVNO          WLF(7)                                       CSD015
     C                   MOVEL     RCRN          WLF(8)                                       CSD015
     C                   MOVEL     PIBN          WLF(9)                                       CSD015
     C                   MOVEL     POBN          WLF(10)                                      CSD015
     C                   MOVEL     AWBN          WLF(11)                                      CSD015
     C                   MOVEL     BENN          WLF(12)                                      CSD015
     C                   EXSR      SrWatch                                                    CSD015
     C                   ELSE                                                                 CSD015
                                                                                              CSD015
     C                   MOVEA     *BLANKS       WLF                                          CSD015
                                                                                              CSD015
     C                   IF        RONS <> CHRONS                                             CSD015
     C                   MOVEL     RONS          WLF(1)                                       CSD015
     C                   EVAL      WLChgFlg = 'Y'                                             CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        ROCN <> CHROCN                                             CSD015
     C                   MOVEL     ROCN          WLF(2)                                       CSD015
     C                   EVAL      WLChgFlg = 'Y'                                             CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        RIBN <> CHRIBN                                             CSD015
     C                   MOVEL     RIBN          WLF(3)                                       CSD015
     C                   EVAL      WLChgFlg = 'Y'                                             CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        ROBN <> CHROBN                                             CSD015
     C                   MOVEL     ROBN          WLF(4)                                       CSD015
     C                   EVAL      WLChgFlg = 'Y'                                             CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        PONS <> CHPONS                                             CSD015
     C                   MOVEL     PONS          WLF(5)                                       CSD015
     C                   EVAL      WLChgFlg = 'Y'                                             CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        POCN <> CHPOCN                                             CSD015
     C                   MOVEL     POCN          WLF(6)                                       CSD015
     C                   EVAL      WLChgFlg = 'Y'                                             CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        RVNO <> CHRVNO                                             CSD015
     C                   MOVEL     RVNO          WLF(7)                                       CSD015
     C                   EVAL      WLChgFlg = 'Y'                                             CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        RCRN <> CHRCRN                                             CSD015
     C                   MOVEL     RCRN          WLF(8)                                       CSD015
     C                   EVAL      WLChgFlg = 'Y'                                             CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        PIBN <> CHPIBN                                             CSD015
     C                   MOVEL     PIBN          WLF(9)                                       CSD015
     C                   EVAL      WLChgFlg = 'Y'                                             CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        POBN <> CHPOBN                                             CSD015
     C                   MOVEL     POBN          WLF(10)                                      CSD015
     C                   EVAL      WLChgFlg = 'Y'                                             CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        AWBN <> CHAWBN                                             CSD015
     C                   MOVEL     AWBN          WLF(11)                                      CSD015
     C                   EVAL      WLChgFlg = 'Y'                                             CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        BENN <> CHBENN                                             CSD015
     C                   MOVEL     BENN          WLF(12)                                      CSD015
     C                   EVAL      WLChgFlg = 'Y'                                             CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
                                                                                              CSD015
     C                   IF        WLChgFlg = 'Y'                                             CSD015
     C                   EXSR      SrWatch                                                    CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      *                                                                                       CDL038
      * Class                                                                                 CDL038
      *                                                                                       CDL038
     C                   MOVEL     FRCLAS        CLAS                                         CDL038
      *
      * UPDATE DEAL
      *
     C                   UPDATE    DEALSDGF
     C/COPY WNCPYSRC,IRFRADC006
                                                                                             BUG8094
      ** Set up deal activity for on-line updates.                                           BUG8094
      ** only if the deal is authorised. Else perform in SrAuthorise.                        BUG8094
                                                                                             BUG8094
     C                   IF        FRCHTP <> *BLANKS                                         BUG8094
     C                   MOVEL     DEALS         Z#ASTS                                      BUG8094
     C                   Z-ADD     *ZEROS        Z#AAMT                                      BUG8094
     C                   ENDIF                                                               BUG8094
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* FRDEL  - DELETE AN FRA                                       *
     C*                                                              *
     C****************************************************************
     C     FRDEL         BEGSR
      *
      * ACCESS DEAL
      *
     C     FRDLNO        CHAIN     DEALSDGF                           99
      *
      ** DATABASE ERROR
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     FRDLNO        DBKEY
     C                   MOVEL     'DEALSDG '    DBFILE                         ************
     C                   MOVEL     '003'         DBASE                          * DBERR 003*
     C                   EXSR      SRERR                                        ************
     C                   END
      *
      * SET CONFIRMATION BIT ON DEAL
      * AND CONFIRMATION REQUIRED INDICATOR
      * TO BE WRITTEN TO DTRIX
      *
     C                   EXSR      CNFDEL
                                                                                              CIR008
      ** Deal Status and Change Type                                                          CIR008
                                                                                              CIR008
     C                   IF        CIR008 = 'Y'                                               CIR008
                                                                                              CIR008
     C                   CALLB     'ZAFUTSTATP'                                               CIR008
     C                   PARM      'D'           P_ACTN                                       CIR008
     C                   PARM      FIDSTS        P_CSTS                                       CIR008
     C                   PARM                    BQFIAU                                       CIR008
     C                   PARM                    BQFIRA                                       CIR008
     C                   PARM      *BLANK        FIDSTS                                       CIR008
     C                   PARM      *BLANK        FRCHTP                                       CIR008
                                                                                              CIR008
     C                   ENDIF                                                                CIR008
      *                                                                                      BUG8094
      ** Set up "before" status of deal for on-line updates.                                 BUG8094
      ** only if the deal is authorised. Else perform in SrAuthorise.                        BUG8094
      *                                                                                      BUG8094
     C                   IF        FRCHTP <> *BLANKS                                         BUG8094
     C                   MOVEL     IRVFRA        Z#BSTS                                      BUG8094
     C                   Z-ADD     *ZEROS        Z#BAMT                                      BUG8094
     C                   ENDIF                                                               BUG8094
      *
      * SET RECORD ID TO 'REVERSED'
      *
     C                   MOVE      'R'           RECI
      *
      ** LAST CHANGE DATE & TYPE
      *
     C                   Z-ADD     BJRDNB        LCD
     C**********         MOVE      'R'           CHTP                                         CIR008
     C                   EVAL      CHTP = FRCHTP                                              CIR008
      *
      * Set Transaction No. of Last Update                                      CAP006
     C                   ADD       1             TNLU                           CAP006
      *                                                                         CAP013
      ** Front office transaction ID                                            CAP013
      *                                                                         CAP013
     C                   MOVEL     FRFRNT        FRNT                           CAP013
      *
     C                   UPDATE    DEALSDGF
     C/COPY WNCPYSRC,IRFRADC007
                                                                                             BUG8094
      ** Set up deal activity for on-line updates.                                           BUG8094
      ** only if the deal is authorised. Else perform in SrAuthorise.                        BUG8094
                                                                                             BUG8094
     C                   IF        FRCHTP <> *BLANKS                                         BUG8094
     C                   MOVEL     DEALS         Z#ASTS                                      BUG8094
     C                   Z-ADD     *ZEROS        Z#AAMT                                      BUG8094
     C                   ENDIF                                                               BUG8094

     C                   ENDSR
     C*****************************************************************                       CIR008
      /EJECT                                                                                  CIR008
      *****************************************************************                       CIR008
      *                                                               *                       CIR008
      * SRAuthorise - Authorise an IRS                                *                       CIR008
      *                                                               *                       CIR008
      *****************************************************************                       CIR008
     C     SRAuthorise   BEGSR                                                                CIR008
                                                                                              CIR008
      ** Access Deal                                                                          CIR008
                                                                                              CIR008
     C     FRDLNO        CHAIN     DEALSDGF                           89                      CIR008
                                                                                              CIR008
     C                   IF        *IN89 = *ON                                                CIR008
     C                   MOVE      FRDLNO        DBKEY                                        CIR008
     C                   EVAL      DBFILE = 'DEALSDG'                                         CIR008
     C                   EVAL      DBASE = 007                                                CIR008
     C                   EXSR      SRERR                                                      CIR008
     C                   END                                                                  CIR008
                                                                                              CIR008
      ** Set Confirmation required indicator to be written to DTRIX                           CIR008
                                                                                              CIR008
     C     FIDSTS        CASEQ     'C'           CNFINS                                       CIR008
     C     FIDSTS        CASEQ     'R'           CNFAMD                                       CIR008
     C                   END                                                                  CIR008
                                                                                              CIR008
      ** Deal Status and Change Type                                                          CIR008
                                                                                              CIR008
     C                   CALLB     'ZAFUTSTATP'                                               CIR008
     C                   PARM      'X'           P_ACTN                                       CIR008
     C                   PARM      FIDSTS        P_CSTS                                       CIR008
     C                   PARM                    BQFIAU                                       CIR008
     C                   PARM                    BQFIRA                                       CIR008
     C                   PARM      *BLANK        FIDSTS                                       CIR008
     C                   PARM      *BLANK        FRCHTP                                       CIR008
                                                                                              CIR008
     C                   EVAL      CHTP = FRCHTP                                              CIR008
                                                                                              CIR008
      ** Authorise User                                                                       217684
     C*******************EVAL      FIUSRX = PsUser                                     217684 CAP084
     C*******************EVAL      FIUSRX = USRID                                      CAP084 225811
     C                   EVAL      FIUSRX = FRUSRX                                            225811
                                                                                              217684
      ** Last change date                                                                     CIR008
                                                                                              CIR008
     C                   Z-ADD     BJRDNB        LCD                                          CIR008
                                                                                             BUG8094
      ** Set up "before" status of deal for on-line updates,                                 BUG8094
      ** for Amends and Deletes                                                              BUG8094
                                                                                             BUG8094
     C                   IF        FRCHTP = 'A' OR FRCHTP = 'R'                              BUG8094
     C                   EVAL      Z#BSTS = IRVFRA                                           BUG8094
     C                   Z-ADD     *ZEROS        Z#BAMT                                      BUG8094
     C                   ENDIF                                                               BUG8094
                                                                                              CIR008
      **  Update Record                                                                       CIR008
                                                                                              CIR008
     C                   UPDATE    DEALSDGF                                                   CIR008
                                                                                              CIR008
      ** Set up "after" status of deal for on-line updates                                   BUG8094
                                                                                             BUG8094
     C                   EVAL      Z#ASTS = DEALS                                            BUG8094
     C                   Z-ADD     *ZEROS        Z#AAMT                                      BUG8094
                                                                                             BUG8094
     C                   ENDSR                                                                CIR008
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* SETREQFLD -  SET UP REQUIRED FIELDS ON DEALSDG THAT WERE     *
     C*              NOT SET UP ON VALID FILE                        *
     C*                                                              *
     C****************************************************************
     C     SETREQFLD     BEGSR
      *
      * Hedge Indicator
      *
     C                   EXSR      ACSBOK
     C                   MOVE      BDHGIN        HEDIN                                         S0119
      *
      * Effective Interest Rate
      *
      * Buy
     C     FRBYSL        IFEQ      'B'
     C                   Z-ADD     FRURTSP       UEINR
      * If rate not already fixed then initialize effective interest rate       161937
     C                   TESTB     '0'           TDNSI                    99    161937
     C     *IN99         IFEQ      '0'                                          161937
     C                   Z-ADD     0             TEINR
     C                   ENDIF                                                  161937
     C                   ELSE
      * Sell
     C                   Z-ADD     FRTRTSP       TEINR
      * If rate not already fixed then initialize effective interest rate       161937
     C                   TESTB     '0'           UDNSI                    99    161937
     C     *IN99         IFEQ      '0'                                          161937
     C                   Z-ADD     0             UEINR
     C                   ENDIF                                                  161937
     C                   END
      *
      * Floating Rate Fix Days
      **Default*if*not*entered********
      * (Defaulting done in IRVRATEFIX)
      *
      * Buy
     C     FRBYSL        IFEQ      'B'

     C*****FRTFRFD       IFEQ      *ZEROS
     C*****BJLCCY        IFEQ      BLCYCD                                                      S0119
     C*****FRUCUCY       ANDEQ     BLCYCD                                                      S0119
     C*******            Z-ADD     0             TFRFD
     C*******            ELSE
     C*******            Z-ADD     2             TFRFD
     C*******            END
     C*******            END
     C
                                                                                              CIR011
      ** Their Floating Rate Fix Days will be adjusted if CIR011 is ON.                       CIR011
                                                                                              CIR011
     C     CIR011        IFEQ      'Y'                                                        CIR011
     C                   EXSR      ACSDCY                                                     CIR011
     C                   SUB       A6FXDY        TFRFD                                        CIR011
     C                   ENDIF                                                                CIR011
                                                                                              CIR011
     C/COPY WNCPYSRC,IRFRADC009
      * Our Floating Rate Fix Days & Int Fix Date will be zero for Buy
     C                   Z-ADD     0             UFRFD
     C                   Z-ADD     0             UINFD
     C
     C                   ELSE
      * Sell
     C*****FRUFRFD       IFEQ      *ZEROS
     C*****BJLCCY        IFEQ      BLCYCD                                                      S0119
     C*****FRUCUCY       ANDEQ     BLCYCD                                                      S0119
     C*******            Z-ADD     0             UFRFD
     C*******            ELSE
     C*******            Z-ADD     2             UFRFD
     C*******            END
     C*******            END
                                                                                              CIR011
      ** Our Floating Rate Fix Days will be adjusted if CIR011 is ON.                         CIR011
                                                                                              CIR011
     C     CIR011        IFEQ      'Y'                                                        CIR011
     C                   EXSR      ACSDCY                                                     CIR011
     C                   SUB       A6FXDY        UFRFD                                        CIR011
     C                   ENDIF                                                                CIR011
                                                                                              CIR011
     C/COPY WNCPYSRC,IRFRADC010
     C
      * Their Floating Rate Fix Days & Int Fix Date will be zero for Sell
     C                   Z-ADD     0             TFRFD
     C                   Z-ADD     0             TINFD
     C
     C                   END
      *
      * Base Currency Exchange Rate
      * Default if not entered
      *
     C     FRUBCXR       IFEQ      *ZEROS
     C                   EXSR      ACSDCY
     C                   Z-ADD     A6SPRT        UBCXR
     C                   Z-ADD     A6SPRT        TBCXR
     C                   END
      *
      * Machine Time
      *
     C                   TIME                    DDTM
      *
      * Base Rate Code for Sequencing
      *
     C*****FRUBRTT       IFNE      *ZEROS                                                     CSD103
     C     FRUBRTT       IFNE      *BLANKS                                                    CSD103
     C**********         Z-ADD     FRUBRTT       BRSQ                                         CSD103
     C                   MOVEL     FRUBRTT       BRSQ                                         CSD103
     C                   ELSE
     C**********         Z-ADD     FRTBRTT       BRSQ                                         CSD103
     C                   MOVEL     FRTBRTT       BRSQ                                         CSD103
     C                   END
      *
      * Our/Their Last Rate Change Date                                        CPL002
     C                   Z-ADD     0             PLULRC                        CPL002
     C                   Z-ADD     0             PLTLRC                        CPL002
      *                                                                        CPL002
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* PYRCIN - DETERMINE PAY/RECEIVE INDICATORS                    *
     C*                                                              *
     C****************************************************************
     C     PYRCIN        BEGSR
      *
      * Indicators are '0' for FRAs.
     C                   Z-ADD     *ZERO         @@PRI1            1 0
     C                   Z-ADD     *ZERO         @@PRI2            1 0
     C                   Z-ADD     *ZERO         @@PRI3            1 0
      *
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* CNFINS - SET CONFIRMATION INDICATOR ON INSERTION             *
     C*                                                              *
     C****************************************************************
     C     CNFINS        BEGSR
      *
     C                   MOVE      'N'           @@CNRQ            1
      *
      *
      * CONFIRMATION REQUIRED IF SETTLEMENT INSTRUCTIONS PRESENT
      * OR IF 2 LEVEL INPUT NOT PRESENT
      *
     C     FRRSTM        IFNE      *ZERO
     C     FRPSTM        ORNE      *ZERO
     C     BLL2II        OREQ      'N'
     C                   MOVE      'Y'           @@CNRQ
     C                   END
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* CNFAMD - SET CONFIRMATION INDICATOR ON AMENDMENT             *
     C*                                                              *
     C****************************************************************
     C     CNFAMD        BEGSR
      *
     C                   MOVE      'N'           @@CNRQ                                       194487
      *                                                                                       194487
      * IF SETTLEMENT INSTRUCTIONS WERE PREVIOUSLY PRESENT
      * OR IF 2 LEVEL INPUT NOT PRESENT
      * OR IF ORIGINAL ENTRY DATE NOT EQUAL TO RUN DATE
      *
     C     RSTM          IFNE      *ZERO
     C     PSTM          ORNE      *ZERO
     C     FRRSTM        ORNE      *ZERO                                                      194487
     C     FRPSTM        ORNE      *ZERO                                                      194487
     C     BLL2II        OREQ      'N'
     C     ORED          ORNE      BJRDNB
      *
      ** If settlement instruction fields have changed
      *
     C     RSTM          IFNE      FRRSTM
     C     RONS          ORNE      FRRONS
     C     RIBN          ORNE      FRRIBN
     C     RIBA          ORNE      FRRIBA                                                     194487
     C     ROBN          ORNE      FRROBN                                                     194487
     C     ROCN          ORNE      FRROCN                                                     194487
     C     PSTM          ORNE      FRPSTM
     C     PONS          ORNE      FRPONS
     C     PIBN          ORNE      FRPIBN                                                     194487
     C     PIBA          ORNE      FRPIBA                                                     194487
     C     POBN          ORNE      FRPOBN                                                     194487
     C     POCN          ORNE      FRPOCN                                                     194487
     C     RCRN          ORNE      FRRCRN                                                     194487
     C     RCRA          ORNE      FRRCRA                                                     194487
     C     RVNO          ORNE      FRRVNO                                                     194487
     C     AWBN          ORNE      FRAWBN
     C     AWBA          ORNE      FRAWBA                                                     194487
     C     BENN          ORNE      FRBENN
     C     BENA          ORNE      FRBENA                                                     194487
     C     DTP1          ORNE      FRDTP1                                                     194487
     C     DTP2          ORNE      FRDTP2                                                     194487
     C     DTP3          ORNE      FRDTP3                                                     194487
     C     DTP4          ORNE      FRDTP4                                                     194487
     C     DCHG          ORNE      FRDCHG                                                     194487
     C     BTB1          ORNE      FRBTB1
     C     BTB2          ORNE      FRBTB2                                                     194487
     C     BTB3          ORNE      FRBTB3                                                     194487
     C     BTB4          ORNE      FRBTB4                                                     194487
     C     BTB5          ORNE      FRBTB5                                                     194487
     C     BTB6          ORNE      FRBTB6                                                     194487
     C     CVMR          ORNE      FRCVMR                                                     194487
     C     RSCY          ORNE      FRRSCY                                                     194487
     C     PSCY          ORNE      FRPSCY                                                     194487
     C     IC72          ORNE      FRIC72                                                     194487
      *
      ** or if Def. Sender-Receiver info has changed
     C     DSR1          ORNE      FRDSR1
     C     DSR2          ORNE      FRDSR2
     C     DSR3          ORNE      FRDSR3
     C     DSR4          ORNE      FRDSR4
     C     DSR5          ORNE      FRDSR5
     C     DSR6          ORNE      FRDSR6
      *
      ** or if the ISDA fields have changed                                     CSW097
      *                                                                         CSW097
     C     ISDA          ORNE      FRISDA                                       CSW097
     C     AGTY          ORNE      FRAGTY                                       CSW097
     C     AGDT          ORNE      FRAGDT                                       CSW097
     C     AGVC          ORNE      FRAGVC                                       CSW097
     C     AGVV          ORNE      FRAGVV                                       CSW097
      *                                                                         CSW097
      ** or if deal contract fields have changed
      *
     C*****NIDT          ORNE      IKNIPD
     C*****IPFR          ORNE      IKIPFQ
     C*****INTF          ORNE      IKIPDM
     C     VDAT          ORNE      FRVDAT                                                     194487
     C     MDAT          ORNE      FRMDAT                                                     194487
     C     USTRT         ORNE      FRUSTRT                                                    194487
     C     UEINR         ORNE      FRUEINR                                                    194487
     C     UBRTE         ORNE      FRUBRTE                                                    194487
     C     URTSP         ORNE      FRURTSP                                                    194487
     C     UNICD         ORNE      FRUNICD                                                    194487
     C     UNIPD         ORNE      FRUNIPD                                                    194487
     C     UICFR         ORNE      FRUICFR                                                    194487
     C     UICFD         ORNE      FRUICFD                                                    194487
     C     UIPFR         ORNE      FRUIPFR                                                    194487
     C     UIPFD         ORNE      FRUIPFD                                                    194487
     C     TSTRT         ORNE      FRTSTRT                                                    194487
     C     TEINR         ORNE      FRTEINR                                                    194487
     C     TBRTE         ORNE      FRTBRTE                                                    194487
     C     TRTSP         ORNE      FRTRTSP                                                    194487
     C     TNICD         ORNE      FRTNICD                                                    194487
     C     TNIPD         ORNE      FRTNIPD                                                    194487
     C     TICFR         ORNE      FRTICFR                                                    194487
     C     TICFD         ORNE      FRTICFD                                                    194487
     C     TIPFR         ORNE      FRTIPFR                                                    194487
     C     TIPFD         ORNE      FRTIPFD                                                    194487
      *                                                                                      BUG6877
      ** if Reference Rate has changed                                                       BUG6877
      *                                                                                      BUG6877
     C     UBRTT         ORNE      FRUBRTT                                                   BUG6877
     C     TBRTT         ORNE      FRTBRTT                                                   BUG6877
     C     UFRFD         ORNE      FRUFRFD                                                    220437
     C     TFRFD         ORNE      FRTFRFD                                                    220437
      *                                                                                       220437
      ** If currency for rate fixing convention has been changed                              220437
      *                                                                                       220437
     C     L1CYR1        ORNE      FRCYR1                                                     220437
     C     L1CYR2        ORNE      FRCYR2                                                     220437
     C     L1CYR3        ORNE      FRCYR3                                                     220437
     C     L1CYR4        ORNE      FRCYR4                                                     220437
     C     L1CYR5        ORNE      FRCYR5                                                     220437
     C     L1CYR6        ORNE      FRCYR6                                                     220437
     C     L1CYR7        ORNE      FRCYR7                                                     220437
     C     L1CYR8        ORNE      FRCYR8                                                     220437
     C     L1CYR9        ORNE      FRCYR9                                                     220437
     C     L1CYR0        ORNE      FRCYR0                                                     220437
      *
      ** Produce a confirmation now
      *
     C*****              BITOFF    '0'           CNFI                           CSW097
     C                   BITOFF    '0'           FRCNFI                         CSW097
     C                   MOVE      'Y'           @@CNRQ
      *
      * Set off maturity and interest indicators if past value date
      *
     C     ORED          IFLT      BJRDNB
     C     VDAT          ANDLT     BJRDNB
     C*****              BITOFF    '12'          CNFI                           CSW097
     C                   BITOFF    '12'          FRCNFI                         CSW097
     C                   ENDIF
      *
     C                   END
      *                                                                                      BUG6877
     C     CIR008        IFEQ      'Y'                                                       BUG6877
     C     FIAUTH        ANDNE     'Y'                                                       BUG6877
     C     BQFIRA        ANDEQ     'Y'                                                        239742
     C                   BITOFF    '0'           FRCNFI                                      BUG6877
     C                   BITOFF    '0'           CNFI                                        BUG6877
     C                   MOVE      'Y'           @@CNRQ                                      BUG6877
     C                   ENDIF                                                               BUG6877
      *                                                                                      BUG6877
     C                   END
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* CNFDEL - SET CONFIRMATION INDICATOR ON DELETION              *
     C*                                                              *
     C****************************************************************
     C     CNFDEL        BEGSR
      *
     C                   MOVE      'N'           @@CNRQ                                       194487
      *                                                                                       194487
      * CONFIRMATION REQUIRED IF ONE PRODUCED PREVIOUSLY
      *
     C                   TESTB     '7'           CNFI                     99
     C     *IN99         IFEQ      '1'
     C                   BITOFF    '0'           CNFI
     C                   MOVE      'Y'           @@CNRQ
     C                   END
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* WRTDTX - WRITE A DTRIX RECORD                                *
     C*                                                              *
     C****************************************************************
     C     WRTDTX        BEGSR
      *
      **  SET FIELDS ON RECORD TO BE WRITTEN TO DTRIXDD
      *
     C                   MOVE      'D'           DXRECI
     C                   MOVE      'D'           DXRCDT
     C                   Z-ADD     FRDLNO        DXDLNO
     C                   Z-ADD     *ZERO         DXVDAT
     C                   Z-ADD     *ZERO         DXDASN
     C                   MOVE      FRCHTP        DXCHTP
     C                   MOVE      @@CNRQ        DXCNRQ
     C                   MOVE      'N'           DXCNPR
     C                   MOVE      ' '           DXREPR
     C                   TIME                    @XTIME
     C                   MOVE      @@PRI1        DXPRI1
     C                   MOVE      @@PRI2        DXPRI2
     C                   MOVE      @@PRI3        DXPRI3
     C                   Z-ADD     0             DXICIN
     C                   MOVEL     FRBRCA        DXBRCA
     C                   Z-ADD     *ZERO         DXTNLU
     C*
     C                   WRITE     DTRIXDF
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* UPDDTH - UPDATE THE DTRIX HEADER RECORD                      *
     C*                                                              *
     C****************************************************************
     C     UPDDTH        BEGSR
      *
      ** Access the header record
      *
     C                   Z-ADD     *ZERO         DXDLNO
     C     DXDLNO        CHAIN     DTRIXHF                            99
      *
      ** DATABASE ERROR
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     DXDLNO        DBKEY
     C                   MOVEL     'DTRIXHF '    DBFILE                         ************
     C                   MOVEL     '004'         DBASE                          * DBERR 004*
     C                   EXSR      SRERR                                        ************
     C                   END
      *
      * Add 1 to number of deal records (on DTRIXDD)
      *
     C                   ADD       1             DXNDLR
      *
     C                   UPDATE    DTRIXHF
     C*
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* UPDTRL- UPDATE THE DEALS FILE TRAILER                        *
     C*                                                              *
     C****************************************************************
     C     UPDTRL        BEGSR
      *
     C                   MOVE      *BLANKS       EAPIC            10                        MD025244
      *                                                                                     MD025244
     C                   CALLB     'ZADLTRLRUD'
      *
      ** Return Code
     C                   PARM      *BLANKS       @@RTCD            7
      *
      ** Change Type
     C                   PARM      FRCHTP        @@CHTP            1
      *
      ** Amount
     C                   PARM      FRUPAMT       @@AMNP           15 0
      *
      ** Run Date
     C                   PARM                    BJRDNB            5 0
     C                   PARM                    EAPIC                                      MD025244
      *
      ** DATABASE ERROR
      *
     C     @@RTCD        IFEQ      '*ERROR '
     C                   MOVEL     '999999'      DBKEY
     C                   MOVEL     'DEALSDF '    DBFILE                         ************
     C                   MOVEL     '005'         DBASE                          * DBERR 005*
     C                   EXSR      SRERR                                        ************
     C                   END
      *
     C                   ENDSR
     C****************************************************************
      /EJECT                                                                    CDE001
     C****************************************************************          CDE001
     C*                                                              *          CDE001
     C* UPDOLP- UPDATE THE ON-LINE POSITION FILES                    *          CDE001
     C*                                                              *          CDE001
     C****************************************************************          CDE001
     C     UPDOLP        BEGSR                                                  CDE001
                                                                                             BUG8094
      ** U/TRFIN can be one of the following:                                                BUG8094
      ** "P" = rate fixed in input cycle, processing pending (DL4030)                        BUG8094
      ** "F" = rate has been fixed this input cycle (DL1924)                                 BUG8094
      ** "R" = rate refixed in input cycle, processing pending (DL4030)                      BUG8094
      ** "X" = rate fixed on previous day (DL0280)                                           BUG8094
                                                                                             BUG8094
     C     FRCHTP        IFEQ      'R'                                                       BUG8094
                                                                                             BUG8094
     C     FRBYSL        IFEQ      'S'                                                       BUG8094
     C     FRURFIN       ANDNE     ' '                                                       BUG8094
     C     FRURFIN       ANDNE     'P'                                                       BUG8094
     C     FRBYSL        OREQ      'B'                                                       BUG8094
     C     FRTRFIN       ANDNE     ' '                                                       BUG8094
     C     FRTRFIN       ANDNE     'P'                                                       BUG8094
                                                                                             BUG8094
     C                   CALL      'AOOUFRU0'                                                BUG8094
     C                   PARM      *BLANK        @RTCD                                       BUG8094
     C                   PARM                    Z#BSTS                                      BUG8094
     C                   PARM                    Z#ASTS                                      BUG8094
     C                   PARM                    Z#BAMT           13 0                       BUG8094
     C                   PARM                    Z#AAMT           13 0                       BUG8094
                                                                                             BUG8094
     C     @RTCD         IFEQ      '*ERROR'                                                  BUG8094
     C                   MOVEL     'AOOUFRU0'    DBFILE                                      BUG8094
     C                   MOVEL     '991'         DBASE                                       BUG8094
     C                   MOVEL     *BLANK        DBKEY                                       BUG8094
     C                   EXSR      *PSSR                                                     BUG8094
     C                   ENDIF                                                               BUG8094
                                                                                             BUG8094
     C                   ENDIF                                                               BUG8094
     C                   ENDIF                                                               BUG8094
      *                                                                         CDE001
      ** Data export for CCRM - Limits                                          CDE001
     C                   IF        CDE001 = 'Y'                                 CDE001
     C                   MOVEL     FRDLNO        T#TREF                         CDE001
     C                   CALLB     'DEWRTTRIG'                                  CDE001
     C                   PARM                    T#TREF           20            CDE001
     C                   PARM      'FRAS'        T#TCAT            4            CDE001
     C                   PARM                    T#RSRV           10                          222373
     C                   ENDIF                                                  CDE001
      *                                                                         CDE001
     C                   ENDSR                                                  CDE001
     C****************************************************************          CDE001
      /EJECT
     C****************************************************************
     C*                                                              *
     C* ACSBOK - ACCESS BOOK DETAILS                                 *
     C*                                                              *
     C****************************************************************
     C     ACSBOK        BEGSR
      *
      ** Access book record to pick up Hedge indicator
      *
     C                   CALLB     'AOBOOKR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      FRBOKC        @BOKC             2                           S0119
     C     SDBOOK        PARM      SDBOOK        DSFDY
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @DSNB         DBKEY
     C                   MOVEL     'SDBOOKPD'    DBFILE                         ************
     C                   MOVEL     '006'         DBASE                          * DBERR 006*
     C                   EXSR      SRERR                                        ************
     C                   END
     C*
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* ACSBRN - ACCESS BRANCH DETAILS                               *
     C*                                                              *
     C****************************************************************
     C     ACSBRN        BEGSR
      *
      ** Access branch record to pick up branch internal
      ** customer number.
      *
     C**********         CALLB     'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      FRBRCA        @DSNB             3
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @DSNB         DBKEY
     C                   MOVEL     'SDBRCHPD'    DBFILE                         ************
     C                   MOVEL     '006'         DBASE                          * DBERR 006*
     C                   EXSR      SRERR                                        ************
     C                   END
     C*
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* ACSDCY - ACCESS DEAL CURRENCY DETAILS                        *
     C*                                                              *
     C****************************************************************
     C     ACSDCY        BEGSR
      *
      ** Access currency details using deal currency.
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      FRUCUCY       @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @AJCD         DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE                         ************
     C                   MOVEL     '008'         DBASE                          * DBERR 008*
     C                   EXSR      SRERR                                        ************
     C                   END
     C                   ENDSR
     C****************************************************************
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
      *
      **  PROGRAM PARAMETERS
      *
     C     *ENTRY        PLIST
     C                   PARM                    @@RTCD            7
     C                   PARM                    PModeOfOp                                    CAP056
     C                   PARM                    IRVFRA
     C                   PARM                    CIR008                                       CIR008
     C                   PARM                    CAP056                                       CAP056
                                                                                              CAP056
     C     *LIKE         DEFINE    BQFIRA        WkFIRA                                       CAP056
     C     *LIKE         DEFINE    BQFIAU        WkFIAU                                       CAP056
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG    '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   MOVEL     '900'         DBASE                          * DBERR 900 *
     C                   EXSR      SRERR                                        *************
     C                   END
      *
      ** ACCESS TRADING DETAILS
      *
     C                   CALLB     'AOTRADR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDTRAD        PARM      SDTRAD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDTRADPD'    DBFILE                         *************
     C                   MOVEL     '901'         DBASE                          * DBERR 901 *
     C                   EXSR      SRERR                                        *************
     C                   END
      *                                                                                       200400
      ** Access Retail details                                                                200400
      *                                                                                       200400
     C                   CALLB     'AORETLR0'                                                 200400
     C                   PARM      *BLANK        @RTCD                                        200400
     C                   PARM      '*FIRST '     @OPTN                                        200400
     C     SDRETL        PARM      SDRETL        DSFDY                                        200400
                                                                                              CIR008
      ** Call Access Program for FRA/IRS I.C.D. details                                       CIR008
                                                                                              CIR008
     C                   CALLB     'AOFAISR0'                                                 CIR008
     C                   PARM      '*DBERR '     @RTCD                                        CIR008
     C                   PARM      '*FIRST '     @OPTN                                        CIR008
     C     SDFAIS        PARM      SDFAIS        DSFDY                                        CIR008
                                                                                              CAP056
      ** Store the original value of the flags to a work variable                             CAP056
                                                                                              CAP056
     C                   EVAL      WkFIRA = BQFIRA                                            CAP056
     C                   EVAL      WkFIAU = BQFIAU                                            CAP056
      *                                                                         CIR005
      ** Access SAR details file to determine if Bus. Day Convention is on.     CIR005
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
     C                   Z-ADD     902           DBASE                          CIR005
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
      *                                                                         CDE001
      ** Determine if Data Export for CCRM Limits is active                     CDE001
     C                   CALL      'AOSARDR0'                                   CDE001
     C                   PARM      *BLANKS       @RTCD                          CDE001
     C                   PARM      '*VERIFY'     @OPTN                          CDE001
     C                   PARM      'CDE001'      @SARD             6            CDE001
      *                                                                         CDE001
     C     @RTCD         IFEQ      *BLANK                                       CDE001
     C                   MOVEL     'Y'           CDE001            1            CDE001
     C                   ENDIF                                                  CDE001
                                                                                              CSC011
      ** Check if CSC011 is installed                                                         CSC011
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
     C**********         IN        SDSTAT                                              CSC011 CSD015
     C                   ELSE                                                                 CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
                                                                                              CSC011
     C                   IF        PRtCd <> '*NRF'                                            CSC011
     C     *LOCK         IN        LDA                                                        CSC011
     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBASE = 903                                                CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      SRERR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CIR011
      ** Access SAR details file to determine if Rate Fix Day Adjustment is on                CIR011
                                                                                              CIR011
     C                   CALL      'AOSARDR0'                                                 CIR011
     C                   PARM      *BLANKS       @RTCD                                        CIR011
     C                   PARM      '*VERIFY'     @OPTN                                        CIR011
     C                   PARM      'CIR011'      @SARD                                        CIR011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CIR011
                                                                                              CIR011
     C     @RTCD         IFNE      *BLANKS                                                    CIR011
     C     @RTCD         ANDNE     '*NRF   '                                                  CIR011
     C     *LOCK         IN        LDA                                                        CIR011
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CIR011
     C                   Z-ADD     904           DBASE                                        CIR011
     C                   MOVEL     'CIR011'      DBKEY                                        CIR011
     C                   OUT       LDA                                                        CIR011
     C                   EXSR      *PSSR                                                      CIR011
     C                   ENDIF                                                                CIR011
                                                                                              CIR011
     C     @RTCD         IFEQ      *BLANKS                                                    CIR011
     C                   MOVEL     'Y'           CIR011                                       CIR011
     C                   ELSE                                                                 CIR011
     C                   MOVEL     'N'           CIR011                                       CIR011
     C                   ENDIF                                                                CIR011
                                                                                              CAS006
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
     C                   Z-ADD     904           DBASE                                        CAS006
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
     C/COPY WNCPYSRC,IRFRADC011
                                                                                              CSD015
     C                   IN        SDSTAT                                                     CSD015
     C                   EVAL      CSD015 = 'N'                                               CSD015
                                                                                              CSD015
     C                   CALLB     'AOSARDR0'                                                 CSD015
     C                   PARM      *BLANKS       PRetCode                                     CSD015
     C                   PARM      '*VERIFY'     POption                                      CSD015
     C                   PARM      'CSD015'      PSard                                        CSD015
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD015
                                                                                              CSD015
      ** Database error                                                                       CSD015
                                                                                              CSD015
     C                   IF        (PRetCode <> *BLANKS) and                                  CSD015
     C                             (PRetCode <> '*NRF   ')                                    CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKEY = 'CSD015'                                           CSD015
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD015
     C                   EVAL      DBASE = 904                                                CSD015
     C                   OUT       LDA                                                        CSD015
     C                   EXSR      *PSSR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        PRetCode = *BLANKS                                         CSD015
     C                   EVAL      CSD015 = 'Y'                                               CSD015
                                                                                              CSD015
     C                   CALL      'AOCWCDR0'                                                 CSD015
     C                   PARM      *BLANKS       PRetCode                                     CSD015
     C                   PARM      '*FIRST'      POption                                      CSD015
     C     SDCWCD        PARM      SDCWCD        DSSDY                                        CSD015
                                                                                              CSD015
     C                   IF        PRetCode <> *BLANKS                                        CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKEY = POption                                            CSD015
     C                   EVAL      DBFILE = 'SDCWCDPD'                                        CSD015
     C                   EVAL      DBASE = 907                                                CSD015
     C                   OUT       LDA                                                        CSD015
     C                   EXSR      *PSSR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Access Compliance Watch Transaction details                                          CSD015
                                                                                              CSD015
     C                   CALL      'AOWLCCR0'                                                 CSD015
     C                   PARM      *BLANKS       PRetCode                                     CSD015
     C                   PARM      '*KEY    '    POption                                      CSD015
     C                   PARM      'DEALING '    PFunc                                        CSD015
     C     SDWLCC        PARM      SDWLCC        DSFDY                                        CSD015
                                                                                              CSD015
      ** Database Error                                                                       CSD015
                                                                                              CSD015
     C                   IF        PRetCode <> *BLANKS                                        CSD015
     C                             AND PRetCode <> '*NRF'                                     CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKEY = PFunc                                              CSD015
     C                   EVAL      DBFILE = 'SDWLCCPD'                                        CSD015
     C                   EVAL      DBASE = 905                                                CSD015
     C                   OUT       LDA                                                        CSD015
     C                   EXSR      *PSSR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   EVAL      CCF001 = 'N'                                               CSD015
                                                                                              CSD015
     C                   CALLB     'AOSARDR0'                                                 CSD015
     C                   PARM      *BLANKS       PRetCode                                     CSD015
     C                   PARM      '*VERIFY'     POption                                      CSD015
     C                   PARM      'CCF001'      PSard                                        CSD015
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD015
                                                                                              CSD015
      ** Database error                                                                       CSD015
                                                                                              CSD015
     C                   IF        (PRetCode <> *BLANKS) and                                  CSD015
     C                             (PRetCode <> '*NRF   ')                                    CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKEY = 'CCF001'                                           CSD015
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD015
     C                   EVAL      DBASE = 908                                                CSD015
     C                   OUT       LDA                                                        CSD015
     C                   EXSR      *PSSR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        PRetCode = *BLANKS                                         CSD015
     C                   EVAL      CCF001 = 'Y'                                               CSD015
     C                   EndIf                                                                CSD015
                                                                                            BUG18701
     C                   EVAL      CAP051 = 'N'                                             BUG18701
                                                                                            BUG18701
     C                   CALLB     'AOSARDR0'                                               BUG18701
     C                   PARM      *BLANKS       PRetCode                                   BUG18701
     C                   PARM      '*VERIFY'     POption                                    BUG18701
     C                   PARM      'CAP051'      PSard                                      BUG18701
     C     SCSARD        PARM      SCSARD        DSFDY                                      BUG18701
                                                                                            BUG18701
      ** Database error                                                                     BUG18701
                                                                                            BUG18701
     C                   IF        (PRetCode <> *BLANKS) and                                BUG18701
     C                             (PRetCode <> '*NRF   ')                                  BUG18701
     C     *LOCK         IN        LDA                                                      BUG18701
     C                   EVAL      DBKEY = 'CAP051'                                         BUG18701
     C                   EVAL      DBFILE = 'SCSARDPD'                                      BUG18701
     C                   EVAL      DBASE = 909                                              BUG18701
     C                   OUT       LDA                                                      BUG18701
     C                   EXSR      *PSSR                                                    BUG18701
     C                   ENDIF                                                              BUG18701
                                                                                            BUG18701
     C                   IF        PRetCode = *BLANKS                                       BUG18701
     C                   EVAL      CAP051 = 'Y'                                             BUG18701
     C                   EndIf                                                              BUG18701
                                                                                              CSD083
      ** Check if Watch List Element (CSD083) is on                                           CSD083
                                                                                              CSD083
     C                   CALLB     'AOSARDR0'                                                 CSD083
     C                   PARM      *BLANKS       PRetCode                                     CSD083
     C                   PARM      '*VERIFY'     POption                                      CSD083
     C                   PARM      'CSD083'      PSard                                        CSD083
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD083
                                                                                              CSD083
      ** Database error                                                                       CSD083
                                                                                              CSD083
     C                   IF        (PRetCode <> *BLANKS) AND                                  CSD083
     C                             (PRetCode <> '*NRF   ')                                    CSD083
     C     *LOCK         IN        LDA                                                        CSD083
     C                   EVAL      DBKEY = 'CSD083'                                           CSD083
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD083
     C                   EVAL      DBASE = 910                                                CSD083
     C                   OUT       LDA                                                        CSD083
     C                   EXSR      *PSSR                                                      CSD083
     C                   ENDIF                                                                CSD083
                                                                                              CSD083
     C                   IF        PRetCode = *BLANKS                                         CSD083
     C                   EVAL      CSD015 = 'N'                                               CSD083
     C                   ENDIF                                                                CSD083
                                                                                              CAP084
      * If the user is connected via a browser, the job user name is the data                 CAP084
      * source conection name - the actual user name is stored in ZMUSER                      CAP084
     C**********         IN        ZMUSER                                             CAP084 BUG8550
                                                                                              CSD015
     C     KCwFld        KLIST                                                                CSD015
     C                   KFLD                    WFuncType                                    CSD015
     C                   KFLD                    WIdntifier                                   CSD015
     C                   KFLD                    WBranch                                      CSD015
     C*
     C                   ENDSR
     C****************************************************************
      /EJECT
      *****************************************************************                       CSD015
      *                                                               *                       CSD015
      * SRWatch - Initiates the Midas Compliance Engine.              *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
     C     SRWatch       BEGSR                                                                CSD015
                                                                                              CSD015
      ** Initialise the Transaction Details parameter.                                        CSD015
                                                                                              CSD015
     C                   CLEAR                   SDWLTD                                       CSD015
                                                                                              CSD015
      ** Setup First Parameter                                                                CSD015
                                                                                              CSD015
     C                   EVAL      W4ITEM = 'IRFR'                                            CSD015
                                                                                              CSD015
     C                   MOVEL     DLNO          W4IDEN                                       CSD015
     C                   MOVEL     BRCA          W4BRCH                                       CSD015
                                                                                              CSD015
     C                   IF        CSC011 = 'Y'                                               CSD015
     C                   EVAL      W4SYSM = S1MAIN                                            CSD015
     C                   ELSE                                                                 CSD015
     C                   EVAL      W4SYSM = LIBR                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   EVAL      W4FUNT = 'DEALSDG'                                         CSD015
                                                                                              CSD015
     C                   MOVEL     CNUM          PCUST                                        CSD015
     C                   CALLB     'AOCUSTR0'                                                 CSD015
     C                   PARM      *BLANKS       PRTCD                                        CSD015
     C                   PARM      '*KEY'        POPTN                                        CSD015
     C                   PARM                    PCUST                                        CSD015
     C                   PARM      *BLANKS       PSTKEY                                       CSD015
     C     SDCUST        PARM      SDCUST        DSSDY                                        CSD015
                                                                                              CSD015
     C                   IF        PRetCode <> *BLANKS                                        CSD015
     C                             AND PRetCode <> '*NRF'                                     CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKEY = POption                                            CSD015
     C                   EVAL      DBFILE = 'SDCUSTPD'                                        CSD015
     C                   EVAL      DBASE = 906                                                CSD015
     C                   OUT       LDA                                                        CSD015
     C                   EXSR      *PSSR                                                      CSD015
     C                   END                                                                  CSD015
                                                                                              CSD015
     C                   MOVE      BBCUST        W4CNUM                                       CSD015
                                                                                              CSD015
      ** Determine Counterparty Type                                                          CSD015
                                                                                              CSD015
     C                   IF        CCF001 = 'Y'                                               CSD015
     C                   IF        BBCRPC = 'Y'                                               CSD015
     C                   EVAL      W4CTYP = 'C'                                               CSD015
     C                   ELSE                                                                 CSD015
     C                   EVAL      W4CTYP = 'I'                                               CSD015
     C                   ENDIF                                                                CSD015
     C                   ELSE                                                                 CSD015
     C                   IF        BBLICD <> *BLANKS                                          CSD015
     C                             AND BBLICD <> W1IND1                                       CSD015
     C                             AND BBLICD <> W1IND2                                       CSD015
     C                             AND BBLICD <> W1IND3                                       CSD015
     C                             AND BBLICD <> W1IND4                                       CSD015
     C                             AND BBLICD <> W1IND5                                       CSD015
     C                   EVAL      W4CTYP = 'C'                                               CSD015
     C                   ELSE                                                                 CSD015
     C                   EVAL      W4CTYP = 'I'                                               CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   EVAL      W4CUST = BBCRNM + BBCRTN                                   CSD015
                                                                                              CSD015
     C                   MOVE      DDAT          PDate                                        CSD015
     C                   CALLB     'ZACVTDATE'                                                CSD015
     C                   PARM                    PRetCode                                     CSD015
     C                   PARM                    PDate                                        CSD015
     C                   PARM                    ConvertedDate                                CSD015
     C                   PARM                    PDummy10                                     CSD015
                                                                                              CSD015
     C                   EVAL      W4DDAT = ConvertedDate                                     CSD015
                                                                                              CSD015
     C                   MOVE      VDAT          PDate                                        CSD015
     C                   CALLB     'ZACVTDATE'                                                CSD015
     C                   PARM                    PRetCode                                     CSD015
     C                   PARM                    PDate                                        CSD015
     C                   PARM                    ConvertedDate                                CSD015
     C                   PARM                    PDummy10                                     CSD015
                                                                                              CSD015
     C                   EVAL      W4VDAT = ConvertedDate                                     CSD015
                                                                                              CSD015
     C                   MOVE      MDAT          PDate                                        CSD015
     C                   CALLB     'ZACVTDATE'                                                CSD015
     C                   PARM                    PRetCode                                     CSD015
     C                   PARM                    PDate                                        CSD015
     C                   PARM                    ConvertedDate                                CSD015
     C                   PARM                    PDummy10                                     CSD015
                                                                                              CSD015
     C                   EVAL      W4MDAT = ConvertedDate                                     CSD015
                                                                                              CSD015
     C                   EVAL      W4DEN1 = UCUCY                                             CSD015
                                                                                              CSD015
     C                   MOVE      UPAMT         PAMT                                         CSD015
     C                   CALLB     'ZACVTAMT'                                                 CSD015
     C                   PARM                    PRetCode                                     CSD015
     C                   PARM                    UCUCY                                        CSD015
     C                   PARM                    PAMT                                         CSD015
     C                   PARM                    ConvertedAmt                                 CSD015
     C                   PARM                    PDummy16                                     CSD015
                                                                                              CSD015
     C                   EVAL      W4AMT1 = ConvertedAmt                                      CSD015
                                                                                              CSD015
      ** Build the free format string.                                                        CSD015
                                                                                              CSD015
     C                   EVAL      Ctr = 1                                                    CSD015
     C                   EVAL      PFreeFmtStr = *BLANKS                                      CSD015
     C                   EVAL      WXMLPacket = *BLANKS                                       CSD015
     C                   EVAL      WData = *BLANKS                                            CSD015
                                                                                              CSD015
     C                   DOU       Ctr > Elements                                             CSD015
                                                                                              CSD015
     C                   IF        WLF(Ctr) <> *BLANKS                                        CSD015
     C                             AND WLF(Ctr) <> '000000'                                   CSD015
                                                                                              CSD015
     C                   IF        PSCY <> *BLANKS                                            CSD015
     C                   EVAL      PFmtCCY = PSCY                                             CSD015
     C                   ELSE                                                                 CSD015
     C                   EVAL      PFmtCCY = UCUCY                                            CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   CALL      'SDCWLFMT'                                                 CSD015
     C                   PARM                    PRetCode                                     CSD015
     C                   PARM                    WLF(Ctr)                                     CSD015
     C                   PARM                    PDummy35                                     CSD015
     C                   PARM                    PDummy35                                     CSD015
     C                   PARM                    PDummy35                                     CSD015
     C                   PARM                    PDummy35                                     CSD015
     C                   PARM                    PDummy35                                     CSD015
     C                   PARM                    PFmtCCY                                      CSD015
     C                   PARM                    WData                                        CSD015
     C                   PARM                    PDummy6                                      CSD015
                                                                                              CSD015
     C                   CAT       XOT(Ctr):0    WXMLPacket                                   CSD015
     C                   CAT       WData:0       WXMLPacket                                   CSD015
                                                                                              CSD015
      ** Add Account Lines                                                                    CSD015
                                                                                              CSD015
     C                   IF        Ctr = 3                                                    CSD015
     C                   CAT       RIBA:1        WXMLPacket                                   CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        Ctr = 8                                                    CSD015
     C                   CAT       RCRA:1        WXMLPacket                                   CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        Ctr = 9                                                    CSD015
     C                   CAT       PIBA:1        WXMLPacket                                   CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        Ctr = 11                                                   CSD015
     C                   CAT       AWBA:1        WXMLPacket                                   CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        Ctr = 12                                                   CSD015
     C                   CAT       BENA:1        WXMLPacket                                   CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   CAT       XCT(Ctr):0    WXMLPacket                                   CSD015
     C                   CAT       WXMLPacket:0  PFreeFmtStr                                  CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   EVAL      WXMLPacket = *BLANKS                                       CSD015
     C                   EVAL      WData = *BLANKS                                            CSD015
                                                                                              CSD015
     C                   EVAL      Ctr = Ctr + 1                                              CSD015
     C                   ENDDO                                                                CSD015
                                                                                              CSD015
      ** Add the Payment Details.                                                             CSD015
                                                                                              CSD015
     C                   IF        DTP1 <> *BLANKS OR DTP2 <> *BLANKS                         CSD015
     C                             OR DTP3 <> *BLANKS OR DTP4 <> *BLANKS                      CSD015
                                                                                              CSD015
     C                   EVAL      Ctr = Ctr + 1                                              CSD015
     C                   CAT       XOT(Ctr):0    WXMLPacket                                   CSD015
     C                   CAT       DTP1:0        WXMLPacket                                   CSD015
     C                   CAT       DTP2:1        WXMLPacket                                   CSD015
     C                   CAT       DTP3:1        WXMLPacket                                   CSD015
     C                   CAT       DTP4:1        WXMLPacket                                   CSD015
     C                   CAT       XCT(Ctr):0    WXMLPacket                                   CSD015
     C                   CAT       WXMLPacket:0  PFreeFmtStr                                  CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Check for compliance.                                                                CSD015
                                                                                              CSD015
     C                   CALL      'SDCWLCHK'                                                 CSD015
     C                   PARM                    SDWLTD                                       CSD015
     C                   PARM                    PFreeFmtStr                                  CSD015
                                                                                              CSD015
     C                   ENDSR                                                                CSD015
      ****************************************************************                        CSD015
      /EJECT                                                                                  CSD015
     C****************************************************************
     C*                                                              *
     C* SRERR - EXCEPTION ERRORS                                     *
     C*                                                              *
     C****************************************************************
     C     SRERR         BEGSR
     C*
     C                   MOVEL     '*ERROR '     @@RTCD
     C                   MOVEL     'IRFRAUPD'    DBPGM            10
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   DUMP
     C*
     C**  TERMINATE THE PROGRAM
     C*
     C                   RETURN
     C*
     C                   ENDSR
     C****************************************************************
      /EJECT                                                                    CIR005
      *****************************************************************         CIR005
      ** Program, module and procedure names for database error processing.     CIR005
      ** =================================================================      CIR005
      ** The following /COPY sets these values, and also defines LDA as         CIR005
      ** an external data area                                                  CIR005
      ********************************************************************      CIR005
      /COPY ZACPYSRC,PSSR_ILE                                                   CIR005
**  CPY@
(c) Finastra International Limited 2001
** CTDATA XOT - XML Opening Tags for the Compliance Engine.                                   CSD015
<Receipt Our Nostro>                                                                          CSD015
<Receipt Ord Customer>                                                                        CSD015
<Receipt Int Bank>                                                                            CSD015
<Receipt Ord Bank>                                                                            CSD015
<Payment Our Nostro>                                                                          CSD015
<Payment Ord Customer>                                                                        CSD015
<Payment Reciever>                                                                            CSD015
<Payment R Corespondent>                                                                      CSD015
<Payment Int Bank>                                                                            CSD015
<Payment Ord Bank>                                                                            CSD015
<Payment A/C with Bank>                                                                       CSD015
<Payment Beneficiary>                                                                         CSD015
<Payment Details of Pay>                                                                      CSD015
** CTDATA XCT - XML Closing Tags for the Compliance Engine.                                   CSD015
</Receipt Our Nostro>                                                                         CSD015
</Receipt Ord Customer>                                                                       CSD015
</Receipt Int Bank>                                                                           CSD015
</Receipt Ord Bank>                                                                           CSD015
</Payment Our Nostro>                                                                         CSD015
</Payment Ord Customer>                                                                       CSD015
</Payment Reciever>                                                                           CSD015
</Payment R Corespondent>                                                                     CSD015
</Payment Int Bank>                                                                           CSD015
</Payment Ord Bank>                                                                           CSD015
</Payment A/C with Bank>                                                                      CSD015
</Payment Beneficiary>                                                                        CSD015
</Payment Details of Pay>                                                                     CSD015
