     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas TI Journal entry held batches report')
      *****************************************************************
      *                                                               *
      *  Midas - Trade Inovation (TI) Module                          *
      *                                                               *
      *  TI0320 - TI Journal Entry Held Batches Report                *
      *                                                               *
      *  Function: This program either:-                              *
      *  Lists one (held) batch when called from TI JE Generation Pgm *
      *  OR lists all held batches created by TI JE Interface         *
      *                                                               *
      *  Phase(s): I/C upon Request                                   *
      *                                                               *
      *  Called By: TIC0320                                           *
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
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CEU029             Date 04Sep98               *
      *                 CTI001  *CREATE    Date 16Jul97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CEU029 - EMU Midas/Trade Innovation Interface Enhancements:  *
      *           include Original Ccy and Amount.                    *
      *  CTI001 - Midas / Trade Innovation Interface Phase 1          *
      *                                                               *
      *****************************************************************
      *
      * GL Journal Entry Header - By Branch/Batch No.
     FGLJENHL2  IF   E           K DISK    INFSR(*PSSR)
      *
      * GL Journal Entry Posting - By Branch/Batch No.
     FGLJENPL3  IF   E           K DISK    INFSR(*PSSR)
      *
     FTI0320AU  O    E             PRINTER
     F                                     INFDS(SPOOLU)
     FTI0320P1  O    E             PRINTER USROPN
     F                                     INFDS(SPOOL1)
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   01  - EMU Midas/TI Interface Enhancements are switched on.  *         CEU029
      *   37  - Multibranching ON                                     *
      *   89  - End of File                                           *
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
      *  ALLBAT - List All                                            *
      *  HEADER - Determine Header Details and Write Header           *
      *                                                               *
      *  FWRITE - Format and Write a Detail Record to the Report      *
      *  WRITEE - Write End of Report                                 *
      *                                                               *
      *  AUDIT  - Produce Audit Report and End Program                *
      *  *PSSR  - Program Error processing Subroutine                 *
      *  RCFP1  - RCF processing for P1 Report                        *
      *  RCFAU  - RCF processing for Audit Report                     *
      *                                                               *
      *****************************************************************
     D/EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      ** Array containing Copyright statement
      *
      /SPACE 3
      *
     D DBERR         E DS           256    EXTNAME(LDA)
      ** Local data area for database error details
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      ** Data Area giving Installation Control Details
      *
     D PSDS           SDS
      ** Program Status Data Structure
      *
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
     D SPOOL1          DS
      ***  File Information Data Structure for TI0320P1.
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
      *
     D SPOOLU          DS
      ***  File Information Data Structure for TI0320AU.
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
      *
      ***  Dummy Data Structures used by Access Programs.
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** External DS for Access Objects
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ***  External data structures for Bank Details
      *
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ***  External data structures for Branch Details
      *
     D SDDEPT        E DS                  EXTNAME(SDDEPTPD)
      ***  External data structures for Department Codes
      *
     D TIC             C                   CONST('Trade Innovation')
      *
     C/TITLE Main Processing
      *================================================================
      *  P R O G R A M   S T A R T                                    *
      *================================================================
      *
      **  Perform Initialisation.
      *
     C                   EXSR      INIT
      *
      **  List All/One Held Batches.
      *
     C                   EXSR      ALLBAT
      *
      ***  Output Audit Report and End Program.
      *
     C                   EXSR      AUDIT
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
      *  RCFAU  - RCF Processing for Audit Report                     *
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
     C                   PARM                    PSEQ              5
      *
      ***  Initialise LDA field.
      *
     C                   MOVEL     'TI0320'      DBPGM
      *
      ***  Call Access Program for Bank Details - Title, Run Date and
      ***  Run Day Number.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     WRTCD             7
     C                   PARM      '*FIRST '     WOPTN             7
     C     SDBANK        PARM      SDBANK        DSSDY
      *
      ***  Handle Database Error.
      *
     C     WRTCD         IFNE      *BLANKS
     C                   MOVE      'SDBANKPD'    DBFILE                         ***************
     C                   Z-ADD     1             DBASE                          * DB ERROR 01 *
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
     C     *DTAARA       DEFINE    LDA           @LDA            256
     C                   IN        RUNDAT
      *
     C     AGMBIN        IFEQ      'M'
     C                   SETON                                        37
     C                   ENDIF
      *                                                                         CEU029
      ** Access switchable features file for EMU Midas/TI Enhancement.          CEU029
      *                                                                         CEU029
     C                   CALL      'AOSARDR0'                                   CEU029
     C                   PARM      '       '     WRTCD                          CEU029
     C                   PARM      '*VERIFY'     WOPTN                          CEU029
     C                   PARM      'CEU029'      WSARD             6            CEU029
      *                                                                         CEU029
      ** Database Error                                                         CEU029
     C     WRTCD         IFNE      *BLANKS                                      CEU029
     C     WRTCD         ANDNE     '*NRF   '                                    CEU029
     C                   Z-ADD     4             DBASE                          CEU029
     C                   MOVEL     'SCSARDPD'    DBFILE                         CEU029
     C                   EXSR      *PSSR                                        CEU029
     C                   ENDIF                                                  CEU029
     C*                                                                         CEU029
     C     WRTCD         IFEQ      *BLANKS                                      CEU029
     C                   MOVE      *ON           *IN01                          CEU029
     C                   ENDIF                                                  CEU029
      *
      ***  Report Work fields.
      *
     C                   Z-ADD     0             DIFLN1            3 0                   C
      *
      ***  Key for GLJENPL3.
      *
     C     JEN3KY        KLIST
     C                   KFLD                    BRBCDA
     C                   KFLD                    BRBTNB
     C                   KFLD                    ITEMNO            3 0
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/ALLBAT
      *****************************************************************
      *                                                               *
      *  ALLBAT - Subroutine to do the Detail Processing.             *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls:                                                       *
      *  HEADER - Determine Header Details and Write Header           *
      *  WRITEE - Write End of Report                                 *
      *                                                               *
      *****************************************************************
      *
     C     ALLBAT        BEGSR
      *
      ** Only Open File if 'TI' and Held Batch
      *
     C     *IN89         DOUEQ     *ON
     C     BRBDES        OREQ      TIC
     C     BRBTSF        ANDEQ     'H'
      *
     C                   READ      GLJENHL2                               89
      *
     C     BRBDES        IFEQ      TIC
     C     BRBTSF        ANDEQ     'H'
     C                   MOVEL     'Y'           NEWBAT            1
     C                   MOVEL     BRBTNB        W#BTNB            3
     C                   OPEN      TI0320P1
     C                   EXSR      RCFP1
     C                   Z-ADD     1             BCOUNT
     C                   EXSR      HEADER
     C                   ENDIF
      *
     C                   ENDDO
      *
     C     *IN89         DOWEQ     *OFF
      *
     C                   READ      GLJENHL2                               89
      *
     C     *IN89         IFEQ      *OFF
     C     BRBDES        ANDEQ     TIC
     C     BRBTSF        ANDEQ     'H'
      *
      ** New Page (due to change of Batch).
     C     BRBTNB        IFNE      W#BTNB
     C                   MOVEL     'Y'           NEWBAT
     C                   MOVEL     BRBTNB        W#BTNB
     C                   ADD       1             BCOUNT
     C                   EXSR      HEADER
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     *IN89         IFEQ      *ON
     C     BCOUNT        ANDGT     0
     C                   EXSR      WRITEE
     C                   CLOSE     TI0320P1
     C                   ENDIF
      *
     C                   ENDDO
      *
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/HEADER
      *****************************************************************
      *                                                               *
      *  HEADER - Determine Header Details and Write Header           *
      *                                                               *
      *  Called By: ALLBAT                                            *
      *  Calls:                                                       *
      *  FWRITE - Format and Write a Detail Record to the Report      *
      *                                                               *
      *****************************************************************
      *
     C     HEADER        BEGSR
      *
      ***  Access Branch Details
     C     NEWBAT        IFEQ      'Y'
     C**********         CALL      'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      '*DBERR '     WRTCD
     C                   PARM      '*KEY   '     WOPTN
     C                   PARM      BRBCDA        WBRCD             3
     C     SDBRCH        PARM      SDBRCH        DSSDY
      *
     C     WRTCD         IFNE      *BLANKS
     C                   MOVE      'SDBRCHPD'    DBFILE                         ***************
     C                   Z-ADD     2             DBASE                          * DB ERROR 02 *
     C                   EXSR      *PSSR                                        ***************
     C                   ENDIF
      *
      ***  Access Department Details
      *
     C                   CALL      'AODEPTR0'
     C                   PARM      '*DBERR '     WRTCD
     C                   PARM      '*KEY   '     WOPTN
     C                   PARM      BRDPCD        WBRCD
     C     SDDEPT        PARM      SDDEPT        DSSDY
      *
     C     WRTCD         IFNE      *BLANKS
     C                   MOVE      'SDDEPTPD'    DBFILE                         ***************
     C                   Z-ADD     3             DBASE                          * DB ERROR 03 *
     C                   EXSR      *PSSR                                        ***************
     C                   ENDIF
     C                   ENDIF
      *
     C                   EXSR      POSTDT
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/DETAIL
      *****************************************************************
      *                                                               *
      *  DETAIL - Determine Posting Details                           *
      *                                                               *
      *  Called By: HEADER                                            *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     POSTDT        BEGSR
      *
      * Get GL Journal Entry Posting
      *
     C     JEN3KY        SETLL     GLJENPL3
     C                   READ      GLJENPL3                               88
      *
     C     *IN88         DOWEQ     *OFF
     C                   EXSR      FWRITE
     C                   ADD       1             ICOUNT
     C                   READ      GLJENPL3                               88
      * If Branch Changes, to header processing
     C     BRBTNB        IFNE      BTBTNB
     C                   MOVE      *ON           *IN88
     C                   ENDIF
     C                   ENDDO
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/FWRITE
      *****************************************************************
      *                                                               *
      *  FWRITE - Subroutine to Write a Detail record to the Report.  *
      *                                                               *
      *  Called By: ALLBAT                                            *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     FWRITE        BEGSR                                                  *** FWRITE ***
      *
      ***  Convert Midas Day No. Value Date to DDMMMYY
      *
     C                   CALL      'ZDATE2'
     C                   PARM      BTVLDT        WQ0001            5 0
     C                   PARM                    ZDATFM            1
     C                   PARM                    ZDATE             6 0
     C     VALDAT        PARM                    WQ0004            7
      *
      ***  Check that sufficient lines remain for the Format. If not,
      ***  write out the Main Headings on a new page.
      *
     C                   Z-ADD     4             RQDLN1            3 0
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C     NEWBAT        OREQ      'Y'
     C                   WRITE     HEADP1
     C                   MOVE      'N'           NEWBAT
     C                   ENDIF
      *
      ***  Write out Detail Record.
      *
     C                   WRITE     DETAIL
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/WRITEE
      *****************************************************************
      *                                                               *
      *  WRITEE - Subroutine to Write End of Report.                  *
      *                                                               *
      *  Called By: ALLBAT                                            *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     WRITEE        BEGSR                                                  *** WRITEE ***
      *
      ***  Check that sufficient lines remain for the Format. If not,
      ***  write out the Main Headings on a new page.
      *
     C                   Z-ADD     4             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     HEADP1
     C                   ENDIF
      *
      ***  Write out Total Format.
      *
     C                   WRITE     TRAILP1
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/AUDIT
      *****************************************************************
      *                                                               *
      *  AUDIT  - Subroutine to Output Audit report and End Program.  *
      *                                                               *
      *  Called By: Main Processing, ALLBAT, *PSSR                    *
      *  Calls: None.                                                 *
      *                                                               *
      *****************************************************************
      *
     C     AUDIT         BEGSR                                                  *** AUDIT  ***
      *
      *
      ***  RCF Processing for Audit File.
     C                   EXSR      RCFAU
      *
      ***  Output Report Header and File Controls.
      *
     C                   WRITE     HEADAU
     C                   WRITE     CONTROL
      *
      ***  If there is a DB Error, Output the DB Error Information.
      *
     C     *INU7         IFEQ      *ON
     C                   WRITE     DBERROR
     C                   ELSE
      *
      ***  Or, if no records read, Output "No Details" message.
      *
     C     BCOUNT        IFEQ      0
     C                   WRITE     NODTLS
     C                   ENDIF
     C                   ENDIF
      *
      ***  End Program and Return.
      *
     C                   SETON                                        LR
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
      ***  Check to see that *PSSR has not already been called.
      *
     C     WRUN          IFEQ      *BLANK
     C                   MOVE      'Y'           WRUN              1
      *
     C     *LOCK         IN        @LDA
     C                   MOVEL     DBERR         @LDA
     C                   OUT       @LDA
      *
     C                   SETON                                        U7U8LR
     C                   DUMP
     C                   EXSR      AUDIT
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
      *
     C                   CALL      'ZSFILE'
     C                   PARM      PSEQ          SEQ               5
     C                   PARM                    SENTY             3
     C                   PARM                    SFILE1
     C                   PARM                    ZSNUM
     C                   PARM                    ZSERR             1
      *
      ***  If Error occurs during ZSFILE Processing, then return to the
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
      /TITLE SR/RCFAU
      *****************************************************************
      *                                                               *
      *  RCFAU  - Subroutine to register the AU Printer File via RCF. *
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
      ***  If Error occurs during ZSFILE Processing, then return to the
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
