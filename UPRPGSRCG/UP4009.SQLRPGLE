
     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2020')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP - ADBU create drive file *GLOBAL')
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP4009 - ADBU Create drvier file *GLOBAL                     *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. MD061690             Date 27Jul23             *
      *  Prev Amend No. MD060709             Date 08Nov22             *
      *                 MD060961             Date 23Jan23             *
      *                 MD059751             Date 25Mar22             *
      *                 MD059742             Date 23Mar22             *
      *                 MD058585             Date 17Aug21             *
      *                 CUT017 *CREATE       Date 17Mar20             *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD061690 - File GPSRAJW0 was deleted because one of its      *
      *             dependency was deleted                            *
      *  MD060709 - Change in LF dynamic selection is omitted         *
      *             File is not deleted when both DTAARA and file     *
      *             have the same name.                               *
      *             Change in PF key is omitted                       *
      *  MD060961 - File is not created when both DTAARA and file     *
      *             have the same name.                               *
      *             Discard LF if dependency is not found in the      *
      *             current system in case 'File missing'             *
      *  MD059751 - SQL view statement change is not detected by aDBU *
      *  MD059742 - Cope with change in Alternative field name        *
      *  MD058585 - aDBU does not detect if LF has different keys     *
      *  CUT017 - Adaptive Database Upgrade                           *
      *                                                               *
      *****************************************************************
      /EJECT

     D RdLib           S             10
     D ChkFile         S             10
     D RdFile          S             10
     D C_LIB           S             10
     D @NwFld          S              1
     D @AmFld          S              1
     D @NwFl           S              1
     D @MisFl          S              1
     D @FlDup          S              1
     D @ATICAP         S              1
     D @ATACCP         S              1
     D @SQLSTM         S              1                                                     MD059751
     D @FileC          S              1
     D RcdCount        S              5  0
     D RcdCount2       S              5  0
     D @Like           S              3
     D @LikeP          S              3                                                     MD060961
     D RcdCount3       S              5  0                                                  MD060961
     D @DTAQ           S              1
     D @DTAARA         S              1
     D TotalDel        S              5  0                                                  MD061690
     D IGNORE          S              1                                                     MD061690

     D UPGLOG        E DS                  EXTNAME(UPCLOGPD)
     D UPGDRV        E DS                  EXTNAME(UPGDRVTD)
      /EJECT

     C     *ENTRY        PLIST
     C                   PARM                    Lib1              2
     C                   PARM                    RefSys            2

     C                   eval      @Like = RefSys + '%'
     C                   eval      @LikeP = Lib1  + '%'                                     MD060961

      * Read log file and process for each entry
     C/exec SQL
     C+ declare CursorRdZ cursor for
     C+ select distinct WJOB, WFILE
     C+ from UPGLOGPD where SUBSTR(WJOB,1,2) = :Lib1
     C+ order by WJOB, WFILE
     C/end-exec
      *
     C/exec SQL
     C+ open CursorRdZ
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from CursorRdZ
     C+ into
     C+   :RdLib, :RdFile
     C/end-exec

     C                   DOW       SQLCODE = 0

      * If file is reported as dependent file, it can be ignored here
      * Unless it is found in dependent because at least one of its dependency has been     MD061690
      * deleted                                                                             MD061690
     C                   If        %SUBST(RdLib:4:1) = 'V'
     C/exec SQL
     C+ select count(*) into :RcdCount from UPGXRFPD
     C+ where PDEPF = :RdFile
     C/end-exec
     C                   exsr      Check_Del                                                MD061690

     C                   eval      RcdCount3 = 0                                            MD060961
      * check if 'File missing'                                                             MD060961
     C/exec SQL                                                                             MD060961
     C+ select count(*) into :RcdCount3 from UPGLOGPD                                       MD060961
     C+ where WFILE  = :RdFile and WDESC = 'File missing'                                   MD060961
     C/end-exec                                                                             MD060961
     C                   if        RcdCount3 = 1                                            MD060961
      * also, it can be ignored if its dependency does not exist yet                        MD060961
      * in the Prod system (not in the reference system)                                    MD060961
     C/exec SQL                                                                             MD060961
     C+ select count(*) into :RcdCount2 from QADBFDEP                                       MD060961
     C+ where DBFFDP = :RdFile and DBFLDP like :@LikeP                                      MD060961
     C/end-exec                                                                             MD060961
     C                   else                                                               MD060961
      * also, it can be ignored if its dependency does not exist yet
     C/exec SQL
     C+ select count(*) into :RcdCount2 from QADBFDEP
     C+ where DBFFDP = :RdFile and DBFLDP like :@Like
     C/end-exec
     C                   endif                                                              MD060961

     C                   ENDIF

     C                   If        %SUBST(RdLib:4:1) = 'V'
     C                             and RcdCount > 0
     C                             and IGNORE = 'Y'                                         MD061690
     C                             or %SUBST(RdLib:4:1) = 'V'
     C                             and RcdCount2 = 0
     C                   else
     C                   exsr      SR_DetailsZ
     C                   ENDIF
      * Get next
     C/exec SQL
     C+ fetch next
     C+ from CursorRdZ
     C+ into
     C+   :RdLib, :RdFile
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close CursorRdZ
     C/end-exec

      * Now update Exception flag if at least one field is Removed
     C/exec SQL
     C+ update UPGdrvtd d set d.DREXCP = 'Y', d.DRACTN = 'IGNORE'
     C+ where exists (select * from UPGLOGPD l where l.WFILE = d.DRFILE
     C+ and l.WDESC = 'Rmv field')
     C+ and not exists (select * from UPGLOGPD l where l.WFILE = d.DRFILE
     C+  and l.Wflda = 'RFNAME')
     C/end-exec

      * and update DRACTN = 'IGNORE' if flagged as Exception
     C/exec SQL
     C+ update upgdrvtd set DRACTN = 'IGNORE'
     C+ where DREXCP ='Y'
     C/end-exec

      * and update DRACTN = 'IGNORE' for any LF for which its dependency is flagged
      * as 'IGNORE'
     C/exec SQL
     C+ update upgdrvtd u set u.DRACTN = 'IGNORE'
     C+ where exists (select * from UPGXRIPD i where i.PDEPF = u.DRFILE)
     C/end-exec

     C                   SETON                                            LR
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SR_DetailsZ -                                                 *
      *                                                               *
      *****************************************************************
     C     SR_DetailsZ   BEGSR

      * Initialize work fields
     C                   eval      @NwFl = *BLANKS
     C                   eval      @MisFl = *BLANKS
     C                   eval      @NwFld = *BLANKS
     C                   eval      @AmFld = *BLANKS
     C                   eval      @FlDup = *BLANKS
     C                   eval      @ATICAP = *BLANKS
     C                   eval      @ATACCP = *BLANKS
     C                   eval      @SQLSTM = *BLANKS                                        MD059751
     C                   eval      @FileC = *BLANKS
     C                   eval      @DTAQ = *BLANKS
     C                   eval      @DTAARA = *BLANKS

      * Reset Exception flag
     C                   eval      DREXCP = 'N'
     C                   eval      DRACTN = *BLANKS

      * Read log file by WJOB, WFILE and WDSP
     C/exec SQL
     C+ declare EachRdZ cursor for
     C+ select * from UPGLOGPD
     C+ where WJOB = :RdLib and WFILE = :RdFile
     C+ order by WJOB, WFILE, WDSP
     C/end-exec
      *
     C/exec SQL
     C+ open EachRdZ
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from EachRdZ
     C+ into  :UPGLOG
     C/end-exec

     C                   DOW       SQLCODE = 0

      ** As UPZLOGPD is read with DISTINCT, only one record is processed in case            MD060961
      ** both File and DTAARA are new. In that case, check @NwFl. If set to 'Y' and         MD060961
      ** WDESC is now 'New DTAARA', both objects are to be created.                         MD060961
      ** Same is applied in case both DTAARA and file are deleted.                          MD060709
                                                                                            MD060961
      * if new PF file
     C                   if        (WDESC = 'New file'
     C                             and %SUBST(WJOB:4:1) <> 'V')
     C                   eval      @NwFl = 'Y'

      * Get next
     C/exec SQL
     C+ fetch next
     C+ from EachRdZ
     C+ into :UPGLOG
     C/end-exec

     C                   iter
     C                   ENDIF

     C                   if        WDESC = 'File missing'
     C                   eval      @MisFl = 'Y'

      * but do not ignore if its dependency is not found in Ref System (dpcy by default retained)
      * but same dependent is found in the Ref System (e.g. UPGSVALJ0)
      * in that case file must be deleted

      * Read log file and process for each entry
     C/exec SQL
     C+ declare CursorChk cursor for
     C+ select PDEPF
     C+ from UPGXRFPD where PMFILE = :WFILE
     C/end-exec

     C/exec SQL
     C+ open CursorChk
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from CursorChk
     C+ into :ChkFile
     C/end-exec

     C                   DOW       SQLCODE = 0

     C/exec SQL
     C+ select count(*) into :RcdCount2 from QADBFDEP
     C+ where DBFFDP = :ChkFile and DBFLDP like :@Like
     C/end-exec
     C                   if        RcdCount2 > 0
     C                   eval      @MisFl = 'X'
     C                   leave
     C                   endif
     C/exec SQL
     C+ fetch next
     C+ from CursorChk
     C+ into :ChkFile
     C/end-exec

     C                   ENDDO
     C/exec SQL
     C+ close CursorChk
     C/end-exec

      * also, do not ignore (and delete) if file is found in a different library (e.g. T_WIPCF)
     C                   eval      C_LIB = RefSys + 'GMLIB'
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *blanks       ExistYN          10
     C                   PARM      WFILE         DFFILE           10
     C                   PARM      C_LIB         Library          10
     C                   PARM      '*FILE'       ObjectType        8
     C                   PARM      *blanks       Member           10
     C                   IF        ExistYN = 'Exist     '
     C                   eval      @MisFl = 'X'
     C                   else
     C                   eval      C_LIB = RefSys + 'GPLIB'
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *blanks       ExistYN
     C                   PARM      WFILE         DFFILE
     C                   PARM      C_LIB         Library
     C                   PARM      '*FILE'       ObjectType
     C                   PARM      *blanks       Member
     C                   IF        ExistYN = 'Exist     '
     C                   eval      @MisFl = 'X'
     C                   else
     C                   eval      C_LIB = RefSys + 'GTALIB'
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *blanks       ExistYN
     C                   PARM      WFILE         DFFILE
     C                   PARM      C_LIB         Library
     C                   PARM      '*FILE'       ObjectType
     C                   PARM      *blanks       Member
     C                   IF        ExistYN = 'Exist     '
     C                   eval      @MisFl = 'X'
     C                   else
     C                   eval      C_LIB = RefSys + 'GVLIB'
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *blanks       ExistYN
     C                   PARM      WFILE         DFFILE
     C                   PARM      C_LIB         Library
     C                   PARM      '*FILE'       ObjectType
     C                   PARM      *blanks       Member
     C                   IF        ExistYN = 'Exist     '
     C                   eval      @MisFl = 'X'
     C                   endif
     C                   endif
     C                   endif
     C                   endif

      * Get next
     C/exec SQL
     C+ fetch next
     C+ from EachRdZ
     C+ into :UPGLOG
     C/end-exec

     C                   iter
     C                   ENDIF

     C                   if        WDESC = 'New field'
     C                             or WDESC = 'Rmv field'
     C                   eval      @NwFld = 'Y'
      * Get next
     C/exec SQL
     C+ fetch next
     C+ from EachRdZ
     C+ into :UPGLOG
     C/end-exec

     C                   iter
     C                   ENDIF

      * if New Field has been recorded, ignore those which are expected
     C                   if        (WFLDA = 'RFFLDN' or WFLDA = 'RFLEN'
     C                             or WFLDA = 'RFID') and @NwFld = 'Y'
      * Get next
     C/exec SQL
     C+ fetch next
     C+ from EachRdZ
     C+ into :UPGLOG
     C/end-exec

     C                   iter
     C                   ENDIF

     C                   if        WDSP = 'DSPFFD1' and
     C                             (WFLDA = 'WHFLDB' or WFLDA = 'WHFLDD' or
     C                             WFLDA = 'WHFLDT' or WFLDA = 'WHVARL' or
     C                             WFLDA = 'WHCHD1' or WFLDA = 'WHCHD2' or
     C                             WFLDA = 'WHCHD3'or WFLDA = 'WHFTXT' or
     C*********                    WFLDA = 'WHFLDP')                                        MD059742
     C                             WFLDA = 'WHFLDP' or WFLDA = 'WHALIS' or                  MD059742
     C                             WFLDA = 'WHALI2')                                        MD059742
     C                   eval      @AmFld = 'Y'
      * reset the duplicate flag as file will be rebuild
     C                   eval      @FlDup = ' '
      * if field type is becoming G, then 'mark' @ATICAP as this field attribute change
      * expected
     C                   if        WFLDA = 'WHFLDT'
     C                             and %subst(WDATA:22:1) = 'G'
      * or field type was initially G, then 'mark' @ATICAP as this field attribute change
      * expected
     C                             or WFLDA = 'WHFLDT'
     C                             and %subst(WDATA:1:1) = 'G'
     C                             or WFLDA = 'WHFLDT'
      * or 'O'
     C                             and %subst(WDATA:22:1) = 'O'
     C                             or WFLDA = 'WHFLDT'
     C                             and %subst(WDATA:1:1) = 'O'
     C                   eval      @ATICAP = 'X'
     C                   endif

      * Get next
     C/exec SQL
     C+ fetch next
     C+ from EachRdZ
     C+ into :UPGLOG
     C/end-exec

     C                   iter
     C                   ENDIF

     C                   if        WFLDA = 'RFID' or WFLDA = 'RFLEN'
     C                             or WFLDA = 'RFFLDN'
      *  if this is a LF/view, file need to be duplicate instead of SQL Update
     C                             or WDSP  = 'DSPFD_K'                                     MD058585
      *  or if there is a change in the key                                                 MD058585
     C                             or WFLDA = 'Select'                                      MD060709
      *  or if dynamic selection is different                                               MD060709
     C                   If        %SUBST(RdLib:4:1) = 'V'
     C                   eval      @FlDup = 'E'
     C                   else
     C                   eval      @AmFld = 'Y'
     C                   Endif
      * Get next
     C/exec SQL
     C+ fetch next
     C+ from EachRdZ
     C+ into :UPGLOG
     C/end-exec

     C                   iter
     C                   ENDIF

      * Existing file to be duplicated
     C                   if        WFLDA = 'ATJOIN'
     C                             or WFLDA = 'ATSELO'
     C                             or WFLDA = 'ATNOFM'
     C                             or WFLDA = 'ATTXT'
     C                             or WFLDA = 'APNKYF'                                      MD060709
      *  or if dynamic selection is different for PF                                        MD060709
     C                   eval      @FlDup = 'E'
      * Get next
     C/exec SQL
     C+ fetch next
     C+ from EachRdZ
     C+ into :UPGLOG
     C/end-exec

     C                   iter
     C                   ENDIF

      * If change of ATICAP, record it and wait for WHFLDT change to 'G'
     C                   If        WFLDA = 'ATICAP'
     C                   eval      @ATICAP = 'Y'
      * Get next
     C/exec SQL
     C+ fetch next
     C+ from EachRdZ
     C+ into :UPGLOG
     C/end-exec

     C                   iter
     C                   ENDIF

      * these changes go along with ATICAP
     C                   if        WDSP = 'DSPFFD1' and
     C                             (WFLDA = 'WHFLDG' or WFLDA = 'WHFDSL' or
     C                             WFLDA = 'WHPSUD' or WFLDA = 'WHALCH' or
     C                             WFLDA = 'WHSQLT' or WFLDA = 'WHNULL' or
     C                             WFLDA = 'WHDBLL' or WFLDA = 'WHDFT ' or
     C                             WFLDA = 'WHDFTL')
     C                   if        @ATICAP = 'X'
     C                             or @ATICAP = 'Y'
     C                   else
     C                   if        WFLDA = 'WHDFT ' or
     C                              WFLDA = 'WHDFTL'
     C                   eval      @AmFld = 'Y'
     C                   else
     C                   eval      DREXCP = 'Y'
     C                   endif
     C                   endif

      * Get next
     C/exec SQL
     C+ fetch next
     C+ from EachRdZ
     C+ into :UPGLOG
     C/end-exec

     C                   iter
     C                   ENDIF


      * or new LF file to be duplicated
     C                   If        (WDESC = 'New file'
     C                             and %SUBST(WJOB:4:1) = 'V')
     C                   eval      @FlDup = 'N'
      * Get next
     C/exec SQL
     C+ fetch next
     C+ from EachRdZ
     C+ into :UPGLOG
     C/end-exec

     C                   iter
     C                   ENDIF

      * if a change in file
     C                   If        WFLDA = 'ATWAIT' or WFLDA = 'ATTXT'
     C                             or WFLDA = 'ATWATR'
     C                             or WFLDA = 'ATLVLC'
     C                   eval      @FileC = 'Y'
      * Get next
     C/exec SQL
     C+ fetch next
     C+ from EachRdZ
     C+ into :UPGLOG
     C/end-exec

     C                   iter
     C                   ENDIF

      * If change of ATACCP, record it and wait for RFNAME change
     C                   If        WFLDA = 'ATACCP'
     C                   eval      @ATACCP = 'Y'
      * Get next
     C/exec SQL
     C+ fetch next
     C+ from EachRdZ
     C+ into :UPGLOG
     C/end-exec

     C                   iter
     C                   ENDIF

      * If change of Format Name, file will have to be duplicated
     C                   If        WFLDA = 'RFNAME'
      * or if file is now table/view
     C                             or WFLDA = 'ATSQLT'
     C                   eval      @FlDup = 'E'

      * If change of record format, reset @ATACCP field
     C                   eval      @ATACCP = *BLANKS
      * and reset this flag
     C                   eval      @NwFld = ' '
      * leave as file will be duplicated, there is no need to check further
     C                   leave
      * Get next
     C/exec SQL
     C+ fetch next
     C+ from EachRdZ
     C+ into :UPGLOG
     C/end-exec

     C                   iter
     C                   ENDIF

      * If SQL statement view  is changed                                                   MD059751
     C                   If        WDESC = 'SQL view statement'                             MD059751
     C                   eval      @SQLSTM = 'Y'                                            MD059751
      * Get next                                                                            MD059751
     C/exec SQL                                                                             MD059751
     C+ fetch next                                                                          MD059751
     C+ from EachRdZ                                                                        MD059751
     C+ into :UPGLOG                                                                        MD059751
     C/end-exec                                                                             MD059751
                                                                                            MD059751
     C                   iter                                                               MD059751
     C                   ENDIF                                                              MD059751
                                                                                            MD059751
      * If DTAQ
     C                   If        WTYPE = 'DTAQ'
     C                   Select
     C                   when      WDESC = 'DTAQ missing'
     C                   eval      @DTAQ = 'M'

     C                   when      WDESC = 'New DTAQ'
     C                   eval      @DTAQ = 'N'

     C                   other
     C                   eval      @DTAQ = 'A'
     C                   endsl
      * Get next
     C/exec SQL
     C+ fetch next
     C+ from EachRdZ
     C+ into :UPGLOG
     C/end-exec

     C                   iter
     C                   ENDIF

      * If DTAAARA
     C                   If        WTYPE = 'DTAA'
     C                   Select
     C                   when      WDESC = 'DTAARA missing'
     C                   eval      @DTAARA = 'M'

     C                   when      WDESC = 'New DTAARA'
     C                   eval      @DTAARA = 'N'

     C                   other
     C                   eval      @DTAARA = 'A'
     C                   endsl
      * Get next
     C/exec SQL
     C+ fetch next
     C+ from EachRdZ
     C+ into :UPGLOG
     C/end-exec

     C                   iter
     C                   ENDIF

     C                   DUMP
     C                   eval      DREXCP = 'Y'
      * Get next
     C/exec SQL
     C+ fetch next
     C+ from EachRdZ
     C+ into :UPGLOG
     C/end-exec

     C                   iter
     C                   ENDDO

     C/exec SQL
     C+ close EachRdZ
     C/end-exec

      * Now, analyze results
     C                   if        @NwFld = 'Y'
     C                             or @AmFld = 'Y'
     C                   eval      DRACTN = 'SQL Update'
     C                   eval      DRALLC = 'N'
     C                   ENDIF

     C                   if        @NwFl = 'Y'
     C                   eval      DRACTN = 'File will be copied'
     C                   eval      DRALLC = 'N'
     C                   ENDIF

      * By 'default', file not existing in reference system will be kept
     C                   if        @MisFl = 'Y'
     C                   eval      DRACTN = 'IGNORE'
     C                   eval      DRALLC = 'Y'
     C                   ENDIF

     C                   if        @MisFl = 'X'
     C                   eval      DRACTN = 'File will be deleted'
     C                   ENDIF

     C                   if        @FlDup = 'E'
     C                   eval      DRACTN = 'Existing file will be duplicated'
     C                   eval      DRALLC = 'N'
     C                   ENDIF

     C                   if        @FlDup = 'N'
     C                   eval      DRACTN = 'New file will be duplicated'
     C                   eval      DRALLC = 'N'
     C                   ENDIF

     C                   if        @FileC = 'Y'
     C                   eval      DRFLCH = 'Y'
     C                   if        DRACTN = *blanks
     C                   eval      DRACTN = 'File will be changed'
     C                   endif
     C                   else
     C                   eval      DRFLCH = 'N'
     C                   ENDIF

     C                   if        @DTAQ = 'N'
     C                   eval      DRACTN = 'New DTAQ will be duplicated'
     C                   eval      DRALLC = 'N'
     C                   ENDIF

     C                   if        @DTAQ = 'M'
     C                   eval      DRACTN = 'IGNORE'
     C                   eval      DRALLC = 'Y'
     C                   ENDIF

     C                   if        @DTAQ = 'A'
     C                   eval      DRACTN = 'Existing DTAQ will be duplicated'
     C                   eval      DRALLC = 'N'
     C                   ENDIF

     C                   if        @DTAARA = 'N'
      ** Check first @NwFl. If set to 'Y' then 2 records must be written in the driver      MD060961
     C                   if        @NwFl = 'Y'                                              MD060961
     C/EXEC SQL                                                                             MD060961
     C+ insert into UPGDRVTD                                                                MD060961
     C+ (                                                                                   MD060961
     C+   DRPRFX                                                                            MD060961
     C+  ,DRFILE                                                                            MD060961
     C+  ,DRLIB                                                                             MD060961
     C+  ,DRACTN                                                                            MD060961
     C+  ,DRALLC                                                                            MD060961
     C+  ,DRFLCH                                                                            MD060961
     C+  ,DREXCP                                                                            MD060961
     C+  ,DRSCRP                                                                            MD060961
     C+  ,DRUPDD                                                                            MD060961
     C+ )                                                                                   MD060961
     C+ Values                                                                              MD060961
     C+ (                                                                                   MD060961
     C+   :Lib1                                                                             MD060961
     C+  ,:WFILE                                                                            MD060961
     C+  ,:WJOB                                                                             MD060961
     C+  ,:DRACTN                                                                           MD060961
     C+  ,:DRALLC                                                                           MD060961
     C+  ,:DRFLCH                                                                           MD060961
     C+  ,:DREXCP                                                                           MD060961
     C+  ,' '                                                                               MD060961
     C+  ,' '                                                                               MD060961
     C+ )                                                                                   MD060961
     C/END-EXEC                                                                             MD060961
     C                                                                                      MD060961
     C                   ENDIF                                                              MD060961
     C                   eval      DRACTN = 'New DTAARA will be duplicated'
     C                   eval      DRALLC = 'N'
     C                   ENDIF

     C                   if        @DTAARA = 'M'
      ** Check first @MisFl. If set to 'Y' then 2 records must be written in the driver     MD060709
     C                   if        @MisFl = 'Y'                                             MD060709
     C/EXEC SQL                                                                             MD060709
     C+ insert into UPGDRVTD                                                                MD060709
     C+ (                                                                                   MD060709
     C+   DRPRFX                                                                            MD060709
     C+  ,DRFILE                                                                            MD060709
     C+  ,DRLIB                                                                             MD060709
     C+  ,DRACTN                                                                            MD060709
     C+  ,DRALLC                                                                            MD060709
     C+  ,DRFLCH                                                                            MD060709
     C+  ,DREXCP                                                                            MD060709
     C+  ,DRSCRP                                                                            MD060709
     C+  ,DRUPDD                                                                            MD060709
     C+ )                                                                                   MD060709
     C+ Values                                                                              MD060709
     C+ (                                                                                   MD060709
     C+   :Lib1                                                                             MD060709
     C+  ,:WFILE                                                                            MD060709
     C+  ,:WJOB                                                                             MD060709
     C+  ,:DRACTN                                                                           MD060709
     C+  ,:DRALLC                                                                           MD060709
     C+  ,:DRFLCH                                                                           MD060709
     C+  ,:DREXCP                                                                           MD060709
     C+  ,' '                                                                               MD060709
     C+  ,' '                                                                               MD060709
     C+ )                                                                                   MD060709
     C/END-EXEC                                                                             MD060709
     C                                                                                      MD060709
     C                   ENDIF                                                              MD060709
      * keep IGNORE to be consistent with missing file                                      MD060709
     C                   eval      DRACTN = 'IGNORE'
     C                   eval      DRALLC = 'Y'
     C                   ENDIF

     C                   if        @DTAARA = 'A'
     C                   eval      DRACTN = 'Existing DTAARA will be duplicated'
     C                   eval      DRALLC = 'N'
     C                   ENDIF

      * flag EXCEPTION if @ATICAP is still 'Y' or @ATACCP
     C                   if        @ATICAP = 'Y'
     C                             or @ATACCP = 'Y'
      * only if value after is K (if change from key to non-key,
     C                   eval      DREXCP = 'Y'
     C                   endif

     C                   if        DREXCP = 'Y'
     C                   eval      DRALLC = 'Y'
     C                   endif

      * if the SQL statement view was changed and file has not been reported yet            MD059751
     C                   if        @SQLSTM = 'Y'  and DRACTN = ' '                          MD059751
     C                   eval      DRACTN = 'Existing file will be duplicated'              MD059751
     C                   eval      DRALLC = 'N'                                             MD059751
     C                   ENDIF                                                              MD059751
                                                                                            MD059751
     C/EXEC SQL
     C+ insert into UPGDRVTD
     C+ (
     C+   DRPRFX
     C+  ,DRFILE
     C+  ,DRLIB
     C+  ,DRACTN
     C+  ,DRALLC
     C+  ,DRFLCH
     C+  ,DREXCP
     C+  ,DRSCRP
     C+  ,DRUPDD
     C+ )
     C+ Values
     C+ (
     C+   :Lib1
     C+  ,:WFILE
     C+  ,:WJOB
     C+  ,:DRACTN
     C+  ,:DRALLC
     C+  ,:DRFLCH
     C+  ,:DREXCP
     C+  ,' '
     C+  ,' '
     C+ )
     C/END-EXEC
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************                  MD061690
      *                                                                  *                  MD061690
      * Check_Del - GPSRAJW0 is reported as dependent because            *                  MD061690
      *             GPRELHPD has been made redundant. But GPSRAJW0       *                  MD061690
      *             should not be deleted, its script must be updated    *                  MD061690
      *             instead.                                             *                  MD061690
      *             This SR checks that if a dependent file is reported  *                  MD061690
      *             1. it does exist in the reference system             *                  MD061690
      *             2. if yes, it checks if its dependency (in the ref   *                  MD061690
      *             system) are existing in UPGLOGPD. If it is the case  *                  MD061690
      *             then it can be ignored as it will be automatically   *                  MD061690
      *             rebuild with the dependency.                         *                  MD061690
      *             But if it is not the case, then it cannot be ignored *                  MD061690
      *                                                                  *                  MD061690
      ********************************************************************                  MD061690
      *                                                                                     MD061690
     C     Check_Del     BEGSR                                                              MD061690
                                                                                            MD061690
     C                   eval      IGNORE = 'Y'                                             MD061690
     C                   eval      TotalDel = 0                                             MD061690
                                                                                            MD061690
      ** Does file exist in reference system?                                               MD061690
     C                   eval      C_LIB = RefSys + 'GVLIB'                                 MD061690
                                                                                            MD061690
     C                   CALL      'UTCHKOBJ'                                               MD061690
     C                   PARM      *blanks       ExistYN                                    MD061690
     C                   PARM      RdFile        DFFILE                                     MD061690
     C                   PARM      C_LIB         Library                                    MD061690
     C                   PARM      '*FILE'       ObjectType                                 MD061690
     C                   PARM      *blanks       Member                                     MD061690
                                                                                            MD061690
      ** If it does, check its dependency                                                   MD061690
     C                   IF        ExistYN = 'Exist     '                                   MD061690
                                                                                            MD061690
     C/exec SQL                                                                             MD061690
     C+ select count(*) into :TotalDel from UPGLOGPD                                        MD061690
     C+ where WFILE in (select DBFFIL  from QADBFDEP                                        MD061690
     C+ where DBFFDP = :RdFile  and DBFLDP = :C_LIB)                                        MD061690
     C/end-exec                                                                             MD061690
                                                                                            MD061690
      ** If none of the dependencies are found, do not ignore                               MD061690
     C                   If        TotalDel = 0                                             MD061690
     C                   eval      IGNORE = 'N'                                             MD061690
     C                   Endif                                                              MD061690
     C                                                                                      MD061690
     C                   ENDIF                                                              MD061690
                                                                                            MD061690
     C                   ENDSR                                                              MD061690
      *                                                                                     MD061690
      ********************************************************************                  MD061690
      /EJECT                                                                                MD061690
