     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2023')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas LE Loan Advice with Fwd ARR Rates')              *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  XX0372P - LE Loan Advice with Fwd ARR Rates                  *
      *                                                               *
      *  Function:  This program will generate Loan Advices for the   *
      *             loans set as Rate Known with interest due         *
      *             which includes forward ARR rates.                 *
      *                                                               *
      *  Called By: XXC0370 - Midas LE ARR Fwd Rates                  *
      *                                                               *
      *  (c) Finastra International Limited 2023                      *
      *                                                               *
      *  Last Amend No. MD061164 *CREATE   Date 03May23               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD061164 - LE ARR - Forward rates and new report changes.    *
      *             Formalise codes introduced by ARR_CC10, EF010822, *
      *             EF270622, AM070622, EF250522, EF230522, and ARRLOR*
      *           - ARR_CC10 - Add page with breakdown of Interest    *
      *           - EF010822 - Recompile due to PRTF changes          *
      *           - EF270622 - Do not display rate if not CCR         *
      *           - AM070622 - Amend page width to 90 and fit btn     *
      *             posns 9-81 (Recompile)                            *
      *           - EF250522 - Define report in RCF                   *
      *           - EF230522 - Include latest Interest rate in XX0371 *
      *           - ARRLOR - LE Loan Advice with Fwd ARR Rates        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  USE OF INDICATORS                                            *
      *                                                               *
      *    U7         Database error                                  *
      *    U8         Database error                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *                                                               *
      *****************************************************************

     FXXRTKNTD  IF   E             DISK    INFSR(*PSSR)

      ** Report File
     FXX0372P1  O    E             PRINTER USROPN
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

     D DSDate          DS             7
     D  DSDy1                  1      1
     D  DSDay                  1      2
     D  DSMth                  3      5
     D  DSYear                 6      7

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

      ** Access Object Variables
     D PRTCD           S              7A
     D POPTN           S              7A

      ** Report Variables
     D RQDLN1          S              3S 0
     D DIFLN1          S              3S 0
     D WOPNP1          S              1A
      *
      ** Entry Parameters for AOCUSTR0
     D @RtCd           S              7
     D @Optn           S              7
     D @Key10          S             10
     D @KySt           S              7

     D WWCust          S             10
     D PInta           S             13P 0
     D PNidt           S              5P 0
     D WWNrdy          S              4S 0
     D WWNrdyChar      S              4A
     D WWIndyChar      S              5A
     D XCINPDT         S              5  0
     D XCINPSD         S              5  0
     D XFTRNID         S              6
     D Prv_ZIEND       S              5P 0

      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN PROCESSING                                               *
      *****************************************************************

      ** Initialize Report Work Variables
     C                   EVAL      WOPNP1 = 'N'

     C                   Read      XXRTKNTD                               40
     C     *IN40         Doweq     *Off
     C
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
     C+ from CLOANCL
     C+ where
     C+     LNRF = :FTRNID
     C/end-exec

     C/exec SQL
     C+ open CLOA
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from CLOA
     C+ into :LoanDS
     C/end-exec

      *
      ** Transaction reference
      *
     C                   Eval      P1LNRF = FTRNID
      *
      ** Customer
     C                   Eval      P1CUST = DSCnum
      *
     C                   Eval      WWCust = DSCnum
     C                   Call      'AOCUSTR0'
     C                   Parm      *BLANKS       @RtCd
     C                   Parm      '*KEY   '     @Optn
     C                   Parm      WWCust        @Key10
     C                   Parm      *BLANKS       @KySt
     C     SDCUST        Parm      SDCUST        DSSDY
      *
     C                   If        @RtCd <> *BLANKS
     C     *LOCK         In        LDA
     C                   Eval      DBFile = 'SDCUSTPD'
     C                   Z-Add     901           DBase
     C                   Eval      DBKey = DSCnum
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   else
     C                   Eval      P1CNA1 = BBCNA1
     C                   Eval      P1CNA2 = BBCNA2
     C                   Eval      P1CNA3 = BBCNA3
     C                   Eval      P1CNA4 = BBCNA4
     C                   Endif
      *
      ** Int Start date
      *
     C                   If        DSSLID <> 0
     C                   Eval      ZDayNo = DSSLID
     C                   else
     C                   Eval      ZDayNo = DSVDAT
     C                   Endif
      *
     C                   Call      'ZDATE2'
     C                   Parm                    ZDayNo
     C                   Parm                    BJDFIN
     C                   Parm      *Zero         ZDate
     C                   Parm      *BLanks       ZADate
      *
     C                   Eval      DSDATE = ZADate
     C     DSDy1         Ifeq      ' '
     C                   Eval      DSDy1 = '0'
     C                   Endif
     C                   Eval      P1SLID = DSDay + '-' + DSMth + '-' + DSYear
      *
      ** Next Int pay date
      *
     C     DSNidt        Ifne      0
     C                   z-add     DSNidt        PNIDT
     C                   else
     C     DSRept        Ifeq      3
     C     DSNrpd        andne     0
     C                   z-add     DSNrpd        PNIDT
     C                   else
     C                   z-add     DSMdat        PNIDT
     C                   Endif
     C                   Endif
      *
     C                   Eval      ZDayNo = PNIDT
     C                   Call      'ZDATE2'
     C                   Parm                    ZDayNo
     C                   Parm                    BJDFIN
     C                   Parm      *Zero         ZDate
     C                   Parm      *BLanks       ZADate
      *
     C                   Eval      DSDATE = ZADate
     C     DSDy1         Ifeq      ' '
     C                   Eval      DSDy1 = '0'
     C                   Endif
     C                   Eval      P1NIDT = DSDay + '-' + DSMth + '-' + DSYear
      *
      ** Number of days  - might need changes (-1 day), Arthur to check with BMI ..

     C                   If        DSSLID <> 0
     C     PNidt         Sub       DSSLid        WWNrdy
     C                   else
     C     PNidt         Sub       DSVdat        WWNrdy
     C                   Endif

     C                   Move      WWNrdy        WWNrdyChar
     C                   Eval      WWNrdyChar =  %triml(WWNrdyChar:'0')

     C                   Eval      P1NRDY = '('+(%trim(WWNrdyChar))+' days'+ ')'
      *
      ** Principal Amount
     C                   EVAL      P1CCY  = DSccy

     C                   Call      'AOCURRR0'
     C                   Parm      *BLANKS       PRTCD
     C                   Parm      '*KEY   '     POPTN
     C                   Parm                    DSCCY
     C     SDCURR        Parm      SDCURR        DSSDY

     C                   Eval      ZFLD15 = DSCPAM
     C                   Eval      ZDECS = A6NBDP

     C                   Call      'ZSEDIT'
     C                   Parm                    ZFLD15
     C                   Parm                    ZDECS
     C                   Parm      'J'           ZECODE
     C                   Parm                    ZOUT21

     C                   Eval      P1CPAM  = %trim(ZOUT21)
      *
      ** Interest due Amount

     C                   EVAL      P1ICCY  = DSccy

     C                   z-add     0             PInta
     C                   Call      'XX0371'
     C                   Parm      *BLANKS       PRTCD
     C                   Parm                    FTRNID
     C                   Parm                    PInta
     C                   Parm                    PZIRate          11 7

     C                   Eval      ZFLD15 = PInta

     C                   Call      'ZSEDIT'
     C                   Parm                    ZFLD15
     C                   Parm                    ZDECS
     C                   Parm      'J'           ZECODE
     C                   Parm                    ZOUT21

     C                   Eval      P1INTA  = %trim(ZOUT21)

      *
      ** Interest Rate

     C     DSCalm        Ifeq      'CCR'
     C                   Move      PZIRate       ZFLD15
     C                   Eval      ZDECS = 7

     C                   Call      'ZSEDIT'
     C                   Parm                    ZFLD15
     C                   Parm                    ZDECS
     C                   Parm      'J'           ZECODE
     C                   Parm                    ZOUT21

     C                   Eval      P1INTR  = (%trim(ZOUT21)) + ' % P.A.'
     C                   else
     C                   Eval      P1INTR  = *Blanks
     C                   Endif

     C/exec SQL
     C+ close CLOA
     C/end-exec

      ** Write Detail
     C                   EXSR      SRReportP1
     C     DSCalm        Ifeq      'NCCR'
     C                   EXSR      SRReportP2
     C                   Endif

      ** Close file
     C                   EXSR      SREndRPT

     C                   Read      XXRTKNTD                               40
     C                   Enddo

      ** End Program
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
     C                   OPEN      XX0372P1
     C                   EVAL      WOPNP1 = 'Y'
     C                   ENDIF

     C                   Z-Add     SFNUM1        ZSNUM             6 0
     C                   Move      *Blanks       @Brca             3
      *
     C                   Call      'ZSFILE'
     C                   Parm                    SEQR              5
     C                   Parm      @Brca         SENTY             3
     C                   Parm                    SFILE1
     C                   Parm                    ZSNUM
     C                   Parm                    ZSERR             1
      *
      ** Error during ZSFILE processing, end pgm.
      *
     C     ZSERR         Ifne      ' '
     C                   Eval      *InU7 = *On
     C                   Eval      *InU8 = *On
     C                   Eval      *InLR = *On
     C                   Return
     C                   Endif
      *
      ** Write out Detail Record
     C                   WRITE     DETLP1

      ** Write out Trailer Format
     C                   WRITE     TRAILP1

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRReportP2 - Period detail page                               *
      *                                                               *
      *****************************************************************
     C     SRReportP2    Begsr

     C                   z-add     0             XCINPSD
     C                   z-add     DSICBS        ZICALC
     C                   z-add     DSCPAM        ZIAMT
     C                   z-add     DSINTR        ZIRATE
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
     C+ and CTRNID = :FTRNID
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

     C                   If        SQLCOD <> 100
     C                   eval      XCINPSD = DintStart
     C                   WRITE     HEADP2
     C                   Endif

     C                   DOW       SQLCOD <> 100
     C                   eval      XCINPDT = Dintd

      **  Interest Period Date
     C                   Move      Dintd         ZDayNo
     C                   Call      'ZDATE2'
     C                   Parm                    ZDayNo
     C                   Parm                    BJDFIN
     C                   Parm      *Zero         ZDate
     C                   Parm      *BLanks       ZADate
      *
     C                   Eval      DSDATE = ZADate
     C     DSDy1         Ifeq      ' '
     C                   Eval      DSDy1 = '0'
     C                   Endif
     C                   Eval      P2INTD = DSDay + '-' + DSMth + '-' + DSYear

      **  Interest Period Days
     C                   Move      Dindy         WWIndyChar
     C                   Eval      P2INDY =  %triml(WWIndyChar:'0')

      **  Published Risk Free Rate
     C                   z-add     Dbrfr         WrkRate          11 7
     C                   z-add     0             ZFLD15
     C                   Move      WrkRate       ZFLD15
     C                   Eval      ZDECS = 7
     C                   Call      'ZSEDIT'
     C                   Parm                    ZFLD15
     C                   Parm                    ZDECS
     C                   Parm      'J'           ZECODE
     C                   Parm                    ZOUT21
     C                   Eval      P2BRFR  = (%trim(ZOUT21))

      **  Rate Applied (calculated)
     C                   Exsr      SRNEWI
     C                   z-add     0             ZFLD15
     C                   Move      ZIRATE        ZFLD15
     C                   Eval      ZDECS = 7
     C                   Call      'ZSEDIT'
     C                   Parm                    ZFLD15
     C                   Parm                    ZDECS
     C                   Parm      'J'           ZECODE
     C                   Parm                    ZOUT21
     C                   Eval      P2RTAP  = (%trim(ZOUT21))

      *
      ** Interest amount

     C                   z-add     0             PInta
     C                   z-add     DIntd         ZIBEG

     C     DIntd         add       DIndy         ZIEND
     C                   Exsr      GLINTC
     C                   Add(H)    ZINTR         PInta

     C                   z-add     0             ZFLD15
     C                   Eval      ZFLD15 = PInta
     C                   Eval      ZDECS = A6NBDP

     C                   Call      'ZSEDIT'
     C                   Parm                    ZFLD15
     C                   Parm                    ZDECS
     C                   Parm      'J'           ZECODE
     C                   Parm                    ZOUT21
     C                   Eval      P2INTA  = %trim(ZOUT21)
      *
      ** Write out Detail Record
      *
     C                   Z-Add     1             RQDLN1            3 0
     C     OFLLN1        Sub       PRTLN1        DIFLN1            3 0
     C     DIFLN1        Ifle      RQDLN1
     C     *IN01         oreq      *On
     C                   Write     HeadP2
     C                   move      *Off          *IN01
     C                   Endif
     C                   WRITE     DETLP2

     C/exec SQL
     C+ fetch next
     C+ from SDHS
     C+ into :DlyDS
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close SDHS
     C/end-exec

      ** Process ARR forward rates
     C                   eval      XCINPDT = 0
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
     C+ and FTRNID = :FTRNID
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
     C                   eval      XCINPDT = Dintd

      **  Interest Period Date
     C                   Move      Dintd         ZDayNo
     C                   Call      'ZDATE2'
     C                   Parm                    ZDayNo
     C                   Parm                    BJDFIN
     C                   Parm      *Zero         ZDate
     C                   Parm      *BLanks       ZADate
      *
     C                   Eval      DSDATE = ZADate
     C     DSDy1         Ifeq      ' '
     C                   Eval      DSDy1 = '0'
     C                   Endif
     C                   Eval      P2INTD = DSDay + '-' + DSMth + '-' + DSYear
      *
      **  Interest Period Days
     C                   Move      Dindy         WWIndyChar
     C                   Eval      P2INDY =  %triml(WWIndyChar:'0')

      **  Published Risk Free Rate
     C                   Z-Add     Dbrfr         WrkRate
     C                   Z-Add     0             ZFLD15
     C                   Move      WrkRate       ZFLD15
     C                   Eval      ZDECS = 7
     C                   Call      'ZSEDIT'
     C                   Parm                    ZFLD15
     C                   Parm                    ZDECS
     C                   Parm      'J'           ZECODE
     C                   Parm                    ZOUT21
     C                   Eval      P2BRFR  = (%trim(ZOUT21))

      **  Rate Applied (calculated)
     C                   Exsr      SRNEWI
     C                   Z-Add     0             ZFLD15
     C                   Move      ZIRATE        ZFLD15
     C                   Eval      ZDECS = 7
     C                   Call      'ZSEDIT'
     C                   Parm                    ZFLD15
     C                   Parm                    ZDECS
     C                   Parm      'J'           ZECODE
     C                   Parm                    ZOUT21
     C                   Eval      P2RTAP  = (%trim(ZOUT21))

      *
      ** Interest amount

     C                   z-add     0             PInta
     C                   z-add     DIntd         ZIBEG

     C     DIntd         add       DIndy         ZIEND
     C                   Exsr      GLINTC
     C                   Add(H)    ZINTR         PInta

     C                   Z-Add     0             ZFLD15
     C                   Eval      ZFLD15 = PInta
     C                   Eval      ZDECS = A6NBDP

     C                   Call      'ZSEDIT'
     C                   Parm                    ZFLD15
     C                   Parm                    ZDECS
     C                   Parm      'J'           ZECODE
     C                   Parm                    ZOUT21
     C                   Eval      P2INTA  = %trim(ZOUT21)
      *
      ** Write out Detail Record
      *
     C                   Z-Add     1             RQDLN1            3 0
     C     OFLLN1        Sub       PRTLN1        DIFLN1            3 0
     C     DIFLN1        Ifle      RQDLN1
     C     *IN01         oreq      *On
     C                   Write     HeadP2
     C                   move      *Off          *IN01
     C                   Endif
     C                   WRITE     DETLP2

     C/exec SQL
     C+ fetch next
     C+ from SDFW
     C+ into :DlyDS
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close SDFW
     C/end-exec
     C                   Endsr

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNEWI - Calculate Rate                                      *
      *                                                               *
      *****************************************************************
     C     SRNEWI        BEGSR
      *
     C                   Z-Add     0             ZIRATE
      *
     C                   Select
     C     DSCalm        Wheneq    'NCCR'
     C                   Z-Add     DCmrt         WrkRate
     C     WrkRate       add       DSBadj        ZIRATE
     C     DSCalm        Wheneq    'CCR'
     C                   Z-Add     DAvcr         WrkRate
     C     WrkRate       add       DSBadj        ZIRATE
     C     DSCalm        Wheneq    'SARR'
     C                   Z-Add     DRtap         WrkRate
     C     WrKRate       add       DSBadj        ZIRATE
     C     DSCalm        Wheneq    'SAVG'
     C                   Z-Add     DSmav         WrkRate
     C     WrkRate       add       DSBadj        ZIRATE
     C                   Endsl

     C                   Select
     C                   When      DSSPIN ='A'
     C     ZIRATE        ADD       DSRTSP        ZIRATE
     C                   When      DSSPIN ='S'
     C     ZIRATE        SUB       DSRTSP        ZIRATE
     C                   When      DSSPIN ='P'
     C     DSRTSP        DIV       100           WWORK            11 9
     C     ZIRATE        MULT      WWORK         ZIRATE
     C                   Endsl
      *
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

      ** Write out Trailer Format
     C                   Close     XX0372P1
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

      ** Initialize Work fields
     C                   EVAL      DBPGM = 'XX0372P'

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
      *
     C                   EVAL      DSDATE = BJMRDT
     C     DSDy1         Ifeq      ' '
     C                   Eval      DSDy1 = '0'
     C                   Endif
     C                   EVAL      P1Date = DSDay + '-' + DSMth + '-' + DSYear


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
     C/COPY ZSRSRC,GLINTCZ1LE
     C/COPY ZSRSRC,ZINTDYZ2LE
     C/COPY ZSRSRC,ZDATE9Z3LE
     C/COPY ZSRSRC,ZDAT10Z2LE
