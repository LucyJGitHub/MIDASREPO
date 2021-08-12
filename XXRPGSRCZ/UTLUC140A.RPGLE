     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2021')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UT SDMSTDX0 to XXMSTDX0')                        *
      *****************************************************************
      *                                                               *
      *  Midas - LUC140 RE Stamp Duty and Account                     *
      *                                                               *
      *  UTLUC140A - Utility from SDMSTDX0 to XXMSTDX0                *
      *                                                               *
      *  (c) Finastra International Limited 2021                      *
      *                                                               *
      *  Last Amend No. LUC140  *Create    Date 01Mar21               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC140 - Upgrade MMI013 to FM2.1                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *PSSR     - Error processing                                 *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FSDMSTDX0  IF   E             DISK    INFSR(*PSSR)
     FXXMSTDX0  O    E             DISK    INFSR(*PSSR)
     F                                     RENAME(SDMSTDD0:XXMSTDD0)

     FRESDCDV0  IF   E           K DISK    INFSR(*PSSR)
     FXXSDCDTD  O    E             DISK    INFSR(*PSSR)
     F                                     RENAME(RESDCDPP:XXSDCDPP)
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ ===================================  ¦
      ** +--------------------------------------+

      ** The following /COPY line includes all the defined fields in
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS

     D/COPY ZACPYSRC,STD_D_SPEC

     D DBMACDR         DS            18
     D  DBBrca                 1      3
     D  DBCNUM                 4      9
     D  DBCCY                 10     12
     D  DBACOD                13     16  0
     D  DBACSQ                17     18  0

     D FMMACDR         DS            24
     D  FMBrca                 1      3
     D  FMCNUM                 4      9
     D  FMCCY                 10     12
     D  FMACOD                13     22  0
     D  FMACSQ                23     24  0

     ISDMSTDD0
     I              MCust                       DMCust
     I              MAcod                       DMAcod
     I              MAcdr                       DMAcdr

     IRESDCDPP
     I              MCust                       REMCust
     I              MAcod                       REMAcod
      *****************************************************************
      /EJECT
      *****************************************************************

      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************

      *
      ** SDMSTDX0/XXMSTDX0
      *
     C                   READ      SDMSTDX0
     C                   DOW       NOT %EOF(SDMSTDX0)

     C                   Movel     DMCust        MCust
     C                   Move      '0000000000'  MAcod
     C                   Movel     DMAcod        MAcod

     C                   Movel     DMAcdr        DBMacdr
     C                   Movel     DBCnum        FMCnum
     C                   Move      '0000000000'  FMAcod
     C                   Movel     DBAcod        FMAcod
     C                   Movel     DBAcsq        FMAcsq
     C                   Movel     DBBrca        FMBRca
     C                   Movel     DBCcy         FMCcy
     C                   Move      FMMacdr       MAcdr

     C                   Write     XXMSTDD0

     C                   Read      SDMSTDX0

     C                   Enddo
      *
      ** RESDCDPP/XXSDCDTD
      *
     C     *Loval        Setll     RESDCDV0
     C                   READ      RESDCDV0
     C                   DOW       NOT %EOF(RESDCDV0)

     C                   Movel     REMCust       MCust
     C                   Move      '0000000000'  MAcod
     C                   Movel     REMAcod       MAcod

     C                   Write     XXSDCDPP

     C                   Read      RESDCDV0

     C                   Enddo

     C                   Eval      *INLR = *ON
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program Exception Error Routine                      *
      *                                                               *
      *****************************************************************

     C     *PSSR         BEGSR

     C                   SETON                                        U7U8LR
     C                   DUMP
     C                   RETURN

     C                   ENDSR
