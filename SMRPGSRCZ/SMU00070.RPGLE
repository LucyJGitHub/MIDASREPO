     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2007')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Initialise counter CCY amount fields')        *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00070 - Initialise the counter currency amount fields     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CAP208             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *   Prev Amend No. BG26993            Date 26Jan10              *
      *                  111728 *CREATE     Date 29Feb00              *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAP208 - F&O Market Instrument API (Recompile)               *
      *    BG26993- Delivery of upgrade programs to core.             *
      *           - Renamed program S11172801.                        *
      *    111728 - The counter currency amount fields are not        *
      *             initialised and so cause an error when enquiring  *
      *             on existing OTC's of type 4. This program should  *
      *             be used to initialise existing OTC's of type 4    *
      *             that cannot be enquired upon successfully.        *
      *                                                               *
      ********************************************************************
     FINTYPD    UF   E             DISK
      *
     C********************************************************************
      **                M A I N   P R O C E S S I N G
     C********************************************************************
     C                   MOVE      '0'           *IN08
     C*
     C     *IN08         DOWEQ     '0'
     C                   READ      INTYPD                                 08
     C*
     C     *IN08         IFEQ      '0'
     C*
     C     ISPT          IFEQ      4
     C* Move CCAM into alphanumeric field via zoned field
     C* (Initialise CCAMZ and CCAMA fields)
     C                   Z-ADD     *ZERO         CCAMZ
     C                   MOVE      *BLANK        CCAMA
     C                   Z-ADD     CCAM          CCAMZ            13 0
     C                   MOVE      CCAMZ         CCAMA            13
     C*
     C* If the field, CCAMA is zero initialise the CCAM fields.
     C     CCAMA         IFEQ      *ZERO
     C                   Z-ADD     *ZERO         CCAM
     C                   MOVE      *BLANK        SCCAM            13
     C                   Z-ADD     *ZERO         WCCAM            13 0
     C* Update the CCAM field
     C                   EXCEPT    POST
     C                   ENDIF
     C*
     C                   ENDIF
     C*
     C                   END
      * Zeroise/Initialise the CCAM field after update of record
      * and before read of next record. This prevents the carrying of
      * uncorrupt data into a corrupt field. If the CCAM field is
      * corrupt the previous CCAM is not overwritten and hence the next
      * update is incorrect.
      *
     C                   Z-ADD     0             CCAM
      *
     C                   END
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
     OINTYPDF   E            POST
     O                       CCAM
