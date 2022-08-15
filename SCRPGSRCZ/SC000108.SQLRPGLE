     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/**** *  RPGBASEBND                                                   *                     MD058087
/*STD *  RPGSQLBND                                                    *                     MD058087
/*EXI *  TEXT('Midas SC Remove records from SCPEADPD')                *
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SC000108 - Remove Records from SCPEADPD which are not to     *
      *             be restored                                       *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. MD058087           Date 11May21               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 AR999518           Date 04Jul12               *
      *                 CSC054  *CREATE    Date 23Feb12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058087 - Deliverable Data Split for System Control         *
      *  MD046248 - Finastra Rebranding                               *
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
     FSCPEADPD  UF   E           K DISK

      ** Midas SC Objs not to be Restored in PEA System
     F*SCRMVDPD* IF   E           K DISK                                                    MD058087

     D SCRMVD        E DS                  EXTNAME(SCRMVJW0)                                MD058087
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     D @RUN            S              1

      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

     C     Key_Obj       KLIST
     C                   KFLD                    ODOBNM
     C                   KFLD                    ODOBTP

     C     *LOVAL        SETLL     SCPEADPD
     C                   READ      SCPEADPD

     C                   DOU       %EOF

     C*****Key_Obj       CHAIN     SCRMVDPD                                                 MD058087
     C/EXEC SQL                                                                             MD058087
     C+ SELECT *                                                                            MD058087
     C+ into :SCRMVD                                                                        MD058087
     C+ from SCRMVJW0                                                                       MD058087
     C+ where PEOBJ = :ODOBNM and PETYPE = :ODOBTP                                          MD058087
     C/END-EXEC                                                                             MD058087
     C**********         IF        %FOUND                                                   MD058087
     C                   IF        SQLCODE = 0                                              MD058087
     C                   DELETE    SCPEADPD
     C                   ENDIF

     C                   READ      SCPEADPD

     C                   ENDDO

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
