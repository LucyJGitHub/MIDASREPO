     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas TI Branches with no accruals report')
      *****************************************************************
      *                                                               *
      *  Midas - Trade Inovation (TI) Module                          *
      *                                                               *
      *  TI0507 - TI Branches with no Accruals                        *
      *                                                               *
      *  Program Function:                                            *
      *                                                               *
      *  Phase(s): I/C by Menu Request                                *
      *                                                               *
      *  Called By:                                                   *
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
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CTI003   *CREATE   Date 04Sep00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  212558 - Use TIPOSTLB to use Branch as primary key.          *
      *  CTI003 - Patch D.  CoB changes.                              *
      *                                                               *
      *****************************************************************
      *
      * Branches
     FSDBRCHPD  IF   E             DISK    INFSR(*PSSR)
      *
      * TI Postings
     F*TIPOSTL0*IF***E           K DISK    INFSR(*PSSR)                                       212558
     FTIPOSTLB  IF   E           K DISK    INFSR(*PSSR)                                       212558
      *
     FTI0507AU  O    E             PRINTER INFDS(SPOOLU)
      *
      ** DS for reformatting TI branch codes
     D                 DS
     D BRANCHD                 1      4  0
     D D#BRCH                  1      4
     D BRANCH3                 1      3
     D KEY                     2      4
     D SPACE                   4      4
      *
      ** DS for reformatting TI branch codes
     D RUNDAT        E DS
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      ****88**-*End*of*File*TIPOSTL0                                  *                       212558
      *   88  - End of File TIPOSTLB                                  *                       212558
      *   89  - End of File SDBRCHPD                                  *
      * 90-99 - Used by Standard Subroutines                          *
      *                                                               *
      * U7+U8 - Database error                                        *
      *                                                               *
      *****************************************************************
      /SPACE 3
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  RDVDBR - Find a TI branch with no accruals                   *
      *  *PSSR  - Program Error processing Subroutine                 *
      *  INIT   - Initial processing                                  *
      *                                                               *
      *****************************************************************
     D/EJECT
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
      *
     D SPOOLU          DS
      **  File Information Data Structure for TI0507AU.
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
     D  OFLLNU               188    189B 0
     D  PRTLNU               367    368B 0
      *
     C/TITLE Main Processing
      *================================================================
      *  P R O G R A M   S T A R T                                    *
      *================================================================
      *
     C                   WRITE     HEADAU
      *
      ***Read*SDBRCHPD*&*check*TIPOSTL0*for*outstanding*accruals.                             212558
      ** Read SDBRCHPD & check TIPOSTLB for outstanding accruals.                             212558
      *
     C                   EXSR      RDVDBR
      *
      ** If a TI branch with no outstanding accruals found, report it.
      ** Set on U7 & U8 to fail the CoB component.
      *
     C     ERROR         IFEQ      'Y'
     C     *IN89         ANDEQ     *OFF
      *
     C                   SETON                                        U7U8
      *
     C     ERROR         DOWEQ     'Y'
     C     *IN89         ANDEQ     *OFF
      *
      ** Check that sufficient lines remain for the Format.
      *
     C     OFLLNU        SUB       PRTLNU        DIFLNU            3 0
     C     DIFLNU        IFLE      RQDLNU
     C                   WRITE     HEADAU
     C                   ENDIF
      *
     C                   WRITE     DETAIL
      *
      ***Read*SDBRCHPD*&*check*TIPOSTL0*for*outstanding*accruals.                             212558
      ** Read SDBRCHPD & check TIPOSTLB for outstanding accruals.                             212558
      *
     C                   EXSR      RDVDBR
      *
     C                   ENDDO
      *
     C                   WRITE     TRAILAU
      *
      **  If no branches in error found, report.
      *
     C                   ELSE
     C                   WRITE     NODTLS
     C                   ENDIF
      *
      **  End program and return.
      *
     C                   SETON                                        LR
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
      *  Called By: Automatically                                     *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      **  Initialise LDA field.
      *
     C                   MOVEL     'TI0507P'     DBPGM
     C     *DTAARA       DEFINE    LDA           @LDA            256
      *
      ** Read in Installation Data
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
      **  Initialise required no. of lines for detail output
      *
     C                   Z-ADD     2             RQDLNU            3 0
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/RDVDBR
      *****************************************************************
      *                                                               *
      *  RDVDBR - Read SDBRCHPD & check if no outstanding accruals    *
      *           exist for each TI branch.                           *
      *                                                               *
      *****************************************************************
      *
     C     RDVDBR        BEGSR
      *
      **  Find TI Branch codes in SDBRCHPD, and check if any accruals
      ****exist*in*TIPOSTL0*for*that*Branch                                                   212558
      **  exist in TIPOSTLB for that Branch                                                   212558
      *
     C     *IN89         DOUEQ     *ON
     C     ERROR         OREQ      'Y'
     C     BRANCHD       ANDNE     0
     C                   READ      SDBRCHPD                               89
      *
      ** Reset branch in error flag.
      *
     C                   MOVE      ' '           ERROR             1
      *
      ** Reset TISEQN.
      *
     C                   CLEAR                   TISEQN
      *
      ** Make sure that the branch code is four long, with
      ** no space in 4th position.
      *
     C                   CLEAR                   TEMP              3 0
     C                   CLEAR                   D#BRCH
     C                   MOVE      A8TIBR        D#BRCH
     C     SPACE         IFEQ      ' '
     C                   MOVE      BRANCH3       TEMP
     C                   Z-ADD     TEMP          BRANCHD
     C                   ENDIF
      *
      ** Set up key field - four long, left justified, with
      ** a space in 4th position.
      *
     C                   CLEAR                   BRKEY             4
     C                   MOVEL     KEY           BRKEY
      *
     C     BRANCHD       IFNE      0
      *
     C*****BRKEY         SETLL     TIPOSTL0                                                   212558
     C     BRKEY         SETLL     TIPOSTLB                                                   212558
      *
     C     *IN88         DOUEQ     *ON
     C     ERROR         OREQ      'N'
      *
     C*****BRKEY         READE     TIPOSTL0                               88                  212558
     C     BRKEY         READE     TIPOSTLB                               88                  212558
      *
     C     TISEQN        IFGE      900
     C     *IN88         ANDEQ     *OFF
     C                   MOVE      'N'           ERROR
     C                   ENDIF
      *
     C                   ENDDO
      *
      ***If*at*end*of*TIPOSTL0*and*Error*flag*has*not*been*reset,                             212558
      ** If at end of TIPOSTLB and Error flag has not been reset,                             212558
      ** then there is a branch in error.  Set flag to 'Y'.
      *
     C     *IN88         IFEQ      *ON
     C     ERROR         ANDEQ     ' '
     C                   MOVE      'Y'           ERROR
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
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
      **  Check to see that *PSSR has not already been called.
      *
     C     WRUN          IFEQ      *BLANK
     C                   MOVE      'Y'           WRUN              1
      *
     C     *LOCK         IN        @LDA
     C                   MOVEL     DBERR         @LDA
     C                   OUT       @LDA
     C                   SETON                                        U7U8LR
     C                   DUMP
     C                   ENDIF
      *
      **  If *PSSR already run, then just end the program here.
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
