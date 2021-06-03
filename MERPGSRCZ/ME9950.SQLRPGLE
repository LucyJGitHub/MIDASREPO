     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD056888
/*STD *  RPGSQLBND                                                    *                     MD056888
/*EXI *  TEXT('Midas ME Validate field 72: sender to receiver')       *
      *****************************************************************
      *                                                               *
      *  Midas - Message Management Module                            *
      *                                                               *
      *  ME9950 - Validate Field 72: Sender to Receiver Information   *
      *                                                               *
      *  Function:  This program handles the validation of Field 72:  *
      *             Sender to Receiver Information                    *
      *                                                               *
      *  Called By: SD2410 - Extended Settlement Instructions         *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD056888           Date 20Sep20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CSW215             Date 06Apr15               *
      *                 245501             Date 05Jun15               *
      *                 CSW214             Date 25Nov14               *
      *                 CDL094             Date 01Sep14               *
      *                 MD027698           Date 19Aug14               *
      *                 CMG003             Date 04Oct12               *
      *                 CMG003             Date 04Oct12               *
      *                 CSW212             Date 03May12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG19090           Date 06Jun08               *
      *                 CSW208             Date 15Apr08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSW206F            Date 09Oct06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222373             Date 27Oct03               *
      *                 219242             Date 01Jul03               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSW201             Date 02May01               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSW097             Date 02Dec99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 144084             Date 05Oct98               *
      *                 CSW011             Date 21Mar97               *
      *                 096299             Date 04MAR97               *
      *                 110822             Date 20FEB97               *
      *                 CSW005             Date 01AUG96               *
      *                 CSW096             Date 04JUN96               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD056888 - Deliverable Data Split for SDCODEPD               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSW215 - SWIFT Changes 2015                                  *
      *  245501 - Change position 7 of array CDEA from N to blank     *
      *           for /ACC/ & /BNF/ to allow optional narrative after *
      *           /ACC/ & /BNF/ in Line 1 of Bank to Bank Information.*
      *         - Applied for MD031205                                *
      *  CSW214 - SWIFT Changes 2014                                  *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *  MD027698 - Remove restriction that codeword /INS/ can only   *
      *             have 2 lines.                                     *
      *  CMG003 - SWIFT MT600 Message Generation                      *
      *  CSW212 - SWIFT 2012 Changes                                  *
      *  BUG19090 - Field 72 misleading error message                 *
      *  CSW208 - SWIFT 2008 Changes                                  *
      *  CSW206F - BONL codeword is allowed for tag 23E Instruction   *
      *            Code. Remove /BENONLY/ codeword from array CDEW    *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222373 - Parameter mismatch.                                 *
      *  219242 - Not possible to create MT103+ payment msg from      *
      *           non-FT transaction                                  *
      *  CSW201 - SWIFT 2001 Standards Update                         *
      *  144084 - Bank to Bank checking modification.  Validate fld72 *
      *           for SWIFT messages only.                            *
      *  CSW097 - MT34*s and MT36*s Message Generation.               *
      *  CSW011 - FRA MT34n only Message Generation                   *
      *  096299 - Alter field 72 validation to accept /TELEBIN/       *
      *           instead of /TELEXBIN/, /TELE/ instead of /TELEX/    *
      *           and /TELEIBK/ instead of /TELEXIBK/. Changes take   *
      *           place in the array specs.                           *
      *  110822 - Array index error if line completely filled with    *
      *           alphabetic characters                               *
      *  CSW005 - FRAIRS MG34n & MG34n Message Generation             *
      *  CSW096 - SWIFT Changes November 1996                         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Indicator usage                                              *
      *  ~~~~~~~~~~~~~~~                                              *
      *  90    General Error Indicator                                *
      *  91    FRA/IRS CODEWORD INDICATOR                             *                       CSW208
      *                                                               *
      *****************************************************************
      /EJECT
     F*SDCODEL2* IF   E           K DISK    INFSR(SRFILE)                                   MD056888
     F**********                           USROPN                                           MD056888
      *
      *  Valid Message Control File
      *
     FACNUM     IF   E           K DISK    INFSR(SRFILE)
     F                                     USROPN
      *
      *  Valid Message Control File
      *
      * Initialise Program F-Spec
     F/COPY WNCPYSRC,ME9950DFPG
      /EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      *  Array containing Copyright statement
      ***************** FIRST COMPILE TIME ARRAY *********************
      *
      *
      *  Error codes array
      *
      *
      *  Array for validating Bank to Bank
      *
     D #ER             S              1    DIM(6)
     D SL              S              2    DIM(6)
      *
      *  Swift codewords
      *
     D/COPY WNCPYSRC,ME9950E001
     D**********          CDEW    1  30 20   CDEA   20                                        219242
     D**********          CDEW    1  32 20   CDEA   20                                219242 CSW206F
     D**********          CDEW    1  31 20   CDEA   20                                CSW206F CSW214
     D CDEW            S             20    DIM(32) CTDATA PERRCD(1)
     D CDEA            S             20    DIM(32) ALT(CDEW)
     D/COPY WNCPYSRC,ME9950E002
      *
      *  Transaction Types to Modules
      *
     D TTYP            S              2    DIM(37) CTDATA PERRCD(1) ASCEND
     D TMOD            S              2    DIM(37) ALT(TTYP)
      *
      *  Specified on screen code words
      *
     D CDE             S             20    DIM(6)
      *                                                                                       CSW208
      ** FRA/IRS confirmation array                                                           CSW208
      *                                                                                       CSW208
     D CFRA            S             20    DIM(2) CTDATA PERRCD(1)
     D*COPY*MECPYSRC,SRERRE                                                                 MD056888
     D/COPY MECPYSRC,SRERRELE                                                               MD056888
      * Initialise Program E-Spec
     D/COPY WNCPYSRC,ME9950DEPG
      *                                                                                       CSC022
      ** Array of Commitment Job Names                                                        CSC022
     D CMTJOB          S             10    DIM(10)
      /EJECT
      * Initialise Program I-Spec
     D/COPY WNCPYSRC,ME9950DIPG
      * Data structures:
     D JBDTTM          DS
      * Job date/time
     D  ##JDT                  1      6  0
     D  ##JYY                  1      2  0
     D  ##JMM                  3      4  0
     D  ##JDD                  5      6  0
     D  ##JTM                  7     12  0
     D  ##JHH                  7      8  0
     D  ##JNN                  9     10  0
     D  ##JSS                 11     12  0
      *
      *  Copysource for error processing
      *
     D*COPY*MECPYSRC,SRERRI                                                                 MD056888
     D/COPY MECPYSRC,SRERRILE                                                               MD056888
      *
     D RUNDTA        E DS                  EXTNAME(RUNDAT)
      *
      * Get Rundate - Rundate  *
      *
     D MMODDS        E DS                  EXTNAME(SDMMODPD)
      *
      * Modules Data Structure *
      *
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
      *
      * Nostro Details Structure *
      *
     D DSCCSY        E DS                  EXTNAME(SDCCSYPD)
      *
      * Currency Clearing Systems *
      *
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      *  Calling parameter data structure for AOCUSTR0
      *
     D SDCNST        E DS                  EXTNAME(SDCNSTPD)
      *
      *  Calling parameter data structure for ME1400
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CSW005
      *                                                                   CSW005
      *  SAR descriptions                                                 CSW005
     D MEBICD        E DS                  EXTNAME(MEBICDPD)
      *
      *  Calling parameter data structure for ME1400
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      * Data Structures used by Access Programs
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      * Data Structures used by Access Programs
      *
     D MEISOC        E DS                  EXTNAME(MEISOCPD)
      *                                                                                       CSW214
      * ISO Country Code Details Data Structure                                               CSW214
      *                                                                                       CSW214
      *
      * Define actions for keyword
      *
     D DSCDEA          DS            20
      * Type of validation INBK, ACBK or BENF
     D  A#TYPE                 1      4
      * Substitute Phone if + after keyword
     D  A#PHON                 5      5
      * Substitute Telex if + after keyword
     D  A#TELX                 6      6
      * Allow blanks after keyword, Y, N or Blank
     D  A#BLNK                 7      7
      * Maximum Lines after that may be //
     D  A#SLLA                 8      8
     D  A#SLLN                 8      8  0
      * Bank required, Y, N or blank
     D  A#BANK                 9      9
      * Swift Address required
     D  A#BICD                10     10
      **Interest*Rate*Swap*Codeword?*                              CSW005 CSW097
     D***********                            11  11 A#IRSC         CSW005 CSW097
      *
      * Input Parameters
      *
     D***I#PARM*     DS                            512                                        CGL029
     D I#PARM          DS           514
      * Field to be validated
     D  I#VFLD                 1      5
      * Pay/Receive Settlement (PAY/REC)
     D  I#PR                   6      8
      * Customer/Counterparty Nostro /BIC indentified type
      *    C           X              S  X-> C'party Nostro or Customer
      * Customer/Counterparty/BIC indentified
     D  I#PRTT                 9      9
     D  I#PRTY                10     20
      * Pay Currency
     D  I#PCCY                21     23
      * Receive Currency
     D  I#RCCY                24     26
      * Account Line
     D  I#ACLN                27     61
      * Account Line Character 1
     D  I#ACC1                27     27
      * Account Line Character 2
     D  I#ACC2                28     28
      * Account Line Character 3
     D  I#ACC3                29     29
      * Account Line first 4 characters
     D  I#ACCL                27     30
      * Account Line Clearing System
     D  I#ACCS                29     30
      * Account Line No account data
     D  I#SPC1                31     61
      * Message Type
     D  I#MTYP                62     64
      * Intermediary Institution for Bank to Bank validation
     D  I#INBT                65     65
     D  I#INBK                66     76
      * Account with Institution for Bank to Bank validation
     D  I#AWBT                77     77
     D  I#AWBK                78     88
      * Beneficiary for Bank to Bank validation
     D  I#BENT                89     89
     D  I#BENF                90    100
      * Pay and Receive Settlement Methods
     D  I#RSTM               101    102
     D  I#PSTM               103    104
      * Field 53 and 54 Entered
     D  I#5354               105    105
      * Midas Module
     D  I#MMOD               106    107
      * Pay and Receive Settlement Accounts
     D**********                            108 125 I#PYAC                                    CGL029
     D**********                            126 143 I#RCAC                                    CGL029
      * Transaction Type
     D  I#TTYP               144    145
      * Cover required
     D  I#COVR               146    146
      * Bank to Bank Information
     D  I#BTB                257    466
     D  I#BTB1               257    291
     D  I#BTB2               292    326
     D  I#BTB3               327    361
     D  I#BTB4               362    396
     D  I#BTB5               397    431
     D  I#BTB6               432    466
      * Pay and Receive Settlement Accounts                                                   CGL029
     D  I#PYAC               467    490
     D  I#RCAC               491    514
      *
      * Output Parameters
      *
     D***O#PARM*     DS                            512                                        CGL029
     D O#PARM          DS           514
      * Account Line modified
     D  O#ACLN                 1     35
      * Bank to Bank Information
     D  O#BTB                257    466
     D  O#BTB1               257    291
     D  O#BTB2               292    326
     D  O#BTB3               327    361
     D  O#BTB4               362    396
     D  O#BTB5               397    431
     D  O#BTB6               432    466
      *
      * Error Parameters
      *
     D E#PARM          DS           256
      * Calling Program
     D  E#CPGM                 1     10
      * Error message sent
     D  E#ERRM                12     12
      * Warning message sent
     D  E#WARN                13     13
      * Error index
     D  E#INDX                14     18  0
      * Message text to prefix error message
     D  E#MSGD                19     25
     D  E#MSGF                26     35
      * Fields in error
     D  E#FLDS                36     41
      * Error codes array
     D  E#ERCD                51    200
     D  ERCD                  51    200
     D                                     DIM(50)
     D DSMTR           DS
      *
      *  Define fields for message transalation
      *
     D  #MSDTA                 1    132
     D  #MSTX1               133    264
     D #MSTX2          DS
     D  #MSTXA                 1    256
     D  #MSTXB               257    512
      *
      *  Define look up of SWIFT Codeword file
      *
     D LKCODE          DS                  OCCURS(20)
     D  L#SWCD                 1      1
     D  L#MTYP                 2      2
     D  L#MMOD                 3      3
     D  L#DSCN                 4      4
      *
     D SCCMT           DS           256
     D  CMTNUM                 1      3  0
     D  CMTARR                 4    103
      *                                                                                       CSC022
      *  Defined Constants
      *
      *
     D DIGITS          C                   CONST('0123456789')
      *
      * Named Constant used to determine if a field contains invalid
      * characters for Telex and S.W.I.F.T.
      *
     D ISO             C                   CONST('ABCDEFGHIJKLMNOPQRST-
     D                                     UVWXYZ 1234567890/-?-
     D                                     ?:().,''+')
      * Extended ISO
     D ISOEX           C                   CONST('ABCDEFGHIJKLMNOPQRST-
     D                                     UVWXYZ 1234567890/-?-
     D                                     ?:().,''+abcdefghijk-
     D                                     lmnopqrstuvwxyz')
      *
      * Named Constant used to determine if a field is alphabetic
      *
     D ALPHAB          C                   CONST('ABCDEFGHIJKLMNOPQRST-
     D                                     UVWXYZ')
      *
      * Named Constant used to determine if a field is alphabetic
      * with numbers
      *
     D ALPHAN          C                   CONST('ABCDEFGHIJKLMNOPQRST-
     D                                     UVWXYZ0123456789')
      *
     D SDCODE        E DS                  EXTNAME(SDCODJW0)                                MD056888
      *
      /EJECT
      *
      *****************************************************************
      *                                                               *
      *  List of Subroutines                                          *
      *                                                               *
      *  SRBTOB   : Validate Field 72: Sender to Receiver             *
      *  SROTHR   : Validate Other Details                            *
      *  SRCUST   : Get Customer/Counterparty Nostro/ Bic Information *
      *  SRSNMS   : Send Message to Calling program                   *
      *  SRINIT   : Initialise and define fields                      *
      *                                                               *
      *****************************************************************
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'MAIN'        @STK(Q)
      * Entry parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    W0RTN             7
     C                   PARM                    I#PARM                         I Input Parms
     C                   PARM                    O#PARM                         O Output Parms
     C                   PARM                    E#PARM                         E Error Inform
     C                   PARM                    Z#PARM          256            B User Defined
      *
      *  Set up primary reference
      *
     C                   MOVEL(P)  I#BTB         W0PREF
      *                                                                   CSW005
      * Ensure validation is correctly performed if from SD0402R and      CSW005
      * type is 'AT'                                                      CSW005
     C     CSW005        IFEQ      'Y'                                                         CSW00
     C     I#MMOD        ANDEQ     'FI'                                                        CSW00
     C     I#TTYP        ANDEQ     'AT'                                                        CSW00
     C                   MOVE      'RX'          I#TTYP                                        CSW00
     C                   END                                                                   CSW00
     C     CSW011        IFEQ      'Y'                                                         CSW01
     C     I#MMOD        ANDEQ     'FI'                                                        CSW01
     C     I#TTYP        ANDEQ     'AT'                                                        CSW01
     C     CSW005        ANDNE     'Y'                                                         CSW01
     C                   MOVE      'FR'          I#TTYP                                        CSW01
     C                   END                                                                   CSW01
      *
      * Initialise program
      *
     C     $FIRST        IFEQ      *BLANKS
     C                   EXSR      SRINIT
     C                   END
      *
      * Initialise return code etc
      *
     C                   MOVEL     *BLANK        P#RTCD            7
     C                   MOVEL     *BLANK        E#ERRM
     C                   MOVEL     *BLANK        E#WARN
     C                   MOVEL     *BLANK        E#ERCD
     C                   Z-ADD     1             E                 5 0
      *
     C                   MOVEL     *BLANKS       W9CUST
     C                   MOVEL     *BLANKS       W9CNST
     C                   MOVEL     *BLANKS       W9BICD
      * Main processing 1
     C/COPY WNCPYSRC,ME9950DMP1
      *
      ** Depending on field call relevant subroutine
      *
     C                   SELECT
      * Intermediary Institution
     C     I#VFLD        WHENEQ    ':72: '
     C                   EXSR      SRBTOB
      * Catch all
     C                   OTHER
     C                   EXSR      SROTHR
     C                   ENDSL
      *
      * Main processing 2
     C/COPY WNCPYSRC,ME9950DMP2
      *
      ** Set return depending errors found
     C     P#RTCD        IFNE      *BLANKS
     C                   MOVEL     P#RTCD        W0RTN
     C                   ENDIF
     C     E             IFNE      0
     C                   Z-ADD     E             E#INDX
     C                   ENDIF
     C                   MOVEL     I#BTB         O#BTB
      * Main processing 3
     C/COPY WNCPYSRC,ME9950DMP3
      *
      *
      *  Unwind subroutine stack name
      *
     C     EXMAIN        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   RETURN
      *
      ********************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRBTOB   : Validate Field 72: Sender to Receiver             *
      *                                                               *
      *  CALLED BY: SRSEPT SWIFT September 1993 /8a/                  *
      *                                                               *
      *****************************************************************
     CSR   SRBTOB        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRBTOB'      @STK(Q)
      *
      * Copy point for Other Institution Validation
     C/COPY WNCPYSRC,ME9950BTOB
      *
      *  Primary Validation to check very basics
      *
     C                   EXSR      SRPVAL
     C     E#ERRM        IFNE      *BLANKS
     C                   GOTO      EXBTOB
     C                   ENDIF
      *
      ***Only*check*SWIFT*if*settlement*method*is*01,*08*and*10********** 144084
      *  Only check SWIFT if settlement method is 08                      144084
      *  or cover required
      *
     C***********I#PSTM    IFEQ '01'                                      144084
     C***********I#PSTM    OREQ '08'                                      144084
     C***********I#PSTM    OREQ '10'                                      144084
     C     I#PSTM        IFEQ      '08'                                                        14408
     C     I#COVR        OREQ      'Y'
     C     I#MTYP        OREQ      '300'
     C     I#MTYP        OREQ      '600'
     C     CSW005        OREQ      'Y'                                                         CSW00
     C     I#MMOD        ANDEQ     'FI'                                                        CSW00
     C     CSW011        OREQ      'Y'                                                         CSW01
     C     I#MMOD        ANDEQ     'FI'                                                        CSW01
      *
      *  Check that SWIFT /8a/ Rules are obeyed
      *
     C                   EXSR      SRSEPT
     C     E#ERRM        IFNE      *BLANKS
     C                   GOTO      EXBTOB
     C                   ENDIF
      *
      *  Check valid keywords
      *
      * Only check codewords for FT if some exist on file
      * for all other modules always check
      *
     C     I#MMOD        IFNE      'FT'
     C     I#MMOD        OREQ      'FT'
     C     SWCODE        ANDEQ     'Y'
     C***********CSW005    OREQ 'Y'                                CSW005 CSW011
     C***********I#MMOD    ANDEQ'FI'                               CSW005 CSW011
     C***********I#MMOD    OREQ 'FI'                               CSW011 CSW097
     C***********I#TTYP    ANDNE'FR'                               CSW005 CSW097
     C                   EXSR      SRKYWD
     C     E#ERRM        IFNE      *BLANKS
     C                   GOTO      EXBTOB
     C                   ENDIF
     C                   ENDIF
      *
      *  Check SWIFT Character Set
      *
     C                   EXSR      SRSWCH
     C     E#ERRM        IFNE      *BLANKS
     C                   GOTO      EXBTOB
     C                   ENDIF
      *
     C                   ENDIF
      *
      *  Unwind subroutine stack name
      *
     C     EXBTOB        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SROTHR   : Validate Other Details                            *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SROTHR        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SROTHR'      @STK(Q)
      *
      * Copy point for Other Institution Validation
     C/COPY WNCPYSRC,ME9950OTHR
      *
      *  Unwind subroutine stack name
      *
     C     EXOTHR        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRPVAL   : Primary Validation                                *
      *                                                               *
      *  CALLED BY: SRBTOB Validate Field :72:                        *
      *                                                               *
      *****************************************************************
     CSR   SRPVAL        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SRPVAL'      @STK(Q)
      *
      *  /COPY Statement
      *
     C/COPY WNCPYSRC,ME9950PVAL
      *
      *  Override Module depending on lookup
      *
     C                   Z-ADD     1             #H
     C     I#TTYP        LOOKUP    TTYP(#H)                               90
     C     *IN90         IFEQ      *ON
      *
      * If not FT OP then use value found
      *
     C     I#MMOD        IFNE      'FT'
     C     I#TTYP        ANDNE     'OP'
     C                   MOVEA     TMOD(#H)      I#MMOD
     C                   ENDIF
     C                   ENDIF
      *
      *  No blank lines allowed between lines
      *
     C                   MOVEA     *BLANKS       #ER
      *
     C     I#BTB         IFNE      *BLANKS
      * Line 2 input line 1 blank
     C     I#BTB1        IFEQ      *BLANKS
     C     I#BTB2        ANDNE     *BLANKS
     C/COPY WNCPYSRC,ME9950C001
      * Line 3 input line 2 blank
     C     I#BTB2        OREQ      *BLANKS
     C     I#BTB3        ANDNE     *BLANKS
      * Line 4 input line 3 blank
     C     I#BTB3        OREQ      *BLANKS
     C     I#BTB4        ANDNE     *BLANKS
      * Line 5 input line 4 blank
     C     I#BTB4        OREQ      *BLANKS
     C     I#BTB5        ANDNE     *BLANKS
     C/COPY WNCPYSRC,ME9950C002
      * Line 6 input line 5 blank
     C     I#BTB5        OREQ      *BLANKS
     C     I#BTB6        ANDNE     *BLANKS
     C                   MOVE      '994'         ERCD(E)
     C                   ADD       1             E
      *
     C                   MOVEL     'Y'           E#ERRM
     C                   MOVEL     *BLANKS       MEMSDT
     C                   MOVEL     'MEC0105'     MEMSID
     C                   MOVEL     'MEMSG'       MEMSGF
     C                   EXSR      SRSNMS
      *
      * Set field in error
      *
     C                   SELECT
     C     I#BTB1        WHENEQ    *BLANKS
     C                   MOVEA     'Y'           #ER(1)
     C     I#BTB2        WHENEQ    *BLANKS
     C                   MOVEA     'Y'           #ER(2)
     C     I#BTB3        WHENEQ    *BLANKS
     C                   MOVEA     'Y'           #ER(3)
     C     I#BTB4        WHENEQ    *BLANKS
     C                   MOVEA     'Y'           #ER(4)
     C     I#BTB5        WHENEQ    *BLANKS
     C                   MOVEA     'Y'           #ER(5)
     C                   ENDSL
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      * Move array of errors to E#FLDS
      *
     C                   MOVEA     #ER           ##006             6
     C                   MOVEL     ##006         E#FLDS
      *
      *  Unwind subroutine stack name
      *
     C     EXPVAL        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRSEPT   : SWIFT validation changes                          *
      *                                                               *
      *  CALLED BY: SRBTOB Validate Field :72:                        *
      *                                                               *
      *****************************************************************
     CSR   SRSEPT        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SRSEPT'      @STK(Q)
      *
      *  /COPY Statement
      *
     C/COPY WNCPYSRC,ME9950SEPT
      *
      *  Check through each of the 6 fields in turn.
      *
     C                   Z-ADD     1             #S                5 0
     C                   MOVEA     *BLANKS       #ER
     C     1             DO        6             #T                5 0
      *
      *  Set flag to show line correct and move data to work fields
      *
     C                   MOVE      'F'           SSF               1
     C     35            SUBST(P)  I#BTB:#S      ##FLD            35
      *
      *  If not equal to blanks validate
      *
     C     ##FLD         IFNE      *BLANKS
      *
      * If line is not blank then first position must be a "/"
      *
     C     1             SUBST     ##FLD:1       ##001             1
      *
      *  First position must be a '/'
      *
     C     ##001         IFNE      '/'
     C/COPY WNCPYSRC,ME9950C009
     C                   MOVE      '153'         ERCD(E)
     C                   ADD       1             E
      *
     C                   MOVEA     'Y'           #ER(#T)
     C                   MOVEL     'Y'           E#ERRM
     C                   MOVEL     *BLANKS       MEMSDT
     C                   MOVEL     'MEC0101'     MEMSID
     C                   MOVEL     'MEMSG'       MEMSGF
     C                   EXSR      SRSNMS
     C/COPY WNCPYSRC,ME9950C010
     C                   ELSE
      *
      *  The first special instruction line cannot have '/'
      *  in position 2
      *
     C     #S            IFEQ      1
     C     1             SUBST     ##FLD:2       ##001             1
     C     ##001         IFEQ      '/'
     C                   MOVE      '989'         ERCD(E)
     C/COPY WNCPYSRC,ME9950C008
     C                   ADD       1             E
      *
     C                   MOVEL     'Y'           E#ERRM
     C                   MOVEL     *BLANKS       MEMSDT
     C                   MOVEL     'MEC0102'     MEMSID
     C                   MOVEL     'MEMSG'       MEMSGF
     C                   EXSR      SRSNMS
     C                   MOVEA     'Y'           #ER(#T)
     C                   END
     C                   END
     C/COPY WNCPYSRC,ME9950C007
      *
      *  2nd - 6th special instruction line cannot have '/'
      *  in position 2 followed by a narrative of blanks.
      *
     C     #S            IFNE      1
     C     1             SUBST     ##FLD:2       ##POS2            1
     C     33            SUBST     ##FLD:3       ##NARR           33
     C     ##POS2        IFEQ      '/'
     C     ##NARR        ANDEQ     *BLANKS
     C                   MOVE      '153'         ERCD(E)
     C                   ADD       1             E
      *
     C                   MOVEL     'Y'           E#ERRM
     C                   MOVEL     *BLANKS       MEMSDT
     C                   MOVEL     'MEC0100'     MEMSID
     C                   MOVEL     'MEMSG'       MEMSGF
     C                   EXSR      SRSNMS
     C                   MOVEA     'Y'           #ER(#T)
     C                   END
     C                   END
      *
      *  Check the line for '8a/', where 8a represents
      *  up to eight upper case alphabetic charaters
      *
      *
     C                   Z-ADD     2             #R                3 0
      *                                                                                       CSW201
     C     CSW201        IFEQ      'Y'
     C     ALPHAN        CHECK     ##FLD:#R      #R
     C                   ELSE
     C     ALPHAB        CHECK     ##FLD:#R      #R
     C                   ENDIF
      *                                                                                       CSW201
     C     #R            IFGE      11
     C     #R            ORLE      0                                                           11082
     C                   MOVE      '153'         ERCD(E)
     C     CDL094        IFEQ      'Y'
     C     E#CPGM        IFEQ      'LDNI'
     C     E#CPGM        OREQ      'FXDL'
     C     CSW201        IFEQ      'Y'
     C                   MOVE      '302'         ERCD(E)
     C                   ELSE
     C                   MOVE      '103'         ERCD(E)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ADD       1             E
      *
     C                   MOVEL     'Y'           E#ERRM
     C                   MOVEL     *BLANKS       MEMSDT
      *                                                                                       CSW201
     C     CSW201        IFEQ      'Y'
     C                   MOVEL     'MEC0302'     MEMSID
     C                   ELSE
     C                   MOVEL     'MEC0103'     MEMSID
     C                   ENDIF
      *                                                                                       CSW201
     C                   MOVEL     'MEMSG'       MEMSGF
     C                   EXSR      SRSNMS
     C                   MOVEA     'Y'           #ER(#T)
     C                   END
      *
      *  If #R less than eleven then this character must be "/"
      *
     C     #R            IFLT      11
     C     #R            ANDGT     0                                                           11082
     C     1             SUBST     ##FLD:#R      ##001
     C     ##001         IFNE      '/'
     C**********           MOVE '153'     ERCD,E                                              CDL094
     C                   MOVE      '104'         ERCD(E)
     C                   ADD       1             E
      *
     C                   MOVEL     'Y'           E#ERRM
     C                   MOVEL     *BLANKS       MEMSDT
     C                   MOVEL     'MEC0104'     MEMSID
     C                   MOVEL     'MEMSG'       MEMSGF
     C                   EXSR      SRSNMS
     C                   MOVEA     'Y'           #ER(#T)
     C                   END
     C                   END
     C                   END
     C                   END
      *
      * Move pointer on 35 characters
      *
     C                   ADD       35            #S
     C                   ENDDO
      *
      *  Unwind subroutine stack name
      *
     C     EXSEPT        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
      * Move array of errors to E#FLDS
      *
     C                   MOVEA     #ER           ##006             6
     C                   MOVEL     ##006         E#FLDS
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRKYWD   : Validate Keywords, old style                      *
      *                                                               *
      *  CALLED BY: SRBTOB Validate Field :72:                        *
      *                                                               *
      *****************************************************************
     CSR   SRKYWD        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SRKYWD'      @STK(Q)
      *
      *  /COPY Statement
      *
     C/COPY WNCPYSRC,ME9950KYWD
      *
      *  Check through each of the 6 fields in turn.
      *
     C                   Z-ADD     1             #S                5 0
     C                   MOVEA     *BLANKS       CDE
     C                   Z-ADD     1             #X                5 0
     C                   MOVEA     *BLANKS       #ER
     C     1             DO        6             #T                5 0
     C     35            SUBST(P)  I#BTB:#S      ##FLD            35
      *
      *  /COPY Statement
      *
     C/COPY WNCPYSRC,ME9950KYW1
      *
      *  If not equal to blanks validate
      *
     C     ##FLD         IFNE      *BLANKS
      *
      * Get code word including slashes
      *
     C     '/'           SCAN      ##FLD:2       #R                       90
     C     *IN90         IFEQ      *ON
     C     #R            ANDNE     2
     C     #R            SUBST(P)  ##FLD:1       ##KYWD           20
      *
      *  If code not '//' then check no duplicates
      *
     C     ##KYWD        IFNE      '//'
      *
     C                   Z-ADD     1             #Y                5 0
     C     ##KYWD        LOOKUP    CDE(#Y)                                90
      * Codeword found
      ** Allow multiple /INS/ code if CSW215 is installed                                     CSW215
      *                                                                                       CSW215
     C     *IN90         IFEQ      *ON
     C     ##KYWD        ANDNE     '/INS/'
     C     *IN90         OREQ      *ON
     C     ##KYWD        ANDEQ     '/INS/'
     C     CSW215        ANDEQ     'N'
     C                   MOVE      '997'         ERCD(E)
     C                   ADD       1             E
      *
     C                   MOVEL     'Y'           E#ERRM
     C                   MOVEL(P)  #T            MEMSDT
     C     MEMSDT        CAT       ##KYWD:0      MEMSDT
     C                   MOVEL     'MEC0115'     MEMSID
     C                   MOVEL     'MEMSG'       MEMSGF
     C                   EXSR      SRSNMS
     C                   MOVEA     'Y'           #ER(#T)
     C                   GOTO      EXKYWD
      *
     C                   ENDIF
      *
     C                   MOVEA     ##KYWD        CDE(#X)
     C                   ADD       1             #X
      *
     C     *IN90         IFEQ      '1'
     C     ##KYWD        ANDEQ     '/INS/'
     C     CSW215        ANDEQ     'Y'
     C                   MOVEL     '0'           *IN90
     C                   ENDIF
      *                                                                                       CSW215
     C                   ENDIF
      *
      * If codewords then check if valid
      *
     C     SWCODE        IFEQ      'Y'
     C                   MOVEL     'N'           ##VCDE            1
     C                   EXSR      SREXCD
     C                   ENDIF
      *
      * Look up valid codeword array
      *
     C/COPY WNCPYSRC,ME9950C003
     C                   Z-ADD     1             #Y                5 0
     C     ##KYWD        LOOKUP    CDEW(#Y)                               90
     C/COPY WNCPYSRC,ME9950C004
      *                                                                                       CSW208
      ** Check if valid FRA/IRS codeword                                                      CSW208
      *                                                                                       CSW208
     C                   MOVEL     'N'           #VFRA             1
     C     CSW208        IFEQ      'Y'
     C     I#MMOD        ANDEQ     'FI'
      *                                                                                       CSW208
     C     ##KYWD        LOOKUP    CFRA                                   91
     C     *IN91         IFEQ      *ON
     C                   MOVEL     'Y'           #VFRA
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSW208
      ** TSU code is only valid for MT202                                                     CSW208
      *                                                                                       CSW208
     C                   MOVEL     'N'           #VTSU             1
     C     CSW208        IFEQ      'Y'
     C     I#MTYP        ANDEQ     '202'
     C     ##KYWD        ANDEQ     '/TSU/'
     C                   MOVEL     'Y'           #VTSU
     C                   ENDIF
      *
     C                   SELECT
      *
      * Codeword found and no codes on SDCODEL2 or codeword found
      * and not allowed via SDCODEL2
      *
     C     *IN90         WHENEQ    *ON
     C     SWCODE        ANDEQ     'N'
     C     *IN90         OREQ      *ON
     C     SWCODE        ANDEQ     'Y'
     C     ##VCDE        ANDEQ     'Y'
     C/COPY WNCPYSRC,ME9950C005
     C                   MOVEL     CDEA(#Y)      DSCDEA
     C/COPY WNCPYSRC,ME9950C006
      *
      * Validate according to type
      *
     C                   EXSR      SRVCDE
      *                                                                                       CSW208
      ** VENU/TIME/TSU CODEWORD                                                               CSW208
      *                                                                                       CSW208
     C     #VFRA         WHENEQ    'Y'
     C     #VTSU         OREQ      'Y'
      *
      * If no codewords then report code word not allowed
      *
     C     SWCODE        WHENEQ    'N'
     C     *IN90         ANDEQ     *OFF
     C                   MOVE      '990'         ERCD(E)
     C                   ADD       1             E
      *
     C                   MOVEL     'Y'           E#ERRM
     C                   MOVEL     *BLANKS       MEMSDT
     C                   MOVEL     'MEC0106'     MEMSID
     C                   MOVEL     'MEMSG'       MEMSGF
     C                   EXSR      SRSNMS
     C                   MOVEA     'Y'           #ER(#T)
      *
      * If codewords and not found error
      *
     C     SWCODE        WHENEQ    'Y'
     C     ##VCDE        ANDEQ     'N'
      *                                                                                     BUG19090
      * If CSW208 is switched off and codeword is TSU, display a new error message.         BUG19090
      *                                                                                     BUG19090
     C                   MOVE      '990'         ERCD(E)
     C     ##KYWD        IFEQ      '/TSU/'
     C     CSW208        ANDEQ     'N'
     C                   MOVE      '152'         ERCD(E)
     C                   ENDIF
     C                   ADD       1             E
      *
     C                   MOVEL     'Y'           E#ERRM
     C                   MOVEL     *BLANKS       MEMSDT
     C                   MOVEL     'MEC0119'     MEMSID
     C                   MOVEL     'MEMSG'       MEMSGF
     C                   EXSR      SRSNMS
     C                   MOVEA     'Y'           #ER(#T)
     C                   ENDSL
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      * Move pointer on 35 characters
      *
     C                   ADD       35            #S
     C                   ENDDO
      *
      *  Unwind subroutine stack name
      *
     C     EXKYWD        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
      * Move array of errors to E#FLDS
      *
     C                   MOVEA     #ER           ##006             6
     C                   MOVEL     ##006         E#FLDS
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SREXCD   : Validate SWIFT Extended Codewords                 *
      *                                                               *
      *  CALLED BY: SRKYWD Validate Key words                         *
      *                                                               *
      *****************************************************************
     CSR   SREXCD        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SREXCD'      @STK(Q)
      *
      *  /COPY Statement
      *
     C/COPY WNCPYSRC,ME9950EXCD
      *
      *  Get Customer number of Pay Party
      *
     C                   MOVEL     *BLANKS       ##DSCN
     C     I#PYAC        IFNE      *BLANKS
     C                   MOVEL(P)  I#PYAC        ##D035           35
     C                   MOVEL     I#PCCY        ##CYCD
     C                   EXSR      SRACCS
     C                   ENDIF
      *
      *  Define key
      *
     C     KCODE2        KLIST
     C                   KFLD                    FYSWCD
     C                   KFLD                    FYSMTP
     C                   KFLD                    FYMMID
     C                   KFLD                    FYDCUS
      *
      *  Loop around occurrance data structure for look ups
      *
     C                   DO        L#NBR         #K                5 0
      *
      *  Set up key
      *
     C     #K            OCCUR     LKCODE
      *
      *  /COPY Statement
      *
     C/COPY WNCPYSRC,ME9950EXC1
      *
     C                   MOVEL     *BLANKS       FYSWCD
     C                   MOVEL     *BLANKS       FYSMTP
     C                   MOVEL     *BLANKS       FYMMID
     C                   MOVEL     *BLANKS       FYDCUS
     C     *LIKE         DEFINE    BBCUST        ##DSCN
      *
      * Codeword
     C                   SELECT
     C     L#SWCD        WHENEQ    'Y'
     C                   MOVEL(P)  ##KYWD        FYSWCD
     C     L#SWCD        WHENEQ    '*'
     C                   MOVEL(P)  '*ALL'        FYSWCD
     C     L#SWCD        WHENEQ    'N'
     C                   MOVEL     *BLANKS       FYSWCD
     C                   OTHER
     C                   ITER
     C                   ENDSL
      * Message type
     C                   SELECT
     C     L#MTYP        WHENEQ    'Y'
     C     I#MTYP        ANDEQ     *BLANKS
     C                   ITER
     C     L#MTYP        WHENEQ    'Y'
     C                   MOVEL     I#MTYP        FYSMTP
     C     L#MTYP        WHENEQ    'N'
     C                   MOVEL     *BLANKS       FYSMTP
     C                   OTHER
     C                   ITER
     C                   ENDSL
      * Module
     C                   SELECT
     C     L#MMOD        WHENEQ    'Y'
     C     I#MMOD        ANDEQ     *BLANKS
     C                   ITER
     C     L#MMOD        WHENEQ    'Y'
     C                   MOVEL     I#MMOD        FYMMID
     C     L#MMOD        WHENEQ    'N'
     C                   MOVEL     *BLANKS       FYMMID
     C                   OTHER
     C                   ITER
     C                   ENDSL
      * Destination Customer
     C                   SELECT
     C     L#DSCN        WHENEQ    'Y'
     C     ##DSCN        ANDEQ     *BLANKS
     C                   ITER
     C     L#DSCN        WHENEQ    'Y'
     C                   MOVEL     ##DSCN        FYDCUS
     C     L#DSCN        WHENEQ    'N'
     C                   MOVEL     *BLANKS       FYDCUS
     C                   OTHER
     C                   ITER
     C                   ENDSL
      *
     C*****KCODE2        CHAIN     @CODEL2                            90                    MD056888
     C/EXEC SQL                                                                             MD056888
     C+ SELECT *                                                                            MD056888
     C+ into :SDCODE                                                                        MD056888
     C+ from SDCODJW0                                                                       MD056888
     C+ where FYSWCD = :FYSWCD and FYSMTP = :FYSMTP and FYMMID = :FYMMID                    MD056888
     C+ and FYDCUS = :FYDCUS and FYRECI = 'D'                                               MD056888
     C/END-EXEC                                                                             MD056888
     C******IN90         IFEQ      *OFF                                                     MD056888
     C     SQLCODE       IFEQ      0                                                        MD056888
     C                   MOVEL     'Y'           ##VCDE
     C                   GOTO      EXEXCD
     C                   ENDIF
      *
     C                   ENDDO
      *
      *  Unwind subroutine stack name
      *
     C     EXEXCD        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRACCS   : Get Account Customer                              *
      *                                                               *
      *  CALLED BY: SRBTOB Validate Field :72:                        *
      *                                                               *
      *****************************************************************
     CSR   SRACCS        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SRACCS'      @STK(Q)
      *
      *  /COPY Statement
      *
     C/COPY WNCPYSRC,ME9950ACCS
      *
      *  Scan for first blank
      *
     C     ' '           SCAN      ##D035        #H
     C                   SELECT
      * Partial Nostro
     C     #H            WHENEQ    3
      *
      *  Get Nostro Code
      *
     C                   MOVEL     ##D035        P@NONB
     C     *LIKE         DEFINE    P@CYCD        ##CYCD
     C                   MOVEL     ##CYCD        P@CYCD
      *
     C                   CALL      'AONOSTR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY   '     P@OPTN
     C                   PARM      *BLANKS       P@CUST            6
     C                   PARM                    P@CYCD
     C**********           PARM *BLANKS   P@ACCN  4                                           CGL029
     C                   PARM      *BLANKS       P@ACCN           10
     C                   PARM      *BLANKS       P@ACSN            2
     C                   PARM                    P@NONB            2
     C                   PARM      *BLANKS       P@BRCD            3
     C                   PARM      *BLANKS       P@CSSN           10
     C                   PARM      *BLANKS       @PNOI             1
     C     SDNOST        PARM      SDNOST        DSFDY
      *
      *  If error on call
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'AONOSTR0'    W0FILE                         ***************
     C                   MOVEL     '*CALL'       W0KEY                          * DB ERROR 01 *
     C                   Z-ADD     1             W0ERNB                         ***************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
     C                   MOVEL     A7CUST        ##DSCN
      * Full Nostro
     C     #H            WHENEQ    6
      *
      *  Get Nostro Code
      *
     C                   MOVE      ##D035        P@NONB
     C                   MOVEL     ##D035        P@CYCD
      *
     C                   CALL      'AONOSTR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY   '     P@OPTN
     C                   PARM      *BLANKS       P@CUST            6
     C                   PARM                    P@CYCD
     C**********           PARM *BLANKS   P@ACCN  4                                           CGL029
     C                   PARM      *BLANKS       P@ACCN
     C                   PARM      *BLANKS       P@ACSN            2
     C                   PARM                    P@NONB            2
     C                   PARM      *BLANKS       P@BRCD            3
     C                   PARM      *BLANKS       P@CSSN           10
     C                   PARM      *BLANKS       @PNOI             1
     C     SDNOST        PARM      SDNOST        DSFDY
      *
      *  If error on call
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'AONOSTR0'    W0FILE                         ***************
     C                   MOVEL     '*CALL'       W0KEY                          * DB ERROR 01 *
     C                   Z-ADD     1             W0ERNB                         ***************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
     C                   MOVEL     A7CUST        ##DSCN
      * Retail Account Number
     C     #H            WHENEQ    11
     C     ACNO          CHAIN     ACCNTABF                           90
     C     *IN90         IFEQ      *ON
     C                   MOVEL     CNUM          ##DSCN
     C                   ENDIF
      * Partial Specified, <cnum><acod><acsq><brca>
     C                   OTHER
     C     6             SUBST     ##D035:1      ##DSCN
     C                   ENDSL
      *
      *  Unwind subroutine stack name
      *
     C     EXACCS        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRSWCH   : Validate SWIFT EXtended Characters                *
      *                                                               *
      *  CALLED BY: SRBTOB Validate Field :72:                        *
      *                                                               *
      *****************************************************************
     CSR   SRSWCH        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SRSWCH'      @STK(Q)
      *
      *  /COPY Statement
      *
     C/COPY WNCPYSRC,ME9950SWCH
      *
     C     ISOEX         CHECK     I#BTB         V#                5 0    90
      *
      * If invalid then get character and format number
      *
     C     *IN90         IFEQ      *ON
     C     1             SUBST     I#BTB:V#      ##001             1
     C     V#            DIV       35            V#
     C                   MVR                     R#                5 0
      *
     C                   MOVE      '894'         ERCD(E)
     C                   ADD       1             E
      *
     C                   MOVEL     'Y'           E#ERRM
      * This part of CSW005 change is to detect invalid                   CSW005
      * character on the 35th position of the field.                      CSW005
     C     R#            IFNE      0                                                           CSW00
     C                   ADD       1             V#
     C                   ELSE                                                                  CSW00
     C                   Z-ADD     35            R#                                            CSW00
     C                   ENDIF                                                                 CSW00
     C                   MOVEL(P)  V#            ##005A            5
     C                   MOVEL     R#            MEMSDT
     C     MEMSDT        CAT(P)    ##005A:0      MEMSDT
     C     MEMSDT        CAT(P)    ##001:0       MEMSDT
     C                   MOVEL     'MEC0118'     MEMSID
     C                   MOVEL     'MEMSG'       MEMSGF
     C                   EXSR      SRSNMS
     C                   MOVEA     'Y'           #ER(V#)
     C                   ENDIF
      *
      *  Unwind subroutine stack name
      *
     C     EXSWCH        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRVCDE   : Validate SWIFT Codeword details                   *
      *                                                               *
      *  CALLED BY: SRKYWD Validate Key words                         *
      *                                                               *
      *****************************************************************
     CSR   SRVCDE        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRVCDE'      @STK(Q)
      *
      * Copy point for Codeword extra validation
     C/COPY WNCPYSRC,ME9950VCDE
      *                                                                   CSW005
     C***********CSW005    IFEQ 'Y'                                CSW005 CSW097
     C***********CSW011    OREQ 'Y'                                CSW005 CSW097
      ***********                                                  CSW005 CSW097
      ***Codeword*/BROKER/*and*/ELEC/*are*specific*only*for*IRS*deaCSW005 CSW097
      ***********                                                  CSW005 CSW097
     C***********A#IRSC    IFEQ 'X'                                CSW005 CSW097
     C***********I#MMOD    ANDNE'FI'                               CSW005 CSW097
     C***********          MOVE '990'     ERCD,E                   CSW005 CSW097
     C***********          ADD  1         E                        CSW005 CSW097
     C***********          MOVEL'Y'       E#ERRM                   CSW005 CSW097
     C***********          MOVEL*BLANKS   MEMSDT                   CSW005 CSW097
     C***********          MOVEL'MEC0106' MEMSID                   CSW005 CSW097
     C***********          MOVEL'MEMSG'   MEMSGF                   CSW005 CSW097
     C***********          EXSR SRSNMS                             CSW005 CSW097
     C***********          MOVEA'Y'       #ER,#T                   CSW005 CSW097
     C***********          GOTO EXVCDE                             CSW005 CSW097
     C***********          ENDIF                                   CSW005 CSW097
      ***********                                                  CSW005 CSW097
      ***Codeword*used*is*not*a*valid*IRS*codeword.*               CSW005 CSW097
      ***********                                                  CSW005 CSW097
     C***********A#IRSC    IFEQ *BLANKS                            CSW005 CSW097
     C***********I#MMOD    ANDEQ'FI'                               CSW005 CSW097
     C***********          ADD  1         E                        CSW005 CSW097
     C***********          MOVEL'Y'       E#ERRM                   CSW005 CSW097
     C***********          MOVEL*BLANKS   MEMSDT                   CSW005 CSW097
     C***********          MOVEL'MEC0106' MEMSID                   CSW005 CSW097
     C***********          MOVEL'MEMSG'   MEMSGF                   CSW005 CSW097
     C***********          EXSR SRSNMS                             CSW005 CSW097
     C***********          MOVEA'Y'       #ER,#T                   CSW005 CSW097
     C***********          GOTO EXVCDE                             CSW005 CSW097
     C***********          ENDIF                                   CSW005 CSW097
      ***********                                                  CSW005 CSW097
     C***********          ENDIF                                   CSW005 CSW097
      *
      *  If /RCB/ then 53 and 54 must be specified
      *
     C     A#TYPE        IFEQ      '5354'
      *
      *  5354 must be Y
      *
     C     I#5354        IFEQ      *BLANKS
     C                   MOVE      '897'         ERCD(E)
     C                   ADD       1             E
      *
     C                   MOVEL     'Y'           E#ERRM
     C                   MOVEL     *BLANKS       MEMSDT
     C                   MOVEL     'MEC0116'     MEMSID
     C                   MOVEL     'MEMSG'       MEMSGF
     C                   EXSR      SRSNMS
     C                   MOVEA     'Y'           #ER(#T)
     C                   GOTO      EXVCDE
     C                   ENDIF
      *
     C                   ENDIF
      *
      *  If Intermediary
      *
     C     A#TYPE        IFEQ      'INBK'
      *
      *  Intermediary must be entered
      *
     C     I#INBT        IFEQ      *BLANKS
     C                   MOVE      '893'         ERCD(E)
     C                   ADD       1             E
      *
     C                   MOVEL     'Y'           E#ERRM
     C                   MOVEL     *BLANKS       MEMSDT
     C                   MOVEL     'MEC0108'     MEMSID
     C                   MOVEL     'MEMSG'       MEMSGF
     C                   EXSR      SRSNMS
     C                   MOVEA     'Y'           #ER(#T)
     C                   GOTO      EXVCDE
     C                   ENDIF
      *
     C                   ENDIF
      *
      *  If A/c with Institution
      *
     C     A#TYPE        IFEQ      'ACBK'
      *
      *  A/c with Institution must be entered
      *
     C     I#AWBT        IFEQ      *BLANKS
     C                   MOVE      '895'         ERCD(E)
     C                   ADD       1             E
      *
     C                   MOVEL     'Y'           E#ERRM
     C                   MOVEL     *BLANKS       MEMSDT
     C                   MOVEL     'MEC0107'     MEMSID
     C                   MOVEL     'MEMSG'       MEMSGF
     C                   EXSR      SRSNMS
     C                   MOVEA     'Y'           #ER(#T)
     C                   GOTO      EXVCDE
     C                   ENDIF
      *
     C                   ENDIF
      *
      *  If Beneficiary
      *
     C     A#TYPE        IFEQ      'BENF'
     C                   ENDIF
      *
      *  If Y in Phone check for + after last slash followed by spaces
      *  if so substitute the phone number
      *
     C     A#PHON        IFEQ      'Y'
     C                   EXSR      SRPHON
     C                   ENDIF
      *
      *  If Y in Telex check for + after last slash followed by spaces
      *  if so substitute the telex number
      *
     C     A#TELX        IFEQ      'Y'
     C                   EXSR      SRTELX
     C                   ENDIF
      *
      *  If N or Y in Blanks check for details after second slash
      *  N indicates data must be present, Y indicates must be blank
      *
     C     A#BLNK        IFNE      *BLANKS
     C                   EXSR      SRBLNK
     C                   ENDIF
      *
      *  If Number of // lines before this code word not blank then
      *  check for number of // before
      *
     C     A#SLLA        IFNE      *BLANKS
     C                   EXSR      SRSLLA
     C                   ENDIF
      *
      *  If Bank not blank then check for customer type
      *  If Y must be a bank else N must not be a bank
      *
     C     A#BANK        IFNE      *BLANKS
     C                   EXSR      SRBANK
     C                   ENDIF
      *
      *  If SWIFT specified then following information must be a SWIFT
      *  Address
      *
     C     A#BICD        IFNE      *BLANKS
     C                   EXSR      SRBICD
     C                   ENDIF
      *                                                                                       CSW214
      ** Validate PSET codeword                                                               CSW214
      *                                                                                       CSW214
     C     ##KYWD        IFEQ      '/PSET/'
     C     CSW214        IFEQ      'Y'
     C     2             SUBST     ##FLD:7       WISO              2
     C     1             SUBST     ##FLD:7       WISO1             1
     C     1             SUBST     ##FLD:8       WISO2             1
     C     27            SUBST     ##FLD:9       WEXCS            27
      *                                                                                       CSW214
     C     WISO1         IFNE      *BLANKS
     C     WISO2         ANDNE     *BLANKS
     C     WEXCS         ANDEQ     *BLANKS
      *                                                                                       CSW214
     C                   CALL      'AOMSOCR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*KEY   '     POPTN             7
     C                   PARM      WISO          WISOC             2
     C     MEISOC        PARM      MEISOC        DSFDY
      *                                                                                       CSW214
     C     PRTCD         IFNE      *BLANKS
     C     E#CPGM        IFEQ      'ME9950'
     C                   MOVE      '955'         ERCD(E)
     C                   MOVEL     'Y'           E#WARN
     C                   ELSE
     C                   MOVE      '899'         ERCD(E)
     C                   MOVEL     'Y'           E#WARN
     C                   ENDIF
      *                                                                                       CSW214
     C                   ADD       1             E
     C                   MOVEA     'Y'           #ER(#T)
     C                   GOTO      EXVCDE
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSW214
     C                   ELSE
      *                                                                                       CSW214
     C                   MOVE      '898'         ERCD(E)
     C                   ADD       1             E
      *                                                                                       CSW214
     C                   MOVEL     'Y'           E#ERRM
     C                   MOVEL     *BLANKS       MEMSDT
     C                   MOVEL     'MEC0119'     MEMSID
     C                   MOVEL     'MEMSG'       MEMSGF
     C                   EXSR      SRSNMS
     C                   MOVEA     'Y'           #ER(#T)
     C                   GOTO      EXVCDE
     C                   ENDIF
     C                   ENDIF
      *
      *  Unwind subroutine stack name
      *
     C     EXVCDE        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRPHON   : Check for Telephone substitution                  *
      *                                                               *
      *  CALLED BY: SRKYWD Validate Key words                         *
      *                                                               *
      *****************************************************************
     CSR   SRPHON        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRPHON'      @STK(Q)
      *
      * Copy point for Telephone number substitution
     C/COPY WNCPYSRC,ME9950PHON
      *
      * Get data after second slash
      *
     C     '/'           SCAN      ##FLD:2       #Z                5 0    90
     C                   ADD       1             #Z
     C     1             SUBST     ##FLD:#Z      ##001A            1
      * If a plus then must be followed by blanks
     C     ##001A        IFEQ      '+'
     C                   ADD       1             #Z
     C     35            SUB       #Z            #U                5 0
     C     #U            SUBST(P)  ##FLD:#Z      ##NARR
      *
     C     ##NARR        IFEQ      *BLANKS
      *
      * Get appropiate details
      *
     C                   SELECT
     C     A#TYPE        WHENEQ    'INBK'
     C                   MOVEL     I#INBT        ##PRTT
     C                   MOVEL     I#INBK        ##PRTY
     C     A#TYPE        WHENEQ    'ACBK'
     C                   MOVEL     I#AWBT        ##PRTT
     C                   MOVEL     I#AWBK        ##PRTY
     C     A#TYPE        WHENEQ    'BENF'
     C                   MOVEL     I#BENT        ##PRTT
     C                   MOVEL     I#BENF        ##PRTY
     C                   ENDSL
      *
     C     ##PRTT        IFNE      *BLANKS
     C                   EXSR      SRCUST
      * If phone number then substitute
     C     BBCTNB        IFNE      *BLANKS
     C     ##FLD         CAT       BBCTNB:0      ##FLD
      * Move back result
     C                   SELECT
     C     #T            WHENEQ    1
     C                   MOVEL     ##FLD         I#BTB1
     C     #T            WHENEQ    2
     C                   MOVEL     ##FLD         I#BTB2
     C     #T            WHENEQ    3
     C                   MOVEL     ##FLD         I#BTB3
     C     #T            WHENEQ    4
     C                   MOVEL     ##FLD         I#BTB4
     C     #T            WHENEQ    5
     C                   MOVEL     ##FLD         I#BTB5
     C     #T            WHENEQ    6
     C                   MOVEL     ##FLD         I#BTB6
     C                   ENDSL
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      *
      *  Unwind subroutine stack name
      *
     C     EXPHON        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRTELX   : Check for Telex substitution                      *
      *                                                               *
      *  CALLED BY: SRKYWD Validate Key words                         *
      *                                                               *
      *****************************************************************
     CSR   SRTELX        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRTELX'      @STK(Q)
      *
      * Copy point for Telex substitution
     C/COPY WNCPYSRC,ME9950TELX
      *
      * Get data after second slash
      *
     C     '/'           SCAN      ##FLD:2       #Z                5 0    90
     C                   ADD       1             #Z
     C     1             SUBST     ##FLD:#Z      ##001A            1
      * If a plus then must be followed by blanks
     C     ##001A        IFEQ      '+'
     C                   ADD       1             #Z
     C     35            SUB       #Z            #U                5 0
     C     #U            SUBST(P)  ##FLD:#Z      ##NARR
      *
     C     ##NARR        IFEQ      *BLANKS
      *
      * Get appropiate details
      *
     C                   SELECT
     C     A#TYPE        WHENEQ    'INBK'
     C                   MOVEL     I#INBT        ##PRTT
     C                   MOVEL     I#INBK        ##PRTY
     C     A#TYPE        WHENEQ    'ACBK'
     C                   MOVEL     I#AWBT        ##PRTT
     C                   MOVEL     I#AWBK        ##PRTY
     C     A#TYPE        WHENEQ    'BENF'
     C                   MOVEL     I#BENT        ##PRTT
     C                   MOVEL     I#BENF        ##PRTY
     C                   ENDSL
      *
     C     ##PRTT        IFNE      *BLANKS
     C                   EXSR      SRCUST
      * If phone number then substitute
     C     BBTXA1        IFNE      *BLANKS
     C     ##FLD         CAT       BBTXA1:0      ##FLD
      * Move back result
     C                   SELECT
     C     #T            WHENEQ    1
     C                   MOVEL     ##FLD         I#BTB1
     C     #T            WHENEQ    2
     C                   MOVEL     ##FLD         I#BTB2
     C     #T            WHENEQ    3
     C                   MOVEL     ##FLD         I#BTB3
     C     #T            WHENEQ    4
     C                   MOVEL     ##FLD         I#BTB4
     C     #T            WHENEQ    5
     C                   MOVEL     ##FLD         I#BTB5
     C     #T            WHENEQ    6
     C                   MOVEL     ##FLD         I#BTB6
     C                   ENDSL
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      *
      *  Unwind subroutine stack name
      *
     C     EXTELX        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRBLNK   : Check for blanks after codeword                   *
      *                                                               *
      *  CALLED BY: SRKYWD Validate Key words                         *
      *                                                               *
      *****************************************************************
     CSR   SRBLNK        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRBLNK'      @STK(Q)
      *
      * Copy point for Blanks after codeword
     C/COPY WNCPYSRC,ME9950BLNK
      *
      * Get data after second slash
      *
     C     '/'           SCAN      ##FLD:2       #Z                5 0    90
     C                   ADD       1             #Z
     C     35            SUB       #Z            #U                5 0
     C     #U            SUBST(P)  ##FLD:#Z      ##NARR
      *
      * If Y then must be blank else non-blank
      *
     C     A#BLNK        IFEQ      'Y'
     C     ##NARR        ANDNE     *BLANKS
     C                   MOVE      '993'         ERCD(E)
     C                   ADD       1             E
      *
     C                   MOVEL     'Y'           E#ERRM
     C                   MOVEL     *BLANKS       MEMSDT
     C                   MOVEL     #T            MEMSDT
     C                   MOVEL     'MEC0111'     MEMSID
     C                   MOVEL     'MEMSG'       MEMSGF
     C                   EXSR      SRSNMS
     C                   MOVEA     'Y'           #ER(#T)
     C                   GOTO      EXBLNK
     C                   ENDIF
      * Non-blank required
     C     A#BLNK        IFEQ      'N'
     C     ##NARR        ANDEQ     *BLANKS
     C                   MOVE      '993'         ERCD(E)
     C                   ADD       1             E
      *
     C                   MOVEL     'Y'           E#ERRM
     C                   MOVEL     *BLANKS       MEMSDT
     C                   MOVEL     #T            MEMSDT
     C                   MOVEL     'MEC0112'     MEMSID
     C                   MOVEL     'MEMSG'       MEMSGF
     C                   EXSR      SRSNMS
     C                   MOVEA     'Y'           #ER(#T)
     C                   GOTO      EXBLNK
      *
     C                   ENDIF
      *
      *
      *  Unwind subroutine stack name
      *
     C     EXBLNK        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRSLLA   : Check that number of // lines before codeword     *
      *                                                               *
      *  CALLED BY: SRKYWD Validate Key words                         *
      *                                                               *
      *****************************************************************
     CSR   SRSLLA        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRSLLA'      @STK(Q)
      *
      * Copy point for Customer details
     C/COPY WNCPYSRC,ME9950SLLA
      *
      *  Calculate the line to start from
      *
     C     #T            ADD       1             #G                5 0
     C     #G            IFGT      6
     C                   Z-ADD     6             #G
     C                   ENDIF
      *
      *  Calculate the line to end at
      *
     C                   Z-ADD     6             #H                5 0
      *
      *  Calculate the number of lines to check
      *
     C     6             SUB       #T            #I                5 0
      *
      *  If the number of check lines is greater than the number
      *  of check lines continue else exit routine
      *
     C     A#SLLN        CABGT     #I            EXSLLA
      *
      *  Loop through lines obtaining the first two characters
      *
     C                   Z-ADD     0             #I
     C     #T            MULT      35            #J                5 0
     C                   ADD       1             #J
     C                   MOVEA     *BLANKS       SL
     C     #G            DO        #H
     C                   ADD       1             #I
     C     2             SUBST     I#BTB:#J      ##002A            2
     C                   MOVEA     ##002A        SL(#I)
     C                   ADD       35            #J
     C                   ENDDO
      *
      *  Now check that the number of // is less than A#SLLN
      *
     C                   DO        #I            #H
     C     SL(#H)        IFNE      '//'
     C                   LEAVE
     C                   ENDIF
      *
      *  If thee number of // is equal then error
      *
     C     A#SLLN        IFLE      #H
     C                   MOVE      '998'         ERCD(E)
     C                   ADD       1             E
      *
     C                   MOVEL     'Y'           E#ERRM
     C                   MOVEL     *BLANKS       MEMSDT
     C                   MOVEL(P)  A#SLLN        ##001A            1
     C                   MOVEL     #T            MEMSDT
     C     MEMSDT        CAT(P)    ##001A:0      MEMSDT
     C                   MOVEL     'MEC0120'     MEMSID
     C                   MOVEL     'MEMSG'       MEMSGF
     C                   EXSR      SRSNMS
     C                   MOVEA     'Y'           #ER(#T)
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
      *
      *  Unwind subroutine stack name
      *
     C     EXSLLA        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRBANK   : Check that Customer/C'party is a bank             *
      *                                                               *
      *  CALLED BY: SRKYWD Validate Key words                         *
      *                                                               *
      *****************************************************************
     CSR   SRBANK        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRBANK'      @STK(Q)
      *
      * Copy point for Bank check
     C/COPY WNCPYSRC,ME9950BANK
      *
      * Get appropiate details
      *
     C                   SELECT
     C     A#TYPE        WHENEQ    'INBK'
     C                   MOVEL     I#INBT        ##PRTT
     C                   MOVEL     I#INBK        ##PRTY
     C     A#TYPE        WHENEQ    'ACBK'
     C                   MOVEL     I#AWBT        ##PRTT
     C                   MOVEL     I#AWBK        ##PRTY
     C     A#TYPE        WHENEQ    'BENF'
     C                   MOVEL     I#BENT        ##PRTT
     C                   MOVEL     I#BENF        ##PRTY
     C                   ENDSL
      *
     C     ##PRTT        IFNE      *BLANKS
     C                   EXSR      SRCUST
      *
      * Report error depending on validation required
      *
      * Must be a bank
     C     A#BANK        IFEQ      'Y'
     C     W9CUST        ANDEQ     'Y'
     C     BBBNBI        ANDNE     'Y'
     C     A#BANK        OREQ      'Y'
     C     W9CNST        ANDEQ     'Y'
     C     AWSWID        ANDEQ     *BLANKS
     C                   MOVE      '995'         ERCD(E)
     C                   ADD       1             E
      *
     C                   MOVEL     'Y'           E#ERRM
     C                   MOVEL     #T            MEMSDT
     C                   MOVEL     'MEC0109'     MEMSID
     C                   MOVEL     'MEMSG'       MEMSGF
     C                   EXSR      SRSNMS
     C                   MOVEA     'Y'           #ER(#T)
     C                   GOTO      EXBANK
      *
     C                   ENDIF
      * Must not be a bank
     C     A#BANK        IFEQ      'N'
     C     W9CUST        ANDEQ     'Y'
     C     BBBNBI        ANDEQ     'Y'
     C     A#BANK        OREQ      'N'
     C     W9CNST        ANDEQ     'Y'
     C     AWSWID        ANDNE     *BLANKS
     C     A#BANK        OREQ      'N'
     C     W9BICD        ANDEQ     'Y'
     C                   MOVE      '995'         ERCD(E)
     C                   ADD       1             E
      *
     C                   MOVEL     'Y'           E#ERRM
     C                   MOVEL     #T            MEMSDT
     C                   MOVEL     'MEC0110'     MEMSID
     C                   MOVEL     'MEMSG'       MEMSGF
     C                   EXSR      SRSNMS
     C                   MOVEA     'Y'           #ER(#T)
     C                   GOTO      EXBANK
      *
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      *  Unwind subroutine stack name
      *
     C     EXBANK        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRBICD   : Check that SWIFT BIC entered after codeword       *
      *                                                               *
      *  CALLED BY: SRKYWD Validate Key words                         *
      *                                                               *
      *****************************************************************
     CSR   SRBICD        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRBICD'      @STK(Q)
      *
      * Copy point for SWIFT BIC check
     C/COPY WNCPYSRC,ME9950BICD
      *
      * Get data after second slash
      *
     C     '/'           SCAN      ##FLD:2       #Z                5 0    90
     C                   ADD       1             #Z
     C     35            SUB       #Z            #U                5 0
     C     #U            SUBST(P)  ##FLD:#Z      ##NARR
      *
      * Get first 11 characters
      *
     C     ##NARR        IFNE      *BLANKS
     C     11            SUBST(P)  ##NARR:1      ##PRTY
     C                   MOVEL     'S'           ##PRTT
     C                   EXSR      SRCUST
      * Must be a SWIFT
     C     W9CUST        IFNE      'Y'
     C     W9CNST        ANDNE     'Y'
     C     W9BICD        ANDNE     'Y'
     C                   MOVE      '897'         ERCD(E)
     C                   ADD       1             E
      *
     C                   MOVEL     'Y'           E#ERRM
     C                   MOVEL     *BLANKS       MEMSDT
     C                   MOVEL     'MEC0117'     MEMSID
     C                   MOVEL     'MEMSG'       MEMSGF
     C                   EXSR      SRSNMS
     C                   MOVEA     'Y'           #ER(#T)
     C                   GOTO      EXBICD
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      *
      *  Unwind subroutine stack name
      *
     C     EXBICD        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRCUST   : Get Customer/Counterparty Nostro/ Bic Information *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SRCUST        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRCUST'      @STK(Q)
      *
      * Copy point for Customer details
     C/COPY WNCPYSRC,ME9950CUST
      *
      * If a customer look up SDCUSTPD
     C     ##PRTT        IFEQ      'C'
     C     ##PRTT        OREQ      'X'
      *
      *  Call to access pgm for Customer details
      *
     C     *LIKE         DEFINE    I#PRTY        ##PRTY
     C     *LIKE         DEFINE    I#PRTT        ##PRTT
     C                   MOVEL     ##PRTY        P@CNUM
      *
     C                   CALL      'AOCUSTR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      '*KEY   '     P@OPTN            7
     C                   PARM                    P@CNUM           10
     C                   PARM      *BLANKS       P@KYST            7
     C     SDCUST        PARM      *BLANKS       DSSDY
      *
     C     *IN90         IFEQ      '1'
     C     P@RTCD        ORNE      *BLANKS
     C     ##PRTT        ANDNE     'X'
     C                   MOVEL     'AOCUSTR0'    W0FILE                         ***************
     C                   MOVEL     '*CALL'       W0KEY                          * DB ERROR 01 *
     C                   Z-ADD     1             W0ERNB                         ***************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C                   MOVEL     'Y'           W9CUST
     C                   GOTO      EXCUST
      *
     C                   ENDIF
      *
      * If a customer or counterparty nostros look up SDCNSTPD
     C     ##PRTT        IFEQ      'X'
      *
      *  Call to access pgm for Counterpart Nostros
      *
     C                   MOVEL     ##PRTY        P@CNCD
      *
     C                   CALL      'AOCNSTR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      '*KEY   '     P@OPTN            7
     C                   PARM                    P@CNCD            8
     C**********           PARM *BLANKS   P@KYST  7                                           222373
     C     SDCUST        PARM      *BLANKS       DSSDY
      *
     C     *IN90         IFEQ      '1'
     C     P@RTCD        ORNE      *BLANKS
     C                   MOVEL     'AOCNSTR0'    W0FILE                         ***************
     C                   MOVEL     '*CALL'       W0KEY                          * DB ERROR 02 *
     C                   Z-ADD     2             W0ERNB                         ***************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C                   MOVEL     'Y'           W9CNST
     C                   GOTO      EXCUST
      *
     C                   ENDIF
      *
      * If a BIC use ME1400 to access information
     C     ##PRTT        IFEQ      'S'
      *
      *  Call Access object to validate identifier
      *
     C                   MOVEL     ##PRTY        W9BICC
     C     3             SUBST     ##PRTY:9      W9BICB
      *
     C                   CALL      'ME1400'
     C                   PARM      *BLANKS       W9RTN             7
     C                   PARM                    W9BICC            8
     C                   PARM                    W9BICB            3
     C                   PARM                    SDCUST
     C                   PARM                    SDCNST
     C                   PARM                    MEBICD
     C                   PARM      *BLANKS       W9CUST            1
     C                   PARM      *BLANKS       W9CNST            1
     C                   PARM      *BLANKS       W9BICD            1
      *
     C                   SELECT
      *
      *  Record not found - S.W.I.F.T does not exist
      *
     C     W9RTN         WHENEQ    'Y2U0005'
      * No action
      *
      *  Use data depending on file that the data exists on
      *
     C     W9BICD        WHENEQ    'Y'
      *
     C     W9CUST        WHENEQ    'Y'
      *
     C     W9CNST        WHENEQ    'Y'
      *
     C                   ENDSL
      *
     C                   ENDIF
      *
      *  Unwind subroutine stack name
      *
     C     EXCUST        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRCHKC   : Check Currency Combination                        *
      *                                                               *
      *  CALLED BY: *NONE                                             *
      *                                                               *
      *****************************************************************
     CSR   SRCHKC        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRCHKC'      @STK(Q)
      *
      * Copy point for Currency Clearing System Get Details
     C/COPY WNCPYSRC,ME9950CHKC
      *
      * Use access object to obtain details
      *
     C                   CALL      'AOCCSYR0'                           9090
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY    '    P@OPTN
     C                   PARM                    P@CYCD            3
     C                   PARM                    P@CLSY            2
     C     DSCCSY        PARM      *BLANKS       DSFDY
      *
      *  If return with an error (LR seton in called program) then
      *  process for database error.
      *
     C     *IN90         IFEQ      '1'
     C     P@RTCD        OREQ      '*ERROR*'
     C                   MOVEL     'AOCCSYR0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY                          ***************
     C                   Z-ADD     3             W0ERNB                         * DB ERROR 03 *
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      *  Unwind subroutine stack name
      *
     C     EXCHKC        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRSNMS   : Send Message to Calling program                   *
      *                                                               *
      *  CALLED BY: *Any Error                                        *
      *                                                               *
      *****************************************************************
     CSR   SRSNMS        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SRSNMS'      @STK(Q)
      *
      * Copy point for Send error message
     C/COPY WNCPYSRC,ME9950SNMS
      *
      * Obtain leading text for field
      *
     C     E#MSGD        IFNE      *BLANKS
     C                   CALL      'MEC1150'                            9090
     C                   PARM      E#MSGD        #MSGID
     C                   PARM      E#MSGF        #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C     MEMSDT        CAT       #MSTX1:0      MEMSDT
     C                   END
      *
      * Send message
      *
     C                   MOVEL     E#CPGM        MEPGMQ
     C                   EXSR      MESNMS
      *
      *  Unwind subroutine stack name
      *
     C     EXSNMS        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRINIT   : Initialise and define fields                      *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SRINIT        BEGSR
      *
      *  Set up copyright statement
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SRINIT'      @STK(Q)
      *
      *  Indicate that set up is complete
      *
     C                   MOVEL     'Y'           $FIRST            1
      *
      *  Get Rundate information
      *
     C     *DTAARA       DEFINE    RUNDAT        RUNDTA
     C                   IN        RUNDTA
     C                   MOVE      AGMRDT        WUMRDT            7            Midas Run date
     C                   MOVE      AGRDNB        WURDNB            5 0          Run day number
     C                   MOVE      AGSUC         WUSUC             1            Set up complete
     C                   MOVE      AGDFF         WUDFF             1            Date Format
     C                   MOVE      AGMBIN        WUMBIN            1            Multi Branched
      *
      * Get modules information
      *
     C                   CALL      'AOMMODR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7            B:Return code
     C                   PARM      '*FIRST '     P@OPTN            7            I:Option
     C     MMODDS        PARM      *BLANKS       DSFDY                          O:Module Flg
      *
      *  If return with an error (LR seton in called program) then
      *  process for database error.
      *
     C     *IN90         IFEQ      '1'
     C     P@RTCD        OREQ      '*ERROR*'
     C                   MOVEL     'AOMMODR0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY                          ***************
     C                   Z-ADD     5             W0ERNB                         * DB ERROR 05 *
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      * Check if SWIFT 96 active
      *
     C                   CALL      'SWIFT96'                            9090
     C                   PARM      *BLANKS       CSW096            7            B:Return code
      *
      *  If return with an error (LR seton in called program) then
      *  process for database error.
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'SWIFT96'     W0FILE
     C                   MOVEL     '*CALL'       W0KEY                          ***************
     C***********          Z-ADD6         W0ERNB           * DB ERROR 05 *CSW005
     C                   Z-ADD     6             W0ERNB                         * DB ERROR 06 *CSW00
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *                                                                                       CSW208
      ** Access AOSARDR0 to check if CSW208 is switched on                                    CSW208
      *                                                                                       CSW208
     C                   MOVEL     'N'           CSW208            1
     C                   CALL      'SWIF2008'
     C                   PARM      *BLANKS       P@RTCD
      *                                                                                       CSW208
     C     P@RTCD        IFEQ      'CSW2008'
     C                   MOVEL     'Y'           CSW208
     C                   END
      *                                                                                       CSW214
      ** Check if SWIFT Changes 2014 (CSW214) is installed                                    CSW214
      *                                                                                       CSW214
     C                   MOVEL     'N'           CSW214            1
     C                   CALL      'SWIF2014'
     C                   PARM      *BLANKS       PRTCD
      *                                                                                       CSW214
     C     PRTCD         IFEQ      'CSW2014'
     C                   MOVEL     'Y'           CSW214
     C                   ENDIF
      *                                                                   CSW005
      ** Access AOSARDR0 to check if CSW005 is switched on                CSW005
      *                                                                   CSW005
     C                   CALL      'AOSARDR0'                                                  CSW00
     C                   PARM      *BLANKS       P@RTCD                                        CSW00
     C                   PARM      '*VERIFY'     P@OPTN                                        CSW00
     C                   PARM      'CSW005'      P@SARD            6                           CSW00
     C     SCSARD        PARM      SCSARD        DSFDY                                         CSW00
      *                                                                   CSW005
     C     P@RTCD        IFNE      *BLANKS                                                     CSW00
     C     P@RTCD        ANDNE     '*NRF   '                                                   CSW00
     C                   MOVEL     'AOSARDR0'    W0FILE                                        CSW00
     C                   MOVEL     '*CALL'       W0KEY                          ***************CSW00
     C                   Z-ADD     7             W0ERNB                         * DB ERROR 07 *CSW00
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************CSW00
     C                   MOVEL     'MIDAS  '     W0MSGF                                        CSW00
     C                   EXSR      SRERR                                                       CSW00
     C                   END                                                                   CSW00
      *                                                                   CSW005
     C     P@RTCD        IFEQ      *BLANKS                                                     CSW00
     C                   MOVE      'Y'           CSW005            1                           CSW00
     C                   ELSE                                                                  CSW00
     C                   MOVE      'N'           CSW005                                        CSW00
     C                   ENDIF                                                                 CSW00
      *                                                                   CSW011
      ** Access AOSARDR0 to check if CSW011 is switched on                CSW011
      *                                                                   CSW011
     C                   CALL      'AOSARDR0'                                                  CSW01
     C                   PARM      *BLANKS       P@RTCD                                        CSW01
     C                   PARM      '*VERIFY'     P@OPTN                                        CSW01
     C                   PARM      'CSW011'      P@SARD            6                           CSW01
     C     P@RTCD        IFEQ      *BLANKS                                                     CSW01
     C                   MOVE      'Y'           CSW011            1                           CSW01
     C                   ELSE                                                                  CSW01
     C                   MOVE      'N'           CSW011                                        CSW01
     C                   ENDIF                                                                 CSW01
      *                                                                                       CSW201
      ** Check if SWIFT 2001 is installed                                                     CSW201
      *                                                                                       CSW201
     C                   CALL      'SWIF2001'                           1212
     C                   PARM      *BLANKS       P@RTCD
      *                                                                                       CSW201
     C     *IN12         IFEQ      *ON
     C                   MOVEL     'SWIF2001'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY
     C                   Z-ADD     10            W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
      *                                                                                       CSW201
     C                   ELSE
     C     P@RTCD        IFEQ      'CSW2001'
     C                   MOVE      'Y'           CSW201            1
     C                   ELSE
     C                   MOVE      'N'           CSW201
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSW215
      ** Check if SWIFT Changes 2015 (CSW215) is installed                                    CSW215
      *                                                                                       CSW215
     C                   MOVEL     'N'           CSW215            1
     C                   CALL      'SWIF2015'
     C                   PARM      *BLANKS       PRTCD
      *                                                                                       CSW215
     C     PRTCD         IFEQ      'CSW2015'
     C                   MOVEL     'Y'           CSW215
     C                   END
      *
      * Open ACNUM for look up by Retail account Number
      *
     C                   OPEN      ACNUM
      *
      * Open SDCODEL2 for checking of new codewords
      *
     C*********          OPEN      SDCODEL2                                                 MD056888
      *
      * Read SDCODEL2 to see if live records
      *
     C**********         READ      SDCODEL2                               90                MD056888
     C                   Z-add     0             COUNT             5 0                      MD056888
     C/EXEC SQL                                                                             MD056888
     C+ declare Cursor insensitive scroll cursor for                                        MD056888
     C+ select *                                                                            MD056888
     C+  from SDCODJW0 where FYRECI = 'D'                                                   MD056888
     C/END-EXEC                                                                             MD056888
                                                                                            MD056888
     C/EXEC SQL                                                                             MD056888
     C+ open Cursor                                                                         MD056888
     C/END-EXEC                                                                             MD056888
                                                                                            MD056888
     C/EXEC SQL                                                                             MD056888
     C+ get diagnostics :Count = DB2_NUMBER_ROWS                                            MD056888
     C/END-EXEC                                                                             MD056888
                                                                                            MD056888
     C/EXEC SQL                                                                             MD056888
     C+ close Cursor                                                                        MD056888
     C/END-EXEC                                                                             MD056888
                                                                                            MD056888
     C******IN90         IFEQ      *ON                                                      MD056888
     C     Count         IFEQ      0                                                        MD056888
     C                   MOVEL     'N'           SWCODE            1
     C                   ELSE
     C                   MOVEL     'Y'           SWCODE
     C                   ENDIF
      *
     C                   Z-ADD     1             L#NBR             5 0
      * Load Occurrance data structure
     C*COPY*MECPYSRC,ME9950LOAD                                                             MD056888
     C/COPY MECPYSRC,ME9950LADL                                                             MD056888
      *
      * Copy point for Initialisation
     C/COPY WNCPYSRC,ME9950INIT
      *
      *  Unwind subroutine stack name
      *
     C     EXINIT        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *                                                                                       CSC022
      ** Check if CSC022 is switched *ON.                                                     CSC022
      *                                                                                       CSC022
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CSC022'      @SARD             6
      *                                                                                       CSC022
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CSC022            1
     C     *DTAARA       DEFINE    SCCMTJOB      SCCMT
     C                   IN        SCCMT
     C                   Z-ADD     1             C                 3 0
     C                   MOVEL     *BLANKS       WCMTSK            1
     C                   MOVEA     CMTARR        CMTJOB
     C     CMTNUM        IFGT      0
     C     C             DOWLE     CMTNUM
     C     ##JOB         IFEQ      CMTJOB(C)
     C                   MOVEL     'Y'           WCMTSK
     C                   ENDIF
     C                   ADD       1             C
     C                   ENDDO
     C                   ENDIF
     C                   ELSE
     C                   MOVE      'N'           CSC022
     C                   ENDIF
      *
      ** Check if CDL094 is switched *ON.                                                     CDL094
      *                                                                                       CDL094
     C                   MOVE      'N'           CDL094            1
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CDL094'      @SARD             6
      *                                                                                       CDL094
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CDL094            1
     C                   ENDIF
      *                                                                                       CDL094
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
     C/COPY WNCPYSRC,ME9950DCPG
      *
      *  /Copy point for Calculations
      *
     C/EJECT
      *
      *  File and Program Error Processing
      *
     C*COPY*MECPYSRC,SRERRC                                                                 MD056888
     C/COPY MECPYSRC,SRERRCLE                                                               MD056888
      * Standard send-program-message routine /COPY
     C*COPY*MECPYSRC,SMESNMSC                                                               MD056888
     C/COPY MECPYSRC,SMESNMSCLE                                                             MD056888
     C/EJECT
     C/COPY WNCPYSRC,ME9950DOPG
      *
      *  /Copy point for Outputs
      *
      ***CDEA,*add*Y*in*position*11*for*code*words*/PHON/*&*/TELEX/CSW005 CSW097
      ***Also,*use*spare*rcds*22*and*23*for*codewords*/BROKER/*&*/ECSW005 CSW097
**  CPY@
(c) Finastra International Limited 2001
**  CDEW/CDEA Code  typePTB0BS1234567890
     X/COPY WNCPYSRC,ME9950X002
/REC/                     N
/INT/               INBK  N
/ACC/               ACBK                                                                      245501
/BNF/                                                                                         245501
/INS/                     N                                                                 MD027698
/OGB/               BENF  N2Y
/CHEQUE/
/CONFIRM/
/HOLD/
/RESERVE/
/CABLE/             ACBK
/PHON/              ACBKY                                           CSW005CSW097
/TELE/              ACBK Y                                          096299CSW097
/CABLEBEN/          BENF
/PHONBEN/           BENFY
/TELEBEN/           BENF Y                                                096299
/CABLEIBK/          INBK
/PHONIBK/           INBKY
/TELEIBK/           INBK Y                                                096299
/RCB/               5354  N  Y
/*spare/            typePTB0B0S234567890                            CSW005CSW097
/*spare/            typePTB0B0S234567890                            CSW005CSW097
/*spare/            typePTB0B0S234567890
/*spare/            typePTB0B0S234567890
/*spare/            typePTB0B0S234567890
/*spare/            typePTB0B0S234567890
/*spare/            typePTB0B0S234567890
/*spare/            typePTB0B0S234567890
/*spare/            typePTB0B0S234567890
/INTRACOM/                                                                                    219242
/CORPTRAD/                                                                                    219242
/PSET/                                                                                        CSW214
**  TTYP/TMOD Code  Transaction Type to Module conversion
ATDL
BDDL
BPDL
BRDL
BSDL
CDDL
CIDL
CLDL
CSDL
CXDL
C1DL
C2DL
DADL
DLDL
FFDL
FPDL
FSDL
FXDL
IPDL
ITDL
MFDL
MMDL
NPDL
NSDL
OPDL
OTDL
PDDL
PIDL
RADL
SCDL
SIDL
SWDL
TADL
TDDL
TIDL
TRDL
TSDL
     X/COPY WNCPYSRC,ME9950X001
**  CFRA FRA/IRS Codes                                                                        CSW208
/TIME/                                                                                        CSW208
/VENU/                                                                                        CSW208
