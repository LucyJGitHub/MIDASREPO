      /TITLE X09FMR - Set up unit/server cross references                 X09FMR
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
      *****************************************************************
      *                                                               *
      *  Meridian Replication                                         *
      *                                                               *
      *  X09FMR - Set up unit/server cross references                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. MD058809           Date 16Dec21               *
      *  Prev Amend No. 000876 Bugzilla    Date 18Apr06               *
      *                 CRP017             Date 19Jul02               *
      *                 182870    *CREATE  Date 19Sep00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058809 - After installation of MQ9 compatibility patch and *
      *             restart of the Meridian Replication subsystem     *
      *             REPMIDASPT, the job MPT1PBSIN ended in MSGW.      *
      *  000876 - Remove reference to KAPSTATUS to make errors visible*
      *  CRP017 - Suppress display of save file CRTOBJ.               *
      *  182870 - Remove call to nonexistent program KMDUCC.          *
      *                                                               *
      *****************************************************************
      *-------------------------------------------------------------------X09FMR
      *              System Name - EQUATION                               X09FMR
      *              Module Name - Trade Innovation                       X09FMR
      *                                                                   X09FMR
      *             Program Name - X09FMR                                 X09FMR
      *            Program Title - Instal release to TI subsystem         X09FMR
      *                                                                   X09FMR
      *                                                                   X09FMR
      *            Creation Date - 15 September 1997                      X09FMR
      *      Last Amendment Date -                                        X09FMR
      *-------------------------------------------------------------------X09FMR
      *P Purpose                                                          X09FMR
      *P ~~~~~~~                                                          X09FMR
      *P To pick a software release for installation to TI subsystem      X09FMR
      *P Note: This function can be used from outside the input system.   X09FMR
      *P                                                                  X09FMR
      *-------------------------------------------------------------------X09FMR
      *H Change Control                                                   X09FMR
      *H ~~~~~~~~~~~~~~                                                   X09FMR
      *H Project     Programmer    Date         Level                     X09FMR
      *H ~~~~~~~     ~~~~~~~~~~    ~~~~         ~~~~~                     X09FMR
      *H XXXXXXX     XXXXXXXXXX    DDMMMYY      XXX                       X09FMR
      *H                                                                  X09FMR
      *H  X-------------------------------------------------------------X X09FMR
      *H  X-------------------------------------------------------------X X09FMR
      *-------------------------------------------------------------------------
      /EJECT                                                              X09FMR
      *COPY EQCPYSRC,HSPEC                       Program header specificatX09FMR
      *                                                                   HSPEC
      *  Program header specification                                     HSPEC
     H DEBUG DECEDIT('.') DFTNAME(HSPEC) DATEDIT(*DMY/)
      *                                                                   X09FMR
      *-------------------------------------------------------------------X09FMR
      *  FILES                                                            X09FMR
      *-------------------------------------------------------------------X09FMR
      *                                                                   X09FMR
      *  X09FMD  - Set Up Server/Unit Cross Reference Display file        X09FMR
     FX09FMD    CF   E             WORKSTN INFSR(*PSSR)                         X09FMR
     F                                     USROPN
     F                                     SFILE(X09FMDA:#RRNS)                 X09FMR
      *  Ignore screen format containing hidden fields                    X09FMR
     F                                     IGNORE(X09FMDZ)                      X09FMR
      *  DSPOBJD output (all files in TIDBA library)
     FQADSPOBJ  IF   E             DISK    USROPN
      *  X3PF - Unit details.
     FX3PF      UF   E             DISK    USROPN
      *                                                                   X09FMR
      *-------------------------------------------------------------------X09FMR
      *  ARRAYS                                                           X09FMR
      *-------------------------------------------------------------------X09FMR
      *                                                                   X09FMR
      *  Compile time arrays                                              X09FMR
      *                                                                   X09FMR
      *                                                                   X09FMR
      *  Execution time arrays                                            X09FMR
      *                                                                   X09FMR
      *COPY EQCPYSRC,ARAOW                       Array of overidden warninX09FMR
      *                                                                   ARAOW
      * Array to store six overidden warning messages for journal         ARAOW
     D AOW             S             37    DIM(6)                                                ARA
      *COPY EQCPYSRC,ARASTR                      Array of warning asteriskX09FMR
      *                                                                   ARAST
      *  Array of warning asterisks for the screen                        ARAST
     D AST             S              1    DIM(50)                                               ARA
      *COPY EQCPYSRC,ARFIAR                      Array of screen indicatorX09FMR
      *                                                                   ARFIA
      *  Array of screen fields with error or warning                     ARFIA
     D FIA             S              1    DIM(50)                                               ARF
      *COPY EQCPYSRC,AROID                       Array for user defined coX09FMR
      *                                                                   AROID
      *  Arrays for user defined command key options and text             AROID
     D OID             S              3    DIM(4)                                                ARO
     D OCT             S             11    DIM(4)                                                ARO
      *COPY EQCPYSRC,AR@EM                       Array of up to 20 msgs toX09FMR
      *                                                                   AR@EM
      *  Error messages array                                             AR@EM
     D @EM             S             37    DIM(20)                                               AR@
      *COPY EQCPYSRC,ARAPWR                      Array to track overriden X09FMR
      *                                                                   ARAPW
      *  Array of warning messages overriden so far                       ARAPW
     D APW             S             40    DIM(50)                                               ARA
      *                                                                   ARAPW
      *  Array of warning messages from this validation pass              ARAPW
     D AAW             S             40    DIM(50)                                               ARA
      /EJECT                                                              X09FMR
      *                                                                   X09FMR
      *-------------------------------------------------------------------X09FMR
      *  DATA AREAS                                                       X09FMR
      *-------------------------------------------------------------------X09FMR
      *                                                                   X09FMR
      *                                                                   X09FMR
      *-------------------------------------------------------------------X09FMR
      *  DATA STRUCTURES                                                  X09FMR
      *-------------------------------------------------------------------X09FMR
      *                                                                   X09FMR
      *COPY EQCPYSRC,DPGMDS                      Data structure for prograX09FMR
      *                                                                   DPGMDS
      *  DPGMDS - Program Status Data Structure                           DPGMDS
      *                                                                   DPGMDS
      *  Kaprog - 1A0                                                     DPGMDS
      *                                                                   DPGMDS
     D DPGMDS         SDS                                                       DPGMDS
     D  @PGMID           *PROC                                                  DPGMDS
     D  $PGMST           *STATUS                                                DPGMDS
      *COPY EQCPYSRC,DMSGDS_A                    DS for dump message      X09FMR
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
      *                                                                   X09FMR
      *COPY EQCPYSRC,DSEPMS                      Data structure for messagX09FMR
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
      *COPY EQCPYSRC,DSUDCT_A                    Data structure for user dX09FMR
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
      *COPY EQCPYSRC,DSMSGIR                     Data structure for messagX09FMR
      *                                                                   DSMSGI
      *  Message and indicator combination for tracking warnings          DSMSGI
     D DSMSGI          DS                                                       DSMSGI
     D  $MSG                   1     37                                         DSMSGI
     D  $I                    38     39  0                                      DSMSGI
     D  $SCRN                 40     40                                         DSMSGI
      *                                                                   X09FMR
      *  DSAST  - Data structure for screen asterisk fields - must be     X09FMR
      *           defined by programmer as required by each application   X09FMR
      *           Note - ASTnn must be positioned from nn to nn           X09FMR
     D DSAST           DS                                                       X09FMR
     D  AST01                  1      1                                         X09FMR
     D  AST02                  2      2                                         X09FMR
     D  AST03                  3      3                                         X09FMR
     D  AST04                  4      4                                         X09FMR
     D  ASX09                  5      5                                         X09FMR
      *                                                                   X09FMR
      *-------------------------------------------------------------------X09FMR
      *  PRE-INITIALISED DATA STRUCTURES                                  X09FMR
      *-------------------------------------------------------------------X09FMR
      *                                                                   X09FMR
      *  KAPROG data structure                                            X09FMR
     D KAPROG          DS                                                       X09FMR
     D  XXXXXX                 1      6    INZ('XXXXXX')                        X09FMR
     D  KAPLVL                 8     10    INZ('E3A')                           X09FMR
     D  KAPPGM                12     17                                         X09FMR
     D  KAPPG7                12     18                                         X09FMR
      *                                                                   X09FMR
      *-------------------------------------------------------------------X09FMR
      *  NAMED CONSTANTS                                                  X09FMR
      *-------------------------------------------------------------------X09FMR
      *                                                                   X09FMR
      *COPY EQCPYSRC,STDCNST                     Standard program constantX09FMR
      *                                                                   STDCNS
      * Define standard program constants                                 STDCNS
      *                                                                   STDCNS
     D #YES            C                   CONST('Y')                           STDCNS
     D #NO             C                   CONST('N')                           STDCNS
     D #FALSE          C                   CONST('0')                           STDCNS
     D #TRUE           C                   CONST('1')                           STDCNS
     D #DIGIT          C                   CONST('0123456789')                  STDCNS
      *                                                                   X09FMR
      * Set up maximum number of screens                                  X09FMR
     D #SCNO           C                   CONST(1)                             X09FMR
      *                                                                   X09FMR
     D MN              C                   CONST('mnemonic')                    X09FMR
     D $OVRD           C                   CONST('F24=Override')
     D $MENT           C                   CONST('ENTRY')
     D $MMNT           C                   CONST('MAINT')
      *                                                                   X09FMR
      *-------------------------------------------------------------------X09FMR
      *  PARAMETER AND KEY LISTS                                          X09FMR
      *-------------------------------------------------------------------X09FMR
      *                                                                   X09FMR
      *  Parameter lists                                                  X09FMR
      *                                                                   X09FMR
      *COPY EQCPYSRC,PLM14                       Plist for sending messageX09FMR
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
      *COPY EQCPYSRC,PLMSG                       Plist for calling messageX09FMR
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
      *                                                                   X09FMR
      *  Key lists                                                        X09FMR
      *                                                                   MAIN
      *  *None                                                            MAIN
      *                                                                   MAIN
      /EJECT                                                              MAIN
      *===================================================================MAIN
      *  INITIAL PROCESSING                                               MAIN
      *===================================================================MAIN
      *                                                                   MAIN
     C     *ENTRY        PLIST
     C     ZLSBS         PARM                    @SBS             10
      *  Open display file                                                MAIN
B001 C     #OPEN         IFNE      #YES                                                        MAIN
 001 C                   OPEN      X09FMD                                                      MAIN
 001 C                   OPEN      QADSPOBJ                                                    MAIN
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
     C                   MOVEL     $MENT         ZLMODE                                        A000
      *                                                                   A000
      *  Set new transaction flag (passed to validation module)           A000
     C                   MOVE      #YES          #BLD              1                           A000
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
     C                   MOVEA     *BLANKS       AOW                                           A000
     C                   MOVEA     *BLANKS       AST                                           A000
      *                                                                   A000
      *  Only display key screen if not enough fields have been provided  A000
B001 C     #SKIP         IFEQ      #NO                                                         A000
 001 C                   EXSR      Z200                                                        A000
E001 C                   END                                                    #SKIP EQ #NO   A000
      *                                                                   A000
     C                   ENDSR                                                                 A000
      /EJECT                                                              X09FMR
      *-------------------------------------------------------------------X09FMR
     C     A100          BEGSR                                                                 A100
      *-------------------------------------------------------------------A100
      *                                                                   A100
      *S Clear screen fields                                              A100
      *                                                                   A100
      *-------------------------------------------------------------------A100
      *                                                                   A100
      *  Initialise screen fields for a new transaction                   A100
     C*                    MOVE *BLANKS   ZLSBS                           A100
      *                                                                   A100
     C                   ENDSR                                                                 A100
      /EJECT                                                              X09FMR
      *-------------------------------------------------------------------X09FMR
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
 001 C                   ADD       1             #SCRN                                         B000
X001 C                   ELSE                                                   Else           B000
      *                                                                   B000
      *  Otherwise must be last screen and no messages to display so      B000
      *  if screen has changed call the update module.  If screen has     B000
      *  not been changed simply redisplay the key screen                 B000
 001 C                   EXSR      B300                                                        B000
      *                                                                   B000
      *  If no update messages to display set the "end of transaction"    B000
      *  flag, as update completed successfully, and drop out of this     B000
      *  subroutine . Otherwise redisplay screen with messages            B000
B002 C     #UPMSG        IFEQ      #NO                                                         B000
 002 C                   MOVE      #YES          #EOT                                          B000
E002 C                   END                                                    #UPMSG EQ #NO  B000
E001 C                   END                                                    #SCRN LT #SCNO B000
      *                                                                   B000
      *  Write a screen                                                   B000
     C     B00010        TAG                                                                   B000
B001 C     #EOT          IFEQ      #NO                                                         B000
 001 C                   EXSR      Z200                                                        B000
E001 C                   END                                                    #EOT EQ #NO    B000
      *                                                                   B000
     C     B000XT        ENDSR                                                                 B000
      /EJECT                                                              X09FMR
      *-------------------------------------------------------------------X09FMR
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
 001 C                   READ      X09FMDB                                99    EOF            B100
      *                                                                   B100
E001 C                   ENDSL                                                  SELEC          B100
      *                                                                   B100
     C     *IN99         CASEQ     *ON           *PSSR                                         B100
     C                   END                                                    Case End       B100
      *                                                                   B100
     C                   ENDSR                                                                 B100
      /EJECT                                                              X09FMR
      *-------------------------------------------------------------------X09FMR
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
     C                   MOVE      #NO           #BLD                                          B200
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
      *                                                                   B200
      *  Check that susbsytem exists                                      B200
B001 C     ZLSBS         IFNE      *BLANK                                                      B300
 001 C                   CALL      'KMDSRC'                                                    B300
 001 C                   PARM                    ZLSBS                                         B300
 001 C                   PARM                    @REL             10                           B300
     C                   PARM                    @FLAG             1
B002 C     @FLAG         IFNE      'Y'                                                         B300
     C                   MOVEL     ZLSBS         @PM1
     C     @FLAG         IFEQ      'N'
      *                Subsystem not found
     C                   MOVEL     'KCM3856'     @ERM
     C                   ELSE
      *                Subsystem damaged
     C                   MOVEL     'KCM3857'     @ERM
     C                   END
     C                   Z-ADD     1             T3
     C                   EXSR      USA01R
E002 C                   END                                                    *IN99 EQ *ON   B300
E001 C                   END                                                    ZLDSM NE *BLANKB300
      *                                                                   B200
      *  Validate subfile                                                 B200
B002 C     #RRNS         IFGT      0                                                           B200
 002 C                   READC     X09FMDA                                98    EOF            B200
B003 C     *IN98         DOWEQ     *OFF                                                        B200
B004 C     ZLSEL         IFNE      *BLANK                                                      B200
 004 C                   MOVE      *ON           *IN76                                         B200
B005 C     ZLSEL         IFNE      '1'                                                         B200
 005 C                   MOVE      *ON           *IN51                                         B200
 005 C                   MOVE      'KCM2042'     @ERM                                          B200
 005 C                   MOVEL(P)  ZLSEL         @PM1                                          B200
 005 C                   MOVEL(P)  '1'           @PM2                                          B200
 005 C                   Z-ADD     0             T3                                            B200
 005 C                   EXSR      USA01R                                                      B200
B006 C     #RRNS         IFLT      RRN                                                         B200
 006 C                   Z-ADD     #RRNS         RRN                                           B200
E006 C                   END                                                    #RRNS LT RRN   B200
E005 C                   END                                                    ZLSEL NE 'D'   B200
 004 C                   UPDATE    X09FMDA                                                     B200
 004 C                   MOVE      *OFF          *IN51                                         B200
 004 C                   MOVE      *OFF          *IN76                                         B200
E004 C                   END                                                    ZLSEL NE *BLANKB200
 003 C                   READC     X09FMDA                                98    EOF            B200
E003 C                   END                                                    *IN98 EQ *OFF  B200
E002 C                   END                                                    #RRNS GT 0     B200
      *                                                                   B200
E001 C                   ENDSL                                                  SELEC          B200
      *                                                                   B200
     C                   EXSR      USA14R                                                      B200
      *                                                                   B200
      *  Set message flags from validation parameters                     B200
     C                   EXSR      USA04R                                                      B200
      *                                                                   B200
     C                   ENDSR                                                                 B200
      /EJECT                                                              X09FMR
      *-------------------------------------------------------------------X09FMR
     C     B300          BEGSR                                                                 B300
      *-------------------------------------------------------------------B300
      *                                                                   B300
      *S Call the update module and check for errors returned             B300
      *                                                                   B300
      *-------------------------------------------------------------------B300
      *                                                                   B300
      *                                                                   B300
     C                   MOVE      '  '          @SEV                                          B300
     C                   Z-ADD     0             #MSGSV                                        B300
     C                   Z-ADD     0             S3                                            B300
     C                   Z-ADD     0             T3                                            B300
      *                                                                   B300
      *                                                                   B300
     C     #RRNS         IFGT      0
     C     ZLSBS         ANDNE     *BLANKS
     C     @FLAG         ANDEQ     'Y'
     C                   READC     X09FMDA                                99    EOF            B300
B001 C     *IN99         DOWEQ     *OFF                                                        B300
B002 C     ZLSEL         IFEQ      '1'                                                         B300
     C                   CALL      'KMDISC'
     C                   PARM                    ZLSBS
     C                   PARM                    ZMREL
      *
      * Unhook any units which dont have necessary interface software
      *
     C                   OPEN      X3PF
     C                   READ      X3PFR                                  91
     C                   MOVE      #NO           #UPMSG
     C     *IN91         DOUEQ     *ON
     C     X3SBS         IFEQ      ZLSBS
      *                                                                   182870
      * Fix 182870: the following program does not exist (and never has); 182870
      * this code should never be executed anyway, but for safety, the    182870
      * call has been removed, and for simplicity the return code set     182870
      * suitably.                                                         182870
     C***********          CALL 'KMDUCC'                                  182870
     C***********          PARM           X3UMN                           182870
     C***********          PARM           @REL                            182870
     C***********          PARM           @FLAG                           182870
      *                                                                   182870
      * Force "no update needed" processing                               182870
     C                   MOVE      'Y'           @FLAG                                         18287
      *                                                                   182870
     C     @FLAG         IFNE      'Y'
      *  Unit needs upgrading - detach it from unit
     C                   MOVE      *BLANKS       X3SBS
     C                   UPDATE    X3PFR
     C     #UPMSG        IFEQ      #NO
     C                   MOVE      #YES          #UPMSG
     C                   MOVEL     ZLSBS         @PM1
     C                   MOVEL     'KCM3861'     @ERM
     C                   Z-ADD     1             T3
     C                   EXSR      USA01R
     C                   END
     C                   MOVEL     X3UMN         @PM1
     C                   MOVEL     ZLSBS         @PM2
     C                   MOVEL     'KCM3860'     @ERM
     C                   Z-ADD     1             T3
     C                   EXSR      USA01R
     C                   END
     C                   END
     C                   READ      X3PFR                                  91
     C                   END
     C                   CLOSE     X3PF
E002 C                   END                                                    ZLSEL EQ 'D'   B300
      *                                                                   B300
 001 C                   READC     X09FMDA                                99    EOF            B300
E001 C                   END                                                    *IN99 EQ *OFF  B300
E001 C                   END                                                    *IN99 EQ *OFF  B300
      *                                                                   B300
     C                   ENDSR                                                                 B300
      /EJECT                                                              X09FMR
      *-------------------------------------------------------------------X09FMR
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
 002 C                   CLOSE     X09FMD                                                      C000
 002 C                   CLOSE     QADSPOBJ                                                    C000
 002 C                   MOVE      #NO           #OPEN                                         C000
E002 C                   END                                                    #OPEN EQ #YES  C000
 001 C                   SETON                                        LR                       C000
 001 C                   RETURN                                                                C000
E001 C                   END                                                    #CMDKY EQ '03' C000
      *                                                                   C000
     C                   ENDSR                                                                 C000
      /EJECT                                                              X09FMR
      *-------------------------------------------------------------------X09FMR
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
      /EJECT                                                              X09FMR
      *-------------------------------------------------------------------X09FMR
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
      *  Function specific indicators                                     Z210
B001 C     #BLD          IFEQ      #YES                                                        Z210
 001 C                   EXSR      INZSFL                                                      Z210
 001 C                   EXSR      BLDSFL                                                      Z210
E001 C                   END                                                    #BLD EQ #YES   Z210
      *                                                                   Z210
      *  Display appropriate detail screen                                Z210
S001 C                   SELECT                                                                Z210
      *                                                                   Z210
W001 C     #SCRN         WHENEQ    1                                                           Z210
 001 C                   MOVE      *ON           *IN85                                         Z210
B002 C     #RRNS         IFGT      0                                                           Z210
 002 C                   MOVE      *ON           *IN86                                         Z210
E002 C                   END                                                    #RRNS GT 0     Z210
 001 C                   WRITE     X09FMDB                                                     Z210
      *                                                                   Z210
E001 C                   ENDSL                                                  SELEC          Z210
      *                                                                   Z210
     C                   ENDSR                                                                 Z210
      /EJECT                                                              X09FMR
      *-------------------------------------------------------------------X09FMR
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
      /EJECT                                                              X09FMR
      *-------------------------------------------------------------------X09FMR
     C     Z230          BEGSR                                                                 Z230
      *-------------------------------------------------------------------Z230
      *                                                                   Z230
      *S Perform additional processing per screen                         Z230
      *                                                                   Z230
      *-------------------------------------------------------------------Z230
      *                                                                   Z230
      *                                                                   Z230
     C                   ENDSR                                                                 Z230
      /EJECT                                                              X09FMR
      *-------------------------------------------------------------------X09FMR
     C     INZSFL        BEGSR                                                                 INZSF
      *-------------------------------------------------------------------INZSFL
      *                                                                   INZSFL
      *S Initialise the subfile                                           INZSFL
      *                                                                   INZSFL
      *-------------------------------------------------------------------INZSFL
      *                                                                   INZSFL
      *  Reset record numbers                                             INZSFL
     C                   Z-ADD     0             #RRNS                                         INZSF
     C                   Z-ADD     1             RRN                                           INZSF
      *                                                                   INZSFL
      *  Clear the subfile                                                INZSFL
     C                   MOVE      *OFF          *IN85                                         INZSF
     C                   MOVE      *OFF          *IN86                                         INZSF
     C                   MOVE      *OFF          *IN73                                         INZSF
     C                   MOVE      *ON           *IN84                                         INZSF
     C                   WRITE     X09FMDB                                                     INZSF
     C                   MOVE      *OFF          *IN84                                         INZSF
      *                                                                   INZSFL
     C                   ENDSR                                                                 INZSF
      /EJECT                                                              X09FMR
      *-------------------------------------------------------------------X09FMR
     C     BLDSFL        BEGSR                                                                 BLDSF
      *-------------------------------------------------------------------BLDSFL
      *                                                                   BLDSFL
      *S Build subfile pages when requested                               BLDSFL
      *                                                                   BLDSFL
      *-------------------------------------------------------------------BLDSFL
      *                                                                   BLDSFL
     C                   MOVE      *OFF          *IN76                                         BLDSF
     C     1             SETLL     QADSPOBJ                                                    BLDSF
     C                   READ      QADSPOBJ                               88    EOF            BLDSF
B001 C     *IN88         DOWEQ     *OFF                                                        BLDSF
     C     ODOBAT        IFEQ      'SAVF'
     C     ODOBNM        ANDNE     'CRTOBJ'                                     CRP017
 001 C                   ADD       1             #RRNS                                         BLDSF
 001 C                   MOVE      *BLANKS       ZLSEL                                         BLDSF
 001 C                   MOVE      ODOBNM        ZMREL                                         BLDSF
 001 C                   WRITE     X09FMDA                                                     BLDSF
     C                   END
 001 C                   READ      QADSPOBJ                               88    EOF            BLDSF
E001 C                   END                                                    *IN88 EQ *OFF  BLDSF
      *                                                                   BLDSFL
     C                   ENDSR                                                                 BLDSF
      /EJECT                                                              X09FMR
      *COPY EQCPYSRC,USA01RR                     Store messages for returnX09FMR
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
 002 C                   MOVEA     *BLANKS       AOW                                           USA01
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
      /EJECT                                                              X09FMR
      *COPY EQCPYSRC,USA04R                      Set error/warning/info meX09FMR
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
      /EJECT                                                              X09FMR
      *COPY EQCPYSRC,USA06RR                     Set up warning asterisks X09FMR
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
      /EJECT                                                              X09FMR
      *COPY EQCPYSRC,USA10R_A                    Store messages for sendinX09FMR
      *-------------------------------------------------------------------USA10R
     C     USA10R        BEGSR                                                                 USA10
      *-------------------------------------------------------------------USA10R
      *                                                                   USA10R
      *S Store up to twenty messages for sending to the program queue     USA10R
      *                                                                   USA10R
      *   Kaprog - 1A0                                                    USA10R
      *                                                                   USA10R
      *-------------------------------------------------------------------USA10R
      *                                                                   USA10R
      *  Retrieve message severity from message file                      USA10R
     C                   MOVE      @ERM          @MSGID                                        USA10
     C                   MOVE      @PMALL        @MSGDA                                        USA10
     C                   CALL      'KMDU2C'      PLMSG                                         USA10
      *                                                                   USA10R
      *  If severity higher than previously, clear stored messages        USA10R
B001 C     @MSGSV        IFGT      #MSGSV                                                      USA10
 001 C                   EXSR      USA12R                                                      USA10
E001 C                   END                                                    @MSGSV GT #MSGSUSA10
      *                                                                   USA10R
      *  If severity greater than or equal to highest severity so far     USA10R
      *  then add message to array                                        USA10R
B001 C     @MSGSV        IFGE      #MSGSV                                                      USA10
 001 C     S3            ANDLT     20                                                          USA10
 001 C                   ADD       1             S3                                            USA10
 001 C                   MOVE      DSEPMS        @EM(S3)                                       USA10
E001 C                   END                                                    @MSGSV GE #MSGSUSA10
      *                                                                   USA10R
      *  If severity higher than any previous message or this is the      USA10R
      *  first message in this pass, then store the message severity      USA10R
B001 C     @MSGSV        IFGT      #MSGSV                                                      USA10
 001 C     S3            OREQ      1                                                           USA10
 001 C                   Z-ADD     @MSGSV        #MSGSV            2 0                         USA10
 001 C                   MOVE      @MSGSV        @SEV                                          USA10
 001 C                   EXSR      USA04R                                                      USA10
E001 C                   END                                                    @MSGSV GT #MSGSUSA10
      *                                                                   USA10R
      *   Blank out the message data structure                            USA10R
     C                   MOVE      *BLANK        DSEPMS                                        USA10
      *                                                                   USA10R
     C                   ENDSR                                                                 USA10
      /EJECT                                                              X09FMR
      *COPY EQCPYSRC,USA11R_B                    Message sending subroutinX09FMR
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
      /EJECT                                                              X09FMR
      *COPY EQCPYSRC,USA12R_A                    Clear messages from storaX09FMR
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
      /EJECT                                                              X09FMR
      *COPY EQCPYSRC,USA14RR                     Set up return parms and mX09FMR
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
      *  Return a maximum of six overriden warnings for the journal       USA14R
B002 C     1             DO        6             I3                                            USA14
 002 C                   MOVEL     APW(I3)       AOW(I3)                                       USA14
E002 C                   END                                                    1 DO 6         USA14
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
      /EJECT                                                              X09FMR
      *COPY EQCPYSRC,USA49R_BEG                  Validate function keys - X09FMR
      *-------------------------------------------------------------------USA49R
     C     USA49R        BEGSR                                                                 USA49
      *-------------------------------------------------------------------USA49R
      *                                                                   USA49R
      *  Validate function keys                                           USA49R
      *                                                                   USA49R
      *  Level - E2A                                                      USA49R
      *                                                                   USA49R
      *-------------------------------------------------------------------USA49R
      *-------------------------------------------------------------------X09FMR
      *                                                                   X09FMR
      *  Insert any "non standard" proccessing for standard function keys X09FMR
      *                                                                   X09FMR
      *-------------------------------------------------------------------X09FMR
      *COPY EQCPYSRC,USA49R_STN                  Standard function key proX09FMR
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
      *-------------------------------------------------------------------X09FMR
      *                                                                   X09FMR
      *  Insert any processing for non standard function keys here        X09FMR
      *                                                                   X09FMR
      *-------------------------------------------------------------------X09FMR
      *COPY EQCPYSRC,USA49R_END                  Invalid function key catcX09FMR
      *-------------------------------------------------------------------USA49R
      *                                                                   USA49R
      *   Catch all invalid function keys                                 USA49R
      *                                                                   USA49R
      *                                                                   USA49R
      *-------------------------------------------------------------------USA49R
      *                                                                   USA49R
      *   Store "Invalid function key" in message array                   USA49R
     C                   MOVE      'KSM0807'     @ERM                                          USA49
     C                   EXSR      USA10R                                                      USA49
     C                   MOVE      '1'           #TAGNO                                        USA49
     C                   MOVE      #YES          #INVCK            1                           USA49
      *                                                                   USA49R
     C     USA49X        ENDSR                                                                 USA49
      /EJECT                                                              X09FMR
      *-------------------------------------------------------------------X09FMR
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
     C                   MOVEL     $MENT         ZLMODE                                        *INZS
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
      *                                                                   *INZSR
     C                   ENDSR                                                                 *INZS
      /EJECT                                                              X09FMR
      *COPY EQCPYSRC,PSSR_A                      Program error control subX09FMR
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
      /EJECT                                                              X09FMR
      *                                                                   X09FMR
      *-------------------------------------------------------------------X09FMR
      * COMPILE TIME ARRAY DATA                                           X09FMR
      *-------------------------------------------------------------------X09FMR
      *                                                                   X09FMR
