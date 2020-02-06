     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM FT Upgrade utility 1 (SAR is off/on)')        *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00012 - FT Upgrade Utility 1 (SAR is off/on)              *
      *                                                               *
      *  Function:  This program moves the Receiver's Correspondent   *
      *             details from the old fields (RCRT, RCCO) to the   *
      *             new ones (INRCRT, INRCO1-5).                      *
      *                                                               *
      *  Called By: SMUC00012 - FT Upgrade Utility 1 (SAR is off/on)  *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CFT120             Date 28Sep12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BG26993            Date 26Jan10               *
      *                 CFT014  *CREATE    Date 25May00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  BG26993 - Delivery of upgrade programs to core.              *
      *          - Renamed program CFT014R01.                         *
      *  CFT014  - Straight-through Processing Phase 2 MT103          *
      *            Messages Generation for FT.                        *
      *                                                               *
      *****************************************************************
      *
      ** Incoming Payment details file
     FINPAY     UF   E           K DISK    INFSR(*PSSR)
      *
      *****************************************************************
     D/EJECT
      *
      * Perform Incoming Payment detail processing.
     C                   EXSR      SRINPAY
      *
      * End program and return.
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINPAY - Incoming Payment details processing                *
      *                                                               *
      *  Called By : Main Processing                                  *
      *  Calls     : None                                             *
      *                                                               *
      *****************************************************************
     C     SRINPAY       BEGSR
      *
      * Read first record from file.
     C     *LOVAL        SETLL     INPAY
     C                   READ      INPAYDDF                               89
      *
      * Do Until End of File.
     C                   DOW       *IN89 = *OFF
      *
      * Update INPAYDD.
     C                   EVAL      INRCRT = *BLANK
     C                   EVAL      INRCO1 = *BLANK
     C                   EVAL      INRCO2 = *BLANK
     C                   EVAL      INRCO3 = *BLANK
     C                   EVAL      INRCO4 = *BLANK
     C                   EVAL      INRCO5 = *BLANK
      *
     C                   IF        RCRT = 'N'
     C                   MOVEL     RCCO          WFLD2             2
     C                   MOVEL     WFLD2         INRCO1
     C                   ELSE
     C                   MOVEL     RCCO          INRCO1
     C                   ENDIF
      *
     C                   EVAL      INRCRT = RCRT
     C                   EVAL      RCRT = *BLANK
     C                   EVAL      RCCO = *blanks
      *
     C                   UPDATE    INPAYDDF
      *
      * Read next record.
     C                   READ      INPAYDDF                               89
      *
      * End of Do Until End of Valid Records.
     C                   ENDDO
      *
     C                   ENDSR
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
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
      *
      ** Check to see that *PSSR has not already been called.
      *
     C     WRUN          IFEQ      *BLANK
     C                   MOVE      'Y'           WRUN              1
     C                   DUMP
     C                   ENDIF
      *
      ** If *PSSR already run, then just end the program here.
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
