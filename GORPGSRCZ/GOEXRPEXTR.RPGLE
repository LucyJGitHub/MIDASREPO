     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI * ALWNULL(*USRCTL)                                              *
/*EXI *  TEXT('Midas GO Exception Reporting Extract')
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  GOEXRPEXTR Midas GO Exception Reporting Extract              *
      *                                                               *
      *  Function:  This module extracts all the Exceptions with a    *
      *             non-null Write Date and stores their information  *
      *             in a temporary file for use by GOEXPRREPT.        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Last Amend No. CSD086             Date 18Mar10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BG4467             Date 05Oct04               *
      *                 CGP008 *CREATE     Date 17Sep04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD086 - Overridable Errors                                  *
      *  BG4467 - Some fields on report GOEXRP1 contain old data.     *
      *  CGP008 - Exception Reporting. Extract today's Exceptions.    *
      *                                                               *
      *                                                               *
      *****************************************************************
      ** Exception Records - All information
     FV_GPEXREP IF   E           K DISK    RENAME(V_GPEXREP:GPEXREP)
     F
      *
     F* Exception Reporting Extract file
     FGOEXKSPD  O    E             DISK    INFSR(*PSSR)
     F                                     RENAME(GOEXKSPD:GOEXKSPF)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  FUNCTION OF INDICATORS                                       *
      *                                                               *
      *   10 -  Record not found on V_GPEXREP                         *
      *                                                               *
      * U7+U8 - Database Error                                        *
      *                                                               *
      *****************************************************************
      /SPACE 3
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  *INZSR   -  Initialise                                       *
      *  SRSELECT -  Select Exception records for today & this zone.  *
      *  SRDETAIL -  Format fields and write to Extract file.         *
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
     D WorkRunDate     S               D
     D DateOut         S              8S 0
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, short data structure
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
     D                 DS
      ** Format amount returned by standard subroutine
     D  ZOUT22                 1     22
     D  ZOUT21                 1     21
     D  ZOUT20                 1     20
     D  ZNEG                  21     21
      *
      /SPACE 3
      *
      *================================================================
      *  P R O G R A M   S T A R T                                    *
      *================================================================
      *
      ** Initialisation subroutine *INZSR runs automatically.
      *
      ** Select Exception Detail Records for today in this zone
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
      *  Calls    : AOBANKR0 AOSARDR0 AOGPSVR0                        *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** Define data areas
      *
     C     *DTAARA       DEFINE                  LDA
     C                   MOVEL     *BLANK        I#ERMS           50
      *
      ** Get Zone (O#ZONE)
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
     C                   MOVEL     'GOEXRPEXTR'  DBPGM
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     BJDFIN        IFEQ      'M'
     C                   MOVE      '1'           *IN98
     C                   ENDIF
      *
      ** Format Run date field:
      *
      ** BJRDNB is a 5 digit Midas Day number, but it needs to be converted
      ** into SQL date format for comparison with the Exception Write date.
      *
     C                   MOVEL     *BLANKS       WORKDATE          8
     C                   CALLB     'ZDATE9'
     C                   PARM      BJRDNB        INDATE            5 0
     C                   PARM                    DateOut           8 0
     C                   PARM      '0'           RTN               1
     C                   MOVEL     DateOut       WDateOut         10
     C                   EVAL      WorkRunDate = %DATE(WDateOut:*ISO0)
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRSELECT : Select Exception Records to be printed on report   *
      * Called by: Main Processing                                    *
      * Calls    : SRDETAIL                                           *
      *****************************************************************
     C     SRSELECT      BEGSR
      *
      ** Check for all Exceptions in this zone, dated today:
      *
     C                   READ      V_GPEXREP                              10
     C     *IN10         DOWEQ     '0'
 
 
      * Only process records in this zone that are dated today
     C     O#ZONE        IFEQ      ERZONE
     C     ERPDAT        ANDEQ     WorkRunDate
     C                   EXSR      SRDETAIL
     C                   ENDIF
 
     C                   READ      V_GPEXREP                              10
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      * SRDETAIL : Format fields and output to Extract file           *
      * Called by: SRSELECT                                           *
      * Calls    :                                                    *
      *****************************************************************
     C     SRDETAIL      BEGSR
      *
     C                   MOVEL     *BLANKS       KSZONE                                       BG4467
     C                   MOVEL     *BLANKS       KSTREF                                       BG4467
     C                   MOVEL     *BLANKS       KSACTION                                     BG4467
     C                   MOVEL     *BLANKS       KSUSER                                       BG4467
     C                   MOVEL     *BLANKS       KSTEXT                                       BG4467
     C                   MOVEL     *BLANKS       KSTYPE                                       BG4467
     C                   MOVEL     *BLANKS       KSDESC                                       BG4467
     C                   MOVEL     *BLANKS       KSFORC                                       CSD086
     C                   MOVEL     *BLANKS       KSCLAS                                       CSD086
      *                                                                                       BG4467
     C                   Z-ADD     ERID          KSERID
     C                   MOVEL     ERZONE        KSZONE
     C                   MOVEL     ERBRCA        KSBRCA
     C                   MOVEL     ERMOD         KSMOD
     C                   MOVEL     ERTREF        KSTREF
     C                   MOVEL     ERAPI         KSAPI
     C                   MOVEL     ERACTION      KSACTION
     C                   MOVEL     ERWDAT        KSWDAT
     C                   MOVEL     ERWTIME       KSWTIME
     C                   MOVEL     ERPDAT        KSPDAT
     C                   MOVEL     ERUSER        KSUSER
     C                   MOVEL     EDWARNCODE    KSWARNCODE
     C                   MOVEL     EDTEXT        KSTEXT
     C                   MOVEL     EXTYPE        KSTYPE
     C                   MOVEL     ETDESC        KSDESC
     C                   MOVEL     ERFORC        KSFORC                                       CSD086
     C                   MOVEL     EDCLAS        KSCLAS                                       CSD086
      *
     C                   WRITE     GOEXKSPF
      *
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
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2004
