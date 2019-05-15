     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2007')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Bridge data correction for SEACKA')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      * SMU00013 - Implementation program for MA012646.               *
      *                                                               *
      *  Function: This program initialises the new SEACKA file       *
      *            control fields from the contents of the redundant  *
      *            ones. It then sets those to zero.                  *
      *                                                               *
      *  (c) Finastra International Limited 2007                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. BG26993            Date 26Jan10               *
      *                 B12646  *CREATE    Date 16Apr07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BG26993 - Delivery of upgrade programs to core.              *
      *          - Renamed program BG12646R01.                        *
      *  B12646  - Cater for SEACKA file control length increase.     *
      *                                                               *
      *****************************************************************
      *
     FSEACKA    UF A E             DISK    INFSR(*PSSR)
      *
      * Update SEACKA trailer
     C     1             CHAIN     SEACKA                             90
      *
      * If trailer not found, Write initial record.
     C                   IF        *IN90 = '1'
      *
     C                   EVAL      SLRB = 0
     C                   EVAL      SINS = 0
     C                   EVAL      SAMD = 0
     C                   EVAL      SDEL = 0
     C                   EVAL      NORE = 0
     C                   EVAL      SLRB10 = 0
     C                   EVAL      SINS10 = 0
     C                   EVAL      SAMD10 = 0
     C                   EVAL      SDEL10 = 0
     C                   EVAL      NORE10 = 0
     C                   WRITE     SEACKAF
      *
     C                   ELSE
      *
     C                   IF        SLRB <> 0
     C                   EVAL      SLRB10 = SLRB
     C                   EVAL      SLRB = 0
     C                   ENDIF
      *
     C                   IF        SINS <> 0
     C                   EVAL      SINS10 = SINS
     C                   EVAL      SINS = 0
     C                   ENDIF
      *
     C                   IF        SAMD <> 0
     C                   EVAL      SAMD10 = SAMD
     C                   EVAL      SAMD = 0
     C                   ENDIF
      *
     C                   IF        SDEL <> 0
     C                   EVAL      SDEL10 = SDEL
     C                   EVAL      SDEL = 0
     C                   ENDIF
      *
     C                   IF        NORE <> 0
     C                   EVAL      NORE10 = NORE
     C                   EVAL      NORE = 0
     C                   ENDIF
      *
     C                   UPDATE    SEACKAF
      *
     C                   ENDIF
      *
      ** End program and return.
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      /EJECT
      *****************************************************************
      /TITLE SR/*PSSR
      *****************************************************************
      *                                                               *
      *  *PSSR  - Error Control subroutine                            *
      *                                                               *
      *  Called By :                                                  *
      *  Calls     : None                                             *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
      ** Check to see that *PSSR has not already been called.
      *
     C                   IF        Recursive = *BLANKS
     C                   MOVE      'Y'           Recursive         1
     C                   DUMP
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
