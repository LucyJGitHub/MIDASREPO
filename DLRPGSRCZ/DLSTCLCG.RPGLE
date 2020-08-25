     H DEBUG
     H COPYRIGHT('(C) Copyright Finastra International Limited, 2005')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas DL Deal SubType/Class Changes - A/C Key Gen')    *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DLSTCLCG - Deal Sub-Type/Class Changes - A/c Key Generation  *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CDL099             Date 06Oct17               *
      *                 CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CLE148             Date 23Jul12               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 CER048             Date 19May08               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027A            Date 05May06               *
      *                 CDL038  *CREATE    Date 10May05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompiled)                                        *
      *  CLE148 - Alpha Loan Reference                                *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CSD027A- Conversion of customer number to alpha.             *
      *  CDL038 - Extended Deal Sub Type                              *
      *                                                               *
      *****************************************************************

     FDEALSDB   IF   E             DISK    INFSR(*PSSR)

     FDEALSDC   IF   E             DISK    INFSR(*PSSR)
     FMMDEMULL  UF   E           K DISK    INFSR(*PSSR)  INCLUDE(DEAMSDIF)
     F                                     PREFIX(A_)
     FMMDAMULL  UF   E           K DISK    INFSR(*PSSR)  INCLUDE(MMDEAMP0)

     FDEALSDD   IF   E             DISK    INFSR(*PSSR)

     FDEALSDE   IF   E             DISK    INFSR(*PSSR)

     FDEALSDG   IF   E             DISK    INFSR(*PSSR)
     FASHTRNLA  IF   E           K DISK    INFSR(*PSSR)
     FASHGLKL1  IF   E           K DISK    INFSR(*PSSR)

     FDLSTCLL0  IF   E           K DISK    INFSR(*PSSR) PREFIX(O_)
     FDLSTCLPD  O    E             DISK    INFSR(*PSSR) RENAME(DLSTCLD0:NEW)
     FDLDKEYPD  O    E             DISK    INFSR(*PSSR) PREFIX(K_) EXTIND(*INU1)

     D AKY             S              1    DIM(14)

     D DKEYS         E DS                  EXTNAME(DLDKEYPD) PREFIX(K_)

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D SDFAIS        E DS                  EXTNAME(SDFAISPD)
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)

     IDEALSDBF      01
     IDEALSDCF      02
     IDEALSDDF      03
     IDEALSDEF      04
     IDEALSDGF      05

      * FOREX

     C                   MOVE      *OFF          *IN
     C                   IF         P_FILE = 'B' OR P_FILE = ' '
     C                   EXSR      P_DEALSDB
     C                   ENDIF

      * LOANS & DEPOSITS

     C                   MOVE      *OFF          *IN
     C                   IF         P_FILE = 'C' OR P_FILE = ' '
     C                   EXSR      P_DEALSDC
     C                   ENDIF

      * NAS PURCHASED

     C                   MOVE      *OFF          *IN
     C                   IF         P_FILE = 'D' OR P_FILE = ' '
     C                   EXSR      P_DEALSDD
     C                   ENDIF

      * NAS SOLD

     C                   MOVE      *OFF          *IN
     C                   IF         P_FILE = 'E' OR P_FILE = ' '
     C                   EXSR      P_DEALSDE
     C                   ENDIF

      * DERIVATIVES

     C                   MOVE      *OFF          *IN
     C                   IF         P_FILE = 'G' OR P_FILE = ' '
     C                   EXSR      P_DEALSDG
     C                   ENDIF

     C                   SETON                                        LR
     C                   RETURN

      /SPACE 5
      ********************************************************************
     C     P_DEALSDB     BEGSR
     C                   READ      DEALSDB                                99
     C     *IN99         DOWEQ     *OFF
     C                   IF         RECI <> 'N' AND RECI <> 'M' AND RECI <> 'E'
     C                              AND DTYP <> 'NX' AND DTYP <> 'OT'

     C                   EXSR      CHK_STCL

     C     STCL_Changed  IFEQ      'Y'

      * If deal date accounting has been done, generate fx deal date a/c keys

     C                   TESTB     '0'           ACEI                     98
     C   98              DO
     C                   MOVEL     O_DLST        DealSubType       2
     C                   MOVEL     O_CLAS        DealClass         4
     C                   Z-ADD     1             ReversalInd       1 0
     C                   EXSR      FOREX_DEAL
     C                   MOVEL     DLST          DealSubType
     C                   MOVEL     CLAS          DealClass
     C                   Z-ADD     0             ReversalInd
     C                   EXSR      FOREX_DEAL
     C                   ENDDO
     C                   ENDIF
     C                   WRITE     NEW
     C                   ENDIF
     C                   READ      DEALSDB                                99
     C                   ENDDO
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     P_DEALSDC     BEGSR
     C                   READ      DEALSDC                                99
     C     *IN99         DOWEQ     *OFF
     C                   IF         RECI <> 'N' AND RECI <> 'M' AND RECI <> 'E'
     C                   EXSR      DEAM_SYNC

     C                   EXSR      CHK_STCL

     C     STCL_Changed  IFEQ      'Y'

      * If deal date accounting has been done,
      * but value date accounting has NOT been done, generate loan/deposit deal date a/c keys

     C                   TESTB     '0'           ACEI                     98
     C                   TESTB     '1'           ACEI                     99
     C   98
     CANN99              DO
     C                   MOVEL     O_DLST        DealSubType
     C                   MOVEL     O_CLAS        DealClass
     C                   Z-ADD     1             ReversalInd
     C                   EXSR      LOANDEP_DEAL
     C                   MOVEL     DLST          DealSubType
     C                   MOVEL     CLAS          DealClass
     C                   Z-ADD     0             ReversalInd
     C                   EXSR      LOANDEP_DEAL
     C                   ENDDO

      * If value date accounting has been done, generate loan/deposit transfer a/c keys

     C                   TESTB     '1'           ACEI                     99
     C   99              DO
     C                   MOVEL     O_DLST        DealSubType
     C                   MOVEL     O_CLAS        DealClass
     C                   Z-ADD     1             ReversalInd
     C                   EXSR      LOANDEP_TRANS
     C                   MOVEL     DLST          DealSubType
     C                   MOVEL     CLAS          DealClass
     C                   Z-ADD     0             ReversalInd
     C                   EXSR      LOANDEP_TRANS
     C                   ENDDO
     C                   ENDIF
     C                   WRITE     NEW
     C                   ENDIF
     C                   READ      DEALSDC                                99
     C                   ENDDO
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     P_DEALSDD     BEGSR
     C                   READ      DEALSDD                                99
     C     *IN99         DOWEQ     *OFF
     C                   IF         RECI <> 'N' AND RECI <> 'M' AND RECI <> 'E'

     C                   EXSR      CHK_STCL

     C     STCL_Changed  IFEQ      'Y'

      * If deal date accounting has been done,
      * but value date accounting has NOT been done, generate na purchased deal date a/c keys

     C                   TESTB     '0'           ACEI                     98
     C                   TESTB     '1'           ACEI                     99
     C   98
     CANN99              DO
     C                   MOVEL     O_DLST        DealSubType
     C                   MOVEL     O_CLAS        DealClass
     C                   Z-ADD     1             ReversalInd
     C                   EXSR      NAPURCH_DEAL
     C                   MOVEL     DLST          DealSubType
     C                   MOVEL     CLAS          DealClass
     C                   Z-ADD     0             ReversalInd
     C                   EXSR      NAPURCH_DEAL
     C                   ENDDO

      * If value date accounting has been done, generate na purchased transfer a/c keys

     C                   TESTB     '1'           ACEI                     99
     C   99              DO
     C                   MOVEL     O_DLST        DealSubType
     C                   MOVEL     O_CLAS        DealClass
     C                   Z-ADD     1             ReversalInd
     C                   EXSR      NAPURCH_TRANS
     C                   MOVEL     DLST          DealSubType
     C                   MOVEL     CLAS          DealClass
     C                   Z-ADD     0             ReversalInd
     C                   EXSR      NAPURCH_TRANS
     C                   ENDDO
     C                   ENDIF
     C                   WRITE     NEW
     C                   ENDIF
     C                   READ      DEALSDD                                99
     C                   ENDDO
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     P_DEALSDE     BEGSR
     C                   READ      DEALSDE                                99
     C     *IN99         DOWEQ     *OFF
     C                   IF         RECI <> 'N' AND RECI <> 'M' AND RECI <> 'E'

     C                   EXSR      CHK_STCL

     C     STCL_Changed  IFEQ      'Y'

      * If deal date accounting has been done,
      * but value date accounting has NOT been done, generate na purchased deal date a/c keys

     C                   TESTB     '0'           ACEI                     98
     C                   TESTB     '1'           ACEI                     99
     C   98
     CANN99              DO
     C                   MOVEL     O_DLST        DealSubType
     C                   MOVEL     O_CLAS        DealClass
     C                   Z-ADD     1             ReversalInd
     C                   EXSR      NASOLD_DEAL
     C                   MOVEL     DLST          DealSubType
     C                   MOVEL     CLAS          DealClass
     C                   Z-ADD     0             ReversalInd
     C                   EXSR      NASOLD_DEAL
     C                   ENDDO
     C                   ENDIF
     C                   WRITE     NEW
     C                   ENDIF
     C                   READ      DEALSDE                                99
     C                   ENDDO
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     P_DEALSDG     BEGSR
     C                   READ      DEALSDG                                99
     C     *IN99         DOWEQ     *OFF
     C                   IF         RECI <> 'N' AND RECI <> 'M' AND RECI <> 'E'

     C                   EXSR      CHK_STCL

     C     STCL_Changed  IFEQ      'Y'
     C                   SELECT
     C     DTYP          WHENEQ    'FR'
     C                   EXSR      FRAS
     C                   OTHER
     C                   EXSR      OTHERDERIVS
     C                   ENDSL
     C                   ENDIF
     C                   WRITE     NEW
     C                   ENDIF
     C                   READ      DEALSDG                                99
     C                   ENDDO
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     DEAM_SYNC     BEGSR

      * Synchronize DEAMSDI

     C     DLNO          SETLL     DEAMSDIF
     C     DLNO          READE     DEAMSDIF                               99
     C     *IN99         DOWEQ     *OFF
     C                   MOVEL     DLST          A_DLST
     C                   MOVEL     CLAS          A_CLAS
     C                   EXCEPT    DEAMSDIO
     C     DLNO          READE     DEAMSDIF                               99
     C                   ENDDO

      * Synchronize MMDEAMPP

     C     DLNO          SETLL     MMDEAMP0
     C     DLNO          READE     MMDEAMP0                               99
     C     *IN99         DOWEQ     *OFF
     C                   MOVEL     DLST          HNOMDT
     C                   MOVEL     CLAS          HNCLAS
     C                   EXCEPT    MMDEAMPPO
     C     DLNO          READE     MMDEAMP0                               99
     C                   ENDDO
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     FOREX_DEAL    BEGSR

     C     PUCY          COMP      BJCYCD                                 65
     C     SLCY          COMP      BJCYCD                                 66

      * Purchase currency deal date a/c key

     C                   MOVE      *BLANK        AKY
     C                   MOVE      'D'           AKY(3)
     C                   MOVEA     DealSubType   AKY(4)
     C   65              MOVE      'B'           AKY(9)
     C  N65              MOVE      'F'           AKY(9)
     C                   MOVE      'B'           AKY(10)
     C                   MOVEA     DealClass     AKY(11)
     C                   Z-ADD     PUAM          EventAmount      13 0
     C                   MOVE      PUCY          EventCurrency     3
     C                   Z-ADD     SLAM          OtherAmount      13 0
     C                   MOVE      SLCY          OtherCurrency     3
     C                   EXSR      WRITE_KEY

      * Sale currency deal date a/c key

     C                   MOVE      *BLANK        AKY
     C                   MOVE      'D'           AKY(3)
     C                   MOVEA     DealSubType   AKY(4)
     C   66              MOVE      'B'           AKY(9)
     C  N66              MOVE      'F'           AKY(9)
     C                   MOVE      'C'           AKY(10)
     C                   MOVEA     DealClass     AKY(11)
     C                   Z-ADD     SLAM          EventAmount
     C                   MOVE      SLCY          EventCurrency
     C                   Z-ADD     PUAM          OtherAmount
     C                   MOVE      PUCY          OtherCurrency
     C                   EXSR      WRITE_KEY

      * Unaccrued swap profit/loss deal date a/c key (on 2nd leg swap deal)

     C     DTYP          IFEQ      'SW'
     C     FSLI          ANDEQ     2

     C     SPLA          SUB       SPPD          EventAmount          6768
     C   68              Z-SUB     EventAmount   EventAmount
     C                   MOVE      *BLANK        AKY
     C                   MOVE      'D'           AKY(3)
     C                   MOVEA     DealSubType   AKY(4)
     C   67              MOVE      'H'           AKY(10)
     C   68              MOVE      'L'           AKY(10)
     C                   MOVEA     DealClass     AKY(11)
     C                   MOVE      SPLC          EventCurrency
     C                   Z-ADD     0             OtherAmount
     C                   MOVE      *BLANK        OtherCurrency
     C                   EXSR      WRITE_KEY

     C                   ENDIF

     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     LOANDEP_DEAL  BEGSR

      * Deal date Principal a/c key

     C                   MOVE      *BLANK        AKY
     C                   MOVE      'D'           AKY(3)
     C                   MOVEA     DealSubType   AKY(4)
     C                   MOVE      'A'           AKY(10)
     C                   MOVEA     DealClass     AKY(11)
     C                   Z-ADD     PCPL          EventAmount
     C                   MOVE      CCY           EventCurrency
     C                   Z-ADD     0             OtherAmount
     C                   MOVE      *BLANK        OtherCurrency
     C                   EXSR      WRITE_KEY

     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     LOANDEP_TRANS BEGSR

      * Transfer principal a/c key

     C                   MOVE      *BLANK        AKY
     C                   MOVE      'T'           AKY(3)
     C                   MOVEA     DealSubType   AKY(4)
     C                   MOVE      'A'           AKY(10)
     C                   MOVEA     DealClass     AKY(11)
     C                   Z-ADD     PCPL          EventAmount
     C                   MOVE      CCY           EventCurrency
     C                   Z-ADD     0             OtherAmount
     C                   MOVE      *BLANK        OtherCurrency
     C                   EXSR      WRITE_KEY

      * Transfer unaccrued interest a/c key

     C                   MOVE      *BLANK        AKY
     C                   MOVE      'T'           AKY(3)
     C                   MOVEA     DealSubType   AKY(4)
     C                   MOVE      'I'           AKY(10)
     C                   MOVEA     DealClass     AKY(11)
     C     AIPD          SUB       IPRD          EventAmount
     C                   SUB       ICTD          EventAmount
     C                   MOVE      CCY           EventCurrency
     C                   Z-ADD     0             OtherAmount
     C                   MOVE      *BLANK        OtherCurrency
     C                   EXSR      WRITE_KEY

     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     NAPURCH_DEAL  BEGSR

      * Deal date face value a/c key

     C                   MOVE      *BLANK        AKY
     C                   MOVE      'D'           AKY(3)
     C                   MOVEA     DealSubType   AKY(4)
     C                   MOVE      'F'           AKY(10)
     C                   MOVEA     DealClass     AKY(11)
     C                   Z-ADD     FVAL          EventAmount
     C                   MOVE      CCY           EventCurrency
     C                   Z-ADD     0             OtherAmount
     C                   MOVE      *BLANK        OtherCurrency
     C                   EXSR      WRITE_KEY

      * Deal date Purchase price a/c key

     C     DTYP          IFNE      'C1'
     C                   MOVE      *BLANK        AKY
     C                   MOVE      'D'           AKY(3)
     C                   MOVEA     DealSubType   AKY(4)
     C                   MOVE      'A'           AKY(10)
     C                   MOVEA     DealClass     AKY(11)
     C                   Z-ADD     PUPR          EventAmount
     C                   MOVE      CCY           EventCurrency
     C                   Z-ADD     0             OtherAmount
     C                   MOVE      *BLANK        OtherCurrency
     C                   EXSR      WRITE_KEY
     C                   ENDIF

     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     NAPURCH_TRANS BEGSR

      * Transfer face value a/c key

     C                   MOVE      *BLANK        AKY
     C                   MOVE      'T'           AKY(3)
     C                   MOVEA     DealSubType   AKY(4)
     C                   MOVE      'F'           AKY(10)
     C                   MOVEA     DealClass     AKY(11)
     C                   Z-ADD     FVAL          EventAmount
     C                   MOVE      CCY           EventCurrency
     C                   Z-ADD     0             OtherAmount
     C                   MOVE      *BLANK        OtherCurrency
     C                   EXSR      WRITE_KEY

      * Transfer unaccrued discount/premium a/c key

     C     DISA          SUB       DPTD          EventAmount            53
     C   53              Z-SUB     EventAmount   EventAmount
     C                   MOVE      *BLANK        AKY
     C                   MOVE      'T'           AKY(3)
     C                   MOVEA     DealSubType   AKY(4)
     C  N53              MOVE      'D'           AKY(10)
     C   53              MOVE      'C'           AKY(10)
     C                   MOVEA     DealClass     AKY(11)
     C                   MOVE      CCY           EventCurrency
     C                   Z-ADD     0             OtherAmount
     C                   MOVE      *BLANK        OtherCurrency
     C                   EXSR      WRITE_KEY

      * Transfer unaccrued interest a/c key

     C                   MOVE      *BLANK        AKY
     C                   MOVE      'T'           AKY(3)
     C                   MOVEA     DealSubType   AKY(4)
     C                   MOVE      'I'           AKY(10)
     C                   MOVEA     DealClass     AKY(11)
     C     AIPD          SUB       IPRD          EventAmount
     C                   MOVE      CCY           EventCurrency
     C                   Z-ADD     0             OtherAmount
     C                   MOVE      *BLANK        OtherCurrency
     C                   EXSR      WRITE_KEY

     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     NASOLD_DEAL   BEGSR

      * Deal date sale price a/c key

     C                   MOVE      *BLANK        AKY
     C                   MOVE      'D'           AKY(3)
     C                   MOVEA     DealSubType   AKY(4)
     C                   MOVE      'A'           AKY(10)
     C                   MOVEA     DealClass     AKY(11)
     C                   Z-ADD     SAPR          EventAmount
     C                   MOVE      CCY           EventCurrency
     C                   Z-ADD     0             OtherAmount
     C                   MOVE      *BLANK        OtherCurrency
     C                   EXSR      WRITE_KEY

     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     FRAS          BEGSR

      * If deal date accounting has been done,
      * but value date accounting has NOT been done, generate FRA deal date a/c keys
      * (FRAS balances run from deal date to value date)

     C                   TESTB     '0'           ACEI                     98
     C                   TESTB     '1'           ACEI                     99
     C   98
     CANN99              DO
     C                   MOVEL     O_DLST        DealSubType
     C                   MOVEL     O_CLAS        DealClass
     C                   Z-ADD     1             ReversalInd
     C                   EXSR      FRAS_DEAL
     C                   MOVEL     DLST          DealSubType
     C                   MOVEL     CLAS          DealClass
     C                   Z-ADD     0             ReversalInd
     C                   EXSR      FRAS_DEAL
     C                   ENDDO

      * If this is a hedged FRA and FRA accruals are done
      * If value date accounting has been done, generate FRA transfer a/c keys

     C     HEDIN         IFEQ      'Y'
     C     BQHFRA        ANDEQ     'Y'
     C                   TESTB     '1'           ACEI                     99
     C   99              DO
     C                   MOVEL     O_DLST        DealSubType
     C                   MOVEL     O_CLAS        DealClass
     C                   Z-ADD     1             ReversalInd
     C                   EXSR      FRAS_TRANS
     C                   MOVEL     DLST          DealSubType
     C                   MOVEL     CLAS          DealClass
     C                   Z-ADD     0             ReversalInd
     C                   EXSR      FRAS_TRANS
     C                   ENDDO
     C                   ENDIF
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     FRAS_DEAL     BEGSR

      * Deal date FRA notional principal a/c key

     C                   MOVE      *BLANK        AKY
     C                   MOVE      'D'           AKY(3)
     C                   MOVEA     DealSubType   AKY(4)
     C                   MOVE      'A'           AKY(10)
     C                   MOVEA     DealClass     AKY(11)
     C                   Z-ADD     UPAMT         EventAmount
     C                   MOVE      UCUCY         EventCurrency
     C                   Z-ADD     0             OtherAmount
     C                   MOVE      *BLANK        OtherCurrency
     C                   EXSR      WRITE_KEY

      * Deal date FRA exposure a/c key

     C                   MOVE      *BLANK        AKY
     C                   MOVE      'D'           AKY(3)
     C                   MOVEA     DealSubType   AKY(4)
     C                   MOVE      'E'           AKY(10)
     C                   MOVEA     DealClass     AKY(11)
     C                   Z-ADD     UAEXA         EventAmount
     C                   MOVE      UCUCY         EventCurrency
     C                   Z-ADD     0             OtherAmount
     C                   MOVE      *BLANK        OtherCurrency
     C                   EXSR      WRITE_KEY

     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     FRAS_TRANS    BEGSR

      ** Check Percentage of Ineffective/Effective Linkages present

     C     CAS006        IFEQ      'Y'
     C                   MOVE      'N'           WHDGFL
     C                   Z-ADD     *ZEROS        WEFPTG
     C                   MOVEL     DLNO          DLNOA                                        CLE148
     C     KHDGKY        SETLL     ASHTRNLA
     C     KHDGKY        READE     ASHTRNLA                               98
     C     *IN98         DOWEQ     '0'
     C     FSHTID        IFEQ      'D'
     C     FSHEDI        CHAIN     ASHGLKL1                           99
     C     *IN99         IFEQ      '0'
     C     FSRECI        ANDEQ     'D'
     C                   MOVE      'Y'           WHDGFL            1
     C                   ADD       FSPCTG        WEFPTG            6 2
     C                   ENDIF
     C                   ENDIF
     C     KHDGKY        READE     ASHTRNLA                               98
     C                   ENDDO
     C                   DIV       100           WEFPTG
     C                   ENDIF


      ** If CAS006 is on only generate a key if the hedge linkages are effective

     C     CAS006        IFEQ      'N'
     C     CAS006        OREQ      'Y'
     C     WHDGFL        ANDEQ     'Y'

      * Transfer FRA unaccrued settlement amount a/c key

     C                   MOVE      *BLANK        AKY
     C                   MOVE      'T'           AKY(3)
     C                   MOVEA     DealSubType   AKY(4)
     C     UIPRD         IFNE      0
     C                   MOVE      'P'           AKY(9)
     C                   END
     C     TIPRD         IFNE      0
     C                   MOVE      'R'           AKY(9)
     C                   END
     C                   MOVE      'I'           AKY(10)
     C                   MOVEA     DealClass     AKY(11)
     C                   MOVE      UCUCY         EventCurrency
     C                   Z-ADD     *ZERO         EventAmount
     C     AKY(9)        IFEQ      'P'
     C     UIPRD         SUB       UAIPD         EventAmount
     C                   END
     C     AKY(9)        IFEQ      'R'
     C     TIPRD         SUB       TAIPD         EventAmount
     C                   END

      ** When CAS006 is on output the effectively hedged percentage

     C     CAS006        IFEQ      'Y'
     C                   MULT      WEFPTG        EventAmount
     C                   ENDIF
     C                   Z-ADD     0             OtherAmount
     C                   MOVE      *BLANK        OtherCurrency
     C                   EXSR      WRITE_KEY
     C                   ENDIF

     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     OTHERDERIVS   BEGSR

      * If deal date accounting has been done,
      *    generate deal date a/c keys
      *   (derivative balances run from deal date to maturity date)

     C                   TESTB     '0'           ACEI                     98
     C   98              DO
     C                   MOVEL     O_DLST        DealSubType
     C                   MOVEL     O_CLAS        DealClass
     C                   Z-ADD     1             ReversalInd
     C                   EXSR      DERIVS_DEAL
     C                   MOVEL     DLST          DealSubType
     C                   MOVEL     CLAS          DealClass
     C                   Z-ADD     0             ReversalInd
     C                   EXSR      DERIVS_DEAL
     C                   ENDDO

      * If value date accounting has been done, generate transfer a/c keys

     C                   TESTB     '1'           ACEI                     99
     C   99              DO
     C                   MOVEL     O_DLST        DealSubType
     C                   MOVEL     O_CLAS        DealClass
     C                   Z-ADD     1             ReversalInd
     C                   EXSR      DERIVS_TRANS
     C                   MOVEL     DLST          DealSubType
     C                   MOVEL     CLAS          DealClass
     C                   Z-ADD     0             ReversalInd
     C                   EXSR      DERIVS_TRANS
     C                   ENDDO
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     DERIVS_DEAL   BEGSR

      * Deal date notional principal a/c key (NOT 'RX')

     C     DTYP          IFNE      'RX'
     C                   MOVE      *BLANK        AKY
     C                   MOVE      'D'           AKY(3)
     C                   MOVEA     DealSubType   AKY(4)
     C                   MOVE      'A'           AKY(10)
     C                   MOVEA     DealClass     AKY(11)
     C                   Z-ADD     UPAMT         EventAmount
     C                   MOVE      UCUCY         EventCurrency
     C                   Z-ADD     0             OtherAmount
     C                   MOVE      *BLANK        OtherCurrency
     C                   EXSR      WRITE_KEY
     C                   ENDIF

      * Deal date exposure a/c key  (NOT 'RX')

     C     DTYP          IFNE      'RX'
     C                   MOVE      *BLANK        AKY
     C                   MOVE      'D'           AKY(3)
     C                   MOVEA     DealSubType   AKY(4)
     C                   MOVE      'E'           AKY(10)
     C                   MOVEA     DealClass     AKY(11)
     C                   Z-ADD     UAEXA         EventAmount
     C                   MOVE      UCUCY         EventCurrency
     C                   Z-ADD     0             OtherAmount
     C                   MOVE      *BLANK        OtherCurrency
     C                   EXSR      WRITE_KEY
     C                   ENDIF

      * Deal date notional principal a/c key ('RX')

     C     DTYP          IFEQ      'RX'
     C                   MOVE      *BLANK        AKY
     C                   MOVE      'D'           AKY(3)
     C                   MOVEA     DealSubType   AKY(4)
     C                   MOVE      'O'           AKY(9)
     C                   MOVE      'A'           AKY(10)
     C                   MOVEA     DealClass     AKY(11)
     C                   Z-ADD     UPAMT         EventAmount
     C                   MOVE      UCUCY         EventCurrency
     C                   Z-ADD     0             OtherAmount
     C                   MOVE      *BLANK        OtherCurrency
     C                   EXSR      WRITE_KEY
     C                   MOVE      'T'           AKY(9)
     C                   Z-ADD     TPAMT         EventAmount
     C                   MOVE      TCUCY         EventCurrency
     C                   EXSR      WRITE_KEY
     C                   ENDIF

      * Deal date exposure a/c key  ('RX')

     C     DTYP          IFEQ      'RX'
     C                   MOVE      *BLANK        AKY
     C                   MOVE      'D'           AKY(3)
     C                   MOVEA     DealSubType   AKY(4)
     C                   MOVE      'O'           AKY(9)
     C                   MOVE      'E'           AKY(10)
     C                   MOVEA     DealClass     AKY(11)
     C                   Z-ADD     UAEXA         EventAmount
     C                   MOVE      UCUCY         EventCurrency
     C                   Z-ADD     0             OtherAmount
     C                   MOVE      *BLANK        OtherCurrency
     C                   EXSR      WRITE_KEY
     C                   MOVE      'T'           AKY(9)
     C                   Z-ADD     TAEXA         EventAmount
     C                   MOVE      TCUCY         EventCurrency
     C                   EXSR      WRITE_KEY
     C                   ENDIF

      * If value date accounting has NOT been done, generate fee key

     C                   TESTB     '1'           ACEI                     99
     C  N99              DO
     C                   MOVE      *BLANK        AKY
     C                   MOVE      'D'           AKY(3)
     C                   MOVEA     DealSubType   AKY(4)
     C                   MOVEA     UPPR          AKY(9)
     C                   MOVE      'F'           AKY(10)
     C                   MOVEA     DealClass     AKY(11)
     C                   Z-ADD     UPFE          EventAmount
     C     AKY(9)        IFEQ      'P'
     C                   MOVEL     UCUCY         EventCurrency
     C                   END
     C     AKY(9)        IFEQ      'R'
     C                   MOVEL     TCUCY         EventCurrency
     C                   END
     C                   Z-ADD     0             OtherAmount
     C                   MOVE      *BLANK        OtherCurrency
     C                   EXSR      WRITE_KEY
     C                   ENDDO

      * If buy-out date accounting has NOT been done, generate buy-out key

     C                   TESTB     '4'           ACEI                     99
     C  N99              DO
     C                   MOVE      *BLANK        AKY
     C                   MOVE      'D'           AKY(3)
     C                   MOVEA     DealSubType   AKY(4)
     C                   MOVEA     BAPR          AKY(9)
     C                   MOVE      'B'           AKY(10)
     C                   MOVEA     DealClass     AKY(11)
     C                   Z-ADD     BOAM          EventAmount
     C     AKY(9)        IFEQ      'P'
     C                   MOVEL     UCUCY         EventCurrency
     C                   END
     C     AKY(9)        IFEQ      'R'
     C                   MOVEL     TCUCY         EventCurrency
     C                   END
     C                   Z-ADD     0             OtherAmount
     C                   MOVE      *BLANK        OtherCurrency
     C                   EXSR      WRITE_KEY
     C                   ENDDO

     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     DERIVS_TRANS  BEGSR

      * Transfer our unaccrued interest a/c key

     C                   MOVE      *BLANK        AKY
     C                   MOVE      'T'           AKY(3)
     C                   MOVEA     DealSubType   AKY(4)
     C                   MOVE      'P'           AKY(9)
     C                   MOVE      'I'           AKY(10)
     C                   MOVEA     DealClass     AKY(11)
     C     UAIPD         SUB       UIPRD         EventAmount
     C                   MOVE      UCUCY         EventCurrency
     C                   Z-ADD     0             OtherAmount
     C                   MOVE      *BLANK        OtherCurrency
     C                   EXSR      WRITE_KEY

      * Transfer their unaccrued interest a/c key

     C                   MOVE      *BLANK        AKY
     C                   MOVE      'T'           AKY(3)
     C                   MOVEA     DealSubType   AKY(4)
     C                   MOVE      'R'           AKY(9)
     C                   MOVE      'I'           AKY(10)
     C                   MOVEA     DealClass     AKY(11)
     C     TAIPD         SUB       TIPRD         EventAmount
     C                   MOVE      TCUCY         EventCurrency
     C                   Z-ADD     0             OtherAmount
     C                   MOVE      *BLANK        OtherCurrency
     C                   EXSR      WRITE_KEY

      * Transfer unaccrued fee a/c key

     C                   MOVE      *BLANK        AKY
     C                   MOVE      'T'           AKY(3)
     C                   MOVEA     DealSubType   AKY(4)
     C                   MOVE      UPPR          AKY(9)
     C                   MOVE      'F'           AKY(10)
     C                   MOVEA     DealClass     AKY(11)
     C     UPFE          SUB       UPAD          EventAmount
     C     AKY(9)        IFEQ      'P'
     C                   MOVEL     UCUCY         EventCurrency
     C                   END
     C     AKY(9)        IFEQ      'R'
     C                   MOVEL     TCUCY         EventCurrency
     C                   END
     C                   Z-ADD     0             OtherAmount
     C                   MOVE      *BLANK        OtherCurrency
     C                   EXSR      WRITE_KEY

     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     WRITE_KEY     BEGSR

     C     *INU1         CABEQ     *OFF          NO_KEY
     C     EventAmount   CABEQ     0             NO_KEY

     C                   CLEAR                   DKEYS
     C                   MOVEL     'D'           K_RECI
     C                   MOVEA     AKY           K_AKEY
     C                   MOVEL     DTYP          K_AKEY
     C                   MOVEL     K_AKEY        K_QQAKEY
     C                   Z-ADD     DLNO          K_DLNO
     C**********         Z-ADD     CNUM          K_CNUM                                      CSD027A
     C                   MOVE      CNUM          K_CNUM                                      CSD027A
     C                   MOVEL     BRCA          K_BRCA
     C   02              MOVEL     CDAS          K_ACSQ
     C   03              MOVEL     IDAS          K_ACSQ
     C     K_ACSQ        IFEQ      *ZERO
     C                   Z-ADD     1             K_ACSQ
     C                   ENDIF
     C                   Z-ADD     BJRDNB        K_EDAT
     C                   Z-ADD     EventAmount   K_EAMT
     C                   MOVEL     EventCurrency K_ECCY
     C                   Z-ADD     ReversalInd   K_REVI
     C                   Z-ADD     OtherAmount   K_OTHA
     C                   MOVEL     OtherCurrency K_OTHC
     C   01              Z-ADD     EXRT          K_EXRT
     C***02              Z-ADD     BRTT          K_BRTT                                       CSD103
     C   02              MOVEL     BRTT          K_BRTT                                       CSD103
     C   02              Z-ADD     BRTE          K_BRTE
     C   02              Z-ADD     RTSP          K_RTSP
     C   02              Z-ADD     INTR          K_INTR
     C                   Z-ADD     VDAT          K_VDAT
     C  N01              Z-ADD     MDAT          K_MDAT
     C                   Z-ADD     BJRDNB        K_FFVD
     C                   MOVEL     PRFC          K_PRFC
     C                   MOVEL     BOKC          K_BOKC
     C                   EVAL      Key_DLST = %SubST(K_AKEY:4:2)
     C                   EVAL      Key_CLAS = %SubST(K_AKEY:11:4)

      * Current or New

     C     Key_DLST      IFEQ      O_DLST
     C     Key_CLAS      ANDEQ     O_CLAS
     C                   MOVEL     'C'           K_ZZ002
     C                   ELSE
     C                   MOVEL     'N'           K_ZZ002
     C                   ENDIF

     C                   WRITE     DKEYSDPF
     C     NO_KEY        ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     CHK_STCL      BEGSR

      * Check if sub-type or class have changed

     C                   MOVEL     'N'           STCL_Changed      1

     C     DLNO          CHAIN     DLSTCLD0                           99
     C     *IN99         IFEQ      *OFF
     C     DLST          IFNE      O_DLST
     C     CLAS          ORNE      O_CLAS
     C                   MOVEL     'Y'           STCL_Changed
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     *PSSR         BEGSR
     C     P#RUN         IFNE      'Y'
     C                   MOVEL     'Y'           P#RUN             1
     C                   SETON                                        LRU7U8
     C                   DUMP
     C                   ENDIF
     C                   RETURN
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     *INZSR        BEGSR
     C     *ENTRY        PLIST
     C                   PARM                    P_FILE            1

      * Access Bank details

     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY

      * Access FRA/IRS details

     C                   CALL      'AOFAISR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST  '    POPTN
     C     SDFAIS        PARM      SDFAIS        DSFDY

      ** Access AOSARDR0 and check if CAS006 is installed

     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CAS006'      PSARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CAS006            1
     C                   ELSE
     C                   MOVE      'N'           CAS006
     C                   ENDIF

     C                   MOVE      'DL'          ModuleID
     C                   MOVE      *BLANK        KEY_DLST          2
     C                   MOVE      *BLANK        KEY_CLAS          4

      * Key lists

     C     KHDGKY        KLIST
     C                   KFLD                    ModuleID          2
     C**********         KFLD                    DLNO                                         CLE148
     C                   KFLD                    DLNOA             6                          CLE148
     C                   ENDSR
      ********************************************************************
     ODEAMSDIF  E            DEAMSDIO
     O                       A_DLST
     O                       A_CLAS
     OMMDEAMP0  E            MMDEAMPPO
     O                       HNOMDT
     O                       HNCLAS
