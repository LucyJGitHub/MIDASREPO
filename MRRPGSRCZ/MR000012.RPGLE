/*XBIA*  OVRDBF FILE(MRPCMXL1H) TOFILE(MRPCMXL1) MBR(HIST)            *
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas MR Update Historic Posting Months')
     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
      *                                                               *
      *  Midas - MidasPlus Reporting Module                           *
      *                                                               *
      *  MR000012 -  Update Historic Posting Months                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CMR001             Date 01Sep04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CMR001 - MidasPlus Reporting                                 *
      *                                                               *
      *****************************************************************
 
     FMRPCMXL1H IF A E           K DISK    RENAME(MRPCMXD0:HistMonth)
 
 
     C                   EXSR      UPD_HIST
 
     C                   SETON                                        LR
     C                   RETURN
 
      /SPACE 5
     C**********************************************************************************
     C     UPD_HIST      BEGSR
     C     PCMXK         KLIST
     C                   KFLD                    CY
     C                   KFLD                    CM
     C                   MOVEL     Year          CY
     C                   MOVEL     Month         CM
     C     PCMXK         CHAIN     HistMonth                          99
     C     *IN99         IFEQ      *ON
     C                   Z-ADD     StartMonthDateCSMDAT
     C                   WRITE     HistMonth
     C                   ENDIF
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     *INZSR        BEGSR
     C     *ENTRY        PLIST
     C                   PARM                    Year              2
     C                   PARM                    Month             2
     C                   PARM                    StartMonthDate    5 0
 
     C                   ENDSR
     C**********************************************************************************
