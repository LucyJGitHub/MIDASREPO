     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Aggregated Facility History Report')          *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000056 - Aggregated Facility History Report                *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 BUG6005            Date 04Apr05               *
      *                 BUG5998            Date 08Mar05               *
      *                 CLE041  *CREATE    Date 11Oct04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  BUG6005- Print blank whenever exchange rate is zero since    *
      *           this is dependent on the revolving credit indicator *
      *           of the aggregate facility or tranche.               *
      *  BUG5998 - LEC000056 failed due to pointer or parameter error *
      *  CLE041 - Collateralised Lending Phase 2B                     *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Aggregate Facility File
     FLEAGFYL1  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas LE Aggregate Facilities Detail B Record
     FLEAGFYL2  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas LE Aggregate Facility File
     FLEAGFCL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FCLTYFMF:AGFCLTYA)
 
      ** Midas LE Agg.Fclty History by Fclty/VDAT/SEQ
     FLEAGHSL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas LE Tranche-Aggregate Fclty Rel by Agg.Fclty
     FLETRAGL1  IF   E           K DISK    INFSR(*PSSR)
 
      ** Facility File
     FFCLTY1    IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(OR)
 
     FFCLTYL5   IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FCLTYFNF:CRFCLTYN)
     F                                     PREFIX(CR)
 
      ** Aggregated Facility History Report
     FLE000056P1O    E             PRINTER INFSR(*PSSR)
     F                                     OFLIND(*IN05)
     F                                     USROPN
     F                                     INFDS(SPOOL)
 
      ** Aggregated Facility History Report - Audit
     FLE000056AUO    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOLU)
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
     D/COPY ZACPYSRC,STD_D_SPEC
      ** Data Area giving Installation Control Details
 
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure
 
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
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for Midas Modules Details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      ** External DS for Branch Details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
      ** External DS for Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** External DS for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D SDCUSTDFAC    E                     EXTFLD(QQDFAC)
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, Short Data Structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for Access Programs, Long Data Structure
 
     D PParm           DS           100
     D   ParmCUST              1      6
     D   ParmFACT              7      9
     D   ParmFCNO             10     11
 
      ** SPOOL Information Data Structure for ZSFILE
     D SPOOL           DS
     D  SFILE                 83     92
     D  SFNUM                123    124B 0
 
      ** SPOOL Information Data Structure for ZSFILE - AU Report
     D SPOOLU          DS
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PSeq            S              5
     D PLev            S              1
     D PEnty           S              3
     D PWEnty          S              3                                                      BUG5998
     D PSFile          S             10
     D PZSNum          S              6  0
     D PZSErr          S              1
     D WRun            S              1
     D Empty1          S              1
     D Empty2          S              1
     D RdFile1         S              1
     D PRtCd           S              7
     D POptn           S              7
     D WkTRNM          S              6
     D WkTRFT          S              3
     D WkTRFN          S              2
     D WkTRFC          S              5
     D WkCount         S              5S 0
     D WTotalFAMT      S             15  0
     D PDayNo          S              5  0
     D PDateN          S              6  0
     D PDateA          S              7
     D PBRCH           S              3
     D PCUST           S             10
     D PSTKEY          S              7
     D PCcy            S              3
     D PFld15          S             15  0
     D PDecs           S              1  0
     D PECode          S              1
     D Zout21          S             21
     D WRATE           S             13  8
     D WSPRT1          S             13  8
     D WSPRT2          S             13  8
     D XSPRT1          S             13  8
     D XSPRT2          S             13  8
     D WMDIN           S              1
     D WMDIN1          S              1
     D WMDIN2          S              1
     D XMDIN1          S              1
     D XMDIN2          S              1
     D WCCY1           S              3
     D WCCY2           S              3
     D WNBDP1          S              1  0
     D WNBDP2          S              1  0
     D WINAMT          S             15  0
     D WOUTAMT         S             15  0
 
     D WrkBRCA         S                   LIKE(BRCA)
     D KBRCA           S                   LIKE(BRCA)
     D KCNUM           S                   LIKE(CNUM)
     D KFACT           S                   LIKE(FACT)
     D KFCNO           S                   LIKE(FCNO)
     D KFCTY           S                   LIKE(AIFCTY)
     D KLCNUM          S                   LIKE(CNUM)
     D KLFACT          S                   LIKE(FACT)
     D KLFCNO          S                   LIKE(FCNO)
     D KTBRCA          S                   LIKE(BRCA)
     D KTCNUM          S                   LIKE(CNUM)
     D KTFACT          S                   LIKE(FACT)
     D KTFCNO          S                   LIKE(FCNO)
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *================================================================
      *  P R O G R A M   S T A R T                                    *
      *================================================================
 
      ** Main processing
 
     C                   EXSR      SRMain
 
      ** Termination processing
 
     C                   EXSR      SRTerm
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMain - Main Processing                                     *
      *                                                               *
      *****************************************************************
 
     C     SRMain        BEGSR
 
     C                   IF        PEnty <> 'ALL'
     C                   EVAL      KBRCA = PEnty
     C                   ELSE
     C                   EVAL      KBRCA = *BLANKS
     C                   ENDIF
 
     C                   IF        ParmCust = *BLANKS and ParmFACT = *BLANKS
     C                             and ParmFCNO = *BLANKS
     C**********         EVAL      KCNUM = *ZEROS                                             CSD027
     C                   EVAL      KCNUM = *BLANKS                                            CSD027
     C                   EVAL      KFACT = *ZEROS
     C                   EVAL      KFCNO = *ZEROS
     C                   ELSE
     C                   MOVEL     ParmCUST      KCNUM
     C                   MOVEL     ParmFACT      KFACT
     C                   MOVEL     ParmFCNO      KFCNO
     C                   ENDIF
 
      ** Print report for a specific branch
 
     C                   IF        PEnty <> 'ALL'
     C                   EVAL      PBRCH = PEnty
     C                   EXSR      SRBranch
 
     C                   SELECT
 
      ** Process all aggregated facilities
 
     C                   WHEN      ParmCust = *BLANKS and ParmFACT = *BLANKS
     C                             and ParmFCNO = *BLANKS
     C     KBRCA         SETLL     LEAGFYL1
     C     KBRCA         READE     LEAGFYL1
     C                   EXSR      SRProc1
 
      ** Process requested aggregated facility
 
     C                   WHEN      PParm <> *BLANKS
     C     KFCLTYA       SETLL     LEAGFYL1
     C     KFCLTYA       READE     LEAGFYL1
     C                   EXSR      SRProc1
 
     C                   ENDSL
 
      ** Print report for all branches
 
     C                   ELSE
 
     C                   EXSR      SRProc2
 
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProc1 - Process Aggregated Facility from Specific Branch   *
      *                                                               *
      *****************************************************************
 
     C     SRProc1       BEGSR
 
     C                   EXSR      SRPrintRec
 
     C                   DOW       NOT %EOF(LEAGFYL1)
 
     C                   MOVEL     CNUM          KCNUM
     C                   MOVEL     FACT          KFACT
     C                   MOVEL     FCNO          KFCNO
     C                   MOVEL     BRCA          KBRCA
 
     C     KFCLTYB       CHAIN     LEAGFYL2                           65
 
     C                   MOVEL     CNUM          PCUST
     C                   EXSR      SRCustomer
     C                   MOVEL     CNUM          RFCUST
     C                   MOVEL     FACT          RFFACT
     C                   MOVEL     FCNO          RFFCNO
     C                   EVAL      RFFCCY = FCCY
     C                   EVAL      RFRCVR = RVCR
 
      ** Format Facility Amount
 
     C                   EVAL      PCcy = FCCY
     C                   EXSR      SRGetCurrD
     C                   EVAL      PDecs = A6NBDP
 
     C                   EVAL      PFld15 = FAMT
     C                   EXSR      SRFmtAmt
     C                   MOVE      ZOut21        RFFAMT
 
      ** Format Drawn Amount
 
     C                   EVAL      PFld15 = OAM1
     C                   EXSR      SRFmtAmt
     C                   MOVE      ZOut21        RFOAM1
 
     C                   WRITE     LE000056R0
 
     C                   ADD       1             WkCount
 
     C                   EXSR      SRFmtDetls
 
     C                   IF        Empty2 = 'N'
     C                   EXSR      SRPrintTotal
     C                   ENDIF
 
      ** Read next record
 
     C                   SELECT
 
     C                   WHEN      ParmCust = *BLANKS and ParmFACT = *BLANKS
     C                             and ParmFCNO = *BLANKS
     C     KBRCA         READE     LEAGFYL1
 
     C                   WHEN      PParm <> *BLANKS
     C     KFCLTYA       READE     LEAGFYL1
 
     C                   ENDSL
 
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProc2 - Process Aggregated Facilities from All Branches    *
      *                                                               *
      *****************************************************************
 
     C     SRProc2       BEGSR
 
     C                   EVAL      RdFile1 = 'Y'
 
     C                   IF        ParmCust = *BLANKS and ParmFACT = *BLANKS
     C                             and ParmFCNO = *BLANKS
     C     *LOVAL        SETLL     LEAGFYL1
     C                   READ      LEAGFYL1
     C                   ELSE
     C                   EVAL      RdFile1 = 'N'
     C     KFCLTYC       SETLL     LEAGFCL3
     C     KFCLTYC       READE     LEAGFCL3
     C                   ENDIF
 
     C                   IF        (NOT %EOF(LEAGFYL1) and RdFile1 = 'Y') or
     C                             (NOT %EOF(LEAGFCL3) and RdFile1 = 'N')
     C                   EVAL      WrkBRCA = BRCA
     C                   EVAL      PBRCH = BRCA
     C                   EXSR      SRBranch
     C                   ENDIF
 
     C                   EXSR      SRPrintRec
 
     C                   DOW       (NOT %EOF(LEAGFYL1) and RdFile1 = 'Y') or
     C                             (NOT %EOF(LEAGFCL3) and RdFile1 = 'N')
 
      ** Change in branch
 
     C                   IF        BRCA <> WrkBRCA
 
     C                   IF        *IN05 = *ON
     C                   WRITE     LE000056R0
     C                   EVAL      *IN05 = *OFF
     C                   ENDIF
 
      ** Write 'END OF REPORT FOR BRANCH'
 
     C                   WRITE     LE000056R6
     C                   CLOSE     LE000056P1
     C                   OPEN      LE000056P1
 
     C                   EVAL      WrkBRCA = BRCA
     C                   EVAL      PBRCH = BRCA
     C                   EXSR      SRBranch
     C                   EVAL      *IN05 = *OFF
 
     C                   ENDIF
 
     C                   MOVEL     CNUM          KCNUM
     C                   MOVEL     FACT          KFACT
     C                   MOVEL     FCNO          KFCNO
     C                   MOVEL     BRCA          KBRCA
 
     C     KFCLTYB       CHAIN     LEAGFYL2                           65
 
     C                   MOVEL     CNUM          PCUST
     C                   EXSR      SRCustomer
     C                   MOVEL     CNUM          RFCUST
     C                   MOVEL     FACT          RFFACT
     C                   MOVEL     FCNO          RFFCNO
     C                   EVAL      RFFCCY = FCCY
     C                   EVAL      RFRCVR = RVCR
 
      ** Format Facility Amount
 
     C                   EVAL      PCcy = FCCY
     C                   EXSR      SRGetCurrD
     C                   EVAL      PDecs = A6NBDP
 
     C                   EVAL      PFld15 = FAMT
     C                   EXSR      SRFmtAmt
     C                   MOVE      ZOut21        RFFAMT
 
      ** Format Drawn Amount
 
     C                   EVAL      PFld15 = OAM1
     C                   EXSR      SRFmtAmt
     C                   MOVE      ZOut21        RFOAM1
 
     C                   WRITE     LE000056R0
 
     C                   IF        BRCA <> WrkBRCA
     C                   EVAL      WrkBRCA = BRCA
     C                   ELSE
 
     C                   ADD       1             WkCount
 
     C                   EXSR      SRFmtDetls
 
     C                   IF        Empty2 = 'N'
     C                   EXSR      SRPrintTotal
     C                   ENDIF
 
      ** Read next record
 
     C                   IF        ParmCust = *BLANKS and ParmFACT = *BLANKS
     C                             and ParmFCNO = *BLANKS
     C                   READ      LEAGFYL1
     C                   ELSE
     C     KFCLTYC       READE     LEAGFCL3
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrintRec - Print a Record                                  *
      *                                                               *
      *****************************************************************
 
     C     SRPrintRec    BEGSR
 
      ** For the first pass, open the printer file
 
     C                   IF        NOT %EOF(LEAGFYL1)
     C                   OPEN      LE000056P1
 
      ** Ensure report file is recorded by RCF
 
     C                   Z-ADD     SFNUM         PZSNum
     C                   MOVE      SFILE         PSFile
     C                   EXSR      SRRCFProc
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtDetls - Format Report Details                           *
      *                                                               *
      *****************************************************************
 
     C     SRFmtDetls    BEGSR
 
      ** Facility Amount History
 
     C                   WRITE     LE000056R1
 
     C                   EVAL      Empty1 = 'Y'
     C                   EVAL      *IN75 = *OFF
     C                   MOVE      KFCNO         KFCTY
     C                   MOVEL     KFACT         KFCTY
 
     C     KLEAGHS       SETLL     LEAGHSL0
     C     KLEAGHS       READE     LEAGHSL0
 
     C                   DOW       NOT %EOF(LEAGHSL0)
 
     C                   EVAL      Empty1 = 'N'
     C                   EVAL      *IN75 = *ON
      ** Format Date
 
     C                   EVAL      PDayNo = AIDATE
     C                   EXSR      SRFmtDate
     C                   EVAL      RDATE = PDateA
 
     C                   MOVEL     AITRNM        WkTRNM
     C                   MOVEL     AITRFC        WkTRFC
     C                   EVAL      RACTN = AIACTN
     C                   EVAL      RRCIN = AIRCIN
 
     C                   IF        AITRBR <> *BLANKS
     C                   EVAL      RTRN1 = AITRBR + WkTRNM + WkTRFC
     C                   ELSE
     C                   EVAL      RTRN1 = *BLANKS
     C                   ENDIF
 
     C                   EVAL      RTRCY = AITRCY
     C                   EVAL      RTRRC = AITRRC
     C                   EVAL      RMDIN1 = AIMDIN
 
      ** Format Action Amount (Aggregate)
 
     C                   EVAL      PCcy = FCCY
     C                   EXSR      SRGetCurrD
     C                   EVAL      PDecs = A6NBDP
 
     C                   EVAL      PFld15 = AIAAMT
     C                   EXSR      SRFmtAmt
     C                   MOVE      ZOut21        RAAMT
 
      ** Format Facility Amount
 
     C                   EVAL      PFld15 = AIAFAM
     C                   EXSR      SRFmtAmt
     C                   MOVE      ZOut21        RAFAM
 
      ** Format Action Amount (Tranche)
 
     C                   IF        AITRCY <> *BLANKS
     C                   EVAL      PCcy = AITRCY
     C                   EXSR      SRGetCurrD
     C                   EVAL      PDecs = A6NBDP
 
     C                   EVAL      PFld15 = AITRAM
     C                   EXSR      SRFmtAmt
     C                   MOVE      ZOut21        RTRAM
     C                   ELSE
     C                   EVAL      RTRAM = *BLANKS
     C                   ENDIF
 
      ** Format Exchange Rate
 
     C                   IF        AIEXRT <> 0                                               BUG6005
     C                   EVAL      PDecs = 8
     C                   MOVE      AIEXRT        PFld15
     C                   EXSR      SRFmtAmt
     C                   MOVE      ZOut21        REXRT1
     C                   ELSE                                                                BUG6005
     C                   MOVE      *BLANKS       REXRT1                                      BUG6005
     C                   ENDIF                                                               BUG6005
 
      ** Format Module and Transaction
 
     C                   EVAL      RMODL = *BLANKS
     C                   EVAL      RTRAN = *BLANKS
 
     C**********         IF        AILOAN <> 0                                                CLE148
     C                   IF        AILOAN <> *BLANKS                                          CLE148
     C                   EVAL      RMODL = 'LE'
     C                   MOVEL     AILOAN        RTRAN
     C                   ENDIF
 
     C                   IF        AIDEAL <> 0
     C                   EVAL      RMODL = 'DL'
     C                   MOVEL     AIDEAL        RTRAN
     C                   ENDIF
 
     C                   IF        AIUSEQ <> 0
     C                   EVAL      RMODL = 'MT'
     C                   MOVEL     AIUSEQ        RTRAN
     C                   ENDIF
 
     C                   IF        *IN05 = *ON
     C                   WRITE     LE000056R0
     C                   WRITE     LE000056R1
     C                   EVAL      *IN05 = *OFF
     C                   ENDIF
 
     C                   WRITE     LE000056R3
 
      ** Read next record
 
     C     KLEAGHS       READE     LEAGHSL0
     C                   ENDDO
 
     C                   IF        Empty1 = 'Y'
     C                   WRITE     LE000056R3
     C                   ENDIF
 
      ** Facility Drawn Amount Aggregates
 
     C                   WRITE     LE000056R2
 
     C                   EVAL      Empty2 = 'Y'
     C                   EVAL      *IN76 = *OFF
 
     C                   EVAL      KLCNUM = KCNUM
     C                   EVAL      KLFACT = KFACT
     C                   EVAL      KLFCNO = KFCNO
 
     C     KLETRAG       SETLL     LETRAGL1
     C     KLETRAG       READE     LETRAGL1
 
     C                   DOW       NOT %EOF(LETRAGL1)
 
     C                   EVAL      Empty2 = 'N'
     C                   EVAL      *IN76 = *ON
 
     C                   MOVEL     AGTRNM        WkTRNM
     C                   MOVEL     AGTRFT        WkTRFT
     C                   MOVEL     AGTRFN        WkTRFN
     C                   MOVEL     AGTRBR        KTBRCA
     C                   MOVEL     AGTRNM        KTCNUM
     C                   MOVEL     AGTRFT        KTFACT
     C                   MOVEL     AGTRFN        KTFCNO
 
     C     KTempA        CHAIN     FCLTY1                             65
 
     C                   IF        *IN65 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'LEAGFMPD'
     C                   EVAL      DBKEY = AGTRBR + WkTRNM +
     C                                     WkTRFT + WkTRFN
     C                   EVAL      DBASE = 6
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      RFCCY = ORFCCY
     C                   EVAL      RTRN2 = AGTRBR + '-' + WkTRNM +
     C                                     '-' + WkTRFT + '-' + WkTRFN
 
      ** Format Drawn Amount
 
     C     KTempB        CHAIN     FCLTYL5                            65
 
     C                   EVAL      PCcy = ORFCCY
     C                   EXSR      SRGetCurrD
     C                   EVAL      PDecs = A6NBDP
 
     C                   EVAL      PFld15 = CROAM1
     C                   EXSR      SRFmtAmt
     C                   MOVE      ZOut21        ROAM1
 
      ** Format Exchange Rate
 
     C                   EVAL      PCcy = ORFCCY
     C                   EVAL      WCCY1 = ORFCCY
     C                   EXSR      SRGetCurrD
 
      ** Save necessary details
 
     C                   EVAL      WSPRT1 = A6SPRT
     C                   EVAL      WMDIN1 = A6MDIN
     C                   EVAL      WNBDP1 = A6NBDP
 
     C                   EVAL      PCcy = RFFCCY
     C                   EVAL      WCCY2 = RFFCCY
     C                   EXSR      SRGetCurrD
 
      ** Save necessary details
 
     C                   EVAL      WSPRT2 = A6SPRT
     C                   EVAL      WMDIN2 = A6MDIN
     C                   EVAL      WNBDP2 = A6NBDP
 
     C                   EVAL      XMDIN1 = WMDIN1
     C                   EVAL      XMDIN2 = WMDIN2
     C                   EVAL      XSPRT1 = WSPRT1
     C                   EVAL      XSPRT2 = WSPRT2
 
     C                   CALLB     'ZXRATE'
     C                   PARM                    XSPRT1
     C                   PARM                    XMDIN1
     C                   PARM                    XSPRT2
     C                   PARM                    XMDIN2
     C                   PARM                    WRATE
     C                   PARM                    WMDIN
 
     C                   EVAL      PDecs = 8
     C                   MOVE      WRATE         PFld15
     C                   EXSR      SRFmtAmt
     C                   MOVE      ZOut21        REXRT2
 
     C                   EVAL      RMDIN2 = WMDIN
     C                   EVAL      WINAMT = OROAM1
 
      ** Format Aggregated Facility Drawn Amount
 
     C                   CALLB     'ZCONVZ1'
     C                   PARM                    WINAMT
     C                   PARM                    WRATE
     C                   PARM                    WMDIN
     C                   PARM                    WCCY1
     C                   PARM                    WCCY2
     C                   PARM                    WNBDP1
     C                   PARM                    WNBDP2
     C                   PARM                    WOUTAMT
 
     C                   EVAL      PCcy = WCCY2
     C                   EXSR      SRGetCurrD
     C                   EVAL      PDecs = A6NBDP
 
     C                   EVAL      PFld15 = WOUTAMT
     C                   EXSR      SRFmtAmt
     C                   MOVE      ZOut21        RAFAMT
 
     C                   ADD       WOUTAMT       WTotalFAMT
 
     C                   IF        *IN05 = *ON
     C                   WRITE     LE000056R0
     C                   WRITE     LE000056R2
     C                   EVAL      *IN05 = *OFF
     C                   ENDIF
 
     C                   WRITE     LE000056R4
 
      ** Read next record
 
     C     KLETRAG       READE     LETRAGL1
     C                   ENDDO
 
     C                   IF        Empty2 = 'Y'
     C                   WRITE     LE000056R4
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrintTotal - Print Total Aggregated Facility Drawn Amount  *
      *                                                               *
      *****************************************************************
 
     C     SRPrintTotal  BEGSR
 
      ** Format total aggregated facility drawn amount
 
     C                   EVAL      PCcy = FCCY
     C                   EXSR      SRGetCurrD
     C                   EVAL      PDecs = A6NBDP
     C                   EVAL      PFld15 = WTotalFAMT
     C                   EXSR      SRFmtAmt
     C                   MOVE      ZOut21        RTFAMT
 
      ** If overflow indicator, print header on next page
 
     C                   IF        *IN05 = *ON
     C                   WRITE     LE000056R0
     C                   EVAL      *IN05 = *OFF
     C                   ENDIF
 
     C                   WRITE     LE000056R5
 
     C                   EVAL      WTotalFAMT = 0
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtAmt - Subroutine that Formats Amount                    *
      *                                                               *
      *****************************************************************
 
     C     SRFmtAmt      BEGSR
 
     C                   CALL      'ZSEDIT'
     C                   PARM                    PFld15
     C                   PARM                    PDecs
     C                   PARM      'J'           PECode
     C                   PARM                    Zout21
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtDate - Subroutine that Formats Date                     *
      *                                                               *
      *****************************************************************
 
     C     SRFmtDate     BEGSR
 
     C                   CALL      'ZDATE2'
     C                   PARM                    PDayNo
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         PDateN
     C                   PARM      *BLANKS       PDateA
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetCurrD - Subroutine that Retrieves Currency Details      *
      *                                                               *
      *****************************************************************
 
     C     SRGetCurrD    BEGSR
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PCcy
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBKEY = PCcy
     C                   EVAL      DBASE = 3
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTerm - Termination Processing                              *
      *                                                               *
      *****************************************************************
 
     C     SRTerm        BEGSR
 
     C                   IF        WkCount > 0
     C                   IF        *IN05 = *ON
     C                   WRITE     LE000056R0
     C                   EVAL      *IN05 = *OFF
     C                   ENDIF
 
      ** Print 'END OF REPORT FOR BRANCH'
 
     C                   WRITE     LE000056R6
 
      ** Print 'END OF REPORT'
 
     C                   WRITE     LE000056R7
 
     C                   CLOSE     LE000056P1
 
      ** Print audit report
 
     C                   Z-ADD     WkCount       RTRECS
     C                   ENDIF
 
      ** Write header and details
 
     C                   WRITE     HEADAU
 
     C                   IF        *INU7 = *ON
     C                   WRITE     DBERROR
     C                   ELSE
     C                   IF        WkCount = 0
     C                   WRITE     NODTLS
     C                   ELSE
     C                   WRITE     CONTROL
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRCFProc - RCF Processing                                   *
      *                                                               *
      *****************************************************************
 
     C     SRRCFProc     BEGSR
 
      ** Ensure detail spool file recorded by RCF
 
     C                   EVAL      PWEnty  = PEnty                                           BUG5998
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C**********         PARM                    PEnty                                       BUG5998
     C                   PARM                    PWEnty                                      BUG5998
     C                   PARM                    PSFile
     C                   PARM                    PZSNum
     C                   PARM      *BLANK        PZSErr
 
      ** If error occurs during ZSFILE processing, then return to the
      ** calling program
 
     C                   IF        PZSErr = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBranch - Access Branch Details                             *
      *                                                               *
      *****************************************************************
 
     C     SRBranch      BEGSR
 
      ** Access branch details
 
     C                   CALL      'AOBRCHR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PBRCH
     C     SDBRCH        PARM      SDBRCH        DSFDY
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBRCHPD'
     C                   EVAL      DBKEY = PBRCH
     C                   EVAL      DBASE = 4
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      RBBRC = A8BRCD
     C                   EVAL      RBRNM = A8BRNM
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCustomer - Access Customer Details                         *
      *                                                               *
      *****************************************************************
 
     C     SRCustomer    BEGSR
 
      ** Access customer details
 
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY'        POptn
     C                   PARM                    PCUST
     C                   PARM      *BLANKS       PSTKEY
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBKEY = PCUST
     C                   EVAL      DBASE = 5
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      RFCRNM = BBCRNM
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Routine                      *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PSeq
     C                   PARM                    PLev
     C                   PARM                    PEnty
     C                   PARM                    PParm
 
     C     KFCLTYA       KLIST
     C                   KFLD                    KBRCA
     C                   KFLD                    KCNUM
     C                   KFLD                    KFACT
     C                   KFLD                    KFCNO
 
     C     KFCLTYB       KLIST
     C                   KFLD                    KCNUM
     C                   KFLD                    KFACT
     C                   KFLD                    KFCNO
 
     C     KFCLTYC       KLIST
     C                   KFLD                    KCNUM
     C                   KFLD                    KFACT
     C                   KFLD                    KFCNO
 
     C     KLEAGHS       KLIST
     C                   KFLD                    KBRCA
     C                   KFLD                    KCNUM
     C                   KFLD                    KFCTY
 
     C     KLETRAG       KLIST
     C                   KFLD                    KLCNUM
     C                   KFLD                    KLFACT
     C                   KFLD                    KLFCNO
 
     C     KTempA        KLIST
     C                   KFLD                    KTBRCA
     C                   KFLD                    KTCNUM
     C                   KFLD                    KTFACT
     C                   KFLD                    KTFCNO
 
     C     KTempB        KLIST
     C                   KFLD                    KTCNUM
     C                   KFLD                    KTFACT
     C                   KFLD                    KTFCNO
 
      ** Access bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = '*FIRST'
     C                   EVAL      DBASE = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access Midas modules details
 
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDMMOD        PARM      SDMMOD        DSFDY
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDMMODPD'
     C                   EVAL      DBKEY = '*FIRST'
     C                   EVAL      DBASE = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
 
     C                   IF        BGMBIN = 'Y'
     C                   EVAL      *IN27 = *ON
     C                   ENDIF
 
     C                   ENDIF
 
      ** Ensure audit report is recorded by RCF
 
     C                   Z-ADD     SFNUMU        PZSNum
     C                   MOVE      SFILEU        PSFile
     C                   EXSR      SRRCFProc
 
      ** Initialise record counters
 
     C                   EVAL      WkCount = 0
     C                   EVAL      WTotalFAMT = 0
 
     C                   IF        ParmCUST = *ZEROS                                         BUG5998
     C                   EVAL      ParmCUST = *BLANKS                                        BUG5998
     C                   ENDIF                                                               BUG5998
                                                                                             BUG5998
     C                   IF        ParmFACT = *ZEROS                                         BUG5998
     C                   EVAL      ParmFACT = *BLANKS                                        BUG5998
     C                   ENDIF                                                               BUG5998
                                                                                             BUG5998
     C                   IF        ParmFCNO = *ZEROS                                         BUG5998
     C                   EVAL      ParmFCNO = *BLANKS                                        BUG5998
     C                   ENDIF                                                               BUG5998
                                                                                             BUG5998
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Error Handling Subroutine                            *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   IF        WRun  = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   EVAL      DBPGM = 'LE000056'
     C                   DUMP
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   EXSR      SRTerm
 
     C                   ENDSR
 
      *****************************************************************
