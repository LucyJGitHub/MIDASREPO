     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SC Remove records from SCPEADPD')                *
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SC000108 - Remove Records from SCPEADPD which are not to     *
      *             be restored                                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. AR999518           Date 04Jul12               *
      *  Prev Amend No. CSC054  *CREATE    Date 23Feb12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
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
     FSCRMVDPD  IF   E           K DISK
 
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
 
     C     Key_Obj       CHAIN     SCRMVDPD
     C                   IF        %FOUND
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
