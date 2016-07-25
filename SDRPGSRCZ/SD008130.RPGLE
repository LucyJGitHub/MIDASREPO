     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Stamp Tax Rate Changes')                      *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data                                        *
      *                                                               *
      *  SD008130 - Stamp Tax update after change of Tax rate         *
      *                                                               *
      *           This function checks whether a Tax rate change has  *
      *           occurred today, if this is the case all outstanding *
      *           Flat Tax amounts will be recalculated to reflect    *
      *           the change.                                         *
      *                                                               *
      *  (c) Copyright Misys International Banking Systems Ltd 2010   *
      *                                                               *
      *  Called From: SDC008150                                       *
      *                                                               *
      *  Last Amend No. MD038025           Date 27Jul16               *
      *  Prev Amend No. AR1084524          Date 13Feb13               *
      *                 CLE148             Date 23Jul12               *
      *                 AR873924A          Date 08Feb12               *
      *                 AR888911           Date 26Jan12               *
      *                 AR864714B          Date 28Mar12               *
      *                 AR884152A          Date 26Jan12               *
      *                 AR884152           Date 16Jan12               *
      *                 AR879983           Date 21Dec11               *
      *                 AR875365           Date 07Dec11               *
      *                 AR873924           Date 01Dec11               *
      *                 CLE147             Date 30Sep11               *
      *                 AR853257           Date 04Nov11               *
      *                 CER049  *CREATE    Date 06Dec10               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD038025 - Review AR875365 to only default ST rate if        *
      *             'number of month' is not zero.                    *
      *  AR1084524 - Performance issue on IPAY & OPAY listview        *
      *              (Recompile)                                      *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  AR873924A - Module id must be written in the report (Reopen) *
      *  AR888911 - In reversing a deal, REV column in Stamp Tax      *
      *             Movements Enquiry is not changing from N to Y     *
      *             (Recompile)                                       *
      *           - Applied for AR944923                              *
      *  AR864714B - No movement is posted in Stamp Tax Movement      *
      *              enquiry for Position Settlements                 *
      *            - Applied for AR942839                             *
      *  AR884152A - New stamp tax rate did not take effect (Reopen)  *
      *  AR884152 - New stamp tax rate did not take effect            *
      *  AR879983 - Add stamp tax exchange rate (Recompile)           *
      *  AR875365 - Stamp tax rate change applied on some transaction *
      *             is incorrect                                      *
      *  AR873924 - Module id must be written in the report           *
      *  CLE147 - Aggregate Facility (Recompile)                      *
      *  AR853257 - Account Keys for FT were not generated            *
      *             (Recompile)                                       *
      *  CER049 - Stamp Tax                                           *
      *                                                               *
      *****************************************************************
      *
      * Stamp Tax Control file
     FSDSTPTL1  IF   E           K DISK
     F*
     FSDSTPDL1  IF   E           K DISK
     F*
      ** Stamp Tax Historic/Details file
     FSDSTMDL1  IP   E           K DISK
     FSDSTMDL0  UF   E           K DISK
      *
      ** Stamp Tax Summary Files
     FDLDLDCL3  UF   E           K DISK
     FCLONCLL1  UF   E           K DISK
     FLEFCLTLH  UF   E           K DISK
     FLEFEEQL1  UF   E           K DISK
     FTRADSQL0  UF   E           K DISK
     FINPAYQL0  UF   E           K DISK
     FOTPAYQL0  UF   E           K DISK
     FCQCOCQL0  UF   E           K DISK
     FCQPACQL0  UF   E           K DISK
     FPOSETDYL  UF   E           K DISK
     FTRADS     UF   E           K DISK                                                     AR875365
     FCQCOD     IF   E           K DISK    PREFIX(CQ)                                      AR873924A
     F                                     IGNORE(CQCODDDF)                                AR873924A
     FCQPAC     IF   E           K DISK    PREFIX(CP)                                      AR873924A
     F                                     IGNORE(CQPACDDF)                                AR873924A
      *
      ** Report
     FSD008130AUO    E             PRINTER INFDS(SPOOLA) USROPN
     FSD008130P1O    E             PRINTER INFDS(SPOOL1)
      **
      *****************************************************************
      * ID F  C  H  L    FUNCTION OF INDICATORS
      *
      * 40            Read Ind
      * 41            Read Ind
      * 42            Chain Stamp Tax summary file
      * 75            Work Ind
      * 90-99         Standard Routines
      *
      *****************************************************************
     D/COPY ZSRSRC,ZDATE9Z1LE
     D/COPY ZSRSRC,ZSEDITZ1LE
     D/COPY ZSRSRC,ZDATE2Z1LE
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
      *
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** External DS for General Ledger Details
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External DS for Midas Currency Details
      *
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** External DS for branch name details
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** SAR File Details Accessed via Access Program AOSARDR0
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Fisrt DS for Access Programs, Short data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for Access Programs, Long data structure
      *
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Retail a/c nr
     D @POSET          DS
     D  @RPBRC                 1      3
     D  @RPSSH                 4     13
     D  @RPCPT                14     19
     D  @RPDUD                20     25  0
     D  @RPEVT                26     27  0
      *
     D SPOOL1          DS
      *
      ** DS FOR P1 SPOOL FILE NAME
      *
     D  SFILE1                83     92
     D  SFNUM                123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
      *
     D SPOOLA          DS
      *
      ** DS FOR AU SPOOL FILE NAME
      *
     D  SFILEA                83     92
     D  SFNUMA               123    124B 0
     D  OFLLNA               188    189B 0
     D  PRTLNA               367    368B 0
      *
     D                 DS
     D  WORK15                 1     15  0
      *
      ** Parameter fields
      *
     D  @RTCD          S              7
     D  @OPTN          S              7
     D  @SARD          S              6
     D  CCY            S              3
     D  SEQNO          S              5
     D  ENTY           S              3
     D  ZSNUM          S              6  0
     D  ZSERR          S              1
      *
      ** Work fields
      *
     D  T#DEAL         S              6
     D  T#FACA         S              3
     D  T#FCNA         S              2
     D  @T2FCL         S              5  0
     D  @KEYR1         S             13
     D  @KEYR4         S             16
     D  @KEYR6         S              6
     D  @GROSS         S             30  9
     D  BIS@           S             40
     D  @@DAYN         S              5  0
     D  @ACTDT         S              8  0
     D  ZZAPDT         S              5  0
     D  ZZDNWD         S              5  0
     D  CER049         S              1
     D  WRUN           S              1
     D  ZZAMT          S             15  3
     D  ZZAMTI         S             15  0
     D  ZZAMTD         S              3  0
     D  ZZTOTI         S             15  0
     D  ZZTOTD         S              3  0
     D  ZZWK2          S              4  0
     D  ZZWK3          S             15  0
     D  ZZNEGD         S              5
     I*
     I/COPY ZSRSRC,ZDATE9Z2LE
      *****************************************************************
      * MAIN
      *****************************************************************
      *
      ** Read all Flat Tax records with the same control key
      ** Tax Indicators selected:
      ** - Flat Tax
      ** - Charge Tax
      *
     C     T2STFC        IFEQ      'Y'
     C     T2STFF        OREQ      'Y'
      *
      ** Tax Actions selected:
      ** - Tax only calculated and not posted
      *
     C     T2TPAY        IFNE      'Y'
     C     T2TCAL        ANDEQ     'Y'
      *
      ** Tax Record Type selected:
      ** - Control Date = 0 (where Flat/Charge tax is stored)
      *
     C     T2CDTE        IFEQ      0
      *
     C                   CLEAR                   A3BRCA
     C                   CLEAR                   A3CUST
     C                   CLEAR                   A3CTRY
     C                   CLEAR                   A3ACCD
     C                   CLEAR                   A3DTYP
     C                   CLEAR                   A3DSTP
     C                   CLEAR                   A3LTYP
     C                   CLEAR                   A3LSTP
     C                   CLEAR                   A3LSTP
     C                   CLEAR                   A3FTYP
     C                   CLEAR                   A3LFTP
      *
     C                   MOVE      T2KEY         @T2KEY
     C                   MOVE      T2BRCA        @BRCA                                      AR873924
     C                   MOVE      T2ECCY        @CCY                                       AR873924
      *
      ** Access relevant Stamp Tax summary file
      *
     C     T2KEY         IFEQ      'DEAL'
     C                   MOVE      T2DLNO        T#DEAL
     C     T#DEAL        CHAIN     DLDLDCL3                           42
      *
      ** Check if rate changed today:
      ** ...access deal type/subtype
      *
     C                   MOVE      F1DTYP        @3DTYP                                     AR875365
     C                   MOVE      F1DSTP        @3DSTP                                     AR875365
     C                   MOVE      *BLANKS       @3LTYP                                     AR875365
     C                   MOVE      *BLANKS       @3LSTP                                     AR875365
     C                   MOVE      *BLANKS       @3FTYP                                     AR875365
     C                   MOVE      *BLANKS       @3LFTP                                     AR875365
     C                   MOVE      F1DTYP        A3DTYP
     C                   MOVE      F1DSTP        A3DSTP
     C  N42              MOVE      F1BRCA        @BRCA                                     AR873924A
     C                   END
      *
     C     T2KEY         IFEQ      'LOAN'
     C     T2LNRF        CHAIN     CLONCLL1                           42
      *
      ** Check if rate changed today:
      ** ...access deal type/subtype
      *
     C                   MOVE      LQLTYP        @3LTYP                                     AR875365
     C                   MOVE      LQLSTP        @3LSTP                                     AR875365
     C                   MOVE      *BLANKS       @3DTYP                                     AR875365
     C                   MOVE      *BLANKS       @3DSTP                                     AR875365
     C                   MOVE      *BLANKS       @3FTYP                                     AR875365
     C                   MOVE      *BLANKS       @3LFTP                                     AR875365
     C                   MOVE      LQLTYP        A3LTYP
     C                   MOVE      LQLSTP        A3LSTP
     C  N42              MOVE      LQBRCA        @BRCA                                     AR873924A
     C                   END
      *
     C     T2KEY         IFEQ      'FACILITY'
     C     KFCLT         KLIST
     C                   KFLD                    T2FCNM
     C                   KFLD                    T#FACA
     C                   KFLD                    T#FCNA
     C                   MOVE      T2FACT        T#FACA
     C                   MOVE      T2FCNO        T#FCNA
     C     KFCLT         CHAIN     LEFCLTLH                           42
     C                   MOVE      T2FACT        A3FTYP
     C  N42              MOVE      FCXBRC        @BRCA                                     AR873924A
     C                   END
      *
     C     T2KEY         IFEQ      'FEE'
     C     KFEE          KLIST
     C                   KFLD                    T2FCNM
     C                   KFLD                    @T2FCL
     C                   KFLD                    T2LNRF
     C                   KFLD                    T2FSEQ
     C                   KFLD                    T2ORED
     C                   MOVEL     T2FACT        @T2FCL
     C                   MOVE      T2FCNO        @T2FCL
     C     KFEE          CHAIN     LEFEEQL1                           42
     C                   MOVE      T2FSEQ        A3LFTP
     C  N42              MOVE      FQBRCA        @BRCA                                     AR873924A
     C                   END
      *
     C     T2KEY         IFEQ      'SECURITY'
     C     T2TDRF        CHAIN     TRADSQL0                           42
     C  N42              MOVE      TQTDBA        @BRCA                                     AR873924A
     C     T2TDRF        CHAIN     TRADS                              42                    AR875365
     C                   END
      *
     C     T2KEY         IFEQ      'IPAY'
     C     T2PREF        CHAIN     INPAYQL0                           42
     C  N42              MOVE      IPBRCA        @BRCA                                     AR873924A
     C                   END
      *
     C     T2KEY         IFEQ      'OPAY'
     C     T2PREF        CHAIN     OTPAYQL0                           42
     C  N42              MOVE      OTBRCA        @BRCA                                     AR873924A
     C                   END
      *
     C     T2KEY         IFEQ      'CHEQC'
     C     KCHQ          KLIST
     C                   KFLD                    T2PREF
     C                   KFLD                    T2CQSQ
     C     KCHQ          CHAIN     CQCOCQL0                           42
     C     KCHQ          CHAIN     CQCOD                              42                   AR873924A
     C  N42              MOVE      CQBRCA        @BRCA                                     AR873924A
     C                   END
      *
     C     T2KEY         IFEQ      'CHEQP'
     C     KCHQ          CHAIN     CQPACQL0                           42
     C     KCHQ          CHAIN     CQPAC                              42                   AR873924A
     C  N42              MOVE      CPBRCA        @BRCA                                     AR873924A
     C                   END
      *
     C     T2KEY         IFEQ      'POSSET'
     C     KPSET         KLIST
     C                   KFLD                    T2PBRC
     C                   KFLD                    T2PSSH
     C                   KFLD                    T2PCPY
     C                   KFLD                    T2PDUD
     C                   KFLD                    T2PEVT
     C     KPSET         CHAIN     POSETDYL                           42
     C  N42              MOVE      P3PBCA        @BRCA                                     AR873924A
     C                   END
      *
      ** clear fields
      *
     C                   CLEAR                   A3EDTE
     C                   CLEAR                   A3EDTN
     C                   CLEAR                   A3STRT
     C                   CLEAR                   A3SERT                                    AR884152A
     C                   CLEAR                   A1EDTE
     C                   CLEAR                   A1EDTN
     C                   CLEAR                   A1STRT
     C                   CLEAR                   A1SERT                                    AR884152A
      *
     C     STKEY3        CHAIN     SDSTPDL1                           40
      *
     C     *IN40         IFEQ      *ON
      *
      ** ...access single module first and Control record if module
      **    not found
      *
     C     T2KEY         CHAIN     SDSTPDL1                           40
      *
      ** if not found access CONTROL record
      *
     C     *IN40         IFEQ      *ON
     C                   MOVE      *BLANKS       A1KEY
     C                   MOVEL     'CONTROL'     A1KEY
     C     A1KEY         CHAIN     SDSTPTL1                           40
     C                   Z-ADD     A1EDTE        A3EDTE
     C                   Z-ADD     A1EDTN        A3EDTN
     C     T2KEY         IFEQ      'SECURITY'                                              AR864714B
     C     T2KEY         OREQ      'POSSET'                                                AR864714B
     C                   Z-ADD     A1SERT        A3STRT                                    AR864714B
     C                   ELSE                                                              AR864714B
     C                   Z-ADD     A1STRT        A3STRT
     C                   Z-ADD     A1SERT        A3SERT                                    AR884152A
     C                   ENDIF                                                             AR864714B
     C                   ELSE                                                               AR875365
     C     T2KEY         IFEQ      'SECURITY'                                              AR864714B
     C     T2KEY         OREQ      'POSSET'                                                AR864714B
     C                   Z-ADD     A3SERT        A3STRT                                    AR864714B
     C                   ENDIF                                                             AR864714B
     C                   EXSR      SRGETR                                                   AR875365
     C                   END
     C                   ELSE                                                               AR875365
     C     T2KEY         IFEQ      'SECURITY'                                              AR864714B
     C     T2KEY         OREQ      'POSSET'                                                AR864714B
     C                   Z-ADD     A3SERT        A3STRT                                    AR864714B
     C                   ENDIF                                                             AR864714B
     C                   EXSR      SRGETR                                                   AR875365
     C                   END
      *
      ** ..if rate changed today
      *
     C     *IN40         IFEQ      *OFF
     C*****A3EDTE        ANDGE     BJRDNB                                                   AR884152
     C     A3EDTE        ANDLE     BJRDNB                                                   AR884152
     C     A3EDTE        ANDLE     BKAPDT
      *
     C*****A3EDTN        ORGE      BJRDNB                                                   AR884152
     C     A3EDTN        ORLE      BJRDNB                                                   AR884152
     C     A3EDTN        ANDLE     BKAPDT
     C                   EXSR      STCHGR
     C                   END
      *
     C                   END
     C                   END
     C                   END
      *
     C     *INLR         IFEQ      *ON
     C                   RETURN
     C                   END
      *****************************************************************                     AR875365
      * SRGETR - Get Rate on Principal (Dealing and Lending)                                AR875365
      *                                                                                     AR875365
      * Called From: MAIN                                                                   AR875365
      *                                                                                     AR875365
      * Calls:                                                                              AR875365
      *****************************************************************                     AR875365
      *                                                                                     AR875365
     C     SRGETR        BEGSR                                                              AR875365
     C                   IF        A3KEY = 'LOAN' OR                                        AR875365
     C                             A3KEY = 'DEAL'                                           AR875365
     C                   SELECT                                                             AR875365
     C                   WHEN      T2MNTH < 12                                              AR875365
     C                             and T2MNTH > 0                                           MD038025
     C                   Z-ADD     A3F01Y        A3STRT                                     AR875365
     C                   WHEN      T2MNTH >= 12  AND T2MNTH <= 59                           AR875365
     C                   Z-ADD     A3F05Y        A3STRT                                     AR875365
     C                   WHEN      T2MNTH >= 60                                             AR875365
     C                   Z-ADD     A3F99Y        A3STRT                                     AR875365
     C                   ENDSL                                                              AR875365
     C                   ENDIF                                                              AR875365
     C                   ENDSR                                                              AR875365
      *                                                                                     AR875365
      *****************************************************************
      * STCHGR - Rate Change
      *
      * Called From: MAIN
      *
      * Calls:
      *****************************************************************
      *
     C     STCHGR        BEGSR
      *
      ** Update Only if both Tax amount and tax rate are not zero
      *
     C     T2TATC        IFNE      *ZEROS
     C     T2TXRT        ANDNE     *ZEROS
     C     A3STRT        ANDNE     *ZEROS                                                   AR875365
     C     T2TXRT        ANDNE     A3STRT                                                   AR875365
      *
      ** Retrieve original gross amount
      *
     C*****T2TATC        DIV       T2TXRT        @GROSS                                     AR875365
      *
      ** Calculate new tax applying the new rate
      *
     C*****@GROSS        MULT      A3STRT        @TAXE                                      AR875365
     C                   IF        T2TDRF = *BLANKS                                        AR884152A
     C     T2GROS        MULT      A3STRT        @TAXE                                      AR875365
     C                   IF        A3KEY = 'LOAN' AND                                       AR875365
     C                             (T2MNTH >= 1 AND T2MNTH < 12) OR                         AR875365
     C                             A3KEY = 'DEAL' AND                                       AR875365
     C                             (T2MNTH >= 1 AND T2MNTH < 12)                            AR875365
     C     @TAXE         MULT      T2MNTH        @TAXE                                      AR875365
     C                   ENDIF                                                              AR875365
     C                   ELSE                                                              AR884152A
     C     @GROSS        MULT      A3SERT        @TAXE                                     AR884152A
     C                   ENDIF                                                             AR884152A
      *
      ** Print record
      *
     C                   EXSR      STPRIN
      *
     C     STKEY2        CHAIN     SDSTMDL0                           66
     C                   Z-ADD     @TAXE         T2TATC
      *
      ** Update File
      *
     C                   IF        T2TDRF = *BLANKS                                        AR884152A
     C                   Z-ADD     A3STRT        T2TXRT
     C                   ELSE                                                              AR884152A
     C                   Z-ADD     A3SERT        T2TXRT                                    AR884152A
     C                   ENDIF                                                             AR884152A
     C                   Z-ADD     BJRDNB        T2LCD
     C                   MOVE      'A'           T2TYLC
     C  N66              EXCEPT    UPDREC
      *
      ** Update Summary Files
      *
     C     *IN42         IFEQ      *OFF
      *
      ** Deals
      *
     C     T2KEY         IFEQ      'DEAL'
      *
     C     F1PRIN        IFEQ      'Y'
     C                   Z-ADD     T2TATC        F1STAB
     C                   END
     C                   EXCEPT    UPDSDL
     C                   END
      *
      ** Loans
      *
     C     T2KEY         IFEQ      'LOAN'
      *
     C     LQPRIN        IFEQ      'Y'
     C                   Z-ADD     T2TATC        LQSTAB
     C                   END
     C                   EXCEPT    UPDSLN
     C                   END
      *
      ** Facilities
      *
     C     T2KEY         IFEQ      'FACILITY'
      *
     C     FCPRIN        IFEQ      'Y'
     C                   Z-ADD     T2TATC        FCSTAF
     C                   END
     C                   EXCEPT    UPDSFC
     C                   END
      *
      ** Fees
      *
     C     T2KEY         IFEQ      'FEE'
      *
     C     FQHFLF        IFEQ      'Y'
     C                   Z-ADD     T2TATC        FQSTAF
     C                   END
     C                   EXCEPT    UPDSFE
     C                   END
      *
      ** Trades
      *
     C     T2KEY         IFEQ      'SECURITY'
      *
     C     TQTAX         IFEQ      'Y'
     C                   Z-ADD     T2TATC        TQSTAF
     C                   Z-ADD     T2TATC        TCA7                                       AR875365
     C                   END
     C                   EXCEPT    UPDSTR
     C                   EXCEPT    UPDTRD                                                   AR875365
     C                   END
      *
      ** Incoming Payments
      *
     C     T2KEY         IFEQ      'IPAY'
      *
     C     IPTAX         IFEQ      'Y'
     C                   Z-ADD     T2TATC        IPSTAF
     C                   END
     C                   EXCEPT    UPDSIP
     C                   END
      *
      ** Outgoing Payments
      *
     C     T2KEY         IFEQ      'OPAY'
      *
     C     OTTAX         IFEQ      'Y'
     C                   Z-ADD     T2TATC        OTSTAF
     C                   END
     C                   EXCEPT    UPDSOP
     C                   END
      *
      ** Cheques for Collection
      *
     C     T2KEY         IFEQ      'CHEQC'
      *
     C     QCTAX         IFEQ      'Y'
     C                   Z-ADD     T2TATC        QCSTAF
     C                   END
     C                   EXCEPT    UPDSCC
     C                   END
      *
      ** Cheques to be Paid
      *
     C     T2KEY         IFEQ      'CHEQP'
      *
     C     QPTAX         IFEQ      'Y'
     C                   Z-ADD     T2TATC        QPSTAF
     C                   END
     C                   EXCEPT    UPDSCP
     C                   END
      *
      ** Position Settlements
      *
     C     T2KEY         IFEQ      'POSSET'
      *
     C     P3TAX         IFEQ      'Y'
     C                   Z-ADD     T2TATC        P3STAF
     C                   END
     C                   EXCEPT    UPDSPS
     C                   END
      *
     C                   END
      *
     C                   END
      *
     C                   ENDSR
      *
      *****************************************************************
      * STPRIN - Print details of the changes applied
      *
      * Called From: MAIN
      *
      * Calls:
      *****************************************************************
      *
     C     STPRIN        BEGSR
      *
     C**********         MOVE      A3KEY         @AKEY                                      AR873924
     C                   MOVE      T2KEY         @AKEY                                      AR873924
      *
      ** Set transaction reference
      *
     C                   MOVE      *BLANKS       @KEYRF
     C                   MOVE      *BLANKS       CCY
      *
     C                   SELECT
     C     T2KEY         WHENEQ    'LOAN'
     C                   MOVEL     T2LNRF        @KEYRF
      *
     C     T2KEY         WHENEQ    'DEAL'
     C                   MOVEL     T2DLNO        @KEYRF
      *
     C     T2KEY         WHENEQ    'SECURITY'
     C                   MOVEL     T2TDRF        @KEYRF
      *
     C     T2KEY         WHENEQ    'IPAY'
     C     T2KEY         OREQ      'OPAY'
     C                   MOVEL     T2PREF        @KEYRF
      *
     C     T2KEY         WHENEQ    'CHEQC'
     C     T2KEY         OREQ      'CHEQP'
     C                   MOVEL     T2PREF        @KEYRF
     C                   MOVE      T2CQSQ        @KEYRF
      *
     C     T2KEY         WHENEQ    'FEE'
     C                   MOVEL     T2LNRF        @KEYR1
     C                   MOVE      T2FCNM        @KEYR1
     C                   MOVEL     @KEYR1        @KEYR4
     C                   MOVE      T2FSEQ        @KEYR4
     C                   MOVEL     @KEYR4        @KEYRF
      *
     C     T2KEY         WHENEQ    'FACILITY'
     C                   MOVEL     T2FCNM        @KEYR1
     C                   MOVEL     T2FACT        @KEYR6
     C                   MOVE      T2FCNO        @KEYR6
     C                   MOVE      @KEYR6        @KEYR1
     C                   MOVEL     @KEYR1        @KEYRF
      *
     C     T2KEY         WHENEQ    'POSSET'
     C                   MOVE      T2PBRC        @RPBRC
     C                   MOVE      T2PSSH        @RPSSH
     C                   MOVE      T2PCPY        @RPCPT
     C                   Z-ADD     T2PDUD        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATE         @RPDUD
     C                   MOVE      T2PEVT        @RPEVT
     C                   MOVE      @POSET        @KEYRF
      *
     C                   ENDSL
      *
     C                   MOVE      T2ECCY        CCY
      *
      ** Edit amounts
      ** AOCCY  : Call to Access object AOCURRR0 for Currency Details.
      *
     C                   Z-ADD     0             A6NBDP
     C                   CALL      'AOCURRR0'
      *
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    CCY
      *
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C                   Z-ADD     @GROSS        ZFLD15
     C                   Z-ADD     0             ZDECS
     C                   MOVE      'J'           ZECODE
     C**********         EXSR      ZSEDIT                                                   AR875365
     C                   CALL      'ZSEDIT'                                                 AR875365
     C                   PARM                    ZFLD15                                     AR875365
     C                   PARM                    ZDECS                                      AR875365
     C                   PARM                    ZECODE                                     AR875365
     C                   PARM                    ZOUT21                                     AR875365
     C                   MOVE      ZOUT21        @GROSA
      *
     C                   Z-ADD     T2TATC        ZFLD15
     C                   Z-ADD     A6NBDP        ZDECS
     C                   MOVE      'J'           ZECODE
     C**********         EXSR      ZSEDIT                                                   AR875365
     C                   CALL      'ZSEDIT'                                                 AR875365
     C                   PARM                    ZFLD15                                     AR875365
     C                   PARM                    ZDECS                                      AR875365
     C                   PARM                    ZECODE                                     AR875365
     C                   PARM                    ZOUT21                                     AR875365
     C                   MOVE      ZOUT21        @TAXO
      *
     C                   Z-ADD     @TAXE         ZFLD15
     C                   Z-ADD     A6NBDP        ZDECS
     C                   MOVE      'J'           ZECODE
     C**********         EXSR      ZSEDIT                                                   AR875365
     C                   CALL      'ZSEDIT'                                                 AR875365
     C                   PARM                    ZFLD15                                     AR875365
     C                   PARM                    ZDECS                                      AR875365
     C                   PARM                    ZECODE                                     AR875365
     C                   PARM                    ZOUT21                                     AR875365
     C                   MOVE      ZOUT21        @TAXN
      *
      ** Write Report SD008130P1
      *
     C     PRTLN1        IFGE      59
     C                   WRITE     HEADP1
     C                   END
      *
     C                   WRITE     DETDP1
      *
     C                   ENDSR
      *
      *****************************************************************
      * *INZSR - Initial Process
      *
      * Called From: MAIN
      *
      * Calls:
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ** Define Fields for Keys
      *
     C                   MOVE      *ALL'-'       TRATT
      *
     C                   Z-ADD     *ZEROS        @GROSS
      *
     C     *LIKE         DEFINE    T2TATC        @TAXE
     C     *LIKE         DEFINE    T2KEY         @T2KEY
      *
     C     *LIKE         DEFINE    A3BRCA        @3BRCA
     C     *LIKE         DEFINE    A3CUST        @3CUST
     C     *LIKE         DEFINE    A3CTRY        @3CTRY
     C     *LIKE         DEFINE    A3ACCD        @3ACCD
     C     *LIKE         DEFINE    A3DTYP        @3DTYP
     C     *LIKE         DEFINE    A3DSTP        @3DSTP
     C     *LIKE         DEFINE    A3LTYP        @3LTYP
     C     *LIKE         DEFINE    A3LSTP        @3LSTP
     C     *LIKE         DEFINE    A3FTYP        @3FTYP
     C     *LIKE         DEFINE    A3LFTP        @3LFTP
      *
     C     *DTAARA       DEFINE                  LDA
     C                   MOVEA     CPY@          BIS@
     C                   MOVE      'SD008130'    DBPGM
      *
      ** Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     @OPTN         DBKEY
     C                   Z-ADD     1             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
      *
      ** Check System Date Format, DDMMYY OR MMDDYY.
      *
     C     BJDFIN        COMP      'M'                                    98
      *
     C                   END
      *
      ** Convert Run Date to ccyymmdd
      *
     C                   Z-ADD     BJRDNB        @@DAYN
     C                   EXSR      ZDATE9
     C                   MOVE      @@VDT         @ACTDT
      *
      ** Access General Ledger Details
      *
     C                   CALL      'AOGELRR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDGELR        PARM      SDGELR        DSFDY
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDGELRPD'    DBFILE
     C                   MOVEL     @OPTN         DBKEY
     C                   Z-ADD     2             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
      *
      ** Accrual Profit Date
      *
     C                   Z-ADD     BKAPDT        ZZAPDT
     C                   Z-ADD     BJDNWD        ZZDNWD
      *
      ** Check if CAR CER049 is switched *ON.
      *
     C                   MOVE      'N'           CER049
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CER049 '     @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CER049
     C                   END
      *
      ** If CAR is switched off, end program
      *
     C     CER049        IFEQ      'N'
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   END
      *
     C     STKEY2        KLIST
     C                   KFLD                    T2KEY
     C                   KFLD                    T2TYPE
     C                   KFLD                    T2LNRF
     C                   KFLD                    T2FCNM
     C                   KFLD                    T2FACT
     C                   KFLD                    T2FCNO
     C                   KFLD                    T2FSEQ
     C                   KFLD                    T2ORED
     C                   KFLD                    T2DLNO
     C                   KFLD                    T2TDRF
     C                   KFLD                    T2BRCA
     C                   KFLD                    T2CNUM
     C                   KFLD                    T2CCY
     C                   KFLD                    T2ACOD
     C                   KFLD                    T2ACSQ
     C                   KFLD                    T2PREF
     C                   KFLD                    T2CQSQ
     C                   KFLD                    T2PBRC
     C                   KFLD                    T2PSSH
     C                   KFLD                    T2PCPY
     C                   KFLD                    T2PDUD
     C                   KFLD                    T2PEVT
     C                   KFLD                    T2RCTP
     C                   KFLD                    T2CDTE
     C                   KFLD                    T2ASEQ
      *
     C     STKEY3        KLIST
     C                   KFLD                    @T2KEY
     C                   KFLD                    @3BRCA
     C                   KFLD                    @3CUST
     C                   KFLD                    @3CTRY
     C                   KFLD                    @3ACCD
     C                   KFLD                    @3DTYP
     C                   KFLD                    @3DSTP
     C                   KFLD                    @3LTYP
     C                   KFLD                    @3LSTP
     C                   KFLD                    @3FTYP
     C                   KFLD                    @3LFTP
      *
     C                   WRITE     HEADP1
      *
      ** Ensure the P1 spool file is recorded by RCF
      *
     C                   Z-ADD     SFNUM         ZSNUM
      *
      ** Call ZSFILE for SD008130P1
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    SEQNO
     C                   PARM      *BLANKS       ENTY
     C                   PARM                    SFILE1
     C                   PARM                    ZSNUM
     C                   PARM                    ZSERR
      *
      * If error in ZSFILE, exit via *PSSR
      *
     C     ZSERR         IFEQ      'Y'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *
     C/EJECT
      *****************************************************************
      * *PSSR  - Program exception processing.                        *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *  Called By: VARIOUS                                           *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
      ** Ensure dump is executed only once.
      *
     C     WRUN          IFEQ      *BLANK
     C                   MOVE      'Y'           WRUN
     C                   SETON                                        U7U8
     C                   DUMP
      *
      ** Produce error report
      *
     C                   OPEN      SD008130AU
     C                   WRITE     SD8130A1
     C                   WRITE     DBFMTAU
      *
      ** Ensure the AU spool file is recorded by RCF
      *
     C                   Z-ADD     SFNUMA        ZSNUM
      *
      ** Call ZSFILE for SD008130AU
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    SEQNO
     C                   PARM      *BLANKS       ENTY
     C                   PARM                    SFILEA
     C                   PARM                    ZSNUM
     C                   PARM                    ZSERR
      *
     C                   CLOSE     SD008130AU
      *
     C                   SETON                                        LR
     C                   RETURN
     C                   END
      *
      ** Exit program.
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *
     C/EJECT
     C/COPY ZSRSRC,ZDATE9Z3LE
     C/EJECT
     C/COPY ZSRSRC,ZSEDITZ3LE
     C/EJECT
     C/COPY ZSRSRC,ZDATE2Z2LE
      *
     C/EJECT
      *****************************************************************
      * GLZADD -
      *
      * Called From: SRHASH
      *
      * Calls:       GLZSUM
      *****************************************************************
      *
     CSR   GLZADD        BEGSR
      *
     CSR                 Z-ADD     ZZAMT         ZZAMT                    91
     CSR 91              GOTO      ZZAEND
      *
      ** SPLIT ZZAMT INTO INTEGER AND DECIMAL FIELDS
      *
     CSR                 Z-ADD     ZZAMT         ZZAMTI
     CSR                 MOVE      ZZAMT         ZZAMTD
      *
      ** BOTH ZZAMTI AND ZZAMTD CONTAIN A 'SIGN' ZONE NOW
      *
     CSR                 EXSR      GLZSUM
     CSR   ZZAEND        ENDSR
      *
      ********************************************************************
      * SUBROUTINE TO CARRY OUT THE ADDITION FOR SUBROUTINES -
      *                        GLZADD, GLZSUB, GLZCMP.
      *          PARAMETERS PASSED -
      *                     I/P ZZAMTI ZZAMTD
      *                     O/P ZZTOTI ZZTOTD ZZNEGD IND 96 IND 99.
      *
      ********************************************************************
     CSR   GLZSUM        BEGSR
      *
     CSR                 Z-ADD     ZZTOTI        ZZTOTI
     CSR                 Z-ADD     ZZTOTD        ZZTOTD
     CSR                 SETOFF                                       919293
     CSR                 SETOFF                                       949599
      *
      ** DETERMINE SIGN OF ZZAMTI & D,   92 IF NEG
      *
     CSR   ZZAMTI        COMP      0                                    9293
     CSR 93ZZAMTD        COMP      0                                    9293
     CSR 93              GOTO      ZZSEND
      *
      ** DETERMINE SIGN OF ZZTOTI & D, 91 IF NEG.
      *
     CSR   ZZTOTI        COMP      0                                    9193
     CSR 93ZZTOTD        COMP      0                                    9193
      *
      ** IF ZZTOTAL IS ZERO, RETURN ZZAMOUNT.
      *
     CSR 93              Z-ADD     ZZAMTI        ZZTOTI
     CSR 93              Z-ADD     ZZAMTD        ZZTOTD
     CSR 93              GOTO      ZZSEND
      *
      ** IF SIGNS DIFFER BYPASS OVERFLOW CHECKS.
      *
     CSR 91
     CANN92
     CORN91
     CAN 92              GOTO      ZZOFPS
      *
     CSR   ZZAMTD        ADD       ZZTOTD        ZZWK2
     CSR   ZZWK2         COMP      999                                93
     CSRN93ZZWK2         COMP      -999                                 93
      *
     CSR 93
     CANN92ZZAMTI        ADD       1             ZZWK3
     CSR 93
     CAN 92ZZAMTI        SUB       1             ZZWK3
     CSR 93ZZTOTI        ADD       ZZWK3         ZZWK3
     CSRN93ZZTOTI        ADD       ZZAMTI        ZZWK3
      *
      ** IF THE MODULUS OF ZZWK3 IS LT MOD. ZZTOTI THEN O/F HAS OCCURED
      *
     CSRN92ZZWK3         COMP      ZZTOTI                               99
     CSR 92ZZWK3         COMP      ZZTOTI                             99
     CSRN99              Z-ADD     ZZWK2         ZZTOTD
     CSRN99              Z-ADD     ZZWK3         ZZTOTI
      *
      ** IF O/F ZEROIZE ZZAMT , IND '99' SET AND ZZTOT FIELDS LEFT INTACT.
      *
     CSR 99              Z-ADD     0             ZZAMT
     CSR                 GOTO      ZZSEND
      *
      ** THE 'SIGNS' ARE DIFFERENT
      *
     CSR   ZZOFPS        TAG
      *
      ** IF ZZAMT WAS NEGATIVE, MAKE IT POS. TO COMP WITH ZZTOT
      *
     CSR 92              Z-SUB     ZZAMTI        ZZAMTI
     CSR 92              Z-SUB     ZZAMTD        ZZAMTD
      *
      ** IF ZZTOT WAS NEGATIVE, MAKE IT POS. TO COMP WITH ZZAMT.
      *
     CSR 91              Z-SUB     ZZTOTI        ZZTOTI
     CSR 91              Z-SUB     ZZTOTD        ZZTOTD
      *
      ** BOTH ZZAMT AND ZZTOT ARE NOW POSITIVE.
      *
     CSR   ZZTOTI        COMP      ZZAMTI                             93  95
     CSR 95ZZTOTD        COMP      ZZAMTD                             93  95
      *
      ** IF ZZTOT EQ. ZZAMT RETURN ZERO.
      *
     CSR 95              Z-ADD     0             ZZTOTI
     CSR 95              Z-ADD     0             ZZTOTD
     CSR 95              GOTO      ZZSEND
      *
      ** IF ZZTOT GT. ZZAMT.
      *
     CSR 93ZZAMTD        COMP      ZZTOTD                             94
     CSR 93
     CAN 94ZZTOTI        SUB       1             ZZTOTI
     CSR 93
     CAN 94ZZTOTD        ADD       1000          ZZWK2
     CSR 93ZZTOTI        SUB       ZZAMTI        ZZTOTI
     CSR 93
     CAN 94ZZWK2         SUB       ZZAMTD        ZZTOTD
     CSR 93
     CANN94ZZTOTD        SUB       ZZAMTD        ZZTOTD
      *
      **IF ZZAMT GT. ZZTOT.
      *
     CSRN93ZZTOTD        COMP      ZZAMTD                             94
     CSRN93
     CAN 94ZZAMTI        SUB       1             ZZWK3
     CSRN93
     CAN 94ZZAMTD        ADD       1000          ZZWK2
     CSRN93
     CAN 94ZZWK3         SUB       ZZTOTI        ZZTOTI
     CSRN93
     CANN94ZZAMTI        SUB       ZZTOTI        ZZTOTI
     CSRN93
     CAN 94ZZWK2         SUB       ZZTOTD        ZZTOTD
     CSRN93
     CANN94ZZAMTD        SUB       ZZTOTD        ZZTOTD
      *
      ** REVERSE SIGN OF ZZTOT IF LARGER I/P FIELDS WERE NEGATIVE
      *
     CSR                 SETOFF                                       94
     CSR 93
     CAN 91
     CORN93
     CAN 92              SETON                                        94
     CSR 94              Z-SUB     ZZTOTI        ZZTOTI
     CSR 94              Z-SUB     ZZTOTD        ZZTOTD
      *
      **   RESTORE SIGN OF ZZAMTI & ZZAMTD IF IT WAS REVERSED.
      *
     CSR 92              Z-SUB     ZZAMTI        ZZAMTI
     CSR 92              Z-SUB     ZZAMTD        ZZAMTD
     CSR   ZZSEND        TAG
      *
      **   IF ZZTOTD IS ZERO, AND ZZTOTI IS NEG. SET UP ZZNEGD.
      *
     CSR                 SETOFF                                       96
     CSR   ZZTOTD        COMP      0                                      91
     CSR 91ZZTOTI        COMP      0                                    96
     CSR 96              MOVE      '.000-'       ZZNEGD
     CSR                 ENDSR
      *
      **************************************************************
      ** Stamp Tax Summary files:
      ** DLDLDCQD
     ODLDLDCD0  E            UPDSDL
     O                       F1STAB
      *
      ** CLONCLQD
     OCLONLQD0  E            UPDSLN
     O                       LQSTAB
      *
      ** LEFCLTQD
     OLEFCLTD0  E            UPDSFC
     O                       FCSTAF
      *
      ** LEFEEDQD
     OLEFEEQD0  E            UPDSFE
     O                       FQSTAF
      *
      ** TRADSDQD
     OTRADSQD0  E            UPDSTR
     O                       TQSTAF
      *
      ** INPAYDQD
     OINPAYQD0  E            UPDSIP
     O                       IPSTAF
      *
      ** OTPAYDQD
     OOTPAYQD0  E            UPDSOP
     O                       OTSTAF
      *
      ** CQCOCDQD
     OCQCOCQD0  E            UPDSCC
     O                       QCSTAF
      *
      ** CQPACDQD
     OCQPACQD0  E            UPDSCP
     O                       QPSTAF
      *
      ** POSETDX3
     OPOSETDD3  E            UPDSPS
     O                       P3STAF
      *
      ** Stamp Tax Details file: (SDSTMDPD)
     O@STMDV0   E            UPDREC
     O                       T2TXRT
     O                       T2TATC
     O                       T2TYLC
     O                       T2LCD
      *
      ** TRADSD                                                                             AR875365
     OTRADSDF   E            UPDTRD                                                         AR875365
     O                       TCA7                                                           AR875365
      *                                                                                     AR875365
** @YD  USED BY SR. ZDATE9 - YEARS, IN DAYS, CUMULATIVE IN 4 YEAR SPAN
00366007310109601461
** @MD  USED BY SR. ZDATE9 - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
00000000310005900090001200015100181002120024300273003040033400365
**   ZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
0366073110961461
**   ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
000031059090120151181212243273304334365
**   ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
** CPY@   **      OBJECT COPYRIGHT
(c) Copyright Misys International Banking Systems Ltd. 2010
