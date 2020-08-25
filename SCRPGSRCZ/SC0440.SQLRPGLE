     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD055681
/*STD *  RPGSQLBND                                                    *                     MD055681
/*EXI *  TEXT('Midas SC SAR information file')
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SC0440 - Switchable Features Information File Report         *
      *           Generator.                                          *
      *                                                               *
      *  Function:  This program drives a printer file SC0440P1       *
      *  which displays switchable features details keyed by primary  *
      *  module, switchable feature number and release level.         *
      *                                                               *
      *  Called By: SCC4000                                           *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD055681           Date 31Jul20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CPK010             Date 29Sep99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CSC010             Date 20Jul99               *
      *                 CSC007             Date 08Feb98               *
      *                 CSC005  *CREATE    Date 08May98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055681 - Deliverable Data Split for SAR                    *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CPK010 - DBA3 Alphasite.                                     *
      *           - Hide Chargeable Field (recompile)                 *
      *  CSC010 - Add beta site processing.                           *
      *  CSC007 - Put RCF processing in. Change input parameters so   *
      *           that OPT flag is character, not numeric.            *
      *  CSC005 - New suite of programs and files to permit           *
      *           insertion of switchable features via passwords.     *
      *                                                               *
      *****************************************************************
     F*SCSARSPD* IF   E           K DISK                                                    MD055681
     FSC0440P1  O    E             PRINTER
     F                                     INFDS(SPOOL1)
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   37  - Multibranching ON                                     *
      *                                                               *
      *   51  - Option 1 selected from user menu                      *
      *   52  - Option 2 selected from user menu                      *
      *   53  - Option 3 selected from user menu                      *
      *                                                               *
      *   89  - End of File                                           *
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
      *  INIT   - Program Initialisation                              *
      *  PROCES - Detail Processing                                   *
      *  REPORT - Process Report Lines                                *
      *                                                               *
      *  WP1REC - Format and Write a Detail Record to the Report      *
      *  WP1END - Write End of Report                                 *
      *                                                               *
      ***AUDIT**-*Produce Audit Report and End Program*****************   CSC007
      *  *PSSR  - Program Error Processing Subroutine                 *
      *  RCFP1  - RCF Processing for P1 Report                        *
      ***RCFAU**-*RCF*Processing*for*Audit*Report**********************   CSC007
      *                                                               *
      *  ZDATE1 - Validate Date and Convert into Midas Day Number     *
      *  ZDATE2 - Convert Midas Day Number into Date (DDMMYY/MMDDYY)  *
      *
      *                                                               *
      *****************************************************************
     D/EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** Array containing Copyright statement
      *
     D*COPY ZSRSRC,ZDATE2Z1                                                                 MD055681
     D/COPY ZSRSRC,ZDATE2Z1LE                                                               MD055681
      /SPACE 3
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **                                    142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
      ** Data Area giving Installation Control Details
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
     D PSDS           SDS
      *
      ** Program Status Data Structure
      *
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
     D SPOOL1          DS
      ***  File Information Data Structure for SC0440
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
      *
      ***  Define Titles for report as constants
      *
     D WRD1            C                   CONST('Switchable Feature  -
     D                                     Number')
     D WRD2            C                   CONST('Primary Module')
     D WRD3            C                   CONST('Release Level')
      *
      ***  Dummy Data Structures used by Access Programs.
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D*                                                                   S01486
     D DSFDY         E DS                  EXTNAME(DSFDY)                       S01194
     I* FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE                S01194
     D SCSARS        E DS                  EXTNAME(SCSRSJW0)                                MD055681
      ***  External data structures for Bank Details
     C/TITLE Main Processing
      *================================================================
      *  P R O G R A M   S T A R T                                    *
      *================================================================
      *
      ***  Perform Initialisation.
      *
     C                   EXSR      INIT
      *
      ***  Perform Detail Processing.
      *
     C                   EXSR      PROCES
      *
      ***  Perform Detail Processing.
      *
     C                   EXSR      EXIT
      *
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
      *  AOBANKR0 Access Program                                      *
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
     C*********************PARM           OPT     10                      CSC007
     C**********         PARM                    OPT               1                  CSC00 MD055681
     C                   PARM                    OPT               1 0                      MD055681
     C                   PARM                    SEQNO             5
      *
      ***  Initialise indicators which condition printer file output.
      *
     C                   SELECT
     C***********OPT*******WHEQ*1****************                         CSC007
     C*****OPT           WHENEQ    '1'                                                CSC00 MD055681
     C     OPT           WHENEQ    1                                                        MD055681
     C                   MOVE      *ON           *IN51
     C***********OPT*******WHEQ*2****************                         CSC007
     C*****OPT           WHENEQ    '2'                                                CSC00 MD055681
     C     OPT           WHENEQ    2                                                        MD055681
     C                   MOVE      *ON           *IN52
     C***********OPT*******WHEQ*3****************                         CSC007
     C*****OPT**         WHENEQ    '3'                                                CSC00 MD055681
     C     OPT           WHENEQ    3                                                        MD055681
     C                   MOVE      *ON           *IN53
     C                   ENDSL
      *
      ***  Initialise LDA field.
      *
     C                   MOVEL     'SCSARS'      DBPGM
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
     C*
     C                   EXSR      RCFP1                                                       CSC00
      *
      ***  Check System Date Format, DDMMYY (*IN98 off)
      ***                            MMDDYY (*IN98 on).
      *
     C     BJDFIN        IFEQ      'M'
     C                   SETON                                        98
     C                   ENDIF
      *
      ***  Report Work fields.
      *
     C                   Z-ADD     0             RQDLN1            3 0
     C                   Z-ADD     0             DIFLN1            3 0
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/PROCES
      *****************************************************************
      *                                                               *
      *  PROCES - Subroutine to do the Detail Processing.             *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls:                                                       *
      *  AUDIT  - Produce Audit Report and End Program                *
      *  REPORT - Process Report Lines                                *
      *  WP1END - Write End of Report                                 *
      *                                                               *
      *****************************************************************
      *
     C     PROCES        BEGSR                                                  *** PROCES ***
      *
      ***  Read first record from File.
      *
     C**********         READ      SCSARSPD                               89                MD055681
     C                   SELECT                                                             MD055681
     C     OPT           WHENEQ    1                                                        MD055681
     C/EXEC SQL                                                                             MD055681
     C+ declare ACursor insensitive scroll cursor for                                       MD055681
     C+ select * from SCSRSJW0                                                              MD055681
     C+ where AXMODE = 'C'                                                                  MD055681
     C+ order by AXSARN                                                                     MD055681
     C/END-EXEC                                                                             MD055681
                                                                                            MD055681
     C/EXEC SQL                                                                             MD055681
     C+ open ACursor                                                                        MD055681
     C/END-EXEC                                                                             MD055681
                                                                                            MD055681
     C/EXEC SQL                                                                             MD055681
     C+ fetch next from ACursor into :SCSARS                                                MD055681
     C/END-EXEC                                                                             MD055681
                                                                                            MD055681
     C     OPT           WHENEQ    2                                                        MD055681
     C/EXEC SQL                                                                             MD055681
     C+ declare BCursor insensitive scroll cursor for                                       MD055681
     C+ select * from SCSRSJW0                                                              MD055681
     C+ where AXMODE = 'C'                                                                  MD055681
     C+ order by AXPRIM                                                                     MD055681
     C/END-EXEC                                                                             MD055681
                                                                                            MD055681
     C/EXEC SQL                                                                             MD055681
     C+ open BCursor                                                                        MD055681
     C/END-EXEC                                                                             MD055681
                                                                                            MD055681
     C/EXEC SQL                                                                             MD055681
     C+ fetch next from BCursor into :SCSARS                                                MD055681
     C/END-EXEC                                                                             MD055681
                                                                                            MD055681
     C     OPT           WHENEQ    3                                                        MD055681
     C/EXEC SQL                                                                             MD055681
     C+ declare CCursor insensitive scroll cursor for                                       MD055681
     C+ select * from SCSRSJW0                                                              MD055681
     C+ where AXMODE = 'C'                                                                  MD055681
     C+ order by AXRELL, AXIREL                                                             MD055681
     C/END-EXEC                                                                             MD055681
                                                                                            MD055681
     C/EXEC SQL                                                                             MD055681
     C+ open CCursor                                                                        MD055681
     C/END-EXEC                                                                             MD055681
                                                                                            MD055681
     C/EXEC SQL                                                                             MD055681
     C+ fetch next from CCursor into :SCSARS                                                MD055681
     C/END-EXEC                                                                             MD055681
                                                                                            MD055681
     C                   ENDSL                                                              MD055681
      *
      ***  Do Until End of File.
      *
     C******IN89         DOUEQ     *ON                                                      MD055681
     C                   DOU       SQLCODE = 100                                            MD055681
      *
      ***  Count records read.
      *
     C                   ADD       1             RCOUNT            5 0
      *
      ***  Process Report Lines.
      *
     C                   EXSR      REPORT
      *
      ***  Read next record.
      *
     C**********         READ      SCSARSPD                               89                MD055681
     C                   SELECT                                                             MD055681
     C     OPT           WHENEQ    1                                                        MD055681
     C/EXEC SQL                                                                             MD055681
     C+ fetch next from ACursor into :SCSARS                                                MD055681
     C/END-EXEC                                                                             MD055681
                                                                                            MD055681
     C     OPT           WHENEQ    2                                                        MD055681
     C/EXEC SQL                                                                             MD055681
     C+ fetch next from BCursor into :SCSARS                                                MD055681
     C/END-EXEC                                                                             MD055681
                                                                                            MD055681
     C     OPT           WHENEQ    3                                                        MD055681
     C/EXEC SQL                                                                             MD055681
     C+ fetch next from CCursor into :SCSARS                                                MD055681
     C/END-EXEC                                                                             MD055681
                                                                                            MD055681
     C                   ENDSL                                                              MD055681
      *
      ***  End of Do Until End of Valid Records.
     C                   ENDDO
      *
      *
      ***  Write final records and Totals to Report.
      *
     C                   EXSR      REPORT
     C                   EXSR      WP1END
      *
     C                   SELECT                                                             MD055681
     C     OPT           WHENEQ    1                                                        MD055681
     C/EXEC SQL                                                                             MD055681
     C+ close ACursor                                                                       MD055681
     C/END-EXEC                                                                             MD055681
                                                                                            MD055681
     C     OPT           WHENEQ    2                                                        MD055681
     C/EXEC SQL                                                                             MD055681
     C+ close BCursor                                                                       MD055681
     C/END-EXEC                                                                             MD055681
                                                                                            MD055681
     C     OPT           WHENEQ    3                                                        MD055681
     C/EXEC SQL                                                                             MD055681
     C+ close CCursor                                                                       MD055681
     C/END-EXEC                                                                             MD055681
                                                                                            MD055681
     C                   ENDSL                                                              MD055681
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/REPORT
      *****************************************************************
      *                                                               *
      *  REPORT - Process Report Lines.                               *
      *                                                               *
      *  Called By: PROCES                                            *
      *  Calls:                                                       *
      *  WP1REC - Format and Write a Detail Record to the Report      *
      *                                                               *
      *****************************************************************
      *
     C     REPORT        BEGSR                                                  *** REPORT ***
      *
      *----------------------------------------------------------------
      *
      *    Perform any necessary processing before writing detail line
      *
      *----------------------------------------------------------------
      *
      ***  Write out the record.
      *
     C                   EXSR      WP1REC
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/WP1REC
      *****************************************************************
      *                                                               *
      *  WP1REC - Subroutine to Write a Detail record to the Report.  *
      *                                                               *
      *  Called By:                                                   *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     WP1REC        BEGSR                                                  *** WP1REC ***
      *
      *----------------------------------------------------------------
      *
      *    Perform any formatting before printing via ZDATE2, ZSEDIT
      *
      *----------------------------------------------------------------
      *
      ***  Check that sufficient lines remain for the Format. If not,
      ***  write out the Main Headings on a new page.
      *
     C                   Z-ADD     1             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   SELECT
     C     *IN51         WHENEQ    *ON
     C                   MOVEL(P)  WRD1          KEYWRD           30
     C     *IN52         WHENEQ    *ON
     C                   MOVEL(P)  WRD2          KEYWRD
     C     *IN53         WHENEQ    *ON
     C                   MOVEL(P)  WRD3          KEYWRD
     C                   ENDSL
     C                   WRITE     HEADPY
     C                   ENDIF
      *
      ***  Write out Detail Record.
     C*                    MOVEL*BLANKS   REL1
     C*                    MOVEL*BLANKS   MANMSG
     C                   SELECT
     C     AXRSTS        WHENEQ    'R'
     C                   MOVEL(P)  'Rel'         REL1
     C                   MOVEL(P)  'Rel'         REL2
     C                   MOVEL(P)  'Rel'         REL3
     C     AXRSTS        WHENEQ    'A'
     C                   MOVEL(P)  'Alpha'       REL1
     C                   MOVEL(P)  'Alpha'       REL2
     C                   MOVEL(P)  'Alpha'       REL3
     C     AXRSTS        WHENEQ    'B'
     C                   MOVEL(P)  'Beta'        REL1
     C                   MOVEL(P)  'Beta'        REL2
     C                   MOVEL(P)  'Beta'        REL3
     C     AXRSTS        WHENEQ    'W'
     C                   MOVEL(P)  'Wait'        REL1
     C                   MOVEL(P)  'Wait'        REL2
     C                   MOVEL(P)  'Wait'        REL3
     C                   ENDSL
     C                   SELECT
     C     AXMNTB        WHENEQ    'C'
     C                   MOVEL(P)  'Core'        MAN1
     C                   MOVEL(P)  'Core'        MAN2
     C                   MOVEL(P)  'Core'        MAN3
     C     AXMNTB        WHENEQ    'B'
     C                   MOVEL(P)  'Branch'      MAN1
     C                   MOVEL(P)  'Branch'      MAN2
     C                   MOVEL(P)  'Branch'      MAN3
     C                   ENDSL
     C                   MOVE      *BLANKS       AXRSTS
     C                   MOVE      *BLANKS       AXMNTB
     C                   SELECT
     C***********OPT       WHEQ  1                                        CSC007
     C*****OPT**         WHENEQ    '1'                                                CSC00 MD055681
     C     OPT           WHENEQ    1                                                        MD055681
     C                   WRITE     DETAIL1
     C***********OPT       WHEQ  2                                        CSC007
     C*****OPT**         WHENEQ    '2'                                                CSC00 MD055681
     C     OPT           WHENEQ    2                                                        MD055681
     C                   WRITE     DETAIL2
     C***********OPT       WHEQ  3                                        CSC007
     C*****OPT**         WHENEQ    '3'                                                CSC00 MD055681
     C     OPT           WHENEQ    3                                                        MD055681
     C                   WRITE     DETAIL3
     C                   ENDSL
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/WP1END
      *****************************************************************
      *                                                               *
      *  WP1END - Subroutine to Write End of Report.                  *
      *                                                               *
      *  Called By: PROCES                                            *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     WP1END        BEGSR                                                  *** WP1END ***
      *
      ***  Check that sufficient lines remain for the Format. If not,
      ***  write out the Main Headings on a new page.
      *
     C                   Z-ADD     4             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     HEADPY
     C                   ENDIF
      *
      ***  Write out Total Format.
      *
     C                   WRITE     TRAILPY
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/RCFP1
      *****************************************************************
      *                                                               *
      *  RCFP1  - Subroutine to register the P1 Printer File via RCF. *
      *                                                               *
      *****************************************************************
      *
     C     RCFP1         BEGSR                                                   *** RCFP1  ***
      *
      ***  Ensure Report Spool File recorded by RCF.
      *
     C                   Z-ADD     SFNUM1        ZSNUM             6 0
     C                   CALL      'ZSFILE'
     C*********************PARM PSEQ      SEQ     5                       CSC007
     C*********************PARM           SENTY   3                       CSC007
     C                   PARM                    SEQNO
     C                   PARM      *BLANKS       ENTY              3
     C                   PARM                    SFILE1
     C                   PARM                    ZSNUM
     C                   PARM                    ZSERR             1
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
      *                                                               *
      *  EXIT   - Subroutine to END PROGRAM                           *
      *                                                               *
      *  Called By: PROCES                                            *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
     C     EXIT          BEGSR
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDSR
      *****************************************************************
      /TITLE SR/*PSSR
      *****************************************************************
      *                                                               *
      *  *PSSR  - Error control subroutine                            *
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
     C                   MOVEL     DBFILE        WLDA
     C                   OUT       WLDA
      *
     C                   SETON                                        U7U8LR
     C                   DUMP
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
      *
      *
      *****************************************************************
      /TITLE SR/ZDATE1
     C*COPY ZSRSRC,ZDATE1Z2                                                                 MD055681
     C/COPY ZSRSRC,ZDATE1Z2LE                                                               MD055681
      /TITLE SR/ZDATE2
     C*COPY ZSRSRC,ZDATE2Z2                                                                 MD055681
     C/COPY ZSRSRC,ZDATE2Z2LE                                                               MD055681
**  CPY@
(c) Finastra International Limited 2001
**   ZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
0366073110961461
**   ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
000031059090120151181212243273304334365
**   ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
