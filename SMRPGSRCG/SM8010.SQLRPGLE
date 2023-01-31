     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2022')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP OTM Migration initialize')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  SM8010 - Midas UP OTM initialize                             *
      *                                                               *
      *  Function: This program allows initialization of system       *
      *            values and other options needed for migration      *
      *                                                               *
      *  (c) Finastra International Limited 2022                      *
      *                                                               *
      *  Last Amend No. MD060979           Date 27Jan23               *
      *  Prev Amend No. CUP046 *CREATE     Date 18Jul22               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD060979 - Monitor does not refresh (recompile)              *
      *  CUP046 - One Touch Bridge - migration                        *
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
     FSM8010GF  CF   E             WORKSTN

      ** Declared Variables
     D ErrInd          S             10A
     D LIBDM           S             10A
     D LIBGM           S             10A
     D LIBLIB          S             10A
     D DBASE           S              3A
     D EX_OBJ          S             10A
     D EX_TYP          S              9A
     D Ix              S              3  0
     D pos             S              2  0
     D XVAL            S            200A
     D TMST            S              6A
     D TMDT            S              6A
     D Cmd_String      S            300
     D Cmd_Len         S             15  5 INZ(300)

     D RelDS           DS
     D DSProd                  1     10
     D DSRel                  11     20
     D DSSub                  21     22

     D ##TIME          DS
     D ##TIM                   1     12  0
     D ##TME                   1      6  0
     D ##DTE                   7     12  0
      ** ZASNMS Variables
     D ZAPGMQ          S             10
     D ZAPGRL          S              5
     D ZAMSID          S              7
     D ZAMSGF          S             10
     D ZAMSDA          S            132
     D ZAMSTP          S              7
      ** Error Indicators
     D ErIOff          S             15
     D ErrFlg          S              1
      ** CBTIME Parameters
     D DayNoa          S              5
     D STime           S              6
     D DFmt            S              1
      ** ZDATE2 Parameters
     D CurrDt          S              5  0
     D WQ0003          S              6  0
     D ZDate           S              7
     D etc             S              3


      ** Program data structure
     D MyPSDS         SDS
     D DFPGMQ                  1     10
     D DFJOBN                244    253
     D DFDUSR                254    263
     D DFJBNO                264    269S 0
     D DFJBNC                264    269
      /EJECT
      *****************************************************************

      * load screen for old release level
     C                   exsr      SR_Release

      * load screen for system values
     C                   exsr      SR_SysVal

      * confirm layer(s) to be migrated
     C                   exsr      SR_Layers

      * if Global is to be migrated, display exception screen
     C                   If        #MIGGYN = 'Y'
     C                   exsr      SR_GlobExcp
     C                   ENDIF

      * if Zone is to be migrated, display exception screen
     C                   If        #MIGZYN = 'Y'
     C                   exsr      SR_ZoneExcp
     C                   ENDIF

      * if Zone is to be migrated, prompt for the new zone
     C                   If        #MIGZYN = 'Y'
     C                   exsr      SR_NewZone
     C                   ENDIF

      * if Zone is to be migrated, prompt for the users migration
     C                   If        #MIGZYN = 'Y'
     C                   exsr      SR_UsrMig
     C                   ENDIF

      * Finally update migration table
     C                   TIME                    ##TIM
     C                   eval      TMST = %CHAR(##TME)
     C                   eval      TMDT = %editC(##DTE:'X')
     C/EXEC SQL
     C+ insert into SMOTMMTD
     C+ (
     C+   DNGPFX
     C+  ,DNZPFX
     C+  ,DOGPFX
     C+  ,DOZPFX
     C+  ,DORLSL
     C+  ,DNOCMP
     C+  ,DNOCMC
     C+  ,DSTRTT
     C+  ,DSTRTD
     C+  ,DENDTM
     C+  ,DENDDT
     C+  ,DACTLY
     C+  ,DACTNR
     C+  ,DUTMST
     C+  ,DMIGGB
     C+  ,DMIGZN
     C+  ,DMIGHT
     C+ )
     C+ Values
     C+ (
     C+   :#GLBPFX
     C+  ,:#ZONPFX
     C+  ,:#GLOPFX
     C+  ,:#ZOOPFX
     C+  ,:#ORLSLV
     C+  ,0
     C+  ,0
     C+  ,:TMST
     C+  ,:TMDT
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+  ,:#MIGGYN
     C+  ,:#MIGZYN
     C+  ,' '
     C+ )
     C/END-EXEC
     C                   If        SQLCODE <> 0
     C                   eval      DBASE = '111'
     C                   exsr      *pssr
     C                   ENDIF

      ** End of program.
     C                   EVAL      *INLR = *ON
     C                   RETURN

      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_Release - Validate release level                          *
      *                                                               *
      *****************************************************************
     C     SR_Release    BEGSR
     C                   eval      ErrInd = 'Y'

     C                   DOW       *INKC = *OFF
     C                             and ErrInd = 'Y'
     C                   eval      ErrInd = 'N'

     C                   WRITE     SM8010F0

     C                   seton                                        28
     C                   WRITE     SM8010C1

     C                   EXFMT     SM8010F10

      ** End program if F3 is pressed.
     C                   IF        *INKC = *ON
     C                   EXSR      Exit
     C                   ENDIF

     C                   EXSR      CLEAR
     C                   setoff                                       56

     C                   if        #RELEASE = *Blanks
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM8014'
     C                   EVAL      ErrInd = 'Y'
     C                   seton                                        56
     C                   EXSR      ZASNMS
     C                   else
     C                   eval      RelDS = #RELEASE
     C                   call      'SMC8002'
     C                   parm                    DsProd
     C                   parm                    DsRel
     C                   parm                    DsSub
     C                   endif

      * check that system value was correctly updated
     C/exec SQL
     C+ select GIVAL into :XVAL from GPSVLXTD
     C+   where GISVAL = 'BrgOldSystemRlsLvl'
     C/end-exec
     C                   If        SQLCODE = 0 and XVAL <> *blanks
     C                   eval      #RELEASE = XVAL
     C                   else
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM8014'
     C                   EVAL      ErrInd = 'Y'
     C                   seton                                        56
     C                   EXSR      ZASNMS
     C                   ENDIF

     C                   ENDDO

      * Redisplay screen to confirm
     C                   WRITE     SM8010F0
     C                   seton                                        2128
     C                   WRITE     SM8010C1
     C                   EXFMT     SM8010F10

      ** End program if F3 is pressed.
     C                   IF        *INKC = *ON
     C                   EXSR      Exit
     C                   ENDIF


     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_SysVal - Validate system values                           *
      *                                                               *
      *****************************************************************
     C     SR_SysVal     BEGSR
     C                   eval      ErrInd = 'Y'
     C                   setoff                                       2122

      * retrieve values from tables
     C                   exsr      SR_RtvSval

     C                   DOW       *INKC = *OFF
     C                             and ErrInd = 'Y'
     C                   eval      ErrInd = 'N'

     C                   WRITE     SM8010F0

     C                   seton                                        28
     C                   WRITE     SM8010C1

     C                   EXFMT     SM8010F1

      ** End program if F3 is pressed.
     C                   IF        *INKC = *ON
     C                   EXSR      Exit
     C                   ENDIF

     C                   EXSR      CLEAR
     C                   setoff                                       515253
     C                   setoff                                       545556

      * *I library
      * Validate that library entered is non blank
     C                   If        #BRGLIB = *blanks
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM8007'
     C                   EVAL      ErrInd = 'Y'
     C                   seton                                        51
     C                   EXSR      ZASNMS
     C                   else

      * Check that library exists
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *BLANK        RTNCOD           10
     C                   PARM      #BRGLIB       P2OBNM           10
     C                   PARM      '*LIBL'       P2TLIB           10
     C                   PARM      '*LIB'        P2OBTP            8
     C                   PARM      *blanks       CHKMBR           10
      *
      * If libary does not exist in the library list, send message
     C     RTNCOD        IFNE      'Exist'
     C                   seton                                        51
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM8004'
     C                   EVAL      ZAMSDA = #BRGLIB
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   else

      * Check that library has 'I' suffix
     C     ' '           scan      #BRGLIB       pos
     C                   if        pos = 0
     C                   eval      pos = 11
     C                   endif
     C                   if        %subst(#BRGLIB:pos-1:1) <> 'I'
     C                   seton                                        51
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM8006'
     C                   EVAL      ZAMSDA = #BRGLIB
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

      * *Q library
      * Validate that library entered is non blank
     C                   If        #STRLIB = *blanks
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM8013'
     C                   EVAL      ErrInd = 'Y'
     C                   seton                                        56
     C                   EXSR      ZASNMS
     C                   else

      * Check that library exists
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *BLANK        RTNCOD           10
     C                   PARM      #STRLIB       P2OBNM           10
     C                   PARM      '*LIBL'       P2TLIB           10
     C                   PARM      '*LIB'        P2OBTP            8
     C                   PARM      *blanks       CHKMBR           10
      *
      * If libary does not exist in the library list, send message
     C     RTNCOD        IFNE      'Exist'
     C                   seton                                        56
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM8004'
     C                   EVAL      ZAMSDA = #STRLIB
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   else

      * Check that library has 'Q' suffix
     C     ' '           scan      #STRLIB       pos
     C                   if        pos = 0
     C                   eval      pos = 11
     C                   endif
     C                   if        %subst(#STRLIB:pos-1:1) <> 'Q'
     C                   seton                                        56
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM8015'
     C                   EVAL      ZAMSDA = #STRLIB
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

      * Global prefix
      * Validate that prefix entered is non blank
     C                   If        #GLBPFX = *blanks
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM8008'
     C                   EVAL      ErrInd = 'Y'
     C                   seton                                        52
     C                   EXSR      ZASNMS
     C                   else

      * Check that GM library exists
     C                   eval      LIBGM = #GLBPFX + 'GMLIB'
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *BLANK        RTNCOD
     C                   PARM      LIBGM         P2OBNM
     C                   PARM      '*LIBL'       P2TLIB
     C                   PARM      '*LIB'        P2OBTP
     C                   PARM      *blanks       CHKMBR

      * If libary does not exist in the library list, send message
     C     RTNCOD        IFNE      'Exist'
     C                   seton                                        52
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM8004'
     C                   EVAL      ZAMSDA = LIBGM
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF

      * Zone prefix
      * Validate that prefix entered is non blank
     C                   If        #ZONPFX = *blanks
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM8009'
     C                   EVAL      ErrInd = 'Y'
     C                   seton                                        53
     C                   EXSR      ZASNMS
     C                   else

      * Check that DM library exists
     C                   eval      LIBDM = #ZONPFX + 'DMLIB'
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *BLANK        RTNCOD
     C                   PARM      LIBDM         P2OBNM
     C                   PARM      '*LIBL'       P2TLIB
     C                   PARM      '*LIB'        P2OBTP
     C                   PARM      *blanks       CHKMBR

      * If libary does not exist in the library list, send message
     C     RTNCOD        IFNE      'Exist'
     C                   seton                                        53
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM8004'
     C                   EVAL      ZAMSDA = LIBDM
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF

      * Old Global prefix
      * Validate that prefix entered is non blank as long as old release is not didas
     C                   If        %subst(#RELEASE:1:6) <> 'Midas '
     C                   If        #GLOPFX = *blanks
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM8008'
     C                   EVAL      ErrInd = 'Y'
     C                   seton                                        54
     C                   EXSR      ZASNMS
     C                   else

      * Check that GM library exists
     C                   eval      LIBGM = #GLOPFX + 'GMLIB'
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *BLANK        RTNCOD
     C                   PARM      LIBGM         P2OBNM
     C                   PARM      '*LIBL'       P2TLIB
     C                   PARM      '*LIB'        P2OBTP
     C                   PARM      *blanks       CHKMBR

      * If libary does not exist in the library list, send message
     C     RTNCOD        IFNE      'Exist'
     C                   seton                                        54
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM8004'
     C                   EVAL      ZAMSDA = LIBGM
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
     C                   else
     C                   eval      #GLOPFX = *blanks
     C                   ENDIF

      * Zone prefix
      * Validate that prefix entered is non blank
     C                   If        #ZOOPFX = *blanks
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM8009'
     C                   EVAL      ErrInd = 'Y'
     C                   seton                                        55
     C                   EXSR      ZASNMS
     C                   else

      * Check that DM library exists
     C                   eval      LIBDM = #ZOOPFX + 'DMLIB'
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *BLANK        RTNCOD
     C                   PARM      LIBDM         P2OBNM
     C                   PARM      '*LIBL'       P2TLIB
     C                   PARM      '*LIB'        P2OBTP
     C                   PARM      *blanks       CHKMBR

      * If libary does not exist in the library list, send message
     C     RTNCOD        IFNE      'Exist'
     C                   seton                                        55
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM8004'
     C                   EVAL      ZAMSDA = LIBDM
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF

     C                   ENDDO

      * Redisplay screen to confirm
     C                   WRITE     SM8010F0
     C                   seton                                        2128
     C                   WRITE     SM8010C1
     C                   EXFMT     SM8010F1

      ** End program if F3 is pressed.
     C                   IF        *INKC = *ON
     C                   EXSR      Exit
     C                   ENDIF

      ** Update the system values
     C/exec SQL
     C+ update GPSVLXTD set GIVAL = :#BRGLIB
     C+   where GISVAL = 'BrgDeliveredBrgLib'
     C/end-exec
     C                   If        SQLCODE <> 0
     C                   eval      DBASE = '001'
     C                   exsr      *pssr
     C                   ENDIF

     C/exec SQL
     C+ update GPSVLXTD set GIVAL = :#STRLIB
     C+   where GISVAL = 'BrgDeliveredStrPrLib'
     C/end-exec
     C                   If        SQLCODE <> 0
     C                   eval      DBASE = '011'
     C                   exsr      *pssr
     C                   ENDIF

     C/exec SQL
     C+ update GPSVLXTD set GIVAL = :#GLBPFX
     C+   where GISVAL = 'BrgMidasGlobalPrefix'
     C/end-exec
     C                   If        SQLCODE <> 0
     C                   eval      DBASE = '002'
     C                   exsr      *pssr
     C                   ENDIF

     C/exec SQL
     C+ update GPSVLXTD set GIVAL = :#GLOPFX
     C+   where GISVAL = 'BrgOldGlobalPrefix'
     C/end-exec
     C                   If        SQLCODE <> 0
     C                   eval      DBASE = '020'
     C                   exsr      *pssr
     C                   ENDIF

     C/exec SQL
     C+ update GPSVLXTD set GIVAL = :#ORLSLV
     C+   where GISVAL = 'BrgOldSystemRlsLvl'
     C/end-exec
     C                   If        SQLCODE <> 0
     C                   eval      DBASE = '021'
     C                   exsr      *pssr
     C                   ENDIF

     C/exec SQL
     C+ update SDSVLXTD set GIVAL = :#BRGLIB
     C+   where GISVAL = 'BrgDeliveredBrgLib'
     C/end-exec
     C                   If        SQLCODE <> 0
     C                   eval      DBASE = '003'
     C                   exsr      *pssr
     C                   ENDIF

     C/exec SQL
     C+ update SDSVLXTD set GIVAL = :#STRLIB
     C+   where GISVAL = 'BrgDeliveredStrPrLib'
     C/end-exec
     C                   If        SQLCODE <> 0
     C                   eval      DBASE = '133'
     C                   exsr      *pssr
     C                   ENDIF

     C/exec SQL
     C+ update SDSVLXTD set GIVAL = :#GLBPFX
     C+   where GISVAL = 'BrgMidasGlobalPrefix'
     C/end-exec
     C                   If        SQLCODE <> 0
     C                   eval      DBASE = '004'
     C                   exsr      *pssr
     C                   ENDIF

     C/exec SQL
     C+ update SDSVLXTD set GIVAL = :#ZOOPFX
     C+   where GISVAL = 'BrgOldZonePrefix'
     C/end-exec
     C                   If        SQLCODE <> 0
     C                   eval      DBASE = '022'
     C                   exsr      *pssr
     C                   ENDIF

     C/exec SQL
     C+ update SDSVLXTD set GIVAL = :#ZONPFX
     C+   where GISVAL = 'BrgMidasSystemPrefix'
     C/end-exec
     C                   If        SQLCODE <> 0
     C                   eval      DBASE = '005'
     C                   exsr      *pssr
     C                   ENDIF

     C/exec SQL
     C+ update SDSVLXTD set GIVAL = :#ORLSLV
     C+   where GISVAL = 'BrgOldSystemRlsLvl'
     C/end-exec
     C                   If        SQLCODE <> 0
     C                   eval      DBASE = '025'
     C                   exsr      *pssr
     C                   ENDIF

     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_RtvSval - Retrieve system values from tables              *
      *                                                               *
      *****************************************************************
     C     SR_RtvSval    BEGSR

     C/exec SQL
     C+ select GIVAL into :XVAL from GPSVLXTD
     C+   where GISVAL = 'BrgDeliveredBrgLib'
     C/end-exec
     C                   If        SQLCODE = 0
     C                   eval      #BRGLIB = %subst(XVAL:1:10)
     C                   ENDIF

     C/exec SQL
     C+ select GIVAL into :XVAL from GPSVLXTD
     C+   where GISVAL = 'BrgDeliveredStrPrLib'
     C/end-exec
     C                   If        SQLCODE = 0
     C                   eval      #STRLIB = %subst(XVAL:1:10)
     C                   ENDIF

     C/exec SQL
     C+ select GIVAL into :XVAL from GPSVLXTD
     C+   where GISVAL = 'BrgMidasGlobalPrefix'
     C/end-exec
     C                   If        SQLCODE = 0
     C                   eval      #GLBPFX = %subst(XVAL:1:2)
     C                   ENDIF

     C/exec SQL
     C+ select GIVAL into :XVAL from GPSVLXTD
     C+   where GISVAL = 'BrgOldGlobalPrefix'
     C/end-exec
     C                   If        SQLCODE = 0
     C                   eval      #GLOPFX = %subst(XVAL:1:2)
     C                   ENDIF
      * if old release level is Midas, there is no old global
     C                   If        %subst(#RELEASE:1:6) = 'Midas '
     C                   eval      #GLOPFX = *blanks
     C                   seton                                        22
     C                   ENDIF

     C/exec SQL
     C+ select GIVAL into :XVAL from GPSVLXTD
     C+   where GISVAL = 'BrgOldSystemRlsLvl'
     C/end-exec
     C                   If        SQLCODE = 0
     C                   eval      #ORLSLV = %subst(XVAL:1:22)
     C                   ENDIF


     C/exec SQL
     C+ select GIVAL into :XVAL from SDSVLXTD
     C+   where GISVAL = 'BrgOldZonePrefix'
     C/end-exec
     C                   If        SQLCODE = 0
     C                   eval      #ZOOPFX = %subst(XVAL:1:2)
     C                   ENDIF

     C/exec SQL
     C+ select GIVAL into :XVAL from SDSVLXTD
     C+   where GISVAL = 'BrgMidasSystemPrefix'
     C/end-exec
     C                   If        SQLCODE = 0
     C                   eval      #ZONPFX = %subst(XVAL:1:2)
     C                   ENDIF

     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_Layers - Confirm layer(s) to be migrated                  *
      *                                                               *
      *****************************************************************
     C     SR_Layers     BEGSR

     C                   setoff                                       21
     C                   eval      ErrInd = 'Y'
     C                   eval      #MIGNRG = 'Migrate global layer ' +
     C                             #GLOPFX + ' into ' + #GLBPFX
     C                   eval      #MIGNRZ = 'Migrate zone layer ' +
     C                             #ZOOPFX + ' into ' + #ZONPFX

      * retrieve %ASP used
     C                   call      'UP0249'
     C                   parm                    RTCD             10
     C                   parm                    SysPctAft         7 4
     C                   parm                    SysTot            7 0
     C                   eval      #CURASP = 'Current % system ASP used is ' +
     C                             %char(SysPctAft)

     C                   DOW       *INKC = *OFF
     C                             and ErrInd = 'Y'
     C                   eval      ErrInd = 'N'

     C                   WRITE     SM8010F0

     C                   seton                                        28
     C                   WRITE     SM8010C1

     C                   EXFMT     SM8020F1

      ** End program if F3 is pressed.
     C                   IF        *INKC = *ON
     C                   EXSR      Exit
     C                   ENDIF

     C                   EXSR      CLEAR
     C                   setoff                                       616263
     C                   setoff                                       64

      * If no global is to be migrated, default value to 'N'
     C                   If        %subst(#RELEASE:1:6) =  'Midas '
     C                   eval      #MIGGYN = 'N'
     C                   Endif

      * Global must be Y or N
     C                   If        #MIGGYN <> 'Y'  and #MIGGYN <> 'N'
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM8012'
     C                   EVAL      ErrInd = 'Y'
     C                   seton                                        61
     C                   EXSR      ZASNMS
     C                   Endif

      * Zone must be Y or N
     C                   If        #MIGZYN <> 'Y'  and #MIGZYN <> 'N'
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM8012'
     C                   EVAL      ErrInd = 'Y'
     C                   seton                                        62
     C                   EXSR      ZASNMS
     C                   Endif

      * End copy must be num, range 01-99
     C                   If        #SYSSTG > 0 and #SYSSTG < 100
     C                   else
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM8016'
     C                   EVAL      ErrInd = 'Y'
     C                   seton                                        63
     C                   EXSR      ZASNMS
     C                   Endif

      * Jump must be num, range 1-10
     C                   If        #JUMP > 0 and #JUMP < 11
     C                   else
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM8017'
     C                   EVAL      ErrInd = 'Y'
     C                   seton                                        64
     C                   EXSR      ZASNMS
     C                   Endif

     C                   ENDDO

      * Redisplay screen to confirm
     C                   WRITE     SM8010F0
     C                   seton                                        2128
     C                   WRITE     SM8010C1
     C                   EXFMT     SM8020F1

      ** End program if F3 is pressed.
     C                   IF        *INKC = *ON
     C                   EXSR      Exit
     C                   ENDIF

      ** Update something
     C*exec SQL
     C* update GPSVLXTD set GIVAL = :#BRGLIB
     C*   where GISVAL = 'BrgDeliveredBrgLib'
     C*end-exec
     C*                  If        SQLCODE <> 0
     C*                  eval      DBASE = '001'
     C*                  exsr      *pssr
     C*                  ENDIF

     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_GlobExcp - Exceptions for Global                          *
      *                                                               *
      *****************************************************************
     C     SR_GlobExcp   BEGSR

     C                   setoff                                       21
     C                   eval      ErrInd = 'Y'
     C                   eval      #MIGFRM = #GLOPFX + 'GMLIB'
     C                   eval      #MIGTO  = #GLBPFX + 'GMLIB'

     C                   DOW       *INKC = *OFF
     C                             and ErrInd = 'Y'
     C                   eval      ErrInd = 'N'

     C                   WRITE     SM8010F0

     C                   seton                                        28
     C                   WRITE     SM8010C1

     C                   EXFMT     SM8031F1

      ** End program if F3 is pressed.
     C                   IF        *INKC = *ON
     C                   EXSR      Exit
     C                   ENDIF

     C                   EXSR      CLEAR
      * Set off indicators *IN41 to *IN80
     C                   eval      %Subarr(*IN : 41 : 40) = *OFF

      * Validations
     C                   Exsr      SR_DO20G

     C                   ENDDO

      * Redisplay screen to confirm
     C                   WRITE     SM8010F0
     C                   seton                                        2128
     C                   WRITE     SM8010C1
     C                   EXFMT     SM8031F1

      ** End program if F3 is pressed.
     C                   IF        *INKC = *ON
     C                   EXSR      Exit
     C                   ENDIF

      ** Write SM exceptions
      * replace blank by X *FILE
     C                   exsr      SR_SubstitG
     C/exec SQL
     C+ insert into SMEXCPTD
     C+ (EXOBJ1, EXTYP1, EXOBJ2, EXTYP2, EXOBJ3, EXTYP3, EXOBJ4, EXTYP4,
     C+  EXOBJ5, EXTYP5, EXOBJ6, EXTYP6, EXOBJ7, EXTYP7, EXOBJ8, EXTYP8,
     C+  EXOBJ9, EXTYP9, EXOBJ10, EXTYP10, EXOBJ11, EXTYP11, EXOBJ12, EXTYP12,
     C+  EXOBJ13, EXTYP13, EXOBJ14, EXTYP14, EXOBJ15, EXTYP15, EXOBJ16, EXTYP16,
     C+  EXOBJ17, EXTYP17, EXOBJ18, EXTYP18, EXOBJ19, EXTYP19, EXOBJ20, EXTYP20,
     C+  EXLAYR, EXTHRE, EXJUMP)
     C+  Values
     C+ (:##GOBJ1, :##GTYP1, :##GOBJ2, :##GTYP2, :##GOBJ3, :##GTYP3, :##GOBJ4,
     C+  :##GTYP4, :##GOBJ5, :##GTYP5, :##GOBJ6, :##GTYP6, :##GOBJ7, :##GTYP7,
     C+  :##GOBJ8, :##GTYP8, :##GOBJ9, :##GTYP9, :##GOBJ10,:##GTYP10,:##GOBJ11,
     C+  :##GTYP11, :##GOBJ12, :##GTYP12, :##GOBJ13, :##GTYP13, :##GOBJ14,
     C+  :##GTYP14, :##GOBJ15, :##GTYP15,  :##GOBJ16, :##GTYP16, :##GOBJ17,
     C+  :##GTYP17, :##GOBJ18, :##GTYP18, :##GOBJ19,
     C+  :##GTYP19, :##GOBJ20, :##GTYP20,  '*GLOBAL', :#SYSSTG, :#JUMP)
     C/end-exec
     C                   If        SQLCODE <> 0
     C                   eval      DBASE = '700'
     C                   exsr      *pssr
     C                   ENDIF

     C                   EVAL      Cmd_String = 'CRTPF FILE(' +
     C                             %trimr(#GLOPFX) + 'GMLIB/X) RCDLEN(10)'

     C                   CALL      'QCMDEXC'                            20
     C                   PARM                    Cmd_String
     C                   PARM                    Cmd_Len

     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_ZoneExcp - Exceptions for Zone                            *
      *                                                               *
      *****************************************************************
     C     SR_ZoneExcp   BEGSR

     C                   setoff                                       21
     C                   eval      ErrInd = 'Y'
     C                   eval      #MIZFRM = #ZOOPFX + 'DMLIB'
     C                   eval      #MIZTO  = #ZONPFX + 'DMLIB'

     C                   DOW       *INKC = *OFF
     C                             and ErrInd = 'Y'
     C                   eval      ErrInd = 'N'

     C                   WRITE     SM8010F0

     C                   seton                                        28
     C                   WRITE     SM8010C1

     C                   EXFMT     SM8032F1

      ** End program if F3 is pressed.
     C                   IF        *INKC = *ON
     C                   EXSR      Exit
     C                   ENDIF

     C                   EXSR      CLEAR
      * Set off indicators *IN41 to *IN80
     C                   eval      %Subarr(*IN : 41 : 40) = *OFF

      * Validations
     C                   Exsr      SR_DO20Z

     C                   ENDDO

      * Redisplay screen to confirm
     C                   WRITE     SM8010F0
     C                   seton                                        2128
     C                   WRITE     SM8010C1
     C                   EXFMT     SM8032F1

      ** End program if F3 is pressed.
     C                   IF        *INKC = *ON
     C                   EXSR      Exit
     C                   ENDIF

      ** Write SM exceptions
      * replace blank by X *FILE
     C                   exsr      SR_SubstitZ
     C/exec SQL
     C+ insert into SMEXCPTD
     C+ (EXOBJ1, EXTYP1, EXOBJ2, EXTYP2, EXOBJ3, EXTYP3, EXOBJ4, EXTYP4,
     C+  EXOBJ5, EXTYP5, EXOBJ6, EXTYP6, EXOBJ7, EXTYP7, EXOBJ8, EXTYP8,
     C+  EXOBJ9, EXTYP9, EXOBJ10, EXTYP10, EXOBJ11, EXTYP11, EXOBJ12, EXTYP12,
     C+  EXOBJ13, EXTYP13, EXOBJ14, EXTYP14, EXOBJ15, EXTYP15, EXOBJ16, EXTYP16,
     C+  EXOBJ17, EXTYP17, EXOBJ18, EXTYP18, EXOBJ19, EXTYP19, EXOBJ20, EXTYP20,
     C+  EXLAYR, EXTHRE, EXJUMP)
     C+  Values
     C+ (:##ZOBJ1, :##ZTYP1, :##ZOBJ2, :##ZTYP2, :##ZOBJ3, :##ZTYP3, :##ZOBJ4,
     C+  :##ZTYP4, :##ZOBJ5, :##ZTYP5, :##ZOBJ6, :##ZTYP6, :##ZOBJ7, :##ZTYP7,
     C+  :##ZOBJ8, :##ZTYP8, :##ZOBJ9, :##ZTYP9, :##ZOBJ10,:##ZTYP10,:##ZOBJ11,
     C+  :##ZTYP11, :##ZOBJ12, :##ZTYP12, :##ZOBJ13, :##ZTYP13, :##ZOBJ14,
     C+  :##ZTYP14, :##ZOBJ15, :##ZTYP15,  :##ZOBJ16, :##ZTYP16, :##ZOBJ17,
     C+  :##ZTYP17, :##ZOBJ18, :##ZTYP18, :##ZOBJ19,
     C+  :##ZTYP19, :##ZOBJ20, :##ZTYP20, '*ZONE', :#SYSSTG, :#JUMP)
     C/end-exec
     C                   If        SQLCODE <> 0
     C                   eval      DBASE = '701'
     C                   exsr      *pssr
     C                   ENDIF

     C                   EVAL      Cmd_String = 'CRTPF FILE(' +
     C                             %trimr(#ZOOPFX) + 'DMLIB/X) RCDLEN(10)'

     C                   CALL      'QCMDEXC'                            20
     C                   PARM                    Cmd_String
     C                   PARM                    Cmd_Len

     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Initial processing                                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    Error            10

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
      *  SR_VAlExp - Validate exception objects                       *
      *                                                               *
      *****************************************************************
      *
     C     SR_ValExp     BEGSR

     C                   setoff                                       9899

      * if one is blank
     C                   If        EX_OBJ <> *blanks
     C                             and EX_TYP = *blanks
     C                   seton                                        99
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM8005'
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   leavesr
     C                   ENDIF

     C                   If        EX_OBJ = *blanks
     C                             and EX_TYP <> *blanks
     C                   seton                                        98
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM8010'
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   leavesr
     C                   ENDIF

      * if both non-blank
     C                   If        EX_OBJ <> *blanks
     C                             and EX_TYP <> *blanks

      * type must be *FILE or *DTAQ or *DTAARA
     C                   If        EX_TYP <> '*FILE' and EX_TYP <> '*DTAQ'
     C                             and EX_TYP <> '*DTAARA'
     C                   seton                                        99
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM8005'
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   leavesr
     C                   ENDIF

      * check that object exists
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *BLANK        RTNCOD
     C                   PARM      EX_OBJ        P2OBNM
     C                   PARM      LIBLIB        P2TLIB
     C                   PARM      EX_TYP        P2OBTP
     C                   PARM      *blanks       CHKMBR

      * If libary does not exist in the library list, send message
     C     RTNCOD        IFNE      'Exist'
     C                   seton                                        9899
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM8011'
     C                   MOVEL     *blanks       ZAMSD1           29
     C                   eval      ZAMSD1 = EX_OBJ + EX_TYP +LIBLIB
     C                   MOVEL     ZAMSD1        ZAMSDA
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF
     C
     C                   Endif

     C                   ENDSR

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
      *  SR_DO20Z - Validation                                        *
      *                                                               *
      *****************************************************************
     C     SR_DO20Z      BEGSR

     C                   EVAL      ErrInd = ' '
     C                   EVAL      LIBLIB = LIBDM
      * Validate 20 possible exceptions
     C                   Do        20            Ix
     C                   Select

     C                   when      Ix = 1
     C                   eval      EX_OBJ = ##ZOBJ1
     C                   eval      EX_TYP = ##ZTYP1
     C                   exsr      SR_ValExp
     C   98              seton                                        41
     C   99              seton                                        61

     C                   when      Ix = 2
     C                   eval      EX_OBJ = ##ZOBJ2
     C                   eval      EX_TYP = ##ZTYP2
     C                   exsr      SR_ValExp
     C   98              seton                                        42
     C   99              seton                                        62

     C                   when      Ix = 3
     C                   eval      EX_OBJ = ##ZOBJ3
     C                   eval      EX_TYP = ##ZTYP3
     C                   exsr      SR_ValExp
     C   98              seton                                        43
     C   99              seton                                        63

     C                   when      Ix = 4
     C                   eval      EX_OBJ = ##ZOBJ4
     C                   eval      EX_TYP = ##ZTYP4
     C                   exsr      SR_ValExp
     C   98              seton                                        44
     C   99              seton                                        64

     C                   when      Ix = 5
     C                   eval      EX_OBJ = ##ZOBJ5
     C                   eval      EX_TYP = ##ZTYP5
     C                   exsr      SR_ValExp
     C   98              seton                                        45
     C   99              seton                                        65

     C                   when      Ix = 6
     C                   eval      EX_OBJ = ##ZOBJ6
     C                   eval      EX_TYP = ##ZTYP6
     C                   exsr      SR_ValExp
     C   98              seton                                        46
     C   99              seton                                        66

     C                   when      Ix = 7
     C                   eval      EX_OBJ = ##ZOBJ7
     C                   eval      EX_TYP = ##ZTYP7
     C                   exsr      SR_ValExp
     C   98              seton                                        47
     C   99              seton                                        67

     C                   when      Ix = 8
     C                   eval      EX_OBJ = ##ZOBJ8
     C                   eval      EX_TYP = ##ZTYP8
     C                   exsr      SR_ValExp
     C   98              seton                                        48
     C   99              seton                                        68

     C                   when      Ix = 9
     C                   eval      EX_OBJ = ##ZOBJ9
     C                   eval      EX_TYP = ##ZTYP9
     C                   exsr      SR_ValExp
     C   98              seton                                        49
     C   99              seton                                        69

     C                   when      Ix = 10
     C                   eval      EX_OBJ = ##ZOBJ10
     C                   eval      EX_TYP = ##ZTYP10
     C                   exsr      SR_ValExp
     C   98              seton                                        50
     C   99              seton                                        70

     C                   when      Ix = 11
     C                   eval      EX_OBJ = ##ZOBJ11
     C                   eval      EX_TYP = ##ZTYP11
     C                   exsr      SR_ValExp
     C   98              seton                                        51
     C   99              seton                                        71

     C                   when      Ix = 12
     C                   eval      EX_OBJ = ##ZOBJ12
     C                   eval      EX_TYP = ##ZTYP12
     C                   exsr      SR_ValExp
     C   98              seton                                        52
     C   99              seton                                        72

     C                   when      Ix = 13
     C                   eval      EX_OBJ = ##ZOBJ13
     C                   eval      EX_TYP = ##ZTYP13
     C                   exsr      SR_ValExp
     C   98              seton                                        53
     C   99              seton                                        73

     C                   when      Ix = 14
     C                   eval      EX_OBJ = ##ZOBJ14
     C                   eval      EX_TYP = ##ZTYP14
     C                   exsr      SR_ValExp
     C   98              seton                                        54
     C   99              seton                                        74

     C                   when      Ix = 15
     C                   eval      EX_OBJ = ##ZOBJ15
     C                   eval      EX_TYP = ##ZTYP15
     C                   exsr      SR_ValExp
     C   98              seton                                        55
     C   99              seton                                        75

     C                   when      Ix = 16
     C                   eval      EX_OBJ = ##ZOBJ16
     C                   eval      EX_TYP = ##ZTYP16
     C                   exsr      SR_ValExp
     C   98              seton                                        56
     C   99              seton                                        76

     C                   when      Ix = 17
     C                   eval      EX_OBJ = ##ZOBJ17
     C                   eval      EX_TYP = ##ZTYP17
     C                   exsr      SR_ValExp
     C   98              seton                                        57
     C   99              seton                                        77

     C                   when      Ix = 18
     C                   eval      EX_OBJ = ##ZOBJ18
     C                   eval      EX_TYP = ##ZTYP18
     C                   exsr      SR_ValExp
     C   98              seton                                        58
     C   99              seton                                        78

     C                   when      Ix = 19
     C                   eval      EX_OBJ = ##ZOBJ19
     C                   eval      EX_TYP = ##ZTYP19
     C                   exsr      SR_ValExp
     C   98              seton                                        59
     C   99              seton                                        79

     C                   when      Ix = 20
     C                   eval      EX_OBJ = ##ZOBJ20
     C                   eval      EX_TYP = ##ZTYP20
     C                   exsr      SR_ValExp
     C   98              seton                                        60
     C   99              seton                                        80

     C                   ENDSL
     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_DO20G - Validation                                        *
      *                                                               *
      *****************************************************************
     C     SR_DO20G      BEGSR

     C                   EVAL      ErrInd = ' '
     C                   EVAL      LIBLIB = LIBGM
      * Validate 20 possible exceptions
     C                   Do        20            Ix
     C                   Select

     C                   when      Ix = 1
     C                   eval      EX_OBJ = ##GOBJ1
     C                   eval      EX_TYP = ##GTYP1
     C                   exsr      SR_ValExp
     C   98              seton                                        41
     C   99              seton                                        61

     C                   when      Ix = 2
     C                   eval      EX_OBJ = ##GOBJ2
     C                   eval      EX_TYP = ##GTYP2
     C                   exsr      SR_ValExp
     C   98              seton                                        42
     C   99              seton                                        62

     C                   when      Ix = 3
     C                   eval      EX_OBJ = ##GOBJ3
     C                   eval      EX_TYP = ##GTYP3
     C                   exsr      SR_ValExp
     C   98              seton                                        43
     C   99              seton                                        63

     C                   when      Ix = 4
     C                   eval      EX_OBJ = ##GOBJ4
     C                   eval      EX_TYP = ##GTYP4
     C                   exsr      SR_ValExp
     C   98              seton                                        44
     C   99              seton                                        64

     C                   when      Ix = 5
     C                   eval      EX_OBJ = ##GOBJ5
     C                   eval      EX_TYP = ##GTYP5
     C                   exsr      SR_ValExp
     C   98              seton                                        45
     C   99              seton                                        65

     C                   when      Ix = 6
     C                   eval      EX_OBJ = ##GOBJ6
     C                   eval      EX_TYP = ##GTYP6
     C                   exsr      SR_ValExp
     C   98              seton                                        46
     C   99              seton                                        66

     C                   when      Ix = 7
     C                   eval      EX_OBJ = ##GOBJ7
     C                   eval      EX_TYP = ##GTYP7
     C                   exsr      SR_ValExp
     C   98              seton                                        47
     C   99              seton                                        67

     C                   when      Ix = 8
     C                   eval      EX_OBJ = ##GOBJ8
     C                   eval      EX_TYP = ##GTYP8
     C                   exsr      SR_ValExp
     C   98              seton                                        48
     C   99              seton                                        68

     C                   when      Ix = 9
     C                   eval      EX_OBJ = ##GOBJ9
     C                   eval      EX_TYP = ##GTYP9
     C                   exsr      SR_ValExp
     C   98              seton                                        49
     C   99              seton                                        69

     C                   when      Ix = 10
     C                   eval      EX_OBJ = ##GOBJ10
     C                   eval      EX_TYP = ##GTYP10
     C                   exsr      SR_ValExp
     C   98              seton                                        50
     C   99              seton                                        70

     C                   when      Ix = 11
     C                   eval      EX_OBJ = ##GOBJ11
     C                   eval      EX_TYP = ##GTYP11
     C                   exsr      SR_ValExp
     C   98              seton                                        51
     C   99              seton                                        71

     C                   when      Ix = 12
     C                   eval      EX_OBJ = ##GOBJ12
     C                   eval      EX_TYP = ##GTYP12
     C                   exsr      SR_ValExp
     C   98              seton                                        52
     C   99              seton                                        72

     C                   when      Ix = 13
     C                   eval      EX_OBJ = ##GOBJ13
     C                   eval      EX_TYP = ##GTYP13
     C                   exsr      SR_ValExp
     C   98              seton                                        53
     C   99              seton                                        73

     C                   when      Ix = 14
     C                   eval      EX_OBJ = ##GOBJ14
     C                   eval      EX_TYP = ##GTYP14
     C                   exsr      SR_ValExp
     C   98              seton                                        54
     C   99              seton                                        74

     C                   when      Ix = 15
     C                   eval      EX_OBJ = ##GOBJ15
     C                   eval      EX_TYP = ##GTYP15
     C                   exsr      SR_ValExp
     C   98              seton                                        55
     C   99              seton                                        75

     C                   when      Ix = 16
     C                   eval      EX_OBJ = ##GOBJ16
     C                   eval      EX_TYP = ##GTYP16
     C                   exsr      SR_ValExp
     C   98              seton                                        56
     C   99              seton                                        76

     C                   when      Ix = 17
     C                   eval      EX_OBJ = ##GOBJ17
     C                   eval      EX_TYP = ##GTYP17
     C                   exsr      SR_ValExp
     C   98              seton                                        57
     C   99              seton                                        77

     C                   when      Ix = 18
     C                   eval      EX_OBJ = ##GOBJ18
     C                   eval      EX_TYP = ##GTYP18
     C                   exsr      SR_ValExp
     C   98              seton                                        58
     C   99              seton                                        78

     C                   when      Ix = 19
     C                   eval      EX_OBJ = ##GOBJ19
     C                   eval      EX_TYP = ##GTYP19
     C                   exsr      SR_ValExp
     C   98              seton                                        59
     C   99              seton                                        79

     C                   when      Ix = 20
     C                   eval      EX_OBJ = ##GOBJ20
     C                   eval      EX_TYP = ##GTYP20
     C                   exsr      SR_ValExp
     C   98              seton                                        60
     C   99              seton                                        80

     C                   ENDSL
     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_Substit - Substitute blank value                          *
      *                                                               *
      *****************************************************************
     C     SR_SubstitG   BEGSR

     C                   If        ##GOBJ1 = *blanks
     C                   eval      ##GOBJ1 = 'X'
     C                   eval      ##GTYP1 = '*FILE'
     C                   ENDIF

     C                   If        ##GOBJ2 = *blanks
     C                   eval      ##GOBJ2 = 'X'
     C                   eval      ##GTYP2 = '*FILE'
     C                   ENDIF

     C                   If        ##GOBJ3 = *blanks
     C                   eval      ##GOBJ3 = 'X'
     C                   eval      ##GTYP3 = '*FILE'
     C                   ENDIF

     C                   If        ##GOBJ4 = *blanks
     C                   eval      ##GOBJ4 = 'X'
     C                   eval      ##GTYP4 = '*FILE'
     C                   ENDIF

     C                   If        ##GOBJ5 = *blanks
     C                   eval      ##GOBJ5 = 'X'
     C                   eval      ##GTYP5 = '*FILE'
     C                   ENDIF

     C                   If        ##GOBJ6 = *blanks
     C                   eval      ##GOBJ6 = 'X'
     C                   eval      ##GTYP6 = '*FILE'
     C                   ENDIF

     C                   If        ##GOBJ7 = *blanks
     C                   eval      ##GOBJ7 = 'X'
     C                   eval      ##GTYP7 = '*FILE'
     C                   ENDIF

     C                   If        ##GOBJ8 = *blanks
     C                   eval      ##GOBJ8 = 'X'
     C                   eval      ##GTYP8 = '*FILE'
     C                   ENDIF

     C                   If        ##GOBJ9 = *blanks
     C                   eval      ##GOBJ9 = 'X'
     C                   eval      ##GTYP9 = '*FILE'
     C                   ENDIF

     C                   If        ##GOBJ10 = *blanks
     C                   eval      ##GOBJ10 = 'X'
     C                   eval      ##GTYP10 = '*FILE'
     C                   ENDIF

     C                   If        ##GOBJ11 = *blanks
     C                   eval      ##GOBJ11 = 'X'
     C                   eval      ##GTYP11 = '*FILE'
     C                   ENDIF

     C                   If        ##GOBJ12 = *blanks
     C                   eval      ##GOBJ12 = 'X'
     C                   eval      ##GTYP12 = '*FILE'
     C                   ENDIF

     C                   If        ##GOBJ13 = *blanks
     C                   eval      ##GOBJ13 = 'X'
     C                   eval      ##GTYP13 = '*FILE'
     C                   ENDIF

     C                   If        ##GOBJ14 = *blanks
     C                   eval      ##GOBJ14 = 'X'
     C                   eval      ##GTYP14 = '*FILE'
     C                   ENDIF

     C                   If        ##GOBJ15 = *blanks
     C                   eval      ##GOBJ15 = 'X'
     C                   eval      ##GTYP15 = '*FILE'
     C                   ENDIF

     C                   If        ##GOBJ16 = *blanks
     C                   eval      ##GOBJ16 = 'X'
     C                   eval      ##GTYP16 = '*FILE'
     C                   ENDIF

     C                   If        ##GOBJ17 = *blanks
     C                   eval      ##GOBJ17 = 'X'
     C                   eval      ##GTYP17 = '*FILE'
     C                   ENDIF

     C                   If        ##GOBJ18 = *blanks
     C                   eval      ##GOBJ18 = 'X'
     C                   eval      ##GTYP18 = '*FILE'
     C                   ENDIF

     C                   If        ##GOBJ19 = *blanks
     C                   eval      ##GOBJ19 = 'X'
     C                   eval      ##GTYP19 = '*FILE'
     C                   ENDIF

     C                   If        ##GOBJ20 = *blanks
     C                   eval      ##GOBJ20 = 'X'
     C                   eval      ##GTYP20 = '*FILE'
     C                   ENDIF


     C                   ENDSR
      *****************************************************************
      *****************************************************************
     C     SR_SubstitZ   BEGSR

     C                   If        ##ZOBJ1 = *blanks
     C                   eval      ##ZOBJ1 = 'X'
     C                   eval      ##ZTYP1 = '*FILE'
     C                   ENDIF

     C                   If        ##ZOBJ2 = *blanks
     C                   eval      ##ZOBJ2 = 'X'
     C                   eval      ##ZTYP2 = '*FILE'
     C                   ENDIF

     C                   If        ##ZOBJ3 = *blanks
     C                   eval      ##ZOBJ3 = 'X'
     C                   eval      ##ZTYP3 = '*FILE'
     C                   ENDIF

     C                   If        ##ZOBJ4 = *blanks
     C                   eval      ##ZOBJ4 = 'X'
     C                   eval      ##ZTYP4 = '*FILE'
     C                   ENDIF

     C                   If        ##ZOBJ5 = *blanks
     C                   eval      ##ZOBJ5 = 'X'
     C                   eval      ##ZTYP5 = '*FILE'
     C                   ENDIF

     C                   If        ##ZOBJ6 = *blanks
     C                   eval      ##ZOBJ6 = 'X'
     C                   eval      ##ZTYP6 = '*FILE'
     C                   ENDIF

     C                   If        ##ZOBJ7 = *blanks
     C                   eval      ##ZOBJ7 = 'X'
     C                   eval      ##ZTYP7 = '*FILE'
     C                   ENDIF

     C                   If        ##ZOBJ8 = *blanks
     C                   eval      ##ZOBJ8 = 'X'
     C                   eval      ##ZTYP8 = '*FILE'
     C                   ENDIF

     C                   If        ##ZOBJ9 = *blanks
     C                   eval      ##ZOBJ9 = 'X'
     C                   eval      ##ZTYP9 = '*FILE'
     C                   ENDIF

     C                   If        ##ZOBJ10 = *blanks
     C                   eval      ##ZOBJ10 = 'X'
     C                   eval      ##ZTYP10 = '*FILE'
     C                   ENDIF

     C                   If        ##ZOBJ11 = *blanks
     C                   eval      ##ZOBJ11 = 'X'
     C                   eval      ##ZTYP11 = '*FILE'
     C                   ENDIF

     C                   If        ##ZOBJ12 = *blanks
     C                   eval      ##ZOBJ12 = 'X'
     C                   eval      ##ZTYP12 = '*FILE'
     C                   ENDIF

     C                   If        ##ZOBJ13 = *blanks
     C                   eval      ##ZOBJ13 = 'X'
     C                   eval      ##ZTYP13 = '*FILE'
     C                   ENDIF

     C                   If        ##ZOBJ14 = *blanks
     C                   eval      ##ZOBJ14 = 'X'
     C                   eval      ##ZTYP14 = '*FILE'
     C                   ENDIF

     C                   If        ##ZOBJ15 = *blanks
     C                   eval      ##ZOBJ15 = 'X'
     C                   eval      ##ZTYP15 = '*FILE'
     C                   ENDIF

     C                   If        ##ZOBJ16 = *blanks
     C                   eval      ##ZOBJ16 = 'X'
     C                   eval      ##ZTYP16 = '*FILE'
     C                   ENDIF

     C                   If        ##ZOBJ17 = *blanks
     C                   eval      ##ZOBJ17 = 'X'
     C                   eval      ##ZTYP17 = '*FILE'
     C                   ENDIF

     C                   If        ##ZOBJ18 = *blanks
     C                   eval      ##ZOBJ18 = 'X'
     C                   eval      ##ZTYP18 = '*FILE'
     C                   ENDIF

     C                   If        ##ZOBJ20 = *blanks
     C                   eval      ##ZOBJ20 = 'X'
     C                   eval      ##ZTYP20 = '*FILE'
     C                   ENDIF

     C                   If        ##ZOBJ19 = *blanks
     C                   eval      ##ZOBJ19 = 'X'
     C                   eval      ##ZTYP19 = '*FILE'
     C                   ENDIF


     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_NewZone - Initialize new Zone                             *
      *                                                               *
      *****************************************************************
     C     SR_NewZone    BEGSR

     C                   setoff                                       21
     C                   eval      ErrInd = 'Y'

     C                   DOW       *INKC = *OFF
     C                             and ErrInd = 'Y'
     C                   eval      ErrInd = 'N'

     C                   EVAL      Cmd_String = '?INZNEWZON2'
     C                   CALL      'QCMDEXC'                            20
     C                   PARM                    Cmd_String
     C                   PARM                    Cmd_Len

      ** if error
     C                   If        *IN20 = *ON
     C                   eval      DBASE = '105'
     C                   eval      ErrInd = 'Y'
     C                   Endif

      ** End program if F3 is pressed.
     C                   IF        *INKC = *ON
     C                   EXSR      Exit
     C                   ENDIF

     C                   ENDDO


     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_UsrMig - Users migration                                  *
      *                                                               *
      *****************************************************************
     C     SR_UsrMig     BEGSR

     C                   setoff                                       21
     C                   eval      ErrInd = 'Y'

     C                   DOW       *INKC = *OFF
     C                             and ErrInd = 'Y'
     C                   eval      ErrInd = 'N'

     C                   CALL      'SMC008070'                          20
     C                   PARM                    #ZONPFX
     C                   PARM                    #ZOOPFX
     C                   PARM                    Error

      ** if error
     C                   If        *IN20 = *ON or Error <> *blanks
     C                   eval      ErrInd = 'Y'
     C                   Endif

      ** End program if F3 is pressed.
     C                   IF        *INKC = *ON
     C                   EXSR      Exit
     C                   ENDIF

     C                   ENDDO


     C                   ENDSR

      *****************************************************************
