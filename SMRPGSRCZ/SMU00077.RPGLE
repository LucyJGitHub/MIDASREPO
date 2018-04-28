     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2007')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Century fields in MEINCRPD')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00077 - This program fills new cent. fields in MEINCRPD   *
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
      *          - Renamed program S12467303.                         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators                                            *
      *                                                               *
      *  90   End of file                                             *
      *  LR   Last Record                                             *
      *                                                               *
      *****************************************************************
     FMEINCRPD  UF   E             DISK
      *
     C                   READ      MEINCRPD                               90
      *
     C     *IN90         DOWEQ     *OFF
      *
     C     CRMDEC        IFEQ      *BLANKS
     C     CRSTDC        OREQ      *BLANKS
     C     CRSVDC        OREQ      *BLANKS
     C                   EXSR      SRCNT1
     C                   EXSR      SRCNT2
     C                   EXSR      SRCNT3
     C                   UPDATE    @INCRPD
     C                   ENDIF
      *
     C                   READ      MEINCRPD                               90
      *
     C                   ENDDO
      *
     C                   SETON                                        LR
      *
      *****************************************************************
      * SRCNT1 - Subroutine to allocate century to date CRMODE.
      *****************************************************************
      *
     C     SRCNT1        BEGSR
      *
     C                   MOVE      *BLANKS       CENT              2
      *
     C     CRMODE        IFNE      *ZEROS
     C                   MOVEL     CRMODE        CENT
     C     CENT          IFLT      '72'
     C                   MOVE      '20'          CENT
     C                   ELSE
     C                   MOVE      '19'          CENT
     C                   ENDIF
      *
     C                   MOVE      CENT          CRMDEC
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      *
      *****************************************************************
      * SRCNT2 - Subroutine to allocate century to date CRSNTD.
      *****************************************************************
      *
     C     SRCNT2        BEGSR
      *
     C                   MOVE      *BLANKS       CENT
      *
     C     CRSNTD        IFNE      *ZEROS
     C                   MOVEL     CRSNTD        CENT
     C     CENT          IFLT      '72'
     C                   MOVE      '20'          CENT
     C                   ELSE
     C                   MOVE      '19'          CENT
     C                   ENDIF
     C                   ENDIF
      *
     C                   MOVE      CENT          CRSTDC
      *
     C                   ENDSR
      *
      *****************************************************************
      * SRCNT3 - Subroutine to allocate century to date CRSVDT.
      *****************************************************************
      *
     C     SRCNT3        BEGSR
      *
     C                   MOVE      *BLANKS       CENT
      *
     C     CRSVDT        IFNE      *BLANKS
     C                   MOVEL     CRSVDT        CENT
     C     CENT          IFLT      '72'
     C                   MOVE      '20'          CENT
     C                   ELSE
     C                   MOVE      '19'          CENT
     C                   ENDIF
     C                   ENDIF
      *
     C                   MOVE      CENT          CRSVDC
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
