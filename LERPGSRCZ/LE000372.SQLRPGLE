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
      *  Last Amend No. MD058517 *CREATE    Date 17Oct22              *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
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
     FSDRTKNTD  UF   E             DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
      ** Midas SD Array of Text Table
     FSDARRTTD  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Midas SD ARR Calculator Parameter Details
     FSDLIBRTD  IF   E           K DISK    INFSR(*PSSR)
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

      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN PROCESSING                                               *
      *****************************************************************

      ** Read records from LE Rate Known Loans Files File

     C                   READ      SDRTKNTD                               40
     C     *IN40         DOWEQ     *OFF
     C                   IF        KMODID = 'LE' AND KRTKNI = 'Y' AND
     C                             (KCINTA <> KPINTA OR KSPLFP <> 'Y'
     C                              OR RPRNT = 'Y')
     C/exec SQL
     C+ declare CLOA cursor for
     C+ select
     C+   CNUM
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
     C+ from CLOANCL
     C+ where
     C+     LNRF = :KTRNID
     C/end-exec

     C/exec SQL
     C+ open CLOA
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from CLOA
     C+ into :LoanDS
     C/end-exec

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

     C                   CLEAR                   DlyDS
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

      ** Interest Rate
     C     DSCalm        IFEQ      'CCR'
     C     DSCalm        OREQ      'SAVG'

     C                   SELECT
     C     DSCalm        WHENEQ    'CCR'
     C     Davcr         ADD(H)    DSBADJ        WIntr

     C     DSCalm        WHENEQ    'SAVG'
     C     Dsmav         ADD(H)    DSBADJ        WIntr
     C                   ENDSL

     C                   SELECT
     C     DSSPIN        WHENEQ    'A'
     C                   ADD(H)    DSRTSP        WIntr
     C     DSSPIN        WHENEQ    'S'
     C                   SUB(H)    DSRTSP        WIntr
     C     DSSPIN        WHENEQ    'P'
     C     DSRTSP        DIV       100           WRK_139          13 9
     C                   MULT(H)   WRK_139       WIntr
     C     DSSPIN        WHENEQ    *BLANK
     C                   ADD(H)    DSRTSP        WIntr
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

     C/exec SQL
     C+ close FWCursor
     C/end-exec

      ** Principal Amount
     C                   EVAL      P1CCY  = DSccy

     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    DSCCY
     C     SDCURR        PARM      SDCURR        DSSDY

     C                   EVAL      ZFLD15 = DSCPAM
     C                   EVAL      ZDECS = A6NBDP

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


     C/exec SQL
     C+ close CLOA
     C/end-exec

      ** Write Detail
     C                   EXSR      SRReportP1
     C                   EXSR      SRReportP2

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

     C                   ENDIF

     C                   READ      SDRTKNTD                               40
     C                   ENDDO

      ** End Program
     C                   COMMIT
     C                   EVAL      *INLR = *ON
     C                   RETURN

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
     C     'LE000372  '  CHAIN     SDARRTTD                           41
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
     C     KLIBR         CHAIN     SDLIBRTD                           42
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
     C     KLIBR         CHAIN     SDLIBRTD                           42
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
     C+ order by
     C+     CINPDT asc
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
     C                   EVAL      P2INDY =  %triml(WWIndyChar:'0')

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
     C                   EVAL      P2BRFR  = (%trim(ZOUT21))

      ** Rate Applied
     C                   Z-ADD     Drtap         WrkRate
     C                   Z-ADD     0             ZFLD15
     C                   MOVE      WrkRate       ZFLD15
     C                   EVAL      ZDECS = 7
     C                   CALL      'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM                    ZDECS
     C                   PARM      'J'           ZECODE
     C                   PARM                    ZOUT21
     C                   EVAL      P2RTAP  = (%trim(ZOUT21))

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
     C                   EVAL      P2AVCR  = (%trim(ZOUT21))

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

      ** Process ARR Forward Rates
     C                   EVAL      XCINPDT = 0
     C/exec SQL
     C+ declare SDFW cursor for
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
     C+     FMODID = 'LE'
     C+ and FTRNID = :KTRNID
     C+ and FINPSD = :XCINPSD
     C+ order by
     C+     FINPDT asc
     C/end-exec

     C/exec SQL
     C+ open SDFW
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from SDFW
     C+ into :DlyDS
     C/end-exec

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
     C                   EVAL      P2INDY =  %triml(WWIndyChar:'0')

      ** Published Risk Free Rate
     C                   Z-ADD     Dbrfr         WrkRate
     C                   Z-ADD     0             ZFLD15
     C                   MOVE      WrkRate       ZFLD15
     C                   EVAL      ZDECS = 7
     C                   CALL      'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM                    ZDECS
     C                   PARM      'J'           ZECODE
     C                   PARM                    ZOUT21
     C                   EVAL      P2BRFR  = (%trim(ZOUT21))

      ** Rate Applied
     C                   Z-ADD     Drtap         WrkRate
     C                   Z-ADD     0             ZFLD15
     C                   MOVE      WrkRate       ZFLD15
     C                   EVAL      ZDECS = 7
     C                   CALL      'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM                    ZDECS
     C                   PARM      'J'           ZECODE
     C                   PARM                    ZOUT21
     C                   EVAL      P2RTAP  = (%trim(ZOUT21))

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
     C                   EVAL      P2AVCR  = (%trim(ZOUT21))

      ** Write out detail record
     C                   Z-ADD     1             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C     *IN01         OREQ      *ON
     C                   WRITE     HEADP3
     C                   MOVE      *OFF          *IN01
     C                   ENDIF
     C                   WRITE     DETLP3

     C/exec SQL
     C+ fetch next
     C+ from SDFW
     C+ into :DlyDS
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close SDFW
     C/end-exec

     C                   ENDSR
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
