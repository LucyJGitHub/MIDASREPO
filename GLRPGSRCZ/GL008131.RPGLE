     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL Stamp Tax A/C Keys - Intr., Avg. Pst. C&C')   *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger                                       *
      *                                                               *
      *  GL008131 - Additional Postings for Stamp Tax                 *
      *                                                               *
      *  Function:  This function generates postings for stamp tax    *
      *             paid on debit interest for retail accounts and    *
      *             for Stamp Tax paid on debit average balances for  *
      *             Retail and average balances for lending and       *
      *             dealing, also this computes stamp tax paid for    *
      *             charges and commissions                           *
      *                                                               *
      *             It runs daily.                                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2010            *
      *                                                               *
      *  Last Amend No. CRE090             Date 14Feb14               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      *                 AR888911           Date 26Jan12               *
      *                 AR899028           Date 25Jan12               *
      *                 AR879983           Date 21Dec11               *
      *                 AR847269           Date 09Nov11               *
      *                 AR853257           Date 04Nov11               *
      *                 AR871734           Date 05Dec11               *
      *                 AR833361           Date 22Nov11               *
      *                 AR821972           Date 07Sep11               *
      *                 AR824348           Date 02Sep11               *
      *                 AR820965           Date 26Aug11               *
      *                 CER049  *CREATE    Date 06Dec10               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CRE090 - Delay Capitalisation of Interest (Recompile)        *
      *  CLE148 - Alpha Loan Reference                                *
      *  AR888911 - In reversing a deal, REV column in Stamp Tax      *
      *             Movements Enquiry is not changing from N to Y     *
      *             (Recompile)                                       *
      *           - Applied for AR944923                              *
      *  AR899028 - NOSTRO AMAD System errors occured; applied        *
      *             fix AR847269                                      *
      *  AR879983 - Add stamp tax exchange rate                       *
      *  AR847269 - Column F1DACN not in specified tables (Recompile) *
      *  AR853257 - Account Keys for FT were not generated            *
      *  AR871734 - GLC008131 00001 I/O operation was applied to      *
      *             closed file GL008131P1; applied fix AR833361      *
      *  AR833361 - I/O operation was applied to closed file          *
/*    *  AR821972 - Stamp tax on debit interest did not generate      *
/*    *             amount in GLVCLSIN                                *
      *  AR824348 - Naming convention errors                          *
/*    *  AR820965 - Component GLC008131 00001 failed                  *
      *  CER049 - Stamp Tax                                           *
      *                                                               *
      *****************************************************************
      *
      ** Principal Movements
     FGLHPMPL1  IF   E           K DISK
      *
      ** Stamp Tax Customers
     FSDCUSQL0  IF   E           K DISK
      *
      ** Debit Interest Postings
     FGEICPD    IF   E             DISK
      *
      ** Transaction charges and commissions
     FREACCJL3  IF   E           K DISK
      *
      ** Stamp Tax Summary Transactions Extension files
     FGLACNTL3  UF   E           K DISK
     FDLDLDCL3  UF   E           K DISK
     FCLONCLL1  UF   E           K DISK
      *
      ** Retail Historic Files - all records
     FREHISDL   IF   E           K DISK
      *
      ** Historic Spot Rates
     FSDCUHSL2  IF   E           K DISK
      *
      ** Retail Historic Files - only Header record ('B')
     FREHISBL   IF   E           K DISK
     F                                     RENAME(REHISPPF:REHEAD)
      *
      ** Retail a/c Keys Output file: Stamp Tax on Debit Interest
     FGLVCLSIN  O    E             DISK
      *
      ** Retail a/c Keys Output file: Stamp Tax on averages
     FGLVCLSRE  O    E             DISK
      *
      ** Deals a/c Keys Output file: Stamp Tax on averages
     FGLVCLSDL  O    E             DISK
      *
      ** Loans a/c Keys Output file: Stamp Tax on averages
     FGLVCLSLE  O    E             DISK
      *
      ** Retail a/c Keys Output file: Stamp Tax on Charges and Commissions
     FGLVCLSCC  O    E             DISK
      *
      ** Stamp Tax Historic/Details file: Stamp Tax on averages
     FSDSTMDL0  UF A E           K DISK
      *
      ** Accounts Being Closed Today
     FGLCLOSL0  IF   E           K DISK
      *
      ** Report
      *
     F***GL8131CY  UF A E           K DISK                                                  AR824348
     FGLSTCYPD  UF A E           K DISK                                                     AR824348
      *
      ** GL8131P2 c Keys Output file: Stamp Tax on averages
     F***GL8131PD  O    E             DISK                                                  AR824348
     FGLSTRPPD  O    E             DISK                                                     AR824348
      *
     FGL008131AUO    E             PRINTER INFDS(SPOOLA) USROPN
     FGL008131P1O    E             PRINTER INFDS(SPOOL1) USROPN
     FGL008131P2O    E             PRINTER INFDS(SPOOL2) USROPN
      **
      *****************************************************************
      * ID F  C  H  L    FUNCTION OF INDICATORS
      *
      * 75            Work Ind
      * 40            Read Ind
      * 41            Read Ind
      * 42            Chain SDSTMPPD
      * 43            Chain SDSTPCPD
      * 90-99         Standard Routines
      *
      *****************************************************************
      *
     D ZW              S              1    DIM(14)
      *
      ** WORK ARRAY USED FOR ZRATE3 TO HOLD RATE
      ** ARRAY FOR SR. ZDATE9 - CUMULATIVE DAYS IN YEAR FOR 4 YEAR PERIOD
     D @YD             S              5  0 DIM(4) CTDATA PERRCD(4) ASCEND
      *
      ** ARRAY FOR SR. ZDATE9 - CUMULATIVE DAYS IN YEAR PER MONTH
     D @MD             S              5  0 DIM(13) CTDATA PERRCD(13) ASCEND
      *
     D ZS2             S              1    DIM(21)
      *
     D ZYDY            S              4  0 DIM(4) CTDATA PERRCD(4)
     D ZMDY            S              3  0 DIM(13) CTDATA PERRCD(13)
     D ZMNM            S              3    DIM(12) CTDATA PERRCD(12)
      *
     D POWER           S              7  3 DIM(7) CTDATA PERRCD(1)
     D SR@             S              6    DIM(3) CTDATA PERRCD(3)
     D DC@             S             20    DIM(3) CTDATA PERRCD(3)
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
 
     D TotalCHG        S             13P 0 INZ(*ZEROS)
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
     D STAMDA          DS
     D  TAKEON                 1      5  0
     D  DATRAT                 6     10  0
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** External DS for branch name details
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** SAR File Details Accessed via Access Program AOSARDR0
      *
     D SDACCT        E DS                  EXTNAME(ACCNTAB)
      ** Data structure for Account details
     D  ACRECI       E                     EXTFLD(RECI)
     D  ACBRCA       E                     EXTFLD(BRCA)
     D  ACCNUM       E                     EXTFLD(CNUM)
     D  ACCCY        E                     EXTFLD(CCY)
     D  ACACOD       E                     EXTFLD(ACOD)
     D  ACACSQ       E                     EXTFLD(ACSQ)
     D  ACPRFC       E                     EXTFLD(PRFC)
     D  ACPTFR       E                     EXTFLD(PTFR)
     D  ACORED       E                     EXTFLD(ORED)
     D  ALCD         E                     EXTFLD(LCD)
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Fisrt DS for Access Programs, Short data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for Access Programs, Long data structure
      *
     D LDA           E DS           256    EXTNAME(LDA)
      *
     D                 DS
     D  AKDS                   1     14
     D  AKDS68                 6      8
      *
     D AKY             DS
     D  AKEY                   1     14
     D  AKF12                  1      2
     D  AKF15                  1      5
     D  AKF45                  4      5
     D  AKF68                  6      8
     D  AKF910                 9     10
     D  AKEVEN                 3      3
     D  AKFL10                10     10
      *
      * Retail a/c nr
     D @RETAI          DS
     D  @RBRCA                 1      3
     D  @RCUST                 4      9
     D  @RCCY                 10     12
     D  @RACOD                13     22  0
     D  @RACSQ                23     24  0
      *
      ** Format account for report
     D @REACC          DS
     D  @REPBR                 1      3
     D                         4      4    INZ('-')
     D  @REPCU                 5     10
     D                        11     11    INZ('-')
     D  @REPCY                12     14
     D                        15     15    INZ('-')
     D  @REPAC                16     25
     D                        26     26    INZ('-')
     D  @REPAS                27     28
      *
      ** Debit a/c nr
     D @DEBIT          DS
     D  @DBRCA                 1      3
     D                         4      4    INZ('-')
     D  @DCUST                 5     10
     D                        11     11    INZ('-')
     D  @DCCY                 12     14
     D                        15     15    INZ('-')
     D  @DACOD                16     25
     D                        26     26    INZ('-')
     D  @DACSQ                27     28
      *
     D @OTAC           DS
     D  @OBRCA                 1      3
     D  @OCNUM                 4      9
     D  @OCCY                 10     12
     D  @OACOD                13     22
     D  @OACSQ                23     24
      *
      ** OSAC
     D @OVACC          DS
     D  OVCUST                 1      6
     D  OVACOD                 7     16
     D  OVACSQ                17     18
      *
      ** Date
     D @DATE           DS
     D  @DDAY                  1      2  0
     D  @DMON                  3      4  0
     D  @DYEA                  5      6  0
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
     D SPOOL2          DS
      *
      ** DS FOR P2 SPOOL FILE NAME
      *
     D  SFILE2                83     92
     D  SFNUM2               123    124B 0
     D  OFLLN2               188    189B 0
     D  PRTLN2               367    368B 0
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
      ** DATA STRUCTURE FOR SR. ZDATE9 - FIELD IS @@Z71Y
     D                 DS
     D  @@Z71Y                 1      4  0
     D  @@SSY1                 1      1  0
     D  @@SSY2                 2      2  0
     D  @@SSY3                 3      3  0
     D  @@SSY4                 4      4  0
      ** DATA STRUCTURE FOR SR. ZDATE9 - FIELD IS @@VDT
     D                 DS
     D  @@VDT                  1      8  0
     D  @@YR                   1      4  0
     D  @@Z71M                 5      6  0
     D  @@Z71D                 7      8  0
      *
     D                 DS
     D  WORK15                 1     15  0
     D  ZS1                    1     15  0
     D                                     DIM(15)
      *
     I@HPMPV1
      *
     I              T3OPAM                      HISB
     I              T3VALD                      HISD
      *****************************************************************
      * MAIN
      *****************************************************************
      *
      ** Initial Process
     C                   EXSR      STINIT
      *
      ** Stamp Tax on Debit Interest
     C                   EXSR      STDBRE
      *
      ** Stamp Tax on Average Balances
     C                   EXSR      STAVBL
      *
      ** Stamp Tax on Charges and Commissions
     C                   EXSR      STCHCO
      *
      ** End Process
     C                   EXSR      SRTERM
      *
     C/EJECT
      *****************************************************************
      * STDBRE - Stamp Tax on Debit Interest on Debit Retail a/c
      *
      * Called From: MAIN
      *
      * Calls:       STTXRT Retrieve Tax Rate/Ccy
      *              STCCYD Retrieve Ccy details
      *              STSTAX Calculate Tax
      *              STCONV Convert Tax AMount to Base/Stamp Tax ccy
      *              STACKY Generate Stamp Tax a/c keys
      *****************************************************************
      *
     C     STDBRE        BEGSR
      *
     C                   CLEAR                   @CALTX
      ** set a/c keys
      *
     C                   MOVE      *BLANKS       AKEY
     C                   MOVE      *BLANKS       AKEYDR
     C                   MOVE      *BLANKS       AKEYST
     C                   MOVE      *BLANKS       AKEYF
     C                   MOVE      *BLANKS       AKEYS
     C                   MOVE      *BLANKS       AKEYA
     C                   MOVE      *BLANKS       AKEYB
      *
      ** AKEYDR = Debit account currency: STVTX---FI----
     C                   MOVEL     'STVTX'       AKEYDR
     C                   MOVE      'FI    '      AKEYDR
      *
      ** AKEYST = Stamp Tax currency:     STVTX---SI----
     C                   MOVEL     'STVTX'       AKEYST
     C                   MOVE      'SI    '      AKEYST
      *
      ** CONVERSION ACCOUNT KEYS:
      ** AKEYF  = Debit account currency: STVTX----F----
     C                   MOVEL     'STVTX'       AKEYF
     C                   MOVE      'F    '       AKEYF
      *
      ** AKEYS  = Stamp Tax currency:     STVTX----S----
     C                   MOVEL     'STVTX'       AKEYS
     C                   MOVE      'S    '       AKEYS
      *
      ** AKEYA = Base ccy conversion - debit account ccy: STVTXsss-A---- (sss is dr acc ccy)
     C                   MOVEL     'STVTX'       AKEYA
     C                   MOVE      ' A    '      AKEYA
      *
      ** AKEYB = Base ccy conversion - stamp tax unt ccy: STVTXccc-B---- (ccc is stamp tax ccy)
     C                   MOVEL     'STVTX'       AKEYB
     C                   MOVE      ' B    '      AKEYB
      *
      ** Set work-fields
     C                   MOVE      'STDBRE'      @SRNAM
     C                   MOVE      ' '           @PMRUN
     C                   Z-ADD     1             @SEQ2
      *
      ** Read GL Generated Entries - Int/Cap Details file
      *
     C                   MOVE      *OFF          *IN40
      *
     C                   READ      GEICPD                                 40
      *
     C     *IN40         DOWEQ     *OFF
      *
      ** Determine whether record is to be selected:
      *
     C                   MOVE      *BLANKS       @SEL              1
      *
     C     ZZ007         IFEQ      'DEB INT'
     C                   MOVE      'Y'           @SEL
     C                   END
      *
      ** Record Selected
      *
     C     @SEL          IFNE      *BLANKS
      *
      ** Access record on Summary Stamp Tax - Transactions ext. file
      ** ...Retail Debit Interest or Retail Average Balance
     C                   MOVE      BRCA          @T1BRC
     C                   MOVE      CNUM          @T1CNM
     C                   MOVE      ACOD          @T1ACO
     C                   MOVE      ACSQ          @T1ACS
     C                   MOVE      CCY           @T1CCY
      *
      ** Set module
     C                   MOVEL     'ACCOUNT'     @T1KEY
      *
      ** Access Stamp Tax Summary Transactions Extension file
      *
     C     ACKEYK        CHAIN     GLACNTL3                           42
     C                   MOVEL     'ACCOUNT'     T#KEY
     C                   MOVE      F1DBRC        T#DBRC
     C                   MOVE      F1DCST        T#DCST
     C                   MOVE      F1DCCY        T#DCCY
     C                   MOVE      F1DACD        T#DACD
     C                   MOVE      F1DASC        T#DASC
      *
      ** Retrieve Settlement Branch Details
      *
     C     *IN42         IFEQ      *OFF
     C                   MOVEL     F1BRCA        @BRCA
     C                   EXSR      AOBRCA
     C                   END
      *
      ** Retrieve Customer Stamp Tax details
      *
     C     F1CNUM        CHAIN     SDCUSQL0                           43
      *
      ** Calculate Tax if Tax indicator is ON and Value Date is After
      ** "Tax on Interest" Start Date.
     C     F1TAX         IFEQ      'Y'
     C     VALD          ANDGT     F1IDTE
      *
      ** ....Calculate Stamp Tax
      ** The tax amount is calculated on the amount of the Debit
      ** Interest, the tax rate is the effective rate at the Value Date.
      *
     C                   MOVE      CCY           @ECCY
     C                   MOVE      CCY           ECCY
     C                   Z-ADD     PSTA          @GROSS
      *
      ** Reverse sign if Debit interest is being credited
      ** calculate stamp tax
     C                   EXSR      STSTAX
      *
      ** Convert tax to Stamp Tax and Base ccy
      *
     C                   EXSR      STCONV
      *
      ** Generate RE Debit Interest Stamp Tax a/c keys
      * ---------------------------------------------
      *
     C     @TAXE         CASNE     *ZEROS        STACKY
     C                   END
      *
      ** Update Stamp Tax summary record
     C  N42              EXCEPT    UPDAC
      *
     C                   END
     C                   END
      *
     C                   READ      GEICPD                                 40
     C                   ENDDO
      *
      ** End of Report GL008131P1 - account keys generated
      *
     C                   IF        @OPNREP1 = *BLANKS                                       AR833361
     C                   OPEN      GL008131P1                                               AR833361
     C                   WRITE     HEADP1                                                   AR833361
     C                   MOVE      'Y'           @OPNREP1                                   AR833361
     C                   ENDIF                                                              AR833361
     C     PRTLN1        IFGE      57
     C                   WRITE     HEADP1
     C                   END
     C                   WRITE     ENDDP1
      ** Close GL008131P1
     C                   IF        @OPNREP1 <> *BLANKS
     C                   CLOSE     GL008131P1
     C                   MOVE      *BLANKS       @OPNREP1
     C                   ENDIF
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      * STAVBL - Stamp Tax on Average Balances
      *
      * Called From: MAIN
      *
      * Calls:       STCLRF Clear work fields
      *              AOBRCA Access Branch details
      *              STAVRE Stamp Tax on Retail Avg Bal
      *              STAVDL Stamp Tax on Dealing/Lending Avg Bal
      *****************************************************************
      *
     C     STAVBL        BEGSR
      *
      ** clear indicators/fields
     C                   MOVE      *OFF          *IN40
     C                   MOVE      *OFF          *IN76
     C                   Z-ADD     0             DRCR
     C                   Z-ADD     @ECMDT        VALD
      *
      ** Read Retail Stamp Tax Summary file, select records where the
      ** Avg indicator is 'Y'
      *
     C     *LOVAL        SETLL     GLACNTL3
     C                   READ      GLACNTL3                               40
      *
     C     *IN40         DOWEQ     *OFF
      *
      **  determine whether record is to be selected:
      **   ....F1TAX  = Y - Stamp Tax liable
      **  ....F1AVBL = Y - record subject to Average Balance Stamp tax
      *
     C     F1AVBL        IFEQ      'Y'
     C     F1TAX         ANDEQ     'Y'
      *
      ** clear work fields: Date, Balance, Avg Balance
     C                   MOVE      'ACCOUNT   '  T#KEY            10
     C                   EXSR      STCLRF
     C                   MOVE      F1DBRC        T#DBRC            3
     C                   MOVE      F1DCST        T#DCST            6
     C                   MOVE      F1DCCY        T#DCCY            3
     C                   MOVE      F1DACD        T#DACD           10 0
     C                   MOVE      F1DASC        T#DASC            2 0
     C                   Z-ADD     F1ADTE        T#ADTE            5 0
      *
      ** Retrieve Customer Stamp Tax details
      *
     C     F1CNUM        CHAIN     SDCUSQL0                           43
      *
      ** get details of the branch
      *
     C                   MOVE      F1BRCA        @BRCA
     C                   MOVE      @BRCA         BRCA
     C                   EXSR      AOBRCA
      *
      ** Retrieve Last Drop off movements date
     C                   MOVEL     F1CNUM        @RCNUM
     C                   MOVEL     F1CCY         @RCCY
     C                   MOVEL     F1ACOD        @RACOD
     C                   MOVEL     F1ACSQ        @RACSQ
     C                   MOVEL     F1BRCA        @RBRCA
     C                   Z-ADD     *ZEROS        @RHISD
     C     STHIS         CHAIN     REHISBL                            75
     C                   Z-ADD     HISD          HISDAT
      *
      ** ......Avg on Dr Bal on Retail a/c
     C                   MOVE      'STAVRE'      @SRNAM
     C                   EXSR      STAVRE
      *
      ** update summary file
     C     @CLOSE        IFEQ      'Y'
      *
     C     F1CLOS        IFEQ      'C'
     C                   MOVE      'N'           F1TAX
     C                   MOVE      ' '           F1CLOS
     C                   END
     C     T3ACST        IFEQ      'C'
     C     T3DACC        ANDGT     0
     C                   MOVE      'Y'           F1CLOS
     C                   END
      *
     C                   END
      *
     C                   EXCEPT    UPDAC
      *
     C                   END
      *
      **  read next record from Retail Stamp Tax summary file
     C                   READ      GLACNTL3                               40
     C                   ENDDO
      *
      ** Read Dealing Stamp Tax Summary file, select records where the
      ** Avg indicator is 'Y'
      *
     C     *LOVAL        SETLL     DLDLDCL3
     C                   READ      DLDLDCL3                               40
      *
     C     *IN40         DOWEQ     *OFF
      *
      **  determine whether record is to be selected:
      **  ....F1TAX  = Y - Stamp Tax liable
      **  ....F1AVBL = Y - record subject to Average Balance Stamp tax
      *
     C     F1AVBL        IFEQ      'Y'
     C     F1TAX         ANDEQ     'Y'
      *
      ** clear work fields: Date, Balance, Avg Balance
     C                   MOVE      'DEAL      '  T#KEY
     C                   EXSR      STCLRF
     C                   MOVE      F1DBRC        T#DBRC
     C                   MOVE      F1DCST        T#DCST
     C                   MOVE      F1DCCY        T#DCCY
     C                   MOVE      F1DACD        T#DACD
     C                   MOVE      F1DASC        T#DASC
     C                   Z-ADD     F1ADTE        T#ADTE
      *
      ** Retrieve Customer Stamp Tax details
      *
     C     F1DCST        CHAIN     SDCUSQL0                           43
      *
      ** get details of the branch
      *
     C                   MOVE      F1DBRC        @BRCA
     C                   MOVE      @BRCA         BRCA
     C                   EXSR      AOBRCA
      *
      ** ......Avg Bal on Dealing
     C                   MOVE      'STAVDL'      @SRNAM
     C                   EXSR      STAVDL
      *
      ** update summary file
      *
     C                   EXCEPT    UPDDL
      *
     C                   END
      *
      ** read next record from Dealing Stamp Tax summary file
     C                   READ      DLDLDCL3                               40
     C                   ENDDO
      *
      ** Read Lending Stamp Tax Summary file, select records where the
      ** Avg indicator is 'Y'
      *
     C     *LOVAL        SETLL     CLONCLL1
     C                   READ      CLONCLL1                               40
      *
     C     *IN40         DOWEQ     *OFF
      *
      **   determine whether record is to be selected:
      **   ....LQTAX  = Y - Stamp Tax liable
      **   ....LQAVBL = Y - record subject to Average Balance Stamp tax
      *
     C     LQAVBL        IFEQ      'Y'
     C     LQTAX         ANDEQ     'Y'
      *
      ** clear work fields: Date, Balance, Avg Balance
     C                   MOVE      'LOAN      '  T#KEY
     C                   EXSR      STCLRF
     C                   MOVE      LQDBRC        T#DBRC
     C                   MOVE      LQDCST        T#DCST
     C                   MOVE      LQDCCY        T#DCCY
     C                   MOVE      LQDACD        T#DACD
     C                   MOVE      LQDASC        T#DASC
     C                   Z-ADD     LQADTE        T#ADTE
      *
      ** Retrieve Customer Stamp Tax details
      *
     C     LQDCST        CHAIN     SDCUSQL0                           43
      *
      ** get details of the branch
      *
     C                   MOVE      LQDBRC        @BRCA
     C                   MOVE      @BRCA         BRCA
     C                   EXSR      AOBRCA
      *
      ** ......Avg Bal on Lending
     C                   MOVE      'STAVDL'      @SRNAM
     C                   EXSR      STAVDL
      *
      ** update summary file
      *
     C                   EXCEPT    UPDLN
      *
     C                   END
      *
      **  read next record from Lending Stamp Tax summary file
     C                   READ      CLONCLL1                               40
     C                   ENDDO
      *
      ** Print Totals by ccy
      *
     C                   EXSR      STPRCY
      *
     C                   ENDSR
      *
     C/EJECT
      *****************************************************************
      * STCHCO - Stamp Tax on Charges and Commissions
      *
      * Called From: MAIN
      *
      * Calls:       STTXRT Retrieve Tax Rate/Ccy
      *              STCCYD Retrieve Ccy details
      *              STSTAX Calculate Tax
      *              STCONV Convert Tax AMount to Base/Stamp Tax ccy
      *              STACKY Generate Stamp Tax a/c keys
      *****************************************************************
      *
     C     STCHCO        BEGSR
      *
     C                   CLEAR                   @CALTX
      *
      ** Set A/C Keys
     C                   MOVE      *BLANKS       AKEY
     C                   MOVE      *BLANKS       AKEYDR
     C                   MOVE      *BLANKS       AKEYST
     C                   MOVE      *BLANKS       AKEYF
     C                   MOVE      *BLANKS       AKEYS
     C                   MOVE      *BLANKS       AKEYA
     C                   MOVE      *BLANKS       AKEYB
      *
      ** AKEYDR = Debit account currency: STVTX---FC----
     C                   MOVEL     'STVTX'       AKEYDR
     C                   MOVE      'FC    '      AKEYDR
      *
      ** AKEYST = Stamp Tax currency:     STVTX---SC----
     C                   MOVEL     'STVTX'       AKEYST
     C                   MOVE      'SC    '      AKEYST
      *
      ** CONVERSION ACCOUNT KEYS:
      ** AKEYF  = Debit account currency: STVTX----F----
     C                   MOVEL     'STVTX'       AKEYF
     C                   MOVE      'F    '       AKEYF
      *
      ** AKEYS  = Stamp Tax currency:     STVTX----S----
     C                   MOVEL     'STVTX'       AKEYS
     C                   MOVE      'S    '       AKEYS
      *
      ** AKEYA = Base ccy conversion - debit account ccy: STVTXsss-A---- (sss is dr acc ccy)
     C                   MOVEL     'STVTX'       AKEYA
     C                   MOVE      ' A    '      AKEYA
      *
      ** AKEYB = Base ccy conversion - stamp tax unt ccy: STVTXccc-B---- (ccc is stamp tax ccy)
     C                   MOVEL     'STVTX'       AKEYB
     C                   MOVE      ' B    '      AKEYB
      *
      ** Set work-fields
     C                   MOVE      'STCHCO'      @SRNAM
     C                   MOVE      ' '           @PMRUN
     C                   Z-ADD     1             @SEQ2
      *
      ** Read REACCJL3 - Retail accounts joint logical file
      *
     C                   DOU       %EOF(REACCJL3)
     C                   READ      REACCJZ3
      *
     C                   EVAL      @SEL = 'N'
     C                   IF        NOT(%EOF(REACCJL3))
      *
     C                   IF        RECI <> 'C'
     C                   EVAL      @SEL = 'Y'
     C                   ENDIF
      *
     C                   IF        @SEL = 'Y'
      *
      ** Access record on Summary Stamp Tax - Transactions ext. file
      ** ..Retail Charges and Commissions
     C                   MOVE      BRCA          @T1BRC
     C                   MOVE      CNUM          @T1CNM
     C                   MOVE      ACOD          @T1ACO
     C                   MOVE      ACSQ          @T1ACS
     C                   MOVE      CCY           @T1CCY
      *
      ** Set module
     C                   MOVEL     'ACCOUNT'     @T1KEY
      *
      ** Access Stamp Tax Summary Transactions Extension file
      *
     C     ACKEYK        CHAIN     GLACNTL3                           42
     C                   MOVEL     'ACCOUNT'     T#KEY
     C                   MOVE      F1DBRC        T#DBRC
     C                   MOVE      F1DCST        T#DCST
     C                   MOVE      F1DCCY        T#DCCY
     C                   MOVE      F1DACD        T#DACD
     C                   MOVE      F1DASC        T#DASC
      *
      ** Retrieve Settlement Branch Details
      *
     C     *IN42         IFEQ      *OFF
     C                   MOVEL     F1BRCA        @BRCA
     C                   EXSR      AOBRCA
     C                   ENDIF
      *
      ** Retrieve Customer Stamp Tax details
      *
     C     F1CNUM        CHAIN     SDCUSQL0                           43
      *
      ** Calculate Tax if Tax indicator is ON and Value Date is After
      ** "Tax on Interest" Start Date.
     C     F1CCFL        IFEQ      'Y'
      *
      ** ....Calculate Stamp Tax
      ** The tax amount is calculated on the amount of the Debit
      ** Interest, the tax rate is the effective rate at the Value Date.
      *
     C                   MOVE      CCY           @ECCY
     C                   MOVE      CCY           ECCY
     C                   EVAL      TotalCHG = TRCH + CHCO
     C                   EVAL      @GROSS = TotalCHG
      *
      ** Reverse sign if Debit interest is being credited
      ** calculate stamp tax
     C                   EXSR      STSTAX
      *
      ** convert tax to Stamp Tax and Base ccy
      *
     C                   EXSR      STCONV
      *
      ** Generate RE Charges and Commissions Tax A/C Keys
      * ------------------------------------------------
      *
     C     @TAXE         CASNE     *ZEROS        STACKY
     C                   ENDCS
      *
      ** Update Stamp Tax Summary Record
     C  N42              EXCEPT    UPDAC
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
      ** End of Report GL008131P1 - account keys generated
      *
     C                   IF        @OPNREP1 = *BLANKS                                       AR833361
     C                   OPEN      GL008131P1                                               AR833361
     C                   WRITE     HEADP1                                                   AR833361
     C                   MOVE      'Y'           @OPNREP1                                   AR833361
     C                   ENDIF                                                              AR833361
     C     PRTLN1        IFGE      57
     C                   WRITE     HEADP1
     C                   END
     C                   WRITE     ENDDP1
      ** Close GL008131P1
     C                   IF        @OPNREP1 <> *BLANKS
     C                   CLOSE     GL008131P1
     C                   MOVE      *BLANKS       @OPNREP1
     C                   ENDIF
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      * STAVRE - Stamp Tax on Retail Average Balances
      *
      * Called From: MAIN
      *
      * Calls:       STCLRF   Clear Retail Fields
      *              STSEDT   Calculate Start/End Period
      *              STAVRM   Avg Bal recalculated from start to Run dt
      *              STAVRD   Daily Avg Balance update from SoM
      *              AOACCN   a/c details
      *****************************************************************
      *
     C     STAVRE        BEGSR
      *
      ** Close Printer files if open
     C     @OPNRE        IFEQ      *BLANKS
     C     @OPNREP1      IFNE      *BLANKS
      *
      ** End of Report GL008131P1 - account keys generated
      *
     C     PRTLN1        IFGE      57
     C                   WRITE     HEADP1
     C                   END
     C                   WRITE     ENDDP1
     C                   CLOSE     GL008131P1
     C                   MOVE      *BLANKS       @OPNREP1
     C                   ENDIF
      *
      ** Open Printer files:
     C     @OPNREP1      IFEQ      *BLANKS
     C                   OPEN      GL008131P1
     C                   WRITE     HEADP1
     C                   MOVE      'Y'           @OPNREP1
     C                   ENDIF
      *
      ** Open Printer files:
     C     @OPNREP2      IFNE      *BLANKS
      *
      ** End of Report GL008131P2 - Up to date Average Balance Report
      *
     C     PRTLN2        IFGE      57
     C                   WRITE     HEADP2
     C                   END
     C                   WRITE     ENDDP2
     C                   CLOSE     GL008131P2
     C                   MOVE      *BLANKS       @OPNREP2
     C                   ENDIF
      *
      ** Open Printer files:
     C     @OPNREP2      IFEQ      *BLANKS
     C                   OPEN      GL008131P2
     C                   WRITE     HEADP2
     C                   MOVE      'Y'           @OPNREP2
     C                   END
     C                   MOVE      'Y'           @OPNRE
     C                   END
      *
      ** Set a/c keys
      ** ..Debit account currency
      **  AKEYDR = Debit account currency: STVTX---FA----
     C                   MOVEL     'STVTX'       AKEYDR
     C                   MOVE      'FA    '      AKEYDR
      *
      ** AKEYST = Stamp Tax currency:     STVTX---SA----
     C                   MOVEL     'STVTX'       AKEYST
     C                   MOVE      'SA    '      AKEYST
      *
      ** CONVERSION ACCOUNT KEYS
      ** AKEYF = Debit account currency: STVTX----F----
     C                   MOVEL     'STVTX'       AKEYF
     C                   MOVE      'F    '       AKEYF
      *
      ** AKEYS = Stamp Tax currency:     STVTX----S----
     C                   MOVEL     'STVTX'       AKEYS
     C                   MOVE      'S    '       AKEYS
      *
      ** AKEYA = Base ccy conversion - debit account ccy: STVTXsss-A---- (sss is dr acc ccy)
     C                   MOVEL     'STVTX'       AKEYA
     C                   MOVE      ' A    '      AKEYA
      *
      ** AKEYB = Base ccy conversion - stamp tax unt ccy: STVTXccc-B---- (ccc is stamp tax ccy)
     C                   MOVEL     'STVTX'       AKEYB
     C                   MOVE      ' B    '      AKEYB
      *
      ** Set account fields to retrieve account details
      *
     C                   MOVEL     *BLANKS       ##ACID
     C                   MOVEL     F1CNUM        ##CUST
     C                   MOVEL     F1CCY         ##CYCD
     C                   MOVEL     F1ACOD        ##ACCD
     C                   MOVEL     F1ACSQ        ##ACSN
     C                   MOVEL     F1BRCA        ##BRCD
      *
      ** Get Account Details through Access Program - AOACCTR0.
      *
     C                   EXSR      AOACCN
      *
      ** F1TAX might have been set to 'N' within AOACCN in the case
      ** where the account is not found or is already closed
     C     F1TAX         IFEQ      'Y'
      *
      ** Check if stamp tax a/c flagged as 'Closing'
      *
     C     F1CLOS        IFEQ      'C'
     C                   MOVE      'Y'           @CLOSE
     C                   Z-ADD     BKAPDT        DACC
     C                   END
      *
      ** Check if account closed today
      *
     C     @RTCD         IFEQ      *BLANKS
     C     T3RECI        IFEQ      'D'
     C     T3ACST        ANDEQ     'C'
     C     T3DACC        ANDEQ     BJRDNB
     C     F1CLOS        ANDEQ     *BLANKS
      *
     C                   Z-ADD     T3DACC        DACC
      ** Process only if Date Closed is after Stamp Tax Take-on Date
      *
     C     DACC          IFGT      TAKEON
     C                   MOVE      'Y'           @CLOSE
     C                   MOVE      DACC          VALD
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
      ** Process only live accounts or accounts closing today
     C     DACC          IFEQ      0
     C     @CLOSE        OREQ      'Y'
      *
      ** If End of Month or Close of the Account:
      **    - recalculate Average Balance from start up to previous EoM, generate account
      **      account key to adjust previous month Stamp tax if necessary
      **      else produce report GL008131P2
     C                   EXSR      STAVRM
      *
      ** Calculate average balance for current month, produce
      ** a/ck if if is end of month, else produce only the report
      *
     C                   EXSR      STAVRD
     C                   END
     C                   END
      *
     C                   ENDSR
      *
     C/EJECT
      *****************************************************************
      * STAVDL - Stamp Tax on Lending/Dealing Transactions
      *
      * Called From: STAVBL
      *
      * Calls:
      *****************************************************************
      *
     C     STAVDL        BEGSR
      *
      ** Close Printer files:
     C     @OPNLD        IFEQ      *BLANKS
     C     @OPNREP1      IFNE      *BLANKS
      *
      ** End of Report GL008131P1 - account keys generated
      *
     C     PRTLN1        IFGE      57
     C                   WRITE     HEADP1
     C                   END
     C                   WRITE     ENDDP1
     C                   CLOSE     GL008131P1
     C                   MOVE      *BLANKS       @OPNREP1
     C                   ENDIF
      *
      ** Open Printer files:
     C     @OPNREP1      IFEQ      *BLANKS
     C                   OPEN      GL008131P1
     C                   WRITE     HEADP1
     C                   MOVE      'Y'           @OPNREP1
     C                   END
      *
      ** Close Printer files:
     C     @OPNREP2      IFNE      *BLANKS
      *
      ** End of Report GL008131P2 - Up to date Average Balance Report
      *
     C     PRTLN2        IFGE      57
     C                   WRITE     HEADP2
     C                   END
     C                   WRITE     ENDDP2
     C                   CLOSE     GL008131P2
     C                   MOVE      *BLANKS       @OPNREP2
     C                   ENDIF
      *
      ** Open Printer files:
     C     @OPNREP2      IFEQ      *BLANKS
     C                   OPEN      GL008131P2
     C                   WRITE     HEADP2
     C                   MOVE      'Y'           @OPNREP2
     C                   END
     C                   MOVE      'Y'           @OPNLD
     C                   END
      *
      ** set a/c keys
      ** AKEYDR = Debit account currency: xxVyy---FA----
     C     T#KEY         IFEQ      'DEAL      '
     C                   MOVEL     F1DTYP        AKF12
     C                   MOVE      F1DSTP        AKF45
     C                   ELSE
     C                   MOVEL     LQLTYP        AKF12
     C                   MOVE      LQLSTP        AKF45
     C                   END
     C                   MOVE      'V'           AKEVEN
     C                   MOVE      'FA    '      AKEY
     C                   MOVE      AKEY          AKEYDR
      *
      **  AKEYST = Stamp Tax currency:     xxYyy---SA----
     C                   MOVE      'SA    '      AKEY
     C                   MOVE      AKEY          AKEYST
      *
      ** CONVERSION CURRENCY A/C KEYS
      ** AKEYF = Debit account currency: STVTX----F----
     C                   MOVEL     'STVTX'       AKEYF
     C                   MOVE      'F    '       AKEYF
      *
      ** AKEYS = Stamp Tax currency:     STVTX----S----
     C                   MOVEL     'STVTX'       AKEYS
     C                   MOVE      'S    '       AKEYS
      *
      ** AKEYA = Base ccy conversion - debit account ccy: STVTXsss-A----
     C                   MOVEL     'STVTX'       AKEYA
     C                   MOVE      ' A    '      AKEYA
      *
      ** AKEYB = Base ccy conversion - stamp tax unt ccy: STVTXccc-B----
     C                   MOVEL     'STVTX'       AKEYB
     C                   MOVE      ' B    '      AKEYB
      *
      ** Check if Transaction maturing today
     C                   MOVE      *BLANKS       T3ECCY
     C                   Z-ADD     *ZEROS        DACC
      *
     C     T#KEY         IFEQ      'DEAL      '
     C**********         Z-ADD     0             @T3LNR                                       CLE148
     C                   MOVE      *BLANKS       @T3LNR                                       CLE148
     C                   MOVE      F1DLNO        @T3DLN
     C                   ELSE
     C**********         Z-ADD     LQLNRF        @T3LNR                                       CLE148
     C                   MOVEL     LQLNRF        @T3LNR                                       CLE148
     C                   Z-ADD     0             @T3DLN
     C                   END
     C                   Z-ADD     BKAPDT        @T3VAL
     C     STHPM         SETGT     GLHPMPL1
     C     STHPP         READPE    GLHPMPL1                               76
      *
     C     *IN76         IFEQ      *OFF
     C     T3MATD        ANDEQ     'Y'
     C     HISD          ANDGE     BJRDNB
     C     HISD          ANDLE     BKAPDT
     C                   MOVE      'Y'           @CLOSE
     C                   Z-ADD     HISD          DACC
     C                   END
      *
      ** If end of month or transaction maturing today:
      **    - recalculate Average Balance from start up to previous EoM
      **      and adjust tax paid at Prev EoM (STAVDM)
      *
     C     DACC          IFEQ      *ZEROS
     C     @CLOSE        OREQ      'Y'
      *
     C                   EXSR      STAVDM
      *
      **  If end of month, calculate stamp tax and generate a/c keys, else
      **  produce report for current month average balance
      *
     C                   EXSR      STAVDD
     C                   END
      *
     C                   ENDSR
      *
     C/EJECT
      *****************************************************************
      * STAVRM - Stamp Tax on Retail Average Balances: EOM  PROCESS
      *
      * Called From: STAVRE
      *
      * Calls:       None
      *****************************************************************
      *
     C     STAVRM        BEGSR
      *
      ** Set work-fields
     C                   MOVE      F1CCY         @ECCY
     C                   MOVE      F1CCY         ECCY
     C                   CLEAR                   @PRT
     C                   CLEAR                   @PRBCK
      *
     C                   MOVE      'Y'           @PMRUN
     C                   Z-ADD     0             @RHISD
      *
      ** Read retail historic file
     C                   MOVE      *OFF          *IN41
     C     STHISS        SETLL     REHISDL
     C     STHIS         READE     REHISDL                                41
      *
      ** - SET Initial values
      ** - calculate start/end date (@STPER/@ENPER) of the period
      ** - where the posting date falls
      ** - Set Initial Balance
      *
     C                   Z-ADD     HISD          @LSTDT
     C                   Z-ADD     HISD          ZDAYNO
     C                   EXSR      STSEDT
     C                   Z-ADD     HISB          @CURBL
     C                   Z-ADD     HISB          @OPNBL
      *
      ** Loop on RE Hist/File: read all records for the a/c processed
      *
     C     *IN41         DOWEQ     *OFF
     C     HISD          ANDLT     @SCMDT
      *
      ** ....calculate: (Dr Bal * nr of days) and add to @TOTBL
     C                   EXSR      STBALN
     C     STHIS         READE     REHISDL                                41
      *
     C                   ENDDO
      *
      ** calculate Balance/Tax for period
     C                   EXSR      STBALN
      *
     C                   ENDSR
      *
     C/EJECT
      *****************************************************************
      * STAVRD - Stamp Tax on Retail Average Balances: DAILY PROCESS
      *          This routine calculates the Average Balance from
      *          Start of Current Month (run date month) up to
      *          Run Date. Each day this total is calculated and
      *          printed, together with the total tax paid up to
      *          lat end of month and average balance at last end
      *          of month.
      *          At end of month the stamp tax is calculated on the
      *          average balance, the account key is generated and
      *          a record is output to SDSTMDPD with record type 'T'.
      *
      * Called From: STAVRE
      *              STAVRM
      *
      * Calls:       STBALN
      *****************************************************************
      *
     C     STAVRD        BEGSR
      *
      ** set work-fields
     C                   CLEAR                   @PMRUN
     C                   CLEAR                   @CURBL
     C                   CLEAR                   @TOTBL
     C                   CLEAR                   @CLOBL
     C                   CLEAR                   @OPNBL
     C                   CLEAR                   @AVGBL
     C                   CLEAR                   @TAXE
     C                   CLEAR                   @CALTX
      *
      ** set currency from GLACNTQD
     C                   MOVE      F1CCY         ECCY
     C                   MOVE      F1CCY         @ECCY
      *
     C                   MOVE      *OFF          *IN41
     C                   Z-ADD     1             @SEQ2
      *
      ** Position on REHISPD with Start of Current Month
      ** start dates
      ** @SCMDT - Start of current month
      ** @ECMDT - End of current month
      *
     C                   Z-ADD     @SCMDT        @RHISD
     C                   Z-ADD     @SCMDT        @LSTDT
     C                   Z-ADD     @SCMDT        @STPER
      ** end period
     C                   Z-ADD     @ECMDT        @ENPER
     C     @CLOSE        IFEQ      'Y'
     C     @ENPER        ANDGT     DACC
     C                   Z-ADD     DACC          @ENPER
     C                   END
      *
      ** get opening balance
     C     STHISS        SETLL     REHISDL
     C     STHIS         READPE    REHISDL                                75
     C     *IN75         IFEQ      *OFF
     C                   Z-ADD     HISB          @OPNBL
     C                   END
      *
     C     STHISS        SETGT     REHISDL
      *
      ** read previous record to retrieve outstanding balance at
      ** start of running month
     C     STHIS         READPE    REHISDL                                75
     C     *IN75         IFEQ      *OFF
     C                   Z-ADD     HISB          @CURBL
     C                   Z-ADD     HISB          @CLOBL
     C                   END
     C     STHISS        SETLL     REHISDL
      *
     C     STHIS         READE     REHISDL                                41
      *
      ** Read RE Postings and Sum Balances:
      ** ---------------------------------
      *
     C     *IN41         DOWEQ     *OFF
     C                   EXSR      STBALN
     C     STHIS         READE     REHISDL                                41
     C                   ENDDO
      *
      ** Calculate from last position to end of period
     C                   EXSR      STBALN
      *
      ** Check IF Stamp Tax already posted this month
     C                   EXSR      STPOST
      *
      ** Print Up to Date Average Balance (GL008131P2)
     C                   EXSR      STPRI2
      *
      ** If End of Month or Close of the account, then calculate
      ** tax and generate a/ck entries else just update Avg.Bal
      *
     C     @EOM          IFEQ      'Y'
     C     @CLOSE        OREQ      'Y'
      *
      ** calculate tax
      *
     C     @TAXE         IFNE      *ZEROS
      *
      ** convert tax to Stamp Tax and Base ccy
     C                   EXSR      STCONV
      *
      ** Generate Dr Avg Bal Stamp Tax a/c keys
     C                   EXSR      STACKY
      *
     C                   END
      *
     C                   END
      *
     C                   ENDSR
      *
     C/EJECT
      *****************************************************************
      * STAVDM - Stamp Tax on DL/LE Average Balances: EOM  PROCESS
      *
      * Called From: STAVDL
      *
      * Calls:
      *****************************************************************
      *
     C     STAVDM        BEGSR
      *
      ** set work-fields
     C                   MOVE      T3ECCY        @ECCY             3
     C                   MOVE      T3ECCY        ECCY
     C                   CLEAR                   @PRT
     C                   CLEAR                   @PRBCK
      *
     C                   MOVE      'Y'           @PMRUN
     C                   Z-ADD     0             @SEQ2
     C                   Z-ADD     0             @T3VAL
     C                   Z-ADD     0             @LSTDT
     C                   Z-ADD     0             @NXTDT
      *
     C                   MOVE      *OFF          *IN41
     C     STHPM         SETLL     GLHPMPL1
     C     STHPP         READE     GLHPMPL1                               41
      *
      * - SET Initial values
      * - calculate start/end date (@STPER/@ENPER) of the period
      * - where the posting date falls
      * - Set Initial Balance
      *
     C                   Z-ADD     HISD          @LSTDT
     C                   Z-ADD     HISD          ZDAYNO
     C                   EXSR      STSEDT
     C                   Z-ADD     HISB          @CURBL
     C                   Z-ADD     HISB          @OPNBL
      *
      ** Loop on RE Hist/File: read all records for the a/c processed
      *
     C     *IN41         DOWEQ     *OFF
     C     HISD          ANDLT     @SCMDT
      *
      ** ....calculate: (Dr Bal * nr of days) and add to @TOTBL
     C                   EXSR      STBALN
     C     STHPP         READE     GLHPMPL1                               41
      *
     C                   ENDDO
      *
      ** calculate (Dr Bal * nr dd) from last position to end of period
     C                   EXSR      STBALN
      *
     C                   ENDSR
      *
     C/EJECT
      *****************************************************************
      * STAVDD - Stamp Tax on Lending/Dealing:
      *          Calculate Stamp Tax for current month
      *
      * Called From: STAVDL
      *
      * Calls:
      *****************************************************************
      *
     C     STAVDD        BEGSR
      *
      ** set work-fields
     C                   MOVE      T3ECCY        ECCY
     C                   MOVE      T3ECCY        @ECCY             3
     C                   MOVE      *OFF          *IN41
     C                   Z-ADD     1             @SEQ2
     C                   CLEAR                   @PMRUN
     C                   CLEAR                   @CURBL
     C                   CLEAR                   @TOTBL
     C                   CLEAR                   @CLOBL
     C                   CLEAR                   @OPNBL
     C                   CLEAR                   @AVGBL
     C                   CLEAR                   @TAXE
     C                   CLEAR                   @CALTX
      *
      ** Position on GLHPMPL1 with Start of Current Month
      ** start dates
      ** @SCMDT - Start of current month
      ** @ECMDT - End of current month
      *
     C                   Z-ADD     @SCMDT        @T3VAL
     C                   Z-ADD     @SCMDT        @LSTDT
     C                   Z-ADD     @SCMDT        @STPER
      ** end period
     C                   Z-ADD     @ECMDT        @ENPER
     C     @CLOSE        IFEQ      'Y'
     C     @ENPER        ANDGT     DACC
     C                   Z-ADD     DACC          @ENPER
     C                   END
      ** get opening balance
     C     STHPM         SETLL     GLHPMPL1
     C     STHPP         READPE    GLHPMPL1                               75
     C     *IN75         IFEQ      *OFF
     C                   Z-ADD     HISB          @OPNBL
     C                   END
      *
     C     STHPM         SETGT     GLHPMPL1
      *
      ** read previous record to retrieve outstanding balance at
      ** start of running month
     C     STHPP         READPE    GLHPMPL1                               75
     C     *IN75         IFEQ      *OFF
     C                   Z-ADD     HISB          @CURBL
     C                   Z-ADD     HISB          @CLOBL
     C                   END
     C     STHPM         SETLL     GLHPMPL1
      *
     C     STHPP         READE     GLHPMPL1                               41
      *
      ** Read DL/LE Principal change Movements
      ** ---------------------------------------
      *
     C     *IN41         DOWEQ     *OFF
     C                   EXSR      STBALN
     C     STHPP         READE     GLHPMPL1                               41
     C                   ENDDO
      *
      ** calculate from last position to end of period
     C                   EXSR      STBALN
      *
      ** Check IF Stamp Tax already posted this month
     C                   EXSR      STPOST
      *
      ** Print Up to Date Average Balance (GL008131P2)
     C                   EXSR      STPRI2
      *
      ** If End of Month or Close of the account, then calculate
      ** tax and generate a/ck entries
      *
     C     @EOM          IFEQ      'Y'
     C     @CLOSE        OREQ      'Y'
      *
      ** generate account keys and update files
     C     @TAXE         IFNE      *ZEROS
      *
      ** convert tax to Stamp Tax and Base ccy
     C                   EXSR      STCONV
      *
      ** Generate Dr Avg Bal Stamp Tax a/c keys
     C                   EXSR      STACKY
      *
     C                   END
     C                   END
      *
     C                   ENDSR
      *
     C/EJECT
      *****************************************************************
      * STBALN - Calculate Current Balance * Nr of Days
      *
      * Called From: STAVRD
      *
      * Calls:
      *****************************************************************
      *
     C     STBALN        BEGSR
      *
      ** Start Date set to Start of period if earlier than this
      *
     C     @LSTDT        IFLT      @STPER
     C                   Z-ADD     @STPER        @LSTDT
     C                   END
      *
      ** Next Date set to next movement date read from file
      *
     C                   Z-ADD     HISD          @NXTDT
      *
      ** Next date set to start of period if this is greater
      *
     C     @NXTDT        IFLT      @STPER
     C                   Z-ADD     @STPER        @NXTDT
     C                   END
      *
      ** Next Date is set to end of period if this is earlier than next
      ** movement date read from file
     C     @NXTDT        IFGT      @ENPER
     C     *IN41         OREQ      *ON
     C                   Z-ADD     @ENPER        @NXTDT
     C                   END
      *
      ** Calculate Debit Balance * Nr of days between dates and
      ** add it to Total Balance (@TOTBL)
     C     @LSTDT        IFGT      0
     C     @LSTDT        ANDLT     @NXTDT
     C     @CURBL        ANDGT     0
     C                   Z-ADD     @LSTDT        @SDT
     C                   Z-ADD     @NXTDT        @EDT
     C                   EXSR      STCLBL
     C                   END
      *
      ** Check if tax needs to be calculated and stored:
      ** ..if next movement date is greater than end of current period
      *    or if it is end of month
     C     HISD          IFGE      @ENPER
     C     *IN41         OREQ      *ON
     C                   Z-ADD     @CURBL        @CLOBL
      *
     C     @PMRUN        IFNE      'Y'
     C     @TOTBL        ANDNE     *ZEROS
     C     @PMRUN        OREQ      'Y'
     C                   EXSR      STTMON
     C                   END
      *
     C                   Z-ADD     HISD          ZDAYNO
     C                   EXSR      STSEDT
     C     *IN41         IFEQ      *OFF
     C     HISD          IFEQ      @STPER
     C                   Z-ADD     @CURBL        @OPNBL
     C                   ELSE
     C                   Z-ADD     @CURBL        @OPNBL
     C                   END
     C                   END
      *
     C                   END
      *
      ** Set Last Date
     C                   Z-ADD     HISD          @LSTDT
      *
      ** Set new Balance
      *
     C                   Z-ADD     HISB          @CURBL
      *
     C                   ENDSR
      *
     C/EJECT
      *****************************************************************
      * STTMON - Calculate Tax for the closing Month up to Start
      *          of Month where the next posting date falls
      *
      * Called From: STBALN
      *
      * Calls:       STSEDT
      *              STSTAX
      *****************************************************************
      *
     C     STTMON        BEGSR
      *
      ** set Loop Date equal to Next Movement Date, if it is end of file set Loop Date
      ** equal to end of period date
      *
     C                   Z-ADD     HISD          @LOPDT            5 0
     C     *IN41         IFEQ      *ON
     C     @PMRUN        IFEQ      'Y'
     C                   Z-ADD     @SCMDT        @LOPDT
     C                   ELSE
     C                   Z-ADD     @ECMDT        @LOPDT
     C                   END
     C                   END
      *
      ** Calculate Tax amount
      ** Loop until End of Month is greater than Next Posting Date
      *
     C     @ENPER        DOWLE     @LOPDT
      *
      ** Calculate Average Balance (Sum of Debit Balances/30)
      *
     C                   CLEAR                   @AVGBL
     C     @TOTBL        IFNE      0
     C     @TOTBL        DIV(H)    30            @WKF30           30 9
     C                   Z-ADD(H)  @WKF30        @AVGBL
     C                   END
      *
     C                   Z-ADD     @AVGBL        @GROSS
      *
      ** calculate tax and add to EoPr Month total
     C                   EXSR      STSTAX
     C                   Z-ADD     @TAXE         @EPMTX
      *
      ** Calculate Tax already posted for the processed month
      ** If adjustment is necessary then a posting will be generated
      **     and record will be printed on GL008131P2. Record will be
      **     printed anyway if it is within the 4 previous months
      *
     C     @PMRUN        CASEQ     'Y'           STBACK
     C                   END
      *
      ** calculate new start/end of period dates
      *
     C     @ENPER        IFLT      @LOPDT
     C                   Z-ADD     @ENPER        ZDAYNO
     C                   EXSR      STSEDT
      *
      ** calculate new Total Balance (@CURBL * nr of days in the month)
     C                   Z-ADD     @STPER        @SDT
     C                   Z-ADD     @ENPER        @EDT
     C                   Z-ADD     *ZEROS        @TOTBL
      *
      ** Calculate New Debit Balance if end Date is before the end of
      ** month or if the Free Amount End Date is before the end of
      ** month
      *
     C     @EDT          IFLE      @LOPDT
     C     F1FEDT        ORLE      @LOPDT
     C     F1FEDT        ANDNE     0
     C                   EXSR      STCLBL
     C                   END
      *
      ** else, set Loop date to zero to exit loop
     C                   ELSE
     C                   Z-ADD     0             @LOPDT
     C                   END
      *
     C                   ENDDO
      *
     C                   Z-ADD     *ZEROS        @TOTBL
     C                   Z-ADD     @STPER        @LSTDT
     C                   Z-ADD     @ENPER        @NXTDT
     C     HISD          IFLT      @NXTDT
     C                   Z-ADD     HISD          @NXTDT
     C                   END
      *
      ** If it is Previous month run, then calculate Balance * nr of days
      ** between Start of Current period up to Next Movement Date
      *
     C     @PMRUN        IFEQ      'Y'
     C     @CURBL        ANDGT     0
     C     HISD          ANDLT     @ENPER
     C     *IN41         ANDEQ     *OFF
     C                   Z-ADD     @LSTDT        @SDT
     C                   Z-ADD     @NXTDT        @EDT
     C                   EXSR      STCLBL
     C                   END
      *
     C                   ENDSR
      *
     C/EJECT
      *****************************************************************
      * STCLBL - Calculate Balance (Dr. Bal * Nr days)
      *
      * Called From: STBALN
      *              STTOMN
      *
      * Calls:       None
      *****************************************************************
      *
     C     STCLBL        BEGSR
      *
      * T#ADTE: is the Start Date for Tax on Average (RE/DL/LE).
      *         If this date is zero, then no check is done and the tax
      *         on Averages is always calculated. If not zero then
      *         no calculation is done for debit balances that are
      *         before this date
      *
     C     @SDT          IFGT      0
     C     @SDT          ANDLT     @EDT
     C     @EDT          ANDGT     T#ADTE
     C     @CURBL        ANDGT     0
      ** calculate nr days between dates
      ** ...use T#ADTE if Start Date is earlier than T#ADTE
     C     @SDT          IFLT      T#ADTE
     C                   Z-ADD     T#ADTE        @SDT
     C                   END
      *
     C     @EDT          SUB       @SDT          @NRDAY
     C     @NRDAY        IFGT      31
     C                   Z-ADD     31            @NRDAY
     C                   END
      ** ---------------------------
      ** Free Amount Process - Start
      ** ---------------------------
     C     T#KEY         IFEQ      'ACCOUNT   '
     C                   CLEAR                   @DEBBL
     C                   CLEAR                   @NDAYF
     C                   Z-ADD     F1FREE        @TXFRE
     C                   Z-ADD     F1FEDT        @TXFDT
     C     @TXFDT        IFEQ      @SDT
     C                   ADD       1             @TXFDT
     C                   END
      *
      ** Process only if Free Amount is not zero and Free Amount End
      ** Date is not in the past.
      *
     C     F1FREE        IFNE      0
     C     F1FEDT        ANDGE     @SDT
      *
      ** If Free Amount End Date is before End of Period, then
      **    calculate nr of "Free days"
      *
     C     F1FEDT        IFLE      @EDT
     C     @TXFDT        SUB       @SDT          @NDAYF
     C                   ELSE
     C                   Z-ADD     @NRDAY        @NDAYF
     C                   END
      *
      ** (Free Amount) * (Nr of Free days)
      ** (Current Debit Balance) * (Nr of Free days)
      *
     C     F1FREE        MULT      @NDAYF        @TXFRE
     C     @CURBL        MULT      @NDAYF        @DEBBL
      *
      ** Deduct Free Amount from Current Debit balance, if it is still
      ** Dr then add it to Total Debit Amount
     C     @DEBBL        SUB       @TXFRE        @BALAN
     C     @BALAN        IFGT      0
     C                   ADD       @BALAN        @TOTBL
     C                   END
      *
      ** subract nr of "Free Days" from the Total Nr of Days
     C                   SUB       @NDAYF        @NRDAY
      *
     C                   END
      *
     C                   END
      ** -------------------------
      ** Free Amount Process - End
      ** -------------------------
      *
      ** Outstanding Debit Balance * nr of days
     C     @NRDAY        IFGT      0
     C     @CURBL        MULT      @NRDAY        @BALAN
     C                   ADD       @BALAN        @TOTBL
     C                   END
     C                   END
      *
     C                   ENDSR
      *
     C/EJECT
      *****************************************************************
      * STCLAV - Calculate Average Balance (Total Balance/30)
      *
      * Called From: STTMON
      *
      * Calls:       None
      *****************************************************************
      *
     C     STCLAV        BEGSR
      *
     C     @TOTBL        IFNE      0
     C     @TOTBL        DIV(H)    30            @WKF30           30 9
     C                   Z-ADD(H)  @WKF30        @AVGBL
     C                   END
      *
     C                   Z-ADD     @AVGBL        @GROSS
      *
     C                   ENDSR
      *
     C/EJECT
      *****************************************************************
      * STSTAX - Calculate Stamp Tax
      *
      * Called From: STDBRE
      *              STTMON
      *              STAVRM
      *
      * Calls:       None
      *****************************************************************
      *
     C     STSTAX        BEGSR
      *
      * ....Retrieve Stamp Tax Rate/Ccy at Value Date of Posting
     C                   EXSR      STTXRT
      *
      * ....Retrieve details of currencies involved
     C                   EXSR      STCCYD
      *
      * ....Calculate Stamp Tax
      * The tax amount is calculated on the amount of the Debit
      * Interest, the tax rate is the effective rate at the Value Date.
      *
     C                   Z-ADD(H)  0             @TAXE
     C     @GROSS        IFNE      0
     C     @TXRAT        ANDNE     0
     C     @GROSS        MULT      @TXRAT        @@TAX            30 9
     C                   Z-ADD(H)  @@TAX         @TAXE
      *
     C                   END
      *
     C                   ENDSR
      *
     C/EJECT
      *****************************************************************
      * STTXRT - Retrieve Tax Rate and Ccy
      *
      * Called From: STDBTX
      *
      * Calls:       None
      *****************************************************************
      *
     C     STTXRT        BEGSR
      *
      ** Set Tax work-fields
      *
     C                   Z-ADD     *ZEROS        @TAXB
     C                   Z-ADD     *ZEROS        @TAXD
     C                   Z-ADD     *ZEROS        @TAXS
      *
     C                   MOVE      *ZEROS        @TXRAT           13 8
     C                   MOVE      *BLANKS       @TXCCY            3
     C                   MOVE      *BLANKS       U#MOD            10
      *
      ** For Debit Interest the Tax Rate and currency is retrieved
      ** at the Value Date of the Debit Interest Posting.
      ** ...RE Debit Interest = Value Date
     C     @SRNAM        IFEQ      'STDBRE'
     C                   Z-ADD     VALD          U#DATE
     C                   MOVE      *BLANKS       U#TXTY            1
      *
     C                   ELSE
     C*****@SRNAM        IFEQ      'STAVBL'                                                 AR853257
     C     @SRNAM        IFEQ      'STAVRE'                                                 AR853257
     C     @SRNAM        OREQ      'STAVDL'                                                 AR853257
      *
      ** ...rate type is 'Balance'
     C                   MOVE      'B'           U#TXTY            1
      *
      ** Retrieve Tax at end of month (@ENPER contains start of
      ** following month)
      *
     C     @ENPER        SUB       1             U#DATE            5 0
     C     @CLOSE        IFEQ      'Y'
     C     U#DATE        ANDGT     DACC
     C                   Z-ADD     DACC          U#DATE
     C                   END
      *
     C                   ENDIF
     C                   ENDIF
      *
     C     @SRNAM        IFEQ      'STCHCO'
     C                   Z-ADD     BJRDNB        U#DATE
      *
      ** ...rate type is 'charges and commissions'
     C                   MOVE      'C'           U#TXTY
     C                   ENDIF
      *
      ** Do not retrieve tax rate if Date is earlier than take on date
      *
     C     U#DATE        IFGT      DATRAT
     C     U#DATE        ANDGT     CQSTD
      *
      * Call SD008140 to retrieve the rate: the program receives
      *   The module Tax Rate/Ccy will be used, if existing otherwise
      *   they are overridden by the CONTROL tax rate/ccy
      *
      ** Set calling parameters:
      *
     C                   MOVEL     T#KEY         U#MOD
     C     U#MOD         IFEQ      'DEAL   '
     C**********         MOVEL     F1DTYP        U#TYPE            4                        AR821972
     C**********         MOVE      F1DSTP        U#TYPE                                     AR821972
     C                   MOVEL     F1DTYP        U#TYPE           10                        AR821972
     C                   EVAL      %SUBST(U#TYPE:3:2) = F1DSTP                              AR821972
     C                   END
      *
     C     U#MOD         IFEQ      'LOAN   '
     C**********         MOVEL     LQLTYP        U#TYPE            4                        AR821972
     C**********         MOVE      LQLSTP        U#TYPE                                     AR821972
     C                   EVAL      U#TYPE =  LQLTYP                                         AR821972
     C                   EVAL      %SUBST(U#TYPE:3:2) = LQLSTP                              AR821972
     C                   END
      *
      * if module is ACCOUNT, set it to 'RETAIL'
      *
     C     U#MOD         IFEQ      'ACCOUNT'
     C                   MOVEL     'RETAIL '     U#MOD
     C                   MOVE      F1ACOD        U#TYPE
     C                   END
      *
     C                   Z-ADD     *ZEROS        U#CTAX           13 8
     C                   Z-ADD     *ZEROS        U#MTAX           13 8
     C                   MOVE      *BLANKS       U#CCCY            3
     C                   MOVE      *BLANKS       U#MCCY            3
     C                   MOVE      *BLANKS       U#CSCC            2
     C                   MOVE      *BLANKS       U#MSCC            2
      *
     C                   CALL      'SD008140'
     C                   PARM                    U#DATE
     C                   PARM                    U#MOD
     C                   PARM                    U#TYPE
     C                   PARM                    U#CTAX
     C                   PARM                    U#MTAX
     C                   PARM                    U#CCCY
     C                   PARM                    U#MCCY
     C                   PARM                    U#CSCC
     C                   PARM                    U#MSCC
     C                   PARM                    U#TXTY
      *
     C                   MOVE      U#MTAX        @TXRAT
     C                   MOVE      U#MCCY        @TXCCY
      * ...Event Date
     C     @TXRAT        IFEQ      0
     C     @SRNAM        IFEQ      'STDBRE'
     C                   MOVE      U#CTAX        @TXRAT
     C                   ENDIF
     C                   MOVE      U#CCCY        @TXCCY
     C                   END
     C                   END
      *
     C                   ENDSR
      *
     C/EJECT
      *****************************************************************
      * STROUT - Set fields for output to Historic/Details Stamp Tax
      *          file
      *
      * Called From: STAVRD Retail Average Balance - Daily process
      *              STACKY RE Debit Int Stamp Tax a/c key generation
      *
      * Calls:       None
      *****************************************************************
      *
     C     STROUT        BEGSR
      *
      * Clear Format
     C                   CLEAR                   @STMDV0
      *
      * Set Common fields
      *
     C                   MOVE      T#KEY         T2KEY
     C     T#KEY         IFEQ      'LOAN      '
     C                   MOVE      LQLNRF        T2LNRF
     C                   ELSE
     C**********         Z-ADD     0             T2LNRF                                       CLE148
     C                   MOVE      *BLANKS       T2LNRF                                       CLE148
     C                   END
     C                   MOVE      *BLANKS       T2FCNM
     C                   Z-ADD     0             T2FACT
     C                   Z-ADD     0             T2FCNO
     C                   Z-ADD     0             T2FSEQ
     C                   Z-ADD     0             T2ORED
     C     T#KEY         IFEQ      'DEAL      '
     C                   MOVE      F1DLNO        T2DLNO
     C                   ELSE
     C                   Z-ADD     0             T2DLNO
     C                   END
     C                   MOVE      *BLANKS       T2TDRF
     C     T#KEY         IFEQ      'ACCOUNT   '
     C                   MOVE      F1BRCA        T2BRCA
     C                   MOVE      F1CNUM        T2CNUM
     C                   MOVE      F1CCY         T2CCY
     C                   MOVE      F1ACOD        T2ACOD
     C                   MOVE      F1ACSQ        T2ACSQ
     C                   ELSE
     C                   MOVE      *BLANKS       T2BRCA
     C                   MOVE      *BLANKS       T2CNUM
     C                   MOVE      *BLANKS       T2CCY
     C                   Z-ADD     0             T2ACOD
     C                   Z-ADD     0             T2ACSQ
     C                   END
     C                   MOVE      *BLANKS       T2PREF
     C                   Z-ADD     0             T2CQSQ
     C                   MOVE      *BLANKS       T2PBRC
     C                   MOVE      *BLANKS       T2PSSH
     C                   MOVE      *BLANKS       T2PCPY
     C                   Z-ADD     0             T2PDUD
     C                   MOVE      *BLANKS       T2PEVT
     C                   Z-ADD     @SEQ2         T2ASEQ
     C                   MOVE      'T'           T2RCTP
     C                   MOVE      'Y'           T2TPAY
      *
     C                   Z-ADD     EDAT          T2CDTE
     C                   Z-ADD     EDAT          T2VALD
     C                   Z-ADD     BKAPDT        T2PSDT
     C                   Z-ADD     BKAPDT        T2LCD
     C                   MOVE      'I'           T2TYLC
      *
     C                   Z-ADD     @TAXE         T2TATC
     C                   Z-ADD     @TAXS         T2TASC
     C                   Z-ADD     @TAXD         T2TADC
     C                   Z-ADD     @TXRAT        T2TXRT
     C                   Z-ADD     @TXRAT        T2TXRB
     C                   Z-ADD     @GROSS        T2GROS
      *
      * set spot rates
     C                   Z-ADD     ZRATEE        T2ESPR
     C                   Z-ADD     ZRATET        T2SSPR
     C                   Z-ADD     ZRATED        T2DSPR
      *
     C                   MOVE      @TECCY        T2ECCY
     C                   MOVE      @TXCCY        T2SCCY
      *
      * Set remaining fields for Debit Interest
      *
     C     @SRNAM        IFEQ      'STDBRE'
     C                   MOVE      'Y'           T2STFI
     C                   Z-ADD     *ZEROS        T2TXRB
     C                   ELSE
     C                   Z-ADD     @AVGBL        T2GROS
     C                   Z-ADD     @AVGBL        T2AVBL
     C                   Z-ADD     @OPNBL        T2STBL
     C                   Z-ADD     @CLOBL        T2ENBL
      *
      * set start/end dates
      *
     C     @PMRUN        IFEQ      'Y'
     C                   Z-ADD     @SPMDT        T2STDT
     C     @SCMDT        SUB       1             T2ENDT
     C                   ELSE
     C                   Z-ADD     @SCMDT        T2STDT
     C     @ECMDT        SUB       1             T2ENDT
     C                   END
      *
     C                   MOVE      'Y'           T2STFB
     C                   END
      *
      * convert Action Date to ccyymmdd
     C                   Z-ADD     T2CDTE        @@DAYN
     C                   EXSR      ZDATE9
     C                   MOVE      @@VDT         T2DATE
      *
      * Write SDSTMDPD file
      *
      * Set UDF Flag
     C                   MOVE      *BLANKS       T2UDCF
      *
      * Set Debit Account
     C                   MOVE      T#DBRC        T2DBRC
     C                   MOVE      T#DCST        T2DCST
     C                   MOVE      T#DCCY        T2DCCY
     C                   MOVE      T#DACD        T2DACD
     C                   MOVE      T#DASC        T2DASQ
     C                   MOVE      AKEY          T2AKEY
     C                   MOVE      AKEY          T2ETYP
     C                   MOVE      REVI          T2REVI
     C                   MOVEL     @XRATE        T2XRAT                                     AR879983
      *
     C                   WRITE     @STMDV0
      *
     C                   ENDSR
      *
     C/EJECT
      *****************************************************************
      * STCCYD - Stamp Tax: Get details of currencies involved
      *
      * Called From: STDBRE
      *
      * Calls:
      *****************************************************************
      *
     C     STCCYD        BEGSR
      *
     C                   CLEAR                   ZRATET
     C                   CLEAR                   ZMDIT
     C                   CLEAR                   ZINCYT
     C                   CLEAR                   ZNBDPT
      *
     C                   CLEAR                   ZRATEE
     C                   CLEAR                   ZMDIE
     C                   CLEAR                   ZINCYE
     C                   CLEAR                   ZNBDPE
      *
     C                   CLEAR                   ZRATED
     C                   CLEAR                   ZMDID
     C                   CLEAR                   ZINCYD
     C                   CLEAR                   ZNBDPD
      *
      * retrieve Stamp Tax ccy details
      *
     C     @TXCCY        IFNE      *BLANKS
     C                   MOVE      @TXCCY        @AJCD
     C                   Z-ADD     53            @DBERR
     C                   EXSR      AOCCY
     C                   Z-ADD     A6SPRT        ZRATET
     C                   MOVE      A6MDIN        ZMDIT
     C                   MOVE      A6INCY        ZINCYT
     C                   MOVE      A6NBDP        ZNBDPT
     C                   END
      *
      * Currency of Transaction
      *
     C                   CLEAR                   @TECCY
     C     @ECCY         IFNE      *BLANKS
     C                   MOVE      @ECCY         @TECCY
     C                   MOVE      @ECCY         @AJCD
     C                   Z-ADD     54            @DBERR
     C                   EXSR      AOCCY
     C                   Z-ADD     A6SPRT        ZRATEE
     C                   MOVE      A6MDIN        ZMDIE
     C                   MOVE      A6INCY        ZINCYE
     C                   MOVE      A6NBDP        ZNBDPE
     C                   END
      *
      * Debit Account CCY details (Stamp Tax Debit Account)
      *
     C     T#DCCY        IFNE      *BLANKS
     C                   MOVE      T#DCCY        @AJCD
     C                   Z-ADD     55            @DBERR
     C                   EXSR      AOCCY
     C                   Z-ADD     A6SPRT        ZRATED
     C                   MOVE      A6MDIN        ZMDID
     C                   MOVE      A6INCY        ZINCYD
     C                   MOVE      A6NBDP        ZNBDPD
     C                   END
      *
     C                   ENDSR
      *
     C/EJECT
      *****************************************************************
      * STCONV - Stamp Tax: Calculate Stamp Tax amount on Debit
      *                     Interest and Average Balance
      *
      * Called From: STDBTX - Tax on Debit Interest
      *
      * Calls:       XCAMT  - Conversion of amount in different ccy
      *****************************************************************
      *
     C     STCONV        BEGSR
      *
     C                   Z-ADD     1             @XRATE                                     AR879983
      * Set Amounts for currencies that match
     C     @TAXE         IFNE      *ZEROS
      *
      * Convert From Event CCY (@TAXE) to Debit Account CCY (@TAXD)
      *
     C                   Z-ADD     @TAXE         @TAXD
     C     @ECCY         IFNE      T#DCCY
      *
      * .....move Event CCY details
     C                   MOVE      @ECCY         CCYFR
     C                   Z-ADD     ZRATEE        ZRATFR
     C                   MOVE      ZINCYE        ZINCFR
     C                   MOVE      ZNBDPE        ZNBDFR
     C                   MOVE      ZMDIE         ZMDIFR
      *
      * .....move Debit CCY details
     C                   MOVE      T#DCCY        CCYTO
     C                   Z-ADD     ZRATED        ZRATTO
     C                   MOVE      ZINCYD        ZINCTO
     C                   MOVE      ZNBDPD        ZNBDTO
     C                   MOVE      ZMDID         ZMDITO
      * .... Convert Routine
     C                   Z-ADD     @TAXE         P@FRAM
     C                   EXSR      XCAMT
     C                   MOVE      P@OUTA        @TAXD
      *
     C                   END
      *
      * Convert DrCCy Tax Amount in Stamp Tax CCY (@TXCCY)
      *
     C                   Z-ADD     @TAXD         @TAXS
     C     T#DCCY        IFNE      @TXCCY
      *
      * .....move Debit CCY details
     C                   MOVE      T#DCCY        CCYFR
     C                   Z-ADD     ZRATED        ZRATFR
     C                   MOVE      ZINCYD        ZINCFR
     C                   MOVE      ZNBDPD        ZNBDFR
     C                   MOVE      ZMDID         ZMDIFR
      *
      * .....move Tax CCY details
     C                   MOVE      @TXCCY        CCYTO
     C                   Z-ADD     ZRATET        ZRATTO
     C                   MOVE      ZINCYT        ZINCTO
     C                   MOVE      ZNBDPT        ZNBDTO
     C                   MOVE      ZMDIT         ZMDITO
      *
      * Convert Routine
      *
     C                   Z-ADD     @TAXD         P@FRAM
     C                   EXSR      XCAMT
     C                   MOVE      P@OUTA        @TAXS
      *                                                                                     AR879983
      ** Save exchange rate                                                                 AR879983
      *                                                                                     AR879983
     C                   Z-ADD     ZRATEX        @XRATE           13 8                      AR879983
      *
     C                   END
      *
      * Convert From Tax CCY (@TAXS) to Base CCY  (@TAXB)
      *
     C                   Z-ADD     @TAXS         @TAXB
     C     @TXCCY        IFNE      BJCYCD
      *
      * .....move Tax CCY details
     C                   MOVE      @TXCCY        CCYFR
     C                   Z-ADD     ZRATET        ZRATFR
     C                   MOVE      ZINCYT        ZINCFR
     C                   MOVE      ZNBDPT        ZNBDFR
     C                   MOVE      ZMDIT         ZMDIFR
      *
      * .....move Base CCY details
     C                   MOVE      BJCYCD        CCYTO
     C                   Z-ADD     ZRATEB        ZRATTO
     C                   MOVE      ZINCYB        ZINCTO
     C                   MOVE      ZNBDPB        ZNBDTO
     C                   MOVE      ZMDIB         ZMDITO
      *
      * Convert Routine
      *
     C                   Z-ADD     @TAXS         P@FRAM
     C                   EXSR      XCAMT
     C                   MOVE      P@OUTA        @TAXB
      *
     C                   END
      *
     C                   END
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      * STACKY - Output Stamp Tax Account Keys for Tax on Debit
      *          Interest for Retail Accounts
      *
      * Called From: STDBRE
      *
      * Calls:       STCNVK  Conversion Account Keys
      *              STPRIN  Produce Report
      *****************************************************************
      *
     C     STACKY        BEGSR
      *
      * Print Original Record with Debit Interest or Average amount
      *
     C                   MOVE      'Y'           @ORIGT            1
     C                   MOVE      @ECCY         ECCY
     C                   MOVE      ZNBDPE        NDECIM
     C                   EXSR      STPRIN
      *
      * set fields from extension files if it is Average Balance process
     C     @SRNAM        IFNE      'STDBRE'
     C                   Z-ADD     0             DRCR
     C                   Z-ADD     BKAPDT        VALD
      *
      * Close of Account or EoM process
     C     @CLOSE        IFEQ      'Y'
     C                   Z-ADD     DACC          VALD
     C                   ELSE
     C                   Z-ADD     @ECMDT        VALD
     C                   END
      *
      * If Previous Month run process, set end of prv month fields
     C     @PMRUN        IFEQ      'Y'
     C                   Z-ADD     @AJDAT        VALD
     C                   END
      *
     C                   END
     C*
      * set a/c key record fields
      *
     C     T#KEY         IFEQ      'ACCOUNT   '
     C                   MOVE      F1BRCA        BRCA
     C                   MOVE      F1CNUM        CNUM
     C                   ELSE
     C                   MOVE      T#DBRC        BRCA
     C                   MOVE      T#DCST        CNUM
     C                   END
      *
     C     T#KEY         IFEQ      'LOAN      '
     C                   MOVE      LQLNRF        LNNO
     C                   END
     C     T#KEY         IFEQ      'DEAL      '
     C                   MOVE      F1DLNO        DLNO
     C                   END
     C                   MOVE      *BLANKS       AKEY
     C                   MOVE      'D'           RECI
     C                   MOVE      T#DBRC        OSBR
     C                   MOVE      T#DASC        ACSQ
     C                   Z-ADD     VALD          EDAT
     C                   MOVE      VALD          VDAT
     C* Override account
     C                   MOVE      '05'          SETP
     C                   MOVE      T#DCST        OVCUST
     C                   MOVE      T#DACD        OVACOD
     C                   MOVE      T#DASC        OVACSQ
     C**********         MOVE      @OVACC        OSAC                                       AR821972
     C                   MOVEL     @OVACC        OSAC                                       AR821972
      *
      * Set Original Account
     C     T#KEY         IFEQ      'ACCOUNT   '
     C                   MOVE      F1BRCA        @OBRCA
     C                   MOVE      F1CNUM        @OCNUM
     C                   MOVE      F1CCY         @OCCY
     C                   MOVE      F1ACOD        @OACOD
     C                   MOVE      F1ACSQ        @OACSQ
     C**********         MOVE      @OTAC         OTAC                                       AR821972
     C                   MOVEL     @OTAC         OTAC                                       AR821972
     C                   END
      *
      * ... Reverse Tax if Debit Interest is credited
     C                   Z-ADD     0             REVI
     C     DRCR          IFEQ      1
     C                   Z-ADD     1             REVI
     C                   END
      *
      * module
     C                   MOVE      'RE'          MODC
      *
     C     @SRNAM        IFEQ      'STAVDL'
     C     T#KEY         IFEQ      'LOAN      '
     C                   MOVE      'LE'          MODC
     C                   ELSE
     C                   MOVE      'DL'          MODC
     C                   END
     C                   END
      *
      * OUTPUT STAMP TAX a/c KEY
      * ..... Stamp Tax in Debit account currency
     C                   Z-ADD     @TAXD         EAMT
     C                   MOVE      T#DCCY        ECCY
     C                   MOVE      ZNBDPD        NDECIM
     C                   MOVE      AKEYDR        AKEY
     C                   EXSR      WRTACK
      *
      * Print Record
     C                   EXSR      STPRIN
      *
      * ..... Stamp Tax in Stamp Tax ccy
     C                   MOVE      @TXCCY        ECCY
     C                   MOVE      ZNBDPT        NDECIM
     C                   Z-ADD     @TAXS         EAMT
     C                   MOVE      AKEYST        AKEY
     C                   EXSR      WRTACK
      *
      * Print Record
     C                   EXSR      STPRIN
      *
      * Generates Conversion Account Keys if DR Ccy and Stamp Tax Ccy
      * are different
      *
     C     T#DCCY        CASNE     @TXCCY        STCNVK
     C                   END
      *
      * UPDATE STAMP TAX FILES:
      *
      * Summary File: Add Stamp Tax posted to Tax on Interest or Tax on Average
      * -------------
      *
     C     @SRNAM        IFEQ      'STDBRE'
     C                   ADD       @TAXE         F1STAI
     C                   ELSE
     C     @SRNAM        IFEQ      'STAVBL'
     C     T#KEY         IFEQ      'LOAN      '
     C                   ADD       @TAXE         LQSTAB
     C                   ELSE
     C                   ADD       @TAXE         F1STAB
     C                   END
     C                   ELSE
     C     @SRNAM        IFEQ      'STCHCO'
     C                   ADD       @TAXE         F1STCC
     C                   END
     C                   END
     C                   END
      *
     C     @CLOSE        IFEQ      'Y'
     C     @PMRUN        ANDNE     'Y'
      *
     C     T#KEY         IFEQ      'ACCOUNT'
     C     F1CLOS        IFEQ      'C'
     C                   MOVE      'N'           F1TAX
     C                   MOVE      ' '           F1CLOS
     C                   END
     C     T3ACST        IFEQ      'C'
     C     T3DACC        ANDGT     0
     C                   MOVE      'Y'           F1CLOS
     C                   END
     C                   END
      *
     C                   END
      *
      * Hist/Details file: Output a record with the details of the
      * ------------------ Stamp Tax on Interest postings SDSTMDPD
      *
     C                   EXSR      STROUT
      *
      * Clear a/ck Output file
      *
     C                   CLEAR                   @VCLSIN
     C                   CLEAR                   @VCLSRE
     C                   CLEAR                   @VCLSDL
     C                   CLEAR                   @VCLSLE
      *
     C                   ENDSR
      *
     C/EJECT
      *****************************************************************
      * STCNVK - Generate Conversion Account keys
      *
      * Called From: STACKY
      *
      * Calls:       None
      *****************************************************************
      *
     C     STCNVK        BEGSR
      *
      * Conversion Account Keys
     C                   MOVE      '05'          SETP
     C                   MOVE      *BLANKS       OSAC
      *
      * AKEYF =  debit ccy: STVTX----F----
     C                   MOVE      AKEYF         AKEY
     C                   MOVE      T#DCCY        ECCY
     C                   MOVE      ZNBDPD        NDECIM
     C                   Z-ADD     @TAXD         EAMT
     C                   EXSR      WRTACK
      *
      * Print Record
     C                   EXSR      STPRIN
      *
      * AKEYS =  Stamp Tax CCY: STVTX----S----
     C                   MOVE      AKEYS         AKEY
     C                   MOVE      @TXCCY        ECCY
     C                   MOVE      ZNBDPT        NDECIM
     C                   Z-ADD     @TAXS         EAMT
     C                   EXSR      WRTACK
      *
      * Print Record
     C                   EXSR      STPRIN
      *
      *  ------------------------
      *  BASE CURRENCY CONVERSION
      *  ------------------------
      *
     C                   MOVE      BJCYCD        ECCY
     C                   MOVE      ZNBDPB        NDECIM
      *
      * ....AKEYA = STVTXsss-A---- (where sss is debit account currency)
     C                   MOVE      AKEYA         AKDS
     C                   MOVE      T#DCCY        AKDS68
     C                   MOVE      AKDS          AKEY
     C                   Z-ADD     @TAXB         EAMT
     C                   EXSR      WRTACK
      *
      * Print Record
     C                   EXSR      STPRIN
      *
      * ....AKEYB = STVTXsss-B---- (where sss is Stamp Tax ccy)
     C                   MOVE      AKEYB         AKDS
     C                   MOVE      @TXCCY        AKDS68
     C                   MOVE      AKDS          AKEY
     C                   EXSR      WRTACK
      *
      * Print Record
     C                   EXSR      STPRIN
      *
     C                   ENDSR
      *
     C/EJECT
      *****************************************************************
      * WRTACK - output record to account keys file according to the module
      *
      * Called From: STACKY
      *              STCNVK
      *
      * Calls:      None
      *****************************************************************
      *
     C     WRTACK        BEGSR
      *
      *  Retail Charges and Commissions
     C     @SRNAM        IFEQ      'STCHCO'
     C                   WRITE     @VCLSCC
     C                   END
      *
      *  Retail Dr. Interest
     C     @SRNAM        IFEQ      'STDBRE'
     C                   WRITE     @VCLSIN
     C                   END
      *
      *  Average on Retail
      *
     C     @SRNAM        IFEQ      'STAVRE'
     C                   WRITE     @VCLSRE
     C                   END
      *
     C     @SRNAM        IFEQ      'STAVDL'
      *  Lending
     C     T#KEY         IFEQ      'LOAN      '
     C                   WRITE     @VCLSLE
     C                   ELSE
      *  Dealing
     C                   WRITE     @VCLSDL
     C                   END
      *
     C                   END
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      * STPRIN - Print Account Key generated
      *
      * Called From: STACKY
      *              STCNVK
      *
      * Calls:      None
      *****************************************************************
      *
     C     STPRIN        BEGSR
      *
      * Set Output fields
      *
     C                   CLEAR                   @KEYRF
     C                   CLEAR                   @AKEY
     C                   MOVEL     AKEY          @AKEY
      *
     C                   MOVE      *BLANKS       @KEYRF
      *
      * Retail
     C     @SRNAM        IFEQ      'STDBRE'
     C     @SRNAM        OREQ      'STAVRE'
     C                   MOVE      F1BRCA        @RBRCA
     C                   MOVE      F1CNUM        @RCUST
     C                   MOVE      F1CCY         @RCCY
     C                   MOVE      F1ACOD        @RACOD
     C                   MOVE      F1ACSQ        @RACSQ
      *
     C                   MOVE      F1BRCA        @REPBR
     C                   MOVE      F1CNUM        @REPCU
     C                   MOVE      F1CCY         @REPCY
     C                   MOVE      F1ACOD        @REPAC
     C                   MOVE      F1ACSQ        @REPAS
     C                   MOVEL     @REACC        @KEYRF
     C                   END
      *
      * Dealing
     C     @SRNAM        IFEQ      'STAVDL'
     C     T#KEY         IFEQ      'DEAL      '
     C                   MOVEL     F1DLNO        @KEYRF
     C                   ELSE
     C                   MOVEL     LQLNRF        @KEYRF
     C                   END
     C                   END
      *
      * Posting/Value Dates
      *
     C                   Z-ADD     BKAPDT        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZADATE        @PSTDT
      *
     C                   Z-ADD     EDAT          ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZADATE        @VALDT
      *
      * Event Currency
      *
     C                   MOVE      ECCY          @CCY
      *
      * Convert Gros Amount (Event Amount)
      *
     C                   Z-ADD     @GROSS        ZFLD15
     C                   Z-ADD     ZNBDPE        ZDECS
     C                   MOVE      'J'           ZECODE
     C**********         EXSR      ZSEDIT                                                   AR853257
     C                   CALL      'ZSEDIT'                                                 AR853257
     C                   PARM                    ZFLD15                                     AR853257
     C                   PARM                    ZDECS                                      AR853257
     C                   PARM                    ZECODE                                     AR853257
     C                   PARM                    ZOUT21                                     AR853257
     C                   MOVE      ZOUT21        @EAMT
      *
      * Tax Amount in Trasaction Currency
      *
     C                   Z-ADD     EAMT          ZFLD15
     C                   Z-ADD     NDECIM        ZDECS
     C                   MOVE      'J'           ZECODE
     C**********         EXSR      ZSEDIT                                                   AR853257
     C                   CALL      'ZSEDIT'                                                 AR853257
     C                   PARM                    ZFLD15                                     AR853257
     C                   PARM                    ZDECS                                      AR853257
     C                   PARM                    ZECODE                                     AR853257
     C                   PARM                    ZOUT21                                     AR853257
     C                   MOVE      ZOUT21        @TAXO
      *
      * Tax Rate
      *
     C                   Z-ADD     0             @TAXR
     C     @TXRAT        MULT      100           @TAXR
      *
      * Debit Account
      *
     C                   MOVE      T#DBRC        @DBRCA
     C                   MOVE      T#DCST        @DCUST
     C                   MOVE      T#DCCY        @DCCY
     C                   MOVE      T#DACD        @DACOD
     C                   MOVE      T#DASC        @DACSQ
     C                   MOVE      @DEBIT        @DBACC
      *
      * Reverse Indicator
      *
     C     REVI          IFEQ      1
     C                   MOVE      'Y'           @REVIN
     C                   ELSE
     C                   MOVE      ' '           @REVIN
     C                   END
      *
      * If Date are retrieved from original record, re-set fields
      *
     C     @ORIGT        IFEQ      'Y'
      *
      *  Clear Posting and Value Date
     C                   CLEAR                   @PSTDT
     C                   CLEAR                   @VALDT
      *
      *  A/c key contains description of Original Transaction
     C                   CLEAR                   @AKEY
     C                   Z-ADD     1             @TB               1 0
     C     @SRNAM        LOOKUP    SR@(@TB)                               70
     C     *IN70         IFEQ      *ON
     C                   MOVEL     DC@(@TB)      @AKEY
     C                   END
      *
     C     @SRNAM        IFEQ      'STAVDL'
     C     T#KEY         ANDEQ     'DEAL      '
     C     F1DLNO        ANDEQ     *ZEROS
     C                   MOVEL     'DEAL'        @AKEY
     C                   END
      *
      * Posting/Value Dates are set for Retail
      *
     C     @SRNAM        IFEQ      'STDBRE'
     C                   Z-ADD     PSTD          ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZADATE        @PSTDT
      *
     C                   Z-ADD     VALD          ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZADATE        @VALDT
     C                   END
      *
      * clear Tax amount
     C                   CLEAR                   @TAXO
      *
      * allow tax rate to be printed
     C                   MOVE      *ON           *IN71
      *
     C                   ELSE
     C                   CLEAR                   @DBACC
     C                   CLEAR                   @EAMT
     C                   CLEAR                   @KEYRF
      *
     C                   END
      *
      * Write Report GL008131P1
      *
     C                   IF        @OPNREP1 = *BLANKS                                       AR833361
     C                   OPEN      GL008131P1                                               AR833361
     C                   WRITE     HEADP1                                                   AR833361
     C                   MOVE      'Y'           @OPNREP1                                   AR833361
     C                   ENDIF                                                              AR833361
     C     PRTLN1        IFGE      58
     C                   WRITE     HEADP1
     C                   END
      *
     C                   WRITE     DETDP1
      *
      * Clear Original Transaction Flag and Ind *IN71 so that tax rate is only printed
      * with the Orig. Transaction
     C                   CLEAR                   @ORIGT
     C                   MOVE      *OFF          *IN71
      *
     C                   ENDSR
      *
     C/EJECT
      *****************************************************************
      * STPRI2 - Print Up to date Average Balance
      *
      * Called From: STAVRD
      *
      * Calls:      None
      *****************************************************************
      *
     C     STPRI2        BEGSR
      *
      * Set Output fields
      *
     C                   CLEAR                   DETDP2
     C                   MOVE      *BLANKS       @PRREC            1
     C                   CLEAR                   @ORF24
      * Retail
     C     T#KEY         IFEQ      'ACCOUNT   '
     C                   MOVE      F1BRCA        @RBRCA
     C                   MOVE      F1CNUM        @RCUST
     C                   MOVE      F1CCY         @RCCY
     C                   MOVE      F1ACOD        @RACOD
     C                   MOVE      F1ACSQ        @RACSQ
     C                   MOVEL     @RETAI        @ORF24           24
      *
     C                   MOVE      F1BRCA        @REPBR
     C                   MOVE      F1CNUM        @REPCU
     C                   MOVE      F1CCY         @REPCY
     C                   MOVE      F1ACOD        @REPAC
     C                   MOVE      F1ACSQ        @REPAS
     C                   MOVEL     @REACC        @OREFR
     C                   END
      *
      * Dealing
     C     T#KEY         IFEQ      'DEAL      '
     C                   MOVEL     'DEAL'        @F11             11
     C                   MOVE      F1DLNO        @F11
     C                   MOVEL     @F11          @F15
     C                   MOVE      @ECCY         @F15             15
     C                   MOVEL     @F15          @OREFR
     C                   MOVEL     @F15          @ORF24
     C                   END
      *
     C     T#KEY         IFEQ      'LOAN      '
     C                   MOVEL     'LOAN'        @F11
     C                   MOVE      LQLNRF        @F11
     C                   MOVEL     @F11          @F15
     C                   MOVE      @ECCY         @F15
     C                   MOVEL     @F15          @OREFR
     C                   MOVEL     @F15          @ORF24
     C                   END
      *
      **move*to*GL8131PD**********************************************                      AR824348
      * Move to GLSTRPPD                                                                    AR824348
     C                   MOVEL     @ORF24        O1REFR
     C     T#KEY         IFEQ      'ACCOUNT   '
     C                   MOVE      F1BRCA        O1BRCA
     C                   MOVE      F1CNUM        O1CNUM
     C                   MOVE      F1CCY         O1CCY
     C                   MOVE      F1ACOD        O1ACOD
     C                   MOVE      F1ACSQ        O1ACSQ
     C                   END
      *
      * Start/End and Posting Date
      *
     C                   MOVE      @SCMDT        ZDAYNO
     C     @PMRUN        IFEQ      'Y'
     C                   MOVE      @STPER        ZDAYNO
     C                   END
     C                   EXSR      ZDATE2
     C                   MOVE      ZADATE        @OSTDT
      *
      **move*to*GL8131PD**********************************************                      AR824348
      * Move to GLSTRPPD                                                                    AR824348
     C                   MOVE      ZADATE        O1STDT
     C                   Z-ADD     ZDAYNO        O1STDN
      *
     C                   MOVE      BKAPDT        ZDAYNO
     C     @PMRUN        IFEQ      'Y'
     C     @ENPER        SUB       1             ZDAYNO
     C                   END
     C                   EXSR      ZDATE2
     C                   MOVE      ZADATE        @OENDT
     C                   MOVE      ZDAYNO        KO2CDT
      *
      **move*to*GL8131PD**********************************************                      AR824348
      * Move to GLSTRPPD                                                                    AR824348
     C                   MOVE      ZADATE        O1ENDT
     C                   Z-ADD     ZDAYNO        O1ENDN
      *
     C                   MOVE      BKAPDT        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZADATE        @OPSDT
      *
      **move*to*GL8131PD**********************************************                      AR824348
      * Move to GLSTRPPD                                                                    AR824348
     C                   MOVE      ZADATE        O1PSDT
     C                   Z-ADD     ZDAYNO        O1PSDN
      *
      * If There is no tax or adjustment posted, then blank Posting
      *    Date
     C     @TAXE         IFEQ      0
     C                   MOVE      *BLANKS       O1PSDT
     C                   MOVE      *BLANKS       @OPSDT
     C                   Z-ADD     0             O1PSDN
     C                   END
      *
      * Opening Balance
      *
     C     @OPNBL        IFNE      *ZEROS
     C                   Z-ADD     @OPNBL        ZFLD15
     C                   Z-ADD     ZNBDPE        ZDECS
     C                   MOVE      'J'           ZECODE
     C**********         EXSR      ZSEDIT                                                   AR853257
     C                   CALL      'ZSEDIT'                                                 AR853257
     C                   PARM                    ZFLD15                                     AR853257
     C                   PARM                    ZDECS                                      AR853257
     C                   PARM                    ZECODE                                     AR853257
     C                   PARM                    ZOUT21                                     AR853257
     C                   MOVE      ZOUT21        @OOPNB
     C     @OPNBL        IFGT      0
     C                   MOVE      'Y'           @PRREC
     C                   END
     C                   ELSE
     C                   MOVE      '0 '          @OOPNB
     C                   END
      *
      **move*to*GL8131PD**********************************************                      AR824348
      * Move to GLSTRPPD                                                                    AR824348
     C                   MOVE      @OPNBL        O1OPNB
      *
      * Current Closing Balance
      *
     C     @CLOBL        IFNE      0
     C                   Z-ADD     @CLOBL        ZFLD15
     C                   Z-ADD     ZNBDPE        ZDECS
     C                   MOVE      'J'           ZECODE
     C**********         EXSR      ZSEDIT                                                   AR853257
     C                   CALL      'ZSEDIT'                                                 AR853257
     C                   PARM                    ZFLD15                                     AR853257
     C                   PARM                    ZDECS                                      AR853257
     C                   PARM                    ZECODE                                     AR853257
     C                   PARM                    ZOUT21                                     AR853257
     C                   MOVE      ZOUT21        @OCURB
     C     @CLOBL        IFGT      0
     C                   MOVE      'Y'           @PRREC
     C                   END
     C                   ELSE
     C                   MOVE      '0 '          @OCURB
     C                   END
      *
      **move*to*GL8131PD**********************************************                      AR824348
      * Move to GLSTRPPD                                                                    AR824348
     C                   MOVE      @CLOBL        O1CURB
      *
      * Current Average Balance
      *
     C     @AVGBL        IFNE      0
     C                   Z-ADD     @AVGBL        ZFLD15
     C                   Z-ADD     ZNBDPE        ZDECS
     C                   MOVE      'J'           ZECODE
     C**********         EXSR      ZSEDIT                                                   AR853257
     C                   CALL      'ZSEDIT'                                                 AR853257
     C                   PARM                    ZFLD15                                     AR853257
     C                   PARM                    ZDECS                                      AR853257
     C                   PARM                    ZECODE                                     AR853257
     C                   PARM                    ZOUT21                                     AR853257
     C                   MOVE      ZOUT21        @OAVGB
     C     @AVGBL        IFGT      0
     C                   MOVE      'Y'           @PRREC
     C                   END
     C                   ELSE
     C                   MOVE      '0 '          @OAVGB
     C                   END
      *
      **move*to*GL8131PD**********************************************                      AR824348
      * Move to GLSTRPPD                                                                    AR824348
     C                   MOVE      @AVGBL        O1AVGB
      *
      * Current Tax calculated
      *
     C     @TAXE         IFNE      0
     C                   Z-ADD     @TAXE         ZFLD15
     C                   Z-ADD     ZNBDPE        ZDECS
     C                   MOVE      'J'           ZECODE
     C**********         EXSR      ZSEDIT                                                   AR853257
     C                   CALL      'ZSEDIT'                                                 AR853257
     C                   PARM                    ZFLD15                                     AR853257
     C                   PARM                    ZDECS                                      AR853257
     C                   PARM                    ZECODE                                     AR853257
     C                   PARM                    ZOUT21                                     AR853257
     C                   MOVE      ZOUT21        @OTAXE
     C                   MOVE      'Y'           @PRREC
     C                   ELSE
     C                   MOVE      '0 '          @OTAXE
     C                   END
      *
      **move*to*GL8131PD**********************************************                      AR824348
      * Move to GLSTRPPD                                                                    AR824348
     C                   MOVE      @TAXE         O1TAXE
     C     T#KEY         IFEQ      'LOAN      '
     C                   MOVE      @TAXE         LQTAXE
     C                   ELSE
     C                   MOVE      @TAXE         F1TAXE
     C                   END
      *
      * Total Tax paid
      *
     C     @CALTX        IFNE      0
     C                   Z-ADD     @CALTX        ZFLD15
     C                   Z-ADD     ZNBDPE        ZDECS
     C                   MOVE      'J'           ZECODE
     C**********         EXSR      ZSEDIT                                                   AR853257
     C                   CALL      'ZSEDIT'                                                 AR853257
     C                   PARM                    ZFLD15                                     AR853257
     C                   PARM                    ZDECS                                      AR853257
     C                   PARM                    ZECODE                                     AR853257
     C                   PARM                    ZOUT21                                     AR853257
     C                   MOVE      ZOUT21        @OCALT
     C                   MOVE      'Y'           @PRREC
     C                   ELSE
     C                   MOVE      '0 '          @OCALT
     C                   END
      *
      **move*to*GL8131PD**********************************************                      AR824348
      * Move to GLSTRPPD                                                                    AR824348
     C                   MOVE      @CALTX        O1CALT
      *
     C     @PRREC        IFEQ      'Y'
     C                   MOVE      'Y'           @PRBCK
     C                   END
      *
      * Write Report GL008131P2
      *
     C     @PRREC        IFEQ      'Y'
      *
      * If End of month is within last three months
     C     @ENPER        ORGT      @SBCKD
     C     @PRBCK        ANDEQ     'Y'
      *
      * Current Month
     C     @PMRUN        ORNE      'Y'
     C     @PRT          ANDEQ     'Y'
      *
     C     PRTLN2        IFGE      57
     C                   WRITE     HEADP2
     C                   END
      *
     C                   WRITE     DETDP2
     C**********         WRITE     @GL8131                                                  AR824348
     C                   WRITE     GLSTRPD0                                                 AR824348
      *
      **Update*GL8131CY*to*store*the*totals*by*ccy*********************                     AR824348
      * Update GLSTCYPD to store the totals by ccy                                          AR824348
      *
     C     @CALTX        IFNE      0
     C     @TAXE         ORNE      0
     C                   MOVE      @ECCY         KO2CCY
     C**********         CLEAR                   @GL813Y                                    AR824348
     C                   CLEAR                   GLSTCYD0                                   AR824348
     C*****STKCCY        CHAIN     GL8131CY                           80                    AR824348
     C     STKCCY        CHAIN     GLSTCYPD                           80                    AR824348
     C                   ADD       @CALTX        O2CALT
     C                   ADD       @TAXE         O2TAXE
     C     *IN80         IFEQ      *OFF
     C**********         UPDATE    @GL813Y                                                  AR824348
     C                   UPDATE    GLSTCYD0                                                 AR824348
     C                   ELSE
     C                   Z-ADD     ZRATEE        O2SPRT
     C                   Z-ADD     ZNBDPE        O2NBDP
     C                   MOVE      @ECCY         O2CCY
     C                   MOVE      KO2CDT        O2CDTE
     C                   MOVE      @OENDT        O2CDTA
     C                   MOVE      @TAXE         O2TAXE
     C**********         WRITE     @GL813Y                                                  AR824348
     C                   WRITE     GLSTCYD0                                                 AR824348
     C                   END
     C                   END
      *
     C                   END
      *
      * Write Report GL8131P2
      *
     C     @PMRUN        IFEQ      'Y'
     C     @PRREC        ANDEQ     'Y'
     C                   MOVE      'Y'           @PRT
     C                   END
      *
     C     @PMRUN        IFNE      'Y'
     C     PRTLN2        ANDLT     57
     C     @PRREC        IFEQ      'Y'
     C     @PRT          OREQ      'Y'
     C                   WRITE     DETDP3
     C                   END
     C                   END
      *
     C                   ENDSR
      *
     C/EJECT
      *****************************************************************
      * STPRCY - Print Totals by ccy
      *
      * Called From: STAVBL
      *
      * Calls:      None
      *****************************************************************
      *
     C     STPRCY        BEGSR
      *
     C                   MOVE      *OFF          *IN40
     C                   WRITE     TOTCCH
     C******LOVAL        SETLL     GL8131CY                                                 AR824348
     C     *LOVAL        SETLL     GLSTCYPD                                                 AR824348
      *
     C     *IN40         DOWEQ     *OFF
     C**********         READ      GL8131CY                               40                AR824348
     C                   READ      GLSTCYPD                               40                AR824348
      *
     C     *IN40         IFEQ      *OFF
      *
     C                   CLEAR                   TOTCCD
      *
     C     O2CALT        IFNE      0
     C                   Z-ADD     O2CALT        ZFLD15
     C                   Z-ADD     O2NBDP        ZDECS
     C                   MOVE      'J'           ZECODE
     C**********         EXSR      ZSEDIT                                                   AR853257
     C                   CALL      'ZSEDIT'                                                 AR853257
     C                   PARM                    ZFLD15                                     AR853257
     C                   PARM                    ZDECS                                      AR853257
     C                   PARM                    ZECODE                                     AR853257
     C                   PARM                    ZOUT21                                     AR853257
     C                   MOVE      ZOUT21        @O2TXP
     C                   ELSE
     C                   MOVE      '0 '          @O2TXP
     C                   END
      *
     C     O2TAXE        IFNE      0
     C                   Z-ADD     O2TAXE        ZFLD15
     C                   Z-ADD     O2NBDP        ZDECS
     C                   MOVE      'J'           ZECODE
     C**********         EXSR      ZSEDIT                                                   AR853257
     C                   CALL      'ZSEDIT'                                                 AR853257
     C                   PARM                    ZFLD15                                     AR853257
     C                   PARM                    ZDECS                                      AR853257
     C                   PARM                    ZECODE                                     AR853257
     C                   PARM                    ZOUT21                                     AR853257
     C                   MOVE      ZOUT21        @O2TXA
     C                   ELSE
     C                   MOVE      '0 '          @O2TXA
     C                   END
      *
     C     O2SPRT        IFNE      0
     C                   Z-ADD     O2SPRT        ZINPR
     C                   EXSR      ZRATE3
     C                   MOVE      ZOUTR         @O2SPR
     C                   ELSE
     C                   MOVE      '0 '          @O2SPR
     C                   END
      *
     C                   MOVE      O2CDTA        @O2CDT
     C                   MOVE      O2CCY         @O2CCY
      *
     C     PRTLN2        IFGE      57
     C                   WRITE     TOTCCH
     C                   END
      *
     C                   WRITE     TOTCCD
     C                   END
     C                   ENDDO
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      * STSEDT - Set Start/End Month for running period
      *
      * Called From: STAVRE
      *
      * Calls:       None
      *****************************************************************
      *
     C     STSEDT        BEGSR
      *
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATE         @DATE
      *
      * Start of running Period (@STPER)
      * It is the First Day of month of the month being processed
      *
     C     BJDFIN        IFEQ      'D'
     C                   Z-ADD     1             @DDAY
     C                   ELSE
     C                   Z-ADD     1             @DMON
     C                   END
      *
     C                   MOVE      @DATE         ZDATE
     C                   EXSR      ZDATE1
     C                   Z-ADD     ZDAYNO        @STPER
      *
      * End of running Period (@ENPER)
      * It is First Day of the month following the one being processed
      *
      * ....@DATE already contains Start of running period
      * ....get Start of Next Month (which is end of period)
      *
     C     BJDFIN        IFEQ      'D'
      *
     C                   ADD       1             @DMON
     C     @DMON         IFGE      13
     C                   Z-ADD     1             @DMON
     C                   ADD       1             @DYEA
     C                   END
      *
     C                   ELSE
      *
     C                   ADD       1             @DDAY
     C     @DDAY         IFGE      13
     C                   Z-ADD     1             @DDAY
     C                   ADD       1             @DYEA
     C                   END
      *
     C                   END
      *
      *  End of running period = Start of following month
     C                   MOVE      @DATE         ZDATE
     C                   EXSR      ZDATE1
     C                   Z-ADD     ZDAYNO        @ENPER
      *
      * If greater than start of Run Date MM, set Start of CM
     C     @PMRUN        IFEQ      'Y'
     C     @ENPER        IFGT      @SCMDT
     C     *IN41         ANDEQ     *ON
     C                   Z-ADD     @SCMDT        @ENPER
     C                   END
     C                   ELSE
     C     @ENPER        IFGT      @ECMDT
     C                   Z-ADD     @ECMDT        @ENPER
     C                   END
     C                   END
      *
     C                   ENDSR
      *
      *****************************************************************
      * STBACK - Calculate Tax already posted for backvaluation
      *
      * Called From: STTMON
      *
      * Calls:       None
      *****************************************************************
      *
     C     STBACK        BEGSR
      *
     C                   CLEAR                   @ESPRT
     C                   CLEAR                   @SSPRT
     C                   CLEAR                   @DSPRT
      *
     C                   CLEAR                   @CALTX
     C                   CLEAR                   @TAXE
      *
     C                   CLEAR                   @AJDAT
     C                   CLEAR                   @SEQ2
      *
     C                   CLEAR                   G2SPRT
     C                   CLEAR                   T2ECCY
     C                   CLEAR                   T2SCCY
      *
      * save Spot Rates
     C                   Z-ADD     ZRATEE        @RATEE
     C                   Z-ADD     ZRATET        @RATET
     C                   Z-ADD     ZRATED        @RATED
      *
      * Set Value/Adjustment Date
      *
     C                   Z-ADD     @ENPER        @AJDAT
      *
      * Retrieve Event Ccy Spot Rate at End of month
      *
     C     @ENPER        SUB       1             KO2CDT
     C                   MOVE      @ECCY         KO2CCY
     C     STKCCY        SETGT     SDCUHSL2
     C     KO2CCY        READPE    SDCUHSL2                               55
     C     *IN55         IFEQ      *OFF
     C                   Z-ADD     G2SPRT        @ESPRT
     C                   END
      *
      * Retrieve Stamp Tax Ccy Spot Rate at End of month
      *
     C                   MOVE      @TXCCY        KO2CCY
     C     STKCCY        SETGT     SDCUHSL2
     C     KO2CCY        READPE    SDCUHSL2                               55
     C     *IN55         IFEQ      *OFF
     C                   Z-ADD     G2SPRT        @SSPRT
     C                   END
      *
      * Retrieve Debit Ccy Spot Rate at End of month
      *
     C                   MOVE      T#DCCY        KO2CCY
     C     STKCCY        SETGT     SDCUHSL2
     C     KO2CCY        READPE    SDCUHSL2                               55
     C     *IN55         IFEQ      *OFF
     C                   Z-ADD     G2SPRT        @DSPRT
     C                   END
      *
      * set Spot Rates at backvalued date
      *
     C     @ESPRT        IFNE      *ZEROS
     C                   Z-ADD     @ESPRT        ZRATEE
     C                   END
      *
     C     @SSPRT        IFNE      *ZEROS
     C                   Z-ADD     @SSPRT        ZRATET
     C                   END
      *
     C     @DSPRT        IFNE      *ZEROS
     C                   Z-ADD     @DSPRT        ZRATED
     C                   END
      *
      * Calculate Total Tax posted between the month being affected by mon
      * backvaluation
      * ...set work/key fields
     C                   MOVE      'T'           @T2RCT
     C                   Z-ADD     @STPER        @T2CDT
      *
      * ...access Stamp Tax Historic/Details file from start of month
      *    where backvaluation has occurred
      *
     C     STKEY2        SETLL     SDSTMDL0
     C     STKEYP        READE     SDSTMDL0                               76
      *
      * ...read records T with Tax Paid indicator Y
      *    T2TATC is the Paid Tax in transaction ccy
      *
     C     *IN76         DOWEQ     *OFF
      *
     C     T2STFB        IFEQ      'Y'
     C     T2TPAY        ANDEQ     'Y'
      *
      * ... only consider records within the period being processed
      *     (@ENPER contains the Start of Following month)
     C     T2CDTE        IFGT      @STPER
     C     T2CDTE        ANDLE     @ENPER
     C                   ADD       T2TATC        @CALTX
     C                   Z-ADD     T2ASEQ        @SEQ2
      *
     C                   END
      *
     C                   END
      *
      *  read next record from stamp tax details file
     C     STKEYP        READE     SDSTMDL0                               76
     C                   ENDDO
      *
      * Adjustment is necessary if tax re-calculated up to end
      * of previous month is different from the total of tax paid
      * calculated from Stamp Tax Hist/Details file
      *   @EPMTX = Total Tax up to previous month from Retail Posting
      *   @CALTX = Total Tax up to previous month from Stamp Tax File
      *
     C     @EPMTX        SUB       @CALTX        @TAXE
      *
      *  set fields for GL8131P2 report
      *
     C                   Z-ADD     @TAXE         @TXADJ
     C                   Z-ADD     @CLOBL        @PMCLO
     C                   Z-ADD     @AVGBL        @PMAVG
     C                   Z-ADD     @EPMTX        @PMTAX
      *
      * If End of Month or Close of the account, then calculate
      * tax and generate a/ck entries
      *
     C     @EOM          IFEQ      'Y'
     C     @CLOSE        OREQ      'Y'
      *
      * Generate Postings and Update Stamp Tax Files
      *
     C     @TAXE         IFNE      *ZEROS
     C                   ADD       1             @SEQ2
      *
      * convert tax to Stamp Tax and Base ccy
     C                   EXSR      STCONV
      *
      * Generate RE Stamp Tax adjusment on averages
     C                   EXSR      STACKY
      *
     C                   END
      *
     C                   END
      *
      * Print Record if it is within the past four months or there is
      * an adjustment
     C     @TAXE         IFNE      *ZEROS
     C     @ENPER        ORGT      @SBCKD
     C     @ENPER        ANDGT     DATRAT
     C                   EXSR      STPRI2
     C                   END
      *
      * Reset Today's spot rates
      *
     C                   Z-ADD     @RATEE        ZRATEE
     C                   Z-ADD     @RATET        ZRATET
     C                   Z-ADD     @RATED        ZRATED
      *
     C                   ENDSR
      *
      *****************************************************************
      * STPOST - Check if Stamp Tax already posted this month
      *
      * Called From: STAVRD
      *
      * Calls:       None
      *****************************************************************
      *
     C     STPOST        BEGSR
      *
     C                   CLEAR                   @CALTX
     C                   Z-ADD     @TAXE         @EPMTX
      *
      * Calculate Total Tax posted between the month being affected by mon
      * backvaluation
      * ...set work/key fields
     C                   MOVE      'T'           @T2RCT
     C                   Z-ADD     @SCMDT        @T2CDT
      *
      * ...access Stamp Tax Historic/Details file from start of month
      *    where backvaluation has occurred
      *
     C     STKEY2        SETLL     SDSTMDL0
     C     STKEYP        READE     SDSTMDL0                               76
      *
      * ...read records T with Tax Paid indicator Y
      *    T2TATC is the Paid Tax in transaction ccy
      *
     C     *IN76         DOWEQ     *OFF
      *
     C     T2STFB        IFEQ      'Y'
     C     T2TPAY        ANDEQ     'Y'
      *
      * ... only consider records within the period being processed
      *     (@ENPER contains the Start of Following month)
     C     T2CDTE        IFGT      @SCMDT
     C     T2CDTE        ANDLE     @ECMDT
     C                   ADD       T2TATC        @CALTX
     C                   Z-ADD     T2ASEQ        @SEQ2
      *
     C                   END
      *
     C                   END
      *
      *  read next record from stamp tax details file
     C     STKEYP        READE     SDSTMDL0                               76
     C                   ENDDO
      *
      * Adjustment is necessary if tax already posted
      *   @EPMTX = Total Tax up to previous month from Retail Posting
      *   @CALTX = Total Tax up to previous month from Stamp Tax File
      *
     C     @EPMTX        SUB       @CALTX        @TAXE
      *
     C                   ENDSR
      *
     C/EJECT
      *****************************************************************
      * STCLRF - Clear fields
      *
      * Called From: STAVRD
      *
      * Calls:       None
      *****************************************************************
      *
     C     STCLRF        BEGSR
      *
      * clear acount  key fields
     C                   CLEAR                   AKEY
     C                   CLEAR                   AKEYDR
     C                   CLEAR                   AKEYST
     C                   CLEAR                   AKEYF
     C                   CLEAR                   AKEYS
     C                   CLEAR                   AKEYA
     C                   CLEAR                   AKEYB
      *
      * Clear Historic fields
     C                   CLEAR                   HISD
     C                   CLEAR                   HISB
     C                   CLEAR                   HISDAT
      *
      * clear start/end dates
     C                   CLEAR                   @STPER
     C                   CLEAR                   @ENPER
     C                   CLEAR                   @LSTDT
     C                   CLEAR                   @NXTDT
      *
      * clear balance fields
     C                   CLEAR                   @OPNBL
     C                   CLEAR                   @CLOBL
     C                   CLEAR                   @AVGBL
     C                   CLEAR                   @TOTBL
     C                   CLEAR                   @BALAN
     C                   CLEAR                   @CURBL
      *
      * clear tax fields
     C                   CLEAR                   @EPMTX
     C                   CLEAR                   @CALTX
     C                   CLEAR                   @TAXE
     C                   CLEAR                   @TAXS
     C                   CLEAR                   @TAXD
     C                   CLEAR                   @TAXB
      *
     C                   CLEAR                   @CLOSE
      *
      * set key fields
      *
     C                   MOVE      T#KEY         @T1KEY
     C                   CLEAR                   @T2TYP
     C     T#KEY         IFEQ      'LOAN      '
     C                   MOVE      LQLNRF        @T1LNR
     C                   ELSE
     C**********         Z-ADD     0             @T1LNR                                       CLE148
     C                   MOVE      *BLANKS       @T1LNR                                       CLE148
     C                   END
     C                   MOVE      *BLANKS       @T1FCU
     C                   Z-ADD     0             @T1FAC
     C                   Z-ADD     0             @T1FCN
     C                   Z-ADD     0             @T1FSQ
     C                   Z-ADD     0             @T1ORD
     C     T#KEY         IFEQ      'DEAL      '
     C                   MOVE      F1DLNO        @T1DLN
     C                   ELSE
     C                   Z-ADD     0             @T1DLN
     C                   END
     C                   MOVE      *BLANKS       @T1TDR
     C     T#KEY         IFEQ      'ACCOUNT   '
     C                   MOVE      F1BRCA        @T1BRC
     C                   MOVE      F1CNUM        @T1CNM
     C                   MOVE      F1CCY         @T1CCY
     C                   MOVE      F1ACOD        @T1ACO
     C                   MOVE      F1ACSQ        @T1ACS
     C                   ELSE
     C                   MOVE      *BLANKS       @T1BRC
     C                   MOVE      *BLANKS       @T1CNM
     C                   MOVE      *BLANKS       @T1CCY
     C                   Z-ADD     0             @T1ACO
     C                   Z-ADD     0             @T1ACS
     C                   END
     C                   MOVE      *BLANKS       @T1PRF
     C                   Z-ADD     0             @T1QSQ
     C                   MOVE      *BLANKS       @T1PBR
     C                   MOVE      *BLANKS       @T1PSH
     C                   MOVE      *BLANKS       @T1PCP
     C                   Z-ADD     0             @T1PDD
     C                   MOVE      *BLANKS       @T1PET
     C                   CLEAR                   @T2RCT
     C                   CLEAR                   @T2CDT
     C                   CLEAR                   @T2ASE
      *
     C                   ENDSR
      *
     C/EJECT
      *****************************************************************
      * STINIT - Initial Process
      *
      * Called From: MAIN
      *
      * Calls:       SROPEN
      *****************************************************************
      *
     C     STINIT        BEGSR
      *
      * Retrieve STAMPDA where the Take On Date is stored
      *
     C******DTAARA       DEFINE    STAMPDA       STAMDA                                     AR820695
     C     *DTAARA       DEFINE    SDSTAMPDA     STAMDA                                     AR820695
     C                   IN        STAMDA
      *
      * Define Fields
      *
     C                   MOVE      *ALL'-'       TRATT
     C                   MOVE      *ALL'-'       TRATT2
     C                   MOVE      *ALL'-'       TRAT2           198
      *
     C                   MOVE      *BLANKS       @OPNREP1          1
     C                   MOVE      *BLANKS       @OPNREP2          1
     C                   MOVE      *BLANKS       @OPNRE            1
     C                   MOVE      *BLANKS       @OPNLD            1
     C                   MOVE      *BLANKS       @CLOSE            1
     C                   MOVE      *BLANKS       AKEYDR           14
     C                   MOVE      *BLANKS       AKEYST           14
     C                   MOVE      *BLANKS       AKEYF            14
     C                   MOVE      *BLANKS       AKEYS            14
     C                   MOVE      *BLANKS       AKEYA            14
     C                   MOVE      *BLANKS       AKEYB            14
     C                   MOVE      *BLANKS       @PRT              1
     C                   MOVE      *BLANKS       @PRBCK            1
      *
     C     *LIKE         DEFINE    @TOTBL        @DEBBL
     C     *LIKE         DEFINE    @NRDAY        @NDAYF
     C     *LIKE         DEFINE    F1FEDT        @TXFDT
     C     *LIKE         DEFINE    F1FREE        @TXFRE
     C     *LIKE         DEFINE    T2PSDT        @AJDAT
     C     *LIKE         DEFINE    F1CCY         @TECCY
     C     *LIKE         DEFINE    DBASE         @DBERR
     C     *LIKE         DEFINE    T2TYPE        @T2TYP
     C     *LIKE         DEFINE    T#KEY         @T1KEY
     C     *LIKE         DEFINE    LQLNRF        @T1LNR
     C     *LIKE         DEFINE    T2FCNM        @T1FCU
     C     *LIKE         DEFINE    T2FACT        @T1FAC
     C     *LIKE         DEFINE    T2FCNO        @T1FCN
      * Fee Key
     C     *LIKE         DEFINE    T2FSEQ        @T1FSQ
     C     *LIKE         DEFINE    T2ORED        @T1ORD
      * Deal key
     C     *LIKE         DEFINE    T3DLNO        @T1DLN
      * Securities Trade Reference
     C     *LIKE         DEFINE    T2TDRF        @T1TDR
      * Account Reference
     C     *LIKE         DEFINE    F1BRCA        @T1BRC
     C     *LIKE         DEFINE    F1CNUM        @T1CNM
     C     *LIKE         DEFINE    F1CCY         @T1CCY
     C     *LIKE         DEFINE    F1ACOD        @T1ACO
     C     *LIKE         DEFINE    F1ACSQ        @T1ACS
      * Funds Transfer Payment Reference
     C     *LIKE         DEFINE    T2PREF        @T1PRF
     C     *LIKE         DEFINE    T2CQSQ        @T1QSQ
      * Position Settlement Reference
     C     *LIKE         DEFINE    T2PBRC        @T1PBR
     C     *LIKE         DEFINE    T2PSSH        @T1PSH
     C     *LIKE         DEFINE    T2PCPY        @T1PCP
     C     *LIKE         DEFINE    T2PDUD        @T1PDD
     C     *LIKE         DEFINE    T2PEVT        @T1PET
      *
      * details from Historic/Details file
     C     *LIKE         DEFINE    T2RCTP        @T2RCT
     C     *LIKE         DEFINE    T2CDTE        @T2CDT
     C     *LIKE         DEFINE    T2ASEQ        @T2ASE
     C     *LIKE         DEFINE    T2ASEQ        @SEQ2
      * Deal key
     C     *LIKE         DEFINE    T3DLNO        @T3DLN
      *
      * Loan key
     C     *LIKE         DEFINE    T3LNRF        @T3LNR
      *
      * Value Date
     C     *LIKE         DEFINE    HISD          @T3VAL
      *
      * Historic
     C     *LIKE         DEFINE    HISD          HISDAT
      *
      * Opening/Closing Balances
     C     *LIKE         DEFINE    HISB          @OPNBL
     C     *LIKE         DEFINE    HISB          @CLOBL
     C     *LIKE         DEFINE    HISB          @PMCLO
     C     *LIKE         DEFINE    HISB          @AVGBL
     C     *LIKE         DEFINE    HISB          @PMAVG
     C     *LIKE         DEFINE    HISB          @BALAN
     C     *LIKE         DEFINE    HISB          @CURBL
     C                   Z-ADD     *ZEROS        @TOTBL           30 9
      *
      * Tax
     C     *LIKE         DEFINE    HISB          @ADJTX
     C                   Z-ADD     *ZEROS        @PMTAX           30 0
     C                   Z-ADD     *ZEROS        @EPMTX           30 0
     C                   Z-ADD     *ZEROS        @CALTX           30 0
      *
      * Dates
      *
     C     *LIKE         DEFINE    HISD          @SDT
     C     *LIKE         DEFINE    HISD          @EDT
     C     *LIKE         DEFINE    HISD          @HISD
     C     *LIKE         DEFINE    HISD          @RHISD
     C     *LIKE         DEFINE    EDAT          @STPER
     C     *LIKE         DEFINE    EDAT          @ENPER
     C     *LIKE         DEFINE    EDAT          @EPMDT
     C     *LIKE         DEFINE    EDAT          @SCMDT
     C     *LIKE         DEFINE    EDAT          @ECMDT
     C     *LIKE         DEFINE    EDAT          @SPMDT
     C     *LIKE         DEFINE    EDAT          @LSTDT
     C     *LIKE         DEFINE    EDAT          @NXTDT
     C     *LIKE         DEFINE    EDAT          @NRDAY
      *
      * Work fields for tax calculation
      *
     C     *LIKE         DEFINE    EAMT          @GROSS
     C     *LIKE         DEFINE    EAMT          @TXADJ
     C     *LIKE         DEFINE    EAMT          @TAXE
     C     *LIKE         DEFINE    EAMT          @TAXB
     C     *LIKE         DEFINE    EAMT          @TAXD
     C     *LIKE         DEFINE    EAMT          @TAXS
      *
      * CCY details
      *
     C     *LIKE         DEFINE    A6CYCD        CCYFR
     C     *LIKE         DEFINE    A6CYCD        CCYTO
      *
     C     *LIKE         DEFINE    A6MDIN        ZMDIFR
     C     *LIKE         DEFINE    A6MDIN        ZMDITO
     C     *LIKE         DEFINE    A6SPRT        ZRATFR
     C     *LIKE         DEFINE    A6SPRT        ZRATTO
     C     *LIKE         DEFINE    A6INCY        ZINCFR
     C     *LIKE         DEFINE    A6INCY        ZINCTO
     C     *LIKE         DEFINE    A6NBDP        NDECIM
     C     *LIKE         DEFINE    A6NBDP        ZNBDFR
     C     *LIKE         DEFINE    A6NBDP        ZNBDTO
     C     *LIKE         DEFINE    A6SPRT        @ESPRT
     C     *LIKE         DEFINE    A6SPRT        @SSPRT
     C     *LIKE         DEFINE    A6SPRT        @DSPRT
      *
     C     *LIKE         DEFINE    A6SPRT        @RATEE
     C     *LIKE         DEFINE    A6SPRT        @RATED
     C     *LIKE         DEFINE    A6SPRT        @RATET
      *
     C     *LIKE         DEFINE    A6MDIN        ZMDI1
     C     *LIKE         DEFINE    A6MDIN        ZMDI2
     C     *LIKE         DEFINE    A6MDIN        ZMDIB
     C     *LIKE         DEFINE    A6MDIN        ZMDIE
     C     *LIKE         DEFINE    A6MDIN        ZMDIT
     C     *LIKE         DEFINE    A6MDIN        ZMDID
      *
     C     *LIKE         DEFINE    A6SPRT        ZRATEE
     C     *LIKE         DEFINE    A6SPRT        ZRATED
     C     *LIKE         DEFINE    A6SPRT        ZRATE1
     C     *LIKE         DEFINE    A6SPRT        ZRATE2
     C     *LIKE         DEFINE    A6SPRT        ZRATEB
     C     *LIKE         DEFINE    A6SPRT        ZRATET
      *
     C     *LIKE         DEFINE    A6INCY        ZINCYD
     C     *LIKE         DEFINE    A6INCY        ZINCYE
     C     *LIKE         DEFINE    A6INCY        ZINCYB
     C     *LIKE         DEFINE    A6INCY        ZINCYT
     C     *LIKE         DEFINE    A6INCY        ZINCY1
     C     *LIKE         DEFINE    A6INCY        ZINCY2
      *
     C     *LIKE         DEFINE    A6NBDP        ZNBDPD
     C     *LIKE         DEFINE    A6NBDP        ZNBDPE
     C     *LIKE         DEFINE    A6NBDP        SULNDP
     C     *LIKE         DEFINE    A6NBDP        ZNBDP1
     C     *LIKE         DEFINE    A6NBDP        ZNBDP2
     C     *LIKE         DEFINE    A6NBDP        ZNBDPB
     C     *LIKE         DEFINE    A6NBDP        ZNBDPT
     C     *LIKE         DEFINE    F1CCY         KO2CCY
     C     *LIKE         DEFINE    F1CDTE        KO2CDT
      *
      *  Work-fields
     C     *LIKE         DEFINE    CNUM          @RCNUM
     C     *LIKE         DEFINE    BRCA          @BRCA
     C                   MOVE      ' '           @PMRUN            1
     C                   MOVE      ' '           @SEL              1
     C                   MOVE      *BLANKS       @SRNAM            6
      *
      *  KEYS
     C     STKCCY        KLIST
     C                   KFLD                    KO2CCY
     C                   KFLD                    KO2CDT
      *  KCLOS
     C     KCLOS         KLIST
     C                   KFLD                    F1BRCA
     C                   KFLD                    F1CNUM
     C                   KFLD                    F1CCY
     C                   KFLD                    F1ACOD
     C                   KFLD                    F1ACSQ
      *  KEYS
     C     ACKEYK        KLIST
     C                   KFLD                    @T1CNM
     C                   KFLD                    @T1CCY
     C                   KFLD                    @T1ACO
     C                   KFLD                    @T1ACS
     C                   KFLD                    @T1BRC
      *
      * SDSTMDPD
     C     STKEY2        KLIST
     C                   KFLD                    @T1KEY
     C                   KFLD                    @T2TYP
     C                   KFLD                    @T1LNR
     C                   KFLD                    @T1FCU
     C                   KFLD                    @T1FAC
     C                   KFLD                    @T1FCN
     C                   KFLD                    @T1FSQ
     C                   KFLD                    @T1ORD
     C                   KFLD                    @T1DLN
     C                   KFLD                    @T1TDR
     C                   KFLD                    @T1BRC
     C                   KFLD                    @T1CNM
     C                   KFLD                    @T1CCY
     C                   KFLD                    @T1ACO
     C                   KFLD                    @T1ACS
     C                   KFLD                    @T1PRF
     C                   KFLD                    @T1QSQ
     C                   KFLD                    @T1PBR
     C                   KFLD                    @T1PSH
     C                   KFLD                    @T1PCP
     C                   KFLD                    @T1PDD
     C                   KFLD                    @T1PET
     C                   KFLD                    @T2RCT
     C                   KFLD                    @T2CDT
     C                   KFLD                    @T2ASE
      *
      * SDSTMDPD Partial Key
     C     STKEYP        KLIST
     C                   KFLD                    @T1KEY
     C                   KFLD                    @T2TYP
     C                   KFLD                    @T1LNR
     C                   KFLD                    @T1FCU
     C                   KFLD                    @T1FAC
     C                   KFLD                    @T1FCN
     C                   KFLD                    @T1FSQ
     C                   KFLD                    @T1ORD
     C                   KFLD                    @T1DLN
     C                   KFLD                    @T1TDR
     C                   KFLD                    @T1BRC
     C                   KFLD                    @T1CNM
     C                   KFLD                    @T1CCY
     C                   KFLD                    @T1ACO
     C                   KFLD                    @T1ACS
     C                   KFLD                    @T1PRF
     C                   KFLD                    @T1QSQ
     C                   KFLD                    @T1PBR
     C                   KFLD                    @T1PSH
     C                   KFLD                    @T1PCP
     C                   KFLD                    @T1PDD
     C                   KFLD                    @T1PET
     C                   KFLD                    @T2RCT
      *
      * Retail Historic File
      *
     C     STHIS         KLIST
     C                   KFLD                    @RBRCA
     C                   KFLD                    @RCNUM
     C                   KFLD                    @RCCY
     C                   KFLD                    @RACOD
     C                   KFLD                    @RACSQ
      *
     C     STHISS        KLIST
     C                   KFLD                    @RBRCA
     C                   KFLD                    @RCNUM
     C                   KFLD                    @RCCY
     C                   KFLD                    @RACOD
     C                   KFLD                    @RACSQ
     C                   KFLD                    @RHISD
      *
      *  Principal Movements
     C     STHPM         KLIST
     C                   KFLD                    @T3LNR
     C                   KFLD                    @T3DLN
     C                   KFLD                    @T3VAL
      *
      *  Principal Movements - Partial Key
     C     STHPP         KLIST
     C                   KFLD                    @T3LNR
     C                   KFLD                    @T3DLN
      *
     C     *DTAARA       DEFINE                  LDA
     C                   MOVEA     CPY@          BIS@             40
      *
      *  Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVE      *BLANKS       DBPGM
     C                   MOVEL     'GL008131'    DBPGM
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     @OPTN         DBKEY
     C                   Z-ADD     1             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
      *
      * Check System Date Format, DDMMYY OR MMDDYY.
      *
     C                   MOVE      *OFF          *IN98
     C     BJDFIN        IFEQ      'M'
     C                   MOVE      *ON           *IN98
     C                   END
      *
     C                   END
      *
      * Access Base Ccy details
      *
     C                   CLEAR                   ZRATEB
     C                   CLEAR                   ZMDIB
     C                   CLEAR                   ZINCYB
     C                   CLEAR                   ZNBDPB
      *
      * retrieve Stamp Tax ccy details
      *
     C     BJCYCD        IFNE      *BLANKS
     C                   MOVE      BJCYCD        @AJCD
     C                   Z-ADD     57            @DBERR
     C                   EXSR      AOCCY
     C                   Z-ADD     A6SPRT        ZRATEB
     C                   MOVE      A6MDIN        ZMDIB
     C                   MOVE      A6INCY        ZINCYB
     C                   MOVE      A6NBDP        ZNBDPB
     C                   END
      *
      ** Access General Ledger Details
      *
     C                   CALL      'AOGELRR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDGELR        PARM      SDGELR        DSFDY
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVE      *BLANKS       DBPGM
     C                   MOVEL     'GL008131'    DBPGM
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
     C                   EXSR      ZEVCD
      *
      ** Check if CAR CER049 is switched *ON.
      *
     C                   MOVE      'N'           CER049            1
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CER049 '     @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CER049            1
     C                   END
      *
      * If CAR is switched off, end program
      *
     C     CER049        IFEQ      'N'
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   END
      *
      * GL008131P1 - account keys generated
     C                   OPEN      GL008131P1
     C                   WRITE     HEADP1
     C                   MOVE      'Y'           @OPNREP1
      *
      * Ensure the P1 spool file is recorded by RCF
      *
     C                   Z-ADD     SFNUM         ZSNUM
      *
      * Call ZSFILE for GL008131P1
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
      * GL008131P2 - Up to date Average Balance report
     C                   OPEN      GL008131P2
     C                   WRITE     HEADP2
     C                   MOVE      'Y'           @OPNREP2
      *
      * Ensure the P2 spool file is recorded by RCF
      *
     C                   Z-ADD     SFNUM2        ZSNUM             6 0
      *
      * Call ZSFILE for GL008131P2
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    SEQNO             5
     C                   PARM      *BLANKS       ENTY              3
     C                   PARM                    SFILE2
     C                   PARM                    ZSNUM
     C                   PARM                    ZSERR             1
      *
      * If error in ZSFILE, exit via *PSSR
      *
     C     ZSERR         IFEQ      'Y'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * Check if End of Month Run
     C                   CALL      'SD2000'
     C                   PARM                    @EOM              1
     C                   PARM                    @EOY              1
     C                   PARM                    @ERROR            1
      *
      * Run Date converted to ddmmyy
     C                   Z-ADD     BJRDNB        ZDAYNO
     C                   EXSR      ZDATE2
      *
      * move to @DATE DS (@DDAY, @DMON, @DYEA)
      *
     C                   MOVE      ZDATE         @DATE
      *
      * Start of Current Month (@SCMDT)
      *
     C     BJDFIN        IFEQ      'D'
     C                   Z-ADD     1             @DDAY
     C                   ELSE
     C                   Z-ADD     1             @DMON
     C                   END
      *
     C                   MOVE      @DATE         ZDATE
     C                   EXSR      ZDATE1
     C                   Z-ADD     ZDAYNO        @SCMDT
      *
      * End of Current Period (@ECMDT)
      *
     C     BKAPDT        ADD       1             @ECMDT
      *
      * End of Current Month (@ECMDT) is calculated if it is end of month
      *      as Start of Previous month + 1 month
      *
     C     @EOM          IFEQ      'Y'
      *
     C     BJDFIN        IFEQ      'D'
     C                   ADD       1             @DMON
     C     @DMON         IFGE      13
     C                   Z-ADD     1             @DMON
     C                   ADD       1             @DYEA
     C                   END
      *
     C                   ELSE
      *
     C                   ADD       1             @DDAY
     C     @DDAY         IFGE      13
     C                   Z-ADD     1             @DDAY
     C                   ADD       1             @DYEA
     C                   END
      *
     C                   END
      *
      * convert to number
     C                   MOVE      @DATE         ZDATE
     C                   EXSR      ZDATE1
     C                   Z-ADD     ZDAYNO        @ECMDT
      *
     C                   END
      *
      * Start of Previous Month (@SPMDT)
      *
      * @DATE already contains Start of Current Month
     C     BJDFIN        IFEQ      'D'
      *
     C                   SUB       1             @DMON
     C     @DMON         IFLE      0
     C                   Z-ADD     12            @DMON
     C                   SUB       1             @DYEA
     C                   END
      *
     C                   ELSE
      *
     C                   SUB       1             @DDAY
     C     @DDAY         IFLE      0
     C                   Z-ADD     12            @DDAY
     C                   SUB       1             @DYEA
     C                   END
      *
     C                   END
      *
     C                   MOVE      @DATE         ZDATE
     C                   EXSR      ZDATE1
     C                   Z-ADD     ZDAYNO        @SPMDT
      *
      * End of Previous month action date
     C     @SCMDT        SUB       1             @@DAYN            5 0
     C                   EXSR      ZDATE9
     C                   MOVE      @@VDT         @PVMDT            8 0
      *
      * Calculate 3 months backvalued
     C                   Z-ADD     BJRDNB        ZDAYNO
     C                   EXSR      ZDATE2
      *
      * move to @DATE DS (@DDAY, @DMON, @DYEA)
      *
     C                   MOVE      ZDATE         @DATE
      *
      * Start of Current Month (@SCMDT)
      *
     C     BJDFIN        IFEQ      'D'
     C                   SUB       2             @DMON
     C                   Z-ADD     1             @DDAY
     C     @DMON         IFLE      0
     C                   Z-ADD     12            @DMON
     C                   SUB       1             @DYEA
     C                   END
     C                   ELSE
     C                   Z-ADD     1             @DMON
     C                   SUB       2             @DDAY
     C     @DDAY         IFLE      0
     C                   Z-ADD     12            @DDAY
     C                   SUB       1             @DYEA
     C                   END
     C                   END
      *
     C                   MOVE      @DATE         ZDATE
     C                   EXSR      ZDATE1
     C                   Z-ADD     ZDAYNO        @SBCKD            5 0
      *
     C                   MOVE      BJURPT        BJURPY
     C                   MOVE      BJMRDT        BJMRDY
      *
     C                   ENDSR
      *
     C/EJECT
      *****************************************************************
      * SRTERM - Close Input Account Keys file
      *
      * Called From: MAIN
      *
      * Calls:       None
      *****************************************************************
      *
     C     SRTERM        BEGSR
      *
      * End of Report GL008131P1 - account keys generated
      *
     C                   IF        @OPNREP1 <> *BLANKS
     C     PRTLN1        IFGE      57
     C                   WRITE     HEADP1
     C                   END
     C                   WRITE     ENDDP1
     C                   ENDIF
      *
      * End of Report GL008131P2 - Up to date Average Balance Report
      *
     C     PRTLN2        IFGE      57
     C                   WRITE     HEADP2
     C                   END
     C                   WRITE     ENDDP2
      *
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *
     C                   ENDSR
      *
     C/EJECT
      *****************************************************************
      *  XCAMT - Convert Amount                                       *
      *                                                               *
      *  Called From: STCONV                                          *
      *                                                               *
      *  Call:        ZXRATE                                          *
      *               ZCONV                                           *
      *****************************************************************
      *
     C     XCAMT         BEGSR
      *
     C                   Z-ADD     *ZEROS        P@OUTA
      *
      * From CCY is not EUR and is not an 'IN' CcY
      * ..OR To CCY is not EUR and is not an 'IN' Ccy
      *
     C     CCYFR         IFNE      'EUR'
     C     ZINCFR        ANDNE     'Y'
      *
     C     CCYTO         ORNE      'EUR'
     C     ZINCTO        ANDNE     'Y'
      *
      * ....move FROM Ccy details
     C                   Z-ADD     ZRATFR        ZRATE1
     C                   MOVE      ZMDIFR        ZMDI1
     C                   MOVE      ZNBDFR        ZNBDP1
      *
      * ....move TO Ccy details
     C                   Z-ADD     ZRATTO        ZRATE2
     C                   MOVE      ZMDITO        ZMDI2
     C                   MOVE      ZNBDTO        ZNBDP2
      *
     C                   EXSR      ZXRATE
      *
     C                   Z-ADD     ZNBDP1        ZCDPI
     C                   Z-ADD     ZNBDP2        ZCDPO
     C                   Z-ADD     P@FRAM        ZAMTCI
     C                   Z-ADD     *ZEROS        ZAMTCO
     C                   Z-ADD     ZRATEX        ZEXCH
     C                   MOVE      ZMDIX         ZMD
      *
     C                   EXSR      ZCONV
      *
     C                   Z-ADD     ZAMTCO        P@OUTA
      *
      * Conversion between EURO currencies
      *
     C                   ELSE
      *
     C                   MOVE      CCYFR         P@FRCY
     C                   MOVE      CCYTO         P@TOCY
      *
     C                   CALL      'EU0200'
      *                                                    Input:
     C                   PARM      '       '     P@RTCD            7
     C                   PARM                    P@FRAM           18 3
     C                   PARM                    P@FRCY            3
     C                   PARM                    P@TOCY            3
      *                                                    Output:
     C                   PARM                    P@OUTA           15 0
     C                   PARM                    P@INTA           18 3
     C                   PARM                    P@EXRT           15 9
     C                   PARM                    P@MDIN            1
      *
     C     @RTCD         IFNE      *BLANK
      *
     C     *LOCK         IN        LDA
     C                   MOVE      'GL008131'    DBPGM
     C                   MOVEL     'EU0200  '    DBFILE
     C                   MOVEL     P@FRCY        DBKEY1            6
     C                   MOVE      P@TOCY        DBKEY1
     C                   MOVEL     DBKEY1        DBKEY
     C                   Z-ADD     50            DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   END
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      * AOACCN - Account Code details
      *
      * Called From: STAVRE
      *
      * Calls:       AOACCTR0
      *****************************************************************
      *
     C     AOACCN        BEGSR
      *
     C                   CALL      'AOACCTR0'
     C                   PARM                    @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM                    ##ACID           10
     C                   PARM                    ##CUST            6
     C                   PARM                    ##CYCD            3
     C                   PARM                    ##ACCD           10
     C                   PARM                    ##ACSN            2
     C                   PARM                    ##BRCD            3
     C     SDACCT        PARM      *BLANK        DSSDY
      *
     C     @RTCD         IFNE      *BLANK
     C     @RTCD         OREQ      *BLANK
     C     ACRECI        ANDNE     'D'
     C                   MOVE      'N'           F1TAX
     C                   END
      *
      * Check if Account being closed today
     C                   CLEAR                   T3RECI
     C                   CLEAR                   T3BRCA
     C                   CLEAR                   T3CNUM
     C                   CLEAR                   T3CCY
     C                   CLEAR                   T3ACOD
     C                   CLEAR                   T3ACSQ
     C                   CLEAR                   T3ACST
     C                   CLEAR                   T3DACC
      *
     C     KCLOS         CHAIN     GLCLOSL0                           88
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      * AOBRCA - Branch Details
      *
      * Called From: STCHAI
      *
      * Calls:       AOBRCHR0
      *****************************************************************
      *
     C     AOBRCA        BEGSR
      *
     C                   CALL      'AOBRCHR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      @BRCA         @DSNB             3
     C     SDBRCH        PARM      SDBRCH        DSFDY
      *
      * ....error
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      *BLANKS       DBKEY
     C                   MOVEL     @BRCA         DBKEY
     C                   MOVE      *BLANKS       DBPGM
     C                   MOVEL     'GL008131'    DBPGM
     C                   MOVEL     'SDBRCHPD'    DBFILE
     C                   Z-ADD     052           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
      *
     C                   ENDSR
      *
     C/EJECT
      *****************************************************************
      *  AOCCY - Call AOCURRR0 to retrieve CCY details
      *
      *  Called From: STCCYD
      *
      *  Call:        None
      *
      *****************************************************************
      *
     C     AOCCY         BEGSR
      *
      * AOCCY  : Call to Access object AOCURRR0 for Currency Details.
      *
     C                   CALL      'AOCURRR0'
      *                                                     Input:
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @AJCD             3
      *                                                     Output:
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      ** If a record is not found, perform database Error processing.
      *
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      *BLANKS       DBPGM
     C                   MOVEL     'GL008131'    DBPGM
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     @AJCD         DBKEY
     C                   Z-ADD     @DBERR        DBASE
     C                   OUT       LDA
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
     C     WRUN          IFEQ      *BLANK
     C                   MOVE      'Y'           WRUN              1
     C                   SETON                                        U7U8
     C                   DUMP
      *
      ** Produce error report
     C                   OPEN      GL008131AU
     C                   WRITE     GL8131A1
     C                   WRITE     DBFMTAU
      *
      * Ensure the AU spool file is recorded by RCF
      *
     C                   Z-ADD     SFNUMA        ZSNUM
      *
      * Call ZSFILE for GL008131AU
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    SEQNO
     C                   PARM      *BLANKS       ENTY
     C                   PARM                    SFILEA
     C                   PARM                    ZSNUM
     C                   PARM                    ZSERR
      *
     C                   CLOSE     GL008131AU
      *
     C                   SETON                                        LR
     C                   RETURN
     C                   END
      *
      ** Exit program.
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *
     C/EJECT
      ********************************************************************
     C     ZDATE1        BEGSR
      ********************************************************************
      **
      **   ZDATE1 SR. TO VALIDATE DATES SUBMITTED AND
      **              CONVERT TO A NUMBER OF DAYS.
      **
      **   THE YEAR 2000, BEING DIVISIBLE BY 400, IS A LEAP YEAR.
      **
      **   CLEAR DAY NUMBER. RESET ERROR INDICATOR
     C                   Z-ADD     0             ZDAYNO            5 0
     C                   SETOFF                                       99
      **
      **   CALCULATION TO DEFINE INPUT DATE FIELD.
     C                   Z-ADD     ZDATE         ZDATE             6 0
      **
      **   GET INDIVIDUAL DAY, MONTH AND YEAR FIELDS.
     C                   MOVE      ZDATE         ZYEAR             2 0
     C  N98              MOVEL     ZDATE         ZDAY              2 0
     C   98              MOVEL     ZDATE         ZMTH              2 0
     C                   MOVE      ZDATE         ZWRK4             4 0
     C  N98              MOVEL     ZWRK4         ZMTH
     C   98              MOVEL     ZWRK4         ZDAY
      **
      **   ENSURE MONTH IS VALID. BYPASS IF ERROR
     C     ZMTH          IFLE      0
     C     ZMTH          ORGT      12
     C                   SETON                                        99
     C                   GOTO      ZDEND1
     C                   END
      **
      **   ENSURE DAY IS VALID. BYPASS IF ERROR
     C     ZDAY          IFLE      0
     C                   SETON                                        99
     C                   GOTO      ZDEND1
     C                   END
      **
      **   CHECK FOR 30 DAY MONTHS. BYPASS IF ERROR
     C     ZMTH          IFEQ      4
     C     ZMTH          OREQ      6
     C     ZMTH          OREQ      9
     C     ZMTH          OREQ      11
     C**
     C     ZDAY          IFGT      30
     C                   SETON                                        99
     C                   GOTO      ZDEND1
     C                   END
     C**
     C                   ELSE
      **
      **   CHECK FOR 31 DAY MONTHS (ALL OTHERS BUT FEB). BYPASS IF ERROR
     C     ZDAY          IFGT      31
     C     ZMTH          ANDNE     2
     C                   SETON                                        99
     C                   GOTO      ZDEND1
     C                   END
      **
     C                   END
      **
      **   CHECK FOR LEAP YEAR: REMAINDER WILL BE ZERO IF IT IS A LEAP YR
     C     ZYEAR         ADD       28            ZYEAR
     C     ZYEAR         DIV       4             ZLYR              2 0
     C                   MVR                     ZLY               1 0
      **
      **   IF FEBUARY FURTHER VALIDATE DAY.
     C     ZMTH          IFEQ      2
      **
      **   INVALID IF GREATER THAN 28 AND NOT A LEAP YEAR
     C     ZLY           IFGT      0
     C     ZDAY          ANDGT     28
     C                   SETON                                        99
     C                   GOTO      ZDEND1
     C                   END
      **
      **   INVALID IF GREATER THAN 29 AND A LEAP YEAR - BYPASS IF ERROR
     C     ZLY           IFEQ      0
     C     ZDAY          ANDGT     29
     C                   SETON                                        99
     C                   GOTO      ZDEND1
     C                   END
      **
     C                   END
      **
      **   DETERMINE NUMBER OF DAYS FROM 31/12/1971.
      **
      **   MULTIPLY NO. OF FOUR-YEAR SPANS, BY NO. OF DAYS IN SPAN
     C     ZLYR          MULT      1461          ZDAYNO
      **
      **   IF NOT A LEAP YEAR, ADD APPROPRIATE NO. OF DAYS FOR EXTRA
      **   YEARS USING REMAINDER FIELD (IE. 1, 2 OR 3 X 356)
     C     ZLY           IFGT      0
     C     ZDAYNO        ADD       ZYDY(ZLY)     ZDAYNO
     C                   END
      **
      **   IF IT IS A LEAP YEAR, AND LATER THAN FEBRUARY, ADD ONE FOR
      **   29TH OF FEB
     C     ZLY           IFEQ      0
     C     ZMTH          ANDGT     2
     C     ZDAYNO        ADD       1             ZDAYNO
     C                   END
      **
      **   ADD APPROPRIATE NUMBER OF DAYS FOR THE MONTH NUMBER
     C     ZDAYNO        ADD       ZMDY(ZMTH)    ZDAYNO
      **
      **   ADD NUMBER OF DAYS IN MONTH
     C     ZDAYNO        ADD       ZDAY          ZDAYNO
      **
     C     ZDEND1        ENDSR
      **
     C********************************************************************
     C/EJECT
     C*
     C*****************************************************************
     C*
     C     ZDATE9        BEGSR
     C*
     C                   SETOFF                                       9091
     C                   MOVE      '0'           @@RTN             1
     C                   Z-ADD     0             @@VDT
     C                   Z-ADD     1             @@I               2 0
     C                   Z-ADD     1             @@J               2 0
     C                   Z-ADD     1             @@LEAP            1 0
      *
     C     @@DAYN        IFLT      1
     C                   MOVE      '1'           @@RTN
     C                   GOTO      ZDAT79
     C                   END
      *
      * DIVISION TO DETERMINE WETHER LEAP YEAR.
      *
     C     @@DAYN        DIV       1461          @@Z71Y
     C                   MVR                     @@RDAY            5 0
      *
      * CALCULATING YEAR.
      *
     C     @@Z71Y        MULT      4             @@Z71Y
     C                   ADD       1972          @@Z71Y
      *
      * CHECKING IF YEAR IS GREATER THAN OR EQUAL TO 2100
      *
     C     @@Z71Y        IFGE      2100
     C                   ADD       @@SSY2        @@RDAY
     C                   END
      *
      * LOKUP ARRAY @YD TO SEE HOW MANY YEARS OF A FOUR YEAR CYCLE
      * HAVE PASSED.
      *
     C     @@RDAY        LOOKUP    @YD(@@I)                             9090
      *
      * IF YEAR IS A LEAP YEAR SSLEAP IS SET TO ZERO.
      *
     C     *IN90         IFEQ      '0'
     C                   Z-ADD     0             @@LEAP
     C                   END
      *
      * ADD INDEX TO YEAR TO GIVE CORRECT YEAR AND ADJUST '@@RDAY'.
      *
     C     @@LEAP        IFEQ      1
     C     @@RDAY        SUB       @YD(@@I)      @@RDAY
     C                   ADD       @@I           @@Z71Y
     C                   END
      *
      * PROCESSING FOR A LEAP YEAR.
      *
     C     @@LEAP        IFEQ      0
      *
      * IF '@@RDAY' = 60 DATE MUST BE 29TH OF FEBRUARY.
      *
     C     @@RDAY        IFEQ      60
     C                   Z-ADD     29            @@Z71D
     C                   Z-ADD     2             @@Z71M
     C                   GOTO      ZA0711
     C                   END
      *
      * IF '@@RDAY' > 60 DATE IS AFTER 29TH OF FEBRUARY,CONVERSION CAN
      * PROCEED AS USUAL AFTER SUBTRACTING THE EXTRA DAY FOR THE LEAP
      * YEAR. NOTE : '@@RDAY' < 60 CONVERSION PROCEEDS AS USUAL.
      *
     C     @@RDAY        IFGT      60
     C     @@RDAY        SUB       1             @@RDAY
     C                   END
      *
     C                   END
      *
      * IF DAY '@@DAYN' IS EXACTLY DIVISIBLE BY 1461 (NUMBER OF DAYS
      * IN 4 YEARS) THEN DATE MUST BE LAST DAY OF PREVIOUS FOUR YEAR
      * GROUP.
      *
     C     @@RDAY        IFEQ      0
     C                   Z-ADD     31            @@Z71D
     C                   Z-ADD     12            @@Z71M
     C                   SUB       1             @@Z71Y
     C                   GOTO      ZA0711
     C                   END
      *
      * LOOK UP ARRAY ARRAY @MD TO DETERMINE WHICH MONTH '@@RDAY'
      * OCCURS IN
      *
     C     @@RDAY        LOOKUP    @MD(@@J)                             91
     C                   Z-ADD     @@J           @@Z71M
     C     @@RDAY        SUB       @MD(@@J)      @@Z71D
      *
      * DS @@VDT  IS RETURNED IN YYYYMMDD FORMAT
      *
     C     ZA0711        TAG
      *
     C                   MOVE      @@Z71Y        @@YR
      *
     C     ZDAT79        ENDSR
     C*****************************************************************
     C/EJECT
      *
     C*****************************************************************
      *    SUBROUTINE- ZEVCD                                          *
      *    DETERMINE EVENT CONTROL DATE                               *
      *                                                               *
      *   INPUT - ZZAPDT - ACCRUALS/PROFIT DATE FROM SDGELRPD/TABTB11 *
      *           ZZDNWD - DATE OF NEXT WORKING DAY FROM SDBANKPD OR  *
      *                    TABTB11                                    *
      *                                                               *
      *  OUTPUT - ECD (5,0) - EVENT CONTROL DATE                      *
      *                                                               *
      *****************************************************************
      *
     C     ZEVCD         BEGSR
      *
     C                   Z-ADD     ZZAPDT        ZZAPDT            5 0
     C                   Z-ADD     ZZDNWD        ZZDNWD            5 0
      *
     C     ZZAPDT        IFGE      ZZDNWD
     C     ZZDNWD        SUB       1             ECD
      *  ECD = DATE OF NEXT WORKING DAY - 1
      * OTHERWISE ECD = ACCRUALS/PROFIT DATE
     C                   ELSE
     C                   Z-ADD     ZZAPDT        ECD               5 0
     C                   END
      *
     C                   ENDSR
     C/EJECT
      *
      ********************************************************************
      **                                                                 *
      ** ZSEDIT subroutine to insert a decimal point and sign into a     *
      ** numeric field and to blank out leading zeros (optionaly         *
      ** inserting commas).                                              *
      **     Input fields:   ZFLD15 15/0                                 *
      **                     ZDECS  1/0                                  *
      **                     ZECODE 1/  ('J', 'L' or blank)              *
      **                                                                 *
      **     Arrays:         ZS1    15/1/0                               *
      **                     ZS2    21/1/                                *
      **                                                                 *
      **     Output fields:  ZOUT21 21                                   *
      **                                                                 *
     CSR   ZSEDIT        BEGSR
      *
      * Define/Clear fields
      *
     C                   Z-ADD     ZFLD15        ZFLD15           15 0
     C                   Z-ADD     ZDECS         ZDECS             1 0
     C                   MOVE      ZECODE        ZECODE            1
     C                   MOVE      *BLANKS       ZOUT21           21
      *
      *       SET UP WORK FIELDS
      *
     C                   Z-ADD     0             ZS1
     C                   MOVE      ' '           ZS2
      *
     C                   Z-ADD     15            Z1                2 0
     C                   Z-ADD     20            Z2                2 0
      *
     C     15            SUB       ZDECS         ZINTS             2 0
      *
      * Check if numeric field is negative
      *
     C     ZFLD15        IFLT      *ZEROS
     C                   MOVE      '-'           ZS2(21)
     C                   Z-SUB     ZFLD15        ZFLD15
     C                   END
      *
     C                   Z-ADD     ZFLD15        WORK15
      *
      *       CHECK TO SEE IF THERE ARE ANY DECIMAL PLACES
      *
     C     ZDECS         CABEQ     0             ZS10
      *
      *       SET UP DECIMALS
      *
     C                   Z-ADD     *ZEROS        ZCNT              1 0
     C     ZCNT          DOUEQ     ZDECS
     C                   MOVE      ZS1(Z1)       ZS2(Z2)
     C                   SUB       1             Z2
     C                   ADD       1             ZCNT
     C                   SUB       1             Z1
     C                   END
      *
      *       PUT IN DECIMAL PLACE
      *
     C                   MOVE      '.'           ZS2(Z2)
     C                   SUB       1             Z2
      *
     C     ZS10          TAG
      *
      *       SET UP INTEGERS
      *
     C                   Z-ADD     *ZEROS        CNT3              1 0
     C     Z1            DOUEQ     *ZEROS
     C                   MOVE      ZS1(Z1)       ZS2(Z2)
     C                   SUB       1             Z1
     C                   SUB       1             Z2
      *
      * If edit code is 'J', insert a ',' before each group of three
      * digits - not if beginning of array reached.
      *
     C     Z2            IFGT      *ZEROS
     C     ZECODE        ANDEQ     'J'
     C                   ADD       1             CNT3
     C     CNT3          IFEQ      3
     C                   MOVE      ','           ZS2(Z2)
     C                   SUB       1             Z2
     C                   Z-ADD     *ZEROS        CNT3
     C                   END
     C                   END
      *
     C                   END
      *
      *       PUT IN LEADING BLANKS
      *
     C                   Z-ADD     1             Z2
     C     ZS2(Z2)       DOWEQ     '0'
     C     ZS2(Z2)       OREQ      ' '
     C     ZS2(Z2)       OREQ      ','
     C                   MOVE      ' '           ZS2(Z2)
     C                   ADD       1             Z2
     C     Z2            CABEQ     22            ZS20
     C                   END
      *
      *       IF NO INTEGERS PUT IN LEADING ZERO
      *
     C     ZS20          TAG
      *
     C     Z2            IFEQ      22
     C                   SUB       2             Z2
     C                   MOVE      '0'           ZS2(Z2)
     C                   ELSE
      *
     C     ZS2(Z2)       IFEQ      '.'
     C                   SUB       1             Z2
     C                   MOVE      '0'           ZS2(Z2)
     C                   END
     C                   END
      *
      *       SET UP OUTPUT FIELD
      *
     C                   MOVEA     ZS2           ZOUT21
      *
     CSR                 ENDSR
     C*****************************************************************
     C/EJECT
      *
      ********************************************************************
      **
      **   ZDATE2 SR. TO CONVERT A DAY NUMBER TO DATE FORMATS.
      **
      **   THE YEAR 2000, BEING DIVISIBLE BY 400, IS A LEAP YEAR.
      **
     C     ZDATE2        BEGSR
      **
      **   CLEAR LEAP YEAR WORK FIELD.
     C                   MOVE      'N'           ZLEAP             1
      **
      **   CLEAR DATE FIELDS.
     C                   Z-ADD     0             ZDATE             6 0
     C                   MOVEL     '       '     ZADATE            7
      **
      **   CALCULATION TO DEFINE INPUT DAY NUMBER.
     C                   Z-ADD     ZDAYNO        ZDAYNO            5 0
      **
      **   DETERMINE YEAR NUMBER.
      **
      **   ADJUST DAY NUMBER IN CASE LAST DAY OF YEAR.
     C     ZDAYNO        SUB       1             ZDAYN1            5 0
     C     ZDAYN1        IFLT      0
     C                   GOTO      ZDEND2
     C                   END
      **
      **   CALCULATE NUMBER OF 4 YEAR SPANS SINCE 31/12/1971.
     C     ZDAYN1        DIV       1461          ZLYR              2 0
     C                   MVR                     ZDAYN1
      **                                                   DAYS
      **   CALCULATE NUMBER OF REMAINING YEARS.
     C                   Z-ADD     1             ZWRK2             2 0
     C     ZDTAG1        TAG
     C     ZDAYN1        IFGE      ZYDY(ZWRK2)
     C     ZWRK2         ADD       1             ZWRK2
     C                   GOTO      ZDTAG1
     C                   END
      *
     C     ZWRK2         SUB       1             ZWRK2
      **
      **   DECREMENT DAY NO. BY DAYS IN REMAINING YEARS.
     C     ZWRK2         IFNE      0
     C     ZDAYN1        SUB       ZYDY(ZWRK2)   ZDAYN1
     C                   END
      **
      **   CALCULATE ACTUAL YEAR NUMBER.
     C     ZLYR          MULT      4             ZWRK3             3 0
     C     ZWRK3         ADD       72            ZWRK3
     C                   Z-ADD     ZWRK3         ZYEAR             2 0
     C     ZYEAR         ADD       ZWRK2         ZYEAR
      **
      **   DETERMINE MONTH NUMBER.
      **
      **   ADJUST DAY NO. IN CASE LAST DAY OF LEAP YEAR FEBRUARY.
     C     ZWRK2         IFEQ      0
     C     ZDAYN1        IFEQ      59
     C                   MOVE      'Y'           ZLEAP
     C                   END
     C     ZDAYN1        IFGE      59
     C     ZDAYN1        SUB       1             ZDAYN1
     C                   END
     C                   END
      **
      **   CALCULATE MONTH NUMBER.
     C                   Z-ADD     2             ZWRK2
     C     ZDTAG2        TAG
     C     ZDAYN1        IFGE      ZMDY(ZWRK2)
     C     ZWRK2         ADD       1             ZWRK2
     C                   GOTO      ZDTAG2
     C                   END
      *
     C     ZWRK2         SUB       1             ZWRK2
      **
     C                   Z-ADD     ZWRK2         ZMTH              2 0
      **
      **   DETERMINE DAY OF MONTH.
      **
      **   ADD BACK LAST DAY OF YEAR ADJUSTMENT.
     C     ZDAYN1        ADD       1             ZDAYN1
      **
      **   CALCULATE DAY OF MONTH.
     C     ZDAYN1        SUB       ZMDY(ZWRK2)   ZDAY              2 0
      **
      **   ADD BACK LEAP YEAR 29TH FEBUARY ADJUSTMENT, IF REQUIRED.
     C     ZLEAP         IFEQ      'Y'
     C     ZDAY          ADD       1             ZDAY
     C                   END
      **
      **   FORMAT DATE, DDMMYY OR MMDDYY.
     C  N98              MOVEL     ZDAY          ZWRK4             4 0
     C   98              MOVE      ZDAY          ZWRK4
     C  N98              MOVE      ZMTH          ZWRK4
     C   98              MOVEL     ZMTH          ZWRK4
     C                   MOVEL     ZWRK4         ZDATE
     C                   MOVE      ZYEAR         ZDATE
      **
      **   FORMAT ALPHA DATE, DDMMMYY.
     C                   MOVEL     ZDAY          ZWRK5             5
     C     ZDAY          IFLT      10
     C                   MOVEL     ' '           ZWRK5
     C                   END
     C                   MOVE      ZMNM(ZMTH)    ZWRK5
     C                   MOVEL     ZWRK5         ZADATE
     C                   MOVE      ZYEAR         ZADATE
      **
     C     ZDEND2        ENDSR
      **
     C/EJECT
      *****************************************************************
      **
      **  ZXRATE SUBROUTINE TO OBTAIN A CROSS-EXCHANGE RATE AND
      **         MULTIPLY/DIVIDE INDICATOR BETWEEN TWO CURRENCIES
      **
      **  INPUT   - ZRATE1 (13,8) BASE CURRENCY EXCHANGE RATE 1
      **            ZMDI1  (1)    ZRATE1 MULTIPLY/DIVIDE INDICATOR
      **            ZRATE2 (13,8) BASE CURRENCY EXCHANGE RATE 2
      **            ZMDI2  (1)    ZRATE2 MULTIPLY/DIVIDE INDICATOR
      **
      **  OUTPUT  - ZRATEX (13,8) CROSS EXCHANGE RATE
      **            ZMDIX  (1)    CROSS MULTIPLY/DIVIDE INDICATOR
      **
     C*****************************************************************
      **
     C     ZXRATE        BEGSR
      *
     C                   Z-ADD     *ZEROS        ZRATEX           13 8
      *
      * CALCULATE CROSS RATE
      *
      *    ..  IF M/D INDICATOR 1 = M/D INDICATOR 2
      *
     C     ZMDI1         IFEQ      ZMDI2
     C     ZRATE2        IFNE      *ZEROS
     C     ZRATE1        DIV(H)    ZRATE2        ZRATEX
     C                   END
      *
     C                   ELSE
      *    ..  ELSE
      *
     C     ZRATE1        MULT(H)   ZRATE2        ZRATEX
     C                   END
      *
      * SET CROSS M/D INDICATOR
      *
     C                   MOVE      ZMDI1         ZMDIX             1
      **
     C                   ENDSR
      *
      *****************************************************************
     C/EJECT
      *
      **********************************************************************
      **
      **   ZCONV - SUBROUTINE TO CONVERT AN  AMOUNT FROM ONE CURRENCY
      **               TO ANOTHER
      **
      **   INPUT  - ZAMTCI (15,0) AMOUNT INPUT
      **            ZEXCH  (13,8) EXCHANGE RATE
      **            ZMD    (1)    MULTIPLY/DIVIDE INDICATOR
      **            ZCCYI  (3)    CURRENCY INPUT
      **            ZCCYO  (3)    CURRENCY TO BE CONVERTED TO
      **            POWER   -     COMPILE TIME ARRAY MUST BE INCLUDED
      **                          IN THE PROGRAM SOURCE
      **            ZCDPI  (1,0)  (FROM) CURRENCY DECIMAL PLACES
      **            ZCDPO  (1,0)  (TO) CURRENCY DECIMAL PLACES
      **
      **  OUTPUT -  ZAMTCO (15,0) AMOUNT OUTPUT
      **
      **  CALLS  -  NONE
      **
      **********************************************************************
      *
     C     ZCONV         BEGSR
      *
      * DEFINE INPUT AND OUTPUT FIELDS
      *
     C                   MOVE      ZCCYI         ZCCYI             3
     C                   MOVE      ZCCYO         ZCCYO             3
     C                   Z-ADD     ZCDPI         ZCDPI             1 0
     C                   Z-ADD     ZCDPO         ZCDPO             1 0
     C                   Z-ADD     ZAMTCI        ZAMTCI           15 0
     C                   Z-ADD     0             ZAMTCO           15 0
     C                   Z-ADD     ZEXCH         ZEXCH            13 8
     C                   MOVE      ZMD           ZMD               1
      *
      * IF EXCHANGE RATE IS 0 - OUTPUT CURRENCY AMOUNT AS ZERO
      *
     C     ZEXCH         IFEQ      0
     C                   Z-ADD     0             ZAMTCO
     C                   GOTO      EZCONV
     C                   END
      *
      * IF DECIMAL PLACES ARE THE SAME FOR BOTH CURRENCIES
      *
     C     ZCDPI         IFEQ      ZCDPO
      *
      ***  CALCULATE OUTPUT CURRENCY AMOUNT BY DIVIDING EXCHANGE RATE INTO
      *** OR MULTIPLYING EXCHANGE RATE BY CURRENCY AMOUNT INPUT DEPENDING
      *** ON INDICATOR
      *
      *  When converting from Base ccy back to EUR , inverted value of
      *  MDIN should be used. Check for unique field WUFLAG to validate
      *  it has been called from DL0410 .
      *
      * Define new fields lengths
     C                   MOVE      WBINCY        WBINCY            1
     C                   MOVE      WUFLAG        WUFLAG            1
     C     WUFLAG        IFEQ      'Y'
     C     WBINCY        ANDNE     'Y'
      *
     C     ZMD           IFEQ      'D'
     C     ZAMTCI        MULT(H)   ZEXCH         ZAMTCO
     C                   ELSE
     C     ZAMTCI        DIV(H)    ZEXCH         ZAMTCO
     C                   END
      *
     C                   ELSE
     C     ZMD           IFEQ      'D'
     C     ZAMTCI        DIV(H)    ZEXCH         ZAMTCO
     C                   ELSE
     C     ZAMTCI        MULT(H)   ZEXCH         ZAMTCO
     C                   END
      *
     C                   END
      *
     C                   ELSE
      *
      *** IF DECIMAL PLACES DIFFER -
      ***      CALCULATE DIFFERENCE IN DECIMAL PLACES TO USE AS POWER INDEX
      *
     C     ZCDPO         SUB       ZCDPI         ZPX               1 0
     C                   ADD       4             ZPX
      *
      *** CALCULATE CURRENCY AMOUNT OUTPUT BY MULTIPLYING INPUT AMOUNT BY
      ***  POWER ARRAY ENTRY AND THEN MULTIPLYING RESULT BY EXCHANGE RATE
      ***  DEPENDING ON INDICATOR
      *
     C     POWER(ZPX)    IFLT      1
     C     ZAMTCI        MULT      POWER(ZPX)    Z15#3            15 3
      *
      *  Do the same procedure if converting from Base ccy back to EUR
      *
     C     WUFLAG        IFEQ      'Y'
     C     WBINCY        ANDNE     'Y'
      *
     C     ZMD           IFEQ      'D'
     C     Z15#3         MULT(H)   ZEXCH         ZAMTCO
     C                   ELSE
     C     Z15#3         DIV(H)    ZEXCH         ZAMTCO
     C                   END
      *
     C                   ELSE
      *
     C     ZMD           IFEQ      'D'
     C     Z15#3         DIV(H)    ZEXCH         ZAMTCO
     C                   ELSE
     C     Z15#3         MULT(H)   ZEXCH         ZAMTCO
     C                   END
      *
     C                   END
      *
     C                   ELSE
     C     ZAMTCI        MULT      POWER(ZPX)    ZAMTCI
      *
     C     WUFLAG        IFEQ      'Y'
     C     WBINCY        ANDNE     'Y'
      *
     C     ZMD           IFEQ      'D'
     C     ZAMTCI        MULT(H)   ZEXCH         ZAMTCO
     C                   ELSE
     C     ZAMTCI        DIV(H)    ZEXCH         ZAMTCO
     C                   END
      *
     C                   ELSE
      *
     C     ZMD           IFEQ      'D'
     C     ZAMTCI        DIV(H)    ZEXCH         ZAMTCO
     C                   ELSE
     C     ZAMTCI        MULT(H)   ZEXCH         ZAMTCO
     C                   END
     C*
     C                   END
      *
     C                   END
     C*
     C                   END
     C*
     C     EZCONV        ENDSR
     C*
      *****************************************************************
     C/EJECT
      *
      *****************************************************************
      *                                                               *
      * ZRATE3 - Subroutine to convert a 13,9 rate to display, no     *
      *          sign and no right justify                            *
      *                                                               *
      * INPUT  : ZINPR  (13,9) Rate to be edited.                     *
      *                                                               *
      * OUTPUT : ZOUTR  (14A)  Edited output rate.                    *
      *                                                               *
      * USES   : ZWDECS Field to hold decimal digits for input rate.  *
      *          ZWINTS Field to hold integers for input rate.        *
      *          ZN     Counter field.                                *
      *          ZW     Work array.                                   *
      *                                                               *
      *****************************************************************
     C     ZRATE3        BEGSR
      *
      **  Initialise fields used.
      *
     C                   MOVE      *BLANKS       ZWOUTR           14
     C                   MOVE      *BLANKS       ZWDECS            9
     C                   MOVE      *BLANKS       ZWINTS            4
     C                   Z-ADD     0             ZN                2 0
      *
      **  Initialise work array.
     C
     C                   MOVEA     *BLANKS       ZW
      *
      **  If the rate is negative reverse the sign.
      *
     C     ZINPR         IFLT      0
     C                   Z-SUB     ZINPR         ZINPR            13 9
     C                   END
      *
      **  Separate integers and decimal digits into two fields.
      *
     C                   MOVE      ZINPR         ZWDECS
     C                   MOVEL     ZINPR         ZWINTS
      *
      **  Move integers, decimal separator and decimal digits into
      **  work array.
      *
     C                   MOVEA     ZWINTS        ZW
     C                   MOVE      '.'           ZW(5)
     C                   MOVEA     ZWDECS        ZW(6)
      *
      **  Remove leading zeros from the rate and replace with blanks.
      *
     C                   Z-ADD     1             ZN
     C     ZN            DOWLE     3
     C     ZW(ZN)        ANDEQ     '0'
     C                   MOVE      *BLANK        ZW(ZN)
     C                   ADD       1             ZN
     C                   END
      *
      **  Truncate trailing zeros and replace with blanks. If rate is
      **  an integer a single zero after the decimal place should be
      **  displayed.
      *
     C                   Z-ADD     14            ZN
     C     ZN            DOWGE     7
     C     ZW(ZN)        ANDEQ     '0'
     C                   MOVE      *BLANK        ZW(ZN)
     C                   SUB       1             ZN
     C                   END
      *
      **  Move the final array into the output field.
      *
     C                   MOVEA     ZW            ZOUTR            14
      *
     C     ZRAT39        ENDSR
     C/EJECT
      *
      **************************************************************
      *
      * Summary Stamp Tax file: (GLACNTQD)
     OGLACNTD0  E            UPDAC
     O                       F1STAI
     O                       F1STAB
     O                       F1CLOS
     O                       F1TAX
     O                       F1TAXE
     O                       F1STCC
      *
      * Summary Stamp Tax file: (DLDLDCQD)
     ODLDLDCD0  E            UPDDL
     O                       F1STAI
     O                       F1STAB
     O                       F1TAX
     O                       F1TAXE
      *
      * Summary Stamp Tax file: (CLONCLQD)
     OCLONLQD0  E            UPDLN
     O                       LQSTAI
     O                       LQSTAB
     O                       LQTAX
     O                       LQTAXE
      *
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
**  POWER - ARRAY OF POWERS FOR CURRENCY CONVERSION
0000001
0000010
0000100
0001000
0010000
0100000
1000000
** SR@    **      Sr Names
STDBRESTAVRESTAVDL
** DC@    **      Sr Description
DEB INT POSTING     RE DEBIT AVERAGE    LOAN AVERAGE
** CPY@   **      OBJECT COPYRIGHT
(C) Copyright Misys International Banking Systems Ltd., 2010
