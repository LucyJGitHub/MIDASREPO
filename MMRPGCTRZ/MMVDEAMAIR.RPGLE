     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate Actual Interest Rate     (Deams)')
      *****************************************************************
      *                                                               *
      *  Midas - Common Validation Routine                            *
      *                                                               *
      *  MMVDEAMAIR - Validate Actual Interest Rate                   *
      *               (for Deal Amendment processing)                 *
      *                                                               *
      *  Function:  This module receives a parameter containing the   *
      *             Actual Interest Rate and confirms if it is valid. *
      *             If it is valid the 10A return code will be blank; *
      *             if it is not it will contain 'Error'.             *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG3620            Date 12Jul04               *
      *                 CDL020  *CREATE    Date 03Feb04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG3620- Apply Base Rate at Value Date for Spread Changes    *
      *  CDL020 - Apply Base Rate at Value Date                       *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +----------------------------+
      ** ¦ Manually Included F-Specs  ¦
      ** ¦ =========================  ¦
      ** +----------------------------+
      **
      ** +-----------------------------------+
      ** ¦ End of Manually Included F-Specs  ¦
      ** ¦ ================================  ¦
      ** +-----------------------------------+
      **
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
 
      ** Program, procedure and module names for parameters
      ** ==================================================
 
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
 
     D INFDS           DS
      **  Data structure for file status of MM deals file.
 
     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)
      ** External DS for Base Rate details
 
     D SDBSHS        E DS                  EXTNAME(SDBSHSPD)
      ** External DS for Historic Base Rate details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** External data structure for access programs (short)
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** External data structure for access programs (long)
 
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
 
      ** Deal Amendment Type received as a parameter
     D DDMTYP          S              2A
 
      ** Interest Rate/Spread received as a parameter
     D DDAIR           S             12A
 
      ** Analytical Accounting Installed Indicator (from SDMMODPD)
      ** received as a parameter
     D BGN0ST          S              1A
 
      ** Decimal separator from SDDEALPD received as a parameter
     D BNDCSP          S              1A
 
      ** Currency received as a parameter
     D DDCCY           S              3A
 
      ** Base Rate received as a parameter
     D DDBSRT          S              2A
 
      ** Value Date received as a parameter
     D ValDate         S              5  0
 
      ** Run Date received as a parameter
     D WProcDate       S              5  0
 
      ** Interest Rate/Spread received as a parameter
     D IGINTR          S             11  7
 
      ** Interest Rate returned to caller
     D IGBRTE          S             11  7
 
      ** Fields used in call to Module ZA0840
 
      ** Alpha field for numeric validation
     D @@ALPH          S             16A
      ** Millions/Thousands id (Y=function on)
     D @@MTID          S              1A
      ** Amount calculation field
     D @@AMT           S             15  0
      ** Error code
     D @@ERCD          S              1  0
      ** Number of decimal places
     D @@IDP           S              3  0
      ** Number of integers
     D @@IINT          S              3  0
 
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
 
      ** Reset the error flag to prevent problems on subsequent calls
     C                   RESET                   ErrorFound
     C                   RESET                   Msgid1
      *
      *  *-------------------------------*
      *  * Validate Actual Interest Rate *
      *  *-------------------------------*
      *
 
      **  If Actual Interest Rate is not blank, this is an error for type
      **  other than BC and EM.
      **  and SC.                                                                            BUG3620
 
     C     DDMTYP        IFNE      'BC'
     C     DDMTYP        ANDNE     'EM'
     C     DDMTYP        ANDNE     'SC'                                                      BUG3620
     C     DDAIR         ANDNE     *BLANKS
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0332'     Msgid1
     C                   ENDIF
 
      ** Actual Interest Rate can not be amended if Base Rate Code is blank
 
     C     DDBSRT        IFEQ      *BLANKS
     C     DDAIR         ANDNE     *BLANKS
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0352'     Msgid1
     C                   ENDIF
 
      ** If Deal Amendment Type is valid and Base Rate Code entered
 
     C     DDMTYP        IFEQ      'BC'
     C     DDBSRT        ANDNE     *BLANKS
     C     ErrorFound    ANDNE     'Y'
     C     DDMTYP        OREQ      'EM'
     C     DDBSRT        ANDNE     *BLANKS
     C     ErrorFound    ANDNE     'Y'
     C     DDMTYP        OREQ      'SC'                                                      BUG3620
     C     DDBSRT        ANDNE     *BLANKS                                                   BUG3620
     C     ErrorFound    ANDNE     'Y'                                                       BUG3620
 
      ** If Actual Interest Rate is Blank, then default base rate
 
     C     DDAIR         IFEQ      *BLANKS
 
      ** Access Current Base Rate
 
     C                   CALL      'AOBSRTR0'
     C                   PARM      *BLANKS       @RETURN           7
     C                   PARM      '*KEY   '     @OPTION           7
     C                   PARM      DDCCY         @CURRCY           3
     C                   PARM      DDBSRT        @ALPHBSRC         2
     C     SDBSRT        PARM      SDBSRT        DSSDY
 
      ** Get Historic Base Rate or Current Base Rate depending on
      ** Value Date.
 
     C     ValDate       IFGE      BAVDRC
 
      ** Determine actual base rate
 
     C     ValDate       IFLT      BAVDNR
     C                   Z-ADD     BACBSR        WkBaseRate       11 7
     C                   ELSE
     C                   Z-ADD     BANBRT        WkBaseRate
     C                   ENDIF
 
      ** Access Historic Base Rates
     C                   ELSE
     C                   Z-ADD     0             @BSRT             2 0
     C                   MOVE      DDBSRT        @BSRT
 
     C                   CALL      'AOBSHSR0'
     C                   PARM      *BLANKS       @RETURN
     C                   PARM      '*KEY   '     @OPTION
     C                   PARM      DDCCY         @CURRCY
     C                   PARM      @BSRT         @DEFFNDRT         2 0
     C                   PARM      ValDate       @HISTDATE         5 0
     C     SDBSHS        PARM      SDBSHS        DSFDY
 
     C                   Z-ADD     G0CBSR        WkBaseRate
 
     C                   ENDIF
 
     C     @RETURN       IFEQ      *BLANKS
     C                   Z-ADD     WkBaseRate    IGBRTE
     C     WkBaseRate    ADD       IGINTR        WAIR             11 7
     C                   Z-ADD     0             PAmtIn
     C                   MOVE      WAIR          PAmtIn
     C                   Z-ADD     7             PNoOfDecPl
     C                   CALLB     'ZA0921'
     C                   PARM      *BLANK        RetCodeIn
     C                   PARM                    PAmtIn           15 0
     C                   PARM                    PNoOfDecPl        1 0
     C                   PARM                    BNDCSP
     C                   PARM      *BLANK        PAmtOutS         16
     C                   PARM      *BLANK        PAmtOutU         17
      *
     C                   MOVE      PAmtOutS      DDAIR
      *
     C                   ELSE
     C                   MOVE      *BLANKS       DDAIR
     C                   ENDIF
 
      ** Actual Interest Rate is not Blank
     C                   ELSE
      *
      **  Check it is a valid figure with 7 decimal places max.
     C                   Z-ADD     7             @@IDP
     C                   Z-ADD     4             @@IINT
     C                   MOVE      *BLANKS       @@ALPH
     C                   MOVE      DDAIR         @@ALPH
     C                   MOVE      'N'           @@MTID            1
     C                   CALLB     'ZA0840'
     C                   PARM                    RetCodeIn
     C                   PARM                    @@ALPH
     C                   PARM                    @@IDP
     C                   PARM                    @@IINT
     C                   PARM                    @@MTID
     C                   PARM                    @@Ercd
     C                   PARM                    @@Amt
     C                   PARM                    BNDCSP
      *
     C     @@Ercd        IFNE      0
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0422'     Msgid1
     C                   ENDIF
      *
      **  If the spread/rate is valid, determine the Actual Interest Rate
      **  and output it
     C     ErrorFound    IFNE      'Y'
     C     DDAIR         IFNE      *BLANKS
     C     @@Amt         DIV       10000000      IGBRTE
     C     IGBRTE        SUB       IGINTR        IGBRTE
     C                   MOVE      @@ALPH        DDAIR
     C                   ELSE
     C                   Z-ADD     0             IGBRTE
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
 
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
 
     C     *entry        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    Msgid1
     C                   PARM                    DDMTYP
     C                   PARM                    DDAIR
     C                   PARM                    BGN0ST
     C                   PARM                    BNDCSP
     C                   PARM                    DDCCY
     C                   PARM                    DDBSRT
     C                   PARM                    ValDate
     C                   PARM                    WProcDate
     C                   PARM                    IGINTR
     C                   PARM                    IGBRTE
 
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
(c) Finastra International Limited 2004
