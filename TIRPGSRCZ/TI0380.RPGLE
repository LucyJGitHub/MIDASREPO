     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas TI Postings purge')                              *
      *****************************************************************
      *                                                               *
      *  Midas - Trade Inovation (TI) Module                          *
      *                                                               *
      *  TI0380 - TI Postings Purge                                   *
      *                                                               *
      *  Function: This API will delete A/c postings from PF/TIPOSTPD *
      *            where the Value Date is before the Next Working Day*
      *  Phase(s): COB                                                *
      *                                                               *
      *  Called By: TIC0380                                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027             Date 09Dec05               *
      *  Prev Amend No. 212558             Date 30Jan03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 162541             Date 12JUL99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CTI001   *CREATE   Date 16JUL97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  212558 - Recompile over changed file TIPOSTPD.               *
      *  162541 - Only delete processed postings                      *
      *  CTI001 - Midas / Trade Innovation Interface Phase 1          *
      *                                                               *
      *****************************************************************
      /EJECT
      *
      ** TI Postings File
     FTIPOSTPD  UF   E           K DISK    INFSR(*PSSR)
      *
     F/COPY WNCPYSRC,TI0380F001
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      ** Array containing Copyright statement
      *
      /SPACE 3
     D LDA           E DS           256    EXTNAME(LDA)
      *
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      ** Data Area giving Installation Control Details
      *
     D PSDS           SDS
      ** Program Status Data Structure
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** External DS for Access Objects
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
     D/COPY WNCPYSRC,TIH00009
      *
      *================================================================
      *  P R O G R A M     S T A R T                                  *
      *================================================================
      *
      **  Initialisation Performed.
      *
      **  Delete Relevent Postings
      *
     C                   READ      TIPOSTPD                               89
      *
     C     *IN89         DOWEQ     *OFF
     C     MTIVD         IFLT      BJDNWD
     C     PSTS          ANDEQ     'JEG'                                                      162541
     C                   DELETE    TIPOSTPD
     C/COPY WNCPYSRC,TI0380C001
     C                   ENDIF
     C                   READ      TIPOSTPD                               89
     C                   ENDDO
      *
      *
      *================================================================
      *  P R O G R A M     E N D                                      *
      *================================================================
      *
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *
      *================================================================
      /EJECT
     C/COPY WNCPYSRC,TI0380C002
      *****************************************************************
      /TITLE SR/*INZSR
      *****************************************************************
      *                                                               *
      * *INZSR  - Intialisation routine                               *
      *                                                               *
      * Called: Automatically                                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ** Set up copyright parameter
     C                   MOVEA     CPY@          CPY2@            80
      *
      ***  Initialise LDA field.
     C                   MOVEL     'TI0380'      DBPGM
      *
      ** Read in Installation Data
     C     *DTAARA       DEFINE                  RUNDAT
     C     *DTAARA       DEFINE                  LDA
     C                   IN        RUNDAT
      *
      ** Set Date Format Indicator *IN98  on if date format is MMDDYY
     C     AGDFF         IFEQ      'M'
     C                   SETON                                        98
     C                   ENDIF
      *
      ** Get Bank Details by access object
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   SETON                                          U7U8
     C                   Z-ADD     1             DBASE                          ***************
     C                   MOVEL     'SDBANKPD'    DBFILE                         *DB ERROR 001 *
     C                   MOVEL     '*FIRST'      DBKEY                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C/COPY WNCPYSRC,TI0380C003
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      /TITLE SR/*PSSR
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: Various                                            *
      *                                                               *
      * Calls:                                                        *
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
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *
     C                   ENDSR
      *
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
