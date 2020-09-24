     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/**** *  RPGBASEBND                                                   *                     MD055682
/*STD *  RPGSQLBND                                                    *                     MD055682
/**** *  TEXT('Midas SC Check for 'Live' trigger')                                          MD055682
/*EXI *  TEXT('Midas SC Check for Live trigger')                                            MD055682
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SCCHKLTRG - Check For 'Live' Trigger                         *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD055682           Date 31Jul20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055682 - Deliverable Data Split for TRIG                   *
      *  MD046248 - Finastra Rebranding                               *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    99         Record not found on SDTRIGJ0                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *****************************************************************

     F*SCTRIGJ0* IF   E           K DISK    INFSR(*PSSR)                                    MD055682

     D @RUN            S              1
     D SCTRIG        E DS                  EXTNAME(SCTRGJW0)                                MD055682

      * ENTRY PARAMETERS

     C     *ENTRY        PLIST
     C                   PARM                    I#FILE           10
     C                   PARM                    I#TIME            1
     C                   PARM                    I#EVNT            1
     C                   PARM                    I#SEQ             2
     C                   PARM                    O#LIVE            1

     C*****SCTRIGJ0K     CHAIN     @TRIGJ0                            99                    MD055682
     C/EXEC SQL                                                                             MD055682
     C+ SELECT *                                                                            MD055682
     C+ into :SCTRIG                                                                        MD055682
     C+ from SCTRGJW0                                                                       MD055682
     C+ where TRFILE = :I#FILE and TRTIME = :I#TIME                                         MD055682
     C+   and TREVNT = :I#EVNT and TRSEQ = :I#SEQ                                           MD055682
     C/END-EXEC                                                                             MD055682
     C******IN99         IFEQ      *OFF                                                     MD055682
     C                   IF        SQLCODE = 0                                              MD055682
     C                   MOVEL     'Y'           O#LIVE
     C                   ELSE
     C                   MOVEL     'N'           O#LIVE
     C                   ENDIF

     C                   RETURN
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR

     C     SCTRIGJ0K     KLIST
     C                   KFLD                    I#FILE
     C                   KFLD                    I#TIME
     C                   KFLD                    I#EVNT
     C                   KFLD                    I#SEQ

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR
      *****************************************************************
