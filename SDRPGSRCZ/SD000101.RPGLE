     H DEBUG
     H DFTACTGRP(*NO)
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Customer Segmentation Group Report')          *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000101 - Customer Segmentation Group Report                *
      *                                                               *
      *  Function:  This program will produce on-request Input Cycle  *
      *             or COB report that will list the Customer         *
      *             Segmentation Group hierarchy including orphans    *
      *             customer segmentation code                        *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR819241           Date 24Aug11               *
      *                 CSD090  *CREATE    Date 06Dec10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR819241 - Customer Segmentation Code in SD000101P1 not      *
      *             displayed properly (Recompile)                    *
      *  CSD090 - Customer Segmentation and Overdraft                 *
      *                                                               *
      *****************************************************************
      *
     FSDCSEGL1  IF   E           K DISK
      ** Customer Segmentation Codes
      *
     FSDCSEGL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(#0:2)
     F                                     RENAME(SDCSEGD0:CSEG#L0)
      ** Customer Segmentation Codes
      *
 
     FSD000101AUO    E             PRINTER INFDS(SPOOLU)
      ** Midas SD Customer Segmentation Group Report - Audit
 
     FSD000101P1O    E             PRINTER INFDS(SPOOL1) USROPN
      ** Midas SD Customer Segmentation Group Report
 
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   89  - End of File                                           *
      *                                                               *
      *   70  - Non-Orphan (*OFF) / Orphan (*ON) indicator            *
      *   98  - Date Format: DDMMYY (off); MMDDYY (on)                *
      * 90-99 - Used by Standard Subroutines                          *
      *                                                               *
      * U7+U8 - Database Error                                        *
      *                                                               *
      *****************************************************************
      *                                                               *
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
      *  RCFP1  - Subroutine to register the Printer File via RCF     *
      *  RCFAU  - Subroutine to register the AU Printer File via RCF  *
      *  AUDIT  - Produce Audit Report and End Program                *
      *  *PSSR  - Program Error Processing Subroutine                 *
      *                                                               *
      *                                                               *
      *****************************************************************
      *
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** File Information Data Structure for SD000101P1.
      *
     DSPOOL1           DS
     DSFILE1                  83     92
     DSFNUM1                 123    124B 0
     DOFLLN1                 188    189B 0
     DPRTLN1                 367    368B 0
      *
     DSPOOLU           DS
      ** File Information Data Structure for SD000101AU.
     DSFILEU                  83     92
     DSFNUMU                 123    124B 0
      *
      ** External data structures for Bank Details
      *
     DSDBANK         E DS                  EXTNAME(SDBANKPD)
      *
      ** First DS for Access programs, short Data Structure
      *
     DDSFDY          E DS                  EXTNAME(DSFDY)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D PSEQ            S              5A
     D SENTY           S              3A
     D ZFILE           S             10A
     D ZSERR           S              1A
     D ZSNUM           S              6  0
      *
     D X               S              1  0
      *
     DPrintSegment     PR
     D W#GRPX                        10    VALUE
     D W#LVLX                         1  0
      *
      *TITLE Main Processing
      *================================================================
      *  P R O G R A M   S T A R T                                    *
      *================================================================
      *
      ** Perform Initialisation.
      *
     C                   EXSR      INIT
      *
      ** Perform Detail Processing.
      *
      ** Write Non-Orphans Customer Segmentation Group First
      *
     C                   SETOFF                                       70
     C                   EXSR      PROCES
      *
      ** Write Orphans Customer Segmentation Group Next
      *
     C                   SETON                                        70
     C                   EXSR      PROCES
      *
     C                   EXSR      AUDIT
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
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
      *                                                               *
      *****************************************************************
      *
     C     INIT          BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    PSEQ
     C                   PARM                    SENTY
      *
      ** Prepare LDA.
      *
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'SD000101'
     C                   OUT       LDA
      *
      ** Call Access Program for Bank Details - Title, Run Date and
      ** Run Day Number.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     WRTCD             7
     C                   PARM      '*FIRST '     WOPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Handle Database Error.
      *
     C                   IF        WRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 001
     C                   EVAL      DBKEY = WOPTN
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Report Work fields.
      *
     C                   Z-ADD     0             RQDLN1            3 0
     C                   Z-ADD     0             DIFLN1            3 0
     C                   Z-ADD     *ZERO         RCOUNT
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
      *  RCFP1  - Subroutine to register the Printer File via RCF     *
      *  WP1END - Write End of Report                                 *
      *  PrintSegment - Procedure needed for recursion                *
      *                                                               *
      *****************************************************************
      *
     C     PROCES        BEGSR
      *
      ** Read first record from File.
      *
     C     *LOVAL        SETLL     SDCSEGL0
     C                   READ      SDCSEGL0
      *
     C                   DOW       NOT %EOF(SDCSEGL0)
     C                             AND #0CODE <> *BLANKS
      *
     C                   IF        #0GRP = *BLANKS
      *
     C                   IF        NOT %OPEN(SD000101P1)
      *
      ** Open printer file
      *
     C                   OPEN      SD000101P1
     C                   EXSR      RCFP1
     C                   WRITE     HEAD1
     C                   ENDIF
      *
      ** Top Level
      *
     C     #0CODE        CHAIN     SDCSEGL1
      *
     C                   IF        (%FOUND(SDCSEGL1)
     C                             AND *IN70 = *OFF) OR
     C                             (NOT %FOUND(SDCSEGL1)
     C                             AND *IN70 = *ON)
     C                   EVAL      X = 1
     C                   EXSR      REPORT
     C                   ADD       1             RCOUNT
     C                   ENDIF
      *
     C                   IF        *IN70 = *OFF
     C                   EVAL      X = 2
     C                   CALLP     PrintSegment(#0CODE:X)
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Read next record.
      *
     C                   READ      SDCSEGL0
      *
     C                   ENDDO
      *
     C                   IF        *IN70
     C                             AND RCOUNT > *ZERO
      *
      ** Write the footer
      *
     C                   EXSR      WP1END
      *
     C                   ENDIF
      *
     C                   ENDSR
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
     C     REPORT        BEGSR
      *
      ** Write out the Detail Record
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
      *  Called By: PROCES                                            *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     WP1REC        BEGSR
      *
     C                   EVAL      CSCOD1 = *BLANKS
     C                   EVAL      CSCOD2 = *BLANKS
     C                   EVAL      CSCOD3 = *BLANKS
     C                   EVAL      CSCOD4 = *BLANKS
     C                   EVAL      CSCOD5 = *BLANKS
     C                   EVAL      CSCOD6 = *BLANKS
     C                   EVAL      CSCOD7 = *BLANKS
     C                   EVAL      CSCOD8 = *BLANKS
     C                   EVAL      CSCOD9 = *BLANKS
     C
     C                   SELECT
     C     X             WHENEQ    1
     C                   EVAL      CSCOD1 = #0CODE
     C     X             WHENEQ    2
     C                   EVAL      CSCOD2 = #0CODE
     C     X             WHENEQ    3
     C                   EVAL      CSCOD3 = #0CODE
     C     X             WHENEQ    4
     C                   EVAL      CSCOD4 = #0CODE
     C     X             WHENEQ    5
     C                   EVAL      CSCOD5 = #0CODE
     C     X             WHENEQ    6
     C                   EVAL      CSCOD6 = #0CODE
     C     X             WHENEQ    7
     C                   EVAL      CSCOD7 = #0CODE
     C     X             WHENEQ    8
     C                   EVAL      CSCOD8 = #0CODE
     C     X             WHENEQ    9
     C                   EVAL      CSCOD9 = #0CODE
     C                   ENDSL
     C                   EVAL      CSNAME = #0NAME
      *
      ***  Check that sufficient lines remain for the Format. If not,
      ***  write out the Main Headings on a new page.
      *
     C                   Z-ADD     1             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     HEAD1
     C                   ENDIF
      *
      ***  Write out Detail Record.
      *
     C                   WRITE     DETAIL
      *
     C                   ENDSR
      *
      *****************************************************************
      *
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
     C     WP1END        BEGSR
      *
      ***  Check that sufficient lines remain for the Format. If not,
      ***  write out the Main Headings on a new page.
      *
     C                   Z-ADD     4             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     HEAD1
     C                   ENDIF
      *
      ***  Write out Total Format.
      *
     C                   WRITE     TRAIL1
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/AUDIT
      *****************************************************************
      *                                                               *
      *  AUDIT  - Subroutine to Output Audit report and End Program.  *
      *                                                               *
      *  Called By: Main Processing, PROCES, *PSSR                    *
      *  Calls:                                                       *
      *  RCFAU  - Subroutine to register the AU Printer File via RCF  *
      *                                                               *
      *****************************************************************
      *
     C     AUDIT         BEGSR
      *
      ** Output Report Header and File Controls.
      *
     C                   EXSR      RCFAU
     C                   WRITE     HEADAU
     C                   IF        *INU7 = *ON AND *INU8 = *ON
      *
      ** If there is a DB Error, Output the DB Error Information.
      *
     C                   WRITE     DBERROR
     C                   ELSE
     C                   IF        RCOUNT > 0
     C                   WRITE     CONTROL
     C                   ELSE
     C                   WRITE     NODTLS
     C                   ENDIF
     C                   ENDIF
      *
      ** End Program and Return.
      *
     C                   WRITE     ENDREPT
      *
     C                   ENDSR
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * RCFP1 - SR to register the P1 PRTF via RCF.                   *
      *                                                               *
      * Called by: PROCES                                             *
      *                                                               *
      * Calls: ZSFILE                                                 *
      *                                                               *
      *****************************************************************
      *
     C     RCFP1         BEGSR
      *
      ** Ensure Report Spool File recorded by RCF.
      *
     C                   EVAL      ZSNUM = SFNUM1
     C                   EVAL      ZFILE = SFILE1
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    PSEQ
     C                   PARM                    SENTY
     C                   PARM                    ZFILE
     C                   PARM                    ZSNUM
     C                   PARM      *BLANK        ZSERR
      *
      ** If error occurs during  SFILE processing, then return to the
      ** calling program.
      *
     C                   IF        ZSERR = 'Y'
     C                   EVAL      DBFILE = 'ZSFILE'
     C                   EVAL      DBASE = 002
     C                   EVAL      DBKEY = *BLANKS
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  RCFAU - SR to register the AU PRTF via RCF.                  *
      *                                                               *
      *  Called by: *INZSR                                            *
      *                                                               *
      *  Calls: ZSFILE                                                *
      *                                                               *
      *****************************************************************
      *
     C     RCFAU         BEGSR
      *
      ** Ensure Audit Spool File recorded by RCF.
      *
     C                   EVAL      ZSNUM = SFNUMU
     C                   EVAL      ZFILE = SFILEU
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    PSEQ
     C                   PARM                    SENTY
     C                   PARM                    ZFILE
     C                   PARM                    ZSNUM
     C                   PARM      *BLANK        ZSERR
      *
      ** If error occurs during ZSFILE processing, then return to the
      ** calling program.
      *
     C                   IF        ZSERR = 'Y'
     C                   EVAL      DBFILE = 'ZSFILE'
     C                   EVAL      DBASE = 003
     C                   EVAL      DBKEY = *BLANKS
     C                   EXSR      *PSSR
     C                   ENDIF
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
      ** Check to see that *PSSR has not already been called.
      *
     C                   IF        WRUN = *BLANK
     C                   MOVE      'Y'           WRUN              1
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   EXSR      AUDIT
     C                   DUMP
     C                   ENDIF
      *
     C                   RETURN
      *
     C                   ENDSR
      *
     P PrintSegment    B
     D PrintSegment    PI
     D   W#GRPX1                           LIKE(CSGRP) VALUE
     D   W#LVLX1                      1  0
      *
     C     SavedKey      KLIST
     C                   KFLD                    W#GRP1           10
     C                   KFLD                    W#CSCODE1        10
 
     C     W#GRPX1       CHAIN     SDCSEGL1
     C                   IF        %FOUND(SDCSEGL1)
     C                   DOW       NOT %EOF(SDCSEGL1)
     C                             AND CSCODE <> *BLANKS
      *
     C                   EVAL      CSCOD1 = *BLANKS
     C                   EVAL      CSCOD2 = *BLANKS
     C                   EVAL      CSCOD3 = *BLANKS
     C                   EVAL      CSCOD4 = *BLANKS
     C                   EVAL      CSCOD5 = *BLANKS
     C                   EVAL      CSCOD6 = *BLANKS
     C                   EVAL      CSCOD7 = *BLANKS
     C                   EVAL      CSCOD8 = *BLANKS
     C                   EVAL      CSCOD9 = *BLANKS
     C
     C                   SELECT
     C     W#LVLX1       WHENEQ    1
     C                   EVAL      CSCOD1 = CSCODE
     C     W#LVLX1       WHENEQ    2
     C                   EVAL      CSCOD2 = CSCODE
     C     W#LVLX1       WHENEQ    3
     C                   EVAL      CSCOD3 = CSCODE
     C     W#LVLX1       WHENEQ    4
     C                   EVAL      CSCOD4 = CSCODE
     C     W#LVLX1       WHENEQ    5
     C                   EVAL      CSCOD5 = CSCODE
     C     W#LVLX1       WHENEQ    6
     C                   EVAL      CSCOD6 = CSCODE
     C     W#LVLX1       WHENEQ    7
     C                   EVAL      CSCOD7 = CSCODE
     C     W#LVLX1       WHENEQ    8
     C                   EVAL      CSCOD8 = CSCODE
     C     W#LVLX1       WHENEQ    9
     C                   EVAL      CSCOD9 = CSCODE
     C                   ENDSL
      *
      ***  Check that sufficient lines remain for the Format. If not,
      ***  write out the Main Headings on a new page.
      *
     C                   Z-ADD     1             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     HEAD1
     C                   ENDIF
      *
      ***  Write out Detail Record.
      *
     C                   WRITE     DETAIL
     C                   ADD       1             RCOUNT
     C     W#LVLX1       ADD       1             Z                 1 0
      *
     C                   MOVE      CSGRP         W#GRP1
     C                   MOVE      CSCODE        W#CSCODE1
      *
     C                   CALLP     PrintSegment(CSCODE:Z)
      *
     C     SavedKey      SETGT     SDCSEGL1
     C     W#GRPX1       READE     SDCSEGL1
      *
     C                   ENDDO
     C                   ENDIF
     C                   RETURN
     P                 E
