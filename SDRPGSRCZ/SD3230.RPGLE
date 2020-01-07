     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2019')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Check if FTP network exists')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD3230 - Midas SD Check if FTP network exists                *
      *                                                               *
      *  (c) Finastra International Limited 2019                      *
      *                                                               *
      *  Last Amend No. MD053437  *CREATE  Date 07Oct19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD053437 - CGL013 FTP exit program                           *
      *                                                               *
      *****************************************************************

     FSDNWRKL2  IF   E           K DISK    INFSR(*PSSR)

      ** =======
      ** D-specs
      ** =======

     D/COPY ZACPYSRC,STD_D_SPEC

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D PRTCD           S              1A

      *****************************************************************
      /EJECT
      *****************************************************************

     C     *ENTRY        PLIST
     C                   PARM                    PRTCD

     C                   EVAL      PRTCD = 'N'

     C     *LOVAL        SETLL     SDNWRKL2
     C                   READ      SDNWRKL2                               01

     C                   IF        *IN01 = *OFF
     C                   EVAL      PRTCD = 'Y'
     C                   ENDIF

     C                   SETON                                        LR

     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************

     C     *PSSR         BEGSR

     C                   DUMP

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON

     C                   RETURN

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
