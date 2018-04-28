     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate JEOPCx Operation code')
      *****************************************************************
      *                                                               *
      *  Midas - IBLC 2002 Module                                     *
      *                                                               *
      *  GLVJEOPC2 - Validate Operation code                          *
      *                                                               *
      *  Function:  This module receives parameters containing an     *
      *             Operation code and confirm wether it is a valid   *
      *             Operation code or not                             *
      *             If it is valid the 10A return code will be blank, *
      *             if it is not it will contain 'Error'              *
      *                                                               *
      ***Component*of:**SP122CTYLX*-*Core*Luxembourg*service*program***                       CER001
      *  Component of:  SP6GL0004  - Core service program             *                       CER001
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CER001             Date 25Apr05               *
      *  Prev Amend No. ULX043             Date 16Oct01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
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
 
      **
      **   Declared variables
      **   ==================
      **
 
      ** Define *entry parameters
     D #LLXOPCF        S              3A
     D #1CUST          S              6A
     D #1CYCD          S              3A
 
      ** Define parameters for call module
     D ZALIGNok        S              1A
     D ZFIELD          S             16A
     D ZADEC           S              1P 0
     D ZADIG           S              2P 0
 
     D @CODE           S              3A
     D @CUST           S              6A
     D @TCCY           S              3A
     D @CPGM           S             10A
     D @DBID           S              1A
     D @ERID           S              1A
     D @CLIM           S             15P 0
     D @ILIM           S             15P 0
     D @LREG           S             15P 0
 
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *                M A I N  P R O C E S S I N G                   *
      *                                                               *
      *****************************************************************
      *
      **
      ** Initial processing is performed automatically: the *INZSR is
      ** executed at program activation.
      **
      *
      ** Reset the error flag to prevent problems on subsequent calls
      *
     C                   RESET                   ErrorFound
      *
      ***  Validate field
      ***  Search Asked ?
      *
     C     '?'           SCAN      #LLXOPCF      RESULT            1 0    99
     C     *IN99         IFEQ      *ON
      *
      ***  Call IBLC 2002 Operation Selection Program
      *
     C                   CALL      'IL0400'
     C                   PARM      #LLXOPCF      WWOPCO            3
     C                   PARM      *BLANK        WWSELE            1
     C                   PARM      *BLANK        WWRETR            1
      *
     C     WWSELE        IFEQ      '1'                                          if selection made
     C                   MOVE      WWOPCO        #LLXOPCF                       then use it
     C                   ENDIF
     C                   MOVE      *ON           *IN75                          Redisplay Screen
     C                   ENDIF
      *
      ***  1) If other input, operation code couldn't be blanks
      *
     C     #LLXOPCF      IFEQ      *BLANKS
      *
      ***  'Please insert an IBLC Operation Code.'
      *
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'IL10001'     #MSGID
     C                   GOTO      #ERROR
     C                   ENDIF
      *
      ***  2) check if numeric
      *
     C                   MOVE      *OFF          *IN99
     C                   TESTN                   #LLXOPCF             99
      *
     C     *IN99         IFNE      *ON
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'BL10002'     #MSGID
     C                   GOTO      #ERROR
     C                   ELSE
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE(P)   #LLXOPCF      ZFIELD
     C                   Z-ADD     3             ZADIG
     C                   Z-ADD     0             ZADEC
      *
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
      *
      ** Input is not valid
      *
     C     ZALIGNok      IFEQ      'N'
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'IL10002'     #MSGID
     C                   GOTO      #ERROR
     C                   ENDIF
     C                   ENDIF
      *
      ***  3) Verify if operation code is active
      *
     C                   MOVEL     #LLXOPCF      @CODE
     C                   MOVEL     'GLBPLXVXL'   @CPGM
      *
      ** Call validation program
      *
     C                   CALL      'IL0410'
     C                   PARM                    @CODE
     C                   PARM      '*BANK '      @LIMT             6            LIMIT = 0
     C                   PARM      #1CYCD        @TCCY                          Ccy for limits
     C                   PARM      'GLVJEOPC2'   @CPGM
      *
      ***  Result parameters
      *
     C                   PARM      '0'           @ERID
     C                   PARM      '0'           @DBID                                      .
     C                   PARM      *ZEROS        @CLIM
     C                   PARM      *ZEROS        @ILIM
     C                   PARM                    @LREG                          Limit of Registrat.
      *                                                                         In Transaction Ccy
      ** If error found, report error using message, passed by validation pgm
      *
     C     @DBID         IFEQ      *ON
     C                   MOVEL     'ILCODEPD'    DBFILE                         ***************
     C                   MOVEL     '900'         DBASE                          * DBERROR 900 *
     C                   MOVEL     '1'           DBKEY                          ***************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** If not found, report error
      *
     C     @ERID         IFEQ      '1'
      *
      ***  'IBLC code not more/yet defined in IBLC 2002 table.''
      *
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'IL10003'     #MSGID
     C                   GOTO      #ERROR
     C                   ENDIF
      *
     C     #ERROR        TAG
      *
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
     C                   RETURN
 
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Parameters
      *
     C     *entry        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    #MsgID
     C                   PARM                    #LLXOPCF
     C                   PARM                    #1CUST
     C                   PARM                    #1CYCD
     C                   PARM                    @CLIM
     C                   PARM                    @ILIM
      *
      ** Set the program, module and procedure names for database
      ** error processing.  Note: this /COPY requires that the PSDS
      ** /COPY is also included.
      *
     C                   EVAL      DBPgm  = PSProcPgm
     C                   EVAL      DBMod  = PSProcMod
     C                   EVAL      DBProc = PSProcName
      *
     C                   ENDSR
      *
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
