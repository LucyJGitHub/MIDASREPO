     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas Take on of Stamp Tax Customers')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD008198 - Midas Take on of Stamp Tax Customers              *
      *                                                               *
      *  (C) Copyright Misys International Banking Systems Ltd. 2010  *
      *                                                               *
      *  Last Amend No. AR818226           Date 22Aug11               *
      *  Prev Amend No. CER049  *CREATE    Date 06Dec10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR818226 - Take-on Program SDCUSTQD not successful           *
      *  CER049 - Stamp Tax                                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *PSSR     - Error processing                                 *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas SD Customer details update
     FSDCUSTL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas SD Stamp Tax Customer Extension File
     FSDCUSQL0  UF   E           K DISK    INFSR(*PSSR)
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     D @RUN            S              1A
 
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D RUNDTA        E DS                  EXTNAME(RUNDAT)
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
     C                   DOU       %EOF(SDCUSTL0)
     C                   READ      SDCUSTL0
 
     C                   IF        NOT(%EOF(SDCUSTL0))
     C     KSDCUSQL0     CHAIN     SDCUSQL0
     C**********         IF        %FOUND(SDCUSTL0)                                         AR818226
     C                   IF        %FOUND(SDCUSQL0)                                         AR818226
     C                   EVAL      CQTAX   = 'Y'
     C                   UPDATE    SDCUSQD0
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     KSDCUSQL0     KLIST
     C                   KFLD                    BBCUST
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *  Called by: (**calling routines**)                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(C) Copyright Misys International Banking Systems Ltd., 2010
