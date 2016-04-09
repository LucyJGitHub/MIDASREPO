     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2007')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Electronic Broker field in SDBROKPD')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00079 - This program fills Electronic Broker field        *
      *             in SDBROKPD. (Y if REUTERS, N if other)           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Last Amend No. BG26993            DATE 26Jan10               *
      *  Prev Amend No. 125375   *CREATE   DATE 02Aug98               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  BG26993 - Delivery of upgrade programs to core.              *
      *          - Renamed program S12537501.                         *
      *  125375  - Add Electronic Broker field in SDBROKPD            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators                                            *
      *                                                               *
      *  90   End of file                                             *
      *  LR   Last Record                                             *
      *                                                               *
      *****************************************************************
     FSDBROKPD  UF   E             DISK
      *
      *
     C                   READ      SDBROKPD                               90
      *
     C     *IN90         DOWEQ     *OFF
      *
     C     A9EBS         IFEQ      *BLANKS
      *   If Broker is Reuters the code is 'Y', otherwise 'N'
     C     A9BROK        IFEQ      'REUT'
     C                   MOVE      'Y'           A9EBS
     C                   ELSE
     C                   MOVE      'N'           A9EBS
     C                   ENDIF
     C                   UPDATE    SDBROKD0
     C                   ENDIF
      *
     C                   READ      SDBROKPD                               90
      *
     C                   ENDDO
      *
     C                   SETON                                        LR
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
