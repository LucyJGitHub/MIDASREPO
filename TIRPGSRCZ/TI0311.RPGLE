     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas TI Unprocessed postings report')
      *****************************************************************
      *                                                               *
      *  Midas - Trade Inovation (TI) Module                          *
      *                                                               *
      *  TI0311 - TI Unprocessed Postings                             *
      *                                                               *
      *  Program Function: Lists TI Postings rejected by TI0310       *
      *                                                               *
      *  Phase(s): I/C by Menu Request                                *
      *                                                               *
      *  Called By: SDC541P                                           *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 212558             Date 30Jan03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CEU029             Date 04SEP98               *
      *                 CTI001   *CREATE   Date 16JUL97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  212558 - Recompile over changed file TIPOSTL5.               *
      *  CEU029 - EMU Midas/Trade Innovation Interface Enhancements:  *
      *           include Original Ccy and Amount.                    *
      *  CTI001 - Midas / Trade Innovation Interface Phase 1          *
      *                                                               *
      *****************************************************************
      *
      * TI Postings in Error
     FTIPOSTL5  IF   E             DISK    INFSR(*PSSR)
      *
     FTI0311AU  O    E             PRINTER INFDS(SPOOLU)
      *
     FTI0311P1  O    E             PRINTER INFDS(SPOOL1)
     F                                     USROPN
      *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   01  - EMU Midas/TI Interface Enhancements are switched on.  *         CEU029
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
     D PSDS           SDS
      ** Program Status Data Structure
      *
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
     D SPOOL1          DS
      ***  File Information Data Structure for TI0311P1.
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
      *
     D SPOOLU          DS
      ***  File Information Data Structure for TI0311AU.
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
      *
      ***  Data Structure to format TI Value Date
     D DSDATE          DS
     D  DSYEAR                 1      4  0
     D  DSMNTH                 5      6  0
     D  DSDAYS                 7      8  0
      *
     C/TITLE Main Processing
      *================================================================
      *  P R O G R A M   S T A R T                                    *
      *================================================================
      *
     C                   READ      TIPOSTL5                               89
      *
     C     *IN89         IFEQ      *OFF
      *
     C                   OPEN      TI0311P1
     C                   EXSR      RCFP1
      *
     C     *IN89         DOWEQ     *OFF
      *
     C                   ADD       1             PCOUNT
      *
      ** Check that sufficient lines remain for the Format.
     C     OFLLN1        SUB       PRTLN1        DIFLN1            3 0
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     HEADP1
     C                   ENDIF
      *
      ** Format Value Date
     C                   Z-ADD     0             DSYEAR
     C                   MOVE      TIVALD        DSDATE
     C                   ADD       1900          DSYEAR
      *
     C                   WRITE     DETAIL
      *
     C                   READ      TIPOSTL5                               89
      *
     C                   ENDDO
      *
     C                   WRITE     TRAILP1
     C                   CLOSE     TI0311P1
      *
     C                   ENDIF
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
      *  Called By: Automatically                                     *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    PRTNCD            7
     C                   PARM                    PMODE             1
     C                   PARM                    PSEQ              5
     C                   PARM                    PLEVEL            1
     C                   PARM                    PENT              3
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
      ***  Initialise LDA field.
      *
     C                   MOVEL     'TI0311P'     DBPGM
      *
     C     *DTAARA       DEFINE    LDA           @LDA            256
      *
      ***  Initialise required no. of lines for detail output
     C                   Z-ADD     4             RQDLN1            3 0
      *                                                                         CEU029
      ** Access switchable features file for EMU Midas/TI Enhancement.          CEU029
      *                                                                         CEU029
     C                   CALL      'AOSARDR0'                                   CEU029
     C                   PARM      '       '     WRTCD             7            CEU029
     C                   PARM      '*VERIFY'     WOPTN             7            CEU029
     C                   PARM      'CEU029'      WSARD             6            CEU029
      *                                                                         CEU029
      ** Database Error                                                         CEU029
     C     WRTCD         IFNE      *BLANKS                                      CEU029
     C     WRTCD         ANDNE     '*NRF   '                                    CEU029
     C                   Z-ADD     1             DBASE                          CEU029
     C                   MOVEL     'SCSARDPD'    DBFILE                         CEU029
     C                   MOVEL     'TI0311  '    DBPGM                          CEU029
     C                   EXSR      *PSSR                                        CEU029
     C                   ENDIF                                                  CEU029
     C*                                                                         CEU029
     C     WRTCD         IFEQ      *BLANKS                                      CEU029
     C                   MOVE      *ON           *IN01                          CEU029
     C                   ENDIF                                                  CEU029
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/AUDIT
      *****************************************************************
      *                                                               *
      *  AUDIT  - Subroutine to Output Audit report and End Program.  *
      *                                                               *
      *  Called By: Main Processing, *PSSR                            *
      *  Calls: None.                                                 *
      *                                                               *
      *****************************************************************
      *
     C     AUDIT         BEGSR
      *
      ***  RCF Processing for Audit File.
     C                   EXSR      RCFAU
      *
      ***  Output Report Header and File Controls.
     C                   WRITE     HEADAU
     C                   WRITE     CONTROL
      *
      ***  If there is a DB Error, Output the DB Error Information.
     C     *INU7         IFEQ      *ON
     C                   WRITE     DBERROR
     C                   ENDIF
      *
      ***  If there are no details
     C     PCOUNT        IFEQ      0
     C                   WRITE     NODTLS
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
     C     *PSSR         BEGSR
      *
      ***  Check to see that *PSSR has not already been called.
      *
     C     WRUN          IFEQ      *BLANK
     C                   MOVE      'Y'           WRUN              1
      *
     C     *LOCK         IN        @LDA
     C                   MOVEL     DBERR         @LDA
     C                   OUT       @LDA
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
     C     RCFP1         BEGSR
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
     C     RCFAU         BEGSR
      *
      ***  Ensure Audit Spool File recorded by RCF.
      *
     C                   Z-ADD     SFNUMU        ZSNUMU            6 0
      *
     C                   CALL      'ZSFILE'
     C                   PARM      *BLANKS       SEQ
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
(c) Finastra International Limited 2001
