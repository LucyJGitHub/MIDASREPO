     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2021')
      *****************************************************************
/*STD *  RPGSQLMOD                                                    *
/*EXI *  TEXT('Midas SD Daily Rate Calculation Report - FRA/IRS')     *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD001110P3 - Midas SD Daily Rate Calculation Report          *
      *               (IRS)                                           *
      *                                                               *
      *  (c) Finastra International Limited 2021                      *
      *                                                               *
      *  Last Amend No. MD059624           Date 20Jul22               *
      *  Prev Amend No. MD059169           Date 03Nov21               *
      *                 CIR020  *CREATE    Date 02Aug21               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD059624 - CCR Rounding parameters for NCCR calculation CC8  *
      *  MD059169 - Spread Indicator is missing on Daily Rate         *
      *             Calculation Report SD001110P3                     *
      *  CIR020 - LIBOR Deregulation - IRS                            *
      *                                                               *
      *****************************************************************

     FSD001110P3O    E             PRINTER OFLIND(*IN50)
     F                                     INFDS(SPOOL1)
      ** Midas SD Compounding Rate History Details Report

     FDEALS     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(DEALSDAF:DEALSDBF:DEALSDCF)
     F                                     IGNORE(DEALSDDF:DEALSDEF:DEALSDFF)
      ** Deals Details

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
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External DS for currency details
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for Access Programs, Long Data Structure

      ** Data Structure for Backward-Looking Rate Loans
     D TransBLRT     E DS                  EXTNAME(SDBJEXPD)

     D SPOOL1          DS
     D  OFLINE               188    189B 0
     D  PRTLNE               367    368B 0

     D pDSSDY          S            200A

      ** Parameters for ZDATE2
     D ZDayNo          S              5P 0
     D ZDate           S              6P 0
     D ZADate          S              7A
      ** Parameters for ZSEDIT
     D PRTCD           S              7
     D POPTN           S              7
     D ZFLD15          S             15  0
     D ZDECS           S              1  0
     D ZECODE          S              1
     D ZOUT21          S             21
     D  ARR            DS            14

      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  ErrorOnFl             35     35
     D  EndOfFile             45     45

      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))
     D CFLR            C                   CONST(9999.9999999)

      ** +--------------------------------------+
      ** ¦ Variable declaration                 ¦
      ** ¦ ====================                 ¦
      ** +--------------------------------------+
     D pReturnCode     S              7A
     D pOption         S              7A

     D dealExists      S              1A
     D DIFLNE          S              3  0
     D RQDLNE          S              3  0

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
     D Dcalm                          4a
     D Davcr                         17p12
     D Dcmrt                         17p12
     D Dsmav                         17p12

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
     C     *LOVAL        SETLL     DEALS
     C                   READ      DEALS                                3545
      *
      ** Database error
      *
     C                   IF        ErrorOnFl = True
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = '*FIRST'
     C                   EVAL      DBFile = 'DEALS'
     C                   EVAL      DBase = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Start loop
      *
     C                   DOW       EndOfFile = False
      *
      ** Check if deal exists on Backward-Looking Rate Extract File
      *
     C                   EVAL      dealExists = 'N'
      * For OURS leg
     C/exec SQL
     C+ select * into :transBLRT
     C+ from SDBJEXPD
     C+ where
     C+    (TRMODI = 'RU')
     C+ and TRTRAN = digits(:DLNO)
     C/end-exec
     C                   IF        SQLCODE <> 0 and SQLCODE <> 100
     C                   EVAL      DBFILE = 'SDBJEXPD'
     C                   EVAL      DBKEY  = 'SQL ERROR'
     C                   EVAL      DBASE  = 003
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        SQLCODE = 0
     C                   EVAL      dealExists = 'Y'
     C                   ENDIF
      *
      ** Process Report Lines
      *
     C                   IF        DealExists = 'Y'
     C                   EXSR      SRPrint
     C                   ENDIF
      *
     C                   EVAL      dealExists = 'N'
      ** for THEIRS leg
      *
     C/exec SQL
     C+ select * into :transBLRT
     C+ from SDBJEXPD
     C+ where
     C+    (TRMODI = 'RT')
     C+ and TRTRAN = digits(:DLNO)
     C/end-exec
     C                   IF        SQLCODE <> 0 and SQLCODE <> 100
     C                   EVAL      DBFILE = 'SDBJEXPD'
     C                   EVAL      DBKEY  = 'SQL ERROR'
     C                   EVAL      DBASE  = 003
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        SQLCODE = 0
     C                   EVAL      dealExists = 'Y'
     C                   ENDIF
      *
      ** Process Report Lines
      *
     C                   IF        DealExists = 'Y'
     C                   EXSR      SRPrint
     C                   ENDIF

      *
      ** Read next record
      *
     C                   READ      DEALS                                3545
      *
     C                   IF        ErrorOnFl = True
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = '*NEXT'
     C                   EVAL      DBFile = 'DEALS'
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
      * Deal Details
     C                   IF        TRMODI = 'RU'
     C                   MOVEL     'OURS  '      P1CMID
     C                   ELSE
     C                   MOVEL     'THEIRS'      P1CMID
     C                   ENDIF
      *
     C                   MOVEL     DLNO          P1LNRF
      *
     C                   EVAL      ZDayNo = VDAT
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDayNo
     C                   PARM                    BJDFIN
     C                   PARM      *Zero         ZDate
     C                   PARM      *BLanks       ZADate
      *
     C                   EVAL      P1VLDT = ZADate
      *
     C                   EVAL      ZDayNo = MDAT
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDayNo
     C                   PARM                    BJDFIN
     C                   PARM      *Zero         ZDate
     C                   PARM      *BLanks       ZADate
      *
     C                   EVAL      P1MTDT = ZADate
      *
     C                   IF        TRMODI  = 'RU'
     C                   EVAL      P1CCY  = UCUCY
     C                   ELSE
     C                   EVAL      P1CCY  = TCUCY
     C                   ENDIF
      *
     C                   EVAL      P1BRAT = TRBRTT

      ** Format amount

     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    TRCCY
     C     SDCURR        PARM      SDCURR        DSSDY

      *
     C                   IF        TRMODI  = 'RU'
     C                   EVAL      ZFLD15 = UPAMT
     C                   ELSE
     C                   EVAL      ZFLD15 = TPAMT
     C                   ENDIF
      *
     C                   EVAL      ZDECS = A6NBDP

     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM                    ZDECS
     C                   PARM      'J'           ZECODE
     C                   PARM                    ZOUT21

     C                   EVAL      P1CUPR  = ZOUT21

      *
     C                   IF        TRMODI  = 'RU'
     C                   EVAL      P1RTSP = URTSP
     C                   EVAL      P1SPRD = USPIN                                           MD059169
     C                   ELSE
     C                   EVAL      P1RTSP = TRTSP
     C                   EVAL      P1SPRD = TSPIN                                           MD059169
     C                   ENDIF
      *
     C**********         EVAL      P1SPRD = *BLANKS                                         MD059169
      *
     C                   EVAL      P1BADJ = TRBADJ
     C                   EVAL      P1RFRT = TRRFRR
     C                   EVAL      P1LKBD = TRLBDY
     C                   EVAL      P1LOUT = TRLODY
     C                   EVAL      P1RTRO = TRRRDP
     C                   EVAL      P1DBFA = TRDBAV
      *
     C     TRDBAV        IFEQ      0
     C                   EVAL      P1AVDS = 'Zero'
     C                   ENDIF
     C     TRDBAV        IFEQ      1
     C                   EVAL      P1AVDS = 'Actual/365'
     C                   ENDIF
     C     TRDBAV        IFEQ      2
     C                   EVAL      P1AVDS = 'Actual/360'
     C                   ENDIF
     C     TRDBAV        IFEQ      6
     C                   EVAL      P1AVDS = 'Actual/Actual'
     C                   ENDIF
      *
     C                   EVAL      P1OBSP = TROPSH
      *
     C                   IF        TRMODI  = 'RU'
     C                   EVAL      P1RAKI = URTKN
     C                   ELSE
     C                   EVAL      P1RAKI = TRTKN
     C                   ENDIF
     C                   IF        TRFLOR = CFLR
     C                   EVAL      P1FLOR = *BLANKS
     C                   ELSE
     C                   MOVE      TRFLOR        ARR
     C                   MOVE      ARR           ZFLD15
     C                   EVAL      ZDECS = 7

     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM                    ZDECS
     C                   PARM      'L'           ZECODE
     C                   PARM                    ZOUT21
     C                   MOVE      ZOUT21        P1FLOR
     C                   ENDIF
     C                   MOVEL     TRMODI        MODI              2

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
     C+ , CCALCM
     C+ , CAVCRT
     C+ , CDCMRT
     C+ , CSMPAV
     C+ from SDHSDRTD
     C+ where
     C+     CMODID = :MODI
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
     C                   EVAL      P1CALM = Dcalm
      *
     C                   IF        TRMODI  = 'RU'
     C                   EVAL      P1INFR = UICFR
     C                   ELSE
     C                   EVAL      P1INFR = TICFR
     C                   ENDIF
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
      ** Check that sufficient lines remain for the format
      *
     C                   EVAL      RQDLNE = 22
      *
     C                   EVAL      DIFLNE = OFLINE - PRTLNE
     C                   IF        DIFLNE <= RQDLNE
     C                   ADD       1             PGENUM                                     MD059624
     C                   WRITE     SD001110H1                                               MD059624
     C                   EVAL      *IN50 = '0'                                              MD059624
     C                   ENDIF
      *
     C                   EVAL      isRndApplies = 'Y'                                       MD059624
     C                   IF        TRCALM = 'NCCR'                                          MD059624
     C                   CALL      'ZAGETRDAPL'                                             MD059624
     C                   PARM                    TRRFRR                                     MD059624
     C                   PARM                    isRndApplies      1                        MD059624
     C                   ENDIF                                                              MD059624
     C                   IF        isRndApplies = 'N'                                       MD059624
     C                   EVAL      P1RAPL= 'Yes'                                            MD059624
     C                   EVAL      P1ROPR = TRRRDP                                          MD059624
     C                   EVAL      P1RTRO = 0                                               MD059624
     C                   ELSE                                                               MD059624
     C                   EVAL      P1RAPL= 'No'                                             MD059624
     C                   EVAL      P1ROPR = 0                                               MD059624
     C                   EVAL      P1RTRO = TRRRDP                                          MD059624
     C                   ENDIF                                                              MD059624
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
     C                   SELECT
     C                   WHEN      Dcalm = 'CCR'
     C                   EVAL      P1AVCM = Davcr
     C                   WHEN      Dcalm = 'NCCR'
     C                   EVAL      P1AVCM = Dcmrt
     C                   WHEN      Dcalm = 'SAVG'
     C                   EVAL      P1AVCM = Dsmav
     C                   WHEN      Dcalm = 'SARR'
     C                   EVAL      P1AVCM = Drtap
     C                   ENDSL
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
(c) Finastra International Limited 2021
