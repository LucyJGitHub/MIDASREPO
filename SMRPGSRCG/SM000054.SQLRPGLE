     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2011')
      *****************************************************************
/*XBI *  OVRDBF FILE(QTUSER) TOFILE(GZMUSERDD)                        *
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Upload to BF - Users')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SM000054 - Midas SM Upload to BF - Users                     *
      *                                                               *
      *  (c) Finastra International Limited 2011                      *
      *                                                               *
      *  Last Amend No. MD050393           Date 13Apr18               *
      *  Prev Amend No. MD032152           Date 22Jan15               *
      *                 MD022609           Date 27Sep13               *
      *                 MD022372           Date 12Sep13               *
      *                 MD018386C          Date 23Apr13               *
      *                 AR1085933          Date 06Feb13               *
      *                 AR989186           Date 06Feb13               *
      *                 AR958654           Date 02May12               *
      *                 AR883210           Date 21Dec11               *
      *                 CBF005   *CREATE   Date 04Jul11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD050393 - UXP: Amend user ends in error                     *
      *           - apply trim function to BFUSERID field to avoid    *
      *             UXP data type mismatch                            *
      *  MD032152 - Records not written to BFTUSRZONE if same user is *
      *             defined in a second zone.                         *
      *  MD022609 - System prefix not updated in BFTUSRZONE           *
      *  MD022372 -  Duplicate Key error on user migration            *
      *  MD018386C - Update for BFP3.1 patch changes                  *
      *  AR1085933 - Set USZONE field values in MUSERDD records in    *
      *              all zones                                        *
      *  AR989186 - Set default zone to first zone in GPZONEPD        *
      *           - Applied for AR1085933                             *
      *  AR958654 - Updated Mapping to BFZONE, BFUSERID, BFBMBRANCH   *
      *             BFLANGUAGELOCALE, BFCOUNTRYLOCALE                 *
      *             (Child:AR958655)
      *  AR883210 - Additional Deliverables for BF                    *
      *  CBF005 - BF Infrastructure: Single Security User Maintenance *
      *           Profile                                             *
      *                                                               *
      *****************************************************************
      *
     D UserName        S             10
     D Pass            S             10
     D UserTyp         S             10
     D Zone            S              2
     D ZoneName        S             10
     D DefZone         S             10
     D LogStat         S              2  0
     D InvPass         S              2  0
     D LockOut         S              2  0
     D PassExp         S               d
     D PassInd         S              2  0
     D LogCnt          S              9  0
     D Key             S              5  0 INZ(1)
     D CtryLocale      S              2                                                     AR958654
     D LangLocale      S              2                                                     AR958654
     D UserId          S             50                                                     AR958654
     D DefBranch       S              3                                                     AR958654
     D USZONESTM       S            256                                                    AR1085933
      *
     D Count           S              2  0
      *
     D Recursive       S              1    INZ('N')
      *
     D USER          E DS                  EXTNAME(GZMUSERDD)
     D BFUS          E DS                  EXTNAME(BFTB_USER)
     D UBUS          E DS                  EXTNAME(SMBFUDPD)
     D GPZN          E DS                  EXTNAME(GPZONEPD)                               AR1085933
      *
     C/EXEC SQL
     C+ DECLARE UScursor CURSOR FOR
     C+ SELECT * FROM QTUSER
     C/END-EXEC
      *
     C/EXEC SQL
     C+ OPEN UScursor
     C/END-EXEC
      *
     C/EXEC SQL
     C+ FETCH NEXT
     C+ FROM UScursor
     C+ INTO: USER
     C/END-EXEC
      *
     C                   DOW       SQLCODE = 0
      *
     C                   EVAL      UserName = USRP
     C                   EVAL      Pass = '???'
     C                   EVAL      UserTyp = 'S'
     C                   EVAL      LogStat = 0
     C                   EVAL      PassExp = %date('2014-01-01')
     C                   EVAL      InvPass = 0
     C                   EVAL      LockOut = 0
     C                   EVAL      PassInd  = 0
     C                   EVAL      LogCnt = 0
     C                   EVAL      ZoneName = USZONE
     C                   EVAL      UserId = USER1                                           AR958654
     C                   EVAL      DefBranch = DBRN                                         AR958654
      *                                                                                     AR958654
     C/EXEC SQL                                                                             AR958654
     C+ select substr(LCLOCA,4) into :CtryLocale                                            AR958654
     C+ from UTLCALPD where LCCODE = :MULT                                                  AR958654
     C/END-EXEC                                                                             AR958654
      *                                                                                     AR958654
     C/EXEC SQL                                                                             AR958654
     C+ select substr(LCLOCA,1,2) into :LangLocale                                          AR958654
     C+ from UTLCALPD where LCCODE = :MULT                                                  AR958654
     C/END-EXEC                                                                             AR958654
                                                                                            AR958654
      *                                                                                    AR1085933
      ** If no country and language locale found in UTLCALPD                               AR1085933
      ** default with 'en' and 'GB' - the only supported locales                           AR1085933
      ** as of this writing                                                                AR1085933
      *                                                                                    AR1085933
     C                   IF        CtryLocale = '' OR LangLocale = ''                      AR1085933
     C                   EVAL      CtryLocale = 'GB'                                       AR1085933
     C                   EVAL      LangLocale = 'en'                                       AR1085933
     C                   ENDIF                                                             AR1085933
                                                                                           AR1085933
      **                                                                                    AR958654
     **** Check for duplicates                                                              AR958654
      **                                                                                    AR958654
                                                                                            AR958654
     C****/EXEC SQL                                                                         MD032152
     C****+ SELECT COUNT(*) INTO :Count                                                     MD032152
     C****+ FROM BFTB_USER WHERE BFNAMEPK = :UserName                                       MD032152
     C****/END-EXEC                                                                         MD032152
     C****               IF        Count = 0                                                MD032152
     C                   EXSR      WriteRec
     C****               ELSE                                                               MD032152
     C****               EXSR      LogDupl                                                  MD032152
     C****               ENDIF                                                              MD032152
      *
     C/EXEC SQL
     C+ FETCH NEXT
     C+ FROM UScursor
     C+ INTO: USER
     C/END-EXEC
     C                   EVAL      Key = Key + 1
      *
     C                   ENDDO
      *
     C/EXEC SQL
     C+ CLOSE UScursor
     C/END-EXEC
      *
     C                   EXSR      SETUSZONE                                               AR1085933
      *                                                                                    AR1085933
     C                   EVAL      *INLR = *ON
     C                   RETURN
      /EJECT
      *****************************************************************                    AR1085933
      *                                                               *                    AR1085933
      *  SetUSZONE - Populate USZONE field in all MUSERDD             *                    AR1085933
      *              records in all zones                             *                    AR1085933
      *                                                               *                    AR1085933
      *****************************************************************                    AR1085933
      *                                                                                    AR1085933
      /free
         BegSr setUSZONE;                                                                //AR1085933
                                                                                         //AR1085933
         Exec SQL
              Declare ZONES cursor for
              Select * from GPZONEPD;                                                    //AR1085933
                                                                                         //AR1085933
         Exec SQL
              Open ZONES;                                                                //AR1085933
                                                                                         //AR1085933
         Exec SQL
              Fetch next
              from ZONES into :GPZN;                                                     //AR1085933
                                                                                         //AR1085933
         DoW SQLCODE = 0;                                                                //AR1085933
                                                                                         //AR1085933
           USZONESTM = 'Update '+ ZOMSYS +'DTALIB/MUSERDD set USZONE = ''' +
                       ZOZONE + ''' where USRP in (select BFNAMEPK ' +
                       'from BFTB_USER)';                                                //AR1085933
           Exec SQL
                Prepare MUSZONE from :USZONESTM;                                         //AR1085933
                                                                                         //AR1085933
           Exec SQL
                Execute MUSZONE;                                                         //AR1085933
                                                                                         //AR1085933
           USZONESTM = 'Insert into '+ ZOMSYS +'DTALIB/MBROSDD ' +
                       '(RECI, USRP, NOBR, LCD, LCT, CHTP) ' +
                       '(select ''D'', USRP, 0, 0, 0, ''I'' from ' +
                       ZOMSYS +'DTALIB/MUSERDD where USRP not in ' +
                       '(select USRP from '+ ZOMSYS +'DTALIB/MBROSDD))';                 //AR1085933

           Exec SQL
                Prepare MUSZONE from :USZONESTM;                                         //AR1085933
                                                                                         //AR1085933
           Exec SQL
                Execute MUSZONE;                                                         //AR1085933
                                                                                         //AR1085933
           Exec SQL
                Fetch next
                from ZONES into :GPZN;                                                   //AR1085933
         EndDo;                                                                          //AR1085933
                                                                                         //AR1085933
         Exec SQL
              Close ZONES;                                                               //AR1085933
                                                                                         //AR1085933
         EndSr;                                                                          //AR1085933
      /end-free
      *****************************************************************
      *                                                               *
      *  WriteRec - Write records to BankFusion tables                *
      *                                                               *
      *****************************************************************
      *
     C     WriteRec      BEGSR
      *
     C/EXEC SQL
     C*+********SELECT*TZONE*INTO*:DefZone*from*T_USERMENU*                                 MD022609
     C+ SELECT TZONE INTO :ZoneName from T_USERMENU                                         MD022609
     C+ WHERE MUSERNAME = :UserName
     C/END-EXEC
      *
     C**********         IF        DefZone = ''                                             MD022609
     C                   IF        ZoneName = ''                                            MD022609
     C**********         EVAL      DefZone = ' '                                            AR989186
      *                                                                                     AR989186
     C/EXEC SQL                                                                             AR989186
     C*+********SELECT*ZOZONE*INTO*:DefZone*from*GPZONEPD*                         AR989186 MD022609
     C+ SELECT ZOZONE INTO :ZoneName from GPZONEPD                                          MD022609
     C+ FETCH FIRST 1 ROWS ONLY                                                             AR989186
     C/END-EXEC                                                                             AR989186
      *
     C                   ENDIF
      *                                                                                     AR958654
     C/EXEC SQL                                                                             AR958654
     C+ SELECT ZOMSYS INTO :DefZone from GPZONEPD                                           AR958654
     C*+********WHERE*ZOZONE*=*:DefZone*                                           AR958654 MD022609
     C+ WHERE ZOZONE = :ZoneName                                                            MD022609
     C/END-EXEC                                                                             AR958654
      *
     **** Check for duplicates                                                              MD032152
     C/EXEC SQL                                                                             MD032152
     C+ SELECT COUNT(*) INTO :Count                                                         MD032152
     C+ FROM BFTB_USER WHERE BFNAMEPK = :UserName                                           MD032152
     C/END-EXEC                                                                             MD032152
     C                   IF        Count = 0                                                MD032152
      *                                                                                     MD032152
      * Write record on BFTB_USER
      *
     C/EXEC SQL
     C+ INSERT INTO BFTB_USER (
     C+ BFNAMEPK, BFZONE, VERSIONNUM, BFUSERTYPE,
     C*+*BFINVALIDPASSWORDATTEMPTS,*BFLOCKEDOUT,*BFLOGINSTATUS,*****************           MD018386C
     C+ BFINVALIDPASSWORDATTEMPTS, BFLOCKEDOUT,                                            MD018386C
     C*+*BFPASSWORDEXPIRYDATE,*BFPASSWORDEXPIRYIND,*BFLOGINCOUNT,***************           AR1085933
     C+ BFPASSWORDEXPIRYDATE, BFPASSWORDEXPIRYIND,                                         AR1085933
     C+ BFREAUTHENTICATION, BFUSERID, BFBMBRANCH,                                           AR958654
     C+ BFLANGUAGELOCALE, BFCOUNTRYLOCALE )                                                 AR958654
     C*+********BFREAUTHENTICATION)                                                         AR958654
     C+ VALUES (
     C*+*:UserName,*:DefZone,***************************************************           AR1085933
     C*+*:UserName,*trim(:DefZone),********************************************* AR1085933 MD018386C
     C+ trim(:UserName), trim(:DefZone),                                                   MD018386C
     C*+*1,*:UserTyp,*:InvPass,*:LockOut,*:LogStat,*****************************           MD018386C
     C+ 1, :UserTyp, :InvPass, :LockOut,                                                   MD018386C
     C*+*:PassExp,*:PassInd,*:LogCnt,*0,****************************************  AR958654 AR1085933
     C+ :PassExp, :PassInd, 0,                                                             AR1085933
     C*+*:UserId,*:DefBranch,*:LangLocale,*:CtryLocale**************************   AR958654 MD050393
     C+ trim(:UserId), :DefBranch, :LangLocale, :CtryLocale                                 MD050393
     C+ )                                                                                   AR958654
     C*+********:PassExp, :PassInd, :LogCnt, 0)                                             AR958654
     C/END-EXEC
     C                   Endif                                                              MD032152
      *
      *
     C/EXEC SQL
     C+ SELECT ZOMSYS INTO :Zone from GPZONEPD
     C+ WHERE ZOZONE = :ZoneName
     C/END-EXEC
      *
      * Write record on BFTB_ZONEUSER
     C/EXEC SQL
     C+ INSERT INTO BFTB_ZONEUSER(
     C+ BFRECCREATEDBY, BFRECCREATEDON, BFRECSYSDATE,                                      MD018386C
     C+ BFUSERID, BFLINKIDPK, BFZONE, VERSIONNUM)
     C*+*VALUES(:UserName,*CONCAT('MIZU',:Key),*:Zone,*1)**********************            MD018386C
     C+ VALUES( 'system', Now(), Now(),                                                    MD018386C
     C*+********trim(:UserName),*CONCAT(trim(:Username),:Zone),*:Zone,*1)****      MD022372 MD022609
     C+         trim(:UserName), CONCAT(trim(:Username),:Zone),trim(:Zone), 1)              MD022609
     C*+********trim(:UserName),*CONCAT('MIZU',:Key),*:Zone,*1)****************   MD018386C MD022372
     C/END-EXEC
      *
      * Write record on BFTB_USERLOGINNODE
     C/EXEC SQL
     C+ INSERT INTO BFTB_USERLOGINNODE(
     C+ BFIDPK, BFNODEID, BFLOGINCOUNT,
     C+ BFUSERNAME, VERSIONNUM)
     C+ VALUES (
     C+ CONCAT(trim(:UserName), :Key), ' ', 0, :Username, 1)                                MD022372
     C*+*CONCAT('usrloginmod',:Key),*'*',*0,*:UserName,*1)*********************             MD022372
     C/END-EXEC
      *
     C     WriteRecE     ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  LogDupl - Log duplicates                                     *
      *                                                               *
      *****************************************************************
      *
     C**** LogDupl       BEGSR                                                              MD032152
      ****                                                                                  MD032152
     C****               DUMP                                                               AR989186
      ****                                                                                  MD032152
     C**** LogDuplE      ENDSR                                                              MD032152
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
