     H DEBUG                                                                                  CGL120
      *****************************************************************
/*S*D****RPGBASE*******************************************************                       CGL120
/*STD *  RPGBASEBNC                                                   *                       CGL120
/*EXI *  TEXT('Midas S/D Ledger and Cleared Balance Upd.')            *
     F********************************************************************
     F*                                                                  *
     F*  Midas GENERAL LEDGER MODULE
     F*                                                                  *
     F*       GL0349 - SORTED ACCOUNT POSTINGS START OF DAY LEDGER       *
     F*                AND CLEARED BALANCES UPDATE.                      *
     F*                                                                  *
      *  (c) Finastra International Limited 2001                      *
     F*                                                                  *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CGL120             Date 06Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CSC042             Date 16Feb09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CGL014             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CGL020             Date 12Dec02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CGL007             Date 26Mar99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 S10736             Date 26Oct92               *  *
      *                 S01333             Date 25Apr90               *  *
     F*                     E22151           DATE  21MAY90               *
     F*                                                                  *
     F*---------------------------------------------------------------*
     F********************************************************************
     F*                                                                  *
     F*       DESCRIPTION OF CHANGE: ADDITION OF ADDRESS REFS            *
     F*                                                                  *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL120 - GL COB Components Task Split                           *
     F*     CSC042  - Performance fix. Only CHAIN ACCNT on change of     *
     F*               account as SACPO is sorted by account.
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CGL029 - Increase Account Code to 10 digits                  *
     F*  CGL020 - Midas Compliance Watch - Additional A/C Postings    *
     F*           Information                                         *
      *  CGL007 - Account Postings Enquiry (Recompile)                *
     F*     S10736  -  RECOMPILE FOR MANAGEMENT ACCOUNTS                 *
     F*     S01333  -  MIS REL 10, USE SOB ACCOUNT BALANCES              *
     F*     E22151  -  PROGRAM CREATED FOR E22151 TO UPDATE SACPO        *
     F*                WITH THE START OF DAY LEDGER AND CLEARED          *
     F*                BALANCES FROM THE ACCNT FILE.                     *
     F*                                                                  *
     F********************************************************************
     F*  C R E A T I O N     P A R A M E T E R S                      *
     F*                                                               *
     F*                                                               *
     F*****************************************************************
     F/SPACE 3
     F*ACCNT***IF**E           K        DISK                              S01333
     F************ACCNTAAF                          KIGNORE               S01333
     F************ACCNTACF                          KIGNORE               S01333
     FGLACBTL0  IF   E           K DISK                                         S01333
     F*SACPO***UP**F     268 13AI     2 DISK                              S01333
     F***SACPO***UP  F     268 18AI     2 DISK                     S01333 CGL007
     F***SACPO** UP  F     331 18AI     2 DISK                                         CGL007 CGL020
     F***SACPO** UP  F     589 18AI     2 DISK                                         CGL020 CGL029
     F***SACPO**   UP   F  620    24AIDISK    KEYLOC(2)                                CGL029 CGL120
     F/COPY WNCPYSRC,GLH00826
     FSACPO     UF   F  620    24AIDISK    KEYLOC(2) COMMIT                                   CGL120
     F/COPY WNCPYSRC,GLH00827
     FGLCBUSPD  IF   E           K DISK                                                       CGL120
     D*
     D*    LOCAL DATA AREA
     D*
     D*  DATA STRUCTURE FOR COMPILATION  - COPYRIGHT INSERTION
     D CPYR@#          DS
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
     D  CPY@##                 1     20
     D DSKEY           DS                                                                     CGL120
     D  CNUM                                                                                  CGL120
     D  CCY                                                                                   CGL120
     D  ACOD                                                                                  CGL120
     D  ACSQ                                                                                  CGL120
     D  BRCA                                                                                  CGL120
      *************************************************************                           CGL120
      *  I Specs                                                  *                           CGL120
      *************************************************************                           CGL120
     ISACPO     NS  01    1 CP
     I**********                              2   70CNUM                                      CSD027
     I                                  2    7  CNUM                                          CSD027
     I                                  8   10  CCY
     I**********                             11  140ACOD                                      CGL029
     I                                 11   14 0ACODQQ                                        CGL029
     I                                 15   16 0ACSQ
     I                                103  105  BRCA                            S01333
     I                             P  251  258 0ISDCB                                         CSC042
     I                             P  259  266 0ISDLB                                         CSC042
     I**********                      590  599 0ACOD                                   CGL029 CGL120
     I                             S  590  599 0ACOD                                          CGL120
     I          NS
     C*
     C*****KLIST         KLIST                                                                CGL120
     C     KACBAL        KLIST                                                                CGL120
     C                   KFLD                    CNUM
     C                   KFLD                    CCY
     C                   KFLD                    ACOD
     C                   KFLD                    ACSQ
     C                   KFLD                    BRCA                                         S01333
     C*
     C                   MOVEA     CPY@          BIS@             80
     C     *LIKE         DEFINE    LDBL          SDLB
     C     *LIKE         DEFINE    CLBL          SDCB
     C******LIKE         DEFINE    BRCA          ZBRCAZ                                CSC042 CGL120
     C******LIKE         DEFINE    CNUM          ZCNUMZ                                CSC042 CGL120
     C******LIKE         DEFINE    CCY           ZCCYZ                                 CSC042 CGL120
     C******LIKE         DEFINE    ACOD          ZACODZ                                CSC042 CGL120
     C******LIKE         DEFINE    ACSQ          ZACSQZ                                CSC042 CGL120
     C******LIKE         DEFINE    LDBL          ZLDBLZ                                CSC042 CGL120
     C******LIKE         DEFINE    CLBL          ZCLBLZ                                CSC042 CGL120
     C******LIKE         DEFINE    RECI          ZRECIZ                                CSC042 CGL120
     C*
     C**  IF THE RECORD IS A POSTING THEN UPDATE SACPO FROM ACCNT
     C******IN01         IFEQ      '1'                                                        CGL120
     C                   READ      GLCBUSPD                               10                  CGL120
     C                   DOW       NOT %EOF                                                   CGL120
     C*
     C*****BRCA*         IFEQ      ZBRCAZ                                              CSC042 CGL120
     C*****CNUM*         ANDEQ     ZCNUMZ                                              CSC042 CGL120
     C*****CCY**         ANDEQ     ZCCYZ                                               CSC042 CGL120
     C*****ACOD*         ANDEQ     ZACODZ                                              CSC042 CGL120
     C*****ACSQ*         ANDEQ     ZACSQZ                                              CSC042 CGL120
     C**********         Z-ADD     ZLDBLZ        LDBL                                  CSC042 CGL120
     C**********         Z-ADD     ZCLBLZ        CLBL                                  CSC042 CGL120
     C**********         MOVEL     ZRECIZ        RECI                                  CSC042 CGL120
     C**********         ELSE                                                          CSC042 CGL120
     C***********KLIST     CHAINACCNT                99                   S01333
     C*****KLIST         CHAIN     GLACBLF                            99               S01333 CGL120
     C     KACBAL        CHAIN     GLACBLF                            99                      CGL120
     C**********         MOVEL     BRCA          ZBRCAZ                                CSC042
     C******               Z-ADDCNUM      ZCNUMZ                                              CSC042
     C**********         MOVE      CNUM          ZCNUMZ                                CSC042 CGL120
     C**********         MOVEL     CCY           ZCCYZ                                 CSC042 CGL120
     C**********         Z-ADD     ACOD          ZACODZ                                CSC042 CGL120
     C**********         Z-ADD     ACSQ          ZACSQZ                                CSC042 CGL120
     C**********         Z-ADD     LDBL          ZLDBLZ                                CSC042 CGL120
     C**********         Z-ADD     CLBL          ZCLBLZ                                CSC042 CGL120
     C**********         MOVEL     RECI          ZRECIZ                                CSC042 CGL120
     C**********         END                                                           CSC042 CGL120
     C*
     C**  IF ACCNT RECORD FLAGGED FOR DELETION SET LAST DAY BALANCE
     C**  AND CLEARED BALANCE TO ZEROES
     C     RECI          IFNE      'D'
     C     *IN99         OREQ      '1'
     C                   Z-ADD     0             LDBL
     C                   Z-ADD     0             CLBL
     C                   END
     C*
     C     DSKEY         SETLL     SACPO                                                      CGL120
     C     DSKEY         READE     SACPO                                  80                  CGL120
     C                   DOW       *IN80=*OFF                                                 CGL120
     C     *IN01         IFEQ      *ON                                                        CGL120
     C*                                                                                       CGL120
     C** UPDATE FIELDS ON EACH POSTING ON SACPO WITH DATA FROM ACCNT.
     C                   Z-ADD     LDBL          SDLB
     C                   Z-ADD     CLBL          SDCB
     C     SDCB          IFNE      ISDCB                                                      CSC042
     C     SDLB          ORNE      ISDLB                                                      CSC042
     C                   EXCEPT
     C                   END                                                                  CSC042
     C                   ENDIF                                                                CGL120
     C     DSKEY         READE     SACPO                                  80                  CGL120
     C                   ENDDO                                                                CGL120
      *                                                                                       CGL120
     C                   READ      GLCBUSPD                               10                  CGL120
     C                   ENDDO                                                                CGL120
     C**********         END                                                                  CGL120
      *                                                                                       CGL120
     C                   SETON                                        LR                      CGL120
     C                   COMMIT                                                               CGL120
     C                   RETURN                                                               CGL120
     OSACPO     E
     O                       SDCB               258P
     O                       SDLB               266P
**CTDATA CPY@
(c) Finastra International Limited 2001
