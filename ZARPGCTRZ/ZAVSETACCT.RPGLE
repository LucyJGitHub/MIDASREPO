     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Validate interest settlement account')        *
      *****************************************************************
      *                                                               *
      *  Midas - Standard routines                                    *
      *                                                               *
      *  ZAVSETACCT - Validate interest settlement account            *
      *                                                               *
      *  Function:  This module checks whether the interest           *
      *             settlement account field is valid.                *
      *                                                               *
      *  Component of: ZA_ALL     - All ZA modules service program.   *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR863274           Date 11Nov11               *
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 01Aug97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR863274 - Valid GL account not accepted                     *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
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
 
 
      ** Map variable names to indicators to allow use of names instead
      ** of numbers; base the following data structure on a pointer to
      ** the indicator array.
     D Indicators      DS                  BASED(pIndicator)
     D  StrFound              99     99
 
      ** Set the indicator array pointer
     D pIndicator      S               *   INZ(%Addr(*In))
 
     D                 DS
      **  Data structure for Interest Settlement Account
     D**@@INSA**               1     15                                                       CGL029
     D  @@INSA                 1     21                                                       CGL029
     D  INOST                  1      2
     D**IZ013***               3     15                                                       CGL029
     D  IZ019                  3     21                                                       CGL029
     D  ICUST                  1      6
     D**IZ009***               7     15                                                       CGL029
     D  IZ015                  7     21                                                       CGL029
     D  IRETL                  1     10
     D**IACOD***               7     10                                                       CGL029
     D**IACSQ***              11     12                                                       CGL029
     D**IBRCA***              13     15                                                       CGL029
     D**IZ004***              11     15                                                       CGL029
     D**IINSN***               1     12                                                       CGL029
     D  IACOD                  7     16                                                       CGL029
     D  IACSQ                 17     18                                                       CGL029
     D  IBRCA                 19     21                                                       CGL029
     D  IZ011                 11     21                                                       CGL029
     D  IINSN                  1     18                                                       CGL029
 
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      * SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** EXTERNAL DS FOR ACCOUNT DETAILS
     D SDACNT        E DS                  EXTNAME(ACCNTAB)
 
      ** EXTERNAL DS FOR NOSTRO DETAILS
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** Decimal point
     D DecPoint        C                   CONST('.')
 
      ** Comma
     D Comma           C                   CONST(',')
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** ==========
      ** Parameters
 
      ** Message ID
     D MsgID1          S                   LIKE(#MsgID)
 
      ** Message data
     D MsgData1        S                   LIKE(#MsgData)
 
      ** Interest settlement account identifier
     D*DDINSA***       S             15A                                                      CGL029
     D DDINSA          S             21A                                                      CGL029
 
      ** Deal Currency
     D DDCCY           S              3A
 
      ** Interest Settlement Currency
     D DDISCY          S              3A
 
      ** Interest settlement method
     D DDIMET          S              2A
 
      ** Interest paid separately
     D DDIPDS          S              1A
 
      ** Settlement Method OK flag
     D SetMethOK       S              1A
 
      ** Switchable feature S01434 (Enhanced Rollovers) on
     D S01434          S              1A
 
      ** End of parameters
      ** =================
 
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
 
      ** Reset error found flag to prevent problems on later calls
     C                   RESET                   ErrorFound
 
     C*
     C** Move screen fields into field so can be checked
     C*
     C                   MOVEL     DDINSA        @@INSA
     C*
     C** 'Effective' Settlement Currency
     C*
     C     DDISCY        IFNE      *BLANK
     C                   MOVEL     DDISCY        EffSetCcy         3
     C                   ELSE
     C                   MOVEL     DDCCY         EffSetCcy
     C                   ENDIF
     C*
     C** Only validate if Enhanced Rollovers processing switched on
     C     S01434        IFEQ      'Y'
     C     DDIPDS        IFEQ      'Y'
      ** If no error in settlement method
     C                   IF        SetMethOK <> 'N'
 
     C** Some settlement methods do not require a settlement account
     C     DDIMET        IFEQ      *BLANKS
     C     DDIMET        OREQ      '00'
     C     DDIMET        OREQ      '04'
     C     DDIMET        OREQ      '06'
      *
     C     DDINSA        IFNE      *BLANKS
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0636'     MsgID1
     C                   END
      *
     C                   ELSE
     C*
     C** Settlement method 03 can not have a settlement account
     C*
     C     DDIMET        IFNE      '03'
     C     DDINSA        IFEQ      *BLANKS
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0637'     MsgID1
     C                   END
     C                   END
     C                   END
     C*
     C** Some settlement methods have to have a nostro number
     C*
     C     ErrorFound    IFEQ      'N'
     C     DDIMET        IFEQ      '01'
     C     DDIMET        OREQ      '02'
     C     DDIMET        OREQ      '07'
     C     DDIMET        OREQ      '08'
     C     DDIMET        OREQ      '12'
     C*****IZ013         IFNE      *BLANKS                                                    CGL029
     C     IZ019         IFNE      *BLANKS                                                    CGL029
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0638'     MsgID1
     C                   ELSE
     C*
     C** Validate nostro number
     C*
     C                   MOVEL     EffSetCcy     @KEYB
     C                   MOVEL     INOST         @KEYE
     C                   CALLB     'AONOSTR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      *BLANKS       @KEYA             6
     C                   PARM                    @KEYB             3
     C**********         PARM      *BLANKS       @KEYC             4                          CGL029
     C                   PARM      *BLANKS       @KEYC            10                          CGL029
     C                   PARM      *BLANKS       @KEYD             2
     C                   PARM                    @KEYE             2
     C                   PARM      *BLANKS       @KEYF             3
     C                   PARM      *BLANKS       @KEYG            10
     C                   PARM      *BLANKS       @KEYH             1
     C     SDNOST        PARM      SDNOST        DSFDY
     C*
     C     @RTCD         IFNE      *BLANKS
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0639'     MsgID1
     C                   END
     C                   END
     C                   END
     C*
     C** If a settlement account has been entered for settlement method
     C** 03, then it should be a deal number
     C*
     C     DDIMET        IFEQ      '03'
     C     DDINSA        ANDNE     *BLANKS
     C**********         MOVE      ICUST         WWCUST            6 0                        CSD027
     C                   MOVE      ICUST         WWCUST            6                          CSD027
     C                   MOVE      WWCUST        WACUST            6
     C     ICUST         IFNE      WACUST
     C*****IZ009         ORNE      *BLANKS                                                    CGL029
     C     IZ015         ORNE      *BLANKS                                                    CGL029
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0640'     MsgID1
     C                   END
     C                   END
     C*
     C** Need a valid account for settlement method 05
     C*
     C     DDIMET        IFEQ      '05'
     C**********         MOVE      IINSN         WWINSN           12 0                        CGL029
     C**********         MOVE      WWINSN        WAINSN           12                          CGL029
     C**********         MOVE      IINSN         WWINSN           18 0               CGL029 AR863274
     C**********         MOVE      WWINSN        WAINSN           18                 CGL029 AR863274
     C*****IINSN         IFNE      WAINSN                                                   AR863274
     C**********         EVAL      ErrorFound = 'Y'                                         AR863274
     C**********         MOVEL     'MMM0641'     MsgID1                                     AR863274
     C**********         ELSE                                                               AR863274
     C*
     C                   CALLB     'AOACCTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      *BLANKS       @RETL            10
     C                   PARM      ICUST         @CNUM             6
     C                   PARM      EffSetCcy     @CYCD             3
     C**********         PARM      IACOD         @ACCD             4                          CGL029
     C                   PARM      IACOD         @ACCD            10                          CGL029
     C                   PARM      IACSQ         @ACSN             2
     C                   PARM      IBRCA         @DSNB             3
     C     SDACNT        PARM      SDACNT        DSSDY
     C*
     C     @RTCD         IFNE      *BLANKS
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0642'     MsgID1
     C                   ELSE
     C     RECI          IFNE      'D'
 
      ** Concatenate customer, currency, a/c code & a/c sequence.
      ** The orogonal CAT opcodes lines have been replaced by the following
      ** EVAL statement because the CATs appear to work differently in
      ** ILE RPG from OPM.
 
     C                   EVAL      MsgData1 = @CNUM + '-' + @CYCD
     C                                        + '-' + @ACCD + '-' + @ACSN
 
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'BBM0130'     MsgID1
     C                   END
     C                   END
     C**********         END                                                                AR863274
     C                   END
     C                   END
     C*
     C** Need a valid retail account for settlement method 14
     C*
     C     DDIMET        IFEQ      '14'
     C*****IZ004         IFNE      *BLANKS                                                    CGL029
     C     IZ011         IFNE      *BLANKS                                                    CGL029
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0643'     MsgID1
     C                   ELSE
 
      ** The following condition was added because of an apparent difference
      ** in response between OPM and ILE code; the existing numeric check
      ** causes a decimal data error if the alpha field contains a decimal
      ** point or a comma.
 
      ** Note that indicator 99 is mapped to the variable StrFound.
      ** If both scans fail, then no decimal point or comma
      ** has been entered, so the existing validation can be carried out.
      ** If either scan is successful, the generation of the correct error
      ** message relies on the assumption that IRETL and WARETL will not
      ** be the same in these circumstances.
     C     DecPoint      SCAN      IRETL                                  99
     C                   IF        StrFound = False
     C     Comma         SCAN      IRETL                                  99
     C                   ENDIF
     C                   IF        StrFound = False
 
     C                   MOVE      IRETL         WWRETL           10 0
     C                   MOVE      WWRETL        WARETL           10
 
     C                   ENDIF
 
     C     IRETL         IFNE      WARETL
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0644'     MsgID1
     C                   ELSE
     C*
     C                   CALLB     'AOACCTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      IRETL         @RETL
     C                   PARM      *BLANKS       @CNUM
     C                   PARM      *BLANKS       @CYCD
     C                   PARM      *BLANKS       @ACCD
     C                   PARM      *BLANKS       @ACSN
     C                   PARM      *BLANKS       @DSNB
     C     SDACNT        PARM      SDACNT        DSSDY
     C*
     C     @RTCD         IFNE      *BLANKS
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0645'     MsgID1
     C                   ELSE
     C     RECI          IFNE      'D'
 
     C                   MOVEL(P)  @RETL         MsgData1
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'BBM0130'     MsgID1
     C                   ELSE
     C*
     C** Currency of the retail account should be the same as the
     C** effective settlement currency
     C*
     C     EffSetCcy     IFNE      CCY
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0646'     MsgID1
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
     C                   ELSE
     C*
     C** Should not be input if Interest Paid Separately is No
     C*
     C     DDINSA        IFNE      *BLANKS
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0651'     MsgID1
     C                   END
     C                   END
     C                   ELSE
     C                   MOVE      *BLANKS       @@INSA
     C                   END
 
      *
      ** Set return code
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
      ** Incoming return code (10A)
     C                   PARM                    RetCodeIn
      ** Message ID (10A)
     C                   PARM                    MsgID1
      ** Message data (45A)
     C                   PARM                    MsgData1
      ** Intereset settlement account identifier (15A, from transaction)
     C                   PARM                    DDINSA
      ** Switchable feature S01434 on (1A, from AOSARDPD)
     C                   PARM                    S01434
      ** Interest paid separately (1A, from transaction)
     C                   PARM                    DDIPDS
      ** Settlement method OK (1A, from caller)
     C                   PARM                    SetMethOK
      ** Interest settlement method (2A, from transaction)
     C                   PARM                    DDIMET
      ** Deal currency (3A, from transaction)
     C                   PARM                    DDCCY
      ** Interest settlement currency (3A, from transaction)
     C                   PARM                    DDISCY
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C     InzEnd        ENDSR                                                  *** InzEnd ***
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
