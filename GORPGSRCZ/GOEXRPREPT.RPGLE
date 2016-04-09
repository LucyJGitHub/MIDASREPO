     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Generate Exception Report')
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  GOEXRPREPT Midas GO Generate Exception Report                *
      *                                                               *
      *  Function:  This module produces a report listing all the     *
      *             Exceptions that were captured during today's      *
      *             input cycle, for the branches in this zone.       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Last Amend No. CSD086             Date 18Mar10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 BUG7841            Date 04Aug05               *
      *                 BG4543             Date 13Oct04               *
      *                 CGP008 *CREATE     Date 15Sep04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD086 - Overridable Errors                                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG7841- Fixed truncation of exception message.              *
      *  BG4543 - Pass correct parameters for ZSFILE.                 *
      *  CGP008 - Exception Reporting.                                *
      *                                                               *
      *                                                               *
      *****************************************************************
      ** Exception Records - Extract File
     FGOEXKSPD  IF   E           K DISK    RENAME(GOEXKSPD:GOEXKSPF)
      *
      ** Report listing Today's Exceptions in this zone:
     FGOEXRP1   O    E             PRINTER USROPN
     F                                     INFSR(*PSSR)
     F                                     INFDS(SPOOL1)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  FUNCTION OF INDICATORS                                       *
      *                                                               *
      *   10 -                                                        *
      *   11 -                                                        *
      *                                                               *
      * U7+U8 - Database Error                                        *
      *                                                               *
      *****************************************************************
      /SPACE 3
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  *INZSR   -  Initialisation subroutine                        *
      *  SRSELECT -  Select Exception records for reporting           *
      *  REPORT   -  Generate GOEXRP1 report.                         *
      *  SrRcfP1  -  Register the P1 Printer File via RCF.            *
      *  NODET    -  No Exception Details to be reported today.       *
      *  *PSSR    -  Program Error Processing Subroutine.             *
      *                                                               *
      *****************************************************************
      /EJECT
      *
      ** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** Subroutine Stack
     D STK             S             10    DIM(99)
      *
      ** Parameters for ZSFILE
     D PSeq            S              5
     D SEnty           S              3
     D ZSnum           S              6  0
     D*ZSnumU******    S              6  0                                                    BG4543
     D ZSerr           S              1
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, short data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for access programs, long data structure
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Bank details
      *
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
      ** File Information Data Structure for GOEXRP1
     D SPOOL1          DS
     D  PSFile1               83     92
     D  PSFNum1              123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
      *
     D                 DS
      ** Format amount returned by standard subroutine
     D  ZOUT22                 1     22
     D  ZOUT21                 1     21
     D  ZOUT20                 1     20
     D  ZNEG                  21     21
      /SPACE 3
      *
      *================================================================
      *  P R O G R A M   S T A R T                                    *
      *================================================================
      *
      ** Initialisation subroutine *INZSR runs automatically.
      *
      ** Select Exception Detail Records & print on report:
      *
     C                   EXSR      SRSELECT
      *
      ** Terminate program
      *
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *
      /EJECT
      *****************************************************************
      *  *INZSR - Program Initialisation                              *
      *  Called by: Main routine                                      *
      *  Calls    : AOBANKR0                                          *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C***********        PARM                    UPDATE            1                         BG4543
     C                   PARM                    PSeq              5                         BG4543
     C                   PARM                    RLev              1                         BG4543
     C                   PARM                    SEnty             3                         BG4543
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** Set up 'No Details' flag:
     C                   MOVEL     'N'           DET               1
      *
      ** Initialise Saved Branch field
     C                   MOVEL     *BLANKS       SVBRCA            3
      *
      ** Define data areas
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C     *DTAARA       DEFINE                  LDA
     C                   IN        RUNDAT
     C                   MOVEL     *BLANK        I#ERMS           50
      *
      ** Get Zone & Current Rundate (O#ZONE & O#RDNB)
      *
      /COPY GOCPYSRC,GOGETZONE
      *
      ** Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   Z-ADD     001           DBASE
     C                   MOVEL     *BLANKS       DBKEY
     C                   MOVEL     'BANK'        DBKEY
     C                   MOVEL     'GOEXRPREPT'  DBPGM
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C     BJDFIN        IFEQ      'M'
     C                   MOVE      '1'           *IN98
     C                   ENDIF
      *
      ** Open Printer File:
      *
     C                   Z-ADD     0             RQDLN1            3 0
     C                   Z-ADD     0             DIFLN1            4 0
     C                   Z-ADD     0             PRTLN1
      *
     C                   EXSR      SrRcfP1
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRSELECT : Select Exception Records to be printed on report   *
      * Called by: Main Processing                                    *
      * Calls    : REPORT                                             *
      *****************************************************************
     C     SRSELECT      BEGSR
      *
      ** Check for all Exceptions in this zone, dated today:
      *
     C                   READ      GOEXKSPD                               10
     C     *IN10         DOWEQ     '0'
     C                   MOVEL     'Y'           DET               1
      *
      ** Print details on report:
      *
     C                   EXSR      REPORT
      *
 
     C                   READ      GOEXKSPD                               10
     C                   ENDDO
      *
      ** If no Exceptions are found, print 'No Details':
     C     DET           IFEQ      'N'
     C                   EXSR      NODET
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      *  REPORT - Generate GOEXRP1 Report
      *  Called by: SRSELECT                                          *
      *  Calls    :                                                   *
      *****************************************************************
     C     REPORT        BEGSR
      *
     C                   MOVEL     *BLANKS       RPWARNM
     C                   MOVEL     *BLANKS       RPUSER
     C                   MOVEL     *BLANKS       RPWARNM2                                    BUG7841
     C                   MOVEL     *BLANKS       RPWARNM3                                    BUG7841
     C                   MOVEL     *BLANKS       RPFORC                                       CSD086
     C                   MOVEL     *BLANKS       RPCLAS                                       CSD086
      *
     C                   MOVEL     KSZONE        RPZONE
     C                   MOVEL     KSBRCA        RPBRCA
     C                   MOVEL     KSTREF        RPTREF
     C                   MOVEL     KSMOD         RPMOD
     C                   MOVEL     KSUSER        RPUSER
     C                   MOVEL     KSWDAT        RPWDAT
     C                   MOVEL     KSWTIME       RPWTIME
     C                   MOVEL     KSDESC        RPDESC
     C                   MOVEL     KSWARNCODE    RPWARC
     C**********         MOVEL     KSTEXT        RPWARNM                                     BUG7841
     C                   MOVEL     KSTEXT        WPWARNM1        120                         BUG7841
     C                   MOVE      KSTEXT        WPWARNM2        380                         BUG7841
     C                   MOVEL     WPWARNM2      WPWARNM3        120                         BUG7841
     C                   MOVEL     WPWARNM1      RPWARNM                                     BUG7841
     C                   MOVE      WPWARNM1      RPWARNM2                                    BUG7841
     C                   MOVEL     WPWARNM3      RPWARNM3                                    BUG7841
     C                   MOVEL     KSACTION      RPTACT                                      BUG7841
     C                   MOVEL     KSAPI         RPAPI
      *                                                                                       CSD086
     C     KSFORC        IFEQ      'Y'                                                        CSD086
     C                   MOVEL     'YES'         RPFORC                                       CSD086
     C                   ELSE                                                                 CSD086
     C                   MOVEL     'NO'          RPFORC                                       CSD086
     C                   ENDIF                                                                CSD086
      *                                                                                       CSD086
     C                   SELECT                                                               CSD086
     C     KSCLAS        WHENEQ    'E'                                                        CSD086
     C                   MOVEL     'BLOCKING'    RPCLAS                                       CSD086
     C     KSCLAS        WHENEQ    'W'                                                        CSD086
     C                   MOVEL     'WARNING'     RPCLAS                                       CSD086
     C     KSCLAS        WHENEQ    'O'                                                        CSD086
     C                   MOVEL     'OVERRIDABLE' RPCLAS                                       CSD086
     C                   ENDSL                                                                CSD086
      *
     C     KSTREF        IFNE      SVTREF
     C                   Z-ADD     11            RQDLN1
     C                   ELSE
     C                   Z-ADD     4             RQDLN1
     C                   ENDIF
     C     OFLLN1        SUB       PRTLN1        DIFLN1
      *
     C     DIFLN1        IFLE      RQDLN1
     C     KSBRCA        ORNE      SVBRCA
     C                   WRITE     HEADER1
     C                   WRITE     DETAIL1
     C                   ELSE
      *
      * Print 1st detail line on report if new transaction:
     C     KSTREF        IFNE      SVTREF
     C                   WRITE     DETAIL1
     C                   ENDIF
     C                   ENDIF
      *
      * Print 2nd detail line on report:
     C                   WRITE     DETAIL2
     C                   MOVEL     'Y'           DET               1
     C                   MOVEL     KSBRCA        SVBRCA
     C                   MOVEL     KSTREF        SVTREF           50
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *  NODET
      *****************************************************************
     C     NODET         BEGSR
      *
     C                   MOVEL     KSZONE        RPZONE
      *
      * Print Header of GOEXRP1:
     C                   WRITE     HEADER1
      *
      ** Print 'No Details' line on report:
     C                   WRITE     NODETR1
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SrRcfP1 - Subroutine to register the P1 Printer File via RCF *
      *                                                               *
      *****************************************************************
     C     SrRcfP1       BEGSR
 
     C                   OPEN      GOEXRP1
 
      ** Ensure Detail Spool File recorded by RCF.
 
     C                   EVAL      ZSnum = PSFNum1
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C***********        PARM                    SEnty                                        BG4543
     C                   PARM      *BLANKS       SEnty                                        BG4543
     C                   PARM                    PSFile1
     C                   PARM                    ZSnum
     C                   PARM      *BLANKS       ZSErr
 
     C                   IF        ZSERR = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
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
      *
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   ENDIF
      *
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      **********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2004
