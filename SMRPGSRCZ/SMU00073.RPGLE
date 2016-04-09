     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2007')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Upgrade CGPDEFPD update COPY_TAG literal')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00073 - Upgrade CGPDEFPD                                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Last Amend No. BG26993            Date 26Jan10               *
      *  Prev Amend No. 118048 *CREATE     Date 15May97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *   BG26993 - Delivery of upgrade programs to core.             *
      *           - Renamed program S11804801.                        *
      *****************************************************************
      *
     FCGPDEFPD  UP   E             DISK
      *
      *****************************************************************
      *
     D VAL             S             10    DIM(1) CTDATA PERRCD(1)
      *
      *****************************************************************
      *
     C                   MOVEA     VAL(1)        @LRPLA           10
      *
     C     LRPLAN        IFEQ      @LRPLA
     C     LRFLDN        ANDEQ     'COPY_TAG'
     C     LRRECI        ANDEQ     'D'
     C     LRRDE         ANDEQ     *BLANKS
     C     LRLITD        ANDEQ     'L'
     C     LRD256        ANDEQ     *BLANKS
     C                   MOVEL     'Copy'        LRD256
     C                   UPDATE    @PDEFPD
     C                   ENDIF
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program Error Processing Subroutine                 *
      *                                                               *
      *  Called By: Various                                           *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
      * Check to see that *PSSR has not already been called.
     C     *INLR         IFNE      *ON
     C                   EVAL      *INLR = *ON
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   DUMP
     C                   ENDIF
      *
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
** VALUE ARRAY
d12CFCDATA
