     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*XBI *  OVRDBF FILE(GBEGINJRNF) TOFILE(UPOBJDTPD)                    *
/*STD *  RPGBASEBND                                                   *
/*EXI *  DBGVIEW(*LIST)                                               *
/*EXI *  TEXT('Midas GP Remove recs. for objs. not to be journd')
      *****************************************************************
      *                                                               *
      *  Midas - Global processing                                    *
      *                                                               *
      *  GP000001 - Remove records from GBEGINJRNF fir objects not to *
      *             be journaled                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      *  Last Amend No. BUG27134 *CREATE   Date 01Oct08               *
      *  Prev Amend No. xxxxxx             Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG27134- Rewrite of GPBEGINJRN.                             *
      *                                                               *
      *****************************************************************
      *
      * File containing list of objects to be journaled.
     FGBEGINJRNFUF   E             DISK
      * File containing list of objects not to be journaled.
     FGPNJRNL4  IF   E           K DISK
      *
     D ObjType         S             10
     D Recursive       S              1
      *
     C     Obj_and_Type  KLIST
     C                   KFLD                    ODOBNM
     C                   KFLD                    ObjType
      *
      * Read first record.
     C     1             SETLL     GBEGINJRNF
     C                   READ      GBEGINJRNF
      *
     C                   DOU       %EOF
     C                   EVAL      ObjType = ODOBTP
      *
     C                   EXSR      CheckGPNJRNL4
      *
     C                   READ      GBEGINJRNF
      *
     C                   ENDDO
      *
     C     ENDPGM        TAG
     C                   SETON                                        LR
     C                   RETURN
      *****************************************************************
      *                                                               *
      *  CheckGPNJRNL4 - Check if object name/type combination        *
      *                  exists on GPNJRNL4.  If it does then delete  *
      *                  it from GBEGINJRNF.                          *
      *                                                               *
      *****************************************************************
      *
     C     CheckGPNJRNL4 BEGSR
      *
     C     Obj_and_Type  CHAIN     GPNJRNL4
     C                   IF        %FOUND
     C                   IF        NJACTV = 'Y'
     C                   DELETE    GBEGINJRNF
     C                   ENDIF
     C                   ENDIF
      *
     C     CheckGPNJRNL4EENDSR
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
