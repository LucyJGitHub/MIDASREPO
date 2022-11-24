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
      *  Last Amend No. MD058517           Date 17Oct22               *
      *  Prev Amend No. MD059624           Date 20Jul22               *
      *                 MD059190           Date 08Nov21               *
      *                 MD059137           Date 29Oct21               *
      *                 MD058103           Date 19May21               *
      *                 CLE172             Date 01Oct20               *
      *                 CSD103  *CREATE    Date 10Aug20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058517 - CLE172 LIBOR Lending- Change Control CC3.1        *
      *             Interest Projection Using Known Rates             *
      *             CC10 CLE172 Spool File Correspondence (MD059817)  *
      *  MD059624 - CCR Rounding parameters for NCCR calculation CC8  *
      *  MD059190 - Use rollover ARR parameters if loan exists in     *
      *             RO extract file and rollover is authorised.       *
      *  MD059137 - Include in the report loans with interest due date*
      *             and rollover date on rundate that changed flag    *
      *             from forward to backward looking rate.            *
      *           - output end date based on the latest interest date *
      *  MD058103 - ARR Daily Rates History content for NCCR SARR     *
      *             and SAVG are not correct                          *
      *  CLE172 - LIBOR Deregulation - Lending                        *
      *  CSD103 - LIBOR Deregulation - Common Layer Standing Data     *
      *                                                               *
      *****************************************************************

     FSD001110P1O    E             PRINTER OFLIND(*IN50)
     F                                     INFDS(SPOOL1)                                    MD059624
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
     D SDCURR        E DS                  EXTNAME(SDCURRPD)                                MD058103
      ** External DS for currency details                                                   MD058103
     D DSSDY         E DS                  EXTNAME(DSSDY)                                   MD058103
      ** Second DS for Access Programs, Long Data Structure                                 MD058103

     D pDSSDY          S            200A

      ** Parameters for ZDATE2
     D ZDayNo          S              5P 0
     D ZDate           S              6P 0
     D ZADate          S              7A
      ** Parameters for ZSEDIT                                                              MD058103
     D PRTCD           S              7                                                     MD058103
     D POPTN           S              7                                                     MD058103
     D ZFLD15          S             15  0                                                  MD058103
     D ZDECS           S              1  0                                                  MD058103
     D ZECODE          S              1                                                     MD058103
     D ZOUT21          S             21                                                     MD058103
     D  ARR            DS            14                                                     MD058103
                                                                                            MD058103
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  ErrorOnFl             35     35
     D  EndOfFile             45     45

      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))
     D CFLR            C                   CONST(9999.9999999)                              MD058103

      ** +--------------------------------------+
      ** ¦ Variable declaration                 ¦
      ** ¦ ====================                 ¦
      ** +--------------------------------------+
     D pReturnCode     S              7A
     D pOption         S              7A
     D WrkRollChk      S              1A                                                    MD059137
     D NoOfRecs        S              3S 0                                                  MD059137
     D WrkEDATE        S              5P 0                                                  MD059137
     D DIFLNE          S              3  0                                                  MD059624
     D RQDLNE          S              3  0                                                  MD059624
                                                                                            MD059624
     D SPOOL1          DS                                                                   MD059624
     D  OFLINE               188    189B 0                                                  MD059624
     D  PRTLNE               367    368B 0                                                  MD059624

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
     D Dcalm                          4a                                                    MD058103
     D Davcr                         17p12
     D Dcmrt                         17p12                                                  MD058103
     D Dsmav                         17p12                                                  MD058103

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
      *                                                                                     MD059137
     C                   EXSR      SRRollChk                                                MD059137
      *
      ** Process Report Lines
      *
     C     BLRT          IFEQ      'Y'
     C     RECI          ANDEQ     'D'                                                      MD058103
     C     WrkRollChk    OREQ      'Y'                                                      MD059137
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
     C**********         EVAL      P1INFR = IPFR                                            MD058103
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
     C**********         EVAL      P1CUPR = CPAM                                            MD058103
      ** Format amount                                                                      MD058103
                                                                                            MD058103
     C                   CALL      'AOCURRR0'                                               MD058103
     C                   PARM      *BLANKS       PRTCD                                      MD058103
     C                   PARM      '*KEY   '     POPTN                                      MD058103
     C                   PARM                    CCY                                        MD058103
     C     SDCURR        PARM      SDCURR        DSSDY                                      MD058103
                                                                                            MD058103
     C                   EVAL      ZFLD15 = CPAM                                            MD058103
     C                   EVAL      ZDECS = A6NBDP                                           MD058103
                                                                                            MD058103
     C                   CALLB     'ZSEDIT'                                                 MD058103
     C                   PARM                    ZFLD15                                     MD058103
     C                   PARM                    ZDECS                                      MD058103
     C                   PARM      'J'           ZECODE                                     MD058103
     C                   PARM                    ZOUT21                                     MD058103
                                                                                            MD058103
     C                   EVAL      P1CUPR  = ZOUT21                                         MD058103

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
     C**********         EVAL      P1FLOR = FLOR                                            MD058103
     C                   IF        FLOR = CFLR                                              MD058103
     C                   EVAL      P1FLOR = *BLANKS                                         MD058103
     C                   ELSE                                                               MD058103
     C                   MOVE      FLOR          ARR                                        MD058103
     C                   MOVE      ARR           ZFLD15                                     MD058103
     C                   EVAL      ZDECS = 7                                                MD058103
                                                                                            MD058103
     C                   CALLB     'ZSEDIT'                                                 MD058103
     C                   PARM                    ZFLD15                                     MD058103
     C                   PARM                    ZDECS                                      MD058103
     C                   PARM      'L'           ZECODE                                     MD058103
     C                   PARM                    ZOUT21                                     MD058103
     C                   MOVE      ZOUT21        P1FLOR                                     MD058103
     C                   ENDIF                                                              MD058103
      *                                                                                     MD059137
     C                   EVAL      WrkEDATE = 0                                             MD059137
     C/exec SQL                                                                             MD059137
     C+ select CINPED into :WrkEDATE                                                        MD059137
     C+ from SDHSDRTD                                                                       MD059137
     C+ where                                                                               MD059137
     C+     CMODID = 'LE'                                                                   MD059137
     C+ and CTRNID = :P1LNRF                                                                MD059137
     C+ and CINFLG = 'Y'                                                                    MD059137
     C+ order by                                                                            MD059137
     C+     CINPDT desc                                                                     MD059137
     C+ fetch first row only                                                                MD059137
     C/end-exec                                                                             MD059137
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
     C+ , CCALCM                                                                            MD058103
     C+ , CAVCRT                                                                            MD058103
     C+ , CDCMRT                                                                            MD058103
     C+ , CSMPAV                                                                            MD058103
     C+ from SDHSDRTD
     C+ where
     C+     CMODID = 'LE'
     C+ and CTRNID = :P1LNRF
     C+ and CINFLG >= 'Y'
     C***order by                                                                           MD058517
     C******CINPDT asc                                                                      MD058517
     C+ union all                                                                           MD058517
     C+ select                                                                              MD058517
     C+   FINPSD                                                                            MD058517
     C+ , FINPED                                                                            MD058517
     C+ , FINPDT AS CINPDT                                                                  MD058517
     C+ , FINPDY                                                                            MD058517
     C+ , FOBPDT                                                                            MD058517
     C+ , FOBPDY                                                                            MD058517
     C+ , FPBRFR                                                                            MD058517
     C+ , FRTEAP                                                                            MD058517
     C+ , FCALCM                                                                            MD058517
     C+ , FAVCRT                                                                            MD058517
     C+ , FDCMRT                                                                            MD058517
     C+ , FSMPAV                                                                            MD058517
     C+ from SDFWDRTD T2                                                                    MD058517
     C+ where                                                                               MD058517
     C+ not exists (                                                                        MD058517
     C+ select * from SDHSDRTD T1                                                           MD058517
     C+ where T1.CINPDT = T2.FINPDT )                                                       MD058517
     C+ and FMODID = 'LE'                                                                   MD058517
     C+ and FTRNID = :P1LNRF                                                                MD058517
     C+ and FINFLG >= 'Y'                                                                   MD058517
     C+ order by                                                                            MD058517
     C+     CINPDT asc                                                                      MD058517
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
     C                   EVAL      P1CALM = Dcalm                                           MD058103
     C                   EVAL      P1INFR = IPFR                                            MD058103
      *
     C                   IF        DintEnd = WrkEDATE                                       MD059137
     C                   EVAL      ZDayNo = DintEnd
     C                   ELSE                                                               MD059137
     C                   EVAL      ZDayNo = WrkEDATE                                        MD059137
     C                   ENDIF                                                              MD059137
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDayNo
     C                   PARM                    BJDFIN
     C                   PARM      *Zero         ZDate
     C                   PARM      *BLanks       ZADate
      *
     C                   EVAL      P1ENDT = ZADate
      *
      ** Check that sufficient lines remain for the format                                  MD059624
      *                                                                                     MD059624
     C                   EVAL      RQDLNE = 22                                              MD059624
      *                                                                                     MD059624
     C                   EVAL      DIFLNE = OFLINE - PRTLNE                                 MD059624
     C                   IF        DIFLNE <= RQDLNE                                         MD059624
     C                   ADD       1             PGENUM                                     MD059624
     C                   WRITE     SD001110H1                                               MD059624
     C                   EVAL      *IN50 = '0'                                              MD059624
     C                   ENDIF                                                              MD059624
     C                   EVAL      isRndApplies = 'N'                                       MD059624
     C                   IF        CALM = 'NCCR'                                            MD059624
     C                   CALL      'ZAGETRDAPL'                                             MD059624
     C                   PARM                    RFRR                                       MD059624
     C                   PARM                    isRndApplies      1                        MD059624
     C                   ENDIF                                                              MD059624
     C                   IF        isRndApplies = 'Y'                                       MD059624
     C                   EVAL      P1RAPL= 'Y'                                              MD059624
     C                   EVAL      P1ROPR = RRDP                                            MD059624
     C                   EVAL      P1RTRO = 0                                               MD059624
     C                   ELSE                                                               MD059624
     C                   EVAL      P1RAPL= 'N'                                              MD059624
     C                   EVAL      P1ROPR = 0                                               MD059624
     C                   EVAL      P1RTRO = RRDP                                            MD059624
     C                   ENDIF                                                              MD059624
      *                                                                                     MD059624
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
     C                   SELECT                                                             MD058103
     C                   WHEN      Dcalm = 'CCR'                                            MD058103
     C                   EVAL      P1AVCM = Davcr                                           MD058103
     C                   WHEN      Dcalm = 'NCCR'                                           MD058103
     C                   EVAL      P1AVCM = Dcmrt                                           MD058103
     C                   WHEN      Dcalm = 'SAVG'                                           MD058103
     C                   EVAL      P1AVCM = Dsmav                                           MD058103
     C                   WHEN      Dcalm = 'SARR'                                           MD058103
     C                   EVAL      P1AVCM = Drtap                                           MD058103
     C                   ENDSL                                                              MD058103
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
      *****************************************************************                     MD059137
      /EJECT                                                                                MD059137
      *****************************************************************                     MD059137
      *                                                               *                     MD059137
      * SRRollChk - Check if loan exists on LEROBLPD                  *                     MD059137
      *                                                               *                     MD059137
      * Called by: Main processing                                    *                     MD059137
      *                                                               *                     MD059137
      * Calls: None                                                   *                     MD059137
      *                                                               *                     MD059137
      *****************************************************************                     MD059137
     C     SRRollChk     BEGSR                                                              MD059137
     C                   EVAL      WrkRollChk = 'N'                                         MD059137
     C                   IF        (RLDT > 0 AND BLRT = 'N' AND NBLRT = 'Y')                MD059137
     C                             OR (RLDT > 0 AND RLDT < BJDNWD                           MD059190
     C                                 AND BLRT = 'Y' AND NBLRT = 'Y')                      MD059190
     C/exec SQL                                                                             MD059137
     C+ select count(*) into :NoOfRecs                                                      MD059137
     C+ from LEROBLPD                                                                       MD059137
     C+ where ROLNRF = :LNRF                                                                MD059137
     C+ and :LNRF not in (select * from LEWIPROLL)                                          MD059190
     C/end-exec                                                                             MD059137
     C                   IF        NoOfRecs <> 0                                            MD059137
     C                   EVAL      WrkRollChk = 'Y'                                         MD059137
     C                   EVAL      RFRR = NRFRR                                             MD059137
     C                   EVAL      CALM = NCALM                                             MD059137
     C                   EVAL      BADJ = NBADJ                                             MD059137
     C                   EVAL      FLOR = NFLOR                                             MD059137
     C                   EVAL      LBDY = NLBDY                                             MD059137
     C                   EVAL      LODY = NLODY                                             MD059137
     C                   EVAL      OPSH = NOPSH                                             MD059137
     C                   EVAL      RRDP = NRRDP                                             MD059137
     C                   EVAL      DBAV = NDBAV                                             MD059137
     C                   EVAL      RTKN = 'N'                                               MD059137
     C                   EVAL      BRTT = NBRA                                              MD059137
     C                   EVAL      RTSP = NRTS                                              MD059190
     C                   EVAL      SPIN = NSIN                                              MD059190
     C                   ENDIF                                                              MD059137
     C                   ENDIF                                                              MD059137
     C                   EVAL      NoOfRecs = 0                                             MD059137
     C                   ENDSR                                                              MD059137
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
