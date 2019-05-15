     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2008')
      *****************************************************************
/*XBI *  OVRDBF FILE(SMC000054F) TOFILE(UPFDBATPD)                    *
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Remove recs. for files with set CCSIDs')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation                                       *
      *                                                               *
      *  SM000005 - Remove records for files that have set CCSIDs.    *
      *                                                               *
      *  (c) Finastra International Limited 2008                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. 256038  *CREATE    Date 06Aug08               *
      *                 XXXXXX             Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  256038 - New utility to change CCSIDs.                       *
      *                                                               *
      *****************************************************************
      *
      * File containing list of files to have CCSIDS changed.
     FSMC000054FUF   E             DISK
      * File containing list of files with set CCSIDs.
     FSMCSIDPD  IF   E           K DISK
      *
     D Recursive       S              1
      *
     C     FileName      KLIST
     C                   KFLD                    ATFILE
      *
      * Read first record.
     C     1             SETLL     SMC000054F
     C                   READ      SMC000054F
      *
     C                   DOU       %EOF
      *
     C                   EXSR      CheckSMCSIDPD
      *
     C                   READ      SMC000054F
      *
     C                   ENDDO
      *
     C     ENDPGM        TAG
     C                   SETON                                        LR
     C                   RETURN
      *****************************************************************
      *                                                               *
      *  CheckSMCSIDPD - Check if file exists on SMCSIDPD.  If it     *
      *                  then delete it from CPYDTA.                  *
      *                                                               *
      *****************************************************************
      *
     C     CheckSMCSIDPD BEGSR
      *
     C     FileName      CHAIN     SMCSIDPD
     C                   IF        %FOUND
     C                   DELETE    SMC000054F
     C                   ENDIF
      *
     C     CheckSMCSIDPDEENDSR
      *
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        Recursive = 'N'
     C                   EVAL      Recursive = 'Y'
     C                   SETON                                        U7U8
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *
