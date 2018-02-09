     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2007')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Century fields in MSIXI2PD')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00076 - This program fills new cent. fields in MSIXI2PD   *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. BG26993            Date 26Jan10               *
      *                 124673  *CREATE    Date 29Feb00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BG26993 - Delivery of upgrade programs to core.              *
      *          - Renamed program S12467302.                         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators                                            *
      *                                                               *
      *  90   End of file                                             *
      *  LR   Last Record                                             *
      *                                                               *
      *****************************************************************
     FMSIXI2PD  UF   E             DISK
      *
     C                   READ      MSIXI2PD                               90
      *
     C     *IN90         DOWEQ     *OFF
      *
     C     MODEC         IFEQ      *BLANKS
     C     SVDTC         OREQ      *BLANKS
     C                   EXSR      SRCNT1
     C                   EXSR      SRCNT2
     C                   UPDATE    MSIXI2D0
     C                   ENDIF
      *
     C                   READ      MSIXI2PD                               90
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
      *
      *****************************************************************
      * SRCNT2 - Subroutine to allocate century to date SVDT.
      *****************************************************************
      *
     C     SRCNT2        BEGSR
      *
     C                   MOVE      *BLANKS       CENT
      *
     C     SVDT          IFNE      *BLANKS
     C                   MOVEL     SVDT          CENT
     C     CENT          IFLT      '72'
     C                   MOVE      '20'          CENT
     C                   ELSE
     C                   MOVE      '19'          CENT
     C                   ENDIF
     C                   ENDIF
      *
     C                   MOVE      CENT          SVDTC
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
