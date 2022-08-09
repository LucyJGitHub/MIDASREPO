     H DEBUG
     H COPYRIGHT('(c) Finastra International 2022')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP OTU retrieve next layer for upgrade')         *
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP6003 - Midas UP retrieve next layer for upgrade            *
      *                                                               *
      *  Function: This program retrieves the next layer that was     *
      *            selected for upgrade.                              *
      *                                                               *
      *  (c) Finastra International Limited 2022                      *
      *                                                               *
      *  Last Amend No. CUP044 *CREATE     Date 22May22               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUP044 - One Touch Bridge Automation Changes - Release/      *
      *           Patch Upgrade                                       *
      *                                                               *
      *****************************************************************
     D SQLEOF          C                   Const( 100 )
     D SQLOK           C                   Const( 0 )
     D RcdCount        S              5  0

     D ArrLyr          S              2    DIM(11)
     D Ix              S              2S 0
     D Ixx             S              2S 0
     D Loop            S              2S 0
      ** Program data structure
     D MyPSDS         SDS
     D DFPGMQ                  1     10
     D DFJOBN                244    253
     D DFDUSR                254    263
     D DFJBNO                264    269S 0
     D DFJBNC                264    269

     D UPOPFX        E DS                  EXTNAME(UPOPFXTD)
       /EJECT
      *****************************************************************
      *                                                               *
      *  MAIN PROCESSING                                              *
      *                                                               *
      *****************************************************************

     C     *ENTRY        PLIST
     C                   PARM                    LAYER             2
     C                   PARM                    RETURN           10

     C                   eval      RETURN = *blanks


      * Retrieve layers from UPOPFXTD
     C/exec SQL
     C+ select * into :UPOPFX
     C+ from UPOPFXTD
     C/end-exec
     C                   If        SQLCode <> 0
     C                   dump
     C                   eval      RETURN = '*Error'
     C                   Return
     C                   Endif

     C                   eval      ArrLyr(1) = GPRFX
     C                   eval      ArrLyr(2) = ZPFX1
     C                   eval      ArrLyr(3) = ZPFX2
     C                   eval      ArrLyr(4) = ZPFX3
     C                   eval      ArrLyr(5) = ZPFX4
     C                   eval      ArrLyr(6) = ZPFX5
     C                   eval      ArrLyr(7) = ZPFX6
     C                   eval      ArrLyr(8) = ZPFX7
     C                   eval      ArrLyr(9) = ZPFX8
     C                   eval      ArrLyr(10) =ZPFX9
     C                   eval      ArrLyr(11) =ZPFX0

      * at first, layer passed is blank
      * find first non-blank entry, this is the layer for which to run the upgrade
     C                   IF        LAYER = '  '
     C                   DO        11            Ix
     C                   if        ArrLyr(Ix) <> *blanks
     C                   eval      LAYER = ArrLyr(Ix)
     C                   leave
     C                   endif
     C                   ENDDO

     C                   ELSE
      * if layer is non-blank, find it in the arrary and find the next non-blank entry
     C                   eval      Ix = %lookup(LAYER:ArrLyr)
     C                   eval      Loop = 11 -Ix
     C                   eval      Ix = Ix + 1
     C                   eval      LAYER = *blanks
     C                   DO        Loop          Ixx
     C                   if        ArrLyr(Ix) <> *blanks
     C                   eval      LAYER = ArrLyr(Ix)
     C                   leave
     C                   endif
     C                   eval      Ix = Ix + 1
     C                   ENDDO

     C                   ENDIF

     C                   Seton                                        LR
     C                   Return

      *****************************************************************
