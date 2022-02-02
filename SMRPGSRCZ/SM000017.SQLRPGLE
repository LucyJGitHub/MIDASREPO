     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*X*I****OVRDBF*FILE(CPYDTA)*TOFILE(UPOBJDTPD)*************************                     BUG27793
/**** *  RPGBASEBND                                                   *                     MD058089
/*STD *  RPGSQLBND                                                    *                     MD058089
/*EXI *  TEXT('Midas SM Remove recs. for objects not to copied')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SM000017 - Remove records from CPYDTA that are not to be     *
      *             migrated.                                         *
      *                                                               *
      *  (c) Finastra International Limited 2007                      *
      *                                                               *

      *  Last Amend No. MD058089           Date 01Sep21               *
      *  Prev Amend No. MD046248           Date 05Feb18               *
      *                 BUG27793           Date 04Jun10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CSM010             Date 22Jun07               *
      *                 CER001  *CREATE    Date 16Apr07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058089 - Deliverable Data Split for SM and UP              *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG27793 - Make migration multi-streamed.                    *
      *  CSM010 - Applied by CER001.                                  *
      *  CER001 - MidasPlus 1.3 packaging.  Changes to migration.     *
      *                                                               *
      *****************************************************************
      *
      * File containing list of objects to be migrated.
     F*CPYDTA***UF   E             DISK                                                     BUG27793
     FSMCPYDPD  UF   E           K DISK                                                     BUG27793
      * File containing list of objects not to be migrated.
      ***at*Release*4.*                                                                     BUG27793
     F*SMZNMGPD* IF   E           K DISK                                                    MD058089
      *
     D Recursive       S              1
     D SMZNMG        E DS                  EXTNAME(SMZNMJW0)                                MD058089
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
     C                   EXSR      CheckSMZNMGPD
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
      *  CheckSMZNMGPD - Check if object name/type combination        *
      *                  exists on SMZNMGPD.  If it is then delete    *
      *                  it from CPYDTA.                              *
      *                                                               *
      *****************************************************************
      *
     C     CheckSMZNMGPD BEGSR
      *
     C*****Obj_and_Type  CHAIN     SMZNMGPD                                                 MD058089
     C/EXEC SQL                                                                             MD058089
     C+ SELECT *                                                                            MD058089
     C+ into :SMZNMG                                                                        MD058089
     C+ from SMZNMJW0                                                                       MD058089
     C+ where ZNOBJ = :ODOBNM and ZNTYPE = :ODOBTP                                          MD058089
     C/END-EXEC                                                                             MD058089
     C**********         IF        %FOUND                                                   MD058089
     C                   IF        SQLCODE = 0                                              MD058089
     C**********         DELETE    CPYDTA                                                   BUG27793
     C                   DELETE    SMCPYDPD                                                 BUG27793
     C                   ENDIF
      *
     C     CheckSMZNMGPDEENDSR
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
