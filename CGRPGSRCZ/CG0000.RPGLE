     H DEBUG
     H CCSID(*GRAPH:*SRC)                                                                   MD056543
      *****************************************************************
/*S*DF***RPGBASE*******************************************************                       CSD053
/*S*D ***RPGBNOCVT*****************************************************              CSD053 MD056543
/*E*S ***RPGCVTOPT1****************************************************              CSD053 MD056543
/*STD *  RPGBASEBND                                                   *                     MD056543
/*EXI *  TEXT('Midas CG Initial file setup')
/*OVRF*: OVRDBF                                                     : *
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG0000 - Initial file setup                                  *
      *                                                               *
      *  Function:  This program creates the system default           *
      *             correspondent record for User Defined             *
      *             Correspondence.                                   *
      *                                                               *
      *  Called By: CGC0000 (SCBEGIN) - Next Day Setup                *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD056543           Date 15Sep20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD053             Date 01Jun06               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 S01522             Date 28Oct94               *
      *                                    DATE ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD056543 - EDWH SSRS Reports cannot be run.                  *
      *           - Translate graphic fields of CGCORRPD to readable  *
      *             unicode equivalent.                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD053 - Correspondence Manager Multilanguage Upgrade        *
      *         - (Recompile)                                         *
      *  S01522 - User Defined Correspondence                         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Indicator usage                                              *
      *  ~~~~~~~~~~~~~~~                                              *
      *                                                               *
      *  50   -    NrF for system                                     *
      *                                                               *
      *****************************************************************
      *
     FCGCORRL3  UF A E           K DISK
     F                                     INFSR(SRFILE)
      /EJECT
      ** Copyright statement
      *
      *COPY*CGCPYSRC,SRERRE                                                                 MD056543
      /COPY CGCPYSRC,SRERRDLE                                                               MD056543
      /EJECT
     D CPYR@#          DS
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
      ** Copyright statement
      *
     D RUNDTA        E DS                  EXTNAME(RUNDAT)
      ** Data Area for run-date
      *
      *COPY*CGCPYSRC,SRERRI                                                                 MD056543
      /EJECT
      *
      ** Set up copyright statement
     C                   MOVE      CPYR@#        ACT@             80
      *
      ** Check system record does not already exist
     C     '   '         CHAIN     CGCORRL3                           50
      *
      ** If it does not, set it up.
     C     *IN50         IFEQ      '1'
     C                   MOVEL     'SYSTEM'      CDCORR
     C                   MOVEL     'D'           CDRECI
     C                   MOVEL     'D'           CDRTYP
     C                   MOVEL     'GB'          CDLGID
     C                   MOVEL     'System'      CDCORN
     C                   MOVEL     'IMED'        CDDPRT
     C                   MOVEL     'N'           CDPLAB
     C                   Z-ADD     1             CDATDT
     C                   Z-ADD     99999         CDDADT
     C                   MOVEL     'System'      CDDESC
     C                   MOVEL     ##JOB         CDAJOB
     C                   MOVEL     ##USR         CDAUSR
     C                   TIME                    CDATIM
     C                   MOVEL     'I'           CDAACT
      *
     C                   WRITE     @CORRL3
     C                   ENDIF
      *
      ** End program
     C                   SETON                                        LR
      /EJECT
      *COPY*CGCPYSRC,SRERRC                                                                 MD056543
      *COPY*CGCPYSRC,SRERRPSSR                                                              MD056543
      /COPY CGCPYSRC,SRERRCLE                                                               MD056543
      /COPY CGCPYSRC,SRERRPSSRL                                                             MD056543
**CTDATA CPY@
(c) Finastra International Limited 2001
