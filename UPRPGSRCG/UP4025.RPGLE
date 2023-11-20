     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2022')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UP - aDBU scan replace')                                               MD061992
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *                     MD061992
      *                                                               *                     MD061992
      *  UP4025 - Midas UP aDBU scan replace                          *                     MD061992
      *                                                               *
      *  (c) Finastra International Limited 2022                      *
      *                                                               *
      *  Last Amend No. MD062077           Date 08Nov23               *
      *  Prev Amend No. MD061992           Date 23Oct23               *
      *                 MD060271           Date 21Jul22               *
      *                 MD059751 *CREATE   Date 25Mar22               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD062077 - Include reference BFLIB                           *
      *  MD061992 - Allow 3 char prefix for reference libraries       *
      *  MD060271 - SQL view is reported different when the differ-   *
      *             ence is only one blank character.                 *
      *  MD059751 - SQL view statement change is not detected by aDBU *
      *                                                               *
      *****************************************************************
     FUPSQLSTD  UF   F 5010        DISK
      *****************************************************************
      /EJECT
      *****************************************************************

     D LB1             S             10
     D LT1             S             10
     D LB2             S             10
     D LT2             S             10
     D LB3             S             10
     D LT3             S             10
     D LB4             S             10
     D LT4             S             10
     D LB5             S             10
     D LT5             S             10
     D*PFX******       S              3                                                     MD061992
     D PFX             S              4                                                     MD061992
     D pos             S              4  0
     D UPD             S              1
     D xlent           S              4  0
     D diff            S              4  0
     D DATAX           DS
     D  SVIEW                  1     10
     D  SSTMT                 11   5010
     D CR              C                   CONST(X'0D')                                     MD061992
     D LF              C                   CONST(X'25')                                     MD061992
     D BL              C                   CONST(X'40')                                     MD061992

     IUPSQLSTD  NS  01
     I                                  1 5010  XXTMT

      * read through UPSQLSTD
     C     1             SETLL     UPSQLSTD
     C                   READ      UPSQLSTD
     C                   DOW       NOT %EOF(UPSQLSTD)
     C                   EVAL      UPD = 'N'

     C                   EVAL      pos = %scan(%trimr(LB1):XXTMT)
     C                   if        pos > 0
     C                   EVAL      UPD = 'Y'
     C                   EVAL      XXTMT= %scanrpl(%trimr(LB1):%trimr(LT1):
     C                             XXTMT)
     C                   endif

     C                   EVAL      pos = %scan(%trimr(LB2):XXTMT)
     C                   if        pos > 0
     C                   EVAL      UPD = 'Y'
     C                   EVAL      XXTMT= %scanrpl(%trimr(LB2):%trimr(LT2):
     C                             XXTMT)
     C                   endif

     C                   EVAL      pos = %scan(%trimr(LB3):XXTMT)
     C                   if        pos > 0
     C                   EVAL      UPD = 'Y'
     C                   EVAL      XXTMT= %scanrpl(%trimr(LB3):%trimr(LT3):
     C                             XXTMT)
     C                   endif

     C                   EVAL      pos = %scan(%trimr(LB4):XXTMT)
     C                   if        pos > 0
     C                   EVAL      UPD = 'Y'
     C                   EVAL      XXTMT= %scanrpl(%trimr(LB4):%trimr(LT4):
     C                             XXTMT)
     C                   endif

     C                   EVAL      pos = %scan(%trimr(LB5):XXTMT)
     C                   if        pos > 0
     C                   EVAL      UPD = 'Y'
     C                   EVAL      XXTMT= %scanrpl(%trimr(LB5):%trimr(LT5):
     C                             XXTMT)
     C                   endif

      * Replace CR and LF by blank                                                          MD061992
     C                   EVAL      XXTMT= %scanrpl(CR:BL:XXTMT)                             MD061992
     C                   EVAL      XXTMT= %scanrpl(LF:BL:XXTMT)                             MD061992
                                                                                            MD061992
     C                   EVAL      pos = %scan('  ':XXTMT)                                  MD060271
     C                   if        pos > 0                                                  MD060271
     C                   EVAL      UPD = 'Y'                                                MD060271
     C                   EVAL      XXTMT= %scanrpl('  ':' ':XXTMT)                          MD060271
      * Cater for 16 blanks (now 8)                                                         MD061992
     C                   EVAL      XXTMT= %scanrpl('  ':' ':XXTMT)                          MD061992
     C                   EVAL      XXTMT= %scanrpl('  ':' ':XXTMT)                          MD061992
     C                   EVAL      XXTMT= %scanrpl('  ':' ':XXTMT)                          MD061992
     C                   endif                                                              MD060271
                                                                                            MD060271
     C                   if        UPD = 'Y'
     C                   eval      DATAX = XXTMT
     C                   Update    UPSQLSTD      DATAX
     C                   endif

     C                   READ      UPSQLSTD
     C                   ENDDO


     C                   seton                                        LR
     C                   RETURN
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    LIB              10
     C                   PARM                    LAYER             7

      * Test if system prefix is 3 char                                                     MD061992
     C                   if        %subst(LIB:3:5) = 'GVLIB'                                MD061992
     C                             and LAYER = '*GLOBAL'                                    MD061992
     C                             or %subst(LIB:3:5) = 'DVLIB'                             MD061992
     C                             and LAYER = '*ZONE'                                      MD061992
     C                   eval      PFX = %subst(LIB:1:3)
     C                   eval      LB5 = %subst(LIB:1:2) + 'BFLIB'                          MD062077
     C                   else                                                               MD061992
     C                   eval      PFX = %subst(LIB:1:4)                                    MD061992
     C                   eval      LB5 = %subst(LIB:1:3) + 'BFLIB'                          MD062077
     C                   endif                                                              MD061992
     C**********         eval      LB1 = PFX + 'MLIB'                                       MD061992
     C**********         eval      LB2 = PFX + 'VLIB'                                       MD061992
     C**********         eval      LB3 = PFX + 'PLIB'                                       MD061992
     C**********         eval      LB4 = PFX + 'TALIB'                                      MD061992
     C                   eval      LB1 = %trim(PFX) + 'MLIB'                                MD061992
     C                   eval      LB2 = %trim(PFX) + 'VLIB'                                MD061992
     C                   eval      LB3 = %trim(PFX) + 'PLIB'                                MD061992
     C                   eval      LB4 = %trim(PFX) + 'TALIB'                               MD061992
     C**********         eval      LB5 = %subst(LIB:1:2) + 'BFLIB'                          MD062077

     C                   if        LAYER = '*ZONE'
     C                   eval      LT1 = 'XX' + 'DMLIB'
     C                   eval      LT2 = 'XX' + 'DVLIB'
     C                   eval      LT3 = 'XX' + 'DPLIB'
     C                   eval      LT4 = 'XX' + 'DTALIB'
     C                   eval      LT5 = 'XX' + 'BFLIB'
     C                   else
     C                   eval      LT1 = 'XX' + 'GMLIB'
     C                   eval      LT2 = 'XX' + 'GVLIB'
     C                   eval      LT3 = 'XX' + 'GPLIB'
     C                   eval      LT4 = 'XX' + 'GTALIB'
     C                   eval      LT5 = 'XX' + 'BFLIB'
     C                   endif

     C                   ENDSR
