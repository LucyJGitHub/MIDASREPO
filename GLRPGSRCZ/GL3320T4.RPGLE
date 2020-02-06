     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas GL Trailers Update for GL3320')                  *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL3320T4 - Midas GL Trailers update for GL3320               *
      *                                                               *
      *  Function:  Update ABEXZY, ACCNTAC, STMTZX and REACRZ files   *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD042411           Date 18Nov16               *
      *                 MD035213           Date 25May16               *
      *                 MD024688           Date 09May14               *
      *                 CGL142   *CREATE   Date 06Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD042411 - BRCA/CCY/ACOD totals can be more than 15 digits   *
      *            (Recompile)                                        *
      *  MD035213 - Component GLC3320T4 failed on program GL3320T4    *
      *             due to empty REACRZ.                              *
      *  MD024688 - GLC3320T4 00001 failed during COB                 *
      *  CGL142 - Tactical COB changes GL                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Function of indicators                                       *
      *  ----------------------                                       *
      *                                                               *
      *     99 - Indicator for read                                   *
      *                                                               *
      *  U7+U8 - Database error                                       *
      *                                                               *
      *****************************************************************
      *
     FABEXZY    UF   E             DISK    INFSR(*PSSR) COMMIT
     F                                     PREFIX(ZY_)
     FGLABEXZY  IF   E             DISK    INFSR(*PSSR)
 
     FSTMTZX    UF   E             DISK    INFSR(*PSSR) COMMIT
     F                                     PREFIX(ST_)
     FGLSTMTZX  IF   E             DISK    INFSR(*PSSR)
 
     FACCNTAC   UF   E             DISK    INFSR(*PSSR) COMMIT
     F                                     PREFIX(AC_)
     FGLACC2AC  IF   E             DISK    INFSR(*PSSR)
 
     FREACRZ    UF   E             DISK    INFSR(*PSSR) COMMIT
     F                                     PREFIX(RE_)
     FGLREACRZ  IF   E             DISK    INFSR(*PSSR)
 
      ** Local data area for database error details
     D LDA           E DS           256    EXTNAME(LDA)
     D MMOD          E DS           256    EXTNAME(MMOD)                                    MD035213
 
      ** Program Status Data Structure
     D PSDS           SDS
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
 
      ** Program Variables
     D TotVlrf2        S             18  0
     D*TotVlrf**       S             18  0                                                  MD024688
     D TotVlrf         S             19  0                                                  MD024688
     D TotChrf2        S             18  0
     D*TotChrf**       S             18  0                                                  MD024688
     D TotChrf         S             19  0                                                  MD024688
     D TotNore         S              5  0
     D TotNret         S              5  0
 
      ** Main Processing
 
     C                   Z-ADD     0             TotVlrf2
     C                   Z-ADD     0             TotVlrf
     C                   Z-ADD     0             TotChrf2
     C                   Z-ADD     0             TotChrf
     C                   Z-ADD     0             TotNore
     C     *Dtaara       DEFINE                  MMOD                                       MD035213
     C                   IN        MMOD                                                     MD035213
 
      ** Process GLABEXZY and update ABEXZY
 
     C                   READ      GLABEXZY                               99
 
     C                   DOW       *IN99 = *OFF
 
     C     NORE          ADD       TOTNORE       TOTNORE
     C                   EVAL      TotVlrf = TotVlrf + (DHWN * 1000) + DHDC
     C                   EVAL      TotChrf = TotChrf + (CHWN * 1000) + CHDC
 
     C                   READ      GLABEXZY                               99
     C                   ENDDO
 
     C     1             CHAIN     ABEXZY                             99
     C                   IF        *IN99 = *ON
     C                   MOVE      'ABEXZY '     DBFILE
     C                   Z-ADD     001           DBASE
     C                   EXSR      *PSSR
     C                   ELSE
     C     TOTNORE       ADD       ZY_NORE       ZY_NORE
 
     C                   EVAL      TotVlrf2 = (ZY_DHWN * 1000) + ZY_DHDC
     C     TOTVLRF       ADD       TOTVLRF2      TOTVLRF2
     C                   EVAL      ZY_DHWN = (TotVlrf2 / 1000)
     C                   EVAL      ZY_DHDC = TotVlrf2 - (ZY_DHWN * 1000)
 
     C                   EVAL      TotChrf2 = (ZY_CHWN * 1000) + ZY_CHDC
     C     TOTCHRF       ADD       TOTCHRF2      TOTCHRF2
     C                   EVAL      ZY_CHWN = (TotChrf2 / 1000)
     C                   EVAL      ZY_CHDC = TotChrf2 - (ZY_CHWN * 1000)
 
     C                   UPDATE    ABEXZYF
 
     C                   ENDIF
 
      ** Process GLSTMTZX and update STMTZX
 
     C                   Z-ADD     0             TotNore
     C                   READ      GLSTMTZX                               99
     C                   DOW       *IN99 = *OFF
     C     NORE1         ADD       TOTNORE       TOTNORE
     C                   READ      GLSTMTZX                               99
     C                   ENDDO
 
     C     1             CHAIN     STMTZX                             99
     C                   IF        *IN99 = *ON
     C                   MOVE      'STMTZX '     DBFILE
     C                   Z-ADD     002           DBASE
     C                   EXSR      *PSSR
     C                   ELSE
     C     TOTNORE       ADD       ST_NORE1      ST_NORE1
     C                   UPDATE    STMTZXF
     C                   ENDIF
 
      ** Process GLACC2AC and update ACCNTAC
 
     C                   Z-ADD     0             TotNore
     C                   Z-ADD     0             TotNret
 
     C                   READ      GLACC2AC                               99
     C                   DOW       *IN99 = *OFF
 
     C     NODROP        ADD       TOTNORE       TOTNORE
     C     REDROP        ADD       TOTNRET       TOTNRET
 
     C                   READ      GLACC2AC                               99
     C                   ENDDO
 
     C     1             CHAIN     ACCNTAC                            99
     C                   IF        *IN99 = *ON
     C                   MOVE      'ACCNTAC'     DBFILE
     C                   Z-ADD     003           DBASE
     C                   EXSR      *PSSR
     C                   ELSE
 
     C                   IF        AC_NORE >= TotNore
     C     AC_NORE       SUB       TOTNORE       AC_NORE
     C                   ELSE
     C                   EVAL      AC_NORE = 100000 + AC_NORE - TotNore
     C                   ENDIF
     C                   IF        AC_NRET >= TotNret
     C     AC_NRET       SUB       TOTNRET       AC_NRET
     C                   ELSE
     C                   EVAL      AC_NRET = 100000 + AC_NRET - TotNret
     C                   ENDIF
 
     C                   UPDATE    ACCNTACF
     C                   ENDIF
 
      ** Process GLREACRZ and update REACRZ
 
     C                   Z-ADD     0             TotNore
     C                   READ      GLREACRZ                               99
     C                   DOW       *IN99 = *OFF
     C     NORE          ADD       TOTNORE       TOTNORE
     C                   READ      GLREACRZ                               99
     C                   ENDDO
 
     C                   IF        RT = 'Y'                                                 MD035213
     C     1             CHAIN     REACRZ                             99
     C                   IF        *IN99 = *ON
     C                   MOVE      'REACRZ '     DBFILE
     C                   Z-ADD     004           DBASE
     C                   EXSR      *PSSR
     C                   ELSE
     C     RE_NORE       SUB       TOTNORE       RE_NORE
     C                   UPDATE    REACRZF
     C                   ENDIF
     C                   ENDIF                                                              MD035213
 
     C                   COMMIT
 
     C                   SETON                                        LR
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
