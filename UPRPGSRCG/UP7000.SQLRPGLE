     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2022')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP OTR select layer for refresh')                *
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP7000 - Midas UP OTR select layer for refresh               *
      *                                                               *
      *  Function: This program allows layer to be selected as well   *
      *            as prefix for the library used for the refresh to  *
      *            be specified.                                      *
      *                                                               *
      *  (c) Finastra International Limited 2022                      *
      *                                                               *
      *  Last Amend No. MD061580           Date 12Jul23               *
      *  Prev Amend No. CUP045 *CREATE     Date 09Dec22               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD060580 - Strange characters appear in OTRM (One Touch      *
      *             Bridge - Refresh Monitor). (Recompile)            *
      *  CUP045 - One Touch Bridge - refresh                          *
      *         - Applied for MD060769.                               *
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
     FUP7000GF  CF   E             WORKSTN


      ** Declared Variables
     D ErrInd          S             10A
     D LibName         S             10A
     D GPFX            S              2A
     D ZONE            S              2A
     D L_DESC          S             35A
     D SysVal          S             20A
     D SysVal2         S             20A
     D vPRFX           S              2A
     D vPFX1           S              2A
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


     C                   eval      SysVal = 'BrgMidasGlobalPrefix'
     C                   eval      SysVal2 = 'BrgMidasSystemPrefix'
      ** Load global prefix too
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRetCode          7
     C                   PARM      SysVal        P@OP01           20
     C                   PARM      *BLANKS       P@VL01          200
     C                   PARM      SysVal2       P@OP02           20
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
     C                   eval      ZONE = %subst(P@VL02:1:2)


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
     C                   eval      vPFX1 = ZONE
     C                   ENDIF

     C                   seton                                        28
     C                   WRITE     UP7000F0
     C                   WRITE     UP7000C1
     C                   EXFMT     UP7000F1

     C                   IF        *INKC = *OFF

     C                   IF        XSELG <> *blanks
     C                   eval      Prefix = GPFX
     C                   eval      Layer  = '*GLOBAL'
     C/exec SQL
     C+ update GPSVLXTD set GIVAL = :XLIBP
     C+   where GISVAL = 'BrgOldGlobalPrefix'
     C/end-exec
     C                   If        SQLCODE <> 0
     C                   exsr      *pssr
     C                   ENDIF
     C                   ENDIF

     C                   IF        XSELZ1 <> *blanks
     C                   eval      Prefix = ZONE
     C                   eval      Layer  = '*ZONE  '
     C/exec SQL
     C+ update SDSVLXTD set GIVAL = :XLIBP
     C+   where GISVAL = 'BrgOldZonePrefix'
     C/end-exec
     C                   If        SQLCODE <> 0
     C                   exsr      *pssr
     C                   ENDIF
     C                   ENDIF
     C
     C                   Else
     C                   Exsr      Exit
     C                   Endif


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


     C                   eval      XNARG = GPFX + ' - *GLOBAL layer'
     C                   seton                                        40

      * If *ZONE, retrieve zone name
     C/exec SQL
     C+ select ZODESC into :L_DESC
     C+ from GPZONEPD where ZOMSYS = :ZONE
     C/end-exec
     C                   eval      XNARZ1 = ZONE + ' - ' + L_DESC
     C                   seton                                        41

     C                   WRITE     UP7000F0

     C                   EXFMT     UP7000F1

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
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM7000'
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF

      * and only one layer has to be selected
     C                   If        XSELG <> *blanks and XSELZ1 <> *blanks
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM7002'
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF

      * and prefix library cannot be blanks
     C                   If        XLIBP = *blanks
     C                   seton                                        32
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM7003'
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF

      * and prefix entered cannot be the same as GLobal of Prefix
     C                   If        (XLIBP = ZONE and ZONE <> *blanks)
     C                             or (XLIBP = GPFX and GPFX <> *blanks)
     C                   seton                                        32
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM7005'
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF

      * and check that corresponding library exist
     C                   If        XLIBP <> *blanks
     C                             and (XSELG <> *blanks or XSELZ1 <> *blanks)

     C                   If        XSELG <> *blanks
     C                   eval      LibName = XLIBP  + 'GMLIB'
     C                   else
     C                   eval      LibName = XLIBP   + 'DMLIB'
     C                   ENDIF

     C                   CALL      'UTCHKOBJ'
     C                   PARM      *BLANK        RTNCOD           10
     C                   PARM      LibName       P2OBNM           10
     C                   PARM      '*LIBL'       P2TLIB           10
     C                   PARM      '*LIB'        P2OBTP            8
     C                   PARM      *blanks       CHKMBR           10
      *
      * If libary does not exist in the library list, send message
     C     RTNCOD        IFNE      'Exist'
     C                   seton                                        32
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM7004'
     C                   EVAL      ZAMSDA = LibName
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF

     C                   ENDIF

     C                   DOW       *INKC = *OFF
     C                             and ErrInd = 'Y'
     C                   WRITE     UP7000F0

     C                   seton                                        28
     C                   WRITE     UP7000C1

     C                   EXFMT     UP7000F1

     C                   EXSR      CLEAR
     C                   EVAL      ErrInd = 'N'
      * At least on layer has to be selected
     C                   If        XSELG = *blanks and XSELZ1 = *blanks
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM7000'
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF

      * and only one layer has to be selected
     C                   If        XSELG <> *blanks and XSELZ1 <> *blanks
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM7002'
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF

     C                   setoff                                       32
      * and prefix entered cannot be the same as GLobal of Prefix
     C                   If        (XLIBP = ZONE and ZONE <> *blanks)
     C                             or (XLIBP = GPFX and GPFX <> *blanks)
     C                   seton                                        32
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM7005'
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF

      * and prefix library cannot be blanks
     C                   If        XLIBP = *blanks
     C                   seton                                        32
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM7003'
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF

      * and check that corresponding library exist
     C                   If        XLIBP <> *blanks
     C                             and (XSELG <> *blanks or XSELZ1 <> *blanks)

     C                   If        XSELG <> *blanks
     C                   eval      LibName = XLIBP + 'GMLIB'
     C                   else
     C                   eval      LibName = XLIBP + 'DMLIB'
     C                   ENDIF

     C                   CALL      'UTCHKOBJ'
     C                   PARM      *BLANK        RTNCOD           10
     C                   PARM      LibName       P2OBNM           10
     C                   PARM      '*LIBL'       P2TLIB           10
     C                   PARM      '*LIB'        P2OBTP            8
     C                   PARM      *blanks       CHKMBR           10
      *
      * If libary does not exist in the library list, send message
     C     RTNCOD        IFNE      'Exist'
     C                   seton                                        32
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'UPM7004'
     C                   EVAL      ZAMSDA = LibName
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF

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
     C                   PARM                    Prefix            2
     C                   PARM                    Layer             7
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
