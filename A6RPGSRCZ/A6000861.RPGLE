     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Utility to Sync GLNW94PD and A6NW94PD')                *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  A6000861 - Utility to Sync GLNW94PD and A6NW94PD             *
      *                                                               *
      *  Function:  This program INSERTS missing records in A6NW94PD  *
      *             and DELETES records that does not exist in        *
      *             GLNW94PD                                          *
      *                                                               *
      *  Called By: UTCGL0861                                         *
      *                                                               *
      *  (c) Finastra International Limited 2023                      *
      *                                                               *
      *  Last Amend No. BA6026   *CREATE   Date 18Jan23               *
      *  Prev Amend No. xxxxxxxx           Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BA6026 - Structuring Current MT940 and SEPA Compliance.      *
      *           Include MD058337.                                   *
      *                                                               *
      *****************************************************************
      *  Function of Indicators                                       *
      *                                                               *
      *       12  Records for Deletion Exists                         *
      *       14  Overflow Indicator                                  *
      *       16  Update Mode                                         *
      *       90  Error in AOBANKR0                                   *
      *                                                               *
      *****************************************************************

     FGLNW94L7  IF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLNW94D0:GLNW94F7)
     FA6NW94L2  UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(A6NW94D0:A6NW94G2)
     FA6000861P1O    E             PRINTER OFLIND(*IN14)
     FA6000861AUO    E             PRINTER
      /EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)

      ** Array containing Copyright statement

      /SPACE 3
     D LDA           E DS           256    EXTNAME(LDA)

      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
     D RCOUNT          S              6  0
     D DCOUNT          S              6  0
     D ICOUNT          S              6  0

     D SDBANK        E DS                  EXTNAME(SDBANKPD)

     D DSFDY         E DS                  EXTNAME(DSFDY)

     D DS94D           DS            29
     D  N4BRCA                 1      3
     D  N4CNUM                 4      9
     D  N4CCY                 10     12
     D  N4ACCD                13     22  0
     D  N4ACSQ                23     24  0
     D  N4DBKEY                1     24

     D DS94X           DS            29
     D  G4BRCA                 1      3
     D  G4CNUM                 4      9
     D  G4CCY                 10     12
     D  G4ACCD                13     22  0
     D  G4ACSQ                23     24  0
     D  G4DBKEY                1     24

      ** Data Area giving Installation Control Details

     D PSDS           SDS

      ** Program Status Data Structure

     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263

     D @RUN            S              1A
     D WKCCYY          S              4S 0
     D WKDFMT          S              9A
     D WKYEAR          S              2S 0
     D CPY2@           S             80A
     D @RTCD           S              7A
     D @OPTN           S              7A
     D P@PRCD          S              1A
     D P@RFNO          S             10A
     D P@FRAC          S             24A
     D P@TOAC          S             24A

      *****************************************************************
      /EJECT
      *****************************************************************

     C     *ENTRY        PLIST
     C                   PARM                    P@PRCD

     C                   EXSR      SRINIT

     C                   EXSR      XMNW94

     C                   SETON                                        LR
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  XMNW94 - Create Missing A6NW94PD Records                     *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls:     PRINTP1, SRAUDIT                                  *
      *                                                               *
      *****************************************************************

     C     XMNW94        BEGSR

     C     *LOVAL        SETLL     GLNW94F7
     C                   READ      GLNW94F7

     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'GLNW94L7'
     C                   EVAL      DBKEY = N4DBKEY
     C                   Z-ADD     001           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Check if 94D Record exists in 94X if NOT Write 94X Record

     C                   EVAL      ACTION = 'INSERT'
     C                   DOW       NOT %EOF(GLNW94L7)
     C     KNW94D        CHAIN     A6NW94G2

     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'A6NW94L2'
     C                   EVAL      DBKEY = G4DBKEY
     C                   Z-ADD     002           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        NOT %FOUND(A6NW94L2)
     C                   EVAL      G4RECI = N4RECI
     C                   EVAL      G4NWRK = G4NWRK
     C                   EVAL      G4BRCA = N4BRCA
     C                   EVAL      G4CNUM = N4CNUM
     C                   EVAL      G4CCY  = N4CCY
     C                   EVAL      G4ACCD = N4ACCD
     C                   EVAL      G4ACSQ = N4ACSQ
     C                   EVAL      G4NATY = N4NATY
     C                   EVAL      G4DSTN = N4DSTN
     C                   EVAL      G4SF86 = 'N'

     C                   IF        *IN16 = *ON
     C                   WRITE     A6NW94G2
     C                   ENDIF
     C                   EVAL      ICOUNT += 1

     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'A6NW94L2'
     C                   EVAL      DBKEY = G4DBKEY
     C                   Z-ADD     003           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EXSR      PRINTP1

     C                   ENDIF

     C                   READ      GLNW94F7

     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'GLNW94L7'
     C                   EVAL      DBKEY = N4DBKEY
     C                   Z-ADD     004           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDDO
      *
      ** Check if 94X record exists in 94D. If NOT, delete 94X
      *
     C     *LOVAL        SETLL     A6NW94G2
     C                   READ      A6NW94G2
      *
     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'A6NW94L2'
     C                   EVAL      DBKEY = G4DBKEY
     C                   Z-ADD     007           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Check if 94D Record exists in 94X if NOT Write 94X Record

     C                   EVAL      ACTION = 'DELETE'
     C                   DOW       NOT %EOF(A6NW94L2)
     C     KNW94X        CHAIN     GLNW94F7
      *
     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'GLNW94L7'
     C                   EVAL      DBKEY = N4DBKEY
     C                   Z-ADD     008           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        NOT %FOUND(GLNW94L7)
      *
     C                   IF        *IN16 = *ON
     C                   DELETE    A6NW94G2
     C                   ENDIF
     C                   EVAL      DCOUNT += 1
      *
     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'A6NW94L2'
     C                   EVAL      DBKEY = G4DBKEY
     C                   Z-ADD     009           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EXSR      PRINTP1

     C                   ENDIF
      *
     C                   READ      A6NW94G2
      *
     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'A6NW94L2'
     C                   EVAL      DBKEY = G4DBKEY
     C                   Z-ADD     010           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDDO
     C                   EXSR      SRAUDIT
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINIT - Initialise and define fields                        *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************

     C     SRINIT        BEGSR

      ** Set up copyright parameter

     C                   MOVEA     CPY@          CPY2@

     C     *DTAARA       DEFINE                  LDA

      ** Retrieve Run Date.

     C                   CALL      'AOBANKR0'                           9090
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY

      ** If return with an error (LR seton in called program) then
      ** process for database error.

     C                   IF        *IN90 = '1' OR
     C                             @RTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'AOBANKR0'
     C                   EVAL      DBKEY = '*FIRST'
     C                   Z-ADD     006           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      WKDFMT = BJMRDT
     C                   MOVE      BJMRDT        WKYEAR

     C                   IF        WKYEAR < 72
     C                   EVAL      WKCCYY = WKYEAR + 2000
     C                   ELSE
     C                   EVAL      WKCCYY = WKYEAR + 1900
     C                   ENDIF

     C                   MOVE      WKCCYY        WKDFMT

     C     KNW94D        KLIST
     C                   KFLD                    N4BRCA
     C                   KFLD                    N4CNUM
     C                   KFLD                    N4CCY
     C                   KFLD                    N4ACCD
     C                   KFLD                    N4ACSQ

     C     KNW94X        KLIST
     C                   KFLD                    G4BRCA
     C                   KFLD                    G4CNUM
     C                   KFLD                    G4CCY
     C                   KFLD                    G4ACCD
     C                   KFLD                    G4ACSQ

     C                   EVAL      RCOUNT = 0
     C                   EVAL      DCOUNT = 0
     C                   EVAL      ICOUNT = 0

     C                   IF        P@PRCD = 'U' or P@PRCD = 'u'
     C                   EVAL      *IN16 = *On
     C                   ELSE
     C                   IF        P@PRCD = 'A' or P@PRCD = 'a'
     C                   EVAL      *IN16 = *Off
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      *IN14 = *ON

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  PRINT SUBROUTINE                                             *
      *                                                               *
      *****************************************************************
     C     PRINTP1       BEGSR
      *
      ** Print the first header on the start of page
      *
     C                   IF        *IN14 = *On and RCOUNT = 0
     C                   WRITE     HEADER1
     C                   EVAL      *IN14 = *Off
     C                   ENDIF
      *
      ** Print account details
      *
     C                   EVAL      RCOUNT += 1
     C                   EVAL      *IN12 = *On
     C                   WRITE     DETAIL1
      *
      ** If next page, write header and title line again
      *
     C                   IF        RCOUNT > 0 and *IN14 = *On
     C                   WRITE     HEADER1
     C                   EVAL      *IN14 = *Off
     C                   ENDIF
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAUDIT - Subroutine to Output Audit report and End Program. *
      *                                                               *
      *****************************************************************
     C     SRAUDIT       BEGSR

      ** Output Report Header and File Controls.
     C                   WRITE     HEADAU
     C                   WRITE     CONTROL

      ** If there is a DB Error, Output the DB Error Information.
     C                   IF        *INU7 = *On
     C                   WRITE     DBERROR
     C                   ELSE

      ** Or, if no records read, Output "No Details" message.
     C                   IF        RCOUNT = 0
     C                   WRITE     NODTLS
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *PSSR         BEGSR

     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
     C                   ENDIF
     C                   WRITE     DBERROR

     C                   SETON                                        U7U8LR
     C                   RETURN

     C                   ENDSR

      ********************************************************************
**  CPY@
(c) Finastra International Limited 2023
