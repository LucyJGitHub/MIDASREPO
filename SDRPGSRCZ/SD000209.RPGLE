     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Display Withholding Tax Rate Dft Matrix')     *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000209 - Display Withholding Tax Rate Dft Matrix           *
      *                                                               *
      *  (c) Finastra International Limited 2015                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL165  *CREATE    Date 23Feb15               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL165 - Dual Withholding Tax                                *
      *                                                               *
      *****************************************************************
     FSD000209DFCF   E             WORKSTN
     F                                     INFDS(INFDS#)
      * DSP: Midas SD Display Withholding Tax Rate Default Matrix
      *
     FSDMMODL1  IF   E           K DISK
      * RTV: MIDAS Modules             Retrieval index
      *
     D**
     D SHR1            S             22    DIM(9)
     D** Withholding Tax Rate Dft Matrix Array to hold ordered Base Field
     D** LHS Texts according to their associated field priorities.
     D**
     D SHR2            S             22    DIM(9)  CTDATA PERRCD(1)
     D** Withholding Tax Rate Default Matrix Array to hold LHS Text Text for all
     D** base fields.
     D**
     D/EJECT
     D**
     D IAR1            S             14    DIM(9)
     D** Withholding Tax Rate Default Matrix Array to hold ordered Base Fields
     D** according to their priorities.
     D**
     D/EJECT
     D PMTV            S             78    DIM(3) CTDATA PERRCD(1)
     D*
     D*  DETAIL LINE COMMAND KEY TEXT
     D*
     D* Description     : Copyright notice for inclusion in all programs
     D*
     D********************************************************************
     D @CN             S             25    DIM(12) CTDATA PERRCD(1)             Long constants.
     D*
     D* Description     : Copyright notice for inclusion in all programs
     D*
     D DATA            DS          1024
     D  #1BRCH                 1      3
     D  #1BOOK                 4      5
     D  #1CURY                 6      8
     D  #1CTRY                 9     10
     D  #1CUTY                11     11
     D  #1INST                12     13
     D  #1MODU                14     15
     D  #1TRTY                16     25
     D  #1TRST                26     27
      /EJECT
      * Data structures:-
     D PGMDS         ESDS                  EXTNAME(Y2PGDSP)
      * Program data structure.
     D JBDTTM          DS
      * Job date/time.
     D  ##JDT                  1      6  0
     D  ##JYY                  1      2  0
     D  ##JMM                  3      4  0
     D  ##JDD                  5      6  0
     D  ##JTM                  7     12  0
     D  ##JHH                  7      8  0
     D  ##JNN                  9     10  0
     D  ##JSS                 11     12  0
     D DfltPr          DS
      * Default Priorities
     D  DMBR                   1      1  0
     D  DMBO                   2      2  0
     D  DMCU                   3      3  0
     D  DMCD                   4      4  0
     D  DMCT                   5      5  0
     D  DMIN                   6      6  0
     D  DMMO                   7      7  0
     D  DMTY                   8      8  0
     D  DMTS                   9      9  0
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
      * Display file data structure.
      *
     D A@CPY           DS
     D* Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)              Copyright array
     D RUNDAT          DS
     D  MRDT                   1      7                                         S01229
     D  RDNB                   8     10P 0                                      S01229
     D  SUC                   11     11                                         S01229
     D  DFF                   12     12                                         S01229
     D  MBIN                  13     13                                         S01229
      /EJECT
      * Parameter declarations.
     D P1PARM          DS            31
      * RCD: Withholding Tax Rate Default Matrix Retrieval index
      * I:MAP Branch code
     D  P1BRCH                 1      3
      * I:MAP Book Code
     D  P1BOOK                 4      5
      * I:MAP Currency
     D  P1CURY                 6      8
      * I:MAP Country of Domicile
     D  P1CTRY                 9     10
      * I:MAP Customer Type
     D  P1CUTY                11     11
      * I:MAP Institution Code
     D  P1INST                12     13
      * I:MAP Module
     D  P1MODU                14     15
      * I:MAP Transaction Type
     D  P1TRTY                16     25
      * I:MAP Transaction Subtype
     D  P1TRST                26     27
      * I:MAP Default Tax Rate Code
     D  P1TXR1                28     29
      * I:MAP Default Tax Rate Code
     D  P1TXR2                30     31
      *
     D P2PARM          DS
      * I:    Action Code
     D  P2ANCD                 1      1
      *
      /EJECT
      *****************************************************************
     C     *ENTRY        PLIST                                                  Entry parameter
     C                   PARM                    P0RTN             7            Return code
     C                   PARM                    P1PARM                         RCD: WH Tax Rate
     C     P2ANCD        PARM                    WP0001            1            Action Code
      *****************************************************************
      * Initialise
     C                   EXSR      ZZINIT
      *
      * Conduct screen conversation.
     C                   DO        *HIVAL
      * Start new transaction.
     C                   MOVEL     'Y'           W0TRN             1
      * Process current transaction.
     C     W0TRN         DOWEQ     'Y'
      * Display screen.
     C                   EXSR      CAEXFM
      * Process response:
      * Cancel & exit program.
     C   03              CAS                     ZXEXPG
      * Process screen input.
     C                   CAS                     DAPRSC
     C                   END
      *
     C                   END
      *
     C                   END
      *****************************************************************
      /EJECT
     CSR   CAEXFM        BEGSR
      *================================================================
      * Display screen and process HELP requests.
      *================================================================
      * Update screen time.
     C                   TIME                    ##TME                          Screen time.
     C     W0HLP         DOUEQ     'N'
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT1
     C                   EXFMT     #RCDDTL1
     C                   MOVEL     'N'           W0HLP             1            Reset help requ
      * If help requested, display help text.
     C   25              EXSR      ZHHPKY                                       Display help te
     C                   END
      * Update job time.
     C                   TIME                    ##JTM                          Job time.
      * Clear messages from program message queue.
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGM            10
     C                   PARM      '*SAME'       ZAPGRL            5
      * Reset first message only flag.
     C                   MOVEL     'Y'           ZAFSMS            1      99    *
      *================================================================
     CSR   CAEXIT        ENDSR
      /EJECT
     CSR   DAPRSC        BEGSR
      *================================================================
      * Process screen input.
      *================================================================
      * Confirm/update is not defered.
     C                   MOVEL     'N'           W0DCF             1
      * USER: Process command keys
      *CASE:     DTL.*CMD key is CF12
     C     *IN12         IFEQ      '1'                                          *IF
     C                   MOVEL     @CN(02)       P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   END                                                    *FI
      * Validate screen.
     C                   EXSR      DBVLSC
      * If error, exit:
     C     *IN99         CABEQ     '1'           DAEXIT
      * Defer confirm/update requested:
     C     W0DCF         CABEQ     'Y'           DAEXIT
      * USER: User defined action
     C                   MOVEL     @CN(02)       P0RTN                          *Return code
     C                   EXSR      ZYEXPG
      * Request new transaction.
     C                   MOVEL     'N'           W0TRN
      *================================================================
     CSR   DAEXIT        ENDSR
      /EJECT
     CSR   DBVLSC        BEGSR
      *================================================================
      * Validate screen.
      *================================================================
      * USER: Validate fields
      * Bypass ref file checks if error already detected.
     C   99              GOTO      DBEXIT
      * CALC: Screen function fields
      * USER: Validate relations
      *CASE:     WRK.Window processing requir. is Yes
     C     WUWDPR        IFEQ      @CN(01)                                      *IF
      * WM call Window Manager - Window manager  *
     C                   CALL      'WN0010'                                                    S0121
     C                   PARM      ##PGM         UPGM             10            Program        S0121
     C                   PARM      *BLANK        UFKEY             2            Function Key   S0121
     C                   PARM      @CN(03)       UACTCD            1            Action  S01212 S0122
     C                   PARM                    DATA                           Trans Data     S0121
     C                   PARM      *BLANK        W0RTN                          Return Code    S0121
     C                   PARM                    SPARE           256            Spare Field    LN035
      * WM Check Return
      *CASE:     PAR.*Return code is *User QUIT requested
     C     W0RTN         IFEQ      @CN(04)                                      *IF
     C                   MOVEL     W0RTN         P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   ELSE
      *CASE:     PAR.*Return code is WN Window Error
     C     W0RTN         IFEQ      @CN(05)                                      *IF
      * Send message 'WN Window Error'
     C                   MOVEL     'USR0563'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   SETON                                        99        *
      *
     C                   MOVEL     @CN(01)       W0DCF                          *Defer confirm
     C                   GOTO      DBEXIT                                       *QUIT
     C                   ELSE
      *CASE:     PAR.*Return code is *DBF update error
     C     W0RTN         IFEQ      @CN(06)                                      *IF
      * Send message 'WN Database Error'
     C                   MOVEL     'USR0567'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   SETON                                        99        *
      *
     C                   MOVEL     @CN(01)       W0DCF                          *Defer confirm
     C                   GOTO      DBEXIT                                       *QUIT
     C                   ELSE
      *CASE:     PAR.*Return code is *Previous Screen
     C     W0RTN         IFEQ      @CN(02)                                      *IF
     C                   MOVEL     @CN(01)       W0DCF                          *Defer confirm
     C                   GOTO      DBEXIT                                       *QUIT
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C*
     C                   END                                                    *FI
      *================================================================
     CSR   DBEXIT        ENDSR
      /EJECT
     CSR   MALDSC        BEGSR
      *================================================================
      * Load screen from passed parameters
      *================================================================
     C                   MOVEL     P1BRCH        #1BRCH                         Branch Code
     C                   MOVEL     P1BOOK        #1BOOK                         Book Code
     C                   MOVEL     P1CURY        #1CURY                         Currency
     C                   MOVEL     P1CTRY        #1CTRY                         Country of Domicile
     C                   MOVEL     P1CUTY        #1CUTY                         Customer Type
     C                   MOVEL     P1INST        #1INST                         Institution Code
     C                   MOVEL     P1MODU        #1MODU                         Module
     C                   MOVEL     P1TRTY        #1TRTY                         Transaction Type
     C                   MOVEL     P1TRST        #1TRST                         Transaction Subtype
     C                   Z-ADD     *ZERO         #1LCD                          Last Change Dat
     C                   MOVEL     *BLANK        #1TYPC                         Type of Last Ch
     C                   MOVEL     *BLANK        #DWPT1                         Pty Def WH Ma
     C                   MOVEL     *BLANK        #DWPM1                         Priority Def WH
     C                   MOVEL     *BLANK        #DWPT2                         Pty Def WH Ma
     C                   MOVEL     *BLANK        #DWPM2                         Priority Def WH
     C                   MOVEL     *BLANK        #DWPT3                         Pty Def WH Ma
     C                   MOVEL     *BLANK        #DWPM3                         Priority Def WH
     C                   MOVEL     *BLANK        #DWPT4                         Pty Def WH Ma
     C                   MOVEL     *BLANK        #DWPM4                         Priority Def WH
     C                   MOVEL     *BLANK        #DWPT5                         Pty Def WH Ma
     C                   MOVEL     *BLANK        #DWPM5                         Priority Def WH
     C                   MOVEL     *BLANK        #DWPT6                         Pty Def WH Ma
     C                   MOVEL     *BLANK        #DWPM6                         Priority Def WH
     C                   MOVEL     *BLANK        #DWPT7                         Pty Def WH Ma
     C                   MOVEL     *BLANK        #DWPM7                         Priority Def WH
     C                   MOVEL     *BLANK        #DWPT8                         Pty Def WH Ma
     C                   MOVEL     *BLANK        #DWPM8                         Priority Def WH
     C                   MOVEL     *BLANK        #DWPT9                         Pty Def WH Ma
     C                   MOVEL     *BLANK        #DWPM9                         Priority Def WH
     C                   MOVEL     P1TXR1        #1TXR1                         Default Tax Rate Cod
     C                   MOVEL     P1TXR2        #1TXR2                         Default Tax Rate Cod
      *
      * CALC: Screen function fields
      * USER: Load screen
      * Load DTL Screen Headers - Withholding Tax Rate Default Matrix *
     C**
     C** Move each DB field LHS Text into the associated section of the
     C** array in order to move the correct LHS Text into the screen
     C** LHS Text output fields.
     C**
     C** To place the text into the correct portion of the array make
     C** use of the priorities specified for each base field off the
     C** General Ledger File, the fields of which are passed into this
     C** user source.
     C**
     C** Set-up Branch Code LHS Text
     C**
     C**  IF Multibranching Switched On then Branch Code Will be          LN0592
     C**  displayed if the priority on WHTDftMtrxPriorities is GT 0       LN0592
     C     WUMBIN        IFEQ      'Y'                                                         LN059
     C**                                                                  LN0592
     C     WUWMBH        IFNE      0                                               IF 1
     C                   Z-ADD     WUWMBH        H                 2 0
     C** Move LHS Text into array element according to the
     C** fields priority on General Ledger Details.
     C**                   ¦
     C                   MOVE      SHR2(1)       SHR1(H)
     C                   END                                                      IF 1
     C**                                                                  LN0592
     C                   END                                                                   LN059
     C** Set-up Book Code LHS Text
     C**
     C     WUWMBK        IFNE      0                                               IF 1
     C                   Z-ADD     WUWMBK        B                 2 0
     C** Move LHS Text into array element according to the
     C** fields priority on General Ledger Details.
     C**                   ¦
     C                   MOVE      SHR2(2)       SHR1(B)
     C                   END                                                      IF 1
     C** Set-up Currency LHS Text
     C**
     C     WUWMCY        IFNE      0                                               IF 1
     C                   Z-ADD     WUWMCY        C                 2 0
     C** Move LHS Text into array element according to the
     C** fields priority on General Ledger Details.
     C**                   ¦
     C                   MOVE      SHR2(3)       SHR1(C)
     C                   END                                                      IF 1
     C** Set-up Country of Domicile LHS Text
     C**
     C     WUWMCR        IFNE      0                                               IF 1
     C                   Z-ADD     WUWMCR        D                 2 0
     C** Move LHS Texts 1 & 2 into array element according to the
     C** fields priority on General Ledger Details.
     C**                   ¦
     C                   MOVE      SHR2(4)       SHR1(D)
     C                   END                                                      IF 1
     C** Set-up Customer Type LHS Text
     C**
     C     WUWMCT        IFNE      0                                               IF 1
     C                   Z-ADD     WUWMCT        U                 2 0
     C** Move LHS Text into array element according to the
     C** fields priority on General Ledger Details.
     C**                   ¦
     C                   MOVE      SHR2(5)       SHR1(U)
     C                   END                                                      IF 1
     C** Set-up Institution Code LHS Text
     C**
     C     WUWMIS        IFNE      0                                               IF 1
     C                   Z-ADD     WUWMIS        I                 2 0
     C** Move LHS Texts 1 & 2 into array element according to the
     C** fields priority on General Ledger Details.
     C**                   ¦
     C                   MOVE      SHR2(6)       SHR1(I)
     C                   END                                                      IF 1
     C** Set-up Module LHS Text
     C**
     C     WUWMMO        IFNE      0                                               IF 1
     C                   Z-ADD     WUWMMO        M                 2 0
     C** Move LHS Text into array element according to the
     C** fields priority on General Ledger Details.
     C**                   ¦
     C                   MOVE      SHR2(7)       SHR1(M)
     C                   END                                                      IF 1
     C** Set-up Transaction Type LHS Text
     C**
     C     WUWMTT        IFNE      0                                               IF 1
     C                   Z-ADD     WUWMTT        T                 2 0
     C** Move LHS Texts 1 & 2 into array element according to the
     C** fields priority on General Ledger Details.
     C**                   ¦
     C                   MOVE      SHR2(8)       SHR1(T)
     C                   END                                                      IF 1
     C** Set-up Transaction Subtype LHS Text
     C**
     C     WUWMTS        IFNE      0                                               IF 1
     C                   Z-ADD     WUWMTS        S                 2 0
     C** Move LHS Texts 1 & 2 into array element according to the
     C** fields priority on General Ledger Details.
     C**                   ¦
     C                   MOVE      SHR2(9)       SHR1(S)
     C                   END                                                      IF 1
      *
     C** Load Screen Function Fields With LHS Text
     C**
     C                   MOVEA     SHR1(1)       #DWPT1
     C                   MOVEA     SHR1(2)       #DWPT2
     C                   MOVEA     SHR1(3)       #DWPT3
     C                   MOVEA     SHR1(4)       #DWPT4
     C                   MOVEA     SHR1(5)       #DWPT5
     C                   MOVEA     SHR1(6)       #DWPT6
     C                   MOVEA     SHR1(7)       #DWPT7
     C                   MOVEA     SHR1(8)       #DWPT8
     C                   MOVEA     SHR1(9)       #DWPT9
     C**
      * Blank out Asterisks in Key Fields
     C                   EXSR      UASUBR                                       Blank out Aster
      * Set Screen Fun Fields to Input Parms - File Fields.
     C                   EXSR      UKSUBR                                       Set Screen Fun
      * Load DTL Screen Fields - Withholding Tax Rate Default Matrix *
     C**
     C** Move each database field into the associated section of the
     C** array in order to display all the details into the screen
     C** output fields.
     C**
     C** To place the field into the correct portion of the array make
     C** use of the priorities specified for each field off the
     C** General Ledger File, the fields of which are passed into this
     C** user source.
     C**
     C** Set-up Branch Code
     C**
     C**  IF Multibranching Switched On then Branch Code Will be          LN0592
     C**  displayed if the priority on WHTDftMtrxPriorities is GT 0       LN0592
     C     WUMBIN        IFEQ      'Y'                                                         LN059
     C**                                                                  LN0592
     C     WUWMBH        IFNE      0                                               IF 1
     C                   Z-ADD     WUWMBH        H
     C** Initialise Branch Code Storage Fields
     C**                   ¦
     C                   MOVE      *BLANKS       UUBFLD
     C                   MOVEL     WUBHSN        UUBFLD
     C** Move Long Store Bch Code  to array element according to the
     C** fields priority on General Ledger Details.
     C**                   ¦
     C                   MOVEA     UUBFLD        IAR1(H)
     C                   END                                                      IF 1
     C**                                                                  LN0592
     C                   END                                                                   LN059
     C** Set-up Book Code
     C**
     C     WUWMBK        IFNE      0                                               IF 1
     C                   Z-ADD     WUWMBK        B
     C** Initialise Base Storage Field
     C**                   ¦
     C                   MOVE      *BLANKS       UUBFLD           10
     C                   MOVEL     WUBKSN        UUBFLD
     C** Move Store Book Code to array element according to the
     C** fields priority on General Ledger Details.
     C**                   ¦
     C                   MOVEA     UUBFLD        IAR1(B)
     C                   END                                                      IF 1
     C** Set-up Currency
     C**
     C     WUWMCY        IFNE      0                                               IF 1
     C                   Z-ADD     WUWMCY        C
     C** Initialise Base Storage Field
     C**                   ¦
     C                   MOVE      *BLANKS       UUBFLD
     C                   MOVEL     WUCYSN        UUBFLD
     C** Move Long Store Currency to array element according to the
     C** fields priority on General Ledger Details.
     C**                   ¦
     C                   MOVEA     UUBFLD        IAR1(C)
     C                   END                                                      IF 1
     C** Set-up Country of Domicile
     C**
     C     WUWMCR        IFNE      0                                               IF 1
     C                   Z-ADD     WUWMCR        D
     C** Initialise Base Storage Field
     C**                   ¦
     C                   MOVE      *BLANKS       UUBFLD
     C                   MOVEL     WUCRSN        UUBFLD
     C** Move Long Store Ctry od Domicile to array element according to the
     C** fields priority on General Ledger Details.
     C**                   ¦
     C                   MOVEA     UUBFLD        IAR1(D)
     C                   END                                                      IF 1
     C** Set-up Customer Type
     C**
     C     WUWMCT        IFNE      0                                               IF 1
     C                   Z-ADD     WUWMCT        U
     C** Initialise Base Storage Field
     C**                   ¦
     C                   MOVE      *BLANKS       UUBFLD
     C                   MOVEL     WUCTSN        UUBFLD
     C** Move Long Store Cust Type to array element according to the
     C** fields priority on General Ledger Details.
     C**                   ¦
     C                   MOVEA     UUBFLD        IAR1(U)
     C                   END                                                      IF 1
     C** Set-up Institution Code
     C**
     C     WUWMIS        IFNE      0                                               IF 1
     C                   MOVE      WUWMIS        I
     C** Initialise User Id Storage Fields
     C**                   ¦
     C                   MOVE      *BLANKS       UUBFLD
     C                   MOVEL     WUISSN        UUBFLD
     C** Move Long Store Institution Code to array element according to the
     C** fields priority on General Ledger Details.
     C**                   ¦
     C                   MOVEA     UUBFLD        IAR1(I)
     C                   END                                                      IF 1
     C** Set-up Module
     C**
     C     WUWMMO        IFNE      0                                               IF 1
     C                   Z-ADD     WUWMMO        M
     C** Initialise Base Storage Fields
     C**                   ¦
     C                   MOVE      *BLANKS       UUBFLD
     C                   MOVEL     WUMOSN        UUBFLD
     C** Move Long Store Module to array element according to the
     C** fields priority on General Ledger Details.
     C**                   ¦
     C                   MOVEA     UUBFLD        IAR1(M)
     C                   END                                                      IF 1
     C** Set-up Transaction Type
     C**
     C     WUWMTT        IFNE      0                                               IF 1
     C                   Z-ADD     WUWMTT        T
     C** Initialise Base Storage Field
     C**                   ¦
     C                   MOVE      *BLANKS       UUBFLD
     C                   MOVEL     WUTTSN        UUBFLD
     C** Move Long Store Transaction type to array element according to the
     C** fields priority on General Ledger Details.
     C**                   ¦
     C                   MOVEA     UUBFLD        IAR1(T)
     C                   END                                                      IF 1
     C** Set-up Transaction Subtype
     C**
     C     WUWMTS        IFNE      0                                               IF 1
     C                   Z-ADD     WUWMTS        S
     C** Initialise Base Storage Field
     C**                   ¦
     C                   MOVE      *BLANKS       UUBFLD
     C                   MOVEL     WUTSSN        UUBFLD
     C** Move Long Store Trans Subtype to array element according to the
     C** fields priority on General Ledger Details.
     C**                   ¦
     C                   MOVEA     UUBFLD        IAR1(S)
     C                   END                                                      IF 1
      *
     C/EJECT
     C** Move Final Array Contents to Output Screen Field
     C**
     C                   MOVEA     IAR1(1)       #DWPM1
     C                   MOVEA     IAR1(2)       #DWPM2
     C                   MOVEA     IAR1(3)       #DWPM3
     C                   MOVEA     IAR1(4)       #DWPM4
     C                   MOVEA     IAR1(5)       #DWPM5
     C                   MOVEA     IAR1(6)       #DWPM6
     C                   MOVEA     IAR1(7)       #DWPM7
     C                   MOVEA     IAR1(8)       #DWPM8
     C                   MOVEA     IAR1(9)       #DWPM9
     C**
      * Set-up Screen Ftr PMTVAL - Standard Functions  *
     C*
     C*  If Action Code is Delete :
     C*
     C     @CN(08)       IFEQ      'D'                                                         S0122
     C                   MOVEA     PMTV(1)       ##CTX1                                        S0122
     C                   END
     C*
     C*  If Action Code is Insert :
     C*
     C     @CN(08)       IFEQ      'I'                                                         S0122
     C                   MOVEA     PMTV(2)       ##CTX1                                        S0122
     C                   END
     C*
     C*  If Action Code is Amend :
     C*
     C     @CN(08)       IFEQ      'A'                                                         S0122
     C                   MOVEA     PMTV(3)       ##CTX1                                        S0122
     C                   END
     C*
      *================================================================
     CSR   MAEXIT        ENDSR
      /EJECT
     CSR   SARVGN        BEGSR
      *================================================================
      * Obtain Withholding Tax Rate Def Pty - System Value WHTDftMtrxPriorities
      *================================================================
     C                   Eval      P@Op01 = 'WHTDftMtrxPriorities'
     C                   Call      'AOSVALR0'
     C                   Parm      *Blanks       P@Rtcd            7
     C                   Parm                    P@Op01           20
     C                   Parm      *Blanks       P@Vl01          200
     C                   Parm      *Blanks       P@Op02           20
     C                   Parm      *Blanks       P@Vl02          200
     C                   Parm      *Blanks       P@Op03           20
     C                   Parm      *Blanks       P@Vl03          200
     C                   Parm      *Blanks       P@Op04           20
     C                   Parm      *Blanks       P@Vl04          200
     C                   Parm      *Blanks       P@Op05           20
     C                   Parm      *Blanks       P@Vl05          200
     C                   Parm      *Blanks       P@Op06           20
     C                   Parm      *Blanks       P@Vl06          200
     C                   Parm      *Blanks       P@Op07           20
     C                   Parm      *Blanks       P@Vl07          200
     C                   Parm      *Blanks       P@Op08           20
     C                   Parm      *Blanks       P@Vl08          200
     C                   Parm      *Blanks       P@Op09           20
     C                   Parm      *Blanks       P@Vl09          200
     C                   Parm      *Blanks       P@Op10           20
     C                   Parm      *Blanks       P@Vl10          200
 
      **  If the Return Code is blank, set Default Priorities
     C                   If        P@Rtcd = *Blanks
     C                   Eval      DfltPr = P@Vl01
      * PAR = DB1 By name
     C                   Z-ADD     DMBR          WUWMBH                         WH Tax Rate Def Matr
     C                   Z-ADD     DMBO          WUWMBK                         WH Tax Rate Def Matr
     C                   Z-ADD     DMCU          WUWMCY                         WH Tax Rate Def Matr
     C                   Z-ADD     DMCD          WUWMCR                         WH Tax Rate Def Matr
     C                   Z-ADD     DMCT          WUWMCT                         WH Tax Rate Def Matr
     C                   Z-ADD     DMIN          WUWMIS                         WH Tax Rate Def Matr
     C                   Z-ADD     DMMO          WUWMMO                         WH Tax Rate Def Matr
     C                   Z-ADD     DMTY          WUWMTT                         WH Tax Rate Def Matr
     C                   Z-ADD     DMTS          WUWMTS                         WH Tax Rate Def Matr
      *
     C                   MOVEL     @CN(11)       W0RTN                          *Return code
     C                   Else
      * DBF Record not found.
     C                   MOVEL     'USR0199'     W0RTN             7
      * USER: Processing if DBF record not found
     C                   MOVEL     @CN(10)       W0RTN                          *Return code
     C                   GOTO      SAEXIT
     C                   END
      *
      *================================================================
     CSR   SAEXIT        ENDSR
      /EJECT
     CSR   SBRVGN        BEGSR
      *================================================================
      * Get 'Window required' ind - MIDAS Modules  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define Keylist.
     C     KRSSB         KLIST
     C                   KFLD                    BGMODS                         Modules
      * Move fields to key list.
     C                   MOVEL     @CN(12)       BGMODS                         Modules
     C     KRSSB         CHAIN     @BGREC8                            90        *
      * DBF Record not found.
     C   90              MOVEL     'USR0096'     W0RTN             7
     C     *IN90         IFEQ      '0'
      * USER: Process DBF record
      *CASE:     DB1.Window processing requir. is Yes
     C     BGWDPR        IFEQ      @CN(01)                                      *IF
     C                   MOVEL     @CN(01)       WUWDPR                         Window processi
     C                   END                                                    *FI
     C                   END
      *================================================================
     CSR   SBEXIT        ENDSR
      /EJECT
     CSR   UASUBR        BEGSR
      *================================================================
      * Blank out Asterisks in Key Fields
      *================================================================
      * Branch
     C                   EXSR      UBSUBR                                       Branch Code
      * Book Code
     C                   EXSR      UCSUBR                                       Book Code
      * Currency
     C                   EXSR      UDSUBR                                       Currency
      * Country of Domicile
     C                   EXSR      UESUBR                                       Country of Domicile
      * Customer Type
     C                   EXSR      UFSUBR                                       Customer Type
      * Institution Code
     C                   EXSR      UGSUBR                                       Institution Code
      * Module
     C                   EXSR      UHSUBR                                       Module
      * Transaction Type
     C                   EXSR      UISUBR                                       Transaction Type
      * Transaction Subtype
     C                   EXSR      UJSUBR                                       Transaction Subtype
      *================================================================
     CSR   UAEXIT        ENDSR
      /EJECT
     CSR   UBSUBR        BEGSR
      *================================================================
      * Branch Code
      *================================================================
     C                   MOVEL     #1BRCH        WUCAKY                         Check For Aster
      *CASE:     WRK.Check For Asterisk in Key is Asterisk
     C     WUCAKY        IFEQ      @CN(07)                                      *IF
     C                   MOVEL     *BLANK        #1BRCH                         Branch Code
     C                   END                                                    *FI
      *================================================================
     CSR   UBEXIT        ENDSR
      /EJECT
     CSR   UCSUBR        BEGSR
      *================================================================
      * Book Code
      *================================================================
     C                   MOVEL     #1BOOK        WUCAKY                         Check For Aster
      *CASE:     WRK.Check For Asterisk in Key is Asterisk
     C     WUCAKY        IFEQ      @CN(07)                                      *IF
     C                   MOVEL     *BLANK        #1BOOK                         Book Code
     C                   END                                                    *FI
      *================================================================
     CSR   UCEXIT        ENDSR
      /EJECT
     CSR   UDSUBR        BEGSR
      *================================================================
      * Currency
      *================================================================
     C                   MOVEL     #1CURY        WUCAKY                         Check For Aster
      *CASE:     WRK.Check For Asterisk in Key is Asterisk
     C     WUCAKY        IFEQ      @CN(07)                                      *IF
     C                   MOVEL     *BLANK        #1CURY                         Currency
     C                   END                                                    *FI
      *================================================================
     CSR   UDEXIT        ENDSR
      /EJECT
     CSR   UESUBR        BEGSR
      *================================================================
      * Country of Domicile
      *================================================================
     C                   MOVEL     #1CTRY        WUCAKY                         Check For Aster
      *CASE:     WRK.Check For Asterisk in Key is Asterisk
     C     WUCAKY        IFEQ      @CN(07)                                      *IF
     C                   MOVEL     *BLANK        #1CTRY                         Country of Domicile
     C                   END                                                    *FI
      *================================================================
     CSR   UEEXIT        ENDSR
      /EJECT
     CSR   UFSUBR        BEGSR
      *================================================================
      * Customer Type
      *================================================================
     C                   MOVEL     #1CUTY        WUCAKY                         Check For Aster
      *CASE:     WRK.Check For Asterisk in Key is Asterisk
     C     WUCAKY        IFEQ      @CN(07)                                      *IF
     C                   MOVEL     *BLANK        #1CUTY                         Customer Type
     C                   END                                                    *FI
      *================================================================
     CSR   UFEXIT        ENDSR
      /EJECT
     CSR   UGSUBR        BEGSR
      *================================================================
      * Institution Code
      *================================================================
     C                   MOVEL     #1INST        WUCAKY                         Check For Aster
      *CASE:     WRK.Check For Asterisk in Key is Asterisk
     C     WUCAKY        IFEQ      @CN(07)                                      *IF
     C                   MOVEL     *BLANK        #1INST                         Institution Code
     C                   END                                                    *FI
      *================================================================
     CSR   UGEXIT        ENDSR
      /EJECT
     CSR   UHSUBR        BEGSR
      *================================================================
      * Module
      *================================================================
     C                   MOVEL     #1MODU        WUCAKY                         Check For Aster
      *CASE:     WRK.Check For Asterisk in Key is Asterisk
     C     WUCAKY        IFEQ      @CN(07)                                      *IF
     C                   MOVEL     *BLANK        #1MODU                         Module
     C                   END                                                    *FI
      *================================================================
     CSR   UHEXIT        ENDSR
      /EJECT
     CSR   UISUBR        BEGSR
      *================================================================
      * Transaction Type
      *================================================================
     C                   MOVEL     #1TRTY        WUCAKY                         Check For Aster
      *CASE:     WRK.Check For Asterisk in Key is Asterisk
     C     WUCAKY        IFEQ      @CN(07)                                      *IF
     C                   MOVEL     *BLANK        #1TRTY                         Transaction Type
     C                   END                                                    *FI
      *================================================================
     CSR   UIEXIT        ENDSR
      /EJECT
     CSR   UJSUBR        BEGSR
      *================================================================
      * Transaction Subtype
      *================================================================
     C                   MOVEL     #1TRST        WUCAKY                         Check For Aster
      *CASE:     WRK.Check For Asterisk in Key is Asterisk
     C     WUCAKY        IFEQ      @CN(07)                                      *IF
     C                   MOVEL     *BLANK        #1TRST                         Transaction Subtype
     C                   END                                                    *FI
      *================================================================
     CSR   UJEXIT        ENDSR
      /EJECT
     CSR   UKSUBR        BEGSR
      *================================================================
      * Set Screen Fun Fields to Input Parms - File Fields.
      *================================================================
     C                   MOVEL     *BLANK        WUBHSN                         Branch    Scree
     C                   MOVEL     #1BRCH        WUBHSN                         Branch    Scree
     C                   MOVEL     *BLANK        WUBKSN                         Book Code Scree
     C                   MOVEL     #1BOOK        WUBKSN                         Book Code Scree
     C                   MOVEL     *BLANK        WUCYSN                         Currency  Scree
     C                   MOVEL     #1CURY        WUCYSN                         Currency  Scree
     C                   MOVEL     *BLANK        WUCRSN                         Ctry Dom  Scree
     C                   MOVEL     #1CTRY        WUCRSN                         Ctry Dom  Scree
     C                   MOVEL     *BLANK        WUCTSN                         Cust Type Scree
     C                   MOVEL     #1CUTY        WUCTSN                         Cust Type Scree
     C                   MOVEL     *BLANK        WUISSN                         Inst Code Scree
     C                   MOVEL     #1INST        WUISSN                         Inst Code Scree
     C                   MOVEL     *BLANK        WUMOSN                         Module    Scree
     C                   MOVEL     #1MODU        WUMOSN                         Module    Scree
     C                   MOVEL     *BLANK        WUTTSN                         Trans     Scree
     C                   MOVEL     #1TRTY        WUTTSN                         Trans     Scree
     C                   MOVEL     *BLANK        WUTSSN                         Trans S   Scree
     C                   MOVEL     #1TRST        WUTSSN                         Trans S   Scree
      *
      *================================================================
     CSR   UKEXIT        ENDSR
      /EJECT
     CSR   ZASNMS        BEGSR
      *================================================================
      * Send message to program's message queue.
      *================================================================
     C     ZAPGM         IFEQ      *BLANK
     C                   MOVEL     ##PGM         ZAPGM
     C                   END
      * If no message file specified use default.
     C     ZAMSGF        IFEQ      *BLANK
     C                   MOVEL     ZADFMF        ZAMSGF
     C                   END
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGM            10            Program queue
     C                   PARM                    ZAPGRL            5            Rel queue
     C                   PARM                    ZAMSID            7            Message Id.
     C                   PARM                    ZAMSGF           10            Message file.
     C                   PARM                    ZAMSDA          132            Message data.
     C                   PARM                    ZAMSTP            7            Message type.
      * Clear all fields for default mechanism next time.
     C                   MOVEL     *BLANK        ZAPGM                          Program queue
     C                   MOVEL     *BLANK        ZAPGRL                         Rel queue
     C                   MOVEL     *BLANK        ZAMSID                         Message Id.
     C                   MOVEL     *BLANK        ZAMSGF                         Message file.
     C                   MOVEL     *BLANK        ZAMSDA                         Message data.
     C                   MOVEL     *BLANK        ZAMSTP                         Message type.
      *================================================================
     CSR   ZAEXIT        ENDSR
      /EJECT
     CSR   ZHHPKY        BEGSR
      *================================================================
      * Display HELP text.
      *================================================================
     C                   MOVEL     'Y'           W0HLP             1            Signal help req
     C                   CALL      'YDDSHPR'
     C                   PARM      ##PGM         W0HPMB           10            Member name.
     C                   PARM      *BLANK        YYHPFL           10            *DFT text file.
     C                   PARM      *BLANK        YYHPLB           10            Help text lib.
     C                   PARM                    W0RTN             7            Return Code.
      *================================================================
     CSR   ZHEXIT        ENDSR
      /EJECT
     CSR   ZXEXPG        BEGSR
      *================================================================
      * Cancel & exit program
      *================================================================
      * USER: Exit program processing
      *CASE:     DTL.*CMD key is CF03
     C     *IN03         IFEQ      '1'                                          *IF
     C                   MOVEL     @CN(04)       P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   END                                                    *FI
     C                   MOVEL     *BLANK        P0RTN
     C                   EXSR      ZYEXPG
      *================================================================
     CSR   ZXEXIT        ENDSR
      /EJECT
     CSR   ZYEXPG        BEGSR
      *================================================================
      * Exit program: Direct.
      *================================================================
      * Terminate program.
     C                   SETON                                        LR
      *
      * Exit program.
     C                   RETURN
      *
      *================================================================
     CSR   ZYEXIT        ENDSR
      /EJECT
     CSR   ZZINIT        BEGSR
      *================================================================
      * Initialisation.
      *================================================================
     C                   MOVE      *BLANK        P0RTN
     C                   MOVE      *BLANK        W0RTN             7
      * Setup job date/time.
     C                   Z-ADD     UDATE         ##JDT                          Job date.
     C                   TIME                    ##JTM                          Job time.
     C                   TIME                    ##TME             6 0          Screen time.
      * Define work field S01212
     C                   MOVEL     *BLANK        WUMFTS            1
      * Define work field Window processing requir.
     C                   MOVEL     *BLANK        WUWDPR            1
      * Obtain default message file.
     C     *DTAARA       DEFINE    Y2MGFLA       ZADFMF           10
     C                   IN        ZADFMF
      * Define work field WH Tax Rate Def Matrix-Branch
     C                   Z-ADD     *ZERO         WUWMBH            2 0
      * Define work field WH Tax Rate Def Matrix-Book
     C                   Z-ADD     *ZERO         WUWMBK            2 0
      * Define work field WH Tax Rate Def Matrix-Currency
     C                   Z-ADD     *ZERO         WUWMCY            2 0
      * Define work field WH Tax Rate Def Matrix-Country of Domicile
     C                   Z-ADD     *ZERO         WUWMCR            2 0
      * Define work field WH Tax Rate Def Matrix-Customer Type
     C                   Z-ADD     *ZERO         WUWMCT            2 0
      * Define work field WH Tax Rate Def Matrix-Institution Code
     C                   Z-ADD     *ZERO         WUWMIS            2 0
      * Define work field WH Tax Rate Def Matrix-Module
     C                   Z-ADD     *ZERO         WUWMMO            2 0
      * Define work field WH Tax Rate Def Matrix-Transaction Type
     C                   Z-ADD     *ZERO         WUWMTT            2 0
      * Define work field WH Tax Rate Def Matrix-Transaction Subtype
     C                   Z-ADD     *ZERO         WUWMTS            2 0
      * Define work field WH Tax Rate Def Matrix-Country of Risk                              AUA012
     C                   Z-ADD     *ZERO         WUWMCK            2 0
      * Define work field Check For Asterisk in Key
     C                   MOVEL     *BLANK        WUCAKY            1
      * Define work field Branch Code   Screen Fld
     C                   MOVEL     *BLANK        WUBHSN           10
      * Define work field Book Code     Screen Fld
     C                   MOVEL     *BLANK        WUBKSN           10
      * Define work field Currency      Screen Fld
     C                   MOVEL     *BLANK        WUCYSN           10
      * Define work field Country of Domicile Screen Fld
     C                   MOVEL     *BLANK        WUCRSN           10
      * Define work field Customer Type Screen Fld
     C                   MOVEL     *BLANK        WUCTSN           10
      * Define work field Institution Code Screen Fld
     C                   MOVEL     *BLANK        WUISSN           10
      * Define work field Module        Screen Fld
     C                   MOVEL     *BLANK        WUMOSN           10
      * Define work field Transaction Type Screen Fld
     C                   MOVEL     *BLANK        WUTTSN           10
      * Define work field Transaction Subtype Screen Fld
     C                   MOVEL     *BLANK        WUTSSN           10
      * Define work field Country of Risk Screen Fld                                          AUA012
     C                   MOVEL     *BLANK        WUCRSK           10
      * Define work field Midas Run Date
     C                   MOVEL     *BLANK        WUMRDT            7
      * Define work field Run day number
     C                   Z-ADD     *ZERO         WURDNB            5 0
      * Define work field Set Up Complete
     C                   MOVEL     *BLANK        WUSUC             1
      * Define work field Date format flag
     C                   MOVEL     *BLANK        WUDFF             1
      * Define work field Multi-branching Indicator
     C                   MOVEL     *BLANK        WUMBIN            1
      * USER: Initialise program
      * Standard RPG Creation PAR - Standard Functions  *
      * Last Amend Box SDH023E - Withholding Tax Rate Default Matrix *
      * Copyright Statement - Standard Functions  *
      * Get Rundate - Rundate  *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      MRDT          ##MRDT                         RUN DATE       S0122
     C                   MOVE      MRDT          WUMRDT                                        S0122
     C                   MOVE      RDNB          WURDNB                         RUNDAY NO.     S0122
     C                   MOVE      SUC           WUSUC                          SET UP COMPLT  S0122
     C                   MOVE      DFF           WUDFF                          DTE FMT FLAG   S0122
     C                   MOVE      MBIN          WUMBIN                         MULTI BR. IND  S0122
      *
      * Obtain WH Tax Rate Dft Pty - General Ledger Details  *
     C                   EXSR      SARVGN
     C                   MOVEL     @CN(01)       WUMFTS                         S01212
      *CASE:     WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      @CN(01)                                      *IF
      * WH Tax Rate Def Mat DATA DS - Withholding Tax Rate Default Matrix *
      * Get 'Window required' ind - MIDAS Modules  *
     C                   EXSR      SBRVGN
     C                   END                                                    *FI
      * Load screen
     C                   EXSR      MALDSC
      *================================================================
     CSR   ZZEXIT        ENDSR
      *
**CTDATA SHR2
Branch Code .........:
Book Code ...........:
Currency ............:
Country of Domicile..:
Customer Type .......:
Institution Code ....:
Module ..............:
Product Type ........:
Product Subtype......:
**CTDATA PMTV
F3=Main Menu   F10=Delete   F12=Previous
F3=Main Menu   F12=Previous
F3=Main Menu   F12=Previous
**CTDATA CPY@
(c) Finastra International Limited 2015
**CTDATA @CN
Y
USR0790
E
Y2U9999
USR0563
Y2U0004
*
A
GELR
Y2U0005
Y2U0003
MMOD
