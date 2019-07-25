     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2011')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Upload to BF - Zones')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SM000053 - Midas SM Upload to BF - Zones                     *
      *                                                               *
      *  (c) Finastra International Limited 2011                      *
      *                                                               *
      *  Last Amend No. AR1085933          Date 06Feb13               *
      *  Prev Amend No. AR989186           Date 06Feb13               *
      *                 AR883210           Date 21Dec11               *
      *                 CBF005   *CREATE   Date 04Jul11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR1085933 - Trim spaces on uploaded details                  *
      *  AR989186 - Update mapping to BFTB_PERSISTENTTAG and BFTB_ZONE*
      *           - Applied for AR1085933                             *
      *  AR883210 - Additional Deliverables for BF                    *
      *  CBF005 - BF Infrastructure: Single Security User Maintenance *
      *           Profile                                             *
      *                                                               *
      *****************************************************************
      *
     D ZoneName        S            100
     D ZoneDesc        S            255
     D BaseCurr        S              3
     D ZonePref        S             30
     D Count           S              2  0
      *
     D Recursive       S              1    INZ('N')
      *
     D ZONE          E DS                  EXTNAME(GPZONEPD)
     D BFZN          E DS                  EXTNAME(BFTB_ZONE)
      *
     C/EXEC SQL
     C+ DECLARE ZNcursor CURSOR FOR
     C+ select * from GPZONEPD
     C/END-EXEC
      *
     C/EXEC SQL
     C+ OPEN ZNcursor
     C/END-EXEC
      *
     C/EXEC SQL
     C+ FETCH NEXT
     C+ FROM ZNcursor
     C+ INTO: ZONE
     C/END-EXEC
      *
     C                   DOW       SQLCODE = 0
      *
     C                   EVAL      ZoneName = ZOZONE
     C**********         EVAL      ZoneDesc = ZODESC                                        AR989186
      *                                                                                     AR989186
      * BFDESCRIPTION field is expected to have                                             AR989186
      * ZOZONE value by the user maintenance API                                            AR989186
      *                                                                                     AR989186
     C                   EVAL      ZoneDesc = ZOZONE                                        AR989186
      *                                                                                     AR989186
     C                   EVAL      ZonePref = %TRIM(ZOMSYS)
      *
     C                   EXSR      WriteRec
      *
     C/EXEC SQL
     C+ FETCH NEXT
     C+ FROM ZNcursor
     C+ INTO: ZONE
     C/END-EXEC
      *
     C                   ENDDO
      *
     C/EXEC SQL
     C+ CLOSE ZNcursor
     C/END-EXEC
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
     C+ select COUNT(*) INTO :Count
     C+ from BFTB_ZONE where BFNAMEPK = :ZoneName
     C/END-EXEC
      *
     C     Count         IFEQ      0
      *
     C/EXEC SQL
     C+ insert into BFTB_ZONE(BFNAMEPK,
     C+ BFDESCRIPTION, VERSIONNUM, BFDATASOURCENAME,
     C+ BFSEPARATOR, BFLIBRARYPREFIX, BFSYSTEMPREFIX,
     C+ BFCOBISRUNNING)
     C*+*values(:ZoneName,*:ZoneDesc,*1,*'BANKFUSION',*trim(:ZonePref),********            AR1085933
     C+ values(trim(:ZoneName), trim(:ZoneDesc), 1,                                        AR1085933
     C+ 'BANKFUSION', trim(:ZonePref),                                                     AR1085933
     C+ trim(:ZonePref), trim(:ZonePref) , 0)
     C/END-EXEC
     C                   ELSE
     C/EXEC SQL
     C+ update BFTB_ZONE
     C*+*set*BFDESCRIPTION*=*:ZoneDesc,****************************************            AR1085933
     C+ set BFDESCRIPTION = trim(:ZoneDesc),                                               AR1085933
     C+ BFLIBRARYPREFIX = trim(:ZonePref),
     C+ BFSEPARATOR = trim(:ZonePref),
     C+ BFDATASOURCENAME = 'BANKFUSION',
     C+ VERSIONNUM = 1,
     C+ BFCOBISRUNNING = 0,
     C+ BFSYSTEMPREFIX = TRIM(:ZonePref)
     C+ where BFNAMEPK = :ZoneName
     C/END-EXEC
      *
     C                   ENDIF
     C/EXEC SQL                                                                            AR1085933
     C+ select COUNT(*) INTO :Count                                                        AR1085933
     C+ from BFTB_PERSISTENTTAG                                                            AR1085933
     C+ where BFPERSISTENTTAGSIDPK = :ZonePref                                             AR1085933
     C/END-EXEC                                                                            AR1085933
      *                                                                                    AR1085933
     C     Count         IFEQ      0                                                       AR1085933
      *
     C/EXEC SQL
     C+ select BJCYCD into :BaseCurr
     C+ from GZSDBANKPD where BJZONE = :ZoneName
     C/END-EXEC
      *
      *
     C/EXEC SQL
     C+ insert into BFTB_PERSISTENTTAG(BFPERSISTENTTAGSIDPK,
     C+ BFWEBSERVICEAVAILABILITY, BFISPAUSED,
     C+ BFBASECURRENCYCODE, VERSIONNUM, BFBALANCEFROZEN,
     C+ BFAUTHENTICATEWEBSERVICES, BFISATMONLINE)
     C+ values(TRIM(:ZonePref), 0, 'N',
     C+ :BaseCurr, 1, 0,
     C+ 1, 'N')
     C/END-EXEC
      *
     C                   ENDIF                                                             AR1085933
      *                                                                                    AR1085933
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
     C                   IF        Recursive = *BLANKS
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
