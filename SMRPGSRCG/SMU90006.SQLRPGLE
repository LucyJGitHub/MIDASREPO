     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2021')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Generate Permission Mapping')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SMU90006 - Update SMBFMGTD                                   *
      *                                                               *
      *  (c) Finastra International Limited 2021                      *
      *                                                               *
      *  Last Amend No. MD059073 *CREATE   Date 15Oct21               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD059073 - FBM - UXP Reference users are removed from user   *
      *             configuration after the upgrade from SP23 to      *
      *             2021.B                                            *
      *           - Applied for MD059722                              *
      *                                                               *
      *****************************************************************
      *
     D Recursive       S              1    INZ('N')

       // Main Routine

      /free

       // Update record in SMBFMGTD for BFTB_USER.
       // BFREFERENCEUSERNAME field will be included
       // in insert mode during migration.

             Exec SQL
              UPDATE SMBFMGTD SET BFTFLD = 'BFNAMEPK, BFPASSWORD, BFUSERTYPE, +
              BFREAUTHENTICATION, BFINVALIDPASSWORDATTEMPTS, BFLOCKEDOUT, +
              BFPASSWORDEXPIRYDATE, BFPASSWORDEXPIRYIND, VERSIONNUM, +
              BFLANGUAGELOCALE, BFCOUNTRYLOCALE, BFVARIANTLOCALE, BFZONE, +
              BFBMBRANCH, BFUSERID, BFRECCREATEDBY, BFRECCREATEDON, +
              BFRECSYSDATE, BFREFERENCEUSER, BFUPDATEENTOFLINKEDUSER, +
              BFRSAFLAG, BFRECDELETETDATE, BFREFERENCEUSERNAME'
              WHERE BFTABL= 'BFTB_USER' AND BFUFLD= 'BFNAMEPK';

       *INLR = *ON;

       Return;

      /end-free
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
