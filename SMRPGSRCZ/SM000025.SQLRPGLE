     H DEBUG
     H COPYRIGHT('(c)Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Update AUTOAUTH profile')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SM000025 - Update AUTOAUTH profile                           *
      *                                                               *
      *  (c)Finastra International Limited 2005                       *
      *                                                               *
      *  Last Amend No. MD046248           Date 05Feb18               *
      *  Prev Amend No. MD019986           Date 12Apr13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BG8125  *CREATE    Date 02Nov05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD019986 - Remove MACBRDD processing for AUTOAUTH setup      *
      *  BG8125 - AUTOAUTH user doesn't get setup in MUSER            *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     F***MACBR*****IF   E           K DISK    INFSR(*PSSR)                                  MD019986
     FMUSER     UF   E           K DISK    INFSR(*PSSR)
     FMBROS     UF A E           K DISK    INFSR(*PSSR)
     FMBRBS     UF A E           K DISK    INFSR(*PSSR)

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+

     D/COPY ZACPYSRC,STD_D_SPEC
      ** Data Area Giving Installation Control Details

     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** External DS for branch details

     D DSFDY         E DS                  EXTNAME(DSFDY)
      * First DS for access programs, short data strucure

     D BrchArray       S              3    Dim(900)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D KeyUser         S                   Like(USRP)
     D Idx             S              3  0
     D WorkVBRX        S                   Like(VBRX)
     D StartPos        S              4  0
     D Len             S              4  0

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************

      ** Update default branch for AUTOAUTH profile on MUSERDD
     C                   Eval      KeyUser = 'AUTOAUTH'
     C     KeyUser       Chain(e)  MUSER
      *
      ** Database error
     C                   If        %Error or not %Found
     C                   MoveL     KeyUser       DBKEY
     C                   MoveL     'MUSERDD '    DBFILE                         ************
     C                   MoveL     '001'         DBASE                          * DBERR 001*
     C                   ExSr      *Pssr                                        ************
     C                   EndIf

      ** Get a default branch
     C                   Call      'AOBRCHR0'
     C                   Parm                    @RtCd
     C                   Parm      '*FIRST '     @Optn
     C                   Parm                    @DSNB             3
     C     SDBRCH        Parm      SDBRCH        DSFDY
      *
      ** Database error
     C                   If        @RTCD <> *BLANK
     C                   MoveL     '*FIRST'      DBKEY
     C                   MoveL     'SDBRCHPD'    DBFILE                         ************
     C                   MoveL     '002'         DBASE                          * DBERR 002*
     C                   ExSr      *Pssr                                        ************
     C                   EndIf

     C                   Eval      DBRN = A8BRCD
     C                   Update    MUSERDDF

      ***Check*that*the*user*profile*doesn't*already*exist*on*MACBR****                     MD019986
     C*****KeyUser       Chain(e)  MACBR                                                    MD019986
     C**********         If        %Found                                                   MD019986
     C**********         Eval       INLR =  On                                              MD019986
     C**********         Return                                                             MD019986
     C**********         EndIf                                                              MD019986
      **********                                                                            MD019986
      ***Authorise*the*user*profile*to*all*switched*on*API's*where*****                     MD019986
      ***there*is*an*authorising*function******************************                     MD019986
     C*/EXEC*SQL                                                                            MD019986
     C*+*Insert*into MACBRDD select distinct                                                MD019986
     C*+*'D',*'AUTOAUTH', 0, ' ', A8BRCD , 'E', 'X', ' ',                                   MD019986
     C*+*'*',*'*', ' ', ' ', ' ', ' ', ' ', 0, ' ', 0,                                      MD019986
     C*+*MIINDX, ' ' FROM sfmenuj0, sdbrchpd                                                MD019986
     C*+*WHERE*MIALLAC like '%X%' and MIINDX in                                             MD019986
     C*+*(select MIINDX from sfmenupd where MIAPI1 <> ' ' )                                 MD019986
     C*/END-EXEC                                                                            MD019986
      **********                                                                            MD019986
      **Check*for*successful*completion********************************                     MD019986
     C**********         If        SQLCOD <> 0                                              MD019986
     C**********         ExSR      *PSSR                                                    MD019986
     C**********         EndIf                                                              MD019986

      ** Get all remaining branches
     C                   Eval      Idx = 0

     C                   DoU       @RtCd = '*EOF' or
     C                             Idx = 900
     C                   Eval      Idx += 1
     C                   Eval      BrchArray(Idx) = A8BRCD

     C                   Call      'AOBRCHR0'
     C                   Parm                    @RtCd
     C                   Parm      '*NEXT  '     @Optn
     C                   Parm                    @DSNB
     C     SDBRCH        Parm      SDBRCH        DSFDY
      *
      ** Database error
     C                   If        @RtCd <> *BLANK and
     C                             @RtCd <> '*EOF'
     C                   MoveL     '*NEXT '      DBKEY
     C                   MoveL     'SDBRCHPD'    DBFILE                         ************
     C                   MoveL     '003'         DBASE                          * DBERR 003*
     C                   ExSr      *Pssr                                        ************
     C                   EndIf

     C                   EndDo

      ** Set up profile on MBROSDD, MBRBSDD
     C     KeyUser       Chain(e)  MBROS
     C                   Eval      RECI = 'D'
     C                   Eval      NOBR = Idx
     C                   Eval      StartPos = %Len(VBRX) - (Idx * 3) +  1
     C                   Eval      Len = Idx * 3
     C                   MoveA     BrchArray     WorkVBRX
     C                   Eval      %Subst(VBRX:StartPos:Len) =
     C                             %Subst(WorkVBRX:1:Len)
     C                   If        %Found
     C                   Update    MBROSDDF
     C                   Else
     C                   Write     MBROSDDF
     C                   EndIf

     C     KeyUser       Chain(e)  MBRBS
     C                   If        %Found
     C                   Eval      RECI = 'D'
     C                   Eval      NOBR = Idx
     C                   Eval      %Subst(VBRX:StartPos:Len) =
     C                             %Subst(WorkVBRX:1:Len)
     C                   Update    MBRBSDDF
     C                   Else
     C                   Write     MBRBSDDF
     C                   EndIf

     C                   Eval      *INLR = *On
     C                   Return

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program Exception Error Routine                     *
      *                                                               *
      *****************************************************************

     C     *PSSR         BegSr

     C                   If        RunBefore = *BLANKS
     C                   Eval      RunBefore = 'Y'
     C                   Dump

     C                   Call      'DBERRCTL'

     C                   EndIf

     C                   Eval      *INU7 = *ON
     C                   Eval      *INU8 = *ON
     C                   Eval      *INLR = *ON
     C                   Return

     C                   EndSr

