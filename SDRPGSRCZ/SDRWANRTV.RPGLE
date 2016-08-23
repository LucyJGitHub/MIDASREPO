     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2007')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Customer Risk Weighted Assets Details Retrieve')       *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDRWANRTV - Customer Risk Weighted Assets Details RETRIEVE   *
      *              (WITH ACTION CODE VERSUS Customer Number         *
      *               VALIDATION)                                     *
      *                                                               *
      *  Function:  This module retrieves a Customer Risk Weighted    *
      *             Assets from the database. As it does, it          *
      *             validates the action code and customer number.    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2007            *
      *                                                               *
      *  Last Amend No. MD039287           Date 09Jun16               *
      *  Prev Amend No. MD025006           Date 19Aug14               *
      *                 MD022997           Date 24Apr14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 260292             Date 18May09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG14009           Date 22Jun07               *
      *                 CSD079  *CREATE    Date 05Feb07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD039287 - Customer number is not automatically generated    *
      *             when CSD021 is on                                 *
      *  MD025006 - Incorrect error message displayed when amending   *
      *             an already deleted customer                       *
      *  MD022997 - Customer being filtered was not displayed on the  *
      *             main list view of CUSD maintenance                *
      *  260292 - Create new system values to check the branch/user   *
      *           authority.                                          *
      *  BUG14009 - To Implement Close and Release Functionality in   *
      *             Customer API                                      *
      *  CSD079 - Enhanced Customer Maintenance API                   *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Midas SD Customer RWA Master file Retrieve
     FSDCRWAL1  IF   E           K DISK    INFSR(*PSSR)

      ** Midas SD Customer Extra Details Retrieval
     FSDCUSTL1  IF   E           K DISK    INFSR(*PSSR)

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **------------------------------------------------------------------

      **------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **------------------------------------------------------------------

      **------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **------------------------------------------------------------------

      **------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **------------------------------------------------------------------

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** Depot shortnames array
     D DepotSn         S             10    DIM(10)

      ** Depot customer numbers array
     D DepotNo         S              6    DIM(10)

      ** RWA Cod_Arr
     D Cod_Arr         S              2    DIM(36)

      ** RWA Set_Arr
     D Set_Arr         S              1    DIM(36)

      ** External DS for bank details ICD retrieval
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** External DS for API ICD
     D SDAPI         E DS                  EXTNAME(SDAPIPD)

      ** External DS for Securities ICD Details
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)

      ** External DS for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)

      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** Transaction Details in File Format
     D TranFilFmt    E DS                  EXTNAME(SDVRWANPD)

     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                MD039287

     D RUNDAT          DS
     D  @MBIN                 13     13

     D ZMUSER          DS
     D  DBRN                  11     13
     D  BANK                  17     17

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Index for arrays of of error message ids etc
     D Ix              S              3P 0

     D Ctr             S              3P 0

     D ZACTN           S              1A
     D ERR             S              1P 0
     D ZBR             S              3A

      ** Entry Parameters
     D ModeofOp        S              6A
     D RespMode        S              1A
     D DDACTN          S              1A
     D DDCUST          S              6A
     D From_Cust       S              1A
     D OKACTN          S              1A
     D OKCUST          S              1A
      *                                                                                       260292
      ** Constant paramater for AOSVALR0                                                      260292
      *                                                                                       260292
     D BRCUSR          C                   CONST('CheckBrchUserAuthori')                      260292
     D CurSysVal       DS           200                                                       260292
     D CurVal                  1      1                                                       260292
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      **************************************************************

      ** Initialisation

     C                   EXSR      INIT

      ** If the mode is 'Front Office Transaction Interface'
      ** Do (Extra) Validation for Front Office Transaction Interface

     C                   IF        ModeofOp = '*FRONT'
     C                   EXSR      VFRNT

      ** Carry out no further validation if errors have occurred

     C                   IF        OKACTN = 'N'
     C                   RETURN
     C                   ENDIF
     C                   ENDIF

      ** Validate Action Code & Transaction Number

     C                   EXSR      VAL

      **  Carry out no further validation if errors have occurred

     C                   IF        OKACTN = 'N' OR
     C                             OKCUST = 'N'
     C                   RETURN
     C                   ENDIF

      ** Access Security Checking

     C                   IF        RespMode = 'S'
     C                   EVAL      ZACTN=DDACTN

      ** If single branching
      ** Access Security Checking - Single Branching

     C                   IF        BJSBRC <> *BLANK AND
     C                             RESPMODE = 'S'
     C                   EXSR      ACSSES
     C                   ENDIF

      ** If multibranching
      ** Access Security Checking - Multi-Branching

     C                   IF        BJSBRC = *BLANK AND
     C                             DDACTN <> 'I' AND
     C                             RESPMODE = 'S'
     C                   EXSR      ACSSEM
     C                   ENDIF
     C                   ENDIF

      ** Carry out no further validation if errors have occurred

     C                   IF        OKACTN = 'N'
     C                   RETURN
     C                   ENDIF

      ** Validation for Action Code 'I'

     C                   IF        DDACTN = 'I'
     C                   EXSR      VALACI
     C                   ENDIF

      ** Validation for Action Code 'E'

     C                   IF        DDACTN = 'E'
     C                   EXSR      RTVCRWA
     C                   ENDIF

      ** Validation for Action Code 'A'

     C                   IF        DDACTN = 'A'
     C                   EXSR      RTVCRWA
     C                   ENDIF

      ** Validation for Action Code 'D'

     C                   IF        DDACTN = 'D'
     C                   EXSR      RTVCRWA
     C                   EXSR      VALACD
     C                   ENDIF

      ** Validation for Action Code 'C'                                                     BUG14009
                                                                                            BUG14009
     C                   IF        DDACTN = 'C'                                             BUG14009
     C                   EXSR      RTVCRWA                                                  BUG14009
     C                   ENDIF                                                              BUG14009
                                                                                            BUG14009
      ** Validation for Action Code 'R'                                                     BUG14009
                                                                                            BUG14009
     C                   IF        DDACTN = 'R'                                             BUG14009
     C                   EXSR      RTVCRWA                                                  BUG14009
     C                   ENDIF                                                              BUG14009
                                                                                            BUG14009
      **  Carry out no further validation if errors occurred

     C                   IF        OKACTN = 'N' OR
     C                             OKCUST = 'N'
     C                   RETURN
     C                   ENDIF

      ** Return

     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ACSSES - Access Security Checking - Single Branching         *
      *                                                               *
      *****************************************************************
     C     ACSSES        BEGSR

      ** Check user's authority for the action

     C                   CALL      'ZVACTU'
     C                   PARM                    ZACTN             1
     C                   PARM                    ERR               1 0

      ** If action invalid for user

     C                   IF        ERR = 1
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   SELECT
     C                   WHEN      DDACTN='E'
     C                   MOVEL     'RE7105B'     MsgIdArr(Ix)
     C                   WHEN      DDACTN='I'
     C                   MOVEL     'RE7102B'     MsgIdArr(Ix)
     C                   WHEN      DDACTN='A'
     C                   MOVEL     'RE7103B'     MsgIdArr(Ix)
     C                   WHEN      DDACTN='D'
     C                   MOVEL     'RE7104B'     MsgIdArr(Ix)
     C                   WHEN      DDACTN='C'                                               BUG14009
     C                   MOVEL     'USR0638'     MsgIdArr(Ix)                               BUG14009
     C                   WHEN      DDACTN='R'                                               BUG14009
     C                   MOVEL     'USR0639'     MsgIdArr(Ix)                               BUG14009
     C                   ENDSL
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  ACSSEM - ACCESS SECURITY CHECKING - MULTI-BRANCHING          *
      *                                                               *
      *****************************************************************
     C     ACSSEM        BEGSR

     C                   CALLB     'AOSVALR0'                                                 260292
     C                   PARM                    @RTCD             7                          260292
     C                   PARM      BRCUSR        @OP01            20                          260292
     C     CurSysVal     PARM                    @VL01           200                          260292
     C                   PARM                    @OP02            20                          260292
     C                   PARM                    @VL02           200                          260292
     C                   PARM                    @OP03            20                          260292
     C                   PARM                    @VL03           200                          260292
     C                   PARM                    @OP04            20                          260292
     C                   PARM                    @VL04           200                          260292
     C                   PARM                    @OP05            20                          260292
     C                   PARM                    @VL05           200                          260292
     C                   PARM                    @OP06            20                          260292
     C                   PARM                    @VL06           200                          260292
     C                   PARM                    @OP07            20                          260292
     C                   PARM                    @VL07           200                          260292
     C                   PARM                    @OP08            20                          260292
     C                   PARM                    @VL08           200                          260292
     C                   PARM                    @OP09            20                          260292
     C                   PARM                    @VL09           200                          260292
     C                   PARM                    @OP10            20                          260292
     C                   PARM                    @VL10           200                          260292
      *                                                                                       260292
     C                   IF        CurVal = 'Y'                                               260292
      *                                                                                     MD022997
     C     DDCUST        CHAIN     SDCUSTL1                           44                    MD022997
     C                   MOVE      BBBRCD        ZBR                                        MD022997
      *                                                                                       260292
      ** Check user's authority for the action & Booking Branch

     C                   CALL      'ZVACTBU'
     C                   PARM                    ZACTN
     C**********         PARM      DBRN          ZBR                                        MD022997
     C                   PARM                    ZBR                                        MD022997
     C                   PARM                    ERR

      ** If action invalid for user

     C                   IF        ERR = 1
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'RE71070'     MsgIdArr(Ix)
     C                   ELSE
     C                   IF        ERR = 2
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   SELECT
     C                   WHEN      DDACTN='E'
     C                   MOVEL     'RE7105B'     MsgIdArr(Ix)
     C                   WHEN      DDACTN='I'
     C                   MOVEL     'RE7102B'     MsgIdArr(Ix)
     C                   WHEN      DDACTN='A'
     C                   MOVEL     'RE7103B'     MsgIdArr(Ix)
     C                   WHEN      DDACTN='D'
     C                   MOVEL     'RE7104B'     MsgIdArr(Ix)
     C                   WHEN      DDACTN='C'                                               BUG14009
     C                   MOVEL     'USR0638'     MsgIdArr(Ix)                               BUG14009
     C                   WHEN      DDACTN='R'                                               BUG14009
     C                   MOVEL     'USR0639'     MsgIdArr(Ix)                               BUG14009
     C                   ENDSL
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF                                                                260292
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * RTVCRWA - Retrieve Customer Risk Weighted Assets Details If   *
      *           Action Code 'A', 'E' or 'D'                         *
      *                                                               *
      *****************************************************************
     C     RTVCRWA       BEGSR

      ** Access Customer Risk Weighted Assets from the Customer Risk
      ** Weighted Assets file

     C                   Eval      Cod_Arr = *BLANKS
     C                   Eval      Set_Arr = *BLANKS
     C                   Eval      Ctr=1
     C                   MOVE      *OFF          *IN25
     C     DDCUST        SETLL     SDCRWAL1
     C                   DOW       *IN25 = *OFF
     C     DDCUST        READE     SDCRWAL1                               25
     C                   IF        *IN25 = *OFF   AND
     C                             RWRECI = *BLANK

      ** Populate Cod/Set Array here

     C                   Eval      RARECI = RWRECI
     C                   Eval      RACUST = DDCUST
     C                   Eval      Cod_Arr(Ctr) = RWCODE
     C                   Eval      Set_Arr(Ctr) = RWSETN
     C                   Eval      RACHTP = RWCHTP
     C                   Eval      RALCD = RWLCD
     C                   Eval      RATMST = RWTMST
     C                   Eval      Ctr = Ctr + 1
     C                   ENDIF
     C                   ENDDO

      ** populate file format & Extra Details of customer

     C                   EXSR      Pop_filfmt

     C     EndRTV        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  VFRNT - Validation for Front Office Transaction  Interface   *
      *                                                               *
      *****************************************************************
     C     VFRNT         BEGSR

      ** Error if Action Code is not 'I','A','E' OR 'D'

     C                   IF        DDACTN <> 'I' AND
     C                             DDACTN <> 'A' AND
     C                             DDACTN <> 'E' AND
     C                             DDACTN <> 'D'
     C                   EVAL      OKACTN = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0200'     MsgIdArr(Ix)
     C                   ENDIF
      *
      *
     C     EVFRNT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  VAL - VALIDATION OF ACTION CODE AND Customer Code            *
      *                                                               *
      *****************************************************************
     C     VAL           BEGSR

      ** Action Code
      **  .. must be 'I','A','D' or 'E'

     C                   IF        DDACTN <> 'I' AND
     C                             DDACTN <> 'A' AND
     C                             DDACTN <> 'E' AND
     C**********                   DDACTN <> 'D'                                            BUG14009
     C                             DDACTN <> 'D' AND                                        BUG14009
     C                             DDACTN <> 'C' AND                                        BUG14009
     C                             DDACTN <> 'R'                                            BUG14009
     C                   EVAL      OKACTN = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'SDA0001'     MsgIdArr(Ix)
     C                   ENDIF

      ** Customer number required
     C     CSD021        IFEQ      'N'                                                      MD039287
     C     DDACTN        ORNE      'I'                                                      MD039287

     C     DDCUST        IFEQ      *BLANKS
     C     DDCUST        OREQ      *ZEROS
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUST'      FldNameArr(Ix)
     C                   MOVEL     'USR0246'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ENDIF

     C                   ENDIF                                                              MD039287

      ** Access Customer from the Customers file when action code is
      ** not equal to 'D'

     C                   If        DDACTN <> 'D' AND
     C                             From_Cust = 'N'

     C     DDCUST        CHAIN     SDCUSTL1                           44

      ** Customer details not found

     C     *IN44         IFEQ      '1'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUST'      FldNameArr(Ix)
     C                   MOVEL     'USR0081'     MsgIdArr(Ix)

      ** Customer must reference an active Customer

     C                   ELSE
     C     BBDTDL        IFNE      *ZERO
     C     DDACTN        ANDNE     'E'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUST'      FldNameArr(Ix)
     C                   IF        DDACTN = 'I'                                             MD025006
     C                   MOVEL     'USR0342'     MsgIdArr(Ix)
     C                   ELSEIF    DDACTN = 'A' OR DDACTN = 'D'                             MD025006
     C                   MOVEL     '5046259'     MsgIdArr(Ix)                               MD025006
     C                   ENDIF                                                              MD025006
     C                   ELSE
     C     BBCLST        IFEQ      'Y'
     C     DDACTN        ANDEQ     'A'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUST'      FldNameArr(Ix)
     C                   MOVEL     'USR9236'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C     EVAL          ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  VALACI - Validation of Action Code 'I'                       *
      *                                                               *
      *****************************************************************
     C     VALACI        BEGSR

      ** Access Customer Risk Weighted Assets from the RWA code file
      ** (SDCRWAL1)

     C     DDCUST        CHAIN     SDCRWAD0                           44

      ** Error if customer already exist

     C                   IF        *IN44 = *OFF
     C                   EVAL      OKCUST = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUST'      FldNameArr(Ix)
     C                   MOVEL     'USR0542'     MsgIdArr(Ix)
     C                   ENDIF

     C     EVALAI        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  VALACD - VALIDATION OF ACTION CODE 'D'                       *
      *                                                               *
      *****************************************************************
     C     VALACD        BEGSR


     C     EVALAD        ENDSR
      *****************************************************************
      /EJECT

      *****************************************************************
      *                                                               *
      *  Pop_filfmt - Populate File Format                            *
      *                                                               *
      *****************************************************************
     C     Pop_filfmt    BEGSR

     C                   Eval      RACOD1 = Cod_Arr(1)
     C                   Eval      RASET1 = Set_Arr(1)
     C                   Eval      RACOD2 = Cod_Arr(2)
     C                   Eval      RASET2 = Set_Arr(2)
     C                   Eval      RACOD3 = Cod_Arr(3)
     C                   Eval      RASET3 = Set_Arr(3)
     C                   Eval      RACOD4 = Cod_Arr(4)
     C                   Eval      RASET4 = Set_Arr(4)
     C                   Eval      RACOD5 = Cod_Arr(5)
     C                   Eval      RASET5 = Set_Arr(5)
     C                   Eval      RACOD6 = Cod_Arr(6)
     C                   Eval      RASET6 = Set_Arr(6)
     C                   Eval      RACOD7 = Cod_Arr(7)
     C                   Eval      RASET7 = Set_Arr(7)
     C                   Eval      RACOD8 = Cod_Arr(8)
     C                   Eval      RASET8 = Set_Arr(8)
     C                   Eval      RACOD9 = Cod_Arr(9)
     C                   Eval      RASET9 = Set_Arr(9)
     C                   Eval      RACOD10 = Cod_Arr(10)
     C                   Eval      RASET10 = Set_Arr(10)
     C                   Eval      RACOD11 = Cod_Arr(11)
     C                   Eval      RASET11 = Set_Arr(11)
     C                   Eval      RACOD12 = Cod_Arr(12)
     C                   Eval      RASET12 = Set_Arr(12)
     C                   Eval      RACOD13 = Cod_Arr(13)
     C                   Eval      RASET13 = Set_Arr(13)
     C                   Eval      RACOD14 = Cod_Arr(14)
     C                   Eval      RASET14 = Set_Arr(14)
     C                   Eval      RACOD15 = Cod_Arr(15)
     C                   Eval      RASET15 = Set_Arr(15)
     C                   Eval      RACOD16 = Cod_Arr(16)
     C                   Eval      RASET16 = Set_Arr(16)
     C                   Eval      RACOD17 = Cod_Arr(17)
     C                   Eval      RASET17 = Set_Arr(17)
     C                   Eval      RACOD18 = Cod_Arr(18)
     C                   Eval      RASET18 = Set_Arr(18)
     C                   Eval      RACOD19 = Cod_Arr(19)
     C                   Eval      RASET19 = Set_Arr(19)
     C                   Eval      RACOD20 = Cod_Arr(20)
     C                   Eval      RASET20 = Set_Arr(20)
     C                   Eval      RACOD21 = Cod_Arr(21)
     C                   Eval      RASET21 = Set_Arr(21)
     C                   Eval      RACOD22 = Cod_Arr(22)
     C                   Eval      RASET22 = Set_Arr(22)
     C                   Eval      RACOD23 = Cod_Arr(23)
     C                   Eval      RASET23 = Set_Arr(23)
     C                   Eval      RACOD24 = Cod_Arr(24)
     C                   Eval      RASET24 = Set_Arr(24)
     C                   Eval      RACOD25 = Cod_Arr(25)
     C                   Eval      RASET25 = Set_Arr(25)
     C                   Eval      RACOD26 = Cod_Arr(26)
     C                   Eval      RASET26 = Set_Arr(26)
     C                   Eval      RACOD27 = Cod_Arr(27)
     C                   Eval      RASET27 = Set_Arr(27)
     C                   Eval      RACOD28 = Cod_Arr(28)
     C                   Eval      RASET28 = Set_Arr(28)
     C                   Eval      RACOD29 = Cod_Arr(29)
     C                   Eval      RASET29 = Set_Arr(29)
     C                   Eval      RACOD30 = Cod_Arr(30)
     C                   Eval      RASET30 = Set_Arr(30)
     C                   Eval      RACOD31 = Cod_Arr(31)
     C                   Eval      RASET31 = Set_Arr(31)
     C                   Eval      RACOD32 = Cod_Arr(32)
     C                   Eval      RASET32 = Set_Arr(32)
     C                   Eval      RACOD33 = Cod_Arr(33)
     C                   Eval      RASET33 = Set_Arr(33)
     C                   Eval      RACOD34 = Cod_Arr(34)
     C                   Eval      RASET34 = Set_Arr(34)
     C                   Eval      RACOD35 = Cod_Arr(35)
     C                   Eval      RASET35 = Set_Arr(35)
     C                   Eval      RACOD36 = Cod_Arr(36)
     C                   Eval      RASET36 = Set_Arr(36)

      ** Get customer further detail from customer master

     C     DDCUST        CHAIN     SDCUSTL1                           40

      ** Customer details found

     C                   IF        *IN40 = *OFF
     C                   Eval      RACSSN = BBCSSN
     C                   Eval      RACRNM = BBCRNM
     C                   Eval      RACNA2 = BBCNA2
     C                   ENDIF
      *
     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  INIT - Initial processing                                    *
      *                                                               *
      *****************************************************************
     C     INIT          BEGSR

      ** Clear Outputs

     C                   CLEAR                   TranFilFmt
     C                   EVAL      OKACTN = 'Y'
     C                   EVAL      OKCUST = 'Y'

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Initialisation                                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

      ** Parameters

     C     *ENTRY        PLIST

      ** Inputs
      ** Return code

     C                   PARM                    RetCodeIn

      ** Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ** Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)

     C                   PARM                    ModeofOp

      ** Response mode

     C                   PARM                    RespMode

      ** Action Code

     C                   PARM                    DDACTN

      ** (Midas) Customer Number

     C                   PARM                    DDCUST

      ** From Customer Flag

     C                   PARM                    From_Cust

      ** Outputs
      ** Transaction Details in File Format

     C                   PARM                    TranFilFmt

      ** OK - Action code

     C                   PARM                    OKACTN

      ** OK - Customer Number

     C                   PARM                    OKCUST

      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr

      ** Array index (3P0) from/to caller

     C                   PARM                    Ix

      ** Initialise program name

     C                   EVAL      DBPGM = 'SDRWANRTV'

      **  GET RUNDAT to access MULTI-BRANCHING flag

     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER

      ** Access Bank Details

     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Database Error

     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  =  900
     C                   EVAL      DBKEY = @OPTN
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Access API ICD via access program

     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDAPI         PARM      SDAPI         DSFDY
      *
      ** Determine if CSD021 is switched on                                                 MD039287

     C                   MOVEL     'N'           CSD021            1                        MD039287
     C                   CALLB     'AOSARDR0'                                               MD039287
     C                   PARM      *BLANKS       @RTCD                                      MD039287
     C                   PARM      '*VERIFY'     @OPTN                                      MD039287
     C                   PARM      'CSD021'      @SARD             6                        MD039287
     C     SCSARD        PARM      SCSARD        DSFDY                                      MD039287

     C     @RTCD         IFEQ      *BLANK                                                   MD039287
     C                   MOVEL     'Y'           CSD021                                     MD039287
     C                   ENDIF                                                              MD039287

      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      /COPY ZACPYSRC,DBFIELDS
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program, and performs      *
      *          a ROLLBACK.                                          *
      *                                                               *
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE

      *  Note: if non-standard processing required, use the PSSR_ILENE
      *  subroutine
      ****************************************************************
      /EJECT
      ****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2007
