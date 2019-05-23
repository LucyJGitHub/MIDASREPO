     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2018')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SD Password Encryption Take-on program')         *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000405 - Midas SD Password Encryption Take-on Program      *
      *                                                               *
      *  Function:  This program will transfer all password from      *
      *             API/interface                                     *
      *                                                               *
      *  (c) Finastra International Limited 2018                      *
      *                                                               *
      *  Last Amend No. MD053450           Date 11May19               *
      *  Prev Amend No. MD053394           Date 08May19               *
      *                 MD053109           Date 03Apr19               *
      *                 MD053146           Date 02Apr19               *
      *                 MD053090           Date 26Mar19               *
      *                 CSD101 *CREATE     Date 07Dec18               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD053450 - No profile and password defined but reflected on  *
      *             take on report                                    *
      *  MD053394 - Same profile migrated during data take on         *
      *  MD053109 - Data Take-On Reconciliation Issues                *
      *  MD053146 - Incorrect account key format was migrated on      *
      *             validation list after data take on                *
      *  MD053090 - Create a back up file for REAPWDPD                *
      *  CSD101 - Password Encryption                                 *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Subroutine index                                             *
      *                                                               *
      *  SrProcess  - Process the user password                       *
      *  SrSVAL1    - Retrieve system value                           *
      *  SrOldVald  - Call old common validation list program         *
      *  SrNewVald  - Call new common validation list program         *
      *  SrInsert   - Write a record to SDFACXTD file                 *
      *  SrSetPass  - Set the password into BLANKS                    *
      *  SrRetrieve - Retrieve username and password                  *
      *  *PSSR      - Error processing                                *
      *  *INZSR     - Initialise                                      *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
                                                                                            MD053109
      ** RPT: Take On Program Report Control                                                MD053109
     FSD000405P1O    E             PRINTER INFDS(Spool1)                                    MD053109
     F                                     INFSR(*Pssr)                                     MD053109
     F                                     USROPN                                           MD053109

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
                                                                                            MD053109
      ** First DS for Access Programs, Short Data Structure                                 MD053109
     D DSFDY         E DS                  EXTNAME(DSFDY)                                   MD053109
                                                                                            MD053109
      ** Bank Details Accessed via Access Program                                           MD053109
     D SDBANK        E DS                  EXTNAME(SDBANKPD)                                MD053109
                                                                                            MD053109
      ** File Information Data Structure for printer file SD000405P1                        MD053109
     D Spool1          DS                                                                   MD053109
     D  Sfile1                83     92                                                     MD053109
     D  Sfnum1               123    124B 0                                                  MD053109
     D  Oflln1               188    189B 0                                                  MD053109
     D  Prtln1               367    368B 0                                                  MD053109

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Fields used to check that sufficient lines remain for the                          MD053109
      ** printer file record format                                                         MD053109
     D Difln1          S              2  0                                                  MD053109
     D Rqdln1          S              2  0                                                  MD053109

     D PReturnCode     S              7A
     D PAction         S              1A
     D PValidList      S             10A   INZ('SDINTFVL')
     D PLibrary        S             10A
     D PIDName         S            100A
     D PPass1          S            128A
     D PPass3          S            128A                                                    MD053394
     D PAction2        S              1A                                                    MD053394
     D Wwrite          S              1A                                                    MD053394
     D PDescr          S           1000A
     D WTimestamp      S             26A   INZ('0001-01-01-00.00.00.000000')

     D Stmt            S            500A
     D Result          S             50A
     D Result2         S             50A
     D Result3         S             50A
     D Result4         S             50A
     D Result5         S             50A
     D Result6         S             50A
     D WUser           S             50A
     D WUser2          S             50A
     D WUser3          S             50A
     D WUser4          S             50A
     D WUser5          S             50A
     D WPassword       S            128A
     D PInterface      S             20A
     D PUser           S             50A
     D PUserDesc       S             50A
     D PUniq           S             75A
     D WPrefix         S              2A
     D PUserName       S            100A
     D PPassword1      S            128A
     D PPassword2      S            600A
     D PDescrptn       S           1000A
     D PFRtnCd         S              7A
     D PFFile          S             10A
     D PFEnti          S             20A
     D PFUsr1          S             20A
     D PFUsr2          S             20A
     D PFUsr3          S             20A
     D PFUsr4          S             20A
     D PFUsr5          S             20A
     D PFPass          S            128A
     D PFSvl1          S             20A
     D PFSvl2          S             20A
     D PFKnum          S              1A
     D PDmlib          S              7A
     D PFEntd          S             50A                                                    MD053109
     D WRun            S              1A
     D WField          S             10A
     D WField2         S             10A
     D WField3         S             10A
     D WField4         S             10A
     D WField5         S             10A
     D WField6         S             10A
     D WSval           S             10A
     D CommandStr      S            200A   INZ(*BLANKS)
     D CommandLen      S             15  5
     D WFSval          S             20A
     D WWACSQ          S              2A
     D WWACOD          S             10A
     D WFFile          S             10A
     D POptn           S              7A                                                    MD053109
     D PRtcd           S              7A                                                    MD053109


      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************

     C**********         EVAL      SQLCODE = 0                                              MD053146
     C                   EVAL      SQLCODE = 1                                              MD053146

     C                   SELECT
     C                   WHEN      PFKnum = '1'
     C                   EVAL      WField = %TRIMR(PFUSR1)
     C                   EVAL      WField2 = %TRIMR(PFPASS)
     C                   EXSR      SrRetrieve1
     C                   EVAL      WUser = Result
     C                   EVAL      WPassword = Result2

     C                   WHEN      PFKnum = '2'
     C                   EVAL      WField = %TRIMR(PFUSR1)
     C                   EVAL      WField2 = %TRIMR(PFUSR2)
     C                   EVAL      WField3 = %TRIMR(PFPASS)
     C                   EXSR      SrRetrieve2
     C                   EVAL      WUser = Result
     C                   EVAL      WUser2 = Result2
     C                   EVAL      WPassword = Result3

     C                   WHEN      PFKnum = '3'
     C                   EVAL      WField = %TRIMR(PFUSR1)
     C                   EVAL      WField2 = %TRIMR(PFUSR2)
     C                   EVAL      WField3 = %TRIMR(PFUSR3)
     C                   EVAL      WField4 = %TRIMR(PFPASS)
     C                   EXSR      SrRetrieve3
     C                   EVAL      WUser = Result
     C                   EVAL      WUser2 = Result2
     C                   EVAL      WUser3 = Result3
     C                   EVAL      WPassword = Result4

     C                   WHEN      PFKnum = '4'
     C                   EVAL      WField = %TRIMR(PFUSR1)
     C                   EVAL      WField2 = %TRIMR(PFUSR2)
     C                   EVAL      WField3 = %TRIMR(PFUSR3)
     C                   EVAL      WField4 = %TRIMR(PFUSR4)
     C                   EVAL      WField5 = %TRIMR(PFPASS)
     C                   EXSR      SrRetrieve4
     C                   EVAL      WUser = Result
     C                   EVAL      WUser2 = Result2
     C                   EVAL      WUser3 = Result3
     C                   EVAL      WUser4 = Result4
     C                   EVAL      WPassword = Result5

     C                   WHEN      PFKnum = '5'
     C                   EVAL      WField = %TRIMR(PFUSR1)
     C                   EVAL      WField2 = %TRIMR(PFUSR2)
     C                   EVAL      WField3 = %TRIMR(PFUSR3)
     C                   EVAL      WField4 = %TRIMR(PFUSR4)
     C                   EVAL      WField5 = %TRIMR(PFUSR5)
     C                   EVAL      WField6 = %TRIMR(PFPASS)
     C                   EXSR      SrRetrieve5
     C                   EVAL      WUser = Result
     C                   EVAL      WUser2 = Result2
     C                   EVAL      WUser3 = Result3
     C                   EVAL      WUser4 = Result4
     C                   EVAL      WUser5 = Result5
     C                   EVAL      WPassword = Result6

     C                   WHEN      PFKnum = 'S'

     C                   EVAL      WField = %TRIMR(PFUSR1)
     C                   EVAL      WSval = %TRIMR(PFPASS)
     C                   EVAL      WFSval = PFSvl1
     C                   EVAL      WFFILE = PFFILE
     C                   EXSR      SrSVAL1
     C                   EVAL      WUser = Result

     C                   ENDSL

     C                   DOW       SQLCODE = 0

     C                   IF        WUser <> *Blanks                                         MD053450
     C                   EXSR      SrProcess
     C                   ENDIF                                                              MD053450

     C                   SELECT
     C                   WHEN      PFKnum = '1'
     C                   EVAL      WField = %TRIMR(PFUSR1)
     C                   EVAL      WField2 = %TRIMR(PFPASS)
     C                   EXSR      SrRetrieve1
     C                   EVAL      WUser = Result
     C                   EVAL      WPassword = Result2

     C                   WHEN      PFKnum = '2'
     C                   EVAL      WField = %TRIMR(PFUSR1)
     C                   EVAL      WField2 = %TRIMR(PFUSR2)
     C                   EVAL      WField3 = %TRIMR(PFPASS)
     C                   EXSR      SrRetrieve2
     C                   EVAL      WUser = Result
     C                   EVAL      WUser2 = Result2
     C                   EVAL      WPassword = Result3

     C                   WHEN      PFKnum = '3'
     C                   EVAL      WField = %TRIMR(PFUSR1)
     C                   EVAL      WField2 = %TRIMR(PFUSR2)
     C                   EVAL      WField3 = %TRIMR(PFUSR3)
     C                   EVAL      WField4 = %TRIMR(PFPASS)
     C                   EXSR      SrRetrieve3
     C                   EVAL      WUser = Result
     C                   EVAL      WUser2 = Result2
     C                   EVAL      WUser3 = Result3
     C                   EVAL      WPassword = Result4

     C                   WHEN      PFKnum = '4'
     C                   EVAL      WField = %TRIMR(PFUSR1)
     C                   EVAL      WField2 = %TRIMR(PFUSR2)
     C                   EVAL      WField3 = %TRIMR(PFUSR3)
     C                   EVAL      WField4 = %TRIMR(PFUSR4)
     C                   EVAL      WField5 = %TRIMR(PFPASS)
     C                   EXSR      SrRetrieve4
     C                   EVAL      WUser = Result
     C                   EVAL      WUser2 = Result2
     C                   EVAL      WUser3 = Result3
     C                   EVAL      WUser4 = Result4
     C                   EVAL      WPassword = Result5

     C                   WHEN      PFKnum = '5'
     C                   EVAL      WField = %TRIMR(PFUSR1)
     C                   EVAL      WField2 = %TRIMR(PFUSR2)
     C                   EVAL      WField3 = %TRIMR(PFUSR3)
     C                   EVAL      WField4 = %TRIMR(PFUSR4)
     C                   EVAL      WField5 = %TRIMR(PFUSR5)
     C                   EVAL      WField6 = %TRIMR(PFPASS)
     C                   EXSR      SrRetrieve5
     C                   EVAL      WUser = Result
     C                   EVAL      WUser2 = Result2
     C                   EVAL      WUser3 = Result3
     C                   EVAL      WUser4 = Result4
     C                   EVAL      WUser5 = Result5
     C                   EVAL      WPassword = Result6

     C                   WHEN      PFKnum = 'S'
      ** Exit do while loop
     C                   EVAL      SQLCODE = 1

     C                   ENDSL

     C                   ENDDO
                                                                                            MD053146
     C                   IF        PFFILE = 'REOSECPD'                                      MD053146
     C                   EXSR      SrClear                                                  MD053146
     C                   EXSR      SrSetFlag                                                MD053146
     C                   ENDIF                                                              MD053146

     C**********         EVAL      *INLR = *ON                                              MD053109
     C                   IF        %OPEN (SD000405P1)                                       MD053109
     C                             AND PFKnum = ' '                                         MD053109
     C                   CLOSE     SD000405P1                                               MD053109
     C                   EVAL      *INU7 = *ON                                              MD053109
     C                   EVAL      *INU8 = *ON                                              MD053109
     C                   EVAL      *INLR = *ON                                              MD053109
     C                   ENDIF                                                              MD053109
                                                                                            MD053109
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrProcess - Subroutine to process the user password           *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: SrOldVald, SrNewVald, SrInsert, SrSetPass              *
      *                                                               *
      *****************************************************************

     C     SrProcess     BEGSR

     C                   IF        PFKnum = 'S'
     C                   IF        PFSvl2 = *Blanks
     C                   EVAL      PAction = 'F'
     C                   EVAL      PValidList = 'GPLDAPVL'
     C                   EVAL      PPassword1 = *BLANKS
     C                   EXSR      SrOldVald
     C                   EVAL      WPassword = PPassword1
     C                   ELSE
     C                   EVAL      WField = %TRIMR(PFUSR1)
     C                   EVAL      WSval = %TRIMR(PFPASS)
     C                   EVAL      WFSval = PFSvl2
     C                   EVAL      WFFILE = 'ZSDSVALPD'
     C                   EVAL      Result = *Blanks
     C                   EXSR      SrSVAL1
     C                   EVAL      WPassword = Result
     C                   ENDIF
     C                   ENDIF

     C                   IF        PFFILE = 'SDMGMEPD'
     C                             AND WUser = '*blank'
     C                             AND WPassword = '*blank'
     C                   EVAL      WPassword = *Blanks
     C                   EXSR      SrSetPass
     C                   ENDIF

     C                   EVAL      RRTRFR = 'N'                                             MD053109
     C                   EVAL      RRRESN = 'Password is blanks'                            MD053109
     C                   IF        WPassword <> *BLANKS
     C                   EVAL      RRTRFR = 'Y'                                             MD053109
     C                   EVAL      RRRESN = 'Successfully transferred'                      MD053109
     C                   EVAL      PAction = 'A'
     C                   EVAL      PValidList = 'SDINTFVL'
     C                   EVAL      Wwrite = 'Y'                                             MD053394
     C                   SELECT
     C                   WHEN      PFKnum = '1'
     C                   EVAL      PIDName = %TRIM(PFENTI) + '_' + WUser
     C                   WHEN      PFKnum = '2'
     C                   EVAL      PIDName = %TRIM(PFENTI) + '_' + %TRIM(WUSER)
     C                                       + %TRIM(WUSER2)
     C                   WHEN      PFKnum = '3'
     C                   EVAL      PIDName = %TRIM(PFENTI) + '_' + %TRIM(WUSER)
     C                                       + %TRIM(WUSER2) + %TRIM(WUSER3)
     C                   WHEN      PFKnum = '4'
     C                   EVAL      PIDName = %TRIM(PFENTI) + '_' + %TRIM(WUSER)
     C                                       + %TRIM(WUSER2) + %TRIM(WUSER3) +
     C                                       %TRIM(WUSER4)
     C                   WHEN      PFKnum = '5'
     C                   IF        PFFILE = 'REAPWDPD'
     C**********         EVALR     WWACSQ = ('00' + %TRIM(WUSER3))                          MD053146
     C**********         EVALR     WWACOD = ('000000000' + %TRIM(WUSER5))                   MD053146
     C**********         EVAL      PIDName = %TRIM(PFENTI) + '_' + %TRIM(WUSER)             MD053146
     C**********                             + %TRIM(WUSER2) + %TRIM(WWACSQ) +              MD053146
     C**********                             %TRIM(WUSER4) + %TRIM(WWACOD)                  MD053146
     C                   EVALR     WWACSQ = ('00' + %TRIM(WUSER4))                          MD053146
     C                   EVALR     WWACOD = ('000000000' + %TRIM(WUSER3))                   MD053146
     C                   EVAL      PIDName = %TRIM(PFENTI) + '_' + %TRIM(WUSER)             MD053146
     C                                       + %TRIM(WUSER2) + %TRIM(WWACOD) +              MD053146
     C                                       %TRIM(WWACSQ) + %TRIM(WUSER5)                  MD053146
     C                   ELSE
     C                   EVAL      PIDName = %TRIM(PFENTI) + '_' + %TRIM(WUSER)
     C                                       + %TRIM(WUSER2) + %TRIM(WUSER3) +
     C                                       %TRIM(WUSER4) + %TRIM(WUSER5)
     C                   ENDIF
     C                   WHEN      PFKnum = 'S'
     C                   EVAL      PIDName = %TRIM(PFENTI) + '_' + WUser
     C                   ENDSL
     C                   EVAL      PPass1 = WPassword
                                                                                            MD053394
     C                   CALL      'SD000404'                                               MD053394
     C                   PARM      *BLANKS       PReturnCode                                MD053394
     C                   PARM      'F'           PAction2                                   MD053394
     C                   PARM                    PValidList                                 MD053394
     C                   PARM      PDmlib        PLibrary                                   MD053394
     C                   PARM                    PIDName                                    MD053394
     C                   PARM                    PPass3                                     MD053394
     C                   PARM      *BLANKS       PDescr                                     MD053394
                                                                                            MD053394
     C                   IF        PReturnCode = *BLANKS                                    MD053394
     C                   EVAL      Wwrite = 'N'                                             MD053394
     C                   ELSE                                                               MD053394
     C                   EXSR      SrNewVald                                                MD053394
     C                   ENDIF                                                              MD053394
      ** Do not create SDFACXTD record for REAPWDPD
     C                   IF        PFFILE <> 'REAPWDPD'
     C                             AND Wwrite = 'Y'                                         MD053394
     C                   EXSR      SrInsert
     C                   ENDIF
     C                   IF        PFFILE <> 'REAPWDPD'                                     MD053109
     C                   EXSR      SrSetPass
     C                   ENDIF                                                              MD053109
     C                   EXSR      SrSetFlag
     C                   ENDIF

     C                   EXSR      SrPrint                                                  MD053109

     C                   EVAL      Result = *Blanks
     C                   EVAL      Result2 = *Blanks
     C                   EVAL      Result3 = *Blanks
     C                   EVAL      Result4 = *Blanks
     C                   EVAL      Result5 = *Blanks
     C                   EVAL      Result6 = *Blanks

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrSVAL1 - Subroutine to retrieve system value                 *
      *                                                               *
      * Called by: SrProcess                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrSVAL1       BEGSR

     C                   EVAL      Stmt = 'SELECT ' + %TRIMR(WSval)
     C                                  + ' from ' + %TRIMR(WFFILE)
     C                                  + ' where ' + %TRIMR(WField)
     C                                  + ' = ''' + %TRIMR(WFSval)
     C                                  + ''''

     C/exec SQL
     C+                  prepare sqlstmt2 from :stmt
     C/end-exec
     C/exec SQL          declare C2 cursor for sqlstmt2
     C/end-exec
     C/exec SQL          open C2
     C/end-exec
     C/exec SQL          fetch from C2 into :Result
     C/end-exec
     C***/exec*SQL          close C2                                                        MD053090
     C***/end-exec                                                                          MD053090
     C/exec SQL          close C2                                                           MD053450
     C/end-exec                                                                             MD053450

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrOldVald - Subroutine to call old common validation          *
      *             list program                                      *
      *                                                               *
      * Called by: SrProcess                                          *
      *                                                               *
      * Calls: UT000033                                               *
      *                                                               *
      *****************************************************************

     C     SrOldVald     BEGSR

     C                   EVAL      PLibrary = WPrefix + 'GMLIB'

     C                   CALL      'UT000033'
     C                   PARM      *BLANKS       PReturnCode
     C                   PARM                    PAction
     C                   PARM                    PValidList
     C                   PARM                    PLibrary
     C                   PARM      WUser         PUserName
     C                   PARM                    PPassword1
     C                   PARM      *BLANKS       PPassword2
     C                   PARM      *BLANKS       PDescrptn

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrNewVald - Subroutine to call new common validation          *
      *             list program                                      *
      *                                                               *
      * Called by: SrProcess                                          *
      *                                                               *
      * Calls: SD000404                                               *
      *                                                               *
      *****************************************************************

     C     SrNewVald     BEGSR

     C                   EVAL      PLibrary = PDmlib

     C                   CALL      'SD000404'
     C                   PARM      *BLANKS       PReturnCode
     C                   PARM                    PAction
     C                   PARM                    PValidList
     C                   PARM                    PLibrary
     C                   PARM                    PIDName
     C                   PARM                    PPass1
     C                   PARM      *BLANKS       PDescr

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrInsert - Subroutine to write a record to SDFACXTD file      *
      *                                                               *
      * Called by: SrProcess                                          *
      *                                                               *
      * Calls: UT000033                                               *
      *                                                               *
      *****************************************************************

     C     SrInsert      BEGSR

     C                   EVAL      PInterface = PFENTI
     C                   EVAL      PUser = WUser
     C                   EVAL      PUniq = PIDName
     C                   EVAL      PUserDesc = *BLANKS

     C/exec SQL
     C+ insert into SDFACXTD
     C+ (
     C+   ININTF
     C+  ,INUSER
     C+  ,INUNIQ
     C+  ,INUSRD
     C+  ,INTMST
     C+ )
     C+ values
     C+ (
     C+   :PInterface
     C+  ,:PUser
     C+  ,:PUniq
     C+  ,:PUserDesc
     C+  ,:WTimeStamp
     C+ )
     C/end-exec

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrSetPass - Subroutine to set the password into BLANKS        *
      *                                                               *
      * Called by: SrProcess                                          *
      *                                                               *
      * Calls: SrOldVald                                              *
      *                                                               *
      *****************************************************************

     C     SrSetPass     BEGSR

     C                   IF        PFSvl1 = *Blanks

     C                   SELECT
     C                   WHEN      PFKnum = '1'
     C                   EVAL      Stmt = 'UPDATE ' + PFFILE + ' SET '
     C                                  + %TRIMR(PFPASS) + ' = '''
     C                                  + '          ' + ''''
     C                                  + ' where ' + %TRIMR(PFUSR1)
     C                                  + ' = ''' + %TRIMR(WUser) + ''''

     C                   WHEN      PFKnum = '2'
     C                   EVAL      Stmt = 'UPDATE ' + PFFILE + ' SET '
     C                                  + %TRIMR(PFPASS) + ' = '''
     C                                  + '          ' + ''''
     C                                  + ' where ' + %TRIMR(PFUSR1)
     C                                  + ' = ''' + %TRIMR(WUser) + ''''
     C                                  + ' and ' + %TRIMR(PFUSR2)
     C                                  + ' = ''' + %TRIMR(WUser2) + ''''

     C                   WHEN      PFKnum = '3'
     C                   EVAL      Stmt = 'UPDATE ' + PFFILE + ' SET '
     C                                  + %TRIMR(PFPASS) + ' = '''
     C                                  + '          ' + ''''
     C                                  + ' where ' + %TRIMR(PFUSR1)
     C                                  + ' = ''' + %TRIMR(WUser) + ''''
     C                                  + ' and ' + %TRIMR(PFUSR2)
     C                                  + ' = ''' + %TRIMR(WUser2) + ''''
     C                                  + ' and ' + %TRIMR(PFUSR3)
     C                                  + ' = ''' + %TRIMR(WUser3) + ''''

     C                   WHEN      PFKnum = '4'
     C                   EVAL      Stmt = 'UPDATE ' + PFFILE + ' SET '
     C                                  + %TRIMR(PFPASS) + ' = '''
     C                                  + '          ' + ''''
     C                                  + ' where ' + %TRIMR(PFUSR1)
     C                                  + ' = ''' + %TRIMR(WUser) + ''''
     C                                  + ' and ' + %TRIMR(PFUSR2)
     C                                  + ' = ''' + %TRIMR(WUser2) + ''''
     C                                  + ' and ' + %TRIMR(PFUSR3)
     C                                  + ' = ''' + %TRIMR(WUser3) + ''''
     C                                  + ' and ' + %TRIMR(PFUSR4)
     C                                  + ' = ''' + %TRIMR(WUser4) + ''''

     C                   WHEN      PFKnum = '5'
     C                   EVAL      Stmt = 'UPDATE ' + PFFILE + ' SET '
     C                                  + %TRIMR(PFPASS) + ' = '''
     C                                  + '          ' + ''''
     C                                  + ' where ' + %TRIMR(PFUSR1)
     C                                  + ' = ''' + %TRIMR(WUser) + ''''
     C                                  + ' and ' + %TRIMR(PFUSR2)
     C                                  + ' = ''' + %TRIMR(WUser2) + ''''
     C                                  + ' and ' + %TRIMR(PFUSR3)
     C                                  + ' = ''' + %TRIMR(WUser3) + ''''
     C                                  + ' and ' + %TRIMR(PFUSR4)
     C                                  + ' = ''' + %TRIMR(WUser4) + ''''
     C                                  + ' and ' + %TRIMR(PFUSR5)
     C                                  + ' = ''' + %TRIMR(WUser5) + ''''
     C                   ENDSL

     C                   EVAL      CommandStr = Stmt
     C                   EVAL      CommandLen = 100
     C                   EXSR      SrCommand

     C                   ENDIF

     C                   ENDSR


      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrSetFlag - Subroutine to set process flag to 'Y'             *
      *                                                               *
      * Called by: SrProcess                                          *
      *                                                               *
      * Calls: SrOldVald                                              *
      *                                                               *
      *****************************************************************

     C     SrSetFlag     BEGSR

     C                   EVAL      Stmt = 'UPDATE SDINTFTD '
     C                                    + 'SET IFPRCF = ''Y'' where '
     C                                    + 'IFFILE = '''
     C                                    + %TRIMR(PFFile) + ''''
     C                                    + ' and IFSVL1 = '''
     C                                    + %TRIMR(PFSvl1) + ''''
     C                   EVAL      CommandStr = Stmt
     C                   EVAL      CommandLen = 100
     C                   EXSR      SrCommand

     C                   ENDSR
                                                                                            MD053146
      *****************************************************************                     MD053146
      /EJECT                                                                                MD053146
      *****************************************************************                     MD053146
      *                                                               *                     MD053146
      * SrClear - Subroutine to clear retail password files           *                     MD053146
      *                                                               *                     MD053146
      * Called by: Main Processing                                    *                     MD053146
      *                                                               *                     MD053146
      * Calls: SrCommand                                              *                     MD053146
      *                                                               *                     MD053146
      *****************************************************************                     MD053146
                                                                                            MD053146
     C     SrClear       BEGSR                                                              MD053146
                                                                                            MD053146
     C                   EVAL      Stmt = 'DELETE FROM REOSECPA'                            MD053146
     C                   EVAL      CommandStr = Stmt                                        MD053146
     C                   EVAL      CommandLen = 100                                         MD053146
     C                   EXSR      SrCommand                                                MD053146
                                                                                            MD053146
     C                   EVAL      Stmt = 'DELETE FROM REOSECPD'                            MD053146
     C                   EVAL      CommandStr = Stmt                                        MD053146
     C                   EVAL      CommandLen = 100                                         MD053146
     C                   EXSR      SrCommand                                                MD053146
                                                                                            MD053146
     C                   EVAL      Stmt = 'DELETE FROM REOSECPT'                            MD053146
     C                   EVAL      CommandStr = Stmt                                        MD053146
     C                   EVAL      CommandLen = 100                                         MD053146
     C                   EXSR      SrCommand                                                MD053146
                                                                                            MD053146
     C                   ENDSR                                                              MD053146
                                                                                            MD053109
      *****************************************************************                     MD053109
      /EJECT                                                                                MD053109
      *****************************************************************                     MD053109
      *                                                               *                     MD053109
      * SrPrint  - Prints header and details of report                *                     MD053109
      *                                                               *                     MD053109
      * Called by: SrMain                                             *                     MD053109
      *                                                               *                     MD053109
      * Calls    : None                                               *                     MD053109
      *                                                               *                     MD053109
      *****************************************************************                     MD053109
     C     SrPrint       BEGSR                                                              MD053109
                                                                                            MD053109
      ** Prepare detail data for printing                                                   MD053109
     C                   EVAL      RRDESC = PFEntd                                          MD053109
     C                   EVAL      RRUSER = WUSER                                           MD053109
                                                                                            MD053109
      **  Check that sufficient lines remain for the Format. If not,                        MD053109
      **  write out the Main Headings on a new page.                                        MD053109
     C                   Eval      Rqdln1 = 4                                               MD053109
     C                   Eval      Difln1 = Oflln1 - Prtln1                                 MD053109
                                                                                            MD053109
     C                   IF        DifLn1 <= Rqdln1                                         MD053109
     C                   WRITE     SD000405R0                                               MD053109
     C                   ENDIF                                                              MD053109
                                                                                            MD053109
      ** Write detail record to SD000405P1                                                  MD053109
     C                   WRITE     SD000405R1                                               MD053109
                                                                                            MD053109
     C                   ENDSR                                                              MD053109

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrRetrieve1 - Subroutine to retrieve username and password    *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrRetrieve1   BEGSR

     C                   EVAL      Stmt = 'SELECT ' + WField
     C                                  + ', ' + WField2
     C                                  + ' from ' + PFFILE

     C/exec SQL
     C+                  prepare sqlstmt1 from :stmt
     C/end-exec
     C/exec SQL          declare C1 cursor for sqlstmt1
     C/end-exec
     C/exec SQL          open C1
     C/end-exec
     C/exec SQL          fetch from C1 into :Result, :Result2
     C/end-exec

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrRetrieve2 - Subroutine to retrieve username and password    *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrRetrieve2   BEGSR

     C                   EVAL      Stmt = 'SELECT ' + WField
     C                                  + ', ' + WField2
     C                                  + ', ' + WField3
     C                                  + ' from ' + PFFILE

     C/exec SQL
     C+                  prepare sqlstmt3 from :stmt
     C/end-exec
     C/exec SQL          declare C3 cursor for sqlstmt3
     C/end-exec
     C/exec SQL          open C3
     C/end-exec
     C/exec SQL          fetch from C3 into :Result, :Result2,
     C+                       :Result3
     C/end-exec

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrRetrieve3 - Subroutine to retrieve username and password    *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrRetrieve3   BEGSR

     C                   EVAL      Stmt = 'SELECT ' + WField
     C                                  + ', ' + WField2
     C                                  + ', ' + WField3
     C                                  + ', ' + WField4
     C                                  + ' from ' + PFFILE

     C/exec SQL
     C+                  prepare sqlstmt4 from :stmt
     C/end-exec
     C/exec SQL          declare C4 cursor for sqlstmt4
     C/end-exec
     C/exec SQL          open C4
     C/end-exec
     C/exec SQL          fetch from C4 into :Result, :Result2,
     C+                       :Result3, :Result4
     C/end-exec

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrRetrieve4 - Subroutine to retrieve username and password    *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrRetrieve4   BEGSR

     C                   EVAL      Stmt = 'SELECT ' + WField
     C                                  + ', ' + WField2
     C                                  + ', ' + WField3
     C                                  + ', ' + WField4
     C                                  + ', ' + WField5
     C                                  + ' from ' + PFFILE

     C/exec SQL
     C+                  prepare sqlstmt5 from :stmt
     C/end-exec
     C/exec SQL          declare C5 cursor for sqlstmt5
     C/end-exec
     C/exec SQL          open C5
     C/end-exec
     C/exec SQL          fetch from C5 into :Result, :Result2,
     C+                       :Result3, :Result4, :Result5
     C/end-exec

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrRetrieve5 - Subroutine to retrieve username and password    *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrRetrieve5   BEGSR

     C                   IF        PFFILE = 'REAPWDPD'                                      MD053450
     C                   EVAL      PFFILE = 'ZREAPWDPD'                                     MD053450
     C                   ENDIF                                                              MD053450

     C                   EVAL      Stmt = 'SELECT ' + WField
     C                                  + ', ' + WField2
     C                                  + ', ' + WField3
     C                                  + ', ' + WField4
     C                                  + ', ' + WField5
     C                                  + ', ' + WField6
     C                                  + ' from ' + PFFILE

     C/exec SQL
     C+                  prepare sqlstmt6 from :stmt
     C/end-exec
     C/exec SQL          declare C6 cursor for sqlstmt6
     C/end-exec
     C/exec SQL          open C6
     C/end-exec
     C/exec SQL          fetch from C6 into :Result, :Result2,
     C+                       :Result3, :Result4, :Result5, :Result6
     C/end-exec

     C                   IF        PFFILE = 'ZREAPWDPD'                                     MD053450
     C                   EVAL      PFFILE = 'REAPWDPD'                                      MD053450
     C                   ENDIF                                                              MD053450
                                                                                            MD053450
     C                   ENDSR

      *****************************************************************
      *                                                               *
      *  SrCommand - Execute CL Command                               *
      *                                                               *
      *****************************************************************

     C     SrCommand     BEGSR

     C/exec SQL
     C+ execute immediate :Stmt
     C/end-exec

     C                   ENDSR

      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Routine                      *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    PFRtnCd
     C                   PARM                    PFFile
     C                   PARM                    PFEnti
     C                   PARM                    PFUsr1
     C                   PARM                    PFUsr2
     C                   PARM                    PFUsr3
     C                   PARM                    PFUsr4
     C                   PARM                    PFUsr5
     C                   PARM                    PFPass
     C                   PARM                    PFSvl1
     C                   PARM                    PFSvl2
     C                   PARM                    PFKnum
     C                   PARM                    PDmlib
     C                   PARM                    PFEntd                                     MD053109
                                                                                            MD053109
      ** Access bank details                                                                MD053109
                                                                                            MD053109
     C                   CALL      'AOBANKR0'                                               MD053109
     C                   PARM      '*MSG   '     PRtcd                                      MD053109
     C                   PARM      '*FIRST '     POptn                                      MD053109
     C     SDBANK        PARM      SDBANK        DSFDY                                      MD053109
                                                                                            MD053109
     C                   EVAL      RRTITL = BJURPT                                          MD053109
     C                   EVAL      RRRUNA = BJMRDT                                          MD053109
     C                   EVAL      WField = 'GISVAL'
     C                   EVAL      WSval = 'GIVAL'
     C                   EVAL      WFSval = 'GlobalSystemPrefix'
     C                   EVAL      WFFILE = 'SDSVALPD'
     C                   EXSR      SrSVAL1
     C                   EVAL      WPrefix = Result
                                                                                            MD053109
     C                   IF        %OPEN (SD000405P1)                                       MD053109
     C                   CLOSE     SD000405P1                                               MD053109
     C                   ENDIF                                                              MD053109
                                                                                            MD053109
     C                   IF        NOT %OPEN (SD000405P1)                                   MD053109
     C                   OPEN      SD000405P1                                               MD053109
     C                   ENDIF                                                              MD053109
                                                                                            MD053109
     C                   Eval      Prtln1 =  Oflln1                                         MD053109
                                                                                            MD053109
      ** Write header                                                                       MD053109
     C                   WRITE     SD000405R0                                               MD053109

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

     C                   CALL      'DBERRCTL'

     C                   ENDIF

     C                   IF        %OPEN (SD000405P1)                                       MD053450
     C                   CLOSE     SD000405P1                                               MD053450
     C                   ENDIF                                                              MD053450

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON

     C                   RETURN

     C                   ENDSR

      *****************************************************************
