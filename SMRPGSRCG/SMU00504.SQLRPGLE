     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2020')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Migrate Data of Old Platform Schema')         *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SMU00504 - Migrate Data of Old FusionBanking Platform Schema *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. MD050405  *CREATE  Date 03Jun20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD050405 - Fusion Midas 2.1 Platform Upgrade                 *
      *                                                               *
      *****************************************************************

      ** Program entry parameters
     D PLayer          S              7A
     D PBFLib          S             10A
     D PNewBFLib       S             10A
     D PReturn         S              1A

      ** Parameter variables for access object GPAOSVALR0
     D PRtCd           S              7A   INZ(*BLANKS)
     D PSysVal01       S             20A   INZ(*BLANKS)
     D PSysValCurS01   S            200A   INZ(*BLANKS)
     D PSysVal02       S             20A   INZ(*BLANKS)
     D PSysValCurS02   S            200A   INZ(*BLANKS)
     D PSysVal03       S             20A   INZ(*BLANKS)
     D PSysValCurS03   S            200A   INZ(*BLANKS)
     D PSysVal04       S             20A   INZ(*BLANKS)
     D PSysValCurS04   S            200A   INZ(*BLANKS)
     D PSysVal05       S             20A   INZ(*BLANKS)
     D PSysValCurS05   S            200A   INZ(*BLANKS)
     D PSysVal06       S             20A   INZ(*BLANKS)
     D PSysValCurS06   S            200A   INZ(*BLANKS)
     D PSysVal07       S             20A   INZ(*BLANKS)
     D PSysValCurS07   S            200A   INZ(*BLANKS)
     D PSysVal08       S             20A   INZ(*BLANKS)
     D PSysValCurS08   S            200A   INZ(*BLANKS)
     D PSysVal09       S             20A   INZ(*BLANKS)
     D PSysValCurS09   S            200A   INZ(*BLANKS)
     D PSysVal10       S             20A   INZ(*BLANKS)
     D PSysValCurS10   S            200A   INZ(*BLANKS)

      ** Program work variables
     D RecType         S              3A
     D TableName       S             50A
     D UniqueFld       S             50A
     D TableFlds       S           1500A
     D SQLStmt         S           1500A   VARYING INZ
     D SQLScript       S            200A   VARYING INZ
     D WErrFlag        S              1A   INZ(*BLANK)
     D Status          S              1A
     D Marker          S              4S 0 INZ(0)
     D PreMarker       S           1500A   VARYING INZ
     D PostMarker      S           1500A   VARYING INZ
     D PZone           S              2A
     D PGlobalSysID    S              2A
     D WZone           S              2A
     D WSQLError       S              1A
     D WRun            S              1A
     D DBASE           s              3S 0

     D/COPY GPCPYSRCG,PSDS
      ** Program Status Data Structure

      *****************************************************************
      ** MAIN PROCESSING
      *****************************************************************

     C     *ENTRY        PLIST
     C                   PARM                    PLayer
     C                   PARM                    PBFLib
     C                   PARM                    PNewBFLib
     C                   PARM                    PReturn

      ** Get first Midas zone
     C/exec SQL
     C+ select ZOMSYS into :PZone
     C+ from GPZONEPD
     C+ fetch first 1 rows only
     C/end-exec

      ** Retrieve global system prefix
     C                   EVAL      PSysVal01 = 'BrgMidasGlobalPrefix'

     C                   CALL      'GPAOSVALR0'
     C                   PARM      *Blank        PRtCd
     C                   PARM                    PSysVal01
     C                   PARM                    PSysValCurS01
     C                   PARM                    PSysVal02
     C                   PARM                    PSysValCurS02
     C                   PARM                    PSysVal03
     C                   PARM                    PSysValCurS03
     C                   PARM                    PSysVal04
     C                   PARM                    PSysValCurS04
     C                   PARM                    PSysVal05
     C                   PARM                    PSysValCurS05
     C                   PARM                    PSysVal06
     C                   PARM                    PSysValCurS06
     C                   PARM                    PSysVal07
     C                   PARM                    PSysValCurS07
     C                   PARM                    PSysVal08
     C                   PARM                    PSysValCurS08
     C                   PARM                    PSysVal09
     C                   PARM                    PSysValCurS09
     C                   PARM                    PSysVal10
     C                   PARM                    PSysValCurS10

      ** Error routine - Retrieval of SysVal failed
     C                   IF        PRtCd <> *BLANKS
     C                   EVAL      DBASE = 001
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   MOVEL     PSysValCurS01 PGlobalSysID

      ** Read all records from Schema Migration Driver File
     C/exec SQL
     C+ declare BFMG cursor for
     C+ select BFRTYP, BFTABL, BFUFLD, BFTFLD
     C+ from SMBFMGTD
     C+ where BFSTAT <> 'C'
     C+   and BFLAYR = :PLayer
     C+ order by BFPRTY, BFTABL
     C/end-exec

     C/exec SQL
     C+ open BFMG
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from BFMG
     C+ into :RecType, :TableName, :UniqueFld, :TableFlds
     C/end-exec

     C                   DOW       SQLCOD <> 100

     C                   IF        SQLCOD <> 0 and SQLCOD <> 100
     C                   EVAL      DBASE = 002
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      SQLStmt = *BLANKS

      ** Build the SQL statement depending on the record type
     C                   IF        RecType = 'INS' or
     C                             RecType = 'CRT' or
     C                             RecType = 'UPD' or
     C                             RecType = 'DEL'

     C                   IF        RecType = 'INS' and
     C                             UniqueFld <> *BLANKS

      /free
        SQLStmt = 'insert into ' + %trim(PNewBFLib) + '/' + %trim(TableName)
                + '(' + %trim(TableFlds) + ')'
                + '(select ' + %trim(TableFlds)
                + ' from ' + %trim(PBFLib) + '/' + %trim(TableName)
                + ' where ' + %trim(UniqueFld) + ' not in '
                + '(select ' + %trim(UniqueFld)
                + ' from ' + %trim(PNewBFLib) + '/' + %trim(TableName) + '))';
      /end-free

     C                   ELSE

     C                   EVAL      SQLStmt = %trim(TableFlds)
     C                   EXSR      SRRepMarker

     C                   ENDIF

      ** Prepare and Execute SQL
     C/exec SQL
     C+ prepare S1 from :SQLStmt
     C/end-exec

     C/exec SQL
     C+ execute S1
     C/end-exec

     C                   EXSR      SRChkSQLErr
     C                   ENDIF

     C                   IF        RecType = 'REP'
     C                   EXSR      SRReplicate
     C                   ENDIF

     C/exec SQL
     C+ update SMBFMGTD
     C+ set BFSTAT = :Status
     C+ where current of BFMG
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from BFMG
     C+ into :RecType, :TableName, :UniqueFld, :TableFlds
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close BFMG
     C/end-exec

      ** If atleast one failed SQL, then end program abnormally
     C                   IF        WErrFlag = 'Y'
     C                   EVAL      DBASE = 003
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRepMarker - Subroutine to replace the markers               *
      *                                                               *
      *****************************************************************
     C     SRRepMarker   BEGSR

      ** Scan for marker ? and replace with the new schema library
     C                   EVAL      Marker = %scan( '?' : SQLStmt )
     C                   DOW       Marker > 0
     C                   EVAL      PreMarker = ''
     C                   EVAL      PostMarker = ''
     C                   EVAL      PreMarker  = %subst( SQLStmt : 1 :
     C                                                  Marker-1 )
     C                   EVAL      PostMarker = %subst( SQLStmt  :
     C                                                  Marker+1 )
     C                   EVAL      SQLStmt = %trim(PreMarker) +
     C                                       ' ' + %trim(PNewBFLib) +
     C                                       %trim(PostMarker)
     C                   EVAL      Marker = %scan( '?' : SQLStmt )
     C                   ENDDO

      ** Scan for marker # and replace with the old schema library
     C                   EVAL      Marker = %scan( '#' : SQLStmt )
     C                   DOW       Marker > 0
     C                   EVAL      PreMarker = ''
     C                   EVAL      PostMarker = ''
     C                   EVAL      PreMarker  = %subst( SQLStmt : 1 :
     C                                                  Marker-1 )
     C                   EVAL      PostMarker = %subst( SQLStmt  :
     C                                                  Marker+1 )
     C                   EVAL      SQLStmt = %trim(PreMarker) +
     C                                       ' ' + %trim(PBFLib) +
     C                                       %trim(PostMarker)
     C                   EVAL      Marker = %scan( '#' : SQLStmt )
     C                   ENDDO

      ** Scan for marker <ZZ> and replace with Midas zone
     C                   EVAL      Marker = %scan( '<ZZ>' : SQLStmt )
     C                   DOW       Marker > 0
     C                   EVAL      PreMarker = ''
     C                   EVAL      PostMarker = ''
     C                   EVAL      PreMarker  = %subst( SQLStmt : 1 :
     C                                                  Marker-1 )
     C                   EVAL      PostMarker = %subst( SQLStmt  :
     C                                                  Marker+4 )
     C                   EVAL      SQLStmt = %trim(PreMarker) +
     C                                       %trim(PZone) +
     C                                       %trim(PostMarker)
     C                   EVAL      Marker = %scan( '<ZZ>' : SQLStmt )
     C                   ENDDO

      ** Scan for marker <GG> and replace with Midas Global System Prefix
     C                   EVAL      Marker = %scan( '<GG>' : SQLStmt )
     C                   DOW       Marker > 0
     C                   EVAL      PreMarker = ''
     C                   EVAL      PostMarker = ''
     C                   EVAL      PreMarker  = %subst( SQLStmt : 1 :
     C                                                  Marker-1 )
     C                   EVAL      PostMarker = %subst( SQLStmt  :
     C                                                  Marker+4 )
     C                   EVAL      SQLStmt = %trim(PreMarker) +
     C                                       %trim(PGlobalSysID) +
     C                                       %trim(PostMarker)
     C                   EVAL      Marker = %scan( '<GG>' : SQLStmt )
     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRReplicate - Subroutine to replicate records to all zones    *
      *                                                               *
      *****************************************************************
     C     SRReplicate   BEGSR

      ** Copy records of the new schema file to QTEMP library
      /free
        SQLScript = 'drop table QTEMP/' + %trim(TableName);
      /end-free

     C/exec SQL
     C+ execute immediate :SQLScript
     C/end-exec

      /free
        SQLScript = 'create table QTEMP/' + %trim(TableName)
                  + ' as (select * from '
                  + %trim(PNewBFLib) + '/' + %trim(TableName)
                  + ') with data';
      /end-free

     C/exec SQL
     C+ execute immediate :SQLScript
     C/end-exec

      ** Then, clear the new schema file
      /free
        SQLScript = 'delete from '
                  + %trim(PNewBFLib) + '/' + %trim(TableName);
      /end-free

     C/exec SQL
     C+ execute immediate :SQLScript
     C/end-exec

     C                   EVAL      WSQLError = 'N'
     C                   EXSR      SRChkSQLErr

      ** Read all Midas zones
     C/exec SQL
     C+ declare ZONES cursor for
     C+ select ZOMSYS
     C+ from GPZONEPD
     C/end-exec

     C/exec SQL
     C+ open ZONES
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from ZONES into :WZone
     C/end-exec

     C                   DOW       SQLCOD <> 100 and WSQLError = 'N'

     C                   IF        SQLCOD <> 0 and SQLCOD <> 100
     C                   EVAL      PReturn = 'E'
     C                   EVAL      DBASE = 004
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      SQLStmt = %trim(TableFlds)
     C                   EVAL      PZone = WZone
     C                   EXSR      SRRepMarker

      ** Execute SQL
     C/exec SQL
     C+ prepare S2 from :SQLStmt
     C/end-exec

     C/exec SQL
     C+ execute S2
     C/end-exec

     C                   EXSR      SRChkSQLErr

     C/exec SQL
     C+ fetch next
     C+ from ZONES into :WZone
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close ZONES
     C/end-exec

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRChkSQLErr - Subroutine to check for SQL errors              *
      *                                                               *
      *****************************************************************
     C     SRChkSQLErr   BEGSR

      ** If error in SQL execution, then update status as failed
      ** Else, set status as completed.
     C                   IF        SQLCOD <> 0 and SQLCOD <> 100
     C                   EVAL      WSQLError = 'Y'
     C                   EVAL      WErrFlag = 'Y'
     C                   EVAL      Status = 'F'
     C                   ELSE
     C                   EVAL      Status = 'C'
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF

     C                   EVAL      PReturn = 'E'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR
      *****************************************************************
