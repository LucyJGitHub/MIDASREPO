     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Update LEFHST (HIFRTn & HIAMTn): 240668')     *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00103 - Update PF/LEFHST                                  *
      *                                                               *
      *  Function:  This program updates rates and amount fields      *
      *             (HIFRTn and HIAMTn) of LEFHST to reflect the      *
      *             rates and amounts specific to a fee period.       *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BG26993            Date 26Jan10               *
      *                 240668A            Date 25Sep06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  BG26993 - Delivery of upgrade programs to core.              *
      *          - Renamed program S240668R01.                        *
      *  240668A - Added formatting of fields for LEFHST update.      *
      *  240668 - Initialised HIFRTn and HIAMTn on PF/LEFHST to       *
      *           complete fix for BUG8762 which applied 209513.      *
      *           HIFRTn and HIAMTn contains amounts and rates for    *
      *           each fee period from fee start date.                *
      *           HIFRTn and HIAMTn were inserted to be used in       *
      *           calculating fee accruals of previous periods.       *
      *           Patterned after utility UTCLE149 for 209513.        *
      *                                                               *
      *****************************************************************
     FLEFEED    IF   E           K DISK
     FSMU005PD  UF   E           K DISK
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   80  - LEFEED EOF                                            *
      *   90  - TLEFHST EOF                                           *
      *                                                               *
      *****************************************************************
     D/COPY ZSRSRC,ZDATE2Z1LE
      ** Fee amounts data structure                                                          240668A
     D                 DS                                                                    240668A
     D  FAMT                   1     30P 0                                                   240668A
     D                                     DIM(5) ASCEND                        FEE AMOUNTS  240668A
     D  FEAMT1                 1      6P 0                                                   240668A
     D  FEAMT2                 7     12P 0                                                   240668A
     D  FEAMT3                13     18P 0                                                   240668A
     D  FEAMT4                19     24P 0                                                   240668A
     D  FEAMT5                25     30P 0                                                   240668A
      *                                                                                      240668A
     D                 DS                                                                    240668A
      ** Fee rates data structure                                                            240668A
     D  FRT                    1     20P 5                                                   240668A
     D                                     DIM(5) ASCEND                        FEE RATES    240668A
     D  FEFRT1                 1      4P 5                                                   240668A
     D  FEFRT2                 5      8P 5                                                   240668A
     D  FEFRT3                 9     12P 5                                                   240668A
     D  FEFRT4                13     16P 5                                                   240668A
     D  FEFRT5                17     20P 5                                                   240668A
     D                 DS                                                                    240668A
      ** Fee amounts data structure                                                          240668A
     D  HAMT                   1     30P 0                                                   240668A
     D                                     DIM(5) ASCEND                        FEE AMOUNTS -240668A
     D  HIAMT1                 1      6P 0                                                   240668A
     D  HIAMT2                 7     12P 0                                                   240668A
     D  HIAMT3                13     18P 0                                                   240668A
     D  HIAMT4                19     24P 0                                                   240668A
     D  HIAMT5                25     30P 0                                                   240668A
      *                                                                                      240668A
     D                 DS                                                                    240668A
      ** Fee rates data structure                                                            240668A
     D  HRT                    1     20P 5                                                   240668A
     D                                     DIM(5) ASCEND                        FEE RATES - H240668A
     D  HIFRT1                 1      4P 5                                                   240668A
     D  HIFRT2                 5      8P 5                                                   240668A
     D  HIFRT3                 9     12P 5                                                   240668A
     D  HIFRT4                13     16P 5                                                   240668A
     D  HIFRT5                17     20P 5                                                   240668A
      *
      ** Bank details and rundate
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** Parameter entry
      *
     C     *ENTRY        PLIST
     C                   PARM                    MODE              1
      *
     C     LEFHKY        KLIST
     C                   KFLD                    FECNUM
     C                   KFLD                    FEFACL
     C                   KFLD                    FEFSEQ
     C                   KFLD                    FELOAN
      *
      ** Access bank details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C                   MOVE      *OFF          *IN98
      *
      ** Read Lending Fee Master Detail File.
      *
     C     *LOVAL        SETLL     LEFEED
     C                   READ      LEFEED                                 80
     C     *IN80         DOWEQ     '0'
     C                   EXSR      UPDFEH
     C                   READ      LEFEED                                 80
     C                   ENDDO
      *
     C                   MOVE      *ON           *INLR
     C                   RETURN
      /EJECT
      *****************************************************************
      *  UPDFEH - Update lending fee history file LEFHST.             *
      *  Called from:  Main Processing                                *
      *  Calls: WRTRPT                                                *
      *****************************************************************
     C     UPDFEH        BEGSR
      *
     C     LEFHKY        SETLL     SMU005PD
     C     LEFHKY        READE     SMU005PD                               90
     C     *IN90         DOWEQ     '0'
     C                   Z-ADD     FRT           HRT
     C                   Z-ADD     FAMT          HAMT
     C                   UPDATE    LEFHSTF
     C     LEFHKY        READE     SMU005PD                               90
     C                   ENDDO
     C                   UNLOCK    SMU005PD
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program Error Processing Subroutine                 *
      *                                                               *
      *  Called By: Various                                           *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
      * Check to see that *PSSR has not already been called.
     C     *INLR         IFNE      *ON
     C                   EVAL      *INLR = *ON
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   DUMP
     C                   ENDIF
      *
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
     C/COPY ZSRSRC,ZDATE2Z2LE
**   ZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
0366073110961461
**   ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
000031059090120151181212243273304334365
**   ZMNM - MONTHS SHORT NAMES
JanFebMarAprMayJunJulAugSepOctNovDec
