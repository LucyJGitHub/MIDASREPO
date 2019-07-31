     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2011')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Sort Action Codes')                           *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SM000032 - Sort Action Codes                                 *
      *                                                               *
      *  (c) Finastra International Limited 2011                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CBF005  *CREATE    Date 04Jul11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CBF005 - BF Infrastructure: Single Security User Maintenance *
      *           Profile                                             *
      *                                                               *
      *****************************************************************
     FSMBFACPD  UF   E             DISK    INFSR(*PSSR)
      *
     D ActCodes        S              1    DIM(10) CTDATA PERRCD(4) DESCEND
     D Recursive       S              1    INZ('N')
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      ** Read the list of available menu items by user, branch, etc.
      *
     C     1             SETLL     SMBFACPD
     C                   READ      SMBFACPD
      *
     C                   DOW       NOT(%EOF)
      *
      ** Move Action Codes into array.
      *
     C                   EVAL      ActCodes(1) = ACAC01
     C                   EVAL      ActCodes(2) = ACAC02
     C                   EVAL      ActCodes(3) = ACAC03
     C                   EVAL      ActCodes(4) = ACAC04
     C                   EVAL      ActCodes(5) = ACAC05
     C                   EVAL      ActCodes(6) = ACAC06
     C                   EVAL      ActCodes(7) = ACAC07
     C                   EVAL      ActCodes(8) = ACAC08
     C                   EVAL      ActCodes(9) = ACAC09
     C                   EVAL      ActCodes(10) = ACAC10
      *
      ** Sort the arrays; this will be in descending order.
      *
     C                   SORTA     ActCodes
      *
      ** Update record with resorted codes.
      *
     C                   EVAL      ACAC01 = ActCodes(1)
     C                   EVAL      ACAC02 = ActCodes(2)
     C                   EVAL      ACAC03 = ActCodes(3)
     C                   EVAL      ACAC04 = ActCodes(4)
     C                   EVAL      ACAC05 = ActCodes(5)
     C                   EVAL      ACAC06 = ActCodes(6)
     C                   EVAL      ACAC07 = ActCodes(7)
     C                   EVAL      ACAC08 = ActCodes(8)
     C                   EVAL      ACAC09 = ActCodes(9)
     C                   EVAL      ACAC10 = ActCodes(10)
     C                   UPDATE    SMBFACD0
      *
     C                   READ      SMBFACPD
     C                   ENDDO
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program Exception Error Routine                     *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        Recursive = *blanks
     C                   EVAL      Recursive = 'Y'
     C                   DUMP
      *
     C                   ENDIF
      *
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C     PSSRE         ENDSR
      *
      *****************************************************************
