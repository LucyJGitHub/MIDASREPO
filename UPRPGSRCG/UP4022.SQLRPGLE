     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2020')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP Midas UP ADBU System Value Substitute')
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP4022 - Midas UP ADBU System Value Substitute               *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. MD061992           Date 23Oct23               *
      *  Prev Amend No. CUT017 *CREATE     Date 17Mar20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD061992 - Allow 3 char prefix for reference libraries       *
      *  CUT017 - Adaptive Database Upgrade                           *
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
     FUP4022GF  CF   E             WORKSTN

      ** Program data structure
     D*MyPSDS         SDS
     D*DFPGMQ                  1     10
     D*DFJOBN                244    253
     D*DFDUSR                254    263
     D*DFJBNO                264    269S 0
     D*DFJBNC                264    269

      ** Declared Variables
     D @LIB            S             10A
     D @MisLiG         S              1A
     D @MisLiZ         S              1A
     D Empty           S              1A
     D SysVal          S             20A
     D Idx             S              5  0
     D ExistYN         S             10A
     D Library         S             10A
     D RefLib          S             10A
     D ObjectType      S              7A
     D Member          S             10A
     D sqlStat         S           5000A
     D DFSRCHAL        S             40A
     D ZoneArr         S              2    DIM(999)
     D DepF            S             10
     D S_DepF          S             10
     D Ix              S              5  0
     D Cnt             S              5  0
     D pos             S              5  0
     D SavInKK         S              1
     D RcdCount        S              5  0
      ** ZASNMS Variables
     D ZAPGMQ          S             10
     D ZAPGRL          S              5
     D ZAMSID          S              7
     D ZAMSGF          S             10
     D ZAMSDA          S            132
     D ZAMSTP          S              7
      ** Error Indicators
     D ErIOff          S             15
     D ErrInd          S              1
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

     D Command         S             70
     D CommandLen      S             15  5 INZ(70)

     D UPADBU        E DS                  EXTNAME(UPADBUTD)
     D ZONE          E DS                  EXTNAME(GPZONEPD)

     D/COPY ZACPYSRC,PSDS
       /EJECT
      *****************************************************************

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
     C                   eval      Idx = Idx + 1
     C                   eval      ZoneArr(Idx) = ZOMSYS
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

     C                   eval      Idx = Idx + 1
     C                   eval      ZoneArr(Idx) = %subst(P@VL01:1:2)

      ** Load prefixes if found
     C/EXEC SQL
     C+ SELECT *
     C+ into :UPADBU
     C+ from UPADBUTD
     C/END-EXEC

     C                   eval      Empty = 'Y'
     C                   If        SQLCODE = 0
     C                   eval      G_REF = GPRFX
     C                   eval      Z_REF = ZPRFX
     C                   eval      Empty = 'N'
     C                   ENDIF
      ** Main process.
     C                   DOW       *INKC = *OFF

      ** Process first screen.
     C                   EXSR      LoadScreen

      ** End program if F3 is pressed.
     C                   IF        *INKC = *ON
     C                   EXSR      Exit
     C                   ENDIF

     C                   ENDDO

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

     C                   eval      DFJOBN = PSJobName
     C                   eval      DFDUSR = PSUser

      * If Mode is Protected
     C                   If        Mode = 'P'
     C                   seton                                        20
     C                   ENDIF

     C                   EXFMT     UP4022F0
      *
      *
      ** Validation For Core records.
     C                   IF        *INKC = *OFF
     C                   EXSR      ValidateFlds

     C                   IF        *IN99 = *OFF
     C                   IF        Empty = 'Y'
     C/exec SQL
     C+ insert into UPADBUTD
     C+ ( GPRFX, ZPRFX )
     C+ values
     C+ ( :G_REF, :Z_REF )
     C/end-exec
     C                   Else
     C/exec SQL
     C+ update UPADBUTD set
     C+ GPRFX = :G_REF, ZPRFX = :Z_REF
     C/end-exec
     C                   Endif

     C                   IF        SQLCODE <> 0
     C                   EVAL      ERROR = '*Error'
     C                   Else
     C                   eval      GPFX = G_REF
     C                   eval      ZPFX = Z_REF
     C                   exsr      Exit
     C                   ENDIF
     C                   ENDIF

      * If F3 pressed, return
     C                   else
     C                   eval      Error = '*Return'
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

     C                   eval      @MisLiG = ' '
     C                   eval      @MisLiZ = ' '
     C                   setoff                                       353699
     C                   eval      ERR_L1 = ' '
     C                   eval      ERR_L2 = ' '
     C                   eval      ERR_L3 = ' '
     C                   eval      ERR_L4 = ' '

      * Both prefixes must be different
     C                   IF        G_REF = Z_REF
     C                             and G_REF <> *blanks
     C                   seton                                        353699
     C                   eval      ERR_L1 = 'Both prefixes must be different'
     C                   goto      EndVal
     C                   ENDIF

      * Prefix cannot be blank
     C                   IF        G_REF = ' '
     C                   seton                                        3599
     C                   eval      ERR_L1 = 'Prefix cannot be blank'
     C                   Else
      **Prefix*cannot be existing prefix                                                    MD061992
      * This can be removed now as reference system is 3 characters                         MD061992
     C**********         EVAL      Idx = 1                                                  MD061992
     C*****G_REF         LOOKUP    ZoneArr(Idx)                           40                MD061992
     C**********         IF        *IN40 = *ON                                              MD061992
     C**********         seton                                        3599                  MD061992
     C**********         eval      ERR_L1 = 'Prefix is used for an existing' +              MD061992
     C**********                   ' layer'                                                 MD061992
     C**********         goto      EndVal                                                   MD061992
     C**********         ENDIF                                                              MD061992
      * Check global libraires exist
     C                   eval      @LIB = G_REF + 'GMLIB'
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *blanks       ExistYN          10
     C                   PARM      @LIB          OBJ              10
     C                   PARM      '*LIBL'       Library          10
     C                   PARM      '*LIB'        ObjectType
     C                   PARM      *blanks       Member           10
     C                   IF        ExistYN <> 'Exist     '
     C                   eval      @MisLiG = 'X'
     C                   seton                                        3599
     C                   endif

     C                   eval      @LIB = G_REF + 'GPLIB'
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *blanks       ExistYN          10
     C                   PARM      @LIB          OBJ              10
     C                   PARM      '*LIBL'       Library          10
     C                   PARM      '*LIB'        ObjectType
     C                   PARM      *blanks       Member           10
     C                   IF        ExistYN <> 'Exist     '
     C                   eval      @MisLiG = 'X'
     C                   seton                                        3599
     C                   endif

     C                   eval      @LIB = G_REF + 'GVLIB'
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *blanks       ExistYN          10
     C                   PARM      @LIB          OBJ              10
     C                   PARM      '*LIBL'       Library          10
     C                   PARM      '*LIB'        ObjectType
     C                   PARM      *blanks       Member           10
     C                   IF        ExistYN <> 'Exist     '
     C                   eval      @MisLiG = 'X'
     C                   seton                                        3599
     C                   endif

     C                   eval      @LIB = G_REF + 'GTALIB'
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *blanks       ExistYN          10
     C                   PARM      @LIB          OBJ              10
     C                   PARM      '*LIBL'       Library          10
     C                   PARM      '*LIB'        ObjectType
     C                   PARM      *blanks       Member           10
     C                   IF        ExistYN <> 'Exist     '
     C                   eval      @MisLiG = 'X'
     C                   seton                                        3599
     C                   endif

     C                   IF        @MisLiG = 'X'
     C                   eval      ERR_L1 = 'At least one of these Global l' +
     C                             'ibraries does not exists: ' +  G_Ref +
     C                             'GMLIB, ' + G_Ref + 'GPLIB, '
     C                   eval      ERR_L2 = G_Ref + 'GTALIB, ' + G_Ref + 'GVLIB'
     C                   ENDIF

     C                   ENDIF

     C                   IF        Z_REF = ' '
     C                   seton                                        3699
     C                   eval      ERR_L3 = 'Prefix cannot be blank'
     C                   Else
      **Prefix*cannot be existing prefix                                                    MD061992
      * This can be removed now as reference system is 3 characters                         MD061992
     C**********         EVAL      Idx = 1                                                  MD061992
     C*****Z_REF         LOOKUP    ZoneArr(Idx)                           40                MD061992
     C**********         IF        *IN40 = *ON                                              MD061992
     C**********         seton                                        3699                  MD061992
     C**********         eval      ERR_L1 = 'Prefix is used for an existing' +              MD061992
     C**********                   ' layer'                                                 MD061992
     C**********         goto      EndVal                                                   MD061992
     C**********         ENDIF                                                              MD061992
      * Check zone libraires exist
     C                   eval      @LIB = Z_REF + 'DMLIB'
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *blanks       ExistYN          10
     C                   PARM      @LIB          OBJ              10
     C                   PARM      '*LIBL'       Library          10
     C                   PARM      '*LIB'        ObjectType
     C                   PARM      *blanks       Member           10
     C                   IF        ExistYN <> 'Exist     '
     C                   eval      @MisLiZ = 'X'
     C                   seton                                        3699
     C                   endif

     C                   eval      @LIB = Z_REF + 'DPLIB'
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *blanks       ExistYN          10
     C                   PARM      @LIB          OBJ              10
     C                   PARM      '*LIBL'       Library          10
     C                   PARM      '*LIB'        ObjectType
     C                   PARM      *blanks       Member           10
     C                   IF        ExistYN <> 'Exist     '
     C                   eval      @MisLiZ = 'X'
     C                   seton                                        3699
     C                   endif

     C                   eval      @LIB = Z_REF + 'DVLIB'
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *blanks       ExistYN          10
     C                   PARM      @LIB          OBJ              10
     C                   PARM      '*LIBL'       Library          10
     C                   PARM      '*LIB'        ObjectType
     C                   PARM      *blanks       Member           10
     C                   IF        ExistYN <> 'Exist     '
     C                   eval      @MisLiZ = 'X'
     C                   seton                                        3699
     C                   endif

     C                   eval      @LIB = Z_REF + 'DTALIB'
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *blanks       ExistYN          10
     C                   PARM      @LIB          OBJ              10
     C                   PARM      '*LIBL'       Library          10
     C                   PARM      '*LIB'        ObjectType
     C                   PARM      *blanks       Member           10
     C                   IF        ExistYN <> 'Exist     '
     C                   eval      @MisLiZ = 'X'
     C                   seton                                        3699
     C                   endif

     C                   IF        @MisLiZ = 'X'
     C                   If        ERR_L1 = *blanks
     C                   eval      ERR_L1 = 'At least one of these Zone l' +
     C                             'ibraries does not exists: ' +  Z_Ref +
     C                             'DMLIB, ' + Z_Ref + 'DPLIB, '
     C                   eval      ERR_L2 = Z_Ref + 'DTALIB, ' + Z_Ref + 'DVLIB'
     C                   else
     C                   eval      ERR_L3 = 'At least one of these Zone l' +
     C                             'ibraries does not exists: ' +  Z_Ref +
     C                             'DMLIB, ' + Z_Ref + 'DPLIB, '
     C                   eval      ERR_L4 = Z_Ref + 'DTALIB, ' + Z_Ref + 'DVLIB'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF


     C     EndVal        ENDSR
      *
      *****************************************************************
      *                                                               *
      *  *INZSR - Initial processing                                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C**********         PARM                    GPFX              2                        MD061992
     C                   PARM                    GPFX              3                        MD061992
     C**********         PARM                    ZPFX              2                        MD061992
     C                   PARM                    ZPFX              3                        MD061992
     C                   PARM                    Mode              1
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

     C     INZSRE        ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  Exit - Exit program                                          *
      *                                                               *
      *****************************************************************
     C     Exit          BEGSR
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C     ExitE         ENDSR
      *
      /EJECT
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
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
