     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/**** *  RPGBASEBND                                                   *                     MD058087
/*STD *  RPGSQLBND                                                    *                     MD058087
/*EXI *  TEXT('Midas SC Update PEA Driving File Status')              *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SC000109 - Update PEA Driving File Status                    *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. MD058087           Date 11May21               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 AR1009800          Date 20Nov12               *
      *                 AR999518           Date 04Jul12               *
      *                 CSC054  *CREATE    Date 23Feb12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058087 - Deliverable Data Split for System Control         *
      *  MD046248 - Finastra Rebranding                               *
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
     F*SCMEXCPD* IF   E           K DISK                                                    MD058087

     D SCMEXC        E DS                  EXTNAME(SCMEXJW0)                                MD058087
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

     C*****PObject       CHAIN     SCMEXCPD                                                 MD058087
     C/EXEC SQL                                                                             MD058087
     C+ SELECT *                                                                            MD058087
     C+ into :SCMEXC                                                                        MD058087
     C+ from SCMEXJW0                                                                       MD058087
     C+ where MEFILE = :PObject                                                             MD058087
     C/END-EXEC                                                                             MD058087

     C**********         IF        %FOUND                                                   MD058087
     C                   IF        SQLCODE = 0                                              MD058087
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
