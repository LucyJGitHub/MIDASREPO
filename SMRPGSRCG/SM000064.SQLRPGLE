     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Init BFTC and BFWS permissions on zones')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SM000064 - Initialisa BFTC/BFWS permissions on zones         *
      *                                                               *
      *  Function:  This program will initialise the BFTC and BFWS    *
      *             permissions in SMBFPRTD in all zones in BFTB_ZONE *
      *             - thus, populating BFTB_ZONEPERMISSION            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. MD032025           Date 21Jan15               *
      *  Prev Amend No. MD020456           Date 23May13               *
      *                 MD018386C          Date 23Apr13               *
      *                 MD018386B *CREATE  Date 22Apr13               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD032025  - Duplicate key when creating new zone since pgm   *
      *              tries to reload all zones.                       *
      *  MD020456 - BF Upload menu option UPLD doesn't upload         *
      *             entitlements to BFTB tables                       *
      *  MD018386C - Trim spaces from values                          *
      *  MD018386B - Include BFTC and BFWS permissions initialisation *
      *              in BF Upload.                                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *****************************************************************
      /free
       Exec SQL
            Insert into BFTB_ZONEPERMISSION
            (BFPERMISSIONID, BFZONE, BFALLOWINCOB, BFZONEPERMISSIONIDPK
            , VERSIONNUM, BFRECCREATEDBY, BFRECCREATEDON, BFRECSYSDATE)
            (
       //***select*b.BPPERID, a.ZOMSYS, 0,                                               //MD018386C
            select trim(b.BPPERID), trim(a.ZOMSYS), 0,                                   //MD018386C
       //********** trim(b.BPPERID)||'-'||trim(a.ZOMSYS),                                 //MD020456
                    concat(concat(trim(b.BPPERID),'-'),trim(a.ZOMSYS)),                   //MD020456
                    0,'system', Now(), Now()
            from GPZONEPD a
               , SMBFPRTD b
                 Where concat(concat(trim(b.BPPERID),'-'),trim(a.ZOMSYS))                 //MD032025
                 not in (select BFZONEPERMISSIONIDPK from BFTB_ZONEPERMISSION)            //MD032025
            );
 
       *INLR = *ON;
       Return;
      /end-free
 
      *****************************************************************
