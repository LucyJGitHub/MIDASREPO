     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Initialise AUTOAUTH')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SM000061 - Midas SM AUTOAUTH Security Data Initialisation    *
      *                                                               *
      *  Function:  This program will initialise the security data    *
      *             setup (permissions and entitlements) for          *
      *             AUTOAUTH profile                                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. MD020456           Date 23May13               *
      *  Prev Amend No. MD018386C          Date 23Apr13               *
      *                 AR1081696 *CREATE  Date 12Feb13               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD020456 - BF Upload menu option UPLD doesn t upload         *
      *             entitlements to BFTB tables                       *
      *  MD018386C - Update for BFP3.1 patch changes                  *
      *  AR1081696 - Include AUTOAUTH initialisation BF Upload        *
      *              Applied for AR1083560.                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  CreateRole - Creates AUTOAUTH role                           *
      *  ResetRole - Repopulates AUTOAUTH role with permissions       *
      *  RevokeCurrAuth - Revoke role and entitlements of AUTOAUTH    *
      *  ApplyAuth - (re)Assign role and entitlements                 *
      *                                                               *
      *****************************************************************
     D EntType         S             50    INZ('Branch')
     D RoleExists      S              2  0 INZ(0)
     D GroupId         S             20
     D DynaSQL         S            256    INZ('')
 
      /free
 
       // MAIN
       //---------------------------------*
 
       // Check if AUTOAUTH role already exists
         Exec SQL
              Select count(*) into :RoleExists
              from BFTB_ORGANISATIONGRP
              where BFGROUPNAME = 'AUTOAUTH';
 
         If RoleExists = 0;
              ExSr CreateRole;
         EndIf;
 
         ExSr ResetRole;
         ExSr RevokeCurrAuth;
         ExSr ApplyAuth;
 
         *INLR = *ON;
         Return;
 
       // SUBROUTINES
       //---------------------------------*
       //-------------------*
       // Create Role       |
       //-------------------*
         BegSr CreateRole;
           Exec SQL
                Insert into BFTB_ORGANISATIONGRP
                ( BFGROUPIDPK, BFGROUPDISPLAYNAME, BFGROUPPARENTID, VERSIONNUM
       //*******,*BFGROUPNAME, BFUSERID )                                                //MD018386C
                , BFGROUPNAME, BFRECCREATEDBY)                                           //MD018386C
                values
                ( 'AUTOAUTH', 'Auto-Authorise Profile', 1, 0
                , 'AUTOAUTH', 'system');                                                 //MD018386C
 
         // Populate audit fields, if exists
           DynaSQL = 'Update BFTB_ORGANISATIONGRP '
                     + 'set BFRECCREATEDBY = ''system'''
                     + ', BFRECCREATEDON = now() '
       //**********  + 'where BFGROUPID = ''AUTOAUTH''';                                 //MD018386C
                     + 'where BFGROUPIDPK = ''AUTOAUTH''';                               //MD018386C
 
           Exec SQL
                Prepare ORAudit from :DynaSQL;
 
           If SQLCode = 0;
              Exec SQL
                   Execute ORAudit;
           EndIf;
 
         EndSr;
 
       //-------------------*
       // Reset Role        |
       //-------------------*
         BegSr ResetRole;
         // Retrieve BFGROUPID
           Exec SQL
                select BFGROUPIDPK into :GroupId
                from BFTB_ORGANISATIONGRP
                where BFGROUPNAME = 'AUTOAUTH';
 
         //Update permissions attached to AUTOAUTH role
           Exec SQL
                Delete from BFTB_GROUPPERMMAP
                where BFGROUPID = :GroupId;
 
           Exec SQL
                Insert into BFTB_GROUPPERMMAP
                (BFIDPK, BFPERMISSIONID, VERSIONNUM, BFGROUPID)
                ( select
         //*********'AUTO' || A.MIINDX || B.PMACTC                                        //MD020456
                      concat(concat('AUTO', A.MIINDX), B.PMACTC)                          //MD020456
                    , C.BFPERMISSIONID
                    , 0
                    , :GroupId
                  from ( select distinct MIINDX from GZSFMENUPD
                          where MIAPI1 <> '' ) as A
                  left join MITB_PERMM B
                         on A.MIINDX = B.PMINDX
                  left join BFTB_RESOURCEPERM C
                         on B.PMARTF = C.BFRESOURCEID
                  where B.PMACTC in ('E', 'X'));
 
         // Populate audit fields, if exists
           DynaSQL = 'Update BFTB_GROUPPERMMAP '
                     + 'set BFRECCREATEDBY = ''system'''
                     + ', BFRECCREATEDON = now() '
         //**********+ 'where BFGROUPID = ' + GroupId;                                   //MD018386C
                     + 'where BFGROUPID = ''' + GroupId + '''';                          //MD018386C
 
           Exec SQL
                Prepare GPAudit from :DynaSQL;
 
           If SQLCode = 0;
              Exec SQL
                   Execute GPAudit;
           EndIf;
 
         EndSr;
 
       //---------------------------*
       // Revoke Current Authority  |
       //---------------------------*
         BegSr RevokeCurrAuth;
         // Revoke AUTOAUTH of roles/entitlements, if any
 
           Exec SQL
                Delete from BFTB_ORGGROUPUSER where BFUSERNAME = 'AUTOAUTH';
           Exec SQL
                Delete from BFTB_ENTITLEMENTS where BFUSERNAME = 'AUTOAUTH';
         EndSr;
 
       //---------------------*
       // Re/Apply Authority  |
       //---------------------*
         BegSr ApplyAuth;
         // (Re)Assign role to AUTOAUTH and entitle to all branches.
           Exec SQL
                Insert into BFTB_ORGGROUPUSER
                  ( BFSEQUENCEIDPK, BFGROUPID, BFUSERNAME, VERSIONNUM)
                values
                  ( 'AUTOAUTH'
                  , :GroupId
                  , 'AUTOAUTH'
                  , 0 );
 
           Exec SQL
                Insert into BFTB_ENTITLEMENTS
                  ( BFIDPK, BFGROUPNAME, BFENTITLEMENTTYPE, BFENTITLEMENTVALUE
                  , BFUSERNAME, VERSIONNUM, BFDESCRIPTION )
                  ( select
         //**********'AUTOAUTH' || A8BRCD                                                 //MD020456
                     concat('AUTOAUTH',A8BRCD)                                            //MD020456
                   , 'AUTOAUTH'
                   , :EntType
                   , A8BRCD
                   , 'AUTOAUTH'
                   , 0
                   , A8BRNM
                   from GZSDBRCHPD );
 
         // Populate audit fields, if exists
           DynaSQL = 'Update BFTB_ENTITLEMENTS '
                     + 'set BFRECCREATEDBY = ''system'''
                     + ', BFRECCREATEDON = now() '
                     + 'where BFUSERNAME = ''AUTOAUTH''';
 
           Exec SQL
                Prepare ENAudit from :DynaSQL;
 
           If SQLCode = 0;
              Exec SQL
                   Execute ENAudit;
           EndIf;
 
           DynaSQL = 'Update BFTB_ORGGROUPUSER '
                     + 'set BFRECCREATEDBY = ''system'''
                     + ', BFRECCREATEDON = now() '
                     + 'where BFUSERNAME = ''AUTOAUTH''';
 
           Exec SQL
                Prepare OGAudit from :DynaSQL;
 
           If SQLCode = 0;
              Exec SQL
                   Execute OGAudit;
           EndIf;
 
         EndSr;
 
 
 
      /end-free
 
      *****************************************************************
      /EJECT
