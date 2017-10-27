     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Watch List Bulk Data Checking module (DL)')   *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000015 - Watch List Bulk Data Checking Component for       *
      *             Dealing                                           *
      *                                                               *
      *  Function:  This module performs Compliance Checking on       *
      *             COB Processing.                                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. CDL099             Date 06Oct17               *
      *  Prev Amend No. CGL165             Date 15Feb17               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 AR702741           Date 02Feb11               *
      *                 CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 11May06               *
      *                 CDL038             Date 10May05               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 BUG5671            Date 01Feb05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CDL022             Date 03Feb04               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 CDL018             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL016             Date 03Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 CSD015  *CREATE    Date 14Oct02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  AR702741 - Include location as parameter in ZFREQB to        *
      *             determine the next settlement date                *
      *             (Child: AR702742)                                 *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG5671- Add Sequence number to detail record (Recompile)    *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CDL022 - Deal Amendment Changes (Recompile)                  *
      *  CDL020 - Apply Base Rate at Value Date (Recompile)           *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *           (Recompile)                                         *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *           (Recompile)                                         *
      *  CDL016 - Automatic rollover of Fixed Term Loans/Deposits     *
      *           (Recompile)                                         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      *
      ** Compliance Watch Hit List
      *
     FSDCWHTL1  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Watch List Checking Details by Function Code
      *
     FSDWLCCL0  UF   E           K DISK    INFSR(*PSSR)
      *
      ** Midas Deals Databases
      *
     FDEALSDB   IF   E             DISK    USROPN INFSR(*PSSR)
     FDEALSDG   IF   E             DISK    USROPN INFSR(*PSSR)
     FDLGXSTL0  IF   E           K DISK    USROPN INFSR(*PSSR)
     FFXCLSPSD  IF   E             DISK    USROPN INFSR(*PSSR)
     FMMDEAMLL  IF   E           K DISK    USROPN INFSR(*PSSR)
     FFXNETMPD  IF   E             DISK    USROPN INFSR(*PSSR)
     FFXDEALLL  IF   E           K DISK    USROPN INFSR(*PSSR)
     FMMDELDPP  IF   E             DISK    USROPN INFSR(*PSSR)
     FMMDENALL  IF   E           K DISK    USROPN INFSR(*PSSR)
     F                                     PREFIX(HX:2)
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structure. They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      *
      ** Max. no. of elements associated with the CE arrays
      *
     D ArrMax          C                   CONST(23)
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      *
      ** XML Opening Tags for the Compliance Engine
      *
     D XOT             S             25A   DIM(ArrMax) PERRCD(1) CTDATA
      *
      ** XML Closing Tags for the Compliance Engine
      *
     D XCT             S             25A   DIM(ArrMax) PERRCD(1) CTDATA
      *
      ** Working XML Opening Tags for the Compliance Engine
      *
     D WOT             S             25A   DIM(ArrMax)
      *
      ** Working XML Closing Tags for the Compliance Engine
      *
     D WCT             S             25A   DIM(ArrMax)
      *
      ** Watch List Fields Array
      *
     D WLF             S             35A   DIM(ArrMax)
      *
      ** Watch List Fields Standing Data Array
      *
     D WLFSD           S             35A   DIM(ArrMax)
      *
      ** Bank Details Data Structure
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Nostro Details Data Structure
      *
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
      *
      ** Switchable Feature Details Data Structure
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *
      ** Watch List Checking Details Data Structure
      *
     D SDWLCC        E DS                  EXTNAME(SDWLCCPD)
      *
      ** Watch List Transaction Details Data Structure (Formatted)
      *
     D SDWLTD        E DS                  EXTNAME(SDWLTDPD)
      *
      ** Watch List Transaction Details Data Structure (Unformatted)
      *
     D SDWLTO        E DS                  EXTNAME(SDWLTOPD)
     D                                     PREFIX(UF:2)
      *
      ** Compliance Watch Configuration Data DS
      *
     D SDCWCD        E DS                  EXTNAME(SDCWCDPD)
      *
      ** 24X7 Status Data Area
      *
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
      *
      ** SD Data Area
      *
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
      *
      ** Customer Details Data Structure
      *
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      ** General Ledger Data Structure
      *
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D  QQACD1       E                     EXTFLD(QQACCD)                                     CGL029
      *
      ** Short DS for Access Objects
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** Long DS for Access Objects
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** Extended Settlements Data Structure
      *
     D DLGXST          DS
     D  RcptDetails            1     20
     D  PayDetails            33     52
     D  OtherInfo             65    236
     D**RXRONS**               1     12                                                       CGL029
     D  QQRONS                 1     12                                                       CGL029
     D  RXRIBN                13     20
     D**RXROBN**              21     26  0                                                    CSD027
     D**RXROCN**              27     32  0                                                    CSD027
     D  RXROBN                21     26                                                       CSD027
     D  RXROCN                27     32                                                       CSD027
     D**RXPONS**              33     44                                                       CGL029
     D  QQPONS                33     44                                                       CGL029
     D  RXPIBN                45     52
     D**RXPOBN**              53     58  0                                                    CSD027
     D**RXPOCN**              59     64  0                                                    CSD027
     D  RXPOBN                53     58                                                       CSD027
     D  RXPOCN                59     64                                                       CSD027
     D  RXRCRN                65     72
     D  RXRVNO                73     80
     D  RXAWBN                81     88
     D  RXBENN                89     96
     D  RXDTP1                97    131
     D  RXDTP2               132    166
     D  RXDTP3               167    201
     D  RXDTP4               202    236
     D  RXRONS               237    254                                                       CGL029
     D  RXPONS               255    272                                                       CGL029
      *
      ** Working Date Data Structure
      *
     D WDATE           DS
     D  WLongYr                1      4  0
     D  WShortYr               3      4  0
     D  WMonth                 5      6  0
     D  WDay                   7      8  0
      *
      ** ZDATE Data Structure
      *
     D ZDATE           DS
     D  PZDate                 1      6  0
     D  PZDay                  1      2  0
     D  PZMonth                3      4  0
     D  PZYear                 5      6  0
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
 
      *
      ** Program Parameters
      *
     D PFuncCode       S              8
     D PLPCD           S              5  0
      *
      ** Switchable Feature Indicators
      *
     D CSC011          S              1A   INZ('N')
     D CCF001          S              1A   INZ('N')
     D CIR003          S              1A   INZ('N')
      *
      ** Compliance Engine Free Format String Parameter
      *
     D PFreeFmtStr     S          30000A
      *
      ** SDCWLFMT Parameters
      *
     D PInpA           S             35
     D PInpB           S             35
     D PInpC           S             35
     D PInpD           S             35
     D PInpE           S             35
     D POutA           S              6
      *
      ** ZDATE1 Parameters
      *
     D PZDateIn        S              6
     D PZDayNo         S              5  0
     D PZDateFmt       S              1
     D PZRtCd          S              1
      *
      ** ZACVTDATE Parameters
      *
     D PZADayNo        S              5
     D PZADDT          S               D
     D PZACvtDate      S             10
      *
      ** ZACVTAMT Parameters
      *
     D PZARtCd         S             10
     D PZACcy          S              3
     D PZANtvAmt       S             15
     D PZAAmt          S             18  3
     D PZACvtAmt       S             16
      *
      ** ZFREQB Parameters
      *
     D PZPFRQ          S              1
     D PZNPCD          S              5  0
     D PZLCCY          S              3
     D PZLOC           S              3                                                     AR702741
     D PZPDYN          S              2  0
     D PZDFIN          S              1
      *
      ** AOCUSTR0 Parameters
      *
     D PCustNo         S             10
     D PErrInf         S              7
      *
      ** AONOSTR0 Parameters
      *
     D PCUST           S              6
     D*PACCD****       S              4                                                       CGL029
     D PACCD           S             10                                                       CGL029
     D PACSN           S              2
     D PBRCD           S              3
     D PCSSN           S             10
     D PPNOI           S              1
     D PCcy            S              3
     D PNostCode       S              2
      *
      ** Compliance Watch Hit List Key Fields
      *
     D KFuncType       S              8
     D KIden           S             40
     D KBranch         S              3
      *
      ** Extended Settlement Details Key Fields
      *
     D KDLNO           S              6  0
     D KEDCD           S              3
      *
      ** Unformatted Fields Data Store
      *
     D UFDTP1          S             35
     D UFDTP2          S             35
     D UFDTP3          S             35
     D UFDTP4          S             35
     D UFRSCY          S              3
     D UFPSCY          S              3
      *
      ** Working Variables
      *
     D WHitFlg         S              1
     D WLimit          S              2  0
     D Ctr             S              2  0
     D WData           S            216
     D WXMLPacket      S            400
     D WOKFlg          S              1
     D WCtrpRpt        S             30
     D WCtrpTyp        S              1
     D WDDT            S               D
     D WAMT            S             18  3
     D WCcy            S              3
     D WVDAT           S              5
     D WSEQN           S              2
     D WDA38           S              6
     D WVDYY           S              4
     D WVDMM           S              2
     D WVDDD           S              2
     D WDS38           S              3
     D WIden           S             30
     D WItr            S              1  0
     D*WSum*****       S              8  0                                                    CSD027
     D WSum            S             24A                                                      CSD027
 
     D PRetCode        S              7A
     D PMsg            S            132A
     D PMsgId          S              7A
     D PMsgF           S             10A
     D PMsgQ           S             10A
     D PSrvContext     S               *
     D WDBASE          S              3  0
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +---------------- Start of Main Processing ------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
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
 
      *
      ** Begin Database Checks
      ** =====================
      *
      ** Foreign Exchange Details
      ** ------------------------
      *
     C                   OPEN      DEALSDB
      *
     C                   READ      DEALSDB
      *
     C                   DOW       NOT %EOF(DEALSDB)
      *
     C                   IF        RECI = 'D'
      *
     C                   EVAL      KFuncType = 'DEALSDB'
     C                   MOVEL     DLNO          KIden
     C                   EVAL      KBranch = BRCA
     C                   EXSR      SRHitChk
      *
     C                   IF        WHitFlg = 'N' AND W1LPCD < W1LUDT OR
     C                             WHitFlg = 'Y' AND W3LWCD < W1LUDT
     C                   EXSR      SRFXDChk
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   READ      DEALSDB
      *
     C                   ENDDO
      *
     C                   CLOSE     DEALSDB
      *
      ** Forward Rate Agreements and Interest Rate Swaps
      ** -----------------------------------------------
      *
     C                   OPEN      DEALSDG
      *
     C                   READ      DEALSDG
      *
     C                   DOW       NOT %EOF(DEALSDG)
      *
     C                   IF        RECI = 'D'
      *
     C                   EVAL      KFuncType = 'DEALSDG'
     C                   MOVEL     DLNO          KIden
     C                   EVAL      KBranch = BRCA
     C                   EXSR      SRHitChk
      *
     C                   IF        WHitFlg = 'N' AND W1LPCD < W1LUDT OR
     C                             WHitFlg = 'Y' AND W3LWCD < W1LUDT
     C                   EXSR      SRFXDChk
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   READ      DEALSDG
      *
     C                   ENDDO
      *
     C                   CLOSE     DEALSDG
      *
      ** CLS Pay Schedule Details
      ** ------------------------
      *
     C                   OPEN      FXCLSPSD
      *
     C                   READ      FXCLSPSD
      *
     C                   DOW       NOT %EOF(FXCLSPSD)
      *
     C                   IF        PYRECI = 'D'
      *
     C                   EVAL      PCcy = PYCCY
     C                   EVAL      PNostCode = PYNOST
     C                   EXSR      SRGetRealNst
      *
     C                   EVAL      KFuncType = 'FXCLSPSH'
     C                   MOVE      PYVDAT        WVDAT
     C                   MOVE      PYSEQN        WSEQN
     C                   CAT       PYCCY:0       KIden
     C                   CAT       PYNOST:0      KIden
     C                   CAT       WVDAT:0       KIden
     C                   CAT       WSEQN:0       KIden
     C                   EVAL      WIden = KIden
     C                   EVAL      KBranch = A7BRCD
     C                   EXSR      SRHitChk
      *
     C                   IF        WHitFlg = 'N' AND W1LPCD < W1LUDT OR
     C                             WHitFlg = 'Y' AND W3LWCD < W1LUDT
     C                   EXSR      SRCLSChk
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   READ      FXCLSPSD
      *
     C                   ENDDO
      *
     C                   CLOSE     FXCLSPSD
      *
      ** Deal Amendments Details
      ** -----------------------
      *
     C                   OPEN      MMDEAMLL
      *
     C                   READ      MMDEAMLL
      *
     C                   DOW       NOT %EOF(MMDEAMLL)
      *
     C                   IF        HNDSTS = 'C' OR
     C                             HNDSTS = 'A' OR
     C                             HNDSTS = 'R'
      *
     C                   EVAL      KFuncType = 'MMDEAMPP'
     C                   MOVEL     HNDA38        WDA38
     C                   MOVEL     HNVDYY        WVDYY
     C                   MOVEL     HNVDMM        WVDMM
     C                   MOVEL     HNVDDD        WVDDD
     C                   MOVEL     HNDS38        WDS38
     C                   CAT       WDA38:0       KIden
     C                   CAT       WVDYY:0       KIden
     C                   CAT       WVDMM:0       KIden
     C                   CAT       WVDDD:0       KIden
     C                   CAT       WDS38:0       KIden
     C                   EVAL      WIden = KIden
     C                   EVAL      KBranch = HNBRCA
     C                   EXSR      SRHitChk
      *
     C                   IF        WHitFlg = 'N' AND W1LPCD < W1LUDT OR
     C                             WHitFlg = 'Y' AND W3LWCD < W1LUDT
     C                   EXSR      SRDEAChk
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   READ      MMDEAMLL
      *
     C                   ENDDO
      *
     C                   CLOSE     MMDEAMLL
      *
      ** Confirmed Nets Details
      ** ----------------------
      *
     C                   OPEN      FXNETMPD
      *
     C                   READ      FXNETMPD
      *
     C                   DOW       NOT %EOF(FXNETMPD)
      *
     C                   IF        AMRECI = 'D'
      *
     C                   EVAL      KFuncType = 'FXNETMPD'
     C                   EVAL      KIden = AMNETR
     C                   EVAL      KBranch = AMBRCA
     C                   EXSR      SRHitChk
      *
     C                   IF        WHitFlg = 'N' AND W1LPCD < W1LUDT OR
     C                             WHitFlg = 'Y' AND W3LWCD < W1LUDT
     C                   EXSR      SRFXCChk
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   READ      FXNETMPD
      *
     C                   ENDDO
      *
     C                   CLOSE     FXNETMPD
      *
      ** Foreign Exchange Deal Details
      ** -----------------------------
      *
     C                   OPEN      FXDEALLL
      *
     C                   READ      FXDEALLL
      *
     C                   DOW       NOT %EOF(FXDEALLL)
      *
     C                   IF        FHDSTS = 'C' OR
     C                             FHDSTS = 'A' OR
     C                             FHDSTS = 'R'
      *
     C                   EVAL      KFuncType = 'FXDEALPP'
     C                   MOVEL     FHDN38        KIden
     C                   EVAL      KBranch = FHMBCA
     C                   EXSR      SRHitChk
      *
     C                   IF        WHitFlg = 'N' AND W1LPCD < W1LUDT OR
     C                             WHitFlg = 'Y' AND W3LWCD < W1LUDT
     C                   EXSR      SRFXDDChk
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   READ      FXDEALLL
      *
     C                   ENDDO
      *
     C                   CLOSE     FXDEALLL
      *
      ** Loans/Deposits/CD Issued Details
      ** --------------------------------
      *
     C                   OPEN      MMDELDPP
      *
     C                   READ      MMDELDPP
      *
     C                   DOW       NOT %EOF(MMDELDPP)
      *
     C                   IF        HKDSTS = 'C' OR
     C                             HKDSTS = 'A' OR
     C                             HKDSTS = 'R'
      *
     C                   EVAL      KFuncType = 'MMDELDPP'
     C                   MOVEL     HKDN38        KIden
     C                   EVAL      KBranch = HKBRCA
     C                   EXSR      SRHitChk
      *
     C                   IF        WHitFlg = 'N' AND W1LPCD < W1LUDT OR
     C                             WHitFlg = 'Y' AND W3LWCD < W1LUDT
     C                   EXSR      SRLDNChk
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   READ      MMDELDPP
      *
     C                   ENDDO
      *
     C                   CLOSE     MMDELDPP
      *
      ** Negotiable Assets Bought and Sold
      ** ---------------------------------
      *
     C                   OPEN      MMDENALL
      *
     C                   READ      MMDENALL
      *
     C                   DOW       NOT %EOF(MMDENALL)
      *
     C                   IF        HXDSTS = 'C' OR
     C                             HXDSTS = 'A' OR
     C                             HXDSTS = 'R'
      *
     C                   SELECT
     C                   WHEN      HXRBSI = 'B'
     C                   EVAL      KFuncType = 'MMDENBPP'
     C                   WHEN      HXRBSI = 'S'
     C                   EVAL      KFuncType = 'MMDENSPP'
     C                   ENDSL
      *
     C                   MOVEL     HXDN38        KIden
     C                   EVAL      KBranch = HXBRCA
     C                   EXSR      SRHitChk
      *
     C                   IF        WHitFlg = 'N' AND W1LPCD < W1LUDT OR
     C                             WHitFlg = 'Y' AND W3LWCD < W1LUDT
     C                   EXSR      SRNAPSChk
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   READ      MMDENALL
      *
     C                   ENDDO
      *
     C                   CLOSE     MMDENALL
      *
      ** End Database Checks
      ** ===================
      *
      ** Retrieve function code record from the WLC Details File.
      *
     C     PFuncCode     CHAIN     SDWLCCL0
      *
     C                   EVAL      W1LPCD = BJRDNB
      *
      ** Determine the next periodic check date.
      *
     C                   EVAL      PZNPCD = W1NPCD
     C                   EVAL      PZPDYN = W1PDYN
      *
     C                   CALLB     'ZFREQB'
     C                   PARM      *BLANKS       RetCodeIn
     C                   PARM      W1PFRQ        PZPFRQ
     C                   PARM                    PZNPCD
     C                   PARM      BJLCCY        PZLCCY
     C                   PARM      *BLANKS       PZLOC                                      AR702741
     C                   PARM                    PZPDYN
     C                   PARM      BJDFIN        PZDFIN
     C     SDGELR        PARM      SDGELR        DSFDY
      *
     C                   EVAL      W1NPCD = PZNPCD
      *
     C                   UPDATE    SDWLCCD0
 
      ** Close connection with the server
 
     C                   CALL      'SDOFACCL'
     C                   PARM      *BLANK        PRetCode
     C                   PARM                    PSrvContext
      *
     C                   EVAL      *INLR = True
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRFXDChk - Checks Foreign Exchange Deals for compliance.      *
      *                                                               *
      *****************************************************************
     C     SRFXDChk      BEGSR
      *
      ** Initialise the Unformatted Watch List Detail fields.
      *
     C                   CLEAR                   SDWLTO
     C                   EVAL      UFRSCY = *BLANKS
     C                   EVAL      UFPSCY = *BLANKS
     C                   EVAL      UFDTP1 = *BLANKS
     C                   EVAL      UFDTP2 = *BLANKS
     C                   EVAL      UFDTP3 = *BLANKS
     C                   EVAL      UFDTP4 = *BLANKS
      *
      ** FX Mode
      ** =======
      *
     C                   IF        %OPEN(DEALSDB)
     C                   MOVEL     'DLNT'        UFITEM
     C                   MOVEL     'DEALSDB'     UFFUNT
     C                   MOVEL     OTDT          UFMDAT
     C                   MOVEL     PUCY          UFDEN1
     C                   MOVEL     SLCY          UFDEN2
     C                   MOVEL     PUAM          UFAMT1
     C                   MOVEL     SLAM          UFAMT2
     C                   ENDIF
      *
      ** FRA/IRS Mode
      ** ============
      *
     C                   IF        %OPEN(DEALSDG)
     C                   CAT       'IR':0        UFITEM
     C                   CAT       DTYP:0        UFITEM
     C                   MOVEL     'DEALSDG'     UFFUNT
     C                   MOVEL     MDAT          UFMDAT
     C                   MOVEL     UCUCY         UFDEN1
     C                   MOVEL     TCUCY         UFDEN2
     C                   MOVEL     UPAMT         UFAMT1
     C                   MOVEL     TPAMT         UFAMT2
     C                   ENDIF
      *
     C                   MOVEL     DLNO          UFIDEN
     C                   MOVEL     BRCA          UFBRCH
     C                   MOVEL     CNUM          UFCNUM
     C                   MOVEL     DDAT          UFDDAT
     C                   MOVEL     VDAT          UFVDAT
      *
     C                   MOVEL     RSCY          UFRSCY
     C                   MOVEL     PSCY          UFPSCY
      *
     C                   MOVEL     DTP1          UFDTP1
     C                   MOVEL     DTP2          UFDTP2
     C                   MOVEL     DTP3          UFDTP3
     C                   MOVEL     DTP4          UFDTP4
      *
      ** Initialise the Opening and Closing XML Tags.
      *
     C                   MOVEA     *BLANKS       WOT
     C                   MOVEA     *BLANKS       WCT
     C                   EVAL      Ctr = 1
     C                   EVAL      WLimit = 13
      *
     C                   DOU       Ctr = WLimit
     C                   EVAL      WOT(Ctr) = XOT(Ctr)
     C                   EVAL      WCT(Ctr) = XCT(Ctr)
     C                   EVAL      Ctr = Ctr + 1
     C                   ENDDO
      *
      ** Move the relevant fields to the Watch List Fields array.
      *
     C                   MOVEA     *BLANKS       WLF
      *
     C                   MOVEL     RONS          WLF(1)
     C                   MOVEL     RIBN          WLF(2)
     C                   MOVEL     ROBN          WLF(3)
     C                   MOVEL     ROCN          WLF(4)
     C                   MOVEL     PONS          WLF(5)
     C                   MOVEL     PIBN          WLF(6)
     C                   MOVEL     POBN          WLF(7)
     C                   MOVEL     POCN          WLF(8)
     C                   MOVEL     RCRN          WLF(9)
     C                   MOVEL     RVNO          WLF(10)
     C                   MOVEL     AWBN          WLF(11)
     C                   MOVEL     BENN          WLF(12)
      *
      ** Initialise additional standing data.
      *
     C                   MOVEA     *BLANKS       WLFSD
      *
     C                   MOVEL     RIBA          WLFSD(2)
     C                   MOVEL     PIBA          WLFSD(6)
     C                   MOVEL     RCRA          WLFSD(9)
     C                   MOVEL     AWBA          WLFSD(11)
     C                   MOVEL     BENA          WLFSD(12)
      *
     C                   EXSR      SRWLFChk
      *
      ** Check the Maturity and Value XST Details if CIR003 is enabled.
      *
     C                   IF        %OPEN(DEALSDG) AND
     C                             CIR003 = 'Y' AND
     C                             WOKFlg = 'N'
     C                   EXSR      SRMVWLFC
     C                   ENDIF
      *
     C                   IF        WOKFlg = 'Y'
     C                   EXSR      SRWatch
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCLSChk - Checks CLS Pay Schedule Deals for compliance.      *
      *                                                               *
      *****************************************************************
     C     SRCLSChk      BEGSR
      *
      ** Initialise the Unformatted Watch List Detail fields.
      *
     C                   CLEAR                   SDWLTO
     C                   EVAL      UFRSCY = *BLANKS
     C                   EVAL      UFPSCY = *BLANKS
     C                   EVAL      UFDTP1 = *BLANKS
     C                   EVAL      UFDTP2 = *BLANKS
     C                   EVAL      UFDTP3 = *BLANKS
     C                   EVAL      UFDTP4 = *BLANKS
      *
     C                   MOVEL     'FXCLSP'      UFITEM
     C                   MOVEL     WIden         UFIDEN
     C                   MOVEL     'FXCLSPSH'    UFFUNT
      *
     C                   MOVEL     A7CUST        UFCNUM
     C                   MOVEL     A7BRCD        UFBRCH
      *
     C                   MOVEL     PYVDAT        UFVDAT
     C                   MOVEL     PYCCY         UFDEN1
     C                   MOVE      PYAMT         UFAMT1
      *
      ** Initialise the Opening and Closing XML Tags.
      *
     C                   MOVEA     *BLANKS       WOT
     C                   MOVEA     *BLANKS       WCT
     C                   EVAL      WLimit = 6
      *
     C                   EVAL      WOT(1) = XOT(14)
     C                   EVAL      WOT(2) = XOT(23)
     C                   EVAL      WOT(3) = XOT(17)
     C                   EVAL      WOT(4) = XOT(22)
     C                   EVAL      WOT(5) = XOT(21)
     C                   EVAL      WCT(1) = XCT(14)
     C                   EVAL      WCT(2) = XCT(23)
     C                   EVAL      WCT(3) = XCT(17)
     C                   EVAL      WCT(4) = XCT(22)
     C                   EVAL      WCT(5) = XCT(21)
      *
      ** Move the relevant fields to the Watch List Fields array.
      *
     C                   MOVEA     *BLANKS       WLF
      *
     C                   MOVEL     A7LPR         WLF(1)
     C                   MOVEL     A7CUST        WLF(2)
     C                   MOVEL     A7CLSM        WLF(3)
     C                   MOVEL     A7CLSM        WLF(4)
     C                   MOVEL     A7CLSC        WLF(5)
      *
     C                   EXSR      SRWLFChk
      *
     C                   IF        WOKFlg = 'Y'
     C                   EXSR      SRWatch
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDEAChk - Checks Deal Amendments for compliance.             *
      *                                                               *
      *****************************************************************
     C     SRDEAChk      BEGSR
      *
      ** Initialise the Unformatted Watch List Detail fields.
      *
     C                   CLEAR                   SDWLTO
     C                   EVAL      UFRSCY = *BLANKS
     C                   EVAL      UFPSCY = *BLANKS
     C                   EVAL      UFDTP1 = *BLANKS
     C                   EVAL      UFDTP2 = *BLANKS
     C                   EVAL      UFDTP3 = *BLANKS
     C                   EVAL      UFDTP4 = *BLANKS
      *
     C                   CAT       'MM':0        UFITEM
     C                   CAT       HNMTYP:0      UFITEM
     C                   MOVEL     WIden         UFIDEN
     C                   MOVEL     HNBRCA        UFBRCH
     C                   MOVEL     'MMDEAMPP'    UFFUNT
     C                   MOVEL     HNCNUM        UFCNUM
      *
     C                   EVAL      WLongYr = HNDMDY
     C                   EVAL      PZYear = WShortYr
     C                   EVAL      PZMonth = HNDMDM
     C                   EVAL      PZDay = HNDMDD
      *
     C                   MOVE      PZDate        PZDateIn
     C                   MOVE      BJDFIN        PZDateFmt
      *
     C                   CALLB     'ZDATE1'
     C                   PARM                    PZDateIn
     C                   PARM                    PZDayNo
     C                   PARM                    PZDateFmt
     C                   PARM      *BLANKS       PZRtCd
      *
     C                   MOVEL     PZDayNo       UFDDAT
      *
     C                   EVAL      WLongYr = HNVDYY
     C                   EVAL      PZYear = WShortYr
     C                   EVAL      PZMonth = HNVDMM
     C                   EVAL      PZDay = HNVDDD
      *
     C                   MOVE      PZDate        PZDateIn
      *
     C                   CALLB     'ZDATE1'
     C                   PARM                    PZDateIn
     C                   PARM                    PZDayNo
     C                   PARM                    PZDateFmt
     C                   PARM      *BLANKS       PZRtCd
      *
     C                   MOVEL     PZDayNo       UFVDAT
      *
     C                   MOVEL     HNCCY         UFDEN1
     C                   MOVE      HNAMNP        UFAMT1
      *
     C                   MOVEL     HNSTCY        UFRSCY
      *
     C                   MOVEL     HNDTP1        UFDTP1
     C                   MOVEL     HNDTP2        UFDTP2
     C                   MOVEL     HNDTP3        UFDTP3
     C                   MOVEL     HNDTP4        UFDTP4
      *
      ** Initialise the Opening and Closing XML Tags.
      *
     C                   MOVEA     *BLANKS       WOT
     C                   MOVEA     *BLANKS       WCT
     C                   EVAL      Ctr = 1
     C                   EVAL      WLimit = 13
      *
     C                   DOU       Ctr = WLimit
     C                   EVAL      WOT(Ctr) = XOT(Ctr)
     C                   EVAL      WCT(Ctr) = XCT(Ctr)
     C                   EVAL      Ctr = Ctr + 1
     C                   ENDDO
      *
      ** Move the relevant fields to the Watch List Fields array.
      *
     C                   MOVEA     *BLANKS       WLF
      *
     C                   MOVEL     HNRONS        WLF(1)
     C                   MOVEL     HNRIBN        WLF(2)
     C                   MOVEL     HNROBN        WLF(3)
     C                   MOVEL     HNROCN        WLF(4)
     C                   MOVEL     HNPONS        WLF(5)
     C                   MOVEL     HNPIBN        WLF(6)
     C                   MOVEL     HNPOBN        WLF(7)
     C                   MOVEL     HNPOCN        WLF(8)
     C                   MOVEL     HNRCRN        WLF(9)
     C                   MOVEL     HNRVNO        WLF(10)
     C                   MOVEL     HNAWBN        WLF(11)
     C                   MOVEL     HNBENN        WLF(12)
      *
      ** Initialise additional standing data.
      *
     C                   MOVEA     *BLANKS       WLFSD
      *
     C                   MOVEL     HNRIBA        WLFSD(2)
     C                   MOVEL     HNPIBA        WLFSD(6)
     C                   MOVEL     HNRCRA        WLFSD(9)
     C                   MOVEL     HNAWBA        WLFSD(11)
     C                   MOVEL     HNBENA        WLFSD(12)
      *
     C                   EXSR      SRWLFChk
      *
     C                   IF        WOKFlg = 'Y'
     C                   EXSR      SRWatch
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRFXCChk - Checks Foreign Exchange Confirmed Nets Details for *
      *            compliance.                                        *
      *                                                               *
      *****************************************************************
     C     SRFXCChk      BEGSR
      *
      ** Initialise the Unformatted Watch List Detail fields.
      *
     C                   CLEAR                   SDWLTO
     C                   EVAL      UFRSCY = *BLANKS
     C                   EVAL      UFPSCY = *BLANKS
     C                   EVAL      UFDTP1 = *BLANKS
     C                   EVAL      UFDTP2 = *BLANKS
     C                   EVAL      UFDTP3 = *BLANKS
     C                   EVAL      UFDTP4 = *BLANKS
      *
     C                   CAT       'FXNET'       UFITEM
     C                   MOVEL     AMNETR        UFIDEN
     C                   MOVEL     AMBRCA        UFBRCH
     C                   MOVEL     'FXNETMPD'    UFFUNT
     C                   MOVEL     AMCNUM        UFCNUM
     C                   MOVEL     AMVALD        UFVDAT
      *
     C                   MOVEL     AMCCYD        UFDEN1
     C                   MOVE      AMDBUY        UFAMT1
      *
     C                   MOVEL     AMDTP1        UFDTP1
     C                   MOVEL     AMDTP2        UFDTP2
     C                   MOVEL     AMDTP3        UFDTP3
     C                   MOVEL     AMDTP4        UFDTP4
      *
      ** Initialise the Opening and Closing XML Tags.
      *
     C                   MOVEA     *BLANKS       WOT
     C                   MOVEA     *BLANKS       WCT
     C                   EVAL      Ctr = 1
     C                   EVAL      WLimit = 9
      *
     C                   DOU       Ctr = WLimit
     C                   EVAL      WOT(Ctr) = XOT(Ctr+14)
     C                   EVAL      WCT(Ctr) = XCT(Ctr+14)
     C                   EVAL      Ctr = Ctr + 1
     C                   ENDDO
      *
      ** Move the relevant fields to the Watch List Fields array.
      *
     C                   MOVEA     *BLANKS       WLF
      *
     C                   MOVEL     AMOURN        WLF(1)
     C                   MOVEL     AMIBNK        WLF(2)
     C                   MOVEL     AMOBNK        WLF(3)
     C                   MOVEL     AMORDC        WLF(4)
     C                   MOVEL     AMRCRN        WLF(5)
     C                   MOVEL     AMRVNO        WLF(6)
     C                   MOVEL     AMAWBN        WLF(7)
     C                   MOVEL     AMBENN        WLF(8)
      *
      ** Initialise additional standing data.
      *
     C                   MOVEA     *BLANKS       WLFSD
      *
     C                   MOVEL     AMIBNA        WLFSD(2)
     C                   MOVEL     AMRCRA        WLFSD(5)
     C                   MOVEL     AMAWBA        WLFSD(7)
     C                   MOVEL     AMBENA        WLFSD(8)
      *
     C                   EXSR      SRWLFChk
      *
     C                   IF        WOKFlg = 'Y'
     C                   EXSR      SRWatch
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRFXDDChk - Checks Foreign Exchange Deal Details for com-     *
      *             pliance.                                          *
      *                                                               *
      *****************************************************************
     C     SRFXDDChk     BEGSR
      *
      ** Initialise the Unformatted Watch List Detail fields.
      *
     C                   CLEAR                   SDWLTO
     C                   EVAL      UFRSCY = *BLANKS
     C                   EVAL      UFPSCY = *BLANKS
     C                   EVAL      UFDTP1 = *BLANKS
     C                   EVAL      UFDTP2 = *BLANKS
     C                   EVAL      UFDTP3 = *BLANKS
     C                   EVAL      UFDTP4 = *BLANKS
      *
     C                   CAT       'FX':0        UFITEM
     C                   CAT       FHTYPE:0      UFITEM
     C                   MOVEL     FHDN38        UFIDEN
     C                   MOVEL     FHMBCA        UFBRCH
     C                   MOVEL     'FXDEALPP'    UFFUNT
     C                   MOVEL     FHDCNO        UFCNUM
      *
     C                   EVAL      WLongYr = FHDDYY
     C                   EVAL      PZYear = WShortYr
     C                   EVAL      PZMonth = FHDDMM
     C                   EVAL      PZDay = FHDDDD
      *
     C                   MOVE      PZDate        PZDateIn
     C                   MOVE      BJDFIN        PZDateFmt
      *
     C                   CALLB     'ZDATE1'
     C                   PARM                    PZDateIn
     C                   PARM                    PZDayNo
     C                   PARM                    PZDateFmt
     C                   PARM      *BLANKS       PZRtCd
      *
     C                   MOVEL     PZDayNo       UFDDAT
      *
     C                   EVAL      WLongYr = FHVDYY
     C                   EVAL      PZYear = WShortYr
     C                   EVAL      PZMonth = FHVDMM
     C                   EVAL      PZDay = FHVDDD
      *
     C                   MOVE      PZDate        PZDateIn
      *
     C                   CALLB     'ZDATE1'
     C                   PARM                    PZDateIn
     C                   PARM                    PZDayNo
     C                   PARM                    PZDateFmt
     C                   PARM      *BLANKS       PZRtCd
      *
     C                   MOVEL     PZDayNo       UFVDAT
      *
     C                   EVAL      WLongYr = FHDOEY
     C                   EVAL      PZYear = WShortYr
     C                   EVAL      PZMonth = FHDOEM
     C                   EVAL      PZDay = FHDOED
      *
     C                   MOVE      PZDate        PZDateIn
      *
     C                   CALLB     'ZDATE1'
     C                   PARM                    PZDateIn
     C                   PARM                    PZDayNo
     C                   PARM                    PZDateFmt
     C                   PARM      *BLANKS       PZRtCd
      *
     C                   MOVEL     PZDayNo       UFMDAT
      *
     C                   MOVEL     FHCCY1        UFDEN1
     C                   MOVEL     FHCCY2        UFDEN2
     C                   MOVE      FHDBUY        UFAMT1
     C                   MOVE      FHDSEL        UFAMT2
      *
     C                   MOVEL     FHRSCY        UFRSCY
     C                   MOVEL     FHPSCY        UFPSCY
      *
     C                   MOVEL     FHDTP1        UFDTP1
     C                   MOVEL     FHDTP2        UFDTP2
     C                   MOVEL     FHDTP3        UFDTP3
     C                   MOVEL     FHDTP4        UFDTP4
      *
      ** Initialise the Opening and Closing XML Tags.
      *
     C                   MOVEA     *BLANKS       WOT
     C                   MOVEA     *BLANKS       WCT
     C                   EVAL      Ctr = 1
     C                   EVAL      WLimit = 13
      *
     C                   DOU       Ctr = WLimit
     C                   EVAL      WOT(Ctr) = XOT(Ctr)
     C                   EVAL      WCT(Ctr) = XCT(Ctr)
     C                   EVAL      Ctr = Ctr + 1
     C                   ENDDO
      *
      ** Move the relevant fields to the Watch List Fields array.
      *
     C                   MOVEA     *BLANKS       WLF
      *
     C                   MOVEL     FHRONS        WLF(1)
     C                   MOVEL     FHRIBN        WLF(2)
     C                   MOVEL     FHROBN        WLF(3)
     C                   MOVEL     FHROCN        WLF(4)
     C                   MOVEL     FHPONS        WLF(5)
     C                   MOVEL     FHPIBN        WLF(6)
     C                   MOVEL     FHPOBN        WLF(7)
     C                   MOVEL     FHPOCN        WLF(8)
     C                   MOVEL     FHRCRN        WLF(9)
     C                   MOVEL     FHRVNO        WLF(10)
     C                   MOVEL     FHAWBN        WLF(11)
     C                   MOVEL     FHBENN        WLF(12)
      *
      ** Initialise additional standing data.
      *
     C                   MOVEA     *BLANKS       WLFSD
      *
     C                   MOVEL     FHRIBA        WLFSD(2)
     C                   MOVEL     FHPIBA        WLFSD(6)
     C                   MOVEL     FHRCRA        WLFSD(9)
     C                   MOVEL     FHAWBA        WLFSD(11)
     C                   MOVEL     FHBENA        WLFSD(12)
      *
     C                   EXSR      SRWLFChk
      *
     C                   IF        WOKFlg = 'Y'
     C                   EXSR      SRWatch
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRLDNChk - Checks Loans/Deposits/CD Issued Details for com-   *
      *            pliance.                                           *
      *                                                               *
      *****************************************************************
     C     SRLDNChk      BEGSR
      *
      ** Initialise the Unformatted Watch List Detail fields.
      *
     C                   CLEAR                   SDWLTO
     C                   EVAL      UFRSCY = *BLANKS
     C                   EVAL      UFPSCY = *BLANKS
     C                   EVAL      UFDTP1 = *BLANKS
     C                   EVAL      UFDTP2 = *BLANKS
     C                   EVAL      UFDTP3 = *BLANKS
     C                   EVAL      UFDTP4 = *BLANKS
      *
     C                   IF        HKDRID = *BLANK
     C                   CAT       'MM':0        UFITEM
     C                   ELSE
     C                   CAT       'SE':0        UFITEM
     C                   ENDIF
      *
     C                   CAT       HKMTYP:0      UFITEM
     C                   MOVEL     HKDN38        UFIDEN
     C                   MOVEL     HKBRCA        UFBRCH
     C                   MOVEL     'MMDELDPP'    UFFUNT
     C                   MOVEL     HKCNUM        UFCNUM
      *
     C                   EVAL      WLongYr = HKDDYY
     C                   EVAL      PZYear = WShortYr
     C                   EVAL      PZMonth = HKDDMM
     C                   EVAL      PZDay = HKDDDD
      *
     C                   MOVE      PZDate        PZDateIn
     C                   MOVE      BJDFIN        PZDateFmt
      *
     C                   CALLB     'ZDATE1'
     C                   PARM                    PZDateIn
     C                   PARM                    PZDayNo
     C                   PARM                    PZDateFmt
     C                   PARM      *BLANKS       PZRtCd
      *
     C                   MOVEL     PZDayNo       UFDDAT
      *
     C                   EVAL      WLongYr = HKVDYY
     C                   EVAL      PZYear = WShortYr
     C                   EVAL      PZMonth = HKVDMM
     C                   EVAL      PZDay = HKVDDD
      *
     C                   MOVE      PZDate        PZDateIn
      *
     C                   CALLB     'ZDATE1'
     C                   PARM                    PZDateIn
     C                   PARM                    PZDayNo
     C                   PARM                    PZDateFmt
     C                   PARM      *BLANKS       PZRtCd
      *
     C                   MOVEL     PZDayNo       UFVDAT
      *
     C                   EVAL      WLongYr = HKMDYY
     C                   EVAL      PZYear = WShortYr
     C                   EVAL      PZMonth = HKMDMM
     C                   EVAL      PZDay = HKMDDD
      *
     C                   MOVE      PZDate        PZDateIn
      *
     C                   CALLB     'ZDATE1'
     C                   PARM                    PZDateIn
     C                   PARM                    PZDayNo
     C                   PARM                    PZDateFmt
     C                   PARM      *BLANKS       PZRtCd
      *
     C                   MOVEL     PZDayNo       UFMDAT
      *
     C                   MOVEL     HKCCY         UFDEN1
     C                   MOVE      HKAMNP        UFAMT1
      *
     C                   MOVEL     HKSTCY        UFRSCY
      *
     C                   MOVEL     HKDTP1        UFDTP1
     C                   MOVEL     HKDTP2        UFDTP1
     C                   MOVEL     HKDTP3        UFDTP3
     C                   MOVEL     HKDTP4        UFDTP4
      *
      ** Initialise the Opening and Closing XML Tags.
      *
     C                   MOVEA     *BLANKS       WOT
     C                   MOVEA     *BLANKS       WCT
     C                   EVAL      Ctr = 1
     C                   EVAL      WLimit = 13
      *
     C                   DOU       Ctr = WLimit
     C                   EVAL      WOT(Ctr) = XOT(Ctr)
     C                   EVAL      WCT(Ctr) = XCT(Ctr)
     C                   EVAL      Ctr = Ctr + 1
     C                   ENDDO
      *
      ** Move the relevant fields to the Watch List Fields array.
      *
     C                   MOVEA     *BLANKS       WLF
      *
     C                   MOVEL     HKRONS        WLF(1)
     C                   MOVEL     HKRIBN        WLF(2)
     C                   MOVEL     HKROBN        WLF(3)
     C                   MOVEL     HKROCN        WLF(4)
     C                   MOVEL     HKPONS        WLF(5)
     C                   MOVEL     HKPIBN        WLF(6)
     C                   MOVEL     HKPOBN        WLF(7)
     C                   MOVEL     HKPOCN        WLF(8)
     C                   MOVEL     HKRCRN        WLF(9)
     C                   MOVEL     HKRVNO        WLF(10)
     C                   MOVEL     HKAWBN        WLF(11)
     C                   MOVEL     HKBENN        WLF(12)
      *
      ** Initialise additional standing data.
      *
     C                   MOVEA     *BLANKS       WLFSD
      *
     C                   MOVEL     HKRIBA        WLFSD(2)
     C                   MOVEL     HKPIBA        WLFSD(6)
     C                   MOVEL     HKRCRA        WLFSD(9)
     C                   MOVEL     HKAWBA        WLFSD(11)
     C                   MOVEL     HKBENA        WLFSD(12)
      *
     C                   EXSR      SRWLFChk
      *
     C                   IF        WOKFlg = 'Y'
     C                   EXSR      SRWatch
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRNAPSChk - Checks Negotiable Assets Purchased and Sold for   *
      *             compliance.                                       *
      *                                                               *
      *****************************************************************
     C     SRNAPSChk     BEGSR
      *
      ** Initialise the Unformatted Watch List Detail fields.
      *
     C                   CLEAR                   SDWLTO
     C                   EVAL      UFRSCY = *BLANKS
     C                   EVAL      UFPSCY = *BLANKS
     C                   EVAL      UFDTP1 = *BLANKS
     C                   EVAL      UFDTP2 = *BLANKS
     C                   EVAL      UFDTP3 = *BLANKS
     C                   EVAL      UFDTP4 = *BLANKS
      *
     C                   CAT       'MM':0        UFITEM
     C                   CAT       HXMTYP:0      UFITEM
     C                   MOVEL     HXDN38        UFIDEN
     C                   MOVEL     HXBRCA        UFBRCH
      *
     C                   SELECT
     C                   WHEN      HXRBSI = 'B'
     C                   MOVEL     'MMDENBPP'    UFFUNT
     C                   WHEN      HXRBSI = 'S'
     C                   MOVEL     'MMDENSPP'    UFFUNT
     C                   ENDSL
      *
     C                   MOVEL     HXCNUM        UFCNUM
      *
     C                   EVAL      WLongYr = HXDDYY
     C                   EVAL      PZYear = WShortYr
     C                   EVAL      PZMonth = HXDDMM
     C                   EVAL      PZDay = HXDDDD
      *
     C                   MOVE      PZDate        PZDateIn
     C                   MOVE      BJDFIN        PZDateFmt
      *
     C                   CALLB     'ZDATE1'
     C                   PARM                    PZDateIn
     C                   PARM                    PZDayNo
     C                   PARM                    PZDateFmt
     C                   PARM      *BLANKS       PZRtCd
      *
     C                   MOVEL     PZDayNo       UFDDAT
      *
     C                   EVAL      WLongYr = HXVDYY
     C                   EVAL      PZYear = WShortYr
     C                   EVAL      PZMonth = HXVDMM
     C                   EVAL      PZDay = HXVDDD
      *
     C                   MOVE      PZDate        PZDateIn
      *
     C                   CALLB     'ZDATE1'
     C                   PARM                    PZDateIn
     C                   PARM                    PZDayNo
     C                   PARM                    PZDateFmt
     C                   PARM      *BLANKS       PZRtCd
      *
     C                   MOVEL     PZDayNo       UFVDAT
      *
     C                   EVAL      WLongYr = HXMDYY
     C                   EVAL      PZYear = WShortYr
     C                   EVAL      PZMonth = HXMDMM
     C                   EVAL      PZDay = HXMDDD
      *
     C                   MOVE      PZDate        PZDateIn
      *
     C                   CALLB     'ZDATE1'
     C                   PARM                    PZDateIn
     C                   PARM                    PZDayNo
     C                   PARM                    PZDateFmt
     C                   PARM      *BLANKS       PZRtCd
      *
     C                   MOVEL     PZDayNo       UFMDAT
      *
     C                   MOVEL     HXCCY         UFDEN1
     C                   MOVE      HXAMNP        UFAMT1
      *
     C                   MOVEL     HXSTCY        UFRSCY
      *
     C                   MOVEL     HXDTP1        UFDTP1
     C                   MOVEL     HXDTP2        UFDTP1
     C                   MOVEL     HXDTP3        UFDTP3
     C                   MOVEL     HXDTP4        UFDTP4
      *
      ** Initialise the Opening and Closing XML Tags.
      *
     C                   MOVEA     *BLANKS       WOT
     C                   MOVEA     *BLANKS       WCT
     C                   EVAL      Ctr = 1
     C                   EVAL      WLimit = 13
      *
     C                   DOU       Ctr = WLimit
     C                   EVAL      WOT(Ctr) = XOT(Ctr)
     C                   EVAL      WCT(Ctr) = XCT(Ctr)
     C                   EVAL      Ctr = Ctr + 1
     C                   ENDDO
      *
      ** Move the relevant fields to the Watch List Fields array.
      *
     C                   MOVEA     *BLANKS       WLF
      *
     C                   MOVEL     HXRONS        WLF(1)
     C                   MOVEL     HXRIBN        WLF(2)
     C                   MOVEL     HXROBN        WLF(3)
     C                   MOVEL     HXROCN        WLF(4)
     C                   MOVEL     HXPONS        WLF(5)
     C                   MOVEL     HXPIBN        WLF(6)
     C                   MOVEL     HXPOBN        WLF(7)
     C                   MOVEL     HXPOCN        WLF(8)
     C                   MOVEL     HXRCRN        WLF(9)
     C                   MOVEL     HXRVNO        WLF(10)
     C                   MOVEL     HXAWBN        WLF(11)
     C                   MOVEL     HXBENN        WLF(12)
      *
      ** Initialise additional standing data.
      *
     C                   MOVEA     *BLANKS       WLFSD
      *
     C                   MOVEL     HXRIBA        WLFSD(2)
     C                   MOVEL     HXPIBA        WLFSD(6)
     C                   MOVEL     HXRCRA        WLFSD(9)
     C                   MOVEL     HXAWBA        WLFSD(11)
     C                   MOVEL     HXBENA        WLFSD(12)
      *
     C                   EXSR      SRWLFChk
      *
     C                   IF        WOKFlg = 'Y'
     C                   EXSR      SRWatch
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRWatch - Initiates the Midas Compliance Engine.              *
      *                                                               *
      *****************************************************************
     C     SRWatch       BEGSR
      *
      ** Initialise the Transaction Details Parameter
      ** ============================================
      *
     C                   CLEAR                   SDWLTD
      *
      ** Item Type, Identifier, and Branch information.
      *
     C                   MOVEL     UFITEM        W4ITEM
     C                   MOVEL     UFIDEN        W4IDEN
     C                   MOVEL     UFBRCH        W4BRCH
      *
      ** Select the System Prefix.
      *
     C                   IF        CSC011 = 'Y'
     C                   EVAL      W4SYSM = S1MAIN
     C                   ELSE
     C                   EVAL      W4SYSM = LIBR
     C                   ENDIF
      *
     C                   MOVEL     UFFUNT        W4FUNT
      *
      ** Get the Counter Party Detail.
      *
     C                   MOVEL     UFCNUM        W4CNUM
     C                   MOVEL     UFCNUM        PCustNo
     C                   EXSR      SRGetCtrpDet
     C                   MOVEL     WCtrpTyp      W4CTYP
     C                   MOVEL     WCtrpRpt      W4CUST
      *
      ** Get the Deal Date.
      *
     C                   MOVEL     UFDDAT        PZADayNo
     C                   EXSR      SRDateToDDT
     C                   EVAL      W4DDAT = WDDT
      *
      ** Get the Value Date.
      *
     C                   MOVEL     UFVDAT        PZADayNo
     C                   EXSR      SRDateToDDT
     C                   EVAL      W4VDAT = WDDT
      *
      ** Get the Maturity Date.
      *
     C                   MOVEL     UFMDAT        PZADayNo
     C                   EXSR      SRDateToDDT
     C                   EVAL      W4MDAT = WDDT
      *
      ** Currency and Amount information.
      *
     C                   MOVEL     UFDEN1        W4DEN1
     C                   MOVEL     UFDEN1        PZACcy
     C                   MOVE      *BLANKS       PZANtvAmt
     C                   MOVE      UFAMT1        PZANtvAmt
     C                   EXSR      SRAmtToNum
     C                   EVAL      W4AMT1 = WAMT
      *
     C                   MOVEL     UFDEN2        W4DEN2
     C                   MOVEL     UFDEN2        PZACcy
     C                   MOVE      *BLANKS       PZANtvAmt
     C                   MOVE      UFAMT2        PZANtvAmt
     C                   EXSR      SRAmtToNum
     C                   EVAL      W4AMT2 = WAMT
      *
      ** Switch denominations for transactions of type INT (default).
      *
     C                   IF        %OPEN(DEALSDG)
     C                   EVAL      UFRSCY = PSCY
     C                   EVAL      UFPSCY = RSCY
     C                   EVAL      UFDEN1 = W4DEN2
     C                   EVAL      UFDEN2 = W4DEN1
     C                   ENDIF
      *
      ** Build the Free Format String
      ** ============================
      *
     C                   EVAL      PFreeFmtStr = *BLANKS
      *
      ** Build the XML Packet chain.
      *
     C                   EXSR      SRBldXPC
      *
      ** Add the Extended Settlement XML Packets if necessary.
      *
     C                   IF        %OPEN(DEALSDG) AND
     C                             CIR003 = 'Y'
     C                   EXSR      SRMVXSTXP
     C                   ENDIF
      *
      ** Check for compliance.
      *
     C                   IF        PFreeFmtStr <> *BLANKS
     C                   CALL      'SDWLENGN'
     C                   PARM      *BLANK        PRetCode
     C                   PARM                    PSrvContext
     C                   PARM                    SDWLTD
     C                   PARM                    PFreeFmtStr
 
      ** Error calling SDWLENGN
 
     C                   IF        PRetCode <> *BLANK
     C                   SELECT
 
     C                   WHEN      PRetCode = '*ERROR '
     C                   EVAL      WDBASE = 7
 
     C                   WHEN      PRetCode = '*FOFEXE'
     C                   EVAL      WDBASE = 8
     C                   EVAL      PMsgId = 'USR9680'
     C                   EXSR      SRSndErr
 
     C                   WHEN      PRetCode = '*SRVNAM'
     C                   EVAL      WDBASE = 9
     C                   EVAL      PMsgId = 'USR9681'
     C                   EXSR      SRSndErr
 
     C                   WHEN      PRetCode = '*DBNAME'
     C                   EVAL      WDBASE = 10
     C                   EVAL      PMsgId = 'USR9682'
     C                   EXSR      SRSndErr
 
     C                   WHEN      PRetCode = '*USRNAM'
     C                   EVAL      WDBASE = 11
     C                   EVAL      PMsgId = 'USR9683'
     C                   EXSR      SRSndErr
 
     C                   WHEN      PRetCode = '*PASSWD'
     C                   EVAL      WDBASE = 12
     C                   EVAL      PMsgId = 'USR9684'
     C                   EXSR      SRSndErr
 
     C                   OTHER
     C                   EVAL      PMsgId = 'USR9685'
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
     C                   EVAL      DBKey = SDWLTD
     C                   EVAL      DBFile = 'SDWLENGN'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBldXPC - Builds the XML Packet chain on the Compliance      *
      *            Engine Free Format String.                         *
      *                                                               *
      *****************************************************************
     C     SRBldXPC      BEGSR
      *
      ** Begin string and packet assembly.
      *
     C                   EVAL      Ctr = 1
     C                   EVAL      WXMLPacket = *BLANKS
     C                   EVAL      WData = *BLANKS
     C                   EVAL      WCcy = *BLANKS
      *
     C                   DOU       Ctr = WLimit
      *
     C                   IF        WLF(Ctr) <> *BLANKS
      *
      ** Select the currency for nostro fields.
      *
     C                   IF        WOT(Ctr) = '<Receipt Our Nostro>' OR
     C                             WOT(Ctr) = '<Our Nostro>' OR
     C                             WOT(Ctr) = '<CLS Nostro>'
     C                   IF        UFRSCY <> *BLANKS
     C                   EVAL      WCcy = UFRSCY
     C                   ELSE
     C                   EVAL      WCcy = UFDEN1
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        WOT(Ctr) = '<Payment Our Nostro>'
     C                   IF        UFPSCY <> *BLANKS
     C                   EVAL      WCcy = UFPSCY
     C                   ELSE
     C                   EVAL      WCcy = UFDEN2
     C                   ENDIF
      *
      ** Use the 1st Denomination if the Payment Settlement Currency
      ** is still undefined at this point.
      *
     C                   IF        WCcy = *BLANKS
     C                   EVAL      WCcy = UFDEN1
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Call the detail retriever program.
      *
     C                   CALL      'SDCWLFMT'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM                    WLF(Ctr)
     C                   PARM      *BLANKS       PInpA
     C                   PARM      *BLANKS       PInpB
     C                   PARM      *BLANKS       PInpC
     C                   PARM      *BLANKS       PInpD
     C                   PARM      *BLANKS       PInpE
     C                   PARM                    WCcy
     C                   PARM                    WData
     C                   PARM                    POutA
      *
     C                   IF        WData <> *BLANKS AND
     C                             %CHECK('0 ':WData) <> 0 AND
     C                             @RtCd = *BLANKS
     C                   CAT       WOT(Ctr):0    WXMLPacket
     C                   CAT       WData:0       WXMLPacket
     C                   CAT       WLFSD(Ctr):1  WXMLPacket
     C                   CAT       WCT(Ctr):0    WXMLPacket
     C                   CAT       WXMLPacket:0  PFreeFmtStr
     C                   ENDIF
      *
     C                   EVAL      WXMLPacket = *BLANKS
     C                   EVAL      WData = *BLANKS
     C                   EVAL      WCcy = *BLANKS
      *
     C                   ENDIF
      *
     C                   EVAL      Ctr = Ctr + 1
      *
     C                   ENDDO
      *
      ** Add the Payment Details.
      *
     C                   IF        UFDTP1 <> *BLANKS OR
     C                             UFDTP2 <> *BLANKS OR
     C                             UFDTP3 <> *BLANKS OR
     C                             UFDTP4 <> *BLANKS
      *
     C                   EVAL      WOT(Ctr) = XOT(13)
     C                   EVAL      WCT(Ctr) = XCT(13)
      *
     C                   CAT       WOT(Ctr):0    WXMLPacket
     C                   CAT       UFDTP1:0      WXMLPacket
     C                   CAT       UFDTP2:1      WXMLPacket
     C                   CAT       UFDTP3:1      WXMLPacket
     C                   CAT       UFDTP4:1      WXMLPacket
     C                   CAT       WCT(Ctr):0    WXMLPacket
     C                   CAT       WXMLPacket:0  PFreeFmtStr
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMVXSTXP - Adds Extended Settlement XML Packets to the       *
      *             Compliance Engine Free Format string.             *
      *                                                               *
      *****************************************************************
     C     SRMVXSTXP     BEGSR
      *
     C                   OPEN      DLGXSTL0
      *
      ** Use the current Deal Number to retrieve Extended Settlements.
      *
     C                   EVAL      KDLNO = DLNO
      *
     C                   FOR       WItr = 1 TO 2
      *
     C                   MOVEA     *BLANKS       WLF
     C                   MOVEA     *BLANKS       WLFSD
      *
      ** Add Maturity Settlements on the first iteration and
      ** Value Settlements on the second iteration.
      *
     C                   IF        WItr = 1
     C                   EVAL      KEDCD = 'MAT'
     C                   EVAL      UFRSCY = RXPSCY
     C                   EVAL      UFPSCY = RXRSCY
     C                   ELSE
     C                   EVAL      KEDCD = 'VAL'
      *
      ** Set usual denominations for transactions of type VAL.
      *
     C                   EVAL      UFRSCY = RXRSCY
     C                   EVAL      UFPSCY = RXPSCY
     C                   EVAL      UFDEN1 = W4DEN1
     C                   EVAL      UFDEN2 = W4DEN2
     C                   ENDIF
      *
      ** Search for Extended Settlements.
      *
     C     KGXST         CHAIN     DLGXSTL0
      *
     C                   IF        %FOUND(DLGXSTL0)
      *
      ** Move the relevant fields to the Watch List Fields array.
      *
     C                   MOVEL     RXRONS        WLF(1)
     C                   MOVEL     RXRIBN        WLF(2)
     C                   MOVEL     RXROBN        WLF(3)
     C                   MOVEL     RXROCN        WLF(4)
     C                   MOVEL     RXPONS        WLF(5)
     C                   MOVEL     RXPIBN        WLF(6)
     C                   MOVEL     RXPOBN        WLF(7)
     C                   MOVEL     RXPOCN        WLF(8)
     C                   MOVEL     RXRCRN        WLF(9)
     C                   MOVEL     RXRVNO        WLF(10)
     C                   MOVEL     RXAWBN        WLF(11)
     C                   MOVEL     RXBENN        WLF(12)
      *
      ** Initialise additional standing data.
      *
     C                   MOVEL     RXRIBA        WLFSD(2)
     C                   MOVEL     RXPIBA        WLFSD(6)
     C                   MOVEL     RXRCRA        WLFSD(9)
     C                   MOVEL     RXAWBA        WLFSD(11)
     C                   MOVEL     RXBENA        WLFSD(12)
      *
      ** Initialise working variables.
      *
     C                   EVAL      UFRSCY = RXRSCY
     C                   EVAL      UFPSCY = RXPSCY
      *
     C                   EVAL      UFDTP1 = RXDTP1
     C                   EVAL      UFDTP2 = RXDTP2
     C                   EVAL      UFDTP3 = RXDTP3
     C                   EVAL      UFDTP4 = RXDTP4
      *
      ** Check if useful Extended Settlement Details are available.
      *
     C                   EXSR      SRWLFChk
      *
      ** Build the XML Packet chain.
      *
     C                   IF        WOKFlg = 'Y'
     C                   EXSR      SRBldXPC
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDFOR
      *
     C                   CLOSE     DLGXSTL0
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMVWLFC - Watch List Fields check for Maturity and Value     *
      *            Extended Settlement Details.                       *
      *                                                               *
      *****************************************************************
     C     SRMVWLFC      BEGSR
      *
     C                   OPEN      DLGXSTL0
      *
      ** Use the current Deal Number to retrieve Extended Settlements.
      *
     C                   EVAL      KDLNO = DLNO
      *
     C                   FOR       WItr = 1 TO 2
      *
      ** Check Maturity Settlements on the first iteration and
      ** Value Settlements on the second iteration.
      *
     C                   IF        WItr = 1
     C                   EVAL      KEDCD = 'MAT'
     C                   ELSE
     C                   EVAL      KEDCD = 'VAL'
     C                   ENDIF
      *
      ** Search for Extended Settlements.
      *
     C     KGXST         CHAIN     DLGXSTL0
      *
     C                   IF        %FOUND(DLGXSTL0)
     C                   EVAL      WSum = RXROBN + RXROCN +
     C                             RXPOBN + RXPOCN
     C                   IF        RcptDetails <> *BLANKS OR
     C                             PayDetails <> *BLANKS OR
     C                             OtherInfo <> *BLANKS OR
     C**********                   WSum <> 0                                                  CSD027
     C                             WSum <> *BLANKS                                            CSD027
     C                             OR RXPONS <> *BLANKS                                       CGL029
     C                             OR RXRONS <> *BLANKS                                       CGL029
     C                   EVAL      WOKFlg = 'Y'
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDFOR
      *
     C                   CLOSE     DLGXSTL0
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRHitChk - Checks if the current record is on the Compliance  *
      *            Watch Hit List.                                    *
      *                                                               *
      *****************************************************************
     C     SRHitChk      BEGSR
      *
     C                   EVAL      WHitFlg = 'N'
      *
     C     KCWHT         CHAIN     SDCWHTL1
      *
     C                   IF        %FOUND(SDCWHTL1)
     C                   EVAL      WHitFlg = 'Y'
     C                   ENDIF
      *
     C                   EVAL      KFuncType = *BLANKS
     C                   EVAL      KIden = *BLANKS
     C                   EVAL      KBranch = *BLANKS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRWLFChk - Checks if there is something useful to return      *
      *            to the Compliance Engine.                          *
      *                                                               *
      *****************************************************************
     C     SRWLFChk      BEGSR
      *
      ** Check the Watch List Fields array.
      *
     C                   EVAL      WOKFlg = 'N'
     C                   EVAL      Ctr = 1
      *
     C                   DOU       Ctr = WLimit
     C                   IF        WLF(Ctr) <> *BLANKS AND
     C                             %CHECK('0 ':WLF(Ctr)) <> 0
     C                   EVAL      WOKFlg = 'Y'
     C                   LEAVE
     C                   ENDIF
     C                   EVAL      Ctr = Ctr + 1
     C                   ENDDO
      *
      ** Check the Payment Details.
      *
     C                   IF        WOKFlg = 'N'
     C                   IF        UFDTP1 <> *BLANKS OR
     C                             UFDTP2 <> *BLANKS OR
     C                             UFDTP3 <> *BLANKS OR
     C                             UFDTP4 <> *BLANKS
     C                   EVAL      WOKFlg = 'Y'
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRGetCtrpDet - Gets the Counterparty Details given a Customer *
      *                Number.                                        *
      *                                                               *
      *****************************************************************
     C     SRGetCtrpDet  BEGSR
      *
      ** Initialise the relevant variables.
      *
     C                   EVAL      WCtrpRpt = *BLANKS
     C                   EVAL      WCtrpTyp = *BLANKS
      *
      ** Get the Customer Detail.
      *
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM                    PCustNo
     C                   PARM      *BLANKS       PErrInf
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C                   IF        @RtCd = *BLANKS
      *
      ** Assemble the Counterparty Report information.
      *
     C                   CAT       BBCRNM:0      WCtrpRpt
     C                   CAT       BBCRTN:0      WCtrpRpt
      *
      ** Determine the Counterparty Type.
      *
     C                   IF        CCF001 = 'Y'
      *
     C                   IF        BBCRPC = 'Y'
     C                   EVAL      WCtrpTyp = 'C'
     C                   ELSE
     C                   EVAL      WCtrpTyp = 'I'
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   IF        BBLICD <> *BLANKS AND
     C                             BBLICD <> W1IND1  AND
     C                             BBLICD <> W1IND2  AND
     C                             BBLICD <> W1IND3  AND
     C                             BBLICD <> W1IND4  AND
     C                             BBLICD <> W1IND5
     C                   EVAL      WCtrpTyp = 'C'
     C                   ELSE
     C                   EVAL      WCtrpTyp = 'I'
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ELSE
      *
      ** Handle Database Errors if any occur.
      *
     C                   IF        @RtCd <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = @Optn
     C                   EVAL      DBFile = 'SDCUSTPD'
     C                   EVAL      DBase = 906
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDateToDDT - Converts a date into Date Data Type format.     *
      *                                                               *
      *****************************************************************
     C     SRDateToDDT   BEGSR
      *
      ** Convert the derived Midas Day Number into Date Data Type.
      *
     C                   CALL      'ZACVTDATE'
     C                   PARM      *BLANKS       PZARtCd
     C                   PARM                    PZADayNo
     C                   PARM                    PZADDT
     C                   PARM                    PZACvtDate
      *
     C                   EVAL      WDDT = PZADDT
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAmtToNum - Converts a native amount into numerical format.  *
      *                                                               *
      *****************************************************************
     C     SRAmtToNum    BEGSR
      *
      ** Directly convert the given amount into numerical format.
      *
     C                   CALL      'ZACVTAMT'
     C                   PARM      *BLANKS       PZARtCd
     C                   PARM                    PZACcy
     C                   PARM                    PZANtvAmt
     C                   PARM                    PZAAmt
     C                   PARM                    PZACvtAmt
      *
     C                   EVAL      WAMT = PZAAmt
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRGetRealNst - Gets the Real Nostro given a CLS Dummy Nostro. *
      *                                                               *
      *****************************************************************
     C     SRGetRealNst  BEGSR
      *
      ** Use the CLS Dummy Nostro first.
      *
     C                   EXSR      SRGetNstDet
      *
      ** This time, use the CLS Pay/Receive Nostro Code.
      *
     C                   EVAL      PNostCode = A7LPR
     C                   EXSR      SRGetNstDet
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRGetNstDet - Gets the Nostro details given a currency and    *
      *               Nostro Code pair.                               *
      *                                                               *
      *****************************************************************
     C     SRGetNstDet   BEGSR
      *
      ** Access Nostro Details.
      *
     C                   CALL      'AONOSTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      *BLANKS       PCUST
     C                   PARM                    PCcy
     C                   PARM      *BLANKS       PACCD
     C                   PARM      *BLANKS       PACSN
     C                   PARM                    PNostCode
     C                   PARM      *BLANKS       PBRCD
     C                   PARM      *BLANKS       PCSSN
     C                   PARM      *BLANKS       PPNOI
     C     SDNOST        PARM      SDNOST        DSFDY
      *
     C                   IF        @RtCd <> *BLANKS AND
     C                             @RtCd <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = PCcy + PNostCode
     C                   EVAL      DBFile = 'SDNOSTPD'
     C                   EVAL      DBase = 907
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
 
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
     C                   PARM      'SD000015'    PMsg
     C                   PARM                    PMsgId
     C                   PARM      'GBSDUSRMSG'  PMsgF
     C                   PARM      'MOPERQ    '  PMsgQ
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation Subroutine                    *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Access the SDSTAT Data Area.
      *
     C                   IN        SDSTAT
      *
      ** Access Bank Details.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Handle Database Errors if any occur.
      *
     C                   IF        @Rtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBase = 901
     C                   EVAL      DBKey = @Optn
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access DEALING function code details.
      *
     C                   CALL      'AOWLCCR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM      'DEALING '    PFuncCode
     C     SDWLCC        PARM      SDWLCC        DSFDY
      *
     C                   IF        @RtCd <> *BLANKS AND
     C                             @RtCd <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = 'DEALING'
     C                   EVAL      DBFile = 'SDWLCCPD'
     C                   EVAL      DBase = 902
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Check for compliance today?
      *
     C                   IF        @RTCD = '*NRF' OR
     C                             W1PFRQ = *BLANK OR W1NPCD > BJRDNB
     C                   EVAL      *INLR = True
     C                   RETURN
     C                   ENDIF
      *
      ** Compliance Watch Hit List Key.
      *
     C     KCWHT         KLIST
     C                   KFLD                    KFuncType
     C                   KFLD                    KIden
     C                   KFLD                    KBranch
      *
      ** Extended Settlement Details Key.
      *
     C     KGXST         KLIST
     C                   KFLD                    KDLNO
     C                   KFLD                    KEDCD
      *
      ** Access Compliance Watch Configuration Data.
      *
     C                   CALL      'AOCWCDR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDCWCD        PARM      SDCWCD        DSSDY
      *
     C                   IF        @RtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDCWCDPD'
     C                   EVAL      DBase = 903
     C                   EVAL      DBKey = @Optn
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access SAR details to see if CSC011 is switched on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*VERIFY'     @Optn
     C                   PARM      'CSC011'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        @RtCd = *BLANKS
     C                   EVAL      CSC011 = 'Y'
     C                   IN        SC24X7
     C                   ELSE
      *
     C                   IF        @RtCd <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = 'CSC011'
     C                   EVAL      DBFile = 'SCSARDPD'
     C                   EVAL      DBase = 904
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Access SAR details to see if CCF001 is switched on.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*VERIFY'     @Optn
     C                   PARM      'CCF001'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        @RtCd = *BLANKS
     C                   EVAL      CCF001 = 'Y'
     C                   ELSE
      *
     C                   IF        @RtCd <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = 'CCF001'
     C                   EVAL      DBFile = 'SCSARDPD'
     C                   EVAL      DBase = 905
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Access SAR details to see if CIR003 is switched on.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*VERIFY'     @Optn
     C                   PARM      'CIR003'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        @RtCd = *BLANKS
     C                   EVAL      CIR003 = 'Y'
     C                   ELSE
      *
     C                   IF        @RtCd <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = 'CIR003'
     C                   EVAL      DBFile = 'SCSARDPD'
     C                   EVAL      DBase = 906
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF
      *
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
      /EJECT
      *****************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2002
** CTDATA XOT - XML Opening Tags for the Compliance Engine.
<Receipt Our Nostro>
<Receipt Inter. Bank>
<Receipt Ord. Bank>
<Receipt Ord. Customer>
<Payment Our Nostro>
<Payment Inter. Bank>
<Payment Ord. Bank>
<Payment Ord. Customer>
<Payment Rec. Corr.>
<Payment Recipient>
<Payment Acc. with Bank>
<Payment Beneficiary>
<Payment Details>
<CLS Nostro>
<Our Nostro>
<Intermediary Bank>
<Ordering Bank>
<Ordering Customer>
<Receiver Correspondent>
<Receiver Number>
<Account with Bank>
<Beneficiary>
<Destination>
** CTDATA XCT - XML Closing Tags for the Compliance Engine.
</Receipt Our Nostro>
</Receipt Inter. Bank>
</Receipt Ord. Bank>
</Receipt Ord. Customer>
</Payment Our Nostro>
</Payment Inter. Bank>
</Payment Ord. Bank>
</Payment Ord. Customer>
</Payment Rec. Corr.>
</Payment Recipient>
</Payment Acc. with Bank>
</Payment Beneficiary>
</Payment Details>
</CLS Nostro>
</Our Nostro>
</Intermediary Bank>
</Ordering Bank>
</Ordering Customer>
</Receiver Correspondent>
</Receiver Number>
</Account with Bank>
</Beneficiary>
</Destination>
