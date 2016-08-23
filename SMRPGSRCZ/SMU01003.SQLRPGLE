     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Change component sequence to 2NNNN')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU01003 - Midas SM Change component sequence to 2NNNN       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
/*    *  Last Amend No. AR1097122 *CREATE    Date 25Mar13             *
      *                                                               *
      *****************************************************************
      *                                                               *
/*    *  AR1097122 - SFC0521 seq 21001 failed                         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
 
     FCBCMPNL0  IF   E           K DISK    INFSR(*PSSR)
     FCBCOBRL0  IF   E           K DISK    INFSR(*PSSR)
     FFCPREQL0  IF   E           K DISK    INFSR(*PSSR)
     FFCRREQL0  IF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      *                                                               *
      *  MAIN PROCESSING                                              *
      *                                                               *
      *****************************************************************
 
      ** Variables
     D OTTKEY          S             10A
     D SEQKEY          S              5A
     D VARSEQ1         S              4A
     D VARSEQ2         S              1A
     D VARSEQ3         S              5A
 
     D RUNBFOR         S              1A
     D SEQUENS         S              5A
     D COMPONT         S             10A
 
      ** Key fields.
 
     C     BCMPNK        KLIST
     C                   KFLD                    OTTKEY
     C                   KFLD                    SEQKEY
 
      ** Read On request components to run in next COB file.
 
     C                   READ      CBCOBRL0                               99
 
     C                   DOU       *IN99 = '1'
 
     C                   MOVE      CRCOTT        OTTKEY
     C                   MOVE      CRCSEQ        SEQKEY
     C                   MOVE      CRCSEQ        VARSEQ1
     C                   MOVEL     CRCSEQ        VARSEQ2
     C                   MOVE      CRCSEQ        VARSEQ3
 
      ** If component name and sequence not found in CBCMPNPD
      ** change the sequence with its equivalent in secondary
      ** cob and chain again.
 
     C                   EXSR      CHAINR
 
     ** If the component name and sequence is found in Components
     ** Physical file then update CBCOBRPD.
 
     C                   IF        *IN97 = '0'
     C                   EXSR      UPDCOBR
     C                   ENDIF
 
     C                   READ      CBCOBRL0                               99
     C                   ENDDO
 
      ** Process Report Requests components file.
 
     C                   READ      FCRREQL0                               99
 
     C                   DOU       *IN99 = '1'
 
     C                   MOVE      D5COTT        OTTKEY
     C                   MOVE      D5CSEQ        SEQKEY
     C                   MOVE      D5CSEQ        VARSEQ1
     C                   MOVEL     D5CSEQ        VARSEQ2
     C                   MOVE      D5CSEQ        VARSEQ3
 
      ** If component name and sequence not found in CBCMPNPD
      ** change the sequence with its equivalent in secondary
      ** cob and chain again.
 
     C                   EXSR      CHAINR
 
     ** If the component name and sequence is found in Components
     ** Physical file then update FCRREQPD.
 
     C                   IF        *IN97 = '0'
     C                   EXSR      UPDRREQ
     C                   ENDIF
 
     C                   READ      FCRREQL0                               99
     C                   ENDDO
 
      ** Process Periodic Requests components file.
 
     C                   READ      FCPREQL0                               99
 
     C                   DOU       *IN99 = '1'
 
     C                   MOVE      D9COTT        OTTKEY
     C                   MOVE      D9CSEQ        SEQKEY
     C                   MOVE      D9CSEQ        VARSEQ1
     C                   MOVEL     D9CSEQ        VARSEQ2
     C                   MOVE      D9CSEQ        VARSEQ3
 
      ** If component name and sequence not found in CBCMPNPD
      ** change the sequence with its equivalent in secondary
      ** cob and chain again.
 
     C                   EXSR      CHAINR
 
     ** If the component name and sequence is found in Components
     ** Physical file then update FCPREQPD.
 
     C                   IF        *IN97 = '0'
     C                   EXSR      UPDPREQ
     C                   ENDIF
 
     C                   READ      FCPREQL0                               99
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      *  CHAINR - This subroutine will chain the component name and   *
      *           sequence in CBCMPNPD.                               *
      *****************************************************************
     C     CHAINR        BEGSR
 
     C                   EVAL      *IN98 = *OFF
     C                   EVAL      *IN97 = *ON
 
     C     BCMPNK        CHAIN     CBCMPNL0                           98
 
     C                   IF        *IN98 = '1'
 
     C                   EXSR      CHGSEQ
     C     BCMPNK        CHAIN     CBCMPNL0                           97
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      *  UPDRREQ - This subroutine will update the sequence in file   *
      *            FCRREQPD                                           *
      *****************************************************************
     C     UPDRREQ       BEGSR
 
     C/EXEC SQL
     C+ update FCRREQPD set D5CSEQ = :SEQKEY
     C+ where D5COTT = :DHCOTT and D5CSEQ = :VARSEQ3
     C/END-EXEC
 
     C                   IF        SQLCODE <> 0 AND SQLCODE <> 100
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      *  UPDPREQ - This subroutine will update the sequence in file   *
      *            FCPREQPD                                           *
      *****************************************************************
     C     UPDPREQ       BEGSR
 
     C/EXEC SQL
     C+ update FCPREQPD set D9CSEQ = :SEQKEY
     C+ where D9COTT = :D9COTT and D9CSEQ = :VARSEQ3
     C/END-EXEC
 
     C                   IF        SQLCODE <> 0 AND SQLCODE <> 100
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      *  UPDCOBR - This subroutine will update the sequence in file   *
      *            CBCOBRPD                                           *
      *****************************************************************
     C     UPDCOBR       BEGSR
 
     C/EXEC SQL
     C+ update CBCOBRPD set CRCSEQ = :SEQKEY
     C+ where CRCOTT = :CRCOTT and CRCSEQ = :VARSEQ3
     C/END-EXEC
 
     C                   IF        SQLCODE <> 0 AND SQLCODE <> 100
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      *  CHGSEQ - This subroutine will change the sequence use in     *
      *          CHAIN with CBCMPNPD from Main COB to Secondary COB.  *
      *****************************************************************
     C     CHGSEQ        BEGSR
 
     C                   MOVEL     VARSEQ2       VARSEQ1
     C                   MOVE      VARSEQ1       SEQKEY
     C                   MOVEL     '2'           SEQKEY
 
     C                   ENDSR
      *****************************************************************
      *  *PSSR  - Program exception error routine                     *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        RUNBFOR = *BLANK
     C                   MOVE      'Y'           RUNBFOR
     C                   MOVE      SEQKEY        SEQUENS
     C                   MOVE      OTTKEY        COMPONT
     C                   DUMP
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
