     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2007')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Inits. New Exch. Rate field on CLOANCK')      *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00080 - Initialises New Exchange Rate Field on CLOANCK    *
      *                                                               *
      *  This program needs to be run before a Facility Currency      *
      *  Conversion (LE3600) is run.                                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. BG26993            Date 26Jan10               *
      *                 148813  *CREATE    Date 14Jan99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  BG26993 - Delivery of upgrade programs to core.              *
      *          - Renamed program S14881301.                         *
      *  148813  - Upgrade program for DBAR2 IR09.                    *
      *                                                               *
      *****************************************************************
     FCLOANCK   UF   E           K DISK
      *
     C                   READ      CLOANCKF                               60
      *
     C     *IN60         DOWEQ     *OFF
     C     NCCY          IFEQ      *BLANKS
     C                   Z-ADD     0             NFCE
     C                   MOVE      *BLANK        NFMD
     C                   UPDATE    CLOANCKF
     C                   ENDIF
      *
     C                   READ      CLOANCKF                               60
     C                   ENDDO
      *
     C                   SETON                                        LR
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
