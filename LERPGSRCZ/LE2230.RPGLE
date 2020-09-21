     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*XBI *  OVRDBF FILE(LESTALLX) TOFILE(LESTALL2) SHARE(*NO)            *                       CAP065
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Settlements allocation input')                *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE2230 - Settlements Allocation Input                        *
      *                                                               *
      *  Function:  This module will be a new combined maintenance/   *
      *             enquiry function on Midas and a new combined      *
      *             maintenance/browser function on loan manager.     *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CLE148             Date 23Jul12               *
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 227714             Date 20May04               *
      *                 CLE038             Date 11May04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 222373             Date 29Oct03               *
      *                 221960             Date 08Oct03               *
      *                 221859             Date 03Oct03               *
      *                 219793             Date 17Jul03               *
      *                 219608             Date 14Jul03               *
      *                 219070             Date 24Jun03               *
      *                 218782             Date 20Jun03               *
      *                 CLE034  *CREATE    Date 05May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE148 - Alpha Loan Reference                                *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile).       *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  227714 - Not finding any records when doing amend after delet*
      *  CLE038 - Lending Enhancement for Nordea: Allocation by Amount*
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222373 - Parameter mismatch.                                 *
      *  221960 - If the action code is 'R', set up command key F12.  *
      *  221859 - If protecting pay side, do not set up any pay       *
      *           settlement fields.                                  *
      *  219793 - Parameter Settle Through Nostros, PSetlNos, was     *
      *           not being set up                                    *
      *  219608 - Amendment of Settlement Allocations needs a 'Before'*
      *           image to ensure the right allocations are reversed. *
      *  219070 - Allow transactions in EUR to use any settlement ccy.*
      *  218782 - Check system value Settlement09Postings to decide   *
      *           whether to use Settlement or Transaction Ccy.       *
      *  CLE034 - Lending Enhancements.                               *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas LE Settlement Allocation by Transaction and Sequence
     FLESTALL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LESTALD0:LESTAL1)
 
      ** Midas LE Settlement Allocation by Transaction and Sequence
     FLESTALL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LESTALD0:LESTAL2)
 
      ** Midas LE Settlement Allocation by Transaction and Sequence
     FLESTALLX  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LESTALD0:LESTALX)
 
      ** Midas LE Settlement Allocation by Transaction (Live)
     FLESTALL5  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LESTALD0:LESTAL5)
 
      ** Midas LE Settlement Allocation by Transaction and Sequence (Access)
     FLESTALL6  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LESTALD0:LESTAL6)
 
      ** Midas LE Settlement Allocation by Transaction and Sequence (Update)
     FLESTALL7  UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LESTALD0:LESTAL7)
     F                                     COMMIT
 
      ** Midas LE Settlement Allocation by Transaction (All)
     FLESTALL9  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LESTALD0:LESTAL9)
 
      ** Midas LE Settlement Allocation Input Invalid Data by
      ** Transaction and Repair Number
     FLEISTLL1  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LEISTLD0:LEISTL1)
     F                                     COMMIT
 
      ** API Invalid Log File by Type/FO Id/Timestamp
     FAPILOGL0  UF   E           K DISK    INFSR(*PSSR) USROPN
     F                                     RENAME(APILOGD0:APILOG0)
     F                                     COMMIT
 
      ** API Invalid Log File
     FAPILOGPD  UF A E           K DISK    INFSR(*PSSR) USROPN
     F                                     COMMIT
 
      ** API Valid Log File
     FAPVLOGPD  UF A E           K DISK    INFSR(*PSSR) USROPN
     F                                     COMMIT
 
      ** Midas LE Settlement Allocation Input Invalid Data
     FLEISTLPD  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** Settlements Allocation Input Display File
     FLE2230DF  CF   E             WORKSTN SFILE(LE2230S0:WRRN0)
     F                                     SFILE(LE2230S1:WRRN1)
     F                                     USROPN
      ** Before Image of Settlement Allocations                                               219608
     FLEBSTLPD  O    E             DISK    INFSR(*PSSR) USROPN                                219608
     F                                     RENAME(LESTALD0:LEBSTLD0)                          219608
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition.
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all of the defined fields
      ** in the PSDS. They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ Named Constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
     D WConst1         C                   'Settlement09Customer'
     D*WConst2*********C                   'Settlement09AccountC'                             218782
     D WConst2         C                   'Settlement09AccCode '                             218782
     D WConst3         C                   'Settlement09Postings'                             218782
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Bank Details Data Structure
     D LEPD          E DS                  EXTNAME(LE2230PD)
     D                                     OCCURS(2000)
 
      ** Bank Details Data Structure
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** General Ledger Details Data Structure
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
 
      ** Branch Details Data Structure
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
      ** Currency Details Data Structure
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** Account Code Details Data Structure
     D SDACOD        E DS                  EXTNAME(SDACODPD)
     D QQACCD1       E                     EXTFLD(QQACCD)                                     CGL029
 
      ** Account Details Data Structure
     D ACCNTB        E DS                  EXTNAME(ACCNTAB)
     D                                     PREFIX(AC)
 
      ** Nostro Code Details Data Structure
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
     D QQACCD2       E                     EXTFLD(QQACCD)                                     CGL029
 
      ** Switchable Features Data Structure
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** Short Access Object Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long Access Object Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Midas Settlement Details Format
     D SETLIAB       E DS                  EXTNAME(SETLIAB)
 
      ** Midas Settle/Detail Format including Control Parms
     D SETLIAZ       E DS                  EXTNAME(SETLIAZ)
 
      ** Midas Settlement Details Format (Backup)
     D XSETLIB       E DS                  EXTNAME(SETLIAB)
     D                                     PREFIX(X)
 
      ** Midas Settle/Detail Format including Control Parms (Backup)
     D XSETLIZ       E DS                  EXTNAME(SETLIAZ)
     D                                     PREFIX(X)
     D @PARM3        E DS                  EXTNAME(SDSETLPD)                                  222373
 
      ** Transmitted message format
     D PINPP         E DS                  EXTNAME(LES1MFPD)
 
      ** Rundate Details Data Structure
     D RUNDAT        E DS                  EXTNAME(RUNDAT) DTAARA(RUNDAT)
 
      ** SD Layout Details Data Structure
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
 
      ** Midas 24x7 Status Data Structure
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
 
      ** Midas PF Reflecting Data Structure
     D*LEALLO***     E DS                  EXTNAME(LEALLO) DTAARA(LEALLO)                     CLE148
     D LEALLO        E DS                  EXTNAME(LEALLO)                                    CLE148
 
      ** Sequence Number Array A
     D WArSEQN0        S              5  0 DIM(9999)
 
      ** Sequence Number Array B
     D WArSEQN1        S              5  0 DIM(9999)
 
      ** Sequence Number Array
     D WArXSEQ         S              5  0 DIM(9999)
 
      ** Receive Percentage Arrays
     D WArRPcg         S             12  9 DIM(9999)
                                                                                              CLE038
      ** Receive Amount Arrays                                                                CLE038
     D WArRAmt         S             13  0 DIM(9999)                                          CLE038
                                                                                              CLE038
      ** Receive By Amount                                                                    CLE038
     D WArRByAmt       S              1A                                                      CLE038
                                                                                              CLE038
      ** Receive Transaction Amount Arrays                                                    CLE038
     D WArRTAmt        S             13  0 DIM(9999)                                          CLE038
 
      ** Receive Method Arrays
     D WArRMtd         S              2A   DIM(9999)
 
      ** Receive Currency Arrays
     D WArRCcy         S              3A   DIM(9999)
 
      ** Receive Account Arrays
     D*WArRAcc******** S             12A   DIM(9999)                                          CGL029
     D WArRAcc         S             18A   DIM(9999)                                          CGL029
 
      ** Receive Branch Arrays
     D WArRBrc         S              3A   DIM(9999)
 
      ** Pay Percentage Arrays
     D WArPPcg         S             12  9 DIM(9999)
                                                                                              CLE038
      ** Pay Amount Arrays                                                                    CLE038
     D WArPAmt         S             13  0 DIM(9999)                                          CLE038
                                                                                              CLE038
      ** Pay By Amount                                                                        CLE038
     D WArPByAmt       S              1A                                                      CLE038
                                                                                              CLE038
      ** Pay Transaction Amount Arrays                                                        CLE038
     D WArPTAmt        S             13  0 DIM(9999)                                          CLE038
 
      ** Pay Method Arrays
     D WArPMtd         S              2A   DIM(9999)
 
      ** Pay Currency Arrays
     D WArPCcy         S              3A   DIM(9999)
 
      ** Pay Account Arrays
     D*WArPAcc******** S             12A   DIM(9999)                                          CGL029
     D WArPAcc         S             18A   DIM(9999)                                          CGL029
 
      ** Pay Branch Arrays
     D WArPBrc         S              3A   DIM(9999)
 
      ** Receive Currency/Location Input Arrays
     D WArRICL         S              6A   DIM(9999)
 
      ** Receive Currency/Location Output Arrays
     D WArROCL         S              6A   DIM(9999)
 
      ** Receive Currency Output Arrays
     D WArRCcyP        S              3A   DIM(20)
 
      ** Receive Location Output Arrays
     D WArRLocP        S              3A   DIM(20)
 
      ** Pay Currency/Location Input Arrays
     D WArPICL         S              6A   DIM(9999)
 
      ** Pay Currency/Location Output Arrays
     D WArPOCL         S              6A   DIM(9999)
 
      ** Pay Currency Output Arrays
     D WArPCcyP        S              3A   DIM(20)
 
      ** Pay Location Output Arrays
     D WArPLocP        S              3A   DIM(20)
 
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry Parameters
     D PType           S              4A
     D PLnRef          S              6A
     D PLnAmdVDat      S              5A
     D PLnAmdSeq       S              3A
     D PCusFees        S              6A
     D PFclFees        S              5A
     D PFeeSeq         S              2A
     D PMode           S              1A
     D PTimeStamp      S             26A
     D PErrors         S              1A
     D PWarnings       S              1A
     D PSetlNos        S              1A
     D PSetlAmd        S              1A
     D PNoDetails      S              1A
     D PRcvSetlCcy     S             60A
     D PRcvSetlLoc     S             60A
     D PPaySetlCcy     S             60A
     D PPaySetlLoc     S             60A
     D ParentPCRef     S             15A
     D PORED           S              5A                                                      CLE038
     D PAllcAmt        S             13P 0                                                    CLE038
 
      ** Access Object Parameters
     D PRetCode        S              7A
     D POption         S              7A
     D PBranch         S              3A
     D PCurr           S              3A
     D*PAcod********** S              4A                                               CLE034 CGL029
     D PAcod           S             10A                                                      CGL029
     D PSard           S              6A
     D PSysValK1       S             20A
     D PSysVal1        S            200A
     D PSysValK2       S             20A
     D PSysVal2        S            200A
     D PSysValK3       S             20A
     D PSysVal3        S            200A
     D PSysValK4       S             20A
     D PSysVal4        S            200A
     D PSysValK5       S             20A
     D PSysVal5        S            200A
     D PSysValK6       S             20A
     D PSysVal6        S            200A
     D PSysValK7       S             20A
     D PSysVal7        S            200A
     D PSysValK8       S             20A
     D PSysVal8        S            200A
     D PSysValK9       S             20A
     D PSysVal9        S            200A
     D PSysValK10      S             20A
     D PSysVal10       S            200A
     D PRETL           S             10A
     D PCNUM           S              6A
     D PACID           S             10A
     D PCYCD           S              3A
     D*PACCD****       S              4A                                                      CGL029
     D PACCD           S             10A                                                      CGL029
     D PACSQ           S              2A
     D PBRCA           S              3A
     D PTYPA           S              7A
     D PNONB           S              2A
     D PPNOI           S              1A
     D P#FMT           S            400A
 
      ** LE2031 Parameters
     D PInvFilNm       S              8A
     D PRprNum         S              5  0
     D PSupSysOn       S              1A
     D PPCTrnRef       S             15A
     D PTrnTmStm       S             26Z
 
      ** Y2SNMGC/Y2RVMGC Parameters
     D ZAPGMQ          S             10A
     D ZAPGRL          S              5A
     D ZAMSID          S              7A
     D ERCD            S              3A
     D ZAMSGF          S             10A
     D ZAMSDA          S            132A
     D ZAMSTP          S              7A
     D ZAMSTX          S            132A
 
      ** ZEDIT/ZASIGN Parameters
     D ZAsignOk        S              1A
     D ZField          S             16A
     D ZADEC           S              1P 0
     D ZADIG           S              2P 0
     D ZFLD17          S             17A
     D ZSDCSP          S              1A
     D ZOUT15          S             15A
     D ZFSIGN          S              1A
     D  ZRATE1         S             13P 8                                                    CLE038
     D  ZMDI1          S              1A                                                      CLE038
     D  ZRATE2         S             13P 8                                                    CLE038
     D  ZMDI2          S              1A                                                      CLE038
     D  ZRATEX         S             13P 8                                                    CLE038
     D  ZMDIX          S              1A                                                      CLE038
     D ZAMTCI          S             15P 0                                                    CLE038
     D ZEXCH           S             13P 8                                                    CLE038
     D ZMD             S              1A                                                      CLE038
     D ZCCYI           S              3A                                                      CLE038
     D ZCCYO           S              3A                                                      CLE038
     D ZCDPI           S              1P 0                                                    CLE038
     D ZCDPO           S              1P 0                                                    CLE038
     D ZAMTCO          S             15P 0                                                    CLE038
 
      ** ZDATE9 Parameters
     D ZDateIn         S              5  0
     D ZDateOut        S              8  0
     D ZRTN            S              1A
 
      ** Key Fields
     D WType           S              4A
     D*WLnRef***       S              6  0                                                    CLE148
     D WLnRef          S              6                                                       CLE148
     D WLnAmdVDat      S              5  0
     D WLnAmdVDatA     S              8A
     D WLnAmdSeq       S              3  0
     D*WCusFees*       S              6  0                                                    CSD027
     D WCusFees        S              6A                                                      CSD027
     D WFclFees        S              5  0
     D WFeeSeq         S              2  0
     D WMode           S              1A
     D WTimeStamp      S             26Z
     D WSequence       S              5  0
     D WMsgType        S              8A
     D WFrOffId        S             20
 
      ** Working Variables
     D CEU004          S              1A
     D CLE031          S              1A
     D CLE033          S              1A
     D CLE038          S              1A                                                      CLE038
     D CSC011          S              1A
     D WRRN0           S              4  0
     D WRRN1           S              4  0
     D WSRRN0          S              4  0
     D WSRRN1          S              4  0
     D WCnt1           S              4  0
     D WCnt2           S              4  0
     D WCntC           S              4  0
     D WCntX           S              4  0
     D WcR             S              4  0
     D WcX             S              4  0
     D WRMax           S              4  0
     D WFormat         S              4A
     D WRcvInCcy       S              3A
     D WPayInCcy       S              3A
     D WRecSpot        S             13P 8                                                    CLE038
     D WPaySpot        S             13P 8                                                    CLE038
     D WRecMDI         S              1A                                                      CLE038
     D WPayMDI         S              1A                                                      CLE038
     D WRecDP          S              1S 0                                                    CLE038
     D WPayDP          S              1S 0                                                    CLE038
     D WSCcyDP         S              1S 0                                                    CLE038
     D WRcvSetlCcy     S              3A
     D WPaySetlCcy     S              3A
     D WRcvSetlLoc     S              3A
     D WPaySetlLoc     S              3A
     D WSupSys         S              1A
     D WPRInd          S              1A
     D WSAction        S              1A
     D WSPercentage    S             13A
     D WSAmount        S             14A                                                      CLE038
     D WSByAmt         S              1A                                                      CLE038
     D WSMethod        S              2A
     D WSCurrency      S              3A
     D*WSAccount****** S             15A                                                      CGL029
     D WSAccount       S             21A                                                      CGL029
     D WSBranch        S              3A
     D WTotRcv         S             12  9
     D WFTotRcv        S             12  9
     D WTotPay         S             12  9
     D WFTotPay        S             12  9
     D WTotRcvAmt      S             13  0                                                    CLE038
     D WFTotRAmt       S             13  0                                                    CLE038
     D WFTotRTAmt      S             13  0                                                    CLE038
     D WTotPayAmt      S             13  0                                                    CLE038
     D WFTotPAmt       S             13  0                                                    CLE038
     D WFTotPTAmt      S             13  0                                                    CLE038
     D WPercentNum     S             12  9
     D WAmountNum      S             13  0                                                    CLE038
     D WInCurrency     S              1A
     D WSetlCcy        S              3A
     D WrkACID         S             10A
     D WrkCYCD         S              3A
     D*WrkACCD******** S              4A                                                      CGL029
     D WrkACCD         S             10A                                                      CGL029
     D WrkACSQ         S              2A
     D WrkBRCA         S              3A
     D WrkCNUM         S              6A
     D WrkNONB         S              2A
     D*WAccount******* S             12A                                                      CGL029
     D WAccount        S             18A                                                      CGL029
     D WAcodSeq        S             12A                                                      CSD031
     D WNostro         S              2A
     D WCustomer       S              6A
     D WRetail         S             10A
     D WCompDat        S              5  0
     D WLogValid       S              1A
     D WSetl09Cus      S              6A
     D*WSetl09AcCd**** S              4A                                                      CGL029
     D WSetl09AcCd     S             10A                                                      CGL029
     D WSetl09Ccy      S              1A                                                      218782
     D WrkSequence     S              5  0
     D WAction         S              1A
     D WVErr           S              1A
     D WPErr           S              1A
     D WMErr           S              1A
     D WCErr           S              1A
     D WAErr           S              1A
     D WTErr           S              1A
     D WXErr           S              1A
     D WBErr           S              1A                                                      CLE038
     D WOErr           S              1A                                                      CLE038
     D WRCcyLoc        S              6A
     D WPCcyLoc        S              6A
     D WcI             S              4  0
     D WcO             S              4  0
     D WError          S              1A
     D*PCNEXT***       S              8  0                                                    CLE148
     D PCNEXT          S              8A                                                      CLE148
     D PCNEXTA         S              8A
     D WXAction        S              1A
     D WF9             S              1A
     D WFirst          S              1A
     D XACTC           S              1A
     D XPRCV           S              1A
     D XPPAY           S              1A
     D WACTC           S              1A
     D WPRCV           S              1A
     D WPPAY           S              1A
     D WMFSequence     S              4  0
     D WTMST           S             26A
     D WBefore         S              1A                                                      219608
     D PRTCD           S              7A                                                      CLE148
     D PUPDT           S              1A                                                      CLE148
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +---------------- Start of Main Processing ------------------+
      ** ¦                                                            ¦
      ** ¦  *INZSR is automatically executed at program activation.   ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
     C                   EXSR      SRINIT
 
     C                   DOU       WFormat = 'END'
 
     C                   IF        WFormat = 'SUB'
     C                   EXSR      SRLOAD
     C                   ENDIF
 
     C                   IF        WFormat = 'DET'
     C                   EXSR      SRFLDT
     C                   ENDIF
 
     C                   IF        WFormat = 'VAL'
     C                   EXSR      SRVAL
     C                   ENDIF
 
     C                   IF        WFormat = 'FULL'
     C                   EXSR      SRFULL
     C                   ENDIF
 
     C                   IF        WFormat = 'DB'
     C                   EXSR      SRDB
     C                   ENDIF
 
     C                   IF        WFormat = 'END'
     C                   EXSR      SREND
     C                   ENDIF
 
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINIT - Initialisation subroutine                           *
      *                                                               *
      *****************************************************************
     C     SRINIT        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PType
     C                   PARM                    PLnRef
     C                   PARM                    PLnAmdVDat
     C                   PARM                    PLnAmdSeq
     C                   PARM                    PCusFees
     C                   PARM                    PFclFees
     C                   PARM                    PFeeSeq
     C                   PARM                    SETLIAB
     C                   PARM                    SETLIAZ
     C                   PARM                    PMode
     C                   PARM                    PTimeStamp
     C                   PARM                    PErrors
     C                   PARM                    PWarnings
     C                   PARM                    PSetlNos
     C                   PARM                    PSetlAmd
     C                   PARM                    PNoDetails
     C                   PARM                    PRcvSetlCcy
     C                   PARM                    PRcvSetlLoc
     C                   PARM                    PPaySetlCcy
     C                   PARM                    PPaySetlLoc
     C                   PARM                    ParentPCRef
     C                   PARM                    PORED                                        CLE038
     C                   PARM                    PAllcAmt                                     CLE038
 
     C                   EVAL      WFirst = 'Y'
     C                   EVAL      WBefore = ' '                                              219608
 
     C                   IF        PMPRCV = 'Y' AND
     C                             PMACTC <> 'E' AND
     C                             PMACTC <> 'D'
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN60 = *ON
     C                   ENDIF
 
     C                   IF        PMPPAY = 'Y' AND
     C                             PMACTC <> 'E' AND
     C                             PMACTC <> 'D'
     C                   EVAL      *IN41 = *ON
     C                   EVAL      *IN61 = *ON
     C                   ENDIF
 
     C                   IF        PMode <> 'B'
     C                   OPEN      LE2230DF
     C                   ENDIF
 
     C                   SELECT
 
     C                   WHEN      PMACTC = 'D'
     C                   EVAL      WFormat = 'END'
     C                   EVAL      PMCMDP = '12'                                              221960
     C                   WHEN      PMACTC = 'I'
     C                   EVAL      WAction = 'I'
     C                   EVAL      WFormat = 'DET'
 
     C                   OTHER
     C                   EVAL      WAction = PMACTC
     C                   IF        WAction = 'X'
     C                   EVAL      WAction = 'E'
     C                   ENDIF
     C                   EVAL      WFormat = 'SUB'
 
     C                   ENDSL
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = '*CALL'
     C                   EVAL      DBASE = 1
     C                   EVAL      PMDBSE = DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access General Ledger Details
 
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDGELR        PARM      SDGELR        DSSDY
 
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDGELRPD'
     C                   EVAL      DBKEY = '*CALL'
     C                   EVAL      DBASE = 2
     C                   EVAL      PMDBSE = DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Get Receive Currency Details
 
     C                   EVAL      PCurr = PMRCCY
     C                   EXSR      SRAOCURR
 
     C                   IF        PRetCode = *BLANKS
     C                   EVAL      WRcvInCcy = A6INCY
     C                   EVAL      WRecDP    = A6NBDP                                         CLE038
     C                   EVAL      WRecSpot  = A6SPRT                                         CLE038
     C                   EVAL      WRecMDI   = A6MDIN                                         CLE038
     C                   ENDIF
 
      ** Get Pay Currency Details
 
     C                   EVAL      PCurr = PMPCCY
     C                   EXSR      SRAOCURR
 
     C                   IF        PRetCode = *BLANKS
     C                   EVAL      WPayInCcy = A6INCY
     C                   EVAL      WPayDP    = A6NBDP                                         CLE038
     C                   EVAL      WPaySpot  = A6SPRT                                         CLE038
     C                   EVAL      WPayMDI   = A6MDIN                                         CLE038
     C                   ENDIF
 
      ** Check if Switchable Feature CSC011 (24x7 Midas Availability) is on
 
     C                   EVAL      CSC011 = 'N'
     C                   EVAL      PSard = 'CSC011'
     C                   EXSR      SRAOSARD
 
     C                   IF        PRetCode = *BLANKS
     C                   EVAL      CSC011 = 'Y'
     C                   ENDIF
 
      ** Check if Switchable Feature CEU004 (Transaction Settlement - Lending) is on
 
     C                   EVAL      CEU004 = 'N'
     C                   EVAL      PSard = 'CEU004'
     C                   EXSR      SRAOSARD
 
     C                   IF        PRetCode = *BLANKS
     C                   EVAL      CEU004 = 'Y'
     C                   ENDIF
 
      ** Check if Switchable Feature CLE031 (Lending Enhancements) is on
 
     C                   EVAL      CLE031 = 'N'
     C                   EVAL      PSard = 'CLE031'
     C                   EXSR      SRAOSARD
 
     C                   IF        PRetCode = *BLANKS
     C                   EVAL      CLE031 = 'Y'
     C                   ENDIF
                                                                                              CLE038
      ** Check if Switchable Feature CLE038 is on                                             CLE038
                                                                                              CLE038
     C                   EVAL      CLE038 = 'N'                                               CLE038
     C                   EVAL      PSard = 'CLE038'                                           CLE038
     C                   EXSR      SRAOSARD                                                   CLE038
                                                                                              CLE038
     C                   IF        PRetCode = *BLANKS                                         CLE038
     C                   EVAL      CLE038 = 'Y'                                               CLE038
     C     PType         IFEQ      'LAPI'                                                     CLE038
     C     PType         OREQ      'LOAN'                                                     CLE038
     C     PType         OREQ      'PTSO'                                                     CLE038
     C                   SETON                                        51                      CLE038
     C                   ENDIF                                                                CLE038
     C                   ENDIF                                                                CLE038
                                                                                              CLE038
 
      ** Check if Switchable Feature CLE033 is on
 
     C                   EVAL      CLE033 = 'N'
     C                   EVAL      PSard = 'CLE033'
     C                   EXSR      SRAOSARD
 
     C                   IF        PRetCode = *BLANKS
     C                   EVAL      CLE033 = 'Y'
     C                   ENDIF
 
      ** If CLE033 is on
 
     C                   IF        CLE033 = 'Y'
 
      ** Retrieve Settlement 09 Customer
      ** & Settlement09Postings value - use settlement currency?                              218782
 
     C                   EVAL      PSysValK1 = WConst1
     C                   EVAL      PSysValK2 = WConst3                                        218782
     C                   EXSR      SRAOSVAL
 
     C                   IF        PRetCode = *BLANKS
     C                   EVAL      WSetl09Cus = PSysVal1
     C                   EVAL      WSetl09Ccy = PSysVal2                                      218782
     C                   ENDIF
 
      ** Retrieve Settlement 09 Account Code
 
     C                   EVAL      PSysValK1 = WConst2
     C                   EXSR      SRAOSVAL
 
     C                   IF        PRetCode = *BLANKS
     C                   EVAL      WSetl09AcCd = PSysVal1
     C                   ENDIF
 
      ** Get Account Code Details of Settlement 09
 
     C                   EVAL      PAcod = WSetl09AcCd
     C                   EXSR      SRAOACOD
 
     C                   ENDIF
 
      ** Set Settle Amended to blanks
 
     C                   EVAL      PSetlAmd = *BLANKS
 
      ** Set the system information display fields
 
     C                   EVAL      #0RUNA = BJMRDT
     C                   EVAL      #1RUNA = BJMRDT
     C                   EVAL      #0USER = PSUser
     C                   EVAL      #1USER = PSUser
     C                   EVAL      #0WSID = PSJobName
     C                   EVAL      #1WSID = PSJobName
     C                   EVAL      #1PGMQ = PSProcMod
     C                   EVAL      ZAPGMQ = PSProcName
     C                   EVAL      ZAMSGF = 'GBDRSMM'
     C                   EVAL      #0TRTY = PType
     C                   IF        PType = 'PTSO'                                             CLE038
     C                   EVAL      #0TRTY = 'LOAN'                                            CLE038
     C                   ENDIF                                                                CLE038
     C                   IF        PType = 'FEES'
     C                   EVAL      %SUBST(#0KEY:1:6) = PCusFees
     C                   EVAL      %SUBST(#0KEY:8:5) = PFclFees
     C                   EVAL      %SUBST(#0KEY:14:2) = PFeeSeq
     C                   EVAL      %SUBST(#1KEY:1:6) = PCusFees
     C                   EVAL      %SUBST(#1KEY:8:5) = PFclFees
     C                   EVAL      %SUBST(#1KEY:14:2) = PFeeSeq
     C                   ELSE
     C                   EVAL      #0KEY = PLnRef
     C                   EVAL      #1KEY = PLnRef
     C                   ENDIF
     C                   EVAL      #0CCY = PMRCCY
     C                   EVAL      #1TRTY = PType
     C                   IF        PType = 'PTSO'                                             CLE038
     C                   EVAL      #1TRTY = 'LOAN'                                            CLE038
     C                   ENDIF                                                                CLE038
     C                   EVAL      #1CCY = PMRCCY
     C     CLE038        IFEQ      'Y'                                                        CLE038
     C     PType         IFEQ      'LOAN'                                                     CLE038
     C     PType         OREQ      'PTSO'                                                     CLE038
     C     PType         OREQ      'LAPI'                                                     CLE038
     C                   EVAL      PCurr = PMRCCY                                             CLE038
     C                   EXSR      SRAOCURR                                                   CLE038
     C                   MOVE      *BLANKS       ZField                                       CLE038
     C                   MOVE      PAllcAmt      ZField                                       CLE038
     C                   Z-ADD     A6NBDP        ZADEC                                        CLE038
     C                   EXSR      ZEDIT                                                      CLE038
     C                   MOVE      ZField        #1AMT                                        CLE038
     C                   MOVE      ZField        #0AMT                                        CLE038
     C                   ENDIF                                                                CLE038
     C                   ENDIF                                                                CLE038
 
      ** Retrieve dataarea details
 
     C                   IN        RUNDAT
     C                   IN        SDSTAT
     C                   IN        SC24X7
 
     C                   EVAL      *IN92 = *ON
 
     C                   EVAL      XSETLIB = SETLIAB
     C                   EVAL      XSETLIZ = SETLIAZ
     C                   EVAL      XACTC = PMACTC
     C                   EVAL      XPRCV = PMPRCV
     C                   EVAL      XPPAY = PMPPAY
 
     C                   IF        PMode = 'B' AND
     C                             PMACTC <> 'D'
     C                   EVAL      WFormat = 'END'
     C                   EXSR      SRBATCH
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSUB - Subfile subroutine                                   *
      *                                                               *
      *****************************************************************
     C     SRSUB         BEGSR
 
     C                   DOU       WVErr = 'N'
 
     C                   IF        WVErr = 'Y'
     C                   IF        WTErr <> 'Y'
     C                   EVAL      *IN90 = *ON
     C                   UPDATE    LE2230S1
     C                   EVAL      *IN90 = *OFF
     C                   ELSE
     C                   EVAL      WRRN0 = 1
     C                   ENDIF
     C                   WRITE     LE2230C2
     C                   ENDIF
 
     C                   EVAL      WSAction = ' '
     C                   EVAL      WF9 = 'N'
     C                   EVAL      WVErr = 'N'
     C                   EVAL      WTErr = 'N'
     C                   EXSR      SRCLRM
     C                   IF        WAction <> 'D'
     C                   MOVEA     *ZEROS        WArSEQN1
     C                   ENDIF
 
     C                   WRITE     LE2230F1
 
     C                   EVAL      #1RLRN = 1
     C                   WRITE     LE2230C1
     C                   READ      LE2230C1
 
     C                   SELECT
 
     C                   WHEN      *INKC = *ON
     C                   EVAL      PMCMDP = '03'
     C                   EVAL      WFormat = 'END'
 
     C                   WHEN      *INKL = *ON
     C                   EVAL      PMCMDP = '12'
     C                   EVAL      WFormat = 'END'
 
     C                   WHEN      *INKI = *ON  AND
     C                             WAction = 'A'
     C                   EVAL      WF9 = 'Y'
     C                   EVAL      WFormat = 'DET'
 
     C                   OTHER
 
     C                   IF        WAction <> 'D'
 
     C                   READC     LE2230S1                               15
 
     C                   EVAL      WCnt1 = *ZERO
 
     C                   DOW       *IN15 = *OFF
 
     C                   EVAL      WSAction = #1ACTN
 
     C                   IF        PMode <> 'F'
 
     C                   IF        WAction = 'E' AND
     C                             WSAction <> 'E' AND
     C                             WSAction <> ' ' OR
     C                             WAction = 'A' AND
     C                             WSAction <> 'A' AND
     C                             WSAction <> 'D' AND
     C                             WSAction <> 'E' AND
     C                             WSAction <> ' '
     C                   EVAL      ZAMSID = 'ESM0820'
     C                   EXSR      ZASNMS
     C                   EVAL      *IN21 = *ON
     C                   EVAL      WVErr = 'Y'
     C                   LEAVE
     C                   ELSE
     C                   IF        WXAction <> *BLANKS AND
     C                             WXAction <> WSAction
     C                   EVAL      ZAMSID = 'ESM0826'
     C                   EXSR      ZASNMS
     C                   EVAL      *IN21 = *ON
     C                   EVAL      WVErr = 'Y'
     C                   LEAVE
     C                   ENDIF
     C                   EVAL      WXAction = WSAction
     C                   ENDIF
 
     C                   IF        WVErr <> 'Y' AND
     C                             WSAction <> ' '
     C                   EVAL      WXAction = *BLANKS
     C                   EVAL      WCnt1 = WCnt1 + 1
     C                   EVAL      WArSEQN1(WCnt1) = #1SEQ
     C                   IF        WAction = 'D' OR
     C                             WAction = 'A' AND
     C                             WSAction <> 'E'
     C                   EVAL      WFormat = 'DET'
     C                   ELSE
     C                   IF        WAction = 'E' OR
     C                             WSAction = 'E'
     C                   EVAL      WArSEQN1(WCnt1) = #1SEQ
     C                   EVAL      WFormat = 'FULL'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        WSAction = 'U' OR
     C                             WSAction = 'Q'
     C                   IF        WSAction = 'U'
     C                   EVAL      WrkSequence = WRRN0
     C                   EVAL      WCnt1 = WRRN0
     C                   EVAL      WCnt1 = WCnt1 + 1
     C                   EVAL      WFormat = 'DET'
     C                   ENDIF
     C                   IF        WAction = 'Q'
     C                   EXSR      SRINVL
     C                   ENDIF
     C                   ELSE
     C                   EVAL      ZAMSID = 'ESM0820'
     C                   EXSR      ZASNMS
     C                   EVAL      *IN21 = *ON
     C                   EVAL      WVErr = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   READC     LE2230S1                               15
     C                   ENDDO
 
     C                   ELSE
 
     C                   EVAL      WFormat = 'DB'
 
     C                   ENDIF
 
     C                   ENDSL
     C                   ENDDO
 
     C                   EXSR      SRCLRM
     C                   WRITE     LE2230C2
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINVL - Invalid subroutine                                  *
      *                                                               *
      *****************************************************************
     C     SRINVL        BEGSR
 
     C                   IN        SDSTAT
     C                   IN        SC24X7
 
     C                   IF        CSC011 = *ON AND
     C                             S1SUPP = LIBR
     C                   EVAL      WSupSys = 'Y'
     C                   ELSE
     C                   EVAL      WSupSys = 'N'
     C                   ENDIF
 
      ** Call invalid lending transaction maintenance
 
     C                   CALL      'LE2031'
     C                   PARM      'LEISTLPD'    PInvFilNm
     C                   PARM      XREPN         PRprNum
     C**********         PARM      WSupSys       PSupSysOn                                    222373
     C**********         PARM      IPCRF         PPCTrnRef                                    222373
     C**********         PARM      ITMST         PTrnTmStm                                    222373
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRLOAD - Load subfile subroutine                             *
      *                                                               *
      *****************************************************************
     C     SRLOAD        BEGSR
 
     C                   EVAL      WType = PType
     C                   IF        PType = 'PTSO'                                             CLE038
     C                   EVAL      WType = 'LOAN'                                             CLE038
     C                   ENDIF                                                                CLE038
     C                   MOVE      PLnRef        WLnRef
     C                   MOVE      PLnAmdVDat    WLnAmdVDat
     C                   MOVE      PLnAmdVDat    WLnAmdVDatA
     C                   MOVE      PLnAmdSeq     WLnAmdSeq
     C                   MOVE      PCusFees      WCusFees
     C                   MOVE      PFclFees      WFclFees
     C                   MOVE      PFeeSeq       WFeeSeq
 
      ** If mode is repair
 
     C                   IF        PMode = 'F'
 
     C     KFLDS3        SETLL     LEISTL1
     C     KFLDS3        READE     LEISTL1
 
     C                   IF        NOT %FOUND(LEISTLL1)
     C                   EVAL      PNoDetails = 'Y'
     C                   EVAL      WFormat = 'DET'
     C                   ELSE
 
     C                   EVAL      WRRN0 = *ZERO
     C                   EVAL      WcntX = *ZERO
 
     C                   EVAL      *IN97 = *ON
     C                   WRITE     LE2230C0
     C                   EVAL      *IN97 = *OFF
 
     C                   EVAL      *IN98 = *ON
 
     C                   DOW       %FOUND(LEISTLL1) AND
     C                             *IN98 = *ON
 
     C                   EVAL      WCntX = *ZERO
     C                   EVAL      *IN21 = *OFF
     C                   EVAL      *IN22 = *OFF
     C                   EVAL      *IN23 = *OFF
     C                   EVAL      *IN24 = *OFF
     C                   EVAL      *IN25 = *OFF
     C                   EVAL      *IN26 = *OFF
     C                   EVAL      *IN27 = *OFF
     C                   EVAL      *IN28 = *OFF
 
     C                   DOW       %FOUND(LEISTLL1) AND
     C                             WCntX < 13
 
     C                   EVAL      WRRN0 = WRRN0 + 1
     C                   EVAL      WCntX = WCntX + 1
 
      ** Receive Settlement
 
     C                   EVAL      #0RPCG = IRCPC
     C                   EVAL      #0RAMT = IRCPC                                             CLE038
     C                   EVAL      #0RCBA = IRCBA                                             CLE038
     C     #0RCBA        IFNE      'A'                                                        CLE038
     C                   SETON                                        52                      CLE038
     C                   ELSE                                                                 CLE038
     C                   EVAL      #0RAMT = IRCAM                                             CLE038
     C                   SETOFF                                       52                      CLE038
     C                   ENDIF                                                                CLE038
     C                   EVAL      #0RMTD = IRSTM
     C                   EVAL      #0RCCY = IRSCY
     C                   IF        IRSTM = '05' OR
     C                             CLE033 = 'Y' AND
     C                             IRSTM = '09'
     C                   EVAL      #0RACC = IRONS
     C                   ELSE
     C**********         EVAL      #0RACC = %SUBST(IRONS:4:12)                                CGL029
     C                   EVAL      #0RACC = %SUBST(IRONS:4:18)                                CGL029
     C                   ENDIF
 
      ** Payment Settlement
 
     C                   EVAL      #0PPCG = IPYPC
     C                   EVAL      #0PAMT = IPYPC                                             CLE038
     C                   EVAL      #0PYBA = IPYBA                                             CLE038
     C     #0PYBA        IFNE      'A'                                                        CLE038
     C                   SETON                                        53                      CLE038
     C                   ELSE                                                                 CLE038
     C                   EVAL      #0PAMT = IPYAM                                             CLE038
     C                   SETOFF                                       53                      CLE038
     C                   ENDIF                                                                CLE038
     C                   EVAL      #0PMTD = IPSTM
     C                   EVAL      #0PCCY = IPSCY
     C                   IF        IPSTM = '05' OR
     C                             CLE033 = 'Y' AND
     C                             IPSTM = '09'
     C                   EVAL      #0PACC = IPONS
     C                   ELSE
     C**********         EVAL      #0PACC = %SUBST(IPONS:4:12)                                CGL029
     C                   EVAL      #0PACC = %SUBST(IPONS:4:18)                                CGL029
     C                   ENDIF
 
     C                   WRITE     LE2230S0
 
     C     KFLDS3        READE     LEISTL1
     C                   ENDDO
 
     C                   EVAL      WSRRN0 = WRRN0
     C                   EXSR      SRSUB
     C                   ENDDO
 
     C                   ENDIF
 
      ** Not repair mode
 
     C                   ELSE
 
     C                   SELECT
     C                   WHEN      WAction = 'E' OR
     C                             WAction = 'D'
     C                   EVAL      *IN80 = *ON
     C                   EVAL      *IN81 = *OFF
     C                   EVAL      *IN82 = *OFF
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN41 = *ON
     C                   IF        WAction = 'D'
     C                   EVAL      *IN46 = *ON
     C                   ENDIF
     C                   WHEN      WAction = 'A'
     C                   EVAL      *IN81 = *ON
     C                   EVAL      *IN80 = *OFF
     C                   EVAL      *IN82 = *OFF
     C                   IF        *IN60 = *OFF
     C                   EVAL      *IN40 = *OFF
     C                   ENDIF
     C                   IF        *IN61 = *OFF
     C                   EVAL      *IN41 = *OFF
     C                   ENDIF
     C                   ENDSL
 
      ** Get the latest sequence (including deleted records)
 
     C     KFLDS5        SETLL     LESTAL9
     C     KFLDS5        READE(N)  LESTAL9                                50
 
     C                   DOW       *IN50 = *OFF
     C                   EVAL      WMFSequence = SEQ
     C     KFLDS5        READE     LESTAL9                                50
     C                   ENDDO
 
      ** Load subfile of live records
 
     C     KFLDS5        SETLL     LESTAL5
     C     KFLDS5        READE(N)  LESTAL5                                96
 
     C                   EXSR      SRDEFT
 
     C                   IF        *IN96 = *ON
     C                   EVAL      PNoDetails = 'Y'
     C                   EVAL      WFormat = 'DET'
     C                   IF        WAction = 'D' OR
     C                             WAction = 'E'
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN41 = *ON
     C                   EVAL      *IN60 = *ON
     C                   EVAL      *IN61 = *ON
     C                   ENDIF
     C                   ELSE
 
     C                   MOVE      TMST          PTimeStamp
     C                   EVAL      *IN21 = *OFF
     C                   EVAL      WRRN1 = *ZERO
     C                   EVAL      WFTotRcv = *ZERO
     C                   EVAL      WFTotPay = *ZERO
     C                   EVAL      WFTotRAmt = *ZERO                                          CLE038
     C                   EVAL      WFTotPAmt = *ZERO                                          CLE038
     C                   EVAL      WFTotRTAmt = *ZERO                                         CLE038
     C                   EVAL      WFTotPTAmt = *ZERO                                         CLE038
 
     C                   EVAL      *IN97 = *ON
     C                   WRITE     LE2230C1
     C                   EVAL      *IN97 = *OFF
 
     C                   DOW       *IN96 = *OFF
      *                                                                                       219608
      ** Save 'before' image of Settlement Allocation (but                                    219608
      ** not in batch mode as LE2240 has already done it).                                    219608
      *                                                                                       219608
     C                   IF        PMode <> 'B' AND                                           219608
     C                             WBefore <> 'Y'                                             219608
     C                   IF        WAction = 'D' OR                                           219608
     C                             WAction = 'A'                                              219608
     C                   OPEN      LEBSTLPD                                                   219608
     C                   WRITE     LEBSTLD0                                                   219608
     C                   CLOSE     LEBSTLPD                                                   219608
     C                   ENDIF                                                                219608
     C                   ENDIF                                                                219608
 
     C                   EVAL      WRRN1 = WRRN1 + 1
     C                   EVAL      #1ACTN = *BLANKS
     C                   EVAL      #1SEQ = SEQ
     C                   IF        WAction = 'D'
     C                   EVAL      WArSEQN1(WRRN1) = SEQ
     C                   ENDIF
     C                   EVAL      WFTotRcv = WFTotRcv + RCPC
     C                   EVAL      WFTotPay = WFTotPay + PYPC
 
      ** Receive Settlement
 
     C                   IF        WAction = 'E' OR
     C                             WAction = 'D' OR
     C                             WAction = 'A' AND
     C                             *IN60 = *OFF
 
     C                   MOVE      *BLANKS       ZField
     C                   MOVE      RCPC          ZField
     C                   Z-ADD     9             ZADEC
     C                   EXSR      ZEDIT
     C**********         MOVE      ZField        #1RPCG                                       CLE038
     C                   MOVE      ZField        #1RAMT                                       CLE038
     C                   EVAL      #1RMTD = RSTM
     C                   EVAL      #1RCCY = RSCY
     C                   IF        RSTM = '05' OR
     C                             CLE033 = 'Y' AND
     C                             RSTM = '09'
     C                   EVAL      #1RACC = ROBR + RONS
     C                   ELSE
     C                   EVAL      #1RACC = RONS
     C                   ENDIF
     C                   EVAL      #1RCBA = RCBA                                              CLE038
     C     #1RCBA        IFNE      'A'                                                        CLE038
     C                   SETON                                        52                      CLE038
     C                   ELSE                                                                 CLE038
     C                   SETOFF                                       52                      CLE038
     C                   ENDIF                                                                CLE038
     C                   EVAL      PCurr = #1RCCY                                             CLE038
     C     #1RCCY        IFEQ      *BLANKS                                                    CLE038
     C     RSTM          OREQ      '09'                                                       CLE038
     C     CLE033        ANDEQ     'Y'                                                        CLE038
     C     WSetl09Ccy    ANDEQ     'T'                                                        CLE038
     C                   EVAL      PCurr = PMRCCY                                             CLE038
     C                   ENDIF                                                                CLE038
     C                   EXSR      SRAOCURR                                                   CLE038
     C     CLE038        IFEQ      'Y'                                                        CLE038
     C     #1RCBA        ANDEQ     'A'                                                        CLE038
     C                   MOVE      *BLANKS       ZField                                       CLE038
     C                   MOVE      RCAM          ZField                                       CLE038
     C                   Z-ADD     A6NBDP        ZADEC                                        CLE038
     C                   EXSR      ZEDIT                                                      CLE038
     C                   MOVE      ZField        #1RAMT                                       CLE038
     C                   EVAL      WFTotRAmt = RCAM                                           CLE038
     C     #1RCCY        IFEQ      PMRCCY                                                     CLE038
     C     #1RCCY        OREQ      *BLANKS                                                    CLE038
     C     RSTM          OREQ      '09'                                                       CLE038
     C     WSetl09Ccy    ANDEQ     'T'                                                        CLE038
     C                   EVAL      WFTotRTAmt = WFTotRTAmt + RCAM                             CLE038
     C                   ELSE                                                                 CLE038
     C     #1REXR        IFEQ      *BLANKS                                                    CLE038
     C                   Z-ADD     *ZEROS        WKREXR                                       CLE038
     C                   ELSE                                                                 CLE038
     C                   MOVE      *BLANKS       ZFld17                                       CLE038
     C                   MOVE      #1REXR        ZFld17                                       CLE038
     C                   Z-ADD     8             ZADEC                                        CLE038
     C                   Z-ADD     5             ZADIG                                        CLE038
     C                   EXSR      ZASIGN                                                     CLE038
     C                   Z-ADD     *ZEROS        WKREXR                                       CLE038
     C                   MOVE      ZOUT15        WKREXR           13 8                        CLE038
     C                   IF        ZAsignOk = 'N'                                             CLE038
     C                   Z-ADD     *ZEROS        WKREXR                                       CLE038
     C                   ENDIF                                                                CLE038
     C                   ENDIF                                                                CLE038
     C     WKREXR        IFEQ      0                                                          CLE038
     C                   Z-ADD     A6SPRT        ZRATE1                                       CLE038
     C                   MOVE      A6MDIN        ZMDI1                                        CLE038
     C                   Z-ADD     WRecSpot      ZRATE2                                       CLE038
     C                   MOVE      WRecMDI       ZMDI2                                        CLE038
     C                   EXSR      ZXRATE                                                     CLE038
     C                   Z-ADD     ZRATEX        ZEXCH                                        CLE038
     C                   MOVE      ZMDIX         ZMD                                          CLE038
     C                   ELSE                                                                 CLE038
     C                   Z-ADD     WKREXR        ZEXCH                                        CLE038
     C     #1REXI        IFEQ      'M'                                                        CLE038
     C                   MOVEL     'D'           ZMD                                          CLE038
     C                   ELSE                                                                 CLE038
     C                   MOVEL     'M'           ZMD                                          CLE038
     C                   ENDIF                                                                CLE038
     C                   ENDIF                                                                CLE038
      *                                                                                       CLE038
     C                   MOVE      #1RCCY        ZCCYI                                        CLE038
     C                   MOVE      PMRCCY        ZCCYO                                        CLE038
     C                   MOVE      A6NBDP        ZCDPI                                        CLE038
     C                   MOVE      WRecDP        ZCDPO                                        CLE038
     C                   Z-ADD     RCAM          ZAMTCI                                       CLE038
     C                   EXSR      ZCONV                                                      CLE038
     C                   EVAL      WFTotRTAmt = WFTotRTAmt + ZAMTCO                           CLE038
     C                   ENDIF                                                                CLE038
     C                   ENDIF                                                                CLE038
 
     C                   ENDIF
     C                   IF        WAction = 'A' AND                                          CLE038
     C                             *IN60 = *ON                                                CLE038
     C                   EVAL      #1RCBA = RCBA                                              CLE038
     C     #1RCBA        IFNE      'A'                                                        CLE038
     C                   SETON                                        52                      CLE038
     C                   ELSE                                                                 CLE038
     C                   SETOFF                                       52                      CLE038
     C                   ENDIF                                                                CLE038
     C                   ENDIF                                                                CLE038
 
      ** Payment Settlement
 
     C                   IF        WAction = 'E' OR
     C                             WAction = 'D' OR
     C                             WAction = 'A' AND
     C                             *IN61 = *OFF
 
     C                   MOVE      *BLANKS       ZField
     C                   MOVE      PYPC          ZField
     C                   Z-ADD     9             ZADEC
     C                   EXSR      ZEDIT
     C**********         MOVE      ZField        #1PPCG                                       CLE038
     C                   MOVE      ZField        #1PAMT                                       CLE038
     C                   EVAL      #1PMTD = PSTM
     C                   EVAL      #1PCCY = PSCY
     C                   IF        PSTM = '05' OR
     C                             CLE033 = 'Y' AND
     C                             PSTM = '09'
     C                   EVAL      #1PACC = POBR + PONS
     C                   ELSE
     C                   EVAL      #1PACC = PONS
     C                   ENDIF
     C                   EVAL      #1PYBA = PYBA                                              CLE038
     C     #1PYBA        IFNE      'A'                                                        CLE038
     C                   SETON                                        53                      CLE038
     C                   ELSE                                                                 CLE038
     C                   SETOFF                                       53                      CLE038
     C                   ENDIF                                                                CLE038
     C                   EVAL      PCurr = #1PCCY                                             CLE038
     C     #1PCCY        IFEQ      *BLANKS                                                    CLE038
     C     PSTM          OREQ      '09'                                                       CLE038
     C     CLE033        ANDEQ     'Y'                                                        CLE038
     C     WSetl09Ccy    ANDEQ     'T'                                                        CLE038
     C                   EVAL      PCurr = PMPCCY                                             CLE038
     C                   ENDIF                                                                CLE038
     C                   EXSR      SRAOCURR                                                   CLE038
     C     CLE038        IFEQ      'Y'                                                        CLE038
     C     #1PYBA        ANDEQ     'A'                                                        CLE038
     C                   MOVE      *BLANKS       ZField                                       CLE038
     C                   MOVE      PYAM          ZField                                       CLE038
     C                   Z-ADD     A6NBDP        ZADEC                                        CLE038
     C                   EXSR      ZEDIT                                                      CLE038
     C                   MOVE      ZField        #1PAMT                                       CLE038
     C                   EVAL      WFTotPAmt = PYAM                                           CLE038
     C     #1PCCY        IFEQ      PMPCCY                                                     CLE038
     C     #1PCCY        OREQ      *BLANKS                                                    CLE038
     C     PSTM          OREQ      '09'                                                       CLE038
     C     WSetl09Ccy    ANDEQ     'T'                                                        CLE038
     C                   EVAL      WFTotPTAmt = WFTotPTAmt + PYAM                             CLE038
     C                   ELSE                                                                 CLE038
      *                                                                                       CLE038
     C     #1PEXR        IFEQ      *BLANKS                                                    CLE038
     C                   Z-ADD     *ZEROS        WKPEXR                                       CLE038
     C                   ELSE                                                                 CLE038
     C                   MOVE      *BLANKS       ZFld17                                       CLE038
     C                   MOVE      #1PEXR        ZFld17                                       CLE038
     C                   Z-ADD     8             ZADEC                                        CLE038
     C                   Z-ADD     5             ZADIG                                        CLE038
     C                   EXSR      ZASIGN                                                     CLE038
     C                   Z-ADD     *ZEROS        WKPEXR                                       CLE038
     C                   MOVE      ZOUT15        WKPEXR           13 8                        CLE038
     C                   IF        ZAsignOk = 'N'                                             CLE038
     C                   Z-ADD     *ZEROS        WKPEXR                                       CLE038
     C                   ENDIF                                                                CLE038
     C                   ENDIF                                                                CLE038
     C     WKPEXR        IFEQ      0                                                          CLE038
     C                   Z-ADD     A6SPRT        ZRATE1                                       CLE038
     C                   MOVE      A6MDIN        ZMDI1                                        CLE038
     C                   Z-ADD     WPaySpot      ZRATE2                                       CLE038
     C                   MOVE      WPayMDI       ZMDI2                                        CLE038
     C                   EXSR      ZXRATE                                                     CLE038
     C                   Z-ADD     ZRATEX        ZEXCH                                        CLE038
     C                   MOVE      ZMDIX         ZMD                                          CLE038
     C                   ELSE                                                                 CLE038
     C                   Z-ADD     WKPEXR        ZEXCH                                        CLE038
     C     #1PEXI        IFEQ      'M'                                                        CLE038
     C                   MOVEL     'D'           ZMD                                          CLE038
     C                   ELSE                                                                 CLE038
     C                   MOVEL     'M'           ZMD                                          CLE038
     C                   ENDIF                                                                CLE038
     C                   ENDIF                                                                CLE038
      *                                                                                       CLE038
     C                   MOVE      #1PCCY        ZCCYI                                        CLE038
     C                   MOVE      PMPCCY        ZCCYO                                        CLE038
     C                   MOVE      A6NBDP        ZCDPI                                        CLE038
     C                   MOVE      WPayDP        ZCDPO                                        CLE038
     C                   Z-ADD     PYAM          ZAMTCI                                       CLE038
     C                   EXSR      ZCONV                                                      CLE038
     C                   EVAL      WFTotPTAmt = WFTotPTAmt + ZAMTCO                           CLE038
     C                   ENDIF                                                                CLE038
     C                   ENDIF                                                                CLE038
 
     C                   ENDIF
     C                   IF        WAction = 'A' AND                                          CLE038
     C                             *IN61 = *ON                                                CLE038
     C                   EVAL      #1PYBA = PYBA                                              CLE038
     C     #1PYBA        IFNE      'A'                                                        CLE038
     C                   SETON                                        53                      CLE038
     C                   ELSE                                                                 CLE038
     C                   SETOFF                                       53                      CLE038
     C                   ENDIF                                                                CLE038
     C                   ENDIF                                                                CLE038
 
     C                   EXSR      SRFRFD
 
     C                   WRITE     LE2230S1
 
     C     KFLDS5        READE     LESTAL5                                96
                                                                                              219608
     C                   IF        *IN96 = *ON                                                219608
     C                   EVAL      WBefore = 'Y'                                              219608
     C                   ENDIF                                                                219608
                                                                                              219608
     C                   ENDDO
 
     C                   IF        WRRN1 = *ZERO
 
     C                   EVAL      WF9 = 'Y'
     C                   EVAL      WFormat = 'DET'
 
     C                   ELSE
 
     C                   IF        WFirst <> 'Y'
     C                   IF        WAction = 'A'
     C     CLE038        IFEQ      'Y'                                                        CLE038
     C     RCBA          ANDEQ     'A'                                                        CLE038
     C                   IF        WFTotRTAmt <> PAllcAmt AND                                 CLE038
     C                             *IN60 = *OFF                                               CLE038
     C                   EVAL      ZAMSID = 'ESM0830'                                         CLE038
     C                   EXSR      ZASNMS                                                     CLE038
     C                   EVAL      WVErr = 'Y'                                                CLE038
     C                   EVAL      WTErr = 'Y'                                                CLE038
     C                   ENDIF                                                                CLE038
     C                   ELSE                                                                 CLE038
     C                   IF        WFTotRcv <> 100 AND
     C                             *IN60 = *OFF
     C                   EVAL      ZAMSID = 'ESM0822'
     C                   EXSR      ZASNMS
     C                   EVAL      WVErr = 'Y'
     C                   EVAL      WTErr = 'Y'
     C                   ENDIF
     C                   ENDIF                                                                CLE038
     C     CLE038        IFEQ      'Y'                                                        CLE038
     C     PYBA          ANDEQ     'A'                                                        CLE038
     C                   IF        WFTotPTAmt <> PAllcAmt AND                                 CLE038
     C                             *IN61 = *OFF                                               CLE038
     C                   EVAL      ZAMSID = 'ESM0831'                                         CLE038
     C                   EXSR      ZASNMS                                                     CLE038
     C                   EVAL      WVErr = 'Y'                                                CLE038
     C                   EVAL      WTErr = 'Y'                                                CLE038
     C                   ENDIF                                                                CLE038
     C                   ELSE                                                                 CLE038
     C                   IF        WFTotPay <> 100 AND
     C                             *IN61 = *OFF
     C                   EVAL      ZAMSID = 'ESM0823'
     C                   EXSR      ZASNMS
     C                   EVAL      WVErr = 'Y'
     C                   EVAL      WTErr = 'Y'
     C                   ENDIF
     C                   ENDIF                                                                CLE038
     C                   ENDIF
     C                   ELSE
     C                   EVAL      WFirst = 'N'
     C                   ENDIF
 
     C                   EXSR      SRSUB
 
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDEFT - Default settlements subroutine                      *
      *                                                               *
      *****************************************************************
     C     SRDEFT        BEGSR
 
     C                   IF        *IN96 = *ON
 
     C                   IF        PType = 'ROLL'
     C                   EVAL      WType = 'LOAN'
     C     KFLDS5        SETLL     LESTAL5
     C     KFLDS5        READE     LESTAL5                                96
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBATCH - Batch processing subroutine                        *
      *                                                               *
      *****************************************************************
     C     SRBATCH       BEGSR
 
     C                   EVAL      WType = PType
     C                   IF        PType = 'PTSO'                                             CLE038
     C                   EVAL      WType = 'LOAN'                                             CLE038
     C                   ENDIF                                                                CLE038
     C                   IF        PTimeStamp <> *BLANKS
     C                   MOVE      PTimeStamp    WTimeStamp
     C                   ENDIF
     C                   MOVE      PLnRef        WLnRef
     C                   MOVE      PLnAmdVDat    WLnAmdVDat
     C                   MOVE      PLnAmdVDat    WLnAmdVDatA
     C                   MOVE      PLnAmdSeq     WLnAmdSeq
     C                   MOVE      PCusFees      WCusFees
     C                   MOVE      PFclFees      WFclFees
     C                   MOVE      PFeeSeq       WFeeSeq
 
     C     1             DO        2000          @X                5 0                        197145
     C     @X            OCCUR     LEPD
     C                   CLEAR                   LEPD
     C                   END
     C                   Z-ADD     0             @X
 
     C     KFLDS6        SETLL     LESTALX
     C     KFLDS6        READE(N)  LESTALX                                30
 
     C     *IN30         IFEQ      *ON
     C                   EVAL      ZAMSID = 'ESM0827'
     C                   EXSR      ZASNMS
     C                   ENDIF
 
     C                   DOW       *IN30 = *OFF
 
     C                   ADD       1             @X
     C     @X            OCCUR     LEPD
 
     C                   EVAL      WArSEQN0(@X) = SEQ
 
      ** Receive Settlement
 
     C                   IF        *IN60 = *OFF
 
     C                   MOVE      *BLANKS       ZField
     C                   MOVE      RCPC          ZField
     C                   Z-ADD     9             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZField        #0RPCG
     C                   MOVE      ZField        #0RAMT                                       CLE038
     C                   EVAL      #0RMTD = RSTM
     C                   EVAL      #0RCCY = RSCY
     C                   IF        RSTM = '05' OR
     C                             CLE033 = 'Y' AND
     C                             RSTM = '09'
     C                   EVAL      #0RACC = ROBR + RONS
     C                   ELSE
     C                   EVAL      #0RACC = RONS
     C                   ENDIF
     C                   EVAL      #0RCBA = RCBA                                              CLE038
     C     #0RCBA        IFNE      'A'                                                        CLE038
     C                   SETON                                        52                      CLE038
     C                   ELSE                                                                 CLE038
     C                   SETOFF                                       52                      CLE038
     C                   ENDIF                                                                CLE038
     C                   EVAL      PCurr = #0RCCY                                             CLE038
     C     #0RCCY        IFEQ      *BLANKS                                                    CLE038
     C     RSTM          OREQ      '09'                                                       CLE038
     C     CLE033        ANDEQ     'Y'                                                        CLE038
     C     WSetl09Ccy    ANDEQ     'T'                                                        CLE038
     C                   EVAL      PCurr = PMRCCY                                             CLE038
     C                   ENDIF                                                                CLE038
     C                   EXSR      SRAOCURR                                                   CLE038
     C     CLE038        IFEQ      'Y'                                                        CLE038
     C     #0RCBA        ANDEQ     'A'                                                        CLE038
     C                   MOVE      *BLANKS       ZField                                       CLE038
     C                   MOVE      RCAM          ZField                                       CLE038
     C                   Z-ADD     A6NBDP        ZADEC                                        CLE038
     C                   EXSR      ZEDIT                                                      CLE038
     C                   MOVE      ZField        #0RAMT                                       CLE038
     C                   ENDIF                                                                CLE038
                                                                                              CLE038
     C                   MOVE      *BLANKS       ZFIELD                                       CLE038
     C                   MOVE      REXR          ZFIELD                                       CLE038
     C                   Z-ADD     8             ZADEC                                        CLE038
     C                   EXSR      ZEDIT                                                      CLE038
     C                   MOVE      ZFIELD        #0REXR                                       CLE038
     C                   MOVE      REXI          #0REXI                                       CLE038
 
     C                   ENDIF
 
      ** Payment Settlement
 
     C                   IF        *IN61 = *OFF
 
     C                   MOVE      *BLANKS       ZField
     C                   MOVE      PYPC          ZField
     C                   Z-ADD     9             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZField        #0PPCG
     C                   MOVE      ZField        #0PAMT                                       CLE038
     C                   EVAL      #0PMTD = PSTM
     C                   EVAL      #0PCCY = PSCY
     C                   IF        PSTM = '05' OR
     C                             CLE033 = 'Y' AND
     C                             PSTM = '09'
     C                   EVAL      #0PACC = POBR + PONS
     C                   ELSE
     C                   EVAL      #0PACC = PONS
     C                   ENDIF
     C                   EVAL      #0PYBA = PYBA                                              CLE038
     C     #0PYBA        IFNE      'A'                                                        CLE038
     C                   SETON                                        53                      CLE038
     C                   ELSE                                                                 CLE038
     C                   SETOFF                                       53                      CLE038
     C                   ENDIF                                                                CLE038
     C                   EVAL      PCurr = #0PCCY                                             CLE038
     C     #0PCCY        IFEQ      *BLANKS                                                    CLE038
     C     PSTM          OREQ      '09'                                                       CLE038
     C     CLE033        ANDEQ     'Y'                                                        CLE038
     C     WSetl09Ccy    ANDEQ     'T'                                                        CLE038
     C                   EVAL      PCurr = PMPCCY                                             CLE038
     C                   ENDIF                                                                CLE038
     C                   EXSR      SRAOCURR                                                   CLE038
     C     CLE038        IFEQ      'Y'                                                        CLE038
     C     #0PYBA        ANDEQ     'A'                                                        CLE038
     C                   MOVE      *BLANKS       ZField                                       CLE038
     C                   MOVE      PYAM          ZField                                       CLE038
     C                   Z-ADD     A6NBDP        ZADEC                                        CLE038
     C                   EXSR      ZEDIT                                                      CLE038
     C                   MOVE      ZField        #0PAMT                                       CLE038
     C                   ENDIF                                                                CLE038
                                                                                              CLE038
     C                   MOVE      *BLANKS       ZFIELD                                       CLE038
     C                   MOVE      PEXR          ZFIELD                                       CLE038
     C                   Z-ADD     8             ZADEC                                        CLE038
     C                   EXSR      ZEDIT                                                      CLE038
     C                   MOVE      ZFIELD        #0PEXR                                       CLE038
     C                   MOVE      PEXI          #0PEXI                                       CLE038
 
     C                   ENDIF
 
     C     KFLDS6        READE(N)  LESTALX                                30
     C                   ENDDO
 
     C                   EXSR      SRVAL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFLDT - Fill Detail Screen subroutine                       *
      *                                                               *
      *****************************************************************
     C     SRFLDT        BEGSR
 
     C                   IF        WAction = 'I' OR
     C                             WF9 = 'Y' OR
     C                             PNoDetails = 'Y'
 
     C                   EVAL      *IN80 = *ON
     C                   EVAL      *IN81 = *OFF
     C                   EVAL      *IN82 = *OFF
     C                   IF        *IN60 = *OFF
     C                   EVAL      *IN40 = *OFF
     C                   ENDIF
     C                   IF        *IN61 = *OFF
     C                   EVAL      *IN41 = *OFF
     C                   ENDIF
 
     C                   EVAL      WSAction = ' '
     C                   MOVEA     *ZEROS        WArSEQN0
     C                   EXSR      SRRESET
     C                   EVAL      WRRN0 = *ZERO
     C                   EVAL      WcntX = *ZERO
 
     C                   EVAL      *IN97 = *ON
     C                   WRITE     LE2230C0
     C                   EVAL      *IN97 = *OFF
 
     C                   IF        WF9 <> 'Y'
 
     C                   EXSR      SRFRXD
 
     C                   MOVE      *BLANKS       ZField
     C                   MOVE      100000000000  ZField
     C                   Z-ADD     9             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZField        #0RPCG
     C                   MOVE      ZField        #0PPCG
     C                   MOVE      ZField        #0RAMT                                       CLE038
     C                   MOVE      ZField        #0PAMT                                       CLE038
     C     CLE038        IFEQ      'Y'                                                        CLE038
     C                   MOVE      'P'           #0PYBA                                       CLE038
     C                   MOVE      'P'           #0RCBA                                       CLE038
     C     PType         IFEQ      'LAPI'                                                     CLE038
     C     PType         OREQ      'LOAN'                                                     CLE038
     C     PType         OREQ      'PTSO'                                                     CLE038
     C                   MOVE      *BLANKS       ZField                                       CLE038
     C                   MOVE      *ZEROS        ZField                                       CLE038
     C                   Z-ADD     WRecDP        ZADEC                                        CLE038
     C                   EXSR      ZEDIT                                                      CLE038
     C                   MOVE      ZField        WRKZEROAMT       14                          CLE038
     C     PType         IFEQ      'LAPI'                                                     CLE038
     C     PType         OREQ      'LOAN'                                                     CLE038
     C                   MOVE      ZField        #0PAMT                                       CLE038
     C                   MOVE      'A'           #0PYBA                                       CLE038
     C                   ENDIF                                                                CLE038
     C     PType         IFEQ      'LAPI'                                                     CLE038
     C     PType         OREQ      'PTSO'                                                     CLE038
     C                   MOVE      ZField        #0RAMT                                       CLE038
     C                   MOVE      'A'           #0RCBA                                       CLE038
     C                   ENDIF                                                                CLE038
     C                   ENDIF                                                                CLE038
     C     #0RCBA        IFNE      'A'                                                        CLE038
     C                   SETON                                        52                      CLE038
     C                   ELSE                                                                 CLE038
     C                   SETOFF                                       52                      CLE038
     C                   ENDIF                                                                CLE038
     C     #0PYBA        IFNE      'A'                                                        CLE038
     C                   SETON                                        53                      CLE038
     C                   ELSE                                                                 CLE038
     C                   SETOFF                                       53                      CLE038
     C                   ENDIF                                                                CLE038
     C                   ENDIF                                                                CLE038
 
     C                   EVAL      WRRN0 = WRRN0 + 1
     C                   EVAL      #0RLRN = WRRN0
     C                   EVAL      WCntX = WCntX + 1
     C                   EVAL      *IN90 = *ON
     C                   WRITE     LE2230S0
     C                   EVAL      *IN90 = *OFF
 
     C                   EVAL      *IN98 = *ON
 
     C                   DOW       *IN98 = *ON
 
     C                   IF        WCntX > 1
     C                   EVAL      WCntX = *ZERO
     C                   EXSR      SRRESET
     C                   ENDIF
 
     C                   EVAL      #0RPCG = *BLANKS
     C                   EVAL      #0RAMT = *BLANKS                                           CLE038
     C                   EVAL      #0RMTD = *BLANKS
     C                   EVAL      #0RCCY = *BLANKS
     C                   EVAL      #0RACC = *BLANKS
     C                   EVAL      #0PPCG = *BLANKS
     C                   EVAL      #0PAMT = *BLANKS                                           CLE038
     C                   EVAL      #0PMTD = *BLANKS
     C                   EVAL      #0PCCY = *BLANKS
     C                   EVAL      #0PACC = *BLANKS
 
     C                   DOW       WCntX < 13  AND
     C                             WRRN0 < 10000
     C                   EVAL      WRRN0 = WRRN0 + 1
     C                   EVAL      WCntX = WCntX + 1
     C                   WRITE     LE2230S0
     C                   ENDDO
 
     C                   IF        WRRN0 = 9999
     C                   EVAL      *IN96 = *ON
     C                   ENDIF
 
     C                   EVAL      WSRRN0 = WRRN0
     C                   EXSR      SRDET
     C                   ENDDO
 
     C                   ELSE
 
     C                   EVAL      *IN98 = *ON
 
     C                   DOW       *IN98 = *ON
 
     C                   EVAL      WCntX = *ZERO
     C                   EXSR      SRRESET
 
     C                   EVAL      #0RPCG = *BLANKS
     C                   EVAL      #0RAMT = *BLANKS                                           CLE038
     C                   EVAL      #0RMTD = *BLANKS
     C                   EVAL      #0RCCY = *BLANKS
     C                   EVAL      #0RACC = *BLANKS
     C                   EVAL      #0PPCG = *BLANKS
     C                   EVAL      #0PAMT = *BLANKS                                           CLE038
     C                   EVAL      #0PMTD = *BLANKS
     C                   EVAL      #0PCCY = *BLANKS
     C                   EVAL      #0PACC = *BLANKS
 
     C                   DOW       WCntX < 13
     C                   EVAL      WRRN0 = WRRN0 + 1
     C                   EVAL      WCntX = WCntX + 1
     C                   WRITE     LE2230S0
     C                   ENDDO
 
     C                   EVAL      #0RLRN = 1
     C                   EVAL      WSRRN0 = WRRN0
     C                   EXSR      SRDET
     C                   ENDDO
 
     C                   ENDIF
 
      ** Amend or Delete
 
     C                   ELSE
 
     C                   EVAL      WType = PType
     C                   IF        PType = 'PTSO'                                             CLE038
     C                   EVAL      WType = 'LOAN'                                             CLE038
     C                   ENDIF                                                                CLE038
     C                   MOVE      PLnRef        WLnRef
     C                   MOVE      PLnAmdVDat    WLnAmdVDat
     C                   MOVE      PLnAmdVDat    WLnAmdVDatA
     C                   MOVE      PLnAmdSeq     WLnAmdSeq
     C                   MOVE      PCusFees      WCusFees
     C                   MOVE      PFclFees      WFclFees
     C                   MOVE      PFeeSeq       WFeeSeq
 
     C                   IF        WAction = 'D'
     C                   EVAL      *IN80 = *ON
     C                   EVAL      *IN81 = *OFF
     C                   EVAL      *IN82 = *OFF
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN41 = *ON
     C                   ENDIF
 
     C                   IF        WAction = 'A'
     C                   IF        WSAction = 'A'
     C                   EVAL      *IN80 = *ON
     C                   EVAL      *IN81 = *OFF
     C                   EVAL      *IN82 = *OFF
     C                   IF        *IN60 = *OFF
     C                   EVAL      *IN40 = *OFF
     C                   ENDIF
     C                   IF        *IN61 = *OFF
     C                   EVAL      *IN41 = *OFF
     C                   ENDIF
     C                   ELSE
     C                   EVAL      *IN80 = *OFF
     C                   EVAL      *IN81 = *OFF
     C                   EVAL      *IN82 = *ON
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN41 = *ON
     C                   ENDIF
     C                   ENDIF
 
     C                   EXSR      SRRESET
     C                   EVAL      WRRN0 = *ZERO
     C                   EVAL      #0RLRN = *ZERO
     C                   EVAL      WcntX = *ZERO
     C                   EVAL      WCnt2 = 1
 
     C                   EVAL      *IN97 = *ON
     C                   WRITE     LE2230C0
     C                   EVAL      *IN97 = *OFF
 
     C                   DOW       WCnt2 <= WCnt1
 
     C                   EVAL      WRRN0 = WRRN0 + 1
     C                   EVAL      #0RLRN = #0RLRN + 1
     C                   EVAL      WSequence = WArSEQN1(WCnt2)
 
      ** If mode is repair
 
     C                   IF        PMode = 'F'
 
     C     KFLDS3        SETLL     LEISTL1
     C     KFLDS3        READE     LEISTL1                                11
 
     C                   IF        *IN11 = *OFF
 
      ** Receive Settlement
 
     C                   EVAL      #0RPCG = IRCPC
     C                   EVAL      #0RAMT = IRCPC                                             CLE038
     C                   EVAL      #0RCBA = IRCBA                                             CLE038
     C     #0RCBA        IFNE      'A'                                                        CLE038
     C                   SETON                                        52                      CLE038
     C                   ELSE                                                                 CLE038
     C                   SETOFF                                       52                      CLE038
     C                   EVAL      #0RAMT = IRCAM                                             CLE038
     C                   ENDIF                                                                CLE038
     C                   EVAL      #0RMTD = IRSTM
     C                   EVAL      #0RCCY = IRSCY
     C                   IF        IRSTM = '05' OR
     C                             CLE033 = 'Y' AND
     C                             IRSTM = '09'
     C                   EVAL      #0RACC = IRONS
     C                   ELSE
     C**********         EVAL      #0RACC = %SUBST(IRONS:4:12)                                CGL029
     C                   EVAL      #0RACC = %SUBST(IRONS:4:18)                                CGL029
     C                   ENDIF
 
      ** Payment Settlement
 
     C                   EVAL      #0PPCG = IPYPC
     C                   EVAL      #0PAMT = IPYPC                                             CLE038
     C                   EVAL      #0PYBA = IPYBA                                             CLE038
     C     #0PYBA        IFNE      'A'                                                        CLE038
     C                   SETON                                        53                      CLE038
     C                   ELSE                                                                 CLE038
     C                   EVAL      #0PAMT = IPYAM                                             CLE038
     C                   SETOFF                                       53                      CLE038
     C                   ENDIF                                                                CLE038
     C                   EVAL      #0PMTD = IPSTM
     C                   EVAL      #0PCCY = IPSCY
     C                   IF        IPSTM = '05' OR
     C                             CLE033 = 'Y' AND
     C                             IPSTM = '09'
     C                   EVAL      #0PACC = IPONS
     C                   ELSE
     C**********         EVAL      #0PACC = %SUBST(IPONS:4:12)                                CGL029
     C                   EVAL      #0PACC = %SUBST(IPONS:4:18)                                CGL029
     C                   ENDIF
 
     C                   EVAL      WRRN0 = WRRN0 + 1
     C                   EVAL      #0RLRN = #0RLRN + 1
     C                   WRITE     LE2230S0
 
     C                   ENDIF
 
      ** Not repair mode
 
     C                   ELSE
 
     C     KFLDS2        SETLL     LESTAL6
     C     KFLDS2        READE(N)  LESTAL6
 
      ** Receive Settlement
 
     C                   IF        *IN60 = *OFF
 
     C                   MOVE      *BLANKS       ZField
     C                   MOVE      RCPC          ZField
     C                   Z-ADD     9             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZField        #0RPCG
     C                   MOVE      ZField        #0RAMT                                       CLE038
     C                   EVAL      #0RMTD = RSTM
     C                   EVAL      #0RCCY = RSCY
     C                   IF        RSTM = '05' OR
     C                             CLE033 = 'Y' AND
     C                             RSTM = '09'
     C                   EVAL      #0RACC = ROBR + RONS
     C                   ELSE
     C                   EVAL      #0RACC = RONS
     C                   ENDIF
      *                                                                                       CLE038
     C                   EVAL      #0RCBA = RCBA                                              CLE038
     C     #0RCBA        IFNE      'A'                                                        CLE038
     C                   SETON                                        52                      CLE038
     C                   ELSE                                                                 CLE038
     C                   SETOFF                                       52                      CLE038
     C                   ENDIF                                                                CLE038
     C                   EVAL      PCurr = RSCY                                               CLE038
     C     RSCY          IFEQ      *BLANKS                                                    CLE038
     C     RSTM          OREQ      '09'                                                       CLE038
     C     CLE033        ANDEQ     'Y'                                                        CLE038
     C     WSetl09Ccy    ANDEQ     'T'                                                        CLE038
     C                   EVAL      PCurr = PMRCCY                                             CLE038
     C                   ENDIF                                                                CLE038
     C                   EXSR      SRAOCURR                                                   CLE038
     C     CLE038        IFEQ      'Y'                                                        CLE038
     C     #0RCBA        ANDEQ     'A'                                                        CLE038
     C                   MOVE      *BLANKS       ZField                                       CLE038
     C                   MOVE      RCAM          ZField                                       CLE038
     C                   Z-ADD     A6NBDP        ZADEC                                        CLE038
     C                   EXSR      ZEDIT                                                      CLE038
     C                   MOVE      ZField        #0RAMT                                       CLE038
     C                   ENDIF                                                                CLE038
 
     C                   ENDIF
                                                                                              CLE038
     C                   IF        *IN60 = *ON                                                CLE038
     C                   EVAL      #0RCBA = RCBA                                              CLE038
     C     #0RCBA        IFNE      'A'                                                        CLE038
     C                   SETON                                        52                      CLE038
     C                   ELSE                                                                 CLE038
     C                   SETOFF                                       52                      CLE038
     C                   ENDIF                                                                CLE038
     C                   ENDIF                                                                CLE038
 
      ** Payment Settlement
 
     C                   IF        *IN61 = *OFF
 
     C                   MOVE      *BLANKS       ZField
     C                   MOVE      PYPC          ZField
     C                   Z-ADD     9             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZField        #0PPCG
     C                   MOVE      ZField        #0PAMT                                       CLE038
     C                   EVAL      #0PMTD = PSTM
     C                   EVAL      #0PCCY = PSCY
     C                   IF        PSTM = '05' OR
     C                             CLE033 = 'Y' AND
     C                             PSTM = '09'
     C                   EVAL      #0PACC = POBR + PONS
     C                   ELSE
     C                   EVAL      #0PACC = PONS
     C                   ENDIF
      *                                                                                       CLE038
     C                   EVAL      #0PYBA = PYBA                                              CLE038
     C     #0PYBA        IFNE      'A'                                                        CLE038
     C                   SETON                                        53                      CLE038
     C                   ELSE                                                                 CLE038
     C                   SETOFF                                       53                      CLE038
     C                   ENDIF                                                                CLE038
     C                   EVAL      PCurr = PSCY                                               CLE038
     C     PSCY          IFEQ      *BLANKS                                                    CLE038
     C     PSTM          OREQ      '09'                                                       CLE038
     C     CLE033        ANDEQ     'Y'                                                        CLE038
     C     WSetl09Ccy    ANDEQ     'T'                                                        CLE038
     C                   EVAL      PCurr = PMPCCY                                             CLE038
     C                   ENDIF                                                                CLE038
     C                   EXSR      SRAOCURR                                                   CLE038
     C     CLE038        IFEQ      'Y'                                                        CLE038
     C     #0PYBA        ANDEQ     'A'                                                        CLE038
     C                   MOVE      *BLANKS       ZField                                       CLE038
     C                   MOVE      PYAM          ZField                                       CLE038
     C                   Z-ADD     A6NBDP        ZADEC                                        CLE038
     C                   EXSR      ZEDIT                                                      CLE038
     C                   MOVE      ZField        #0PAMT                                       CLE038
     C                   ENDIF                                                                CLE038
 
     C                   ENDIF
     C                   IF        *IN61 = *ON                                                CLE038
     C                   EVAL      #0PYBA = PYBA                                              CLE038
     C     #0PYBA        IFNE      'A'                                                        CLE038
     C                   SETON                                        53                      CLE038
     C                   ELSE                                                                 CLE038
     C                   SETOFF                                       53                      CLE038
     C                   ENDIF                                                                CLE038
     C                   ENDIF                                                                CLE038
 
     C                   WRITE     LE2230S0
 
     C                   ENDIF
 
     C                   EVAL      WCnt2 = WCnt2 + 1
     C                   ENDDO
 
     C                   IF        WCnt2 > WCnt1
     C                   EVAL      *IN96 = *ON
     C                   ENDIF
 
     C                   EXSR      SRDET
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDET - Detail Screen subroutine                             *
      *                                                               *
      *****************************************************************
     C     SRDET         BEGSR
 
     C                   DOU       WVErr = 'N'
 
     C                   IF        WVErr = 'Y'
     C                   IF        WTErr <> 'Y' AND
     C                             WXErr <> 'Y'
     C                   EVAL      *IN90 = *ON
     C                   UPDATE    LE2230S0
     C                   EVAL      *IN90 = *OFF
     C                   ELSE
     C                   EVAL      WRRN0 = 1
     C                   ENDIF
     C                   WRITE     LE2230C2
     C                   ENDIF
 
     C                   EVAL      WVErr = 'N'
     C                   EVAL      WTErr = 'N'
     C                   EVAL      WXErr = 'N'
 
     C                   WRITE     LE2230F1
 
     C                   IF        WAction = 'A' AND
     C                             WVErr <> 'Y' AND
     C                             WTErr <> 'Y'
     C                   EVAL      #0RLRN = 1
     C                   ELSE
     C                   EVAL      #0RLRN = WRRN0
     C                   ENDIF
     C                   WRITE     LE2230C0
     C                   READ      LE2230C0
 
     C                   EVAL      #0RPCG = #0RAMT                                            CLE038
     C                   EVAL      #0PPCG = #0PAMT                                            CLE038
                                                                                              CLE038
     C                   SELECT
 
     C                   WHEN      *IN98 = *ON
     C                   IF        WAction = 'I' OR
     C                             WF9 = 'Y' OR
     C                             PNoDetails = 'Y'
     C                   EVAL      WRRN0 = WSRRN0
     C                   LEAVE
     C                   ENDIF
 
     C                   WHEN      *INKC = *ON
     C                   EVAL      PMCMDP = '03'
     C                   EVAL      WFormat = 'END'
 
     C                   WHEN      *INKL = *ON
     C                   IF        WAction = 'I' OR
     C                             PNoDetails = 'Y'
     C                   EVAL      PMCMDP = '12'
     C                   EVAL      WFormat = 'END'
     C                   ENDIF
     C                   IF        WAction = 'A' AND
     C                             PNoDetails <> 'Y'
     C                   EVAL      WFormat = 'SUB'
     C                   ENDIF
 
     C                   WHEN      *INKJ = *ON AND
     C                             WAction = 'A' AND
     C                             WSAction = 'D'
     C                   EVAL      WFormat = 'DB'
 
     C                   OTHER
     C                   IF        WSAction = 'D'
     C                   EVAL      ZAMSID = 'ESM0821'
     C                   EXSR      ZASNMS
     C                   EVAL      WVErr = 'Y'
     C                   EVAL      WXErr = 'Y'
     C                   ELSE
     C                   EXSR      SRCLRM
     C                   EXSR      SRVAL
     C                   ENDIF
 
     C                   ENDSL
     C                   ENDDO
 
     C                   EXSR      SRCLRM
     C                   WRITE     LE2230C2
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVAL - Validation subroutine                                *
      *                                                               *
      *****************************************************************
     C     SRVAL         BEGSR
 
     C                   EXSR      SRRESET
     C                   EVAL      WRcvSetlCcy = *BLANKS
     C                   EVAL      WRcvSetlLoc = *BLANKS
     C                   EVAL      WPaySetlCcy = *BLANKS
     C                   EVAL      WPaySetlLoc = *BLANKS
     C                   EVAL      WRCcyLoc = *BLANKS
     C                   EVAL      WPCcyLoc = *BLANKS
     C                   EVAL      WPercentNum = *ZEROS
     C                   EVAL      WAmountNum = *ZEROS                                        CLE038
 
     C                   IF        PMode <> 'B'
     C                   READC     LE2230S0                               15
     C                   ELSE
     C                   Z-ADD     1             @Y                5 0
     C     @Y            OCCUR     LEPD
     C                   ENDIF
 
     C                   DOW       *IN15 = *OFF and PMode <> 'B'
     C                             OR @Y <= @X and PMode = 'B'
 
     C                   EVAL      #0RPCG = #0RAMT                                            CLE038
     C                   EVAL      #0PPCG = #0PAMT                                            CLE038
                                                                                              CLE038
     C                   IF        #0RPCG <> *BLANKS OR
     C                             #0RAMT <> *BLANKS OR                                       CLE038
     C                             #0RMTD <> *BLANKS OR
     C                             #0RCCY <> *BLANKS OR
     C                             #0RACC <> *BLANKS OR
     C                             #0PPCG <> *BLANKS OR
     C                             #0PAMT <> *BLANKS OR                                       CLE038
     C                             #0PMTD <> *BLANKS OR
     C                             #0PCCY <> *BLANKS OR
     C                             #0PACC <> *BLANKS
 
     C                   IF        *IN60 = *OFF
 
      ** Validate Receive Settlement
 
     C                   EVAL      WPRInd = 'R'
     C                   EVAL      WSPercentage = #0RPCG
     C                   EVAL      WSMethod = #0RMTD
     C                   EVAL      WSCurrency = #0RCCY
     C                   EVAL      WSAccount = #0RACC
     C                   EVAL      WSBranch = #0RACC
     C                   EVAL      WSByAmt = #0RCBA                                           CLE038
     C                   EVAL      WSAmount = #0RAMT                                          CLE038
     C                   EXSR      SRVBYA                                                     CLE038
 
     C     WSByAmt       IFEQ      'A'                                                        CLE038
     C*****              EXSR      SRVAMT1                                                    CLE038
     C                   ELSE                                                                 CLE038
     C                   EXSR      SRVPCT
     C                   ENDIF                                                                CLE038
     C************       IF        WPErr <> 'Y' AND                                           CLE038
     C************                 WPercentNum <> *ZERO                                       CLE038
     C                   IF        WPErr <> 'Y' AND                                           CLE038
     C                             WBErr <> 'Y' AND                                           CLE038
     C                             WSByAmt <> 'A' AND                                         CLE038
     C                             WPercentNum <> *ZERO                                       CLE038
     C                             OR WOErr <> 'Y' AND                                        CLE038
     C                             WBErr <> 'Y' AND                                           CLE038
     C                             WSByAmt = 'A' AND                                          CLE038
     C                             WSAmount <> WRKZEROAMT                                     CLE038
     C                   IF        WPErr <> 'Y' AND
     C                             WPercentNum <> *ZERO
     C                   EXSR      SRVMTH
     C                   EXSR      SRVCCY
     C                   EXSR      SRVACT
     C     WSByAmt       IFEQ      'A'                                                        CLE038
     C     WCErr         ANDNE     'Y'                                                        CLE038
     C                   EXSR      SRVAMT2                                                    CLE038
     C                   ENDIF                                                                CLE038
     C                   ENDIF
     C                   ENDIF                                                                CLE038
 
     C                   IF        WCErr <> 'Y' AND
     C                             WAErr <> 'Y'
     C                   IF        PMode <> 'B'
     C                   EVAL      WArRICL(WRRN0) = WRCcyLoc
     C                   ELSE
     C                   EVAL      WArRICL(@Y) = WRCcyLoc
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        WPErr = 'Y' OR
     C                             WMErr = 'Y' OR
     C                             WCErr = 'Y' OR
     C**********                   WAErr = 'Y'                                                CLE038
     C                             WAErr = 'Y' OR                                             CLE038
     C                             WBErr = 'Y' OR                                             CLE038
     C                             WOErr = 'Y'                                                CLE038
     C                   EVAL      WVErr = 'Y'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        *IN61 = *OFF
 
      ** Validate Payment Settlement
 
     C                   EVAL      WPRInd = 'P'
     C                   EVAL      WSPercentage =  #0PPCG
     C                   EVAL      WSMethod = #0PMTD
     C                   EVAL      WSCurrency = #0PCCY
     C                   EVAL      WSAccount = #0PACC
     C                   EVAL      WSBranch = #0PACC
     C                   EVAL      WSByAmt = #0PYBA                                           CLE038
     C                   EVAL      WSAmount = #0PAMT                                          CLE038
     C                   EXSR      SRVBYA                                                     CLE038
 
     C     WSByAmt       IFEQ      'A'                                                        CLE038
     C*****              EXSR      SRVAMT1                                                    CLE038
     C                   ELSE                                                                 CLE038
     C                   EXSR      SRVPCT
     C                   ENDIF                                                                CLE038
     C************       IF        WPErr <> 'Y' AND                                           CLE038
     C************                 WPercentNum <> *ZERO                                       CLE038
     C                   IF        WPErr <> 'Y' AND                                           CLE038
     C                             WBErr <> 'Y' AND                                           CLE038
     C                             WSByAmt <> 'A' AND                                         CLE038
     C                             WPercentNum <> *ZERO                                       CLE038
     C                             OR WOErr <> 'Y' AND                                        CLE038
     C                             WBErr <> 'Y' AND                                           CLE038
     C                             WSByAmt = 'A' AND                                          CLE038
     C                             WSAmount <> WRKZEROAMT                                     CLE038
     C                   IF        WPErr <> 'Y' AND
     C                             WPercentNum <> *ZERO
     C                   EXSR      SRVMTH
     C                   EXSR      SRVCCY
     C                   EXSR      SRVACT
     C     WSByAmt       IFEQ      'A'                                                        CLE038
     C     WCErr         ANDNE     'Y'                                                        CLE038
     C                   EXSR      SRVAMT2                                                    CLE038
     C                   ENDIF                                                                CLE038
     C                   ENDIF
     C                   ENDIF                                                                CLE038
 
     C                   IF        WCErr <> 'Y' AND
     C                             WAErr <> 'Y'
     C                   IF        PMode <> 'B'
     C                   EVAL      WArPICL(WRRN0) = WPCcyLoc
     C                   ELSE
     C                   EVAL      WArPICL(@Y) = WPCcyLoc
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        WPErr = 'Y' OR
     C                             WMErr = 'Y' OR
     C                             WCErr = 'Y' OR
     C**********                   WAErr = 'Y'                                                CLE038
     C                             WAErr = 'Y' OR                                             CLE038
     C                             WBErr = 'Y' OR                                             CLE038
     C                             WOErr = 'Y'                                                CLE038
     C                   EVAL      WVErr = 'Y'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        WVErr = 'Y'
     C                   EVAL      *IN15 = *ON
     C                   ELSE
     C                   IF        PMode <> 'B'
     C                   EVAL      WArSEQN0(WRRN0) = WRRN0
     C                   IF        WRRN0 > WRMax
     C                   EVAL      WRMax = WRRN0
     C                   ENDIF
                                                                                              CLE038
     C     #0RCBA        IFNE      'A'                                                        CLE038
     C                   EVAL      #0RAMT = #0RPCG                                            CLE038
     C                   ENDIF                                                                CLE038
     C     #0PYBA        IFNE      'A'                                                        CLE038
     C                   EVAL      #0PAMT = #0PPCG                                            CLE038
     C                   ENDIF                                                                CLE038
                                                                                              CLE038
     C                   UPDATE    LE2230S0
     C                   READC     LE2230S0                               15
     C                   ELSE
     C                   ADD       1             @Y
     C     @Y            OCCUR     LEPD
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDDO
 
      ** No More error in validations
 
     C                   IF        WAction = 'I' OR
     C                             PNoDetails = 'Y'
     C                   IF        WVErr <> 'Y'
 
      ** Compute Total Receive/Payment Percentage
 
     C                   EVAL      WTotRcv = 0
     C                   EVAL      WTotPay = 0
     C                   EVAL      WTotRcvAmt = 0                                             CLE038
     C                   EVAL      WTotPayAmt = 0                                             CLE038
 
     C                   EVAL      WCntC = 1
 
     C                   DOW       WCntC <= WRMax and PMode <> 'B'
     C                             OR WCntC <= @X and PMode = 'B'                             197145
     C                   IF        PMode <> 'B'
     C                   EVAL      WcR = WArSEQN0(WCntC)
     C                   ELSE
     C                   EVAL      WcR = WCntC
     C                   ENDIF
     C                   IF        WcR <> *ZERO
     C     WArRByAmt     IFEQ      'A'                                                        CLE038
     C                   EVAL      WTotRcvAmt = WTotRcvAmt +                                  CLE038
     C                              WArRTAmt(WcR)                                             CLE038
     C                   ELSE                                                                 CLE038
     C                   EVAL      WTotRcv = WTotRcv + WArRPcg(WcR)
     C                   ENDIF                                                                CLE038
     C     WArPByAmt     IFEQ      'A'                                                        CLE038
     C                   EVAL      WTotPayAmt = WTotPayAmt +                                  CLE038
     C                              WArPTAmt(WcR)                                             CLE038
     C                   ELSE                                                                 CLE038
     C                   EVAL      WTotPay = WTotPay + WArPPcg(WcR)
     C                   ENDIF                                                                CLE038
     C                   ENDIF
     C                   EVAL      WCntC = WCntC + 1
     C                   ENDDO
 
      ** Total Receive Percentage and Total Payment Percentage
      ** should be equal to 100
 
     C***********        IF        WTotRcv <> 100 AND                                         CLE038
     C***********                  *IN60 = *OFF                                               CLE038
     C                   IF        *IN60 = *OFF                                               CLE038
     C                   IF        WArRByAmt = 'A'                                            CLE038
     C                   IF        WTotRcvAmt <> PAllcAmt                                     CLE038
     C                   EVAL      ZAMSID = 'ESM0830'                                         CLE038
     C                   EXSR      ZASNMS                                                     CLE038
     C                   EVAL      WVErr = 'Y'                                                CLE038
     C                   EVAL      WTErr = 'Y'                                                CLE038
     C                   ENDIF                                                                CLE038
     C                   ELSE                                                                 CLE038
     C                   IF        WTotRcv <> 100 AND
     C                             *IN60 = *OFF
     C                   EVAL      ZAMSID = 'ESM0822'
     C                   EXSR      ZASNMS
     C                   EVAL      WVErr = 'Y'
     C                   EVAL      WTErr = 'Y'
     C                   ENDIF                                                                CLE038
     C                   ENDIF                                                                CLE038
     C                   ENDIF
 
     C***********        IF        WTotPay <> 100 AND                                         CLE038
     C***********                  *IN61 = *OFF                                               CLE038
     C                   IF        *IN61 = *OFF                                               CLE038
     C                   IF        WArPByAmt = 'A'                                            CLE038
     C                   IF        WTotPayAMT <> PAllcAmt                                     CLE038
     C                   EVAL      ZAMSID = 'ESM0831'                                         CLE038
     C                   EXSR      ZASNMS                                                     CLE038
     C                   EVAL      WVErr = 'Y'                                                CLE038
     C                   EVAL      WTErr = 'Y'                                                CLE038
     C                   ENDIF                                                                CLE038
     C                   ELSE                                                                 CLE038
     C                   IF        WTotPay <> 100 AND
     C                             *IN61 = *OFF
     C                   EVAL      ZAMSID = 'ESM0823'
     C                   EXSR      ZASNMS
     C                   EVAL      WVErr = 'Y'
     C                   EVAL      WTErr = 'Y'
     C                   ENDIF                                                                CLE038
     C                   ENDIF                                                                CLE038
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        WTErr <> 'Y'
     C                   EVAL      WFormat = 'FULL'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  CLE038
      *****************************************************************                       CLE038
      *                                                               *                       CLE038
      *  SRVBYA - Validate By Amount                                  *                       CLE038
      *                                                               *                       CLE038
      *****************************************************************                       CLE038
     C     SRVBYA        BEGSR                                                                CLE038
                                                                                              CLE038
     C                   EVAL      WBErr = 'N'                                                CLE038
                                                                                              CLE038
     C                   IF        *IN51 = *OFF                                               CLE038
     C                   MOVEL     'P'           WSByAmt                                      CLE038
     C                   ENDIF                                                                CLE038
     C                   IF        WSByAmt <> 'A' AND                                         CLE038
     C                             WSByAmt <> 'P'                                             CLE038
     C                   EVAL      ZAMSID = 'ESM0833'                                         CLE038
     C                   EVAL      *IN53 = *ON                                                CLE038
     C                   IF        WPRInd = 'P'                                               CLE038
     C                   EVAL      ZAMSID = 'ESM0832'                                         CLE038
     C                   EVAL      *IN54 = *ON                                                CLE038
     C                   EVAL      *IN53 = *OFF                                               CLE038
     C                   ENDIF                                                                CLE038
     C                   EXSR      ZASNMS                                                     CLE038
     C                   EVAL      WBErr = 'Y'                                                CLE038
     C                   ENDIF                                                                CLE038
                                                                                              CLE038
     C                   IF        WBErr <> 'Y'                                               CLE038
     C                   IF        PType = 'LOAN'                                             CLE038
     C                   IF        WPRInd = 'R' AND                                           CLE038
     C                             WSByAmt <> 'P'                                             CLE038
     C                   EVAL      ZAMSID = 'ESM0834'                                         CLE038
     C                   EVAL      *IN53 = *ON                                                CLE038
     C                   EXSR      ZASNMS                                                     CLE038
     C                   EVAL      WBErr = 'Y'                                                CLE038
     C                   ENDIF                                                                CLE038
     C                   ENDIF                                                                CLE038
     C                   IF        PType = 'PTSO'                                             CLE038
     C                   IF        WPRInd = 'P' AND                                           CLE038
     C                             WSByAmt <> 'P'                                             CLE038
     C                   EVAL      ZAMSID = 'ESM0835'                                         CLE038
     C                   EVAL      *IN54 = *ON                                                CLE038
     C                   EXSR      ZASNMS                                                     CLE038
     C                   EVAL      WBErr = 'Y'                                                CLE038
     C                   ENDIF                                                                CLE038
     C                   ENDIF                                                                CLE038
                                                                                              CLE038
     C                   SELECT                                                               CLE038
                                                                                              CLE038
     C                   WHEN      WPRInd = 'P'                                               CLE038
     C                   IF        WArPByAmt = *BLANKS                                        CLE038
     C                   EVAL      WArPByAmt = WSByAmt                                        CLE038
     C                   ELSE                                                                 CLE038
     C                   IF        WArPByAmt <> WSByAmt                                       CLE038
     C                   EVAL      ZAMSID = 'ESM0836'                                         CLE038
     C                   EVAL      *IN54 = *ON                                                CLE038
     C                   EXSR      ZASNMS                                                     CLE038
     C                   EVAL      WBErr = 'Y'                                                CLE038
     C                   ENDIF                                                                CLE038
     C                   ENDIF                                                                CLE038
                                                                                              CLE038
     C                   WHEN      WPRInd = 'R'                                               CLE038
     C                   IF        WArRByAmt = *BLANKS                                        CLE038
     C                   EVAL      WArRByAmt = WSByAmt                                        CLE038
     C                   ELSE                                                                 CLE038
     C                   IF        WArRByAmt <> WSByAmt                                       CLE038
     C                   EVAL      ZAMSID = 'ESM0837'                                         CLE038
     C                   EVAL      *IN53 = *ON                                                CLE038
     C                   EXSR      ZASNMS                                                     CLE038
     C                   EVAL      WBErr = 'Y'                                                CLE038
     C                   ENDIF                                                                CLE038
     C                   ENDIF                                                                CLE038
                                                                                              CLE038
     C                   ENDSL                                                                CLE038
     C                   ENDIF                                                                CLE038
                                                                                              CLE038
     C                   ENDSR                                                                CLE038
      *****************************************************************                       CLE038
      /EJECT                                                                                  CLE038
      *****************************************************************                       CLE038
      *                                                               *                       CLE038
      *  SRVAMT1 - Validate Amount before currency validated          *                       CLE038
      *                                                               *                       CLE038
      *****************************************************************                       CLE038
     C     SRVAMT1       BEGSR                                                                CLE038
                                                                                              CLE038
     C                   EVAL      WOErr = 'N'                                                CLE038
                                                                                              CLE038
     C                   MOVE      *Blanks       ZFld17                                       CLE038
     C                   MOVE      WSAmount      ZFld17                                       CLE038
     C                   IF        WPRInd = 'P'                                               CLE038
     C                   Z-ADD     WPayDP        ZADEC                                        CLE038
     C                   ELSE                                                                 CLE038
     C                   Z-ADD     WRecDP        ZADEC                                        CLE038
     C                   ENDIF                                                                CLE038
     C     13            SUB       ZADEC         ZADIG                                        CLE038
                                                                                              CLE038
     C                   EXSR      ZASIGN                                                     CLE038
                                                                                              CLE038
     C                   IF        WSAmount <> *Blanks AND                                    CLE038
     C                             ZAsignOk = 'N'                                             CLE038
     C                   EVAL      ZAMSID = 'ESM0839'                                         CLE038
     C                   EVAL      *IN22 = *ON                                                CLE038
     C                   IF        WPRInd = 'P'                                               CLE038
     C                   EVAL      ZAMSID = 'ESM0838'                                         CLE038
     C                   EVAL      *IN26 = *ON                                                CLE038
     C                   EVAL      *IN22 = *OFF                                               CLE038
     C                   ENDIF                                                                CLE038
     C                   EXSR      ZASNMS                                                     CLE038
     C                   EVAL      WOErr = 'Y'                                                CLE038
     C                   ELSE                                                                 CLE038
                                                                                              CLE038
     C                   MOVE      ZOUT15        WAmountNum                                   CLE038
                                                                                              CLE038
     C                   ENDIF                                                                CLE038
                                                                                              CLE038
                                                                                              CLE038
     C                   ENDSR                                                                CLE038
      *****************************************************************                       CLE038
      /EJECT                                                                                  CLE038
      *****************************************************************                       CLE038
      *                                                               *                       CLE038
      *  SRVAMT2 - Validate Amount after currency validated           *                       CLE038
      *                                                               *                       CLE038
      *****************************************************************                       CLE038
     C     SRVAMT2       BEGSR                                                                CLE038
                                                                                              CLE038
     C                   EVAL      WOErr = 'N'                                                CLE038
                                                                                              CLE038
     C                   MOVE      *Blanks       ZFld17                                       CLE038
     C                   MOVE      WSAmount      ZFld17                                       CLE038
     C                   Z-ADD     WSCcyDP       ZADEC                                        CLE038
     C     13            SUB       ZADEC         ZADIG                                        CLE038
                                                                                              CLE038
     C                   EXSR      ZASIGN                                                     CLE038
                                                                                              CLE038
     C                   IF        WSAmount <> *Blanks AND                                    CLE038
     C                             ZAsignOk = 'N'                                             CLE038
     C                   EVAL      ZAMSID = 'ESM0841'                                         CLE038
     C                   EVAL      *IN22 = *ON                                                CLE038
     C                   IF        WPRInd = 'P'                                               CLE038
     C                   EVAL      ZAMSID = 'ESM0840'                                         CLE038
     C                   EVAL      *IN26 = *ON                                                CLE038
     C                   EVAL      *IN22 = *OFF                                               CLE038
     C                   ENDIF                                                                CLE038
     C                   EXSR      ZASNMS                                                     CLE038
     C                   EVAL      WOErr = 'Y'                                                CLE038
     C                   ENDIF                                                                CLE038
                                                                                              CLE038
     C                   IF        WOErr <> 'Y'                                               CLE038
                                                                                              CLE038
     C                   MOVE      ZOUT15        WAmountNum                                   CLE038
                                                                                              CLE038
     C                   SELECT                                                               CLE038
                                                                                              CLE038
     C                   WHEN      WPRInd = 'P'                                               CLE038
     C                   IF        WAmountNum = *ZERO                                         CLE038
     C                   EVAL      #0PAMT = *BLANKS                                           CLE038
     C                   IF        WSMethod <> *BLANKS  AND                                   CLE038
     C                             WSMethod <> '00' OR                                        CLE038
     C                             WSCurrency <> *BLANKS OR                                   CLE038
     C                             WSAccount <> *BLANKS                                       CLE038
     C                   EVAL      ZAMSID = 'ESM0842'                                         CLE038
     C                   EVAL      *IN26 = *ON                                                CLE038
     C                   EXSR      ZASNMS                                                     CLE038
     C                   EVAL      WOErr = 'Y'                                                CLE038
     C                   ENDIF                                                                CLE038
     C                   EVAL      PMPPAY = 'Y'                                               CLE038
     C                   ELSE                                                                 CLE038
     C                   MOVE      *BLANKS       ZField                                       CLE038
     C                   MOVE      WAmountNum    ZField                                       CLE038
     C                   Z-ADD     WSCcyDP       ZADEC                                        CLE038
     C                   EXSR      ZEDIT                                                      CLE038
     C                   MOVE      ZField        #0PAMT                                       CLE038
     C                   ENDIF                                                                CLE038
                                                                                              CLE038
     C     WSetlCcy      IFEQ      PMPCCY                                                     CLE038
     C                   IF        PMode <> 'B'                                               CLE038
     C                   EVAL      WArPAmt(WRRN0) = WAmountNum                                CLE038
     C                   EVAL      WArPTAmt(WRRN0) = WAmountNum                               CLE038
     C                   ELSE                                                                 CLE038
     C                   EVAL      WArPAmt(@Y) = WAmountNum                                   CLE038
     C                   EVAL      WArPTAmt(@Y) = WAmountNum                                  CLE038
     C                   ENDIF                                                                CLE038
     C                   ELSE                                                                 CLE038
                                                                                              CLE038
     C*                                                                                       CLE038
     C** Convert amount to transaction currency                                               CLE038
     C*                                                                                       CLE038
     C     #0PEXR        IFEQ      *BLANKS                                                    CLE038
     C                   Z-ADD     *ZEROS        WKPEXR                                       CLE038
     C                   ELSE                                                                 CLE038
     C                   MOVE      *BLANKS       ZFld17                                       CLE038
     C                   MOVE      #0PEXR        ZFld17                                       CLE038
     C                   Z-ADD     8             ZADEC                                        CLE038
     C                   Z-ADD     5             ZADIG                                        CLE038
     C                   EXSR      ZASIGN                                                     CLE038
     C                   Z-ADD     *ZEROS        WKPEXR                                       CLE038
     C                   MOVE      ZOUT15        WKPEXR                                       CLE038
     C                   IF        ZAsignOk = 'N'                                             CLE038
     C                   Z-ADD     *ZEROS        WKPEXR                                       CLE038
     C                   ENDIF                                                                CLE038
     C                   ENDIF                                                                CLE038
     C     WKPEXR        IFEQ      0                                                          CLE038
     C                   Z-ADD     A6SPRT        ZRATE1                                       CLE038
     C                   MOVE      A6MDIN        ZMDI1                                        CLE038
     C                   Z-ADD     WPaySpot      ZRATE2                                       CLE038
     C                   MOVE      WPayMDI       ZMDI2                                        CLE038
     C                   EXSR      ZXRATE                                                     CLE038
     C                   Z-ADD     ZRATEX        ZEXCH                                        CLE038
     C                   MOVE      ZMDIX         ZMD                                          CLE038
     C                   ELSE                                                                 CLE038
     C                   Z-ADD     WKPEXR        ZEXCH                                        CLE038
     C     #0PEXI        IFEQ      'M'                                                        CLE038
     C                   MOVEL     'D'           ZMD                                          CLE038
     C                   ELSE                                                                 CLE038
     C                   MOVEL     'M'           ZMD                                          CLE038
     C                   ENDIF                                                                CLE038
     C                   ENDIF                                                                CLE038
      *                                                                                       CLE038
     C                   MOVE      WSetlCcy      ZCCYI                                        CLE038
     C                   MOVE      PMPCCY        ZCCYO                                        CLE038
     C                   MOVE      WSCcyDP       ZCDPI                                        CLE038
     C                   MOVE      WPayDP        ZCDPO                                        CLE038
     C                   Z-ADD     WAmountNum    ZAMTCI                                       CLE038
     C                   EXSR      ZCONV                                                      CLE038
                                                                                              CLE038
     C                   IF        PMode <> 'B'                                               CLE038
     C                   EVAL      WArPAmt(WRRN0) = WAmountNum                                CLE038
     C                   EVAL      WArPTAmt(WRRN0) = ZAMTCO                                   CLE038
     C                   ELSE                                                                 CLE038
     C                   EVAL      WArPAmt(@Y) = WAmountNum                                   CLE038
     C                   EVAL      WArPTAmt(@Y) = ZAMTCO                                      CLE038
     C                   ENDIF                                                                CLE038
     C                   ENDIF                                                                CLE038
                                                                                              CLE038
     C                   WHEN      WPRInd = 'R'                                               CLE038
     C                   IF        WAmountNum = *ZERO                                         CLE038
     C                   EVAL      #0RAMT = *BLANKS                                           CLE038
     C                   IF        WSMethod <> *BLANKS  AND                                   CLE038
     C                             WSMethod <> '00' OR                                        CLE038
     C                             WSCurrency <> *BLANKS OR                                   CLE038
     C                             WSAccount <> *BLANKS                                       CLE038
     C                   EVAL      ZAMSID = 'ESM0843'                                         CLE038
     C                   EVAL      *IN22 = *ON                                                CLE038
     C                   EXSR      ZASNMS                                                     CLE038
     C                   EVAL      WOErr = 'Y'                                                CLE038
     C                   ENDIF                                                                CLE038
     C                   EVAL      PMPRCV = 'Y'                                               CLE038
     C                   ELSE                                                                 CLE038
     C                   MOVE      *BLANKS       ZField                                       CLE038
     C                   MOVE      WAmountNum    ZField                                       CLE038
     C                   Z-ADD     WSCcyDP       ZADEC                                        CLE038
     C                   EXSR      ZEDIT                                                      CLE038
     C                   MOVE      ZField        #0RAMT                                       CLE038
     C                   ENDIF                                                                CLE038
     C     WSetlCcy      IFEQ      PMRCCY                                                     CLE038
     C                   IF        PMode <> 'B'                                               CLE038
     C                   EVAL      WArRAmt(WRRN0) = WAmountNum                                CLE038
     C                   EVAL      WArRTAmt(WRRN0) = WAmountNum                               CLE038
     C                   ELSE                                                                 CLE038
     C                   EVAL      WArRAmt(@Y) = WAmountNum                                   CLE038
     C                   EVAL      WArRTAmt(@Y) = WAmountNum                                  CLE038
     C                   ENDIF                                                                CLE038
     C                   ELSE                                                                 CLE038
     C*                                                                                       CLE038
     C** Convert amount to transaction currency                                               CLE038
     C*                                                                                       CLE038
     C     #0REXR        IFEQ      *BLANKS                                                    CLE038
     C                   Z-ADD     *ZEROS        WKREXR                                       CLE038
     C                   ELSE                                                                 CLE038
     C                   MOVE      *BLANKS       ZFld17                                       CLE038
     C                   MOVE      #0REXR        ZFld17                                       CLE038
     C                   Z-ADD     8             ZADEC                                        CLE038
     C                   Z-ADD     5             ZADIG                                        CLE038
     C                   EXSR      ZASIGN                                                     CLE038
     C                   Z-ADD     *ZEROS        WKREXR                                       CLE038
     C                   MOVE      ZOUT15        WKREXR                                       CLE038
     C                   IF        ZAsignOk = 'N'                                             CLE038
     C                   Z-ADD     *ZEROS        WKREXR                                       CLE038
     C                   ENDIF                                                                CLE038
     C                   ENDIF                                                                CLE038
     C     WKREXR        IFEQ      0                                                          CLE038
     C                   Z-ADD     A6SPRT        ZRATE1                                       CLE038
     C                   MOVE      A6MDIN        ZMDI1                                        CLE038
     C                   Z-ADD     WRecSpot      ZRATE2                                       CLE038
     C                   MOVE      WRecMDI       ZMDI2                                        CLE038
     C                   EXSR      ZXRATE                                                     CLE038
     C                   Z-ADD     ZRATEX        ZEXCH                                        CLE038
     C                   MOVE      ZMDIX         ZMD                                          CLE038
     C                   ELSE                                                                 CLE038
     C                   Z-ADD     WKREXR        ZEXCH                                        CLE038
     C     #0REXI        IFEQ      'M'                                                        CLE038
     C                   MOVEL     'D'           ZMD                                          CLE038
     C                   ELSE                                                                 CLE038
     C                   MOVEL     'M'           ZMD                                          CLE038
     C                   ENDIF                                                                CLE038
     C                   ENDIF                                                                CLE038
      *                                                                                       CLE038
     C                   MOVE      WSetlCcy      ZCCYI                                        CLE038
     C                   MOVE      PMRCCY        ZCCYO                                        CLE038
     C                   MOVE      WSCcyDP       ZCDPI                                        CLE038
     C                   MOVE      WRecDP        ZCDPO                                        CLE038
     C                   Z-ADD     WAmountNum    ZAMTCI                                       CLE038
     C                   EXSR      ZCONV                                                      CLE038
                                                                                              CLE038
     C                   IF        PMode <> 'B'                                               CLE038
     C                   EVAL      WArRAmt(WRRN0) = WAmountNum                                CLE038
     C                   EVAL      WArRTAmt(WRRN0) = ZAMTCO                                   CLE038
     C                   ELSE                                                                 CLE038
     C                   EVAL      WArRAmt(@Y) = WAmountNum                                   CLE038
     C                   EVAL      WArRTAmt(@Y) = ZAMTCO                                      CLE038
     C                   ENDIF                                                                CLE038
     C                   ENDIF                                                                CLE038
                                                                                              CLE038
     C                   ENDSL                                                                CLE038
     C                   ENDIF                                                                CLE038
                                                                                              CLE038
     C                   ENDSR                                                                CLE038
      *****************************************************************                       CLE038
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVPCT - Validate Percentage Routine                         *
      *                                                               *
      *****************************************************************
     C     SRVPCT        BEGSR
 
     C                   EVAL      WPErr = 'N'
 
     C                   MOVE      *Blanks       ZFld17
     C                   MOVE      WSPercentage  ZFld17
     C                   Z-ADD     9             ZADEC
     C                   Z-ADD     3             ZADIG
 
     C                   EXSR      ZASIGN
 
     C                   IF        WSPercentage <> *Blanks AND
     C                             ZAsignOk = 'N'
     C                   EVAL      ZAMSID = 'ESM0824'
     C                   EVAL      *IN22 = *ON
     C                   IF        WPRInd = 'P'
     C                   EVAL      ZAMSID = 'ESM0825'
     C                   EVAL      *IN26 = *ON
     C                   EVAL      *IN22 = *OFF
     C                   ENDIF
     C                   EXSR      ZASNMS
     C                   EVAL      WPErr = 'Y'
     C                   ENDIF
 
     C                   IF        WPErr <> 'Y'
 
     C                   MOVE      ZOUT15        WPercentNum
 
     C                   SELECT
 
     C                   WHEN      WPRInd = 'P'
     C                   IF        WPercentNum = *ZERO
     C                   EVAL      #0PPCG = *BLANKS
     C                   IF        WSMethod <> *BLANKS  AND
     C                             WSMethod <> '00' OR
     C                             WSCurrency <> *BLANKS OR
     C                             WSAccount <> *BLANKS
     C                   EVAL      ZAMSID = 'ESM0829'
     C                   EVAL      *IN26 = *ON
     C                   EXSR      ZASNMS
     C                   EVAL      WPErr = 'Y'
     C                   ENDIF
     C                   EVAL      PMPPAY = 'Y'
     C                   ELSE
     C                   MOVE      *BLANKS       ZField
     C                   MOVE      WPercentNum   ZField
     C                   Z-ADD     9             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZField        #0PPCG
     C                   MOVE      ZField        #0PAMT                                       CLE038
     C                   ENDIF
     C                   IF        PMode <> 'B'
     C                   EVAL      WArPPcg(WRRN0) = WPercentNum
     C                   ELSE
     C                   EVAL      WArPPcg(@Y) = WPercentNum
     C                   ENDIF
 
     C                   WHEN      WPRInd = 'R'
     C                   IF        WPercentNum = *ZERO
     C                   EVAL      #0RPCG = *BLANKS
     C                   IF        WSMethod <> *BLANKS  AND
     C                             WSMethod <> '00' OR
     C                             WSCurrency <> *BLANKS OR
     C                             WSAccount <> *BLANKS
     C                   EVAL      ZAMSID = 'ESM0828'
     C                   EVAL      *IN22 = *ON
     C                   EXSR      ZASNMS
     C                   EVAL      WPErr = 'Y'
     C                   ENDIF
     C                   EVAL      PMPRCV = 'Y'
     C                   ELSE
     C                   MOVE      *BLANKS       ZField
     C                   MOVE      WPercentNum   ZField
     C                   Z-ADD     9             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZField        #0RPCG
     C                   MOVE      ZField        #0RAMT                                       CLE038
     C                   ENDIF
     C                   IF        PMode <> 'B'
     C                   EVAL      WArRPcg(WRRN0) = WPercentNum
     C                   ELSE
     C                   EVAL      WArRPcg(@Y) = WPercentNum
     C                   ENDIF
 
     C                   ENDSL
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVCCY - Validate Currency subroutine                        *
      *                                                               *
      *****************************************************************
     C     SRVCCY        BEGSR
 
     C                   EVAL      WCErr = 'N'
 
     C                   IF        WSCurrency <> *BLANKS
 
     C                   IF        CLE031 <> 'Y' AND
     C                             CEU004 <> 'Y'
 
     C                   EVAL      ZAMSID = 'ESM0848'
     C                   SELECT
     C                   WHEN      WPRInd = 'P'
     C                   EVAL      *IN28 = *ON
     C                   WHEN      WPRInd = 'R'
     C                   EVAL      *IN24 = *ON
     C                   ENDSL
     C                   EXSR      ZASNMS
     C                   EVAL      WCErr = 'Y'
 
     C                   ELSE
 
     C                   EVAL      PCurr = WSCurrency
     C                   EXSR      SRAOCURR
 
     C                   IF        PRetCode <> *BLANKS
 
     C                   EVAL      ZAMSID = 'ESM0848'
     C                   SELECT
     C                   WHEN      WPRInd = 'P'
     C                   EVAL      *IN28 = *ON
     C                   WHEN      WPRInd = 'R'
     C                   EVAL      ZAMSID = 'ESM0862'
     C                   EVAL      *IN24 = *ON
     C                   ENDSL
     C                   EXSR      ZASNMS
     C                   EVAL      WCErr = 'Y'
 
     C                   ELSE
 
     C                   EVAL      WSCurrency = A6CYCD
     C                   EVAL      WInCurrency = A6INCY
     C                   EVAL      WSCcyDP = A6NBDP                                           CLE038
 
     C     WSMethod      IFEQ      '09'                                                       CLE038
     C     CLE033        ANDEQ     'Y'                                                        CLE038
     C     WSetl09Ccy    ANDEQ     'T'                                                        CLE038
     C**  Do nothing                                                                          CLE038
     C                   ELSE                                                                 CLE038
     C                   IF        CEU004 = 'Y'
 
     C**********         IF        WPRInd = 'R' AND                                           219070
     C**********                   WRcvInCcy = 'Y' OR                                         219070
     C**********                   WPRInd = 'R' AND                                           219070
     C**********                   PMRCCY = BKEURO OR                                         219070
     C**********                   WPRInd = 'P' AND                                           219070
     C**********                   WPayInCcy = 'Y' OR                                         219070
     C**********                   WPRInd = 'P' AND                                           219070
     C**********                   PMPCCY = BKEURO                                            219070
      **********                                                                              219070
     C**********         IF        WInCurrency <> 'Y'                                         219070
     C**********         EVAL      ZAMSID = 'ESM0853'                                         219070
     C**********         SELECT                                                               219070
     C**********         WHEN      WPRInd = 'P'                                               219070
     C**********         EVAL      *IN28 = *ON                                                219070
     C**********         WHEN      WPRInd = 'R'                                               219070
     C**********         EVAL      ZAMSID = 'ESM0850'                                         219070
     C**********         EVAL      *IN24 = *ON                                                219070
     C**********         ENDSL                                                                219070
     C**********         EXSR      ZASNMS                                                     219070
     C**********         EVAL      WCErr = 'Y'                                                219070
     C**********         ELSE                                                                 219070
      *                                                                                       219070
      * If transaction uses an 'In' currency:                                                 219070
     C                   IF        WPRInd = 'R' AND                                           219070
     C                             WRcvInCcy = 'Y' OR                                         219070
     C                             WPRInd = 'P' AND                                           219070
     C                             WPayInCcy = 'Y'                                            219070
      *  Display error message ESM0854 if                                                     219070
      *  settlement currency is not 'EUR':                                                    219070
     C                   IF        WSCurrency <> BKEURO
     C                   EVAL      ZAMSID = 'ESM0854'
     C                   SELECT
     C                   WHEN      WPRInd = 'P'
     C                   EVAL      *IN28 = *ON
     C                   WHEN      WPRInd = 'R'
     C                   EVAL      ZAMSID = 'ESM0851'
     C                   EVAL      *IN24 = *ON
     C                   ENDSL
     C                   EXSR      ZASNMS
     C                   EVAL      WCErr = 'Y'
     C                   ENDIF
     C**********         ENDIF
                                                                                              219070
     C                   ELSE
 
     C                   IF        CLE031 <> 'Y'
     C                   EVAL      ZAMSID = 'ESM0844'
     C                   SELECT
     C                   WHEN      WPRInd = 'P'
     C                   EVAL      *IN28 = *ON
     C                   WHEN      WPRInd = 'R'
     C                   EVAL      *IN24 = *ON
     C                   ENDSL
     C                   EXSR      ZASNMS
     C                   EVAL      WCErr = 'Y'
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF                                                                CLE038
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        WCErr <> 'Y'
 
     C                   SELECT
 
     C                   WHEN      WPRInd = 'P'
     C                   MOVE      WSCurrency    #0PCCY
     C                   EVAL      %SUBST(WPCcyLoc:1) = WSCurrency
     C                   IF        PMode <> 'B'
     C                   EVAL      WArPCcy(WRRN0) = WSCurrency
     C                   ELSE
     C                   EVAL      WArPCcy(@Y) = WSCurrency
     C                   ENDIF
 
     C                   WHEN      WPRInd = 'R'
     C                   MOVE      WSCurrency    #0RCCY
     C                   EVAL      %SUBST(WRCcyLoc:1) = WSCurrency
     C                   IF        PMode <> 'B'
     C                   EVAL      WArRCcy(WRRN0) = WSCurrency
     C                   ELSE
     C                   EVAL      WArRCcy(@Y) = WSCurrency
     C                   ENDIF
 
     C                   ENDSL
     C                   ENDIF
                                                                                              CLE038
     C                   IF        WSCurrency = *BLANKS                                       CLE038
     C                             OR WSCurrency <> *BLANKS AND CLE033 = 'Y'                  CLE038
     C                             AND WSMethod = '09' AND WSetl09Ccy = 'T'                   CLE038
                                                                                              CLE038
     C                   SELECT                                                               CLE038
     C                   WHEN      WPRInd = 'P'                                               CLE038
     C                   EVAL      WSCcyDP = WPayDP                                           CLE038
     C                   WHEN      WPRInd = 'R'                                               CLE038
     C                   EVAL      WSCcyDP = WRecDP                                           CLE038
     C                   ENDSL                                                                CLE038
     C                   ENDIF                                                                CLE038
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVMTH - Validate Method subroutine                          *
      *                                                               *
      *****************************************************************
     C     SRVMTH        BEGSR
 
     C                   EVAL      WMErr = 'N'
 
     C                   EVAL      WSetlCcy = WSCurrency
 
     C**********         IF        WSetlCcy = *BLANKS                                         218782
     C                   IF        WSetlCcy = *BLANKS OR                                      218782
     C                             WSetl09Ccy ='T' AND WSMethod = '09'                        218782
     C                   SELECT
     C                   WHEN      WPRInd = 'R'
     C                   EVAL      WSetlCcy = PMRCCY
     C                   WHEN      WPRInd = 'P'
     C                   EVAL      WSetlCcy = PMPCCY
     C                   ENDSL
     C                   ENDIF
 
      ** Case 1
 
     C                   IF        WSMethod = '00'
     C                   IF        WSAccount <> *BLANKS OR
     C                             WSCurrency <> *BLANKS
     C                   EVAL      ZAMSID = 'ESM0929'
     C                   SELECT
     C                   WHEN      WPRInd = 'P'
     C                   EVAL      *IN27 = *ON
     C                   WHEN      WPRInd = 'R'
     C                   EVAL      ZAMSID = 'ESM0900'
     C                   EVAL      *IN23 = *ON
     C                   ENDSL
     C                   EXSR      ZASNMS
     C                   EVAL      WMErr = 'Y'
     C                   ENDIF
     C                   ENDIF
 
      ** Case 2
 
     C                   IF        CLE033 <> 'Y' OR
     C                             CLE033 = 'Y' AND
     C                             WSMethod <> '09'
     C                   IF        WSMethod <> '00' AND
     C                             WSMethod <> '01' AND
     C                             WSMethod <> '02' AND
     C                             WSMethod <> '03' AND
     C                             WSMethod <> '04' AND
     C                             WSMethod <> '05' AND
     C                             WSMethod <> '06' AND
     C                             WSMethod <> '07' AND
     C                             WSMethod <> '08' AND
     C                             WSMethod <> '12' AND
     C                             WSMethod <> '14'
     C                   EVAL      ZAMSID = 'ESM0931'
     C                   SELECT
     C                   WHEN      WPRInd = 'P'
     C                   EVAL      *IN27 = *ON
     C                   WHEN      WPRInd = 'R'
     C                   EVAL      ZAMSID = 'ESM0902'
     C                   EVAL      *IN23 = *ON
     C                   ENDSL
     C                   EXSR      ZASNMS
     C                   EVAL      WMErr = 'Y'
     C                   ENDIF
     C                   ENDIF
 
      ** Case 3
 
     C                   IF        WSMethod = '04' OR
     C                             WSMethod = '14'
     C                   IF        PMRETP <> 'Y'
     C                   EVAL      ZAMSID = 'ESM0932'
     C                   SELECT
     C                   WHEN      WPRInd = 'P'
     C                   EVAL      *IN27 = *ON
     C                   WHEN      WPRInd = 'R'
     C                   EVAL      ZAMSID = 'ESM0903'
     C                   EVAL      *IN23 = *ON
     C                   ENDSL
     C                   EXSR      ZASNMS
     C                   EVAL      WMErr = 'Y'
     C                   ENDIF
     C                   ENDIF
 
      ** Case 4
 
     C                   IF        WSMethod = '04'
     C                   EVAL      WrkACID = PMCSNM
     C                   EVAL      WrkCYCD = WSetlCcy
     C                   MOVE      PMPCYA        WrkACCD
     C                   EVAL      WrkACSQ = '01'
     C                   EVAL      WrkBRCA = PMBRCA
     C                   IF        WSBranch = *BLANKS
     C                   EVAL      WSBranch = PMBRCA
     C                   ENDIF
     C                   EXSR      SRAOACCV
     C                   IF        PRetCode <> *BLANKS OR
     C                             ACRECI <> 'D' OR
     C                             ACACST = 'C'
     C                   EVAL      ZAMSID  = 'ESM0934'
     C                   SELECT
     C                   WHEN      WPRInd = 'P'
     C                   EVAL      *IN27 = *ON
     C                   WHEN      WPRInd = 'R'
     C                   EVAL      ZAMSID  = 'ESM0904'
     C                   EVAL      *IN23 = *ON
     C                   ENDSL
     C                   EXSR      ZASNMS
     C                   EVAL      WMErr = 'Y'
     C                   ENDIF
     C                   ENDIF
 
      ** Case 5
 
     C                   IF        WSMethod = '07' AND
     C                             WSetlCcy <> 'USD'
     C                   EVAL      ZAMSID  = 'ESM0935'
     C                   SELECT
     C                   WHEN      WPRInd = 'P'
     C                   EVAL      *IN27 = *ON
     C                   WHEN      WPRInd = 'R'
     C                   EVAL      ZAMSID  = 'ESM0905'
     C                   EVAL      *IN23 = *ON
     C                   ENDSL
     C                   EXSR      ZASNMS
     C                   EVAL      WMErr = 'Y'
     C                   ENDIF
 
      ** Case 6
 
     C                   IF        WSMethod = '14' AND
     C                             PMRETS <> 'Y'
     C                   EVAL      ZAMSID  = 'ESM0936'
     C                   SELECT
     C                   WHEN      WPRInd = 'P'
     C                   EVAL      *IN27 = *ON
     C                   WHEN      WPRInd = 'R'
     C                   EVAL      ZAMSID  = 'ESM0906'
     C                   EVAL      *IN23 = *ON
     C                   ENDSL
     C                   EXSR      ZASNMS
     C                   EVAL      WMErr = 'Y'
     C                   ENDIF
 
      ** Case 7
 
     C                   IF        CLE033 = 'Y' AND
     C                             WSMethod = '09' AND
     C                             A5ACTY = 'R'
     C                   EVAL      WrkCNUM = WSetl09Cus
     C                   EVAL      WrkCYCD = WSetlCcy
     C                   EVAL      WrkACCD = WSetl09AcCd
     C                   EVAL      WrkACSQ = '01'
     C                   EVAL      WrkBRCA = PMBRCA
     C                   EXSR      SRAOACCR
     C                   IF        PRetCode <> *BLANKS OR
     C                             ACRECI <> 'D' OR
     C                             ACATYP <> 'R'
     C                   EVAL      ZAMSID  = 'ESM0934'
     C                   SELECT
     C                   WHEN      WPRInd = 'P'
     C                   EVAL      *IN27 = *ON
     C                   WHEN      WPRInd = 'R'
     C                   EVAL      ZAMSID  = 'ESM0904'
     C                   EVAL      *IN23 = *ON
     C                   ENDSL
     C                   EXSR      ZASNMS
     C                   EVAL      WMErr = 'Y'
     C                   ENDIF
     C                   ENDIF
 
      ** Case 8
 
     C                   IF        AGMBIN = 'Y'
 
     C                   IF        CLE033 <> 'Y' AND
     C                             WSMethod <> '04' AND
     C                             WSMethod <> '05' OR
     C                             CLE033 = 'Y' AND
     C                             WSMethod <> '04' AND
     C                             WSMethod <> '05' AND
     C                             WSMethod <> '09'
     C                   EVAL      WSBranch = *BLANKS
     C                   ELSE
 
     C                   IF        CLE033 = 'Y' AND
     C                             WSMethod = '09'
     C                   ELSE
 
     C                   IF        WSBranch = *BLANKS
     C                   EVAL      ZAMSID  = 'ESM0882'
     C                   SELECT
     C                   WHEN      WPRInd = 'P'
     C                   EVAL      *IN27 = *ON
     C                   WHEN      WPRInd = 'R'
     C                   EVAL      ZAMSID  = 'ESM0885'
     C                   EVAL      *IN23 = *ON
     C                   ENDSL
     C                   EXSR      ZASNMS
     C                   EVAL      WMErr = 'Y'
     C                   ELSE
 
     C                   EVAL      PBranch = WSBranch
     C                   EXSR      SRAOBRCH
     C                   IF        PRetCode = '*NOSEL'
     C                   EVAL      ZAMSID = 'ESM0864'
     C                   SELECT
     C                   WHEN      WPRInd = 'P'
     C                   EVAL      *IN27 = *ON
     C                   WHEN      WPRInd = 'R'
     C                   EVAL      ZAMSID  = 'ESM0863'
     C                   EVAL      *IN23 = *ON
     C                   ENDSL
     C                   EXSR      ZASNMS
     C                   EVAL      WMErr = 'Y'
     C                   ELSE
 
     C                   IF        PRetCode <> *BLANKS
     C                   EVAL      ZAMSID  = 'ESM0881'
     C                   SELECT
     C                   WHEN      WPRInd = 'P'
     C                   EVAL      *IN27 = *ON
     C                   WHEN      WPRInd = 'R'
     C                   EVAL      ZAMSID  = 'ESM0884'
     C                   EVAL      *IN23 = *ON
     C                   ENDSL
     C                   EXSR      ZASNMS
     C                   EVAL      WMErr = 'Y'
     C                   ELSE
 
     C                   EVAL      WSBranch = PBranch
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        WMErr <> 'Y'
 
     C                   SELECT
 
     C                   WHEN      WPRInd = 'P'
     C                   MOVE      WSMethod      #0PMTD
     C                   IF        PMode <> 'B'
     C                   EVAL      WArPMtd(WRRN0) = WSMethod
     C                   ELSE
     C                   EVAL      WArPMtd(@Y) = WSMethod
     C                   ENDIF
 
     C                   WHEN      WPRInd = 'R'
     C                   MOVE      WSMethod      #0RMTD
     C                   IF        PMode <> 'B'
     C                   EVAL      WArRMtd(WRRN0) = WSMethod
     C                   ELSE
     C                   EVAL      WArRMtd(@Y) = WSMethod
     C                   ENDIF
 
     C                   ENDSL
     C*                                                                                       219793
     C                   IF        WSMethod = '01' OR                                         219793
     C                             WSMethod = '02' OR                                         219793
     C                             WSMethod = '07' OR                                         219793
     C                             WSMethod = '08' OR                                         219793
     C                             WSMethod = '12'                                            219793
     C                   MOVEL     'Y'           PSetlNos                                     219793
     C                   ENDIF                                                                219793
     C*                                                                                       219793
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVACT - Validate account subroutine                         *
      *                                                               *
      *****************************************************************
     C     SRVACT        BEGSR
 
     C                   EVAL      WAErr = 'N'
 
      ** Case 1
 
     C                   IF        WSMethod = '00' OR
     C                             WSMethod = '04' OR
     C                             WSMethod = '06'
     C                   IF        WSAccount <> *BLANKS
     C                   EVAL      ZAMSID  = 'ESM0937'
     C                   SELECT
     C                   WHEN      WPRInd = 'P'
     C                   EVAL      *IN29 = *ON
     C                   WHEN      WPRInd = 'R'
     C                   EVAL      ZAMSID  = 'ESM0907'
     C                   EVAL      *IN25 = *ON
     C                   ENDSL
     C                   EXSR      ZASNMS
     C                   EVAL      WAErr = 'Y'
     C                   ENDIF
     C                   ENDIF
 
      ** Case 2
 
     C                   IF        WSMethod = '01' OR
     C                             WSMethod = '02' OR
     C                             WSMethod = '07' OR
     C                             WSMethod = '08' OR
     C                             WSMethod = '12'
 
     C                   EVAL      WNostro = WSAccount
     C                   TESTN                   WNostro              02
     C     '?'           SCAN      WNostro                                03
 
     C                   IF        *IN02 = *OFF AND
     C                             *IN03 = *OFF OR
     C                             %SUBST(WSAccount:3) <> *BLANKS
     C                   EVAL      ZAMSID  = 'ESM0938'
     C                   SELECT
     C                   WHEN      WPRInd = 'P'
     C                   EVAL      *IN29 = *ON
     C                   WHEN      WPRInd = 'R'
     C                   EVAL      ZAMSID  = 'ESM0908'
     C                   EVAL      *IN25 = *ON
     C                   ENDSL
     C                   EXSR      ZASNMS
     C                   EVAL      WAErr = 'Y'
     C                   ELSE
 
     C                   EVAL      WrkCYCD = WSetlCcy
     C                   EVAL      WrkNONB = WSAccount
     C                   EXSR      SRAONOST
     C                   IF        PRetCode <> *BLANKS AND
     C                             PRetCode <> '*NOSEL'
     C                   EVAL      ZAMSID  = 'ESM0938'
     C                   SELECT
     C                   WHEN      WPRInd = 'P'
     C                   EVAL      *IN29 = *ON
     C                   WHEN      WPRInd = 'R'
     C                   EVAL      ZAMSID  = 'ESM0908'
     C                   EVAL      *IN25 = *ON
     C                   ENDSL
     C                   EXSR      ZASNMS
     C                   EVAL      WAErr = 'Y'
     C                   ELSE
 
     C                   IF        PRetCode = '*NOSEL'
     C                   EVAL      ZAMSID  = 'ESM0867'
     C                   SELECT
     C                   WHEN      WPRInd = 'P'
     C                   EVAL      *IN29 = *ON
     C                   WHEN      WPRInd = 'R'
     C                   EVAL      *IN25 = *ON
     C                   ENDSL
     C                   EXSR      ZASNMS
     C                   EVAL      WAErr = 'Y'
     C                   ELSE
 
     C                   EVAL      WrkACID = A7CUST
     C                   EVAL      WrkCYCD = WSetlCcy
     C                   MOVE      A7ACSN        WrkACSQ
     C                   EVAL      WrkACCD = A7ACCD
     C                   EVAL      WrkBRCA = A7BRCD
     C                   IF        WSBranch = *BLANKS
     C                   EVAL      WSBranch = A7BRCD
     C                   ENDIF
     C                   EXSR      SRAOACCV
     C                   IF        PRetCode <> *BLANKS OR
     C                             ACRECI <> 'D'
     C                   EVAL      ZAMSID  = 'ESM0938'
     C                   SELECT
     C                   WHEN      WPRInd = 'P'
     C                   EVAL      *IN29 = *ON
     C                   WHEN      WPRInd = 'R'
     C                   EVAL      ZAMSID  = 'ESM0908'
     C                   EVAL      *IN25 = *ON
     C                   ENDSL
     C                   EXSR      ZASNMS
     C                   EVAL      WAErr = 'Y'
     C                   ELSE
 
     C                   IF        AGMBIN = 'N'
     C                   IF        BJSBRC <> A7BRCD
     C                   EVAL      ZAMSID  = 'ESM0501'
     C                   SELECT
     C                   WHEN      WPRInd = 'P'
     C                   EVAL      *IN29 = *ON
     C                   WHEN      WPRInd = 'R'
     C                   EVAL      ZAMSID  = 'ESM0500'
     C                   EVAL      *IN25 = *ON
     C                   ENDSL
     C                   EXSR      ZASNMS
     C                   EVAL      WAErr = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Case 3
 
     C                   IF        WSMethod = '03' AND
     C                             WSAccount <> *BLANKS
     C                   EVAL      WCustomer = WSAccount
     C                   TESTN                   WCustomer            02
     C                   IF        *IN02 = *OFF OR
     C                             %SUBST(WSAccount:7) <> *BLANKS
     C                   EVAL      ZAMSID  = 'ESM0939'
     C                   SELECT
     C                   WHEN      WPRInd = 'P'
     C                   EVAL      *IN29 = *ON
     C                   WHEN      WPRInd = 'R'
     C                   EVAL      ZAMSID  = 'ESM0909'
     C                   EVAL      *IN25 = *ON
     C                   ENDSL
     C                   EXSR      ZASNMS
     C                   EVAL      WAErr = 'Y'
     C                   ENDIF
     C                   ENDIF
 
      ** Case 4
 
     C                   IF        WSMethod = '05'
 
     C                   IF        AGMBIN = 'Y'
     C                   EVAL      WSBranch = %SUBST(WSAccount:1:3)
     C**********         EVAL      WAccount = %SUBST(WSAccount:4:12)                          CGL029
     C                   EVAL      WAccount = %SUBST(WSAccount:4:18)                          CGL029
     C                   EVAL      WAcodSeq = %SUBST(WSAccount:10:12)                         CSD031
 
     C**********         IF        %SUBST(WAccount:11:2) = *BLANKS OR                         CGL029
     C**********                   %SUBST(WAccount:11:2) = '00'                               CGL029
     C**********         EVAL      %SUBST(WAccount:11:2) = '01'                               CGL029
     C                   IF        %SUBST(WAccount:17:2) = *BLANKS OR                         CGL029
     C                             %SUBST(WAccount:17:2) = '00'                               CGL029
     C                   EVAL      %SUBST(WAccount:17:2) = '01'                               CGL029
     C                   ENDIF
 
     C*****              TESTN                   WAccount             02                      CSD031
     C                   TESTN                   WAcodSeq             02                      CSD031
     C                   IF        *IN02 = *OFF
     C                   EVAL      ZAMSID  = 'ESM0940'
     C                   SELECT
     C                   WHEN      WPRInd = 'P'
     C                   EVAL      *IN29 = *ON
     C                   WHEN      WPRInd = 'R'
     C                   EVAL      ZAMSID  = 'ESM0910'
     C                   EVAL      *IN25 = *ON
     C                   ENDSL
     C                   EXSR      ZASNMS
     C                   EVAL      WAErr = 'Y'
     C                   ELSE
 
     C                   EVAL      WrkACID = %SUBST(WAccount:1:6)
     C                   EVAL      WrkCYCD = WSetlCcy
     C**********         EVAL      WrkACCD = %SUBST(WAccount:7:4)                             CGL029
     C**********         EVAL      WrkACSQ = %SUBST(WAccount:11:2)                            CGL029
     C                   EVAL      WrkACCD = %SUBST(WAccount:7:10)                            CGL029
     C                   EVAL      WrkACSQ = %SUBST(WAccount:17:2)                            CGL029
     C                   EVAL      WrkBRCA = WSBranch
 
     C                   IF        AGMBIN = 'N'
     C                   EVAL      WrkBRCA = BJSBRC
     C                   ENDIF
 
     C                   EXSR      SRAOACCV
 
     C                   IF        PRetCode <> *BLANKS OR
     C                             ACRECI <> 'D' OR
     C                             ACACST = 'C'
 
     C                   IF        CEU004 = 'Y' AND
     C                             WrkCYCD = 'EUR' AND
     C                             PRetCode = '*NRF' OR
     C                             CEU004 = 'Y' AND
     C                             WrkCYCD = BKEURO AND
     C                             WPRInd = 'R' AND
     C                             *IN60 = *ON OR
     C                             CEU004 = 'Y' AND
     C                             WrkCYCD = BKEURO AND
     C                             WPRInd = 'P' AND
     C                             *IN61 = *ON
     C                   EVAL      ZAMSID  = 'ESM0940'
     C                   SELECT
     C                   WHEN      WPRInd = 'P'
     C                   EVAL      *IN29 = *ON
     C                   WHEN      WPRInd = 'R'
     C                   EVAL      ZAMSID  = 'ESM0910'
     C                   EVAL      *IN25 = *ON
     C                   ENDSL
     C                   EXSR      ZASNMS
     C                   EVAL      WAErr = 'Y'
     C                   ELSE
 
     C                   EVAL      ZAMSID  = 'ESM0940'
     C                   SELECT
     C                   WHEN      WPRInd = 'P'
     C                   EVAL      *IN29 = *ON
     C                   WHEN      WPRInd = 'R'
     C                   EVAL      ZAMSID  = 'ESM0910'
     C                   EVAL      *IN25 = *ON
     C                   ENDSL
     C                   EXSR      ZASNMS
     C                   EVAL      WAErr = 'Y'
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Case 5
 
     C                   IF        WSMethod = '14'
 
     C                   EVAL      WRetail = WSAccount
     C                   TESTN                   WRetail              02
 
     C                   IF        *IN02 = *OFF OR
     C                             %SUBST(WSAccount:11) <> *BLANKS
     C                   EVAL      ZAMSID  = 'ESM0941'
     C                   SELECT
     C                   WHEN      WPRInd = 'P'
     C                   EVAL      *IN29 = *ON
     C                   WHEN      WPRInd = 'R'
     C                   EVAL      ZAMSID  = 'ESM0911'
     C                   EVAL      *IN25 = *ON
     C                   ENDSL
     C                   EXSR      ZASNMS
     C                   EVAL      WAErr = 'Y'
     C                   ELSE
 
     C                   EVAL      WrkACID = WRetail
     C                   EVAL      WrkCYCD = *BLANKS
     C                   EVAL      WrkACCD = *BLANKS
     C                   EVAL      WrkACSQ = *BLANKS
     C                   EVAL      WrkBRCA = *BLANKS
 
     C                   EXSR      SRAOACCV
 
     C                   IF        PRetCode <> *BLANKS OR
     C                             ACRECI <> 'D' OR
     C                             ACACST = 'C'
 
     C                   IF        CEU004 = 'Y' AND
     C                             WrkCYCD = 'EUR' AND
     C                             PRetCode = '*NRF' OR
     C                             CEU004 = 'Y' AND
     C                             WSetlCcy = BKEURO AND
     C                             WPRInd = 'R' AND
     C                             *IN60 = *ON OR
     C                             CEU004 = 'Y' AND
     C                             WSetlCcy = BKEURO AND
     C                             WPRInd = 'P' AND
     C                             *IN61 = *ON
     C                   EVAL      ZAMSID  = 'ESM0941'
     C                   SELECT
     C                   WHEN      WPRInd = 'P'
     C                   EVAL      *IN29 = *ON
     C                   WHEN      WPRInd = 'R'
     C                   EVAL      ZAMSID  = 'ESM0911'
     C                   EVAL      *IN25 = *ON
     C                   ENDSL
     C                   EXSR      ZASNMS
     C                   EVAL      WAErr = 'Y'
     C                   ELSE
     C                   EVAL      ZAMSID  = 'ESM0941'
     C                   SELECT
     C                   WHEN      WPRInd = 'P'
     C                   EVAL      *IN29 = *ON
     C                   WHEN      WPRInd = 'R'
     C                   EVAL      ZAMSID  = 'ESM0911'
     C                   EVAL      *IN25 = *ON
     C                   ENDSL
     C                   EXSR      ZASNMS
     C                   EVAL      WAErr = 'Y'
     C                   ENDIF
 
     C                   ELSE
     C                   TESTB     '2'           ACRETB                   04
     C                   TESTB     '3'           ACRETB                   05
 
     C                   IF        *IN04 = *ON OR
     C                             *IN05 = *ON
     C                   EVAL      ZAMSID  = 'ESM0992'
     C                   SELECT
     C                   WHEN      WPRInd = 'P'
     C                   EVAL      *IN29 = *ON
     C                   WHEN      WPRInd = 'R'
     C                   EVAL      ZAMSID  = 'ESM0991'
     C                   EVAL      *IN25 = *ON
     C                   ENDSL
     C                   EXSR      ZASNMS
     C                   EVAL      WAErr = 'Y'
     C                   ENDIF
 
     C                   IF        WSBranch = *BLANKS
     C                   EVAL      WSBranch = ACBRCA
     C                   ENDIF
 
     C                   IF        WSCurrency <> *BLANKS AND
     C                             WSCurrency <> ACCCY OR
     C                             WSCurrency = *BLANKS AND
     C                             WPRInd = 'R' AND
     C                             PMRCCY <> ACCCY OR
     C                             WSCurrency = *BLANKS AND
     C                             WPRInd = 'P' AND
     C                             PMPCCY <> ACCCY
     C                   EVAL      ZAMSID  = 'ESM0944'
     C                   SELECT
     C                   WHEN      WPRInd = 'P'
     C                   EVAL      *IN29 = *ON
     C                   WHEN      WPRInd = 'R'
     C                   EVAL      ZAMSID  = 'ESM0914'
     C                   EVAL      *IN25 = *ON
     C                   ENDSL
     C                   EXSR      ZASNMS
     C                   EVAL      WAErr = 'Y'
     C                   ELSE
 
     C                   IF        AGMBIN = 'N'
     C                   IF        BJSBRC <> A7BRCD
     C                   EVAL      ZAMSID  = 'ESM0887'
     C                   SELECT
     C                   WHEN      WPRInd = 'P'
     C                   EVAL      *IN29 = *ON
     C                   WHEN      WPRInd = 'R'
     C                   EVAL      ZAMSID  = 'ESM0888'
     C                   EVAL      *IN25 = *ON
     C                   ENDSL
     C                   EXSR      ZASNMS
     C                   EVAL      WAErr = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Case 6
 
     C                   IF        ZAMSID = *BLANKS
 
     C                   IF        WSMethod = '01' OR
     C                             WSMethod = '02' OR
     C                             WSMethod = '04' OR
     C                             WSMethod = '05' OR
     C                             WSMethod = '07' OR
     C                             WSMethod = '08' OR
     C                             WSMethod = '12' OR
     C                             WSMethod = '14'
 
     C                   IF        PMDTRC < ACDACO
     C                   IF        CEU004 <> 'Y' OR
     C                             WAction = 'I' OR
     C                             WAction = 'A'
     C                   EVAL      ZAMSID  = 'ESM0942'
     C                   SELECT
     C                   WHEN      WPRInd = 'P'
     C                   EVAL      *IN29 = *ON
     C                   WHEN      WPRInd = 'R'
     C                   EVAL      ZAMSID  = 'ESM0912'
     C                   EVAL      *IN25 = *ON
     C                   ENDSL
     C                   EXSR      ZASNMS
     C                   EVAL      WAErr = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        ACATYP = 'R'
     C                   IF        WPRInd = 'R' AND
     C                             *IN60 = *OFF OR
     C                             WPRInd = 'P' AND
     C                             *IN61 = *OFF
     C                   EVAL      WCompDat = PMRUND - PMBVPD
     C                   IF        PMDTRC < WCompDat
     C                   EVAL      ZAMSID  = 'ESM0943'
     C                   SELECT
     C                   WHEN      WPRInd = 'P'
     C                   EVAL      *IN29 = *ON
     C                   WHEN      WPRInd = 'R'
     C                   EVAL      ZAMSID  = 'ESM0913'
     C                   EVAL      *IN25 = *ON
     C                   ENDSL
     C                   EXSR      ZASNMS
     C                   EVAL      WAErr = 'Y'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        WAErr <> 'Y'
 
     C                   SELECT
 
     C                   WHEN      WPRInd = 'P'
     C                   MOVEL     WSBranch      #0PACC
     C                   MOVEL     WSAccount     #0PACC
     C                   EVAL      %SUBST(WPCcyLoc:1) = WPaySetlCcy
     C                   EVAL      %SUBST(WPCcyLoc:4) = WPaySetlLoc
     C                   IF        WSMethod = '05'
     C                   IF        PMode <> 'B'
     C                   EVAL      WArPAcc(WRRN0) = WAccount
     C                   EVAL      WArPBrc(WRRN0) = WSBranch
     C                   ELSE
     C                   EVAL      WArPAcc(@Y) = WAccount
     C                   EVAL      WArPBrc(@Y) = WSBranch
     C                   ENDIF
     C                   ELSE
     C                   IF        PMode <> 'B'
     C                   EVAL      WArPAcc(WRRN0) = WSAccount
     C                   EVAL      WArPBrc(WRRN0) = *BLANKS
     C                   IF        WSMethod = '09'
     C**********         EVAL      WAccount = %SUBST(WSAccount:4:12)                          CGL029
     C                   EVAL      WAccount = %SUBST(WSAccount:4:18)                          CGL029
     C                   EVAL      WArPAcc(WRRN0) = WAccount
     C                   EVAL      WArPBrc(WRRN0) = WSBranch
     C                   ENDIF
     C                   ELSE
     C                   EVAL      WArPAcc(@Y) = WSAccount
     C                   EVAL      WArPBrc(@Y) = *BLANKS
     C                   ENDIF
     C                   ENDIF
 
     C                   WHEN      WPRInd = 'R'
     C                   MOVEL     WSBranch      #0RACC
     C                   MOVE      WSAccount     #0RACC
     C                   EVAL      %SUBST(WRCcyLoc:1) = WRcvSetlCcy
     C                   EVAL      %SUBST(WRCcyLoc:4) = WRcvSetlLoc
     C                   IF        WSMethod = '05'
     C                   IF        PMode <> 'B'
     C                   EVAL      WArRAcc(WRRN0) = WAccount
     C                   EVAL      WArRBrc(WRRN0) = WSBranch
     C                   ELSE
     C                   EVAL      WArRAcc(@Y) = WAccount
     C                   EVAL      WArRBrc(@Y) = WSBranch
     C                   ENDIF
     C                   ELSE
     C                   IF        PMode <> 'B'
     C                   EVAL      WArRAcc(WRRN0) = WSAccount
     C                   EVAL      WArRBrc(WRRN0) = *BLANKS
     C                   IF        WSMethod = '09'
     C**********         EVAL      WAccount = %SUBST(WSAccount:4:12)                          CGL029
     C                   EVAL      WAccount = %SUBST(WSAccount:4:18)                          CGL029
     C                   EVAL      WArRAcc(WRRN0) = WAccount
     C                   EVAL      WArRBrc(WRRN0) = WSBranch
     C                   ENDIF
     C                   ELSE
     C                   EVAL      WArRAcc(@Y) = WSAccount
     C                   EVAL      WArRBrc(@Y) = *BLANKS
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSL
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFULL - Process Full Details subroutine                     *
      *                                                               *
      *****************************************************************
     C     SRFULL        BEGSR
 
     C                   IF        WAction <> 'E' AND
     C                             WSAction <> 'E'
 
     C                   EVAL      WCntC = 1
 
     C                   DOW       WCntC <= WRMax and PMode <> 'B'
     C                             OR WCntC <= @X and PMode = 'B'                             197145
     C                   IF        WAction = 'I' OR
     C                             WF9 = 'Y' OR
     C                             PNoDetails = 'Y' OR
     C                             PMode = 'B'
     C                   EVAL      WcR = WArSEQN0(WCntC)
     C                   ELSE
     C                   EVAL      WcR = WArSEQN1(WCntC)
     C                   ENDIF
 
     C                   IF        WcR <> *ZERO
 
     C                   IF        WF9 = 'Y'
     C                   EVAL      WrkSequence = WMFSequence
     C                   EVAL      WMFSequence = WMFSequence + 1
     C                   ELSE
     C                   IF        WAction <> 'I' AND
     C                             PNoDetails <> 'Y' OR
     C                             PMode = 'B'
     C                   EVAL      WrkSequence = WcR
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      SETLIAB = XSETLIB
     C                   EVAL      SETLIAZ = XSETLIZ
 
     C                   SELECT
     C                   WHEN      PMode = 'B' AND
     C                             WAction = 'I'
     C                   EXSR      SRSETF
     C                   WHEN      WAction = 'A' AND
     C                             WF9 <> 'Y' AND
     C                             PNoDetails <> 'Y'
     C                   EXSR      SRSETF
     C                   OTHER
     C                   EXSR      SRCLRF
     C                   EXSR      SRTOEX
     C                   ENDSL
 
     C                   IF        PMode = 'B'
     C                   CALL      'SD2410'
     C                   PARM                    SETLIAB
     C                   PARM                    SETLIAZ
     C                   PARM                    @PARM3                                       222373
     C     PMDBSE        IFNE      *ZERO
     C     *LOCK         IN        LDA
     C                   MOVEL     PMDBFL        DBFILE                         ************
     C                   Z-ADD     PMDBSE        DBASE                          * DBERR XX *
     C                   MOVEL     PMDBKY        DBKEY                          ************
     C                   MOVEL     PMDPGM        DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C     PMERCD        IFNE      *BLANKS
     C     3             SUBST     PMERCD:1      WSERR             3
     C                   MOVEL     'ESM0'        ZAMSID
     C                   MOVE      WSERR         ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ELSE
     C                   CALL      'SD2400'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM                    SETLIAB
     C                   PARM                    SETLIAZ
     C                   PARM                    PLnRef
     C                   PARM                    @PARM3                                       222373
     C                   ENDIF
 
     C                   EVAL      PMACTC = WACTC
     C                   EVAL      PMPRCV = WPRCV
     C                   EVAL      PMPPAY = WPPAY
 
     C                   IF        PMSDTV = 'Y'
     C                   EXSR      SRDB
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      WCntC = WCntC + 1
     C                   ENDDO
 
     C                   SELECT
 
     C                   WHEN      PMode = 'B'
     C                   EVAL      WFormat = 'END'
 
     C                   WHEN      WAction = 'I' OR
     C                             PNoDetails = 'Y'
     C                   EVAL      WFormat = 'END'
 
     C                   WHEN      WAction = 'A'
     C                   EVAL      WFormat = 'SUB'
 
     C                   ENDSL
 
      ** Enquire
 
     C                   ELSE
 
     C                   EVAL      WCntC = 1
     C                   EVAL      WcR = WArSEQN1(WCntC)
 
     C                   DOW       WcR <> *ZERO
 
     C                   EVAL      WrkSequence = WcR
 
     C                   EXSR      SRSETF
 
     C                   CALL      'SD2400'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM                    SETLIAB
     C                   PARM                    SETLIAZ
     C                   PARM                    PLnRef
     C                   PARM                    @PARM3                                       222373
 
     C                   EVAL      WCntC = WCntC + 1
     C                   EVAL      WcR = WArSEQN1(WCntC)
     C                   ENDDO
 
     C                   SELECT
 
     C                   WHEN      PMode = 'B'
     C                   EVAL      WFormat = 'END'
     C                   OTHER
     C                   EVAL      WFormat = 'SUB'
 
     C                   ENDSL
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSETF - Setup File Values                                   *
      *                                                               *
      *****************************************************************
     C     SRSETF        BEGSR
 
     C                   EVAL      WType = PType
     C                   IF        PType = 'PTSO'                                             CLE038
     C                   EVAL      WType = 'LOAN'                                             CLE038
     C                   ENDIF                                                                CLE038
     C                   IF        PTimeStamp <> *BLANKS
     C                   MOVE      PTimeStamp    WTimeStamp
     C                   ENDIF
     C                   MOVE      PLnRef        WLnRef
     C                   MOVE      PLnAmdVDat    WLnAmdVDat
     C                   MOVE      PLnAmdVDat    WLnAmdVDatA
     C                   MOVE      PLnAmdSeq     WLnAmdSeq
     C                   MOVE      PCusFees      WCusFees
     C                   MOVE      PFclFees      WFclFees
     C                   MOVE      PFeeSeq       WFeeSeq
     C                   EVAL      WSequence = WrkSequence
 
     C                   SELECT
     C                   WHEN      PMode = 'B' AND
     C                             WAction = 'I'
     C     KFLDS1        SETLL     LESTAL2
     C     KFLDS1        READE(N)  LESTAL2                                30
     C                   WHEN      WAction = 'A' AND
     C                             PNoDetails <> 'Y' OR
     C                             WAction = 'E' OR
     C                             WSAction = 'E' OR
     C                             WAction = 'D' OR
     C                             WSAction = 'D'
     C     KFLDS2        SETLL     LESTAL7
     C     KFLDS2        READE     LESTAL7
     C                   ENDSL
 
     C                   IF        WAction <> 'D' AND
     C                             WSAction <> 'D'
     C                   EXSR      SRTOEX
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCLRF - Clear File Extended Details                         *
      *                                                               *
      *****************************************************************
     C     SRCLRF        BEGSR
 
     C                   EVAL      RSTM = *ZEROS
     C                   EVAL      RONS = *BLANKS
     C**********         EVAL      ROBN = *ZEROS                                              CSD027
     C**********         EVAL      ROCN = *ZEROS                                              CSD027
     C                   EVAL      ROBN = *BLANKS                                             CSD027
     C                   EVAL      ROCN = *BLANKS                                             CSD027
     C                   EVAL      RIBN = *BLANKS
     C                   EVAL      RIBA = *BLANKS
     C                   EVAL      PSTM = *ZEROS
     C                   EVAL      PONS = *BLANKS
     C**********         EVAL      POBN = *ZEROS                                              CSD027
     C**********         EVAL      POCN = *ZEROS                                              CSD027
     C                   EVAL      POBN = *BLANKS                                             CSD027
     C                   EVAL      POCN = *BLANKS                                             CSD027
     C                   EVAL      PIBN = *BLANKS
     C                   EVAL      PIBA = *BLANKS
     C                   EVAL      RCRN = *BLANKS
     C                   EVAL      RCRA = *BLANKS
     C                   EVAL      RVNO = *BLANKS
     C                   EVAL      AWBN = *BLANKS
     C                   EVAL      AWBA = *BLANKS
     C                   EVAL      BENN = *BLANKS
     C                   EVAL      BENA = *BLANKS
     C                   EVAL      DTP1 = *BLANKS
     C                   EVAL      DTP2 = *BLANKS
     C                   EVAL      DTP3 = *BLANKS
     C                   EVAL      DTP4 = *BLANKS
     C                   EVAL      DCHG = *BLANKS
     C                   EVAL      BTB1 = *BLANKS
     C                   EVAL      BTB2 = *BLANKS
     C                   EVAL      BTB3 = *BLANKS
     C                   EVAL      BTB4 = *BLANKS
     C                   EVAL      BTB5 = *BLANKS
     C                   EVAL      BTB6 = *BLANKS
     C                   EVAL      CVMR = *BLANKS
     C                   EVAL      ROBR = *BLANKS
     C                   EVAL      POBR = *BLANKS
     C**********         EVAL      ROBN = *ZEROS                                              CSD027
     C**********         EVAL      ROCN = *ZEROS                                              CSD027
     C                   EVAL      ROBN = *BLANKS                                             CSD027
     C                   EVAL      ROCN = *BLANKS                                             CSD027
     C                   EVAL      RIBN = *BLANKS
     C**********         EVAL      POBN = *ZEROS                                              CSD027
     C**********         EVAL      POCN = *ZEROS                                              CSD027
     C                   EVAL      POBN = *BLANKS                                             CSD027
     C                   EVAL      POCN = *BLANKS                                             CSD027
     C                   EVAL      PIBN = *BLANKS
     C                   EVAL      RCRN = *BLANKS
     C                   EVAL      RVNO = *BLANKS
     C                   EVAL      AWBN = *BLANKS
     C                   EVAL      BENN = *BLANKS
     C                   EVAL      RSCY = *BLANKS
     C                   EVAL      PSCY = *BLANKS
     C                   EVAL      IC72 = *BLANKS
     C*                  EVAL      IERI = *BLANKS
     C                   IF        CLE031 = 'Y'
     C                   EVAL      REXR = *ZEROS
     C                   EVAL      REXI = *BLANKS
     C                   EVAL      PEXR = *ZEROS
     C                   EVAL      PEXI = *BLANKS
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTOEX - Move Details to SETLIAB subroutine                  *
      *                                                               *
      *****************************************************************
     C     SRTOEX        BEGSR
 
     C                   EVAL      WACTC = PMACTC
     C                   EVAL      WPRCV = PMPRCV
     C                   EVAL      WPPAY = PMPPAY
 
     C                   IF        WAction = 'E' OR
     C                             WSAction = 'E'
     C                   EVAL      PMACTC = 'E'
     C                   EVAL      PMPRCV = 'Y'
     C                   EVAL      PMPPAY = 'Y'
     C                   ELSE
     C                   EVAL      PMACTC = 'A'
     C                   IF        *IN60 = *OFF
     C                   EVAL      PMPRCV = 'N'
     C                   ENDIF
     C                   IF        *IN61 = *OFF
     C                   EVAL      PMPPAY = 'N'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        WAction <> 'E' AND
     C                             WSAction <> 'E'
 
     C                   IF        *IN60 = *OFF
     C                   MOVE      WArRMtd(WCntC)PMRSTM
     C                   EVAL      PMRONS = WArRAcc(WCntC)
     C                   EVAL      PMROBR = WArRBrc(WCntC)
     C                   EVAL      PMRSCY = WArRCcy(WCntC)
     C                   IF        PMode <> 'B'
     C                   EVAL      RCPC   = WArRPcg(WCntC)
     C                   EVAL      RCAM   = WArRAmt(WCntC)                                    CLE038
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        *IN61 = *OFF
     C                   MOVE      WArPMtd(WCntC)PMPSTM
     C                   EVAL      PMPONS = WArPAcc(WCntC)
     C                   EVAL      PMPOBR = WArPBrc(WCntC)
     C                   EVAL      PMPSCY = WArPCcy(WCntC)
     C                   IF        PMode <> 'B'
     C                   EVAL      PYPC   = WArPPcg(WCntC)
     C                   EVAL      PYAM   = WArPAmt(WCntC)                                    CLE038
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        WAction = 'E' OR
     C                             WSAction = 'E'
 
     C                   IF        *IN60 = *OFF
     C                   MOVE      RSTM          PMRSTM
     C                   IF        ROBR = *BLANKS
     C                   MOVE      RONS          PMRONS
     C                   ENDIF
     C                   EVAL      PMROBR = ROBR
     C                   EVAL      PMRSCY = RSCY
     C                   ENDIF
 
     C                   IF        *IN61 = *OFF
     C                   MOVE      PSTM          PMPSTM
     C                   IF        POBR = *BLANKS
     C                   MOVE      PONS          PMPONS
     C                   ENDIF
     C                   EVAL      PMPOBR = POBR
     C                   EVAL      PMPSCY = PSCY
     C                   ENDIF
 
     C                   ELSE
      *
     C************       IF        RCPC = *ZEROS                                              CLE038
     C                   IF        WArRByAmt = 'P' AND                                        CLE038
     C                             RCPC = *ZEROS                                              CLE038
     C                             OR WArRByAmt = 'A' AND                                     CLE038
     C                             RCAM = *ZEROS                                              CLE038
     C                   EVAL      PMPRCV = 'Y'
     C                   ENDIF
     C**********         IF        PYPC = *ZEROS                                              CLE038
     C                   IF        WArPByAmt = 'P' AND                                        CLE038
     C                             PYPC = *ZEROS                                              CLE038
     C                             OR WArPByAmt = 'A' AND                                     CLE038
     C                             PYAM = *ZEROS                                              CLE038
     C                   EVAL      PMPPAY = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        *IN60 = *OFF
     C**********         IF        ROBN <> *ZERO                                              CSD027
     C                   IF        ROBN <> *BLANKS                                            CSD027
     C                   MOVEL     ROBN          PAROBN
     C                   MOVEL     ROBN          PMROBN
     C                   ELSE
     C                   MOVEL     *BLANKS       PMROBN
     C                   MOVEL     *BLANKS       PAROBN
     C                   ENDIF
     C**********         IF        ROCN <> *ZERO                                              CSD027
     C                   IF        ROCN <> *BLANKS                                            CSD027
     C                   MOVEL     ROCN          PAROCN
     C                   MOVEL     ROCN          PMROCN
     C                   ELSE
     C                   MOVEL     *BLANKS       PMROCN
     C                   MOVEL     *BLANKS       PAROCN
     C                   ENDIF
     C                   EVAL      PARIBN = RIBN
     C                   EVAL      PMRIBN = RIBN
     C                   EVAL      PMRIBA = RIBA
     C                   ENDIF
 
     C                   IF        *IN61 = *OFF
     C**********         IF        POBN <> *ZERO                                              CSD027
     C                   IF        POBN <> *BLANKS                                            CSD027
     C                   MOVEL     POBN          PAPOBN
     C                   MOVEL     POBN          PMPOBN
     C                   ELSE
     C                   MOVEL     *BLANKS       PMPOBN
     C                   MOVEL     *BLANKS       PAPOBN
     C                   ENDIF
     C**********         IF        POCN <> *ZERO                                              CSD027
     C                   IF        POCN <> *BLANKS                                            CSD027
     C                   MOVEL     POCN          PAPOCN
     C                   MOVEL     POCN          PMPOCN
     C                   ELSE
     C                   MOVEL     *BLANKS       PMPOCN
     C                   MOVEL     *BLANKS       PAPOCN
     C                   ENDIF
     C                   EVAL      PAPIBN = PIBN
     C                   EVAL      PMPIBN = PIBN
     C                   EVAL      PMPIBA = PIBA
     C*************      ENDIF                                                                221859
 
     C                   EVAL      PARCRN = RCRN
     C                   EVAL      PMRCRA = RCRA
     C                   EVAL      PARVNO = RVNO
     C                   EVAL      PAAWBN = AWBN
     C                   EVAL      PMAWBA = AWBA
     C                   EVAL      PABENN = BENN
     C                   EVAL      PMBENA = BENA
     C                   EVAL      PMDTP1 = DTP1
     C                   EVAL      PMDTP2 = DTP2
     C                   EVAL      PMDTP3 = DTP3
     C                   EVAL      PMDTP4 = DTP4
     C                   EVAL      PMDCHG = DCHG
     C                   EVAL      PMBTB1 = BTB1
     C                   EVAL      PMBTB2 = BTB2
     C                   EVAL      PMBTB3 = BTB3
     C                   EVAL      PMBTB4 = BTB4
     C                   EVAL      PMBTB5 = BTB5
     C                   EVAL      PMBTB6 = BTB6
     C                   EVAL      PMCVMR = CVMR
     C                   EVAL      PMRCRN = RCRN
     C                   EVAL      PMRVNO = RVNO
     C                   EVAL      PMAWBN = AWBN
     C                   EVAL      PMBENN = BENN
     C                   EVAL      PMIC72 = IC72
     C                   ENDIF                                                                221859
 
     C                   IF        CLE031 = 'Y'
 
     C                   IF        *IN60 = *OFF OR
     C                             WAction = 'E' OR
     C                             WSAction = 'E'
     C                   IF        REXR <> *ZEROS
     C                   MOVE      *BLANKS       ZField
     C                   MOVE      REXR          ZField
     C                   Z-ADD     8             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZField        PMREXR
     C                   ELSE
     C                   EVAL      PMREXR = *BLANKS
     C                   ENDIF
     C                   EVAL      PMREXI = REXI
     C                   ENDIF
 
     C                   IF        *IN61 = *OFF OR
     C                             WAction = 'E' OR
     C                             WSAction = 'E'
     C                   IF        PEXR <> *ZEROS
     C                   MOVE      *BLANKS       ZField
     C                   MOVE      PEXR          ZField
     C                   Z-ADD     8             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZField        PMPEXR
     C                   ELSE
     C                   EVAL      PMPEXR = *BLANKS
     C                   ENDIF
     C                   EVAL      PMPEXI = PEXI
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFRFD - Move File Details to Detail Line subroutine         *
      *                                                               *
      *****************************************************************
     C     SRFRFD        BEGSR
 
     C                   IF        WAction = 'E' OR
     C                             WAction = 'D' OR
     C                             WAction = 'A' AND
     C                             *IN60 = *OFF
     C                   MOVE      RSTM          #1RMTD
     C                   IF        ROBR <> *BLANKS
     C                   IF        RSTM = '05' OR
     C                             RSTM = '09'
     C**********         EVAL      %SUBST(#1RACC:4:12) = RONS                                 CGL029
     C                   EVAL      %SUBST(#1RACC:4:18) = RONS                                 CGL029
     C                   ENDIF
     C                   ENDIF
     C**********         IF        ROBN <> *ZEROS                                             CSD027
     C                   IF        ROBN <> *BLANKS                                            CSD027
     C                   MOVEL     ROBN          #1ROBN
     C                   ENDIF
     C**********         IF        ROCN <> *ZEROS                                             CSD027
     C                   IF        ROCN <> *BLANKS                                            CSD027
     C                   MOVEL     ROCN          #1ROCN
     C                   ENDIF
     C                   EVAL      #1RIBN = RIBN
     C                   EVAL      #1RIBA = RIBA
     C                   EVAL      #1RCCY = RSCY
     C                   ENDIF
 
     C                   IF        WAction = 'E' OR
     C                             WAction = 'D' OR
     C                             WAction = 'A' AND
     C                             *IN61 = *OFF
     C                   MOVE      PSTM          #1PMTD
     C                   IF        POBR <> *BLANKS
     C                   IF        PSTM = '05' OR
     C                             PSTM = '09'
     C**********         EVAL      %SUBST(#1PACC:4:12) = PONS                                 CGL029
     C                   EVAL      %SUBST(#1PACC:4:18) = PONS                                 CGL029
     C                   ENDIF
     C                   ENDIF
     C**********         IF        POBN <> *ZEROS                                             CSD027
     C                   IF        POBN <> *BLANKS                                            CSD027
     C                   MOVEL     POBN          #1POBN
     C                   ENDIF
     C**********         IF        POCN <> *ZEROS                                             CSD027
     C                   IF        POCN <> *BLANKS                                            CSD027
     C                   MOVEL     POCN          #1POCN
     C                   ENDIF
     C                   EVAL      #1PIBN = PIBN
     C                   EVAL      #1PIBA = PIBA
     C                   EVAL      #1PCCY = PSCY
     C                   ENDIF
 
     C                   EVAL      #1RCRN = RCRN
     C                   EVAL      #1RCRA = RCRA
     C                   EVAL      #1RVNO = RVNO
     C                   EVAL      #1AWBN = AWBN
     C                   EVAL      #1AWBA = AWBA
     C                   EVAL      #1BENN = BENN
     C                   EVAL      #1BENA = BENA
     C                   EVAL      #1DTP1 = DTP1
     C                   EVAL      #1DTP2 = DTP2
     C                   EVAL      #1DTP3 = DTP3
     C                   EVAL      #1DTP4 = DTP4
     C                   EVAL      #1DCHG = DCHG
     C                   EVAL      #1BTB1 = BTB1
     C                   EVAL      #1BTB2 = BTB2
     C                   EVAL      #1BTB3 = BTB3
     C                   EVAL      #1BTB4 = BTB4
     C                   EVAL      #1BTB5 = BTB5
     C                   EVAL      #1BTB6 = BTB6
     C                   EVAL      #1CVMR = CVMR
     C                   EVAL      #1IC72 = IC72
     C*                  EVAL      #1IERI = IERI
     C                   IF        CLE031 = 'Y'
     C                   IF        WAction = 'E' OR
     C                             WAction = 'D' OR
     C                             WAction = 'A' AND
     C                             *IN60 = *OFF
     C                   IF        REXR <> *ZEROS
     C                   MOVE      *BLANKS       ZField
     C                   MOVE      REXR          ZField
     C                   Z-ADD     8             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZField        #1REXR
     C                   ELSE
     C                   EVAL      #1REXR = *BLANKS
     C                   ENDIF
     C                   EVAL      #1REXI = REXI
     C                   ENDIF
     C                   IF        WAction = 'E' OR
     C                             WAction = 'D' OR
     C                             WAction = 'A' AND
     C                             *IN61 = *OFF
     C                   IF        PEXR <> *ZEROS
     C                   MOVE      *BLANKS       ZField
     C                   MOVE      PEXR          ZField
     C                   Z-ADD     8             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZField        #1PEXR
     C                   ELSE
     C                   EVAL      #1PEXR = *BLANKS
     C                   ENDIF
     C                   EVAL      #1PEXI = PEXI
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFRXD - Move Extended Details to Detail Line subroutine     *
      *                                                               *
      *****************************************************************
     C     SRFRXD        BEGSR
 
     C                   IF        *IN60 = *OFF
     C                   MOVEL     PMRSTM        #0RMTD
     C                   IF        PMROBR <> *BLANKS AND
     C                             #0RMTD = '05'
     C                   EVAL      %SUBST(#0RACC:1:3) = PMROBR
     C**********         EVAL      %SUBST(#0RACC:4:12) = PMRONS                               CGL029
     C                   EVAL      %SUBST(#0RACC:4:18) = PMRONS                               CGL029
     C                   ELSE
     C                   EVAL      #0RACC = PMRONS
     C                   ENDIF
     C                   IF        PAROBN <> *BLANKS
     C                   MOVEL     PAROBN        #0ROBN
     C                   ENDIF
     C                   IF        PAROCN <> *BLANKS
     C                   MOVEL     PAROCN        #0ROCN
     C                   ENDIF
     C                   EVAL      #0RIBN = PARIBN
     C                   EVAL      #0RIBA = PMRIBA
     C                   EVAL      #0RCCY = PMRSCY
     C                   ENDIF
 
     C                   IF        *IN61 = *OFF
     C                   MOVEL     PMPSTM        #0PMTD
     C                   IF        PMPOBR <> *BLANKS AND
     C                             #0RMTD = '05'
     C                   EVAL      %SUBST(#0PACC:1:3) = PMPOBR
     C**********         EVAL      %SUBST(#0PACC:4:12) = PMPONS                               CGL029
     C                   EVAL      %SUBST(#0PACC:4:18) = PMPONS                               CGL029
     C                   ELSE
     C                   EVAL      #0PACC = PMPONS
     C                   ENDIF
     C                   IF        PAPOBN <> *BLANKS
     C                   MOVEL     PAPOBN        #0POBN
     C                   ENDIF
     C                   IF        PAPOCN <> *BLANKS
     C                   MOVEL     PAPOCN        #0POCN
     C                   ENDIF
     C                   EVAL      #0PIBN = PAPIBN
     C                   EVAL      #0PIBA = PMPIBA
     C                   EVAL      #0PCCY = PMPSCY
     C                   ENDIF
 
     C                   EVAL      #0RCRN = PARCRN
     C                   EVAL      #0RCRA = PMRCRA
     C                   EVAL      #0RVNO = PARVNO
     C                   EVAL      #0AWBN = PAAWBN
     C                   EVAL      #0AWBA = PMAWBA
     C                   EVAL      #0BENN = PABENN
     C                   EVAL      #0BENA = PMBENA
     C                   EVAL      #0DTP1 = PMDTP1
     C                   EVAL      #0DTP2 = PMDTP2
     C                   EVAL      #0DTP3 = PMDTP3
     C                   EVAL      #0DTP4 = PMDTP4
     C                   EVAL      #0DCHG = PMDCHG
     C                   EVAL      #0BTB1 = PMBTB1
     C                   EVAL      #0BTB2 = PMBTB2
     C                   EVAL      #0BTB3 = PMBTB3
     C                   EVAL      #0BTB4 = PMBTB4
     C                   EVAL      #0BTB5 = PMBTB5
     C                   EVAL      #0BTB6 = PMBTB6
     C                   EVAL      #0CVMR = PMCVMR
     C                   EVAL      #0IC72 = PMIC72
     C*                  EVAL      #0IERI = PMIERI
     C                   IF        CLE031 = 'Y'
     C                   IF        *IN60 = *OFF
     C                   EVAL      #0REXR = PMREXR
     C                   EVAL      #0REXI = PMREXI
     C                   ENDIF
     C                   IF        *IN61 = *OFF
     C                   EVAL      #0PEXR = PMPEXR
     C                   EVAL      #0PEXI = PMPEXI
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFRXF - Move Extended Details to File Subroutine            *
      *                                                               *
      *****************************************************************
     C     SRFRXF        BEGSR
 
     C                   IF        *IN60 = *OFF
     C                   MOVE      PMRSTM        RSTM
     C                   MOVE      PMROBR        ROBR
     C                   EVAL      RONS = PMRONS
     C                   IF        PAROBN <> *BLANKS
     C                   MOVEL     PAROBN        ROBN
     C                   ENDIF
     C                   IF        PAROCN <> *BLANKS
     C                   MOVEL     PAROCN        ROCN
     C                   ENDIF
     C                   EVAL      RIBN = PARIBN
     C                   EVAL      RIBA = PMRIBA
     C                   EVAL      RSCY = PMRSCY
     C                   ENDIF
 
     C                   IF        *IN61 = *OFF
     C                   MOVE      PMPSTM        PSTM
     C                   MOVE      PMPOBR        POBR
     C                   EVAL      PONS = PMPONS
     C                   IF        PAPOBN <> *BLANKS
     C                   MOVEL     PAPOBN        POBN
     C                   ENDIF
     C                   IF        PAPOCN <> *BLANKS
     C                   MOVEL     PAPOCN        POCN
     C                   ENDIF
     C                   EVAL      PIBN = PAPIBN
     C                   EVAL      PIBA = PMPIBA
     C                   EVAL      PSCY = PMPSCY
     C                   ENDIF
 
     C                   EVAL      RCRN = PARCRN
     C                   EVAL      RCRA = PMRCRA
     C                   EVAL      RVNO = PARVNO
     C                   EVAL      AWBN = PAAWBN
     C                   EVAL      AWBA = PMAWBA
     C                   EVAL      BENN = PABENN
     C                   EVAL      BENA = PMBENA
     C                   EVAL      DTP1 = PMDTP1
     C                   EVAL      DTP2 = PMDTP2
     C                   EVAL      DTP3 = PMDTP3
     C                   EVAL      DTP4 = PMDTP4
     C                   EVAL      DCHG = PMDCHG
     C                   EVAL      BTB1 = PMBTB1
     C                   EVAL      BTB2 = PMBTB2
     C                   EVAL      BTB3 = PMBTB3
     C                   EVAL      BTB4 = PMBTB4
     C                   EVAL      BTB5 = PMBTB5
     C                   EVAL      BTB6 = PMBTB6
     C                   EVAL      CVMR = PMCVMR
     C                   EVAL      IC72 = PMIC72
 
     C                   IF        CLE031 = 'Y'
     C                   IF        *IN60 = *OFF
     C                   MOVE      *BLANKS       ZFLD17
     C                   MOVE      PMREXR        ZFLD17
     C                   Z-ADD     8             ZADEC
     C                   Z-ADD     5             ZADIG
     C                   EXSR      ZASIGN
     C                   MOVE      ZOUT15        REXR
     C                   EVAL      REXI = PMREXI
     C                   ENDIF
     C                   IF        *IN61 = *OFF
     C                   MOVE      *BLANKS       ZFLD17
     C                   MOVE      PMPEXR        ZFLD17
     C                   Z-ADD     8             ZADEC
     C                   Z-ADD     5             ZADIG
     C                   EXSR      ZASIGN
     C                   MOVE      ZOUT15        PEXR
     C                   EVAL      PEXI = PMPEXI
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFILE - Setup file Details for Update                       *
      *                                                               *
      *****************************************************************
     C     SRFILE        BEGSR
 
     C                   EVAL      RECI = 'D'
     C                   EVAL      TYPE = PType
     C                   IF        PType = 'PTSO'                                             CLE038
     C                   EVAL      TYPE = 'LOAN'                                              CLE038
     C                   ENDIF                                                                CLE038
     C                   MOVE      PLnRef        LNRF
     C                   MOVE      PLnAmdVDat    VDAT
     C                   MOVE      PLnAmdSeq     LASQ
     C                   MOVE      PCusFees      CNUM
     C                   MOVE      PFclFees      FACL
     C                   MOVE      PFeeSeq       FESQ
     C                   EVAL      RCPC = WArRPcg(WcR)
     C                   EVAL      PYPC = WArPPcg(WcR)
     C                   EVAL      RCAM = WArRAmt(WcR)                                        CLE038
     C                   EVAL      PYAM = WArPAmt(WcR)                                        CLE038
     C                   EVAL      RCBA = WArRByAmt                                           CLE038
     C                   EVAL      PYBA = WArPByAmt                                           CLE038
     C                   EVAL      CCY  = PMRCCY                                              CLE038
 
     C                   IF        PMode <> 'B'
     C                   IF        WAction = 'I' OR
     C                             WF9 = 'Y' OR
     C                             PNoDetails = 'Y'
     C******LOCK         IN        LEALLO                                                     CLE148
     C**********         EVAL      PCNEXT = PCLAST + 1                                        CLE148
     C                   CALL      'LEALLO'                                                   CLE148
     C                   PARM      *BLANKS       PRTCD                                        CLE148
     C                   PARM      'Y'           PUPDT                                        CLE148
     C                   PARM      *BLANKS       PCLAST                                       CLE148
     C                   PARM      *BLANKS       PCNEXT                                       CLE148
     C                   MOVE      PCNEXT        PCNEXTA
     C                   EVAL      %SUBST(PCRF:1:3) = %SUBST(A8MQSM:1:3)
     C                   EVAL      %SUBST(PCRF:4:8) = PCNEXTA
     C                   EVAL      %SUBST(PCRF:12:4) = '0001'
     C**********         EVAL      PCLAST = PCNEXT                                            CLE148
     C**********         OUT       LEALLO                                                     CLE148
     C                   ENDIF
 
     C                   EVAL      PTRF = ParentPCRef
     C                   ENDIF
 
     C                   EXSR      SRCLRF
     C                   EXSR      SRFRXF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDB - Database Process subroutine                           *
      *                                                               *
      *****************************************************************
     C     SRDB          BEGSR
 
     C                   SELECT
 
     C                   WHEN      WAction = 'I' OR
     C                             WF9 = 'Y' OR
     C                             PNoDetails = 'Y'
     C                   EXSR      SRINS
 
     C                   WHEN      WAction = 'A' AND
     C                             WSAction <> 'D' OR
     C                             WAction = 'U'
     C                   EXSR      SRAMD
     C                   IF        PMode = 'B'
     C                   EVAL      WFormat = 'END'
     C                   ELSE
     C                   EVAL      WFormat = 'SUB'
     C                   ENDIF
 
     C                   WHEN      WAction = 'A' AND
     C                             WSAction = 'D' OR
     C                             WAction = 'D'
 
     C                   EVAL      WCntC = 1
 
     C                   EVAL      WrkSequence = WArSEQN1(WCntC)
     C                   DOW       WrkSequence <> *ZERO
     C                   EXSR      SRSETF
     C                   EXSR      SRAMD
     C                   EVAL      WCntC = WCntC + 1
     C                   EVAL      WrkSequence = WArSEQN1(WCntC)
     C                   ENDDO
 
     C                   IF        PMode = 'B'
     C                   EVAL      WFormat = 'END'
     C                   ELSE
     C                   IF        WAction = 'D'
     C                   EVAL      PMCMDP = '12'
     C                   EVAL      PMSDTV = 'Y'
     C                   EVAL      WFormat = 'END'
     C                   ELSE
     C                   EVAL      WFormat = 'SUB'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAMD - Database Amend subroutine                            *
      *                                                               *
      *****************************************************************
     C     SRAMD         BEGSR
 
     C                   IF        WSAction = 'A' OR
     C                             WSAction = 'U'
 
     C                   EVAL      PSetlAmd = 'Y'
 
     C                   MOVE      PLnRef        LNRF
     C                   MOVE      PLnAmdVDat    VDAT
     C                   MOVE      PLnAmdSeq     LASQ
     C                   MOVE      PCusFees      CNUM
     C                   MOVE      PFclFees      FACL
     C                   MOVE      PFeeSeq       FESQ
 
     C                   IF        *IN60 = *OFF
     C                   Z-ADD     WArRPcg(WCntC)RCPC
     C                   Z-ADD     WArRAmt(WCntC)RCAM                                         CLE038
     C                   MOVEL     WArRByAmt     RCBA                                         CLE038
     C                   ENDIF
 
     C                   IF        *IN61 = *OFF
     C                   Z-ADD     WArPPcg(WCntC)PYPC
     C                   Z-ADD     WArPAmt(WCntC)PYAM                                         CLE038
     C                   MOVEL     WArPByAmt     PYBA                                         CLE038
     C                   ENDIF
     C                   EVAL      CCY  = PMRCCY                                              CLE038
 
     C                   EXSR      SRCLRF
     C                   EXSR      SRFRXF
 
     C                   ENDIF
 
     C                   IF        WAction = 'D' OR
     C                             WSAction = 'D'
     C                   EVAL      RECI = 'R'
     C                   ENDIF
 
     C                   UPDATE    LESTAL7
 
     C                   IN        SDSTAT
     C                   IN        SC24X7
 
     C                   IF        PMode <> 'B'
     C                   IF        CSC011 = 'Y' AND
     C                             S1SUPP = 'LIBR'
     C                   EXSR      LOG247
     C                   EVAL      WLogValid = 'V'
     C                   EXSR      APLGTR
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        PMode = 'F'
     C                   EVAL      WSequence = XREPN
     C     KFLDS3        SETLL     LEISTL1
     C     KFLDS3        READE     LEISTL1
     C                   IF        %FOUND(LEISTLL1)
     C                   DELETE    LEISTL1
     C                   ENDIF
     C                   IF        CSC011 = 'Y' AND
     C                             S1SUPP = 'LIBR'
     C                   EXSR      LOGDEL
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINS - Database Insert subroutine                           *
      *                                                               *
      *****************************************************************
     C     SRINS         BEGSR
 
     C                   EVAL      WType = PType
     C                   IF        PType = 'PTSO'                                             CLE038
     C                   EVAL      WType = 'LOAN'                                             CLE038
     C                   ENDIF                                                                CLE038
     C                   IF        PTimeStamp <> *BLANKS
     C                   MOVE      PTimeStamp    WTimeStamp
     C                   ENDIF
     C                   MOVE      PLnRef        WLnRef
     C                   MOVE      PLnAmdVDat    WLnAmdVDat
     C                   MOVE      PLnAmdVDat    WLnAmdVDatA
     C                   MOVE      PLnAmdSeq     WLnAmdSeq
     C                   MOVE      PCusFees      WCusFees
     C                   MOVE      PFclFees      WFclFees
     C                   MOVE      PFeeSeq       WFeeSeq
     C                   EVAL      WSequence = WrkSequence
 
     C                   IF        PMODE <> 'B'
     C*****KFLDS1        SETGT     LESTALX                                                    227714
     C*****KFLDS1        READPE    LESTALX                                30                  227714
     C     KFLDS6        SETGT     LESTALX                                                    227714
     C     KFLDS6        READPE    LESTALX                                30                  227714
 
     C                   IF        *IN30 = *OFF
     C                   EVAL      SEQ = SEQ + 1
     C                   EVAL      TMST = TMST
     C                   ELSE
     C                   EVAL      SEQ = 1
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TMST
     C                   MOVE      TMST          PTimeStamp
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      WrkSequence = SEQ
 
     C                   IF        PMode <> 'B'
     C                   IF        WAction = 'I' OR
     C                             WF9 = 'Y' OR
     C                             PNoDetails = 'Y'
     C                   EVAL      PBranch = PMBRCA
     C                   EXSR      SRAOBRCH
     C                   ENDIF
     C                   ENDIF
 
     C                   EXSR      SRFILE
 
     C                   IF        PMode <> 'B'
     C                   WRITE     LESTAL7
     C                   ENDIF
 
     C                   IF        PMode <> 'B'
 
     C                   IN        SDSTAT
     C                   IN        SC24X7
 
     C                   IF        CSC011 = 'Y' AND
     C                             S1SUPP = LIBR
     C                   EXSR      LOG247
     C                   EVAL      WLogValid = 'V'
     C                   EXSR      APLGTR
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        PMode = 'F'
     C                   EVAL      WSequence = XREPN
     C     KFLDS3        SETLL     LEISTL1
     C     KFLDS3        READE     LEISTL1
     C                   IF        %FOUND(LEISTLL1)
     C                   DELETE    LEISTL1
     C                   ENDIF
     C                   IF        CSC011 = 'Y' AND
     C                             S1SUPP = LIBR
     C                   EXSR      LOGDEL
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREND - Setup Return Fields                                  *
      *                                                               *
      *****************************************************************
     C     SREND         BEGSR
 
     C                   EVAL      PErrors = WError
 
      ** Receive Settlement Currency and Location
 
     C                   IF        *IN60 = *OFF
 
     C                   EVAL      WcI = 1
     C                   EVAL      WcO = 0
 
     C                   DOW       WcI <= WRMax and PMode <> 'B'
     C                             OR WcI <= @X and PMode = 'B'                               197145
     C     WArRICL(WcI)  LOOKUP    WArROCL                                22
     C                   IF        *IN22 = *OFF
     C                   EVAL      WcO = WcO + 1
     C                   MOVE      WArRICL(WcI)  WArROCL(WcO)
     C                   MOVE      WArROCL(WcO)  WRCcyLoc
     C                   EVAL      WArRCcyP(WcO) = %SUBST(WRCcyLoc:1:3)
     C                   EVAL      WArRLocP(WcO) = %SUBST(WRCcyLoc:4:3)
     C                   ENDIF
     C                   EVAL      WcI = WcI + 1
     C                   ENDDO
 
     C                   MOVEA     WArRCcyP      PRcvSetlCcy
     C                   MOVEA     WArRLocP      PRcvSetlLoc
 
     C                   ENDIF
 
      ** Pay Settlement Currency and Location
 
     C                   IF        *IN61 = *OFF
 
     C                   EVAL      WcI = 1
     C                   EVAL      WcO = 0
 
     C                   DOW       WcI <= WRMax and PMode <> 'B'
     C                             OR WcI <= @X and PMode = 'B'                               197145
     C     WArPICL(WcI)  LOOKUP    WArPOCL                                22
     C                   IF        *IN22 = *OFF
     C                   EVAL      WcO = WcO + 1
     C                   MOVE      WArPICL(WcI)  WArPOCL(WcO)
     C                   MOVE      WArPOCL(WcO)  WPCcyLoc
     C                   EVAL      WArPCcyP(WcO) = %SUBST(WPCcyLoc:1:3)
     C                   EVAL      WArPLocP(WcO) = %SUBST(WPCcyLoc:4:3)
     C                   ENDIF
     C                   EVAL      WcI = WcI + 1
     C                   ENDDO
 
     C                   MOVEA     WArPCcyP      PPaySetlCcy
     C                   MOVEA     WArPLocP      PPaySetlLoc
 
     C                   ENDIF
 
      ** Revalidate Pay/Receive Percentage
 
     C                   IF        PMCMDP = '12' AND
     C                             WAction <> 'E' AND
     C                             WAction <> 'D'
 
     C                   EVAL      WTotRcv = 0
     C                   EVAL      WTotPay = 0
     C                   EVAL      WTotRcvAmt = 0                                             CLE038
     C                   EVAL      WTotPayAmt = 0                                             CLE038
     C                   EVAL      WCntC = 0
     C                   EVAL      WType = PType
     C                   IF        PType = 'PTSO'                                             CLE038
     C                   EVAL      WType = 'LOAN'                                             CLE038
     C                   ENDIF                                                                CLE038
     C                   IF        PTimeStamp <> *BLANKS
     C                   MOVE      PTimeStamp    WTimeStamp
     C                   ENDIF
 
     C     KFLDS7        SETLL     LESTAL1
     C     KFLDS7        READE(N)  LESTAL1                                50
 
     C                   DOW       *IN50 = *OFF
     C                   EVAL      WCntC = WCntc + 1
     C                   EVAL      WTotRcv = WTotRcv + RCPC
     C                   EVAL      WTotPay = WTotPay + PYPC
      *                                                                                       CLE038
     C     CLE038        IFEQ      'Y'                                                        CLE038
      *                                                                                       CLE038
     C     RSCY          IFEQ      PMRCCY                                                     CLE038
     C     RSCY          OREQ      *BLANKS                                                    CLE038
     C     RSTM          OREQ      '09'                                                       CLE038
     C     WSetl09Ccy    ANDEQ     'T'                                                        CLE038
     C                   EVAL      WTotRcvAmt = WTotRcvAmt + RCAM                             CLE038
     C                   ELSE                                                                 CLE038
     C                   EVAL      PCurr = RSCY                                               CLE038
     C                   EXSR      SRAOCURR                                                   CLE038
     C     REXR          IFEQ      0                                                          CLE038
     C                   Z-ADD     A6SPRT        ZRATE1                                       CLE038
     C                   MOVE      A6MDIN        ZMDI1                                        CLE038
     C                   Z-ADD     WRecSpot      ZRATE2                                       CLE038
     C                   MOVE      WRecMDI       ZMDI2                                        CLE038
     C                   EXSR      ZXRATE                                                     CLE038
     C                   Z-ADD     ZRATEX        ZEXCH                                        CLE038
     C                   MOVE      ZMDIX         ZMD                                          CLE038
     C                   ELSE                                                                 CLE038
     C                   Z-ADD     REXR          ZEXCH                                        CLE038
     C     REXI          IFEQ      'M'                                                        CLE038
     C                   MOVEL     'D'           ZMD                                          CLE038
     C                   ELSE                                                                 CLE038
     C                   MOVEL     'M'           ZMD                                          CLE038
     C                   ENDIF                                                                CLE038
     C                   ENDIF                                                                CLE038
      *                                                                                       CLE038
     C                   MOVE      RSCY          ZCCYI                                        CLE038
     C                   MOVE      PMRCCY        ZCCYO                                        CLE038
     C                   MOVE      A6NBDP        ZCDPI                                        CLE038
     C                   MOVE      WRecDP        ZCDPO                                        CLE038
     C                   Z-ADD     RCAM          ZAMTCI                                       CLE038
     C                   EXSR      ZCONV                                                      CLE038
     C                   EVAL      WTotRcvAmt = WTotRcvAmt + ZAMTCO                           CLE038
     C                   ENDIF                                                                CLE038
      *                                                                                       CLE038
     C     PSCY          IFEQ      PMPCCY                                                     CLE038
     C     PSCY          OREQ      *BLANKS                                                    CLE038
     C     PSTM          OREQ      '09'                                                       CLE038
     C     WSetl09Ccy    ANDEQ     'T'                                                        CLE038
     C                   EVAL      WTotPayAmt = WTotPayAmt + PYAM                             CLE038
     C                   ELSE                                                                 CLE038
     C                   EVAL      PCurr = PSCY                                               CLE038
     C                   EXSR      SRAOCURR                                                   CLE038
     C     PEXR          IFEQ      0                                                          CLE038
     C                   Z-ADD     A6SPRT        ZRATE1                                       CLE038
     C                   MOVE      A6MDIN        ZMDI1                                        CLE038
     C                   Z-ADD     WPaySpot      ZRATE2                                       CLE038
     C                   MOVE      WPayMDI       ZMDI2                                        CLE038
     C                   EXSR      ZXRATE                                                     CLE038
     C                   Z-ADD     ZRATEX        ZEXCH                                        CLE038
     C                   MOVE      ZMDIX         ZMD                                          CLE038
     C                   ELSE                                                                 CLE038
     C                   Z-ADD     PEXR          ZEXCH                                        CLE038
     C     PEXI          IFEQ      'M'                                                        CLE038
     C                   MOVEL     'D'           ZMD                                          CLE038
     C                   ELSE                                                                 CLE038
     C                   MOVEL     'M'           ZMD                                          CLE038
     C                   ENDIF                                                                CLE038
     C                   ENDIF                                                                CLE038
      *                                                                                       CLE038
     C                   MOVE      PSCY          ZCCYI                                        CLE038
     C                   MOVE      PMPCCY        ZCCYO                                        CLE038
     C                   MOVE      A6NBDP        ZCDPI                                        CLE038
     C                   MOVE      WPayDP        ZCDPO                                        CLE038
     C                   Z-ADD     PYAM          ZAMTCI                                       CLE038
     C                   EXSR      ZCONV                                                      CLE038
     C                   EVAL      WTotPayAmt = WTotPayAmt + ZAMTCO                           CLE038
     C                   ENDIF                                                                CLE038
     C                   ENDIF                                                                CLE038
      *                                                                                       CLE038
     C     KFLDS7        READE     LESTAL1                                50
     C                   ENDDO
 
     C                   IF        WCntC = *ZERO
     C                   EVAL      PMSDTV = 'N'
     C                   EVAL      PMERCD = *BLANKS
     C                   ELSE
     C***********        IF        WTotRcv <> 100 AND                                         CLE038
     C***********                  *IN60 = *OFF OR                                            CLE038
     C***********                  WTotPay <> 100 AND                                         CLE038
     C***********                  *IN61 = *OFF                                               CLE038
     C                   SELECT                                                               CLE038
     C                   WHEN      RCBA = 'A'  AND                                            CLE038
     C                             WTotRcvAmt <> PAllcAmt AND                                 CLE038
     C                             *IN60 = *OFF                                               CLE038
     C                   EVAL      PMSDTV = 'N'                                               CLE038
     C                   EVAL      PMERCD = '830'                                             CLE038
     C                   EVAL      ZAMSID = 'ESM0830'                                         CLE038
     C                   EXSR      ZASNMS                                                     CLE038
     C                   WHEN      RCBA <> 'A'  AND                                           CLE038
     C                             WTotRcv <> 100 AND                                         CLE038
     C                             *IN60 = *OFF                                               CLE038
     C                   EVAL      PMSDTV = 'N'                                               CLE038
     C                   EVAL      PMERCD = '822'                                             CLE038
     C                   EVAL      ZAMSID = 'ESM0822'                                         CLE038
     C                   EXSR      ZASNMS                                                     CLE038
     C                   WHEN      PYBA = 'A'  AND                                            CLE038
     C                             WTotPayAmt <> PAllcAmt AND                                 CLE038
     C                             *IN61 = *OFF                                               CLE038
     C                   EVAL      PMSDTV = 'N'                                               CLE038
     C                   EVAL      PMERCD = '831'                                             CLE038
     C                   EVAL      ZAMSID = 'ESM0831'                                         CLE038
     C                   EXSR      ZASNMS                                                     CLE038
     C                   WHEN      PYBA <> 'A' AND                                            CLE038
     C                             WTotPay <> 100 AND                                         CLE038
     C                             *IN61 = *OFF                                               CLE038
     C                   EVAL      PMSDTV = 'N'
     C                   EVAL      PMSDTV = 'N'
     C**********         EVAL      PMERCD = '*ERROR'                                          CLE038
     C                   EVAL      PMERCD = '823'                                             CLE038
     C                   EVAL      ZAMSID = 'ESM0823'                                         CLE038
     C                   EXSR      ZASNMS                                                     CLE038
     C**********         ELSE                                                                 CLE038
     C                   OTHER                                                                CLE038
     C                   EVAL      PMSDTV = 'Y'
     C                   EVAL      PMERCD = *BLANKS
     C**********         ENDIF                                                                CLE038
     C                   ENDSL                                                                CLE038
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      PMACTC = XACTC
     C                   EVAL      PMPRCV = XPRCV
     C                   EVAL      PMPPAY = XPPAY
 
     C                   IF        PMode <> 'B'
     C                   CLOSE     LE2230DF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  LOGDEL - Delete record from 24x7 Midas Availability Log      *
      *                                                               *
      *****************************************************************
     C     LOGDEL        BEGSR
 
     C                   EVAL      WMsgType = 'LE' + 'STAL'
     C                   EVAL      WFrOffId = PCRF
     C                   EVAL      WTimeStamp = TMST
 
     C                   OPEN      APILOGL0
 
     C     KFLDS4        CHAIN     APILOG0
 
     C                   IF        %FOUND(APILOGL0)
     C                   DELETE    APILOG0
     C                   ENDIF
 
     C                   CLOSE     APILOGL0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  LOG247 - Convert fields to the 24x7 Midas Availability Log   *
      *                                                               *
      *****************************************************************
     C     LOG247        BEGSR
      *
     C*                  IF        PMode <> 'B'
      *
     C*                  CLEAR                   PINPP
     C*                  EVAL      SA1MST = 'STAL'
     C*                  EVAL      SA1TUS = PSUser
     C*                  EVAL      SA1TWS = PSJobName
     C*                  EVAL      SA1TRF = PLnRef
     C*                  EVAL      SA1TSN = SEQ
     C*                  EVAL      SA1ACT = WAction
     C*                  CALLB     'ZAGENTMSTM'
     C*                  PARM                    WTMST
     C*                  EVAL      %SUBST(SA1TDS:1:2) = %SUBST(WTMST:9:2)
     C*                  EVAL      %SUBST(SA1TDS:3:2) = %SUBST(WTMST:6:2)
     C*                  EVAL      %SUBST(SA1TDS:5:4) = %SUBST(WTMST:1:4)
     C*                  EVAL      %SUBST(SA1TTS:1:2) = %SUBST(WTMST:12:2)
     C*                  EVAL      %SUBST(SA1TTS:3:2) = %SUBST(WTMST:15:2)
     C*                  EVAL      %SUBST(SA1TTS:5:2) = %SUBST(WTMST:18:2)
     C*                  EVAL      %SUBST(SA1TTS:7:2) = %SUBST(WTMST:21:2)
     C*                  EVAL      SA1NRB
     C*                  EVAL      SA1RLC
     C*                  EVAL      SA1FL3 = *BLANKS
     C*                  EVAL      SA1TYP = PType
     C*                  IF        PTimeStamp <> *BLANKS
     C*                  EVAL      SA1TMS = PTimeStamp
     C*                  ENDIF
     C*                  EVAL      SA1PCR = PCRF
     C*                  MOVE      PLnRef        SA1LNR
     C*                  IF        PLnAmdVDat <> *BLANKS
     C*                  MOVE      PLnAmdVDat    ZDateIn
     C*                  CALLB     'ZDATE9'
     C*                  PARM                    ZDateIn
     C*                  PARM                    ZDateOut
     C*                  PARM                    ZRTN
     C*                  MOVE      ZDateOut      SA1VDT
     C*                  ELSE
     C*                  EVAL      SA1VDT = *BLANKS
     C*                  ENDIF
     C*                  IF        PLnAmdSeq <> *BLANKS
     C*                  MOVE      PLnAmdSeq     SA1LAS
     C*                  ELSE
     C*                  EVAL      SA1VDT = *ZERO
     C*                  ENDIF
     C*                  IF        PCusFees <> *BLANKS
     C*                  MOVE      PCusFees      SA1CNM
     C*                  ELSE
     C*                  EVAL      SA1VDT = *ZERO
     C*                  ENDIF
     C*                  IF        PFclFees <> *BLANKS
     C*                  MOVE      PFclFees      SA1FAC
     C*                  ELSE
     C*                  EVAL      SA1VDT = *ZERO
     C*                  ENDIF
     C*                  IF        PFeeSeq <> *BLANKS
     C*                  MOVE      PFeeSeq       SA1FSQ
     C*                  ELSE
     C*                  EVAL      SA1VDT = *ZERO
     C*                  ENDIF
     C*                  EVAL      SA1SEQ = SEQ
     C*                  MOVE      RCPC          SA1RPC
     C*                  EVAL      SA1RSM = PMRSTM
     C*                  EVAL      %SUBST(SA1RNS:1:3) = PMROBR
     C*                  EVAL      %SUBST(SA1RNS:4:12) = PMRONS
     C*                  EVAL      SA1RIB = PARIBN
     C*                  EVAL      SA1RBA = PMRIBA
     C*                  EVAL      SA1ROB = PAROBN
     C*                  EVAL      SA1ROC = PAROCN
     C*                  EVAL      SA1RSC = PMRCCY
     C*                  EVAL      SA1RXR = PMREXR
     C*                  EVAL      SA1RXI = PMREXI
     C*                  MOVE      PYPC          SA1PPC
     C*                  EVAL      %SUBST(SA1PSM:1:3) = PMPOBR
     C*                  EVAL      %SUBST(SA1PSM:4:12) = PMPONS
     C*                  EVAL      SA1PNS = PMPO
     C*                  EVAL      SA1PIB = PAPIBN
     C*                  EVAL      SA1PBA = PMPIBA
     C*                  MOVE      PAPOBN        SA1POB
     C*                  MOVE      PAPOCN        SA1POC
     C*                  EVAL      SA1RCR = PARCRN
     C*                  EVAL      SA1RCA = PMRCRA
     C*                  EVAL      SA1RVN = PARVNO
     C*                  EVAL      SA1AWB = PAAWBN
     C*                  EVAL      SA1ABA = PMAWBA
     C*                  EVAL      SA1BEN = PABENN
     C*                  EVAL      SA1BNA = PMBENA
     C*                  EVAL      SA1DP1 = PMDTP1
     C*                  EVAL      SA1DP2 = PMDTP2
     C*                  EVAL      SA1DP3 = PMDTP3
     C*                  EVAL      SA1DP4 = PMDTP4
     C*                  EVAL      SA1DCH = PMDCHG
     C*                  EVAL      SA1BB1 = PMBTB1
     C*                  EVAL      SA1BB2 = PMBTB2
     C*                  EVAL      SA1BB3 = PMBTB3
     C*                  EVAL      SA1BB4 = PMBTB4
     C*                  EVAL      SA1BB5 = PMBTB5
     C*                  EVAL      SA1BB6 = PMBTB6
     C*                  EVAL      SA1CMR = PMCVMR
     C*                  EVAL      SA1PSC = PMPSCY
     C*                  EVAL      SA1C72 = PMIC72
     C*                  EVAL      SA1PXR = PMPEXR
     C*                  EVAL      SA1PXI = PMPEXI
     C*                  EVAL      SA1PTF = ParentPCRef
      *
     C*                  ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  APLGTR - Write Transaction to 24x7 Midas Availability Log    *
      *                                                               *
      *****************************************************************
     C     APLGTR        BEGSR
 
     C                   EVAL      APTRAN = 'STAL'
     C                   EVAL      APSTMS = TMST
     C                   EVAL      APMTYP = 'LE' + 'STAL'
     C                   EVAL      APSOFC = PCRF
 
     C                   IF        WLogValid = 'V'
     C                   OPEN      APVLOGPD
     C                   WRITE     APVLOGD0
     C                   CLOSE     APVLOGPD
     C                   ENDIF
 
     C                   IF        WLogValid = 'I'
     C                   OPEN      APILOGPD
     C                   WRITE     APILOGD0
     C                   CLOSE     APILOGPD
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCLRM - Clear message queue                                 *
      *                                                               *
      *****************************************************************
     C     SRCLRM        BEGSR
 
     C                   CALL      'Y2CLMSC'
     C                   PARM                    ZAPGMQ
     C                   PARM      '*SAME'       ZAPGRL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZASNMS - Send messages to the program's message queue        *
      *                                                               *
      *****************************************************************
     C     ZASNMS        BEGSR
 
     C                   IF        PMode = 'B' OR
     C                             PMode = 'P'
 
     C                   EXSR      SRBERR
 
     C                   ELSE
 
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGMQ
     C                   PARM                    ZAPGRL
     C                   PARM                    ZAMSID
     C                   PARM                    ZAMSGF
     C                   PARM                    ZAMSDA
     C                   PARM                    ZAMSTP
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBERR - Set up Batch Error Details                          *
      *                                                               *
      *****************************************************************
     C     SRBERR        BEGSR
 
     C                   DUMP
     C                   CALL      'Y2RVMGC'
     C                   PARM                    PRetCode
     C                   PARM                    ZAMSID
     C                   PARM                    ZAMSGF
     C                   PARM                    ZAMSDA
     C                   PARM                    ZAMSTX
 
     C*                  IF        WBError = 'Y'
 
     C*                  IF        RepairLoc = 'B'
 
     C*                  CALL      'LEC0215'
     C*                  PARM                    XREPN
 
     C*                  EVAL      XREPN
     C*                  EVAL      XMSID
     C*                  EVAL      ITYPE
     C*                  EVAL      ITMST
     C*                  EVAL      IPCRF
     C*                  EVAL      ILNRF
     C*                  EVAL      IVDAT
     C*                  EVAL      ILASQ
     C*                  EVAL      ICNUM
     C*                  EVAL      IFACL
     C*                  EVAL      IFESQ
     C*                  EVAL      ISEQ
     C*                  EVAL      IRCPC
     C*                  EVAL      IRSTM
     C*                  EVAL      IRONS
     C*                  EVAL      IRIBN
     C*                  EVAL      IRIBA
     C*                  EVAL      IROBN
     C*                  EVAL      IROCN
     C*                  EVAL      IRSCY
     C*                  EVAL      IREXR
     C*                  EVAL      IREXI
     C*                  EVAL      IPYPC
     C*                  EVAL      IPSTM
     C*                  EVAL      IPONS
     C*                  EVAL      IPIBN
     C*                  EVAL      IPIBA
     C*                  EVAL      IPOBN
     C*                  EVAL      IPOCN
     C*                  EVAL      IRCRN
     C*                  EVAL      IRCRA
     C*                  EVAL      IRVNO
     C*                  EVAL      IAWBN
     C*                  EVAL      IAWBA
     C*                  EVAL      IBENN
     C*                  EVAL      IBENA
     C*                  EVAL      IDTP1
     C*                  EVAL      IDTP2
     C*                  EVAL      IDTP3
     C*                  EVAL      IDTP4
     C*                  EVAL      IDCHG
     C*                  EVAL      IBTB1
     C*                  EVAL      IBTB2
     C*                  EVAL      IBTB3
     C*                  EVAL      IBTB4
     C*                  EVAL      IBTB5
     C*                  EVAL      IBTB6
     C*                  EVAL      ICVMR
     C*                  EVAL      IPSCY
     C*                  EVAL      IIC72
     C*                  EVAL      IPEXR
     C*                  EVAL      IPEXI
     C*                  EVAL      IPTRF
 
     C*                  WRITE     LEISTLD0
 
     C*                  IF        CSC011 = 'Y' AND
     C*                            S1SUPP = LIBR
     C*                  EXSR      LOG247
     C*                  EVAL      WLogValid = 'I'
     C*                  EXSR      APLGTR
     C*                  ENDIF
 
     C*                  ENDIF
     C*                  ENDIF
 
     C                   IF        PMode = 'B'
     C*                  EVAL      DETAILS
     C                   ENDIF
      *
      ** If not a warning error, stop validation and return
      ** For batch mode, update LDA before returning
      *
     C     PMODE         IFEQ      'B'
     C     *LOCK         IN        LDA
     C                   MOVEL     ZAMSID        DBKEY
     C                   MOVEL     'LERMSGF'     DBFILE
     C                   MOVEL     ZAMSTX        ZZ053
     C                   OUT       LDA
     C                   MOVE      ZAMSID        ERCD
     C                   MOVEL     ERCD          PMERCD
     C                   ENDIF
      *
     C                   MOVE      '1'           *INLR
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAOCURR - Access Currency Details                           *
      *                                                               *
      *****************************************************************
     C     SRAOCURR      BEGSR
 
      ** Access Currency Details
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*KEY   '     POption
     C                   PARM                    PCurr
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAOACOD - Access Account Code Details                       *
      *                                                               *
      *****************************************************************
     C     SRAOACOD      BEGSR
 
      ** Access Account Code Details
 
     C                   CALL      'AOACODR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*KEY   '     POption
     C                   PARM                    PAcod
     C     SDACOD        PARM      SDACOD        DSFDY
 
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDACODPD'
     C                   EVAL      DBKEY =  PAcod
     C                   EVAL      DBASE =  3
     C                   EVAL      PMDBSE = DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   OUT       LDA
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAOBRCH - Access Branch Code Details                        *
      *                                                               *
      *****************************************************************
     C     SRAOBRCH      BEGSR
 
      ** Access Branch Code Details
 
     C**********         CALL      'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*KEY   '     POption
     C                   PARM                    PBranch
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAOACCV - Access Account Identifer                          *
      *                                                               *
      *****************************************************************
     C     SRAOACCV      BEGSR
 
      ** Access Account Identifier
 
     C                   CALL      'AOACCTV0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      WrkACID       PACID
     C                   PARM      WrkCYCD       PCYCD
     C                   PARM      WrkACCD       PACCD
     C                   PARM      WrkACSQ       PACSQ
     C                   PARM      WrkBRCA       PBRCA
     C                   PARM      *BLANKS       PTYPA
     C                   PARM      *BLANKS       PNONB
     C     ACCNTB        PARM      ACCNTB        P#FMT
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAOACCR - Access Account Details                            *
      *                                                               *
      *****************************************************************
     C     SRAOACCR      BEGSR
 
      ** Access Account Details
 
     C                   CALL      'AOACCTR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*KEY   '     POption
     C                   PARM      *BLANKS       PRETL
     C                   PARM      WrkCNUM       PCNUM
     C                   PARM      WrkCYCD       PCYCD
     C                   PARM      WrkACCD       PACCD
     C                   PARM      WrkACSQ       PACSQ
     C                   PARM      WrkBRCA       PBRCA
     C     ACCNTB        PARM      ACCNTB        DSSDY
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAONOST - Access Nostro Code Details                        *
      *                                                               *
      *****************************************************************
     C     SRAONOST      BEGSR
 
      ** Access Nostro Code Details
 
     C                   CALL      'AONOSTR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*KEY   '     POption
     C                   PARM      *BLANKS       PCNUM
     C                   PARM      WrkCYCD       PCYCD
     C                   PARM      *BLANKS       PACCD
     C                   PARM      *BLANKS       PACSQ
     C                   PARM      WrkNONB       PNONB
     C                   PARM      *BLANKS       PBRCA
     C                   PARM      *BLANKS       PACID
     C                   PARM      *BLANKS       PPNOI
     C     SDNOST        PARM      SDNOST        DSFDY
 
     C                   IF        PRetCode = *BLANKS
 
     C                   SELECT
 
     C                   WHEN      WPRInd = 'R'
     C                   EVAL      WRcvSetlCcy = A7CYCD
     C                   EVAL      WRcvSetlLoc = %SUBST(A7NOSN:8:3)
     C                   WHEN      WPRInd = 'P'
     C                   EVAL      WPaySetlCcy = A7CYCD
     C                   EVAL      WPaySetlLoc = %SUBST(A7NOSN:8:3)
     C                   ENDSL
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAOSARD - Access Switchable Features File                   *
      *                                                               *
      *****************************************************************
     C     SRAOSARD      BEGSR
 
      ** Access Switchable Features File
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*VERIFY'     POption
     C                   PARM                    PSard
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRetCode <> *BLANKS AND
     C                             PRetCode <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SCSARDPD'
     C                   EVAL      DBKEY  =  PSard
     C                   EVAL      DBASE  =  4
     C                   EVAL      PMDBSE = DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAOSVAL - Access System Values                              *
      *                                                               *
      *****************************************************************
     C     SRAOSVAL      BEGSR
 
      ** Access System Values
 
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM                    PSysValK1
     C                   PARM                    PSysVal1
     C                   PARM                    PSysValK2
     C                   PARM                    PSysVal2
     C                   PARM                    PSysValK3
     C                   PARM                    PSysVal3
     C                   PARM                    PSysValK4
     C                   PARM                    PSysVal4
     C                   PARM                    PSysValK5
     C                   PARM                    PSysVal5
     C                   PARM                    PSysValK6
     C                   PARM                    PSysVal6
     C                   PARM                    PSysValK7
     C                   PARM                    PSysVal7
     C                   PARM                    PSysValK8
     C                   PARM                    PSysVal8
     C                   PARM                    PSysValK9
     C                   PARM                    PSysVal9
     C                   PARM                    PSysValK10
     C                   PARM                    PSysVal10
 
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDSVALJ0'
     C                   EVAL      DBKEY  =  PSysValK1
     C                   EVAL      DBASE  =  5
     C                   EVAL      PMDBSE = DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZEDIT - Edit Screen Field subroutine                         *
      *                                                               *
      *****************************************************************
     C     ZEDIT         BEGSR
 
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZField
     C                   PARM                    ZADEC
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZASIGN - Validate and right aligned numeric fields           *
      *                                                               *
      *****************************************************************
 
     C     ZASIGN        BEGSR
 
     C                   CALLB     'ZASIGN'
     C                   PARM                    ZAsignOk
     C                   PARM                    ZFLD17
     C                   PARM                    ZADIG
     C                   PARM                    ZADEC
     C                   PARM                    ZSDCSP
     C                   PARM                    ZOUT15
     C                   PARM                    ZFSIGN
 
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  CLE038
      *****************************************************************                       CLE038
      *                                                               *                       CLE038
      *  ZXRATE - Obtain cross-rate between two currencies            *                       CLE038
      *                                                               *                       CLE038
      *****************************************************************                       CLE038
                                                                                              CLE038
     C     ZXRATE        BEGSR                                                                CLE038
                                                                                              CLE038
     C                   CALLB     'ZXRATE'                                                   CLE038
     C                   PARM                    ZRATE1                                       CLE038
     C                   PARM                    ZMDI1                                        CLE038
     C                   PARM                    ZRATE2                                       CLE038
     C                   PARM                    ZMDI2                                        CLE038
     C                   PARM                    ZRATEX                                       CLE038
     C                   PARM                    ZMDIX                                        CLE038
                                                                                              CLE038
     C                   ENDSR                                                                CLE038
      *****************************************************************                       CLE038
      /EJECT                                                                                  CLE038
      *****************************************************************                       CLE038
      *                                                               *                       CLE038
      *  ZCONV  - Obtain cross-rate between two currencies            *                       CLE038
      *                                                               *                       CLE038
      *****************************************************************                       CLE038
                                                                                              CLE038
     C     ZCONV         BEGSR                                                                CLE038
                                                                                              CLE038
     C                   CALLB     'ZCONV'                                                    CLE038
     C                   PARM                    ZAMTCI                                       CLE038
     C                   PARM                    ZEXCH                                        CLE038
     C                   PARM                    ZMD                                          CLE038
     C                   PARM                    ZCCYI                                        CLE038
     C                   PARM                    ZCCYO                                        CLE038
     C                   PARM                    ZCDPI                                        CLE038
     C                   PARM                    ZCDPO                                        CLE038
     C                   PARM                    ZAMTCO                                       CLE038
                                                                                              CLE038
     C                   ENDSR                                                                CLE038
      *****************************************************************                       CLE038
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRESET - Reset Error Indicators                             *
      *                                                               *
      *****************************************************************
 
     C     SRRESET       BEGSR
 
     C                   EVAL      *IN22 = *OFF
     C                   EVAL      *IN23 = *OFF
     C                   EVAL      *IN24 = *OFF
     C                   EVAL      *IN25 = *OFF
     C                   EVAL      *IN26 = *OFF
     C                   EVAL      *IN27 = *OFF
     C                   EVAL      *IN28 = *OFF
     C                   EVAL      *IN29 = *OFF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation subroutine.                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Settlement Allocations File Key List 1
 
     C     KFLDS1        KLIST
     C                   KFLD                    WType
     C                   KFLD                    WTimeStamp
     C                   KFLD                    WLnRef
     C                   KFLD                    WLnAmdVDat
     C                   KFLD                    WLnAmdSeq
     C                   KFLD                    WCusFees
     C                   KFLD                    WFclFees
     C                   KFLD                    WFeeSeq
     C                   KFLD                    WSequence
 
      ** Settlement Allocations File Key List 2
 
     C     KFLDS2        KLIST
     C                   KFLD                    WType
     C                   KFLD                    WLnRef
     C                   KFLD                    WLnAmdVDat
     C                   KFLD                    WLnAmdSeq
     C                   KFLD                    WCusFees
     C                   KFLD                    WFclFees
     C                   KFLD                    WFeeSeq
     C                   KFLD                    WSequence
 
      ** Settlement Allocations Invalid File Key List
 
     C     KFLDS3        KLIST
     C                   KFLD                    WType
     C                   KFLD                    WTimeStamp
     C                   KFLD                    WLnRef
     C                   KFLD                    WLnAmdVDatA
     C                   KFLD                    WLnAmdSeq
     C                   KFLD                    WCusFees
     C                   KFLD                    WFclFees
     C                   KFLD                    WFeeSeq
     C                   KFLD                    WSequence
 
      ** API Invalid Log File Key List
 
     C     KFLDS4        KLIST
     C                   KFLD                    WMsgType
     C                   KFLD                    WFrOffId
     C                   KFLD                    WTimeStamp
 
      ** Settlement Allocations File Key List
 
     C     KFLDS5        KLIST
     C                   KFLD                    WType
     C                   KFLD                    WLnRef
     C                   KFLD                    WLnAmdVDat
     C                   KFLD                    WLnAmdSeq
     C                   KFLD                    WCusFees
     C                   KFLD                    WFclFees
     C                   KFLD                    WFeeSeq
 
      ** Settlement Allocations File Key List 6 for LESTALLX
 
     C     KFLDS6        KLIST
     C                   KFLD                    WType
     C                   KFLD                    WTimeStamp
     C                   KFLD                    WLnRef
     C                   KFLD                    WLnAmdVDat
     C                   KFLD                    WLnAmdSeq
     C                   KFLD                    WCusFees
     C                   KFLD                    WFclFees
     C                   KFLD                    WFeeSeq
 
      ** Settlement Allocations File Key List 7
 
     C     KFLDS7        KLIST
     C                   KFLD                    WType
     C                   KFLD                    WTimeStamp
 
      **---------------------------------------------------------------
      ** The following /COPY line sets the Program, Module, and
      ** Procedure names for Database Error Processing.
     C/COPY ZACPYSRC,DBFIELDS
      **---------------------------------------------------------------
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
 
      *****************************************************************
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C     PMODE         IFNE      'B'
     C                   ROLBK
     C                   ENDIF
 
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
 
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C     PMODE         IFEQ      'I'
     C     PMODE         OREQ      'R'
     C     PMODE         OREQ      'F'
     C                   CALL      'DBERRCTL'
     C                   ENDIF
     C                   ENDIF
 
     C     PMODE         IFEQ      'B'
     C     PMODE         OREQ      'P'
     C     PMDBSE        IFEQ      0
     C                   MOVE      999           PMDBSE
     C                   ENDIF
     C                   EVAL      PMDBFL = DBFILE
     C                   EVAL      PMDBKY = DBKEY
     C                   EVAL      PMDPGM = 'LE2230'
     C                   MOVEL     'LEL0035 '    ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
 
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Finastra International Limited 2003
