/*XBIA*  OVRDBF FILE(MRPCMXL1C) TOFILE(MRPCMXL1) MBR(CURR)            *
/*XBIB*  OVRDBF FILE(MRPCMXL1H) TOFILE(MRPCMXL1) MBR(HIST)            *
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas MR Identify Historic Posting Months')
     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
      *                                                               *
      *  Midas - MidasPlus Reporting Module                           *
      *                                                               *
      *  MR000011 -  Identify Historic Posting Months                 *
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
 
     FMRPCMXL1C UP  AE           K DISK    RENAME(MRPCMXD0:CurrMonth)
     FMRPCMXL1H IS  AE           K DISK    RENAME(MRPCMXD0:HistMonth)
 
     ICurrMonth     01
     I                                          CY            L1M2
     I                                          CM            L1M1
 
     IHistMonth     02
     I                                          CY            L1M2
     I                                          CM            L1M1
 
     C   01
     CANNMR              EXSR      UPD_CURR
 
      /SPACE 5
     C**********************************************************************************
     C     UPD_CURR      BEGSR
     C     CURRMN        IFNE      'Y'
     C                   MOVEL     'Y'           HISTMN
     C                   UPDATE    CurrMonth
     C                   ENDIF
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     *INZSR        BEGSR
 
     C                   ENDSR
     C**********************************************************************************
