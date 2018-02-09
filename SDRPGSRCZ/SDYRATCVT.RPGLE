     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Yield Rates Convert')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDYRATCVT - Yield Rates Convert                              *
      *                                                               *
      *  Function:  This module converts the fields of a Yield Rate   *
      *             Transaction Detail from file to screen format     *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD030900           Date 26Jun15               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CAS008             Date 16Jun04               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001  *CREATE    Date 23Nov01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD030900 - Display negative rates properly                   *
      *  CRE026 - Consumer Banking                                    *
      *  CAS008 - IAS 39 Enhancements                                 *
      *  CAS001 - Net Present Value (NPV) Accounting                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    None                                                       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRSavArr - Saves Rate, Maturity Date & Discount Factor        *
      * SRScreen - Set Screen Fields                                  *
      * SRZDate2 - Format a Date for Output                           *
      * SRZEdit- Edit an Unsigned Field                               *
      * SRFmtRate - Move Rate to Screen File Fields                   *
      * SRInit- Initialisation                                        *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
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
 
      ** Period Years Array
     D PYrAr           S              2    DIM(98)
 
      ** Period Month Array
     D PMnAr           S              2    DIM(98)
 
      ** Period Days Array
     D PDyAr           S              2    DIM(98)
 
      ** Maturity Date Array
     D PMatAr          S              5P 0 DIM(98)
 
      ** Discount Factor Array
     D PDisAr          S             13P 9 DIM(98)
 
      ** Rate Array
     D PRatAr          S             13P 9 DIM(98)
 
      ** Output Array for Rate
     D WRatAr          S             14    DIM(98)
 
      ** Output Parameter Array for Maturity Date and Discount Factor
     D MatDateArr      S              7    DIM(98)
     D DiscFacArr      S             14    DIM(98)
 
      ** Yield Rates Transaction Details in File Format
     D YRATFilFmt    E DS                  EXTNAME(SDVYRATPD)
 
      ** Yield Rates Transaction Details in Screen Format
     D YRATScnFmt    E DS                  EXTNAME(SDYRATPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for switchable features                                                  CAS008
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CAS008
                                                                                              CAS008
      ** Yield Curves Master File
     D SDYLDC        E DS                  EXTNAME(SDYLDCPD)
     D                                     PREFIX(C_)
 
      ** First DS for Access Programs, Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for Access Programs, Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D WAction         S              1
 
     D A               S              4  0
     D B               S              4  0
     D C               S              4  0
     D D               S              4  0
 
     D WYRDta          S           2339
 
     D PRtCd           S              7
     D POptn           S              7
     D PSard           S              6                                                       CAS008
 
     D ZDayNo          S              5  0
     D ZDate           S              6  0
     D ZADate          S              7
 
     D ZField          S             16
     D ZADec           S              1  0
                                                                                              CAS008
      ** Switchable Features                                                                  CAS008
     D CAS008          S              1                                                       CAS008
     D WRKPDY          S              2  0                                                    CRE026
 
                                                                                            MD030900
      **                                                                                    MD030900
     DCharRate         S             14                                                     MD030900
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      **************************************************************
      /EJECT
      **************************************************************
 
      ** Initialization
 
     C                   EXSR      SRInit
 
      ** Save file fields to an array
 
     C                   EXSR      SRSavArr
 
      ** Set screen fields
 
     C                   EXSR      SRScreen
 
      ** Return
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSavArr - Saves Rate, Maturity Date & Discount Factor        *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRSavArr      BEGSR
 
     C                   EVAL      PMatAr(1) = FSMMDN01
     C                   EVAL      PMatAr(2) = FSMMDN02
     C                   EVAL      PMatAr(3) = FSMMDN03
     C                   EVAL      PMatAr(4) = FSMMDN04
     C                   EVAL      PMatAr(5) = FSMMDN05
     C                   EVAL      PMatAr(6) = FSMMDN06
     C                   EVAL      PMatAr(7) = FSMMDN07
     C                   EVAL      PMatAr(8) = FSMMDN08
     C                   EVAL      PMatAr(9) = FSMMDN09
     C                   EVAL      PMatAr(10) = FSMMDN10
     C                   EVAL      PMatAr(11) = FSMMDN11
     C                   EVAL      PMatAr(12) = FSMMDN12
     C                   EVAL      PMatAr(13) = FSMMDN13
     C                   EVAL      PMatAr(14) = FSMMDN14
     C                   EVAL      PMatAr(15) = FSMMDN15
     C                   EVAL      PMatAr(16) = FSMMDN16
     C                   EVAL      PMatAr(17) = FSMMDN17
     C                   EVAL      PMatAr(18) = FSMMDN18
     C                   EVAL      PMatAr(19) = FSMMDN19
     C                   EVAL      PMatAr(20) = FSMMDN20
     C                   EVAL      PMatAr(21) = FSMMDN21
     C                   EVAL      PMatAr(22) = FSMMDN22
     C                   EVAL      PMatAr(23) = FSMMDN23
     C                   EVAL      PMatAr(24) = FSMMDN24
     C                   EVAL      PMatAr(25) = FSMMDN25
     C                   EVAL      PMatAr(26) = FSMMDN26
     C                   EVAL      PMatAr(27) = FSMMDN27
     C                   EVAL      PMatAr(28) = FSMMDN28
     C                   EVAL      PMatAr(29) = FSMMDN29
     C                   EVAL      PMatAr(30) = FSMMDN30
     C                   EVAL      PMatAr(31) = FSMMDN31
     C                   EVAL      PMatAr(32) = FSMMDN32
     C                   EVAL      PMatAr(33) = FSMMDN33
     C                   EVAL      PMatAr(34) = FSMMDN34
     C                   EVAL      PMatAr(35) = FSMMDN35
     C                   EVAL      PMatAr(36) = FSMMDN36
     C                   EVAL      PMatAr(37) = FSMMDN37
     C                   EVAL      PMatAr(38) = FSMMDN38
     C                   EVAL      PMatAr(39) = FSMMDN39
     C                   EVAL      PMatAr(40) = FSMMDN40
     C                   EVAL      PMatAr(41) = FSMMDN41
     C                   EVAL      PMatAr(42) = FSMMDN42
     C                   EVAL      PMatAr(43) = FSMMDN43
     C                   EVAL      PMatAr(44) = FSMMDN44
     C                   EVAL      PMatAr(45) = FSMMDN45
     C                   EVAL      PMatAr(46) = FSMMDN46
     C                   EVAL      PMatAr(47) = FSMMDN47
     C                   EVAL      PMatAr(48) = FSMMDN48
     C                   EVAL      PMatAr(49) = FSMMDN49
     C                   EVAL      PMatAr(50) = FSMMDN50
     C                   EVAL      PMatAr(51) = FSMMDN51
     C                   EVAL      PMatAr(52) = FSMMDN52
     C                   EVAL      PMatAr(53) = FSMMDN53
     C                   EVAL      PMatAr(54) = FSMMDN54
     C                   EVAL      PMatAr(55) = FSMMDN55
     C                   EVAL      PMatAr(56) = FSMMDN56
     C                   EVAL      PMatAr(57) = FSMMDN57
     C                   EVAL      PMatAr(58) = FSMMDN58
     C                   EVAL      PMatAr(59) = FSMMDN59
     C                   EVAL      PMatAr(60) = FSMMDN60
     C                   EVAL      PMatAr(61) = FSMMDN61
     C                   EVAL      PMatAr(62) = FSMMDN62
     C                   EVAL      PMatAr(63) = FSMMDN63
     C                   EVAL      PMatAr(64) = FSMMDN64
     C                   EVAL      PMatAr(65) = FSMMDN65
     C                   EVAL      PMatAr(66) = FSMMDN66
     C                   EVAL      PMatAr(67) = FSMMDN67
     C                   EVAL      PMatAr(68) = FSMMDN68
     C                   EVAL      PMatAr(69) = FSMMDN69
     C                   EVAL      PMatAr(70) = FSMMDN70
     C                   EVAL      PMatAr(71) = FSMMDN71
     C                   EVAL      PMatAr(72) = FSMMDN72
     C                   EVAL      PMatAr(73) = FSMMDN73
     C                   EVAL      PMatAr(74) = FSMMDN74
     C                   EVAL      PMatAr(75) = FSMMDN75
     C                   EVAL      PMatAr(76) = FSMMDN76
     C                   EVAL      PMatAr(77) = FSMMDN77
     C                   EVAL      PMatAr(78) = FSMMDN78
     C                   EVAL      PMatAr(79) = FSMMDN79
     C                   EVAL      PMatAr(80) = FSMMDN80
     C                   EVAL      PMatAr(81) = FSMMDN81
     C                   EVAL      PMatAr(82) = FSMMDN82
     C                   EVAL      PMatAr(83) = FSMMDN83
     C                   EVAL      PMatAr(84) = FSMMDN84
     C                   EVAL      PMatAr(85) = FSMMDN85
     C                   EVAL      PMatAr(86) = FSMMDN86
     C                   EVAL      PMatAr(87) = FSMMDN87
     C                   EVAL      PMatAr(88) = FSMMDN88
     C                   EVAL      PMatAr(89) = FSMMDN89
     C                   EVAL      PMatAr(90) = FSMMDN90
     C                   EVAL      PMatAr(91) = FSMMDN91
     C                   EVAL      PMatAr(92) = FSMMDN92
     C                   EVAL      PMatAr(93) = FSMMDN93
     C                   EVAL      PMatAr(94) = FSMMDN94
     C                   EVAL      PMatAr(95) = FSMMDN95
     C                   EVAL      PMatAr(96) = FSMMDN96
     C                   EVAL      PMatAr(97) = FSMMDN97
     C                   EVAL      PMatAr(98) = FSMMDN98
 
     C                   EVAL      PDisAr(1) = FSDSCF01
     C                   EVAL      PDisAr(2) = FSDSCF02
     C                   EVAL      PDisAr(3) = FSDSCF03
     C                   EVAL      PDisAr(4) = FSDSCF04
     C                   EVAL      PDisAr(5) = FSDSCF05
     C                   EVAL      PDisAr(6) = FSDSCF06
     C                   EVAL      PDisAr(7) = FSDSCF07
     C                   EVAL      PDisAr(8) = FSDSCF08
     C                   EVAL      PDisAr(9) = FSDSCF09
     C                   EVAL      PDisAr(10) = FSDSCF10
     C                   EVAL      PDisAr(11) = FSDSCF11
     C                   EVAL      PDisAr(12) = FSDSCF12
     C                   EVAL      PDisAr(13) = FSDSCF13
     C                   EVAL      PDisAr(14) = FSDSCF14
     C                   EVAL      PDisAr(15) = FSDSCF15
     C                   EVAL      PDisAr(16) = FSDSCF16
     C                   EVAL      PDisAr(17) = FSDSCF17
     C                   EVAL      PDisAr(18) = FSDSCF18
     C                   EVAL      PDisAr(19) = FSDSCF19
     C                   EVAL      PDisAr(20) = FSDSCF20
     C                   EVAL      PDisAr(21) = FSDSCF21
     C                   EVAL      PDisAr(22) = FSDSCF22
     C                   EVAL      PDisAr(23) = FSDSCF23
     C                   EVAL      PDisAr(24) = FSDSCF24
     C                   EVAL      PDisAr(25) = FSDSCF25
     C                   EVAL      PDisAr(26) = FSDSCF26
     C                   EVAL      PDisAr(27) = FSDSCF27
     C                   EVAL      PDisAr(28) = FSDSCF28
     C                   EVAL      PDisAr(29) = FSDSCF29
     C                   EVAL      PDisAr(30) = FSDSCF30
     C                   EVAL      PDisAr(31) = FSDSCF31
     C                   EVAL      PDisAr(32) = FSDSCF32
     C                   EVAL      PDisAr(33) = FSDSCF33
     C                   EVAL      PDisAr(34) = FSDSCF34
     C                   EVAL      PDisAr(35) = FSDSCF35
     C                   EVAL      PDisAr(36) = FSDSCF36
     C                   EVAL      PDisAr(37) = FSDSCF37
     C                   EVAL      PDisAr(38) = FSDSCF38
     C                   EVAL      PDisAr(39) = FSDSCF39
     C                   EVAL      PDisAr(40) = FSDSCF40
     C                   EVAL      PDisAr(41) = FSDSCF41
     C                   EVAL      PDisAr(42) = FSDSCF42
     C                   EVAL      PDisAr(43) = FSDSCF43
     C                   EVAL      PDisAr(44) = FSDSCF44
     C                   EVAL      PDisAr(45) = FSDSCF45
     C                   EVAL      PDisAr(46) = FSDSCF46
     C                   EVAL      PDisAr(47) = FSDSCF47
     C                   EVAL      PDisAr(48) = FSDSCF48
     C                   EVAL      PDisAr(49) = FSDSCF49
     C                   EVAL      PDisAr(50) = FSDSCF50
     C                   EVAL      PDisAr(51) = FSDSCF51
     C                   EVAL      PDisAr(52) = FSDSCF52
     C                   EVAL      PDisAr(53) = FSDSCF53
     C                   EVAL      PDisAr(54) = FSDSCF54
     C                   EVAL      PDisAr(55) = FSDSCF55
     C                   EVAL      PDisAr(56) = FSDSCF56
     C                   EVAL      PDisAr(57) = FSDSCF57
     C                   EVAL      PDisAr(58) = FSDSCF58
     C                   EVAL      PDisAr(59) = FSDSCF59
     C                   EVAL      PDisAr(60) = FSDSCF60
     C                   EVAL      PDisAr(61) = FSDSCF61
     C                   EVAL      PDisAr(62) = FSDSCF62
     C                   EVAL      PDisAr(63) = FSDSCF63
     C                   EVAL      PDisAr(64) = FSDSCF64
     C                   EVAL      PDisAr(65) = FSDSCF65
     C                   EVAL      PDisAr(66) = FSDSCF66
     C                   EVAL      PDisAr(67) = FSDSCF67
     C                   EVAL      PDisAr(68) = FSDSCF68
     C                   EVAL      PDisAr(69) = FSDSCF69
     C                   EVAL      PDisAr(70) = FSDSCF70
     C                   EVAL      PDisAr(71) = FSDSCF71
     C                   EVAL      PDisAr(72) = FSDSCF72
     C                   EVAL      PDisAr(73) = FSDSCF73
     C                   EVAL      PDisAr(74) = FSDSCF74
     C                   EVAL      PDisAr(75) = FSDSCF75
     C                   EVAL      PDisAr(76) = FSDSCF76
     C                   EVAL      PDisAr(77) = FSDSCF77
     C                   EVAL      PDisAr(78) = FSDSCF78
     C                   EVAL      PDisAr(79) = FSDSCF79
     C                   EVAL      PDisAr(80) = FSDSCF80
     C                   EVAL      PDisAr(81) = FSDSCF81
     C                   EVAL      PDisAr(82) = FSDSCF82
     C                   EVAL      PDisAr(83) = FSDSCF83
     C                   EVAL      PDisAr(84) = FSDSCF84
     C                   EVAL      PDisAr(85) = FSDSCF85
     C                   EVAL      PDisAr(86) = FSDSCF86
     C                   EVAL      PDisAr(87) = FSDSCF87
     C                   EVAL      PDisAr(88) = FSDSCF88
     C                   EVAL      PDisAr(89) = FSDSCF89
     C                   EVAL      PDisAr(90) = FSDSCF90
     C                   EVAL      PDisAr(91) = FSDSCF91
     C                   EVAL      PDisAr(92) = FSDSCF92
     C                   EVAL      PDisAr(93) = FSDSCF93
     C                   EVAL      PDisAr(94) = FSDSCF94
     C                   EVAL      PDisAr(95) = FSDSCF95
     C                   EVAL      PDisAr(96) = FSDSCF96
     C                   EVAL      PDisAr(97) = FSDSCF97
     C                   EVAL      PDisAr(98) = FSDSCF98
 
     C                   IF        C_FSYLDT = 'D'
     C                   EVAL      PRatAr(1) = FSDSCF01
     C                   EVAL      PRatAr(2) = FSDSCF02
     C                   EVAL      PRatAr(3) = FSDSCF03
     C                   EVAL      PRatAr(4) = FSDSCF04
     C                   EVAL      PRatAr(5) = FSDSCF05
     C                   EVAL      PRatAr(6) = FSDSCF06
     C                   EVAL      PRatAr(7) = FSDSCF07
     C                   EVAL      PRatAr(8) = FSDSCF08
     C                   EVAL      PRatAr(9) = FSDSCF09
     C                   EVAL      PRatAr(10) = FSDSCF10
     C                   EVAL      PRatAr(11) = FSDSCF11
     C                   EVAL      PRatAr(12) = FSDSCF12
     C                   EVAL      PRatAr(13) = FSDSCF13
     C                   EVAL      PRatAr(14) = FSDSCF14
     C                   EVAL      PRatAr(15) = FSDSCF15
     C                   EVAL      PRatAr(16) = FSDSCF16
     C                   EVAL      PRatAr(17) = FSDSCF17
     C                   EVAL      PRatAr(18) = FSDSCF18
     C                   EVAL      PRatAr(19) = FSDSCF19
     C                   EVAL      PRatAr(20) = FSDSCF20
     C                   EVAL      PRatAr(21) = FSDSCF21
     C                   EVAL      PRatAr(22) = FSDSCF22
     C                   EVAL      PRatAr(23) = FSDSCF23
     C                   EVAL      PRatAr(24) = FSDSCF24
     C                   EVAL      PRatAr(25) = FSDSCF25
     C                   EVAL      PRatAr(26) = FSDSCF26
     C                   EVAL      PRatAr(27) = FSDSCF27
     C                   EVAL      PRatAr(28) = FSDSCF28
     C                   EVAL      PRatAr(29) = FSDSCF29
     C                   EVAL      PRatAr(30) = FSDSCF30
     C                   EVAL      PRatAr(31) = FSDSCF31
     C                   EVAL      PRatAr(32) = FSDSCF32
     C                   EVAL      PRatAr(33) = FSDSCF33
     C                   EVAL      PRatAr(34) = FSDSCF34
     C                   EVAL      PRatAr(35) = FSDSCF35
     C                   EVAL      PRatAr(36) = FSDSCF36
     C                   EVAL      PRatAr(37) = FSDSCF37
     C                   EVAL      PRatAr(38) = FSDSCF38
     C                   EVAL      PRatAr(39) = FSDSCF39
     C                   EVAL      PRatAr(40) = FSDSCF40
     C                   EVAL      PRatAr(41) = FSDSCF41
     C                   EVAL      PRatAr(42) = FSDSCF42
     C                   EVAL      PRatAr(43) = FSDSCF43
     C                   EVAL      PRatAr(44) = FSDSCF44
     C                   EVAL      PRatAr(45) = FSDSCF45
     C                   EVAL      PRatAr(46) = FSDSCF46
     C                   EVAL      PRatAr(47) = FSDSCF47
     C                   EVAL      PRatAr(48) = FSDSCF48
     C                   EVAL      PRatAr(49) = FSDSCF49
     C                   EVAL      PRatAr(50) = FSDSCF50
     C                   EVAL      PRatAr(51) = FSDSCF51
     C                   EVAL      PRatAr(52) = FSDSCF52
     C                   EVAL      PRatAr(53) = FSDSCF53
     C                   EVAL      PRatAr(54) = FSDSCF54
     C                   EVAL      PRatAr(55) = FSDSCF55
     C                   EVAL      PRatAr(56) = FSDSCF56
     C                   EVAL      PRatAr(57) = FSDSCF57
     C                   EVAL      PRatAr(58) = FSDSCF58
     C                   EVAL      PRatAr(59) = FSDSCF59
     C                   EVAL      PRatAr(60) = FSDSCF60
     C                   EVAL      PRatAr(61) = FSDSCF61
     C                   EVAL      PRatAr(62) = FSDSCF62
     C                   EVAL      PRatAr(63) = FSDSCF63
     C                   EVAL      PRatAr(64) = FSDSCF64
     C                   EVAL      PRatAr(65) = FSDSCF65
     C                   EVAL      PRatAr(66) = FSDSCF66
     C                   EVAL      PRatAr(67) = FSDSCF67
     C                   EVAL      PRatAr(68) = FSDSCF68
     C                   EVAL      PRatAr(69) = FSDSCF69
     C                   EVAL      PRatAr(70) = FSDSCF70
     C                   EVAL      PRatAr(71) = FSDSCF71
     C                   EVAL      PRatAr(72) = FSDSCF72
     C                   EVAL      PRatAr(73) = FSDSCF73
     C                   EVAL      PRatAr(74) = FSDSCF74
     C                   EVAL      PRatAr(75) = FSDSCF75
     C                   EVAL      PRatAr(76) = FSDSCF76
     C                   EVAL      PRatAr(77) = FSDSCF77
     C                   EVAL      PRatAr(78) = FSDSCF78
     C                   EVAL      PRatAr(79) = FSDSCF79
     C                   EVAL      PRatAr(80) = FSDSCF80
     C                   EVAL      PRatAr(81) = FSDSCF81
     C                   EVAL      PRatAr(82) = FSDSCF82
     C                   EVAL      PRatAr(83) = FSDSCF83
     C                   EVAL      PRatAr(84) = FSDSCF84
     C                   EVAL      PRatAr(85) = FSDSCF85
     C                   EVAL      PRatAr(86) = FSDSCF86
     C                   EVAL      PRatAr(87) = FSDSCF87
     C                   EVAL      PRatAr(88) = FSDSCF88
     C                   EVAL      PRatAr(89) = FSDSCF89
     C                   EVAL      PRatAr(90) = FSDSCF90
     C                   EVAL      PRatAr(91) = FSDSCF91
     C                   EVAL      PRatAr(92) = FSDSCF92
     C                   EVAL      PRatAr(93) = FSDSCF93
     C                   EVAL      PRatAr(94) = FSDSCF94
     C                   EVAL      PRatAr(95) = FSDSCF95
     C                   EVAL      PRatAr(96) = FSDSCF96
     C                   EVAL      PRatAr(97) = FSDSCF97
     C                   EVAL      PRatAr(98) = FSDSCF98
     C                   ELSE
     C                   EVAL      PRatAr(1) = FSYRAT01
     C                   EVAL      PRatAr(2) = FSYRAT02
     C                   EVAL      PRatAr(3) = FSYRAT03
     C                   EVAL      PRatAr(4) = FSYRAT04
     C                   EVAL      PRatAr(5) = FSYRAT05
     C                   EVAL      PRatAr(6) = FSYRAT06
     C                   EVAL      PRatAr(7) = FSYRAT07
     C                   EVAL      PRatAr(8) = FSYRAT08
     C                   EVAL      PRatAr(9) = FSYRAT09
     C                   EVAL      PRatAr(10) = FSYRAT10
     C                   EVAL      PRatAr(11) = FSYRAT11
     C                   EVAL      PRatAr(12) = FSYRAT12
     C                   EVAL      PRatAr(13) = FSYRAT13
     C                   EVAL      PRatAr(14) = FSYRAT14
     C                   EVAL      PRatAr(15) = FSYRAT15
     C                   EVAL      PRatAr(16) = FSYRAT16
     C                   EVAL      PRatAr(17) = FSYRAT17
     C                   EVAL      PRatAr(18) = FSYRAT18
     C                   EVAL      PRatAr(19) = FSYRAT19
     C                   EVAL      PRatAr(20) = FSYRAT20
     C                   EVAL      PRatAr(21) = FSYRAT21
     C                   EVAL      PRatAr(22) = FSYRAT22
     C                   EVAL      PRatAr(23) = FSYRAT23
     C                   EVAL      PRatAr(24) = FSYRAT24
     C                   EVAL      PRatAr(25) = FSYRAT25
     C                   EVAL      PRatAr(26) = FSYRAT26
     C                   EVAL      PRatAr(27) = FSYRAT27
     C                   EVAL      PRatAr(28) = FSYRAT28
     C                   EVAL      PRatAr(29) = FSYRAT29
     C                   EVAL      PRatAr(30) = FSYRAT30
     C                   EVAL      PRatAr(31) = FSYRAT31
     C                   EVAL      PRatAr(32) = FSYRAT32
     C                   EVAL      PRatAr(33) = FSYRAT33
     C                   EVAL      PRatAr(34) = FSYRAT34
     C                   EVAL      PRatAr(35) = FSYRAT35
     C                   EVAL      PRatAr(36) = FSYRAT36
     C                   EVAL      PRatAr(37) = FSYRAT37
     C                   EVAL      PRatAr(38) = FSYRAT38
     C                   EVAL      PRatAr(39) = FSYRAT39
     C                   EVAL      PRatAr(40) = FSYRAT40
     C                   EVAL      PRatAr(41) = FSYRAT41
     C                   EVAL      PRatAr(42) = FSYRAT42
     C                   EVAL      PRatAr(43) = FSYRAT43
     C                   EVAL      PRatAr(44) = FSYRAT44
     C                   EVAL      PRatAr(45) = FSYRAT45
     C                   EVAL      PRatAr(46) = FSYRAT46
     C                   EVAL      PRatAr(47) = FSYRAT47
     C                   EVAL      PRatAr(48) = FSYRAT48
     C                   EVAL      PRatAr(49) = FSYRAT49
     C                   EVAL      PRatAr(50) = FSYRAT50
     C                   EVAL      PRatAr(51) = FSYRAT51
     C                   EVAL      PRatAr(52) = FSYRAT52
     C                   EVAL      PRatAr(53) = FSYRAT53
     C                   EVAL      PRatAr(54) = FSYRAT54
     C                   EVAL      PRatAr(55) = FSYRAT55
     C                   EVAL      PRatAr(56) = FSYRAT56
     C                   EVAL      PRatAr(57) = FSYRAT57
     C                   EVAL      PRatAr(58) = FSYRAT58
     C                   EVAL      PRatAr(59) = FSYRAT59
     C                   EVAL      PRatAr(60) = FSYRAT60
     C                   EVAL      PRatAr(61) = FSYRAT61
     C                   EVAL      PRatAr(62) = FSYRAT62
     C                   EVAL      PRatAr(63) = FSYRAT63
     C                   EVAL      PRatAr(64) = FSYRAT64
     C                   EVAL      PRatAr(65) = FSYRAT65
     C                   EVAL      PRatAr(66) = FSYRAT66
     C                   EVAL      PRatAr(67) = FSYRAT67
     C                   EVAL      PRatAr(68) = FSYRAT68
     C                   EVAL      PRatAr(69) = FSYRAT69
     C                   EVAL      PRatAr(70) = FSYRAT70
     C                   EVAL      PRatAr(71) = FSYRAT71
     C                   EVAL      PRatAr(72) = FSYRAT72
     C                   EVAL      PRatAr(73) = FSYRAT73
     C                   EVAL      PRatAr(74) = FSYRAT74
     C                   EVAL      PRatAr(75) = FSYRAT75
     C                   EVAL      PRatAr(76) = FSYRAT76
     C                   EVAL      PRatAr(77) = FSYRAT77
     C                   EVAL      PRatAr(78) = FSYRAT78
     C                   EVAL      PRatAr(79) = FSYRAT79
     C                   EVAL      PRatAr(80) = FSYRAT80
     C                   EVAL      PRatAr(81) = FSYRAT81
     C                   EVAL      PRatAr(82) = FSYRAT82
     C                   EVAL      PRatAr(83) = FSYRAT83
     C                   EVAL      PRatAr(84) = FSYRAT84
     C                   EVAL      PRatAr(85) = FSYRAT85
     C                   EVAL      PRatAr(86) = FSYRAT86
     C                   EVAL      PRatAr(87) = FSYRAT87
     C                   EVAL      PRatAr(88) = FSYRAT88
     C                   EVAL      PRatAr(89) = FSYRAT89
     C                   EVAL      PRatAr(90) = FSYRAT90
     C                   EVAL      PRatAr(91) = FSYRAT91
     C                   EVAL      PRatAr(92) = FSYRAT92
     C                   EVAL      PRatAr(93) = FSYRAT93
     C                   EVAL      PRatAr(94) = FSYRAT94
     C                   EVAL      PRatAr(95) = FSYRAT95
     C                   EVAL      PRatAr(96) = FSYRAT96
     C                   EVAL      PRatAr(97) = FSYRAT97
     C                   EVAL      PRatAr(98) = FSYRAT98
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRScreen - Set Screen Fields                                  *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SRZDate2, SRZEdit, SRFmtRate                           *
      *                                                               *
      *****************************************************************
 
     C     SRScreen      BEGSR
 
     C                   EVAL      #0YLDC = FSYLDC
     C                   EVAL      #0YCCY = FSYCCY
     C                   EVAL      #0YICM = FSYICM
     C                   EVAL      #0YCFQ = FSYCFQ
     C                   IF        CAS008 = 'Y'                                               CAS008
     C**********         MOVE      FSSPDY        #0SPDY                                CAS008 CRE026
     C                   Z-ADD     FSSPDY        WRKPDY                                       CRE026
     C                   MOVE      WRKPDY        #0SPDY                                       CRE026
     C                   ELSE                                                                 CRE026
     C                   MOVE      *BLANKS       #0SPDY                                       CRE026
     C                   ENDIF                                                                CAS008
 
     C                   EVAL      WYRDta = (%SUBST(YRATFilFmt:12:2328))
 
      ** Reset counters
 
     C                   EVAL      A = *ZERO
     C                   EVAL      B = *ZERO
     C                   EVAL      C = *ZERO
     C                   EVAL      D = *ZERO
 
     C                   EVAL      A = A + 1
     C                   EVAL      B = B + 4
     C                   EVAL      C = B + 2
     C                   EVAL      D = C + 2
 
      ** Format period years, months and days
 
     C                   DOW       A <= 98
 
     C                   EVAL      PYrAr(A) = (%SUBST(WYRDta:B:2))
     C                   EVAL      PMnAr(A) = (%SUBST(WYRDta:C:2))
     C                   EVAL      PDyAr(A) = (%SUBST(WYRDta:D:2))
 
     C                   EVAL      A = A + 1
     C                   EVAL      B = B + 23
     C                   EVAL      C = B + 2
     C                   EVAL      D = C + 2
 
     C                   ENDDO
 
      ** Move formatted year/month/days to screen fields
 
     C                   EVAL      A = 1
     C**********         EVAL      B = 12                                                     CAS008
     C                   EVAL      B = 14                                                     CAS008
 
      ** Period Years
 
     C                   DOW       A <= 98
     C                   IF        PRatAr(A) = *ZERO and A <> 1
     C                   EVAL      %SUBST(YRATScnFmt:B:2) = *BLANKS
     C                   ELSE
     C                   EVAL      %SUBST(YRATScnFmt:B:2) = PYrAr(A)
     C                   ENDIF
     C                   EVAL      A = A + 1
     C                   EVAL      B = B + 20
     C                   ENDDO
 
      ** Period Months
 
     C                   EVAL      A = 1
     C**********         EVAL      B = 14                                                     CAS008
     C                   EVAL      B = 16                                                     CAS008
 
     C                   DOW       A <= 98
     C                   IF        PRatAr(A) = *ZERO and A <> 1
     C                   EVAL      %SUBST(YRATScnFmt:B:2) = *BLANKS
     C                   ELSE
     C                   EVAL      %SUBST(YRATScnFmt:B:2) = PMnAr(A)
     C                   ENDIF
     C                   EVAL      A = A + 1
     C                   EVAL      B = B + 20
     C                   ENDDO
 
      ** Period Days
 
     C                   EVAL      A = 1
     C**********         EVAL      B = 16                                                     CAS008
     C                   EVAL      B = 18                                                     CAS008
 
     C                   DOW       A <= 98
     C                   IF        PRatAr(A) = *ZERO and A <> 1
     C                   EVAL      %SUBST(YRATScnFmt:B:2) = *BLANKS
     C                   ELSE
     C                   EVAL      %SUBST(YRATScnFmt:B:2) = PDyAr(A)
     C                   ENDIF
     C                   EVAL      A = A + 1
     C                   EVAL      B = B + 20
     C                   ENDDO
 
      ** Format Maturity Date, Rate and Discount Factor
 
     C                   EVAL       A = 1
 
     C                   DOW       A <= 98
 
     C                   IF        PMatAr(A) = *ZERO
     C                   EVAL      MatDateArr(A) = *BLANKS
     C                   ELSE
     C                   EVAL      ZDayNo = PMatAr(A)
     C                   EXSR      SRZDate2
     C                   MOVEL     ZADate        MatDateArr(A)
     C                   ENDIF
 
     C                   IF        PDisAr(A) = *ZERO
     C                   MOVEL     *BLANKS       DiscFacArr(A)
     C                   ELSE
     C                   MOVE      *BLANKS       ZField
     C                   MOVE      PDisAr(A)     ZField
     C                   EXSR      SRZEdit
     C                   MOVE      ZField        DiscFacArr(A)
     C                   ENDIF
 
     C                   IF        PRatAr(A) = *ZERO
     C                   MOVEL     *BLANKS       WRatAr(A)
     C                   ELSE
     C                   MOVE      *BLANKS       ZField
      *                                                                                     MD030900
      ** Check if rate is negative.                                                         MD030900
      *                                                                                     MD030900
     C                   MOVE      'N'           NEGINT            1                        MD030900
     C     PRatAr(A)     IFLT      0                                                        MD030900
     C                   MOVE      'Y'           NEGINT                                     MD030900
     C                   Z-SUB     PRatAr(A)     PRatAr(A)                                  MD030900
     C                   ENDIF                                                              MD030900
      *                                                                                     MD030900
     C                   MOVE      PRatAr(A)     ZField
     C                   EXSR      SRZEdit
     C                   MOVE      ZField        WRatAr(A)
      *                                                                                     MD030900
      ** Handle the display of negative rate.                                               MD030900
      *                                                                                     MD030900
     C     NEGINT        IFEQ      'Y'                                                      MD030900
     C                   MOVE      WRatAr(A)     WPerYRTe         13                        MD030900
     C     '-'           CAT       WPerYRTe      NegRate          14                        MD030900
     C                   EVAL      Negrate  = %TRIMR(Negrate)                               MD030900
     C                   MOVE      NegRate       WRatAr(A)                                  MD030900
     C                   ENDIF                                                              MD030900
      *                                                                                     MD030900
     C                   ENDIF
 
     C                   EVAL      A = A + 1
 
     C                   ENDDO
 
     C                   EXSR      SRFmtRate
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRZDate2 - Format a Date for Output                           *
      *                                                               *
      * Called by: SRScreen                                           *
      *                                                               *
      * Calls: ZDate2                                                 *
      *                                                               *
      *****************************************************************
 
     C     SRZDate2      BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDayNo
     C                   PARM                    BJDFIN
     C                   PARM                    ZDate
     C                   PARM                    ZADate
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRZEdit - Edit an Unsigned Field                              *
      *                                                               *
      * Called by: SRScreen                                           *
      *                                                               *
      * Calls: ZEdit                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRZEdit       BEGSR
 
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZField
     C                   PARM      9             ZADec
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRFmtRate - Move Rate to Screen File Fields                   *
      *                                                               *
      * Called by: SRScreen                                           *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRFmtRate     BEGSR
 
     C                   EVAL      #0YRAT01 = WRatAr(1)
     C                   EVAL      #0YRAT02 = WRatAr(2)
     C                   EVAL      #0YRAT03 = WRatAr(3)
     C                   EVAL      #0YRAT04 = WRatAr(4)
     C                   EVAL      #0YRAT05 = WRatAr(5)
     C                   EVAL      #0YRAT06 = WRatAr(6)
     C                   EVAL      #0YRAT07 = WRatAr(7)
     C                   EVAL      #0YRAT08 = WRatAr(8)
     C                   EVAL      #0YRAT09 = WRatAr(9)
     C                   EVAL      #0YRAT10 = WRatAr(10)
     C                   EVAL      #0YRAT11 = WRatAr(11)
     C                   EVAL      #0YRAT12 = WRatAr(12)
     C                   EVAL      #0YRAT13 = WRatAr(13)
     C                   EVAL      #0YRAT14 = WRatAr(14)
     C                   EVAL      #0YRAT15 = WRatAr(15)
     C                   EVAL      #0YRAT16 = WRatAr(16)
     C                   EVAL      #0YRAT17 = WRatAr(17)
     C                   EVAL      #0YRAT18 = WRatAr(18)
     C                   EVAL      #0YRAT19 = WRatAr(19)
     C                   EVAL      #0YRAT20 = WRatAr(20)
     C                   EVAL      #0YRAT21 = WRatAr(21)
     C                   EVAL      #0YRAT22 = WRatAr(22)
     C                   EVAL      #0YRAT23 = WRatAr(23)
     C                   EVAL      #0YRAT24 = WRatAr(24)
     C                   EVAL      #0YRAT25 = WRatAr(25)
     C                   EVAL      #0YRAT26 = WRatAr(26)
     C                   EVAL      #0YRAT27 = WRatAr(27)
     C                   EVAL      #0YRAT28 = WRatAr(28)
     C                   EVAL      #0YRAT29 = WRatAr(29)
     C                   EVAL      #0YRAT30 = WRatAr(30)
     C                   EVAL      #0YRAT31 = WRatAr(31)
     C                   EVAL      #0YRAT32 = WRatAr(32)
     C                   EVAL      #0YRAT33 = WRatAr(33)
     C                   EVAL      #0YRAT34 = WRatAr(34)
     C                   EVAL      #0YRAT35 = WRatAr(35)
     C                   EVAL      #0YRAT36 = WRatAr(36)
     C                   EVAL      #0YRAT37 = WRatAr(37)
     C                   EVAL      #0YRAT38 = WRatAr(38)
     C                   EVAL      #0YRAT39 = WRatAr(39)
     C                   EVAL      #0YRAT40 = WRatAr(40)
     C                   EVAL      #0YRAT41 = WRatAr(41)
     C                   EVAL      #0YRAT42 = WRatAr(42)
     C                   EVAL      #0YRAT43 = WRatAr(43)
     C                   EVAL      #0YRAT44 = WRatAr(44)
     C                   EVAL      #0YRAT45 = WRatAr(45)
     C                   EVAL      #0YRAT46 = WRatAr(46)
     C                   EVAL      #0YRAT47 = WRatAr(47)
     C                   EVAL      #0YRAT48 = WRatAr(48)
     C                   EVAL      #0YRAT49 = WRatAr(49)
     C                   EVAL      #0YRAT50 = WRatAr(50)
     C                   EVAL      #0YRAT51 = WRatAr(51)
     C                   EVAL      #0YRAT52 = WRatAr(52)
     C                   EVAL      #0YRAT53 = WRatAr(53)
     C                   EVAL      #0YRAT54 = WRatAr(54)
     C                   EVAL      #0YRAT55 = WRatAr(55)
     C                   EVAL      #0YRAT56 = WRatAr(56)
     C                   EVAL      #0YRAT57 = WRatAr(57)
     C                   EVAL      #0YRAT58 = WRatAr(58)
     C                   EVAL      #0YRAT59 = WRatAr(59)
     C                   EVAL      #0YRAT60 = WRatAr(60)
     C                   EVAL      #0YRAT61 = WRatAr(61)
     C                   EVAL      #0YRAT62 = WRatAr(62)
     C                   EVAL      #0YRAT63 = WRatAr(63)
     C                   EVAL      #0YRAT64 = WRatAr(64)
     C                   EVAL      #0YRAT65 = WRatAr(65)
     C                   EVAL      #0YRAT66 = WRatAr(66)
     C                   EVAL      #0YRAT67 = WRatAr(67)
     C                   EVAL      #0YRAT68 = WRatAr(68)
     C                   EVAL      #0YRAT69 = WRatAr(69)
     C                   EVAL      #0YRAT70 = WRatAr(70)
     C                   EVAL      #0YRAT71 = WRatAr(71)
     C                   EVAL      #0YRAT72 = WRatAr(72)
     C                   EVAL      #0YRAT73 = WRatAr(73)
     C                   EVAL      #0YRAT74 = WRatAr(74)
     C                   EVAL      #0YRAT75 = WRatAr(75)
     C                   EVAL      #0YRAT76 = WRatAr(76)
     C                   EVAL      #0YRAT77 = WRatAr(77)
     C                   EVAL      #0YRAT78 = WRatAr(78)
     C                   EVAL      #0YRAT79 = WRatAr(79)
     C                   EVAL      #0YRAT80 = WRatAr(80)
     C                   EVAL      #0YRAT81 = WRatAr(81)
     C                   EVAL      #0YRAT82 = WRatAr(82)
     C                   EVAL      #0YRAT83 = WRatAr(83)
     C                   EVAL      #0YRAT84 = WRatAr(84)
     C                   EVAL      #0YRAT85 = WRatAr(85)
     C                   EVAL      #0YRAT86 = WRatAr(86)
     C                   EVAL      #0YRAT87 = WRatAr(87)
     C                   EVAL      #0YRAT88 = WRatAr(88)
     C                   EVAL      #0YRAT89 = WRatAr(89)
     C                   EVAL      #0YRAT90 = WRatAr(90)
     C                   EVAL      #0YRAT91 = WRatAr(91)
     C                   EVAL      #0YRAT92 = WRatAr(92)
     C                   EVAL      #0YRAT93 = WRatAr(93)
     C                   EVAL      #0YRAT94 = WRatAr(94)
     C                   EVAL      #0YRAT95 = WRatAr(95)
     C                   EVAL      #0YRAT96 = WRatAr(96)
     C                   EVAL      #0YRAT97 = WRatAr(97)
     C                   EVAL      #0YRAT98 = WRatAr(98)
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRInit - Initialisation                                       *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRInit        BEGSR
 
      ** Blank outputs (except for Action Code)
 
     C                   MOVEL     #0ACTN        WAction
     C                   MOVEL     *BLANK        YRATScnFmt
     C                   MOVEL     WAction       #0ACTN
 
      ** Access Yield Curves file to get Yield Curve Type
 
     C                   CALLB     'AOYLDCR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY    '    POptn
     C                   PARM                    FSYLDC
     C     SDYLDC        PARM      SDYLDC        DSSDY
 
      ** Database Error
 
     C                   IF        PRtCd <> *BLANK
     C                   EVAL      DBKEY = FSYLDC
     C                   EVAL      DBFILE = 'SDYLDCPD'
     C                   EVAL      DBASE = 901
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Initial Processing                                   *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: AOBANKR0, *PSSR                                        *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      **  Program Parameters
 
     C     *ENTRY        PLIST
 
      ** Input Parameters
      ** Return Code
      ** Yield Rates Transaction Details File Format
 
     C                   PARM                    RetCodeIn
     C                   PARM                    YRATFilFmt
 
      ** Output Parameters
      ** Yield Rates Transaction Details Screen Format
      ** Formatted Maturity Date Array
      ** Formatted Discount Factor Array
 
     C                   PARM                    YRATScnFmt
     C                   PARM                    MatDateArr
     C                   PARM                    DiscFacArr
 
      ** Initialize program name
 
     C                   EVAL      DBPGM = 'SDYRATCVT'
 
      ** Access Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST  '    POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        PRtCd <> *BLANK
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 900
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CAS008
      ** Check if switchable feature CAS008 is switched on                                    CAS008
      *                                                                                       CAS008
     C                   CALLB     'AOSARDR0'                                                 CAS008
     C                   PARM      *BLANKS       PRtCd                                        CAS008
     C                   PARM      '*VERIFY '    POptn                                        CAS008
     C                   PARM      'CAS008'      PSard                                        CAS008
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS008
                                                                                              CAS008
     C                   EVAL      CAS008 = 'N'                                               CAS008
     C                   IF        PRtCd <> *BLANKS AND                                       CAS008
     C                             PRtCd <> '*NRF'                                            CAS008
     C     *LOCK         IN        LDA                                                        CAS008
     C                   EVAL      DBKEY = 'CAS008'                                           CAS008
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS008
     C                   EVAL      DBASE = 902                                                CAS008
     C                   OUT       LDA                                                        CAS008
     C                   EXSR      *PSSR                                                      CAS008
     C                   ELSE                                                                 CAS008
     C                   IF        PRtCd = *BLANKS                                            CAS008
     C                   EVAL      CAS008 = 'Y'                                               CAS008
     C                   ENDIF                                                                CAS008
     C                   ENDIF                                                                CAS008
 
     C                   ENDSR
 
      ********************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
