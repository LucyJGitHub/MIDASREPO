     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Validate Interest Settlement Method')         *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  ZZVSETMETH - Validate Interest Settlement Method             *
      *                                                               *
      *  Function:  This module receives a parameter containing the   *
      *             Interest Settlement Method field and confirms     *
      *             whether it has a valid value.                     *
      *             If it is valid the 10A return code will be blank, *
      *             if it is not it will contain  'Error'             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date  3Oct97               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
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
 
     D TABSET          S              2    DIM(11) CTDATA PERRCD(11)
 
     D Msgdata1        DS            45
      **  Data structure to hold the data for screen messages.
     D  @DATA1                 1     25
     D  @DATA2                26     45
 
     D SDACNT        E DS                  EXTNAME(ACCNTAB)
      ** EXTERNAL DS FOR ACCOUNT DETAILS
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Error message fields received as a parameter
     D Msgid1          S                   LIKE(#Msgid)
     D Msgid2          S                   LIKE(#Msgid)
 
      ** Interest Settlement Account field in error (DDINSA).
      ** (This field also validated by this program)
     D DDINSAOK        S              1A
 
      ** Interest Counterparty Nostro field in error (DDINOS) also validated
      ** (This field also validated by this program)
     D DDINOSOK        S              1A
 
      ** Enhanced Rollover Processing Indicator - received as a parameter
     D S01434          S              1A
 
      ** Deal Currency - received as a parameter
     D DDCCY           S              3A
 
      ** Interest Settlement Currency - received as a parameter
     D DDISCY          S              3A
 
      ** Interest Paid Seperately Indicator - received as a parameter
     D DDIPDS          S              1A
 
      ** Interest Settlement Method - received as a parameter
     D DDIMET          S              2A
 
      ** Retail Banking Indicator - received as a parameter
     D BGRTBN          S              1A
 
      ** Customer - received as a parameter
     D*IKCNUM***       S              6S 0                                                    CSD027
     D IKCNUM          S              6A                                                      CSD027
 
      ** Retail Account Code - received as a parameter
     D***BMACCD          S              4A                                                    CGL029
     D BMACCD          S             10A                                                      CGL029
 
      ** Branch Code - received as a parameter
     D DDBRCA          S              3A
 
      ** Branch Internal Customer - received as a parameter
     D A8BICN          S              6A
 
      ** General Ledger Account Code - received as a parameter
     D***BKACCD          S              4A                                                    CGL029
     D BKACCD          S             10A                                                      CGL029
 
      ** Yankee Doller Currency Code - received as a parameter
     D BLUSCY          S              3A
 
      ** Interest Settlement Account - received as a parameter
     D***DDINSA          S             15A                                                    CGL029
     D DDINSA          S             21A                                                      CGL029
 
      ** Interest Counterparty Nostro - received as a parameter
     D DDINOS          S             10A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Reset error flags & msgs to prevent problems on subsequent calls
     C                   RESET                   ErrorFound
     C                   RESET                   Msgid1
     C                   RESET                   Msgid2
     C                   RESET                   MsgData1
     C*
     C** 'Effective' Settlement Currency
     C*
     C     DDISCY        IFNE      *BLANK
     C                   MOVEL     DDISCY        EffSetCcy         3
     C                   ELSE
     C                   MOVEL     DDCCY         EffSetCcy
     C                   ENDIF
 
      ** *--------------------------------------------*
      ** * Validate Interest Settlement Method        *
      ** *--------------------------------------------*
 
      ** Only validate if Enhanced Rollovers processing switched on
     C     S01434        IFEQ      'Y'
 
     C     DDIPDS        IFEQ      'Y'
     C     DDIMET        LOOKUP    TABSET                                 85
 
      ** Has to be a valid settlement method
     C     *IN85         IFEQ      '0'
     C     DDIMET        IFNE      *BLANKS
     C                   SETON                                        85
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0631'     Msgid1
     C                   END
     C                   ELSE
 
      ** Retail module has to be switched on for methods 04 and 14
     C                   SETOFF                                       85
     C     DDIMET        IFEQ      '04'
     C     DDIMET        OREQ      '14'
     C     BGRTBN        IFNE      'Y'
     C                   SETON                                        85
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0632'     Msgid1
     C                   END
     C                   END
 
      ** Prime Retail account has to exist for settlement method 04
     C     *IN85         IFEQ      '0'
     C     DDIMET        ANDEQ     '04'
     C                   MOVEL     IKCNUM        @CNUM
     C                   CALLB     'AOACCTR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      *BLANKS       @RETL            10
     C                   PARM                    @CNUM             6
     C                   PARM      EffSetCcy     @CYCD             3
     C**********         PARM      BMACCD        @ACCD             4                          CGL029
     C                   PARM      BMACCD        @ACCD            10                          CGL029
     C                   PARM      '01'          @ACSN             2
     C                   PARM      DDBRCA        @DSNB             3
     C     SDACNT        PARM      SDACNT        DSSDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   SETON                                        85
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0633'     Msgid1
 
     C                   ELSE
 
     C     RECI          IFNE      'D'
     C                   SETON                                        85
     C                   MOVE      'Y'           ErrorFound
 
      ** Concatenate customer, currency, a/c code & a/c sequence.
      ** The original CAT opcode lines have been replaced by the following
      ** EVAL statement because the CATs appear to work differently in
      ** ILE RPG from OPM.
 
     C                   EVAL      MsgData1 = @CNUM + '-' + @CYCD
     C                                        + '-' + @ACCD + '-' + @ACSN
 
     C                   MOVEL     'BBM0130'     Msgid1
     C                   END
     C                   END
     C                   END
 
      ** Computer Suspense account has to exist for method 06
     C     *IN85         IFEQ      '0'
     C     DDIMET        ANDEQ     '06'
 
     C                   CALL      'AOACCTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      *BLANKS       @RETL            10
     C                   PARM      A8BICN        @CNUM             6
     C                   PARM      EffSetCcy     @CYCD             3
     C**********         PARM      BKACCD        @ACCD             4                          CGL029
     C                   PARM      BKACCD        @ACCD                                        CGL029
     C                   PARM      '01'          @ACSN             2
     C                   PARM      DDBRCA        @DSNB             3
     C     SDACNT        PARM      SDACNT        DSSDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   SETON                                        85
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0634'     Msgid1
     C                   ELSE
     C     RECI          IFNE      'D'
     C                   SETON                                        85
     C                   MOVE      'Y'           ErrorFound
 
      ** Concatenate customer, currency, a/c code & a/c sequence.
      ** The original CAT opcode lines have been replaced by the following
      ** EVAL statement because the CATs appear to work differently in
      ** ILE RPG from OPM.
 
     C                   EVAL      MsgData1 = @CNUM + '-' + @CYCD
     C                                        + '-' + @ACCD + '-' + @ACSN
 
     C                   MOVEL     'BBM0130'     Msgid1
     C                   END
     C                   END
     C                   END
 
      ** Deal currency has to be USD for settlement method 07
     C     *IN85         IFEQ      '0'
     C     DDIMET        ANDEQ     '07'
     C     EffSetCcy     ANDNE     BLUSCY
     C                   SETON                                        85
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0635'     Msgid1
     C                   MOVE      *BLANKS       MsgData1
     C                   MOVEL     BLUSCY        MsgData1
     C                   END
     C                   END
 
     C                   ELSE
 
     C** Should not be input if Interest Paid Separately is No
     C     DDIMET        IFNE      *BLANKS
     C                   SETON                                        85
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0650'     Msgid1
     C                   END
 
     C     DDINOS        IFNE      *BLANKS
     C                   MOVE      'N'           DDINOSOK
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0647'     Msgid2
     C                   END
     C                   END
     C                   ELSE
     C                   MOVE      *BLANKS       DDIMET
     C                   MOVE      *BLANKS       DDINSA
     C                   MOVE      *BLANKS       DDINOS
     C                   END
 
      ** If an error was found, set the return code appropriately
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
 
     C     *ENTRY        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    Msgid1
     C                   PARM                    Msgid2
     C                   PARM                    MsgData1
     C                   PARM                    DDINSAOK
     C                   PARM                    DDINOSOK
     C                   PARM                    S01434
     C                   PARM                    DDCCY
     C                   PARM                    DDISCY
     C                   PARM                    DDIPDS
     C                   PARM                    DDIMET
     C                   PARM                    BGRTBN
     C                   PARM                    IKCNUM
     C                   PARM                    BMACCD
     C                   PARM                    DDBRCA
     C                   PARM                    A8BICN
     C                   PARM                    BKACCD
     C                   PARM                    BLUSCY
     C                   PARM                    DDINSA
     C                   PARM                    DDINOS
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
** TABSET - Interest Settlement Methods
0001020304050607081214
