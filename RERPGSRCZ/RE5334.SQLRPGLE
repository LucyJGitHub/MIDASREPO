     H DEBUG
      *****************************************************************
/*S*D****RPGBASE*******************************************************                     CRE083AA
/*STD *  RPGSQLBND                                                    *                     CRE083AA
/*EXI *  TEXT('Midas Accounts not subject to charge List')
     F*****************************************************************
     F*                                                               *
     F*  Midas - Retail Module
     F*                                                               *
     F*  RE5334 -  ACCOUNTS NOT SUBJECT TO CHARGE REPORT              *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
     F*                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. CRE083AA           Date 06Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 239284             Date 13Apr06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE002             Date 21Dec99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 S01413  *CREATE    Date 13Apr93               *
     F*                                                               *
     F*****************************************************************
     F*                                                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  CRE083AA - COB Restructure - RE COB Optimisation Phase 1     *
      *  239284 - Applied fix 238920.                                 *
      *  238920 - Make sure correct branch is output to report trail. *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CDE002 - Revenue Analysis - Recompiled due to changes in     *
      *           PF/REFXAJL1.                                        *
     F*  S01413 - Retail 3 incorporation                              *
     F*                                                               *
     F*****************************************************************
     F*                                                               *
     F*  C R E A T I O N     P A R A M E T E R S                      *
     F*                                                               *
     F*                                                               *
     F*****************************************************************
     F***REFXAJL1  IF   E           K DISK                                                  CRE083AA
     FRE5334P1  O    E             PRINTER INFDS(SPOOL)
     F                                     OFLIND(*IN80)
     F                                     USROPN
     FRE5334AU  O    E             PRINTER INFDS(SPOOLU)
     F                                     OFLIND(*IN81)
     F                                     USROPN
     F********************************************************************
     F/SPACE 3
     F*****************************************************************
     F*                                                               *
     F*  S U B R O U T I N E   I N D E X                              *
     F*                                                               *
     F*  *PSSR  - Data base error performing                          *
     F*  ZSEDIT - To edit an amoumt                                   *
     F*                                                               *
     F*****************************************************************
     D/SPACE 3
     D********************************************************************
     DACNTDS           DS                  OCCURS(32001)                                    CRE083AA
     D RECI                           1A                                                    CRE083AA
     D CNUM                           6A                                                    CRE083AA
     D CCY                            3A                                                    CRE083AA
     D ACOD                          10  0                                                  CRE083AA
     D ACSQ                           2  0                                                  CRE083AA
     D BRCA                           3A                                                    CRE083AA
     D ATYP                           1A                                                    CRE083AA
     D ANAM                          20A                                                    CRE083AA
     D LDBL                          15  0                                                  CRE083AA
     D ATCNUM                         6A                                                    CRE083AA
     D ATCHIN                         1A                                                    CRE083AA
                                                                                            CRE083AA
     DNOREC            S              5  0 INZ(32000)                                       CRE083AA
     DACNIDX           S              7  0 INZ(0)                                           CRE083AA
     D ZS2             S              1    DIM(21)
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)              COPYRIGHT
     D #C1             S              3    DIM(250)                                         CRE083AA
     D #C2             S              1  0 DIM(250)                                         CRE083AA
     D********************************************************************
     D/SPACE 3
     D********************************************************************
     D*
     D SPOOL           DS
     D  SFILE                 83     92
     D  SFNUM                123    124B 0
     D SPOOLU          DS
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
     D*
     D**  File Information Data Structure
     D*
     D LDA             DS           256
     D  DBLOT                134    183
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
     D*
     D**   Local data area for data base errors:
     D*
     D                 DS
     D  WORK15                 1     15  0
     D  ZS1                    1     15  0
     D                                     DIM(15)
     D*
     D**   Data structure used by SR/ZSEDIT
     D*
     D RUNDAT          DS
     D  RUNA                   1      7
     D  RUND                   8     10P 0
     D  SSF                   11     11
     D  DATF                  12     12
     D  MBIN                  13     13
     D*
     D**  Data Area RUNDAT
     D*
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D*
     D** Bank Details
     D*
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D  BRNM         E                     EXTFLD(A8BRNM)
     D*
     D**  External DS for Branch Codes.
     D*
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
     D*
     D**  External DS for Currency Codes.
     D*
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D*
     D** First DS for access programs, Short data structure
     D*
     D DSSDY         E DS                  EXTNAME(DSSDY)
     I*
     I** Second DS for access programs, Long data structure
     I*
     C/EJECT
     *********************************************************************
     C*
     C** Copyright Statement
     C*
     C                   MOVEA     CPY@          BIS@             80
     C*
     C     *LIKE         DEFINE    CCY           WWCCY                          Currency code
     C     *LIKE         DEFINE    BRCA          WBRCA                          Branch code
     C                   MOVE      'J'           ZECODE
     C                   Z-ADD     0             #Y                3 0
     C*
     C**   Prepare LDA & RUNDAT:
     C*
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVEL     *BLANK        DBLOT
     C                   MOVEL     'RE5334'      DBPGM
     C                   OUT       LDA
     C*
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
     C*
     C**   If record not found:
     C*
     C     @RTCD         IFNE      *BLANKS                                      *B1
     C*
     C**   DB error:
     C*
     C     *LOCK         IN        LDA
     C                   Z-ADD     1             DBASE                          ***************
     C                   MOVEL     'SDBANKL0'    DBFILE                         * DB ERROR 01 *
     C                   MOVEL     'BANK'        DBKEY                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C*
     C                   END                                                    *E1
     C*
     C** Test for Multibranching
     C*
     C     MBIN          IFEQ      'Y'
     C                   MOVE      '1'           *IN88
     C                   END
     C*
     C**   Reading input file
     C*
     C**********         READ      REFXAJL1                               50                CRE083AA
     C                   EXSR      SROPEN                                                   CRE083AA
     C                   EXSR      SRREADN                                                  CRE083AA
     C*
     C**   Detail processing if end of file not reached
     C*
     C******IN50         DOWEQ     '0'                                          *B1         CRE083AA
     C*
     C                   DOU       SQLCOD = 100                                             CRE083AA
     C                   IF        SQLCOD = 100                                             CRE083AA
     C                   LEAVE                                                              CRE083AA
     C                   ENDIF                                                              CRE083AA
     C                   FOR       ACNIDX = 1 TO SQLERRD(3)                                 CRE083AA
     C     ACNIDX        OCCUR     ACNTDS                                                   CRE083AA
     C     BRCA          IFNE      WBRCA
     C                   SETON                                        L3
     C                   MOVE      WBRCA         TBRCA
     C                   MOVE      BRCA          WBRCA
     C                   ELSE
     C                   SETOFF                                       L3
     C                   END
     C*
     C     *INL3         IFEQ      '1'
     C     *IN87         IFEQ      '1'
     C                   WRITE     TRAILAU
     C                   SETOFF                                       87
     C                   END
     C                   CLOSE     RE5334P1
     C                   SETON                                        58
     C                   OPEN      RE5334P1
     C                   SETON                                        31
     C                   SETON                                        87
     C                   WRITE     HEADLI
     C**
     C                   Z-ADD     0             PAGE
     C*
     C** ENSURE REPORT SPOOL FILE RECORDED BY RCF
     C*
     C                   Z-ADD     SFNUM         ZSNUM             6 0
     C*
     C                   CALL      'ZSFILE'
     C                   PARM      *BLANKS       SEQ               5
     C                   PARM      BRCA          SENTY             3
     C                   PARM                    SFILE
     C                   PARM                    ZSNUM
     C                   PARM                    ZSERR             1
     C*
     C     ZSERR         IFEQ      'Y'
     C*
     C**  ERROR DURING ZSFILE PROCESSING, RETURN TO CALLING PROGRAM
     C*
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   END
     C*
     C     MBIN          IFEQ      'Y'
     C*
     C** GET BRANCH NAME (IN BRNM)
     C*
     C**********           CALL 'AOBRCHR0'                                                    CGL029
     C                   CALL      'AOBRCHR1'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      BRCA          @DSNB             3
     C********** SDBRCH    PARM SDBRCH    DSFDY                                               CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     BRCA          DBKEY
     C                   MOVEL     'SDBRCHPD'    DBFILE
     C                   Z-ADD     12            DBASE                          * DBERROR 012 *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C                   END
     C*
     C                   WRITE     BRCHNM
     C*
     C                   END
     C*
     C**   Access the currency code details if there is a change of
     C**   currency code
     C*
     C     WWCCY         IFNE      CCY                                          *B2
     C                   ADD       1             #Y                                         CRE083AA
     C     CCY           LOOKUP    #C1(#Y)                                74                CRE083AA
     C     *IN74         IFEQ      *ON                                                      CRE083AA
     C                   MOVE      #C1(#Y)       WWCCY                                      CRE083AA
     C                   MOVE      #C2(#Y)       A6NBDP                                     CRE083AA
     C                   ELSE                                                               CRE083AA
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C                   PARM      CCY           @CCY              3
     C     SDCURR        PARM      SDCURR        DSSDY
     C*
     C**   If record not found:
     C*
     C     @RTCD         IFNE      *BLANKS                                      *B3
     C*
     C**   DB error:
     C*
     C     *LOCK         IN        LDA
     C                   Z-ADD     02            DBASE                          ***************
     C                   MOVEL     'SDCURRL0'    DBFILE                         * DB ERROR 02 *
     C                   MOVEL     CCY           DBKEY                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE                                                   *E3
     C                   MOVE      CCY           WWCCY
     C                   MOVE      CCY           #C1(#Y)                                    CRE083AA
     C                   MOVE      A6NBDP        #C2(#Y)                                    CRE083AA
     C*
     C                   END                                                    *E3
     C                   ENDIF                                                              CRE083AA
     C                   END                                                    *E2
     C*
     C                   Z-ADD     LDBL          ZFLD15
     C                   Z-ADD     A6NBDP        ZDECS
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        PPLDBL
     C*
     C                   WRITE     DETAIL
     C*
     C     *IN80         IFEQ      '1'                                          *B2
     C                   WRITE     HEADLI
     C                   MOVE      '0'           *IN80
     C                   END                                                    *E2
     C*
     C**   Reading next record on input file
     C*
     C**********         READ      REFXAJL1                               50                CRE083AA
     C*
     C                   END                                                    *E1
     C                   EXSR      SRREADN                                                  CRE083AA
     C                   ENDDO                                                              CRE083AA
     C*
     C     *IN31         IFEQ      '0'
     C                   OPEN      RE5334P1
     C*
     C** ENSURE REPORT SPOOL FILE RECORDED BY RCF
     C*
     C                   Z-ADD     SFNUM         ZSNUM             6 0
     C*
     C                   CALL      'ZSFILE'
     C                   PARM      *BLANKS       SEQ               5
     C                   PARM      BRCA          SENTY             3
     C                   PARM                    SFILE
     C                   PARM                    ZSNUM
     C                   PARM                    ZSERR             1
     C*
     C     ZSERR         IFEQ      'Y'
     C*
     C**  ERROR DURING ZSFILE PROCESSING, RETURN TO CALLING PROGRAM
     C*
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   END
     C*
     C                   WRITE     HEADLI
     C                   WRITE     BRCHNM
     C                   WRITE     NONE
     C                   CLOSE     RE5334P1
     C*
     C                   END
     C*
     C**  PRINT 'END OF BRANCH' NARRATIVE AT END OF PROGRAM ALSO
     C*
     C     *IN87         IFEQ      '1'
     C                   MOVE      WBRCA         TBRCA
     C                   WRITE     TRAILAU
     C                   END
     C*
     C                   MOVE      1             *INLR
     C                   RETURN
      *****************************************************************                     CRE083AA
      /EJECT                                                                                CRE083AA
      *****************************************************************                     CRE083AA
      *                                                               *                     CRE083AA
      * SRREADN - Insert selected records in a data structure         *                     CRE083AA
      *                                                               *                     CRE083AA
      *****************************************************************                     CRE083AA
     C     SRREADN       BEGSR                                                              CRE083AA
     C/EXEC SQL                                                                             CRE083AA
     C+ FETCH NEXT FROM MAIN_CURSOR FOR :NOREC ROWS INTO :ACNTDS                            CRE083AA
     C/END-EXEC                                                                             CRE083AA
     C                   IF        SQLCOD <  0                                              CRE083AA
     C                   EXSR      SRCLOSE                                                  CRE083AA
     C                   EVAL      *INLR = *ON                                              CRE083AA
     C                   RETURN                                                             CRE083AA
     C                   ENDIF                                                              CRE083AA
     C                   ENDSR                                                              CRE083AA
      *****************************************************************                     CRE083AA
      /EJECT                                                                                CRE083AA
      *****************************************************************                     CRE083AA
      *                                                               *                     CRE083AA
      * SRCLOSE - Close SQL Cursor                                    *                     CRE083AA
      *                                                               *                     CRE083AA
      *****************************************************************                     CRE083AA
     C     SRCLOSE       BEGSR                                                              CRE083AA
     C/EXEC SQL                                                                             CRE083AA
     C+ CLOSE MAIN_CURSOR                                                                   CRE083AA
     C/END-EXEC                                                                             CRE083AA
     C                   ENDSR                                                              CRE083AA
      *****************************************************************                     CRE083AA
      /EJECT                                                                                CRE083AA
      *****************************************************************                     CRE083AA
      *                                                               *                     CRE083AA
      * SROPEN - Declare SQL Cursor                                   *                     CRE083AA
      *                                                               *                     CRE083AA
      *****************************************************************                     CRE083AA
     C     SROPEN        BEGSR                                                              CRE083AA
     C/EXEC SQL                                                                             CRE083AA
     C+ DECLARE MAIN_CURSOR SCROLL CURSOR FOR                                               CRE083AA
     C+ SELECT                                                                              CRE083AA
     C+      RECI                                                                           CRE083AA
     C+     ,CNUM                                                                           CRE083AA
     C+     ,CCY                                                                            CRE083AA
     C+     ,ACOD                                                                           CRE083AA
     C+     ,ACSQ                                                                           CRE083AA
     C+     ,BRCA                                                                           CRE083AA
     C+     ,ATYP                                                                           CRE083AA
     C+     ,ANAM                                                                           CRE083AA
     C+     ,LDBL                                                                           CRE083AA
     C+     ,ATCNUM                                                                         CRE083AA
     C+     ,ATCHIN                                                                         CRE083AA
     C+   from ACCNTAB                                                                      CRE083AA
     C+   LEFT JOIN ACCNTBXC                                                                CRE083AA
     C+   ON                                                                                CRE083AA
     C+     BRCA = ATBRCA  AND                                                              CRE083AA
     C+     CNUM = ATCNUM  AND                                                              CRE083AA
     C+     CCY  = ATCCY   AND                                                              CRE083AA
     C+     ACOD = ATACOD  AND                                                              CRE083AA
     C+     ACSQ = ATACSQ                                                                   CRE083AA
     C+  where RECI = 'D' AND                                                               CRE083AA
     C+    ATYP= 'R'  AND ATCHIN <> 'Y'                                                     CRE083AA
     C+  ORDER BY                                                                           CRE083AA
     C+    ATBRCA, ATCNUM, ATCCY, ATACOD, ATACSQ                                            CRE083AA
     C/END-EXEC                                                                             CRE083AA
     C                                                                                      CRE083AA
     C/EXEC SQL                                                                             CRE083AA
     C+ OPEN MAIN_CURSOR                                                                    CRE083AA
     C/END-EXEC                                                                             CRE083AA
     C                   IF        SQLCOD <  0                                              CRE083AA
     C                   EXSR      SRCLOSE                                                  CRE083AA
     C                   EVAL      *INLR = *ON                                              CRE083AA
     C                   RETURN                                                             CRE083AA
     C                   ENDIF                                                              CRE083AA
     C                   ENDSR                                                              CRE083AA
     C********************************************************************
     C/EJECT
     C********************************************************************
     C*                                                                  *
     C**   *PSSR - Subroutine to process abnormal end of program         *
     C*                                                                  *
     C**   Called by main processing                                     *
     C*                                                                  *
     C**   Calls -                                                       *
     C*                                                                  *
     C********************************************************************
     C     *PSSR         BEGSR                                                  ** *PSRR BSR**
     C*
     C**   Dump and return to the calling program
     C*
     C                   MOVE      '1'           *INLR
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   OPEN      RE5334AU
     C                   Z-ADD     0             PAGE1
     C*
     C** ENSURE REPORT SPOOL FILE RECORDED BY RCF
     C*
     C                   Z-ADD     SFNUMU        ZSNUM             6 0
     C*
     C                   CALL      'ZSFILE'
     C                   PARM      *BLANKS       SEQ               5
     C                   PARM      *BLANKS       SENTY             3
     C                   PARM                    SFILEU
     C                   PARM                    ZSNUM
     C                   PARM                    ZSERR             1
     C*
     C     ZSERR         IFEQ      'Y'
     C*
     C**  ERROR DURING ZSFILE PROCESSING, RETURN TO CALLING PROGRAM
     C*
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   END
     C*
     C                   WRITE     HEADAU
     C                   CLOSE     RE5334AU
     C     @RUN          IFNE      'Y'
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   END
     C                   RETURN
     C*
     C                   ENDSR                                                   ** *PSRR ESR**
     C********************************************************************
     C/EJECT
     C********************************************************************
     C**                                                                 *
     C** ZSEDIT subroutine to insert a decimal point and sign into a     *
     C** numeric field and to blank out leading zeros (optionaly         *
     C** inserting commas).                                              *
     C**     Input fields:   ZFLD15 15/0                                 *
     C**                     ZDECS  1/0                                  *
     C**                     ZECODE 1/  ('J', 'L' or blank)              *
     C**                                                                 *
     C**     Arrays:         ZS1    15/1/0                               *
     C**                     ZS2    21/1/                                *
     C**                                                                 *
     C**     Output fields:  ZOUT21 21                                   *
     C**                                                                 *
     CSR   ZSEDIT        BEGSR                                                  **  ZSEDIT   *
     C*
     C* Define/Clear fields
     C*
     C                   Z-ADD     ZFLD15        ZFLD15           15 0
     C                   Z-ADD     ZDECS         ZDECS             1 0
     C                   MOVE      ZECODE        ZECODE            1
     C                   MOVE      *BLANKS       ZOUT21           21
     C*
     C*       SET UP WORK FIELDS
     C*
     C                   Z-ADD     0             ZS1
     C                   MOVE      ' '           ZS2
     C*
     C                   Z-ADD     15            Z1                2 0
     C                   Z-ADD     20            Z2                2 0
     C*
     C     15            SUB       ZDECS         ZINTS             2 0
     C*
     C* Check if numeric field is negative
     C*
     C     ZFLD15        IFLT      *ZEROS
     C                   MOVE      '-'           ZS2(21)
     C                   Z-SUB     ZFLD15        ZFLD15
     C                   END
     C*
     C                   Z-ADD     ZFLD15        WORK15
     C*
     C*       CHECK TO SEE IF THERE ARE ANY DECIMAL PLACES
     C*
     C     ZDECS         CABEQ     0             ZS10
     C*
     C*       SET UP DECIMALS
     C*
     C                   Z-ADD     *ZEROS        ZCNT              1 0
     C     ZCNT          DOUEQ     ZDECS
     C                   MOVE      ZS1(Z1)       ZS2(Z2)
     C                   SUB       1             Z2
     C                   ADD       1             ZCNT
     C                   SUB       1             Z1
     C                   END
     C*
     C*       PUT IN DECIMAL PLACE
     C*
     C                   MOVE      '.'           ZS2(Z2)
     C                   SUB       1             Z2
     C*
     C     ZS10          TAG                                                    ** ZS10 TAG **
     C*
     C*       SET UP INTEGERS
     C*
     C                   Z-ADD     *ZEROS        CNT3              1 0
     C     Z1            DOUEQ     *ZEROS
     C                   MOVE      ZS1(Z1)       ZS2(Z2)
     C                   SUB       1             Z1
     C                   SUB       1             Z2
     C*
     C* If edit code is 'J', insert a ',' before each group of three
     C* digits - not if beginning of array reached.
     C*
     C     Z2            IFGT      *ZEROS
     C     ZECODE        ANDEQ     'J'
     C                   ADD       1             CNT3
     C     CNT3          IFEQ      3
     C                   MOVE      ','           ZS2(Z2)
     C                   SUB       1             Z2
     C                   Z-ADD     *ZEROS        CNT3
     C                   END
     C                   END
     C*
     C                   END
     C*
     C*       PUT IN LEADING BLANKS
     C*
     C                   Z-ADD     1             Z2
     C     ZS2(Z2)       DOWEQ     '0'
     C     ZS2(Z2)       OREQ      ' '
     C     ZS2(Z2)       OREQ      ','
     C                   MOVE      ' '           ZS2(Z2)
     C                   ADD       1             Z2
     C     Z2            CABEQ     22            ZS20
     C                   END
     C*
     C*       IF NO INTEGERS PUT IN LEADING ZERO
     C*
     C     ZS20          TAG                                                    ** ZS20 TAG **
     C*
     C     Z2            IFEQ      22
     C                   SUB       2             Z2
     C                   MOVE      '0'           ZS2(Z2)
     C                   ELSE
     C*
     C     ZS2(Z2)       IFEQ      '.'
     C                   SUB       1             Z2
     C                   MOVE      '0'           ZS2(Z2)
     C                   END
     C                   END
     C*
     C*       SET UP OUTPUT FIELD
     C*
     C                   MOVEA     ZS2           ZOUT21
     C*
     CSR                 ENDSR
     C*****************************************************************
**  CPY@  OBJECT COPYRIGHT
(c) Finastra International Limited 2001
