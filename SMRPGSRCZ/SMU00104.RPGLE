     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Update RSACMTPD field NRTC to 0 if blank')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU000104 - Update field NRTC on RSACMTPD to blanks if 0     *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. BG26993            Date 26Jan10               *
      *                 R10.5/xx           Date  1May02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BG26993  - Delivery of upgrade programs to core.             *
      *           - Renamed program X.5P0601.                         *
      *  R10.5/xx - Upgrade RSACMTPD when NRTC changed from numeric   *
      *             to alpha.  Run after CPYF *NOCHK.                 *
      *                                                               *
      *****************************************************************
      *
     FRSACMTPD  UF   E             DISK
      *
     C                   READ      RSACMTPO                               01
     C     *IN01         DOUEQ     '1'
     C     NRTC          IFEQ      '00'
     C                   MOVE      *BLANK        NRTC
     C                   UPDATE    RSACMTPO
     C                   END
     C                   READ      RSACMTPO                               01
     C                   ENDDO
      *
     C                   SETON                                        LR
     C                   RETURN
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
