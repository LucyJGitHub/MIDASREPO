     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/*S*D****RPGBASE*******************************************************                       LUC109
/*STD *  RPGBASEBND                                                   *                       LUC109
/*EXI *  TEXT('FEINT - FEPRI - FETAS EXTRACT')                        *                       LUC109
      *****************************************************************
      *                                                               *
      *  Midas - Interface to Head Office Reporting                   *
      *                                                               *
      ***GLM048**-*FEINT*-*FEPRI*-*FETAS*EXTRACT***********************                       LUC109
      *  XX000048 - FEINT - FEPRI - FETAS EXTRACT                     *                       LUC109
      *                                                               *                       LUC109
  ?   *****************************************************************
  ?   * *** THIS PROGRAM MUST BE COMPILED WITH XXINTFLIB AT THE TOP   *
  ?   * OF LIBL ***                                                   *
  ?   *****************************************************************
      *                                                               *
      *  Function: to extract the following events, for all deals     *
      *            and loans extracted on FECCD and FEDER:            *
      *            Interest Payments (FEPRI extract);                 *
      *            Principal Changes (FEPRI extract);                 *
      *            Interest Rate Changes (FETAS extract).             *
      *                                                               *
      ***CALLED*BY**GLCM048*-*GL*INT/PRI/TAS*Extract*******************                       LUC109
      *  CALLED BY GLC000048 - GL INT/PRI/TAS Extract                 *                       LUC109
      *             Frequency: Automatically in Close of Business     *
      *                                                               *
      ***(C)*COPYRIGHT*Misys*2004**************************************                       LUC109
      *  (c) Finastra International Limited 2016                      *                       LUC109
      *                                                               *
      *  Last Amend No. LUC109             Date 20Sep16               *
      *  Prev Amend No. MD024836           Date 07Feb14               *
      *                 LUC013             Date 15May08               *
      *                 237990             Date 01Dec04               *
      *                 230946             Date 01Dec04               *
      *                 230190             Date 20Oct04               *
      *                 228619             Date 09Aug04               *
      *                 MUI011   *Create   Date 07May04               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  LUC109 - HO Reporting (Upgrade to FB Midas 2.1)              *
      *  MD024736 - Loans with no Rollover Date are not being         *
      *             extracted.                                        *
      *  LUC013 - Head Office Reporting Upgrade to MidasPlus          *
      *  237990 - Interest Payments not extracted when are part of a  *
      *           Manual Repayment.                                   *
      *  230946 - Output Principal Changes to a work file (WKFEPRI)   *
      *           so that they can be reformatted by GLM049. This     *
      *           will allow the netting of participations sold.      *
      *         - Include Principal Transfers in FEPRI extarct.       *
      *         - Fixing Date on FETAS to be calculated based on      *
      *           rate fixing days, ignoring values read on input     *
      *           files.                                              *
      *  230190 - FEPRI records not created for amortising IRS.       *
      *  228619 - Bank ICD record not read, causing blank fields on   *
      *           extract file headers.                               *
      *  MUI011 - ALMS changes to HOR                                 *
      *                                                               *
      *****************************************************************
      *
     FFECCDDV1  IF   E           K DISK
     FDEALGBR   IF   E           K DISK
     FDLMPEVV0  IF   E           K DISK
     FDLMFEVV0  IF   E           K DISK
     FDLPCSCL0  IF   E           K DISK
     FDLEVNPL2  IF   E           K DISK
     FDEAMSD    IF   E           K DISK
     FCLOANCV0  IF   E           K DISK
     FHISTR     IF   E           K DISK
     FMHISR     IF   E           K DISK
     F                                     RENAME(HISTSHMF:MHISMF)
     F                                     RENAME(HISTSHPF:MHISPF)
     F                                     RENAME(HISTSHQF:MHISQF)
     FLELOAML3  IF   E           K DISK
     FSVNTS     IF   E           K DISK
     FSDBANKPD  IF   E             DISK
     FSDINTFV0  IF   E             DISK
     FSDGELRPP  IF   E             DISK
     FSDBRCHV0  IF   E           K DISK
     FFECCDDV0  IF   E           K DISK                                         230946
     F                                     RENAME(FECCDDP0:FECCV0)              230946
     FFEINT     O    E             DISK
     F****FEPRI   O   E                    DISK                           230946
     FWKFEPRI   O    E             DISK                                         230946
     FFETAS     O    E             DISK
      ** Header Record
      *
     D R00000        E DS
      *
      ** Detail Record - FEINT
      *
     D DETINT          DS
     D  F1PROG                 1      3  0
     D  F1COMP                 4      6
     D  F1BRCD                 7      9
     D  F1MODL                10     12
     D  F1DLNO                13     27
     D  F1FILE                28     32
     D  F1OUTH                33     33
     D  F1IPFR                34     34
     D  F1EDAT                35     42
     D  F1EAMT                43     61
     D  F1FILL                62     78
      *********                                                           230946
      ***Detail Record - FEPRI                                            230946
      *********                                                           230946
     D**DETPRI*** DS                                                      230946
     D*********                               1   30F2PROG                230946
     D*********                               4   6 F2COMP                230946
     D*********                               7   9 F2BRCD                230946
     D*********                              10  12 F2MODL                230946
     D*********                              13  27 F2DLNO                230946
     D*********                              28  32 F2FILE                230946
     D*********                              33  33 F2RPFR                230946
     D*********                              34  41 F2EDAT                230946
     D*********                              42  60 F2EAMT                230946
     D*********                              61  61 F2OUTH                230946
     D*********                              62  78 F2FILL                230946
      *
      ** Detail Record - FETAS
      *
     D DETTAS          DS
     D  F3PROG                 1      3  0
     D  F3COMP                 4      6
     D  F3BRCD                 7      9
     D  F3MODL                10     12
     D  F3DLNO                13     27
     D  F3FILE                28     32
     D  F3OUTH                33     33
     D  F3BRTT                34     35
     D  F3EDAT                36     43
     D  F3FRFD                44     45
     D  F3INFD                46     53
     D  F3ICFR                54     54
     D  F3RTSP                55     63
     D  F3INTR                64     76
     D  F3FILL                77     78
      *
     D                 DS
     D  ETYP                   1      4
     D  EVCD                   3      4
      *
     D***/C*PY*ZSRSRC,ZAOZ1                                                                   LUC109
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     LUC109
     D***/C*PY*ZSRSRC,ZAOZ2                                                                   LUC109
     D SDGELR        E DS                  EXTNAME(SDGELRPD)                                  LUC109
     D***/C*PY*ZSRSRC,ZHOLI                                                                   LUC109
     D/COPY ZSRSRC,ZHOLILE                                                                    LUC109
     D*
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
     I***/C*PY*ZSRSRC,ZFREQBZ1                                                                LUC109
     D ZFMD            S              2    DIM(12) CTDATA PERRCD(12)                          LUC109
     I***/C*PY*ZSRSRC,ZHOLE                                                                   LUC109
     D/COPY ZSRSRC,ZHOLELE                                                                    LUC109
     I***/C*PY*ZSRSRC,ZDATE2Z1                                                                LUC109
     D/COPY ZSRSRC,ZDATE2Z1LE                                                                 LUC109
      *
     IDEAMSDIF                                                                                 LUC01
     I              OSAC                        XXOSAC                                         LUC01
     I              RONS                        XXRONS                                         LUC01
     I              PONS                        XXPONS                                         LUC01
     I              CNUM                        XXCNUM                                        LUC109
     I              ROBN                        XXROBN                                        LUC109
     I              ROCN                        XXROCN                                        LUC109
     I              POBN                        XXPOBN                                        LUC109
     I              POCN                        XXPOCN                                        LUC109
     I* SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
      *
      **********************************************************************
      *
      * M A I N   L I N E
      *
      **********************************************************************
      *
     C     *INLR         IFNE      *ON
      *
      * Write header records
      *
     C                   EXSR      S00000
      *
      * Process all branches
      *
     C                   EXSR      SBRCH
      *
      * Write footer records
      *
     C                   EXSR      S99000
      *
     C                   ENDIF
      *
     C                   MOVE      *ON           *INLR
      *
      *****************************************************************
      *                                                               *
      *  SBRCH  -  Process all branches                               *
      *                                                               *
      *  Called By: Main line                                         *
      *  Calls: S02000                                                *
      *         SRDEAL                                                *
      *         SRLOAN                                                *
      *         S09000                                                *
      *                                                               *
      *****************************************************************
      *
     C     SBRCH         BEGSR
      *
     C     *LOVAL        SETLL     SDBRCHD0
     C                   READ      SDBRCHD0                               01
      *
     C     *IN01         DOWEQ     *OFF
      *
      * Branch Initial Records
      *
     C                   EXSR      S02000
      *
      * Process CCD extract
      *
     C                   MOVE      'FECCD'       C9869             5
     C                   MOVE      ' '           C9872             1
      *
     C     A8BRCD        SETLL     FECCDDP0
     C     A8BRCD        READE     FECCDDP0                               02
      *
     C     *IN02         DOWEQ     *OFF
      *
     C                   MOVE      C0150         $$CCY
      *
      * Money Market Deal (Loan/Deposit or Negotiable Asset Purchased)
      *
     C     C9149         IFEQ      'MM'
     C                   MOVE      'C'           RCDT
     C                   EXSR      SRDEAL
     C                   ENDIF
      *
     C     C9149         IFEQ      'NA'
     C                   MOVE      'D'           RCDT
     C                   EXSR      SRDEAL
     C                   ENDIF
      *
      * Loan
      *
     C     C9149         IFEQ      'LE'
     C                   EXSR      SRLOAN
     C                   ENDIF
      *
     C     A8BRCD        READE     FECCDDP0                               02
      *
     C                   ENDDO
      *
      * Process DER extract
      *
     C                   MOVE      A8CMCD        C9003
     C                   MOVE      A8BRCD        C0120
     C                   MOVEL     'DL'          C9149
     C                   MOVE      'FEDER'       C9869
      *
     C     A8BRCD        SETLL     DEALGBR
     C     A8BRCD        READE     DEALGBR                                03
      *
     C     *IN03         DOWEQ     *OFF
      *
     C                   MOVEL(P)  DLNO          C9150
      *
      * Ours
      *
     C                   MOVE      'U'           RCDT
     C                   MOVE      'O'           C9872
     C                   MOVE      UCUCY         $$CCY
     C                   EXSR      SRDEAL
      *
      * Theirs
      *
     C                   MOVE      'T'           RCDT
     C                   MOVE      'T'           C9872
     C                   MOVE      TCUCY         $$CCY
     C                   EXSR      SRDEAL
      *
     C     A8BRCD        READE     DEALGBR                                03
     C                   ENDDO
      *
      * Branch Final Records
      *
     C                   EXSR      S09000
      *
     C                   READ      SDBRCHD0                               01
      *
     C                   ENDDO
      *                                                                   230946
      * Output principal changes for participations sold. These           230946
      * records will be used by GLM049 to reduce the amounts of           230946
      * the original loans.                                               230946
      *                                                                   230946
     C     KFECCD        KLIST                                                                 23094
     C                   KFLD                    C9150                                         23094
     C                   KFLD                    C9149                                         23094
      *                                                                   230946
     C                   MOVE      'FECCD'       C9869                                         23094
     C                   MOVE      ' '           C9872                                         23094
      *                                                                   230946
     C     *LOVAL        SETLL     CLOANCV0                                                    23094
     C                   READ      CLOANCV0                               14                   23094
      *                                                                   230946
     C     *IN14         DOWEQ     *OFF                                                        23094
      *                                                                   230946
     C     PTYP          IFEQ      66                                                          23094
     C     PTYP          OREQ      67                                                          23094
     C     PTYP          OREQ      69                                                          23094
     C     PTYP          OREQ      72                                                          23094
     C                   MOVE      'LE '         C9149                                         23094
     C                   MOVEL(P)  OLNO          C9150                                         23094
     C     KFECCD        CHAIN     FECCV0                             15                       23094
     C     *IN15         IFEQ      *OFF                                                        23094
     C                   MOVE      C0150         $$CCY                                         23094
     C                   EXSR      SRPSOL                                                      23094
     C                   ENDIF                                                                 23094
     C                   ENDIF                                                                 23094
      *                                                                   230946
     C                   READ      CLOANCV0                               14                   23094
      *                                                                   230946
     C                   ENDDO                                                                 23094
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDEAL -  Write past and future events for one deal to all   *
      *            extract files                                      *
      *                                                               *
      *  Called By: SBRCH                                             *
      *  Calls: OUTINT                                                *
      *         OUTPRI                                                *
      *         OUTTAS                                                *
      *                                                               *
      *****************************************************************
      *
     C     SRDEAL        BEGSR
      *
      * Reset running Principal Amount
      *
     C                   Z-ADD     *ZERO         WRKAMT           15 0
     C                   MOVE      *BLANKS       HRPFR             1
      *
     C     KDLHIS        KLIST
     C                   KFLD                    DLNO
     C                   KFLD                    RCDT
      *
      * Process Dealing History (output by DLM011-12)
      *
     C                   MOVEL     C9150         DLNO
     C     KDLHIS        CHAIN     DLMPEVP0                           04
     C     *IN04         DOWEQ     *OFF
     C     HOUTF         CASEQ     'INT'         OUTINT
     C     HOUTF         CASEQ     'PRI'         OUTPRI
     C     HOUTF         CASEQ     'TAS'         OUTTAS
     C                   ENDCS
     C     KDLHIS        READE     DLMPEVP0                               04
     C                   ENDDO
      *
      * Process IRS Future Rate Changes and Interest Payments
      * (output by DLM013)
      *
     C     RCDT          IFEQ      'U'
     C     RCDT          OREQ      'T'
     C     KDLHIS        CHAIN     DLMFEVP0                           05
     C     *IN05         DOWEQ     *OFF
     C     HOUTF         CASEQ     'INT'         OUTINT
     C     HOUTF         CASEQ     'TAS'         OUTTAS
     C                   ENDCS
     C     KDLHIS        READE     DLMFEVP0                               05
     C                   ENDDO
      *
      * Extract future MM Interest Payments from DL Events file
      *
     C                   ELSE
     C     DLNO          CHAIN     EVNTXEDF                           06
     C     *IN06         DOWEQ     *OFF
      *
     C     IBRE          IFNE      'Y'
     C     EVCD          ANDEQ     'I3'
     C                   Z-ADD     EDAT          HEDAT
     C                   Z-ADD     EAMT          HEAMT
     C                   MOVE      *BLANKS       HIPFR
     C                   EXSR      OUTINT
     C                   ENDIF
      *
     C     DLNO          READE     EVNTXEDF                               06
     C                   ENDDO
      *
      * Extract future MM Principal and Rate Changes from Deal
      * Amendments file
      *
     C     DLNO          CHAIN     DEAMSDIF                           07
     C     *IN07         DOWEQ     *OFF
      *
     C**********           Z-ADDEDAT      HEDAT
     C                   Z-ADD     VDAT          HEDAT                                         23094
      *
     C     AMTP          IFEQ      'PI'
     C                   Z-ADD     DAAM          HEAMT
     C                   EXSR      OUTPRI
     C                   ENDIF
      *
     C     AMTP          IFEQ      'PD'
     C                   Z-SUB     DAAM          HEAMT
     C                   EXSR      OUTPRI
     C                   ENDIF
      *
     C     AMTP          IFEQ      'SC'
     C                   MOVE      BRTT          HBRTT
     C                   Z-ADD     *ZERO         HFRFD
     C**********           Z-ADD*ZERO     HINFD                           230946
     C                   MOVE      *BLANKS       HICFR
     C     RTSP          IFLT      *ZERO
     C                   MOVE      'S'           HSPIN
     C                   Z-SUB     RTSP          HRTSP
     C                   ELSE
     C                   MOVE      'A'           HSPIN
     C                   Z-ADD     RTSP          HRTSP
     C                   ENDIF
     C                   Z-ADD     INTR          HINTR
     C                   EXSR      OUTTAS
     C                   ENDIF
      *
     C     DLNO          READE     DEAMSDIF                               07
     C                   ENDDO
     C                   ENDIF
      *
      * Process IRS Principal Changes (past and future)
      *
     C     RCDT          IFEQ      'U'
     C     RCDT          OREQ      'T'
      *
     C     KDLHIS        CHAIN     DLPCSCL0                           08
     C     *IN08         DOWEQ     *OFF
     C                   Z-ADD     PRDT          HEDAT
     C     PAMT          SUB       WRKAMT        HEAMT
     C                   EXSR      OUTPRI                                                      23019
     C     KDLHIS        READE     DLPCSCL0                               08
     C                   ENDDO
      *                                                                   230190
     C     DLNO          CHAIN     DLPCSCL0                           08                       23019
     C     *IN08         DOWEQ     *OFF                                                        23019
     C                   Z-ADD     PRDT          HEDAT                                         23019
     C     PAMT          SUB       WRKAMT        HEAMT                                         23019
     C                   EXSR      OUTPRI                                                      23019
     C     DLNO          READE     DLPCSCL0                               08                   23019
     C                   ENDDO                                                                 23019
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRLOAN -  Write past and future events for one loan to all   *
      *            extract files                                      *
      *                                                               *
      *  Called By: SBRCH                                             *
      *  Calls: OUTINT                                                *
      *         OUTPRI                                                *
      *         OUTTAS                                                *
      *                                                               *
      *****************************************************************
      *
     C     SRLOAN        BEGSR
      *
      * Reset running Principal Amount
      *
     C                   Z-ADD     *ZERO         WRKAMT           15 0
     C                   MOVE      *BLANKS       HRPFR             1
      *
      * Access Loan details
      *
     C                   MOVEL     C9150         LNRF
     C     LNRF          CHAIN     CLOANCV0                           09
     C                   MOVE      RFRQ          HRPFR
     C                   MOVE      RLFQ          HICFR
      *
     C     KLEHIS        KLIST
     C                   KFLD                    BRCA
     C                   KFLD                    CNUM
     C                   KFLD                    LNRF
      *
      * Process Loan History
      *
     C     KLEHIS        CHAIN     HISTR                              10
     C     *IN10         DOWEQ     *OFF
     C                   EXSR      SRHIST
     C     KLEHIS        READE     HISTR                                  10
     C                   ENDDO
      *
     C     KLEHIS        CHAIN     MHISR                              11
     C     *IN11         DOWEQ     *OFF
     C                   EXSR      SRHIST
     C     KLEHIS        READE     MHISR                                  11
     C                   ENDDO
      *
      * Process Loan Events
      *
     C     LNRF          CHAIN     LVENTELF                           12
     C     *IN12         DOWEQ     *OFF
      *
     C     EAMT          IFNE      *ZERO
     C     EDAT          ANDNE     *ZERO                                                       23094
     C     IBRE          ANDNE     'Y'                                                         23094
      *
     C                   Z-ADD     EDAT          HEDAT
      *
     C     EVCD          IFEQ      'I2'
     C     EVCD          OREQ      'M2'
     C     EVCD          OREQ      'R2'
     C     EVCD          OREQ      'X2'
     C                   MOVE      IPFR          HIPFR
     C                   Z-ADD     EAMT          HEAMT
     C     EDAT          IFGT      RLDT
     C     RLDT          ANDNE     0
     C                   Z-ADD     *ZERO         HEAMT
     C                   ENDIF
     C                   EXSR      OUTINT
     C                   ENDIF
      *
     C     EVCD          IFEQ      'V3'
     C     EVCD          OREQ      'V5'
     C     EVCD          OREQ      'V7'
     C     EVCD          OREQ      'X2'
     C     EVCD          OREQ      'V1'                                                        23094
     C                   Z-ADD     EAMT          HEAMT
     C                   EXSR      OUTPRI
     C                   ENDIF
      *
     C     EVCD          IFEQ      'R1'
     C     EVCD          OREQ      'R7'                                                        23094
     C     EVCD          OREQ      'M1'                                                        23094
     C                   Z-SUB     EAMT          HEAMT
     C                   EXSR      OUTPRI
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     LNRF          READE     LVENTELF                               12
     C                   ENDDO
      *
      * Extract future Rate Changes from Loan Amendments File
      *
     C                   Z-ADD     BRTT          SVBRTT            2 0
     C     LNRF          CHAIN     LOAMSDKF                           13
     C     *IN13         DOWEQ     *OFF
      *
     C     AMTP          IFEQ      'SC'
     C     AMTP          OREQ      'BC'
     C                   Z-ADD     VDAT          HEDAT
     C                   MOVE      BRTT          HBRTT
     C***********          Z-ADD*ZERO     HFRFD                           230946
     C                   MOVE      RFDY          HFRFD                                         23094
     C***********          Z-ADD*ZERO     HINFD                           230946
     C***********BRTT      IFNE *ZERO                                     230946
     C***********          Z-ADDVDAT      HINFD                           230946
     C***********          ENDIF                                          230946
     C     RTSP          IFLT      *ZERO
     C                   MOVE      'S'           HSPIN
     C                   Z-SUB     RTSP          HRTSP
     C                   ELSE
     C                   MOVE      'A'           HSPIN
     C                   Z-ADD     RTSP          HRTSP
     C                   ENDIF
     C                   Z-ADD     INTR          HINTR
     C                   EXSR      OUTTAS
     C                   ENDIF
      *
     C     LNRF          READE     LOAMSDKF                               13
     C                   ENDDO
      *
      * Calculate future rollover dates
      *
     C                   Z-ADD     RLDT          ZDAYNO
      *
     C     NROD          IFNE      *ZERO
     C                   Z-ADD     NROD          ZDAYNO
     C                   ENDIF
      *
     C     ZDAYNO        DOWLT     MDAT
     C     ZDAYNO        ANDNE     *ZERO
      *
     C                   Z-ADD     ZDAYNO        HEDAT
     C                   MOVE      SVBRTT        HBRTT
     C                   MOVE      RFDY          HFRFD
     C**********           Z-ADDZDAYNO    HINFD                           230946
     C********** HFRFD     IFNE *ZERO                                     230946
     C**********           Z-ADDHFRFD     ZNRDYS                          230946
     C**********           EXSR ZBKDT                                     230946
     C**********           Z-ADDHINFD     ZDAYNO                          230946
     C**********           Z-ADDZDYNBR    HINFD                           230946
     C**********           ENDIF                                          230946
     C                   MOVE      'A'           HSPIN
     C                   Z-ADD     *ZERO         HINTR
      *                                                                   230946
     C                   Z-ADD     ZDAYNO        SVZDYN            5 0                         23094
      *
     C                   EXSR      OUTTAS
      *                                                                   230946
     C                   Z-ADD     SVZDYN        ZDAYNO                                        23094
      *
     C     RLFQ          IFNE      *BLANKS
     C                   MOVE      RLFQ          ZFREQ
     C                   Z-ADD     RLDY          ZMDAY
     C                   MOVE      CCY           ZCCY
     C                   EXSR      ZFREQB
     C                   ELSE
     C                   Z-ADD     MDAT          ZDAYNO
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRHIST -  Process each record on Loan History                *
      *                                                               *
      *  Called By: SRLOAN                                            *
      *  Calls: OUTINT                                                *
      *         OUTPRI                                                *
      *         OUTTAS                                                *
      *                                                               *
      *****************************************************************
      *
     C     SRHIST        BEGSR
      *
     C                   Z-ADD     VDAT          HEDAT
      *
     C     AMTP          IFEQ      'IN'
     C     AMTP          OREQ      'MR'                                                        23799
     C     INTA          ANDNE     *ZERO                                                       23799
     C                   MOVE      IPFR          HIPFR
     C                   Z-ADD     INTA          HEAMT
     C                   EXSR      OUTINT
     C                   ENDIF
      ***********                                                         230946
     C***********AMTP      IFEQ 'ST'                                      230946
     C***********AMTP      OREQ 'PI'                                      230946
     C***********AMTP      OREQ 'MR'                                      230946
     C***********AMTP      OREQ 'RE'                                      230946
     C***********CPAM      SUB  WRKAMT    HEAMT                           230946
     C***********          EXSR OUTPRI                                    230946
     C***********          ENDIF                                          230946
      *                                                                   230946
     C     AMTP          IFEQ      'ST'                                                        23094
     C     AMTP          OREQ      'PI'                                                        23094
     C     AMTP          OREQ      'PT'                                                        23094
     C                   Z-ADD     PRAM          HEAMT                                         23094
     C                   EXSR      OUTPRI                                                      23094
     C                   ENDIF                                                                 23094
      *                                                                   230946
     C     AMTP          IFEQ      'MR'                                                        23094
     C     AMTP          OREQ      'RE'                                                        23094
     C     AMTP          OREQ      'PF'                                                        23094
     C                   Z-SUB     PRAM          HEAMT                                         23094
     C                   EXSR      OUTPRI                                                      23094
     C                   ENDIF                                                                 23094
      *
     C     AMTP          IFEQ      'ST'
     C     AMTP          OREQ      'SC'
     C     AMTP          OREQ      'RO'
     C     AMTP          OREQ      'BC'                                                        23094
     C                   MOVE      BRTT          HBRTT
     C***********          Z-ADD*ZERO     HFRFD                           230946
     C                   MOVE      RFDY          HFRFD                                         23094
     C***********          Z-ADD*ZERO     HINFD                           230946
     C     RTSP          IFLT      *ZERO
     C                   MOVE      'S'           HSPIN
     C                   Z-SUB     RTSP          HRTSP
     C                   ELSE
     C                   MOVE      'A'           HSPIN
     C                   Z-ADD     RTSP          HRTSP
     C                   ENDIF
     C                   Z-ADD     INTR          HINTR
     C                   EXSR      OUTTAS
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  OUTINT -  Write a record to Interest Payments extract file   *
      *                                                               *
      *  Called By: SRDEAL                                            *
      *             SRLOAN                                            *
      *                                                               *
      *****************************************************************
      *
     C     OUTINT        BEGSR
      *
     C                   MOVE      C9003         F1COMP
     C                   MOVE      C0120         F1BRCD
     C                   MOVE      C9149         F1MODL
     C                   MOVE      C9150         F1DLNO
     C                   MOVE      C9869         F1FILE
     C                   MOVE      C9872         F1OUTH
      *
     C                   MOVE      HIPFR         F1IPFR
      *
     C                   Z-ADD     HEDAT         $$DAY
     C                   EXSR      GLM053
     C                   MOVE      $$DATE        F1EDAT
      *
     C                   Z-ADD     HEAMT         $$AMNT
     C                   EXSR      GLM041
     C                   MOVE      $$CAMT        F1EAMT                                     nt
      *
     C                   MOVE      '05'          RECC
     C                   MOVE      DETINT        DATA
     C                   ADD       1             RRNINT
     C                   WRITE     FEINTF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  OUTPRI -  Write a record to Principal Changes extract file   *
      *                                                               *
      *  Called By: SRDEAL                                            *
      *             SRLOAN                                            *
      *                                                               *
      *****************************************************************
      *
     C     OUTPRI        BEGSR
      *
     C                   MOVE      C9003         F2COMP
     C                   MOVE      C0120         F2BRCD
     C                   MOVE      C9149         F2MODL
     C                   MOVE      C9150         F2DLNO
     C                   MOVE      C9869         F2FILE
     C                   MOVE      C9872         F2OUTH
      *
     C                   MOVE      HRPFR         F2RPFR
      **********                                                          230946
     C**********           Z-ADDHEDAT     $$DAY                           230946
     C**********           EXSR GLM053                                    230946
     C**********           MOVE $$DATE    F2EDAT                          230946
      **********                                                          230946
     C                   ADD       HEAMT         WRKAMT
     C                   MOVE      $$CCY         F2CCY                                         23094
     C**********           Z-ADDWRKAMT    $$AMNT                          230946
     C**********           EXSR GLM041                                    230946
     C**********           MOVE $$CAMT    F2EAMT                          230946
      *
     C**********           MOVE '05'      RECC                            230946
     C**********           MOVE DETPRI    DATA                            230946
     C**********           ADD  1         RRNPRI                          230946
     C**********           WRITEFEPRIF                                    230946
     C                   WRITE     WKFEPRIF                                                    23094
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  OUTTAS -  Write a record to Rate Changes extract file        *
      *                                                               *
      *  Called By: SRDEAL                                            *
      *             SRLOAN                                            *
      *                                                               *
      *****************************************************************
      *
     C     OUTTAS        BEGSR
      *
     C                   MOVE      C9003         F3COMP
     C                   MOVE      C0120         F3BRCD
     C                   MOVE      C9149         F3MODL
     C                   MOVE      C9150         F3DLNO
     C                   MOVE      C9869         F3FILE
     C                   MOVE      C9872         F3OUTH
      *
     C                   MOVE      *BLANKS       F3BRTT
     C     HBRTT         IFNE      *ZERO
     C                   MOVE      HBRTT         F3BRTT
     C                   ENDIF
      *
     C                   Z-ADD     HEDAT         $$DAY
     C                   EXSR      GLM053
     C                   MOVE      $$DATE        F3EDAT
      *
     C                   MOVE      HFRFD         F3FRFD
      *
     C                   Z-ADD     *ZERO         HINFD                                         23094
     C     HBRTT         IFNE      *ZERO                                                       23094
     C                   Z-ADD     HEDAT         HINFD                                         23094
     C     HFRFD         IFNE      *ZERO                                                       23094
     C                   MOVE      $$CCY         ZCCY                                          23094
     C                   Z-ADD     HINFD         ZDAYNO                                        23094
     C                   Z-ADD     HFRFD         ZNRDYS                                        23094
     C                   EXSR      ZBKDT                                                       23094
     C                   Z-ADD     ZDYNBR        HINFD                                         23094
     C                   ENDIF                                                                 23094
     C                   ENDIF                                                                 23094
     C                   Z-ADD     HINFD         $$DAY
     C                   EXSR      GLM053
     C                   MOVE      $$DATE        F3INFD
      *
     C                   MOVE      HICFR         F3ICFR
      *
     C     HSPIN         IFEQ      'S'
     C                   MOVEL     '-'           F3RTSP
     C                   ELSE
     C                   MOVEL     '+'           F3RTSP
     C                   ENDIF
     C                   Z-ADD(H)  HRTSP         WKRTSP            8 5
     C                   MOVE      WKRTSP        F3RTSP
      *
     C     HBRTT         IFEQ      *ZERO
     C                   MOVE      *BLANKS       F3RTSP
     C                   ENDIF
      *
     C                   Z-ADD(H)  HINTR         WKINTR           13 8
     C                   MOVE      WKINTR        F3INTR
      *
     C                   MOVE      '05'          RECC
     C                   MOVE      DETTAS        DATA
     C                   ADD       1             RRNTAS
     C                   WRITE     FETASF
      *
     C                   ENDSR
      /EJECT                                                              230946
      *****************************************************************   230946
      *                                                               *   230946
      *  SRPSOL -  Write past and future principal changes for        *   230946
      *            participations sold.                               *   230946
      *                                                               *   230946
      *  Called By: SBRCH                                             *   230946
      *  Calls: OUTPRI                                                *   230946
      *                                                               *   230946
      *****************************************************************   230946
      *                                                                   230946
     C     SRPSOL        BEGSR                                                                 23094
      *                                                                   230946
     C                   MOVE      RFRQ          HRPFR                                         23094
      *                                                                   230946
      * Process Loan History                                              230946
      *                                                                   230946
     C     KLEHIS        CHAIN     HISTR                              10                       23094
     C     *IN10         DOWEQ     *OFF                                                        23094
      *                                                                   230946
     C                   Z-ADD     VDAT          HEDAT                                         23094
      *                                                                   230946
     C     AMTP          IFEQ      'ST'                                                        23094
     C     AMTP          OREQ      'PI'                                                        23094
     C     AMTP          OREQ      'PT'                                                        23094
     C                   Z-SUB     PRAM          HEAMT                                         23094
     C                   EXSR      OUTPRI                                                      23094
     C                   ENDIF                                                                 23094
      *                                                                   230946
     C     AMTP          IFEQ      'MR'                                                        23094
     C     AMTP          OREQ      'RE'                                                        23094
     C     AMTP          OREQ      'PF'                                                        23094
     C                   Z-ADD     PRAM          HEAMT                                         23094
     C                   EXSR      OUTPRI                                                      23094
     C                   ENDIF                                                                 23094
      *                                                                   230946
     C     KLEHIS        READE     HISTR                                  10                   23094
     C                   ENDDO                                                                 23094
      *                                                                   230946
     C     KLEHIS        CHAIN     MHISR                              11                       23094
     C     *IN11         DOWEQ     *OFF                                                        23094
      *                                                                   230946
     C                   Z-ADD     VDAT          HEDAT                                         23094
      *                                                                   230946
     C     AMTP          IFEQ      'ST'                                                        23094
     C     AMTP          OREQ      'PI'                                                        23094
     C     AMTP          OREQ      'PT'                                                        23094
     C                   Z-SUB     PRAM          HEAMT                                         23094
     C                   EXSR      OUTPRI                                                      23094
     C                   ENDIF                                                                 23094
      *                                                                   230946
     C     AMTP          IFEQ      'MR'                                                        23094
     C     AMTP          OREQ      'RE'                                                        23094
     C     AMTP          OREQ      'PF'                                                        23094
     C                   Z-ADD     PRAM          HEAMT                                         23094
     C                   EXSR      OUTPRI                                                      23094
     C                   ENDIF                                                                 23094
     C     KLEHIS        READE     MHISR                                  11                   23094
     C                   ENDDO                                                                 23094
      *                                                                   230946
      * Process Loan Events                                               230946
      *                                                                   230946
     C     LNRF          CHAIN     LVENTELF                           12                       23094
     C     *IN12         DOWEQ     *OFF                                                        23094
      *                                                                   230946
     C     EAMT          IFNE      *ZERO                                                       23094
     C     EDAT          ANDNE     *ZERO                                                       23094
     C     IBRE          ANDNE     'Y'                                                         23094
      *                                                                   230946
     C                   Z-ADD     EDAT          HEDAT                                         23094
      *                                                                   230946
     C     EVCD          IFEQ      'V3'                                                        23094
     C     EVCD          OREQ      'V5'                                                        23094
     C     EVCD          OREQ      'V7'                                                        23094
     C     EVCD          OREQ      'X2'                                                        23094
     C     EVCD          OREQ      'V1'                                                        23094
     C                   Z-SUB     EAMT          HEAMT                                         23094
     C                   EXSR      OUTPRI                                                      23094
     C                   ENDIF                                                                 23094
      *                                                                   230946
     C     EVCD          IFEQ      'R1'                                                        23094
     C     EVCD          OREQ      'R7'                                                        23094
     C     EVCD          OREQ      'M1'                                                        23094
     C                   Z-ADD     EAMT          HEAMT                                         23094
     C                   EXSR      OUTPRI                                                      23094
     C                   ENDIF                                                                 23094
      *                                                                   230946
     C                   ENDIF                                                                 23094
      *                                                                   230946
     C     LNRF          READE     LVENTELF                               12                   23094
     C                   ENDDO                                                                 23094
      *                                                                   230946
     C                   ENDSR                                                                 23094
      /EJECT
      *****************************************************************
      *                                                               *
      *  S00000 -  Write Header Record on each extract file           *
      *                                                               *
      *  Called By: Main line                                         *
      *  Calls: GLM053                                                *
      *                                                               *
      *****************************************************************
      *
     C     S00000        BEGSR
      *
     C                   MOVE      '00'          RECC
     C                   MOVE      A8CMCD        BKCODE
     C                   MOVE      BJSLCD        GRCODE
     C                   MOVE      *DATE         SYSDAT
      *
     C                   Z-ADD     MLACD         $$DAY
     C                   EXSR      GLM053
     C                   MOVE      $$DATE        LASTAC
      *
     C                   MOVE      MMDAT         LASTWR
      *
     C                   Z-ADD     BJDNWD        $$DAY
     C                   EXSR      GLM053
     C                   MOVE      $$DATE        NEXTWR
      *
     C                   MOVE      'FEINT'       EXNAME
     C                   MOVE      R00000        DATA
     C                   ADD       1             RRNINT
     C                   WRITE     FEINTF
      **********                                                          230946
     C**********           MOVE 'FEPRI'   EXNAME                          230946
     C**********           MOVE R00000    DATA                            230946
     C**********           WRITEFEPRIF                                    230946
     C**********           ADD  1         RRNPRI                          230946
      *
     C                   MOVE      'FETAS'       EXNAME
     C                   MOVE      R00000        DATA
     C                   WRITE     FETASF
     C                   ADD       1             RRNTAS
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  S02000 -  Writing Branch Initial Record on each extract file *
      *                                                               *
      *  Called By: SBRCH                                             *
      *                                                               *
      *****************************************************************
      *
     C     S02000        BEGSR
      *
     C                   MOVE      '02'          RECC
     C                   MOVEL(P)  A8BRCD        DATA
      *
     C                   WRITE     FEINTF
     C                   ADD       1             RRNINT            6 0
      **********                                                          230946
     C**********           WRITEFEPRIF                                    230946
     C**********           ADD  1         RRNPRI  60                      230946
      *
     C                   WRITE     FETASF
     C                   ADD       1             RRNTAS            6 0
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  S09000 -  Write Branch Final Record on each extract file     *
      *                                                               *
      *  Called By: SBRCH                                             *
      *                                                               *
      *****************************************************************
      *
     C     S09000        BEGSR
      *
     C                   MOVE      '09'          RECC
     C                   MOVE      *BLANKS       DATA
      *
     C                   WRITE     FEINTF
     C                   ADD       1             RRNINT
      **********                                                          230946
     C**********           WRITEFEPRIF                                    230946
     C**********           ADD  1         RRNPRI                          230946
      *
     C                   WRITE     FETASF
     C                   ADD       1             RRNTAS
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  S99000 -  Write Footer Record on each extract file           *
      *                                                               *
      *  Called By: Main line                                         *
      *                                                               *
      *****************************************************************
      *
     C     S99000        BEGSR
      *
     C                   MOVE      '99'          RECC
      *
     C                   ADD       1             RRNINT
     C                   MOVEL(P)  RRNINT        DATA
     C                   WRITE     FEINTF
      **********                                                          230946
     C**********           ADD  1         RRNPRI                          230946
     C**********           MOVELRRNPRI    DATA      P                     230946
     C**********           WRITEFEPRIF                                    230946
      *
     C                   ADD       1             RRNTAS
     C                   MOVEL(P)  RRNTAS        DATA
     C                   WRITE     FETASF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      ***GLM041*-*Calling*Routine*GLM041*for*AM*data*type*conversion***                       LUC109
      *  GLM041 - Calling Routine XX000041 for AM data type conversion*                       LUC109
      *                                                               *
      *****************************************************************
      *
     C     GLM041        BEGSR
      *
     C                   CLEAR                   $$CAMT
      *
     C**********         CALL      'GLM041'                                                   LUC109
     C                   CALL      'XX000041'                                                 LUC109
     C                   PARM                    $$CCY             3            Currency code
     C                   PARM                    $$AMNT           15 0          Amount
     C                   PARM                    $$CAMT           19            Converted amnt
     C                   PARM                    $$EROR            1            Error indicator
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      ***GLM053*-*Calling*Routine*GLM053*for*date*conversion***********                       LUC109
      *  GLM053 - Calling Routine XX000053 for date conversion        *                       LUC109
      *                                                               *
      *****************************************************************
      *
     C     GLM053        BEGSR
      *
     C                   CLEAR                   $$DATE
     C**********         CALL      'GLM053'                                                   LUC109
     C                   CALL      'XX000053'                                                 LUC109
     C                   PARM                    $$DAY             5 0
     C                   PARM                    $$DATE            8 0
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Subroutine to do Program Initialisation.            *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C***********          READ SDBANKD0                 LR               228619
     C     1             CHAIN     SDBANKD0                           LR                       22861
      *
     C                   READ      SDINTFV0                               LR
      *
     C     S9BRCH        CHAIN     SDBRCHD0                           LR
      *
     C                   READ      SDGELRPP                               LR
      *
     C                   Z-ADD     1             F1PROG
     C                   Z-ADD     1             F2PROG
     C                   Z-ADD     1             F3PROG
      *
     C     BJDFIN        IFEQ      'M'
     C                   MOVE      *ON           *IN98
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
     C***/C*PY*ZSRSRC,ZACCH                                                                   LUC109
     C/COPY ZSRSRC,ZACCHLE                                                                    LUC109
     C***/C*PY*ZSRSRC,ZBKDT                                                                   LUC109
     C/COPY ZSRSRC,ZBKDT_ILE                                                                  LUC109
     C***/C*PY*ZSRSRC,ZCHKH                                                                   LUC109
     C/COPY ZSRSRC,ZCHKHLE                                                                    LUC109
     C***/C*PY*ZSRSRC,ZDATE1Z2                                                                LUC109
     C/COPY ZSRSRC,ZDATE1Z2LE                                                                 LUC109
     C***/C*PY*ZSRSRC,ZDATE2Z2                                                                LUC109
     C/COPY ZSRSRC,ZDATE2Z2LE                                                                 LUC109
     C***/C*PY*ZSRSRC,ZFREQBZ2                                                                LUC109
     C/COPY ZSRSRC,ZFREQBZ2LE                                                                 LUC109
      /EJECT
**   ZFMD  -  NUMBER OF DAYS IN THE MONTH
312831303130313130313031
**   ZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
0366073110961461
**   ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
000031059090120151181212243273304334365
**   ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
