     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas TI Postings report MODULE')
      *****************************************************************
      *                                                               *
      *  Midas - Trade Innovation Module                              *
      *                                                               *
      *  TI0330M - TI Postings Report                                 *
      *                                                               *
      *  Function:  This program prints a report TI0330P1 of all of   *
      *             'shadow posted' postings from the TI Postings file*
      *  (phases: I/C (on request), COB)                              *
      *                                                               *
      *  Called By: TIC0330 - TI Postings Report Control Program      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      *                 212558             Date 31Jan03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 06Jun01               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 161459             Date 01AUG99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CEU029             Date 04SEP98               *
      *                 CTI001 *CREATE     Date 18JUL97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits (Recompile)      *
      *  212558 - Recompile over changed file TIPOSTL3.               *
      *  CSD006 - Use long DS with SDBSRTPD and SDCURRPD.             *
      *  161459 - Value date is formatted incorrectly                 *
      *         - Use the TIDCIN-debit/credit ind. to check if it is  *
      *           credit amount.                                      *
      *         - Changed program to use the currency's number of     *
      *           decimal places to determine the amount's decimal.   *
      *  CEU029 - EMU Midas/Trade Innovation Interface Enhancements:  *
      *           include Original Ccy and Amount on report.          *
      *  CTI001 - Midas / Trade Innovation Interface Phase 1          *
      *                                                               *
      *****************************************************************
     FTIPOSTL3  IF   E           K DISK
     FTI0330AU  O    E             PRINTER
     F                                     INFDS(SPOOLU)
     FTI0330P1  O    E             PRINTER USROPN
     F                                     INFDS(SPOOL1)
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   01  - EMU Midas/TI Interface Enhancements are switched on.  *         CEU029
      *   37  - Multibranching ON                                     *
      *                                                               *
      *                                                               *
      *   88  - Printer file TI0330P1 is open                         *
      *   89  - End of File TIPOSTL3                                  *
      *                                                               *
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
      *  INIT   - Initialisation Processing                           *
      *  CHBR   - Change In Branch Processing                         *
      *  FRMT   - Format Report Details                               *
      *  TERM   - Termination Processing                              *
      *                                                               *
      *  *PSSR  - Program Error Processing Subroutine                 *
      *  RCFAU  - RCF Processing for Audit Report                     *
      *                                                               *
      *  ZSEDITM - Edit an Amount                                     *
      *                                                               *
      *****************************************************************
     D/EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** Array containing Copyright statement
      *
     D ZMNM            S              3    DIM(12) CTDATA PERRCD(12)            ZDATE2 SR. ARRAY
      *
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
      *
     D PSDS           SDS
      *
      ** Program Status Data Structure
      *
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
     D SPOOL1          DS
      ***  File Information Data Structure for TI0330P1.
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
      *
     D SPOOLU          DS
      ***  File Information Data Structure for TI0330AU.
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
      *
      ***  Dummy Data Structures used by Access Programs.
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D*  Short DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)                       CEU029
      *  Second DS for access programs, long data structure                     CEU029
     D**
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ***  External data structures for Bank Details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ***  External data structures for Branch Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)                    CEU029
      ***  External data structures for Currency Details                        CEU029
     D ACODA           S             10A                                                      CGL029
                                                                                              CGL029
     D/TITLE Main Processing
      *================================================================
      *  P R O G R A M   S T A R T                                    *
      *================================================================
      *
      ***  Perform Initialisation.
      *
     C                   EXSR      INIT
      *
      ***  Read first record on TIPOSTL3
      *
     C                   READ      TIPOSTL3                               89
      *
      ***  Do while not end of file
      *
     C     *IN89         DOWEQ     *OFF
      *
      ***  Only process this record if the entity is 'ALL' or this branch
      *
     C     PENT          IFEQ      'ALL'
     C     PENT          OREQ      BRCA
      *
      ***  Count records read.
      *
     C                   ADD       1             RCOUNT
      *
      ***  If branch has changed then
      ***  perform change of branch processing
      *
     C     BRCA          IFNE      BRCAX
     C                   EXSR      CHBR
     C                   ENDIF
      *
      ***  Set up report details
      *
     C                   EXSR      FRMT
      *
      ***  Write a report detail record
      *
     C                   WRITE     DETAIL
      *
     C                   ENDIF
      *
      ***  Read next record on TIPOSTL3
      *
     C                   READ      TIPOSTL3                               89
      *
     C                   ENDDO
      *
      ***  Perform Termination Processing
      *
     C                   EXSR      TERM
      *
      *================================================================
      *  P R O G R A M   E N D                                        *
      *================================================================
     C/EJECT
      *****************************************************************
      *                                                               *
      *  INIT   - Subroutine to do Program Initialisation.            *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls:                                                       *
      *  *PSSR  - Program error processing subroutine                 *
      *  AOBANKR0 Access Program                                      *
      *  RCFAU  - RCF Processing for Audit Report                     *
      *                                                               *
      *****************************************************************
      *
     C     INIT          BEGSR                                                  ***  INIT  ***
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
      ***  Receive Parameter List.
      *
     C     *ENTRY        PLIST
     C                   PARM                    PSEQ              5
     C                   PARM                    PENT              3
      *
      ***  Initialise LDA field.
      *
     C                   MOVEL     'TI0330'      DBPGM
      *
      ***  Call Access Program for Bank Details - Title, Run Date and
      ***  Run Day Number.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     WRTCD             7
     C                   PARM      '*FIRST '     WOPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ***  Handle Database Error.
      *
     C     WRTCD         IFNE      *BLANKS
     C                   MOVE      'SDBANKPD'    DBFILE                         ***************
     C                   Z-ADD     001           DBASE                          * DB ERROR 01 *
     C                   EXSR      *PSSR                                        ***************
     C                   ENDIF
      *
      ***  Check System Date Format, DDMMYY (*IN98 off)
      ***                            MMDDYY (*IN98 on).
      *
     C     BJDFIN        IFEQ      'M'
     C                   SETON                                        98
     C                   ENDIF
      *
      **   Access RUNDAT for multibranching indicator
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C     *DTAARA       DEFINE                  LDA
     C                   IN        RUNDAT
      *
     C     AGMBIN        IFEQ      'Y'
     C                   SETON                                        37
     C                   END
      *
      ***  RCF Processing for Audit File.
      *
     C                   EXSR      RCFAU
      *
      ***  Report Work fields.
      *
     C                   Z-ADD     0             RQDLN1            3 0
     C                   Z-ADD     0             DIFLN1            3 0
      *
      ***  Initialise record count for TIPOSTL3.
      *
     C                   Z-ADD     0             RCOUNT            5 0
      *                                                                         CEU029
      ** Access SAR details file to determine if CEU029 is installed.           CEU029
      *                                                                         CEU029
     C                   CALL      'AOSARDR0'                                   CEU029
     C                   PARM      '       '     ##RTCD            7            CEU029
     C                   PARM      '*VERIFY'     ##OPTN            7            CEU029
     C                   PARM      'CEU029'      ##SARD            6            CEU029
      *                                                                         CEU029
      ** Database Error                                                         CEU029
      *                                                                         CEU029
     C     ##RTCD        IFNE      *BLANK                                       CEU029
     C     ##RTCD        ANDNE     '*NRF   '                                    CEU029
     C                   Z-ADD     4             DBASE                          CEU029*********
     C                   MOVEL     'SCSARDPD'    DBFILE                         CEU029RROR 04 *
     C                   MOVEL     '*CALL'       DBKEY                          CEU029*********
     C                   EXSR      *PSSR                                        CEU029
     C                   ENDIF                                                  CEU029
     C*                                                                         CEU029
     C     ##RTCD        IFEQ      *BLANK                                       CEU029
     C                   MOVEL     'Y'           CEU029            1            CEU029
     C                   MOVE      *ON           *IN01                          CEU029
     C                   ELSE                                                   CEU029
     C                   MOVEL     'N'           CEU029                         CEU029
     C                   MOVE      *OFF          *IN01                          CEU029
     C                   ENDIF                                                  CEU029
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/CHBR
      *****************************************************************
      *                                                               *
      *  CHBR   - Change in branch processing.                        *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls:                                                       *
      *  ZSFILE - Midas FC set up spool file numbers                  *
      *  *PSSR  - Program error processing subroutine                 *
      *  AOBRCHR0 Access Program                                      *
      *                                                               *
      *****************************************************************
      *
     C     CHBR          BEGSR                                                  *** CHBR   ***
      *
      ***  If printer file TI0330P1 is already open then
      *
     C     *IN88         IFEQ      *ON
      *
      ***  Check that sufficient lines remain for the trailer. If not,
      ***  write out the Main Headings on a new page.
      *
     C                   Z-ADD     4             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     HEADP1
     C                   WRITE     HEADP2
     C                   ENDIF
      *
      ***  output the report trailer and close printer file TI0330P1
      *
     C                   WRITE     TRAILP1
     C                   CLOSE     TI0330P1
     C                   MOVE      *OFF          *IN88
     C                   ENDIF
      *
      ***  Open printer file TI0330P1.
      *
     C                   OPEN      TI0330P1
     C                   MOVE      *ON           *IN88
      *
      ***  Ensure Report Spool File recorded by RCF.
      *
     C                   Z-ADD     SFNUM1        ZSNUM             6 0
      *
     C                   CALL      'ZSFILE'
     C                   PARM      PSEQ          SEQ               5
     C                   PARM      PENT          SENTY             3
     C                   PARM                    SFILE1
     C                   PARM                    ZSNUM
     C                   PARM                    ZSERR             1
      *
      ***  If Error occurs during ZSFILE processing, then return to the
      ***  Calling Program.
      *
     C     ZSERR         IFEQ      'Y'
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDIF
      *
      ***  Call Access Program for Branch Details
      *
     C**********         CALL      'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      '*MSG   '     WRTCD             7
     C                   PARM      '*KEY   '     WOPTN             7
     C                   PARM                    BRCA
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
      *
      ***  Handle Database Error.
      *
     C     WRTCD         IFNE      *BLANKS
     C                   MOVE      'SDBRCHPD'    DBFILE                         ***************
     C                   Z-ADD     002           DBASE                          * DB ERROR 02 *
     C                   EXSR      *PSSR                                        ***************
     C                   ENDIF
      *
      ***  Output the report header
      *
     C                   WRITE     HEADP1
     C                   WRITE     HEADP2
      *
      ***  Save the current branch as BRCAX
      *
     C                   MOVE      BRCA          BRCAX             3
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/FRMT
      *****************************************************************
      *                                                               *
      *  FRMT   - Format report details.                              *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls:                                                       *
      *  ZSEDITM - Edit an Amount                                     *
      *                                                               *
      *****************************************************************
      *
     C     FRMT          BEGSR                                                  *** FRMT   ***
      *
      ***  Check that sufficient lines remain for the Format. If not,
      ***  write out the Main Headings on a new page.
      *
     C                   Z-ADD     2             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     HEADP1
     C                   WRITE     HEADP2
     C                   ENDIF
      *
      *** format Midas Account field
      *
     C                   MOVE      CNUM          CNUMA             6
     C**********         MOVE      ACOD          ACODA             4                          CGL029
     C                   MOVE      ACOD          ACODA                                        CGL029
     C                   MOVE      ACSQ          ACSQA             2
     C                   MOVE      *BLANKS       ACOUNT
     C                   MOVEL     CNUMA         ACOUNT
     C                   CAT       '-':0         ACOUNT
     C                   CAT       CCY:0         ACOUNT
     C                   CAT       '-':0         ACOUNT
     C                   CAT       ACODA:0       ACOUNT
     C                   CAT       '-':0         ACOUNT
     C                   CAT       ACSQA:0       ACOUNT
      *
      *** format Value Date field
      *
     C                   MOVE      TIVALD        DAY               2
     C                   MOVEL     TIVALD        TEMP              3
     C                   MOVE      TEMP          YEAR              2
     C                   MOVE      TIVALD        TEMP2             4 0
     C                   MOVEL     TEMP2         MNTH              2 0
     C                   MOVE      ZMNM(MNTH)    MONTH             3
     C*******************MOVEL     DAY           VDATE                          161459
     C*******************CAT       MONTH:0       VDATE                          161459
     C*******************CAT       YEAR:0        VDATE                          161459
     C                   EVAL      VDATE = *BLANKS                              161459
     C                   EVAL      VDATE = DAY + MONTH + YEAR                   161459
     C** Access the Currency Details.                                           161459
     C                   CALL      'AOCURRR0'                                   161459
     C                   PARM      *BLANKS       WRTCD                          161459
     C                   PARM      '*KEY   '     WOPTN                          161459
     C                   PARM                    CCY                            161459
     C*****SDCURR        PARM      SDCURR        DSFDY                   161459 CSD006
     C     SDCURR        PARM      SDCURR        DSSDY                          CSD006
     C     WRTCD         IFNE      *BLANKS                                      161459
     C                   MOVEL     'SDCURRPD'    DBFILE                         161459
     C                   Z-ADD     003           DBASE                          161459
     C                   EXSR      *PSSR                                        161459
     C                   ENDIF                                                  161459
      *
      *** format Amount field
      *
     C                   CALLB     'ZSEDIT'
     C                   PARM      TIAMNT        AmountNum        15 0          I:NUMERIC FIELD
     C*******************PARM      2             Decimals          1 0          161459 # of decimals
     C                   PARM      A6NBDP        Decimals          1 0          161459
     C                   PARM      'J'           EditCode          1            I:EDIT CODE
     C     AMOUNT        PARM      *BLANK        AmountChar       21            O:FUNCTION FIELD
     C*
     C                   MOVE      *BLANKS       CR                2
     C     TIAMNT        IFLT      0
     C     TIDCIN        OREQ      'C'                                          161459
     C                   MOVE      'CR'          CR
     C                   ENDIF
     C                   CAT       CR:0          AMOUNT
      *
      *** format Original Amount field                                          CEU029
      *                                                                         CEU029
     C     CEU029        IFEQ      'Y'                                          CEU029
     C     TIOCCY        ANDNE     *BLANKS                                      CEU029
     C                   CALL      'AOCURRR0'                                   CEU029
     C                   PARM      *BLANKS       WRTCD             7            CEU029
     C                   PARM      '*KEY'        WOPTN             7            CEU029
     C                   PARM      TIOCCY        ##CCY             3            CEU029
     C     SDCURR        PARM      *BLANK        DSSDY                          CEU029
      *                                                                         CEU029
      ***  Handle Database Error.                                               CEU029
      *                                                                         CEU029
     C     WRTCD         IFNE      *BLANKS                                      CEU029
     C                   MOVE      'SDCURRPD'    DBFILE                         CEU029*********
     C                   Z-ADD     003           DBASE                          CEU029RROR 03 *
     C                   EXSR      *PSSR                                        CEU029*********
     C                   ENDIF                                                  CEU029
      *                                                                         CEU029
     C                   CALLB     'ZSEDIT'                                     CEU029
     C                   PARM      TIOAMT        AmountNum        15 0          CEU029
     C                   PARM      A6NBDP        Decimals          1 0          CEU029
     C                   PARM      'J'           EditCode          1            CEU029
     C     ORGAMT        PARM      *BLANK        AmountChar       21            CEU029
     C*                                                                         CEU029
     C                   MOVE      *BLANKS       CR                2            CEU029
     C     TIOAMT        IFLT      0                                            CEU029
     C                   MOVE      'CR'          CR                             CEU029
     C                   ENDIF                                                  CEU029
     C                   CAT       CR:0          ORGAMT                         CEU029
     C                   ELSE                                                   CEU029
     C                   MOVE      *BLANKS       ORGAMT                         CEU029
     C                   ENDIF                                                  CEU029
      *                                                                         CEU029
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/*PSSR
      *****************************************************************
      *                                                               *
      *  *PSSR  - Error control subroutine                            *
      *  Calls:   none                                                *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR **
      *
      ***  Check to see that *PSSR has not already been called.
      *
     C     WRUN          IFEQ      *BLANK
     C                   MOVE      'Y'           WRUN              1
      *
     C     *DTAARA       DEFINE    LDA           WLDA            256
     C     *LOCK         IN        WLDA
     C                   MOVEL     LDA           WLDA
     C                   OUT       WLDA
      *
     C                   SETON                                        U7U8LR
     C                   DUMP
      *
      ***  Output Audit Report Header and DB Error Information.
      *
     C                   WRITE     HEADAU
     C                   WRITE     DBERROR
      *
     C                   ENDIF
      *
      ***  If *PSSR already run, then just end the program here.
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/TERM
      *****************************************************************
      *                                                               *
      *  TERM   - Termination Processing.                             *
      *  Called By: Main Processing                                   *
      *  Calls:     none                                              *
      *                                                               *
      *****************************************************************
      *
     C     TERM          BEGSR                                                   *** TERM   ***
      *
      ***  If printer file TI0330P1 is open then
      *
     C     *IN88         IFEQ      *ON
      *
      ***  Check that sufficient lines remain for the trailer. If not,
      ***  write out the Main Headings on a new page.
      *
     C                   Z-ADD     4             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     HEADP1
     C                   WRITE     HEADP2
     C                   ENDIF
      *
      ***  output the report trailer and close printer file TI0330P1
      *
     C                   WRITE     TRAILP1
     C                   CLOSE     TI0330P1
     C                   MOVE      *OFF          *IN88
     C                   ENDIF
      *
      ***  If no details to report:
      *
     C     RCOUNT        IFEQ      0
      *
      ***  Output Report Header and 'No details to report' narrative.
      *
     C                   WRITE     HEADAU
     C                   WRITE     NODTLS
      *
     C                   ELSE
      *
      ***  Else output Report Header and file controls record.
      *
     C                   WRITE     HEADAU
     C                   WRITE     CONTROL
      *
     C                   ENDIF
      *
      ***  Set on last record indicator and return to calling program.
      *
     C                   SETON                                        LR
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/RCFAU
      *****************************************************************
      *                                                               *
      *  RCFAU  - Subroutine to register the AU Printer File via RCF. *
      *  Called By: INIT                                              *
      *  Calls:                                                       *
      *  ZSFILE - Midas FC set up spool file numbers                  *
      *                                                               *
      *****************************************************************
      *
     C     RCFAU         BEGSR                                                   *** RCFAU  ***
      *
      ***  Ensure Audit Spool File recorded by RCF.
      *
     C                   Z-ADD     SFNUMU        ZSNUMU            6 0
      *
     C                   CALL      'ZSFILE'
     C                   PARM      PSEQ          SEQ
     C                   PARM      *BLANKS       SENTY
     C                   PARM                    SFILEU
     C                   PARM                    ZSNUMU
     C                   PARM      *BLANK        ZSERR
      *
      ***  If Error occurs during ZSFILE processing, then return to the
      ***  Calling Program.
      *
     C     ZSERR         IFEQ      'Y'
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
**   ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
