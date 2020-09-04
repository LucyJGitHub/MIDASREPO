     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2011')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Upload to BF - Permission to Role Mapping')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SM000056 - Upload to BF - Permission to Role Mapping         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2011            *
      *                                                               *
      *  Last Amend No. MD022372A          Date 28Apr14               *
      *  Prev Amend No. AR989186           Date 06Feb13               *
      *                 AR883210           Date 21Dec11               *
      *                 CBF005   *CREATE   Date 04Jul11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD022372A - Avoid duplicate key in iteration mode run        *
      *            - Use GROUPNAME instead of Displayname             *
      *  AR989186 - Insert record only if not already existing        *
      *           - Applied for AR1085933                             *
      *  AR883210 - Additional Deliverables for BF                    *
      *  CBF005 - BF Infrastructure: Single Security User Maintenance *
      *           Profile                                             *
      *                                                               *
      *****************************************************************
      *
     D Permission      S            255
     D PermID          S             22
     D GroupID         S             20
     D Role            S             40
     D Count           S              2  0
     D Key             S             10  0 INZ(1)
      *
     D Recursive       S              1    INZ('N')
      *
     D BFRP          E DS                  EXTNAME(SMBFRPPD)
      *
      ** Get the next PK available for BFTB_GROUPPERMMAP                                    AR989186
      *                                                                                     AR989186
     C/EXEC SQL                                                                             AR989186
     C+ select                                                                              AR989186
     C+ value(max(integer(trim(substr(bfidpk,7,10)))), 0)                                   AR989186
     C+ into :Key                                                                           AR989186
     C+ from BFTB_GROUPPERMMAP                                                              AR989186
     C+ where BFIDPK like 'grpper%'                                                         AR989186
     C/END-EXEC                                                                             AR989186
      *                                                                                     AR989186
     C/EXEC SQL
     C+ DECLARE RPcursor CURSOR FOR
     C+ SELECT * FROM SMBFRPPD
     C/END-EXEC
      *
     C/EXEC SQL
     C+ OPEN RPcursor
     C/END-EXEC
      *
     C/EXEC SQL
     C+ FETCH NEXT
     C+ FROM RPcursor
     C+ INTO: BFRP
     C/END-EXEC
      *
     C                   DOW       SQLCODE = 0
      *
     C                   EVAL      Role = RPROLE
     C                   EVAL      Permission = RPARTF
     C                   EVAL      GroupID = *BLANKS
      *
      *
     C/EXEC SQL
     C+ SELECT BFGROUPIDPK INTO :GroupID
     C+ FROM BFTB_ORGANISATIONGRP
     C*+*WHERE*BFGROUPDISPLAYNAME*=*TRIM(:Role)*******                                     MD022372A
     C+ WHERE BFGROUPNAME = TRIM(:Role)                                                    MD022372A
     C/END-EXEC
      *
     C     GroupID       IFNE      *BLANKS
      *
     C/EXEC SQL
     C+ SELECT BFPERMISSIONID INTO :PermID
     C+ FROM BFTB_RESOURCEPERM WHERE BFRESOURCEID = :Permission
     C/END-EXEC
      *
     C     PermID        IFNE      *BLANKS
      *
     C/EXEC SQL                                                                             AR989186
     C+ SELECT count(*) INTO :Count                                                         AR989186
     C+ FROM BFTB_GROUPPERMMAP                                                              AR989186
     C+ WHERE BFPERMISSIONID = :PermID                                                      AR989186
     C+ AND   BFGROUPID = :GroupID                                                          AR989186
     C/END-EXEC                                                                             AR989186
      *                                                                                     AR989186
     C                   IF        Count = 0                                                AR989186
      *                                                                                     AR989186
     C                   EVAL      Key = Key + 1                                           MD022372A
     C                   EXSR      WriteRec
      *                                                                                     AR989186
     C                   ENDIF                                                              AR989186
      *
     C                   ENDIF
     C                   ENDIF
      *
     C/EXEC SQL
     C+ FETCH NEXT
     C+ FROM RPcursor
     C+ INTO: BFRP
     C/END-EXEC
      *
     C                   EVAL      Key = Key + 1
     C                   ENDDO
      *
     C/EXEC SQL
     C+ CLOSE RPcursor
     C/END-EXEC
      *
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      *  WriteRec - Write records to BankFusion tables                *
      *                                                               *
      *****************************************************************
      *
     C     WriteRec      BEGSR
      *
      * Write record on BFTB_GROUPPERMMAP
     C
     C/EXEC SQL
     C+ INSERT INTO BFTB_GROUPPERMMAP(
     C+ BFIDPK,
     C+ BFPERMISSIONID,
     C+ BFGROUPID,
     C+ VERSIONNUM)
     C+ VALUES(CONCAT('grpper', :Key), trim(:PermID), trim(:GroupID), 1)
     C/END-EXEC
      *
     C     WriteRecE     ENDSR
      *
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
