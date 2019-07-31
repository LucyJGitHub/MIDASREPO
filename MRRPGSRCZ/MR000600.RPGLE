     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*XBIA*  OVRDBF FILE(MRTRDTPDX) TOFILE(MRTRDTPD) SHARE(*NO)           *
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas MR Extract Transactions, Accnts & Posns Dats')
      *****************************************************************
      *                                                               *
      *  Midas - MidasPlus Reporting module                           *
      *                                                               *
      *  RPGLE/MR000600 - Extract Transactions, Accounts & Positions  *
      *                   Dates                                       *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG6543  *CREATE   Date 08Apr05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG6543 - MRTRAPXPD file is not purged.                      *
      *                                                               *
      *****************************************************************
 
     FMRTRDTPD  IP   E             DISK    INFSR(*PSSR)
     FMRTRDTPDX O    E             DISK    RENAME(MRTRDTD0:OUTFIL)
     F                                     PREFIX(P) INFSR(*PSSR)
 
 
      ** Bank Details Data Structure
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Short Access Object Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
 
      * Convert the transaction date
 
     C                   Z-ADD     EXTDAT        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZADATE        METDAT            5
 
      * Write a record
 
     C   10              EXSR      WRT_RECORD
 
     C                   Z-ADD     EXTDAT        PEXTDAT
     C                   MOVEL     METDAT        PMETDAT           6
     C                   SETON                                        10
 
     CLR                 SETON                                        20
      * Write a record
     CLR                 EXSR      WRT_RECORD
 
      /SPACE 5
      ******************************************************************************
      * Write a record
      ******************************************************************************
     C     WRT_RECORD    BEGSR
     C     *IN20         IFEQ      *ON
     C     PMETDAT       ORNE      METDAT
     C                   MOVEL     'M'           PRECTYP
     C                   ELSE
     C     PEXTDAT       IFLE      RetentionDat
     C                   MOVEL     'D'           PRECTYP
     C                   ELSE
     C                   MOVEL     ' '           PRECTYP
     C                   ENDIF
     C                   ENDIF
     C                   WRITE     OUTFIL
     C                   ENDSR
     C******************************************************************************
      /SPACE 5
      ******************************************************************************
      * Convert date format
      ******************************************************************************
     C     ZDATE2        BEGSR
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM      'D'           ZDATFMT           1
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
     C                   ENDSR
      ******************************************************************************
      /SPACE 5
      ******************************************************************************
      * *INZSR
      ******************************************************************************
     C     *INZSR        BEGSR
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRetCode          7
     C                   PARM      '*FIRST '     POption           7
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C     BJRDNB        SUB       7             RetentionDat      5 0
 
     C                   ENDSR
     C******************************************************************************
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
