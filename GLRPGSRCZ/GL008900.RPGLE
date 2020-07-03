     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL Corrective Batch Additional Posting Gen')     *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL008900 - Midas GL Corrective Batch Additional Posting      *
      *             Generation                                        *
      *                                                               *
      *  Function:  This program generates additional postings in     *
      *             COB for corrective batch entries.                 *
      *                                                               *
      *  Called By: GLC008900 - Midas GL Corrective Batch Additional  *
      *                         Posting Generation                    *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. MD050216           Date 15Nov18               *
      *  Prev Amend No. MD032070           Date 20Mar15               *
      *                 MD046248           Date 27Oct17               *
      *                 CGL182             Date 11May17               *
      *                 AR1093704          Date 05Mar13               *
      *                 AR1054387          Date 09Nov12               *
      *                 AR1005162          Date 16Jul12               *
      *                 AR985003           Date 06Jun12               *
      *                 CSC054 *CREATE     Date 23Feb12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD050216 - I/E transfer not done for PEA system if Book date *
      *             = rundate. Perform SRFrgnCCY with this condition  *
      *  MD032070 - Missing postings when inserting backvalued journal*
      *             items. Use batch customer number instead of BICN  *
      *             for EOY position transfer in Base ccy.            *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL182 - Journal Entry via the Interface File - Java Version *
      *           (Recompile)                                         *
      *  AR1093704 - Error in trailer computation                     *
      *  AR1054387 - Postings done were made with contrary sign       *
      *  AR1005162 - Base ccy exchange rate in corrective batch has   *
      *              incorrect number of decimal places (Recompile)   *
      *  AR985003 - Previous accrual date should be used instead of   *
      *             accrual date                                      *
      *  CSC054 - Period End Adjustments                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    20      Foreign currency, 0 decimal places                 *
      *    21      Foreign currency, 1 decimal place                  *
      *    22      Foreign currency, 2 decimal places                 *
      *    23      Foreign currency, 3 decimal places                 *
      *    51      Account codes array lookup                         *
      *    52      Compare number of decimal places                   *
      *    53      Check negative posting amount                      *
      *    54      Check negative posting amount                      *
      *    70      Journal entry postings join LF - EOF               *
      *    71      Manual postings trailer file - EOF                 *
      *    72      Account codes file - EOF                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRFrgnCCY - Transfer Foreign Currency Income and Expense      *
      *             to Base Currency                                  *
      * SRBaseCCY - Transfer of Base Currency Income and Expense      *
      *             to Retained Earnings                              *
      * SRBrchDet - Access branch details                             *
      * SRCurr    - Access currency details                           *
      * SRAcod    - Access account codes details                      *
      * *PSSR     - Error processing                                  *
      * *INZSR    - Initialise                                        *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
 
      ** Midas GL Journal Entry Joint File
     FGLJENPJ0  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas GL Corrective Batch Register File
     FSDACODL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas GL Corrective Batch Register File
     FMANPOPD   O    E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      ** Midas GL Manual Postings Trailer File
     FMANPOZZ   UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
      ** Data Area giving Installation Control Details
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Account codes and narrative array
     D ACS             S              2    DIM(9999)
     D ACD             S             10    DIM(9999)
     D PNARR           S             30    DIM(7) CTDATA PERRCD(1)
 
      ** Narrative 2 data structure
     D PNAR2           DS            30
     D PNTR                    1      8
     D SP                      9      9
     D BTCUST                 10     15
     D BTCYCD                 16     18
     D BTACCD                 19     28
     D BTACSN                 29     30
 
      ** Amount conversion fields
     D                 DS
     D AMT0                    1     15  0
     D AMT1                    1     15  1
     D AMT2                    1     15  2
     D AMT3                    1     15  3
     D                 DS
     D BASAM0                  1     15  0
     D BASAM1                  1     15  1
     D BASAM2                  1     15  2
     D BASAM3                  1     15  3
 
      ** Bank Details Data Structure
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** General Ledger Details Data Structure
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D QQACC1        E                     EXTFLD(QQACCD)
 
      ** Currency Codes Data Structure
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** Branch Codes Data Structure
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
      ** Trading Details Data Structure
     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
     D QQACC2        E                     EXTFLD(QQACCD)
 
      ** Account Codes Data Structure
     D SDACOD        E DS                  EXTNAME(SDACODPD)
     D QQACC3        E                     EXTFLD(QQACCD)
 
      ** Short Access Object Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long Access Object Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Access program fields
     D PRtCd           S              7A
     D POptn           S              7A
     D PCcy            S              3A
     D PBrca           S              3A
     D PAfnb           S             10A
 
      ** Hash totalling fields
     D ZZAMT           S             15  3
     D ZZAMTI          S             15  0
     D ZZTOTI          S             15  0
     D ZZAMTD          S              3  0
     D ZZTOTD          S              3  0
     D RECCNT          S              6  0
     D SUBTOT          S             15  0
 
      ** Other work fields
     D WRun            S              1A
     D BSDSC           S              2A
     D BSDTY           S              1A
     D TRDSC           S              2A
     D TRDTY           S              1A
     D SRDSC           S              2A
     D SRDTY           S              1A
     D PLSC            S              2A
     D PLTY            S              1A
     D TACC            S             10  0
     D BSTACC          S             10  0
     D BASDP           S              1  0
 
      ** ZFREQC parameters                                                                  AR985003
     D PRetCodeIn      S             10A                                                    AR985003
     D PNxtColDay      S              4A                                                    AR985003
     D PIncldTday      S              1A                                                    AR985003
     D PzFreq          S              1A                                                    AR985003
     D PzDayNo         S              5  0                                                  AR985003
     D PzWDay          S              3A                                                    AR985003
     D PzMDay          S              2  0                                                  AR985003
     D PBaseDate       S              5  0                                                  AR985003
                                                                                            AR985003
     D PEASystem       C                   Const('PEASystemPrefix')                         MD050216
     D CurSystem       C                   Const('BrgMidasSystemPrefix')                    MD050216
                                                                                            MD050216
     D WPEA            S              2A                                                    MD050216
     D WSYS            S              2A                                                    MD050216
     D PSysVal01       S             20A                                                    MD050216
     D PCurSet01       S            200A                                                    MD050216
     D PSysVal02       S             20A                                                    MD050216
     D PCurSet02       S            200A                                                    MD050216
     D PSysVal03       S             20A                                                    MD050216
     D PCurSet03       S            200A                                                    MD050216
     D PSysVal04       S             20A                                                    MD050216
     D PCurSet04       S            200A                                                    MD050216
     D PSysVal05       S             20A                                                    MD050216
     D PCurSet05       S            200A                                                    MD050216
     D PSysVal06       S             20A                                                    MD050216
     D PCurSet06       S            200A                                                    MD050216
     D PSysVal07       S             20A                                                    MD050216
     D PCurSet07       S            200A                                                    MD050216
     D PSysVal08       S             20A                                                    MD050216
     D PCurSet08       S            200A                                                    MD050216
     D PSysVal09       S             20A                                                    MD050216
     D PCurSet09       S            200A                                                    MD050216
     D PSysVal10       S             20A                                                    MD050216
     D PCurSet10       S            200A                                                    MD050216
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
     C                   CALL      'AOSVALR0'                                               MD050216
     C                   PARM      *BLANKS       PRtCd                                      MD050216
     C                   PARM      PEASystem     PSysVal01                                  MD050216
     C                   PARM                    PCurSet01                                  MD050216
     C                   PARM      CurSystem     PSysVal02                                  MD050216
     C                   PARM                    PCurSet02                                  MD050216
     C                   PARM                    PSysVal03                                  MD050216
     C                   PARM                    PCurSet03                                  MD050216
     C                   PARM                    PSysVal04                                  MD050216
     C                   PARM                    PCurSet04                                  MD050216
     C                   PARM                    PSysVal05                                  MD050216
     C                   PARM                    PCurSet05                                  MD050216
     C                   PARM                    PSysVal06                                  MD050216
     C                   PARM                    PCurSet06                                  MD050216
     C                   PARM                    PSysVal07                                  MD050216
     C                   PARM                    PCurSet07                                  MD050216
     C                   PARM                    PSysVal08                                  MD050216
     C                   PARM                    PCurSet08                                  MD050216
     C                   PARM                    PSysVal09                                  MD050216
     C                   PARM                    PCurSet09                                  MD050216
     C                   PARM                    PSysVal10                                  MD050216
     C                   PARM                    PCurSet10                                  MD050216
                                                                                            MD050216
     C                   IF        PrtCd   = *BLANKS                                        MD050216
     C                             AND PCurSet01 <> *BLANKS                                 MD050216
     C                   EVAL      WPEA    = PCurSet01                                      MD050216
     C                   EVAL      WSYS    = PCurSet02                                      MD050216
     C                   ELSE                                                               MD050216
     C                   EXSR      *PSSR                                                    MD050216
     C                   ENDIF                                                              MD050216
                                                                                            MD050216
      ** Process all corrective batch entries for additional posting
 
     C     *LOVAL        SETLL     GLJENPJ0
     C                   READ      GLJENPJ0                               70
     C     *IN70         DOWEQ     '0'
 
     C                   Z-ADD     1             X
     C     BTACCD        LOOKUP    ACD(X)                                 51
     C                   IF        *IN51 = '1'
     C                   EXSR      SRBrchDet
 
      ** For each corrective batch that post to foreign ccy income or
      ** expense & booking date is the previous accrual date or earlier
 
     C                   IF        BTCYCD <> BJCYCD
 
     C**********         IF        HQBDTE < BKAPDT AND                                      AR985003
     C                   IF        HQBDTE <= PzDayNo AND                                    AR985003
     C**********                   BTPTAM <> *ZERO                                          MD050216
     C                             BTPTAM <> *ZERO OR                                       MD050216
     C                             WPEA = WSYS   AND                                        MD050216
     C                             HQBDTE <= BJRDNB                                         MD050216
     C                   EXSR      SRFrgnCCY
     C                   ENDIF
     C                   IF        HQBDTE <= BJPEYD AND
     C                             BTPTAM <> *ZERO
     C                   EXSR      SRBaseCCY
     C                   ENDIF
 
     C                   ELSE
 
      ** For each corrective batch that posts to a base ccy income or
      ** expense & booking date is the previous end of year or earlier
 
     C                   IF        HQBDTE <= BJPEYD AND
     C                             BTPTAM <> *ZERO
     C                   EXSR      SRBaseCCY
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C                   READ      GLJENPJ0                               70
     C                   ENDDO
 
     C                   EXSR      SRControl
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFrgnCCY - Transfer Foreign Currency Income and Expense     *
      *              to Base Currency                                 *
      *                                                               *
      *****************************************************************
     C     SRFrgnCCY     BEGSR
 
      ** 1st Posting: Income or Expense a/c in foreign ccy
 
     C                   Z-ADD     HQBDTE        VALD
     C                   Z-ADD     BJRDNB        PSTD
 
     C                   EVAL      BRCA = A8BRCD
     C                   EVAL      CNUM = BTCUST
     C                   EVAL      CCY  = BTCYCD
     C                   MOVE      BTACCD        ACOD
     C                   MOVE      BTACSN        ACSQ
     C                   EVAL      ATYP = BTACTY
     C                   EVAL      ACSC = ACS(X)
     C                   EVAL      PNAR = PNARR(1)
 
     C                   Z-ADD     BTPTAM        PSTA                   53
     C                   IF        *IN53  = '1'
     C                   Z-SUB     BTPTAM        PSTA
     C                   ENDIF
 
     C                   IF        BTDCIN = 'C'
     C                   MOVE      '0'           DRCR
     C                   ELSE
     C                   MOVE      '1'           DRCR
     C                   ENDIF
 
     C                   IF        ATYP = 'R'
     C                   Z-ADD     1             RIND
     C                   ELSE
     C                   Z-ADD     0             RIND
     C                   ENDIF
 
     C                   WRITE     APOSTPDF
 
      ** 2nd Posting: Position a/c in foreign ccy
 
     C                   EVAL      CNUM = A8BICN
     C                   EVAL      ATYP = TRDTY
     C                   EVAL      ACSC = TRDSC
     C                   MOVE      BLSPTA        ACOD
     C                   Z-ADD     1             ACSQ
 
     C                   IF        BTDCIN = 'C'
     C                   MOVE      '1'           DRCR
     C                   ELSE
     C                   MOVE      '0'           DRCR
     C                   ENDIF
 
     C                   IF        ATYP = 'R'
     C                   Z-ADD     1             RIND
     C                   ELSE
     C                   Z-ADD     0             RIND
     C                   ENDIF
 
     C                   WRITE     APOSTPDF
 
      ** Convert foreign currency amount to base currency
 
     C                   Z-ADD     0             PSTA
     C                   EXSR      SRConvert
 
     C                   IF        BASAM0 <> *ZERO
 
      ** Get trade type and sequence of spot trading account equiv.
 
     C                   MOVEL     A6SPAE        TACC
     C                   MOVE      *BLANKS       PAfnb
     C                   MOVE      TACC          PAfnb
     C                   EXSR      SRAcod
     C                   EVAL      SRDTY = A5ACTY
     C                   EVAL      SRDSC = A5ACSC
 
      ** 3rd Posting: Income or Expense a/c in base ccy
 
     C                   EVAL      CCY  = BJCYCD
     C                   MOVE      TACC          ACOD
     C                   EVAL      ATYP = SRDTY
     C                   EVAL      ACSC = SRDSC
 
     C                   IF        BTDCIN = 'C'
     C                   MOVE      '0'           DRCR
     C                   ELSE
     C                   MOVE      '1'           DRCR
     C                   ENDIF
 
     C                   IF        ATYP = 'R'
     C                   Z-ADD     1             RIND
     C                   ELSE
     C                   Z-ADD     0             RIND
     C                   ENDIF
 
     C                   WRITE     APOSTPDF
 
      ** 4th Posting: Equivalent a/c in base ccy
 
     C                   IF        BKFCRC = 'B' OR
     C                             BKFCRC = 'C'
     C                   EVAL      CNUM = BTCUST
     C                   ENDIF
 
     C                   IF        BKFCRC = 'B' OR
     C                             BKFCRC = 'S'
     C                   MOVE      BTACSN        ACSQ
     C                   ENDIF
 
     C                   MOVE      BTACCD        ACOD
     C                   EVAL      ATYP = BTACTY
     C                   EVAL      ACSC = ACS(X)
     C                   EVAL      PNAR = PNAR2
 
     C                   IF        BTDCIN = 'C'
     C                   MOVE      '1'           DRCR
     C                   ELSE
     C                   MOVE      '0'           DRCR
     C                   ENDIF
 
     C                   IF        ATYP = 'R'
     C                   Z-ADD     1             RIND
     C                   ELSE
     C                   Z-ADD     0             RIND
     C                   ENDIF
 
     C                   WRITE     APOSTPDF
 
      ** Additional postings when base currency trade and trade equivalent
      ** accounts are used by installation
 
     C                   IF        BSTACC <> *ZERO
     C                   EVAL      CNUM = A8BICN
     C                   EVAL      ATYP = TRDTY
     C                   EVAL      ACSC = TRDSC
     C                   MOVE      BLSPTA        ACOD
     C                   Z-ADD     1             ACSQ
     C                   EVAL      PNAR = PNARR(1)
 
     C**********         IF        BTDCIN = 'C'                                            AR1054387
     C                   IF        BTDCIN = 'D'                                            AR1054387
     C                   MOVE      '1'           DRCR
     C                   ELSE
     C                   MOVE      '0'           DRCR
     C                   ENDIF
     C                   IF        ATYP = 'R'
     C                   Z-ADD     1             RIND
     C                   ELSE
     C                   Z-ADD     0             RIND
     C                   ENDIF
 
     C                   WRITE     APOSTPDF
 
     C                   EVAL      ATYP = BSDTY
     C                   EVAL      ACSC = BSDSC
     C                   Z-ADD     BSTACC        ACOD
 
     C**********         IF        BTDCIN = 'C'                                            AR1054387
     C                   IF        BTDCIN = 'D'                                            AR1054387
     C                   MOVE      '0'           DRCR
     C                   ELSE
     C                   MOVE      '1'           DRCR
     C                   ENDIF
     C                   IF        ATYP = 'R'
     C                   Z-ADD     1             RIND
     C                   ELSE
     C                   Z-ADD     0             RIND
     C                   ENDIF
 
     C                   WRITE     APOSTPDF
 
     C                   ENDIF
     C                   ENDIF
 
      ** Maintain hash totals
 
     C                   Z-ADD     0             SUBTOT
     C                   ADD       2             RECCNT
     C     BTPTAM        MULT      2             SUBTOT
     C                   IF        BASAM0 <> *ZERO
     C                   DO        2
     C                   ADD       BASAM0        SUBTOT
     C                   ENDDO
     C                   ADD       2             RECCNT
     C                   IF        BSTACC <> *ZERO
     C                   DO        2
     C                   ADD       BASAM0        SUBTOT
     C                   ENDDO
     C                   ADD       2             RECCNT
     C                   ENDIF
     C                   ENDIF
 
     C     SUBTOT        DIV       1000          ZZAMT
     C                   IF        ZZAMT < *ZERO
     C                   Z-SUB     ZZAMT         ZZAMT
     C                   ENDIF
 
     C                   Z-ADD     ZZAMT         ZZAMTI
     C                   MOVE      ZZAMT         ZZAMTD
     C                   ADD       ZZAMTD        ZZTOTD
 
     C                   IF        ZZTOTD < ZZAMTD
     C                   ADD       1             ZZAMTI
     C                   ENDIF
     C                   ADD       ZZAMTI        ZZTOTI
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBaseCCY - Transfer of Base Currency Income and Expense     *
      *              to Retained Earnings                             *
      *                                                               *
      *****************************************************************
     C     SRBaseCCY     BEGSR
 
     C                   IF        BASAM0 <> *ZERO OR
     C                             BTCYCD = BJCYCD
 
      ** 1st Posting: Income or Expense a/c in base ccy
 
     C                   IF        BTCYCD = BJCYCD
     C                   EVAL      CCY  = BTCYCD
 
     C                   Z-ADD     BTPTAM        PSTA                   53
     C                   IF        *IN53  = '1'
     C                   Z-SUB     BTPTAM        PSTA
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      CCY  = BJCYCD
     C                   ENDIF
 
     C                   MOVE      BTACCD        ACOD
     C                   MOVE      BTACSN        ACSQ
     C**********         EVAL      CNUM = A8BICN                                            MD032070
     C                   EVAL      CNUM = BTCUST                                            MD032070
     C                   EVAL      ATYP = BTACTY
     C                   EVAL      ACSC = ACS(X)
     C                   EVAL      PNAR = PNARR(3)
 
     C                   Z-ADD     BJRDNB        PSTD
     C                   Z-ADD     HQBDTE        VALD
 
     C                   IF        BTDCIN = 'C'
     C                   MOVE      '0'           DRCR
     C                   ELSE
     C                   MOVE      '1'           DRCR
     C                   ENDIF
 
     C                   IF        ATYP = 'R'
     C                   Z-ADD     1             RIND
     C                   ELSE
     C                   Z-ADD     0             RIND
     C                   ENDIF
 
     C                   WRITE     APOSTPDF
 
      ** 2nd Posting: Retained earning a/c in base ccy
 
     C                   EVAL      CNUM = A8BICN
     C                   MOVE      BKPLAC        ACOD
     C                   Z-ADD     1             ACSQ
     C                   EVAL      ATYP = PLTY
     C                   EVAL      ACSC = PLSC
     C                   EVAL      PNAR = PNAR2
 
     C                   IF        BTDCIN = 'C'
     C                   MOVE      '1'           DRCR
     C                   ELSE
     C                   MOVE      '0'           DRCR
     C                   ENDIF
 
     C                   IF        ATYP = 'R'
     C                   Z-ADD     1             RIND
     C                   ELSE
     C                   Z-ADD     0             RIND
     C                   ENDIF
 
     C                   WRITE     APOSTPDF
     C                   ENDIF
 
      ** Maintain hash totals
 
     C                   Z-ADD     0             SUBTOT
     C                   IF        BTCYCD = BJCYCD
     C                   ADD       2             RECCNT
     C     BTPTAM        MULT      2             SUBTOT
     C                   ELSE
     C                   IF        BASAM0 <> *ZERO
     C                   ADD       2             RECCNT
     C                   DO        2
     C                   ADD       BASAM0        SUBTOT
     C                   ENDDO
     C                   ENDIF
     C                   ENDIF
 
     C     SUBTOT        DIV       1000          ZZAMT
     C                   IF        ZZAMT < *ZERO
     C                   Z-SUB     ZZAMT         ZZAMT
     C                   ENDIF
 
     C                   Z-ADD     ZZAMT         ZZAMTI
     C                   MOVE      ZZAMT         ZZAMTD
     C                   ADD       ZZAMTD        ZZTOTD
 
     C                   IF        ZZTOTD < ZZAMTD
     C                   ADD       1             ZZAMTI
     C                   ENDIF
     C                   ADD       ZZAMTI        ZZTOTI
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRConvert - Convert foreign currency posting amount          *
      *              to base currency                                 *
      *                                                               *
      *****************************************************************
     C     SRConvert     BEGSR
 
      ** Identify no. of decimal places from batch item currency
 
     C                   MOVE      BTCYCD        PCcy
     C                   EXSR      SRCurr
 
     C     A6NBDP        COMP      1                                  522021
     C                   IF        *IN52 = '1'
     C     A6NBDP        COMP      2                                  23  22
     C                   ENDIF
 
      ** Set amount work field and convert using base rate of batch
 
     C                   Z-ADD     0             BASAM0
     C                   Z-ADD     0             BASAM1
     C                   Z-ADD     0             BASAM2
     C                   Z-ADD     0             BASAM3
     C                   Z-ADD     BTPTAM        AMT0
 
     C                   SELECT
     C                   WHEN      IQBCIN = 'M'
     C                   IF        BASDP = 0
     C   20AMT0          MULT(H)   IQBCRT        BASAM0
     C   21AMT1          MULT(H)   IQBCRT        BASAM0
     C   22AMT2          MULT(H)   IQBCRT        BASAM0
     C   23AMT3          MULT(H)   IQBCRT        BASAM0
     C                   ELSEIF    BASDP = 1
     C   20AMT0          MULT(H)   IQBCRT        BASAM1
     C   21AMT1          MULT(H)   IQBCRT        BASAM1
     C   22AMT2          MULT(H)   IQBCRT        BASAM1
     C   23AMT3          MULT(H)   IQBCRT        BASAM1
     C                   ELSEIF    BASDP = 2
     C   20AMT0          MULT(H)   IQBCRT        BASAM2
     C   21AMT1          MULT(H)   IQBCRT        BASAM2
     C   22AMT2          MULT(H)   IQBCRT        BASAM2
     C   23AMT3          MULT(H)   IQBCRT        BASAM2
     C                   ELSE
     C   20AMT0          MULT(H)   IQBCRT        BASAM3
     C   21AMT1          MULT(H)   IQBCRT        BASAM3
     C   22AMT2          MULT(H)   IQBCRT        BASAM3
     C   23AMT3          MULT(H)   IQBCRT        BASAM3
     C                   ENDIF
     C                   WHEN      IQBCIN = 'D'
     C                   IF        BASDP = 0
     C   20AMT0          DIV(H)    IQBCRT        BASAM0
     C   21AMT1          DIV(H)    IQBCRT        BASAM0
     C   22AMT2          DIV(H)    IQBCRT        BASAM0
     C   23AMT3          DIV(H)    IQBCRT        BASAM0
     C                   ELSEIF    BASDP = 1
     C   20AMT0          DIV(H)    IQBCRT        BASAM1
     C   21AMT1          DIV(H)    IQBCRT        BASAM1
     C   22AMT2          DIV(H)    IQBCRT        BASAM1
     C   23AMT3          DIV(H)    IQBCRT        BASAM1
     C                   ELSEIF    BASDP = 2
     C   20AMT0          DIV(H)    IQBCRT        BASAM2
     C   21AMT1          DIV(H)    IQBCRT        BASAM2
     C   22AMT2          DIV(H)    IQBCRT        BASAM2
     C   23AMT3          DIV(H)    IQBCRT        BASAM2
     C                   ELSE
     C   20AMT0          DIV(H)    IQBCRT        BASAM3
     C   21AMT1          DIV(H)    IQBCRT        BASAM3
     C   22AMT2          DIV(H)    IQBCRT        BASAM3
     C   23AMT3          DIV(H)    IQBCRT        BASAM3
     C                   ENDIF
     C                   ENDSL
 
      ** Set posting amount field
 
     C                   Z-ADD     BASAM0        PSTA                   54
 
     C                   IF        *IN54 = '1'
     C                   Z-SUB     BASAM0        PSTA
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRControl - Termination/file control routine                 *
      *                                                               *
      *****************************************************************
     C     SRControl     BEGSR
 
      ** Update trailer record
 
     C                   READ      MANPOZZ                                71
     C                   ADD       RECCNT        NORE1
     C                   ADD       ZZTOTI        HRWN
     C                   ADD       ZZTOTD        HRDC
     C                   IF        HRDC < ZZTOTD                                           AR1093704
     C                   ADD       1             HRWN                                      AR1093704
     C                   ENDIF                                                             AR1093704
     C                   UPDATE    APOSTZZF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBrchDet - Access branch details                            *
      *                                                               *
      *****************************************************************
     C     SRBrchDet     BEGSR
 
     C                   CALL      'AOBRCHR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      BTIBCA        PBrca
     C     SDBRCH        PARM      SDBRCH        DSSDY
 
     C                   IF        PRtCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDBRCHPD'
     C                   EVAL      DBKey =  POptn
     C                   EVAL      DBase =  004
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   MOVE      A8BRCD        BRCA
     C                   MOVE      'P'           RECI
     C                   MOVE      *BLANKS       GETP
     C                   MOVE      BTPRCN        PRFC
     C                   MOVEL     BTBTNB        SPOS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCurr - Access currency details                             *
      *                                                               *
      *****************************************************************
     C     SRCurr        BEGSR
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PCcy
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRtCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDCURRPD'
     C                   EVAL      DBKey =  POptn
     C                   EVAL      DBase =  005
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAcod - Access account codes details                        *
      *                                                               *
      *****************************************************************
     C     SRAcod        BEGSR
 
     C                   CALL      'AOACODR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PAfnb
     C     SDACOD        PARM      SDACOD        DSSDY
 
     C                   IF        PRtCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDACODPD'
     C                   EVAL      DBKey =  POptn
     C                   EVAL      DBase =  006
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program initialisation subroutine                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *DTAARA       DEFINE                  LDA
     C                   Z-ADD     0             RECCNT
     C                   Z-ADD     0             ZZAMT
     C                   Z-ADD     0             ZZAMTI
     C                   Z-ADD     0             ZZTOTI
     C                   Z-ADD     0             ZZAMTD
     C                   Z-ADD     0             ZZTOTD
     C                   Z-ADD     0             SUBTOT
     C                   Z-ADD     0             AMT0
     C                   Z-ADD     0             AMT1
     C                   Z-ADD     0             AMT2
     C                   Z-ADD     0             AMT3
     C                   Z-ADD     0             BASAM0
     C                   Z-ADD     0             BASAM1
     C                   Z-ADD     0             BASAM2
     C                   Z-ADD     0             BASAM3
     C                   Z-ADD     0             X
     C                   Z-ADD     0             VOIN
     C                   Z-ADD     235959        PTIM
     C                   MOVEL     PNARR(2)      PNTR
     C                   MOVEL     'GL008900'    DBPGM
     C                   MOVE      *BLANKS       DBKey
     C                   MOVE      *BLANKS       DBase
     C                   MOVE      *BLANKS       DBFile
     C                   MOVE      *BLANKS       SP
 
      ** Access bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRtCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBase = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access general ledger details
 
     C                   CALL      'AOGELRR1'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDGELR        PARM      SDGELR        DSSDY
 
     C                   IF        PRtCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDGELRPD'
     C                   EVAL      DBKey =  POptn
     C                   EVAL      DBase =  002
     C                   OUT       LDA
     C                   EXSR      *PSSR
                                                                                            AR985003
     C                   ELSE                                                               AR985003
                                                                                            AR985003
      ** Get previous accrual date                                                          AR985003
                                                                                            AR985003
     C                   IF        BKAPFQ = 'D'                                             AR985003
     C                   Z-ADD     BJRDNB        PzDayNo                                    AR985003
     C                   ELSE                                                               AR985003
     C                   Z-ADD     BKAPDT        PzDayNo                                    AR985003
     C                   ENDIF                                                              AR985003
                                                                                            AR985003
     C                   CALL      'ZFREQC'                                                 AR985003
     C                   PARM      *BLANKS       PRetCodeIn                                 AR985003
     C                   PARM      'PREV'        PNxtColDay                                 AR985003
     C                   PARM      *BLANKS       PIncldTday                                 AR985003
     C                   PARM      BKAPFQ        PzFreq                                     AR985003
     C                   PARM                    PzDayNo                                    AR985003
     C                   PARM                    BJLCCY                                     AR985003
     C                   PARM      *BLANKS       PzWDay                                     AR985003
     C                   PARM      BKAPFD        PzMDay                                     AR985003
     C                   PARM                    BJDFIN                                     AR985003
     C                   PARM                    PBaseDate                                  AR985003
                                                                                            AR985003
     C                   IF        PRetCodeIn <> *BLANKS                                    AR985003
     C     *LOCK         IN        LDA                                                      AR985003
     C                   EVAL      DBFile = 'ZFREQC  '                                      AR985003
     C                   EVAL      DBKey =  '*CALL'                                         AR985003
     C                   EVAL      DBase =  007                                             AR985003
     C                   OUT       LDA                                                      AR985003
     C                   EXSR      *PSSR                                                    AR985003
     C                   ENDIF                                                              AR985003
     C                   ENDIF
 
      ** Access trading details
 
     C                   CALL      'AOTRADR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDTRAD        PARM      SDTRAD        DSFDY
 
     C                   IF        PRtCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDTRADPD'
     C                   EVAL      DBKey =  POptn
     C                   EVAL      DBase =  003
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Build Income and Expense account codes
 
     C     *LOVAL        SETLL     SDACODL0
     C                   READ      SDACODL0                               72
     C     *IN72         DOWEQ     '0'
     C                   IF        A5TOIN = 'N' AND
     C                             (A5ACSC = 'IN' OR A5ACSC = 'EX')
     C                   ADD       1             X                 4 0
     C                   MOVE      A5ACCD        ACD(X)
     C                   MOVE      A5ACSC        ACS(X)
     C                   ENDIF
     C                   READ      SDACODL0                               72
     C                   ENDDO
 
      ** Get base currency no. of decimal places
 
     C                   MOVE      BJCYCD        PCcy
     C                   EXSR      SRCurr
     C                   Z-ADD     A6NBDP        BASDP
     C                   MOVEL     A6SPAE        BSTACC
 
      ** Get trade type and sequence of base currency trading account
      ** code equivalent
 
     C                   MOVE      *BLANKS       PAfnb
     C                   MOVE      BSTACC        PAfnb
     C                   EXSR      SRAcod
     C                   EVAL      BSDTY = A5ACTY
     C                   EVAL      BSDSC = A5ACSC
 
      ** Get trade type and sequence of spot trading account code
 
     C                   MOVE      *BLANKS       PAfnb
     C                   MOVE      BLSPTA        PAfnb
     C                   EXSR      SRAcod
     C                   EVAL      TRDTY = A5ACTY
     C                   EVAL      TRDSC = A5ACSC
 
      ** Get trade type and sequence of Profit and Loss account code
 
     C                   MOVE      *BLANKS       PAfnb
     C                   MOVE      BKPLAC        PAfnb
     C                   EXSR      SRAcod
     C                   EVAL      PLTY  = A5ACTY
     C                   EVAL      PLSC  = A5ACSC
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
** PNARR
TRANSFER F/C INCOME+EXPENSE
TRANS FROM
TRANSFER TO PROFIT+LOSS
