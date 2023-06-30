     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2022')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP OTU main screen display')                     *
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP6000 - Midas UP OTU main screen display                    *
      *                                                               *
      *  Function: This program displays several screens with         *
      *            informations needed to perform the upgrade:        *
      *            package name, layer(s), ...                        *
      *                                                               *
      *  (c) Finastra International Limited 2022                      *
      *                                                               *
      *  Last Amend No. MD061533           Date 27Jun23               *
      *  Prev Amend No. MD061361           Date 04May23               *
      *                 MD060396           Date 20Sep22               *
      *                 CUP044 *CREATE     Date 22May22               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD061533 - Amendments to INSP screen and process             *
      *  MD061361 - Correct package name when calling PGM             *
      *             Applied for MD-61366                              *
      *  MD060396 - Only X should be used to select layers            *
      *  CUP044 - One Touch Bridge Automation Changes - Release/      *
      *           Patch Upgrade                                       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of Indicators                                            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Subroutine index.                                            *
      *                                                               *
      *  *INZSR - Initial processing                                  *
      *  NonDisplay - Set on indicators to not display fields         *
      *  Exit - Exit program                                          *
      *  *PSSR  - Program exception error routine                     *
      *                                                               *
      *****************************************************************
      /EJECT
      *
      ** Display File
     FUP6000GF  CF   E             WORKSTN


      ** Declared Variables
     D ErrInd          S             10A
     D LibName         S             10A
     D LibNameQ        S             10A
     D SAVF            S             10A
     D ValLib          S             10A
     D RstLib          S             10A
     D GPFX            S              2A
     D vPRFX           S              2A
     D vPFX1           S              2A
     D vPFX2           S              2A
     D vPFX3           S              2A
     D vPFX4           S              2A
     D vPFX5           S              2A
     D vPFX6           S              2A
     D vPFX7           S              2A
     D vPFX8           S              2A
     D vPFX9           S              2A
     D vPFX0           S              2A
     D sprf            S              2A
     D DBASE           S              3A
     D SQLDynStmt      S            500A
     D SysVal          S             20A
     D Idx             S              5  0
     D pos             S              5  0
     D Library         S             10A
     D RefLib          S             10A
     D ObjectType      S              7A
     D Member          S             10A
     D sqlStat         S           5000A
     D ZoneArr         S              2    DIM(10)
     D ZoneDsc         S             50    DIM(10)
     D RcdCount        S              5  0
     D Cmd_String      S            200
     D Cmd_Len         S             15  5 INZ(200)
     D X_CHK           S              2
      ** ZASNMS Variables
     D ZAPGMQ          S             10
     D ZAPGRL          S              5
     D ZAMSID          S              7
     D ZAMSGF          S             10
     D ZAMSDA          S            132
     D ZAMSTP          S              7
      ** CBTIME Parameters
     D DayNoa          S              5
     D STime           S              6
     D DFmt            S              1
      ** ZDATE2 Parameters
     D CurrDt          S              5  0
     D WQ0003          S              6  0
     D ZDate           S              7
     D etc             S              3
     D LIBP            S             10                                                     MD061533
     D RTN             S             10                                                     MD061533

     D ZONE          E DS                  EXTNAME(GPZONEPD)

      ** Program data structure
     D MyPSDS         SDS
     D DFPGMQ                  1     10
     D DFJOBN                244    253
     D DFDUSR                254    263
     D DFJBNO                264    269S 0
     D DFJBNC                264    269
      **  Exception type
     D PSExcpType             40     42
      **  Exception number
     D PSExcpNo               43     46
     **  Exception data
     D PSExcpData             91    170

      **  Exception Id
     D PSExcpID              171    174
       /EJECT
      *****************************************************************

      ** Handle package name
     C                   exsr      Sr_Package

      ** End program if F3 is pressed.
     C                   IF        *INKC = *ON
     C                   EXSR      Exit
     C                   ENDIF

     C                   eval      X_PACK = XPACK
     C*                  eval      X_PACK2 = XPACK2
      ** Load all existing prefixes
     C/EXEC SQL
     C+ DECLARE ZNcursor CURSOR FOR
     C+ select * from GPZONEPD
     C/END-EXEC

     C/EXEC SQL
     C+ OPEN ZNcursor
     C/END-EXEC

     C/EXEC SQL
     C+ FETCH NEXT
     C+ FROM ZNcursor
     C+ INTO: ZONE
     C/END-EXEC

     C                   eval      Idx = 0
     C                   DOW       SQLCODE = 0
     C                             and Idx < 10
     C                   eval      Idx = Idx + 1
     C                   eval      ZoneArr(Idx) = ZOMSYS
     C                   eval      ZoneDsc(Idx) = ZODESC
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

     C                   eval      SysVal = 'BrgMidasGlobalPrefix'
      ** Load global prefix too
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRetCode          7
     C                   PARM      SysVal        P@OP01           20
     C                   PARM      *BLANKS       P@VL01          200
     C                   PARM      *BLANKS       P@OP02           20
     C                   PARM      *BLANKS       P@VL02          200
     C                   PARM      *BLANKS       P@OP03           20
     C                   PARM      *BLANKS       P@VL03          200
     C                   PARM      *BLANKS       P@OP04           20
     C                   PARM      *BLANKS       P@VL04          200
     C                   PARM      *BLANKS       P@OP05           20
     C                   PARM      *BLANKS       P@VL05          200
     C                   PARM      *BLANKS       P@OP06           20
     C                   PARM      *BLANKS       P@VL06          200
     C                   PARM      *BLANKS       P@OP07           20
     C                   PARM      *BLANKS       P@VL07          200
     C                   PARM      *BLANKS       P@OP08           20
     C                   PARM      *BLANKS       P@VL08          200
     C                   PARM      *BLANKS       P@OP09           20
     C                   PARM      *BLANKS       P@VL09          200
     C                   PARM      *BLANKS       P@OP10           20
     C                   PARM      *BLANKS       P@VL10          200

     C                   eval      GPFX = %subst(P@VL01:1:2)


      ** Process first screen.
     C                   EXSR      LoadScreen

      ** End program if F3 is pressed.
     C                   IF        *INKC = *ON
     C                   EXSR      Exit
     C                   ENDIF

      ** Redisplay screen for confirmation
     C                   seton                                        20
     C                   if        XSELG = *blanks
     C                   setoff                                       40
     C                   eval      vPRFX = *blank
     C                   else
     C                   eval      vPRFX = GPFX
     C                   ENDIF
     C                   if        XSELZ1 = *blanks
     C                   setoff                                       41
     C                   eval      vPFX1 = *blank
     C                   else
     C                   eval      vPFX1 = ZoneArr(1)
     C                   ENDIF
     C                   if        XSELZ2 = *blanks
     C                   setoff                                       42
     C                   eval      vPFX2 = *blank
     C                   else
     C                   eval      vPFX2 = ZoneArr(2)
     C                   ENDIF
     C                   if        XSELZ3 = *blanks
     C                   setoff                                       43
     C                   eval      vPFX3 = *blank
     C                   else
     C                   eval      vPFX3 = ZoneArr(3)
     C                   ENDIF
     C                   if        XSELZ4 = *blanks
     C                   setoff                                       44
     C                   eval      vPFX4 = *blank
     C                   else
     C                   eval      vPFX4 = ZoneArr(4)
     C                   ENDIF
     C                   if        XSELZ5 = *blanks
     C                   setoff                                       45
     C                   eval      vPFX5 = *blank
     C                   else
     C                   eval      vPFX5 = ZoneArr(5)
     C                   ENDIF
     C                   if        XSELZ6 = *blanks
     C                   setoff                                       46
     C                   eval      vPFX6 = *blank
     C                   else
     C                   eval      vPFX6 = ZoneArr(6)
     C                   ENDIF
     C                   if        XSELZ7 = *blanks
     C                   setoff                                       47
     C                   eval      vPFX7 = *blank
     C                   else
     C                   eval      vPFX7 = ZoneArr(7)
     C                   ENDIF
     C                   if        XSELZ8 = *blanks
     C                   setoff                                       48
     C                   eval      vPFX8 = *blank
     C                   else
     C                   eval      vPFX8 = ZoneArr(8)
     C                   ENDIF
     C                   if        XSELZ9 = *blanks
     C                   setoff                                       49
     C                   eval      vPFX9 = *blank
     C                   else
     C                   eval      vPFX9 = ZoneArr(9)
     C                   ENDIF
     C                   if        XSELZ0 = *blanks
     C                   setoff                                       50
     C                   eval      vPFX0 = *blank
     C                   else
     C                   eval      vPFX0 = ZoneArr(10)
     C                   ENDIF

     C                   WRITE     UP6000F0
     C                   EXFMT     UP6000F1

      ** End program if F3 is pressed.
     C                   IF        *INKC = *ON
     C                   EXSR      Exit
     C                   ENDIF

     C                   IF        *INKC = *OFF
      ** Update the prefixes table
     C/EXEC SQL
     C+ insert into UPOPFXTD
     C+ (
     C+   GPRFX
     C+  ,ZPFX1
     C+  ,ZPFX2
     C+  ,ZPFX3
     C+  ,ZPFX4
     C+  ,ZPFX5
     C+  ,ZPFX6
     C+  ,ZPFX7
     C+  ,ZPFX8
     C+  ,ZPFX9
     C+  ,ZPFX0
     C+ )
     C+ Values
     C+ (
     C+   :vPRFX
     C+  ,:vPFX1
     C+  ,:vPFX2
     C+  ,:vPFX3
     C+  ,:vPFX4
     C+  ,:vPFX5
     C+  ,:vPFX6
     C+  ,:vPFX7
     C+  ,:vPFX8
     C+  ,:vPFX9
     C+  ,:vPFX0
     C+ )
     C/END-EXEC
     C                   If        SQLCode <> 0
     C                   exsr      *pssr
     C                   Endif

      * Set the system values, always for the global then only for the selected zone(s)
     C                   eval      sprf = GPFX
     C                   exsr      SrSysValg
     C                   if        XSELG <> *blanks
     C                   eval      XNAXG  = '/' + XPACK + 'G' + ' objects ' +
     C                             'will be restored to'
     C**********         eval      XNAYG  = 'Programs PGMAG, PGMB1 and PGMC1' +             MD061533
     C                   eval      XNAYG  = 'Programs PGMB1 and PGMC1' +                    MD061533
     C                             ' will be called for global'
     C                   eval      XLIRG = GPFX + 'GIRLIB'
     C                   ENDIF

     C                   if        vPFX1 <> *blanks
     C                   eval      sprf = vPFX1
     C                   exsr      SrSysVal
     C                   eval      XNAXZ1 = '/' + XPACK + 'Z' + ' objects ' +
     C                             'will be restored to'
     C**********         eval      XNAYZ1 = 'Programs PGMAZ, PGMB2 and PGMC2' +             MD061533
     C                   eval      XNAYZ1 = 'Programs PGMB2 and PGMC2' +                    MD061533
     C                             ' will be called for layer ' + sprf
     C                   eval      XLIRZ1 = sprf + 'IRLIB'
     C                   ENDIF

     C                   if        vPFX2 <> *blanks
     C                   eval      sprf = vPFX2
     C                   exsr      SrSysVal
     C                   eval      XNAXZ2 = '/' + XPACK + 'Z' + ' objects ' +
     C                             'will be restored to'
     C                   eval      XNAYZ2 = 'Programs PGMB2 and PGMC2' +                    MD061533
     C                             ' will be called for layer ' + sprf                      MD061533
     C                   eval      XLIRZ2 = sprf + 'IRLIB'
     C                   ENDIF

     C                   if        vPFX3 <> *blanks
     C                   eval      sprf = vPFX3
     C                   exsr      SrSysVal
     C                   eval      XNAXZ3 = '/' + XPACK + 'Z' + ' objects ' +
     C                             'will be restored to'
     C                   eval      XNAYZ3 = 'Programs PGMB2 and PGMC2' +                    MD061533
     C                             ' will be called for layer ' + sprf                      MD061533
     C                   eval      XLIRZ3 = sprf + 'IRLIB'
     C                   ENDIF

     C                   if        vPFX4 <> *blanks
     C                   eval      sprf = vPFX4
     C                   exsr      SrSysVal
     C                   eval      XNAXZ4 = '/' + XPACK + 'Z' + ' objects ' +
     C                             'will be restored to'
     C                   eval      XNAYZ4 = 'Programs PGMB2 and PGMC2' +                    MD061533
     C                             ' will be called for layer ' + sprf                      MD061533
     C                   eval      XLIRZ4 = sprf + 'IRLIB'
     C                   ENDIF

     C                   if        vPFX5 <> *blanks
     C                   eval      sprf = vPFX5
     C                   exsr      SrSysVal
     C                   eval      XNAXZ5 = '/' + XPACK + 'Z' + ' objects ' +
     C                             'will be restored to'
     C                   eval      XNAYZ5 = 'Programs PGMB2 and PGMC2' +                    MD061533
     C                             ' will be called for layer ' + sprf                      MD061533
     C                   eval      XLIRZ5 = sprf + 'IRLIB'
     C                   ENDIF

     C                   if        vPFX6 <> *blanks
     C                   eval      sprf = vPFX6
     C                   exsr      SrSysVal
     C                   eval      XNAXZ6 = '/' + XPACK + 'Z' + ' objects ' +
     C**********                   'will be restored to ' + sprf + 'IRLIB'                  MD061533
     C                             'will be restored to'                                    MD061533
     C                   eval      XNAYZ6 = 'Programs PGMB2 and PGMC2' +                    MD061533
     C                             ' will be called for layer ' + sprf                      MD061533
     C                   eval      XLIRZ6 = sprf + 'IRLIB'
     C                   ENDIF

     C                   if        vPFX7 <> *blanks
     C                   eval      sprf = vPFX7
     C                   exsr      SrSysVal
     C                   eval      XNAXZ7 = '/' + XPACK + 'Z' + ' objects ' +
     C                             'will be restored to'
     C                   eval      XNAYZ7 = 'Programs PGMB2 and PGMC2' +                    MD061533
     C                             ' will be called for layer ' + sprf                      MD061533
     C                   eval      XLIRZ7 = sprf + 'IRLIB'
     C                   ENDIF

     C                   if        vPFX8 <> *blanks
     C                   eval      sprf = vPFX8
     C                   exsr      SrSysVal
     C                   eval      XNAXZ8 = '/' + XPACK + 'Z' + ' objects ' +
     C                             'will be restored to'
     C                   eval      XNAYZ8 = 'Programs PGMB2 and PGMC2' +                    MD061533
     C                             ' will be called for layer ' + sprf                      MD061533
     C                   eval      XLIRZ8 = sprf + 'IRLIB'
     C                   ENDIF

     C                   if        vPFX9 <> *blanks
     C                   eval      sprf = vPFX9
     C                   exsr      SrSysVal
     C                   eval      XNAXZ9 = '/' + XPACK + 'Z' + ' objects ' +
     C                             'will be restored to'
     C                   eval      XNAYZ9 = 'Programs PGMB2 and PGMC2' +                    MD061533
     C                             ' will be called for layer ' + sprf                      MD061533
     C                   eval      XLIRZ9 = sprf + 'IRLIB'
     C                   ENDIF

     C                   if        vPFX0 <> *blanks
     C                   eval      sprf = vPFX0
     C                   exsr      SrSysVal
     C                   eval      XNAXZ0 = '/' + XPACK + 'Z' + ' objects ' +
     C                             'will be restored to'
     C                   eval      XNAYZ0 = 'Programs PGMB2 and PGMC2' +                    MD061533
     C                             ' will be called for layer ' + sprf                      MD061533
     C                   eval      XLIRZ0 = sprf + 'IRLIB'
     C                   ENDIF

     C                   ENDIF

      ** Validate Restore libraries and IRLIB
     C                   EXSR      Sr_RestLib

      ** Proceed with restore
     C                   EXSR      Sr_RestObj

      ** End of program.
     C                   EVAL      *INLR = *ON
     C                   RETURN

      /EJECT
      *****************************************************************
      *                                                               *
      *  LoadScreen -                                                 *
      *                                                               *
      *****************************************************************
     C     LoadScreen    BEGSR

     C                   eval      X_PACKK = XPACK + ' and ' + XPACK2

     C                   eval      XNARG = GPFX + ' - *GLOBAL layer'
     C                   seton                                        40

     C                   eval      XNARZ1 = ZoneArr(1) + ' - ' + ZoneDsc(1)
     C                   seton                                        41

     C                   eval      XNARZ2 = ZoneArr(2) + ' - ' + ZoneDsc(2)
     C                   seton                                        42
     C                   if        ZoneArr(2) = *BLANKS
     C                   setoff                                       42
     C                   endif

     C                   eval      XNARZ3 = ZoneArr(3) + ' - ' + ZoneDsc(3)
     C                   seton                                        43
     C                   if        ZoneArr(3) = *BLANKS
     C                   setoff                                       43
     C                   endif

     C                   eval      XNARZ4 = ZoneArr(4) + ' - ' + ZoneDsc(4)
     C                   seton                                        44
     C                   if        ZoneArr(4) = *BLANKS
     C                   setoff                                       44
     C                   endif

     C                   eval      XNARZ5 = ZoneArr(5) + ' - ' + ZoneDsc(5)
     C                   seton                                        45
     C                   if        ZoneArr(5) = *BLANKS
     C                   setoff                                       45
     C                   endif

     C                   eval      XNARZ6 = ZoneArr(6) + ' - ' + ZoneDsc(6)
     C                   seton                                        46
     C                   if        ZoneArr(6) = *BLANKS
     C                   setoff                                       46
     C                   endif

     C                   eval      XNARZ7 = ZoneArr(7) + ' - ' + ZoneDsc(7)
     C                   seton                                        47
     C                   if        ZoneArr(7) = *BLANKS
     C                   setoff                                       47
     C                   endif

     C                   eval      XNARZ8 = ZoneArr(8) + ' - ' + ZoneDsc(8)
     C                   seton                                        48
     C                   if        ZoneArr(8) = *BLANKS
     C                   setoff                                       48
     C                   endif

     C                   eval      XNARZ9 = ZoneArr(9) + ' - ' + ZoneDsc(9)
     C                   seton                                        49
     C                   if        ZoneArr(9) = *BLANKS
     C                   setoff                                       49
     C                   endif

     C                   eval      XNARZ0 = ZoneArr(10) + ' - ' + ZoneDsc(10)
     C                   seton                                        50
     C                   if        ZoneArr(10) = *BLANKS
     C                   setoff                                       50
     C                   endif

     C                   WRITE     UP6000F0

     C                   EXFMT     UP6000F1

      ** Validation For Core records.
     C                   IF        *INKC = *OFF
     C                   EXSR      ValidateFlds
     C                   EXSR      CLEAR
     C                   ENDIF

     C     LoadSubfileE  ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidateFlds -                                               *
      *                                                               *
      *                                                               *
      *****************************************************************
     C     ValidateFlds  BEGSR

     C                   EVAL      ErrInd = 'N'
      * At least on layer has to be selected
     C                   If        XSELG = *blanks and XSELZ1 = *blanks
     C                             and XSELZ2 = *blanks and XSELZ3 = *blanks
     C                             and XSELZ4 = *blanks and XSELZ5 = *blanks
     C                             and XSELZ6 = *blanks and XSELZ7 = *blanks
     C                             and XSELZ8 = *blanks and XSELZ9 = *blanks
     C                             and XSELZ0 = *blanks
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6000'
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   Else                                                               MD060396
      * action code must be 'X'                                                             MD060396
     C                   If        (XSELG <> *blanks and XSELG <> 'X')                      MD060396
     C                   seton                                        30                    MD060396
     C                   Endif                                                              MD060396
     C                   If        (XSELZ1 <> *blanks and XSELZ1 <> 'X')                    MD060396
     C                   seton                                        31                    MD060396
     C                   Endif                                                              MD060396
     C                   If        (XSELZ2 <> *blanks and XSELZ2 <> 'X')                    MD060396
     C                   seton                                        32                    MD060396
     C                   Endif                                                              MD060396
     C                   If        (XSELZ3 <> *blanks and XSELZ3 <> 'X')                    MD060396
     C                   seton                                        33                    MD060396
     C                   Endif                                                              MD060396
     C                   If        (XSELZ4 <> *blanks and XSELZ4 <> 'X')                    MD060396
     C                   seton                                        34                    MD060396
     C                   Endif                                                              MD060396
     C                   If        (XSELZ5 <> *blanks and XSELZ5 <> 'X')                    MD060396
     C                   seton                                        35                    MD060396
     C                   Endif                                                              MD060396
     C                   If        (XSELZ6 <> *blanks and XSELZ6 <> 'X')                    MD060396
     C                   seton                                        36                    MD060396
     C                   Endif                                                              MD060396
     C                   If        (XSELZ7 <> *blanks and XSELZ7 <> 'X')                    MD060396
     C                   seton                                        37                    MD060396
     C                   Endif                                                              MD060396
     C                   If        (XSELZ8 <> *blanks and XSELZ8 <> 'X')                    MD060396
     C                   seton                                        38                    MD060396
     C                   Endif                                                              MD060396
     C                   If        (XSELZ9 <> *blanks and XSELZ9 <> 'X')                    MD060396
     C                   seton                                        39                    MD060396
     C                   Endif                                                              MD060396
     C                   If        (XSELZ0 <> *blanks and XSELZ0 <> 'X')                    MD060396
     C                   seton                                        40                    MD060396
     C                   Endif                                                              MD060396
     C                   If        (XSELG <> *blanks and XSELG <> 'X') or                   MD060396
     C                             (XSELZ1 <> *blanks and XSELZ1 <> 'X') or                 MD060396
     C                             (XSELZ2 <> *blanks and XSELZ2 <> 'X') or                 MD060396
     C                             (XSELZ3 <> *blanks and XSELZ3 <> 'X') or                 MD060396
     C                             (XSELZ4 <> *blanks and XSELZ4 <> 'X') or                 MD060396
     C                             (XSELZ5 <> *blanks and XSELZ5 <> 'X') or                 MD060396
     C                             (XSELZ6 <> *blanks and XSELZ6 <> 'X') or                 MD060396
     C                             (XSELZ7 <> *blanks and XSELZ7 <> 'X') or                 MD060396
     C                             (XSELZ8 <> *blanks and XSELZ8 <> 'X') or                 MD060396
     C                             (XSELZ9 <> *blanks and XSELZ9 <> 'X') or                 MD060396
     C                             (XSELZ0 <> *blanks and XSELZ0 <> 'X')                    MD060396
     C                   EVAL      ZAMSGF = 'UTMSGF'                                        MD060396
     C                   EVAL      ZAMSID = 'UPM6010'                                       MD060396
     C                   EVAL      ErrInd = 'Y'                                             MD060396
     C                   EXSR      ZASNMS                                                   MD060396
     C                   Endif                                                              MD060396
     C                   ENDIF

     C                   DOW       *INKC = *OFF
     C                             and ErrInd = 'Y'
     C                   WRITE     UP6000F0

     C                   seton                                        28
     C                   WRITE     UP6000C1

     C                   EXFMT     UP6000F1
     C                   EXSR      CLEAR
     C                   EVAL      ErrInd = 'N'
     C                   eval      %Subarr(*IN : 30 : 10) = *OFF                            MD060396
      * At least on layer has to be selected
     C                   If        XSELG = *blanks and XSELZ1 = *blanks
     C                             and XSELZ2 = *blanks and XSELZ3 = *blanks
     C                             and XSELZ4 = *blanks and XSELZ5 = *blanks
     C                             and XSELZ6 = *blanks and XSELZ7 = *blanks
     C                             and XSELZ8 = *blanks and XSELZ9 = *blanks
     C                             and XSELZ0 = *blanks
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6000'
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   Else                                                               MD060396
      * action code must be 'X'                                                             MD060396
     C                   If        (XSELG <> *blanks and XSELG <> 'X')                      MD060396
     C                   seton                                        30                    MD060396
     C                   Endif                                                              MD060396
     C                   If        (XSELZ1 <> *blanks and XSELZ1 <> 'X')                    MD060396
     C                   seton                                        31                    MD060396
     C                   Endif                                                              MD060396
     C                   If        (XSELZ2 <> *blanks and XSELZ2 <> 'X')                    MD060396
     C                   seton                                        32                    MD060396
     C                   Endif                                                              MD060396
     C                   If        (XSELZ3 <> *blanks and XSELZ3 <> 'X')                    MD060396
     C                   seton                                        33                    MD060396
     C                   Endif                                                              MD060396
     C                   If        (XSELZ4 <> *blanks and XSELZ4 <> 'X')                    MD060396
     C                   seton                                        34                    MD060396
     C                   Endif                                                              MD060396
     C                   If        (XSELZ5 <> *blanks and XSELZ5 <> 'X')                    MD060396
     C                   seton                                        35                    MD060396
     C                   Endif                                                              MD060396
     C                   If        (XSELZ6 <> *blanks and XSELZ6 <> 'X')                    MD060396
     C                   seton                                        36                    MD060396
     C                   Endif                                                              MD060396
     C                   If        (XSELZ7 <> *blanks and XSELZ7 <> 'X')                    MD060396
     C                   seton                                        37                    MD060396
     C                   Endif                                                              MD060396
     C                   If        (XSELZ8 <> *blanks and XSELZ8 <> 'X')                    MD060396
     C                   seton                                        38                    MD060396
     C                   Endif                                                              MD060396
     C                   If        (XSELZ9 <> *blanks and XSELZ9 <> 'X')                    MD060396
     C                   seton                                        39                    MD060396
     C                   Endif                                                              MD060396
     C                   If        (XSELZ0 <> *blanks and XSELZ0 <> 'X')                    MD060396
     C                   seton                                        40                    MD060396
     C                   Endif                                                              MD060396
     C                   If        (XSELG <> *blanks and XSELG <> 'X') or                   MD060396
     C                             (XSELZ1 <> *blanks and XSELZ1 <> 'X') or                 MD060396
     C                             (XSELZ2 <> *blanks and XSELZ2 <> 'X') or                 MD060396
     C                             (XSELZ3 <> *blanks and XSELZ3 <> 'X') or                 MD060396
     C                             (XSELZ4 <> *blanks and XSELZ4 <> 'X') or                 MD060396
     C                             (XSELZ5 <> *blanks and XSELZ5 <> 'X') or                 MD060396
     C                             (XSELZ6 <> *blanks and XSELZ6 <> 'X') or                 MD060396
     C                             (XSELZ7 <> *blanks and XSELZ7 <> 'X') or                 MD060396
     C                             (XSELZ8 <> *blanks and XSELZ8 <> 'X') or                 MD060396
     C                             (XSELZ9 <> *blanks and XSELZ9 <> 'X') or                 MD060396
     C                             (XSELZ0 <> *blanks and XSELZ0 <> 'X')                    MD060396
     C                   EVAL      ZAMSGF = 'UTMSGF'                                        MD060396
     C                   EVAL      ZAMSID = 'UPM6010'                                       MD060396
     C                   EVAL      ErrInd = 'Y'                                             MD060396
     C                   EXSR      ZASNMS                                                   MD060396
     C                   Endif                                                              MD060396
     C                   ENDIF

     C                   ENDDO
     C     EndVal        ENDSR
      *
      *****************************************************************
      *                                                               *
      *  *INZSR - Initial processing                                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    Error            10

      ** Get the current time.
     C                   CALL      'CBTIME'
     C                   PARM                    DayNoa
     C                   PARM                    STime
     C                   PARM                    DFmt
     C                   MOVE      DayNoa        CurrDt
      *
      ** Convert date to DDMMYY format.
     C                   CALL      'ZDATE2'
     C                   PARM                    CurrDt
     C                   PARM                    DFmt
     C                   PARM                    WQ0003
     C                   PARM      *blanks       ZDate

     C                   EVAL      DFDATE = ZDate

     C/exec SQL
      + delete from UPOPFXTD
     C/end-exec
     C                   If        SQLCode <> 0
     C                             and SQLCode <> 100
     C                   exsr      *pssr
     C                   Endif

     C     INZSRE        ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  Exit - Exit program                                          *
      *                                                               *
      *****************************************************************
     C     Exit          BEGSR

     C                   eval      Error = '*Exit '
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C     ExitE         ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZASNMS - Send message to program's message queue             *
      *                                                               *
      *****************************************************************
      *
     C     ZASNMS        BEGSR

     C                   IF        ZAPGMQ = *BLANK
     C                   EVAL      ZAPGMQ = DFPGMQ
     C                   END

     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGMQ
     C                   PARM                    ZAPGRL
     C                   PARM                    ZAMSID
     C                   PARM                    ZAMSGF
     C                   PARM                    ZAMSDA
     C                   PARM                    ZAMSTP

     C     ZAEXIT        ENDSR

      /EJECT
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Clear - Clear the error messages on the subfile               *
      *                                                               *
      *****************************************************************
     C     Clear         BEGSR

     C                   CALL      'Y2CLMSC'
     C                   PARM      DFPGMQ        ZAPGMQ
     C                   PARM      '*SAME'       ZAPGRL

     C     ClearE        ENDSR

      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   DUMP

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   eval      Error = '*Error'
     C                   RETURN

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Sr_Package - Request package name                            *
      *                                                               *
      *****************************************************************
     C     Sr_Package    BEGSR

     C                   eval      ErrInd = 'Y'

      * display first part
     C                   setoff                                       19
     C                   DOW       *INKC = *OFF
     C                             and ErrInd = 'Y'
     C                   eval      ErrInd = 'N'

     C                   WRITE     UP6000F0

     C                   seton                                        28
     C                   WRITE     UP6000C1

     C                   EXFMT     UP6000F2

     C                   EXSR      CLEAR
     C                   setoff                                       3031

      * Validate non blank
     C                   If        XCUM  = *blanks
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6009'
     C                   EVAL      ErrInd = 'Y'
     C                   seton                                        29
     C                   EXSR      ZASNMS
     C                   ITER
     C                   ENDIF

      * Validate 'Y' or 'N'
     C                   If        XCUM <> 'Y' and XCUM <> 'N'
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6009'
     C                   EVAL      ErrInd = 'Y'
     C                   seton                                        29
     C                   EXSR      ZASNMS
     C                   ITER
     C                   ENDIF

     C                   ENDDO

      * display second part
     C                   eval      ErrInd = 'Y'
     C                   seton                                        19
     C                   If        XCUM = 'Y'
     C                   seton                                        18
     C                   else
     C                   setoff                                       18
     C                   endif

     C                   DOW       *INKC = *OFF
     C                             and ErrInd = 'Y'
     C                   eval      ErrInd = 'N'

     C                   WRITE     UP6000F0

     C                   seton                                        28
     C                   WRITE     UP6000C1

     C                   EXFMT     UP6000F2

     C                   EXSR      CLEAR
     C                   setoff                                       3031

      * Validate that package entered is non blank
     C                   If        XPACK = *blanks
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6002'
     C                   EVAL      ErrInd = 'Y'
     C                   seton                                        30
     C                   EXSR      ZASNMS
     C                   ENDIF

     C                   If        XCUM = 'Y'
     C                   If        XPACK2 = *blanks
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6002'
     C                   EVAL      ErrInd = 'Y'
     C                   seton                                        31
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF

     C                   If        ErrInd = 'Y'
     C                   ITER
     C                   Endif

      * Validate that package entered is 9 char
     C                   If        %len(%trim(XPACK)) <> 9
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6003'
     C                   EVAL      ErrInd = 'Y'
     C                   seton                                        30
     C                   EXSR      ZASNMS
     C                   ENDIF

     C                   If        XCUM = 'Y'
     C                   If        %len(%trim(XPACK2)) <> 9
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6003'
     C                   EVAL      ErrInd = 'Y'
     C                   seton                                        31
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF

     C                   If        ErrInd = 'Y'
     C                   ITER
     C                   Endif

      * Check that libraries exist
      * *B
     C                   If        XCUM = 'Y'
     C                   eval      LibName = XPACK2 + 'B'
     C                   else
     C                   eval      LibName = XPACK + 'B'
     C                   endif
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *BLANK        RTNCOD           10
     C                   PARM      LibName       P2OBNM           10
     C                   PARM      '*LIBL'       P2TLIB           10
     C                   PARM      '*LIB'        P2OBTP            8
     C                   PARM      *blanks       CHKMBR           10
      *
      * If libary does not exist, send message
     C     RTNCOD        IFNE      'Exist'
     C                   If        XCUM = 'Y'
     C                   seton                                        31
     C                   else
     C                   seton                                        30
     C                   endif
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6004'
     C                   EVAL      ZAMSDA = LibName
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF

      * *U
     C                   eval      LibName = XPACK + 'U'
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *BLANK        RTNCOD           10
     C                   PARM      LibName       P2OBNM           10
     C                   PARM      '*LIBL'       P2TLIB           10
     C                   PARM      '*LIB'        P2OBTP            8
     C                   PARM      *blanks       CHKMBR           10
      *
      * If libary does not exist, send message
     C     RTNCOD        IFNE      'Exist'
     C                   seton                                        30
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6004'
     C                   EVAL      ZAMSDA = LibName
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF

      * *D
     C                   If        XCUM = 'Y'
     C                   eval      LibName = XPACK2 + 'D'
     C                   else
     C                   eval      LibName = XPACK + 'D'
     C                   endif
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *BLANK        RTNCOD           10
     C                   PARM      LibName       P2OBNM           10
     C                   PARM      '*LIBL'       P2TLIB           10
     C                   PARM      '*LIB'        P2OBTP            8
     C                   PARM      *blanks       CHKMBR           10
      *
      * If libary does not exist, send message
     C     RTNCOD        IFNE      'Exist'
     C                   If        XCUM = 'Y'
     C                   seton                                        31
     C                   else
     C                   seton                                        30
     C                   endif
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6004'
     C                   EVAL      ZAMSDA = LibName
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF

      * *Q
     C                   eval      LibName = XPACK + 'Q'
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *BLANK        RTNCOD           10
     C                   PARM      LibName       P2OBNM           10
     C                   PARM      '*LIBL'       P2TLIB           10
     C                   PARM      '*LIB'        P2OBTP            8
     C                   PARM      *blanks       CHKMBR           10
      *
      * If libary does not exist replace it by BrgDeliveredSrcLib
     C     RTNCOD        IFNE      'Exist'
     C                   eval      LibNameQ = XPACK + 'U'
     C                   else
     C                   eval      LibNameQ = XPACK + 'Q'
     C                   ENDIF

     C                   If        XCUM = 'Y'
      * *G
     C                   eval      LibName = XPACK + 'G'
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *BLANK        RTNCOD           10
     C                   PARM      LibName       P2OBNM           10
     C                   PARM      '*LIBL'       P2TLIB           10
     C                   PARM      '*LIB'        P2OBTP            8
     C                   PARM      *blanks       CHKMBR           10
      *
      * If libary does not exist, send message
     C     RTNCOD        IFNE      'Exist'
     C                   seton                                        30
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6004'
     C                   EVAL      ZAMSDA = LibName
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF

      * *Z
     C                   eval      LibName = XPACK + 'Z'
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *BLANK        RTNCOD           10
     C                   PARM      LibName       P2OBNM           10
     C                   PARM      '*LIBL'       P2TLIB           10
     C                   PARM      '*LIB'        P2OBTP            8
     C                   PARM      *blanks       CHKMBR           10
      *
      * If libary does not exist, send message
     C     RTNCOD        IFNE      'Exist'
     C                   seton                                        30
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6004'
     C                   EVAL      ZAMSDA = LibName
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF

      * *M
     C                   eval      LibName = XPACK2 + 'M'
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *BLANK        RTNCOD           10
     C                   PARM      LibName       P2OBNM           10
     C                   PARM      '*LIBL'       P2TLIB           10
     C                   PARM      '*LIB'        P2OBTP            8
     C                   PARM      *blanks       CHKMBR           10
      *
      * If libary does not exist, send message
     C     RTNCOD        IFNE      'Exist'
     C                   seton                                        31
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6004'
     C                   EVAL      ZAMSDA = LibName
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF

      * *N
     C                   eval      LibName = XPACK2 + 'N'
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *BLANK        RTNCOD           10
     C                   PARM      LibName       P2OBNM           10
     C                   PARM      '*LIBL'       P2TLIB           10
     C                   PARM      '*LIB'        P2OBTP            8
     C                   PARM      *blanks       CHKMBR           10
      *
      * If libary does not exist, send message
     C     RTNCOD        IFNE      'Exist'
     C                   seton                                        31
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6004'
     C                   EVAL      ZAMSDA = LibName
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF

      * *P
     C                   eval      LibName = XPACK2 + 'P'
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *BLANK        RTNCOD           10
     C                   PARM      LibName       P2OBNM           10
     C                   PARM      '*LIBL'       P2TLIB           10
     C                   PARM      '*LIB'        P2OBTP            8
     C                   PARM      *blanks       CHKMBR           10
      *
      * If libary does not exist, send message
     C     RTNCOD        IFNE      'Exist'
     C                   seton                                        31
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6004'
     C                   EVAL      ZAMSDA = LibName
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF

     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrSysValg - Set system values for global                     *
      *                                                               *
      *****************************************************************
     C     SrSysValg     BEGSR

     C                   If        XCUM = 'Y'
     C                   eval      SQLDynStmt = 'update ' + sprf + 'GMLIB' +
     C                             '/GPSVLXTD set GIVAL = ' + '''' +
     C                             XPACK2 + 'B' + '''' + ' where GISVAL = ' +
     C                             '''' + 'BrgDeliveredBrgLib' + ''''
     C                   else
     C                   eval      SQLDynStmt = 'update ' + sprf + 'GMLIB' +
     C                             '/GPSVLXTD set GIVAL = ' + '''' +
     C                             XPACK + 'B' + '''' + ' where GISVAL = ' +
     C                             '''' + 'BrgDeliveredBrgLib' + ''''
     C                   endif

     C/EXEC SQL
     C+ prepare DynSQLStmnt
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ execute DynSQLStmnt
     C/end-exec
     C                   If        SQLCode <> 0
     C                   eval      DBASE = '010'
     C                   exsr      *pssr
     C                   Endif

     C                   If        XCUM = 'Y'
     C                   eval      SQLDynStmt = 'update ' + sprf + 'GMLIB' +
     C                             '/GPSVLXTD set GIVAL = ' + '''' +
     C                             XPACK2 + 'D' + '''' + ' where GISVAL = ' +
     C                             '''' + 'BrgDeliveredDtaLib' + ''''
     C                   else
     C                   eval      SQLDynStmt = 'update ' + sprf + 'GMLIB' +
     C                             '/GPSVLXTD set GIVAL = ' + '''' +
     C                             XPACK + 'D' + '''' + ' where GISVAL = ' +
     C                             '''' + 'BrgDeliveredDtaLib' + ''''
     C                   endif

     C/EXEC SQL
     C+ prepare DynSQLStmnt
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ execute DynSQLStmnt
     C/end-exec
     C                   If        SQLCode <> 0
     C                   eval      DBASE = '011'
     C                   exsr      *pssr
     C                   Endif

     C                   eval      SQLDynStmt = 'update ' + sprf + 'GMLIB' +
     C                             '/GPSVLXTD set GIVAL = ' + '''' +
     C                             XPACK + 'U' + '''' + ' where GISVAL = ' +
     C                             '''' + 'BrgDeliveredSrcLib' + ''''

     C/EXEC SQL
     C+ prepare DynSQLStmnt
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ execute DynSQLStmnt
     C/end-exec
     C                   If        SQLCode <> 0
     C                   eval      DBASE = '012'
     C                   exsr      *pssr
     C                   Endif

     C                   eval      SQLDynStmt = 'update ' + sprf + 'GMLIB' +
     C                             '/GPSVLXTD set GIVAL = ' + '''' +
     C                             LibNameQ    + '''' + ' where GISVAL = ' +
     C                             '''' + 'BrgDeliveredStrPrLib' + ''''

     C/EXEC SQL
     C+ prepare DynSQLStmnt
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ execute DynSQLStmnt
     C/end-exec
     C                   If        SQLCode <> 0
     C                   eval      DBASE = '013'
     C                   exsr      *pssr
     C                   Endif

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrSysVal - Set system values                                 *
      *                                                               *
      *****************************************************************
     C     SrSysVal      BEGSR

     C                   If        XCUM = 'Y'
     C                   eval      SQLDynStmt = 'update ' + sprf + 'DMLIB' +
     C                             '/SDSVLXTD set GIVAL = ' + '''' +
     C                             XPACK2 + 'B' + '''' + ' where GISVAL = ' +
     C                             '''' + 'BrgDeliveredBrgLib' + ''''
     C                   else
     C                   eval      SQLDynStmt = 'update ' + sprf + 'DMLIB' +
     C                             '/SDSVLXTD set GIVAL = ' + '''' +
     C                             XPACK + 'B' + '''' + ' where GISVAL = ' +
     C                             '''' + 'BrgDeliveredBrgLib' + ''''
     C                   Endif

     C/EXEC SQL
     C+ prepare DynSQLStmnt
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ execute DynSQLStmnt
     C/end-exec
     C                   If        SQLCode <> 0
     C                   eval      DBASE = '014'
     C                   exsr      *pssr
     C                   Endif

     C                   If        XCUM = 'Y'
     C                   eval      SQLDynStmt = 'update ' + sprf + 'DMLIB' +
     C                             '/SDSVLXTD set GIVAL = ' + '''' +
     C                             XPACK2 + 'D' + '''' + ' where GISVAL = ' +
     C                             '''' + 'BrgDeliveredDtaLib' + ''''
     C                   else
     C                   eval      SQLDynStmt = 'update ' + sprf + 'DMLIB' +
     C                             '/SDSVLXTD set GIVAL = ' + '''' +
     C                             XPACK + 'D' + '''' + ' where GISVAL = ' +
     C                             '''' + 'BrgDeliveredDtaLib' + ''''
     C                   Endif

     C/EXEC SQL
     C+ prepare DynSQLStmnt
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ execute DynSQLStmnt
     C/end-exec
     C                   If        SQLCode <> 0
     C                   eval      DBASE = '015'
     C                   exsr      *pssr
     C                   Endif

     C                   eval      SQLDynStmt = 'update ' + sprf + 'DMLIB' +
     C                             '/SDSVLXTD set GIVAL = ' + '''' +
     C                             XPACK + 'U' + '''' + ' where GISVAL = ' +
     C                             '''' + 'BrgDeliveredSrcLib' + ''''

     C/EXEC SQL
     C+ prepare DynSQLStmnt
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ execute DynSQLStmnt
     C/end-exec
     C                   If        SQLCode <> 0
     C                   eval      DBASE = '016'
     C                   exsr      *pssr
     C                   Endif

     C                   eval      SQLDynStmt = 'update ' + sprf + 'DMLIB' +
     C                             '/SDSVLXTD set GIVAL = ' + '''' +
     C                             LibNameQ    + '''' + ' where GISVAL = ' +
     C                             '''' + 'BrgDeliveredStrPrLib' + ''''

     C/EXEC SQL
     C+ prepare DynSQLStmnt
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ execute DynSQLStmnt
     C/end-exec
     C                   If        SQLCode <> 0
     C                   eval      DBASE = '017'
     C                   exsr      *pssr
     C                   Endif


     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Sr_RestLib - Validate libraries for restore                  *
      *                                                               *
      *****************************************************************
     C     Sr_RestLib    BEGSR

     C                   eval      ErrInd = 'Y'

      * If not cumulative
     C                   If        XCUM <> 'Y'

     C                   DOW       *INKC = *OFF
     C                             and ErrInd = 'Y'
     C                   eval      ErrInd = 'N'

     C                   setoff                                       20
     C                   WRITE     UP6000F0

     C                   seton                                        28
     C                   WRITE     UP6000C1

     C                   EXFMT     UP6000F11

      ** End program if F3 is pressed.
     C                   IF        *INKC = *ON
     C                   EXSR      Exit
     C                   ENDIF

     C                   EXSR      CLEAR
     C                   eval      %Subarr(*IN : 30 : 10) = *OFF
     C                   eval      %Subarr(*IN : 60 : 10) = *OFF

      * Run validation for each selected layer
     C                   if        XSELG <> *blanks
     C                   eval      ValLib = XLIBG
     C                   exsr      Sr_ValLibG
     C                   If        ErrInd = 'Y'
     C                   seton                                        30
     C                   ENDIF
     C                   eval      ValLib = XLIRG
     C                   exsr      Sr_ValLibL
     C                   If        ErrInd = 'Y'
     C                   seton                                        60
     C                   ENDIF
     C                   ENDIF

     C                   if        vPFX1 <> *blanks
     C                   eval      ValLib = XLIBZ1
     C                   exsr      Sr_ValLibZ
     C                   If        ErrInd = 'Y'
     C                   seton                                        31
     C                   ENDIF
     C                   eval      ValLib = XLIRZ1
     C                   exsr      Sr_ValLibL
     C                   If        ErrInd = 'Y'
     C                   seton                                        61
     C                   ENDIF
     C                   ENDIF

     C                   if        vPFX2 <> *blanks
     C                   eval      ValLib = XLIBZ2
     C                   exsr      Sr_ValLibZ
     C                   If        ErrInd = 'Y'
     C                   seton                                        32
     C                   ENDIF
     C                   eval      ValLib = XLIRZ2
     C                   exsr      Sr_ValLibL
     C                   If        ErrInd = 'Y'
     C                   seton                                        62
     C                   ENDIF
     C                   ENDIF

     C                   if        vPFX3 <> *blanks
     C                   eval      ValLib = XLIBZ3
     C                   exsr      Sr_ValLibZ
     C                   If        ErrInd = 'Y'
     C                   seton                                        33
     C                   ENDIF
     C                   eval      ValLib = XLIRZ3
     C**********         exsr      Sr_ValLibZ                                               MD061533
     C                   exsr      Sr_ValLibL                                               MD061533
     C                   If        ErrInd = 'Y'
     C                   seton                                        63
     C                   ENDIF
     C                   ENDIF

     C                   if        vPFX4 <> *blanks
     C                   eval      ValLib = XLIBZ4
     C                   exsr      Sr_ValLibZ
     C                   If        ErrInd = 'Y'
     C                   seton                                        34
     C                   ENDIF
     C                   eval      ValLib = XLIRZ4
     C                   exsr      Sr_ValLibL
     C                   If        ErrInd = 'Y'
     C                   seton                                        64
     C                   ENDIF
     C                   ENDIF

     C                   if        vPFX5 <> *blanks
     C                   eval      ValLib = XLIBZ5
     C                   exsr      Sr_ValLibZ
     C                   If        ErrInd = 'Y'
     C                   seton                                        35
     C                   ENDIF
     C                   eval      ValLib = XLIRZ5
     C                   exsr      Sr_ValLibL
     C                   If        ErrInd = 'Y'
     C                   seton                                        65
     C                   ENDIF
     C                   ENDIF

     C                   if        vPFX6 <> *blanks
     C                   eval      ValLib = XLIBZ6
     C                   exsr      Sr_ValLibZ
     C                   If        ErrInd = 'Y'
     C                   seton                                        36
     C                   ENDIF
     C                   eval      ValLib = XLIRZ6
     C                   exsr      Sr_ValLibL
     C                   If        ErrInd = 'Y'
     C                   seton                                        66
     C                   ENDIF
     C                   ENDIF

     C                   if        vPFX7 <> *blanks
     C                   eval      ValLib = XLIBZ7
     C                   exsr      Sr_ValLibZ
     C                   If        ErrInd = 'Y'
     C                   seton                                        37
     C                   ENDIF
     C                   eval      ValLib = XLIRZ7
     C                   exsr      Sr_ValLibL
     C                   If        ErrInd = 'Y'
     C                   seton                                        67
     C                   ENDIF
     C                   ENDIF

     C                   if        vPFX8 <> *blanks
     C                   eval      ValLib = XLIBZ8
     C                   exsr      Sr_ValLibZ
     C                   If        ErrInd = 'Y'
     C                   seton                                        38
     C                   ENDIF
     C                   eval      ValLib = XLIRZ8
     C                   exsr      Sr_ValLibL
     C                   If        ErrInd = 'Y'
     C                   seton                                        68
     C                   ENDIF
     C                   ENDIF

     C                   if        vPFX9 <> *blanks
     C                   eval      ValLib = XLIBZ9
     C                   exsr      Sr_ValLibZ
     C                   If        ErrInd = 'Y'
     C                   seton                                        39
     C                   ENDIF
     C                   eval      ValLib = XLIRZ9
     C                   exsr      Sr_ValLibL
     C                   If        ErrInd = 'Y'
     C                   seton                                        69
     C                   ENDIF
     C                   ENDIF

     C                   if        vPFX0 <> *blanks
     C                   eval      ValLib = XLIBZ0
     C                   exsr      Sr_ValLibZ
     C                   If        ErrInd = 'Y'
     C                   seton                                        40
     C                   ENDIF
     C                   eval      ValLib = XLIRZ0
     C                   exsr      Sr_ValLibL
     C                   If        ErrInd = 'Y'
     C                   seton                                        70
     C                   ENDIF
     C                   ENDIF

     C                   eval      pos = %LOOKUP(*ON: *IN: 30 : 10)
     C                   If        pos > 0
     C                   eval      ErrInd = 'Y'
     C                   Endif

     C                   eval      pos = %LOOKUP(*ON: *IN: 60 : 10)
     C                   If        pos > 0
     C                   eval      ErrInd = 'Y'
     C                   Endif

     C                   ENDDO

      * If cumulative
     C                   else

     C                   DOW       *INKC = *OFF
     C                             and ErrInd = 'Y'
     C                   eval      ErrInd = 'N'

     C                   setoff                                       20
     C                   WRITE     UP6000F0

     C                   seton                                        28
     C                   WRITE     UP6000C1

     C                   EXFMT     UP6000F12

      ** End program if F3 is pressed.
     C                   IF        *INKC = *ON
     C                   EXSR      Exit
     C                   ENDIF

     C                   EXSR      CLEAR
     C                   eval      %Subarr(*IN : 30 : 10) = *OFF
     C                   eval      %Subarr(*IN : 60 : 10) = *OFF


     C                   ENDDO

     C                   endif

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Sr_ValLibG - Validate library and SAVF                       *
      *                                                               *
      *****************************************************************
     C     Sr_ValLibG    BEGSR

     C                   eval      ErrInd = ' '
      * Check that library exists
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *BLANK        RTNCOD
     C                   PARM      ValLib        P2OBNM
     C                   PARM      '*LIBL'       P2TLIB
     C                   PARM      '*LIB'        P2OBTP
     C                   PARM      *blanks       CHKMBR
      *
      * If libary does not exist in the library list, send message
     C     RTNCOD        IFNE      'Exist'
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6004'
     C                   EVAL      ZAMSDA = ValLib
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   else

      * Check that SAVF exists in the library
     C                   eval      SAVF = XPACK + 'G'
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *BLANK        RTNCOD
     C                   PARM      SAVF          P2OBNM
     C                   PARM      ValLib        P2TLIB
     C                   PARM      '*FILE'       P2OBTP
     C                   PARM      *blanks       CHKMBR
      *
      * If SAVF does not exist in the library, send message
     C     RTNCOD        IFNE      'Exist'
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6006'
     C                   EVAL      ZAMSDA = SAVF
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Sr_ValLibL  - Validate library                               *
      *                                                               *
      *****************************************************************
     C     Sr_ValLibL    BEGSR

     C                   eval      ErrInd = ' '
      * Check that library exists
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *BLANK        RTNCOD
     C                   PARM      ValLib        P2OBNM
     C                   PARM      '*LIBL'       P2TLIB
     C                   PARM      '*LIB'        P2OBTP
     C                   PARM      *blanks       CHKMBR
      *
      * If libary does not exist in the library list, send message
     C     RTNCOD        IFNE      'Exist'
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6004'
     C                   EVAL      ZAMSDA = ValLib
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Sr_ValLibZ - Validate library and SAVF                       *
      *                                                               *
      *****************************************************************
     C     Sr_ValLibZ    BEGSR

     C                   eval      ErrInd = ' '
      * Check that library exists
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *BLANK        RTNCOD
     C                   PARM      ValLib        P2OBNM
     C                   PARM      '*LIBL'       P2TLIB
     C                   PARM      '*LIB'        P2OBTP
     C                   PARM      *blanks       CHKMBR
      *
      * If libary does not exist in the library list, send message
     C     RTNCOD        IFNE      'Exist'
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6004'
     C                   EVAL      ZAMSDA = ValLib
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   else

      * Check that SAVF exists in the library
     C                   eval      SAVF = XPACK + 'Z'
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *BLANK        RTNCOD
     C                   PARM      SAVF          P2OBNM
     C                   PARM      ValLib        P2TLIB
     C                   PARM      '*FILE'       P2OBTP
     C                   PARM      *blanks       CHKMBR
      *
      * If SAVF does not exist in the library, send message
     C     RTNCOD        IFNE      'Exist'
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6006'
     C                   EVAL      ZAMSDA = SAVF
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Sr_RestObj - Restore objects from SAVF                       *
      *                                                               *
      *****************************************************************
     C     Sr_RestObj    BEGSR

     C                   eval      ErrInd = 'Y'

      * If no cumulative
     C                   If        XCUM <> 'Y'

     C                   DOW       *INKC = *OFF
     C                             and ErrInd = 'Y'
     C                   eval      ErrInd = 'N'

      ** Redisplay screen for confimration
     C                   seton                                        2021
     C                   WRITE     UP6000F0
     C                   seton                                        28
     C                   WRITE     UP6000C1
     C                   EXFMT     UP6000F11

      ** End program if F3 is pressed.
     C                   IF        *INKC = *ON
     C                   EXSR      Exit
     C                   ENDIF

     C                   EXSR      CLEAR
     C                   eval      %Subarr(*IN : 30 : 10) = *OFF

      * Run validation for each selected layer
     C                   if        XSELG <> *blanks
     C                   eval      sprf = GPFX
     C                   eval      ValLib = XLIBG
     C                   exsr      Sr_RestG
     C                   If        ErrInd = 'Y'
     C                   seton                                        30
     C                   ENDIF
     C                   ENDIF

     C                   if        vPFX1 <> *blanks
     C                   eval      sprf = vPFX1
     C                   eval      ValLib = XLIBZ1
     C                   eval      RstLib = XLIRZ1
     C                   exsr      Sr_RestZ
     C                   If        ErrInd = 'Y'
     C                   seton                                        31
     C                   ENDIF
     C                   ENDIF

     C                   if        vPFX2 <> *blanks
     C                   eval      sprf = vPFX2
     C                   eval      ValLib = XLIBZ2
     C                   eval      RstLib = XLIRZ2
     C                   exsr      Sr_RestZ
     C                   If        ErrInd = 'Y'
     C                   seton                                        32
     C                   ENDIF
     C                   ENDIF

     C                   if        vPFX3 <> *blanks
     C                   eval      sprf = vPFX3
     C                   eval      ValLib = XLIBZ3
     C                   eval      RstLib = XLIRZ3
     C                   exsr      Sr_RestZ
     C                   If        ErrInd = 'Y'
     C                   seton                                        33
     C                   ENDIF
     C                   ENDIF

     C                   if        vPFX4 <> *blanks
     C                   eval      sprf = vPFX4
     C                   eval      ValLib = XLIBZ4
     C                   eval      RstLib = XLIRZ4
     C                   exsr      Sr_RestZ
     C                   If        ErrInd = 'Y'
     C                   seton                                        34
     C                   ENDIF
     C                   ENDIF

     C                   if        vPFX5 <> *blanks
     C                   eval      sprf = vPFX5
     C                   eval      ValLib = XLIBZ5
     C                   eval      RstLib = XLIRZ5
     C                   exsr      Sr_RestZ
     C                   If        ErrInd = 'Y'
     C                   seton                                        35
     C                   ENDIF
     C                   ENDIF

     C                   if        vPFX6 <> *blanks
     C                   eval      sprf = vPFX6
     C                   eval      ValLib = XLIBZ6
     C                   eval      RstLib = XLIRZ6
     C                   exsr      Sr_RestZ
     C                   If        ErrInd = 'Y'
     C                   seton                                        36
     C                   ENDIF
     C                   ENDIF

     C                   if        vPFX7 <> *blanks
     C                   eval      sprf = vPFX7
     C                   eval      ValLib = XLIBZ7
     C                   eval      RstLib = XLIRZ7
     C                   exsr      Sr_RestZ
     C                   If        ErrInd = 'Y'
     C                   seton                                        37
     C                   ENDIF
     C                   ENDIF

     C                   if        vPFX8 <> *blanks
     C                   eval      sprf = vPFX8
     C                   eval      ValLib = XLIBZ8
     C                   eval      RstLib = XLIRZ8
     C                   exsr      Sr_RestZ
     C                   If        ErrInd = 'Y'
     C                   seton                                        38
     C                   ENDIF
     C                   ENDIF

     C                   if        vPFX9 <> *blanks
     C                   eval      sprf = vPFX9
     C                   eval      ValLib = XLIBZ9
     C                   eval      RstLib = XLIRZ9
     C                   exsr      Sr_RestZ
     C                   If        ErrInd = 'Y'
     C                   seton                                        39
     C                   ENDIF
     C                   ENDIF

     C                   if        vPFX0 <> *blanks
     C                   eval      sprf = vPFX0
     C                   eval      ValLib = XLIBZ0
     C                   eval      RstLib = XLIRZ0
     C                   exsr      Sr_RestZ
     C                   If        ErrInd = 'Y'
     C                   seton                                        40
     C                   ENDIF
     C                   ENDIF

     C                   eval      pos = %LOOKUP(*ON: *IN: 30 : 10)
     C                   If        pos > 0
     C                   eval      ErrInd = 'Y'
     C                   Endif

     C                   ENDDO

      * if cumulative
     C                   else
     C                   DOW       *INKC = *OFF
     C                             and ErrInd = 'Y'
     C                   eval      ErrInd = 'N'

      ** Redisplay screen for confimration
     C                   seton                                        2021
     C                   WRITE     UP6000F0
     C                   seton                                        28
     C                   WRITE     UP6000C1
     C                   EXFMT     UP6000F12

      ** End program if F3 is pressed.
     C                   IF        *INKC = *ON
     C                   EXSR      Exit
     C                   ENDIF

     C                   EXSR      CLEAR
     C                   eval      %Subarr(*IN : 60 : 10) = *OFF

      * Run validation for each selected layer
     C                   if        XSELG <> *blanks
     C                   eval      sprf = GPFX
     C                   eval      ValLib = XLIBG
     C                   exsr      Sr_RestGCum
     C                   If        ErrInd = 'Y'
     C                   seton                                        60
     C                   ENDIF
     C                   ENDIF

     C                   if        vPFX1 <> *blanks
     C                   eval      sprf = vPFX1
     C                   eval      ValLib = XLIBZ1
     C                   eval      RstLib = XLIRZ1
     C                   exsr      Sr_RestZCum
     C                   If        ErrInd = 'Y'
     C                   seton                                        61
     C                   ENDIF
     C                   ENDIF

     C                   if        vPFX2 <> *blanks
     C                   eval      sprf = vPFX2
     C                   eval      ValLib = XLIBZ2
     C                   eval      RstLib = XLIRZ2
     C                   exsr      Sr_RestZCum
     C                   If        ErrInd = 'Y'
     C                   seton                                        62
     C                   ENDIF
     C                   ENDIF

     C                   if        vPFX3 <> *blanks
     C                   eval      sprf = vPFX3
     C                   eval      ValLib = XLIBZ3
     C                   eval      RstLib = XLIRZ3
     C                   exsr      Sr_RestZCum
     C                   If        ErrInd = 'Y'
     C                   seton                                        63
     C                   ENDIF
     C                   ENDIF

     C                   if        vPFX4 <> *blanks
     C                   eval      sprf = vPFX4
     C                   eval      ValLib = XLIBZ4
     C                   eval      RstLib = XLIRZ4
     C                   exsr      Sr_RestZCum
     C                   If        ErrInd = 'Y'
     C                   seton                                        64
     C                   ENDIF
     C                   ENDIF

     C                   if        vPFX5 <> *blanks
     C                   eval      sprf = vPFX5
     C                   eval      ValLib = XLIBZ5
     C                   eval      RstLib = XLIRZ5
     C                   exsr      Sr_RestZCum
     C                   If        ErrInd = 'Y'
     C                   seton                                        65
     C                   ENDIF
     C                   ENDIF

     C                   if        vPFX6 <> *blanks
     C                   eval      sprf = vPFX6
     C                   eval      ValLib = XLIBZ6
     C                   eval      RstLib = XLIRZ6
     C                   exsr      Sr_RestZCum
     C                   If        ErrInd = 'Y'
     C                   seton                                        66
     C                   ENDIF
     C                   ENDIF

     C                   if        vPFX7 <> *blanks
     C                   eval      sprf = vPFX7
     C                   eval      ValLib = XLIBZ7
     C                   eval      RstLib = XLIRZ7
     C                   exsr      Sr_RestZCum
     C                   If        ErrInd = 'Y'
     C                   seton                                        67
     C                   ENDIF
     C                   ENDIF

     C                   if        vPFX8 <> *blanks
     C                   eval      sprf = vPFX8
     C                   eval      ValLib = XLIBZ8
     C                   eval      RstLib = XLIRZ8
     C                   exsr      Sr_RestZCum
     C                   If        ErrInd = 'Y'
     C                   seton                                        68
     C                   ENDIF
     C                   ENDIF

     C                   if        vPFX9 <> *blanks
     C                   eval      sprf = vPFX9
     C                   eval      ValLib = XLIBZ9
     C                   eval      RstLib = XLIRZ9
     C                   exsr      Sr_RestZCum
     C                   If        ErrInd = 'Y'
     C                   seton                                        69
     C                   ENDIF
     C                   ENDIF

     C                   if        vPFX0 <> *blanks
     C                   eval      sprf = vPFX0
     C                   eval      ValLib = XLIBZ0
     C                   eval      RstLib = XLIRZ0
     C                   exsr      Sr_RestZCum
     C                   If        ErrInd = 'Y'
     C                   seton                                        70
     C                   ENDIF
     C                   ENDIF

     C                   eval      pos = %LOOKUP(*ON: *IN: 60 : 10)
     C                   If        pos > 0
     C                   eval      ErrInd = 'Y'
     C                   Endif

     C                   ENDDO
     C                   endif

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Sr_RestG - Restore Global                                    *
      *                                                               *
      *****************************************************************
     C     Sr_RestG      BEGSR

     C                   eval      ErrInd = ' '
     C                   eval      PSExcpNo = '    '
     C                   EVAL      Cmd_String = 'RSTOBJ OBJ(*ALL) SAVLIB(' +
     C                             XPACK + 'G) DEV(*SAVF) SAVF(' +
     C                             %trim(ValLib) + '/' +
     C                             XPACK + 'G) MBROPT(*ALL) ALWOBJDIF' +
     C                             '(*ALL) RSTLIB(' + %trimr(XLIRG) + ')'  +
     C                             ' OUTPUT(*PRINT)'
     C                   CALL      'QCMDEXC'                            20
     C                   PARM                    Cmd_String
     C                   PARM                    Cmd_Len

      ** if CPF3773, allow '0 not restored'
     C                   eval      X_CHK = *blanks
     C                   If        PSExcpNo = '3773'
     C                   eval      pos = %scan('not restored':PSExcpData:1)
     C                   eval      X_CHK = %subst(PSExcpData:pos-3:2)
     C                   ENDIF

      ** if error
     C                   If        PSExcpNo <> '    '
     C                             and PSExcpNo <> '3707'
     C                             and PSExcpNo <> '3773'
     C                             or PSExcpNo = '3773' and X_CHK <> ' 0'
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6008'
     C                   EVAL      ZAMSDA = %trimr(XPACK) + 'G'
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   Endif


     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Sr_RestZ - Restore Global                                    *
      *                                                               *
      *****************************************************************
     C     Sr_RestZ      BEGSR

     C                   eval      ErrInd = ' '
     C                   eval      PSExcpNo = '    '
     C                   EVAL      Cmd_String = 'RSTOBJ OBJ(*ALL) SAVLIB(' +
     C                             XPACK + 'Z) DEV(*SAVF) SAVF(' +
     C                             %trim(ValLib) + '/' +
     C                             XPACK + 'Z) MBROPT(*ALL) ALWOBJDIF' +
     C                             '(*ALL) RSTLIB(' + %trimr(RstLib) + ')' +
     C                             ' OUTPUT(*PRINT)'
     C                   CALL      'QCMDEXC'                            20
     C                   PARM                    Cmd_String
     C                   PARM                    Cmd_Len

      ** if CPF3773, allow '0 not restored'
     C                   eval      X_CHK = *blanks
     C                   If        PSExcpNo = '3773'
     C                   eval      pos = %scan('not restored':PSExcpData:1)
     C                   eval      X_CHK = %subst(PSExcpData:pos-3:2)
     C                   ENDIF

      ** if error
     C                   If        PSExcpNo <> '    '
     C                             and PSExcpNo <> '3707'
     C                             and PSExcpNo <> '3773'
     C                             or PSExcpNo = '3773' and X_CHK <> ' 0'
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM6008'
     C                   EVAL      ZAMSDA = %trimr(XPACK) + 'Z'
     C                   EVAL      ErrInd = 'Y'
     C                   seton                                        51
     C                   EXSR      ZASNMS
     C                   Endif


     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Sr_RestGCum - Install global objects                         *
      *                                                               *
      *****************************************************************
     C     Sr_RestGCum   BEGSR

     C                   eval      ErrInd = ' '
     C                   eval      RTN = *blanks                                            MD061533

     C                   eval      LIBP =   XPACK2 + 'P'

      * System values are already updated, no need to run the scripts                       MD061533
     C**********         CALL      'PGMAG'                              20                  MD061533
     C**********         PARM                    LIBP                                       MD061533
     C**********         PARM                    GPFX                                       MD061533
     C**********         PARM                    ZPFX              2                        MD061533
     C**********         PARM                    RTN              10                        MD061533
      **********                                                                            MD061533
     C**********         if        RTN <> *blanks or *IN20 = '1'                            MD061533
     C**********         eval      ErrInd = 'Y'                                             MD061533
     C**********         leaveSR                                                            MD061533
     C**********         endif                                                              MD061533

     C                   CALL      'PGMB1'                              20
     C**********         PARM                    XPACK2                                     MD061361
     C                   PARM                    XPACK                                      MD061361
     C                   PARM                    GPFX
     C                   PARM                    ZPFX              2
     C                   PARM                    RTN

     C                   if        RTN <> *blanks or *IN20 = '1'
     C                   eval      ErrInd = 'Y'
     C                   leaveSR
     C                   endif

     C                   CALL      'PGMC1'                              20
     C                   PARM                    XPACK2
     C                   PARM                    GPFX
     C                   PARM                    ZPFX              2
     C                   PARM                    RTN

     C                   if        RTN <> *blanks or *IN20 = '1'
     C                   eval      ErrInd = 'Y'
     C                   leaveSR
     C                   endif

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Sr_RestZCum - Install zone objects                           *
      *                                                               *
      *****************************************************************
     C     Sr_RestZCum   BEGSR

     C                   eval      ErrInd = ' '
     C                   eval      RTN = *blanks                                            MD061533

     C                   eval      LIBP =   XPACK2 + 'P'

      * System values are already updated, no need to run the scripts                       MD061533
     C**********         CALL      'PGMAZ'                              20                  MD061533
     C**********         PARM                    LIBP             10                        MD061533
     C**********         PARM                    GPFX                                       MD061533
     C**********         PARM                    sprf                                       MD061533
     C**********         PARM                    RTN                                        MD061533
      **********                                                                            MD061533
     C**********         if        RTN <> *blanks or *IN20 = '1'                            MD061533
     C**********         eval      ErrInd = 'Y'                                             MD061533
     C**********         leaveSR                                                            MD061533
     C**********         endif                                                              MD061533

     C                   CALL      'PGMB2'                              20
     C**********         PARM                    XPACK2                                     MD061361
     C                   PARM                    XPACK                                      MD061361
     C                   PARM                    GPFX
     C                   PARM                    sprf
     C                   PARM                    RTN

     C                   if        RTN <> *blanks or *IN20 = '1'
     C                   eval      ErrInd = 'Y'
     C                   leaveSR
     C                   endif

     C                   CALL      'PGMC2'                              20
     C                   PARM                    XPACK2
     C                   PARM                    GPFX
     C                   PARM                    sprf
     C                   PARM                    RTN

     C                   if        RTN <> *blanks or *IN20 = '1'
     C                   eval      ErrInd = 'Y'
     C                   leaveSR
     C                   endif

     C                   ENDSR
      *****************************************************************

