     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Private Banking migration - FXDEALPP')        *
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  SMU00047 - Migrate FXDEALPP                                  *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CDL099             Date 06Oct17               *
      *                 CDL094             Date 11Jun14               *
      *                 CSW212             Date 03May12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BG26993            Date 26Jan10               *
      *                 CSM001 *CREATE     Date 14Oct02               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CSW212 - SWIFT 2012 Changes (Recompile)                      *
      *  BG26993 - Delivery of upgrade programs to core.              *
      *          - Rename program CPBMIG35.                           *
      *  CSM001  - Upgrade of Private Banking layer.                  *
      *                                                               *
      *****************************************************************
      * Function of indicators
      *
      *       20      End of file
      *       69      Read, write or chain fail
      *
     FFXDEALPP  UF   E             DISK
      *
      /EJECT
      *
     D @YD             S              5  0 DIM(4) CTDATA PERRCD(4) ASCEND
     D @MD             S              5  0 DIM(13) CTDATA PERRCD(13) ASCEND
      *
     D PSDS           SDS
      *
      * Program Status Data Structure.
      *
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
      * Date (YYYYMMDD)
     D FullDate        DS
     D  DateIn                 1      8  0
     D  Year                   1      4  0
     D  Century                1      2  0
     D  Month                  5      6  0
     D  Day                    7      8  0
      *
     D DateOut         S              5P 0
      *
      * Read FXDEALPP
     C     1             SETLL     FXDEALP0
     C                   READ      FXDEALP0                             6920
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
     C     *IN20         DOWEQ     *OFF
      *
      * Value date day number
     C     FHVDYY        IFEQ      0
     C     FHVDMM        ANDEQ     0
     C     FHVDDD        ANDEQ     0
      *
     C                   Z-ADD     0             FHVDDN
     C                   ELSE
      *
     C                   Z-ADD     FHVDYY        Year
     C                   Z-ADD     FHVDMM        Month
     C                   Z-ADD     FHVDDD        Day
     C                   EXSR      ZDAT10
     C                   Z-ADD     DateOut       FHVDDN
     C                   ENDIF
      *
      * Deal date day number
     C     FHDTYY        IFEQ      0
     C     FHDTMM        ANDEQ     0
     C     FHDTDD        ANDEQ     0
      *
     C                   Z-ADD     0             FHDDDN
     C                   ELSE
      *
     C                   Z-ADD     FHDTYY        Year
     C                   Z-ADD     FHDTMM        Month
     C                   Z-ADD     FHDTDD        Day
     C                   EXSR      ZDAT10
     C                   Z-ADD     DateOut       FHDDDN
     C                   ENDIF
      *
      * Option to date day number
     C     FHDOEY        IFEQ      0
     C     FHDOEM        ANDEQ     0
     C     FHDOED        ANDEQ     0
      *
     C                   Z-ADD     0             FHOTDN
     C                   ELSE
      *
     C                   Z-ADD     FHDOEY        Year
     C                   Z-ADD     FHDOEM        Month
     C                   Z-ADD     FHDOED        Day
     C                   EXSR      ZDAT10
     C                   Z-ADD     DateOut       FHOTDN
      *
     C                   ENDIF
      *
     C                   UPDATE    FXDEALP0
     C                   READ      FXDEALP0                             6920
     C                   ENDDO
      *
     C     ENDPGM        TAG
     C                   SETON                                        LR
     C                   RETURN
      /EJECT
     C*******************************************************************
      *
     C     ZDAT10        BEGSR
      *
     C                   Z-ADD     0             DateOut           5 0
      *
     C     DateIn        CABEQ     0             ZDAT19
     C     Year          IFGE      2072
     C     Year          SUB       1972          Year
      *
     C     Century       MULT      36525         DateOut
     C     Year          ADD       1972          Year
     C                   END
      *
     C     Year          ADD       28            ZWWK2             2 0
      *
     C     ZWWK2         DIV       4             ZWWK2
     C                   MVR                     ZWREM             1 0
      *
     C     ZWWK2         MULT      1461          ZWWK5             5 0
     C                   ADD       ZWWK5         DateOut
      *
     C     ZWREM         IFEQ      0
     C     Month         ANDGT     2
     C                   ADD       1             DateOut
     C                   END
      *
     C     ZWREM         IFNE      0
     C                   ADD       @YD(ZWREM)    DateOut
     C                   END
      *
     C                   ADD       @MD(Month)    DateOut
      *
     C                   ADD       Day           DateOut
      *
     C     ZDAT19        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: None                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR SR **
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   END
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *
      ********************************************************************
** @YD
00366007310109601461
** @MD
00000000310005900090001200015100181002120024300273003040033400365
