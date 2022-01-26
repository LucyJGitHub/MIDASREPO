     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD058079
/*STD *  RPGSQLBND                                                    *                     MD058079
/*EXI *  TEXT('Midas SE Initialisation of S01515 - Update SECOND')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading                                   *
      *                                                               *
      *  Program name: SE0007 - Initialisation of S01515              *
      *                                                               *
      *  Function:  This program initialises:                         *
      *                                                               *
      *             PF/SECOND which determines linked enquiries and   *
      *             changes SE0225 to SE0226, and SE0235 to SE0236.   *
      *                                                               *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD058079           Date 11May21               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 221797  *CREATE    Date 01Oct03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058079 - Deliverable Data Split for sundry files           *
      *  MD046248 - Finastra Rebranding                               *
      *  221797 - Initialise SECOND for S01515.                       *
      *                                                               *
      *****************************************************************
     F*
     F*SECOND**UF  E           K        DISK                                                MD058079
      /EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D*
     D** Array containing Copyright statement
     D SECOND        E DS                  EXTNAME(SECONJW0)                                MD058079
      *****************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    RETCDE            7
     C                   PARM                    PMODE             1
      *
      *** Set up copyright parameter
      *
     C                   MOVEA     CPY@          BIS@             80
      *
     C     PMODE         IFEQ      '1'
     C     PMODE         OREQ      '2'
      *
     C                   EXSR      PROC1
     C                   ENDIF
      *
     C                   SETON                                            LR
     C                   RETURN
      *
      *****************************************************************
      *
      *** This program can be called with a parameter of '2' when the
      *** switchable feature is being reset on or '3' if being set off
      *** OR '1' when the feature is switched on for the first time.
      *
      *****************************************************************
      *
     C     PROC1         BEGSR
     C**********           READ SECOND                   04                                 MD058079
     C********** *IN04     DOWEQ'0'                                                         MD058079
      **********                                                                            MD058079
      **********                                                                            MD058079
     C*****TPGM*         IFEQ      'SE0225'                                                 MD058079
     C**********         MOVEL     'SE0226'      TPGM                                       MD058079
     C**********         UPDATE    SECONDF                                                  MD058079
      **********                                                                            MD058079
     C**********         ELSE                                                               MD058079
     C*****TPGM*         IFEQ      'SE0235'                                                 MD058079
     C**********         MOVEL     'SE0236'      TPGM                                       MD058079
     C**********         UPDATE    SECONDF                                                  MD058079
     C**********         ENDIF                                                              MD058079
     C**********         ENDIF                                                              MD058079
      **********                                                                            MD058079
     C**********         READ      SECOND                                 04                MD058079
     C**********         END                                                                MD058079
     C/EXEC SQL                                                                             MD058079
     C+ update SECONCTD set                                                                 MD058079
     C+   TPGM = 'SE0226'                                                                   MD058079
     C+ where TPGM = 'SE0225'                                                               MD058079
     C/END-EXEC                                                                             MD058079
     C/EXEC SQL                                                                             MD058079
     C+ update SECONCTD set                                                                 MD058079
     C+   TPGM = 'SE0236'                                                                   MD058079
     C+ where TPGM = 'SE0235'                                                               MD058079
     C/END-EXEC                                                                             MD058079
      *
     C                   ENDSR
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
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR SR **
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   END
      *
     C                   SETON                                        U7U8LR
     C                   MOVEL     'FAILURE'     RETCDE
     C                   RETURN
      ********************************************************************
      *
     C                   ENDSR
      *
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2003
