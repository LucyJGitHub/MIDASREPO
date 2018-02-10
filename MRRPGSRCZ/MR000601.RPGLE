     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*XBIA*  OVRDBF FILE(MRTRAPXINP) TOFILE(MRTRAPXPD) SHARE(*NO)         *
/*XBIB*  OVRDBF FILE(MRTRAPXOUT) TOFILE(MRTRAPXPD) SHARE(*NO)         *
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas MR Purge Transactions, Accounts & Posns Ex2D')
      *****************************************************************
      *                                                               *
      *  Midas - MidasPlus Reporting module                           *
      *                                                               *
      *  RPGLE/MR000601 - Purge Transactions, Accounts & Positions    *
      *                   Extracted To Date                           *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CDL038             Date 10May05               *
      *                 BUG6543  *CREATE   Date 08Apr05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL038 - Extended Deal Sub Type                              *
      *  BUG6543 - MRTRAPXPD file is not purged.                      *
      *                                                               *
      *****************************************************************
 
     FMRTRAPXINPIP   E             DISK    INFSR(*PSSR)
     FMRTRDTPD  IF   E           K DISK    INFSR(*PSSR)
     FMRTRAPXOUTO    E             DISK    INFSR(*PSSR) RENAME(MRTRAPD0:OUTFIL)
 
 
     IMRTRAPD0      01
     I                                          EXTDAT        L1
 
 
     C   L1EXTDAT        CHAIN     MRTRDTD0                           99
     C   L1
     CAN 99              MOVEL     'X'           RECTYP
     C     RECTYP        IFNE      'D'
     C                   WRITE     OUTFIL
     C                   ENDIF
 
      /SPACE 5
      ******************************************************************************
      * *PSSR  - Program exception error routine                                   *
      ******************************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        WkRun = *BLANK
     C                   MOVEL     'Y'           WkRun             1
     C                   DUMP
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      ******************************************************************************
