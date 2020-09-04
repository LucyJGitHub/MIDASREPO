     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2011')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Upload to BF - Role/Group from Model User')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SM000055 - Upload to BF - Role/Group from Model User         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2011            *
      *                                                               *
      *  Last Amend No. MD022372A          Date 28Apr14               *
      *  Prev Amend No. MD018386C          Date 23Apr13               *
      *                 AR989186           Date 06Feb13               *
      *               . AR883210A          Date 11Jan12               *
      *                 AR883210           Date 21Dec11               *
      *                 CBF005   *CREATE   Date 04Jul11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD022372A - Avoid duplicate key in iteration mode run        *
      *  MD018386C - Update for BFP3.1 patch changes                  *
      *  AR989186 - Insert record only if not already existing        *
      *           - Applied for AR1085933                             *
      *  AR883210A - Updated Mapping for BFGROUPPARENTID field        *
      *  AR883210 - Additional Deliverables for BF                    *
      *  CBF005 - BF Infrastructure: Single Security User Maintenance *
      *           Profile                                             *
      *                                                               *
      *****************************************************************
      *
     D Role            S             40
     D RoleCount       S              2  0                                                  AR989186
     D Count           S              2  0
     D Key             S              5  0 INZ(1)
      *
     D Recursive       S              1    INZ('N')
      *
     D BFRP          E DS                  EXTNAME(SMBFRPPD)
      *
      **********/free                                                            MD018386C MD022372A
      *Exec*SQL*                                                               //MD018386C MD022372A
      ******select value(max(integer(substr(BFGROUPIDPK,6,2))),0)              //MD018386C MD022372A
      ******into :Key                                                          //MD018386C MD022372A
      ******from BFTB_ORGANISATIONGRP                                          //MD018386C MD022372A
      ******where BFGROUPIDPK like 'group%';                                   //MD018386C MD022372A
      **********                                                               //MD018386C MD022372A
      **********/end-free                                                        MD018386C MD022372A
      /free                                                                                MD022372A
       Exec SQL                                                                          //MD022372A
            select value(max(integer(substr(BFGROUPIDPK,6,5))),0)                        //MD022372A
            into :Key                                                                    //MD022372A
            from BFTB_ORGANISATIONGRP                                                    //MD022372A
            where BFGROUPIDPK like 'group%';                                             //MD022372A
                                                                                         //MD022372A
      /end-free                                                                            MD022372A
     C/EXEC SQL
     C+ DECLARE RPcursor CURSOR FOR
     C+ SELECT DISTINCT(RPROLE) FROM SMBFRPPD
     C/END-EXEC
      *
     C/EXEC SQL
     C+ OPEN RPcursor
     C/END-EXEC
      *
     C/EXEC SQL
     C+ FETCH NEXT
     C+ FROM RPcursor
     C+ INTO: Role
     C/END-EXEC
      *
     C*/EXEC SQL                                                                  AR989186 MD018386C
     C*+*select value(max(integer(substr(BFGROUPIDPK,6,2))),0)                    AR989186 MD018386C
     C*+*into*:Key                                                                AR989186 MD018386C
     C*+*from*BFTB_ORGANISATIONGRP                                                AR989186 MD018386C
     C*+*where*BFGROUPIDPK like 'group%'                                          AR989186 MD018386C
     C*/END-EXEC                                                                  AR989186 MD018386C
      **                                                                                    AR989186
     C**********         EVAL      Count = 1                                                AR989186
      **                                                                                    AR989186
     C                   DOW       SQLCODE = 0
      *
     C/EXEC SQL                                                                             AR989186
     C+ select count(*) into :RoleCount                                                     AR989186
     C+ from BFTB_ORGANISATIONGRP                                                           AR989186
     C+ where BFGROUPNAME = :Role                                                           AR989186
     C/END-EXEC                                                                             AR989186
      *                                                                                     AR989186
     C                   IF        RoleCount = 0                                            AR989186
     C                   EVAL      Key = Key +1                                            MD022372A
     C                   EXSR      WriteRec
     C                   ENDIF                                                              AR989186
      *
     C/EXEC SQL
     C+ FETCH NEXT
     C+ FROM RPcursor
     C+ INTO: Role
     C/END-EXEC
     C**********         EVAL      Key = Key + 1                                           MD022372A
      *
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
     C/EXEC SQL
     C+ INSERT INTO BFTB_ORGANISATIONGRP(
     C+ BFGROUPIDPK,
     C+ BFGROUPDISPLAYNAME,
     C+ BFGROUPPARENTID,
     C+ VERSIONNUM,
     C+ BFGROUPNAME)
     C+ VALUES(
     C*CONCAT('group',*:Key),*:Role,*'*',*1,*:Role)********************                /*AR883210A*/
     C+ CONCAT('group', :Key), :Role, '1', 1, :Role)                                   /*AR883210A*/
     C/END-EXEC
      *
     C     WriteRecE     ENDSR
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
