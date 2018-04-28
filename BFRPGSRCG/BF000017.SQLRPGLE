     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGSQLMOD                                                    *
/*EXI *  TEXT('Midas BF Permissions Upload')
      *****************************************************************
      *                                                               *
      *  Midas - BankFusion Module                                    *
      *                                                               *
      *  BF000017 - Permissions Upload                                *
      *                                                               *
      *  Function:  This program writes permission data into the      *
      *              BankFusion layer                                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2014            *
      *                                                               *
      *  Last Amend No. MD019885  *CREATE  Date 04Apr14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD019885 - Permission upload interface                       *
      *           - Applied for MD026157                              *
      *                                                               *
      *****************************************************************
      /EJECT
      *
      ** +--------------------------------------+
      ** ¦ Program Prototype                    ¦
      ** ¦ =================                    ¦
      ** +--------------------------------------+
      *
      * Permission Upload Routines
     D/COPY BFCPYSRCG,BF000008
      *
     D Ret             S             10I 0
     D Mode            S              3A
     D Index           S             10A
     D Action          S              1A
     D ArtfName        S            256A
     D ArtfDesc        S            256A
     D Module          S            100A
      /EJECT
      *
      ** +--------------------------------------+
      ** ¦ MAIN                                 ¦
      ** ¦ ====                                 ¦
      ** +--------------------------------------+
      *
     C     *ENTRY        PLIST
     C                   PARM                    Ret
     C                   PARM                    Mode
     C                   PARM                    Index
     C                   PARM                    Action
     C                   PARM                    ArtfName
     C                   PARM                    ArtfDesc
     C                   PARM                    Module
      /free
 
             Ret = GenArtefact( Index
                              : Action
                              : ArtfName
                              : ArtfDesc
                              );
             If Ret = 0;
             Ret = GenPermission( Index
                                : Action
                                : ArtfDesc
                                : ArtfDesc
                                : Mode
                                : Module
                                );
             Else;
             Ret = DelPermData( Index
                              : Action
                              : ArtfName
                              );
             EndIf;
 
             If Ret = 0;
             Ret = MapArtfPerm( Index
                              : Action
                              : ArtfName
                              );
             Else;
             Ret = DelPermData( Index
                              : Action
                              : ArtfName
                              );
             EndIf;
 
             *INLR = '1';
 
      /end-free
      *****************************************************************
      /EJECT
      *****************************************************************
