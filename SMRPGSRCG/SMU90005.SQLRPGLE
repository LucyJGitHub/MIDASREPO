     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2021')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Generate Permission Mapping')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SMU90005 - Update SMBFMGTD                                   *
      *                                                               *
      *  (c) Finastra International Limited 2021                      *
      *                                                               *
      *  Last Amend No. MD058802 *CREATE   Date 30Sep21               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058802 - UXP: Data Migration Issues                        *
      *                                                               *
      *****************************************************************
      *
     D Recursive       S              1    INZ('N')

       // Main Routine

      /free

       // Insert new record in SMBFMGTD for BFTB_EVENTCODE.
       // This will update the severity of BFTB_EVENTCODE
       // from old to new platform.

             Exec SQL
              INSERT INTO SMBFMGTD (BFTABL, BFSTAT, BFLAYR, BFPRTY,
              BFRTYP, BFUFLD, BFTFLD) VALUES ('BFTB_EVENTCODE', ' ' ,
              '*GLOBAL', 3, 'UPD', ' ' , 'UPDATE ?.BFTB_EVENTCODE A +
              SET A.BFSEVERITY= CASE WHEN A.BFSEVERITY <> (SELECT B.BFSEVERITY +
              FROM #.BFTB_EVENTCODE B WHERE A.BFEVENTCODEIDPK = +
              B.BFEVENTCODEIDPK) THEN (SELECT B.BFSEVERITY FROM +
              #.BFTB_EVENTCODE B WHERE A.BFEVENTCODEIDPK = B.BFEVENTCODEIDPK) +
              ELSE A.BFSEVERITY END WHERE A.BFEVENTCODEIDPK = +
              (SELECT B.BFEVENTCODEIDPK FROM #.BFTB_EVENTCODE B +
              WHERE A.BFEVENTCODEIDPK = B.BFEVENTCODEIDPK)');

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
