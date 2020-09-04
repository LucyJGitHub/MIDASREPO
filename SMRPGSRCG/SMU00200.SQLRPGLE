     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Apply Permission Patch')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00200 - Midas SM Upgrade for Permission Patch Application *
      *                                                               *
      *  Last Amend No. MD020108 *CREATE   Date 18Apr13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD020108 - Permissions Patch                                 *
      *                                                               *
      *****************************************************************
      *
     DPERM           E DS                  EXTNAME(SMNWPMTD)
     DCOUNT            S              5  0
      *
     DMPrmCount        S              2  0
 
      /free
 
       ExSr ProcModules;
 
       EXEC SQL
        Declare Pcursor cursor for
        Select NPINDX, NPACTC, NPARTF,
               value(NPMMOD, ''), value(NPDESC, ''), NPREMV
        from   SMNWPMTD;
 
       EXEC SQL Open Pcursor;
 
       EXEC SQL
        Fetch NEXT from Pcursor into :PERM;
 
                 Count = 0;
 
                 DoW SQLCODE = 0;
 
                 If  NPREMV = 'Y';
                     ExSr Remove;
                 EndIf;
                 If  NPREMV = 'N';
                     ExSr Rename;
                 EndIf;
 
       EXEC SQL
        Fetch NEXT from Pcursor into :PERM;
 
                 EndDo;
 
       EXEC SQL
        Close Pcursor;
 
                 *INLR = *ON;
                 Return;
 
       //-------------------------------------------------------------*
       // Process permissions for removal                             *
       //-------------------------------------------------------------*
          BegSr Remove;
 
             Exec SQL
             Delete from BFTB_RESOURCE
                    where BFARTEFACTID = :NPARTF;
 
             Exec SQL
             Delete from BFTB_PERMISSION
                    where BFIDPK in
                    (select BFPERMISSIONID
                     from BFTB_RESOURCEPERM
                     where trim(BFRESOURCEID) = trim(:NPARTF));
 
             Exec SQL
             Delete from BFTB_GROUPPERMMAP
                    where BFPERMISSIONID in
                    (select BFPERMISSIONID
                     from BFTB_RESOURCEPERM
                     where trim(BFRESOURCEID) = trim(:NPARTF));
 
             Exec SQL
             Delete from BFTB_RESOURCEPERM
                    where trim(BFRESOURCEID) = trim(:NPARTF);
 
             Exec SQL
             Delete from MITB_PERMM
                    where trim(PMARTF) = trim(:NPARTF);
 
             Exec SQL
             Select count(*) into :MPrmCount from MITB_PERMM
                    where PMINDX = :NPINDX;
 
             If MPrmCount < 1;
                Exec SQL
                Update GPMTXTPD
                       set MIDEL = 'Y'
                       where MIINDX = :NPINDX;
             EndIf;
 
          EndSr;
 
       //-------------------------------------------------------------*
       // Process permissions for retention and rename                *
       //-------------------------------------------------------------*
          BegSr Rename;
 
             Exec SQL
             Update BFTB_RESOURCE
                    set BFDISPLAYNAME = :NPDESC
                      , BFDESCRIPTION = :NPDESC
                    where trim(BFARTEFACTID) = (:NPARTF);
 
             Exec SQL
             Update BFTB_PERMISSION
                    set BFSHORTDESCRIPTION = :NPDESC
                      , BFLONGDESCRIPTION = :NPDESC
                      , BFHOSTMODULEID = :NPMMOD
                    where BFIDPK in
                    (select BFPERMISSIONID
                     from BFTB_RESOURCEPERM
                     where (BFRESOURCEID) = (:NPARTF));
 
             Exec SQL
             Update MITB_PERMM
                    set PMARTD = :NPDESC
                    where trim(PMARTF) = trim(:NPARTF);
 
          EndSr;
       //-------------------------------------------------------------*
       // Process all modules                                         *
       //-------------------------------------------------------------*
          BegSr ProcModules;
 
          Exec SQL
               Insert into BFTB_HOSTMODULE
               (BFHOSTMODULEIDPK, BFHOSTMODULESHORTNAME
               , BFHOSTMODULEDISPLAYNAME, BFHOSTID, BFRECCREATEDBY)
               select distinct NPMMOD, NPMMOD, NPMMOD, 'MIDAS', 'system'
               from SMNWPMTD where length(NPMMOD) > 1;
 
          EndSr;
      /end-free
