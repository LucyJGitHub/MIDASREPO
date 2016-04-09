     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Private Banking migration - MMDELDPP')        *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00048 - Migrate MMDELDPP                                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. CGL165             Date 15Feb17               *
      *  Prev Amend No. CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BG26993            Date 26Jan10               *
      *                 CSM001 *CREATE     Date 14Oct02               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  BG26993 - Delivery of upgrade programs to core.              *
      *          - Rename program CPBMIG36.                           *
      *  CSM001  - Upgrade of Private Banking layer.                  *
      *                                                               *
      *****************************************************************
      * Function of indicators
      *
      *       20      End of file
      *       69      Read, write or chain fail
      *
     FMMDELDPP  UF   E             DISK
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
      * Read MMDELDPP
     C     1             SETLL     MMDELDP0
     C                   READ      MMDELDP0                             6920
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
     C     *IN20         DOWEQ     *OFF
      *
      * Deal value start date
     C     HKVDYY        IFEQ      0
     C     HKVDMM        ANDEQ     0
     C     HKVDDD        ANDEQ     0
      *
     C                   Z-ADD     0             HKDVSD
     C                   ELSE
      *
     C                   Z-ADD     HKVDYY        Year
     C                   Z-ADD     HKVDMM        Month
     C                   Z-ADD     HKVDDD        Day
     C                   EXSR      ZDAT10
     C                   Z-ADD     DateOut       HKDVSD
     C                   ENDIF
      *
      * Maturity date
     C     HKMDYY        IFEQ      0
     C     HKMDMM        ANDEQ     0
     C     HKMDDD        ANDEQ     0
      *
     C                   Z-ADD     0             HKMATD
     C                   ELSE
      *
     C                   Z-ADD     HKMDYY        Year
     C                   Z-ADD     HKMDMM        Month
     C                   Z-ADD     HKMDDD        Day
     C                   EXSR      ZDAT10
     C                   Z-ADD     DateOut       HKMATD
     C                   ENDIF
      *
      * Next interest payment date
     C     HKNIYY        IFEQ      0
     C     HKNIMM        ANDEQ     0
     C     HKNIDD        ANDEQ     0
      *
     C                   Z-ADD     0             HKNIPD
     C                   ELSE
      *
     C                   Z-ADD     HKNIYY        Year
     C                   Z-ADD     HKNIMM        Month
     C                   Z-ADD     HKNIDD        Day
     C                   EXSR      ZDAT10
     C                   Z-ADD     DateOut       HKNIPD
      *
     C                   ENDIF
      *
      * Start date or last interest date
     C     HKSLYY        IFEQ      0
     C     HKSLMM        ANDEQ     0
     C     HKSLDD        ANDEQ     0
      *
     C                   Z-ADD     0             HKSLID
     C                   ELSE
      *
     C                   Z-ADD     HKSLYY        Year
     C                   Z-ADD     HKSLMM        Month
     C                   Z-ADD     HKSLDD        Day
     C                   EXSR      ZDAT10
     C                   Z-ADD     DateOut       HKSLID
      *
     C                   ENDIF
      *
      * Deal done date
     C     HKDDYY        IFEQ      0
     C     HKDDMM        ANDEQ     0
     C     HKDDDD        ANDEQ     0
      *
     C                   Z-ADD     0             HKDDND
     C                   ELSE
      *
     C                   Z-ADD     HKDDYY        Year
     C                   Z-ADD     HKDDMM        Month
     C                   Z-ADD     HKDDDD        Day
     C                   EXSR      ZDAT10
     C                   Z-ADD     DateOut       HKDDND
      *
     C                   ENDIF
      *
     C                   UPDATE    MMDELDP0
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   READ      MMDELDP0                             6920
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
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
