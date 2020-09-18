     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL Shadow Post Update Processing')               *
/*OVRF*: OVRDBF (File in program) (file on system)                  : *
      *****************************************************************
      *                                                               *
      *  Midas - GL Shadow Post Interface                             *
      *                                                               *
      *  GL002200 - Shadow Post Update Processing                     *
      *                                                               *
      *  Function:  This program runs daily in Input Cycle. It        *
      *             verifies if an account is o.k. for transaction    *
      *             and depending on action code updates the shadow   *
      *             post files.                                       *
      *                                                               *
      *  Called By: GLC002200  - Start Shadow Post Interface          *
      *                                                               *
      *  (c) Finastra International Limited 2017                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 AR1096687          Date 04Apr17               *
      *                 AR1069768          Date 04Apr17               *
      *                 AR1038758          Date 04Apr17               *
      *                 CGL027  *CREATE    Date 04Apr17               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  AR1096687A - All shadow postings CGL027 movements are near   *
      *  AR1069768 - Write correct error info to SHDOUTTD             *
      *  AR1038758 - Shadow Interface Posting not updating Balance.   *
      *            - Include the movement type in the parameter to be *
      *              passed on the call to AOSPOSU0 as this field is  *
      *              used by RE001501 on how to update GLACNTQD.      *
      *              (Child: AR1038759)                               *
      *  CGL027 - Shadow Postings and Sufficient Funds Check          *
      *                                                               *
      *****************************************************************
     FSHDINPTD  O    E           K DISK    INFSR(SRFILE)
     FSHDOUTTD  O    E           K DISK    INFSR(SRFILE)
      *****************************************************************
      *  Indicator usage                                              *
      *  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯                                              *
      *  90   -    ROLBK indicator                                    *
      *  99   -    General work indicator                             *
      *                                                               *
      *****************************************************************
      *
      ** Copyright array.
      *
     D/COPY CGCPYSRC,SRERRDLE
     D/EJECT
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** External DS for bank details
      *
     D SHDINP        E DS                  EXTNAME(SHDINPTD)
      *
      ** External DS for Shadow Input Data
      *
     D SHDOUT        E DS                  EXTNAME(SHDOUTTD)
     D  BOUNID       E                     EXTFLD(BTUNID)
      *
      ** External DS for Shadow Output Data
      *
     D D@ACCT        E DS                  EXTNAME(ACCNTAB)
      *
      ** Account Details DS for assigning data from Access
      ** Programs to work fields
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, short data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** First DS for access programs, long data structure
      *
     D CPYR            DS
      ** Data Structure for Compilation - Copyright Insertion
     D  ##CPY                  1     80
     D                                     DIM(1) CTDATA PERRCD(1)
      *
     D  ##ERR          S            100    DIM(4) CTDATA PERRCD(1)
      *
     D JBDTTM          DS
      * Job date/time
     D  ##JTM                  7     12  0
     D  ##JHH                  7      8  0
     D  ##JNN                  9     10  0
     D  ##JSS                 11     12  0
      *
      ** Defined Constants
      *
     D #FORCE          C                   CONST('*FORCE    ')
     D #CHECK          C                   CONST('*CHECK    ')
     D #CHKUP          C                   CONST('*CHECKUPD ')
      *
      ** Calling parameter data structure for AOSPOSU0
      *
     D C#DTA           DS           256
     D  C#ATYP                 1      1
     D  C#ACCT                 2     19
     D  C#CNU1                 2      7
     D  C#CCY1                 8     10
     D  C#ACS1                15     16  0
     D  C#BRC1                17     19
     D  C#NOSN                 2      3  0
     D  C#NOS                  2      6
     D  C#ACNO                 2     11  0
     D  C#CNUM                 2      7
     D  C#ACSQ                12     13  0
     D  C#BRCA                14     16
     D  C#IO                  24     24
     D  C#CCY                 25     27
     D  C#TRYP                28     29
     D  C#NARR                30     59
     D  C#CHQN                60     67  0
     D  C#PREF                68     82
     D  C#TRN                 83     88
     D  C#AMT                 89     96P 0
     D  C#PRON                97     97
     D  C#OLPS                98     98
     D  C#MEMS                99     99
     D  C#RSAC               100    100
     D  C#MOD                101    102
     D  C#OLRC               103    104
     D  C#FTOV               105    105
     D  C#VDAT               106    108P 0
     D  C#PSTD               109    111P 0
     D  C#ACO1               121    130  0
     D  C#ACOD               131    140  0
     D  C#MTYP               161    161                                                    AR1038758
      *
      *
     D DSMTR           DS
      *
      ** Define fields for message transalation
      *
     D  #MSDTA                 1    132
     D  #MSTX1               133    264
     D #MSTX2          DS
     D  #MSTXA                 1    256
     D  #MSTXB               257    512
      *
     D PRtAcNum        S             10S 0
     D PCusn           S              6A
     D PCurr           S              3A
     D PAcod           S             10S 0
     D PAcsq           S              2S 0
     D PBrch           S              3A
     D PTrnTyp         S             10A
     D PValDat         S              5S 0
     D PAmt            S             15S 0
     D PErr01          S              7A
     D PErr02          S              7A
     D PActBal         S             15S 0
     D PAvlBal         S             15S 0
     D PFailDat        S              5S 0
     D PFailBal        S             15S 0
      *
     D @BLAF           S             15S 0
     D @BLBF           S             15S 0
     D @RCD            S              1A
      *
     C/EJECT
      *****************************************************************
      *                                                               *
      *   Index to subroutines                                        *
      *   --------------------                                        *
      *                                                               *
      *   SRINIT - Initial processing - On First Call                 *
      *   *PSSR  - Exception/Error Handling                           *
      *****************************************************************
     C/EJECT
      *****************************************************************
      * Process     :  MAINLINE                                       *
      * Function    :  Mainline processing                            *
      *                                                               *
      * Called by   :  None                                           *
      * Calls       :  SRINIT - Initial Processing - On First Call    *
      *                SRCHKA - Check Account exits                   *
      *                SRSCHK - Sufficient Funds Check                *
      *                SRSHDP - Shadow Post                           *
      *                SRSHDP - Set up return data                    *
      *****************************************************************
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'MAIN'        @STK(Q)
      *
     C     *ENTRY        PLIST
     C                   PARM                    INDATA          256
     C                   PARM                    OTDATA          256
      *
      ** Initial processing - Once Only
      *
     C     #FIRST        IFEQ      *BLANKS
     C                   EXSR      SRINIT
     C                   MOVEL     'Y'           #FIRST            1
     C                   ENDIF
      *
      ** Set up Primary Reference to be Input Data
      *
     C                   MOVEL     INDATA        W0PREF
      *
     C                   MOVEL     INDATA        SHDINP
     C                   WRITE     SHDINPT0
      *
      ** Check Account Exists
      *
     C                   EXSR      SRCHKA
     C     #NOACC        CABNE     *BLANKS       EXMAIN
     C     BTSUCC        CABEQ     'N'           EXMAIN
      *
      ** Sufficient Funds Check if debit
      ** Initialise return code indicator
      *
     C                   MOVE      'Y'           @RCD
      *
      ** Sufficient Funds Check if Retail
     C     ATYP          IFEQ      'R'
     C                   EXSR      SRSCHK
     C                   ENDIF
      *
      ** Update Shadow Post
      *
     C     BTACTC        IFEQ      #FORCE
     C     @RCD          OREQ      'Y'
     C     BTDCIN        OREQ      'C'
      *
      ** Set success indicator
     C                   MOVEL     'Y'           BTSUCC
      *
      ** Update Shadow Postings if Force or Update requested
     C     BTACTC        IFEQ      #FORCE
     C     BTACTC        OREQ      #CHKUP
     C                   EXSR      SRSHDP
     C                   ENDIF
     C                   ENDIF
      *
     C     EXMAIN        TAG
      *
      ** Set Up Return Data
      *
     C                   EXSR      SRRTND
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C                   RETURN
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      * Subroutine  :  SRCHKA                                         *
      * Function    :  Check Account Exists                           *
      *                                                               *
      * Called by   :                                                 *
      * Calls       :  AOACCTR0 - Accounts Master read                *
      *****************************************************************
     C     SRCHKA        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRCHKA'      @STK(Q)
      *
      ** Initialise output data and work values
      *
     C                   CLEAR                   OTDATA
     C                   CLEAR                   SHDOUT
     C                   MOVEL     *BLANKS       BTSUCC
      *
      ** Set up Account depending on transaction being verified
      *
     C                   MOVEL     *BLANKS       #NOACC            1
      *
      ** Account
      *
     C     BTRACN        IFNE      0
     C                   MOVEL     BTRACN        ##RETL           10
      *
     C                   CALL      'AOACCTR0'
      ** Return code
     C                   PARM      *BLANKS       @RTCD
      ** Option
     C                   PARM      '*KEY'        @OPTN
      ** Acount identifier
     C                   PARM      ##RETL        @RETL
      ** Customer number
     C                   PARM      *BLANKS       @CNNM
      ** Currency code
     C                   PARM      *BLANKS       @CUCD
      ** Account code
     C                   PARM      *BLANKS       @ACCD
      ** Account sequence
     C                   PARM      *BLANKS       @ACSQ
      ** Branch code
     C                   PARM      *BLANKS       @BRCD
      ** Format
     C     D@ACCT        PARM      D@ACCT        DSSDY
      *
     C                   ELSE
      *
     C                   CALL      'AOACCTR0'
      ** Return code
     C                   PARM      *BLANKS       @RTCD             7
      ** Option
     C                   PARM      '*KEY'        @OPTN             7
      ** Acount identifier
     C                   PARM      *BLANKS       @RETL            10
      ** Customer number
     C                   PARM      BTCUST        @CNNM             6
      ** Currency code
     C                   PARM      BTCYCD        @CUCD             3
      ** Account code
     C                   PARM      BTACCD        @ACCD            10
      ** Account sequence
     C                   PARM      BTACSN        @ACSQ             2
      ** Branch code
     C                   PARM      BTIBCA        @BRCD             3
      ** Format
     C     D@ACCT        PARM      D@ACCT        DSSDY
      *
     C                   ENDIF
      *
     C*
     C** DB error if no customer number found for this currency/nostro
     C*
     C     @RTCD         IFEQ      *BLANKS
      *
      ** Check for blocked status
      *
     C                   MOVEL     *BLANKS       ##RETA
      *
     C     ATYP          IFEQ      'R'
      *
      ** If a debit
      *
     C     BTDCIN        IFEQ      'D'
     C                   TESTB     '2'           RETB                     90
     C     *IN90         IFEQ      '1'
     C                   MOVEL     '2'           ##RETA
     C                   ENDIF
     C                   ELSE
      *
      ** If a credit
      *
     C                   TESTB     '3'           RETB                     90
     C     *IN90         IFEQ      '1'
     C                   MOVEL     '3'           ##RETA            1
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Set up return code
     C                   SELECT
      ** when retail but closed
     C     ATYP          WHENEQ    'R'
     C     RECI          ANDNE     'D'
     C                   MOVEL     'ABN0004'     BTRTNC
     C                   MOVEL     'GB'          #MSGF
     C                   MOVE      'GLUSRMSG'    #MSGF
     C                   CALL      'CGC1000'                            9090
     C                   PARM      'ABN0004'     #MSGID
     C                   PARM                    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
     C                   MOVEL     #MSTX1        BTRTNT
     C                   MOVEL     'N'           BTSUCC
      ** Not retail
     C     ATYP          WHENNE    'R'
     C                   MOVEL     'ABN0002'     BTRTNC
     C                   MOVEL     'GB'          #MSGF
     C                   MOVE      'GLUSRMSG'    #MSGF
     C                   CALL      'CGC1000'                            9090
     C                   PARM      'ABN0002'     #MSGID
     C                   PARM                    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
     C                   MOVEL     #MSTX1        BTRTNT
     C                   MOVEL     'N'           BTSUCC
      *
      ** Or account blocked
      *
     C     ATYP          WHENEQ    'R'
     C     ##RETA        ANDNE     *BLANKS
     C                   MOVEL     'ABN0005'     BTRTNC
     C                   MOVEL     'GB'          #MSGF
     C                   MOVE      'GLUSRMSG'    #MSGF
     C                   CALL      'CGC1000'                            9090
     C                   PARM      'ABN0005'     #MSGID
     C                   PARM                    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
     C                   MOVEL     #MSTX1        BTRTNT
     C                   MOVEL     'N'           BTSUCC
     C                   ENDSL
      *
      ** Set currency code if blank
     C     BTCYCD        IFEQ      *BLANKS
     C                   MOVEL     CCY           BTCYCD
     C                   ENDIF
      *
      ** Not found
     C                   ELSE
     C                   MOVEL     'Y'           #NOACC            1
     C                   MOVEL     'ABN0001'     BTRTNC
     C                   MOVEL     'GB'          #MSGF
     C                   MOVE      'GLUSRMSG'    #MSGF
     C                   CALL      'CGC1000'                            9090
     C                   PARM      'ABN0001'     #MSGID
     C                   PARM                    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
     C                   MOVEL     #MSTX1        BTRTNT
     C                   MOVEL     'N'           BTSUCC
     C                   ENDIF
      *
     C     EXCHKA        TAG
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * Subroutine  :  SRSCHK                                         *
      * Function    :  Sufficient Funds Check                         *
      *                                                               *
      * Called by   :                                                 *
      * Calls       :  RE001590 - Account Balance Check               *
      *****************************************************************
     C     SRSCHK        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRSCHK'      @STK(Q)
      *
      ** Set up parameters
      *
     C                   EVAL      PRtAcNum = 0
     C                   EVAL      PCusn = *Blanks
     C                   EVAL      PCurr = *Blanks
     C                   EVAL      PAcod = 0
     C                   EVAL      PAcsq = 0
     C                   EVAL      PBrch = *Blanks
     C                   EVAL      PTrnTyp = *Blanks
     C                   EVAL      PValDat = 0
     C                   EVAL      PAmt = 0
     C                   EVAL      PErr01 = *Blanks
     C                   EVAL      PErr02 = *Blanks
     C                   EVAL      PActBal = 0
     C                   EVAL      PAvlBal = 0
     C                   EVAL      PFailDat = 0
     C                   EVAL      PFailBal = 0
      *
     C                   IF        BTRACN <> 0
     C                   EVAL      PRtAcNum = BTRACN
     C                   EVAL      PCurr = BTCYCD
     C                   ELSE
     C                   EVAL      PCusn = BTCUST
     C                   EVAL      PCurr = BTCYCD
     C                   MOVE      BTACCD        PAcod
     C                   MOVE      BTACSN        PAcsq
     C                   EVAL      PBrch = BTIBCA
     C                   ENDIF
     C                   EVAL      PTrnTyp = 'RETELD'
     C                   EVAL      PValDat = BTVLDT
     C                   IF        BTDCIN = 'D'
     C                   EVAL      PAmt = BTPTAM
     C                   ELSE
     C                   EVAL      PAmt = BTPTAM * (-1)
     C                   ENDIF
      *
      ** Call Account Balance Check RPG program
      *
     C                   CALL      'RE001590'
     C                   PARM                    PRtAcNum
     C                   PARM                    PCusn
     C                   PARM                    PCurr
     C                   PARM                    PAcod
     C                   PARM                    PAcsq
     C                   PARM                    PBrch
     C                   PARM                    PTrnTyp
     C                   PARM                    PValDat
     C                   PARM                    PAmt
     C                   PARM                    PErr01
     C                   PARM                    PErr02
     C                   PARM                    PActBal
     C                   PARM                    PAvlBal
     C                   PARM                    PFailDat
     C                   PARM                    PFailBal
      *
     C                   IF        PErr01 <> *Blanks Or PErr02 <> *Blanks
     C                   EVAL      @RCD = 'N'
     C                   ENDIF
     C                   EVAL      @BLBF = PAvlBal
     C                   EVAL      @BLAF = PAvlBal + PAmt
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * Subroutine  :  SRSHDP                                         *
      * Function    :  Shadow Post                                    *
      *                                                               *
      * Called by   :                                                 *
      * Calls       :  AOSPOSU0 - Shadow Post Processing              *
      *****************************************************************
     C     SRSHDP        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRSHDP'      @STK(Q)
      *
      ** Clear arrays in AOSPOSU0
      *
     C                   CLEAR                   C#DTA
     C     *LIKE         DEFINE    O#RTN         R#RTN
     C                   CALL      'AOSPOSU0'                           9090
     C     R#RTN         PARM      *BLANKS       O#RTN             7
     C                   PARM      '*CLEAR  '    W0ACT             8
     C                   PARM      C#DTA         O#DTA           256
      *
     C     *IN90         IFEQ      '1'
     C     R#RTN         ORNE      *BLANKS
     C                   MOVEL     '*CALL   '    W0FILE
     C                   MOVEL     'AOSPOSU0'    W0KEY
     C                   Z-ADD     03            W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
      ** Set Up Parameters for call to AOSPOSU0
      *
     C                   CLEAR                   C#DTA
      ** account
     C     BTRACN        IFNE      0
     C                   MOVEL     'R'           C#ATYP
     C                   MOVEL     BTRACN        C#ACCT
     C                   ELSE
     C                   MOVEL     'G'           C#ATYP
     C                   MOVEL     BTIBCA        C#BRC1
     C                   MOVEL     BTCUST        C#CNU1
     C                   MOVEL     BTCYCD        C#CCY1
     C                   MOVEL     BTACCD        C#ACO1
     C                   MOVEL     BTACSN        C#ACS1
     C                   ENDIF
      ** dates
     C                   Z-ADD     BTVLDT        C#VDAT
     C                   Z-ADD     BTPTDT        C#PSTD
      ** Other info
     C                   MOVEL     'I'           C#IO
     C                   MOVEL     BTCYCD        C#CCY
     C                   MOVEL     *BLANKS       C#TRYP
     C                   MOVEL     'AT'          C#TRYP
     C                   MOVEL     BTSWCR        C#PREF
     C                   MOVEL     BTNRDC        C#NARR
      ** Amount
     C     BTDCIN        IFEQ      'D'
     C                   Z-ADD     BTPTAM        C#AMT
     C                   ELSE
     C                   Z-SUB     BTPTAM        C#AMT
     C                   ENDIF
      ** Other info extended
     C                   MOVEL     'GL'          C#MOD
     C                   MOVEL     '01'          C#OLRC
     C                   MOVEL     *BLANKS       C#FTOV
     C*****BTVLDT        IFGT      BTPTDT                                       AR1038758 AR1096687A
     C**********         MOVEL     'F'           C#MTYP                         AR1038758 AR1096687A
     C**********         ELSE                                                   AR1038758 AR1096687A
     C                   MOVEL     'S'           C#MTYP                                    AR1038758
     C**********         ENDIF                                                  AR1038758 AR1096687A
      *
      ** Call AOSPOSU0 to add movement
      *
     C                   CALL      'AOSPOSU0'                           9090
     C     R#RTN         PARM      *BLANKS       O#RTN             7
     C                   PARM      '*ADD    '    W0ACT             8
     C                   PARM      C#DTA         O#DTA           256
      *
     C     *IN90         IFEQ      '1'
     C     R#RTN         ORNE      *BLANKS
     C                   MOVEL     '*CALL   '    W0FILE
     C                   MOVEL     'AOSPOSU0'    W0KEY
     C                   Z-ADD     04            W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
      ** Call AOSPOSU0 to update database
      *
     C                   CLEAR                   C#DTA
      *
     C                   CALL      'AOSPOSU0'                           9090
     C     R#RTN         PARM      *BLANKS       O#RTN             7
     C                   PARM      '*UPDATE '    W0ACT             8
     C                   PARM      C#DTA         O#DTA           256
      *
     C     *IN90         IFEQ      '1'
     C     R#RTN         ORNE      *BLANKS
     C                   MOVEL     '*CALL   '    W0FILE
     C                   MOVEL     'AOSPOSU0'    W0KEY
     C                   Z-ADD     05            W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
      ** Commit Changes
      *
     C                   COMMIT
      *
     C     EXSHDP        TAG
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * Subroutine  :  SRRTND                                         *
      * Function    :  Return data                                    *
      *                                                               *
      * Called by   :                                                 *
      * Calls       :  Nothing                                        *
      *****************************************************************
     C     SRRTND        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRRTND'      @STK(Q)
      *
      ** Set unique identifier
     C                   MOVEL     BTUNID        BOUNID
      *
      ** Set success indicator to 'N' if still blank
      *
     C     BTSUCC        IFEQ      *BLANKS
     C                   MOVEL     'N'           BTSUCC
     C     PERR01        IFNE      *BLANKS                                                 AR1069768
     C**********         MOVEL     'ABN0003'     BTRTNC                                    AR1069768
     C                   MOVEL     PERR01        BTRTNC                                    AR1069768
     C                   ELSE                                                              AR1069768
     C     PERR02        IFNE      *BLANKS                                                 AR1069768
     C                   MOVEL     PERR02        BTRTNC                                    AR1069768
     C                   ENDIF                                                             AR1069768
     C                   ENDIF                                                             AR1069768
      *                                                                                    AR1069768
     C     BTRTNT        IFEQ      *BLANK
     C                   SELECT
     C     BTRTNC        WHENEQ    'ABC0001'
     C                   EVAL      BTRTNT = ##ERR(1)
     C     BTRTNC        WHENEQ    'ABC0002'
     C                   EVAL      BTRTNT = ##ERR(2)
     C     BTRTNC        WHENEQ    'ABC0003'
     C                   EVAL      BTRTNT = ##ERR(3)
     C     BTRTNC        WHENEQ    'ABC0004'
     C                   EVAL      BTRTNT = ##ERR(4)
     C                   ENDSL
     C                   ENDIF
      *
     C                   ENDIF
      ** Set up balances - available for retail only
      ** and only if successful
     C     BTSUCC        IFEQ      'Y'
     C     ATYP          IFEQ      'R'
     C                   MOVEL     'D'           BTBFDC
     C                   Z-ADD     @BLBF         BTBLBF
     C     @BLBF         IFLT      0
     C                   MOVEL     'C'           BTBFDC
     C                   Z-SUB     @BLBF         BTBLBF
     C                   ENDIF
     C                   MOVEL     'D'           BTAFDC
     C                   Z-ADD     @BLAF         BTBLAF
     C     @BLAF         IFLT      0
     C                   MOVEL     'C'           BTAFDC
     C                   Z-SUB     @BLAF         BTBLAF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Move data for output
      *
     C                   MOVEL     SHDOUT        OTDATA
      *
     C                   WRITE     SHDOUTT0
      *
     C     EXRTND        TAG
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * Subroutine  :  SRINIT                                         *
      * Function    :  Initial processing - First Call Only           *
      *                                                               *
      * Called by   :  Mainline                                       *
      * Calls       :  AOBANKR0 - Obtain Bank details                 *
      *                AOGELRR0 - Obtain General Ledger Details       *
      *****************************************************************
     C     SRINIT        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRINIT'      @STK(Q)
      *
      ** Call access program for Bank details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       ##RTCD            7
     C                   PARM      '*FIRST  '    ##OPTN            7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error
     C     ##RTCD        IFNE      *BLANK
      *
     C                   MOVEL     'AOBANKR0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY
     C                   Z-ADD     01            W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
      ** Copyright
     C                   MOVEA     ##CPY         ##ACT            80
      *
     C     EXINIT        TAG
      *
      ** Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
     C/COPY CGCPYSRC,SRERRPSSRL
     C/SPACE 5
     C/COPY CGCPYSRC,SRERRCLE
**CTDATA ##CPY
(c) Copyright Finastra International Limited 2017
**CTDATA ##ERR
ABC fails because of minimum balance requirement
ABC fails but is within overdraft tolerance
ABC fails and is in excess of the overdraft tolerance
Movement date is forward, account balance check not performed
