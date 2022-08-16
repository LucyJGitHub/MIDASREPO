     H DEBUG
     H COPYRIGHT('(c) Finastra International 2022')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP OTU output log table')                        *
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP6002 - Midas UP OTU output log table                       *
      *                                                               *
      *  Function: This program output in the log table.              *
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

      ** Program data structure
     D MyPSDS         SDS
     D DFPGMQ                  1     10
     D DFJOBN                244    253
     D DFDUSR                254    263
     D DFJBNO                264    269S 0
     D DFJBNC                264    269

       /EJECT
      *****************************************************************
      *                                                               *
      *  MAIN PROCESSING                                              *
      *                                                               *
      *****************************************************************

     C     *ENTRY        PLIST
     C                   PARM                    PRFX              2
     C                   PARM                    CMPN              2 0
     C                   PARM                    RETURN           10

     C                   eval      RETURN = *blanks


     C/EXEC SQL
     C+ insert into UPOTBLTD
     C+ (
     C+   D_PRFX
     C+  ,D_CMPN
     C+  ,D_JBUS
     C+  ,D_JBNB
     C+  ,D_JBNM
     C+ )
     C+ Values
     C+ (
     C+   :PRFX
     C+  ,:CMPN
     C+  ,:DFDUSR
     C+  ,:DFJBNC
     C+  ,:DFJOBN
     C+ )
     C/END-EXEC
     C                   If        SQLCode <> 0
     C                   eval      RETURN = '*Error'
     C                   DUMP
     C                   Endif

     C                   Seton                                        LR
     C                   Return

      *****************************************************************
