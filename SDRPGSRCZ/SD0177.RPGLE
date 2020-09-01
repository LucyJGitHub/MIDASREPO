     H DEBUG
      *****************************************************************
/*XBIA*: OVRDBF FILE(SDMDFBSR) TOFILE(SDMDFHL6)                     : *
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Valid Spot rates received from MDF today')
      *****************************************************************
      *                                                               *
      *  Midas - SD Module                                            *
      *                                                               *
      *  SD0177 - SD Valid Base Rates Received from MDF today         *
      *                                                               *
      *  Function:  This program Reports data received by MDF which   *
      *             has successfully updated the Midas database       *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *                 196570  *CREATE    Date 12Nov01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  196570 - Market Data Feeds: enhanced reporting               *
      *                                                               *
      *****************************************************************
     FSDMDFBSR  UF   E           K DISK    INFSR(*PSSR)
      ** MDF History File For Base Rates Exceeding Tolerance
      *
     FSD0177AU  O    E             PRINTER
     F                                     INFDS(SPOOLU)
      ** Base Rates Exceeding Rate Tolerance Report - Audit
      *
     FSD0177P1  O    E             PRINTER USROPN
     F                                     INFDS(SPOOL1)
      ** Base Rates Exceeding Rate Tolerance Report
      *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   80  - End of File                                           *
      *   83  - Error on Update                                       *
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
      *  SRINIT - Program Initialisation                              *
      *  SRPROC - Detail Processing                                   *
      *  SRSAVR - Subroutine to save rate history detail for each     *
      *           currency                                            *
      *  SRREPT - Process Report Lines                                *
      *  SRFMTR - Subroutine to format report fields                  *
      *                                                               *
      *  SRP1RC - Format and Write a Detail Record to the Report      *
      *  SRREND - Write End of Report                                 *
      *                                                               *
      *  SRAUDT - Produce Audit Report and End Program                *
      *  *PSSR  - Program Error Processing Subroutine                 *
      *  RCFP1  - RCF Processing for P1 Report                        *
      *  RCFAU  - RCF Processing for Audit Report                     *
      *                                                               *
      *  AOBANKR0  - Access Object for Bank Details                   *
      *  ZSFILE    - Sets up spool file                               *
      *                                                               *
      *****************************************************************
     D/EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** Array containing Copyright statement
      *
     D @NB             S             11  7 DIM(21)
     D @NL             S             11  7 DIM(21)
      *
      ** Array for old/new borrow and lending rates
      *
      /SPACE 3
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
     D SPOOL1          DS
      **  File Information Data Structure for SD0177P1.
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
      *
     D SPOOLU          DS
      ** File Information Data Structure for SD0177AU.
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
      *
     D WTMEST          DS
      ** Data structure for timestamp (printed)
     D  WCENT                  1      2
     D  WYEAR                  3      4
     D  WSLSH1                 5      5
     D  WMONTH                 6      7
     D  WSLSH2                 8      8
     D  WDAY                   9     10
     D  WHOUR                 12     13
     D  WCOL1                 14     14
     D  WMIN                  15     16
     D  WCOL2                 17     17
     D  WSECS                 18     19
      *
     D WTMEDS          DS
      ** Data structure for timestamp
     D  WCNT                   1      2
     D  WYR                    3      4
     D  WMNTH                  5      6
     D  WDY                    7      8
     D  WHR                    9     10
     D  WMN                   11     12
     D  WSC                   13     14
      *
     D AFTRDS        E DS                  EXTNAME(SDBSRTPD)
     D                                     PREFIX(A_)
      ** After image details of the interest rates
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Dummy Data Structures used by Access Programs.
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      **   External data structures for Bank Details
      *
     D WBNBRT          S             12
     C/TITLE Main Processing
      *================================================================
      *  P R O G R A M   S T A R T                                    *
      *================================================================
      *
      ** Perform Initialisation.
      *
     C                   EXSR      SRINIT
      *
      ** Perform Detail Processing.
      *
     C                   EXSR      SRPROC
      *
      ** Output Audit Report and End Program.
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
      *                                                               *
      *  Calls:                                                       *
      *  AOBANKR0 Access Program                                      *
      *                                                               *
      *****************************************************************
      *
     C     SRINIT        BEGSR                                                  *** SRINIT ***
      *
      ** Receive Parameter List.
      *
     C     *ENTRY        PLIST
     C                   PARM                    RSEQ              5
     C                   PARM                    RPARM           100
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** Setup LDA
      *
     C     *DTAARA       DEFINE                  LDA
      *
      ** Initialise LDA field.
      *
     C                   MOVEL     'SD0177'      DBPGM
      *
      *** Call Access Program for Bank Details - Title, Run Date and
      *** Run Day Number.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     WRTCD             7
     C                   PARM      '*FIRST '     WOPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Handle Database Error.
      *
     C     WRTCD         IFNE      *BLANKS
     C                   MOVE      'SDBANKPD'    DBFILE                         ***************
     C                   Z-ADD     001           DBASE                          * DB ERROR 01 *
     C                   MOVEL     WOPTN         DBKEY                          ***************
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
      ** Key lists
      *
     C     KYMDF         KLIST
     C                   KFLD                    BJRDNB
      *
      ** Report Work fields.
      *
     C                   Z-ADD     0             RQDLN1            3 0
     C                   Z-ADD     0             DIFLN1            3 0
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
      *                                                               *
      *  Calls:                                                       *
      *  SRREPT - Process Report Lines                                *
      *  SRREND - Write End of Report                                 *
      *  RCFP1  - Subroutine to register P1 printer file via RCF.     *
      *                                                               *
      *****************************************************************
      *
     C     SRPROC        BEGSR                                                  *** SRPROC ***
      *
      ** Read first record from File.
      *
     C                   READ      SDMDFBSR                               80
      *
      ** If End of Records, (*IN80), Perform: Audit Reporting (No
      ** Records).
      *
     C     *IN80         IFEQ      *ON
     C                   EXSR      SRAUDT
     C                   ELSE
     C                   EXSR      RCFP1
     C                   ENDIF
      *
      ** Do until end of file
      *
     C     *IN80         DOUEQ     *ON
     C     RHPRCD        IFEQ      BJRDNB
      *
      ** Count records read.
      *
     C                   ADD       1             RCOUNT            5 0
      *
      ** Process Report Lines.
      *
     C                   EXSR      SRREPT
     C                   ENDIF
      *
      ** Read next record.
      *
     C                   READ      SDMDFBSR                               80
     C                   ENDDO
      *
      ** Write final records and Totals to Report.
      *
     C                   EXSR      SRREND
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SRREPT
      *****************************************************************
      *                                                               *
      *  SRREPT - Process Report Lines.                               *
      *                                                               *
      *  Called By: SRPROC                                            *
      *  Calls:                                                       *
      *  SRFMTR - Format fields for output                            *
      *  SRP1RC - Write Detail Record to the Report                   *
      *                                                               *
      *****************************************************************
      *
     C     SRREPT        BEGSR                                                  *** SRREPT ***
      *
      ** Format report fields
      *
     C                   EXSR      SRFMTR
      *
      ** Write out the record.
      *
     C                   EXSR      SRP1RC
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SRFMTR
      *****************************************************************
      *                                                               *
      *  SRFMTR - Subroutine to format report fields.                 *
      *                                                               *
      *  Called By: SRFMTR subroutine                                 *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRFMTR        BEGSR                                                  *** SRFMTR ***
 
      * Move Before and After Image into Data Structure
 
     C                   MOVEL     RHAIMG        AFTRDS
 
      * Base Rate Id and Currency
 
     C                   MOVEL     RHTREF        WTREF
     C                   MOVEL     A_BACYCD      WCYCD
     C                   MOVEL     A_BABSRC      WBSRC
 
      * Base Rate
 
     C                   MOVE      A_BANBRT      ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        WANBRT
 
      * Data Feed Request Id
 
     C                   MOVEL     RHDFRI        WDFRI
      * Timestamp
 
     C                   MOVEL     '/'           WSLSH1
     C                   MOVEL     '/'           WSLSH2
     C                   MOVEL     ':'           WCOL1
     C                   MOVEL     ':'           WCOL2
     C                   MOVEL     RHDFTS        WTMEDS
     C                   MOVEL     WCNT          WCENT
     C                   MOVEL     WYR           WYEAR
     C                   MOVEL     WMNTH         WMONTH
     C                   MOVEL     WDY           WDAY
     C                   MOVEL     WHR           WHOUR
     C                   MOVEL     WMN           WMIN
     C                   MOVEL     WSC           WSECS
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZEDIT - Edit an unsigned field                                *
      *                                                               *
      *****************************************************************
     C     ZEDIT         BEGSR
 
     C                   EVAL      ZADEC = 7
 
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
 
     C                   ENDSR
      *****************************************************************
      /TITLE SR/SRP1RC
      *****************************************************************
      *                                                               *
      *  SRP1RC - Subroutine to Write a Detail record to the Report.  *
      *                                                               *
      *  Called By: SRREPT subroutine                                 *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRP1RC        BEGSR                                                  *** SRP1RC ***
      *
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
      *
     C                   Z-ADD     6             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     HEADP1
     C                   WRITE     HEADP2
     C                   ELSE
     C                   WRITE     HEADP2
     C                   ENDIF
      *
      ** Write out Detail Record.
      *
     C                   WRITE     DETAIL
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SRREND
      *****************************************************************
      *                                                               *
      *  SRREND - Subroutine to Write End of Report.                  *
      *                                                               *
      *  Called By: SRPROC subroutine                                 *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRREND        BEGSR                                                  *** SRREND ***
      *
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
      *
     C                   Z-ADD     4             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     HEADP1
     C                   ENDIF
      *
      ** Write out Total Format.
      *
     C                   WRITE     TRAILP1
     C                   CLOSE     SD0177P1
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
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRAUDT        BEGSR                                                  *** SRAUDT ***
      *
      ** Output Report Header and File Controls.
      *
     C                   WRITE     HEADAU
     C                   WRITE     CONTROL
      *
      ** If there is a DB Error, Output the DB Error Information.
      *
     C     *INU7         IFEQ      *ON
     C                   WRITE     DBERROR
     C                   ELSE
      *
      ** Or, if no records read, Output "No Details" message.
      *
     C     RCOUNT        IFEQ      0
     C                   WRITE     NODTLS
     C                   ENDIF
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
     C     *PSSR         BEGSR                                                  ** *PSSR **
      *
      ** Check to see that *PSSR has not already been called.
      *
     C     WRUN          IFEQ      *BLANK
     C                   MOVE      'Y'           WRUN              1
      *
     C                   SETON                                        U7U8LR
     C                   DUMP
     C                   EXSR      SRAUDT
     C                   ENDIF
      *
      ** If *PSSR already run, then just end the program here.
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
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
      ** Ensure Report Spool File recorded by RCF.
      *
     C                   OPEN      SD0177P1
     C                   Z-ADD     SFNUM1        ZSNUM             6 0
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    SEQ               5
     C                   PARM      *BLANK        SENTY             3
     C                   PARM                    SFILE1
     C                   PARM                    ZSNUM
     C                   PARM                    ZSERR             1
      *
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
      *
     C     ZSERR         IFEQ      'Y'
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/RCFAU
      *****************************************************************
      *                                                               *
      *  RCFAU  - Subroutine to register the AU Printer File via RCF. *
      *                                                               *
      *****************************************************************
      *
     C     RCFAU         BEGSR                                                   *** RCFAU  ***
      *
      ** Ensure Audit Spool File recorded by RCF.
      *
     C                   Z-ADD     SFNUMU        ZSNUMU            6 0
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    SEQ
     C                   PARM      *BLANKS       SENTY
     C                   PARM                    SFILEU
     C                   PARM                    ZSNUMU
     C                   PARM      *BLANK        ZSERR
      *
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
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
(c) Finastra International Limited 2001
