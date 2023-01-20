     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2019')
      *****************************************************************
/******  RPGBASEBND                                                   *                     MD058830
/*STD *  RPGSQLBND                                                    *                     MD058830
/*EXI *  TEXT('Midas SD Check if FTP network exists')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD3230 - Midas SD Check if FTP network exists                *
      *                                                               *
      *  (c) Finastra International Limited 2019                      *
      *                                                               *
      *  Last Amend No. MD058830           Date 01Oct21               *
      *  Prev Amend No. MD053437  *CREATE  Date 07Oct19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058830 - Deliverable Data Split for SDNWRKPD               *
      *  MD053437 - CGL013 FTP exit program                           *
      *                                                               *
      *****************************************************************

     F*SDNWRKL2* IF   E           K DISK    INFSR(*PSSR)                                    MD058830

      ** =======
      ** D-specs
      ** =======

     D/COPY ZACPYSRC,STD_D_SPEC

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D PRTCD           S              1A
     D SDNWRK        E DS                  EXTNAME(SDNWKJW0)                                MD058830

      *****************************************************************
      /EJECT
      *****************************************************************

     C     *ENTRY        PLIST
     C                   PARM                    PRTCD

     C                   EVAL      PRTCD = 'N'

     C******LOVAL        SETLL     SDNWRKL2                                                 MD058830
     C**********         READ      SDNWRKL2                               01                MD058830
     C/EXEC SQL                                                                             MD058830
     C+ SELECT *                                                                            MD058830
     C+ into :SDNWRK                                                                        MD058830
     C+ from SDNWKJW0                                                                       MD058830
     C+ where EDPROT = '*FTP'                                                               MD058830
     C/END-EXEC                                                                             MD058830

     C**********         IF        *IN01 = *OFF                                             MD058830
     C                   If        SQLCODE <> 100                                           MD058830
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
