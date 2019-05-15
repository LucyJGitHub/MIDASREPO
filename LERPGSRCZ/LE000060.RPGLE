     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  ALWNULL(*YES)                                                *
/*EXI *  TEXT('Midas LE Build the Tranche-Aggregate Facility Rel.')
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000060 - Build the Tranche-Aggregate Facility Relationship *
      *                                                               *
      *  Function:  This program will identify all tranches affecting *
      *  (COB)      a particular aggregated facility.                 *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CLE041  *CREATE    Date 11Oct04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE041 - Collateralised Lending Phase 2B                     *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FLEFCLNL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(F0)
      ** Facility Group Links by Hierarchy/Item Link
 
     FLEFCLNL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LEFCLND0:LEFCLND1)
     F                                     PREFIX(F1)
      ** Facility Group Links by Hierarchy/Item Link
 
     FLEFCGRL0  IF   E           K DISK    INFSR(*PSSR)
      ** Facility Group by Hierarchy ID/Group ID
 
     FLETRAGPD  UF A E           K DISK    INFSR(*PSSR)
      ** Tranche-Aggregate Facilities Relationship
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      ** Array containing Copyright statement
 
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
 
      ** Bank Details Data Structure
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Short Access Object Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long Access Object Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D                 DS
     D F1FCTRRN                1     14
     D AGTRBR                  1      3
     D*AGTRNM***               4      9  0                                                    CSD027
     D AGTRNM                  4      9                                                       CSD027
     D AGTRFT                 10     12  0
     D AGTRFN                 13     14  0
 
     D                 DS
     D FCAGRN                  1     14
     D AGAGBR                  1      3
     D*AGAGNM***               4      9  0                                                    CSD027
     D AGAGNM                  4      9                                                       CSD027
     D AGAGFT                 10     12  0
     D AGAGFN                 13     14  0
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D ACT@            S             80
     D WRun            S              1A
     D PRetCode        S              7
     D POption         S              7
     D KFCHYID         S                   LIKE(FCHYID)
     D KFCGRID         S                   LIKE(FCGRID)
     D WkCtr           S                   LIKE(F0FCLNID)
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Read all records from the Facility Group Links
     C     *LOVAL        SETLL     LEFCLNL0
     C                   READ      LEFCLNL0                               10
 
     C                   DOW       *IN10 = *OFF
     C                   EVAL      KFCHYID = F0FCHYID
     C                   EVAL      KFCGRID = F0FCGRID
     C     KLFLnk0       CHAIN     LEFCGRL0                           11
     C                   IF        *IN11 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'LEFCGRL0'
     C                   MOVEL     KFCHYID       DBKEY
     C                   MOVE      KFCGRID       DBKEY
     C                   EVAL      DBASE = 3
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   EVAL      WkCtr = F0FCLNID + 1
     C                   DOW       WkCtr <= F0FCENDI
     C     KLFLnk1       CHAIN     LEFCLNL1
     C                   IF        %FOUND(LEFCLNL1)
     C                   WRITE     LETRAGD0
     C                   ENDIF
     C                   ADD       1             WkCtr
     C                   ENDDO
 
      ** Read next record
     C                   READ      LEFCLNL0                               10
     C                   ENDDO
 
      ** Terminate Program
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Set up copyright parameter
     C                   MOVEA     CPY@          ACT@
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY = *BLANKS
     C                   EVAL      DBPGM = 'LE000060'
     C                   EVAL      DBMOD = 'LE000060'
     C                   EVAL      DBASE = *ZEROS
     C                   OUT       LDA
 
      ** Access Bank Details
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = '*FIRST'
     C                   EVAL      DBASE = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C     KLFLnk0       KLIST
     C                   KFLD                    KFCHYID
     C                   KFLD                    KFCGRID
 
     C     KLFLnk1       KLIST
     C                   KFLD                    KFCHYID
     C                   KFLD                    WkCtr
 
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        WRun = *BLANKS
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2004
