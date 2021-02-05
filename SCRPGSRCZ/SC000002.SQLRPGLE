     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2008')
      *****************************************************************
/*XBI *  OVRDBF FILE(BEGINJRNF) TOFILE(UPOBJDTPD)                     *
/**** *  RPGBASEBND                                                   *                     MD056887
/*STD *  RPGSQLBND                                                    *                     MD056887
/**** *  DBGVIEW(*LIST)                                               *                     MD056887
/*EXI *  TEXT('Midas SC Remove recs. for objs. not to be journd')
      *****************************************************************
      *                                                               *
      *  Midas - System control module                                *
      *                                                               *
      *  SC000002 - Remove records from BEGINJRNF fir objects not to  *
      *             be journaled                                      *
      *                                                               *
      *  (c) Finastra International Limited 2008                      *
      *                                                               *
      *  Last Amend No. MD056887           Date 29Sep20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 BUG27134 *CREATE   Date 01Oct08               *
      *                 XXXXXX             Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD056887 - Deliverable Data Split for SCNJRNPD               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG27134 - Rewrite of SCBEGINJRN.                            *
      *                                                               *
      *****************************************************************
      *
      * File containing list of objects to be journaled.
     FBEGINJRNF UF   E             DISK
      * File containing list of objects not to be journaled.
     F*SCNJRNL4* IF   E           K DISK                                                    MD056887
      *
     D ObjType         S             10
     D Recursive       S              1
     D SCNJRN        E DS                  EXTNAME(SCNJRJW0)                                MD056887
      *
     C     Obj_and_Type  KLIST
     C                   KFLD                    ODOBNM
     C                   KFLD                    ObjType
      *
      * Read first record.
     C     1             SETLL     BEGINJRNF
     C                   READ      BEGINJRNF
      *
     C                   DOU       %EOF
     C                   EVAL      ObjType = ODOBTP
      *
     C                   EXSR      CheckSCNJRNL4
      *
     C                   READ      BEGINJRNF
      *
     C                   ENDDO
      *
     C     ENDPGM        TAG
     C                   SETON                                        LR
     C                   RETURN
      *****************************************************************
      *                                                               *
      *  CheckSCNJRNL4 - Check if object name/type combination        *
      *                  exists on SCNJRNL4.  If it does then delete  *
      *                  it from BEGINJRNF.                           *
      *                                                               *
      *****************************************************************
      *
     C     CheckSCNJRNL4 BEGSR
      *
     C*****Obj_and_Type  CHAIN     SCNJRNL4                                                 MD056887
     C/EXEC SQL                                                                             MD056887
     C+ SELECT *                                                                            MD056887
     C+ into :SCNJRN                                                                        MD056887
     C+ from SCNJRJW0                                                                       MD056887
     C+ where NJFILE = :ODOBNM and NJOTYP = :ObjType                                        MD056887
     C/END-EXEC                                                                             MD056887
     C**********         IF        %FOUND                                                   MD056887
     C                   IF        SQLCODE = 0                                              MD056887
     C                   IF        NJACTV = 'Y'
     C                   DELETE    BEGINJRNF
     C                   ENDIF
     C                   ENDIF
      *
     C     CheckSCNJRNL4EENDSR
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
