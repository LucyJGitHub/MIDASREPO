     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
      *****************************************************************
      *                                                               *
      *  Meridian Replication                                         *
      *                                                               *
      *  X08EMR - Log viewer                                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. MD058809           Date 16Dec21               *
      *  Prev Amend No. 000876 Bugzilla    Date 18Apr06               *
      *                 093531 RoyalBlue   Date 26Feb03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058809 - After installation of MQ9 compatibility patch and *
      *             restart of the Meridian Replication subsystem     *
      *             REPMIDASPT, the job MPT1PBSIN ended in MSGW.      *
      *  000876 - Remove reference to KAPSTATUS to make errors visible*
      *  093531 - Enable data to be shown - change *HIVAL SETGT to    *
      *           *END SETLL.                                         *
      *           Also X6TIME value is now too long to fit in a 9,0   *
      *           files so extend this.                               *
      *                                                               *
      *****************************************************************
      /TITLE X08EMR - Log viewer                                          T02FMR
      *-------------------------------------------------------------------T02FMR
      *              System Name - MDBA                                   T02FMR
      *              Module Name - Replication                            T02FMR
      *                                                                   T02FMR
      *             Program Name - X08EMR                                 T02FMR
      *            Program Title - Log viewer                             T02FMR
      *                                                                   T02FMR
      *                                                                   T02FMR
      *            Creation Date - 12 March 1998                          T02FMR
      *      Last Amendment Date -                                        T02FMR
      *-------------------------------------------------------------------T02FMR
      *P Purpose                                                          T02FMR
      *P ~~~~~~~                                                          T02FMR
      *P To display log messages from MDBA processes
      *P                                                                  T02FMR
      *-------------------------------------------------------------------T02FMR
      *H Change Control                                                   T02FMR
      *H ~~~~~~~~~~~~~~                                                   T02FMR
      *H Project     Programmer    Date         Level                     T02FMR
      *H ~~~~~~~     ~~~~~~~~~~    ~~~~         ~~~~~                     T02FMR
      *-------------------------------------------------------------------------
      /EJECT                                                              T02FMR
      *                                                                   HSPEC
      *  Program header specification                                     HSPEC
     H DEBUG DECEDIT('.') DFTNAME(HSPEC) DATEDIT(*DMY/)
      *                                                                   T02FMR
      *-------------------------------------------------------------------T02FMR
      *  FILES                                                            T02FMR
      *-------------------------------------------------------------------T02FMR
      *                                                                   T02FMR
      *  X08FMD  - Log viewer
     FX08EMD    CF   E             WORKSTN INFSR(*PSSR)                         T02FMR
     F                                     USROPN
     F                                     SFILE(EQSFL:#RRNS)                   T02FMR
      *
      * X610LF - Log messages by time and process                         T02FMR
     FX610LF    IF   E           K DISK    INFSR(*PSSR)                         T02FMR
     F                                     USROPN
      *                                                                   T02FMR
      *-------------------------------------------------------------------T02FMR
      *  ARRAYS                                                           T02FMR
      *-------------------------------------------------------------------T02FMR
      *                                                                   T02FMR
      *  Compile time arrays                                              T02FMR
      *                                                                   T02FMR
     D TABA            S              1    DIM(11) CTDATA PERRCD(11)
      *                                                                   T02FMR
      *  Execution time arrays                                            T02FMR
      *                                                                   T02FMR
      *                                                                   ARZBA
      *   Work arrays                                                     ARZBA
      *                                                                   ARAST
      *  Array of warning asterisks for the screen                        ARAST
     D AST             S              1    DIM(50)                                               ARA
      *                                                                   ARFIA
      *  Array of screen fields with error or warning                     ARFIA
     D FIA             S              1    DIM(50)                                               ARF
      *                                                                   AROID
      *  Arrays for user defined command key options and text             AROID
     D OID             S              3    DIM(4)                                                ARO
     D OCT             S             11    DIM(4)                                                ARO
      *                                                                   AR@EM
      *  Error messages array                                             AR@EM
     D @EM             S             37    DIM(20)                                               AR@
      *                                                                   ARAPW
      *  Array of warning messages overriden so far                       ARAPW
     D APW             S             40    DIM(50)                                               ARA
      *                                                                   ARAPW
      *  Array of warning messages from this validation pass              ARAPW
     D AAW             S             40    DIM(50)                                               ARA
      /EJECT                                                              T02FMR
      *                                                                   T02FMR
      *-------------------------------------------------------------------T02FMR
      *  DATA AREAS                                                       T02FMR
      *-------------------------------------------------------------------T02FMR
      *                                                                   T02FMR
      *                                                                   T02FMR
      *-------------------------------------------------------------------T02FMR
      *  DATA STRUCTURES                                                  T02FMR
      *-------------------------------------------------------------------T02FMR
      *                                                                   T02FMR
      *                                                                   DPGMDS
      *  DPGMDS - Program Status Data Structure                           DPGMDS
      *                                                                   DPGMDS
      *  Kaprog - 1A0                                                     DPGMDS
      *                                                                   DPGMDS
     D DPGMDS         SDS                                                       DPGMDS
     D  @PGMID           *PROC                                                  DPGMDS
     D  $PGMST           *STATUS                                                DPGMDS
      *                                                                   DMSGDS
      *  DSMSG  - Dump Message Data Structure                             DMSGDS
      *                                                                   DMSGDS
      *                                                                   DMSGDS
     D DSMSG           DS                                                       DMSGDS
     D  $PSCPY                 1     40    INZ('( C )  COPYRIGHT -              DMSGDS
     D                                     MISYS PLC 1995')                     DMSGDS
     D  $PSPGM                41     47    INZ('PROGRAM')                       DMSGDS
     D  $PSEIE                48     61    INZ('ENDED IN ERROR')                DMSGDS
     D  $PSDPT                62     73    INZ('- DUMP TAKEN')                  DMSGDS
     D  $PSRCD                74     79    INZ('RECORD')                        DMSGDS
     D  $PSINF                80     86    INZ('IN FILE')                       DMSGDS
     D  $PSNTF                87     95    INZ('NOT FOUND')                     DMSGDS
     D  $DMPID                96    105                                         DMSGDS
     D**$PSSTS               106    115    INZ('KAPSTATUS')                     000876
     D  $PSSTS               106    115                                         000876
      *                                                                   T02FMR
      *                                                                   DSEPMS
      *  DSEPMS - Error Message Data Structure                            DSEPMS
      *                                                                   DSEPMS
      *  Kaprog - 1A0                                                     DSEPMS
      *                                                                   DSEPMS
     D DSEPMS          DS                                                       DSEPMS
     D  @ERM                   1      7                                         DSEPMS
     D  @PM1                   8     17                                         DSEPMS
     D  @PM2                  18     27                                         DSEPMS
     D  @PM3                  28     37                                         DSEPMS
     D  @PMALL                 8     37                                         DSEPMS
      *                                                                   DSUDCT
      *  DSFKEY - User defined function key text                          DSUDCT
      *                                                                   DSUDCT
     D DSFKEY          DS                  OCCURS(9)                            DSUDCT
     D  ZLCMD1                 1     78                                         DSUDCT
     D  ZLCMD2                79    156                                         DSUDCT
     D  $CNTIN                79     96                                         DSUDCT
     D  $USDCT                99    142                                         DSUDCT
     D  $OVRDE               143    156                                         DSUDCT
     D  $SINIT               157    157                                         DSUDCT
     D  $FOID                158    160                                         DSUDCT
      *                                                                   DSMSGI
      *  Message and indicator combination for tracking warnings          DSMSGI
     D DSMSGI          DS                                                       DSMSGI
     D  $MSG                   1     37                                         DSMSGI
     D  $I                    38     39  0                                      DSMSGI
     D  $SCRN                 40     40                                         DSMSGI
      *                                                                   DSZBA
      *   DSZBA  - Data structure of array ZBA                            DSZBA
     D DSZBA           DS                                                       DSZBA
     D  ZBA                    1    128                                         DSZBA
     D                                     DIM(128)                                              ARZ
      *
     D DSPATT          DS                  OCCURS(10)
     D  PATLEN                 1      2P 0
     D  #START                 3      4P 0
     D  #LIMIT                 5      6P 0
     D  TRNSLT                 7      7
     D  #PATT                  8     26
      *
     D DSRCD           DS
     D  PROC1                  1     19
      *
     D DSAST           DS
     D  AST01                  1      1
      *                                                                   T02FMR
     D TimeToConvert   S             10P 0                                      093531
                                                                                093531
     D DSDATE          DS            26
     D  MON                    5      7
     D  DAY                    9     10
     D  #TIME                 12     19
      *
     D DSDATA          DS
     D  #DATA                  1    200
     D  ZMDTA1                 1     50
     D  ZMDTA2                51    100
     D  ZMDTA3               101    150
     D  ZMDTA4               151    200
      *
     D DSVIEW          DS            74
     D  #DATE                  1      5
     D  #TIM                   7     14
     D  #DBG                  18     18
     D  #PROC                 22     74
     D  #MESS                 42     74
      *
     D X6BUFF          DS          2000
      *-------------------------------------------------------------------T02FMR
      *  PRE-INITIALISED DATA STRUCTURES                                  T02FMR
      *-------------------------------------------------------------------T02FMR
      *                                                                   T02FMR
      *  KAPROG data structure                                            T02FMR
     D KAPROG          DS                                                       T02FMR
     D  XXXXXX                 1      6    INZ('XXXXXX')                        T02FMR
     D  KAPLVL                 8     10    INZ('E3B')                           T02FMR
     D  KAPPGM                12     17                                         T02FMR
     D  KAPPG7                12     18                                         T02FMR
      *                                                                   T02FMR
      *-------------------------------------------------------------------T02FMR
      *  NAMED CONSTANTS                                                  T02FMR
      *-------------------------------------------------------------------T02FMR
      *                                                                   T02FMR
      *COPY EQCPYSRC,STDCNST                     Standard program constantT02FMR
      *                                                                   STDCNS
      * Define standard program constants                                 STDCNS
      *                                                                   STDCNS
     D #YES            C                   CONST('Y')                           STDCNS
     D #NO             C                   CONST('N')                           STDCNS
     D #FALSE          C                   CONST('0')                           STDCNS
     D #TRUE           C                   CONST('1')                           STDCNS
     D #DIGIT          C                   CONST('0123456789')                  STDCNS
      *                                                                   T02FMR
      * Set up maximum number of screens                                  T02FMR
     D #SCNO           C                   CONST(2)                             T02FMR
      *                                                                   T02FMR
     D MN              C                   CONST('mnemonic')                    T02FMR
     D $OVRD           C                   CONST('F24=Override')
     D $MENT           C                   CONST('ENTRY')
     D $MMNT           C                   CONST('MAINT')
      *                                                                   T02FMR
     D SFLPAG          C                   CONST(16)
      *
     D CMD1            C                   CONST('1=Select  F3=Exit  F-
     D                                     11=View 2  F12=Cance-
     D                                     l')
      *
     D CMD2            C                   CONST('1=Select  F3=Exit  F-
     D                                     11=View 1  F12=Cance-
     D                                     l')
      *
     D CMD3            C                   CONST('F3=Exit  F12=Cancel')
      *
     D #PRC            C                   CONST('Process')
     D #MES            C                   CONST('Message')
      *-------------------------------------------------------------------T02FMR
      *  PARAMETER AND KEY LISTS                                          T02FMR
      *-------------------------------------------------------------------T02FMR
      *                                                                   T02FMR
      *  Parameter lists                                                  T02FMR
      *                                                                   T02FMR
      *                                                                   PLM14
      *  PLM14  - Plist for sending messages to program message queue     PLM14
      *                                                                   PLM14
      *  Kaprog - 1A0                                                     PLM14
      *                                                                   PLM14
      *  @PGM   - Program message queue to send messages to               PLM14
      *  @EM    - Message id and parameters array  (upto 20*37bytes)      PLM14
      *  S2     - Number of messages to send                              PLM14
      *  @CLRQ  - Clear queue first before sending these messages         PLM14
      *                                                                   PLM14
     C     PLM14         PLIST                                                                 PLM14
     C                   PARM                    @PGM             10                           PLM14
     C                   PARM                    @EM                                           PLM14
     C                   PARM                    S2                2 0                         PLM14
     C                   PARM                    @CLRQ             1                           PLM14
      *                                                                   PLMSG
      *  PLMSG  - Plist for message retreival from KSMMSGF                PLMSG
      *                                                                   PLMSG
      *  Kaprog - 1A0                                                     PLMSG
      *                                                                   PLMSG
      *  @MSGID - Message identifier                                      PLMSG
      *  @MSGDA - Three by 10 byte message parameters (&1,&2,&3)          PLMSG
      *  @MSGDT - Return message text                                     PLMSG
      *  @MSGSV - Return message severity                                 PLMSG
      *                                                                   PLMSG
     C     PLMSG         PLIST                                                                 PLMSG
     C                   PARM                    @MSGID            7                           PLMSG
     C                   PARM                    @MSGDA           30                           PLMSG
     C                   PARM                    @MSGDT          132                           PLMSG
     C                   PARM                    @MSGSV            2 0                         PLMSG
      *                                                                   T02FMR
      *  Key lists                                                        T02FMR
      *                                                                   MAIN
      *  *None                                                            MAIN
      *                                                                   MAIN
      /EJECT                                                              MAIN
      *===================================================================MAIN
      *  INITIAL PROCESSING                                               MAIN
      *===================================================================MAIN
      *                                                                   MAIN
      *  Open display file                                                MAIN
B001 C     #OPEN         IFNE      #YES                                                        MAIN
 001 C                   OPEN      X08EMD                                                      MAIN
 001 C                   OPEN      X610LF                                                      MAIN
      *                                                                   MAIN
 001 C                   MOVE      #YES          #OPEN             1                           MAIN
E001 C                   END                                                    #OPEN NE #YES  MAIN
      /EJECT                                                              MAIN
      *===================================================================MAIN
      *  MAINLINE                                                         MAIN
      *===================================================================MAIN
      *                                                                   MAIN
      *  Process until end of transaction                                 MAIN
B001 C                   DO        *HIVAL                                                      MAIN
      *                                                                   MAIN
      *  Initial transaction processing                                   MAIN
 001 C                   EXSR      A000                                                        MAIN
      *                                                                   MAIN
      *  Process screens until end of transaction                         MAIN
B002 C     #EOT          DOUEQ     #YES                                                        MAIN
 002 C                   EXSR      B000                                                        MAIN
E002 C                   END                                                    #EOT EQ #YES   MAIN
      *                                                                   MAIN
      *  End of transaction processing (If F12 not pressed)               MAIN
B002 C     #CMDKY        IFNE      '12'                                                        MAIN
 002 C                   EXSR      C000                                                        MAIN
E002 C                   END                                                    #CMDKY NE '12' MAIN
      *                                                                   MAIN
E001 C                   END                                                    DO *HIVAL      MAIN
      /EJECT                                                              MAIN
      *===================================================================MAIN
      *  SUBROUTINES                                                      MAIN
      *===================================================================MAIN
      *                                                                   MAIN
      *-------------------------------------------------------------------MAIN
     C     A000          BEGSR                                                                 A000
      *-------------------------------------------------------------------A000
      *                                                                   A000
      *S Initial transaction processing                                   A000
      *                                                                   A000
      *-------------------------------------------------------------------A000
      *                                                                   A000
      *D This subroutine is executed once for each new transaction to:    A000
      *D  - Reset error message and control flags                         A000
      *D  - Blank out screen fields                                       A000
      *D  - Load any pre-entered key fields from selection string/default A000
      *D  - data/context dataarea                                         A000
      *                                                                   A000
      *-------------------------------------------------------------------A000
      *                                                                   A000
      *  Reset end of transaction indicator                               A000
     C                   MOVE      #NO           #EOT              1                           A000
     C                   MOVE      #NO           #SKIP             1                           A000
      *                                                                   A000
      *  Clear field indicator array                                      A000
     C                   MOVEA     *ZEROS        FIA                                           A000
      *                                                                   A000
      *  Reset 'clear message subfile' and 'VLDCMDKEY' indicator          A000
     C                   MOVE      *OFF          *IN83                                         A000
     C                   MOVE      *OFF          *IN90                                         A000
      *                                                                   A000
      *  Reset error message flags                                        A000
     C                   MOVE      #NO           #MSG              1                           A000
     C                   MOVE      #NO           #ERROR            1                           A000
     C                   MOVE      #NO           #WARN             1                           A000
     C                   MOVE      #NO           #INFO             1                           A000
     C                   MOVE      #NO           #UPMSG            1                           A000
     C                   MOVE      #NO           #DSPLY            1                           A000
      *                                                                   A000
      *  Reset message severity field                                     A000
     C                   Z-ADD     *ZERO         #MSGSV            2 0                         A000
      *                                                                   A000
      *  Reset screen number to one                                       A000
     C                   Z-ADD     1             #SCRN             1 0                         A000
      *                                                                   A000
      *  Clear overriden warning message field                            A000
     C                   MOVE      *BLANKS       @OWM             40                           A000
     C                   MOVE      *BLANKS       @SEV              2                           A000
     C                   MOVEA     *BLANKS       APW                                           A000
     C                   Z-ADD     *ZEROS        P3                3 0                         A000
      *                                                                   A000
      *  Default function type to add and mode to 'ENTRY'                 A000
     C                   MOVE      'A'           @FCT              1                           A000
      *                                                                   A000
      *  Clear screen fields                                              A000
     C                   EXSR      A100                                                        A000
      *                                                                   A000
      *  Clear out stored error message arrays and set array counter      A000
     C                   MOVEA     *BLANKS       @EM                                           A000
     C                   Z-ADD     0             S3                3 0                         A000
     C                   MOVE      #NO           @PRMPT            1                           A000
      *                                                                   A000
      *  Clear overriden warning messages and warning asterisks arrays    A000
     C                   MOVEA     *BLANKS       AST                                           A000
      *                                                                   A000
      *  Only display key screen if not enough fields have been provided  A000
B001 C     #SKIP         IFEQ      #NO                                                         A000
     C                   Z-ADD     1             #VIEW
     C                   EXSR      INZSFL
     C                   EXSR      BLDSFL
 001 C                   EXSR      Z200                                                        A000
E001 C                   END                                                    #SKIP EQ #NO   A000
      *                                                                   A000
     C                   ENDSR                                                                 A000
      /EJECT                                                              T02FMR
      *-------------------------------------------------------------------T02FMR
     C     A100          BEGSR                                                                 A100
      *-------------------------------------------------------------------A100
      *                                                                   A100
      *S Clear screen fields                                              A100
      *                                                                   A100
      *-------------------------------------------------------------------A100
      *                                                                   A100
      *  Initialise screen fields for a new transaction                   A100
      *                                                                   A100
     C                   MOVE      *BLANKS       ZLDBGC
     C                   MOVE      *BLANKS       ZLPRCC
      *
     C                   ENDSR                                                                 A100
      /EJECT                                                              T02FMR
      *-------------------------------------------------------------------T02FMR
     C     B000          BEGSR                                                                 B000
      *-------------------------------------------------------------------B000
      *                                                                   B000
      *S Process screens until end of transaction                         B000
      *                                                                   B000
      *-------------------------------------------------------------------B000
      *                                                                   B000
      *D Read last screen that was dispalyed                              B000
      *D Validate and action any function key that has been pressed       B000
      *D Check for fields containing prompt characters                    B000
      *D If prompt characters found call validation program in prompt     B000
      *D mode else call in validate mode.                                 B000
      *D Update context dataarea with key screen fields                   B000
      *D Call update program when complete transaction is valid           B000
      *                                                                   B000
      *-------------------------------------------------------------------B000
      *                                                                   B000
      *  If key screen has been displayed, read it. Otherwise reset #SKIP B000
      *  flag for next transaction                                        B000
B001 C     #SKIP         IFEQ      #NO                                                         B000
 001 C                   EXSR      B100                                                        B000
X001 C                   ELSE                                                   Else           B000
 001 C                   MOVE      #NO           #SKIP                                         B000
E001 C                   END                                                    #SKIP EQ #NO   B000
      *                                                                   B000
      *  Reset 'messages to display' flag and message severity            B000
     C                   MOVE      #NO           #MSG                                          B000
     C                   Z-ADD     *ZERO         #MSGSV                                        B000
      *                                                                   B000
      *  Reset invalid function key flag                                  B000
     C                   MOVE      #NO           #INVCK                                        B000
      *                                                                   B000
      *  Clear function key field and branching field                     B000
     C                   MOVE      '  '          #CMDKY            2                           B000
     C                   MOVE      '0'           #TAGNO            1                           B000
      *                                                                   B000
      *  Validate function key if pressed                                 B000
     C     *IN90         CASEQ     *ON           USA49R                                        B000
     C                   END                                                    Case End       B000
      *                                                                   B000
      *  Branch to display screen or not if necessary                     B000
     C     #TAGNO        CABEQ     '1'           B00010                                        B000
     C     #TAGNO        CABEQ     '2'           B000XT                                        B000
      *                                                                   B000
      *  If an error message was returned from update module the only     B000
      *  valid action is to exit screen using function keys               B000
      *  NB - record has not been updated                                 B000
B001 C     #UPMSG        IFEQ      #YES                                                        B000
 001 C     #ERROR        ANDEQ     #YES                                                        B000
 001 C                   GOTO      B00010                                                      B000
E001 C                   END                                                    #UPMSG EQ #YES B000
      *                                                                   B000
      *  If an info message was returned from update module then the      B000
      *  transaction has been updated. ENTER must be pressed to redisplay B000
      *  the key screen (or use function keys)                            B000
B001 C     #UPMSG        IFEQ      #YES                                                        B000
 001 C     #INFO         ANDEQ     #YES                                                        B000
 001 C                   MOVE      #YES          #EOT                                          B000
 001 C                   GOTO      B000XT                                                      B000
E001 C                   END                                                    #UPMSG EQ #YES B000
      *                                                                   B000
      *  Perform validation pass                                          B000
     C                   EXSR      B200                                                        B000
      *                                                                   B000
      *  If errors or warnings or not previously displayed information    B000
      *  messages returned, then redisplay screen                         B000
B001 C     #ERROR        IFEQ      #YES                                                        B000
 001 C     #WARN         OREQ      #YES                                                        B000
 001 C     #INFO         OREQ      #YES                                                        B000
 001 C     #DSPLY        ANDEQ     #NO                                                         B000
 001 C                   GOTO      B00010                                                      B000
E001 C                   END                                                    #ERROR EQ #YES B000
      *                                                                   B000
      *  Reset the 'information messages displayed' flag                  B000
B001 C     #INFO         IFEQ      #YES                                                        B000
 001 C                   MOVE      #NO           #DSPLY                                        B000
E001 C                   END                                                    #INFO EQ #YES  B000
      *                                                                   B000
      *  If verify pressed then redisplay same screen                     B000
B001 C     #CMDKY        IFEQ      '05'                                                        B000
 001 C                   GOTO      B00010                                                      B000
E001 C                   END                                                    #CMDKY EQ '05' B000
      *                                                                   B000
      *  Screen is valid from here onwards, and ENTER has been pressed    B000
      *                                                                   B000
      *  If another screen to display increment screen number             B000
B001 C     #SCRN         IFLT      #SCNO                                                       B000
     C     #SINP         ANDEQ     '1'
 001 C                   ADD       1             #SCRN                                         B000
X001 C                   ELSE                                                   Else           B000
      *                                                                   B000
      *  Otherwise must be last screen and no messages to display so      B000
      *  if screen has changed call the update module.  If screen has     B000
      *  not been changed simply redisplay the key screen                 B000
      *                                                                   B000
E001 C                   END                                                    #SCRN LT #SCNO B000
      *                                                                   B000
      *  Write a screen                                                   B000
     C     B00010        TAG                                                                   B000
B001 C     #EOT          IFEQ      #NO                                                         B000
 001 C                   EXSR      Z200                                                        B000
E001 C                   END                                                    #EOT EQ #NO    B000
      *                                                                   B000
     C     B000XT        ENDSR                                                                 B000
      /EJECT                                                              T02FMR
      *-------------------------------------------------------------------T02FMR
     C     B100          BEGSR                                                                 B100
      *-------------------------------------------------------------------B100
      *                                                                   B100
      *S Read the detail screen last written                              B100
      *                                                                   B100
      *-------------------------------------------------------------------B100
      *                                                                   B100
S001 C                   SELECT                                                                B100
      *                                                                   B100
W001 C     #SCRN         WHENEQ    1                                                           B100
 001 C                   READ      EQCTL                                  99    EOF            B100
      *
     C     #SCRN         WHENEQ    2
     C                   READ      X08EMDB                                99
      *                                                                   B100
E001 C                   ENDSL                                                  SELEC          B100
      *                                                                   B100
     C     *IN99         CASEQ     *ON           *PSSR                                         B100
     C                   END                                                    Case End       B100
      *                                                                   B100
     C                   ENDSR                                                                 B100
      /EJECT                                                              T02FMR
      *-------------------------------------------------------------------T02FMR
     C     B200          BEGSR                                                                 B200
      *-------------------------------------------------------------------B200
      *                                                                   B200
      *S Validate fields from the current screen                          B200
      *                                                                   B200
      *-------------------------------------------------------------------B200
      *                                                                   B200
      *  Initalise fields for validation                                  B200
     C                   MOVEA     *ZEROS        FIA                                           B200
     C                   MOVE      *BLANKS       @SEV                                          B200
     C                   MOVEA     *BLANKS       AAW                                           B200
     C                   MOVE      *BLANKS       DSEPMS                                        B200
     C                   Z-ADD     0             S3                                            B200
     C                   MOVE      #YES          @CLRQ                                         B200
     C                   MOVE      *BLANKS       #SINP
      *                                                                   B200
      *  Initialise array indexs                                          B200
     C                   Z-ADD     1             T3                3 0                         B200
     C                   Z-ADD     1             I3                3 0                         B200
     C                   Z-ADD     1             J3                3 0                         B200
      *                                                                   B200
S001 C                   SELECT                                                                B200
      *                                                                   B200
      *  Screen 1                                                         B200
W001 C     #SCRN         WHENEQ    1                                                           B200
      *
     C     ZLDBGC        IFNE      #DBGC
     C     ZLPRCC        ORNE      #PRCC
     C                   MOVE      ZLDBGC        #DBGC
     C                   MOVE      ZLPRCC        #PRCC
     C     ZLDBGC        LOOKUP    TABA                                   90
     C     *IN90         IFEQ      *OFF
     C     ZLDBGC        ANDNE     $PCHRO
     C     ZLDBGC        ANDNE     $PCHRM
     C                   MOVE      'KCM1555'     @ERM
     C                   Z-ADD     1             T3
     C                   MOVE      *BLANKS       @PMALL
     C                   MOVEL     'Field'       @PMALL
     C                   EXSR      USA01R
     C                   END
      *
     C     ZLPRCC        IFNE      *BLANK
     C                   MOVEL     ZLPRCC        DSZBA
     C                   Z-ADD     1             K2
     C     $PCHRM        LOOKUP    ZBA(K2)                                80
     C     *IN80         IFNE      *ON
     C                   Z-ADD     19            K2
     C                   END
      *
     C                   MOVE      #YES          #FFLD             1
     C                   MOVE      #FALSE        #TRNS
     C                   Z-ADD     19            J3
     C                   EXSR      PRECHK
     C                   END
      *
     C     FIA(1)        IFEQ      #FALSE
     C     FIA(2)        ANDEQ     #FALSE
     C                   EXSR      INZSFL
     C                   EXSR      BLDSFL
     C                   MOVE      '05'          #CMDKY
     C                   END
     C                   END
      *                                                                   B200
      *  Validate subfile                                                 B200
B002 C     #RRNS         IFGT      0                                                           B200
 002 C                   READC     EQSFL                                  98    EOF            B200
     C     *IN98         IFEQ      *OFF
     C                   MOVE      ZLSINP        #SINP             1
B004 C     ZLSINP        IFNE      *BLANK                                                      B200
B005 C     ZLSINP        ANDNE     '1'                                                         B200
 005 C                   MOVE      'KCM2042'     @ERM                                          B200
 005 C                   MOVEL(P)  ZLSINP        @PM1                                          B200
 005 C                   MOVEL(P)  '1'           @PM2                                          B200
 005 C                   Z-ADD     0             T3                                            B200
 005 C                   EXSR      USA01R                                                      B200
 006 C                   Z-ADD     #RRNS         RRN                                           B200
 006 C                   Z-ADD     #RRNS         PGNO                                          B200
     C                   ELSE
     C                   MOVEL(P)  ZLDATE        ZMDATE
     C                   MOVEL(P)  ZLTIME        ZMTIME
     C                   MOVE(P)   ZHDBGL        ZMDBGL
     C                   MOVEL(P)  ZHPROC        ZMPROC
     C                   MOVEL(P)  ZHDATA        #DATA
     C                   Z-ADD     CSR           PGNO
     C                   Z-ADD     CSR           RRN
E005 C                   END                                                    ZLSEL NE 'D'   B200
     C                   MOVE      *BLANK        ZLSINP
 004 C                   UPDATE    EQSFL                                                       B200
E002 C                   END                                                    #RRNS GT 0     B200
E002 C                   END                                                    #RRNS GT 0     B200
      *
E001 C                   ENDSL                                                  SELEC          B200
      *                                                                   B200
     C                   EXSR      USA14R                                                      B200
      *                                                                   B200
      *  Set message flags from validation parameters                     B200
     C                   EXSR      USA04R                                                      B200
      *                                                                   B200
     C     B200XT        ENDSR                                                                 B200
      /EJECT                                                              T02FMR
      *-------------------------------------------------------------------T02FMR
     C     C000          BEGSR                                                                 C000
      *-------------------------------------------------------------------C000
      *                                                                   C000
      *S End of transaction processing                                    C000
      *                                                                   C000
      *-------------------------------------------------------------------C000
      *                                                                   C000
      *  Exit program if only one transaction allowed or if F3 pressed    C000
B001 C     #CMDKY        IFEQ      '03'                                                        C000
 001 C                   MOVE      #YES          #SKIP                                         C000
      *                                                                   C000
      *  Close the screen explicitly                                      C000
B002 C     #OPEN         IFEQ      #YES                                                        C000
 002 C                   CLOSE     X08EMD                                                      C000
 002 C                   CLOSE     X610LF                                                      C000
 002 C                   MOVE      #NO           #OPEN                                         C000
E002 C                   END                                                    #OPEN EQ #YES  C000
 001 C                   SETON                                        LR                       C000
 001 C                   RETURN                                                                C000
E001 C                   END                                                    #CMDKY EQ '03' C000
      *                                                                   C000
     C                   ENDSR                                                                 C000
      /EJECT                                                              T02FMR
      *-------------------------------------------------------------------T02FMR
     C     Z200          BEGSR                                                                 Z200
      *-------------------------------------------------------------------Z200
      *                                                                   Z200
      *S Display a screen                                                 Z200
      *                                                                   Z200
      *-------------------------------------------------------------------Z200
      *                                                                   Z200
      *  Write header format                                              Z200
     C                   WRITE     HEADER                                                      Z200
      *                                                                   Z200
      *  Write trailer format                                             Z200
     C                   EXSR      Z220                                                        Z200
      *                                                                   Z200
      *  Write detail format                                              Z200
     C                   EXSR      Z210                                                        Z200
      *                                                                   Z200
      *  Perform additional processing per screen                         Z200
      *  (Used to make 'dummy' calls to validate and update modules)      Z200
     C                   EXSR      Z230                                                        Z200
      *                                                                   Z200
     C                   ENDSR                                                                 Z200
      /EJECT                                                              T02FMR
      *-------------------------------------------------------------------T02FMR
     C     Z210          BEGSR                                                                 Z210
      *-------------------------------------------------------------------Z210
      *                                                                   Z210
      *S Display detail format                                            Z210
      *                                                                   Z210
      *-------------------------------------------------------------------Z210
      *                                                                   Z210
      *  Reset screen warning asterisk fields                             Z210
     C                   MOVE      *BLANKS       DSAST                                         Z210
      *                                                                   Z210
      *  Set specific field display characteristic indicators             Z210
     C                   MOVEA     FIA           *IN                                           Z210
      *                                                                   Z210
      *  Set field attribute indicators depending on message severity     Z210
     C                   MOVE      *OFF          *IN73                                         Z210
     C                   MOVE      *OFF          *IN74                                         Z210
B001 C     #ERROR        IFEQ      #YES                                                        Z210
 001 C                   MOVE      *ON           *IN73                                         Z210
X001 C                   ELSE                                                   Else           Z210
B002 C     #WARN         IFEQ      #YES                                                        Z210
 002 C                   MOVE      *ON           *IN74                                         Z210
 002 C                   EXSR      USA06R                                                      Z210
E002 C                   END                                                    #WARN EQ #YES  Z210
E001 C                   END                                                    #ERROR EQ #YES Z210
      *                                                                   Z210
      *  If an update message passed back, protect the screen             Z210
     C                   MOVE      *OFF          *IN77                                         Z210
B001 C     #UPMSG        IFEQ      #YES                                                        Z210
 001 C                   MOVE      *ON           *IN77                                         Z210
E001 C                   END                                                    #UPMSG EQ #YES Z210
      *                                                                   Z210
      *  Display appropriate detail screen                                Z210
S001 C                   SELECT                                                                Z210
      *                                                                   Z210
W001 C     #SCRN         WHENEQ    1                                                           Z210
 001 C                   MOVE      *ON           *IN85                                         Z210
B002 C     #RRNS         IFGT      0                                                           Z210
 002 C                   MOVE      *ON           *IN86                                         Z210
E002 C                   END                                                    #RRNS GT 0     Z210
     C     #VIEW         IFEQ      2
     C                   MOVE      *ON           *IN51
     C                   MOVE      #MES          ZLCOL1
     C                   MOVE      *BLANKS       ZLCOL2
     C                   ELSE
     C                   MOVE      *OFF          *IN51
     C                   MOVE      #PRC          ZLCOL1
     C                   MOVE      #MES          ZLCOL2
     C                   END
 001 C                   WRITE     EQCTL                                                       Z210
      *
     C     #SCRN         WHENEQ    2
     C                   WRITE     X08EMDB
      *                                                                   Z210
E001 C                   ENDSL                                                  SELEC          Z210
      *                                                                   Z210
     C                   ENDSR                                                                 Z210
      /EJECT                                                              T02FMR
      *-------------------------------------------------------------------T02FMR
     C     Z220          BEGSR                                                                 Z220
      *-------------------------------------------------------------------Z220
      *                                                                   Z220
      *S Write trailer format                                             Z220
      *                                                                   Z220
      *-------------------------------------------------------------------Z220
      *                                                                   Z220
      *  Set up function key text for overriding warning messages         Z220
B001 C     #WARN         IFEQ      #YES                                                        Z220
 001 C     #CMDKY        ANDNE     '12'                                                        Z220
 001 C     #INVCK        ANDNE     #YES                                                        Z220
 001 C                   MOVEL     $OVR          $OVRDE                                        Z220
X001 C                   ELSE                                                   Else           Z220
 001 C                   MOVE      *BLANKS       $OVRDE                                        Z220
E001 C                   END                                                    #WARN EQ #YES  Z220
      *                                                                   Z220
      *  Write trailer format which contains function keys                Z220
     C                   MOVE      *OFF          *IN83                                         Z220
     C     #SCRN         IFEQ      1
     C     #VIEW         IFEQ      1
     C                   MOVEL(P)  CMD1          ZLCTXT
     C                   ELSE
     C                   MOVEL(P)  CMD2          ZLCTXT
     C                   END
     C                   ELSE
     C                   MOVEL(P)  CMD3          ZLCTXT
     C                   END
     C                   WRITE     OPTION                                                      Z220
      *                                                                   Z220
      *  If messages to display load the message subfile in one go        Z220
B001 C     #MSG          IFEQ      #YES                                                        Z220
      *                                                                   Z220
      *  Send any messages generated to this programs message queue       Z220
B002 C     S3            IFGT      0                                                           Z220
 002 C                   MOVEA     *ZEROS        FIA                                           Z220
 002 C                   MOVE      #YES          @CLRQ                                         Z220
 002 C                   EXSR      USA11R                                                      Z220
      *                                                                   Z220
      *  Reset severity level for messages initiated in this module       Z220
 002 C                   Z-ADD     0             #MSGSV                                        Z220
E002 C                   END                                                    S3 GT 0        Z220
X001 C                   ELSE                                                   Else           Z220
      *                                                                   Z220
      * If no messages from this pass, clear message queue                Z220
 001 C                   MOVE      #YES          @CLRQ                                         Z220
 001 C                   EXSR      USA11R                                                      Z220
E001 C                   END                                                    #MSG EQ #YES   Z220
      *                                                                   Z220
      * Display any messages on program message queue in the message      Z220
      * subfile                                                           Z220
     C                   MOVE      *ON           *IN83                                         Z220
     C                   WRITE     MSGCTL                               99      Error          Z220
      *                                                                   Z220
      *  If information message , flag that they have been displayed      Z220
B001 C     #INFO         IFEQ      #YES                                                        Z220
 001 C                   MOVE      #YES          #DSPLY                                        Z220
E001 C                   END                                                    #INFO EQ #YES  Z220
      *                                                                   Z220
     C                   ENDSR                                                                 Z220
      /EJECT                                                              T02FMR
      *-------------------------------------------------------------------T02FMR
     C     Z230          BEGSR                                                                 Z230
      *-------------------------------------------------------------------Z230
      *                                                                   Z230
      *S Perform additional processing per screen                         Z230
      *                                                                   Z230
      *-------------------------------------------------------------------Z230
      *                                                                   Z230
      *                                                                   Z230
     C                   ENDSR                                                                 Z230
      /EJECT                                                              T02FMR
      *-------------------------------------------------------------------T02FMR
     C     INZSFL        BEGSR                                                                 INZSF
      *-------------------------------------------------------------------INZSFL
      *                                                                   INZSFL
      *S Initialise the subfile                                           INZSFL
      *                                                                   INZSFL
      *-------------------------------------------------------------------INZSFL
      *                                                                   INZSFL
      *  Reset record numbers                                             INZSFL
     C                   Z-ADD     0             #RRNS                                         INZSF
     C                   Z-ADD     0             LSTRRN                                        INZSF
      *                                                                   INZSFL
      *  Clear the subfile                                                INZSFL
     C                   MOVE      *OFF          *IN85                                         INZSF
     C                   MOVE      *OFF          *IN86                                         INZSF
     C                   MOVE      *OFF          *IN73                                         INZSF
     C                   MOVE      *ON           *IN84                                         INZSF
     C                   WRITE     EQCTL                                                       INZSF
     C                   MOVE      *OFF          *IN84                                         INZSF
      *
     C******HIVAL********SETGT     X610LF                                       093531
     C     *end          setll     X610LF                                       093531
     C                   READP     X610LF                                 88
      *                                                                   INZSFL
     C                   ENDSR                                                                 INZSF
      /EJECT                                                              T02FMR
      *-------------------------------------------------------------------T02FMR
     C     BLDSFL        BEGSR                                                                 BLDSF
      *-------------------------------------------------------------------BLDSFL
      *                                                                   BLDSFL
      *S Build subfile pages when requested                               BLDSFL
      *                                                                   BLDSFL
      *-------------------------------------------------------------------BLDSFL
      *                                                                   BLDSFL
     C                   Z-ADD     LSTRRN        #RRNS
     C     #RRNS         ADD       SFLPAG        NXTRRN
      *
B001 C     *IN88         DOWEQ     *OFF                                                        BLDSF
     C     #RRNS         ANDLT     NXTRRN
      *
     C     X6PROC        IFNE      *BLANK
     C                   EXSR      FILTER
     C                   END
      *
     C     #RRNS         IFLE      NXTRRN
 001 C                   READP     X610LF                                 88    EOF            BLDSF
E001 C                   END                                                    *IN88 EQ *OFF  BLDSF
E001 C                   END                                                    *IN88 EQ *OFF  BLDSF
      *
     C                   Z-ADD     #RRNS         LSTRRN
     C                   Z-ADD     LSTRRN        PGNO
     C                   Z-ADD     LSTRRN        RRN
      *                                                                   BLDSFL
     C                   ENDSR                                                                 BLDSF
      /EJECT                                                              T02FMR
      *-------------------------------------------------------------------T02FMR
     C     FILTER        BEGSR                                                                 BLDSF
      *-------------------------------------------------------------------BLDSFL
      *                                                                   BLDSFL
      *S Filter database records according to selection criteria          BLDSFL
      *                                                                   BLDSFL
      *-------------------------------------------------------------------BLDSFL
      *                                                                   BLDSFL
     C                   MOVE      #TRUE         DBGY              1
     C                   MOVE      #TRUE         PRCY              1
     C     ZLDBGC        IFNE      *BLANK
     C     ZLDBGC        ANDNE     $PCHRO
     C     ZLDBGC        ANDNE     $PCHRM
     C                   MOVE      ZLDBGC        #I1               1 0
     C                   Z-ADD     X6DBGL        #J1               1 0
     C     #J1           IFGT      #I1
     C                   MOVE      #FALSE        DBGY
     C                   END
     C                   END
      *
     C     ZLPRCC        IFNE      *BLANK
     C     #PATNO        ANDNE     *ZERO
     C                   MOVEL     X6PROC        PROC1
      *
     C                   Z-ADD     1             STRPOS
      *
     C     1             DO        #PATNO        #OCUR             3 0
     C     #OCUR         OCCUR     DSPATT
      *
     C     #START        IFGT      STRPOS
     C                   Z-ADD     #START        STRPOS
     C                   END
      *
     C                   CALL      'QCLSCAN'
     C                   PARM                    DSRCD
     C                   PARM                    STRSIZ            3 0
     C                   PARM                    STRPOS            3 0
     C                   PARM                    #PATT
     C                   PARM                    PATLEN            3 0
     C                   PARM                    TRNSLT            1
     C                   PARM                    TRIM              1
     C                   PARM                    $PCHRO
     C                   PARM                    #FND              3 0
      *
     C     #FND          IFLE      0
     C     #FND          ORGT      #LIMIT
     C                   Z-ADD     #PATNO        #OCUR
     C                   Z-ADD     *ZERO         #FND
     C                   MOVE      #FALSE        PRCY
     C                   END
     C                   END
     C                   END
      *
     C     DBGY          IFEQ      #TRUE
     C     PRCY          ANDEQ     #TRUE
     C                   EXSR      MTOSFL
     C                   END
      *
     C                   ENDSR
      /EJECT                                                              T02FMR
      *COPY EQCPYSRC,PVPRCK
      /EJECT                                                              PVPRCK
      *-------------------------------------------------------------------PVPRCK
     C     PRECHK        BEGSR                                                                 PRECH
      *-------------------------------------------------------------------PRECHK
      *                                                                   PRECHK
      *S Check selection fields and create selection patterns             PRECHK
      *                                                                   PRECHK
      *-------------------------------------------------------------------PRECHK
      *                                                                   PRECHK
      *D  Each field of the selection is passed via DSZBA, and the field  PRECHK
      *D  length is passed via J3                                         PRECHK
      *                                                                   PRECHK
      *-------------------------------------------------------------------PRECHK
      *                                                                   PRECHK
      *  Reset work flag                                                  PRECHK
     C                   MOVE      #NO           #ALPHA            1                           PRECH
      *                                                                   PRECHK
      *  If this is the first field for the selection, initialise         PRECHK
      *  the number of patterns field and field offset in data structure  PRECHK
      *  DSRCD                                                            PRECHK
B001 C     #FFLD         IFEQ      #YES                                                        PRECH
 001 C                   Z-ADD     0             #PATNO            3 0                         PRECH
 001 C                   Z-ADD     1             OFFSET            3 0                         PRECH
 001 C                   MOVE      #NO           #FFLD             1                           PRECH
E001 C                   END                                                    #FFLD EQ #YES  PRECH
      *                                                                   PRECHK
      *  Loop through characters of field, replacing '*?' with '?*'       PRECHK
     C                   MOVE      #FALSE        #END              1                           PRECH
B001 C     #END          DOWEQ     #FALSE                                                      PRECH
 001 C                   Z-ADD     0             X3                                            PRECH
 001 C     #MS           SCAN      DSZBA         X3                3 0                         PRECH
B002 C     X3            IFGT      *ZERO                                                       PRECH
 002 C     X3            ANDLT     J3                                                          PRECH
 002 C                   MOVEA     #SM           ZBA(X3)                                       PRECH
X002 C                   ELSE                                                   Else           PRECH
 002 C                   MOVE      #TRUE         #END                                          PRECH
E002 C                   END                                                    X3 GT *ZERO    PRECH
E001 C                   END                                                    #END EQ #FALSE PRECH
      *                                                                   PRECHK
      *   Find first occurence of multiple prompt character $PCHRM        PRECHK
     C                   Z-ADD     1             K3                3 0                         PRECH
     C     $PCHRM        LOOKUP    ZBA(K3)                                80    Equal          PRECH
      *                                                                   PRECHK
      *   If prompt character not found, then set occurence to J3+1       PRECHK
B001 C     *IN80         IFEQ      #FALSE                                                      PRECH
 001 C     J3            ADD       1             K3                                            PRECH
E001 C                   END                                                    *IN80 EQ #FALSEPRECH
      *                                                                   PRECHK
      *  If there is a multiple prompt character, see if there are        PRECHK
      *  trailing blanks within the field length. If so, repeatedly       PRECHK
      *  shift data from K3 to K3+1 allowing prompt characters to         PRECHK
      *  remain within field until no trailing blanks remain.             PRECHK
      *    Example: four charatcer field set to '*A  '                    PRECHK
      *             This will expand to '**A ' and then to '***A'         PRECHK
      *             all three fields will cause the same records to       PRECHK
      *             be selected                                           PRECHK
B001 C     K3            IFLT      J3                                                          PRECH
 001 C     K3            ADD       1             I3                                            PRECH
B002 C     ZBA(J3)       DOWEQ     ' '                                                         PRECH
 002 C                   MOVEA     ZBA(K3)       #WORK           128                           PRECH
 002 C                   MOVEA     #WORK         ZBA(I3)                                       PRECH
E002 C                   END                                                    ZBA,J3 EQ ' '  PRECH
E001 C                   END                                                    K3 LT J3       PRECH
      *                                                                   PRECHK
      *  If there is a multiple prompt character, it is the first one.    PRECHK
      *  Now, find the last by setting I3 to J3 and reduce I3 until       PRECHK
      *  one is found. There will always be at least one, since K3        PRECHK
      *  is less than J3.                                                 PRECHK
     C     J3            ADD       1             I3                                            PRECH
B001 C     K3            IFLT      J3                                                          PRECH
 001 C                   Z-ADD     J3            I3                                            PRECH
      *                                                                   PRECHK
B002 C     ZBA(I3)       DOWNE     $PCHRM                                                      PRECH
 002 C                   SUB       1             I3                                            PRECH
E002 C                   END                                                    ZBA,I3 NE $PCHRPRECH
      *                                                                   PRECHK
      *  If the position of the last prompt character is not the same     PRECHK
      *  as the first, there must be more than one multiple prompt        PRECHK
      *  character                                                        PRECHK
B002 C     K3            IFLT      I3                                                          PRECH
      *                                                                   PRECHK
      *  Loop from the first prompt character to the last                 PRECHK
B003 C     K3            DO        I3            L3                                            PRECH
      *                                                                   PRECHK
      *  If there is a non-prompt chraracter between the two multiple     PRECHK
      *  prompt characters, then set work flag accordingly                PRECHK
B004 C     ZBA(L3)       IFNE      $PCHRO                                                      PRECH
 004 C     ZBA(L3)       ANDNE     $PCHRM                                                      PRECH
 004 C                   MOVE      #YES          #ALPHA                                        PRECH
 004 C                   Z-ADD     I3            L3                                            PRECH
E004 C                   END                                                    ZBA,L3 NE $PCHRPRECH
      *                                                                   PRECHK
E003 C                   END                                                    K3 DO I3       PRECH
E002 C                   END                                                    K3 LT I3       PRECH
E001 C                   END                                                    K3 LT J3       PRECH
      *                                                                   PRECHK
      *  If no non-prompt character found between the two multiple prompt PRECHK
      *  characters, then replacing all multiple prompt characters with   PRECHK
      *  single prompt characters will cause the same records to be       PRECHK
      *  selected ie 'A***' becomes 'A???'                                PRECHK
      *              'A**A' becomes 'A??A'                                PRECHK
      *              '**AA' becomes '??AA'                                PRECHK
B001 C     #ALPHA        IFEQ      #NO                                                         PRECH
      *                                                                   PRECHK
      *  Loop through all characters of field                             PRECHK
B002 C     1             DO        J3            I3                                            PRECH
      *                                                                   PRECHK
      *  If character is a multiple prompt character, then replace with   PRECHK
      *  a single prompt character                                        PRECHK
B003 C     ZBA(I3)       IFEQ      $PCHRM                                                      PRECH
 003 C                   MOVE      $PCHRO        ZBA(I3)                                       PRECH
E003 C                   END                                                    ZBA,I3 EQ $PCHRPRECH
E002 C                   END                                                    1 DO J3        PRECH
      *                                                                   PRECHK
      *  This selection field now becomes a single pattern, so set K3     PRECHK
      *  and I3 to indicate this                                          PRECHK
 001 C     J3            ADD       1             K3                                            PRECH
 001 C     J3            ADD       1             I3                                            PRECH
E001 C                   END                                                    #ALPHA EQ #NO  PRECH
      *                                                                   PRECHK
      *  Save selection field                                             PRECHK
     C                   MOVEL     DSZBA         #WORK                                         PRECH
      *                                                                   PRECHK
      *  K3 is the offset of the first multiple prompt character          PRECHK
      *  If K3 is greater than 1, store pattern up to K3-1                PRECHK
B001 C     K3            IFGT      1                                                           PRECH
 001 C     K3            SUB       1             #LOOP             3 0                         PRECH
      *                                                                   PRECHK
      *  Loop through characters up to K3-1                               PRECHK
B002 C     1             DO        #LOOP         X3                                            PRECH
      *                                                                   PRECHK
      *  Find first non-single-prompt character                           PRECHK
B003 C     ZBA(X3)       IFNE      $PCHRO                                                      PRECH
      *                                                                   PRECHK
      *  Increment number of patterns stored                              PRECHK
 003 C                   ADD       1             #PATNO                                        PRECH
      *                                                                   PRECHK
      *  Set occurence of data structure DSPATT accordingly               PRECHK
 003 C     #PATNO        OCCUR     DSPATT                                                      PRECH
      *                                                                   PRECHK
      *  Initialise DSPATT fileds                                         PRECHK
 003 C                   CLEAR                   DSPATT                                        PRECH
 003 C                   MOVE      #TRNS         TRNSLT                                        PRECH
      *                                                                   PRECHK
      *  Start position is current loop position - 1 + offset in DSRCD    PRECHK
      *  #START = OFFSET + X3 - 1                                         PRECHK
 003 C     OFFSET        ADD       X3            #START                                        PRECH
 003 C                   SUB       1             #START                                        PRECH
      *                                                                   PRECHK
      *  Clear array at first multiple prompt character                   PRECHK
 003 C                   MOVEA     *BLANKS       ZBA(K3)                                       PRECH
      *                                                                   PRECHK
      *  Move the pattern into the data structure                         PRECHK
 003 C                   MOVEA     ZBA(X3)       #PATT                                         PRECH
      *                                                                   PRECHK
      *  Reset selection field                                            PRECHK
 003 C                   MOVEL     #WORK         DSZBA                                         PRECH
      *                                                                   PRECHK
      *  Pattern length is the difference between the current position    PRECHK
      *  in the loop nad the position of the first multiple prompt        PRECHK
      *  character (PATLEN = K3 - X3)                                     PRECHK
 003 C     K3            SUB       X3            PATLEN                                        PRECH
      *                                                                   PRECHK
      *  The limiting position the pattern must be found in is the        PRECHK
      *  current position in the loop adjusted by the OFFSET within       PRECHK
      *  DSRCD. That is OFFSET + X3 - 1. However, this is equivalent      PRECHK
      *  to OFFSET + #LOOP - PATLEN                                       PRECHK
 003 C     OFFSET        ADD       #LOOP         #LIMIT                                        PRECH
 003 C                   SUB       PATLEN        #LIMIT                                        PRECH
      *                                                                   PRECHK
      *  Set X3 to #LOOP to escape the loop straight away                 PRECHK
 003 C                   Z-ADD     #LOOP         X3                                            PRECH
      *                                                                   PRECHK
      *  Note that if the characters up to the first multiple prompt      PRECHK
      *  characters are all single prompt characters, then nothing is     PRECHK
      *  actually stored (and quite right too)                            PRECHK
E003 C                   END                                                    ZBA,X3 NE $PCHRPRECH
E002 C                   END                                                    1 DO #LOOP     PRECH
      *                                                                   PRECHK
E001 C                   END                                                    K3 GT 1        PRECH
      *                                                                   PRECHK
      *  K3 is the offset of the first multiple prompt character          PRECHK
      *  If K3 is less than the length of the selection field, then       PRECHK
      *  there may be more patterns to store                              PRECHK
B001 C     K3            IFLT      J3                                                          PRECH
      *                                                                   PRECHK
      *  I3 is the offset of the last multiple prompt character           PRECHK
      *  If K3 is less than J3, this implies that I3 is set, and is       PRECHK
      *  greater than K3                                                  PRECHK
B002 C     K3            DO        I3            X3                                            PRECH
      *                                                                   PRECHK
      *  Find the first non-multiple-prompt character                     PRECHK
B003 C     ZBA(X3)       IFNE      $PCHRM                                                      PRECH
      *                                                                   PRECHK
      *  Increment number of patterns                                     PRECHK
 003 C                   ADD       1             #PATNO                                        PRECH
      *                                                                   PRECHK
      *  Set occurence of DSPATT accordingly                              PRECHK
 003 C     #PATNO        OCCUR     DSPATT                                                      PRECH
      *                                                                   PRECHK
      *  Initialise DSPATT fileds                                         PRECHK
 003 C                   CLEAR                   DSPATT                                        PRECH
 003 C                   MOVE      #TRNS         TRNSLT                                        PRECH
      *                                                                   PRECHK
      *  Start position is OFFSET in DSRCD + K3 - 1                       PRECHK
      *  #START = OFFSET + K3 - 1                                         PRECHK
 003 C     OFFSET        ADD       K3            #START                                        PRECH
 003 C                   SUB       1             #START                                        PRECH
      *                                                                   PRECHK
      *  Store current position in loop                                   PRECHK
 003 C                   Z-ADD     X3            #ST               3 0                         PRECH
      *                                                                   PRECHK
      *  Find next occurence of multiple prompt character                 PRECHK
 003 C     $PCHRM        LOOKUP    ZBA(X3)                                80    Equal          PRECH
      *                                                                   PRECHK
      *  Pattern length is difference between them                        PRECHK
 003 C     X3            SUB       #ST           PATLEN                                        PRECH
      *                                                                   PRECHK
      *  Limit for all 'middle' patterns is the difference between the    PRECHK
      *  selection field length and the patten length adjusted by the     PRECHK
      *  OFFSET in DSRCD                                                  PRECHK
 003 C     OFFSET        ADD       J3            #LIMIT                                        PRECH
 003 C                   SUB       PATLEN        #LIMIT                                        PRECH
      *                                                                   PRECHK
      *  Blank out array from next multiple prompt character onwards      PRECHK
 003 C                   MOVEA     *BLANKS       ZBA(X3)                                       PRECH
      *                                                                   PRECHK
      *  Store pattern starting at the offset stored previously           PRECHK
 003 C                   MOVEA     ZBA(#ST)      #PATT                                         PRECH
      *                                                                   PRECHK
      *  Reset selection field                                            PRECHK
 003 C                   MOVEL     #WORK         DSZBA                                         PRECH
      *                                                                   PRECHK
      *  Note X3 has been moved to the position of the next multiple      PRECHK
      *  prompt character to handle any more patterns that may exist      PRECHK
      *  before the last multiple prompt character                        PRECHK
E003 C                   END                                                    ZBA,X3 NE $PCHRPRECH
E002 C                   END                                                    K3 DO I3       PRECH
E001 C                   END                                                    K3 LT J3       PRECH
      *                                                                   PRECHK
      *  I3 is the position of the last multiple prompt character         PRECHK
      *  If I3 is less than J3 then store the pattern after I3            PRECHK
B001 C     I3            IFLT      J3                                                          PRECH
 001 C     I3            ADD       1             X3                3 0                         PRECH
      *                                                                   PRECHK
      *  Increment number of patterns                                     PRECHK
 001 C                   ADD       1             #PATNO                                        PRECH
      *                                                                   PRECHK
      *  Set occurence of data structure accordingly                      PRECHK
 001 C     #PATNO        OCCUR     DSPATT                                                      PRECH
      *                                                                   PRECHK
      *  Initialise data structure fields                                 PRECHK
 001 C                   CLEAR                   DSPATT                                        PRECH
 001 C                   MOVE      #TRNS         TRNSLT                                        PRECH
      *                                                                   PRECHK
      *  Start is the current position X3 (=I3+1) adjusted by the OFFSET  PRECHK
      *  in DSRCD                                                         PRECHK
 001 C     OFFSET        ADD       X3            #START                                        PRECH
 001 C                   SUB       1             #START                                        PRECH
      *                                                                   PRECHK
      *  Pattern length is the difference between the field length and    PRECHK
      *  the current position                                             PRECHK
 001 C     J3            SUB       I3            PATLEN                                        PRECH
      *                                                                   PRECHK
      *  The limit that this pattern could be found at is the current     PRECHK
      *  position adjusted by the offset                                  PRECHK
 001 C     OFFSET        ADD       J3            #LIMIT                                        PRECH
 001 C                   SUB       PATLEN        #LIMIT                                        PRECH
      *                                                                   PRECHK
      *  Store the pattern                                                PRECHK
 001 C                   MOVEA     ZBA(X3)       #PATT                                         PRECH
E001 C                   END                                                    I3 LT J3       PRECH
      *                                                                   PRECHK
      *  Increment the offset by the field length and reset the translate PRECHK
      *  into uppercase field                                             PRECHK
     C                   ADD       J3            OFFSET                                        PRECH
     C                   MOVE      #FALSE        #TRNS             1                           PRECH
      *                                                                   PRECHK
     C                   ENDSR                                                                 PRECH
      *-------------------------------------------------------------------T02FMR
     C     MTOSFL        BEGSR                                                                 BLDSF
      *-------------------------------------------------------------------BLDSFL
      *                                                                   BLDSFL
      *S Move database fields to subfile                                  BLDSFL
      *                                                                   BLDSFL
      *-------------------------------------------------------------------BLDSFL
      *                                                                   BLDSFL
     C                   ADD       1             #RRNS
     C                   MOVE      *BLANKS       ZLLINE
     C*******************Z-ADD     X6TIME        ZHTIME                         093531
                                                                                093531
      * The time data is written in a C routine, and the longest int that       093531
      *  seems to be available in iSeries C is 9 digits (4 bytes binary).       093531
      * 999,999,999 is 09 September 2001 01:46:39, hence all dates              093531
      * now need a 10 digit time.                                               093531
      * So a kludge is added here to offset all times by 1,000,000,000          093531
     C                   eval      TimeToConvert = X6TIME + 1000000000          093531
     C                   Z-ADD     X6DBGL        ZHDBGL
     C                   MOVE      ZHDBGL        #DBG              1
     C                   MOVE      X6PROC        ZHPROC
     C                   MOVEL     X6DATA        X6BUFF
     C                   MOVEL     X6BUFF        ZHDATA
      *
     C                   EXSR      CNVTIM
      *
     C                   MOVEL     ZLDATE        #DATE
     C                   MOVEL     ZLTIME        #TIM
      *
     C     #VIEW         IFEQ      1
     C                   MOVEL     ZHPROC        #PROC
     C                   MOVEL     ZHDATA        #MESS
     C                   ELSE
     C                   MOVEL     ZHDATA        #PROC
     C                   END
     C                   MOVEL     DSVIEW        ZLLINE
      *
     C                   WRITE     EQSFL
      *
     C                   ENDSR
      *
      /EJECT                                                              T02FMR
      *-------------------------------------------------------------------T02FMR
     C     CNVTIM        BEGSR                                                                 BLDSF
      *-------------------------------------------------------------------BLDSFL
      *                                                                   BLDSFL
      *S Convert X6TIME to date and time                                  BLDSFL
      *                                                                   BLDSFL
      *-------------------------------------------------------------------BLDSFL
      *                                                                   BLDSFL
     C                   CALL      'KMDTMI'
     C*******************PARM                    ZHTIME                         093531
     C                   PARM                    TimeToConvert                  093531
     C                   PARM                    DSDATE
      *
     C                   MOVEL     DAY           ZLDATE
     C                   MOVE      MON           ZLDATE
     C                   MOVE      #TIME         ZLTIME
      *
     C                   ENDSR
      *
      /EJECT                                                              T02FMR
      *-------------------------------------------------------------------T02FMR
     C     VIEW          BEGSR                                                                 BLDSF
      *-------------------------------------------------------------------BLDSFL
      *                                                                   BLDSFL
      *S Change view 1 to view 2 and vice versa                           BLDSFL
      *                                                                   BLDSFL
      *-------------------------------------------------------------------BLDSFL
      *                                                                   BLDSFL
     C     1             DO        LSTRRN        X                 5 0
     C     X             CHAIN     EQSFL                              99
     C     *IN99         IFEQ      *OFF
     C                   MOVE      *BLANK        ZLLINE
     C                   MOVE      *BLANK        DSVIEW
     C                   MOVEL     ZLDATE        #DATE
     C                   MOVEL     ZLTIME        #TIM
     C                   MOVE      ZHDBGL        #DBG
      *
     C     #VIEW         IFEQ      1
     C                   MOVEL     ZHPROC        #PROC
     C                   MOVEL     ZHDATA        #MESS
     C                   ELSE
     C                   MOVEL     ZHDATA        #PROC
     C                   END
     C                   MOVEL     DSVIEW        ZLLINE
      *
     C                   UPDATE    EQSFL
     C                   END
     C                   ENDDO
      *
     C                   ENDSR
      /EJECT                                                              T02FMR
      *-------------------------------------------------------------------USA01R
     C     USA01R        BEGSR                                                                 USA01
      *-------------------------------------------------------------------USA01R
      *                                                                   USA01R
      *S Store/Sort messages for sending to the input module              USA01R
      *                                                                   USA01R
      *  Kaprog - E3D                                                     USA01R
      *                                                                   USA01R
      *-------------------------------------------------------------------USA01R
      *                                                                   USA01R
      *  Retrieve message severity from message file                      USA01R
     C                   MOVE      @ERM          @MSGID                                        USA01
     C                   CALL      'KMDU2C'      PLMSG                                         USA01
      *                                                                   USA01R
      *  Set up input program name check                                  USA01R
B001 C     #PGM4         IFEQ      *BLANK                                                      USA01
 001 C                   MOVEL     @PGM          #PGM4             4                           USA01
E001 C                   END                                                    #PGM4 EQ *BLANKUSA01
      *                                                                   USA01R
      *  Store warning mesages if called for external input               USA01R
B001 C     #PGM4         IFEQ      'H56H'                                                      USA01
B002 C     @MSGSV        IFEQ      10                                                          USA01
 002 C     P3            ANDLT     6                                                           USA01
 002 C                   ADD       1             P3                                            USA01
 002 C                   MOVEL     DSEPMS        APW(P3)                                       USA01
E002 C                   END                                                    @MSGSV EQ 10   USA01
E001 C                   END                                                    #PGM4 EQ 'H56H'USA01
      *                                                                   USA01R
      *  If this warning message has already been overriden then          USA01R
      *  ignore as it does not need redisplaying - otherwise store it     USA01R
      *  if its to be the first one displayed                             USA01R
B001 C     @MSGSV        IFEQ      10                                                          USA01
 001 C                   MOVE      DSEPMS        $MSG                                          USA01
 001 C                   Z-ADD     T3            $I                                            USA01
 001 C                   MOVE      #SCRN         $SCRN                                         USA01
      *                                                                   USA01R
      *  Store all warning messages from this pass regardless             USA01R
B002 C     J3            IFLE      50                                                          USA01
 002 C                   MOVE      DSMSGI        AAW(J3)                                       USA01
 002 C                   ADD       1             J3                                            USA01
      *                                                                   USA01R
      *  Ignore warning if already overridden                             USA01R
 002 C                   MOVE      *OFF          *IN97                                         USA01
B003 C     P3            IFGT      0                                                           USA01
B004 C     1             DO        P3            I3                                            USA01
B005 C     DSMSGI        IFEQ      APW(I3)                                                     USA01
 005 C                   MOVE      *ON           *IN97                                         USA01
 005 C                   Z-ADD     P3            I3                                            USA01
E005 C                   END                                                    DSMSGI EQ APW,IUSA01
E004 C                   END                                                    1 DO P3        USA01
E003 C                   END                                                    P3 GT 0        USA01
 002 C     *IN97         CABEQ     *ON           USA01X                                        USA01
      *                                                                   USA01R
      *  Store first warning message for return to input module - this    USA01R
      *  will be the message overridden next pass if F24 pressed          USA01R
B003 C     @OWM          IFEQ      *BLANKS                                                     USA01
 003 C                   MOVE      DSMSGI        @OWM                                          USA01
E003 C                   END                                                    @OWM EQ *BLANK USA01
      *                                                                   USA01R
E002 C                   END                                                    J3 LE 50       USA01
E001 C                   END                                                    @MSGSV EQ 10   USA01
      *                                                                   USA01R
      *  Set the "message to display" flag                                USA01R
     C                   MOVE      #YES          #MSG                                          USA01
      *                                                                   USA01R
      *  If severity greater than any already found , reset severity      USA01R
      *  level , the message array and FIA as the messages stored so      USA01R
      *  far are now not relevant and must not be displayed               USA01R
B001 C     @MSGSV        IFGT      #MSGSV                                                      USA01
 001 C                   Z-ADD     @MSGSV        #MSGSV                                        USA01
 001 C                   EXSR      USA12R                                                      USA01
 001 C                   MOVEA     *ZEROS        FIA                                           USA01
 001 C                   MOVE      #YES          @CLRQ                                         USA01
      *                                                                   USA01R
      * Clear overridden warning messages if now dealing with errors      USA01R
B002 C     #MSGSV        IFEQ      20                                                          USA01
 002 C                   MOVE      *BLANKS       @OWM                                          USA01
E002 C                   END                                                    #MSGSV EQ 20   USA01
E001 C                   END                                                    @MSGSV GT #MSGSUSA01
      *                                                                   USA01R
      *  If message severity same as highest so far , store the message   USA01R
B001 C     @MSGSV        IFEQ      #MSGSV                                                      USA01
 001 C     S3            ANDLT     20                                                          USA01
 001 C                   ADD       1             S3                3 0                         USA01
 001 C                   MOVE      DSEPMS        @EM(S3)                                       USA01
B002 C     T3            IFGT      *ZERO                                                       USA01
 002 C     #MSGSV        ANDGT     *ZERO                                                       USA01
 002 C                   MOVE      #TRUE         FIA(T3)                                       USA01
E002 C                   END                                                    T3 GT *ZERO    USA01
E001 C                   END                                                    @MSGSV EQ #MSGSUSA01
      *                                                                   USA01R
      *  Send messages to the program message queue if twenty stored      USA01R
B001 C     S3            IFEQ      20                                                          USA01
 001 C                   EXSR      USA11R                                                      USA01
 001 C                   MOVE      #MSGSV        @SEV                                          USA01
E001 C                   END                                                    S3 EQ 20       USA01
      *                                                                   USA01R
      *  Tag jumped to when message is to be ignored                      USA01R
     C     USA01X        TAG                                                                   USA01
      *                                                                   USA01R
      *  Blank message data structure                                     USA01R
     C                   MOVE      *BLANKS       DSEPMS                                        USA01
      *                                                                   USA01R
     C                   ENDSR                                                                 USA01
      /EJECT                                                              T02FMR
      *-------------------------------------------------------------------USA04R
     C     USA04R        BEGSR                                                                 USA04
      *-------------------------------------------------------------------USA04R
      *                                                                   USA04R
      *S  Set message type flags for this program                         USA04R
      *                                                                   USA04R
      *                                                                   USA04R
      *-------------------------------------------------------------------USA04R
      *                                                                   USA04R
      *  Set the program message flags depending on the severity          USA04R
     C                   MOVE      #NO           #MSG                                          USA04
     C                   MOVE      #NO           #ERROR                                        USA04
     C                   MOVE      #NO           #WARN                                         USA04
     C                   MOVE      #NO           #INFO                                         USA04
      *                                                                   USA04R
      *  Error message                                                    USA04R
B001 C     @SEV          IFEQ      '20'                                                        USA04
 001 C                   MOVE      #YES          #MSG                                          USA04
 001 C                   MOVE      #YES          #ERROR                                        USA04
 001 C                   MOVE      #NO           #DSPLY                                        USA04
X001 C                   ELSE                                                   Else           USA04
      *  Warning message                                                  USA04R
B002 C     @SEV          IFEQ      '10'                                                        USA04
 002 C                   MOVE      #YES          #MSG                                          USA04
 002 C                   MOVE      #YES          #WARN                                         USA04
 002 C                   MOVE      #NO           #DSPLY                                        USA04
X002 C                   ELSE                                                   Else           USA04
      *  Information  message                                             USA04R
B003 C     @SEV          IFEQ      '00'                                                        USA04
 003 C                   MOVE      #YES          #MSG                                          USA04
 003 C                   MOVE      #YES          #INFO                                         USA04
E003 C                   END                                                    @SEV EQ '00'   USA04
E002 C                   END                                                    @SEV EQ '10'   USA04
E001 C                   END                                                    @SEV EQ '20'   USA04
      *                                                                   USA04R
     C                   ENDSR                                                                 USA04
      /EJECT                                                              T02FMR
      *-------------------------------------------------------------------USA06R
     C     USA06R        BEGSR                                                                 USA06
      *-------------------------------------------------------------------USA06R
      *                                                                   USA06R
      *S  Set the flashing asterisk fields for warnings                   USA06R
      *                                                                   USA06R
      *                                                                   USA06R
      *-------------------------------------------------------------------USA06R
      *                                                                   USA06R
      *  Initialise the asterisk array                                    USA06R
     C                   MOVEA     *BLANK        AST                                           USA06
      *                                                                   USA06R
      *  For each byte of FIA set to '1' , set up a corresponding         USA06R
      *  asterisk for display on the screen                               USA06R
B001 C     1             DO        50            I3                3 0                         USA06
      *                                                                   USA06R
B002 C     FIA(I3)       IFEQ      #TRUE                                                       USA06
 002 C                   MOVE      '*'           AST(I3)                                       USA06
E002 C                   END                                                    FIA,I2 EQ #TRUEUSA06
E001 C                   END                                                    1 DO 70        USA06
      *                                                                   USA06R
      *  Move the asterisk array into the screen field data structure     USA06R
     C                   MOVEA     AST           DSAST                                         USA06
      *                                                                   USA06R
     C                   ENDSR                                                                 USA06
      /EJECT                                                              T02FMR
      *-------------------------------------------------------------------USA11R
     C     USA11R        BEGSR                                                                 USA11
      *-------------------------------------------------------------------USA11R
      *                                                                   USA11R
      *S Send messages to the program message queue or recovery module    USA11R
      *                                                                   USA11R
      *                                                                   USA11R
      *-------------------------------------------------------------------USA11R
      *                                                                   USA11R
      *  Pass first error message back in parameter list                  USA11R
     C                   MOVE      @EM(1)        @MSG             37                           USA11
      *                                                                   USA11R
      *  Set number of messages                                           USA11R
     C                   Z-ADD     S3            S2
      *                                                                   USA11R
      *  Send all the stored messages to the program message queue        USA11R
     C                   CALL      'KMDU0C'      PLM14                                         USA11
      *                                                                   USA11R
      *  Clear the program message storage array, (@EM)                   USA11R
     C                   EXSR      USA12R                                                      USA11
      *                                                                   USA11R
     C                   ENDSR                                                                 USA11
      /EJECT                                                              T02FMR
      *-------------------------------------------------------------------USA12R
     C     USA12R        BEGSR                                                                 USA12
      *-------------------------------------------------------------------USA12R
      *                                                                   USA12R
      *S  Clear messages from the program message array                   USA12R
      *                                                                   USA12R
      *  Kaprog - E2A                                                     USA12R
      *                                                                   USA12R
      *-------------------------------------------------------------------USA12R
      *                                                                   USA12R
      *   Clear out message arrays and reset array counter                USA12R
     C                   MOVEA     *BLANKS       @EM                                           USA12
     C                   Z-ADD     0             S3                                            USA12
      *                                                                   USA12R
     C                   ENDSR                                                                 USA12
      /EJECT                                                              T02FMR
      *-------------------------------------------------------------------USA14R
     C     USA14R        BEGSR                                                                 USA14
      *-------------------------------------------------------------------USA14R
      *                                                                   USA14R
      *S Set up return parameters and messages for input module           USA14R
      *                                                                   USA14R
      *                                                                   USA14R
      *  Changed on 18/04/89 as not clearing warning messages already     USA14R
      *  overridden but no longer being generated - ANC                   USA14R
      *                                                                   USA14R
      *-------------------------------------------------------------------USA14R
      *                                                                   USA14R
      *  Any stored messages                                              USA14R
B001 C     P3            IFGT      0                                                           USA14
 001 C     @PRMPT        ANDEQ     #NO                                                         USA14
      *                                                                   USA14R
      *  Move screen number to a character field and set the "remove      USA14R
      *  blanks" flag to No.                                              USA14R
 001 C                   MOVE      #SCRN         #SCRNC            1                           USA14
 001 C                   MOVE      #NO           #RMVBL            1                           USA14
      *                                                                   USA14R
      *  Check all previously overriden warnings for this screen          USA14R
B002 C     1             DO        P3            I3                                            USA14
 002 C                   MOVE      APW(I3)       DSMSGI                                        USA14
      *                                                                   USA14R
      *  Message for current screen                                       USA14R
B003 C     $SCRN         IFEQ      #SCRNC                                                      USA14
      *                                                                   USA14R
      *  Warning message to be retained                                   USA14R
 003 C                   MOVE      *OFF          *IN97                                         USA14
B004 C     J3            IFGT      1                                                           USA14
B005 C     1             DO        J3            T3                                            USA14
B006 C     DSMSGI        IFEQ      AAW(T3)                                                     USA14
 006 C                   MOVE      *ON           *IN97                                         USA14
 006 C                   Z-ADD     J3            T3                                            USA14
E006 C                   END                                                    DSMSGI EQ AAW,TUSA14
E005 C                   END                                                    1 DO J3        USA14
E004 C                   END                                                    J3 GT 1        USA14
      *                                                                   USA14R
      *  Retain only those still being generated                          USA14R
B004 C     *IN97         IFEQ      #FALSE                                                      USA14
 004 C                   MOVE      *BLANKS       APW(I3)                                       USA14
 004 C                   MOVE      #YES          #RMVBL                                        USA14
E004 C                   END                                                    *IN97 EQ #FALSEUSA14
      *                                                                   USA14R
E003 C                   END                                                    $SCRN EQ #SCRNCUSA14
      *                                                                   USA14R
E002 C                   END                                                    1 DO P3        USA14
      *                                                                   USA14R
      *  Remove any blanks from the stored overriden warnings array       USA14R
      *  if the "remove blanks" flag has been set                         USA14R
B002 C     #RMVBL        IFEQ      #YES                                                        USA14
 002 C                   MOVEA     *BLANKS       AAW                                           USA14
 002 C                   Z-ADD     1             J3                                            USA14
      *                                                                   USA14R
B003 C     1             DO        P3            I3                                            USA14
 003 C                   MOVE      APW(I3)       DSMSGI                                        USA14
B004 C     DSMSGI        IFNE      *BLANKS                                                     USA14
 004 C                   MOVE      DSMSGI        AAW(J3)                                       USA14
 004 C                   ADD       1             J3                                            USA14
E004 C                   END                                                    DSMSGI NE *BLANUSA14
E003 C                   END                                                    1 DO P3        USA14
      *                                                                   USA14R
 002 C                   MOVEA     AAW           APW                                           USA14
 002 C     J3            SUB       1             P3                3 0                         USA14
      *                                                                   USA14R
E002 C                   END                                                    #RMVBL EQ #YES USA14
      *                                                                   USA14R
E001 C                   END                                                    P3 GT 0        USA14
      *                                                                   USA14R
      *  Send remaining messages to the program message queue             USA14R
B001 C     S3            IFGT      *ZERO                                                       USA14
 001 C                   EXSR      USA11R                                                      USA14
 001 C                   MOVE      #MSGSV        @SEV                                          USA14
E001 C                   END                                                    S3 GT *ZERO    USA14
      *                                                                   USA14R
     C                   ENDSR                                                                 USA14
      /EJECT                                                              T02FMR
      *-------------------------------------------------------------------USA49R
     C     USA49R        BEGSR                                                                 USA49
      *-------------------------------------------------------------------USA49R
      *                                                                   USA49R
      *  Validate function keys                                           USA49R
      *                                                                   USA49R
      *  Level - E2A                                                      USA49R
      *                                                                   USA49R
      *-------------------------------------------------------------------USA49R
      *-------------------------------------------------------------------T02FMR
      *                                                                   T02FMR
      *  Insert any "non standard" proccessing for standard function keys T02FMR
      *
      *  Changes views on the screen using F11
     C     *INKK         IFEQ      #TRUE
     C     #SCRN         ANDEQ     1
     C                   MOVE      '1'           #TAGNO
     C     #VIEW         IFEQ      1
     C                   Z-ADD     2             #VIEW
     C                   ELSE
     C                   Z-ADD     1             #VIEW
     C                   END
     C                   EXSR      VIEW
     C                   GOTO      USA49X
     C                   END
      *                                                                   USA49R
      *  Previous screen from screen 1                                    USA49R
B001 C     *INKL         IFEQ      *ON                                                         USA49
 001 C     #SCRN         ANDEQ     1                                                           USA49
 001 C                   MOVE      '12'          @CKEY                                         USA49
 001 C                   MOVE      '03'          #CMDKY                                        USA49
 001 C                   MOVE      '   '         @MNR                                          USA49
 001 C                   MOVE      '2'           #TAGNO                                        USA49
 001 C                   MOVE      #YES          #EOT                                          USA49
 001 C                   GOTO      USA49X                                                      USA49
E001 C                   END                                                    *INKL EQ *ON   USA49
      *                                                                   USA49R
      *  Previous screen from screen greater than 1                       USA49R
      *  NB. If previous screen is key screen cancel overriden warnings   USA49R
B001 C     *INKL         IFEQ      *ON                                                         USA49
 001 C     #SCRN         ANDGT     1                                                           USA49
 001 C                   MOVE      '12'          #CMDKY                                        USA49
 001 C                   SUB       1             #SCRN                                         USA49
 001 C                   MOVE      '1'           #TAGNO                                        USA49
 001 C                   GOTO      USA49X                                                      USA49
E001 C                   END                                                    *INKL EQ *ON   USA49
      *                                                                   T02FMR
      *-------------------------------------------------------------------T02FMR
      *-------------------------------------------------------------------USA49R
      *                                                                   USA49R
      *  Standard function key processing                                 USA49R
      *                                                                   USA49R
      *-------------------------------------------------------------------USA49R
      *                                                                   USA49R
      *  First user defined function key                                  USA49R
B001 C     *INKB         IFEQ      *ON                                                         USA49
 001 C     OID(1)        ANDNE     *BLANK                                                      USA49
 001 C                   MOVE      '02'          @CKEY                                         USA49
 001 C                   MOVE      '03'          #CMDKY                                        USA49
 001 C                   MOVE      OID(1)        @MNR                                          USA49
 001 C                   MOVE      '2'           #TAGNO                                        USA49
 001 C                   MOVE      #YES          #EOT                                          USA49
 001 C                   GOTO      USA49X                                                      USA49
E001 C                   END                                                    *INKB EQ *ON   USA49
      *                                                                   USA49R
      *  Exit immediately                                                 USA49R
B001 C     *INKC         IFEQ      *ON                                                         USA49
 001 C                   MOVE      '03'          @CKEY                                         USA49
 001 C                   MOVE      '03'          #CMDKY                                        USA49
 001 C                   MOVE      '   '         @MNR                                          USA49
 001 C                   MOVE      '2'           #TAGNO                                        USA49
 001 C                   MOVE      #YES          #EOT                                          USA49
 001 C                   GOTO      USA49X                                                      USA49
E001 C                   END                                                    *INKC EQ *ON   USA49
      *                                                                   USA49R
      *  Second user defined function key                                 USA49R
B001 C     *INKK         IFEQ      *ON                                                         USA49
 001 C     OID(2)        ANDNE     *BLANK                                                      USA49
 001 C                   MOVE      '11'          @CKEY                                         USA49
 001 C                   MOVE      '03'          #CMDKY                                        USA49
 001 C                   MOVE      OID(2)        @MNR                                          USA49
 001 C                   MOVE      '2'           #TAGNO                                        USA49
 001 C                   MOVE      #YES          #EOT                                          USA49
 001 C                   GOTO      USA49X                                                      USA49
E001 C                   END                                                    *INKK EQ *ON   USA49
      *                                                                   USA49R
      *  Previous screen from screen 1                                    USA49R
B001 C     *INKL         IFEQ      *ON                                                         USA49
 001 C     #SCRN         ANDEQ     1                                                           USA49
 001 C                   MOVE      '12'          @CKEY                                         USA49
 001 C                   MOVE      '03'          #CMDKY                                        USA49
 001 C                   MOVE      '   '         @MNR                                          USA49
 001 C                   MOVE      '2'           #TAGNO                                        USA49
 001 C                   MOVE      #YES          #EOT                                          USA49
 001 C                   GOTO      USA49X                                                      USA49
E001 C                   END                                                    *INKL EQ *ON   USA49
      *                                                                   USA49R
      *  Previous screen from screen greater than 1                       USA49R
      *  NB. If previous screen is key screen cancel overriden warnings   USA49R
B001 C     *INKL         IFEQ      *ON                                                         USA49
 001 C     #SCRN         ANDGT     1                                                           USA49
 001 C                   MOVE      '12'          #CMDKY                                        USA49
 001 C                   SUB       1             #SCRN                                         USA49
 001 C                   MOVE      ' '           #SPOVR            1                           USA49
 001 C                   MOVE      '1'           #TAGNO                                        USA49
B002 C     #SCRN         IFEQ      1                                                           USA49
 002 C                   MOVE      #YES          #EOT                                          USA49
 002 C                   MOVE      '2'           #TAGNO                                        USA49
E002 C                   END                                                    #SCRN EQ 1     USA49
 001 C                   GOTO      USA49X                                                      USA49
E001 C                   END                                                    *INKL EQ *ON   USA49
      *                                                                   USA49R
      *  Third user defined function key                                  USA49R
B001 C     *INKN         IFEQ      *ON                                                         USA49
 001 C     OID(3)        ANDNE     *BLANK                                                      USA49
 001 C                   MOVE      '14'          @CKEY                                         USA49
 001 C                   MOVE      '03'          #CMDKY                                        USA49
 001 C                   MOVE      OID(3)        @MNR                                          USA49
 001 C                   MOVE      '2'           #TAGNO                                        USA49
 001 C                   MOVE      #YES          #EOT                                          USA49
 001 C                   GOTO      USA49X                                                      USA49
E001 C                   END                                                    *INKN EQ *ON   USA49
      *                                                                   USA49R
      *  Fourth user defined function key                                 USA49R
B001 C     *INKX         IFEQ      *ON                                                         USA49
 001 C     OID(4)        ANDNE     *BLANK                                                      USA49
 001 C                   MOVE      '23'          @CKEY                                         USA49
 001 C                   MOVE      '03'          #CMDKY                                        USA49
 001 C                   MOVE      OID(4)        @MNR                                          USA49
 001 C                   MOVE      '2'           #TAGNO                                        USA49
 001 C                   MOVE      #YES          #EOT                                          USA49
 001 C                   GOTO      USA49X                                                      USA49
E001 C                   END                                                    *INKX EQ *ON   USA49
      *                                                                   USA49R
      *  Override first warning message                                   USA49R
B001 C     *INKY         IFEQ      *ON                                                         USA49
 001 C     #WARN         ANDEQ     #YES                                                        USA49
 001 C                   MOVE      '24'          #CMDKY                                        USA49
 001 C                   GOTO      USA49X                                                      USA49
E001 C                   END                                                    *INKY EQ *ON   USA49
      *-------------------------------------------------------------------T02FMR
      *                                                                   T02FMR
      *  Insert any processing for non standard function keys here        T02FMR
      *                                                                   T02FMR
      *  Page up
     C     *IN91         IFEQ      #TRUE
     C     #SCRN         ANDEQ     1
     C                   MOVE      '1'           #TAGNO
     C                   EXSR      BLDSFL
     C                   GOTO      USA49X
     C                   END
      *
      *-------------------------------------------------------------------T02FMR
      *-------------------------------------------------------------------USA49R
      *                                                                   USA49R
      *   Catch all invalid function keys                                 USA49R
      *                                                                   USA49R
      *                                                                   USA49R
      *-------------------------------------------------------------------USA49R
      *                                                                   USA49R
      *   Store "Invalid function key" in message array                   USA49R
     C                   MOVE      'KCM0807'     @ERM                                          USA49
     C                   EXSR      USA01R                                                      USA49
     C                   MOVE      '1'           #TAGNO                                        USA49
     C                   MOVE      #YES          #INVCK            1                           USA49
      *                                                                   USA49R
     C     USA49X        ENDSR                                                                 USA49
      /EJECT                                                              T02FMR
      *-------------------------------------------------------------------T02FMR
     C     *INZSR        BEGSR                                                                 *INZS
      *-------------------------------------------------------------------*INZSR
      *                                                                   *INZSR
      *S Program initialisation                                           *INZSR
      *                                                                   *INZSR
      *-------------------------------------------------------------------*INZSR
      *                                                                   *INZSR
      *  Set up KAPROG program name                                       *INZSR
     C                   MOVEL     @PGMID        KAPPG7                                        *INZS
      *                                                                   *INZSR
      *  Set up multilanguage screen header text                          *INZSR
     C                   MOVEL     $OVRD         $OVR             14                           *INZS
      *                                                                   *INZSR
      *  Set the skip flag (this is set to 'NO' in subroutine A200 if not *INZSR
      *  all the key fields are defaulted from the input data string,     *INZSR
      *  context data area predefined default data)                       *INZSR
      *                                                                   *INZSR
      *  Set up name of the program message queue for use by the          *INZSR
      *  input , validation and update modules in this application        *INZSR
     C                   MOVEL     @PGMID        @PGM                                          *INZS
     C                   MOVEL     @PGMID        FLDPGM                                        *INZS
     C                   MOVE      *BLANKS       @MNR              3                           *INZS
     C                   MOVE      *BLANKS       @CKEY             2                           *INZS
      *                                                                   *INZSR
      *  Define work fields                                               *INZSR
     C     *LIKE         DEFINE    RRN           #RRNS                                         *INZS
     C     *LIKE         DEFINE    RRN           LSTRRN                                        *INZS
     C     *LIKE         DEFINE    RRN           NXTRRN                                        *INZS
     C                   Z-ADD     1             #VIEW             1 0
     C     *LIKE         DEFINE    ZLDBGC        #DBGC
     C     *LIKE         DEFINE    ZLPRCC        #PRCC
     C     *LIKE         DEFINE    I3            L3
     C     *LIKE         DEFINE    I3            K2
     C     *LIKE         DEFINE    I3            FLDSIZ
     C                   MOVE      '?'           $PCHRO            1
     C                   MOVE      '*'           $PCHRM            1
     C                   MOVE      $PCHRO        #MS               2
     C                   MOVEL     $PCHRM        #MS
     C                   MOVE      $PCHRO        #SM               2
     C                   MOVEL     $PCHRM        #SM
     C                   Z-ADD     19            STRSIZ
      *                                                                   *INZSR
     C                   ENDSR                                                                 *INZS
      /EJECT                                                              T02FMR
      *-------------------------------------------------------------------PSSR_A
     C     *PSSR         BEGSR                                                                 *PSSR
      *-------------------------------------------------------------------*PSSR
      *                                                                   *PSSR
      *S Program error handling subroutine                                *PSSR
      *                                                                   *PSSR
      *-------------------------------------------------------------------*PSSR
      *D  This subroutine takes control if a program or file error occurs.*PSSR
      *D  1. It initiates a dump of all program variables to the output   *PSSR
      *D     queue associated with the current job.                       *PSSR
      *D  2. It sends a message to the unit status queue KAPSTATUS        *PSSR
      *D     recording that the program has ended in error.               *PSSR
      *D  3. It cancels the program. In doing so, it notifies the         *PSSR
      *D     calling module that this program terminated abnormally.      *PSSR
      *D                                                                  *PSSR
      *D  NB. This subroutine is coded to prevent it executing any code   *PSSR
      *D      if it should call itself (ie an error occurs whilst         *PSSR
      *D      executing this subroutine) this would cause an infinite     *PSSR
      *D      loop, which must be avoided.                                *PSSR
      *                                                                   *PSSR
      *                                                                   *PSSR
      *-------------------------------------------------------------------*PSSR
      *                                                                   *PSSR
      *  If the first time through perform dump processing                *PSSR
B001 C     #PGERR        IFNE      'Y'                                                         *PSSR
      *                                                                   *PSSR
      *  Set the "dump already called once" flag to prevent it calling    *PSSR
      *  itself again                                                     *PSSR
 001 C                   MOVE      'Y'           #PGERR            1                           *PSSR
      *                                                                   *PSSR
      *  If the $DMPID field has not been set up, default it to @PGMID    *PSSR
B002 C     $DMPID        IFEQ      *BLANK                                                      *PSSR
 002 C                   MOVEL     @PGMID        $DMPID                                        *PSSR
E002 C                   END                                                    $DMPID EQ *BLAN*PSSR
      *                                                                   *PSSR
      *  Perform dump of all program variable values                      *PSSR
 001 C                   DUMP                                                                  *PSSR
      *                                                                   *PSSR
      *  Set up message to send to KAPSTATUS and send it                  *PSSR
 001 C     $PSPGM        CAT       $DMPID:1      #PSBRK           52                           *PSSR
 001 C     #PSBRK        CAT       $PSEIE:1      #PSBRK                                        *PSSR
 001 C     #PSBRK        CAT       $PSDPT:1      #PSBRK                                        *PSSR
 001 C     #PSBRK        DSPLY     $PSSTS                               99      Error          *PSSR
      *                                                                   *PSSR
E001 C                   END                                                    #PGERR NE 'Y'  *PSSR
      *                                                                   *PSSR
      *  Cancel program to signify abnormal termination has occured,      *PSSR
      *  this statement ensures the program and its files are closed      *PSSR
     C                   ENDSR     '*CANCL'                                                    *PSSR
      /EJECT                                                              T02FMR
      *                                                                   T02FMR
      *-------------------------------------------------------------------T02FMR
      * COMPILE TIME ARRAY DATA                                           T02FMR
      *-------------------------------------------------------------------T02FMR
      *                                                                   T02FMR
**
0123456789
