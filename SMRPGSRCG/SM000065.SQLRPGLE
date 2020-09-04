     H DEBUG
     H DFTACTGRP(*NO) ACTGRP(*CALLER)
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Permission Mapping and Upload')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SM000065 - Permission Mapping and Upload                     *
      *                                                               *
      *  Function:  This program will initiate generation of records  *
      *             in the menu item - permission mapping file and    *
      *             invoke upload of permission data into BF layer    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2014            *
      *                                                               *
      *  Last Amend No. MD019885 *CREATE   Date 04Apr14               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD019885 - Permission Upload Interface                       *
      *           - Applied for MD026157                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Program Prototypes                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      * Generic Report Generator
     DUP008010         PR                  EXTPGM('UP008010')
     D Mode                           7A   CONST
     D GenPgmName                    10A   CONST
     D Message                      100A   CONST
 
      * Build permissions mapping table
     DSM000038         PR                  EXTPGM('SM000038')
     D Mode                           5A   CONST
 
      *
      ** +--------------------------------------+
      ** ¦ Work Fields and Data Structures      ¦
      ** ¦ ===============================      ¦
      ** +--------------------------------------+
      *
     D SMode           S              3A
     D Mode            S              5A
     D Map             S              4A
     D OvRdQTMENU      S              4A
     D ModuleName      S            100A
     D ReptLine        S            100A
     D Ret             S             10I 0 INZ(0)
 
     DPERM           E DS                  EXTNAME(MITB_PERMM)
 
     C     *ENTRY        PLIST
     C                   PARM                    Mode
     C                   PARM                    Map
     C                   PARM                    OvRdQTMENU
      /free
 
       Select;
         when Mode  = 'CORE';
              SMode = 'CRE';
         when Mode  = 'CUST';
              SMode = 'CST';
       EndSl;
 
       If Map = '*YES';
 
          If Mode = 'CUST';
             Exec SQL
                  Create table QTEMP/QTMENU as
                  ( select * from GZSFMENUPD
                     where ( MIINDX not like '*G%' and MIINDX not like '00%' )
                       and MIINDX not in ( select PMINDX from MITB_PERMM ))
                  with data;
          Else;
             If OvRdQTMENU = '*NO';
                Exec SQL
                     Create table QTEMP/QTMENU as
                     ( select * from GZSFMENUPD
                        where MIINDX not in ( select PMINDX from MITB_PERMM ))
                     with data;
             EndIf;
          EndIf;
 
          Exec SQL
               Create table QTEMP/MIQT_PERMM as
               (select * from MITB_PERMM) with no data;
 
          SM000038(Mode);
       EndIf;
 
       Exec SQL Declare PM cursor for
                select * from MIQT_PERMM;
 
       Exec SQL Open PM;
       Exec SQL Fetch next from PM into :PERM;
 
       DoW SQLCODE = 0;
 
           ExSr Upload;
 
           If Ret <> 0;
              ExSr CleanUp;
           EndIf;
 
           ExSr Log;
 
           Exec SQL Fetch next from PM into :PERM;
       EndDo;
       Exec SQL Close PM;
 
       UP008010('*REPORT' : 'SM000065' : '');
 
       Exec SQL Insert into MITB_PERMM
                ( select * from MIQT_PERMM);
 
       If Map = '*YES';
          Exec SQL Drop table QTEMP/QTMENU;
          Exec SQL Drop table QTEMP/MIQT_PERMM;
       EndIf;
 
       Return;
      /end-free
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Invoke Upload Routines               ¦
      ** ¦ ======================               ¦
      ** +--------------------------------------+
      *
      /free
       BegSr Upload;
      /end-free
     C                   CALL      'BF000017'
     C                   PARM                    Ret
     C                   PARM                    SMode
     C                   PARM                    PMINDX
     C                   PARM                    PMACTC
     C                   PARM                    PMARTF
     C                   PARM                    PMARTD
     C                   PARM      ''            ModuleName
      /free
       EndSr;
      /end-free
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Cleanup Previous Details             ¦
      ** ¦ ========================             ¦
      ** +--------------------------------------+
      *
      /free
       BegSr Cleanup;
 
             Exec SQL Delete from MIQT_PERMM
                       where PMINDX = :PMINDX;
 
       EndSr;
      /end-free
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Log Upload Result                    ¦
      ** ¦ =================                    ¦
      ** +--------------------------------------+
      *
      /free
       BegSr Log;
             ReptLine = 'Permission upload for menu item - action code '+
                        PMINDX + ' - ' + PMACTC;
             If Ret > 0;
                ReptLine = %trim(Reptline) + ' failed.';
             Else;
                ReptLine = %trim(Reptline) + ' successful.';
             EndIf;
 
             UP008010('*WRITE' : 'SM000065' : ReptLine );
             ReptLine = '';
       EndSr;
      /end-free
      *****************************************************************
      /EJECT
      *****************************************************************
