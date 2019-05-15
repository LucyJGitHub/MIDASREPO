     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2008')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Maintain driving file for data migration')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SM000008 - Update driving file status for migration          *
      *                                                               *
      *  (c) Finastra International Limited 2009                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. BUG27793 *CREATE   Date 04Jun10               *
      *                 XXXXXX             Date DDMmmYY               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG27793 - Make migration multi-streamed.                    *
      *                                                               *
      *****************************************************************
      *
     FSMCPYDPD  UF A E           K DISK
      *
     D PObject         S             10
     D PObjectType     S              8
     D PAction         S              7
     D PStatus         S              6
     D KObject         S             10
     D KObjectType     S              8
     D Recursive       S              1
      *
     C     *ENTRY        PLIST
     C                   PARM                    PObject
     C                   PARM                    PObjectType
     C                   PARM                    PAction
     C                   PARM                    PStatus
      *
     C     ObjectAndType KLIST
     C                   KFLD                    KObject
     C                   KFLD                    KObjectType
      *
     C                   EVAL      KObject = PObject
     C                   EVAL      KObjectType = PObjectType
      *
     C     ObjectAndType CHAIN     SMCPYDPD
     C                   IF        PAction = '*DELETE'
     C                   DELETE    QLIDOBJD
     C                   ENDIF
     C                   IF        PAction = '*UPDATE'
     C                   EVAL      ODDDAT = PStatus
     C                   UPDATE    QLIDOBJD
     C                   ENDIF
     C                   IF        PAction = '*WRITE '
     C                   IF        %FOUND
     C                   EVAL      ODDDAT = PStatus
     C                   UPDATE    QLIDOBJD
     C                   ELSE
     C                   EVAL      ODOBNM = PObject
     C                   EVAL      ODOBTP = PObjectType
     C                   EVAL      ODDDAT = PStatus
     C                   WRITE     QLIDOBJD
     C                   ENDIF
     C                   ENDIF
     C                   IF        PAction = '*CHECK '
     C                   IF        %FOUND
     C                   EVAL      PStatus = ODDDAT
     C                   ELSE
     C                   EVAL      PStatus = ' '
     C                   ENDIF
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
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
     C     *PSSR         BEGSR
      *
     C                   IF        Recursive = *blank
     C                   EVAL      Recursive = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
