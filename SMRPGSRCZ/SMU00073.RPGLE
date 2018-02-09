     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2007')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Upgrade CGPDEFPD update COPY_TAG literal')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00073 - Upgrade CGPDEFPD                                  *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. BG26993            Date 26Jan10               *
      *                 118048 *C *CREATE  Date 15May97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
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
