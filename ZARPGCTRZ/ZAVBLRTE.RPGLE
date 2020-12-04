     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2020')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Validate backward-looking rate fields')       *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data module                                 *
      *                                                               *
      *  ZAVBLRTE - Validate backward-looking rate fields             *
      *                                                               *
      *  Function:  This module receives a parameter containing the   *
      *             Backward-Looking Rate fields and confirms whether *
      *             they have valid values.                           *
      *             If the flds are valid, the returncode 10A will be *
      *             blank and the passed flds will contain valid      *
      *             formatted values (ready to be stored).            *
      *             If one of the flds is invalid, the returncode     *
      *             will contain 'Error' and an error message will be *
      *             returned.                                         *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. CLE172 *CREATE     Date 01Oct20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE172 - LIBOR Deregulation - Lending                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    U7, U8     Database error                                  *
      *    33         Found Base Rate                                 *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *PSSR - Error processing                                     *
      *  *INZSR - Initialise                                          *
      *  SRBLRT - Validate Backward-Looking Rate                      *
      *  SRLBDY - Validate Lookback Days for Settlement               *
      *  SRLODY - Validate Lockout Days                               *
      *  SRPDLY - Validate Payment Delay Days                         *
      *  SRBADJ - Validate Benchmark Adjustment                       *
      *  SRAVOP - Validate Averaging Option                           *
      *  SRCART - Validate Compounded/Average Rate                    *
      *  SRWGHT - Validate Weight Convention                          *
      *  SRBRAC - Validate Base Rate for Accrual                      *
      *  SRLBAC - Validate Lookback Days for Accrual                  *
      *  SRPIAD - Validate Principal Interest Control Date            *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure

     D/COPY ZACPYSRC,STD_D_SPEC

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

     D NumBlank        C                   CONST('0123456789 ')

      ** The maximum size of the appended error arrays
     D XArrayMax       C                   CONST(40)

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** Array of fields in error
     D FldNamXAr       S             10A   DIM(XArrayMax)
      ** Array of error message IDs
     D MsgIdXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
	
     D ArrayBadj       S              1A   DIM(17)
      * Incoming Benchmark Adjustment in screen format
     D ArrayCart       S              1A   DIM(17)
      * Incoming Compounded/Average Rate in screen format

      ** DS for Access Programs: Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** DS for SC Switchable Features
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** DS for General Ledger details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** DS for Dealing details
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
     D                                     PREFIX(DL)
      ** DS for  Base Rate details
     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)
     D                                     PREFIX(B)
      ** DS for Base rate for Accrual details
     D SDBRACDS      E DS                  EXTNAME(SDBSRTPD)
     D                                     PREFIX(Z)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D @RUN            S              1

     D ApiName         S              4A

      ** Index for arrays of error message ids
     D Idx             S              3P 0
      ** Passed index value
     D Ix              S              3P 0

      ** Input Screen fields
     D InpScrfld       DS           200
      ** Output Valid fields
     D OutValfld       DS           200

      ** CLIP Backward-Looking Rate Screen fields (Input)
     D CLBsrScrfld     DS
     D  DDBLRT                 1      1
     D  DDLBDY                 2      3
     D  DDLODY                 4      5
     D  DDPDLY                 6      7
     D  DDBADJ                 8     21
     D  DDAVOP                22     22
     D  DDCART                23     36
     D  DDWGHT                37     37
     D  DDBRAC                38     39
     D  DDLBAC                40     41
     D  DDPIAD                42     46

      ** CLIP Backward-Looking Rate Valid fields (Output)
     D CLBsrValfld     DS
     D  VBLRT                  1      1A
     D  VLBDY                  9     10S 0
     D  VLODY                 11     12S 0
     D  VPDLY                 13     14S 0
     D  VBADJ                 15     21P 8
     D  VAVOP                 22     22A
     D  VCART                 23     29P 8
     D  VWGHT                 30     30A
     D  VBRAC                 31     32A
     D  VLBAC                 33     34A
     D  VPIAD                 36     40S 0

      ** Parameters for access object AOSARDR0
     D PRTCD           S              7A
     D POPTN           S              7A
     D PSARD           S              6A
     D PKEY1           S              3A
     D PKEY2           S              2A
     D CLE172          S              1A
	
      ** Parameters for calling ZA0841
     D @@ALPH          S             16A
     D @@MTID          S              1A
     D @@AMT           S             15P 0
     D @@ERCD          S              1P 0
     D @@IDP           S              3P 0
     D @@IINT          S              3P 0
	
      ** Parameters for calling ZASIGN
     D PZASignOk       S              1A
     D PZFld17         S             17A
     D PZDig           S              2P 0
     D PZDec           S              1P 0
     D PZSDCSP         S              1A
     D PZOut15         S             15A
     D PZFSign         S              1A

     D #1TESTN         S              1A
     D #1CHARPOS       S              2P 0
     D #2CHARPOS       S              2P 0
     D WDAY            S              2S 0
     D PTBADJ          S              2P 0
     D IntBadj         S              5A
     D DecBadj         S              8A
     D WNumBadj        S             13P 8
     D PTCART          S              2P 0
     D IntCart         S              5A
     D DecCart         S              8A
     D WNumCart        S             13P 8

      ** Work fields for base rate key list
     D WFCYCD          S              3A
     D WFBSRC          S              2A

      ** OK fields
     D DDBLRTOK        S              1A
     D DDLBDYOK        S              1A
     D DDLODYOK        S              1A
     D DDPDLYOK        S              1A
     D DDBADJOK        S              1A
     D DDAVOPOK        S              1A
     D DDCARTOK        S              1A
     D DDWGHTOK        S              1A

      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
      *
     C                   Z-ADD     Idx           Ix                             Store index
      *
     C     WFBSRC        IFNE      *BLANKS
     C                   Z-ADD     *ZEROS        WDAY
     C     ApiName       IFEQ      'CLIP'
     C                   MOVE      InpScrfld     CLBsrScrfld
     C                   EXSR      SRBLRT
     C                   EXSR      SRLBDY
     C                   EXSR      SRLODY
     C                   EXSR      SRPDLY
     C                   EXSR      SRBADJ
     C                   EXSR      SRAVOP
     C                   EXSR      SRCART
     C                   EXSR      SRWGHT
     C                   EXSR      SRBRAC
     C                   EXSR      SRLBAC
     C                   EXSR      SRPIAD
     C                   MOVE      OutScrfld     CLBsrValfld
     C                   ENDIF
     C                   ENDIF
      *
      ** If a new error was found, set the return code appropriately
     C                   IF        Idx > Ix
     C                   EVAL      RetCodeOut = 'Error'
     C                   ENDIF

     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    ApiName                        In Param
     C                   PARM                    WFCYCD                         In param
     C                   PARM                    WFBSRC                         In param
     C                   PARM                    InpScrfld                      In/Out param
     C                   PARM                    Idx                            In/Out param
     C                   PARM                    FldNamXAr                      In/Out param
     C                   PARM                    MsgIdXAr                       In/Out param
     C                   PARM                    OutScrfld                      Out param
     C                   PARM                    RetCodeOut                     Out param

      **  Key list for base rate

     C     WKSDBSRT      KLIST
     C                   KFLD                    WFCYCD
     C                   KFLD                    WFBSRC

      ** Check if CLE172 is installed

     C                   EVAL      CLE172 = 'N'

     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CLE172'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      * Database error
     C                   IF        PRTCD <> *BLANKS  AND
     C                             PRTCD <> '*NRF   '
     C     *LOCK         IN        LDA
     C/COPY ZACPYSRC,DBFIELDS
     C                   EVAL      DBFILE =  'SCSARDPD'                         *************
     C                   EVAL      DBKEY  =  PSARD                              * DBERR 001 *
     C                   EVAL      DBASE  =  001                                *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CLE172 = 'Y'
     C                   ENDIF

      ** Access General Ledger details

     C                   CALLB     'AOGELRR1'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDGELR        PARM      SDGELR        DSSDY
      * Database error
     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDGELRPD'                         *************
     C                   EVAL      DBKEY  =  '*FIRST'                           * DBERR 002 *
     C                   EVAL      DBASE  =  002                                *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Access Dealing Details

     C                   CALL      'AODEALR1'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDDEAL        PARM      SDDEAL        DSSDY
      *
     C     PRTCD         IFNE      *BLANK
     C                   EVAL      DLBNDCSP =  '.'
     C                   ENDIF

      ** Access Base Rate Details

     C     WFBSRC        IFNE      *BLANKS
     C                   CALLB     'AOBSRTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      WFCYCD        PKEY1
     C                   PARM      WFBSRC        PKEY2
     C     SDBSRT        PARM      SDBSRT        DSSDY
      *
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      BBABSRC       WFBSRC
     C                   ENDIF
     C     PRTCD         IFEQ      '*NOSEL  '
     C                   MOVE      *BLANKS       WFBSRC
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR

      *****************************************************************

      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRBLRT - Validate backward-looking rate                      *
      *****************************************************************
     C     SRBLRT        BEGSR
      *
     C     CLE172        IFEQ      *ON                                          CLE172=ON
     C                   MOVE      BBABLRT       DDBLRT                         Default from
      *                                                                          SDBSRTPD
     C     DDBLRT        IFEQ      'Y'
     C     BKALDI        ANDEQ     'Y'
      * Accrue on Last Day is Y and Rate is Backward-Looking Rate
     C                   MOVE      'N'           DDBLRTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDBLRT'      FldNamXAr(Idx)
     C                   MOVEL     '5049426'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ELSE                                                   CLE172=OFF
     C                   MOVE      'N'           DDBLRT                          Default: N
     C                   ENDIF
      *
     C     DDBLRTOK      IFNE      'N'
     C                   MOVE      DDBLRT        VBLRT
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRLBDY - Validate lookback days for settlement               *
      *****************************************************************
     C     SRLBDY        BEGSR
      *
     C     CLE172        IFEQ      *ON                                          CLE172=ON
     C     DDLBDY        IFEQ      *BLANKS
     C                   MOVE      BBALBDY       DDLBDY                         Default from
      *                                                                          SDBSRTPD
     C                   ELSE
     C                   MOVE      DDLBDY        #1TESTN                        Check if
     C     #1TESTN       SCAN      NumBlank      #1CHARPOS                       numeric
     C                   MOVEL     DDLBDY        #1TESTN
     C     #1TESTN       SCAN      NumBlank      #2CHARPOS
      *
     C     #1CHARPOS     IFEQ      *ZERO
     C     #2CHARPOS     OREQ      *ZERO
      * Lookback Days for Settlement is not numeric
     C                   MOVE      'N'           DDLBDYOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDLBDY'      FldNamXAr(Idx)
     C                   MOVEL     '5049423'     MsgIdXAr(Idx)
     C                   ELSE                                                   If numeric
      *
     C                   MOVE      DDLBDY        WDAY
     C     BBABLRT       IFEQ      'N'
     C     WDAY          ANDNE     *ZEROS
      * Backward-Looking Rate is N and Lookback Days is not 0
     C                   MOVE      'N'           DDLBDYOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDLBDY'      FldNamXAr(Idx)
     C                   MOVEL     '5049420'     MsgIdXAr(Idx)
     C                   ENDIF
      *
     C                   ENDIF                                                  END numeric
     C                   ENDIF                                                  END default
     C                   ELSE                                                   CLE172=OFF
     C                   MOVE      '00'          DDLBDY                          Default: 00
     C                   ENDIF
      *
     C     DDLBDYOK      IFNE      'N'
     C                   MOVE      DDLBDY        VLBDY
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRLODY - Validate lockout days                               *
      *****************************************************************
     C     SRLODY        BEGSR
      *
     C     CLE172        IFEQ      *ON                                          CLE172=ON
     C     DDLODY        IFEQ      *BLANKS
     C                   MOVE      BBALODY       DDLODY                         Default from
      *                                                                          SDBSRTPD
     C                   ELSE
     C                   MOVE      DDLODY        #1TESTN                        Check if
     C     #1TESTN       SCAN      NumBlank      #1CHARPOS                       numeric
     C                   MOVEL     DDLODY        #1TESTN
     C     #1TESTN       SCAN      NumBlank      #2CHARPOS
      *
     C     #1CHARPOS     IFEQ      *ZERO
     C     #2CHARPOS     OREQ      *ZERO
      * Lockout Days is not numeric
     C                   MOVE      'N'           DDLODYOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDLODY'      FldNamXAr(Idx)
     C                   MOVEL     '5049424'     MsgIdXAr(Idx)
     C                   ELSE                                                   If numeric
      *
     C                   MOVE      DDLODY        WDAY
     C     BBABLRT       IFEQ      'N'
     C     WDAY          ANDNE     *ZEROS
      * Backward-Looking Rate is N and Lockout Days is not 0
     C                   MOVE      'N'           DDLODYOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDLODY'      FldNamXAr(Idx)
     C                   MOVEL     '5049421'     MsgIdXAr(Idx)
     C                   ENDIF
      *
     C                   ENDIF                                                  END numeric
     C                   ENDIF                                                  END default
     C                   ELSE                                                   CLE172=OFF
     C                   MOVE      '00'          DDLODY                          Default: 00
     C                   ENDIF
      *
     C     DDLODYOK      IFNE      'N'
     C                   MOVE      DDLODY        VLODY
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRPDLY - Validate payment delay days                         *
      *****************************************************************
     C     SRPDLY        BEGSR
      *
     C     CLE172        IFEQ      *ON                                          CLE172=ON
     C     DDPDLY        IFEQ      *BLANKS
     C                   MOVE      BBAPDLY       DDPDLY                         Default from
      *                                                                          SDBSRTPD
     C                   ELSE
     C                   MOVE      DDPDLY        #1TESTN                        Check if
     C     #1TESTN       SCAN      NUMBLANK      #1CHARPOS                       numeric
     C                   MOVEL     DDPDLY        #1TESTN
     C     #1TESTN       SCAN      NUMBLANK      #2CHARPOS
      *
     C     #1CHARPOS     IFEQ      *ZERO
     C     #2CHARPOS     OREQ      *ZERO
      * Payment Delay Days is not numeric
     C                   MOVE      'N'           DDPDLYOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDPDLY'      FldNamXAr(Idx)
     C                   MOVEL     '5049425'     MsgIdXAr(Idx)
     C                   ELSE                                                   If numeric
      *
     C                   MOVE      DDPDLY        WDAY
     C     BBABLRT       IFEQ      'N'
     C     WDAY          ANDNE     *ZEROS
      * Backward-Looking Rate is N and Payment Delay Days is not 0
     C                   MOVE      'N'           DDPDLYOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDPDLY'      FldNamXAr(Idx)
     C                   MOVEL     '5049422'     MsgIdXAr(Idx)
     C                   ENDIF
      *
     C                   ENDIF                                                  END numeric
     C                   ENDIF                                                  END default
     C                   ELSE                                                   CLE172=OFF
     C                   MOVE      '00'          DDPDLY                          Default: 00
     C                   ENDIF
      *
     C     DDPDLYOK      IFNE      'N'
     C                   MOVE      DDPDLY        VPDLY
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRBADJ - Validate benchmark adjustment                       *
      *****************************************************************
     C     SRBADJ        BEGSR
      *
     C     CLE172        IFEQ      *ON                                          CLE172=ON
     C     DDBADJ        IFEQ      *BLANKS                                      If blank
     C                   MOVE      BBABADJ       DDBADJ                         Default from
     C                   ENDIF                                                   SDBSRTPD
      *
     C                   MOVE      *BLANKS       @@ALPH
     C                   MOVE      DDBADJ        @@ALPH
     C                   CALLB     'ZA0841'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    @@ALPH                         Display field
     C                   PARM      8             @@IDP                          no.of dec.plcs
     C                   PARM      5             @@IINT                         no.of integers
     C                   PARM      'N'           @@MTID                         Mil/Thou
     C                   PARM      *ZERO         @@ERCD                         Error code
     C                   PARM      *ZERO         @@AMT                          File field
     C                   PARM                    DLBNDCSP
      *
     C     @@ERCD        IFNE      0
      * Benchmark Adjustment is not numeric
     C                   MOVE      'N'           DDBADJOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDBADJ'      FldNamXAr(Idx)
     C                   MOVEL     '5049426'     MsgIdXAr(Idx)
     C                   ELSE                                                   If numeric
      *
     C                   MOVE      @@ALPH        DDBADJ
     C                   MOVEL     DDBADJ        IntBadj
     C                   MOVE      DDBADJ        DecBadj
     C                   MOVEA     IntBadj       ArrayBadj(1)
     C                   MOVEA     DLBNDCSP      ArrayBadj(6)
     C                   MOVEA     DecBadj       ArrayBadj(7)
      *
     C     '-'           SCAN      @@ALPH        PTBADJ
     C     PTBADJ        IFNE      0
     C                   MOVE      '-'           PZFSign
     C                   MOVEA     '- '          ArrayBadj(8)
     C                   ENDIF
     C                   MOVEA     ArrayBadj     PZFld17
      *
     C                   CALLB     'ZASIGN'
     C                   PARM      'Y'           PZASignOk
     C                   PARM                    PZFld17
     C                   PARM      5             PZDig
     C                   PARM      8             PZDec
     C                   PARM      DLBNDCSP      PZSDCSP
     C                   PARM                    PZOut15
     C                   PARM                    PZFSign
     C                   MOVE      PZOut15       WNumBadj
      *
     C     BBABLRT       IFEQ      'N'
     C     WNumBadj      ANDNE     *ZEROS
      * Backward-Looking Rate is N and Benchmark Adjustment is not 0
     C                   MOVE      'N'           DDBADJOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDBADJ'      FldNamXAr(Idx)
     C                   MOVEL     '5049401'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF                                                  END numeric
      *
     C                   ELSE                                                   CLE172=OFF
     C                   MOVE      '0'           DDBADJ                          Default: 0
     C                   ENDIF
      *
     C     DDBADJOK      IFNE      'N'
     C                   MOVE      DDBADJ        VBADJ
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRAVOP - Validate averaging option                           *
      *****************************************************************
     C     SRAVOP        BEGSR
      *
     C     CLE172        IFEQ      *ON                                          CLE172=ON
     C     DDAVOP        IFEQ      *BLANKS
     C                   MOVE      BBAAVOP       DDAVOP                         Default from
     C                   ELSE                                                    SDBSRTPD
      *
     C     DDAVOP        IFNE      '1'
     C     DDAVOP        ANDNE     '2'
     C     DDAVOP        ANDNE     '3'
     C     DDAVOP        ANDNE     '4'
      * Averaging Option value is invalid
     C                   MOVE      'N'           DDAVOPOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDAVOP'      FldNamXAr(Idx)
     C                   MOVEL     '5049403'     MsgIdXAr(Idx)
     C                   ELSE                                                   If valid
      *
     C     BBABLRT       IFEQ      'N'
      * Backward-Looking Rate is N and Averaging Option is not blank
     C                   MOVE      'N'           DDAVOPOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDAVOP'      FldNamXAr(Idx)
     C                   MOVEL     '5049405'     MsgIdXAr(Idx)
     C                   ENDIF
      *
     C                   ENDIF                                                  END valid
     C                   ENDIF                                                  END default
     C                   ELSE                                                   CLE172=OFF
     C                   MOVE      *BLANKS       DDAVOP                          Default:blank
     C                   ENDIF
      *
     C     DDAVOPOK      IFNE      'N'
     C                   MOVE      DDAVOP        VAVOP
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRCART - Validate compounded/average rate                    *
      *****************************************************************
     C     SRCART        BEGSR
      *
     C     CLE172        IFEQ      *ON                                          CLE172=ON
     C     DDCART        IFEQ      *BLANKS                                      If blank
     C                   MOVE      '0'           DDCART                          Default: 0
     C                   ENDIF
      *
     C                   MOVE      *BLANKS       @@ALPH
     C                   MOVE      DDCART        @@ALPH
     C                   CALLB     'ZA0841'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    @@ALPH                         Display field
     C                   PARM      8             @@IDP                          no.of dec.plcs
     C                   PARM      5             @@IINT                         no.of integers
     C                   PARM      'N'           @@MTID                         Mil/Thou
     C                   PARM      *ZERO         @@ERCD                         Error code
     C                   PARM      *ZERO         @@AMT                          File field
     C                   PARM                    DLBNDCSP
      *
     C     @@ERCD        IFNE      0
      * Compounded/Average rate is not numeric
     C                   MOVE      'N'           DDCARTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCART'      FldNamXAr(Idx)
     C                   MOVEL     '5049426'     MsgIdXAr(Idx)
     C                   ELSE                                                   If numeric
      *
     C                   MOVE      @@ALPH        DDCART
     C                   MOVEL     DDCART        IntCart
     C                   MOVE      DDCART        DecCart
     C                   MOVEA     IntCart       ArrayCart(1)
     C                   MOVEA     DLBNDCSP      ArrayCart(6)
     C                   MOVEA     DecCart       ArrayCart(7)
      *
     C     '-'           SCAN      @@ALPH        PTCART
     C     PTCART        IFNE      0
     C                   MOVE      '-'           PZFSign
     C                   MOVEA     '- '          ArrayCart(8)
     C                   ENDIF
     C                   MOVEA     ArrayCart     PZFld17
      *
     C                   CALLB     'ZASIGN'
     C                   PARM      'Y'           PZASignOk
     C                   PARM                    PZFld17
     C                   PARM      5             PZDig
     C                   PARM      8             PZDec
     C                   PARM      DLBNDCSP      PZSDCSP
     C                   PARM                    PZOut15
     C                   PARM                    PZFSign
     C                   MOVE      PZOut15       WNumCart
      *
     C     BBABLRT       IFEQ      'N'
     C     WNumCart      ANDNE     *ZEROS
      * Backward-looking rate is N and Compounded/Average rate is not 0
     C                   MOVE      'N'           DDCARTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCART'      FldNamXAr(Idx)
     C                   MOVEL     '5049401'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF                                                  END numeric
      *
     C                   ELSE                                                   CLE172=OFF
     C                   MOVE      '0'           DDCART                          Default: 0
     C                   ENDIF
      *
     C     DDCARTOK      IFNE      'N'
     C                   MOVE      DDCART        VCART
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRWGHT - Validate weight convention                          *
      *****************************************************************
     C     SRWGHT        BEGSR
      *
     C     CLE172        IFEQ      *ON                                          CLE172=ON
     C     DDWGHT        IFEQ      *BLANKS
     C                   MOVE      BBAWGHT       DDWGHT                         Default from
     C                   ELSE                                                    SDBSRTPD
      *
     C     DDWGHT        IFNE      '1'
     C     DDWGHT        ANDNE     '2'
      * Weight Convention value is invalid
     C                   MOVE      'N'           DDWGHTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDWGHT'      FldNamXAr(Idx)
     C                   MOVEL     '5049408'     MsgIdXAr(Idx)
     C                   ELSE                                                   If valid
      *
     C     BBABLRT       IFEQ      'N'
      * Backward-Looking Rate is N and Weight Convention is not blank
     C                   MOVE      'N'           DDWGHTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDWGHT'      FldNamXAr(Idx)
     C                   MOVEL     '5049455'     MsgIdXAr(Idx)
     C                   ENDIF
      *
     C     DDAVOP        IFNE      '1'
     C     DDAVOP        ANDNE     '2'
      * Averaging Option is not 1/2 and Weight Convention is not blank
     C                   MOVE      'N'           DDWGHTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDWGHT'      FldNamXAr(Idx)
     C                   MOVEL     '5049453'     MsgIdXAr(Idx)
     C                   ENDIF
      *
     C                   ENDIF                                                  END valid
     C                   ENDIF                                                  END default
     C                   ELSE                                                   CLE172=OFF
     C                   MOVE      *BLANKS       DDWGHT
     C                   ENDIF
      *
     C     DDWGHTOK      IFNE      'N'
     C                   MOVE      DDWGHT        VWGHT
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRBRAC - Validate base rate for accrual                      *
      *****************************************************************
     C     SRBRAC        BEGSR
      *
     C     CLE172        IFEQ      *ON                                          CLE172=ON
     C                   MOVE      BBABRAC       DDBRAC                         Default from
      *                                                                          SDBSRTPD
     C                   ELSE                                                   CLE172=OFF
     C                   MOVE      *BLANKS       DDBRAC                          Default:blank
     C                   ENDIF
      *
     C                   MOVE      DDBRAC        VBRAC
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRLBAC - Validate lookback days for accrual                  *
      *****************************************************************
     C     SRLBAC        BEGSR
      *
     C                   MOVE      '00'          DDLBAC                         Default: 00
      *
     C     DDBRAC        IFNE      *BLANKS
     C                   CALLB     'AOBSRTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      WFCYCD        PKEY1
     C                   PARM      BBABRAC       PKEY2
     C     SDBRACDS      PARM      SDBRACDS      DSSDY
      *
     C     PRTCD         IFEQ      *BLANKS                                      If found BRAC
     C     CLE172        ANDEQ     *ON                                           & CLE172=ON
     C                   MOVE      ZBALBDY       DDLBAC
     C                   ENDIF
     C                   ENDIF
      *
     C                   MOVE      DDLBAC        VLBAC
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRPIAD - Validate principal interest control date            *
      *****************************************************************
     C     SRPIAD        BEGSR
      *
     C                   MOVE      0             VPIAD                          Deafult: 0
      *
     C                   ENDSR
      *
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      * Called by: (**calling routines**)                                 *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************

     C     *PSSR         BEGSR

     C                   DUMP

     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'

     C                   CALLB     'DBERRCTL'

     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR

      ********************************************************************
**  CPY@
(c) Finastra International Limited 2004
