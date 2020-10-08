     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate IP third reimbursement inst.')       *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVITRIB - Validate IP Third Reimbursement Institution       *
      *                                                               *
      *  Function:  This module validates Third Reimbursement Insti-  *
      *             tution. This is a component of FTIPAYCTL,         *
      *             FTIPAYRPR, FTIPAYSIN, and service program for     *
      *             Level 1 validation modules.                       *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 CPK028             Date 29Jan08               *
      *                 250600             Date 30Sep07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 239811             Date 09Jun06               *
      *                 CDL049             Date 06Jul06               *
      *                 222470             Date 06Jun06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 13Jan01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014  *CREATE    Date 25May00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CPK028 - Conversion of Customer Number to Alpha.             *
      *  250600 - Fix for CFT032                                      *
      *  239811 - Reset value of ErrorFound field to avoid database   *
      *           error in AOSPOSU0 due to blank TRIT.                *
      *           Applied fix 22470, annotated as 222470.             *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  222470 - Errorfound indicator never initialised to 'N'. As   *
      *           a result the file fields are not updated.           *
      *           If the field is changed to blanks, the file fields  *
      *           are not updated.                                    *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CFT009 - Funds Transfer Fees and Charges (recompile)         *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************

      ** Accounts by retail number
     FACNUMA    IF   E           K DISK    RENAME(ACCNTABF:ACNUMAF)
     F                                     PREFIX(AB)

      ** Accounts by full account number
     FACCNT     IF   E           K DISK    PREFIX(AC)

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
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of dbase error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)

     D/COPY ZACPYSRC,STD_D_SPEC

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in
      ** the PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

      ** The following /COPY line includes the definitions for error
      ** and warning message arrays.
     D/COPY ZACPYSRC,ERR_XARRYS

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT                                                          *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      /COPY FTCPYSRC,SFTVALCSLE

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** Incoming Payments Lvl 1 Scrn details
     D NwIP1ScnFmt   E DS                  EXTNAME(FTIPY1PD)

      ** Incoming Payments Lvl 1 Scrn File 2 details
     D NwIP1AScnFmt  E DS                  EXTNAME(FTIPY1APD)

      ** Incoming Payments Valid extension file
     D NwIP2FilFmt   E DS                  EXTNAME(FTVIPY2PD)

      ** Incoming Payments Lvl 1 scrn error indicators
     D OKIPY1DS      E DS                  EXTNAME(FTEIPY1PD)

      ** First data structure used by access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Second data structure used by access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** Data structure for Nostro details
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)

      ** DS for account details for an IBAN account
     D WIBNACC       E DS                  EXTNAME(ACCNTAB) PREFIX(IB)

      ** Subfields of Third Reimbursement Institution
     D                 DS
     D  WTRIDS                 1     34
     D  WTRI0103               1      3
     D  WTRI0405               4      5
     D  WTRI0106               1      6
     D  WTRI0709               7      9
     D  WTRI0110               1     10
     D  WTRI1013              10     19                                                       CGL029
     D  WTRI1415              20     21                                                       CGL029
     D  WTRI1015              10     21                                                       CGL029
     D  WTRI1618              22     24                                                       CGL029
     D**WTRI1013              10     13                                                       CGL029
     D**WTRI1415              14     15                                                       CGL029
     D**WTRI1015              10     15                                                       CGL029
     D**WTRI1618              16     18                                                       CGL029
     D  WTRI0634               6     34
     D  WTRI1134              11     34
     D  WTRI1634              22     34                                                       CGL029
     D  WTRI1934              25     34                                                       CGL029
     D**WTRI1634              16     34                                                       CGL029
     D**WTRI1934              19     34                                                       CGL029

      ** Work array
     D  Arr050                        1A   DIM(50)

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Index for arrays of error message ids etc
     D Idx             S              3P 0

      ** Index for arrays of warning messages
     D WIdx            S              3P 0

      ** General Index for arrays
     D J               S              3P 0

      ** Third Reimbursement type
     D WTRITyp         S              1

      ** Third Reimbursement customer number
     D*WTRICNUM*       S              6  0                                                    CSD027
     D WTRICNUM        S              6                                                       CSD027

      ** Third Reimbursement currency
     D WTRICcy         S              3

      ** Third Reimbursement account code
     D*WTRIACOD*       S              4  0                                                    CGL029
     D WTRIACOD        S             10  0                                                    CGL029

      ** Third Reimbursement account sequence number
     D WTRIACSQ        S              2  0

      ** Third Reimbursement branch
     D WTRIBRCA        S              3
      ** Define full account to be passed for FT IMM update                                   250600
     D IMACNT          DS            24                                                       250600
     D**IMCNUM**               1      6  0                                             250600 CPK028
     D  IMCNUM                 1      6                                                       CPK028
     D  IMCCY                  7      9                                                       250600
     D  IMACOD                10     19  0                                                    250600
     D  IMACSQ                20     21  0                                                    250600
     D  IMBRCA                22     24                                                       250600
      *                                                                                       250600

      ** Fields redefined by CGL029                                                           CGL029
     D PACCD           S             10                                                       CGL029
     D WCHR15          S             21                                                       CGL029
     D WCHR18          S             24                                                       CGL029
     D WCTR            S              3P 0                                                    CGL029
      **
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT                                                          *
      *****************************************************************

      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+

     C                   EVAL      Idx = 0
     C                   EVAL      WIdx = 0

     C                   EVAL      ErrorFound = 'N'                                           239811
                                                                                              239811
     C                   MOVEL     *Blanks       PTRBDS           18                          250600
     C                   EXSR      SRTRIB
      ** Further validation
     C                   IF        (DDTRIB <> *BLANKS)
     C                             AND (OKTRIB = 'Y')
     C                   EXSR      SRTRIB02
     C                   ENDIF

      ** If an error was found, set the return code appropriately
     C                   IF        ErrorFound = 'Y' OR WarnFound = 'Y'
     C                   EVAL      ReturnCode = 'ERROR'
      *                                                                                       250600
     C                   ELSE                                                                 250600
      *                                                                                       250600
      ** Store full account details for FT Transaction Status File                            250600
      ** record update.                                                                       250600
      *                                                                                       250600
     C**********         Z-ADD     ACCNUM        IMCNUM                                250600 CPK028
     C                   MOVE      ACCNUM        IMCNUM                                       CPK028
     C                   MOVE      ACCCY         IMCCY                                        250600
     C                   Z-ADD     ACACOD        IMACOD                                       250600
     C                   Z-ADD     ACACSQ        IMACSQ                                       250600
     C                   MOVE      ACBRCA        IMBRCA                                       250600
     C                   MOVEL     IMACNT        PTRBDS                                       250600
     C                   ENDIF

     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTRIB   - Third Reimbursement Institution validation        *
      *                                                               *
      *****************************************************************
     C     SRTRIB        BEGSR

     C                   EVAL      WTRIDS = DDTRIB

      *
      ** Display warning message if (1) Level Joiner is off, (2) action
      ** is Amend, (3) Sender Correspondent is blank and (4) Third
      ** Reimbursement has been entered different from the previous.
      *

     C                   IF        (PBTLVJN <> 'Y')
     C                             AND (DDACTN = 'A')
     C                             AND (DDTRIB <> *BLANKS)
     C                             AND (PSndCorTyp <> *BLANKS)
     C                             AND (DDTRIB <> PPrvTRI)
     C                   EVAL      WIdx = WIdx + 1
     C                   EVAL      WMsgIdXAr(WIdx) = 'FTM3159'
     C                   EVAL      WFldNmXAr(WIdx) = 'DDTRIB'
     C                   EVAL      WarnFound = 'Y'
     C                   EVAL      OKTRIB = 'W'
     C                   ENDIF

      *
      ** '?' processing is not allowed in Third Reimbursement
      **    Institution
      *

     C     '?'           SCAN      DDTRIB                                 40
     C                   IF        *IN40 = *ON
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdXAr(Idx) = 'FTM3105'
     C                   EVAL      FldNamXAr(Idx) = 'DDTRIB'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      OKTRIB = 'N'
     C                   GOTO      EXTRIB
     C                   ENDIF

     C                   IF        DDTRIB = *BLANKS

      ** Bypass validation if Receiver's Correspondent is blank
     C                   IF        PRcvCorTyp = *BLANKS
     C                   GOTO      EXTRIB
     C                   ENDIF

      ** Receiver's Correspondent should be valid and should be either a
      ** Nostro, a Retail, an IBAN, or a GL account.
     C                   IF        OKRCO1 = 'Y'
     C                             AND (OKRCO2 = 'Y')
     C                             AND (OKRCO3 = 'Y')
     C                             AND (OKRCO4 = 'Y')
     C                             AND (OKRCO5 = 'Y')
     C                             AND (PRcvCorTyp <> 'N')
     C                             AND (PRcvCorTyp <> 'F')
     C                             AND (PRcvCorTyp <> 'R')
     C                             AND (PRcvCorTyp <> 'I')
     C                             AND (PRcvCorTyp <> 'G')
     C                   EVAL      Idx = Idx + 1
     C                   IF        (CFT004 = 'Y')
     C                   EVAL      MsgIdXAr(Idx) = 'FTM3106'
     C                   ELSE
     C                   EVAL      MsgIdXAr(Idx) = 'FTM3124'
     C                   ENDIF
     C                   EVAL      FldNamXAr(Idx) = 'DDTRIB'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      OKTRIB = 'N'
     C                   GOTO      EXTRIB
     C                   ENDIF

      ** If Receiver's Correspondent's account currency is not equal to
      ** Settle currency, Third Reimbursement Institution must be entered.
     C                   IF        (OKRCO1 = 'Y')
     C                             AND (OKRCO2 = 'Y')
     C                             AND (OKRCO3 = 'Y')
     C                             AND (OKRCO4 = 'Y')
     C                             AND (OKRCO5 = 'Y')
     C                             AND (OKSMCY = 'Y')
     C                   IF        PRcvCorTyp = 'N'
     C                             OR (PRcvCorTyp = 'F')
     C                             OR (PRcvCorTyp = 'R')
     C                             OR (PRcvCorTyp = 'I')
     C                             OR (PRcvCorTyp = 'G')
     C                   IF        PRcvCorCcy <> DDSMCY
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdXAr(Idx) = 'FTM3158'
     C                   EVAL      FldNamXAr(Idx) = 'DDTRIB'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      OKTRIB = 'N'
     C                   GOTO      EXTRIB
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** No further validation if third reimbursement is blank.
     C                   EVAL      I2INTRIT = *BLANKS                                         222470
     C                   EVAL      I2INTRIB = *BLANKS                                         222470
     C                   GOTO      EXTRIB
     C                   ENDIF

      *
      ** If Receiver's Correspondent is blank, Third Reimbursement must be
      ** blank.
      *

     C                   IF        DDRCO1 = *BLANKS
     C                             AND (DDRCO2 = *BLANKS)
     C                             AND (DDRCO3 = *BLANKS)
     C                             AND (DDRCO4 = *BLANKS)
     C                             AND (DDRCO5 = *BLANKS)
     C                             AND (OKRCO1 = 'Y')
     C                             AND (OKRCO2 = 'Y')
     C                             AND (OKRCO3 = 'Y')
     C                             AND (OKRCO4 = 'Y')
     C                             AND (OKRCO5 = 'Y')
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdXAr(Idx) = 'FTM3147'
     C                   EVAL      FldNamXAr(Idx) = 'DDTRIB'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      OKTRIB = 'N'
     C                   GOTO      EXTRIB
     C                   ENDIF

      *
      ** If CFT004 is on, validate as an IBAN account
      *

     C                   IF        CFT004 = 'Y'

     C                   EVAL      PIIBAN = *BLANKS
     C                   MOVE      *BLANKS       WIBAN            34
     C                   CALL      'AOIBANR3'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      DDTRIB        PIIBAN           47
     C                   PARM      *BLANKS       POWITH           47
     C     WIBAN         PARM      *BLANKS       PONOBL           34

     C                   IF        @RTCD = *BLANKS

     C     1             SUBST     WIBAN:1       WCHR01A           1
     C     1             SUBST     WIBAN:2       WCHR01B           1
     C     1             SUBST     WIBAN:3       WCHR01C           1
     C     1             SUBST     WIBAN:4       WCHR01D           1
     C     ALPHAB        CHECK     WCHR01A                                40
     C  N40ALPHAB        CHECK     WCHR01B                                40
     C  N40DIGITS        CHECK     WCHR01C                                40
     C  N40DIGITS        CHECK     WCHR01D                                40

      ** Continue if no invalid characters were found
     C                   IF        *IN40 = *OFF
     C                   CALL      'AOIBANR2'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    WIBAN
     C     WIBNACC       PARM      *BLANKS       DSSDY
     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDTRIB'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      OKTRIB = 'N'
     C                   ENDIF
     C                   SELECT
     C                   WHEN      @RTCD = '      1'
     C                   EVAL      MsgIDXAr(Idx) = 'FTM3125'
     C                   WHEN      @RTCD = '      2'
     C                   EVAL      MsgIDXAr(Idx) = 'FTM3126'
     C                   WHEN      @RTCD = '      3'
     C                   EVAL      MsgIDXAr(Idx) = 'FTM3127'
     C                   WHEN      @RTCD = '      4'
     C                   EVAL      MsgIDXAr(Idx) = 'FTM3128'
     C                   WHEN      @RTCD = '      5'
     C                   EVAL      MsgIDXAr(Idx) = 'FTM3129'
     C                   WHEN      @RTCD = '      6'
     C                   EVAL      MsgIDXAr(Idx) = 'FTM3130'
     C                   WHEN      @RTCD = *BLANKS
     C                   EVAL      DDTRIB = WIBAN
     C                   EVAL      WTRICNUM = IBCNUM
     C                   EVAL      WTRICCY = IBCCY
     C                   EVAL      WTRIACOD = IBACOD
     C                   EVAL      WTRIACSQ = IBACSQ
     C                   EVAL      WTRIBRCA = IBBRCA
     C                   EVAL      PAccTyp = IBATYP
     C                   EVAL      PAccSts = IBACST
     C                   EVAL      PDatAccOpn = IBDACO
     C                   EVAL      WTRICcy= IBCCY
     C                   EVAL      WTRITyp = 'I'
     C                   ENDSL
     C                   GOTO      EXTRIB
     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

      *
      ** If multi-branching and entry is more than 18 characters OR if
      ** single-branching and entry is more than 15 characters, then error.
      *

     C                   IF        (PBJMBIN = 'Y')
     C                             AND (WTRI1934 <> *BLANKS)
     C                             OR (PBJMBIN <> 'Y')
     C                             AND (WTRI1634 <> *BLANKS)

     C                   EVAL      Idx = Idx + 1
     C                   IF        CFT004 = 'Y'
     C                   EVAL      MsgIDXAr(Idx) = 'FTM3131'
     C                   ELSE
     C                   EVAL      MsgIDXAr(Idx) = 'FTM3148'
     C                   ENDIF
     C                   EVAL      FldNamXAr(Idx) = 'DDTRIB'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      OKTRIB = 'N'
     C                   GOTO      EXTRIB

     C                   ENDIF

      *
      ** Check for embedded blanks in positions 1-18 (multi-branching) and
      ** and positions 1-15 (single-branching)
      *

     C                   EVAL      Arr050 = *BLANKS
     C                   EVAL      WCHR15 = *BLANKS
     C                   EVAL      WCHR18 = *BLANKS

     C                   IF        PBJMBIN = 'Y'
     C**********         MOVEL     DDTRIB        WCHR18           18                          CGL029
     C                   MOVEL     DDTRIB        WCHR18                                       CGL029
     C                   MOVEA     WCHR18        Arr050(1)
     C**********         Z-ADD     18            WCTR              3 0                        CGL029
     C                   Z-ADD     24            WCTR                                         CGL029
     C                   ELSE
     C**********         MOVEL     DDTRIB        WCHR15           15                          CGL029
     C                   MOVEL     DDTRIB        WCHR15                                       CGL029
     C                   MOVEA     WCHR15        Arr050(1)
     C**********         Z-ADD     15            WCTR                                         CGL029
     C                   Z-ADD     21            WCTR                                         CGL029
     C                   ENDIF

     C                   SETOFF                                       8889
     C                   Z-ADD     1             I1                3 0
     C     *IN89         DOUEQ     *ON
     C     I1            ORGT      WCTR
     C     Arr050(I1)    IFEQ      *BLANKS
     C                   SETON                                        88
     C                   ELSE
     C     *IN88         IFEQ      *ON
     C                   SETON                                        89
     C                   ENDIF
     C                   ENDIF
     C                   ADD       1             I1
     C                   ENDDO

     C                   IF        (*IN89 = *ON)

     C                   IF        (PBJMBIN = 'Y') AND (J <= 18)
     C                             OR (PBJMBIN <> 'Y') AND (J <= 16)
     C                   EVAL      Idx = Idx + 1
     C                   IF        CFT004 = 'Y'
     C                   EVAL      MsgIDXAr(Idx) = 'FTM3132'
     C                   ELSE
     C                   EVAL      MsgIDXAr(Idx) = 'FTM3148'
     C                   ENDIF
     C                   EVAL      FldNamXAr(Idx) = 'DDTRIB'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      OKTRIB = 'N'
     C                   GOTO      EXTRIB
     C                   ENDIF

     C                   ENDIF

      *
      ** If positions 6-34 are blanks, validate as nostro or full nostro
      *

     C                   IF        WTRI0634 = *BLANKS

      ** Any of positions 4-5 is nonnumeric
     C     DIGITS        CHECK     WTRI0405                               40
     C                   IF        (*IN40 = *ON)
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIDXAr(Idx) = 'FTM3123'
     C                   EVAL      FldNamXAr(Idx) = 'DDTRIB'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      OKTRIB = 'N'
     C                   GOTO      EXTRIB
     C                   ENDIF

      ** Check if entry is an existing nostro identifier
     C                   CALL      'AONOSTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      *BLANKS       PCUST             6
     C                   PARM      WTRI0103      PCYCD             3
     C**********         PARM      *BLANKS       PACCD             4                          CGL029
     C                   PARM      *BLANKS       PACCD                                        CGL029
     C                   PARM      *BLANKS       PACSQ             2
     C                   PARM      WTRI0405      PNONB             2
     C                   PARM      *BLANKS       PBRCD             3
     C                   PARM      *BLANKS       PCSSN            10
     C                   PARM      *BLANKS       PPNOI             1
     C     SDNOST        PARM      *BLANKS       DSFDY
     C                   IF        (@RTCD <> *BLANKS)
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIDXAr(Idx) = 'FTM3133'
     C                   EVAL      FldNamXAr(Idx) = 'DDTRIB'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      OKTRIB = 'N'
     C                   GOTO      EXTRIB
     C                   ENDIF

     C                   MOVE      A7CUST        KCNUM
     C                   MOVE      A7CYCD        KCYCD
     C                   MOVE      A7ACCD        KACOD
     C                   MOVE      A7ACSN        KACSQ
     C                   MOVE      A7BRCD        KBRCA
     C                   EVAL      WTRITyp  = 'F'
     C                   GOTO      EXTRIB

     C                   ENDIF

      *
      ** Validate entry as a Retail account if positions 11-34 are blanks
      ** and Retail module is on.
      *

     C                   IF        (WTRI1134 = *BLANKS)
     C                   IF        (PBGRTBN = 'Y') OR (PBGIOAC = 'Y')

     C     DIGITS        CHECK     WTRI0110                               40

      ** Entry is nonnumeric
     C                   IF        (*IN40 = *ON)
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdXAr(Idx) = 'FTM3134'
     C                   EVAL      FldNamXAr(Idx) = 'DDTRIB'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      OKTRIB = 'N'
     C                   GOTO      EXTRIB
     C                   ENDIF

      ** Check further if it refers to a live Retail account
     C                   MOVE      WTRI0110      WNUM100          10 0
     C     WNUM100       CHAIN     ACNUMA                             40
     C                   IF        (*IN40 = *ON) OR (ABRECI <> 'D')
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdXAr(Idx) = 'FTM3135'
     C                   EVAL      FldNamXAr(Idx) = 'DDTRIB'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      OKTRIB = 'N'
     C                   GOTO      EXTRIB
     C                   ENDIF

      ** Retail account numbers are not supported
     C                   IF        PBMRANR <> 'Y'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdXAr(Idx) = 'FTM3136'
     C                   EVAL      FldNamXAr(Idx) = 'DDTRIB'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      OKTRIB = 'N'
     C                   GOTO      EXTRIB
     C                   ENDIF

     C                   EVAL      WTRICNUM = ABCNUM
     C                   EVAL      WTRICCY  = ABCCY
     C                   EVAL      WTRIACOD = ABACOD
     C                   EVAL      WTRIACSQ = ABACSQ
     C                   EVAL      WTRIBRCA = ABBRCA
     C                   EVAL      PAccTyp = ABATYP
     C                   EVAL      PAccSts = ABACST
     C                   EVAL      PDatAccOpn = ABDACO
     C                   EVAL      WTRITyp  = 'R'
     C                   GOTO      EXTRIB

     C                   ENDIF
     C                   ENDIF

      *
      ** Validate entry as a full account number
      ** 1-6 customer number, 10-13 account code, 14-15 account sequence no.
      *

     C*****DIGITS        CHECK     WTRI0106                               40                  CSD027
     C     DIGITS        CHECK     WTRI1015                               41
     C**********         IF        (*IN40 = *ON) OR (*IN41 = *ON)                             CSD027
     C                   IF        (*IN41 = *ON)                                              CSD027
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdXAr(Idx) = 'FTM3137'
     C                   EVAL      FldNamXAr(Idx) = 'DDTRIB'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      OKTRIB = 'N'
     C                   GOTO      EXTRIB
     C                   ENDIF

      ** Check if a valid GL account exists

     C                   MOVE      WTRI0106      KCNUM
     C                   MOVE      WTRI0709      KCYCD
     C                   MOVE      WTRI1013      KACOD
     C                   MOVE      WTRI1415      KACSQ
     C                   IF        PBJMBIN = 'Y'
     C                   MOVE      WTRI1618      KBRCA
     C                   ELSE
     C                   MOVE      PBJSBRC       KBRCA
     C                   ENDIF

     C     KACCNT        CHAIN     ACCNT                              40
     C                   IF        *IN40 = *ON
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdXAr(Idx) = 'FTM3138'
     C                   EVAL      FldNamXAr(Idx) = 'DDTRIB'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      OKTRIB = 'N'
     C                   GOTO      EXTRIB
     C                   ENDIF

     C                   EVAL      WTRICNUM = ACCNUM
     C                   EVAL      WTRICCY  = ACCCY
     C                   EVAL      WTRIACOD = ACACOD
     C                   EVAL      WTRIACSQ = ACACSQ
     C                   EVAL      WTRIBRCA = ACBRCA
     C                   EVAL      PAccTyp = ACATYP
     C                   EVAL      PAccSts = ACACST
     C                   EVAL      PDatAccOpn = ACDACO
     C                   EVAL      WTRITyp  = 'G'

     C     EXTRIB        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTRIB02 - Further validation of Third Reimbursement such    *
      *             as cross-validations                              *
      *                                                               *
      *****************************************************************
     C     SRTRIB02      BEGSR

     C                   IF        (WTRITyp = 'I')
     C                             OR (WTRITyp = 'F')
     C                             OR (WTRITyp = 'R')
     C                             OR (WTRITyp = 'G')

      ** If nostro, access account details
     C                   IF        (WTRITyp = 'F')
     C     KACCNT        CHAIN     ACCNT                              40
     C                   IF        (*IN40 = *OFF)
     C                   EVAL      WTRICNUM = ACCNUM
     C                   EVAL      WTRICCY  = ACCCY
     C                   EVAL      WTRIACOD = ACACOD
     C                   EVAL      WTRIACSQ = ACACSQ
     C                   EVAL      WTRIBRCA = ACBRCA
     C                   EVAL      PAccTyp = ACATYP
     C                   EVAL      PAccSts = ACACST
     C                   EVAL      PDatAccOpn = ACDACO
     C                   ENDIF
     C                   ENDIF

      ** Account currency must be equal to the Settle currency
     C                   IF        (OKSMCY = 'Y')
     C                             AND (WTRICcy <> DDSMCY)
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdXAr(Idx) = 'FTM3146'
     C                   EVAL      FldNamXAr(Idx) = 'DDTRIB'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      OKTRIB = 'N'
     C                   GOTO      EXTRIB02
     C                   ENDIF

     C                   ENDIF

     C                   IF        ErrorFound = 'N'
     C                   EVAL      I2INTRIT = WTRITyp
     C                   EVAL      I2INTRIB = DDTRIB
     C                   ENDIF

     C     EXTRIB02      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  *INZSR - Program Initialisation routine                      *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
      *
      ** O: Return Code
     C                   PARM                    ReturnCode
      *
      ***********
      ** INPUT **
      ***********
      *
      ** Incoming Payments Lvl 1 Scrn details
     C                   PARM                    NwIP1ScnFmt
      ** Incoming Payments Lvl 1 Scrn File 2 details
     C                   PARM                    NwIP1AScnFmt
      ** Sender's Correspondent Type from file
     C                   PARM                    PSndCorTyp        1
      ** Receiver's Correspondent Type
     C                   PARM                    PRcvCorTyp        1
      ** Receiver's Correspondent's account currency
     C                   PARM                    PRcvCorCcy        3
      ** Level Join indicator (SDFTFRPD)
     C                   PARM                    PBTLVJN           1
      ** Default branch code (SDBANKPD)
     C                   PARM                    PBJSBRC           3
      ** Multi-branching indicator (SDBANKPD)
     C                   PARM                    PBJMBIN           1
      ** Retail module (SDMMODPD)
     C                   PARM                    PBGRTBN           1
      ** Interest on Accrual (SDMMODPD)
     C                   PARM                    PBGIOAC           1
      ** Retail Acc numbers (SDRETLPD)
     C                   PARM                    PBMRANR           1
      ** FT Batch Authorization and Credit Advices
     C                   PARM                    CFT004            1
      *
      ************
      ** OUTPUT **
      ************
      *
      ** Incoming Payments Valid extension file
     C                   PARM                    NwIP2FilFmt
      ** Incoming Payments Lvl 1 Scrn Error indicators
     C                   PARM                    OKIPY1DS
      ** Third Reimbursement Inst. Account Type
     C                   PARM                    PAccTyp           1
      ** Third Reimbursement Inst. Account Status
     C                   PARM                    PAccSts           1
      ** Third Reimbursement Inst. Date Account Opened
     C                   PARM                    PDatAccOpn        5 0
      ** Third Reimbursement Inst. Full Account                                               250600
     C                   PARM                    PTRBDS                                       250600
      ** I/O: Third Reimbursement Institution (previous)
     C                   PARM                    PPrvTRI          34
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr

      ** ==============================================================
      ** Program, module and procedure names for database error proc'g.
      ** ==============================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area

     C/COPY ZACPYSRC,DBFIELDS

     C     *LIKE         DEFINE    ABCNUM        KCNUM
     C     *LIKE         DEFINE    ABCCY         KCYCD
     C     *LIKE         DEFINE    ABACOD        KACOD
     C     *LIKE         DEFINE    ABACSQ        KACSQ
     C     *LIKE         DEFINE    ABBRCA        KBRCA

     C     KACCNT        KLIST
     C                   KFLD                    KCNUM
     C                   KFLD                    KCYCD
     C                   KFLD                    KACOD
     C                   KFLD                    KACSQ
     C                   KFLD                    KBRCA

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
