     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DE Proj Ext for Customer Lending Fees')          *
      *****************************************************************
      *                                                               *
      *  Midas - Data Export module                                   *
      *                                                               *
      *  DEPXTFEES - Projected Extract for Customer Lending Fees      *
      *                                                               *
      *  Function:  This module is called once for every fee by the   *
      *             projected extract controller. It writes details   *
      *             to the projected extract files in the appropriate *
      *             format.                                           *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. AR674226           Date 04Dec19               *
      *  Prev Amend No. CER050             Date 16Jun19               *
      *                 CLE071             Date 18Jul18               *
      *                 MD046248           Date 27Oct17               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CLE139             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CLE031             Date 14Aug03               *
      *                 219833             Date 07Aug03               *
      *                 216909             Date 14Apr03               *
      *                 CDE005             Date 20Aug02               *
      *                 CDE003             Date 11Dec02               *
      *                 208221             Date 11Dec02               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 204452             Date 03May02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE002  *CREATE    Date 05Dec00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR674226 - Manual transaction reached 999. Increase the size *
      *             of utilisation sequence no. and transaction       *
      *             sequence. Recompile. (Child: AR674227)            *
      *           - Applied for MD054782.                             *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  CLE071 - Value Dating of Rate Changes to Fees (Recompile)    *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CLE139 - Lending Fee Capitalisation (Recompile)              *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CLE031 - Lending Enhancements.                               *
      *  219833 - Don't produce rcds if backvalued trans (recompile). *
      *  216909 - Recompile due to change in DEPPOSNPD format.        *
      *  CDE005 - Data Export - Reservation ID                        *
      *  CDE003 - Data Export - MCR Limits Phase II (Recompiled)      *
      *  208221 - If fee amount is negative, the fee amount on the    *
      *           event should be positive with In/Out set to 'O'     *
      *           In transaction reference put blanks instead of all  *
      *           zeros for facility or loan part                     *
      *           Set up fee amount on opening position for           *
      *           non calculated fees and set up Input/Output field   *
      *           Enable DEWRKEDTA to get info from data area         *
      *           Set up spread change on take on.                    *
      *  204452 - Recompiled due to changed PF/LEFEED.                *
      *  CDE002 - Data Export - CCRM Revenue Analysis.                *
      *                                                               *
      *****************************************************************
      *
     FFACHSAL1  IF   E           K DISK
     FLEFHSTL2  IF   E           K DISK
     FLEFHSTL3  IF   E           K DISK                                                       CLE031
     F                                     RENAME(LEFHSTF:LEFHSTF3)                           CLE031
     FFCLTYL0   IF   E           K DISK
     FDEPTRANPD O    E           K DISK
     FDEPPOSNPD O    E           K DISK
     FDEPEVNTPD O    E           K DISK
     FDEPCASHPD O    E           K DISK
      *
      * E X T R A C T   F I L E S
     D/COPY DECPYSRC,DEXTFILS
      * P E R I O D   D E T A I L S
     D/COPY DECPYSRC,DEXTPERDD
      *
     D FAMT            S             11  0 DIM(5) ASCEND                        FEE AMOUNTS
      *
     D FAM             S             13  0 DIM(5) ASCEND                        FEE AMOUNTS
      *
      * Power array
     D POWER           S              7  3 DIM(7) CTDATA PERRCD(1)              POWERS OF 10
      *
      **--------------------------------------------------------------------------------------------
      *                                                               *
      *  AR674226 - Manual transaction reached 999. Increase the size *
      *             of utilisation sequence no. and transaction       *
      *             sequence. Recompile. (Child: AR674227)            *
      *           - Applied for MD054782.                             *
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
      *                                                               *
      *  AR674226 - Manual transaction reached 999. Increase the size *
      *             of utilisation sequence no. and transaction       *
      *             sequence. Recompile. (Child: AR674227)            *
      *           - Applied for MD054782.                             *
     D WNOML           S                   LIKE(P#NOML)
     D WSTBAL          S                   LIKE(FAUNDR)
     D WOPNBL          S                   LIKE(FAUNDR)
     D WRTDTE          S                   LIKE(FE_FEPSTD)
     D WHSDTE          S                   LIKE(HIHDAT)
     D WPEDTE          S                   LIKE(FE_FEPSTD)
     D WRKAGR          S                   LIKE(FAUNDR)
     D WTAGBL          S                   LIKE(FAUNDR)
     D WAVBAL          S                   LIKE(FAUNDR)
     D WRKAMT          S                   LIKE(FAUNDR)
     D WTOTDY          S                   LIKE(HIHDAT)
     D WRKDYS          S                   LIKE(HIHDAT)
     D WCNVAM          S                   LIKE(FAUNDR)
     D WBCAMT          S                   LIKE(FAUNDR)
     D WFNBDP          S                   LIKE(A6NBDP)
     D WBNBDP          S                   LIKE(A6NBDP)
     D WFENDP          S                   LIKE(A6NBDP)
     D WFSPRT          S                   LIKE(A6SPRT)
     D WFESRT          S                   LIKE(A6SPRT)
     D WFMDIN          S                   LIKE(A6MDIN)
     D WFEMDI          S                   LIKE(A6MDIN)
     D WFCCY           S                   LIKE(FCCY)
     D WOPNFL          S              1
     D X               S              2  0
     D P               S              2  0
      *
      **
     D LEFEEX        E DS                  EXTNAME(LEFEED) PREFIX(FE_)
     D FACHISX       E DS                  EXTNAME(FACHISA) PREFIX(FH_)
      *
      **  Fee Transaction Reference
     D W#FEEID         DS
     D**W#CNUM**               1      6  0                                                    CSD027
     D  W#CNUM                 1      6A                                                      CSD027
     D  W#FACL                 7     11  0
     D  W#FACLA                7     11                                                       208221
     D  W#FTYP                 7      9  0                                                    208221
     D**W#LOAN**              12     17  0                                                    CLE148
     D**W#LOANA*              12     17                                                208221 CLE148
     D  W#LOAN                12     17                                                       CLE148
     D  W#FSEQ                18     19  0
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** External DS for GENERAL LEDGER details
     D SDFEE         E DS                  EXTNAME(SDFEEPD)
      ** External DS for LENDING FEE details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External DS for CURRENCY details
     D SCSARD        E DS                  EXTNAME(SCSARDPD) PREFIX(SF_)                      CDE005
      ** External DS for Switchable Features details                                          CDE005
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D DEEXTCTL      E DS                  EXTNAME(DEEXTCTL)                                  208221
      ** Extract Control Data                                                                 208221
                                                                                              208221
      *
      * Transaction Initialisation
      *
     C                   EXSR      TRANIT
      *
      * Main Processing
      *
     C                   EXSR      MAIN
      *
      * Commitment Processing for Fee
      *
     C                   EXSR      COMIT
      *
      * Return
      *
     C                   RETURN
      *
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * TRANIT - Transaction Initialisation                           *
      *****************************************************************
     C     TRANIT        BEGSR
      *
      * Clear Transaction Details
      *
     C                   CLEAR                   T#TRAN
      *
      * Module
     C                   MOVEL     'LE'          T#MOD
      *
      * Transaction Reference
     C**********         Z-ADD     FE_FECNUM     W#CNUM                                       CSD027
     C                   EVAL      W#CNUM = FE_FECNUM                                         CSD027
     C                   IF        FE_FEFACL = 0                                              208221
     C                   MOVEL     *BLANKS       W#FACLA                                      208221
     C                   ELSE                                                                 208221
     C                   Z-ADD     FE_FEFACL     W#FACL
     C                   ENDIF                                                                208221
     C**********         IF        FE_FELOAN = 0                                       208221 CLE148
     C**********         MOVEL     *BLANKS       W#LOANA                               208221 CLE148
     C**********         ELSE                                                          208221 CLE148
     C**********         Z-ADD     FE_FELOAN     W#LOAN                                       CLE148
     C**********         ENDIF                                                         208221 CLE148
     C                   MOVEL     FE_FELOAN     W#LOAN                                       CLE148
     C                   Z-ADD     FE_FEFSEQ     W#FSEQ
     C                   MOVEL     W#FEEID       T#TREF

      ** If the fee is facility related
     C                   IF        FE_FEFACL <> 0

      ** Transaction Type
     C**********         MOVEL     FE_FEFACL     T#TRTP                                       208221
     C                   MOVEL     W#FTYP        T#TRTP                                       208221
      ** Transaction sub-type
     C                   EVAL      T#TRST = *Blanks

     C                   ENDIF

      ** If the fee is loan related
     C**********         IF        FE_FELOAN <> 0                                             CLE148
     C                   IF        FE_FELOAN <> *BLANKS                                       CLE148

      ** Transaction Type
     C                   EVAL      T#TRTP = FE_FELTYP
      ** Transaction sub-type
     C                   EVAL      T#TRST = FE_FESUTP

     C                   ENDIF

      ** Transaction fee code
     C                   MOVEL     FE_FEFCOD     T#FEEC

      ** Transaction calculated fee
     C                   EVAL      T#CAFE = 'Y'
     C                   MOVE      FE_FEFCOD     @FECD
      *
      * Access Fee Code details
      *
     C                   CALL      'AOFEER0'
     C                   PARM      *Blanks       @RTCD             7
     C                   PARM      '*KEY'        @OPTN             7
     C                   PARM                    @FECD             2
     C     SDFEE         PARM      SDFEE         DSFDY
      *
     C                   IF        @RTCD <> *Blanks
     C                   MOVEL     '*ERROR'      I#RTCD
     C                   MOVEL     'AOFEER0'     I#ERMS
     C                   MOVE      '1'           *INLR
     C                   RETURN
     C                   ENDIF
      *
      * Transaction Description
      *
     C                   EVAL      T#TDES = AUFENV
      *
      * Transaction Deal Date
      *
     C                   IF        FE_FEPSTD < FE_FEORED
     C                   EVAL      T#DDAT = FE_FEPSTD
     C                   ELSE
     C                   EVAL      T#DDAT = FE_FEORED
     C                   ENDIF
      *
     C                   EVAL      T#VDAT = FE_FEPSTD
     C                   EVAL      T#MDAT = FE_FEPEND
     C                   EVAL      T#BRCA = FE_FEBRCA
     C                   EVAL      T#CPTY = FE_FECNUM
     C                   EVAL      T#RCST = FE_FECNUM
      *
     C**********         IF        FE_FELOAN = 0                                              CLE148
     C                   IF        FE_FELOAN = *BLANKS                                        CLE148
     C     KYFCTY        KLIST
     C                   KFLD                    FE_FECNUM
     C                   KFLD                    WFACT             3 0
     C                   KFLD                    WFCNO             2 0
     C                   MOVEL     FE_FEFACL     WFACT
     C                   MOVE      FE_FEFACL     WFCNO
      *
     C     KYFCTY        CHAIN     FCLTYL0                            97
      *
     C                   IF        NOT *IN97
     C                   EVAL      WFCCY = FCCY
     C                   ELSE
     C                   MOVEL     '*ERROR'      I#RTCD
     C                   MOVEL     'FCLTYL0'     I#ERMS
     C                   MOVE      '1'           *INLR
     C                   RETURN
     C                   ENDIF
      *
      * Access Facility Currency Details
      *
     C                   MOVE      *BLANKS       @CYCD
     C                   MOVEL     FCCY          @CYCD
     C                   EXSR      ACSCCY
      *
     C                   IF        @RTCD = *BLANKS
     C                   EVAL      WFNBDP = A6NBDP
     C                   EVAL      WFSPRT = A6SPRT
     C                   EVAL      WFMDIN = A6MDIN
     C                   ELSE
     C                   MOVEL     '*ERROR'      I#RTCD
     C                   MOVEL     'AOCURRR0'    I#ERMS
     C                   MOVE      '1'           *INLR
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
      *
     C                   EVAL      T#VCCY = FE_FEFCCY
      *
      * Access Fee Currency Details
      *
     C                   MOVE      *BLANKS       @CYCD
     C                   MOVEL     FE_FEFCCY     @CYCD
     C                   EXSR      ACSCCY
      *
     C                   IF        @RTCD = *BLANKS
     C                   EVAL      WFENDP = A6NBDP
     C                   EVAL      WFESRT = A6SPRT
     C                   EVAL      WFEMDI = A6MDIN
     C                   ELSE
     C                   MOVEL     '*ERROR'      I#RTCD
     C                   MOVEL     'AOCURRR0'    I#ERMS
     C                   MOVE      '1'           *INLR
     C                   RETURN
     C                   ENDIF
      *
     C                   MOVEL     A6NBDP        T#VCDP
     C                   MOVEL     I#ACTN        T#ACTN
      *                                                                                       CDE005
      * Reservation ID                                                                        CDE005
      *                                                                                       CDE005
     C     CDE005        IFEQ      'Y'                                                        CDE005
     C                   MOVEL     I#RSRV        T#RSRV           10                          CDE005
     C                   ENDIF                                                                CDE005
      *
     C                   MOVEL     '*IMPTRAN'    W#MODE
     C                   EXSR      WRKEDTA
      *
      * Reset Export Indicators
      *
     C                   MOVEL     *BLANK        POSN_Exp          1
     C                   MOVEL     *BLANK        EVNT_Exp          1
     C                   MOVEL     *BLANK        CASH_Exp          1
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * IMPORT - Import Opening Position and Events                   *
      *****************************************************************
     C     IMPORT        BEGSR
      *
     C                   MOVEL     FH_FAUNDR     FAUNDR
     C                   MOVEL     FH_FADRAM     FADRAM
     C                   MOVEL     FH_FACFAM     FACFAM
      *
      * Import Opening Balance
      *
     C                   EXSR      OPENBL
     C                   EVAL      WSTBAL = 0
      *
      * If Fee is not calculated, or is calculated but not on
      * an Average Balance Method
      *
     C                   IF        FE_FECALT <>'01' AND FE_FECALT <>'02' AND
     C                             FE_FECALT <>'03' AND FE_FECALT <>'11' AND
     C                             FE_FECALT <>'12' AND FE_FECALT <>'13' AND
     C                             FE_FECALT <>'21'
      *
     C                   EVAL      WSTBAL = WOPNBL
     C                   ELSE
      *
      * If the Fee is calculated on an Average Balance Method
      * Position the files LF/FACHSAL1 and LF/LEFHSTL2 and read the next
      * record with same customer and facility as the fee.
      *
     C     KYFCHS        SETGT     FACHSAL1
      *
     C     KYLEFH        SETLL     LEFHSTL2
      *
     C     KYFHFC        READE     FACHSAL1                               98
     C                   IF        *IN98
     C                   EVAL      FADATE = 99999
     C                   ENDIF
      *
     C     KYLEFH        READE     LEFHSTL2                               99
     C                   IF        *IN99
     C                   EVAL      HIHDAT = 99999
     C                   ENDIF
      *
      * Initialise work field for determining average balance
      *
     C                   EVAL      WTAGBL = *Zeros
     C                   EVAL      WTOTDY = *Zeros
      *
      * Compute for Average balance starting after Fee period start date
      * until the last fee history date.
      *
     C                   IF        FADATE < HIHDAT
      *
     C                   EVAL      WHSDTE = FE_FEPSTD
     C                   DOU       *IN98 OR FADATE > BJRDNB
      *
     C                   EVAL      WRKDYS = FADATE - WHSDTE
     C                   EVAL      WHSDTE = FADATE
     C                   EVAL      WRKAGR = WOPNBL * WRKDYS
     C                   EVAL      WTAGBL = WTAGBL + WRKAGR
     C                   EVAL      WTOTDY = WTOTDY + WRKDYS
     C                   EXSR      OPENBL
      *
     C     KYFHFC        READE     FACHSAL1                               98
     C                   ENDDO
     C                   EVAL      WSTBAL = WTAGBL / WTOTDY
      *
      * If the fee is already in history, compute for the final average
      * balance.
      *
     C                   ELSE
     C                   IF        HIHDAT <> 99999
     C                   EVAL      WRKDYS = HIHDAT - FE_FEPSTD
     C                   EVAL      WRKAGR = WOPNBL * WRKDYS
     C                   EVAL      WSTBAL = WRKAGR / WRKDYS
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      * Convert Amount if fee currency is different with facility ccy
      *
     C                   IF        FE_FEFCCY <> FCCY
     C                   EVAL      WCNVAM = WSTBAL
     C                   EXSR      CVTAMT
     C                   EVAL      WNOML = WCNVAM
     C                   ELSE
     C                   EVAL      WNOML = WSTBAL
     C                   ENDIF
      *
      * Import Opening Position
      *
     C                   EXSR      IMPOPOS
      *
     C                   MOVEL     FH_FAUNDR     FAUNDR
     C                   MOVEL     FH_FADRAM     FADRAM
     C                   MOVEL     FH_FACFAM     FACFAM
      *
      * Import Opening Balance
      *
     C                   EXSR      OPENBL
      *
      * Import Deal Date event for all fees
      *
     C                   EXSR      IMPODDE
      *
      * If Fee is not calculated, or is calculated but not on
      * an Average Balance Method
      *
     C                   IF        FE_FECALT <>'01' AND FE_FECALT <>'02' AND
     C                             FE_FECALT <>'03' AND FE_FECALT <>'11' AND
     C                             FE_FECALT <>'12' AND FE_FECALT <>'13' AND
     C                             FE_FECALT <>'21'
      *
     C                   EVAL      WSTBAL = WOPNBL
      *
      * Convert Amount if fee currency is different with facility ccy
      *
     C                   IF        FE_FEFCCY <> FCCY
     C                   EVAL      WCNVAM = WSTBAL
     C                   EXSR      CVTAMT
     C                   EVAL      P#NOML = WCNVAM
     C                   ELSE
     C                   EVAL      P#NOML = WSTBAL
     C                   ENDIF
      *
      * Import Rate Event for Calculated fees.  For non-calculated fees,
      * Import Flat Fee Payment Event
      *
     C                   IF        FE_FECALT <> *Blanks
     C                   IF        FE_FELPDT = 0 OR
     C                             FE_FELPDT = BJRDNB AND
     C                             FE_FEPLPD = 0 OR
     C                             DETKON = BJRDNB OR                                         208221
     C                             FE_FEORED = BJRDNB
     C                   EVAL      WRTDTE = FE_FEPSTD
     C                   EXSR      IMPORAT
     C                   ENDIF
      *
     C                   ELSE
      *                                                                                       CLE031
      * Read all the records of the fee in fee history file                                   CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C     KYLEF3        SETLL     LEFHSTL3                                                   CLE031
     C     KYLEF3        READE     LEFHSTL3                               99                  CLE031
      *                                                                                       CLE031
     C                   DOW       NOT *IN99                                                  CLE031
      *                                                                                       CLE031
      * Import Mulitple Flat Fee Payment Event                                                CLE031
      *                                                                                       CLE031
     C                   EXSR      IMPOMFE                                                    CLE031
      *                                                                                       CLE031
     C     KYLEF3        READE     LEFHSTL3                               99                  CLE031
     C                   ENDDO                                                                CLE031
     C                   ENDIF                                                                CLE031
      *                                                                                       CLE031
     C                   EVAL      Work_Date = FE_FEPSTD                                      CLE031
     C     FE_FELPDT     IFNE      0                                                          CLE031
     C     CLE031        ANDEQ     'Y'                                                        CLE031
     C                   EVAL      Work_Date = FE_FELPDT                                      CLE031
     C                   ENDIF                                                                CLE031
      *                                                                                       CLE031
     C                   EXSR      IMPOFFE
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C     FE_FENPYD     ANDNE     0                                                          CLE031
     C     FE_FENPYD     ANDNE     FE_FEPEND                                                  CLE031
     C                   EVAL      Work_Date = FE_FENPYD                                      CLE031
     C                   EXSR      IMPOFFE                                                    CLE031
     C                   ENDIF                                                                CLE031
      *                                                                                       CLE031
     C                   ENDIF
      *
      * If the Fee is calculated on an Average Balance Method
      *
     C                   ELSE
      *
      * Set key list
      *
     C     KYFHFC        KLIST
     C                   KFLD                    FH_FACNUM
     C                   KFLD                    FH_FAFCTY
      *
     C     KYFCHS        KLIST
     C                   KFLD                    FH_FACNUM
     C                   KFLD                    FH_FAFCTY
     C                   KFLD                    FH_FADATE
      *
     C     KYLEFH        KLIST
     C                   KFLD                    FE_FECNUM
     C                   KFLD                    FE_FEFACL
     C                   KFLD                    FE_FEFSEQ
      *                                                                                       CLE031
     C     KYLEF3        KLIST                                                                CLE031
     C                   KFLD                    FE_FECNUM                                    CLE031
     C                   KFLD                    FE_FEFACL                                    CLE031
     C                   KFLD                    FE_FELOAN                                    CLE031
     C                   KFLD                    FE_FEFSEQ                                    CLE031
      *
      * Position the files LF/FACHSAL1 and LF/LEFHSTL2 and read the next
      * record with same customer and facility as the fee.
      *
     C     KYFCHS        SETGT     FACHSAL1
      *
     C     KYLEFH        SETLL     LEFHSTL2
      *
     C     KYFHFC        READE     FACHSAL1                               98
     C                   IF        *IN98
     C                   EVAL      FADATE = 99999
     C                   ENDIF
      *
     C     KYLEFH        READE     LEFHSTL2                               99
     C                   IF        *IN99
     C                   EVAL      HIHDAT = 99999
     C                   ENDIF
      *
      * Initialise work field for determining average balance
      *
     C                   EVAL      WOPNFL = *Blanks
     C                   EVAL      WHSDTE = FE_FEPSTD
     C                   EVAL      WPEDTE = FE_FEPSTD
     C                   EVAL      WTAGBL = *Zeros
     C                   EVAL      WTOTDY = *Zeros
      *
      * Compute for Average balance starting after Fee period start date
      * until the last fee history date.
      *
     C                   DOW       NOT *IN98 OR NOT *IN99
      *
     C                   IF        FADATE < HIHDAT
     C                   EVAL      WRKDYS = FADATE - WHSDTE
     C                   EVAL      WHSDTE = FADATE
     C                   EVAL      WRKAGR = WOPNBL * WRKDYS
     C                   EVAL      WTAGBL = WTAGBL + WRKAGR
     C                   EVAL      WTOTDY = WTOTDY + WRKDYS
     C                   EXSR      OPENBL
      *
     C     KYFHFC        READE     FACHSAL1                               98
     C                   IF        *IN98
     C                   EVAL      FADATE = 99999
     C                   ENDIF
      *
      * If the fee is already in history, compute for the final average
      * balance.
      *
     C                   ELSE
     C                   IF        HIHDAT <> 99999
     C                   EVAL      WRKDYS = HIHDAT - WHSDTE
     C                   EVAL      WHSDTE = HIHDAT
     C                   EVAL      WRKAGR = WOPNBL * WRKDYS
     C                   EVAL      WTAGBL = WTAGBL + WRKAGR
     C                   EVAL      WTOTDY = WTOTDY + WRKDYS
     C                   EVAL      WAVBAL = WTAGBL / WTOTDY
      *
      * Determine opening balance
      *
     C                   IF        FADATE = HIHDAT
     C                   EXSR      OPENBL
     C                   ENDIF
      *
      * Work opening position flag is blank on first pass
      *
     C                   IF        WOPNFL = *Blank
     C                   EVAL      WSTBAL = WAVBAL
      *
      * Convert Amount if fee currency is different with facility ccy
      *
     C                   IF        FE_FEFCCY <> FCCY
     C                   EVAL      WCNVAM = WSTBAL
     C                   EXSR      CVTAMT
     C                   EVAL      P#NOML = WCNVAM
     C                   ELSE
     C                   EVAL      P#NOML = WSTBAL
     C                   ENDIF
      *
     C                   EVAL      WOPNFL = 'Y'
     C                   EVAL      WPEDTE = HIHDAT
      *
      * Import Opening Rate Event if Last payment date is zero
      *
     C                   IF        FE_FELPDT = 0 OR
     C                             FE_FELPDT = BJRDNB AND
     C                             FE_FEPLPD = 0 OR
     C                             DETKON = BJRDNB OR                                         208221
     C                             FE_FEORED = BJRDNB
     C                   EVAL      WRTDTE = FE_FEPSTD
     C                   EXSR      IMPORAT
     C                   ENDIF
     C                   ELSE
      *
      * Import Opening Rate Event if Fee History date is equal to Last
      * Payment date
      *
     C                   IF        HIHDAT = FE_FELPDT  AND
     C                             FE_FELPDT <> BJRDNB AND
     C                             FE_FEORED <> BJRDNB
     C                   EVAL      WRTDTE = WPEDTE
     C                   EXSR      IMPORAT
     C                   ENDIF
      *
     C                   EVAL      WRKAMT = WSTBAL - WAVBAL
     C                   EVAL      WSTBAL = WAVBAL
      *
      * Import Movement Event
      *
     C                   EXSR      IMPOMVT
     C                   ENDIF
      *
      * Import Calculated Fee Payment Event
      *
     C                   EXSR      IMPOCFE
      *
     C     KYLEFH        READE     LEFHSTL2                               99
     C                   IF        *IN99
     C                   EVAL      HIHDAT = 99999
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF
      *
      * If Fee is calculated but not on an Average Balance Method
      *
     C                   IF        FE_FECALT <> '01' AND
     C                             FE_FECALT <> '02' AND
     C                             FE_FECALT <> '03' AND
     C                             FE_FECALT <> '11' AND
     C                             FE_FECALT <> '12' AND
     C                             FE_FECALT <> '13' AND
     C                             FE_FECALT <> '21' AND
     C                             FE_FECALT <> *Blanks
      *
      * Read all the records of the facility in history with value date
      * later than fee period start date
      *
     C     KYFCHS        SETGT     FACHSAL1
     C     KYFHFC        READE     FACHSAL1                               98
      *
     C                   DOW       NOT *IN98
     C                   EVAL      WPEDTE = FADATE
      *
      * Select which amount to be used depending on fee calculation type
      *
     C                   SELECT
     C                   WHEN      FE_FECALT = '04' OR FE_FECALT = '05' OR
     C                             FE_FECALT = '06'
     C                   EVAL      WRKAMT = WSTBAL - FAUNDR
     C                   EVAL      WSTBAL = FAUNDR
      *
     C                   WHEN      FE_FECALT = '14' OR FE_FECALT = '15' OR
     C                             FE_FECALT = '16'
     C                   EVAL      WRKAMT = WSTBAL - FADRAM
     C                   EVAL      WSTBAL = FADRAM
      *
     C                   WHEN      FE_FECALT = '22'
     C                   EVAL      WRKAMT = WSTBAL - FACFAM
     C                   EVAL      WSTBAL = FACFAM
     C                   ENDSL
      *
      * Import Movement Event
      *
     C                   EXSR      IMPOMVT
     C     KYFHFC        READE     FACHSAL1                               98
     C                   ENDDO
      *
      * Read all the records of the fee in fee history file
      *
     C     KYLEFH        SETLL     LEFHSTL2
     C     KYLEFH        READE     LEFHSTL2                               99
      *
     C                   DOW       NOT *IN99
      *
      * Import Calculated Fee Payment Event
      *
     C                   EXSR      IMPOCFE
      *
      * Import Rate Event if Fee history date is equal to last payment date
      *
     C                   IF        HIHDAT = FE_FELPDT  AND
     C                             FE_FELPDT <> BJRDNB AND
     C                             FE_FEORED <> BJRDNB
     C                   EVAL      WRTDTE = FE_FELPDT
     C                   EXSR      IMPORAT
     C                   ENDIF
      *
     C     KYLEFH        READE     LEFHSTL2                               99
     C                   ENDDO
      *
     C                   ENDIF
      *
     C                   IF        FE_FEPEND <> *Zeros
      *
      * Clear Event
      *
     C                   CLEAR                   E#EVNT
      *
      * Event Module and Event Transaction
      *
     C                   EVAL      E#TKEY = T#TKEY
     C                   EVAL      E#ASLI = 'A'
     C                   EVAL      E#PRDT = FE_FEPEND
     C                   EVAL      E#EVTP = 'MT'
     C                   EVAL      E#SSET = 'Y'
                                                                                              208221
     C                   IF        FE_FEFAMT < 0                                              208221
     C                   EVAL      E#IO = 'O'                                                 208221
     C                   ELSE                                                                 208221
     C                   EVAL      E#IO = 'I'                                                 208221
     C                   ENDIF                                                                208221
      *
      ** Import the maturity date event
      *
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
     C                   ENDIF
      *
      * Import Period End Dates
      *
     C                   EXSR      IMP_PE
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * OPENBL  - Import Opening Balance                              *
      *****************************************************************
     C     OPENBL        BEGSR
      *
      * Set up opening balance depending on calculation type
      *
     C                   SELECT
      *
     C                   WHEN      FE_FECALT = '01' OR FE_FECALT = '02' OR
     C                             FE_FECALT = '03' OR FE_FECALT = '04' OR
     C                             FE_FECALT = '05' OR FE_FECALT = '06'
     C                   EVAL      WOPNBL = FAUNDR
      *
     C                   WHEN      FE_FECALT = '11' OR FE_FECALT = '12' OR
     C                             FE_FECALT = '13' OR FE_FECALT = '14' OR
     C                             FE_FECALT = '15' OR FE_FECALT = '16'
     C                   EVAL      WOPNBL = FADRAM
      *
     C                   WHEN      FE_FECALT = '21' OR FE_FECALT = '22'
     C                   EVAL      WOPNBL = FACFAM
      *
     C                   WHEN      FE_FECALT = *Blanks
     C                   EVAL      WOPNBL = *Zeros
      *
     C                   ENDSL
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * IMPOPOS - Import Opening Position                             *
      *****************************************************************
     C     IMPOPOS       BEGSR
      *
      * Clear Position details
      *
     C                   CLEAR                   P#POSN
      *
      * Set up Projected Position Fields
      *
     C                   EVAL      P#TKEY = T#TKEY
     C                   EVAL      P#ASLI = 'A'
     C                   EVAL      P#IACD = FE_FEPSTD
      *
     C                   EVAL      P#NOML = WNOML
     C                   EVAL      P#CCY = FE_FEFCCY
     C                   EVAL      P#NCDP = A6NBDP
     C                   EVAL      P#NMDP = A6NBDP
     C                   EVAL      P#SPDY = A6SPDY
     C                   EVAL      P#ACUR = 9
      *
     C                   EXSR      CALMETH
     C                   EVAL      P#ICMT = W#ICMT
      *
      * Position  Accrue Interest and Accrue Fee depending on Calculation
      * type and Payment on Indicator
      *
     C                   IF        FE_FECALT <> *BLANKS
     C                   EVAL      P#ACIN = 'Y'
     C                   EVAL      P#ACFE = *BLANK
      *
     C                   ELSE
     C                   EVAL      P#ACIN = *BLANK
     C                   EVAL      P#FEE = FE_FEFAMT                                          208221
      *
     C                   IF        FE_FEPYON = *BLANK
     C                   EVAL      P#ACFE = *BLANK
     C                   ELSE
     C                   EVAL      P#ACFE = 'Y'
     C                   ENDIF
      *
     C                   ENDIF
      *
      * Import Opening Position
      *
     C                   MOVEL     '*IMPOPBL'    W#MODE
     C                   EXSR      WRKEDTA
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      ********************************************************************
      * IMPODDE - Import Deal Date Event                              *
      ********************************************************************
     C     IMPODDE       BEGSR
      *
      **  Clear event data structure
     C                   CLEAR                   E#EVNT
      *
      **  Set up projected event data structure
     C                   EVAL      E#TKEY = T#TKEY
     C                   EVAL      E#ASLI = 'A'
     C                   EVAL      E#PRDT = T#DDAT
     C                   EVAL      E#PRSQ = *Zero
     C                   EVAL      E#EVTP = 'DD'
                                                                                              208221
     C                   IF        FE_FEFAMT < 0                                              208221
     C                   EVAL      E#IO = 'O'                                                 208221
     C                   ELSE                                                                 208221
     C                   EVAL      E#IO = 'I'                                                 208221
     C                   ENDIF                                                                208221
      *
      **  Import the details of the deal date event
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
      *
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * IMPORAT - Import Rate Event                                   *
      *****************************************************************
     C     IMPORAT       BEGSR
      *
      * Clear Event
      *
     C                   CLEAR                   E#EVNT
      *
      * Set up Projected Event Fields
      *
     C                   EVAL      E#TKEY = T#TKEY
     C                   EVAL      E#ASLI = 'A'
     C                   EVAL      E#PRDT = WRTDTE
     C                   EVAL      E#EVTP = 'SC'
     C                   EVAL      E#IRCH = 'Y'
                                                                                              208221
     C                   IF        FE_FEFAMT < 0                                              208221
     C                   EVAL      E#IO = 'O'                                                 208221
     C                   ELSE                                                                 208221
     C                   EVAL      E#IO = 'I'                                                 208221
     C                   ENDIF                                                                208221
      *
      * Determine Effective Rate
      *
     C                   EXSR      CALEFRT
     C                   EVAL      E#RTSP = W#FERT
      *
      * Determine Calculation Method
      *
     C                   EXSR      CALMETH
     C                   EVAL      E#ICMT = W#ICMT
      *
      * Import Event Rate
      *
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * IMPOMVT - Import Movement Event                               *
      *****************************************************************
     C     IMPOMVT       BEGSR
      *
      * Clear Event
      *
     C                   CLEAR                   E#EVNT
      *
      * Set up Projected Event Fields
      *
     C                   EVAL      E#TKEY = T#TKEY
     C                   EVAL      E#ASLI = 'A'
     C                   EVAL      E#PRDT = WPEDTE
      *
      * Set up Event type
      *
     C                   IF        WRKAMT < *Zero
     C                   Z-SUB     WRKAMT        WRKAMT
     C                   EVAL      E#EVTP = 'PI'
     C                   ELSE
     C                   EVAL      E#EVTP = 'PD'
     C                   ENDIF
      *
     C                   IF        FE_FEFCCY <> FCCY
     C                   EVAL      WCNVAM = WRKAMT
     C                   EXSR      CVTAMT
     C                   EVAL      E#PRAM = WCNVAM
     C                   ELSE
     C                   EVAL      E#PRAM = WRKAMT
     C                   ENDIF
                                                                                              208221
     C                   IF        FE_FEFAMT < 0                                              208221
     C                   EVAL      E#IO = 'O'                                                 208221
     C                   ELSE                                                                 208221
     C                   EVAL      E#IO = 'I'                                                 208221
     C                   ENDIF                                                                208221
      *
      * Import Opening rate event
      *
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * IMPOCFE - Import Calculated Fee Payment Event                 *
      *****************************************************************
     C     IMPOCFE       BEGSR
      *
      * Clear Event
      *
     C                   CLEAR                   E#EVNT
      *
      * Set up Projected Event Fields
      *
     C                   EVAL      E#TKEY = T#TKEY
     C                   EVAL      E#ASLI = 'A'
     C                   EVAL      E#PRDT = HIHDAT
      *
      * Although this is a Fee Payment amount, for calculated fees the
      * amounts are reworked in the same manner as interest, therefore
      * the fee settlements is effectively an Interest Payment event in
      * this case
      *
     C                   EVAL      E#EVTP = 'IP'
     C                   EVAL      E#INTA = HIAMTS

      ** Event fee code
     C                   EVAL      E#FEEC = T#FEEC
                                                                                              208221
     C                   IF        FE_FEFAMT < 0                                              208221
     C                   EVAL      E#IO = 'O'                                                 208221
     C                   ELSE                                                                 208221
     C                   EVAL      E#IO = 'I'                                                 208221
     C                   ENDIF                                                                208221
      *
      * Import Fee interest Payment event
      *
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * IMPOFFE - Import Flat Fee Payment Event                       *
      *****************************************************************
     C     IMPOFFE       BEGSR
      *
      * Clear Event
      *
     C                   CLEAR                   E#EVNT
      *
      * Set up Projected Event Fields
      *
     C                   EVAL      E#TKEY = T#TKEY
     C                   EVAL      E#ASLI = 'A'
     C*************      EVAL      E#PRDT = FE_FEPSTD                                         CLE031
     C                   EVAL      E#PRDT = Work_Date                                         CLE031
     C                   EVAL      E#EVTP = 'FE'
                                                                                              208221
     C                   IF        FE_FEFAMT < 0                                              208221
     C                   EVAL      E#FEE = - FE_FEFAMT                                        208221
     C                   EVAL      E#TAMT = - FE_FEFAMT                                       208221
     C                   EVAL      E#IO = 'O'                                                 208221
     C                   ELSE                                                                 208221
     C                   EVAL      E#FEE = FE_FEFAMT
     C                   EVAL      E#TAMT = FE_FEFAMT
     C                   EVAL      E#IO = 'I'                                                 208221
     C                   ENDIF                                                                208221
                                                                                              208221
      *
     c                   IF        FE_FEPYON = *BLANK
     C                   EVAL      E#ACIN = *BLANK
     C                   ELSE
     C                   EVAL      E#ACIN = 'Y'
     C                   ENDIF

      ** Event fee code
     C                   EVAL      E#FEEC = T#FEEC
      *
      * Import the Fee Payment Event
      *
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
     C                   ENDSR
      *****************************************************************
     C/SPACE 5                                                                                CLE031
      *****************************************************************                       CLE031
      * IMPOMFE - Import Multiple Flat Fee Payment Event              *                       CLE031
      *****************************************************************                       CLE031
     C     IMPOMFE       BEGSR                                                                CLE031
      *                                                                                       CLE031
      * Clear Event                                                                           CLE031
      *                                                                                       CLE031
     C                   CLEAR                   E#EVNT                                       CLE031
      *                                                                                       CLE031
      * Set up Projected Event Fields                                                         CLE031
      *                                                                                       CLE031
     C                   EVAL      E#TKEY = T#TKEY                                            CLE031
     C                   EVAL      E#ASLI = 'A'                                               CLE031
     C                   EVAL      E#PRDT = HIHDAT                                            CLE031
     C                   EVAL      E#EVTP = 'FE'                                              CLE031
                                                                                              CLE031
     C                   IF        HIAMTS < 0                                                 CLE031
     C                   EVAL      E#FEE = - HIAMTS                                           CLE031
     C                   EVAL      E#TAMT = - HIAMTS                                          CLE031
     C                   EVAL      E#IO = 'O'                                                 CLE031
     C                   ELSE                                                                 CLE031
     C                   EVAL      E#FEE = HIAMTS                                             CLE031
     C                   EVAL      E#TAMT = HIAMTS                                            CLE031
     C                   EVAL      E#IO = 'I'                                                 CLE031
     C                   ENDIF                                                                CLE031
                                                                                              CLE031
      *                                                                                       CLE031
     c                   IF        FE_FEPYON = *BLANK                                         CLE031
     C                   EVAL      E#ACIN = *BLANK                                            CLE031
     C                   ELSE                                                                 CLE031
     C                   EVAL      E#ACIN = 'Y'                                               CLE031
     C                   ENDIF                                                                CLE031
                                                                                              CLE031
      ** Event fee code                                                                       CLE031
     C                   EVAL      E#FEEC = T#FEEC                                            CLE031
      *                                                                                       CLE031
      * Import the Fee Payment Event                                                          CLE031
      *                                                                                       CLE031
     C                   MOVEL     '*IMPEVNT'    W#MODE                                       CLE031
     C                   EXSR      WRKEDTA                                                    CLE031
     C                   ENDSR                                                                CLE031
      *****************************************************************                       CLE031
     C/SPACE 5
      *****************************************************************
      * CALEFRT - Calculate Fee Effective Rate                        *
      *****************************************************************
     C     CALEFRT       BEGSR
      *
     C                   EVAL      W#FERT = *Zeros
      *
      * Single-rate fees
      *
     C                   IF        FE_FECALT = '03' OR FE_FECALT = '06' OR
     C                             FE_FECALT = '13' OR FE_FECALT = '16' OR
     C                             FE_FECALT = '21' OR FE_FECALT = '22'
      *
     C                   EVAL      W#FERT = FE_FEFRT1
     C                   ELSE
      *
      * Tiered-rate fees
      *
     C                   IF        FE_FECALT = '01' OR FE_FECALT = '04' OR
     C                             FE_FECALT = '11' OR FE_FECALT = '14'
     C                   EVAL      W#TIER = 1
     C                   ENDIF
      *
      * Threshold-rate fees
      *
     C                   IF        FE_FECALT = '02' OR FE_FECALT = '05' OR
     C                             FE_FECALT = '12' OR FE_FECALT = '15'
     C                   EVAL      W#TIER = 0
     C                   ENDIF
      *
     C                   IF        FE_FEFCCY <> FCCY
     C                   EVAL      WCNVAM = WSTBAL
     C                   EXSR      CVTAMT
     C                   ELSE
     C                   EVAL      WCNVAM = WSTBAL
     C                   ENDIF
      *
      * Set-up fee amount for fee decimal places
      *
     C                   EVAL      FAMT(1) = FE_FEAMT1
     C                   EVAL      FAMT(2) = FE_FEAMT2
     C                   EVAL      FAMT(3) = FE_FEAMT3
     C                   EVAL      FAMT(4) = FE_FEAMT4
     C                   EVAL      FAMT(5) = FE_FEAMT5
      *
     C                   EVAL      P = A6NBDP + 4
     C                   Z-ADD     1             X
     C                   DOW       X <= 5
     C     FAMT(X)       MULT      POWER(P)      FAM(X)
     C                   EVAL      X = X+1
     C                   ENDDO
      *
      * Calculate Effective Rate if balance is not zero
      *
     C                   IF        WCNVAM <> *Zeros
     C                   CALLB     'DECALEFRT'
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS           30            * ERROR MESSAGE
     C                   PARM      'LE'          W#MODI            2            * ERROR MESSAGE
     C                   PARM      FE_FEFRT1     W#FRT1           11 7
     C                   PARM      FE_FEFRT2     W#FRT2           11 7
     C                   PARM      FE_FEFRT3     W#FRT3           11 7
     C                   PARM      FE_FEFRT4     W#FRT4           11 7
     C                   PARM      FE_FEFRT5     W#FRT5           11 7
     C                   PARM      *Zeros        W#FRT6           11 7
     C                   PARM      *Zeros        W#FRT7           11 7
     C                   PARM      *Zeros        W#FRT8           11 7
     C                   PARM      *Zeros        W#FRT9           11 7
     C                   PARM      *Zeros        W#FRT10          11 7
     C                   PARM      *Zeros        W#FRT11          11 7
     C                   PARM      FAM(1)        W#FAM1           15 0
     C                   PARM      FAM(2)        W#FAM2           15 0
     C                   PARM      FAM(3)        W#FAM3           15 0
     C                   PARM      FAM(4)        W#FAM4           15 0
     C                   PARM      FAM(5)        W#FAM5           15 0
     C                   PARM      *Zeros        W#FAM6           15 0
     C                   PARM      *Zeros        W#FAM7           15 0
     C                   PARM      *Zeros        W#FAM8           15 0
     C                   PARM      *Zeros        W#FAM9           15 0
     C                   PARM      *Zeros        W#FAM10          15 0
     C                   PARM      *Zeros        W#FAM11          15 0
     C                   PARM      WCNVAM        W#IBAL           15 0
     C                   PARM                    W#TIER            1 0
     C                   PARM      *ZERO         W#FERT           11 7
     C                   PARM      *ZERO         W#FEBL           15 0
      *
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO DECALFERT'
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * CALMETH - Determine Calculation Method                        *
      *****************************************************************
     C     CALMETH       BEGSR
      *
     C                   CALLB     'DECVTICDL'
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS           30            * ERROR MESSAGE
     C                   PARM      FE_FECALC     W#ICBS            1 0          * INT CAL BASIS
     C                   PARM      *BLANKS       W#ICMT            7            * INT CAL MTHD
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * CVTAMT - Conversion process for Facility Currency Amount      *
      *****************************************************************
     C     CVTAMT        BEGSR
      *
     C                   IF        FCCY <> BJCYCD
     C                   EXSR      CVTTOBASE
     C                   ELSE
     C                   EVAL      WBCAMT = WCNVAM
     C                   ENDIF
      *
     C                   IF        FE_FEFCCY <> BJCYCD
     C                   EXSR      CVTFMBASE
     C                   ELSE
     C                   EVAL      WCNVAM = WBCAMT
     C                   ENDIF
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      *****************************************************************
      * CVTTOBASE - Convert Facility Amount to Base currency          *
      *****************************************************************
     C     CVTTOBASE     BEGSR
      *
     C                   CALLB     'ZCONVZ1'
     C                   PARM      WCNVAM        ZAMTCI           15 0
     C                   PARM      WFSPRT        ZEXCH            13 8
     C                   PARM      WFMDIN        ZMD               1
     C                   PARM      FCCY          ZCCYI             3
     C                   PARM      BJCYCD        ZCCYO             3
     C                   PARM      WFNBDP        ZCDPI             1 0
     C                   PARM      WBNBDP        ZCDPO             1 0
     C                   PARM      *Zeros        ZAMTCO           15 0
      *
     C                   EVAL      WBCAMT = ZAMTCO
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      *****************************************************************
      * CVTFMBASE - Convert Base Currency Amount to Fee Currency      *
      *****************************************************************
     C     CVTFMBASE     BEGSR
      *
     C                   IF        WFEMDI = 'M'
     C                   EVAL      ZMD = 'D'
     C                   ELSE
     C                   EVAL      ZMD = 'M'
     C                   ENDIF
      *
     C                   CALLB     'ZCONVZ1'
     C                   PARM      WBCAMT        ZAMTCI
     C                   PARM      WFESRT        ZEXCH
     C                   PARM                    ZMD
     C                   PARM      BJCYCD        ZCCYI
     C                   PARM      FE_FEFCCY     ZCCYO
     C                   PARM      WBNBDP        ZCDPI
     C                   PARM      WFENDP        ZCDPO
     C                   PARM      *Zeros        ZAMTCO
      *
     C                   EVAL      WCNVAM = ZAMTCO
     C                   ENDSR
     C/SPACE 5
      ********************************************************************
      * ACCESS CURRENCY DETAILS
      ********************************************************************
     C     ACSCCY        BEGSR
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*KEY    '    @OPTN             7
     C                   PARM                    @CYCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
     C                   ENDSR
      ********************************************************************
      * *INZSR --- Initial Processing                                 *
      ********************************************************************
     C     *INZSR        BEGSR
      *
      * Input Parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7            * RETURN CODE
     C                   PARM                    I#ERMS           30            * ERROR MESSAGE

     C                   PARM                    I#ACTN            1            * ACTION CODE
     C                   PARM                    I#EXTT            4
     C                   PARM                    I#PH              1
     C                   PARM                    I#EOB             1
     C                   PARM                    I#RDNB            5 0          * RUN DATE
     C                   PARM                    I#DNWD            5 0          * DATE OF NXT W DAY
     C                   PARM                    I#HCOD            5 0
     C                   PARM                    I#EXTD            5 0
     C                   PARM                    I#EVCD            5 0
     C                   PARM                    I#PCOD            5 0
     C                   PARM                    PeriodEDT       300
     C                   PARM                    LEFEEX
     C                   PARM                    FACHISX
     C                   PARM                    Dataarea                                     208221
     C                   PARM                    I#RSRV           10                          CDE005
      *
      **  Access Bank Details
      *
     C                   MOVEL     Dataarea      DEEXTCTL                                     208221
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C                   IF        @RTCD <> *Blanks
     C                   MOVEL     '*ERROR'      I#RTCD
     C                   MOVEL     'AOBANKR0'    I#ERMS
     C                   MOVE      '1'           *INLR
     C                   RETURN
     C                   ENDIF
      *
      **  Access General Ledger details
      *
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
     C                   IF        @RTCD <> *Blanks
     C                   MOVEL     '*ERROR'      I#RTCD
     C                   MOVEL     'AOGELRR0'    I#ERMS
     C                   MOVE      '1'           *INLR
     C                   RETURN
     C                   ENDIF
      *
      * Acces currency details for base currency code
      *
     C                   MOVE      *BLANKS       @CYCD
     C                   MOVEL     BJCYCD        @CYCD
     C                   EXSR      ACSCCY
      *
     C                   IF        @RTCD = *BLANKS
     C                   EVAL      WBNBDP = A6NBDP
     C                   ELSE
     C                   MOVEL     '*ERROR'      I#RTCD
     C                   MOVEL     'AOCURRR0'    I#ERMS
     C                   MOVE      '1'           *INLR
     C                   RETURN
     C                   ENDIF
                                                                                              CLE031
      ** Access Switchable Features File                                                      CLE031
                                                                                              CLE031
     C                   CALLB     'AOSARDR0'                                                 CLE031
     C                   PARM      *Blanks       PRtcd             7                          CLE031
     C                   PARM      '*VERIFY '    POptn             7                          CLE031
     C                   PARM      'CLE031'      PSard             6                          CLE031
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE031
                                                                                              CLE031
     C                   MOVE      'N'           CLE031            1                          CLE031
     C                   IF        PRtcd = *Blanks                                            CLE031
     C                   EVAL      CLE031 = 'Y'                                               CLE031
     C                   ENDIF                                                                CLE031
     C     *LIKE         DEFINE    FE_FEPSTD     Work_Date                                    CLE031
      *                                                                                       208221
      **  Set up Type for DEWRKEDTA                                                           208221
      *                                                                                       208221
     C                   EVAL      W#TYPE = 'PFEES'                                           208221
      *
      ** Determine if Data Export - Reservation ID is active                                  CDE005
     C                   CALL      'AOSARDR0'                                                 CDE005
     C                   PARM      *BLANKS       @RTCD             7                          CDE005
     C                   PARM      '*VERIFY'     @OPTN             7                          CDE005
     C                   PARM      'CDE005'      @SARD             6                          CDE005
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDE005
      *                                                                                       CDE005
     C     @RTCD         IFEQ      *BLANK                                                     CDE005
     C                   MOVEL     'Y'           CDE005            1                          CDE005
     C                   ELSE                                                                 CDE005
     C                   MOVEL     'N'           CDE005                                       CDE005
     C                   ENDIF                                                                CDE005
      *                                                                                       CDE005
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * M A I N   P R O C E S S I N G
      /COPY DECPYSRC,DEXTMAINO
      *****************************************************************
      * C O M M I T M E N T   P R O C E S S I N G
      /COPY DECPYSRC,DEXTCOMMO
      *********************************************************************
      * I M P O R T   P E R I O D   E N D   D A T E S
      /COPY DECPYSRC,DEXTPERDI
      ********************************************************************
      * W O R K   W I T H   E X T R A C T   D A T A
      *****************************************************************
      /COPY DECPYSRC,DEXTWEDTA
      *********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY DECPYSRC,DEPSSR
      *********************************************************************
      /SPACE 5
**   POWER - ARRAY OF POWERS OF 10 FOR CURRENCY CONVERSIONS
0000001
0000010
0000100
0001000
0010000
0100000
1000000
**  CPY@
(c) Finastra International Limited 2001
