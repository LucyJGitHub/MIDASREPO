     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2007')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Update REACT fld to "Y" for certain dates')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00094 - Update REACT field to "Y" if                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Last Amend No. BG26993            Date 26Jan10               *
      *  Prev Amend No. 172614 *CREATE     Date 26Feb01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BG26993 - Delivery of upgrade programs to core.              *
      *          - Renamed program S17261401.                         *
      *  172614  - CoB component lasting many hours                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators                                            *
      *                                                               *
      *  90   End of file                                             *
      *  91   Error on file access                                    *
      *  LR   Last Record                                             *
      *                                                               *
      *****************************************************************
     FREHPOSPP  UF   E             DISK
      *
     C     *ENTRY        PLIST
     C                   PARM                    LSTDY             5 0
      *
     C                   READ      REHPOSPP                             9190
     C     *IN91         IFEQ      *ON
     C                   SETON                                        U7U8
     C                   GOTO      ENDPGM
     C                   ENDIF
      *
     C     *IN90         DOWEQ     *OFF
      *
      *   If post date or value date is less than the last day of the previous month
      *   then move "Y" to REACT.
      *
     C     PSTD          IFLT      LSTDY
     C     VALD          ANDLT     LSTDY
     C                   MOVEL     'Y'           REACT
     C                   UPDATE    REHPOSPF                             91
     C     *IN91         IFEQ      *ON
     C                   SETON                                        U7U8
     C                   GOTO      ENDPGM
     C                   ENDIF
     C                   ENDIF
      *
     C                   READ      REHPOSPP                             9190
     C     *IN91         IFEQ      *ON
     C                   SETON                                        U7U8
     C                   GOTO      ENDPGM
     C                   ENDIF
      *
     C                   ENDDO
      *
     C     ENDPGM        TAG
     C                   SETON                                        LR
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
