000100201203     H DEBUG
000101201203     H COPYRIGHT('(c) Finastra International Limited 2020')
000102201203      *****************************************************************
000103201203/*STD *  RPGBASEMOD                                                   *
000104201203/*EXI *  TEXT('Midas ZA Validate backward-looking rate fields')       *
000105201203      *****************************************************************
000106201203      *                                                               *
000107201203      *  Midas - Standing Data module                                 *
000108201203      *                                                               *
000109201203      *  ZAVBLRTE - Validate backward-looking rate fields             *
000110201203      *                                                               *
000111201203      *  Function:  This module receives a parameter containing the   *
000112201203      *             Backward-Looking Rate fields and confirms whether *
000113201203      *             they have valid values.                           *
000114201203      *             If the flds are valid, the returncode 10A will be *
000115201203      *             blank and the passed flds will contain valid      *
000116201203      *             formatted values (ready to be stored).            *
000117201203      *             If one of the flds is invalid, the returncode     *
000118201203      *             will contain 'Error' and an error message will be *
000119201203      *             returned.                                         *
000120201203      *                                                               *
000121201203      *  (c) Finastra International Limited 2020                      *
000122201203      *                                                               *
000123201203      *  Last Amend No. CLE172 *CREATE     Date 01Oct20               *
000124201203      *                                                               *
000125201203      *---------------------------------------------------------------*
000126201203      *                                                               *
000127201203      *  CLE172 - LIBOR Deregulation - Lending                        *
000128201203      *                                                               *
000129201203      *****************************************************************
000130201203      *                                                               *
000131201203      *  Use of indicators.                                           *
000132201203      *                                                               *
000133201203      *    U7, U8     Database error                                  *
000134201203      *    33         Found Base Rate                                 *
000135201203      *                                                               *
000136201203      *****************************************************************
000137201203      *                                                               *
000138201203      *  S U B R O U T I N E  I N D E X                               *
000139201203      *                                                               *
000140201203      *  *PSSR - Error processing                                     *
000141201203      *  *INZSR - Initialise                                          *
000142201203      *  SRBLRT - Validate Backward-Looking Rate                      *
000143201203      *  SRLBDY - Validate Lookback Days for Settlement               *
000144201203      *  SRLODY - Validate Lockout Days                               *
000145201203      *  SRPDLY - Validate Payment Delay Days                         *
000146201203      *  SRBADJ - Validate Benchmark Adjustment                       *
000147201203      *  SRAVOP - Validate Averaging Option                           *
000148201203      *  SRCART - Validate Compounded/Average Rate                    *
000149201203      *  SRWGHT - Validate Weight Convention                          *
000150201203      *  SRBRAC - Validate Base Rate for Accrual                      *
000151201203      *  SRLBAC - Validate Lookback Days for Accrual                  *
000152201203      *  SRPIAD - Validate Principal Interest Control Date            *
000153201203      *                                                               *
000154201203      *****************************************************************
000155201203      ** +--------------------------------------+
000156201203      ** ¦ F-specs                              ¦
000157201203      ** ¦ =======                              ¦
000158201203      ** +--------------------------------------+
000162201203
000163201203      *****************************************************************
000164201203      /EJECT
000165201203      *****************************************************************
000166201203      ** +--------------------------------------+
000167201203      ** ¦ D-specs                              ¦
000168201203      ** ¦ =======                              ¦
000169201203      ** +--------------------------------------+
000170201203
000171201203     D/COPY ZACPYSRC,PSDS
000172201203      *
000173201203      ** Program Status Data Structure
000174201203
000175201203     D/COPY ZACPYSRC,STD_D_SPEC
000176201203
000177201203      ** +--------------------------------------+
000178201203      ** ¦ Named constants                      ¦
000179201203      ** ¦ ===============                      ¦
000180201203      ** +--------------------------------------+
000181201203
000182201203     D NumBlank        C                   CONST('0123456789 ')
000183201203
000184201203      ** The maximum size of the appended error arrays
000185201203     D XArrayMax       C                   CONST(40)
000186201203
000187201203      ** +--------------------------------------+
000188201203      ** ¦ Arrays and Data Structures           ¦
000189201203      ** ¦ ==========================           ¦
000190201203      ** +--------------------------------------+
000191201203
000192201203      ** Array of fields in error
000193201203     D FldNamXAr       S             10A   DIM(XArrayMax)
000194201203      ** Array of error message IDs
000195201203     D MsgIdXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
000196201203	
000197201203     D ArrayBadj       S              1A   DIM(17)
000198201203      * Incoming Benchmark Adjustment in screen format
000199201203     D ArrayCart       S              1A   DIM(17)
000200201203      * Incoming Compounded/Average Rate in screen format
000201201203
000202201203      ** DS for Access Programs: Short Data Structure
000203201203     D DSFDY         E DS                  EXTNAME(DSFDY)
000204201203      ** First DS for access programs, long data structure
000205201203     D DSSDY         E DS                  EXTNAME(DSSDY)
000206201203
000207201203      ** DS for SC Switchable Features
000208201203     D SCSARD        E DS                  EXTNAME(SCSARDPD)
000210201203      ** DS for General Ledger details
000211201203     D SDGELR        E DS                  EXTNAME(SDGELRPD)
000213201203      ** DS for Dealing details
000214201203     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
000215201203     D                                     PREFIX(DL)
000216201203      ** DS for  Base Rate details
000217201203     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)
000218201203     D                                     PREFIX(B)
000226201203      ** DS for Base rate for Accrual details
000227201203     D SDBRACDS      E DS                  EXTNAME(SDBSRTPD)
000228201203     D                                     PREFIX(Z)
000229201203
000230201203      ** +--------------------------------------+
000231201203      ** ¦ Declared variables                   ¦
000232201203      ** ¦ ==================                   ¦
000233201203      ** +--------------------------------------+
000234201203
000235201203     D @RUN            S              1
000236201203
000237201203      ** Index for arrays of error message ids
000238201203     D Idx             S              3P 0
000239201203      ** Passed index value
000240201203     D Ix              S              3P 0
000241201203
000242201203      ** Backward-Looking Rate screen fields - received as a parameter
000243201203     D BasRBckfld      DS            46
000244201203     D  DDBLRT                 1      1
000245201203     D  DDCART                 2     15
000246201203     D  DDLBDY                16     17
000247201203     D  DDLODY                18     19
000248201203     D  DDPDLY                20     21
000249201203     D  DDBADJ                22     35
000250201203     D  DDAVOP                36     36
000251201203     D  DDBRAC                37     38
000252201203     D  DDWGHT                39     39
000253201203     D  DDLBAC                40     41
000254201203     D  DDPIAD                42     46
000255201203
000257201203      ** Backward-Looking Rate valid fields
000259201203     D  VBLRT          S              1A
000260201203     D  VCART          S             13P 8
000261201203     D  VLBDY          S              2S 0
000262201203     D  VLODY          S              2S 0
000263201203     D  VPDLY          S              2S 0
000264201203     D  VBADJ          S             13P 8
000265201203     D  VAVOP          S              1A
000266201203     D  VBRAC          S              2A
000267201203     D  VWGHT          S              1A
000268201203     D  VLBAC          S              2S 0
000269201203     D  VPIAD          S              5P 0
000270201203
000271201203      ** Parameters for access object AOSARDR0
000272201203     D PRTCD           S              7A
000273201203     D POPTN           S              7A
000274201203     D PSARD           S              6A
000275201203     D PKEY1           S              3A
000276201203     D PKEY2           S              2A
000277201203     D CLE172          S              1A
000278201203	
000279201203      ** Parameters for calling ZA0841
000280201203     D @@ALPH          S             16A
000281201203     D @@MTID          S              1A
000282201203     D @@AMT           S             15P 0
000283201203     D @@ERCD          S              1P 0
000284201203     D @@IDP           S              3P 0
000285201203     D @@IINT          S              3P 0
000286201203	
000287201203      ** Parameters for calling ZASIGN
000288201203     D PZASignOk       S              1A
000289201203     D PZFld17         S             17A
000290201203     D PZDig           S              2P 0
000291201203     D PZDec           S              1P 0
000292201203     D PZSDCSP         S              1A
000293201203     D PZOut15         S             15A
000294201203     D PZFSign         S              1A
000295201203
000296201203     D #1TESTN         S              1A
000297201203     D #1CHARPOS       S              2P 0
000298201203     D #2CHARPOS       S              2P 0
000299201203     D WDAY            S              2S 0
000300201203     D PTBADJ          S              2P 0
000301201203     D IntBadj         S              5A
000302201203     D DecBadj         S              8A
000303201203     D WNumBadj        S             13P 8
000304201203     D PTCART          S              2P 0
000305201203     D IntCart         S              5A
000306201203     D DecCart         S              8A
000307201203     D WNumCart        S             13P 8
000308201203
000309201203      ** Work fields for base rate key list
000310201203     D WFCYCD          S              3A
000311201203     D WFBSRC          S              2A
000312201203
000313201203      ** OK fields
000314201203     D DDBLRTOK        S              1A
000315201203     D DDLBDYOK        S              1A
000316201203     D DDLODYOK        S              1A
000317201203     D DDPDLYOK        S              1A
000318201203     D DDBADJOK        S              1A
000319201203     D DDAVOPOK        S              1A
000320201203     D DDCARTOK        S              1A
000321201203     D DDWGHTOK        S              1A
000322201203
000323201203      *****************************************************************
000324201203      /EJECT
000325201203      *****************************************************************
000326201203      *
000327201203      ** +--- Start of Main processing -----------------------------------+
000328201203      ** ¦                                                                ¦
000329201203      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
000330201203      ** ¦ executed at program activation.                                ¦
000331201203      ** ¦                                                                ¦
000332201203      ** +----------------------------------------------------------------+
000333201203
000334201203      *********************************************************************
000335201203      * MAIN PROCEDURE                                                    *
000336201203      *********************************************************************
000337201203      *
000338201203     C                   Z-ADD     Idx           Ix                             Store index
000339201203      *
000340201203     C     WFBSRC        IFNE      *BLANKS
000341201203     C                   Z-ADD     *ZEROS        WDAY
000342201203     C                   EXSR      SRBLRT
000343201203     C                   EXSR      SRLBDY
000344201203     C                   EXSR      SRLODY
000345201203     C                   EXSR      SRPDLY
000346201203     C                   EXSR      SRBADJ
000347201203     C                   EXSR      SRAVOP
000348201203     C                   EXSR      SRCART
000349201203     C                   EXSR      SRWGHT
000350201203     C                   EXSR      SRBRAC
000351201203     C                   EXSR      SRLBAC
000352201203     C                   EXSR      SRPIAD
000353201203     C                   ENDIF
000354201203      *
000355201203      ** If a new error was found, set the return code appropriately
000356201203     C                   IF        Idx > Ix
000357201203     C                   EVAL      RetCodeOut = 'Error'
000358201203     C                   ENDIF
000359201203
000360201203     C                   RETURN
000361201203
000362201203      *****************************************************************
000363201203      /EJECT
000364201203      *****************************************************************
000365201203      *                                                               *
000366201203      * *INZSR - Program Initialisation routine                       *
000367201203      *                                                               *
000368201203      * Called by: Implicitly on program activation                   *
000369201203      *                                                               *
000370201203      * Calls: None                                                   *
000371201203      *                                                               *
000372201203      *****************************************************************
000373201203
000374201203     C     *INZSR        BEGSR
000375201203
000376201203     C     *ENTRY        PLIST
000377201203     C                   PARM                    WFCYCD                         In param
000378201203     C                   PARM                    WFBSRC                         In param
000379201203     C                   PARM                    BasRBckFld                     In/Out param
000380201203     C                   PARM                    Idx                            In/Out param
000381201203     C                   PARM                    FldNamXAr                      In/Out param
000382201203     C                   PARM                    MsgIdXAr                       In/Out param
000383201203     C                   PARM                    VBLRT                          Out param
000384201203     C                   PARM                    VLBDY                          Out param
000385201203     C                   PARM                    VLODY                          Out param
000386201203     C                   PARM                    VPDLY                          Out param
000387201203     C                   PARM                    VBADJ                          Out param
000388201203     C                   PARM                    VAVOP                          Out param
000389201203     C                   PARM                    VCART                          Out param
000390201203     C                   PARM                    VWGHT                          Out param
000391201203     C                   PARM                    VBRAC                          Out param
000392201203     C                   PARM                    VLBAC                          Out param
000393201203     C                   PARM                    VPIAD                          Out param
000394201203     C                   PARM                    RetCodeOut                     Out param
000395201203
000396201203      **  Key list for base rate
000397201203
000398201203     C     WKSDBSRT      KLIST
000399201203     C                   KFLD                    WFCYCD
000400201203     C                   KFLD                    WFBSRC
000401201203
000402201203      ** Check if CLE172 is installed
000403201203
000404201203     C                   EVAL      CLE172 = 'N'
000405201203
000406201203     C                   CALL      'AOSARDR0'
000407201203     C                   PARM      *BLANKS       PRTCD
000408201203     C                   PARM      '*VERIFY'     POPTN
000409201203     C                   PARM      'CLE172'      PSARD
000410201203     C     SCSARD        PARM      SCSARD        DSFDY
000411201203      * Database error
000412201203     C                   IF        PRTCD <> *BLANKS  AND
000413201203     C                             PRTCD <> '*NRF   '
000414201203     C     *LOCK         IN        LDA
000415201203     C/COPY ZACPYSRC,DBFIELDS
000416201203     C                   EVAL      DBFILE =  'SCSARDPD'                         *************
000417201203     C                   EVAL      DBKEY  =  PSARD                              * DBERR 001 *
000418201203     C                   EVAL      DBASE  =  001                                *************
000419201203     C                   OUT       LDA
000420201203     C                   EXSR      *PSSR
000421201203     C                   ENDIF
000422201203
000423201203     C                   IF        PRTCD = *BLANKS
000424201203     C                   EVAL      CLE172 = 'Y'
000425201203     C                   ENDIF
000426201203
000427201203      ** Access General Ledger details
000428201203
000429201203     C                   CALLB     'AOGELRR1'
000430201203     C                   PARM      *BLANKS       PRTCD
000431201203     C                   PARM      '*FIRST '     POPTN
000432201203     C     SDGELR        PARM      SDGELR        DSSDY
000433201203      * Database error
000434201203     C     PRTCD         IFNE      *BLANKS
000435201203     C     *LOCK         IN        LDA
000436201203     C                   EVAL      DBFILE =  'SDGELRPD'                         *************
000437201203     C                   EVAL      DBKEY  =  '*FIRST'                           * DBERR 002 *
000438201203     C                   EVAL      DBASE  =  002                                *************
000439201203     C                   OUT       LDA
000440201203     C                   EXSR      *PSSR
000441201203     C                   ENDIF
000442201203
000443201203      ** Access Dealing Details
000444201203
000445201203     C                   CALL      'AODEALR1'
000446201203     C                   PARM      *BLANKS       PRTCD
000447201203     C                   PARM      '*FIRST '     POPTN
000448201203     C     SDDEAL        PARM      SDDEAL        DSSDY
000449201203      *
000450201203     C     PRTCD         IFNE      *BLANK
000451201203     C                   EVAL      DLBNDCSP =  '.'
000452201203     C                   ENDIF
000453201203
000454201203      ** Access Base Rate Details
000455201203
000456201203     C     WFBSRC        IFNE      *BLANKS
000457201203     C                   CALLB     'AOBSRTR0'
000458201203     C                   PARM      *BLANKS       PRTCD
000459201203     C                   PARM      '*KEY   '     POPTN
000460201203     C                   PARM      WFCYCD        PKEY1
000461201203     C                   PARM      WFBSRC        PKEY2
000462201203     C     SDBSRT        PARM      SDBSRT        DSSDY
000463201203      *
000464201203     C     PRTCD         IFEQ      *BLANKS
000465201203     C                   MOVE      BBABSRC       WFBSRC
000466201203     C                   ENDIF
000467201203     C     PRTCD         IFEQ      '*NOSEL  '
000468201203     C                   MOVE      *BLANKS       WFBSRC
000469201203     C                   ENDIF
000470201203     C                   ENDIF
000471201203      *
000472201203     C                   ENDSR
000473201203
000474201203      *****************************************************************
000475201203
000476201203      *****************************************************************
000477201203      /EJECT
000478201203      *****************************************************************
000479201203      *  SRBLRT - Validate backward-looking rate                      *
000480201203      *****************************************************************
000481201203     C     SRBLRT        BEGSR
000482201203      *
000483201203     C     CLE172        IFEQ      *ON                                          CLE172=ON
000484201203     C                   MOVE      BBABLRT       DDBLRT                         Default from
000485201203      *                                                                          SDBSRTPD
000486201203     C     DDBLRT        IFEQ      'Y'
000487201203     C     BKALDI        ANDEQ     'Y'
000488201203      * Accrue on Last Day is Y and Rate is Backward-Looking Rate
000489201203     C                   MOVE      'N'           DDBLRTOK
000490201203     C                   ADD       1             Idx
000491201203     C                   MOVEL     'DDBLRT'      FldNamXAr(Idx)
000492201203     C                   MOVEL     '5049426'     MsgIdXAr(Idx)
000493201203     C                   ENDIF
000494201203     C                   ELSE                                                   CLE172=OFF
000495201203     C                   MOVE      'N'           DDBLRT                          Default: N
000496201203     C                   ENDIF
000497201203      *
000498201203     C     DDBLRTOK      IFNE      'N'
000499201203     C                   MOVE      DDBLRT        VBLRT
000500201203     C                   ENDIF
000501201203      *
000502201203     C                   ENDSR
000503201203      *
000504201203      *****************************************************************
000505201203      /EJECT
000506201203      *****************************************************************
000507201203      *  SRLBDY - Validate lookback days for settlement               *
000508201203      *****************************************************************
000509201203     C     SRLBDY        BEGSR
000510201203      *
000511201203     C     CLE172        IFEQ      *ON                                          CLE172=ON
000512201203     C     DDLBDY        IFEQ      *BLANKS
000513201203     C                   MOVE      BBALBDY       DDLBDY                         Default from
000514201203      *                                                                          SDBSRTPD
000515201203     C                   ELSE
000516201203     C                   MOVE      DDLBDY        #1TESTN                        Check if
000517201203     C     #1TESTN       SCAN      NumBlank      #1CHARPOS                       numeric
000518201203     C                   MOVEL     DDLBDY        #1TESTN
000519201203     C     #1TESTN       SCAN      NumBlank      #2CHARPOS
000520201203      *
000521201203     C     #1CHARPOS     IFEQ      *ZERO
000522201203     C     #2CHARPOS     OREQ      *ZERO
000523201203      * Lookback Days for Settlement is not numeric
000524201203     C                   MOVE      'N'           DDLBDYOK
000525201203     C                   ADD       1             Idx
000526201203     C                   MOVEL     'DDLBDY'      FldNamXAr(Idx)
000527201203     C                   MOVEL     '5049423'     MsgIdXAr(Idx)
000528201203     C                   ELSE                                                   If numeric
000529201203      *
000530201203     C                   MOVE      DDLBDY        WDAY
000531201203     C     BBABLRT       IFEQ      'N'
000532201203     C     WDAY          ANDNE     *ZEROS
000533201203      * Backward-Looking Rate is N and Lookback Days is not 0
000534201203     C                   MOVE      'N'           DDLBDYOK
000535201203     C                   ADD       1             Idx
000536201203     C                   MOVEL     'DDLBDY'      FldNamXAr(Idx)
000537201203     C                   MOVEL     '5049420'     MsgIdXAr(Idx)
000538201203     C                   ENDIF
000539201203      *
000540201203     C                   ENDIF                                                  END numeric
000541201203     C                   ENDIF                                                  END default
000542201203     C                   ELSE                                                   CLE172=OFF
000543201203     C                   MOVE      '00'          DDLBDY                          Default: 00
000544201203     C                   ENDIF
000545201203      *
000546201203     C     DDLBDYOK      IFNE      'N'
000547201203     C                   MOVE      DDLBDY        VLBDY
000548201203     C                   ENDIF
000549201203      *
000550201203     C                   ENDSR
000551201203      *
000552201203      *****************************************************************
000553201203      /EJECT
000554201203      *****************************************************************
000555201203      *  SRLODY - Validate lockout days                               *
000556201203      *****************************************************************
000557201203     C     SRLODY        BEGSR
000558201203      *
000559201203     C     CLE172        IFEQ      *ON                                          CLE172=ON
000560201203     C     DDLODY        IFEQ      *BLANKS
000561201203     C                   MOVE      BBALODY       DDLODY                         Default from
000562201203      *                                                                          SDBSRTPD
000563201203     C                   ELSE
000564201203     C                   MOVE      DDLODY        #1TESTN                        Check if
000565201203     C     #1TESTN       SCAN      NumBlank      #1CHARPOS                       numeric
000566201203     C                   MOVEL     DDLODY        #1TESTN
000567201203     C     #1TESTN       SCAN      NumBlank      #2CHARPOS
000568201203      *
000569201203     C     #1CHARPOS     IFEQ      *ZERO
000570201203     C     #2CHARPOS     OREQ      *ZERO
000571201203      * Lockout Days is not numeric
000572201203     C                   MOVE      'N'           DDLODYOK
000573201203     C                   ADD       1             Idx
000574201203     C                   MOVEL     'DDLODY'      FldNamXAr(Idx)
000575201203     C                   MOVEL     '5049424'     MsgIdXAr(Idx)
000576201203     C                   ELSE                                                   If numeric
000577201203      *
000578201203     C                   MOVE      DDLODY        WDAY
000579201203     C     BBABLRT       IFEQ      'N'
000580201203     C     WDAY          ANDNE     *ZEROS
000581201203      * Backward-Looking Rate is N and Lockout Days is not 0
000582201203     C                   MOVE      'N'           DDLODYOK
000583201203     C                   ADD       1             Idx
000584201203     C                   MOVEL     'DDLODY'      FldNamXAr(Idx)
000585201203     C                   MOVEL     '5049421'     MsgIdXAr(Idx)
000586201203     C                   ENDIF
000587201203      *
000588201203     C                   ENDIF                                                  END numeric
000589201203     C                   ENDIF                                                  END default
000590201203     C                   ELSE                                                   CLE172=OFF
000591201203     C                   MOVE      '00'          DDLODY                          Default: 00
000592201203     C                   ENDIF
000593201203      *
000594201203     C     DDLODYOK      IFNE      'N'
000595201203     C                   MOVE      DDLODY        VLODY
000596201203     C                   ENDIF
000597201203      *
000598201203     C                   ENDSR
000599201203      *
000600201203      *****************************************************************
000601201203      /EJECT
000602201203      *****************************************************************
000603201203      *  SRPDLY - Validate payment delay days                         *
000604201203      *****************************************************************
000605201203     C     SRPDLY        BEGSR
000606201203      *
000607201203     C     CLE172        IFEQ      *ON                                          CLE172=ON
000608201203     C     DDPDLY        IFEQ      *BLANKS
000609201203     C                   MOVE      BBAPDLY       DDPDLY                         Default from
000610201203      *                                                                          SDBSRTPD
000611201203     C                   ELSE
000612201203     C                   MOVE      DDPDLY        #1TESTN                        Check if
000613201203     C     #1TESTN       SCAN      NUMBLANK      #1CHARPOS                       numeric
000614201203     C                   MOVEL     DDPDLY        #1TESTN
000615201203     C     #1TESTN       SCAN      NUMBLANK      #2CHARPOS
000616201203      *
000617201203     C     #1CHARPOS     IFEQ      *ZERO
000618201203     C     #2CHARPOS     OREQ      *ZERO
000619201203      * Payment Delay Days is not numeric
000620201203     C                   MOVE      'N'           DDPDLYOK
000621201203     C                   ADD       1             Idx
000622201203     C                   MOVEL     'DDPDLY'      FldNamXAr(Idx)
000623201203     C                   MOVEL     '5049425'     MsgIdXAr(Idx)
000624201203     C                   ELSE                                                   If numeric
000625201203      *
000626201203     C                   MOVE      DDPDLY        WDAY
000627201203     C     BBABLRT       IFEQ      'N'
000628201203     C     WDAY          ANDNE     *ZEROS
000629201203      * Backward-Looking Rate is N and Payment Delay Days is not 0
000630201203     C                   MOVE      'N'           DDPDLYOK
000631201203     C                   ADD       1             Idx
000632201203     C                   MOVEL     'DDPDLY'      FldNamXAr(Idx)
000633201203     C                   MOVEL     '5049422'     MsgIdXAr(Idx)
000634201203     C                   ENDIF
000635201203      *
000636201203     C                   ENDIF                                                  END numeric
000637201203     C                   ENDIF                                                  END default
000638201203     C                   ELSE                                                   CLE172=OFF
000639201203     C                   MOVE      '00'          DDPDLY                          Default: 00
000640201203     C                   ENDIF
000641201203      *
000642201203     C     DDPDLYOK      IFNE      'N'
000643201203     C                   MOVE      DDPDLY        VPDLY
000644201203     C                   ENDIF
000645201203      *
000646201203     C                   ENDSR
000647201203      *
000648201203      *****************************************************************
000649201203      /EJECT
000650201203      *****************************************************************
000651201203      *  SRBADJ - Validate benchmark adjustment                       *
000652201203      *****************************************************************
000653201203     C     SRBADJ        BEGSR
000654201203      *
000655201203     C     CLE172        IFEQ      *ON                                          CLE172=ON
000656201203     C     DDBADJ        IFEQ      *BLANKS                                      If blank
000657201203     C                   MOVE      BBABADJ       DDBADJ                         Default from
000658201203     C                   ENDIF                                                   SDBSRTPD
000659201203      *
000660201203     C                   MOVE      *BLANKS       @@ALPH
000661201203     C                   MOVE      DDBADJ        @@ALPH
000662201203     C                   CALLB     'ZA0841'
000663201203     C                   PARM      *BLANK        RetCodeOut
000664201203     C                   PARM                    @@ALPH                         Display field
000665201203     C                   PARM      8             @@IDP                          no.of dec.plcs
000666201203     C                   PARM      5             @@IINT                         no.of integers
000667201203     C                   PARM      'N'           @@MTID                         Mil/Thou
000668201203     C                   PARM      *ZERO         @@ERCD                         Error code
000669201203     C                   PARM      *ZERO         @@AMT                          File field
000670201203     C                   PARM                    DLBNDCSP
000671201203      *
000672201203     C     @@ERCD        IFNE      0
000673201203      * Benchmark Adjustment is not numeric
000674201203     C                   MOVE      'N'           DDBADJOK
000675201203     C                   ADD       1             Idx
000676201203     C                   MOVEL     'DDBADJ'      FldNamXAr(Idx)
000677201203     C                   MOVEL     '5049426'     MsgIdXAr(Idx)
000678201203     C                   ELSE                                                   If numeric
000679201203      *
000680201203     C                   MOVE      @@ALPH        DDBADJ
000681201203     C                   MOVEL     DDBADJ        IntBadj
000682201203     C                   MOVE      DDBADJ        DecBadj
000683201203     C                   MOVEA     IntBadj       ArrayBadj(1)
000684201203     C                   MOVEA     DLBNDCSP      ArrayBadj(6)
000685201203     C                   MOVEA     DecBadj       ArrayBadj(7)
000686201203      *
000687201203     C     '-'           SCAN      @@ALPH        PTBADJ
000688201203     C     PTBADJ        IFNE      0
000689201203     C                   MOVE      '-'           PZFSign
000690201203     C                   MOVEA     '- '          ArrayBadj(8)
000691201203     C                   ENDIF
000692201203     C                   MOVEA     ArrayBadj     PZFld17
000693201203      *
000694201203     C                   CALLB     'ZASIGN'
000695201203     C                   PARM      'Y'           PZASignOk
000696201203     C                   PARM                    PZFld17
000697201203     C                   PARM      5             PZDig
000698201203     C                   PARM      8             PZDec
000699201203     C                   PARM      DLBNDCSP      PZSDCSP
000700201203     C                   PARM                    PZOut15
000701201203     C                   PARM                    PZFSign
000702201203     C                   MOVE      PZOut15       WNumBadj
000703201203      *
000704201203     C     BBABLRT       IFEQ      'N'
000705201203     C     WNumBadj      ANDNE     *ZEROS
000706201203      * Backward-Looking Rate is N and Benchmark Adjustment is not 0
000707201203     C                   MOVE      'N'           DDBADJOK
000708201203     C                   ADD       1             Idx
000709201203     C                   MOVEL     'DDBADJ'      FldNamXAr(Idx)
000710201203     C                   MOVEL     '5049401'     MsgIdXAr(Idx)
000711201203     C                   ENDIF
000712201203     C                   ENDIF                                                  END numeric
000713201203      *
000714201203     C                   ELSE                                                   CLE172=OFF
000715201203     C                   MOVE      '0'           DDBADJ                          Default: 0
000716201203     C                   ENDIF
000717201203      *
000718201203     C     DDBADJOK      IFNE      'N'
000719201203     C                   MOVE      DDBADJ        VBADJ
000720201203     C                   ENDIF
000721201203      *
000722201203     C                   ENDSR
000723201203      *
000724201203      *****************************************************************
000725201203      /EJECT
000726201203      *****************************************************************
000727201203      *  SRAVOP - Validate averaging option                           *
000728201203      *****************************************************************
000729201203     C     SRAVOP        BEGSR
000730201203      *
000731201203     C     CLE172        IFEQ      *ON                                          CLE172=ON
000732201203     C     DDAVOP        IFEQ      *BLANKS
000733201203     C                   MOVE      BBAAVOP       DDAVOP                         Default from
000734201203     C                   ELSE                                                    SDBSRTPD
000735201203      *
000736201203     C     DDAVOP        IFNE      '1'
000737201203     C     DDAVOP        ANDNE     '2'
000738201203     C     DDAVOP        ANDNE     '3'
000739201203     C     DDAVOP        ANDNE     '4'
000740201203      * Averaging Option value is invalid
000741201203     C                   MOVE      'N'           DDAVOPOK
000742201203     C                   ADD       1             Idx
000743201203     C                   MOVEL     'DDAVOP'      FldNamXAr(Idx)
000744201203     C                   MOVEL     '5049403'     MsgIdXAr(Idx)
000745201203     C                   ELSE                                                   If valid
000746201203      *
000747201203     C     BBABLRT       IFEQ      'N'
000748201203      * Backward-Looking Rate is N and Averaging Option is not blank
000749201203     C                   MOVE      'N'           DDAVOPOK
000750201203     C                   ADD       1             Idx
000751201203     C                   MOVEL     'DDAVOP'      FldNamXAr(Idx)
000752201203     C                   MOVEL     '5049405'     MsgIdXAr(Idx)
000753201203     C                   ENDIF
000754201203      *
000755201203     C                   ENDIF                                                  END valid
000756201203     C                   ENDIF                                                  END default
000757201203     C                   ELSE                                                   CLE172=OFF
000758201203     C                   MOVE      *BLANKS       DDAVOP                          Default:blank
000759201203     C                   ENDIF
000760201203      *
000761201203     C     DDAVOPOK      IFNE      'N'
000762201203     C                   MOVE      DDAVOP        VAVOP
000763201203     C                   ENDIF
000764201203      *
000765201203     C                   ENDSR
000766201203      *
000767201203      *****************************************************************
000768201203      /EJECT
000769201203      *****************************************************************
000770201203      *  SRCART - Validate compounded/average rate                    *
000771201203      *****************************************************************
000772201203     C     SRCART        BEGSR
000773201203      *
000774201203     C     CLE172        IFEQ      *ON                                          CLE172=ON
000775201203     C     DDCART        IFEQ      *BLANKS                                      If blank
000776201203     C                   MOVE      '0'           DDCART                          Default: 0
000777201203     C                   ENDIF
000778201203      *
000779201203     C                   MOVE      *BLANKS       @@ALPH
000780201203     C                   MOVE      DDCART        @@ALPH
000781201203     C                   CALLB     'ZA0841'
000782201203     C                   PARM      *BLANK        RetCodeOut
000783201203     C                   PARM                    @@ALPH                         Display field
000784201203     C                   PARM      8             @@IDP                          no.of dec.plcs
000785201203     C                   PARM      5             @@IINT                         no.of integers
000786201203     C                   PARM      'N'           @@MTID                         Mil/Thou
000787201203     C                   PARM      *ZERO         @@ERCD                         Error code
000788201203     C                   PARM      *ZERO         @@AMT                          File field
000789201203     C                   PARM                    DLBNDCSP
000790201203      *
000791201203     C     @@ERCD        IFNE      0
000792201203      * Compounded/Average rate is not numeric
000793201203     C                   MOVE      'N'           DDCARTOK
000794201203     C                   ADD       1             Idx
000795201203     C                   MOVEL     'DDCART'      FldNamXAr(Idx)
000796201203     C                   MOVEL     '5049426'     MsgIdXAr(Idx)
000797201203     C                   ELSE                                                   If numeric
000798201203      *
000799201203     C                   MOVE      @@ALPH        DDCART
000800201203     C                   MOVEL     DDCART        IntCart
000801201203     C                   MOVE      DDCART        DecCart
000802201203     C                   MOVEA     IntCart       ArrayCart(1)
000803201203     C                   MOVEA     DLBNDCSP      ArrayCart(6)
000804201203     C                   MOVEA     DecCart       ArrayCart(7)
000805201203      *
000806201203     C     '-'           SCAN      @@ALPH        PTCART
000807201203     C     PTCART        IFNE      0
000808201203     C                   MOVE      '-'           PZFSign
000809201203     C                   MOVEA     '- '          ArrayCart(8)
000810201203     C                   ENDIF
000811201203     C                   MOVEA     ArrayCart     PZFld17
000812201203      *
000813201203     C                   CALLB     'ZASIGN'
000814201203     C                   PARM      'Y'           PZASignOk
000815201203     C                   PARM                    PZFld17
000816201203     C                   PARM      5             PZDig
000817201203     C                   PARM      8             PZDec
000818201203     C                   PARM      DLBNDCSP      PZSDCSP
000819201203     C                   PARM                    PZOut15
000820201203     C                   PARM                    PZFSign
000821201203     C                   MOVE      PZOut15       WNumCart
000822201203      *
000823201203     C     BBABLRT       IFEQ      'N'
000824201203     C     WNumCart      ANDNE     *ZEROS
000825201203      * Backward-looking rate is N and Compounded/Average rate is not 0
000826201203     C                   MOVE      'N'           DDCARTOK
000827201203     C                   ADD       1             Idx
000828201203     C                   MOVEL     'DDCART'      FldNamXAr(Idx)
000829201203     C                   MOVEL     '5049401'     MsgIdXAr(Idx)
000830201203     C                   ENDIF
000831201203     C                   ENDIF                                                  END numeric
000832201203      *
000833201203     C                   ELSE                                                   CLE172=OFF
000834201203     C                   MOVE      '0'           DDCART                          Default: 0
000835201203     C                   ENDIF
000836201203      *
000837201203     C     DDCARTOK      IFNE      'N'
000838201203     C                   MOVE      DDCART        VCART
000839201203     C                   ENDIF
000840201203      *
000841201203     C                   ENDSR
000842201203      *
000843201203      *****************************************************************
000844201203      /EJECT
000845201203      *****************************************************************
000846201203      *  SRWGHT - Validate weight convention                          *
000847201203      *****************************************************************
000848201203     C     SRWGHT        BEGSR
000849201203      *
000850201203     C     CLE172        IFEQ      *ON                                          CLE172=ON
000851201203     C     DDWGHT        IFEQ      *BLANKS
000852201203     C                   MOVE      BBAWGHT       DDWGHT                         Default from
000853201203     C                   ELSE                                                    SDBSRTPD
000854201203      *
000855201203     C     DDWGHT        IFNE      '1'
000856201203     C     DDWGHT        ANDNE     '2'
000857201203      * Weight Convention value is invalid
000858201203     C                   MOVE      'N'           DDWGHTOK
000859201203     C                   ADD       1             Idx
000860201203     C                   MOVEL     'DDWGHT'      FldNamXAr(Idx)
000861201203     C                   MOVEL     '5049408'     MsgIdXAr(Idx)
000862201203     C                   ELSE                                                   If valid
000863201203      *
000864201203     C     BBABLRT       IFEQ      'N'
000865201203      * Backward-Looking Rate is N and Weight Convention is not blank
000866201203     C                   MOVE      'N'           DDWGHTOK
000867201203     C                   ADD       1             Idx
000868201203     C                   MOVEL     'DDWGHT'      FldNamXAr(Idx)
000869201203     C                   MOVEL     '5049455'     MsgIdXAr(Idx)
000870201203     C                   ENDIF
000871201203      *
000872201203     C     DDAVOP        IFNE      '1'
000873201203     C     DDAVOP        ANDNE     '2'
000874201203      * Averaging Option is not 1/2 and Weight Convention is not blank
000875201203     C                   MOVE      'N'           DDWGHTOK
000876201203     C                   ADD       1             Idx
000877201203     C                   MOVEL     'DDWGHT'      FldNamXAr(Idx)
000878201203     C                   MOVEL     '5049453'     MsgIdXAr(Idx)
000879201203     C                   ENDIF
000880201203      *
000881201203     C                   ENDIF                                                  END valid
000882201203     C                   ENDIF                                                  END default
000883201203     C                   ELSE                                                   CLE172=OFF
000884201203     C                   MOVE      *BLANKS       DDWGHT
000885201203     C                   ENDIF
000886201203      *
000887201203     C     DDWGHTOK      IFNE      'N'
000888201203     C                   MOVE      DDWGHT        VWGHT
000889201203     C                   ENDIF
000890201203      *
000891201203     C                   ENDSR
000892201203      *
000893201203      *****************************************************************
000894201203      /EJECT
000895201203      *****************************************************************
000896201203      *  SRBRAC - Validate base rate for accrual                      *
000897201203      *****************************************************************
000898201203     C     SRBRAC        BEGSR
000899201203      *
000900201203     C     CLE172        IFEQ      *ON                                          CLE172=ON
000901201203     C                   MOVE      BBABRAC       DDBRAC                         Default from
000902201203      *                                                                          SDBSRTPD
000903201203     C                   ELSE                                                   CLE172=OFF
000904201203     C                   MOVE      *BLANKS       DDBRAC                          Default:blank
000905201203     C                   ENDIF
000906201203      *
000907201203     C                   MOVE      DDBRAC        VBRAC
000908201203      *
000909201203     C                   ENDSR
000910201203      *
000911201203      *****************************************************************
000912201203      /EJECT
000913201203      *****************************************************************
000914201203      *  SRLBAC - Validate lookback days for accrual                  *
000915201203      *****************************************************************
000916201203     C     SRLBAC        BEGSR
000917201203      *
000918201203     C                   MOVE      '00'          DDLBAC                         Default: 00
000919201203      *
000922201203     C     DDBRAC        IFNE      *BLANKS
000923201203     C                   CALLB     'AOBSRTR0'
000924201203     C                   PARM      *BLANKS       PRTCD
000925201203     C                   PARM      '*KEY   '     POPTN
000926201203     C                   PARM      WFCYCD        PKEY1
000927201203     C                   PARM      BBABRAC       PKEY2
000928201203     C     SDBRACDS      PARM      SDBRACDS      DSSDY
000929201203      *
000930201203     C     PRTCD         IFEQ      *BLANKS                                      If found BRAC
000931201203     C     CLE172        ANDEQ     *ON                                           & CLE172=ON
000932201203     C                   MOVE      ZBALBDY       DDLBAC
000933201203     C                   ENDIF
000936201203     C                   ENDIF
000941201203      *
000942201203     C                   MOVE      DDLBAC        VLBAC
000943201203      *
000944201203     C                   ENDSR
000945201203      *
000964201203      *****************************************************************
000965201203      /EJECT
000966201203      *****************************************************************
000967201203      *  SRPIAD - Validate principal interest control date            *
000968201203      *****************************************************************
000969201203     C     SRPIAD        BEGSR
000970201203      *
000971201203     C                   MOVE      0             VPIAD                          Deafult: 0
000972201203      *
000973201203     C                   ENDSR
000974201203      *
000975201203      *********************************************************************
000976201203      /EJECT
000977201203      *********************************************************************
000978201203      *                                                                   *
000979201203      * *PSSR  - Program exception error routine                          *
000980201203      *          Called automatically if a program error occurs,          *
000981201203      *          or directly by the program code using EXSR.              *
000982201203      *          This subroutine DUMPs the program just once.             *
000983201203      *                                                                   *
000984201203      * Called by: (**calling routines**)                                 *
000985201203      *                                                                   *
000986201203      * Calls: None                                                       *
000987201203      *                                                                   *
000988201203      *********************************************************************
000989201203
000990201203     C     *PSSR         BEGSR
000991201203
000992201203     C                   DUMP
000993201203
000994201203     C                   IF        @RUN = *BLANK
000995201203     C                   EVAL      @RUN = 'Y'
000996201203
000997201203     C                   CALLB     'DBERRCTL'
000998201203
000999201203     C                   ENDIF
001000201203
001001201203     C                   EVAL      *INU7 = *ON
001002201203     C                   EVAL      *INU8 = *ON
001003201203     C                   EVAL      *INLR = *ON
001004201203     C                   RETURN
001005201203
001006201203     C                   ENDSR
001007201203
001008201203      ********************************************************************
001009201203**  CPY@
001010201203(c) Finastra International Limited 2004
