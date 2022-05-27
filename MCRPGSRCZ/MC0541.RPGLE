     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas MC Spot Reval by F/Ccy Spot Trade A/c report')   *
      *****************************************************************
      *                                                               *
      *  Midas - Midas Accounting Module                              *
      *                                                               *
      *  MC0541 - Spot Revaluation Report by                          *
      *           Foreign Currency Spot Trade Account                 *
      *                                                               *
      *  Function:  This program produces the Management account's    *
      *   (COB)     version of the Spot trade revaluation report.     *
      *                                                               *
      *  The MC0541 report will be a copy of the existing MC0540      *
      *  to show the Spot Revaluation of the Alternate Spot Trade     *
      *  Accounts as defined in the mapping table                     *
      *                                                               *
      *  Called By: MCC0540 - Spot Revaluation Report Component       *
      *                                                               *
      *  (c) Finastra International Limited 2021                      *
      *                                                               *
      *  Last Amend No. MD059975           Date 19May22               *
      *  Prev Amend No. MD059964           Date 18May22               *
      *                 CGL057  *Create    Date 02Nov21               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD059975 - No Profit and Loss reported on MC0451P1           *
      *           - include the last movement date in getting the     *
      *             Period End Balance                                *
      *           - interchange the value of WTBCE and WTSPV          *
      *           - compare the last movement date to PRUN if not     *
      *             equal use 99999                                   *
      *  MD059964 - Multiple audit reports are being generated.       *
      *           - include the Spot Trade A/C code in the audit      *
      *             header even if no details to report               *
      *  CGL057 - Posting of Profit and Loss to Multiple Retained     *
      *           Earnings Accounts.                                  *
      *           Print a separate MC0541P1/AU report for each        *
      *           Spot Trade a/c code and Foreign Currency.           *
      *                                                               *
      *****************************************************************
     FMCSRRPOQ  IF   E           K DISK    INFSR(*PSSR)
      **  Management A/c Spot Trade Accounts
      *
     FMC0541AU  O    E             PRINTER INFDS(SPOOLU)
     F                                     USROPN
      **  Spot Revaluation Audit Report
      *
     FMC0541P1  O    E             PRINTER INFDS(SPOOL1)
     F                                     USROPN
      **  Spot Revaluation Report by Alternate Spot Trade Account
      *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   25  - No change in currency                                 *
      *                                                               *
      *   37  - Multibranching ON                                     *
      *   38  - System level requested                                *
      *                                                               *
      *   89  - End of File                                           *
      *                                                               *
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
      *  SRINIT - Program Initialisation                              *
      *  SRPROC - Detail Processing                                   *
      *                                                               *
      *  SRNWBR - Process New Branch                                  *
      *  SRLINE - Check Remaining Lines on Page                       *
      *  SRCHBR - Process a Change in Branch                          *
      *  SRCHCY - Process a Change in Currency                        *
      *  SRTOTL - Write a Subtotal Line                               *
      *                                                               *
      *  SRAUDT - Produce Audit Report                                *
      *  *PSSR  - Program Error Processing Subroutine                 *
      *  SRRCFP - RCF Processing for P1 Report                        *
      *  SRRCFA - RCF Processing for Audit Report                     *
      *                                                               *
      *  ZEDIT  - Edit an Amount                                      *
      *  ZFRPED - Edit an Amount based on edit code passed            *
      *                                                               *
      *****************************************************************
     D/EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      **  Array containing Copyright statement
      *
     D*/COPY ZSRSRC,ZEDITZ1
     D ZA1             S              1    DIM(16)                              ZALIGN/ZEDIT ARRAY
     D ZA2             S              1    DIM(16)                              ZALIGN/ZEDIT ARRAY
      *
     D*/COPY ZSRSRC,ZFRPEDZ1
     D ZS2             S              1    DIM(22)
      *
      /SPACE 3
     D PLMDT           S              5S 0                                                  MD059975
      *
     D*/COPY ZSRSRC,ZFRPEDZ2
     D                 DS
     D  ZWRK15                 1     15  0
     D  ZS1                    1     15  0
     D                                     DIM(15)
     D                 DS
     D  ZOUT25                 1     25
     D  ZOUT0                  1     21
     D  ZOUT1                  2     23
     D  ZOUT2                  3     24
     D  ZOUT3                  5     25
      *****************************************************************
      * End of /COPY XXXXXXX                                          *
      *****************************************************************
      *
     D LDA           E DS           256    EXTNAME(LDA)
     D  $FCCY                204    206
     D  $SPTA                207    216
      *
      **  Local data area for database error details
      **  *LOCK IN LDA immediately before and OUT LDA immediately
      **  after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Retrieve Previous Run date                                                         MD059975
     D JNSTAT        E DS                  EXTNAME(JNSTAT)                                  MD059975
      *                                                                                     MD059975
      **  Data Area giving Installation Control Details
      *
     D SPOOL1          DS
      **  File Information Data Structure for MC0541P1.
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
      *
     D SPOOLU          DS
      **  File Information Data Structure for MC0541AU.
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      **  External data structure for Bank Details
      *
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      **  External data structure for Branch Details
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      **  External data structure for Currency Details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      **  First data structure for Access Programs, short DS
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      **  Second data structure for Access Programs, long DS
      *
     C/TITLE Main Processing
      *================================================================
      *  P R O G R A M   S T A R T                                    *
      *================================================================
      *
      **  Perform Initialisation.
      *
     C                   EXSR      SRINIT
      *
      **  Read first record
      *
     C                   READ      MCSRRPOQ                               89
      *
      **  If End of Records, (*IN89), Perform: Audit Reporting (No
      **  Records); Otherwise, process spot revaluations
      *
     C     *IN89         IFEQ      *ON
     C                   MOVEL     $SPTA         RACCD                          MD059964
     C                   EXSR      SRAUDT
     C                   ELSE
     C                   EXSR      SRPROC
     C                   ENDIF
      *
      **  Seton LR and End Program.
      *
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *
      *================================================================
      *  P R O G R A M   E N D                                        *
      *================================================================
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRINIT - Subroutine to do Program Initialisation.            *
      *                                                               *
      *  Called By:  Main Processing                                  *
      *  Calls    :  *PSSR  - Error Control Subroutine                *
      *                                                               *
      *****************************************************************
      *
     C     SRINIT        BEGSR                                                  *** SRINIT ***
      *
      **  Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
      **  Receive Parameter List.
      *
     C     *ENTRY        PLIST
     C                   PARM                    PSEQN             5
     C                   PARM                    PLEVL             1
     C                   PARM                    PENTY             3
      *
      **  Initialise LDA field.
      *
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVEL     'MC0541'      DBPGM
     C                   MOVE      *BLANKS       DBKEY
     C                   MOVE      *BLANKS       DBFILE
     C                   Z-ADD     *ZEROS        DBASE
     C                   OUT       LDA
      *
      **  Call Access Program for Bank Details - Title, Run Date,
      **  Run Day Number and Base Currency
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      **  Handle Database Error.
      *
     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBANKPD'    DBFILE                         ***************
     C                   Z-ADD     1             DBASE                          * DB ERROR 01 *
     C                   MOVEL     '*FIRST'      DBKEY                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      **  Call Access Program for Currency Details - Base Currency
      **  decimal places.
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      BJCYCD        PCCY              3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      **  Handle Database Error.
      *
     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCURRPD'    DBFILE                         ************
     C                   Z-ADD     4             DBASE                          * DBERR 04 *
     C                   MOVEL     PCCY          DBKEY                          ************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   Z-ADD     A6NBDP        BCNBDP            1 0
      *
      **   Access RUNDAT for multibranching indicator
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
     C     AGMBIN        IFEQ      'Y'
     C                   MOVE      *ON           *IN37
     C                   ELSE
     C                   MOVE      *OFF          *IN37
     C                   ENDIF
      *                                                                                     MD059975
      **   Access JNSTAT for previous run date                                              MD059975
      *                                                                                     MD059975
     C     *DTAARA       DEFINE                  JNSTAT                                     MD059975
     C                   IN        JNSTAT                                                   MD059975
      *
      **  System level requested.
      *
     C     PLEVL         IFEQ      'S'
     C                   MOVE      *ON           *IN38
     C                   ENDIF
      *
      **  Initialise Report Work fields.
      *
     C                   Z-ADD     0             RQDLN1            3 0
     C                   Z-ADD     0             DIFLN1            3 0
     C                   Z-ADD     0             WRCNT             5 0
      *
     C                   Z-ADD     0             WSPEQ            15 0
     C                   Z-ADD     0             WTSPT            15 0
     C                   Z-ADD     0             WTBCE            15 0
     C                   Z-ADD     0             WTSPV            15 0
     C                   Z-ADD     0             WTPLO            15 0
     C                   MOVE      'N'           WOPEN             1
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SRPROC
      *****************************************************************
      *                                                               *
      *  SRPROC - Subroutine to Process Spot Revaluations             *
      *                                                               *
      *  Called By:  Main Processing                                  *
      *  Calls    :  SRNWBR - Process New Branch                      *
      *              SRLINE - Check Remaining Lines on Page           *
      *              SRCHBR - Process a Change in Branch              *
      *              SRTOTL - Print a Subtotal Line                   *
      *              *PSSR  - Error Control Subroutine                *
      *                                                               *
      *****************************************************************
      *
     C     SRPROC        BEGSR                                                  *** SRPROC ***
      *
      **  Process New Branch
      *
     C                   EXSR      SRNWBR
      *
      **  Do While Not End of File.
      *
     C     *IN89         DOWEQ     *OFF
      *
      **  Save current branch and current currency details
      *
     C                   MOVE      SRBRCD        WSVBR             3
     C                   MOVE      SRCYCD        WSVCY             3
     C                   MOVE      SRCYNM        WSVNM            14
     C                   Z-ADD     SRNBDP        WNBDP             1 0
     C                   Z-ADD     SRSPRT        WSVRT            13 8
      *                                                                                     MD059975
      **  Compare the last movement date (SRLMDT) to previous run date in JNSTAT            MD059975
      **  if PRUN is equal to last movement date use it else use 99999                      MD059975
      *                                                                                     MD059975
     C     SRLMDT        IFNE      PRUN                                                     MD059975
     C                   EVAL      PLMDT = 99999                                            MD059975
     C                   ELSE                                                               MD059975
     C                   EVAL      PLMDT = SRLMDT                                           MD059975
     C                   ENDIF                                                              MD059975
      *
      **  Call GL0765 to convert the Period End Balance into Base Ccy
      *
     C                   CALL      'GL0765'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      SRCYCD        PCYCD             3
     C                   PARM      BJCYCD        PBCCY             3
     C**********         PARM      99999         PDYNB             5 0                      MD059975
     C                   PARM      PLMDT         PDYNB             5 0                      MD059975
     C     WSPEQ         PARM      SREPCB        PAMNT            19 0
      *
      **  Handle database error
      *
     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'See Dump'    DBFILE                         ***************
     C                   Z-ADD     2             DBASE                          * DB ERROR 02 *
     C                   MOVEL     'GL0765'      DBKEY                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      **  Compute for 'Revaluation P&L'
      *
     C     SRBCEQ        SUB       WSPEQ         WRVPL            15 0
      *
      **  Accumulate closing balance, base ccy equivalent, spot trade
      **  equivalent, and revaluation P&L.
      *
     C                   ADD       SREPCB        WTSPT
     C**********         ADD       SRBCEQ        WTBCE                                      MD059975
     C**********         ADD       WSPEQ         WTSPV                                      MD059975
     C                   ADD       WSPEQ         WTBCE                                      MD059975
     C                   ADD       SRBCEQ        WTSPV                                      MD059975
     C                   ADD       WRVPL         WTPLO
      *
      **  Setup report details
      *
     C                   MOVE      SRPCCD        RPRFC
     C                   MOVE      SRBKCD        RBKCD
     C                   MOVE      SROTTP        ROTTP
     C                   MOVE      SRTSTY        RTSTY
     C     SRASNB        IFEQ      *ZERO
     C                   MOVE      *BLANKS       RASNB
     C                   ELSE
     C                   MOVE      SRASNB        RASNB
     C                   ENDIF
      *
      **  Format Spot Position/Closing Balance
      *
     C                   Z-ADD     SREPCB        ZFLD15
     C                   Z-ADD     SRNBDP        ZDECS
     C                   MOVE      'A'           ZECODE
     C                   EXSR      ZFRPED
     C                   MOVE      ZOUT22        RSPOT
      *
      **  Format Base Currency Equivalent
      *
     C**********         Z-ADD     SRBCEQ        ZFLD15                                     MD059975
     C                   Z-ADD     WSPEQ         ZFLD15                                     MD059975
     C                   Z-ADD     BCNBDP        ZDECS
     C                   EXSR      ZFRPED
     C                   MOVE      ZOUT22        RBCEQ
      *
      **  Format Spot Value/Spot Trade Equivalent
      *
     C**********         Z-ADD     WSPEQ         ZFLD15                                     MD059975
     C                   Z-ADD     SRBCEQ        ZFLD15                                     MD059975
     C                   EXSR      ZFRPED
     C                   MOVE      ZOUT22        RSPVL
      *
      **  Format Revaluation Profit/Loss
      *
     C                   Z-ADD     WRVPL         ZFLD15
     C                   EXSR      ZFRPED
     C                   MOVE      ZOUT22        RPRLO
      *
      **  Check that sufficient lines remain for the Format
      *
     C                   Z-ADD     6             RQDLN1
     C                   EXSR      SRLINE
      *
      **  Write out Detail Record and add 1 to currency record count.
      *
     C                   WRITE     DETAIL
     C                   ADD       1             WRCNT             5 0
      *
      **  Read next record.
      *
     C                   READ      MCSRRPOQ                               89
      *
      **  If End of File or Change of Branch
      *
     C     *IN89         IFEQ      *ON
     C     SRBRCD        ORNE      RBRCH
     C                   EXSR      SRCHBR
     C                   ENDIF
      *
      **  If Not End of File and Change of Currency
      *
     C     *IN89         IFEQ      *OFF
     C     SRCYCD        ANDNE     RCYCD
     C                   EXSR      SRCHCY
     C                   ENDIF
      *
      **  End of Do While Not End of Valid Records.
     C                   ENDDO
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SRNWBR
      *****************************************************************
      *                                                               *
      *  SRNWBR - Subroutine to Process New Branch                    *
      *                                                               *
      *  Called By:  SRPROC - Process Detail Line                     *
      *              SRCHBR - Process a Change in Branch              *
      *  Calls    :  SRRCFP - RCF Processing for P1                   *
      *              SRLINE - Check Remaining Lines on Page           *
      *              *PSSR - Database Error Handling Subroutine       *
      *                                                               *
      *****************************************************************
      *
     C     SRNWBR        BEGSR                                                  *** SRNWBR ***
      *
      **  Get branch details using access object
      *
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*KEY    '    POPTN             7
     C                   PARM      SRBRCD        PBRCA             3
     C     SDBRCH        PARM      SDBRCH        DSSDY
      *
      **  Handle database error
      *
     C     PRTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBRCHPD'    DBFILE                         ***************
     C                   MOVEL     PBRCA         DBKEY                          * DB ERROR 03 *
     C                   Z-ADD     3             DBASE                          ***************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVEL     A8BRCD        RBRCH
     C                   MOVEL     A8BRNM        RBRNM
      *
      **  Open printer file MC0541P1 if entity not blank
      **  or the printer file is not yet open
      *
     C     PENTY         IFNE      *BLANK
     C     WOPEN         ORNE      'Y'
     C                   OPEN      MC0541P1
     C                   MOVE      'Y'           WOPEN
      *
      **  Ensure Report Spool File recorded by RCF
      *
     C     PENTY         IFNE      *BLANK
     C                   MOVE      SRBRCD        SENTY
     C                   ELSE
     C                   MOVE      *BLANKS       SENTY
     C                   ENDIF
      *
     C                   EXSR      SRRCFP
     C                   ENDIF
      *
      **  Check remaining lines on page
      *
     C                   MOVE      'Y'           WCHCY             1
     C                   Z-ADD     99            RQDLN1
     C                   EXSR      SRLINE
     C                   MOVE      'N'           WCHCY
      *
     C                   ENDSR
      *****************************************************************
      /TITLE SR/SRHEAD
      *****************************************************************
      *                                                               *
      *  SRHEAD - Subroutine to output account code to report header  *
      *                                                               *
      *  Called By:  SRLINE - Check Remaining Lines on Page           *
      *              SRAUDT - Audit report and End Program.           *
      *  Calls    :  none                                             *
      *                                                               *
      *****************************************************************
      *
     C     SRHEAD        BEGSR                                                  *** SRHEAD ***
      *
     C                   MOVEL     $FCCY         RCYCD
     C                   MOVEL     $SPTA         RACCD
      *
     C                   ENDSR
      *****************************************************************
      /TITLE SR/SRLINE
      *****************************************************************
      *                                                               *
      *  SRLINE - Subroutine to Check Remaining Lines on Page         *
      *                                                               *
      *  Called By:  SRPROC - Detail Processing                       *
      *              SRNWBR - Process New Branch                      *
      *  Calls    :  ZEDIT  - Format an Amount                        *
      *                                                               *
      *****************************************************************
      *
     C     SRLINE        BEGSR                                                  *** SRLINE ***
      *
      **  Subtract Current Line Number from Lines per Page
      *
     C     OFLLN1        SUB       PRTLN1        DIFLN1
      *
      **  If remaining lines are less than the lines to print, write
      **  report headings
      *
     C     DIFLN1        IFLT      RQDLN1
      *
     C                   EXSR      SRHEAD
      *
     C                   WRITE     HEADP1
      *
      **  If no change in currency, add '(CONTINUED)' after ccy name
      **  and use saved values; otherwise, use new values
      *
     C                   MOVE      *OFF          *IN25
     C                   MOVE      *BLANKS       ZFIELD
     C     WCHCY         IFNE      'Y'
     C                   MOVE      *ON           *IN25
     C                   MOVE      WSVCY         RCYCD
     C                   MOVE      WSVNM         RCYNM
     C                   MOVE      WSVRT         ZFIELD
     C                   ELSE
     C                   MOVE      SRCYCD        RCYCD
     C                   MOVE      SRCYNM        RCYNM
     C                   MOVE      SRSPRT        ZFIELD
     C                   ENDIF
      *
      **  Format Spot Rate
     C                   Z-ADD     8             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        RSPRT
      *
     C                   WRITE     SUBHDG
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /TITLE SR/SRCHBR
      *****************************************************************
      *                                                               *
      *  SRCHBR - Subroutine to Process a Change in Branch            *
      *                                                               *
      *  Called By:  SRPROC - Detail Processing                       *
      *  Calls    :  SRTOTL - Print a Subtotal Line                   *
      *              SRLINE - Check Remaining Lines on Page           *
      *              SRNWBR - Process New Branch                      *
      *                                                               *
      *****************************************************************
      *
     C     SRCHBR        BEGSR                                                  *** SRCHBR ***
      *
      **  Print Currency Totals
     C                   EXSR      SRTOTL
      *
      **  If printer file is open, print report footer for previous
      **  branch or if end of file
      *
     C     WOPEN         IFEQ      'Y'
      *
     C     PENTY         IFNE      *BLANK
     C     *IN89         OREQ      *ON
      *
      **  Check that sufficient lines remain for the Format
     C                   Z-ADD     4             RQDLN1
     C                   EXSR      SRLINE
      *
      **  Write out Total Format.
      *
     C                   WRITE     TRAILP1
     C                   CLOSE     MC0541P1
     C                   MOVE      'N'           WOPEN
     C                   ENDIF
      *
     C                   ENDIF
      *
      **  If not yet end of file, process new branch
      *
     C     *IN89         IFNE      *ON
     C                   EXSR      SRNWBR
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SRCHCY
      *****************************************************************
      *                                                               *
      *  SRCHBR - Subroutine to Process a Change in Currency          *
      *                                                               *
      *  Called By:  SRPROC - Detail Processing                       *
      *  Calls    :  SRTOTL - Print a Subtotal Line                   *
      *              SRLINE - Check Remaining Lines on Page           *
      *                                                               *
      *****************************************************************
      *
     C     SRCHCY        BEGSR                                                  *** SRCHCY ***
      *
      **  Print currency totals
      *
     C                   EXSR      SRTOTL
      *
      **  Check remaining lines on page
      *
     C                   MOVE      'Y'           WCHCY
     C                   Z-ADD     10            RQDLN1
     C                   EXSR      SRLINE
     C                   MOVE      'N'           WCHCY
      *
      **  If currency not equal, print currency headings
      *
     C     SRCYCD        IFNE      RCYCD
     C                   MOVE      SRCYCD        RCYCD
     C                   MOVE      SRCYNM        RCYNM
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      SRSPRT        ZFIELD
     C                   Z-ADD     8             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        RSPRT
     C                   WRITE     SUBHDG
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /TITLE SR/SRTOTL
      *****************************************************************
      *                                                               *
      *  SRTOTL - Subroutine to Write a Subtotal record to the Report *
      *                                                               *
      *  Called By:  SRPROC - Process Detail Line                     *
      *              SRCHBR - Process a Change in Branch              *
      *  Calls    :  none                                             *
      *                                                               *
      *****************************************************************
      *
     C     SRTOTL        BEGSR                                                  *** SRTOTL ***
      *
      **  If currency record count is greater than 1, print
      **  currency totals
      *
     C     WRCNT         IFGT      1
      *
      **  Format Total Spot Position/Closing Balance
      *
     C                   Z-ADD     WTSPT         ZFLD15
     C                   Z-ADD     WNBDP         ZDECS
     C                   MOVE      'A'           ZECODE
     C                   EXSR      ZFRPED
     C                   MOVE      ZOUT22        RTSPT
      *
      **  Format Total Base Currency Equivalent
      *
     C                   Z-ADD     WTBCE         ZFLD15
     C                   Z-ADD     BCNBDP        ZDECS
     C                   EXSR      ZFRPED
     C                   MOVE      ZOUT22        RTBCE
      *
      **  Format Total Spot Value/Spot Trade Equivalent
      *
     C                   Z-ADD     WTSPV         ZFLD15
     C                   EXSR      ZFRPED
     C                   MOVE      ZOUT22        RTSPV
      *
      **  Format Total Revaluation Profit/Loss
      *
     C                   Z-ADD     WTPLO         ZFLD15
     C                   EXSR      ZFRPED
     C                   MOVE      ZOUT22        RTPLO
      *
     C                   WRITE     SUBTTL
     C                   ENDIF
      *
      **  Initialise subtotal fields
      *
     C                   Z-ADD     *ZEROS        WTSPT
     C                   Z-ADD     *ZEROS        WTBCE
     C                   Z-ADD     *ZEROS        WTSPV
     C                   Z-ADD     *ZEROS        WTPLO
     C                   Z-ADD     *ZEROS        WRCNT
      *
     C                   ENDSR
      *****************************************************************
      /TITLE SR/SRAUDT
      *****************************************************************
      *                                                               *
      *  SRAUDT - Subroutine to Output Audit report and End Program.  *
      *                                                               *
      *  Called By:  Main Processing                                  *
      *              *PSSR  - Error control subroutine                *
      *  Calls    :  None                                             *
      *                                                               *
      *****************************************************************
      *
     C     SRAUDT        BEGSR                                                  *** SRAUDT ***
      *
      **  Ensure audit spooled file is recorded by RCF
      *
     C                   OPEN      MC0541AU
     C                   EXSR      SRRCFA
      *
     C                   EXSR      SRHEAD
      *
     C                   WRITE     HEADAU
      *
      **  If there is a DB Error, output the DB Error Information.
      *
     C     *INU7         IFEQ      *ON
     C                   WRITE     DBERROR
      *
      **  If P1 report is open, output the DB Error reference.
     C     WOPEN         IFEQ      'Y'
     C                   Z-ADD     3             RQDLN1
     C                   EXSR      SRLINE
     C                   WRITE     DBERRF
     C                   ENDIF
     C                   ELSE
      *
      **  No records read, so output "No Details" message.
     C                   WRITE     NODTLS
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/*PSSR
      *****************************************************************
      *                                                               *
      *  *PSSR  - Error Control Subroutine                            *
      *                                                               *
      *  Called By:  SRINIT - Perform Initialisation Processing       *
      *              SRPROC - Process Detail Line                     *
      *              SRNWBR - Process New Branch                      *
      *  Calls    :  SRAUDT - Produce Audit Report and End Program    *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR **
      *
      **  Check to see that *PSSR has not already been called.
      *
     C     WRUN          IFEQ      *BLANK
     C                   MOVE      'Y'           WRUN              1
     C                   SETON                                        U7U8LR
     C                   DUMP
     C                   EXSR      SRAUDT
     C                   ENDIF
      *
      **  If *PSSR already run, then just end the program here.
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SRRCFP
      *****************************************************************
      *                                                               *
      *  SRRCFP - Subroutine to register the P1 Printer File via RCF. *
      *                                                               *
      *  Called By:  SRNWBR - Process New Branch                      *
      *  Calls    :  None                                             *
      *                                                               *
      *****************************************************************
      *
     C     SRRCFP        BEGSR                                                   *** SRRCFP ***
      *
      **  Ensure Report Spool File recorded by RCF.
      *
     C                   Z-ADD     SFNUM1        ZSNUM             6 0
      *
     C                   CALL      'ZSFILE'
     C                   PARM      PSEQN         SEQ               5
     C                   PARM                    SENTY             3
     C                   PARM                    SFILE1
     C                   PARM                    ZSNUM
     C                   PARM                    ZSERR             1
      *
      **  If Error occurs during ZSFILE processing, then return to the
      **  Calling Program.
      *
     C     ZSERR         IFEQ      'Y'
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SRRCFA
      *****************************************************************
      *                                                               *
      *  SRRCFA - Subroutine to register the AU Printer File via RCF. *
      *                                                               *
      *  Called By:  SRAUDT - Perform Audit Processing                *
      *  Calls    :  None                                             *
      *                                                               *
      *****************************************************************
      *
     C     SRRCFA        BEGSR                                                   *** SRRCFA ***
      *
      **  Ensure Audit Spool File recorded by RCF.
      *
     C                   Z-ADD     SFNUMU        ZSNUMU            6 0
      *
     C                   CALL      'ZSFILE'
     C                   PARM      PSEQN         SEQ
     C                   PARM      *BLANKS       SENTY
     C                   PARM                    SFILEU
     C                   PARM                    ZSNUMU
     C                   PARM      *BLANK        ZSERR
      *
      **  If Error occurs during ZSFILE processing, then return to the
      **  Calling Program.
      *
     C     ZSERR         IFEQ      'Y'
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/ZEDIT
     C*/COPY ZSRSRC,ZEDITZ2
     C********************************************************************
     C**                                                                 *
     C**  ZEDIT SUBROUTINE TO INSERT A DECIMAL POINT INTO A NUMERIC FIELD*
     C**  AND TO BLANK OUT LEADING ZEROES.                               *
     C**      INPUT FIELDS:   ZFIELD 16/                                 *
     C*                       ZADEC                                      *
     C*                       ZADIG - NOT ACTUALLY USED                  *
     C*                                                                  *
     C*       ARRAYS    ZA1 ,ZA2   BOTH 16 ELEMENTS, EACH ONE BYTE LONG. *
     C*                                                                  *
     C*       OUTPUT FIELD   ZFIELD                                      *
     C*                                                                  *
     C     ZEDIT         BEGSR                                                  ***  ZEDIT  ***
     C**
     C**   CALCULATION TO DEFINE NUMBER STRUCTURE CONTROL FIELDS.
     C                   Z-ADD     ZADIG         ZADIG             2 0
     C                   Z-ADD     ZADEC         ZADEC             1 0
     C**                                                                 *
     C*       SET UP WORK FIELDS                                         *
     C*                                                                  *
     C                   MOVEA     ' '           ZA1                                          *
     C                   MOVEA     ' '           ZA2                                          *
     C*                                                                  *
     C                   Z-ADD     16            Z1                2 0                        *
     C                   Z-ADD     16            Z2                2 0                        *
     C*                                                                  *
     C     16            SUB       ZADEC         ZADEC2            2 0                        *
     C*                                                                  *
     C*
     C                   MOVEA     ZFIELD        ZA1                                          *
     C*                                                                  *
     C*       CHECK TO SEE IF THERE ARE ANY DECIMAL PLACES               *
     C*                                                                  *
     C     ZADEC         COMP      0                                      91                  *
     C   91              GOTO      ZT20                                                       *
     C**                                                                 *
     C     ZT10          TAG                                                    ** ZT10 TAG ***
     C**                                                                 *
     C*                                                                  *
     C*       SET UP DECIMALS                                            *
     C*                                                                  *
     C                   MOVE      ZA1(Z1)       ZA2(Z2)                                      *
     C     Z1            SUB       1             Z1                                           *
     C     Z2            SUB       1             Z2                                           *
     C*                                                                  *
     C     Z2            COMP      0                                      90                  *
     C   90              GOTO      ZT30                                                       *
     C*                                                                  *
     C*       CHECK IF END OF DECIMALS                                   *
     C**                                                                 *
     C     Z2            COMP      ZADEC2                             90                      *
     C   90              GOTO      ZT10                                                       *
     C*                                                                  *
     C**                                                                 *
     C*       PUT IN DECIMAL PLACE                                       *
     C*                                                                  *
     C                   MOVE      '.'           ZA2(Z2)                                      *
     C     Z2            SUB       1             Z2                                           *
     C*                                                                  *
     C     ZT20          TAG                                                    ** ZT20 TAG ***
     C*                                                                  *
     C*       SET UP INTEGERS                                            *
     C*                                                                  *
     C                   MOVE      ZA1(Z1)       ZA2(Z2)                                      *
     C     Z1            SUB       1             Z1                                           *
     C     Z2            SUB       1             Z2                                           *
     C**                                                                 *
     C     Z2            COMP      0                                  90                      *
     C   90              GOTO      ZT20                                                       *
     C*                                                                  *
     C*       PUT IN LEADING BLANKS                                      *
     C*                                                                  *
     C     ZT30          TAG                                                    ** ZT30 TAG ***
     C**                                                                 *
     C                   Z-ADD     1             Z2                                           *
     C**                                                                 *
     C     ZT40          TAG                                                    ** ZT40 TAG ***
     C*                                                                  *
     C     ZA2(Z2)       COMP      '0'                                9090                    *
     C   90ZA2(Z2)       COMP      ' '                                9090                    *
     C*                                                                  *
     C   90              GOTO      ZT50                                                       *
     C*                                                                  *
     C                   MOVE      ' '           ZA2(Z2)                                      *
     C     Z2            ADD       1             Z2                                           *
     C*                                                                  *
     C     Z2            COMP      16                                   90                    *
     C   90              GOTO      ZT40                                                       *
     C*                                                                  *
     C*       IF NO INTEGERS PUT IN LEADING ZERO                         *
     C*                                                                  *
     C     ZT50          TAG                                                    ** ZT50 TAG ***
     C*                                                                  *
     C                   Z-ADD     ZADEC2        Z2                                           *
     C  N91Z2            SUB       1             Z2                                           *
     C     ZA2(Z2)       COMP      ' '                                    90                  *
     C   90              MOVE      '0'           ZA2(Z2)                                      *
     C*                                                                  *
     C*       SET UP OUTPUT FIELD                                        *
     C*                                                                  *
     C     ZT60          TAG                                                    ** ZT60 TAG ***
     C*                                                                  *
     C                   MOVEA     ZA2           ZFIELD           16                          *
     C**                                                                 *
     CSR   ZEND          ENDSR                                                  ** ZEND **    *
     C*****************************************************************
      /TITLE SR/ZFRPED
     C*/COPY ZSRSRC,ZFRPEDZ3
     C********************************************************************
     C**                                                                 *
     C** ZFRPED subroutine to insert a decimal point and sign into a     *
     C** numeric field and to blank out leading zeros (optionaly         *
     C** inserting commas).                                              *
     C**     Input fields:   ZFLD15 15/0                                 *
     C**                     ZDECS  1/0                                  *
     C**                     ZECODE 1/  ('A','C','J','L' or blank)       *
     C**                                ( Default is 'J')                *
     C**     Arrays:         ZS1    15/1/0                               *
     C**                     ZS2    22/1/                                *
     C**                                                                 *
     C**     Output fields:  ZOUT22 22                                   *
     C**     Output fields:  ZOUT25 25  (ALIGNED BY DECIMAL POINT)       *
     C**          (The last 2 characters will be '  ','CR',or '- ')      *
     C**
     C     ZFRPED        BEGSR                                                  **  ZFRPED   *
     C*
     C* Define/Clear fields
     C*
     C                   Z-ADD     ZFLD15        ZFLD15           15 0
     C                   Z-ADD     ZDECS         ZDECS             1 0
     C                   MOVE      ZECODE        ZECODE            1
     C                   MOVE      *BLANKS       ZOUT22           22
     C                   MOVE      *BLANKS       ZOUT25           25
     C     ZECODE        IFEQ      *BLANKS
     C                   MOVE      'J'           ZECODE
     C                   END
     C*
     C*       SET UP WORK FIELDS
     C*
     C                   Z-ADD     0             ZS1
     C                   MOVE      ' '           ZS2
     C*
     C                   Z-ADD     15            Z1                2 0
     C                   Z-ADD     20            Z2                2 0
     C*
     C     15            SUB       ZDECS         ZINTS             2 0
     C*
     C* Check if numeric field is negative
     C*
     C     ZFLD15        IFLT      *ZEROS
     C     ZECODE        IFEQ      'A'
     C     ZECODE        OREQ      'C'
     C                   MOVEA     'CR'          ZS2(21)
     C                   ELSE
     C                   MOVE      '-'           ZS2(21)
     C                   END
     C                   Z-SUB     ZFLD15        ZFLD15
     C                   END
     C*
     C                   Z-ADD     ZFLD15        ZWRK15
     C*
     C*       CHECK TO SEE IF THERE ARE ANY DECIMAL PLACES
     C*
     C     ZDECS         CABEQ     0             ZS10
     C*
     C*       SET UP DECIMALS
     C*
     C                   Z-ADD     *ZEROS        ZCNT              1 0
     C     ZCNT          DOUEQ     ZDECS
     C                   MOVE      ZS1(Z1)       ZS2(Z2)
     C                   SUB       1             Z2
     C                   ADD       1             ZCNT
     C                   SUB       1             Z1
     C                   END
     C*
     C*       PUT IN DECIMAL PLACE
     C*
     C                   MOVE      '.'           ZS2(Z2)
     C                   SUB       1             Z2
     C*
     C     ZS10          TAG                                                    ** ZS10 TAG **
     C*
     C*       SET UP INTEGERS
     C*
     C                   Z-ADD     *ZEROS        CNT3              1 0
     C     Z1            DOUEQ     *ZEROS
     C                   MOVE      ZS1(Z1)       ZS2(Z2)
     C                   SUB       1             Z1
     C                   SUB       1             Z2
     C*
     C* If edit code is 'J', insert a ',' before each group of three
     C* digits - not if beginning of array reached.
     C*
     C     Z2            IFGT      *ZEROS
     C     ZECODE        ANDEQ     'J'
     C     Z2            ORGT      *ZEROS
     C     ZECODE        ANDEQ     'A'
     C                   ADD       1             CNT3
     C     CNT3          IFEQ      3
     C                   MOVE      ','           ZS2(Z2)
     C                   SUB       1             Z2
     C                   Z-ADD     *ZEROS        CNT3
     C                   END
     C                   END
     C*
     C                   END
     C*
     C*       PUT IN LEADING BLANKS
     C*
     C                   Z-ADD     1             Z2
     C     ZS2(Z2)       DOWEQ     '0'
     C     ZS2(Z2)       OREQ      ' '
     C     ZS2(Z2)       OREQ      ','
     C                   MOVE      ' '           ZS2(Z2)
     C                   ADD       1             Z2
     C     Z2            CABEQ     23            ZS20
     C                   END
     C*
     C*       IF NO INTEGERS PUT IN LEADING ZERO
     C*
     C     ZS20          TAG                                                    ** ZS20 TAG **
     C*
     C     Z2            IFEQ      23
     C     ZFLD15        IFEQ      0
     C     ZDECS         ANDEQ     0
     C                   SUB       3             Z2
     C                   ELSE
     C                   SUB       2             Z2
     C                   ENDIF
     C                   MOVE      '0'           ZS2(Z2)
     C                   ELSE
     C*
     C     ZS2(Z2)       IFEQ      '.'
     C                   SUB       1             Z2
     C                   MOVE      '0'           ZS2(Z2)
     C                   END
     C                   END
     C*
     C*       SET UP OUTPUT FIELD
     C*
     C                   MOVEA     ZS2           ZOUT22
     C*
     C     ZDECS         IFEQ      0
     C                   MOVE      ZOUT22        ZOUT0
     C                   ELSE
     C**
     C     ZDECS         IFEQ      1
     C                   MOVE      ZOUT22        ZOUT1
     C                   ELSE
     C**
     C     ZDECS         IFEQ      2
     C                   MOVE      ZOUT22        ZOUT2
     C                   ELSE
     C**
     C                   MOVE      ZOUT22        ZOUT3
     C                   END
     C**
     C                   END
     C**
     C                   END
     C**
     C                   ENDSR
     C*
      *****************************************************************
      * End of /COPY ZFRPEDZ3                                         *
     C********************************************************************
**  CPY@
(c) Finastra International Limited 2021
