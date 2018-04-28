      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate OPOPCO IBLC Operation code')         *
      *****************************************************************
      *                                                               *
      *  Midas - IBLC 2002 Module                                     *
      *                                                               *
      *  FTVOPOPCO2 - Validate IBLC Operation code                    *
      *                                                               *
      *  Function:  This module receives parameters containing an     *
      *             IBLC Operation code and confirm wether it is a    *
      *             valid IBLC Operation code type or not             *
      *             If it is valid the 10A return code will be blank, *
      *             if it is not it will contain 'Error'              *
      *                                                               *
      *  Component of:  SP6FT0009 - Core Luxembourg service program   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      *  Last Amend No. CFT120             Date 28Sep12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CER001             Date 25Apr05               *
      *                 ULX043             Date 22Aug01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  ULX043 - IBLC 2002 Reporting                                 *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FILICDRPD  IF   E             DISK
      ***  IBLC 2002 ICD modules                                  Prefix BG
      *
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
     D/COPY ZACPYSRC,PROCPARMS
 
      ** The following /COPY line includes the definitions for error &
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      **
      **   Named constants
      **   ===============
      **
 
      **
      **   Arrays and Data Structures
      **   ==========================
      **
 
      ** Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** DS for Access progrmas
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Input array
     D WND             S              5    DIM(28) CTDATA PERRCD(7)
     D OPT             S              1    DIM(28) ALT(WND)
 
      **
      **   Declared variables
      **   ==================
      **
 
      ** Define *entry parameters
     D #LLXOPCO        S              3A
     D #LLXORTY        S              2A
     D #LLXBETY        S              2A
     D SMCY            S              3A
     D SMAM            S             13P 0
     D @@SETT          S              1A
     D @@BOAF          S              1A
 
      ** Define parameters for call pgm
     D @CODE           S              3A
     D @CUST           S              6A
     D @TCCY           S              3A
     D @CPGM           S             10A
     D @DBID           S              1A
     D @ERID           S              1A
     D @CLIM           S             15P 0
     D @ILIM           S             15P 0
     D @LREG           S             15P 0
 
      ** Define parameters for call module
     D ZALIGNok        S              1A
     D ZFIELD          S             16A
     D ZADEC           S              1P 0
     D ZADIG           S              2P 0
 
     D ZAMTF           s             15P 0
     D ZCCYF           s              3
     D ZCCYT           s              3
     D ZRATEF          s             13P 8
     D ZRATET          s             13P 8
     D ZMDINF          s              1
     D ZMDINT          s              1
     D ZCDPF           s              1P 0
     D ZCDPT           s              1P 0
     D ZAMTT           s             15P 0
     D ZCRSRT          s             13P 8
     D ZCRSMD          s              1A
 
      ** Define working DS
     D                 DS
     D  TWND                   1      5
     D  WWTRAN                 1      2
     D  WWORDE                 3      3
     D  WWBENE                 4      4
     D  WWSETT                 5      5
 
      ** Define working fields
     D  @CCY           S              3A
     D  W              S              2P 0
     D  WWOPTI         S              1    INZ(*OFF)
     D  WWMAND         S              1    INZ(*OFF)
     D  WWBET2         S              1A
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *                M A I N  P R O C E S S I N G                   *
      *                                                               *
      *****************************************************************
      *
      ***
      ***  Initial processing is performed automatically: the *INZSR is
      ***  executed at program activation.
      ***
      *
      ***  Reset the error flag to prevent problems on subsequent calls
      *
     C                   RESET                   ErrorFound
      *
      ***  Validate field
      *
      ***  Is the ordering custoner type resident ?
      *
     C                   MOVE      #LLXORTY      WWORDE
     C     WWORDE        IFNE      'R'
     C                   MOVE      'O'           WWORDE
     C                   ENDIF
      *
      ***  Is the Beneficiary customer type resident ?
      *
     C                   MOVE      #LLXBETY      WWBENE
     C     WWBENE        IFNE      'R'
     C                   MOVE      'O'           WWBENE
     C                   ENDIF
      *
      ***  Verify mode of management
      *
     C                   MOVE      *OFF          WWMAND            1            Mandatory ind.
     C                   MOVE      *OFF          WWOPTI            1            Optional ind.
      *
      ***  Retrieve limit of Registration
      ***  Call validation program IL0410 without Operation Code
      *
      ****  Synoptic program will removed unnecessary items
     C                   MOVE      '*NBANK'      PLIMT             6            Default
      *
     C**** @@BOAF        IFEQ      'Y'                                          Bank Own Account
     C****               MOVE      '*BANK'       PLIMT
     C****               ENDIF
      *
     C                   CALL      'IL0410'
     C                   PARM      *BLANKS       @CODE
     C                   PARM                    PLIMT
     C                   PARM      SMCY          PTCCY             3
     C                   PARM      'FTVOPOPCO2'  PCPGM            10
      *
      ***  Result parameters
      *
     C                   PARM      '0'           @ERID
     C                   PARM      '0'           @DBID
     C                   PARM      *ZEROS        @CLIM
     C                   PARM      *ZEROS        @ILIM
     C                   PARM      ICLIMR        @LREG                          Limit of Registrat.
      *
      ***  If Limit of Registration is reached, then validate window Management
      *
      ***  For Now, Synoptic program will remove unecessary items
     C**** SMAM          IFGE      @LREG                                        Settlement Amount >=
      *                                                                         Limit of Regsitrat.
     C                   Z-ADD     1             W
     C     TWND          LOOKUP    WND(W)                                 99
     C     *IN99         IFEQ      *ON                                          Found
     C     OPT(W)        IFEQ      'O'                                          Operation code
     C                   MOVE      *ON           WWOPTI                          - is optional
     C                   ELSE
     C                   MOVE      *ON           WWMAND                          - is mandatory
     C                   ENDIF
     C                   ENDIF                                                   - not allowed
     C****               ENDIF
      *
      ***  Default the IBLC Code if this one is allowed
      *
     C     WWMAND        IFEQ      *ON
     C     WWOPTI        ANDEQ     *OFF
     C     #LLXOPCO      ANDEQ     *BLANKS                                      and Blanks
      *
      ***  Default with code 071
      *
     C                   MOVE      '071'         #LLXOPCO
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'IL04514'     #MSGID
     C                   GOTO      #ERROR
     C                   ENDIF
      *
     C     '?'           SCAN      #LLXOPCO      RESULT            1 0    90
     C     *IN90         IFEQ      *ON
     C                   CALL      'IL0400'
     C                   PARM      #LLXOPCO      WWOPCO            3
     C                   PARM      *BLANK        WWSELE            1
     C                   PARM      *BLANK        WWRETR            1
      *
     C     WWSELE        IFEQ      '1'
     C                   MOVE      WWOPCO        #LLXOPCO
     C                   ENDIF
      *
     C                   ENDIF
      *
      ***  Operation code couldn't be blank if mandatory,
      ***                 must be blank if not allowed,
      ***  if it is allowed, normal validation
      *
      ***  Validation for *blank
      *
      ***  Validation for not *blanks
      *
     C     #LLXOPCO      IFNE      *BLANK
     C     WWMAND        IFEQ      *OFF
     C     WWOPTI        ANDEQ     *OFF
      *
      ***  'Not Required. left blank'
      *
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'IL04503'     #MSGID
     C                   MOVE      *BLANKS       #LLXOPCO
     C                   GOTO      #ERROR
     C                   ENDIF
      *
      ***  Continue validation if entered when it's possible
      *
     C                   MOVE      *OFF          *IN99
     C                   TESTN                   #LLXOPCO             99
     C     *IN99         IFNE      *ON
      *
      ***  'Must be 3 digits field '
      *
     C                   MOVEL     'IL04504'     #MSGID
     C                   ELSE
      *
     C                   MOVE(P)   #LLXOPCO      ZFIELD
     C                   Z-ADD     3             ZADIG
     C                   Z-ADD     0             ZADEC
      *
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
      *
      ***  Input is not valid
      *
     C     ZALIGNok      IFEQ      'N'
     C                   MOVEL     'IL04503'     #MSGID
     C                   ELSE
     C                   MOVE      ZFIELD        #LLXOPCO
     C                   ENDIF
      *
     C                   ENDIF
      *
      ***  If errors detected, bypass any further validation
      *
     C     #MSGID        IFNE      *BLANKS
     C                   EVAL      ErrorFound = 'Y'
     C                   GOTO      #ERROR
     C                   ENDIF
      *
      ***  Check if exist
      *
     C                   MOVE      #LLXOPCO      @CODE
      *
      ***  Call validation program
      *
      ****  Synoptic program will removed unnecessary items
     C                   MOVE      '*BANK '      PLIMT                          Default
     C                   CALL      'IL0410'
      * Input
     C                   PARM                    @CODE                          Op. code
     C                   PARM                    @CUST                          Customer number
     C                   PARM      SMCY          @TCCY                          Tr. currency
     C                   PARM      'FTVOPOPCO2'  @CPGM                          Calling pgm
      * Output
     C                   PARM      '0'           @ERID                          Error ind.
     C                   PARM      '0'           @DBID                          DB error ind.
     C                   PARM      *ZEROS        @CLIM                          Country lim.
     C                   PARM      *ZEROS        @ILIM                          Id limit
     C                   PARM                    @LREG                          Limit of Registrat.
      *
      ***  If error found, report error using message, passed by validation pgm
      *
     C     @DBID         IFEQ      '1'
     C                   MOVEL     'ILCODEPD'    DBFILE                         ***************
     C                   MOVEL     '901'         DBASE                          * DBERROR 901 *
     C                   MOVEL     *BLANKS       DBKEY                          ***************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ***  IBLC Operation code does not exist
      *
     C     @ERID         IFEQ      '1'
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'IL04505'     #MSGID
     C                   GOTO      #ERROR
     C                   ENDIF
      *
      ***  'Not valid today'
      *
     C     @ERID         IFEQ      '2'
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'IL04506'     #MSGID
     C                   GOTO      #ERROR
     C                   ENDIF
      *
     C                   ENDIF                                                  #0OPCO NOT BLANKS
      *
     C     #ERROR        TAG
      *
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ***  Parameters
      *
     C     *entry        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    #MsgID
     C                   PARM                    #LLXOPCO
     C                   PARM                    #LLXORTY
     C                   PARM                    #LLXBETY
     C                   PARM                    SMCY
     C                   PARM                    SMAM
     C                   PARM                    @@SETT
     C                   PARM                    ZCCYT
     C                   PARM                    ZRATET
     C                   PARM                    ZMDINT
     C                   PARM                    ZCDPT
     C                   PARM                    @CUST
     C                   PARM                    @@BOAF
     C                   PARM                    @CLIM
     C                   PARM                    @ILIM
      *
      ***  Setup DS TWND
      *
     C                   MOVE      'OP'          WWTRAN
     C                   MOVE      @@SETT        WWSETT
      *
      ***  Set the program, module and procedure names for database
      ***  error processing.  Note: this /COPY requires that the PSDS
      ***  /COPY is also included.
      *
     C                   EVAL      DBPgm  = PSProcPgm
     C                   EVAL      DBMod  = PSProcMod
     C                   EVAL      DBProc = PSProcName
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Program, module and procedure names for database error process*
      *                                                               *
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2005
**  WND
INOR1MINOR2MINOR4MINOR5OINRO1MINRO5OINOR7M
OPRO1MOPRO2MOPRO4MOPRO5OOPOR1MOPOR5OOPRO7M
CCOR1MCCOR2MCCOR4MCCOR5OCCRO1MCCRO5OCCOR7M
CPRO1MCPRO2MCPRO4MCPRO5OCPOR1MCPOR5OCPRO7M
