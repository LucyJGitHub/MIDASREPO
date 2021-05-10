     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD056890
/*STD *  RPGSQLBND                                                    *                     MD056890
/*EXI *  TEXT('Midas PB Maintenance calling pgm to check window')
      *****************************************************************
      *                                                               *
      *  Midas - Private Banking Module                               *
      *                                                               *
      *  PB0005 - CALLS PB MAINTENANCE PROGRAMS AND CHECKS FOR        *
      *           WINDOW PROCESSING                                   *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD057705           Date 21Jan21               *
      *  Prev Amend No. MD056890           Date 11Oct20               *
      *                 MD055681           Date 31Jul20               *
      *                 MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CPK018             Date 19Mar05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CPB001  *CREATE    Date 9JUn99                *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD057705 - Deliverable Data Split for SDOREFPD               *
      *  MD056890 - Deliverable Data Split for SDMREFPD               *
      *  MD055681 - Deliverable Data Split for SAR                    *
      *  MD046248 - Finastra Rebranding                               *
      *  CPK018 - Change to make windows switchable. Replace use of   *
      *           - Replace use of SDMREFL1 with SDMREFJ0.            *
      *  CPB001 -  'Private Banking' Module                           *
      *                                                               *
      *****************************************************************
     FSDMMODPD  IF   E             DISK
     F*SDMREFL1IF*E*******    K        DISK                                                   CPK018
     F*SDMREFJ0* IF   E           K DISK                                                    MD056890
     F*SDOREFL1* IF   E           K DISK                                                    MD057705
     D MSG             S             40    DIM(1) CTDATA PERRCD(1)
     D*  DATA STRUCTURE FOR COMPILATION  - COPYRIGHT INSERTION
     D CPYR@#          DS
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
     D  CPY@##                 1     20
     D SDMREF        E DS                  EXTNAME(SDMRFJW1)                                MD056890
     D NullInds        s              5i 0 dim(17)                                          MD056890
     D SDOREF        E DS                  EXTNAME(SDOREJW0)                                MD057705
     C*
     C*  ENTRY PARAMETERS ARE PROGRAM NAMES
     C*
     C     *ENTRY        PLIST
     C                   PARM                    PGM1              8
     C                   PARM                    PGM2              8
     C                   PARM                    PGMMD             1
     C                   PARM                    PGM3              8
     C*
     C     PGM1          IFEQ      *BLANKS
     C  N92              CALL      PGM2                                 90
     C                   PARM                    WORTN             7
     C                   PARM                    PGMMD
     C                   ELSE
     C*
     C*  IF NO ALTERNATIVE PROGRAM FOR WINDOWS (PGM2) CALL PGM1
     C*
     C     PGM2          IFEQ      *BLANKS
     C*
     C                   CALL      PGM1                                 90
     C                   PARM                    WORTN             7
     C*
     C                   ELSE
     C*
     C                   READ      SDMMODPD                               91
     C*
     C*  CHECK MMOD FOR WINDOW PROCESSING FLAG 'YES'
     C*
     C     BGWDPR        IFEQ      'Y'
     C*
     C*  CHECK SDMREFPD TO SEE IF WINDOW PROCESSING DEFINED
     C*  AND CHECK SDOREFPD TO SEE IF WINDOW PROCESSING DEFINED
     C*
     C                   MOVEL     PGM3          WPGM3            10
     C********** WPGM3     CHAINSDMREFL1             92                                       CPK018
     C*****WPGM3         CHAIN     SDMREFJ0                           92                    MD056890
     C/EXEC SQL                                                                             MD056890
     C+ SELECT *                                                                            MD056890
     C+ into :SDMREF :NullInds                                                              MD056890
     C+ from SDMRFJW1                                                                       MD056890
     C+ where DLNMCP = :WPGM3                                                               MD056890
     C/END-EXEC                                                                             MD056890
     C                   setoff                                       92                    MD056890
     C                   If        SQLCODE = 100                                            MD056890
     C                   seton                                        92                    MD056890
     C                   Endif                                                              MD056890
                                                                                            MD056890
     C*****WPGM3         CHAIN     SDOREFL1                           93                    MD057705
     C/EXEC SQL                                                                             MD057705
     C+ SELECT *                                                                            MD057705
     C+ into :SDOREF                                                                        MD057705
     C+ from SDOREJW0                                                                       MD057705
     C+ where DMNMCP = :WPGM3                                                               MD057705
     C/END-EXEC                                                                             MD057705
     C                   setoff                                       93                    MD057705
     C                   If        SQLCODE = 100                                            MD057705
     C                   seton                                        93                    MD057705
     C                   Endif                                                              MD057705
                                                                                            MD057705
     C     *IN92         IFEQ      '1'
     C     *IN93         ANDEQ     '1'
     C                   CALL      PGM1                                 90
     C                   PARM                    W0RTN             7
     C                   ELSE
     C                   CALL      PGM2                                 90
     C                   PARM                    W0RTN             7
     C                   PARM                    PGMMD
     C                   END
     C*
     C                   ELSE
     C                   CALL      PGM1                                 90
     C                   PARM                    WORTN             7
     C                   END
     C                   END
     C                   END
     C*
     C*  SEND ERROR MESSAGE IF CALL OR READ OPERATIONS FAIL
     C*
     C   91
     COR 90MSG(1)        DSPLY     '*EXT'        REPLY             1
     C*
     C                   SETON                                        LR
     C                   RETURN
     C*
**CTDATA CPY@
(c) Finastra International Limited 2001
**CTDATA MSG
Transaction Failed, Enter to Continue
