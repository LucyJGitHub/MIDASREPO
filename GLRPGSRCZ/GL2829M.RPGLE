     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Drop Historic Fontis IAT batches/TPP msgs')
      *****************************************************************
      *                                                               *
      *  Midas - GL module                                            *
      *                                                               *
      *  GL2829M - Drop Historic Fontis IAT Batches and TPP Messages  *
      *                                                               *
      *  Function:  This program output all non-historic Fontis       *
      *             batches and messages                              *
      *                                                               *
      *  Called By: GLC2829 - (Drop Historic Fontis Messages)         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027             Date 09Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.01 -----------------------------------------------*
      *  Prev Amend No. CGL009  *CREATE    Date 02JUN99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL009 - Midas Fontis IAT/TPP interface                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    50         EOF of MGTPPXPD                                 *
      *    51         EOF of MGTPPMPD                                 *
      *    52         EOF of GLIATXPD                                 *
      *    53         EOF of GLIATJPD                                 *
      *    90         General error indicator                         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *PSSR  - Error processing                                    *
      *  *INZSR - Initialise                                          *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      * Fontis IAT batches header
     FGLIATXPD  IF   E           K DISK    INFSR(*PSSR)
      * Fontis IAT batches postings
     FGLIATJL0  IF   E           K DISK    INFSR(*PSSR)
      * Backup IAT batches header
     FGLIATXBK  O    E             DISK    INFSR(*PSSR)
     F                                     RENAME(GLIATXD0:GLIAXBK1)
      * Backup IAT postings
     FGLIATJBK  O    E             DISK    INFSR(*PSSR)
     F                                     RENAME(GLIATJD0:GLIAJBK1)
      * Fontis third party message Index
     FMGTPPXPD  IF   E           K DISK    INFSR(*PSSR)
      * Fontis third party message Data
     FMGTPPMPD  IF   E           K DISK    INFSR(*PSSR)
      * Backup third party message Index
     FMGTPPXBK  O    E             DISK    INFSR(*PSSR)
     F                                     RENAME(MGTPPXD0:MGTPXBK1)
      * Backup third party message Data
     FMGTPPMBK  O    E             DISK    INFSR(*PSSR)
     F                                     RENAME(MGTPPMD0:MGTPMBK1)
      /EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** Array containing Copyright statement
      *
      /SPACE 3
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Data Area giving Installation Control Details
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Fontis Interface ICD
     D SDFONT        E DS                  EXTNAME(SDFONTPD)
      *
      ** Working
     DWTPP             S                   LIKE(BJRDNB)
     DWIAT             S                   LIKE(BJRDNB)
     DWMODT            S                   LIKE(BJRDNB)
     DWREF             DS
     D  W#BREF                             LIKE(FCBREF)
     D    W#DATE                      8S 0 OVERLAY(W#BREF:8)
      *
      ** Parameters for ZDATE10
     DZZDTIN           S              8S 0
     DZZMDNO           S                   LIKE(BJRDNB)
      /EJECT
      /SPACE 3
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *****************************************************************
      * MAIN PROCEDURE
      *
     C                   EXSR      SRIAT
     C                   EXSR      SRTPP
     C                   SETON                                        LR
      *
      *****************************************************************
     C*
     C     SRIAT         BEGSR
     C*
     C                   READ      GLIATXPD                               52
     C     *IN52         DOWEQ     '0'
      *
      ** Convert message date to Midas Day number
     C                   MOVEL     FCBREF        WREF
     C                   CALLB     'ZDATE10'                            90
     C                   PARM      W#DATE        ZZDTIN
     C     WMODT         PARM                    ZZMDNO
      *
     C     *IN90         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   SETON                                          U7U8
     C                   Z-ADD     001           DBASE
     C                   MOVEL(P)  'ZDATE10'     DBFILE
     C                   MOVEL(P)  FFMODE        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Output unaccepted and non-historic Fontis IAT batches
      **   Unnacepted batches are those with FCPROC <> 'A'
      **   Non-historic batches are those with receipt date >= retention
      **   date
     C     FCPROC        IFNE      'A'
     C     WMODT         ANDGE     WIAT
      *
      **   Reset processed flag if not blank
      *
     C     FCPROC        IFNE      *BLANK
     C                   MOVEL     *BLANK        FCPROC
     C                   ENDIF
      *
     C                   WRITE     GLIAXBK1
      *
     C     FCBREF        SETLL     GLIATJD0                               53
     C     *IN53         IFEQ      '1'
     C     FCBREF        READE     GLIATJD0                               53
     C     *IN53         DOWEQ     '0'
     C                   WRITE     GLIAJBK1
     C     FCBREF        READE     GLIATJD0                               53
     C                   ENDDO
      ** Detail record not found
     C                   ELSE
     C     *LOCK         IN        LDA
     C                   SETON                                          U7U8
     C                   Z-ADD     002           DBASE
     C                   MOVEL(P)  'GLIATJL0'    DBFILE
     C                   MOVEL(P)  FFMIR         DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   READ      GLIATXPD                               52
     C                   ENDDO
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
     C*
     C     SRTPP         BEGSR
     C*
     C                   READ      MGTPPXPD                               50
     C     *IN50         DOWEQ     '0'
      *
      ** Convert message date to Midas Day number
     C                   CALLB     'ZDATE10'                            90
     C                   PARM      FFMODE        ZZDTIN
     C     WMODT         PARM                    ZZMDNO
      *
     C     *IN90         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   SETON                                          U7U8
     C                   Z-ADD     003           DBASE
     C                   MOVEL(P)  'ZDATE10'     DBFILE
     C                   MOVEL(P)  FFMODE        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Output non-historic Fontis messages
      ** Non-historic messages are those with receipt date >= retention
      ** date
     C     WMODT         IFGE      WTPP
     C                   WRITE     MGTPXBK1
      *
     C     FFMIR         SETLL     MGTPPMPD                               51
     C     *IN51         IFEQ      '1'
     C     FFMIR         READE     MGTPPMPD                               51
     C     *IN51         DOWEQ     '0'
     C                   WRITE     MGTPMBK1
     C     FFMIR         READE     MGTPPMPD                               51
     C                   ENDDO
      ** Detail record not found
     C                   ELSE
     C     *LOCK         IN        LDA
     C                   SETON                                          U7U8
     C                   Z-ADD     004           DBASE
     C                   MOVEL(P)  'MGTPPMPD'    DBFILE
     C                   MOVEL(P)  FFMIR         DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   READ      MGTPPXPD                               50
     C                   ENDDO
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      ************ CALL DBERRCTL IF INTERACTIVE PROGRAM ***************
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
      ************ CALL DBERRCTL IF INTERACTIVE PROGRAM ******************
      *
     C******BATCH********CALL      'DBERRCTL'
      *
      ********************************************************************
     C                   END
      *
      ************ END PROGRAM IF DBERRCTL NOT CALLED ********************
     C                   SETON                                        U7U8LR
     C                   RETURN
      ********************************************************************
      *
     C                   ENDSR
      *****************************************************************
      * *INZSR - INITIAL PROCESSING                                   *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    P#PARM1          10
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** Read in Installation Data
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C     *DTAARA       DEFINE                  LDA
     C                   IN        RUNDAT
      *
      ** Set Date Format Indicator *IN98  on if date format is MMDDYY
      *
     C     AGDFF         IFEQ      'M'
     C                   SETON                                        98
     C                   ENDIF
      *
      ** Retrieve Bank Details
     C                   CALLB     'AOBANKR0'                           90
     C                   PARM                    P@RTCD            7            B:Return code
     C                   PARM      '*FIRST'      P@OPTN            7            I:Option
     C     SDBANK        PARM      SDBANK        DSFDY                          O:Format
      *
     C     P@RTCD        IFNE      *BLANK
     C     *IN90         OREQ      '1'
     C     *LOCK         IN        LDA
     C                   SETON                                          U7U8
     C                   Z-ADD     005           DBASE
     C                   MOVEL(P)  'AOBANKR0'    DBFILE
     C                   MOVEL(P)  '*FIRST'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Retrieve Electronic Banking ICD record
     C                   CALL      'AOFONTR0'                           90
     C                   PARM                    P@RTCD            7            B:Return code
     C                   PARM      '*FIRST'      P@OPTN            7            I:Option
     C     SDFONT        PARM      SDFONT        DSFDY                          O:Format
      *
     C     P@RTCD        IFNE      *BLANK
     C     *IN90         OREQ      '1'
     C     *LOCK         IN        LDA
     C                   SETON                                          U7U8
     C                   Z-ADD     006           DBASE
     C                   MOVEL(P)  'AOFONTR0'    DBFILE
     C                   MOVEL(P)  '*FIRST'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Set retention base date
     C     BJRDNB        SUB       F8MRDS        WTPP
     C     BJRDNB        SUB       F8BRDS        WIAT
     C                   ENDSR
      *****************************************************************
      * SAMPLE ERROR                                                  *
      * Its a sample to show how handle errors. Don't call it         *
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
