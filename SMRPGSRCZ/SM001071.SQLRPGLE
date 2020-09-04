     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Add records to new user files')
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  SM001071 - Add records to new user files                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *  Last Amend No. MD046248           Date 05Feb18               *
      *  Prev Amend No. A1084804           Date 29Jan13               *
      *                 CUP003             Date 12Aug10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CUP034  *CREATE    Date 18Dec06               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  A1084804 - Ensure user text is brought across.               *
      *  CUP003 - Rename user profiles on SFACAUPD.                   *
      *  CUP034 - MidasPlus user data migration.                      *
      *                                                               *
      *****************************************************************
      *
     D PSDS           SDS
      *
      ** Program Status Data Structure.
      *
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
     D POldUsrPrf      S             10
     D OldUsrPrf       S                   LIKE(POldUsrPrf)
     D PNewUsrPrf      S                   LIKE(POldUsrPrf)
     D NewUsrPrf       S                   LIKE(POldUsrPrf)
     D PMITEMFlag      S              1
     D PUserText       S             25                                                     A1084804
      *
     C     *ENTRY        PLIST
     C                   PARM                    POldUsrPrf
     C                   PARM                    PNewUsrPrf
     C                   PARM                    PMITEMFlag
     C                   PARM                    PUserText                                  A1084804
      *
     C                   EVAL      OldUsrPrf = POldUsrPrf
     C                   EVAL      NewUsrPrf = PNewUsrPrf
      *
     C/EXEC SQL
     C+  WHENEVER SQLERROR GO TO TAGSQLERR
     C/END-EXEC
      *
      * Delete existing records (if any) from user files.
     C/EXEC SQL
     C+ delete from MUSERDD
     C+ where USRP = :NewUsrPrf
     C/END-EXEC
     C/EXEC SQL
     C+ delete from MACBRDD
     C+ where USRP = :NewUsrPrf
     C/END-EXEC
     C/EXEC SQL
     C+ delete from MBRBSDD
     C+ where USRP = :NewUsrPrf
     C/END-EXEC
     C/EXEC SQL
     C+ delete from MBROSDD
     C+ where USRP = :NewUsrPrf
     C/END-EXEC
     C/EXEC SQL
     C+ delete from MCMPSDD
     C+ where USRP = :NewUsrPrf
     C/END-EXEC
      *
      * If the new user profile does not match the old user profile then
      *  update the temporary versions ...
     C                   IF        OldUSrPrf <> NewUsrPrf
     C                   EXSR      UpdateTemp
      *
      * ... else just update the new user files.
     C                   ELSE
     C                   EXSR      UpdateNew
     C                   ENDIF
      *
      * If MITEM is involved process MACBRDD specially.
     C                   IF        PMITEMFlag = 'Y'
     C                   CALL      'SM001073'
     C                   ENDIF
      *
     C                   SETON                                        LR
     C                   RETURN
      *
     C     TAGSQLERR     TAG
      *
     C                   EXSR      *PSSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * UpdateTemp - Insert and update temporary versions of user     *
      *              files.                                           *
      *                                                               *
      *****************************************************************
     C     UpdateTemp    BEGSR
      *
     C/EXEC SQL
     C+ insert into MUSERDDQT select * from FMUSERDDQT
     C+ where USRP = :OldUsrPrf
     C/END-EXEC
     C/EXEC SQL
     C+ update MUSERDDQT
     C+ set USRP = :NewUsrPrf
     C+ , USER1 = :PUserText                                                                A1084804
     C/END-EXEC
     C/EXEC SQL
     C+ insert into MACBRDDQT select * from FMACBRDDQT
     C+ where USRP = :OldUsrPrf
     C/END-EXEC
     C/EXEC SQL
     C+ update MACBRDDQT
     C+ set USRP = :NewUsrPrf
     C/END-EXEC
     C/EXEC SQL
     C+ insert into MBRBSDDQT select * from FMBRBSDDQT
     C+ where USRP = :OldUsrPrf
     C/END-EXEC
     C/EXEC SQL
     C+ update MBRBSDDQT
     C+ set USRP = :NewUsrPrf
     C/END-EXEC
     C/EXEC SQL
     C+ insert into MBROSDDQT select * from FMBROSDDQT
     C+ where USRP = :OldUsrPrf
     C/END-EXEC
     C/EXEC SQL
     C+ update MBROSDDQT
     C+ set USRP = :NewUsrPrf
     C/END-EXEC
     C/EXEC SQL
     C+ insert into MCMPSDDQT select * from FMCMPSDDQT
     C+ where USRP = :OldUsrPrf
     C/END-EXEC
     C/EXEC SQL
     C+ update MCMPSDDQT
     C+ set USRP = :NewUsrPrf
     C/END-EXEC
     C/EXEC SQL                                                                               CUP003
     C+ update SFACAUPD                                                                       CUP003
     C+ set SFUSRP = :NewUsrPrf                                                               CUP003
     C+ where SFUSRP = :OldUsrPrf                                                             CUP003
     C/END-EXEC                                                                               CUP003
     C/EXEC SQL                                                                               CUP003
     C+ update SFRAAUPA                                                                       CUP003
     C+ set MAUSR = :NewUsrPrf                                                                CUP003
     C+ where MAUSR = :OldUsrPrf                                                              CUP003
     C/END-EXEC                                                                               CUP003
     C/EXEC SQL                                                                               CUP003
     C+ update SFUFAVPD                                                                       CUP003
     C+ set UFUSRP = :NewUsrPrf                                                               CUP003
     C+ where UFUSRP = :OldUsrPrf                                                             CUP003
     C/END-EXEC                                                                               CUP003
     C/EXEC SQL                                                                               CUP003
     C+ update SFVAMUSPD                                                                      CUP003
     C+ set USUSRP = :NewUsrPrf                                                               CUP003
     C+ where USUSRP = :OldUsrPrf                                                             CUP003
     C/END-EXEC                                                                               CUP003
     C/EXEC SQL                                                                               CUP003
     C+ update SFVBBRCPD                                                                      CUP003
     C+ set BBUSRP = :NewUsrPrf                                                               CUP003
     C+ where BBUSRP = :OldUsrPrf                                                             CUP003
     C/END-EXEC                                                                               CUP003
     C/EXEC SQL                                                                               CUP003
     C+ update SFVCOMPPD                                                                      CUP003
     C+ set CMUSRP = :NewUsrPrf                                                               CUP003
     C+ where CMUSRP = :OldUsrPrf                                                             CUP003
     C/END-EXEC                                                                               CUP003
     C/EXEC SQL                                                                               CUP003
     C+ update SFVOBRCPD                                                                      CUP003
     C+ set OBUSRP = :NewUsrPrf                                                               CUP003
     C+ where OBUSRP = :OldUsrPrf                                                             CUP003
     C/END-EXEC                                                                               CUP003
      *
     C     UpdateTempE   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * UpdateNew - Insert records into new user files                *
      *                                                               *
      *****************************************************************
     C     UpdateNew     BEGSR
      *
     C/EXEC SQL
     C+ insert into MUSERDD select * from FMUSERDDQT
     C+ where USRP = :OldUsrPrf
     C/END-EXEC
     C                   IF        PMITEMFlag = 'Y'
     C/EXEC SQL
     C+ insert into MACBRDDQT select * from FMACBRDDQT
     C+ where USRP = :OldUsrPrf
     C/END-EXEC
     C                   ELSE
     C/EXEC SQL
     C+ insert into MACBRDD select * from FMACBRDDQT
     C+ where USRP = :OldUsrPrf
     C/END-EXEC
     C                   ENDIF
     C/EXEC SQL
     C+ insert into MBRBSDD select * from FMBRBSDDQT
     C+ where USRP = :OldUsrPrf
     C/END-EXEC
     C/EXEC SQL
     C+ insert into MBROSDD select * from FMBROSDDQT
     C+ where USRP = :OldUsrPrf
     C/END-EXEC
     C/EXEC SQL
     C+ insert into MCMPSDD select * from FMCMPSDDQT
     C+ where USRP = :OldUsrPrf
     C/END-EXEC
      *
     C     UpdateNewE    ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: None                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR SR **
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   END
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
