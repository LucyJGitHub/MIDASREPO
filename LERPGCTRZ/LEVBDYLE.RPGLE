     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2016')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Ccy for business day conv. validation')       *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LEVBDYLE - Midas LE Business Day Convention for Loans        *
      *             Validation                                        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2016            *
      *                                                               *
      *  Last Amend No. CLE141  *CREATE    Date 08Feb16               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE141 - Currency and Location Business Day Convention       *
      *           for LE Transactions                                 *
      *                                                               *
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
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
     D LoanBDC         DS            60
     D   CCY1                  1      3
     D   CCY2                  4      6
     D   CCY3                  7      9
     D   CCY4                 10     12
     D   CCY5                 13     15
     D   CCY6                 16     18
     D   CCY7                 19     21
     D   CCY8                 22     24
     D   CCY9                 25     27
     D   CCY0                 28     30
     D   LOC1                 31     33
     D   LOC2                 34     36
     D   LOC3                 37     39
     D   LOC4                 40     42
     D   LOC5                 43     45
     D   LOC6                 46     48
     D   LOC7                 49     51
     D   LOC8                 52     54
     D   LOC9                 55     57
     D   LOC0                 58     60
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     D RetCode         S              7
     D DayNo           S              5  0
     D Ind             S              1
     D ParmCCY         S              3
     D ParmLoc         S              3

      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

     C                   Exsr      HolidayVal

     C                   Eval      *INLR = *On
     C                   Return
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * HolidayVal - Validation for Currency & Location               *
      *              Business Day Convention                          *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     HolidayVal    Begsr

     C                   If        RetCode = *Blanks and CCY1 <> *Blanks
     C                   Eval      ParmCCY = CCY1
     C                   Eval      ParmLoc = LOC1
     C                   Exsr      CheckHol
     C                   If        Ind = 'H'
     C                   Eval      RetCode = 'HOLIDAY'
     C                   Endif
     C                   Endif
     C                   If        RetCode = *Blanks and CCY2 <> *Blanks
     C                   Eval      ParmCCY = CCY2
     C                   Eval      ParmLoc = LOC2
     C                   Exsr      CheckHol
     C                   If        Ind = 'H'
     C                   Eval      RetCode = 'HOLIDAY'
     C                   Endif
     C                   Endif
     C                   If        RetCode = *Blanks and CCY3 <> *Blanks
     C                   Eval      ParmCCY = CCY3
     C                   Eval      ParmLoc = LOC3
     C                   Exsr      CheckHol
     C                   If        Ind = 'H'
     C                   Eval      RetCode = 'HOLIDAY'
     C                   Endif
     C                   Endif
     C                   If        RetCode = *Blanks and CCY4 <> *Blanks
     C                   Eval      ParmCCY = CCY4
     C                   Eval      ParmLoc = LOC4
     C                   Exsr      CheckHol
     C                   If        Ind = 'H'
     C                   Eval      RetCode = 'HOLIDAY'
     C                   Endif
     C                   Endif
     C                   If        RetCode = *Blanks and CCY5 <> *Blanks
     C                   Eval      ParmCCY = CCY5
     C                   Eval      ParmLoc = LOC5
     C                   Exsr      CheckHol
     C                   If        Ind = 'H'
     C                   Eval      RetCode = 'HOLIDAY'
     C                   Endif
     C                   Endif
     C                   If        RetCode = *Blanks and CCY6 <> *Blanks
     C                   Eval      ParmCCY = CCY6
     C                   Eval      ParmLoc = LOC6
     C                   Exsr      CheckHol
     C                   If        Ind = 'H'
     C                   Eval      RetCode = 'HOLIDAY'
     C                   Endif
     C                   Endif
     C                   If        RetCode = *Blanks and CCY7 <> *Blanks
     C                   Eval      ParmCCY = CCY7
     C                   Eval      ParmLoc = LOC7
     C                   Exsr      CheckHol
     C                   If        Ind = 'H'
     C                   Eval      RetCode = 'HOLIDAY'
     C                   Endif
     C                   Endif
     C                   If        RetCode = *Blanks and CCY8 <> *Blanks
     C                   Eval      ParmCCY = CCY8
     C                   Eval      ParmLoc = LOC8
     C                   Exsr      CheckHol
     C                   If        Ind = 'H'
     C                   Eval      RetCode = 'HOLIDAY'
     C                   Endif
     C                   Endif
     C                   If        RetCode = *Blanks and CCY9 <> *Blanks
     C                   Eval      ParmCCY = CCY9
     C                   Eval      ParmLoc = LOC9
     C                   Exsr      CheckHol
     C                   If        Ind = 'H'
     C                   Eval      RetCode = 'HOLIDAY'
     C                   Endif
     C                   Endif
     C                   If        RetCode = *Blanks and CCY0 <> *Blanks
     C                   Eval      ParmCCY = CCY0
     C                   Eval      ParmLoc = LOC0
     C                   Exsr      CheckHol
     C                   If        Ind = 'H'
     C                   Eval      RetCode = 'HOLIDAY'
     C                   Endif
     C                   Endif

     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CheckHol - Check Holiday                                      *
      *                                                               *
      * Called by: HolidayVal                                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     CheckHol      Begsr

     C                   CALLB     'ZCHKH'
     C                   PARM                    DayNo
     C                   PARM                    ParmCCY
     C                   PARM                    ParmLoc
     C                   PARM      *BLANK        Ind

     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *INZSR        Begsr

     C     *Entry        Plist
     C                   Parm                    RetCode
     C                   Parm                    LoanBDC
     C                   Parm                    DayNo

     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
