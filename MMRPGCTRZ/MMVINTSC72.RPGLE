     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate Int. Settle Ccy & Field 72 Ccy')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMVINTSC72 - Validate Interest Settlement Currency           *
      *               and 'In' Currency in field 72                   *
      *                                                               *
      *  Function:  This module receives an interest settlement       *
      *             curency and an 'in' currency in field 72 and      *
      *             validates them both. If they are valid the 10A    *
      *             return code will be blank; if they are not it     *
      *             will contain 'Error'                              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *  Prev Amend No. CAP002   *CREATE   Date 01May98               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CAP002 - Conversion of input functions into modular          *
      *           structure to use as APIs.                           *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
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
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
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
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** External data structure for currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** Long data structure for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Error message code 1 received as a parameter
     D Msgid1          S                   LIKE(#MSGID)
      ** Error message code 2 received as a parameter
     D Msgid2          S                   LIKE(#MSGID)
 
 
      ** Error indicators (1A, returned to caller)
     D ErrIntSetc      S                   LIKE(ErrorFound)
     D ErrIntin72      S                   LIKE(ErrorFound)
 
 
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Reset the error flags to prevent problems on subsequent calls
     C                   RESET                   ErrorFound
     C                   RESET                   Msgid1
     C                   RESET                   Msgid2
     C                   RESET                   ErrIntSetc
     C                   RESET                   ErrIntin72
 
      ** Reset output fields
 
     C                   MOVEL     *BLANK        IKISCY
     C                   MOVEL     *BLANK        IKII72
      *
      **  If both fields are blank, return to the calling program.
      *
     C     DDISCY        IFEQ      *BLANKS
     C     DDII72        ANDEQ     *BLANKS
     C                   RETURN
     C                   ENDIF
      *
      **  Validate Interest Settlement Currency
      *
     C     DDISCY        IFNE      *BLANKS
     C                   EXSR      VAL_ISCY
     C                   ENDIF
      *
      **  Validate Interest 'In' Currency in Field 72
      *
     C     DDII72        IFNE      *BLANKS
     C                   EXSR      VAL_II72
     C                   ENDIF
 
      ** If an error was found, set the return code appropriately
 
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * VAL_ISCY - Validate Interest Settlement Currency              *
      *                                                               *
      *****************************************************************
     C     VAL_ISCY      BEGSR
      *
      **  Interest paid separately indicator is not 'Y'
      *
     C     DDIPDS        IFNE      'Y'
     C                   MOVE      'Y'           ErrorFound
     C                   MOVE      'Y'           ErrIntSetc
     C                   MOVEL     'MMM0089'     Msgid1
     C                   GOTO      EVALISCY
     C                   ENDIF
      *
      **  Get interest settlement currency details
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY    '    @OPTN             7
     C                   PARM      DDISCY        @CURR             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      **  Invalid interest settlement currency
      *
     C     @RTCD         IFNE      *BLANKS
     C     A6DLCI        ORNE      'Y'
     C                   MOVE      'Y'           ErrorFound
     C                   MOVE      'Y'           ErrIntSetc
     C                   MOVEL     'MMM0083'     Msgid1
     C                   GOTO      EVALISCY
     C                   END
 
     C                   MOVEL     A6CYCD        DDISCY
      *
      ** Transaction currency is Euros
      *
     C     DDCCY         IFEQ      BKEURO
      *
      **  Error if interest settlement ccy is not an 'In' currency
      *
     C     A6INCY        IFNE      'Y'
     C                   MOVE      'Y'           ErrorFound
     C                   MOVE      'Y'           ErrIntSetc
     C                   MOVEL     'MMM0082'     Msgid1
     C                   ENDIF
 
     C                   ELSE
      *
      **  Transaction ccy is an 'In' currency
      *
     C     DDccyINCY     IFEQ      'Y'
      *
      **  Error if interest settlement ccy is not Euros
      *
     C     DDISCY        IFNE      BKEURO
     C                   MOVE      'Y'           ErrorFound
     C                   MOVE      'Y'           ErrIntSetc
     C                   MOVEL     'MMM0081'     Msgid1
     C                   ENDIF
      *
      **  Transaction ccy is an 'Out' currency,
      **  so interest settlement currency shouldn't be defined
      *
     C                   ELSE
     C                   MOVE      'Y'           ErrorFound
     C                   MOVE      'Y'           ErrIntSetc
     C                   MOVEL     'MMM0091'     Msgid1
     C                   ENDIF
 
     C                   ENDIF
 
     C                   MOVEL     DDISCY        IKISCY
 
     C     EVALISCY      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * VAL_II72 - Validate Interest 'In' Currency in Field 72        *
      *                                                               *
      *****************************************************************
     C     VAL_II72      BEGSR
      *
      **  Interest paid separately indicator is not 'Y'
      *
     C     DDIPDS        IFNE      'Y'
     C                   MOVE      'Y'           ErrorFound
     C                   MOVE      'Y'           ErrIntin72
     C                   MOVEL     'MMM0090'     Msgid2
     C                   GOTO      EVALII72
     C                   ENDIF
      *
      **  Interest settlement method is not 01 or 08
      *
     C     DDIMET        IFNE      '01'
     C     DDIMET        ANDNE     '08'
     C                   MOVE      'Y'           ErrorFound
     C                   MOVE      'Y'           ErrIntin72
     C                   MOVEL     'MMM0084'     Msgid2
     C                   GOTO      EVALII72
     C                   ENDIF
      *
      **  Deal is not a deposit
      *
     C     DDTYPE        IFNE      'IT'
     C     DDTYPE        ANDNE     'TD'
     C     DDTYPE        ANDNE     'CD'
     C     DDTYPE        ANDNE     'CI'
     C                   MOVE      'Y'           ErrorFound
     C                   MOVE      'Y'           ErrIntin72
     C                   MOVEL     'MMM0092'     Msgid2
     C                   GOTO      EVALII72
     C                   ENDIF
      *
      **  Get interest 'in' currency in field 72 currency details
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY    '    @RTCD
     C                   PARM      DDII72        @CURR
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      **  Invalid currency
      *
     C     @RTCD         IFNE      *BLANKS
     C     A6DLCI        ORNE      'Y'
     C                   MOVE      'Y'           ErrorFound
     C                   MOVE      'Y'           ErrIntin72
     C                   MOVEL     'MMM0085'     Msgid2
     C                   GOTO      EVALII72
     C                   END
 
     C                   MOVEL     A6CYCD        DDII72
 
      *
      ** If transaction currency is Euros and int settle ccy is blank
      ** or int settle ccy is Euros and transaction currency is an 'in' ccy
      *
     C     DDCCY         IFEQ      BKEURO
     C     DDISCY        ANDEQ     *BLANKS
     C     DDISCY        OREQ      BKEURO
     C     DDccyINCY     ANDEQ     'Y'
      *
      ** If transaction currency is Euros
      *
     C     DDCCY         IFEQ      BKEURO
      *
      ** Error if the 'in' currency in field 72 is NOT an 'in' currency
      *
     C     A6INCY        IFNE      'Y'
     C                   MOVE      'Y'           ErrorFound
     C                   MOVE      'Y'           ErrIntin72
     C                   MOVEL     'MMM0086'     Msgid2
     C                   ENDIF
      *
     C                   ELSE
      *
      ** If transaction currency is NOT Euros
      ** the 'in' currency in field 72 must be the transaction ccy
      *
     C     DDII72        IFNE      DDCCY
     C                   MOVE      'Y'           ErrorFound
     C                   MOVE      'Y'           ErrIntin72
     C                   MOVEL     'MMM0088'     Msgid2
     C                   ENDIF
     C*
     C                   ENDIF
      *
      ** 'In' currency in field 72 can't be present
      *
     C                   ELSE
     C                   MOVE      'Y'           ErrorFound
     C                   MOVE      'Y'           ErrIntin72
     C                   MOVEL     'MMM0087'     Msgid2
     C                   ENDIF
 
     C                   MOVEL     DDII72        IKII72
 
     C     EVALII72      ENDSR
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
 
     C     *entry        PLIST
     C                   PARM                    ReturnCode
     C                   PARM                    Msgid1
     C                   PARM                    Msgid2
     C                   PARM                    ErrIntSetc
     C                   PARM                    ErrIntin72
     C                   PARM                    DDISCY            3
     C                   PARM                    DDII72            3
     C                   PARM                    DDTYPE            2
     C                   PARM                    DDCCY             3
     C                   PARM                    DDccyINCY         1
     C                   PARM                    DDIPDS            1
     C                   PARM                    DDIMET            2
     C                   PARM                    BKEURO            3
     C                   PARM                    IKISCY            3
     C                   PARM                    IKII72            3
 
      ** Initialise error flags (can't be done using INZ keyword in
      ** D-specs because they are on the parameter list)
     C                   EVAL            ErrIntSetc = 'N'
     C                   EVAL            ErrIntin72 = 'N'
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR                                                  *** InzEnd ***
 
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
