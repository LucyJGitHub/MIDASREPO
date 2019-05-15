     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2011')
      *****************************************************************
/*XBI *  OVRDBF FILE(SMENTLQT) TOFILE(SFENTLV0)                       *
/*XBI *  OVRDBF FILE(SMGPMPQT) TOFILE(SFGPMPV0)                       *
/*XBI *  OVRDBF FILE(SMGRUSQT) TOFILE(SFORGPV0)                       *
/*XBI *  OVRDBF FILE(SMPERMQT) TOFILE(SFPRMNV0)                       *
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Report Permission by User from extract')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SM000049 - Midas SM Report Permission by User from extract   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2011            *
      *                                                               *
      *  Last Amend No. CBF005   *CREATE   Date 04Jul11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CBF005 - BF Infrastructure: Single Security User Maintenance *
      *           Profile                                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators                                            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Subroutines                                                  *
      *                                                               *
      * *main                                                         *
      * *PSSR : Error processing                                      *
      *                                                               *
      *****************************************************************
      *
     D Key             S              4  0
     D Action          S              1
     D Permission      S            256
     D MenuArtf        S            256
     D GroupNm         S             30
     D UserNm          S             10
     D PermID          S             30
     D Brch            S             10
     D Recursive       S              1    INZ('N')
      *
     D BFUB          E DS                  EXTNAME(SMBFUBPD)
     D BFAC          E DS                  EXTNAME(SMBFACPD)
      *
      ** MAIN
      *
      ** Populate SMPERMQT with permissions
      *
     C                   EXSR      ListPerm
      *
     C
      *
      ** Read through user-branch combinations from extract
      *
     C/exec SQL
     C+ declare UBcursor cursor for
     C+ select * from SMBFUBPD
     C/end-exec
      *
     C/exec SQL
     C+ open UBcursor
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from UBcursor
     C+ into: BFUB
     C/end-exec
      *
     C                   DOW       SQLCODE = 0
      *
     C                   EVAL      GroupNm = 'group0' + %trim(%editc(Key :'J'))
     C                   EVAL      UserNm = UBUSER
     C                   EVAL      Brch = UBBRCH
      *
     C                   EXSR      BuildRoles
      *
     C/exec SQL
     C+ fetch next
     C+ from UBcursor
     C+ into: BFUB
     C/end-exec
      *
     C                   ENDDO
      *
     C/exec SQL
     C+ close UBcursor
     C/end-exec
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      *****************************************************************
      *                                                               *
      * BuildRoles - Associate permissions with role                  *
      *                                                               *
      *****************************************************************
      *
     C     BuildRoles    BEGSR
      *
      ** First insert user-branch and assign a temporary group name.
      *
     C/exec SQL
     C+ INSERT INTO SMENTLQT
     C+ (BFGROUPNAME, BFUSERNAME, BFENTITLEMENTVALUE)
     C+ VALUES
     C+ (:GroupNm, :UserNm, :Brch)
     C/end-exec
      *
      * Insert temp group-user
     C/exec SQL
     C+ INSERT INTO SMGRUSQT
     C+ (BFGROUPID, BFUSERNAME)
     C+ VALUES
     C+ (:GroupNm, :UserNm)
     C/end-exec
      *
      ** Find permissions (menu code + action) from Midas data.
      *
     C/exec SQL
     C+ declare ACcursor cursor for
     C+ select * from SMBFACPD
     C+ where ACUSER = :UserNm and ACBRCH = :Brch
     C/end-exec
      *
     C/exec SQL
     C+ open ACcursor
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from ACcursor
     C+ into: BFAC
     C/end-exec
      *
     C                   DOW       SQLCODE = 0
      *
      ** Check each action code (I, E, etc.) and find equivalent permission.
      *
     C                   IF        ACAC01 <> ' '
     C                   EVAL      Action = ACAC01
     C                   EXSR      FindPerm
     C                   ENDIF
     C                   IF        ACAC02 <> ' '
     C                   EVAL      Action = ACAC02
     C                   EXSR      FindPerm
     C                   ENDIF
     C                   IF        ACAC03 <> ' '
     C                   EVAL      Action = ACAC03
     C                   EXSR      FindPerm
     C                   ENDIF
     C                   IF        ACAC04 <> ' '
     C                   EVAL      Action = ACAC04
     C                   EXSR      FindPerm
     C                   ENDIF
     C                   IF        ACAC05 <> ' '
     C                   EVAL      Action = ACAC05
     C                   EXSR      FindPerm
     C                   ENDIF
     C                   IF        ACAC06 <> ' '
     C                   EVAL      Action = ACAC06
     C                   EXSR      FindPerm
     C                   ENDIF
     C                   IF        ACAC07 <> ' '
     C                   EVAL      Action = ACAC07
     C                   EXSR      FindPerm
     C                   ENDIF
     C                   IF        ACAC08 <> ' '
     C                   EVAL      Action = ACAC08
     C                   EXSR      FindPerm
     C                   ENDIF
     C                   IF        ACAC09 <> ' '
     C                   EVAL      Action = ACAC09
     C                   EXSR      FindPerm
     C                   ENDIF
     C                   IF        ACAC10 <> ' '
     C                   EVAL      Action = ACAC10
     C                   EXSR      FindPerm
     C                   ENDIF
      *
     C/exec SQL
     C+ fetch next
     C+ from ACcursor
     C+ into: BFAC
     C/end-exec
      *
     C                   ENDDO
      *
     C/exec SQL
     C+ close ACcursor
     C/end-exec
      *
     C     BuildPermsE   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * FindPerm - Identify permission associated with menu code and  *
      *            action                                             *
      *                                                               *
      * Called by: BuildRoles                                         *
      *                                                               *
      *****************************************************************
      *
     C     FindPerm      BEGSR
      *
      ** Find the matching menu artefact for the menu code and action.
      *
     C/exec SQL
     C+ select PMARTF into :MenuArtf
     C+ from MITB_PERMM
     C+ where PMINDX = :ACINDX and PMACTC = :Action
     C/end-exec
      *
      ** Find the matching PermissionID for the menu artefact.
      *
     C/exec SQL
     C+ select BFIDPK into :Permission
     C+ from SMPERMQT
     C+ where BFPERMISSIONNAME = :MenuArtf
     C/end-exec
      *
      ** Write record to the permission-role file.
      *
     C/exec SQL
     C+ insert into SMGPMPQT (
     C+ BFGROUPID, BFPERMISSIONID
     C+ )
     C+ values (
     C+ :GroupNm, :Permission
     C+ )
     C/end-exec
      *
     C     FindPermE     ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * ListPerm - Populate SMPERMQT with permissions                 *
      *                                                               *
      * Called by: MAIN                                               *
      *                                                               *
      *****************************************************************
      *
     C     ListPerm      BEGSR
      *
     C
     C/exec SQL
     C+ declare PRcursor cursor for
     C+ select PMARTF from MITB_PERMM
     C/end-exec
      *
     C/exec SQL
     C+ open PRcursor
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from PRcursor
     C+ into: MenuArtf
     C/end-exec
      *
     C                   EVAL      Key = 1
     C                   DOW       SQLCODE = 0
      *
     C                   EVAL      PermID = 'Perm' + %trim(%editc(Key :'J'))
     C                   EVAL      Permission = %REPLACE('PRM':MenuArtf:3:3)
      *
      ** Write record to the permission-role file.
      *
     C/exec SQL
     C+ insert into SMPERMQT (
     C+ BFIDPK, BFPERMISSIONID
     C+ )
     C+ values (
     C+ :PermID, :Permission
     C+ )
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from PRcursor
     C+ into: MenuArtf
     C/end-exec
      *
     C                   EVAL      Key = Key + 1
     C                   ENDDO
      *
     C/exec SQL
     C+ close PRcursor
     C/end-exec
      *
     C     ListPermE     ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  -   Program exception error routine                    *
      *            Called automatically if a program error occurs,    *
      *            or directly by the program code using EXSR.        *
      *            This subroutine DUMPs the program just once.       *
      *                                                               *
      * Called by: *INZSR                                             *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        Recursive = *BLANK
     C                   EVAL      Recursive = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
