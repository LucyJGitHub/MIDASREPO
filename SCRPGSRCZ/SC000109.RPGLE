     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SC Update PEA Driving File Status')              *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SC000109 - Update PEA Driving File Status                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. AR1009800          Date 20Nov12               *
      *  Prev Amend No. AR999518           Date 04Jul12               *
      *                 CSC054  *CREATE    Date 23Feb12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR1009800 - Added mutually exclusive key field               *
      *  AR999518 - Moved SCPEADPD from SCDDSSRCGP to SCDDSSRCDP      *
      *             source file (Recompile)                           *
      *  CSC054 - Period End Adjustments                              *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Files                                ¦
      ** ¦ =====                                ¦
      ** +--------------------------------------+
 
      ** Midas SC Driving File for PEA Objects
     FSCPEADPD  UF A E           K DISK    USROPN
 
      ** Midas SC Mutually Exclusive objects
     FSCMEXCPD  IF   E           K DISK
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D PObject         S             10
     D PObjectType     S              8
     D PAction         S              7
     D PStatus         S              6
     D KObject         S             10
     D KObjectType     S              8
     D @RUN            S              1
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C     *ENTRY        PLIST
     C                   PARM                    PObject
     C                   PARM                    PObjectType
     C                   PARM                    PAction
     C                   PARM                    PStatus
 
     C     Key_Obj       KLIST
     C                   KFLD                    KObject
     C                   KFLD                    KObjectType
 
      ** If ACTIVE wait for mutual exclusive file to complete the copy
 
     C                   IF        PStatus = 'ACTIVE'
 
     C     PObject       CHAIN     SCMEXCPD
 
     C                   IF        %FOUND
     C                   EVAL      KObject = MEMEXC
     C                   EVAL      KObjectType = PObjectType
 
     C**********         DOU       ODDDAT <> 'ACTIVE'                                      AR1009800
     C                   DOU       ODDDAT = 'PASSED' OR                                    AR1009800
     C                             ODDDAT = 'FAILED'                                       AR1009800
     C                   OPEN      SCPEADPD
     C     Key_Obj       CHAIN     SCPEADPD
     C                   CLOSE     SCPEADPD
     C                   ENDDO
 
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      KObject = PObject
     C                   EVAL      KObjectType = PObjectType
 
     C                   OPEN      SCPEADPD
     C     Key_Obj       CHAIN     SCPEADPD
 
     C                   IF        PAction = '*UPDATE'
     C                   EVAL      ODDDAT = PStatus
     C                   UPDATE    QLIDOBJD
     C                   ENDIF
 
     C                   CLOSE     SCPEADPD
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
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
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
