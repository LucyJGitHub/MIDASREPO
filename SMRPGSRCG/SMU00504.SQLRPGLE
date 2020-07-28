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

      ** Program work variables
     D RecType         S              3A
     D TableName       S             50A
     D UniqueFld       S             50A
     D TableFlds       S           2000A
     D SQLStmt         S           2000A   VARYING INZ
     D WErrFlag        S              1A   INZ(*BLANK)
     D Status          S              1A
     D WRun            S              1A

     D/COPY GPCPYSRCG,PSDS

     C     *ENTRY        PLIST
     C                   PARM                    PLayer
     C                   PARM                    PBFLib
     C                   PARM                    PNewBFLib
     C                   PARM                    PReturn


     C/exec SQL
     C+ declare BFMC cursor for
     C+ select
     C+   BFRTYP
     C+ , BFTABL
     C+ , BFUFLD
     C+ , BFTFLD
     C+ from SMBFMCTD
     C+ where
     C+     BFSTAT <> 'C'
     C+ and BFLAYR = :PLayer
     C+ order by
     C+   BFRTYP desc, BFRECI asc
     C/end-exec

     C/exec SQL
     C+ open BFMC
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from BFMC
     C+ into
     C+   :RecType
     C+ , :TableName
     C+ , :UniqueFld
     C+ , :TableFlds
     C/end-exec

     C                   DOW       SQLCOD <> 100

     C                   IF        SQLCOD <> 0 and SQLCOD <> 100
     C                   EVAL      PReturn = 'E'
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Build the SQL statement depending on the record type
     C                   IF        RecType = 'INS'
     C                   EVAL      SQLStmt = 'insert into '
     C                                      + %trim(PNewBFLiB) + '/'
     C                                      + %trim(TableName) + '('
     C                                      + %trim(TableFlds) + ')'
     C                                      + '(select '
     C                                      + %trim(TableFlds)
     C                                      + ' from '
     C                                      + %trim(PBFLiB) + '/'
     C                                      + %trim(TableName)
     C                                      + ' where '
     C                                      + %trim(UniqueFld)
     C                                      + ' not in '
     C                                      + '(select '
     C                                      + %trim(UniqueFld)
     C                                      + ' from '
     C                                      + %trim(PNewBFLiB) + '/'
     C                                      + %trim(TableName) + '))'
     C                   ENDIF

     C                   IF        RecType = 'CRT'
     C                   EVAL      SQLStmt = %trim(TableFlds)
     C                   ENDIF

      ** Execute SQL
     C/exec SQL
     C+ prepare S1 from :SQLStmt
     C/end-exec

     C/exec SQL
     C+ execute S1
     C/end-exec

      ** If error in SQL execution, then update status as failed
      ** Else, set status as completed.
     C                   IF        SQLCOD <> 0 and SQLCOD <> 100
     C                   EVAL      WErrFlag = 'Y'
     C                   EVAL      Status = 'F'
     C                   ELSE
     C                   EVAL      Status = 'C'
     C                   ENDIF

     C/exec SQL
     C+ update SMBFMCTD
     C+ set BFSTAT = :Status
     C+ where current of BFMC
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from BFMC
     C+ into
     C+   :RecType
     C+ , :TableName
     C+ , :UniqueFld
     C+ , :TableFlds
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close BFMC
     C/end-exec

      ** If atleast one failed SQL, then end program abnormally
     C                   IF        WErrFlag = 'Y'
     C                   EVAL      PReturn = 'E'
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      *INLR = *ON
     C                   RETURN

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

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR
      *****************************************************************
