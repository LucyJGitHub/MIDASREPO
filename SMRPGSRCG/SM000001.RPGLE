     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*X*I****OVRDBF*FILE(CPYDTA)*TOFILE(UPOBJDTPD)*************************                     BUG27793
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Remove recs. for objects not to copied')      *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SM000001 - Remove records from SMCPYDPD that are not to be   *
      *             migrated.                                         *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CUP002             Date 19Aug10               *
      *                 BUG27793           Date 04Jun10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CPK025  *CREATE    Date 04Aug06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CUP002 - New utility to rename zone.  Recompile.             *
      *  BUG27793 - Make migration multi-streamed.                    *
      *  CPK025 - MidasPlus 1.3 packaging.  Changes to migration.     *
      *                                                               *
      *****************************************************************
      *
      * File containing list of objects to be migrated.
     F*CPYDTA***UF   E             DISK                                                     BUG27793
     FSMCPYDPD  UF   E           K DISK                                                     BUG27793
      * File containing list of objects not to be migrated.
      ***at*Release*4.*                                                                     BUG27793
     FSMGNMGPD  IF   E           K DISK
      *
     D Recursive       S              1
      *
     C     Obj_and_Type  KLIST
     C                   KFLD                    ODOBNM
     C                   KFLD                    ODOBTP
      *
      * Read first record.
     C*****1****         SETLL     CPYDTA                                                   BUG27793
     C**********         READ      CPYDTA                                                   BUG27793
     C     *LOVAL        SETLL     SMCPYDPD                                                 BUG27793
     C                   READ      SMCPYDPD                                                 BUG27793
      *
     C                   DOU       %EOF
      *
     C                   EXSR      CheckSMGNMGPD
      *
     C**********         READ      CPYDTA                                                   BUG27793
     C                   READ      SMCPYDPD                                                 BUG27793
      *
     C                   ENDDO
      *
     C     ENDPGM        TAG
     C                   SETON                                        LR
     C                   RETURN
      *****************************************************************
      *                                                               *
      *  CheckSMGNMGPD - Check if object name/type combination        *
      *                  exists on SMGNMGPD.  If it is then delete    *
      *                  it from CPYDTA.                              *
      *                                                               *
      *****************************************************************
      *
     C     CheckSMGNMGPD BEGSR
      *
     C     Obj_and_Type  CHAIN     SMGNMGPD
     C                   IF        %FOUND
     C**********         DELETE    CPYDTA                                                   BUG27793
     C                   DELETE    SMCPYDPD                                                 BUG27793
     C                   ENDIF
      *
     C     CheckSMGNMGPDEENDSR
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
