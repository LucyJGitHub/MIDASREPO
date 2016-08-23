     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2007')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Update Shared Fee Ind. on LEFEED')            *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00090 - Upgrade LEFEED Shared Fee Indicator               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CLE148             Date 23Jul12               *
      *  Prev Amend No. CLE139             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BG26993            Date 26Jan10               *
      *                 160201 *CREATE     Date 28Nov00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CLE139 - Lending Fee Capitalisation (Recompile)              *
      *  BG26993 - Delivery of upgrade programs to core.              *
      *          - Renamed program S16020101.                         *
      *  160201  - Default Shared Fee Ind. to "N".                    *
      *                                                               *
      *****************************************************************
     FLEFEED    UF   E             DISK
      *****************************************************************
      *
     C                   READ      LEFEED                                 50
      *
     C     *IN50         DOWEQ     '0'
      *
     C     SHFI          IFEQ      ' '
      *
     C                   MOVEL     'N'           SHFI
      *
     C                   ENDIF
      *
     C                   UPDATE    LEFEEDF
     C                   READ      LEFEED                                 50
     C                   ENDDO
     C*
     C                   SETON                                        LR
     C*
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
