     H DEBUG
     H COPYRIGHT('(c) Finastra International 2021')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP Deliverable Data Split take-on')              *
/*OVRF*: OVRDBF UPGXRFPD UPXREFPD
      *****************************************************************
      *                                                               *
      *  Midas - Upgrade Module                                       *
      *                                                               *
      *  UP0352 - Midas UP Deliverable Data Split take-on             *
      *                                                               *
      *  (c) Finastra International Limited 2021                      *
      *                                                               *
      *  Last Amend No. MD058953 *CREATE     Date 29Sep21             *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058953 - Problem with DDS data take-on                     *
      *           - Applied for MD-59211                              *
      *                                                               *
      *****************************************************************
     D SQLEOF          C                   Const( 100 )
     D SQLOK           C                   Const( 0 )

     D PFOld           S             10A   DIM(300)
     D Idx             S              5  0
     D TotRow          S             13  0
     D sqlStat         S            500A
     D SQLDynStmt      S            500A
     D OLDNM           S             10
     D Layer           S             10

     D Command         S           6000
     D CommandLen      S             15  5 INZ(5000)
     D ALLF            S           5500
     D UPDLVC        E DS                  EXTNAME(UPDLVCPD)
       /EJECT
      *****************************************************************
      *                                                               *
      *  MAIN PROCESSING                                              *
      *                                                               *
      *****************************************************************

     C     *ENTRY        PLIST
     C                   PARM                    MOVLIB           10
     C                   PARM                    BRGBRGLIB        10
     C                   PARM                    SAVF             10
     C                   PARM                    DLDTALIB         10
     C                   PARM                    Return           10

     C                   EVAL      Idx = 0
     C                   If        %subst(MOVLIB:5:1) = 'G'
     C                   eval      Layer = '*GLOBAL'
     C                   else
     C                   eval      Layer = '*ZONE'
     C                   ENDIF

      * if UPDDSFPD is not part of the delivery, assume no NEW DDS file (hence no take-on)
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *BLANK        RtnCode          10
     C                   PARM      'UPDDSFPD'    ObjFil           10
     C                   PARM                    DLDTALIB
     C                   PARM      '*FILE'       ObjType           8
     C                   PARM                    ChkMbr           10

      * if the file does exist, add it in array for back up
     C                   IF        RtnCode <> 'Exist     '
     C                   EVAL      Return = '*NONE'
     C                   seton                                        LR
     C                   return
     C                   ENDIF


      * determine DDS files being delivered
     C                   eval      sqlStat = 'select * from ' +
     C                             %trim(BRGBRGLIB) + '/UPDLVCPD' +
     C                             ' WHERE substr(AUMBNM,6,3) = ''CTD'' ' +
     C                             ' and AUMBTP = ''SQLTBL'' ' +
     C                             ' and AUDTLB = ' + '''' + Layer  +
     C                             ''''

     C/EXEC SQL
     C+ prepare sqlStat
     C+ from :sqlStat
     C/END-EXEC

     C/exec SQL
     C+ declare UPDLVCursor insensitive scroll cursor for
     C+ sqlStat
     C/end-exec

     C/exec SQL
     C+ open UPDLVCursor
     C/end-exec

      ** Get the number of rows of the selected records.
     C/exec SQL
     C+ get diagnostics :TotRow  = db2_number_rows
     C/end-exec

     C                   If        TotRow = 0
     C                   EVAL      Return = '*NONE'
     C                   seton                                        LR
     C                   return
     C                   ENDIF

     C/exec SQL
     C+ fetch next from UPDLVCursor into :UPDLVC
     C/end-exec

      ** Process while record on file.
     C                   DOW       SQLCODE = 0

      * retrieve corresponding name of the non-DDS file, these are stored in
      * UPDDSFPD which may not be up-to-date yet as the file is part of the delivery
     C                   eval      SQLDynStmt = 'select DDSORF from ' +
     C                             %trim(DLDTALIB) + '/UPDDSFPD where ' +
     C                             ' DDSNWF = ' + '''' + AUMBNM + ''''

     C/EXEC SQL
     C+ prepare DynSQLStmnt
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ declare C1 cursor with return to client for DynSQLStmnt
     C/end-exec

     C/EXEC SQL
     C+ open C1
     C/END-EXEC

     C/EXEC SQL
     C+ fetch C1 into :OLDNM
     C/END-EXEC

     C                   If        SQLCODE = 0
      * check that the file is in the backup library
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *BLANK        RtnCode          10
     C                   PARM                    OLDNM            10
     C                   PARM      MOVLIB        ObjLib           10
     C                   PARM      '*FILE'       ObjType           8
     C                   PARM                    ChkMbr           10

      * if the file does exist, add it in array for back up
     C                   IF        RtnCode = 'Exist     '
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      PFOld(Idx) = OLDNM
     C                   IF        OLDNM = 'SCSARDPD'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      PFOld(Idx) = 'SCSAREPD'
     C                   ENDIF
     C                   IF        OLDNM = 'GPSARDPD'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      PFOld(Idx) = 'GPSAREPD'
     C                   ENDIF
     C                   IF        OLDNM = 'SCSARSPD'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      PFOld(Idx) = 'SCSARZPD'
     C                   ENDIF
     C                   ENDIF

     C/EXEC SQL
     C+ close C1
     C/END-EXEC

     C                   Endif
      *
     C/exec SQL
     C+ fetch next from UPDLVCursor into :UPDLVC
     C/end-exec
      *
     C                   ENDDO

     C/exec SQL
     C+ close UPDLVCursor
     C/end-exec

     C                   If        Idx = 0
     C                   EVAL      Return = '*NONE'
     C                   seton                                        LR
     C                   return
     C                   ENDIF


      * check if files need to be saved
     C                   If        Idx >= 1

     C                   eval      ALLF = *blanks
     C                   eval      Idx =  1
     C                   dou       PFOld(Idx) = *blanks
     C                   eval      ALLF = %trimr(ALLF) + ' ' +  PFOld(Idx)
     C                   eval      Idx = Idx + 1
     C                   ENDDO

     C                   EVAL      Command = *blanks
     C                   EVAL      Command = 'SAVOBJ OBJ(' + %trim(ALLF) +
     C                             ') LIB(' + %trim(MOVLIB) +
     C                             ') DEV(*SAVF) SAVF(' + %TRIMR(BRGBRGLIB) +
     C                             '/' + %trim(SAVF) + ')'
     C                   CALL      'QCMDEXC'
     C                   PARM                    Command
     C                   PARM                    CommandLen
     C
     C                   ENDIF

     C                   Seton                                        LR
     C                   Return

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program Exception Error Routine                      *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *PSSR         BEGSR

     C                   DUMP

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   EVAL      Return = '*ERROR'
     C                   RETURN

     C                   ENDSR

      ********************************************************************
