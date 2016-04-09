     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2007')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Additional Customer Detls utility')           *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00071 - Additional Customer Details Utility               *
      *                                                               *
      *  Function:  This utility program replaces blank field         *
      *             E5BRT2 with '19'                                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. CER070             Date 19Aug14               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BG26993            Date 26Jan10               *
      *                 113339   *CREATE   Date ddmmmyy               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  BG26993 - Delivery of upgraded programs to core.             *
      *          - Renamed program S11333901.                         *
      *  113339  - SD customer date of birth in MIDAS FORMAT.         *
      *            Add century field to SDACUSPD.                     *
      *****************************************************************
     FSDBANKPD  IF   E             DISK
     FSDACUSPD  UF   E             DISK
      *
     C                   READ      SDBANKPD                               40
      *
     C                   READ      SDACUSPD                               35
      *
     C     *IN35         DOWEQ     '0'
      *
     C                   CALL      'ZDATE2'
     C                   PARM      E5BRTH        E5BRTH            5 0          Work Midas Date
     C                   PARM      BJDFIN        D                 1            Date format fla
     C                   PARM      *ZERO         DOBN              6 0          Work Converted
     C                   PARM      *BLANK        DOBA              7            Work Alpha Date
      *
     C                   MOVE      DOBN          E5BRT1
      *
     C     E5BRTH        IFNE      0
     C                   MOVE      '19'          E5BRT2
     C                   ENDIF
      *
     C     E5BRTH        IFGE      10228
     C                   Z-ADD     0             E5BRTH
     C                   ENDIF
      *
     C                   UPDATE    SDACUSD0
      *
     C                   READ      SDACUSPD                               35
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
