     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Initialise ggBFMADM')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SM000063 - Midas SM ggBFMADM Security Data Initialisation    *
      *                                                               *
      *  Function:  This program will initialise the security data    *
      *             setup (permissions and entitlements) for          *
      *             ggBFMADM profile                                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. MD020456           Date 23May13               *
      *  Prev Amend No. MD018386C          Date 23Apr13               *
      *                 MD018386B          Date 22Apr13               *
      *                 AR1088235 *CREATE  Date 13Feb13               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD020456  - BF Upload menu option UPLD doesn t upload        *
      *              entitlements to BFTB tables                      *
      *  MD018386C - Update for BFP3.1 patch changes                  *
      *  MD018386B - Include ggBFMSUP supervisor profile              *
      *  AR1088235 - Include ggBFMADM initialisation BF Upload        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  CreateUser - Creates BFMADM user                             *
      *             - and BFMSUP user                                 *
      *  CreateRole - Creates BFMADMIN role                           *
      *  ResetRole - Repopulates BFADMIN role with permissions        *
      *  RevokeCurrAuth - Revoke role and entitlements of ggBFMADM    *
      *  ApplyAuth - (re)Assign role and entitlements                 *
      *                                                               *
      *****************************************************************
     D EntType         S             50    INZ('Branch')
     D GroupId         S             20
     D RoleExists      S              1  0
     D UserExists      S              1  0
     D SysValRet       S              7A
     D wGPrefSVal      S            200A
     D PassExp         S               d
     D AdminUser       S             10
     D SupvsUser       S             10                                                  //MD018386B
     D UserZone        S              2
     D DefBranch       S              3
     D DynaSQL         S            256A
      *
      ** Prototypes
      *
     D GPAOSVALR0      PR                  EXTPGM('GPAOSVALR0')
     D   P@RTCD                       7A
     D   P@OP01                      20A   CONST
     D   P@VL01                     200A
     D   P@OP02                      20A   CONST
     D   P@VL02                     200A   CONST
     D   P@OP03                      20A   CONST
     D   P@VL03                     200A   CONST
     D   P@OP04                      20A   CONST
     D   P@VL04                     200A   CONST
     D   P@OP05                      20A   CONST
     D   P@VL05                     200A   CONST
     D   P@OP06                      20A   CONST
     D   P@VL06                     200A   CONST
     D   P@OP07                      20A   CONST
     D   P@VL07                     200A   CONST
     D   P@OP08                      20A   CONST
     D   P@VL08                     200A   CONST
     D   P@OP09                      20A   CONST
     D   P@VL09                     200A   CONST
     D   P@OP10                      20A   CONST
     D   P@VL10                     200A   CONST
      *
      /free
 
       // MAIN
       //---------------------------------*
 
       // Purge pre-existing ggBFMADM User/s
         Exec SQL
              Delete
              from BFTB_USER
              where BFNAMEPK like '%BFMADM';
 
         Exec SQL
              Delete
              from BFTB_ZONEUSER
              where BFUSERID like '%BFMADM';
 
       // Purge pre-existing ggBFMSUP User/s                                             //MD018386B
         Exec SQL                                                                        //MD018386B
              Delete                                                                     //MD018386B
              from BFTB_USER                                                             //MD018386B
              where BFNAMEPK like '%BFMSUP';                                             //MD018386B
                                                                                         //MD018386B
         Exec SQL                                                                        //MD018386B
              Delete                                                                     //MD018386B
              from BFTB_ZONEUSER                                                         //MD018386B
              where BFUSERID like '%BFMSUP';                                             //MD018386B
 
         ExSr CreateUser;
 
       // Check if ggBFMADM role already exists
         Exec SQL
              Select count(*) into :RoleExists
              from BFTB_ORGANISATIONGRP
              where BFGROUPNAME = 'BFMADMIN';
 
         If RoleExists = 0;
              ExSr CreateRole;
         EndIf;
 
         ExSr ResetRole;
         ExSr RevokeCurrAuth;
         ExSr ApplyAuth;
 
         Exec SQL
              Delete from BFTB_PERSISTENTTAG
              where BFPERSISTENTTAGSIDPK = 'BF';
 
         Exec SQL
              Insert into BFTB_PERSISTENTTAG
              (BFPERSISTENTTAGSIDPK, BFWEBSERVICEAVAILABILITY, BFISPAUSED,
              BFBASECURRENCYCODE, VERSIONNUM, BFBALANCEFROZEN,
              BFAUTHENTICATEWEBSERVICES, BFISATMONLINE)
              values
              ('BF', 0, 'N', '***', 1, 0, 1, 'N');
                                                                                         //MD018386C
         Exec SQL Update BFTB_USER set BFNAMEPK = trim(BFNAMEPK);                        //MD018386C
         Exec SQL Update BFTB_ZONEUSER set BFUSERID= trim(BFUSERID);                     //MD018386C
         Exec SQL Update BFTB_ORGGROUPUSER                                               //MD018386C
                     set bfsequenceidpk = trim(bfsequenceidpk),                          //MD018386C
                         bfgroupid = trim(bfgroupid),                                    //MD018386C
                         bfusername = trim(bfusername);                                  //MD018386C
         Exec SQL Update BFTB_GROUPPERMMAP set BFGROUPID = trim(BFGROUPID);              //MD018386C
         Exec SQL Update BFTB_ENTITLEMENTS set BFUSERNAME = trim(BFUSERNAME);            //MD018386C
 
         *INLR = *ON;
         Return;
 
       // SUBROUTINES
       //---------------------------------*
       //-------------------*
       // Create User       |
       //-------------------*
         BegSr CreateUser;
 
           GPAOSVALR0(SysValRet
                      :'BrgMidasGlobalPrefix'
                      :wGPrefSVal
                      :' ':' ':' ':' '
                      :' ':' ':' ':' ':' ':' ':' '
                      :' ':' ':' ':' ':' ':' ':' ');
 
           AdminUser = %trim(wGPrefSval) + 'BFMADM';
           SupvsUser = %trim(wGPrefSval) + 'BFMSUP';                                     //MD018386B
 
           Exec SQl
                select ZOMSYS into :UserZone
                from GPZONEPD
                fetch first 1 rows only;
 
           Exec SQl
                select A8BRCD into :DefBranch
                from GZSDBRCHPD
                fetch first 1 rows only;
 
           Exec SQL
                Insert into BFTB_USER
                ( BFNAMEPK, BFZONE, VERSIONNUM, BFUSERTYPE
                , BFINVALIDPASSWORDATTEMPTS, BFLOCKEDOUT
                , BFPASSWORDEXPIRYDATE, BFPASSWORDEXPIRYIND
       //*******,*BFREAUTHENTICATION, BFBMBRANCH, BFLOGINSTATUS                          //MD018386B
                , BFREAUTHENTICATION, BFBMBRANCH                                         //MD018386B
                , BFRECCREATEDBY, BFRECCREATEDON, BFRECSYSDATE                           //MD018386B
                , BFLANGUAGELOCALE, BFCOUNTRYLOCALE, BFUSERID
                , BFVARIANTLOCALE )
                values
                ( :SupvsUser                                                             //MD018386B
                , :UserZone                                                              //MD018386B
                , 0 , 'S', 0, 0, (CURRENT_DATE + 2 YEARS), 0, 0                          //MD018386B
                , :DefBranch                                                             //MD018386B
                , 'system', Now(), Now()                                                 //MD018386B
                , 'en', 'GB', 'BF Midas BFTC SupervisorProfile', 'GB' ),                 //MD018386B
                ( :AdminUser
                , :UserZone
                , 0 , 'S', 0, 0, (CURRENT_DATE + 2 YEARS), 0, 0
                , :DefBranch
       //*******,*0, 'en', 'GB', 'BF Midas BFTC Admin Profile', 'GB' );                  //MD018386B
                , 'system', Now(), Now()                                                 //MD018386B
                , 'en', 'GB', 'BF Midas BFTC Admin Profile', 'GB' );                     //MD018386B
 
           Exec SQL
                Insert into BFTB_ZONEUSER
                ( BFUSERID, BFLINKIDPK, BFZONE, VERSIONNUM)
       //*******( select :AdminUser, 'ADM' || ZOMSYS, ZOMSYS, 0 from GPZONEPD);           //MD020456
                ( select :AdminUser, concat('ADM',ZOMSYS)                                 //MD020456
                       , ZOMSYS, 0 from GPZONEPD);                                        //MD020456
 
           Exec SQL                                                                      //MD018386B
                Insert into BFTB_ZONEUSER                                                //MD018386B
                ( BFUSERID, BFLINKIDPK, BFZONE, VERSIONNUM)                              //MD018386B
       //*******( select :SupvsUser, 'SUP' || ZOMSYS, ZOMSYS, 0 from GPZONEPD); //MD018386B MD020456
                ( select :SupvsUser, concat('SUP',ZOMSYS)                                 //MD020456
                       , ZOMSYS, 0 from GPZONEPD);                                        //MD020456
                                                                                         //MD018386B
           Exec SQL
                Delete from BFTB_USER
 
                where BFNAMEPK = 'system';
           Exec SQL
                Insert into BFTB_USER
                ( BFNAMEPK, BFZONE, VERSIONNUM, BFUSERTYPE
                , BFINVALIDPASSWORDATTEMPTS, BFLOCKEDOUT
                , BFPASSWORDEXPIRYDATE, BFPASSWORDEXPIRYIND
       //*******,*BFREAUTHENTICATION, BFBMBRANCH, BFLOGINSTATUS                          //MD018386B
                , BFREAUTHENTICATION, BFBMBRANCH                                         //MD018386B
                , BFRECCREATEDBY, BFRECCREATEDON, BFRECSYSDATE                           //MD018386B
                , BFLANGUAGELOCALE, BFCOUNTRYLOCALE, BFUSERID
                , BFVARIANTLOCALE )
                values
                ( 'system'
                , :UserZone
                , 0 , 'S', 0, 0, (CURRENT_DATE + 2 YEARS), 0, 0
                , :DefBranch
       //*******,*0, 'en', 'GB', 'BF Midas System', 'GB' );                              //MD018386B
                , 'system', Now(), Now()                                                 //MD018386B
                , 'en', 'GB', 'BF Midas System', 'GB' );                                 //MD018386B
 
         EndSr;
 
       //-------------------*
       // Create Role       |
       //-------------------*
         BegSr CreateRole;
           Exec SQL
                Insert into BFTB_ORGANISATIONGRP
                ( BFGROUPIDPK, BFGROUPDISPLAYNAME, BFGROUPPARENTID, VERSIONNUM
       //*******,*BFGROUPNAME, BFUSERID )                                                //MD018386B
                , BFGROUPNAME                                                            //MD018386B
                , BFRECCREATEDBY, BFRECCREATEDON, BFRECSYSDATE                           //MD018386B
                )                                                                        //MD018386B
                values
                ( 'BFMADMIN', 'BF Midas Admin Profile', 1, 0
       //*******,*'BFMADMIN', 'system');                                                 //MD018386B
                , 'BFMADMIN', 'system', Now(), Now());                                   //MD018386B
 
         // Populate audit fields, if exists
           DynaSQL = 'Update BFTB_ORGANISATIONGRP '
                     + 'set BFRECCREATEDBY = ''system'''
                     + ', BFRECCREATEDON = now() '
       //**********  + 'where BFGROUPID = ''AUTOAUTH''';                                  //MD020456
                     + 'where BFGROUPIDPK = ''AUTOAUTH''';                                //MD020456
 
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
                where BFGROUPNAME = 'BFMADMIN';
 
         //Update permissions attached to BFMADMIN role
           Exec SQL
                Delete from BFTB_GROUPPERMMAP
                where BFGROUPID = :GroupId;
 
           Exec SQL
                Insert into BFTB_GROUPPERMMAP
                (BFIDPK, BFPERMISSIONID, VERSIONNUM, BFGROUPID)
                ( select
         //*********'ADM' || trim(A.BFIDPK)                                               //MD020456
                    concat('ADM',trim(A.BFIDPK))                                          //MD020456
                    , A.BFIDPK
                    , 0
                    , :GroupId
                  from ( select distinct BFIDPK
                         from BFTB_PERMISSION
         //**********     where BFIDPK like 'BFTC%')                                     //MD018386B
                          where BFIDPK like 'BFTC%' or BFIDPK like 'BFWS%' )             //MD018386B
                as A );
 
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
         // Revoke ggBFMADM of roles/entitlements, if any
 
           Exec SQL
                Delete from BFTB_ORGGROUPUSER where BFUSERNAME like '%BFMADM';
           Exec SQL
                Delete from BFTB_ENTITLEMENTS where BFUSERNAME like '%BFMADM';
           Exec SQL                                                                      //MD018386B
                Delete from BFTB_ORGGROUPUSER where BFUSERNAME like '%BFMSUP';           //MD018386B
           Exec SQL                                                                      //MD018386B
                Delete from BFTB_ENTITLEMENTS where BFUSERNAME like '%BFMSUP';           //MD018386B
         EndSr;
 
       //---------------------*
       // Re/Apply Authority  |
       //---------------------*
         BegSr ApplyAuth;
         // (Re)Assign role to ggBFMADM and entitle to all branches.
           Exec SQL
                Insert into BFTB_ORGGROUPUSER
                  ( BFSEQUENCEIDPK, BFGROUPID, BFUSERNAME, VERSIONNUM)
                values
                  ( 'BFMSUPVS'                                                           //MD018386B
                  , :GroupId                                                             //MD018386B
                  , :SupvsUser                                                           //MD018386B
                  , 0 ),                                                                 //MD018386B
                  ( 'BFMADMIN'
                  , :GroupId
                  , :AdminUser
                  , 0 );
 
           Exec SQL
                Insert into BFTB_ENTITLEMENTS
                  ( BFIDPK, BFGROUPNAME, BFENTITLEMENTTYPE, BFENTITLEMENTVALUE
                  , BFUSERNAME, VERSIONNUM, BFDESCRIPTION )
                  ( select
         //**********'ADM' || A8BRCD                                                      //MD020456
                     concat('ADM',A8BRCD)                                                 //MD020456
                   , 'BFMADMIN'
                   , :EntType
                   , A8BRCD
                   , :AdminUser
                   , 0
                   , A8BRNM
                   from GZSDBRCHPD );
 
           Exec SQL                                                                      //MD018386B
                Insert into BFTB_ENTITLEMENTS                                            //MD018386B
                  ( BFIDPK, BFGROUPNAME, BFENTITLEMENTTYPE, BFENTITLEMENTVALUE           //MD018386B
                  , BFUSERNAME, VERSIONNUM, BFDESCRIPTION )                              //MD018386B
                  ( select                                                               //MD018386B
         //**********'SUP' || A8BRCD                                            //MD018386B MD020456
                     concat('SUP',A8BRCD)                                                 //MD020456
                   , 'BFMADMIN'                                                          //MD018386B
                   , :EntType                                                            //MD018386B
                   , A8BRCD                                                              //MD018386B
                   , :SupvsUser                                                          //MD018386B
                   , 0                                                                   //MD018386B
                   , A8BRNM                                                              //MD018386B
                   from GZSDBRCHPD );                                                    //MD018386B
                                                                                         //MD018386B
         // Populate audit fields, if exists
           DynaSQL = 'Update BFTB_ENTITLEMENTS '
                     + 'set BFRECCREATEDBY = ''system'''
                     + ', BFRECCREATEDON = now() '
                     + 'where BFUSERNAME = ''' + AdminUser + '''';
           DynaSQL = %trim(DynaSQL) + ' or BFUSERNAME = ''' + SupvsUser + '''';          //MD018386B
 
           Exec SQL
                Prepare ENAudit from :DynaSQL;
 
           If SQLCode = 0;
              Exec SQL
                   Execute ENAudit;
           EndIf;
 
           DynaSQL = 'Update BFTB_ORGGROUPUSER '
                     + 'set BFRECCREATEDBY = ''system'''
                     + ', BFRECCREATEDON = now() '
                     + 'where BFUSERNAME = ''' + AdminUser + '''';
           DynaSQL = %trim(DynaSQL) + ' or BFUSERNAME = ''' + SupvsUser + '''';          //MD018386B
 
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
      *****************************************************************
