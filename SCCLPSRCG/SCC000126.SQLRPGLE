     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2015')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas Insert missing Entitlement for new branch')      *
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SCC000126 - Midas Insert missing Entitlement for new branch  *
      *                                                               *
      *  Function:  This program will insert the new branch from      *
      *             BFTC entitlement table of PEA system              *
      *                                                               *
      *  (c) Finastra International Limited 2015                      *
      *                                                               *
      *  Last Amend No. MD033623  *CREATE  Date 28Sep15               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD033626  - We Can't give permissions to the Branch 900 on   *
      *              PEA                                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  InsertBranchEntitlements - Insert missing entitlement for    *
      *                             branch                            *
      *                                                               *
      *****************************************************************
      *
      /free

       // MAIN
       //---------------------------------*


       // Insert missing entitlement for branch

         ExSr InsertBranchEntitlements;


         *INLR = *ON;
         Return;

       // SUBROUTINES
       //---------------------------------*

       //----------------------------*
       // Insert Branch Entitlements |
       //----------------------------*
         BegSr InsertBranchEntitlements;

         Exec SQL
          INSERT INTO BFTB_00081 (BFIDPK, BFUSERNAME,
             BFGROUPNAME, BFENTITLEMENTTYPE, BFENTITLEMENTVALUE)
          (SELECT  TRIM((SELECT GIVAL FROM GPSVALPD
          WHERE GISVAL = 'BankFusionAdminUser')) || A8BRCD,
          (SELECT GIVAL FROM GPSVALPD WHERE GISVAL = 'BankFusionAdminUser'),
          (SELECT GIVAL FROM GPSVALPD WHERE GISVAL = 'BankFusionAdminRole'),
              'Branch',
              A8BRCD
                FROM PEAGLOBRST/GZSDBRCHPD WHERE  A8BRCD NOT IN (
          SELECT BFENTITLEMENTVALUE FROM BFTB_00081
          WHERE BFUSERNAME = (SELECT GIVAL FROM GPSVALPD
          WHERE GISVAL = 'BankFusionAdminUser')
                AND BFGROUPNAME =  (SELECT GIVAL FROM GPSVALPD
          WHERE GISVAL = 'BankFusionAdminRole')));


         EndSr;

      /end-free

      *****************************************************************
      /EJECT
      *****************************************************************