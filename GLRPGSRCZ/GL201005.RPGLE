     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2023')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*E*I****TEXT('Midas*GL*Today's*Transfer*Postings*Report')*************                     MD062120
/*EXI *  TEXT('Midas GL Todays Transfer Postings Report')             *                     MD062120
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  RPGLE/GL201005 - Midas GL Today's Transfer Postings Report   *
      *                                                               *
      *  Function:  The bank is changing their system to do Foreign   *
      *  (CoB)      Currency Transfer daily from the present month-end*
      *             transfer.  They would like the information about  *
      *             the amount transferred from respective currencies *
      *             to base currency to be reported in two revised    *
      *             formats for (1) Head Office and (2) the local     *
      *             Singapore branch. In addition, (3) a third report *
      *             will be produced as a transaction-based audit     *
      *             trail.                                            *
      *                                                               *
      *  Called from: Program GLC201001                               *
      *                                                               *
      *  (c) Finastra International Limited 2023                      *
      *                                                               *
      *  Last Amend No. MD062120           Date 21Nov23               *
      *  Prev Amend No. AR854120           Date 22Sep23               *
      *                 CGL201 *Create     Date 22Sep23               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD062120 - LBBW ASIA CAR Upgrade to FM2021.G - fixes         *
      *  AR854120  - Seoul reports with SUMMARY FOR SINGAPORE BRANCH -*
      *              Added variable field to pass correct header      *
      *              statement for the Country Code (Child: AR854121) *
      *  CGL201 - New Reports for Daily Transfer of Foreign Exchange  *
      *                                                               *
      *****************************************************************
     FGLACTPL0  IF   E           K DISK    INFSR(*PSSR)

     FGLACTPL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLACTPD0:GLACTPP1)

     FGLTFRPL0  IF   E           K DISK    INFSR(*PSSR)

     FGLAPSTL1  IF   E           K DISK    INFSR(*PSSR)

     FGL201005P1O    E             PRINTER USROPN
     F                                     INFDS(SPOOL1)

     FGL201005P2O    E             PRINTER USROPN
     F                                     INFDS(SPOOL2)

     FGL201005P3O    E             PRINTER USROPN
     F                                     INFDS(SPOOL3)
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   37  - Multibranching ON                                     *
      *   98  - Date Format: DDMMYY (off); MMDDYY (on)                *
      * 90-99 - Used by Standard Subroutines                          *
      *                                                               *
      * U7+U8 - Database Error                                        *
      *                                                               *
      *****************************************************************
      /SPACE 3
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  *INZSR  - Program initialization                             *
      *  SrHoRpt - Head Office report                                 *
      *  SrSngRpt - Singapore Branch report                           *
      *  SrTotalsP2 - Totals routine for Singapore branch report      *
      *  SrDtlRpt - Transaction-based reporting                       *
      *  SrPostings - Detail postings for Transaction-based report    *
      *  SrTotalsP3 - Totals routine for Transaction-based report     *
      *  SrTrailP1 - P1 report trailer                                *
      *  SrTrailP2 - P2 report trailer                                *
      *  SrTrailP3 - P3 report trailer                                *
      *  SrRCFP1 - RCF processing                                     *
      *  *PSSR   - Program Error Processing Subroutine                *
      *  SrR2HSUM - Country Code header summary statement             *
      *                                                               *
      *****************************************************************
     D/EJECT

     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      ** Array containing Copyright statement

     D ARRY            S             30A   DIM(2) CTDATA                                    AR854120
      ** Array for Country Code header summary statement                                    AR854120
      *                                                                                     AR854120
      /SPACE 3
     D LDA           E DS           256    EXTNAME(LDA)
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      ** Data Area giving Installation Control Details

     D PSDS           SDS
      ** Program Status Data Structure
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263

     D SPOOL1          DS
      ** File Information Data Structure for GL201005P1
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0

     D SPOOL2          DS
      ** File Information Data Structure for GL201005P2
     D  SFILE2                83     92
     D  SFNUM2               123    124B 0
     D  OFLLN2               188    189B 0
     D  PRTLN2               367    368B 0

     D SPOOL3          DS
      ** File Information Data Structure for GL201005P3
     D  SFILE3                83     92
     D  SFNUM3               123    124B 0
     D  OFLLN3               188    189B 0
     D  PRTLN3               367    368B 0

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, short DS

     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for access programs, long DS

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External data structures for Bank details

     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External data structures for Currencies details

     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** External data structures for Branch details

     D                 DS
     D ZOUT20                  1     20A
     D ZOUT21                  1     21A

     D SVBRCA          S              3A
     D SVACOD          S             10S 0
     D SVCCY           S              3A
     D WDIFLIN         S              3P 0
     D CCYPSTA         S             15P 0
     D CCYBSTA         S             23P 8
     D WNUM238         S             23P 8
     D ZDAYNO          S              5P 0
     D ZCHR01          S              1A
     D ZDATE6          S              6P 0
     D ZDATE7          S              7A
     D ZRTN1           S              1A
     D ZDATE8          S              8P 0
     D ZDECS           S              1P 0
     D ZNUM15          S             15P 0
     D I               S              1P 0

      ** Global fields
      ** -------------

     D BCYNDP          S              1S 0
      ** Base currency's number of decimal places

     D WOPNP1          S               N   INZ(*OFF)
      ** P1 is open if this indicator is on

     D WOPNP2          S               N   INZ(*OFF)
      ** P2 is open if this indicator is on

     D WOPNP3          S               N   INZ(*OFF)
      ** P3 is open if this indicator is on

     C/TITLE Main Processing
      *================================================================
      *  P R O G R A M   S T A R T                                    *
      *================================================================

      ** Head Office Reporting
     C                   EXSR      SrHoRpt

      ** Singapore Office Reporting
     C                   EXSR      SrSngRpt

      ** Audit Detail Reporting
     C                   EXSR      SrDtlRpt

     C                   SETON                                        LR

      *================================================================
      *  P R O G R A M   E N D                                        *
      *================================================================
     C/EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Subroutine to do program initialisation.            *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C     K_GLTFRP      KLIST
     C                   KFLD                    TDBRCA
     C                   KFLD                    TDCCY
     C                   KFLD                    TDACOD

      ** Set up copyright parameter

     C                   MOVEA     CPY@          CPY2@            80

      ** Initialise LDA field.

     C                   MOVEL     PGM           DBPGM

      ** Access Bank ICD

     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       WRTCD             7
     C                   PARM      '*FIRST '     WOPTN             7
     C     SDBANK        PARM      *BLANKS       DSFDY

      ** Handle Database Error.

     C     WRTCD         IFNE      *BLANKS
     C                   MOVE      'SDBANKPD'    DBFILE
     C                   MOVEL(P)  WOPTN         DBKEY
     C                   Z-ADD     001           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Check System Date Format, DDMMYY (*IN98 off)
      **                           MMDDYY (*IN98 on).

     C     BJDFIN        IFEQ      'M'
     C                   SETON                                        98
     C                   ENDIF

      ** Access base currency details

     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       WRTCD
     C                   PARM      '*KEY   '     WOPTN
     C                   PARM      BJCYCD        WCHR03
     C     SDCURR        PARM      *BLANKS       DSSDY
     C     WRTCD         IFNE      *BLANKS
     C                   MOVE      'SDCURRPD'    DBFILE
     C                   MOVEL(P)  TFCCY         DBKEY
     C                   Z-ADD     002           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   Z-ADD     A6NBDP        BCYNDP

      ** Access RUNDAT for multibranching indicator

     C     *DTAARA       DEFINE                  RUNDAT
     C     *DTAARA       DEFINE                  LDA
     C                   IN        RUNDAT

     C     AGMBIN        IFEQ      'Y'
     C                   SETON                                        37
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /TITLE SR/SrHoRpt
      *****************************************************************
      *                                                               *
      *  SrHoRpt - Head Office report.                                *
      *                                                               *
      *****************************************************************
     C     SrHoRpt       BEGSR

      ** Initialization
      ** --------------

     C                   MOVEL     *BLANKS       SVBRCA
     C                   Z-ADD     0             SVACOD

      ** Read first record from File.

     C                   READ      GLACTPL0

      ** Do while not end of file
      ** ------------------------

     C                   DOW       NOT %EOF(GLACTPL0)

      ** Change in branch
      ** ----------------

     C     SVBRCA        IFNE      TFBRCA

      ** Close the previous branch report
     C     SVBRCA        IFNE      *BLANKS
     C                   EXSR      SrTrailP1
     C                   CLOSE     GL201005P1
     C                   MOVE      *OFF          WOPNP1
     C                   ENDIF

      ** Access details of the current branch
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       WRTCD
     C                   PARM      '*KEY   '     WOPTN
     C                   PARM      TFBRCA        WCHR03
     C     SDBRCH        PARM      *BLANKS       DSSDY
     C     WRTCD         IFNE      *BLANKS
     C                   MOVE      'SDBRCHPD'    DBFILE
     C                   MOVEL(P)  TFBRCA        DBKEY
     C                   Z-ADD     003           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Set up report of the current branch
     C                   OPEN      GL201005P1
     C                   MOVE      *ON           WOPNP1
     C                   MOVEL(P)  SFILE1        SFILE
     C                   Z-ADD     SFNUM1        ZSNUM
     C                   EXSR      SrRCFP1
     C                   WRITE     HEADP1

     C                   MOVEL     TFBRCA        SVBRCA

     C                   ENDIF

      ** Change in Account Code
      ** ----------------------

     C     SVACOD        IFNE      TFACOD

     C     SVACOD        IFNE      0
     C     OFLLN1        SUB       PRTLN1        WDIFLIN
     C     WDIFLIN       IFLE      1
     C                   WRITE     HEADP1
     C                   ELSE
     C                   WRITE     BLANKP1
     C                   ENDIF
     C                   ENDIF

     C                   Z-ADD     TFACOD        SVACOD

     C                   ENDIF

      ** Detail report preparation
      ** -------------------------

      ** Retrieve currency details
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       WRTCD
     C                   PARM      '*KEY   '     WOPTN
     C                   PARM      TFCCY         WCHR03            3
     C     SDCURR        PARM      *BLANKS       DSSDY
     C     WRTCD         IFNE      *BLANKS
     C                   MOVE      'SDCURRPD'    DBFILE
     C                   MOVEL(P)  TFCCY         DBKEY
     C                   Z-ADD     004           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Branch
     C                   MOVE      TFBRCA        R1BRCH

      ** Value Date
     C                   CALL      'ZA0140'
     C                   PARM      TFVALD        ZDAYNO
     C                   PARM      BJDFIN        ZCHR01
     C                   PARM      0             ZDATE6
     C                   PARM      *BLANKS       ZDATE7
     C                   PARM      *BLANK        ZRTN1
     C                   PARM      0             ZDATE8

     C     ZRTN1         IFEQ      '1'
     C                   MOVE      'ZA0140  '    DBFILE
     C                   MOVE(P)   TFVALD        DBKEY
     C                   Z-ADD     005           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   MOVE      ZDATE7        R1VDAT

      ** Account Code
     C                   MOVE      TFACOD        R1ACOD

      ** Currency
     C                   MOVE      TFCCY         R1CCY

      ** Today Transfer
     C                   Z-ADD     A6NBDP        ZDECS
     C                   CALL      'ZSEDIT'
     C                   PARM      TFPSTA        ZNUM15
     C                   PARM                    ZDECS
     C                   PARM      'J'           ZCHR01
     C                   PARM      *BLANKS       ZOUT21

     C                   MOVE(P)   ZOUT20        R1PSTA

     C     TFPSTA        IFLT      0
     C                   MOVE      'DR'          R1DRCR1
     C                   EVALR     R1PSTA = '-' + %TRIM(R1PSTA)
     C                   ELSE
     C                   MOVE      'CR'          R1DRCR1
     C                   ENDIF

      ** Current Month
     C                   Z-ADD     A6NBDP        ZDECS
     C                   CALL      'ZSEDIT'
     C                   PARM      TFMTDA        ZNUM15
     C                   PARM                    ZDECS
     C                   PARM      'J'           ZCHR01
     C                   PARM      *BLANKS       ZOUT21

     C                   MOVE(P)   ZOUT20        R1MTDA

     C     TFMTDA        IFLT      0
     C                   MOVE      'DR'          R1DRCR2
     C                   EVALR     R1MTDA = '-' + %TRIM(R1MTDA)
     C                   ELSE
     C                   MOVE      'CR'          R1DRCR2
     C                   ENDIF

      ** YTD Balance
     C                   Z-ADD     A6NBDP        ZDECS
     C                   CALL      'ZSEDIT'
     C                   PARM      TFYTDA        ZNUM15
     C                   PARM                    ZDECS
     C                   PARM      'J'           ZCHR01
     C                   PARM      *BLANKS       ZOUT21

     C                   MOVE(P)   ZOUT20        R1YTDA

     C     TFYTDA        IFLT      0
     C                   MOVE      'DR'          R1DRCR3
     C                   EVALR     R1YTDA = '-' + %TRIM(R1YTDA)
     C                   ELSE
     C                   MOVE      'CR'          R1DRCR3
     C                   ENDIF

      ** Base Equivalent
     C                   Z-ADD     BCYNDP        ZDECS
     C                   CALL      'ZSEDIT'
     C                   PARM      TFBSTA        ZNUM15
     C                   PARM                    ZDECS
     C                   PARM      'J'           ZCHR01
     C                   PARM      *BLANKS       ZOUT21

     C                   MOVE(P)   ZOUT20        R1BPSTA

     C     TFBSTA        IFLT      0
     C                   EVALR     R1BPSTA= '-' + %TRIM(R1BPSTA)
     C                   ENDIF

      ** FX Spot Rates
     C                   MOVE      TFSPOT        ZNUM15
     C                   CALL      'ZSEDIT'
     C                   PARM                    ZNUM15
     C                   PARM      8             ZDECS
     C                   PARM      *BLANK        ZCHR01
     C                   PARM      *BLANKS       ZOUT21

     C                   MOVE(P)   ZOUT20        R1SPOT

      ** Write out detail record
      ** -----------------------

      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
     C     OFLLN1        SUB       PRTLN1        WDIFLIN
     C     WDIFLIN       IFLE      1
     C                   WRITE     HEADP1
     C                   ENDIF

     C                   WRITE     DETAILP1

      ** Read next record
      ** ----------------

     C                   READ      GLACTPL0

     C                   ENDDO

      ** End of file routine
      ** -------------------

     C     WOPNP1        IFEQ      *ON
     C                   EXSR      SrTrailP1
     C                   CLOSE     GL201005P1
     C                   MOVE      *OFF          WOPNP1
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /TITLE SR/SrSngRpt
      *****************************************************************
      *                                                               *
      *  SrSngRpt - Singapore branch report.                          *
      *                                                               *
      *****************************************************************
     C     SrSngRpt      BEGSR

      ** Initialization
      ** --------------

     C                   MOVE      *BLANKS       SVBRCA

      ** Read first record from File.

     C                   READ      GLACTPL1

      ** Do while not end of file
      ** ------------------------

     C                   DOW       NOT %EOF(GLACTPL1)

      ** Change in branch
      ** ----------------

     C     SVBRCA        IFNE      TFBRCA

      ** Close report for the previous branch
     C     SVBRCA        IFNE      *BLANKS

      ** Write Totals
     C                   EXSR      SrTotalsP2
     C                   Z-ADD     0             CCYPSTA
     C                   Z-ADD     0             CCYBSTA

      ** Trailer
     C                   EXSR      SrTrailP2
     C                   CLOSE     GL201005P2
     C                   MOVE      *OFF          WOPNP2

     C                   ENDIF

      ** Access details of the current branch
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       WRTCD
     C                   PARM      '*KEY   '     WOPTN
     C                   PARM      TFBRCA        WCHR03
     C     SDBRCH        PARM      *BLANKS       DSSDY
     C     WRTCD         IFNE      *BLANKS
     C                   MOVE      'SDBRCHPD'    DBFILE
     C                   MOVEL(P)  TFBRCA        DBKEY
     C                   Z-ADD     006           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Set up report for the current branch
     C                   OPEN      GL201005P2
     C                   MOVE      *ON           WOPNP2
     C                   MOVEL(P)  SFILE2        SFILE
     C                   Z-ADD     SFNUM2        ZSNUM
     C                   EXSR      SrRCFP1
                                                                                            AR854120
      ** Check Country Code for the header summary statement                                AR854120
      *                                                                                     AR854120
     C                   EXSR      SrR2HSUM                                                 AR854120
      *                                                                                     AR854120
     C                   WRITE     HEADP2

     C                   MOVEL     TFBRCA        SVBRCA
     C                   Z-ADD     0             SVACOD
     C                   MOVE      *BLANKS       SVCCY

     C                   ENDIF

      ** Change in Currency
      ** ------------------

     C     SVCCY         IFNE      TFCCY

     C     SVCCY         IFNE      *BLANKS

      ** Write Totals
     C                   EXSR      SrTotalsP2

     C                   ENDIF

     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       WRTCD
     C                   PARM      '*KEY   '     WOPTN
     C                   PARM      TFCCY         WCHR03
     C     SDCURR        PARM      *BLANKS       DSSDY
     C     WRTCD         IFNE      *BLANKS
     C                   MOVE      'SDCURRPD'    DBFILE
     C                   MOVEL(P)  TFCCY         DBKEY
     C                   Z-ADD     007           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Reset totals
     C                   Z-ADD     0             CCYPSTA
     C                   Z-ADD     0             CCYBSTA
     C                   MOVE      TFCCY         SVCCY

     C                   ENDIF

      ** Change in Account Code
      ** ----------------------

     C     SVACOD        IFNE      TFACOD

     C     SVACOD        IFNE      0
     C     OFLLN2        SUB       PRTLN2        WDIFLIN
     C     WDIFLIN       IFLE      1
     C                   WRITE     HEADP2
     C                   ELSE
     C                   WRITE     BLANKP2
     C                   ENDIF
     C                   ENDIF

     C                   Z-ADD     TFACOD        SVACOD

     C                   ENDIF

      ** Prepare detail report
      ** ---------------------

      ** Branch
     C                   MOVE      TFBRCA        R2BRCH

      ** Value Date
     C                   CALL      'ZA0140'
     C                   PARM      TFVALD        ZDAYNO
     C                   PARM      BJDFIN        ZCHR01
     C                   PARM      0             ZDATE6
     C                   PARM      *BLANKS       ZDATE7
     C                   PARM      *BLANK        ZRTN1
     C                   PARM      0             ZDATE8

     C     ZRTN1         IFEQ      '1'
     C                   MOVE      'ZA0140  '    DBFILE
     C                   MOVE(P)   TFVALD        DBKEY
     C                   Z-ADD     008           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   MOVE      ZDATE7        R2VDAT

      ** Account Code
     C                   MOVE      TFACOD        R2ACOD

      ** Currency
     C                   MOVE      TFCCY         R2CCY

      ** Today Transfer
     C                   Z-ADD     A6NBDP        ZDECS
     C                   CALL      'ZSEDIT'
     C                   PARM      TFPSTA        ZNUM15
     C                   PARM                    ZDECS
     C                   PARM      'J'           ZCHR01
     C                   PARM      *BLANKS       ZOUT21

     C                   MOVE(P)   ZOUT20        R2PSTA

     C     TFPSTA        IFLT      0
     C                   MOVE      'DR'          R2DRCR1
     C                   EVALR     R2PSTA = '-' + %TRIM(R2PSTA)
     C                   ELSE
     C                   MOVE      'CR'          R2DRCR1
     C                   ENDIF

      ** Current Month
     C                   Z-ADD     A6NBDP        ZDECS
     C                   CALL      'ZSEDIT'
     C                   PARM      TFMTDA        ZNUM15
     C                   PARM                    ZDECS
     C                   PARM      'J'           ZCHR01
     C                   PARM      *BLANKS       ZOUT21

     C                   MOVE(P)   ZOUT20        R2MTDA

     C     TFMTDA        IFLT      0
     C                   MOVE      'DR'          R2DRCR2
     C                   EVALR     R2MTDA = '-' + %TRIM(R2MTDA)
     C                   ELSE
     C                   MOVE      'CR'          R2DRCR2
     C                   ENDIF

      ** YTD Balance
     C                   Z-ADD     A6NBDP        ZDECS
     C                   CALL      'ZSEDIT'
     C                   PARM      TFYTDA        ZNUM15
     C                   PARM                    ZDECS
     C                   PARM      'J'           ZCHR01
     C                   PARM      *BLANKS       ZOUT21

     C                   MOVE(P)   ZOUT20        R2YTDA

     C     TFYTDA        IFLT      0
     C                   MOVE      'DR'          R2DRCR3
     C                   EVALR     R2YTDA = '-' + %TRIM(R2YTDA)
     C                   ELSE
     C                   MOVE      'CR'          R2DRCR3
     C                   ENDIF

      ** Base Equivalent

     C                   Z-ADD     TFBSTA        ZNUM15
     C                   Z-ADD     BCYNDP        ZDECS
     C                   CALL      'ZSEDIT'
     C                   PARM                    ZNUM15
     C                   PARM                    ZDECS
     C                   PARM      'J'           ZCHR01
     C                   PARM      *BLANKS       ZOUT21

     C                   MOVE(P)   ZOUT20        R2BPSTA

     C     TFPSTA        IFLT      0
     C                   EVALR     R2BPSTA = '-' + %TRIM(R2BPSTA)
     C                   ENDIF

      ** FX Spot Rates
     C                   MOVE      TFSPOT        ZNUM15
     C                   CALL      'ZSEDIT'
     C                   PARM                    ZNUM15
     C                   PARM      8             ZDECS
     C                   PARM      *BLANK        ZCHR01
     C                   PARM      *BLANKS       ZOUT21

     C                   MOVE(P)   ZOUT20        R2SPOT

      ** Write out detail record
      ** -----------------------

      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
     C     OFLLN2        SUB       PRTLN2        WDIFLIN
     C     WDIFLIN       IFLE      1
     C                   WRITE     HEADP2
     C                   ENDIF

     C                   WRITE     DETAILP2

      ** Accumulate totals
      ** -----------------

     C                   ADD       TFPSTA        CCYPSTA
     C                   ADD       TFBSTA        CCYBSTA

      ** Read next record
      ** ----------------
     C                   READ      GLACTPL1

     C                   ENDDO

      ** End of file process
      ** -------------------

     C     WOPNP2        IFEQ      *ON

      ** Write totals
     C                   EXSR      SrTotalsP2

      ** Write report trailer
     C                   EXSR      SrTrailP2
     C                   CLOSE     GL201005P2
     C                   MOVE      *OFF          WOPNP2

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /TITLE SR/SrTotalsP2
      *****************************************************************
      *                                                               *
      *  SrTotalsP2 - Totals for Singapore branch report.             *
      *                                                               *
      *****************************************************************
     C     SrTotalsP2    BEGSR

      ** Ccy details are those from the previous record
     C                   Z-ADD     A6NBDP        ZDECS
     C                   CALL      'ZSEDIT'
     C                   PARM      CCYPSTA       ZNUM15
     C                   PARM                    ZDECS
     C                   PARM      'J'           ZCHR01
     C                   PARM      *BLANKS       ZOUT21

     C                   MOVE(P)   ZOUT20        R2CCYPSTA

      ** Debit/credit
     C     CCYPSTA       IFLT      0
     C                   MOVE      'DR'          R2DRCR
     C                   EVALR     R2CCYPSTA = '-' + %TRIM(R2CCYPSTA)
     C                   ELSE
     C                   MOVE      'CR'          R2DRCR
     C                   ENDIF

      ** In base ccy
     C                   Z-ADD     CCYBSTA       ZNUM15
     C                   Z-ADD     BCYNDP        ZDECS
     C                   CALL      'ZSEDIT'
     C                   PARM                    ZNUM15
     C                   PARM                    ZDECS
     C                   PARM      'J'           ZCHR01
     C                   PARM      *BLANKS       ZOUT21

     C                   MOVE(P)   ZOUT20        R2CCYBPSTA

     C     CCYBSTA       IFLT      0
     C                   EVALR     R2CCYBPSTA = '-' + %TRIM(R2CCYBPSTA)
     C                   ENDIF

      ** If not enough lines for the total, then print header
     C     OFLLN2        SUB       PRTLN2        WDIFLIN
     C     WDIFLIN       IFLE      5
     C                   WRITE     HEADP2
     C                   ENDIF

     C                   WRITE     TOTALP2

     C                   ENDSR
      *****************************************************************
      /TITLE SR/SrDtlRpt
      *****************************************************************
      *                                                               *
      *  SrDtlRpt - Transaction-based report.                         *
      *                                                               *
      *****************************************************************
     C     SrDtlRpt      BEGSR

      ** Initialization
      ** --------------

     C                   MOVE      *BLANKS       SVBRCA
     C                   Z-ADD     0             CCYPSTA

      ** Read first record from File.

     C                   READ      GLTFRPL0

      ** Do while not end of file
      ** ------------------------

     C                   DOW       NOT %EOF(GLTFRPL0)

      ** Change in branch
      ** ----------------

     C     SVBRCA        IFNE      TDBRCA

      ** Close report of previous branch
     C     SVBRCA        IFNE      *BLANKS

      ** Write Totals
     C                   EXSR      SrTotalsP3
     C                   Z-ADD     0             CCYPSTA
      ** Trailer
     C                   EXSR      SrTrailP3
     C                   CLOSE     GL201005P3
     C                   MOVE      *OFF          WOPNP3

     C                   ENDIF

      ** Access details of the current branch
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       WRTCD
     C                   PARM      '*KEY   '     WOPTN
     C                   PARM      TDBRCA        WCHR03
     C     SDBRCH        PARM      *BLANKS       DSSDY
     C     WRTCD         IFNE      *BLANKS
     C                   MOVE      'SDBRCHPD'    DBFILE
     C                   MOVEL(P)  TDBRCA        DBKEY
     C                   Z-ADD     009           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Set up report for the current branch
     C                   OPEN      GL201005P3
     C                   MOVE      *ON           WOPNP3
     C                   MOVEL(P)  SFILE3        SFILE
     C                   Z-ADD     SFNUM3        ZSNUM
     C                   EXSR      SrRCFP1
     C                   WRITE     HEADP3

      ** Remember current branch
     C                   MOVEL     TDBRCA        SVBRCA
     C                   Z-ADD     0             SVACOD
     C                   MOVE      *BLANKS       SVCCY

     C                   ENDIF

      ** Change in Currency
      ** ------------------

     C     SVCCY         IFNE      TDCCY

     C     SVCCY         IFNE      *BLANKS

      ** Write Totals
     C                   EXSR      SrTotalsP3
      ** Reset totals
     C                   Z-ADD     0             CCYPSTA

     C                   ENDIF

     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       WRTCD
     C                   PARM      '*KEY   '     WOPTN
     C                   PARM      TDCCY         WCHR03
     C     SDCURR        PARM      *BLANKS       DSSDY
     C     WRTCD         IFNE      *BLANKS
     C                   MOVE      'SDCURRPD'    DBFILE
     C                   MOVEL(P)  TDCCY         DBKEY
     C                   Z-ADD     010           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   MOVE      TDCCY         SVCCY

     C                   ENDIF

      ** Report account postings
      ** -----------------------

     C                   EXSR      SrPostings

      ** Totals process
      ** --------------

      ** Output total on Account Code level

     C                   Z-ADD     A6NBDP        ZDECS
     C                   CALL      'ZSEDIT'
     C                   PARM      TDPSTA        ZNUM15
     C                   PARM                    ZDECS
     C                   PARM      'J'           ZCHR01
     C                   PARM      *BLANKS       ZOUT21

     C                   MOVE(P)   ZOUT20        R3ACDPSTA

     C     TDPSTA        IFLT      0
     C                   MOVE      'DR'          R3ACDDRCR2
     C                   EVALR     R3ACDPSTA = '-' + %TRIM(R3ACDPSTA)
     C                   ELSE
     C                   MOVE      'CR'          R3ACDDRCR2
     C                   ENDIF

     C     OFLLN3        SUB       PRTLN3        WDIFLIN
     C     WDIFLIN       IFLE      3
     C                   WRITE     HEADP3
     C                   ENDIF

     C                   WRITE     ACDTOTALP3

      ** Accumulate totals
     C                   ADD       TDPSTA        CCYPSTA

      ** Read next record
      ** ----------------
     C                   READ      GLTFRPL0

     C                   ENDDO

      ** End of file process
      ** -------------------

     C     WOPNP3        IFEQ      *ON

      ** Write Totals
     C                   EXSR      SrTotalsP3

      ** Write report trailer
     C                   EXSR      SrTrailP3
     C                   CLOSE     GL201005P3
     C                   MOVE      *OFF          WOPNP3

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /TITLE SR/SrPostings
      *****************************************************************
      *                                                               *
      *  SrPostings - Posting details for the Transaction-based report*
      *                                                               *
      *****************************************************************
     C     SrPostings    BEGSR

     C     K_GLTFRP      SETLL     GLAPSTL1
     C     K_GLTFRP      READE     GLAPSTL1

     C                   DOW       NOT %EOF(GLAPSTL1)

      ** Value Date
     C                   CALL      'ZA0140'
     C                   PARM      PSTD          ZDAYNO
     C                   PARM      BJDFIN        ZCHR01
     C                   PARM      0             ZDATE6
     C                   PARM      *BLANKS       ZDATE7
     C                   PARM      *BLANK        ZRTN1
     C                   PARM      0             ZDATE8

     C     ZRTN1         IFEQ      '1'
     C                   MOVE      'ZA0140  '    DBFILE
     C                   MOVE(P)   PSTD          DBKEY
     C                   Z-ADD     011           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   MOVE      ZDATE7        R3PSTD

      ** Customer number
     C                   MOVE      CNUM          R3CNUM

      ** Currency
     C                   MOVE      CCY           R3CCY

      ** Posting amount
     C                   Z-ADD     A6NBDP        ZDECS
     C                   CALL      'ZSEDIT'
     C                   PARM      PSTA          ZNUM15
     C                   PARM                    ZDECS
     C                   PARM      'J'           ZCHR01
     C                   PARM      *BLANKS       ZOUT21

     C                   MOVE(P)   ZOUT20        R3PSTA

     C     DRCR          IFEQ      1
     C                   MOVE      'DR'          R3DRCR
     C                   EVALR     R3PSTA = '-' + %TRIM(R3PSTA)
     C                   ELSE
     C                   MOVE      'CR'          R3DRCR
     C                   ENDIF

      ** Source of posting
     C                   MOVE      SPOS          R3SPOS

      ** Branch
     C                   MOVE      BRCA          R3BRCA

      ** Transaction Type
     C                   MOVEL     OTTP          R3TRTY

      ** Transaction sub-type
     C                   MOVEL     OTST          R3TRSU

      ** Transaction reference
     C     SPOS          IFEQ      '  GE-LE'
     C     6             SUBST     OTRF          R3TREF
     C                   ELSE
     C                   MOVEL     OTRF          R3TREF
     C                   ENDIF

      ** Account Code
     C                   MOVE      ACOD          R3ACOD

      ** Account Sequence number
     C                   MOVE      ACSQ          R3ACSQ

      ** Write out detail record
      ** -----------------------

      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.

     C     OFLLN3        SUB       PRTLN3        WDIFLIN
     C     WDIFLIN       IFLE      1
     C                   WRITE     HEADP3
     C                   ENDIF

     C                   WRITE     DETAILP3

      ** Read next record
      ** ----------------

     C     K_GLTFRP      READE     GLAPSTL1

     C                   ENDDO


     C                   ENDSR
      *****************************************************************
      /TITLE SR/SrTotalsP3
      *****************************************************************
      *                                                               *
      *  SrTotalsP3 - Totals for the Transaction-based report.        *
      *                                                               *
      *****************************************************************
     C     SrTotalsP3    BEGSR

      ** Write ccy total
      ** Ccy details are those from the previous record
     C                   Z-ADD     A6NBDP        ZDECS
     C                   CALL      'ZSEDIT'
     C                   PARM      CCYPSTA       ZNUM15
     C                   PARM                    ZDECS
     C                   PARM      'J'           ZCHR01
     C                   PARM      *BLANKS       ZOUT21

     C                   MOVE(P)   ZOUT20        R3CCYPSTA


     C     CCYPSTA       IFLT      0
     C                   MOVE      'DR'          R3ACDDRCR3
     C                   EVALR     R3CCYPSTA = '-' + %TRIM(R3CCYPSTA)
     C                   ELSE
     C                   MOVE      'CR'          R3ACDDRCR3
     C                   ENDIF

      ** If not enough lines for the total, then print header
     C     OFLLN3        SUB       PRTLN3        WDIFLIN
     C     WDIFLIN       IFLE      2
     C                   WRITE     HEADP3
     C                   ENDIF

     C                   WRITE     CCYTOTALP3

     C                   ENDSR
      *****************************************************************
      /TITLE SR/SrTrailP1
      *****************************************************************
      *                                                               *
      *  SrTrailP1 - Write report trailer for P1                      *
      *                                                               *
      *****************************************************************
     C     SrTrailP1     BEGSR

      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
     C     OFLLN1        SUB       PRTLN1        WDIFLIN
     C     WDIFLIN       IFLE      4
     C                   WRITE     HEADP1
     C                   ENDIF

      ** Write out Total Format.
     C                   WRITE     TRAILP1

     C                   ENDSR
      *****************************************************************
      /TITLE SR/SrTrailP2
      *****************************************************************
      *                                                               *
      *  SrTrailP2 - Write report trailer for P2                      *
      *                                                               *
      *****************************************************************
     C     SrTrailP2     BEGSR

      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
     C     OFLLN2        SUB       PRTLN2        WDIFLIN
     C     WDIFLIN       IFLE      4
     C                   WRITE     HEADP2
     C                   ENDIF


      ** Write out Total Format.
     C                   WRITE     TRAILP2

     C                   ENDSR
      *****************************************************************
      /TITLE SR/SrTrailP3
      *****************************************************************
      *                                                               *
      *  SrTrailP3 - Write report trailer for P3                      *
      *                                                               *
      *****************************************************************
     C     SrTrailP3     BEGSR

      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
     C     OFLLN3        SUB       PRTLN3        WDIFLIN
     C     WDIFLIN       IFLE      4
     C                   WRITE     HEADP3
     C                   ENDIF

      ** Write out Total Format.
     C                   WRITE     TRAILP3

     C                   ENDSR
      *****************************************************************
      /TITLE SR/SrRCFP1
      *****************************************************************
      *                                                               *
      *  SrRCFP1 - Subroutine to register the printer file via RCF.   *
      *                                                               *
      *****************************************************************
     C     SrRCFP1       BEGSR

      ** Ensure Report Spool File recorded by RCF.

     C                   CALL      'ZSFILE'
     C                   PARM      *BLANKS       SEQ               5
     C                   PARM                    SENTY             3
     C                   PARM                    SFILE            10
     C                   PARM                    ZSNUM             6 0
     C                   PARM      *BLANK        ZSERR             1

      ** If Error occurs during ZSFILE processing, then return to the
      ** calling Program.

     C     ZSERR         IFEQ      'Y'
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /TITLE SR/*PSSR
      *****************************************************************
      *                                                               *
      *  *PSSR  - Error control subroutine                            *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

      ** Check to see that *PSSR has not already been called.
     C     WRUN          IFEQ      *BLANK

     C                   MOVE      'Y'           WRUN              1
     C     *DTAARA       DEFINE    LDA           WLDA            256
     C     *LOCK         IN        WLDA
     C                   MOVEL     LDA           WLDA
     C                   OUT       WLDA
     C                   SETON                                        U7U8LR
     C                   DUMP

     C                   ENDIF

      ** If *PSSR already run, then just end the program here.
     C                   SETON                                        U7U8LR
     C                   RETURN

     C                   ENDSR
      *****************************************************************
      /TITLE SR/SrR2HSUM                                                                    AR854120
      *****************************************************************                     AR854120
      *                                                               *                     AR854120
      *  SrR2HSUM - Country Code header summary statement             *                     AR854120
      *                                                               *                     AR854120
      *  Called by: SrSngRpt                                          *                     AR854120
      *  Calls: None                                                  *                     AR854120
      *                                                               *                     AR854120
      *****************************************************************                     AR854120
     C     SrR2HSUM      BEGSR                                                              AR854120
     C                   MOVE      *BLANKS       R2HSUM                                     AR854120
      *                                                                                     AR854120
     C                   SELECT                                                             AR854120
     C     BJCNCD        WHENEQ    'KR'                                                     AR854120
     C                   MOVEA     ARRY(1)       R2HSUM                                     AR854120
     C     BJCNCD        WHENEQ    'SG'                                                     AR854120
     C                   MOVEA     ARRY(2)       R2HSUM                                     AR854120
     C                   ENDSL                                                              AR854120
      *                                                                                     AR854120
     C                   ENDSR                                                              AR854120
      *****************************************************************                     AR854120
**  CPY@
(c) Finastra International Limited 2023
**  ARRY                                                                                    AR854120
SUMMARY FOR SEOUL BRANCH     -                                                              AR854120
SUMMARY FOR SINGAPORE BRANCH -                                                              AR854120
