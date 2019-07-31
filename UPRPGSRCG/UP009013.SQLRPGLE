     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP Resequence unique numbers for CB* files')
      *****************************************************************
      *                                                               *
      *  Midas - Upgrade module                                       *
      *                                                               *
      *  UP009013 - Resequence unique numbers for CB* files, part of  *
      *             *MRG option                                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. A1084804 *CREATE   Date 01Feb13               *
      *  Prev Amend No. xxxxxxxx           Date ddMmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  A1084804 - Add *MRG option.                                  *
      *                                                               *
      *****************************************************************
      *
     D NewATDATA       S           6000
     D SaveFile        S             10
     D SaveComp        S             10
     D SaveSeq         S              5
     D Len             S              1  0
     D DSStart         S              1  0
     D SpecStart       S              2  0
     D Recursive       S              1    INZ('N')
      *
     D AFCP          E DS                  EXTNAME(UPAFCPPD)
      *
     D ResetUnq        DS
     D  ResetUnq3              1      3  0
     D  ResetUnq3A             1      3
     D  ResetUnq2              2      3  0
     D  ResetUnq2A             2      3
      *
      * Drop table if it already exists.
     C/exec SQL
     C+ drop table QTEMP/UPAFCP
     C/end-exec
      *
      * Drop table if it already exists.
     C/exec SQL
     C+ create table QTEMP/UPAFCP
     C+ as
     C+ (
     C+ select
     C+   ATFILE
     C+ , ATNUMB
     C+ , ATACT
     C+ , ATIGNA
     C+ , ATDATA
     C+ from UPAFCPPD
     C+ where
     C+ (
     C+    ATFILE = 'CBDPRLPD'
     C+ or ATFILE = 'CBMEXCPD'
     C+ or ATFILE = 'CBMDCNPD'
     C+ )
     C+ and ATACT = 'I'
     C+ order by
     C+   ATFILE
     C+ , ATDATA
     C+ )
     C+ with data
     C/end-exec
      *
      * Start reading through the copy.
     C/exec SQL
     C+ declare AFCursor cursor for
     C+ select * from QTEMP/UPAFCP
     C+ for update of
     C+   ATDATA
     C/end-exec
      *
     C/exec SQL
     C+ open AFCursor
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from AFCursor
     C+ into: AFCP
     C/end-exec
      *
     C                   DOW       SQLCODE = 0
      *
      * If a new file is found then find key fields position and length.
     C                   IF        ATFILE <> SaveFile
     C                   EVAL      ResetUnq3 = 999
     C                   EVAL      SaveFile = ATFILE
     C                   ENDIF
      *
      * Check component and sequence; this will be the same for all 3 CB* files.
     C                   IF        %SUBST(ATDATA:1:10) <> SaveComp or
     C                             %SUBST(ATDATA:11:5) <> SaveSeq
     C                   EVAL      ResetUnq3 = 999
     C                   EVAL      SaveComp = %SUBST(ATDATA:1:10)
     C                   EVAL      SaveSeq = %SUBST(ATDATA:11:5)
     C                   ENDIF
      *
     C                   SELECT
     C                   WHEN      ATFILE = 'CBDPRLPD'
     C                   EVAL      Len = 3
     C                   EVAL      DSStart = 1
     C                   WHEN      ATFILE = 'CBMEXCPD'
     C                   EVAL      Len = 2
     C                   EVAL      DSStart = 2
     C                   WHEN      ATFILE = 'CBMDCNPD'
     C                   EVAL      Len = 2
     C                   EVAL      DSStart = 2
     C                   ENDSL
     C
     C                   EVAL      SpecStart = 16 + Len
     C                   EXSR      ResetUnique
 
     C                   EVAL      ResetUnq3 = ResetUnq3 - 1
      *
     C/exec SQL
     C+ update QTEMP/UPAFCP
     C+ set
     C+    ATDATA = :NewATDATA
     C+ where
     C+    current of AFCursor
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from AFCursor
     C+ into: AFCP
     C/end-exec
      *
     C                   ENDDO
      *
     C/exec SQL
     C+ close AFCursor
     C/end-exec
      *
      * Once the temporary copy has been updated then delete the records
      *  from the original and add the updated records back in.
     C/exec SQL
     C+ delete from UPAFCPPD
     C+ where
     C+ (
     C+    ATFILE = 'CBDPRLPD'
     C+ or ATFILE = 'CBMEXCPD'
     C+ or ATFILE = 'CBMDCNPD'
     C+ )
     C+ and ATACT = 'I'
     C/end-exec
      *
     C/exec SQL
     C+ insert into UPAFCPPD
     C+ select * from QTEMP/UPAFCP
     C/end-exec
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      *    ResetUnique - Update string with new records CBDPRLPD                             *
      *                                                               *
      *****************************************************************
     C     ResetUnique   BEGSR
      *
     C                   EVAL      %SUBST(NewATDATA:1:15) =
     C                             %SUBST(ATDATA:1:15)
     C                   EVAL      %SUBST(NewATDATA:16:Len) =
     C                             %SUBST(ResetUnq:DSStart:Len)
      * The use of a length of 100 is arbritary and just ensures all files
      *  are covered.
     C                   EVAL      %SUBST(NewATDATA:SpecStart:100) =
     C                             %SUBST(ATDATA:SpecStart:100)
      *
     C     ResetUniqueE  ENDSR
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
