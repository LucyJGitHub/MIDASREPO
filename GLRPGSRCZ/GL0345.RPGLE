     H DEBUG
      *****************************************************************
/*S*D ***RPGBASE*******************************************************                     MD021155
/*STD *  RPGBASEBND                                                   *                     MD021155
/*EXI *  TEXT('Midas GL Generated entries audit report - GL/RE')      *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL0345  -  Generated Entries audit report - GL/RE            *
      *                                                               *
      *  Function:  This program compares the number/value of         *
      *             postings on the COB Generated Entries files       *
      *             against the hash totals on the trailer files,     *
      *             listing all the totals and printing DIFFERENCE    *
      *             against any files which do not tally.             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. MD021155           Date 17Jul13               *
      *  Prev Amend No. AR722462           Date 10Jun11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CAP204             Date 10Feb10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *                 153640  *CREATE    Date 26Jan99               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD021155 - COB Restructure Phase 1 Remnants                  *
      *           - CGL120 changes not done                           *
      *  AR722462 - Add GESPPD and GESP2PD in the report              *
      *             (Child:AR722468)                                  *
      *  CAP204 - Retail Account Transfer                             *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  156640 - New file.                                           *
      *                                                               *
      *****************************************************************
     FCLEARPD   IF   E             DISK
     F                                     RENAME(APOSTPDF:CLEARPDF)
     FCLEARZZ   IF   E             DISK
     F                                     RENAME(APOSTZZF:CLEARZZF)
     FCLEAROPD  IF   E             DISK
     F                                     RENAME(APOSTPDF:CLEAROPF)
     FCLEAROZZ  IF   E             DISK
     F                                     RENAME(APOSTZZF:CLEAROZF)
     FCLEAR2PD  IF   E             DISK
     F                                     RENAME(APOSTPDF:CLEAR2PF)
     FCLEAR2ZZ  IF   E             DISK
     F                                     RENAME(APOSTZZF:CLEAR2ZF)
     FGECEPD    IF   E             DISK
     F                                     RENAME(APOSTPDF:GECEPDF)
     FGECEZZ    IF   E             DISK
     F                                     RENAME(APOSTZZF:GECEZZF)
     FGEFAPD    IF   E             DISK
     F                                     RENAME(APOSTPDF:GEFAPDF)
     FGEFAZZ    IF   E             DISK
     F                                     RENAME(APOSTZZF:GEFAZZF)
     FGEFRPD    IF   E             DISK
     F                                     RENAME(APOSTPDF:GEFRPDF)
     FGEFRZZ    IF   E             DISK
     F                                     RENAME(APOSTZZF:GEFRZZF)
     FGEHMPD    IF   E             DISK
     F                                     RENAME(APOSTPDF:GEHMPDF)
     FGEHMZZ    IF   E             DISK
     F                                     RENAME(APOSTZZF:GEHMZZF)
     FGEHM2PD   IF   E             DISK
     F                                     RENAME(APOSTPDF:GEHM2PDF)
     FGEHM2ZZ   IF   E             DISK
     F                                     RENAME(APOSTZZF:GEHM2ZZF)
     FGEICPD    IF   E             DISK
     F                                     RENAME(APOSTPDF:GEICPDF)
     FGEICZZ    IF   E             DISK
     F                                     RENAME(APOSTZZF:GEICZZF)
     FGEIC2PD   IF   E             DISK
     F                                     RENAME(APOSTPDF:GEIC2PDF)
     FGEIC2ZZ   IF   E             DISK
     F                                     RENAME(APOSTZZF:GEIC2ZZF)
     FGEIERPD   IF   E             DISK
     F                                     RENAME(APOSTPDF:GEIERPDF)
     FGEIERZZ   IF   E             DISK
     F                                     RENAME(APOSTZZF:GEIERZZF)
     FGEIER2PD  IF   E             DISK
     F                                     RENAME(APOSTPDF:GEIER2PF)
     FGEIER2ZZ  IF   E             DISK
     F                                     RENAME(APOSTZZF:GEIER2ZF)
     FGENAPD    IF   E             DISK
     F                                     RENAME(APOSTPDF:GENAPDF)
     FGENAZZ    IF   E             DISK
     F                                     RENAME(APOSTZZF:GENAZZF)
     FGENA2PD   IF   E             DISK
     F                                     RENAME(APOSTPDF:GENA2PDF)
     FGENA2ZZ   IF   E             DISK
     F                                     RENAME(APOSTZZF:GENA2ZZF)
     FGEPCPD    IF   E             DISK
     F                                     RENAME(APOSTPDF:GEPCPDF)
     FGEPCZZ    IF   E             DISK
     F                                     RENAME(APOSTZZF:GEPCZZF)
     FGEPC2PD   IF   E             DISK
     F                                     RENAME(APOSTPDF:GEPC2PDF)
     FGEPC2ZZ   IF   E             DISK
     F                                     RENAME(APOSTZZF:GEPC2ZZF)
     FGESFPD    IF   E             DISK
     F                                     RENAME(APOSTPDF:GESFPDF)
     FGESFZZ    IF   E             DISK
     F                                     RENAME(APOSTZZF:GESFZZF)
     FGESOPD    IF   E             DISK
     F                                     RENAME(APOSTPDF:GESOPDF)
     FGESOZZ    IF   E             DISK
     F                                     RENAME(APOSTZZF:GESOZZF)
     FGESRPD    IF   E             DISK
     F                                     RENAME(APOSTPDF:GESRPDF)
     FGESRZZ    IF   E             DISK
     F                                     RENAME(APOSTZZF:GESRZZF)
     FGEXBPD    IF   E             DISK
     F                                     RENAME(APOSTPDF:GEXBPDF)
     FGEXBZZ    IF   E             DISK
     F                                     RENAME(APOSTZZF:GEXBZZF)
     FGEXFPD    IF   E             DISK
     F                                     RENAME(APOSTPDF:GEXFPDF)
     FGEXFZZ    IF   E             DISK
     F                                     RENAME(APOSTZZF:GEXFZZF)
     FMANPOPD   IF   E             DISK
     F                                     RENAME(APOSTPDF:MANPOPDF)
     FMANPOZZ   IF   E             DISK
     F                                     RENAME(APOSTZZF:MANPOZZF)
     FGETXPD    IF   E             DISK                                                       CAP204
     F                                     RENAME(APOSTPDF:GETXPDF)                           CAP204
     FGETXZZ    IF   E             DISK                                                       CAP204
     F                                     RENAME(APOSTZZF:GETXZZF)                           CAP204
     FGESPPD    IF   E             DISK                                                     AR722462
     F                                     RENAME(APOSTPDF:GESPPDF)                         AR722462
     FGESP2PD   IF   E             DISK                                                     AR722462
     F                                     RENAME(APOSTPDF:GESP2PDF)                        AR722462
     FGESPZZ    IF   E             DISK                                                     AR722462
     F                                     RENAME(APOSTZZF:GESPZZF)                         AR722462
     FGL0345AU  O    E             PRINTER INFDS(SPOOLU)
      *
     D**********          FILE@   1  24 40                                                  AR722462
     D FILE@           S             40    DIM(25) CTDATA PERRCD(1)                         AR722462
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** Array containing Copyright statement
      *
      /SPACE 3
     D SPOOLU          DS
     D  LINE                 367    368B 0
      *
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
      *
     D PSDS           SDS
      *
      ** Program Status Data Structure
      *
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
     D**   MIDAS MOD FLAGS
     D*
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D**   BANK DETAILS
     D*
     D DSFDY         E DS                  EXTNAME(DSFDY)
     I** First DS for Access Programs, Short Data Structure
      *
      *
     C     FIRST         IFNE      'Y'
     C                   EXSR      INIT
     C                   MOVE      'Y'           FIRST             1
     C                   END
      *
     C                   EXSR      MAIN
      *
     C                   SETON                                        LR
     C                   RETURN
      *
      *****************************************************************
      *                                                               *
      * DEAL   - Process dealing files                                *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     MAIN          BEGSR                                                  ** MAIN SR **
      *
      *********************
      ** ( 1)  CLEARPD   **
      *********************
     C                   READ      CLEARPD                              1011
     C     *IN10         IFEQ      *ON
     C                   MOVE      'CLEARPD '    FILNAM            8
     C                   EXSR      *PSSR
     C                   END
     C                   Z-ADD     0             FPSTA            18 0
     C                   Z-ADD     0             FNORE             5 0
     C     *IN11         DOWEQ     *OFF
     C                   ADD       PSTA          FPSTA
     C                   ADD       1             FNORE
     C                   READ      CLEARPD                                11
     C                   ENDDO
      *
     C                   READ      CLEARZZ                                12
     C     *IN12         IFEQ      *ON
     C                   Z-ADD     0             TPSTA            18 0
     C                   Z-ADD     0             TNORE             5 0
     C                   ELSE
     C     HRWN          MULT      1000          #WRK18           18 0
     C     #WRK18        ADD       HRDC          TPSTA
     C     NORE1         SUB       2             TNORE
     C                   END
      *
     C                   MOVE      *BLANKS       TEXT
     C                   MOVE      FILE@(1)      TEXT
     C                   EXSR      PRTDET
      *
      *********************
      ** ( 2)  CLEAROPD  **
      *********************
     C                   READ      CLEAROPD                             1011
     C     *IN10         IFEQ      *ON
     C                   MOVE      'CLEAROPD'    FILNAM            8
     C                   EXSR      *PSSR
     C                   END
     C                   Z-ADD     0             FPSTA            18 0
     C                   Z-ADD     0             FNORE             5 0
     C     *IN11         DOWEQ     *OFF
     C                   ADD       PSTA          FPSTA
     C                   ADD       1             FNORE
     C                   READ      CLEAROPD                               11
     C                   ENDDO
      *
     C                   READ      CLEAROZZ                               12
     C     *IN12         IFEQ      *ON
     C                   Z-ADD     0             TPSTA            18 0
     C                   Z-ADD     0             TNORE             5 0
     C                   ELSE
     C     HRWN          MULT      1000          #WRK18           18 0
     C     #WRK18        ADD       HRDC          TPSTA
     C     NORE1         SUB       2             TNORE
     C                   END
      *
     C                   MOVE      *BLANKS       TEXT
     C                   MOVE      FILE@(2)      TEXT
     C                   EXSR      PRTDET
      *
      *********************
      ** ( 3)  CLEAR2PD  **
      *********************
     C                   READ      CLEAR2PD                             1011
     C     *IN10         IFEQ      *ON
     C                   MOVE      'CLEAR2PD'    FILNAM            8
     C                   EXSR      *PSSR
     C                   END
     C                   Z-ADD     0             FPSTA            18 0
     C                   Z-ADD     0             FNORE             5 0
     C     *IN11         DOWEQ     *OFF
     C                   ADD       PSTA          FPSTA
     C                   ADD       1             FNORE
     C                   READ      CLEAR2PD                               11
     C                   ENDDO
      *
     C                   READ      CLEAR2ZZ                               12
     C     *IN12         IFEQ      *ON
     C                   Z-ADD     0             TPSTA            18 0
     C                   Z-ADD     0             TNORE             5 0
     C                   ELSE
     C     HRWN          MULT      1000          #WRK18           18 0
     C     #WRK18        ADD       HRDC          TPSTA
     C     NORE1         SUB       2             TNORE
     C                   END
      *
     C                   MOVE      *BLANKS       TEXT
     C                   MOVE      FILE@(3)      TEXT
     C                   EXSR      PRTDET
      *
      *********************
      ** ( 4)  GECEPD    **
      *********************
     C                   READ      GECEPD                               1011
     C     *IN10         IFEQ      *ON
     C                   MOVE      'GECEPD  '    FILNAM            8
     C                   EXSR      *PSSR
     C                   END
     C                   Z-ADD     0             FPSTA            18 0
     C                   Z-ADD     0             FNORE             5 0
     C     *IN11         DOWEQ     *OFF
     C                   ADD       PSTA          FPSTA
     C                   ADD       1             FNORE
     C                   READ      GECEPD                                 11
     C                   ENDDO
      *
     C                   READ      GECEZZ                                 12
     C     *IN12         IFEQ      *ON
     C                   Z-ADD     0             TPSTA            18 0
     C                   Z-ADD     0             TNORE             5 0
     C                   ELSE
     C     HRWN          MULT      1000          #WRK18           18 0
     C     #WRK18        ADD       HRDC          TPSTA
     C     NORE1         SUB       2             TNORE
     C                   END
      *
     C                   MOVE      *BLANKS       TEXT
     C                   MOVE      FILE@(4)      TEXT
     C                   EXSR      PRTDET
      *
      *
      *********************
      ** ( 5)  GEFAPD    **
      *********************
     C                   READ      GEFAPD                               1011
     C     *IN10         IFEQ      *ON
     C                   MOVE      'GEFAPD  '    FILNAM            8
     C                   EXSR      *PSSR
     C                   END
     C                   Z-ADD     0             FPSTA            18 0
     C                   Z-ADD     0             FNORE             5 0
     C     *IN11         DOWEQ     *OFF
     C                   ADD       PSTA          FPSTA
     C                   ADD       1             FNORE
     C                   READ      GEFAPD                                 11
     C                   ENDDO
      *
     C                   READ      GEFAZZ                                 12
     C     *IN12         IFEQ      *ON
     C                   Z-ADD     0             TPSTA            18 0
     C                   Z-ADD     0             TNORE             5 0
     C                   ELSE
     C     HRWN          MULT      1000          #WRK18           18 0
     C     #WRK18        ADD       HRDC          TPSTA
     C     NORE1         SUB       2             TNORE
     C                   END
      *
     C                   MOVE      *BLANKS       TEXT
     C                   MOVE      FILE@(5)      TEXT
     C                   EXSR      PRTDET
      *
      *********************
      ** ( 6)  GEFRPD    **
      *********************
     C                   READ      GEFRPD                               1011
     C     *IN10         IFEQ      *ON
     C                   MOVE      'GEFRPD  '    FILNAM            8
     C                   EXSR      *PSSR
     C                   END
     C                   Z-ADD     0             FPSTA            18 0
     C                   Z-ADD     0             FNORE             5 0
     C     *IN11         DOWEQ     *OFF
     C                   ADD       PSTA          FPSTA
     C                   ADD       1             FNORE
     C                   READ      GEFRPD                                 11
     C                   ENDDO
      *
     C                   READ      GEFRZZ                                 12
     C     *IN12         IFEQ      *ON
     C                   Z-ADD     0             TPSTA            18 0
     C                   Z-ADD     0             TNORE             5 0
     C                   ELSE
     C     HRWN          MULT      1000          #WRK18           18 0
     C     #WRK18        ADD       HRDC          TPSTA
     C     NORE1         SUB       2             TNORE
     C                   END
      *
     C                   MOVE      *BLANKS       TEXT
     C                   MOVE      FILE@(6)      TEXT
     C                   EXSR      PRTDET
      *
      *********************
      ** ( 7)  GEHMPD    **
      *********************
     C                   READ      GEHMPD                               1011
     C     *IN10         IFEQ      *ON
     C                   MOVE      'GEHMPD  '    FILNAM            8
     C                   EXSR      *PSSR
     C                   END
     C                   Z-ADD     0             FPSTA            18 0
     C                   Z-ADD     0             FNORE             5 0
     C     *IN11         DOWEQ     *OFF
     C                   ADD       PSTA          FPSTA
     C                   ADD       1             FNORE
     C                   READ      GEHMPD                                 11
     C                   ENDDO
      *
     C                   READ      GEHMZZ                                 12
     C     *IN12         IFEQ      *ON
     C                   Z-ADD     0             TPSTA            18 0
     C                   Z-ADD     0             TNORE             5 0
     C                   ELSE
     C     HRWN          MULT      1000          #WRK18           18 0
     C     #WRK18        ADD       HRDC          TPSTA
     C     NORE1         SUB       2             TNORE
     C                   END
      *
     C                   MOVE      *BLANKS       TEXT
     C                   MOVE      FILE@(7)      TEXT
     C                   EXSR      PRTDET
      *
      *********************
      ** ( 8)  GEHM2PD   **
      *********************
     C                   READ      GEHM2PD                              1011
     C     *IN10         IFEQ      *ON
     C                   MOVE      'GEHM2PD '    FILNAM            8
     C                   EXSR      *PSSR
     C                   END
     C                   Z-ADD     0             FPSTA            18 0
     C                   Z-ADD     0             FNORE             5 0
     C     *IN11         DOWEQ     *OFF
     C                   ADD       PSTA          FPSTA
     C                   ADD       1             FNORE
     C                   READ      GEHM2PD                                11
     C                   ENDDO
      *
     C                   READ      GEHM2ZZ                                12
     C     *IN12         IFEQ      *ON
     C                   Z-ADD     0             TPSTA            18 0
     C                   Z-ADD     0             TNORE             5 0
     C                   ELSE
     C     HRWN          MULT      1000          #WRK18           18 0
     C     #WRK18        ADD       HRDC          TPSTA
     C     NORE1         SUB       2             TNORE
     C                   END
      *
     C                   MOVE      *BLANKS       TEXT
     C                   MOVE      FILE@(8)      TEXT
     C                   EXSR      PRTDET
      *
      *********************
      ** ( 9)  GEICPD    **
      *********************
     C                   READ      GEICPD                               1011
     C     *IN10         IFEQ      *ON
     C                   MOVE      'GEICPD  '    FILNAM            8
     C                   EXSR      *PSSR
     C                   END
     C                   Z-ADD     0             FPSTA            18 0
     C                   Z-ADD     0             FNORE             5 0
     C     *IN11         DOWEQ     *OFF
     C                   ADD       PSTA          FPSTA
     C                   ADD       1             FNORE
     C                   READ      GEICPD                                 11
     C                   ENDDO
      *
     C                   READ      GEICZZ                                 12
     C     *IN12         IFEQ      *ON
     C                   Z-ADD     0             TPSTA            18 0
     C                   Z-ADD     0             TNORE             5 0
     C                   ELSE
     C     HRWN          MULT      1000          #WRK18           18 0
     C     #WRK18        ADD       HRDC          TPSTA
     C     NORE1         SUB       2             TNORE
     C                   END
      *
     C                   MOVE      *BLANKS       TEXT
     C                   MOVE      FILE@(9)      TEXT
     C                   EXSR      PRTDET
      *
      *********************
      ** (10)  GEIC2PD   **
      *********************
     C                   READ      GEIC2PD                              1011
     C     *IN10         IFEQ      *ON
     C                   MOVE      'GEIC2PD '    FILNAM            8
     C                   EXSR      *PSSR
     C                   END
     C                   Z-ADD     0             FPSTA            18 0
     C                   Z-ADD     0             FNORE             5 0
     C     *IN11         DOWEQ     *OFF
     C                   ADD       PSTA          FPSTA
     C                   ADD       1             FNORE
     C                   READ      GEIC2PD                                11
     C                   ENDDO
      *
     C                   READ      GEIC2ZZ                                12
     C     *IN12         IFEQ      *ON
     C                   Z-ADD     0             TPSTA            18 0
     C                   Z-ADD     0             TNORE             5 0
     C                   ELSE
     C     HRWN          MULT      1000          #WRK18           18 0
     C     #WRK18        ADD       HRDC          TPSTA
     C     NORE1         SUB       2             TNORE
     C                   END
      *
     C                   MOVE      *BLANKS       TEXT
     C                   MOVE      FILE@(10)     TEXT
     C                   EXSR      PRTDET
      *
      *********************
      ** (11)  GEIERPD   **
      *********************
     C                   READ      GEIERPD                              1011
     C     *IN10         IFEQ      *ON
     C                   MOVE      'GEIERPD '    FILNAM            8
     C                   EXSR      *PSSR
     C                   END
     C                   Z-ADD     0             FPSTA            18 0
     C                   Z-ADD     0             FNORE             5 0
     C     *IN11         DOWEQ     *OFF
     C                   ADD       PSTA          FPSTA
     C                   ADD       1             FNORE
     C                   READ      GEIERPD                                11
     C                   ENDDO
      *
     C                   READ      GEIERZZ                                12
     C     *IN12         IFEQ      *ON
     C                   Z-ADD     0             TPSTA            18 0
     C                   Z-ADD     0             TNORE             5 0
     C                   ELSE
     C     HRWN          MULT      1000          #WRK18           18 0
     C     #WRK18        ADD       HRDC          TPSTA
     C     NORE1         SUB       2             TNORE
     C                   END
      *
     C                   MOVE      *BLANKS       TEXT
     C                   MOVE      FILE@(11)     TEXT
     C                   EXSR      PRTDET
      *
      *********************
      ** (12)  GEIER2PD  **
      *********************
     C                   READ      GEIER2PD                             1011
     C     *IN10         IFEQ      *ON
     C                   MOVE      'GEIER2PD'    FILNAM            8
     C                   EXSR      *PSSR
     C                   END
     C                   Z-ADD     0             FPSTA            18 0
     C                   Z-ADD     0             FNORE             5 0
     C     *IN11         DOWEQ     *OFF
     C                   ADD       PSTA          FPSTA
     C                   ADD       1             FNORE
     C                   READ      GEIER2PD                               11
     C                   ENDDO
      *
     C                   READ      GEIER2ZZ                               12
     C     *IN12         IFEQ      *ON
     C                   Z-ADD     0             TPSTA            18 0
     C                   Z-ADD     0             TNORE             5 0
     C                   ELSE
     C     HRWN          MULT      1000          #WRK18           18 0
     C     #WRK18        ADD       HRDC          TPSTA
     C     NORE1         SUB       2             TNORE
     C                   END
      *
     C                   MOVE      *BLANKS       TEXT
     C                   MOVE      FILE@(12)     TEXT
     C                   EXSR      PRTDET
      *
      *********************
      ** (13)  GENAPD    **
      *********************
     C                   READ      GENAPD                               1011
     C     *IN10         IFEQ      *ON
     C                   MOVE      'GENAPD  '    FILNAM            8
     C                   EXSR      *PSSR
     C                   END
     C                   Z-ADD     0             FPSTA            18 0
     C                   Z-ADD     0             FNORE             5 0
     C     *IN11         DOWEQ     *OFF
     C                   ADD       PSTA          FPSTA
     C                   ADD       1             FNORE
     C                   READ      GENAPD                                 11
     C                   ENDDO
      *
     C                   READ      GENAZZ                                 12
     C     *IN12         IFEQ      *ON
     C                   Z-ADD     0             TPSTA            18 0
     C                   Z-ADD     0             TNORE             5 0
     C                   ELSE
     C     HRWN          MULT      1000          #WRK18           18 0
     C     #WRK18        ADD       HRDC          TPSTA
     C     NORE1         SUB       2             TNORE
     C                   END
      *
     C                   MOVE      *BLANKS       TEXT
     C                   MOVE      FILE@(13)     TEXT
     C                   EXSR      PRTDET
      *
      *********************
      ** (14)  GENA2PD   **
      *********************
     C                   READ      GENA2PD                              1011
     C     *IN10         IFEQ      *ON
     C                   MOVE      'GENA2PD '    FILNAM            8
     C                   EXSR      *PSSR
     C                   END
     C                   Z-ADD     0             FPSTA            18 0
     C                   Z-ADD     0             FNORE             5 0
     C     *IN11         DOWEQ     *OFF
     C                   ADD       PSTA          FPSTA
     C                   ADD       1             FNORE
     C                   READ      GENA2PD                                11
     C                   ENDDO
      *
     C                   READ      GENA2ZZ                                12
     C     *IN12         IFEQ      *ON
     C                   Z-ADD     0             TPSTA            18 0
     C                   Z-ADD     0             TNORE             5 0
     C                   ELSE
     C     HRWN          MULT      1000          #WRK18           18 0
     C     #WRK18        ADD       HRDC          TPSTA
     C     NORE1         SUB       2             TNORE
     C                   END
      *
     C                   MOVE      *BLANKS       TEXT
     C                   MOVE      FILE@(14)     TEXT
     C                   EXSR      PRTDET
      *
      *********************
      ** (15)  GEPCPD    **
      *********************
     C                   READ      GEPCPD                               1011
     C     *IN10         IFEQ      *ON
     C                   MOVE      'GEPCPD  '    FILNAM            8
     C                   EXSR      *PSSR
     C                   END
     C                   Z-ADD     0             FPSTA            18 0
     C                   Z-ADD     0             FNORE             5 0
     C     *IN11         DOWEQ     *OFF
     C                   ADD       PSTA          FPSTA
     C                   ADD       1             FNORE
     C                   READ      GEPCPD                                 11
     C                   ENDDO
      *
     C                   READ      GEPCZZ                                 12
     C     *IN12         IFEQ      *ON
     C                   Z-ADD     0             TPSTA            18 0
     C                   Z-ADD     0             TNORE             5 0
     C                   ELSE
     C     HRWN          MULT      1000          #WRK18           18 0
     C     #WRK18        ADD       HRDC          TPSTA
     C     NORE1         SUB       2             TNORE
     C                   END
      *
     C                   MOVE      *BLANKS       TEXT
     C                   MOVE      FILE@(15)     TEXT
     C                   EXSR      PRTDET
      *
      *********************
      ** (16)  GEPC2PD   **
      *********************
     C                   READ      GEPC2PD                              1011
     C     *IN10         IFEQ      *ON
     C                   MOVE      'GEPC2PD '    FILNAM            8
     C                   EXSR      *PSSR
     C                   END
     C                   Z-ADD     0             FPSTA            18 0
     C                   Z-ADD     0             FNORE             5 0
     C     *IN11         DOWEQ     *OFF
     C                   ADD       PSTA          FPSTA
     C                   ADD       1             FNORE
     C                   READ      GEPC2PD                                11
     C                   ENDDO
      *
     C                   READ      GEPC2ZZ                                12
     C     *IN12         IFEQ      *ON
     C                   Z-ADD     0             TPSTA            18 0
     C                   Z-ADD     0             TNORE             5 0
     C                   ELSE
     C     HRWN          MULT      1000          #WRK18           18 0
     C     #WRK18        ADD       HRDC          TPSTA
     C     NORE1         SUB       2             TNORE
     C                   END
      *
     C                   MOVE      *BLANKS       TEXT
     C                   MOVE      FILE@(16)     TEXT
     C                   EXSR      PRTDET
      *
      *
      *********************
      ** (17)  GESFPD    **
      *********************
     C                   READ      GESFPD                               1011
     C     *IN10         IFEQ      *ON
     C                   MOVE      'GESFPD  '    FILNAM            8
     C                   EXSR      *PSSR
     C                   END
     C                   Z-ADD     0             FPSTA            18 0
     C                   Z-ADD     0             FNORE             5 0
     C     *IN11         DOWEQ     *OFF
     C                   ADD       PSTA          FPSTA
     C                   ADD       1             FNORE
     C                   READ      GESFPD                                 11
     C                   ENDDO
      *
     C                   READ      GESFZZ                                 12
     C     *IN12         IFEQ      *ON
     C                   Z-ADD     0             TPSTA            18 0
     C                   Z-ADD     0             TNORE             5 0
     C                   ELSE
     C     HRWN          MULT      1000          #WRK18           18 0
     C     #WRK18        ADD       HRDC          TPSTA
     C     NORE1         SUB       2             TNORE
     C                   END
      *
     C                   MOVE      *BLANKS       TEXT
     C                   MOVE      FILE@(17)     TEXT
     C                   EXSR      PRTDET
      *
      *********************
      ** (18)  GESOPD    **
      *********************
     C                   READ      GESOPD                               1011
     C     *IN10         IFEQ      *ON
     C                   MOVE      'GESOPD  '    FILNAM            8
     C                   EXSR      *PSSR
     C                   END
     C                   Z-ADD     0             FPSTA            18 0
     C                   Z-ADD     0             FNORE             5 0
     C     *IN11         DOWEQ     *OFF
     C                   ADD       PSTA          FPSTA
     C                   ADD       1             FNORE
     C                   READ      GESOPD                                 11
     C                   ENDDO
      *
     C                   READ      GESOZZ                                 12
     C     *IN12         IFEQ      *ON
     C                   Z-ADD     0             TPSTA            18 0
     C                   Z-ADD     0             TNORE             5 0
     C                   ELSE
     C     HRWN          MULT      1000          #WRK18           18 0
     C     #WRK18        ADD       HRDC          TPSTA
     C     NORE1         SUB       2             TNORE
     C                   END
      *
     C                   MOVE      *BLANKS       TEXT
     C                   MOVE      FILE@(18)     TEXT
     C                   EXSR      PRTDET
      *
      *********************
      ** (19)  GESRPD    **
      *********************
     C                   READ      GESRPD                               1011
     C     *IN10         IFEQ      *ON
     C                   MOVE      'GESRPD  '    FILNAM            8
     C                   EXSR      *PSSR
     C                   END
     C                   Z-ADD     0             FPSTA            18 0
     C                   Z-ADD     0             FNORE             5 0
     C     *IN11         DOWEQ     *OFF
     C                   ADD       PSTA          FPSTA
     C                   ADD       1             FNORE
     C                   READ      GESRPD                                 11
     C                   ENDDO
      *
     C                   READ      GESRZZ                                 12
     C     *IN12         IFEQ      *ON
     C                   Z-ADD     0             TPSTA            18 0
     C                   Z-ADD     0             TNORE             5 0
     C                   ELSE
     C     HRWN          MULT      1000          #WRK18           18 0
     C     #WRK18        ADD       HRDC          TPSTA
     C     NORE1         SUB       2             TNORE
     C                   END
      *
     C                   MOVE      *BLANKS       TEXT
     C                   MOVE      FILE@(19)     TEXT
     C                   EXSR      PRTDET
      *
      *********************
      ** (20)  GEXBPD    **
      *********************
     C                   READ      GEXBPD                               1011
     C     *IN10         IFEQ      *ON
     C                   MOVE      'GEXBPD  '    FILNAM            8
     C                   EXSR      *PSSR
     C                   END
     C                   Z-ADD     0             FPSTA            18 0
     C                   Z-ADD     0             FNORE             5 0
     C     *IN11         DOWEQ     *OFF
     C                   ADD       PSTA          FPSTA
     C                   ADD       1             FNORE
     C                   READ      GEXBPD                                 11
     C                   ENDDO
      *
     C                   READ      GEXBZZ                                 12
     C     *IN12         IFEQ      *ON
     C                   Z-ADD     0             TPSTA            18 0
     C                   Z-ADD     0             TNORE             5 0
     C                   ELSE
     C     HRWN          MULT      1000          #WRK18           18 0
     C     #WRK18        ADD       HRDC          TPSTA
     C     NORE1         SUB       2             TNORE
     C                   END
      *
     C                   MOVE      *BLANKS       TEXT
     C                   MOVE      FILE@(20)     TEXT
     C                   EXSR      PRTDET
      *
      *********************
      ** (21)  GEXFPD    **
      *********************
     C                   READ      GEXFPD                               1011
     C     *IN10         IFEQ      *ON
     C                   MOVE      'GEXFPD  '    FILNAM            8
     C                   EXSR      *PSSR
     C                   END
     C                   Z-ADD     0             FPSTA            18 0
     C                   Z-ADD     0             FNORE             5 0
     C     *IN11         DOWEQ     *OFF
     C                   ADD       PSTA          FPSTA
     C                   ADD       1             FNORE
     C                   READ      GEXFPD                                 11
     C                   ENDDO
      *
     C                   READ      GEXFZZ                                 12
     C     *IN12         IFEQ      *ON
     C                   Z-ADD     0             TPSTA            18 0
     C                   Z-ADD     0             TNORE             5 0
     C                   ELSE
     C     HRWN          MULT      1000          #WRK18           18 0
     C     #WRK18        ADD       HRDC          TPSTA
     C     NORE1         SUB       2             TNORE
     C                   END
      *
     C                   MOVE      *BLANKS       TEXT
     C                   MOVE      FILE@(21)     TEXT
     C                   EXSR      PRTDET
      *
      *
      *********************
      ** (22)  MANPOPD   **
      *********************
     C                   READ      MANPOPD                              1011
     C     *IN10         IFEQ      *ON
     C                   MOVE      'MANPOPD '    FILNAM            8
     C                   EXSR      *PSSR
     C                   END
     C                   Z-ADD     0             FPSTA            18 0
     C                   Z-ADD     0             FNORE             5 0
     C     *IN11         DOWEQ     *OFF
     C                   ADD       PSTA          FPSTA
     C                   ADD       1             FNORE
     C                   READ      MANPOPD                                11
     C                   ENDDO
      *
     C                   READ      MANPOZZ                                12
     C     *IN12         IFEQ      *ON
     C                   Z-ADD     0             TPSTA            18 0
     C                   Z-ADD     0             TNORE             5 0
     C                   ELSE
     C     HRWN          MULT      1000          #WRK18           18 0
     C     #WRK18        ADD       HRDC          TPSTA
     C     NORE1         SUB       2             TNORE
     C                   END
      *
     C                   MOVE      *BLANKS       TEXT
     C                   MOVE      FILE@(22)     TEXT
     C                   EXSR      PRTDET
      *                                                                                       CAP204
      ** (23)  GETXPD                                                                         CAP204
      *                                                                                       CAP204
      *                                                                                       CAP204
     C     CAP204        IFEQ      'Y'                                                        CAP204
     C                   READ      GETXPD                               1011                  CAP204
     C     *IN10         IFEQ      *ON                                                        CAP204
     C                   MOVE      'GETXPD'      FILNAM                                       CAP204
     C                   EXSR      *PSSR                                                      CAP204
     C                   END                                                                  CAP204
     C                   Z-ADD     0             FPSTA                                        CAP204
     C                   Z-ADD     0             FNORE                                        CAP204
     C     *IN11         DOWEQ     *OFF                                                       CAP204
     C                   ADD       PSTA          FPSTA                                        CAP204
     C                   ADD       1             FNORE                                        CAP204
     C                   READ      GETXPD                                 11                  CAP204
     C                   ENDDO                                                                CAP204
      *                                                                                       CAP204
     C                   READ      GETXZZ                                 12                  CAP204
     C     *IN12         IFEQ      *ON                                                        CAP204
     C                   Z-ADD     0             TPSTA                                        CAP204
     C                   Z-ADD     0             TNORE                                        CAP204
     C                   ELSE                                                                 CAP204
     C     HRWN          MULT      1000          #WRK18                                       CAP204
     C     #WRK18        ADD       HRDC          TPSTA                                        CAP204
     C     NORE1         SUB       2             TNORE                                        CAP204
     C                   END                                                                  CAP204
      *                                                                                       CAP204
     C                   MOVE      *BLANKS       TEXT                                         CAP204
     C                   MOVE      FILE@(23)     TEXT                                         CAP204
     C                   EXSR      PRTDET                                                     CAP204
     C                   ENDIF                                                                CAP204
      *                                                                                     AR722462
      ** (24) GESPPD                                                                        AR722462
      *                                                                                     AR722462
     C                   READ      GESPPD                               1011                AR722462
     C     *IN10         IFEQ      *ON                                                      AR722462
     C                   MOVE      'GESPPD'      FILNAM                                     AR722462
     C                   EXSR      *PSSR                                                    AR722462
     C                   ENDIF                                                              AR722462
     C                   Z-ADD     0             FPSTA                                      AR722462
     C                   Z-ADD     0             FNORE                                      AR722462
     C     *IN11         DOWEQ     *OFF                                                     AR722462
     C                   ADD       PSTA          FPSTA                                      AR722462
     C                   ADD       1             FNORE                                      AR722462
     C                   READ      GESPPD                                 11                AR722462
     C                   ENDDO                                                              AR722462
      *                                                                                     AR722462
     C                   READ      GESPZZ                                 12                AR722462
     C     *IN12         IFEQ      *ON                                                      AR722462
     C                   Z-ADD     0             TPSTA                                      AR722462
     C                   Z-ADD     0             TNORE                                      AR722462
     C                   ELSE                                                               AR722462
     C     HRWN          MULT      1000          #WRK18                                     AR722462
     C     #WRK18        ADD       HRDC          TPSTA                                      AR722462
     C     NORE1         SUB       2             TNORE                                      AR722462
     C                   ENDIF                                                              AR722462
      *                                                                                     AR722462
     C                   MOVE      *BLANKS       TEXT                                       AR722462
     C                   MOVE      FILE@(24)     TEXT                                       AR722462
     C                   EXSR      PRTDET                                                   AR722462
      *                                                                                     AR722462
      ** (25) GESP2PD                                                                       AR722462
      *                                                                                     AR722462
     C                   READ      GESP2PD                              1011                AR722462
     C     *IN10         IFEQ      *ON                                                      AR722462
     C                   MOVE      'GESP2PD'     FILNAM                                     AR722462
     C                   EXSR      *PSSR                                                    AR722462
     C                   ENDIF                                                              AR722462
     C                   Z-ADD     0             FPSTA                                      AR722462
     C                   Z-ADD     0             FNORE                                      AR722462
     C     *IN11         DOWEQ     *OFF                                                     AR722462
     C                   ADD       PSTA          FPSTA                                      AR722462
     C                   ADD       1             FNORE                                      AR722462
     C                   READ      GESP2PD                                11                AR722462
     C                   ENDDO                                                              AR722462
      *                                                                                     AR722462
      ** GESP2ZZ                                                                            AR722462
      *                                                                                     AR722462
     C                   CALL      'GL0347'                                                 AR722462
     C                   PARM      *BLANKS       PRTCD             6                        AR722462
     C                   PARM      'GESP2ZZ'     PFILE            10                        AR722462
     C                   PARM      0             PNORE             5 0                      AR722462
     C                   PARM      0             PPSTA            18 0                      AR722462
      *                                                                                     AR722462
     C     PRTCD         IFNE      *BLANKS                                                  AR722462
     C                   MOVE      'GESP2ZZ'     FILNAM                                     AR722462
     C                   EXSR      *PSSR                                                    AR722462
     C                   ELSE                                                               AR722462
     C                   Z-ADD     PNORE         TNORE                                      AR722462
     C                   Z-ADD     PPSTA         TPSTA                                      AR722462
     C                   ENDIF                                                              AR722462
      *                                                                                     AR722462
     C                   MOVE      *BLANKS       TEXT                                       AR722462
     C                   MOVE      FILE@(25)     TEXT                                       AR722462
     C                   EXSR      PRTDET                                                   AR722462
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      * PRTDET - Print detail line if required                        *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     PRTDET        BEGSR                                                  ** PRTDET SR **
      *
     C     LINE          IFGT      55
     C                   WRITE     HEADAU
     C                   END
      *
     C     TPSTA         IFNE      FPSTA
     C     TNORE         ORNE      FNORE
     C                   SETON                                        50
     C                   ELSE
     C                   SETOFF                                       50
     C                   END
      *
     C                   WRITE     DETAIL
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      * INIT   - Initial routines                                     *
      *          Called at beginning of program.                      *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     INIT          BEGSR                                                  ** INIT SR **
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** Read in Installation Data
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C     *DTAARA       DEFINE                  LDA
     C                   IN        RUNDAT
      *
      ** Set Date Format Indicator *IN98  on if date format is MMDDYY
      *
     C     AGDFF         IFEQ      'M'
     C                   SETON                                        98
     C                   END
     C*
     C**  Access bank details file
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVEL     'GL0345'      DBPGM
     C                   MOVEL     'SDBANKPD'    DBFILE                           *************
     C                   Z-ADD     1             DBASE                            * DBERR 001 *
     C                   MOVEL     @OPTN         DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C*
     C** Access Midas Modules file
     C                   CALL      'AOMMODR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDMMOD        PARM      SDMMOD        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'GL0345'      DBPGM
     C                   MOVEL     'SDMMODPD'    DBFILE                           *************
     C                   Z-ADD     2             DBASE                            * DBERR 002 *
     C                   MOVEL     @OPTN         DBKEY            29
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C**  Access SAR details file to see if CAP204 is installed.                              CAP204
     C*                                                                                       CAP204
     C                   CALL      'AOSARDR0'                                                 CAP204
     C                   PARM      '       '     @RTCD                                        CAP204
     C                   PARM      '*VERIFY'     @OPTN                                        CAP204
     C                   PARM      'CAP204'      WSARD             6                          CAP204
     C*                                                                                       CAP204
     C     @RTCD         IFEQ      *BLANK                                                     CAP204
     C                   MOVE      'Y'           CAP204            1                          CAP204
     C                   ELSE                                                                 CAP204
     C     @RTCD         IFNE      *BLANKS                                                    CAP204
     C     @RTCD         ANDNE     '*NRF  '                                                   CAP204
     C     *LOCK         IN        LDA                                                        CAP204
     C                   MOVEL     'GL0345'      DBPGM                                        CAP204
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CAP204
     C                   Z-ADD     3             DBASE                                        CAP204
     C                   MOVEL     WSARD         DBKEY                                        CAP204
     C                   OUT       LDA                                                        CAP204
     C                   EXSR      *PSSR                                                      CAP204
     C                   ENDIF                                                                CAP204
     C                   ENDIF                                                                CAP204
      *
     C                   SETON                                        41
     C                   WRITE     HEADAU
      *
     C                   ENDSR
      *
      ********************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR SR **
      *
     C     FILNAM        IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'GL0345'      DBPGM
     C                   MOVEL     FILNAM        DBFILE                           *************
     C                   Z-ADD     99            DBASE                            * DBERR 099 *
     C                   MOVEL     'READ    '    DBKEY            29
     C                   OUT       LDA
     C                   END
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
      *****************************************************************
**  FILE@
CLEARPD   Items in clearing             -       1
CLEAROPD  New Items in clearing         -       2
CLEAR2PD  Items in clearing ANWD        -       3
GECEPD    Customer exchanges            -       4
GEFAPD    Fixed account fees            -       5
GEFRPD    Forward Revaluations          -       6
GEHMPD    Hold Mail                     -       7
GEHM2PD   Hold Mail ANWD                -       8
GEICPD    Interest capitalisation       -       9
GEIC2PD   Interest capitalisation ANWD  -      10
GEIERPD   Retail Inc/Exp                -      11
GEIER2PD  Retail Inc/Exp ANWD           -      12
GENAPD    Numbered account              -      13
GENA2PD   Numbered account ANWD         -      14
GEPCPD    Profit centre                 -      15
GEPC2PD   Profit centre ANWD            -      16
GESFPD    Statement Fees                -      17
GESOPD    Standing Orders               -      18
GESRPD    Spot Revaluations             -      19
GEXBPD    Transfer of base ccy to P&L   -      20
GEXFPD    Transfer of f/ccy to base ccy -      21
MANPOPD   Manual postings               -      22
GETXPD    Account Transfer Gen. Entries -      23
GESPPD    Sweep entries                 -      24
GESP2PD   Sweep entries 2               -      25
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
