     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2011')
      *****************************************************************
/*XBI *  OVRDBF FILE(QTMENU) TOFILE(GPMENUPD)                         *
/*XBI *  OVRDBF FILE(MIQT_PERMM) TOFILE(MITB_PERMM)                   *
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Generate Permission Mapping')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SM000038 - Generate Permission Mapping                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2014            *
      *                                                               *
      *  Last Amend No. MD019885 *CREATE   Date 04Apr14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD019885 - Permission Upload Interface                       *
      *           - Applied for MD026157                              *
      *                                                               *
      *****************************************************************
      *
     D MenuCode        S             10
     D Action          S              1
     D ActionText      S             10
     D LastPMINDX      S             10
     D MenuINDX        S             10
     D FoundPos        S              3  0
     D x               S              2  0
     D CharCheck       S              1
     D PermMCnt        S              1  0
     D Permission      S            256
     D PermissionD     S            256
     D PermissionRoot  S            256
     D Recursive       S              1    INZ('N')
     D Counter         S              4  0
      *
     D LowerCase       S              1    DIM(26) CTDATA PERRCD(26)
     D UpperCase       S              1    DIM(26) CTDATA PERRCD(26)
      *
     D MENU          E DS                  EXTNAME(GPMENUPD)
     D BFPM          E DS                  EXTNAME(MITB_PERMM)
      *
      *
     C     *ENTRY        PLIST
     C                   PARM                    Mode              5
      *
      /free
       Exec SQL
        Declare QT cursor for
            Select * from QTMENU order by MIINDX;
 
       Exec SQL Open QT;
 
       Exec SQL
        Fetch next
        from QT
        into :MENU;
 
       DoW SQLCODE = 0;
 
           MenuCode = MIINDX;
           PermMCnt = 0;
 
           Exec SQL
            Select count(*) into :PermMCnt from MITB_PERMM
            where PMINDX = :MenuCode;
 
           If PermMCnt = 0;
              Exec SQL
               Select count(*) into :PermMCnt from MIQT_PERMM
               where PMINDX = :MenuCode;
           EndIf;
 
           If PermMCnt = 0;
 
              If MIAAC1 <> *Blanks;
                 Action = MIAAC1;
                 ExSr WriteRec;
              EndIf;
 
              If MIAAC2 <> *Blanks;
                 Action = MIAAC2;
                 ExSr WriteRec;
              EndIf;
 
              If MIAAC3 <> *Blanks;
                 Action = MIAAC3;
                 ExSr WriteRec;
              EndIf;
 
              If MIAAC4 <> *Blanks;
                 Action = MIAAC4;
                 ExSr WriteRec;
              EndIf;
 
              If MIAAC5 <> *Blanks;
                 Action = MIAAC5;
                 ExSr WriteRec;
              EndIf;
 
              If MIAAC6 <> *Blanks;
                 Action = MIAAC6;
                 ExSr WriteRec;
              EndIf;
 
              If MIAAC7 <> *Blanks;
                 Action = MIAAC7;
                 ExSr WriteRec;
              EndIf;
 
              If MIAAC8 <> *Blanks;
                 Action = MIAAC8;
                 ExSr WriteRec;
              EndIf;
 
              If MIAAC9 <> *Blanks;
                 Action = MIAAC9;
                 ExSr WriteRec;
              EndIf;
 
              If MIAAC10 <> *Blanks;
                 Action = MIAAC10;
                 ExSr WriteRec;
              EndIf;
 
           EndIf;
 
           Exec SQL
            fetch next
            from QT
            into: MENU;
 
       EndDo;
 
       Exec SQL Close QT;
 
       // Now read through the permission mapping file to build description.
 
       Exec SQL Declare PM cursor for
          Select * from MIQT_PERMM;
 
       Exec SQL Open PM;
       Exec SQL Fetch next from PM into :BFPM;
 
       DoW SQLCODE = 0;
 
           Exec SQL
            Select count(*)
              into :Counter
              from GPMTXTPD b, T_GRMENUG c, T_GRMENUL d
             where b.MIINDX   = d.MLMENUCODE
               and d.MLPARENT = c.MGID
               and b.MIINDX   = :PMINDX;
 
           ExSr UpdDescr;
 
           Exec SQL Fetch next from PM into :BFPM;
 
       EndDo;
 
       Exec SQL Close PM;
 
       // Now read through the permissions file to build the Artefact Name
 
       Exec SQL Declare PM2 cursor for
          Select * from MIQT_PERMM;
 
       Exec SQL Open PM2;
       Exec SQL Fetch next from PM2 into :BFPM;
 
       DoW SQLCODE = 0;
 
        // Only remove blanks once per different menu item.
 
           If PMINDX <> LastPMINDX;
              LastPMINDX = PMINDX;
              If PMARTD <> ' ';
                 ExSr RemoveBlanks;
              Else;
                 PermissionRoot = PMINDX;
              EndIf;
           EndIf;
           ActionText = '';
 
        // Try to obtain suffix for Non-Standard Action Codes
 
           Exec SQL
            select EXSUFX into :ActionText
              from MITB_ASFEX
             where EXACTC = trim(:PMACTC)
               and EXINDX = trim(:PMINDX);
 
           If ActionText = '';
 
        // Try to obtain suffix for Standard Action Codes
 
           Exec SQL
            select SFSUFX into :ActionText
              from MITB_ASSFX
             where SFACTC = trim(:PMACTC);
 
           EndIf;
 
        // If no suffix is found use Action Code
 
           If ActionText = *Blanks;
              ActionText = PMACTC;
           EndIf;
 
           MenuINDX = PMINDX;
 
           Permission = 'MI_MNU_' + %trim(Mode) + '_' +
                        %trim(MenuINDX) + '_' +
                        %TRIMR(PermissionRoot) + '_' + PMACTC;
 
           PermissionD =  %trim(PMARTD) + ' - ' + %trim(ActionText);
 
           Exec SQL
            Update MIQT_PERMM
               set PMARTF = trim(replace(:Permission, '*', ''))
                 , PMARTD = trim(:PermissionD)
             where PMINDX = :PMINDX
               and PMACTC = :PMACTC;
 
           Exec SQL Fetch next from PM2 into :BFPM;
 
       EndDo;
       Exec SQL Close PM2;
 
       // Remove known special characters in Artefact Names generated.
 
       Exec SQL
        Update MIQT_PERMM SET PMARTF = REPLACE(PMARTF,'/','');
 
       Exec SQL
        Update MIQT_PERMM SET PMARTF = REPLACE(PMARTF,',','');
 
       Exec SQL
        Update MIQT_PERMM SET PMARTF = REPLACE(PMARTF,')','');
 
       Exec SQL
        Update MIQT_PERMM SET PMARTF = REPLACE(PMARTF,'(','');
 
       Exec SQL
        Update MIQT_PERMM SET PMARTF = REPLACE(PMARTF,'%','');
 
       Exec SQL
        Update MIQT_PERMM SET PMARTF = REPLACE(PMARTF,'-','');
 
       Exec SQL
        Update MIQT_PERMM SET PMARTF = REPLACE(PMARTF,'.','');
 
       Exec SQL
        Update MIQT_PERMM SET PMARTF = REPLACE(PMARTF,'''','');
 
       Exec SQL
        Update MIQT_PERMM set PMARTF = replace(pmartf,'§','Section');
       Exec SQL
        Update MIQT_PERMM set PMARTD = replace(pmartd,'§','Section');
 
       Exec SQL
        Update MIQT_PERMM set PMARTF = replace(pmartf,'&','And');
 
       *INLR = *ON;
       Return;
 
      /end-free
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Update Description Field             ¦
      ** ¦ ========================             ¦
      ** +--------------------------------------+
      *
      /free
       BegSr UpdDescr;
             If Counter > 1;
 
                Exec SQL
                 Update MIQT_PERMM
                    set PMARTD =
                        (select concat(trim(c.MGNAME),
                                concat('_',trim(b.MIINAR)))
                           from GPMTXTPD b, T_GRMENUG c, T_GRMENUL d
                          where b.MIINDX = :PMINDX
                            and d.MLMENUCODE = :PMINDX
                            and d.MLPARENT = c.MGID)
                  where PMINDX = :PMINDX
                    and PMACTC = :PMACTC;
 
             Else;
 
                Exec SQL
                 Update MIQT_PERMM
                    set PMARTD = (select trim(MIINAR)
                                    from GPMTXTPD where MIINDX = :PMINDX)
                  where PMINDX = :PMINDX
                    and PMACTC = :PMACTC;
       EndIf;
 
       EndSr;
 
      /end-free
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Write Record to Mapping File         ¦
      ** ¦ ============================         ¦
      ** +--------------------------------------+
      *
      /free
       BegSr WriteRec;
 
             Exec SQL
              Insert into MIQT_PERMM (
              PMINDX, PMACTC, PMARTF, PMARTD
              )
              values (
              :MenuCode, :Action, ' ', ' '
              );
 
       EndSr;
      /end-free
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Format Description for Artefact Name ¦
      ** ¦ ==================================== ¦
      ** +--------------------------------------+
      *
     C     RemoveBlanks  BEGSR
      *
     C                   EVAL      Permission = PMARTD
     C                   EVAL      FoundPos = %SCAN(' ':Permission:1)
     C                   DOU       FoundPos <= 0 or
     C                             FoundPos = 256
     C                   EVAL      %SUBST(Permission:FoundPos:(255 - FoundPos))
     C                             = %SUBST(Permission:(FoundPos + 1):
     C                             (256 - FoundPos))
      *
      ** Check if the next character is lower case and change it to upper.
      *
     C                   IF        FoundPos <> 256
     C                   EVAL      CharCheck = %SUBST(Permission:FoundPos)
     C                   EVAL      x = %LOOKUP(CharCheck:LowerCase)
     C                   IF        x <> 0
     C                   EVAL      %SUBST(Permission:FoundPos:1) =
     C                             UpperCase(x)
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      FoundPos = %SCAN(' ':Permission:
     C                             (FoundPos + 1))
     C                   ENDDO
     C                   EVAL      PermissionRoot = Permission
      *
     C     RemoveBlanksE ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program Exception Error Routine                     *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        Recursive = *blanks
     C                   EVAL      Recursive = 'Y'
     C                   DUMP
      *
     C                   ENDIF
      *
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C     PSSRE         ENDSR
      *
      *****************************************************************
** LowerCase
abcdefghijklmnopqrstuvwxyz
** UpperCase
ABCDEFGHIJKLMNOPQRSTUVWXYZ
