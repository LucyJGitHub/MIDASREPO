     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2007')
      *****************************************************************
/*XBIA*  CRTPF FILE(QTEMP/CMPSRCOF) RCDLEN(220)                       *
/*XBIB*  OVRDBF FILE(CMPSRCQT) TOFILE(CMPSRCOF)                       *
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UT Remove unneeded lines from CMPSRC file')
      *****************************************************************
      *                                                               *
      *  Midas - Utilities                                            *
      *                                                               *
      *  UT000003 - Remove extraneous lines                           *
      *                                                               *
      *  (c) Finastra International Limited 2007                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 05Feb18               *
      *  Prev Amend No. CUP007             Date 10Nov10               *
      *                 BUG27884 *CREATE   Date 08Jul10               *
      *                 CUT010             Date 15May07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CUP007 - New utility.                                        *
      *  BUG27884 - Applied CUT010.                                   *
      *  CUT010 - New utility.                                        *
      *                                                               *
      *****************************************************************
      *
     FCMPSRCQT  IF   E             DISK    RENAME(CMPSRCOF:CMPSRCF)
     F                                     PREFIX(Z)
      *
     D Recursive       S              1    INZ('N')
     D*Line110*        S            110                                                       CUP007
     D Line110         S             33                                                       CUP007
      *
      /EJECT
      * Read first record and substring (page numbers will vary).
     C     1             SETLL     CMPSRCF
     C                   READ      CMPSRCF
      *
      * Read the first record and delete all occurrences from file.
     C                   EVAL      Line110 = ZCMPSRCOF
     C/EXEC SQL
     C***delete*from*CMPSRCOF*where*substring(CMPSRCOF,1,110)*=*:Line110*                     CUP007
     C+  delete from CMPSRCOF where substring(CMPSRCOF,1,33) = :Line110                       CUP007
     C/END-EXEC
      *
      * Ignore the next record as this contains member names.
     C                   READ      CMPSRCF
      *
      * Read the next record and delete all occurences
     C                   READ      CMPSRCF
     C                   DO        6
     C/EXEC SQL
     C+  delete from CMPSRCOF where CMPSRCOF = :ZCMPSRCOF
     C/END-EXEC
      *
     C                   READ      CMPSRCF
     C                   ENDDO
      *
     C                   SETON                                        LR
     C                   RETURN
      *
      /EJECT
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
