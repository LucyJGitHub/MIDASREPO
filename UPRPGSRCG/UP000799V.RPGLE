     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*X*I ***OVRDBF*FILE(UPACTFL0)*TOFILE(UPGPACTFL0)**********************                       CUP021
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UP Action File handler - validity checker')      *
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP000799V - Action File handler validity checker.            *
      *              Check record for the file exist in UPACTFPD.     *
      *              If exists, pass action file data back.           *
      *              If not exists, pass the PNoActionFile as 'Y'.    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. CUP021             Date 09Feb11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CUP022 *CREATE     Date 09Feb04               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CUP021 - Rewrite of Action File processing                   *
      *  CUP022 - Standardise action file processing.                 *
      *                                                               *
      *****************************************************************
      * Function of indicators                                        *
      *                                                               *
      *       30      Chain - record not found (UPACTFL0)             *
      *       31      Chain - record not found (UPGPACTFL0)           *
      *                                                               *
      *****************************************************************
     FUPACTFL0  IF   E           K DISK    INFSR(*PSSR)
     F*UPGPACTFL0IF**E           K DISK    INFSR(*PSSR)                                       CUP021
     F**********                           USROPN                                             CUP021
     F**********                           RENAME(UPACTFD0:GPACTFD0)                          CUP021
      *
      /EJECT
     D LDA           E DS           256    EXTNAME(LDA)
      *
      * Local data area for database error details
      * *LOCK IN LDA immediately before and OUT LDA immediately
      * after each database error handling.
      *
      *                                     134 141 DBFILE
      *       Defines:                      142 170 DBKEY
      *                                     171 180 DBPGM
      *                                     181 1830DBASE
      *
     D PSDS           SDS
      *
      * Program Status Data Structure.
      *
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
     D KFile           S             10
      *
     C     *ENTRY        PLIST
     C                   PARM                    PFile            10
     C**********         PARM                    PActionFile      10                          CUP021
     C**********         PARM                    PLogicFile       10                          CUP021
     C                   PARM                    PNoActionFile     1
     C**********         PARM                    PAFCProg         10                          CUP021
     C**********         PARM                    POvrRideFile     10                          CUP021
      *
     C                   Eval      KFile = PFile
      *
     C     KFile         CHAIN     UPACTFL0                           30
      *
      **If*record*not*found,*check*if*the*file*in*UPGPACTFL0.*
     C**********         IF        *IN30         = *ON                                        CUP021
     C**********         OPEN      UPGPACTFL0                                                 CUP021
     C*****KFile         CHAIN     UPGPACTFL0                         31                      CUP021
     C**********         CLOSE     UPGPACTFL0                                                 CUP021
      *
      * If record still not found, set flag to pass back to validity checker.
     C**********         IF        *IN31         = *ON                                        CUP021
     C                   IF        *IN30         = *ON
     C**********         EVAL      PActionFile   = *BLANK                                     CUP021
     C**********         EVAL      PLogicFile    = *BLANK                                     CUP021
     C                   EVAL      PNoActionFile = 'Y'
     C**********         EVAL      PAFCProg      = *BLANK                       AF CPP        CUP021
     C**********         EVAL      POvrRideFile  = *BLANK                       Override file CUP021
      *
     C                   GOTO      ENDPGM
     C**********         ENDIF                                                  FI *IN31 = *ONCUP021
      *
     C                   ENDIF                                                  FI *IN30 = *ON
      *
      * Record found, pass action file data back for validity check.
     C**********         EVAL      PActionFile   = AAFRMF                       Copy from fileCUP021
     C**********         EVAL      PLogicFile    = AAAFLF                       LF used by AF CUP021
     C                   EVAL      PNoActionFile = *BLANK
     C**********         EVAL      PAFCProg      = AAPROG                       AF CPP        CUP021
     C**********         EVAL      POvrRideFile  = AAUPLF                       Override file CUP021
      *
     C     ENDPGM        TAG
     C                   SETON                                        LR
     C                   RETURN
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
