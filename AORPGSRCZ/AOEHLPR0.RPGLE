     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas Calling GAR49R   Help Access Object')
      *****************************************************************
      *                                                               *
      *  Midas - Access Obbject Module                                *
      *                                                               *
      *  AOEHLPR0 - Consumer Banking Help Access Object               *
      *                                                               *
      *  Function:  This program retrieves the call stack information *
      *             and calls a program that returns the menu item    *
      *             being used                                        *
      *                                                               *
      *  Called By: SCHELPR - Help Processing                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. BUG14435           Date 06Aug07               *
      *  Prev Amend No. CRE026  *CREATE    Date 24May06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG14435 - The system displayed details on Maintain          *
      *             Sundry Items instead of the functionality         *
      *             of Inward Clearing Cheque                         *
      *  CRE026 - Consumer Banking                                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    98         Date Format                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
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
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
 
      ** External Data structure to hold the outgoing record format
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
     D/COPY QSYSINC/QRPGLESRC,QWVRCSTK
      ** Format of Call Stack file Header and Records
     D/COPY QSYSINC/QRPGLESRC,QWCATTR
      ** Format of Job Description Information
 
      ** Error Data Structure for the Open File Call
     D   ERRC0100      DS
     D    BYTESPROV            1      4B 0 INZ(144)
     D    BYTESAVAIL           5      8B 0 INZ(0)
     D    EXCEPID              9     15A   INZ(*BLANKS)
     D    RESVD2              16     16A   INZ(*BLANKS)
     D    EXCEPTION           17    144A   INZ(*BLANKS)
 
     D Entry           DS           256
     D  QWVEL01                      10I 0
     D  PgmNam                       10    Overlay(Entry:25)
     D  PgmLib                       10    Overlay(Entry:35)
     D Holding         DS           256
     D  QWVEL02                      10I 0
     D  TempPgmNam                   10    Overlay(Holding:25)
     D  TempPgmLib                   10    Overlay(Holding:35)
 
     D @DSINCRM        DS           128
     D @INCREMENTAL                   1
     D @RETURNUIINFO                  1
     D @RESUME                        1
     D @RESETCONTEXT                  1
     D @ENTRYEVENT                    2
     D @FORMAT                       10
     D @EVENTCOUNT                    2
     D @PVROOT                        5
     D @PVDECODE                      1
     D @PVFIELD                      10
 
     D @DSCNTRL        DS           128
     D @AUDITUSRID                   10
     D @ENTRYOPTID                    3
     D @ENTRYROOT                     4
     D @ENTRYPROGRAM                 10
     D @INPUTREF                     16
     D @APIMODE                       1
     D @TRANTYPE                      1
     D @RETURNJRNKEY                  1
     D @RETURNEVENTKY                 1
     D @RETURNBEFIMG                  1
     D @RETURNINPUT                   1
     D @RETURNOUTPUT                  1
     D @FORMATOUTPUT                  1
     D @USEBEFOREIMG                  1
     D @DFLTCHARGES                   1
     D @AUTOOVERRIDE                  1
     D @SUPERUSRID                   10
     D @ENCRYPTION                    1
     D @SUPERCOMMENT                 30
     D @APIAEXT                       1
     D @APIAREC                       1
     D @CCSTART                       1
     D @CCEND                         1
     D @CALLSTATUS                    1
     D @RETURNSTATUS                  4
 
     D @DSPV           DS            11
     D  @PVBEGIN                      1
     D  @PVREQCOUNT                   5
     D  @PVRETCOUNT                   5
 
     D @DSSUPER        DS            64
     D @SUPERUSRPWD                  64
 
     D DSEPMS          DS
     D  @ERM                   1      7
     D  @PM1                   8     17
     D  @PM2                  18     27
     D  @PM3                  28     37
     D  @PMALL                 8     37
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
 
     D PRetCode        S              7A
     D POption         S              7A
     D KeyInfo         S            200A
     D HelpTag         S            600A
 
     D ReceiverVar     S           9999
     D ReceiverLen     S              4B 0 INZ(%size(ReceiverVar))
     D ReceiverFmt     S              8
     D JobIDVar        S             56
     D JobIDFmt        S              8
     D ErrorCode       S              8
     D ReturnC7        S              7
     D RtnCode         S              7
     D Option          S              7
     D Type            S              1
     D ShortCode       S             10A
     D RootName        S              4A
     D RecNam          S              4A
     D Count           S             10  0 INZ(1)
 
     D @PRMPT          S              1
     D @CCN            S            128
     D @NUM            S             15  0
     D @NEW            S              1
     D @DECOD          S              1
     D @BLANK          S              1
     D @ERMSG          S             37
     D @LRIND          S              1
     D @CKEY           S              2
     D @PVFILTER       S            256
     D @PVLIST         S           9999
     D @PVSELECTION    S            256
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      ** Need to get the program for which the help is required
 
      *
      ** Set up the default variables for the call to the API
      *
 
     C                   Eval      ReceiverFmt = 'CSTK0100'
     C                   Eval      QWCJN02     = %SubSt(KeyInfo:17:10)
     C                   Eval      QWCJNBR00   = %SubSt(KeyInfo:1:6)
     C                   Eval      QWCUN       = %SubSt(KeyInfo:7:10)
     C                   Eval      JobIDFmt    = 'JIDF0100'
     C                   Eval      QWCERVED06  = X'0000'
     C                   Eval      QWCTI00     = 2
     C                   Eval      QWCTI01     = X'0000000000000000'
 
     C                   CALL      'QWVRCSTK'
     C                   PARM                    ReceiverVar
     C                   PARM                    ReceiverLen
     C                   PARM                    ReceiverFmt
     C                   PARM                    QWCF0100
     C                   PARM                    JobIDFmt
     C     ERRC0100      PARM                    ERRC0100
 
     C                   IF        BYTESAVAIL <> 0
     C                   MOVEL     'QWVRCSTK'    DBFile
     C                   MOVEL     '001'         DBase
     C                   MOVEL     Option        DBKey
     C                   EXSR      *PSSR
     C                   EndIf
      *
      ** Put the returned variable into the header record and retrieve the length of each record
      *
     C                   Eval      QWVK0100 = ReceiverVar
     C                   Eval      Entry = %subst(ReceiverVar:QWVEO + 1)
     C                   Eval      RootName = %SubSt(KeyInfo:27:4)
      *
      ** Loop until you find the first record which contains the first 4 characters of the open
      ** display file. In Consumer Banking this should be a the screen handler program.  It
      ** should then fall out of the loop
      *
     C                   DoW       (Count <= QWVERTN) and
     C                             (RootName <> RecNam)
     C                   Eval      Entry = %subst(ReceiverVar:QWVEO + 1)
     C                   Eval      RecNam      = %SubSt(PgmNam:1:4)
     C                   Eval      QWVCSTKE = %subst(ReceiverVar:QWVEO + 1)
     C                   Eval      QWVEO = QWVEO + QWVEL01
     C                   eval      count = count+1
     C                   Enddo
      *
      ** It should now loop until the last record is found and that should be the calling Pgm
      *
     C                   DoW       (Count <= QWVERTN) and
     C                             (RootName = RecNam)
     C                   Eval      Entry = Holding
     C                   Eval      Holding = %subst(ReceiverVar:QWVEO + 1)
     C                   Eval      RecNam      = %SubSt(TempPgmNam:1:4)
     C                   Eval      QWVCSTKE = %subst(ReceiverVar:QWVEO + 1)
     C                   Eval      QWVEO = QWVEO + QWVEL02
     C                   eval      count = count+1
     C                   Enddo
      *
      ** If it still has not reached the end of the call stack, retrieve the menu option for the
      ** program
      *
     C                   If        count <= QWVERTN
      *
      ** Initialise the long set of parameters
      *
     C                   eval      @prmpt  = 'N'
      *                                                                                     BUG14435
     C                   If        RootName = 'H15A' and RecNam = 'K30A'                    BUG14435
     C                   eval      @ccn    = TempPgmNam                                     BUG14435
     C                   else                                                               BUG14435
     C                   eval      @ccn    = PgmNam
     C                   endif                                                              BUG14435
     C                   eval      @num    = *zero
     C                   eval      @new    = 'N'
     C                   eval      @decod  = ' '
     C                   eval      @blank  = 'N'
     C                   eval      @ermsg  = *blanks
     C                   eval      @lrind  = 'N'
     C                   eval      @ckey   = *blanks
     C                   clear                   @DSCNTRL
     C                   clear                   @DSSUPER
     C                   clear                   @DSINCRM
     C                   clear                   @DSPV
     C                   clear                   @PVFILTER
     C                   clear                   @PVLIST
     C                   clear                   @PVSELECTION
      *
     C                   call      'GAR49R'      PLPMOD                 99
      *
     C                   EndIf
 
     C                   Eval      HelpTag = %subst(@CCN:42:3)
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *Entry        PLIST
      *
      ** Inputs
      *
     C                   Parm                    PRetCode
     C                   Parm                    POption
     C                   Parm                    KeyInfo
     C                   Parm                    HelpTag
     C                   Parm                    DSSDY
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
      *  @PRMPT - Prompt or validate mode (prompt=Y, validate=N)
      *  @CCN   - Communication array - data in & out of program
      *  @NUM   - Used to return numeric values
      *  @NEW   - Validate for new or existing records (new=Y)
      *  @DECOD - Decode type
      *  @BLANK - Is blank value permitted (yes=Y)
      *  @ERMSG - Return error message number & parmameters
      *  @LRIND - Last record indicator to be set (yes=Y)
      *  @CKEY  - Command key utilised from prompt screen
      *  @DSCNTRL      - API Control Fields
      *  @DSSUPER      - API Supervisor Data
      *  @DSINCRM      - API Incremental Mode Control Fields
      *  @DSPV         - PV Control Fields
      *  @PVFILTER     - PV Filter Data
      *  @PVLIST       - Array of PV row data
      *  @PVSELECTION  - PV Selected Item
      *
     C     PLPMOD        PLIST
     C                   PARM                    @PRMPT
     C                   PARM                    @CCN
     C                   PARM                    @NUM
     C                   PARM                    @NEW
     C                   PARM                    @DECOD
     C                   PARM                    @BLANK
     C     DSEPMS        PARM      DSEPMS        @ERMSG
     C                   PARM                    @LRIND
     C                   PARM                    @CKEY
     C                   PARM                    @DSCNTRL
     C                   PARM                    @DSSUPER
     C                   PARM                    @DSINCRM
     C                   PARM                    @DSPV
     C                   PARM                    @PVFILTER
     C                   PARM                    @PVLIST
     C                   PARM                    @PVSELECTION
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
