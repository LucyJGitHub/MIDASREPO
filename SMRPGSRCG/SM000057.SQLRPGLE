     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2011')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Upload to BF - User to Role Mapping')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SM000057 - Midas SM Upload to BF - User to Role Mapping      *
      *                                                               *
      *  (c) Finastra International Limited 2011                      *
      *                                                               *
      *  Last Amend No. MD057068           Date 07Nov20               *
      *  Prev Amend No. MD033413           Date 19May15               *
      *                 AR989186           Date 23Aug12               *
      *                 AR883210           Date 21Dec11               *
      *                 CBF005   *CREATE   Date 04Jul11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD057068 - When running BF Upload for migrating user/role    *
      *             from multiple zones, some user-role associations  *
      *             are not mapped. SP23 Blocker error.               *
      *           - Move location of SQL code that checks and retrieve*
      *             user role and group id on ‘BFTB_ORGANISATIONGRP’  *
      *             from 'after' to 'before' location SQL code of     *
      *             'BFTORGGRPU'.                                     *
      *  MD033413 - New Role is not assigned to the users via API     *
      *  AR989186 - Insert record only if not already existing        *
      *           - Applied for AR1085933                             *
      *  AR883210 - Additional Deliverables for BF                    *
      *  CBF005 - BF Infrastructure: Single Security User Maintenance *
      *           Profile                                             *
      *                                                               *
      *****************************************************************
      *
     D GrpID           S             30
     D WrkGrpId        S              8                                                     MD033413
     D Count           S              5  0 INZ(0)
     D VerNum          S              9  0 INZ(1)
     D ORGGRPCNT       S              5  0 INZ(0)                                           AR989186
      *
     D BFUBPD        E DS                  EXTNAME(SMBFUBPD)
      *
      *
     C
      *
     C/EXEC SQL
     C+ DECLARE PCursor CURSOR FOR
     C+ SELECT * FROM SMBFUBPD
     C+ WHERE UBROLE <> ''
     C/END-EXEC
      *
     C/EXEC SQL
     C+ OPEN PCursor
     C/END-EXEC
      *
     C/EXEC SQL
     C+ FETCH
     C+ FROM PCursor
     C+ INTO: BFUBPD
     C/END-EXEC
      *
     C                   DOW       SQLCODE = 0
      *                                                                                     MD057068
      ** Check first if role is existing to get the Group ID                                MD057068
      *                                                                                     MD057068
     C/EXEC SQL                                                                             MD057068
     C+ SELECT BFGROUPIDPK INTO :GrpID                                                      MD057068
     C+ FROM BFTB_ORGANISATIONGRP                                                           MD057068
     C+ WHERE TRIM(BFGROUPNAME) = TRIM(:UBROLE)                                             MD057068
     C/END-EXEC                                                                             MD057068
     C*                                                                                     AR989186
     C/EXEC SQL                                                                             AR989186
     C+ select count(*) into :ORGGRPCNT                                                     AR989186
     C+ from BFTB_ORGGROUPUSER                                                              AR989186
     C+ where                                                                               AR989186
     C+ BFGROUPID = :GrpID                                                                  AR989186
     C+ and BFUSERNAME = trim(:UBUSER)                                                      AR989186
     C/END-EXEC                                                                             AR989186
      *
      ** Move below SQL code before DOW                                                     MD057068
     C***/EXEC*SQL                                                                          MD057068
     C***+*SELECT*BFGROUPIDPK*INTO*:GrpID                                                   MD057068
     C***+*FROM*BFTB_ORGANISATIONGRP                                                        MD057068
     C***+*WHERE*TRIM(BFGROUPNAME)*=*TRIM(:UBROLE)                                          MD057068
     C***/END-EXEC                                                                          MD057068
      *
     C                   IF        SQLCODE = 0
     C                             AND ORGGRPCNT = 0                                        AR989186
     C
     C                   EVAL      WrkGrpId = *BLANKS                                       MD033413
     C                   EVAL      WrkGrpId = GrpID                                         MD033413
      *                                                                                     MD033413
     C/EXEC SQL
     C+ INSERT INTO BFTB_ORGGROUPUSER(
     C+ BFSEQUENCEIDPK, BFGROUPID, BFUSERNAME, VERSIONNUM)
     C+ VALUES(
     C***+*CONCAT(CONCAT('mi',TRIM(:GrpID)),TRIM(:UBUSER)),*:GrpID,                         MD033413
     C+ CONCAT(CONCAT('mi',TRIM(:WrkGrpId)),TRIM(:UBUSER)), :GrpID,                         MD033413
     C+ :UBUSER, :VerNum)
     C/END-EXEC
      *
     C                   ENDIF
      *
     C/EXEC SQL
     C+ FETCH NEXT
     C+ FROM PCursor
     C+ INTO: BFUBPD
     C/END-EXEC
      *
     C                   ENDDO
      *
     C/EXEC SQL
     C+ CLOSE PCursor
     C/END-EXEC
      *
      /EJECT
      *****************************************************************
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
