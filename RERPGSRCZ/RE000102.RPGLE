     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas RE ABC Calculation Initialization')              *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE000102 - Account Balance Check Calculation Initialization  *
      *                                                               *
      *  Function:  This will calculate the base available balance    *
      *             for every account.                                *
      *                                                               *
      *  Called By: REC000102                                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. MD030959           Date 17Jun15               *
      *  Prev Amend No. CRE095             Date 25Apr14               *
      *               . CRE090             Date 14Feb14               *
      *  Prev Amend No. AR1095876A         Date 30Sep13               *     
      *                 AR1095876          Date 30Sep13               *
      *                 CLE148             Date 23Jul12               *
      *                 AR958145 *CREATE   Date 26Apr12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD030959 - Recompiled due to changed PF/HELDIHC.             *
      *  CRE095 - Rate Fixing for RE Accounts (Recompile)             *
      *  CRE090 - Delay Capitalisation of Interest (Recompile)        *
      *  AR1095876A-Additional requirement for Processing Type 3: If  *
      *             the transaction Value Date is greater than System *
      *             Date, no balances should be updated. Regardless   *
      *             of ANWD indicator in GL ICD. (Child: AR1095877)   *
      *  AR1095876- ABC - Forward Days 1 should = DNWD-1, not just    *
      *             RUND (Child: AR1095877)                           *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  AR958145 - ABC First day processing enhancement              *
      *           - Applied fix for AR975746                          *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    50         General Indicator Used For CHAIN                *
      *                                                               *
      *****************************************************************
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *INZSR        - Initialise                                    *
      * *PSSR         - Error processing                              *
      * SRWorkDay     - Set working dates for today and next n working*
      *                 days                                          *
      * SRBaseAvail   - Calculate Base Available Balance              *
      * SRAvaBalance  - Calculate Available Balance                   *
      * SRAvaBalance2 - Calculate Available Balance with CLEARPD      *
      * SROverDraft   - Retrieve OverDraft line                       *
      * SRGetCurrD    - Retrieves Currency Details                    *
      * SRGetProcess  - Assign processing type to use                 *
      * SRStorSysVal  - Retrieve and store system values              *
      * SrSysValues   - Get System values                             *
      *                                                               *
      *****************************************************************
     FACCNT     IF   E           K DISK
     F                                     IGNORE(ACCNTAAF)
     F                                     IGNORE(ACCNTACF)
      ** Midas GL Accounts master
 
     FRSACMTL8  IF   E           K DISK
      ** Midas GL Account Movements in Value Date Seq
 
     FGLCOLLLG  IF   E           K DISK
      ** Midas GL Live Collateral Details by Account
 
     FGLCOLLQ0  IF   E           K DISK
      ** Midas GL Collateral Details Extension File
 
     FHELDIL1   IF   E           K DISK
     F                                     IGNORE(HELDIHAF)
     F                                     IGNORE(HELDIHCF)
      ** Midas RE Held Item File -  By Branch
 
     FREODHSL0  IF   E           K DISK
      ** Midas RE Overdraft hist by account and hist date
 
     FGLACNTL3  UF   E           K DISK    COMMIT
      ** Midas GL Account Extension File
 
     FCLEAR     IF   E           K DISK
     F                                     IGNORE(APOSTHHF)
     F                                     RENAME(APOSTPDF:CLEARPDF)
     F                                     IGNORE(APOSTZZF)
      ** Items in Clearing
 
     FGLHATML2  IF   E           K DISK
      ** Midas GL Account Transfer Input file
 
      *****************************************************************
      /EJECT
      *****************************************************************
      /SPACE 3
     D LDA           E DS           256    EXTNAME(LDA)
      ** Local data area for database error details
      *
 
     D JNSTAT        E DS                  EXTNAME(JNSTAT)
      ** Data Area giving Installation Control Details
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ***  External data structures for Bank Details
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** Switchable Features file
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ***  External data structures for Currency Details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ***  Short data structures for Access Objects
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Long data structure for access objects
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D                 DS
      *** Data structure of workdates
     D  F1DAT0                 1      3P 0
     D  F1DAT1                 4      6P 0
     D  F1DAT2                 7      9P 0
     D  F1DAT3                10     12P 0
     D  F1DAT4                13     15P 0
     D  F1DAT5                16     18P 0
     D  F1DAT6                19     21P 0
     D  F1DAT7                22     24P 0
     D  F1DAT8                25     27P 0
     D  F1DAT9                28     30P 0
     D  F1DATS                 1     30P 0
     D                                     DIM(10) ASCEND
 
     D                 DS
      *** Data structure of Base Available Balance
     D  F1BAB0                 1      8P 0
     D  F1BAB1                 9     16P 0
     D  F1BAB2                17     24P 0
     D  F1BAB3                25     32P 0
     D  F1BAB4                33     40P 0
     D  F1BAB5                41     48P 0
     D  F1BAB6                49     56P 0
     D  F1BAB7                57     64P 0
     D  F1BAB8                65     72P 0
     D  F1BAB9                73     80P 0
     D  F1BAVS                 1     80P 0
     D                                     DIM(10) ASCEND
 
     D                 DS
      **  Data structure of Account Balance
     D  F1BAV0                 1      8P 0
     D  F1BAV1                 9     16P 0
     D  F1BAV2                17     24P 0
     D  F1BAV3                25     32P 0
     D  F1BAV4                33     40P 0
     D  F1BAV5                41     48P 0
     D  F1BAV6                49     56P 0
     D  F1BAV7                57     64P 0
     D  F1BAV8                65     72P 0
     D  F1BAV9                73     80P 0
     D  F1ACBS                 1     80P 0
     D                                     DIM(10) ASCEND
 
     D                 DS
      *** Data structure of Available Balance
     D  F1AVA0                 1      8P 0
     D  F1AVA1                 9     16P 0
     D  F1AVA2                17     24P 0
     D  F1AVA3                25     32P 0
     D  F1AVA4                33     40P 0
     D  F1AVA5                41     48P 0
     D  F1AVA6                49     56P 0
     D  F1AVA7                57     64P 0
     D  F1AVA8                65     72P 0
     D  F1AVA9                73     80P 0
     D  F1AVAS                 1     80P 0
     D                                     DIM(10) ASCEND
 
     D                 DS
      *** Data structure of Blocked Collateral
     D  F1CBC0                 1      8P 0
     D  F1CBC1                 9     16P 0
     D  F1CBC2                17     24P 0
     D  F1CBC3                25     32P 0
     D  F1CBC4                33     40P 0
     D  F1CBC5                41     48P 0
     D  F1CBC6                49     56P 0
     D  F1CBC7                57     64P 0
     D  F1CBC8                65     72P 0
     D  F1CBC9                73     80P 0
     D  F1CBCS                 1     80P 0
     D                                     DIM(10) ASCEND
 
     D                 DS
      *** Data structure of Held Items
     D  F1HIT0                 1      8P 0
     D  F1HIT1                 9     16P 0
     D  F1HIT2                17     24P 0
     D  F1HIT3                25     32P 0
     D  F1HIT4                33     40P 0
     D  F1HIT5                41     48P 0
     D  F1HIT6                49     56P 0
     D  F1HIT7                57     64P 0
     D  F1HIT8                65     72P 0
     D  F1HIT9                73     80P 0
     D  F1HITS                 1     80P 0
     D                                     DIM(10) ASCEND
 
      *** Data structure of Held Items
     D  HELDS          S              1    DIM(10)
 
      *** Work variables
     D WDATEIN         S              5  0
     D WCNUM           S              6
     D WCCY            S              3
     D WACOD           S             10  0
     D WACSQ           S              2  0
     D WBRCA           S              3
     D WBRC1           S              3
     D WXREF           S             10
     D W#OverLine      S             11  0
     D WHISD           S              5  0
     D WProcessType    S              1
     D NoDays          S              3  0
     D WNWD            S              3  0                                                 AR1095876
 
     D FieldsDS        DS
      ** Module is FT
     D WKSysFTDR                      1
     D WKSysFTCR                      1
      ** Module is GL Transaction Type is ME
     D WKSysGLMEDR                    1
     D WKSysGLMECR                    1
      ** Module is SE
     D WKSysSEDR                      1
     D WKSysSECR                      1
      ** Module is GL Transaction Type is ZT and Movement Type is S
     D WKSysGLMESDR                   1
     D WKSysGLMESCR                   1
      ** Module is GL Transaction Type is ZT and Movement Type is F
     D WKSysGLMEFDR                   1
     D WKSysGLMEFCR                   1
      ** Other modules Movetype is S
     D WKSysOTSDR                     1
     D WKSysOTSCR                     1
      ** Other modules Movetype is F
     D WKSysOTFDR                     1
     D WKSysOTFCR                     1
     ** System value for number of days
     D WKSysNoDays                    1
     D FieldsArr                      1    DIM(15)
     D                                     OVERLAY(FieldsDS)
 
      ** AOSVALR0 parameters
 
     D PSysVal         S             20    DIM(10)
     D PCurSet         S            200    DIM(10)
 
      ** AOCURRR0 parameters
     D PCcy            S              3
 
      ** Fields for SRGetProcess
     D WkCMOD          S                   LIKE(CMOD)
     D WkDORC          S                   LIKE(DORC)
     D WkTRYP          S                   LIKE(TRYP)
     D WkMTYP          S                   LIKE(MTYP)
 
     D WkTREF          S                   LIKE(R1TREF)
 
      ** Array Indices
 
     D X               S              3P 0
 
     D WCTR            S              2P 0
     D LOCIND          S              1A
     D ACTIND          S              1A
     D @RTCD           S              7A
     D @OPTN           S              7A
     D @SARD           S              6A
     D CRE001          S              1A
     D @RUN            S              1A
 
      *** Other variables
     D/COPY ZSRSRC,ZHOLILE
     D/COPY ZSRSRC,ZHOLELE
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
     IGLCOLQD0
     I              CDXREF                      CDXREF10
 
     IRSACMTPO
     I              NRTC                        NRTCX
 
     IREODHSD0
     I              ODED                        ODEDX
     I              ODLN                        ODLNX
      *****************************************************************
      /SPACE 3
      *****************************************************************
      /EJECT
      *================================================================
      *  P R O G R A M   S T A R T                                    *
      *================================================================
 
      ** Start of processing
 
     C     *LOVAL        SETLL     GLACNTL3
     C                   READ      GLACNTL3
     C                   DOW       NOT %EOF(GLACNTL3)
 
      ** Retrieve account details
 
     C                   MOVE      F1CNUM        WCNUM
     C                   MOVE      F1CCY         WCCY
     C                   MOVE      F1ACOD        WACOD
     C                   MOVE      F1ACSQ        WACSQ
     C                   MOVE      F1BRCA        WBRCA
 
     C     KACCNT        CHAIN     ACCNT
 
     C                   IF        F1IABC = 'Y' OR
     C                             ATYP = 'R'
 
      ** Account should not be attached to a facility
 
     C                   IF        %FOUND(ACCNT)
     C                             AND FCCU = *BLANKS AND
     C                             FACT = *ZERO AND FCNO = *ZERO
 
      ** set working date for today and the next 9 working days
     C                   EXSR      SRWorkDay
 
      ** compute base available balance
     C                   EXSR      SRBaseAvail
 
      ** compute available balance
     C                   EXSR      SRAvaBalance
 
      ** compute available balance using CLEARPD
     C                   EXSR      SRAvaBalance2
 
     C                   UPDATE    GLACNTD0
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   READ      GLACNTL3
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *================================================================
      *  P R O G R A M   E N D                                        *
      *================================================================
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWorkDay - Subroutine to set working date for today and the *
      *              next 9 working days                              *
      *                                                               *
      *****************************************************************
     C     SRWorkDay     BEGSR
 
     C                   EVAL      NoDays = %INT(%TRIM(WKSysNoDays)) + 1
 
      ** Initialize variables
 
     C                   MOVEA     *ZERO         F1DATS
 
      ** current rundate has already been changed so we will set
      ** this as F1DAT1 and F1DAT0 as previous day
 
     C                   IF        NoDays >= 1
     C                   Z-ADD     PRUN          F1DAT0
     C                   EndIf
 
     C                   IF        NoDays >= 2
     C                   Z-ADD     BJRDNB        F1DAT1
     C                   ENDIF
 
      ** get the third day to tenth day
 
     C                   IF        NoDays >= 3
     C                   Z-ADD     3             WCTR
     C     BJRDNB        ADD       1             WDATEIN
 
     C                   DOW       WCTR <= NoDays
 
      ** Location currency
 
     C                   Z-ADD     WDATEIN       ZDAYNO
     C                   MOVE      BJLCCY        ZCCY
     C                   MOVE      *BLANKS       ZLOC
     C                   MOVE      *BLANKS       ZIND
 
     C                   EXSR      ZCHKH
 
     C                   MOVE      ZIND          LOCIND
 
      ***Account*currency**********************************************                    AR1095876
      **********                                                                           AR1095876
     C**********         Z-ADD     WDATEIN       ZDAYNO                                    AR1095876
     C**********         MOVE      CCY           ZCCY                                      AR1095876
     C**********         MOVE      *BLANKS       ZLOC                                      AR1095876
     C**********         MOVE      *BLANKS       ZIND                                      AR1095876
      **********                                                                           AR1095876
     C**********         EXSR      ZCHKH                                                   AR1095876
      **********                                                                           AR1095876
     C**********         MOVE      ZIND          ACTIND                                    AR1095876
      **********                                                                           AR1095876
     C**********         IF        LOCIND = 'W' OR ACTIND = 'W'                            AR1095876
     C                   IF        LOCIND = 'W'                                            AR1095876
     C                   EVAL      F1DATS(WCTR) = WDATEIN
     C                   ADD       1             WCTR
     C                   ENDIF
     C
     C                   ADD       1             WDATEIN
 
     C                   ENDDO
     C                   ENDIF
      *                                                                                    AR1095876
      ** Get the next working day after the last ABC availability date and                 AR1095876
      ** put it in F1OAD field                                                             AR1095876
      *                                                                                    AR1095876
     C                   EVAL      WDATEIN = F1DATS(NoDays) + 1                            AR1095876
     C                   EVAL      LOCIND = *BLANK                                         AR1095876
      *                                                                                    AR1095876
     C                   DOW       LOCIND <> 'W'                                           AR1095876
      *                                                                                    AR1095876
      ** Location currency                                                                 AR1095876
      *                                                                                    AR1095876
     C                   Z-ADD     WDATEIN       ZDAYNO                                    AR1095876
     C                   MOVE      BJLCCY        ZCCY                                      AR1095876
     C                   MOVE      *BLANKS       ZLOC                                      AR1095876
     C                   MOVE      *BLANKS       ZIND                                      AR1095876
      *                                                                                    AR1095876
     C                   EXSR      ZCHKH                                                   AR1095876
      *                                                                                    AR1095876
     C                   MOVE      ZIND          LOCIND                                    AR1095876
     C                   IF        LOCIND = 'W'                                            AR1095876
     C                   EVAL      F1OAD = WDATEIN                                         AR1095876
     C                   ENDIF                                                             AR1095876
     C                   ADD       1             WDATEIN                                   AR1095876
     C                   ENDDO                                                             AR1095876
      *                                                                                    AR1095876
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBaseAvail - Subroutine to calculate Base Available Balance *
      *                                                               *
      *****************************************************************
     C     SRBaseAvail   BEGSR
 
      ** Initialize variables
 
     C                   MOVEA     *BLANKS       HELDS
     C                   MOVEA     *ZERO         F1BAVS
     C                   MOVEA     *ZERO         F1AVAS
     C                   MOVEA     *ZERO         F1HITS
     C                   MOVEA     *ZERO         F1CBCS
     C                   MOVEA     *ZERO         F1ACBS
 
     C                   Z-ADD     1             WCTR
 
      ** Initialize account balance and base available balance arrays
      ** with cleared balance for the next N days where N is the ABC
      ** Number of Days Forward + 1 in SDSVALPD.
 
     C                   DOW       WCTR <= NoDays
     C                   EVAL      F1ACBS(WCTR) = CLBL
     C                   EVAL      F1BAVS(WCTR) = CLBL
 
     C                   ADD       1             WCTR
     C                   ENDDO
 
      ** Check if Blocked Collateral Exists
 
     C     KGCOLG        CHAIN     GLCOLLLG                           50
 
     C                   DOW       *IN50 = *OFF
 
     C                   IF        CDBCOL = 'Y'
     C                             AND CDCOPT = 'A'
 
     C                   Z-ADD     1             WCTR
     C                   DOW       WCTR <= NoDays
 
     C                   IF        CDEDAT >= F1DATS(WCTR) AND
     C                             CDVDAT <= F1DATS(WCTR)
 
     C                   MOVE      CDCBRC        WBRC1
     C                   MOVE      CDCREF        WXREF
 
     C     KGCOQ0        CHAIN     GLCOLLQ0
     C                   IF        %FOUND(GLCOLLQ0)
 
     C                   IF        CDXCBC > 0
     C                   EVAL      F1CBCS(WCTR) = F1CBCS(WCTR) + CDXCBC
 
     C                   ENDIF
 
     C                   ELSE
 
      ** account should always have corresponding record on GLCOLLQ0
      ** when the preceding conditions are satisfied
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'GLCOLLQD'
     C                   EVAL      DBKEY = WXREF
     C                   EVAL      DBASE = 3
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ADD       1             WCTR
 
     C                   ENDDO
 
     C                   ENDIF
 
     C     KGCOLG        READE     GLCOLLLG                               50
     C                   ENDDO
 
      ** Check if Held Items Exists
 
     C     KHLDL1        CHAIN     HELDIL1                            50
 
     C                   DOW       *IN50 = *OFF
 
     C                   IF        RECI = 'D'
 
     C                   Z-ADD     1             WCTR
     C                   DOW       WCTR <= NoDays
     C                   IF        HEXP >= F1DATS(WCTR)
 
     C                   EVAL      F1HITS(WCTR) = F1HITS(WCTR) + HLDA
 
     C                   IF        HHIT = 'Y'
     C                   EVAL      HELDS(WCTR) = 'Y'
     C                   ENDIF
 
     C                   ENDIF
     C                   ADD       1             WCTR
     C                   ENDDO
 
     C                   ENDIF
 
     C     KHLDL1        READE     HELDIL1                                50
     C                   ENDDO
 
      ** Calculate for the Base Available Balance
 
     C                   Z-ADD     1             WCTR
 
      ** Get currency detail
 
     C                   EVAL      PCcy = WCCY
     C                   EXSR      SRGetCurrD
 
     C                   DOW       WCTR <= NoDays
 
      ** If there is a blocked collateral amount
 
     C                   IF        F1CBCS(WCTR) <> *ZERO
 
      ** Base Available Balance
      **  = Cleared Account Balance debit all Held Items debit all Blocked Collateral
      **  = Cleared Account Balance + all Held Items + all Blocked Collateral
 
     C                   EVAL      F1BAVS(WCTR) = F1BAVS(WCTR) + F1HITS(WCTR)
     C                   EVAL      F1BAVS(WCTR) = F1BAVS(WCTR) + F1CBCS(WCTR)
 
     C                   ELSE
 
      ** Base Available Balance
      **  = Cleared Account Balance debit all Held Items
      **  = Cleared Account Balance + all Held Items
 
     C                   EVAL      F1BAVS(WCTR) = F1BAVS(WCTR) + F1HITS(WCTR)
 
      ** If there are no hard held items
 
     C                   IF        HELDS(WCTR) <> 'Y'
 
      ** Base Available Balance
      **  = Cleared Account Balance debit all Held Items credit Overdraft Line
      **  = Cleared Account Balance + all Held Items - Overdraft Line
 
     C                   EXSR      SROverDraft
     C                   EVAL      F1BAVS(WCTR) = F1BAVS(WCTR) - W#OverLine
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ADD       1             WCTR
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAvaBalance - Subroutine to calculate Available Balance     *
      *                 and Account Balances                          *
      *                                                               *
      *****************************************************************
     C     SRAvaBalance  BEGSR
 
      ** Initialize variables
 
     C                   MOVEA     F1BAVS        F1AVAS
 
     C     KRSCL6        SETLL     RSACMTL8
     C     KRSCL6        READE     RSACMTL8
 
     C                   DOW       NOT %EOF(RSACMTL8)
 
     C                   Z-ADD     1             WCTR
     C                   EVAL      WNWD = WCTR + 1                                         AR1095876
      *                                                                                    AR1095876
      ** Retrieve processing type to be used
 
     C                   EVAL      WkCMOD = CMOD
     C                   EVAL      WkDORC = DORC
     C                   EVAL      WkTRYP = TRYP
     C                   EVAL      WkMTYP = MTYP
     C                   EXSR      SRGetProcess
 
     C                   DOW       WCTR <= NoDays
     C                   SELECT
     C                   WHEN      WProcessType = '1'
 
      ** No Additional Condition
 
     C                   IF        DORC = 0
      ** Add Movement Amount, MVAM and Base Available Balance
     C                   ADD       MVAM          F1AVAS(WCTR)
 
      ** Add Movement Amount MVAM to Account Balance
     C                   ADD       MVAM          F1ACBS(WCTR)
     C                   ELSE
      ** Subtract Movement Amount, MVAM and Base Available Balance
     C                   SUB       MVAM          F1AVAS(WCTR)
      ** Subtract Movement Amount MVAM from Account Balance
     C                   SUB       MVAM          F1ACBS(WCTR)
 
     C                   ENDIF
 
     C                   WHEN      WProcessType = '2'
 
      ** If Movement Date, VUDT is less than or equal to date being processed
      ** Or if Value Date is not an availability date (i.e. movements with a               AR1095876
      ** value date that is a holiday in system currency), update the                      AR1095876
      ** balance of the preceding availability date. This processing is                    AR1095876
      ** 'in advance'                                                                      AR1095876
 
     C                   IF        VUDT <= F1DATS(WCTR)
     C                             OR VUDT > F1DATS(WCTR)                                  AR1095876
     C                             AND VUDT < F1DATS(WNWD)                                 AR1095876
     C                             OR VUDT > F1DATS(WCTR)                                  AR1095876
     C                             AND VUDT < F1OAD                                        AR1095876
     C                             AND WCTR = NoDays                                       AR1095876
     C                   IF        DORC = 0
      ** Add Movement Amount, MVAM and Base Available Balance
     C                   ADD       MVAM          F1AVAS(WCTR)
      ** Add Movement Amount MVAM to Account Balance
     C                   ADD       MVAM          F1ACBS(WCTR)
 
     C                   ELSE
      ** Subtract Movement Amount, MVAM and Base Available Balance
     C                   SUB       MVAM          F1AVAS(WCTR)
      ** Subtract Movement Amount MVAM from Account Balance
     C                   SUB       MVAM          F1ACBS(WCTR)
 
     C                   ENDIF
     C                   ENDIF
 
     C                   WHEN      WProcessType = '3'
 
      ***If*Movement*Date,*PTDT*is*less*than*or*equal*to*F1DAT0********                   AR1095876A
      ** If Value Date, VUDT is less than or equal to today's date                        AR1095876A
      ** and Movement Date, VUDT is less than or equal to date being processed
 
     C**********         IF        PTDT <= F1DAT0                                         AR1095876A
     C                   IF        VUDT <= BJRDNB                                         AR1095876A
     C                             AND VUDT <= F1DATS(WCTR)
     C                   IF        DORC = 0
      ** Add Movement Amount, MVAM and Base Available Balance
     C                   ADD       MVAM          F1AVAS(WCTR)
      ** Add Movement Amount MVAM to Account Balance
     C                   ADD       MVAM          F1ACBS(WCTR)
 
     C                   ELSE
      ** Subtract Movement Amount, MVAM and Base Available Balance
     C                   SUB       MVAM          F1AVAS(WCTR)
      ** Subtract Movement Amount MVAM from Account Balance
     C                   SUB       MVAM          F1ACBS(WCTR)
 
     C                   ENDIF
     C                   ENDIF
 
     C                   WHEN      WProcessType = '4'
      ** Movement is not included hence do nothing
     C                   ENDSL
     C                   ADD       1             WCTR
     C                   IF        WCTR >= NoDays                                          AR1095876
     C                   EVAL      WNWD = WCTR                                             AR1095876
     C                   ELSEIF    WCTR < NoDays                                           AR1095876
     C                   EVAL      WNWD = WCTR + 1                                         AR1095876
     C                   ENDIF                                                             AR1095876
     C                   ENDDO
 
     C     KRSCL6        READE     RSACMTL8
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAvaBalance2 - Subroutine to calculate Available Balance    *
      *                  with CLEARPD                                 *
      *                                                               *
      *****************************************************************
     C     SRAvaBalance2 BEGSR
 
     C     KRSCL6        SETLL     CLEARPDF
     C     KRSCL6        READE     CLEARPDF
 
     C                   DOW       NOT %EOF(CLEAR)
     C                   Z-ADD     1             WCTR
     C                   EVAL      WNWD = WCTR + 1                                         AR1095876
 
      ** Retrieve processing type to be used
 
     C                   EVAL      WkTRYP = *BLANK
     C                   EVAL      WkDORC = DRCR
     C                   SELECT
     C                   WHEN      SPOS = '  GE-IC'
     C                   EVAL      WkCMOD = 'RE'
     C                   EVAL      WkMTYP = 'S'
 
     C                   WHEN      SPOS = '  GE-CE'
     C                   EVAL      WkCMOD = 'RE'
     C                   EVAL      WkMTYP = 'S'
 
     C                   WHEN      SPOS = '  GE-TX'
     C                   EVAL      WkCMOD = 'GL'
     C                   EVAL      WkTRYP = 'ZT'
     C                   MOVEL     OTRF          WkTREF
     C     KeyHATM       CHAIN     GLHATML2
     C                   IF        %FOUND(GLHATML2)
 
      ** Expiry date for GLHATMPD is always <= current rundate,
      ** hence, same day processing, "S"
 
     C                   EVAL      WkMTYP = 'S'
     C                   ELSE
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'GLHATMPD'
     C                   EVAL      DBKEY = WkTREF
     C                   EVAL      DBASE = 6
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   OTHER
     C                   EVAL      WkCMOD = 'GL'
     C                   EVAL      WkTRYP = 'ME'
     C                   EVAL      WkMTYP = 'S'
 
     C                   ENDSL
 
     C                   EXSR      SRGetProcess
 
     C                   DOW       WCTR <= NoDays
     C                   SELECT
     C                   WHEN      WProcessType = '1'
 
      ** No Additional Condition
 
     C                   IF        DRCR = 0
 
      ** Add Posting Amount, PSTA and Base Available Balance
 
     C                   ADD       PSTA          F1AVAS(WCTR)
      ** Add Posting Amount PSTA to Account Balance
     C                   ADD       PSTA          F1ACBS(WCTR)
 
     C                   ELSE
 
      ** Subtract Posting Amount, PSTA and Base Available Balance
 
     C                   SUB       PSTA          F1AVAS(WCTR)
      ** Subtract Posting Amount PSTA from Account Balance
     C                   SUB       PSTA          F1ACBS(WCTR)
 
     C                   ENDIF
 
     C                   WHEN      WProcessType = '2'
 
      ** If Movement Date, VALD is less than or equal to date being processed
 
     C                   IF        VALD <= F1DATS(WCTR)
     C                             OR VALD > F1DATS(WCTR)                                  AR1095876
     C                             AND VALD < F1DATS(WNWD)                                 AR1095876
     C                             OR VALD > F1DATS(WCTR)                                  AR1095876
     C                             AND VALD < F1OAD                                        AR1095876
     C                             AND WCTR = NoDays                                       AR1095876
     C                   IF        DRCR = 0
 
      ** Add Posting Amount, PSTA and Base Available Balance
 
     C                   ADD       PSTA          F1AVAS(WCTR)
      ** Add Posting Amount PSTA to Account Balance
     C                   ADD       PSTA          F1ACBS(WCTR)
 
     C                   ELSE
 
      ** Subtract Posting Amount, PSTA and Base Available Balance
 
     C                   SUB       PSTA          F1AVAS(WCTR)
      ** Subtract Posting Amount PSTA from Account Balance
     C                   SUB       PSTA          F1ACBS(WCTR)
 
     C                   ENDIF
     C                   ENDIF
 
     C                   WHEN      WProcessType = '3'
 
      ***If*Movement*Date,*PSTD*is*less*than*or*equal*to*F1DAT0********                   AR1095876A
      ** If Movement Date, VALD is less than or equal to Today's date                     AR1095876A
      ** and Movement Date, VALD is less than or equal to date being processed
 
     C**********         IF        PSTD <= F1DAT0                                         AR1095876A
     C                   IF        VALD <= BJRDNB                                         AR1095876A
     C                             AND VALD <= F1DATS(WCTR)
     C                   IF        DRCR = 0
 
      ** Add Posting Amount, PSTA and Base Available Balance
 
     C                   ADD       PSTA          F1AVAS(WCTR)
      ** Add Posting Amount PSTA to Account Balance
     C                   ADD       PSTA          F1ACBS(WCTR)
 
     C                   ELSE
 
      ** Subtract Posting Amount, PSTA and Base Available Balance
 
     C                   SUB       PSTA          F1AVAS(WCTR)
      ** Subtract Posting Amount PSTA from Account Balance
     C                   SUB       PSTA          F1ACBS(WCTR)
 
     C                   ENDIF
     C                   ENDIF
 
     C                   WHEN      WProcessType = '4'
 
      ** Movement is not included hence do nothing
 
     C                   ENDSL
 
     C                   ADD       1             WCTR
     C                   IF        WCTR >= NoDays                                          AR1095876
     C                   EVAL      WNWD = WCTR                                             AR1095876
     C                   ELSEIF    WCTR < NoDays                                           AR1095876
     C                   EVAL      WNWD = WCTR + 1                                         AR1095876
     C                   ENDIF                                                             AR1095876
     C                   ENDDO
 
     C     KRSCL6        READE     CLEARPDF
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SROverDraft - Subroutine to retrieve OverDraft line          *
      *                                                               *
      *****************************************************************
     C     SROverDraft   BEGSR
 
      ** Initialize variables
 
     C                   Z-ADD     *ZERO         W#OverLine
 
     C                   IF        CRE001 = 'N'
 
     C                   IF        ODED >= F1DATS(WCTR)
     C                   EVAL      W#OverLine = ODLN * (10**A6NBDP)
     C                   ENDIF
 
     C                   ELSE
 
      ** CRE001 is switched on
 
     C                   EVAL      WHISD = F1DATS(WCTR)
     C     KROHL0        SETGT     REODHSL0
     C     KHLDL1        READPE    REODHSL0
     C                   IF        NOT %EOF(REODHSL0)
 
     C                   IF        F1DATS(WCTR) >= HISD AND
     C                             F1DATS(WCTR) <= ODEDX
     C                   EVAL      W#OverLine = ODLNX * (10**A6NBDP)
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      W#OverLine = *ZERO
     C                   ENDIF
 
     C                   ENDIF
 
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
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    PCcy
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        @RTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBKEY = PCcy
     C                   EVAL      DBASE = 5
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetProcess - Subroutine to assign processing type to use   *
      *                                                               *
      *****************************************************************
     C     SRGetProcess  BEGSR
 
      ** These fields came from RSACMTL6
 
     C                   SELECT
     C                   WHEN      WkCMOD = 'FT'
     C                   IF        WkDORC = 0
     C                   EVAL      WProcessType = WKSysFTDR
     C                   ELSE
     C                   EVAL      WProcessType = WKSysFTCR
     C                   ENDIF
 
     C                   WHEN      WkCMOD = 'GL'
     C                             AND WkTRYP = 'ME'
     C                   IF        WkDORC = 0
     C                   EVAL      WProcessType = WKSysGLMEDR
     C                   ELSE
     C                   EVAL      WProcessType = WKSysGLMECR
     C                   ENDIF
 
     C                   WHEN      WkCMOD = 'GL'
     C                             AND WkTRYP = 'ZT' AND WkMTYP = 'S'
     C                   IF        WkDORC = 0
     C                   EVAL      WProcessType = WKSysGLMESDR
     C                   ELSE
     C                   EVAL      WProcessType = WKSysGLMESCR
     C                   ENDIF
 
     C                   WHEN      WkCMOD = 'GL'
     C                             AND WkTRYP = 'ZT' AND WkMTYP = 'F'
     C                   IF        WkDORC = 0
     C                   EVAL      WProcessType = WKSysGLMEFDR
     C                   ELSE
     C                   EVAL      WProcessType = WKSysGLMEFCR
     C                   ENDIF
 
     C                   WHEN      WkCMOD = 'SE'
     C                   IF        WkDORC = 0
     C                   EVAL      WProcessType = WKSysSEDR
     C                   ELSE
     C                   EVAL      WProcessType = WKSysSECR
     C                   ENDIF
 
     C                   OTHER
     C                   IF        WkMTYP = 'S'
     C                   IF        WkDORC = 0
     C                   EVAL      WProcessType = WKSysOTSDR
     C                   ELSE
     C                   EVAL      WProcessType = WKSysOTSCR
     C                   ENDIF
     C                   ELSE
     C                   IF        WkMTYP = 'F'
     C                   IF        WkDORC = 0
     C                   EVAL      WProcessType = WKSysOTFDR
     C                   ELSE
     C                   EVAL      WProcessType = WKSysOTFCR
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRStorSysVal - Subroutine to retrieve and store system values*
      *                                                               *
      *****************************************************************
     C     SRStorSysVal  BEGSR
 
     C                   CLEAR                   PSysVal
     C                   CLEAR                   PCurSet
 
     C                   EVAL      PSysVal(1)  = 'ABCFTPaymentsDR'
     C                   EVAL      PSysVal(2)  = 'ABCFTPaymentsCR'
     C                   EVAL      PSysVal(3)  = 'ABCJournalEntryDR'
     C                   EVAL      PSysVal(4)  = 'ABCJournalEntryCR'
     C                   EVAL      PSysVal(5)  = 'ABCSEEventsDR'
     C                   EVAL      PSysVal(6)  = 'ABCSEEventsCR'
     C                   EVAL      PSysVal(7)  = 'ABCAcctfrsameDR'
     C                   EVAL      PSysVal(8)  = 'ABCAcctfrsameCR'
     C                   EVAL      PSysVal(9)  = 'ABCAcctfrfrwdDR'
     C                   EVAL      PSysVal(10) = 'ABCAcctfrfrwdCR'
 
     C                   EXSR      SrSysValues
 
      ** Populate Fields array elements 1 to 10
 
     C                   FOR       X = 1 TO 10
     C                   IF        PCurSet(X) <> *BLANKS
     C                   EVAL      FieldsArr(X) = %TRIM(PCurSet(X))
     C                   ENDIF
     C                   ENDFOR
 
      ** Set up calling parameters for AOSVALR0
 
     C                   CLEAR                   PSysVal
     C                   CLEAR                   PCurSet
 
     C                   EVAL      PSysVal(1)  = 'ABCTransValueDR'
     C                   EVAL      PSysVal(2)  = 'ABCTransValueCR'
     C                   EVAL      PSysVal(3)  = 'ABCTransForwardDR'
     C                   EVAL      PSysVal(4)  = 'ABCTransForwardCR'
     C                   EVAL      PSysVal(5)  = 'ABCNoDaysForward'
 
      ** Get System Values
 
     C                   ExSr      SrSysValues
 
      ** Populate Fields array elements 11 to 15
 
     C                   FOR       X = 1 TO 5
     C                   IF        PCurSet(X) <> *BLANKS
     C                   EVAL      FieldsArr(X+10) = %TRIM(PCurSet(X))
     C                   ENDIF
     C                   ENDFOR
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * SrSysValues -  Subroutine to Get System Values                *
      *                                                               *
      *****************************************************************
     C     SrSysValues   BEGSR
 
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    PSysVal(1)
     C                   PARM                    PCurSet(1)
     C                   PARM                    PSysVal(2)
     C                   PARM                    PCurSet(2)
     C                   PARM                    PSysVal(3)
     C                   PARM                    PCurSet(3)
     C                   PARM                    PSysVal(4)
     C                   PARM                    PCurSet(4)
     C                   PARM                    PSysVal(5)
     C                   PARM                    PCurSet(5)
     C                   PARM                    PSysVal(6)
     C                   PARM                    PCurSet(6)
     C                   PARM                    PSysVal(7)
     C                   PARM                    PCurSet(7)
     C                   PARM                    PSysVal(8)
     C                   PARM                    PCurSet(8)
     C                   PARM                    PSysVal(9)
     C                   PARM                    PCurSet(9)
     C                   PARM                    PSysVal(10)
     C                   PARM                    PCurSet(10)
 
      ** Check if database error occured
 
     C                   FOR       X = 1 TO 10
 
     C                   IF        PCurSet(X) = '*NRF'
     C                                      OR
     C                             @RTCD <> *BLANKS
     C                               AND @RTCD <> '*NRF'
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY   = PSysVal(X)
     C                   EVAL      DBFILE  = 'SDSVALPD'
     C                   EVAL      DBASE   = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDFOR
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Routine                      *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Initialise LDA field.
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVEL     'RE000102'    DBPGM
     C                   OUT       LDA
 
      ** Key List for ACCNT
 
     C     KACCNT        KLIST
     C                   KFLD                    WCNUM
     C                   KFLD                    WCCY
     C                   KFLD                    WACOD
     C                   KFLD                    WACSQ
     C                   KFLD                    WBRCA
 
      ** Key List for GLCOLLLG
 
     C     KGCOLG        KLIST
     C                   KFLD                    WBRCA
     C                   KFLD                    WCNUM
     C                   KFLD                    WCCY
     C                   KFLD                    WACOD
     C                   KFLD                    WACSQ
 
      ** Key List for GLCOLLQ0
 
     C     KGCOQ0        KLIST
     C                   KFLD                    WBRC1
     C                   KFLD                    WXREF
 
      ** Key List for HELDIL1
 
     C     KHLDL1        KLIST
     C                   KFLD                    WBRCA
     C                   KFLD                    WCNUM
     C                   KFLD                    WCCY
     C                   KFLD                    WACOD
     C                   KFLD                    WACSQ
 
      ** Key List for REODHSL0
 
     C     KROHL0        KLIST
     C                   KFLD                    WBRCA
     C                   KFLD                    WCNUM
     C                   KFLD                    WCCY
     C                   KFLD                    WACOD
     C                   KFLD                    WACSQ
     C                   KFLD                    WHISD
 
      ** Key List for RSACMTL6
 
     C     KRSCL6        KLIST
     C                   KFLD                    WBRCA
     C                   KFLD                    WCNUM
     C                   KFLD                    WCCY
     C                   KFLD                    WACOD
     C                   KFLD                    WACSQ
 
      ** Key List for GLHATML2
 
     C     KeyHATM       KLIST
     C                   KFLD                    WkTREF
 
     C
      ** Call Access Program for Bank Details - Title, Run Date and
      ** Run Day Number.
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Handle Database Error.
 
     C                   IF        @RTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = @OPTN
     C                   EVAL      DBASE = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access SAR details file to determine if Retail Account
      ** Transfer is switched on
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CRE001'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   MOVEL     'N'           CRE001
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           CRE001
     C                   ELSE
     C     @RTCD         IFNE      '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 4
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBKEY = 'CRE001'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
 
      ** Retrieve and Store System Values
 
     C                   EXSR      SRStorSysVal
 
      ** Access RUNDAT for multibranching indicator
 
     C     *DTAARA       DEFINE                  JNSTAT
     C                   IN        JNSTAT
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Error control subroutine                            *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        @RUN = *BLANKS
     C                   MOVE      'Y'           @RUN
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   DUMP
     C                   ENDIF
 
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZSRSRC,ZCHKHLE
     C/COPY ZSRSRC,ZACCHLE
