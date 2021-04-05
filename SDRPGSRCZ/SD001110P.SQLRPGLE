     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2020')
      *****************************************************************
/*STD *  RPGSQLMOD                                                    *
/*EXI *  TEXT('Midas SD Daily Rate Calculation Report')               *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD001110P - Midas SD Daily Rate Calculation Report           *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. CLE172    *CREATE  Date 01Oct20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE172 - LIBOR Deregulation - Lending                        *
      *                                                               *
      *****************************************************************
     FSD001110P1O    E             PRINTER OFLIND(*IN50)
      ** Midas SD Compounding Rate History Details Report
     FLECLIPL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(CLOANCKF)
      ** Loan Details

      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
     D/COPY ZACPYSRC,STD_D_SPEC

      ** +--------------------------------------+
      ** ¦ Program Prototypes                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     D RetrieveBANK    PR                  EXTPGM('AOBANKR0')
     D  pReturnCode                   7A
     D  pOption                       7A
     D  pDSSDY                      200A

      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D pDSSDY          S            200A

      ** Parameters for ZDATE2
     D ZDayNo          S              5P 0
     D ZDate           S              6P 0
     D ZADate          S              7A

      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  ErrorOnFl             35     35
     D  EndOfFile             45     45

      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))

      ** +--------------------------------------+
      ** ¦ Variable declaration                 ¦
      ** ¦ ====================                 ¦
      ** +--------------------------------------+
     D pReturnCode     S              7A
     D pOption         S              7A

      ** Temporary DS for SDHSDRTD

     D DlyDS           DS
     D DintStart                      5p 0
     D DintEnd                        5p 0
     D Dintd                          5p 0
     D Dindy                          5p 0
     D Dobdt                          5p 0
     D Dobdy                          5p 0
     D Dbrfr                         17p12
     D Drtap                         17p12
     D Davcr                         17p12

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+

      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************

     C                   ADD       1             PGENUM
     C                   WRITE     SD001110H1
      *
     C     *LOVAL        SETLL     LECLIPL2
     C                   READ      LECLIPL2                             3545
      *
      ** Database error
      *
     C                   IF        ErrorOnFl = True
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = '*FIRST'
     C                   EVAL      DBFile = 'LECLIPL2'
     C                   EVAL      DBase = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Start loop
      *
     C                   DOW       EndOfFile = False
      *
      ** Process Report Lines
      *
     C     BLRT          IFEQ      'Y'
     C                   EXSR      SRPrint
     C                   ENDIF
      *
      ** Read next record
      *
     C                   READ      LECLIPL2                             3545
      *
     C                   IF        ErrorOnFl = True
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = '*NEXT'
     C                   EVAL      DBFile = 'LECLIPL2'
     C                   EVAL      DBase = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   WRITE     SD001110T1
      *
     C                   EVAL      *INLR = *ON

      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPrint - Print details report                                *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRPrint       BEGSR
      *
      ** Write details to printer fields
      *
      * Loan Details
     C                   EVAL      P1LNRF = LNRF
      *
     C                   EVAL      ZDayNo = VDAT
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDayNo
     C                   PARM                    BJDFIN
     C                   PARM      *Zero         ZDate
     C                   PARM      *BLanks       ZADate
      *
     C                   EVAL      P1VLDT = ZADate
     C                   EVAL      P1INFR = IPFR
      *
     C                   EVAL      ZDayNo = MDAT
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDayNo
     C                   PARM                    BJDFIN
     C                   PARM      *Zero         ZDate
     C                   PARM      *BLanks       ZADate
      *
     C                   EVAL      P1MTDT = ZADate
     C                   EVAL      P1CCY  = CCY
     C                   EVAL      P1BRAT = BRTT
     C                   EVAL      P1CUPR = CPAM
     C                   EVAL      P1RTSP = RTSP
     C                   EVAL      P1SPRD = SPIN
     C                   EVAL      P1BADJ = BADJ
      *
     C                   EVAL      P1RFRT = RFRR
     C                   EVAL      P1LKBD = LBDY
     C                   EVAL      P1LOUT = LODY
     C                   EVAL      P1RTRO = RRDP
     C                   EVAL      P1DBFA = DBAV
      *
     C     DBAV          IFEQ      0
     C                   EVAL      P1AVDS = 'Zero'
     C                   ENDIF
     C     DBAV          IFEQ      1
     C                   EVAL      P1AVDS = 'Actual/365'
     C                   ENDIF
     C     DBAV          IFEQ      2
     C                   EVAL      P1AVDS = 'Actual/360'
     C                   ENDIF
     C     DBAV          IFEQ      6
     C                   EVAL      P1AVDS = 'Actual/Actual'
     C                   ENDIF
      *
     C                   EVAL      P1OBSP = OPSH
     C                   EVAL      P1RAKI = RTKN
     C                   SETON                                        20
     C                   EVAL      P1FLOR = FLOR
     C     0             IFEQ      FLOR
     C                   SETOFF                                       20
     C                   ENDIF
      *
      ** Daily Details
      *
      *
     C/exec SQL
     C+ declare SDHS cursor for
     C+ select
     C+   CINPSD
     C+ , CINPED
     C+ , CINPDT
     C+ , CINPDY
     C+ , COBPDT
     C+ , COBPDY
     C+ , CPBRFR
     C+ , CRTEAP
     C+ , CAVCRT
     C+ from SDHSDRTD
     C+ where
     C+     CMODID = 'LE'
     C+ and CTRNID = :P1LNRF
     C+ and CINFLG >= 'Y'
     C+ order by
     C+     CINPDT asc
     C/end-exec
      *
     C/exec SQL
     C+ open SDHS
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from SDHS
     C+ into :DlyDS
     C/end-exec
      *
     C                   IF        SQLCODE = 0
      *
      ** CHECK IF OVERFLOW
      *
     C                   IF        *IN50 = '1'
     C                   ADD       1             PGENUM
     C                   WRITE     SD001110H1
     C                   EVAL      *IN50 = '0'
     C                   ENDIF
      *
      *
     C                   EVAL      ZDayNo = DintStart
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDayNo
     C                   PARM                    BJDFIN
     C                   PARM      *Zero         ZDate
     C                   PARM      *BLanks       ZADate
      *
     C                   EVAL      P1STDT = ZADate
      *
     C                   EVAL      ZDayNo = DintEnd
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDayNo
     C                   PARM                    BJDFIN
     C                   PARM      *Zero         ZDate
     C                   PARM      *BLanks       ZADate
      *
     C                   EVAL      P1ENDT = ZADate
      *
     C                   WRITE     SD001110D2
     C                   WRITE     SD001110H3
      *
     C                   DOW       SQLCOD <> 100
      *
      ** CHECK IF OVERFLOW
      *
     C                   IF        *IN50 = '1'
     C                   ADD       1             PGENUM
     C                   WRITE     SD001110H1
     C                   EVAL      *IN50 = '0'
     C                   ENDIF
      *
     C                   EVAL      ZDayNo = Dintd
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDayNo
     C                   PARM                    BJDFIN
     C                   PARM      *Zero         ZDate
     C                   PARM      *BLanks       ZADate
      *
     C                   EVAL      P1INDT = ZADate
     C                   EVAL      P1INDY = Dindy
      *
     C                   EVAL      ZDayNo = Dobdt
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDayNo
     C                   PARM                    BJDFIN
     C                   PARM      *Zero         ZDate
     C                   PARM      *BLanks       ZADate
      *
     C                   EVAL      P1OBDT = ZADate
     C                   EVAL      P1OBDY = Dobdy
     C                   EVAL      P1PRFR = Dbrfr
     C                   EVAL      P1RTAP = Drtap
     C                   EVAL      P1AVCM = Davcr
     C                   WRITE     SD001110D3
      *
     C/exec SQL
     C+ fetch next
     C+ from SDHS
     C+ into :DlyDS
     C/end-exec
      *
     C                   ENDDO
      *
     C                   ENDIF
     C/exec SQL
     C+ close SDHS
     C/end-exec
      *
     C                   EVAL      P1INDT = *Blanks
     C                   EVAL      P1INDY = 0
     C                   EVAL      P1OBDT = *Blanks
     C                   EVAL      P1OBDY = 0
     C                   EVAL      P1PRFR = 0
     C                   EVAL      P1RTAP = 0
     C                   EVAL      P1AVCM = 0
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: AOBANKR0                                               *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
     C                   EVAL      pOption = '*FIRST'
     C                   CALLP     RetrieveBANK(pReturnCode: pOption: pDSSDY)
     C                   EVAL      SDBANK = pDSSDY
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
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2020
