     H DEBUG
     H ALWNULL(*INPUTONLY)
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GP Extract ML Exposure')                         *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPEXTMLEX - Extract ML Exposure                              *
      *                                                               *
      *  (c) Finastra Systems Technology, Inc. 2019                   *
      *                                                               *
      *  Last Amend No. DAI103             Date 25Jun19               *
      *  Prev Amend No. NADC02             Date 12Jun12               *
      *                 NADC01  *CREATE    Date 17Nov09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  DAI103 - Upgraded MPlus 121 NADC01 and NADC02 ML Extracts    *
      *           to FB 2.1                                           *
      *  NADC02 - ML REPORTING TO INCLUDE IRS                         *
      *  NADC01 - ML EXTRACTS FOR MIZUHO                              *
      *                                                               *
      *****************************************************************
 
     FGPTRAPL0  IP  AE           K DISK
     FTXMLTRNEXPIS  AE           K DISK
     FTXUCAPTRANIS  AE           K DISK
     FGPPOSNL0  IF   E           K DISK
     FGZSDBANKPDIF   E             DISK
     FGZSDCUSTL1IF   E           K DISK
     FI_GPMLCSI0IF   E           K DISK
     FGPCUSTXL0 IF   E           K DISK
     FGPCTRYL0  IF   E           K DISK
     FGZSDINDSL0IF   E           K DISK
     FGPMLEXPD  O    E             DISK     rename(GPMLEXD0:GPMLEXF)
     FQSYSPRT   O    F  132        PRINTER
 
     D ZYDY            S              4  0 DIM(4) CTDATA PERRCD(4)
     D ZMDY            S              3  0 DIM(13) CTDATA PERRCD(13)
     D ZMNM            S              3    DIM(12) CTDATA PERRCD(12)
 
     D GPML          E DS                  EXTNAME(GPMLEXPD)
 
     D ZDayNo          S              5P 0
     D ZDatfm          S              1A
     D ZADate          S              7A
     D ZDate           S              6P 0
 
      ** Parameters for MRDATBID - Date Bucket Identification Module
     D PaDtSch         S              1  0
     D PaRepDt         S              5  0
     D PaSchDt         S              5  0
     D PaBuckCode      S              8
 
     IGOTRAPD0      01
     I                                          T_ID          L1M1
     ITXMLTRNEXF    02
     I              TETRNIDX                    T_ID          L1M1
     ITXUCAPTRAF    03
     I              TRAN_IDX                    T_ID          L1M1
 
     C   L1              CLEAR                   GPML
 
     C   01              ADD       1             Cnt_TRAP
     C   02              ADD       1             Cnt_TRNEXP
     C   03              ADD       1             Cnt_UCAPTRN
 
     CL1                 SELECT
 
      * Extract Exposures
 
     CL1                 WHEN      Cnt_TRAP = 1
     C                             AND Cnt_TRNEXP = 1
     CL1                 EXSR      EXT_MLEX
 
      * Extract Uncaptured Transactions
 
     CL1                 WHEN      Cnt_TRAP = 1
     C                             AND Cnt_TRNEXP = 0
     CL1                 EXSR      EXT_MLUT
 
      * Report discrepancies
 
     CL1                 OTHER
     CL1                 EXSR      RPT_DISC
     CL1                 ENDSL
 
     CL1                 Z-ADD     0             Cnt_TRAP          2 0
     CL1                 Z-ADD     0             Cnt_TRNEXP        2 0
     CL1                 Z-ADD     0             Cnt_UCAPTRN       2 0
 
     CLR                 Z-ADD     1             CHLINE
     CLR                 EXSR      PAG
     CLR                 EXCEPT    ENDRPT
      *****************************************************************
     C     RPT_DISC      BEGSR
     C                   Z-ADD     1             CHLINE            2 0
     C                   EXSR      PAG
     C                   EXCEPT    DETAIL
     C                   ENDSR
      *****************************************************************
     C     PAG           BEGSR
     C                   ADD       CHLINE        LINENO
     C     LINENO        IFGT      59
     C                   ADD       1             PAGNUM
     C                   EXCEPT    PAGEHEAD
     C     2             ADD       CHLINE        LINENO
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
     C     EXT_MLEX      BEGSR
     C**?? T_MATI        CABEQ     'Y'           ENDMLEX
 
     C                   EXSR      GET_POSN
     C     *IN99         CABEQ     '1'           ENDMLEX
 
     C                   EXSR      SET_OUTPUT
 
     C                   EXSR      MKT_VALUE
 
     C                   EXSR      USD_AMNTS
 
     C                   IF        MEINST <> *blank
     C                   IF        MENOMINAL <> 0 OR MEEXPOSURE <> 0
     C                             OR MEPOSITN <> 0
     C                   WRITE     GPMLEXF
     C                   ENDIF
     C                   ENDIF
 
     C     ENDMLEX       ENDSR
      *****************************************************************
     C     EXT_MLUT      BEGSR
     C**?? T_MATI        CABEQ     'Y'           ENDMLUT
 
     C                   EVAL      TEINST    = *BLANK
     C                   EVAL      TEEXPOSURE= *ZERO
     C                   EVAL      TEOFFSET  = *ZERO
 
     C                   EXSR      GET_POSN
     C     *IN99         CABEQ     '1'           ENDMLUT
 
     C                   EVAL      TEEXPCCY  = P_CCY
     C                   EVAL      TEOFFCCY  = P_OCCY
 
     C                   EXSR      SET_OUTPUT
     C                   IF        T_RLDO = 'Y' AND P_ASLI = 'A'
     C                   EVAL      MEINST    = 'GLOBMM'
     C                   EVAL      MEEXPOSURE= MENOMINAL
     C                   ENDIF
 
     C                   EXSR      MKT_VALUE
 
     C                   EXSR      USD_AMNTS
 
     C                   IF        MEINST <> *blank
     C                   IF        MENOMINAL <> 0 OR MEEXPOSURE <> 0
     C                             OR MEPOSITN <> 0
     C                   WRITE     GPMLEXF
     C                   IF        T_RLDO = 'Y'
     C                   EVAL      MEGLCAT = '4 FWD'
     C                   Z-SUB     MEEXPOSURE    MEEXPOSURE
     C                   Z-SUB     MEEXPINUSD    MEEXPINUSD
     C                   WRITE     GPMLEXF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C     ENDMLUT       ENDSR
      *****************************************************************
     C     GET_POSN      BEGSR
     C     GPPOSNK       KLIST
     C                   KFLD                    P_ID
     C                   KFLD                    P_TVDI
     C                   KFLD                    P_PSTP
     C                   EVAL      P_ID = T_ID
     C                   EVAL      P_TVDI = 'T'
     C                   IF        T_RLDO <> 'Y'
     C                   EVAL      P_PSTP = 'C'
     C                   ELSE
     C                   EVAL      P_PSTP = 'M'
     C                   ENDIF
     C     GPPOSNK       CHAIN     GOPOSND0                           99
     C                   ENDSR
      *****************************************************************
     C     SET_OUTPUT    BEGSR
     C                   MOVEL     T_CNUM        Customer          6
     C                   MOVEL     T_CUBR        CustBranch        3
     C     CustomerKey   KLIST
     C                   KFLD                    CustBranch
     C                   KFLD                    Customer
     C     CustomerKey   CHAIN     SDCUSTD0                           99
     C   99              MOVEL     Customer      BBCUST
     C   99              MOVEL     CustBranch    BBBRCD
     C   99              MOVEL     *BLANK        BBCRNM
 
     C     GPCUSTXKey    KLIST
     C                   KFLD                    BBBRCD
     C                   KFLD                    BBCUST
     C     GPCUSTXKey    CHAIN     GPCUSTXD0                          99
      * Global Customer number
     C   99              EVAL      MEGCUST = BBBRCD + '-' + BBCUST
     C  N99              EVAL      MEGCUST = CUGCUS
      * Customer number type
     C   99              EVAL      MECUNTP = 'Z'
     C  N99              EVAL      MECUNTP = 'G'
      * Customer Name
     C                   EVAL      MECUSTNAME = BBCUST + '  ' + BBCRNM
      * Transaction Reference
     C                   EVAL      METREF    = T_TREF
      * Transaction Shortname
     C                   EVAL      MESNAM    = T_SNAM
      * Booking Branch
     C                   EVAL      MEBRCA    = T_BRCA
      * Global Instrument Code
     C                   EVAL      MEINST    = TEINST
      * GL Categgory
     C                   EXSR      DETGLCAT
 
      * Transaction Date DDMMMYY
     C                   Z-ADD     T_TDAT        ZDAYNO
     C                   EXSR      ZDATE2
     C                   EVAL      MERTDAT   = ZADATE
      * Start Date DDMMMYY
     C                   Z-ADD     T_SDAT        ZDAYNO
     C                   EXSR      ZDATE2
     C                   EVAL      MERSDAT   = ZADATE
      * End Date DDMMMYY
     C                   Z-ADD     T_EDAT        ZDAYNO
     C                   EXSR      ZDATE2
     C                   EVAL      MEREDAT   = ZADATE
 
      ** Set Maturity Bucket - Date schedule 0
 
     C                   EVAL      PaDtSch = 0
     C                   EVAL      PaRepDt = BJRDNB
     C                   EVAL      PaSchDt = T_EDAT
     C                   EXSR      SRGetBuckCd
     C                   EVAL      MEMATB = PaBuckCode
      * Nominal
      * (May be set to Market value later)
 
     C                   EVAL      MENOMINAL= 0
     C                   IF           P_ASLI = 'A'
     C                   IF           T_SMOD <> 'SBPS'
     C                             OR T_SMOD =  'SBPS' AND T_EDAT > 0
     C                   SELECT
     C                   WHEN      P_NMDP = 3
     C                   EVAL      MENOMINAL= P_NOML/1000
     C                   WHEN      P_NMDP = 2
     C                   EVAL      MENOMINAL= P_NOML/100
     C                   WHEN      P_NMDP = 1
     C                   EVAL      MENOMINAL= P_NOML/10
     C                   OTHER
     C                   EVAL      MENOMINAL= P_NOML
     C                   ENDSL
     C                   ENDIF
     C                   ENDIF
      * Nominal Currency
     C                   EVAL      MENOMCCY  = P_CCY
      * Position
     C                   IF        T_SMOD = 'SBPS' AND T_EDAT <= 0
     C                   SELECT
     C                   WHEN      P_NMDP = 4
     C                   EVAL      MEPOSITN = P_NOML/10000
     C                   WHEN      P_NMDP = 3
     C                   EVAL      MEPOSITN = P_NOML/1000
     C                   WHEN      P_NMDP = 2
     C                   EVAL      MEPOSITN = P_NOML/100
     C                   WHEN      P_NMDP = 1
     C                   EVAL      MEPOSITN = P_NOML/10
     C                   OTHER
     C                   EVAL      MEPOSITN = P_NOML
     C                   ENDSL
     C                   ELSE
     C                   EVAL      MEPOSITN = 0
     C                   ENDIF
      * Market Price
     C                   EVAL      MEMKPR = P_MKPR
      * Other Nominal
     C                   IF           T_SMOD = 'FXDL'
     C                   SELECT
     C                   WHEN         P_OCCY = 'AIC'  OR P_OCCY = 'BEF'
     C                             OR P_OCCY = 'ITL'  OR P_OCCY = 'JPY'
     C                   EVAL      MEOTHNOM = P_ONOM
     C                   WHEN      P_OCCY = 'MRO'
     C                   EVAL      MEOTHNOM = P_ONOM/10
     C                   WHEN         P_OCCY = 'BHD'  OR P_OCCY = 'KWD'
     C                             OR P_OCCY = 'DZD'  OR P_OCCY = 'OMR'
     C                             OR P_OCCY = 'EGP'  OR P_OCCY = 'SDD'
     C                             OR P_OCCY = 'IQD'  OR P_OCCY = 'SDG'
     C                             OR P_OCCY = 'JOD'  OR P_OCCY = 'TND'
     C                   EVAL      MEOTHNOM = P_ONOM/1000
     C                   OTHER
     C                   EVAL      MEOTHNOM = P_ONOM/100
     C                   ENDSL
     C                   ELSE
     C                   EVAL      MEOTHNOM = 0
     C                   ENDIF
      * Other Currency
     C                   EVAL      MEOTHCCY  = P_OCCY
      * Exposure
     C                   SELECT
     C                   WHEN         P_CCY  = 'AIC'  OR P_CCY  = 'BEF'
     C                             OR P_CCY  = 'ITL'  OR P_CCY  = 'JPY'
     C                   Z-ADD(H)  TEEXPOSURE    wrk150           15 0
     C                   EVAL      MEEXPOSURE= wrk150
     C                   WHEN      P_CCY  = 'MRO'
     C                   Z-ADD(H)  TEEXPOSURE    wrk161           16 1
     C                   EVAL      MEEXPOSURE= wrk161
     C                   WHEN         P_CCY  = 'BHD'  OR P_CCY  = 'KWD'
     C                             OR P_CCY  = 'DZD'  OR P_CCY  = 'OMR'
     C                             OR P_CCY  = 'EGP'  OR P_CCY  = 'SDD'
     C                             OR P_CCY  = 'IQD'  OR P_CCY  = 'SDG'
     C                             OR P_CCY  = 'JOD'  OR P_CCY  = 'TND'
     C                   Z-ADD(H)  TEEXPOSURE    wrk183           18 3
     C                   EVAL      MEEXPOSURE= wrk183
     C                   OTHER
     C                   Z-ADD(H)  TEEXPOSURE    wrk172           17 2
     C                   EVAL      MEEXPOSURE= wrk172
     C                   ENDSL
      * Exposure Currency
     C                   EVAL      MEEXPCCY  = TEEXPCCY
      * Offset
     C                   SELECT
     C                   WHEN         TEOFFCCY = 'AIC'  OR TEOFFCCY = 'BEF'
     C                             OR TEOFFCCY = 'ITL'  OR TEOFFCCY = 'JPY'
     C                   Z-ADD(H)  TEOFFSET      wrk150           15 0
     C                   EVAL      MEOFFSET  = wrk150
     C                   WHEN      TEOFFCCY = 'MRO'
     C                   Z-ADD(H)  TEOFFSET      wrk161           16 1
     C                   EVAL      MEOFFSET  = wrk161
     C                   WHEN         TEOFFCCY = 'BHD'  OR TEOFFCCY = 'KWD'
     C                             OR TEOFFCCY = 'DZD'  OR TEOFFCCY = 'OMR'
     C                             OR TEOFFCCY = 'EGP'  OR TEOFFCCY = 'SDD'
     C                             OR TEOFFCCY = 'IQD'  OR TEOFFCCY = 'SDG'
     C                             OR TEOFFCCY = 'JOD'  OR TEOFFCCY = 'TND'
     C                   Z-ADD(H)  TEOFFSET      wrk183           18 3
     C                   EVAL      MEOFFSET  = wrk183
     C                   OTHER
     C                   Z-ADD(H)  TEOFFSET      wrk172           17 2
     C                   EVAL      MEOFFSET  = wrk172
     C                   ENDSL
      * Offset Currency
     C                   EVAL      MEOFFCCY  = TEOFFCCY
      * % Weighting
     C                   EVAL      MEWEIGHT = 100
      * Customer branch
     C                   EVAL      MECBRC = BBBRCD
      * Customer number
     C                   EVAL      MECUST = BBCUST
      * Country code
     C                   EVAL      MECNCD = T_CNCD
     C                   IF        MECNCD = *BLANK
     C                   EVAL      MECNCD = '??'
     C                   ENDIF
      * Country code & name
     C                   MOVEL     *BLANK        A4CNNM
     C     MECNCD        CHAIN     GPCTRYD0                           99
     C                   EVAL      MECNCDNAM = MECNCD + ' ' + A4CNNM
      * Industry code
     C                   EVAL      MELICD = T_LICD
     C                   IF        MELICD = *BLANK
     C                   EVAL      MELICD = '??'
     C                   ENDIF
      * Industry code & name
     C                   MOVEL     *BLANK        AOLINA
     C     MELICD        CHAIN     SDINDSD0                           99
     C                   EVAL      MELICDNAM = MELICD + ' ' + AOLINA
      * Transaction ID
     C                   EVAL      MEID      = T_ID
      * Sub-Module
     C                   EVAL      MESMOD    = T_SMOD
      * Transaction Type
     C                   EVAL      METRTP    = T_TRTP
      * Transaction Sub Type
     C                   EVAL      METRST    = T_TRST
      * Transaction Date
     C                   EVAL      METDAT    = T_TDAT
      * Start Date
     C                   EVAL      MESDAT    = T_SDAT
      * End Date
     C                   EVAL      MEEDAT    = T_EDAT
      * Limit defined
     C                   EVAL      MELIMDEFC  = 'N'
     C                   EVAL      MELIMDEFP  = 'N'
     C                   EVAL      MELIMDEFX  = 'N'
 
     C                   ENDSR
      *****************************************************************
     C     MKT_VALUE     BEGSR
      * Market value
     C                   EVAL      MEMKTVAL = 0
     C                   SELECT
     C                   WHEN         T_VCCY = 'AIC'  OR T_VCCY = 'BEF'
     C                             OR T_VCCY = 'ITL'  OR T_VCCY = 'JPY'
     C                   EVAL      MEMKTVAL = T_MKVL
     C                   WHEN      T_VCCY = 'MRO'
     C                   EVAL      MEMKTVAL = T_MKVL/10
     C                   WHEN         T_VCCY = 'BHD'  OR T_VCCY = 'KWD'
     C                             OR T_VCCY = 'DZD'  OR T_VCCY = 'OMR'
     C                             OR T_VCCY = 'EGP'  OR T_VCCY = 'SDD'
     C                             OR T_VCCY = 'IQD'  OR T_VCCY = 'SDG'
     C                             OR T_VCCY = 'JOD'  OR T_VCCY = 'TND'
     C                   EVAL      MEMKTVAL = T_MKVL/1000
     C                   OTHER
     C                   EVAL      MEMKTVAL = T_MKVL/100
     C                   ENDSL
      * Market value currency
     C                   EVAL      MEMKTCCY = T_VCCY
      * NOMINAL
     C                   IF        T_SMOD =  'SBPS' AND T_EDAT = 0
     C                   EVAL      MENOMINAL= MEMKTVAL
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
     C     USD_AMNTS     BEGSR
      * Zone
     C                   MOVEL     T_ZONE        ZONE
     C                   MOVE      'USD'         TCCY              3
 
      * Nominal in USD
     C                   MOVE      P_CCY         FCCY              3
     C                   Z-ADD     MENOMINAL     INAMT            17 2
     C                   Z-ADD     0             OTAMT            17 2
     C                   EXSR      CONV
     C                   EVAL      MENOMINUSD = OTAMT
      * Exposure in USD
     C                   MOVE      P_CCY         FCCY              3
     C                   Z-ADD     MEEXPOSURE    INAMT            17 2
     C                   Z-ADD     0             OTAMT            17 2
     C                   EXSR      CONV
     C                   EVAL      MEEXPINUSD = OTAMT
      * Other Nominal in USD
     C                   IF        P_OCCY <> '    '
     C                   MOVE      P_OCCY        FCCY              3
     C                   Z-ADD     MEOTHNOM      INAMT            17 2
     C                   Z-ADD     0             OTAMT            17 2
     C                   EXSR      CONV
     C                   EVAL      MEONMINUSD = OTAMT
     C                   ELSE
     C                   EVAL      MEONMINUSD = 0
     C                   ENDIF
      * Offset in USD
     C                   IF        P_OCCY <> '    '
     C                   MOVE      P_OCCY        FCCY              3
     C                   Z-ADD     MEOFFSET      INAMT            17 2
     C                   Z-ADD     0             OTAMT            17 2
     C                   EXSR      CONV
     C                   EVAL      MEOFFINUSD = OTAMT
     C                   ELSE
     C                   EVAL      MEOFFINUSD = 0
     C                   ENDIF
      * Market Value in USD
     C                   IF        T_VCCY <> '    '
     C                   MOVE      T_VCCY        FCCY              3
     C                   Z-ADD     MEMKTVAL      INAMT            17 2
     C                   Z-ADD     0             OTAMT            17 2
     C                   EXSR      CONV
     C                   EVAL      MEMKTINUSD = OTAMT
     C                   ELSE
     C                   EVAL      MEMKTINUSD = 0
     C                   ENDIF
      * Exposure Difference
     C                   IF        MEEXPINUSD <> MENOMINUSD
     C                   EVAL      MEEXPDIF = 'Y'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
     C     CONV          BEGSR
 
     C                   SELECT
 
     C                   WHEN      FCCY = 'USD'
     C                   EVAL      OTAMT = INAMT
 
     C                   OTHER
     C                   MOVE      FCCY          CCY
     C     KEY           CHAIN     GPMLCSPD                           99
     C   99              EVAL      CCYSRATE = 1
     C   99              DUMP
     C                   EVAL(H)   OTAMT = INAMT * CCYSRATE
     C                   ENDSL
 
     C     KEY           KLIST
     C                   KFLD                    CCY               3
     C                   KFLD                    ZONE             10
 
     C                   ENDSR
      *****************************************************************
     C     DETGLCAT      BEGSR
     C                   EVAL      MEGLCAT = '1 ON '
     C                   IF        T_SMOD = 'SBPS'
     C                   CALL      'GPDETPGLC'
     C                   PARM      T_TRTP        I#TRTP            5            INV TYPE
     C                   PARM      T_SNAM        I#SNAM           50            SHORTAME
     C                   PARM      *BLANK        MEGLCAT
     C                   ENDIF
     C                   IF        T_SMOD = 'LDNI' OR T_SMOD = 'LOAN'
     C                   CALL      'GPDETTGLC'
     C                   PARM      T_TRTP        I#TRTP            5            TYPE
     C                   PARM      T_TRST        I#TRST            5            SUB-TYPE
     C                   PARM      *BLANK        MEGLCAT
     C                   IF        T_SDAT >= BJRDNB
     C                   EVAL      MEGLCAT = '4 FWD'
     C                   ENDIF
     C                   ENDIF
     C                   IF        T_SMOD = 'FXDL' OR T_SMOD = 'MT  '
     C                                             OR T_SMOD = 'FRAS'                         NADC02
     C                                             OR T_SMOD = 'SIRS'                         NADC02
     C                                             OR T_SMOD = 'CIRS'                         NADC02
     C                   EVAL      MEGLCAT = '2 OFF'
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
     C     ZDATE2        BEGSR
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDayNo
     C                   PARM      BJDFIN        ZDatfm
     C                   PARM                    ZDate
     C                   PARM                    ZADate
     C                   ENDSR
      *****************************************************************
     C     SRGetBuckCd   BEGSR
 
     C                   CALL      'MRDATBID'
     C                   PARM                    PaDtSch
     C                   PARM                    PaRepDt
     C                   PARM                    PaSchDt
      ** Output
     C                   PARM                    PaBuckCode
 
     C                   ENDSR
      *****************************************************************
     C     *INZSR        BEGSR
 
     C                   READ      GZSDBANKPD                             H1
     C   H1              DUMP
 
     C                   Z-ADD     99            LINENO            3 0
     C                   Z-ADD     0             PAGNUM            5 0
     C                   EXSR      PAG
 
     C                   ENDSR
      *****************************************************************
     OQSYSPRT   E            PAGEHEAD        001002
     O                                           14 'REF. GPEXTMLEX'
     O                                           70 'EXPOSURE DISCEPANCY REPORT'
     O                                          107 'DATE:'
     O                       BJMRDT             114
     O                                          120 'PAGE:'
     O                       PAGNUM             125 '   0 '
     O          E            PAGEHEAD    1
     O                                           15 'TRANSACTION ID'
     O                                           40 'TRAP Count'
     O                                           60 'TRNEXP Count'
     O                                           80 'UCAPTRN Count'
     O          E            DETAIL      1
     O                       T_ID                15
     O                       Cnt_TRAP            40 '0 '
     O                       Cnt_TRNEXP          60 '0 '
     O                       Cnt_UCAPTRN         80 '0 '
     O          E            ENDRPT      1
     O                                           70 '*END OF REPORT*'
**   ZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
0366073110961461
**   ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
000031059090120151181212243273304334365
**   ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
