     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2007')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Century fields in MSMSI2PD')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00075 - This program fills new cent. fields in MSMSI2PD   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Last Amend No. BG26993            Date 26Jan10               *
      *  Prev Amend No. 124673   *CREATE   Date 29Feb00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BG26993 - Delivery of upgrade programs to core.              *
      *          - Renamed program S12467301.                         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators                                            *
      *                                                               *
      *  90   End of file                                             *
      *  LR   Last Record                                             *
      *                                                               *
      *****************************************************************
     FMSMSI2PD  UF   E             DISK
      *
     C                   READ      MSMSI2PD                               90
      *
     C     *IN90         DOWEQ     *OFF
      *
     C     MODEC         IFEQ      *BLANKS
     C                   EXSR      SRCNT1
     C                   UPDATE    MSMSI2D0
     C                   ENDIF
      *
     C                   READ      MSMSI2PD                               90
      *
     C                   ENDDO
      *
     C                   SETON                                        LR
      *
      *
      *****************************************************************
      * SRCNT1 - Subroutine to allocate century to date MODE.
      *****************************************************************
      *
     C     SRCNT1        BEGSR
      *
     C                   MOVE      *BLANKS       CENT              2
      *
     C     MODE          IFNE      *ZEROS
     C                   MOVEL     MODE          CENT
     C     CENT          IFLT      '72'
     C                   MOVE      '20'          CENT
     C                   ELSE
     C                   MOVE      '19'          CENT
     C                   ENDIF
     C                   ENDIF
      *
     C                   MOVE      CENT          MODEC
      *
     C                   ENDSR
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
