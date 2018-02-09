     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Transactions update phase II')
      *****************************************************************
      *                                                               *
      *  Midas - Futures and Options Module                           *
      *                                                               *
      *  FF000391 - Transactions Update Phase II                      *
      *                                                               *
      *  Function:  This program updates charges and commissions.     *
      *  (COB)                                                        *
      *                                                               *
      *  Component of: FFC1009 - Transaction Update Phase 2 (EOC)     *
      *                FFC0790 - Transaction Update Phase 2 (COB)     *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. 223424             Date 26May06               *
      *                 222971             Date 26May06               *
      *                 219682             Date 26May06               *
      *                 CSD027             Date 09Dec05               *
      *                 CGL020             Date 12Dec02               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 201061             Date 26Aug02               *
      *                 208523             Date 22Aug02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 206860             Date 24Jun02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CFF007  *CREATE    Date 13Feb01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  223424 - Generate reversal of premium when deal is reversed. *
      *  222971 - Amended program in such a way that any deletion of  *
      *           Trade done within the day will produce a reversal of*
      *           a/c key premium.                                    *
      *         - Value date premium a/c key is not produced for a    *
      *           reversed trade.  Make sure that reversal of         *
      *           premium a/c key is generated when a trade is        *
      *           reversed.                                           *
      *         - Generate Value Date premium a/c key on its input    *
      *           date regardless if the rundate is ahead of the      *
      *           Market Business Date, when the Auto EOC indicator in*
      *           MARKTD file is defined as 'A' (i.e. After COB).     *
      *  219682 - Check if premium entries already generated.         *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL020 - Midas Compliance Watch - Additional A/c Postings    *
      *           Information                                         *
      *  201061 - No settlement branch passed for premium account     *
      *           keys in this program, thus posting is posted in     *
      *           the suspense.                                       *
      *  208523 - Update FOKEYD account key field.                    *
      *  206860 - FOKEYA is not updated properly (FOOB in FFC0910)    *
      *  CFF007 - Futures and Options Enhancement for Private Banking *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         READ indicator for primary file                 *
      *    50         General purpose file access indicator           *
      *                                                               *
      *    U7+U8      Database Errors                                 *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRMain     - Controlling subroutine for type of transaction. *
      *  SRTotal    - Process audit record/report.                    *
      *  SROptnAcKey- Generate option account keys/position change rec*
      *  SROptnAcPRS- Generate account keys for premium at start.     *
      *               (Trade Input)                                   *
      *  SR00001    - Defines position 2 and 6-10 of the account key. *
      *  SRFFFmt    - Accepts market centre name and business date,   *
      *               and outputs a field with these fields formatted *
      *               with the text 'as at' with no embedded blanks.  *
      * *PSSR - Error processing.                                     *
      * *INZSR - Initialization.                                      *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FTRANS14   UF   E           K DISK    INFSR(*PSSR)
 
     FINTYP     IF   E           K DISK    INFSR(*PSSR)
                                                                                              219682
     FPRMPL0    UF A E           K DISK    INFSR(*PSSR)                                       219682
 
     FPRICS     IF   E           K DISK    INFSR(*PSSR)
 
     FMKCTL     IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
 
     FMARKT     IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
 
     FTRSET     UF   E           K DISK    INFSR(*PSSR)
 
     FFOKEYA    UF   E             DISK    INFSR(*PSSR)
 
     FFOKEYD    O    E             DISK    INFSR(*PSSR)
 
     FFF000391AUO    E             PRINTER
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     D LDA           E DS           256    EXTNAME(LDA) DTAARA
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D WTbMsg          S             20    DIM(1) CTDATA PERRCD(1)
 
      ** Array for underlining
     D WArFULA         S              1    DIM(34)
 
      ** SRFFFMT - Format name and date field for output to report
     D                 DS
     D  WFFTxt                 1     34
     D  WArFFT                 1     34    DIM(34)
 
     D WDsFFKY         DS
      ** Account key subfields
     D  TYPE                   1      1
     D  INVA                   2      2
     D  ETYP                   3      3
     D  BOOK                   4      5
     D  MKINST                 6     10
     D  LORS                  11     11
     D  PRTY                  12     12
     D  POS13                 13     13
     D  AMTC                  14     14
 
      ** SAR Details                                                                          CGL020
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CGL020
                                                                                              CGL020
      ** First data structure for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** External data structure for bank ICD details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External data structure for Futures and Options ICD details
     D SDFODA        E DS                  EXTNAME(SDFODAPD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** *Entry parameters
     D P0Mkt           S              2A
 
      ** Parameter fields of access objects
     D PRtnCde07A      S              7A
     D POption07A      S              7A
 
      ** Parameter fileds of MIDAS Z* programs
     D PZDayNo050P     S              5P 0
     D PZDayFwd020P    S              2P 0
     D PZDayNoOut050P  S              5P 0
     D PZCcy003A       S              3A
     D PZLoc003A       S              3A
     D PZDteFmt001A    S              1A
     D PZDte060P       S              6P 0
     D PZDte007A       S              7A
     D PZAmt153P       S             15P 3
     D PZInt150P       S             15P 0
     D PZDec030P       S              3P 0
 
      ** General-purpose fields
     D WRun            S              1A
     D WChr001         S              1A
 
     ** Work variables and parameters used in CGL020                                          CGL020
     D CGL020          S              1A                                                      CGL020
     D PSARD           S              6A                                                      CGL020
     D SEBA            S              3A                                                      CGL020
     D SEFA            S             10A                                                      CGL020
     D SECP            S              8A                                                      CGL020
                                                                                              CGL020
      ** Parameters for ZAAMLSETFF                                                            CGL020
     D*PCBCD****       S              6S 0                                             CGL020 CSD027
     D PCBCD           S              6                                                       CSD027
                                                                                              CGL020
      *****************************************************************
      /EJECT
      *****************************************************************
 
     ITRANSDF
      ** Level break on Instrument for TRANS11 file
     I              RECI                        TRECI
     I              VALD                        TVDAT
     I              ORED                        TORED
     I              LCD                         TVLCD
 
     ITRSETDF
      ** Rename fields on TRSET
     I              RECI                        FRECI
 
     IINTYPDF
     I              CNTT                        FFCNTT
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: *INZSR is   ¦
      ** ¦ executed at program activation.                            ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
     C                   MOVE      *BLANKS       WSvISTT
     C                   Z-ADD     0             WSvYRNO
     C                   Z-ADD     0             WSvMTHN
     C                   MOVE      *BLANKS       WSvPCAL
     C                   Z-ADD     0             WSvSTRP
     C                   Z-ADD     0             PZInt150P                                    206860
     C                   Z-ADD     0             PZDec030P                                    206860
 
      ** Read TRANS14
     C                   READ      TRANS14                                01
 
      ** Do while not EOF
     C     *IN01         DOWEQ     '0'
 
     C     WSvISTT       IFNE      ISTT
     C     WSvYRNO       ORNE      YRNO
     C     WSvMTHN       ORNE      MTHN
     C     WSvPCAL       ORNE      PCAL
     C     WSvSTRP       ORNE      STRP
 
     C                   MOVE      ISTT          WSvISTT
     C                   Z-ADD     YRNO          WSvYRNO
     C                   Z-ADD     MTHN          WSvMTHN
     C                   MOVE      PCAL          WSvPCAL
     C                   Z-ADD     STRP          WSvSTRP
 
      ** Access INTYP for instrument type details if changed
     C     ISTT          CHAIN     INTYP                              50
     C     *IN50         IFEQ      *ON
     C     RECI          ORNE      'D'
     C                   Z-ADD     3             DBASE
     C                   MOVEL     'INTYP'       DBFILE
     C                   MOVEL     ISTT          DBKEY
     C                   WRITE     HeadAU
     C                   WRITE     DBERRAU
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   ENDIF
 
      ** Access PRICS for market prices
     C     PRICSK        CHAIN     PRICS                              50
 
     C                   ENDIF
 
     C                   EXSR      SRMain
 
     C                   READ      TRANS14                                01
 
     C                   ENDDO
 
      ** End process - updating completed or DB errors
     C                   EXSR      SRTotal
 
     C                   MOVE      *ON           *INLR
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMain     - Controlling subroutine for type of transaction. *
      *                                                               *
      *  Called by: Main processing                                   *
      *                                                               *
      *  Calls:     ZFWDT, SROptnAcKey                                *
      *                                                               *
      *****************************************************************
     C     SRMain        BEGSR
 
      ** Access TRSET for transaction settlement details
     C     TNBR          CHAIN     TRSET                              50
     C     *IN50         IFEQ      *ON
     C     FRECI         ORNE      TRECI
     C     *LOCK         IN        LDA
     C                   Z-ADD     6             DBASE
     C                   MOVEL     'TRSET'       DBFILE
     C                   MOVEL     TNBR          DBKEY
     C                   OUT       LDA
     C                   WRITE     HeadAU
     C                   WRITE     DBERRAU
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   ENDIF
 
      ** Check if premium already generated                                                   219682
                                                                                              219682
     C     TNBR          CHAIN     PRMPL0                             55                      219682
     C     *IN55         IFEQ      *ON                                                        219682
     C                   MOVE      'N'           CUPR                                         219682
     C                   MOVE      'N'           BRPR                                         219682
     C                   WRITE     PRMPDF                                                     219682
     C     TNBR          CHAIN     PRMPL0                             55                      219682
     C                   ENDIF                                                                219682
                                                                                              219682
      ** Process records w/ value date less or equal next working day
      ** minus one calendar day. Otherwise bypass processing.
 
      ** If Market process, take Business Date instead of run date
     C     P0Mkt         IFEQ      *BLANKS
     C                   Z-ADD     BJRDNB        PZDayNo050P
     C                   ELSE
     C                   Z-ADD     BUSD          PZDayNo050P
     C                   ENDIF
     C                   CALLB     'ZFWDT'
     C                   PARM                    PZDayNo050P
     C                   PARM      1             PZDayFwd020P
     C                   PARM      *ZERO         PZDayNoOut050P
     C                   PARM      ISCY          PZCcy003A
     C                   PARM                    PZLoc003A
 
     C     TRECI         IFEQ      'D'
     C     TVDAT         ANDLT     PZDayNoOut050P
     C     TVDAT         ANDGE     PZDayNo050P
 
     C     TRECI         OREQ      'D'                                                        222971
     C     TVDAT         ANDGE     PZDayNoOut050P                                             222971
     C     TVDAT         ANDGT     PZDayNo050P                                                222971
                                                                                              222971
      ** Input with value date = next day with next day closed in local
      ** ccy but open in instrument currency
     C     TRECI         OREQ      'D'
     C     TVDAT         ANDLE     PZDayNoOut050P
     C     TVDAT         ANDGE     PZDayNo050P
     C     TVDAT         ANDLT     BJDNWD
 
     C     TRECI         OREQ      '*'
     C     PZDayNo050P   ANDGT     TVDAT
     C     PZDayNo050P   ANDEQ     TVLCD
 
     C     TRECI         OREQ      '*'                                                        222971
     C     TORED         ANDLE     BJRDNB                                                     222971
                                                                                              222971
     C     TRECI         OREQ      'R'
     C     PZDayNo050P   ANDGT     TVDAT
     C     PZDayNo050P   ANDEQ     TVLCD
     C     TVLCD         ANDEQ     BJRDNB                                                     222971
 
     C     TRECI         OREQ      'R'                                                        222971
     C     TVLCD         ANDEQ     BJRDNB                                                     222971
                                                                                              222971
     C     TRECI         OREQ      'D'
     C     TVDAT         ANDLT     PZDayNoOut050P
     C     TORED         ANDEQ     PZDayNo050P
 
      ** A back valued trade inserted today should also produce premium                       222971
      ** a/c key during EOC/COB today, even if the system's rundate is ahead                  222971
      ** of the Business Date of the market. This condition is possible                       222971
      ** when the Market is defined to have an EOC processing after COB                       222971
      ** (i.e. AEOC = 'A' in MARKTD file).                                                    222971
     C     TRECI         OREQ      'D'                                                        222971
     C     TVDAT         ANDLT     PZDayNoOut050P                                             222971
     C     TORED         ANDGT     PZDayNo050P                                                222971
     C     AEOC          ANDEQ     'A'                                                        222971
                                                                                              222971
      ** Generate Premium Account Keys
     C                   EXSR      SROptnAcKey
 
      ** Update transaction details and transaction settlement details
     C     TRECI         IFEQ      '*'
     C                   MOVE      'R'           TRECI
     C                   MOVE      'R'           FRECI
     C                   ENDIF
 
     C                   EXCEPT    UTRANS
     C                   EXCEPT    UTRSET
     C                   EXCEPT    UPRMP                                                      219682
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTotal    - Process audit record/report.                    *
      *                                                               *
      *  Called by: Main processing                                   *
      *                                                               *
      *  Calls:     None.                                             *
      *                                                               *
      *****************************************************************
     C     SRTotal       BEGSR
 
      ** Write to audit report
     C                   WRITE     HEADAU
 
     C     COUNT         IFGT      0
 
     C                   READ      FOKEYAF                                50
     C     *IN50         IFEQ      *ON
     C     RECI          ORNE      'T'
     C     *LOCK         IN        LDA
     C                   Z-ADD     7             DBASE
     C                   MOVEL     'FOKEY'       DBFILE
     C                   MOVEL     'TRAILER'     DBKEY
     C                   OUT       LDA
     C                   WRITE     HeadAU
     C                   WRITE     DBERRAU
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDIF
      ** Update audit record totals
     C                   ADD       COUNT         NORE
      ** Add hash total to file control total, accomodating overflow
     C                   ADD       PZInt150P     HRWN
     C     HRDC          ADD       PZDec030P     TEMP              3 0
     C     TEMP          IFLT      HRDC
     C                   ADD       1             HRWN
     C                   ENDIF
     C                   Z-ADD     TEMP          HRDC
     C                   UPDATE    FOKEYAF
 
     C                   ENDIF
 
      ** Write to audit report (end of report)
     C                   WRITE     TRAILAU
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SROptnAcKey- Generate option account keys/position change    *
      *               rec.                                            *
      *                                                               *
      *  Called by: SRMain                                            *
      *                                                               *
      *  Calls:     SROptnAcPRS                                       *
      *                                                               *
      *****************************************************************
     C     SROptnAcKey   BEGSR
 
      ** If transaction is a trade
     C     TRTY          IFEQ      'P'
     C     TRTY          OREQ      'S'
 
      ** Generate a/c keys for the premium at start amount
      ** (for the premium payable on the trade)
     C     PRMP          IFNE      0
     C                   EXSR      SROptnAcPRS
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SROptnAcPRS- Generate account keys for premium at start.     *
      *                                                               *
      *  Called by: SROptnAcKey                                       *
      *                                                               *
      *  Calls:     SR00001, ZZADD                                    *
      *                                                               *
      *****************************************************************
     C     SROptnAcPRS   BEGSR
 
      ** Set value for FOKEYD
     C                   MOVE      'D'           RECI
     C                   Z-ADD     BJRDNB        EDAT
     C                   MOVE      ISCY          CCY
 
      ** Customer account keys
     C     CUPR          IFNE      'Y'                                                        219682
                                                                                              219682
     C     TRECI         OREQ      '*'                                                        223424
     C     ECPI          ANDEQ     'Y'                                                        223424
                                                                                              222971
     C     TRECI         OREQ      'R'                                                        222971
     C     ECPI          ANDEQ     'Y'                                                        222971
     C*****CUSC*         IFNE      0                                                          CSD027
     C     CUSC          IFNE      *BLANKS                                                    CSD027
 
      ** Account key field positions 1-10
     C                   MOVE      *BLANK        WDsFFKY
     C                   MOVE      CUSC          CBCD
     C                   MOVE      BOKC          BOOK
     C                   MOVE      'F'           TYPE
     C                   MOVE      'P'           ETYP
 
      ** Include instrument name only if market instrument
     C                   EXSR      SR00001
 
      ** Accommodate transaction type - position 11 of a/c key
     C     TRTY          IFEQ      'P'
     C                   MOVE      'L'           LORS
     C                   ELSE
     C                   MOVE      'S'           LORS
     C                   ENDIF
 
      ** Set up position 12 of account key
     C     ISTI          IFEQ      'N'
     C*****BOCO*         ANDNE     0                                                          CSD027
     C     BOCO          ANDNE     *BLANKS                                                    CSD027
     C                   MOVE      ' '           PRTY
     C                   ELSE
     C                   MOVE      'C'           PRTY
     C                   ENDIF
 
      ** Set up position 13 of account key
     C                   MOVE      'V'           POS13
 
      ** Set up position 14 of account key
     C     ISTI          IFEQ      'N'
     C*****BOCO*         ANDEQ     0                                                          CSD027
     C     BOCO          ANDEQ     *BLANKS                                                    CSD027
     C     BXISTY        IFEQ      'Y'
     C                   MOVE      'D'           AMTC
     C                   ELSE
     C     PUPF          IFEQ      'Y'
     C                   MOVE      'D'           AMTC
     C                   ELSE
     C                   MOVE      'F'           AMTC
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C     ISTI          IFEQ      'N'
     C*****BOCO*         ANDNE     0                                                          CSD027
     C     BOCO          ANDNE     *BLANKS                                                    CSD027
     C     TRTY          IFEQ      'P'
     C                   MOVE      'B'           AMTC
     C                   ELSE
     C                   MOVE      'C'           AMTC
     C                   ENDIF
     C                   ENDIF
 
     C     ISTI          IFEQ      'Y'
     C     PUPF          IFEQ      'Y'
     C                   MOVE      'D'           AMTC
     C                   ELSE
     C                   MOVE      'F'           AMTC
     C                   ENDIF
     C                   ENDIF
 
      ** Add a record to FOKEYD - customer settlement from TRSET
     C                   MOVE      CSLT          SETP
     C                   MOVE      CSLA          SETA
     C                   MOVE      BRSC          SEBR                                   201061
 
     C                   IF        CGL020 = 'Y'                                               CGL020
     C                   EVAL      SEBA = BRSC                                                CGL020
     C                   EVAL      SEFA = CFAO                                                CGL020
     C                   EVAL      SECP = CCPN                                                CGL020
     C                   EXSR      SRAMPR                                                     CGL020
                                                                                              CGL020
     C                   ENDIF                                                                CGL020
                                                                                              CGL020
      ** Event amount is premium paid from TRSET
     C                   Z-ADD     PRMP          EAMT
     C     BUSD          IFEQ      0
     C                   Z-ADD     BJRDNB        BUSD
     C                   ENDIF
 
      ** Reversal indicator
     C     TRECI         IFEQ      '*'
     C*****BUSD*         ANDGT     TVDAT                                                      222971
     C     ECPI          ANDEQ     'Y'
     C     TRECI         OREQ      'R'
     C*****BUSD*         ANDGT     TVDAT                                                      222971
     C     ECPI          ANDEQ     'Y'
     C                   Z-ADD     1             REVI
     C                   ELSE
     C                   Z-ADD     0             REVI
     C                   ENDIF
 
      ** No a/c key for 'Premium Payable At End' at value date
     C     PUPF          IFEQ      'Y'
 
      ** Set up value date with trade value date
     C     ETYP          IFEQ      'P'
     C     AMTC          ANDEQ     'B'
     C     ETYP          OREQ      'P'
     C     AMTC          ANDEQ     'C'
     C     ETYP          OREQ      'P'
     C     AMTC          ANDEQ     'D'
     C                   Z-ADD     TVDAT         VDAT
     C                   ENDIF
                                                                                              208523
      ** Move value from data structure to file field                                         208523
     C                   MOVEL(p)  WDsFFKY       FFKY                                         208523
 
     C                   WRITE     FOKEYDF
 
      ** Restore value date for other a/c key
     C                   Z-ADD     WWVDAT        VDAT
 
     C                   ADD       1             COUNT
     C     EAMT          DIV       1000          PZAmt153P
     C                   CALLB     'ZZADD'
     C                   PARM                    PZAmt153P
     C**********         PARM      *ZERO         PZInt150P                                    206860
     C**********         PARM      *ZERO         PZDec030P                                    206860
     C                   PARM                    PZInt150P                                    206860
     C                   PARM                    PZDec030P                                    206860
     C                   Z-ADD     PZInt150P     ZZTOTI
     C                   Z-ADD     PZDec030P     ZZTOTD
 
     C                   ENDIF
 
      ** End of customer premium account keys
     C                   ENDIF
 
     C                   MOVE      'Y'           CUPR                                         219682
     C                   ENDIF                                                                219682
      ** Broker account keys
     C     BRPR          IFNE      'Y'                                                        219682
                                                                                              219862
     C     TRECI         OREQ      '*'                                                        223424
     C     ECPI          ANDEQ     'Y'                                                        223424
                                                                                              222971
     C     TRECI         OREQ      'R'                                                        222971
     C     ECPI          ANDEQ     'Y'                                                        222971
     C*****BOCO*         IFNE      0                                                          CSD027
     C     BOCO          IFNE      *BLANKS                                                    CSD027
 
      ** Account key field positions 1-10
     C                   MOVE      *BLANK        WDsFFKY
     C                   MOVE      BOCO          CBCD
     C                   MOVE      BOKC          BOOK
     C                   MOVE      'F'           TYPE
     C                   MOVE      'P'           ETYP
 
      ** Include instrument name only if market instrument
     C                   EXSR      SR00001
 
      ** Accommodate transaction type - position 11 of a/c key
     C     TRTY          IFEQ      'P'
     C                   MOVE      'L'           LORS
     C                   ELSE
     C                   MOVE      'S'           LORS
     C                   ENDIF
 
      ** Set up position 12 of account key
     C*****CUSC*         IFEQ      0                                                          CSD027
     C     CUSC          IFEQ      *BLANKS                                                    CSD027
     C                   MOVE      'B'           PRTY
     C                   ELSE
     C                   MOVE      ' '           PRTY
     C                   ENDIF
 
      ** Set up position 13 of account key
     C                   MOVE      'V'           POS13
 
      ** Set up position 14 of account key
     C*****CUSC*         IFEQ      0                                                          CSD027
     C     CUSC          IFEQ      *BLANKS                                                    CSD027
     C     BXISTY        IFEQ      'Y'
     C                   MOVE      'D'           AMTC
     C                   ELSE
     C     PUPF          IFEQ      'Y'
     C                   MOVE      'D'           AMTC
     C                   ELSE
     C                   MOVE      'F'           AMTC
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C*****CUSC*         IFNE      0                                                          CSD027
     C     CUSC          IFNE      *BLANKS                                                    CSD027
     C     TRTY          IFEQ      'P'
     C                   MOVE      'C'           AMTC
     C                   ELSE
     C                   MOVE      'B'           AMTC
     C                   ENDIF
     C                   ENDIF
 
      ** Add a record to FOKEYD - broker settlement from TRSET
     C                   MOVE      BSLT          SETP
     C                   MOVE      BSLA          SETA
     C                   MOVE      BSBR          SEBR                            201061
 
     C                   IF        CGL020 = 'Y'                                               CGL020
     C                   EVAL      SEBA = BSBR                                                CGL020
     C                   EVAL      SEFA = BFAO                                                CGL020
     C                   EVAL      SECP = BCPN                                                CGL020
     C                   EXSR      SRAMPR                                                     CGL020
                                                                                              CGL020
     C                   ENDIF                                                                CGL020
                                                                                              CGL020
      ** Event amount is premium padi from TRSET
     C                   Z-ADD     PRMP          EAMT
 
      ** Reversal indicator
     C     TRECI         IFEQ      '*'
     C*****BUSD*         ANDGT     TVDAT                                                      222971
     C     ECPI          ANDEQ     'Y'
     C     TRECI         OREQ      'R'
     C*****BUSD*         ANDGT     TVDAT                                                      222971
     C     ECPI          ANDEQ     'Y'
     C                   Z-ADD     1             REVI
     C                   ELSE
     C                   Z-ADD     0             REVI
     C                   ENDIF
 
      ** No a/c key for 'Premium Payable At End' at value date
     C     PUPF          IFEQ      'Y'
 
      ** Set up value date with trade value date
     C     ETYP          IFEQ      'P'
     C     AMTC          ANDEQ     'B'
     C     ETYP          OREQ      'P'
     C     AMTC          ANDEQ     'C'
     C     ETYP          OREQ      'P'
     C     AMTC          ANDEQ     'D'
     C                   Z-ADD     TVDAT         VDAT
     C                   ENDIF
                                                                                              208523
      ** Move value from data structure to file field                                         208523
     C                   MOVEL(p)  WDsFFKY       FFKY                                         208523
 
     C                   WRITE     FOKEYDF
 
      ** Restore value date for other a/c key
     C                   Z-ADD     WWVDAT        VDAT
 
     C                   ADD       1             COUNT
     C     EAMT          DIV       1000          PZAmt153P
     C                   CALLB     'ZZADD'
     C                   PARM                    PZAmt153P
     C**********         PARM      *ZERO         PZInt150P        15 0                        206860
     C**********         PARM      *ZERO         PZDec030P         3 0                        206860
     C                   PARM                    PZInt150P        15 0                        206860
     C                   PARM                    PZDec030P         3 0                        206860
     C                   Z-ADD     PZInt150P     ZZTOTI
     C                   Z-ADD     PZDec030P     ZZTOTD
 
     C                   ENDIF
 
      ** End of broker premium account keys
     C                   ENDIF
                                                                                              219682
     C                   MOVE      'Y'           BRPR                                         219682
     C                   ENDIF                                                                219682
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR00001    - Defines position 2 and 6-10 of the account key. *
      *                                                               *
      *  Called by: SROptnAcPRS                                       *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
     C     SR00001       BEGSR
 
      ** The instrument type is defined on the account key
      ** but for market instruments only
     C     BXISTY        IFEQ      'Y'
 
     C     ISTI          IFEQ      'N'
     C                   MOVE      ISTT          MKINST
     C                   MOVEL     P0Mkt         MKINST
     C                   ELSE
     C                   MOVE      '     '       MKINST
     C                   ENDIF
 
     C                   ELSE
 
      ** The processing type is only valid if indicator is 'Y'
      ** on I.C.D.
     C     BXPROT        IFEQ      'Y'
     C                   MOVE      ISPT          INVA
     C                   ELSE
     C                   MOVE      *BLANKS       INVA
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFFFmt    - Accepts market centre name and business date,   *
      *               and outputs a field with these fields formatted *
      *               with the text 'as at' with no embedded blanks.  *
      *                                                               *
      *      Input:                                                   *
      *             WFFNAM - Market centre name                       *
      *             WFFDAT - Business date                            *
      *                                                               *
      *     Output:                                                   *
      *             WFFTxt - 'WFFNAM as at WFFDAT'                    *
      *             WFFULIN- No. of characters for underline          *
      *                                                               *
      *       Uses: WArFFT - array used to build output field         *
      *             WFF    - index for array WArFFT                   *
      *                                                               *
      *  Called by: *INZSR                                            *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
     C     SRFFFmt       BEGSR
 
      ** Initialization -
      ** Define fields passed into array
     C                   MOVE      WFFNAM        WFFNAM           20
     C                   MOVE      WFFDAT        WFFDAT            7
     C                   Z-ADD     WFFULIN       WFFULIN           2 0
 
      ** Left-justify market name in array
     C                   MOVEA     *BLANKS       WArFFT
     C                   MOVEA     WFFNAM        WArFFT
 
      ** Find position of last character of market name
     C                   Z-ADD     20            WFF               2 0
     C     WArFFT(WFF)   DOWEQ     *BLANK
     C                   SUB       1             WFF
     C                   ENDDO
 
      ** Store number of characters in market name plus text
      ** plus date
     C     WFF           ADD       14            WFFULIN
 
      ** Add the text 'as at' following the market name
     C                   ADD       2             WFF
     C                   MOVEA     'as at'       WArFFT(WFF)
 
      ** If day in month is less than 10, remove extra blank
     C                   MOVEL     WFFDAT        WChr001
     C     WChr001       IFEQ      *BLANK
     C                   ADD       5             WFF
     C                   ELSE
     C                   ADD       6             WFF
     C                   ENDIF
 
      ** Add the business date following the text 'as at'
     C                   MOVEA     WFFDAT        WArFFT(WFF)
 
     C                   ENDSR
      *****************************************************************                       CGL020
      /EJECT                                                                                  CGL020
      *****************************************************************                       CGL020
      *                                                               *                       CGL020
      *  SRAMPR   - Determines AML Pay/Receive Instructions           *                       CGL020
      *                                                               *                       CGL020
      *  Called by: SROptnAcPRS                                       *                       CGL020
      *                                                               *                       CGL020
      *  Calls:     None                                              *                       CGL020
      *                                                               *                       CGL020
      *****************************************************************                       CGL020
                                                                                              CGL020
     C     SRAMPR        BEGSR                                                                CGL020
                                                                                              CGL020
     C                   CALL      'ZAAMLSETFF'                                               CGL020
     C                   PARM      CBCD          PCBCD                                        CGL020
     C                   PARM                    SETA                                         CGL020
     C                   PARM                    SEBA                                         CGL020
     C                   PARM                    SEFA                                         CGL020
     C                   PARM                    SECP                                         CGL020
     C                   PARM                    CCY                                          CGL020
     C                   PARM                    F1RACT                                       CGL020
     C                   PARM                    F1RCTY                                       CGL020
     C                   PARM                    F1RBNK                                       CGL020
     C                   PARM                    F1RCDE                                       CGL020
     C                   PARM                    F1PACT                                       CGL020
     C                   PARM                    F1PCTY                                       CGL020
     C                   PARM                    F1PBNK                                       CGL020
     C                   PARM                    F1PCDE                                       CGL020
     C                   PARM                    F1DACT                                       CGL020
     C                   PARM                    F1DCTY                                       CGL020
     C                   PARM                    F1DBNK                                       CGL020
                                                                                              CGL020
     C                   Z-ADD     FCDA          F1SDAT                                       CGL020
                                                                                              CGL020
     C                   ENDSR                                                                CGL020
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls:     AOBANKR0, AOFODAR0, ZDATE2, SRFFFmt               *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    P0Mkt
 
      ** Key list for PRICS file
     C     PRICSK        KLIST
     C                   KFLD                    ISTT
     C                   KFLD                    YRNO
     C                   KFLD                    MTHN
     C                   KFLD                    PCAL
     C                   KFLD                    STRP
 
     C     *LIKE         DEFINE    ISTT          WSvISTT
     C     *LIKE         DEFINE    YRNO          WSvYRNO
     C     *LIKE         DEFINE    MTHN          WSvMTHN
     C     *LIKE         DEFINE    PCAL          WSvPCAL
     C     *LIKE         DEFINE    STRP          WSvSTRP
 
      ** Reset LDA
     C     *LOCK         IN        LDA
     C                   MOVE      *BLANKS       DBFile
     C                   MOVE      *BLANKS       DBKey
     C                   Z-ADD     *ZEROS        DBASE
     C                   MOVEL     PSProcMod     DBPgm
     C                   OUT       LDA
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtnCde07A
     C                   PARM      '*FIRST'      POption07A
     C     SDBANK        PARM      *BLANKS       DSFDY
     C     PRtnCde07A    IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     01            DBASE
     C                   MOVEL     'SDBANKPD'    DBFile
     C                   MOVEL     '*FIRST  '    DBKey
     C                   OUT       LDA
     C                   WRITE     HeadAU
     C                   WRITE     DBERRAU
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   ENDIF
 
     C                   Z-ADD     BJRDNB        EDAT
     C                   Z-ADD     BJRDNB        VDAT
 
     C                   CALL      'AOFODAR0'
     C                   PARM      *BLANKS       PRtnCde07A
     C                   PARM      '*FIRST '     POption07A
     C     SDFODA        PARM      SDFODA        DSFDY
     C     PRtnCde07A    IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDFODAPD'    DBFILE
     C                   MOVEL     '*FIRST '     DBKEY
     C                   Z-ADD     2             DBASE
     C                   OUT       LDA
     C                   WRITE     HeadAU
     C                   WRITE     DBERRAU
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   ENDIF
 
      ** Access SAR details to verify if the switchable feature                               CGL020
      ** CGL020 is installed.                                                                 CGL020
                                                                                              CGL020
     C                   CALL      'AOSARDR0'                                                 CGL020
     C                   PARM      *BLANKS       PRtnCde07A                                   CGL020
     C                   PARM      '*VERIFY '    POption07A                                   CGL020
     C                   PARM      'CGL020'      PSARD                                        CGL020
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL020
                                                                                              CGL020
      ** Database error                                                                       CGL020
     C                   IF        PRtnCde07A <> *Blanks                                      CGL020
     C                             AND PRtnCde07A <> '*NRF'                                   CGL020
     C     *LOCK         IN        LDA                                                        CGL020
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CGL020
     C                   EVAL      DBASE = 8                                                  CGL020
     C                   EVAL      DBKEY = 'CGL020'                                           CGL020
     C                   OUT       LDA                                                        CGL020
     C                   EXSR      *PSSR                                                      CGL020
     C                   ENDIF                                                                CGL020
                                                                                              CGL020
     C                   IF        PRtnCde07A =  *Blank                                       CGL020
     C                   EVAL      CGL020 = 'Y'                                               CGL020
     C                   ELSE                                                                 CGL020
     C                   EVAL      CGL020 = 'N'                                               CGL020
     C                   ENDIF                                                                CGL020
                                                                                              CGL020
      ** Access market center file for current business date if
      ** parameter is not blank
 
     C     P0Mkt         IFNE      *BLANKS
 
     C                   OPEN      MKCTL
     C     P0Mkt         CHAIN     MKCTL                              50
     C     *IN50         IFEQ      *ON
     C     RECI          ORNE      'D'
     C     *LOCK         IN        LDA
     C                   Z-ADD     3             DBASE
     C                   MOVEL     'MKCTL'       DBFILE
     C                   MOVEL     P0Mkt         DBKEY
     C                   OUT       LDA
     C                   WRITE     HeadAU
     C                   WRITE     DBERRAU
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   ENDIF
     C                   MOVE      BUSD          VDAT
 
      ** Access market file for market name
     C                   OPEN      MARKT
     C     P0Mkt         CHAIN     MARKT                              50
     C     *IN50         IFEQ      '1'
     C     RECI          ORNE      'D'
     C     *LOCK         IN        LDA
     C                   MOVE      'MARKT'       DBFILE
     C                   MOVEL     P0Mkt         DBKEY
     C                   Z-ADD     4             DBASE
     C                   OUT       LDA
     C                   WRITE     HeadAU
     C                   WRITE     DBERRAU
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   ENDIF
 
     C                   ENDIF
 
      ** Format run/business date for report title
     C     P0Mkt         IFNE      *BLANKS
     C                   Z-ADD     BUSD          PZDayNo050P
     C                   CALLB     'ZDATE2'
     C                   PARM                    PZDayNo050P
     C                   PARM      BJDFIN        PZDteFmt001A
     C                   PARM      *ZERO         PZDte060P
     C                   PARM      *BLANKS       PZDte007A
     C                   MOVE      PZDte007A     WFFDAT
     C                   MOVE      MKTN          WFFNAM
     C                   ELSE
     C                   MOVE      WTbMsg(1)     WFFNAM
     C                   MOVE      BJMRDT        WFFDAT
     C                   ENDIF
 
     C                   EXSR      SRFFFmt
     C                   MOVE      WFFTxt        MNAMED
 
      **  Set up underlining for heading
      **  Initialise array index
     C                   Z-ADD     0             X                 2 0
 
      ** WFFULIN returned from SRFFFmt contains number of characters
      ** for underline
     C     X             DOUEQ     WFFULIN
     C                   ADD       1             X
     C                   MOVEA     '-'           WArFULA(X)
     C                   ENDDO
 
      **  Move underline array to output field
     C                   MOVEA     WArFULA       FULINE
 
      ** Save value date to avoid overwriting
     C                   Z-ADD     VDAT          WWVDAT            5 0
 
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
      *  Called by: (**calling routines**)                            *
      *                                                               *
      *  Calls:     DBERRCTL                                          *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   DUMP
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   CALLB     'DBERRCTL'
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
     OTRANSDF   E            UTRANS
     O                       TRECI
     OTRSETDF   E            UTRSET
     O                       FRECI
     OPRMPDF    E            UPRMP                                                            219682
     O                       TNBR                                                             219682
     O                       CUPR                                                             219682
     O                       BRPR                                                             219682
      *****************************************************************
** WTbMsg
OVER THE COUNTER
