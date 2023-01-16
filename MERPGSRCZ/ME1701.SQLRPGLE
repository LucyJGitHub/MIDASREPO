     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD058081
/*STD *  RPGSQLBND                                                    *                     MD058081
/*EXI *  TEXT('Midas ME Bilateral Agreement Types Report')
      *****************************************************************
      *                                                               *
      *  Midas - Message Management Module                            *
      *                                                               *
      *  ME1701 - Bilateral Agreement Types List Report               *
      *                                                               *
      *  Function:  This program will list details of each of the     *
      *  (I/C)      Bilateral Agreement Types that have been          *
      *             defined to the system at the time of request.     *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD058081           Date 11May21               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014             Date 25May00               *
      *                 CFT013  *CREATE    Date 25May00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058081 - Deliverable Data Split for ME and MS              *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CFT014 - Straight-through Processing Phase 2 MT103 Messages  *
      *           Generation for FT.                                  *
      *  CFT013 - Straight-through Processing Phase 2 MT103 Messages  *
      *           Generation for non-FT.                              *
      *                                                               *
      *****************************************************************
     F*MEBATYL1* IF   E           K DISK                                                    MD058081
     FME1701AU  O    E             PRINTER
     F                                     INFDS(SPOOLU)
     FME1701P1  O    E             PRINTER USROPN
     F                                     INFDS(SPOOL1)
     F                                     RENAME(ME1701F1:ME1701R1)
     F                                     RENAME(ME1701F2:ME1701R2)
     F                                     RENAME(ME1701F3:ME1701R3)
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   37  - Multibranching ON                                     *
      *   60  - Read Indicator for MEBATYL1                           *
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
      *  SRINIT - Program Initialisation                              *
      *  SRPROC - Details Processing                                  *
      *  SRREPT - Process Report Lines                                *
      *                                                               *
      *  SP1REC - Format and Write a Detail Record to the Report      *
      *  SP1END - Write End of Report                                 *
      *                                                               *
      *  SRAUDT - Produce Audit Report and End Program                *
      *  *PSSR  - Program Error Processing Subroutine                 *
      *  SRCFP1 - RCF Processing for P1 Report                        *
      *  SRCFAU - RCF Processing for Audit Report                     *
      *                                                               *
      *****************************************************************
      /EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** Array containing Copyright statement
      *
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Rundate
      *
     D PSDS           SDS
      *
      ** Program Status Data Structure
      *
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
     D SPOOL1          DS
      *
      ** File Information Data Structure for M1701P1.
      *
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
      *
     D SPOOLU          DS
      *
      ** File Information Data Structure for ME1701AU.
      *
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      **  First DS for access programs, short data structure
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** External data structures for Bank Details
      *
     D MEBATY        E DS                  EXTNAME(MEBTYJW0)                                MD058081
     C/TITLE Main Processing
      *================================================================
      *  P R O G R A M   S T A R T                                    *
      *================================================================
      *
      ***  Perform Initialisation.
      *
     C                   EXSR      SRINIT
      *
      ***  Perform Detail Processing.
      *
     C                   EXSR      SRPROC
      *
      ***  Output Audit Report and End Program.
      *
     C                   EXSR      SRAUDT
      *
      *================================================================
      *  P R O G R A M   E N D                                        *
      *================================================================
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRINIT - Subroutine to do Program Initialisation.            *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls    :                                                   *
      *  SRCFAU - RCF Processing for Audit Report                     *
      *  AOBANKR0 Access Program                                      *
      *                                                               *
      *****************************************************************
      *
     C     SRINIT        BEGSR
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
     C                   MOVE      USER          RUSER
      *
      ** Receive Parameter List.
      *
     C     *ENTRY        PLIST
     C                   PARM                    PSEQ              5
      *
      ** Initialise LDA field.
      *
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVEL     'ME1701'      DBPGM
     C                   MOVE      *BLANKS       DBFILE
     C                   MOVE      *BLANKS       DBKEY
     C                   Z-ADD     0             DBASE
     C                   OUT       LDA
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
     C     *LOCK         IN        LDA
     C                   MOVEL     '*FIRST'      DBKEY
     C                   MOVE      'SDBANKPD'    DBFILE
     C                   Z-ADD     1             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Check System Date Format, DDMMYY (*IN98 off)
      **                           MMDDYY (*IN98 on).
      *
     C     BJDFIN        IFEQ      'M'
     C                   MOVE      *ON           *IN98
     C                   ENDIF
      *
      ** Access RUNDAT for multibranching indicator
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
     C     AGMBIN        IFEQ      'M'
     C                   MOVE      *ON           *IN37
     C                   END
      *
      ** RCF Processing for Audit File.
      *
     C                   EXSR      SRCFAU
      *
      ** Report Work fields.
      *
     C                   Z-ADD     0             RQDLN1            3 0
     C                   Z-ADD     0             DIFLN1            3 0
      *
      ** Register GL3300P1 to RCF
      *
     C                   CLOSE     ME1701P1
     C                   OPEN      ME1701P1
     C                   EXSR      SRCFP1
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SRPROC
      *****************************************************************
      *                                                               *
      *  SRPROC - Subroutine to do the Detail Processing.             *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls    :                                                   *
      *  SRAUDT - Produce Audit Report and End Program                *
      *  SRREPT - Process Report Lines                                *
      *  SRBRCH - Process Branch Details                              *
      *  SRCFP1 - RCF Processing for P1 Report/s                      *
      *  SP1END - Write End of Report                                 *
      *                                                               *
      *****************************************************************
      *
     C     SRPROC        BEGSR
      *
     C******LOVAL        SETLL     MEBATYL1                                                 MD058081
      *
      ** Read Bilateral Agreements Type Logical File
      *
     C**********         READ      MEBATYL1                               60                MD058081
     C/EXEC SQL                                                                             MD058081
     C+ declare ACursor insensitive scroll cursor for                                       MD058081
     C+ select * from MEBTYJW0                                                              MD058081
     C+ order by M1BATY                                                                     MD058081
     C/END-EXEC                                                                             MD058081
                                                                                            MD058081
     C/EXEC SQL                                                                             MD058081
     C+ open ACursor                                                                        MD058081
     C/END-EXEC                                                                             MD058081
                                                                                            MD058081
     C/EXEC SQL                                                                             MD058081
     C+ fetch next from ACursor into :MEBATY                                                MD058081
     C/END-EXEC                                                                             MD058081
      *
      ** If end of records, generate audit reporting to report
      ** no records found.
      *
     C******IN60         IFEQ      *ON                                                      MD058081
     C     SQLCODE       IFEQ      100                                                      MD058081
     C                   EXSR      SRAUDT
     C                   ELSE
      *
     C******IN60         DOWEQ     *OFF                                                     MD058081
     C     SQLCODE       DOWEQ     0                                                        MD058081
      *
      ** RCF Processing for Printer File.
      *
     C                   ADD       1             RCOUNT            5 0
      *
      ** Process Report Lines.
      *
     C                   EXSR      SRREPT
      *
      ** Read next record.
      *
     C**********         READ      MEBATYL1                               60                MD058081
     C/EXEC SQL                                                                             MD058081
     C+ fetch next from ACursor into :MEBATY                                                MD058081
     C/END-EXEC                                                                             MD058081
      *
      ** End of Do While not End of File.
      *
     C                   ENDDO
      *
     C                   ENDIF
      *
      ** Write final records and Totals to Report.
      *
     C                   EXSR      SP1END
      *
     C/EXEC SQL                                                                             MD058081
     C+ close ACursor                                                                       MD058081
     C/END-EXEC                                                                             MD058081
                                                                                            MD058081
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SRREPT
      *****************************************************************
      *                                                               *
      *  SRREPT - Process Report Lines.                               *
      *                                                               *
      *  Called By: SRPROC                                            *
      *  Calls    :                                                   *
      *  SP1REC - Format and Write a Detail Record to the Report      *
      *                                                               *
      *****************************************************************
      *
     C     SRREPT        BEGSR
      *
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
      *
     C                   Z-ADD     1             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     ME1701R1
     C                   ENDIF
      *
     C                   EXSR      SP1REC
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SP1REC
      *****************************************************************
      *                                                               *
      *  SP1REC - Subroutine to Write a Detail record to the Report.  *
      *                                                               *
      *  Called By: SRPROC                                            *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     SP1REC        BEGSR
      *
      ** Bilateral Agreeement Type
      *
     C                   MOVE      M1BATY        RM1BTY
      *
      ** Bilateral Agreeement Type Description
      *
     C                   MOVE      M1BATD        RM1BTD
      *
      ** Write out Detail Record.
      *
     C                   WRITE     ME1701R2
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SP1END
      *****************************************************************
      *                                                               *
      *  SP1END - Subroutine to Write End of Report.                  *
      *                                                               *
      *  Called By: SRPROC                                            *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     SP1END        BEGSR
      *
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
      *
     C                   Z-ADD     4             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     ME1701R1
     C                   ENDIF
      *
      ** Write out Total Format.
      *
     C                   WRITE     ME1701R3
      *
     C                   CLOSE     ME1701P1
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SRAUDT
      *****************************************************************
      *                                                               *
      *  SRAUDT - Subroutine to Output Audit report and End Program.  *
      *                                                               *
      *  Called By: Main Processing, SRPROC, *PSSR                    *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRAUDT        BEGSR
      *
      ** Display user
      *
     C                   MOVEL     USER          RUSER
      *
      **  Output Report Header and File Controls.
      *
     C                   WRITE     ME1701F1
      *
      ** If there is a DB Error, Output the DB Error Information.
      *
     C     *INU7         IFEQ      *ON
     C                   WRITE     ME1701F4
     C                   ELSE
      *
      ** If no records read, output no details to report.
      *
     C     RCOUNT        IFEQ      0
     C                   WRITE     ME1701F3
     C                   ELSE
      *
      ** Output no. of records processed.
      *
     C                   MOVEL     RCOUNT        RPROC
     C                   WRITE     ME1701F2
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** End Program and Return.
      *
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/*PSSR
      *****************************************************************
      *                                                               *
      *  *PSSR  - Error control subroutine                            *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
      *
      ** Check to see that *PSSR has not already been called.
      *
     C     WRUN          IFEQ      *BLANK
     C                   MOVE      'Y'           WRUN              1
     C                   EXSR      SRAUDT
     C                   DUMP
     C                   ENDIF
      *
      ** If *PSSR already run, then just end the program here.
      *
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SRCFP1
      *****************************************************************
      *                                                               *
      *  SRCFP1 - Subroutine to register the P1 Printer File via RCF. *
      *                                                               *
      *****************************************************************
      *
     C     SRCFP1        BEGSR
      *
      ** Ensure Report Spool File recorded by RCF.
      *
     C                   Z-ADD     SFNUM1        ZSNUM             6 0
      *
     C                   CALL      'ZSFILE'
     C                   PARM      PSEQ          SEQ               5
     C                   PARM                    SENTY             3
     C                   PARM                    SFILE1
     C                   PARM                    ZSNUM
     C                   PARM      *BLANKS       ZSERR             1
      *
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
      *
     C     ZSERR         IFEQ      'Y'
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SRCFAU
      *****************************************************************
      *                                                               *
      *  SRCFAU - Subroutine to register the AU Printer File via RCF. *
      *                                                               *
      *****************************************************************
      *
     C     SRCFAU        BEGSR
      *
      ** Ensure Audit Spool File recorded by RCF.
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
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
