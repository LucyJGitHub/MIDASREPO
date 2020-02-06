     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2007')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Utility program to update GTEESZZ')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00092 - Utiliity Program To Update GTEESZZ                *
      *                                                               *
      *  Function:  This utility program counts the amount of records *
      *  in GTEESGT and updates the trailer record if it is wrong.    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. BG26993            Date 26Jan10               *
      *                 165426  *CREATE    Date 14Oct99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BG26993 - Delivery of upgrade programs to core.              *
      *          - Renamed program S16542601.                         *
      *  165426  - Run this utility to update GTEESZZ when the fix is *
      *            applied to LE programs.                            *
      *                                                               *
      *****************************************************************
0020 F* ID F  C  H  L    FUNCTION OF INDICATORS
0021 F*    90         GTEES  - END OF FILE
0021 F*    91         RUNDAT - Error reading
0021 F*    92         GTEESGT- Error reading
0021 F*    93         GTEESZZ- Error reading
     FGTEESGT   IF   E             DISK
     FGTEESZZ   UF   E             DISK
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
     D TotNumRec       S              5P 0
     D NumDetAIC       S              5P 0
     D NumInsAIC       S              5P 0
     D NumDelAIC       S              5P 0
     D NumDetBIC       S              5P 0
     D WrkTot          S             13P 0
      *
     D                 DS
     D  AmtDetAIC              1     13  0 inz(*ZEROS)
     D  WhlDetAIC              1     10  0
     D  DecDetAIC             11     13  0
      *
     D                 DS
     D  AmtDelAIC              1     13  0 inz(*zeros)
     D  WhlDelAIC              1     10  0
     D  DecDelAIC             11     13  0
      *
     D                 DS
     D  AmtInsAIC              1     13  0 inz(*zeros)
     D  WhlInsAIC              1     10  0
     D  DecInsAIC             11     13  0
      *
     D                 DS
     D  AmtDetBIC              1     13  0 inz(*zeros)
     D  WhlDetBIC              1     10  0
     D  DecDetBIC             11     13  0
      *
      /EJECT
      *
      ** Read in Installation Data
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT                               91
     C     *IN91         IFEQ      *ON                                          Error
     C                   SETON                                        U7U8
     C                   GOTO      GETOUT
     C                   ENDIF
      *
      ** Main routine
      *
     C     1             SETLL     GTEESGT
B01  C     *IN90         DOWEQ     *OFF
     C                   READ      GTEESGT                              9290
     C     *IN92         IFEQ      *ON                                          Error
     C                   SETON                                        U7U8
     C                   GOTO      GETOUT
     C                   ENDIF
      *
      *
B02  C     *IN90         IFEQ      *OFF
      *
      ** Accumulate the amounts of all records on the file
      *
     C                   ADD       1             TotNumRec
      *
      ** Accumulate the amounts of all the detail records
      *
B03  C     RECI          IFEQ      'D'
     C                   ADD       UAMT          AmtDetAIC
     C                   ADD       1             NumDetAIC
      *
      ** Accumulate the amounts of all the inserted records
      *
B04  C     LCD           IFEQ      AGRDNB
     C     CHTP          ANDEQ     'I'
     C                   ADD       UAMT          AmtInsAIC
     C                   ADD       1             NumInsAIC
E04  C                   ENDIF
      *
E03  C                   ENDIF
      *
      ** Accumulate the amounts of all the deleted records
      *
B03  C     RECI          IFEQ      '*'
     C                   ADD       UAMT          AmtDelAIC
     C                   ADD       1             NumDelAIC
E03  C                   ENDIF
E02  C                   ENDIF
      *
E01  C                   ENDDO
      *
      ** Add 2 to the total number of records to take into account the
      ** header and trailer
      *
     C     TotNumRec     ADD       2             TotNumRec
      *
      ** Calculate the value of records before input cycle including
      ** any amounts due to changes because of amendments
      *
     C     AmtDetAIC     SUB       AmtInsAIC     WrkTot
     C     WrkTot        ADD       AmtDelAIC     AmtDetBIC
      *
      ** Calculate the number of records before input cycle
      *
     C                   Z-ADD     *Zero         WrkTot
     C     NumDetAIC     SUB       NumInsAIC     WrkTot
     C     WrkTot        ADD       NumDelAIC     NumDetBIC
      *
      ** Update GTEESZZ with calculated values
      *
     C                   READ      GTEESZZ                              9390
     C     *IN93         IFEQ      *ON                                          Error
     C                   SETON                                        U7U8
     C                   GOTO      GETOUT
     C                   ENDIF
     C     *IN90         IFEQ      *OFF
      *
     C                   Z-ADD     TotNumRec     NORE
     C                   Z-ADD     NumDetBIC     NLRB
     C                   Z-ADD     NumInsAIC     NINS
     C                   Z-ADD     NumDelAIC     NDEL
     C                   Z-ADD     NumDetAIC     NLRA
     C                   Z-ADD     WhlDetBIC     VLBF
     C                   Z-ADD     DecDetBIC     VLBL
     C                   Z-ADD     WhlInsAIC     VRIF
     C                   Z-ADD     DecInsAIC     VRIL
     C                   Z-ADD     WhlDelAIC     VRDF
     C                   Z-ADD     DecDelAIC     VRDL
     C                   Z-ADD     0             VRAF
     C                   Z-ADD     0             VRAL
     C                   Z-ADD     WhlDetAIC     VLAF
     C                   Z-ADD     DecDetAIC     VLAL
      *
     C                   UPDATE    GTEESZZF                             94
     C     *IN94         IFEQ      *ON                                          Error
     C                   SETON                                        U7U8
     C                   ENDIF
     C                   ENDIF
      *
     C     GETOUT        TAG
      *
     C                   SETON                                        LR
     C                   RETURN
      *
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
