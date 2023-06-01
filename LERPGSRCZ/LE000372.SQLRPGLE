     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2022')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas LE Loan Advice with Fwd ARR Rates')              *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000372 - LE Loan Advice with Fwd ARR Rates                 *
      *                                                               *
      *  Function:  This program will generate Loan Advices for the   *
      *             loans set as Rate Known with interest due         *
      *             which includes forward ARR rates.                 *
      *                                                               *
      *  Called By: LEC000372 - Midas LE ARR Fwd Rates                *
      *                                                               *
      *  (c) Finastra International Limited 2022                      *
      *                                                               *
      *  Last Amend No. MD061389            Date 24May23              *
      *  Prev Amend No. MD061274            Date 09May23              *
      *                 MD060441            Date 01Feb23              *
      *                 MD061006            Date 02Feb23              *
      *                 MD060824            Date 10Jan23              *
      *                 MD060897            Date 10Jan23              *
      *                 MD058517 *CREATE    Date 17Oct22              *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD061389 - Incorrect period and spread on LE000372 report    *
      *             Amended the program to get the interest period    *
      *             from SDHSDRTD for CCR and SAVG                    *
      *             Retrieve the spread rate and indicator from       *
      *             HISTSHQ and HISTSHM                               *
      *  MD061274 - Deliverable Data Split for SDARRTTD               *
      *  MD060441 - CLE172 CC9 - Back-valued Rollover to a            *
      *             backward looking rate                             *
      *  MD061006 - Compilation failed on LE000372 due to SDLIBRTD    *
      *             made redundant                                    *
      *             Amended all calls to SDLIBRTD to access           *
      *             SDLIBJW0 instead                                  *
      *  MD060824 - Future rates were rounded up on rates known date  *
      *             on LOAC and LEFWBRPD                              *
      *             Amended rate computation to follow ZAGETCALRT     *
      *             logic.                                            *
      *  MD060897 - CC10 Loan Interest Confirmation Spool file issues *
      *             - Loan record is reported twice                   *
      *             - Reprint function failed for matured loans       *
      *             - Some labels does not match user story reqmnt    *
      *             Amended this program as follows                   *
      *             - Do not perform print routine if record is not   *
      *               found in loans file                             *
      *             - Use union to combine current and forward rates  *
      *               excluding records which exist on both files     *
      *  MD058517 - CLE172 LIBOR Lending- Change Control CC3.1        *
      *             Interest Projection Using Known Rates             *
      *             CC10 CLE172 Spool File Correspondence (MD059817)  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  USE OF INDICATORS                                            *
      *                                                               *
      *    40         READ to SDRTKNTD file                           *
      *    41         CHAIN to SDARRTTD file                          *
      *    42         CHAIN to SDLIBRTD file                          *
      *    U7         Database error                                  *
      *    U8         Database error                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *                                                               *
      *****************************************************************
      *
      ** Midas LE Rate Known Loans File
     F***SDRTKNTD  UF   E             DISK    INFSR(*PSSR)                                  MD060441
     FSDRTKNL0  UF   E             DISK    INFSR(*PSSR)                                     MD060441
     F                                     COMMIT
      *****************************************************************                     MD061274
      ***Midas*SD*Array*of*Text*Table**********************************                     MD061274
     F***SDARRTTD  IF   E           K DISK    INFSR(*PSSR)                                  MD061274
      *
      ** Midas SD ARR Calculator Parameter Details
     F***SDLIBRTD  IF   E           K DISK    INFSR(*PSSR)                                  MD061006
      *
      ** Midas LE Loan Advice with Fwd ARR Rates Report File
     FLE000372P1O    E             PRINTER USROPN
     F                                     OFLIND(*IN01)
     F                                     INFDS(SPOOL1)

      *****************************************************************
      /EJECT
      *****************************************************************

     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE

      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS

      ** File Information Data Structure for SD001112P1
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0

     D/COPY ZSRSRC,ZINTDYZ1LE
     D/COPY ZSRSRC,ZDATE9Z1LE
     D/COPY ZSRSRC,ZDATE9Z2LE
     D/COPY ZSRSRC,ZDAT10Z1LE

      ** Data Sructure for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** Data Sructure for currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)

      ** Data Sructure for customer details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)

      ** Short Data Structure for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Long Data Structure for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** Work Data Structures
     D LoanDS          DS
     D  DSRECI                        1A                                                    MD060897
     D  DSCNUM                        6A
     D  DSCPAM                       13P 0
     D  DSCCY                         3A
     D  DSSLID                        5P 0
     D  DSNIDT                        5P 0
     D  DSREPT                        1S 0
     D  DSNRPD                        5P 0
     D  DSMDAT                        5P 0
     D  DSINTR                       11P 7
     D  DSVDAT                        5P 0
     D  DSCALM                        4A
     D  DSICBS                        1S 0
     D  DSBADJ                       11P 7
     D  DSRTSP                       11P 7
     D  DSSPIN                        1A
     D  DSRFRR                       10A
     D  DSDBAV                        1S 0
     D  DSFLOR                       11P 7
     D  DSLODY                        2S 0
     D  DSLBDY                        2S 0
     D  DSOPSH                        1A
     D  DSRRDP                        2S 0

     D DSDate          DS             7
     D  DSDy1                  1      1
     D  DSDay                  1      2
     D  DSMth                  3      5
     D  DSYear                 6      7

      ** Temporary DS for SDHSDRTD/SDFWDRTD
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

      ** Parameters for ZDATE2
     D ZDayNo          S              5P 0
     D ZDate           S              6P 0
     D ZADate          S              7A

      ** Parameters for ZSEDIT
     D ZFLD15          S             15  0
     D ZDECS           S              1  0
     D ZECODE          S              1
     D ZOUT21          S             21

      ** Work variables
     D @RUN            S              1A
     D WIntr           S             11P 7

      ** Access Object Variables
     D PRTCD           S              7A
     D POPTN           S              7A

      ** Report Variables
     D RQDLN1          S              3S 0
     D DIFLN1          S              3S 0
     D WOPNP1          S              1A
     D PSEQ            S              5A
     D SENTY           S              3A
     D RPRNT           S              1A
     D ZFILE           S             10A
     D ZSERR           S              1A
     D ZSNUM           S              6  0
                                                                                            MD061389
      ** Spread Rate and Spread Indicator variables                                         MD061389
     D wrkSpread       S             11P 7 INZ(0)                                           MD061389
     D wrkSpreadInd    S              1A   INZ(*BLANKS)                                     MD061389

      ** Entry Parameters for AOCUSTR0
     D @RtCd           S              7
     D @Optn           S              7
     D @Key10          S             10
     D @KySt           S              7

     D WWCust          S             10
     D PNidt           S              5P 0
     D WWNrdy          S              4S 0
     D WWNrdyChar      S              4A
     D WWIndyChar      S              5A
     D XCINPDT         S              5  0
     D XCINPSD         S              5  0
     D CFlor           C                   CONST(9999.9999999)

      ** Entry Parameters for AOSVALR0
     D P@OP01          S             20
     D P@VL01          S            200
     D P@OP02          S             20
     D P@VL02          S            200
     D P@OP03          S             20
     D P@VL03          S            200
     D P@OP04          S             20
     D P@VL04          S            200
     D P@OP05          S             20
     D P@VL05          S            200
     D P@OP06          S             20
     D P@VL06          S            200
     D P@OP07          S             20
     D P@VL07          S            200
     D P@OP08          S             20
     D P@VL08          S            200
     D P@OP09          S             20
     D P@VL09          S            200
     D P@OP10          S             20
     D P@VL10          S            200
     D PrintP3         S              1
     D NO_RECORD       c                   const(100)                                       MD060897
     D wFinalRate      S             15P 9 INZ(0)                                           MD060824
     D wCurrRate       S             11P 7 INZ(0)                                           MD060824
     D SDLIBR        E DS                  EXTNAME(SDLIBJW0)                                MD061006
     D isFirstRun      S              1N   INZ(*ON)                                         MD060441
     D wrkDec          S              1S 0 INZ(0)                                           MD060441
     D wrkVDAT         S              5P 0 INZ(0)                                           MD060441
     D isManualComp    S              1N   INZ(*OFF)                                        MD060441
     D SDARRT        E DS                  EXTNAME(SDARRJW0)                                MD061274
     D PCALLER         S             10A   INZ(*BLANKS)                                     MD061274

      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN PROCESSING                                               *
      *****************************************************************

      ** Read records from LE Rate Known Loans Files File

     C**********         READ      SDRTKNTD                               40                MD060441
     C                   READ      SDRTKNL0                               40                MD060441

     C     *IN40         DOWEQ     *OFF
     C                   IF        KMODID = 'LE' AND KRTKNI = 'Y' AND
     C                             (KCINTA <> KPINTA OR KSPLFP <> 'Y'
     C                              OR RPRNT = 'Y')
     C/exec SQL
     C**********+ declare CLOA cursor for                                                   MD060897
     C+ select
     C+   RECI                                                                              MD060897
     C**********+   CNUM                                                                    MD060897
     C+ , CNUM                                                                              MD060897
     C+ , CPAM
     C+ , CCY
     C+ , SLID
     C+ , NIDT
     C+ , REPT
     C+ , NRPD
     C+ , MDAT
     C+ , INTR
     C+ , VDAT
     C+ , CALM
     C+ , ICBS
     C+ , BADJ
     C+ , RTSP
     C+ , SPIN
     C+ , RFRR
     C+ , DBAV
     C+ , FLOR
     C+ , LODY
     C+ , LBDY
     C+ , OPSH
     C+ , RRDP
     C+   INTO   :LoanDS                                                                    MD060897
     C+ from CLOANCL
     C+ where
     C+     LNRF = :KTRNID
     C+     AND BLRT = 'Y'                                                                  MD060441
     C/end-exec

     C**********/exec SQL                                                                   MD060897
     C**********+ open CLOA                                                                 MD060897
     C**********/end-exec                                                                   MD060897
                                                                                            MD060897
     C**********/exec SQL                                                                   MD060897
     C**********+ fetch next                                                                MD060897
     C**********+ from CLOA                                                                 MD060897
     C**********+ into :LoanDS                                                              MD060897
     C**********/end-exec                                                                   MD060897

     C                   IF        SQLCOD <> NO_RECORD AND DSRECI = 'D'                     MD060897
      ** Transaction Reference
     C                   EVAL      P1LNRF = KTRNID

      ** Customer
     C                   EVAL      P1CUST = DSCnum

     C                   EVAL      WWCust = DSCnum
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM      WWCust        @Key10
     C                   PARM      *BLANKS       @KySt
     C     SDCUST        PARM      SDCUST        DSSDY

     C                   IF        @RtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDCUSTPD'
     C                   Z-ADD     901           DBase
     C                   EVAL      DBKey = DSCnum
     C                   OUT       LDA
     C                   Exsr      *PSSR
     C                   ELSE
     C                   EVAL      P1CNA1 = BBCNA1
     C                   EVAL      P1CNA2 = BBCNA2
     C                   EVAL      P1CNA3 = BBCNA3
     C                   EVAL      P1CNA4 = BBCNA4
     C                   ENDIF
                                                                                            MD061389
     C                   CLEAR                   wrkSpread                                  MD061389
     C                   CLEAR                   wrkSpreadInd                               MD061389

     C                   CLEAR                   DlyDS

      *                                                                                     MD061389
     C                   IF        (DSCALM = 'NCCR' OR DSCALM = 'SARR')                     MD061389
     C/exec SQL
     C+ declare FWCursor cursor for
     C+ select
     C+   FINPSD
     C+ , FINPED
     C+ , FINPDT
     C+ , FINPDY
     C+ , FOBPDT
     C+ , FOBPDY
     C+ , FPBRFR
     C+ , FRTEAP
     C+ , FCALCM
     C+ , FAVCRT
     C+ , FDCMRT
     C+ , FSMPAV
     C+ from SDFWDRTD
     C+ where
     C+ FTRNID = :KTRNID
     C+ order by FINPDT desc
     C/end-exec

     C/exec SQL
     C+ open FWCursor
     C/end-exec

     C/exec SQL
     C+ fetch next from FWCursor into :DlyDS
     C/end-exec

     C                   ELSE                                                               MD061389
     C/exec SQL                                                                             MD061389
     C+ declare HSCursor cursor for                                                         MD061389
     C+ select                                                                              MD061389
     C+   CINPSD                                                                            MD061389
     C+ , CINPED                                                                            MD061389
     C+ , CINPDT                                                                            MD061389
     C+ , CINPDY                                                                            MD061389
     C+ , COBPDT                                                                            MD061389
     C+ , COBPDY                                                                            MD061389
     C+ , CPBRFR                                                                            MD061389
     C+ , CRTEAP                                                                            MD061389
     C+ , CCALCM                                                                            MD061389
     C+ , CAVCRT                                                                            MD061389
     C+ , CDCMRT                                                                            MD061389
     C+ , CSMPAV                                                                            MD061389
     C+ from SDHSDRTD                                                                       MD061389
     C+ where                                                                               MD061389
     C+ CTRNID = :KTRNID                                                                    MD061389
     C+ order by CINPDT desc                                                                MD061389
     C/end-exec                                                                             MD061389
                                                                                            MD061389
     C/exec SQL                                                                             MD061389
     C+ open HSCursor                                                                       MD061389
     C/end-exec                                                                             MD061389
                                                                                            MD061389
     C/exec SQL                                                                             MD061389
     C+ fetch next from HSCursor into :DlyDS                                                MD061389
     C/end-exec                                                                             MD061389
                                                                                            MD061389
     C                   ENDIF                                                              MD061389
                                                                                            MD061389
      ** Int Start Date
     C     SQLCOD        IFNE      100
     C     DintStart     ANDNE     0
     C                   EVAL      ZDayNo = DintStart
     C                   ELSE
     C                   EVAL      ZDayNo = DSVDAT
     C                   ENDIF

     C                   CALL      'ZDATE2'
     C                   PARM                    ZDayNo
     C                   PARM                    BJDFIN
     C                   PARM      *Zero         ZDate
     C                   PARM      *BLanks       ZADate

     C                   EVAL      DSDATE = ZADate
     C     DSDy1         IFEQ      ' '
     C                   EVAL      DSDy1 = '0'
     C                   ENDIF
     C                   EVAL      P1STDT = DSDay + '-' + DSMth + '-' + DSYear

      ** Int End Date
     C     DSNidt        IFNE      0
     C                   Z-ADD     DSNidt        PNIDT
     C                   ELSE
     C     DSRept        IFEQ      3
     C     DSNrpd        ANDNE     0
     C     DSRept        OREQ      1
     C     DSNrpd        ANDNE     0
     C                   Z-ADD     DSNrpd        PNIDT
     C                   ELSE
     C                   Z-ADD     DSMdat        PNIDT
     C                   ENDIF
     C                   ENDIF

     C                   EVAL      ZDayNo = PNIDT
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDayNo
     C                   PARM                    BJDFIN
     C                   PARM      *Zero         ZDate
     C                   PARM      *BLanks       ZADate

     C                   EVAL      DSDATE = ZADate
     C     DSDy1         IFEQ      ' '
     C                   EVAL      DSDy1 = '0'
     C                   ENDIF
     C                   EVAL      P1NIDT = DSDay + '-' + DSMth + '-' + DSYear

      ** Number of Days
     C                   IF        DintStart <> 0
     C     PNidt         SUB       DintStart     WWNrdy
     C                   ELSE
     C     PNidt         SUB       DSVdat        WWNrdy
     C                   ENDIF

     C                   MOVE      WWNrdy        WWNrdyChar
     C                   EVAL      WWNrdyChar =  %triml(WWNrdyChar:'0')

     C                   EVAL      P1NRDY = '('+(%trim(WWNrdyChar))+' days'+ ')'

     C                   CLEAR                   wCurrRate                                  MD060824
     C                   CLEAR                   wFinalRate                                 MD060824
      ** Interest Rate
     C     DSCalm        IFEQ      'CCR'
     C     DSCalm        OREQ      'SAVG'

     C                   SELECT
     C     DSCalm        WHENEQ    'CCR'
     C*****Davcr         ADD(H)    DSBADJ        WIntr                                      MD060824
     C                   EVAL      wCurrRate =  Davcr                                       MD060824

     C     DSCalm        WHENEQ    'SAVG'
     C*****Dsmav         ADD(H)    DSBADJ        WIntr                                      MD060824
     C                   EVAL      wCurrRate =  Dsmav                                       MD060824
     C                   ENDSL
     C                   EVAL      wFinalRate = wCurrRate + DSBADJ                          MD060824
     C                   EVAL(H)   WIntr      = wFinalRate                                  MD060824

     C                   SELECT
     C     DSSPIN        WHENEQ    'A'
     C**********         ADD(H)    DSRTSP        WIntr                                      MD060824
     C                   ADD       DSRTSP        WIntr                                      MD060824
     C     DSSPIN        WHENEQ    'S'
     C**********         SUB(H)    DSRTSP        WIntr                                      MD060824
     C                   SUB       DSRTSP        WIntr                                      MD060824
     C     DSSPIN        WHENEQ    'P'
     C     DSRTSP        DIV       100           WRK_139          13 9
     C                   MULT(H)   WRK_139       WIntr
     C     DSSPIN        WHENEQ    *BLANK
     C**********         ADD(H)    DSRTSP        WIntr                                      MD060824
     C                   ADD       DSRTSP        WIntr                                      MD060824
     C                   ENDSL

     C                   MOVE      WIntr         ZFLD15
     C                   EVAL      ZDECS = 7

     C                   CALL      'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM                    ZDECS
     C                   PARM      'J'           ZECODE
     C                   PARM                    ZOUT21

     C                   EVAL      P1INTR  = (%trim(ZOUT21)) + ' % P.A.'
     C                   ELSE
     C                   EVAL      P1INTR  = *Blanks
     C                   ENDIF

     C                   IF        (DSCALM = 'NCCR' OR DSCALM = 'SARR')                     MD061389
     C/exec SQL
     C+ close FWCursor
     C/end-exec
     C                   ELSE                                                               MD061389
     C/exec SQL                                                                             MD061389
     C+ close HSCursor                                                                      MD061389
     C/end-exec                                                                             MD061389
     C                   ENDIF                                                              MD061389

      ** Principal Amount
     C                   EVAL      P1CCY  = DSccy

     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    DSCCY
     C     SDCURR        PARM      SDCURR        DSSDY

     C                   EVAL      ZFLD15 = DSCPAM
     C                   EVAL      ZDECS = A6NBDP
     C                   EVAL      wrkDec = A6NBDP                                          MD060441

     C                   CALL      'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM                    ZDECS
     C                   PARM      'J'           ZECODE
     C                   PARM                    ZOUT21

     C                   EVAL      P1CPAM  = %trim(ZOUT21)

      ** Interest Due Amount
     C                   EVAL      P1ICCY  = DSccy

     C                   EVAL      ZFLD15 = KCINTA
     C                   CALL      'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM                    ZDECS
     C                   PARM      'J'           ZECODE
     C                   PARM                    ZOUT21

     C                   EVAL      P1INTA  = %trim(ZOUT21)


     C**********/exec SQL                                                                   MD061389
     C**********+ close CLOA                                                                MD061389
     C**********/end-exec                                                                   MD061389

      ** Write Detail
     C                   EXSR      SRReportP1
     C                   EXSR      SRReportP2

     C                   CLEAR                   curIntrstAmt     13 0                      MD060441
     C                   CLEAR                   nxtIntrstAmt     13 0                      MD060441
     C                   CLEAR                   wrkIntrstAmt     13 0                      MD060441
     C                   CLEAR                   prvIntrstAmt     13 0                      MD060441
                                                                                            MD060441
     C     PrintP3       IFEQ      '1'
     C                   EXSR      SRReportP3
I    C                   ENDIF

     C     PrintP3       IFEQ      '2'
     C     DSCalm        IFEQ      'NCCR'
     C     DSCalm        OREQ      'SARR'
     C                   EXSR      SRReportP3
     C                   ENDIF
     C                   ENDIF

      ** Close file
     C                   EXSR      SREndRPT

      ** Update SDRTKNTD file if not requested from i/c
     C     RPRNT         IFNE      'Y'
     C                   EVAL      KSPLFP  = 'Y'
     C                   EVAL      KPINTA  = KCINTA
     C                   UPDATE    SDRTKNT0
     C                   ENDIF
     C                   ENDIF                                                              MD060897

     C                   ENDIF

     C**********         READ      SDRTKNTD                               40                MD060441
     C                   READ      SDRTKNL0                               40                MD060441
     C                   ENDDO

      ** End Program
     C                   COMMIT
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************                     MD061389
      /EJECT                                                                                MD061389
      *****************************************************************                     MD061389
      *                                                               *                     MD061389
      * RetrieveHSTM - Retrieve History File                          *                     MD061389
      *                                                               *                     MD061389
      *****************************************************************                     MD061389
     C     RetrieveHISTM BEGSR                                                              MD061389
     C/exec SQL                                                                             MD061389
     C+ select                                                                              MD061389
     C+   RTSP                                                                              MD061389
     C+ , SPIN                                                                              MD061389
     C+   into   :wrkSpread, :wrkSpreadInd                                                  MD061389
     C+ from HISTSHM                                                                        MD061389
     C+ where                                                                               MD061389
     C+     LNRF = :KTRNID                                                                  MD061389
     C/end-exec                                                                             MD061389
     C                   ENDSR                                                              MD061389
      *****************************************************************                     MD061389
      /EJECT                                                                                MD061389
      *****************************************************************                     MD061389
      *                                                               *                     MD061389
      * RetrieveHISTQ - Retrieve History File                         *                     MD061389
      *                                                               *                     MD061389
      *****************************************************************                     MD061389
     C     RetrieveHISTQ BEGSR                                                              MD061389
     C/exec SQL                                                                             MD061389
     C+ select                                                                              MD061389
     C+   RTSP                                                                              MD061389
     C+ , SPIN                                                                              MD061389
     C+   into   :wrkSpread, :wrkSpreadInd                                                  MD061389
     C+ from HISTSHQ                                                                        MD061389
     C+ where (AMTP = 'RO' or AMTP = 'SC' or AMTP = 'MC')                                   MD061389
     C+ and LNRF = :KTRNID and VDAT <= :XCINPDT                                             MD061389
     C+ order by VDAT desc, PRSQ desc, LCD desc                                             MD061389
     C+ fetch first row only                                                                MD061389
     C/end-exec                                                                             MD061389
     C                   IF        SQLCODE = 100                                            MD061389
     C                   EXSR      RetrieveHISTM                                            MD061389
     C                   ENDIF                                                              MD061389
     C                   ENDSR                                                              MD061389

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRReportP1 - Detail Report Subroutine                         *
      *                                                               *
      *****************************************************************
     C     SRReportP1    BEGSR

      ** Report fields have value at this point, open report file

     C                   IF        WOPNP1 <> 'Y'
     C                   OPEN      LE000372P1
     C                   EVAL      WOPNP1 = 'Y'
     C                   ENDIF

      ** Ensure Report Spool File recorded by RCF.
     C                   EVAL      ZSNUM = SFNUM1
     C                   EVAL      ZFILE = SFILE1

     C                   CALL      'ZSFILE'
     C                   PARM                    PSEQ
     C                   PARM                    SENTY
     C                   PARM                    ZFILE
     C                   PARM                    ZSNUM
     C                   PARM      *BLANK        ZSERR

     C     ZSERR         IFNE      *BLANKS
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF

      ** Write out detail record
     C                   WRITE     DETLP1

      ** Write out trailer format
     C*****'LE000372  '  CHAIN     SDARRTTD                           41                    MD061274
     C                   EVAL      PCALLER = 'LE000372'                                     MD061274
     C/EXEC SQL                                                                             MD061274
     C+ SELECT *                                                                            MD061274
     C+ into :SDARRT                                                                        MD061274
     C+ from SDARRJW0                                                                       MD061274
     C+ where CALLER = :PCALLER                                                             MD061274
     C/END-EXEC                                                                             MD061274
     C                   IF        SQLCODE = 100                                            MD061274
     C                   SETON                                        41                    MD061274
     C                   ENDIF                                                              MD061274
     C                   WRITE     TRAILP1

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRReportP2 - ARR Detail Page                                  *
      *                                                               *
      *****************************************************************
     C     SRReportP2    BEGSR

      ** Risk Free Rate
     C                   MOVEL     DSRFRR        P1RFRR

      ** Calculation Method
     C                   MOVEL     'METHOD  '    KSCFLD
     C                   MOVEL     DSCALM        KINVAL
     C*****KLIBR         CHAIN     SDLIBRTD                           42                    MD061006
     C/EXEC SQL                                                                             MD061006
     C+ SELECT *                                                                            MD061006
     C+ into :SDLIBR                                                                        MD061006
     C+ from SDLIBJW0                                                                       MD061006
     C+ where SCRFLD = :KSCFLD and INTVAL = :KINVAL                                         MD061006
     C/END-EXEC                                                                             MD061006
     C                   IF        SQLCODE = 100                                            MD061006
     C                   SETON                                        42                    MD061006
     C                   ENDIF                                                              MD061006
     C     *IN42         IFEQ      '0'
     C                   MOVEL     DSPVAL        P1CALM
     C                   ENDIF

      ** Benchmark Adjustment
     C                   MOVE      DSBADJ        ZFLD15
     C                   Z-ADD     7             ZDECS

     C                   Call      'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM                    ZDECS
     C                   PARM      'J'           ZECODE
     C                   PARM                    ZOUT21

     C                   EVAL      P1BADJ  = (%trim(ZOUT21)) + ' % '

      ** Day Basis for Average
     C                   MOVEL     *BLANKS       KINVAL
     C                   MOVEL     'DAYCOUNT'    KSCFLD
     C                   MOVEL     DSDBAV        KINVAL
     C*****KLIBR         CHAIN     SDLIBRTD                           42                    MD061006
     C/EXEC SQL                                                                             MD061006
     C+ SELECT *                                                                            MD061006
     C+ into :SDLIBR                                                                        MD061006
     C+ from SDLIBJW0                                                                       MD061006
     C+ where SCRFLD = :KSCFLD and INTVAL = :KINVAL                                         MD061006
     C/END-EXEC                                                                             MD061006
     C                   IF        SQLCODE = 100                                            MD061006
     C                   SETON                                        42                    MD061006
     C                   ENDIF                                                              MD061006
     C     *IN42         IFEQ      '0'
     C                   MOVEL     DSPVAL        P1DBAV
     C                   ENDIF

      ** Floor
     C     DSFLOR        IFEQ      CFlor
     C                   EVAL      P1FLOR  = *BLANKS
     C                   ELSE

     C                   MOVE      DSFLOR        ZFLD15
     C                   Z-ADD     7             ZDECS
     C                   CAll      'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM                    ZDECS
     C                   PARM      'J'           ZECODE
     C                   PARM                    ZOUT21

     C                   EVAL      P1FLOR  = (%trim(ZOUT21)) + ' % '
     C                   ENDIF

      ** Lockout Days
     C                   MOVEL     DSLODY        P1LODY

      ** Lookback Days
     C                   MOVEL     DSLBDY        P1LBDY

      ** Observation Period Shift
     C                   MOVEL     DSOPSH        P1OPSH

      ** Rates Known Indicator
     C                   MOVEL     KRTKNI        P1RTKN

      ** Rate Rounding Precision
     C                   MOVEL     DSRRDP        P1RRDP
     C                   EVAL      isRndApplies = 'N'                                       MD060897
     C                   IF        DSCALM = 'NCCR'                                          MD060897
     C                   CALL      'ZAGETRDAPL'                                             MD060897
     C                   PARM                    DSRFRR                                     MD060897
     C                   PARM                    isRndApplies      1                        MD060897
     C                   ENDIF                                                              MD060897
     C                   IF        isRndApplies = 'Y'                                       MD060897
     C                   EVAL      P1RLBL = 'Rate Rounding Precision'                       MD060897
     C                   ELSE                                                               MD060897
     C                   EVAL      P1RLBL = 'Rate Rounding Decimals '                       MD060897
     C                   ENDIF                                                              MD060897

      ** Write out detail record
     C                   WRITE     DETLP2

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRReportP3 - Period Detail Page                               *
      *                                                               *
      *****************************************************************
     C     SRReportP3    BEGSR

     C                   Z-ADD     0             XCINPSD
     C                   EVAL      isFirstRun  = *on                                        MD060441
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
     C+     CMODID = 'LE'
     C+ and CTRNID = :KTRNID
     C+ and CINFLG = 'Y'
     C**********+ order by                                                                  MD060897
     C**********+     CINPDT asc                                                            MD060897
     C+ union                                                                               MD060441
     C**********+ union all                                                        MD060897 MD060441
     C+ select                                                                              MD060897
     C+   FINPSD                                                                            MD060897
     C+ , FINPED                                                                            MD060897
     C+ , FINPDT AS CINPDT                                                                  MD060897
     C+ , FINPDY                                                                            MD060897
     C+ , FOBPDT                                                                            MD060897
     C+ , FOBPDY                                                                            MD060897
     C+ , FPBRFR                                                                            MD060897
     C+ , FRTEAP                                                                            MD060897
     C+ , FCALCM                                                                            MD060897
     C+ , FAVCRT                                                                            MD060897
     C+ , FDCMRT                                                                            MD060897
     C+ , FSMPAV                                                                            MD060897
     C+ from SDFWDRTD T2                                                                    MD060897
     C+ where                                                                               MD060897
     C**********+ not exists (                                                     MD060897 MD060441
     C**********+ select * from SDHSDRTD T1                                        MD060897 MD060441
     C**********+ where T1.CINPDT = T2.FINPDT )                                    MD060897 MD060441
     C**********+ and FMODID = 'LE'                                                MD060897 MD060441
     C+     FMODID = 'LE'                                                                   MD060441
     C+ and FTRNID = :KTRNID                                                                MD060897
     C+ order by                                                                            MD060897
     C+ CINPDT asc                                                                          MD060897
     C/end-exec

     C/exec SQL
     C+ open SDHS
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from SDHS
     C+ into :DlyDS
     C/end-exec

     C                   IF        SQLCOD <> 100
     C                   EVAL      XCINPSD = DintStart
     C                   WRITE     HEADP3
     C                   ENDIF

     C                   DOW       SQLCOD <> 100
     C                   EVAL      XCINPDT = Dintd

      ** Interest Period Date
     C                   MOVE      Dintd         ZDayNo
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDayNo
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         ZDate
     C                   PARM      *BLANKS       ZADate

     C                   EVAL      DSDATE = ZADate
     C     DSDy1         IFEQ      ' '
     C                   EVAL      DSDy1 = '0'
     C                   ENDIF
     C                   EVAL      P2INTD = DSDay + '-' + DSMth + '-' + DSYear

      ** Interest Period Days
     C                   MOVE      Dindy         WWIndyChar
     C**********         EVAL      P2INDY =  %triml(WWIndyChar:'0')                         MD060441
     C                   EVALR     P2INDY =  %triml(WWIndyChar:'0')                         MD060441


      ** Published Risk Free Rate
     C                   Z-ADD     Dbrfr         WrkRate          11 7
     C                   Z-ADD     0             ZFLD15
     C                   MOVE      WrkRate       ZFLD15
     C                   EVAL      ZDECS = 7
     C                   CALL      'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM                    ZDECS
     C                   PARM      'J'           ZECODE
     C                   PARM                    ZOUT21
     C**********         EVAL      P2BRFR  = (%trim(ZOUT21))                                MD060441
     C                   EVALR     P2BRFR  = (%trim(ZOUT21))                                MD060441

      ***Rate*Applied*************************************************                      MD060441
     C**********         Z-ADD     Drtap         WrkRate                                    MD060441
     C**********         Z-ADD     0             ZFLD15                                     MD060441
     C**********         MOVE      WrkRate       ZFLD15                                     MD060441
     C**********         EVAL      ZDECS = 7                                                MD060441
     C**********         CALL      'ZSEDIT'                                                 MD060441
     C**********         PARM                    ZFLD15                                     MD060441
     C**********         PARM                    ZDECS                                      MD060441
     C**********         PARM      'J'           ZECODE                                     MD060441
     C**********         PARM                    ZOUT21                                     MD060441
     C**********         EVAL      P2RTAP  = (%trim(ZOUT21))                                MD060441

      ** Average/Compound Rate
     C                   SELECT
     C                   WHEN      Dcalm = 'CCR'
     C                   Z-ADD     Davcr         WrkRate
     C                   WHEN      Dcalm = 'NCCR'
     C                   Z-ADD     Dcmrt         WrkRate
     C                   WHEN      Dcalm = 'SAVG'
     C                   Z-ADD     Dsmav         WrkRate
     C                   WHEN      Dcalm = 'SARR'
     C                   Z-ADD     Drtap         WrkRate
     C                   ENDSL

     C                   Z-ADD     0             ZFLD15
     C                   MOVE      WrkRate       ZFLD15
     C                   EVAL      ZDECS = 7
     C                   CALL      'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM                    ZDECS
     C                   PARM      'J'           ZECODE
     C                   PARM                    ZOUT21
     C**********         EVAL      P2AVCR  = (%trim(ZOUT21))                                MD060441
     C                   EVALR     P2AVCR  = (%trim(ZOUT21))                                MD060441
      *                                                                                     MD060441
      ** Compute all-in interest rate                                                       MD060441
      *                                                                                     MD060441
     C                   EXSR      RetrieveHISTQ                                            MD061389
      *                                                                                     MD061389
     C                   CLEAR                   wrkAllInRate     11 7                      MD060441
     C                   EVAL      wrkAllInRate = WrkRate + DSBADJ                          MD060441
     C                   SELECT                                                             MD060441
     C*****DSSPIN        WHENEQ    'A'                                             MD060441 MD061389
     C**********         ADD       DSRTSP        wrkAllInRate                      MD060441 MD061389
     C     wrkSpreadInd  WHENEQ    'A'                                                      MD061389
     C                   ADD       wrkSpread     wrkAllInRate                               MD061389
     C*****DSSPIN        WHENEQ    'S'                                             MD060441 MD061389
     C**********         SUB       DSRTSP        wrkAllInRate                      MD060441 MD061389
     C     wrkSpreadInd  WHENEQ    'S'                                                      MD061389
     C                   SUB       wrkSpread     wrkAllInRate                               MD061389
     C*****DSSPIN        WHENEQ    'P'                                             MD060441 MD061389
     C*****DSRTSP        DIV       100           WRK_139          13 9             MD060441 MD061389
     C     wrkSpreadInd  WHENEQ    'P'                                                      MD061389
     C     wrkSpread     DIV       100           WRK_139          13 9                      MD061389
     C                   MULT(H)   WRK_139       wrkAllInRate                               MD060441
     C*****DSSPIN        WHENEQ    *BLANK                                                   MD060441
     C**********         ADD       DSRTSP        wrkAllInRate                               MD060441
     C     wrkSpreadInd  WHENEQ    *BLANK                                                   MD061389
     C                   ADD       wrkSpread     wrkAllInRate                               MD061389
     C                   ENDSL                                                              MD060441
     C                   Z-ADD     0             ZFLD15                                     MD060441
     C                   MOVE      wrkAllInRate  ZFLD15                                     MD060441
     C                   EVAL      ZDECS = 7                                                MD060441
     C                   CALL      'ZSEDIT'                                                 MD060441
     C                   PARM                    ZFLD15                                     MD060441
     C                   PARM                    ZDECS                                      MD060441
     C                   PARM      'J'           ZECODE                                     MD060441
     C                   PARM                    ZOUT21                                     MD060441
                                                                                            MD060441
     C                   EVALR     P2ALIN  = (%trim(ZOUT21))                                MD060441
                                                                                            MD060441
     C                   EXSR      srGetTotalInt                                            MD060441

      ** Write out Detail Record
     C                   Z-ADD     1             RQDLN1            3 0
     C     OFLLN1        SUB       PRTLN1        DIFLN1            3 0
     C     DIFLN1        IFLE      RQDLN1
     C     *IN01         OREQ      *ON
     C                   WRITE     HEADP3
     C                   MOVE      *OFF          *IN01
     C                   ENDIF
     C                   WRITE     DETLP3

     C/exec SQL
     C+ fetch next
     C+ from SDHS
     C+ into :DlyDS
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close SDHS
     C/end-exec

      ***Process*ARR*Forward*Rates************************************                      MD060897
     C**********         EVAL      XCINPDT = 0                                              MD060897
     C**********/exec SQL                                                                   MD060897
     C**********+ declare SDFW cursor for                                                   MD060897
     C**********+ select                                                                    MD060897
     C**********+   FINPSD                                                                  MD060897
     C**********+ , FINPED                                                                  MD060897
     C**********+ , FINPDT                                                                  MD060897
     C**********+ , FINPDY                                                                  MD060897
     C**********+ , FOBPDT                                                                  MD060897
     C**********+ , FOBPDY                                                                  MD060897
     C**********+ , FPBRFR                                                                  MD060897
     C**********+ , FRTEAP                                                                  MD060897
     C**********+ , FCALCM                                                                  MD060897
     C**********+ , FAVCRT                                                                  MD060897
     C**********+ , FDCMRT                                                                  MD060897
     C**********+ , FSMPAV                                                                  MD060897
     C**********+ from SDFWDRTD                                                             MD060897
     C**********+ where                                                                     MD060897
     C**********+     FMODID = 'LE'                                                         MD060897
     C**********+ and FTRNID = :KTRNID                                                      MD060897
     C**********+ and FINPSD = :XCINPSD                                                     MD060897
     C**********+ order by                                                                  MD060897
     C**********+     FINPDT asc                                                            MD060897
     C**********/end-exec                                                                   MD060897

     C**********/exec SQL                                                                   MD060897
     C**********+ open SDFW                                                                 MD060897
     C**********/end-exec                                                                   MD060897

     C**********/exec SQL                                                                   MD060897
     C**********+ fetch next                                                                MD060897
     C**********+ from SDFW                                                                 MD060897
     C**********+ into :DlyDS                                                               MD060897
     C**********/end-exec                                                                   MD060897
                                                                                            MD060897
     C**********         DOW       SQLCOD <> 100                                            MD060897
     C**********         EVAL      XCINPDT = Dintd                                          MD060897
                                                                                            MD060897
      ***Interest*Period*Date*****************************************                      MD060897
     C**********         MOVE      Dintd         ZDayNo                                     MD060897
     C**********         CALL      'ZDATE2'                                                 MD060897
     C**********         PARM                    ZDayNo                                     MD060897
     C**********         PARM                    BJDFIN                                     MD060897
     C**********         PARM      *ZERO         ZDate                                      MD060897
     C**********         PARM      *BLANKS       ZADate                                     MD060897

     C**********         EVAL      DSDATE = ZADate                                          MD060897
     C*****DSDy1         IFEQ      ' '                                                      MD060897
     C**********         EVAL      DSDy1 = '0'                                              MD060897
     C**********         ENDIF                                                              MD060897
     C**********         EVAL      P2INTD = DSDay + '-' + DSMth + '-' + DSYear              MD060897
                                                                                            MD060897
      ***Interest*Period*Days*****************************************                      MD060897
     C**********         MOVE      Dindy         WWIndyChar                                 MD060897
     C**********         EVAL      P2INDY =  %triml(WWIndyChar:'0')                         MD060897

      ***Published*Risk*Free*Rate*************************************
     C**********         Z-ADD     Dbrfr         WrkRate                                    MD060897
     C**********         Z-ADD     0             ZFLD15                                     MD060897
     C**********         MOVE      WrkRate       ZFLD15                                     MD060897
     C**********         EVAL      ZDECS = 7                                                MD060897
     C**********         CALL      'ZSEDIT'                                                 MD060897
     C**********         PARM                    ZFLD15                                     MD060897
     C**********         PARM                    ZDECS                                      MD060897
     C**********         PARM      'J'           ZECODE                                     MD060897
     C**********         PARM                    ZOUT21                                     MD060897
     C**********         EVAL      P2BRFR  = (%trim(ZOUT21))                                MD060897

      ***Rate*Applied*************************************************                      MD060897
     C**********         Z-ADD     Drtap         WrkRate                                    MD060897
     C**********         Z-ADD     0             ZFLD15                                     MD060897
     C**********         MOVE      WrkRate       ZFLD15                                     MD060897
     C**********         EVAL      ZDECS = 7                                                MD060897
     C**********         CALL      'ZSEDIT'                                                 MD060897
     C**********         PARM                    ZFLD15                                     MD060897
     C**********         PARM                    ZDECS                                      MD060897
     C**********         PARM      'J'           ZECODE                                     MD060897
     C**********         PARM                    ZOUT21                                     MD060897
     C**********         EVAL      P2RTAP  = (%trim(ZOUT21))                                MD060897

      ***Average/Compound Rate****************************************                      MD060897
     C**********         SELECT                                                             MD060897
     C**********         WHEN      Dcalm = 'CCR'                                            MD060897
     C**********         Z-ADD     Davcr         WrkRate                                    MD060897
     C**********         WHEN      Dcalm = 'NCCR'                                           MD060897
     C**********         Z-ADD     Dcmrt         WrkRate                                    MD060897
     C**********         WHEN      Dcalm = 'SAVG'                                           MD060897
     C**********         Z-ADD     Dsmav         WrkRate                                    MD060897
     C**********         WHEN      Dcalm = 'SARR'                                           MD060897
     C**********         Z-ADD     Drtap         WrkRate                                    MD060897
     C**********         ENDSL                                                              MD060897

     C**********         Z-ADD     0             ZFLD15                                     MD060897
     C**********         MOVE      WrkRate       ZFLD15                                     MD060897
     C**********         EVAL      ZDECS = 7                                                MD060897
     C**********         CALL      'ZSEDIT'                                                 MD060897
     C**********         PARM                    ZFLD15                                     MD060897
     C**********         PARM                    ZDECS                                      MD060897
     C**********         PARM      'J'           ZECODE                                     MD060897
     C**********         PARM                    ZOUT21                                     MD060897
     C**********         EVAL      P2AVCR  = (%trim(ZOUT21))                                MD060897

      ***Write*out*detail*record**************************************                      MD060897
     C**********         Z-ADD     1             RQDLN1                                     MD060897
     C*****OFLLN1        SUB       PRTLN1        DIFLN1                                     MD060897
     C*****DIFLN1        IFLE      RQDLN1                                                   MD060897
     C******IN01         OREQ      *ON                                                      MD060897
     C**********         WRITE     HEADP3                                                   MD060897
     C**********         MOVE      *OFF          *IN01                                      MD060897
     C**********         ENDIF                                                              MD060897
     C**********         WRITE     DETLP3                                                   MD060897

     C**********/exec SQL                                                                   MD060897
     C**********+ fetch next                                                                MD060897
     C**********+ from SDFW                                                                 MD060897
     C**********+ into :DlyDS                                                               MD060897
     C**********/end-exec                                                                   MD060897

     C**********         ENDDO                                                              MD060897

     C**********/exec SQL                                                                   MD060897
     C**********+ close SDFW                                                                MD060897
     C**********/end-exec                                                                   MD060897

     C                   ENDSR
      *****************************************************************                     MD060441
      /EJECT                                                                                MD060441
      *****************************************************************                     MD060441
      *                                                               *                     MD060441
      * srGetTotalInt - Compute Total Interest Amount                 *                     MD060441
      *                                                               *                     MD060441
      *****************************************************************                     MD060441
     C     srGetTotalInt BEGSR                                                              MD060441
                                                                                            MD060441
     C                   IF        Dcalm = 'NCCR' or Dcalm = 'SARR'                         MD060441
     C                   EXSR      srCalculate1                                             MD060441
     C                   ELSEIF    Dcalm = 'CCR' or Dcalm = 'SAVG'                          MD060441
     C                   EXSR      srCalculate2                                             MD060441
     C                   ENDIF                                                              MD060441
                                                                                            MD060441
     C                   ENDSR                                                              MD060441
      *****************************************************************                     MD060441
      /EJECT                                                                                MD060441
      *****************************************************************                     MD060441
      *                                                               *                     MD060441
      * srCalculate1                                                  *                     MD060441
      *                                                               *                     MD060441
      *****************************************************************                     MD060441
                                                                                            MD060441
     C     srCalculate1  BEGSR                                                              MD060441
                                                                                            MD060441
     C                   EVAL      isManualComp = *OFF                                      MD060441
                                                                                            MD060441
      ** Get current interest amount from history file                                      MD060441
                                                                                            MD060441
     C/exec SQL                                                                             MD060441
     C+ select AITC                                                                         MD060441
     C+ into :curIntrstAmt                                                                  MD060441
     C+ from HISTSHQ                                                                        MD060441
     C+ where LNRF = :KTRNID and                                                            MD060441
     C+       VDAT = :XCINPDT and                                                           MD060441
     C+       AMTP = 'BR'                                                                   MD060441
     C/end-exec                                                                             MD060441
                                                                                            MD060441
     C                   IF        ( SQLCOD <> NO_RECORD )                                  MD060441
                                                                                            MD060441
      ** Get next interest amount from history file                                         MD060441
     C/exec SQL                                                                             MD060441
     C+ select AITC                                                                         MD060441
     C+ into :nxtIntrstAmt                                                                  MD060441
     C+ from HISTSHQ                                                                        MD060441
     C+ where LNRF = :KTRNID and                                                            MD060441
     C+       AMTP = 'BR' and                                                               MD060441
     C+       VDAT > :XCINPDT                                                               MD060441
     C+ order by VDAT                                                                       MD060441
     C+ fetch first 1 row only                                                              MD060441
     C/end-exec                                                                             MD060441
                                                                                            MD060441
     C                   IF        ( SQLCOD <> NO_RECORD )                                  MD060441
     C                   EVAL      wrkIntrstAmt = nxtIntrstAmt - curIntrstAmt               MD060441
     C                   ELSE                                                               MD060441
     C                   EVAL      isManualComp = *ON                                       MD060441
     C                   ENDIF                                                              MD060441
     C                   ELSE                                                               MD060441
     C                   EVAL      isManualComp = *ON                                       MD060441
     C                   ENDIF                                                              MD060441
                                                                                            MD060441
     C                   IF        (isManualComp)                                           MD060441
                                                                                            MD060441
      ** If there are no record retrieve from history file, manually compute the            MD060441
      ** interest amount                                                                    MD060441
                                                                                            MD060441
                                                                                            MD060441
     C                   EVAL      ZIBEG = Dintd                                            MD060441
     C                   EVAL      ZIEND = Dintd + Dindy                                    MD060441
     C                   EVAL      ZIAMT = DSCPAM                                           MD060441
     C                   EVAL      ZICALC = DSICBS                                          MD060441
     C                   EVAL      ZIRATE = wrkAllInRate                                    MD060441
                                                                                            MD060441
     C                   EXSR      GLINTC                                                   MD060441
                                                                                            MD060441
     C                   EVAL (H)  wrkIntrstAmt = ZINTR                                     MD060441
     C                   ENDIF                                                              MD060441
                                                                                            MD060441
     C                   EVAL      ZFLD15 = wrkIntrstAmt                                    MD060441
     C                   EVAL      ZDECS = wrkDec                                           MD060441
     C                   CALL      'ZSEDIT'                                                 MD060441
     C                   PARM                    ZFLD15                                     MD060441
     C                   PARM                    ZDECS                                      MD060441
     C                   PARM      'J'           ZECODE                                     MD060441
     C                   PARM                    ZOUT21                                     MD060441
                                                                                            MD060441
     C                   EVALR     P2INTA  = %trim(ZOUT21)                                  MD060441
                                                                                            MD060441
     C                   ENDSR                                                              MD060441
      *****************************************************************                     MD060441
      /EJECT                                                                                MD060441
      *****************************************************************                     MD060441
      *                                                               *                     MD060441
      * srCalculate2                                                  *                     MD060441
      *                                                               *                     MD060441
      *****************************************************************                     MD060441
     C     srCalculate2  BEGSR                                                              MD060441
                                                                                            MD060441
     C                   EVAL      ZIBEG = Dintd                                            MD060441
     C                   EVAL      ZIEND = Dintd + Dindy                                    MD060441
     C                   EVAL      ZIAMT = DSCPAM                                           MD060441
     C                   EVAL      ZICALC = DSICBS                                          MD060441
     C                   EVAL      ZIRATE = wrkAllInRate                                    MD060441
                                                                                            MD060441
     C                   EXSR      GLINTC                                                   MD060441
                                                                                            MD060441
     C                   IF        isFirstRun                                               MD060441
     C                   EVAL (H)  wrkIntrstAmt = ZINTR                                     MD060441
     C                   EVAL      isFirstRun = *OFF                                        MD060441
     C                   EVAL (H)  prvIntrstAmt = ZINTR                                     MD060441
     C                   ELSE                                                               MD060441
     C                   EVAL (H)  wrkIntrstAmt = ZINTR                                     MD060441
     C                   EVAL      wrkIntrstAmt = wrkIntrstAmt - prvIntrstAmt               MD060441
     C                   EVAL (H)  prvIntrstAmt = ZINTR                                     MD060441
     C                   ENDIF                                                              MD060441
     C                                                                                      MD060441
                                                                                            MD060441
     C                   EVAL      ZFLD15 = wrkIntrstAmt                                    MD060441
     C                   EVAL      ZDECS = wrkDec                                           MD060441
     C                   CALL      'ZSEDIT'                                                 MD060441
     C                   PARM                    ZFLD15                                     MD060441
     C                   PARM                    ZDECS                                      MD060441
     C                   PARM      'J'           ZECODE                                     MD060441
     C                   PARM                    ZOUT21                                     MD060441
                                                                                            MD060441
     C                   EVALR     P2INTA  = %trim(ZOUT21)                                  MD060441
     C                                                                                      MD060441
     C                   ENDSR                                                              MD060441

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SREndRPT - Write End of Report Line and Close the File        *
      *                                                               *
      *****************************************************************
     C     SREndRPT      BEGSR


      ** If report file is opened, write the End of Report line
     C                   IF        WOPNP1 = 'Y'

      ** Write out end of report format
     C                   Z-ADD     2             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C     *IN01         OREQ      *ON
     C                   WRITE     HEADP3
     C                   MOVE      *OFF          *IN01
     C                   ENDIF

     C                   WRITE     ENDREP
     C                   CLOSE     LE000372P1
     C                   EVAL      WOPNP1 = 'N'

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

      ** Initialize report work variables

     C                   EVAL      WOPNP1 = 'N'

      ** Program Parameters

     C     *ENTRY        PLIST
     C                   PARM                    PSEQ
     C                   PARM                    SENTY
     C                   PARM                    RPRNT

      ** Initialize Work fields
     C                   EVAL      DBPGM = 'LE000372'

      ** Access Bank Details
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Database error
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  = 001
     C                   EVAL      DBKEY  = POPTN
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      DSDATE = BJMRDT
     C     DSDy1         IFEQ      ' '
     C                   Eval      DSDy1 = '0'
     C                   Endif
     C                   EVAL      P1Date = DSDay + '-' + DSMth + '-' + DSYear

      ** System value check
     C                   EVAL      PrintP3 = *BLANKS
     C                   EVAL      P@OP01 = 'PrintIntPeriodDetail'
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    P@OP01
     C                   PARM      *BLANKS       P@VL01
     C                   PARM                    P@OP02
     C                   PARM      *BLANKS       P@VL02
     C                   PARM                    P@OP03
     C                   PARM      *BLANKS       P@VL03
     C                   PARM                    P@OP04
     C                   PARM      *BLANKS       P@VL04
     C                   PARM                    P@OP05
     C                   PARM      *BLANKS       P@VL05
     C                   PARM                    P@OP06
     C                   PARM      *BLANKS       P@VL06
     C                   PARM                    P@OP07
     C                   PARM      *BLANKS       P@VL07
     C                   PARM                    P@OP08
     C                   PARM      *BLANKS       P@VL08
     C                   PARM                    P@OP09
     C                   PARM      *BLANKS       P@VL09
     C                   PARM                    P@OP10
     C                   PARM      *BLANKS       P@VL10

     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      DBASE = 002
     C                   EVAL      DBFILE = 'SDSVALPD'
     C                   EVAL      DBKEY = P@OP01
     C                   EVAL      DBPGM = 'AOSVALR0'
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      PrintP3 = P@VL01
     C                   ENDIF

     C     KLIBR         KLIST
     C                   KFLD                    KSCFLD            8
     C                   KFLD                    KINVAL           10

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
      *****************************************************************
     C     *PSSR         BEGSR

     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR
      *****************************************************************
     C/COPY ZSRSRC,ZINTDYZ2LE
     C/COPY ZSRSRC,ZDATE9Z3LE
     C/COPY ZSRSRC,ZDAT10Z2LE
     C/COPY ZSRSRC,GLINTCZ1LE                                                               MD060441
